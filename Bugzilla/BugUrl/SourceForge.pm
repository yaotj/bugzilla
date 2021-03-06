# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.
#
# This Source Code Form is "Incompatible With Secondary Licenses", as
# defined by the Mozilla Public License, v. 2.0.

package Bugzilla::BugUrl::SourceForge;

use 5.10.1;
use strict;
use warnings;

use parent qw(Bugzilla::BugUrl);

###############################
####        Methods        ####
###############################

sub should_handle {
    my ($class, $uri) = @_;

    # SourceForge tracker URLs have only one form:
    #  http://sourceforge.net/tracker/?func=detail&aid=111&group_id=111&atid=111
    # SourceForge Allura ticket URLs have several forms:
    #  http://sourceforge.net/p/project/bugs/12345/
    #  http://sourceforge.net/p/project/feature-requests/12345/
    #  http://sourceforge.net/p/project/patches/12345/
    #  http://sourceforge.net/p/project/support-requests/12345/
    return (lc($uri->authority) eq 'sourceforge.net'
            and (($uri->path eq '/tracker/'
                  and $uri->query_param('func') eq 'detail'
                  and $uri->query_param('aid')
                  and $uri->query_param('group_id')
                  and $uri->query_param('atid'))
                or $uri->path =~ m!^/p/[^/]+/(?:bugs|feature-requests|patches|support-requests)/\d+/?$!)) ? 1 : 0;
}

sub _check_value {
    my $class = shift;

    my $uri = $class->SUPER::_check_value(@_);

    # Remove any # part if there is one.
    $uri->fragment(undef);

    # Make sure the trailing slash is present
    my $path = $uri->path;
    $path =~ s!/*$!/!;
    $uri->path($path);

    return $uri;
}

1;

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0624598540
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245753AbiHROF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245133AbiHROF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:05:26 -0400
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A6236F542;
        Thu, 18 Aug 2022 07:05:23 -0700 (PDT)
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id BBD2A77A; Thu, 18 Aug 2022 09:05:21 -0500 (CDT)
Date:   Thu, 18 Aug 2022 09:05:21 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Paul Moore <paul@paul-moore.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com,
        stephen.smalley.work@gmail.com, eparis@parisplace.org,
        shuah@kernel.org, brauner@kernel.org, casey@schaufler-ca.com,
        bpf@vger.kernel.org, linux-security-module@vger.kernel.org,
        selinux@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        kernel-team@cloudflare.com, cgzones@googlemail.com,
        karl@bigbadwolfsecurity.com, tixxdz@gmail.com
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
Message-ID: <20220818140521.GA1000@mail.hallyn.com>
References: <20220815162028.926858-1-fred@cloudflare.com>
 <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 17, 2022 at 04:24:28PM -0500, Eric W. Biederman wrote:
> Paul Moore <paul@paul-moore.com> writes:
> 
> > On Wed, Aug 17, 2022 at 4:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> Paul Moore <paul@paul-moore.com> writes:
> >> > On Wed, Aug 17, 2022 at 3:58 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> >> >> Paul Moore <paul@paul-moore.com> writes:
> >> >>
> >> >> > At the end of the v4 patchset I suggested merging this into lsm/next
> >> >> > so it could get a full -rc cycle in linux-next, assuming no issues
> >> >> > were uncovered during testing
> >> >>
> >> >> What in the world can be uncovered in linux-next for code that has no in
> >> >> tree users.
> >> >
> >> > The patchset provides both BPF LSM and SELinux implementations of the
> >> > hooks along with a BPF LSM test under tools/testing/selftests/bpf/.
> >> > If no one beats me to it, I plan to work on adding a test to the
> >> > selinux-testsuite as soon as I'm done dealing with other urgent
> >> > LSM/SELinux issues (io_uring CMD passthrough, SCTP problems, etc.); I
> >> > run these tests multiple times a week (multiple times a day sometimes)
> >> > against the -rcX kernels with the lsm/next, selinux/next, and
> >> > audit/next branches applied on top.  I know others do similar things.
> >>
> >> A layer of hooks that leaves all of the logic to userspace is not an
> >> in-tree user for purposes of understanding the logic of the code.
> >
> > The BPF LSM selftests which are part of this patchset live in-tree.
> > The SELinux hook implementation is completely in-tree with the
> > subject/verb/object relationship clearly described by the code itself.
> > After all, the selinux_userns_create() function consists of only two
> > lines, one of which is an assignment.  Yes, it is true that the
> > SELinux policy lives outside the kernel, but that is because there is
> > no singular SELinux policy for everyone.  From a practical
> > perspective, the SELinux policy is really just a configuration file
> > used to setup the kernel at runtime; it is not significantly different
> > than an iptables script, /etc/sysctl.conf, or any of the other myriad
> > of configuration files used to configure the kernel during boot.
> 
> I object to adding the new system configuration knob.

I do strongly sympathize with Eric's points.  It will be very easy, once
user namespace creation has been further restricted in some distros, to
say "well see this stuff is silly" and go back to simply requiring root
to create all containers and namespaces, which is generally quite a bit
easier anywway.  And then, of course, give everyone root so they can
start containers.

As Eric said,

 | Further adding a random failure mode to user namespace creation if it is
 | used at all will just encourage userspace to use a setuid application to
 | perform the namespace creation instead.  Creating a less secure system
 | overall.

However, I'm also looking at e.g. CVE-2022-2588 and CVE-2022-2586, and
yes there are two issues which do require discussion (three if you
count reportability, which is mainly a tool in guarding against the others).

The first is, indeed, configuration knobs.  There are tools, including
chrome, which use user namespaces to make things better.  The hope is
that more and more tools will do so.

The second is damage control.  When an 0day has been announced, things
change.  You can say "well the bug was there all along", but it is
different when every lazy ne'erdowell can pick an exploit off a mailing
list and use it against a product for which spinning a new version with
a new kernel and getting customers to update is probably a months-long
endeavor.  Some of these products do in fact require namespaces (user
and otherwise) as part of their function.  And - to my chagrin - I suspect
most of them create usernamespace as the root user, before possibly processing
untrusted user input, so unprivileged_userns_clone isn't a good fit.

SELinux (and LSMs in generaly) do in fact seem like a useful place to
add some configuration, because they tend to assign different domains
to tasks with different purposes and trust levels.  But another such
place is the init system / service manager.  And in most cases these
days, this will use cgroups to collect tasks of certain types.  So I
wonder (this is ALMOST ENTIRELY thinking out loud, not thought through
sufficiently) whether we should be setting a cgroup.nslock or
somesuch.

Of course, kernel livepatch is another potentially useful mitigation.
Currently that's not possible for everyone.

Maybe there is a more fundamental way we can approach this.  Part of me
still likes the idea of splitting the id mapping and capability-in-userns
parts, but that's not sufficient.  Maybe looking over all the relevant
CVEs would give a better hint.

Eric, you said

 | If the concern is to reduce the attack surface everything this
 | proposed hook can do is already possible with the security_capable
 | security hook.

I suppose I could envision an LSM which gets activated when we find
out there was a net-ns-exacerbated 0-day, which refuses CAP_NET_ADMIN
for a task not in init_user_ns?  Ideally it would be more flexible
than that.

> idea.  What is userspace going to do with this new feature that makes it
> worth maintaining in the kernel?
> 
> That is always the conversation we have when adding new features, and
> that is exactly the conversation that has not happened here.

Eric and Paul, I wonder, will you - or some people you'd like to represent
you - be at plumbers in September?  Should there be a BOF session there?  (I
won't be there, but could join over video)  I think a brainstorming session 
for solutions to the above problems would be good.

> Adding a layer of indirection should not exempt a new feature from
> needing to justify itself.
> 
> Eric

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284B6599DB7
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 16:48:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349373AbiHSOpn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 10:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349286AbiHSOpl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 10:45:41 -0400
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EDCBCD539;
        Fri, 19 Aug 2022 07:45:39 -0700 (PDT)
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id 55E9A606; Fri, 19 Aug 2022 09:45:37 -0500 (CDT)
Date:   Fri, 19 Aug 2022 09:45:37 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, stephen.smalley.work@gmail.com,
        eparis@parisplace.org, shuah@kernel.org, brauner@kernel.org,
        casey@schaufler-ca.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@cloudflare.com,
        cgzones@googlemail.com, karl@bigbadwolfsecurity.com,
        tixxdz@gmail.com
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
Message-ID: <20220819144537.GA16552@mail.hallyn.com>
References: <CAHC9VhTuxxRfJg=Ax5z87Jz6tq1oVRcppB444dHM2gP-FZrkTQ@mail.gmail.com>
 <8735dux60p.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhSHJNLS-KJ-Rz1R12PQbqACSksLYLbymF78d5hMkSGc-g@mail.gmail.com>
 <871qte8wy3.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhSU_sqMQwdoh0nAFdURqs_cVFbva8=otjcZUo8s+xyC9A@mail.gmail.com>
 <8735du7fnp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhQuRNxzgVeNhDy=p5+RHz5+bTH6zFdU=UvvEhyH1e962A@mail.gmail.com>
 <87tu6a4l83.fsf@email.froward.int.ebiederm.org>
 <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 18, 2022 at 11:11:06AM -0400, Paul Moore wrote:
> On Thu, Aug 18, 2022 at 10:05 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> > On Wed, Aug 17, 2022 at 04:24:28PM -0500, Eric W. Biederman wrote:
> > > Paul Moore <paul@paul-moore.com> writes:
> > > > On Wed, Aug 17, 2022 at 4:56 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > >> Paul Moore <paul@paul-moore.com> writes:
> > > >> > On Wed, Aug 17, 2022 at 3:58 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > >> >> Paul Moore <paul@paul-moore.com> writes:
> > > >> >>
> > > >> >> > At the end of the v4 patchset I suggested merging this into lsm/next
> > > >> >> > so it could get a full -rc cycle in linux-next, assuming no issues
> > > >> >> > were uncovered during testing
> > > >> >>
> > > >> >> What in the world can be uncovered in linux-next for code that has no in
> > > >> >> tree users.
> > > >> >
> > > >> > The patchset provides both BPF LSM and SELinux implementations of the
> > > >> > hooks along with a BPF LSM test under tools/testing/selftests/bpf/.
> > > >> > If no one beats me to it, I plan to work on adding a test to the
> > > >> > selinux-testsuite as soon as I'm done dealing with other urgent
> > > >> > LSM/SELinux issues (io_uring CMD passthrough, SCTP problems, etc.); I
> > > >> > run these tests multiple times a week (multiple times a day sometimes)
> > > >> > against the -rcX kernels with the lsm/next, selinux/next, and
> > > >> > audit/next branches applied on top.  I know others do similar things.
> > > >>
> > > >> A layer of hooks that leaves all of the logic to userspace is not an
> > > >> in-tree user for purposes of understanding the logic of the code.
> > > >
> > > > The BPF LSM selftests which are part of this patchset live in-tree.
> > > > The SELinux hook implementation is completely in-tree with the
> > > > subject/verb/object relationship clearly described by the code itself.
> > > > After all, the selinux_userns_create() function consists of only two
> > > > lines, one of which is an assignment.  Yes, it is true that the
> > > > SELinux policy lives outside the kernel, but that is because there is
> > > > no singular SELinux policy for everyone.  From a practical
> > > > perspective, the SELinux policy is really just a configuration file
> > > > used to setup the kernel at runtime; it is not significantly different
> > > > than an iptables script, /etc/sysctl.conf, or any of the other myriad
> > > > of configuration files used to configure the kernel during boot.
> > >
> > > I object to adding the new system configuration knob.
> >
> > I do strongly sympathize with Eric's points.  It will be very easy, once
> > user namespace creation has been further restricted in some distros, to
> > say "well see this stuff is silly" and go back to simply requiring root
> > to create all containers and namespaces, which is generally quite a bit
> > easier anywway.  And then, of course, give everyone root so they can
> > start containers.
> 
> That's assuming a lot.  Many years have passed since namespaces were
> first introduced, and awareness of good security practices has
> improved, perhaps not as much as any of us would like, but to say that
> distros, system builders, and even users are the same as they were so
> many years ago is a bit of a stretch in my opinion.

Maybe.  But I do get a bit worried based on some of what I've been
reading in mailing lists lately.  Kernel dev definitely moves like
fashion - remember when every api should have its own filesystem?
That was not a different group of people.

> However, even ignoring that for a moment, do we really want to go to a
> place where we dictate how users compose and secure their systems?
> Linux "took over the world" because it offered a level of flexibility
> that wasn't really possible before, and it has flourished because it
> has kept that mentality.  The Linux Kernel can be shoehorned onto most
> hardware that you can get your hands on these days, with driver
> support for most anything you can think to plug into the system.  Do
> you want a single-user environment with no per-user separation?  We
> can do that.  Do you want a traditional DAC based system that leans
> heavy on ACLs and capabilities?  We can do that.  Do you want a
> container host that allows you to carve up the system with a high
> degree of granularity thanks to the different namespaces?  We can do
> that.  How about a system that leverages the LSM to enforce a least
> privilege ideal, even on the most privileged root user?  We can do
> that too.  This patchset is about giving distro, system builders, and
> users another choice in how they build their system.  We've seen both

Oh, you misunderstand.  Whereas I do feel there are important concerns in
Eric's objections, and whereas I don't feel this set sufficiently
addresses the problems that I see and outlined above, I do see value in
this set, and was not aiming to deter it.  We need better ways to
mitigate a certain clas sof 0-days without completely disallowing use of
user namespaces, and this may help.

> in this patchset and in previously failed attempts that there is a
> definite want from a user perspective for functionality such as this,
> and I think it's time we deliver it in the upstream kernel so they
> don't have to keep patching their own systems with out-of-tree
> patches.
> 
> > Eric and Paul, I wonder, will you - or some people you'd like to represent
> > you - be at plumbers in September?  Should there be a BOF session there?  (I
> > won't be there, but could join over video)  I think a brainstorming session
> > for solutions to the above problems would be good.
> 
> Regardless of if Eric or I will be at LPC, it is doubtful that all of
> the people who have participated in this discussion will be able to
> attend, and I think it's important that the users who are asking for
> this patchset have a chance to be heard in each forum where this is
> discussed.  While conferences are definitely nice - I definitely
> missed them over the past couple of years - we can't use them as a
> crutch to help us reach a conclusion on this issue; we've debated much

No I wasn't thinking we would use LPC to decide on this patchset.  As far
as I can see, the patchset is merged.  I am hoping we can come up with
"something better" to address people's needs, make everyone happy, and
bring forth world peace.  Which would stack just fine with what's here
for defense in depth.

You may well not be interested in further work, and that's fine.  I need
to set aside a few days to think on this.

> more difficult things over the mailing lists, I see no reason why this
> would be any different.
> 
> -- 
> paul-moore.com

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC5815ABCB1
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 05:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbiICD6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 23:58:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231379AbiICD6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 23:58:34 -0400
Received: from mail.hallyn.com (mail.hallyn.com [178.63.66.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 416923ECDF;
        Fri,  2 Sep 2022 20:58:31 -0700 (PDT)
Received: by mail.hallyn.com (Postfix, from userid 1001)
        id E6017D39; Fri,  2 Sep 2022 22:58:28 -0500 (CDT)
Date:   Fri, 2 Sep 2022 22:58:28 -0500
From:   "Serge E. Hallyn" <serge@hallyn.com>
To:     Christian Brauner <brauner@kernel.org>
Cc:     "Serge E. Hallyn" <serge@hallyn.com>,
        Song Liu <songliubraving@fb.com>,
        Paul Moore <paul@paul-moore.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederick Lawler <fred@cloudflare.com>,
        KP Singh <kpsingh@kernel.org>,
        "revest@chromium.org" <revest@chromium.org>,
        "jackmanb@chromium.org" <jackmanb@chromium.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        James Morris <jmorris@namei.org>,
        "stephen.smalley.work@gmail.com" <stephen.smalley.work@gmail.com>,
        "eparis@parisplace.org" <eparis@parisplace.org>,
        Shuah Khan <shuah@kernel.org>,
        Casey Schaufler <casey@schaufler-ca.com>,
        bpf <bpf@vger.kernel.org>,
        LSM List <linux-security-module@vger.kernel.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        "cgzones@googlemail.com" <cgzones@googlemail.com>,
        "karl@bigbadwolfsecurity.com" <karl@bigbadwolfsecurity.com>,
        "tixxdz@gmail.com" <tixxdz@gmail.com>
Subject: Re: [PATCH v5 0/4] Introduce security_create_user_ns()
Message-ID: <20220903035828.GA23652@mail.hallyn.com>
References: <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
 <20220819144537.GA16552@mail.hallyn.com>
 <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
 <875yigp4tp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
 <0D14C118-E644-4D7B-84C0-CA7752DC0605@fb.com>
 <20220826152445.GB12466@mail.hallyn.com>
 <25C89E75-A900-42C7-A8E4-2800AA2E3387@fb.com>
 <20220826210039.GA15952@mail.hallyn.com>
 <20220829153304.nvhakybpkj7erpuc@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220829153304.nvhakybpkj7erpuc@wittgenstein>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 05:33:04PM +0200, Christian Brauner wrote:
> On Fri, Aug 26, 2022 at 04:00:39PM -0500, Serge Hallyn wrote:
> > On Fri, Aug 26, 2022 at 05:00:51PM +0000, Song Liu wrote:
> > > 
> > > 
> > > > On Aug 26, 2022, at 8:24 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > > > 
> > > > On Thu, Aug 25, 2022 at 09:58:46PM +0000, Song Liu wrote:
> > > >> 
> > > >> 
> > > >>> On Aug 25, 2022, at 12:19 PM, Paul Moore <paul@paul-moore.com> wrote:
> > > >>> 
> > > >>> On Thu, Aug 25, 2022 at 2:15 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > > >>>> Paul Moore <paul@paul-moore.com> writes:
> > > >>>>> On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> > > >>>>>> I am hoping we can come up with
> > > >>>>>> "something better" to address people's needs, make everyone happy, and
> > > >>>>>> bring forth world peace.  Which would stack just fine with what's here
> > > >>>>>> for defense in depth.
> > > >>>>>> 
> > > >>>>>> You may well not be interested in further work, and that's fine.  I need
> > > >>>>>> to set aside a few days to think on this.
> > > >>>>> 
> > > >>>>> I'm happy to continue the discussion as long as it's constructive; I
> > > >>>>> think we all are.  My gut feeling is that Frederick's approach falls
> > > >>>>> closest to the sweet spot of "workable without being overly offensive"
> > > >>>>> (*cough*), but if you've got an additional approach in mind, or an
> > > >>>>> alternative approach that solves the same use case problems, I think
> > > >>>>> we'd all love to hear about it.
> > > >>>> 
> > > >>>> I would love to actually hear the problems people are trying to solve so
> > > >>>> that we can have a sensible conversation about the trade offs.
> > > >>> 
> > > >>> Here are several taken from the previous threads, it's surely not a
> > > >>> complete list, but it should give you a good idea:
> > > >>> 
> > > >>> https://lore.kernel.org/linux-security-module/CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com/
> > > >>> 
> > > >>>> As best I can tell without more information people want to use
> > > >>>> the creation of a user namespace as a signal that the code is
> > > >>>> attempting an exploit.
> > > >>> 
> > > >>> Some use cases are like that, there are several other use cases that
> > > >>> go beyond this; see all of our previous discussions on this
> > > >>> topic/patchset.  As has been mentioned before, there are use cases
> > > >>> that require improved observability, access control, or both.
> > > >>> 
> > > >>>> As such let me propose instead of returning an error code which will let
> > > >>>> the exploit continue, have the security hook return a bool.  With true
> > > >>>> meaning the code can continue and on false it will trigger using SIGSYS
> > > >>>> to terminate the program like seccomp does.
> > > >>> 
> > > >>> Having the kernel forcibly exit the process isn't something that most
> > > >>> LSMs would likely want.  I suppose we could modify the hook/caller so
> > > >>> that *if* an LSM wanted to return SIGSYS the system would kill the
> > > >>> process, but I would want that to be something in addition to
> > > >>> returning an error code like LSMs normally do (e.g. EACCES).
> > > >> 
> > > >> I am new to user_namespace and security work, so please pardon me if
> > > >> anything below is very wrong. 
> > > >> 
> > > >> IIUC, user_namespace is a tool that enables trusted userspace code to 
> > > >> control the behavior of untrusted (or less trusted) userspace code. 
> > > > 
> > > > No.  user namespaces are not a way for more trusted code to control the
> > > > behavior of less trusted code.
> > > 
> > > Hmm.. In this case, I think I really need to learn more. 
> > > 
> > > Thanks for pointing out my misunderstanding.
> > 
> > (I thought maybe Eric would chime in with a better explanation, but I'll
> > fill it in for now :)
> > 
> > One of the main goals of user namespaces is to allow unprivileged users
> > to do things like chroot and mount, which are very useful development
> > tools, without needing admin privileges.  So it's almost the opposite
> > of what you said: rather than to enable trusted userspace code to control
> > the behavior of less trusted code, it's to allow less privileged code to
> > do things which do not affect other users, without having to assume *more*
> > privilege.
> > 
> > To be precise, the goals were:
> > 
> > 1. uid mapping - allow two users to both "use uid 500" without conflicting
> > 2. provide (unprivileged) users privilege over their own resources
> > 3. absolutely no extra privilege over other resources
> > 4. be able to nest
> > 
> > While (3) was technically achieved, the problem we have is that
> > (2) provides unprivileged users the ability to exercise kernel code
> > which they previously could not.
> 
> The consequence of the refusal to give users any way to control whether
> or not user namespaces are available to unprivileged users is that a
> non-significant number of distros still carry the same patch for about
> 10 years now that adds an unprivileged_userns_clone sysctl to restrict
> them to privileged users. That includes current Debian and Archlinux btw.

Hi Christian,

I'm wondering about your placement of this argument in the thread, and whether
you interpreted what I said above as an argument against this patchset, or
whether you're just expanding on what I said.

> The LSM hook is a simple way to allow administrators to control this and

(I think the "control" here is suboptimal, but I've not seen - nor
conceived of - anything better as of yet)

> will allow user namespaces to be enabled in scenarios where they
> would otherwise not be accepted precisely because they are available to
> unprivileged users.
> 
> I fully understand the motivation and usefulness in unprivileged
> scenarios but it's an unfounded fear that giving users the ability to
> control user namespace creation via an LSM hook will cause proliferation
> of setuid binaries (Ignoring for a moment that any fully unprivileged
> container with useful idmappings has to rely on the new{g,u}idmap setuid
> binaries to setup useful mappings anyway.) or decrease system safety let
> alone cause regressions (Which I don't think is an applicable term here
> at all.). Distros that have unprivileged user namespaces turned on by
> default are extremely unlikely to switch to an LSM profile that turns
> them off and distros that already turn them off will continue to turn
> them off whether or not that LSM hook is available.
> 
> It's much more likely that workloads that want to minimize their attack
> surface while still getting the benefits of user namespaces for e.g.
> service isolation will feel comfortable enabling them for the first time
> since they can control them via an LSM profile.

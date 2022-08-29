Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D59C65A5041
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 17:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbiH2PdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 11:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbiH2PdT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 11:33:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B8987E001;
        Mon, 29 Aug 2022 08:33:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D287B810E2;
        Mon, 29 Aug 2022 15:33:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D37C433D7;
        Mon, 29 Aug 2022 15:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661787194;
        bh=jzNzgbkp8S7F5ShJoRQg4sI4IZkepolVYyaXxRiHuaU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ByRHXZZIPHw1GAtaglSfS40oiwbi3+y+Qo+KygaRYVKAAWamjVRSzpM0+P7rovGiV
         W2dKwScf6KwNN7nKXRugLMCFD5/wZL8+FZHCOiM4wyFgkUlrxTr9XSWexM9LZ9nnTj
         35ff9NAvlOEdAT6GycEsYNY9RV4kdgFVbkP9Ll6z1gPX1koy3JruNQFOWIU8LB8eo7
         2FFQx9wTBfh2wWb4S/d8koZZyazHDPw2TRG36g+2Ckd5XNdf8mf0upqDTETfjFSWmc
         2JUat1koBEYEk4LmBaJKAlI6K7KKDyGl92OI3/lwI8g4ZPPkwd9Y4zsnK3oDjTJF2u
         gEhyxb0iFW/Bw==
Date:   Mon, 29 Aug 2022 17:33:04 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     "Serge E. Hallyn" <serge@hallyn.com>
Cc:     Song Liu <songliubraving@fb.com>, Paul Moore <paul@paul-moore.com>,
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
Message-ID: <20220829153304.nvhakybpkj7erpuc@wittgenstein>
References: <20220818140521.GA1000@mail.hallyn.com>
 <CAHC9VhRqBxtV04ARQFPWpMf1aFZo0HP_HiJ+8VpXAT-zXF6UXw@mail.gmail.com>
 <20220819144537.GA16552@mail.hallyn.com>
 <CAHC9VhSZ0aaa3k3704j8_9DJvSNRy-0jfXpy1ncs2Jmo8H0a7g@mail.gmail.com>
 <875yigp4tp.fsf@email.froward.int.ebiederm.org>
 <CAHC9VhTN09ZabnQnsmbSjKgb8spx7_hkh4Z+mq5ArQmfPcVqAg@mail.gmail.com>
 <0D14C118-E644-4D7B-84C0-CA7752DC0605@fb.com>
 <20220826152445.GB12466@mail.hallyn.com>
 <25C89E75-A900-42C7-A8E4-2800AA2E3387@fb.com>
 <20220826210039.GA15952@mail.hallyn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220826210039.GA15952@mail.hallyn.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 26, 2022 at 04:00:39PM -0500, Serge Hallyn wrote:
> On Fri, Aug 26, 2022 at 05:00:51PM +0000, Song Liu wrote:
> > 
> > 
> > > On Aug 26, 2022, at 8:24 AM, Serge E. Hallyn <serge@hallyn.com> wrote:
> > > 
> > > On Thu, Aug 25, 2022 at 09:58:46PM +0000, Song Liu wrote:
> > >> 
> > >> 
> > >>> On Aug 25, 2022, at 12:19 PM, Paul Moore <paul@paul-moore.com> wrote:
> > >>> 
> > >>> On Thu, Aug 25, 2022 at 2:15 PM Eric W. Biederman <ebiederm@xmission.com> wrote:
> > >>>> Paul Moore <paul@paul-moore.com> writes:
> > >>>>> On Fri, Aug 19, 2022 at 10:45 AM Serge E. Hallyn <serge@hallyn.com> wrote:
> > >>>>>> I am hoping we can come up with
> > >>>>>> "something better" to address people's needs, make everyone happy, and
> > >>>>>> bring forth world peace.  Which would stack just fine with what's here
> > >>>>>> for defense in depth.
> > >>>>>> 
> > >>>>>> You may well not be interested in further work, and that's fine.  I need
> > >>>>>> to set aside a few days to think on this.
> > >>>>> 
> > >>>>> I'm happy to continue the discussion as long as it's constructive; I
> > >>>>> think we all are.  My gut feeling is that Frederick's approach falls
> > >>>>> closest to the sweet spot of "workable without being overly offensive"
> > >>>>> (*cough*), but if you've got an additional approach in mind, or an
> > >>>>> alternative approach that solves the same use case problems, I think
> > >>>>> we'd all love to hear about it.
> > >>>> 
> > >>>> I would love to actually hear the problems people are trying to solve so
> > >>>> that we can have a sensible conversation about the trade offs.
> > >>> 
> > >>> Here are several taken from the previous threads, it's surely not a
> > >>> complete list, but it should give you a good idea:
> > >>> 
> > >>> https://lore.kernel.org/linux-security-module/CAHC9VhQnPAsmjmKo-e84XDJ1wmaOFkTKPjjztsOa9Yrq+AeAQA@mail.gmail.com/
> > >>> 
> > >>>> As best I can tell without more information people want to use
> > >>>> the creation of a user namespace as a signal that the code is
> > >>>> attempting an exploit.
> > >>> 
> > >>> Some use cases are like that, there are several other use cases that
> > >>> go beyond this; see all of our previous discussions on this
> > >>> topic/patchset.  As has been mentioned before, there are use cases
> > >>> that require improved observability, access control, or both.
> > >>> 
> > >>>> As such let me propose instead of returning an error code which will let
> > >>>> the exploit continue, have the security hook return a bool.  With true
> > >>>> meaning the code can continue and on false it will trigger using SIGSYS
> > >>>> to terminate the program like seccomp does.
> > >>> 
> > >>> Having the kernel forcibly exit the process isn't something that most
> > >>> LSMs would likely want.  I suppose we could modify the hook/caller so
> > >>> that *if* an LSM wanted to return SIGSYS the system would kill the
> > >>> process, but I would want that to be something in addition to
> > >>> returning an error code like LSMs normally do (e.g. EACCES).
> > >> 
> > >> I am new to user_namespace and security work, so please pardon me if
> > >> anything below is very wrong. 
> > >> 
> > >> IIUC, user_namespace is a tool that enables trusted userspace code to 
> > >> control the behavior of untrusted (or less trusted) userspace code. 
> > > 
> > > No.  user namespaces are not a way for more trusted code to control the
> > > behavior of less trusted code.
> > 
> > Hmm.. In this case, I think I really need to learn more. 
> > 
> > Thanks for pointing out my misunderstanding.
> 
> (I thought maybe Eric would chime in with a better explanation, but I'll
> fill it in for now :)
> 
> One of the main goals of user namespaces is to allow unprivileged users
> to do things like chroot and mount, which are very useful development
> tools, without needing admin privileges.  So it's almost the opposite
> of what you said: rather than to enable trusted userspace code to control
> the behavior of less trusted code, it's to allow less privileged code to
> do things which do not affect other users, without having to assume *more*
> privilege.
> 
> To be precise, the goals were:
> 
> 1. uid mapping - allow two users to both "use uid 500" without conflicting
> 2. provide (unprivileged) users privilege over their own resources
> 3. absolutely no extra privilege over other resources
> 4. be able to nest
> 
> While (3) was technically achieved, the problem we have is that
> (2) provides unprivileged users the ability to exercise kernel code
> which they previously could not.

The consequence of the refusal to give users any way to control whether
or not user namespaces are available to unprivileged users is that a
non-significant number of distros still carry the same patch for about
10 years now that adds an unprivileged_userns_clone sysctl to restrict
them to privileged users. That includes current Debian and Archlinux btw.

The LSM hook is a simple way to allow administrators to control this and
will allow user namespaces to be enabled in scenarios where they
would otherwise not be accepted precisely because they are available to
unprivileged users.

I fully understand the motivation and usefulness in unprivileged
scenarios but it's an unfounded fear that giving users the ability to
control user namespace creation via an LSM hook will cause proliferation
of setuid binaries (Ignoring for a moment that any fully unprivileged
container with useful idmappings has to rely on the new{g,u}idmap setuid
binaries to setup useful mappings anyway.) or decrease system safety let
alone cause regressions (Which I don't think is an applicable term here
at all.). Distros that have unprivileged user namespaces turned on by
default are extremely unlikely to switch to an LSM profile that turns
them off and distros that already turn them off will continue to turn
them off whether or not that LSM hook is available.

It's much more likely that workloads that want to minimize their attack
surface while still getting the benefits of user namespaces for e.g.
service isolation will feel comfortable enabling them for the first time
since they can control them via an LSM profile.

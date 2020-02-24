Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8194216B2E6
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 22:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgBXVlY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 16:41:24 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:46857 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728313AbgBXVlX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 16:41:23 -0500
Received: by mail-pl1-f194.google.com with SMTP id y8so4568497pll.13
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 13:41:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=g1FhGTDL8AVFZXNru5fbzASJM+cg6EOxs9nHV0lzNKQ=;
        b=IEVKAGgaxj82dG4Cpwq3+YmGUyR0pewWh2bRscDfWtiNIE7WbQOuRUBd6DiJTm8Gqt
         AzHr4ROxwZicAqQo8SwglMxcYxv4Oawq2nlM09RceB0Dg9sqEz1GGQ4TXBq4Ac+RJGJz
         wHVIK+pZeZugJSrrwRLJ+/az21NXjZ37wblLA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=g1FhGTDL8AVFZXNru5fbzASJM+cg6EOxs9nHV0lzNKQ=;
        b=IdyGFUFHCAwQRWMjMe0wcAcvfW9MDzkIwJPZ0zSIKF13gqp/SigQDwkgrA67Z4uRM4
         n73yYwaM3KNJc3ZizoDEhV9mYIREclrXl4tnKWlbda9b6pr7WkIpa79IKZjjSU0fPgsz
         TbutysyovmYJw4se9AaVZZgpdSqVNiPzFDjC35lo5cWkg5j7WAnvI/LZJTEtb4G8++c3
         2EkRuUXHPogqAmucaN4bWE9FtAL7Jd2j7MTqS39B954PxAFB2KwSAMaO0m+mWp2AhKZm
         gIHq/ooZaQ4AD8Az/66OYUA8Hm+o5I8tQ5eT5nOoRKhRty5/AWYsAy5bYeHjXC42lTrJ
         /UsA==
X-Gm-Message-State: APjAAAWBNFiBDF2nyMy8o9/CDfQJdSgKmRzi5ZsQWiD1NzeD/8OTEqTk
        y1Ib5UZGMC84qKFTpbDiqsOGdw==
X-Google-Smtp-Source: APXvYqzwjEv2qe8tukvEE57R7Vz3qP4mX4z2ov8bcn7+2KXjnQONWS2ZnRfjQX7ObF+9HfWrLw8bAw==
X-Received: by 2002:a17:90a:d80b:: with SMTP id a11mr1280200pjv.142.1582580482136;
        Mon, 24 Feb 2020 13:41:22 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id w2sm13565100pfw.43.2020.02.24.13.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 13:41:21 -0800 (PST)
Date:   Mon, 24 Feb 2020 13:41:19 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     KP Singh <kpsingh@chromium.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Security Module list 
        <linux-security-module@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        James Morris <jmorris@namei.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH bpf-next v4 3/8] bpf: lsm: provide attachment points for
 BPF LSM programs
Message-ID: <202002241136.C4F9F7DFF@keescook>
References: <20200220175250.10795-1-kpsingh@chromium.org>
 <20200220175250.10795-4-kpsingh@chromium.org>
 <0ef26943-9619-3736-4452-fec536a8d169@schaufler-ca.com>
 <202002211946.A23A987@keescook>
 <20200223220833.wdhonzvven7payaw@ast-mbp>
 <c5c67ece-e5c1-9e8f-3a2b-60d8d002c894@schaufler-ca.com>
 <20200224171305.GA21886@chromium.org>
 <00c216e1-bcfd-b7b1-5444-2a2dfa69190b@schaufler-ca.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <00c216e1-bcfd-b7b1-5444-2a2dfa69190b@schaufler-ca.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 10:45:27AM -0800, Casey Schaufler wrote:
> On 2/24/2020 9:13 AM, KP Singh wrote:
> > On 24-Feb 08:32, Casey Schaufler wrote:
> >> On 2/23/2020 2:08 PM, Alexei Starovoitov wrote:
> >>> On Fri, Feb 21, 2020 at 08:22:59PM -0800, Kees Cook wrote:
> >>>> If I'm understanding this correctly, there are two issues:
> >>>>
> >>>> 1- BPF needs to be run last due to fexit trampolines (?)
> >>> no.
> >>> The placement of nop call can be anywhere.
> >>> BPF trampoline is automagically converting nop call into a sequence
> >>> of directly invoked BPF programs.
> >>> No link list traversals and no indirect calls in run-time.
> >> Then why the insistence that it be last?
> > I think this came out of the discussion about not being able to
> > override the other LSMs and introduce a new attack vector with some
> > arguments discussed at:
> >
> >   https://lore.kernel.org/bpf/20200109194302.GA85350@google.com/
> >
> > Let's say we have SELinux + BPF runnng on the system. BPF should still
> > respect any decisions made by SELinux. This hasn't got anything to
> > do with the usage of fexit trampolines.
> 
> The discussion sited is more about GPL than anything else.
> 
> The LSM rule is that any security module must be able to
> accept the decisions of others. SELinux has to accept decisions
> made ahead of it. It always has, as LSM checks occur after
> "traditional" checks, which may fail. The only reason that you
> need to be last in this implementation appears to be that you
> refuse to use the general mechanisms. You can't blame SELinux
> for that.

Okay, this is why I wanted to try to state things plainly. The "in last
position" appears to be the result of a couple design choices:

-the idea of "not wanting to get in the way of other LSMs", while
 admirable, needs to actually be a non-goal to be "just" a stacked LSM
 (as you're saying here Casey). This position _was_ required for the
 non-privileged LSM case to avoid security implications, but that goal
 not longer exists here either.

-optimally using the zero-cost call-outs (static key + fexit trampolines)
 meant it didn't interact well with the existing stacking mechanism.

So, fine, these appear to be design choices, not *specifically*
requirements. Let's move on, I think there is more to unpack here...

> >>>> 2- BPF hooks don't know what may be attached at any given time, so
> >>>>    ALL LSM hooks need to be universally hooked. THIS turns out to create
> >>>>    a measurable performance problem in that the cost of the indirect call
> >>>>    on the (mostly/usually) empty BPF policy is too high.
> >>> also no.

AIUI, there was some confusion on Alexei's reply here. I, perhaps,
was not as clear as I needed to be. I think the later discussion on
performance overheads gets more into the point, and gets us closer to
the objections Alexei had. More below...

> >   This approach still had the issues of an indirect call and an
> >   extra check when not used. So this was not truly zero overhead even
> >   after special casing BPF.
> 
> The LSM mechanism is not zero overhead. It never has been. That's why
> you can compile it out. You get added value at a price. You get the
> ability to use SELinux and KRSI together at a price. If that's unacceptable
> you can go the route of seccomp, which doesn't use LSM for many of the
> same reasons you're on about.
> [...]
> >>>> So, trying to avoid the indirect calls is, as you say, an optimization,
> >>>> but it might be a needed one due to the other limitations.
> >>> I'm convinced that avoiding the cost of retpoline in critical path is a
> >>> requirement for any new infrastructure in the kernel.
> >> Sorry, I haven't gotten that memo.

I agree with Casey here -- it's a nice goal, but those cost evaluations have
not yet(?[1]) hit the LSM world. I think it's a desirable goal, to be
sure, but this does appear to be an early optimization.

> [...]
> It can do that wholly within KRSI hooks. You don't need to
> put KRSI specific code into security.c.

This observation is where I keep coming back to.

Yes, the resulting code is not as fast as it could be. The fact that BPF
triggers the worst-case performance of LSM hooking is the "new" part
here, from what I can see.

I suspect the problem is that folks in the BPF subsystem don't want to
be seen as slowing anything down, even other subsystems, so they don't
want to see this done in the traditional LSM hooking way (which contains
indirect calls).

But the LSM subsystem doesn't want special cases (Casey has worked very
hard to generalize everything there for stacking). It is really hard to
accept adding a new special case when there are still special cases yet
to be worked out even in the LSM code itself[2].

> >>> Networking stack converted all such places to conditional calls.
> >>> In BPF land we converted indirect calls to direct jumps and direct calls.
> >>> It took two years to do so. Adding new indirect calls is not an option.
> >>> I'm eagerly waiting for Peter's static_call patches to land to convert
> >>> a lot more indirect calls. May be existing LSMs will take advantage
> >>> of static_call patches too, but static_call is not an option for BPF.
> >>> That's why we introduced BPF trampoline in the last kernel release.
> >> Sorry, but I don't see how BPF is so overwhelmingly special.
> > My analogy here is that if every tracepoint in the kernel were of the
> > type:
> >
> > if (trace_foo_enabled) // <-- Overhead here, solved with static key
> >    trace_foo(a);  // <-- retpoline overhead, solved with fexit trampolines

This is a helpful distillation; thanks.

static keys (perhaps better described as static branches) make sense to
me; I'm familiar with them being used all over the place[3]. The resulting
"zero performance" branch mechanism is extremely handy.

I had been thinking about the fexit stuff only as a way for BPF to call
into kernel functions directly, and I missed the place where this got
used for calling from the kernel into BPF directly. KP walked me through
the fexit stuff off list. I missed where there NOP stub ("noinline int
bpf_lsm_##NAME(__VA_ARGS__) { return 0; }") was being patched by BPF in
https://lore.kernel.org/lkml/20200220175250.10795-6-kpsingh@chromium.org/
The key bit being "bpf_trampoline_update(prog)"

> > It would be very hard to justify enabling them on a production system,
> > and the same can be said for BPF and KRSI.
> 
> The same can be and has been said about the LSM infrastructure.
> If BPF and KRSI are that performance critical you shouldn't be
> tying them to LSM, which is known to have overhead. If you can't
> accept the LSM overhead, get out of the LSM. Or, help us fix the
> LSM infrastructure to make its overhead closer to zero. Whether
> you believe it or not, a lot of work has gone into keeping the LSM
> overhead as small as possible while remaining sufficiently general
> to perform its function.
> 
> No. If you're too special to play by LSM rules then you're special
> enough to get into the kernel using more direct means.

So, I see the primary conflict here being about the performance
optimizations. AIUI:

- BPF subsystem maintainers do not want any new slowdown associated
  with BPF
- LSM subsystem maintainers do not want any new special cases in
  LSM stacking

So, unless James is going to take this over Casey's objections, the path
forward I see here is:

- land a "slow" KRSI (i.e. one that hooks every hook with a stub).
- optimize calling for all LSMs

Does this seem right to everyone?

-Kees


[1] There is a "known cost to LSM", but as Casey mentions, it's been
generally deemed "acceptable". There have been some recent attempts to
quantify it, but it's not been very clear:
https://lore.kernel.org/linux-security-module/c98000ea-df0e-1ab7-a0e2-b47d913f50c8@tycho.nsa.gov/ (lore is missing half this conversation for some reason)

[2] Casey's work to generalize the LSM interfaces continues and it quite
complex:
https://lore.kernel.org/linux-security-module/20200214234203.7086-1-casey@schaufler-ca.com/

[3] E.g. HARDENED_USERCOPY uses it:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/usercopy.c?h=v5.5#n258
and so does the heap memory auto-initialization:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/mm/slab.h?h=v5.5#n676

-- 
Kees Cook

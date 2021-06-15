Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13B013A76EB
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 08:11:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbhFOGNC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 02:13:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbhFOGNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 02:13:02 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CD9CC061574;
        Mon, 14 Jun 2021 23:10:58 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id h12-20020a17090aa88cb029016400fd8ad8so1552736pjq.3;
        Mon, 14 Jun 2021 23:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DBHEmS4g0Ps/56IJBsEic1dXCRjW+WMYMVD7IZgxAsY=;
        b=Ip5LGGIS/e4lktZgEbgLWY+9qLgo8Ojp3ieP5zjE9Y8Z1m5PKdyzEsGT+11Ixo5+X6
         JZVYb2yfZEEgPLUtLtwq1iDmXWyYk6IPpuBbUwS//q/yIY9gb4NS3X5kPqEJWLAE5cTX
         K63irwPoTD2x40rpJDZ1zMyb8q85YHxQ/f7UaZdXdpMFIYKbtMwa0kjxi3Oyc5AOM5tE
         CbjW4ZZ+Osis4lv7SHZ82djZjd7sbpun5ugtxaELiuexVv4mwA0zv+2PkC7mSJzKy4s6
         qKFvmsEHi8OP+xfo7rgchexnspeYVr59zBeSWAX3Q1N7FBxbM9Uxyt7ZGV/dpkwbReY9
         9Y/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DBHEmS4g0Ps/56IJBsEic1dXCRjW+WMYMVD7IZgxAsY=;
        b=e2OZDozf6qEhjJ8T7peE6lAj9mSxPlGl+m6SNPwKM8/f8sXnAuVpqkecgi3XU5tNdD
         VCOdOX6+9fdiyE8jf8d5j9/Wb1lOlh0ncQUxO+fDx57vCszw4bnFAvdEdSYSp8WO3Fxy
         sDm60r6vzBap6b3RVba5hqioFL2USn8WhFWYxWcphgefHnXm3UjZhAV+c5anJvr5wgmZ
         Zvc9D2gu0dJY6rWMoG+Ys7wyFX1h3obQ2jBWsB0Sgl9AdO149PSWRKRkUoEhFiIDyNQU
         /s79qyeYDEoJecBRiWGm57WMFVWpxrD7dQpyDtvSbmfnP00wGL0AuOoEj8rBAdthFIyM
         9olQ==
X-Gm-Message-State: AOAM532y08MNjBWsX7bjjEP44KqKFBiW0F88Yy60xy3/QF1dk56FE9TH
        G+98fIEqGbuzW8n16CJIM6GLi41QgMkmD8YoSXw=
X-Google-Smtp-Source: ABdhPJxA/h5peHLM3DmuaPS23lS63xfnY/uYWMofDEs0liPBBNtYnPtekZJp3wMcjdopE2bLUsly5vLGn2vmFCyn2og=
X-Received: by 2002:a17:90b:190a:: with SMTP id mp10mr3312003pjb.145.1623737457967;
 Mon, 14 Jun 2021 23:10:57 -0700 (PDT)
MIME-Version: 1.0
References: <20210611042442.65444-1-alexei.starovoitov@gmail.com>
 <20210611042442.65444-2-alexei.starovoitov@gmail.com> <CAM_iQpW=a_ukO574qtZ6m4rqo2FrQifoGC1jcrd7yWK=6WWg1w@mail.gmail.com>
 <20210611184516.tpjvlaxjc4zdeqe6@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20210611184516.tpjvlaxjc4zdeqe6@ast-mbp.dhcp.thefacebook.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 14 Jun 2021 23:10:46 -0700
Message-ID: <CAM_iQpV2fv=MMhf3w+YpGDXCYaMKVO_hoACL0=oXmn_pDUVexg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 1/3] bpf: Introduce bpf_timer
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 11, 2021 at 11:45 AM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Jun 10, 2021 at 11:42:24PM -0700, Cong Wang wrote:
> > On Thu, Jun 10, 2021 at 9:27 PM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > From: Alexei Starovoitov <ast@kernel.org>
>
> Please stick to one email thread in the future, ok?
>
> I'll consolidate them here:
>
> > What is your use case to justify your own code? Asking because
> > you deny mine, so clearly my use case is not yours.
>
> I mentioned several use cases in the prior threads.
> tldr: any periodic event in tracing, networking, security.
> Garbage collection falls into this category as well, but please internalize
> that implementing conntrack as it is today in the kernel is an explicit non-goal.

You need to read my use case again, it is for the conntrack
in Cilium, not the kernel one.

>
> > And more importantly, why not just use BPF_TEST_RUN with
> > a user-space timer? Asking because you offer no API to read or
> > modify timer expiration, so literally the same with BPF_TEST_RUN
> > approach.
>
> a wrapper on top of hrtimer_get_remaining() like bpf_timer_get_remaining()
> is trivial to add, but what is the use case?

If you do not have any use case, then stick to BPF_TEST_RUN
with user-space timers? And of course your patches are not needed
at all.

>
> > >
> > > Introduce 'struct bpf_timer { __u64 :64; __u64 :64; };' that can be embedded
> > > in hash/array/lru maps as regular field and helpers to operate on it:
> >
> > Can be or has to be? Huge difference here.
>
> map elements don't have to use timers.

You interpret this in a wrong way, what I asked is whether a bpf timer has
to be embedded in a map. IOW, can a bpf timer be a standalone global
data?

>
> > In the other thread, you said it is global data, which implies that it does
> > not have to be in a map.
>
> global data is a map. That was explained in the prior thread as well.
>

I think you implied bpf timer can exist without a map, hence I am asking.


> >
> > In your test case or your example, all timers are still in a map. So what has
> > changed since then? Looks nothing to me.
>
> look again?

Yes, I just looked at it again, only more confusing, not less.

>
> > Hmm, finally you begin refcounting it, which you were strongly against. ;)
>
> That was already answered in the prior thread.
> tldr: there were two options. This is one of them. Another can be added
> in the future as well.
>
> > Three questions:
> >
> > 1. Can t->prog be freed between bpf_timer_init() and bpf_timer_start()?
>
> yes.

Good. So if a program which only initializes the timer and then exits,
the other program which shares this timer will crash when it calls
bpf_timer_start(), right?

>
> > If the timer subprog is always in the same prog which installs it, then
>
> installs it? I'm not following the quesiton.
>
> > this is fine. But then how do multiple programs share a timer?
>
> there is only one callback function.

That's exactly my question. How is one callback function shared
by multiple eBPF programs which want to share the timer?


>
> > In the
> > case of conntrack, either ingress or egress could install the timer,
> > it only depends which one gets traffic first. Do they have to copy
> > the same subprog for the same timer?
>
> conntrack is an explicit non-goal.

I interpret this as you do not want timers to be shared by multiple
eBPF programs, correct? Weirdly, maps are shared, timers are
placed in a map, so timers should be shared naturally too.

>
> >
> > 2. Can t->prog be freed between a timer expiration and bpf_timer_start()
> > again?
>
> If it's already armed with the first bpf_timer_start() it won't be freed.

Why? I see t->prog is released in your timer callback:

+       bpf_prog_put(prog);
+       this_cpu_write(hrtimer_running, NULL);
+       return HRTIMER_NORESTART;

>
> > It gets a refcnt when starting a timer and puts it when cancelling
> > or expired, so t->prog can be freed right after cancelling or expired. What
> > if another program which shares this timer wants to restart this timer?
>
> There is only one callback_fn per timer. Another program can share
> the struct bpf_timer and the map. It might have subprog callback_fn code
> that looks exactly the same as callback_fn in the first prog.
> For example when libbpf loads progs/timer.c (after it was compiled into .o)
> it might share a subprog in the future (when kernel has support for
> dynamic linking). From bpf user pov it's a single .c file.
> The split into programs and subprograms is an implemenation detail
> that C programmer doesn't need to worry about.

Not exactly, they share a same C file but still can be loaded/unloaded
separately. And logically, whether a timer has been initialized once or
twice makes a huge difference for programers.

>
> > 3. Since you offer no API to read the expiration time, why not just use
> > BPF_TEST_RUN with a user-space timer? This is preferred by Andrii.
>
> Andrii point was that there should be no syscall cmds that replicate
> bpf_timer_init/start/cancel helpers. I agree with this.

Actually there is no strong reason to bother a bpf timer unless you
want to access the timer itself, which mostly contains expiration.
User-space timers work just fine for your cases, even if not, extending
BPF_TEST_RUN should too.

>
>
> > Thanks.
> >
> > Another unpopular point of view:
> >
> > This init() is not suitable for bpf programs, because unlike kernel modules,
> > there is no init or exit functions for a bpf program. And timer init
> > is typically
> > called during module init.
>
> Already answerd this in the prior thread. There will be __init and __fini like
> subprograms in bpf progs.

I interpret this as init does not make sense until we have __init and __fini?

>
> Please apply the patches to your local tree and do few experiments based
> on selftests/bpf/progs/timer.c. I think experimenting with the code
> will answer all of your questions.

Sounds like you find a great excuse for a failure of documentation.
What I asked are just fundamental design questions you should have
covered in your cover letter, which is literally empty.

Thanks.

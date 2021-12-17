Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385AB47839C
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 04:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhLQDVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 22:21:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhLQDVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 22:21:51 -0500
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F759C061574
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 19:21:51 -0800 (PST)
Received: by mail-ed1-x52f.google.com with SMTP id r11so2643535edd.9
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 19:21:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QmLp9l4UAHF5Ymv1J067Od0keyQaO0/FoX91IQBmiq8=;
        b=Gh73E85yTsCSi66skCl3rfCsURhqEVqFh7pOB9XskjnrBTKkmhCAj8H+HlfzUyIx3z
         9Trp6g3JrfRVVa3tlHgeHhm1hkTdhmppBk91bNVy1uBTJi7brrIPbYbyJS4AZ6mo2Wt2
         t2OKzjANaJEC4aQjGZqyLFb5qDnrEV11LDDKyW31NxA+XFi6QkrxPXF7pTV5yk+S7lYv
         OO1fmUsLeWvFoMnrbd2T+jw//o9vgoyIrSmTHhwm4rQGrLv+2sKpXckoe2JCuWNaw20M
         0Xu+2PTziemmIzVpkb6S1JoFasG9HIgZHNaGjc+dOtQxdNIJgLMjCLkNuW6O5+4Hsxf0
         CDYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QmLp9l4UAHF5Ymv1J067Od0keyQaO0/FoX91IQBmiq8=;
        b=X1vwikeuhW6rQSmC8Ypnw3Qzh+LcVs83TSucvLBH8KQGQEJJD9IyJWu0xbJbnc7jz6
         CkJF1rk47lWA1miNTcLC3hnA46frNYr7ID0pRhYpuIrCuOgthkIHITDRqWX8qJ1bVDAZ
         efkWQlAhlmwUPjdq7853B+RM0+GeBI1DavqXCfUSexWmej+EHVZh3a0pbMgq+SIBFYtD
         OMmLOcmxDbB3HcDVmtDFiwu+FISW6p/UMslI8PL5G4xgE6FZS+xVbHrtbPSYUgNTq3I+
         uwYmunV0mC9zBrmXQyLMk87yvuZKdrbJn8EZ00YZaHuUhAlOXSI9ZPdwHYJbwEkfk+42
         xmIg==
X-Gm-Message-State: AOAM531GcO6+1Wqqma05mFEzfT9N2erZOL4rJH8eqxpPPtsUIivWMSp0
        kvVVIMzlr3wbI4G1PDvi+sXfoFgE2lwn25Tbsew=
X-Google-Smtp-Source: ABdhPJxLO5D0uLttHpxaPhQQiuZvWTkyi/o5eqMv6LR+RTRNiUiB1LKpBI6BiJc1gfnajMqg2eqpoZrdkfi7EPJlLg8=
X-Received: by 2002:a17:906:1e05:: with SMTP id g5mr929739ejj.552.1639711309883;
 Thu, 16 Dec 2021 19:21:49 -0800 (PST)
MIME-Version: 1.0
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
 <20211208145459.9590-3-xiangxia.m.yue@gmail.com> <61b383c6373ca_1f50e20816@john.notmuch>
 <CAMDZJNV3-y5jkUAJJ--10PcicKpGMwKS_3gG9O7srjomO3begw@mail.gmail.com>
 <CAMDZJNXL5qSfFv54A=RrMwHe8DOv48EfrypHb1FFSUFu36-9DQ@mail.gmail.com>
 <CAMDZJNUyOELOcf0dtxktCTRKv1sUrp5Z17mW+4so7tt6DFnJsw@mail.gmail.com>
 <368e82ef-24be-06c7-2111-8a21cd558100@iogearbox.net> <CAMDZJNXY249r_SBuSjCwkAf-xGF98-5EPN41d23Jix0fTawZTw@mail.gmail.com>
 <1ba06b2f-6c78-cec1-4ba4-98494a402d0e@iogearbox.net>
In-Reply-To: <1ba06b2f-6c78-cec1-4ba4-98494a402d0e@iogearbox.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Fri, 17 Dec 2021 11:21:07 +0800
Message-ID: <CAMDZJNUcOo94i0gbDG-a9+Y=x04cZx_7KSedKEUh6gvCsa+k0g@mail.gmail.com>
Subject: Re: [net v5 2/3] net: sched: add check tc_skip_classify in sch egress
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     John Fastabend <john.fastabend@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 16, 2021 at 8:37 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/11/21 1:37 AM, Tonghao Zhang wrote:
> > On Sat, Dec 11, 2021 at 4:11 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >> On 12/10/21 8:54 PM, Tonghao Zhang wrote:
> >>> On Sat, Dec 11, 2021 at 1:46 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >>>> On Sat, Dec 11, 2021 at 1:37 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >>>>> On Sat, Dec 11, 2021 at 12:43 AM John Fastabend
> >>>>> <john.fastabend@gmail.com> wrote:
> >>>>>> xiangxia.m.yue@ wrote:
> [...]
> >>>>> Hi John
> >>>>> Tx ethx -> __dev_queue_xmit -> sch_handle_egress
> >>>>> ->  execute BPF program on ethx with bpf_redirect(ifb0) ->
> >>>>> -> ifb_xmit -> ifb_ri_tasklet -> dev_queue_xmit -> __dev_queue_xmit
> >>>>> the packets loopbacks, that means bpf_redirect doesn't work with ifb
> >>>>> netdev, right ?
> >>>>> so in sch_handle_egress, I add the check skb_skip_tc_classify().
> >>
> >> But why would you do that? Usage like this is just broken by design..
> > As I understand, we can redirect packets to a target device either at
> > ingress or at *egress
> >
> > The commit ID: 3896d655f4d491c67d669a15f275a39f713410f8
> > Allow eBPF programs attached to classifier/actions to call
> > bpf_clone_redirect(skb, ifindex, flags) helper which will mirror or
> > redirect the packet by dynamic ifindex selection from within the
> > program to a target device either at ingress or at egress. Can be used
> > for various scenarios, for example, to load balance skbs into veths,
> > split parts of the traffic to local taps, etc.
> >
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=3896d655f4d491c67d669a15f275a39f713410f8
> > https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=27b29f63058d26c6c1742f1993338280d5a41dc6
> >
> > But at egress the bpf_redirect doesn't work with ifb.
> >> If you need to loop anything back to RX, just use bpf_redirect() with
> > Not use it to loop packets back. the flags of bpf_redirect is 0. for example:
> >
> > tc filter add dev veth1 \
> > egress bpf direct-action obj test_bpf_redirect_ifb.o sec redirect_ifb
> > https://patchwork.kernel.org/project/netdevbpf/patch/20211208145459.9590-4-xiangxia.m.yue@gmail.com/
> >> BPF_F_INGRESS? What is the concrete/actual rationale for ifb here?
> > We load balance the packets to different ifb netdevices at egress. On
> > ifb, we install filters, rate limit police,
Hi Daniel, I try to answer your question. thanks
> I guess this part here is what I don't quite follow. Could you walk me through
> the packet flow in this case? So you go from bpf@tc-egress@phys-dev to do the
> redirect to bpf@tc-egress@ifb, and then again to bpf@tc-egress@phys-dev (same
ifb doesn't install bpf prog, ifb will redirect packets to netdevice
which packets from.
ifb_ri_tasklet
1. skb->dev = dev_get_by_index_rcu(dev_net(txp->dev), skb->skb_iif);
// skb_iif is phys-dev
2. dev_queue_xmit

> dev or different one I presume)? Why not doing the load-balancing, applying the
> policy, and doing the rate-limiting (e.g. EDT with sch_fq) directly at the initial
> bpf@tc-egress@phys-dev location given bpf is perfectly capable to do all of it
> there w/o the extra detour & overhead through ifb? The issue I see here is adding
This is not easy to explain. We have two solution for our production,
one is this, other one is my
other patchset:
https://patchwork.kernel.org/project/netdevbpf/list/?series=593409&archive=both&state=*

Why I need those solutions, please see my patch 1/2 commit message.
https://patchwork.kernel.org/project/netdevbpf/patch/20211210023626.20905-2-xiangxia.m.yue@gmail.com/

The different of two solution is that this one use ifb to do the
rate-limiting/load-blance for applications which
key is high throughput. Then for  applications which key is  the low
latency of data access, can use the
mq or fifo qdisc in the phys-dev. This is very useful in k8s
environment. Anyway my other patchset is better
for this one sulotion. but this one solution is easy to used because
we can use the tc cmd(not bpf) to install filters.

This patch try to fix the bug in bpf.
> extra overhead to support such a narrow case that nobody else is using and that
I don't agree that, I think it's very useful in k8s. If the pods of
k8s are sharing the network resource, this is really a narrow case.
But part of pods want low latency, and other part of pods want high
throughput, this solution is selectable.
> can be achieved already with existing infra as I understood it; the justification
> right now to add the extra checks to the critical fast path is very thin..
note that:
For tc cmd, there is the check "skb_skip_tc_classify" in
tcf_action_exec, This patch only want to move check to
sch_handle_egress to avoid the
unessential tc filter lookup.
For bpf_redirect, we don't run tcf_action_exec, the packets loopback
if there is no check. This patch try to fix bug(bpf), and improve
performance(tc)

I use the netperf/iperf to measure performance, It's not easy to
figure out performance drop.
> Thanks,
> Daniel



-- 
Best regards, Tonghao

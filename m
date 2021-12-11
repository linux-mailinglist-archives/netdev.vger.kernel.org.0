Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 549C6470F87
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 01:38:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345493AbhLKAlx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 19:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345465AbhLKAlt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 19:41:49 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80B43C061714
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 16:38:13 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id z5so35601179edd.3
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 16:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+HtJv7UQXnlWIVwfi+CjeSm1dzhTzPYVG1OMTvzte1c=;
        b=Sj1GthU6T8a2qkwOJd+J7LBQ3DosZLHs3WSw9f8iIwhvnTQKJ0EKA4H1djIQiyEBVJ
         037wr1+i/B8a468+PtwOxzGuSSzhydtghr2YkRQKb8RZ3jYJFRY04LLTEoK4Lq8i3ng0
         SefUOeGHtgVKMT90UfDGEpOeuhPfpbkMyuiDfDhUk4dH4/95zdCGj1UTmBSzGlQnm7n9
         K6W1D9NIjUEem3SUmdvfYELhCx0ITwyJWi4gk5k6tkbMd1he5EfVQslCmEBSfsCDkFuX
         oyn8OktqIuH1Cpqcg4NwAF+IliumXx67s5IPt+xuWspNuveQkK46/6fqlJD+LfqbOF1/
         DBHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+HtJv7UQXnlWIVwfi+CjeSm1dzhTzPYVG1OMTvzte1c=;
        b=0jRW6nsKGeqQusMOs6s4vi18uSQeFKD/OPRmRXdPK9kWqw3M3Ni7TSNUaMElzBHoBY
         OuVV6UxjcDWBeebC/JvRe2ofKq+KiusQj7FP+cSWC1wfJAZjIcY/lnoi2qs+yiZr2xe3
         VbQMdH5EApf0vhiBK5vKWDe1vitZZ0V/raj4ngnvCXXNYmv/5BjSj4ZYWuUVOXTk8dTZ
         /K3r8EXYxb/Lq+dSjh/MM9uut3bDVST08NmXcyTqts9r7Z59+hrEkiiaFX8bSPYV7T60
         6GxZlLMIyx8wbJ3JnyDg8goOSYW3EyJrSVxOs1pA2ZQUhtgQ9U46Xb8uBSz0qNYFyyuk
         kjaA==
X-Gm-Message-State: AOAM533GYWYPnlpe7tF4Q/gSKYVtJeLwxlxYt0R25ju/b5c52mOQN8iS
        il3rXbc9WBZ1PdP/ClpdLjoHlng/026gcNFkiWcFycwEMfPCrgi7
X-Google-Smtp-Source: ABdhPJwYf/7IETYLuoT7L2izYrTcZejyP3Bz8q2Vhv+ouLx1G+WOAZuGaDlxdAKmFtx9K3kRDCoHhxvgFEUnXpKLdtU=
X-Received: by 2002:a17:906:7009:: with SMTP id n9mr27731645ejj.431.1639183092047;
 Fri, 10 Dec 2021 16:38:12 -0800 (PST)
MIME-Version: 1.0
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
 <20211208145459.9590-3-xiangxia.m.yue@gmail.com> <61b383c6373ca_1f50e20816@john.notmuch>
 <CAMDZJNV3-y5jkUAJJ--10PcicKpGMwKS_3gG9O7srjomO3begw@mail.gmail.com>
 <CAMDZJNXL5qSfFv54A=RrMwHe8DOv48EfrypHb1FFSUFu36-9DQ@mail.gmail.com>
 <CAMDZJNUyOELOcf0dtxktCTRKv1sUrp5Z17mW+4so7tt6DFnJsw@mail.gmail.com> <368e82ef-24be-06c7-2111-8a21cd558100@iogearbox.net>
In-Reply-To: <368e82ef-24be-06c7-2111-8a21cd558100@iogearbox.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 11 Dec 2021 08:37:35 +0800
Message-ID: <CAMDZJNXY249r_SBuSjCwkAf-xGF98-5EPN41d23Jix0fTawZTw@mail.gmail.com>
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

On Sat, Dec 11, 2021 at 4:11 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> On 12/10/21 8:54 PM, Tonghao Zhang wrote:
> > On Sat, Dec 11, 2021 at 1:46 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >> On Sat, Dec 11, 2021 at 1:37 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >>> On Sat, Dec 11, 2021 at 12:43 AM John Fastabend
> >>> <john.fastabend@gmail.com> wrote:
> >>>> xiangxia.m.yue@ wrote:
> >>>>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >>>>>
> >>>>> Try to resolve the issues as below:
> >>>>> * We look up and then check tc_skip_classify flag in net
> >>>>>    sched layer, even though skb don't want to be classified.
> >>>>>    That case may consume a lot of cpu cycles. This patch
> >>>>>    is useful when there are a lot of filters with different
> >>>>>    prio. There is ~5 prio in in production, ~1% improvement.
> >>>>>
> >>>>>    Rules as below:
> >>>>>    $ for id in $(seq 1 5); do
> >>>>>    $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> >>>>>    $ done
> >>>>>
> >>>>> * bpf_redirect may be invoked in egress path. If we don't
> >>>>>    check the flags and then return immediately, the packets
> >>>>>    will loopback.
> >>>>
> >>>> This would be the naive case right? Meaning the BPF program is
> >>>> doing a redirect without any logic or is buggy?
> >>>>
> >>>> Can you map out how this happens for me, I'm not fully sure I
> >>>> understand the exact concern. Is it possible for BPF programs
> >>>> that used to see packets no longer see the packet as expected?
> >>>>
> >>>> Is this the path you are talking about?
> >>> Hi John
> >>> Tx ethx -> __dev_queue_xmit -> sch_handle_egress
> >>> ->  execute BPF program on ethx with bpf_redirect(ifb0) ->
> >>> -> ifb_xmit -> ifb_ri_tasklet -> dev_queue_xmit -> __dev_queue_xmit
> >>> the packets loopbacks, that means bpf_redirect doesn't work with ifb
> >>> netdev, right ?
> >>> so in sch_handle_egress, I add the check skb_skip_tc_classify().
>
> But why would you do that? Usage like this is just broken by design..
As I understand, we can redirect packets to a target device either at
ingress or at *egress

The commit ID: 3896d655f4d491c67d669a15f275a39f713410f8
Allow eBPF programs attached to classifier/actions to call
bpf_clone_redirect(skb, ifindex, flags) helper which will mirror or
redirect the packet by dynamic ifindex selection from within the
program to a target device either at ingress or at egress. Can be used
for various scenarios, for example, to load balance skbs into veths,
split parts of the traffic to local taps, etc.

https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=3896d655f4d491c67d669a15f275a39f713410f8
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/?id=27b29f63058d26c6c1742f1993338280d5a41dc6

But at egress the bpf_redirect doesn't work with ifb.
> If you need to loop anything back to RX, just use bpf_redirect() with
Not use it to loop packets back. the flags of bpf_redirect is 0. for example:

tc filter add dev veth1 \
egress bpf direct-action obj test_bpf_redirect_ifb.o sec redirect_ifb
https://patchwork.kernel.org/project/netdevbpf/patch/20211208145459.9590-4-xiangxia.m.yue@gmail.com/
> BPF_F_INGRESS? What is the concrete/actual rationale for ifb here?
We load balance the packets to different ifb netdevices at egress. On
ifb, we install filters, rate limit police,




-- 
Best regards, Tonghao

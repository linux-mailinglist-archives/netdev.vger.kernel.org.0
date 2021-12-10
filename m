Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD70470B20
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 20:55:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242904AbhLJT6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 14:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239993AbhLJT6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 14:58:36 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553D0C061746
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:55:01 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id e3so33941495edu.4
        for <netdev@vger.kernel.org>; Fri, 10 Dec 2021 11:55:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=np0Bgb9QERmxyrGc4HVOA85tC0IBOpQK5AB9tRWgq80=;
        b=JqAAGzUFas0IsgsvMrwpsKeIzq5xTSoZe5NYL2x1Xb5qBpaSlwZBj5LON3SWB+wLQJ
         sJF9ddYXKqPAqZypzwXz/9QJClVy02w3H8eNAvqW7WjT5x82BxBXj2mQveNW6vmJEse5
         IuWnaDq1/7tCIt+DDNW1VQuEuTmPav/r+2mw1PCVJyQisenSngwlrQMmwM5zJkMSv92W
         TRe8F4T9vqho1CDBf+H9jVumvhsHk8SEY+L6oCYLkMPtMu5LOwE1h/Q2S+OtbK1NC19Y
         VyZBeQ0Xx8ZHgpHeSRgfVSMZ1Ri/6LiBss6v5Diy+rLP7MFS/Z4DGFrRmpaQhmDp28pn
         hx9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=np0Bgb9QERmxyrGc4HVOA85tC0IBOpQK5AB9tRWgq80=;
        b=cvWC8EraplhfiegGou9q4fHMfgJQT82riKwMt0ttV39bCnGnrxp1fgaFUo6POHXjDo
         ozj3dp0Z0XcqUQQ8ZDOemonfNbFpiYQ+n/YrCsgmfu3Az2QkLY4c5aoqo59WX1FKbO/I
         5QQmJbBV/5BOBV7d88AhM4Vr0Kux6VxcU2+cPCd78PWwQs9sB4Lf1//LRhReETcsff1h
         uAb7dSdHkv9QcmbcUowUDNKjhe4zzdq8MKXYXBln7N5o8waiMD00nESCzx+3ZgEVFlzF
         QaCZYxjNSqjQy+6cCbCMAfLiyEiMSQOMp8xhTzz286Ufte/IRDM6NQmt4UI6rBHU8Lcn
         Pf+Q==
X-Gm-Message-State: AOAM532N2jxFCem+GwYQ4/lxLYe2kzzx55v+ALexpfnGNwDwcm08ngyh
        GGbVGEaJDY03jsHDMSPcWGNbscorPXhp0r9z5ZY=
X-Google-Smtp-Source: ABdhPJxqSH2yslH36URW9KDCdALc59K7VMFSFzJyMxcaY5B6TCyoNd8hca/tT7G/suvl3/aeZ5Hy+5LWbpesgGjKp1Q=
X-Received: by 2002:a05:6402:4389:: with SMTP id o9mr41606203edc.138.1639166099924;
 Fri, 10 Dec 2021 11:54:59 -0800 (PST)
MIME-Version: 1.0
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
 <20211208145459.9590-3-xiangxia.m.yue@gmail.com> <61b383c6373ca_1f50e20816@john.notmuch>
 <CAMDZJNV3-y5jkUAJJ--10PcicKpGMwKS_3gG9O7srjomO3begw@mail.gmail.com> <CAMDZJNXL5qSfFv54A=RrMwHe8DOv48EfrypHb1FFSUFu36-9DQ@mail.gmail.com>
In-Reply-To: <CAMDZJNXL5qSfFv54A=RrMwHe8DOv48EfrypHb1FFSUFu36-9DQ@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sat, 11 Dec 2021 03:54:23 +0800
Message-ID: <CAMDZJNUyOELOcf0dtxktCTRKv1sUrp5Z17mW+4so7tt6DFnJsw@mail.gmail.com>
Subject: Re: [net v5 2/3] net: sched: add check tc_skip_classify in sch egress
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
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

On Sat, Dec 11, 2021 at 1:46 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Sat, Dec 11, 2021 at 1:37 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> >
> > On Sat, Dec 11, 2021 at 12:43 AM John Fastabend
> > <john.fastabend@gmail.com> wrote:
> > >
> > > xiangxia.m.yue@ wrote:
> > > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > > >
> > > > Try to resolve the issues as below:
> > > > * We look up and then check tc_skip_classify flag in net
> > > >   sched layer, even though skb don't want to be classified.
> > > >   That case may consume a lot of cpu cycles. This patch
> > > >   is useful when there are a lot of filters with different
> > > >   prio. There is ~5 prio in in production, ~1% improvement.
> > > >
> > > >   Rules as below:
> > > >   $ for id in $(seq 1 5); do
> > > >   $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> > > >   $ done
> > > >
> > > > * bpf_redirect may be invoked in egress path. If we don't
> > > >   check the flags and then return immediately, the packets
> > > >   will loopback.
> > >
> > > This would be the naive case right? Meaning the BPF program is
> > > doing a redirect without any logic or is buggy?
> > >
> > > Can you map out how this happens for me, I'm not fully sure I
> > > understand the exact concern. Is it possible for BPF programs
> > > that used to see packets no longer see the packet as expected?
> > >
> > > Is this the path you are talking about?
> > Hi John
> > Tx ethx -> __dev_queue_xmit -> sch_handle_egress
> > ->  execute BPF program on ethx with bpf_redirect(ifb0) ->
> > -> ifb_xmit -> ifb_ri_tasklet -> dev_queue_xmit -> __dev_queue_xmit
> > the packets loopbacks, that means bpf_redirect doesn't work with ifb
> > netdev, right ?
> > so in sch_handle_egress, I add the check skb_skip_tc_classify().
> >
> > >  rx ethx  ->
> > >    execute BPF program on ethx with bpf_redirect(ifb0) ->
> > >      __skb_dequeue @ifb tc_skip_classify = 1 ->
> > >        dev_queue_xmit() ->
> > >           sch_handle_egress() ->
> > >             execute BPF program again
> > >
> > > I can't see why you want to skip that second tc BPF program,
> > > or for that matter any tc filter there. In general how do you
> > > know that is the correct/expected behavior? Before the above
> > > change it would have been called, what if its doing useful
> > > work.
> > bpf_redirect works fine on ingress with ifb
> > __netif_receive_skb_core -> sch_handle_ingress -> bpf_redirect (ifb0)
> > -> ifb_xmit -> netif_receive_skb -> __netif_receive_skb_core
> > but
> > __netif_receive_skb_core --> skb_skip_tc_classify(so the packets will
> > execute the BPF progam again)
> so the packets will NOT execute the BPF progam again)
>
> > > Also its not clear how your ifb setup is built or used. That
> > > might help understand your use case. I would just remove the
> > > IFB altogether and the above discussion is mute.
> > tc filter add dev veth1 egress bpf direct-action obj
> > test_bpf_redirect_ifb.o sec redirect_ifb
> >
> > the test_bpf_redirect_ifb  bpf progam:
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2021 DiDi Global */
> > +
> > +#include <linux/bpf.h>
> > +#include <bpf/bpf_helpers.h>
> > +
> > +SEC("redirect_ifb")
> > +int redirect(struct __sk_buff *skb)
> > +{
> > +       return bpf_redirect(skb->ifindex + 1 /* ifbX */, 0);
> > +}
> > +
> > +char __license[] SEC("license") = "GPL";
> >
> > The 3/3 is selftest:
> > https://patchwork.kernel.org/project/netdevbpf/patch/20211208145459.9590-4-xiangxia.m.yue@gmail.com/
> >
> > > Thanks,
> > > John
Hi John
Did I answer your question? I hope I explained things clearly.
> >
> >
> > --
> > Best regards, Tonghao
>
>
>
> --
> Best regards, Tonghao



-- 
Best regards, Tonghao

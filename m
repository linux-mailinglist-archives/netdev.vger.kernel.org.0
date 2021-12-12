Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91434471984
	for <lists+netdev@lfdr.de>; Sun, 12 Dec 2021 10:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230004AbhLLJlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Dec 2021 04:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbhLLJl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Dec 2021 04:41:29 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FD86C061714
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 01:41:29 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id v1so43452360edx.2
        for <netdev@vger.kernel.org>; Sun, 12 Dec 2021 01:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KwaV+90gkfKpRorBcfPvmE8WN7HF/WeI5cAnJtlChFI=;
        b=pZKbCN9VZ9P5odNzSE342s3SW0xxrliS/lZCysrRZDUaTGXMJztt+w7JxyrQizctFj
         WvnwssiwvK9VAkDUcqG+mJ+F8E7pCoN0oCYCNXkzNk94W3P0XkAKg6lmQuDifKHuP1DV
         9jXUQf5UeG4hy2Z25E2XFgfC7eGHMrfAaXOqRO10Fvq76zlNBP3fVs9ujO6D70n7byGd
         XiBPBOtBipj1PGP9fAWfh8x54k0fgDXPd6R13j2F3IPH0ElMXb0qrUUD7N3vSjSp2SKD
         BPJpnoqdbtHzmdEV2wq8FvIvkHSfl2uuAFg3dyAlQi9GHWon8T8/zf5dlbwb3oyy/E83
         s4vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KwaV+90gkfKpRorBcfPvmE8WN7HF/WeI5cAnJtlChFI=;
        b=GLQPtBqQTVVTuQA3ZR3BAXygm158TVxFVHEumUtXzzreSGy6uOIKVoghXyjYxXhzQX
         1sVwbXLA/ClHqIVbjjomZIh8NRgpdIo913WV0c1uWEuOFn/EtNbqEt8uIP4R9xfn9wh2
         QVTP0I2aG8pvumXxf71SbmoFCFnLdmgnZAKy5A/hjhn+y3Oo/0Tg0T3O9qt9MfB4LDjB
         vNkqlWFnMou4PA1d8b1pVS/IJjaqmjdBXuKuYiteVNOu5v2y1R9SYcSf+ITmvRlQzgGT
         sp85B6+qwMnnsC15Jky+ypZJ/TSQBr3cEmU+I+WCL7z2DYcqZcbcWkSUZqnKFuPFCtOV
         C9tQ==
X-Gm-Message-State: AOAM531RcjHrmu+1F6WGitm9HXPUaYgtl7knnIaot2Jt1TtXXUuJZKjF
        VXUDgLJZ4cJjhpPADYA7Kx/CfX52hmHIveGHaQc=
X-Google-Smtp-Source: ABdhPJzR1zenKTBp9cW1jMx1ffSYFcS3ovrPE0Gb+IqJ52vAtbzQc9WGYoTgx5s72pTfEpF0NHGulC8+NfTv9qjRL4k=
X-Received: by 2002:a05:6402:34d:: with SMTP id r13mr53357414edw.208.1639302087805;
 Sun, 12 Dec 2021 01:41:27 -0800 (PST)
MIME-Version: 1.0
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
 <20211208145459.9590-3-xiangxia.m.yue@gmail.com> <61b383c6373ca_1f50e20816@john.notmuch>
 <CAMDZJNV3-y5jkUAJJ--10PcicKpGMwKS_3gG9O7srjomO3begw@mail.gmail.com>
 <CAMDZJNXL5qSfFv54A=RrMwHe8DOv48EfrypHb1FFSUFu36-9DQ@mail.gmail.com>
 <CAMDZJNUyOELOcf0dtxktCTRKv1sUrp5Z17mW+4so7tt6DFnJsw@mail.gmail.com> <368e82ef-24be-06c7-2111-8a21cd558100@iogearbox.net>
In-Reply-To: <368e82ef-24be-06c7-2111-8a21cd558100@iogearbox.net>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Sun, 12 Dec 2021 17:40:51 +0800
Message-ID: <CAMDZJNXMDWYd_CYVDSEdpkAUSZDJLdK7G4qBb4AVc1Nye0r_yA@mail.gmail.com>
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
> If you need to loop anything back to RX, just use bpf_redirect() with
> BPF_F_INGRESS? What is the concrete/actual rationale for ifb here?
Hi
note that: ifb_ri_tasklet can send out the packets or receive skb
ifb_ri_tasklet
                if (!skb->from_ingress) {
                        dev_queue_xmit(skb); // bpf_redirect to ifb
and ifb invoked the dev_queue_xmit in our case.
                } else {
                        skb_pull_rcsum(skb, skb->mac_len);
                        netif_receive_skb(skb);
                }
-- 
Best regards, Tonghao

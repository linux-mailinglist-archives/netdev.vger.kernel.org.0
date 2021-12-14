Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31DA3473ABF
	for <lists+netdev@lfdr.de>; Tue, 14 Dec 2021 03:28:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244008AbhLNC2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 21:28:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229616AbhLNC17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Dec 2021 21:27:59 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF7EC061574
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 18:27:59 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id l25so58650480eda.11
        for <netdev@vger.kernel.org>; Mon, 13 Dec 2021 18:27:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IINFqFM48YEdk/eyQMnqQrTgqiUFOQW3mFSLXia9rwk=;
        b=ecUJbIH4rSILW9xTOPVbAWxjoHpB8w+t5qSjY8t8bPtEua2AdYqpnSPJu2EoXm7vg8
         lOaD7OWlMbBi0VyXrLmCGdJh+u/LtIbJ6Jm00o60MtkKkNCaXr4atixLC1ODvfY9+XLj
         Vn5u6i9LAdIG+8HUW2yr7rVaECgSkQkBzuL5qwlvTyALkoEELRgwniL0fXrB6mcvvlHs
         aoZ0yAqM6bbcnUt2oKA1owt47ZhNAnhK+pMRzziLevD/q6CjWUwAnvUZajZiPJzrLE78
         tfqA0S94r+b2AH7QZ+T/LqVptM3c40RtwQLoi7hHc20LgwZ8fFILAajdpUQPU7d7thlS
         SCkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IINFqFM48YEdk/eyQMnqQrTgqiUFOQW3mFSLXia9rwk=;
        b=Oj14tV9LFzZfohxu+ZANPjtkb6VbN4EPYXmhjVcjh7RtKNULmaD5/EWX0U2QhELBxu
         GjxBUvWAKZMk46OTzfVaKiQXKWLIx+FxoV3xIx76lNI3wgxtVaNiRiMNNiVlyb55P+EM
         QtCiQTTM3qb2YkhOM6hEGYib+/qlUcCsaapN9QJ6nfl/vykM8yKTpMBneTsT6oNcxljj
         adW9oWwJkOjNH3C0XlCnv5tOl/sVA1pNqksmQvGxzwQfMxopN+oaffx5BddcyXismvTh
         Ceern+dBpLU9iW/itKUoSOYMmUqr8umv5a8ZdlkshMPjVBbM8E0HppuGOIfiniYeDaS0
         q7Cw==
X-Gm-Message-State: AOAM530Ol+asb0jb87TNLWB7JhwpqghtWB1xnWx4H45tKOEtwHNOqF8L
        pZVmJXlj+oZzJsskDK0iMax+ry0273/4cs4G+Yw=
X-Google-Smtp-Source: ABdhPJyT4nUxmG09CnVeBNeYa2MQtzKKquOlTwaK22GQtDGXBREUe6oTSyQjrSBHNrTSUgKe/T/H1CKDaUW65d8nJWk=
X-Received: by 2002:a05:6402:2152:: with SMTP id bq18mr3690883edb.105.1639448878023;
 Mon, 13 Dec 2021 18:27:58 -0800 (PST)
MIME-Version: 1.0
References: <20211208145459.9590-1-xiangxia.m.yue@gmail.com>
 <20211208145459.9590-3-xiangxia.m.yue@gmail.com> <61b383c6373ca_1f50e20816@john.notmuch>
 <CAMDZJNV3-y5jkUAJJ--10PcicKpGMwKS_3gG9O7srjomO3begw@mail.gmail.com>
 <CAMDZJNXL5qSfFv54A=RrMwHe8DOv48EfrypHb1FFSUFu36-9DQ@mail.gmail.com>
 <CAMDZJNUyOELOcf0dtxktCTRKv1sUrp5Z17mW+4so7tt6DFnJsw@mail.gmail.com>
 <368e82ef-24be-06c7-2111-8a21cd558100@iogearbox.net> <CAMDZJNXMDWYd_CYVDSEdpkAUSZDJLdK7G4qBb4AVc1Nye0r_yA@mail.gmail.com>
In-Reply-To: <CAMDZJNXMDWYd_CYVDSEdpkAUSZDJLdK7G4qBb4AVc1Nye0r_yA@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 14 Dec 2021 10:27:21 +0800
Message-ID: <CAMDZJNXN3wAtyoOHCGD=oLdwPoy2cNhmuKZ9JEP6KZX4TjCoMA@mail.gmail.com>
Subject: Re: [net v5 2/3] net: sched: add check tc_skip_classify in sch egress
To:     Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
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

On Sun, Dec 12, 2021 at 5:40 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Sat, Dec 11, 2021 at 4:11 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> >
> > On 12/10/21 8:54 PM, Tonghao Zhang wrote:
> > > On Sat, Dec 11, 2021 at 1:46 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > >> On Sat, Dec 11, 2021 at 1:37 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > >>> On Sat, Dec 11, 2021 at 12:43 AM John Fastabend
> > >>> <john.fastabend@gmail.com> wrote:
> > >>>> xiangxia.m.yue@ wrote:
> > >>>>> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >>>>>
> > >>>>> Try to resolve the issues as below:
> > >>>>> * We look up and then check tc_skip_classify flag in net
> > >>>>>    sched layer, even though skb don't want to be classified.
> > >>>>>    That case may consume a lot of cpu cycles. This patch
> > >>>>>    is useful when there are a lot of filters with different
> > >>>>>    prio. There is ~5 prio in in production, ~1% improvement.
> > >>>>>
> > >>>>>    Rules as below:
> > >>>>>    $ for id in $(seq 1 5); do
> > >>>>>    $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> > >>>>>    $ done
> > >>>>>
> > >>>>> * bpf_redirect may be invoked in egress path. If we don't
> > >>>>>    check the flags and then return immediately, the packets
> > >>>>>    will loopback.
> > >>>>
> > >>>> This would be the naive case right? Meaning the BPF program is
> > >>>> doing a redirect without any logic or is buggy?
> > >>>>
> > >>>> Can you map out how this happens for me, I'm not fully sure I
> > >>>> understand the exact concern. Is it possible for BPF programs
> > >>>> that used to see packets no longer see the packet as expected?
> > >>>>
> > >>>> Is this the path you are talking about?
> > >>> Hi John
> > >>> Tx ethx -> __dev_queue_xmit -> sch_handle_egress
> > >>> ->  execute BPF program on ethx with bpf_redirect(ifb0) ->
> > >>> -> ifb_xmit -> ifb_ri_tasklet -> dev_queue_xmit -> __dev_queue_xmit
> > >>> the packets loopbacks, that means bpf_redirect doesn't work with ifb
> > >>> netdev, right ?
> > >>> so in sch_handle_egress, I add the check skb_skip_tc_classify().
> >
> > But why would you do that? Usage like this is just broken by design..
> > If you need to loop anything back to RX, just use bpf_redirect() with
> > BPF_F_INGRESS? What is the concrete/actual rationale for ifb here?
> Hi
> note that: ifb_ri_tasklet can send out the packets or receive skb
> ifb_ri_tasklet
>                 if (!skb->from_ingress) {
>                         dev_queue_xmit(skb); // bpf_redirect to ifb
> and ifb invoked the dev_queue_xmit in our case.
>                 } else {
>                         skb_pull_rcsum(skb, skb->mac_len);
>                         netif_receive_skb(skb);
>                 }
Hi
In this thread, I try to explain this patch, and answer questions.
What should I do next? v1-v4 is "Changes Requested" in patchwork, but
v5 is "Rejected"
Should I add more commit message in this patch, and send v6 ?
1/3, 3/3 patch still need to be reviewed.

> --
> Best regards, Tonghao



-- 
Best regards, Tonghao

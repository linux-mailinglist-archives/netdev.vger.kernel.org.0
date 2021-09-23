Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A787415538
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 03:49:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238849AbhIWBuo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 21:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbhIWBuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 21:50:44 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B014EC061574;
        Wed, 22 Sep 2021 18:49:13 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id me5-20020a17090b17c500b0019af76b7bb4so5834769pjb.2;
        Wed, 22 Sep 2021 18:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N2D3VyoDcsgE51qq+Pq9H2UU5wjY053D1gpcylBhrL4=;
        b=JnJ4Iq29HqL2qL5IW6KAgedD4bmEXC1Qn5uh13RL+R/0ivZBgBQGGMxbFK3mb/aYEn
         WR0/FPKcAtOCKkM1j+gGzLG48AC/Kak+IQVgMjKdcx2KJHIKUI2GZC8/9p8hNKLUuQLl
         YZZzSqrPS8CsKgx2siUtvVRHIgzqQB5fmuDhcYxbBqd7cL1OBVHWtk4TM60nAJ8+lqKl
         pjk+BXRJhUlQZ6ctWA5Q5tkXsNbNsnH+iUCCcYRp6TxtT84OJUCAxk6JllnVxBrfvLi4
         9RJpMM19TKCUiPP3gFhZtHi5Byn0zG2aFg8SiwSLRbdageYaR7UnuI1AHIwJ/yT5nOnZ
         NpDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N2D3VyoDcsgE51qq+Pq9H2UU5wjY053D1gpcylBhrL4=;
        b=A3C/uGxiQl8RTrJCTzuYw8Emd5ko15ToKBPy95rgVhiMU1/D1TR/iQYH95bq+GX1u4
         OnrxtKRiv5nez4P2i8c++NpkDYwBe5dSNej839GHKmaWxaZkT0BnK2KOh3NaCNtKAhdk
         HE6gUH2uAkOrpij0DoZnc++VoqNyt8LPihejqbw0sohjfC2KbMGj5868bbJkMeNQ/umi
         RZzMy4AlVkxPMS2t/Zd5DsRjut2JMOtpEJ6GDksja+FqJi3om7dt2M+784jfJYwmbLWT
         zZiehyCIsWG+3Tdk/J4PCZL+0yDbdbUnNdv4GXfjuy6qW8B8D167lfeD9tn0wlX4WKMq
         9omw==
X-Gm-Message-State: AOAM530gL+7Io5Sw1dCG6CDrMCimT7DSU8xRL6D22O0PXgwug3ujg1hJ
        DO8zjZTBTRs+ZIe9UdfXSGjIMR4XANnTMJDzgSo=
X-Google-Smtp-Source: ABdhPJwDz1F6yEqtvltKhAOuCqwpoQx9h7Ne+h//61/ZAfCzcTzloOvyxOu+O61d7k5CxEF7yms6nuR9xf+2zuf53y0=
X-Received: by 2002:a17:90b:1c08:: with SMTP id oc8mr2403221pjb.138.1632361753150;
 Wed, 22 Sep 2021 18:49:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210913231108.19762-1-xiyou.wangcong@gmail.com>
 <CAADnVQJFbCmzoFM8GGHyLWULSmX75=67Tu0EnTOOoVfH4gE+HA@mail.gmail.com>
 <CAM_iQpX2prCpPDmO1U0A_wyJi_LS4wmd9MQiFKiqQT8NfGNNnw@mail.gmail.com>
 <CAADnVQJJHLuaymMEdDowharvyJr+6ta2Tg9XAR3aM+4=ysu+bg@mail.gmail.com> <CAM_iQpUCtXRWhMqSaoymZ6OqOywb-k4R1_mLYsLCTm7ABJ5k_A@mail.gmail.com>
In-Reply-To: <CAM_iQpUCtXRWhMqSaoymZ6OqOywb-k4R1_mLYsLCTm7ABJ5k_A@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Sep 2021 18:49:02 -0700
Message-ID: <CAADnVQJcUspoBzk9Tt3Rx_OH7-MB+m1xw+vq2k2SozYZMmpurg@mail.gmail.com>
Subject: Re: [RFC Patch net-next v2] net_sched: introduce eBPF based Qdisc
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 21, 2021 at 9:13 PM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> "This *incomplete* patch introduces a programmable Qdisc with
> eBPF.  The goal is to make this Qdisc as programmable as possible,
> that is, to replace as many existing Qdisc's as we can, no matter
> in tree or out of tree. And we want to make programmer's and researcher's
> life as easy as possible, so that they don't have to write a complete
> Qdisc kernel module just to experiment some queuing theory."

The inspiration was clear and obvious.
Folks in the thread had the same idea long before your patches came out.
But it doesn't matter who came up with an idea to implement qdisc in bpf first.
Everyone in the thread agreed that such a feature would be great to have.
The point people explicitly highlighted is that qdisc is not only about skbs.
The queuing concepts (fq, codel, etc) are useful in xdp and non networking
contexts too.
That's why approaching the goal with more generic ambitions was requested.

> If you compare it with V1, V2 explains the use case in more details,
> which is to target Qdisc writers, not any other. Therefore, the argument
> of making it out of Qdisc is non-sense, anything outside of Qdisc is
> not even my target. Of course you can do anything in XDP, but it has
> absolutely nothing with my goal here: Qdisc.

Applying queuing discipline to non-skb context may be not your target
but it's a reasonable and practical request to have. The kernel is not
about solving one person's itch. The kernel has to be optimized for
all use cases.

>
> I also addressed the skb map concern:
>
> " 2b) Kernel would lose the visibility of the "queues", as maps are only
>    shared between eBPF programs and user-space. These queues still have to
>    interact with the kernel, for example, kernel wants to reset all queues
>    when we reset the network interface, kernel wants to adjust number of
>    queues if they are mapped to hardware queues."
>
> More than writing, I even tried to write a skb map by myself,

Cool and it sounds that you've failed to do so?
At the same time Toke mentioned that he has a prototype of suck skb map.
What addition data can open your mind that skb/packet map is more
universal building block for queuing discipline in different layers?

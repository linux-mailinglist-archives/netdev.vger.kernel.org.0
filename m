Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636354629A2
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 02:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236008AbhK3B2a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 20:28:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbhK3B2a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 20:28:30 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC77C061574
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:25:11 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id z5so14496300edd.3
        for <netdev@vger.kernel.org>; Mon, 29 Nov 2021 17:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zULfVQjws8AsJSrlwPJXHrGsOrz/kxRLLGGWvhA+NXo=;
        b=QfvQ4z2A4Ci+DhALpJaMB4CURmBxivlZ2p9+Bgh5fIxNHx25teEng6hr3S9Y6QrpaK
         nQEd4xZpK6DdNL9cALTPkUaW38ZlPK1tdngNvVpyXV865P4EjtmGA9a7lMl2+jUg2vPJ
         sSgmo5LBPFJmEdl7QdRceQ9mNcU43GcK0pkX6kYZfqfdwyVfNQXGOuQKCgyr8mabTH6B
         RDyU4yYYZQs7oiAHaOsC0MT5FA79G9APUOAabaoeMGREqG1zKG32JP2w3G/v0BIfk/h2
         bDtLIrkNJwBDOc+cYTqbdzGdWM6jiUGdjnFMhT4f0rpa3bJD6NHQeLTe2Pv7NXla26qB
         Lglg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zULfVQjws8AsJSrlwPJXHrGsOrz/kxRLLGGWvhA+NXo=;
        b=mNMW8Fkt/hif5wM9+kYdsgIHAk6pNSKRw/VrJg84w0onCUoOImo6vZfTA28zRV+Up2
         BJ0RhYi84uRUmLbnVvnL3l0tqHej137kQM23Tw5zuXq1G4tEWuAOoRltcVvuSyBvj/8i
         G7ZAQal114/ardNRvH5Ax9uuOFHU1YpPaRnuixWrkSA3C6F70QVgImTlL8cxRFP50Dc3
         3d0upwI0tNrFfXd/L1DmOshpr3SQ9jehhzJWdlyMlFGQLlnL0WiVC8xCKmgDkhcwVL0g
         7H7uF0lRSTFsHCxJ8HzA2ETpIUXGjbS1xZ88F/1EwVHavsX/qi3ZCeOqKSCdZYIs5lmm
         KBUA==
X-Gm-Message-State: AOAM530cXTjnrAlKDccT5Z6aaUI0ey/t+BSKcMmxERHKtCiuXoqoAaEp
        Px1NIT6xRPdfplvuZoW56fuNhAutzbChrDBZKaE=
X-Google-Smtp-Source: ABdhPJy7ZsgtyWrPvfIovSPQTjr0QhUVzpqi1LdNdNKNInsZ0wRQ2QhL8vCBRWwTWAz7rhwrIS3iAfgQxSlgQdXpgw4=
X-Received: by 2002:a05:6402:16cd:: with SMTP id r13mr80051424edx.264.1638235510400;
 Mon, 29 Nov 2021 17:25:10 -0800 (PST)
MIME-Version: 1.0
References: <20211129045503.20217-1-xiangxia.m.yue@gmail.com>
 <20211129045503.20217-2-xiangxia.m.yue@gmail.com> <CANn89i+Pk61q+7gxzhDEDgQBkcOhOLpx80QoiuDM2ceunFkqvg@mail.gmail.com>
In-Reply-To: <CANn89i+Pk61q+7gxzhDEDgQBkcOhOLpx80QoiuDM2ceunFkqvg@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 30 Nov 2021 09:24:34 +0800
Message-ID: <CAMDZJNUbG-Q6HYEE+cVNTvoh6Ps5wQDXbZ=_6cY7m2nqtHn_7g@mail.gmail.com>
Subject: Re: [net v3 2/3] net: sched: add check tc_skip_classify in sch egress
To:     Eric Dumazet <edumazet@google.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Antoine Tenart <atenart@kernel.org>,
        Alexander Lobakin <alexandr.lobakin@intel.com>,
        Wei Wang <weiwan@google.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 1:44 AM Eric Dumazet <edumazet@google.com> wrote:
>
> On Sun, Nov 28, 2021 at 8:55 PM <xiangxia.m.yue@gmail.com> wrote:
> >
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > Try to resolve the issues as below:
> > * We look up and then check tc_skip_classify flag in net
> >   sched layer, even though skb don't want to be classified.
> >   That case may consume a lot of cpu cycles.
> >
> >   Install the rules as below:
> >   $ for id in $(seq 1 100); do
> >   $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> >   $ done
> >
> >   netperf:
> >   $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
> >   $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
> >
> >   Before: 10662.33 tps, 108.95 Mbit/s
> >   After:  12434.48 tps, 145.89 Mbit/s
> >   For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.
>
> These numbers mean nothing, really.
>
> I think you should put 10,000 filters instead of 100 so that the
> numbers look even better ?
This 100 filters with different prio, I will install 10,000 filters
and test again. Thanks.
> As a matter of fact, you add yet another check in fast  path.
>
> For some reason I have not received the cover letter and patch 1/3.
1/3 patch, https://patchwork.kernel.org/project/netdevbpf/patch/20211129045503.20217-1-xiangxia.m.yue@gmail.com/


-- 
Best regards, Tonghao

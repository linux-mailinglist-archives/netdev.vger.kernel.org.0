Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B338464C3A
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 11:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230450AbhLALCZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 06:02:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbhLALCZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 06:02:25 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6748DC061574
        for <netdev@vger.kernel.org>; Wed,  1 Dec 2021 02:59:04 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id y12so99894713eda.12
        for <netdev@vger.kernel.org>; Wed, 01 Dec 2021 02:59:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J4DKnefQ9mvAj25w7T0s4TEqlw2TeJz3nxP0IregaDo=;
        b=egLzOAWBvvExQSOw5cotejq3g+Z2lVK5Dn/ZMFFvmk4fLoHDSHoAJTy8LE16scZ+v7
         sjUW61Ca/UYwbImzsvbLvjgFUQfOqPryUOGLvFi8Qg8ooby/nFa0zrlxvmr+b4i8/fKd
         l39zbK8JD3xTJsZWPtn3TKqoMfeZUR4QJNF7u5O0jhNkEqPjpsgxk09j3m4nNOfL23AP
         ArfeRJziZMshMQZ4L874LGoHt1XHldxSGCPZrSwFHiZ5MEZ0Dx0PqtziaJbi3z7KGxeQ
         4P704veKmAmnmxUDT+WN5QXCLJ5CuHNOFN+VpSlW15y+RCUzPaIdCPa8ZQ9RIIUn0wnW
         k+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J4DKnefQ9mvAj25w7T0s4TEqlw2TeJz3nxP0IregaDo=;
        b=EcGPYOitp89tR/D8Fu78h4D3MEQda22kiTkkrqX5awJfhObX8f8sIMiYAzwZe5mlN4
         iJr6vlt9cynOQ57YEek+X9dQlTUlJuhNfyXwXGSsTW3zr67+9B925Lsio6oIhcU8/5lZ
         JauRmndZ2rM6Uw+lMoqjGSfZc2iPs8YAZzC8xhDlrxwwU2fNdntFoWhGH5UOtzxzvWsL
         QqK3EUIc6SrbDo07gEuSFCFQZ0ljRgpXKrYJN3iHfPs71zlTMOILVMlQ9r+jPbR5wHFg
         97ioqWdToupfHSwKErpHcVbj+1W8P+u0kxct8cO5hUZ2K2PIj1UH6vp0Hx4RGx7HbfJW
         QBTA==
X-Gm-Message-State: AOAM532T4YIDuUuKQe3PKHbTP0ajQascGD/tuyW5yi8QQhZ5HeVZzJ5j
        4azmR/9asZ/e1zuNmIjW1SGH/QIgiKvL9G3GqMA=
X-Google-Smtp-Source: ABdhPJzUoseeQryXhTLhCyGvAAdKyj7avwyh5lYG+484nKox3W+GZe2V0zqihXj6GP3S/PUBOYbp/gP/g6IDPzlZh30=
X-Received: by 2002:a17:906:2c47:: with SMTP id f7mr6381150ejh.94.1638356343024;
 Wed, 01 Dec 2021 02:59:03 -0800 (PST)
MIME-Version: 1.0
References: <20211129045503.20217-1-xiangxia.m.yue@gmail.com>
 <20211129045503.20217-2-xiangxia.m.yue@gmail.com> <CANn89i+Pk61q+7gxzhDEDgQBkcOhOLpx80QoiuDM2ceunFkqvg@mail.gmail.com>
 <CAMDZJNUbG-Q6HYEE+cVNTvoh6Ps5wQDXbZ=_6cY7m2nqtHn_7g@mail.gmail.com>
In-Reply-To: <CAMDZJNUbG-Q6HYEE+cVNTvoh6Ps5wQDXbZ=_6cY7m2nqtHn_7g@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 1 Dec 2021 18:58:27 +0800
Message-ID: <CAMDZJNW9YDV1ojPJ2GP0Zp0GRTTPJjxFbGTWXTrWSswUZGiXYQ@mail.gmail.com>
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

On Tue, Nov 30, 2021 at 9:24 AM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
>
> On Tue, Nov 30, 2021 at 1:44 AM Eric Dumazet <edumazet@google.com> wrote:
> >
> > On Sun, Nov 28, 2021 at 8:55 PM <xiangxia.m.yue@gmail.com> wrote:
> > >
> > > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> > >
> > > Try to resolve the issues as below:
> > > * We look up and then check tc_skip_classify flag in net
> > >   sched layer, even though skb don't want to be classified.
> > >   That case may consume a lot of cpu cycles.
> > >
> > >   Install the rules as below:
> > >   $ for id in $(seq 1 100); do
> > >   $       tc filter add ... egress prio $id ... action mirred egress redirect dev ifb0
> > >   $ done
> > >
> > >   netperf:
> > >   $ taskset -c 1 netperf -t TCP_RR -H ip -- -r 32,32
> > >   $ taskset -c 1 netperf -t TCP_STREAM -H ip -- -m 32
> > >
> > >   Before: 10662.33 tps, 108.95 Mbit/s
> > >   After:  12434.48 tps, 145.89 Mbit/s
> > >   For TCP_RR, there are 16.6% improvement, TCP_STREAM 33.9%.
> >
> > These numbers mean nothing, really.
> >
> > I think you should put 10,000 filters instead of 100 so that the
> > numbers look even better ?
> This 100 filters with different prio, I will install 10,000 filters
> and test again. Thanks.
Hi Eric
I install 10,000 filters with different prio: for example
tc filter add dev enp5s0f0 egress protocol ip prio 10000 flower
skip_hw src_ip 4.4.39.16 action mirred egress redirect dev ifb0

Test test commands:
taskset -c 1 netperf -t TCP_RR -L 4.4.39.16 -H 4.4.200.200 -- -r 32,32
taskset -c 1 netperf -t TCP_STREAM -L 4.4.39.16 -H 4.4.200.200 -- -m 32

Without patch:
152.04 tps
0.58 10^6bits/sec
With patch:
303.07 tps
1.51 10^6bits/sec

> > As a matter of fact, you add yet another check in fast  path.
> >
> > For some reason I have not received the cover letter and patch 1/3.
> 1/3 patch, https://patchwork.kernel.org/project/netdevbpf/patch/20211129045503.20217-1-xiangxia.m.yue@gmail.com/
>
>
> --
> Best regards, Tonghao



-- 
Best regards, Tonghao

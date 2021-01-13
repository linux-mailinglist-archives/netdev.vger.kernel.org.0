Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8876E2F50D3
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 18:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727777AbhAMRQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 12:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbhAMRQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 12:16:12 -0500
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DFEDC061786
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:32 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id d9so5626438iob.6
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 09:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iG5tn1Cp1H1SX7Oz4JztIttuqT2rpmzdP4e1bJ1egZw=;
        b=IsfSocUY2mNt1pZMwug7a5E2OXpGai3WI/nMgxsA7go3zjPysB6IO+sNC+dySGXhGc
         4H6AyB2YiJqCOY0x7RVe7qzU47Qf1r9Ia5zYEd+etR+wVvMHoCJK/l7vC7Jl5zPo1kcp
         pTIJi+KOwtPP2zUbG6jP1Vrp0Kse6CqaEFd3gisJ+izxmTnNHwWmYjD/79o6I87Ffib/
         mIZroSmNeC/WT/FbrEm7WlhoJi3Uuc+GMAEGiOBqgzUSJo9/nct3s6h4Pft/tUd5XoSw
         HRzo5yF2gSALYwd3E/qVEMgniGsvgT3DZbAXyGHJme5Aemc/JTGQypy7bv4ana99XSMr
         s0cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iG5tn1Cp1H1SX7Oz4JztIttuqT2rpmzdP4e1bJ1egZw=;
        b=YhaYiUoRwVgC87J6tC0trSJlyqr5UKWJ33+lC0A6xGf75pJL9T0tf+cVT5CJEKhm1c
         W27YF6GaWp4mqhiZZ+1HTWfWYTnQyGp3dJ3u+al+8FXugCqhDEZ2HHY71GG/TU6yXNDD
         Q7Lveqd0Jfot9imrkvj3UhftbgP4AC5gShHRzgtUz9hE/jlvSrOZl75KTt/pJPPV1ieA
         I86fv6SVeQQdnuuFTgH+UV/TK+YpLke1MPa/vik3e7jlA1cd49X5R+icWMsX2dHUQYwg
         B6vq2ZpLiClCqn0Hi17drBNgmzpkziiedOA3O7P79XHLAbwQnLGvWQy+0iJGtYfKMKW4
         ap/w==
X-Gm-Message-State: AOAM531zeDqdaaWIkGfQddYLoLlRr98psbu8oBczNSVEeA6xVhXVBvKf
        Q4M6UDru15pdWG6hfkWzw2CS/NnF0+ICX4o52GJ5GA==
X-Google-Smtp-Source: ABdhPJylZHEaw237oZ4CbrJCJFg6Ton+1eK+rao9y9y/HYmPh6ZM5UTG7y0KERoN/2ulkm2kAgU9oSEqGH7fnFrXUBA=
X-Received: by 2002:a92:9153:: with SMTP id t80mr3261980ild.216.1610558131599;
 Wed, 13 Jan 2021 09:15:31 -0800 (PST)
MIME-Version: 1.0
References: <20210111182655.12159-1-alobakin@pm.me> <d4f4b6ba-fb3b-d873-23b2-4b5ba9cf4db8@gmail.com>
 <20210112110802.3914-1-alobakin@pm.me> <CANn89iKEc_8_ySqV+KrbheTDKRL4Ws6JUKYeKXfogJNhfd+pGQ@mail.gmail.com>
 <20210112170242.414b8664@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CANn89i+ppTAPYwQ2mH5cZtcMqanFU8hXzD4szdygrjOBewPb+Q@mail.gmail.com> <20210113090341.74832be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210113090341.74832be9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Wed, 13 Jan 2021 18:15:20 +0100
Message-ID: <CANn89iJeJR+i-WLi=VwNSmWQ2aFepmFO8w6Yh9DQX6hvV4BceA@mail.gmail.com>
Subject: Re: [PATCH net-next 0/5] skbuff: introduce skbuff_heads bulking and reusing
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Alexander Lobakin <alobakin@pm.me>,
        Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Edward Cree <ecree@solarflare.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Miaohe Lin <linmiaohe@huawei.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Guillaume Nault <gnault@redhat.com>,
        Yadu Kishore <kyk.segfault@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 13, 2021 at 6:03 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> On Wed, 13 Jan 2021 05:46:05 +0100 Eric Dumazet wrote:
> > On Wed, Jan 13, 2021 at 2:02 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > >
> > > On Tue, 12 Jan 2021 13:23:16 +0100 Eric Dumazet wrote:
> > > > On Tue, Jan 12, 2021 at 12:08 PM Alexander Lobakin <alobakin@pm.me> wrote:
> > > > >
> > > > > From: Edward Cree <ecree.xilinx@gmail.com>
> > > > > Date: Tue, 12 Jan 2021 09:54:04 +0000
> > > > >
> > > > > > Without wishing to weigh in on whether this caching is a good idea...
> > > > >
> > > > > Well, we already have a cache to bulk flush "consumed" skbs, although
> > > > > kmem_cache_free() is generally lighter than kmem_cache_alloc(), and
> > > > > a page frag cache to allocate skb->head that is also bulking the
> > > > > operations, since it contains a (compound) page with the size of
> > > > > min(SZ_32K, PAGE_SIZE).
> > > > > If they wouldn't give any visible boosts, I think they wouldn't hit
> > > > > mainline.
> > > > >
> > > > > > Wouldn't it be simpler, rather than having two separate "alloc" and "flush"
> > > > > >  caches, to have a single larger cache, such that whenever it becomes full
> > > > > >  we bulk flush the top half, and when it's empty we bulk alloc the bottom
> > > > > >  half?  That should mean fewer branches, fewer instructions etc. than
> > > > > >  having to decide which cache to act upon every time.
> > > > >
> > > > > I though about a unified cache, but couldn't decide whether to flush
> > > > > or to allocate heads and how much to process. Your suggestion answers
> > > > > these questions and generally seems great. I'll try that one, thanks!
> > > >
> > > > The thing is : kmalloc() is supposed to have batches already, and nice
> > > > per-cpu caches.
> > > >
> > > > This looks like an mm issue, are we sure we want to get over it ?
> > > >
> > > > I would like a full analysis of why SLAB/SLUB does not work well for
> > > > your test workload.
> > >
> > > +1, it does feel like we're getting into mm territory
> >
> > I read the existing code, and with Edward Cree idea of reusing the
> > existing cache (storage of pointers),
> > ths now all makes sense, since there will be not much added code (and
> > new storage of 64 pointers)
> >
> > The remaining issue is to make sure KASAN will still work, we need
> > this to detect old and new bugs.
>
> IDK much about MM, but we already have a kmem_cache for skbs and now
> we're building a cache on top of a cache.  Shouldn't MM take care of
> providing a per-CPU BH-only lockless cache?

I think part of the improvement comes from bulk operations, which are
provided by mm layer.

I also note Alexander made no provision for NUMA awareness.
Probably reusing skb located on a remote node will not be ideal.

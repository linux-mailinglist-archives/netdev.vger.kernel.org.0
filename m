Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78FA34F888C
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 22:33:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiDGUeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 16:34:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiDGUd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 16:33:57 -0400
Received: from mail-yw1-x1133.google.com (mail-yw1-x1133.google.com [IPv6:2607:f8b0:4864:20::1133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E2631E1C6
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 13:19:44 -0700 (PDT)
Received: by mail-yw1-x1133.google.com with SMTP id 00721157ae682-2eb680211d9so74480827b3.9
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 13:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s8nZp0I+IEtLPPy2zze757XPaBi8wlS/S/3C8QHqd2A=;
        b=R6vuhl9d/QzjZ2AYWI+36TA5CsQg0rwn58W2K6eojzPgfOeh/jZ1npqzFA7ys4nNBM
         a6msAStjDW56lUXzwDENLpxRGZ10WZ+UqCdoVShKypDhP5tt6ZY4eNk/f7v0JvKIL0cM
         2ohHo0Udt6m6lz9jVLMBJGOjcctc7Cc+HDOsieZVEJSF/3aBT0n7k7tygX7UiEg3tWpB
         annY4bubDAFA8ChMhmrSW1LP2dsy+pqroeHZjiehUFYbNpCSoFjoBXleepdwnHoGK1QB
         Xk2Sgw8PNMLM8kKgA5LSDOTDJmqBGOAgJsG8jW+HcriC+v/o19VPy6IOeirfCDZpoGH4
         1tMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s8nZp0I+IEtLPPy2zze757XPaBi8wlS/S/3C8QHqd2A=;
        b=himhiwLyPKPxh14mgcU0r+Rl9pgEV+FlOOB+v7Fh1f7pa2jLyHY+B+r5G1eKEUK7cS
         v+c1nlztK5gPs95gdXqr4BU0NM+jBsZy8M7Uj5Kh2/QKicVI9H3hLz7zLd+mjl4LRqI4
         ZHrW9tVopjrHMJFuP7NB739XyHxOqhBJHuCrXy+OAiRUwSTT51+K8Z0UIiIcpo1BT/jY
         d9Jyyx181rtlSB54ivM7EPbPnkS5bjIvIxESUdG/OlF7edZsw4sduGTXp3qtgeNqk5u3
         AiWc/y+CGoN/NfLB/b7SN1ON4pLOpZ1esJPDNMzlB4bI9UDrs3p4Vb4aHD4s5eI/1BxV
         lt1Q==
X-Gm-Message-State: AOAM532gTS/G1dJVZnlJx+FAcVClnwXVhWLvdl83KzwT6WTnpnsj1JZ5
        YEMwFfk8agTwh69kVgu90zrswIofhkbAs0i4B5frEcx8KXemPw==
X-Google-Smtp-Source: ABdhPJwOnKC7qUhgJgMyAE6ZRt4mvTn7hKTo9c4t5KyTkpQ5pPK8O7LG2HJtPqzoyFH2bdBF2GO7FVr5BeRs6w1ULhk=
X-Received: by 2002:a81:ff05:0:b0:2d6:8e83:e723 with SMTP id
 k5-20020a81ff05000000b002d68e83e723mr13507467ywn.382.1649362783806; Thu, 07
 Apr 2022 13:19:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649350165.git.lorenzo@kernel.org> <cd1bb62e5efe9d151fe96a5224add25122f5044a.1649350165.git.lorenzo@kernel.org>
 <Yk8sqA8sxutE+HRO@lunn.ch> <CAC_iWjKttCb-oDk27vb_Ar58qLN8vY_1cFbGtLB+YUMXtTX8nw@mail.gmail.com>
 <Yk86vuqcCOZVxgOe@lunn.ch>
In-Reply-To: <Yk86vuqcCOZVxgOe@lunn.ch>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Thu, 7 Apr 2022 23:19:08 +0300
Message-ID: <CAC_iWjJv2uSHXmHkCvA+0Cbx=NT=jBi48vaow9xLgz4FmrF_wA@mail.gmail.com>
Subject: Re: [RFC net-next 2/2] net: mvneta: add support for page_pool_get_stats
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, thomas.petazzoni@bootlin.com,
        jbrouer@redhat.com, jdamato@fastly.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

[...]

> > > > +
> > > > +             stats.alloc_stats.fast += pp_stats.alloc_stats.fast;
> > > > +             stats.alloc_stats.slow += pp_stats.alloc_stats.slow;
> > > > +             stats.alloc_stats.slow_high_order +=
> > > > +                     pp_stats.alloc_stats.slow_high_order;
> > > > +             stats.alloc_stats.empty += pp_stats.alloc_stats.empty;
> > > > +             stats.alloc_stats.refill += pp_stats.alloc_stats.refill;
> > > > +             stats.alloc_stats.waive += pp_stats.alloc_stats.waive;
> > > > +             stats.recycle_stats.cached += pp_stats.recycle_stats.cached;
> > > > +             stats.recycle_stats.cache_full +=
> > > > +                     pp_stats.recycle_stats.cache_full;
> > > > +             stats.recycle_stats.ring += pp_stats.recycle_stats.ring;
> > > > +             stats.recycle_stats.ring_full +=
> > > > +                     pp_stats.recycle_stats.ring_full;
> > > > +             stats.recycle_stats.released_refcnt +=
> > > > +                     pp_stats.recycle_stats.released_refcnt;
> > >
> > > We should be trying to remove this sort of code from the driver, and
> > > put it all in the core.  It wants to be something more like:
> > >
> > >         struct page_pool_stats stats = {};
> > >         int i;
> > >
> > >         for (i = 0; i < rxq_number; i++) {
> > >                 struct page_pool *page_pool = pp->rxqs[i].page_pool;
> > >
> > >                 if (!page_pool_get_stats(page_pool, &stats))
> > >                         continue;
> > >
> > >         page_pool_ethtool_stats_get(data, &stats);
> > >
> > > Let page_pool_get_stats() do the accumulate as it puts values in stats.
> >
> > Unless I misunderstand this, I don't think that's doable in page pool.
> > That means page pool is aware of what stats to accumulate per driver
> > and I certainly don't want anything driver specific to creep in there.
> > The driver knows the number of pools he is using and he can gather
> > them all together.
>
> I agree that the driver knows about the number of pools. For mvneta,
> there is one per RX queue. Which is this part of my suggestion
>
> > >         for (i = 0; i < rxq_number; i++) {
> > >                 struct page_pool *page_pool = pp->rxqs[i].page_pool;
> > >
>
> However, it has no idea about the stats themselves. They are purely a
> construct of the page pool. Hence the next part of my suggest, ask the
> page pool for the stats, place them into stats, doing the accumulate
> at the same time.:
>
> > >                 if (!page_pool_get_stats(page_pool, &stats))
> > >                         continue;
>
> and now we have the accumulated stats, turn them into ethtool format:
>
> > >         page_pool_ethtool_stats_get(data, &stats);
>
> Where do you see any driver knowledge required in either of
> page_pool_get_stats() or page_pool_ethtool_stats_get().

Indeed I read the first mail wrong. I thought you wanted page_pool it
self to account for the driver stats without passing a 'struct
page_pool *pool' to page_pool_get_stats(). In a system with XDP (which
also uses page_pool) or multiple drivers using that, it would require
some metadata fed into the page pool subsystem to reason about which
pools to accumulate.

The code snip you included seems fine.

Thanks
/Ilias

>
>       Andrew

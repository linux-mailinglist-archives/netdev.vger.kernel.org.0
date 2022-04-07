Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09DF44F8725
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 20:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344110AbiDGSid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 14:38:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346883AbiDGSia (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 14:38:30 -0400
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71F71C60F0
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 11:36:28 -0700 (PDT)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-2eb680211d9so71702567b3.9
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 11:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KWoLiEmwGXS8u1aBX50tyvllEFZL88qS3E2bXTdaTwE=;
        b=DdaM0i3C/xiDl5f7w5OI76+tq1tch4KOV2dXXvghUPQ6mUhnlBK4I3OROJjtcitdtd
         V3xjOJtkmxbETZsW18Q7s0mzLDpfufo6goKTYtv8YZXMeq+NYs12/emrTIOOpylyM3KT
         BoU1ZEvX9aWz/wp3gxT5eJjeQ++TQigKBUAvRDaNp5HKkHXNsxWhTMtcmbFmtzqTPyPt
         gDAthLn9V4oxGOyMRon+XhSSiyCBmxcVpxOfN3M6GfuECRac8VJHWD8ZZ9QxQl6lai5B
         b8siaPMO1fPUG1dlaREBRDLx+63sjhI6xeTBDoIWq82BuCXrbLa80FEYjLOayZUs3hdB
         nEVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KWoLiEmwGXS8u1aBX50tyvllEFZL88qS3E2bXTdaTwE=;
        b=o68R7h4a+M2TBDyFdw2HeGyn8/H5krnH3BYs65WuKk1xKuNOTp0ZwXyMXag5GAHuoc
         M82rtmrDFrVIq5vUWuPQmYteRHzQVXuV03lu4P51qzrcn+e5UnxLXG+A2KL/3lDE6JHK
         XkKxnoPfTwPWbvO3gZZ2Bb8FHKM3mBeuUyLuB4ZuUbFmEhxMKSnsGlu4oFEmE4xclj7H
         Mrleye47H2DQpgjMcgj7deYMt4OPfsIg+gQQzT10X8RnNa47lL8Y3tuw1bR71AjfPqcw
         PiB5A6xSnlgQlRmN1WxtH3XCl0kaI4j8pnFmXj6xsrf22a1urSB0I/p1JYYGcHTXjU/4
         aNqQ==
X-Gm-Message-State: AOAM533PuRfu7ft48O6Vabxx94hPEQdubOoHjsDy5BFCugwGDKXj3zd6
        YZABFoxqwKKtcVmgfysJO7IVxVuwWHNOQK6Om9Cvqw==
X-Google-Smtp-Source: ABdhPJyLrBFUiBDLpvYi317VsxYmF5oPc0BzeVGusLuuqNpzNXc9UpmLk4cK1CbfCIvtxFSoMwNXwrJS82vey8EZi6E=
X-Received: by 2002:a05:690c:81:b0:2e1:b8cf:5ea9 with SMTP id
 be1-20020a05690c008100b002e1b8cf5ea9mr14101032ywb.191.1649356588045; Thu, 07
 Apr 2022 11:36:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1649350165.git.lorenzo@kernel.org> <cd1bb62e5efe9d151fe96a5224add25122f5044a.1649350165.git.lorenzo@kernel.org>
 <Yk8sqA8sxutE+HRO@lunn.ch>
In-Reply-To: <Yk8sqA8sxutE+HRO@lunn.ch>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Thu, 7 Apr 2022 21:35:52 +0300
Message-ID: <CAC_iWjKttCb-oDk27vb_Ar58qLN8vY_1cFbGtLB+YUMXtTX8nw@mail.gmail.com>
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

On Thu, 7 Apr 2022 at 21:25, Andrew Lunn <andrew@lunn.ch> wrote:
>
> > +static void mvneta_ethtool_pp_stats(struct mvneta_port *pp, u64 *data)
> > +{
> > +     struct page_pool_stats stats = {};
> > +     int i;
> > +
> > +     for (i = 0; i < rxq_number; i++) {
> > +             struct page_pool *page_pool = pp->rxqs[i].page_pool;
> > +             struct page_pool_stats pp_stats = {};
> > +
> > +             if (!page_pool_get_stats(page_pool, &pp_stats))
> > +                     continue;
> > +
> > +             stats.alloc_stats.fast += pp_stats.alloc_stats.fast;
> > +             stats.alloc_stats.slow += pp_stats.alloc_stats.slow;
> > +             stats.alloc_stats.slow_high_order +=
> > +                     pp_stats.alloc_stats.slow_high_order;
> > +             stats.alloc_stats.empty += pp_stats.alloc_stats.empty;
> > +             stats.alloc_stats.refill += pp_stats.alloc_stats.refill;
> > +             stats.alloc_stats.waive += pp_stats.alloc_stats.waive;
> > +             stats.recycle_stats.cached += pp_stats.recycle_stats.cached;
> > +             stats.recycle_stats.cache_full +=
> > +                     pp_stats.recycle_stats.cache_full;
> > +             stats.recycle_stats.ring += pp_stats.recycle_stats.ring;
> > +             stats.recycle_stats.ring_full +=
> > +                     pp_stats.recycle_stats.ring_full;
> > +             stats.recycle_stats.released_refcnt +=
> > +                     pp_stats.recycle_stats.released_refcnt;
>
> We should be trying to remove this sort of code from the driver, and
> put it all in the core.  It wants to be something more like:
>
>         struct page_pool_stats stats = {};
>         int i;
>
>         for (i = 0; i < rxq_number; i++) {
>                 struct page_pool *page_pool = pp->rxqs[i].page_pool;
>
>                 if (!page_pool_get_stats(page_pool, &stats))
>                         continue;
>
>         page_pool_ethtool_stats_get(data, &stats);
>
> Let page_pool_get_stats() do the accumulate as it puts values in stats.

Unless I misunderstand this, I don't think that's doable in page pool.
That means page pool is aware of what stats to accumulate per driver
and I certainly don't want anything driver specific to creep in there.
The driver knows the number of pools he is using and he can gather
them all together.

Regards
/Ilias
>
> You probably should also rework the mellanox driver to use the same
> code structure.
>
>     Andrew
>
>

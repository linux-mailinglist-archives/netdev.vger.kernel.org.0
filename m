Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0C04FA6C4
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 12:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237381AbiDIKZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 06:25:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233317AbiDIKZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 06:25:39 -0400
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D861EE096
        for <netdev@vger.kernel.org>; Sat,  9 Apr 2022 03:23:31 -0700 (PDT)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2eb680211d9so119775827b3.9
        for <netdev@vger.kernel.org>; Sat, 09 Apr 2022 03:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GmdTmlJZIIZuys2mm8muzRQwHtWKMe35edtFcAAvtEo=;
        b=lp3dcneMfhvbCJbA3r1XGwZ5zIepqdf4axyZ8GSTqFGnrRbdrOZp+zkIpRXlMvaPaQ
         2idu2YAE6GDhnQ2aK89HtmpvJEpcPFhXqhR57pEvvQs0xXUWC3Cy9HmoHwhqz0eCHjan
         81tq8nzc7h6iie91i/+jLfBa8Tmd3eO61/zJkeQPI7qtMJpLQptCsjw62b4ggZOE3ZFh
         OksjlVsNlWcBZfSqfrt/kZiWAMwF1lZqhbff8U4owgrfns8l2er+Ra/FlXEw5akjJy9X
         3IayUMq5il+q77QA158n3k9/6ZP6RRZgL1pTfg4YkI4i2igVJczI3CGyHbbSubjCC32L
         pjJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GmdTmlJZIIZuys2mm8muzRQwHtWKMe35edtFcAAvtEo=;
        b=sKPOtJpr09AVN21KIBuuL401L3ClH06R23t8uWh+ATaewMbUpJHF/AH3ctqSu3a1b6
         2PFd0PtTYm3WSeZWj2t0ucBEULXq/cuoOAjbbDg5St6eaiJWFADpqdKWapkqCFAqFxRn
         xokJkgmOiQy7+zamB+Wim84Mc5shmrzan1mn538kz37ljuUg5evvNBQbuN+38jD1wYGG
         qWxxW9uz80bl5NX466S05cYu1jlq9QUIcB6UDAcNK9hT8gAOSp4iARhpHLEsv6eVqCeA
         3llaESHIYks8fOhfCBSwpgVo8Sxo5lReRFQGmmgwOCgJVWttCupDEF8DJhpn2aqjiezH
         /BSw==
X-Gm-Message-State: AOAM531vDKSdJhcn7RSAi5mUtd2JWmDOLAdZvEvG3lQ9Z7yRDZCrrKnR
        H0oLx784NDIWHD6VC3vLv6rdhlRljSWreT1ko4O7Lw==
X-Google-Smtp-Source: ABdhPJyRoN/h2tYWnxJbsjloJdbyS3plqL78XRLqUvswE1GOO5Y9e1osWOLWeD7uoZUbuNsp6CeIV3l8BUCl6S+DvNU=
X-Received: by 2002:a05:690c:81:b0:2e1:b8cf:5ea9 with SMTP id
 be1-20020a05690c008100b002e1b8cf5ea9mr21015671ywb.191.1649499810742; Sat, 09
 Apr 2022 03:23:30 -0700 (PDT)
MIME-Version: 1.0
References: <1921137145a6a20bb3494c72b33268f5d6d86834.1649191881.git.lorenzo@kernel.org>
 <20220406231512.GB96269@fastly.com> <CAC_iWjJdPvhd5Py5vWqWtbf16eJZfg_NWU=BBM90302mSZA=sQ@mail.gmail.com>
 <20220409052223.GA101563@fastly.com>
In-Reply-To: <20220409052223.GA101563@fastly.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Sat, 9 Apr 2022 13:22:54 +0300
Message-ID: <CAC_iWjJObky2yh_hY3P_5egLLb3oJioozPTrwu_tox8zmZNqfA@mail.gmail.com>
Subject: Re: [PATCH net-next] page_pool: Add recycle stats to page_pool_put_page_bulk
To:     Joe Damato <jdamato@fastly.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jbrouer@redhat.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joe,

On Sat, 9 Apr 2022 at 08:22, Joe Damato <jdamato@fastly.com> wrote:
>
> On Thu, Apr 07, 2022 at 11:14:15PM +0300, Ilias Apalodimas wrote:
> > Hi Joe,
> >
> > On Thu, 7 Apr 2022 at 02:15, Joe Damato <jdamato@fastly.com> wrote:
> > >
> > > On Tue, Apr 05, 2022 at 10:52:55PM +0200, Lorenzo Bianconi wrote:
> > > > Add missing recycle stats to page_pool_put_page_bulk routine.
> > >
> > > Thanks for proposing this change. I did miss this path when adding
> > > stats.
> > >
> > > I'm sort of torn on this. It almost seems that we might want to track
> > > bulking events separately as their own stat.
> > >
> > > Maybe Ilias has an opinion on this; I did implement the stats, but I'm not
> > > a maintainer of the page_pool so I'm not sure what I think matters all
> > > that much ;)
> >
> > It does.  In fact I think people that actually use the stats for
> > something have a better understanding on what's useful and what's not.
> > OTOH page_pool_put_page_bulk() is used on the XDP path for now but it
> > ends up returning pages on a for loop.  So personally I think we are
> > fine without it. The page will be either returned to the ptr_ring
> > cache or be free'd and we account for both of those.
> >
> > However looking at the code I noticed another issue.
> > __page_pool_alloc_pages_slow() increments the 'slow' stat by one. But
> > we are not only allocating a single page in there we allocate nr_pages
> > and we feed all of them but one to the cache.  So imho here we should
> > bump the slow counter appropriately.  The next allocations will
> > probably be served from the cache and they will get their own proper
> > counters.
>
> After thinking about this a bit more... I'm not sure.
>
> __page_pool_alloc_pages_slow increments slow by 1 because that one page is
> returned to the user via the slow path. The side-effect of landing in the
> slow path is that nr_pages-1 pages will be fed into the cache... but not
> necessarily allocated to the driver.

Well they are in the cache *because* we allocated the from the slow path.

>
> As you mention, follow up allocations will count them properly as fast path
> allocations.
>
> It might be OK as it is. If we add nr_pages to the number of slow allocs
> (even though they were never actually allocated as far as the user is
> concerned), it may be a bit confusing -- essentially double counting those
> allocations as both slow and fast.

Those allocations didn't magically appear in the fast cache.  (At
least) Once in the lifetime of the driver you allocated some packets.
Shouldn't that be reflected into the stats?  The recycled stats
packets basically means "How many of the original slow path allocated
packets did I manage to feed from my cache" isn't it ?

>
> So, I think Lorenzo's original patch is correct as is and my comment on it
> about __page_pool_alloc_pages_slow was wrong.

Me too, I think we need Lorenzo's additions regardless.

Thanks
/Ilias
>
> > >
> > > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > > ---
> > > >  net/core/page_pool.c | 15 +++++++++++++--
> > > >  1 file changed, 13 insertions(+), 2 deletions(-)
> > > >
> > > > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > > > index 1943c0f0307d..4af55d28ffa3 100644
> > > > --- a/net/core/page_pool.c
> > > > +++ b/net/core/page_pool.c
> > > > @@ -36,6 +36,12 @@
> > > >               this_cpu_inc(s->__stat);                                                \
> > > >       } while (0)
> > > >
> > > > +#define recycle_stat_add(pool, __stat, val)                                          \
> > > > +     do {                                                                            \
> > > > +             struct page_pool_recycle_stats __percpu *s = pool->recycle_stats;       \
> > > > +             this_cpu_add(s->__stat, val);                                           \
> > > > +     } while (0)
> > > > +
> > > >  bool page_pool_get_stats(struct page_pool *pool,
> > > >                        struct page_pool_stats *stats)
> > > >  {
> > > > @@ -63,6 +69,7 @@ EXPORT_SYMBOL(page_pool_get_stats);
> > > >  #else
> > > >  #define alloc_stat_inc(pool, __stat)
> > > >  #define recycle_stat_inc(pool, __stat)
> > > > +#define recycle_stat_add(pool, __stat, val)
> > > >  #endif
> > > >
> > > >  static int page_pool_init(struct page_pool *pool,
> > > > @@ -566,9 +573,13 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > > >       /* Bulk producer into ptr_ring page_pool cache */
> > > >       page_pool_ring_lock(pool);
> > > >       for (i = 0; i < bulk_len; i++) {
> > > > -             if (__ptr_ring_produce(&pool->ring, data[i]))
> > > > -                     break; /* ring full */
> > > > +             if (__ptr_ring_produce(&pool->ring, data[i])) {
> > > > +                     /* ring full */
> > > > +                     recycle_stat_inc(pool, ring_full);
> > > > +                     break;
> > > > +             }
> > > >       }
> > > > +     recycle_stat_add(pool, ring, i);
> > >
> > > If we do go with this approach (instead of adding bulking-specific stats),
> > > we might want to replicate this change in __page_pool_alloc_pages_slow; we
> > > currently only count the single allocation returned by the slow path, but
> > > the rest of the pages which refilled the cache are not counted.
> >
> > Ah yes we are saying the same thing here
> >
> > Thanks
> > /Ilias
> > >
> > > >       page_pool_ring_unlock(pool);
> > > >
> > > >       /* Hopefully all pages was return into ptr_ring */
> > > > --
> > > > 2.35.1
> > > >

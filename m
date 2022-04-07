Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588884F8864
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 22:33:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbiDGUa4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 16:30:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbiDGUaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 16:30:30 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB2D248AB2F
        for <netdev@vger.kernel.org>; Thu,  7 Apr 2022 13:14:52 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id l14so11561285ybe.4
        for <netdev@vger.kernel.org>; Thu, 07 Apr 2022 13:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pYmk/ua1gRBXpeyoRsy55XdotLekwMo4KNCdQ+myqQk=;
        b=MAvoWavex/kBvH3IhMnmakJDNwfuqzOuk5CWB9PenotWms55UN11lfW+SKQFsKVaBA
         Sh891+h0Gx38+4853LSedUjp4IvPm5/Fy5DiLn0ra9jXHpF8KmPdsutfhGWUTErCqE91
         jXQhqhgWRbsP9wru72usnpaDMDdO8NPmeshpx8UGh2NuLF6wl4MeR6HioKsGYM0fgKeB
         1vIN9EEEwsiOv3oeVbVOCcjYjiGw2qEZwmSVRsXjYXUSNjyBerVoiEXQQWwwxmTQ04SD
         n5K6EfJg614dwfcssfzg15+qprdhJr60QHk04wvs5zUkZRo5WmlWuOAE2TRE9GpXNhI7
         kdaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pYmk/ua1gRBXpeyoRsy55XdotLekwMo4KNCdQ+myqQk=;
        b=S5Y0oDCo85dAGYazqFMD+DyHQvz84qlFgCguPSn6aDAUQim56NmIYsw2DuUjMevUyH
         Q+x0lDJMORrtUQSKCU2foGJD60GNNb185L3C4NubsTelc5ySGEJMxjR4zonwPaOkIIYa
         FZyiq+9qqCMLfUvJ+8ZsHSrzege40uuXdvS8y76L0R0nMeSwaglrJQreoqLrc/pIHWlk
         0eotmclHB5lZEtUn89fIaaf0sYf21M5DJQLFXjAMUvQcIBpFIX8zD/GQh1x9nJN+TKmR
         gnqoRlzxP0rFVqbXnkgvOK0e7jojxtE/jpdn3nhJsDdXAjswcgriCEuT9ijuGP0+Shhe
         PaKQ==
X-Gm-Message-State: AOAM533IOvYEWsksOeoCGtMP3mmXgkUVX9uDlEEdEDZPLcTyiT4esVET
        4MycYy4DrhkKVjOmAHlaI5nnOMSrDiIFrd3aTogc/g==
X-Google-Smtp-Source: ABdhPJzpHg4HGq4gzsI8u1LVdka5Ywt0xyQYMNve0+yc+36hYcoCCFp3JtKUtYL49z/GeqXDoLt6fb2PP/dm3h3XfMg=
X-Received: by 2002:a25:7bc2:0:b0:634:6678:b034 with SMTP id
 w185-20020a257bc2000000b006346678b034mr11521097ybc.495.1649362491820; Thu, 07
 Apr 2022 13:14:51 -0700 (PDT)
MIME-Version: 1.0
References: <1921137145a6a20bb3494c72b33268f5d6d86834.1649191881.git.lorenzo@kernel.org>
 <20220406231512.GB96269@fastly.com>
In-Reply-To: <20220406231512.GB96269@fastly.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Thu, 7 Apr 2022 23:14:15 +0300
Message-ID: <CAC_iWjJdPvhd5Py5vWqWtbf16eJZfg_NWU=BBM90302mSZA=sQ@mail.gmail.com>
Subject: Re: [PATCH net-next] page_pool: Add recycle stats to page_pool_put_page_bulk
To:     Joe Damato <jdamato@fastly.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jbrouer@redhat.com
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

Hi Joe,

On Thu, 7 Apr 2022 at 02:15, Joe Damato <jdamato@fastly.com> wrote:
>
> On Tue, Apr 05, 2022 at 10:52:55PM +0200, Lorenzo Bianconi wrote:
> > Add missing recycle stats to page_pool_put_page_bulk routine.
>
> Thanks for proposing this change. I did miss this path when adding
> stats.
>
> I'm sort of torn on this. It almost seems that we might want to track
> bulking events separately as their own stat.
>
> Maybe Ilias has an opinion on this; I did implement the stats, but I'm not
> a maintainer of the page_pool so I'm not sure what I think matters all
> that much ;)

It does.  In fact I think people that actually use the stats for
something have a better understanding on what's useful and what's not.
OTOH page_pool_put_page_bulk() is used on the XDP path for now but it
ends up returning pages on a for loop.  So personally I think we are
fine without it. The page will be either returned to the ptr_ring
cache or be free'd and we account for both of those.

However looking at the code I noticed another issue.
__page_pool_alloc_pages_slow() increments the 'slow' stat by one. But
we are not only allocating a single page in there we allocate nr_pages
and we feed all of them but one to the cache.  So imho here we should
bump the slow counter appropriately.  The next allocations will
probably be served from the cache and they will get their own proper
counters.

>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  net/core/page_pool.c | 15 +++++++++++++--
> >  1 file changed, 13 insertions(+), 2 deletions(-)
> >
> > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > index 1943c0f0307d..4af55d28ffa3 100644
> > --- a/net/core/page_pool.c
> > +++ b/net/core/page_pool.c
> > @@ -36,6 +36,12 @@
> >               this_cpu_inc(s->__stat);                                                \
> >       } while (0)
> >
> > +#define recycle_stat_add(pool, __stat, val)                                          \
> > +     do {                                                                            \
> > +             struct page_pool_recycle_stats __percpu *s = pool->recycle_stats;       \
> > +             this_cpu_add(s->__stat, val);                                           \
> > +     } while (0)
> > +
> >  bool page_pool_get_stats(struct page_pool *pool,
> >                        struct page_pool_stats *stats)
> >  {
> > @@ -63,6 +69,7 @@ EXPORT_SYMBOL(page_pool_get_stats);
> >  #else
> >  #define alloc_stat_inc(pool, __stat)
> >  #define recycle_stat_inc(pool, __stat)
> > +#define recycle_stat_add(pool, __stat, val)
> >  #endif
> >
> >  static int page_pool_init(struct page_pool *pool,
> > @@ -566,9 +573,13 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> >       /* Bulk producer into ptr_ring page_pool cache */
> >       page_pool_ring_lock(pool);
> >       for (i = 0; i < bulk_len; i++) {
> > -             if (__ptr_ring_produce(&pool->ring, data[i]))
> > -                     break; /* ring full */
> > +             if (__ptr_ring_produce(&pool->ring, data[i])) {
> > +                     /* ring full */
> > +                     recycle_stat_inc(pool, ring_full);
> > +                     break;
> > +             }
> >       }
> > +     recycle_stat_add(pool, ring, i);
>
> If we do go with this approach (instead of adding bulking-specific stats),
> we might want to replicate this change in __page_pool_alloc_pages_slow; we
> currently only count the single allocation returned by the slow path, but
> the rest of the pages which refilled the cache are not counted.

Ah yes we are saying the same thing here

Thanks
/Ilias
>
> >       page_pool_ring_unlock(pool);
> >
> >       /* Hopefully all pages was return into ptr_ring */
> > --
> > 2.35.1
> >

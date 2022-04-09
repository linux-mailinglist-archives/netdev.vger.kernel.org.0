Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC1F4FA519
	for <lists+netdev@lfdr.de>; Sat,  9 Apr 2022 07:26:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239208AbiDIFYi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Apr 2022 01:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239164AbiDIFYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Apr 2022 01:24:34 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F37B328991
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 22:22:27 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id t6so3296203plg.7
        for <netdev@vger.kernel.org>; Fri, 08 Apr 2022 22:22:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fastly.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eYUl1dDbTizQboDLT/oVAvk0+MpDAmq28wFQukqtnQs=;
        b=avKBQn0GhBO6lezacXFNja3bXJTYRB/xaPy/QdqIQMwOmHBOqA4URt1E0Fv/IHtyBm
         J1bmazvv89ZIQbuHn6HMEE4RzR5gqGVTQvNOQTSgrqQb0BlSEZLD6E2B+RkojwqgFYNa
         XSAk6Oam7uAJ92onIaLJGI8j1KnsjbCe1JjeU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=eYUl1dDbTizQboDLT/oVAvk0+MpDAmq28wFQukqtnQs=;
        b=7VmGo4tiHRWZ4uD1sLvWlep9HNaJQvabEG7uA1Y2ZI27oEaKhLJlVJh6FfXSg++j40
         OhjXY2YJPxwDm4jV7bw/NmOs0dQtO1c1Sx/3mCacLc5G6VXn3Rapbt/162RLZZ/iZmfY
         8ssQUAdiH+X2RM65AxUaRhYE6RSx7vePYmeBSMw0r76VB9XXemDEp/ynYAYasHJN+qSS
         i6tutuZjIsMUXBYyho1VVJaaG0xQsCZgWErqAzPpAItb9FL4UI16XfuHJxe+OwnhVkdp
         LeVyPX8Y2Rb2MfeWF4R83gyzhUtifwP7JvEWIm8iUAqSOrKSvQJOUegYgvygzXa8bZRQ
         YJCA==
X-Gm-Message-State: AOAM531vCXBvuIMxrRhHpLBMrhWkEDnjMYlaY642IlFG7vXXFO+wBFG1
        SdAgr7XzDVRONNr9M3O5YCNnqCnn/nBfNw==
X-Google-Smtp-Source: ABdhPJwGv81erJIxlpp1zx29zpnAwXMutNASekj+nuwNQHIBRbo2JfW5E//JFK3ySJ9m6VIgb2zryA==
X-Received: by 2002:a17:90a:448d:b0:1ca:1ff6:da22 with SMTP id t13-20020a17090a448d00b001ca1ff6da22mr25961761pjg.12.1649481747201;
        Fri, 08 Apr 2022 22:22:27 -0700 (PDT)
Received: from fastly.com (c-73-223-190-181.hsd1.ca.comcast.net. [73.223.190.181])
        by smtp.gmail.com with ESMTPSA id d5-20020a056a0024c500b004fae56b2921sm27699657pfv.167.2022.04.08.22.22.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Apr 2022 22:22:26 -0700 (PDT)
Date:   Fri, 8 Apr 2022 22:22:24 -0700
From:   Joe Damato <jdamato@fastly.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jbrouer@redhat.com
Subject: Re: [PATCH net-next] page_pool: Add recycle stats to
 page_pool_put_page_bulk
Message-ID: <20220409052223.GA101563@fastly.com>
References: <1921137145a6a20bb3494c72b33268f5d6d86834.1649191881.git.lorenzo@kernel.org>
 <20220406231512.GB96269@fastly.com>
 <CAC_iWjJdPvhd5Py5vWqWtbf16eJZfg_NWU=BBM90302mSZA=sQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC_iWjJdPvhd5Py5vWqWtbf16eJZfg_NWU=BBM90302mSZA=sQ@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 07, 2022 at 11:14:15PM +0300, Ilias Apalodimas wrote:
> Hi Joe,
> 
> On Thu, 7 Apr 2022 at 02:15, Joe Damato <jdamato@fastly.com> wrote:
> >
> > On Tue, Apr 05, 2022 at 10:52:55PM +0200, Lorenzo Bianconi wrote:
> > > Add missing recycle stats to page_pool_put_page_bulk routine.
> >
> > Thanks for proposing this change. I did miss this path when adding
> > stats.
> >
> > I'm sort of torn on this. It almost seems that we might want to track
> > bulking events separately as their own stat.
> >
> > Maybe Ilias has an opinion on this; I did implement the stats, but I'm not
> > a maintainer of the page_pool so I'm not sure what I think matters all
> > that much ;)
> 
> It does.  In fact I think people that actually use the stats for
> something have a better understanding on what's useful and what's not.
> OTOH page_pool_put_page_bulk() is used on the XDP path for now but it
> ends up returning pages on a for loop.  So personally I think we are
> fine without it. The page will be either returned to the ptr_ring
> cache or be free'd and we account for both of those.
> 
> However looking at the code I noticed another issue.
> __page_pool_alloc_pages_slow() increments the 'slow' stat by one. But
> we are not only allocating a single page in there we allocate nr_pages
> and we feed all of them but one to the cache.  So imho here we should
> bump the slow counter appropriately.  The next allocations will
> probably be served from the cache and they will get their own proper
> counters.

After thinking about this a bit more... I'm not sure.

__page_pool_alloc_pages_slow increments slow by 1 because that one page is
returned to the user via the slow path. The side-effect of landing in the
slow path is that nr_pages-1 pages will be fed into the cache... but not
necessarily allocated to the driver.

As you mention, follow up allocations will count them properly as fast path
allocations.

It might be OK as it is. If we add nr_pages to the number of slow allocs
(even though they were never actually allocated as far as the user is
concerned), it may be a bit confusing -- essentially double counting those
allocations as both slow and fast.

So, I think Lorenzo's original patch is correct as is and my comment on it
about __page_pool_alloc_pages_slow was wrong.

> >
> > > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > > ---
> > >  net/core/page_pool.c | 15 +++++++++++++--
> > >  1 file changed, 13 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> > > index 1943c0f0307d..4af55d28ffa3 100644
> > > --- a/net/core/page_pool.c
> > > +++ b/net/core/page_pool.c
> > > @@ -36,6 +36,12 @@
> > >               this_cpu_inc(s->__stat);                                                \
> > >       } while (0)
> > >
> > > +#define recycle_stat_add(pool, __stat, val)                                          \
> > > +     do {                                                                            \
> > > +             struct page_pool_recycle_stats __percpu *s = pool->recycle_stats;       \
> > > +             this_cpu_add(s->__stat, val);                                           \
> > > +     } while (0)
> > > +
> > >  bool page_pool_get_stats(struct page_pool *pool,
> > >                        struct page_pool_stats *stats)
> > >  {
> > > @@ -63,6 +69,7 @@ EXPORT_SYMBOL(page_pool_get_stats);
> > >  #else
> > >  #define alloc_stat_inc(pool, __stat)
> > >  #define recycle_stat_inc(pool, __stat)
> > > +#define recycle_stat_add(pool, __stat, val)
> > >  #endif
> > >
> > >  static int page_pool_init(struct page_pool *pool,
> > > @@ -566,9 +573,13 @@ void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > >       /* Bulk producer into ptr_ring page_pool cache */
> > >       page_pool_ring_lock(pool);
> > >       for (i = 0; i < bulk_len; i++) {
> > > -             if (__ptr_ring_produce(&pool->ring, data[i]))
> > > -                     break; /* ring full */
> > > +             if (__ptr_ring_produce(&pool->ring, data[i])) {
> > > +                     /* ring full */
> > > +                     recycle_stat_inc(pool, ring_full);
> > > +                     break;
> > > +             }
> > >       }
> > > +     recycle_stat_add(pool, ring, i);
> >
> > If we do go with this approach (instead of adding bulking-specific stats),
> > we might want to replicate this change in __page_pool_alloc_pages_slow; we
> > currently only count the single allocation returned by the slow path, but
> > the rest of the pages which refilled the cache are not counted.
> 
> Ah yes we are saying the same thing here
> 
> Thanks
> /Ilias
> >
> > >       page_pool_ring_unlock(pool);
> > >
> > >       /* Hopefully all pages was return into ptr_ring */
> > > --
> > > 2.35.1
> > >

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43EA4A316F
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 19:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245283AbiA2Stj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 13:49:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242589AbiA2Sti (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 13:49:38 -0500
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF79C061714
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 10:49:38 -0800 (PST)
Received: by mail-yb1-xb35.google.com with SMTP id r65so28084929ybc.11
        for <netdev@vger.kernel.org>; Sat, 29 Jan 2022 10:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6COsrBirBySNxA/mH2Kh5iZLsVNdCWqZ3zXgQqS29nc=;
        b=JYk2tCBoltXtwu0psHU/E2cx/SlRwbvsPZd9wCodRPMzVz9LZRHj5pFrmT853K0DyB
         gfIjBf4dWeZymWlWW8qiS7JuEFpCxhbJuxCkyKfFf9BAd3LQU4duazmAo1J9EX2X/MBt
         F6Bnl4q0CHeljV/AK4wBwS+a7cM0ixZ/2vXbhBIFmQOoKT+76mNiGRuzE5sRkGq3+N0J
         ZpYSJR62Q04IphUk8OpCJhrfb4oSpC0WIiv/Qty25uRpCKEmcavRlZLT6uCnschbqSb1
         dP6u7XIYFPd6SN5aUJzfBA1bhM/x8C5J1ZAmZwaINN11JBbkjs6HCIXxzrXZRsXWDriG
         Fkww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6COsrBirBySNxA/mH2Kh5iZLsVNdCWqZ3zXgQqS29nc=;
        b=RpKpJja9czdsThTe3Q+/K9B9UnYT+/RANVrqDxkfXBUgB1UjwNd8AxdLeBMqN0/TAq
         1zU9eRxTwNghrWrYYFcasaZuKafOzNCqm5CnT20QZ5NQEshhN07krcKgvDQ+Cge8E92E
         dGrmCjymr5xmseAfokaXjVDXqKczAyepNoIeg/i5GW2M5ZX6pAerN3qRL6LB5PpNZ4Fk
         4wIYhEdnDi8z/2taw+pesMVlRt1VJ9VorI7p5mngKhKghKSqUP8YgReoIW2KGSUMdmRR
         5grcXXs+tGfNlCqb9y0+RTUjbWZRDunDSqGgvNr0DSCY7KwBf1p0vrgyk2NduXP9xnID
         XlPA==
X-Gm-Message-State: AOAM533qIhCInMLoswCApcEGhpuY5xSeRYpAB9EzkaNzSY1R8/Ef/Km2
        Gxa1Lkg4f7pb9YB4o0QP0xDAysZh7/sug2BMAVnQvQ==
X-Google-Smtp-Source: ABdhPJwmqFUCoMNq1pNkuggpUCAcWk64vpi7TxqV5tVZjlma14wGxQsahFaEc5cySpBGHhRtqlOr2jHv7yJRqxFHk7Q=
X-Received: by 2002:a5b:a03:: with SMTP id k3mr20889450ybq.219.1643482177399;
 Sat, 29 Jan 2022 10:49:37 -0800 (PST)
MIME-Version: 1.0
References: <164329517024.130462.875087745767169286.stgit@localhost.localdomain>
 <eae2e24f-03c7-8e92-9e70-8a50d620c1ca@huawei.com> <YfUOTkboCcHok27N@hades> <CAKgT0Ucjp3HKOPcjYNGh4ShGQzq7_7dMhQip_1P5Ei-xrv_pLQ@mail.gmail.com>
In-Reply-To: <CAKgT0Ucjp3HKOPcjYNGh4ShGQzq7_7dMhQip_1P5Ei-xrv_pLQ@mail.gmail.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Sat, 29 Jan 2022 20:49:01 +0200
Message-ID: <CAC_iWjKsHyNXmZFb7JTUbfCNsDbC5DdEkDfg5W6RLgUeRmp4Zg@mail.gmail.com>
Subject: Re: [net-next PATCH v2] page_pool: Refactor page_pool to enable
 fragmenting after allocation
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     Yunsheng Lin <linyunsheng@huawei.com>,
        Netdev <netdev@vger.kernel.org>, hawk@kernel.org,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexanderduyck@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

On Sat, 29 Jan 2022 at 20:35, Alexander Duyck <alexander.duyck@gmail.com> wrote:
>

[...]

> > >
> > > Also I am not sure exporting the frag count to the driver is a good
> > > idea, as the above example seems a little complex, maybe adding
> > > the fragmenting after allocation support for a existing driver
> > > is a good way to show if the API is really a good one.
> >
> > This is already kind of exposed since no one limits drivers from calling
> > page_pool_atomic_sub_frag_count_return() right?
> > What this patchset does is allow the drivers to actually use it and release
> > pages without having to atomically decrement all the refcnt bias.
> >
> > And I do get the point that a driver might choose to do the refcounting
> > internally.  That was the point all along with the fragment support in
> > page_pool.  There's a wide variety of interfaces out there and each one
> > handles buffers differently.
> >
> > What I am missing though is how this works with the current recycling
> > scheme? The driver will still have to to make sure that
> > page_pool_defrag_page(page, 1) == 0 for that to work no?
>
> The general idea here is that we are getting away from doing in-driver
> recycling and instead letting page pool take care of all that. That
> was the original idea behind page pool, however the original
> implementation was limited to a single use per page only.
>
> So most of the legacy code out there is having to use the
> page_ref_count == 1 or page_ref_count == bias trick in order to
> determine if it can recycle the page. The page pool already takes care
> of the page recycling by returning the pages to the pool when
> page_ref_count == 1, what we get by adding the frag count is the
> ability for the drivers to drop the need to perform their own ref
> count tricks and instead offloads that to the kernel so when
> page_pool_defrag_page(page, 1) == 0 it can then go immediately into
> the checks for page_ref_count == 1 and just recycle the page into the
> page pool.

Excellent, that's what I assumed tbh

Thanks!

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
>
> > >
> > >
> > > >
> > > > The general idea is that we want to have the ability to allocate a page
> > > > with excess fragment count and then trim off the unneeded fragments.
> > > >
> > > > Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
> > > > ---
> > > >
> > > > v2: Added page_pool_is_last_frag
> > > >     Moved comment about CONFIG_PAGE_POOL to page_pool_put_page
> > > >     Wrapped statements for page_pool_is_last_frag in parenthesis
> > > >
> > > >  include/net/page_pool.h |   82 ++++++++++++++++++++++++++++++-----------------
> > > >  net/core/page_pool.c    |   23 ++++++-------
> > > >  2 files changed, 62 insertions(+), 43 deletions(-)
> > > >
> > > > diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> > > > index 79a805542d0f..fbed91469d42 100644
> > > > --- a/include/net/page_pool.h
> > > > +++ b/include/net/page_pool.h
> > > > @@ -201,21 +201,67 @@ static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> > > >  }
> > > >  #endif
> > > >
> > > > -void page_pool_put_page(struct page_pool *pool, struct page *page,
> > > > -                   unsigned int dma_sync_size, bool allow_direct);
> > > > +void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
> > > > +                             unsigned int dma_sync_size,
> > > > +                             bool allow_direct);
> > > >
> > > > -/* Same as above but will try to sync the entire area pool->max_len */
> > > > -static inline void page_pool_put_full_page(struct page_pool *pool,
> > > > -                                      struct page *page, bool allow_direct)
> > > > +static inline void page_pool_fragment_page(struct page *page, long nr)
> > > > +{
> > > > +   atomic_long_set(&page->pp_frag_count, nr);
> > > > +}
> > > > +
> > > > +static inline long page_pool_defrag_page(struct page *page, long nr)
> > > > +{
> > > > +   long ret;
> > > > +
> > > > +   /* If nr == pp_frag_count then we are have cleared all remaining
> >
> > s/are//
>
> Will fix for v3.
>
> Thanks,
>
> Alex

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 898143FC885
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 15:43:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbhHaNoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 09:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239555AbhHaNoK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 09:44:10 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3970FC061575;
        Tue, 31 Aug 2021 06:43:15 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id i21so38896911ejd.2;
        Tue, 31 Aug 2021 06:43:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VH/yKqNAe9e3PUm35v8kdpwIp0mhzflq9zZXa4MIE80=;
        b=cQmZ8fYs6ynPoVomOUgSSwIFWfEsgdikbjEQfS8VdxK9y/dBxVlm1S/6vWtaU6kWJo
         LOE5xjRT/QezIFQuTT+RSzP+aVt7mb3v18K55fLa9W9cFmLBeAvg6Jjg4rMRuhwClE9b
         wKwfgP96LheuO7HofYhnV4heAXQbJGMrbqvdz7fAw7uC2lgu8bOBgNv8uGO0p4M53Ezh
         vGgpT/yCEN18qbFmqEa1/ibKnU1xn5xOe97sa+hkU5ykMP9nyMkodys6tIQwpmVLzptR
         du+hDUgMln/KWWWhy4qvrN/UGdkyQ2LIRgbOdxZcH3jALQvIcEDUJ4T4mQjuCheEC+79
         Ox8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VH/yKqNAe9e3PUm35v8kdpwIp0mhzflq9zZXa4MIE80=;
        b=Li7DLtisoCF8ULtbLYde1U63HagsZiR8q8GJomGiejNblwIxp/eZF1tj+QVR8YM6gp
         fQKziozBh2nULS7YS4gTc/RiDCqRP/TUHMuk19/Jz0XPZFyaWSiJe/b71j1JrYkY9fGS
         p8YrmW/3mSXouMP2tDXgxdo9mXBUgAN1hjTHYPK68JmwggamQQwzcxitNBG2wxeXUE/b
         +vPLG9EHF1xDlfOSSd/TwP8Kqkb1Y0IFVo7FyqL4G5oY5nKeiIo97ZtwCRMEpadgMERz
         Rzj0g4aQteP+1N4b+p2NmSKqHyjaJCoDguDDDTMo+ujRsVEdMxDok5l9q9KAno3YgNAx
         B+4w==
X-Gm-Message-State: AOAM531vee1ZWlCX3t+aCqruLO1YtLMrKpJLjDTgg+75Ju2a0mNax//A
        1CG58zR72P4uIKzsJ772FPTsB5i0ekPqKpIHF/8=
X-Google-Smtp-Source: ABdhPJzF4TqghotOb9gsyWAEqZ8d+Z807qcLYjslQQfjFeb/w2NC7K8Rss2nKk5fvcsj5hCbQobCQTmDne5hJC7dpew=
X-Received: by 2002:a17:907:2d9f:: with SMTP id gt31mr30503364ejc.489.1630417393590;
 Tue, 31 Aug 2021 06:43:13 -0700 (PDT)
MIME-Version: 1.0
References: <1630286290-43714-1-git-send-email-linyunsheng@huawei.com>
 <1630286290-43714-2-git-send-email-linyunsheng@huawei.com>
 <CAKgT0UfNFw+jwoDr_xx6kX_OoCVgrq2rCSc4zdXRMSZLBmbA8Q@mail.gmail.com> <e0f927bb-7a03-de00-d62a-d2235a0f4d8c@huawei.com>
In-Reply-To: <e0f927bb-7a03-de00-d62a-d2235a0f4d8c@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 31 Aug 2021 06:43:02 -0700
Message-ID: <CAKgT0UcYAKsO8FmunL1WKz=_tyw4EK+Z1UbcOup6_Ywi7J84HQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] page_pool: support non-split page with PP_FLAG_PAGE_FRAG
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxarm@openeuler.org,
        hawk@kernel.org, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>, memxor@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 30, 2021 at 11:14 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> On 2021/8/30 23:05, Alexander Duyck wrote:
> > On Sun, Aug 29, 2021 at 6:19 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
> >>
> >> Currently when PP_FLAG_PAGE_FRAG is set, the caller is not
> >> expected to call page_pool_alloc_pages() directly because of
> >> the PP_FLAG_PAGE_FRAG checking in __page_pool_put_page().
> >>
> >> The patch removes the above checking to enable non-split page
> >> support when PP_FLAG_PAGE_FRAG is set.
> >>
> >> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> >> ---
> >>  include/net/page_pool.h |  6 ++++++
> >>  net/core/page_pool.c    | 12 +++++++-----
> >>  2 files changed, 13 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> >> index a408240..2ad0706 100644
> >> --- a/include/net/page_pool.h
> >> +++ b/include/net/page_pool.h
> >> @@ -238,6 +238,9 @@ static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> >>
> >>  static inline void page_pool_set_frag_count(struct page *page, long nr)
> >>  {
> >> +       if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> >> +               return;
> >> +
> >>         atomic_long_set(&page->pp_frag_count, nr);
> >>  }
> >>
> >> @@ -246,6 +249,9 @@ static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
> >>  {
> >>         long ret;
> >>
> >> +       if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> >> +               return 0;
> >> +
> >>         /* As suggested by Alexander, atomic_long_read() may cover up the
> >>          * reference count errors, so avoid calling atomic_long_read() in
> >>          * the cases of freeing or draining the page_frags, where we would
> >> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> >> index 1a69784..ba9f14d 100644
> >> --- a/net/core/page_pool.c
> >> +++ b/net/core/page_pool.c
> >> @@ -313,11 +313,14 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
> >>
> >>         /* Fast-path: Get a page from cache */
> >>         page = __page_pool_get_cached(pool);
> >> -       if (page)
> >> -               return page;
> >>
> >>         /* Slow-path: cache empty, do real allocation */
> >> -       page = __page_pool_alloc_pages_slow(pool, gfp);
> >> +       if (!page)
> >> +               page = __page_pool_alloc_pages_slow(pool, gfp);
> >> +
> >> +       if (likely(page))
> >> +               page_pool_set_frag_count(page, 1);
> >> +
> >>         return page;
> >>  }
> >>  EXPORT_SYMBOL(page_pool_alloc_pages);
> >> @@ -426,8 +429,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
> >>                      unsigned int dma_sync_size, bool allow_direct)
> >>  {
> >>         /* It is not the last user for the page frag case */
> >> -       if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
> >> -           page_pool_atomic_sub_frag_count_return(page, 1))
> >> +       if (page_pool_atomic_sub_frag_count_return(page, 1))
> >>                 return NULL;
> >
> > Isn't this going to have a negative performance impact on page pool
> > pages in general? Essentially you are adding an extra atomic operation
> > for all the non-frag pages.
> >
> > It would work better if this was doing a check against 1 to determine
> > if it is okay for this page to be freed here and only if the check
> > fails then you perform the atomic sub_return.
>
> The page_pool_atomic_sub_frag_count_return() has added the optimization
> to not do the atomic sub_return when the caller is the last user of the
> page, see page_pool_atomic_sub_frag_count_return():
>
>         /* As suggested by Alexander, atomic_long_read() may cover up the
>          * reference count errors, so avoid calling atomic_long_read() in
>          * the cases of freeing or draining the page_frags, where we would
>          * not expect it to match or that are slowpath anyway.
>          */
>         if (__builtin_constant_p(nr) &&
>             atomic_long_read(&page->pp_frag_count) == nr)
>                 return 0;
>
> So the check against 1 is not needed here?

Ah, okay. I hadn't seen that part. So yeah, then this should be mostly
harmless since 1 falls into the category of a builtin constant and
would result in the standard case being the frag count being set to 1
and then being read which should be minimal overhead.

Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

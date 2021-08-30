Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA0DA3FB8BA
	for <lists+netdev@lfdr.de>; Mon, 30 Aug 2021 17:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237268AbhH3PGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Aug 2021 11:06:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237123AbhH3PGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Aug 2021 11:06:24 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D57C061575;
        Mon, 30 Aug 2021 08:05:30 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id me10so31805226ejb.11;
        Mon, 30 Aug 2021 08:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lYmhCndv6D6zxy0kLorHB0ixdkNzSVX/DeO0ZDxZWts=;
        b=T1IBEaTTOs3gGFWRmAvGYFhPXFFPtOTlhqCafMZjZiGUZ7hkdEp78j4orgS7F0E6fW
         hCxzyzxfB4t9wlGhZEZOn3aQs3sDHuQdXf8TLVDfmKX+Ql0UJY6gUY/4lA6PMUKBKUHp
         O+cB+onUrkSWUMQ5BYvdFmL/ytnXa275kOcbc9DQZ+ahP2RCugldxeB2ho73A2QDRphK
         8JwWUR58qX9KBvd+2dZRXVJJ8FD+Rzlwqn25obzHr6uGKwVVFQzIKti6VGqHqR3O8N2d
         SS1+TdxyCutQqUZenZpVH8jXlCPVIOZYVO1Z2PN+Lu15QUXOhPUzO/w0yKv7B2ROKbDH
         OJlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lYmhCndv6D6zxy0kLorHB0ixdkNzSVX/DeO0ZDxZWts=;
        b=So5sycRDF4rIYqkxYpgbI9Rp8GYgdiSooXN1Rvl2cqZRaxvLEw+JXalrUcamHFz7y4
         LKKiTt+IQGh2B5ceROA3FoPjMef1BPurSK8TCSIauCJqotECMvTmUIGZGzYXmVaT6QEp
         V17vqRE29NbOfQos3O+DBleD3P/ZO0kpfteBeSaXnBMAKbWEv7kFqkl2ZrA5RbGT53xJ
         nXB6zqd42HBazz2je7o3/7QUzZIXBw9vrga8a9NiNy10UoWQm8riySbStwXU+1UdY8YU
         laRBbQquFasgVv6bk/FI1biqko/JlaC0GdzUmFvIzyfZLm5/syyRHvovdPQnVHoO3+lm
         vo/A==
X-Gm-Message-State: AOAM530jy69d7xGjXsWm1tN4plM2ePJTAsPZqLE1GRvyjv8uEaWO22vG
        kjLf8tevt+HEkq44mmAWkuOKs3qQUTbxl0bf1y4=
X-Google-Smtp-Source: ABdhPJzZIFeSC+BDivYn/eXHJWH7fe+C3I1QxEZnu8JWh2pMJSceYo/Jr62j5E8itu50ljXAZdqXRJLbxyaNOFNhFwM=
X-Received: by 2002:a17:907:764f:: with SMTP id kj15mr11537950ejc.473.1630335928716;
 Mon, 30 Aug 2021 08:05:28 -0700 (PDT)
MIME-Version: 1.0
References: <1630286290-43714-1-git-send-email-linyunsheng@huawei.com> <1630286290-43714-2-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1630286290-43714-2-git-send-email-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 30 Aug 2021 08:05:17 -0700
Message-ID: <CAKgT0UfNFw+jwoDr_xx6kX_OoCVgrq2rCSc4zdXRMSZLBmbA8Q@mail.gmail.com>
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

On Sun, Aug 29, 2021 at 6:19 PM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> Currently when PP_FLAG_PAGE_FRAG is set, the caller is not
> expected to call page_pool_alloc_pages() directly because of
> the PP_FLAG_PAGE_FRAG checking in __page_pool_put_page().
>
> The patch removes the above checking to enable non-split page
> support when PP_FLAG_PAGE_FRAG is set.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/net/page_pool.h |  6 ++++++
>  net/core/page_pool.c    | 12 +++++++-----
>  2 files changed, 13 insertions(+), 5 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index a408240..2ad0706 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -238,6 +238,9 @@ static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>
>  static inline void page_pool_set_frag_count(struct page *page, long nr)
>  {
> +       if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> +               return;
> +
>         atomic_long_set(&page->pp_frag_count, nr);
>  }
>
> @@ -246,6 +249,9 @@ static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
>  {
>         long ret;
>
> +       if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> +               return 0;
> +
>         /* As suggested by Alexander, atomic_long_read() may cover up the
>          * reference count errors, so avoid calling atomic_long_read() in
>          * the cases of freeing or draining the page_frags, where we would
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 1a69784..ba9f14d 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -313,11 +313,14 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
>
>         /* Fast-path: Get a page from cache */
>         page = __page_pool_get_cached(pool);
> -       if (page)
> -               return page;
>
>         /* Slow-path: cache empty, do real allocation */
> -       page = __page_pool_alloc_pages_slow(pool, gfp);
> +       if (!page)
> +               page = __page_pool_alloc_pages_slow(pool, gfp);
> +
> +       if (likely(page))
> +               page_pool_set_frag_count(page, 1);
> +
>         return page;
>  }
>  EXPORT_SYMBOL(page_pool_alloc_pages);
> @@ -426,8 +429,7 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>                      unsigned int dma_sync_size, bool allow_direct)
>  {
>         /* It is not the last user for the page frag case */
> -       if (pool->p.flags & PP_FLAG_PAGE_FRAG &&
> -           page_pool_atomic_sub_frag_count_return(page, 1))
> +       if (page_pool_atomic_sub_frag_count_return(page, 1))
>                 return NULL;

Isn't this going to have a negative performance impact on page pool
pages in general? Essentially you are adding an extra atomic operation
for all the non-frag pages.

It would work better if this was doing a check against 1 to determine
if it is okay for this page to be freed here and only if the check
fails then you perform the atomic sub_return.

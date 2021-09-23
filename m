Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ABDC415A9C
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 11:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240116AbhIWJMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 05:12:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239137AbhIWJMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 05:12:17 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5115AC061574
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 02:10:46 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id 194so19498931qkj.11
        for <netdev@vger.kernel.org>; Thu, 23 Sep 2021 02:10:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=a8Z7t7bZfR3zmbFDGF4G+8fqZ83a7fJdal0XrkBEoaM=;
        b=X/Q7uS++0f06h6qGTrAtL6Dr3MDX9jd3ktMBTvVq9DEX0nDbeN0WqTNAPDCjtwYfpI
         A9o1fD+1rrnt+VQ2EEYnx8q9zYgLZuGZOOhYBR27Y38bxF3vjRE729xdQ98CLooKAB/z
         zzfUBgGvCRJDB8Znz6KVu54ApaWpG5Y/geolPesvcGuvbF17tDaXyEOnZXN1xm6P0umO
         G7rMorfdQR8nJ/dK5s5KXdscWKCebo/5SPuWALmO/4n/vI2WWz3KZsojETUhgvjaCryX
         PUrrhOFYC8jY08QWC6ty9jZVrR9LXG832Uzb1N0X2XRs7DoKE/hBmw4QoeLA/pwnAtVI
         7tfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=a8Z7t7bZfR3zmbFDGF4G+8fqZ83a7fJdal0XrkBEoaM=;
        b=q0AVp9LVMrGN+FQO18a7DtLbjUYAlgbSoORypmc3u7ocNKYvmEnp6wfzBtf8+GGJGg
         63o+DwZ/zDE6o+Ig25r6nPpzp4HuvWzs1jjqRkZRcxGENe8NEvFeQYr3LnOCEUAZwg9S
         jein2Z47gp+IEcxqBlXtEKmrbjsFuEKa6VAlIybb+8xi3EVrc6IVSz1ShuZFtzmmaBum
         seIkwkniIyX04GwyD1e0dEdkx2EVHYLVfWUxD83kiUtPUx+octiUbVbqSfskFzYE+c4e
         jCeerCmqKkc0ZsKsyayNgsJoeOefkHcVgL7oNCfokyrAQO84f/B1PBdlTVrKX4oJQspg
         3deg==
X-Gm-Message-State: AOAM531lZcFs+6zPo9EwR9cae23/eYyEHjwax/TsayYREtopv1LCdubu
        h3L8npIPc02s/ZXA6Bvy+ggZ1KVvdCgz+1gxhR/wQQ==
X-Google-Smtp-Source: ABdhPJyuMo9tO8gq+x1tVZ1Zj+/oL/M388xHMA31qLuA4thsvoMrdth5gcUkn5OmPZuapjUb2+9w6JZF0goZCcBHyqo=
X-Received: by 2002:a25:2f48:: with SMTP id v69mr4366162ybv.339.1632388245450;
 Thu, 23 Sep 2021 02:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20210922094131.15625-1-linyunsheng@huawei.com> <20210922094131.15625-2-linyunsheng@huawei.com>
In-Reply-To: <20210922094131.15625-2-linyunsheng@huawei.com>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Thu, 23 Sep 2021 12:10:09 +0300
Message-ID: <CAC_iWjJX1N_Hi42muo=FUD6oNapwo7mi3af5Gj7=24XSJJbYtQ@mail.gmail.com>
Subject: Re: [PATCH net-next 1/7] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linuxarm@openeuler.org, Jesper Dangaard Brouer <hawk@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Kevin Hao <haokexin@gmail.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Marco Elver <elver@google.com>, memxor@gmail.com,
        Eric Dumazet <edumazet@google.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        David Ahern <dsahern@gmail.com>,
        Matthew Wilcox <willy@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

(+cc Matthew) but this looks safe to me.

On Wed, 22 Sept 2021 at 12:43, Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> As the 32-bit arch with 64-bit DMA seems to rare those days,
> and page pool is carrying a lot of code and complexity for
> systems that possibly don't exist.
>
> So disable dma mapping support for such systems, if drivers
> really want to work on such systems, they have to implement
> their own DMA-mapping fallback tracking outside page_pool.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/linux/mm_types.h | 13 +------------
>  include/net/page_pool.h  | 12 +-----------
>  net/core/page_pool.c     | 10 ++++++----
>  3 files changed, 8 insertions(+), 27 deletions(-)
>
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 7f8ee09c711f..436e0946d691 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -104,18 +104,7 @@ struct page {
>                         struct page_pool *pp;
>                         unsigned long _pp_mapping_pad;
>                         unsigned long dma_addr;
> -                       union {
> -                               /**
> -                                * dma_addr_upper: might require a 64-bit
> -                                * value on 32-bit architectures.
> -                                */
> -                               unsigned long dma_addr_upper;
> -                               /**
> -                                * For frag page support, not supported in
> -                                * 32-bit architectures with 64-bit DMA.
> -                                */
> -                               atomic_long_t pp_frag_count;
> -                       };
> +                       atomic_long_t pp_frag_count;
>                 };
>                 struct {        /* slab, slob and slub */
>                         union {
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index a4082406a003..3855f069627f 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -216,24 +216,14 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>         page_pool_put_full_page(pool, page, true);
>  }
>
> -#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT        \
> -               (sizeof(dma_addr_t) > sizeof(unsigned long))
> -
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -       dma_addr_t ret = page->dma_addr;
> -
> -       if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> -               ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
> -
> -       return ret;
> +       return page->dma_addr;
>  }
>
>  static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>  {
>         page->dma_addr = addr;
> -       if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> -               page->dma_addr_upper = upper_32_bits(addr);
>  }
>
>  static inline void page_pool_set_frag_count(struct page *page, long nr)
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 1a6978427d6c..a65bd7972e37 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -49,6 +49,12 @@ static int page_pool_init(struct page_pool *pool,
>          * which is the XDP_TX use-case.
>          */
>         if (pool->p.flags & PP_FLAG_DMA_MAP) {
> +               /* DMA-mapping is not supported on 32-bit systems with
> +                * 64-bit DMA mapping.
> +                */
> +               if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +                       return -EINVAL;
> +
>                 if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
>                     (pool->p.dma_dir != DMA_BIDIRECTIONAL))
>                         return -EINVAL;
> @@ -69,10 +75,6 @@ static int page_pool_init(struct page_pool *pool,
>                  */
>         }
>
> -       if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> -           pool->p.flags & PP_FLAG_PAGE_FRAG)
> -               return -EINVAL;
> -
>         if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
>                 return -ENOMEM;
>
> --
> 2.33.0
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

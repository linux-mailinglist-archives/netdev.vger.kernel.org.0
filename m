Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4316A3C35E0
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 19:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231241AbhGJRqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 13:46:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbhGJRqL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 13:46:11 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 647BEC0613DD;
        Sat, 10 Jul 2021 10:43:25 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id c17so23132477ejk.13;
        Sat, 10 Jul 2021 10:43:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=guxa8zszEeOuF4Mx8YxUECO6Q6Nkvsker5B3i1dKPQE=;
        b=aiACP9aEZ6vdJYZdq8vaaEQUWRAt58kaiugXKY1LAT88HK8sgGYKSM6IM+uLE1bPwa
         5T6wSBYOq3OJk/MWe3YxQdaJSP1qd74JkVGJhYLmo1f+26N9oEKmJSANkhLA2Lpqy7Z0
         ET/rdIOm4a0fL1IaS2fX90c5KbVeVXUplambJIPk5Yd8Rg3/j0e/2J5pA59MxbEhtAI/
         XHvjTriWI3M9SSZLQYpyS/60dS7SUMfsMNcz+PHG5Wp/ol1mAHE6t0ZRJ5AYBHZSH9zb
         meHShZ0X+PtOyJ2jBVj6c0kg19V5YdByaaMIwpR6d3TwAHlzCLzui0kAAelskMVeMUtm
         0U+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=guxa8zszEeOuF4Mx8YxUECO6Q6Nkvsker5B3i1dKPQE=;
        b=BHD82aJs4SQBFfv8MeLiCcgwdDrJcb0wn5ijHwEaqOJcpuwxUKvmP6+2aa1MQew04z
         8A7An6sk5UJrykt/+CFY+PX1OemTvLD9Area4BZal2uCTQzlsaFciuYdLagZCAbIyZRc
         5vw9p/Qx2Dk+zQQwJm+QSz5gs0vA9mFdlyKZPBxrb2zTBYNO9+s4IyZzm07SXbGks/w9
         7WIxVFZIQzPalefJXugUctfJPqOIsVuwAwifSdW6RLBn5U9XPDMeN1Jcrw0nZYmDRmXN
         h7aRa+tE7GOQC6mC8ByX/BhtPRLrxMYNT8GXGTqtXFY0XEVoKh79Hf92AR43e7NCdTHr
         yGCw==
X-Gm-Message-State: AOAM53238WvWXnIt8Q6stuTYS7E42UKihEAJYxyHmdUy2nyBNrMu5i/9
        /PXU3suScX78BB3EPrbypHT3I9BYLvpPvW3Xw0E=
X-Google-Smtp-Source: ABdhPJxnHiiSZfEBzdaEl/d2Bk6oQkoBBuMK5ewsNzKJdXTFwl3XO/Gy68Su310socbtWATWApdfpSxw8P25bdLzjyk=
X-Received: by 2002:a17:907:1ca4:: with SMTP id nb36mr44026762ejc.33.1625939003591;
 Sat, 10 Jul 2021 10:43:23 -0700 (PDT)
MIME-Version: 1.0
References: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com> <1625903002-31619-5-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1625903002-31619-5-git-send-email-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 10 Jul 2021 10:43:12 -0700
Message-ID: <CAKgT0UeDf1+-CjzsCo0Chtd2kn_mFV7=my1ygeKMBHBSdjrAHQ@mail.gmail.com>
Subject: Re: [PATCH rfc v2 4/5] page_pool: support page frag API for page pool
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, Salil Mehta <salil.mehta@huawei.com>,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Vlastimil Babka <vbabka@suse.cz>, fenghua.yu@intel.com,
        guro@fb.com, Peter Xu <peterx@redhat.com>,
        Feng Tang <feng.tang@intel.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Matteo Croce <mcroce@microsoft.com>,
        Hugh Dickins <hughd@google.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Willem de Bruijn <willemb@google.com>, wenxu@ucloud.cn,
        Cong Wang <cong.wang@bytedance.com>,
        Kevin Hao <haokexin@gmail.com>, nogikh@google.com,
        Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:44 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> Currently each desc use a whole page to do ping-pong page
> reusing in most driver. As the page pool has support page
> recycling based on elevated refcnt, it makes sense to add
> a page frag API in page pool to split a page to different
> frag to serve multi descriptions.
>
> This means a huge memory saving for kernel with page size of
> 64K, as a page can be used by 32 descriptions with 2k buffer
> size, comparing to each desc using one page currently.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/net/page_pool.h | 14 ++++++++++++++
>  net/core/page_pool.c    | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 63 insertions(+)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index f0e708d..06a5e43 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -80,6 +80,7 @@ struct page_pool_params {
>         enum dma_data_direction dma_dir; /* DMA mapping direction */
>         unsigned int    max_len; /* max DMA sync memory size */
>         unsigned int    offset;  /* DMA addr offset */
> +       unsigned int    frag_size;
>  };
>
>  struct page_pool {
> @@ -91,6 +92,8 @@ struct page_pool {
>         unsigned long defer_warn;
>
>         u32 pages_state_hold_cnt;
> +       unsigned int frag_offset;
> +       struct page *frag_page;
>
>         /*
>          * Data structure for allocation side
> @@ -140,6 +143,17 @@ static inline struct page *page_pool_dev_alloc_pages(struct page_pool *pool)
>         return page_pool_alloc_pages(pool, gfp);
>  }
>
> +struct page *page_pool_alloc_frag(struct page_pool *pool,
> +                                 unsigned int *offset, gfp_t gfp);
> +
> +static inline struct page *page_pool_dev_alloc_frag(struct page_pool *pool,
> +                                                   unsigned int *offset)
> +{
> +       gfp_t gfp = (GFP_ATOMIC | __GFP_NOWARN);
> +
> +       return page_pool_alloc_frag(pool, offset, gfp);
> +}
> +
>  /* get the stored dma direction. A driver might decide to treat this locally and
>   * avoid the extra cache line from page_pool to determine the direction
>   */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index a87cbe1..b787033 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -350,6 +350,53 @@ struct page *page_pool_alloc_pages(struct page_pool *pool, gfp_t gfp)
>  }
>  EXPORT_SYMBOL(page_pool_alloc_pages);
>
> +struct page *page_pool_alloc_frag(struct page_pool *pool,
> +                                 unsigned int *offset, gfp_t gfp)
> +{
> +       unsigned int frag_offset = pool->frag_offset;
> +       unsigned int frag_size = pool->p.frag_size;
> +       struct page *frag_page = pool->frag_page;
> +       unsigned int max_len = pool->p.max_len;
> +
> +       if (!frag_page || frag_offset + frag_size > max_len) {
> +               frag_page = page_pool_alloc_pages(pool, gfp);
> +               if (unlikely(!frag_page)) {
> +                       pool->frag_page = NULL;
> +                       return NULL;
> +               }
> +
> +               pool->frag_page = frag_page;
> +               frag_offset = 0;
> +
> +               page_pool_sub_bias(pool, frag_page,
> +                                  max_len / frag_size - 1);
> +       }
> +
> +       *offset = frag_offset;
> +       pool->frag_offset = frag_offset + frag_size;
> +
> +       return frag_page;
> +}
> +EXPORT_SYMBOL(page_pool_alloc_frag);

I'm still not a fan of the fixed implementation. For the cost of the
division as I said before you could make this flexible like
page_frag_alloc_align and just decrement the bias by one per
allocation instead of trying to batch it.

I'm sure there would likely be implementations that might need to
operate at two different sizes, for example a header and payload size.

> +static void page_pool_empty_frag(struct page_pool *pool)
> +{
> +       unsigned int frag_offset = pool->frag_offset;
> +       unsigned int frag_size = pool->p.frag_size;
> +       struct page *frag_page = pool->frag_page;
> +       unsigned int max_len = pool->p.max_len;
> +
> +       if (!frag_page)
> +               return;
> +
> +       while (frag_offset + frag_size <= max_len) {
> +               page_pool_put_full_page(pool, frag_page, false);
> +               frag_offset += frag_size;
> +       }
> +

Having to call this to free the page seems confusing. Rather than
reserving multiple and having to free the page multiple times I really
think you would be better off just holding one bias reservation on the
page at a time.

> +       pool->frag_page = NULL;
> +}
> +
>  /* Calculate distance between two u32 values, valid if distance is below 2^(31)
>   *  https://en.wikipedia.org/wiki/Serial_number_arithmetic#General_Solution
>   */
> @@ -670,6 +717,8 @@ void page_pool_destroy(struct page_pool *pool)
>         if (!page_pool_put(pool))
>                 return;
>
> +       page_pool_empty_frag(pool);
> +
>         if (!page_pool_release(pool))
>                 return;
>
> --
> 2.7.4
>

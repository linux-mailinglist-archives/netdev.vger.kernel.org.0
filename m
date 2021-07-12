Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F213C6002
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 18:02:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhGLQFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 12:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229465AbhGLQFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 12:05:33 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42034C0613DD;
        Mon, 12 Jul 2021 09:02:44 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id i20so35573319ejw.4;
        Mon, 12 Jul 2021 09:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yASdFe7xYmlRxSElpuTuPr8cxfmHnIT8PrgFH3o60h4=;
        b=e+zZayXoNQo9VWz+tZHnI2zHtRNCMfp3pIfi5Sgk53DDp5lpwyHgpSi0jqC/RNPTFV
         IGXUf+zE54xTsCFnGeZcsN+ShhKmzA3pO76wJIMAuG6qmL9kIQrmrf0grmBREpZMLJjg
         To09hSnWDZ8uP7RTQKAI9i/847y5ZNK78mm1ojK2ddadyE6kUbTAnewvDPIHdKtGCplQ
         yJXDbBMti4v30fR0LbhxLXOrEVd7DEaZxzRpzlYeeS+4Ef5SpD00g0DzYMLOlJjKK7kP
         Uggn265kEF1/Qn4fUdaBGf/yuSww1wD1JjalrwdjXNlQc3kBjyCXLODkS8ToFO7D4Ire
         k2QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yASdFe7xYmlRxSElpuTuPr8cxfmHnIT8PrgFH3o60h4=;
        b=GqI2yNzoLsGF0bg+xTup9TT7urXHv6McH8SUKI5SexXCg80Qs6DmiZKPa74lIcVJWf
         YluOQLGcVVgCUVVchEoOtATgFZbp432dpf6AgTkRL4spR5VZujrkd/RfzavVqsQ+ap0E
         dYpgNH/lsgNnNzgVBqR4l3DKq9EXq1gLHuV06AFDbqZ60xs9Q3NEdIr/wV4tVh6mumYZ
         1kOqClMxVGWCvhglyo8DyhRBtIKWyrAYotM8WewoPNUdqaDymYQ4R1xIk577lcF+RhQW
         YoZ0e/2nEpyCF4VWuW+IYMDY+Hi9L+qXNnHbTmKrKlZIolRvza0iagfHLIhBY4wW9CVK
         Fy2A==
X-Gm-Message-State: AOAM531XGVQg4YtlH5u2YUVTzYXNjsJUYP4NIRH5DlYMreL991lkebJ3
        ZI+1N9C19937iwoKo5/M0synGXL8f92Jwg2XQ9w=
X-Google-Smtp-Source: ABdhPJwzXOENkXmBa4UTeOnWv/u0+TRdQjmXj/CeSutFRfag8CJJciAOdp8+UV+3fzTJqvGysro8BTXgYbLS5P5YDp0=
X-Received: by 2002:a17:906:bc2:: with SMTP id y2mr53431206ejg.489.1626105762727;
 Mon, 12 Jul 2021 09:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <1626092196-44697-1-git-send-email-linyunsheng@huawei.com> <1626092196-44697-3-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1626092196-44697-3-git-send-email-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 12 Jul 2021 09:02:31 -0700
Message-ID: <CAKgT0Uf1W1H_0jK+zTDHdQnpa-dFSfcAtANqhPTJyZ21VeGmjg@mail.gmail.com>
Subject: Re: [PATCH rfc v3 2/4] page_pool: add interface for getting and
 setting pagecnt_bias
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
        Marco Elver <elver@google.com>, Yonghong Song <yhs@fb.com>,
        kpsingh@kernel.org, andrii@kernel.org,
        Martin KaFai Lau <kafai@fb.com>, songliubraving@fb.com,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 5:17 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> As suggested by Alexander, "A DMA mapping should be page
> aligned anyway so the lower 12 bits would be reserved 0",
> so it might make more sense to repurpose the lower 12 bits
> of the dma address to store the pagecnt_bias for frag page
> support in page pool.
>
> As newly added page_pool_get_pagecnt_bias() may be called
> outside of the softirq context, so annotate the access to
> page->dma_addr[0] with READ_ONCE() and WRITE_ONCE().
>
> And page_pool_get_pagecnt_bias_ptr() is added to implement
> the pagecnt_bias atomic updating when a page is passsed to
> the user.
>
> Other three interfaces using page->dma_addr[0] is only called
> in the softirq context during normal rx processing, hopefully
> the barrier in the rx processing will ensure the correct order
> between getting and setting pagecnt_bias.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/net/page_pool.h | 29 +++++++++++++++++++++++++++--
>  net/core/page_pool.c    |  8 +++++++-
>  2 files changed, 34 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 8d7744d..84cd972 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -200,17 +200,42 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -       dma_addr_t ret = page->dma_addr[0];
> +       dma_addr_t ret = READ_ONCE(page->dma_addr[0]) & PAGE_MASK;
>         if (sizeof(dma_addr_t) > sizeof(unsigned long))
>                 ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
>         return ret;
>  }
>
> -static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> +static inline bool page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>  {
> +       if (WARN_ON(addr & ~PAGE_MASK))
> +               return false;
> +
>         page->dma_addr[0] = addr;
>         if (sizeof(dma_addr_t) > sizeof(unsigned long))
>                 page->dma_addr[1] = upper_32_bits(addr);
> +
> +       return true;
> +}
> +

Rather than making this a part of the check here it might make more
sense to pull this out and perform the WARN_ON after the check for
dma_mapping_error.

Also it occurs to me that we only really have to do this in the case
where dma_addr_t is larger than the size of a long. Otherwise we could
just have the code split things so that dma_addr[0] is the dma_addr
and dma_addr[1] is our pagecnt_bias value in which case we could
probably just skip the check.

> +static inline int page_pool_get_pagecnt_bias(struct page *page)
> +{
> +       return READ_ONCE(page->dma_addr[0]) & ~PAGE_MASK;
> +}
> +
> +static inline unsigned long *page_pool_pagecnt_bias_ptr(struct page *page)
> +{
> +       return page->dma_addr;
> +}
> +
> +static inline void page_pool_set_pagecnt_bias(struct page *page, int bias)
> +{
> +       unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
> +
> +       dma_addr_0 &= PAGE_MASK;
> +       dma_addr_0 |= bias;
> +
> +       WRITE_ONCE(page->dma_addr[0], dma_addr_0);
>  }
>
>  static inline bool is_page_pool_compiled_in(void)
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 78838c6..1abefc6 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -198,7 +198,13 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>         if (dma_mapping_error(pool->p.dev, dma))
>                 return false;
>

So instead of adding to the function below you could just add your
WARN_ON check here with the unmapping call.

> -       page_pool_set_dma_addr(page, dma);
> +       if (unlikely(!page_pool_set_dma_addr(page, dma))) {
> +               dma_unmap_page_attrs(pool->p.dev, dma,
> +                                    PAGE_SIZE << pool->p.order,
> +                                    pool->p.dma_dir,
> +                                    DMA_ATTR_SKIP_CPU_SYNC);
> +               return false;
> +       }
>
>         if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
>                 page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> --
> 2.7.4
>

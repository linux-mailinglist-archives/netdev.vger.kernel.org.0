Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740733C769C
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 20:41:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234564AbhGMSoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 14:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234548AbhGMSoF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 14:44:05 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55A33C0613EE;
        Tue, 13 Jul 2021 11:41:14 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id c17so43203536ejk.13;
        Tue, 13 Jul 2021 11:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FnotVOBY4MJ516v1c1mv4RJWivhMUK0+SH3ZuHVwU20=;
        b=ocH/cyHkQ2xDE+OiGRIQa0nRf0KV/hVRl4c0T/OyflQIoFehVp0nhgd+IN3Ov7uE4m
         fqtDMQtuOgqtjdie2j9qlHulMyKHKrgo1dg1gtsbXr927nK14Nt0F7/k/2KtFRl41ZcC
         IRJTldIaWXNLmTzf798r+N9WDISyZ5kGDaP7mOgPBIwg16Co3XSO2MHVDg/DCIkAIBTg
         TNvVJJOYgGUhoxjdvbKyf+SDn35L7IF9JboMY1GE9HE4O2Gw9NapQt0a6tj9Wu08dA+A
         k54f6HrjM6m7mpXmpfQkVQiR7gswYRrkYOFCTXaGa+jIJaUSuDhV4rcURhdKtBztxLbb
         hK+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FnotVOBY4MJ516v1c1mv4RJWivhMUK0+SH3ZuHVwU20=;
        b=kFhejzADZCdRa3O1vaVc4Qtc3jqjA6mhBXXLIDZ6iKR7N/6qln6jV09w8Ow7kyxcvR
         5CrhiTIOsno2aEnRdTlt/Q//4Yow0F5a7RTIg7yQDnZg437GwzaFDQEUbTf7StWIczR3
         vRQJ3F33ZrZvioLodzu1i33BFshyhFm6b/PHTSPipkKrQRRlD0lhJYIyHyjMlvl/kxmr
         msU1O7mLpjGttcN2g2da9sCzUjrVUkG8cAJ+14OnqXaIH5SaPoTXtVJRJn5rAEKilgWM
         BQ3sWRZq/H499Gnp8msOuMEfCbBhDeM+NnEBx13JauEAeYIW6w53n1V2scv598GEa0kL
         kl8A==
X-Gm-Message-State: AOAM533T6wZTIwEu9ujLC+3OBrb3yKxa7LB17L3+BqoD31yI200HziYp
        nVrzXjIbZE7a8N7MKBdU2UN2CKUhJxv1CJaAXRk=
X-Google-Smtp-Source: ABdhPJx+RwAA0sfkwjHGLIOh81NJNto2mj6271Pb2cD5eDmUd5wrTqTSZarZhopKei55G0/dNnMpdSbuKJ/HMLHWQO8=
X-Received: by 2002:a17:907:e9e:: with SMTP id ho30mr7609884ejc.114.1626201672721;
 Tue, 13 Jul 2021 11:41:12 -0700 (PDT)
MIME-Version: 1.0
References: <1626168272-25622-1-git-send-email-linyunsheng@huawei.com> <1626168272-25622-3-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1626168272-25622-3-git-send-email-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Tue, 13 Jul 2021 11:41:01 -0700
Message-ID: <CAKgT0UevHk7n=Lnfkvw1t04HvRCX9vtyc0a6_2cda3c6hgDdJg@mail.gmail.com>
Subject: Re: [PATCH rfc v4 2/4] page_pool: add interface to manipulate bias in
 page pool
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

On Tue, Jul 13, 2021 at 2:25 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> As suggested by Alexander, "A DMA mapping should be page
> aligned anyway so the lower 12 bits would be reserved 0",
> so it might make more sense to repurpose the lower 12 bits
> of the dma address to store the bias for frag page support
> in page pool for 32 bit systems with 64 bit dma, which
> should be rare those days.
>
> For normal system, the dma_addr[1] in 'struct page' is not
> used, so we can reuse the dma_addr[1] for storing bias.
>
> The PAGE_POOP_USE_DMA_ADDR_1 macro is used to decide where
> to store the bias, as the "sizeof(dma_addr_t) > sizeof(
> unsigned long)" is false for normal system, so hopefully the
> compiler will optimize out the unused code for those system.

I assume the name is a typo and you meant PAGE_POOL_USE_DMA_ADDR_1?

> The newly added page_pool_set_bias() should be called before
> the page is passed to any user. Otherwise, call the newly
> added page_pool_atomic_sub_bias_return().
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/net/page_pool.h | 70 ++++++++++++++++++++++++++++++++++++++++++++++---
>  net/core/page_pool.c    | 10 +++++++
>  2 files changed, 77 insertions(+), 3 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 8d7744d..315b9f2 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -198,21 +198,85 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>         page_pool_put_full_page(pool, page, true);
>  }
>
> +#define PAGE_POOP_USE_DMA_ADDR_1       (sizeof(dma_addr_t) > sizeof(unsigned long))
> +
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -       dma_addr_t ret = page->dma_addr[0];
> -       if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +       dma_addr_t ret;
> +
> +       if (PAGE_POOP_USE_DMA_ADDR_1) {
> +               ret = READ_ONCE(page->dma_addr[0]) & PAGE_MASK;
>                 ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;

Alternatively we could change things a bit and rename things so we
have the MSB of dma_addr where dma_addr[1] is and we rename
dma_addr[0] to pp_frag_count we could have it also contain the lower
bits and handle it like so:
    ret = page->dma_addr;
    if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
        ret <<= 32;
        ret |= atomic_long_read(&page->pp_frag_count) & PAGE_MASK;
    }

> +       } else {
> +               ret = page->dma_addr[0];
> +       }
> +
>         return ret;
>  }
>
>  static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>  {
>         page->dma_addr[0] = addr;
> -       if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +       if (PAGE_POOP_USE_DMA_ADDR_1)
>                 page->dma_addr[1] = upper_32_bits(addr);

So assuming similar logic to above we could do something like:
    if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
        atomic_long_set(&page->pp_frag_count, addr & PAGE_MASK);
        addr >>= 32;
    }
    pp->dma_addr = addr;

>  }
>
> +static inline int page_pool_atomic_sub_bias_return(struct page *page, int nr)
> +{
> +       int bias;
> +
> +       if (PAGE_POOP_USE_DMA_ADDR_1) {
> +               unsigned long *bias_ptr = &page->dma_addr[0];
> +               unsigned long old_bias = READ_ONCE(*bias_ptr);
> +               unsigned long new_bias;
> +
> +               do {
> +                       bias = (int)(old_bias & ~PAGE_MASK);
> +
> +                       /* Warn when page_pool_dev_alloc_pages() is called
> +                        * with PP_FLAG_PAGE_FRAG flag in driver.
> +                        */
> +                       WARN_ON(!bias);
> +
> +                       /* already the last user */
> +                       if (!(bias - nr))
> +                               return 0;
> +
> +                       new_bias = old_bias - nr;
> +               } while (!try_cmpxchg(bias_ptr, &old_bias, new_bias));
> +
> +               WARN_ON((new_bias & PAGE_MASK) != (old_bias & PAGE_MASK));
> +
> +               bias = new_bias & ~PAGE_MASK;
> +       } else {
> +               atomic_t *v = (atomic_t *)&page->dma_addr[1];

The problem with casting like this is that it makes assumptions about
byte ordering in the case that atomic_t is a 32b value and dma_addr is
a long value.

> +
> +               if (atomic_read(v) == nr)
> +                       return 0;
> +
> +               bias = atomic_sub_return(nr, v);
> +               WARN_ON(bias < 0);
> +       }

Rather than have 2 versions of this function it might work better to
just use the atomic_long version of these functions instead. Then you
shouldn't need to have two versions of the code.

You could just modify the block on the end to check for new_frag_count
vs old_frag_count if PAGE_POOL_USE_PP_FRAG_COUNT is true, or
new_frag_count < 0 if false.

> +
> +       return bias;
> +}
> +
> +static inline void page_pool_set_bias(struct page *page, int bias)
> +{
> +       if (PAGE_POOP_USE_DMA_ADDR_1) {
> +               unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
> +
> +               dma_addr_0 &= PAGE_MASK;
> +               dma_addr_0 |= bias;
> +
> +               WRITE_ONCE(page->dma_addr[0], dma_addr_0);
> +       } else {
> +               atomic_t *v = (atomic_t *)&page->dma_addr[1];
> +
> +               atomic_set(v, bias);
> +       }

Similarly here you could just update bias to include the dma_addr in
the if case, and then use atomic_long_set for both cases.

> +}
> +
>  static inline bool is_page_pool_compiled_in(void)
>  {
>  #ifdef CONFIG_PAGE_POOL
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 78838c6..6ac5b00 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -198,6 +198,16 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>         if (dma_mapping_error(pool->p.dev, dma))
>                 return false;
>
> +       if (PAGE_POOP_USE_DMA_ADDR_1 &&
> +           WARN_ON(pool->p.flags & PP_FLAG_PAGE_FRAG &&
> +                   dma & ~PAGE_MASK)) {
> +               dma_unmap_page_attrs(pool->p.dev, dma,
> +                                    PAGE_SIZE << pool->p.order,
> +                                    pool->p.dma_dir,
> +                                    DMA_ATTR_SKIP_CPU_SYNC);
> +               return false;
> +       }
> +
>         page_pool_set_dma_addr(page, dma);
>
>         if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> --
> 2.7.4
>

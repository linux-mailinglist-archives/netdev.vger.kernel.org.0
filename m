Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 143EB3C35A8
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 19:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbhGJQ6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 12:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbhGJQ6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Jul 2021 12:58:10 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A86C0613DD;
        Sat, 10 Jul 2021 09:55:23 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id i20so23024475ejw.4;
        Sat, 10 Jul 2021 09:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wFOGf0fHXSe0uYH1tmI6V0veKuGmSA46Np9pjLsOr6k=;
        b=vYfZROn7ptBqkU3Im7OlwsNbe/A2Gh3aliTChdfXPR3HHyB3RQdZXuaH/u1YLJLAqb
         YZFhdLcpfF0SrC0yZ2QCXChwsYwest+lwWRQnWfLK1hB1R7198ESuok07s177eyVAdWN
         AGW5fYKM9GWzOi/M6+b68CPq/NCpWBe8+G9CCLimRRzulDt8pccOPon4wEwxDIorI4Pi
         3SBUVyOav/Wdq+GFKw1Vryp+qtRc2JBKCSo6Zby7Y7BFx4e8GlyqwcdKi314+TOt/RNQ
         LuMlBhxKBGwXAMs/By/irykQ7bYBaLSLx7GrUiMZpma09hTy4LCiJGfHTgZxckWrX7bL
         7KDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wFOGf0fHXSe0uYH1tmI6V0veKuGmSA46Np9pjLsOr6k=;
        b=PHb6FOLLx6vAs7lv4ZRNUx7ZO0TeDOeMBsA1ZrBVWZHYpm5IMpxIoP6i06IGgfaExn
         /Nbhnr81r1FULAKtwxoOZ4mLO5e9m0ppV40pp/FqlJX2z6jjDjCRCAGBEcFSXjXfWcOS
         IbtyvOY8zmJPUj1xYjUUKE6dotEcScuxpW6pSYdWRJlKXaftuK30NtB1DmGZ5T23LX0u
         ZZe/83usY/26bkTx1ONejbDfdgI5vlAleSNtP4KkvhlgankB3/XqLTY925RmFiRsQAOD
         Cbic7yZ8AhyScv8T9WF+R0ex5onupIp4AclJ0TxU2EPkBWK6WI1LWaR00tgXmG0kK0ac
         ESQg==
X-Gm-Message-State: AOAM530N/Rse/AkNo1qo8lUQSdo1H/MYg5wcby/ySxLipiDtwMVZGwD4
        cuSXyEJtlLrzz6qs1mQDOtHaL8kREvVT1cGSzCs=
X-Google-Smtp-Source: ABdhPJxxt9ODBsxBDJLnHxPdf/hDZpSZAa+uRdNkcG6qKfOlipYLs/GxUeR682DoS7+WWT3ZyRlwTrWTwAthPpVKyNQ=
X-Received: by 2002:a17:907:1ca4:: with SMTP id nb36mr43839266ejc.33.1625936122151;
 Sat, 10 Jul 2021 09:55:22 -0700 (PDT)
MIME-Version: 1.0
References: <1625903002-31619-1-git-send-email-linyunsheng@huawei.com> <1625903002-31619-3-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1625903002-31619-3-git-send-email-linyunsheng@huawei.com>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Sat, 10 Jul 2021 09:55:10 -0700
Message-ID: <CAKgT0UcRqRcj_zewRUH4Qe-AP_ykArK0hu76kcw2xjtvkTw07g@mail.gmail.com>
Subject: Re: [PATCH rfc v2 2/5] page_pool: add interface for getting and
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
        Marco Elver <elver@google.com>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 10, 2021 at 12:44 AM Yunsheng Lin <linyunsheng@huawei.com> wrote:
>
> As suggested by Alexander, "A DMA mapping should be page
> aligned anyway so the lower 12 bits would be reserved 0",
> so it might make more sense to repurpose the lower 12 bits
> of the dma address to store the pagecnt_bias for elevated
> refcnt case in page pool.
>
> As newly added page_pool_get_pagecnt_bias() may be called
> outside of the softirq context, so annotate the access to
> page->dma_addr[0] with READ_ONCE() and WRITE_ONCE().
>
> Other three interfaces using page->dma_addr[0] is only called
> in the softirq context during normal rx processing, hopefully
> the barrier in the rx processing will ensure the correct order
> between getting and setting pagecnt_bias.
>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  include/net/page_pool.h | 24 ++++++++++++++++++++++--
>  1 file changed, 22 insertions(+), 2 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 8d7744d..5746f17 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -200,7 +200,7 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>
>  static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>  {
> -       dma_addr_t ret = page->dma_addr[0];
> +       dma_addr_t ret = READ_ONCE(page->dma_addr[0]) & PAGE_MASK;
>         if (sizeof(dma_addr_t) > sizeof(unsigned long))
>                 ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
>         return ret;
> @@ -208,11 +208,31 @@ static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>
>  static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>  {
> -       page->dma_addr[0] = addr;
> +       unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
> +
> +       dma_addr_0 &= ~PAGE_MASK;
> +       dma_addr_0 |= (addr & PAGE_MASK);

So rather than doing all this testing and clearing it would probably
be better to add a return value to the function and do something like:

if (WARN_ON(dma_addr_0 & ~PAGE_MASK))
    return -1;

That way you could have page_pool_dma_map unmap, free the page, and
return false indicating that the DMA mapping failed with a visible
error in the event that our expectionat that the dma_addr is page
aligned is ever violated.

> +       WRITE_ONCE(page->dma_addr[0], dma_addr_0);
> +
>         if (sizeof(dma_addr_t) > sizeof(unsigned long))
>                 page->dma_addr[1] = upper_32_bits(addr);
>  }
>
> +static inline int page_pool_get_pagecnt_bias(struct page *page)
> +{
> +       return (READ_ONCE(page->dma_addr[0]) & ~PAGE_MASK);

You don't need the parenthesis around the READ_ONCE and PAGE_MASK.

> +}
> +
> +static inline void page_pool_set_pagecnt_bias(struct page *page, int bias)
> +{
> +       unsigned long dma_addr_0 = READ_ONCE(page->dma_addr[0]);
> +
> +       dma_addr_0 &= PAGE_MASK;
> +       dma_addr_0 |= (bias & ~PAGE_MASK);
> +
> +       WRITE_ONCE(page->dma_addr[0], dma_addr_0);
> +}
> +
>  static inline bool is_page_pool_compiled_in(void)
>  {
>  #ifdef CONFIG_PAGE_POOL
> --
> 2.7.4
>

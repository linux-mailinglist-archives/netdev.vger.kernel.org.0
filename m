Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DB51CA554
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 09:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726701AbgEHHkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 03:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbgEHHkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 03:40:15 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF213C05BD43
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 00:40:13 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id h9so704272wrt.0
        for <netdev@vger.kernel.org>; Fri, 08 May 2020 00:40:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jB0igkf1mdIu6waaHZEdkrIXUruW7PpEelnBwe6KEqc=;
        b=WVmGoex2UzG7O+02Q9vWs6HNKyy3mWm9QNUHhwecl9XuirnL99VdD36glEYYT+srDq
         e6e3Tmdn40PBZEXkjnsq1RiLaHVYrIWSih+p0hAIsz1hRmCWMTEEJ+obTL1n0kOFcORg
         VXIMZELrC/6eKhiSq9/kDoh8/jTAHBoWRrLDD7riJ5j7fUE8i0sKrxKwhMorcRdUjUxo
         CLAvr8iZ/g8LZrX3xkue1xQMpy0Oq3w34fqfoB8qaJ6aEcZdyLDutDp9WMz+wsaxKsO4
         MD8WQbkkApZWWJs+ud+RZqQ+T9Z+F9RpIFse7rLS/LtsVWcVt3yda8sRLCRktqqONPpB
         VUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jB0igkf1mdIu6waaHZEdkrIXUruW7PpEelnBwe6KEqc=;
        b=lOdr26yNAmvgoFqM88tzcaRsUQYW3ahMlz7u9ojlga7SLLTL4U7FBhJqY5S5YLGqyd
         dp+KnID7EX7LhWuJonOxoqW9/lR7qVjXkSidJIFsEvWO1SbKNE0r1ENQvbq9i89Oj/sa
         BBAEw2PHtO+/1/FaQvqV9WmdDocm7QuRe8UaP23qbdUfvRYAqanYLbw7EmEoHfl1HgcG
         VaUZa7wuGxUbQEcG0uOJ8YUspTG6AojWi9wbQKzIZzbM0vWuGvmbQ/Cf12/aiBBHj3AM
         1qWsjqAATHBVED3wnwqhulPIaqv8XY8qhaDCo99wU6fmmD4uzaONcadNeTJp9gj+dptJ
         0pKA==
X-Gm-Message-State: AGi0PuayKzvNGFQc6JXuVm0oy6/Qexfe5+MQZIM/foYIfk/ewbecCzeG
        c+clqEUub3+K7U3wgbEM8Ugke12qNJo3O8y27AE=
X-Google-Smtp-Source: APiQypI7PtBR2OeEWu4RHK05x234ay5xb93WDYq1/08jNYMcFtpqhDYnGp0nVX6teStD6Y/yZuiQXtSKrfp11ADv7FM=
X-Received: by 2002:a5d:6283:: with SMTP id k3mr1351733wru.62.1588923612730;
 Fri, 08 May 2020 00:40:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200508040728.24202-1-haokexin@gmail.com>
In-Reply-To: <20200508040728.24202-1-haokexin@gmail.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 8 May 2020 13:10:00 +0530
Message-ID: <CA+sq2CfoY1aRC2BernvqaMGgTgCByM+yq19-Vak0KJqxEU-5Eg@mail.gmail.com>
Subject: Re: [PATCH] octeontx2-pf: Use the napi_alloc_frag() to alloc the pool buffers
To:     Kevin Hao <haokexin@gmail.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        Sunil Goutham <sgoutham@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        hariprasad <hkelam@marvell.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 9:43 AM Kevin Hao <haokexin@gmail.com> wrote:
>
> In the current codes, the octeontx2 uses its own method to allocate
> the pool buffers, but there are some issues in this implementation.
> 1. We have to run the otx2_get_page() for each allocation cycle and
>    this is pretty error prone. As I can see there is no invocation
>    of the otx2_get_page() in otx2_pool_refill_task(), this will leave
>    the allocated pages have the wrong refcount and may be freed wrongly.
> 2. It wastes memory. For example, if we only receive one packet in a
>    NAPI RX cycle, and then allocate a 2K buffer with otx2_alloc_rbuf()
>    to refill the pool buffers and leave the remain area of the allocated
>    page wasted. On a kernel with 64K page, 62K area is wasted.
>
> IMHO it is really unnecessary to implement our own method for the
> buffers allocate, we can reuse the napi_alloc_frag() to simplify
> our code.
>
> Signed-off-by: Kevin Hao <haokexin@gmail.com>
> ---
>  .../marvell/octeontx2/nic/otx2_common.c       | 51 ++++++++-----------
>  .../marvell/octeontx2/nic/otx2_common.h       | 15 +-----
>  .../marvell/octeontx2/nic/otx2_txrx.c         |  3 +-
>  .../marvell/octeontx2/nic/otx2_txrx.h         |  4 --
>  4 files changed, 22 insertions(+), 51 deletions(-)
>
> diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> index f1d2dea90a8c..15fa1ad57f88 100644
> --- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> +++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.c
> @@ -379,40 +379,32 @@ void otx2_config_irq_coalescing(struct otx2_nic *pfvf, int qidx)
>                      (pfvf->hw.cq_ecount_wait - 1));
>  }
>
> -dma_addr_t otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool,
> -                          gfp_t gfp)
> +dma_addr_t _otx2_alloc_rbuf(struct otx2_nic *pfvf, struct otx2_pool *pool)
>  {
>         dma_addr_t iova;
> +       u8 *buf;
>
> -       /* Check if request can be accommodated in previous allocated page */
> -       if (pool->page && ((pool->page_offset + pool->rbsize) <=
> -           (PAGE_SIZE << pool->rbpage_order))) {
> -               pool->pageref++;
> -               goto ret;
> -       }
> -
> -       otx2_get_page(pool);
> -
> -       /* Allocate a new page */
> -       pool->page = alloc_pages(gfp | __GFP_COMP | __GFP_NOWARN,
> -                                pool->rbpage_order);
> -       if (unlikely(!pool->page))
> +       buf = napi_alloc_frag(pool->rbsize);
> +       if (unlikely(!buf))
>                 return -ENOMEM;
>
> -       pool->page_offset = 0;
> -ret:
> -       iova = (u64)otx2_dma_map_page(pfvf, pool->page, pool->page_offset,
> -                                     pool->rbsize, DMA_FROM_DEVICE);
> -       if (!iova) {
> -               if (!pool->page_offset)
> -                       __free_pages(pool->page, pool->rbpage_order);
> -               pool->page = NULL;
> +       iova = dma_map_single(pfvf->dev, buf, pool->rbsize, DMA_FROM_DEVICE);
> +       if (unlikely(dma_mapping_error(pfvf->dev, iova)))
>                 return -ENOMEM;

Use DMA_ATTR_SKIP_CPU_SYNC while mapping the buffer.

Thanks,
Sunil.

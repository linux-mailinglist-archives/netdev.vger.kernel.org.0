Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08543662CC3
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 18:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbjAIRbq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 12:31:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236755AbjAIRbS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 12:31:18 -0500
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB7BB87C
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 09:31:07 -0800 (PST)
Received: by mail-lf1-x129.google.com with SMTP id f34so14072056lfv.10
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 09:31:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=o37AcJEUaJU5V1Za+eAxuPSBm9n29u/Fpw2wr9C7DtQ=;
        b=msfhnd0wvCf5N6dMfcEYd1RnIac92f89ZQT8bps/A30qUz7f+hElb3sOW7wNK42UXt
         DnF2d4TTsehxYeeOTvlakCcWdVsRPil1d3MP/tZY8EdGHwSqsd1cUYVSeDt4FWYGqsPw
         g6g+RTOvCVvQvVn0PK5lTKK+3U2e6m/Z1rIdMvO1sU1k8Ta10KDQzI4K34JrYe8NfQUi
         F9TGAyHLdAiQYnOEVX4ND06HrB+75tCLTienGjUVK69D50+BSfGu0xyxOi678hQLcI8C
         Y/tU02oW6jxuzJA2r3vbezzovibukexk7mSmbicFIyDAXOW0wXtj8VHzgqKaH5CIMmxS
         ZEGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=o37AcJEUaJU5V1Za+eAxuPSBm9n29u/Fpw2wr9C7DtQ=;
        b=g0T8c9tUNQ96duWpepSHaA0gp+Dd5dyM0Y+SHwOu8o7uYq1cpqvqPlBqTjgPRG/BFG
         RbtOxSOhlmlfuQ/7Hvd824ARl3omzcuoXQncWBGDAbtgAL5168K9zUi3pXGwvv9iSgFc
         L+CqsN69mw2Zt2TMHqmIZtUaFmVydZ9Hfz2e1hMEqs8M68516Kzi7Fsc8S1m1jk6f2j0
         fXXibNeJuLZdRfX8iv+0s7yxMJdqAuD4CUOV/4dpCrBJgCPxj4BqXKrxeLXAFcw+YDwK
         UWuafwy6bdHKJNPlIY4vJ8SXEAaGm5oFzBhVCm6QEXMZvkVeE6oqe3ncI9E94DMxOTQp
         GuxA==
X-Gm-Message-State: AFqh2kqYongasn8gTb5XGRHB6xOVmZ8dcxz25L4yUZnRIkhc2LNCJp50
        Z4g4yKC94HAHbVvDBpRNznYPjGr83Jg971WTt3cyLR9Hx9mB9gYx
X-Google-Smtp-Source: AMrXdXspDP6Qxnnn56o6fxGjptGFL2CHy7RXas0ePAG6MdB3P+MkMKOMT5MMxHspKmdR/ooznwTZjiV7h1FJzqxuQv0=
X-Received: by 2002:a05:6512:3b22:b0:4b6:4c3e:c2fa with SMTP id
 f34-20020a0565123b2200b004b64c3ec2famr4639888lfv.243.1673285465941; Mon, 09
 Jan 2023 09:31:05 -0800 (PST)
MIME-Version: 1.0
References: <20230105214631.3939268-1-willy@infradead.org> <20230105214631.3939268-4-willy@infradead.org>
In-Reply-To: <20230105214631.3939268-4-willy@infradead.org>
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
Date:   Mon, 9 Jan 2023 19:30:30 +0200
Message-ID: <CAC_iWj+bDVMptma_DjQkCZzcardXxShJ965=6zc0_6ffciQhXw@mail.gmail.com>
Subject: Re: [PATCH v2 03/24] page_pool: Add netmem_set_dma_addr() and netmem_get_dma_addr()
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Matthew

On Thu, 5 Jan 2023 at 23:46, Matthew Wilcox (Oracle)
<willy@infradead.org> wrote:
>
> Turn page_pool_set_dma_addr() and page_pool_get_dma_addr() into
> wrappers.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  include/net/page_pool.h | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 84b4ea8af015..196b585763d9 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -449,21 +449,31 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>  #define PAGE_POOL_DMA_USE_PP_FRAG_COUNT        \
>                 (sizeof(dma_addr_t) > sizeof(unsigned long))
>
> -static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
> +static inline dma_addr_t netmem_get_dma_addr(struct netmem *nmem)

Ideally, we'd like to avoid having people call these directly and use
the page_pool_(get|set)_dma_addr wrappers.  Can we add a comment in
v3?

>  {
> -       dma_addr_t ret = page->dma_addr;
> +       dma_addr_t ret = nmem->dma_addr;
>
>         if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> -               ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
> +               ret |= (dma_addr_t)nmem->dma_addr_upper << 16 << 16;
>
>         return ret;
>  }
>
> -static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> +static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
> +{
> +       return netmem_get_dma_addr(page_netmem(page));
> +}
> +
> +static inline void netmem_set_dma_addr(struct netmem *nmem, dma_addr_t addr)
>  {
> -       page->dma_addr = addr;
> +       nmem->dma_addr = addr;
>         if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> -               page->dma_addr_upper = upper_32_bits(addr);
> +               nmem->dma_addr_upper = upper_32_bits(addr);
> +}
> +
> +static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
> +{
> +       netmem_set_dma_addr(page_netmem(page), addr);
>  }
>
>  static inline bool is_page_pool_compiled_in(void)
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

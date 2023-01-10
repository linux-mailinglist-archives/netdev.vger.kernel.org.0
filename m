Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 913C5663D17
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:40:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238215AbjAJJkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238234AbjAJJj7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:39:59 -0500
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7196149171
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:39:58 -0800 (PST)
Received: by mail-ed1-x530.google.com with SMTP id i9so16667673edj.4
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:39:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=05rLE9bIAJu7vOSCUFT1+ZmOdeM8fWt9niDLqe6WzVs=;
        b=F4bdMogB+1TKhJNRHbOeR3AtyP6wqjT2gyaWA1yZoGvkCLLkh7U3QGFG4n+89rKzrl
         +qhUAC/0ssj5H4btBJl+xMYONvQceky8vofD+GoDl3Y5EbFAHteebtU2sOe1oi40RrzB
         5UPWxmch/gQyfITXFBUf/IBU1ORqGYeFUt+/rQcPpYQ6k4DPqPM16Mwi13Rs7ZsvtIxK
         pNo8Rj2mnDKj2S/VM7ixA9yZKZyQCWW199epGDXxXnktwiDMKmE9XUHJ7u5G1HO7p+w5
         I9X5KcGdCG0TBJJsewf02GMDOnmPmKeKpRBDBGVMOwMxHCfJRnV770WsQPshKBEb3zJr
         IZ1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=05rLE9bIAJu7vOSCUFT1+ZmOdeM8fWt9niDLqe6WzVs=;
        b=IfWCR9xNdbZD/nYPspPRnQwzMJavB0ZA2C7GC70fQ7OlUnEDtwPZmbhcsMXzeXlvA9
         yFUxxQC1grg14PfoKXttCyynSv+das+JvESDRLWCPn4y82TcZBUyer9g8+GZD4Uvbk/A
         RhHak5S6vUrQhTqQvbVMYCCuIWblFrhl+LLoDhCn/zv8nsvPB7bIlVfFRsfjBZO37Uj4
         AyC8kuZuqR8YCh7yKFgrOXSOsCo8YB3HujVCqTDqn8HgPHPPWnvJKS7SD3uQS+bS3xnS
         Z3jTlFwlKd71idRlGRfHMl5M5uDA4WBwYND/m1RJx8UZ3uU7P7SC7TN929KSXt0t788S
         2Ugg==
X-Gm-Message-State: AFqh2kqDuTNF5JFKySRdsk5xbFgtyRB08wCfzd7KfD+BQ2+2Fkn4DqLB
        Ogt0KLWAx79ooLXuiwtPcDvFzKSiNXN/Yj2T
X-Google-Smtp-Source: AMrXdXvp8XNK/R9fQ7FPvDNdxg8A8r9blnlBuQZc6FtzMC0nmBdnT3//IV5yF+rW24grRQII7txYJg==
X-Received: by 2002:a05:6402:f17:b0:489:5852:fbb5 with SMTP id i23-20020a0564020f1700b004895852fbb5mr40063159eda.16.1673343597089;
        Tue, 10 Jan 2023 01:39:57 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id q24-20020a056402249800b0046ac460da13sm4726222eda.53.2023.01.10.01.39.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 01:39:56 -0800 (PST)
Date:   Tue, 10 Jan 2023 11:39:54 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 06/24] page_pool: Convert page_pool_return_page() to
 page_pool_return_netmem()
Message-ID: <Y70yaoj4Uz+XQYXb@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-7-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-7-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:13PM +0000, Matthew Wilcox (Oracle) wrote:
> Removes a call to compound_head(), saving 464 bytes of kernel text
> as page_pool_return_page() is inlined seven times.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/core/page_pool.c | 14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 4e985502c569..b606952773a6 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -220,7 +220,13 @@ struct page_pool *page_pool_create(const struct page_pool_params *params)
>  }
>  EXPORT_SYMBOL(page_pool_create);
>
> -static void page_pool_return_page(struct page_pool *pool, struct page *page);
> +static void page_pool_return_netmem(struct page_pool *pool, struct netmem *nm);
> +
> +static inline
> +void page_pool_return_page(struct page_pool *pool, struct page *page)
> +{
> +	page_pool_return_netmem(pool, page_netmem(page));
> +}
>
>  noinline
>  static struct page *page_pool_refill_alloc_cache(struct page_pool *pool)
> @@ -499,11 +505,11 @@ void page_pool_release_netmem(struct page_pool *pool, struct netmem *nmem)
>  EXPORT_SYMBOL(page_pool_release_netmem);
>
>  /* Return a page to the page allocator, cleaning up our state */
> -static void page_pool_return_page(struct page_pool *pool, struct page *page)
> +static void page_pool_return_netmem(struct page_pool *pool, struct netmem *nmem)
>  {
> -	page_pool_release_page(pool, page);
> +	page_pool_release_netmem(pool, nmem);
>
> -	put_page(page);
> +	netmem_put(nmem);
>  	/* An optimization would be to call __free_pages(page, pool->p.order)
>  	 * knowing page is not part of page-cache (thus avoiding a
>  	 * __page_cache_release() call).
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791DD663E8A
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231260AbjAJKr6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:47:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238059AbjAJKra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:47:30 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0FB72BED
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:47:28 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id u19so27416868ejm.8
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:47:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mroQYB+qcZhAc3ilXFdRxv656azL+aF3mo4oWme/p7Y=;
        b=D5yyUfbvNqHYhHjNC/BFZvUGo9udqK8SgAeiUPd15DAySgLJk6Zo3A7AFhnU/MFQIC
         TUOcq+thlne2F7N09seduYA5JyTAGu0STf/5zxoFrW75bG4eX0zxch56dhev3W1Rhbiz
         J29iinoEd51JHGZ2XFDDStyrych1rz7wVLofadHpLR1NlvYni9132i+JuY2Xm2Q1V1BU
         t7tjeQqP3/W26Etv09GBzSexuCzG3tFnS/lZDmxOYYi6VdvEdofiHyLChiBB8GWtouOf
         Fw2JrAXHVATxNh/LqugW7ngbCIqcBP6fSDKswHx5DqNJpte6h+kdJ3H38frUQ+EsHdk0
         PmLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mroQYB+qcZhAc3ilXFdRxv656azL+aF3mo4oWme/p7Y=;
        b=IuHiH4NRWxXwPqYRb+UVcySeGG1tcQOMgXkXGpLQ2gVJVtpldJJ3am5uXAaUvpmT0B
         LbEMfUz11LtS5MWTVtp+8df+QCGWrfh/E9OrmfL06mJxAMpjG9xKyCWAUZHjMxs5o4t4
         I4siQjKEw8T55jNLooCwR/Np3RWpAUx+TUVCdg9TH6/ZeRgonVy1jf5/ptHNUa80/hDn
         0FWBZ1h2nVqsvmJMZzyd8XzuOUz8mg9zqYEAyDGVLzeFIUZF1zuP4vVxIa+diJgt5UYL
         AL8aNaYaSxPdraM0cqcVCsnzBYJ+pJrCiMcVcWccckIwGI9QffZtNuIW/YXFgu2UYpy5
         33iw==
X-Gm-Message-State: AFqh2kplcclNgdrocXD6Fjp2PemDwYf11o8YddL9THF2o3XQHoYbikWB
        BYUe14DFHVt7Emn0AoZ4SQWN4+/21uoeLnPv
X-Google-Smtp-Source: AMrXdXuKJ3cNh2RxhOoknb5xSyX7IJXSwRaWnLnOFj9lekY5uPJ/qsBjra5oymc1mx+9pQAYqqQ8rA==
X-Received: by 2002:a17:907:d38c:b0:83c:1a1e:1efe with SMTP id vh12-20020a170907d38c00b0083c1a1e1efemr57094303ejc.6.1673347647353;
        Tue, 10 Jan 2023 02:47:27 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id 15-20020a170906310f00b00738795e7d9bsm4704648ejx.2.2023.01.10.02.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 02:47:26 -0800 (PST)
Date:   Tue, 10 Jan 2023 12:47:24 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 13/24] page_pool: Convert
 page_pool_dma_sync_for_device() to take a netmem
Message-ID: <Y71CPHfsG3IpJi4m@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-14-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-14-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:20PM +0000, Matthew Wilcox (Oracle) wrote:
> Change all callers.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/core/page_pool.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index c7ea487acbaa..3fa03baa80ee 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -299,10 +299,10 @@ static struct netmem *__page_pool_get_cached(struct page_pool *pool)
>  }
>
>  static void page_pool_dma_sync_for_device(struct page_pool *pool,
> -					  struct page *page,
> +					  struct netmem *nmem,
>  					  unsigned int dma_sync_size)
>  {
> -	dma_addr_t dma_addr = page_pool_get_dma_addr(page);
> +	dma_addr_t dma_addr = netmem_get_dma_addr(nmem);
>
>  	dma_sync_size = min(dma_sync_size, pool->p.max_len);
>  	dma_sync_single_range_for_device(pool->p.dev, dma_addr,
> @@ -329,7 +329,7 @@ static bool page_pool_dma_map(struct page_pool *pool, struct netmem *nmem)
>  	page_pool_set_dma_addr(page, dma);
>
>  	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> -		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> +		page_pool_dma_sync_for_device(pool, nmem, pool->p.max_len);
>
>  	return true;
>  }
> @@ -576,7 +576,7 @@ __page_pool_put_netmem(struct page_pool *pool, struct netmem *nmem,
>  		/* Read barrier done in netmem_ref_count / READ_ONCE */
>
>  		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> -			page_pool_dma_sync_for_device(pool, netmem_page(nmem),
> +			page_pool_dma_sync_for_device(pool, nmem,
>  						      dma_sync_size);
>
>  		if (allow_direct && in_serving_softirq() &&
> @@ -676,6 +676,7 @@ EXPORT_SYMBOL(page_pool_put_page_bulk);
>  static struct page *page_pool_drain_frag(struct page_pool *pool,
>  					 struct page *page)
>  {
> +	struct netmem *nmem = page_netmem(page);
>  	long drain_count = BIAS_MAX - pool->frag_users;
>
>  	/* Some user is still using the page frag */
> @@ -684,7 +685,7 @@ static struct page *page_pool_drain_frag(struct page_pool *pool,
>
>  	if (page_ref_count(page) == 1 && !page_is_pfmemalloc(page)) {
>  		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> -			page_pool_dma_sync_for_device(pool, page, -1);
> +			page_pool_dma_sync_for_device(pool, nmem, -1);
>
>  		return page;
>  	}
> --
> 2.35.1
>
Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>


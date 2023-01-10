Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFA22663D38
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 10:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238168AbjAJJr3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 04:47:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237882AbjAJJrL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 04:47:11 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35C4933E
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:47:06 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id fc4so27038744ejc.12
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 01:47:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lHERGX7BrEBZikVdtVo4/Ae6G/xz87siiQLUHU0CyFU=;
        b=UmxTH+Ni6Xl3kwtKXtwW4J/Ke0Ue7dA8lr9xZOQsi44PNOhFG34szHyYuoYlA6RLCr
         s3Ox8LMspPbqaZF9T5KgteNv3PmKNKpfhqLvX/KDGXbx7A9EfVjz+9WEjCNbbGe1mmPi
         6zzzcD8ytUZgWLNE4Aokj8TFMHaGljgmv+xraaPHAwvKhPM891rBxFBiTjOejc8P0gbm
         f9aTIjAEDpLPrUOx3b6O9SNvJ+Yrpfyru9VXIqLuzm7K9OfHWn2TPBNa6wiGqiHcvkAj
         rj2csLMRPSG8/nmLN6g/lXsi7IG+9SlTyiHpyigXhPPlEjhNVLMS/LxTF+dxYMfOh07B
         T2sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lHERGX7BrEBZikVdtVo4/Ae6G/xz87siiQLUHU0CyFU=;
        b=qhUOprjZKSSY4g5QGVkojU96HIk2870s9MxkFMXUMPJ4vyXWiLakJ5aM+0lwAce3jm
         2MYHUKzdMPXHucgdDJNZfrQrdJ2YFHzCTs0MeZkk92dDppxuVioOUdLOi6K3FHz7aT4e
         oMcZvg3Q4FWD2DG0y/eT24eT26rXTtK5FsfE8Wwy1GucVcx18A1Uo9PngKg+rXweUGR6
         qeCEaf3mRmLxW87AgPIhxnNATnHfQwKkDm9NCYUxOoEd6DmbvlVtbwCM670rmDKL6Hf6
         xtS3RNP3u8hYaBV+UTEv87QZZZ1A9u30/HdQcF1UJzYpgW7FhHT6yyOo796azcZ5b6It
         NUQw==
X-Gm-Message-State: AFqh2kpR2jzaavwltBO4+0o6Z7kq0FnU2hsod4mST+UyINZPCKRVxatU
        wBFXiWUOkqxLFgz+ZlGFRxzTxg==
X-Google-Smtp-Source: AMrXdXs5X4zufYlBBHo06avn75sPIvTtEUZo8PL036U/EHKUNnYtIL5lqkUSCbXosEnvuqtHFMPESQ==
X-Received: by 2002:a17:907:6d98:b0:7c1:12b0:7d5d with SMTP id sb24-20020a1709076d9800b007c112b07d5dmr76045236ejc.4.1673344024622;
        Tue, 10 Jan 2023 01:47:04 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id k2-20020a170906970200b0073dbaeb50f6sm4649027ejx.169.2023.01.10.01.47.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 01:47:04 -0800 (PST)
Date:   Tue, 10 Jan 2023 11:47:02 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 07/24] page_pool: Convert __page_pool_put_page() to
 __page_pool_put_netmem()
Message-ID: <Y700FlsBvAoBKkKv@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-8-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-8-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:14PM +0000, Matthew Wilcox (Oracle) wrote:
> Removes the call to compound_head() hidden in put_page() which
> saves 169 bytes of kernel text as __page_pool_put_page() is
> inlined twice.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/core/page_pool.c | 29 +++++++++++++++++++----------
>  1 file changed, 19 insertions(+), 10 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index b606952773a6..8f3f7cc5a2d5 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -558,8 +558,8 @@ static bool page_pool_recycle_in_cache(struct page *page,
>   * If the page refcnt != 1, then the page will be returned to memory
>   * subsystem.
>   */
> -static __always_inline struct page *
> -__page_pool_put_page(struct page_pool *pool, struct page *page,
> +static __always_inline struct netmem *
> +__page_pool_put_netmem(struct page_pool *pool, struct netmem *nmem,
>  		     unsigned int dma_sync_size, bool allow_direct)
>  {
>  	/* This allocator is optimized for the XDP mode that uses
> @@ -571,19 +571,20 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>  	 * page is NOT reusable when allocated when system is under
>  	 * some pressure. (page_is_pfmemalloc)
>  	 */
> -	if (likely(page_ref_count(page) == 1 && !page_is_pfmemalloc(page))) {
> -		/* Read barrier done in page_ref_count / READ_ONCE */
> +	if (likely(netmem_ref_count(nmem) == 1 &&
> +		   !netmem_is_pfmemalloc(nmem))) {
> +		/* Read barrier done in netmem_ref_count / READ_ONCE */
>
>  		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> -			page_pool_dma_sync_for_device(pool, page,
> +			page_pool_dma_sync_for_device(pool, netmem_page(nmem),
>  						      dma_sync_size);
>
>  		if (allow_direct && in_serving_softirq() &&
> -		    page_pool_recycle_in_cache(page, pool))
> +		    page_pool_recycle_in_cache(netmem_page(nmem), pool))
>  			return NULL;
>
>  		/* Page found as candidate for recycling */
> -		return page;
> +		return nmem;
>  	}
>  	/* Fallback/non-XDP mode: API user have elevated refcnt.
>  	 *
> @@ -599,13 +600,21 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>  	 * will be invoking put_page.
>  	 */
>  	recycle_stat_inc(pool, released_refcnt);
> -	/* Do not replace this with page_pool_return_page() */
> -	page_pool_release_page(pool, page);
> -	put_page(page);
> +	/* Do not replace this with page_pool_return_netmem() */
> +	page_pool_release_netmem(pool, nmem);
> +	netmem_put(nmem);
>
>  	return NULL;
>  }
>
> +static __always_inline struct page *
> +__page_pool_put_page(struct page_pool *pool, struct page *page,
> +		     unsigned int dma_sync_size, bool allow_direct)
> +{
> +	return netmem_page(__page_pool_put_netmem(pool, page_netmem(page),
> +						dma_sync_size, allow_direct));
> +}
> +
>  void page_pool_put_defragged_page(struct page_pool *pool, struct page *page,
>  				  unsigned int dma_sync_size, bool allow_direct)
>  {
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>


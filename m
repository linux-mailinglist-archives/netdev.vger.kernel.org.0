Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4B1BFCE1D
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbfKNSsl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:48:41 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:38991 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726549AbfKNSsl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:48:41 -0500
Received: by mail-pf1-f194.google.com with SMTP id x28so4879472pfo.6
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version;
        bh=gepp7D4X8EWuU2PgyCmGcalSG4D7hwX4SqFLNGRTKBw=;
        b=NBrKJDwkMO2AVy05m5gUqtRlX3ZTdQu870pfu4hvKNk0eBI2BeHaaNAM5DxZ2BvNrs
         Or9wAU0AHTaemRiMdB3g7F78OIuagi2srC2iRTsxzng/d86Aszj5PD29dqzNyzUGevgh
         e8EIPFfESLUPexOnj8QKg9vpFQ81wcwFPOIPnnEYuK99UEFBBaYXIudJy5e5erzJJ3e9
         w1CTHEie5Z7sQcRXFCYlQoGsPaWRw0TBMyTqgB4Y22Lj7jsRYgw0AKaL/pNtX062Q6d/
         EMnINtT1ulNw5KpSD4RKdPJW8Nz8uFLb3FbKejd8cPn7eATS6T+7cQ4ODEDz0/O+xnjX
         WBMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version;
        bh=gepp7D4X8EWuU2PgyCmGcalSG4D7hwX4SqFLNGRTKBw=;
        b=SjOMCjk/JPSMvhZYLSMN3N2C9+VBY6Vu2FyGE8c9ZkczP7iPWYJsKIrZyUcwhtPHid
         iIuYAtBRTZcv2II0cbpeL7svt2dF4kW3XpW6Wsg51D4xWy2aINv7zlb1A87L2OVWqaMJ
         FjSwyed8FLCAvex3HZOhP03uZu7uHf3biOxw59gcWSFFcEDitWadL6MzB20h4vgGXo5G
         6/V5l44KzxTWexlcCfzRMkgFxBePHgpFD5MZF/rcpe251UjPBhTo43MUijrDF4fA5EnH
         4c5u309vX5Qq/hvjmVBbX9LpG4+JODbNAcqUAdZaBDPDUinaSpl24rcIlKvNk3xTqbg9
         5Sqw==
X-Gm-Message-State: APjAAAXOMy6eSXG+swMbNYvTGU7ImaOZrzj8yJiVtVUZlA1h3/Vgy/9m
        pO75kSCcsdgBEicC8lzxvf5x7Bm9
X-Google-Smtp-Source: APXvYqxVV8iSvkXk29iNaMYeR0qjDUIe0tDQ7IcSlS5HOnsGgh7+JprbUErXJVAvvag8SbsVvfjEJg==
X-Received: by 2002:aa7:96e2:: with SMTP id i2mr10238024pfq.256.1573757319938;
        Thu, 14 Nov 2019 10:48:39 -0800 (PST)
Received: from [172.20.189.1] ([2620:10d:c090:180::dd67])
        by smtp.gmail.com with ESMTPSA id b82sm7542930pfb.33.2019.11.14.10.48.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 10:48:39 -0800 (PST)
From:   "Jonathan Lemon" <jonathan.lemon@gmail.com>
To:     "Lorenzo Bianconi" <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, thomas.petazzoni@bootlin.com,
        brouer@redhat.com, ilias.apalodimas@linaro.org,
        matteo.croce@redhat.com
Subject: Re: [PATCH net-next 2/3] net: page_pool: add the possibility to sync
 DMA memory for non-coherent devices
Date:   Thu, 14 Nov 2019 10:48:38 -0800
X-Mailer: MailMate (1.13r5655)
Message-ID: <6BF4C165-2AA2-49CC-B452-756CD0830129@gmail.com>
In-Reply-To: <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
References: <cover.1573383212.git.lorenzo@kernel.org>
 <68229f90060d01c1457ac945b2f6524e2aa27d05.1573383212.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10 Nov 2019, at 4:09, Lorenzo Bianconi wrote:

> Introduce the following parameters in order to add the possibility to 
> sync
> DMA memory area before putting allocated buffers in the page_pool 
> caches:
> - sync: set to 1 if device is non cache-coherent and needs to flush 
> DMA
>   area
> - offset: DMA address offset where the DMA engine starts copying rx 
> data
> - max_len: maximum DMA memory size page_pool is allowed to flush. This
>   is currently used in __page_pool_alloc_pages_slow routine when pages
>   are allocated from page allocator
> These parameters are supposed to be set by device drivers
>
> Tested-by: Matteo Croce <mcroce@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/page_pool.h | 11 +++++++----
>  net/core/page_pool.c    | 39 +++++++++++++++++++++++++++++++++------
>  2 files changed, 40 insertions(+), 10 deletions(-)
>
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 2cbcdbdec254..defbfd90ab46 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -65,6 +65,9 @@ struct page_pool_params {
>  	int		nid;  /* Numa node id to allocate from pages from */
>  	struct device	*dev; /* device, for DMA pre-mapping purposes */
>  	enum dma_data_direction dma_dir; /* DMA mapping direction */
> +	unsigned int	max_len; /* max DMA sync memory size */
> +	unsigned int	offset;  /* DMA addr offset */
> +	u8 sync;
>  };

How about using PP_FLAG_DMA_SYNC instead of another flag word?
(then it can also be gated on having DMA_MAP enabled)
-- 
Jonathan

>
>  struct page_pool {
> @@ -150,8 +153,8 @@ static inline void page_pool_destroy(struct 
> page_pool *pool)
>  }
>
>  /* Never call this directly, use helpers below */
> -void __page_pool_put_page(struct page_pool *pool,
> -			  struct page *page, bool allow_direct);
> +void __page_pool_put_page(struct page_pool *pool, struct page *page,
> +			  unsigned int dma_sync_size, bool allow_direct);
>
>  static inline void page_pool_put_page(struct page_pool *pool,
>  				      struct page *page, bool allow_direct)
> @@ -160,14 +163,14 @@ static inline void page_pool_put_page(struct 
> page_pool *pool,
>  	 * allow registering MEM_TYPE_PAGE_POOL, but shield linker.
>  	 */
>  #ifdef CONFIG_PAGE_POOL
> -	__page_pool_put_page(pool, page, allow_direct);
> +	__page_pool_put_page(pool, page, 0, allow_direct);
>  #endif
>  }
>  /* Very limited use-cases allow recycle direct */
>  static inline void page_pool_recycle_direct(struct page_pool *pool,
>  					    struct page *page)
>  {
> -	__page_pool_put_page(pool, page, true);
> +	__page_pool_put_page(pool, page, 0, true);
>  }
>
>  /* API user MUST have disconnected alloc-side (not allowed to call
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 5bc65587f1c4..af9514c2d15b 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -112,6 +112,17 @@ static struct page *__page_pool_get_cached(struct 
> page_pool *pool)
>  	return page;
>  }
>
> +/* Used for non-coherent devices */
> +static void page_pool_dma_sync_for_device(struct page_pool *pool,
> +					  struct page *page,
> +					  unsigned int dma_sync_size)
> +{
> +	dma_sync_size = min(dma_sync_size, pool->p.max_len);
> +	dma_sync_single_range_for_device(pool->p.dev, page->dma_addr,
> +					 pool->p.offset, dma_sync_size,
> +					 pool->p.dma_dir);
> +}
> +
>  /* slow path */
>  noinline
>  static struct page *__page_pool_alloc_pages_slow(struct page_pool 
> *pool,
> @@ -156,6 +167,10 @@ static struct page 
> *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  	}
>  	page->dma_addr = dma;
>
> +	/* non-coherent devices - flush memory */
> +	if (pool->p.sync)
> +		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> +
>  skip_dma_map:
>  	/* Track how many pages are held 'in-flight' */
>  	pool->pages_state_hold_cnt++;
> @@ -255,7 +270,8 @@ static void __page_pool_return_page(struct 
> page_pool *pool, struct page *page)
>  }
>
>  static bool __page_pool_recycle_into_ring(struct page_pool *pool,
> -				   struct page *page)
> +					  struct page *page,
> +					  unsigned int dma_sync_size)
>  {
>  	int ret;
>  	/* BH protection not needed if current is serving softirq */
> @@ -264,6 +280,10 @@ static bool __page_pool_recycle_into_ring(struct 
> page_pool *pool,
>  	else
>  		ret = ptr_ring_produce_bh(&pool->ring, page);
>
> +	/* non-coherent devices - flush memory */
> +	if (ret == 0 && pool->p.sync)
> +		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
> +
>  	return (ret == 0) ? true : false;
>  }
>
> @@ -273,18 +293,23 @@ static bool __page_pool_recycle_into_ring(struct 
> page_pool *pool,
>   * Caller must provide appropriate safe context.
>   */
>  static bool __page_pool_recycle_direct(struct page *page,
> -				       struct page_pool *pool)
> +				       struct page_pool *pool,
> +				       unsigned int dma_sync_size)
>  {
>  	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE))
>  		return false;
>
>  	/* Caller MUST have verified/know (page_ref_count(page) == 1) */
>  	pool->alloc.cache[pool->alloc.count++] = page;
> +
> +	/* non-coherent devices - flush memory */
> +	if (pool->p.sync)
> +		page_pool_dma_sync_for_device(pool, page, dma_sync_size);
>  	return true;
>  }
>
> -void __page_pool_put_page(struct page_pool *pool,
> -			  struct page *page, bool allow_direct)
> +void __page_pool_put_page(struct page_pool *pool, struct page *page,
> +			  unsigned int dma_sync_size, bool allow_direct)
>  {
>  	/* This allocator is optimized for the XDP mode that uses
>  	 * one-frame-per-page, but have fallbacks that act like the
> @@ -296,10 +321,12 @@ void __page_pool_put_page(struct page_pool 
> *pool,
>  		/* Read barrier done in page_ref_count / READ_ONCE */
>
>  		if (allow_direct && in_serving_softirq())
> -			if (__page_pool_recycle_direct(page, pool))
> +			if (__page_pool_recycle_direct(page, pool,
> +						       dma_sync_size))
>  				return;
>
> -		if (!__page_pool_recycle_into_ring(pool, page)) {
> +		if (!__page_pool_recycle_into_ring(pool, page,
> +						   dma_sync_size)) {
>  			/* Cache full, fallback to free pages */
>  			__page_pool_return_page(pool, page);
>  		}
> -- 
> 2.21.0

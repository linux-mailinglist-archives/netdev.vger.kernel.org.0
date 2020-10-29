Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2AAD29E49E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730243AbgJ2HkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbgJ2HYv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:51 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBF93C08EA7C
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 00:08:52 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s9so1538840wro.8
        for <netdev@vger.kernel.org>; Thu, 29 Oct 2020 00:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=90tbSpftzM+wEfef3WTFwlNnTYj4eB/xYx32SzM4xzY=;
        b=wd3BV9e7/tLO+tTEwJuHf0XowRZux2zcVXGkWnmWxHKaABtDBZbBMJhMsBXsKICwMx
         feRmzUDOoP0VZUDY99ZbnIjrSxCy+Riwq/xzNFtM7X2XAq2Yb1anaoxGJn6QS6mN15v0
         JmQcbx1RGPZiOK4c8hrNPxtuEJCUWZTwh3eAzk4W/EuTvDWz6NBcF7c7YKJ7PlM0jdeM
         2vPUx96xM+HmpSsvTeBqzpr8r6oOIiHOIxW6Iqw3WBL9LiHoYvEtAPsRIHMn6GdK1n6t
         S0CpK9gIHMs+PBsQnGcmfh73bQhw1WkpHWQTBlz9Qwdy/pHtNpv8PRTJOX/Kg3agTT6q
         msPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=90tbSpftzM+wEfef3WTFwlNnTYj4eB/xYx32SzM4xzY=;
        b=SEZfcvYWp07/0PFGWVXNcOIp38YxexjIfPmD9BoL2HBPG4wJFuHemu3pOfCxhRyH+7
         6g4ShRfFKAmzwgjIcMzOLoh2PRmoY7CqwBU2y5aArsAWTfgCiS2BM+zammttAIBhFdk+
         1ZvWw5B2F/VyzZT8/+3FRIdbXPHPsiyazcRl5gSYlhmPma+Q9WwYjwSBn9cFcegh6tCo
         4aADtSx7fNXGvJYuyxCah48lfdQIAB7hhAkPfWlOKeX8FQZV/6b8I60m14SW4DeQRYnX
         yUmZNMCHQwSOO4sZBXrNrCQNhnviB8pZW2zK/T/VTvkVuOzH2IeyHfpcaQqoUTnmOmzI
         L/vQ==
X-Gm-Message-State: AOAM533jepauXeA+P5cVk2q/dlo4Iq5tP9VKv8g0iCpGA2BXFNW8Q+B4
        DX1w0+i8PYH5cglVMrRQTvTYrg==
X-Google-Smtp-Source: ABdhPJyULY90N+uT8BWJ9LyldpfhK6Uh03XxkLYsulvOCfzFhpQstR0+n+ZnQDwSI9v/6zo0UOUO6Q==
X-Received: by 2002:a5d:6506:: with SMTP id x6mr3826155wru.71.1603955331470;
        Thu, 29 Oct 2020 00:08:51 -0700 (PDT)
Received: from apalos.home (athedsl-246545.home.otenet.gr. [85.73.10.175])
        by smtp.gmail.com with ESMTPSA id i33sm3324230wri.79.2020.10.29.00.08.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2020 00:08:51 -0700 (PDT)
Date:   Thu, 29 Oct 2020 09:08:48 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com
Subject: Re: [PATCH net-next 2/4] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201029070848.GA61336@apalos.home>
References: <cover.1603824486.git.lorenzo@kernel.org>
 <cd58ca966fbe11cabbd6160decea6ce748ebce9f.1603824486.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd58ca966fbe11cabbd6160decea6ce748ebce9f.1603824486.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo, 

On Tue, Oct 27, 2020 at 08:04:08PM +0100, Lorenzo Bianconi wrote:
> Introduce the capability to batch page_pool ptr_ring refill since it is
> usually run inside the driver NAPI tx completion loop.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/page_pool.h | 26 ++++++++++++++++++++++++++
>  net/core/page_pool.c    | 33 +++++++++++++++++++++++++++++++++
>  net/core/xdp.c          |  9 ++-------
>  3 files changed, 61 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 81d7773f96cd..b5b195305346 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -152,6 +152,8 @@ struct page_pool *page_pool_create(const struct page_pool_params *params);
>  void page_pool_destroy(struct page_pool *pool);
>  void page_pool_use_xdp_mem(struct page_pool *pool, void (*disconnect)(void *));
>  void page_pool_release_page(struct page_pool *pool, struct page *page);
> +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> +			     int count);
>  #else
>  static inline void page_pool_destroy(struct page_pool *pool)
>  {
> @@ -165,6 +167,11 @@ static inline void page_pool_release_page(struct page_pool *pool,
>  					  struct page *page)
>  {
>  }
> +
> +static inline void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> +					   int count)
> +{
> +}
>  #endif
>  
>  void page_pool_put_page(struct page_pool *pool, struct page *page,
> @@ -215,4 +222,23 @@ static inline void page_pool_nid_changed(struct page_pool *pool, int new_nid)
>  	if (unlikely(pool->p.nid != new_nid))
>  		page_pool_update_nid(pool, new_nid);
>  }
> +
> +static inline void page_pool_ring_lock(struct page_pool *pool)
> +	__acquires(&pool->ring.producer_lock)
> +{
> +	if (in_serving_softirq())
> +		spin_lock(&pool->ring.producer_lock);
> +	else
> +		spin_lock_bh(&pool->ring.producer_lock);
> +}
> +
> +static inline void page_pool_ring_unlock(struct page_pool *pool)
> +	__releases(&pool->ring.producer_lock)
> +{
> +	if (in_serving_softirq())
> +		spin_unlock(&pool->ring.producer_lock);
> +	else
> +		spin_unlock_bh(&pool->ring.producer_lock);
> +}
> +
>  #endif /* _NET_PAGE_POOL_H */
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ef98372facf6..84fb21f8865e 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -11,6 +11,8 @@
>  #include <linux/device.h>
>  
>  #include <net/page_pool.h>
> +#include <net/xdp.h>
> +
>  #include <linux/dma-direction.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/page-flags.h>
> @@ -408,6 +410,37 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
>  }
>  EXPORT_SYMBOL(page_pool_put_page);
>  
> +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> +			     int count)
> +{
> +	struct page *page_ring[XDP_BULK_QUEUE_SIZE];
> +	int i, len = 0;
> +
> +	for (i = 0; i < count; i++) {
> +		struct page *page = virt_to_head_page(data[i]);
> +
> +		if (unlikely(page_ref_count(page) != 1 ||
> +			     !pool_page_reusable(pool, page))) {
> +			page_pool_release_page(pool, page);

Mind switching this similarly to how page_pool_put_page() is using it?
unlikely -> likely and remove the !

> +			put_page(page);
> +			continue;
> +		}
> +
> +		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> +			page_pool_dma_sync_for_device(pool, page, -1);
> +
> +		page_ring[len++] = page;
> +	}
> +
> +	page_pool_ring_lock(pool);
> +	for (i = 0; i < len; i++) {
> +		if (__ptr_ring_produce(&pool->ring, page_ring[i]))
> +			page_pool_return_page(pool, page_ring[i]);
> +	}
> +	page_pool_ring_unlock(pool);
> +}
> +EXPORT_SYMBOL(page_pool_put_page_bulk);
> +
>  static void page_pool_empty_ring(struct page_pool *pool)
>  {
>  	struct page *page;
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index 93eabd789246..9f9a8d14df38 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -383,16 +383,11 @@ EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
>  void xdp_flush_frame_bulk(struct xdp_frame_bulk *bq)
>  {
>  	struct xdp_mem_allocator *xa = bq->xa;
> -	int i;
>  
> -	if (unlikely(!xa))
> +	if (unlikely(!xa || !bq->count))
>  		return;
>  
> -	for (i = 0; i < bq->count; i++) {
> -		struct page *page = virt_to_head_page(bq->q[i]);
> -
> -		page_pool_put_full_page(xa->page_pool, page, false);
> -	}
> +	page_pool_put_page_bulk(xa->page_pool, bq->q, bq->count);
>  	bq->count = 0;
>  }
>  EXPORT_SYMBOL_GPL(xdp_flush_frame_bulk);
> -- 
> 2.26.2
> 

Cheers
/Ilias

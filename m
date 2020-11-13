Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E73932B261B
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 21:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgKMU7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 15:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726087AbgKMU7K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 15:59:10 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39763C0613D1
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:59:10 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id a3so11287342wmb.5
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 12:59:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=xKnNcop1f2rzTmYplr1tpZUOWAts4UhRzIG/KybJWPE=;
        b=K2g0YNZ3s7tdmmeibJj2fGQKPe9IO8TOEATj1u1BtsDLXoyfZ0Lk14+vsVq8x8HS/y
         kuPuCyGgoimMbOm8gwJGDgnjn+y/C2AprQDMdQYBdH0VflU0R4MIuua11PGzItL3QRly
         xVi+HASObKDjuivGvAuaELr8qnRkb4mo216FVXSD/kYYDeUD5dUtwirANdIsOgPkFXKc
         xYJV9Pf27GtUI0XxOInzQiweLFZV6OB8RJpE+G8iwiBDpqlSPSlbGK3/L+ccHfDiP4WP
         2XWrkG5I2HwK96HXNjZlbkttT6MWRl/KKcQZ/quB4/B61HD6rRqLAVchxFCRCGh2+rgB
         GCPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=xKnNcop1f2rzTmYplr1tpZUOWAts4UhRzIG/KybJWPE=;
        b=PBwTUwVw45RlMRWnvpSk93BpxO6R20yc85mk7XBx5YcYfqUZFvRLe2+72CdHjXkQgc
         07Xth6sgqdiVmAnY44IJTBZwhZV1RZD+OhiO9BKFg4TTJCYXwwCEEmRyMY24lhcpz3v9
         4E359m4WDF+eqMctjWmuomVvRjHkpOCavPFrvO1KGOOA9KkAHxKF86ZMzq+LAHA31WMd
         R5b7QQjpzwp4P4hZdehoNCU2xBDnKDx3zK5uGFbH4OYTZqN9ar3IneHWTl+iumWNLKBE
         FvGVsV1pKXdeWFx5dtpgwFadkflIjZTYY2bQLBe9qT6ut3/bsWCSt1ybolNlYmOSCR/T
         UjMQ==
X-Gm-Message-State: AOAM533n+Q0MeFvvjJT1JQM5E+4UDxBhkUdUOgn8ydQcUWlMI3NaO2in
        mcRB9QQcQ9lGA2TI1OwNzJ9OMg==
X-Google-Smtp-Source: ABdhPJwvuROkX+IU8ANxlMC2wxp+klv69JicRqa7ufuiVFkS0t3v+0tCTnjvyYXUOrBGeDPG+njJwQ==
X-Received: by 2002:a7b:cbd7:: with SMTP id n23mr4425419wmi.142.1605301148900;
        Fri, 13 Nov 2020 12:59:08 -0800 (PST)
Received: from apalos.home (ppp-94-64-112-220.home.otenet.gr. [94.64.112.220])
        by smtp.gmail.com with ESMTPSA id i11sm12346361wrm.1.2020.11.13.12.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 12:59:08 -0800 (PST)
Date:   Fri, 13 Nov 2020 22:59:04 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        lorenzo.bianconi@redhat.com, davem@davemloft.net, kuba@kernel.org,
        brouer@redhat.com, john.fastabend@gmail.com
Subject: Re: [PATCH v6 net-nex 2/5] net: page_pool: add bulk support for
 ptr_ring
Message-ID: <20201113205904.GB1267100@apalos.home>
References: <cover.1605267335.git.lorenzo@kernel.org>
 <08dd249c9522c001313f520796faa777c4089e1c.1605267335.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <08dd249c9522c001313f520796faa777c4089e1c.1605267335.git.lorenzo@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 13, 2020 at 12:48:29PM +0100, Lorenzo Bianconi wrote:
> Introduce the capability to batch page_pool ptr_ring refill since it is
> usually run inside the driver NAPI tx completion loop.
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  include/net/page_pool.h | 26 +++++++++++++++
>  net/core/page_pool.c    | 70 +++++++++++++++++++++++++++++++++++------
>  net/core/xdp.c          |  9 ++----
>  3 files changed, 88 insertions(+), 17 deletions(-)
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
> index ef98372facf6..f3c690b8c8e3 100644
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
> @@ -362,8 +364,9 @@ static bool pool_page_reusable(struct page_pool *pool, struct page *page)
>   * If the page refcnt != 1, then the page will be returned to memory
>   * subsystem.
>   */
> -void page_pool_put_page(struct page_pool *pool, struct page *page,
> -			unsigned int dma_sync_size, bool allow_direct)
> +static __always_inline struct page *
> +__page_pool_put_page(struct page_pool *pool, struct page *page,
> +		     unsigned int dma_sync_size, bool allow_direct)
>  {
>  	/* This allocator is optimized for the XDP mode that uses
>  	 * one-frame-per-page, but have fallbacks that act like the
> @@ -379,15 +382,12 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
>  			page_pool_dma_sync_for_device(pool, page,
>  						      dma_sync_size);
>  
> -		if (allow_direct && in_serving_softirq())
> -			if (page_pool_recycle_in_cache(page, pool))
> -				return;
> +		if (allow_direct && in_serving_softirq() &&
> +		    page_pool_recycle_in_cache(page, pool))
> +			return NULL;
>  
> -		if (!page_pool_recycle_in_ring(pool, page)) {
> -			/* Cache full, fallback to free pages */
> -			page_pool_return_page(pool, page);
> -		}
> -		return;
> +		/* Page found as candidate for recycling */
> +		return page;
>  	}
>  	/* Fallback/non-XDP mode: API user have elevated refcnt.
>  	 *
> @@ -405,9 +405,59 @@ void page_pool_put_page(struct page_pool *pool, struct page *page,
>  	/* Do not replace this with page_pool_return_page() */
>  	page_pool_release_page(pool, page);
>  	put_page(page);
> +
> +	return NULL;
> +}
> +
> +void page_pool_put_page(struct page_pool *pool, struct page *page,
> +			unsigned int dma_sync_size, bool allow_direct)
> +{
> +	page = __page_pool_put_page(pool, page, dma_sync_size, allow_direct);
> +	if (page && !page_pool_recycle_in_ring(pool, page)) {
> +		/* Cache full, fallback to free pages */
> +		page_pool_return_page(pool, page);
> +	}
>  }
>  EXPORT_SYMBOL(page_pool_put_page);
>  
> +/* Caller must not use data area after call, as this function overwrites it */
> +void page_pool_put_page_bulk(struct page_pool *pool, void **data,
> +			     int count)
> +{
> +	int i, bulk_len = 0;
> +
> +	for (i = 0; i < count; i++) {
> +		struct page *page = virt_to_head_page(data[i]);
> +
> +		page = __page_pool_put_page(pool, page, -1, false);
> +		/* Approved for bulk recycling in ptr_ring cache */
> +		if (page)
> +			data[bulk_len++] = page;
> +	}
> +
> +	if (unlikely(!bulk_len))
> +		return;
> +
> +	/* Bulk producer into ptr_ring page_pool cache */
> +	page_pool_ring_lock(pool);
> +	for (i = 0; i < bulk_len; i++) {
> +		if (__ptr_ring_produce(&pool->ring, data[i]))
> +			break; /* ring full */
> +	}
> +	page_pool_ring_unlock(pool);
> +
> +	/* Hopefully all pages was return into ptr_ring */
> +	if (likely(i == bulk_len))
> +		return;
> +
> +	/* ptr_ring cache full, free remaining pages outside producer lock
> +	 * since put_page() with refcnt == 1 can be an expensive operation
> +	 */
> +	for (; i < bulk_len; i++)
> +		page_pool_return_page(pool, data[i]);
> +}
> +EXPORT_SYMBOL(page_pool_put_page_bulk);
> +
>  static void page_pool_empty_ring(struct page_pool *pool)
>  {
>  	struct page *page;
> diff --git a/net/core/xdp.c b/net/core/xdp.c
> index bbaee7fdd44f..3d330ebda893 100644
> --- a/net/core/xdp.c
> +++ b/net/core/xdp.c
> @@ -393,16 +393,11 @@ EXPORT_SYMBOL_GPL(xdp_return_frame_rx_napi);
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
>  	/* bq->xa is not cleared to save lookup, if mem.id same in next bulk */
>  	bq->count = 0;
>  }
> -- 
> 2.26.2
> 
Acked-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

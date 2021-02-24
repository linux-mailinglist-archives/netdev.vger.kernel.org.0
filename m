Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5848A324507
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 21:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235186AbhBXUOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 15:14:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235579AbhBXUMK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 15:12:10 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD290C061786
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 12:11:29 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id m1so2952262wml.2
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 12:11:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=yoEBD3kTTwguyjWERZTod9djozhi6l4dnUPRSHxjTUM=;
        b=IDa0GpfeP5aGN3GSvoQacCquWbdfOYSqZNBxEXraKvzRfYcg2ZMYsUckANfQlJ431j
         nEjzppt0eSyjwbbsniAUk959xpfFeBgl4+c91jVlHR2vKPCRRTOkfUVBurIfT5/NfX5Q
         5bsVrahyZtGmG02NUw/8aZUCq1eQ11oOsh96y3vPBFJsjVsVku6G5hHgCHfuQQ0seszf
         fcFP3GucFRPafZM72k1YQB9ZcshrOGJkuSz2mvACeQsF4RMpErl31Zp4FfUahKHqZRD8
         ejrunv9KOFfsVx/z0KtJk2+Wk78L9s49mq3plPL6FTRZqOK/iBtLrJnY9JPcmAsfrhJs
         OB9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=yoEBD3kTTwguyjWERZTod9djozhi6l4dnUPRSHxjTUM=;
        b=R8oYQEfVdbGQY/3Z6cOY34VVMy30fIqIE60P9Mbb8aTf/FbZgaZZAteZXtPH3m0a8R
         tVf5jUAoC/1pcKaJW4fNACPICfAdT2D+HP/k9kJAYEd0wqPQBcQwSNdNOK+aKW5f7caU
         GjZKLOyzuctxxlJDek4ncLXBisAc4yFIon7MkExKojIAvnxSEMUKn18JLOSrwDUOLYdH
         /KeW0wqsGCGKwMpBvHD68UeR/cLTmAsA7GkPUQxBYXIhUOeE+888XUWLlLHEOAOT9sPE
         nZCjfOqNNSEaph4ycWZO8D2Nwmab8rx8OpjgNRnYjcxxl6/q/PRsFX+umjydPsL9OupJ
         edJA==
X-Gm-Message-State: AOAM53189pZePnltXNw8lbkBCF/SOXIy4hLqXxeFkq/EpSJl/SX4yntU
        FXGpSoVmr4hSoUII8B/ZNqpCRg==
X-Google-Smtp-Source: ABdhPJyvwGC+daxO0xCmJulZwCgtYwQwlrWimSlxEh8LDTFVXZ7EXZ0tb5TomXORGHyjv9ogkVJSKA==
X-Received: by 2002:a1c:dc56:: with SMTP id t83mr5231391wmg.176.1614197488328;
        Wed, 24 Feb 2021 12:11:28 -0800 (PST)
Received: from apalos.home (ppp-94-64-113-158.home.otenet.gr. [94.64.113.158])
        by smtp.gmail.com with ESMTPSA id s124sm4268340wms.40.2021.02.24.12.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 12:11:27 -0800 (PST)
Date:   Wed, 24 Feb 2021 22:11:25 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org,
        chuck.lever@oracle.com, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 1/3] net: page_pool: refactor dma_map into
 own function page_pool_dma_map
Message-ID: <YDay7cWyHdJluEIc@apalos.home>
References: <161419296941.2718959.12575257358107256094.stgit@firesoul>
 <161419300107.2718959.18302883670835746249.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161419300107.2718959.18302883670835746249.stgit@firesoul>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 24, 2021 at 07:56:41PM +0100, Jesper Dangaard Brouer wrote:
> In preparation for next patch, move the dma mapping into its own
> function, as this will make it easier to follow the changes.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  net/core/page_pool.c |   49 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 29 insertions(+), 20 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index ad8b0707af04..50d52aa6fbeb 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -180,6 +180,31 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
>  					 pool->p.dma_dir);
>  }
>  
> +static struct page * page_pool_dma_map(struct page_pool *pool,
> +				       struct page *page)
> +{

Why return a struct page* ?
boolean maybe?

> +	dma_addr_t dma;
> +
> +	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
> +	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
> +	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
> +	 * This mapping is kept for lifetime of page, until leaving pool.
> +	 */
> +	dma = dma_map_page_attrs(pool->p.dev, page, 0,
> +				 (PAGE_SIZE << pool->p.order),
> +				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> +	if (dma_mapping_error(pool->p.dev, dma)) {
> +		put_page(page);

This is a bit confusing when reading it. 
The name of the function should try to map the page and report a yes/no,
instead of trying to call put_page as well.
Can't we explicitly ask the user to call put_page() if the mapping failed?

A clear example is on patch 2/3, when on the first read I was convinced there
was a memory leak.

> +		return NULL;
> +	}
> +	page->dma_addr = dma;
> +
> +	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> +		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> +
> +	return page;
> +}
> +
>  /* slow path */
>  noinline
>  static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
> @@ -187,7 +212,6 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  {
>  	struct page *page;
>  	gfp_t gfp = _gfp;
> -	dma_addr_t dma;
>  
>  	/* We could always set __GFP_COMP, and avoid this branch, as
>  	 * prep_new_page() can handle order-0 with __GFP_COMP.
> @@ -211,27 +235,12 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>  	if (!page)
>  		return NULL;
>  
> -	if (!(pool->p.flags & PP_FLAG_DMA_MAP))
> -		goto skip_dma_map;
> -
> -	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
> -	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
> -	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
> -	 * This mapping is kept for lifetime of page, until leaving pool.
> -	 */
> -	dma = dma_map_page_attrs(pool->p.dev, page, 0,
> -				 (PAGE_SIZE << pool->p.order),
> -				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> -	if (dma_mapping_error(pool->p.dev, dma)) {
> -		put_page(page);
> -		return NULL;
> +	if (pool->p.flags & PP_FLAG_DMA_MAP) {
> +		page = page_pool_dma_map(pool, page);
> +		if (!page)
> +			return NULL;
>  	}
> -	page->dma_addr = dma;
> -
> -	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> -		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
>  
> -skip_dma_map:
>  	/* Track how many pages are held 'in-flight' */
>  	pool->pages_state_hold_cnt++;
>  
> 
> 

Thanks!
/Ilias

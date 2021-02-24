Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2470F324517
	for <lists+netdev@lfdr.de>; Wed, 24 Feb 2021 21:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235437AbhBXUSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Feb 2021 15:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235686AbhBXUQH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Feb 2021 15:16:07 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9ECEC061786
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 12:15:26 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id o10so3858919wmc.1
        for <netdev@vger.kernel.org>; Wed, 24 Feb 2021 12:15:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J1gJV1o9Sl1Wnh9xWJQFa/KkawfMsaygfgB8RdQE8os=;
        b=PcA0tffJHzRc0QDxWkZcmb6WbGBYLYs9WEMRBSGCgpFlPrgGJCTauBZS1e0nR+TIuo
         P7bS/cIRp3mXEScNS+sPOjB/weotyBiu2bFS8B4AIMQmUHok6E0B6AqYR3HHAytYr24i
         uN8Z4aDXQlcyRdC8w9kyOasCEF5+QrJ0cMzcCNw7vE4fgPegZEsEMmV9qVhb+IEOTzYA
         Kng0odzvZpmNLSNsAfEgTkIEpPQYeei+X7ma2gcmv4yxuiRcwOtHljf2UzuxtGwIGhVd
         M8mDL6Ir4geuuDKHscHvoJ6c5rfKglpo4UMtOUmkY3h9yFYWzfiF7Cz65NRfB9RHhRnT
         vkKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J1gJV1o9Sl1Wnh9xWJQFa/KkawfMsaygfgB8RdQE8os=;
        b=l/jDC7jo6LElVBk/b4vDkUC0b9nVOeIQzYQTryh9+GDSYBlk80wjkBuPDy/4hExfjK
         gJ0BCt2anLcPIL0016Fo4DHuGo642hNqLlIjhfNw4FObtYzLFFhP6lffoc7HnrftRrNJ
         0nj2ChB1rGFCxR+XwRWJ7YSWHhVRHdWmyOxzosrPml59gDAc/X3jAi6f83aFZ6gq09OU
         IfXqAkBtB7v50KUHV1x+YxKCnQQPN7dFqeUPwSQIHEmppqWwh4wNxdcUrrUlvN9XaNQr
         HwVPzM6OFjMczutNZr+RzBqGWBj2WE61oripAAdeDxd+lxC/OWseszMW4kuRDfxXH5sX
         2A5g==
X-Gm-Message-State: AOAM5324GV2LUyHdppR1Pvepgz9fVPa4/4lDALEvtRoCH1+YTNwUzaSy
        ufxn+k9jPe1GKaAgQQiZo6cmBw==
X-Google-Smtp-Source: ABdhPJxf2wBacwv+7nH21lGN1XxSnXmyTznri5GC7Ka7XM0MNYSpX5qm+NtljVGMt7wCrErHGVhWNQ==
X-Received: by 2002:a1c:f60b:: with SMTP id w11mr5227838wmc.3.1614197725456;
        Wed, 24 Feb 2021 12:15:25 -0800 (PST)
Received: from apalos.home (ppp-94-64-113-158.home.otenet.gr. [94.64.113.158])
        by smtp.gmail.com with ESMTPSA id y9sm1850442wrm.88.2021.02.24.12.15.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Feb 2021 12:15:25 -0800 (PST)
Date:   Wed, 24 Feb 2021 22:15:22 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org,
        chuck.lever@oracle.com, netdev@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC net-next 2/3] net: page_pool: use alloc_pages_bulk in
 refill code path
Message-ID: <YDaz2tXXxEkcBfRR@apalos.home>
References: <161419296941.2718959.12575257358107256094.stgit@firesoul>
 <161419300618.2718959.11165518489200268845.stgit@firesoul>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <161419300618.2718959.11165518489200268845.stgit@firesoul>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jesper, 

On Wed, Feb 24, 2021 at 07:56:46PM +0100, Jesper Dangaard Brouer wrote:
> There are cases where the page_pool need to refill with pages from the
> page allocator. Some workloads cause the page_pool to release pages
> instead of recycling these pages.
> 
> For these workload it can improve performance to bulk alloc pages from
> the page-allocator to refill the alloc cache.
> 
> For XDP-redirect workload with 100G mlx5 driver (that use page_pool)
> redirecting xdp_frame packets into a veth, that does XDP_PASS to create
> an SKB from the xdp_frame, which then cannot return the page to the
> page_pool. In this case, we saw[1] an improvement of 18.8% from using
> the alloc_pages_bulk API (3,677,958 pps -> 4,368,926 pps).
> 
> [1] https://github.com/xdp-project/xdp-project/blob/master/areas/mem/page_pool06_alloc_pages_bulk.org
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

[...]

> +	/* Remaining pages store in alloc.cache */
> +	list_for_each_entry_safe(page, next, &page_list, lru) {
> +		list_del(&page->lru);
> +		if (pp_flags & PP_FLAG_DMA_MAP) {
> +			page = page_pool_dma_map(pool, page);
> +			if (!page)

As I commented on the previous patch, i'd prefer the put_page() here to be
explicitly called, instead of hiding in the page_pool_dma_map()

> +				continue;
> +		}
> +		if (likely(pool->alloc.count < PP_ALLOC_CACHE_SIZE)) {
> +			pool->alloc.cache[pool->alloc.count++] = page;
> +			pool->pages_state_hold_cnt++;
> +			trace_page_pool_state_hold(pool, page,
> +						   pool->pages_state_hold_cnt);
> +		} else {
> +			put_page(page);
> +		}
> +	}
> +out:
>  	if (pool->p.flags & PP_FLAG_DMA_MAP) {
> -		page = page_pool_dma_map(pool, page);
> -		if (!page)
> +		first_page = page_pool_dma_map(pool, first_page);
> +		if (!first_page)
>  			return NULL;
>  	}
>  
[...]

Cheers
/Ilias

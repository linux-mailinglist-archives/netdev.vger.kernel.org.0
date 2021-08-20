Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B33C43F2963
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 11:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237184AbhHTJkd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 05:40:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233976AbhHTJkc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 05:40:32 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98BDC061575
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 02:39:54 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id w21-20020a7bc1150000b02902e69ba66ce6so5700538wmi.1
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 02:39:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=SgAZrAuLqFLWkgFha/gddUSo+jVTcbw0CntqEuGsVoo=;
        b=hJw/IoWz1kBujVQ1PZSAH9y2ccNURgfsnDZ1H/HYY8CDBDZ7KHY+8QuBOcdDy82R5e
         Znpr2XZvoCEMy3bFPCLH82imTz8kMGJt+WiJAKevCRqapWBuiPx51NC2mN7m7SMDBnON
         J7pPhuVzQagYiomad5QJbZDV+b5aSJs1xMliX5pmWoQru6xVby4ZOaeP94n5NvbIrBYt
         MUhn32WFW3/s+bftjKqsOTW6jkFOAfen7JdlyAq9FaHgb/44BAblZUv49HEDCPxjUGuh
         OzsCf8ZO2MT3i/NqzKCd75Cu1NIqYJwrudWyxuahruTK+vS0qGhKNDxJmto+xIeldr56
         WBUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SgAZrAuLqFLWkgFha/gddUSo+jVTcbw0CntqEuGsVoo=;
        b=Ai6cWPH0Gs3lJ/pJr3l9fupPgx2aqRlT5TQhr2EsBPCbyfuSaKKw5FixWxNeOAOnKM
         uU1z7YiXqCL8vOWxeYlg4DO5kD0s9wyxIw/5j5Q1LRG67t62WJ5iSPMO9VVyVTYpguZO
         30dD5vyCE6GJS1LFe3srE1YORaiyaHLx92yb957r+QxgSn4qlhLM/GJH4+dSKLM8SjJm
         hT3Y7Hv6QZCVWBkgj8rlJwwSNac1CRL0h7Pb19444yqIORCxcAlGwR5TUSqfmmenkbkn
         KkXnlBfX9JUeVERj+KQGMF+W2XG4E6taxcKTN8mzimLgGUxICtoiOqGWx/UHkum3NcWD
         qWcw==
X-Gm-Message-State: AOAM530cQsTT5Dcd4qLd4uyk/chvvtuIZYNW6tH89OD6I1Mhipj+771P
        ufqZpOIagy8Z0zMxAPwy0ewtvA==
X-Google-Smtp-Source: ABdhPJwN1H4oiaqFFnk+KcpRnJHbcydYHgaP9ld0Bns8XUmcEyvT456ckvZJsU0WiGxvhogYhw7gkQ==
X-Received: by 2002:a05:600c:242:: with SMTP id 2mr2877004wmj.167.1629452392633;
        Fri, 20 Aug 2021 02:39:52 -0700 (PDT)
Received: from Iliass-MBP (athedsl-93705.home.otenet.gr. [87.203.119.87])
        by smtp.gmail.com with ESMTPSA id h6sm5250280wmq.5.2021.08.20.02.39.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 02:39:52 -0700 (PDT)
Date:   Fri, 20 Aug 2021 12:39:45 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com
Subject: Re: [PATCH net-next v2 2/2] page_pool: optimize the cpu sync
 operation when DMA mapping
Message-ID: <YR94YYRv2qpQtdSZ@Iliass-MBP>
References: <1629442611-61547-1-git-send-email-linyunsheng@huawei.com>
 <1629442611-61547-3-git-send-email-linyunsheng@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1629442611-61547-3-git-send-email-linyunsheng@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 02:56:51PM +0800, Yunsheng Lin wrote:
> If the DMA_ATTR_SKIP_CPU_SYNC is not set, cpu syncing is
> also done in dma_map_page_attrs(), so set the attrs according
> to pool->p.flags to avoid calling cpu sync function again.

Isn't DMA_ATTR_SKIP_CPU_SYNC checked within dma_map_page_attrs() anyway?

Regards
/Ilias
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>  net/core/page_pool.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 1a69784..3df5554 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -191,8 +191,12 @@ static void page_pool_dma_sync_for_device(struct page_pool *pool,
>  
>  static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>  {
> +	unsigned long attrs = DMA_ATTR_SKIP_CPU_SYNC;
>  	dma_addr_t dma;
>  
> +	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> +		attrs = 0;
> +
>  	/* Setup DMA mapping: use 'struct page' area for storing DMA-addr
>  	 * since dma_addr_t can be either 32 or 64 bits and does not always fit
>  	 * into page private data (i.e 32bit cpu with 64bit DMA caps)
> @@ -200,15 +204,12 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>  	 */
>  	dma = dma_map_page_attrs(pool->p.dev, page, 0,
>  				 (PAGE_SIZE << pool->p.order),
> -				 pool->p.dma_dir, DMA_ATTR_SKIP_CPU_SYNC);
> +				 pool->p.dma_dir, attrs);
>  	if (dma_mapping_error(pool->p.dev, dma))
>  		return false;
>  
>  	page_pool_set_dma_addr(page, dma);
>  
> -	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> -		page_pool_dma_sync_for_device(pool, page, pool->p.max_len);
> -
>  	return true;
>  }
>  
> -- 
> 2.7.4
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2AE0303CBB
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 13:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392187AbhAZMPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 07:15:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404913AbhAZLJR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 06:09:17 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD608C061573
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 03:08:33 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id d16so15316784wro.11
        for <netdev@vger.kernel.org>; Tue, 26 Jan 2021 03:08:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YexESypTZUXGxM0RNYUq5KscUb8ruQBrW1cIhg1mZJ0=;
        b=bskZDSuMdTWcqASyQOy7OtS5KG6+pzOlrEOQmnZLWuKDog92AwWAC1iTsT88zhd+Ja
         ZTzLqQWfD+pNGaDtTg9/JwZGrg2jqNk3p00j0Vqeou4Es5qRMXi3/B5C/X8WDGdgvLC8
         Mj3oB0BD2rnEjNWyqV+6YxFkgxDX0gk7IrTBWoutXmKk+hMV/QjsiqUyNqRK8Iswsc7m
         L/hxU2h/VFLAZ4DsQP4cuQ7HTUZC0vC1x1KXSwSA/5/55OU/Ep4640dCRmO3bKDGb5Zn
         HmIQWYUROmzmI+3qbDfiEH9LsEymELXtGaIE2e6Wv5p2XA69vrlDal64gt7vPdqeUPwV
         TT1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YexESypTZUXGxM0RNYUq5KscUb8ruQBrW1cIhg1mZJ0=;
        b=SOzaWJUPkzvHJcoV1Wk+/EE75kkBjxvmIUASFHa1mB/HrSeN8ghJHAvNLqTPYKlqux
         JRs+pCRZ5EeHjP0ctBOvbkkoxZkFgVBftwoGSiOxu++oNjJPu0nlXNXYFWMI7wUktc5h
         ak4VNHl06qEQ4exYku5QQA4F8eXUzBtT/O3cKDEMMoUezZC8+XQTE9tOyGWMyp5wACdN
         E1Dv8jC4G0HWXenzw8Fybg3r2+Tddi5FA6mAZDNFSu5SlJ3+tFcTdGzn6uAG6DiWzH9X
         L5LyIaTEsEOIbXZ42/sow845km+n894fS8xdhIdDcRvKPawtG2+bs7N6AaQaDkhYgILz
         pujQ==
X-Gm-Message-State: AOAM533dcrjrCypYO/hMuo9oVc7x26rcu5JbRYGPUbhPf5JDQaS01TX1
        oCgl9WqMTKaBKXaUX92e8tj1Xw==
X-Google-Smtp-Source: ABdhPJyfP85ucHm7H/Dm1TztP6OgLXgNB/BxHatQ80kHkb7XarU2/+PooSiT+4Wl68HlfXcBzEPDXg==
X-Received: by 2002:a5d:440a:: with SMTP id z10mr5556407wrq.266.1611659312476;
        Tue, 26 Jan 2021 03:08:32 -0800 (PST)
Received: from apalos.home (athedsl-376992.home.otenet.gr. [79.131.24.158])
        by smtp.gmail.com with ESMTPSA id z18sm10610031wro.91.2021.01.26.03.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Jan 2021 03:08:31 -0800 (PST)
Date:   Tue, 26 Jan 2021 13:08:28 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Alexander Lobakin <alobakin@pm.me>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Willem de Bruijn <willemb@google.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Aleksandr Nogikh <nogikh@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Dexuan Cui <decui@microsoft.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marco Elver <elver@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-rdma@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH net-next 3/3] net: page_pool: simplify page recycling
 condition tests
Message-ID: <YA/4LNJPEQJv++mo@apalos.home>
References: <20210125164612.243838-1-alobakin@pm.me>
 <20210125164612.243838-4-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210125164612.243838-4-alobakin@pm.me>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 25, 2021 at 04:47:20PM +0000, Alexander Lobakin wrote:
> pool_page_reusable() is a leftover from pre-NUMA-aware times. For now,
> this function is just a redundant wrapper over page_is_pfmemalloc(),
> so Inline it into its sole call site.
> 
> Signed-off-by: Alexander Lobakin <alobakin@pm.me>
> ---
>  net/core/page_pool.c | 14 ++++----------
>  1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index f3c690b8c8e3..ad8b0707af04 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -350,14 +350,6 @@ static bool page_pool_recycle_in_cache(struct page *page,
>  	return true;
>  }
>  
> -/* page is NOT reusable when:
> - * 1) allocated when system is under some pressure. (page_is_pfmemalloc)
> - */
> -static bool pool_page_reusable(struct page_pool *pool, struct page *page)
> -{
> -	return !page_is_pfmemalloc(page);
> -}
> -
>  /* If the page refcnt == 1, this will try to recycle the page.
>   * if PP_FLAG_DMA_SYNC_DEV is set, we'll try to sync the DMA area for
>   * the configured size min(dma_sync_size, pool->max_len).
> @@ -373,9 +365,11 @@ __page_pool_put_page(struct page_pool *pool, struct page *page,
>  	 * regular page allocator APIs.
>  	 *
>  	 * refcnt == 1 means page_pool owns page, and can recycle it.
> +	 *
> +	 * page is NOT reusable when allocated when system is under
> +	 * some pressure. (page_is_pfmemalloc)
>  	 */
> -	if (likely(page_ref_count(page) == 1 &&
> -		   pool_page_reusable(pool, page))) {
> +	if (likely(page_ref_count(page) == 1 && !page_is_pfmemalloc(page))) {
>  		/* Read barrier done in page_ref_count / READ_ONCE */
>  
>  		if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> -- 
> 2.30.0
> 
> 

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>

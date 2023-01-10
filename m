Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77FED663E90
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 11:49:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231200AbjAJKtI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 05:49:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238307AbjAJKsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 05:48:25 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A5468C96
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:48:18 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id c17so16875422edj.13
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 02:48:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sg0mN3VXt1Ze93ywGfUQr/46Le7Fdm7QZEKQLC5rtNw=;
        b=v0S35m+Mr6jfxJJe/Qv5iNviBJ0gjvOiJW9UyQcqU8LpY4H5grXHxZSwMsEJMwu/Rt
         k67DIW87q+KcgVUmaVV3vCVZGuWMgZQjHHxkxOVjw+tlNaJxVdMiiKU9UHDcieldM0H7
         9IaxltZVA1/3NE3o8qedk+LJEfHfPw6BfwYhQ8KZLQU/vxnUtWaN1I904IMm6wpwGj0t
         8l7y0d8mU/vDf/nT0Z2DXc9GxgGTT/2pSqEwE72MXM4MBSiGSBmFwYd26KQ2U1h9Zq9D
         pOCUwFX9aMIsXvmap3nCPxmkFXmHb+uAB7CMoKQeizchFlUgq52b0rKoIY/oeho23MF3
         4+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sg0mN3VXt1Ze93ywGfUQr/46Le7Fdm7QZEKQLC5rtNw=;
        b=zFA56lYNjE9XO69muspda5prIy8zum5XPkgvzDkOoxTRMlaID2JqJ2qJWMptHP1zG5
         8oJU59ZSL5LXC/YKtS1nCOWiiPaIa+V0cHB0uWMHhpn9ks+u7lZaWny38F+96UZP4BwU
         RPbJ2ASMfKx423zNsSbs+NGlhXdUQvK4OsMYqV/4VSC6BI+yArx5Xu/8IsClSh+AXtbi
         cKBl5Vs0MOK7M8nCux5O2D6IjfAO4j7ogtSXM7eWJcJOtZHeNJg6Icm92652BDimPTrN
         +mqSVZ1zwQH0IvcDOZ7hWKlvRl/8KGmkPmkwB6OxgjwG/B6CmTybFdz5QqetD5Swc33R
         BHCg==
X-Gm-Message-State: AFqh2kpZETqVRbZOLvOQAKTMg61BtV7xitW5QlbblQrN1LUVpT2BsZ9/
        KsoR5nr0kHak9mJnTwiz1nEc9r43HcfbZdLM
X-Google-Smtp-Source: AMrXdXu+KEnTwAOFwasWztSKGFhBkBkQMuXHSDfCMsEvvXjqwJyxYaF+4/2ydcAelNuB66nKT76BOA==
X-Received: by 2002:a05:6402:685:b0:479:ab7d:1dad with SMTP id f5-20020a056402068500b00479ab7d1dadmr73490557edy.32.1673347697235;
        Tue, 10 Jan 2023 02:48:17 -0800 (PST)
Received: from hera (ppp079167090036.access.hol.gr. [79.167.90.36])
        by smtp.gmail.com with ESMTPSA id x14-20020a056402414e00b0045b4b67156fsm4750650eda.45.2023.01.10.02.48.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 02:48:16 -0800 (PST)
Date:   Tue, 10 Jan 2023 12:48:14 +0200
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>, netdev@vger.kernel.org,
        linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2 14/24] page_pool: Convert page_pool_recycle_in_cache()
 to netmem
Message-ID: <Y71CbrB6/WnxERSF@hera>
References: <20230105214631.3939268-1-willy@infradead.org>
 <20230105214631.3939268-15-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105214631.3939268-15-willy@infradead.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 09:46:21PM +0000, Matthew Wilcox (Oracle) wrote:
> Removes a few casts.
>
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
> ---
>  net/core/page_pool.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 3fa03baa80ee..b925a4dcb09b 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -538,7 +538,7 @@ static bool page_pool_recycle_in_ring(struct page_pool *pool,
>   *
>   * Caller must provide appropriate safe context.
>   */
> -static bool page_pool_recycle_in_cache(struct page *page,
> +static bool page_pool_recycle_in_cache(struct netmem *nmem,
>  				       struct page_pool *pool)
>  {
>  	if (unlikely(pool->alloc.count == PP_ALLOC_CACHE_SIZE)) {
> @@ -547,7 +547,7 @@ static bool page_pool_recycle_in_cache(struct page *page,
>  	}
>
>  	/* Caller MUST have verified/know (page_ref_count(page) == 1) */
> -	pool->alloc.cache[pool->alloc.count++] = page_netmem(page);
> +	pool->alloc.cache[pool->alloc.count++] = nmem;
>  	recycle_stat_inc(pool, cached);
>  	return true;
>  }
> @@ -580,7 +580,7 @@ __page_pool_put_netmem(struct page_pool *pool, struct netmem *nmem,
>  						      dma_sync_size);
>
>  		if (allow_direct && in_serving_softirq() &&
> -		    page_pool_recycle_in_cache(netmem_page(nmem), pool))
> +		    page_pool_recycle_in_cache(nmem, pool))
>  			return NULL;
>
>  		/* Page found as candidate for recycling */
> --
> 2.35.1
>

Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>


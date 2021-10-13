Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFE9B42BCAF
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 12:21:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239302AbhJMKXg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 06:23:36 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:37905 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230005AbhJMKXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 06:23:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634120486;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZYGUqokbeWERaGDZ6FCBB90KTOT0LH0B99uKg6pXVUo=;
        b=hs6DzKk5DE84auLJH+0WMNMvnMGaum25WXvM1toddtPAVGqhbWGDRfu3XoD2/7B8OSeKke
        7+UX7rNegtP5QWqh9cUCx3AKi6z3w6b0fCPZLH2vsDw6NO4N3tn1xGPw7tmL3UAPz0PWux
        /TALBl/kNvgFqSE1GWaFpv+bhFJt8FE=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-185-Ke5pSTnePLqSaXgeWhn93w-1; Wed, 13 Oct 2021 06:21:25 -0400
X-MC-Unique: Ke5pSTnePLqSaXgeWhn93w-1
Received: by mail-ed1-f72.google.com with SMTP id t18-20020a056402021200b003db9e6b0e57so1798219edv.10
        for <netdev@vger.kernel.org>; Wed, 13 Oct 2021 03:21:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZYGUqokbeWERaGDZ6FCBB90KTOT0LH0B99uKg6pXVUo=;
        b=BFdJQQrtIcbW7+jgXVQwvScJWWEiSqlQ2CS/t0lI+Mh4AIAIFnV55cAxfsfJV6Hs5l
         x+5skfX3NP0S24arF8GZh85qXT/mlGJXGyken4YdKSfmZinhOUlqOAQHgGHh5FhqKG1H
         6vC0yLOH0rczDxAk3SDeR2rBoj2iTusLwkN9kFUyU0eUXFuUSdy83+YbJIMETUf534tl
         N4RY76on4TLEeJE7ANKcTl6Q+RBEHEKwiwxnwI32biCG9SJlaGKmZgfdPyXD+WHjdSTb
         7dInfAz1OQ4fFFHbIr/Fh3kjWA4fJDl3w9x3HoC5Xnuu3sQ5TMq3yWlibnDrvexFLXUG
         VjEQ==
X-Gm-Message-State: AOAM53302Ni2iQzwLcUr0mmUlllIfslCb/tbAyEIxRpU9UrMM8++MtpH
        OL6OkDv19SbwvRPW+d/D4rMqB1+yWIRpT83yGe3Hdi24vJ0YPTRzDdNw1/oYGgOqn75jn3DYRZR
        5Xy/mUTUL2KSRnf0o
X-Received: by 2002:a17:906:cccb:: with SMTP id ot11mr38494144ejb.219.1634120484352;
        Wed, 13 Oct 2021 03:21:24 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw97yXcFt1jprzlskLyznf8XHJEKZqMfElmYmzbeTjoIeW1izLyccuYuEX7MU3fMvW9BgsYSQ==
X-Received: by 2002:a17:906:cccb:: with SMTP id ot11mr38494122ejb.219.1634120484159;
        Wed, 13 Oct 2021 03:21:24 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id i21sm6369957eja.50.2021.10.13.03.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 03:21:23 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, ilias.apalodimas@linaro.org,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org,
        jhubbard@nvidia.com, yuzhao@google.com, mcroce@microsoft.com,
        fenghua.yu@intel.com, feng.tang@intel.com, jgg@ziepe.ca,
        aarcange@redhat.com, guro@fb.com,
        Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH net-next v6] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
References: <20211013091920.1106-1-linyunsheng@huawei.com>
Message-ID: <458b7f87-a7ca-739d-cb8c-494909bf0dc3@redhat.com>
Date:   Wed, 13 Oct 2021 12:21:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20211013091920.1106-1-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 13/10/2021 11.19, Yunsheng Lin wrote:
> As the 32-bit arch with 64-bit DMA seems to rare those days,
> and page pool might carry a lot of code and complexity for
> systems that possibly.
> 
> So disable dma mapping support for such systems, if drivers
> really want to work on such systems, they have to implement
> their own DMA-mapping fallback tracking outside page_pool.
> 
> Reviewed-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> V6: Drop pp page tracking support
> ---
>   include/linux/mm_types.h | 13 +------------
>   include/net/page_pool.h  | 12 +-----------
>   net/core/page_pool.c     | 10 ++++++----
>   3 files changed, 8 insertions(+), 27 deletions(-)


Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

This is a nice simplification of struct page and page_pool code, when we 
don't need to handle this 32-bit ARCH with 64-bit DMA case.
It also gets rid of the confusingly named define. Thanks.


> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 7f8ee09c711f..436e0946d691 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -104,18 +104,7 @@ struct page {
>   			struct page_pool *pp;
>   			unsigned long _pp_mapping_pad;
>   			unsigned long dma_addr;
> -			union {
> -				/**
> -				 * dma_addr_upper: might require a 64-bit
> -				 * value on 32-bit architectures.
> -				 */
> -				unsigned long dma_addr_upper;
> -				/**
> -				 * For frag page support, not supported in
> -				 * 32-bit architectures with 64-bit DMA.
> -				 */
> -				atomic_long_t pp_frag_count;
> -			};
> +			atomic_long_t pp_frag_count;
>   		};
>   		struct {	/* slab, slob and slub */
>   			union {
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index a4082406a003..3855f069627f 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -216,24 +216,14 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>   	page_pool_put_full_page(pool, page, true);
>   }
>   
> -#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
> -		(sizeof(dma_addr_t) > sizeof(unsigned long))
> -
>   static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>   {
> -	dma_addr_t ret = page->dma_addr;
> -
> -	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> -		ret |= (dma_addr_t)page->dma_addr_upper << 16 << 16;
> -
> -	return ret;
> +	return page->dma_addr;
>   }
>   
>   static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>   {
>   	page->dma_addr = addr;
> -	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> -		page->dma_addr_upper = upper_32_bits(addr);
>   }
>   
>   static inline void page_pool_set_frag_count(struct page *page, long nr)
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 1a6978427d6c..9b60e4301a44 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -49,6 +49,12 @@ static int page_pool_init(struct page_pool *pool,
>   	 * which is the XDP_TX use-case.
>   	 */
>   	if (pool->p.flags & PP_FLAG_DMA_MAP) {
> +		/* DMA-mapping is not supported on 32-bit systems with
> +		 * 64-bit DMA mapping.
> +		 */
> +		if (sizeof(dma_addr_t) > sizeof(unsigned long))
> +			return -EOPNOTSUPP;
> +
>   		if ((pool->p.dma_dir != DMA_FROM_DEVICE) &&
>   		    (pool->p.dma_dir != DMA_BIDIRECTIONAL))
>   			return -EINVAL;
> @@ -69,10 +75,6 @@ static int page_pool_init(struct page_pool *pool,
>   		 */
>   	}
>   
> -	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> -	    pool->p.flags & PP_FLAG_PAGE_FRAG)
> -		return -EINVAL;
> -
>   	if (ptr_ring_init(&pool->ring, ring_qsize, GFP_KERNEL) < 0)
>   		return -ENOMEM;
>   
> 


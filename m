Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 114FA3C82A1
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 12:18:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239051AbhGNKVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 06:21:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:22442 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238359AbhGNKVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 06:21:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626257929;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LfBNZ1nRgQ8vQTHVhw7mjr+RaP8o0JiRU/ocXdcO9YA=;
        b=NCzLOh3t9lZfuELQovu8AhcLkkGA3mP2QnX+tTOqCwKqGo6Avwzrs2pe7sNlTPbuXXwFdd
        GKqcWDjyfRBJHvPEZ0q3pDUuqfKZZE29+0Cqdb2P7rMkJrSH1m7n5nPasp//ARaNft+nio
        xyxFt8IgjV41w8OK7B5daowAvFgpaoA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-373-CroGQDxzNYKIGgN-KrFAvA-1; Wed, 14 Jul 2021 06:18:48 -0400
X-MC-Unique: CroGQDxzNYKIGgN-KrFAvA-1
Received: by mail-wm1-f71.google.com with SMTP id m40-20020a05600c3b28b02901f42375a73fso604348wms.5
        for <netdev@vger.kernel.org>; Wed, 14 Jul 2021 03:18:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LfBNZ1nRgQ8vQTHVhw7mjr+RaP8o0JiRU/ocXdcO9YA=;
        b=gLt0NlJWe3zmYxuq9GM5adhMcNPehs10OCGAWMqErBnSgdpgdL2Ec0C0pRe9PFHRte
         f3FnR+I1ILLqtl5EP1JiTbOITR+78Xx9Eug9aHuX5FX+gqU3aCjlI8OQeqv8TsvD4FzP
         J2QWlkkcgCZB9RbAt++1Bh34xiXyn/O0X2gf9bhX39cGE6gY3did4A7fYlUix+SXqsdz
         xiIcdHYJ1t274Ybwd6TWAilCgwH1vaZ8ES7Tht+fSxLQ/E8k7VkDHSk1h0iqK4nG9cNb
         /Y1f1Jrlp1YvduzcHevlyiDJEMUxvGDd46XXlMOq+zG2ExbilSO0FHMCJkt+8q5NyLp/
         nlZQ==
X-Gm-Message-State: AOAM5320/S2wtfDUTiKhUCYmRgpNLK9sivyDFoByRA4EzqMqFqKeA7Hk
        mRg0h5W1ygl3t4U6XGjBS0PWFVlrQfzVPPxGSsmSaHzvQouf0waCqF1b93O+KI5YjulK7vC9GFZ
        9el9Q8/BeTcHwle3+
X-Received: by 2002:a5d:6b8d:: with SMTP id n13mr11957073wrx.258.1626257927316;
        Wed, 14 Jul 2021 03:18:47 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwgfZFM3rD5Ku3g+Nf/khVvTbnZKuQr/7PrPxOlAJJ44Gr2x6+IQc7EVQyw6OkLkr42lsqTBw==
X-Received: by 2002:a5d:6b8d:: with SMTP id n13mr11957029wrx.258.1626257927046;
        Wed, 14 Jul 2021 03:18:47 -0700 (PDT)
Received: from [192.168.42.238] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id t9sm1812790wmq.14.2021.07.14.03.18.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 03:18:46 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, alexander.duyck@gmail.com,
        linux@armlinux.org.uk, mw@semihalf.com, linuxarm@openeuler.org,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        thomas.petazzoni@bootlin.com, hawk@kernel.org,
        ilias.apalodimas@linaro.org, ast@kernel.org, daniel@iogearbox.net,
        john.fastabend@gmail.com, akpm@linux-foundation.org,
        peterz@infradead.org, will@kernel.org, willy@infradead.org,
        vbabka@suse.cz, fenghua.yu@intel.com, guro@fb.com,
        peterx@redhat.com, feng.tang@intel.com, jgg@ziepe.ca,
        mcroce@microsoft.com, hughd@google.com, jonathan.lemon@gmail.com,
        alobakin@pm.me, willemb@google.com, wenxu@ucloud.cn,
        cong.wang@bytedance.com, haokexin@gmail.com, nogikh@google.com,
        elver@google.com, yhs@fb.com, kpsingh@kernel.org,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH rfc v5 2/4] page_pool: add interface to manipulate frag
 count in page pool
To:     Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
        kuba@kernel.org
References: <1626255285-5079-1-git-send-email-linyunsheng@huawei.com>
 <1626255285-5079-3-git-send-email-linyunsheng@huawei.com>
Message-ID: <79d9e41c-6433-efe1-773a-4f5e91e8de0f@redhat.com>
Date:   Wed, 14 Jul 2021 12:18:44 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1626255285-5079-3-git-send-email-linyunsheng@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/07/2021 11.34, Yunsheng Lin wrote:
> As suggested by Alexander, "A DMA mapping should be page
> aligned anyway so the lower 12 bits would be reserved 0",
> so it might make more sense to repurpose the lower 12 bits
> of the dma address to store the frag count for frag page
> support in page pool for 32 bit systems with 64 bit dma,
> which should be rare those days.

Do we have any real driver users with 32-bit arch and 64-bit DMA, that 
want to use this new frag-count system you are adding to page_pool?

This "lower 12-bit use" complicates the code we need to maintain 
forever. My guess is that it is never used, but we need to update and 
maintain it, and it will never be tested.

Why don't you simply reject using page_pool flag PP_FLAG_PAGE_FRAG 
during setup of the page_pool for this case?

  if ((pool->p.flags & PP_FLAG_PAGE_FRAG) &&
      (sizeof(dma_addr_t) > sizeof(unsigned long)))
    goto reject-setup;


> For normal system, the dma_addr[1] in 'struct page' is not
> used, so we can reuse one of the dma_addr for storing frag
> count, which means how many frags this page might be splited
> to.
> 
> The PAGE_POOL_DMA_USE_PP_FRAG_COUNT macro is added to decide
> where to store the frag count, as the "sizeof(dma_addr_t) >
> sizeof(unsigned long)" is false for most systems those days,
> so hopefully the compiler will optimize out the unused code
> for those systems.
> 
> The newly added page_pool_set_frag_count() should be called
> before the page is passed to any user. Otherwise, call the
> newly added page_pool_atomic_sub_frag_count_return().
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
>   include/linux/mm_types.h |  8 +++++--
>   include/net/page_pool.h  | 54 ++++++++++++++++++++++++++++++++++++++++++------
>   net/core/page_pool.c     | 10 +++++++++
>   3 files changed, 64 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index d33d97c..82bcbb0 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -103,11 +103,15 @@ struct page {
>   			unsigned long pp_magic;
>   			struct page_pool *pp;
>   			unsigned long _pp_mapping_pad;
> +			atomic_long_t pp_frag_count;
>   			/**
>   			 * @dma_addr: might require a 64-bit value on
> -			 * 32-bit architectures.
> +			 * 32-bit architectures, if so, store the lower 32
> +			 * bits in pp_frag_count, and a DMA mapping should
> +			 * be page aligned, so the frag count can be stored
> +			 * in lower 12 bits for 4K page size.
>   			 */
> -			unsigned long dma_addr[2];
> +			unsigned long dma_addr;
>   		};
>   		struct {	/* slab, slob and slub */
>   			union {
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 8d7744d..ef449c2 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -198,19 +198,61 @@ static inline void page_pool_recycle_direct(struct page_pool *pool,
>   	page_pool_put_full_page(pool, page, true);
>   }
>   
> +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
> +			(sizeof(dma_addr_t) > sizeof(unsigned long))
> +
>   static inline dma_addr_t page_pool_get_dma_addr(struct page *page)
>   {
> -	dma_addr_t ret = page->dma_addr[0];
> -	if (sizeof(dma_addr_t) > sizeof(unsigned long))
> -		ret |= (dma_addr_t)page->dma_addr[1] << 16 << 16;
> +	dma_addr_t ret = page->dma_addr;
> +
> +	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
> +		ret <<= 32;
> +		ret |= atomic_long_read(&page->pp_frag_count) & PAGE_MASK;
> +	}
> +
>   	return ret;
>   }
>   
>   static inline void page_pool_set_dma_addr(struct page *page, dma_addr_t addr)
>   {
> -	page->dma_addr[0] = addr;
> -	if (sizeof(dma_addr_t) > sizeof(unsigned long))
> -		page->dma_addr[1] = upper_32_bits(addr);
> +	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
> +		atomic_long_set(&page->pp_frag_count, addr & PAGE_MASK);
> +		addr >>= 32;
> +	}
> +
> +	page->dma_addr = addr;
> +}
> +
> +static inline long page_pool_atomic_sub_frag_count_return(struct page *page,
> +							  long nr)
> +{
> +	long frag_count = atomic_long_read(&page->pp_frag_count);
> +	long ret;
> +
> +	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
> +		if ((frag_count & ~PAGE_MASK) == nr)
> +			return 0;
> +
> +		ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> +		WARN_ON((ret & PAGE_MASK) != (frag_count & PAGE_MASK));
> +		ret &= ~PAGE_MASK;
> +	} else {
> +		if (frag_count == nr)
> +			return 0;
> +
> +		ret = atomic_long_sub_return(nr, &page->pp_frag_count);
> +		WARN_ON(ret < 0);
> +	}
> +
> +	return ret;
> +}
> +
> +static inline void page_pool_set_frag_count(struct page *page, long nr)
> +{
> +	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT)
> +		nr |= atomic_long_read(&page->pp_frag_count) & PAGE_MASK;
> +
> +	atomic_long_set(&page->pp_frag_count, nr);
>   }
>   
>   static inline bool is_page_pool_compiled_in(void)
> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index 78838c6..0082f33 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -198,6 +198,16 @@ static bool page_pool_dma_map(struct page_pool *pool, struct page *page)
>   	if (dma_mapping_error(pool->p.dev, dma))
>   		return false;
>   
> +	if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT &&
> +	    WARN_ON(pool->p.flags & PP_FLAG_PAGE_FRAG &&
> +		    dma & ~PAGE_MASK)) {
> +		dma_unmap_page_attrs(pool->p.dev, dma,
> +				     PAGE_SIZE << pool->p.order,
> +				     pool->p.dma_dir,
> +				     DMA_ATTR_SKIP_CPU_SYNC);
> +		return false;
> +	}
> +
>   	page_pool_set_dma_addr(page, dma);
>   
>   	if (pool->p.flags & PP_FLAG_DMA_SYNC_DEV)
> 


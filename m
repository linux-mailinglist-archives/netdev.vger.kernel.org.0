Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527E955C590
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234095AbiF0Ju4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 05:50:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234085AbiF0Juw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 05:50:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E5084616C
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 02:50:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656323450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bpgVvEHm/IV3hFTY2amgkVK+YIMLBXRHwpjPAdXd8MA=;
        b=GEQNMDb2+d4gfZNyNW5wQPUjM5jBO4Zxh0cqWokNml5sTpXBlQvQBv5Y6+GNW3epkjEqQV
        R5/H2Mijl6iGG12wmrVlufbR93b5aLxSQ9QvGou+UaEYm5ekZcjHikYYGvaPBSF02umAlA
        wjMz2zu719nxdlhs62pKiwaViqzQdos=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-VuUPtuhgOp-FB8R3lmmLSg-1; Mon, 27 Jun 2022 05:50:49 -0400
X-MC-Unique: VuUPtuhgOp-FB8R3lmmLSg-1
Received: by mail-lf1-f72.google.com with SMTP id h18-20020a056512055200b004810d1b257aso1878732lfl.13
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 02:50:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=bpgVvEHm/IV3hFTY2amgkVK+YIMLBXRHwpjPAdXd8MA=;
        b=SdA3VmQI0LJysvC0oi2xKnDyfhe1n6N4SLBlLB45ZZl6JSaZjN7r3l9iMM3Y+6996m
         npSowIwLB+uFxtqNzynp/2lwqeMJWOiLNW2uEvv01RswMqKyTm48G406sPi/jQ87NZnu
         IT1Vivl4ijtKEK3HQVXXvkQnfs0niN2BcYdzB0ySxyNt0gsBzALj8iqbxMywkwE8M3eU
         rGNibsdrrUemE3CSxXeCEZeUfm5unoy6z6rvXQEeqi0FXY9Ke0r4VKmlc12BWF+BRa6v
         mY65IRlbX/daY+LNk9wq2vHPvSpxMBpJNLltBANPQlsFe0rA0yISfxYvP737YYfPVcdJ
         sKUA==
X-Gm-Message-State: AJIora9ltcjww92qao6dsZNBmyFnmbhKZpk4qNFaXYXgY2aVPskr8qb0
        JTSTyxo5m/oSnNqGOwS7zGpTcd8zpHvP8gKsKKtzlR/XIy1apFwc56gSGLoNfJFfkgpVlIJAu2o
        5sBu+60z5TSv0Obks
X-Received: by 2002:a05:6512:2208:b0:480:ff57:ab31 with SMTP id h8-20020a056512220800b00480ff57ab31mr7704973lfu.144.1656323446880;
        Mon, 27 Jun 2022 02:50:46 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1v6NtFz8znhFOivwgMDjtuZ13nFN7XQO5FYA1oOa2kxAuJ3kJU0aVCNUE8LBKrPh0N5ds5U7g==
X-Received: by 2002:a05:6512:2208:b0:480:ff57:ab31 with SMTP id h8-20020a056512220800b00480ff57ab31mr7704954lfu.144.1656323446542;
        Mon, 27 Jun 2022 02:50:46 -0700 (PDT)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id d22-20020a2e3316000000b0025907141aa6sm1338611ljc.83.2022.06.27.02.50.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jun 2022 02:50:46 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <64caa039-14fb-c883-de1c-6549b5314269@redhat.com>
Date:   Mon, 27 Jun 2022 11:50:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Cc:     brouer@redhat.com, lorenzo@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        lipeng321@huawei.com, chenhao288@hisilicon.com
Subject: Re: [PATCH net-next] net: page_pool: optimize page pool page
 allocation in NUMA scenario
Content-Language: en-US
To:     Guangbin Huang <huangguangbin2@huawei.com>, hawk@kernel.org,
        ilias.apalodimas@linaro.org, davem@davemloft.net, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com
References: <20220624093621.12505-1-huangguangbin2@huawei.com>
In-Reply-To: <20220624093621.12505-1-huangguangbin2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 24/06/2022 11.36, Guangbin Huang wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> Currently NIC packet receiving performance based on page pool deteriorates
> occasionally. To analysis the causes of this problem page allocation stats
> are collected. Here are the stats when NIC rx performance deteriorates:
> 
> bandwidth(Gbits/s)		16.8		6.91
> rx_pp_alloc_fast		13794308	21141869
> rx_pp_alloc_slow		108625		166481
> rx_pp_alloc_slow_h		0		0
> rx_pp_alloc_empty		8192		8192
> rx_pp_alloc_refill		0		0
> rx_pp_alloc_waive		100433		158289
> rx_pp_recycle_cached		0		0
> rx_pp_recycle_cache_full	0		0
> rx_pp_recycle_ring		362400		420281
> rx_pp_recycle_ring_full		6064893		9709724
> rx_pp_recycle_released_ref	0		0
> 
> The rx_pp_alloc_waive count indicates that a large number of pages' numa
> node are inconsistent with the NIC device numa node. Therefore these pages
> can't be reused by the page pool. As a result, many new pages would be
> allocated by __page_pool_alloc_pages_slow which is time consuming. This
> causes the NIC rx performance fluctuations.
> 
> The main reason of huge numa mismatch pages in page pool is that page pool
> uses alloc_pages_bulk_array to allocate original pages. This function is
> not suitable for page allocation in NUMA scenario. So this patch uses
> alloc_pages_bulk_array_node which has a NUMA id input parameter to ensure
> the NUMA consistent between NIC device and allocated pages.
> 
> Repeated NIC rx performance tests are performed 40 times. NIC rx bandwidth
> is higher and more stable compared to the datas above. Here are three test
> stats, the rx_pp_alloc_waive count is zero and rx_pp_alloc_slow which
> indicates pages allocated from slow patch is relatively low.
> 
> bandwidth(Gbits/s)		93		93.9		93.8
> rx_pp_alloc_fast		60066264	61266386	60938254
> rx_pp_alloc_slow		16512		16517		16539
> rx_pp_alloc_slow_ho		0		0		0
> rx_pp_alloc_empty		16512		16517		16539
> rx_pp_alloc_refill		473841		481910		481585
> rx_pp_alloc_waive		0		0		0
> rx_pp_recycle_cached		0		0		0
> rx_pp_recycle_cache_full	0		0		0
> rx_pp_recycle_ring		29754145	30358243	30194023
> rx_pp_recycle_ring_full		0		0		0
> rx_pp_recycle_released_ref	0		0		0
> 
> Signed-off-by: Jie Wang <wangjie125@huawei.com>
> ---
>   net/core/page_pool.c | 11 ++++++++++-
>   1 file changed, 10 insertions(+), 1 deletion(-)

Thanks for improving this, but we need some small adjustments below.
And then you need to send a V2 of the patch.

> diff --git a/net/core/page_pool.c b/net/core/page_pool.c
> index f18e6e771993..15997fcd78f3 100644
> --- a/net/core/page_pool.c
> +++ b/net/core/page_pool.c
> @@ -377,6 +377,7 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>   	unsigned int pp_order = pool->p.order;
>   	struct page *page;
>   	int i, nr_pages;
> +	int pref_nid; /* preferred NUMA node */
>   
>   	/* Don't support bulk alloc for high-order pages */
>   	if (unlikely(pp_order))
> @@ -386,10 +387,18 @@ static struct page *__page_pool_alloc_pages_slow(struct page_pool *pool,
>   	if (unlikely(pool->alloc.count > 0))
>   		return pool->alloc.cache[--pool->alloc.count];
>   
> +#ifdef CONFIG_NUMA
> +	pref_nid = (pool->p.nid == NUMA_NO_NODE) ? numa_mem_id() : pool->p.nid;
> +#else
> +	/* Ignore pool->p.nid setting if !CONFIG_NUMA, helps compiler */

Remove "helps compiler" from comments, it only make sense in the code
this was copy-pasted from.


> +	pref_nid = numa_mem_id(); /* will be zero like page_to_nid() */

The comment about "page_to_nid()" is only relevant in the code
this was copy-pasted from.

Change to:
	pref_nid = NUMA_NO_NODE;

As alloc_pages_bulk_array_node() will be inlined, the effect (generated 
asm code) will be the same, but it will be better for code maintenance.

> +#endif
> +
>   	/* Mark empty alloc.cache slots "empty" for alloc_pages_bulk_array */
>   	memset(&pool->alloc.cache, 0, sizeof(void *) * bulk);
>   
> -	nr_pages = alloc_pages_bulk_array(gfp, bulk, pool->alloc.cache);
> +	nr_pages = alloc_pages_bulk_array_node(gfp, pref_nid, bulk,
> +					       pool->alloc.cache);
>   	if (unlikely(!nr_pages))
>   		return NULL;
>   


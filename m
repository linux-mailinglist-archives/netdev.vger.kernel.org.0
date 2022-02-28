Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3455C4C63A0
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 08:07:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbiB1HHy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 02:07:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233562AbiB1HHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 02:07:48 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E69B673D8
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:07:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646032027;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aM1f3v+v0oJBo0QOv/UKKwlfWnexuxxWNSd3aHbSrvI=;
        b=Ydsws9B+8bwMzN3a/b6t1tGJzp3UtwshdNOJmlrNqtU4QdDlywL36Fg2DufkXNXIpTIrjw
        tqFVeJp+ADR1LvLy3qkaZnuWUpDUrU4lticS5/nT2rBbMPlqX2Vl7fpIIOD7yfq0pHutfB
        LjdmPSDrp+I28312RPnzn0rTJ25xscA=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-13-bwwAvdjwMH-wYodaCnd9UQ-1; Mon, 28 Feb 2022 02:07:04 -0500
X-MC-Unique: bwwAvdjwMH-wYodaCnd9UQ-1
Received: by mail-ej1-f69.google.com with SMTP id i20-20020a17090671d400b006d0ed9c68c1so4714495ejk.14
        for <netdev@vger.kernel.org>; Sun, 27 Feb 2022 23:07:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=aM1f3v+v0oJBo0QOv/UKKwlfWnexuxxWNSd3aHbSrvI=;
        b=MSR0tVnaxDAorNRbsPCw0SqYKrnF+6OyJV9q/QowPD+/ZikXhZW0nfzbXntSq2/VCt
         cig4OJu3/XC2FQ+G6OFB87R1kaAHAasSLiX27YL65xXnujmb7p9G92K+XggFsUnCZ/GA
         yQma7ZkjU4CbVrIBIe5s7UUcEXoh9HQEa8j+Q/vmv2IHpeheC56Jsaed+5CWulipB9J3
         xj7BN05ajhHtFJCORtDyUovTdefCN0xkzIKUYML6bM5i4RLub5I7IulSWDuRb0BGMEfn
         56AqmHeWtF6BCr31BNdmK8/HceciUDyLBwrbLWbULZav31s2xO13xbMssrX1oR57tnuh
         etTQ==
X-Gm-Message-State: AOAM530QPXBbrdcUnIOWhefAJjsxw5fWespYfMTkokN9mGSFIBpdCqJa
        9iCwdxmOwOGZN7Ae4LCputnAIU0wydp5xVahXCxkOp6ExSQYyHDm9q8c4mk73Tju52toVh7dcyn
        93E2GKw2FZMwyAiLu
X-Received: by 2002:a17:906:a40f:b0:6c9:e255:7926 with SMTP id l15-20020a170906a40f00b006c9e2557926mr13678832ejz.27.1646032023565;
        Sun, 27 Feb 2022 23:07:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyNvGStbKkN5ni8gYN5D7d9yLVjWLGr56YZEagtejWOoO1BEWFsS0GS5ePPNEY3yH6nhKDZoQ==
X-Received: by 2002:a17:906:a40f:b0:6c9:e255:7926 with SMTP id l15-20020a170906a40f00b006c9e2557926mr13678821ejz.27.1646032023359;
        Sun, 27 Feb 2022 23:07:03 -0800 (PST)
Received: from [192.168.0.50] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id bm24-20020a0564020b1800b004129263ff24sm5607952edb.68.2022.02.27.23.07.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 27 Feb 2022 23:07:02 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <8bcd9a94-6fb9-15ab-5a91-0b9d71cfa688@redhat.com>
Date:   Mon, 28 Feb 2022 08:07:01 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com
Subject: Re: [net-next v7 1/4] page_pool: Add allocation stats
Content-Language: en-US
To:     Joe Damato <jdamato@fastly.com>, netdev@vger.kernel.org,
        kuba@kernel.org, ilias.apalodimas@linaro.org, davem@davemloft.net,
        hawk@kernel.org, saeed@kernel.org, ttoukan.linux@gmail.com
References: <1645810914-35485-1-git-send-email-jdamato@fastly.com>
 <1645810914-35485-2-git-send-email-jdamato@fastly.com>
In-Reply-To: <1645810914-35485-2-git-send-email-jdamato@fastly.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 25/02/2022 18.41, Joe Damato wrote:
> Add per-pool statistics counters for the allocation path of a page pool.
> These stats are incremented in softirq context, so no locking or per-cpu
> variables are needed.
> 
> This code is disabled by default and a kernel config option is provided for
> users who wish to enable them.
> 
> The statistics added are:
> 	- fast: successful fast path allocations
> 	- slow: slow path order-0 allocations
> 	- slow_high_order: slow path high order allocations
> 	- empty: ptr ring is empty, so a slow path allocation was forced.
> 	- refill: an allocation which triggered a refill of the cache
> 	- waive: pages obtained from the ptr ring that cannot be added to
> 	  the cache due to a NUMA mismatch.
> 
> Signed-off-by: Joe Damato<jdamato@fastly.com>
> ---
>   include/net/page_pool.h | 18 ++++++++++++++++++
>   net/Kconfig             | 13 +++++++++++++
>   net/core/page_pool.c    | 24 ++++++++++++++++++++----
>   3 files changed, 51 insertions(+), 4 deletions(-)
> 
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 97c3c19..1f27e8a4 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -84,6 +84,19 @@ struct page_pool_params {
>   	void *init_arg;
>   };
>   
> +#ifdef CONFIG_PAGE_POOL_STATS
> +struct page_pool_alloc_stats {
> +	u64 fast; /* fast path allocations */
> +	u64 slow; /* slow-path order 0 allocations */
> +	u64 slow_high_order; /* slow-path high order allocations */
> +	u64 empty; /* failed refills due to empty ptr ring, forcing
> +		    * slow path allocation
> +		    */
> +	u64 refill; /* allocations via successful refill */
> +	u64 waive;  /* failed refills due to numa zone mismatch */
> +};
> +#endif
> +
>   struct page_pool {
>   	struct page_pool_params p;
>   
> @@ -96,6 +109,11 @@ struct page_pool {
>   	unsigned int frag_offset;
>   	struct page *frag_page;
>   	long frag_users;
> +
> +#ifdef CONFIG_PAGE_POOL_STATS
> +	/* these stats are incremented while in softirq context */
> +	struct page_pool_alloc_stats alloc_stats;
> +#endif
>   	u32 xdp_mem_id;

I like the cache-line placement.

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>


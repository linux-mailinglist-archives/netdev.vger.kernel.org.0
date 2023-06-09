Return-Path: <netdev+bounces-9574-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 682CB729DB6
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:03:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1B2DA28185E
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:03:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58BE9182D7;
	Fri,  9 Jun 2023 15:03:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474871640B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:03:06 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A352D6B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686322979;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kliWk5KtWXn6tjlvUWVqn/LoEmMuT+sYK46zS+DbrRU=;
	b=E0hapIaseMCdJwuWgijhtrHGHdxT3WTMJ0bWPLJno8lWtYKbxCCa5urwK1UtxufHjVmQps
	kgonkV/MB4YYjpTqiR1FIDq1STJ3BUm/L2A0NXFt7WzfNNuLFTxkIp17pmiTtYgp4CtbJX
	FmRNTmPOMkYoSp0qWf4Cuj6wJx+XwvQ=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-4XBgNpluNJGQ1jkVlUXETQ-1; Fri, 09 Jun 2023 11:02:58 -0400
X-MC-Unique: 4XBgNpluNJGQ1jkVlUXETQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-97542592eb9so164603766b.2
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 08:02:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686322977; x=1688914977;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kliWk5KtWXn6tjlvUWVqn/LoEmMuT+sYK46zS+DbrRU=;
        b=KSy5Ssr+2Qbaffwdrm6DGgBQbUnQoQ5ucMVFwdUBJtApNRxGahJyIW4+Q5YlfYkkY1
         kxfZfYXyiCIC2NcRW1co5BFzp4DJd859U3HMhZS9hUrk1argw9TqKUwSBp3HS8P+DJ0O
         uRnj0yMz3rDhFQ0RZWPFhfyMf65W12rgt67q/TB/g77QHduj0gQIyYvSDUepB2cAw32c
         PiYlOr90T9rIvsS9YzUjakiVy2pKj2z/kWORA653JmEDHoj6xfVucz/J5wJZqUHB9sYC
         IE6zl3uQ85ygJb2W5i/db5jjur3Rfw9pKqvTAb1VoMlAey6bPF1uLfIyzaMvmwgkBPFy
         LyAQ==
X-Gm-Message-State: AC+VfDylCOIdOkYDfzBhf2mQnKaAKufv+xCxfsX+TH3N7DXOOwcRxtaZ
	R6fr7+Gbg12DcV2uZrUQ2eWcEWH0kZa+/Ooc77pZ8PQcCG/g2TkHwbUbhWzfdZsPkHa3tSRZp59
	w0kIzivplLKI01Uta
X-Received: by 2002:a17:907:a40d:b0:94f:1c90:cb71 with SMTP id sg13-20020a170907a40d00b0094f1c90cb71mr2135519ejc.65.1686322977197;
        Fri, 09 Jun 2023 08:02:57 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7kIJT4Dw+mA4Q9GUBl8PP+/FekH+B7/fILEkXJGqguDJ8zV1PCspweiNi+i2gf5sACJchhag==
X-Received: by 2002:a17:907:a40d:b0:94f:1c90:cb71 with SMTP id sg13-20020a170907a40d00b0094f1c90cb71mr2135493ejc.65.1686322976901;
        Fri, 09 Jun 2023 08:02:56 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id lf29-20020a170907175d00b009787062d21csm1396129ejc.77.2023.06.09.08.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jun 2023 08:02:56 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <4f1a0b7d-973f-80f5-cc39-74f09622ccef@redhat.com>
Date: Fri, 9 Jun 2023 17:02:54 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Alexander Duyck <alexander.duyck@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v3 1/4] page_pool: frag API support for 32-bit
 arch with 64-bit DMA
Content-Language: en-US
To: Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com
References: <20230609131740.7496-1-linyunsheng@huawei.com>
 <20230609131740.7496-2-linyunsheng@huawei.com>
In-Reply-To: <20230609131740.7496-2-linyunsheng@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 09/06/2023 15.17, Yunsheng Lin wrote:
> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> index a7c526ee5024..cd4ac378cc63 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
> @@ -832,6 +832,15 @@ static int mlx5e_alloc_rq(struct mlx5e_params *params,
>   		/* Create a page_pool and register it with rxq */
>   		struct page_pool_params pp_params = { 0 };
>   
> +		/* Return error here to aoivd writing to page->pp_frag_count in
                                         ^^^^^
Typo

> +		 * mlx5e_page_release_fragmented() for page->pp_frag_count is not
> +		 * usable for arch with PAGE_POOL_DMA_USE_PP_FRAG_COUNT being true.
> +		 */
> +		if (PAGE_POOL_DMA_USE_PP_FRAG_COUNT) {
> +			err = -EINVAL;
> +			goto err_free_by_rq_type;
> +		}
> +
>   		pp_params.order     = 0;
>   		pp_params.flags     = PP_FLAG_DMA_MAP | PP_FLAG_DMA_SYNC_DEV | PP_FLAG_PAGE_FRAG;
>   		pp_params.pool_size = pool_size;
> diff --git a/include/net/page_pool.h b/include/net/page_pool.h
> index 126f9e294389..5c7f7501f300 100644
> --- a/include/net/page_pool.h
> +++ b/include/net/page_pool.h
> @@ -33,6 +33,7 @@
>   #include <linux/mm.h> /* Needed by ptr_ring */
>   #include <linux/ptr_ring.h>
>   #include <linux/dma-direction.h>
> +#include <linux/dma-mapping.h>
>   
>   #define PP_FLAG_DMA_MAP		BIT(0) /* Should page_pool do the DMA
>   					* map/unmap
> @@ -50,6 +51,9 @@
>   				 PP_FLAG_DMA_SYNC_DEV |\
>   				 PP_FLAG_PAGE_FRAG)
>   
> +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT	\
> +		(sizeof(dma_addr_t) > sizeof(unsigned long))
> +

I have a problem with the name PAGE_POOL_DMA_USE_PP_FRAG_COUNT
because it is confusing to read in an if-statement.

Proposals rename to:  DMA_OVERLAP_PP_FRAG_COUNT
  Or:  MM_DMA_OVERLAP_PP_FRAG_COUNT
  Or:  DMA_ADDR_OVERLAP_PP_FRAG_COUNT

Notice how I also removed the prefix PAGE_POOL_ because this is a 
MM-layer constraint and not a property of page_pool.


--Jesper



Return-Path: <netdev+bounces-3035-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E20A170534B
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 18:12:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF9711C20EC0
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 16:12:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D641131107;
	Tue, 16 May 2023 16:12:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5DDF34CF9
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 16:12:19 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6850F199F
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1684253521;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZXzkStJ5qOz73TkDFSdDc+mZjP1Ln9pacZajUKMd7uY=;
	b=CIP78Oe5iFiKd3DXcr9U9yKvX//p80iLjkAO7MV6jP/YBUQvGpTVOd8mzqDIlOldpgitHg
	sMLDo8N87gVj/0us1HYHGEcqkWT1g4IjrH9Wr3UY4X6uRwHmF0dY8DfLPJhYwvM4kVr2++
	6FHSEWdEzRWy7HDuu924lvuB59J5yjA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-15--kVvouWQMz6f28AAeXQS_Q-1; Tue, 16 May 2023 12:12:00 -0400
X-MC-Unique: -kVvouWQMz6f28AAeXQS_Q-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-506b21104faso15491280a12.1
        for <netdev@vger.kernel.org>; Tue, 16 May 2023 09:11:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684253518; x=1686845518;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZXzkStJ5qOz73TkDFSdDc+mZjP1Ln9pacZajUKMd7uY=;
        b=MuTBq0VIU7Mw5DRdYyvfCZi+FJfO++i43o3IR0Wd+F5CN3BSBAoW0XD2qVSm2qoyWF
         E0wL2rOqrpIDFS+M6YGIull5YzRDwIfmKHlTKLyEVAypEy8WuajEGuMvLj+bowAsCStq
         edzkaaRiATubKJwS4z1FNZoCVN53ivAT5PDUhfWOMdU5jnAchLdtC+VQXoVmXWF56MBk
         VbrcdErZv+XQezaxMx527SVDPA2zec20zNMz1n1g3kKzkz37VMurwi0SuGEYgovMIMr/
         a8W4HSWB/i8PNW6ZSNSTiyNnyerH80RJK2WVQz+n0iAfD79k6dTsRcwCrQQU0e2J1wX3
         JucQ==
X-Gm-Message-State: AC+VfDztyn0RFn2tgn2Pb6w/ywNPc6NBB+Tf2zEXPbMLqTdS69R59VmF
	tjnOK7kTkoolO7bJIb6XkUUXJai646eg7taCmJBmvbf4TCYIEXmHYNazjK3qkVo0hK/UxSvfnk5
	UH22sp19kk4WBXHSfF8CZlcA7
X-Received: by 2002:a17:906:da8c:b0:94f:7a8:a902 with SMTP id xh12-20020a170906da8c00b0094f07a8a902mr27292113ejb.14.1684253518514;
        Tue, 16 May 2023 09:11:58 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6d1ha1IOKGSdjHoctJTH4PQ39EE7gqcTVJFOLShXjSFJwPxwKkc1Ao7Q3FT+5PQFRCYEXc6g==
X-Received: by 2002:a17:906:da8c:b0:94f:7a8:a902 with SMTP id xh12-20020a170906da8c00b0094f07a8a902mr27292096ejb.14.1684253518166;
        Tue, 16 May 2023 09:11:58 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id v9-20020a170906338900b0094ee99eeb01sm11179428eja.150.2023.05.16.09.11.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 09:11:57 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <ad7d8bdd-9a33-ea34-ae65-aa3762691814@redhat.com>
Date: Tue, 16 May 2023 18:11:56 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, lorenzo.bianconi@redhat.com, bpf@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
 john.fastabend@gmail.com, linyunsheng@huawei.com,
 Alexander Duyck <alexander.duyck@gmail.com>,
 Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [RFC net-next] net: veth: reduce page_pool memory footprint using
 half page per-buffer
Content-Language: en-US
To: Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
References: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
In-Reply-To: <d3ae6bd3537fbce379382ac6a42f67e22f27ece2.1683896626.git.lorenzo@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Cc. Alex Duyck + Eric, please criticize my idea below.

On 12/05/2023 15.08, Lorenzo Bianconi wrote:
> In order to reduce page_pool memory footprint, rely on
> page_pool_dev_alloc_frag routine and reduce buffer size
> (VETH_PAGE_POOL_FRAG_SIZE) to PAGE_SIZE / 2 in order to consume one page
> for two 1500B frames. Reduce VETH_XDP_PACKET_HEADROOM to 192 from 256
> (XDP_PACKET_HEADROOM) to fit max_head_size in VETH_PAGE_POOL_FRAG_SIZE.
> Please note, using default values (CONFIG_MAX_SKB_FRAGS=17), maximum
> supported MTU is now reduced to 36350B.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>   drivers/net/veth.c | 39 +++++++++++++++++++++++++--------------
>   1 file changed, 25 insertions(+), 14 deletions(-)
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 614f3e3efab0..0e648703cccf 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -31,9 +31,12 @@
>   #define DRV_NAME	"veth"
>   #define DRV_VERSION	"1.0"
>   
> -#define VETH_XDP_FLAG		BIT(0)
> -#define VETH_RING_SIZE		256
> -#define VETH_XDP_HEADROOM	(XDP_PACKET_HEADROOM + NET_IP_ALIGN)
> +#define VETH_XDP_FLAG			BIT(0)
> +#define VETH_RING_SIZE			256
> +#define VETH_XDP_PACKET_HEADROOM	192
> +#define VETH_XDP_HEADROOM		(VETH_XDP_PACKET_HEADROOM + \
> +					 NET_IP_ALIGN)
> +#define VETH_PAGE_POOL_FRAG_SIZE	2048
>   
>   #define VETH_XDP_TX_BULK_SIZE	16
>   #define VETH_XDP_BATCH		16
> @@ -736,7 +739,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>   	if (skb_shared(skb) || skb_head_is_locked(skb) ||
>   	    skb_shinfo(skb)->nr_frags ||
>   	    skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> -		u32 size, len, max_head_size, off;
> +		u32 size, len, max_head_size, off, pp_off;
>   		struct sk_buff *nskb;
>   		struct page *page;
>   		int i, head_off;
> @@ -747,17 +750,20 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>   		 *
>   		 * Make sure we have enough space for linear and paged area
>   		 */
> -		max_head_size = SKB_WITH_OVERHEAD(PAGE_SIZE -
> +		max_head_size = SKB_WITH_OVERHEAD(VETH_PAGE_POOL_FRAG_SIZE -
>   						  VETH_XDP_HEADROOM);
> -		if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_size)
> +		if (skb->len >
> +		    VETH_PAGE_POOL_FRAG_SIZE * MAX_SKB_FRAGS + max_head_size)
>   			goto drop;
>   
>   		/* Allocate skb head */
> -		page = page_pool_dev_alloc_pages(rq->page_pool);

It seems wasteful to allocate a full page PAGE_SIZE.

> +		page = page_pool_dev_alloc_frag(rq->page_pool, &pp_off,
> +						VETH_PAGE_POOL_FRAG_SIZE);

Allocating PAGE_SIZE/2 isn't much better.

At this point we already know the skb->len (and skb_headlen).

Why don't we allocated the size that we need?

See page_frag_alloc() system invented by Eric and Duyck.


>   		if (!page)
>   			goto drop;
>   
> -		nskb = napi_build_skb(page_address(page), PAGE_SIZE);
> +		nskb = napi_build_skb(page_address(page) + pp_off,
> +				      VETH_PAGE_POOL_FRAG_SIZE);
>   		if (!nskb) {
>   			page_pool_put_full_page(rq->page_pool, page, true);
>   			goto drop;
> @@ -782,15 +788,18 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>   		len = skb->len - off;
>   
>   		for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
> -			page = page_pool_dev_alloc_pages(rq->page_pool);
> +			page = page_pool_dev_alloc_frag(rq->page_pool, &pp_off,
> +							VETH_PAGE_POOL_FRAG_SIZE);
>   			if (!page) {
>   				consume_skb(nskb);
>   				goto drop;
>   			}
>   
> -			size = min_t(u32, len, PAGE_SIZE);
> -			skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SIZE);
> -			if (skb_copy_bits(skb, off, page_address(page),
> +			size = min_t(u32, len, VETH_PAGE_POOL_FRAG_SIZE);
> +			skb_add_rx_frag(nskb, i, page, pp_off, size,
> +					VETH_PAGE_POOL_FRAG_SIZE);
> +			if (skb_copy_bits(skb, off,
> +					  page_address(page) + pp_off,
>   					  size)) {
>   				consume_skb(nskb);
>   				goto drop;
[...]



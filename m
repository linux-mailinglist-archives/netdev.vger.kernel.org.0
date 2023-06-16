Return-Path: <netdev+bounces-11512-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D60657335FC
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8D01228189D
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:31:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E938F18AFE;
	Fri, 16 Jun 2023 16:31:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE00318AEA
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:31:37 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F5442D72
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:31:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686933095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FPytIYwEkl6QEu7Rgu+ICkD4rqXTkTJ3ru8gg8dbkVU=;
	b=YDCamqWyurashZ3i5O1OandqxeUipq6I1ZoEcS2TcWUrOmfc+zKmIGSnw9+re52Wtr3ZHA
	C7W5mAnLDSfQgx6KjVZJf7JPWXvI22bb9H+w5GRiMNOzeM/EQ7KCvCvCg+ebkyIYhXcdoI
	DPDVGcVbEegfl3I6BHGn2wTiBoe0d1M=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-vmkhOFaROjagXEQ5I49ADQ-1; Fri, 16 Jun 2023 12:31:33 -0400
X-MC-Unique: vmkhOFaROjagXEQ5I49ADQ-1
Received: by mail-ej1-f70.google.com with SMTP id a640c23a62f3a-9715654ab36so61156666b.0
        for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:31:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686933092; x=1689525092;
        h=content-transfer-encoding:in-reply-to:references:to
         :content-language:subject:cc:user-agent:mime-version:date:message-id
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FPytIYwEkl6QEu7Rgu+ICkD4rqXTkTJ3ru8gg8dbkVU=;
        b=NlJb4T+3dGnM7iZ5VoGgSl3ABuge6CGu/XOcXr62HxIeaxLksI507lTn33FJo26jA3
         3xfUSD1jM4SfMe8SRhhXjYaM4x1/g0Rk7XsIF2yPlFg6oDl8N8PQgg438uITjwCpa5tw
         akPjkymoC9LtsN9zaWc2Y9ZLtuNjwh/IkiDzbtc92dfnQMu+yMy1lgFWaJ4aKzWTwqc4
         cuTZxGfYjYQLgbr0TrUqmWDBUyxGc8GQWICdzeKIedp5AgNV4dklPsRN2pHWy96gBSZu
         CCZhdyuUJVSQRokLKgfjmsn3LYXveUxcvJEbA3sXSuPLk2h1Fqt8IhS+18+5zBLs5ny9
         frZA==
X-Gm-Message-State: AC+VfDxbah7RtHXKlNg4vWVnfLM0md6DOq0Vbu18CMC8lZ3TUBN+VSyb
	uTYUL05e27j71FTYGwUCl1LGprcthKEXho0U8QAZzr3B1IXFpM5AYMHgXUi/BPbpMZoCaRek2D+
	3w+POLjw+HzAtV1mj
X-Received: by 2002:a17:907:2cc4:b0:978:70e1:f02e with SMTP id hg4-20020a1709072cc400b0097870e1f02emr2251716ejc.22.1686933092399;
        Fri, 16 Jun 2023 09:31:32 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ6QwaRaNv6ifNugvelfv7foAf6nRIFf7h4Hs5kRZnyhyelYJppcvYV1pqXjZMzTH6ieVSVktw==
X-Received: by 2002:a17:907:2cc4:b0:978:70e1:f02e with SMTP id hg4-20020a1709072cc400b0097870e1f02emr2251685ejc.22.1686933091957;
        Fri, 16 Jun 2023 09:31:31 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id s2-20020a170906960200b00982834553a6sm3278848ejx.165.2023.06.16.09.31.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jun 2023 09:31:31 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <f8ce176f-f975-af11-641c-b56c53a8066a@redhat.com>
Date: Fri, 16 Jun 2023 18:31:29 +0200
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Cc: brouer@redhat.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Jesper Dangaard Brouer <hawk@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Eric Dumazet <edumazet@google.com>, Maryam Tahhan <mtahhan@redhat.com>,
 bpf <bpf@vger.kernel.org>
Subject: Re: [PATCH net-next v3 3/4] page_pool: introduce page_pool_alloc()
 API
Content-Language: en-US
To: Yunsheng Lin <linyunsheng@huawei.com>,
 Jesper Dangaard Brouer <jbrouer@redhat.com>,
 Alexander Duyck <alexander.duyck@gmail.com>
References: <20230609131740.7496-1-linyunsheng@huawei.com>
 <20230609131740.7496-4-linyunsheng@huawei.com>
 <CAKgT0UfVwQ=ri7ZDNnsATH2RQpEz+zDBBb6YprvniMEWGdw+dQ@mail.gmail.com>
 <36366741-8df2-1137-0dd9-d498d0f770e4@huawei.com>
 <CAKgT0UdXTSv1fDHBX4UC6Ok9NXKMJ_9F88CEv5TK+mpzy0N21g@mail.gmail.com>
 <c06f6f59-6c35-4944-8f7a-7f6f0e076649@huawei.com>
 <CAKgT0UccmDe+CE6=zDYQHi1=3vXf5MptzDo+BsPrKdmP5j9kgQ@mail.gmail.com>
 <0ba1bf9c-2e45-cd44-60d3-66feeb3268f3@redhat.com>
 <dcc9db4c-207b-e118-3d84-641677cd3d80@huawei.com>
In-Reply-To: <dcc9db4c-207b-e118-3d84-641677cd3d80@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net



On 16/06/2023 13.57, Yunsheng Lin wrote:
> On 2023/6/16 0:19, Jesper Dangaard Brouer wrote:
> 
> ...
> 
>> You have mentioned veth as the use-case. I know I acked adding page_pool
>> use-case to veth, for when we need to convert an SKB into an
>> xdp_buff/xdp-frame, but maybe it was the wrong hammer(?).
>> In this case in veth, the size is known at the page allocation time.
>> Thus, using the page_pool API is wasting memory.  We did this for
>> performance reasons, but we are not using PP for what is was intended
>> for.  We mostly use page_pool, because it an existing recycle return
>> path, and we were too lazy to add another alloc-type (see enum
>> xdp_mem_type).
>>
>> Maybe you/we can extend veth to use this dynamic size API, to show us
>> that this is API is a better approach.  I will signup for benchmarking
>> this (and coordinating with CC Maryam as she came with use-case we
>> improved on).
> 
> Thanks, let's find out if page pool is the right hammer for the
> veth XDP case.
> 
> Below is the change for veth using the new api in this patch.
> Only compile test as I am not familiar enough with veth XDP and
> testing environment for it.
> Please try it if it is helpful.
> 
> diff --git a/drivers/net/veth.c b/drivers/net/veth.c
> index 614f3e3efab0..8850394f1d29 100644
> --- a/drivers/net/veth.c
> +++ b/drivers/net/veth.c
> @@ -736,7 +736,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>          if (skb_shared(skb) || skb_head_is_locked(skb) ||
>              skb_shinfo(skb)->nr_frags ||
>              skb_headroom(skb) < XDP_PACKET_HEADROOM) {
> -               u32 size, len, max_head_size, off;
> +               u32 size, len, max_head_size, off, truesize, page_offset;
>                  struct sk_buff *nskb;
>                  struct page *page;
>                  int i, head_off;
> @@ -752,12 +752,15 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>                  if (skb->len > PAGE_SIZE * MAX_SKB_FRAGS + max_head_size)
>                          goto drop;
> 
> +               size = min_t(u32, skb->len, max_head_size);
> +               truesize = size;
> +
>                  /* Allocate skb head */
> -               page = page_pool_dev_alloc_pages(rq->page_pool);
> +               page = page_pool_dev_alloc(rq->page_pool, &page_offset, &truesize);

Maybe rename API to:

  addr = netmem_alloc(rq->page_pool, &truesize);

>                  if (!page)
>                          goto drop;
> 
> -               nskb = napi_build_skb(page_address(page), PAGE_SIZE);
> +               nskb = napi_build_skb(page_address(page) + page_offset, truesize);

IMHO this illustrates that API is strange/funky.
(I think this is what Alex Duyck is also pointing out).

This is the memory (virtual) address "pointer":
  addr = page_address(page) + page_offset

This is what napi_build_skb() takes as input. (I looked at other users 
of napi_build_skb() whom all give a mem ptr "va" as arg.)
So, why does your new API provide the "page" and not just the address?

As proposed above:
   addr = netmem_alloc(rq->page_pool, &truesize);

Maybe the API should be renamed, to indicate this isn't returning a "page"?
We have talked about the name "netmem" before.

>                  if (!nskb) {
>                          page_pool_put_full_page(rq->page_pool, page, true);
>                          goto drop;
> @@ -767,7 +770,6 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>                  skb_copy_header(nskb, skb);
>                  skb_mark_for_recycle(nskb);
> 
> -               size = min_t(u32, skb->len, max_head_size);
>                  if (skb_copy_bits(skb, 0, nskb->data, size)) {
>                          consume_skb(nskb);
>                          goto drop;
> @@ -782,14 +784,17 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
>                  len = skb->len - off;
> 
>                  for (i = 0; i < MAX_SKB_FRAGS && off < skb->len; i++) {
> -                       page = page_pool_dev_alloc_pages(rq->page_pool);
> +                       size = min_t(u32, len, PAGE_SIZE);
> +                       truesize = size;
> +
> +                       page = page_pool_dev_alloc(rq->page_pool, &page_offset,
> +                                                  &truesize);
>                          if (!page) {
>                                  consume_skb(nskb);
>                                  goto drop;
>                          }
> 
> -                       size = min_t(u32, len, PAGE_SIZE);
> -                       skb_add_rx_frag(nskb, i, page, 0, size, PAGE_SIZE);
> +                       skb_add_rx_frag(nskb, i, page, page_offset, size, truesize);

Guess, this shows the opposite; that the "page" _is_ used by the 
existing API.

>                          if (skb_copy_bits(skb, off, page_address(page),
>                                            size)) {
>                                  consume_skb(nskb);

--Jesper



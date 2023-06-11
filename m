Return-Path: <netdev+bounces-9901-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9F88172B174
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 12:47:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0B0F28130B
	for <lists+netdev@lfdr.de>; Sun, 11 Jun 2023 10:47:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EE018467;
	Sun, 11 Jun 2023 10:47:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 130F82900
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 10:47:49 +0000 (UTC)
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CFB01734
	for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 03:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1686480467;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=j68gTnjgXVwXYZVMYqrbKZ59sLTdFoJLwLEaM6oQtU0=;
	b=gkVcopoLdRPQNeCHRSTFc7g4kYf9VE4hgSuXmn7bq/9UTdmAQirc5/Qxy31QbRmP81N7rs
	bGhs2HqE1ITPFywFe/ImO9P0B1fmwMfeOnqlAbM6wGcNdYmCTT74YhgNcQOXekucrgVwcg
	c+91SQy/HVesmatvLzmozDIL9nnxmnM=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-45-IvxuyC4FMZm5liZx-rNlsg-1; Sun, 11 Jun 2023 06:47:46 -0400
X-MC-Unique: IvxuyC4FMZm5liZx-rNlsg-1
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-5128dcbdfc1so2620186a12.1
        for <netdev@vger.kernel.org>; Sun, 11 Jun 2023 03:47:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686480465; x=1689072465;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :to:subject:cc:user-agent:mime-version:date:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j68gTnjgXVwXYZVMYqrbKZ59sLTdFoJLwLEaM6oQtU0=;
        b=dNhqqjimoQIj+W5MXsXupFpChDEj/4qmz08AauKNLsGmtgtayRpl9R1TYBh7LelV5u
         77SJzo7vwP1/TlRyjsG4XovTRoF3dK8OGNYVKJN6ewaoRja92pKXthBkWEHoBf4Jzq18
         bWXTYlRiL+NcdRHiy4bpnO/v5JeuOebRjTxzwiE2+vndPcrIx+vOHsFBN1Z7mdFD88Fj
         NUHnAWCSsgjG64c+KbjWzEmAlyDaLTzGIJMfEa+mrwxVS7BcLdv4PylSlK2txx6lYiE2
         Ui4AA3LsqD/5XAuYDQ7hhBiG/06cFV8AxVKO7KUK0gzPZH3K0qKbjHSSXctOU6gCtULc
         2YDQ==
X-Gm-Message-State: AC+VfDysPAP60Ntqfjkzv2qhxu2p2h6jkWonaayrQ/HRkW1dO8uHkskj
	EV3SkpfDkt1OKdD+/zd0PqJdhzYxAG7nuJjEju2P1/PT1jadDOFfsH8wMt4Q5W5f5JEoHnyTaRp
	alImLw1O+CHlms/xi
X-Received: by 2002:aa7:c6c3:0:b0:516:7b3f:545d with SMTP id b3-20020aa7c6c3000000b005167b3f545dmr2758987eds.30.1686480464916;
        Sun, 11 Jun 2023 03:47:44 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ57qE8T9gh9Ypb/Kp13VH7CgAknx2ku8kmlUzRz5ru8rxbZEGZsSTjapnYql/AAy5jug9pyfg==
X-Received: by 2002:aa7:c6c3:0:b0:516:7b3f:545d with SMTP id b3-20020aa7c6c3000000b005167b3f545dmr2758964eds.30.1686480464613;
        Sun, 11 Jun 2023 03:47:44 -0700 (PDT)
Received: from [192.168.42.222] (194-45-78-10.static.kviknet.net. [194.45.78.10])
        by smtp.gmail.com with ESMTPSA id w8-20020aa7cb48000000b0051632dc69absm3776418edt.86.2023.06.11.03.47.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 11 Jun 2023 03:47:43 -0700 (PDT)
From: Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <2c48652e-ace4-45c8-7a7d-5ec87d1b0b75@redhat.com>
Date: Sun, 11 Jun 2023 12:47:42 +0200
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
To: Yunsheng Lin <yunshenglin0825@gmail.com>,
 Jesper Dangaard Brouer <jbrouer@redhat.com>,
 Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com
References: <20230609131740.7496-1-linyunsheng@huawei.com>
 <20230609131740.7496-2-linyunsheng@huawei.com>
 <4f1a0b7d-973f-80f5-cc39-74f09622ccef@redhat.com>
 <1bbf2afa-91b2-a3d0-60e0-81cd386eb68d@gmail.com>
Content-Language: en-US
In-Reply-To: <1bbf2afa-91b2-a3d0-60e0-81cd386eb68d@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On 10/06/2023 15.13, Yunsheng Lin wrote:
> On 2023/6/9 23:02, Jesper Dangaard Brouer wrote:
> ...
> 
>>>                     PP_FLAG_DMA_SYNC_DEV |\
>>>                     PP_FLAG_PAGE_FRAG)
>>>    +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT    \
>>> +        (sizeof(dma_addr_t) > sizeof(unsigned long))
>>> +
>>
>> I have a problem with the name PAGE_POOL_DMA_USE_PP_FRAG_COUNT
>> because it is confusing to read in an if-statement.
> 
> Actually, it is already in an if-statement before this patch:)

I did notice, but I've had a problem with this name for a while.
(see later, why this might be long in separate patch)

> Maybe starting to use it in the driver is confusing to you?
> If not, maybe we can keep it that for now, and change it when
> we come up with a better name.
> 
>>
>> Proposals rename to:  DMA_OVERLAP_PP_FRAG_COUNT
>>   Or:  MM_DMA_OVERLAP_PP_FRAG_COUNT
>>   Or:  DMA_ADDR_OVERLAP_PP_FRAG_COUNT
> 
> It seems DMA_ADDR_OVERLAP_PP_FRAG_COUNT is better,
> and DMA_ADDR_UPPER_OVERLAP_PP_FRAG_COUNT seems more accurate if a
> longer macro name is not an issue here.
> 

I like the shorter DMA_ADDR_OVERLAP_PP_FRAG_COUNT variant best.

>>
>> Notice how I also removed the prefix PAGE_POOL_ because this is a
>> MM-layer constraint and not a property of page_pool.
> 
> I am not sure if it is a MM-layer constraint yet.
> Do you mean 'MM-layer constraint' as 'struct page' not having
> enough space for page pool with 32-bit arch with 64-bit DMA?

Yes.

> If that is the case, we may need a more generic name for that
> constraint instead of 'DMA_ADDR_OVERLAP_PP_FRAG_COUNT'?
>

I think this name is clear enough; the dma_addr_t is overlapping the 
pp_frag_count.


> And a more generic name seems confusing for page pool too, as
> it doesn't tell that we only have that problem for 32-bit arch
> with 64-bit DMA.
> 
> So if the above makes sense, it seems we may need to keep the
> PAGE_POOL_ prefix, which would be
> 'PAGE_POOL_DMA_ADDR_UPPER_OVERLAP_PP_FRAG_COUNT' if the long
> name is not issue here.
> 

I think it gets too long now.

Also I still disagree with PAGE_POOL_ prefix, if anything it is a
property of 'struct page'.  Thus a prefix with PAGE_ make more sense to
me, but it also gets too long (for my taste).

> Anyway, naming is hard, we may need a seperate patch to explain
> it, which is not really related to this patchset IHMO, so I'd
> rather keep it as before if we can not come up with a name which
> is not confusing to most people.
> 

Okay, lets do the (re)naming in another patch then.

--Jesper



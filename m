Return-Path: <netdev+bounces-9812-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8B5CD72ABA4
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 15:13:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 54F2A1C20AC3
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 13:13:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2736A16421;
	Sat, 10 Jun 2023 13:13:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A14ABA4E
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 13:13:45 +0000 (UTC)
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F04426B1;
	Sat, 10 Jun 2023 06:13:44 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d9443c01a7336-1b3b5a5134dso596415ad.2;
        Sat, 10 Jun 2023 06:13:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686402823; x=1688994823;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xsZHpFFEg1aiG9pWfwZJZiPP97oTmn5dJUzpJC9EWqY=;
        b=Lhx3+goHLzT60FeyKoZ6DHIuzTkj3UxiIdQ1KMPp0aBK2bxWJ1sRcCob+LT9u1rEsf
         p4+oQUxXGRoxTYqRAtP15/E2nN+/XqSjcVfEsM/5LXCw/GhkLiqcxiQVTGkxkp7TFZjs
         21rlXwkHxFNgBxyOmBweFkidGSYPbmd17ftthCB9FdSow+LmbmObHW17eAvEvtPngdUF
         7LYY6kvbXQMyEHZr92k58N+4pSafCiCkYZMnKrhGjvieZYsImTNFn+bfpYmaGWE+4WJd
         AKvLXrEDtyti/IjjoKKq7yphIKGtR4uzAZxDT5gtcfi1ZKSfzbSBg7cGBFggMYL6lDy4
         R63Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686402823; x=1688994823;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xsZHpFFEg1aiG9pWfwZJZiPP97oTmn5dJUzpJC9EWqY=;
        b=UNB7TrcDF+oucUTktGlArbZoZ7zpytqefwAJBxT2CasgPWgcOJtVpP3bKQvD1PLNwL
         6PruJfuAbxEr4tl3q+zVZmGnUDphnQHv4LCpbHDfCXj13JVym195pOVmfljKJc6MudrH
         1k7Sp5Ju9JMBT7KkiaP3aqRrl6mjuiFamLB2kY5aeJT4n16NLB0Hl9JzClEMj9x1NTK9
         21Bvl0enPCH+paykFjceyGqi/1yNctTxjdqFxSur65lzobz4yLzKQE+aCrx2NBMYdPUv
         /hmfvots/wbEGCQaodqRq3qhxzVOQYyHab0jHyvoSUXt1kmdOruAyMdtxK0u7LZFQ9qx
         /dQQ==
X-Gm-Message-State: AC+VfDxXkV8PzOw6u1aNlmOBeRLLzX/mBn1o8iyo3dRjpJOdE3mFQ1Ft
	VnBDUGM1gOdKyvxbH020EgxcWBKDJ9EG0FBnwx4=
X-Google-Smtp-Source: ACHHUZ5HXZMOmfbEv2/eWLiHRpM3NQeADEJCnzd539jzBqe8sDyS60Wc8qanH4oltZdQRMjKrxNtBg==
X-Received: by 2002:a17:902:c411:b0:1af:b7cd:5961 with SMTP id k17-20020a170902c41100b001afb7cd5961mr2655583plk.1.1686402823481;
        Sat, 10 Jun 2023 06:13:43 -0700 (PDT)
Received: from ?IPv6:2409:8a55:301b:e120:20b4:84e8:2690:6d80? ([2409:8a55:301b:e120:20b4:84e8:2690:6d80])
        by smtp.gmail.com with ESMTPSA id jj19-20020a170903049300b001aae64e9b36sm5001073plb.114.2023.06.10.06.13.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 10 Jun 2023 06:13:42 -0700 (PDT)
Subject: Re: [PATCH net-next v3 1/4] page_pool: frag API support for 32-bit
 arch with 64-bit DMA
To: Jesper Dangaard Brouer <jbrouer@redhat.com>,
 Yunsheng Lin <linyunsheng@huawei.com>, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com
Cc: brouer@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 Lorenzo Bianconi <lorenzo@kernel.org>,
 Alexander Duyck <alexander.duyck@gmail.com>,
 Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 linux-rdma@vger.kernel.org
References: <20230609131740.7496-1-linyunsheng@huawei.com>
 <20230609131740.7496-2-linyunsheng@huawei.com>
 <4f1a0b7d-973f-80f5-cc39-74f09622ccef@redhat.com>
From: Yunsheng Lin <yunshenglin0825@gmail.com>
Message-ID: <1bbf2afa-91b2-a3d0-60e0-81cd386eb68d@gmail.com>
Date: Sat, 10 Jun 2023 21:13:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <4f1a0b7d-973f-80f5-cc39-74f09622ccef@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
	FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 2023/6/9 23:02, Jesper Dangaard Brouer wrote:
...

>>                    PP_FLAG_DMA_SYNC_DEV |\
>>                    PP_FLAG_PAGE_FRAG)
>>   +#define PAGE_POOL_DMA_USE_PP_FRAG_COUNT    \
>> +        (sizeof(dma_addr_t) > sizeof(unsigned long))
>> +
> 
> I have a problem with the name PAGE_POOL_DMA_USE_PP_FRAG_COUNT
> because it is confusing to read in an if-statement.

Actually, it is already in an if-statement before this patch:)
Maybe starting to use it in the driver is confusing to you?
If not, maybe we can keep it that for now, and change it when
we come up with a better name.

> 
> Proposals rename to:  DMA_OVERLAP_PP_FRAG_COUNT
>  Or:  MM_DMA_OVERLAP_PP_FRAG_COUNT
>  Or:  DMA_ADDR_OVERLAP_PP_FRAG_COUNT

It seems DMA_ADDR_OVERLAP_PP_FRAG_COUNT is better,
and DMA_ADDR_UPPER_OVERLAP_PP_FRAG_COUNT seems more accurate if a
longer macro name is not an issue here.

> 
> Notice how I also removed the prefix PAGE_POOL_ because this is a MM-layer constraint and not a property of page_pool.

I am not sure if it is a MM-layer constraint yet.
Do you mean 'MM-layer constraint' as 'struct page' not having
enough space for page pool with 32-bit arch with 64-bit DMA?
If that is the case, we may need a more generic name for that
constraint instead of 'DMA_ADDR_OVERLAP_PP_FRAG_COUNT'?

And a more generic name seems confusing for page pool too, as
it doesn't tell that we only have that problem for 32-bit arch
with 64-bit DMA.

So if the above makes sense, it seems we may need to keep the
PAGE_POOL_ prefix, which would be
'PAGE_POOL_DMA_ADDR_UPPER_OVERLAP_PP_FRAG_COUNT' if the long
name is not issue here.

Anyway, naming is hard, we may need a seperate patch to explain
it, which is not really related to this patchset IHMO, so I'd
rather keep it as before if we can not come up with a name which
is not confusing to most people.

> 
> 
> --Jesper
> 
> 


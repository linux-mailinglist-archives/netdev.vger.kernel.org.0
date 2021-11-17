Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF9D54545FF
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 12:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbhKQLz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 06:55:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49343 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237040AbhKQLzY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Nov 2021 06:55:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637149945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HvX66XOs0ZBobeStnWySNo3Mavv4MDJzDS3S8I8/fiQ=;
        b=fKGyi/uWf77UnqujzuIBmu29DfwuzcPaCcAn5DiMl3+u6JHeovoV2AJPgjH4BMEmGVJlF+
        EWRYRtmxHsMUg32arKbdJYaiBAMT7sx/6LRjHZvhbV+OwrVtVhoXT8oWlc/2fuUCxMgOwI
        PuBSGbplCDhPq28sbYjEtHrI6J0/fZ8=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-558-7JWAaD73NmevCRv3vkQ46w-1; Wed, 17 Nov 2021 06:52:24 -0500
X-MC-Unique: 7JWAaD73NmevCRv3vkQ46w-1
Received: by mail-ed1-f70.google.com with SMTP id v9-20020a50d849000000b003dcb31eabaaso1903166edj.13
        for <netdev@vger.kernel.org>; Wed, 17 Nov 2021 03:52:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=HvX66XOs0ZBobeStnWySNo3Mavv4MDJzDS3S8I8/fiQ=;
        b=7dQCKq6ipwjCWjmibgaQ5RdfYM75i8BCTJMi4DB7Fkugxd3vWy4d1Vr7WSkRbuDVVs
         RCDOtuarkHFJ7O2SwqrfkjeiS7RCZipymhoQFJBU62cPWWoh6dj8UZOhbLKGFji2CgU1
         oi/o4/DvdtjFCl96+aRgr3LTH0sYRAu1tGwvvBtdKkaP5hgwmi1HtIUATGCq0i78Aelh
         QoukrE4+BD/3NWPz/5b6DGCswMWoY1U7PbEPgVVtdGU75MV0/mx5VtIzAT9noYmC0Nfe
         NfsndsdoMwSBhzfM4SHC8ebiheAi15GPgnPaacfyLofT83meEnb6r+gXUCU2BZjyvNoC
         7f1w==
X-Gm-Message-State: AOAM532rTd3JppzBoKPAOGmCyGfmdZ2MYTdgbAtH8atgen/4eY2PvBT8
        SlJg/b6XmgO9TfPxkhDiKNkHq1wA9gOGBbaHVJ7PFxH+zlGAoQVS3hTAwCjCuAEjjQnA8liO3zy
        3MQR6OYcxs4nPUD41
X-Received: by 2002:a05:6402:438a:: with SMTP id o10mr21205072edc.353.1637149942142;
        Wed, 17 Nov 2021 03:52:22 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwKZxP+dS8RoGlJQ+jqQ+6CML1qsEojuHmMVRttO2pMm8MZB+vTKc9ip9N+Y8IFaFMLR5LTjQ==
X-Received: by 2002:a05:6402:438a:: with SMTP id o10mr21205045edc.353.1637149941916;
        Wed, 17 Nov 2021 03:52:21 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id b14sm7872857edw.6.2021.11.17.03.52.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Nov 2021 03:52:21 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <712f3c04-ffc4-0ae1-00e2-1acb1af81154@redhat.com>
Date:   Wed, 17 Nov 2021 12:52:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com, Yunsheng Lin <linyunsheng@huawei.com>,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        akpm@linux-foundation.org, peterz@infradead.org, will@kernel.org,
        jhubbard@nvidia.com, yuzhao@google.com, mcroce@microsoft.com,
        fenghua.yu@intel.com, feng.tang@intel.com, jgg@ziepe.ca,
        aarcange@redhat.com, guro@fb.com,
        "kernelci@groups.io" <kernelci@groups.io>
Subject: Re: [PATCH net-next v6] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
Content-Language: en-US
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Jesper Dangaard Brouer <jbrouer@redhat.com>
References: <20211013091920.1106-1-linyunsheng@huawei.com>
 <b9c0e7ef-a7a2-66ad-3a19-94cc545bd557@collabora.com>
 <1090744a-3de6-1dc2-5efe-b7caae45223a@huawei.com>
 <644e10ca-87b8-b553-db96-984c0b2c6da1@collabora.com>
 <93173400-1d37-09ed-57ef-931550b5a582@huawei.com>
 <YZJKNLEm6YTkygHM@apalos.home>
 <CAC_iWjKFLr932sMt9G2T+MFYUAQZNWPqp6YsnmSd3rMia7OpoA@mail.gmail.com>
 <d0223831-44ff-3e1a-1be9-27d751dc39f2@huawei.com>
 <8c688448-e8a9-5a6b-7b17-ccd294a416d3@redhat.com>
 <YZKtD4+13gQBXEX6@apalos.home>
In-Reply-To: <YZKtD4+13gQBXEX6@apalos.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 15/11/2021 19.55, Ilias Apalodimas wrote:
> 
> [...]
> 
>>>>>>>>> Some more details can be found here:
>>>>>>>>>
>>>>>>>>>     https://linux.kernelci.org/test/case/id/6189968c3ec0a3c06e3358fe/
>>>>>>>>>
>>>>>>>>> Here's the same revision on the same platform booting fine with a
>>>>>>>>> plain multi_v7_defconfig build:
>>>>>>>>>
>>>>>>>>>     https://linux.kernelci.org/test/plan/id/61899d322c0e9fee7e3358ec/
>>>>>>>>>
>>>>>>>>> Please let us know if you need any help debugging this issue or
>>>>>>>>> if you have a fix to try.
>>>>>>>>
>>>>>>>> The patch below is removing the dma mapping support in page pool
>>>>>>>> for 32 bit systems with 64 bit dma address, so it seems there
>>>>>>>> is indeed a a drvier using the the page pool with PP_FLAG_DMA_MAP
>>>>>>>> flags set in a 32 bit systems with 64 bit dma address.
>>>>>>>>
>>>>>>>> It seems we might need to revert the below patch or implement the
>>>>>>>> DMA-mapping tracking support in the driver as mentioned in the below
>>>>>>>> commit log.
>>>>>>>>
>>>>>>>> which ethernet driver do you use in your system?
>>>>>>>
>>>>>>> Thanks for taking a look and sorry for the slow reply.  Here's a
>>>>>>> booting test job with LPAE disabled:
>>>>>>>
>>>>>>>       https://linux.kernelci.org/test/plan/id/618dbb81c60c4d94503358f1/
>>>>>>>       https://storage.kernelci.org/mainline/master/v5.15-12452-g5833291ab6de/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-nfs-rk3288-rock2-square.html#L812
>>>>>>>
>>>>>>> [    8.314523] rk_gmac-dwmac ff290000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>>>>>>>
>>>>>>> So the driver is drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
>>>>>>
>>>>>> Thanks for the report, this patch seems to cause problem for 32-bit
>>>>>> system with LPAE enabled.
>>>>>>
>>>>>> As LPAE seems like a common feature for 32 bits system, this patch
>>>>>> might need to be reverted.
>>>>>>
>>>>>> @Jesper, @Ilias, what do you think?
>>>>>
>>>>>
>>>>> So enabling LPAE also enables CONFIG_ARCH_DMA_ADDR_T_64BIT on that board?
>>>>> Doing a quick grep only selects that for XEN.  I am ok reverting that,  but
>>>>> I think we need to understand how the dma address ended up being 64bit.
>>>>
>>>> So looking a bit closer, indeed enabling LPAE always enables this.  So
>>>> we need to revert the patch.
>>>> Yunsheng will you send that?
>>>
>>> Sure.
>>
>> Why don't we change that driver[1] to not use page_pool_get_dma_addr() ?
>>
>>   [1] drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
>>
>> I took a closer look and it seems the driver have struct stmmac_rx_buffer in
>> which is stored the dma_addr it gets from page_pool_get_dma_addr().
>>
>> See func: stmmac_init_rx_buffers
>>
>>   static int stmmac_init_rx_buffers(struct stmmac_priv *priv,
>> 				struct dma_desc *p,
>> 				int i, gfp_t flags, u32 queue)
>>   {
>>
>> 	if (!buf->page) {
>> 		buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
>> 		if (!buf->page)
>> 			return -ENOMEM;
>> 		buf->page_offset = stmmac_rx_offset(priv);
>> 	}
>> 	[...]
>>
>> 	buf->addr = page_pool_get_dma_addr(buf->page) + buf->page_offset;
>>
>> 	stmmac_set_desc_addr(priv, p, buf->addr);
>> 	[...]
>>   }
>>
>> I question if this driver really to use page_pool for storing the dma_addr
>> as it just extract it and store it outside page_pool?
>>
>> @Ilias it looks like you added part of the page_pool support in this driver,
>> so I hope you can give a qualified guess on:
>> How much work will it be to let driver do the DMA-map itself?
>> (and not depend on the DMA-map feature provided by page_pool)
> 
> It shouldn't be that hard.   However when we removed that we were hoping we
> had no active consumers.  So we'll have to fix this and check for other
> 32-bit boards with LPAE and page_pool handling the DMA mappings.
> But the point now is that this is far from a 'hardware configuration' of
> 32-bit CPU + 64-bit DMA.  Every armv7 and x86 board can get that.  So I was
> thinking it's better to revert this and live with the 'weird' handling in the
> code.

Okay, I acked the revert.  After discussing this over IRC with Ilias (my 
page_pool co-maintainer). Guess we will have to live with maintaining 
this code for 32-bit CPU + 64-bit DMA.

--Jesper


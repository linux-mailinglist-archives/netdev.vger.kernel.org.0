Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3EE45074B
	for <lists+netdev@lfdr.de>; Mon, 15 Nov 2021 15:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232203AbhKOOn0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 09:43:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:20079 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236763AbhKOOmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 09:42:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636987180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=saNls1B2C2vIhcvJH+P48yAQJomMR68V4SPGiVFRMfE=;
        b=PbLdD+ThH0gjZLyJJMetFgdjtfQh/5zxc09nyKrmn1OEUTiiiw5OAeruzPIgF+TyRn1RUJ
        FIR0N6BoUehI2WLpukZFVybjlWVOKAvjUVTpkn54/CbMf7sFHz7QXgKi9PGo8BFIth7Dkc
        NXhBnb8qF7aVA8+ZqQqlLZyEeaFYCac=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-155-Xtv6R_cRP6qad-gq0hozZg-1; Mon, 15 Nov 2021 09:39:39 -0500
X-MC-Unique: Xtv6R_cRP6qad-gq0hozZg-1
Received: by mail-ed1-f70.google.com with SMTP id m8-20020a056402510800b003e29de5badbso14164761edd.18
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 06:39:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:date:mime-version:user-agent:cc
         :subject:content-language:to:references:in-reply-to
         :content-transfer-encoding;
        bh=saNls1B2C2vIhcvJH+P48yAQJomMR68V4SPGiVFRMfE=;
        b=BOHr93HoGtLSUHPSrkUdFSlCi3+LUwtmuODqhN1P04J7JhthIBV69hmv8OHcSHYQPX
         4gKpYGAhdus6xiL432VQIHdCRhU8+LK6xsUrZQ7A/J0efdtr3Gf4Eb8UZ/KxNV942GO1
         hPzImHsBaeet//+LzcvjTnXSgyxJORNabkxbRK2XCSb1xOy1sdjFCsKgUSLoHjtHqVKg
         oN7aYwG6l72/hnDB+qGITsPVBaWTLyQJSt9siYmajHriO82P1qIOmkFZEsSRIOPZ9Vs0
         p6EMqNgexCyQ1jJWq6NYH8PClaF2HRtFKX6zUyKtwxoi6rovDdEybCT9HCvtl4EVxzsp
         Hrlw==
X-Gm-Message-State: AOAM532B1Fke3+rh1IXA26aA6OvoA8ahCyyrs2VOw2jhUIBFkpJ50nKb
        eErmnohbMULx1pGNdq7tTcfCkHQ6x5U5mkTXoviBSytvdEXYf9L4C6m6l2le7jwxxaLaLqhCWD0
        kHsjg3pR3xxe9X6wk
X-Received: by 2002:a05:6402:280c:: with SMTP id h12mr8693426ede.120.1636987177928;
        Mon, 15 Nov 2021 06:39:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzuOzF39oL6xR8KH2WdXK+FtGTQfGagG/IzVn/t9PI52SrwLnqT9NfaxYy3kwFmxHfc0Y2GEw==
X-Received: by 2002:a05:6402:280c:: with SMTP id h12mr8693398ede.120.1636987177758;
        Mon, 15 Nov 2021 06:39:37 -0800 (PST)
Received: from [192.168.2.13] (3-14-107-185.static.kviknet.dk. [185.107.14.3])
        by smtp.gmail.com with ESMTPSA id q7sm5503446edr.9.2021.11.15.06.39.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Nov 2021 06:39:37 -0800 (PST)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Message-ID: <8c688448-e8a9-5a6b-7b17-ccd294a416d3@redhat.com>
Date:   Mon, 15 Nov 2021 15:39:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Cc:     brouer@redhat.com,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org,
        hawk@kernel.org, akpm@linux-foundation.org, peterz@infradead.org,
        will@kernel.org, jhubbard@nvidia.com, yuzhao@google.com,
        mcroce@microsoft.com, fenghua.yu@intel.com, feng.tang@intel.com,
        jgg@ziepe.ca, aarcange@redhat.com, guro@fb.com,
        "kernelci@groups.io" <kernelci@groups.io>
Subject: Re: [PATCH net-next v6] page_pool: disable dma mapping support for
 32-bit arch with 64-bit DMA
Content-Language: en-US
To:     Yunsheng Lin <linyunsheng@huawei.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
References: <20211013091920.1106-1-linyunsheng@huawei.com>
 <b9c0e7ef-a7a2-66ad-3a19-94cc545bd557@collabora.com>
 <1090744a-3de6-1dc2-5efe-b7caae45223a@huawei.com>
 <644e10ca-87b8-b553-db96-984c0b2c6da1@collabora.com>
 <93173400-1d37-09ed-57ef-931550b5a582@huawei.com>
 <YZJKNLEm6YTkygHM@apalos.home>
 <CAC_iWjKFLr932sMt9G2T+MFYUAQZNWPqp6YsnmSd3rMia7OpoA@mail.gmail.com>
 <d0223831-44ff-3e1a-1be9-27d751dc39f2@huawei.com>
In-Reply-To: <d0223831-44ff-3e1a-1be9-27d751dc39f2@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 15/11/2021 13.21, Yunsheng Lin wrote:
> On 2021/11/15 20:10, Ilias Apalodimas wrote:
>> On Mon, 15 Nov 2021 at 13:53, Ilias Apalodimas
>> <ilias.apalodimas@linaro.org> wrote:
>>>
>>> On Mon, Nov 15, 2021 at 11:34:59AM +0800, Yunsheng Lin wrote:
>>>> On 2021/11/12 17:21, Guillaume Tucker wrote:
>>>>> On 09/11/2021 12:02, Yunsheng Lin wrote:
>>>>>> On 2021/11/9 17:58, Guillaume Tucker wrote:
>>>>>>> Hi Yunsheng,
>>>>>>>
>>>>>>> Please see the bisection report below about a boot failure on
>>>>>>> rk3288-rock2-square which is pointing to this patch.  The issue
>>>>>>> appears to only happen with CONFIG_ARM_LPAE=y.
>>>>>>>
>>>>>>> Reports aren't automatically sent to the public while we're
>>>>>>> trialing new bisection features on kernelci.org but this one
>>>>>>> looks valid.
>>>>>>>
>>>>>>> Some more details can be found here:
>>>>>>>
>>>>>>>    https://linux.kernelci.org/test/case/id/6189968c3ec0a3c06e3358fe/
>>>>>>>
>>>>>>> Here's the same revision on the same platform booting fine with a
>>>>>>> plain multi_v7_defconfig build:
>>>>>>>
>>>>>>>    https://linux.kernelci.org/test/plan/id/61899d322c0e9fee7e3358ec/
>>>>>>>
>>>>>>> Please let us know if you need any help debugging this issue or
>>>>>>> if you have a fix to try.
>>>>>>
>>>>>> The patch below is removing the dma mapping support in page pool
>>>>>> for 32 bit systems with 64 bit dma address, so it seems there
>>>>>> is indeed a a drvier using the the page pool with PP_FLAG_DMA_MAP
>>>>>> flags set in a 32 bit systems with 64 bit dma address.
>>>>>>
>>>>>> It seems we might need to revert the below patch or implement the
>>>>>> DMA-mapping tracking support in the driver as mentioned in the below
>>>>>> commit log.
>>>>>>
>>>>>> which ethernet driver do you use in your system?
>>>>>
>>>>> Thanks for taking a look and sorry for the slow reply.  Here's a
>>>>> booting test job with LPAE disabled:
>>>>>
>>>>>      https://linux.kernelci.org/test/plan/id/618dbb81c60c4d94503358f1/
>>>>>      https://storage.kernelci.org/mainline/master/v5.15-12452-g5833291ab6de/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-nfs-rk3288-rock2-square.html#L812
>>>>>
>>>>> [    8.314523] rk_gmac-dwmac ff290000.ethernet eth0: Link is Up - 1Gbps/Full - flow control rx/tx
>>>>>
>>>>> So the driver is drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c
>>>>
>>>> Thanks for the report, this patch seems to cause problem for 32-bit
>>>> system with LPAE enabled.
>>>>
>>>> As LPAE seems like a common feature for 32 bits system, this patch
>>>> might need to be reverted.
>>>>
>>>> @Jesper, @Ilias, what do you think?
>>>
>>>
>>> So enabling LPAE also enables CONFIG_ARCH_DMA_ADDR_T_64BIT on that board?
>>> Doing a quick grep only selects that for XEN.  I am ok reverting that,  but
>>> I think we need to understand how the dma address ended up being 64bit.
>>
>> So looking a bit closer, indeed enabling LPAE always enables this.  So
>> we need to revert the patch.
>> Yunsheng will you send that?
> 
> Sure.

Why don't we change that driver[1] to not use page_pool_get_dma_addr() ?

  [1] drivers/net/ethernet/stmicro/stmmac/dwmac-rk.c

I took a closer look and it seems the driver have struct 
stmmac_rx_buffer in which is stored the dma_addr it gets from 
page_pool_get_dma_addr().

See func: stmmac_init_rx_buffers

  static int stmmac_init_rx_buffers(struct stmmac_priv *priv,
				struct dma_desc *p,
				int i, gfp_t flags, u32 queue)
  {

	if (!buf->page) {
		buf->page = page_pool_dev_alloc_pages(rx_q->page_pool);
		if (!buf->page)
			return -ENOMEM;
		buf->page_offset = stmmac_rx_offset(priv);
	}
	[...]

	buf->addr = page_pool_get_dma_addr(buf->page) + buf->page_offset;

	stmmac_set_desc_addr(priv, p, buf->addr);
	[...]
  }

I question if this driver really to use page_pool for storing the 
dma_addr as it just extract it and store it outside page_pool?

@Ilias it looks like you added part of the page_pool support in this 
driver, so I hope you can give a qualified guess on:
How much work will it be to let driver do the DMA-map itself?
(and not depend on the DMA-map feature provided by page_pool)

--Jesper


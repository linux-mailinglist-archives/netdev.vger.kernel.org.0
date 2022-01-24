Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF90497BFD
	for <lists+netdev@lfdr.de>; Mon, 24 Jan 2022 10:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233774AbiAXJaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jan 2022 04:30:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233779AbiAXJ35 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jan 2022 04:29:57 -0500
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D56C061744;
        Mon, 24 Jan 2022 01:29:56 -0800 (PST)
Received: by mail-lj1-x22b.google.com with SMTP id q22so2963199ljh.7;
        Mon, 24 Jan 2022 01:29:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=BylAZRLZiOyBqUYQ0byZHJ8IV+2vCMweAI+8MNCkOSw=;
        b=evmatsRBhp0/WOQ6RRsVjbljlAIKAaQd4tBlKQcs7K8Kxke9edWg/RHg5ok34FlOco
         rEwrqfvBKTIHQV/D2zKHNrBy0wLop6PlPos3DQxzpXzx6wt151QCpfusd71QDtCYNJ/V
         y0Ur9Yv9FImNk1dfkSsX0q/4ciNt6UDF/7QNzJQRGojSwrYZMcCgPCLG8LQ4r7HwU+U3
         C5OhqCavFsBgSBebt/ehSxlIVon8diqlRI4LnOouqKPJHrzAIOO1930dG8D/qmSZo/w2
         CttQ9KVuKr4+dssJ9Dcf1AtD1V1ja0CFuYQN0FPpKfoCjUihkczOumNbA9o6+TYH2LIm
         6kmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=BylAZRLZiOyBqUYQ0byZHJ8IV+2vCMweAI+8MNCkOSw=;
        b=XhYb5meEM7Ra4CpJN8r7M9K9D3mfM2xahmLZzu07h0ciuUwVSKMEnTd1P6Ae8dI19O
         SU1iO6nSHPM5BF0CaC8vH8WqUkLETt44ZgGVBtZk1p5YYW272BsLz3y9H8KbX2OdVgUk
         6KiZJjFu/pK342h4xkwBBYq5B978k6RNVgSFR4OF3eRYoeVqbiHABFM6FjG0IQ+mlVWW
         1VHf3IefDygQqme3a24GaUVYqmfKxFyntadgmBzlh7NAbXSRMOgaqJkdl7JNOUdmyCQV
         hMvRoscf3MGkROIaM8zIScTn9trkr/TUurC3QufR9ZSUMt0yCb+fkofayC90nmcFo/F5
         hpRQ==
X-Gm-Message-State: AOAM531ufAtx8ia5B5vg8YZHTIUoS4q/i5Em/MQdivKLOMPJq7SADZTS
        o1cBOs5f7matOMJY++kYZck=
X-Google-Smtp-Source: ABdhPJwDY/NKkYVl6jo01kZCQotV/0114XSeqjYmBym30jgQMmam5q2orQz4vuL7PMczXyDSQgP4dQ==
X-Received: by 2002:a05:651c:1198:: with SMTP id w24mr5392186ljo.42.1643016595297;
        Mon, 24 Jan 2022 01:29:55 -0800 (PST)
Received: from [192.168.8.103] (m91-129-103-86.cust.tele2.ee. [91.129.103.86])
        by smtp.gmail.com with ESMTPSA id n15sm454493lfi.101.2022.01.24.01.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Jan 2022 01:29:54 -0800 (PST)
Message-ID: <5cca8bdd-bed0-f26a-6c96-d18947d3a50b@gmail.com>
Date:   Mon, 24 Jan 2022 11:29:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] net: ena: Do not waste napi skb cache
Content-Language: en-US
From:   Julian Wiedmann <jwiedmann.dev@gmail.com>
To:     Hyeonggon Yoo <42.hyeyoo@gmail.com>, netdev@vger.kernel.org
Cc:     Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sameeh Jubran <sameehj@amazon.com>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-kernel@vger.kernel.org
References: <20220123115623.94843-1-42.hyeyoo@gmail.com>
 <f835cbb3-a028-1daf-c038-516dd47ce47c@gmail.com>
In-Reply-To: <f835cbb3-a028-1daf-c038-516dd47ce47c@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.01.22 10:57, Julian Wiedmann wrote:
> On 23.01.22 13:56, Hyeonggon Yoo wrote:
>> By profiling, discovered that ena device driver allocates skb by
>> build_skb() and frees by napi_skb_cache_put(). Because the driver
>> does not use napi skb cache in allocation path, napi skb cache is
>> periodically filled and flushed. This is waste of napi skb cache.
>>
>> As ena_alloc_skb() is called only in napi, Use napi_build_skb()
>> instead of build_skb() to when allocating skb.
>>
>> This patch was tested on aws a1.metal instance.
>>
>> Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
>> ---
>>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> index c72f0c7ff4aa..2c67fb1703c5 100644
>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>> @@ -1407,7 +1407,7 @@ static struct sk_buff *ena_alloc_skb(struct ena_ring *rx_ring, void *first_frag)
>>  		skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
>>  						rx_ring->rx_copybreak);
> 
> To keep things consistent, this should then also be napi_alloc_skb().
> 

And on closer look, this copybreak path also looks buggy. If rx_copybreak
gets reduced _while_ receiving a frame, the allocated skb can end up too
small to take all the data.

@ ena maintainers: can you please fix this?

>>  	else
>> -		skb = build_skb(first_frag, ENA_PAGE_SIZE);
>> +		skb = napi_build_skb(first_frag, ENA_PAGE_SIZE);
>>  
>>  	if (unlikely(!skb)) {
>>  		ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail, 1,
> 


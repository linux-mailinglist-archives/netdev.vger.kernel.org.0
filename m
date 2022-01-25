Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2A0649B54F
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 14:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237521AbiAYNsN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 08:48:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577601AbiAYNpV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 08:45:21 -0500
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84F4CC06175E;
        Tue, 25 Jan 2022 05:45:18 -0800 (PST)
Received: by mail-lj1-x233.google.com with SMTP id t7so8851641ljc.10;
        Tue, 25 Jan 2022 05:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dmTRZQPuRO8f++oWDROLMKejn3nl3Z1SGKdLjvl7gws=;
        b=BEWDGMMoMtROBzr8EOGbxyLugIK9SlaF4xB8o2GIIWKYTgUO5ifb3+PzatsOVDsiW4
         jts2Q8yi8DTDCnKzLfUtm21nKsYYZdvvN3H4STmJ1T4fnB+dwlbroyvI/9TByhB+nkQ6
         yl8p5oggELsaBPWLBh8v6lK8+UOaV4NzfJrtRKNBHQDkPEUc2HdMYfQfShLepvFL/dq+
         +5suF/LKHu0OGxHZmviEQrtLScqqL50GrVBK2uNVTZSF7uvxGuFKO6O+2q6eY7MPT63G
         Eo1b7WmAiqUVJS0moI3cK+yddSe4bzmcNNS35iQ+XLRqKcsbBfFlkFxM8ziurOhHER+e
         /JxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dmTRZQPuRO8f++oWDROLMKejn3nl3Z1SGKdLjvl7gws=;
        b=v3qdwxIz68a2h0CXHYuSzCwKW0ekfIEETxyoPOyzHlfpUpTDYc2wYcCnhGDe651qQ7
         s/ZbknnkvQskA5FNuJUsD2TqHUbj/uRRk5jJH8/k1kAvgXXTo2u8OFdN8RQXRy7z6QhG
         tLy4Wwra02VwsuABVj1/5Jqc99Tcp9gfEaFoVUB+Mwd24Ylmz9uRp9xGbHVp/KsG2jyZ
         uJK03SvTV+uNA/rRMMNOk/4Aw0jNeslJANVHSRJKqTTLc7UqGeyF7xGRyZ8OdYfVgqqP
         ORod7Ic5VgjC0V1TaJM3EWl6BnzSvS9Mo2JN98fMLUgPfZR3uBHKizaIwoSh4NSFOMl0
         j8YQ==
X-Gm-Message-State: AOAM531SRvLm9Ojncvo+DmU9jXMsV0946i466y6xjRpsGElx7Y4KgJns
        qMrxB9EI3XNT8CbtydjVvYFRwcm21fWt2w==
X-Google-Smtp-Source: ABdhPJx08G3qqyQaY61R2yVb7Y4EUNSulWJAmHB8Z5lo0lAdRk90RX5MGqRpEOLUGDZoH8qyGv9zVw==
X-Received: by 2002:a2e:9cd4:: with SMTP id g20mr10157727ljj.116.1643118316756;
        Tue, 25 Jan 2022 05:45:16 -0800 (PST)
Received: from [192.168.8.103] (m91-129-103-86.cust.tele2.ee. [91.129.103.86])
        by smtp.gmail.com with ESMTPSA id q12sm1224461ljh.16.2022.01.25.05.45.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 05:45:16 -0800 (PST)
Message-ID: <564ae11c-24fb-a9ad-f8f4-c9d80b7307b3@gmail.com>
Date:   Tue, 25 Jan 2022 15:45:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] net: ena: Do not waste napi skb cache
Content-Language: en-US
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     Hyeonggon Yoo <42.hyeyoo@gmail.com>, netdev@vger.kernel.org,
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
 <5cca8bdd-bed0-f26a-6c96-d18947d3a50b@gmail.com>
 <pj41zlmtjk7t9a.fsf@u570694869fb251.ant.amazon.com>
From:   Julian Wiedmann <jwiedmann.dev@gmail.com>
In-Reply-To: <pj41zlmtjk7t9a.fsf@u570694869fb251.ant.amazon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.01.22 22:50, Shay Agroskin wrote:
> 
> Julian Wiedmann <jwiedmann.dev@gmail.com> writes:
> 
>> On 24.01.22 10:57, Julian Wiedmann wrote:
>>> On 23.01.22 13:56, Hyeonggon Yoo wrote:
>>>> By profiling, discovered that ena device driver allocates skb by
>>>> build_skb() and frees by napi_skb_cache_put(). Because the driver
>>>> does not use napi skb cache in allocation path, napi skb cache is
>>>> periodically filled and flushed. This is waste of napi skb cache.
>>>>
>>>> As ena_alloc_skb() is called only in napi, Use napi_build_skb()
>>>> instead of build_skb() to when allocating skb.
>>>>
>>>> This patch was tested on aws a1.metal instance.
>>>>
>>>> Signed-off-by: Hyeonggon Yoo <42.hyeyoo@gmail.com>
>>>> ---
>>>>  drivers/net/ethernet/amazon/ena/ena_netdev.c | 2 +-
>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>>> index c72f0c7ff4aa..2c67fb1703c5 100644
>>>> --- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>>> +++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
>>>> @@ -1407,7 +1407,7 @@ static struct sk_buff *ena_alloc_skb(struct ena_ring *rx_ring, void *first_frag)
>>>>          skb = netdev_alloc_skb_ip_align(rx_ring->netdev,
>>>>                          rx_ring->rx_copybreak);
>>>
>>> To keep things consistent, this should then also be napi_alloc_skb().
>>>
>>
>> And on closer look, this copybreak path also looks buggy. If rx_copybreak
>> gets reduced _while_ receiving a frame, the allocated skb can end up too
>> small to take all the data.
>>
>> @ ena maintainers: can you please fix this?
>>
> 
> Updating the copybreak value is done through ena_ethtool.c (ena_set_tunable()) which updates `adapter->rx_copybreak`.
> The adapter->rx_copybreak value is "propagated back" to the ring local attributes (rx_ring->rx_copybreak) only after an interface toggle which stops the napi routine first.
> 

That's unfortunate. ena_get_tunable() returns the updated adapter->rx_copybreak, how would a user know that their update isn't actually live yet?

> Unless I'm missing something here I don't think the bug you're describing exists.
> 

ack, thanks for double-checking!

> I agree that the netdev_alloc_skb_ip_align() can become napi_alloc_skb(). Hyeonggon Yoo, can you please apply this change as well to this patch?
> 
> Thanks,
> Shay
> 
> 
>>>>      else
>>>> -        skb = build_skb(first_frag, ENA_PAGE_SIZE);
>>>> +        skb = napi_build_skb(first_frag, ENA_PAGE_SIZE);
>>>>  
>>>>      if (unlikely(!skb)) {
>>>>          ena_increase_stat(&rx_ring->rx_stats.skb_alloc_fail,  1,
>>>


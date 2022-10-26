Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 798EB60E9A5
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 21:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234030AbiJZTyB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 15:54:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234922AbiJZTx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 15:53:59 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D549F6C02
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 12:53:58 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id z30so11473068qkz.13
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 12:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ne2k5MZ2liCTxhgAOY1z0SI8nB1K7mmSquubAjYik+0=;
        b=dxliLHEkUjodRDSdkqJ7B2iRyA9ctE41uYxQ3TregubSxpd2WYJToujmVhCYa2NcTs
         Ig3IEHOesj45OSuj7SZVf0KYPy8L96ZfZdPotfF0w4VOMoN7nNAKPNjjbrBZVBXG3qBI
         G0Rf5gzKRFJQF9oXujKfJuWY1frU0fPq173rGb0fo7bNQUcgutR54O/erODRONV3xYqF
         bWIsFfaeB92A8avccRYOAJDe8MgDLWmCqa3L6gGI3xfqa4YdcvEXZ/W9J2H9aahNYPYs
         i/6oM7Em+raLqSsMXkq2dwttyxLq8e0vF3kx1ZvUROWjVO+H3WjYpEA7n16dvddiq6Wr
         d9JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ne2k5MZ2liCTxhgAOY1z0SI8nB1K7mmSquubAjYik+0=;
        b=tQBueF6GpPLW8+VI+BEGyilDM1alHWPTAY6/O3hWzevY3uYbK5mBo7R2tzEBpM66cs
         aCZFkk7INxxZC7mveUaYsv6dOpZPucA3Wv+OvMgdWByUAIHpfSKCXDzogX5c6cI+PQSY
         01YFES8+ljuLNQ12gy8SJAtgHvEvGdwbi3QqdsL9yYdZauVhQm+x5VeuhavXh46vMTca
         jtgnMaeNi/HJdDRpOKD7Qiui+BItWRipnTfb/FWHsX8owvztbIkU2iIgECX5NHr0oant
         VehXPPwC3bRGWWBOOHzkPICzzJac+BmPC0CsoBxFvaU6xedXy+tCUze0I5FOMXDLj5Hq
         KflA==
X-Gm-Message-State: ACrzQf3KhOwfMHrogtjyLpWuTW3Gh3hqTDqybQ7w4/iHhCgMxAAU/p+p
        NwylpSyb0Q/hndr8HXElnLcM4clOruK4ww==
X-Google-Smtp-Source: AMsMyM7/9t8Jk8XiMHwICF4gJ53SoExeofKwjlCpAS1BUpHVy8bZZpxyZIBlQjVJOQKqlDnfWhwyVw==
X-Received: by 2002:ae9:ef8b:0:b0:6ee:7b1f:fc9c with SMTP id d133-20020ae9ef8b000000b006ee7b1ffc9cmr31536651qkg.186.1666814037616;
        Wed, 26 Oct 2022 12:53:57 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g21-20020a05620a40d500b006ee8874f5fasm4630386qko.53.2022.10.26.12.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 12:53:56 -0700 (PDT)
Message-ID: <f0b2383e-fa08-c488-ec00-b0804d22c86d@gmail.com>
Date:   Wed, 26 Oct 2022 12:53:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH] net: broadcom: bcm4908_enet: report queued and
 transmitted bytes
Content-Language: en-US
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20221026142624.19314-1-zajec5@gmail.com>
 <9db364c8-f003-4622-8eee-fedb6e6b712e@gmail.com>
 <bc15d5e0-1e48-d353-fc90-680c8039bf4f@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <bc15d5e0-1e48-d353-fc90-680c8039bf4f@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/26/22 08:12, Rafał Miłecki wrote:
> On 26.10.2022 16:58, Florian Fainelli wrote:
>> On 10/26/2022 7:26 AM, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> This allows BQL to operate avoiding buffer bloat and reducing latency.
>>>
>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>> ---
>>>   drivers/net/ethernet/broadcom/bcm4908_enet.c | 7 +++++++
>>>   1 file changed, 7 insertions(+)
>>>
>>> diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c 
>>> b/drivers/net/ethernet/broadcom/bcm4908_enet.c
>>> index 93ccf549e2ed..e672a9ef4444 100644
>>> --- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
>>> +++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
>>> @@ -495,6 +495,7 @@ static int bcm4908_enet_stop(struct net_device 
>>> *netdev)
>>>       netif_carrier_off(netdev);
>>>       napi_disable(&rx_ring->napi);
>>>       napi_disable(&tx_ring->napi);
>>> +    netdev_reset_queue(netdev);
>>>       bcm4908_enet_dma_rx_ring_disable(enet, &enet->rx_ring);
>>>       bcm4908_enet_dma_tx_ring_disable(enet, &enet->tx_ring);
>>> @@ -564,6 +565,8 @@ static netdev_tx_t bcm4908_enet_start_xmit(struct 
>>> sk_buff *skb, struct net_devic
>>>       enet->netdev->stats.tx_bytes += skb->len;
>>>       enet->netdev->stats.tx_packets++;
>>> +    netdev_sent_queue(enet->netdev, skb->len);
>>
>> There is an opportunity for fixing an use after free here, after you 
>> call bcm4908_enet_dma_tx_ring_enable() the hardware can start 
>> transmission right away and also call the TX completion handler, so 
>> you could be de-referencing a freed skb reference at this point. Also, 
>> to ensure that DMA is actually functional, it is recommended to 
>> increase TX stats in the TX completion handler, since that indicates 
>> that you have a functional completion process.
> 
> I see the problem, thanks!
> 
> Actually hw may start transmission even earlier - right after filling
> buf_desc coherent struct.

Not familiar with that hardware, but in premise yes, I suppose once you 
write a proper address and length the DMA can notice and start 
transmitting. Also even though you are using non-coherent memory, there 
appears to be a missing dma_wmb() between the store to buf_desc->ctl and 
buf_desc->addr. There is no explicit dependency between those two stores 
and subsequent loads or stores, so the processor write buffer could 
re-order those in theory. Unlikely to happen because this used on a 
Cortex-A53 IIRC, but better safe than sorry.

> 
> 
>> So long story short, if you record the skb length *before* calling 
>> bcm4908_enet_dma_tx_ring_enable() and use that for reporting sent 
>> bytes, you should be good.
> 
> I may still end up calling netdev_completed_queue() for data for which
> I didn't call netdev_sent_queue() yet. Is that safe?
> 
> Maybe I just just call netdev_sent_queue() before updating the buf_desc?

You would want it to be as close a possible from when you hand the 
buffer to the hardware, but I see no locking between 
bcm4908_start_xmit() and bcm4908_enet_irq_handler() so you already have 
a race don't you?
-- 
Florian


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4406560E440
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 17:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233833AbiJZPMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 11:12:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233420AbiJZPMr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 11:12:47 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54EF11285DA
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:12:43 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id b1so29237524lfs.7
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3VXLi4WzpxWDtnsr+8mEx52GTgBCjJocpaE+tuOfs4=;
        b=pvzxgEjGmj4Nj6kVFz7tH09xN2O0HUx+vsYQtufFAiizjTShnn1imjZ7PVZgvZEZE1
         XRZTXPKB/pvkhl19N2mA4DYwo/PRc6IY/CqWqKK2a7ptENqjZ+WlPC2e/7o7rHE46j7R
         cqLOseokv7TKbxSh/YmcE384mMZssA5dg07UyYPMOr7kNAojqd/lknq66sxHPvJR9Y/f
         upZKqz54A4ZKl3mDEvCDKwScKNgN/s1xfzq1z+1sUcBlmtQYAj7XkWheK4a9p3DTXtWr
         aoraMDjRlzaki9RQuDYQhqLvenRfDJHFSlJgDpM70fbxw0oRJOt/MzK3dvSz31HR6Mir
         hiTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=T3VXLi4WzpxWDtnsr+8mEx52GTgBCjJocpaE+tuOfs4=;
        b=JzQjeSquVENtujnwwJIH1/327uyVWnPmKKkVSssDRPZMxQrGtTNf/M85zEEjZGPWdQ
         W/gb3FyXJx32ItUVH/Q6CVZ8kx4/CeNJq38eDqreeg76LGfMHCje/clGQN1TKxyyJSUT
         LM2Lv1xYBa0bUbTsNWISpcfyO3sLeg6zKh9zr/na8JL9aUES+4Vu7q3fvPHE+v9fXApH
         m28NLrYyllsOLMKVL2JBsohGs42/mU14E7WSX5PWjSp/otvdvhakOHgDaOFAOgkETf91
         N/IqSkD/kITLpeS2cu2p4daggy2YuOz5AGhGtND+ktU2ZshlgSOQ5Otv3e1ifZVVyvpp
         oCDQ==
X-Gm-Message-State: ACrzQf16mh4R5EksY77aSibedAHnpEIiZ1pcR+s52g8dA6Gobf1X051+
        rHKgpO46to7F7eXQo2DC9+0=
X-Google-Smtp-Source: AMsMyM5gBoXZFvWVRvm1IlmNzle/FhadCoR4aoMfIN23V/fbeD2Mg7fSGpOXTPXezzy2DKkicFwNOg==
X-Received: by 2002:ac2:4c8d:0:b0:4a0:559c:d40e with SMTP id d13-20020ac24c8d000000b004a0559cd40emr15740820lfl.508.1666797161428;
        Wed, 26 Oct 2022 08:12:41 -0700 (PDT)
Received: from [192.168.26.149] (ip-194-187-74-233.konfederacka.maverick.com.pl. [194.187.74.233])
        by smtp.googlemail.com with ESMTPSA id c26-20020a05651200da00b00492b0d23d24sm865743lfp.247.2022.10.26.08.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Oct 2022 08:12:40 -0700 (PDT)
Message-ID: <bc15d5e0-1e48-d353-fc90-680c8039bf4f@gmail.com>
Date:   Wed, 26 Oct 2022 17:12:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:96.0) Gecko/20100101
 Thunderbird/96.0
Subject: Re: [PATCH] net: broadcom: bcm4908_enet: report queued and
 transmitted bytes
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20221026142624.19314-1-zajec5@gmail.com>
 <9db364c8-f003-4622-8eee-fedb6e6b712e@gmail.com>
From:   =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
In-Reply-To: <9db364c8-f003-4622-8eee-fedb6e6b712e@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.10.2022 16:58, Florian Fainelli wrote:
> On 10/26/2022 7:26 AM, Rafał Miłecki wrote:
>> From: Rafał Miłecki <rafal@milecki.pl>
>>
>> This allows BQL to operate avoiding buffer bloat and reducing latency.
>>
>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>> ---
>>   drivers/net/ethernet/broadcom/bcm4908_enet.c | 7 +++++++
>>   1 file changed, 7 insertions(+)
>>
>> diff --git a/drivers/net/ethernet/broadcom/bcm4908_enet.c b/drivers/net/ethernet/broadcom/bcm4908_enet.c
>> index 93ccf549e2ed..e672a9ef4444 100644
>> --- a/drivers/net/ethernet/broadcom/bcm4908_enet.c
>> +++ b/drivers/net/ethernet/broadcom/bcm4908_enet.c
>> @@ -495,6 +495,7 @@ static int bcm4908_enet_stop(struct net_device *netdev)
>>       netif_carrier_off(netdev);
>>       napi_disable(&rx_ring->napi);
>>       napi_disable(&tx_ring->napi);
>> +    netdev_reset_queue(netdev);
>>       bcm4908_enet_dma_rx_ring_disable(enet, &enet->rx_ring);
>>       bcm4908_enet_dma_tx_ring_disable(enet, &enet->tx_ring);
>> @@ -564,6 +565,8 @@ static netdev_tx_t bcm4908_enet_start_xmit(struct sk_buff *skb, struct net_devic
>>       enet->netdev->stats.tx_bytes += skb->len;
>>       enet->netdev->stats.tx_packets++;
>> +    netdev_sent_queue(enet->netdev, skb->len);
> 
> There is an opportunity for fixing an use after free here, after you call bcm4908_enet_dma_tx_ring_enable() the hardware can start transmission right away and also call the TX completion handler, so you could be de-referencing a freed skb reference at this point. Also, to ensure that DMA is actually functional, it is recommended to increase TX stats in the TX completion handler, since that indicates that you have a functional completion process.

I see the problem, thanks!

Actually hw may start transmission even earlier - right after filling
buf_desc coherent struct.


> So long story short, if you record the skb length *before* calling bcm4908_enet_dma_tx_ring_enable() and use that for reporting sent bytes, you should be good.

I may still end up calling netdev_completed_queue() for data for which
I didn't call netdev_sent_queue() yet. Is that safe?

Maybe I just just call netdev_sent_queue() before updating the buf_desc?

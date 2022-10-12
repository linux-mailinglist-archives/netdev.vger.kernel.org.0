Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60AD15FCB9F
	for <lists+netdev@lfdr.de>; Wed, 12 Oct 2022 21:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiJLTdc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 15:33:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJLTda (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 15:33:30 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCBD5FFFA1
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 12:33:27 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id c3-20020a1c3503000000b003bd21e3dd7aso1793315wma.1
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 12:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rb3P+SSN1sXyqJ2czRmiuQmEZ6Yw67MQkLT5mp7Ld9E=;
        b=n7WsXrv60EsxQXCp2IbIUt6y01Ya3R3O3+37j5cvFwQOSW1q1A6W5CeTahQfxDQU+N
         yJgSKowR1R2Aa16hctpL0weH9tXz1f0PqLz7pi4mnL9YDQjYrdIJ01fvCuTVfnzAUSDr
         9ZeZQT/t8k/RpiSZWVAEWbRWXbKrvKYCzeQuuRzWGmpvDumuHcFbhQXPDZq64ryM8TOk
         O8NKS4cuMvDvHnKqVq1XpaUvIMnaOUx5n5BN/d+KDxqOT1hd+An+v9duFKJOdgUnFz+Q
         zWCHvZ6vm/030JYg8h2AJGvXWamtJSvsk5n7B7kTDCsD8u99r0rsdJPs3PqM2OqoC7oy
         Cu2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rb3P+SSN1sXyqJ2czRmiuQmEZ6Yw67MQkLT5mp7Ld9E=;
        b=Z6udZPc0MIcGifqLvP7iN20o0vjfAZBufSJbjprcahC3QLC7hK8I83r9GG628dqPOa
         xPLieDmXNlQ7diJoV3fGb5i3HT3UhFrCC1VnItYZNReVxuQEDzDXPgVap0FDvmroQnRE
         06/PA8FVWZF1bqgKvW5BZLm6JcxgVviwhDoKCxknG3OX4xAKMFX45BcMbhC35Tr0up7S
         dhJecMXI0HbJLxhshNPvNEleb+1gph/lBccles5qjcfoChUpz7eSHJhTaacIcjNIgZDv
         XUcZjYjvi35ymLIgEjqaMnBcochZjPDdKsbdSD/C2TiMrAZ9k3FnQUc6OkSM8jzzNncU
         W68g==
X-Gm-Message-State: ACrzQf3RM6gb0JmfV9YrAzDbc2oaFDWfXp8hw+xS75hZwyBEchRxHU2T
        /uXGrTH7tpALtqunNVqExv0=
X-Google-Smtp-Source: AMsMyM69mEeJgiX89w5iD5lVUzxcawoyo/UxSJzlT1ITMbsUzI+CFNLvlVi22ZBcok/RRQobyuRdMg==
X-Received: by 2002:a05:600c:490f:b0:3c6:2c21:97f6 with SMTP id f15-20020a05600c490f00b003c62c2197f6mr3790706wmp.177.1665603206101;
        Wed, 12 Oct 2022 12:33:26 -0700 (PDT)
Received: from ?IPV6:2a01:c22:6f0c:8900:9422:b6d3:cb18:f1c6? (dynamic-2a01-0c22-6f0c-8900-9422-b6d3-cb18-f1c6.c22.pool.telefonica.de. [2a01:c22:6f0c:8900:9422:b6d3:cb18:f1c6])
        by smtp.googlemail.com with ESMTPSA id g6-20020a05600c4ec600b003b477532e66sm8087747wmq.2.2022.10.12.12.33.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 12:33:25 -0700 (PDT)
Message-ID: <3ffdaa0d-4a3d-dd2c-506c-d10b5297f430@gmail.com>
Date:   Wed, 12 Oct 2022 21:33:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
Content-Language: en-US
To:     Hau <hau@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "grundler@chromium.org" <grundler@chromium.org>
References: <20221004081037.34064-1-hau@realtek.com>
 <6d607965-53ab-37c7-3920-ae2ad4be09e5@gmail.com>
 <6781f98dd232471791be8b0168f0153a@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <6781f98dd232471791be8b0168f0153a@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12.10.2022 09:59, Hau wrote:
>>
>> On 04.10.2022 10:10, Chunhao Lin wrote:
>>> When close device, rx will be enabled if wol is enabeld. When open
>>> device it will cause rx to dma to wrong address after pci_set_master().
>>>
>>> In this patch, driver will disable tx/rx when close device. If wol is
>>> eanbled only enable rx filter and disable rxdv_gate to let hardware
>>> can receive packet to fifo but not to dma it.
>>>
>>> Fixes: 120068481405 ("r8169: fix failing WoL")
>>> Signed-off-by: Chunhao Lin <hau@realtek.com>
>>> ---
>>>  drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++-------
>>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
>>> b/drivers/net/ethernet/realtek/r8169_main.c
>>> index 1b7fdb4f056b..c09cfbe1d3f0 100644
>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>> @@ -2239,6 +2239,9 @@ static void rtl_wol_enable_rx(struct
>> rtl8169_private *tp)
>>>  	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
>>>  		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
>>>  			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
>>> +
>>> +	if (tp->mac_version >= RTL_GIGA_MAC_VER_40)
>>> +		RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
>>
>> Is this correct anyway? Supposedly you want to set this bit to disable DMA.
>>
> If wol is enabled, driver need to disable hardware rxdv_gate for receiving packets.
> 
OK, I see. But why disable it here? I see no scenario where rxdv_gate would be enabled
when we get here.

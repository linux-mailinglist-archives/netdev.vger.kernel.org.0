Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 654486017D2
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 21:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230417AbiJQTi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 15:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiJQTi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 15:38:57 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E577199A
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:38:56 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id ot12so27359503ejb.1
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 12:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wt3z9xfbycx6bM5DJ8XUUHPonXfnBJQqhFm0hiiAICo=;
        b=e/8dwuT/Om9Y+tvr12tlnT5unocgh0rtGyYVUyXpbPI33br8C2Axk2Q6sdBYZQHq3A
         fFKdz0ga/6C2XTOvG1RKzpmQvVlnSXw0BYaRyHGu/NV7v/WkC4BaPj+tvGvHmNXZ4x5l
         wEqLxRTWXgRGMgO8OD22DktUezs/fKN0ri31s68e3WNtUHWPh4z6uTZ8Wd8KPeHwGvTA
         9GHuuyQjEwJJZh7JRrxaRowTC0tuplRvHhdaezAJbs+1uG8vCm2hzOL1dKwmi31i3O1A
         7tbjQJNHhkH5oSPuzWlWfimQd0QCPPa6x8p/WVoX8CW7p4h27ZPwtxk01tB5pEHE009N
         C53Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wt3z9xfbycx6bM5DJ8XUUHPonXfnBJQqhFm0hiiAICo=;
        b=T9dlzmUdh8kSks9Rc3cg6DGID0uOrO8j2alrus7WxrgSFBRoJxlD7TK8ctmqQCV0eB
         ROsap1AHcfNDDMVxLdSPCQd6iYk3/7iDWNw3iq9MSD6OwPc3fvG4W9Zc70VAf/cUlfro
         qnkiboACoKnFjgnb2ESIarGI1igk6hZBYzmoeLwA0KKNhjNtcV1xHz4OjS2s77vysN1w
         nSHixL0UA/A7zprFbYLxxmQFc0qXU59eMhnkli2hi3JBaSRZCD6b7a1IIt1jycMbILje
         iITYrMvP1qVOa9A8sGJ1AsI2xW87pLQ2l8UCmnAm/+JdbnsmcqH1ecAv+6TjaK17fMgs
         60AQ==
X-Gm-Message-State: ACrzQf1QLQqFedGQvZK+fAn9WTPknumV8XsMkwqxXbMlo9zu2lRmrKuf
        B9S0CZeHU69Y72ITlCFTpZL8HlqpRiA=
X-Google-Smtp-Source: AMsMyM64J18exnMlGiR1Rao5nSe6FRmMbgE8V0PZ94BZkagUIn1jSFwSniyQ75gWOWdHJ0lWw2Vrbw==
X-Received: by 2002:a17:907:3f0b:b0:781:e783:2773 with SMTP id hq11-20020a1709073f0b00b00781e7832773mr9744391ejc.610.1666035534607;
        Mon, 17 Oct 2022 12:38:54 -0700 (PDT)
Received: from ?IPV6:2a01:c22:6e67:9200:2d2f:d692:454e:74bc? (dynamic-2a01-0c22-6e67-9200-2d2f-d692-454e-74bc.c22.pool.telefonica.de. [2a01:c22:6e67:9200:2d2f:d692:454e:74bc])
        by smtp.googlemail.com with ESMTPSA id q3-20020aa7da83000000b00458a243df3esm7896265eds.65.2022.10.17.12.38.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 12:38:54 -0700 (PDT)
Message-ID: <465b96bf-0eff-8e5c-433d-3571114058e6@gmail.com>
Date:   Mon, 17 Oct 2022 21:38:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Hau <hau@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "grundler@chromium.org" <grundler@chromium.org>
References: <20221004081037.34064-1-hau@realtek.com>
 <6d607965-53ab-37c7-3920-ae2ad4be09e5@gmail.com>
 <6781f98dd232471791be8b0168f0153a@realtek.com>
 <3ffdaa0d-4a3d-dd2c-506c-d10b5297f430@gmail.com>
 <5eda67bb8f16473fb575b6a470d3592c@realtek.com>
 <48ff36cd-370b-f067-b643-a3d59df036dd@gmail.com>
 <c214fed3af19464c823a5294f531eaea@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
In-Reply-To: <c214fed3af19464c823a5294f531eaea@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 17.10.2022 19:23, Hau wrote:
>> On 13.10.2022 08:04, Hau wrote:
>>>> On 12.10.2022 09:59, Hau wrote:
>>>>>>
>>>>>> On 04.10.2022 10:10, Chunhao Lin wrote:
>>>>>>> When close device, rx will be enabled if wol is enabeld. When open
>>>>>>> device it will cause rx to dma to wrong address after pci_set_master().
>>>>>>>
>>>>>>> In this patch, driver will disable tx/rx when close device. If wol
>>>>>>> is eanbled only enable rx filter and disable rxdv_gate to let
>>>>>>> hardware can receive packet to fifo but not to dma it.
>>>>>>>
>>>>>>> Fixes: 120068481405 ("r8169: fix failing WoL")
>>>>>>> Signed-off-by: Chunhao Lin <hau@realtek.com>
>>>>>>> ---
>>>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++-------
>>>>>>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>>>>>>
>>>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>> b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>> index 1b7fdb4f056b..c09cfbe1d3f0 100644
>>>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>>>> @@ -2239,6 +2239,9 @@ static void rtl_wol_enable_rx(struct
>>>>>> rtl8169_private *tp)
>>>>>>>  	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
>>>>>>>  		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
>>>>>>>  			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
>>>>>>> +
>>>>>>> +	if (tp->mac_version >= RTL_GIGA_MAC_VER_40)
>>>>>>> +		RTL_W32(tp, MISC, RTL_R32(tp, MISC) &
>> ~RXDV_GATED_EN);
>>>>>>
>>>>>> Is this correct anyway? Supposedly you want to set this bit to disable
>> DMA.
>>>>>>
>>>>> If wol is enabled, driver need to disable hardware rxdv_gate for
>>>>> receiving
>>>> packets.
>>>>>
>>>> OK, I see. But why disable it here? I see no scenario where rxdv_gate
>>>> would be enabled when we get here.
>>>>
>>> rxdv_gate will be enabled in rtl8169_cleanup(). When suspend or close
>>> and wol is enabled driver will call rtl8169_down() -> rtl8169_cleanup()->
>> rtl_prepare_power_down()-> rtl_wol_enable_rx().
>>> So disabled rxdv_gate in rtl_wol_enable_rx() for receiving packets.
>>>
>> rtl8169_cleanup() skips the call to rtl_enable_rxdvgate() when being called
>> from
>> rtl8169_down() and wol is enabled. This means rxdv gate is still disabled.
>>
> Yes, it will keep rxdv_gate disable. But it will also keep tx/rx on.  If OS have an  unexpected
> reboot hardware  may dma to invalid memory address. If possible I prefer to keep
> tx/rx off when exit driver control.  
> 

When you say "keep tx/rx off", do you refer to the rxconfig bits in register
RxConfig, or to CmdTxEnb and CmdRxEnb in ChipCmd?

If we talk about the first option, then my guess would be:
According to rtl_wol_enable_rx() the rx config bits are required for WoL to work
on certain chip versions. With the introduction of rxdvgate this changed and
setting these bits isn't needed any longer.
I tested on RTL8168h and WoL worked w/o the Accept bits set in RxConfig.
Please confirm or correct my understanding.

static void rtl_wol_enable_rx(struct rtl8169_private *tp)
{
	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
}


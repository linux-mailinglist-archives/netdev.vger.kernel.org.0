Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84C785FF91D
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 10:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229493AbiJOISW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 04:18:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJOIST (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 04:18:19 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 708F94D4E5
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 01:18:18 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id r13so10774478wrj.11
        for <netdev@vger.kernel.org>; Sat, 15 Oct 2022 01:18:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GoDF0oQn9GFw/y7TXmZjvDJX59nMzt0lbMy1RNebfsI=;
        b=JmbsZ5z4Oj0flVP1eCE4/IXOn2yJOFFeXK5U/7nkPg3woXCldXcIVEKlAZAgG6cqjk
         FO3lhTfmiMd8pnbSfyAeyc+/BAX9BL5cisEgTEy/F5DmVA/Fs9ZJswiOfvdBQRwQLA85
         EoHY+cVjlNk2Vp7Qhj0ojasF8s6wGQKdslsJ8ZlKk9avmMQO/sSrtv7MbRIbJYWUQa5J
         AUf3OdNB4LBmfwpJ3rKYrLWspIeehNqoqR63TJMe5ie6fsKRBuRLliGHnSSjXqgJNV9y
         StkZHt3WL9W6fZegngzrcE2IjLeJ2VmLnIsqACzkIo0gLD370PGu7GJ2G228h1caU+2j
         zUnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GoDF0oQn9GFw/y7TXmZjvDJX59nMzt0lbMy1RNebfsI=;
        b=NqOr0f12YP//JlCNiXZ+HmEG8tgG8JXYdShxR94Z5lIRG5cIetYRviyLf7tU1ie4wD
         qjYtaCRptrxt3gHMCTwbM1AmKTfyYaOM5UO2l0DXLgTGmxC6W6d5bGCFIqgSmrECBeDr
         ecoy4CZjHmOw12pof920QiyOThLBA5HOy0/AcC/hhRqp1XXCcflUwyxJ0ZbkSln8tIrB
         eiIh1f2qgYc4Lv00RI4luhptrCCu+Bmt8kTnJ/5L+QOpOVgz+jWYYaxB1Ae6muu6qSD5
         cV4OePMvGLIDmqdJOpizpK8FJoN7DOFwosO+Qo+gm6Mt2trStpKjY290CphLHzOOcRoV
         KvZw==
X-Gm-Message-State: ACrzQf0aYLtD6bCrQ63nR1J9i6IovOblcpO1HIaWD+xXx0Id1UcJ5DDs
        R5Gpx7lzkgdSoBYi4BlMXOJAymsyAPY=
X-Google-Smtp-Source: AMsMyM7WjupTK63gjKBUSSqLbs00yu09OAJGMVUN6ea1BHCa314yROGHT/H+EZmh2ZLwgWa+TXYczA==
X-Received: by 2002:a5d:50cf:0:b0:22d:f2f:dee9 with SMTP id f15-20020a5d50cf000000b0022d0f2fdee9mr819846wrt.529.1665821896792;
        Sat, 15 Oct 2022 01:18:16 -0700 (PDT)
Received: from ?IPV6:2a01:c22:77f5:9e00:a459:aa87:db99:50f? (dynamic-2a01-0c22-77f5-9e00-a459-aa87-db99-050f.c22.pool.telefonica.de. [2a01:c22:77f5:9e00:a459:aa87:db99:50f])
        by smtp.googlemail.com with ESMTPSA id l32-20020a05600c1d2000b003b47b913901sm17565092wms.1.2022.10.15.01.18.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Oct 2022 01:18:15 -0700 (PDT)
Message-ID: <48ff36cd-370b-f067-b643-a3d59df036dd@gmail.com>
Date:   Sat, 15 Oct 2022 10:18:11 +0200
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
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net] r8169: fix rtl8125b dmar pte write access not set
 error
In-Reply-To: <5eda67bb8f16473fb575b6a470d3592c@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.10.2022 08:04, Hau wrote:
>> On 12.10.2022 09:59, Hau wrote:
>>>>
>>>> On 04.10.2022 10:10, Chunhao Lin wrote:
>>>>> When close device, rx will be enabled if wol is enabeld. When open
>>>>> device it will cause rx to dma to wrong address after pci_set_master().
>>>>>
>>>>> In this patch, driver will disable tx/rx when close device. If wol
>>>>> is eanbled only enable rx filter and disable rxdv_gate to let
>>>>> hardware can receive packet to fifo but not to dma it.
>>>>>
>>>>> Fixes: 120068481405 ("r8169: fix failing WoL")
>>>>> Signed-off-by: Chunhao Lin <hau@realtek.com>
>>>>> ---
>>>>>  drivers/net/ethernet/realtek/r8169_main.c | 14 +++++++-------
>>>>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/ethernet/realtek/r8169_main.c
>>>>> b/drivers/net/ethernet/realtek/r8169_main.c
>>>>> index 1b7fdb4f056b..c09cfbe1d3f0 100644
>>>>> --- a/drivers/net/ethernet/realtek/r8169_main.c
>>>>> +++ b/drivers/net/ethernet/realtek/r8169_main.c
>>>>> @@ -2239,6 +2239,9 @@ static void rtl_wol_enable_rx(struct
>>>> rtl8169_private *tp)
>>>>>  	if (tp->mac_version >= RTL_GIGA_MAC_VER_25)
>>>>>  		RTL_W32(tp, RxConfig, RTL_R32(tp, RxConfig) |
>>>>>  			AcceptBroadcast | AcceptMulticast | AcceptMyPhys);
>>>>> +
>>>>> +	if (tp->mac_version >= RTL_GIGA_MAC_VER_40)
>>>>> +		RTL_W32(tp, MISC, RTL_R32(tp, MISC) & ~RXDV_GATED_EN);
>>>>
>>>> Is this correct anyway? Supposedly you want to set this bit to disable DMA.
>>>>
>>> If wol is enabled, driver need to disable hardware rxdv_gate for receiving
>> packets.
>>>
>> OK, I see. But why disable it here? I see no scenario where rxdv_gate would
>> be enabled when we get here.
>>
> rxdv_gate will be enabled in rtl8169_cleanup(). When suspend or close and wol is enabled
> driver will call rtl8169_down() -> rtl8169_cleanup()-> rtl_prepare_power_down()-> rtl_wol_enable_rx().
> So disabled rxdv_gate in rtl_wol_enable_rx() for receiving packets.
> 
rtl8169_cleanup() skips the call to rtl_enable_rxdvgate() when being called from
rtl8169_down() and wol is enabled. This means rxdv gate is still disabled.




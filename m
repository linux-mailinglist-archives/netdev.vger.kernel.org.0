Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24F4064635B
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 22:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229646AbiLGVlP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 16:41:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbiLGVlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 16:41:14 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C6BD7060D
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 13:41:13 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id k22-20020a05600c1c9600b003d1ee3a6289so2122493wms.2
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 13:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WoXH/vGjceJ1EfMuKk3V81gmiJUDsJnX3+ns3LziZ+k=;
        b=lHdaQqJjgWG6JhAEMOykTsD3ZVQJl4ApMkVKATmPDs89yPz16pcLi7+/L5DyPyr/Ci
         p3d6LeQVe8HPhJtt9sNNiyPMFk506HIfJk2+1FwpPaCXjgd0+GSNVMs6+FVmRrJPfzwS
         ff5IarYnCLkQoK95rAV0rIGkoaWQvTqnIX9Ty4ybObu8jr70o6ikNIAm4lzYHHnve6AV
         zxvx1ms/REs+mtBx/S/vqr2Cvc5I6rc1VTKD64aI5KcKbURQykjwlLSELH3GYtnilhlU
         vi/RMc01rK1pQ+eEle9D5fynQu4td09yvWZQPUDvO7JfnL+fH+bWSC0FL0xlxl5JMtEp
         EBKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WoXH/vGjceJ1EfMuKk3V81gmiJUDsJnX3+ns3LziZ+k=;
        b=Es49e0RnZO3r3DVkSIXA4lDiiNsvMOyZOFK9b8atLvBA7lMSGnC5c/IBYNpd7bM4Vo
         7M9pVqEi8I8TtsjCnh3HmgeUPTvRhn9vedg4dNzDU1ZEEznY0L4XHnwtsC1jw8OlXYQD
         EljJG46YGXx7yWCC6eDGAcaBziVX96UcqQ+/rkWmKyYFS6CXQG42bI8DgD8RoayuWnFh
         JuOlt0L0V7F0ojv0DFKg5DxGm4ZbNl4YonlsFdREQzZwIW+1Pe73/dgBKPpl3l/NKVVH
         r6drggjkWeNQ88uK4R54UcGya+iO99JaEr4BVHzB4RS61qF8GPKp2TjypTbzVbu0r7Ap
         BzfA==
X-Gm-Message-State: ANoB5pnHsvkMcqNx/i7/f1gCLEqivaVKFClpqwLco9s4WOzdVjxqoT4q
        tDuSomC0aoOngQ1AG5yFsq18cKLdH6g=
X-Google-Smtp-Source: AA0mqf5OCLUgdMA9qvhvN/BZQ9CnURXHO/VDxiJLZ4NOe/3m+rBn6ZlY1MIlJJMp0Tz776FHkTvFBQ==
X-Received: by 2002:a05:600c:43c5:b0:3d1:eea7:e13d with SMTP id f5-20020a05600c43c500b003d1eea7e13dmr5722097wmn.74.1670449271449;
        Wed, 07 Dec 2022 13:41:11 -0800 (PST)
Received: from ?IPV6:2a01:c23:c5da:ef00:8192:4585:4b8a:9109? (dynamic-2a01-0c23-c5da-ef00-8192-4585-4b8a-9109.c23.pool.telefonica.de. [2a01:c23:c5da:ef00:8192:4585:4b8a:9109])
        by smtp.googlemail.com with ESMTPSA id u11-20020a5d6acb000000b00241c4bd6c09sm20216807wrw.33.2022.12.07.13.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Dec 2022 13:41:10 -0800 (PST)
Message-ID: <4fa4980c-906b-8fda-b29f-b2125c31304c@gmail.com>
Date:   Wed, 7 Dec 2022 22:41:08 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
To:     Hau <hau@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
References: <20221201143911.4449-1-hau@realtek.com>
 <64a35b94-f062-ad12-728e-8409e7baeeca@gmail.com>
 <df3bf48baf6946f4a75c5c4287e6efa7@realtek.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
In-Reply-To: <df3bf48baf6946f4a75c5c4287e6efa7@realtek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.12.2022 18:43, Hau wrote:
>>
>> On 01.12.2022 15:39, Chunhao Lin wrote:
>>> rtl8168h(revid 0x2a) + rtl8211fs is for utp to fiber application.
>>> rtl8168h is connected to rtl8211fs utp interface. And fiber is
>>> connected to rtl8211fs sfp interface. rtl8168h use its eeprm or gpo
>>> pins to control rtl8211fs mdio bus.
>>>
>>
>> I found a datasheet for RTL8211FS and it doesn't mention SFP support.
>> For the fiber use case it mentions RGMII for MAC/PHY connection and
>> SerDes for connecting the PHY to the fiber module. Is this the mode you'd
>> like to support?
>> "utp to fiber" sounds like the media converter application, and I think that's
>> not what we want here. So it's misleading.
> This application is not listed in datasheet. But it is similar to utp to fiber application. Fiber connects to rtl8211fs through SerDes interface.
> rtl8168h connects to rtl8211fs through mdi interface. rtl8168h also connects to rtl8211fs mdc/mdio interface through its eeprom or gpo pins
>  for controlling rtl8211fs. The link between rtl8211fs and fiber, and the link between rtl8211fs and rtl8168h should be the same.
>  Driver just needs to set the link capability of rtl8168h to auto negation and rtl8211fs will propagate the link status between fiber and itself to rtl8168h. 
> But rtl8168h will not know the link capability of fiber. So when system suspend, if wol is enabled, driver cannot speed down rtl8168h's phy.
> Or rtl8168h cannot be waken up.
> 
> I will submit a new patch according your advice. But we are considering not to use driver(r8169) to setup rtl8211fs. So next patch maybe simpler.
> 

Sounds strange that RTL8168H connects to RTL8211FS via MDI. Typically you would use RGMII here.
Is it because RTL8168H has no pins for RGMII to external PHY's?

Then my understanding would be that you do it like this:
RTL8168H MAC -> <internal RGMII> -> RTL8168H PHY -> <MDI> -> RTL8211FS -> <SerDes> -> Fiber module
   |                                                             |
    -------------------bit-banged MDIO---------------------------

Sou you would need to control both PHY's, right? Because setup wouldn't work if e.g. RTL8168H-internal PHY is powered down.
Is the RTL8211FS interrupt pin connected to RTL8168H? Or has polling to be used to get the status from RTL8211FS?


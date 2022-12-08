Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC80864780F
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 22:35:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229543AbiLHVfv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 16:35:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiLHVft (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 16:35:49 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616A0AD310
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 13:35:48 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id n21so7069982ejb.9
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 13:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=piLUEObfwDZTNoM9jlAlVB7h1QGtnSpxWmpBB+6G9MI=;
        b=QR/z3um6RV4VmJYqB4z+EtlxmwhYzLK2VK7rsXF336RTFqSl+gy4mEobXiCYxTf6se
         zY64yJL50L5vgm/iIkhR6BTsk2PC41mRrwnzsEfs24O4hTtUN6D1+uGR+Kcxo58AkFmK
         Jkqc5PS1YdJ4etgmM81mLfArQcLv9Z0jE/V3ZL9pNLNoOL+pyoQPyNmeJGsMWWo0wvXR
         3l24LRGZKQbvJSCYtYeAP0LFZZOIVzOt/KMr8LQGv0XzTXg6UnpvwOEnbP8kIj+6w05u
         iLEhhU3LQC0TD9mT+USWU8e5HKXINw3PgsS+1E+kKG/ACjoB+hKtCfaueg9CurRbOCAj
         rbzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:references:cc:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=piLUEObfwDZTNoM9jlAlVB7h1QGtnSpxWmpBB+6G9MI=;
        b=Xx35Gzk0b3uH/t9ElIlQLh637oDdPlcWSsCnYT7fcgk2OKzuNGD6dGnlcWqcTp/KLr
         jJAQotc45qUOpjOdVNUwN/o8v2rPaGjMQr5qZrZltc7yIY+WlVFmzu7tZ8ih2mo0LTLQ
         Kgx0ltFoWZM2zS6AM6SQ8U/81sY1uj6jYzBieJ9hrREfZHfpG27V4Az2g/UrXtNjhmRo
         TOwk+fu0cDQbsu4rfnzklZ5mULg+8cJF5cbYsTe72qjosE0/Ogw0gDz6Cl7ReD5OmYH5
         wLKjah5kzOPQbyZXEDj2HahLaf9j9GCyh2EoEMmcdDcypZoMSUuOrvSlimHsDl8seTE9
         vO9A==
X-Gm-Message-State: ANoB5pkBzgrm7AviT8ps/aBSBbYA7GH8mVSqJo/Zm4en9L2HPCX1fhCq
        S/AzSTswS7H1A9Ak/Hli1gM=
X-Google-Smtp-Source: AA0mqf4/EcT6yXETi2zKK1xGHmTX1aPdBDYCG6bm1Cawh4UC/9cYhEveXAq5fdoWkxEBZTdOgvzGxw==
X-Received: by 2002:a17:906:124d:b0:7ad:b822:d2e4 with SMTP id u13-20020a170906124d00b007adb822d2e4mr79581268eja.35.1670535346610;
        Thu, 08 Dec 2022 13:35:46 -0800 (PST)
Received: from ?IPV6:2a01:c22:728e:6100:5167:1b9:69ca:b10e? (dynamic-2a01-0c22-728e-6100-5167-01b9-69ca-b10e.c22.pool.telefonica.de. [2a01:c22:728e:6100:5167:1b9:69ca:b10e])
        by smtp.googlemail.com with ESMTPSA id h26-20020a1709063b5a00b0078db5bddd9csm9546156ejf.22.2022.12.08.13.35.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 13:35:46 -0800 (PST)
Message-ID: <7f460a37-d6f5-603f-2a6c-c65bae56f76b@gmail.com>
Date:   Thu, 8 Dec 2022 22:35:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Content-Language: en-US
To:     Hau <hau@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>, Andrew Lunn <andrew@lunn.ch>
References: <20221201143911.4449-1-hau@realtek.com>
 <64a35b94-f062-ad12-728e-8409e7baeeca@gmail.com>
 <df3bf48baf6946f4a75c5c4287e6efa7@realtek.com>
 <4fa4980c-906b-8fda-b29f-b2125c31304c@gmail.com>
 <cb897c69a9d74b77b34fc94b30dc6bdd@realtek.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v5] r8169: add support for rtl8168h(revid 0x2a) +
 rtl8211fs fiber application
In-Reply-To: <cb897c69a9d74b77b34fc94b30dc6bdd@realtek.com>
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

On 08.12.2022 16:59, Hau wrote:
>> On 07.12.2022 18:43, Hau wrote:
>>>>
>>>> On 01.12.2022 15:39, Chunhao Lin wrote:
>>>>> rtl8168h(revid 0x2a) + rtl8211fs is for utp to fiber application.
>>>>> rtl8168h is connected to rtl8211fs utp interface. And fiber is
>>>>> connected to rtl8211fs sfp interface. rtl8168h use its eeprm or gpo
>>>>> pins to control rtl8211fs mdio bus.
>>>>>
>>>>
>>>> I found a datasheet for RTL8211FS and it doesn't mention SFP support.
>>>> For the fiber use case it mentions RGMII for MAC/PHY connection and
>>>> SerDes for connecting the PHY to the fiber module. Is this the mode
>>>> you'd like to support?
>>>> "utp to fiber" sounds like the media converter application, and I
>>>> think that's not what we want here. So it's misleading.
>>> This application is not listed in datasheet. But it is similar to utp to fiber
>> application. Fiber connects to rtl8211fs through SerDes interface.
>>> rtl8168h connects to rtl8211fs through mdi interface. rtl8168h also
>>> connects to rtl8211fs mdc/mdio interface through its eeprom or gpo pins
>> for controlling rtl8211fs. The link between rtl8211fs and fiber, and the link
>> between rtl8211fs and rtl8168h should be the same.
>>>  Driver just needs to set the link capability of rtl8168h to auto negation and
>> rtl8211fs will propagate the link status between fiber and itself to rtl8168h.
>>> But rtl8168h will not know the link capability of fiber. So when system
>> suspend, if wol is enabled, driver cannot speed down rtl8168h's phy.
>>> Or rtl8168h cannot be waken up.
>>>
>>> I will submit a new patch according your advice. But we are considering not
>> to use driver(r8169) to setup rtl8211fs. So next patch maybe simpler.
>>>
>>
>> Sounds strange that RTL8168H connects to RTL8211FS via MDI. Typically you
>> would use RGMII here.
>> Is it because RTL8168H has no pins for RGMII to external PHY's?
>>
>> Then my understanding would be that you do it like this:
>> RTL8168H MAC -> <internal RGMII> -> RTL8168H PHY -> <MDI> -> RTL8211FS -
>>> <SerDes> -> Fiber module
>>    |                                                             |
>>     -------------------bit-banged MDIO---------------------------
>>
>> Sou you would need to control both PHY's, right? Because setup wouldn't
>> work if e.g. RTL8168H-internal PHY is powered down.
>> Is the RTL8211FS interrupt pin connected to RTL8168H? Or has polling to be
>> used to get the status from RTL8211FS?
>>
> rtl8168H is an integrated Ethernet controller, it contains MAC and PHY. It has no RGMII interface to connect to external PHY.
> In this application, driver r8169 controls two PHY. One is rtl8168h's PHY, another PHY is rtl8211fs.
> What r8169 have to do is to enable all link capability. rtl8211fs firmware will propagate fiber's link status to rtl8168h. 
> rtl8168h will know the fiber's link status from its MAC register 0x6c. This the same as before. So rtl8211fs's interrupt pin 
> will not connect to rtl8168h. And rtl8168h does not have to polling the link status of rtl8211fs.
> 
> RTL8168H MAC -> <internal RGMII> -> RTL8168H PHY -> <MDI> -> RTL8211FS -> <SerDes> -> Fiber module
>    |                                                                                                                                    |
>     -------------------bit-banged MDIO(use eeprom or gpo pin)--------------------
> 
> Because rtl8211fs's firmware will set link capability to 100M and GIGA when fiber link is from off to on..
> So when system suspend, if wol is enabled, rtl8168h will speed down to 100M(because rtl8211fs advertise 100M and giga to rtl8168h).

Can't you disable 100M advertising in RTL8211FS using the standard PHY advertisement register?
This would be more straight-forward and the hack to disable speed-down isn't needed in r8169.
The described firmware behavior to enable 100M advertisement even with 1Gbps speed on fiber side
doesn't seem to make sense.

> The link speed between rtl8168h and fiber will mismatch. That will cause wol fail.
> 
> And in the application, we also need to setup rtl8211fs. Or it may always link down.
> 
>  ------Please consider the environment before printing this e-mail.

OK, I think I get a better idea of your setup.
So it seems RTL8211FS indeed acts as media converter. Link status on MDI side of RTL8211FS reflects link status on fiber/serdes side.
RTL8168H PHY has no idea whether it's connected to RJ45 magnetics or to the MDI side of a RTL8211FS.

I think for configuring RTL8211FS you have two options:
1. Extend the Realtek PHY driver to support RTL8211FS fiber mode
2. Configure RTL8211FS from userspace (phytool, mii-tool, ..). However to be able to do this you may need to add a dummy netdevice
   that RTL8211FS is attached to. When going with this option it may be better to avoid phylib taking control of RTL8211FS.
   This can be done by setting the phy_mask of the bit-banged mii_bus.


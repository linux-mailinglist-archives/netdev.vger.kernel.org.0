Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9010C207866
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 18:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404879AbgFXQGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 12:06:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404525AbgFXQGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 12:06:38 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89512C061573;
        Wed, 24 Jun 2020 09:06:38 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l2so1572705wmf.0;
        Wed, 24 Jun 2020 09:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N5fl5/sMZxwAr7ptc9+M4Sr+AByefpkVY5hVcBVQQ/k=;
        b=c2rzrcC1s/RvV0v6BauZL5SgifsfzraAm6dKbwwVmpzxQX4AEpCnmWIyRQjVyJ0BxY
         VwAF1gysQzcY6viTFWKNd5ER+wald/A+oDJmThbanQzzZTMkP8Syhpwrt+cK1I8evkBw
         vKEUtxcqdx/YAs6AfAz1YMl1W6EjqZaigjKox7N0hT1oe61tpTl1rIpLMJbIlywMUA6y
         r9Iqdiq9bK+9J6sjSGr1PFWW6C7ipYzc5btYktjX9GjMxMJrTiHGA4nrljYift0Cb5wn
         Lo9oppL/ubGVr1CRnyh4GbMhJctzp8q5jjRO/KLV5NGB/8uatOUPDVDfTmK6h+fUbnK4
         JiJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N5fl5/sMZxwAr7ptc9+M4Sr+AByefpkVY5hVcBVQQ/k=;
        b=QXjwsmM9OpdYZkuQliRgF7KLfozW3Jj6Zznn6cATO31eYn/M3SCI6PUq4saLq52kXc
         MZQADTovH++L0Mk2WBDMGKVq6arP4jeCcLsrv1iqyrtDLvVIGbgyd4QoEykj0jf+9Zm2
         tkDQSHytAu0wBGiLtzsjdfnO6s458eCTidzhGOv6sca+C5kQWC1I5RR3v+sajF2cN4jY
         gI2S+v3VrJsQueUNamae/pggfrI+/qGHbVtHH6odUJLEkZLxl3dDD4D/QcNBp2Qh0o/M
         0V+8qWzyuTVXdf/w2H1uFq0iXfEK/zp5a2r/72sr1TwAxAZ20eNG6pz9X+bKqeLDOucV
         O+/g==
X-Gm-Message-State: AOAM530Hj3RVbEljJELo0oSAzpPDBhS/wFCsdfzuqIiwbxMrwRkIskyr
        kPpXjjZ05yKWysVHQ19YXgo=
X-Google-Smtp-Source: ABdhPJwWIG0y9eC4lbkgJBhmydeFIya8dS7IrcbvZPWjmmIvUtHTKwrtZj6sEnp2a6behlqd9ZQbOQ==
X-Received: by 2002:a1c:a90d:: with SMTP id s13mr16491624wme.184.1593014797129;
        Wed, 24 Jun 2020 09:06:37 -0700 (PDT)
Received: from [10.230.189.192] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm10446689wro.90.2020.06.24.09.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2020 09:06:36 -0700 (PDT)
Subject: Re: [PATCH 09/15] net: phy: delay PHY driver probe until PHY
 registration
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Mark Brown <broonie@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Iyappan Subramanian <iyappan@os.amperecomputing.com>,
        Keyur Chudgar <keyur@os.amperecomputing.com>,
        Quan Nguyen <quan@os.amperecomputing.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Liam Girdwood <lgirdwood@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC..." 
        <linux-mediatek@lists.infradead.org>,
        Fabien Parent <fparent@baylibre.com>,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
References: <20200622093744.13685-1-brgl@bgdev.pl>
 <20200622093744.13685-10-brgl@bgdev.pl> <20200622133940.GL338481@lunn.ch>
 <20200622135106.GK4560@sirena.org.uk>
 <dca54c57-a3bd-1147-63b2-4631194963f0@gmail.com>
 <20200624094302.GA5472@sirena.org.uk>
 <CAMRc=McBxJdujCyjQF3NA=bCWHF1dx8xJ1Nc2snmqukvJ_VyoQ@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f806586d-a6d7-99af-bba4-d1e7d28be192@gmail.com>
Date:   Wed, 24 Jun 2020 09:06:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <CAMRc=McBxJdujCyjQF3NA=bCWHF1dx8xJ1Nc2snmqukvJ_VyoQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/24/2020 6:48 AM, Bartosz Golaszewski wrote:
> śr., 24 cze 2020 o 11:43 Mark Brown <broonie@kernel.org> napisał(a):
>>
>> On Tue, Jun 23, 2020 at 12:49:15PM -0700, Florian Fainelli wrote:
>>> On 6/22/20 6:51 AM, Mark Brown wrote:
>>
>>>> If the bus includes power management for the devices on the bus the
>>>> controller is generally responsible for that rather than the devices,
>>>> the devices access this via facilities provided by the bus if needed.
>>>> If the device is enumerated by firmware prior to being physically
>>>> enumerable then the bus will generally instantiate the device model
>>>> device and then arrange to wait for the physical device to appear and
>>>> get joined up with the device model device, typically in such situations
>>>> the physical device might appear and disappear dynamically at runtime
>>>> based on what the driver is doing anyway.
>>
>>> In premise there is nothing that prevents the MDIO bus from taking care
>>> of the regulators, resets, prior to probing the PHY driver, what is
>>> complicated here is that we do need to issue a read of the actual PHY to
>>> know its 32-bit unique identifier and match it with an appropriate
>>> driver. The way that we have worked around this with if you do not wish
>>> such a hardware access to be made, is to provide an Ethernet PHY node
>>> compatible string that encodes that 32-bit OUI directly. In premise the
>>> same challenges exist with PCI devices/endpoints as well as USB, would
>>> they have reset or regulator typically attached to them.
>>
>> That all sounds very normal and is covered by both cases I describe?
>>
>>>> We could use a pre-probe stage in the device model for hotpluggable
>>>> buses in embedded contexts where you might need to bring things out of
>>>> reset or power them up before they'll appear on the bus for enumeration
>>>> but buses have mostly handled that at their level.
>>
>>> That sounds like a better solution, are there any subsystems currently
>>> implementing that, or would this be a generic Linux device driver model
>>> addition that needs to be done?
>>
>> Like I say I'm suggesting doing something at the device model level.
> 
> I didn't expect to open such a can of worms...
> 
> This has evolved into several new concepts being proposed vs my
> use-case which is relatively simple. The former will probably take
> several months of development, reviews and discussions and it will
> block supporting the phy supply on pumpkin boards upstream. I would
> prefer not to redo what other MAC drivers do (phy-supply property on
> the MAC node, controlling it from the MAC driver itself) if we've
> already established it's wrong.

You are not new to Linux development, so none of this should come as a
surprise to you. Your proposed solution has clearly short comings and is
a hack, especially around the PHY_ID_NONE business to get a phy_device
only then to have the real PHY device ID. You should also now that "I
need it now because my product deliverable depends on it" has never been
received as a valid argument to coerce people into accepting a solution
for which there are at review time known deficiencies to the proposed
approach.

> 
> Is there any compromise we could reach to add support for a basic,
> common use-case of a single regulator supplying a PHY that needs
> enabling before reading its ID short-term (just like we currently
> support a single reset or reset-gpios property for PHYs) and
> introducing a whole new concept to the device model for more advanced
> (but currently mostly hypothetical) cases long-term?

The pre-probe use case is absolutely not hypothetical, and I would need
it for pcie-brcmstb.c at some point which is a PCIe root complex driver
with multiple regulators that need to be turned on *prior* to
enumerating the PCIe bus and creating pci_device instances. It is
literally the same thing as what you are trying to do, just in a
different subsystem, therefore I am happy to test and review your patches.
-- 
Florian

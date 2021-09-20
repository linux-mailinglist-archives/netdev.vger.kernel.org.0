Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A1741272D
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 22:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230148AbhITUI3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 16:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbhITUG1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 16:06:27 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ADE8C0610CB
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:14:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id j14so4390522plx.4
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:14:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XkxI10Q63te/79LiM01w0jeXzxe2rMWfHUdzR7oRlOk=;
        b=fkQBhjQTjHVNzCafWbDsAQjMteLUFfphahnJ2v7d1/SbLQAOdhKpdwILLv9ezqPW4y
         AbcQNc65Kzsl+T0QBMoRBdZx7hjxcmHBtalmsLt7Ir1TJS7Oz378Jn/vn0agYE3pi3nG
         zySSfbrsc5J8Tq/fPG28DaFbYEzYxb2s2UREmi1o3RlJ87cCB6c6mBZYoAtGszRTWPmW
         Dm2toRqq3wAKfxHUXzgrcaYWVxhZi3X3NwC4Z/ux1mYmO11BY/HAUqtkNp/6lp6M9tRX
         CU+S1peKHOaFp9+icTiUaOAbgaOMpHf6dwrWt1/WEXojB5f532ccNbX/EZ13LzFmnVJ4
         Qo/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XkxI10Q63te/79LiM01w0jeXzxe2rMWfHUdzR7oRlOk=;
        b=ocuD/a6OXTX5SErH4qS4uIKCe8QMdcCoek6OGY0gt3WextqT2efhLYPikfyBsN6ODt
         qzRR+ZTdDpP3l0i15z9G6V5JtGN8jrDZoheiG8DNrp3sPs8aw0s/UaQrCg8yYcS2IAoo
         zfEoLAQShCBQxuX0YnVijNR+AN47f0dqq7UlMoZSM5HmQT7mTay5lZSDr2rP38bpK6q2
         NDulq/9i6zdDURU4Vo6VMIBzRzwfSzCd/HTKKhWwPiXcTqG8m0hf4G4AI6OgnlwQUN8h
         q71eXJtBOb4SsOTQpG+3DoLhT8GFFwqJWzNKDXNuZxwEP3fBTAoBTM+kHxXndc8Ylofp
         CokA==
X-Gm-Message-State: AOAM533eRCrcC8lGmJLf4R5elAE5Xi9rdEGa74vROjH+Ft8GmGjpmNAL
        B1BgxDaqHJ2kIJehiozTJmw=
X-Google-Smtp-Source: ABdhPJwumqmVMITI7VTJSRx6EJUNyAgcufrKlxngEcjIAQnjFKGSPO1K5QgFBX0oCaZEmesAYXP8Vg==
X-Received: by 2002:a17:902:d34c:b0:13d:a829:bcb4 with SMTP id l12-20020a170902d34c00b0013da829bcb4mr8047089plk.2.1632158090952;
        Mon, 20 Sep 2021 10:14:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u6sm15397576pgr.3.2021.09.20.10.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Sep 2021 10:14:50 -0700 (PDT)
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Saravana Kannan <saravanak@google.com>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
 <20210920170348.o7u66gpwnh7bczu2@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <11994990-11f2-8701-f0a4-25cb35393595@gmail.com>
Date:   Mon, 20 Sep 2021 10:14:48 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210920170348.o7u66gpwnh7bczu2@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/20/21 10:03 AM, Vladimir Oltean wrote:
> On Mon, Sep 20, 2021 at 09:36:23AM -0700, Florian Fainelli wrote:
>> +Andrew, Vladimir, Heiner, Russell, Saravana,
>>
>> On 9/20/21 5:52 AM, Rafał Miłecki wrote:
>>> I have problem using a switch b53 MDIO driver with an Ethernet bgmac
>>> driver.
>>>
>>> bgmac registers MDIO bus before registering Ethernet controller. That
>>> results in kernel probing switch (available as MDIO device) early which
>>> results in dsa_port_parse_of() returning -EPROBE_DEFER.
>>
>> Yes, putting the big picture together and assuming you have applied
>> these 3 patches which is how you observed that:
>>
>> https://lore.kernel.org/linux-devicetree/20210920123441.9088-1-zajec5@gmail.com/
>> https://lore.kernel.org/linux-devicetree/20210920141024.1409-1-zajec5@gmail.com/
>> https://lore.kernel.org/linux-devicetree/20210920141024.1409-2-zajec5@gmail.com/
>>
>> This is somewhat expected unfortunately and I don't know how we can
>> break the circular dependencies here.
> 
> Why is it expected? AFAIK:
> (1) the Generic PHY driver will not match any hardware in phy_bus_match,
>     it is only bound by hand. Am I wrong?
> (2) of_mdiobus_register sets "mdio->phy_mask = ~0;" anyway, which blocks
>     the automatic creation of any phy_device for stuff that responds to
>     PHY ID registers 2 and 3.

I should have been clearer here, it is expected to get at least one
EPROBE_DEFER, the outcome of it is not, but you have provided the reason
why below.

> 
>>> It's OK so far but then in goes like this:
>>>
>>> [    1.306884] bus: 'bcma': driver_probe_device: matched device bcma0:5 with driver bgmac_bcma
>>> [    1.315427] bus: 'bcma': really_probe: probing driver bgmac_bcma with device bcma0:5
>>> [    1.323468] bgmac_bcma bcma0:5: Found PHY addr: 30 (NOREGS)
>>> [    1.329722] libphy: bcma_mdio mii bus: probed
>>> [    1.334468] bus: 'mdio_bus': driver_probe_device: matched device bcma_mdio-0-0:1e with driver bcm53xx
>>> [    1.343877] bus: 'mdio_bus': really_probe: probing driver bcm53xx with device bcma_mdio-0-0:1e
>>> [    1.353174] bcm53xx bcma_mdio-0-0:1e: found switch: BCM53125, rev 4
>>> [    1.359595] bcm53xx bcma_mdio-0-0:1e: failed to register switch: -517
>>> [    1.366212] mdio_bus bcma_mdio-0-0:1e: Driver bcm53xx requests probe deferral
>>> [    1.373499] mdio_bus bcma_mdio-0-0:1e: Added to deferred list
>>> [    1.379362] bgmac_bcma bcma0:5: Support for Roboswitch not implemented
>>> [    1.387067] bgmac_bcma bcma0:5: Timeout waiting for reg 0x1E0
>>> [    1.393600] driver: 'Generic PHY': driver_bound: bound to device 'bcma_mdio-0-0:1e'
>>> [    1.401390] Generic PHY bcma_mdio-0-0:1e: Removed from deferred list
>>>
>>> I can't drop "Generic PHY" driver as it's required for non-CPU switch
>>> ports. I just need kernel to prefer b53 MDIO driver over the "Generic
>>> PHY" one.
>>>
>>> Can someone help me fix that, please?
>>
>> I don't think that you have a race condition, but you have the Ethernet
>> switch's pseudo PHY
> 
> what's a pseudo PHY?
> 
>> which is accessible via MDIO and the Generic PHY driver happily goes
>> on trying to read the MII_PHYSID1/PHYS_ID2 which do not map to
>> anything on that switch, but still you will get a non-zero/non-all Fs
>> value from there, hence the Generic PHY is happy to take over.
> 
> Why would it do that? Why would there be a PHY device created for the
> switch? Is there any phy-handle pointing to the switch OF node?
> 
>> Given that the MDIO node does have a compatible string which is not in
>> the form of an Ethernet PHY's compatible string, I wonder if we can
>> somewhat break the circular dependency using that information.
> 
> I think you're talking about:
> 
> of_mdiobus_register
> -> of_mdiobus_child_is_phy
> 
> but as mentioned, that code path should not be creating PHY devices.
> 
> I think this code path in bgmac_probe might be responsible for it:
> 
> 	switch (core->core_unit) {
> 	case 0:
> 		bgmac->phyaddr = sprom->et0phyaddr;
> 		break;
> 	case 1:
> 		bgmac->phyaddr = sprom->et1phyaddr;
> 		break;
> 	case 2:
> 		bgmac->phyaddr = sprom->et2phyaddr;
> 		break;
> 	}
> 	bgmac->phyaddr &= BGMAC_PHY_MASK;
> 	if (bgmac->phyaddr == BGMAC_PHY_MASK) {
> 		dev_err(bgmac->dev, "No PHY found\n");
> 		err = -ENODEV;
> 		goto err;
> 	}
> 	dev_info(bgmac->dev, "Found PHY addr: %d%s\n", bgmac->phyaddr,
> 		 bgmac->phyaddr == BGMAC_PHY_NOREGS ? " (NOREGS)" : "");
> 
> 	if (!bgmac_is_bcm4707_family(core) &&
> 	    !(ci->id == BCMA_CHIP_ID_BCM53573 && core->core_unit == 1)) {
> 		struct phy_device *phydev;
> 
> 		mii_bus = bcma_mdio_mii_register(bgmac);
> 		if (IS_ERR(mii_bus)) {
> 			err = PTR_ERR(mii_bus);
> 			goto err;
> 		}
> 		bgmac->mii_bus = mii_bus;
> 
> 		phydev = mdiobus_get_phy(bgmac->mii_bus, bgmac->phyaddr);
> 		if (ci->id == BCMA_CHIP_ID_BCM53573 && phydev &&
> 		    (phydev->drv->phy_id & phydev->drv->phy_id_mask) == PHY_ID_BCM54210E)
> 			phydev->dev_flags |= PHY_BRCM_EN_MASTER_MODE;
> 	}
> 
> At least, that's what the log indicates:
> 
> [    1.323468] bgmac_bcma bcma0:5: Found PHY addr: 30 (NOREGS) <- 30 is 0x1e, which is Rafal's switch MDIO address in the device tree patch here:
> https://lore.kernel.org/linux-devicetree/20210920141024.1409-1-zajec5@gmail.com/
> 
> So I haven't investigated what the code tries to do by searching the "sprom", but it probably shouldn't have a PHY address
> pointing towards the switch?

The SPROM is a piece of NVRAM that is intended to describe in a set of
key/value pairs various platform configuration details. There can be up
to 3 GMACs on the SoC which you can connect in a variety of ways towards
internal/external PHYs or internal/external Ethernet switches. The SPROM
is used to describe whether you connect to a regular PHY (not at PHY
address 30 decimal, so not the Broadcom pseudo-PHY) or an Ethernet
switch pseudo-PHY via MDIO.

What appears to be missing here is that we should not be executing this
block of code for phyaddr == BGMAC_PHY_NOREGS because we will not have a
PHY device proper to begin with and this collides with registering the
b53_mdio driver.
--
Florian

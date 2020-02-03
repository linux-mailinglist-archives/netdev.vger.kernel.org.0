Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A981015116D
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 21:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgBCUzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 15:55:06 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:34969 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgBCUzG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Feb 2020 15:55:06 -0500
Received: by mail-pj1-f65.google.com with SMTP id q39so298311pjc.0;
        Mon, 03 Feb 2020 12:55:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4PvKV2c7fablf5zGnZXIOwVJkpsf6Vl3plbqg7cF5bE=;
        b=PxLMg1t72Gtqwy+YXBBPokAcQB9gkEBde90LY1JZzrtuv7iZGmhBlF6FICvPtWGVgO
         jpAnI+Lon4V/BWjiSeTs6tgb8ke5sEhkjRTL5H43lyNWDyNFrULWTFcm3623Cniwpbsx
         Zzm0ZIcf2W5E+NAtLb1AHLAiKNGiAT73mQ+k27iw9+5Lk7cL+x5Nls0ljp7P2onmpOdR
         i9HxOJ7t8GoTEVtbJxhwrzm1N16trAP5lUApPNwKmnQ/22AMK9Bj6i0JN4mKfaE+Xe4z
         MW0E4mcDekSWTYNV9dChLM7LiwgEt//V9azt1txLuAmWWbcotpnfxNOJLWU+Vt4OD2eI
         GZww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=4PvKV2c7fablf5zGnZXIOwVJkpsf6Vl3plbqg7cF5bE=;
        b=LGOGwrpKvArp+3tBjPVSN/NgjigsYeKzNpd88M9EQ6o3nllVnzEbHeKb1Hd0rcCXgU
         5HwxdXqdYBIVPNdnOsr76Y+Aob8pnqR1qA2A7j+LUdFLuq3v4M2AQeE0X6eydTrVsNpv
         F3IHtCdT9nbSwtec2vaGSVkAUe9zoqGdZfFihDAONux9dxlyhdw4WPE55bQBID6YJMX+
         v4dIxebzwUJ5W7aqOHeH7/Nw3jK+J8IE15OKRINmzBaXPhNok7ET28ioLiIxyI+skbMV
         s0l+9URsWaJjtioF3RSUF89d4mWisnq5m6hrz+U2MItAHOBqvE5cTAOOUJeiQZVOgWBF
         vT0g==
X-Gm-Message-State: APjAAAVLjOx5uSHRkh+ZEEufqxYhFgQgVr1buA0cyeaMCbO7gZv+nLVM
        9sz85uO2PxVo5sH1iKqVgL4=
X-Google-Smtp-Source: APXvYqzHDdmwsMI6X+BuEFDVO4jB0VjHYaDSf6AUh4yxmn2+br6obqJ5NG7FuN3Lq9GE/Eyz8+bLgQ==
X-Received: by 2002:a17:902:8341:: with SMTP id z1mr24660047pln.178.1580763305427;
        Mon, 03 Feb 2020 12:55:05 -0800 (PST)
Received: from [10.67.50.115] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i3sm21394759pfg.94.2020.02.03.12.55.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Feb 2020 12:55:04 -0800 (PST)
Subject: Re: [PATCH 3/6] net: bcmgenet: enable automatic phy discovery
To:     Jeremy Linton <jeremy.linton@arm.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com, davem@davemloft.net,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org, wahrenst@gmx.net,
        hkallweit1@gmail.com
References: <20200201074625.8698-1-jeremy.linton@arm.com>
 <20200201074625.8698-4-jeremy.linton@arm.com> <20200201152518.GI9639@lunn.ch>
 <608e7fab-69a3-700d-bfcf-88e5711ce58f@arm.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 G10n8gCguORqNGMsVRxrlLs7/himep7MrCc=
Message-ID: <800ec5d6-44d5-22aa-cf0c-0e7c5de1feb3@gmail.com>
Date:   Mon, 3 Feb 2020 12:55:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <608e7fab-69a3-700d-bfcf-88e5711ce58f@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/1/20 11:07 AM, Jeremy Linton wrote:
> Hi,
> 
> First thanks for looking at this!
> 
> On 2/1/20 9:25 AM, Andrew Lunn wrote:
>> On Sat, Feb 01, 2020 at 01:46:22AM -0600, Jeremy Linton wrote:
>>> The unimac mdio driver falls back to scanning the
>>> entire bus if its given an appropriate mask. In ACPI
>>> mode we expect that the system is well behaved and
>>> conforms to recent versions of the specification.
>>>
>>> We then utilize phy_find_first(), and
>>> phy_connect_direct() to find and attach to the
>>> discovered phy during net_device open.
>>>
>>> Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>>> ---
>>>   drivers/net/ethernet/broadcom/genet/bcmmii.c | 40 +++++++++++++++++---
>>>   1 file changed, 34 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/drivers/net/ethernet/broadcom/genet/bcmmii.c
>>> b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>>> index 2049f8218589..f3271975b375 100644
>>> --- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
>>> +++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
>>> @@ -5,7 +5,7 @@
>>>    * Copyright (c) 2014-2017 Broadcom
>>>    */
>>>   -
>>> +#include <linux/acpi.h>
>>>   #include <linux/types.h>
>>>   #include <linux/delay.h>
>>>   #include <linux/wait.h>
>>> @@ -311,7 +311,9 @@ int bcmgenet_mii_config(struct net_device *dev,
>>> bool init)
>>>   int bcmgenet_mii_probe(struct net_device *dev)
>>>   {
>>>       struct bcmgenet_priv *priv = netdev_priv(dev);
>>> -    struct device_node *dn = priv->pdev->dev.of_node;
>>> +    struct device *kdev = &priv->pdev->dev;
>>> +    struct device_node *dn = kdev->of_node;
>>> +
>>>       struct phy_device *phydev;
>>>       u32 phy_flags = 0;
>>>       int ret;
>>> @@ -334,7 +336,27 @@ int bcmgenet_mii_probe(struct net_device *dev)
>>>               return -ENODEV;
>>>           }
>>>       } else {
>>> -        phydev = dev->phydev;
>>> +        if (has_acpi_companion(kdev)) {
>>> +            char mdio_bus_id[MII_BUS_ID_SIZE];
>>> +            struct mii_bus *unimacbus;
>>> +
>>> +            snprintf(mdio_bus_id, MII_BUS_ID_SIZE, "%s-%d",
>>> +                 UNIMAC_MDIO_DRV_NAME, priv->pdev->id);
>>> +
>>> +            unimacbus = mdio_find_bus(mdio_bus_id);
>>> +            if (!unimacbus) {
>>> +                pr_err("Unable to find mii\n");
>>> +                return -ENODEV;
>>> +            }
>>> +            phydev = phy_find_first(unimacbus);
>>> +            put_device(&unimacbus->dev);
>>> +            if (!phydev) {
>>> +                pr_err("Unable to find PHY\n");
>>> +                return -ENODEV;
>>
>> Hi Jeremy
>>
>> phy_find_first() is not recommended. Only use it if you have no other
>> option. If the hardware is more complex, two PHYs on one bus, you are
>> going to have a problem. So i suggest this is used only for PCI cards
>> where the hardware is very fixed, and there is only ever one MAC and
>> PHY on the PCI card. When you do have this split between MAC and MDIO
>> bus, each being independent devices, it is more likely that you do
>> have multiple PHYs on one shared MDIO bus.
> 
> Understood.
> 
>>
>> In the DT world, you use a phy-handle to point to the PHY node in the
>> device tree. Does ACPI have the same concept, a pointer to some other
>> device in ACPI?
> 
> There aren't a lot of good options here. ACPI is mostly a power mgmt
> abstraction and is directly silent on this topic. So while it can be
> quite descriptive like DT, frequently choosing to use a bunch of DT
> properties in ACPI _DSD methods is a mistake. Both for cross OS booting
> as well as long term support. Similar silence from SBSA, which attempts
> to setup some guide rails for situations like this. I think that is
> because there aren't any non-obsolete industry standards for NICs.

I suppose you have two options from here:

- try to set a good example and provide a representation of the devices
that is as comprehensive as possible and paves the way for others to
draw as a good (or not bad at least) example

- continue to do an ad-hoc solution since there is little to no interest
in any standardization (more likely, no need).

> 
> So, in an attempt to fall back on the idea that the hardware should be
> self describing, and it shouldn't be involving the system firmware in
> basic device specific introspection I've been trying to avoid the use of
> any DSD properties. In the majority of cases (including DT) these
> properties aren't being auto-detected by the firmware either, they are
> just being hard-coded into DT or DSDT tables.
> 
> Part of the arm standardization effort has been to clamp down on all the
> creative ways that these machines can be built. It seems a guide rail
> that says for this adapter it must have a MDIO bus per MAC for ACPI
> support as though it were on PCI isn't unreasonable. Another easily
> understood one, might be to assign the PHY's the the same order as the
> MAC's UIDs if there were a shared bus (less ideal without example
> hardware).
> 
> I'm not really sure what the right answer here is, but I like to avoid
> hardcoding DT properties in DSD unless there simply isn't an alternative.

I do not think we are asking to get properties hard coded, we are asking
to get a proper representation of these MDIO devices, including their
supserset that PHY devices are into ACPI, in a way that is usable by the
core MDIO layer without drivers cutting corners.
-- 
Florian

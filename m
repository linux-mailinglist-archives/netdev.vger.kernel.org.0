Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5A74125F3
	for <lists+netdev@lfdr.de>; Mon, 20 Sep 2021 20:49:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351240AbhITSuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Sep 2021 14:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383927AbhITSqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Sep 2021 14:46:15 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D925FC09CE7C
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:03:58 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id v5so62786615edc.2
        for <netdev@vger.kernel.org>; Mon, 20 Sep 2021 10:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=KY3/Fe4BV/74ZiMw1TvpKdEkm/AsQHzqLHKHNu/kDmc=;
        b=Q/Ys7GbWWpuVI440i0JAGFeXPPptOYdYQVtpkoS49tv/tpV8zttW7xqsOyfk4y/ck6
         wByxL1fmsIgOwPBY8GXugOwNtQKkDUqqydQBskl1ncd3HPNND+0Stg9EZlzAF/47jKVB
         ds8c73TglWaS7jR9IS9Typa+kRbOczPrPqlAKayNuKW2XlmKiOIM9K7rWuoYYiisW+CV
         AwHSVBArhDrlink0r1kqSH8B/Y4wBuucj1nf3sLOhSK6qOqe/TijC/uDmLFRcMWSPmkx
         bFnWnnPuLiuPewgLzC8CEP+jdDwhfSu/3ZuP+8LPu1fpmPDtQVaAmfn98pLWRRw+IR6+
         mC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=KY3/Fe4BV/74ZiMw1TvpKdEkm/AsQHzqLHKHNu/kDmc=;
        b=MAmaZO/sruQxOD8s9swFJF9p1FDP1CXzuW1LjABulJnouJm+ZHUz+irSYTeta5e6xS
         kK0xogH8NDS3Eho3JTxlZXjiX78/av6Hx8eVh3cEalrzbg6JN/ep8gsH/igYMVWI+XLw
         PsKsf7UPUWHT5k2xt5+4jRpL+mHVsfOGA3KeIM71Fdyhb0NKTMWXy3+InBK00l3ekT3V
         8tOykAbIH9je0WzJuT6voA2Rey3W8SisNpsK09F1yzwfpIIriMKOaZWcxhXXrWb/M7lA
         wkDFt6gAvH0+V6TLDoAXKjYb9KgUDzj6LBK6MNof7BsUM/VGcIZArpOAytQVawUqFkea
         oFWQ==
X-Gm-Message-State: AOAM531fWd2Fd1XX2WQ0fL+6C04ZiRvZ1ICVnd7/Vl0420fT2dQlvWNz
        Rzq10fSajOhDozTQH1TQxdM=
X-Google-Smtp-Source: ABdhPJyI9zCBxYoyemmWoqLLLLzW0K6IFRxsRqdNiqPZgF5KHNNKTYIZjik/bU/acmKbQCRPSdCPdQ==
X-Received: by 2002:a17:907:1b1b:: with SMTP id mp27mr28891474ejc.538.1632157430972;
        Mon, 20 Sep 2021 10:03:50 -0700 (PDT)
Received: from skbuf ([82.78.148.104])
        by smtp.gmail.com with ESMTPSA id di4sm7351967edb.34.2021.09.20.10.03.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Sep 2021 10:03:50 -0700 (PDT)
Date:   Mon, 20 Sep 2021 20:03:48 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Network Development <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Saravana Kannan <saravanak@google.com>
Subject: Re: Race between "Generic PHY" and "bcm53xx" drivers after
 -EPROBE_DEFER
Message-ID: <20210920170348.o7u66gpwnh7bczu2@skbuf>
References: <3639116e-9292-03ca-b9d9-d741118a4541@gmail.com>
 <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4648f65c-4d38-dbe9-a902-783e6dfb9cbd@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 09:36:23AM -0700, Florian Fainelli wrote:
> +Andrew, Vladimir, Heiner, Russell, Saravana,
> 
> On 9/20/21 5:52 AM, Rafał Miłecki wrote:
> > I have problem using a switch b53 MDIO driver with an Ethernet bgmac
> > driver.
> > 
> > bgmac registers MDIO bus before registering Ethernet controller. That
> > results in kernel probing switch (available as MDIO device) early which
> > results in dsa_port_parse_of() returning -EPROBE_DEFER.
> 
> Yes, putting the big picture together and assuming you have applied
> these 3 patches which is how you observed that:
> 
> https://lore.kernel.org/linux-devicetree/20210920123441.9088-1-zajec5@gmail.com/
> https://lore.kernel.org/linux-devicetree/20210920141024.1409-1-zajec5@gmail.com/
> https://lore.kernel.org/linux-devicetree/20210920141024.1409-2-zajec5@gmail.com/
> 
> This is somewhat expected unfortunately and I don't know how we can
> break the circular dependencies here.

Why is it expected? AFAIK:
(1) the Generic PHY driver will not match any hardware in phy_bus_match,
    it is only bound by hand. Am I wrong?
(2) of_mdiobus_register sets "mdio->phy_mask = ~0;" anyway, which blocks
    the automatic creation of any phy_device for stuff that responds to
    PHY ID registers 2 and 3.

> > It's OK so far but then in goes like this:
> > 
> > [    1.306884] bus: 'bcma': driver_probe_device: matched device bcma0:5 with driver bgmac_bcma
> > [    1.315427] bus: 'bcma': really_probe: probing driver bgmac_bcma with device bcma0:5
> > [    1.323468] bgmac_bcma bcma0:5: Found PHY addr: 30 (NOREGS)
> > [    1.329722] libphy: bcma_mdio mii bus: probed
> > [    1.334468] bus: 'mdio_bus': driver_probe_device: matched device bcma_mdio-0-0:1e with driver bcm53xx
> > [    1.343877] bus: 'mdio_bus': really_probe: probing driver bcm53xx with device bcma_mdio-0-0:1e
> > [    1.353174] bcm53xx bcma_mdio-0-0:1e: found switch: BCM53125, rev 4
> > [    1.359595] bcm53xx bcma_mdio-0-0:1e: failed to register switch: -517
> > [    1.366212] mdio_bus bcma_mdio-0-0:1e: Driver bcm53xx requests probe deferral
> > [    1.373499] mdio_bus bcma_mdio-0-0:1e: Added to deferred list
> > [    1.379362] bgmac_bcma bcma0:5: Support for Roboswitch not implemented
> > [    1.387067] bgmac_bcma bcma0:5: Timeout waiting for reg 0x1E0
> > [    1.393600] driver: 'Generic PHY': driver_bound: bound to device 'bcma_mdio-0-0:1e'
> > [    1.401390] Generic PHY bcma_mdio-0-0:1e: Removed from deferred list
> > 
> > I can't drop "Generic PHY" driver as it's required for non-CPU switch
> > ports. I just need kernel to prefer b53 MDIO driver over the "Generic
> > PHY" one.
> > 
> > Can someone help me fix that, please?
> 
> I don't think that you have a race condition, but you have the Ethernet
> switch's pseudo PHY

what's a pseudo PHY?

> which is accessible via MDIO and the Generic PHY driver happily goes
> on trying to read the MII_PHYSID1/PHYS_ID2 which do not map to
> anything on that switch, but still you will get a non-zero/non-all Fs
> value from there, hence the Generic PHY is happy to take over.

Why would it do that? Why would there be a PHY device created for the
switch? Is there any phy-handle pointing to the switch OF node?

> Given that the MDIO node does have a compatible string which is not in
> the form of an Ethernet PHY's compatible string, I wonder if we can
> somewhat break the circular dependency using that information.

I think you're talking about:

of_mdiobus_register
-> of_mdiobus_child_is_phy

but as mentioned, that code path should not be creating PHY devices.

I think this code path in bgmac_probe might be responsible for it:

	switch (core->core_unit) {
	case 0:
		bgmac->phyaddr = sprom->et0phyaddr;
		break;
	case 1:
		bgmac->phyaddr = sprom->et1phyaddr;
		break;
	case 2:
		bgmac->phyaddr = sprom->et2phyaddr;
		break;
	}
	bgmac->phyaddr &= BGMAC_PHY_MASK;
	if (bgmac->phyaddr == BGMAC_PHY_MASK) {
		dev_err(bgmac->dev, "No PHY found\n");
		err = -ENODEV;
		goto err;
	}
	dev_info(bgmac->dev, "Found PHY addr: %d%s\n", bgmac->phyaddr,
		 bgmac->phyaddr == BGMAC_PHY_NOREGS ? " (NOREGS)" : "");

	if (!bgmac_is_bcm4707_family(core) &&
	    !(ci->id == BCMA_CHIP_ID_BCM53573 && core->core_unit == 1)) {
		struct phy_device *phydev;

		mii_bus = bcma_mdio_mii_register(bgmac);
		if (IS_ERR(mii_bus)) {
			err = PTR_ERR(mii_bus);
			goto err;
		}
		bgmac->mii_bus = mii_bus;

		phydev = mdiobus_get_phy(bgmac->mii_bus, bgmac->phyaddr);
		if (ci->id == BCMA_CHIP_ID_BCM53573 && phydev &&
		    (phydev->drv->phy_id & phydev->drv->phy_id_mask) == PHY_ID_BCM54210E)
			phydev->dev_flags |= PHY_BRCM_EN_MASTER_MODE;
	}

At least, that's what the log indicates:

[    1.323468] bgmac_bcma bcma0:5: Found PHY addr: 30 (NOREGS) <- 30 is 0x1e, which is Rafal's switch MDIO address in the device tree patch here:
https://lore.kernel.org/linux-devicetree/20210920141024.1409-1-zajec5@gmail.com/

So I haven't investigated what the code tries to do by searching the "sprom", but it probably shouldn't have a PHY address
pointing towards the switch?

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0D46E75AB
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 10:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjDSIv3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 04:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231238AbjDSIv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 04:51:28 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FDAB1A4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:51:25 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id h2so1873930ljh.13
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 01:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ferroamp-se.20221208.gappssmtp.com; s=20221208; t=1681894284; x=1684486284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LoeOWx2i9Y0JjBoTzn0h15KUzNCeh36K/SRub+a0uAc=;
        b=xxoNaFmK63jZpxZBXddD1YQcabpgGaO39LWjM+oC0irYSrOoKXgb4VTnSNNGIrMh4Z
         MunsEG9cazq1S74T6FBaRmqtyZGHNOdKXhLgpXJlKllBeD42PIEIa8WadUW584LnZ7zP
         /EXnu2HOnScBxNoTzT0Goe9FqqQzwCxlNexTX4jFp43rcAm2QwkL0Xmg5oHX2hibmNKg
         PHmouSalDe4rocsBbju3O2FgXVkLFNeHpbIflXmKOmJkN7m+zyqX72Q2YZYvKqm/euX3
         lq6iIfkh41y3vVIZ6qhWErKH/xKPCD3zG1jxshIhBt4q0RQ73kNLdaFPs7KONH8o2Eo/
         qFQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681894284; x=1684486284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LoeOWx2i9Y0JjBoTzn0h15KUzNCeh36K/SRub+a0uAc=;
        b=FCbvaNJE9LCxy8kxTMH+qXq+WKWWJdMViA16Oqx8Bq8Odih9ZSoaAXOQNZueiZOHal
         nhLY9tAeGXGq6Un9sh0Y/KVFSNoSRM4FToIABPC/46XYifJ8YgfycDazacQWyYhHNWt7
         9J0EzE9k6aG1a7M1sJPRaz5m7ezdCdISXTXNDVaBpf4OZJxwr8gcVOpdGW5Kkb5LArYP
         xAzTJ76oe+n1ohj5jfSPLhUf9TQeaMAW0XbK+p3FDeRsT+MLjG3/LQmzGG/+jjgrkPZd
         beDPMU5C+yO6fL6yelRj0w8bYTdsemmUvUDkHEhODfxsD4g243/0X5xE0FimHySCorXp
         888w==
X-Gm-Message-State: AAQBX9dEcw3o2LEUSKDJDKG3auwd3khtpA3Fo/XFDP1lTyPsL88ubRhE
        XoI9vFanao1+eukiwVZc3//PFlfzjBkX7NWAzFs=
X-Google-Smtp-Source: AKy350YYvI2jQTOUaOdA6HdkGo2h8gXfvHqQSzkDhDM84uKbIglgXaxrz+Z1TgEHZ7uKVR2oYPf95A==
X-Received: by 2002:a2e:9997:0:b0:2a8:a5bc:6a10 with SMTP id w23-20020a2e9997000000b002a8a5bc6a10mr1615695lji.45.1681894283776;
        Wed, 19 Apr 2023 01:51:23 -0700 (PDT)
Received: from debian (151.236.202.107.c.fiberdirekt.net. [151.236.202.107])
        by smtp.gmail.com with ESMTPSA id i9-20020a2e8089000000b002a8e73c83ffsm308354ljg.33.2023.04.19.01.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 01:51:23 -0700 (PDT)
Date:   Wed, 19 Apr 2023 10:51:21 +0200
From:   =?iso-8859-1?Q?Ram=F3n?= Nordin Rodriguez 
        <ramon.nordin.rodriguez@ferroamp.se>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Message-ID: <ZD+riUQkTIY2Ep30@debian>
References: <ZD7YzBhzlEBHrEPC@builder>
 <2806b25b-1914-4525-a085-b0867711bce9@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2806b25b-1914-4525-a085-b0867711bce9@lunn.ch>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 18, 2023 at 08:56:47PM +0200, Andrew Lunn wrote:
> > +config LAN867X_PHY
> > +	tristate "Microchip 10BASE-T1S Ethernet PHY"
> > +	help
> > +		Currently supports the LAN8670, LAN8671, LAN8672
> > +
> 
> This file is sorted by tristate string, so it should come before
>         tristate "Microchip PHYs"
> 

Ah, I missed that, fixing it in the next patch version.

> > diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
> > index b5138066ba04..a12c2f296297 100644
> > --- a/drivers/net/phy/Makefile
> > +++ b/drivers/net/phy/Makefile
> > @@ -78,6 +78,7 @@ obj-$(CONFIG_MICROSEMI_PHY)	+= mscc/
> >  obj-$(CONFIG_MOTORCOMM_PHY)	+= motorcomm.o
> >  obj-$(CONFIG_NATIONAL_PHY)	+= national.o
> >  obj-$(CONFIG_NCN26000_PHY)	+= ncn26000.o
> > +obj-$(CONFIG_LAN867X_PHY) += lan867x.o
> 
> And this is sorted by CONFIG_ so should appear after
> CONFIG_INTEL_XWAY_PHY.
> 

Same thing here, will fix it.

> >  obj-$(CONFIG_NXP_C45_TJA11XX_PHY)	+= nxp-c45-tja11xx.o
> >  obj-$(CONFIG_NXP_TJA11XX_PHY)	+= nxp-tja11xx.o
> >  obj-$(CONFIG_QSEMI_PHY)		+= qsemi.o
> > diff --git a/drivers/net/phy/lan867x.c b/drivers/net/phy/lan867x.c
> 
> Maybe call it microchip_t1s.c ? That sort of fits with the pattern of
> the current files:
> 
> microchip.c
> microchip_t1.c
> 
> Microchip drivers don't really have a consistent naming, because they
> keep buying other vendors, like vitesse, Microsemi, Micrel/Kendin...
> 

Totally agree with the name suggestion.

> > +static int lan867x_config_init(struct phy_device *phydev)
> > +{
> > +	/* HW quirk: Microchip states in the application note (AN1699) for the phy
> > +	 * that a set of read-modify-write (rmw) operations has to be performed
> > +	 * on a set of seemingly magic registers.
> > +	 * The result of these operations is just described as 'optimal performance'
> > +	 * Microchip gives no explanation as to what these mmd regs do,
> > +	 * in fact they are marked as reserved in the datasheet.
> > +	 */
> > +
> > +	/* The arrays below are pulled from the following table from AN1699
> > +	 * Access MMD Address Value Mask
> > +	 * RMW 0x1F 0x00D0 0x0002 0x0E03
> > +	 * RMW 0x1F 0x00D1 0x0000 0x0300
> > +	 * RMW 0x1F 0x0084 0x3380 0xFFC0
> > +	 * RMW 0x1F 0x0085 0x0006 0x000F
> > +	 * RMW 0x1F 0x008A 0xC000 0xF800
> > +	 * RMW 0x1F 0x0087 0x801C 0x801C
> > +	 * RMW 0x1F 0x0088 0x033F 0x1FFF
> > +	 * W   0x1F 0x008B 0x0404 ------
> > +	 * RMW 0x1F 0x0080 0x0600 0x0600
> > +	 * RMW 0x1F 0x00F1 0x2400 0x7F00
> > +	 * RMW 0x1F 0x0096 0x2000 0x2000
> > +	 * W   0x1F 0x0099 0x7F80 ------
> > +	 */
> > +
> > +	const int registers[12] = {
> > +		0x00D0, 0x00D1, 0x0084, 0x0085,
> > +		0x008A, 0x0087, 0x0088, 0x008B,
> > +		0x0080, 0x00F1, 0x0096, 0x0099,
> > +	};
> > +
> > +	const int masks[12] = {
> > +		0x0E03, 0x0300, 0xFFC0, 0x000F,
> > +		0xF800, 0x801C, 0x1FFF, 0xFFFF,
> > +		0x0600, 0x7F00, 0x2000, 0xFFFF,
> > +	};
> > +
> > +	const int values[12] = {
> > +		0x0002, 0x0000, 0x3380, 0x0006,
> > +		0xC000, 0x801C, 0x033F, 0x0404,
> > +		0x0600, 0x2400, 0x2000, 0x7F80,
> > +	};
> > +
> > +	int err;
> > +	int reg;
> > +	int reg_value;
> 
> netdev uses reverse christmas tree. That is, variables should be
> sorted with the longest lines first, shorted last.
> 

Missed that in the style guide, will fix it.

> > +	/* Read-Modified Write Pseudocode (from AN1699)
> > +	 * current_val = read_register(mmd, addr) // Read current register value
> > +	 * new_val = current_val AND (NOT mask) // Clear bit fields to be written
> > +	 * new_val = new_val OR value // Set bits
> > +	 * write_register(mmd, addr, new_val) // Write back updated register value
> > +	 */
> > +	for (int i = 0; i < ARRAY_SIZE(registers); i++) {
> > +		reg = registers[i];
> > +		reg_value = phy_read_mmd(phydev, MDIO_MMD_VEND2, reg);
> > +		reg_value &= ~masks[i];
> > +		reg_value |= values[i];
> > +		err = phy_write_mmd(phydev, MDIO_MMD_VEND2, reg, reg_value);
> > +		if (err != 0)
> > +			return err;
> > +	}
> 
> Maybe phy_modify_mmd(). However, that skips the write if the value is
> not changed by the mask and set value.
> 

I've reached out to Microchip regarding this and asked them if a write
is required even if the resulting value is not modified.
I suggest we leave this as is, and if they respond that it's not
required to write on unmodified I will submit a patch that removes this
block and uses phy_modify_mmd instead.
In breif I don't feel confident that I can verify that I've achieved
'optimal perfomance' as they refer to it as and would like to get
feedback from the manufacturer.

> > +static int lan867x_config_interrupt(struct phy_device *phydev)
> > +{
> > +	/* None of the interrupts in the lan867x phy seem relevant.
> > +	 * Other phys inspect the link status and call phy_trigger_machine
> > +	 * on change.
> > +	 * This phy does not support link status, and thus has no interrupt
> > +	 * for it either.
> > +	 * So we'll just disable all interrupts instead.
> > +	 */
> 
> It interrupts are pointless, just don't provide the functions. phylib
> will then poll.
> 

Gotcha, I'll remove the func.

> > +static int lan867x_read_status(struct phy_device *phydev)
> > +{
> > +	/* The phy has some limitations, namely:
> > +	 *  - always reports link up
> > +	 *  - only supports 10MBit half duplex
> > +	 *  - does not support auto negotiate
> > +	 */
> > +	phydev->link = 1;
> > +	phydev->duplex = DUPLEX_HALF;
> > +	phydev->speed = SPEED_10;
> > +	phydev->autoneg = AUTONEG_DISABLE;
> > +
> > +	return 0;
> 
> Not that polling gives anything useful!
> 
>     Andrew

:) Great feedback! Trying to get a new patch out today

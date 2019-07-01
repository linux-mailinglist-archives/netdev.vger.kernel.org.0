Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 957E35C584
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 00:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbfGAWLH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 18:11:07 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38454 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbfGAWLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 18:11:07 -0400
Received: by mail-pl1-f196.google.com with SMTP id 9so7257311ple.5
        for <netdev@vger.kernel.org>; Mon, 01 Jul 2019 15:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HdrP+5n5nJbtYjgIlEc+YGa9TEsVBxE5SMpV5kWYO54=;
        b=JKagJn6S47sY856SpNzPiGzHVpWjDL+ebHQwSACOzykVzvXyzGHcQLHUTqVHawCix6
         rC4s3KAQVm18SbrOWBSC3X9VYjPifrRstjmJTWP9cu/pkojCW18IHa1i3L+PVr88Nz6Z
         +eZelq7nzPP1TUKGOqtyd52Cd+CJlZF3kgPxE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HdrP+5n5nJbtYjgIlEc+YGa9TEsVBxE5SMpV5kWYO54=;
        b=iIAySyrLqQ7krFiJ0nApbAThlEUFZkebRm7515iE3dFZAoPLKIrccv9xGw9S3LEGYA
         BKs4tAL5tJHV3YI5wFj6kWT7iSqxQH9sK7xCenU4EMafOh/I31BXbUO7heWCizK4LjZE
         6+KxPWyelW2E/k/Ho0jkVBBs0vm0cxEtmkMcDPxzflD4k3Fee9yyXbzgypAsGAe0VZcV
         tgay/CUfrwYxkq8920qil5dvcgMIhMG74990UODaTeYSPNNhICkFXW0wFxQbDU1VZu7b
         aj8CnPDkaoHQDUcAVvjHNKWebMPLhq5uvyE1/9sCxHHySKvl+lBGD16U8PVNaZPBcSbO
         eHdg==
X-Gm-Message-State: APjAAAWpKi8/gURxa0I9bSPpQ/9hNZ3QVQ+g5GxEzUVmf2paBRoompXP
        4OOTY3xCD3a21UV2+EwoVrVhiQ==
X-Google-Smtp-Source: APXvYqz06zuULBLTFE1ez0fbfhzDyTWB/DJY0xO9Mb6EE/MT2PdTDwBE7MPtcjYDNo22x5YKVDkx7A==
X-Received: by 2002:a17:902:704c:: with SMTP id h12mr31681479plt.214.1562019066802;
        Mon, 01 Jul 2019 15:11:06 -0700 (PDT)
Received: from localhost ([2620:15c:202:1:75a:3f6e:21d:9374])
        by smtp.gmail.com with ESMTPSA id y68sm12874496pfy.164.2019.07.01.15.11.05
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 01 Jul 2019 15:11:05 -0700 (PDT)
Date:   Mon, 1 Jul 2019 15:11:04 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH 3/3] net: phy: realtek: Support SSC for the RTL8211E
Message-ID: <20190701221104.GC250418@google.com>
References: <20190701195225.120808-1-mka@chromium.org>
 <20190701195225.120808-3-mka@chromium.org>
 <8adbb2b8-6747-b876-f85d-75e54f1978cb@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8adbb2b8-6747-b876-f85d-75e54f1978cb@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 10:49:45PM +0200, Heiner Kallweit wrote:
> On 01.07.2019 21:52, Matthias Kaehlcke wrote:
> > By default Spread-Spectrum Clocking (SSC) is disabled on the RTL8211E.
> > Enable it if the device tree property 'realtek,enable-ssc' exists.
> > 
> > Signed-off-by: Matthias Kaehlcke <mka@chromium.org>
> > ---
> >  drivers/net/phy/realtek.c | 27 ++++++++++++++++++++++++---
> >  1 file changed, 24 insertions(+), 3 deletions(-)
> > 
> > diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
> > index dfc2e20ef335..b617169ccc8c 100644
> > --- a/drivers/net/phy/realtek.c
> > +++ b/drivers/net/phy/realtek.c
> > @@ -9,8 +9,10 @@
> >   * Copyright (c) 2004 Freescale Semiconductor, Inc.
> >   */
> >  #include <linux/bitops.h>
> > -#include <linux/phy.h>
> > +#include <linux/device.h>
> > +#include <linux/of.h>
> >  #include <linux/module.h>
> > +#include <linux/phy.h>
> >  
> >  #define RTL821x_PHYSR				0x11
> >  #define RTL821x_PHYSR_DUPLEX			BIT(13)
> > @@ -28,6 +30,8 @@
> >  
> >  #define RTL8211E_EXT_PAGE			7
> >  #define RTL8211E_EPAGSR				0x1e
> > +#define RTL8211E_SCR				0x1a
> > +#define RTL8211E_SCR_DISABLE_RXC_SSC		BIT(2)
> >  
> >  #define RTL8211F_INSR				0x1d
> >  
> > @@ -87,8 +91,8 @@ static int rtl821e_restore_page(struct phy_device *phydev, int oldpage, int ret)
> >  	return ret;
> >  }
> >  
> > -static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
> > -				    int page, u32 regnum, u16 mask, u16 set)
> > +static int rtl8211e_modify_ext_paged(struct phy_device *phydev, int page,
> > +				     u32 regnum, u16 mask, u16 set)
> >  {
> >  	int ret = 0;
> >  	int oldpage;
> > @@ -114,6 +118,22 @@ static int __maybe_unused rtl8211e_modify_ext_paged(struct phy_device *phydev,
> >  	return rtl821e_restore_page(phydev, oldpage, ret);
> >  }
> >  
> > +static int rtl8211e_probe(struct phy_device *phydev)
> > +{
> > +	struct device *dev = &phydev->mdio.dev;
> > +	int err;
> > +
> > +	if (of_property_read_bool(dev->of_node, "realtek,enable-ssc")) {
> > +		err = rtl8211e_modify_ext_paged(phydev, 0xa0, RTL8211E_SCR,
> > +						RTL8211E_SCR_DISABLE_RXC_SSC,
> > +						0);
> > +		if (err)
> > +			dev_err(dev, "failed to enable SSC on RXC: %d\n", err);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> >  static int rtl8201_ack_interrupt(struct phy_device *phydev)
> >  {
> >  	int err;
> > @@ -372,6 +392,7 @@ static struct phy_driver realtek_drvs[] = {
> >  		.config_init	= &rtl8211e_config_init,
> >  		.ack_interrupt	= &rtl821x_ack_interrupt,
> >  		.config_intr	= &rtl8211e_config_intr,
> > +		.probe          = rtl8211e_probe,
> 
> I'm not sure whether this setting survives soft reset and power-down.
> Maybe it should be better applied in the config_init callback.

Sounds reasonable, I'll change it in the next revision, thanks!

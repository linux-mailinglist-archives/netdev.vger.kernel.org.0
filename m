Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DED531A985
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232218AbhBMBmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:42:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhBMBlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:41:55 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12B57C061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:41:15 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id w1so2200919ejf.11
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:41:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ECq8cNnOGzv8MuURl1Qo4O85d3kaHLCHsO115JqWSp8=;
        b=bszA4LBdi3NTwOPelQu2e26FHpX38QUGuxhCf//J3bGBrVs+F5m766eeXqArwgxoTe
         qM6P5tAoJYlmYKZfOrKVgXFdvffbV0RrePo9tZOiKT8w6Gxhq6UeFAQDuJp48oOOZG0Z
         aTYTaxesK8E4BrcjJfqmAMgOmJoXbYSkj1TMtKjGNCZi/Q9WFs/kvBgNjmtRIB8arAj5
         /q8TZ7MtBPJCYgjecUXQ42TavNmbB9kjO0oTNOZORLahpEA0y3GXTrNTEfANOSX30wWS
         d7Tv+MyfBea7EtzOamwdRkDNGEihpA8+Vc1UaSpVwbqTwy4avbNIFR9OT2P2Ngz4qiA6
         kaUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ECq8cNnOGzv8MuURl1Qo4O85d3kaHLCHsO115JqWSp8=;
        b=ls73P6DMJmKk9XYtcPZj6+kYGV/kIZ9fFI7EcljfZlbiQkw6+9WyMim3CBYWXrwjWP
         rh7/oYKCADmebxG+4Q6lCFlgzGk7stYKHih2T9dkMHuhODgCYX5VWFRSLLtSmzR7hmIy
         uliWqUkpiQWot8WsZouYAAVoguiZ1noGZ0va/TxGnlWpoJ4e3nWiTFJ8O1/Dwdp/h69w
         Ee90Ti7gOVie6NbdkhTbkWI8qw5OZIZ5vZHHCQBIbrxxIWSpITeOIWPawU3Q+SoGkoer
         U0OHz2ZvPrCsapPZC+nT2On0BzKKfRBr4GqMOzBVNP+PmzXT4RvbC7L0V4/ANSeqnzlB
         lenA==
X-Gm-Message-State: AOAM530oabNEmfjo29bgVrz/eY9S7T3zTbcQFz1XkunzyoUBa8R0yDWa
        fuKoB/XwBi/KWdzCkcIiaG0=
X-Google-Smtp-Source: ABdhPJyQESkGtxPiQzafvUNpoI3dt3P+Yc4w3nZUnfLUvdnL/mGlMeuCPbnYobp2BSrs/S64zEzAPQ==
X-Received: by 2002:a17:906:8617:: with SMTP id o23mr5621129ejx.289.1613180473691;
        Fri, 12 Feb 2021 17:41:13 -0800 (PST)
Received: from skbuf (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id u20sm6934688ejx.22.2021.02.12.17.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Feb 2021 17:41:13 -0800 (PST)
Date:   Sat, 13 Feb 2021 03:41:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Robert Hancock <robert.hancock@calian.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux@armlinux.org.uk, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] net: phy: broadcom: Do not modify LED
 configuration for SFP module PHYs
Message-ID: <20210213014112.vk5rt5uer2u4l232@skbuf>
References: <20210213002825.2557444-1-robert.hancock@calian.com>
 <20210213002825.2557444-3-robert.hancock@calian.com>
 <f730a14f-0426-f009-87cf-7a4fbe4a3f6e@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f730a14f-0426-f009-87cf-7a4fbe4a3f6e@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 05:17:53PM -0800, Florian Fainelli wrote:
> On 2/12/2021 4:28 PM, 'Robert Hancock' via BCM-KERNEL-FEEDBACK-LIST,PDL
> wrote:
> > bcm54xx_config_init was modifying the PHY LED configuration to enable link
> > and activity indications. However, some SFP modules (such as Bel-Fuse
> > SFP-1GBT-06) have no LEDs but use the LED outputs to control the SFP LOS
> > signal, and modifying the LED settings will cause the LOS output to
> > malfunction. Skip this configuration for PHYs which are bound to an SFP
> > bus.

That would be me, sorry.

> > Signed-off-by: Robert Hancock <robert.hancock@calian.com>
> > ---
> >  drivers/net/phy/broadcom.c | 26 +++++++++++++++++---------
> >  1 file changed, 17 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/net/phy/broadcom.c b/drivers/net/phy/broadcom.c
> > index 78542580f2b2..81a5721f732a 100644
> > --- a/drivers/net/phy/broadcom.c
> > +++ b/drivers/net/phy/broadcom.c
> > @@ -12,6 +12,7 @@
> >  
> >  #include "bcm-phy-lib.h"
> >  #include <linux/module.h>
> > +#include <linux/netdevice.h>
> >  #include <linux/phy.h>
> >  #include <linux/brcmphy.h>
> >  #include <linux/of.h>
> > @@ -365,18 +366,25 @@ static int bcm54xx_config_init(struct phy_device *phydev)
> >  
> >  	bcm54xx_phydsp_config(phydev);
> >  
> > -	/* Encode link speed into LED1 and LED3 pair (green/amber).
> > +	/* For non-SFP setups, encode link speed into LED1 and LED3 pair
> > +	 * (green/amber).
> >  	 * Also flash these two LEDs on activity. This means configuring
> >  	 * them for MULTICOLOR and encoding link/activity into them.
> > +	 * Don't do this for devices that may be on an SFP module, since
> > +	 * some of these use the LED outputs to control the SFP LOS signal,
> > +	 * and changing these settings will cause LOS to malfunction.
> >  	 */
> > -	val = BCM5482_SHD_LEDS1_LED1(BCM_LED_SRC_MULTICOLOR1) |
> > -		BCM5482_SHD_LEDS1_LED3(BCM_LED_SRC_MULTICOLOR1);
> > -	bcm_phy_write_shadow(phydev, BCM5482_SHD_LEDS1, val);
> > -
> > -	val = BCM_LED_MULTICOLOR_IN_PHASE |
> > -		BCM5482_SHD_LEDS1_LED1(BCM_LED_MULTICOLOR_LINK_ACT) |
> > -		BCM5482_SHD_LEDS1_LED3(BCM_LED_MULTICOLOR_LINK_ACT);
> > -	bcm_phy_write_exp(phydev, BCM_EXP_MULTICOLOR, val);
> > +	if (!phydev->sfp_bus &&
> > +	    (!phydev->attached_dev || !phydev->attached_dev->sfp_bus)) {
> > +		val = BCM5482_SHD_LEDS1_LED1(BCM_LED_SRC_MULTICOLOR1) |
> > +			BCM5482_SHD_LEDS1_LED3(BCM_LED_SRC_MULTICOLOR1);
> > +		bcm_phy_write_shadow(phydev, BCM5482_SHD_LEDS1, val);
> > +
> > +		val = BCM_LED_MULTICOLOR_IN_PHASE |
> > +			BCM5482_SHD_LEDS1_LED1(BCM_LED_MULTICOLOR_LINK_ACT) |
> > +			BCM5482_SHD_LEDS1_LED3(BCM_LED_MULTICOLOR_LINK_ACT);
> > +		bcm_phy_write_exp(phydev, BCM_EXP_MULTICOLOR, val);
> 
> Not sure I can come up with a better solution but this should probably
> be made conditional upon the specific SFP module, or a set of specific
> SFP modules, whether we can convey those details via a Device Tree
> property or by doing a SFP ID lookup.
> 
> Acked-by: Florian Fainelli <f.fainelli@gmail.com>

Not sure when is the last time I saw an SFP module with activity/link
LEDs, the patch was intended for a BCM5464R RJ45 twisted pair setup
which I still have.

What is the last thing that happened in PHY LED territory? I lost track
since Marek's RFC for offloading phy_led_triggers that didn't seem to
make any progress. I could try to explicitly request the activity LED to
blink on my board via device tree, if it helps.

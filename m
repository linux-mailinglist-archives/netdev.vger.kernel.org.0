Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 732D61A8B6D
	for <lists+netdev@lfdr.de>; Tue, 14 Apr 2020 21:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505185AbgDNTpu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Apr 2020 15:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2505166AbgDNTph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Apr 2020 15:45:37 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D997C061A0C
        for <netdev@vger.kernel.org>; Tue, 14 Apr 2020 12:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hMfQ+65HG0cJkLQAR6mE83QrTHNuxx43H/oTwNmSl/4=; b=EwMFDQ+39fHzy8f7cgZkRzyB/
        uq7calQayn646UWIUk5N8d/8JO2MHVX2HtPY0PwayjMGQCqlKaGyEUrov/JswoMVvqCrjUlXX36ov
        xqL4Gw/dYr6hKFIrPeRZiCK48qFDlAODAiRnGIHwmrNkqSHc2m1ncO7MbYplLcekp4Z0YSiboGSb1
        yyP2vZ4uE59xgR/+N5Nz4IY7Vc6lnqvs5UDW/Os+/RwVrLgR1AKBwoiG8hlDtmXMxa7hkfJCkFFh6
        KzixzyyEDxxDjdcCYJ6e8PqRmbvIUwAhhQaYj8rpDe/fg/sKONQ1Ds6UoaPA/D2PMV3I5uzUaisiX
        OuCEE0ACA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:45944)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jORUr-0001kN-0z; Tue, 14 Apr 2020 20:45:25 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jORUm-0008OH-Qm; Tue, 14 Apr 2020 20:45:20 +0100
Date:   Tue, 14 Apr 2020 20:45:20 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Matteo Croce <mcroce@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH net 1/2] net: marvell10g: report firmware version
Message-ID: <20200414194520.GA25745@shell.armlinux.org.uk>
References: <20200414182935.GY25745@shell.armlinux.org.uk>
 <E1jOQK7-0001WH-KM@rmk-PC.armlinux.org.uk>
 <20200414184739.GD637127@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200414184739.GD637127@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 14, 2020 at 08:47:39PM +0200, Andrew Lunn wrote:
> On Tue, Apr 14, 2020 at 07:30:15PM +0100, Russell King wrote:
> > Report the firmware version when probing the PHY to allow issues
> > attributable to firmware to be diagnosed.
> > 
> > Tested-by: Matteo Croce <mcroce@redhat.com>
> > Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> > ---
> >  drivers/net/phy/marvell10g.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> > 
> > diff --git a/drivers/net/phy/marvell10g.c b/drivers/net/phy/marvell10g.c
> > index 7621badae64d..ee60417cdc55 100644
> > --- a/drivers/net/phy/marvell10g.c
> > +++ b/drivers/net/phy/marvell10g.c
> > @@ -33,6 +33,8 @@
> >  #define MV_PHY_ALASKA_NBT_QUIRK_REV	(MARVELL_PHY_ID_88X3310 | 0xa)
> >  
> >  enum {
> > +	MV_PMA_FW_VER0		= 0xc011,
> > +	MV_PMA_FW_VER1		= 0xc012,
> >  	MV_PMA_BOOT		= 0xc050,
> >  	MV_PMA_BOOT_FATAL	= BIT(0),
> >  
> > @@ -83,6 +85,8 @@ enum {
> >  };
> >  
> >  struct mv3310_priv {
> > +	u32 firmware_ver;
> > +
> >  	struct device *hwmon_dev;
> >  	char *hwmon_name;
> >  };
> > @@ -355,6 +359,23 @@ static int mv3310_probe(struct phy_device *phydev)
> >  
> >  	dev_set_drvdata(&phydev->mdio.dev, priv);
> >  
> > +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_VER0);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	priv->firmware_ver = ret << 16;
> > +
> > +	ret = phy_read_mmd(phydev, MDIO_MMD_PMAPMD, MV_PMA_FW_VER1);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	priv->firmware_ver |= ret;
> > +
> > +	dev_info(&phydev->mdio.dev,
> > +		 "Firmware version %u.%u.%u.%u\n",
> > +		 priv->firmware_ver >> 24, (priv->firmware_ver >> 16) & 255,
> > +		 (priv->firmware_ver >> 8) & 255, priv->firmware_ver & 255);
> > +
> 
> Hi Russell
> 
> Did you consider using phydev_info()? Or is it too early, and you
> don't get a sensible name?

No, I keep forgetting those exist!  I'll resend shortly.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

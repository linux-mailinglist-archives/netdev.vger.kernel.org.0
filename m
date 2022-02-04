Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BEF24A97FD
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 11:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231540AbiBDKlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 05:41:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230164AbiBDKlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 05:41:45 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D15C061714;
        Fri,  4 Feb 2022 02:41:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=W/3Zop7fcjbnYlLDhu0A1kp5UG7w3uKfNlREyLJEBgE=; b=sq0D6yrOOezn8lXGC2iCe6WUEA
        NOjLuX8c1BUlxx9KS/oW4HVWevur0jpCHwpOi4XXxDIkgEpmeNfuBaHc87RevZv9D4s5jsvWWMuF3
        u5yUVFx9sV1SoGL8XvVblfTxFVb2uNAfOGvt1SZZOYrYkXK7jBYffGdIG529+wLgMT0NmD4QMy5lx
        21teQ+7AqtUV7gMHIAkLqItVJSoDS4oVFexdSlsexoeZ5X1YmLU191GA4nb6q9SCOMWCzFxTDj6JA
        RCt4C39rVZnlhW5hwz024nyDL42S+XOUWHP81kkHUhznur11JGYpwwWFIMXIJ1PFbo+D0nZ5BaYb+
        kYOOyckQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57034)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nFw28-0004Mm-Iz; Fri, 04 Feb 2022 10:41:40 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nFw25-0004uh-8b; Fri, 04 Feb 2022 10:41:37 +0000
Date:   Fri, 4 Feb 2022 10:41:37 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc:     =?utf-8?B?0J/QsNGA0YXQvtC80LXQvdC60L4g0J/QsNCy0LXQuyDQmtC40YDQuNC70Ls=?=
         =?utf-8?B?0L7QstC40Yc=?= <Pavel.Parkhomenko@baikalelectronics.ru>,
        "michael@stapelberg.de" <michael@stapelberg.de>,
        "afleming@gmail.com" <afleming@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        =?utf-8?B?0JzQsNC70LDRhdC+0LIg0JDQu9C10LrRgdC10Lkg0JLQsNC70LXRgNGM0LU=?=
         =?utf-8?B?0LLQuNGH?= <Alexey.Malahov@baikalelectronics.ru>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Serge Semin <fancer.lancer@gmail.com>
Subject: Re: [PATCH] net: phy: marvell: Fix RGMII Tx/Rx delays setting in
 88e1121-compatible PHYs
Message-ID: <Yf0C4WYxbzFcMO/N@shell.armlinux.org.uk>
References: <96759fee7240fd095cb9cc1f6eaf2d9113b57cf0.camel@baikalelectronics.ru>
 <20220204095621.bcchrzupmtor3jbq@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220204095621.bcchrzupmtor3jbq@mobilestation>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 12:56:21PM +0300, Serge Semin wrote:
> +Cc: Heiner, Russel, David, Jakub
> 
> -Sergey
> 
> On Fri, Feb 04, 2022 at 08:29:11AM +0300, Пархоменко Павел Кириллович wrote:
> > It is mandatory for a software to issue a reset upon modifying RGMII
> > Receive Timing Control and RGMII Transmit Timing Control bit fields of MAC
> > Specific Control register 2 (page 2, register 21) otherwise the changes
> > won't be perceived by the PHY (the same is applicable for a lot of other
> > registers). Not setting the RGMII delays on the platforms that imply
> > it's being done on the PHY side will consequently cause the traffic loss.
> > We discovered that the denoted soft-reset is missing in the
> > m88e1121_config_aneg() method for the case if the RGMII delays are
> > modified but the MDIx polarity isn't changed or the auto-negotiation is
> > left enabled, thus causing the traffic loss on our platform with Marvell
> > Alaska 88E1510 installed. Let's fix that by issuing the soft-reset if the
> > delays have been actually set in the m88e1121_config_aneg_rgmii_delays()
> > method.

Thanks. Indeed, this appears to be correct for the 88E151x PHYs.

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

> > Fixes: d6ab93364734 ("net: phy: marvell: Avoid unnecessary soft reset")
> > Signed-off-by: Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
> > Reviewed-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > Cc: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
> > Cc: Serge Semin <Sergey.Semin@baikalelectronics.ru>
> > Cc: netdev@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > 
> > ---
> >  drivers/net/phy/marvell.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
> > index 4fcfca4e1702..a4f685927a64 100644
> > --- a/drivers/net/phy/marvell.c
> > +++ b/drivers/net/phy/marvell.c
> > @@ -551,9 +551,9 @@ static int m88e1121_config_aneg_rgmii_delays(struct
> > phy_device *phydev)
> >  	else
> >  		mscr = 0;
> >  
> > -	return phy_modify_paged(phydev, MII_MARVELL_MSCR_PAGE,
> > -				MII_88E1121_PHY_MSCR_REG,
> > -				MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
> > +	return phy_modify_paged_changed(phydev, MII_MARVELL_MSCR_PAGE,
> > +					MII_88E1121_PHY_MSCR_REG,
> > +					MII_88E1121_PHY_MSCR_DELAY_MASK, mscr);
> >  }
> >  
> >  static int m88e1121_config_aneg(struct phy_device *phydev)
> > @@ -567,11 +567,13 @@ static int m88e1121_config_aneg(struct phy_device *phydev)
> >  			return err;
> >  	}
> >  
> > +	changed = err;
> > +
> >  	err = marvell_set_polarity(phydev, phydev->mdix_ctrl);
> >  	if (err < 0)
> >  		return err;
> >  
> > -	changed = err;
> > +	changed |= err;
> >  
> >  	err = genphy_config_aneg(phydev);
> >  	if (err < 0)
> > -- 
> > 2.34.1
> > 
> > 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

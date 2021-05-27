Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1C439323F
	for <lists+netdev@lfdr.de>; Thu, 27 May 2021 17:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbhE0PSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 11:18:35 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60308 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234529AbhE0PSd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 11:18:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=sZh68NYV4i6lfMX9rlhUQviE4A3XNjX+lXwtGbnB1bk=; b=ePkEbAEF5tTyzKvVVLSiRUHUfP
        seI0mnFHZ04IjBbJD/eqtdm7mziyjO4Vp4G0rgoiERCjwI4XGnt5HMQDsG8ZIhec2SMI+A3tyL3Wa
        7uaXRpFDVo0N7GOMiSYqbEZDzYPEccywrFmwjm402P0qSsoBt62ewp9aM98gcLPelwSg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lmHkf-006ZL4-6P; Thu, 27 May 2021 17:16:49 +0200
Date:   Thu, 27 May 2021 17:16:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: Re: [PATCH net-next v3 1/9] net: phy: micrel: move phy reg offsets
 to common header
Message-ID: <YK+34eadXNOR4f1D@lunn.ch>
References: <20210526043037.9830-1-o.rempel@pengutronix.de>
 <20210526043037.9830-2-o.rempel@pengutronix.de>
 <20210526220132.stfahc4mrwfiu6yn@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526220132.stfahc4mrwfiu6yn@skbuf>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >  	switch (reg) {
> > -	case PHY_REG_CTRL:
> > +	case MII_BMCR:
> >  		ksz_pread8(dev, p, regs[P_NEG_RESTART_CTRL], &restart);
> >  		ksz_pread8(dev, p, regs[P_SPEED_STATUS], &speed);
> >  		ksz_pread8(dev, p, regs[P_FORCE_CTRL], &ctrl);
> >  		if (restart & PORT_PHY_LOOPBACK)
> > -			data |= PHY_LOOPBACK;
> > +			data |= BMCR_LOOPBACK;
> >  		if (ctrl & PORT_FORCE_100_MBIT)
> > -			data |= PHY_SPEED_100MBIT;
> > +			data |= BMCR_SPEED100;
> >  		if (ksz_is_ksz88x3(dev)) {
> >  			if ((ctrl & PORT_AUTO_NEG_ENABLE))
> > -				data |= PHY_AUTO_NEG_ENABLE;
> > +				data |= BMCR_ANENABLE;
> >  		} else {
> >  			if (!(ctrl & PORT_AUTO_NEG_DISABLE))
> > -				data |= PHY_AUTO_NEG_ENABLE;
> > +				data |= BMCR_ANENABLE;
> >  		}
> >  		if (restart & PORT_POWER_DOWN)
> > -			data |= PHY_POWER_DOWN;
> > +			data |= BMCR_PDOWN;
> >  		if (restart & PORT_AUTO_NEG_RESTART)
> > -			data |= PHY_AUTO_NEG_RESTART;
> > +			data |= BMCR_ANRESTART;
> >  		if (ctrl & PORT_FORCE_FULL_DUPLEX)
> > -			data |= PHY_FULL_DUPLEX;
> > +			data |= BMCR_FULLDPLX;
> >  		if (speed & PORT_HP_MDIX)
> > -			data |= PHY_HP_MDIX;
> > +			data |= KSZ886X_BMCR_HP_MDIX;
> >  		if (restart & PORT_FORCE_MDIX)
> > -			data |= PHY_FORCE_MDIX;
> > +			data |= KSZ886X_BMCR_FORCE_MDI;
> >  		if (restart & PORT_AUTO_MDIX_DISABLE)
> > -			data |= PHY_AUTO_MDIX_DISABLE;
> > +			data |= KSZ886X_BMCR_DISABLE_AUTO_MDIX;
> >  		if (restart & PORT_TX_DISABLE)
> > -			data |= PHY_TRANSMIT_DISABLE;
> > +			data |= KSZ886X_BMCR_DISABLE_TRANSMIT;
> >  		if (restart & PORT_LED_OFF)
> > -			data |= PHY_LED_DISABLE;
> > +			data |= KSZ886X_BMCR_DISABLE_LED;
> >  		break;
> 
> I am deeply confused as to what this function is doing. It is reading
> the 8-bit port registers P_NEG_RESTART_CTRL, P_SPEED_STATUS and
> P_FORCE_CTRL and stitching them into a 16-bit "MII_BMCR"?

Sort of. Take a look at the datasheet for the ksz8841. It has clause
22 like registers which it exports to a PHY driver. It puts MDIX
control into the bottom of the BMCR. So this DSA driver is emulating
the ksz8841 so it can share the PHY driver.

    Andrew

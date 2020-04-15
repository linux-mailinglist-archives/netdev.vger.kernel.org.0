Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388D91AA998
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 16:17:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2636518AbgDOOOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 10:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S2636464AbgDOOOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 10:14:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC2AC061A0C;
        Wed, 15 Apr 2020 07:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=YURTFPGYV0Ly4WKCLsMF0KOG1vWwxeFQv/uUYMR94y4=; b=z3GOZAzVS5DSb1a/YuqiBT3qL
        QhZl7ofjYL5bMIk6ly3q/tOqk4d507QJpheRGwa+5PU3XOJJM+1q+Hs5FYKDtH3zGZ7/4XUGo8DcQ
        w1/zC/ygQia/7DRi2bnp1fppMHemT5yKMIJwvpUEQ3qfzyjGC3OAPK/vmbOoB0mVo3zEjNe6fFPNT
        HB5y9qY28e8E3KaNU1s8Mh8ydYg0XTK3g5xStQTscOMTQwlTBSYEpH8HcjJUTbS3XAQhkPdi/4hj2
        dZhbfhpVSQbwnpSx+h362+Zp9ikcPQrTaTm+jHySuZZlndnmMQyjo9dnrEei6SkuFL16l8r8iiaNH
        oNBDyhkZw==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:46300)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jOioD-0006t0-Jx; Wed, 15 Apr 2020 15:14:33 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jOio7-0000yv-Kt; Wed, 15 Apr 2020 15:14:27 +0100
Date:   Wed, 15 Apr 2020 15:14:27 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        David Jander <david@protonic.nl>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v1] ethtool: provide UAPI for PHY master/slave
 configuration.
Message-ID: <20200415141427.GD25745@shell.armlinux.org.uk>
References: <20200415121209.12197-1-o.rempel@pengutronix.de>
 <20200415121940.2du33zckvayfqjrb@pengutronix.de>
 <20200415124343.GZ3141@unicorn.suse.cz>
 <20200415130034.7zbizr4x4vnxto6a@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200415130034.7zbizr4x4vnxto6a@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 15, 2020 at 03:00:34PM +0200, Oleksij Rempel wrote:
> On Wed, Apr 15, 2020 at 02:43:43PM +0200, Michal Kubecek wrote:
> > On Wed, Apr 15, 2020 at 02:19:40PM +0200, Oleksij Rempel wrote:
> > > Cc: Marek Vasut <marex@denx.de>
> > > 
> > > On Wed, Apr 15, 2020 at 02:12:09PM +0200, Oleksij Rempel wrote:
> > > > This UAPI is needed for BroadR-Reach 100BASE-T1 devices. Due to lack of
> > > > auto-negotiation support, we needed to be able to configure the
> > > > MASTER-SLAVE role of the port manually or from an application in user
> > > > space.
> > > > 
> > > > The same UAPI can be used for 1000BASE-T or MultiGBASE-T devices to
> > > > force MASTER or SLAVE role. See IEEE 802.3-2018:
> > > > 22.2.4.3.7 MASTER-SLAVE control register (Register 9)
> > > > 22.2.4.3.8 MASTER-SLAVE status register (Register 10)
> > > > 40.5.2 MASTER-SLAVE configuration resolution
> > > > 45.2.1.185.1 MASTER-SLAVE config value (1.2100.14)
> > > > 45.2.7.10 MultiGBASE-T AN control 1 register (Register 7.32)
> > > > 
> > > > The MASTER-SLAVE role affects the clock configuration:
> > > > 
> > > > -------------------------------------------------------------------------------
> > > > When the  PHY is configured as MASTER, the PMA Transmit function shall
> > > > source TX_TCLK from a local clock source. When configured as SLAVE, the
> > > > PMA Transmit function shall source TX_TCLK from the clock recovered from
> > > > data stream provided by MASTER.
> > > > 
> > > > iMX6Q                     KSZ9031                XXX
> > > > ------\                /-----------\        /------------\
> > > >       |                |           |        |            |
> > > >  MAC  |<----RGMII----->| PHY Slave |<------>| PHY Master |
> > > >       |<--- 125 MHz ---+-<------/  |        | \          |
> > > > ------/                \-----------/        \------------/
> > > >                                                ^
> > > >                                                 \-TX_TCLK
> > > > 
> > > > -------------------------------------------------------------------------------
> > > > 
> > > > Since some clock or link related issues are only reproducible in a
> > > > specific MASTER-SLAVE-role, MAC and PHY configuration, it is beneficial
> > > > to provide generic (not 100BASE-T1 specific) interface to the user space
> > > > for configuration flexibility and trouble shooting.
> > > > 
> > > > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> > > > ---
> > [...]
> > > > +/* Port mode */
> > > > +#define PORT_MODE_MASTER	0x00
> > > > +#define PORT_MODE_SLAVE		0x01
> > > > +#define PORT_MODE_MASTER_FORCE	0x02
> > > > +#define PORT_MODE_SLAVE_FORCE	0x03
> > > > +#define PORT_MODE_UNKNOWN	0xff
> > 
> > Shouldn't 0 rather be something like PORT_MODE_UNSUPPORTED or
> > PORT_MODE_NONE? If I see correctly, all drivers not setting the new
> > field (which would be all drivers right now and almost all later) will
> > leave the value at 0 which would be interpreted as PORT_MODE_MASTER.
> 
> Yes, you right. I was thinking about it and decided to follow the duplex
> code pattern. Will fix in the next version.

Wouldn't that make PORT_MODE_UNKNOWN unnecessary?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6BEF52F3D58
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:44:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438161AbhALVh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 16:37:59 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:36606 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437075AbhALU4i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 15:56:38 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kzQho-000EK9-OF; Tue, 12 Jan 2021 21:55:56 +0100
Date:   Tue, 12 Jan 2021 21:55:56 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Russell King <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        pali@kernel.org
Subject: Re: [PATCH net-next v4 1/4] net: phy: mdio-i2c: support I2C MDIO
 protocol for RollBall SFP modules
Message-ID: <X/4M3CJ4xU381ozH@lunn.ch>
References: <20210111050044.22002-1-kabel@kernel.org>
 <20210111050044.22002-2-kabel@kernel.org>
 <X/4J8cB1ITZmesN5@lunn.ch>
 <20210112215313.2b2f5523@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210112215313.2b2f5523@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static int i2c_mii_read_rollball(struct mii_bus *bus, int phy_id, int reg)
> > > +{
> > > +	u8 buf[4], res[6];
> > > +	int bus_addr, ret;
> > > +	u16 val;
> > > +
> > > +	if (!(reg & MII_ADDR_C45))
> > > +		return -EOPNOTSUPP;
> > > +
> > > +	bus_addr = i2c_mii_phy_addr(phy_id);
> > > +	if (bus_addr != ROLLBALL_PHY_I2C_ADDR)
> > > +		return 0xffff;
> > > +
> > > +	buf[0] = ROLLBALL_DATA_ADDR;
> > > +	buf[1] = (reg >> 16) & 0x1f;
> > > +	buf[2] = (reg >> 8) & 0xff;
> > > +	buf[3] = reg & 0xff;  
> > 
> > This looks odd. There are only 32 registers for C22 transactions, so
> > it fits in one byte. You can set buf[1] and buf[2] to zero.
> 
> C22 is not supported by this protocol.

Duh!

Sorry for the noise.

      Andrew

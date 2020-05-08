Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85A5C1CB8EF
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 22:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgEHU1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 16:27:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49908 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726811AbgEHU1g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 May 2020 16:27:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=99PO3vaZTM46qvS0LR8bXv5m1BEVlIFvFmNNPuHSrcU=; b=W5D2scAPXtxzyvIYaVnSFKVXeL
        ZqkHeN4Ll77OUV9rI72SL8SPBFaWhVarfaXMhS/ggsB1zhom6zD9coCA0B5vJ6qy2LhJH2ZHGvFAV
        h0NldpoKACJnE+1za8zyt18VTFJZO3SPLta76FPexc3DJhgMMy2idyfNfkFugBkt8QKE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jX9ac-001Pvw-Kd; Fri, 08 May 2020 22:27:22 +0200
Date:   Fri, 8 May 2020 22:27:22 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     Calvin Johnson <calvin.johnson@oss.nxp.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        linux.cj@gmail.com, Florian Fainelli <f.fainelli@gmail.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Florin Laurentiu Chiculita <florinlaurentiu.chiculita@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Varun Sethi <V.Sethi@nxp.com>,
        "Rajesh V . Bikkina" <rajesh.bikkina@nxp.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Diana Madalina Craciun <diana.craciun@nxp.com>,
        netdev <netdev@vger.kernel.org>, Marcin Wojtas <mw@semihalf.com>,
        Laurentiu Tudor <laurentiu.tudor@nxp.com>,
        Makarand Pawagi <makarand.pawagi@nxp.com>,
        linux-arm Mailing List <linux-arm-kernel@lists.infradead.org>,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [net-next PATCH v3 4/5] net: phy: Introduce fwnode_get_phy_id()
Message-ID: <20200508202722.GI298574@lunn.ch>
References: <20200505132905.10276-1-calvin.johnson@oss.nxp.com>
 <20200505132905.10276-5-calvin.johnson@oss.nxp.com>
 <67e263cf-5cd7-98d1-56ff-ebd9ac2265b6@arm.com>
 <CAHp75Vew8Fh6HEoOACk+J9KCpw+AE2t2+oFnXteK1eShopfYAA@mail.gmail.com>
 <83ab4ca4-9c34-4cdd-4413-3b4cdf96727d@arm.com>
 <20200508160755.GB10296@lsv03152.swis.in-blr01.nxp.com>
 <20200508181301.GF298574@lunn.ch>
 <1e33605e-42fd-baf8-7584-e8fcd5ca6fd3@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1e33605e-42fd-baf8-7584-e8fcd5ca6fd3@arm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > There is a very small number of devices where the vendor messed up,
> > and did not put valid contents in the ID registers. In such cases, we
> > can read the IDs from device tree. These are then used in exactly the
> > same way as if they were read from the device.
> > 
> 
> Is that the case here?

Sorry, I don't understand the question?

> Also, how much of this was caused by uboot being deficient

None. It is a silicon issue. The PHY chip simply has the wrong or no
ID value in the registers.

> > Not exactly true. It is the combination of can the bus master do C45
> > and can the device do C45. Unfortunately, we have no knowledge of the
> > bus masters capabilities, if it can do C45. And many MDIO drivers will
> > do a C22 transaction when asked to perform a C45 transaction. All new
> > submissions for MDIO drivers i ask for EOPNOTSUPP to be returned if
> > C45 is not supported. But we cannot rely on that. Too much history >
> > > 
> > > I tend to agree with you on this. Even for DT, ideal case, IMO should be:
> > > 
> > > 1) mdiobus_scan scans the mdiobus for c22 devices by reading phy id from
> > > registers 2 and 3
> > > 2) if not found scan for c45 devices <= looks like this is missing in Linux
> > > 3) look for phy_id from compatible string.
> > 
> > It is somewhat more complex, in that there are a small number of
> > devices which will respond to both C22 and C45. Generally, you want to
> > use C45 if supported. So you would want to do the C45 scan first. But
> > then the earlier problem comes to play, you have no idea if the bus
> > master actually correctly supports C45.
> 
> But this shouldn't this be implied by the mdio vendor/model?

Nope. Many MDIO bus masters don't even appear in DT, because they are
embedded into the MAC driver. The MAC driver just instantiates an MDIO
device, maybe passing a pointer where to find the PHY properties in
DT. If the MDIO bus master is in its own address range, then it
probably does exist in device tree, and has a compatible string. But
that just gets the driver loaded, it says nothing about what it is
capable of, C22 and or C45. And there are cases where the MDIO bus is
embedded inside an Ethernet switch, which is hanging off another MDIO
bus, etc.

> How much of this can be simplified for ACPI buy ignoring the legacy and
> putting some guides around the ACPI/platform requirements?

You can probably ignore the phy-idXXXX.YYYY compatible, since that is
working around silicon issues, and put in place some guidelines that
the PHY silicon needs to conform to the basics of C22 and C45 in terms
of ID registers.

C45 you are going to need. ACPI tends to be more high end devices,
which in general have higher speed network interfaces. Multi-Gige PHYs
tend to be C45. But there is also interest in using ACPI on 1G PHYs
where the majority is C22.

      Andrew

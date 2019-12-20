Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 850D01278C7
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 11:06:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727329AbfLTKG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 05:06:27 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:34806 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727129AbfLTKG1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 05:06:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=as6IYqvOwKnH4gVYbLvmr3OksXVTViVqoOiYR3nLmvE=; b=hmNDsrcTVknj3kMDP0UCFSAoV+
        RFtmlaTTJJyTlSca604hHzHP+cBr5N4IQTWVE5VjvvBXIPVBYFpkII9IXVYOTebr0QOc78mERvWrG
        8G/245hWZbp5c46AKG/RmKY+UNcs8jOcRIcGXCeNTPonUMZF/4ovd119+IbDc3J9Xv94=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iiFAn-0007He-MV; Fri, 20 Dec 2019 11:06:17 +0100
Date:   Fri, 20 Dec 2019 11:06:17 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        "antoine.tenart@free-electrons.com" 
        <antoine.tenart@free-electrons.com>,
        "jaz@semihalf.com" <jaz@semihalf.com>,
        "baruch@tkos.co.il" <baruch@tkos.co.il>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
Message-ID: <20191220100617.GE24174@lunn.ch>
References: <1576768881-24971-2-git-send-email-madalin.bucur@oss.nxp.com>
 <20191219172834.GC25745@shell.armlinux.org.uk>
 <VI1PR04MB5567FA3170CF45F877870E8CEC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219190308.GE25745@shell.armlinux.org.uk>
 <VI1PR04MB5567010C06EB9A4734431106EC520@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191219214930.GG25745@shell.armlinux.org.uk>
 <VI1PR04MB556768668EEEDFD61B7AA518EC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
 <20191220091642.GJ25745@shell.armlinux.org.uk>
 <20191220092900.GB24174@lunn.ch>
 <VI1PR04MB55679B12D4E7C9EC05FE0D9AEC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB55679B12D4E7C9EC05FE0D9AEC2D0@VI1PR04MB5567.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 09:39:08AM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: Andrew Lunn <andrew@lunn.ch>
> > Sent: Friday, December 20, 2019 11:29 AM
> > To: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > Cc: Madalin Bucur (OSS) <madalin.bucur@oss.nxp.com>; antoine.tenart@free-
> > electrons.com; jaz@semihalf.com; baruch@tkos.co.il; davem@davemloft.net;
> > netdev@vger.kernel.org; f.fainelli@gmail.com; hkallweit1@gmail.com;
> > shawnguo@kernel.org; devicetree@vger.kernel.org
> > Subject: Re: [PATCH 1/6] net: phy: add interface modes for XFI, SFI
> > 
> > > How does this help us when we can't simply change the existing usage?
> > > We can update the DT but we can't free up the usage of "10gbase-kr".
> > 
> > Agreed. Code needs to keep on interpreting "10gbase-kr" as any 10G
> > link. If we ever have a true 10gbase-kr, 802.3ap, one meter of copper
> > and two connectors, we are going to have to add a new mode to
> > represent true 10gbase-kr.
> > 
> > 	Andrew
> 
> Hi, actually we do have that. What would be the name of the new mode
> representing true 10GBase-KR that we will need to add when we upstream
> support for that?

Ah!

This is going to be messy.

Do you really need to differentiate? What seems to make 802.3ap
different is the FEC, autoneg and link training. Does you hardware
support this? Do you need to know you are supposed to be using 802.3ap
in order to configure these features?

What are we going to report to user space? 10gbase-kr, or
10gbase-kr-true? How do we handle the mess this makes with firmware
based cards which correctly report
ETHTOOL_LINK_MODE_10000baseKR_Full_BIT to user space?

What do we currently report to user space? Is it possible for us to
split DT from user space? DT says 10gbase-kr-true but to user space we
say ETHTOOL_LINK_MODE_10000baseKR_Full_BIT?

I think in order to work through these issues, somebody probably needs
the hardware, and the desire to see it working. So it might actually
be you who makes a proposal how we sort this out, with help from
Russell and I.

	Andrew

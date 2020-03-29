Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 306D8196BFD
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 11:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgC2JCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 05:02:02 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:34368 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727504AbgC2JCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 05:02:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=H5gHcZt58ItxyBwqaqxZtntJGLmB68FixgDVNtg8rCs=; b=07E0C60Qj23SXfi8N3GXmOZby
        1Hyu8JB6hjpqjVbF5nzJMATZNq7dhhOrute0Hyn00mXx80gRd3XdzNmtNIB7nMSCmCpqz/nl08AKK
        k1ebxfRQ6/3jvcJ8JxSft+oWkYRLzN+rYGQSWCgltsgB5q00nYWgXMBVfU/01oeqtBL0/X2uY3nhQ
        JnhwCkHDAK8MiExjdHJYTM3b6Axw22rJUXByf/MjgCz8FrU0I4zTKHPujP4vBVO717XpEHcoxQ0CS
        1NQdgGPYuNbi/nYU5+y4A7xknuGQUU48hKfDeJcl5SMYOTxLyOHU1dWcoSIlUAF9W4fyPRR5IXt6x
        rG5MBnaKA==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:38708)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jITpB-0003yK-JF; Sun, 29 Mar 2020 10:01:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jITp6-000650-KD; Sun, 29 Mar 2020 10:01:40 +0100
Date:   Sun, 29 Mar 2020 10:01:40 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 3/9] net: phy: add kr phy connection
 type
Message-ID: <20200329090140.GW25745@shell.armlinux.org.uk>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
 <1585230682-24417-4-git-send-email-florinel.iordache@nxp.com>
 <20200327001515.GL3819@lunn.ch>
 <AM0PR04MB54435F251B435789A435A0BBFBCA0@AM0PR04MB5443.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB54435F251B435789A435A0BBFBCA0@AM0PR04MB5443.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 29, 2020 at 08:22:10AM +0000, Florinel Iordache wrote:
> > On Thu, Mar 26, 2020 at 03:51:16PM +0200, Florinel Iordache wrote:
> > > Add support for backplane kr phy connection types currently available
> > > (10gbase-kr, 40gbase-kr4) and the required phylink updates (cover all
> > > the cases for KR modes which are clause 45 compatible to correctly
> > > assign phy_interface and phylink#supported)
> > >
> > > Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> > > ---
> > >  drivers/net/phy/phylink.c | 15 ++++++++++++---
> > >  include/linux/phy.h       |  6 +++++-
> > >  2 files changed, 17 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > > index fed0c59..db1bb87 100644
> > > --- a/drivers/net/phy/phylink.c
> > > +++ b/drivers/net/phy/phylink.c
> > > @@ -4,6 +4,7 @@
> > >   * technologies such as SFP cages where the PHY is hot-pluggable.
> > >   *
> > >   * Copyright (C) 2015 Russell King
> > > + * Copyright 2020 NXP
> > >   */
> > >  #include <linux/ethtool.h>
> > >  #include <linux/export.h>
> > > @@ -303,7 +304,6 @@ static int phylink_parse_mode(struct phylink *pl, struct
> > fwnode_handle *fwnode)
> > >                       break;
> > >
> > >               case PHY_INTERFACE_MODE_USXGMII:
> > > -             case PHY_INTERFACE_MODE_10GKR:
> > 
> > We might have a backwards compatibility issue here. If i remember correctly,
> > there are some boards out in the wild using PHY_INTERFACE_MODE_10GKR not
> > PHY_INTERFACE_MODE_10GBASER.
> > 
> > See e0f909bc3a242296da9ccff78277f26d4883a79d
> > 
> > Russell, what do you say about this?
> > 
> >          Andrew
> 
> Ethernet interface nomenclature is using the following terminology:
> e.g. 10GBase-KR: data rate (10G),  modulation type (Base = Baseband),
> medium type (K = BacKplane), physical layer encoding scheme
> (R = scRambling/descRambling using 64b/66b encoding that allows for
> Ethernet framing at a rate of 10.3125 Gbit/s)
> So 10GBase-R name provide information only about the data rate and
> the encoding scheme without specifying the interface medium.
> 10GBase-R is a family of many different standards specified for
> several different physical medium for copper and optical fiber like
> for example:
> 	10GBase-SR: Short range (over fiber)
> 	10GBase-LR: Long reach (over fiber)
> 	10GBase-LRM: Long reach multi-mode (over fiber)
> 	10GBase-ER: Extended reach (over fiber)
> 	10GBase-CR: 10G over copper
> 	10GBase-KR: Backplane
> 
> 10GBase-KR represents Ethernet operation over electrical backplanes on
> single lane and uses the same physical layer encoding as 10GBase-LR/ER/SR
> defined in IEEE802.3 Clause 49. 

I'm not sure why NXP folk think that they have to keep explaining this
to us.  You do not.

> So prior to my change, phy_interface_t provided both enumerators which is correct:
> 	PHY_INTERFACE_MODE_10GBASER
> 	PHY_INTERFACE_MODE_10GKR
> Perhaps PHY_INTERFACE_MODE_10GKR was not used before because Backplane
> support was not available and all 10GBase-R family of interfaces should
> be using PHY_INTERFACE_MODE_10GBASER.

What you are missing is that PHY_INTERFACE_MODE_10GKR was introduced
first and used _incorrectly_.  We are currently mid-transition to
correct that mistake.

While we are in transition, PHY_INTERFACE_MODE_10GKR can _not_ be used
correctly, and nothing NXP or anyone else says will change that fact
until the transition has been completed.

In kernel land, we do not intentionally regress platforms, even if we
have made a mistake.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

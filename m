Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86ACA1B8598
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 12:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726116AbgDYKWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 06:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726060AbgDYKWr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 06:22:47 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52192C09B04A;
        Sat, 25 Apr 2020 03:22:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=s3Na2WaeJN8ZP3a01wZ11T3dQK6+5+kSc6FYnwxfMlw=; b=b00YjM0PN+/RhAE0WZkI/1LmA
        ZyzyNpedSXiqGaE3h7ko+59RAAstbBqwojqfBIXPQYxAYGXUEeHXO+2OEXrpUZifK+WS6F1er7msd
        +HV2lklHHOlIu8/oQb+RRMCY/yGTmjqeRI1wfbBTXxpxptNw1RNUxgDoDWD5mbEggAhIEH6GUpAUR
        K3/U83+XTS0sIcKwKlnb9W9XX8ELZQwOB9n0LckgPCuzZvmtOAkNRxGgxrLMu4u3bIP46Q23SW0s4
        xooxJCs66TZ40PlWhWchzrgkJSJZlQ77uD1XnxKVkvpdtSfaYaoPkd8R4DK/eRG0wVPnkGoZfDUdk
        jFe/lK5uQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:43510)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jSHx8-00021Y-Ko; Sat, 25 Apr 2020 11:22:30 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jSHx0-0004Wk-SS; Sat, 25 Apr 2020 11:22:22 +0100
Date:   Sat, 25 Apr 2020 11:22:22 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florinel Iordache <florinel.iordache@nxp.com>, davem@davemloft.net,
        netdev@vger.kernel.org, f.fainelli@gmail.com, hkallweit1@gmail.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 3/9] net: phy: add kr phy connection type
Message-ID: <20200425102222.GV25745@shell.armlinux.org.uk>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
 <1587732391-3374-4-git-send-email-florinel.iordache@nxp.com>
 <20200424134236.GB1087366@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200424134236.GB1087366@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 03:42:36PM +0200, Andrew Lunn wrote:
> On Fri, Apr 24, 2020 at 03:46:25PM +0300, Florinel Iordache wrote:
> > Add support for backplane kr phy connection types currently available
> > (10gbase-kr, 40gbase-kr4) and the required phylink updates (cover all
> > the cases for KR modes which are clause 45 compatible to correctly assign
> > phy_interface and phylink#supported)
> > 
> > Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> > ---
> >  drivers/net/phy/phylink.c | 15 ++++++++++++---
> >  include/linux/phy.h       |  6 +++++-
> >  2 files changed, 17 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/net/phy/phylink.c b/drivers/net/phy/phylink.c
> > index 34ca12a..9a31f68 100644
> > --- a/drivers/net/phy/phylink.c
> > +++ b/drivers/net/phy/phylink.c
> > @@ -4,6 +4,7 @@
> >   * technologies such as SFP cages where the PHY is hot-pluggable.
> >   *
> >   * Copyright (C) 2015 Russell King
> > + * Copyright 2020 NXP
> >   */
> >  #include <linux/ethtool.h>
> >  #include <linux/export.h>
> > @@ -304,7 +305,6 @@ static int phylink_parse_mode(struct phylink *pl, struct fwnode_handle *fwnode)
> >  			break;
> >  
> >  		case PHY_INTERFACE_MODE_USXGMII:
> > -		case PHY_INTERFACE_MODE_10GKR:
> >  		case PHY_INTERFACE_MODE_10GBASER:
> >  			phylink_set(pl->supported, 10baseT_Half);
> >  			phylink_set(pl->supported, 10baseT_Full);
> 
> Hi Florinel
> 
> What about the issues pointed out in:
> 
> https://www.spinics.net/lists/netdev/msg641046.html

Having reviewed the situation, it seems that I added a translation
to mvpp2 driver for this, translating PHY_INTERFACE_MODE_10GKR to
PHY_INTERFACE_MODE_10GBASER, so anything using "10gbase-kr" in
arch/arm64/boot/dts/marvell/ is not a worry - however, those DT files
still need to be updated but my request to bootlin for help with
that has gone unanswered to date.  So, I'm tempted to change them
wholesale, since that's what we're doing in the mvpp2 driver anyway.

> > @@ -107,8 +108,9 @@
> >  	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
> >  	PHY_INTERFACE_MODE_10GBASER,
> >  	PHY_INTERFACE_MODE_USXGMII,
> > -	/* 10GBASE-KR - with Clause 73 AN */
> > +	/* Backplane KR */
> >  	PHY_INTERFACE_MODE_10GKR,
> > +	PHY_INTERFACE_MODE_40GKR4,
> >  	PHY_INTERFACE_MODE_MAX,
> >  } phy_interface_t;

I would like to see these (re-)named to PHY_INTERFACE_MODE_*GBASE* as
we have the same for previous definitions such as 1000BASEX and
2500BASEX.

Also, please update Documentation/networking/phy.rst with a description
of the new 40GBASE-KR4 mode.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

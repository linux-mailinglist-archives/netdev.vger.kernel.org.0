Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B207C12F891
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 13:57:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727751AbgACM5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 07:57:31 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40780 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727350AbgACM5b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jan 2020 07:57:31 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=wqTFhvUraQSX/xZ03R/QTSJNyHPxKF6DgB+uA22A3KE=; b=rMlZ7Fg2HYgtHwmfDOX64z6CD
        9k8jpYAyW2OZV5ELdxOztaG4k512rOjY+hcJbIhF2ViXzRHPjViU9uTDlXiF8ykR4PdPKZBcwkUfD
        QcoiPWKfZBfCMhDFVjaxSX2Mb5HJz+TL9DfmciZY3csf+nXLhliJrDZRJbLIwxqXheQStl51OK1Qe
        tLYdlc6o5ANp8xc2HMtOtISdCc1hulJpQsjHG9VbkZf8gnkAVIL4ZeP7tIsyRZ8zmbXr4tFoiYgHH
        2kbsaPBveyF6r2kFFQegRFji2yVodJU7qdkf6ENjAMgxsjLjZpMpFv5muN5rb0Jp+3XnOKPjMT5GR
        kx0wWty1Q==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:33454)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1inMW1-0002A0-IL; Fri, 03 Jan 2020 12:57:21 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1inMVz-000397-4Q; Fri, 03 Jan 2020 12:57:19 +0000
Date:   Fri, 3 Jan 2020 12:57:19 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] Fix 10G PHY interface types
Message-ID: <20200103125719.GF25745@shell.armlinux.org.uk>
References: <20200103115125.GC25745@shell.armlinux.org.uk>
 <DB8PR04MB698593C7DB07A82577562348EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB8PR04MB698593C7DB07A82577562348EC230@DB8PR04MB6985.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 03, 2020 at 12:22:58PM +0000, Madalin Bucur (OSS) wrote:
> > -----Original Message-----
> > From: netdev-owner@vger.kernel.org <netdev-owner@vger.kernel.org> On
> > Behalf Of Russell King - ARM Linux admin
> > Sent: Friday, January 3, 2020 1:51 PM
> > To: Andrew Lunn <andrew@lunn.ch>; Florian Fainelli <f.fainelli@gmail.com>;
> > Heiner Kallweit <hkallweit1@gmail.com>
> > Cc: David S. Miller <davem@davemloft.net>; Jonathan Corbet
> > <corbet@lwn.net>; Kishon Vijay Abraham I <kishon@ti.com>; linux-
> > doc@vger.kernel.org; netdev@vger.kernel.org
> > Subject: [PATCH net-next 0/2] Fix 10G PHY interface types
> > 
> > Recent discussion has revealed that our current usage of the 10GKR
> > phy_interface_t is not correct. This is based on a misunderstanding
> > caused in part by the various specifications being difficult to
> > obtain. Now that a better understanding has been reached, we ought
> > to correct this.
> > 
> > This series introduce PHY_INTERFACE_MODE_10GBASER to replace the
> > existing usage of 10GKR mode, and document their differences in the
> > phylib documentation. Then switch PHY, SFP/phylink, the Marvell
> > PP2 network driver, and its associated comphy driver over to use
> > the correct interface mode. None of the existing platform usage
> > was actually using 10GBASE-KR.
> > 
> > In order to maintain compatibility with existing DT files, arrange
> > for the Marvell PP2 driver to rewrite the phy interface mode; this
> > allows other drivers to adopt correct behaviour w.r.t whether the
> > 10G connection conforms to the backplane 10GBASE-KR protocol vs
> > normal 10GBASE-R protocol.
> > 
> > After applying these locally to net-next I've validated that the
> > only places which mention the old PHY_INTERFACE_MODE_10GKR
> > definition are:
> > 
> > Documentation/networking/phy.rst:``PHY_INTERFACE_MODE_10GKR``
> > drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c:        if (phy_mode ==
> > PHY_INTERFACE_MODE_10GKR)
> > drivers/net/phy/aquantia_main.c:                phydev->interface =
> > PHY_INTERFACE_MODE_10GKR;
> > drivers/net/phy/aquantia_main.c:            phydev->interface !=
> > PHY_INTERFACE_MODE_10GKR &&
> > include/linux/phy.h:    PHY_INTERFACE_MODE_10GKR,
> > include/linux/phy.h:    case PHY_INTERFACE_MODE_10GKR:
> > 
> > which is as expected.  The only users of "10gbase-kr" in DT are:
> > 
> > arch/arm64/boot/dts/marvell/armada-7040-db.dts: phy-mode = "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-clearfog-gt-8k.dts:     phy-mode =
> > "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode = "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-db.dts: phy-mode = "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode =
> > "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-mcbin-singleshot.dts:   phy-mode =
> > "10gbase-kr";
> > arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-mode =
> > "10gbase-kr";arch/arm64/boot/dts/marvell/armada-8040-mcbin.dts:      phy-
> > mode = "10gbase-kr";arch/arm64/boot/dts/marvell/cn9130-db.dts:      phy-
> > mode = "10gbase-kr";
> > arch/arm64/boot/dts/marvell/cn9131-db.dts:      phy-mode = "10gbase-kr";
> > arch/arm64/boot/dts/marvell/cn9132-db.dts:      phy-mode = "10gbase-kr";
> > 
> > which all use the mvpp2 driver, and these will be updated in a
> > separate patch to be submitted in the following kernel cycle.
> > 
> >  Documentation/networking/phy.rst                | 18 ++++++++++++++++++
> >  drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c | 13 ++++++++-----
> >  drivers/net/phy/aquantia_main.c                 |  7 +++++--
> >  drivers/net/phy/bcm84881.c                      |  4 ++--
> >  drivers/net/phy/marvell10g.c                    | 11 ++++++-----
> >  drivers/net/phy/phylink.c                       |  1 +
> >  drivers/net/phy/sfp-bus.c                       |  2 +-
> >  drivers/phy/marvell/phy-mvebu-cp110-comphy.c    | 20 ++++++++++----------
> >  include/linux/phy.h                             | 12 ++++++++----
> >  9 files changed, 59 insertions(+), 29 deletions(-)
> > 
> > --
> > RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
> > FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps
> > up
> > According to speedtest.net: 11.9Mbps down 500kbps up
> 
> Hi,
> 
> we should conclude our discussions on the initial thread before we do this.
> The current use on 10GBASE_KR is not correct, I agree but changing this to
> 10GBASE-R may not be the way to go. We need to determine if the existing
> device tree binding corelated type is the one we need to change or maybe a
> more complex solution is required. There are multiple paths forward:
> 
> Extending this enum that has a mix of things in it that are barely related.
> 
> For 10G Ethernet there is already an XGMII entry that describes the MII, if
> this should stick to strict MIIs. This is of little value for chips that
> have part of the traditional PHY blocks grouped along with the MAC, the XGMII
> is not exposed outside the RTL (if it even exists there) and the actual
> visible interfaces are completely different.
> 
> Describing the actual interface at chip to chip level (RGMII, SGMII, XAUI,
> XFI, etc.). This may be incomplete for people trying to configure their HW
> that supports multiple modes (reminder - device trees describe HW, they do
> not configure SW). More details would be required and the list would be...
> eclectic.
> 
> Moving to something different altogether, that would not conflict existing
> device trees but permit a more thorough classification and less ambiguity.
> We need more work on clearing a path towards that.

I think we've reached stalemate in this discussion. I don't think we
can make any useful forward progress at this point.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

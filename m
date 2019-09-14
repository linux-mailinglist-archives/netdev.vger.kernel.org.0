Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D271FB2C77
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 19:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731020AbfINRox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 13:44:53 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:53198 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbfINRox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 13:44:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=25oA/2ZM2PNrq8SZEQ1WNAyMoK3SOKYR3G7JjdZd9cA=; b=SzvNFxdoNbVdLLtYtJ7E9s/ou
        a7iLif9Flct5BhsIab60Vnr7NemUUeCNJOn98MJGtF0n6UhKObevNDV4kO/FuUs0ud6vecX2dROj7
        LrRyLFYjrES2MsYMUDPNCKFHvMUeZoHKJhe9HiwPOXRR4qoMVIj68XvOP2+V9xRaf4HMiYHw9N4c2
        DGQwOjJIC3y/BhGUEsLaxka/iTbDcxUkO0hZKeCIvtmFiNxQ6PvGd5mPA7JMJHA1D0oxuK4qr/jCr
        mEKxEn/jb8jGVL6X/vsdCTP7VUoVb+k4YIcg7tb327a0arLfwu4OkW+dhf87Dh21mxQVkC/5BAv/Y
        sOM718Qpw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:60214)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1i9C6K-0001wp-HF; Sat, 14 Sep 2019 18:44:48 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1i9C6I-00070Z-Rl; Sat, 14 Sep 2019 18:44:46 +0100
Date:   Sat, 14 Sep 2019 18:44:46 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     George McCollister <george.mccollister@gmail.com>,
        netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: SFP support with RGMII MAC via RGMII to SERDES/SGMII PHY?
Message-ID: <20190914174446.GA25745@shell.armlinux.org.uk>
References: <CAFSKS=NmM9bPb0R_zoFN+9AuG=x6DUffTNXpLSNRAHuZz4ki-g@mail.gmail.com>
 <6cd331e5-4e50-d061-439a-f97417645497@gmail.com>
 <20190914084856.GD13294@shell.armlinux.org.uk>
 <84d75b1c-8489-4242-fe6d-e7d3b389f1a2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <84d75b1c-8489-4242-fe6d-e7d3b389f1a2@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 14, 2019 at 10:15:26AM -0700, Florian Fainelli wrote:
> 
> 
> On 9/14/2019 1:48 AM, Russell King - ARM Linux admin wrote:
> > On Fri, Sep 13, 2019 at 08:31:18PM -0700, Florian Fainelli wrote:
> >> +Russell, Andrew, Heiner,
> >>
> >> On 9/13/2019 9:44 AM, George McCollister wrote:
> >>> Every example of phylink SFP support I've seen is using an Ethernet
> >>> MAC with native SGMII.
> >>> Can phylink facilitate support of Fiber and Copper SFP modules
> >>> connected to an RGMII MAC if all of the following are true?
> >>
> >> I don't think that use case has been presented before, but phylink
> >> sounds like the tool that should help solve it. From your description
> >> below, it sounds like all the pieces are there to support it. Is the
> >> Ethernet MAC driver upstream?
> > 
> > It has been presented, and it's something I've been trying to support
> > for the last couple of years - in fact, I have patches in my tree that
> > support a very similar scenario on the Macchiatobin with the 88x3310
> > PHYs.
> > 
> >>> 1) The MAC is connected via RGMII to a transceiver/PHY (such as
> >>> Marvell 88E1512) which then connects to the SFP via SERDER/SGMII. If
> >>> you want to see a block diagram it's the first one here:
> >>> https://www.marvell.com/transceivers/assets/Alaska_88E1512-001_product_brief.pdf
> > 
> > As mentioned above, this is no different from the Macchiatobin,
> > where we have:
> > 
> >                   .-------- RJ45
> > MAC ---- 88x3310 PHY
> >                   `-------- SFP+
> > 
> > except instead of the MAC to PHY link being 10GBASE-R, it's RGMII,
> > and the PHY to SFP+ link is 10GBASE-R instead of 1000BASE-X.
> > 
> > Note that you're abusing the term "SGMII".  SGMII is a Cisco
> > modification of the IEEE 802.3 1000BASE-X protocol.  Fiber SFPs
> > exclusively use 1000BASE-X protocol.  However, some copper SFPs
> > (with a RJ45) do use SGMII.
> > 
> >>> 2) The 1G Ethernet driver has been converted to use phylink.
> > 
> > This is not necessary for this scenario.  The PHY driver needs to
> > be updated to know about SFP though.
> > 
> > See:
> > 
> > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=phy&id=ece56785ee0e9df40dc823fdc39ee74b4a7cd1c4
> 
> Regarding that patch, the SFP attach/detach callbacks do not seem very
> specific to the PHY driver, only the sfp_insert callback which needs to
> check the interface selected by the SFP.
> 
> Do you think it would make sense to move some of that logic into the
> core PHY library and only have PHY drivers can be used to connect a SFP
> cage specify a "sfp_select_interface" callback that is responsible for
> rejecting the mode the SFP has been configured in, if unsupported?

It's not that simple.  The Marvell 1G PHYs which have a fiber interface
re-use the fiber interface for SGMII when configured for such a mode.
It's not as simple as "did the driver specify a callback for this
feature" but "does the PHY support a fiber interface _and_ does the PHY
configuration allow the fiber interface to be used?"  So, I think the
PHY driver needs to have a say (in terms of code) whether there is
support for fiber.

However, it'd be silly to specify a sfp property in a situation where
the fiber interface on a PHY can't be used.

In any case, the callback into the PHY driver needs to be as per the
"sfp_insert" method - some PHYs will only be able to support a limited
number of SFPs.  It seems, for example, the 88x3310 can support more
than just 10G modules - it allegedly can support 2500base-X, 1000base-X
and SGMII modules too if we hit it hard enough.

> Likewise for parsing the "sfp" property, if we parse that property in
> the core and do not have a sfp_select_interface callback defined, then
> it is not going to work.

Today, I've moved parsing the "sfp" property into sfp-bus, so that's no
longer a concern.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337B11429B2
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 12:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgATLjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 06:39:45 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:33810 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgATLjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 06:39:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JFpNcrCxPvd9E6Fan81VmVrHhEjIHL3IjZvlM4JrnjM=; b=mLPuEpquDqFmxJJcnTS4yAo12
        7/HPuRF9wWdtLwG4/0Kq0d+AjOsyiwW8jvx4G2r+M779gfiJMzbomr1796zPOGJbJcryMyvGZp1OA
        LuX/dF7KUkJ6lI7lAprRaUX0Ul0Gc6kM9FCXV40f2mNh6FRFyl0zzDyDOTp33DLg/i6+V2/P7/5y7
        Ow+YPhyT7El3AblYeisGRcI0eQ0uHULrlL7+W/UOzAOLHlnb5D2F8KKbJVQKv7C9EMK7Sd0FVv3Oz
        OOI25HoHrneurxJ8wIy2/RBusDQ3RZ1EG3nulrhFV+gwSXC9ZPgvTIa6Hm8rVKluxCt40oa4X1WSG
        WteizQLGg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:36696)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1itVP8-0005tQ-N0; Mon, 20 Jan 2020 11:39:38 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1itVP5-0002oR-Cp; Mon, 20 Jan 2020 11:39:35 +0000
Date:   Mon, 20 Jan 2020 11:39:35 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC net-next] net: phy: Add basic support for Synopsys XPCS
 using a PHY driver
Message-ID: <20200120113935.GC25745@shell.armlinux.org.uk>
References: <4953fc69a26bee930bccdeb612f1ce740a4294df.1578921062.git.Jose.Abreu@synopsys.com>
 <20200113133845.GD11788@lunn.ch>
 <BN8PR12MB32666F34D45D7881BDD4CAB3D3350@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200113141817.GN25745@shell.armlinux.org.uk>
 <BN8PR12MB3266EC7870338BA4A65E8A6CD3320@BN8PR12MB3266.namprd12.prod.outlook.com>
 <20200120105020.GB25745@shell.armlinux.org.uk>
 <BN8PR12MB32663612E58060077996670ED3320@BN8PR12MB3266.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BN8PR12MB32663612E58060077996670ED3320@BN8PR12MB3266.namprd12.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 11:07:23AM +0000, Jose Abreu wrote:
> From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> Date: Jan/20/2020, 10:50:20 (UTC+00:00)
> 
> > On Mon, Jan 20, 2020 at 10:31:17AM +0000, Jose Abreu wrote:
> > > From: Russell King - ARM Linux admin <linux@armlinux.org.uk>
> > > Date: Jan/13/2020, 14:18:17 (UTC+00:00)
> > > 
> > > > I've recently suggested a patch to phylink to add a generic helper to
> > > > read the state from a generic 802.3 clause 37 PCS, but I guess that
> > > > won't be sufficient for an XPCS.  However, it should give some clues
> > > > if you're intending to use phylink.
> > > 
> > > So, I think for my particular setup (that has no "real" PHY) we can have 
> > > something like this in SW PoV:
> > > 
> > > stmmac -> xpcs -> SW-PHY / Fixed PHY
> > > 
> > > - stmmac + xpcs state would be handled by phylink (MAC side)
> > > - SW-PHY / Fixed PHY state would be handled by phylink (PHY side)
> > > 
> > > This would need updates for Fixed PHY to support >1G speeds.
> > 
> > You don't want to do that if you have 1G SFPs.  Yes, you *can* do it
> > and make it work, but you miss out completely on the fact that the
> > link is supposed to be negotiated across the SFP link for 1G speeds,
> > and then you're into the realms of having to provide users ways to
> > edit the DT and reboot if the parameters at the link partner change.
> 
> You may have missed my answer to Andrew so I'll quote it here:
> 
> ---
> [...]
> 
> My current setup is this:
> 
> Host PC x86 -> PCI -> XGMAC -> XPCS -> SERDES 10G-BASE-R -> QSFP+
> 
> The only piece that needs configuration besides XGMAC is the XPCS hereby 
> 
> I "called" it a PHY [...]
> ---

I didn't miss this.

> So, besides not having a DT based setup to test changes, I also don't have 
> access to SFP bus neither SERDES ... As you suggested, I would like to 
> integrate XPCS with PHYLINK in stmmac but I'm not entirely sure on how to 
> implement the remaining connections as the connect_phy() callbacks will 
> fail because the only MMD device in the bus will be XPCS. That's why I 
> suggested the Fixed PHY approach ...

Having access to the SFP or not is not that relevent to the data link.
Generally, the SFP is not like a PHY, and doesn't take part in the
link negotiation unless it happens to contain a copper PHY.

Also, please, do not use fixed-phy support with phylink.  phylink
implements a replacement for that, where it supports fixed-links
without needing the fixed-phy stuff.  This is far more flexible
than fixed-phy which is restricted to the capabilities of clause 22
PHYs only.

To make fixed-phy support modes beyond clause 22 PHY capabilities
would need clause 45 register set emulation by swphy and a
corresponding clause 45 phylib driver; clause 45 annoyingly does
not define the 1G negotiation registers in the standard register
set, so every PHY vendor implements that using their own vendor
specific solution.

This is why phylink implements its own solution without using
fixed-phy (which I wish could be removed some day).

I would strongly recommend supporting the XPCS natively and not
via phylib.  Consider the case:

Host PC x86 -> PCI -> XGMAC -> XPCS -> SERDES 10G-BASE-R -> PHY -> RJ45

You can only have one phylib PHY attached to a network device via
connect_phy(); that is a restriction in the higher net layers.  If you
use phylib for the XPCS, how do you attach the PHY to the setup and
configure it?

Also, using a PHY via connect_phy() negates using fixed-link mode in
phylink, the two have always been exclusive.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0940FB6F32
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 00:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388286AbfIRWEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Sep 2019 18:04:12 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35890 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731394AbfIRWEL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Sep 2019 18:04:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=cVXXKsZm1P8Lpc6ktRV2Ycj7KsX2WfV9CmiPOEWszVE=; b=a4oVmItxr4OMxlZlobHneLScU
        nIiRlKlwEPixgGdDICNUvqMqRZzsgAaCZPijPid2gAj2UZA3SA8gVI4UivVkpJCZI0T5kPljIl3Gn
        FLW7z0yOPNTLAbIaGwtiTQmk3Bg3UUdSMJCURYkkC9KbrvNnnoGYi+Zm/UnxGKseMWvppcg9efox5
        Mx7EZ+JKNGAOTbwwa+qH9Nkp7Zi3ebRdbD/MD5l30Z/LN3TOGwP6RcXef4GUmgSUBmZlKLwSmPYdY
        dVuCh7Yj2/ZiHc1TdOsH4/pbuE6uNpo6L34OYABFoLLqFD0xE+FA++D9bnIgfGyh95bAKM0JR+ntK
        yPiRf1zNQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45338)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iAi3S-0002NO-PA; Wed, 18 Sep 2019 23:04:06 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iAi3Q-0002ba-7H; Wed, 18 Sep 2019 23:04:04 +0100
Date:   Wed, 18 Sep 2019 23:04:04 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: SFP support with RGMII MAC via RGMII to SERDES/SGMII PHY?
Message-ID: <20190918220404.GE25745@shell.armlinux.org.uk>
References: <CAFSKS=NmM9bPb0R_zoFN+9AuG=x6DUffTNXpLSNRAHuZz4ki-g@mail.gmail.com>
 <6cd331e5-4e50-d061-439a-f97417645497@gmail.com>
 <20190914084856.GD13294@shell.armlinux.org.uk>
 <CAFSKS=MW=0wrpdt-1n3G6KHeu0HTK8jEsEYvyA++h_7kvp+9Cw@mail.gmail.com>
 <CAFSKS=N_SF-S35eL=tLWOQFKiq7YKKY5B9YT6kxZc0usBayE7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFSKS=N_SF-S35eL=tLWOQFKiq7YKKY5B9YT6kxZc0usBayE7w@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 18, 2019 at 01:44:33PM -0500, George McCollister wrote:
> Russell,
> 
> On Mon, Sep 16, 2019 at 10:40 AM George McCollister
> <george.mccollister@gmail.com> wrote:
> >
> > On Sat, Sep 14, 2019 at 3:49 AM Russell King - ARM Linux admin
> > <linux@armlinux.org.uk> wrote:
> > >
> > > On Fri, Sep 13, 2019 at 08:31:18PM -0700, Florian Fainelli wrote:
> > > > +Russell, Andrew, Heiner,
> > > >
> > > > On 9/13/2019 9:44 AM, George McCollister wrote:
> > > > > Every example of phylink SFP support I've seen is using an Ethernet
> > > > > MAC with native SGMII.
> > > > > Can phylink facilitate support of Fiber and Copper SFP modules
> > > > > connected to an RGMII MAC if all of the following are true?
> > > >
> > > > I don't think that use case has been presented before, but phylink
> > > > sounds like the tool that should help solve it. From your description
> > > > below, it sounds like all the pieces are there to support it. Is the
> > > > Ethernet MAC driver upstream?
> > >
> > > It has been presented, and it's something I've been trying to support
> > > for the last couple of years - in fact, I have patches in my tree that
> > > support a very similar scenario on the Macchiatobin with the 88x3310
> > > PHYs.
> > >
> > > > > 1) The MAC is connected via RGMII to a transceiver/PHY (such as
> > > > > Marvell 88E1512) which then connects to the SFP via SERDER/SGMII. If
> > > > > you want to see a block diagram it's the first one here:
> > > > > https://www.marvell.com/transceivers/assets/Alaska_88E1512-001_product_brief.pdf
> > >
> > > As mentioned above, this is no different from the Macchiatobin,
> > > where we have:
> > >
> > >                   .-------- RJ45
> > > MAC ---- 88x3310 PHY
> > >                   `-------- SFP+
> > >
> > > except instead of the MAC to PHY link being 10GBASE-R, it's RGMII,
> > > and the PHY to SFP+ link is 10GBASE-R instead of 1000BASE-X.
> 
> Did you test with an SFP+ module that has a PHY?

I think you mean SFP module - SFP+ is for >1G.  No, that won't work for
two reasons.

1. The copper SFP module requires SGMII not 1000BASE-X.
2. netdev/phylib doesn't support stacking two PHYs on a single
   network device.

(1) can be worked around if the intermediary PHY can be configured for
it, but (2) is a lot harder to resolve, because phylib wants to put
the PHY into the netdev->phydev pointer, and you can't have two of
them.

I think fixing this properly is going to require quite a lot of
re-work, and as I don't have a setup that electrically supports SFP
modules in this setup (only SFP+ modules) it isn't something I'm
able to test.

> In my setup, nothing connects/attaches to the PHY (88E1111) in the
> RJ45 SFP module I'm testing with (is this intended?). Apparently since
> sfp_upstream_ops in the PHY driver used for the first PHY doesn't
> provide a .connect_phy.

Yep, because there's no way to stack phylib managed PHYs.

> This leaves .phy_link_change NULL. Eventually
> phy_link_down tries to call .phy_link_change resulting in a NULL
> pointer deference OOPs. If phy_link_change doesn't need to be called
> for the second PHY I can just send a patch that doesn't call it if
> it's NULL.

SGMII provides a way to discover the negotiated speed and duplex,
but not the pause settings back to the MAC - so in this setup, we
really do need to read the 88E1111 negotiation results (for the
pause settings) and communicate them back to the MAC for things
to work correctly.

It's something that we need to work out how to do...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

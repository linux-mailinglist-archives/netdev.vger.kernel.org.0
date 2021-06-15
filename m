Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9572D3A8AB7
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 23:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231396AbhFOVLU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 17:11:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhFOVLT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 17:11:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54089C061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 14:09:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0oTEhlDnij9n/RndxAoqoHMN78YObUOQ3meAlhjofgM=; b=GFyFWTyLfWKlLdVpuOO/yYuDx
        vyYRkkIBOrsKCw2q0pFuBNK+a2fhzOuvWQnvv6/1soYWz5Rdy07yHfDXGdhg+cwNVpKG/x0p/SgdG
        h/3BmriGlbVzxJOAG1uDQ4rDo9txwB0ZeaINWJHiBoyDDsaFDNL2e87dhVS/mC1SQyq/lVK+1WcwX
        TL5nN7PMPId7gwUAvVFiOGtE0Iz2Hg+B2ZHVCPXyTof+r+RPTttdjCj/jEaEZFCUkwiphgu0RHM59
        8X/vk+hLtFiKSVFRrp8s0N9GG8RyoTtcZ1XkQr5SCVbbDb/WO4OYx0vSaU3pH9k1nMz0LhystAJ07
        uRZjAwhHQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45040)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ltGJ3-0006Ce-MQ; Tue, 15 Jun 2021 22:09:09 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ltGJ1-0005Ms-Uc; Tue, 15 Jun 2021 22:09:07 +0100
Date:   Tue, 15 Jun 2021 22:09:07 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ioana Ciornei <ciorneiioana@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, hkallweit1@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <20210615210907.GY22278@shell.armlinux.org.uk>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
 <20210615171330.GW22278@shell.armlinux.org.uk>
 <YMjx6iBD88+xdODZ@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YMjx6iBD88+xdODZ@lunn.ch>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 08:31:06PM +0200, Andrew Lunn wrote:
> On Tue, Jun 15, 2021 at 06:13:31PM +0100, Russell King (Oracle) wrote:
> > On Tue, Jun 15, 2021 at 06:44:01PM +0300, Ioana Ciornei wrote:
> > > From: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > 
> > > By mistake, the of_node of the MDIO device was not setup in the patch
> > > linked below. As a consequence, any PHY driver that depends on the
> > > of_node in its probe callback was not be able to successfully finish its
> > > probe on a PHY, thus the Generic PHY driver was used instead.
> > > 
> > > Fix this by actually setting up the of_node.
> > > 
> > > Fixes: bc1bee3b87ee ("net: mdiobus: Introduce fwnode_mdiobus_register_phy()")
> > > Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> > > ---
> > >  drivers/net/mdio/fwnode_mdio.c | 1 +
> > >  1 file changed, 1 insertion(+)
> > > 
> > > diff --git a/drivers/net/mdio/fwnode_mdio.c b/drivers/net/mdio/fwnode_mdio.c
> > > index e96766da8de4..283ddb1185bd 100644
> > > --- a/drivers/net/mdio/fwnode_mdio.c
> > > +++ b/drivers/net/mdio/fwnode_mdio.c
> > > @@ -65,6 +65,7 @@ int fwnode_mdiobus_phy_device_register(struct mii_bus *mdio,
> > >  	 * can be looked up later
> > >  	 */
> > >  	fwnode_handle_get(child);
> > > +	phy->mdio.dev.of_node = to_of_node(child);
> > >  	phy->mdio.dev.fwnode = child;
> > 
> > Yes, this is something that was missed, but let's first look at what
> > other places to when setting up a device:
> > 
> >         pdev->dev.fwnode = pdevinfo->fwnode;
> >         pdev->dev.of_node = of_node_get(to_of_node(pdev->dev.fwnode));
> >         pdev->dev.of_node_reused = pdevinfo->of_node_reused;
> > 
> >         dev->dev.of_node = of_node_get(np);
> >         dev->dev.fwnode = &np->fwnode;
> > 
> >         dev->dev.of_node = of_node_get(node);
> >         dev->dev.fwnode = &node->fwnode;
> > 
> > That seems to be pretty clear that an of_node_get() is also needed.
> 
> I think it also shows we have very little consistency, and the recent
> patchset needs a bit of cleanup. Maybe yet another helper which when
> passed a struct device * and a node pointer, it sets both values?

I do like that idea - maybe a couple of helpers, one that takes the
of_node for a struct device, and another that takes a fwnode and
does the appropriate stuff.

Note that platform_device_release() does this:

	of_node_put(pa->pdev.dev.of_node);

which is currently fine, because platform devices appear to only
have their DT refcount increased. From what I can tell from looking
at drivers/acpi/arm64/iort.c, ACPI fwnodes don't look like they're
refcounted. Seems we're wading into something of a mess here. :(

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

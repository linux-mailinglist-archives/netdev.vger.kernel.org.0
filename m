Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785DB3A8889
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 20:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231618AbhFOS1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 14:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230000AbhFOS1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 14:27:11 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1188BC061574
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 11:25:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=HEvQuIGyM/+fSUtSn0O/v1u//7ms+qcTs0QGEQAyClU=; b=VDsDbes24cb9nwcKtfvovGCJq
        JdE6roRnnAH9Oi/xH2sJRJHe4/os4WNhi81jw2R0YG/nefvQ46L32PWqofnQurxdfYU/I54FHh1Yj
        kwW3QbxAr3yx5RO12reGsItA8B8INJhy49/irnzPNz8xGdSu/Wxh6TdH5zA8KEKOffKKjsk5DJRib
        c28UL3Lp+bqNoaaocqyc7DWZvTi5htOZ9XXJ5WTMznywbQ2hfZ+B5jWfUGYgO/A4u4DPc/NVJYv32
        h+x3+uZvI8SYQ50pifjMF1jjlPBN0mBr2nlX3Ehu8qIl75h3mAVIpAbcfo2TGoL6msAX32MdzQCBl
        E6qgFs68w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:45038)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1ltDkE-0005w1-Sp; Tue, 15 Jun 2021 19:25:02 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1ltDkD-0005G7-DP; Tue, 15 Jun 2021 19:25:01 +0100
Date:   Tue, 15 Jun 2021 19:25:01 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        calvin.johnson@oss.nxp.com, andrew@lunn.ch, hkallweit1@gmail.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] mdio: mdiobus: setup of_node for the MDIO device
Message-ID: <20210615182501.GX22278@shell.armlinux.org.uk>
References: <20210615154401.1274322-1-ciorneiioana@gmail.com>
 <20210615171330.GW22278@shell.armlinux.org.uk>
 <20210615172444.dirudehe3vzis2kw@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210615172444.dirudehe3vzis2kw@skbuf>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 08:24:44PM +0300, Ioana Ciornei wrote:
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
> > 
> 
> I'm not convinced that an of_node_get() is needed besides the
> fwnode_handle_get() call that's already there.
> 
> The fwnode_handle_get() will call the get callback for that particular
> fwnode_handle. When we are in the OF case, the of_fwnode_get() will be
> invoked which in turn does of_node_get().
> 
> Am I missing something here?

Hmm, I think you're actually correct - the other places increase the
OF node's refcount and then assign the fwnode, which is effectively
what will be happening here (since fwnode_handle_get() will do that
for us.)

However, there's definitely horrid stuff going on in this file with
refcounting:

fwnode_mdiobus_register_phy():

			phy_device_free(phy);
			fwnode_handle_put(phy->mdio.dev.fwnode);

phy_device_free() drops the refcount on the embedded struct device - it
_could_ free it, so we should be assuming that "phy" is dead at that
point - we should not be dereferencing it after the call.

fwnode_mdiobus_phy_device_register():

	fwnode_handle_get(child);
	phy->mdio.dev.fwnode = child;

	rc = phy_device_register(phy);
	if (rc) {
		fwnode_handle_put(child);
		return rc;

Here, we leave this function having dropped the fwnode refcount, but
we have left a dangling pointer to the fwnode in place. Hopefully,
no one will use that dangling pointer, but this is sloppy.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

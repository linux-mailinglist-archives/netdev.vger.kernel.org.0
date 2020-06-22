Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D27E20382B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729164AbgFVNg1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729158AbgFVNgY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 09:36:24 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF040C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 06:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=/+qr+F24v2dner5Cjll7wkT48i8BvDK0FG37us55VKE=; b=OxEX3xXbjhf257SnZ1DemCXIZ
        j8eMk3XX0S6bxZwqcuGLvd3nRJQahZXPyMNYIsSsdGUqi3/1DtXoSp+MtnZNAYvUdd27SFD5Z2Ker
        bfUWLblhi1xaexjnDb+kfFMHR1AVUWTZ+B8YkiR0gPQ7lM5WWmoOO2LgZDD25quocCY3LBWHjqYA3
        wR8K0T/LOvacukxcmTF+5iVcalIoG5GJEZPGLGiTonyGENclUhHLEJnl8HBrdy5kA+ckQclAw1Cyu
        FObJbIrJtDNHzEOHhxPPk0qTmarL9nKECf450MjVcWPclM4+SC+GIkA9ep+kVd8b9HSHB4mIZqwMS
        sI0lbhjeA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58968)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jnMcV-0000Ib-Uc; Mon, 22 Jun 2020 14:36:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jnMcV-00005m-63; Mon, 22 Jun 2020 14:36:19 +0100
Date:   Mon, 22 Jun 2020 14:36:19 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Calvin Johnson <calvin.johnson@oss.nxp.com>
Cc:     "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Jeremy Linton <jeremy.linton@arm.com>, Jon <jon@solid-run.com>,
        Cristi Sovaiala <cristian.sovaiala@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "linux.cj@gmail.com" <linux.cj@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net-next PATCH v2 1/3] net: phy: Allow mdio buses to auto-probe
 c45 devices
Message-ID: <20200622133619.GJ1551@shell.armlinux.org.uk>
References: <20200622081914.2807-1-calvin.johnson@oss.nxp.com>
 <20200622081914.2807-2-calvin.johnson@oss.nxp.com>
 <AM6PR04MB3976D2F9DFD9EE940356D31CEC970@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <20200622131652.GA5822@lsv03152.swis.in-blr01.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622131652.GA5822@lsv03152.swis.in-blr01.nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 06:46:52PM +0530, Calvin Johnson wrote:
> On Mon, Jun 22, 2020 at 09:29:17AM +0000, Madalin Bucur (OSS) wrote:
> > > -----Original Message-----
> > > From: Calvin Johnson (OSS) <calvin.johnson@oss.nxp.com>
> > > Sent: Monday, June 22, 2020 11:19 AM
> > > To: Jeremy Linton <jeremy.linton@arm.com>; Russell King - ARM Linux admin
> > > <linux@armlinux.org.uk>; Jon <jon@solid-run.com>; Cristi Sovaiala
> > > <cristian.sovaiala@nxp.com>; Ioana Ciornei <ioana.ciornei@nxp.com>; Andrew
> > > Lunn <andrew@lunn.ch>; Andy Shevchenko <andy.shevchenko@gmail.com>;
> > > Florian Fainelli <f.fainelli@gmail.com>; Madalin Bucur (OSS)
> > > <madalin.bucur@oss.nxp.com>
> > > Cc: linux.cj@gmail.com; netdev@vger.kernel.org; Calvin Johnson (OSS)
> > > <calvin.johnson@oss.nxp.com>
> > > Subject: [net-next PATCH v2 1/3] net: phy: Allow mdio buses to auto-probe
> > > c45 devices
> > > 
> > > From: Jeremy Linton <jeremy.linton@arm.com>
> > > 
> > > The mdiobus_scan logic is currently hardcoded to only
> > > work with c22 devices. This works fairly well in most
> > > cases, but its possible that a c45 device doesn't respond
> > > despite being a standard phy. If the parent hardware
> > > is capable, it makes sense to scan for c22 devices before
> > > falling back to c45.
> > > 
> > > As we want this to reflect the capabilities of the STA,
> > > lets add a field to the mii_bus structure to represent
> > > the capability. That way devices can opt into the extended
> > > scanning. Existing users should continue to default to c22
> > > only scanning as long as they are zero'ing the structure
> > > before use.
> > 
> > How is this default working for existing users, the code below does not seem
> > to do anything for a zeroed struct, as there is no default in the switch?
> 
> Looking further into this, I think MDIOBUS_C22 = 0, was correct. Prior to
> this patch, get_phy_device() was executed for C22 in this path. I'll discuss
> with Russell and Andrew on this and get back.

It is not correct for the reasons I stated when I made the comment.
When you introduce "probe_capabilities", every MDIO bus will have
that field as zero.

In your original patch, that means the bus only supports clause 22.
However, we have buses today that _that_ is factually incorrect.
Therefore, introducing probe_capabilities with zero meaning MDIOBUS_C22
is wrong.  It means we can _never_ assume that bus->probe_capabilities
means the bus does not support Clause 45.

Now, as per your patch below, that is better.  It means we're able to
identify those drivers that have not declared which bus access methods
are supported, while we can positively identify those which have.

All that's needed is for your switch() statement to maintain today's
behaviour where no declared probe_capabilities means that the bus
should be probed for clause 22 PHYs.

This means we can later introduce the ability to prevent clause 45
probing for PHYs that declare themselves as explicitly only supporting
clause 22 if we need to without having been backed into a corner, and
left wondering whether the lack of probe_capabilities is because someone
decided "it's zero, so doesn't need to be initialised" and didn't bother
explicitly stating .probe_capabilities = MDIOBUS_C22.

> > > Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
> > > Signed-off-by: Calvin Johnson <calvin.johnson@oss.nxp.com>
> > > 
> > > ---
> > > 
> > > Changes in v2:
> > > - Reserve "0" to mean that no mdiobus capabilities have been declared.
> > > 
> > >  drivers/net/phy/mdio_bus.c | 17 +++++++++++++++--
> > >  include/linux/phy.h        |  8 ++++++++
> > >  2 files changed, 23 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
> > > index 6ceee82b2839..e6c179b89907 100644
> > > --- a/drivers/net/phy/mdio_bus.c
> > > +++ b/drivers/net/phy/mdio_bus.c
> > > @@ -739,10 +739,23 @@ EXPORT_SYMBOL(mdiobus_free);
> > >   */
> > >  struct phy_device *mdiobus_scan(struct mii_bus *bus, int addr)
> > >  {
> > > -	struct phy_device *phydev;
> > > +	struct phy_device *phydev = ERR_PTR(-ENODEV);
> > >  	int err;
> > > 
> > > -	phydev = get_phy_device(bus, addr, false);
> > > +	switch (bus->probe_capabilities) {
> > > +	case MDIOBUS_C22:
> > > +		phydev = get_phy_device(bus, addr, false);
> > > +		break;
> > > +	case MDIOBUS_C45:
> > > +		phydev = get_phy_device(bus, addr, true);
> > > +		break;
> > > +	case MDIOBUS_C22_C45:
> > > +		phydev = get_phy_device(bus, addr, false);
> > > +		if (IS_ERR(phydev))
> > > +			phydev = get_phy_device(bus, addr, true);
> > > +		break;
> > > +	}
> > > +
> > >  	if (IS_ERR(phydev))
> > >  		return phydev;
> > > 
> > > diff --git a/include/linux/phy.h b/include/linux/phy.h
> > > index 9248dd2ce4ca..7860d56c6bf5 100644
> > > --- a/include/linux/phy.h
> > > +++ b/include/linux/phy.h
> > > @@ -298,6 +298,14 @@ struct mii_bus {
> > >  	/* RESET GPIO descriptor pointer */
> > >  	struct gpio_desc *reset_gpiod;
> > > 
> > > +	/* bus capabilities, used for probing */
> > > +	enum {
> > > +		MDIOBUS_NO_CAP = 0,
> > > +		MDIOBUS_C22,
> > > +		MDIOBUS_C45,
> > > +		MDIOBUS_C22_C45,
> > > +	} probe_capabilities;
> > > +
> > >  	/* protect access to the shared element */
> > >  	struct mutex shared_lock;
> > > 
> > > --
> > > 2.17.1
> > 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

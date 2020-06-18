Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB8701FF9BF
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 18:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730289AbgFRQzQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 12:55:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728664AbgFRQzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 12:55:13 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 538FEC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 09:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=bNQEtVjSYN81l7myBTiMTW9h50u32Ff9Sf3/e7IE9GI=; b=qjyE/Ei6o3yWn8o70fh0yA2y9
        TUd9p/08RE2PtxilrX067FeyphynRsxnyQuguwfiNqXjIz4YO7bXtvk+idhqsnggNwa6jKuBQSw69
        5d4H0Fb8bf0FsHxD6KjepXnqSHIq3ZDlBdjnGHt/Hn46lmaQKFQO5B0aCI8X4cLItU1k7wHFCZft1
        lIHyKlJ5LPlPivH4FGrYbR0sN+fPrvHY9e9IabpVNju/wDcGYbc3YYfr9iHFzOzoHk9ZoL54bDHrG
        gBij7li1qeUC/7nI2hQrTZjUVJ7a5V9czCMepaHr89LUCOJ7YDy/HvdztZ4q9cyl8eSoEkFU34WSt
        /Z6p09jrw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:58794)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jlxol-0005QN-Bc; Thu, 18 Jun 2020 17:55:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jlxok-0004rj-JE; Thu, 18 Jun 2020 17:55:10 +0100
Date:   Thu, 18 Jun 2020 17:55:10 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 4/5] net: phy: add Lynx PCS MDIO module
Message-ID: <20200618165510.GG1551@shell.armlinux.org.uk>
References: <20200618120837.27089-1-ioana.ciornei@nxp.com>
 <20200618120837.27089-5-ioana.ciornei@nxp.com>
 <20200618140623.GC1551@shell.armlinux.org.uk>
 <VI1PR0402MB387191C53CE915E5AC060669E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB387191C53CE915E5AC060669E09B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 04:17:56PM +0000, Ioana Ciornei wrote:
> > > +struct mdio_lynx_pcs *mdio_lynx_pcs_create(struct mdio_device
> > > +*mdio_dev) {
> > > +	struct mdio_lynx_pcs *pcs;
> > > +
> > > +	if (WARN_ON(!mdio_dev))
> > > +		return NULL;
> > > +
> > > +	pcs = kzalloc(sizeof(*pcs), GFP_KERNEL);
> > > +	if (!pcs)
> > > +		return NULL;
> > > +
> > > +	pcs->dev = mdio_dev;
> > > +	pcs->an_restart = lynx_pcs_an_restart;
> > > +	pcs->get_state = lynx_pcs_get_state;
> > > +	pcs->link_up = lynx_pcs_link_up;
> > > +	pcs->config = lynx_pcs_config;
> > 
> > We really should not have these private structure interfaces.  Private structure-
> > based driver specific interfaces really don't constitute a sane approach to
> > interface design.
> > 
> > Would it work if there was a "struct mdio_device" add to the phylink_config
> > structure, and then you could have the phylink_pcs_ops embedded into this
> > driver?
> 
> I think that would restrict too much the usage.
> I am afraid there will be instances where the PCS is not recognizable by PHY_ID,
> thus no way of knowing which driver to probe which mdio_device.
> Also, I would leave to the driver the choice of using (or not) the functions 
> exported by Lynx.

I think you've taken my point way too far.  What I'm complaining about
is the indirection of lynx_pcs_an_restart() et.al. through a driver-
private structure.

In order to access lynx_pcs_an_restart(), we need to dereference
struct mdio_lynx_pcs, which is a structure specific to this lynx PCS
driver.  What this leads to is users doing this:

	if (pcs_is_lynx) {
		struct mdio_lynx_pcs *pcs = foo->bar;

		pcs->an_restart(...);
	} else if (pcs_is_something_else) {
		struct mdio_somethingelse_pcs *pcs = foo->bar;

		pcs->an_restart(...);
	}

which really does not scale.  A step forward would be:

	if (pcs_is_lynx) {
		lynx_pcs_an_restart(...);
	} else if (pcs_is_something_else) {
		something_else_pcs_an_restart(...);
	}

but that also scales horribly.

Even better would be to have a generic set of operations for PCS
devices that can be declared in the lynx PCS driver and used
externally... like, maybe struct phylink_pcs_ops, which is made
globally visible for MAC drivers to use with phylink_add_pcs().

Or maybe a function in this lynx PCS driver that calls phylink_add_pcs()
itself with its own PCS operations, and maybe also sets a field in
struct phylink_config for the PCS mdio device?

Or something like that - just some a way that doesn't force us down
a path that we end up forcing people into code that has to decide
what sort of PCS we have at runtime in all these method paths.

> What if we directly export the helper functions directly as symbols which can
> be used by the driver without any mdio_lynx_pcs in the middle
> (just the mdio_device passed to the function).
> This would be exactly as phylink_mii_c22_pcs_[an_restart/config] are currently
> used.

The difference is that phylink_mii_c22_pcs_* are designed as library
functions - functions that are very likely to be re-used for multiple
different PCS (because the format, location, and access method of
these registers is defined by IEEE 802.3).  It's a bit like phylib's
configuration of autoneg - we don't have all the individual drivers
doing that, we have core code that does that for us in the form of
helpers.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

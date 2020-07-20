Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16C6226E1F
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 20:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbgGTSQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 14:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729430AbgGTSQt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 14:16:49 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89800C0619D2
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 11:16:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1uN6CD/efkpPpFvq1uF47cgzEH10bDBas3ehrlsqX8M=; b=JK0PMygmjMJBEFbfX5VkGDLue
        mfvD9ef0eArMEMUdogPPF6fUxE4HU8WIZLvcgjqdm6v4v/qGv2YIkP6ncBrRpUaD9H2g/QaKWsHYA
        ZkpIwBve6eJuJwfn+K1ilJQok+tMaHpJ4DX07kF2JXyKtrJ/in7IBVKkwiF2C52tC8zYIA5VbNyoV
        0HoVhCEX0bhEXa2lnIhp/PRBudGRIUaKITENZIaV0lAqw2fTprLzQoffv2DFKNmaEFmswvY7HPlSM
        qJrxIPFbKSyrzMHmRJbXiKGnuzEetfzQQ1VKIw3gtYttTT4cv9hWmf05VqKS3tyFo8h5ZqOmPSfj1
        ArrmaY5wg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:41994)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jxaLC-0003QH-Fh; Mon, 20 Jul 2020 19:16:42 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jxaL8-0005Bt-Ih; Mon, 20 Jul 2020 19:16:38 +0100
Date:   Mon, 20 Jul 2020 19:16:38 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 12/13] net: phylink: add struct phylink_pcs
Message-ID: <20200720181638.GX1551@shell.armlinux.org.uk>
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHGO-0006QN-Hw@rmk-PC.armlinux.org.uk>
 <VI1PR0402MB3871010E01CD0C6BADC04520E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
 <20200720162600.GW1551@shell.armlinux.org.uk>
 <VI1PR0402MB387129A07C77AD9D08871F18E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB387129A07C77AD9D08871F18E07B0@VI1PR0402MB3871.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 20, 2020 at 04:59:08PM +0000, Ioana Ciornei wrote:
> On 7/20/20 7:26 PM, Russell King - ARM Linux admin wrote:
> > On Mon, Jul 20, 2020 at 03:50:57PM +0000, Ioana Ciornei wrote:
> >> On 6/30/20 5:29 PM, Russell King wrote:
> >>> Add a way for MAC PCS to have private data while keeping independence
> >>> from struct phylink_config, which is used for the MAC itself. We need
> >>> this independence as we will have stand-alone code for PCS that is
> >>> independent of the MAC.  Introduce struct phylink_pcs, which is
> >>> designed to be embedded in a driver private data structure.
> >>>
> >>> This structure does not include a mdio_device as there are PCS
> >>> implementations such as the Marvell DSA and network drivers where this
> >>> is not necessary.
> >>>
> >>> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
> >>
> >> Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> >>
> >> I integrated and used the phylink_pcs structure into the Lynx PCS just
> >> to see how everything fits. Pasting below the main parts so that we can
> >> catch early any possible different opinions on how to integrate this:
> >>
> >> The basic Lynx structure looks like below and the main idea is just to
> >> encapsulate the phylink_pcs structure and the mdio device (which in some
> >> other cases might not be needed).
> >>
> >> struct lynx_pcs {
> >>          struct phylink_pcs pcs;
> >>          struct mdio_device *mdio;
> >>          phy_interface_t interface;
> >> };
> >>
> >> The lynx_pcs structure is requested by the MAC driver with:
> >>
> >> struct lynx_pcs *lynx_pcs_create(struct mdio_device *mdio)
> >> {
> >> (...)
> >>          lynx_pcs->mdio = mdio;
> >>          lynx_pcs->pcs.ops = &lynx_pcs_phylink_ops;
> >>          lynx_pcs->pcs.poll = true;
> >>
> >>          return lynx_pcs;
> >> }
> >>
> >> And then passed to phylink with something like:
> >>
> >> phylink_set_pcs(pl, &lynx_pcs->pcs);
> >>
> >>
> >> For DSA it's a bit less straightforward because the .setup() callback
> >> from the dsa_switch_ops is run before any phylink structure has been
> >> created internally. For this, a new DSA helper can be created that just
> >> stores the phylink_pcs structure per port:
> >>
> >> void dsa_port_phylink_set_pcs(struct dsa_switch *ds, int port,
> >>                                struct phylink_pcs *pcs)
> >> {
> >>          struct dsa_port *dp = dsa_to_port(ds, port);
> >>
> >>          dp->pcs = pcs;                                         but I do
> >> }
> >>
> >> and at the appropriate time, from dsa_slave_setup, it can really install
> >> the phylink_pcs with phylink_set_pcs.
> >> The other option would be to add a new dsa_switch ops that requests the
> >> phylink_pcs for a specific port - something like phylink_get_pcs.
> > 
> > It is entirely possible to set the PCS in the mac_prepare() or
> > mac_config() callbacks - but DSA doesn't yet support the mac_prepare()
> > callback (because it needs to be propagated through the DSA way of
> > doing things.)
> > 
> > An example of this can be found at:
> > 
> > http://git.armlinux.org.uk/cgit/linux-arm.git/commit/?h=mcbin&id=593d56ef8c7f7d395626752f6810210471a5f5c1
> > 
> > where we choose between the XLGMAC and GMAC pcs_ops structures
> > depending on the interface mode we are configuring for.  Note that
> > this is one of the devices that the PCS does not appear as a
> > distinctly separate entity in the register set, at least in the
> > GMAC side of things.
> > 
> 
> Thanks for the info, I didn't get that this is possible by reading the 
> previous patch. Maybe this would be useful in the documentation of the 
> callback?
> 
> Back to the DSA, I don't feel like we gain much by setting up the 
> phylink_pcs from another callback: we somehow force the driver to 
> implement a phylink_mac_prepare dsa_switch_ops just so that it sets up 
> the phylink_pcs, which for me at least would not be intuitive.

As I said, you can set it in mac_config() as well, which is the
absolute latest point. So, you don't actually need DSA to implement
anything extra.

I may need to add mac_prepare()/mac_finish() to DSA in any case if
I convert Marvell DSA switches to phylink PCS - on the face of it,
that looks like the logical thing, but there are a few quirks (like
auto-media ports) that make it less trivial.  Even so, we already
have no way to properly cope with the Marvell auto-media ports today.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!

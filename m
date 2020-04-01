Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D053A19AD92
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 16:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732975AbgDAOPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 10:15:03 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:58452 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732826AbgDAOPD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 10:15:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CG4OmPa/gJjzatQG79XkzsR0JM6D3FtKUESWPgDFYUI=; b=FLoiFyV9GBN4e5K2JSJFsYsLy
        eQEiCGTHai8I/AIPsdax4gnpxe1sTozOowESIDOeFOHX6PXaLlaOIa1qCKZD2OHOOJ6BP1fQJ3bsG
        yOmw5xJo828E6kLdA7vqcOoooAnPu+C/dHp2sm21JTA2wlMZmwLqK+GGcOfV8GOGy7s730Q/2meIn
        I9iPGDwRX4pbJIzxJ2BG9NQl/yXBP59v8n1kQUNFxw1uh/gJoOuvlGRxHByXAnU5Xq4BR9o+H2Hev
        MHu19blJGnmGCDkaY6T3g9vCEjVUFOjs7ae8+ltAm1ZjPUtbLlL5/ukGo3KKgYK80Q/xmLiTaLpj/
        VLsSYYRNA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:44274)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jJe8r-0006LQ-Nb; Wed, 01 Apr 2020 15:14:53 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jJe8m-0000lb-QQ; Wed, 01 Apr 2020 15:14:48 +0100
Date:   Wed, 1 Apr 2020 15:14:48 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 6/9] net: phy: add backplane kr driver support
Message-ID: <20200401141448.GU25745@shell.armlinux.org.uk>
References: <AM0PR04MB544326757B0B510C7C3C6417FBC90@AM0PR04MB5443.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB544326757B0B510C7C3C6417FBC90@AM0PR04MB5443.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 02:01:25PM +0000, Florinel Iordache wrote:
> > On Thu, Mar 26, 2020 at 03:51:19PM +0200, Florinel Iordache wrote:
> > > Add support for backplane kr generic driver including link training
> > > (ieee802.3ap/ba) and fixed equalization algorithm
> > >
> > > Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> > > +/* Read AN Link Status */
> > > +static int is_an_link_up(struct phy_device *bpphy) {
> > > +     struct backplane_phy_info *bp_phy = bpphy->priv;
> > > +     int ret, val = 0;
> > > +
> > > +     mutex_lock(&bp_phy->bpphy_lock);
> > > +
> > > +     /* Read twice because Link_Status is LL (Latched Low) bit */
> > > +     val = phy_read_mmd(bpphy, MDIO_MMD_AN, bp_phy-
> > >bp_dev.mdio.an_status);
> > > +     val = phy_read_mmd(bpphy, MDIO_MMD_AN,
> > > + bp_phy->bp_dev.mdio.an_status);
> > 
> > Why not just
> > 
> > val = phy_read_mmd(bpphy, MDIO_MMD_AN, MDIO_CTRL1);
> > 
> > Or is your hardware not actually conformant to the standard?
> > 
> > There has also been a lot of discussion of reading the status twice is correct or
> > not. Don't you care the link has briefly gone down and up again?
> > 
> >         Andrew
> 
> This could be changed to use directly the MDIO_STAT1 in order to read
> AN status (and use MDIO_CTRL1 for writing the control register) but this
> is more flexible and more readable since we defined the structure
> kr_mdio_info that contains all registers offsets required by backplane
> driver like: LT(link training) registers, AN registers, PMD registers.
> So we wanted to put all these together to be clear that all these
> offsets are essential for backplane driver and they can be setup
> automatically by calling the function: backplane_setup_mdio_c45.
> 
> + void backplane_setup_mdio_c45(struct backplane_kr_info *bpkr)
> + /* KX/KR AN registers: IEEE802.3 Clause 45 (MMD 7) */
> + bpkr->mdio.an_control = MDIO_CTRL1;
> + bpkr->mdio.an_status = MDIO_STAT1;
> + bpkr->mdio.an_ad_ability_0 = MDIO_PMA_EXTABLE_10GBKR;
> + bpkr->mdio.an_ad_ability_1 = MDIO_PMA_EXTABLE_10GBKR + 1;
> + bpkr->mdio.an_lp_base_page_ability_1 = MDIO_PMA_EXTABLE_10GBKR + 4;

Where they are IEEE 802.3 standard registers, just use the standard
definitions, do not indirect.

> This approach is more flexible because it lets open the possibility for
> extension on other non-standard devices (devices non-compliant with
> clause 45) to still use this driver for backplane operation.

That's an entirely false argument.  If something is going to be
non-standard, why do you think that the only thing they'll do is
have non-standard register offsets?  Wouldn't they also have
non-standard register contents as well - and if they do, your
"flexible" model will no longer work there.

This seems to me to be a classic case of over-design.

We have seem some PHYs with multiple different PHY blocks within the
clause 45 space, but these are merely at offsets and follow the
standard IEEE 802.3 register sets at various offsets.  The minimum
that would be required in that case would be to carry a single register
offset - but there is no point until we encounter a PHY that actually
requires that for this support.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up

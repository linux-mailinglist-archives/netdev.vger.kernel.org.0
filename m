Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1EC46549
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 19:03:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726252AbfFNRD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 13:03:29 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:40756 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfFNRD2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 13:03:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sufpNbI2TvDXrx0wjTmrSfNrCdLHnuRdUOR5wAlySw0=; b=srsO1pM8Yodsu8IF44+hgY8At
        T/QYSxlUKvNbq4wD/BUER4kAzDrpEglFIk8WkCWPs/n8bgFDhuUvgmkG1mVAxioZ2PH8jCnl32OnF
        8T2mYx8R/X9ESzsBhaxx3zO4tKq1luYOTqcnEAtKNxCW5OxKHYeV9rxC4NFsAT3nRXKcrFOw6TswR
        BdXxFwawtL9slBU+BbIUl1L3rkQiBOdK//zydBtfVXbywEvzp1loADkAHbdrttySe5EdgJcj46d4L
        WeEZvlkTAM23D+Pvr9MVPfk66HodrQI5Fpbx/dxTwzkyJw2AumQsd/qggCyAZlbFVHfXKVHxNjnbn
        NKeoOe50w==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56402)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hbpbl-0002hx-GT; Fri, 14 Jun 2019 18:03:21 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hbpbj-0002N0-3A; Fri, 14 Jun 2019 18:03:19 +0100
Date:   Fri, 14 Jun 2019 18:03:18 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Message-ID: <20190614170318.rjn72deumf3eyasr@shell.armlinux.org.uk>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com>
 <20190614014223.GD28822@lunn.ch>
 <20190614095015.mhs723furhhsaclo@shell.armlinux.org.uk>
 <VI1PR0402MB2800FA7EF554B855F3B90353E0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB2800FA7EF554B855F3B90353E0EE0@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 04:54:56PM +0000, Ioana Ciornei wrote:
> > Subject: Re: [PATCH RFC 4/6] dpaa2-mac: add initial driver
> > 
> > On Fri, Jun 14, 2019 at 03:42:23AM +0200, Andrew Lunn wrote:
> > > > +static phy_interface_t phy_mode(enum dpmac_eth_if eth_if) {
> > > > +	switch (eth_if) {
> > > > +	case DPMAC_ETH_IF_RGMII:
> > > > +		return PHY_INTERFACE_MODE_RGMII;
> > >
> > > So the MAC cannot insert RGMII delays? I didn't see anything in the
> > > PHY object about configuring the delays. Does the PCB need to add
> > > delays via squiggles in the tracks?
> > >
> > > > +static void dpaa2_mac_validate(struct phylink_config *config,
> > > > +			       unsigned long *supported,
> > > > +			       struct phylink_link_state *state) {
> > > > +	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
> > > > +	struct dpmac_link_state *dpmac_state = &priv->state;
> > > > +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> > > > +
> > > > +	phylink_set(mask, Autoneg);
> > > > +	phylink_set_port_modes(mask);
> > > > +
> > > > +	switch (state->interface) {
> > > > +	case PHY_INTERFACE_MODE_10GKR:
> > > > +		phylink_set(mask, 10baseT_Full);
> > > > +		phylink_set(mask, 100baseT_Full);
> > > > +		phylink_set(mask, 1000baseT_Full);
> > > > +		phylink_set(mask, 10000baseT_Full);
> > > > +		break;
> > 
> > How does 10GBASE-KR mode support these lesser speeds - 802.3 makes no
> > provision for slower speeds for a 10GBASE-KR link, it is a fixed speed link.  I
> > don't see any other possible phy interface mode supported that would allow
> > for the 1G, 100M and 10M speeds (i.o.w. SGMII).  If SGMII is not supported,
> > then how do you expect these other speeds to work?
> > 
> > Does your PHY do speed conversion - if so, we need to come up with a much
> > better way of handling that (we need phylib to indicate that the PHY is so
> > capable.)
> 
> These are PHYs connected using an XFI interface that indeed can operate at lower
> speeds and are capable of rate adaptation using pause frames.
> 
> Also, I've used PHY_INTERFACE_MODE_10GKR since a dedicated XFI mode is not available.

XFI is basically what that interface mode for - there's a bunch of
different descriptions for it which seems to depend on the module -
SFI for SFP, XFI for XFP, but essentially it's just 10GBASE-R over a
single serdes lane.

My inclusion of the K in there may not be completely correct as that
is for backplane 10GBASE-R connections, but the public information
available is very limited and incomplete.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

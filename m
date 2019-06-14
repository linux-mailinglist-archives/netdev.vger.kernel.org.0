Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32FE645A3F
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 12:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727192AbfFNKUp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 06:20:45 -0400
Received: from pandora.armlinux.org.uk ([78.32.30.218]:35462 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbfFNKUp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 06:20:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=451wvrpEa7IKuNIuMdA1Zwj+WhlIt6P7naTBSEHRSuU=; b=KxEQxQK7OdFT34SYuMqAZz2t9
        n0HrzoTYGQYb+fraGMcDEFgDTYa+A07i4oUh9fq5IBoU6pbXFQnkgUr+dCUQpnT3XN1vwLAWJcLul
        HOWS4033yIO+TjSeYp9JMgcHCqDaYNMEwgnbfGFC9hPLWEbxfRm8jbchuuDOqUl0jOPhgnjRmwcoR
        KI82kHD5dRiO720BTwByr84c2B/eISfLtGbJjj4CyVE8j7Ya69xwXU7fpuzhoawQ7X3RprbFamg3z
        t+cTlw1BuEIlAURZTpcYEGGVfCZibzxhhmNWV8LclNfBu1n1iZmzeEhslcVUVkX1cw/bYgr0PB/kN
        YEe5ZKiiQ==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:56396)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1hbjK1-0000kA-83; Fri, 14 Jun 2019 11:20:37 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.89)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1hbjJx-00028W-Ba; Fri, 14 Jun 2019 11:20:33 +0100
Date:   Fri, 14 Jun 2019 11:20:33 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     hkallweit1@gmail.com, f.fainelli@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, netdev@vger.kernel.org,
        alexandru.marginean@nxp.com, ruxandra.radulescu@nxp.com
Subject: Re: [PATCH RFC 4/6] dpaa2-mac: add initial driver
Message-ID: <20190614102033.ae427mm7jh73wwkv@shell.armlinux.org.uk>
References: <1560470153-26155-1-git-send-email-ioana.ciornei@nxp.com>
 <1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1560470153-26155-5-git-send-email-ioana.ciornei@nxp.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 02:55:51AM +0300, Ioana Ciornei wrote:
> The dpaa2-mac driver binds to DPAA2 DPMAC objects, dynamically
> discovered on the fsl-mc bus. It acts as a proxy between the PHY
> management layer and the MC firmware, delivering any configuration
> changes to the firmware and also setting any new configuration requested
> though PHYLINK.
> 
> A in-depth view of the software architecture and the implementation can
> be found in
> 'Documentation/networking/device_drivers/freescale/dpaa2/dpmac-driver.rst'.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
>  MAINTAINERS                                      |   7 +
>  drivers/net/ethernet/freescale/dpaa2/Kconfig     |  13 +
>  drivers/net/ethernet/freescale/dpaa2/Makefile    |   2 +
>  drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c | 541 +++++++++++++++++++++++
>  4 files changed, 563 insertions(+)
>  create mode 100644 drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index dd247a059889..a024ab2b2548 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4929,6 +4929,13 @@ S:	Maintained
>  F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp*
>  F:	drivers/net/ethernet/freescale/dpaa2/dprtc*
>  
> +DPAA2 MAC DRIVER
> +M:	Ioana Ciornei <ioana.ciornei@nxp.com>
> +L:	netdev@vger.kernel.org
> +S:	Maintained
> +F:	drivers/net/ethernet/freescale/dpaa2/dpaa2-mac*
> +F:	drivers/net/ethernet/freescale/dpaa2/dpmac*
> +
>  DPT_I2O SCSI RAID DRIVER
>  M:	Adaptec OEM Raid Solutions <aacraid@microsemi.com>
>  L:	linux-scsi@vger.kernel.org
> diff --git a/drivers/net/ethernet/freescale/dpaa2/Kconfig b/drivers/net/ethernet/freescale/dpaa2/Kconfig
> index 8bd384720f80..4ffa666c0a43 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/Kconfig
> +++ b/drivers/net/ethernet/freescale/dpaa2/Kconfig
> @@ -16,3 +16,16 @@ config FSL_DPAA2_PTP_CLOCK
>  	help
>  	  This driver adds support for using the DPAA2 1588 timer module
>  	  as a PTP clock.
> +
> +config FSL_DPAA2_MAC
> +	tristate "DPAA2 MAC / PHY proxy interface"
> +	depends on FSL_MC_BUS
> +	select MDIO_BUS_MUX_MMIOREG
> +	select FSL_XGMAC_MDIO
> +	select PHYLINK
> +	help
> +	  Prototype driver for DPAA2 MAC / PHY interface object.
> +	  This driver works as a proxy between PHYLINK including phy drivers and
> +	  the MC firmware.  It receives updates on link state changes from PHYLINK
> +	  and forwards them to MC and receives interrupt from MC whenever a
> +	  request is made to change the link state or configuration.
> diff --git a/drivers/net/ethernet/freescale/dpaa2/Makefile b/drivers/net/ethernet/freescale/dpaa2/Makefile
> index d1e78cdd512f..e96386ab23ea 100644
> --- a/drivers/net/ethernet/freescale/dpaa2/Makefile
> +++ b/drivers/net/ethernet/freescale/dpaa2/Makefile
> @@ -5,10 +5,12 @@
>  
>  obj-$(CONFIG_FSL_DPAA2_ETH)		+= fsl-dpaa2-eth.o
>  obj-$(CONFIG_FSL_DPAA2_PTP_CLOCK)	+= fsl-dpaa2-ptp.o
> +obj-$(CONFIG_FSL_DPAA2_MAC)		+= fsl-dpaa2-mac.o
>  
>  fsl-dpaa2-eth-objs	:= dpaa2-eth.o dpaa2-ethtool.o dpni.o
>  fsl-dpaa2-eth-${CONFIG_DEBUG_FS} += dpaa2-eth-debugfs.o
>  fsl-dpaa2-ptp-objs	:= dpaa2-ptp.o dprtc.o
> +fsl-dpaa2-mac-objs	:= dpaa2-mac.o dpmac.o
>  
>  # Needed by the tracing framework
>  CFLAGS_dpaa2-eth.o := -I$(src)
> diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> new file mode 100644
> index 000000000000..145ab4771788
> --- /dev/null
> +++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-mac.c
> @@ -0,0 +1,541 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR BSD-3-Clause)
> +/* Copyright 2015 Freescale Semiconductor Inc.
> + * Copyright 2018-2019 NXP
> + */
> +#include <linux/module.h>
> +#include <linux/netdevice.h>
> +#include <linux/etherdevice.h>
> +#include <linux/msi.h>
> +#include <linux/rtnetlink.h>
> +#include <linux/if_vlan.h>
> +
> +#include <net/netlink.h>
> +#include <uapi/linux/if_bridge.h>
> +
> +#include <linux/of.h>
> +#include <linux/of_mdio.h>
> +#include <linux/of_net.h>
> +#include <linux/phylink.h>
> +#include <linux/notifier.h>
> +
> +#include <linux/fsl/mc.h>
> +
> +#include "dpmac.h"
> +#include "dpmac-cmd.h"
> +
> +#define to_dpaa2_mac_priv(phylink_config) \
> +	container_of(config, struct dpaa2_mac_priv, phylink_config)
> +
> +struct dpaa2_mac_priv {
> +	struct fsl_mc_device *mc_dev;
> +	struct dpmac_attr attr;
> +	struct dpmac_link_state state;
> +	u16 dpmac_ver_major;
> +	u16 dpmac_ver_minor;
> +
> +	struct phylink *phylink;
> +	struct phylink_config phylink_config;
> +	struct ethtool_link_ksettings kset;
> +};
> +
> +static phy_interface_t phy_mode(enum dpmac_eth_if eth_if)
> +{
> +	switch (eth_if) {
> +	case DPMAC_ETH_IF_RGMII:
> +		return PHY_INTERFACE_MODE_RGMII;
> +	case DPMAC_ETH_IF_XFI:
> +		return PHY_INTERFACE_MODE_10GKR;
> +	case DPMAC_ETH_IF_USXGMII:
> +		return PHY_INTERFACE_MODE_USXGMII;

No support for SGMII nor the 802.3z modes?

> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static int cmp_dpmac_ver(struct dpaa2_mac_priv *priv,
> +			 u16 ver_major, u16 ver_minor)
> +{
> +	if (priv->dpmac_ver_major == ver_major)
> +		return priv->dpmac_ver_minor - ver_minor;
> +	return priv->dpmac_ver_major - ver_major;
> +}
> +
> +struct dpaa2_mac_link_mode_map {
> +	u64 dpmac_lm;
> +	enum ethtool_link_mode_bit_indices ethtool_lm;
> +};
> +
> +static const struct dpaa2_mac_link_mode_map dpaa2_mac_lm_map[] = {
> +	{DPMAC_ADVERTISED_10BASET_FULL, ETHTOOL_LINK_MODE_10baseT_Full_BIT},
> +	{DPMAC_ADVERTISED_100BASET_FULL, ETHTOOL_LINK_MODE_100baseT_Full_BIT},
> +	{DPMAC_ADVERTISED_1000BASET_FULL, ETHTOOL_LINK_MODE_1000baseT_Full_BIT},
> +	{DPMAC_ADVERTISED_10000BASET_FULL, ETHTOOL_LINK_MODE_10000baseT_Full_BIT},

No half-duplex support?

> +	{DPMAC_ADVERTISED_AUTONEG, ETHTOOL_LINK_MODE_Autoneg_BIT},
> +};
> +
> +static void link_mode_phydev2dpmac(unsigned long *phydev_lm,
> +				   u64 *dpmac_lm)
> +{
> +	enum ethtool_link_mode_bit_indices link_mode;
> +	int i;
> +
> +	*dpmac_lm = 0;
> +	for (i = 0; i < ARRAY_SIZE(dpaa2_mac_lm_map); i++) {
> +		link_mode = dpaa2_mac_lm_map[i].ethtool_lm;
> +		if (linkmode_test_bit(link_mode, phydev_lm))
> +			*dpmac_lm |= dpaa2_mac_lm_map[i].dpmac_lm;
> +	}
> +}
> +
> +static void dpaa2_mac_ksettings_change(struct dpaa2_mac_priv *priv)
> +{
> +	struct fsl_mc_device *mc_dev = priv->mc_dev;
> +	struct dpmac_link_cfg link_cfg = { 0 };
> +	int err, i;
> +
> +	err = dpmac_get_link_cfg(mc_dev->mc_io, 0,
> +				 mc_dev->mc_handle,
> +				 &link_cfg);
> +
> +	if (err) {
> +		dev_err(&mc_dev->dev, "dpmac_get_link_cfg() = %d\n", err);
> +		return;
> +	}
> +
> +	phylink_ethtool_ksettings_get(priv->phylink, &priv->kset);
> +
> +	priv->kset.base.speed = link_cfg.rate;
> +	priv->kset.base.duplex = !!(link_cfg.options & DPMAC_LINK_OPT_HALF_DUPLEX);

What's the point of setting duplex to anything other than true here -
everything I've read in this driver apart from the above indicates
that there is no support for half duplex.

> +
> +	ethtool_link_ksettings_zero_link_mode(&priv->kset, advertising);
> +	for (i = 0; i < ARRAY_SIZE(dpaa2_mac_lm_map); i++) {
> +		if (link_cfg.advertising & dpaa2_mac_lm_map[i].dpmac_lm)
> +			__set_bit(dpaa2_mac_lm_map[i].ethtool_lm,
> +				  priv->kset.link_modes.advertising);
> +	}
> +
> +	if (link_cfg.options & DPMAC_LINK_OPT_AUTONEG) {
> +		priv->kset.base.autoneg = AUTONEG_ENABLE;
> +		__set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +			  priv->kset.link_modes.advertising);
> +	} else {
> +		priv->kset.base.autoneg = AUTONEG_DISABLE;
> +		__clear_bit(ETHTOOL_LINK_MODE_Autoneg_BIT,
> +			    priv->kset.link_modes.advertising);
> +	}
> +
> +	phylink_ethtool_ksettings_set(priv->phylink, &priv->kset);

What if this returns an error?  There seems to be no way to communicate
failure back through the firmware.

> +static void dpaa2_mac_validate(struct phylink_config *config,
> +			       unsigned long *supported,
> +			       struct phylink_link_state *state)
> +{
> +	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
> +	struct dpmac_link_state *dpmac_state = &priv->state;
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	phylink_set(mask, Autoneg);
> +	phylink_set_port_modes(mask);
> +
> +	switch (state->interface) {
> +	case PHY_INTERFACE_MODE_10GKR:
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 10000baseT_Full);
> +		break;
> +	case PHY_INTERFACE_MODE_QSGMII:
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 1000baseT_Full);
> +		break;
> +	case PHY_INTERFACE_MODE_USXGMII:
> +		phylink_set(mask, 10baseT_Full);
> +		phylink_set(mask, 100baseT_Full);
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 10000baseT_Full);

Consider using the newer linkmode_set_bit() etc interfaces here.

> +		break;
> +	default:
> +		goto empty_set;
> +	}
> +
> +	bitmap_and(supported, supported, mask, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +
> +	link_mode_phydev2dpmac(supported, &dpmac_state->supported);
> +	link_mode_phydev2dpmac(state->advertising, &dpmac_state->advertising);

This is not correct.  phylink will make calls to this function to
enquire whether something is supported or not, it isn't strictly used
to say "this is what we are going to use", so storing these does not
reflect the current state.

> +
> +	return;
> +
> +empty_set:
> +	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}
> +
> +static void dpaa2_mac_config(struct phylink_config *config, unsigned int mode,
> +			     const struct phylink_link_state *state)
> +{
> +	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
> +	struct dpmac_link_state *dpmac_state = &priv->state;
> +	struct device *dev = &priv->mc_dev->dev;
> +	int err;
> +
> +	if (state->speed == SPEED_UNKNOWN && state->duplex == DUPLEX_UNKNOWN)
> +		return;
> +
> +	dpmac_state->up = !!state->link;
> +	if (dpmac_state->up) {
> +		dpmac_state->rate = state->speed;
> +
> +		if (!state->duplex)
> +			dpmac_state->options |= DPMAC_LINK_OPT_HALF_DUPLEX;
> +		else
> +			dpmac_state->options &= ~DPMAC_LINK_OPT_HALF_DUPLEX;
> +
> +		if (state->an_enabled)
> +			dpmac_state->options |= DPMAC_LINK_OPT_AUTONEG;
> +		else
> +			dpmac_state->options &= ~DPMAC_LINK_OPT_AUTONEG;
> +	}

Apart from my comments for the above in reply to Andrew, you can store
the "advertising" mask here.

However, what is the point of the "dpmac_state->up = !!state->link"
stuff (despite it being wrong as previously described) when you set
dpmac_state->up in the mac_link_up/mac_link_down functions below.
This makes no sense to me.

> +
> +	err = dpmac_set_link_state(priv->mc_dev->mc_io, 0,
> +				   priv->mc_dev->mc_handle, dpmac_state);
> +	if (err)
> +		dev_err(dev, "dpmac_set_link_state() = %d\n", err);
> +}
> +
> +static void dpaa2_mac_link_up(struct phylink_config *config, unsigned int mode,
> +			      phy_interface_t interface, struct phy_device *phy)
> +{
> +	struct dpaa2_mac_priv *priv = to_dpaa2_mac_priv(phylink_config);
> +	struct dpmac_link_state *dpmac_state = &priv->state;
> +	struct device *dev = &priv->mc_dev->dev;
> +	int err;
> +
> +	dpmac_state->up = 1;
> +	err = dpmac_set_link_state(priv->mc_dev->mc_io, 0,
> +				   priv->mc_dev->mc_handle, dpmac_state);
> +	if (err)
> +		dev_err(dev, "dpmac_set_link_state() = %d\n", err);

This is also very suspect - have you read the phylink documentation?
The documentation details that there are some behavioural differences
here depending on the negotiation mode, but your code doesn't even
look at those.

Given that you're not handling those, I don't see how you expect SFP
support to work.  In fact, given that the validate callback doesn't
make any mention of SGMII, 1000BASEX, or 2500BASEX phy modes, I don't
see how you expect this to work with SFP.  Given that, I really
question why you want to use phylink rather than talking to phylib
directly.

I get the overall impression from what I've seen so far that phylink
is entirely unsuited to the structure of this implementation.

phylinks purpose is to support hotpluggable PHYs on SFP modules where
the MAC may be connected _directly_ to the SFP cage without an
intervening PHY, or if there is an intervening PHY, the PHY is
completely transparent.  For that to work, the interface modes that
SFP modules support must be supported by the MAC.

I can't see a reason at the moment for you to use phylink.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up

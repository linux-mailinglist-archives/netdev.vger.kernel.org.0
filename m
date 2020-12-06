Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533C92D06A4
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 19:56:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbgLFSzW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 13:55:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727617AbgLFSzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Dec 2020 13:55:21 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C336C0613D0;
        Sun,  6 Dec 2020 10:54:41 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id b9so5986700ejy.0;
        Sun, 06 Dec 2020 10:54:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4/ABokGimfgekSq3FuVBoBnGVpPMeIZorXRauyrazvw=;
        b=G/qrCx4082sN/RkP9/Nz2a7QkYlODeUmIsj1RHY+XU3rvjmY+s+StYpDAKO2u3V3Bl
         fPL9HzRBWlK062L1VwJDS2Mcur4rROm+eK7HrpqA7vvHc/kIn+c3ISwt3v7rnqqWCi54
         /wndILCbikvjyKpu7QL08nZsG69qpktymDkpi9IyP765G9i1bSUsu4rlMS2/InDURB1x
         Y+RGVFMDsV9DzaP99TzsFKfcqOLnm+OfAmQSLenQgfY+uvl/rf+ywSBLSAUBDfmXS8ED
         EHZVajM2HKWBIjj+xOxUc65EtQ1O7T5xEeZvn1Yw/SGDwuvDnVjjNYwEDVtRiRFGtJQd
         516Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4/ABokGimfgekSq3FuVBoBnGVpPMeIZorXRauyrazvw=;
        b=PGT+iUUkiu3Yu6Wf+lkLI4NfZVSuQulDqEbfb5riDkCq9N9weV5AC+gxSEA1DqCxGv
         5rHBRVqWu+GcWmSiKyTp1ia+DDcggFPaEaZbdMFHOOuQ2Wuls83SiMoBcpM4FvIP41Di
         8WZzvBTVCqNSMA0IlCkygd3KU12FP2/SdzoGhhMyaBunjLxW2qM+7sSCbg0hm97RLVC6
         gIKp7jDwmXNJOicgB5dgsynv4YFXO3dbMMJdZvHYkASfENb8sa/6ChdhmMztVqksLTxr
         3hRPsp8eHKnfadxbQ5xGiQTHRMBIoRqmZJzUICZPkmY+R6OKpBS3wYBurJmoeGsjsn2y
         sxqQ==
X-Gm-Message-State: AOAM530yhC59yH5LS8MPP9Z+r7MdeRgPLd8NMhXouf+iJbsGYqnq4Fvr
        8ape1NJmE/or89o3qv+gXMU=
X-Google-Smtp-Source: ABdhPJxwqXWesDz6GsUxj0EikLLYOz+86gHiC3NhxUMZMyBxQW5MCFR5YhsTu63qs0usrOtS3+VEhA==
X-Received: by 2002:a17:906:b20f:: with SMTP id p15mr1953525ejz.542.1607280879905;
        Sun, 06 Dec 2020 10:54:39 -0800 (PST)
Received: from skbuf ([188.25.2.120])
        by smtp.gmail.com with ESMTPSA id b9sm8961757eju.8.2020.12.06.10.54.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 10:54:38 -0800 (PST)
Date:   Sun, 6 Dec 2020 20:54:37 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Aleksander Jan Bajkowski <olek2@wp.pl>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, davem@davemloft.net, kuba@kernel.org,
        robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] net: dsa: lantiq: allow to use all GPHYs on
 xRX300 and xRX330
Message-ID: <20201206185437.xvegdomi2loz3vy7@skbuf>
References: <20201206132713.13452-1-olek2@wp.pl>
 <20201206132713.13452-2-olek2@wp.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201206132713.13452-2-olek2@wp.pl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 06, 2020 at 02:27:12PM +0100, Aleksander Jan Bajkowski wrote:
> This patch allows to use all PHYs on GRX300 and GRX330. The ARX300 has 3
> and the GRX330 has 4 integrated PHYs connected to different ports compared
> to VRX200.
> 
> Port configurations:
> 
> xRX200:
> GMAC0: RGMII/MII/REVMII/RMII port
> GMAC1: RGMII/MII/REVMII/RMII port
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII port
> 
> xRX300:
> GMAC0: RGMII port
> GMAC1: GPHY2 (GMII)
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII port
> 
> xRX330:
> GMAC0: RGMII/GMII/RMII port
> GMAC1: GPHY2 (GMII)
> GMAC2: GPHY0 (GMII)
> GMAC3: GPHY0 (MII) or GPHY3 (GMII)
> GMAC4: GPHY1 (GMII)
> GMAC5: GPHY1 (MII) or RGMII/RMII port

When you say GMII/MII when you are talking to the GPHY ports, what you
are really talking about is 1000Base-T vs 100Base-TX, right?

How about xRX330, does that really expose the full parallel GMAC pinout
on GMAC0?

> 
> Tested on D-Link DWR966 with OpenWRT.
> 
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---
>  drivers/net/dsa/lantiq_gswip.c | 170 +++++++++++++++++++++++++++------
>  1 file changed, 141 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
> index 09701c17f3f6..4c8f611ed397 100644
> --- a/drivers/net/dsa/lantiq_gswip.c
> +++ b/drivers/net/dsa/lantiq_gswip.c
> @@ -94,6 +94,7 @@
>  /* GSWIP MII Registers */
>  #define GSWIP_MII_CFG0			0x00
>  #define GSWIP_MII_CFG1			0x02
> +#define GSWIP_MII_CFG3			0xc3
>  #define GSWIP_MII_CFG5			0x04
>  #define  GSWIP_MII_CFG_EN		BIT(14)
>  #define  GSWIP_MII_CFG_LDCLKDIS		BIT(12)
> @@ -102,6 +103,7 @@
>  #define  GSWIP_MII_CFG_MODE_RMIIP	0x2
>  #define  GSWIP_MII_CFG_MODE_RMIIM	0x3
>  #define  GSWIP_MII_CFG_MODE_RGMII	0x4
> +#define  GSWIP_MII_CFG_MODE_GMII	0x9
>  #define  GSWIP_MII_CFG_MODE_MASK	0xf
>  #define  GSWIP_MII_CFG_RATE_M2P5	0x00
>  #define  GSWIP_MII_CFG_RATE_M25	0x10
> @@ -222,6 +224,7 @@
>  struct gswip_hw_info {
>  	int max_ports;
>  	int cpu_port;
> +	struct dsa_switch_ops *ops;
>  };
>  
>  struct xway_gphy_match_data {
> @@ -392,12 +395,19 @@ static void gswip_mii_mask(struct gswip_priv *priv, u32 clear, u32 set,
>  static void gswip_mii_mask_cfg(struct gswip_priv *priv, u32 clear, u32 set,
>  			       int port)
>  {
> +	struct device_node *np = priv->ds->dev->of_node;
> +
>  	switch (port) {
>  	case 0:
>  		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG0);
>  		break;
>  	case 1:
> -		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG1);
> +		if (of_device_is_compatible(np, "lantiq,xrx200-gswip"))
> +			gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG1);
> +		break;
> +	case 3:
> +		if (of_device_is_compatible(np, "lantiq,xrx330-gswip"))
> +			gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG3);
>  		break;
>  	case 5:
>  		gswip_mii_mask(priv, clear, set, GSWIP_MII_CFG5);
> @@ -1409,12 +1419,40 @@ static int gswip_port_fdb_dump(struct dsa_switch *ds, int port,
>  	return 0;
>  }
>  
> -static void gswip_phylink_validate(struct dsa_switch *ds, int port,
> -				   unsigned long *supported,
> -				   struct phylink_link_state *state)
> +static void gswip_phylink_set_capab(unsigned long *supported, struct phylink_link_state *state)
>  {
>  	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
>  
> +	/* Allow all the expected bits */
> +	phylink_set(mask, Autoneg);
> +	phylink_set_port_modes(mask);
> +	phylink_set(mask, Pause);
> +	phylink_set(mask, Asym_Pause);
> +
> +	/* With the exclusion of MII and Reverse MII, we support Gigabit,
> +	 * including Half duplex
> +	 */
> +	if (state->interface != PHY_INTERFACE_MODE_MII &&
> +	    state->interface != PHY_INTERFACE_MODE_REVMII) {
> +		phylink_set(mask, 1000baseT_Full);
> +		phylink_set(mask, 1000baseT_Half);
> +	}
> +
> +	phylink_set(mask, 10baseT_Half);
> +	phylink_set(mask, 10baseT_Full);
> +	phylink_set(mask, 100baseT_Half);
> +	phylink_set(mask, 100baseT_Full);
> +
> +	bitmap_and(supported, supported, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	bitmap_and(state->advertising, state->advertising, mask,
> +		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> +}
> +
> +static void gswip_xrx200_phylink_validate(struct dsa_switch *ds, int port,
> +					  unsigned long *supported,
> +					  struct phylink_link_state *state)
> +{
>  	switch (port) {
>  	case 0:
>  	case 1:
> @@ -1441,37 +1479,56 @@ static void gswip_phylink_validate(struct dsa_switch *ds, int port,
>  		return;
>  	}
>  
> -	/* Allow all the expected bits */
> -	phylink_set(mask, Autoneg);
> -	phylink_set_port_modes(mask);
> -	phylink_set(mask, Pause);
> -	phylink_set(mask, Asym_Pause);
> +	gswip_phylink_set_capab(supported, state);
>  
> -	/* With the exclusion of MII and Reverse MII, we support Gigabit,
> -	 * including Half duplex
> -	 */
> -	if (state->interface != PHY_INTERFACE_MODE_MII &&
> -	    state->interface != PHY_INTERFACE_MODE_REVMII) {
> -		phylink_set(mask, 1000baseT_Full);
> -		phylink_set(mask, 1000baseT_Half);
> +	return;
> +
> +unsupported:
> +	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
> +		phy_modes(state->interface), port);
> +}
> +
> +static void gswip_xrx300_phylink_validate(struct dsa_switch *ds, int port,
> +					  unsigned long *supported,
> +					  struct phylink_link_state *state)
> +{
> +	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
> +
> +	switch (port) {
> +	case 0:
> +		if (!phy_interface_mode_is_rgmii(state->interface) &&
> +		    state->interface != PHY_INTERFACE_MODE_GMII &&
> +		    state->interface != PHY_INTERFACE_MODE_RMII)
> +			goto unsupported;
> +		break;
> +	case 1:
> +	case 2:
> +	case 3:
> +	case 4:
> +		if (state->interface != PHY_INTERFACE_MODE_INTERNAL)
> +			goto unsupported;
> +		break;
> +	case 5:
> +		if (!phy_interface_mode_is_rgmii(state->interface) &&
> +		    state->interface != PHY_INTERFACE_MODE_INTERNAL &&
> +		    state->interface != PHY_INTERFACE_MODE_RMII)
> +			goto unsupported;
> +		break;
> +	default:
> +		bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
> +		dev_err(ds->dev, "Unsupported port: %i\n", port);
> +		return;
>  	}

I think there is a pre-existing issue in gswip_phylink_validate in that
when state->interface == PHY_INTERFACE_MODE_NA, this triggers the "goto
unsupported" code path, when it should instead report all supported link
modes. phylink calls phylink_validate() with PHY_INTERFACE_MODE_NA when
the MII protocol is not known off-hand but depends on what is attached /
what that is configured to advertise.

In your case I think it is a bit unlikely to have a clause 45 PHY that
changes MII protocol dynamically, or an SFP module attached directly to
your GMAC, given that on the port without an internal PHY you only have
parallel interfaces and not a SERDES (note that there still exist RGMII
PHYs - see RTL8211FS - that have an optical media side and can therefore
be connected to an SFP cage, but I don't really know how phylink deals
with those given the structure of sfp_select_interface). So it is mainly
a question of API compliance. Do we want to allow drivers to ignore
something than the API requires, because the driver writers know that
the code path will not be executed in real life.

>  
> -	phylink_set(mask, 10baseT_Half);
> -	phylink_set(mask, 10baseT_Full);
> -	phylink_set(mask, 100baseT_Half);
> -	phylink_set(mask, 100baseT_Full);
> +	gswip_phylink_set_capab(supported, state);
>  
> -	bitmap_and(supported, supported, mask,
> -		   __ETHTOOL_LINK_MODE_MASK_NBITS);
> -	bitmap_and(state->advertising, state->advertising, mask,
> -		   __ETHTOOL_LINK_MODE_MASK_NBITS);
>  	return;
>  
>  unsupported:
>  	bitmap_zero(supported, __ETHTOOL_LINK_MODE_MASK_NBITS);
>  	dev_err(ds->dev, "Unsupported interface '%s' for port %d\n",
>  		phy_modes(state->interface), port);
> -	return;
>  }
>  
>  static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
> @@ -1500,6 +1557,9 @@ static void gswip_phylink_mac_config(struct dsa_switch *ds, int port,
>  	case PHY_INTERFACE_MODE_RGMII_TXID:
>  		miicfg |= GSWIP_MII_CFG_MODE_RGMII;
>  		break;
> +	case PHY_INTERFACE_MODE_GMII:
> +		miicfg |= GSWIP_MII_CFG_MODE_GMII;
> +		break;
>  	default:
>  		dev_err(ds->dev,
>  			"Unsupported interface: %d\n", state->interface);
> @@ -1614,7 +1674,7 @@ static int gswip_get_sset_count(struct dsa_switch *ds, int port, int sset)
>  	return ARRAY_SIZE(gswip_rmon_cnt);
>  }
>  
> -static const struct dsa_switch_ops gswip_switch_ops = {
> +static const struct dsa_switch_ops gswip_xrx200_switch_ops = {
>  	.get_tag_protocol	= gswip_get_tag_protocol,
>  	.setup			= gswip_setup,
>  	.port_enable		= gswip_port_enable,
> @@ -1630,7 +1690,32 @@ static const struct dsa_switch_ops gswip_switch_ops = {
>  	.port_fdb_add		= gswip_port_fdb_add,
>  	.port_fdb_del		= gswip_port_fdb_del,
>  	.port_fdb_dump		= gswip_port_fdb_dump,
> -	.phylink_validate	= gswip_phylink_validate,
> +	.phylink_validate	= gswip_xrx200_phylink_validate,
> +	.phylink_mac_config	= gswip_phylink_mac_config,
> +	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
> +	.phylink_mac_link_up	= gswip_phylink_mac_link_up,
> +	.get_strings		= gswip_get_strings,
> +	.get_ethtool_stats	= gswip_get_ethtool_stats,
> +	.get_sset_count		= gswip_get_sset_count,
> +};
> +
> +static const struct dsa_switch_ops gswip_xrx300_switch_ops = {
> +	.get_tag_protocol	= gswip_get_tag_protocol,
> +	.setup			= gswip_setup,
> +	.port_enable		= gswip_port_enable,
> +	.port_disable		= gswip_port_disable,
> +	.port_bridge_join	= gswip_port_bridge_join,
> +	.port_bridge_leave	= gswip_port_bridge_leave,
> +	.port_fast_age		= gswip_port_fast_age,
> +	.port_vlan_filtering	= gswip_port_vlan_filtering,
> +	.port_vlan_prepare	= gswip_port_vlan_prepare,
> +	.port_vlan_add		= gswip_port_vlan_add,
> +	.port_vlan_del		= gswip_port_vlan_del,
> +	.port_stp_state_set	= gswip_port_stp_state_set,
> +	.port_fdb_add		= gswip_port_fdb_add,
> +	.port_fdb_del		= gswip_port_fdb_del,
> +	.port_fdb_dump		= gswip_port_fdb_dump,
> +	.phylink_validate	= gswip_xrx300_phylink_validate,
>  	.phylink_mac_config	= gswip_phylink_mac_config,
>  	.phylink_mac_link_down	= gswip_phylink_mac_link_down,
>  	.phylink_mac_link_up	= gswip_phylink_mac_link_up,
> @@ -1859,7 +1944,7 @@ static int gswip_gphy_fw_list(struct gswip_priv *priv,
>  static int gswip_probe(struct platform_device *pdev)
>  {
>  	struct gswip_priv *priv;
> -	struct device_node *mdio_np, *gphy_fw_np;
> +	struct device_node *np, *mdio_np, *gphy_fw_np;
>  	struct device *dev = &pdev->dev;
>  	int err;
>  	int i;
> @@ -1892,10 +1977,28 @@ static int gswip_probe(struct platform_device *pdev)
>  	priv->ds->dev = dev;
>  	priv->ds->num_ports = priv->hw_info->max_ports;
>  	priv->ds->priv = priv;
> -	priv->ds->ops = &gswip_switch_ops;
> +	priv->ds->ops = priv->hw_info->ops;
>  	priv->dev = dev;
>  	version = gswip_switch_r(priv, GSWIP_VERSION);
>  
> +	np = dev->of_node;
> +	switch (version) {
> +	case GSWIP_VERSION_2_0:
> +	case GSWIP_VERSION_2_1:
> +		if (!of_device_is_compatible(np, "lantiq,xrx200-gswip"))
> +			return -EINVAL;
> +		break;
> +	case GSWIP_VERSION_2_2:
> +	case GSWIP_VERSION_2_2_ETC:
> +		if (!of_device_is_compatible(np, "lantiq,xrx300-gswip") &&
> +		    !of_device_is_compatible(np, "lantiq,xrx330-gswip"))
> +			return -EINVAL;
> +		break;
> +	default:
> +		dev_err(dev, "unknown GSWIP version: 0x%x", version);
> +		return -ENOENT;
> +	}
> +
>  	/* bring up the mdio bus */
>  	gphy_fw_np = of_get_compatible_child(dev->of_node, "lantiq,gphy-fw");
>  	if (gphy_fw_np) {
> @@ -1973,10 +2076,19 @@ static int gswip_remove(struct platform_device *pdev)
>  static const struct gswip_hw_info gswip_xrx200 = {
>  	.max_ports = 7,
>  	.cpu_port = 6,
> +	.ops = &gswip_xrx200_switch_ops,
> +};
> +
> +static const struct gswip_hw_info gswip_xrx300 = {
> +	.max_ports = 7,
> +	.cpu_port = 6,
> +	.ops = &gswip_xrx300_switch_ops,
>  };
>  
>  static const struct of_device_id gswip_of_match[] = {
>  	{ .compatible = "lantiq,xrx200-gswip", .data = &gswip_xrx200 },
> +	{ .compatible = "lantiq,xrx300-gswip", .data = &gswip_xrx300 },
> +	{ .compatible = "lantiq,xrx330-gswip", .data = &gswip_xrx300 },
>  	{},
>  };
>  MODULE_DEVICE_TABLE(of, gswip_of_match);
> -- 
> 2.20.1
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670DB425CC6
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 22:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241948AbhJGUCI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 16:02:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241572AbhJGUCE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 16:02:04 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26CD6C061570;
        Thu,  7 Oct 2021 13:00:09 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id b8so27426184edk.2;
        Thu, 07 Oct 2021 13:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hh+lZNjSIkT05bnwk/EJFj/zP4KhI9GsRMQVL0dXo6k=;
        b=iyvuKGxfEww0uhMQNVAcTNSgTmYdaQwJDgCed3BdmB7PSVqALnfBFPflob7YCcnGr1
         fOvSupGUbJu1vCYe6YUUOXhXwNyjfu89/IcJEE1RqNFK++4z473HeYammp/AsZ4SGEaf
         MF9+EPy8OJsmMj0M0ajckVQb6+xjFi27gI9g7NZEpF13dMLTWXPFWtFpDEg33s2HBVZP
         PdplrLh6tnupDYKxzA6thl8c00bQxCCMzq290YtJ5LmoLO6Yh5n3aoafw6qwahRFGRz2
         kdGRPM9V3cO77zXrqErApVEnB1LOUiLTCbIdff6KiuUdua/nA3r2TWz/tgFLDRZk6g7z
         YniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hh+lZNjSIkT05bnwk/EJFj/zP4KhI9GsRMQVL0dXo6k=;
        b=qpoUg5I8UibTSLKuWQxrniFvMhJQ+MVM3tLjsXXubTyT1prXwG4ZvfD9oK4o0ls3Tp
         FmHxq0FA1MrknetzpwI4FXKA7tzmscRtJRAnJ7hgXNxDPRmnh6H+cxdJfPp2u3vJfmm5
         ITA1/4H8q5nT/2rLo7ivpODQ/krxawaGXzjUard6vGyUhp3dbMZitXYYAbQP9TXd6ujP
         iSItfU8+zvYn/vwVXh9+kkP5YLIBxq0qEiY2Iw74vj/ZP+5BNFEBW/v0UcaJXKNG/eth
         6PjA/5PThuHfP8XXVPIAtgv8ol97MxgI92Oj2/GvBuevH5Eav90eFnII9yhq7Jdmarxt
         e26w==
X-Gm-Message-State: AOAM530fU6Q7trawBclEFPibLb4dNC39LzYfm62NYolQgyDi/BtSOSfo
        EnUsk725A/zoJqHpqrLbgA0=
X-Google-Smtp-Source: ABdhPJxN4R7Sew9KLEp88Dbje2xzHjLns7IakfFkt0VGPlTOw/oukFsco3kGoKMIN27lYeDLFLkYrA==
X-Received: by 2002:a17:906:1bb1:: with SMTP id r17mr8108666ejg.533.1633636807563;
        Thu, 07 Oct 2021 13:00:07 -0700 (PDT)
Received: from skbuf ([188.26.53.217])
        by smtp.gmail.com with ESMTPSA id e22sm173182edu.35.2021.10.07.13.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 13:00:07 -0700 (PDT)
Date:   Thu, 7 Oct 2021 23:00:05 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v4 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20211007200005.3ze43py7ma4omn7r@skbuf>
References: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
 <20211007151200.748944-6-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007151200.748944-6-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 08:41:55PM +0530, Prasanna Vengateshan wrote:
> +static int lan937x_mdio_register(struct dsa_switch *ds)
> +{
> +	struct device_node *mdio_np;
> +	int ret;
> +
> +	mdio_np = of_get_child_by_name(ds->dev->of_node, "mdio");
> +	if (!mdio_np) {
> +		dev_err(ds->dev, "no MDIO bus node\n");
> +		return -ENODEV;
> +	}
> +
> +	ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
> +	if (!ds->slave_mii_bus)
> +		return -ENOMEM;
> +
> +	ds->slave_mii_bus->priv = ds->priv;
> +	ds->slave_mii_bus->read = lan937x_sw_mdio_read;
> +	ds->slave_mii_bus->write = lan937x_sw_mdio_write;
> +	ds->slave_mii_bus->name = "lan937x slave smi";
> +	snprintf(ds->slave_mii_bus->id, MII_BUS_ID_SIZE, "SMI-%d", ds->index);
> +	ds->slave_mii_bus->parent = ds->dev;
> +	ds->slave_mii_bus->phy_mask = ~ds->phys_mii_mask;
> +
> +	ret = of_mdiobus_register(ds->slave_mii_bus, mdio_np);

Please use devm_of_mdiobus_register if you're going to use
devm_mdiobus_alloc, or no devres at all.
https://patchwork.kernel.org/project/netdevbpf/patch/20210920214209.1733768-3-vladimir.oltean@nxp.com/

> +	if (ret) {
> +		dev_err(ds->dev, "unable to register MDIO bus %s\n",
> +			ds->slave_mii_bus->id);
> +	}
> +
> +	of_node_put(mdio_np);
> +
> +	return ret;
> +}
> +
> +static phy_interface_t lan937x_get_interface(struct ksz_device *dev, int port)
> +{
> +	phy_interface_t interface;
> +	u8 data8;
> +	int ret;
> +
> +	if (lan937x_is_internal_phy_port(dev, port))
> +		return PHY_INTERFACE_MODE_NA;

Typically we use PHY_INTERFACE_MODE_INTERNAL.

> +
> +	/* read interface from REG_PORT_XMII_CTRL_1 register */
> +	ret = lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> +	if (ret < 0)
> +		return PHY_INTERFACE_MODE_NA;
> +
> +	switch (data8 & PORT_MII_SEL_M) {
> +	case PORT_RMII_SEL:
> +		interface = PHY_INTERFACE_MODE_RMII;
> +		break;
> +	case PORT_RGMII_SEL:
> +		interface = PHY_INTERFACE_MODE_RGMII;
> +		if (data8 & PORT_RGMII_ID_EG_ENABLE)
> +			interface = PHY_INTERFACE_MODE_RGMII_TXID;
> +		if (data8 & PORT_RGMII_ID_IG_ENABLE) {
> +			interface = PHY_INTERFACE_MODE_RGMII_RXID;
> +			if (data8 & PORT_RGMII_ID_EG_ENABLE)
> +				interface = PHY_INTERFACE_MODE_RGMII_ID;
> +		}
> +		break;
> +	case PORT_MII_SEL:
> +	default:
> +		/* Interface is MII */
> +		interface = PHY_INTERFACE_MODE_MII;
> +		break;
> +	}
> +
> +	return interface;
> +}
> +
> +static void lan937x_config_cpu_port(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port *p;
> +	int i;
> +
> +	ds->num_ports = dev->port_cnt;
> +
> +	for (i = 0; i < dev->port_cnt; i++) {
> +		if (dsa_is_cpu_port(ds, i) && (dev->cpu_ports & (1 << i))) {
> +			phy_interface_t interface;
> +
> +			dev->cpu_port = i;
> +			dev->host_mask = (1 << dev->cpu_port);
> +			dev->port_mask |= dev->host_mask;
> +			p = &dev->ports[i];
> +
> +			/* Check if the device tree have specific interface
> +			 * setting otherwise read & assign from XMII register
> +			 * for host port interface
> +			 */
> +			interface = lan937x_get_interface(dev, i);

What does the CPU port have so special that you override it here?
Again some compatibility with out-of-tree DT bindings?

> +			if (!p->interface)
> +				p->interface = interface;
> +
> +			dev_info(dev->dev,
> +				 "Port%d: using phy mode %s\n",
> +				 i,
> +				 phy_modes(p->interface));
> +
> +			/* enable cpu port */
> +			lan937x_port_setup(dev, i, true);
> +			p->vid_member = dev->port_mask;
> +		}
> +	}
> +
> +static u8 lan937x_rgmii_dly_reg_val(int port, u32 val)
> +{
> +	u8 reg_val;
> +
> +	/* force minimum delay if delay is less than min delay */
> +	if (val && val < 2170)
> +		val = 2170;
> +
> +	/* maximum delay is 4ns */
> +	if (val > 4000)
> +		val = 4000;

These bindings are new. Given that you also document their min and max
values, why don't you just error out on out-of-range values instead of
silently doing what you think is going to be fine?

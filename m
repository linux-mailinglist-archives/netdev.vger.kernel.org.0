Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C976368781
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 21:59:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239028AbhDVUAK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 16:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236058AbhDVUAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 16:00:09 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D4F5C06174A;
        Thu, 22 Apr 2021 12:59:34 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id w6so17947401pfc.8;
        Thu, 22 Apr 2021 12:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WjYscUTc6U3lEgrRubbvOnvvEfZzGBp8aZMGC5uPa2k=;
        b=vXgEChEptvsxNhNU9sk4WK8xEDboVjSrz7spQdAC1apcGpERtPM4fkNYOrTKuqKP6E
         x+Jmi3RtKGm+a1ttDdt1qyIOfac2chuPqvXk5k8R0Cg4Led1SaJA+GvAp4+HNTWPk10F
         m+Os3I5YY65UFCfe01zuLC3ier5kXKCQ3N6xCOg/832PQ5XUfQS2lv/Ka22yTQlXsabH
         lsIi3brtpk6QdFJfB/r/eVf3EvOtMoguaFONxi3fq4fvkIzbwjKrPEAVMqkyylGL0yKN
         FtO1FmMkEe1qYdb886OWVFkavMcDUGwnYQLJ6s/wdWT6wPTwXEM6pmuMdeW8zZQvVVeT
         ZAWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WjYscUTc6U3lEgrRubbvOnvvEfZzGBp8aZMGC5uPa2k=;
        b=QtD8Hm0lSsU/Emgzwqs89YJFJQk2e4H2sAQoVyXga+tLsle6Dlo7Fv17eDYKQipgmg
         rN/pzlIjWTdK/HqjREBW0OvPIB/pFTEIvRczTzNCFqnESKNAzSzpRhUtjgt03H0j0TlG
         /kb0lBWLTzdgOfgiFzDbK0w1BMzUyxKigv57WDwOUMsA6K5sRfAmWuPxHoqlWvuAFhab
         J8c2ewfGWhOjy2taDYt2lC8Goj10AuGU7uUnambLVlgHu9Min9i/ujVoEKPeufglgIJF
         Jcd13jBxYPCABy/Zt+jxrh1D2cfecwGQFdZkIecJ9iBakx00ceMLS+/bKtMto8Iylw3c
         BlYw==
X-Gm-Message-State: AOAM533kOtwG8E1SS6gcpgRK6ZhCG2GIxlzoEz3bFRWOKEueQ6WcJ+Ek
        UWmRHg+bGWXmasMae0oOKZ4=
X-Google-Smtp-Source: ABdhPJwG0PKqktx5FI9WqG9a08mX45QvFPrTiWXkyZGvbGuA4U4WZvY7aPdQS0VO0PpaKj0aAGaiOg==
X-Received: by 2002:a63:930d:: with SMTP id b13mr316874pge.213.1619121573465;
        Thu, 22 Apr 2021 12:59:33 -0700 (PDT)
Received: from skbuf (5-12-16-165.residential.rdsnet.ro. [5.12.16.165])
        by smtp.gmail.com with ESMTPSA id ga21sm3059247pjb.5.2021.04.22.12.59.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Apr 2021 12:59:32 -0700 (PDT)
Date:   Thu, 22 Apr 2021 22:59:21 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 net-next 4/9] net: dsa: microchip: add DSA support for
 microchip lan937x
Message-ID: <20210422195921.utxdh5dn4ddltxkf@skbuf>
References: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
 <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422094257.1641396-5-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 03:12:52PM +0530, Prasanna Vengateshan wrote:
> Basic DSA driver support for lan937x and the device will be
> configured through SPI interface.
> 
> drivers/net/dsa/microchip/ path is already part of MAINTAINERS &
> the new files come under this path. Hence no update needed to the
> MAINTAINERS
> 
> Reused KSZ APIs for port_bridge_join() & port_bridge_leave() and
> added support for port_stp_state_set() & port_fast_age().
> 
> lan937x_flush_dyn_mac_table() which gets called from
> port_fast_age() of KSZ common layer, hence added support for it.
> 
> currently port_bridge_flags returns -EOPNOTSUPP, this support
> will be added later
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> ---
(...)
> +int lan937x_reset_switch(struct ksz_device *dev)
> +{
> +	u32 data32;
> +	u8 data8;
> +	int rc;
> +
> +	/* reset switch */
> +	rc = lan937x_cfg(dev, REG_SW_OPERATION, SW_RESET, true);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* default configuration */
> +	rc = ksz_read8(dev, REG_SW_LUE_CTRL_1, &data8);
> +	if (rc < 0)
> +		return rc;
> +
> +	data8 = SW_AGING_ENABLE | SW_LINK_AUTO_AGING |
> +	      SW_SRC_ADDR_FILTER;
> +
> +	rc = ksz_write8(dev, REG_SW_LUE_CTRL_1, data8);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* disable interrupts */
> +	rc = ksz_write32(dev, REG_SW_INT_MASK__4, SWITCH_INT_MASK);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = ksz_write32(dev, REG_SW_PORT_INT_MASK__4, 0xFF);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = ksz_read32(dev, REG_SW_PORT_INT_STATUS__4, &data32);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* set broadcast storm protection 10% rate */
> +	rc = regmap_update_bits(dev->regmap[1], REG_SW_MAC_CTRL_2,
> +				BROADCAST_STORM_RATE,
> +			   (BROADCAST_STORM_VALUE *
> +			   BROADCAST_STORM_PROT_RATE) / 100);

Why do you think this is a sane enough configuration to enable by
default? We have tc-flower policers for this kind of stuff. If the
broadcast policer is global to the switch and not per port, you can
model it using:

tc qdisc add dev lan1 ingress_block 1 clsact
tc qdisc add dev lan2 ingress_block 1 clsact
tc qdisc add dev lan3 ingress_block 1 clsact
tc filter add block 1 flower skip_sw dst_mac ff:ff:ff:ff:ff:ff \
	action police \
	rate 43Mbit \
	burst 10000

> +
> +	return rc;
> +}
> +
(...)
> +int lan937x_internal_phy_write(struct ksz_device *dev, int addr,
> +			       int reg, u16 val)
> +{
> +	u16 temp, addr_base;
> +	unsigned int value;
> +	int rc;
> +
> +	/* Check for internal phy port */
> +	if (!lan937x_is_internal_phy_port(dev, addr))
> +		return -EOPNOTSUPP;
> +
> +	if (lan937x_is_internal_100BTX_phy_port(dev, addr))
> +		addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> +	else
> +		addr_base = REG_PORT_T1_PHY_CTRL_BASE;
> +
> +	temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
> +
> +	rc = ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* Write the data to be written to the VPHY reg */
> +	rc = ksz_write16(dev, REG_VPHY_IND_DATA__2, val);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* Write the Write En and Busy bit */
> +	rc = ksz_write16(dev, REG_VPHY_IND_CTRL__2, (VPHY_IND_WRITE
> +				| VPHY_IND_BUSY));

This isn't quite the coding style that the kernel community is used to
seeing. This looks more adequate:

	rc = ksz_write16(dev, REG_VPHY_IND_CTRL__2,
			 (VPHY_IND_WRITE | VPHY_IND_BUSY));

> +	if (rc < 0)
> +		return rc;
> +
> +	rc = regmap_read_poll_timeout(dev->regmap[1],
> +				      REG_VPHY_IND_CTRL__2,
> +				value, !(value & VPHY_IND_BUSY), 10, 1000);

very, very odd indentation.

> +
> +	/* failed to write phy register. get out of loop */

What loop? The regmap_read_poll_timeout? If you're here you're already
out of it, aren't you?

> +	if (rc < 0) {
> +		dev_err(dev->dev, "Failed to write phy register\n");
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +int lan937x_internal_phy_read(struct ksz_device *dev, int addr,
> +			      int reg, u16 *val)
> +{
> +	u16 temp, addr_base;
> +	unsigned int value;
> +	int rc;
> +
> +	/* Check for internal phy port, return 0xffff for non-existent phy*/
> +	if (!lan937x_is_internal_phy_port(dev, addr))
> +		return 0xffff;
> +
> +	if (lan937x_is_internal_100BTX_phy_port(dev, addr))
> +		addr_base = REG_PORT_TX_PHY_CTRL_BASE;
> +	else
> +		addr_base = REG_PORT_T1_PHY_CTRL_BASE;
> +
> +	/* get register address based on the logical port */
> +	temp = PORT_CTRL_ADDR(addr, (addr_base + (reg << 2)));
> +
> +	rc = ksz_write16(dev, REG_VPHY_IND_ADDR__2, temp);
> +	if (rc < 0)
> +		return rc;
> +
> +	/* Write Read and Busy bit to start the transaction*/
> +	rc = ksz_write16(dev, REG_VPHY_IND_CTRL__2, VPHY_IND_BUSY);
> +	if (rc < 0)
> +		return rc;
> +
> +	rc = regmap_read_poll_timeout(dev->regmap[1],
> +				      REG_VPHY_IND_CTRL__2,
> +				value, !(value & VPHY_IND_BUSY), 10, 1000);
> +
> +	/*  failed to read phy register. get out of loop */
> +	if (rc < 0) {
> +		dev_err(dev->dev, "Failed to read phy register\n");
> +		return rc;
> +	}
> +
> +	/* Read the VPHY register which has the PHY data*/
> +	rc = ksz_read16(dev, REG_VPHY_IND_DATA__2, val);
> +
> +	return rc;
> +}
> +
> +static void lan937x_set_gbit(struct ksz_device *dev, bool gbit, u8 *data)
> +{
> +	if (gbit)
> +		*data &= ~PORT_MII_NOT_1GBIT;
> +	else
> +		*data |= PORT_MII_NOT_1GBIT;
> +}
> +
> +void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port)
> +{
> +	struct ksz_port *p = &dev->ports[port];
> +	u8 data8, member;
> +
> +	/* enable tag tail for host port */
> +	if (cpu_port) {
> +		lan937x_port_cfg(dev, port, REG_PORT_CTRL_0, PORT_TAIL_TAG_ENABLE,
> +				 true);
> +		/* Enable jumbo packet in host port so that frames are not
> +		 * counted as oversized.
> +		 */
> +		lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_JUMBO_PACKET,
> +				 true);
> +		lan937x_pwrite16(dev, port, REG_PORT_MTU__2, FR_SIZE_CPU_PORT);
> +	}
> +
> +	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_FR_CHK_LENGTH,
> +			 false);
> +
> +	lan937x_port_cfg(dev, port, REG_PORT_CTRL_0, PORT_MAC_LOOPBACK, false);
> +
> +	/* set back pressure */
> +	lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_1, PORT_BACK_PRESSURE, true);
> +
> +	/* enable broadcast storm limit */
> +	lan937x_port_cfg(dev, port, P_BCAST_STORM_CTRL, PORT_BROADCAST_STORM, true);
> +
> +	/* disable DiffServ priority */
> +	lan937x_port_cfg(dev, port, P_PRIO_CTRL, PORT_DIFFSERV_PRIO_ENABLE, false);
> +
> +	/* replace priority */
> +	lan937x_port_cfg(dev, port, REG_PORT_MRI_MAC_CTRL, PORT_USER_PRIO_CEILING,
> +			 false);
> +	lan937x_port_cfg32(dev, port, REG_PORT_MTI_QUEUE_CTRL_0__4,
> +			   MTI_PVID_REPLACE, false);
> +
> +	/* enable 802.1p priority */
> +	lan937x_port_cfg(dev, port, P_PRIO_CTRL, PORT_802_1P_PRIO_ENABLE, true);
> +
> +	if (!lan937x_is_internal_phy_port(dev, port)) {
> +		/* force flow control off*/
> +		lan937x_port_cfg(dev, port, REG_PORT_XMII_CTRL_0,
> +				 PORT_FORCE_TX_FLOW_CTRL | PORT_FORCE_RX_FLOW_CTRL,
> +			     false);

Why do you force flow control off? Doesn't this PHY support PAUSE
autoneg, and doesn't phylink give you rx_pause/tx_pause from the flow
control resolution?

> +
> +		lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> +
> +		/* clear MII selection & set it based on interface later */
> +		data8 &= ~PORT_MII_SEL_M;
> +
> +		/* configure MAC based on p->interface */
> +		switch (p->interface) {
> +		case PHY_INTERFACE_MODE_MII:
> +			lan937x_set_gbit(dev, false, &data8);
> +			data8 |= PORT_MII_SEL;
> +			break;
> +		case PHY_INTERFACE_MODE_RMII:
> +			lan937x_set_gbit(dev, false, &data8);
> +			data8 |= PORT_RMII_SEL;
> +			break;
> +		default:
> +			lan937x_set_gbit(dev, true, &data8);
> +			data8 |= PORT_RGMII_SEL;
> +
> +			data8 &= ~PORT_RGMII_ID_IG_ENABLE;
> +			data8 &= ~PORT_RGMII_ID_EG_ENABLE;
> +
> +			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +			    p->interface == PHY_INTERFACE_MODE_RGMII_RXID)
> +				data8 |= PORT_RGMII_ID_IG_ENABLE;
> +
> +			if (p->interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +			    p->interface == PHY_INTERFACE_MODE_RGMII_TXID)
> +				data8 |= PORT_RGMII_ID_EG_ENABLE;

This is interesting. If you have an RGMII port connected to an external
PHY, how do you ensure that either the lan937x driver, or the PHY driver,
but not both, enable RGMII delays? Was RGMII tested with a PHY or just
fixed-link?

> +			break;
> +		}
> +		lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
> +	}
> +
> +	if (cpu_port)
> +		member = dev->port_mask;
> +	else
> +		member = dev->host_mask | p->vid_member;
> +
> +	lan937x_cfg_port_member(dev, port, member);
> +}
> +
> +static int lan937x_sw_mdio_read(struct mii_bus *bus, int addr, int regnum)
> +{
> +	struct ksz_device *dev = bus->priv;
> +	u16 val;
> +	int rc;
> +
> +	rc = lan937x_internal_phy_read(dev, addr, regnum, &val);
> +	if (rc < 0)
> +		return rc;
> +
> +	return val;
> +}
> +
> +static int lan937x_sw_mdio_write(struct mii_bus *bus, int addr, int regnum, u16 val)
> +{
> +	struct ksz_device *dev = bus->priv;
> +
> +	return lan937x_internal_phy_write(dev, addr, regnum, val);
> +}
> +
> +static int lan937x_mdio_register(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret;
> +
> +	dev->mdio_np = of_get_compatible_child(ds->dev->of_node, "microchip,lan937x-mdio");

I think it is strange to have a node with a compatible string but no
dedicated driver? I think the most popular option is to set:

	dev->mdio_np = of_get_child_by_name(node, "mdio");

and just create an "mdio" subnode with no compatible.

> +
> +	if (!dev->mdio_np) {
> +		dev_err(ds->dev, "no MDIO bus node\n");
> +		return -ENODEV;
> +	}
> +
> +	ds->slave_mii_bus = devm_mdiobus_alloc(ds->dev);
> +
> +	if (!ds->slave_mii_bus)
> +		return -ENOMEM;
> +
> +	ds->slave_mii_bus->priv = ds->priv;
> +	ds->slave_mii_bus->read = lan937x_sw_mdio_read;
> +	ds->slave_mii_bus->write = lan937x_sw_mdio_write;
> +	ds->slave_mii_bus->name = "lan937x slave smi";
> +	snprintf(ds->slave_mii_bus->id, MII_BUS_ID_SIZE, "SMI-%d",
> +		 ds->index);
> +	ds->slave_mii_bus->parent = ds->dev;
> +	ds->slave_mii_bus->phy_mask = ~ds->phys_mii_mask;
> +
> +	ret = of_mdiobus_register(ds->slave_mii_bus, dev->mdio_np);
> +
> +	if (ret) {
> +		dev_err(ds->dev, "unable to register MDIO bus %s\n",
> +			ds->slave_mii_bus->id);
> +		of_node_put(dev->mdio_np);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int lan937x_switch_init(struct ksz_device *dev)
> +{
> +	int i, ret;
> +
> +	dev->ds->ops = &lan937x_switch_ops;
> +
> +	/* Check device tree */
> +	ret = lan937x_check_device_id(dev);
> +
> +	if (ret)
> +		return ret;
> +
> +	dev->port_mask = (1 << dev->port_cnt) - 1;
> +
> +	dev->reg_mib_cnt = SWITCH_COUNTER_NUM;
> +	dev->mib_cnt = ARRAY_SIZE(lan937x_mib_names);
> +
> +	dev->ports = devm_kzalloc(dev->dev,
> +				  dev->port_cnt * sizeof(struct ksz_port),
> +				  GFP_KERNEL);
> +	if (!dev->ports)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < dev->port_cnt; i++) {
> +		mutex_init(&dev->ports[i].mib.cnt_mutex);
> +		dev->ports[i].mib.counters =
> +			devm_kzalloc(dev->dev,
> +				     sizeof(u64) *
> +				     (dev->mib_cnt + 1),
> +				     GFP_KERNEL);
> +		if (!dev->ports[i].mib.counters)
> +			return -ENOMEM;
> +	}
> +
> +	/* set the real number of ports */
> +	dev->ds->num_ports = dev->port_cnt;
> +	return 0;
> +}
> +
> +static int lan937x_init(struct ksz_device *dev)
> +{
> +	int rc;
> +
> +	rc = lan937x_switch_init(dev);
> +	if (rc < 0) {
> +		dev_err(dev->dev, "failed to initialize the switch");
> +		return rc;
> +	}
> +
> +	/* enable Indirect Access from SPI to the VPHY registers */
> +	rc = lan937x_enable_spi_indirect_access(dev);
> +	if (rc < 0) {
> +		dev_err(dev->dev, "failed to enable spi indirect access");
> +		return rc;
> +	}
> +
> +	rc = lan937x_mdio_register(dev->ds);
> +	if (rc < 0) {
> +		dev_err(dev->dev, "failed to register the mdio");
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +const struct ksz_dev_ops lan937x_dev_ops = {
> +	.get_port_addr = lan937x_get_port_addr,
> +	.cfg_port_member = lan937x_cfg_port_member,
> +	.flush_dyn_mac_table = lan937x_flush_dyn_mac_table,
> +	.port_setup = lan937x_port_setup,
> +	.r_mib_cnt = lan937x_r_mib_cnt,
> +	.r_mib_pkt = lan937x_r_mib_pkt,
> +	.port_init_cnt = lan937x_port_init_cnt,
> +	.shutdown = lan937x_reset_switch,
> +	.detect = lan937x_switch_detect,
> +	.init = lan937x_init,
> +	.exit = lan937x_switch_exit,
> +};
> diff --git a/drivers/net/dsa/microchip/lan937x_dev.h b/drivers/net/dsa/microchip/lan937x_dev.h
> new file mode 100644
> index 000000000000..c98e8140ca30
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/lan937x_dev.h
> @@ -0,0 +1,68 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Microchip lan937x dev ops headers
> + * Copyright (C) 2019-2021 Microchip Technology Inc.
> + */
> +
> +#ifndef __LAN937X_CFG_H
> +#define __LAN937X_CFG_H
> +
> +int lan937x_cfg(struct ksz_device *dev, u32 addr, u8 bits, bool set);
> +int lan937x_port_cfg(struct ksz_device *dev, int port, int offset,
> +		     u8 bits, bool set);
> +int lan937x_cfg32(struct ksz_device *dev, u32 addr, u32 bits, bool set);
> +int lan937x_pread8(struct ksz_device *dev, int port, int offset,
> +		   u8 *data);
> +int lan937x_pread16(struct ksz_device *dev, int port, int offset,
> +		    u16 *data);
> +int lan937x_pread32(struct ksz_device *dev, int port, int offset,
> +		    u32 *data);
> +int lan937x_pwrite8(struct ksz_device *dev, int port,
> +		    int offset, u8 data);
> +int lan937x_pwrite16(struct ksz_device *dev, int port,
> +		     int offset, u16 data);
> +int lan937x_pwrite32(struct ksz_device *dev, int port,
> +		     int offset, u32 data);
> +int lan937x_port_cfg32(struct ksz_device *dev, int port, int offset,
> +		       u32 bits, bool set);
> +int lan937x_internal_phy_write(struct ksz_device *dev, int addr,
> +			       int reg, u16 val);
> +int lan937x_internal_phy_read(struct ksz_device *dev, int addr,
> +			      int reg, u16 *val);
> +bool lan937x_is_internal_100BTX_phy_port(struct ksz_device *dev, int port);
> +bool lan937x_is_internal_t1_phy_port(struct ksz_device *dev, int port);
> +bool lan937x_is_internal_phy_port(struct ksz_device *dev, int port);
> +int lan937x_reset_switch(struct ksz_device *dev);
> +void lan937x_cfg_port_member(struct ksz_device *dev, int port,
> +			     u8 member);
> +void lan937x_port_setup(struct ksz_device *dev, int port, bool cpu_port);
> +int lan937x_enable_spi_indirect_access(struct ksz_device *dev);
> +
> +struct mib_names {
> +	int index;
> +	char string[ETH_GSTRING_LEN];
> +};
> +
> +struct lan_alu_struct {
> +	/* entry 1 */
> +	u8	is_static:1;
> +	u8	is_src_filter:1;
> +	u8	is_dst_filter:1;
> +	u8	prio_age:3;
> +	u32	_reserv_0_1:23;
> +	u8	mstp:3;
> +	/* entry 2 */
> +	u8	is_override:1;
> +	u8	is_use_fid:1;
> +	u32	_reserv_1_1:22;
> +	u8	port_forward:8;
> +	/* entry 3 & 4*/
> +	u32	_reserv_2_1:9;
> +	u8	fid:7;
> +	u8	mac[ETH_ALEN];
> +};
> +
> +extern const struct dsa_switch_ops lan937x_switch_ops;
> +extern const struct ksz_dev_ops lan937x_dev_ops;
> +extern const struct mib_names lan937x_mib_names[];
> +
> +#endif
> diff --git a/drivers/net/dsa/microchip/lan937x_main.c b/drivers/net/dsa/microchip/lan937x_main.c
> new file mode 100644
> index 000000000000..944c6f4d6d60
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/lan937x_main.c
> @@ -0,0 +1,364 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Microchip LAN937X switch driver main logic
> + * Copyright (C) 2019-2021 Microchip Technology Inc.
> + */
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/iopoll.h>
> +#include <linux/phy.h>
> +#include <linux/if_bridge.h>
> +#include <net/dsa.h>
> +#include <net/switchdev.h>
> +
> +#include "lan937x_reg.h"
> +#include "ksz_common.h"
> +#include "lan937x_dev.h"
> +
> +static enum dsa_tag_protocol lan937x_get_tag_protocol(struct dsa_switch *ds,
> +						      int port,
> +						      enum dsa_tag_protocol mp)
> +{
> +	return DSA_TAG_PROTO_LAN937X_VALUE;
> +}
> +
> +static int lan937x_phy_read16(struct dsa_switch *ds, int addr, int reg)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	u16 val;
> +	int rc;
> +
> +	rc = lan937x_internal_phy_read(dev, addr, reg, &val);
> +
> +	if (rc < 0)
> +		return rc;
> +
> +	return val;
> +}
> +
> +static int lan937x_phy_write16(struct dsa_switch *ds, int addr, int reg,
> +			       u16 val)
> +{
> +	struct ksz_device *dev = ds->priv;
> +
> +	return lan937x_internal_phy_write(dev, addr, reg, val);
> +}
> +
> +static void lan937x_port_stp_state_set(struct dsa_switch *ds, int port,
> +				       u8 state)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port *p = &dev->ports[port];
> +	int forward = dev->member;
> +	int member = -1;
> +	u8 data;
> +
> +	lan937x_pread8(dev, port, P_STP_CTRL, &data);
> +	data &= ~(PORT_TX_ENABLE | PORT_RX_ENABLE | PORT_LEARN_DISABLE);
> +
> +	switch (state) {
> +	case BR_STATE_DISABLED:
> +		data |= PORT_LEARN_DISABLE;
> +		break;
> +	case BR_STATE_LISTENING:
> +		data |= (PORT_RX_ENABLE | PORT_LEARN_DISABLE);
> +		if (p->stp_state == BR_STATE_DISABLED)
> +			member = dev->host_mask | p->vid_member;
> +		break;
> +	case BR_STATE_LEARNING:
> +		data |= PORT_RX_ENABLE;
> +		break;
> +	case BR_STATE_FORWARDING:
> +		data |= (PORT_TX_ENABLE | PORT_RX_ENABLE);
> +
> +		member = dev->host_mask | p->vid_member;
> +		mutex_lock(&dev->dev_mutex);
> +
> +		/* Port is a member of a bridge. */
> +		if (dev->br_member & (1 << port)) {
> +			dev->member |= (1 << port);
> +			member = dev->member;
> +		}
> +		mutex_unlock(&dev->dev_mutex);
> +		break;
> +	case BR_STATE_BLOCKING:
> +		data |= PORT_LEARN_DISABLE;
> +		if (p->stp_state == BR_STATE_DISABLED)
> +			member = dev->host_mask | p->vid_member;
> +		break;
> +	default:
> +		dev_err(ds->dev, "invalid STP state: %d\n", state);
> +		return;
> +	}
> +
> +	lan937x_pwrite8(dev, port, P_STP_CTRL, data);
> +
> +	p->stp_state = state;
> +	mutex_lock(&dev->dev_mutex);
> +
> +	/* Port membership may share register with STP state. */
> +	if (member >= 0 && member != p->member)
> +		lan937x_cfg_port_member(dev, port, (u8)member);
> +
> +	/* Check if forwarding needs to be updated. */
> +	if (state != BR_STATE_FORWARDING) {
> +		if (dev->br_member & (1 << port))
> +			dev->member &= ~(1 << port);
> +	}
> +
> +	/* When topology has changed the function ksz_update_port_member
> +	 * should be called to modify port forwarding behavior.
> +	 */
> +	if (forward != dev->member)
> +		ksz_update_port_member(dev, port);
> +	mutex_unlock(&dev->dev_mutex);
> +}
> +
> +static phy_interface_t lan937x_get_interface(struct ksz_device *dev, int port)
> +{
> +	phy_interface_t interface;
> +	u8 data8;
> +	int rc;
> +
> +	if (lan937x_is_internal_phy_port(dev, port))
> +		return PHY_INTERFACE_MODE_NA;

I think conventional wisdom is to use PHY_INTERFACE_MODE_INTERNAL for
internal ports, as the name would suggest.

> +
> +	/* read interface from REG_PORT_XMII_CTRL_1 register */
> +	rc = lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> +
> +	if (rc < 0)
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
> +			const char *prev_msg;
> +			const char *prev_mode;
> +
> +			dev->cpu_port = i;
> +			dev->host_mask = (1 << dev->cpu_port);
> +			dev->port_mask |= dev->host_mask;
> +			p = &dev->ports[i];
> +
> +			/* Read from XMII register to determine host port
> +			 * interface.  If set specifically in device tree
> +			 * note the difference to help debugging.
> +			 */
> +			interface = lan937x_get_interface(dev, i);
> +			if (!p->interface) {
> +				if (dev->compat_interface)
> +					p->interface = dev->compat_interface;

Compatibility with what? This is a new driver.

> +				else
> +					p->interface = interface;
> +			}
> +
> +			if (interface && interface != p->interface) {
> +				prev_msg = " instead of ";
> +				prev_mode = phy_modes(interface);
> +			} else {
> +				prev_msg = "";
> +				prev_mode = "";
> +			}
> +
> +			dev_info(dev->dev,
> +				 "Port%d: using phy mode %s%s%s\n",
> +				 i,
> +				 phy_modes(p->interface),
> +				 prev_msg,
> +				 prev_mode);

It's unlikely that anyone is going to be able to find such a composite
error message string using grep.

> +
> +			/* enable cpu port */
> +			lan937x_port_setup(dev, i, true);
> +			p->vid_member = dev->port_mask;
> +		}
> +	}
> +
> +	dev->member = dev->host_mask;
> +
> +	for (i = 0; i < dev->port_cnt; i++) {
> +		if (i == dev->cpu_port)
> +			continue;
> +		p = &dev->ports[i];
> +
> +		/* Initialize to non-zero so that lan937x_cfg_port_member() will
> +		 * be called.
> +		 */
> +		p->vid_member = (1 << i);
> +		p->member = dev->port_mask;
> +		lan937x_port_stp_state_set(ds, i, BR_STATE_DISABLED);
> +	}
> +}
> +
> +static int lan937x_setup(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int rc;
> +
> +	dev->vlan_cache = devm_kcalloc(dev->dev, sizeof(struct vlan_table),
> +				       dev->num_vlans, GFP_KERNEL);
> +	if (!dev->vlan_cache)
> +		return -ENOMEM;
> +
> +	rc = lan937x_reset_switch(dev);
> +	if (rc < 0) {
> +		dev_err(ds->dev, "failed to reset switch\n");
> +		return rc;
> +	}
> +
> +	/* Required for port partitioning. */
> +	lan937x_cfg32(dev, REG_SW_QM_CTRL__4, UNICAST_VLAN_BOUNDARY,
> +		      true);
> +
> +	lan937x_config_cpu_port(ds);
> +
> +	ds->configure_vlan_while_not_filtering = true;

You can delete this line, it's implicitly true now.

> +
> +	/* Enable aggressive back off & UNH */
> +	lan937x_cfg(dev, REG_SW_MAC_CTRL_0, SW_PAUSE_UNH_MODE | SW_NEW_BACKOFF |
> +						SW_AGGR_BACKOFF, true);
> +
> +	lan937x_cfg(dev, REG_SW_MAC_CTRL_1, (MULTICAST_STORM_DISABLE
> +							| NO_EXC_COLLISION_DROP), true);

Odd indentation, no explanation.

> +
> +	/* queue based egress rate limit */
> +	lan937x_cfg(dev, REG_SW_MAC_CTRL_5, SW_OUT_RATE_LIMIT_QUEUE_BASED, true);
> +
> +	lan937x_cfg(dev, REG_SW_LUE_CTRL_0, SW_RESV_MCAST_ENABLE, true);
> +
> +	/* enable global MIB counter freeze function */
> +	lan937x_cfg(dev, REG_SW_MAC_CTRL_6, SW_MIB_COUNTER_FREEZE, true);
> +
> +	/* disable CLK125 & CLK25, 1: disable, 0: enable*/
> +	lan937x_cfg(dev, REG_SW_GLOBAL_OUTPUT_CTRL__1, (SW_CLK125_ENB |
> +						SW_CLK25_ENB), true);

Do you run checkpatch from time to time?

> +
> +	lan937x_enable_spi_indirect_access(dev);
> +
> +	/* start switch */
> +	lan937x_cfg(dev, REG_SW_OPERATION, SW_START, true);
> +
> +	ksz_init_mib_timer(dev);
> +
> +	return 0;
> +}
> +
> +static int lan937x_change_mtu(struct dsa_switch *ds, int port, int mtu)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	u16 max_size;
> +	int rc;
> +
> +	if (mtu >= FR_MIN_SIZE) {
> +		rc = lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_JUMBO_EN, true);
> +		max_size = FR_MAX_SIZE;
> +	} else {
> +		rc = lan937x_port_cfg(dev, port, REG_PORT_MAC_CTRL_0, PORT_JUMBO_EN, false);
> +		max_size = FR_MIN_SIZE;
> +	}
> +
> +	if (rc < 0) {
> +		dev_err(ds->dev, "failed to enable jumbo\n");
> +		return rc;
> +	}
> +
> +	/* Write the frame size in PORT_MAX_FR_SIZE register */
> +	rc = lan937x_pwrite16(dev, port, PORT_MAX_FR_SIZE, max_size);
> +
> +	if (rc < 0) {
> +		dev_err(ds->dev, "failed to change the mtu\n");
> +		return rc;
> +	}
> +
> +	return 0;
> +}
> +
> +static int lan937x_get_max_mtu(struct dsa_switch *ds, int port)
> +{
> +	/* Frame size is 9000 (= 0x2328) if
> +	 * jumbo frame support is enabled, PORT_JUMBO_EN bit will be enabled
> +	 * based on mtu in lan937x_change_mtu() API
> +	 */
> +	return FR_MAX_SIZE;

Frame size is one thing. But MTU is L2 payload, which excludes MAC DA,
MAC SA, EtherType and VLAN ID. So does the switch really accept a packet
with an L2 payload length of 9000 bytes and a VLAN tag?

> +}
> +
> +static int	lan937x_port_pre_bridge_flags(struct dsa_switch *ds, int port,
> +					      struct switchdev_brport_flags flags,
> +					 struct netlink_ext_ack *extack)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static int	lan937x_port_bridge_flags(struct dsa_switch *ds, int port,
> +					  struct switchdev_brport_flags flags,
> +					 struct netlink_ext_ack *extack)
> +{
> +	return -EOPNOTSUPP;
> +}

This shouldn't have been implemented but is necessary due to a bug, see
commit 70a7c484c7c3 ("net: dsa: fix bridge support for drivers without
port_bridge_flags callback").

> +
> +const struct dsa_switch_ops lan937x_switch_ops = {
> +	.get_tag_protocol	= lan937x_get_tag_protocol,
> +	.setup			= lan937x_setup,
> +	.phy_read		= lan937x_phy_read16,
> +	.phy_write		= lan937x_phy_write16,
> +	.port_enable		= ksz_enable_port,
> +	.port_bridge_join	= ksz_port_bridge_join,
> +	.port_bridge_leave	= ksz_port_bridge_leave,
> +	.port_pre_bridge_flags	= lan937x_port_pre_bridge_flags,
> +	.port_bridge_flags	= lan937x_port_bridge_flags,
> +	.port_stp_state_set	= lan937x_port_stp_state_set,
> +	.port_fast_age		= ksz_port_fast_age,
> +	.port_max_mtu		= lan937x_get_max_mtu,
> +	.port_change_mtu	= lan937x_change_mtu,
> +};
> +
> +int lan937x_switch_register(struct ksz_device *dev)
> +{
> +	int ret;
> +
> +	ret = ksz_switch_register(dev, &lan937x_dev_ops);
> +
> +	if (ret) {
> +		if (dev->mdio_np) {
> +			mdiobus_unregister(dev->ds->slave_mii_bus);

I don't see any mdiobus_unregister when the driver is removed?

> +			of_node_put(dev->mdio_np);

Also, why keep mdio_np inside ksz_device, therefore for the entire
lifetime of the driver? Why do you need it? Not to mention you don't
appear to be ever calling of_node_put on unbind, unless I'm missing
something.

> +		}
> +	}
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(lan937x_switch_register);
> +
> +MODULE_AUTHOR("Prasanna Vengateshan Varadharajan <Prasanna.Vengateshan@microchip.com>");
> +MODULE_DESCRIPTION("Microchip LAN937x Series Switch DSA Driver");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/net/dsa/microchip/lan937x_spi.c b/drivers/net/dsa/microchip/lan937x_spi.c
> new file mode 100644
> index 000000000000..d9731d6afb96
> --- /dev/null
> +++ b/drivers/net/dsa/microchip/lan937x_spi.c
> @@ -0,0 +1,226 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/* Microchip LAN937X switch driver register access through SPI
> + * Copyright (C) 2019-2021 Microchip Technology Inc.
> + */
> +#include <asm/unaligned.h>

Why do you need this?

> +
> +#include <linux/delay.h>

Or this?

> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/regmap.h>
> +#include <linux/spi/spi.h>
> +#include <linux/of_device.h>
> +
> +#include "ksz_common.h"
> +
> +#define SPI_ADDR_SHIFT				24
> +#define SPI_ADDR_ALIGN				3
> +#define SPI_TURNAROUND_SHIFT		5
> +
> +KSZ_REGMAP_TABLE(lan937x, 32, SPI_ADDR_SHIFT,
> +		 SPI_TURNAROUND_SHIFT, SPI_ADDR_ALIGN);
> +
> +struct lan937x_chip_data {
> +	u32 chip_id;
> +	const char *dev_name;
> +	int num_vlans;
> +	int num_alus;
> +	int num_statics;
> +	int cpu_ports;
> +	int port_cnt;
> +};
> +
> +static const struct of_device_id lan937x_dt_ids[];
> +
> +static const struct lan937x_chip_data lan937x_switch_chips[] = {
> +	{
> +		.chip_id = 0x00937010,
> +		.dev_name = "LAN9370",
> +		.num_vlans = 4096,
> +		.num_alus = 1024,
> +		.num_statics = 256,
> +		/* can be configured as cpu port */
> +		.cpu_ports = 0x10,
> +		/* total port count */
> +		.port_cnt = 5,
> +	},
> +	{
> +		.chip_id = 0x00937110,
> +		.dev_name = "LAN9371",
> +		.num_vlans = 4096,
> +		.num_alus = 1024,
> +		.num_statics = 256,
> +		/* can be configured as cpu port */
> +		.cpu_ports = 0x30,
> +		/* total port count */
> +		.port_cnt = 6,
> +	},
> +	{
> +		.chip_id = 0x00937210,
> +		.dev_name = "LAN9372",
> +		.num_vlans = 4096,
> +		.num_alus = 1024,
> +		.num_statics = 256,
> +		/* can be configured as cpu port */
> +		.cpu_ports = 0x30,
> +		/* total port count */
> +		.port_cnt = 8,
> +	},
> +	{
> +		.chip_id = 0x00937310,
> +		.dev_name = "LAN9373",
> +		.num_vlans = 4096,
> +		.num_alus = 1024,
> +		.num_statics = 256,
> +		/* can be configured as cpu port */
> +		.cpu_ports = 0x38,
> +		/* total port count */
> +		.port_cnt = 5,
> +	},
> +	{
> +		.chip_id = 0x00937410,
> +		.dev_name = "LAN9374",
> +		.num_vlans = 4096,
> +		.num_alus = 1024,
> +		.num_statics = 256,
> +		/* can be configured as cpu port */
> +		.cpu_ports = 0x30,
> +		/* total port count */
> +		.port_cnt = 8,
> +	},
> +

The new line shouldn't be here?

> +};
> +

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28BD3DC682
	for <lists+netdev@lfdr.de>; Sat, 31 Jul 2021 17:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233361AbhGaPGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Jul 2021 11:06:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233663AbhGaPE0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 31 Jul 2021 11:04:26 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC2C6C06175F;
        Sat, 31 Jul 2021 08:04:19 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id k4so7754297wms.3;
        Sat, 31 Jul 2021 08:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I/EslmhkC1iAJmMAgiErpXP+mUisFxacpJEZiv6vpWk=;
        b=Rbxu5U//4iQjFQeZ7QgXb+HfMr+Mgf0p9nkykYneoqP1bYIrMCeKpQfNxxSGzkbdS1
         RIWQL3RLH5PvXEuFBwveGQ1VPvCoR5YbBRkt2AOuU+jK/WTXp1zyR1jgoDI/ubqkOzhq
         SitShjKJEG6FfxpTu/XqRv5CdZ4NI4GatK7Wq4UuIZlPf//7EpZa4hrEol51OnhLL/kt
         EZ/A35I9/KFLlvApRWapWrpYAaFqgdPMUXDQRBiWgadOKz2BERfgm/hhjjzHrSffJVGO
         AIvC9TkFgzF1OUuD6u+OKPmf/eUg5/mgLu4FZhcqghhNny4lBYmT1ADL8G6pSR9E0QhE
         9JKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I/EslmhkC1iAJmMAgiErpXP+mUisFxacpJEZiv6vpWk=;
        b=rZTYZsdk2+W9+euUEG60f2mjwnLgbwITQBCl+GtEcxLX1RIO3MAJX7QTVZqhrTQ3tW
         f4wExr/uf3Wq5kH5CUR+qaJw6jflehjVtkr9WyTJ+0BSb3xs8nsp5W0bQvSRFgMfMQ+h
         15JOpEc97Cqs4h8hatLUqM2pWerbTig2TO0S08wmlGqhgYgYnzUskkqZIwMBN0/1xSSJ
         HrMBcH7+2d11B5CUFApuDLClB7/IxZKcgMFNFaYr4dcAbkXkgjV1diD/TAR501XsM9jj
         IHrKEMGexxUGzW9I8iZoDQODIgCyxXl8BCSNE1moM5kYpFLnw1u6g6R2QcEzhAugArBd
         J+oQ==
X-Gm-Message-State: AOAM531QNtRAqg6YSkx2IIz86Nh4ImuXUPGgmfDMGX8MOcXoK7R+b0ox
        HUoTHpOun1xZKzLpXMqAo5k=
X-Google-Smtp-Source: ABdhPJyznYXtZS7wEb1RpssWlGIMN/orLxPW2biCkEuogo3XsoQHqiiCaiKj6Xi9KPESKGHFAWrk1Q==
X-Received: by 2002:a05:600c:1906:: with SMTP id j6mr8262344wmq.108.1627743858053;
        Sat, 31 Jul 2021 08:04:18 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id y19sm5128539wmq.5.2021.07.31.08.04.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 31 Jul 2021 08:04:17 -0700 (PDT)
Date:   Sat, 31 Jul 2021 18:04:16 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, robh+dt@kernel.org,
        UNGLinuxDriver@microchip.com, Woojung.Huh@microchip.com,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v3 net-next 05/10] net: dsa: microchip: add DSA support
 for microchip lan937x
Message-ID: <20210731150416.upe5nwkwvwajhwgg@skbuf>
References: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
 <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723173108.459770-6-prasanna.vengateshan@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:01:03PM +0530, Prasanna Vengateshan wrote:
> diff --git a/drivers/net/dsa/microchip/ksz_common.h b/drivers/net/dsa/microchip/ksz_common.h
> index 2e6bfd333f50..690d339edd7b 100644
> --- a/drivers/net/dsa/microchip/ksz_common.h
> +++ b/drivers/net/dsa/microchip/ksz_common.h
> @@ -60,6 +60,8 @@ struct ksz_device {
>  
>  	struct gpio_desc *reset_gpio;	/* Optional reset GPIO */
>  
> +	struct device_node *mdio_np;
> +

I don't think you need to hold a reference to the MDIO bus DT node across
the lifetime of the driver, at least other drivers don't, they drop the
reference to it as soon as they finish with of_mdiobus_register and I
don't think they have seen any adverse effects.

> +int lan937x_cfg32(struct ksz_device *dev, u32 addr, u32 bits, bool set)
> +{
> +	return regmap_update_bits(dev->regmap[2], addr, bits, set ? bits : 0);
> +}

This function is unused.

> +int lan937x_port_cfg32(struct ksz_device *dev, int port, int offset, u32 bits,
> +		       bool set)
> +{
> +	return regmap_update_bits(dev->regmap[2], PORT_CTRL_ADDR(port, offset),
> +				  bits, set ? bits : 0);
> +}

Likewise.

> +static void lan937x_r_mib_cnt(struct ksz_device *dev, int port, u16 addr,
> +			      u64 *cnt)
> +{
> +	unsigned int val;
> +	u32 data;
> +	int ret;
> +
> +	/* Enable MIB Counter read*/

You can try to be more careful with the style of the comments, ensure
that there is a space between the last character and the */ marker, here
and everywhere.

> +	data = MIB_COUNTER_READ;
> +	data |= (addr << MIB_COUNTER_INDEX_S);
> +	lan937x_pwrite32(dev, port, REG_PORT_MIB_CTRL_STAT, data);
> +
> +	ret = regmap_read_poll_timeout(dev->regmap[2],
> +				       PORT_CTRL_ADDR(port, REG_PORT_MIB_CTRL_STAT),
> +				       val, !(val & MIB_COUNTER_READ),
> +				       10, 1000);
> +	if (ret) {
> +		dev_err(dev->dev, "Failed to get MIB\n");
> +		return;
> +	}
> +
> +	/* count resets upon read */
> +	lan937x_pread32(dev, port, REG_PORT_MIB_DATA, &data);
> +	*cnt += data;
> +}

> +
> +bool lan937x_is_internal_100BTX_phy_port(struct ksz_device *dev, int port)

In another similar driver (sja1110), instead of adding camel case names,
I went for "base_tx" and "base_t1". Maybe that looks slightly better and
more uniform between your "100BTX" vs "t1".

> +void lan937x_mac_config(struct ksz_device *dev, int port,
> +			phy_interface_t interface)
> +{
> +	u8 data8;
> +
> +	lan937x_pread8(dev, port, REG_PORT_XMII_CTRL_1, &data8);
> +
> +	/* clear MII selection & set it based on interface later */
> +	data8 &= ~PORT_MII_SEL_M;
> +
> +	/* configure MAC based on interface */
> +	switch (interface) {
> +	case PHY_INTERFACE_MODE_MII:
> +		lan937x_config_gbit(dev, false, &data8);
> +		data8 |= PORT_MII_SEL;
> +		break;
> +	case PHY_INTERFACE_MODE_RMII:
> +		lan937x_config_gbit(dev, false, &data8);
> +		data8 |= PORT_RMII_SEL;
> +		break;
> +	case PHY_INTERFACE_MODE_RGMII:
> +	case PHY_INTERFACE_MODE_RGMII_ID:
> +	case PHY_INTERFACE_MODE_RGMII_TXID:
> +	case PHY_INTERFACE_MODE_RGMII_RXID:
> +		lan937x_config_gbit(dev, true, &data8);
> +		data8 |= PORT_RGMII_SEL;
> +
> +		/* Add RGMII internal delay for cpu port*/
> +		if (dsa_is_cpu_port(dev->ds, port)) {

Why only for the CPU port? I would like Andrew/Florian to have a look
here, I guess the assumption is that if the port has a phy-handle, the
RGMII delays should be dealt with by the PHY, but the logic seems to be
"is a CPU port <=> has a phy-handle / isn't a CPU port <=> doesn't have
a phy-handle"? What if it's a fixed-link port connected to a downstream
switch, for which this one is a DSA master?

> +			if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +			    interface == PHY_INTERFACE_MODE_RGMII_RXID)
> +				data8 |= PORT_RGMII_ID_IG_ENABLE;
> +
> +			if (interface == PHY_INTERFACE_MODE_RGMII_ID ||
> +			    interface == PHY_INTERFACE_MODE_RGMII_TXID)
> +				data8 |= PORT_RGMII_ID_EG_ENABLE;
> +		}
> +		break;
> +	default:
> +		dev_err(dev->dev, "Unsupported interface '%s' for port %d\n",
> +			phy_modes(interface), port);
> +		return;
> +	}
> +
> +	/* Write the updated value */
> +	lan937x_pwrite8(dev, port, REG_PORT_XMII_CTRL_1, data8);
> +}

> +static int lan937x_mdio_register(struct dsa_switch *ds)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	int ret;
> +
> +	dev->mdio_np = of_get_child_by_name(ds->dev->of_node, "mdio");

So you support both the cases where an internal PHY is described using
OF bindings, and where the internal PHY is implicitly accessed using the
slave_mii_bus of the switch, at a PHY address equal to the port number,
and with no phy-handle or fixed-link device tree property for that port?

Do you need both alternatives? The first is already more flexible than
the second.

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

I am not convinced that the dev_mutex brings any value in any of the ksz
drivers that use it.

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
> +
> +	mutex_unlock(&dev->dev_mutex);
> +}

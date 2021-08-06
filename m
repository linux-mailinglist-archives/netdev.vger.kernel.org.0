Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5018A3E2A0C
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245704AbhHFLsz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:48:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245696AbhHFLsz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 07:48:55 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FD17C061798;
        Fri,  6 Aug 2021 04:48:39 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id w197so8218993qkb.1;
        Fri, 06 Aug 2021 04:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rA++RZnknfBR+KErZqwttt9+d18gbqqSiF3ldCHqqhI=;
        b=txpDWksSVu9P5b57FT4ByeemsUYENBeFaRBKedpSI8GXxpdvuXA8Ki17zt5wytj8Q7
         Dsm/knBAqJhot5hQuoCJjwhpoba79/IrMcR88E0qpiyxYh0l+OHNSOLSHtNKMXeik3rp
         o0s3hqza4dGCNtH71dN6pbidFzcbDSp1qnus2XqddlsEoKJCjojSBOQirKchMJqH65Wm
         eGEuaCIH3z2xuTrjMkjyeczOiASE/ldIz6lcdFGvEKUJfWBl5Ib4sdh1Ix5JW0i3/GD5
         2m7ynLb6qmwtpGZaHMgMylzsKzm24UjOc1B4/BYDp3001Fx6EwOXaY5UeHrn0fCdqSUA
         ztkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=rA++RZnknfBR+KErZqwttt9+d18gbqqSiF3ldCHqqhI=;
        b=dp8WaC4YfvhQeued70FY9CWjntoKen5VFaQjqDB3q0wt/eoS7X1L6eb5miQudQXAQS
         /OqCVHxY6TYe/ZzcKlV3/4jgZHCB/aucbuisv0+iRF/UnGSDPNBMfyIiFuBDbeQZJvmD
         M67cbNu7ttKgFNgFGpy2FGWGvRRdO5t++3njL0r75pI/cmJdriOInYYaGN+cNHe1sedT
         nMwF9eQvvZKaePn7EZZ7KvYU5UVfdeGECIBcmsvZnjrwrwiC0O8fsBvIZllJOei7/S4/
         +OJXAjNJrliQ1XB9ZESGcHEaaNEooVXl9srCPPrJgYVj86Yp6RLkh9SJ584VWXcioZbk
         KhzA==
X-Gm-Message-State: AOAM530PUjbH0oLKCFBVMG/jXy8oGXzbJTJUgxNyutsBQJyAWzpyz3Wl
        U1XDFf0ILdKG7LG6u9VPkJt5wXswiRpSyU9G
X-Google-Smtp-Source: ABdhPJx7cMif42+ciuEdFTpZYHedIdgVh6p9/ibDpizFZFZe8FOVyBgbpquWO74Yo6Z1TtEAPZQWOg==
X-Received: by 2002:a05:620a:139b:: with SMTP id k27mr9737292qki.326.1628250518488;
        Fri, 06 Aug 2021 04:48:38 -0700 (PDT)
Received: from errol.ini.cmu.edu (pool-71-112-192-175.pitbpa.fios.verizon.net. [71.112.192.175])
        by smtp.gmail.com with ESMTPSA id m19sm3372634qtx.84.2021.08.06.04.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 04:48:37 -0700 (PDT)
Date:   Fri, 6 Aug 2021 07:48:35 -0400
From:   "Gabriel L. Somlo" <gsomlo@gmail.com>
To:     Joel Stanley <joel@jms.id.au>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Stafford Horne <shorne@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Anton Blanchard <anton@ozlabs.org>, David Shah <dave@ds0.me>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, florent@enjoy-digital.fr
Subject: Re: [PATCH 2/2] net: Add driver for LiteX's LiteETH network interface
Message-ID: <YQ0hk/lsHXUu+ykC@errol.ini.cmu.edu>
References: <20210806054904.534315-1-joel@jms.id.au>
 <20210806054904.534315-3-joel@jms.id.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806054904.534315-3-joel@jms.id.au>
X-Clacks-Overhead: GNU Terry Pratchett
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Joel,

Thanks for pushing this upstream (and for writing it to begin with)!

Would you mind diff-ing your version of litex_liteeth.c against what
is currently in
https://github.com/litex-hub/linux/blob/litex-rebase/drivers/net/ethernet/litex/litex_liteeth.c ?

Two main differences we should discuss:

	1. there's a polling mode (added by Antony Pavlov), and if we
	   decide *not* to keep it around, I want to ensure we do that
	   deliberately, with an explanation as to why;

	2. LiteX CSRs are accessed using `litex_[read|write][8|16|32]()`
	   as opposed to simply `[read|write][b|w|l]()`. The former set
	   are defined in `include/linux/litex.h` and are needed to
	   ensure correct accesses regardless of endianness, since by
	   default LiteX registers' endianness mirrors that of the
	   configured CPU.

Thanks much,
--Gabriel

On Fri, Aug 06, 2021 at 03:19:04PM +0930, Joel Stanley wrote:
> LiteX is a soft system-on-chip that targets FPGAs. LiteETH is a basic
> network device that is commonly used in LiteX designs.
> 
> The driver was first written in 2017 and has been maintained by the
> LiteX community in various trees. Thank you to all who have contributed.
> 
> Co-developed-by: Gabriel Somlo <gsomlo@gmail.com>
> Co-developed-by: David Shah <dave@ds0.me>
> Co-developed-by: Stafford Horne <shorne@gmail.com>
> Signed-off-by: Joel Stanley <joel@jms.id.au>
> ---
>  drivers/net/ethernet/Kconfig               |   1 +
>  drivers/net/ethernet/Makefile              |   1 +
>  drivers/net/ethernet/litex/Kconfig         |  24 ++
>  drivers/net/ethernet/litex/Makefile        |   5 +
>  drivers/net/ethernet/litex/litex_liteeth.c | 340 +++++++++++++++++++++
>  5 files changed, 371 insertions(+)
>  create mode 100644 drivers/net/ethernet/litex/Kconfig
>  create mode 100644 drivers/net/ethernet/litex/Makefile
>  create mode 100644 drivers/net/ethernet/litex/litex_liteeth.c
> 
> diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
> index 1cdff1dca790..d796684ec9ca 100644
> --- a/drivers/net/ethernet/Kconfig
> +++ b/drivers/net/ethernet/Kconfig
> @@ -118,6 +118,7 @@ config LANTIQ_XRX200
>  	  Support for the PMAC of the Gigabit switch (GSWIP) inside the
>  	  Lantiq / Intel VRX200 VDSL SoC
>  
> +source "drivers/net/ethernet/litex/Kconfig"
>  source "drivers/net/ethernet/marvell/Kconfig"
>  source "drivers/net/ethernet/mediatek/Kconfig"
>  source "drivers/net/ethernet/mellanox/Kconfig"
> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
> index cb3f9084a21b..aaa5078cd7d1 100644
> --- a/drivers/net/ethernet/Makefile
> +++ b/drivers/net/ethernet/Makefile
> @@ -51,6 +51,7 @@ obj-$(CONFIG_JME) += jme.o
>  obj-$(CONFIG_KORINA) += korina.o
>  obj-$(CONFIG_LANTIQ_ETOP) += lantiq_etop.o
>  obj-$(CONFIG_LANTIQ_XRX200) += lantiq_xrx200.o
> +obj-$(CONFIG_NET_VENDOR_LITEX) += litex/
>  obj-$(CONFIG_NET_VENDOR_MARVELL) += marvell/
>  obj-$(CONFIG_NET_VENDOR_MEDIATEK) += mediatek/
>  obj-$(CONFIG_NET_VENDOR_MELLANOX) += mellanox/
> diff --git a/drivers/net/ethernet/litex/Kconfig b/drivers/net/ethernet/litex/Kconfig
> new file mode 100644
> index 000000000000..0a863e3ff7bf
> --- /dev/null
> +++ b/drivers/net/ethernet/litex/Kconfig
> @@ -0,0 +1,24 @@
> +#
> +# LiteX device configuration
> +#
> +
> +config NET_VENDOR_LITEX
> +	bool "LiteX devices"
> +	default y
> +	help
> +	  If you have a network (Ethernet) card belonging to this class, say Y.
> +
> +	  Note that the answer to this question doesn't directly affect the
> +	  kernel: saying N will just cause the configurator to skip all
> +	  the questions about LiteX devices. If you say Y, you will be asked
> +	  for your specific card in the following questions.
> +
> +if NET_VENDOR_LITEX
> +
> +config LITEX_LITEETH
> +	tristate "LiteX Ethernet support"
> +	help
> +	  If you wish to compile a kernel for hardware with a LiteX LiteEth
> +	  device then you should answer Y to this.
> +
> +endif # NET_VENDOR_LITEX
> diff --git a/drivers/net/ethernet/litex/Makefile b/drivers/net/ethernet/litex/Makefile
> new file mode 100644
> index 000000000000..9343b73b8e49
> --- /dev/null
> +++ b/drivers/net/ethernet/litex/Makefile
> @@ -0,0 +1,5 @@
> +#
> +# Makefile for the LiteX network device drivers.
> +#
> +
> +obj-$(CONFIG_LITEX_LITEETH) += litex_liteeth.o
> diff --git a/drivers/net/ethernet/litex/litex_liteeth.c b/drivers/net/ethernet/litex/litex_liteeth.c
> new file mode 100644
> index 000000000000..48b551e6d97b
> --- /dev/null
> +++ b/drivers/net/ethernet/litex/litex_liteeth.c
> @@ -0,0 +1,340 @@
> +// SPDX-License-Identifier: GPL-2.0-or-later
> +/*
> + * LiteX Liteeth Ethernet
> + *
> + * Copyright 2017 Joel Stanley <joel@jms.id.au>
> + *
> + */
> +
> +#include <linux/etherdevice.h>
> +#include <linux/interrupt.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_net.h>
> +#include <linux/of_address.h>
> +#include <linux/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/iopoll.h>
> +
> +#define LITEETH_WRITER_SLOT       0x00
> +#define LITEETH_WRITER_LENGTH     0x04
> +#define LITEETH_WRITER_ERRORS     0x08
> +#define LITEETH_WRITER_EV_STATUS  0x0C
> +#define LITEETH_WRITER_EV_PENDING 0x10
> +#define LITEETH_WRITER_EV_ENABLE  0x14
> +#define LITEETH_READER_START      0x18
> +#define LITEETH_READER_READY      0x1C
> +#define LITEETH_READER_LEVEL      0x20
> +#define LITEETH_READER_SLOT       0x24
> +#define LITEETH_READER_LENGTH     0x28
> +#define LITEETH_READER_EV_STATUS  0x2C
> +#define LITEETH_READER_EV_PENDING 0x30
> +#define LITEETH_READER_EV_ENABLE  0x34
> +#define LITEETH_PREAMBLE_CRC      0x38
> +#define LITEETH_PREAMBLE_ERRORS   0x3C
> +#define LITEETH_CRC_ERRORS        0x40
> +
> +#define LITEETH_PHY_CRG_RESET     0x00
> +#define LITEETH_MDIO_W            0x04
> +#define LITEETH_MDIO_R            0x0C
> +
> +#define DRV_NAME	"liteeth"
> +
> +#define LITEETH_BUFFER_SIZE		0x800
> +#define MAX_PKT_SIZE			LITEETH_BUFFER_SIZE
> +
> +struct liteeth {
> +	void __iomem *base;
> +	void __iomem *mdio_base;
> +	struct net_device *netdev;
> +	struct device *dev;
> +	struct mii_bus *mii_bus;
> +
> +	/* Link management */
> +	int cur_duplex;
> +	int cur_speed;
> +
> +	/* Tx */
> +	int tx_slot;
> +	int num_tx_slots;
> +	void __iomem *tx_base;
> +
> +	/* Rx */
> +	int rx_slot;
> +	int num_rx_slots;
> +	void __iomem *rx_base;
> +};
> +
> +
> +static int liteeth_rx(struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +	struct sk_buff *skb;
> +	unsigned char *data;
> +	u8 rx_slot;
> +	int len;
> +
> +	rx_slot = readb(priv->base + LITEETH_WRITER_SLOT);
> +	len = readl(priv->base + LITEETH_WRITER_LENGTH);
> +
> +	skb = netdev_alloc_skb(netdev, len + NET_IP_ALIGN);
> +	if (!skb) {
> +		netdev_err(netdev, "couldn't get memory");
> +		netdev->stats.rx_dropped++;
> +		return NET_RX_DROP;
> +	}
> +
> +	/* Ensure alignemnt of the ip header within the skb */
> +	skb_reserve(skb, NET_IP_ALIGN);
> +	if (len == 0 || len > 2048)
> +		return NET_RX_DROP;
> +	data = skb_put(skb, len);
> +	memcpy_fromio(data, priv->rx_base + rx_slot * LITEETH_BUFFER_SIZE, len);
> +	skb->protocol = eth_type_trans(skb, netdev);
> +
> +	netdev->stats.rx_packets++;
> +	netdev->stats.rx_bytes += len;
> +
> +	return netif_rx(skb);
> +}
> +
> +static irqreturn_t liteeth_interrupt(int irq, void *dev_id)
> +{
> +	struct net_device *netdev = dev_id;
> +	struct liteeth *priv = netdev_priv(netdev);
> +	u8 reg;
> +
> +	reg = readb(priv->base + LITEETH_READER_EV_PENDING);
> +	if (reg) {
> +		netdev->stats.tx_packets++;
> +		writeb(reg, priv->base + LITEETH_READER_EV_PENDING);
> +	}
> +
> +	reg = readb(priv->base + LITEETH_WRITER_EV_PENDING);
> +	if (reg) {
> +		liteeth_rx(netdev);
> +		writeb(reg, priv->base + LITEETH_WRITER_EV_PENDING);
> +	}
> +
> +	return IRQ_HANDLED;
> +}
> +
> +static int liteeth_open(struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +	int err;
> +
> +	/* Clear pending events */
> +	writeb(1, priv->base + LITEETH_WRITER_EV_PENDING);
> +	writeb(1, priv->base + LITEETH_READER_EV_PENDING);
> +
> +	err = request_irq(netdev->irq, liteeth_interrupt, 0, netdev->name, netdev);
> +	if (err) {
> +		netdev_err(netdev, "failed to request irq %d\n", netdev->irq);
> +		return err;
> +	}
> +
> +	/* Enable IRQs */
> +	writeb(1, priv->base + LITEETH_WRITER_EV_ENABLE);
> +	writeb(1, priv->base + LITEETH_READER_EV_ENABLE);
> +
> +	/* TODO: Remove these once we have working mdio support */
> +	priv->cur_duplex = DUPLEX_FULL;
> +	priv->cur_speed = SPEED_100;
> +	netif_carrier_on(netdev);
> +
> +	netif_start_queue(netdev);
> +
> +	return 0;
> +}
> +
> +static int liteeth_stop(struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +
> +	netif_stop_queue(netdev);
> +
> +	writeb(0, priv->base + LITEETH_WRITER_EV_ENABLE);
> +	writeb(0, priv->base + LITEETH_READER_EV_ENABLE);
> +
> +	free_irq(netdev->irq, netdev);
> +
> +	return 0;
> +}
> +
> +static int liteeth_start_xmit(struct sk_buff *skb, struct net_device *netdev)
> +{
> +	struct liteeth *priv = netdev_priv(netdev);
> +	void __iomem *txbuffer;
> +	int ret;
> +	u8 val;
> +
> +	/* Reject oversize packets */
> +	if (unlikely(skb->len > MAX_PKT_SIZE)) {
> +		if (net_ratelimit())
> +			netdev_dbg(netdev, "tx packet too big\n");
> +		goto drop;
> +	}
> +
> +	txbuffer = priv->tx_base + priv->tx_slot * LITEETH_BUFFER_SIZE;
> +	memcpy_toio(txbuffer, skb->data, skb->len);
> +	writeb(priv->tx_slot, priv->base + LITEETH_READER_SLOT);
> +	writew(skb->len, priv->base + LITEETH_READER_LENGTH);
> +
> +	ret = readl_poll_timeout_atomic(priv->base + LITEETH_READER_READY, val, val, 5, 1000);
> +	if (ret == -ETIMEDOUT) {
> +		netdev_err(netdev, "LITEETH_READER_READY timed out\n");
> +		goto drop;
> +	}
> +
> +	writeb(1, priv->base + LITEETH_READER_START);
> +
> +	netdev->stats.tx_bytes += skb->len;
> +
> +	priv->tx_slot = (priv->tx_slot + 1) % priv->num_tx_slots;
> +	dev_kfree_skb_any(skb);
> +	return NETDEV_TX_OK;
> +drop:
> +	/* Drop the packet */
> +	dev_kfree_skb_any(skb);
> +	netdev->stats.tx_dropped++;
> +
> +	return NETDEV_TX_OK;
> +}
> +
> +static const struct net_device_ops liteeth_netdev_ops = {
> +	.ndo_open		= liteeth_open,
> +	.ndo_stop		= liteeth_stop,
> +	.ndo_start_xmit         = liteeth_start_xmit,
> +};
> +
> +static void liteeth_reset_hw(struct liteeth *priv)
> +{
> +	/* Reset, twice */
> +	writeb(0, priv->base + LITEETH_PHY_CRG_RESET);
> +	udelay(10);
> +	writeb(1, priv->base + LITEETH_PHY_CRG_RESET);
> +	udelay(10);
> +	writeb(0, priv->base + LITEETH_PHY_CRG_RESET);
> +	udelay(10);
> +}
> +
> +static int liteeth_probe(struct platform_device *pdev)
> +{
> +	struct net_device *netdev;
> +	void __iomem *buf_base;
> +	struct resource *res;
> +	struct liteeth *priv;
> +	int irq, err;
> +
> +	netdev = alloc_etherdev(sizeof(*priv));
> +	if (!netdev)
> +		return -ENOMEM;
> +
> +	priv = netdev_priv(netdev);
> +	priv->netdev = netdev;
> +	priv->dev = &pdev->dev;
> +
> +	irq = platform_get_irq(pdev, 0);
> +	if (irq < 0) {
> +		dev_err(&pdev->dev, "Failed to get IRQ\n");
> +		goto err;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	priv->base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->base)) {
> +		err = PTR_ERR(priv->base);
> +		goto err;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	priv->mdio_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(priv->mdio_base)) {
> +		err = PTR_ERR(priv->mdio_base);
> +		goto err;
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +	buf_base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(buf_base)) {
> +		err = PTR_ERR(buf_base);
> +		goto err;
> +	}
> +
> +	err = of_property_read_u32(pdev->dev.of_node, "rx-fifo-depth",
> +			&priv->num_rx_slots);
> +	if (err) {
> +		dev_err(&pdev->dev, "unable to get rx-fifo-depth\n");
> +		goto err;
> +	}
> +
> +	err = of_property_read_u32(pdev->dev.of_node, "tx-fifo-depth",
> +			&priv->num_tx_slots);
> +	if (err) {
> +		dev_err(&pdev->dev, "unable to get tx-fifo-depth\n");
> +		goto err;
> +	}
> +
> +	/* Rx slots */
> +	priv->rx_base = buf_base;
> +	priv->rx_slot = 0;
> +
> +	/* Tx slots come after Rx slots */
> +	priv->tx_base = buf_base + priv->num_rx_slots * LITEETH_BUFFER_SIZE;
> +	priv->tx_slot = 0;
> +
> +	err = of_get_mac_address(pdev->dev.of_node, netdev->dev_addr);
> +	if (err)
> +		eth_hw_addr_random(netdev);
> +
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +	platform_set_drvdata(pdev, netdev);
> +
> +	netdev->netdev_ops = &liteeth_netdev_ops;
> +	netdev->irq = irq;
> +
> +	liteeth_reset_hw(priv);
> +
> +	err = register_netdev(netdev);
> +	if (err) {
> +		dev_err(&pdev->dev, "Failed to register netdev\n");
> +		goto err;
> +	}
> +
> +	netdev_info(netdev, "irq %d, mapped at %px\n", netdev->irq, priv->base);
> +
> +	return 0;
> +err:
> +	free_netdev(netdev);
> +	return err;
> +}
> +
> +static int liteeth_remove(struct platform_device *pdev)
> +{
> +	struct net_device *netdev = platform_get_drvdata(pdev);
> +
> +	unregister_netdev(netdev);
> +	free_netdev(netdev);
> +
> +	return 0;
> +}
> +
> +static const struct of_device_id liteeth_of_match[] = {
> +	{ .compatible = "litex,liteeth" },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(of, liteeth_of_match);
> +
> +static struct platform_driver liteeth_driver = {
> +	.probe = liteeth_probe,
> +	.remove = liteeth_remove,
> +	.driver = {
> +		.name = DRV_NAME,
> +		.of_match_table = liteeth_of_match,
> +	},
> +};
> +module_platform_driver(liteeth_driver);
> +
> +MODULE_AUTHOR("Joel Stanley <joel@jms.id.au>");
> +MODULE_LICENSE("GPL");
> -- 
> 2.32.0
> 

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8342FECC1
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 15:19:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729940AbhAUORv convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Jan 2021 09:17:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729765AbhAUOKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 09:10:42 -0500
X-Greylist: delayed 593 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 21 Jan 2021 06:09:31 PST
Received: from unicorn.mansr.com (unicorn.mansr.com [IPv6:2001:8b0:ca0d:8d8e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A99C0613C1
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 06:09:31 -0800 (PST)
Received: from raven.mansr.com (raven.mansr.com [IPv6:2001:8b0:ca0d:8d8e::3])
        by unicorn.mansr.com (Postfix) with ESMTPS id 8065A15361;
        Thu, 21 Jan 2021 13:58:42 +0000 (GMT)
Received: by raven.mansr.com (Postfix, from userid 51770)
        id 7D60A21A3D9; Thu, 21 Jan 2021 13:58:42 +0000 (GMT)
From:   =?iso-8859-1?Q?M=E5ns_Rullg=E5rd?= <mans@mansr.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Marc Gonzalez <marc.w.gonzalez@free.fr>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: remove aurora nb8800 driver
References: <20210120150703.1629527-1-arnd@kernel.org>
Date:   Thu, 21 Jan 2021 13:58:42 +0000
In-Reply-To: <20210120150703.1629527-1-arnd@kernel.org> (Arnd Bergmann's
        message of "Wed, 20 Jan 2021 16:06:31 +0100")
Message-ID: <yw1x8s8mz90t.fsf@mansr.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Arnd Bergmann <arnd@kernel.org> writes:

> From: Arnd Bergmann <arnd@arndb.de>
>
> The tango4 platform is getting removed, and this driver has no
> other known users, so it can be removed.
>
> Cc: Marc Gonzalez <marc.w.gonzalez@free.fr>
> Cc: Mans Rullgard <mans@mansr.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Mans Rullgard <mans@mansr.com>

> ---
>  drivers/net/ethernet/Kconfig         |    1 -
>  drivers/net/ethernet/Makefile        |    1 -
>  drivers/net/ethernet/aurora/Kconfig  |   23 -
>  drivers/net/ethernet/aurora/Makefile |    2 -
>  drivers/net/ethernet/aurora/nb8800.c | 1520 --------------------------
>  drivers/net/ethernet/aurora/nb8800.h |  316 ------
>  6 files changed, 1863 deletions(-)
>  delete mode 100644 drivers/net/ethernet/aurora/Kconfig
>  delete mode 100644 drivers/net/ethernet/aurora/Makefile
>  delete mode 100644 drivers/net/ethernet/aurora/nb8800.c
>  delete mode 100644 drivers/net/ethernet/aurora/nb8800.h
>
> diff --git a/drivers/net/ethernet/Kconfig b/drivers/net/ethernet/Kconfig
> index de50e8b9e656..ad04660b97b8 100644
> --- a/drivers/net/ethernet/Kconfig
> +++ b/drivers/net/ethernet/Kconfig
> @@ -33,7 +33,6 @@ source "drivers/net/ethernet/apple/Kconfig"
>  source "drivers/net/ethernet/aquantia/Kconfig"
>  source "drivers/net/ethernet/arc/Kconfig"
>  source "drivers/net/ethernet/atheros/Kconfig"
> -source "drivers/net/ethernet/aurora/Kconfig"
>  source "drivers/net/ethernet/broadcom/Kconfig"
>  source "drivers/net/ethernet/brocade/Kconfig"
>  source "drivers/net/ethernet/cadence/Kconfig"
> diff --git a/drivers/net/ethernet/Makefile b/drivers/net/ethernet/Makefile
> index f8f38dcb5f8a..1e7dc8a7762d 100644
> --- a/drivers/net/ethernet/Makefile
> +++ b/drivers/net/ethernet/Makefile
> @@ -19,7 +19,6 @@ obj-$(CONFIG_NET_VENDOR_APPLE) += apple/
>  obj-$(CONFIG_NET_VENDOR_AQUANTIA) += aquantia/
>  obj-$(CONFIG_NET_VENDOR_ARC) += arc/
>  obj-$(CONFIG_NET_VENDOR_ATHEROS) += atheros/
> -obj-$(CONFIG_NET_VENDOR_AURORA) += aurora/
>  obj-$(CONFIG_NET_VENDOR_CADENCE) += cadence/
>  obj-$(CONFIG_NET_VENDOR_BROADCOM) += broadcom/
>  obj-$(CONFIG_NET_VENDOR_BROCADE) += brocade/
> diff --git a/drivers/net/ethernet/aurora/Kconfig b/drivers/net/ethernet/aurora/Kconfig
> deleted file mode 100644
> index 9ee30ea90bfa..000000000000
> --- a/drivers/net/ethernet/aurora/Kconfig
> +++ /dev/null
> @@ -1,23 +0,0 @@
> -# SPDX-License-Identifier: GPL-2.0-only
> -config NET_VENDOR_AURORA
> -	bool "Aurora VLSI devices"
> -	default y
> -	help
> -	  If you have a network (Ethernet) device belonging to this class,
> -	  say Y.
> -
> -	  Note that the answer to this question doesn't directly affect the
> -	  kernel: saying N will just cause the configurator to skip all
> -	  questions about Aurora devices. If you say Y, you will be asked
> -	  for your specific device in the following questions.
> -
> -if NET_VENDOR_AURORA
> -
> -config AURORA_NB8800
> -	tristate "Aurora AU-NB8800 support"
> -	depends on HAS_DMA
> -	select PHYLIB
> -	help
> -	 Support for the AU-NB8800 gigabit Ethernet controller.
> -
> -endif
> diff --git a/drivers/net/ethernet/aurora/Makefile b/drivers/net/ethernet/aurora/Makefile
> deleted file mode 100644
> index f3d599867619..000000000000
> --- a/drivers/net/ethernet/aurora/Makefile
> +++ /dev/null
> @@ -1,2 +0,0 @@
> -# SPDX-License-Identifier: GPL-2.0-only
> -obj-$(CONFIG_AURORA_NB8800) += nb8800.o
> diff --git a/drivers/net/ethernet/aurora/nb8800.c b/drivers/net/ethernet/aurora/nb8800.c
> deleted file mode 100644
> index 5b20185cbd62..000000000000
> --- a/drivers/net/ethernet/aurora/nb8800.c
> +++ /dev/null
> @@ -1,1520 +0,0 @@
> -// SPDX-License-Identifier: GPL-2.0-or-later
> -/*
> - * Copyright (C) 2015 Mans Rullgard <mans@mansr.com>
> - *
> - * Mostly rewritten, based on driver from Sigma Designs.  Original
> - * copyright notice below.
> - *
> - * Driver for tangox SMP864x/SMP865x/SMP867x/SMP868x builtin Ethernet Mac.
> - *
> - * Copyright (C) 2005 Maxime Bizon <mbizon@freebox.fr>
> - */
> -
> -#include <linux/module.h>
> -#include <linux/etherdevice.h>
> -#include <linux/delay.h>
> -#include <linux/ethtool.h>
> -#include <linux/interrupt.h>
> -#include <linux/platform_device.h>
> -#include <linux/of_device.h>
> -#include <linux/of_mdio.h>
> -#include <linux/of_net.h>
> -#include <linux/dma-mapping.h>
> -#include <linux/phy.h>
> -#include <linux/cache.h>
> -#include <linux/jiffies.h>
> -#include <linux/io.h>
> -#include <linux/iopoll.h>
> -#include <asm/barrier.h>
> -
> -#include "nb8800.h"
> -
> -static void nb8800_tx_done(struct net_device *dev);
> -static int nb8800_dma_stop(struct net_device *dev);
> -
> -static inline u8 nb8800_readb(struct nb8800_priv *priv, int reg)
> -{
> -	return readb_relaxed(priv->base + reg);
> -}
> -
> -static inline u32 nb8800_readl(struct nb8800_priv *priv, int reg)
> -{
> -	return readl_relaxed(priv->base + reg);
> -}
> -
> -static inline void nb8800_writeb(struct nb8800_priv *priv, int reg, u8 val)
> -{
> -	writeb_relaxed(val, priv->base + reg);
> -}
> -
> -static inline void nb8800_writew(struct nb8800_priv *priv, int reg, u16 val)
> -{
> -	writew_relaxed(val, priv->base + reg);
> -}
> -
> -static inline void nb8800_writel(struct nb8800_priv *priv, int reg, u32 val)
> -{
> -	writel_relaxed(val, priv->base + reg);
> -}
> -
> -static inline void nb8800_maskb(struct nb8800_priv *priv, int reg,
> -				u32 mask, u32 val)
> -{
> -	u32 old = nb8800_readb(priv, reg);
> -	u32 new = (old & ~mask) | (val & mask);
> -
> -	if (new != old)
> -		nb8800_writeb(priv, reg, new);
> -}
> -
> -static inline void nb8800_maskl(struct nb8800_priv *priv, int reg,
> -				u32 mask, u32 val)
> -{
> -	u32 old = nb8800_readl(priv, reg);
> -	u32 new = (old & ~mask) | (val & mask);
> -
> -	if (new != old)
> -		nb8800_writel(priv, reg, new);
> -}
> -
> -static inline void nb8800_modb(struct nb8800_priv *priv, int reg, u8 bits,
> -			       bool set)
> -{
> -	nb8800_maskb(priv, reg, bits, set ? bits : 0);
> -}
> -
> -static inline void nb8800_setb(struct nb8800_priv *priv, int reg, u8 bits)
> -{
> -	nb8800_maskb(priv, reg, bits, bits);
> -}
> -
> -static inline void nb8800_clearb(struct nb8800_priv *priv, int reg, u8 bits)
> -{
> -	nb8800_maskb(priv, reg, bits, 0);
> -}
> -
> -static inline void nb8800_modl(struct nb8800_priv *priv, int reg, u32 bits,
> -			       bool set)
> -{
> -	nb8800_maskl(priv, reg, bits, set ? bits : 0);
> -}
> -
> -static inline void nb8800_setl(struct nb8800_priv *priv, int reg, u32 bits)
> -{
> -	nb8800_maskl(priv, reg, bits, bits);
> -}
> -
> -static inline void nb8800_clearl(struct nb8800_priv *priv, int reg, u32 bits)
> -{
> -	nb8800_maskl(priv, reg, bits, 0);
> -}
> -
> -static int nb8800_mdio_wait(struct mii_bus *bus)
> -{
> -	struct nb8800_priv *priv = bus->priv;
> -	u32 val;
> -
> -	return readl_poll_timeout_atomic(priv->base + NB8800_MDIO_CMD,
> -					 val, !(val & MDIO_CMD_GO), 1, 1000);
> -}
> -
> -static int nb8800_mdio_cmd(struct mii_bus *bus, u32 cmd)
> -{
> -	struct nb8800_priv *priv = bus->priv;
> -	int err;
> -
> -	err = nb8800_mdio_wait(bus);
> -	if (err)
> -		return err;
> -
> -	nb8800_writel(priv, NB8800_MDIO_CMD, cmd);
> -	udelay(10);
> -	nb8800_writel(priv, NB8800_MDIO_CMD, cmd | MDIO_CMD_GO);
> -
> -	return nb8800_mdio_wait(bus);
> -}
> -
> -static int nb8800_mdio_read(struct mii_bus *bus, int phy_id, int reg)
> -{
> -	struct nb8800_priv *priv = bus->priv;
> -	u32 val;
> -	int err;
> -
> -	err = nb8800_mdio_cmd(bus, MDIO_CMD_ADDR(phy_id) | MDIO_CMD_REG(reg));
> -	if (err)
> -		return err;
> -
> -	val = nb8800_readl(priv, NB8800_MDIO_STS);
> -	if (val & MDIO_STS_ERR)
> -		return 0xffff;
> -
> -	return val & 0xffff;
> -}
> -
> -static int nb8800_mdio_write(struct mii_bus *bus, int phy_id, int reg, u16 val)
> -{
> -	u32 cmd = MDIO_CMD_ADDR(phy_id) | MDIO_CMD_REG(reg) |
> -		MDIO_CMD_DATA(val) | MDIO_CMD_WR;
> -
> -	return nb8800_mdio_cmd(bus, cmd);
> -}
> -
> -static void nb8800_mac_tx(struct net_device *dev, bool enable)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -
> -	while (nb8800_readl(priv, NB8800_TXC_CR) & TCR_EN)
> -		cpu_relax();
> -
> -	nb8800_modb(priv, NB8800_TX_CTL1, TX_EN, enable);
> -}
> -
> -static void nb8800_mac_rx(struct net_device *dev, bool enable)
> -{
> -	nb8800_modb(netdev_priv(dev), NB8800_RX_CTL, RX_EN, enable);
> -}
> -
> -static void nb8800_mac_af(struct net_device *dev, bool enable)
> -{
> -	nb8800_modb(netdev_priv(dev), NB8800_RX_CTL, RX_AF_EN, enable);
> -}
> -
> -static void nb8800_start_rx(struct net_device *dev)
> -{
> -	nb8800_setl(netdev_priv(dev), NB8800_RXC_CR, RCR_EN);
> -}
> -
> -static int nb8800_alloc_rx(struct net_device *dev, unsigned int i, bool napi)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct nb8800_rx_desc *rxd = &priv->rx_descs[i];
> -	struct nb8800_rx_buf *rxb = &priv->rx_bufs[i];
> -	int size = L1_CACHE_ALIGN(RX_BUF_SIZE);
> -	dma_addr_t dma_addr;
> -	struct page *page;
> -	unsigned long offset;
> -	void *data;
> -
> -	data = napi ? napi_alloc_frag(size) : netdev_alloc_frag(size);
> -	if (!data)
> -		return -ENOMEM;
> -
> -	page = virt_to_head_page(data);
> -	offset = data - page_address(page);
> -
> -	dma_addr = dma_map_page(&dev->dev, page, offset, RX_BUF_SIZE,
> -				DMA_FROM_DEVICE);
> -
> -	if (dma_mapping_error(&dev->dev, dma_addr)) {
> -		skb_free_frag(data);
> -		return -ENOMEM;
> -	}
> -
> -	rxb->page = page;
> -	rxb->offset = offset;
> -	rxd->desc.s_addr = dma_addr;
> -
> -	return 0;
> -}
> -
> -static void nb8800_receive(struct net_device *dev, unsigned int i,
> -			   unsigned int len)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct nb8800_rx_desc *rxd = &priv->rx_descs[i];
> -	struct page *page = priv->rx_bufs[i].page;
> -	int offset = priv->rx_bufs[i].offset;
> -	void *data = page_address(page) + offset;
> -	dma_addr_t dma = rxd->desc.s_addr;
> -	struct sk_buff *skb;
> -	unsigned int size;
> -	int err;
> -
> -	size = len <= RX_COPYBREAK ? len : RX_COPYHDR;
> -
> -	skb = napi_alloc_skb(&priv->napi, size);
> -	if (!skb) {
> -		netdev_err(dev, "rx skb allocation failed\n");
> -		dev->stats.rx_dropped++;
> -		return;
> -	}
> -
> -	if (len <= RX_COPYBREAK) {
> -		dma_sync_single_for_cpu(&dev->dev, dma, len, DMA_FROM_DEVICE);
> -		skb_put_data(skb, data, len);
> -		dma_sync_single_for_device(&dev->dev, dma, len,
> -					   DMA_FROM_DEVICE);
> -	} else {
> -		err = nb8800_alloc_rx(dev, i, true);
> -		if (err) {
> -			netdev_err(dev, "rx buffer allocation failed\n");
> -			dev->stats.rx_dropped++;
> -			dev_kfree_skb(skb);
> -			return;
> -		}
> -
> -		dma_unmap_page(&dev->dev, dma, RX_BUF_SIZE, DMA_FROM_DEVICE);
> -		skb_put_data(skb, data, RX_COPYHDR);
> -		skb_add_rx_frag(skb, skb_shinfo(skb)->nr_frags, page,
> -				offset + RX_COPYHDR, len - RX_COPYHDR,
> -				RX_BUF_SIZE);
> -	}
> -
> -	skb->protocol = eth_type_trans(skb, dev);
> -	napi_gro_receive(&priv->napi, skb);
> -}
> -
> -static void nb8800_rx_error(struct net_device *dev, u32 report)
> -{
> -	if (report & RX_LENGTH_ERR)
> -		dev->stats.rx_length_errors++;
> -
> -	if (report & RX_FCS_ERR)
> -		dev->stats.rx_crc_errors++;
> -
> -	if (report & RX_FIFO_OVERRUN)
> -		dev->stats.rx_fifo_errors++;
> -
> -	if (report & RX_ALIGNMENT_ERROR)
> -		dev->stats.rx_frame_errors++;
> -
> -	dev->stats.rx_errors++;
> -}
> -
> -static int nb8800_poll(struct napi_struct *napi, int budget)
> -{
> -	struct net_device *dev = napi->dev;
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct nb8800_rx_desc *rxd;
> -	unsigned int last = priv->rx_eoc;
> -	unsigned int next;
> -	int work = 0;
> -
> -	nb8800_tx_done(dev);
> -
> -again:
> -	do {
> -		unsigned int len;
> -
> -		next = (last + 1) % RX_DESC_COUNT;
> -
> -		rxd = &priv->rx_descs[next];
> -
> -		if (!rxd->report)
> -			break;
> -
> -		len = RX_BYTES_TRANSFERRED(rxd->report);
> -
> -		if (IS_RX_ERROR(rxd->report))
> -			nb8800_rx_error(dev, rxd->report);
> -		else
> -			nb8800_receive(dev, next, len);
> -
> -		dev->stats.rx_packets++;
> -		dev->stats.rx_bytes += len;
> -
> -		if (rxd->report & RX_MULTICAST_PKT)
> -			dev->stats.multicast++;
> -
> -		rxd->report = 0;
> -		last = next;
> -		work++;
> -	} while (work < budget);
> -
> -	if (work) {
> -		priv->rx_descs[last].desc.config |= DESC_EOC;
> -		wmb();	/* ensure new EOC is written before clearing old */
> -		priv->rx_descs[priv->rx_eoc].desc.config &= ~DESC_EOC;
> -		priv->rx_eoc = last;
> -		nb8800_start_rx(dev);
> -	}
> -
> -	if (work < budget) {
> -		nb8800_writel(priv, NB8800_RX_ITR, priv->rx_itr_irq);
> -
> -		/* If a packet arrived after we last checked but
> -		 * before writing RX_ITR, the interrupt will be
> -		 * delayed, so we retrieve it now.
> -		 */
> -		if (priv->rx_descs[next].report)
> -			goto again;
> -
> -		napi_complete_done(napi, work);
> -	}
> -
> -	return work;
> -}
> -
> -static void __nb8800_tx_dma_start(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct nb8800_tx_buf *txb;
> -	u32 txc_cr;
> -
> -	txb = &priv->tx_bufs[priv->tx_queue];
> -	if (!txb->ready)
> -		return;
> -
> -	txc_cr = nb8800_readl(priv, NB8800_TXC_CR);
> -	if (txc_cr & TCR_EN)
> -		return;
> -
> -	nb8800_writel(priv, NB8800_TX_DESC_ADDR, txb->dma_desc);
> -	wmb();		/* ensure desc addr is written before starting DMA */
> -	nb8800_writel(priv, NB8800_TXC_CR, txc_cr | TCR_EN);
> -
> -	priv->tx_queue = (priv->tx_queue + txb->chain_len) % TX_DESC_COUNT;
> -}
> -
> -static void nb8800_tx_dma_start(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -
> -	spin_lock_irq(&priv->tx_lock);
> -	__nb8800_tx_dma_start(dev);
> -	spin_unlock_irq(&priv->tx_lock);
> -}
> -
> -static void nb8800_tx_dma_start_irq(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -
> -	spin_lock(&priv->tx_lock);
> -	__nb8800_tx_dma_start(dev);
> -	spin_unlock(&priv->tx_lock);
> -}
> -
> -static netdev_tx_t nb8800_xmit(struct sk_buff *skb, struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct nb8800_tx_desc *txd;
> -	struct nb8800_tx_buf *txb;
> -	struct nb8800_dma_desc *desc;
> -	dma_addr_t dma_addr;
> -	unsigned int dma_len;
> -	unsigned int align;
> -	unsigned int next;
> -	bool xmit_more;
> -
> -	if (atomic_read(&priv->tx_free) <= NB8800_DESC_LOW) {
> -		netif_stop_queue(dev);
> -		return NETDEV_TX_BUSY;
> -	}
> -
> -	align = (8 - (uintptr_t)skb->data) & 7;
> -
> -	dma_len = skb->len - align;
> -	dma_addr = dma_map_single(&dev->dev, skb->data + align,
> -				  dma_len, DMA_TO_DEVICE);
> -
> -	if (dma_mapping_error(&dev->dev, dma_addr)) {
> -		netdev_err(dev, "tx dma mapping error\n");
> -		kfree_skb(skb);
> -		dev->stats.tx_dropped++;
> -		return NETDEV_TX_OK;
> -	}
> -
> -	xmit_more = netdev_xmit_more();
> -	if (atomic_dec_return(&priv->tx_free) <= NB8800_DESC_LOW) {
> -		netif_stop_queue(dev);
> -		xmit_more = false;
> -	}
> -
> -	next = priv->tx_next;
> -	txb = &priv->tx_bufs[next];
> -	txd = &priv->tx_descs[next];
> -	desc = &txd->desc[0];
> -
> -	next = (next + 1) % TX_DESC_COUNT;
> -
> -	if (align) {
> -		memcpy(txd->buf, skb->data, align);
> -
> -		desc->s_addr =
> -			txb->dma_desc + offsetof(struct nb8800_tx_desc, buf);
> -		desc->n_addr = txb->dma_desc + sizeof(txd->desc[0]);
> -		desc->config = DESC_BTS(2) | DESC_DS | align;
> -
> -		desc++;
> -	}
> -
> -	desc->s_addr = dma_addr;
> -	desc->n_addr = priv->tx_bufs[next].dma_desc;
> -	desc->config = DESC_BTS(2) | DESC_DS | DESC_EOF | dma_len;
> -
> -	if (!xmit_more)
> -		desc->config |= DESC_EOC;
> -
> -	txb->skb = skb;
> -	txb->dma_addr = dma_addr;
> -	txb->dma_len = dma_len;
> -
> -	if (!priv->tx_chain) {
> -		txb->chain_len = 1;
> -		priv->tx_chain = txb;
> -	} else {
> -		priv->tx_chain->chain_len++;
> -	}
> -
> -	netdev_sent_queue(dev, skb->len);
> -
> -	priv->tx_next = next;
> -
> -	if (!xmit_more) {
> -		smp_wmb();
> -		priv->tx_chain->ready = true;
> -		priv->tx_chain = NULL;
> -		nb8800_tx_dma_start(dev);
> -	}
> -
> -	return NETDEV_TX_OK;
> -}
> -
> -static void nb8800_tx_error(struct net_device *dev, u32 report)
> -{
> -	if (report & TX_LATE_COLLISION)
> -		dev->stats.collisions++;
> -
> -	if (report & TX_PACKET_DROPPED)
> -		dev->stats.tx_dropped++;
> -
> -	if (report & TX_FIFO_UNDERRUN)
> -		dev->stats.tx_fifo_errors++;
> -
> -	dev->stats.tx_errors++;
> -}
> -
> -static void nb8800_tx_done(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	unsigned int limit = priv->tx_next;
> -	unsigned int done = priv->tx_done;
> -	unsigned int packets = 0;
> -	unsigned int len = 0;
> -
> -	while (done != limit) {
> -		struct nb8800_tx_desc *txd = &priv->tx_descs[done];
> -		struct nb8800_tx_buf *txb = &priv->tx_bufs[done];
> -		struct sk_buff *skb;
> -
> -		if (!txd->report)
> -			break;
> -
> -		skb = txb->skb;
> -		len += skb->len;
> -
> -		dma_unmap_single(&dev->dev, txb->dma_addr, txb->dma_len,
> -				 DMA_TO_DEVICE);
> -
> -		if (IS_TX_ERROR(txd->report)) {
> -			nb8800_tx_error(dev, txd->report);
> -			kfree_skb(skb);
> -		} else {
> -			consume_skb(skb);
> -		}
> -
> -		dev->stats.tx_packets++;
> -		dev->stats.tx_bytes += TX_BYTES_TRANSFERRED(txd->report);
> -		dev->stats.collisions += TX_EARLY_COLLISIONS(txd->report);
> -
> -		txb->skb = NULL;
> -		txb->ready = false;
> -		txd->report = 0;
> -
> -		done = (done + 1) % TX_DESC_COUNT;
> -		packets++;
> -	}
> -
> -	if (packets) {
> -		smp_mb__before_atomic();
> -		atomic_add(packets, &priv->tx_free);
> -		netdev_completed_queue(dev, packets, len);
> -		netif_wake_queue(dev);
> -		priv->tx_done = done;
> -	}
> -}
> -
> -static irqreturn_t nb8800_irq(int irq, void *dev_id)
> -{
> -	struct net_device *dev = dev_id;
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	irqreturn_t ret = IRQ_NONE;
> -	u32 val;
> -
> -	/* tx interrupt */
> -	val = nb8800_readl(priv, NB8800_TXC_SR);
> -	if (val) {
> -		nb8800_writel(priv, NB8800_TXC_SR, val);
> -
> -		if (val & TSR_DI)
> -			nb8800_tx_dma_start_irq(dev);
> -
> -		if (val & TSR_TI)
> -			napi_schedule_irqoff(&priv->napi);
> -
> -		if (unlikely(val & TSR_DE))
> -			netdev_err(dev, "TX DMA error\n");
> -
> -		/* should never happen with automatic status retrieval */
> -		if (unlikely(val & TSR_TO))
> -			netdev_err(dev, "TX Status FIFO overflow\n");
> -
> -		ret = IRQ_HANDLED;
> -	}
> -
> -	/* rx interrupt */
> -	val = nb8800_readl(priv, NB8800_RXC_SR);
> -	if (val) {
> -		nb8800_writel(priv, NB8800_RXC_SR, val);
> -
> -		if (likely(val & (RSR_RI | RSR_DI))) {
> -			nb8800_writel(priv, NB8800_RX_ITR, priv->rx_itr_poll);
> -			napi_schedule_irqoff(&priv->napi);
> -		}
> -
> -		if (unlikely(val & RSR_DE))
> -			netdev_err(dev, "RX DMA error\n");
> -
> -		/* should never happen with automatic status retrieval */
> -		if (unlikely(val & RSR_RO))
> -			netdev_err(dev, "RX Status FIFO overflow\n");
> -
> -		ret = IRQ_HANDLED;
> -	}
> -
> -	return ret;
> -}
> -
> -static void nb8800_mac_config(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	bool gigabit = priv->speed == SPEED_1000;
> -	u32 mac_mode_mask = RGMII_MODE | HALF_DUPLEX | GMAC_MODE;
> -	u32 mac_mode = 0;
> -	u32 slot_time;
> -	u32 phy_clk;
> -	u32 ict;
> -
> -	if (!priv->duplex)
> -		mac_mode |= HALF_DUPLEX;
> -
> -	if (gigabit) {
> -		if (phy_interface_is_rgmii(dev->phydev))
> -			mac_mode |= RGMII_MODE;
> -
> -		mac_mode |= GMAC_MODE;
> -		phy_clk = 125000000;
> -
> -		/* Should be 512 but register is only 8 bits */
> -		slot_time = 255;
> -	} else {
> -		phy_clk = 25000000;
> -		slot_time = 128;
> -	}
> -
> -	ict = DIV_ROUND_UP(phy_clk, clk_get_rate(priv->clk));
> -
> -	nb8800_writeb(priv, NB8800_IC_THRESHOLD, ict);
> -	nb8800_writeb(priv, NB8800_SLOT_TIME, slot_time);
> -	nb8800_maskb(priv, NB8800_MAC_MODE, mac_mode_mask, mac_mode);
> -}
> -
> -static void nb8800_pause_config(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct phy_device *phydev = dev->phydev;
> -	u32 rxcr;
> -
> -	if (priv->pause_aneg) {
> -		if (!phydev || !phydev->link)
> -			return;
> -
> -		priv->pause_rx = phydev->pause;
> -		priv->pause_tx = phydev->pause ^ phydev->asym_pause;
> -	}
> -
> -	nb8800_modb(priv, NB8800_RX_CTL, RX_PAUSE_EN, priv->pause_rx);
> -
> -	rxcr = nb8800_readl(priv, NB8800_RXC_CR);
> -	if (!!(rxcr & RCR_FL) == priv->pause_tx)
> -		return;
> -
> -	if (netif_running(dev)) {
> -		napi_disable(&priv->napi);
> -		netif_tx_lock_bh(dev);
> -		nb8800_dma_stop(dev);
> -		nb8800_modl(priv, NB8800_RXC_CR, RCR_FL, priv->pause_tx);
> -		nb8800_start_rx(dev);
> -		netif_tx_unlock_bh(dev);
> -		napi_enable(&priv->napi);
> -	} else {
> -		nb8800_modl(priv, NB8800_RXC_CR, RCR_FL, priv->pause_tx);
> -	}
> -}
> -
> -static void nb8800_link_reconfigure(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct phy_device *phydev = dev->phydev;
> -	int change = 0;
> -
> -	if (phydev->link) {
> -		if (phydev->speed != priv->speed) {
> -			priv->speed = phydev->speed;
> -			change = 1;
> -		}
> -
> -		if (phydev->duplex != priv->duplex) {
> -			priv->duplex = phydev->duplex;
> -			change = 1;
> -		}
> -
> -		if (change)
> -			nb8800_mac_config(dev);
> -
> -		nb8800_pause_config(dev);
> -	}
> -
> -	if (phydev->link != priv->link) {
> -		priv->link = phydev->link;
> -		change = 1;
> -	}
> -
> -	if (change)
> -		phy_print_status(phydev);
> -}
> -
> -static void nb8800_update_mac_addr(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	int i;
> -
> -	for (i = 0; i < ETH_ALEN; i++)
> -		nb8800_writeb(priv, NB8800_SRC_ADDR(i), dev->dev_addr[i]);
> -
> -	for (i = 0; i < ETH_ALEN; i++)
> -		nb8800_writeb(priv, NB8800_UC_ADDR(i), dev->dev_addr[i]);
> -}
> -
> -static int nb8800_set_mac_address(struct net_device *dev, void *addr)
> -{
> -	struct sockaddr *sock = addr;
> -
> -	if (netif_running(dev))
> -		return -EBUSY;
> -
> -	ether_addr_copy(dev->dev_addr, sock->sa_data);
> -	nb8800_update_mac_addr(dev);
> -
> -	return 0;
> -}
> -
> -static void nb8800_mc_init(struct net_device *dev, int val)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -
> -	nb8800_writeb(priv, NB8800_MC_INIT, val);
> -	readb_poll_timeout_atomic(priv->base + NB8800_MC_INIT, val, !val,
> -				  1, 1000);
> -}
> -
> -static void nb8800_set_rx_mode(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct netdev_hw_addr *ha;
> -	int i;
> -
> -	if (dev->flags & (IFF_PROMISC | IFF_ALLMULTI)) {
> -		nb8800_mac_af(dev, false);
> -		return;
> -	}
> -
> -	nb8800_mac_af(dev, true);
> -	nb8800_mc_init(dev, 0);
> -
> -	netdev_for_each_mc_addr(ha, dev) {
> -		for (i = 0; i < ETH_ALEN; i++)
> -			nb8800_writeb(priv, NB8800_MC_ADDR(i), ha->addr[i]);
> -
> -		nb8800_mc_init(dev, 0xff);
> -	}
> -}
> -
> -#define RX_DESC_SIZE (RX_DESC_COUNT * sizeof(struct nb8800_rx_desc))
> -#define TX_DESC_SIZE (TX_DESC_COUNT * sizeof(struct nb8800_tx_desc))
> -
> -static void nb8800_dma_free(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	unsigned int i;
> -
> -	if (priv->rx_bufs) {
> -		for (i = 0; i < RX_DESC_COUNT; i++)
> -			if (priv->rx_bufs[i].page)
> -				put_page(priv->rx_bufs[i].page);
> -
> -		kfree(priv->rx_bufs);
> -		priv->rx_bufs = NULL;
> -	}
> -
> -	if (priv->tx_bufs) {
> -		for (i = 0; i < TX_DESC_COUNT; i++)
> -			kfree_skb(priv->tx_bufs[i].skb);
> -
> -		kfree(priv->tx_bufs);
> -		priv->tx_bufs = NULL;
> -	}
> -
> -	if (priv->rx_descs) {
> -		dma_free_coherent(dev->dev.parent, RX_DESC_SIZE, priv->rx_descs,
> -				  priv->rx_desc_dma);
> -		priv->rx_descs = NULL;
> -	}
> -
> -	if (priv->tx_descs) {
> -		dma_free_coherent(dev->dev.parent, TX_DESC_SIZE, priv->tx_descs,
> -				  priv->tx_desc_dma);
> -		priv->tx_descs = NULL;
> -	}
> -}
> -
> -static void nb8800_dma_reset(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct nb8800_rx_desc *rxd;
> -	struct nb8800_tx_desc *txd;
> -	unsigned int i;
> -
> -	for (i = 0; i < RX_DESC_COUNT; i++) {
> -		dma_addr_t rx_dma = priv->rx_desc_dma + i * sizeof(*rxd);
> -
> -		rxd = &priv->rx_descs[i];
> -		rxd->desc.n_addr = rx_dma + sizeof(*rxd);
> -		rxd->desc.r_addr =
> -			rx_dma + offsetof(struct nb8800_rx_desc, report);
> -		rxd->desc.config = priv->rx_dma_config;
> -		rxd->report = 0;
> -	}
> -
> -	rxd->desc.n_addr = priv->rx_desc_dma;
> -	rxd->desc.config |= DESC_EOC;
> -
> -	priv->rx_eoc = RX_DESC_COUNT - 1;
> -
> -	for (i = 0; i < TX_DESC_COUNT; i++) {
> -		struct nb8800_tx_buf *txb = &priv->tx_bufs[i];
> -		dma_addr_t r_dma = txb->dma_desc +
> -			offsetof(struct nb8800_tx_desc, report);
> -
> -		txd = &priv->tx_descs[i];
> -		txd->desc[0].r_addr = r_dma;
> -		txd->desc[1].r_addr = r_dma;
> -		txd->report = 0;
> -	}
> -
> -	priv->tx_next = 0;
> -	priv->tx_queue = 0;
> -	priv->tx_done = 0;
> -	atomic_set(&priv->tx_free, TX_DESC_COUNT);
> -
> -	nb8800_writel(priv, NB8800_RX_DESC_ADDR, priv->rx_desc_dma);
> -
> -	wmb();		/* ensure all setup is written before starting */
> -}
> -
> -static int nb8800_dma_init(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	unsigned int n_rx = RX_DESC_COUNT;
> -	unsigned int n_tx = TX_DESC_COUNT;
> -	unsigned int i;
> -	int err;
> -
> -	priv->rx_descs = dma_alloc_coherent(dev->dev.parent, RX_DESC_SIZE,
> -					    &priv->rx_desc_dma, GFP_KERNEL);
> -	if (!priv->rx_descs)
> -		goto err_out;
> -
> -	priv->rx_bufs = kcalloc(n_rx, sizeof(*priv->rx_bufs), GFP_KERNEL);
> -	if (!priv->rx_bufs)
> -		goto err_out;
> -
> -	for (i = 0; i < n_rx; i++) {
> -		err = nb8800_alloc_rx(dev, i, false);
> -		if (err)
> -			goto err_out;
> -	}
> -
> -	priv->tx_descs = dma_alloc_coherent(dev->dev.parent, TX_DESC_SIZE,
> -					    &priv->tx_desc_dma, GFP_KERNEL);
> -	if (!priv->tx_descs)
> -		goto err_out;
> -
> -	priv->tx_bufs = kcalloc(n_tx, sizeof(*priv->tx_bufs), GFP_KERNEL);
> -	if (!priv->tx_bufs)
> -		goto err_out;
> -
> -	for (i = 0; i < n_tx; i++)
> -		priv->tx_bufs[i].dma_desc =
> -			priv->tx_desc_dma + i * sizeof(struct nb8800_tx_desc);
> -
> -	nb8800_dma_reset(dev);
> -
> -	return 0;
> -
> -err_out:
> -	nb8800_dma_free(dev);
> -
> -	return -ENOMEM;
> -}
> -
> -static int nb8800_dma_stop(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct nb8800_tx_buf *txb = &priv->tx_bufs[0];
> -	struct nb8800_tx_desc *txd = &priv->tx_descs[0];
> -	int retry = 5;
> -	u32 txcr;
> -	u32 rxcr;
> -	int err;
> -	unsigned int i;
> -
> -	/* wait for tx to finish */
> -	err = readl_poll_timeout_atomic(priv->base + NB8800_TXC_CR, txcr,
> -					!(txcr & TCR_EN) &&
> -					priv->tx_done == priv->tx_next,
> -					1000, 1000000);
> -	if (err)
> -		return err;
> -
> -	/* The rx DMA only stops if it reaches the end of chain.
> -	 * To make this happen, we set the EOC flag on all rx
> -	 * descriptors, put the device in loopback mode, and send
> -	 * a few dummy frames.  The interrupt handler will ignore
> -	 * these since NAPI is disabled and no real frames are in
> -	 * the tx queue.
> -	 */
> -
> -	for (i = 0; i < RX_DESC_COUNT; i++)
> -		priv->rx_descs[i].desc.config |= DESC_EOC;
> -
> -	txd->desc[0].s_addr =
> -		txb->dma_desc + offsetof(struct nb8800_tx_desc, buf);
> -	txd->desc[0].config = DESC_BTS(2) | DESC_DS | DESC_EOF | DESC_EOC | 8;
> -	memset(txd->buf, 0, sizeof(txd->buf));
> -
> -	nb8800_mac_af(dev, false);
> -	nb8800_setb(priv, NB8800_MAC_MODE, LOOPBACK_EN);
> -
> -	do {
> -		nb8800_writel(priv, NB8800_TX_DESC_ADDR, txb->dma_desc);
> -		wmb();
> -		nb8800_writel(priv, NB8800_TXC_CR, txcr | TCR_EN);
> -
> -		err = readl_poll_timeout_atomic(priv->base + NB8800_RXC_CR,
> -						rxcr, !(rxcr & RCR_EN),
> -						1000, 100000);
> -	} while (err && --retry);
> -
> -	nb8800_mac_af(dev, true);
> -	nb8800_clearb(priv, NB8800_MAC_MODE, LOOPBACK_EN);
> -	nb8800_dma_reset(dev);
> -
> -	return retry ? 0 : -ETIMEDOUT;
> -}
> -
> -static void nb8800_pause_adv(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct phy_device *phydev = dev->phydev;
> -
> -	if (!phydev)
> -		return;
> -
> -	phy_set_asym_pause(phydev, priv->pause_rx, priv->pause_tx);
> -}
> -
> -static int nb8800_open(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct phy_device *phydev;
> -	int err;
> -
> -	/* clear any pending interrupts */
> -	nb8800_writel(priv, NB8800_RXC_SR, 0xf);
> -	nb8800_writel(priv, NB8800_TXC_SR, 0xf);
> -
> -	err = nb8800_dma_init(dev);
> -	if (err)
> -		return err;
> -
> -	err = request_irq(dev->irq, nb8800_irq, 0, dev_name(&dev->dev), dev);
> -	if (err)
> -		goto err_free_dma;
> -
> -	nb8800_mac_rx(dev, true);
> -	nb8800_mac_tx(dev, true);
> -
> -	phydev = of_phy_connect(dev, priv->phy_node,
> -				nb8800_link_reconfigure, 0,
> -				priv->phy_mode);
> -	if (!phydev) {
> -		err = -ENODEV;
> -		goto err_free_irq;
> -	}
> -
> -	nb8800_pause_adv(dev);
> -
> -	netdev_reset_queue(dev);
> -	napi_enable(&priv->napi);
> -	netif_start_queue(dev);
> -
> -	nb8800_start_rx(dev);
> -	phy_start(phydev);
> -
> -	return 0;
> -
> -err_free_irq:
> -	free_irq(dev->irq, dev);
> -err_free_dma:
> -	nb8800_dma_free(dev);
> -
> -	return err;
> -}
> -
> -static int nb8800_stop(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct phy_device *phydev = dev->phydev;
> -
> -	phy_stop(phydev);
> -
> -	netif_stop_queue(dev);
> -	napi_disable(&priv->napi);
> -
> -	nb8800_dma_stop(dev);
> -	nb8800_mac_rx(dev, false);
> -	nb8800_mac_tx(dev, false);
> -
> -	phy_disconnect(phydev);
> -
> -	free_irq(dev->irq, dev);
> -
> -	nb8800_dma_free(dev);
> -
> -	return 0;
> -}
> -
> -static const struct net_device_ops nb8800_netdev_ops = {
> -	.ndo_open		= nb8800_open,
> -	.ndo_stop		= nb8800_stop,
> -	.ndo_start_xmit		= nb8800_xmit,
> -	.ndo_set_mac_address	= nb8800_set_mac_address,
> -	.ndo_set_rx_mode	= nb8800_set_rx_mode,
> -	.ndo_do_ioctl		= phy_do_ioctl,
> -	.ndo_validate_addr	= eth_validate_addr,
> -};
> -
> -static void nb8800_get_pauseparam(struct net_device *dev,
> -				  struct ethtool_pauseparam *pp)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -
> -	pp->autoneg = priv->pause_aneg;
> -	pp->rx_pause = priv->pause_rx;
> -	pp->tx_pause = priv->pause_tx;
> -}
> -
> -static int nb8800_set_pauseparam(struct net_device *dev,
> -				 struct ethtool_pauseparam *pp)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	struct phy_device *phydev = dev->phydev;
> -
> -	priv->pause_aneg = pp->autoneg;
> -	priv->pause_rx = pp->rx_pause;
> -	priv->pause_tx = pp->tx_pause;
> -
> -	nb8800_pause_adv(dev);
> -
> -	if (!priv->pause_aneg)
> -		nb8800_pause_config(dev);
> -	else if (phydev)
> -		phy_start_aneg(phydev);
> -
> -	return 0;
> -}
> -
> -static const char nb8800_stats_names[][ETH_GSTRING_LEN] = {
> -	"rx_bytes_ok",
> -	"rx_frames_ok",
> -	"rx_undersize_frames",
> -	"rx_fragment_frames",
> -	"rx_64_byte_frames",
> -	"rx_127_byte_frames",
> -	"rx_255_byte_frames",
> -	"rx_511_byte_frames",
> -	"rx_1023_byte_frames",
> -	"rx_max_size_frames",
> -	"rx_oversize_frames",
> -	"rx_bad_fcs_frames",
> -	"rx_broadcast_frames",
> -	"rx_multicast_frames",
> -	"rx_control_frames",
> -	"rx_pause_frames",
> -	"rx_unsup_control_frames",
> -	"rx_align_error_frames",
> -	"rx_overrun_frames",
> -	"rx_jabber_frames",
> -	"rx_bytes",
> -	"rx_frames",
> -
> -	"tx_bytes_ok",
> -	"tx_frames_ok",
> -	"tx_64_byte_frames",
> -	"tx_127_byte_frames",
> -	"tx_255_byte_frames",
> -	"tx_511_byte_frames",
> -	"tx_1023_byte_frames",
> -	"tx_max_size_frames",
> -	"tx_oversize_frames",
> -	"tx_broadcast_frames",
> -	"tx_multicast_frames",
> -	"tx_control_frames",
> -	"tx_pause_frames",
> -	"tx_underrun_frames",
> -	"tx_single_collision_frames",
> -	"tx_multi_collision_frames",
> -	"tx_deferred_collision_frames",
> -	"tx_late_collision_frames",
> -	"tx_excessive_collision_frames",
> -	"tx_bytes",
> -	"tx_frames",
> -	"tx_collisions",
> -};
> -
> -#define NB8800_NUM_STATS ARRAY_SIZE(nb8800_stats_names)
> -
> -static int nb8800_get_sset_count(struct net_device *dev, int sset)
> -{
> -	if (sset == ETH_SS_STATS)
> -		return NB8800_NUM_STATS;
> -
> -	return -EOPNOTSUPP;
> -}
> -
> -static void nb8800_get_strings(struct net_device *dev, u32 sset, u8 *buf)
> -{
> -	if (sset == ETH_SS_STATS)
> -		memcpy(buf, &nb8800_stats_names, sizeof(nb8800_stats_names));
> -}
> -
> -static u32 nb8800_read_stat(struct net_device *dev, int index)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -
> -	nb8800_writeb(priv, NB8800_STAT_INDEX, index);
> -
> -	return nb8800_readl(priv, NB8800_STAT_DATA);
> -}
> -
> -static void nb8800_get_ethtool_stats(struct net_device *dev,
> -				     struct ethtool_stats *estats, u64 *st)
> -{
> -	unsigned int i;
> -	u32 rx, tx;
> -
> -	for (i = 0; i < NB8800_NUM_STATS / 2; i++) {
> -		rx = nb8800_read_stat(dev, i);
> -		tx = nb8800_read_stat(dev, i | 0x80);
> -		st[i] = rx;
> -		st[i + NB8800_NUM_STATS / 2] = tx;
> -	}
> -}
> -
> -static const struct ethtool_ops nb8800_ethtool_ops = {
> -	.nway_reset		= phy_ethtool_nway_reset,
> -	.get_link		= ethtool_op_get_link,
> -	.get_pauseparam		= nb8800_get_pauseparam,
> -	.set_pauseparam		= nb8800_set_pauseparam,
> -	.get_sset_count		= nb8800_get_sset_count,
> -	.get_strings		= nb8800_get_strings,
> -	.get_ethtool_stats	= nb8800_get_ethtool_stats,
> -	.get_link_ksettings	= phy_ethtool_get_link_ksettings,
> -	.set_link_ksettings	= phy_ethtool_set_link_ksettings,
> -};
> -
> -static int nb8800_hw_init(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	u32 val;
> -
> -	val = TX_RETRY_EN | TX_PAD_EN | TX_APPEND_FCS;
> -	nb8800_writeb(priv, NB8800_TX_CTL1, val);
> -
> -	/* Collision retry count */
> -	nb8800_writeb(priv, NB8800_TX_CTL2, 5);
> -
> -	val = RX_PAD_STRIP | RX_AF_EN;
> -	nb8800_writeb(priv, NB8800_RX_CTL, val);
> -
> -	/* Chosen by fair dice roll */
> -	nb8800_writeb(priv, NB8800_RANDOM_SEED, 4);
> -
> -	/* TX cycles per deferral period */
> -	nb8800_writeb(priv, NB8800_TX_SDP, 12);
> -
> -	/* The following three threshold values have been
> -	 * experimentally determined for good results.
> -	 */
> -
> -	/* RX/TX FIFO threshold for partial empty (64-bit entries) */
> -	nb8800_writeb(priv, NB8800_PE_THRESHOLD, 0);
> -
> -	/* RX/TX FIFO threshold for partial full (64-bit entries) */
> -	nb8800_writeb(priv, NB8800_PF_THRESHOLD, 255);
> -
> -	/* Buffer size for transmit (64-bit entries) */
> -	nb8800_writeb(priv, NB8800_TX_BUFSIZE, 64);
> -
> -	/* Configure tx DMA */
> -
> -	val = nb8800_readl(priv, NB8800_TXC_CR);
> -	val &= TCR_LE;		/* keep endian setting */
> -	val |= TCR_DM;		/* DMA descriptor mode */
> -	val |= TCR_RS;		/* automatically store tx status  */
> -	val |= TCR_DIE;		/* interrupt on DMA chain completion */
> -	val |= TCR_TFI(7);	/* interrupt after 7 frames transmitted */
> -	val |= TCR_BTS(2);	/* 32-byte bus transaction size */
> -	nb8800_writel(priv, NB8800_TXC_CR, val);
> -
> -	/* TX complete interrupt after 10 ms or 7 frames (see above) */
> -	val = clk_get_rate(priv->clk) / 100;
> -	nb8800_writel(priv, NB8800_TX_ITR, val);
> -
> -	/* Configure rx DMA */
> -
> -	val = nb8800_readl(priv, NB8800_RXC_CR);
> -	val &= RCR_LE;		/* keep endian setting */
> -	val |= RCR_DM;		/* DMA descriptor mode */
> -	val |= RCR_RS;		/* automatically store rx status */
> -	val |= RCR_DIE;		/* interrupt at end of DMA chain */
> -	val |= RCR_RFI(7);	/* interrupt after 7 frames received */
> -	val |= RCR_BTS(2);	/* 32-byte bus transaction size */
> -	nb8800_writel(priv, NB8800_RXC_CR, val);
> -
> -	/* The rx interrupt can fire before the DMA has completed
> -	 * unless a small delay is added.  50 us is hopefully enough.
> -	 */
> -	priv->rx_itr_irq = clk_get_rate(priv->clk) / 20000;
> -
> -	/* In NAPI poll mode we want to disable interrupts, but the
> -	 * hardware does not permit this.  Delay 10 ms instead.
> -	 */
> -	priv->rx_itr_poll = clk_get_rate(priv->clk) / 100;
> -
> -	nb8800_writel(priv, NB8800_RX_ITR, priv->rx_itr_irq);
> -
> -	priv->rx_dma_config = RX_BUF_SIZE | DESC_BTS(2) | DESC_DS | DESC_EOF;
> -
> -	/* Flow control settings */
> -
> -	/* Pause time of 0.1 ms */
> -	val = 100000 / 512;
> -	nb8800_writeb(priv, NB8800_PQ1, val >> 8);
> -	nb8800_writeb(priv, NB8800_PQ2, val & 0xff);
> -
> -	/* Auto-negotiate by default */
> -	priv->pause_aneg = true;
> -	priv->pause_rx = true;
> -	priv->pause_tx = true;
> -
> -	nb8800_mc_init(dev, 0);
> -
> -	return 0;
> -}
> -
> -static int nb8800_tangox_init(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	u32 pad_mode = PAD_MODE_MII;
> -
> -	switch (priv->phy_mode) {
> -	case PHY_INTERFACE_MODE_MII:
> -	case PHY_INTERFACE_MODE_GMII:
> -		pad_mode = PAD_MODE_MII;
> -		break;
> -
> -	case PHY_INTERFACE_MODE_RGMII:
> -	case PHY_INTERFACE_MODE_RGMII_ID:
> -	case PHY_INTERFACE_MODE_RGMII_RXID:
> -	case PHY_INTERFACE_MODE_RGMII_TXID:
> -		pad_mode = PAD_MODE_RGMII;
> -		break;
> -
> -	default:
> -		dev_err(dev->dev.parent, "unsupported phy mode %s\n",
> -			phy_modes(priv->phy_mode));
> -		return -EINVAL;
> -	}
> -
> -	nb8800_writeb(priv, NB8800_TANGOX_PAD_MODE, pad_mode);
> -
> -	return 0;
> -}
> -
> -static int nb8800_tangox_reset(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	int clk_div;
> -
> -	nb8800_writeb(priv, NB8800_TANGOX_RESET, 0);
> -	usleep_range(1000, 10000);
> -	nb8800_writeb(priv, NB8800_TANGOX_RESET, 1);
> -
> -	wmb();		/* ensure reset is cleared before proceeding */
> -
> -	clk_div = DIV_ROUND_UP(clk_get_rate(priv->clk), 2 * MAX_MDC_CLOCK);
> -	nb8800_writew(priv, NB8800_TANGOX_MDIO_CLKDIV, clk_div);
> -
> -	return 0;
> -}
> -
> -static const struct nb8800_ops nb8800_tangox_ops = {
> -	.init	= nb8800_tangox_init,
> -	.reset	= nb8800_tangox_reset,
> -};
> -
> -static int nb8800_tango4_init(struct net_device *dev)
> -{
> -	struct nb8800_priv *priv = netdev_priv(dev);
> -	int err;
> -
> -	err = nb8800_tangox_init(dev);
> -	if (err)
> -		return err;
> -
> -	/* On tango4 interrupt on DMA completion per frame works and gives
> -	 * better performance despite generating more rx interrupts.
> -	 */
> -
> -	/* Disable unnecessary interrupt on rx completion */
> -	nb8800_clearl(priv, NB8800_RXC_CR, RCR_RFI(7));
> -
> -	/* Request interrupt on descriptor DMA completion */
> -	priv->rx_dma_config |= DESC_ID;
> -
> -	return 0;
> -}
> -
> -static const struct nb8800_ops nb8800_tango4_ops = {
> -	.init	= nb8800_tango4_init,
> -	.reset	= nb8800_tangox_reset,
> -};
> -
> -static const struct of_device_id nb8800_dt_ids[] = {
> -	{
> -		.compatible = "aurora,nb8800",
> -	},
> -	{
> -		.compatible = "sigma,smp8642-ethernet",
> -		.data = &nb8800_tangox_ops,
> -	},
> -	{
> -		.compatible = "sigma,smp8734-ethernet",
> -		.data = &nb8800_tango4_ops,
> -	},
> -	{ }
> -};
> -MODULE_DEVICE_TABLE(of, nb8800_dt_ids);
> -
> -static int nb8800_probe(struct platform_device *pdev)
> -{
> -	const struct of_device_id *match;
> -	const struct nb8800_ops *ops = NULL;
> -	struct nb8800_priv *priv;
> -	struct resource *res;
> -	struct net_device *dev;
> -	struct mii_bus *bus;
> -	const unsigned char *mac;
> -	void __iomem *base;
> -	int irq;
> -	int ret;
> -
> -	match = of_match_device(nb8800_dt_ids, &pdev->dev);
> -	if (match)
> -		ops = match->data;
> -
> -	irq = platform_get_irq(pdev, 0);
> -	if (irq <= 0)
> -		return -EINVAL;
> -
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> -	base = devm_ioremap_resource(&pdev->dev, res);
> -	if (IS_ERR(base))
> -		return PTR_ERR(base);
> -
> -	dev_dbg(&pdev->dev, "AU-NB8800 Ethernet at %pa\n", &res->start);
> -
> -	dev = alloc_etherdev(sizeof(*priv));
> -	if (!dev)
> -		return -ENOMEM;
> -
> -	platform_set_drvdata(pdev, dev);
> -	SET_NETDEV_DEV(dev, &pdev->dev);
> -
> -	priv = netdev_priv(dev);
> -	priv->base = base;
> -
> -	ret = of_get_phy_mode(pdev->dev.of_node, &priv->phy_mode);
> -	if (ret)
> -		priv->phy_mode = PHY_INTERFACE_MODE_RGMII;
> -
> -	priv->clk = devm_clk_get(&pdev->dev, NULL);
> -	if (IS_ERR(priv->clk)) {
> -		dev_err(&pdev->dev, "failed to get clock\n");
> -		ret = PTR_ERR(priv->clk);
> -		goto err_free_dev;
> -	}
> -
> -	ret = clk_prepare_enable(priv->clk);
> -	if (ret)
> -		goto err_free_dev;
> -
> -	spin_lock_init(&priv->tx_lock);
> -
> -	if (ops && ops->reset) {
> -		ret = ops->reset(dev);
> -		if (ret)
> -			goto err_disable_clk;
> -	}
> -
> -	bus = devm_mdiobus_alloc(&pdev->dev);
> -	if (!bus) {
> -		ret = -ENOMEM;
> -		goto err_disable_clk;
> -	}
> -
> -	bus->name = "nb8800-mii";
> -	bus->read = nb8800_mdio_read;
> -	bus->write = nb8800_mdio_write;
> -	bus->parent = &pdev->dev;
> -	snprintf(bus->id, MII_BUS_ID_SIZE, "%lx.nb8800-mii",
> -		 (unsigned long)res->start);
> -	bus->priv = priv;
> -
> -	ret = of_mdiobus_register(bus, pdev->dev.of_node);
> -	if (ret) {
> -		dev_err(&pdev->dev, "failed to register MII bus\n");
> -		goto err_disable_clk;
> -	}
> -
> -	if (of_phy_is_fixed_link(pdev->dev.of_node)) {
> -		ret = of_phy_register_fixed_link(pdev->dev.of_node);
> -		if (ret < 0) {
> -			dev_err(&pdev->dev, "bad fixed-link spec\n");
> -			goto err_free_bus;
> -		}
> -		priv->phy_node = of_node_get(pdev->dev.of_node);
> -	}
> -
> -	if (!priv->phy_node)
> -		priv->phy_node = of_parse_phandle(pdev->dev.of_node,
> -						  "phy-handle", 0);
> -
> -	if (!priv->phy_node) {
> -		dev_err(&pdev->dev, "no PHY specified\n");
> -		ret = -ENODEV;
> -		goto err_free_bus;
> -	}
> -
> -	priv->mii_bus = bus;
> -
> -	ret = nb8800_hw_init(dev);
> -	if (ret)
> -		goto err_deregister_fixed_link;
> -
> -	if (ops && ops->init) {
> -		ret = ops->init(dev);
> -		if (ret)
> -			goto err_deregister_fixed_link;
> -	}
> -
> -	dev->netdev_ops = &nb8800_netdev_ops;
> -	dev->ethtool_ops = &nb8800_ethtool_ops;
> -	dev->flags |= IFF_MULTICAST;
> -	dev->irq = irq;
> -
> -	mac = of_get_mac_address(pdev->dev.of_node);
> -	if (!IS_ERR(mac))
> -		ether_addr_copy(dev->dev_addr, mac);
> -
> -	if (!is_valid_ether_addr(dev->dev_addr))
> -		eth_hw_addr_random(dev);
> -
> -	nb8800_update_mac_addr(dev);
> -
> -	netif_carrier_off(dev);
> -
> -	ret = register_netdev(dev);
> -	if (ret) {
> -		netdev_err(dev, "failed to register netdev\n");
> -		goto err_free_dma;
> -	}
> -
> -	netif_napi_add(dev, &priv->napi, nb8800_poll, NAPI_POLL_WEIGHT);
> -
> -	netdev_info(dev, "MAC address %pM\n", dev->dev_addr);
> -
> -	return 0;
> -
> -err_free_dma:
> -	nb8800_dma_free(dev);
> -err_deregister_fixed_link:
> -	if (of_phy_is_fixed_link(pdev->dev.of_node))
> -		of_phy_deregister_fixed_link(pdev->dev.of_node);
> -err_free_bus:
> -	of_node_put(priv->phy_node);
> -	mdiobus_unregister(bus);
> -err_disable_clk:
> -	clk_disable_unprepare(priv->clk);
> -err_free_dev:
> -	free_netdev(dev);
> -
> -	return ret;
> -}
> -
> -static int nb8800_remove(struct platform_device *pdev)
> -{
> -	struct net_device *ndev = platform_get_drvdata(pdev);
> -	struct nb8800_priv *priv = netdev_priv(ndev);
> -
> -	unregister_netdev(ndev);
> -	if (of_phy_is_fixed_link(pdev->dev.of_node))
> -		of_phy_deregister_fixed_link(pdev->dev.of_node);
> -	of_node_put(priv->phy_node);
> -
> -	mdiobus_unregister(priv->mii_bus);
> -
> -	clk_disable_unprepare(priv->clk);
> -
> -	nb8800_dma_free(ndev);
> -	free_netdev(ndev);
> -
> -	return 0;
> -}
> -
> -static struct platform_driver nb8800_driver = {
> -	.driver = {
> -		.name		= "nb8800",
> -		.of_match_table	= nb8800_dt_ids,
> -	},
> -	.probe	= nb8800_probe,
> -	.remove	= nb8800_remove,
> -};
> -
> -module_platform_driver(nb8800_driver);
> -
> -MODULE_DESCRIPTION("Aurora AU-NB8800 Ethernet driver");
> -MODULE_AUTHOR("Mans Rullgard <mans@mansr.com>");
> -MODULE_LICENSE("GPL");
> diff --git a/drivers/net/ethernet/aurora/nb8800.h b/drivers/net/ethernet/aurora/nb8800.h
> deleted file mode 100644
> index 40941fb6065b..000000000000
> --- a/drivers/net/ethernet/aurora/nb8800.h
> +++ /dev/null
> @@ -1,316 +0,0 @@
> -/* SPDX-License-Identifier: GPL-2.0 */
> -#ifndef _NB8800_H_
> -#define _NB8800_H_
> -
> -#include <linux/types.h>
> -#include <linux/skbuff.h>
> -#include <linux/phy.h>
> -#include <linux/clk.h>
> -#include <linux/bitops.h>
> -
> -#define RX_DESC_COUNT			256
> -#define TX_DESC_COUNT			256
> -
> -#define NB8800_DESC_LOW			4
> -
> -#define RX_BUF_SIZE			1552
> -
> -#define RX_COPYBREAK			256
> -#define RX_COPYHDR			128
> -
> -#define MAX_MDC_CLOCK			2500000
> -
> -/* Stargate Solutions SSN8800 core registers */
> -#define NB8800_TX_CTL1			0x000
> -#define TX_TPD				BIT(5)
> -#define TX_APPEND_FCS			BIT(4)
> -#define TX_PAD_EN			BIT(3)
> -#define TX_RETRY_EN			BIT(2)
> -#define TX_EN				BIT(0)
> -
> -#define NB8800_TX_CTL2			0x001
> -
> -#define NB8800_RX_CTL			0x004
> -#define RX_BC_DISABLE			BIT(7)
> -#define RX_RUNT				BIT(6)
> -#define RX_AF_EN			BIT(5)
> -#define RX_PAUSE_EN			BIT(3)
> -#define RX_SEND_CRC			BIT(2)
> -#define RX_PAD_STRIP			BIT(1)
> -#define RX_EN				BIT(0)
> -
> -#define NB8800_RANDOM_SEED		0x008
> -#define NB8800_TX_SDP			0x14
> -#define NB8800_TX_TPDP1			0x18
> -#define NB8800_TX_TPDP2			0x19
> -#define NB8800_SLOT_TIME		0x1c
> -
> -#define NB8800_MDIO_CMD			0x020
> -#define MDIO_CMD_GO			BIT(31)
> -#define MDIO_CMD_WR			BIT(26)
> -#define MDIO_CMD_ADDR(x)		((x) << 21)
> -#define MDIO_CMD_REG(x)			((x) << 16)
> -#define MDIO_CMD_DATA(x)		((x) <<	 0)
> -
> -#define NB8800_MDIO_STS			0x024
> -#define MDIO_STS_ERR			BIT(31)
> -
> -#define NB8800_MC_ADDR(i)		(0x028 + (i))
> -#define NB8800_MC_INIT			0x02e
> -#define NB8800_UC_ADDR(i)		(0x03c + (i))
> -
> -#define NB8800_MAC_MODE			0x044
> -#define RGMII_MODE			BIT(7)
> -#define HALF_DUPLEX			BIT(4)
> -#define BURST_EN			BIT(3)
> -#define LOOPBACK_EN			BIT(2)
> -#define GMAC_MODE			BIT(0)
> -
> -#define NB8800_IC_THRESHOLD		0x050
> -#define NB8800_PE_THRESHOLD		0x051
> -#define NB8800_PF_THRESHOLD		0x052
> -#define NB8800_TX_BUFSIZE		0x054
> -#define NB8800_FIFO_CTL			0x056
> -#define NB8800_PQ1			0x060
> -#define NB8800_PQ2			0x061
> -#define NB8800_SRC_ADDR(i)		(0x06a + (i))
> -#define NB8800_STAT_DATA		0x078
> -#define NB8800_STAT_INDEX		0x07c
> -#define NB8800_STAT_CLEAR		0x07d
> -
> -#define NB8800_SLEEP_MODE		0x07e
> -#define SLEEP_MODE			BIT(0)
> -
> -#define NB8800_WAKEUP			0x07f
> -#define WAKEUP				BIT(0)
> -
> -/* Aurora NB8800 host interface registers */
> -#define NB8800_TXC_CR			0x100
> -#define TCR_LK				BIT(12)
> -#define TCR_DS				BIT(11)
> -#define TCR_BTS(x)			(((x) & 0x7) << 8)
> -#define TCR_DIE				BIT(7)
> -#define TCR_TFI(x)			(((x) & 0x7) << 4)
> -#define TCR_LE				BIT(3)
> -#define TCR_RS				BIT(2)
> -#define TCR_DM				BIT(1)
> -#define TCR_EN				BIT(0)
> -
> -#define NB8800_TXC_SR			0x104
> -#define TSR_DE				BIT(3)
> -#define TSR_DI				BIT(2)
> -#define TSR_TO				BIT(1)
> -#define TSR_TI				BIT(0)
> -
> -#define NB8800_TX_SAR			0x108
> -#define NB8800_TX_DESC_ADDR		0x10c
> -
> -#define NB8800_TX_REPORT_ADDR		0x110
> -#define TX_BYTES_TRANSFERRED(x)		(((x) >> 16) & 0xffff)
> -#define TX_FIRST_DEFERRAL		BIT(7)
> -#define TX_EARLY_COLLISIONS(x)		(((x) >> 3) & 0xf)
> -#define TX_LATE_COLLISION		BIT(2)
> -#define TX_PACKET_DROPPED		BIT(1)
> -#define TX_FIFO_UNDERRUN		BIT(0)
> -#define IS_TX_ERROR(r)			((r) & 0x07)
> -
> -#define NB8800_TX_FIFO_SR		0x114
> -#define NB8800_TX_ITR			0x118
> -
> -#define NB8800_RXC_CR			0x200
> -#define RCR_FL				BIT(13)
> -#define RCR_LK				BIT(12)
> -#define RCR_DS				BIT(11)
> -#define RCR_BTS(x)			(((x) & 7) << 8)
> -#define RCR_DIE				BIT(7)
> -#define RCR_RFI(x)			(((x) & 7) << 4)
> -#define RCR_LE				BIT(3)
> -#define RCR_RS				BIT(2)
> -#define RCR_DM				BIT(1)
> -#define RCR_EN				BIT(0)
> -
> -#define NB8800_RXC_SR			0x204
> -#define RSR_DE				BIT(3)
> -#define RSR_DI				BIT(2)
> -#define RSR_RO				BIT(1)
> -#define RSR_RI				BIT(0)
> -
> -#define NB8800_RX_SAR			0x208
> -#define NB8800_RX_DESC_ADDR		0x20c
> -
> -#define NB8800_RX_REPORT_ADDR		0x210
> -#define RX_BYTES_TRANSFERRED(x)		(((x) >> 16) & 0xFFFF)
> -#define RX_MULTICAST_PKT		BIT(9)
> -#define RX_BROADCAST_PKT		BIT(8)
> -#define RX_LENGTH_ERR			BIT(7)
> -#define RX_FCS_ERR			BIT(6)
> -#define RX_RUNT_PKT			BIT(5)
> -#define RX_FIFO_OVERRUN			BIT(4)
> -#define RX_LATE_COLLISION		BIT(3)
> -#define RX_ALIGNMENT_ERROR		BIT(2)
> -#define RX_ERROR_MASK			0xfc
> -#define IS_RX_ERROR(r)			((r) & RX_ERROR_MASK)
> -
> -#define NB8800_RX_FIFO_SR		0x214
> -#define NB8800_RX_ITR			0x218
> -
> -/* Sigma Designs SMP86xx additional registers */
> -#define NB8800_TANGOX_PAD_MODE		0x400
> -#define PAD_MODE_MASK			0x7
> -#define PAD_MODE_MII			0x0
> -#define PAD_MODE_RGMII			0x1
> -#define PAD_MODE_GTX_CLK_INV		BIT(3)
> -#define PAD_MODE_GTX_CLK_DELAY		BIT(4)
> -
> -#define NB8800_TANGOX_MDIO_CLKDIV	0x420
> -#define NB8800_TANGOX_RESET		0x424
> -
> -/* Hardware DMA descriptor */
> -struct nb8800_dma_desc {
> -	u32				s_addr;	/* start address */
> -	u32				n_addr;	/* next descriptor address */
> -	u32				r_addr;	/* report address */
> -	u32				config;
> -} __aligned(8);
> -
> -#define DESC_ID				BIT(23)
> -#define DESC_EOC			BIT(22)
> -#define DESC_EOF			BIT(21)
> -#define DESC_LK				BIT(20)
> -#define DESC_DS				BIT(19)
> -#define DESC_BTS(x)			(((x) & 0x7) << 16)
> -
> -/* DMA descriptor and associated data for rx.
> - * Allocated from coherent memory.
> - */
> -struct nb8800_rx_desc {
> -	/* DMA descriptor */
> -	struct nb8800_dma_desc		desc;
> -
> -	/* Status report filled in by hardware */
> -	u32				report;
> -};
> -
> -/* Address of buffer on rx ring */
> -struct nb8800_rx_buf {
> -	struct page			*page;
> -	unsigned long			offset;
> -};
> -
> -/* DMA descriptors and associated data for tx.
> - * Allocated from coherent memory.
> - */
> -struct nb8800_tx_desc {
> -	/* DMA descriptor.  The second descriptor is used if packet
> -	 * data is unaligned.
> -	 */
> -	struct nb8800_dma_desc		desc[2];
> -
> -	/* Status report filled in by hardware */
> -	u32				report;
> -
> -	/* Bounce buffer for initial unaligned part of packet */
> -	u8				buf[8] __aligned(8);
> -};
> -
> -/* Packet in tx queue */
> -struct nb8800_tx_buf {
> -	/* Currently queued skb */
> -	struct sk_buff			*skb;
> -
> -	/* DMA address of the first descriptor */
> -	dma_addr_t			dma_desc;
> -
> -	/* DMA address of packet data */
> -	dma_addr_t			dma_addr;
> -
> -	/* Length of DMA mapping, less than skb->len if alignment
> -	 * buffer is used.
> -	 */
> -	unsigned int			dma_len;
> -
> -	/* Number of packets in chain starting here */
> -	unsigned int			chain_len;
> -
> -	/* Packet chain ready to be submitted to hardware */
> -	bool				ready;
> -};
> -
> -struct nb8800_priv {
> -	struct napi_struct		napi;
> -
> -	void __iomem			*base;
> -
> -	/* RX DMA descriptors */
> -	struct nb8800_rx_desc		*rx_descs;
> -
> -	/* RX buffers referenced by DMA descriptors */
> -	struct nb8800_rx_buf		*rx_bufs;
> -
> -	/* Current end of chain */
> -	u32				rx_eoc;
> -
> -	/* Value for rx interrupt time register in NAPI interrupt mode */
> -	u32				rx_itr_irq;
> -
> -	/* Value for rx interrupt time register in NAPI poll mode */
> -	u32				rx_itr_poll;
> -
> -	/* Value for config field of rx DMA descriptors */
> -	u32				rx_dma_config;
> -
> -	/* TX DMA descriptors */
> -	struct nb8800_tx_desc		*tx_descs;
> -
> -	/* TX packet queue */
> -	struct nb8800_tx_buf		*tx_bufs;
> -
> -	/* Number of free tx queue entries */
> -	atomic_t			tx_free;
> -
> -	/* First free tx queue entry */
> -	u32				tx_next;
> -
> -	/* Next buffer to transmit */
> -	u32				tx_queue;
> -
> -	/* Start of current packet chain */
> -	struct nb8800_tx_buf		*tx_chain;
> -
> -	/* Next buffer to reclaim */
> -	u32				tx_done;
> -
> -	/* Lock for DMA activation */
> -	spinlock_t			tx_lock;
> -
> -	struct mii_bus			*mii_bus;
> -	struct device_node		*phy_node;
> -
> -	/* PHY connection type from DT */
> -	phy_interface_t			phy_mode;
> -
> -	/* Current link status */
> -	int				speed;
> -	int				duplex;
> -	int				link;
> -
> -	/* Pause settings */
> -	bool				pause_aneg;
> -	bool				pause_rx;
> -	bool				pause_tx;
> -
> -	/* DMA base address of rx descriptors, see rx_descs above */
> -	dma_addr_t			rx_desc_dma;
> -
> -	/* DMA base address of tx descriptors, see tx_descs above */
> -	dma_addr_t			tx_desc_dma;
> -
> -	struct clk			*clk;
> -};
> -
> -struct nb8800_ops {
> -	int				(*init)(struct net_device *dev);
> -	int				(*reset)(struct net_device *dev);
> -};
> -
> -#endif /* _NB8800_H_ */
> -- 
>
> 2.29.2
>

-- 
Måns Rullgård

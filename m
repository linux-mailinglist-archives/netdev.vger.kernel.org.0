Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F15BA878D
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730483AbfIDN70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 09:59:26 -0400
Received: from ispman.iskranet.ru ([62.213.33.10]:39227 "EHLO
        ispman.iskranet.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729798AbfIDN7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 09:59:24 -0400
Received: by ispman.iskranet.ru (Postfix, from userid 8)
        id 21057821815; Wed,  4 Sep 2019 20:53:18 +0700 (KRAT)
X-Spam-Checker-Version: SpamAssassin 3.3.2 (2011-06-06) on ispman.iskranet.ru
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,SHORTCIRCUIT
        shortcircuit=ham autolearn=disabled version=3.3.2
Received: from KB016249.iskra.kb (unknown [62.213.40.60])
        (Authenticated sender: asolokha@kb.kras.ru)
        by ispman.iskranet.ru (Postfix) with ESMTPA id 8E381821815;
        Wed,  4 Sep 2019 20:53:18 +0700 (KRAT)
From:   Arseny Solokha <asolokha@kb.kras.ru>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, Arseny Solokha <asolokha@kb.kras.ru>
Subject: [PATCH 1/4] gianfar: remove forward declarations
Date:   Wed,  4 Sep 2019 20:52:19 +0700
Message-Id: <20190904135223.31754-2-asolokha@kb.kras.ru>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904135223.31754-1-asolokha@kb.kras.ru>
References: <CA+h21hruqt6nGG5ksDSwrGH_w5GtGF4fjAMCWJne7QJrjusERQ@mail.gmail.com>
 <20190904135223.31754-1-asolokha@kb.kras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove forward declarations of various static functions located in two
driver implementation files and rearrange the corresponding definitions
accordingly.

This patch only introduces mechanical changes, namely it removes forward
declarations and moves function definitions around; it does not change any
functionality.

Signed-off-by: Arseny Solokha <asolokha@kb.kras.ru>
---
 drivers/net/ethernet/freescale/gianfar.c      | 2849 ++++++++---------
 drivers/net/ethernet/freescale/gianfar.h      |    7 -
 .../net/ethernet/freescale/gianfar_ethtool.c  |   13 -
 3 files changed, 1404 insertions(+), 1465 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index 412c0340fed9..fc31ba1a8bb8 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -105,43 +105,6 @@
 
 const char gfar_driver_version[] = "2.0";
 
-static int gfar_enet_open(struct net_device *dev);
-static netdev_tx_t gfar_start_xmit(struct sk_buff *skb, struct net_device *dev);
-static void gfar_reset_task(struct work_struct *work);
-static void gfar_timeout(struct net_device *dev);
-static int gfar_close(struct net_device *dev);
-static void gfar_alloc_rx_buffs(struct gfar_priv_rx_q *rx_queue,
-				int alloc_cnt);
-static int gfar_set_mac_address(struct net_device *dev);
-static int gfar_change_mtu(struct net_device *dev, int new_mtu);
-static irqreturn_t gfar_error(int irq, void *dev_id);
-static irqreturn_t gfar_transmit(int irq, void *dev_id);
-static irqreturn_t gfar_interrupt(int irq, void *dev_id);
-static void adjust_link(struct net_device *dev);
-static noinline void gfar_update_link_state(struct gfar_private *priv);
-static int init_phy(struct net_device *dev);
-static int gfar_probe(struct platform_device *ofdev);
-static int gfar_remove(struct platform_device *ofdev);
-static void free_skb_resources(struct gfar_private *priv);
-static void gfar_set_multi(struct net_device *dev);
-static void gfar_set_hash_for_addr(struct net_device *dev, u8 *addr);
-static void gfar_configure_serdes(struct net_device *dev);
-static int gfar_poll_rx(struct napi_struct *napi, int budget);
-static int gfar_poll_tx(struct napi_struct *napi, int budget);
-static int gfar_poll_rx_sq(struct napi_struct *napi, int budget);
-static int gfar_poll_tx_sq(struct napi_struct *napi, int budget);
-#ifdef CONFIG_NET_POLL_CONTROLLER
-static void gfar_netpoll(struct net_device *dev);
-#endif
-int gfar_clean_rx_ring(struct gfar_priv_rx_q *rx_queue, int rx_work_limit);
-static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue);
-static void gfar_process_frame(struct net_device *ndev, struct sk_buff *skb);
-static void gfar_halt_nodisable(struct gfar_private *priv);
-static void gfar_clear_exact_match(struct net_device *dev);
-static void gfar_set_mac_for_addr(struct net_device *dev, int num,
-				  const u8 *addr);
-static int gfar_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
-
 MODULE_AUTHOR("Freescale Semiconductor, Inc");
 MODULE_DESCRIPTION("Gianfar Ethernet Driver");
 MODULE_LICENSE("GPL");
@@ -162,138 +125,6 @@ static void gfar_init_rxbdp(struct gfar_priv_rx_q *rx_queue, struct rxbd8 *bdp,
 	bdp->lstatus = cpu_to_be32(lstatus);
 }
 
-static void gfar_init_bds(struct net_device *ndev)
-{
-	struct gfar_private *priv = netdev_priv(ndev);
-	struct gfar __iomem *regs = priv->gfargrp[0].regs;
-	struct gfar_priv_tx_q *tx_queue = NULL;
-	struct gfar_priv_rx_q *rx_queue = NULL;
-	struct txbd8 *txbdp;
-	u32 __iomem *rfbptr;
-	int i, j;
-
-	for (i = 0; i < priv->num_tx_queues; i++) {
-		tx_queue = priv->tx_queue[i];
-		/* Initialize some variables in our dev structure */
-		tx_queue->num_txbdfree = tx_queue->tx_ring_size;
-		tx_queue->dirty_tx = tx_queue->tx_bd_base;
-		tx_queue->cur_tx = tx_queue->tx_bd_base;
-		tx_queue->skb_curtx = 0;
-		tx_queue->skb_dirtytx = 0;
-
-		/* Initialize Transmit Descriptor Ring */
-		txbdp = tx_queue->tx_bd_base;
-		for (j = 0; j < tx_queue->tx_ring_size; j++) {
-			txbdp->lstatus = 0;
-			txbdp->bufPtr = 0;
-			txbdp++;
-		}
-
-		/* Set the last descriptor in the ring to indicate wrap */
-		txbdp--;
-		txbdp->status = cpu_to_be16(be16_to_cpu(txbdp->status) |
-					    TXBD_WRAP);
-	}
-
-	rfbptr = &regs->rfbptr0;
-	for (i = 0; i < priv->num_rx_queues; i++) {
-		rx_queue = priv->rx_queue[i];
-
-		rx_queue->next_to_clean = 0;
-		rx_queue->next_to_use = 0;
-		rx_queue->next_to_alloc = 0;
-
-		/* make sure next_to_clean != next_to_use after this
-		 * by leaving at least 1 unused descriptor
-		 */
-		gfar_alloc_rx_buffs(rx_queue, gfar_rxbd_unused(rx_queue));
-
-		rx_queue->rfbptr = rfbptr;
-		rfbptr += 2;
-	}
-}
-
-static int gfar_alloc_skb_resources(struct net_device *ndev)
-{
-	void *vaddr;
-	dma_addr_t addr;
-	int i, j;
-	struct gfar_private *priv = netdev_priv(ndev);
-	struct device *dev = priv->dev;
-	struct gfar_priv_tx_q *tx_queue = NULL;
-	struct gfar_priv_rx_q *rx_queue = NULL;
-
-	priv->total_tx_ring_size = 0;
-	for (i = 0; i < priv->num_tx_queues; i++)
-		priv->total_tx_ring_size += priv->tx_queue[i]->tx_ring_size;
-
-	priv->total_rx_ring_size = 0;
-	for (i = 0; i < priv->num_rx_queues; i++)
-		priv->total_rx_ring_size += priv->rx_queue[i]->rx_ring_size;
-
-	/* Allocate memory for the buffer descriptors */
-	vaddr = dma_alloc_coherent(dev,
-				   (priv->total_tx_ring_size *
-				    sizeof(struct txbd8)) +
-				   (priv->total_rx_ring_size *
-				    sizeof(struct rxbd8)),
-				   &addr, GFP_KERNEL);
-	if (!vaddr)
-		return -ENOMEM;
-
-	for (i = 0; i < priv->num_tx_queues; i++) {
-		tx_queue = priv->tx_queue[i];
-		tx_queue->tx_bd_base = vaddr;
-		tx_queue->tx_bd_dma_base = addr;
-		tx_queue->dev = ndev;
-		/* enet DMA only understands physical addresses */
-		addr  += sizeof(struct txbd8) * tx_queue->tx_ring_size;
-		vaddr += sizeof(struct txbd8) * tx_queue->tx_ring_size;
-	}
-
-	/* Start the rx descriptor ring where the tx ring leaves off */
-	for (i = 0; i < priv->num_rx_queues; i++) {
-		rx_queue = priv->rx_queue[i];
-		rx_queue->rx_bd_base = vaddr;
-		rx_queue->rx_bd_dma_base = addr;
-		rx_queue->ndev = ndev;
-		rx_queue->dev = dev;
-		addr  += sizeof(struct rxbd8) * rx_queue->rx_ring_size;
-		vaddr += sizeof(struct rxbd8) * rx_queue->rx_ring_size;
-	}
-
-	/* Setup the skbuff rings */
-	for (i = 0; i < priv->num_tx_queues; i++) {
-		tx_queue = priv->tx_queue[i];
-		tx_queue->tx_skbuff =
-			kmalloc_array(tx_queue->tx_ring_size,
-				      sizeof(*tx_queue->tx_skbuff),
-				      GFP_KERNEL);
-		if (!tx_queue->tx_skbuff)
-			goto cleanup;
-
-		for (j = 0; j < tx_queue->tx_ring_size; j++)
-			tx_queue->tx_skbuff[j] = NULL;
-	}
-
-	for (i = 0; i < priv->num_rx_queues; i++) {
-		rx_queue = priv->rx_queue[i];
-		rx_queue->rx_buff = kcalloc(rx_queue->rx_ring_size,
-					    sizeof(*rx_queue->rx_buff),
-					    GFP_KERNEL);
-		if (!rx_queue->rx_buff)
-			goto cleanup;
-	}
-
-	gfar_init_bds(ndev);
-
-	return 0;
-
-cleanup:
-	free_skb_resources(priv);
-	return -ENOMEM;
-}
-
 static void gfar_init_tx_rx_base(struct gfar_private *priv)
 {
 	struct gfar __iomem *regs = priv->gfargrp[0].regs;
@@ -477,6 +308,62 @@ static struct net_device_stats *gfar_get_stats(struct net_device *dev)
 	return &dev->stats;
 }
 
+/* Set the appropriate hash bit for the given addr */
+/* The algorithm works like so:
+ * 1) Take the Destination Address (ie the multicast address), and
+ * do a CRC on it (little endian), and reverse the bits of the
+ * result.
+ * 2) Use the 8 most significant bits as a hash into a 256-entry
+ * table.  The table is controlled through 8 32-bit registers:
+ * gaddr0-7.  gaddr0's MSB is entry 0, and gaddr7's LSB is
+ * gaddr7.  This means that the 3 most significant bits in the
+ * hash index which gaddr register to use, and the 5 other bits
+ * indicate which bit (assuming an IBM numbering scheme, which
+ * for PowerPC (tm) is usually the case) in the register holds
+ * the entry.
+ */
+static void gfar_set_hash_for_addr(struct net_device *dev, u8 *addr)
+{
+	u32 tempval;
+	struct gfar_private *priv = netdev_priv(dev);
+	u32 result = ether_crc(ETH_ALEN, addr);
+	int width = priv->hash_width;
+	u8 whichbit = (result >> (32 - width)) & 0x1f;
+	u8 whichreg = result >> (32 - width + 5);
+	u32 value = (1 << (31-whichbit));
+
+	tempval = gfar_read(priv->hash_regs[whichreg]);
+	tempval |= value;
+	gfar_write(priv->hash_regs[whichreg], tempval);
+}
+
+/* There are multiple MAC Address register pairs on some controllers
+ * This function sets the numth pair to a given address
+ */
+static void gfar_set_mac_for_addr(struct net_device *dev, int num,
+				  const u8 *addr)
+{
+	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar __iomem *regs = priv->gfargrp[0].regs;
+	u32 tempval;
+	u32 __iomem *macptr = &regs->macstnaddr1;
+
+	macptr += num*2;
+
+	/* For a station address of 0x12345678ABCD in transmission
+	 * order (BE), MACnADDR1 is set to 0xCDAB7856 and
+	 * MACnADDR2 is set to 0x34120000.
+	 */
+	tempval = (addr[5] << 24) | (addr[4] << 16) |
+		  (addr[3] << 8)  |  addr[2];
+
+	gfar_write(macptr, tempval);
+
+	tempval = (addr[1] << 24) | (addr[0] << 16);
+
+	gfar_write(macptr+1, tempval);
+}
+
 static int gfar_set_mac_addr(struct net_device *dev, void *p)
 {
 	eth_mac_addr(dev, p);
@@ -486,24 +373,6 @@ static int gfar_set_mac_addr(struct net_device *dev, void *p)
 	return 0;
 }
 
-static const struct net_device_ops gfar_netdev_ops = {
-	.ndo_open = gfar_enet_open,
-	.ndo_start_xmit = gfar_start_xmit,
-	.ndo_stop = gfar_close,
-	.ndo_change_mtu = gfar_change_mtu,
-	.ndo_set_features = gfar_set_features,
-	.ndo_set_rx_mode = gfar_set_multi,
-	.ndo_tx_timeout = gfar_timeout,
-	.ndo_do_ioctl = gfar_ioctl,
-	.ndo_get_stats = gfar_get_stats,
-	.ndo_change_carrier = fixed_phy_change_carrier,
-	.ndo_set_mac_address = gfar_set_mac_addr,
-	.ndo_validate_addr = eth_validate_addr,
-#ifdef CONFIG_NET_POLL_CONTROLLER
-	.ndo_poll_controller = gfar_netpoll,
-#endif
-};
-
 static void gfar_ints_disable(struct gfar_private *priv)
 {
 	int i;
@@ -723,6 +592,50 @@ static int gfar_of_group_count(struct device_node *np)
 	return num;
 }
 
+/* Reads the controller's registers to determine what interface
+ * connects it to the PHY.
+ */
+static phy_interface_t gfar_get_interface(struct net_device *dev)
+{
+	struct gfar_private *priv = netdev_priv(dev);
+	struct gfar __iomem *regs = priv->gfargrp[0].regs;
+	u32 ecntrl;
+
+	ecntrl = gfar_read(&regs->ecntrl);
+
+	if (ecntrl & ECNTRL_SGMII_MODE)
+		return PHY_INTERFACE_MODE_SGMII;
+
+	if (ecntrl & ECNTRL_TBI_MODE) {
+		if (ecntrl & ECNTRL_REDUCED_MODE)
+			return PHY_INTERFACE_MODE_RTBI;
+		else
+			return PHY_INTERFACE_MODE_TBI;
+	}
+
+	if (ecntrl & ECNTRL_REDUCED_MODE) {
+		if (ecntrl & ECNTRL_REDUCED_MII_MODE) {
+			return PHY_INTERFACE_MODE_RMII;
+		}
+		else {
+			phy_interface_t interface = priv->interface;
+
+			/* This isn't autodetected right now, so it must
+			 * be set by the device tree or platform code.
+			 */
+			if (interface == PHY_INTERFACE_MODE_RGMII_ID)
+				return PHY_INTERFACE_MODE_RGMII_ID;
+
+			return PHY_INTERFACE_MODE_RGMII;
+		}
+	}
+
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_GIGABIT)
+		return PHY_INTERFACE_MODE_GMII;
+
+	return PHY_INTERFACE_MODE_MII;
+}
+
 static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 {
 	const char *model;
@@ -931,85 +844,6 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	return err;
 }
 
-static int gfar_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
-{
-	struct hwtstamp_config config;
-	struct gfar_private *priv = netdev_priv(netdev);
-
-	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
-		return -EFAULT;
-
-	/* reserved for future extensions */
-	if (config.flags)
-		return -EINVAL;
-
-	switch (config.tx_type) {
-	case HWTSTAMP_TX_OFF:
-		priv->hwts_tx_en = 0;
-		break;
-	case HWTSTAMP_TX_ON:
-		if (!(priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER))
-			return -ERANGE;
-		priv->hwts_tx_en = 1;
-		break;
-	default:
-		return -ERANGE;
-	}
-
-	switch (config.rx_filter) {
-	case HWTSTAMP_FILTER_NONE:
-		if (priv->hwts_rx_en) {
-			priv->hwts_rx_en = 0;
-			reset_gfar(netdev);
-		}
-		break;
-	default:
-		if (!(priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER))
-			return -ERANGE;
-		if (!priv->hwts_rx_en) {
-			priv->hwts_rx_en = 1;
-			reset_gfar(netdev);
-		}
-		config.rx_filter = HWTSTAMP_FILTER_ALL;
-		break;
-	}
-
-	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
-		-EFAULT : 0;
-}
-
-static int gfar_hwtstamp_get(struct net_device *netdev, struct ifreq *ifr)
-{
-	struct hwtstamp_config config;
-	struct gfar_private *priv = netdev_priv(netdev);
-
-	config.flags = 0;
-	config.tx_type = priv->hwts_tx_en ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
-	config.rx_filter = (priv->hwts_rx_en ?
-			    HWTSTAMP_FILTER_ALL : HWTSTAMP_FILTER_NONE);
-
-	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
-		-EFAULT : 0;
-}
-
-static int gfar_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct phy_device *phydev = dev->phydev;
-
-	if (!netif_running(dev))
-		return -EINVAL;
-
-	if (cmd == SIOCSHWTSTAMP)
-		return gfar_hwtstamp_set(dev, rq);
-	if (cmd == SIOCGHWTSTAMP)
-		return gfar_hwtstamp_get(dev, rq);
-
-	if (!phydev)
-		return -ENODEV;
-
-	return phy_mii_ioctl(phydev, rq, cmd);
-}
-
 static u32 cluster_entry_per_class(struct gfar_private *priv, u32 rqfar,
 				   u32 class)
 {
@@ -1133,135 +967,6 @@ static void gfar_detect_errata(struct gfar_private *priv)
 			 priv->errata);
 }
 
-void gfar_mac_reset(struct gfar_private *priv)
-{
-	struct gfar __iomem *regs = priv->gfargrp[0].regs;
-	u32 tempval;
-
-	/* Reset MAC layer */
-	gfar_write(&regs->maccfg1, MACCFG1_SOFT_RESET);
-
-	/* We need to delay at least 3 TX clocks */
-	udelay(3);
-
-	/* the soft reset bit is not self-resetting, so we need to
-	 * clear it before resuming normal operation
-	 */
-	gfar_write(&regs->maccfg1, 0);
-
-	udelay(3);
-
-	gfar_rx_offload_en(priv);
-
-	/* Initialize the max receive frame/buffer lengths */
-	gfar_write(&regs->maxfrm, GFAR_JUMBO_FRAME_SIZE);
-	gfar_write(&regs->mrblr, GFAR_RXB_SIZE);
-
-	/* Initialize the Minimum Frame Length Register */
-	gfar_write(&regs->minflr, MINFLR_INIT_SETTINGS);
-
-	/* Initialize MACCFG2. */
-	tempval = MACCFG2_INIT_SETTINGS;
-
-	/* eTSEC74 erratum: Rx frames of length MAXFRM or MAXFRM-1
-	 * are marked as truncated.  Avoid this by MACCFG2[Huge Frame]=1,
-	 * and by checking RxBD[LG] and discarding larger than MAXFRM.
-	 */
-	if (gfar_has_errata(priv, GFAR_ERRATA_74))
-		tempval |= MACCFG2_HUGEFRAME | MACCFG2_LENGTHCHECK;
-
-	gfar_write(&regs->maccfg2, tempval);
-
-	/* Clear mac addr hash registers */
-	gfar_write(&regs->igaddr0, 0);
-	gfar_write(&regs->igaddr1, 0);
-	gfar_write(&regs->igaddr2, 0);
-	gfar_write(&regs->igaddr3, 0);
-	gfar_write(&regs->igaddr4, 0);
-	gfar_write(&regs->igaddr5, 0);
-	gfar_write(&regs->igaddr6, 0);
-	gfar_write(&regs->igaddr7, 0);
-
-	gfar_write(&regs->gaddr0, 0);
-	gfar_write(&regs->gaddr1, 0);
-	gfar_write(&regs->gaddr2, 0);
-	gfar_write(&regs->gaddr3, 0);
-	gfar_write(&regs->gaddr4, 0);
-	gfar_write(&regs->gaddr5, 0);
-	gfar_write(&regs->gaddr6, 0);
-	gfar_write(&regs->gaddr7, 0);
-
-	if (priv->extended_hash)
-		gfar_clear_exact_match(priv->ndev);
-
-	gfar_mac_rx_config(priv);
-
-	gfar_mac_tx_config(priv);
-
-	gfar_set_mac_address(priv->ndev);
-
-	gfar_set_multi(priv->ndev);
-
-	/* clear ievent and imask before configuring coalescing */
-	gfar_ints_disable(priv);
-
-	/* Configure the coalescing support */
-	gfar_configure_coalescing_all(priv);
-}
-
-static void gfar_hw_init(struct gfar_private *priv)
-{
-	struct gfar __iomem *regs = priv->gfargrp[0].regs;
-	u32 attrs;
-
-	/* Stop the DMA engine now, in case it was running before
-	 * (The firmware could have used it, and left it running).
-	 */
-	gfar_halt(priv);
-
-	gfar_mac_reset(priv);
-
-	/* Zero out the rmon mib registers if it has them */
-	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_RMON) {
-		memset_io(&(regs->rmon), 0, sizeof(struct rmon_mib));
-
-		/* Mask off the CAM interrupts */
-		gfar_write(&regs->rmon.cam1, 0xffffffff);
-		gfar_write(&regs->rmon.cam2, 0xffffffff);
-	}
-
-	/* Initialize ECNTRL */
-	gfar_write(&regs->ecntrl, ECNTRL_INIT_SETTINGS);
-
-	/* Set the extraction length and index */
-	attrs = ATTRELI_EL(priv->rx_stash_size) |
-		ATTRELI_EI(priv->rx_stash_index);
-
-	gfar_write(&regs->attreli, attrs);
-
-	/* Start with defaults, and add stashing
-	 * depending on driver parameters
-	 */
-	attrs = ATTR_INIT_SETTINGS;
-
-	if (priv->bd_stash_en)
-		attrs |= ATTR_BDSTASH;
-
-	if (priv->rx_stash_size != 0)
-		attrs |= ATTR_BUFSTASH;
-
-	gfar_write(&regs->attr, attrs);
-
-	/* FIFO configs */
-	gfar_write(&regs->fifo_tx_thr, DEFAULT_FIFO_TX_THR);
-	gfar_write(&regs->fifo_tx_starve, DEFAULT_FIFO_TX_STARVE);
-	gfar_write(&regs->fifo_tx_starve_shutoff, DEFAULT_FIFO_TX_STARVE_OFF);
-
-	/* Program the interrupt steering regs, only for MG devices */
-	if (priv->num_grps > 1)
-		gfar_write_isrg(priv);
-}
-
 static void gfar_init_addr_hash_table(struct gfar_private *priv)
 {
 	struct gfar __iomem *regs = priv->gfargrp[0].regs;
@@ -1302,578 +1007,6 @@ static void gfar_init_addr_hash_table(struct gfar_private *priv)
 	}
 }
 
-/* Set up the ethernet device structure, private data,
- * and anything else we need before we start
- */
-static int gfar_probe(struct platform_device *ofdev)
-{
-	struct device_node *np = ofdev->dev.of_node;
-	struct net_device *dev = NULL;
-	struct gfar_private *priv = NULL;
-	int err = 0, i;
-
-	err = gfar_of_init(ofdev, &dev);
-
-	if (err)
-		return err;
-
-	priv = netdev_priv(dev);
-	priv->ndev = dev;
-	priv->ofdev = ofdev;
-	priv->dev = &ofdev->dev;
-	SET_NETDEV_DEV(dev, &ofdev->dev);
-
-	INIT_WORK(&priv->reset_task, gfar_reset_task);
-
-	platform_set_drvdata(ofdev, priv);
-
-	gfar_detect_errata(priv);
-
-	/* Set the dev->base_addr to the gfar reg region */
-	dev->base_addr = (unsigned long) priv->gfargrp[0].regs;
-
-	/* Fill in the dev structure */
-	dev->watchdog_timeo = TX_TIMEOUT;
-	/* MTU range: 50 - 9586 */
-	dev->mtu = 1500;
-	dev->min_mtu = 50;
-	dev->max_mtu = GFAR_JUMBO_FRAME_SIZE - ETH_HLEN;
-	dev->netdev_ops = &gfar_netdev_ops;
-	dev->ethtool_ops = &gfar_ethtool_ops;
-
-	/* Register for napi ...We are registering NAPI for each grp */
-	for (i = 0; i < priv->num_grps; i++) {
-		if (priv->poll_mode == GFAR_SQ_POLLING) {
-			netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
-				       gfar_poll_rx_sq, GFAR_DEV_WEIGHT);
-			netif_tx_napi_add(dev, &priv->gfargrp[i].napi_tx,
-				       gfar_poll_tx_sq, 2);
-		} else {
-			netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
-				       gfar_poll_rx, GFAR_DEV_WEIGHT);
-			netif_tx_napi_add(dev, &priv->gfargrp[i].napi_tx,
-				       gfar_poll_tx, 2);
-		}
-	}
-
-	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
-		dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
-				   NETIF_F_RXCSUM;
-		dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG |
-				 NETIF_F_RXCSUM | NETIF_F_HIGHDMA;
-	}
-
-	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
-		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
-				    NETIF_F_HW_VLAN_CTAG_RX;
-		dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
-	}
-
-	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
-
-	gfar_init_addr_hash_table(priv);
-
-	/* Insert receive time stamps into padding alignment bytes, and
-	 * plus 2 bytes padding to ensure the cpu alignment.
-	 */
-	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
-		priv->padding = 8 + DEFAULT_PADDING;
-
-	if (dev->features & NETIF_F_IP_CSUM ||
-	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
-		dev->needed_headroom = GMAC_FCB_LEN;
-
-	/* Initializing some of the rx/tx queue level parameters */
-	for (i = 0; i < priv->num_tx_queues; i++) {
-		priv->tx_queue[i]->tx_ring_size = DEFAULT_TX_RING_SIZE;
-		priv->tx_queue[i]->num_txbdfree = DEFAULT_TX_RING_SIZE;
-		priv->tx_queue[i]->txcoalescing = DEFAULT_TX_COALESCE;
-		priv->tx_queue[i]->txic = DEFAULT_TXIC;
-	}
-
-	for (i = 0; i < priv->num_rx_queues; i++) {
-		priv->rx_queue[i]->rx_ring_size = DEFAULT_RX_RING_SIZE;
-		priv->rx_queue[i]->rxcoalescing = DEFAULT_RX_COALESCE;
-		priv->rx_queue[i]->rxic = DEFAULT_RXIC;
-	}
-
-	/* Always enable rx filer if available */
-	priv->rx_filer_enable =
-	    (priv->device_flags & FSL_GIANFAR_DEV_HAS_RX_FILER) ? 1 : 0;
-	/* Enable most messages by default */
-	priv->msg_enable = (NETIF_MSG_IFUP << 1 ) - 1;
-	/* use pritority h/w tx queue scheduling for single queue devices */
-	if (priv->num_tx_queues == 1)
-		priv->prio_sched_en = 1;
-
-	set_bit(GFAR_DOWN, &priv->state);
-
-	gfar_hw_init(priv);
-
-	/* Carrier starts down, phylib will bring it up */
-	netif_carrier_off(dev);
-
-	err = register_netdev(dev);
-
-	if (err) {
-		pr_err("%s: Cannot register net device, aborting\n", dev->name);
-		goto register_fail;
-	}
-
-	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_MAGIC_PACKET)
-		priv->wol_supported |= GFAR_WOL_MAGIC;
-
-	if ((priv->device_flags & FSL_GIANFAR_DEV_HAS_WAKE_ON_FILER) &&
-	    priv->rx_filer_enable)
-		priv->wol_supported |= GFAR_WOL_FILER_UCAST;
-
-	device_set_wakeup_capable(&ofdev->dev, priv->wol_supported);
-
-	/* fill out IRQ number and name fields */
-	for (i = 0; i < priv->num_grps; i++) {
-		struct gfar_priv_grp *grp = &priv->gfargrp[i];
-		if (priv->device_flags & FSL_GIANFAR_DEV_HAS_MULTI_INTR) {
-			sprintf(gfar_irq(grp, TX)->name, "%s%s%c%s",
-				dev->name, "_g", '0' + i, "_tx");
-			sprintf(gfar_irq(grp, RX)->name, "%s%s%c%s",
-				dev->name, "_g", '0' + i, "_rx");
-			sprintf(gfar_irq(grp, ER)->name, "%s%s%c%s",
-				dev->name, "_g", '0' + i, "_er");
-		} else
-			strcpy(gfar_irq(grp, TX)->name, dev->name);
-	}
-
-	/* Initialize the filer table */
-	gfar_init_filer_table(priv);
-
-	/* Print out the device info */
-	netdev_info(dev, "mac: %pM\n", dev->dev_addr);
-
-	/* Even more device info helps when determining which kernel
-	 * provided which set of benchmarks.
-	 */
-	netdev_info(dev, "Running with NAPI enabled\n");
-	for (i = 0; i < priv->num_rx_queues; i++)
-		netdev_info(dev, "RX BD ring size for Q[%d]: %d\n",
-			    i, priv->rx_queue[i]->rx_ring_size);
-	for (i = 0; i < priv->num_tx_queues; i++)
-		netdev_info(dev, "TX BD ring size for Q[%d]: %d\n",
-			    i, priv->tx_queue[i]->tx_ring_size);
-
-	return 0;
-
-register_fail:
-	if (of_phy_is_fixed_link(np))
-		of_phy_deregister_fixed_link(np);
-	unmap_group_regs(priv);
-	gfar_free_rx_queues(priv);
-	gfar_free_tx_queues(priv);
-	of_node_put(priv->phy_node);
-	of_node_put(priv->tbi_node);
-	free_gfar_dev(priv);
-	return err;
-}
-
-static int gfar_remove(struct platform_device *ofdev)
-{
-	struct gfar_private *priv = platform_get_drvdata(ofdev);
-	struct device_node *np = ofdev->dev.of_node;
-
-	of_node_put(priv->phy_node);
-	of_node_put(priv->tbi_node);
-
-	unregister_netdev(priv->ndev);
-
-	if (of_phy_is_fixed_link(np))
-		of_phy_deregister_fixed_link(np);
-
-	unmap_group_regs(priv);
-	gfar_free_rx_queues(priv);
-	gfar_free_tx_queues(priv);
-	free_gfar_dev(priv);
-
-	return 0;
-}
-
-#ifdef CONFIG_PM
-
-static void __gfar_filer_disable(struct gfar_private *priv)
-{
-	struct gfar __iomem *regs = priv->gfargrp[0].regs;
-	u32 temp;
-
-	temp = gfar_read(&regs->rctrl);
-	temp &= ~(RCTRL_FILREN | RCTRL_PRSDEP_INIT);
-	gfar_write(&regs->rctrl, temp);
-}
-
-static void __gfar_filer_enable(struct gfar_private *priv)
-{
-	struct gfar __iomem *regs = priv->gfargrp[0].regs;
-	u32 temp;
-
-	temp = gfar_read(&regs->rctrl);
-	temp |= RCTRL_FILREN | RCTRL_PRSDEP_INIT;
-	gfar_write(&regs->rctrl, temp);
-}
-
-/* Filer rules implementing wol capabilities */
-static void gfar_filer_config_wol(struct gfar_private *priv)
-{
-	unsigned int i;
-	u32 rqfcr;
-
-	__gfar_filer_disable(priv);
-
-	/* clear the filer table, reject any packet by default */
-	rqfcr = RQFCR_RJE | RQFCR_CMP_MATCH;
-	for (i = 0; i <= MAX_FILER_IDX; i++)
-		gfar_write_filer(priv, i, rqfcr, 0);
-
-	i = 0;
-	if (priv->wol_opts & GFAR_WOL_FILER_UCAST) {
-		/* unicast packet, accept it */
-		struct net_device *ndev = priv->ndev;
-		/* get the default rx queue index */
-		u8 qindex = (u8)priv->gfargrp[0].rx_queue->qindex;
-		u32 dest_mac_addr = (ndev->dev_addr[0] << 16) |
-				    (ndev->dev_addr[1] << 8) |
-				     ndev->dev_addr[2];
-
-		rqfcr = (qindex << 10) | RQFCR_AND |
-			RQFCR_CMP_EXACT | RQFCR_PID_DAH;
-
-		gfar_write_filer(priv, i++, rqfcr, dest_mac_addr);
-
-		dest_mac_addr = (ndev->dev_addr[3] << 16) |
-				(ndev->dev_addr[4] << 8) |
-				 ndev->dev_addr[5];
-		rqfcr = (qindex << 10) | RQFCR_GPI |
-			RQFCR_CMP_EXACT | RQFCR_PID_DAL;
-		gfar_write_filer(priv, i++, rqfcr, dest_mac_addr);
-	}
-
-	__gfar_filer_enable(priv);
-}
-
-static void gfar_filer_restore_table(struct gfar_private *priv)
-{
-	u32 rqfcr, rqfpr;
-	unsigned int i;
-
-	__gfar_filer_disable(priv);
-
-	for (i = 0; i <= MAX_FILER_IDX; i++) {
-		rqfcr = priv->ftp_rqfcr[i];
-		rqfpr = priv->ftp_rqfpr[i];
-		gfar_write_filer(priv, i, rqfcr, rqfpr);
-	}
-
-	__gfar_filer_enable(priv);
-}
-
-/* gfar_start() for Rx only and with the FGPI filer interrupt enabled */
-static void gfar_start_wol_filer(struct gfar_private *priv)
-{
-	struct gfar __iomem *regs = priv->gfargrp[0].regs;
-	u32 tempval;
-	int i = 0;
-
-	/* Enable Rx hw queues */
-	gfar_write(&regs->rqueue, priv->rqueue);
-
-	/* Initialize DMACTRL to have WWR and WOP */
-	tempval = gfar_read(&regs->dmactrl);
-	tempval |= DMACTRL_INIT_SETTINGS;
-	gfar_write(&regs->dmactrl, tempval);
-
-	/* Make sure we aren't stopped */
-	tempval = gfar_read(&regs->dmactrl);
-	tempval &= ~DMACTRL_GRS;
-	gfar_write(&regs->dmactrl, tempval);
-
-	for (i = 0; i < priv->num_grps; i++) {
-		regs = priv->gfargrp[i].regs;
-		/* Clear RHLT, so that the DMA starts polling now */
-		gfar_write(&regs->rstat, priv->gfargrp[i].rstat);
-		/* enable the Filer General Purpose Interrupt */
-		gfar_write(&regs->imask, IMASK_FGPI);
-	}
-
-	/* Enable Rx DMA */
-	tempval = gfar_read(&regs->maccfg1);
-	tempval |= MACCFG1_RX_EN;
-	gfar_write(&regs->maccfg1, tempval);
-}
-
-static int gfar_suspend(struct device *dev)
-{
-	struct gfar_private *priv = dev_get_drvdata(dev);
-	struct net_device *ndev = priv->ndev;
-	struct gfar __iomem *regs = priv->gfargrp[0].regs;
-	u32 tempval;
-	u16 wol = priv->wol_opts;
-
-	if (!netif_running(ndev))
-		return 0;
-
-	disable_napi(priv);
-	netif_tx_lock(ndev);
-	netif_device_detach(ndev);
-	netif_tx_unlock(ndev);
-
-	gfar_halt(priv);
-
-	if (wol & GFAR_WOL_MAGIC) {
-		/* Enable interrupt on Magic Packet */
-		gfar_write(&regs->imask, IMASK_MAG);
-
-		/* Enable Magic Packet mode */
-		tempval = gfar_read(&regs->maccfg2);
-		tempval |= MACCFG2_MPEN;
-		gfar_write(&regs->maccfg2, tempval);
-
-		/* re-enable the Rx block */
-		tempval = gfar_read(&regs->maccfg1);
-		tempval |= MACCFG1_RX_EN;
-		gfar_write(&regs->maccfg1, tempval);
-
-	} else if (wol & GFAR_WOL_FILER_UCAST) {
-		gfar_filer_config_wol(priv);
-		gfar_start_wol_filer(priv);
-
-	} else {
-		phy_stop(ndev->phydev);
-	}
-
-	return 0;
-}
-
-static int gfar_resume(struct device *dev)
-{
-	struct gfar_private *priv = dev_get_drvdata(dev);
-	struct net_device *ndev = priv->ndev;
-	struct gfar __iomem *regs = priv->gfargrp[0].regs;
-	u32 tempval;
-	u16 wol = priv->wol_opts;
-
-	if (!netif_running(ndev))
-		return 0;
-
-	if (wol & GFAR_WOL_MAGIC) {
-		/* Disable Magic Packet mode */
-		tempval = gfar_read(&regs->maccfg2);
-		tempval &= ~MACCFG2_MPEN;
-		gfar_write(&regs->maccfg2, tempval);
-
-	} else if (wol & GFAR_WOL_FILER_UCAST) {
-		/* need to stop rx only, tx is already down */
-		gfar_halt(priv);
-		gfar_filer_restore_table(priv);
-
-	} else {
-		phy_start(ndev->phydev);
-	}
-
-	gfar_start(priv);
-
-	netif_device_attach(ndev);
-	enable_napi(priv);
-
-	return 0;
-}
-
-static int gfar_restore(struct device *dev)
-{
-	struct gfar_private *priv = dev_get_drvdata(dev);
-	struct net_device *ndev = priv->ndev;
-
-	if (!netif_running(ndev)) {
-		netif_device_attach(ndev);
-
-		return 0;
-	}
-
-	gfar_init_bds(ndev);
-
-	gfar_mac_reset(priv);
-
-	gfar_init_tx_rx_base(priv);
-
-	gfar_start(priv);
-
-	priv->oldlink = 0;
-	priv->oldspeed = 0;
-	priv->oldduplex = -1;
-
-	if (ndev->phydev)
-		phy_start(ndev->phydev);
-
-	netif_device_attach(ndev);
-	enable_napi(priv);
-
-	return 0;
-}
-
-static const struct dev_pm_ops gfar_pm_ops = {
-	.suspend = gfar_suspend,
-	.resume = gfar_resume,
-	.freeze = gfar_suspend,
-	.thaw = gfar_resume,
-	.restore = gfar_restore,
-};
-
-#define GFAR_PM_OPS (&gfar_pm_ops)
-
-#else
-
-#define GFAR_PM_OPS NULL
-
-#endif
-
-/* Reads the controller's registers to determine what interface
- * connects it to the PHY.
- */
-static phy_interface_t gfar_get_interface(struct net_device *dev)
-{
-	struct gfar_private *priv = netdev_priv(dev);
-	struct gfar __iomem *regs = priv->gfargrp[0].regs;
-	u32 ecntrl;
-
-	ecntrl = gfar_read(&regs->ecntrl);
-
-	if (ecntrl & ECNTRL_SGMII_MODE)
-		return PHY_INTERFACE_MODE_SGMII;
-
-	if (ecntrl & ECNTRL_TBI_MODE) {
-		if (ecntrl & ECNTRL_REDUCED_MODE)
-			return PHY_INTERFACE_MODE_RTBI;
-		else
-			return PHY_INTERFACE_MODE_TBI;
-	}
-
-	if (ecntrl & ECNTRL_REDUCED_MODE) {
-		if (ecntrl & ECNTRL_REDUCED_MII_MODE) {
-			return PHY_INTERFACE_MODE_RMII;
-		}
-		else {
-			phy_interface_t interface = priv->interface;
-
-			/* This isn't autodetected right now, so it must
-			 * be set by the device tree or platform code.
-			 */
-			if (interface == PHY_INTERFACE_MODE_RGMII_ID)
-				return PHY_INTERFACE_MODE_RGMII_ID;
-
-			return PHY_INTERFACE_MODE_RGMII;
-		}
-	}
-
-	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_GIGABIT)
-		return PHY_INTERFACE_MODE_GMII;
-
-	return PHY_INTERFACE_MODE_MII;
-}
-
-
-/* Initializes driver's PHY state, and attaches to the PHY.
- * Returns 0 on success.
- */
-static int init_phy(struct net_device *dev)
-{
-	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
-	struct gfar_private *priv = netdev_priv(dev);
-	phy_interface_t interface;
-	struct phy_device *phydev;
-	struct ethtool_eee edata;
-
-	linkmode_set_bit_array(phy_10_100_features_array,
-			       ARRAY_SIZE(phy_10_100_features_array),
-			       mask);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, mask);
-	linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT, mask);
-	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_GIGABIT)
-		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, mask);
-
-	priv->oldlink = 0;
-	priv->oldspeed = 0;
-	priv->oldduplex = -1;
-
-	interface = gfar_get_interface(dev);
-
-	phydev = of_phy_connect(dev, priv->phy_node, &adjust_link, 0,
-				interface);
-	if (!phydev) {
-		dev_err(&dev->dev, "could not attach to PHY\n");
-		return -ENODEV;
-	}
-
-	if (interface == PHY_INTERFACE_MODE_SGMII)
-		gfar_configure_serdes(dev);
-
-	/* Remove any features not supported by the controller */
-	linkmode_and(phydev->supported, phydev->supported, mask);
-	linkmode_copy(phydev->advertising, phydev->supported);
-
-	/* Add support for flow control */
-	phy_support_asym_pause(phydev);
-
-	/* disable EEE autoneg, EEE not supported by eTSEC */
-	memset(&edata, 0, sizeof(struct ethtool_eee));
-	phy_ethtool_set_eee(phydev, &edata);
-
-	return 0;
-}
-
-/* Initialize TBI PHY interface for communicating with the
- * SERDES lynx PHY on the chip.  We communicate with this PHY
- * through the MDIO bus on each controller, treating it as a
- * "normal" PHY at the address found in the TBIPA register.  We assume
- * that the TBIPA register is valid.  Either the MDIO bus code will set
- * it to a value that doesn't conflict with other PHYs on the bus, or the
- * value doesn't matter, as there are no other PHYs on the bus.
- */
-static void gfar_configure_serdes(struct net_device *dev)
-{
-	struct gfar_private *priv = netdev_priv(dev);
-	struct phy_device *tbiphy;
-
-	if (!priv->tbi_node) {
-		dev_warn(&dev->dev, "error: SGMII mode requires that the "
-				    "device tree specify a tbi-handle\n");
-		return;
-	}
-
-	tbiphy = of_phy_find_device(priv->tbi_node);
-	if (!tbiphy) {
-		dev_err(&dev->dev, "error: Could not get TBI device\n");
-		return;
-	}
-
-	/* If the link is already up, we must already be ok, and don't need to
-	 * configure and reset the TBI<->SerDes link.  Maybe U-Boot configured
-	 * everything for us?  Resetting it takes the link down and requires
-	 * several seconds for it to come back.
-	 */
-	if (phy_read(tbiphy, MII_BMSR) & BMSR_LSTATUS) {
-		put_device(&tbiphy->mdio.dev);
-		return;
-	}
-
-	/* Single clk mode, mii mode off(for serdes communication) */
-	phy_write(tbiphy, MII_TBICON, TBICON_CLK_SELECT);
-
-	phy_write(tbiphy, MII_ADVERTISE,
-		  ADVERTISE_1000XFULL | ADVERTISE_1000XPAUSE |
-		  ADVERTISE_1000XPSE_ASYM);
-
-	phy_write(tbiphy, MII_BMCR,
-		  BMCR_ANENABLE | BMCR_ANRESTART | BMCR_FULLDPLX |
-		  BMCR_SPEED1000);
-
-	put_device(&tbiphy->mdio.dev);
-}
-
 static int __gfar_is_rx_idle(struct gfar_private *priv)
 {
 	u32 res;
@@ -1949,26 +1082,6 @@ void gfar_halt(struct gfar_private *priv)
 	gfar_write(&regs->maccfg1, tempval);
 }
 
-void stop_gfar(struct net_device *dev)
-{
-	struct gfar_private *priv = netdev_priv(dev);
-
-	netif_tx_stop_all_queues(dev);
-
-	smp_mb__before_atomic();
-	set_bit(GFAR_DOWN, &priv->state);
-	smp_mb__after_atomic();
-
-	disable_napi(priv);
-
-	/* disable ints and gracefully shut down Rx/Tx DMA */
-	gfar_halt(priv);
-
-	phy_stop(dev->phydev);
-
-	free_skb_resources(priv);
-}
-
 static void free_skb_tx_queue(struct gfar_priv_tx_q *tx_queue)
 {
 	struct txbd8 *txbdp;
@@ -2061,6 +1174,26 @@ static void free_skb_resources(struct gfar_private *priv)
 			  priv->tx_queue[0]->tx_bd_dma_base);
 }
 
+void stop_gfar(struct net_device *dev)
+{
+	struct gfar_private *priv = netdev_priv(dev);
+
+	netif_tx_stop_all_queues(dev);
+
+	smp_mb__before_atomic();
+	set_bit(GFAR_DOWN, &priv->state);
+	smp_mb__after_atomic();
+
+	disable_napi(priv);
+
+	/* disable ints and gracefully shut down Rx/Tx DMA */
+	gfar_halt(priv);
+
+	phy_stop(dev->phydev);
+
+	free_skb_resources(priv);
+}
+
 void gfar_start(struct gfar_private *priv)
 {
 	struct gfar __iomem *regs = priv->gfargrp[0].regs;
@@ -2098,103 +1231,207 @@ void gfar_start(struct gfar_private *priv)
 	netif_trans_update(priv->ndev); /* prevent tx timeout */
 }
 
-static void free_grp_irqs(struct gfar_priv_grp *grp)
+static bool gfar_new_page(struct gfar_priv_rx_q *rxq, struct gfar_rx_buff *rxb)
 {
-	free_irq(gfar_irq(grp, TX)->irq, grp);
-	free_irq(gfar_irq(grp, RX)->irq, grp);
-	free_irq(gfar_irq(grp, ER)->irq, grp);
-}
+	struct page *page;
+	dma_addr_t addr;
 
-static int register_grp_irqs(struct gfar_priv_grp *grp)
-{
-	struct gfar_private *priv = grp->priv;
-	struct net_device *dev = priv->ndev;
-	int err;
+	page = dev_alloc_page();
+	if (unlikely(!page))
+		return false;
 
-	/* If the device has multiple interrupts, register for
-	 * them.  Otherwise, only register for the one
-	 */
-	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_MULTI_INTR) {
-		/* Install our interrupt handlers for Error,
-		 * Transmit, and Receive
-		 */
-		err = request_irq(gfar_irq(grp, ER)->irq, gfar_error, 0,
-				  gfar_irq(grp, ER)->name, grp);
-		if (err < 0) {
-			netif_err(priv, intr, dev, "Can't get IRQ %d\n",
-				  gfar_irq(grp, ER)->irq);
+	addr = dma_map_page(rxq->dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
+	if (unlikely(dma_mapping_error(rxq->dev, addr))) {
+		__free_page(page);
 
-			goto err_irq_fail;
-		}
-		enable_irq_wake(gfar_irq(grp, ER)->irq);
-
-		err = request_irq(gfar_irq(grp, TX)->irq, gfar_transmit, 0,
-				  gfar_irq(grp, TX)->name, grp);
-		if (err < 0) {
-			netif_err(priv, intr, dev, "Can't get IRQ %d\n",
-				  gfar_irq(grp, TX)->irq);
-			goto tx_irq_fail;
-		}
-		err = request_irq(gfar_irq(grp, RX)->irq, gfar_receive, 0,
-				  gfar_irq(grp, RX)->name, grp);
-		if (err < 0) {
-			netif_err(priv, intr, dev, "Can't get IRQ %d\n",
-				  gfar_irq(grp, RX)->irq);
-			goto rx_irq_fail;
-		}
-		enable_irq_wake(gfar_irq(grp, RX)->irq);
-
-	} else {
-		err = request_irq(gfar_irq(grp, TX)->irq, gfar_interrupt, 0,
-				  gfar_irq(grp, TX)->name, grp);
-		if (err < 0) {
-			netif_err(priv, intr, dev, "Can't get IRQ %d\n",
-				  gfar_irq(grp, TX)->irq);
-			goto err_irq_fail;
-		}
-		enable_irq_wake(gfar_irq(grp, TX)->irq);
+		return false;
 	}
 
-	return 0;
-
-rx_irq_fail:
-	free_irq(gfar_irq(grp, TX)->irq, grp);
-tx_irq_fail:
-	free_irq(gfar_irq(grp, ER)->irq, grp);
-err_irq_fail:
-	return err;
+	rxb->dma = addr;
+	rxb->page = page;
+	rxb->page_offset = 0;
 
+	return true;
 }
 
-static void gfar_free_irq(struct gfar_private *priv)
+static void gfar_rx_alloc_err(struct gfar_priv_rx_q *rx_queue)
 {
+	struct gfar_private *priv = netdev_priv(rx_queue->ndev);
+	struct gfar_extra_stats *estats = &priv->extra_stats;
+
+	netdev_err(rx_queue->ndev, "Can't alloc RX buffers\n");
+	atomic64_inc(&estats->rx_alloc_err);
+}
+
+static void gfar_alloc_rx_buffs(struct gfar_priv_rx_q *rx_queue,
+				int alloc_cnt)
+{
+	struct rxbd8 *bdp;
+	struct gfar_rx_buff *rxb;
 	int i;
 
-	/* Free the IRQs */
-	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_MULTI_INTR) {
-		for (i = 0; i < priv->num_grps; i++)
-			free_grp_irqs(&priv->gfargrp[i]);
-	} else {
-		for (i = 0; i < priv->num_grps; i++)
-			free_irq(gfar_irq(&priv->gfargrp[i], TX)->irq,
-				 &priv->gfargrp[i]);
-	}
-}
+	i = rx_queue->next_to_use;
+	bdp = &rx_queue->rx_bd_base[i];
+	rxb = &rx_queue->rx_buff[i];
 
-static int gfar_request_irq(struct gfar_private *priv)
-{
-	int err, i, j;
+	while (alloc_cnt--) {
+		/* try reuse page */
+		if (unlikely(!rxb->page)) {
+			if (unlikely(!gfar_new_page(rx_queue, rxb))) {
+				gfar_rx_alloc_err(rx_queue);
+				break;
+			}
+		}
 
-	for (i = 0; i < priv->num_grps; i++) {
-		err = register_grp_irqs(&priv->gfargrp[i]);
-		if (err) {
-			for (j = 0; j < i; j++)
-				free_grp_irqs(&priv->gfargrp[j]);
-			return err;
+		/* Setup the new RxBD */
+		gfar_init_rxbdp(rx_queue, bdp,
+				rxb->dma + rxb->page_offset + RXBUF_ALIGNMENT);
+
+		/* Update to the next pointer */
+		bdp++;
+		rxb++;
+
+		if (unlikely(++i == rx_queue->rx_ring_size)) {
+			i = 0;
+			bdp = rx_queue->rx_bd_base;
+			rxb = rx_queue->rx_buff;
 		}
 	}
 
+	rx_queue->next_to_use = i;
+	rx_queue->next_to_alloc = i;
+}
+
+static void gfar_init_bds(struct net_device *ndev)
+{
+	struct gfar_private *priv = netdev_priv(ndev);
+	struct gfar __iomem *regs = priv->gfargrp[0].regs;
+	struct gfar_priv_tx_q *tx_queue = NULL;
+	struct gfar_priv_rx_q *rx_queue = NULL;
+	struct txbd8 *txbdp;
+	u32 __iomem *rfbptr;
+	int i, j;
+
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		tx_queue = priv->tx_queue[i];
+		/* Initialize some variables in our dev structure */
+		tx_queue->num_txbdfree = tx_queue->tx_ring_size;
+		tx_queue->dirty_tx = tx_queue->tx_bd_base;
+		tx_queue->cur_tx = tx_queue->tx_bd_base;
+		tx_queue->skb_curtx = 0;
+		tx_queue->skb_dirtytx = 0;
+
+		/* Initialize Transmit Descriptor Ring */
+		txbdp = tx_queue->tx_bd_base;
+		for (j = 0; j < tx_queue->tx_ring_size; j++) {
+			txbdp->lstatus = 0;
+			txbdp->bufPtr = 0;
+			txbdp++;
+		}
+
+		/* Set the last descriptor in the ring to indicate wrap */
+		txbdp--;
+		txbdp->status = cpu_to_be16(be16_to_cpu(txbdp->status) |
+					    TXBD_WRAP);
+	}
+
+	rfbptr = &regs->rfbptr0;
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		rx_queue = priv->rx_queue[i];
+
+		rx_queue->next_to_clean = 0;
+		rx_queue->next_to_use = 0;
+		rx_queue->next_to_alloc = 0;
+
+		/* make sure next_to_clean != next_to_use after this
+		 * by leaving at least 1 unused descriptor
+		 */
+		gfar_alloc_rx_buffs(rx_queue, gfar_rxbd_unused(rx_queue));
+
+		rx_queue->rfbptr = rfbptr;
+		rfbptr += 2;
+	}
+}
+
+static int gfar_alloc_skb_resources(struct net_device *ndev)
+{
+	void *vaddr;
+	dma_addr_t addr;
+	int i, j;
+	struct gfar_private *priv = netdev_priv(ndev);
+	struct device *dev = priv->dev;
+	struct gfar_priv_tx_q *tx_queue = NULL;
+	struct gfar_priv_rx_q *rx_queue = NULL;
+
+	priv->total_tx_ring_size = 0;
+	for (i = 0; i < priv->num_tx_queues; i++)
+		priv->total_tx_ring_size += priv->tx_queue[i]->tx_ring_size;
+
+	priv->total_rx_ring_size = 0;
+	for (i = 0; i < priv->num_rx_queues; i++)
+		priv->total_rx_ring_size += priv->rx_queue[i]->rx_ring_size;
+
+	/* Allocate memory for the buffer descriptors */
+	vaddr = dma_alloc_coherent(dev,
+				   (priv->total_tx_ring_size *
+				    sizeof(struct txbd8)) +
+				   (priv->total_rx_ring_size *
+				    sizeof(struct rxbd8)),
+				   &addr, GFP_KERNEL);
+	if (!vaddr)
+		return -ENOMEM;
+
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		tx_queue = priv->tx_queue[i];
+		tx_queue->tx_bd_base = vaddr;
+		tx_queue->tx_bd_dma_base = addr;
+		tx_queue->dev = ndev;
+		/* enet DMA only understands physical addresses */
+		addr  += sizeof(struct txbd8) * tx_queue->tx_ring_size;
+		vaddr += sizeof(struct txbd8) * tx_queue->tx_ring_size;
+	}
+
+	/* Start the rx descriptor ring where the tx ring leaves off */
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		rx_queue = priv->rx_queue[i];
+		rx_queue->rx_bd_base = vaddr;
+		rx_queue->rx_bd_dma_base = addr;
+		rx_queue->ndev = ndev;
+		rx_queue->dev = dev;
+		addr  += sizeof(struct rxbd8) * rx_queue->rx_ring_size;
+		vaddr += sizeof(struct rxbd8) * rx_queue->rx_ring_size;
+	}
+
+	/* Setup the skbuff rings */
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		tx_queue = priv->tx_queue[i];
+		tx_queue->tx_skbuff =
+			kmalloc_array(tx_queue->tx_ring_size,
+				      sizeof(*tx_queue->tx_skbuff),
+				      GFP_KERNEL);
+		if (!tx_queue->tx_skbuff)
+			goto cleanup;
+
+		for (j = 0; j < tx_queue->tx_ring_size; j++)
+			tx_queue->tx_skbuff[j] = NULL;
+	}
+
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		rx_queue = priv->rx_queue[i];
+		rx_queue->rx_buff = kcalloc(rx_queue->rx_ring_size,
+					    sizeof(*rx_queue->rx_buff),
+					    GFP_KERNEL);
+		if (!rx_queue->rx_buff)
+			goto cleanup;
+	}
+
+	gfar_init_bds(ndev);
+
 	return 0;
+
+cleanup:
+	free_skb_resources(priv);
+	return -ENOMEM;
 }
 
 /* Bring the controller up and running */
@@ -2232,27 +1469,247 @@ int startup_gfar(struct net_device *ndev)
 	return 0;
 }
 
-/* Called when something needs to use the ethernet device
- * Returns 0 for success.
+static u32 gfar_get_flowctrl_cfg(struct gfar_private *priv)
+{
+	struct net_device *ndev = priv->ndev;
+	struct phy_device *phydev = ndev->phydev;
+	u32 val = 0;
+
+	if (!phydev->duplex)
+		return val;
+
+	if (!priv->pause_aneg_en) {
+		if (priv->tx_pause_en)
+			val |= MACCFG1_TX_FLOW;
+		if (priv->rx_pause_en)
+			val |= MACCFG1_RX_FLOW;
+	} else {
+		u16 lcl_adv, rmt_adv;
+		u8 flowctrl;
+		/* get link partner capabilities */
+		rmt_adv = 0;
+		if (phydev->pause)
+			rmt_adv = LPA_PAUSE_CAP;
+		if (phydev->asym_pause)
+			rmt_adv |= LPA_PAUSE_ASYM;
+
+		lcl_adv = linkmode_adv_to_lcl_adv_t(phydev->advertising);
+		flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
+		if (flowctrl & FLOW_CTRL_TX)
+			val |= MACCFG1_TX_FLOW;
+		if (flowctrl & FLOW_CTRL_RX)
+			val |= MACCFG1_RX_FLOW;
+	}
+
+	return val;
+}
+
+static noinline void gfar_update_link_state(struct gfar_private *priv)
+{
+	struct gfar __iomem *regs = priv->gfargrp[0].regs;
+	struct net_device *ndev = priv->ndev;
+	struct phy_device *phydev = ndev->phydev;
+	struct gfar_priv_rx_q *rx_queue = NULL;
+	int i;
+
+	if (unlikely(test_bit(GFAR_RESETTING, &priv->state)))
+		return;
+
+	if (phydev->link) {
+		u32 tempval1 = gfar_read(&regs->maccfg1);
+		u32 tempval = gfar_read(&regs->maccfg2);
+		u32 ecntrl = gfar_read(&regs->ecntrl);
+		u32 tx_flow_oldval = (tempval1 & MACCFG1_TX_FLOW);
+
+		if (phydev->duplex != priv->oldduplex) {
+			if (!(phydev->duplex))
+				tempval &= ~(MACCFG2_FULL_DUPLEX);
+			else
+				tempval |= MACCFG2_FULL_DUPLEX;
+
+			priv->oldduplex = phydev->duplex;
+		}
+
+		if (phydev->speed != priv->oldspeed) {
+			switch (phydev->speed) {
+			case 1000:
+				tempval =
+				    ((tempval & ~(MACCFG2_IF)) | MACCFG2_GMII);
+
+				ecntrl &= ~(ECNTRL_R100);
+				break;
+			case 100:
+			case 10:
+				tempval =
+				    ((tempval & ~(MACCFG2_IF)) | MACCFG2_MII);
+
+				/* Reduced mode distinguishes
+				 * between 10 and 100
+				 */
+				if (phydev->speed == SPEED_100)
+					ecntrl |= ECNTRL_R100;
+				else
+					ecntrl &= ~(ECNTRL_R100);
+				break;
+			default:
+				netif_warn(priv, link, priv->ndev,
+					   "Ack!  Speed (%d) is not 10/100/1000!\n",
+					   phydev->speed);
+				break;
+			}
+
+			priv->oldspeed = phydev->speed;
+		}
+
+		tempval1 &= ~(MACCFG1_TX_FLOW | MACCFG1_RX_FLOW);
+		tempval1 |= gfar_get_flowctrl_cfg(priv);
+
+		/* Turn last free buffer recording on */
+		if ((tempval1 & MACCFG1_TX_FLOW) && !tx_flow_oldval) {
+			for (i = 0; i < priv->num_rx_queues; i++) {
+				u32 bdp_dma;
+
+				rx_queue = priv->rx_queue[i];
+				bdp_dma = gfar_rxbd_dma_lastfree(rx_queue);
+				gfar_write(rx_queue->rfbptr, bdp_dma);
+			}
+
+			priv->tx_actual_en = 1;
+		}
+
+		if (unlikely(!(tempval1 & MACCFG1_TX_FLOW) && tx_flow_oldval))
+			priv->tx_actual_en = 0;
+
+		gfar_write(&regs->maccfg1, tempval1);
+		gfar_write(&regs->maccfg2, tempval);
+		gfar_write(&regs->ecntrl, ecntrl);
+
+		if (!priv->oldlink)
+			priv->oldlink = 1;
+
+	} else if (priv->oldlink) {
+		priv->oldlink = 0;
+		priv->oldspeed = 0;
+		priv->oldduplex = -1;
+	}
+
+	if (netif_msg_link(priv))
+		phy_print_status(phydev);
+}
+
+/* Called every time the controller might need to be made
+ * aware of new link state.  The PHY code conveys this
+ * information through variables in the phydev structure, and this
+ * function converts those variables into the appropriate
+ * register values, and can bring down the device if needed.
  */
-static int gfar_enet_open(struct net_device *dev)
+static void adjust_link(struct net_device *dev)
 {
 	struct gfar_private *priv = netdev_priv(dev);
-	int err;
+	struct phy_device *phydev = dev->phydev;
 
-	err = init_phy(dev);
-	if (err)
-		return err;
+	if (unlikely(phydev->link != priv->oldlink ||
+		     (phydev->link && (phydev->duplex != priv->oldduplex ||
+				       phydev->speed != priv->oldspeed))))
+		gfar_update_link_state(priv);
+}
 
-	err = gfar_request_irq(priv);
-	if (err)
-		return err;
+/* Initialize TBI PHY interface for communicating with the
+ * SERDES lynx PHY on the chip.  We communicate with this PHY
+ * through the MDIO bus on each controller, treating it as a
+ * "normal" PHY at the address found in the TBIPA register.  We assume
+ * that the TBIPA register is valid.  Either the MDIO bus code will set
+ * it to a value that doesn't conflict with other PHYs on the bus, or the
+ * value doesn't matter, as there are no other PHYs on the bus.
+ */
+static void gfar_configure_serdes(struct net_device *dev)
+{
+	struct gfar_private *priv = netdev_priv(dev);
+	struct phy_device *tbiphy;
 
-	err = startup_gfar(dev);
-	if (err)
-		return err;
+	if (!priv->tbi_node) {
+		dev_warn(&dev->dev, "error: SGMII mode requires that the "
+				    "device tree specify a tbi-handle\n");
+		return;
+	}
 
-	return err;
+	tbiphy = of_phy_find_device(priv->tbi_node);
+	if (!tbiphy) {
+		dev_err(&dev->dev, "error: Could not get TBI device\n");
+		return;
+	}
+
+	/* If the link is already up, we must already be ok, and don't need to
+	 * configure and reset the TBI<->SerDes link.  Maybe U-Boot configured
+	 * everything for us?  Resetting it takes the link down and requires
+	 * several seconds for it to come back.
+	 */
+	if (phy_read(tbiphy, MII_BMSR) & BMSR_LSTATUS) {
+		put_device(&tbiphy->mdio.dev);
+		return;
+	}
+
+	/* Single clk mode, mii mode off(for serdes communication) */
+	phy_write(tbiphy, MII_TBICON, TBICON_CLK_SELECT);
+
+	phy_write(tbiphy, MII_ADVERTISE,
+		  ADVERTISE_1000XFULL | ADVERTISE_1000XPAUSE |
+		  ADVERTISE_1000XPSE_ASYM);
+
+	phy_write(tbiphy, MII_BMCR,
+		  BMCR_ANENABLE | BMCR_ANRESTART | BMCR_FULLDPLX |
+		  BMCR_SPEED1000);
+
+	put_device(&tbiphy->mdio.dev);
+}
+
+/* Initializes driver's PHY state, and attaches to the PHY.
+ * Returns 0 on success.
+ */
+static int init_phy(struct net_device *dev)
+{
+	__ETHTOOL_DECLARE_LINK_MODE_MASK(mask) = { 0, };
+	struct gfar_private *priv = netdev_priv(dev);
+	phy_interface_t interface;
+	struct phy_device *phydev;
+	struct ethtool_eee edata;
+
+	linkmode_set_bit_array(phy_10_100_features_array,
+			       ARRAY_SIZE(phy_10_100_features_array),
+			       mask);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, mask);
+	linkmode_set_bit(ETHTOOL_LINK_MODE_MII_BIT, mask);
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_GIGABIT)
+		linkmode_set_bit(ETHTOOL_LINK_MODE_1000baseT_Full_BIT, mask);
+
+	priv->oldlink = 0;
+	priv->oldspeed = 0;
+	priv->oldduplex = -1;
+
+	interface = gfar_get_interface(dev);
+
+	phydev = of_phy_connect(dev, priv->phy_node, &adjust_link, 0,
+				interface);
+	if (!phydev) {
+		dev_err(&dev->dev, "could not attach to PHY\n");
+		return -ENODEV;
+	}
+
+	if (interface == PHY_INTERFACE_MODE_SGMII)
+		gfar_configure_serdes(dev);
+
+	/* Remove any features not supported by the controller */
+	linkmode_and(phydev->supported, phydev->supported, mask);
+	linkmode_copy(phydev->advertising, phydev->supported);
+
+	/* Add support for flow control */
+	phy_support_asym_pause(phydev);
+
+	/* disable EEE autoneg, EEE not supported by eTSEC */
+	memset(&edata, 0, sizeof(struct ethtool_eee));
+	phy_ethtool_set_eee(phydev, &edata);
+
+	return 0;
 }
 
 static inline struct txfcb *gfar_add_fcb(struct sk_buff *skb)
@@ -2583,22 +2040,6 @@ static netdev_tx_t gfar_start_xmit(struct sk_buff *skb, struct net_device *dev)
 	return NETDEV_TX_OK;
 }
 
-/* Stops the kernel queue, and halts the controller */
-static int gfar_close(struct net_device *dev)
-{
-	struct gfar_private *priv = netdev_priv(dev);
-
-	cancel_work_sync(&priv->reset_task);
-	stop_gfar(dev);
-
-	/* Disconnect from the PHY */
-	phy_disconnect(dev->phydev);
-
-	gfar_free_irq(priv);
-
-	return 0;
-}
-
 /* Changes the mac address if the controller is not running. */
 static int gfar_set_mac_address(struct net_device *dev)
 {
@@ -2660,6 +2101,85 @@ static void gfar_timeout(struct net_device *dev)
 	schedule_work(&priv->reset_task);
 }
 
+static int gfar_hwtstamp_set(struct net_device *netdev, struct ifreq *ifr)
+{
+	struct hwtstamp_config config;
+	struct gfar_private *priv = netdev_priv(netdev);
+
+	if (copy_from_user(&config, ifr->ifr_data, sizeof(config)))
+		return -EFAULT;
+
+	/* reserved for future extensions */
+	if (config.flags)
+		return -EINVAL;
+
+	switch (config.tx_type) {
+	case HWTSTAMP_TX_OFF:
+		priv->hwts_tx_en = 0;
+		break;
+	case HWTSTAMP_TX_ON:
+		if (!(priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER))
+			return -ERANGE;
+		priv->hwts_tx_en = 1;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (config.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		if (priv->hwts_rx_en) {
+			priv->hwts_rx_en = 0;
+			reset_gfar(netdev);
+		}
+		break;
+	default:
+		if (!(priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER))
+			return -ERANGE;
+		if (!priv->hwts_rx_en) {
+			priv->hwts_rx_en = 1;
+			reset_gfar(netdev);
+		}
+		config.rx_filter = HWTSTAMP_FILTER_ALL;
+		break;
+	}
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
+static int gfar_hwtstamp_get(struct net_device *netdev, struct ifreq *ifr)
+{
+	struct hwtstamp_config config;
+	struct gfar_private *priv = netdev_priv(netdev);
+
+	config.flags = 0;
+	config.tx_type = priv->hwts_tx_en ? HWTSTAMP_TX_ON : HWTSTAMP_TX_OFF;
+	config.rx_filter = (priv->hwts_rx_en ?
+			    HWTSTAMP_FILTER_ALL : HWTSTAMP_FILTER_NONE);
+
+	return copy_to_user(ifr->ifr_data, &config, sizeof(config)) ?
+		-EFAULT : 0;
+}
+
+static int gfar_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+{
+	struct phy_device *phydev = dev->phydev;
+
+	if (!netif_running(dev))
+		return -EINVAL;
+
+	if (cmd == SIOCSHWTSTAMP)
+		return gfar_hwtstamp_set(dev, rq);
+	if (cmd == SIOCGHWTSTAMP)
+		return gfar_hwtstamp_get(dev, rq);
+
+	if (!phydev)
+		return -ENODEV;
+
+	return phy_mii_ioctl(phydev, rq, cmd);
+}
+
 /* Interrupt Handler for Transmit complete */
 static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 {
@@ -2767,77 +2287,6 @@ static void gfar_clean_tx_ring(struct gfar_priv_tx_q *tx_queue)
 	netdev_tx_completed_queue(txq, howmany, bytes_sent);
 }
 
-static bool gfar_new_page(struct gfar_priv_rx_q *rxq, struct gfar_rx_buff *rxb)
-{
-	struct page *page;
-	dma_addr_t addr;
-
-	page = dev_alloc_page();
-	if (unlikely(!page))
-		return false;
-
-	addr = dma_map_page(rxq->dev, page, 0, PAGE_SIZE, DMA_FROM_DEVICE);
-	if (unlikely(dma_mapping_error(rxq->dev, addr))) {
-		__free_page(page);
-
-		return false;
-	}
-
-	rxb->dma = addr;
-	rxb->page = page;
-	rxb->page_offset = 0;
-
-	return true;
-}
-
-static void gfar_rx_alloc_err(struct gfar_priv_rx_q *rx_queue)
-{
-	struct gfar_private *priv = netdev_priv(rx_queue->ndev);
-	struct gfar_extra_stats *estats = &priv->extra_stats;
-
-	netdev_err(rx_queue->ndev, "Can't alloc RX buffers\n");
-	atomic64_inc(&estats->rx_alloc_err);
-}
-
-static void gfar_alloc_rx_buffs(struct gfar_priv_rx_q *rx_queue,
-				int alloc_cnt)
-{
-	struct rxbd8 *bdp;
-	struct gfar_rx_buff *rxb;
-	int i;
-
-	i = rx_queue->next_to_use;
-	bdp = &rx_queue->rx_bd_base[i];
-	rxb = &rx_queue->rx_buff[i];
-
-	while (alloc_cnt--) {
-		/* try reuse page */
-		if (unlikely(!rxb->page)) {
-			if (unlikely(!gfar_new_page(rx_queue, rxb))) {
-				gfar_rx_alloc_err(rx_queue);
-				break;
-			}
-		}
-
-		/* Setup the new RxBD */
-		gfar_init_rxbdp(rx_queue, bdp,
-				rxb->dma + rxb->page_offset + RXBUF_ALIGNMENT);
-
-		/* Update to the next pointer */
-		bdp++;
-		rxb++;
-
-		if (unlikely(++i == rx_queue->rx_ring_size)) {
-			i = 0;
-			bdp = rx_queue->rx_bd_base;
-			rxb = rx_queue->rx_buff;
-		}
-	}
-
-	rx_queue->next_to_use = i;
-	rx_queue->next_to_alloc = i;
-}
-
 static void count_errors(u32 lstatus, struct net_device *ndev)
 {
 	struct gfar_private *priv = netdev_priv(ndev);
@@ -3327,6 +2776,98 @@ static int gfar_poll_tx(struct napi_struct *napi, int budget)
 	return 0;
 }
 
+/* GFAR error interrupt handler */
+static irqreturn_t gfar_error(int irq, void *grp_id)
+{
+	struct gfar_priv_grp *gfargrp = grp_id;
+	struct gfar __iomem *regs = gfargrp->regs;
+	struct gfar_private *priv= gfargrp->priv;
+	struct net_device *dev = priv->ndev;
+
+	/* Save ievent for future reference */
+	u32 events = gfar_read(&regs->ievent);
+
+	/* Clear IEVENT */
+	gfar_write(&regs->ievent, events & IEVENT_ERR_MASK);
+
+	/* Magic Packet is not an error. */
+	if ((priv->device_flags & FSL_GIANFAR_DEV_HAS_MAGIC_PACKET) &&
+	    (events & IEVENT_MAG))
+		events &= ~IEVENT_MAG;
+
+	/* Hmm... */
+	if (netif_msg_rx_err(priv) || netif_msg_tx_err(priv))
+		netdev_dbg(dev,
+			   "error interrupt (ievent=0x%08x imask=0x%08x)\n",
+			   events, gfar_read(&regs->imask));
+
+	/* Update the error counters */
+	if (events & IEVENT_TXE) {
+		dev->stats.tx_errors++;
+
+		if (events & IEVENT_LC)
+			dev->stats.tx_window_errors++;
+		if (events & IEVENT_CRL)
+			dev->stats.tx_aborted_errors++;
+		if (events & IEVENT_XFUN) {
+			netif_dbg(priv, tx_err, dev,
+				  "TX FIFO underrun, packet dropped\n");
+			dev->stats.tx_dropped++;
+			atomic64_inc(&priv->extra_stats.tx_underrun);
+
+			schedule_work(&priv->reset_task);
+		}
+		netif_dbg(priv, tx_err, dev, "Transmit Error\n");
+	}
+	if (events & IEVENT_BSY) {
+		dev->stats.rx_over_errors++;
+		atomic64_inc(&priv->extra_stats.rx_bsy);
+
+		netif_dbg(priv, rx_err, dev, "busy error (rstat: %x)\n",
+			  gfar_read(&regs->rstat));
+	}
+	if (events & IEVENT_BABR) {
+		dev->stats.rx_errors++;
+		atomic64_inc(&priv->extra_stats.rx_babr);
+
+		netif_dbg(priv, rx_err, dev, "babbling RX error\n");
+	}
+	if (events & IEVENT_EBERR) {
+		atomic64_inc(&priv->extra_stats.eberr);
+		netif_dbg(priv, rx_err, dev, "bus error\n");
+	}
+	if (events & IEVENT_RXC)
+		netif_dbg(priv, rx_status, dev, "control frame\n");
+
+	if (events & IEVENT_BABT) {
+		atomic64_inc(&priv->extra_stats.tx_babt);
+		netif_dbg(priv, tx_err, dev, "babbling TX error\n");
+	}
+	return IRQ_HANDLED;
+}
+
+/* The interrupt handler for devices with one interrupt */
+static irqreturn_t gfar_interrupt(int irq, void *grp_id)
+{
+	struct gfar_priv_grp *gfargrp = grp_id;
+
+	/* Save ievent for future reference */
+	u32 events = gfar_read(&gfargrp->regs->ievent);
+
+	/* Check for reception */
+	if (events & IEVENT_RX_MASK)
+		gfar_receive(irq, grp_id);
+
+	/* Check for transmit completion */
+	if (events & IEVENT_TX_MASK)
+		gfar_transmit(irq, grp_id);
+
+	/* Check for errors */
+	if (events & IEVENT_ERR_MASK)
+		gfar_error(irq, grp_id);
+
+	return IRQ_HANDLED;
+}
 
 #ifdef CONFIG_NET_POLL_CONTROLLER
 /* Polling 'interrupt' - used by things like netconsole to send skbs
@@ -3363,44 +2904,154 @@ static void gfar_netpoll(struct net_device *dev)
 }
 #endif
 
-/* The interrupt handler for devices with one interrupt */
-static irqreturn_t gfar_interrupt(int irq, void *grp_id)
+static void free_grp_irqs(struct gfar_priv_grp *grp)
 {
-	struct gfar_priv_grp *gfargrp = grp_id;
-
-	/* Save ievent for future reference */
-	u32 events = gfar_read(&gfargrp->regs->ievent);
-
-	/* Check for reception */
-	if (events & IEVENT_RX_MASK)
-		gfar_receive(irq, grp_id);
-
-	/* Check for transmit completion */
-	if (events & IEVENT_TX_MASK)
-		gfar_transmit(irq, grp_id);
-
-	/* Check for errors */
-	if (events & IEVENT_ERR_MASK)
-		gfar_error(irq, grp_id);
-
-	return IRQ_HANDLED;
+	free_irq(gfar_irq(grp, TX)->irq, grp);
+	free_irq(gfar_irq(grp, RX)->irq, grp);
+	free_irq(gfar_irq(grp, ER)->irq, grp);
 }
 
-/* Called every time the controller might need to be made
- * aware of new link state.  The PHY code conveys this
- * information through variables in the phydev structure, and this
- * function converts those variables into the appropriate
- * register values, and can bring down the device if needed.
+static int register_grp_irqs(struct gfar_priv_grp *grp)
+{
+	struct gfar_private *priv = grp->priv;
+	struct net_device *dev = priv->ndev;
+	int err;
+
+	/* If the device has multiple interrupts, register for
+	 * them.  Otherwise, only register for the one
+	 */
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_MULTI_INTR) {
+		/* Install our interrupt handlers for Error,
+		 * Transmit, and Receive
+		 */
+		err = request_irq(gfar_irq(grp, ER)->irq, gfar_error, 0,
+				  gfar_irq(grp, ER)->name, grp);
+		if (err < 0) {
+			netif_err(priv, intr, dev, "Can't get IRQ %d\n",
+				  gfar_irq(grp, ER)->irq);
+
+			goto err_irq_fail;
+		}
+		enable_irq_wake(gfar_irq(grp, ER)->irq);
+
+		err = request_irq(gfar_irq(grp, TX)->irq, gfar_transmit, 0,
+				  gfar_irq(grp, TX)->name, grp);
+		if (err < 0) {
+			netif_err(priv, intr, dev, "Can't get IRQ %d\n",
+				  gfar_irq(grp, TX)->irq);
+			goto tx_irq_fail;
+		}
+		err = request_irq(gfar_irq(grp, RX)->irq, gfar_receive, 0,
+				  gfar_irq(grp, RX)->name, grp);
+		if (err < 0) {
+			netif_err(priv, intr, dev, "Can't get IRQ %d\n",
+				  gfar_irq(grp, RX)->irq);
+			goto rx_irq_fail;
+		}
+		enable_irq_wake(gfar_irq(grp, RX)->irq);
+
+	} else {
+		err = request_irq(gfar_irq(grp, TX)->irq, gfar_interrupt, 0,
+				  gfar_irq(grp, TX)->name, grp);
+		if (err < 0) {
+			netif_err(priv, intr, dev, "Can't get IRQ %d\n",
+				  gfar_irq(grp, TX)->irq);
+			goto err_irq_fail;
+		}
+		enable_irq_wake(gfar_irq(grp, TX)->irq);
+	}
+
+	return 0;
+
+rx_irq_fail:
+	free_irq(gfar_irq(grp, TX)->irq, grp);
+tx_irq_fail:
+	free_irq(gfar_irq(grp, ER)->irq, grp);
+err_irq_fail:
+	return err;
+
+}
+
+static void gfar_free_irq(struct gfar_private *priv)
+{
+	int i;
+
+	/* Free the IRQs */
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_MULTI_INTR) {
+		for (i = 0; i < priv->num_grps; i++)
+			free_grp_irqs(&priv->gfargrp[i]);
+	} else {
+		for (i = 0; i < priv->num_grps; i++)
+			free_irq(gfar_irq(&priv->gfargrp[i], TX)->irq,
+				 &priv->gfargrp[i]);
+	}
+}
+
+static int gfar_request_irq(struct gfar_private *priv)
+{
+	int err, i, j;
+
+	for (i = 0; i < priv->num_grps; i++) {
+		err = register_grp_irqs(&priv->gfargrp[i]);
+		if (err) {
+			for (j = 0; j < i; j++)
+				free_grp_irqs(&priv->gfargrp[j]);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
+/* Called when something needs to use the ethernet device
+ * Returns 0 for success.
  */
-static void adjust_link(struct net_device *dev)
+static int gfar_enet_open(struct net_device *dev)
 {
 	struct gfar_private *priv = netdev_priv(dev);
-	struct phy_device *phydev = dev->phydev;
+	int err;
 
-	if (unlikely(phydev->link != priv->oldlink ||
-		     (phydev->link && (phydev->duplex != priv->oldduplex ||
-				       phydev->speed != priv->oldspeed))))
-		gfar_update_link_state(priv);
+	err = init_phy(dev);
+	if (err)
+		return err;
+
+	err = gfar_request_irq(priv);
+	if (err)
+		return err;
+
+	err = startup_gfar(dev);
+	if (err)
+		return err;
+
+	return err;
+}
+
+/* Stops the kernel queue, and halts the controller */
+static int gfar_close(struct net_device *dev)
+{
+	struct gfar_private *priv = netdev_priv(dev);
+
+	cancel_work_sync(&priv->reset_task);
+	stop_gfar(dev);
+
+	/* Disconnect from the PHY */
+	phy_disconnect(dev->phydev);
+
+	gfar_free_irq(priv);
+
+	return 0;
+}
+
+/* Clears each of the exact match registers to zero, so they
+ * don't interfere with normal reception
+ */
+static void gfar_clear_exact_match(struct net_device *dev)
+{
+	int idx;
+	static const u8 zero_arr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
+
+	for (idx = 1; idx < GFAR_EM_NUM + 1; idx++)
+		gfar_set_mac_for_addr(dev, idx, zero_arr);
 }
 
 /* Update the hash table based on the current list of multicast
@@ -3494,274 +3145,582 @@ static void gfar_set_multi(struct net_device *dev)
 	}
 }
 
-
-/* Clears each of the exact match registers to zero, so they
- * don't interfere with normal reception
- */
-static void gfar_clear_exact_match(struct net_device *dev)
+void gfar_mac_reset(struct gfar_private *priv)
 {
-	int idx;
-	static const u8 zero_arr[ETH_ALEN] = {0, 0, 0, 0, 0, 0};
-
-	for (idx = 1; idx < GFAR_EM_NUM + 1; idx++)
-		gfar_set_mac_for_addr(dev, idx, zero_arr);
-}
-
-/* Set the appropriate hash bit for the given addr */
-/* The algorithm works like so:
- * 1) Take the Destination Address (ie the multicast address), and
- * do a CRC on it (little endian), and reverse the bits of the
- * result.
- * 2) Use the 8 most significant bits as a hash into a 256-entry
- * table.  The table is controlled through 8 32-bit registers:
- * gaddr0-7.  gaddr0's MSB is entry 0, and gaddr7's LSB is
- * gaddr7.  This means that the 3 most significant bits in the
- * hash index which gaddr register to use, and the 5 other bits
- * indicate which bit (assuming an IBM numbering scheme, which
- * for PowerPC (tm) is usually the case) in the register holds
- * the entry.
- */
-static void gfar_set_hash_for_addr(struct net_device *dev, u8 *addr)
-{
-	u32 tempval;
-	struct gfar_private *priv = netdev_priv(dev);
-	u32 result = ether_crc(ETH_ALEN, addr);
-	int width = priv->hash_width;
-	u8 whichbit = (result >> (32 - width)) & 0x1f;
-	u8 whichreg = result >> (32 - width + 5);
-	u32 value = (1 << (31-whichbit));
-
-	tempval = gfar_read(priv->hash_regs[whichreg]);
-	tempval |= value;
-	gfar_write(priv->hash_regs[whichreg], tempval);
-}
-
-
-/* There are multiple MAC Address register pairs on some controllers
- * This function sets the numth pair to a given address
- */
-static void gfar_set_mac_for_addr(struct net_device *dev, int num,
-				  const u8 *addr)
-{
-	struct gfar_private *priv = netdev_priv(dev);
 	struct gfar __iomem *regs = priv->gfargrp[0].regs;
 	u32 tempval;
-	u32 __iomem *macptr = &regs->macstnaddr1;
 
-	macptr += num*2;
+	/* Reset MAC layer */
+	gfar_write(&regs->maccfg1, MACCFG1_SOFT_RESET);
 
-	/* For a station address of 0x12345678ABCD in transmission
-	 * order (BE), MACnADDR1 is set to 0xCDAB7856 and
-	 * MACnADDR2 is set to 0x34120000.
+	/* We need to delay at least 3 TX clocks */
+	udelay(3);
+
+	/* the soft reset bit is not self-resetting, so we need to
+	 * clear it before resuming normal operation
 	 */
-	tempval = (addr[5] << 24) | (addr[4] << 16) |
-		  (addr[3] << 8)  |  addr[2];
+	gfar_write(&regs->maccfg1, 0);
 
-	gfar_write(macptr, tempval);
+	udelay(3);
 
-	tempval = (addr[1] << 24) | (addr[0] << 16);
+	gfar_rx_offload_en(priv);
 
-	gfar_write(macptr+1, tempval);
+	/* Initialize the max receive frame/buffer lengths */
+	gfar_write(&regs->maxfrm, GFAR_JUMBO_FRAME_SIZE);
+	gfar_write(&regs->mrblr, GFAR_RXB_SIZE);
+
+	/* Initialize the Minimum Frame Length Register */
+	gfar_write(&regs->minflr, MINFLR_INIT_SETTINGS);
+
+	/* Initialize MACCFG2. */
+	tempval = MACCFG2_INIT_SETTINGS;
+
+	/* eTSEC74 erratum: Rx frames of length MAXFRM or MAXFRM-1
+	 * are marked as truncated.  Avoid this by MACCFG2[Huge Frame]=1,
+	 * and by checking RxBD[LG] and discarding larger than MAXFRM.
+	 */
+	if (gfar_has_errata(priv, GFAR_ERRATA_74))
+		tempval |= MACCFG2_HUGEFRAME | MACCFG2_LENGTHCHECK;
+
+	gfar_write(&regs->maccfg2, tempval);
+
+	/* Clear mac addr hash registers */
+	gfar_write(&regs->igaddr0, 0);
+	gfar_write(&regs->igaddr1, 0);
+	gfar_write(&regs->igaddr2, 0);
+	gfar_write(&regs->igaddr3, 0);
+	gfar_write(&regs->igaddr4, 0);
+	gfar_write(&regs->igaddr5, 0);
+	gfar_write(&regs->igaddr6, 0);
+	gfar_write(&regs->igaddr7, 0);
+
+	gfar_write(&regs->gaddr0, 0);
+	gfar_write(&regs->gaddr1, 0);
+	gfar_write(&regs->gaddr2, 0);
+	gfar_write(&regs->gaddr3, 0);
+	gfar_write(&regs->gaddr4, 0);
+	gfar_write(&regs->gaddr5, 0);
+	gfar_write(&regs->gaddr6, 0);
+	gfar_write(&regs->gaddr7, 0);
+
+	if (priv->extended_hash)
+		gfar_clear_exact_match(priv->ndev);
+
+	gfar_mac_rx_config(priv);
+
+	gfar_mac_tx_config(priv);
+
+	gfar_set_mac_address(priv->ndev);
+
+	gfar_set_multi(priv->ndev);
+
+	/* clear ievent and imask before configuring coalescing */
+	gfar_ints_disable(priv);
+
+	/* Configure the coalescing support */
+	gfar_configure_coalescing_all(priv);
 }
 
-/* GFAR error interrupt handler */
-static irqreturn_t gfar_error(int irq, void *grp_id)
-{
-	struct gfar_priv_grp *gfargrp = grp_id;
-	struct gfar __iomem *regs = gfargrp->regs;
-	struct gfar_private *priv= gfargrp->priv;
-	struct net_device *dev = priv->ndev;
-
-	/* Save ievent for future reference */
-	u32 events = gfar_read(&regs->ievent);
-
-	/* Clear IEVENT */
-	gfar_write(&regs->ievent, events & IEVENT_ERR_MASK);
-
-	/* Magic Packet is not an error. */
-	if ((priv->device_flags & FSL_GIANFAR_DEV_HAS_MAGIC_PACKET) &&
-	    (events & IEVENT_MAG))
-		events &= ~IEVENT_MAG;
-
-	/* Hmm... */
-	if (netif_msg_rx_err(priv) || netif_msg_tx_err(priv))
-		netdev_dbg(dev,
-			   "error interrupt (ievent=0x%08x imask=0x%08x)\n",
-			   events, gfar_read(&regs->imask));
-
-	/* Update the error counters */
-	if (events & IEVENT_TXE) {
-		dev->stats.tx_errors++;
-
-		if (events & IEVENT_LC)
-			dev->stats.tx_window_errors++;
-		if (events & IEVENT_CRL)
-			dev->stats.tx_aborted_errors++;
-		if (events & IEVENT_XFUN) {
-			netif_dbg(priv, tx_err, dev,
-				  "TX FIFO underrun, packet dropped\n");
-			dev->stats.tx_dropped++;
-			atomic64_inc(&priv->extra_stats.tx_underrun);
-
-			schedule_work(&priv->reset_task);
-		}
-		netif_dbg(priv, tx_err, dev, "Transmit Error\n");
-	}
-	if (events & IEVENT_BSY) {
-		dev->stats.rx_over_errors++;
-		atomic64_inc(&priv->extra_stats.rx_bsy);
-
-		netif_dbg(priv, rx_err, dev, "busy error (rstat: %x)\n",
-			  gfar_read(&regs->rstat));
-	}
-	if (events & IEVENT_BABR) {
-		dev->stats.rx_errors++;
-		atomic64_inc(&priv->extra_stats.rx_babr);
-
-		netif_dbg(priv, rx_err, dev, "babbling RX error\n");
-	}
-	if (events & IEVENT_EBERR) {
-		atomic64_inc(&priv->extra_stats.eberr);
-		netif_dbg(priv, rx_err, dev, "bus error\n");
-	}
-	if (events & IEVENT_RXC)
-		netif_dbg(priv, rx_status, dev, "control frame\n");
-
-	if (events & IEVENT_BABT) {
-		atomic64_inc(&priv->extra_stats.tx_babt);
-		netif_dbg(priv, tx_err, dev, "babbling TX error\n");
-	}
-	return IRQ_HANDLED;
-}
-
-static u32 gfar_get_flowctrl_cfg(struct gfar_private *priv)
-{
-	struct net_device *ndev = priv->ndev;
-	struct phy_device *phydev = ndev->phydev;
-	u32 val = 0;
-
-	if (!phydev->duplex)
-		return val;
-
-	if (!priv->pause_aneg_en) {
-		if (priv->tx_pause_en)
-			val |= MACCFG1_TX_FLOW;
-		if (priv->rx_pause_en)
-			val |= MACCFG1_RX_FLOW;
-	} else {
-		u16 lcl_adv, rmt_adv;
-		u8 flowctrl;
-		/* get link partner capabilities */
-		rmt_adv = 0;
-		if (phydev->pause)
-			rmt_adv = LPA_PAUSE_CAP;
-		if (phydev->asym_pause)
-			rmt_adv |= LPA_PAUSE_ASYM;
-
-		lcl_adv = linkmode_adv_to_lcl_adv_t(phydev->advertising);
-		flowctrl = mii_resolve_flowctrl_fdx(lcl_adv, rmt_adv);
-		if (flowctrl & FLOW_CTRL_TX)
-			val |= MACCFG1_TX_FLOW;
-		if (flowctrl & FLOW_CTRL_RX)
-			val |= MACCFG1_RX_FLOW;
-	}
-
-	return val;
-}
-
-static noinline void gfar_update_link_state(struct gfar_private *priv)
+static void gfar_hw_init(struct gfar_private *priv)
 {
 	struct gfar __iomem *regs = priv->gfargrp[0].regs;
-	struct net_device *ndev = priv->ndev;
-	struct phy_device *phydev = ndev->phydev;
-	struct gfar_priv_rx_q *rx_queue = NULL;
-	int i;
+	u32 attrs;
 
-	if (unlikely(test_bit(GFAR_RESETTING, &priv->state)))
-		return;
+	/* Stop the DMA engine now, in case it was running before
+	 * (The firmware could have used it, and left it running).
+	 */
+	gfar_halt(priv);
 
-	if (phydev->link) {
-		u32 tempval1 = gfar_read(&regs->maccfg1);
-		u32 tempval = gfar_read(&regs->maccfg2);
-		u32 ecntrl = gfar_read(&regs->ecntrl);
-		u32 tx_flow_oldval = (tempval1 & MACCFG1_TX_FLOW);
+	gfar_mac_reset(priv);
 
-		if (phydev->duplex != priv->oldduplex) {
-			if (!(phydev->duplex))
-				tempval &= ~(MACCFG2_FULL_DUPLEX);
-			else
-				tempval |= MACCFG2_FULL_DUPLEX;
+	/* Zero out the rmon mib registers if it has them */
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_RMON) {
+		memset_io(&(regs->rmon), 0, sizeof(struct rmon_mib));
 
-			priv->oldduplex = phydev->duplex;
-		}
-
-		if (phydev->speed != priv->oldspeed) {
-			switch (phydev->speed) {
-			case 1000:
-				tempval =
-				    ((tempval & ~(MACCFG2_IF)) | MACCFG2_GMII);
-
-				ecntrl &= ~(ECNTRL_R100);
-				break;
-			case 100:
-			case 10:
-				tempval =
-				    ((tempval & ~(MACCFG2_IF)) | MACCFG2_MII);
-
-				/* Reduced mode distinguishes
-				 * between 10 and 100
-				 */
-				if (phydev->speed == SPEED_100)
-					ecntrl |= ECNTRL_R100;
-				else
-					ecntrl &= ~(ECNTRL_R100);
-				break;
-			default:
-				netif_warn(priv, link, priv->ndev,
-					   "Ack!  Speed (%d) is not 10/100/1000!\n",
-					   phydev->speed);
-				break;
-			}
-
-			priv->oldspeed = phydev->speed;
-		}
-
-		tempval1 &= ~(MACCFG1_TX_FLOW | MACCFG1_RX_FLOW);
-		tempval1 |= gfar_get_flowctrl_cfg(priv);
-
-		/* Turn last free buffer recording on */
-		if ((tempval1 & MACCFG1_TX_FLOW) && !tx_flow_oldval) {
-			for (i = 0; i < priv->num_rx_queues; i++) {
-				u32 bdp_dma;
-
-				rx_queue = priv->rx_queue[i];
-				bdp_dma = gfar_rxbd_dma_lastfree(rx_queue);
-				gfar_write(rx_queue->rfbptr, bdp_dma);
-			}
-
-			priv->tx_actual_en = 1;
-		}
-
-		if (unlikely(!(tempval1 & MACCFG1_TX_FLOW) && tx_flow_oldval))
-			priv->tx_actual_en = 0;
-
-		gfar_write(&regs->maccfg1, tempval1);
-		gfar_write(&regs->maccfg2, tempval);
-		gfar_write(&regs->ecntrl, ecntrl);
-
-		if (!priv->oldlink)
-			priv->oldlink = 1;
-
-	} else if (priv->oldlink) {
-		priv->oldlink = 0;
-		priv->oldspeed = 0;
-		priv->oldduplex = -1;
+		/* Mask off the CAM interrupts */
+		gfar_write(&regs->rmon.cam1, 0xffffffff);
+		gfar_write(&regs->rmon.cam2, 0xffffffff);
 	}
 
-	if (netif_msg_link(priv))
-		phy_print_status(phydev);
+	/* Initialize ECNTRL */
+	gfar_write(&regs->ecntrl, ECNTRL_INIT_SETTINGS);
+
+	/* Set the extraction length and index */
+	attrs = ATTRELI_EL(priv->rx_stash_size) |
+		ATTRELI_EI(priv->rx_stash_index);
+
+	gfar_write(&regs->attreli, attrs);
+
+	/* Start with defaults, and add stashing
+	 * depending on driver parameters
+	 */
+	attrs = ATTR_INIT_SETTINGS;
+
+	if (priv->bd_stash_en)
+		attrs |= ATTR_BDSTASH;
+
+	if (priv->rx_stash_size != 0)
+		attrs |= ATTR_BUFSTASH;
+
+	gfar_write(&regs->attr, attrs);
+
+	/* FIFO configs */
+	gfar_write(&regs->fifo_tx_thr, DEFAULT_FIFO_TX_THR);
+	gfar_write(&regs->fifo_tx_starve, DEFAULT_FIFO_TX_STARVE);
+	gfar_write(&regs->fifo_tx_starve_shutoff, DEFAULT_FIFO_TX_STARVE_OFF);
+
+	/* Program the interrupt steering regs, only for MG devices */
+	if (priv->num_grps > 1)
+		gfar_write_isrg(priv);
 }
 
+static const struct net_device_ops gfar_netdev_ops = {
+	.ndo_open = gfar_enet_open,
+	.ndo_start_xmit = gfar_start_xmit,
+	.ndo_stop = gfar_close,
+	.ndo_change_mtu = gfar_change_mtu,
+	.ndo_set_features = gfar_set_features,
+	.ndo_set_rx_mode = gfar_set_multi,
+	.ndo_tx_timeout = gfar_timeout,
+	.ndo_do_ioctl = gfar_ioctl,
+	.ndo_get_stats = gfar_get_stats,
+	.ndo_change_carrier = fixed_phy_change_carrier,
+	.ndo_set_mac_address = gfar_set_mac_addr,
+	.ndo_validate_addr = eth_validate_addr,
+#ifdef CONFIG_NET_POLL_CONTROLLER
+	.ndo_poll_controller = gfar_netpoll,
+#endif
+};
+
+/* Set up the ethernet device structure, private data,
+ * and anything else we need before we start
+ */
+static int gfar_probe(struct platform_device *ofdev)
+{
+	struct device_node *np = ofdev->dev.of_node;
+	struct net_device *dev = NULL;
+	struct gfar_private *priv = NULL;
+	int err = 0, i;
+
+	err = gfar_of_init(ofdev, &dev);
+
+	if (err)
+		return err;
+
+	priv = netdev_priv(dev);
+	priv->ndev = dev;
+	priv->ofdev = ofdev;
+	priv->dev = &ofdev->dev;
+	SET_NETDEV_DEV(dev, &ofdev->dev);
+
+	INIT_WORK(&priv->reset_task, gfar_reset_task);
+
+	platform_set_drvdata(ofdev, priv);
+
+	gfar_detect_errata(priv);
+
+	/* Set the dev->base_addr to the gfar reg region */
+	dev->base_addr = (unsigned long) priv->gfargrp[0].regs;
+
+	/* Fill in the dev structure */
+	dev->watchdog_timeo = TX_TIMEOUT;
+	/* MTU range: 50 - 9586 */
+	dev->mtu = 1500;
+	dev->min_mtu = 50;
+	dev->max_mtu = GFAR_JUMBO_FRAME_SIZE - ETH_HLEN;
+	dev->netdev_ops = &gfar_netdev_ops;
+	dev->ethtool_ops = &gfar_ethtool_ops;
+
+	/* Register for napi ...We are registering NAPI for each grp */
+	for (i = 0; i < priv->num_grps; i++) {
+		if (priv->poll_mode == GFAR_SQ_POLLING) {
+			netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
+				       gfar_poll_rx_sq, GFAR_DEV_WEIGHT);
+			netif_tx_napi_add(dev, &priv->gfargrp[i].napi_tx,
+				       gfar_poll_tx_sq, 2);
+		} else {
+			netif_napi_add(dev, &priv->gfargrp[i].napi_rx,
+				       gfar_poll_rx, GFAR_DEV_WEIGHT);
+			netif_tx_napi_add(dev, &priv->gfargrp[i].napi_tx,
+				       gfar_poll_tx, 2);
+		}
+	}
+
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_CSUM) {
+		dev->hw_features = NETIF_F_IP_CSUM | NETIF_F_SG |
+				   NETIF_F_RXCSUM;
+		dev->features |= NETIF_F_IP_CSUM | NETIF_F_SG |
+				 NETIF_F_RXCSUM | NETIF_F_HIGHDMA;
+	}
+
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_VLAN) {
+		dev->hw_features |= NETIF_F_HW_VLAN_CTAG_TX |
+				    NETIF_F_HW_VLAN_CTAG_RX;
+		dev->features |= NETIF_F_HW_VLAN_CTAG_RX;
+	}
+
+	dev->priv_flags |= IFF_LIVE_ADDR_CHANGE;
+
+	gfar_init_addr_hash_table(priv);
+
+	/* Insert receive time stamps into padding alignment bytes, and
+	 * plus 2 bytes padding to ensure the cpu alignment.
+	 */
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
+		priv->padding = 8 + DEFAULT_PADDING;
+
+	if (dev->features & NETIF_F_IP_CSUM ||
+	    priv->device_flags & FSL_GIANFAR_DEV_HAS_TIMER)
+		dev->needed_headroom = GMAC_FCB_LEN;
+
+	/* Initializing some of the rx/tx queue level parameters */
+	for (i = 0; i < priv->num_tx_queues; i++) {
+		priv->tx_queue[i]->tx_ring_size = DEFAULT_TX_RING_SIZE;
+		priv->tx_queue[i]->num_txbdfree = DEFAULT_TX_RING_SIZE;
+		priv->tx_queue[i]->txcoalescing = DEFAULT_TX_COALESCE;
+		priv->tx_queue[i]->txic = DEFAULT_TXIC;
+	}
+
+	for (i = 0; i < priv->num_rx_queues; i++) {
+		priv->rx_queue[i]->rx_ring_size = DEFAULT_RX_RING_SIZE;
+		priv->rx_queue[i]->rxcoalescing = DEFAULT_RX_COALESCE;
+		priv->rx_queue[i]->rxic = DEFAULT_RXIC;
+	}
+
+	/* Always enable rx filer if available */
+	priv->rx_filer_enable =
+	    (priv->device_flags & FSL_GIANFAR_DEV_HAS_RX_FILER) ? 1 : 0;
+	/* Enable most messages by default */
+	priv->msg_enable = (NETIF_MSG_IFUP << 1 ) - 1;
+	/* use pritority h/w tx queue scheduling for single queue devices */
+	if (priv->num_tx_queues == 1)
+		priv->prio_sched_en = 1;
+
+	set_bit(GFAR_DOWN, &priv->state);
+
+	gfar_hw_init(priv);
+
+	/* Carrier starts down, phylib will bring it up */
+	netif_carrier_off(dev);
+
+	err = register_netdev(dev);
+
+	if (err) {
+		pr_err("%s: Cannot register net device, aborting\n", dev->name);
+		goto register_fail;
+	}
+
+	if (priv->device_flags & FSL_GIANFAR_DEV_HAS_MAGIC_PACKET)
+		priv->wol_supported |= GFAR_WOL_MAGIC;
+
+	if ((priv->device_flags & FSL_GIANFAR_DEV_HAS_WAKE_ON_FILER) &&
+	    priv->rx_filer_enable)
+		priv->wol_supported |= GFAR_WOL_FILER_UCAST;
+
+	device_set_wakeup_capable(&ofdev->dev, priv->wol_supported);
+
+	/* fill out IRQ number and name fields */
+	for (i = 0; i < priv->num_grps; i++) {
+		struct gfar_priv_grp *grp = &priv->gfargrp[i];
+		if (priv->device_flags & FSL_GIANFAR_DEV_HAS_MULTI_INTR) {
+			sprintf(gfar_irq(grp, TX)->name, "%s%s%c%s",
+				dev->name, "_g", '0' + i, "_tx");
+			sprintf(gfar_irq(grp, RX)->name, "%s%s%c%s",
+				dev->name, "_g", '0' + i, "_rx");
+			sprintf(gfar_irq(grp, ER)->name, "%s%s%c%s",
+				dev->name, "_g", '0' + i, "_er");
+		} else
+			strcpy(gfar_irq(grp, TX)->name, dev->name);
+	}
+
+	/* Initialize the filer table */
+	gfar_init_filer_table(priv);
+
+	/* Print out the device info */
+	netdev_info(dev, "mac: %pM\n", dev->dev_addr);
+
+	/* Even more device info helps when determining which kernel
+	 * provided which set of benchmarks.
+	 */
+	netdev_info(dev, "Running with NAPI enabled\n");
+	for (i = 0; i < priv->num_rx_queues; i++)
+		netdev_info(dev, "RX BD ring size for Q[%d]: %d\n",
+			    i, priv->rx_queue[i]->rx_ring_size);
+	for (i = 0; i < priv->num_tx_queues; i++)
+		netdev_info(dev, "TX BD ring size for Q[%d]: %d\n",
+			    i, priv->tx_queue[i]->tx_ring_size);
+
+	return 0;
+
+register_fail:
+	if (of_phy_is_fixed_link(np))
+		of_phy_deregister_fixed_link(np);
+	unmap_group_regs(priv);
+	gfar_free_rx_queues(priv);
+	gfar_free_tx_queues(priv);
+	of_node_put(priv->phy_node);
+	of_node_put(priv->tbi_node);
+	free_gfar_dev(priv);
+	return err;
+}
+
+static int gfar_remove(struct platform_device *ofdev)
+{
+	struct gfar_private *priv = platform_get_drvdata(ofdev);
+	struct device_node *np = ofdev->dev.of_node;
+
+	of_node_put(priv->phy_node);
+	of_node_put(priv->tbi_node);
+
+	unregister_netdev(priv->ndev);
+
+	if (of_phy_is_fixed_link(np))
+		of_phy_deregister_fixed_link(np);
+
+	unmap_group_regs(priv);
+	gfar_free_rx_queues(priv);
+	gfar_free_tx_queues(priv);
+	free_gfar_dev(priv);
+
+	return 0;
+}
+
+#ifdef CONFIG_PM
+
+static void __gfar_filer_disable(struct gfar_private *priv)
+{
+	struct gfar __iomem *regs = priv->gfargrp[0].regs;
+	u32 temp;
+
+	temp = gfar_read(&regs->rctrl);
+	temp &= ~(RCTRL_FILREN | RCTRL_PRSDEP_INIT);
+	gfar_write(&regs->rctrl, temp);
+}
+
+static void __gfar_filer_enable(struct gfar_private *priv)
+{
+	struct gfar __iomem *regs = priv->gfargrp[0].regs;
+	u32 temp;
+
+	temp = gfar_read(&regs->rctrl);
+	temp |= RCTRL_FILREN | RCTRL_PRSDEP_INIT;
+	gfar_write(&regs->rctrl, temp);
+}
+
+/* Filer rules implementing wol capabilities */
+static void gfar_filer_config_wol(struct gfar_private *priv)
+{
+	unsigned int i;
+	u32 rqfcr;
+
+	__gfar_filer_disable(priv);
+
+	/* clear the filer table, reject any packet by default */
+	rqfcr = RQFCR_RJE | RQFCR_CMP_MATCH;
+	for (i = 0; i <= MAX_FILER_IDX; i++)
+		gfar_write_filer(priv, i, rqfcr, 0);
+
+	i = 0;
+	if (priv->wol_opts & GFAR_WOL_FILER_UCAST) {
+		/* unicast packet, accept it */
+		struct net_device *ndev = priv->ndev;
+		/* get the default rx queue index */
+		u8 qindex = (u8)priv->gfargrp[0].rx_queue->qindex;
+		u32 dest_mac_addr = (ndev->dev_addr[0] << 16) |
+				    (ndev->dev_addr[1] << 8) |
+				     ndev->dev_addr[2];
+
+		rqfcr = (qindex << 10) | RQFCR_AND |
+			RQFCR_CMP_EXACT | RQFCR_PID_DAH;
+
+		gfar_write_filer(priv, i++, rqfcr, dest_mac_addr);
+
+		dest_mac_addr = (ndev->dev_addr[3] << 16) |
+				(ndev->dev_addr[4] << 8) |
+				 ndev->dev_addr[5];
+		rqfcr = (qindex << 10) | RQFCR_GPI |
+			RQFCR_CMP_EXACT | RQFCR_PID_DAL;
+		gfar_write_filer(priv, i++, rqfcr, dest_mac_addr);
+	}
+
+	__gfar_filer_enable(priv);
+}
+
+static void gfar_filer_restore_table(struct gfar_private *priv)
+{
+	u32 rqfcr, rqfpr;
+	unsigned int i;
+
+	__gfar_filer_disable(priv);
+
+	for (i = 0; i <= MAX_FILER_IDX; i++) {
+		rqfcr = priv->ftp_rqfcr[i];
+		rqfpr = priv->ftp_rqfpr[i];
+		gfar_write_filer(priv, i, rqfcr, rqfpr);
+	}
+
+	__gfar_filer_enable(priv);
+}
+
+/* gfar_start() for Rx only and with the FGPI filer interrupt enabled */
+static void gfar_start_wol_filer(struct gfar_private *priv)
+{
+	struct gfar __iomem *regs = priv->gfargrp[0].regs;
+	u32 tempval;
+	int i = 0;
+
+	/* Enable Rx hw queues */
+	gfar_write(&regs->rqueue, priv->rqueue);
+
+	/* Initialize DMACTRL to have WWR and WOP */
+	tempval = gfar_read(&regs->dmactrl);
+	tempval |= DMACTRL_INIT_SETTINGS;
+	gfar_write(&regs->dmactrl, tempval);
+
+	/* Make sure we aren't stopped */
+	tempval = gfar_read(&regs->dmactrl);
+	tempval &= ~DMACTRL_GRS;
+	gfar_write(&regs->dmactrl, tempval);
+
+	for (i = 0; i < priv->num_grps; i++) {
+		regs = priv->gfargrp[i].regs;
+		/* Clear RHLT, so that the DMA starts polling now */
+		gfar_write(&regs->rstat, priv->gfargrp[i].rstat);
+		/* enable the Filer General Purpose Interrupt */
+		gfar_write(&regs->imask, IMASK_FGPI);
+	}
+
+	/* Enable Rx DMA */
+	tempval = gfar_read(&regs->maccfg1);
+	tempval |= MACCFG1_RX_EN;
+	gfar_write(&regs->maccfg1, tempval);
+}
+
+static int gfar_suspend(struct device *dev)
+{
+	struct gfar_private *priv = dev_get_drvdata(dev);
+	struct net_device *ndev = priv->ndev;
+	struct gfar __iomem *regs = priv->gfargrp[0].regs;
+	u32 tempval;
+	u16 wol = priv->wol_opts;
+
+	if (!netif_running(ndev))
+		return 0;
+
+	disable_napi(priv);
+	netif_tx_lock(ndev);
+	netif_device_detach(ndev);
+	netif_tx_unlock(ndev);
+
+	gfar_halt(priv);
+
+	if (wol & GFAR_WOL_MAGIC) {
+		/* Enable interrupt on Magic Packet */
+		gfar_write(&regs->imask, IMASK_MAG);
+
+		/* Enable Magic Packet mode */
+		tempval = gfar_read(&regs->maccfg2);
+		tempval |= MACCFG2_MPEN;
+		gfar_write(&regs->maccfg2, tempval);
+
+		/* re-enable the Rx block */
+		tempval = gfar_read(&regs->maccfg1);
+		tempval |= MACCFG1_RX_EN;
+		gfar_write(&regs->maccfg1, tempval);
+
+	} else if (wol & GFAR_WOL_FILER_UCAST) {
+		gfar_filer_config_wol(priv);
+		gfar_start_wol_filer(priv);
+
+	} else {
+		phy_stop(ndev->phydev);
+	}
+
+	return 0;
+}
+
+static int gfar_resume(struct device *dev)
+{
+	struct gfar_private *priv = dev_get_drvdata(dev);
+	struct net_device *ndev = priv->ndev;
+	struct gfar __iomem *regs = priv->gfargrp[0].regs;
+	u32 tempval;
+	u16 wol = priv->wol_opts;
+
+	if (!netif_running(ndev))
+		return 0;
+
+	if (wol & GFAR_WOL_MAGIC) {
+		/* Disable Magic Packet mode */
+		tempval = gfar_read(&regs->maccfg2);
+		tempval &= ~MACCFG2_MPEN;
+		gfar_write(&regs->maccfg2, tempval);
+
+	} else if (wol & GFAR_WOL_FILER_UCAST) {
+		/* need to stop rx only, tx is already down */
+		gfar_halt(priv);
+		gfar_filer_restore_table(priv);
+
+	} else {
+		phy_start(ndev->phydev);
+	}
+
+	gfar_start(priv);
+
+	netif_device_attach(ndev);
+	enable_napi(priv);
+
+	return 0;
+}
+
+static int gfar_restore(struct device *dev)
+{
+	struct gfar_private *priv = dev_get_drvdata(dev);
+	struct net_device *ndev = priv->ndev;
+
+	if (!netif_running(ndev)) {
+		netif_device_attach(ndev);
+
+		return 0;
+	}
+
+	gfar_init_bds(ndev);
+
+	gfar_mac_reset(priv);
+
+	gfar_init_tx_rx_base(priv);
+
+	gfar_start(priv);
+
+	priv->oldlink = 0;
+	priv->oldspeed = 0;
+	priv->oldduplex = -1;
+
+	if (ndev->phydev)
+		phy_start(ndev->phydev);
+
+	netif_device_attach(ndev);
+	enable_napi(priv);
+
+	return 0;
+}
+
+static const struct dev_pm_ops gfar_pm_ops = {
+	.suspend = gfar_suspend,
+	.resume = gfar_resume,
+	.freeze = gfar_suspend,
+	.thaw = gfar_resume,
+	.restore = gfar_restore,
+};
+
+#define GFAR_PM_OPS (&gfar_pm_ops)
+
+#else
+
+#define GFAR_PM_OPS NULL
+
+#endif
+
 static const struct of_device_id gfar_match[] =
 {
 	{
diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index f2af96349c7b..f058594a67fb 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -1326,16 +1326,9 @@ static inline u32 gfar_rxbd_dma_lastfree(struct gfar_priv_rx_q *rxq)
 	return bdp_dma;
 }
 
-irqreturn_t gfar_receive(int irq, void *dev_id);
 int startup_gfar(struct net_device *dev);
 void stop_gfar(struct net_device *dev);
-void reset_gfar(struct net_device *dev);
 void gfar_mac_reset(struct gfar_private *priv);
-void gfar_halt(struct gfar_private *priv);
-void gfar_start(struct gfar_private *priv);
-void gfar_phy_test(struct mii_bus *bus, struct phy_device *phydev, int enable,
-		   u32 regnum, u32 read);
-void gfar_configure_coalescing_all(struct gfar_private *priv);
 int gfar_set_features(struct net_device *dev, netdev_features_t features);
 
 extern const struct ethtool_ops gfar_ethtool_ops;
diff --git a/drivers/net/ethernet/freescale/gianfar_ethtool.c b/drivers/net/ethernet/freescale/gianfar_ethtool.c
index 3433b46b90c1..3c8e4e2efc07 100644
--- a/drivers/net/ethernet/freescale/gianfar_ethtool.c
+++ b/drivers/net/ethernet/freescale/gianfar_ethtool.c
@@ -45,19 +45,6 @@
 
 #define GFAR_MAX_COAL_USECS 0xffff
 #define GFAR_MAX_COAL_FRAMES 0xff
-static void gfar_fill_stats(struct net_device *dev, struct ethtool_stats *dummy,
-			    u64 *buf);
-static void gfar_gstrings(struct net_device *dev, u32 stringset, u8 * buf);
-static int gfar_gcoalesce(struct net_device *dev,
-			  struct ethtool_coalesce *cvals);
-static int gfar_scoalesce(struct net_device *dev,
-			  struct ethtool_coalesce *cvals);
-static void gfar_gringparam(struct net_device *dev,
-			    struct ethtool_ringparam *rvals);
-static int gfar_sringparam(struct net_device *dev,
-			   struct ethtool_ringparam *rvals);
-static void gfar_gdrvinfo(struct net_device *dev,
-			  struct ethtool_drvinfo *drvinfo);
 
 static const char stat_gstrings[][ETH_GSTRING_LEN] = {
 	/* extra stats */
-- 
2.23.0


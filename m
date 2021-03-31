Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E936B34FB72
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 10:22:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbhCaIVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 04:21:32 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15116 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbhCaIVR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Mar 2021 04:21:17 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4F9K3L1ff4z1BFvT;
        Wed, 31 Mar 2021 16:19:10 +0800 (CST)
Received: from localhost.localdomain (10.67.165.24) by
 DGGEMS412-HUB.china.huawei.com (10.3.19.212) with Microsoft SMTP Server id
 14.3.498.0; Wed, 31 Mar 2021 16:21:06 +0800
From:   Weihang Li <liweihang@huawei.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <linuxarm@huawei.com>,
        Yixing Liu <liuyixing1@huawei.com>,
        Weihang Li <liweihang@huawei.com>
Subject: [PATCH net-next 6/7] net: toshiba: fix the trailing format of some block comments
Date:   Wed, 31 Mar 2021 16:18:33 +0800
Message-ID: <1617178714-14031-7-git-send-email-liweihang@huawei.com>
X-Mailer: git-send-email 2.8.1
In-Reply-To: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
References: <1617178714-14031-1-git-send-email-liweihang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.67.165.24]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yixing Liu <liuyixing1@huawei.com>

Use a trailling */ on a separate line for block comments.

Signed-off-by: Yixing Liu <liuyixing1@huawei.com>
Signed-off-by: Weihang Li <liweihang@huawei.com>
---
 drivers/net/ethernet/toshiba/spider_net.c | 42 ++++++++++++++++++++-----------
 drivers/net/ethernet/toshiba/tc35815.c    |  3 ++-
 2 files changed, 30 insertions(+), 15 deletions(-)

diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index d5a75ef..226a766 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -146,7 +146,8 @@ spider_net_read_phy(struct net_device *netdev, int mii_id, int reg)
 
 	/* we don't use semaphores to wait for an SPIDER_NET_GPROPCMPINT
 	 * interrupt, as we poll for the completion of the read operation
-	 * in spider_net_read_phy. Should take about 50 us */
+	 * in spider_net_read_phy. Should take about 50 us
+	 */
 	do {
 		readvalue = spider_net_read_reg(card, SPIDER_NET_GPCROPCMD);
 	} while (readvalue & SPIDER_NET_GPREXEC);
@@ -387,7 +388,8 @@ spider_net_prepare_rx_descr(struct spider_net_card *card,
 		(~(SPIDER_NET_RXBUF_ALIGN - 1));
 
 	/* and we need to have it 128 byte aligned, therefore we allocate a
-	 * bit more */
+	 * bit more
+	 */
 	/* allocate an skb */
 	descr->skb = netdev_alloc_skb(card->netdev,
 				      bufsize + SPIDER_NET_RXBUF_ALIGN - 1);
@@ -488,7 +490,8 @@ spider_net_refill_rx_chain(struct spider_net_card *card)
 	/* one context doing the refill (and a second context seeing that
 	 * and omitting it) is ok. If called by NAPI, we'll be called again
 	 * as spider_net_decode_one_descr is called several times. If some
-	 * interrupt calls us, the NAPI is about to clean up anyway. */
+	 * interrupt calls us, the NAPI is about to clean up anyway.
+	 */
 	if (!spin_trylock_irqsave(&chain->lock, flags))
 		return;
 
@@ -523,14 +526,16 @@ spider_net_alloc_rx_skbs(struct spider_net_card *card)
 
 	/* Put at least one buffer into the chain. if this fails,
 	 * we've got a problem. If not, spider_net_refill_rx_chain
-	 * will do the rest at the end of this function. */
+	 * will do the rest at the end of this function.
+	 */
 	if (spider_net_prepare_rx_descr(card, chain->head))
 		goto error;
 	else
 		chain->head = chain->head->next;
 
 	/* This will allocate the rest of the rx buffers;
-	 * if not, it's business as usual later on. */
+	 * if not, it's business as usual later on.
+	 */
 	spider_net_refill_rx_chain(card);
 	spider_net_enable_rxdmac(card);
 	return 0;
@@ -706,7 +711,8 @@ spider_net_set_low_watermark(struct spider_net_card *card)
 	int i;
 
 	/* Measure the length of the queue. Measurement does not
-	 * need to be precise -- does not need a lock. */
+	 * need to be precise -- does not need a lock.
+	 */
 	while (descr != card->tx_chain.head) {
 		status = descr->hwdescr->dmac_cmd_status & SPIDER_NET_DESCR_NOT_IN_USE;
 		if (status == SPIDER_NET_DESCR_NOT_IN_USE)
@@ -786,7 +792,8 @@ spider_net_release_tx_chain(struct spider_net_card *card, int brutal)
 
 			/* fallthrough, if we release the descriptors
 			 * brutally (then we don't care about
-			 * SPIDER_NET_DESCR_CARDOWNED) */
+			 * SPIDER_NET_DESCR_CARDOWNED)
+			 */
 			fallthrough;
 
 		case SPIDER_NET_DESCR_RESPONSE_ERROR:
@@ -948,7 +955,8 @@ spider_net_pass_skb_up(struct spider_net_descr *descr,
 	skb_put(skb, hwdescr->valid_size);
 
 	/* the card seems to add 2 bytes of junk in front
-	 * of the ethernet frame */
+	 * of the ethernet frame
+	 */
 #define SPIDER_MISALIGN		2
 	skb_pull(skb, SPIDER_MISALIGN);
 	skb->protocol = eth_type_trans(skb, netdev);
@@ -1382,7 +1390,8 @@ spider_net_handle_error_irq(struct spider_net_card *card, u32 status_reg,
 		/* PHY read operation completed */
 		/* we don't use semaphores, as we poll for the completion
 		 * of the read operation in spider_net_read_phy. Should take
-		 * about 50 us */
+		 * about 50 us
+		 */
 		show_error = 0;
 		break;
 	case SPIDER_NET_GPWFFINT:
@@ -1450,7 +1459,8 @@ spider_net_handle_error_irq(struct spider_net_card *card, u32 status_reg,
 	{
 	case SPIDER_NET_GTMFLLINT:
 		/* TX RAM full may happen on a usual case.
-		 * Logging is not needed. */
+		 * Logging is not needed.
+		 */
 		show_error = 0;
 		break;
 	case SPIDER_NET_GRFDFLLINT:
@@ -1694,7 +1704,8 @@ spider_net_enable_card(struct spider_net_card *card)
 {
 	int i;
 	/* the following array consists of (register),(value) pairs
-	 * that are set in this function. A register of 0 ends the list */
+	 * that are set in this function. A register of 0 ends the list
+	 */
 	u32 regs[][2] = {
 		{ SPIDER_NET_GRESUMINTNUM, 0 },
 		{ SPIDER_NET_GREINTNUM, 0 },
@@ -1757,7 +1768,8 @@ spider_net_enable_card(struct spider_net_card *card)
 	spider_net_write_reg(card, SPIDER_NET_ECMODE, SPIDER_NET_ECMODE_VALUE);
 
 	/* set chain tail address for RX chains and
-	 * enable DMA */
+	 * enable DMA
+	 */
 	spider_net_enable_rxchtails(card);
 	spider_net_enable_rxdmac(card);
 
@@ -1995,7 +2007,8 @@ static void spider_net_link_phy(struct timer_list *t)
 
 		case BCM54XX_UNKNOWN:
 			/* copper, fiber with and without failed,
-			 * retry from beginning */
+			 * retry from beginning
+			 */
 			spider_net_setup_aneg(card);
 			card->medium = BCM54XX_COPPER;
 			break;
@@ -2263,7 +2276,8 @@ spider_net_setup_netdev(struct spider_net_card *card)
 		netdev->features |= NETIF_F_RXCSUM;
 	netdev->features |= NETIF_F_IP_CSUM | NETIF_F_LLTX;
 	/* some time: NETIF_F_HW_VLAN_CTAG_TX | NETIF_F_HW_VLAN_CTAG_RX |
-	 *		NETIF_F_HW_VLAN_CTAG_FILTER */
+	 *		NETIF_F_HW_VLAN_CTAG_FILTER
+	 */
 
 	/* MTU range: 64 - 2294 */
 	netdev->min_mtu = SPIDER_NET_MIN_MTU;
diff --git a/drivers/net/ethernet/toshiba/tc35815.c b/drivers/net/ethernet/toshiba/tc35815.c
index 7a6e5ff..fedb2bf 100644
--- a/drivers/net/ethernet/toshiba/tc35815.c
+++ b/drivers/net/ethernet/toshiba/tc35815.c
@@ -1914,7 +1914,8 @@ tc35815_set_multicast_list(struct net_device *dev)
 
 	if (dev->flags & IFF_PROMISC) {
 		/* With some (all?) 100MHalf HUB, controller will hang
-		 * if we enabled promiscuous mode before linkup... */
+		 * if we enabled promiscuous mode before linkup...
+		 */
 		struct tc35815_local *lp = netdev_priv(dev);
 
 		if (!lp->link)
-- 
2.8.1


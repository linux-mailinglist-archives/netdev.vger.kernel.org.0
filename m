Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 716E1134750
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 17:12:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729367AbgAHQM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 11:12:29 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:47940 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726186AbgAHQM2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 11:12:28 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us5.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7E04FA40058;
        Wed,  8 Jan 2020 16:12:26 +0000 (UTC)
Received: from amm-opti7060.uk.solarflarecom.com (10.17.20.147) by
 ukex01.SolarFlarecom.com (10.17.10.4) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Wed, 8 Jan 2020 16:12:21 +0000
From:   "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Subject: [PATCH net-next 08/14] sfc: move some channel-related code
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>
CC:     <linux-net-drivers@solarflare.com>, <scrum-linux@solarflare.com>
References: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Message-ID: <932fd74b-5fa8-6a62-07b2-a0f13a2417d6@solarflare.com>
Date:   Wed, 8 Jan 2020 16:12:18 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <a0cfb828-b98e-3a63-15d9-592675e81b5f@solarflare.com>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.147]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25154.003
X-TM-AS-Result: No-12.722000-8.000000-10
X-TMASE-MatchedRID: ybJNz0LsM78/REwOA9OGtdB/IoRhBzVH2LlbtF/6zpAKfrbmG+DbUP41
        mI4NoedhbNO+RcviUKN0qNjp+6yKLcx079ojRyOiuwdUMMznEA/Uk/02d006RRMu6ersnFy9TBJ
        5VCdJL8X9Ktxj1mXhOo9CL1e45ag4w4mZjhdFeRUHwuCWPSIIAEqAhuLHn5fEQ8kP1MXUYLA0fA
        EAYiHby3ghiIvM4QIV9+bYTZcbHB4nBUzh+98e9o9BVqQOQlT5fYrr1p9yfCrlz4G0C4MbOADbE
        Y4QmtcSIXgVVI54wi8dunRH04uvSGZRsKzcNsjWPja3w1ExF8RvV3/OnMClWpl8NETW6pKC+3n5
        TORW5Is9+VF9zTdE5AXLIIlomiJum8rJlXxq3wJwju9EALAXQhStkd+JewitvWAqehIRxmaA2U4
        DoCTZiHFhLBYnx+r41smIV73H0RnqZVqgtTpaTgm6mWzI013H8Ql85K8KnzPLkl8e9W70i1bTtJ
        pG9MBBkwn33Vura1JO3YKUFeTv4w0SFHfMt4MPKpEngz2rs68r9gVlOIN/6tM73tLodP8W2CMTQ
        A2psty/PQ3+a9qUclkrSGuyROAs/B9dz1laVgyJUlmL3Uj0mFsP0tBwe3qDHWtVZN0asThyoN2Q
        iJtl0TGgLBHIzH0BLy0u2DzE6cNJvfcscZZwqCfzaLQeObABLdLfmiFS7furZHMcVOhFSP0EGqX
        iN/DnRnYiJL0MIib/fZQSl1VJIaPFjJEFr+olfeZdJ1XsoriZUuVCTQbcZ8K21zBg2KlfyMdyHK
        es7ltNqwaJPhECTPNdRX1ewXrpWDfo14xe/0XFzIBNt6wBLg==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--12.722000-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25154.003
X-MDID: 1578499947-nhvKGuCPMwOz
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just a handful of function, but also removed many 'static' identifiers
so the code builds. These will, of course, be moved.
Module parameters for IRQ moderation threshold also moved.

Small code styling fixes included.

Signed-off-by: Alexandru-Mihai Maftei <amaftei@solarflare.com>
---
 drivers/net/ethernet/sfc/Makefile       |   2 +-
 drivers/net/ethernet/sfc/efx.c          | 169 ---------------------
 drivers/net/ethernet/sfc/efx_channels.c | 189 ++++++++++++++++++++++++
 3 files changed, 190 insertions(+), 170 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/efx_channels.c

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 7022cffa31f8..dacfa42beffe 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -1,5 +1,5 @@
 # SPDX-License-Identifier: GPL-2.0
-sfc-y			+= efx.o efx_common.o nic.o \
+sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   farch.o siena.o ef10.o \
 			   tx.o rx.o \
 			   selftest.o ethtool.o ptp.o tx_tso.o \
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index a1af42dde450..530185636afd 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -77,11 +77,6 @@ module_param(efx_separate_tx_channels, bool, 0444);
 MODULE_PARM_DESC(efx_separate_tx_channels,
 		 "Use separate channels for TX and RX");
 
-/* This is the weight assigned to each of the (per-channel) virtual
- * NAPI devices.
- */
-static int napi_weight = 64;
-
 /* Initial interrupt moderation settings.  They can be modified after
  * module load with ethtool.
  *
@@ -123,16 +118,6 @@ static bool phy_flash_cfg;
 module_param(phy_flash_cfg, bool, 0644);
 MODULE_PARM_DESC(phy_flash_cfg, "Set PHYs into reflash mode initially");
 
-static unsigned irq_adapt_low_thresh = 8000;
-module_param(irq_adapt_low_thresh, uint, 0644);
-MODULE_PARM_DESC(irq_adapt_low_thresh,
-		 "Threshold score for reducing IRQ moderation");
-
-static unsigned irq_adapt_high_thresh = 16000;
-module_param(irq_adapt_high_thresh, uint, 0644);
-MODULE_PARM_DESC(irq_adapt_high_thresh,
-		 "Threshold score for increasing IRQ moderation");
-
 static unsigned debug = (NETIF_MSG_DRV | NETIF_MSG_PROBE |
 			 NETIF_MSG_LINK | NETIF_MSG_IFDOWN |
 			 NETIF_MSG_IFUP | NETIF_MSG_RX_ERR |
@@ -167,121 +152,6 @@ static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
  *
  *************************************************************************/
 
-/* Process channel's event queue
- *
- * This function is responsible for processing the event queue of a
- * single channel.  The caller must guarantee that this function will
- * never be concurrently called more than once on the same channel,
- * though different channels may be being processed concurrently.
- */
-static int efx_process_channel(struct efx_channel *channel, int budget)
-{
-	struct efx_tx_queue *tx_queue;
-	struct list_head rx_list;
-	int spent;
-
-	if (unlikely(!channel->enabled))
-		return 0;
-
-	/* Prepare the batch receive list */
-	EFX_WARN_ON_PARANOID(channel->rx_list != NULL);
-	INIT_LIST_HEAD(&rx_list);
-	channel->rx_list = &rx_list;
-
-	efx_for_each_channel_tx_queue(tx_queue, channel) {
-		tx_queue->pkts_compl = 0;
-		tx_queue->bytes_compl = 0;
-	}
-
-	spent = efx_nic_process_eventq(channel, budget);
-	if (spent && efx_channel_has_rx_queue(channel)) {
-		struct efx_rx_queue *rx_queue =
-			efx_channel_get_rx_queue(channel);
-
-		efx_rx_flush_packet(channel);
-		efx_fast_push_rx_descriptors(rx_queue, true);
-	}
-
-	/* Update BQL */
-	efx_for_each_channel_tx_queue(tx_queue, channel) {
-		if (tx_queue->bytes_compl) {
-			netdev_tx_completed_queue(tx_queue->core_txq,
-				tx_queue->pkts_compl, tx_queue->bytes_compl);
-		}
-	}
-
-	/* Receive any packets we queued up */
-	netif_receive_skb_list(channel->rx_list);
-	channel->rx_list = NULL;
-
-	return spent;
-}
-
-/* NAPI poll handler
- *
- * NAPI guarantees serialisation of polls of the same device, which
- * provides the guarantee required by efx_process_channel().
- */
-static void efx_update_irq_mod(struct efx_nic *efx, struct efx_channel *channel)
-{
-	int step = efx->irq_mod_step_us;
-
-	if (channel->irq_mod_score < irq_adapt_low_thresh) {
-		if (channel->irq_moderation_us > step) {
-			channel->irq_moderation_us -= step;
-			efx->type->push_irq_moderation(channel);
-		}
-	} else if (channel->irq_mod_score > irq_adapt_high_thresh) {
-		if (channel->irq_moderation_us <
-		    efx->irq_rx_moderation_us) {
-			channel->irq_moderation_us += step;
-			efx->type->push_irq_moderation(channel);
-		}
-	}
-
-	channel->irq_count = 0;
-	channel->irq_mod_score = 0;
-}
-
-static int efx_poll(struct napi_struct *napi, int budget)
-{
-	struct efx_channel *channel =
-		container_of(napi, struct efx_channel, napi_str);
-	struct efx_nic *efx = channel->efx;
-	int spent;
-
-	netif_vdbg(efx, intr, efx->net_dev,
-		   "channel %d NAPI poll executing on CPU %d\n",
-		   channel->channel, raw_smp_processor_id());
-
-	spent = efx_process_channel(channel, budget);
-
-	xdp_do_flush_map();
-
-	if (spent < budget) {
-		if (efx_channel_has_rx_queue(channel) &&
-		    efx->irq_rx_adaptive &&
-		    unlikely(++channel->irq_count == 1000)) {
-			efx_update_irq_mod(efx, channel);
-		}
-
-#ifdef CONFIG_RFS_ACCEL
-		/* Perhaps expire some ARFS filters */
-		mod_delayed_work(system_wq, &channel->filter_work, 0);
-#endif
-
-		/* There is no race here; although napi_disable() will
-		 * only wait for napi_complete(), this isn't a problem
-		 * since efx_nic_eventq_read_ack() will have no effect if
-		 * interrupts have already been disabled.
-		 */
-		if (napi_complete_done(napi, spent))
-			efx_nic_eventq_read_ack(channel);
-	}
-
-	return spent;
-}
-
 /* Create event queue
  * Event queue memory allocations are done only once.  If the channel
  * is reset, the memory buffer will be reused; this guards against
@@ -1715,45 +1585,6 @@ static int efx_ioctl(struct net_device *net_dev, struct ifreq *ifr, int cmd)
 	return mdio_mii_ioctl(&efx->mdio, data, cmd);
 }
 
-/**************************************************************************
- *
- * NAPI interface
- *
- **************************************************************************/
-
-void efx_init_napi_channel(struct efx_channel *channel)
-{
-	struct efx_nic *efx = channel->efx;
-
-	channel->napi_dev = efx->net_dev;
-	netif_napi_add(channel->napi_dev, &channel->napi_str,
-		       efx_poll, napi_weight);
-}
-
-void efx_init_napi(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-
-	efx_for_each_channel(channel, efx)
-		efx_init_napi_channel(channel);
-}
-
-void efx_fini_napi_channel(struct efx_channel *channel)
-{
-	if (channel->napi_dev)
-		netif_napi_del(&channel->napi_str);
-
-	channel->napi_dev = NULL;
-}
-
-void efx_fini_napi(struct efx_nic *efx)
-{
-	struct efx_channel *channel;
-
-	efx_for_each_channel(channel, efx)
-		efx_fini_napi_channel(channel);
-}
-
 /**************************************************************************
  *
  * Kernel net device interface
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
new file mode 100644
index 000000000000..f288d13d4d09
--- /dev/null
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -0,0 +1,189 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2018 Solarflare Communications Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "net_driver.h"
+#include <linux/module.h>
+#include "efx_channels.h"
+#include "efx.h"
+#include "efx_common.h"
+#include "tx_common.h"
+#include "rx_common.h"
+#include "nic.h"
+#include "sriov.h"
+
+static unsigned int irq_adapt_low_thresh = 8000;
+module_param(irq_adapt_low_thresh, uint, 0644);
+MODULE_PARM_DESC(irq_adapt_low_thresh,
+		 "Threshold score for reducing IRQ moderation");
+
+static unsigned int irq_adapt_high_thresh = 16000;
+module_param(irq_adapt_high_thresh, uint, 0644);
+MODULE_PARM_DESC(irq_adapt_high_thresh,
+		 "Threshold score for increasing IRQ moderation");
+
+/* This is the weight assigned to each of the (per-channel) virtual
+ * NAPI devices.
+ */
+static int napi_weight = 64;
+
+/**************************************************************************
+ *
+ * NAPI interface
+ *
+ *************************************************************************/
+
+/* Process channel's event queue
+ *
+ * This function is responsible for processing the event queue of a
+ * single channel.  The caller must guarantee that this function will
+ * never be concurrently called more than once on the same channel,
+ * though different channels may be being processed concurrently.
+ */
+static int efx_process_channel(struct efx_channel *channel, int budget)
+{
+	struct efx_tx_queue *tx_queue;
+	struct list_head rx_list;
+	int spent;
+
+	if (unlikely(!channel->enabled))
+		return 0;
+
+	/* Prepare the batch receive list */
+	EFX_WARN_ON_PARANOID(channel->rx_list != NULL);
+	INIT_LIST_HEAD(&rx_list);
+	channel->rx_list = &rx_list;
+
+	efx_for_each_channel_tx_queue(tx_queue, channel) {
+		tx_queue->pkts_compl = 0;
+		tx_queue->bytes_compl = 0;
+	}
+
+	spent = efx_nic_process_eventq(channel, budget);
+	if (spent && efx_channel_has_rx_queue(channel)) {
+		struct efx_rx_queue *rx_queue =
+			efx_channel_get_rx_queue(channel);
+
+		efx_rx_flush_packet(channel);
+		efx_fast_push_rx_descriptors(rx_queue, true);
+	}
+
+	/* Update BQL */
+	efx_for_each_channel_tx_queue(tx_queue, channel) {
+		if (tx_queue->bytes_compl) {
+			netdev_tx_completed_queue(tx_queue->core_txq,
+						  tx_queue->pkts_compl,
+						  tx_queue->bytes_compl);
+		}
+	}
+
+	/* Receive any packets we queued up */
+	netif_receive_skb_list(channel->rx_list);
+	channel->rx_list = NULL;
+
+	return spent;
+}
+
+static void efx_update_irq_mod(struct efx_nic *efx, struct efx_channel *channel)
+{
+	int step = efx->irq_mod_step_us;
+
+	if (channel->irq_mod_score < irq_adapt_low_thresh) {
+		if (channel->irq_moderation_us > step) {
+			channel->irq_moderation_us -= step;
+			efx->type->push_irq_moderation(channel);
+		}
+	} else if (channel->irq_mod_score > irq_adapt_high_thresh) {
+		if (channel->irq_moderation_us <
+		    efx->irq_rx_moderation_us) {
+			channel->irq_moderation_us += step;
+			efx->type->push_irq_moderation(channel);
+		}
+	}
+
+	channel->irq_count = 0;
+	channel->irq_mod_score = 0;
+}
+
+/* NAPI poll handler
+ *
+ * NAPI guarantees serialisation of polls of the same device, which
+ * provides the guarantee required by efx_process_channel().
+ */
+static int efx_poll(struct napi_struct *napi, int budget)
+{
+	struct efx_channel *channel =
+		container_of(napi, struct efx_channel, napi_str);
+	struct efx_nic *efx = channel->efx;
+	int spent;
+
+	netif_vdbg(efx, intr, efx->net_dev,
+		   "channel %d NAPI poll executing on CPU %d\n",
+		   channel->channel, raw_smp_processor_id());
+
+	spent = efx_process_channel(channel, budget);
+
+	xdp_do_flush_map();
+
+	if (spent < budget) {
+		if (efx_channel_has_rx_queue(channel) &&
+		    efx->irq_rx_adaptive &&
+		    unlikely(++channel->irq_count == 1000)) {
+			efx_update_irq_mod(efx, channel);
+		}
+
+#ifdef CONFIG_RFS_ACCEL
+		/* Perhaps expire some ARFS filters */
+		mod_delayed_work(system_wq, &channel->filter_work, 0);
+#endif
+
+		/* There is no race here; although napi_disable() will
+		 * only wait for napi_complete(), this isn't a problem
+		 * since efx_nic_eventq_read_ack() will have no effect if
+		 * interrupts have already been disabled.
+		 */
+		if (napi_complete_done(napi, spent))
+			efx_nic_eventq_read_ack(channel);
+	}
+
+	return spent;
+}
+
+void efx_init_napi_channel(struct efx_channel *channel)
+{
+	struct efx_nic *efx = channel->efx;
+
+	channel->napi_dev = efx->net_dev;
+	netif_napi_add(channel->napi_dev, &channel->napi_str,
+		       efx_poll, napi_weight);
+}
+
+void efx_init_napi(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+
+	efx_for_each_channel(channel, efx)
+		efx_init_napi_channel(channel);
+}
+
+void efx_fini_napi_channel(struct efx_channel *channel)
+{
+	if (channel->napi_dev)
+		netif_napi_del(&channel->napi_str);
+
+	channel->napi_dev = NULL;
+}
+
+void efx_fini_napi(struct efx_nic *efx)
+{
+	struct efx_channel *channel;
+
+	efx_for_each_channel(channel, efx)
+		efx_fini_napi_channel(channel);
+}
-- 
2.20.1



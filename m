Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 230E5210E18
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731635AbgGAOxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:53:48 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:48990 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731490AbgGAOxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:53:48 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BEA7C600E5;
        Wed,  1 Jul 2020 14:53:46 +0000 (UTC)
Received: from us4-mdac16-49.ut7.mdlocal (unknown [10.7.66.16])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id BECA0200A0;
        Wed,  1 Jul 2020 14:53:46 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.40])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1EC171C0054;
        Wed,  1 Jul 2020 14:53:46 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 83007BC0081;
        Wed,  1 Jul 2020 14:53:45 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:53:40 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 07/15] sfc: assign TXQs without gaps
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <b52137f3-c767-e659-261e-ff17237ed6a9@solarflare.com>
Date:   Wed, 1 Jul 2020 15:53:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-6.798800-8.000000-10
X-TMASE-MatchedRID: nQOS8O8fzCkBmyRCHqEtfXTzPL3sqyAmCqIE7aqEIgaYeMTPaAHLLXsy
        gY4tPtxe+XbKEHdcobokzGJIpoPATcI+H5LAJqs7eWgJLNowHdX16787vFsqdEFungmhsSsCTR/
        R9+KYBGijF0+il498CK5e4qFm24tJQOASlW3M7HWGOUGPCmibU3qLr3o+NE+IHdFjikZMLIdcpk
        b9zUI7BOGgS4rOorYri7kudfmTABNyPzMTUSO1JBXCv0BjRkS9ndls9F9zmi3RLEyE6G4DRKHD1
        a7PvZdl/uUmXgruvD3KZEewW1X89ig8iUFKzrB2TsJqNJWg0WyikZBjlts/ckoPLn6eZ90++wKw
        0jvhTzSjVhFNcdArczrckx4jHuTGvYtt39hpnmPHmyDJSEsI25naxzJFBx6vXZgp9Jjp/Mx7TC5
        6+ziBs84M0wnt7LoDOWx4orYLiynCFdW8OB9PN7BUinxjyKa14F58RPNYsrGExk6c4qzx8k3GuE
        sINiOjEcJfwGWFaI6b+YYCc0JkafV1MnnwgooQZacDbE73ZSluQYcwHFo4Bq2cVFH995P9a3A6h
        cNu8nB4y9/ByRSA/Cq75Q09Yd+O78/PGPHKF3nKXbIv3mQNY32K69afcnwqmFTLhE9P87qjxYyR
        Ba/qJQPTK4qtAgwIPcCXjNqUmkUgBwKKRHe+ryRYyOyMDmNzTMTuEInwvsVSh5djEoakvSht1s4
        itWfAzU54ySOjyEA=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.798800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615226-VKZ8bprsorLO
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since we only allocate VIs for the number of TXQs we actually need, we
 cannot naively use "channel * TXQ_TYPES + txq" for the TXQ number, as
 this has gaps (when efx->tx_queues_per_channel < EFX_TXQ_TYPES) and
 thus overruns the driver's VI allocations, causing the firmware to
 reject the MC_CMD_INIT_TXQ based on INSTANCE.
Thus, we distinguish INSTANCE (stored in tx_queue->queue) from LABEL
 (tx_queue->label); the former is allocated starting from 0 in
 efx_set_channels(), while the latter is simply the txq type (index in
 channel->tx_queue array).
To simplify things, rather than changing tx_queues_per_channel after
 setting up TXQs, make Siena always probe its HIGHPRI queues at start
 of day, rather than deferring it until tc mqprio enables them.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           |  2 +-
 drivers/net/ethernet/sfc/efx_channels.c   | 38 ++++++++++++++-----
 drivers/net/ethernet/sfc/ethtool_common.c |  7 ++--
 drivers/net/ethernet/sfc/farch.c          |  6 +--
 drivers/net/ethernet/sfc/mcdi_functions.c |  4 +-
 drivers/net/ethernet/sfc/net_driver.h     |  5 ++-
 drivers/net/ethernet/sfc/nic_common.h     |  2 +-
 drivers/net/ethernet/sfc/selftest.c       | 18 ++++-----
 drivers/net/ethernet/sfc/siena.c          |  2 +-
 drivers/net/ethernet/sfc/tx.c             | 46 +++--------------------
 10 files changed, 58 insertions(+), 72 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index f5d19e949592..790a1f516a15 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2244,7 +2244,7 @@ static u32 efx_ef10_tso_versions(struct efx_nic *efx)
 
 static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 {
-	bool csum_offload = tx_queue->queue & EFX_TXQ_TYPE_OFFLOAD;
+	bool csum_offload = tx_queue->label & EFX_TXQ_TYPE_OFFLOAD;
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
 	struct efx_ef10_nic_data *nic_data;
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index dd6ee60b66a0..0c06af958333 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -524,7 +524,8 @@ efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel)
 	for (j = 0; j < EFX_TXQ_TYPES; j++) {
 		tx_queue = &channel->tx_queue[j];
 		tx_queue->efx = efx;
-		tx_queue->queue = i * EFX_TXQ_TYPES + j;
+		tx_queue->queue = -1;
+		tx_queue->label = j;
 		tx_queue->channel = channel;
 	}
 
@@ -853,8 +854,9 @@ int efx_realloc_channels(struct efx_nic *efx, u32 rxq_entries, u32 txq_entries)
 
 int efx_set_channels(struct efx_nic *efx)
 {
-	struct efx_channel *channel;
 	struct efx_tx_queue *tx_queue;
+	struct efx_channel *channel;
+	unsigned int next_queue = 0;
 	int xdp_queue_number;
 
 	efx->tx_channel_offset =
@@ -883,14 +885,30 @@ int efx_set_channels(struct efx_nic *efx)
 		else
 			channel->rx_queue.core_index = -1;
 
-		efx_for_each_channel_tx_queue(tx_queue, channel) {
-			tx_queue->queue -= (efx->tx_channel_offset *
-					    EFX_TXQ_TYPES);
-
-			if (efx_channel_is_xdp_tx(channel) &&
-			    xdp_queue_number < efx->xdp_tx_queue_count) {
-				efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
-				xdp_queue_number++;
+		if (channel->channel >= efx->tx_channel_offset) {
+			if (efx_channel_is_xdp_tx(channel)) {
+				efx_for_each_channel_tx_queue(tx_queue, channel) {
+					tx_queue->queue = next_queue++;
+					netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is XDP %u, HW %u\n",
+						  channel->channel, tx_queue->label,
+						  xdp_queue_number, tx_queue->queue);
+					/* We may have a few left-over XDP TX
+					 * queues owing to xdp_tx_queue_count
+					 * not dividing evenly by EFX_TXQ_TYPES.
+					 * We still allocate and probe those
+					 * TXQs, but never use them.
+					 */
+					if (xdp_queue_number < efx->xdp_tx_queue_count)
+						efx->xdp_tx_queues[xdp_queue_number] = tx_queue;
+					xdp_queue_number++;
+				}
+			} else {
+				efx_for_each_channel_tx_queue(tx_queue, channel) {
+					tx_queue->queue = next_queue++;
+					netif_dbg(efx, drv, efx->net_dev, "Channel %u TXQ %u is HW %u\n",
+						  channel->channel, tx_queue->label,
+						  tx_queue->queue);
+				}
 			}
 		}
 	}
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index 738d9be86899..37a4409e759e 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -287,8 +287,7 @@ static void efx_fill_test(unsigned int test_index, u8 *strings, u64 *data,
 }
 
 #define EFX_CHANNEL_NAME(_channel) "chan%d", _channel->channel
-#define EFX_TX_QUEUE_NAME(_tx_queue) "txq%d", _tx_queue->queue
-#define EFX_RX_QUEUE_NAME(_rx_queue) "rxq%d", _rx_queue->queue
+#define EFX_TX_QUEUE_NAME(_tx_queue) "txq%d", _tx_queue->label
 #define EFX_LOOPBACK_NAME(_mode, _counter)			\
 	"loopback.%s." _counter, STRING_TABLE_LOOKUP(_mode, efx_loopback_mode)
 
@@ -316,11 +315,11 @@ static int efx_fill_loopback_test(struct efx_nic *efx,
 
 	efx_for_each_channel_tx_queue(tx_queue, channel) {
 		efx_fill_test(test_index++, strings, data,
-			      &lb_tests->tx_sent[tx_queue->queue],
+			      &lb_tests->tx_sent[tx_queue->label],
 			      EFX_TX_QUEUE_NAME(tx_queue),
 			      EFX_LOOPBACK_NAME(mode, "tx_sent"));
 		efx_fill_test(test_index++, strings, data,
-			      &lb_tests->tx_done[tx_queue->queue],
+			      &lb_tests->tx_done[tx_queue->label],
 			      EFX_TX_QUEUE_NAME(tx_queue),
 			      EFX_LOOPBACK_NAME(mode, "tx_done"));
 	}
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index dbbb898adddb..d07eeaad9bdf 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -379,7 +379,7 @@ int efx_farch_tx_probe(struct efx_tx_queue *tx_queue)
 
 void efx_farch_tx_init(struct efx_tx_queue *tx_queue)
 {
-	int csum = tx_queue->queue & EFX_TXQ_TYPE_OFFLOAD;
+	int csum = tx_queue->label & EFX_TXQ_TYPE_OFFLOAD;
 	struct efx_nic *efx = tx_queue->efx;
 	efx_oword_t reg;
 
@@ -395,7 +395,7 @@ void efx_farch_tx_init(struct efx_tx_queue *tx_queue)
 			      FRF_AZ_TX_DESCQ_EVQ_ID,
 			      tx_queue->channel->channel,
 			      FRF_AZ_TX_DESCQ_OWNER_ID, 0,
-			      FRF_AZ_TX_DESCQ_LABEL, tx_queue->queue,
+			      FRF_AZ_TX_DESCQ_LABEL, tx_queue->label,
 			      FRF_AZ_TX_DESCQ_SIZE,
 			      __ffs(tx_queue->txd.entries),
 			      FRF_AZ_TX_DESCQ_TYPE, 0,
@@ -409,7 +409,7 @@ void efx_farch_tx_init(struct efx_tx_queue *tx_queue)
 
 	EFX_POPULATE_OWORD_1(reg,
 			     FRF_BZ_TX_PACE,
-			     (tx_queue->queue & EFX_TXQ_TYPE_HIGHPRI) ?
+			     (tx_queue->label & EFX_TXQ_TYPE_HIGHPRI) ?
 			     FFE_BZ_TX_PACE_OFF :
 			     FFE_BZ_TX_PACE_RESERVED);
 	efx_writeo_table(efx, &reg, FR_BZ_TX_PACE_TBL, tx_queue->queue);
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index 962d8395d958..b3a8aa88db06 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -164,7 +164,7 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_TXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
 						       EFX_BUF_SIZE));
-	bool csum_offload = tx_queue->queue & EFX_TXQ_TYPE_OFFLOAD;
+	bool csum_offload = tx_queue->label & EFX_TXQ_TYPE_OFFLOAD;
 	size_t entries = tx_queue->txd.buf.len / EFX_BUF_SIZE;
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
@@ -176,7 +176,7 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 
 	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_SIZE, tx_queue->ptr_mask + 1);
 	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_TARGET_EVQ, channel->channel);
-	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_LABEL, tx_queue->queue);
+	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_LABEL, tx_queue->label);
 	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_INSTANCE, tx_queue->queue);
 	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_OWNER_ID, 0);
 	MCDI_SET_DWORD(inbuf, INIT_TXQ_IN_PORT_ID, efx->vport_id);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 4ded155b12e9..0bf11ebb03cf 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -189,6 +189,8 @@ struct efx_tx_buffer {
  *
  * @efx: The associated Efx NIC
  * @queue: DMA queue number
+ * @label: Label for TX completion events.
+ *	Is our index within @channel->tx_queue array.
  * @tso_version: Version of TSO in use for this queue.
  * @channel: The associated channel
  * @core_txq: The networking core TX queue structure
@@ -250,7 +252,8 @@ struct efx_tx_buffer {
 struct efx_tx_queue {
 	/* Members which don't change on the fast path */
 	struct efx_nic *efx ____cacheline_aligned_in_smp;
-	unsigned queue;
+	unsigned int queue;
+	unsigned int label;
 	unsigned int tso_version;
 	struct efx_channel *channel;
 	struct netdev_queue *core_txq;
diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
index fd474d9e55e4..813f288ab3fe 100644
--- a/drivers/net/ethernet/sfc/nic_common.h
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -90,7 +90,7 @@ static inline bool efx_nic_tx_is_empty(struct efx_tx_queue *tx_queue)
 /* XXX is this a thing on EF100? */
 static inline struct efx_tx_queue *efx_tx_queue_partner(struct efx_tx_queue *tx_queue)
 {
-	if (tx_queue->queue & EFX_TXQ_TYPE_OFFLOAD)
+	if (tx_queue->label & EFX_TXQ_TYPE_OFFLOAD)
 		return tx_queue - EFX_TXQ_TYPE_OFFLOAD;
 	else
 		return tx_queue + EFX_TXQ_TYPE_OFFLOAD;
diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
index 1ae369022d7d..e71d6d37a317 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -445,7 +445,7 @@ static int efx_begin_loopback(struct efx_tx_queue *tx_queue)
 		if (rc != NETDEV_TX_OK) {
 			netif_err(efx, drv, efx->net_dev,
 				  "TX queue %d could not transmit packet %d of "
-				  "%d in %s loopback test\n", tx_queue->queue,
+				  "%d in %s loopback test\n", tx_queue->label,
 				  i + 1, state->packet_count,
 				  LOOPBACK_MODE(efx));
 
@@ -497,7 +497,7 @@ static int efx_end_loopback(struct efx_tx_queue *tx_queue,
 		netif_err(efx, drv, efx->net_dev,
 			  "TX queue %d saw only %d out of an expected %d "
 			  "TX completion events in %s loopback test\n",
-			  tx_queue->queue, tx_done, state->packet_count,
+			  tx_queue->label, tx_done, state->packet_count,
 			  LOOPBACK_MODE(efx));
 		rc = -ETIMEDOUT;
 		/* Allow to fall through so we see the RX errors as well */
@@ -508,15 +508,15 @@ static int efx_end_loopback(struct efx_tx_queue *tx_queue,
 		netif_dbg(efx, drv, efx->net_dev,
 			  "TX queue %d saw only %d out of an expected %d "
 			  "received packets in %s loopback test\n",
-			  tx_queue->queue, rx_good, state->packet_count,
+			  tx_queue->label, rx_good, state->packet_count,
 			  LOOPBACK_MODE(efx));
 		rc = -ETIMEDOUT;
 		/* Fall through */
 	}
 
 	/* Update loopback test structure */
-	lb_tests->tx_sent[tx_queue->queue] += state->packet_count;
-	lb_tests->tx_done[tx_queue->queue] += tx_done;
+	lb_tests->tx_sent[tx_queue->label] += state->packet_count;
+	lb_tests->tx_done[tx_queue->label] += tx_done;
 	lb_tests->rx_good += rx_good;
 	lb_tests->rx_bad += rx_bad;
 
@@ -542,8 +542,8 @@ efx_test_loopback(struct efx_tx_queue *tx_queue,
 		state->flush = false;
 
 		netif_dbg(efx, drv, efx->net_dev,
-			  "TX queue %d testing %s loopback with %d packets\n",
-			  tx_queue->queue, LOOPBACK_MODE(efx),
+			  "TX queue %d (hw %d) testing %s loopback with %d packets\n",
+			  tx_queue->label, tx_queue->queue, LOOPBACK_MODE(efx),
 			  state->packet_count);
 
 		efx_iterate_state(efx);
@@ -570,7 +570,7 @@ efx_test_loopback(struct efx_tx_queue *tx_queue,
 
 	netif_dbg(efx, drv, efx->net_dev,
 		  "TX queue %d passed %s loopback test with a burst length "
-		  "of %d packets\n", tx_queue->queue, LOOPBACK_MODE(efx),
+		  "of %d packets\n", tx_queue->label, LOOPBACK_MODE(efx),
 		  state->packet_count);
 
 	return 0;
@@ -660,7 +660,7 @@ static int efx_test_loopbacks(struct efx_nic *efx, struct efx_self_tests *tests,
 
 		/* Test all enabled types of TX queue */
 		efx_for_each_channel_tx_queue(tx_queue, channel) {
-			state->offload_csum = (tx_queue->queue &
+			state->offload_csum = (tx_queue->label &
 					       EFX_TXQ_TYPE_OFFLOAD);
 			rc = efx_test_loopback(tx_queue,
 					       &tests->loopback[mode]);
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 4c5881a3bfe4..219fb3a0c9d0 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -279,7 +279,7 @@ static int siena_probe_nic(struct efx_nic *efx)
 	efx->max_channels = EFX_MAX_CHANNELS;
 	efx->max_vis = EFX_MAX_CHANNELS;
 	efx->max_tx_channels = EFX_MAX_CHANNELS;
-	efx->tx_queues_per_channel = 2;
+	efx->tx_queues_per_channel = 4;
 
 	efx_reado(efx, &reg, FR_AZ_CS_DEBUG);
 	efx->port_num = EFX_OWORD_FIELD(reg, FRF_CZ_CS_PORT_NUM) - 1;
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 76ff394f5b58..1bcf50ab95d9 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -551,8 +551,8 @@ void efx_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue)
 	/* Must be inverse of queue lookup in efx_hard_start_xmit() */
 	tx_queue->core_txq =
 		netdev_get_tx_queue(efx->net_dev,
-				    tx_queue->queue / EFX_TXQ_TYPES +
-				    ((tx_queue->queue & EFX_TXQ_TYPE_HIGHPRI) ?
+				    tx_queue->channel->channel +
+				    ((tx_queue->label & EFX_TXQ_TYPE_HIGHPRI) ?
 				     efx->n_tx_channels : 0));
 }
 
@@ -561,10 +561,7 @@ int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 	struct tc_mqprio_qopt *mqprio = type_data;
-	struct efx_channel *channel;
-	struct efx_tx_queue *tx_queue;
 	unsigned tc, num_tc;
-	int rc;
 
 	if (type != TC_SETUP_QDISC_MQPRIO)
 		return -EOPNOTSUPP;
@@ -588,40 +585,9 @@ int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
 		net_dev->tc_to_txq[tc].count = efx->n_tx_channels;
 	}
 
-	if (num_tc > net_dev->num_tc) {
-		efx->tx_queues_per_channel = 4;
-		/* Initialise high-priority queues as necessary */
-		efx_for_each_channel(channel, efx) {
-			efx_for_each_channel_tx_queue(tx_queue, channel) {
-				if (!(tx_queue->queue & EFX_TXQ_TYPE_HIGHPRI))
-					continue;
-				if (!tx_queue->buffer) {
-					rc = efx_probe_tx_queue(tx_queue);
-					if (rc)
-						return rc;
-				}
-				if (!tx_queue->initialised)
-					efx_init_tx_queue(tx_queue);
-				efx_init_tx_queue_core_txq(tx_queue);
-			}
-		}
-	} else {
-		/* Reduce number of classes before number of queues */
-		net_dev->num_tc = num_tc;
-	}
-
-	rc = netif_set_real_num_tx_queues(net_dev,
-					  max_t(int, num_tc, 1) *
-					  efx->n_tx_channels);
-	if (rc)
-		return rc;
-
-	/* Do not destroy high-priority queues when they become
-	 * unused.  We would have to flush them first, and it is
-	 * fairly difficult to flush a subset of TX queues.  Leave
-	 * it to efx_fini_channels().
-	 */
-
 	net_dev->num_tc = num_tc;
-	return 0;
+
+	return netif_set_real_num_tx_queues(net_dev,
+					    max_t(int, num_tc, 1) *
+					    efx->n_tx_channels);
 }


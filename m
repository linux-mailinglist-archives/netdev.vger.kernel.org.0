Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602F12650DC
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 22:33:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgIJUd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 16:33:27 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:44806 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726846AbgIJUbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 16:31:42 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id F069D600D4;
        Thu, 10 Sep 2020 20:31:40 +0000 (UTC)
Received: from us4-mdac16-34.ut7.mdlocal (unknown [10.7.66.153])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EC3AA200AC;
        Thu, 10 Sep 2020 20:31:40 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.40])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 651C01C0055;
        Thu, 10 Sep 2020 20:31:40 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id CB0B1BC0068;
        Thu, 10 Sep 2020 20:31:39 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 10 Sep
 2020 21:31:33 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 1/7] sfc: decouple TXQ type from label
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
Message-ID: <6fc83ee8-6b6c-c2ea-ca81-659b6ef25569@solarflare.com>
Date:   Thu, 10 Sep 2020 21:31:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <6fbc3a86-0afd-6e6d-099b-fca9af48d019@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25656.007
X-TM-AS-Result: No-4.890900-8.000000-10
X-TMASE-MatchedRID: U3yCsqBuKGYuGJVwjRzMf26HurDH4PpPM56LeR0qzjdTorRIuadptMiT
        Wug2C4DNl1M7KT9/aqCJYZ+Td59n+yRUxBx2BTapnFVnNmvv47tLXPA26IG0hN9RlPzeVuQQmtz
        dM0My18OrXlS8Wr+tkWRg+Czv7wwMHaQ9wyk4fkAVwr9AY0ZEvQqiBO2qhCIGdLv/+WrG6tM6Rv
        9YN97Y5q+3JT02eIfoxgZLkcFnBTiPG6kqlFlR4sn9tWHiLD2GGrSmht4ssAfHN9tnHHgXhML/Q
        ImyZSpwfbwXoDZ8aBk63JMeIx7kxuJPyge9irBSbWsCUkrA4El8s0cy6t/KSF7OLL/a8shjl5Ef
        wglrgiZYqhPLqTxF2bLPNDefR87hmzIISDN8DZe0pHkVd9vKzH10QHPrN0RXVj3J63pAR3wplD/
        bYdJZ1b6ipT4gS++nZYWN2IoD+xKmvIhzs+DZcVt8oqXrPa7yvr3xZAWZLfEANyw+7EHhUvtZEv
        zXMbqGnw3mElBCfotI3UwDRYAmKVNq22uBrzfYRFakFvQb7akYR+gKWoGXzrqln+jYe7ZhCieTl
        R6U1pq6bt+wCiS8LHlA295yKvR50UVczdgWopPylEfNwb6iLcu99zcLpJbCThCCwTgXpi8c28j3
        pyavd5N1SkQO+8FMfAGh5Z+YweUM8jMXjBF+sDl/1fD/GopdWQy9YC5qGvxKdDgyPBo71yq2rl3
        dzGQ1ovycIGWQOX6P/4ijSH6IDl4M/QD84wt14C16sYg2mwn0TWp72Tt7xQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--4.890900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25656.007
X-MDID: 1599769900-Xtz2t_LllZOS
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Make it possible to have an arbitrary mapping from types to labels,
 because when we add inner-csum-offload TXQs there will no longer be a
 convenient nesting hierarchy of NIC types (EF10 will have inner-csum
 TXQs, while Siena will have HIGHPRI).

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           |  5 ++--
 drivers/net/ethernet/sfc/efx_channels.c   | 10 +++----
 drivers/net/ethernet/sfc/ethtool_common.c |  2 +-
 drivers/net/ethernet/sfc/farch.c          | 20 +++++++-------
 drivers/net/ethernet/sfc/mcdi_functions.c |  2 +-
 drivers/net/ethernet/sfc/net_driver.h     | 33 +++++++++++++----------
 drivers/net/ethernet/sfc/ptp.c            |  2 +-
 drivers/net/ethernet/sfc/selftest.c       |  2 +-
 drivers/net/ethernet/sfc/selftest.h       |  4 +--
 drivers/net/ethernet/sfc/tx.c             |  8 +++++-
 drivers/net/ethernet/sfc/tx_common.c      |  4 ++-
 11 files changed, 54 insertions(+), 38 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 316e14533e9d..c9b6d23580a8 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2146,6 +2146,7 @@ static int efx_ef10_irq_test_generate(struct efx_nic *efx)
 
 static int efx_ef10_tx_probe(struct efx_tx_queue *tx_queue)
 {
+	tx_queue->type = tx_queue->label & EFX_TXQ_TYPE_OFFLOAD;
 	return efx_nic_alloc_buffer(tx_queue->efx, &tx_queue->txd.buf,
 				    (tx_queue->ptr_mask + 1) *
 				    sizeof(efx_qword_t),
@@ -2254,7 +2255,7 @@ static u32 efx_ef10_tso_versions(struct efx_nic *efx)
 
 static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 {
-	bool csum_offload = tx_queue->label & EFX_TXQ_TYPE_OFFLOAD;
+	bool csum_offload = tx_queue->type & EFX_TXQ_TYPE_OFFLOAD;
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
 	struct efx_ef10_nic_data *nic_data;
@@ -2880,7 +2881,7 @@ efx_ef10_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
 	/* Get the transmit queue */
 	tx_ev_q_label = EFX_QWORD_FIELD(*event, ESF_DZ_TX_QLABEL);
 	tx_queue = efx_channel_get_tx_queue(channel,
-					    tx_ev_q_label % EFX_TXQ_TYPES);
+					    tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
 
 	if (!tx_queue->timestamping) {
 		/* Transmit completion */
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index dd4f30ea48a8..0769d921bde1 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -151,7 +151,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 	 */
 
 	n_xdp_tx = num_possible_cpus();
-	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_TXQ_TYPES);
+	n_xdp_ev = DIV_ROUND_UP(n_xdp_tx, EFX_MAX_TXQ_PER_CHANNEL);
 
 	vec_count = pci_msix_vec_count(efx->pci_dev);
 	if (vec_count < 0)
@@ -179,7 +179,7 @@ static int efx_allocate_msix_channels(struct efx_nic *efx,
 		efx->xdp_tx_queue_count = 0;
 	} else {
 		efx->n_xdp_channels = n_xdp_ev;
-		efx->xdp_tx_per_channel = EFX_TXQ_TYPES;
+		efx->xdp_tx_per_channel = EFX_MAX_TXQ_PER_CHANNEL;
 		efx->xdp_tx_queue_count = n_xdp_tx;
 		n_channels += n_xdp_ev;
 		netif_dbg(efx, drv, efx->net_dev,
@@ -521,7 +521,7 @@ efx_alloc_channel(struct efx_nic *efx, int i, struct efx_channel *old_channel)
 	channel->channel = i;
 	channel->type = &efx_default_channel_type;
 
-	for (j = 0; j < EFX_TXQ_TYPES; j++) {
+	for (j = 0; j < EFX_MAX_TXQ_PER_CHANNEL; j++) {
 		tx_queue = &channel->tx_queue[j];
 		tx_queue->efx = efx;
 		tx_queue->queue = -1;
@@ -595,7 +595,7 @@ struct efx_channel *efx_copy_channel(const struct efx_channel *old_channel)
 	channel->napi_str.state = 0;
 	memset(&channel->eventq, 0, sizeof(channel->eventq));
 
-	for (j = 0; j < EFX_TXQ_TYPES; j++) {
+	for (j = 0; j < EFX_MAX_TXQ_PER_CHANNEL; j++) {
 		tx_queue = &channel->tx_queue[j];
 		if (tx_queue->channel)
 			tx_queue->channel = channel;
@@ -895,7 +895,7 @@ int efx_set_channels(struct efx_nic *efx)
 						  xdp_queue_number, tx_queue->queue);
 					/* We may have a few left-over XDP TX
 					 * queues owing to xdp_tx_queue_count
-					 * not dividing evenly by EFX_TXQ_TYPES.
+					 * not dividing evenly by EFX_MAX_TXQ_PER_CHANNEL.
 					 * We still allocate and probe those
 					 * TXQs, but never use them.
 					 */
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index b18a4bcfccdf..bf1443539a1a 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -407,7 +407,7 @@ static size_t efx_describe_per_queue_stats(struct efx_nic *efx, u8 *strings)
 				snprintf(strings, ETH_GSTRING_LEN,
 					 "tx-%u.tx_packets",
 					 channel->tx_queue[0].queue /
-					 EFX_TXQ_TYPES);
+					 EFX_MAX_TXQ_PER_CHANNEL);
 
 				strings += ETH_GSTRING_LEN;
 			}
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index e004524e14a8..2f36622627d5 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -372,6 +372,8 @@ int efx_farch_tx_probe(struct efx_tx_queue *tx_queue)
 	struct efx_nic *efx = tx_queue->efx;
 	unsigned entries;
 
+	tx_queue->type = ((tx_queue->label & 1) ? EFX_TXQ_TYPE_OFFLOAD : 0) |
+			 ((tx_queue->label & 2) ? EFX_TXQ_TYPE_HIGHPRI : 0);
 	entries = tx_queue->ptr_mask + 1;
 	return efx_alloc_special_buffer(efx, &tx_queue->txd,
 					entries * sizeof(efx_qword_t));
@@ -379,7 +381,7 @@ int efx_farch_tx_probe(struct efx_tx_queue *tx_queue)
 
 void efx_farch_tx_init(struct efx_tx_queue *tx_queue)
 {
-	int csum = tx_queue->label & EFX_TXQ_TYPE_OFFLOAD;
+	int csum = tx_queue->type & EFX_TXQ_TYPE_OFFLOAD;
 	struct efx_nic *efx = tx_queue->efx;
 	efx_oword_t reg;
 
@@ -409,7 +411,7 @@ void efx_farch_tx_init(struct efx_tx_queue *tx_queue)
 
 	EFX_POPULATE_OWORD_1(reg,
 			     FRF_BZ_TX_PACE,
-			     (tx_queue->label & EFX_TXQ_TYPE_HIGHPRI) ?
+			     (tx_queue->type & EFX_TXQ_TYPE_HIGHPRI) ?
 			     FFE_BZ_TX_PACE_OFF :
 			     FFE_BZ_TX_PACE_RESERVED);
 	efx_writeo_table(efx, &reg, FR_BZ_TX_PACE_TBL, tx_queue->queue);
@@ -832,13 +834,13 @@ efx_farch_handle_tx_event(struct efx_channel *channel, efx_qword_t *event)
 		tx_ev_desc_ptr = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_DESC_PTR);
 		tx_ev_q_label = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_Q_LABEL);
 		tx_queue = efx_channel_get_tx_queue(
-			channel, tx_ev_q_label % EFX_TXQ_TYPES);
+			channel, tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
 		efx_xmit_done(tx_queue, tx_ev_desc_ptr);
 	} else if (EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_WQ_FF_FULL)) {
 		/* Rewrite the FIFO write pointer */
 		tx_ev_q_label = EFX_QWORD_FIELD(*event, FSF_AZ_TX_EV_Q_LABEL);
 		tx_queue = efx_channel_get_tx_queue(
-			channel, tx_ev_q_label % EFX_TXQ_TYPES);
+			channel, tx_ev_q_label % EFX_MAX_TXQ_PER_CHANNEL);
 
 		netif_tx_lock(efx->net_dev);
 		efx_farch_notify_tx_desc(tx_queue);
@@ -1080,9 +1082,9 @@ efx_farch_handle_tx_flush_done(struct efx_nic *efx, efx_qword_t *event)
 	int qid;
 
 	qid = EFX_QWORD_FIELD(*event, FSF_AZ_DRIVER_EV_SUBDATA);
-	if (qid < EFX_TXQ_TYPES * (efx->n_tx_channels + efx->n_extra_tx_channels)) {
-		tx_queue = efx_get_tx_queue(efx, qid / EFX_TXQ_TYPES,
-					    qid % EFX_TXQ_TYPES);
+	if (qid < EFX_MAX_TXQ_PER_CHANNEL * (efx->n_tx_channels + efx->n_extra_tx_channels)) {
+		tx_queue = efx_get_tx_queue(efx, qid / EFX_MAX_TXQ_PER_CHANNEL,
+					    qid % EFX_MAX_TXQ_PER_CHANNEL);
 		if (atomic_cmpxchg(&tx_queue->flush_outstanding, 1, 0)) {
 			efx_farch_magic_event(tx_queue->channel,
 					      EFX_CHANNEL_MAGIC_TX_DRAIN(tx_queue));
@@ -1675,10 +1677,10 @@ void efx_farch_dimension_resources(struct efx_nic *efx, unsigned sram_lim_qw)
 	 * and the descriptor caches for those channels.
 	 */
 	buftbl_min = ((efx->n_rx_channels * EFX_MAX_DMAQ_SIZE +
-		       total_tx_channels * EFX_TXQ_TYPES * EFX_MAX_DMAQ_SIZE +
+		       total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL * EFX_MAX_DMAQ_SIZE +
 		       efx->n_channels * EFX_MAX_EVQ_SIZE)
 		      * sizeof(efx_qword_t) / EFX_BUF_SIZE);
-	vi_count = max(efx->n_channels, total_tx_channels * EFX_TXQ_TYPES);
+	vi_count = max(efx->n_channels, total_tx_channels * EFX_MAX_TXQ_PER_CHANNEL);
 
 #ifdef CONFIG_SFC_SRIOV
 	if (efx->type->sriov_wanted) {
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index d8a3af86ef78..684471cd7598 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -164,7 +164,7 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_TXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
 						       EFX_BUF_SIZE));
-	bool csum_offload = tx_queue->label & EFX_TXQ_TYPE_OFFLOAD;
+	bool csum_offload = tx_queue->type & EFX_TXQ_TYPE_OFFLOAD;
 	size_t entries = tx_queue->txd.buf.len / EFX_BUF_SIZE;
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 3fd0b59107d1..5a25ef09dcef 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -66,7 +66,8 @@
 #define EFX_TXQ_TYPE_OFFLOAD	1	/* flag */
 #define EFX_TXQ_TYPE_HIGHPRI	2	/* flag */
 #define EFX_TXQ_TYPES		4
-#define EFX_MAX_TX_QUEUES	(EFX_TXQ_TYPES * EFX_MAX_CHANNELS)
+#define EFX_MAX_TXQ_PER_CHANNEL	4
+#define EFX_MAX_TX_QUEUES	(EFX_MAX_TXQ_PER_CHANNEL * EFX_MAX_CHANNELS)
 
 /* Maximum possible MTU the driver supports */
 #define EFX_MAX_MTU (9 * 1024)
@@ -190,6 +191,7 @@ struct efx_tx_buffer {
  * @queue: DMA queue number
  * @label: Label for TX completion events.
  *	Is our index within @channel->tx_queue array.
+ * @type: configuration type of this TX queue.  A bitmask of %EFX_TXQ_TYPE_* flags.
  * @tso_version: Version of TSO in use for this queue.
  * @channel: The associated channel
  * @core_txq: The networking core TX queue structure
@@ -254,6 +256,7 @@ struct efx_tx_queue {
 	struct efx_nic *efx ____cacheline_aligned_in_smp;
 	unsigned int queue;
 	unsigned int label;
+	unsigned int type;
 	unsigned int tso_version;
 	struct efx_channel *channel;
 	struct netdev_queue *core_txq;
@@ -479,6 +482,7 @@ enum efx_sync_events_state {
  * @rx_list: list of SKBs from current RX, awaiting processing
  * @rx_queue: RX queue for this channel
  * @tx_queue: TX queues for this channel
+ * @tx_queue_by_type: pointers into @tx_queue, or %NULL, indexed by txq type
  * @sync_events_state: Current state of sync events on this channel
  * @sync_timestamp_major: Major part of the last ptp sync event
  * @sync_timestamp_minor: Minor part of the last ptp sync event
@@ -540,7 +544,8 @@ struct efx_channel {
 	struct list_head *rx_list;
 
 	struct efx_rx_queue rx_queue;
-	struct efx_tx_queue tx_queue[EFX_TXQ_TYPES];
+	struct efx_tx_queue tx_queue[EFX_MAX_TXQ_PER_CHANNEL];
+	struct efx_tx_queue *tx_queue_by_type[EFX_TXQ_TYPES];
 
 	enum efx_sync_events_state sync_events_state;
 	u32 sync_timestamp_major;
@@ -1200,7 +1205,7 @@ struct efx_udp_tunnel {
  *	a pointer to the &struct efx_msi_context for the channel.
  * @irq_handle_legacy: Handle legacy interrupt.  The @dev_id argument
  *	is a pointer to the &struct efx_nic.
- * @tx_probe: Allocate resources for TX queue
+ * @tx_probe: Allocate resources for TX queue (and select TXQ type)
  * @tx_init: Initialise TX queue on the NIC
  * @tx_remove: Free resources for TX queue
  * @tx_write: Write TX descriptors and doorbell
@@ -1495,14 +1500,6 @@ efx_get_tx_channel(struct efx_nic *efx, unsigned int index)
 	return efx->channel[efx->tx_channel_offset + index];
 }
 
-static inline struct efx_tx_queue *
-efx_get_tx_queue(struct efx_nic *efx, unsigned index, unsigned type)
-{
-	EFX_WARN_ON_ONCE_PARANOID(index >= efx->n_tx_channels ||
-				  type >= efx->tx_queues_per_channel);
-	return &efx->channel[efx->tx_channel_offset + index]->tx_queue[type];
-}
-
 static inline struct efx_channel *
 efx_get_xdp_channel(struct efx_nic *efx, unsigned int index)
 {
@@ -1529,10 +1526,18 @@ static inline unsigned int efx_channel_num_tx_queues(struct efx_channel *channel
 }
 
 static inline struct efx_tx_queue *
-efx_channel_get_tx_queue(struct efx_channel *channel, unsigned type)
+efx_channel_get_tx_queue(struct efx_channel *channel, unsigned int type)
 {
-	EFX_WARN_ON_ONCE_PARANOID(type >= efx_channel_num_tx_queues(channel));
-	return &channel->tx_queue[type];
+	EFX_WARN_ON_ONCE_PARANOID(type >= EFX_TXQ_TYPES);
+	return channel->tx_queue_by_type[type];
+}
+
+static inline struct efx_tx_queue *
+efx_get_tx_queue(struct efx_nic *efx, unsigned int index, unsigned int type)
+{
+	struct efx_channel *channel = efx_get_tx_channel(efx, index);
+
+	return efx_channel_get_tx_queue(channel, type);
 }
 
 /* Iterate over all TX queues belonging to a channel */
diff --git a/drivers/net/ethernet/sfc/ptp.c b/drivers/net/ethernet/sfc/ptp.c
index bea4725a4499..044e3f2637e4 100644
--- a/drivers/net/ethernet/sfc/ptp.c
+++ b/drivers/net/ethernet/sfc/ptp.c
@@ -1085,7 +1085,7 @@ static void efx_ptp_xmit_skb_queue(struct efx_nic *efx, struct sk_buff *skb)
 	struct efx_tx_queue *tx_queue;
 	u8 type = skb->ip_summed == CHECKSUM_PARTIAL ? EFX_TXQ_TYPE_OFFLOAD : 0;
 
-	tx_queue = &ptp_data->channel->tx_queue[type];
+	tx_queue = efx_channel_get_tx_queue(ptp_data->channel, type);
 	if (tx_queue && tx_queue->timestamping) {
 		efx_enqueue_skb(tx_queue, skb);
 	} else {
diff --git a/drivers/net/ethernet/sfc/selftest.c b/drivers/net/ethernet/sfc/selftest.c
index 574856a8a83c..3ec315a0d1bd 100644
--- a/drivers/net/ethernet/sfc/selftest.c
+++ b/drivers/net/ethernet/sfc/selftest.c
@@ -656,7 +656,7 @@ static int efx_test_loopbacks(struct efx_nic *efx, struct efx_self_tests *tests,
 
 		/* Test all enabled types of TX queue */
 		efx_for_each_channel_tx_queue(tx_queue, channel) {
-			state->offload_csum = (tx_queue->label &
+			state->offload_csum = (tx_queue->type &
 					       EFX_TXQ_TYPE_OFFLOAD);
 			rc = efx_test_loopback(tx_queue,
 					       &tests->loopback[mode]);
diff --git a/drivers/net/ethernet/sfc/selftest.h b/drivers/net/ethernet/sfc/selftest.h
index ca88ebb4f6b1..a23f085bf298 100644
--- a/drivers/net/ethernet/sfc/selftest.h
+++ b/drivers/net/ethernet/sfc/selftest.h
@@ -15,8 +15,8 @@
  */
 
 struct efx_loopback_self_tests {
-	int tx_sent[EFX_TXQ_TYPES];
-	int tx_done[EFX_TXQ_TYPES];
+	int tx_sent[EFX_MAX_TXQ_PER_CHANNEL];
+	int tx_done[EFX_MAX_TXQ_PER_CHANNEL];
 	int rx_good;
 	int rx_bad;
 };
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 48d91b26f1a2..b0a08d9f4773 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -527,6 +527,12 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 	}
 
 	tx_queue = efx_get_tx_queue(efx, index, type);
+	if (WARN_ON(!tx_queue))
+		/* We don't have a TXQ of the right type.
+		 * This should never happen, as we don't advertise offload
+		 * features unless we can support them.
+		 */
+		return NETDEV_TX_BUSY;
 
 	return __efx_enqueue_skb(tx_queue, skb);
 }
@@ -577,7 +583,7 @@ void efx_init_tx_queue_core_txq(struct efx_tx_queue *tx_queue)
 	tx_queue->core_txq =
 		netdev_get_tx_queue(efx->net_dev,
 				    tx_queue->channel->channel +
-				    ((tx_queue->label & EFX_TXQ_TYPE_HIGHPRI) ?
+				    ((tx_queue->type & EFX_TXQ_TYPE_HIGHPRI) ?
 				     efx->n_tx_channels : 0));
 }
 
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index f2dac83beb7d..2feff2ead955 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -47,11 +47,12 @@ int efx_probe_tx_queue(struct efx_tx_queue *tx_queue)
 		goto fail1;
 	}
 
-	/* Allocate hardware ring */
+	/* Allocate hardware ring, determine TXQ type */
 	rc = efx_nic_probe_tx(tx_queue);
 	if (rc)
 		goto fail2;
 
+	tx_queue->channel->tx_queue_by_type[tx_queue->type] = tx_queue;
 	return 0;
 
 fail2:
@@ -141,6 +142,7 @@ void efx_remove_tx_queue(struct efx_tx_queue *tx_queue)
 
 	kfree(tx_queue->buffer);
 	tx_queue->buffer = NULL;
+	tx_queue->channel->tx_queue_by_type[tx_queue->type] = NULL;
 }
 
 void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,


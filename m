Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9903C267604
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgIKWkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:40:17 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:38530 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725835AbgIKWkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:40:13 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E2C7460075;
        Fri, 11 Sep 2020 22:40:12 +0000 (UTC)
Received: from us4-mdac16-49.ut7.mdlocal (unknown [10.7.66.16])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E1D7A8009B;
        Fri, 11 Sep 2020 22:40:12 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 5DE7728005C;
        Fri, 11 Sep 2020 22:40:12 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E74FA70006C;
        Fri, 11 Sep 2020 22:40:11 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 23:40:06 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 5/7] sfc: de-indirect TSO handling
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
Message-ID: <c942638a-339a-e564-c915-a89f3f516364@solarflare.com>
Date:   Fri, 11 Sep 2020 23:40:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25660.000
X-TM-AS-Result: No-6.264500-8.000000-10
X-TMASE-MatchedRID: 8t7GO4xSejQJYlnKZc0AV3YZxYoZm58FfLNHMurfykirZHMcVOhFSJVH
        MRn1pNBttIx1NoxidIeV8Dyw8OwGlV5v5rUw2alFalRqQPhHMT56i696PjRPiB3RY4pGTCyHXKZ
        G/c1COwThoEuKzqK2K3DlPghqPnfyYlldA0POS1IaPMGCcVm9DuBefETzWLKxkaEC8FJraL+kWO
        dVsxTLJl1P19T04y0JfuckL5pFTtrxJo5UAYRmgmWnA2xO92UpsKi4EXb8AIpLxCuBTCXaKmWb/
        tULwWnp03juaEic7D8wYDzAfwke0lsMX+cJfRDxzS7qPUhrLiZrTWaGefu3pBqZPM2aqJ5HuVTa
        a+6Dpo+Bp2Bf+q/FPtg0sX6QItLlL47TD00zmvKSvRb8EMdYRXFHqsgruohZSMg2Oe/b8ExRkYT
        SpSslRae6ttAP0e8L9ZMJhb6UpJSRVyw4FNF8Mi0x8J2DopENLyiv/vFzEkQCY1grww+rWb5BEq
        XwSs2UGcEvz580U558RdAlR9lqJrX9jfJpB3pbLIrMljt3adtKRaXN2yYjHv8aP6EIcLWEX4GXu
        3iOKIAPxMUZGIemVVMUL2iZT7XJheTzs+dcqDkL83u6Qud0gMGYhGCkJq+YmyiLZetSf8nJ4y0w
        P1A6AEl4W8WVUOR/joczmuoPCq3Q5J4GDWQJPXMgbarYNt/sYxolUvkE7una0AD4XOCrRhBRx8/
        mOlTu
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--6.264500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599864012-zLtr8Ulp8DE9
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the tx_queue->handle_tso function pointer, and just use
 tx_queue->tso_version to decide which function to call, thus removing
 an indirect call from the fast path.
Instead of passing a tso_v2 flag to efx_mcdi_tx_init(), set the desired
 tx_queue->tso_version before calling it.
In efx_mcdi_tx_init(), report back failure to obtain a TSOv2 context by
 setting tx_queue->tso_version to 0, which will cause the TX path to
 use the GSO-based fallback.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           | 35 +++++++++--------------
 drivers/net/ethernet/sfc/ef100_tx.c       |  9 +++++-
 drivers/net/ethernet/sfc/farch.c          |  2 ++
 drivers/net/ethernet/sfc/mcdi_functions.c |  6 ++--
 drivers/net/ethernet/sfc/mcdi_functions.h |  2 +-
 drivers/net/ethernet/sfc/net_driver.h     |  5 ----
 drivers/net/ethernet/sfc/nic.h            |  4 +++
 drivers/net/ethernet/sfc/tx.c             | 14 +++++++--
 drivers/net/ethernet/sfc/tx_common.c      |  6 +---
 9 files changed, 46 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 1c1bc0dec757..c6507d1f79fe 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -2175,9 +2175,8 @@ static inline void efx_ef10_push_tx_desc(struct efx_tx_queue *tx_queue,
 
 /* Add Firmware-Assisted TSO v2 option descriptors to a queue.
  */
-static int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue,
-				struct sk_buff *skb,
-				bool *data_mapped)
+int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			 bool *data_mapped)
 {
 	struct efx_tx_buffer *buffer;
 	struct tcphdr *tcp;
@@ -2266,7 +2265,6 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
 	struct efx_ef10_nic_data *nic_data;
-	bool tso_v2 = false;
 	efx_qword_t *txd;
 	int rc;
 
@@ -2289,15 +2287,18 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 	 * TSOv2 cannot be used with Hardware timestamping, and is never needed
 	 * for XDP tx.
 	 */
-	if ((csum_offload || inner_csum) && (nic_data->datapath_caps2 &
-			(1 << MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_LBN)) &&
-	    !tx_queue->timestamping && !tx_queue->xdp_tx) {
-		tso_v2 = true;
-		netif_dbg(efx, hw, efx->net_dev, "Using TSOv2 for channel %u\n",
-				channel->channel);
+	if (efx_has_cap(efx, TX_TSO_V2)) {
+		if ((csum_offload || inner_csum) &&
+		    !tx_queue->timestamping && !tx_queue->xdp_tx) {
+			tx_queue->tso_version = 2;
+			netif_dbg(efx, hw, efx->net_dev, "Using TSOv2 for channel %u\n",
+				  channel->channel);
+		}
+	} else if (efx_has_cap(efx, TX_TSO)) {
+		tx_queue->tso_version = 1;
 	}
 
-	rc = efx_mcdi_tx_init(tx_queue, tso_v2);
+	rc = efx_mcdi_tx_init(tx_queue);
 	if (rc)
 		goto fail;
 
@@ -2315,20 +2316,12 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 			     ESF_DZ_TX_OPTION_TYPE,
 			     ESE_DZ_TX_OPTION_DESC_CRC_CSUM,
 			     ESF_DZ_TX_OPTION_UDP_TCP_CSUM, csum_offload,
-			     ESF_DZ_TX_OPTION_IP_CSUM, csum_offload && !tso_v2,
+			     ESF_DZ_TX_OPTION_IP_CSUM, csum_offload && tx_queue->tso_version != 2,
 			     ESF_DZ_TX_OPTION_INNER_UDP_TCP_CSUM, inner_csum,
-			     ESF_DZ_TX_OPTION_INNER_IP_CSUM, inner_csum && !tso_v2,
+			     ESF_DZ_TX_OPTION_INNER_IP_CSUM, inner_csum && tx_queue->tso_version != 2,
 			     ESF_DZ_TX_TIMESTAMP, tx_queue->timestamping);
 	tx_queue->write_count = 1;
 
-	if (tso_v2) {
-		tx_queue->handle_tso = efx_ef10_tx_tso_desc;
-		tx_queue->tso_version = 2;
-	} else if (nic_data->datapath_caps &
-			(1 << MC_CMD_GET_CAPABILITIES_OUT_TX_TSO_LBN)) {
-		tx_queue->tso_version = 1;
-	}
-
 	wmb();
 	efx_ef10_push_tx_desc(tx_queue, txd);
 
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index ef9c2e879499..a90e5a9d2a37 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -37,7 +37,14 @@ void ef100_tx_init(struct efx_tx_queue *tx_queue)
 				    tx_queue->channel->channel -
 				    tx_queue->efx->tx_channel_offset);
 
-	if (efx_mcdi_tx_init(tx_queue, false))
+	/* This value is purely documentational; as EF100 never passes through
+	 * the switch statement in tx.c:__efx_enqueue_skb(), that switch does
+	 * not handle case 3.  EF100's TSOv3 descriptors are generated by
+	 * ef100_make_tso_desc().
+	 * Meanwhile, all efx_mcdi_tx_init() cares about is that it's not 2.
+	 */
+	tx_queue->tso_version = 3;
+	if (efx_mcdi_tx_init(tx_queue))
 		netdev_WARN(tx_queue->efx->net_dev,
 			    "failed to initialise TXQ %d\n", tx_queue->queue);
 }
diff --git a/drivers/net/ethernet/sfc/farch.c b/drivers/net/ethernet/sfc/farch.c
index bb5c45a0291b..d75cf5ff5686 100644
--- a/drivers/net/ethernet/sfc/farch.c
+++ b/drivers/net/ethernet/sfc/farch.c
@@ -415,6 +415,8 @@ void efx_farch_tx_init(struct efx_tx_queue *tx_queue)
 			     FFE_BZ_TX_PACE_OFF :
 			     FFE_BZ_TX_PACE_RESERVED);
 	efx_writeo_table(efx, &reg, FR_BZ_TX_PACE_TBL, tx_queue->queue);
+
+	tx_queue->tso_version = 1;
 }
 
 static void efx_farch_flush_tx_queue(struct efx_tx_queue *tx_queue)
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index 58582a0a42e4..d3e6d8239f5c 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -160,7 +160,7 @@ void efx_mcdi_ev_fini(struct efx_channel *channel)
 			       outbuf, outlen, rc);
 }
 
-int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
+int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue)
 {
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_TXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
 						       EFX_BUF_SIZE));
@@ -195,6 +195,8 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 	inlen = MC_CMD_INIT_TXQ_IN_LEN(entries);
 
 	do {
+		bool tso_v2 = tx_queue->tso_version == 2;
+
 		/* TSOv2 implies IP header checksum offload for TSO frames,
 		 * so we can safely disable IP header checksum offload for
 		 * everything else.  If we don't have TSOv2, then we have to
@@ -217,7 +219,7 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 					NULL, 0, NULL);
 		if (rc == -ENOSPC && tso_v2) {
 			/* Retry without TSOv2 if we're short on contexts. */
-			tso_v2 = false;
+			tx_queue->tso_version = 0;
 			netif_warn(efx, probe, efx->net_dev,
 				   "TSOv2 context not available to segment in "
 				   "hardware. TCP performance may be reduced.\n"
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.h b/drivers/net/ethernet/sfc/mcdi_functions.h
index 687be8b00cd8..b0e2f53a0d9b 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.h
+++ b/drivers/net/ethernet/sfc/mcdi_functions.h
@@ -19,7 +19,7 @@ int efx_mcdi_ev_probe(struct efx_channel *channel);
 int efx_mcdi_ev_init(struct efx_channel *channel, bool v1_cut_thru, bool v2);
 void efx_mcdi_ev_remove(struct efx_channel *channel);
 void efx_mcdi_ev_fini(struct efx_channel *channel);
-int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2);
+int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue);
 void efx_mcdi_tx_remove(struct efx_tx_queue *tx_queue);
 void efx_mcdi_tx_fini(struct efx_tx_queue *tx_queue);
 int efx_mcdi_rx_probe(struct efx_rx_queue *rx_queue);
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index ed444e1274ae..ddcd1c46e3f3 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -208,8 +208,6 @@ struct efx_tx_buffer {
  * @initialised: Has hardware queue been initialised?
  * @timestamping: Is timestamping enabled for this channel?
  * @xdp_tx: Is this an XDP tx queue?
- * @handle_tso: TSO xmit preparation handler.  Sets up the TSO metadata and
- *	may also map tx data, depending on the nature of the TSO implementation.
  * @read_count: Current read pointer.
  *	This is the number of buffers that have been removed from both rings.
  * @old_write_count: The value of @write_count when last checked.
@@ -272,9 +270,6 @@ struct efx_tx_queue {
 	bool timestamping;
 	bool xdp_tx;
 
-	/* Function pointers used in the fast path. */
-	int (*handle_tso)(struct efx_tx_queue*, struct sk_buff*, bool *);
-
 	/* Members used mainly on the completion path */
 	unsigned int read_count ____cacheline_aligned_in_smp;
 	unsigned int old_write_count;
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index 724e2776b585..5c2fe3ce3f4d 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -297,6 +297,10 @@ struct efx_ef10_nic_data {
 	u64 licensed_features;
 };
 
+/* TSOv2 */
+int efx_ef10_tx_tso_desc(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			 bool *data_mapped);
+
 int efx_init_sriov(void);
 void efx_fini_sriov(void);
 
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 13e960b23de8..1665529a7271 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -338,8 +338,18 @@ netdev_tx_t __efx_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb
 	 * size limit.
 	 */
 	if (segments) {
-		EFX_WARN_ON_ONCE_PARANOID(!tx_queue->handle_tso);
-		rc = tx_queue->handle_tso(tx_queue, skb, &data_mapped);
+		switch (tx_queue->tso_version) {
+		case 1:
+			rc = efx_enqueue_skb_tso(tx_queue, skb, &data_mapped);
+			break;
+		case 2:
+			rc = efx_ef10_tx_tso_desc(tx_queue, skb, &data_mapped);
+			break;
+		case 0: /* No TSO on this queue, SW fallback needed */
+		default:
+			rc = -EINVAL;
+			break;
+		}
 		if (rc == -EINVAL) {
 			rc = efx_tx_tso_fallback(tx_queue, skb);
 			tx_queue->tso_fallbacks++;
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 2feff2ead955..d530cde2b864 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -86,11 +86,7 @@ void efx_init_tx_queue(struct efx_tx_queue *tx_queue)
 	tx_queue->completed_timestamp_minor = 0;
 
 	tx_queue->xdp_tx = efx_channel_is_xdp_tx(tx_queue->channel);
-
-	/* Set up default function pointers. These may get replaced by
-	 * efx_nic_init_tx() based off NIC/queue capabilities.
-	 */
-	tx_queue->handle_tso = efx_enqueue_skb_tso;
+	tx_queue->tso_version = 0;
 
 	/* Set up TX descriptor ring */
 	efx_nic_init_tx(tx_queue);


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAB6821296A
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbgGBQ3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:29:36 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:50568 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726297AbgGBQ3f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jul 2020 12:29:35 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 03DEA600CB;
        Thu,  2 Jul 2020 16:29:35 +0000 (UTC)
Received: from us4-mdac16-28.ut7.mdlocal (unknown [10.7.66.60])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 02E9C200A4;
        Thu,  2 Jul 2020 16:29:35 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.41])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6E7E3220059;
        Thu,  2 Jul 2020 16:29:33 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id F10AA4C005C;
        Thu,  2 Jul 2020 16:29:32 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 2 Jul 2020
 17:29:27 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 05/16] sfc: make tx_queues_per_channel variable at
 runtime
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Message-ID: <fdd3c3f2-4af3-4058-e444-49e33031223a@solarflare.com>
Date:   Thu, 2 Jul 2020 17:29:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25516.003
X-TM-AS-Result: No-2.853900-8.000000-10
X-TMASE-MatchedRID: dRrPFMSZPgoTDYs1l+XMYlMsVuL5ry7doPPOu2yMJlO4yGjDjCUdsOyX
        VVRcznlrm1pAgWBXqew48TTAWxwTHKH2g9syPs888Kg68su2wyGqdpuEuCeGaB1rVWTdGrE4cij
        MZrr2iZ2t2gtuWr1Lmtr+D80ZNbcyQWUWXBoRfKEHz0YoejTedldEEmf6TRVBqPGqHIPGZiOwlb
        KVOflASVJmf72lDuOXg7jRE4b9tCu4YfyCujuUkbi7edL7cQQOYBbaP1VZzSWfuM4lD6uC8Zegn
        c+D+O7x6rB2tJvSXOUrdEKOY+7gNm8BU9XGR8QhvmT2VURehlqSiza26cvwNBw0HKhKjTfpNaRg
        Q20sMyK5bSUGOBST56LohLeXh39keFDEh6W6+oiSK+CVypgnQsCY5/Mqi1OiUjFJwpdmcrRUEQD
        v9DmuWuLzNWBegCW2RYvisGWbbS+No+PRbWqfRKu+08oqCcwYDkICk3N463nyJRAwCDTz0MYfVh
        35WIsgvOFSxTlDYHeYB5kWCDE3IylwA1dDKfSc0j/EbEvpbLPegf8AQx6f+nbD271RjilbkERyu
        RHFgnhSMqc7UpUorBKRsPC6bTvOqrQxXydIwG+dGcx97VaKlFZca9RSYo/b
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-2.853900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25516.003
X-MDID: 1593707373-riDxr_TnkJ7o
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Siena needs four TX queues (csum * highpri), EF10 needs two (csum),
 and EF100 only needs one (as checksumming is controlled entirely by
 the transmit descriptor).  Rather than having various bits of ad-hoc
 code to decide which queues to set up etc., put the knowledge of how
 many TXQs a channel has in one place.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c         | 13 +++++-----
 drivers/net/ethernet/sfc/efx_channels.c |  4 +--
 drivers/net/ethernet/sfc/efx_common.c   |  1 +
 drivers/net/ethernet/sfc/net_driver.h   | 34 ++++++++++---------------
 drivers/net/ethernet/sfc/siena.c        |  1 +
 drivers/net/ethernet/sfc/tx.c           |  8 ++++--
 6 files changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 88522b683cc7..be15640c160a 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -600,6 +600,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
 	 * However, until we use TX option descriptors we need two TX queues
 	 * per channel.
 	 */
+	efx->tx_queues_per_channel = 2;
 	efx->max_vis = efx_ef10_mem_map_size(efx) / efx->vi_stride;
 	if (!efx->max_vis) {
 		netif_err(efx, drv, efx->net_dev, "error determining max VIs\n");
@@ -607,7 +608,7 @@ static int efx_ef10_probe(struct efx_nic *efx)
 		goto fail5;
 	}
 	efx->max_channels = min_t(unsigned int, EFX_MAX_CHANNELS,
-				  efx->max_vis / EFX_TXQ_TYPES);
+				  efx->max_vis / efx->tx_queues_per_channel);
 	efx->max_tx_channels = efx->max_channels;
 	if (WARN_ON(efx->max_channels == 0)) {
 		rc = -EIO;
@@ -1120,17 +1121,17 @@ static int efx_ef10_alloc_vis(struct efx_nic *efx,
  */
 static int efx_ef10_dimension_resources(struct efx_nic *efx)
 {
+	unsigned int min_vis = max_t(unsigned int, efx->tx_queues_per_channel,
+				     efx_separate_tx_channels ? 2 : 1);
+	unsigned int channel_vis, pio_write_vi_base, max_vis;
 	struct efx_ef10_nic_data *nic_data = efx->nic_data;
 	unsigned int uc_mem_map_size, wc_mem_map_size;
-	unsigned int min_vis = max(EFX_TXQ_TYPES,
-				   efx_separate_tx_channels ? 2 : 1);
-	unsigned int channel_vis, pio_write_vi_base, max_vis;
 	void __iomem *membase;
 	int rc;
 
 	channel_vis = max(efx->n_channels,
 			  ((efx->n_tx_channels + efx->n_extra_tx_channels) *
-			   EFX_TXQ_TYPES) +
+			   efx->tx_queues_per_channel) +
 			   efx->n_xdp_channels * efx->xdp_tx_per_channel);
 	if (efx->max_vis && efx->max_vis < channel_vis) {
 		netif_dbg(efx, drv, efx->net_dev,
@@ -1219,7 +1220,7 @@ static int efx_ef10_dimension_resources(struct efx_nic *efx)
 		 */
 		efx->max_channels = nic_data->n_allocated_vis;
 		efx->max_tx_channels =
-			nic_data->n_allocated_vis / EFX_TXQ_TYPES;
+			nic_data->n_allocated_vis / efx->tx_queues_per_channel;
 
 		efx_mcdi_free_vis(efx);
 		return -EAGAIN;
diff --git a/drivers/net/ethernet/sfc/efx_channels.c b/drivers/net/ethernet/sfc/efx_channels.c
index 466257b9abbf..c3edebf523b6 100644
--- a/drivers/net/ethernet/sfc/efx_channels.c
+++ b/drivers/net/ethernet/sfc/efx_channels.c
@@ -726,7 +726,7 @@ void efx_remove_channel(struct efx_channel *channel)
 
 	efx_for_each_channel_rx_queue(rx_queue, channel)
 		efx_remove_rx_queue(rx_queue);
-	efx_for_each_possible_channel_tx_queue(tx_queue, channel)
+	efx_for_each_channel_tx_queue(tx_queue, channel)
 		efx_remove_tx_queue(tx_queue);
 	efx_remove_eventq(channel);
 	channel->type->post_remove(channel);
@@ -1090,7 +1090,7 @@ void efx_stop_channels(struct efx_nic *efx)
 	efx_for_each_channel(channel, efx) {
 		efx_for_each_channel_rx_queue(rx_queue, channel)
 			efx_fini_rx_queue(rx_queue);
-		efx_for_each_possible_channel_tx_queue(tx_queue, channel)
+		efx_for_each_channel_tx_queue(tx_queue, channel)
 			efx_fini_tx_queue(tx_queue);
 	}
 }
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 26dca2f9a363..c84123456c01 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1036,6 +1036,7 @@ int efx_init_struct(struct efx_nic *efx,
 	INIT_WORK(&efx->mac_work, efx_mac_work);
 	init_waitqueue_head(&efx->flush_wq);
 
+	efx->tx_queues_per_channel = 1;
 	efx->rxq_entries = EFX_DEFAULT_DMAQ_SIZE;
 	efx->txq_entries = EFX_DEFAULT_DMAQ_SIZE;
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index e536c1e12f86..4ded155b12e9 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -867,6 +867,7 @@ struct efx_async_filter_insertion {
  * @n_rx_channels: Number of channels used for RX (= number of RX queues)
  * @n_tx_channels: Number of channels used for TX
  * @n_extra_tx_channels: Number of extra channels with TX queues
+ * @tx_queues_per_channel: number of TX queues probed on each channel
  * @n_xdp_channels: Number of channels used for XDP TX
  * @xdp_channel_offset: Offset of zeroth channel used for XPD TX.
  * @xdp_tx_per_channel: Max number of TX queues on an XDP TX channel.
@@ -1031,6 +1032,7 @@ struct efx_nic {
 	unsigned tx_channel_offset;
 	unsigned n_tx_channels;
 	unsigned n_extra_tx_channels;
+	unsigned int tx_queues_per_channel;
 	unsigned int n_xdp_channels;
 	unsigned int xdp_channel_offset;
 	unsigned int xdp_tx_per_channel;
@@ -1529,7 +1531,7 @@ static inline struct efx_tx_queue *
 efx_get_tx_queue(struct efx_nic *efx, unsigned index, unsigned type)
 {
 	EFX_WARN_ON_ONCE_PARANOID(index >= efx->n_tx_channels ||
-				  type >= EFX_TXQ_TYPES);
+				  type >= efx->tx_queues_per_channel);
 	return &efx->channel[efx->tx_channel_offset + index]->tx_queue[type];
 }
 
@@ -1551,18 +1553,18 @@ static inline bool efx_channel_has_tx_queues(struct efx_channel *channel)
 	return true;
 }
 
-static inline struct efx_tx_queue *
-efx_channel_get_tx_queue(struct efx_channel *channel, unsigned type)
+static inline unsigned int efx_channel_num_tx_queues(struct efx_channel *channel)
 {
-	EFX_WARN_ON_ONCE_PARANOID(!efx_channel_has_tx_queues(channel) ||
-				  type >= EFX_TXQ_TYPES);
-	return &channel->tx_queue[type];
+	if (efx_channel_is_xdp_tx(channel))
+		return channel->efx->xdp_tx_per_channel;
+	return channel->efx->tx_queues_per_channel;
 }
 
-static inline bool efx_tx_queue_used(struct efx_tx_queue *tx_queue)
+static inline struct efx_tx_queue *
+efx_channel_get_tx_queue(struct efx_channel *channel, unsigned type)
 {
-	return !(tx_queue->efx->net_dev->num_tc < 2 &&
-		 tx_queue->queue & EFX_TXQ_TYPE_HIGHPRI);
+	EFX_WARN_ON_ONCE_PARANOID(type >= efx_channel_num_tx_queues(channel));
+	return &channel->tx_queue[type];
 }
 
 /* Iterate over all TX queues belonging to a channel */
@@ -1571,18 +1573,8 @@ static inline bool efx_tx_queue_used(struct efx_tx_queue *tx_queue)
 		;							\
 	else								\
 		for (_tx_queue = (_channel)->tx_queue;			\
-		     _tx_queue < (_channel)->tx_queue + EFX_TXQ_TYPES && \
-			     (efx_tx_queue_used(_tx_queue) ||            \
-			      efx_channel_is_xdp_tx(_channel));		\
-		     _tx_queue++)
-
-/* Iterate over all possible TX queues belonging to a channel */
-#define efx_for_each_possible_channel_tx_queue(_tx_queue, _channel)	\
-	if (!efx_channel_has_tx_queues(_channel))			\
-		;							\
-	else								\
-		for (_tx_queue = (_channel)->tx_queue;			\
-		     _tx_queue < (_channel)->tx_queue + EFX_TXQ_TYPES;	\
+		     _tx_queue < (_channel)->tx_queue +			\
+				 efx_channel_num_tx_queues(_channel);		\
 		     _tx_queue++)
 
 static inline bool efx_channel_has_rx_queue(struct efx_channel *channel)
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index e438853f64a3..4c5881a3bfe4 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -279,6 +279,7 @@ static int siena_probe_nic(struct efx_nic *efx)
 	efx->max_channels = EFX_MAX_CHANNELS;
 	efx->max_vis = EFX_MAX_CHANNELS;
 	efx->max_tx_channels = EFX_MAX_CHANNELS;
+	efx->tx_queues_per_channel = 2;
 
 	efx_reado(efx, &reg, FR_AZ_CS_DEBUG);
 	efx->port_num = EFX_OWORD_FIELD(reg, FRF_CZ_CS_PORT_NUM) - 1;
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index ed20f6aef435..76ff394f5b58 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -569,6 +569,10 @@ int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
 	if (type != TC_SETUP_QDISC_MQPRIO)
 		return -EOPNOTSUPP;
 
+	/* Only Siena supported highpri queues */
+	if (efx_nic_rev(efx) > EFX_REV_SIENA_A0)
+		return -EOPNOTSUPP;
+
 	num_tc = mqprio->num_tc;
 
 	if (num_tc > EFX_MAX_TX_TC)
@@ -585,10 +589,10 @@ int efx_setup_tc(struct net_device *net_dev, enum tc_setup_type type,
 	}
 
 	if (num_tc > net_dev->num_tc) {
+		efx->tx_queues_per_channel = 4;
 		/* Initialise high-priority queues as necessary */
 		efx_for_each_channel(channel, efx) {
-			efx_for_each_possible_channel_tx_queue(tx_queue,
-							       channel) {
+			efx_for_each_channel_tx_queue(tx_queue, channel) {
 				if (!(tx_queue->queue & EFX_TXQ_TYPE_HIGHPRI))
 					continue;
 				if (!tx_queue->buffer) {


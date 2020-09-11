Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 915DD267602
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 00:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725931AbgIKWjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 18:39:40 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:36180 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725835AbgIKWjj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 18:39:39 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 0961660077;
        Fri, 11 Sep 2020 22:39:39 +0000 (UTC)
Received: from us4-mdac16-39.ut7.mdlocal (unknown [10.7.66.158])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 07E0F2009B;
        Fri, 11 Sep 2020 22:39:39 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 8B2B9220059;
        Fri, 11 Sep 2020 22:39:38 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1F5E2480055;
        Fri, 11 Sep 2020 22:39:38 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Fri, 11 Sep
 2020 23:39:32 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH v2 net-next 3/7] sfc: create inner-csum queues on EF10 if
 supported
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <kuba@kernel.org>, <netdev@vger.kernel.org>
References: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
Message-ID: <119f680d-ece7-4de0-0a3c-33c63e7fbf27@solarflare.com>
Date:   Fri, 11 Sep 2020 23:39:28 +0100
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
X-TM-AS-Result: No-10.788400-8.000000-10
X-TMASE-MatchedRID: 3EjmIZf/JJaescXXGhKTEtUcSZdVkdtzeouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsEfGzuoVn0Vs6PQi9XuOWoOHI/MxNRI7UkCWlWR223da4txMagbN9/PK1mtSCXczSRyIV
        QA/DQ+LfWFw/8OOzxY9duMC+Y92vEGAjMJH/qe440OtJVkKBtK6Iik2/euMx1JnrjDUkDicaklr
        f/qUIG98ygz/0VjAwgtH/hnKtNt9xyH03Lph54Ugw5bFG3LCD6F9s8UTYYetUOkJQR4QWbsITXW
        +ul2mssR39tYegAepLKPsWbRi6i9Li4AdylWPIwINIXjO/Augo1TzP60UkdHR9W4auM/sn0dwHJ
        RSBif9XnSPfNXQ5Pb126LUCaK45J+vbnY9M6ab8gCPGiZqtI8C3Pi/Xo8BzmIS2LNsBlD7HZULV
        BYooo+vteZaevWy/2ZYVRfQNSbCkOn8Q2HyyWwJ4CIKY/Hg3AtOt1ofVlaoLWRN8STJpl3PoLR4
        +zsDTtyMdyHKes7lu3nQXe/p+Bvyn4qgNlq/QWpCXxFT0a0StzBTlrNH8SIA==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--10.788400-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25660.000
X-MDID: 1599863979-eksdDUbmuLta
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the MC reports the VXLAN_NVGRE datapath capability, then these queues
 can be used for checksum offload of encapsulated packets.

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ef10.c           | 23 ++++++++++++++++-------
 drivers/net/ethernet/sfc/mcdi_functions.c | 16 ++++++++++++----
 2 files changed, 28 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
index 2ae85d3aa4b2..1c1bc0dec757 100644
--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -601,10 +601,14 @@ static int efx_ef10_probe(struct efx_nic *efx)
 	efx_ef10_read_licensed_features(efx);
 
 	/* We can have one VI for each vi_stride-byte region.
-	 * However, until we use TX option descriptors we need two TX queues
-	 * per channel.
+	 * However, until we use TX option descriptors we need up to four
+	 * TX queues per channel for different checksumming combinations.
 	 */
-	efx->tx_queues_per_channel = 2;
+	if (nic_data->datapath_caps &
+	    (1 << MC_CMD_GET_CAPABILITIES_OUT_VXLAN_NVGRE_LBN))
+		efx->tx_queues_per_channel = 4;
+	else
+		efx->tx_queues_per_channel = 2;
 	efx->max_vis = efx_ef10_mem_map_size(efx) / efx->vi_stride;
 	if (!efx->max_vis) {
 		netif_err(efx, drv, efx->net_dev, "error determining max VIs\n");
@@ -2146,7 +2150,9 @@ static int efx_ef10_irq_test_generate(struct efx_nic *efx)
 
 static int efx_ef10_tx_probe(struct efx_tx_queue *tx_queue)
 {
-	tx_queue->type = tx_queue->label & EFX_TXQ_TYPE_OUTER_CSUM;
+	/* low two bits of label are what we want for type */
+	BUILD_BUG_ON((EFX_TXQ_TYPE_OUTER_CSUM | EFX_TXQ_TYPE_INNER_CSUM) != 3);
+	tx_queue->type = tx_queue->label & 3;
 	return efx_nic_alloc_buffer(tx_queue->efx, &tx_queue->txd.buf,
 				    (tx_queue->ptr_mask + 1) *
 				    sizeof(efx_qword_t),
@@ -2256,6 +2262,7 @@ static u32 efx_ef10_tso_versions(struct efx_nic *efx)
 static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 {
 	bool csum_offload = tx_queue->type & EFX_TXQ_TYPE_OUTER_CSUM;
+	bool inner_csum = tx_queue->type & EFX_TXQ_TYPE_INNER_CSUM;
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
 	struct efx_ef10_nic_data *nic_data;
@@ -2282,7 +2289,7 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 	 * TSOv2 cannot be used with Hardware timestamping, and is never needed
 	 * for XDP tx.
 	 */
-	if (csum_offload && (nic_data->datapath_caps2 &
+	if ((csum_offload || inner_csum) && (nic_data->datapath_caps2 &
 			(1 << MC_CMD_GET_CAPABILITIES_V2_OUT_TX_TSO_V2_LBN)) &&
 	    !tx_queue->timestamping && !tx_queue->xdp_tx) {
 		tso_v2 = true;
@@ -2303,12 +2310,14 @@ static void efx_ef10_tx_init(struct efx_tx_queue *tx_queue)
 	tx_queue->buffer[0].flags = EFX_TX_BUF_OPTION;
 	tx_queue->insert_count = 1;
 	txd = efx_tx_desc(tx_queue, 0);
-	EFX_POPULATE_QWORD_5(*txd,
+	EFX_POPULATE_QWORD_7(*txd,
 			     ESF_DZ_TX_DESC_IS_OPT, true,
 			     ESF_DZ_TX_OPTION_TYPE,
 			     ESE_DZ_TX_OPTION_DESC_CRC_CSUM,
 			     ESF_DZ_TX_OPTION_UDP_TCP_CSUM, csum_offload,
-			     ESF_DZ_TX_OPTION_IP_CSUM, csum_offload,
+			     ESF_DZ_TX_OPTION_IP_CSUM, csum_offload && !tso_v2,
+			     ESF_DZ_TX_OPTION_INNER_UDP_TCP_CSUM, inner_csum,
+			     ESF_DZ_TX_OPTION_INNER_IP_CSUM, inner_csum && !tso_v2,
 			     ESF_DZ_TX_TIMESTAMP, tx_queue->timestamping);
 	tx_queue->write_count = 1;
 
diff --git a/drivers/net/ethernet/sfc/mcdi_functions.c b/drivers/net/ethernet/sfc/mcdi_functions.c
index c80246e6dee8..58582a0a42e4 100644
--- a/drivers/net/ethernet/sfc/mcdi_functions.c
+++ b/drivers/net/ethernet/sfc/mcdi_functions.c
@@ -165,6 +165,7 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 	MCDI_DECLARE_BUF(inbuf, MC_CMD_INIT_TXQ_IN_LEN(EFX_MAX_DMAQ_SIZE * 8 /
 						       EFX_BUF_SIZE));
 	bool csum_offload = tx_queue->type & EFX_TXQ_TYPE_OUTER_CSUM;
+	bool inner_csum = tx_queue->type & EFX_TXQ_TYPE_INNER_CSUM;
 	size_t entries = tx_queue->txd.buf.len / EFX_BUF_SIZE;
 	struct efx_channel *channel = tx_queue->channel;
 	struct efx_nic *efx = tx_queue->efx;
@@ -194,16 +195,23 @@ int efx_mcdi_tx_init(struct efx_tx_queue *tx_queue, bool tso_v2)
 	inlen = MC_CMD_INIT_TXQ_IN_LEN(entries);
 
 	do {
-		MCDI_POPULATE_DWORD_4(inbuf, INIT_TXQ_IN_FLAGS,
+		/* TSOv2 implies IP header checksum offload for TSO frames,
+		 * so we can safely disable IP header checksum offload for
+		 * everything else.  If we don't have TSOv2, then we have to
+		 * enable IP header checksum offload, which is strictly
+		 * incorrect but better than breaking TSO.
+		 */
+		MCDI_POPULATE_DWORD_6(inbuf, INIT_TXQ_IN_FLAGS,
 				/* This flag was removed from mcdi_pcol.h for
 				 * the non-_EXT version of INIT_TXQ.  However,
 				 * firmware still honours it.
 				 */
 				INIT_TXQ_EXT_IN_FLAG_TSOV2_EN, tso_v2,
-				INIT_TXQ_IN_FLAG_IP_CSUM_DIS, !csum_offload,
+				INIT_TXQ_IN_FLAG_IP_CSUM_DIS, !(csum_offload && tso_v2),
 				INIT_TXQ_IN_FLAG_TCP_CSUM_DIS, !csum_offload,
-				INIT_TXQ_EXT_IN_FLAG_TIMESTAMP,
-						tx_queue->timestamping);
+				INIT_TXQ_EXT_IN_FLAG_TIMESTAMP, tx_queue->timestamping,
+				INIT_TXQ_IN_FLAG_INNER_IP_CSUM_EN, inner_csum && !tso_v2,
+				INIT_TXQ_IN_FLAG_INNER_TCP_CSUM_EN, inner_csum);
 
 		rc = efx_mcdi_rpc_quiet(efx, MC_CMD_INIT_TXQ, inbuf, inlen,
 					NULL, 0, NULL);


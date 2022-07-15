Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A3735761D1
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234531AbiGOMgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:36:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234491AbiGOMgX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:36:23 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2069.outbound.protection.outlook.com [40.107.243.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 659DE70985
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:36:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dEfkOqBXnbLItVdvSjIgvlcDbnd41yHxdxX/GpX+gc6MiwvRSFD4Kf+v0j2DpUWwFo6Cismg3SNje5eQnH3MqsQl4P0A+hkRLchiPr9cTvqT9Pqkb1k6QVLGN4RjxEoI8HUvaQla5gUnuebOP8+ySVun1Hw6ObxX/5yt0UOikKVWuAvboOcFsHXF3OHxN2vZ3QAfWL9YmLrPpqd0qYRDyVtrzoXqCkaeDMOb0ZO80RRNzA0GTi9YWLjm+FzVaubzJjLweKKVQLMOiCL4nhmDJgB9CVvuu21mmxuOh6MrXuc2BB4W+YKsawPaXiDD+TWE/MAHymNdHpwxYWNHFaRA2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wBs07lQS2eEZjFLo9Ma4b3b1gtg3Yv6h/bOO1tsoHtA=;
 b=a5vnY97fklxUifLWxvlKBc8o1Gpqp9PGwl9PVd3fgl7gxRwhabR9q4p9Q4hPVtdiWhbQkRhQbeRXgLFm+cjZJGQOL7KS7MRC/NJ2PlkRRkGUBMXF2yaEccTV0WUR0i1/L/yLqvHANPQCUxwtfymCMgO/9Uls7syvm7/7yX4sdjeaastJ9b5X+Rpsl3v4Od076tbBUBLnzw7hjM7YzKnWXQ880nJIfGuBZ9UJB1cEspV/loXi/OBIYlLoLk1uCL0hRE1H3g9PQ9B6MM5kgxA/gJqjjcwq54siBgYXzjV1dhVbn8LJapBFcG/aaFeROu60mv94ZUhQmLcya3hZgxcivQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wBs07lQS2eEZjFLo9Ma4b3b1gtg3Yv6h/bOO1tsoHtA=;
 b=KQdZlCbgHU6R7V+wD6mf17/z8WRcEs/93JWNxMomYZ3i1QaECtwMQHioFEiSwJCtas/TitGsDliUv9awm7bQGDTodOLYkNKanV0nZGv9EB3iiJj2Fz61NIWxiURGm3D0QrUp9O4qmI9jXTizcJl2x+bO7hGzSle/cPSJK5mhJKVUuV8UjBfl+pjO8cIv8uxeqBeQGMpj+5uqXUnHYmKzwzbmstHMRij42rnxozbikFpXGjXQtJubliS/feg9Hq2UmyVdbHWskumwptnBWa7DoKRKdHZIaOMnLWSGI6feL2qQXQFhULu45gyO2/lnhBgI1W7svRdzhmDgYZJfScplog==
Received: from BN9PR03CA0191.namprd03.prod.outlook.com (2603:10b6:408:f9::16)
 by BN6PR1201MB2483.namprd12.prod.outlook.com (2603:10b6:404:a6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 12:36:19 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f9:cafe::f4) by BN9PR03CA0191.outlook.office365.com
 (2603:10b6:408:f9::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.22 via Frontend
 Transport; Fri, 15 Jul 2022 12:36:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 12:36:18 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:36:18 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 05:36:17 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 15 Jul 2022 07:36:16 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 08/10] sfc: support passing a representor to the EF100 TX path
Date:   Fri, 15 Jul 2022 13:33:30 +0100
Message-ID: <d1002e0511e7fbd1204cfe9bca3318599750139f.1657878101.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1657878101.git.ecree.xilinx@gmail.com>
References: <cover.1657878101.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 66382ea6-f456-4dd0-9900-08da665e9ded
X-MS-TrafficTypeDiagnostic: BN6PR1201MB2483:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xyQIkhhgPm1P41ZeYAZZffEWj8VnoVPeMg0XpvxSNSaUJqM+fexHHE/BidD/CQLZbvWkDsZZz2fBJiinYNgu8SjIfjILuAoxQLt5tt9BPoL0qivjybi3kqAst4AJyULs55dEwEzmYVDfjWEqD2hZG9tZL83NHu6YyxdP7ws9O9JC9Q8iF2Y4zRi4rLSVgWwVFrsnEP3ng7fZBnzgqC16lMQBSCNCaqHkQ5iQhOSAVTySpLqvApfcgVeFzutmtVh9o6illlMkXCIwJigpACyTFedpv/9B6AUnx477iQ6InClD+X3zjCprynj1wQxoHiUFw5OXXUssbbf34NO1heLTNC9zRj0qLC0VI0je6rDvrRhPAIQMuVr6VhfStAGFNFSUwx6OF/8+SCEobg2gSExhz2CbqAiCUr91s9lJfqaHKkSQyIMbo7ijw0kvHROBCFhHH1Mq98X1OI7jLXOn9EI6N8ew5GtQ4HHFlEQpRLM1WQ+mxztDqMcplS/tfJqjhpS370bQT+V/C8kni+U8r1lJTY24aqffdIS57Gb322kFDVkov7lGwfmIg+k6x3IjKuXbt5/fqWkIY/An5pFYJnOJpfmCzNhQctFOcBFRiJ489FPsLTCKA90pwyp0qJm1wfWfyg3BrA0g8Sfr0bk0FCfob90Ahc5iOwZmw/TzREAIb+mI6Ho0WV3RkhRRsEtRGo+/gHMrhbb2NP6KTtWagUb8E+29izG+w/37zrq+fydx/92cz4UInJ1LbZdEwa/RtNpQ69Y2Rep1ve3vl1vbZ+d8K0fdrK3Ysh3/llvzZ54lch9kwdqFpizRaFvYe+Z5XEGj+TY2N68KOXnYyUzFIxlsnzJVBvzRQvOp1aIgp+/2p/Q=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(136003)(376002)(39860400002)(346002)(396003)(46966006)(36840700001)(40470700004)(26005)(70586007)(8676002)(336012)(83170400001)(47076005)(82740400003)(42882007)(5660300002)(70206006)(4326008)(83380400001)(54906003)(82310400005)(81166007)(2906002)(41300700001)(186003)(110136005)(6666004)(356005)(316002)(36756003)(30864003)(36860700001)(9686003)(8936002)(478600001)(40480700001)(55446002)(40460700003)(2876002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 12:36:18.8274
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66382ea6-f456-4dd0-9900-08da665e9ded
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB2483
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

A non-null efv in __ef100_enqueue_skb() indicates that the packet is
 from that representor, should be transmitted with a suitable option
 descriptor (to instruct the switch to deliver it to the representee),
 and should not be accounted to the parent PF's stats or BQL.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/ef100_rep.h  |  7 +++
 drivers/net/ethernet/sfc/ef100_tx.c   | 84 +++++++++++++++++++++++++--
 drivers/net/ethernet/sfc/ef100_tx.h   |  3 +
 drivers/net/ethernet/sfc/net_driver.h |  1 +
 drivers/net/ethernet/sfc/tx.c         |  6 +-
 drivers/net/ethernet/sfc/tx_common.c  | 35 +++++++----
 drivers/net/ethernet/sfc/tx_common.h  |  3 +-
 7 files changed, 122 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index a2f16bd59771..9365986f2841 100644
--- a/drivers/net/ethernet/sfc/ef100_rep.h
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -15,6 +15,12 @@
 
 #include "net_driver.h"
 
+struct efx_rep_sw_stats {
+	atomic64_t rx_packets, tx_packets;
+	atomic64_t rx_bytes, tx_bytes;
+	atomic64_t rx_dropped, tx_errors;
+};
+
 /* Private data for an Efx representor */
 struct efx_rep {
 	struct efx_nic *parent;
@@ -23,6 +29,7 @@ struct efx_rep {
 	u32 mport; /* m-port ID of corresponding VF */
 	unsigned int idx; /* VF index  */
 	struct list_head list; /* entry on efx->vf_reps */
+	struct efx_rep_sw_stats stats;
 };
 
 int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i);
diff --git a/drivers/net/ethernet/sfc/ef100_tx.c b/drivers/net/ethernet/sfc/ef100_tx.c
index 26ef51d6b542..102ddc7e206a 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.c
+++ b/drivers/net/ethernet/sfc/ef100_tx.c
@@ -254,7 +254,8 @@ static void ef100_make_tso_desc(struct efx_nic *efx,
 
 static void ef100_tx_make_descriptors(struct efx_tx_queue *tx_queue,
 				      const struct sk_buff *skb,
-				      unsigned int segment_count)
+				      unsigned int segment_count,
+				      struct efx_rep *efv)
 {
 	unsigned int old_write_count = tx_queue->write_count;
 	unsigned int new_write_count = old_write_count;
@@ -272,6 +273,20 @@ static void ef100_tx_make_descriptors(struct efx_tx_queue *tx_queue,
 	else
 		next_desc_type = ESE_GZ_TX_DESC_TYPE_SEND;
 
+	if (unlikely(efv)) {
+		/* Create TX override descriptor */
+		write_ptr = new_write_count & tx_queue->ptr_mask;
+		txd = ef100_tx_desc(tx_queue, write_ptr);
+		++new_write_count;
+
+		tx_queue->packet_write_count = new_write_count;
+		EFX_POPULATE_OWORD_3(*txd,
+				     ESF_GZ_TX_DESC_TYPE, ESE_GZ_TX_DESC_TYPE_PREFIX,
+				     ESF_GZ_TX_PREFIX_EGRESS_MPORT, efv->mport,
+				     ESF_GZ_TX_PREFIX_EGRESS_MPORT_EN, 1);
+		nr_descs--;
+	}
+
 	/* if it's a raw write (such as XDP) then always SEND single frames */
 	if (!skb)
 		nr_descs = 1;
@@ -306,6 +321,9 @@ static void ef100_tx_make_descriptors(struct efx_tx_queue *tx_queue,
 		/* if it's a raw write (such as XDP) then always SEND */
 		next_desc_type = skb ? ESE_GZ_TX_DESC_TYPE_SEG :
 				       ESE_GZ_TX_DESC_TYPE_SEND;
+		/* mark as an EFV buffer if applicable */
+		if (unlikely(efv))
+			buffer->flags |= EFX_TX_BUF_EFV;
 
 	} while (new_write_count != tx_queue->insert_count);
 
@@ -324,7 +342,7 @@ static void ef100_tx_make_descriptors(struct efx_tx_queue *tx_queue,
 
 void ef100_tx_write(struct efx_tx_queue *tx_queue)
 {
-	ef100_tx_make_descriptors(tx_queue, NULL, 0);
+	ef100_tx_make_descriptors(tx_queue, NULL, 0, NULL);
 	ef100_tx_push_buffers(tx_queue);
 }
 
@@ -350,6 +368,12 @@ void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event)
  * function will free the SKB.
  */
 int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
+{
+	return __ef100_enqueue_skb(tx_queue, skb, NULL);
+}
+
+int __ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			struct efx_rep *efv)
 {
 	unsigned int old_insert_count = tx_queue->insert_count;
 	struct efx_nic *efx = tx_queue->efx;
@@ -376,16 +400,64 @@ int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 			return 0;
 	}
 
+	if (unlikely(efv)) {
+		struct efx_tx_buffer *buffer = __efx_tx_queue_get_insert_buffer(tx_queue);
+
+		/* Drop representor packets if the queue is stopped.
+		 * We currently don't assert backoff to representors so this is
+		 * to make sure representor traffic can't starve the main
+		 * net device.
+		 * And, of course, if there are no TX descriptors left.
+		 */
+		if (netif_tx_queue_stopped(tx_queue->core_txq) ||
+		    unlikely(efx_tx_buffer_in_use(buffer))) {
+			atomic64_inc(&efv->stats.tx_errors);
+			rc = -ENOSPC;
+			goto err;
+		}
+
+		/* Also drop representor traffic if it could cause us to
+		 * stop the queue. If we assert backoff and we haven't
+		 * received traffic on the main net device recently then the
+		 * TX watchdog can go off erroneously.
+		 */
+		fill_level = efx_channel_tx_old_fill_level(tx_queue->channel);
+		fill_level += efx_tx_max_skb_descs(efx);
+		if (fill_level > efx->txq_stop_thresh) {
+			struct efx_tx_queue *txq2;
+
+			/* Refresh cached fill level and re-check */
+			efx_for_each_channel_tx_queue(txq2, tx_queue->channel)
+				txq2->old_read_count = READ_ONCE(txq2->read_count);
+
+			fill_level = efx_channel_tx_old_fill_level(tx_queue->channel);
+			fill_level += efx_tx_max_skb_descs(efx);
+			if (fill_level > efx->txq_stop_thresh) {
+				atomic64_inc(&efv->stats.tx_errors);
+				rc = -ENOSPC;
+				goto err;
+			}
+		}
+
+		buffer->flags = EFX_TX_BUF_OPTION | EFX_TX_BUF_EFV;
+		tx_queue->insert_count++;
+	}
+
 	/* Map for DMA and create descriptors */
 	rc = efx_tx_map_data(tx_queue, skb, segments);
 	if (rc)
 		goto err;
-	ef100_tx_make_descriptors(tx_queue, skb, segments);
+	ef100_tx_make_descriptors(tx_queue, skb, segments, efv);
 
 	fill_level = efx_channel_tx_old_fill_level(tx_queue->channel);
 	if (fill_level > efx->txq_stop_thresh) {
 		struct efx_tx_queue *txq2;
 
+		/* Because of checks above, representor traffic should
+		 * not be able to stop the queue.
+		 */
+		WARN_ON(efv);
+
 		netif_tx_stop_queue(tx_queue->core_txq);
 		/* Re-read after a memory barrier in case we've raced with
 		 * the completion path. Otherwise there's a danger we'll never
@@ -404,8 +476,12 @@ int ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb)
 	/* If xmit_more then we don't need to push the doorbell, unless there
 	 * are 256 descriptors already queued in which case we have to push to
 	 * ensure we never push more than 256 at once.
+	 *
+	 * Always push for representor traffic, and don't account it to parent
+	 * PF netdevice's BQL.
 	 */
-	if (__netdev_tx_sent_queue(tx_queue->core_txq, skb->len, xmit_more) ||
+	if (unlikely(efv) ||
+	    __netdev_tx_sent_queue(tx_queue->core_txq, skb->len, xmit_more) ||
 	    tx_queue->write_count - tx_queue->notify_count > 255)
 		ef100_tx_push_buffers(tx_queue);
 
diff --git a/drivers/net/ethernet/sfc/ef100_tx.h b/drivers/net/ethernet/sfc/ef100_tx.h
index ddc4b98fa6db..e9e11540fcde 100644
--- a/drivers/net/ethernet/sfc/ef100_tx.h
+++ b/drivers/net/ethernet/sfc/ef100_tx.h
@@ -13,6 +13,7 @@
 #define EFX_EF100_TX_H
 
 #include "net_driver.h"
+#include "ef100_rep.h"
 
 int ef100_tx_probe(struct efx_tx_queue *tx_queue);
 void ef100_tx_init(struct efx_tx_queue *tx_queue);
@@ -22,4 +23,6 @@ unsigned int ef100_tx_max_skb_descs(struct efx_nic *efx);
 void ef100_ev_tx(struct efx_channel *channel, const efx_qword_t *p_event);
 
 netdev_tx_t ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb);
+int __ef100_enqueue_skb(struct efx_tx_queue *tx_queue, struct sk_buff *skb,
+			struct efx_rep *efv);
 #endif
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 80ee2c936f59..83631fab7994 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -178,6 +178,7 @@ struct efx_tx_buffer {
 #define EFX_TX_BUF_OPTION	0x10	/* empty buffer for option descriptor */
 #define EFX_TX_BUF_XDP		0x20	/* buffer was sent with XDP */
 #define EFX_TX_BUF_TSO_V3	0x40	/* empty buffer for a TSO_V3 descriptor */
+#define EFX_TX_BUF_EFV		0x100	/* buffer was sent from representor */
 
 /**
  * struct efx_tx_queue - An Efx TX queue
diff --git a/drivers/net/ethernet/sfc/tx.c b/drivers/net/ethernet/sfc/tx.c
index 79cc0bb76321..d12474042c84 100644
--- a/drivers/net/ethernet/sfc/tx.c
+++ b/drivers/net/ethernet/sfc/tx.c
@@ -559,6 +559,7 @@ netdev_tx_t efx_hard_start_xmit(struct sk_buff *skb,
 void efx_xmit_done_single(struct efx_tx_queue *tx_queue)
 {
 	unsigned int pkts_compl = 0, bytes_compl = 0;
+	unsigned int efv_pkts_compl = 0;
 	unsigned int read_ptr;
 	bool finished = false;
 
@@ -580,7 +581,8 @@ void efx_xmit_done_single(struct efx_tx_queue *tx_queue)
 		/* Need to check the flag before dequeueing. */
 		if (buffer->flags & EFX_TX_BUF_SKB)
 			finished = true;
-		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
+		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl,
+				   &efv_pkts_compl);
 
 		++tx_queue->read_count;
 		read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
@@ -589,7 +591,7 @@ void efx_xmit_done_single(struct efx_tx_queue *tx_queue)
 	tx_queue->pkts_compl += pkts_compl;
 	tx_queue->bytes_compl += bytes_compl;
 
-	EFX_WARN_ON_PARANOID(pkts_compl != 1);
+	EFX_WARN_ON_PARANOID(pkts_compl + efv_pkts_compl != 1);
 
 	efx_xmit_done_check_empty(tx_queue);
 }
diff --git a/drivers/net/ethernet/sfc/tx_common.c b/drivers/net/ethernet/sfc/tx_common.c
index 658ea2d34070..67e789b96c43 100644
--- a/drivers/net/ethernet/sfc/tx_common.c
+++ b/drivers/net/ethernet/sfc/tx_common.c
@@ -109,9 +109,11 @@ void efx_fini_tx_queue(struct efx_tx_queue *tx_queue)
 	/* Free any buffers left in the ring */
 	while (tx_queue->read_count != tx_queue->write_count) {
 		unsigned int pkts_compl = 0, bytes_compl = 0;
+		unsigned int efv_pkts_compl = 0;
 
 		buffer = &tx_queue->buffer[tx_queue->read_count & tx_queue->ptr_mask];
-		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
+		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl,
+				   &efv_pkts_compl);
 
 		++tx_queue->read_count;
 	}
@@ -146,7 +148,8 @@ void efx_remove_tx_queue(struct efx_tx_queue *tx_queue)
 void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 			struct efx_tx_buffer *buffer,
 			unsigned int *pkts_compl,
-			unsigned int *bytes_compl)
+			unsigned int *bytes_compl,
+			unsigned int *efv_pkts_compl)
 {
 	if (buffer->unmap_len) {
 		struct device *dma_dev = &tx_queue->efx->pci_dev->dev;
@@ -164,9 +167,15 @@ void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 	if (buffer->flags & EFX_TX_BUF_SKB) {
 		struct sk_buff *skb = (struct sk_buff *)buffer->skb;
 
-		EFX_WARN_ON_PARANOID(!pkts_compl || !bytes_compl);
-		(*pkts_compl)++;
-		(*bytes_compl) += skb->len;
+		if (unlikely(buffer->flags & EFX_TX_BUF_EFV)) {
+			EFX_WARN_ON_PARANOID(!efv_pkts_compl);
+			(*efv_pkts_compl)++;
+		} else {
+			EFX_WARN_ON_PARANOID(!pkts_compl || !bytes_compl);
+			(*pkts_compl)++;
+			(*bytes_compl) += skb->len;
+		}
+
 		if (tx_queue->timestamping &&
 		    (tx_queue->completed_timestamp_major ||
 		     tx_queue->completed_timestamp_minor)) {
@@ -199,7 +208,8 @@ void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 static void efx_dequeue_buffers(struct efx_tx_queue *tx_queue,
 				unsigned int index,
 				unsigned int *pkts_compl,
-				unsigned int *bytes_compl)
+				unsigned int *bytes_compl,
+				unsigned int *efv_pkts_compl)
 {
 	struct efx_nic *efx = tx_queue->efx;
 	unsigned int stop_index, read_ptr;
@@ -218,7 +228,8 @@ static void efx_dequeue_buffers(struct efx_tx_queue *tx_queue,
 			return;
 		}
 
-		efx_dequeue_buffer(tx_queue, buffer, pkts_compl, bytes_compl);
+		efx_dequeue_buffer(tx_queue, buffer, pkts_compl, bytes_compl,
+				   efv_pkts_compl);
 
 		++tx_queue->read_count;
 		read_ptr = tx_queue->read_count & tx_queue->ptr_mask;
@@ -241,15 +252,17 @@ void efx_xmit_done_check_empty(struct efx_tx_queue *tx_queue)
 void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 {
 	unsigned int fill_level, pkts_compl = 0, bytes_compl = 0;
+	unsigned int efv_pkts_compl = 0;
 	struct efx_nic *efx = tx_queue->efx;
 
 	EFX_WARN_ON_ONCE_PARANOID(index > tx_queue->ptr_mask);
 
-	efx_dequeue_buffers(tx_queue, index, &pkts_compl, &bytes_compl);
+	efx_dequeue_buffers(tx_queue, index, &pkts_compl, &bytes_compl,
+			    &efv_pkts_compl);
 	tx_queue->pkts_compl += pkts_compl;
 	tx_queue->bytes_compl += bytes_compl;
 
-	if (pkts_compl > 1)
+	if (pkts_compl + efv_pkts_compl > 1)
 		++tx_queue->merge_events;
 
 	/* See if we need to restart the netif queue.  This memory
@@ -274,6 +287,7 @@ void efx_xmit_done(struct efx_tx_queue *tx_queue, unsigned int index)
 void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
 			unsigned int insert_count)
 {
+	unsigned int efv_pkts_compl = 0;
 	struct efx_tx_buffer *buffer;
 	unsigned int bytes_compl = 0;
 	unsigned int pkts_compl = 0;
@@ -282,7 +296,8 @@ void efx_enqueue_unwind(struct efx_tx_queue *tx_queue,
 	while (tx_queue->insert_count != insert_count) {
 		--tx_queue->insert_count;
 		buffer = __efx_tx_queue_get_insert_buffer(tx_queue);
-		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl);
+		efx_dequeue_buffer(tx_queue, buffer, &pkts_compl, &bytes_compl,
+				   &efv_pkts_compl);
 	}
 }
 
diff --git a/drivers/net/ethernet/sfc/tx_common.h b/drivers/net/ethernet/sfc/tx_common.h
index bbab7f248250..d87aecbc7bf1 100644
--- a/drivers/net/ethernet/sfc/tx_common.h
+++ b/drivers/net/ethernet/sfc/tx_common.h
@@ -19,7 +19,8 @@ void efx_remove_tx_queue(struct efx_tx_queue *tx_queue);
 void efx_dequeue_buffer(struct efx_tx_queue *tx_queue,
 			struct efx_tx_buffer *buffer,
 			unsigned int *pkts_compl,
-			unsigned int *bytes_compl);
+			unsigned int *bytes_compl,
+			unsigned int *efv_pkts_compl);
 
 static inline bool efx_tx_buffer_in_use(struct efx_tx_buffer *buffer)
 {

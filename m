Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 102ED57866F
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 17:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235425AbiGRPdC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 11:33:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235376AbiGRPc6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 11:32:58 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2040.outbound.protection.outlook.com [40.107.223.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 794FE22B
        for <netdev@vger.kernel.org>; Mon, 18 Jul 2022 08:32:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yqvf6J01HTJQ2X2eWzOYSijWA1/kCe668aqOOc70gSUlOypJiwsUqhRs7dp7H0co9Va+K0/g+GMIB3joTp9gJIvAL56adfeVeU5XbcR9a8lHtRH6V1btRmmBKuF6cdEL2O7eIvGV7/EvOmkHVX2x2apoznXnmlUR72e5zqGMxRMGLF6bnJQX5KP3vRR+ns4HwB2khbnFOI5/nGx7+xoF3EiFbcYqFftu7bjF0Uq25gt8wEYutiqJX2XhGhZgoziRKMevcF6LAjLyo0C6YpUDblCsHQQ3/JpZFQO3HYiDx0DYJPO0ar12d0/oOHbetX7s4S0oglfzYEfPs2wNYNWMWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l+lnXKUBmb/sOxUIWMROnw8li5pp27ebFnI6xsHH0hY=;
 b=HTKgLtZyeL9eXFqS9nF/0d7rypitVpLBddMLLt+SAGXhvTF514eH6YQ9KANTy+kEmALh+Xs2oxJ08sFBsaSHBdnB+9ZUKfjK991mHukPZYEO1DZzMts4El38AJntysz69P+l3B0VGG2+DA67IcBXHqYCU7cyRYeHeQNN6wYgKCkW4d8bc7zR6S5lG95UoX9lacVoMz6x6/c5K8SKq/nhPxxE9J/pRNhcAIau0xgOh638AEAyZmwJBALALdSrYt/mczhsd4C9RecCfVXEMqDUP4vCMhNGZeg+EE55IvwsgBLvCUufsPBgP5uCsIKLYZrDNLArFMd8QRp1MGhA38BwWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l+lnXKUBmb/sOxUIWMROnw8li5pp27ebFnI6xsHH0hY=;
 b=iitQgHhzqMdomtjd8fM+3gyGBB6i9E8uxH7VJx3LV8ZdHgWszaoeMI0i+Sn1u8XacuAdZUadSfU3jl9YGUYJMk8n/w3vlKmrryytwYw0OPB/39yLK1IAwo5l3fTkdzwAecrrFWNUNZ2Y1ucG4Yc5KXDtvdXQrxsvzaBTs+obt5m1PkIzieIs47GbigrxA+f4ax9yqtA5jsx0UM99J3TiQLAwhkQrIOUxIcyN1ZZnPSZYLcPc0FoDw0nxCLPTIsqbk4EikFmBQ0DGHVtc/PvaXTacitclIJDpn+zcgI15aDLjyhHRzeGwzJNx2EUW9mDsER1yA8Y/NLvMk76TsLvKcg==
Received: from BN9PR03CA0269.namprd03.prod.outlook.com (2603:10b6:408:ff::34)
 by MN2PR12MB4359.namprd12.prod.outlook.com (2603:10b6:208:265::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17; Mon, 18 Jul
 2022 15:32:54 +0000
Received: from BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ff:cafe::ff) by BN9PR03CA0269.outlook.office365.com
 (2603:10b6:408:ff::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.17 via Frontend
 Transport; Mon, 18 Jul 2022 15:32:54 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT056.mail.protection.outlook.com (10.13.177.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Mon, 18 Jul 2022 15:32:53 +0000
Received: from SATLEXMB06.amd.com (10.181.40.147) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:52 -0500
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB06.amd.com
 (10.181.40.147) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Mon, 18 Jul
 2022 10:32:52 -0500
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Mon, 18 Jul 2022 10:32:51 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 08/10] sfc: support passing a representor to the EF100 TX path
Date:   Mon, 18 Jul 2022 16:30:14 +0100
Message-ID: <47b43514f6c4ff8deb501fdd081d9b11bf49041d.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fb69baa-7952-475a-f5a7-08da68d2c830
X-MS-TrafficTypeDiagnostic: MN2PR12MB4359:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J/85/DwnYJCEiP5uSfR+NtNuo0BAMbbBt+BwcPsFGXcFzlZIRLFAWrwr1f8Fv0uKAqBGiUa2gtxc5UlZaKRKAItCB1j2q9s+kvjy26ig39i4TcoBa+l2xeIn7+vVXNGkFaGeZJ7lW63zufJXBYBP4TZE3bj9ONvbX0MseSjj4Sk1JmBKHGABlwDAmYet7lYkpj2LKeyHwx52g83CbL+uYbRy9ZrwmNYtm9ZAxuCN3Kovdw8ToW76VqgyKK3wr8uLepvRGf0wRVYe1caHoYqdHSxeonwzog7XprgG2IVgl8kyUtcikBqdKZF1WMXh5EmuPgnYTdzHYYT5N8AUBO2Gmuo6UrbMGgFLgj8WJrMlPfLMBiES/vvJuD1EFiP4NXt8Dlwrgkr07eKA6kTAv6NN5ShEmk4Rkd/IZlbFl9j0omubBQYKhYfMEfkH3cDN+IY660lXB8hw6KnrWEYkEYtpHAi4pwPO7ZBTzmqYGJ6jrqgOtJxD3imPLuvnl5tEW75QA/s00SpzZoTIyTO/WzQQnYt+l5akd8W8yoIJW/BSB4BO4K59D3Pk1Oh9yOJYBQE32rdf/8lCMxtgaVNe0VwKH8IHzBmhhkZ/BCzho00lGvpk8vyinTLdbG5J7lD5DH9ay3A7QMHGH7eLRJAztfUE3Jvcg1K5Ahzgma9TOkcnsV5U9SNPGnpkj4g3URfOMWKOuyF9VhzD5+OoQgH0b6ENYMSG5dLpz0ZEGpkGxUGM5t0KxitWU7799LhrhfAAsc2OOafuzVP8o/PJ6sdKZZxcODm+d3SLwpbhrFxAh7fkcp73xazsRfOFyZpa+StqkzhEst/bMB6kFpc0yWoT0emgiSqjgWE4LiqcSPyselFV+kk=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(396003)(136003)(346002)(376002)(40470700004)(46966006)(36840700001)(54906003)(110136005)(6666004)(2876002)(26005)(41300700001)(9686003)(2906002)(478600001)(40480700001)(82310400005)(30864003)(4326008)(316002)(8676002)(8936002)(5660300002)(83170400001)(82740400003)(36860700001)(356005)(36756003)(83380400001)(40460700003)(55446002)(47076005)(336012)(70586007)(186003)(42882007)(70206006)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2022 15:32:53.6481
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fb69baa-7952-475a-f5a7-08da68d2c830
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT056.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4359
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
 drivers/net/ethernet/sfc/ef100_rep.h  |  8 +++
 drivers/net/ethernet/sfc/ef100_tx.c   | 84 +++++++++++++++++++++++++--
 drivers/net/ethernet/sfc/ef100_tx.h   |  3 +
 drivers/net/ethernet/sfc/net_driver.h |  1 +
 drivers/net/ethernet/sfc/tx.c         |  6 +-
 drivers/net/ethernet/sfc/tx_common.c  | 35 +++++++----
 drivers/net/ethernet/sfc/tx_common.h  |  3 +-
 7 files changed, 123 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
index 1d17aaf6cd5c..d47fd8ff6220 100644
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
 /**
  * struct efx_rep - Private data for an Efx representor
  *
@@ -24,6 +30,7 @@
  * @mport: m-port ID of corresponding VF
  * @idx: VF index
  * @list: entry on efx->vf_reps
+ * @stats: software traffic counters for netdev stats
  */
 struct efx_rep {
 	struct efx_nic *parent;
@@ -32,6 +39,7 @@ struct efx_rep {
 	u32 mport;
 	unsigned int idx;
 	struct list_head list;
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
index 037cfa184764..4cde54cf77b9 100644
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

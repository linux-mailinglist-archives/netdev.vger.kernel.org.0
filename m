Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CDD36BD25E
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 15:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231231AbjCPO23 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 10:28:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbjCPO20 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 10:28:26 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60FA3A24C
        for <netdev@vger.kernel.org>; Thu, 16 Mar 2023 07:28:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1678976895; x=1710512895;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=aZA11mLu1BhVIx0Q3LU1hUZMEAC0g9qIFQflORaV3W4=;
  b=n0YU0lrtHydXdhBZeYLvtsIJQX0XbDhGjdlfIlAx5qw/JF6X251sioMK
   snK2naB7TleFPEaa7bQsMCmVd5u1t3AXIV7SkfngqHLmRyr/zUP9+jbmO
   0tnz9b19zdyZWXgsNqBzyBOquxr2qPaco3HcNrTQOfzxDDlEx+7n2vb1m
   o=;
X-IronPort-AV: E=Sophos;i="5.98,265,1673913600"; 
   d="scan'208";a="307928846"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 14:28:06 +0000
Received: from EX19D013EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan3.iad.amazon.com [10.40.163.38])
        by email-inbound-relay-iad-1e-m6i4x-245b69b1.us-east-1.amazon.com (Postfix) with ESMTPS id 41251340137;
        Thu, 16 Mar 2023 14:28:04 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D013EUA003.ant.amazon.com (10.252.50.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 16 Mar 2023 14:28:04 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.176) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Thu, 16 Mar 2023 14:27:56 +0000
From:   Shay Agroskin <shayagr@amazon.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     Shay Agroskin <shayagr@amazon.com>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Kiyanovski, Arthur" <akiyano@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        "Itzko, Shahar" <itzko@amazon.com>,
        "Abboud, Osama" <osamaabb@amazon.com>
Subject: [PATCH v5 net-next 2/6] net: ena: Make few cosmetic preparations to support large LLQ
Date:   Thu, 16 Mar 2023 16:27:02 +0200
Message-ID: <20230316142706.4046263-3-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230316142706.4046263-1-shayagr@amazon.com>
References: <20230316142706.4046263-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.176]
X-ClientProxiedBy: EX19D042UWA003.ant.amazon.com (10.13.139.44) To
 EX19D028EUB003.ant.amazon.com (10.252.61.31)
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Move ena_calc_io_queue_size() implementation closer to the file's
beginning so that it can be later called from ena_device_init()
function without adding a function declaration.

Also add an empty line at some spots to separate logical blocks in
funcitons.

Signed-off-by: Shay Agroskin <shayagr@amazon.com>
---
 drivers/net/ethernet/amazon/ena/ena_netdev.c | 133 ++++++++++---------
 1 file changed, 67 insertions(+), 66 deletions(-)

diff --git a/drivers/net/ethernet/amazon/ena/ena_netdev.c b/drivers/net/ethernet/amazon/ena/ena_netdev.c
index d3999db7c6a2..372e33831323 100644
--- a/drivers/net/ethernet/amazon/ena/ena_netdev.c
+++ b/drivers/net/ethernet/amazon/ena/ena_netdev.c
@@ -3364,6 +3364,71 @@ static const struct net_device_ops ena_netdev_ops = {
 	.ndo_xdp_xmit		= ena_xdp_xmit,
 };
 
+static void ena_calc_io_queue_size(struct ena_adapter *adapter,
+				   struct ena_com_dev_get_features_ctx *get_feat_ctx)
+{
+	struct ena_admin_feature_llq_desc *llq = &get_feat_ctx->llq;
+	struct ena_com_dev *ena_dev = adapter->ena_dev;
+	u32 tx_queue_size = ENA_DEFAULT_RING_SIZE;
+	u32 rx_queue_size = ENA_DEFAULT_RING_SIZE;
+	u32 max_tx_queue_size;
+	u32 max_rx_queue_size;
+
+	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
+		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
+			&get_feat_ctx->max_queue_ext.max_queue_ext;
+		max_rx_queue_size = min_t(u32, max_queue_ext->max_rx_cq_depth,
+					  max_queue_ext->max_rx_sq_depth);
+		max_tx_queue_size = max_queue_ext->max_tx_cq_depth;
+
+		if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
+			max_tx_queue_size = min_t(u32, max_tx_queue_size,
+						  llq->max_llq_depth);
+		else
+			max_tx_queue_size = min_t(u32, max_tx_queue_size,
+						  max_queue_ext->max_tx_sq_depth);
+
+		adapter->max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+						 max_queue_ext->max_per_packet_tx_descs);
+		adapter->max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+						 max_queue_ext->max_per_packet_rx_descs);
+	} else {
+		struct ena_admin_queue_feature_desc *max_queues =
+			&get_feat_ctx->max_queues;
+		max_rx_queue_size = min_t(u32, max_queues->max_cq_depth,
+					  max_queues->max_sq_depth);
+		max_tx_queue_size = max_queues->max_cq_depth;
+
+		if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
+			max_tx_queue_size = min_t(u32, max_tx_queue_size,
+						  llq->max_llq_depth);
+		else
+			max_tx_queue_size = min_t(u32, max_tx_queue_size,
+						  max_queues->max_sq_depth);
+
+		adapter->max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+						 max_queues->max_packet_tx_descs);
+		adapter->max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
+						 max_queues->max_packet_rx_descs);
+	}
+
+	max_tx_queue_size = rounddown_pow_of_two(max_tx_queue_size);
+	max_rx_queue_size = rounddown_pow_of_two(max_rx_queue_size);
+
+	tx_queue_size = clamp_val(tx_queue_size, ENA_MIN_RING_SIZE,
+				  max_tx_queue_size);
+	rx_queue_size = clamp_val(rx_queue_size, ENA_MIN_RING_SIZE,
+				  max_rx_queue_size);
+
+	tx_queue_size = rounddown_pow_of_two(tx_queue_size);
+	rx_queue_size = rounddown_pow_of_two(rx_queue_size);
+
+	adapter->max_tx_ring_size  = max_tx_queue_size;
+	adapter->max_rx_ring_size = max_rx_queue_size;
+	adapter->requested_tx_ring_size = tx_queue_size;
+	adapter->requested_rx_ring_size = rx_queue_size;
+}
+
 static int ena_device_validate_params(struct ena_adapter *adapter,
 				      struct ena_com_dev_get_features_ctx *get_feat_ctx)
 {
@@ -4164,72 +4229,6 @@ static void ena_release_bars(struct ena_com_dev *ena_dev, struct pci_dev *pdev)
 	pci_release_selected_regions(pdev, release_bars);
 }
 
-
-static void ena_calc_io_queue_size(struct ena_adapter *adapter,
-				   struct ena_com_dev_get_features_ctx *get_feat_ctx)
-{
-	struct ena_admin_feature_llq_desc *llq = &get_feat_ctx->llq;
-	struct ena_com_dev *ena_dev = adapter->ena_dev;
-	u32 tx_queue_size = ENA_DEFAULT_RING_SIZE;
-	u32 rx_queue_size = ENA_DEFAULT_RING_SIZE;
-	u32 max_tx_queue_size;
-	u32 max_rx_queue_size;
-
-	if (ena_dev->supported_features & BIT(ENA_ADMIN_MAX_QUEUES_EXT)) {
-		struct ena_admin_queue_ext_feature_fields *max_queue_ext =
-			&get_feat_ctx->max_queue_ext.max_queue_ext;
-		max_rx_queue_size = min_t(u32, max_queue_ext->max_rx_cq_depth,
-					  max_queue_ext->max_rx_sq_depth);
-		max_tx_queue_size = max_queue_ext->max_tx_cq_depth;
-
-		if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
-			max_tx_queue_size = min_t(u32, max_tx_queue_size,
-						  llq->max_llq_depth);
-		else
-			max_tx_queue_size = min_t(u32, max_tx_queue_size,
-						  max_queue_ext->max_tx_sq_depth);
-
-		adapter->max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
-						 max_queue_ext->max_per_packet_tx_descs);
-		adapter->max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
-						 max_queue_ext->max_per_packet_rx_descs);
-	} else {
-		struct ena_admin_queue_feature_desc *max_queues =
-			&get_feat_ctx->max_queues;
-		max_rx_queue_size = min_t(u32, max_queues->max_cq_depth,
-					  max_queues->max_sq_depth);
-		max_tx_queue_size = max_queues->max_cq_depth;
-
-		if (ena_dev->tx_mem_queue_type == ENA_ADMIN_PLACEMENT_POLICY_DEV)
-			max_tx_queue_size = min_t(u32, max_tx_queue_size,
-						  llq->max_llq_depth);
-		else
-			max_tx_queue_size = min_t(u32, max_tx_queue_size,
-						  max_queues->max_sq_depth);
-
-		adapter->max_tx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
-						 max_queues->max_packet_tx_descs);
-		adapter->max_rx_sgl_size = min_t(u16, ENA_PKT_MAX_BUFS,
-						 max_queues->max_packet_rx_descs);
-	}
-
-	max_tx_queue_size = rounddown_pow_of_two(max_tx_queue_size);
-	max_rx_queue_size = rounddown_pow_of_two(max_rx_queue_size);
-
-	tx_queue_size = clamp_val(tx_queue_size, ENA_MIN_RING_SIZE,
-				  max_tx_queue_size);
-	rx_queue_size = clamp_val(rx_queue_size, ENA_MIN_RING_SIZE,
-				  max_rx_queue_size);
-
-	tx_queue_size = rounddown_pow_of_two(tx_queue_size);
-	rx_queue_size = rounddown_pow_of_two(rx_queue_size);
-
-	adapter->max_tx_ring_size  = max_tx_queue_size;
-	adapter->max_rx_ring_size = max_rx_queue_size;
-	adapter->requested_tx_ring_size = tx_queue_size;
-	adapter->requested_rx_ring_size = rx_queue_size;
-}
-
 /* ena_probe - Device Initialization Routine
  * @pdev: PCI device information struct
  * @ent: entry in ena_pci_tbl
@@ -4366,6 +4365,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			"Failed to query interrupt moderation feature\n");
 		goto err_device_destroy;
 	}
+
 	ena_init_io_rings(adapter,
 			  0,
 			  adapter->xdp_num_queues +
@@ -4486,6 +4486,7 @@ static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
 	rtnl_lock(); /* lock released inside the below if-else block */
 	adapter->reset_reason = ENA_REGS_RESET_SHUTDOWN;
 	ena_destroy_device(adapter, true);
+
 	if (shutdown) {
 		netif_device_detach(netdev);
 		dev_close(netdev);
-- 
2.25.1


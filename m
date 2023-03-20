Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9581E6C133D
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:27:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjCTN1C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:27:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbjCTN07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:26:59 -0400
Received: from smtp-fw-80007.amazon.com (smtp-fw-80007.amazon.com [99.78.197.218])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C21F252B6
        for <netdev@vger.kernel.org>; Mon, 20 Mar 2023 06:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1679318812; x=1710854812;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H8PE5AbssBN6qI6vakpJ65RgQuJ/sWXjZbeufNWICzA=;
  b=WEVvZ1/+2FcLDosY1rsuy44gJzNO2QlG0RtlohiSAkbTG5VkmQmhUlZF
   t4961PN2dI2JJyE2KwJ7/bUDckwo9qN6iy0nwAYdjmgAB39SOylh9a+o7
   eAXzvPOJeeAKf4AoPx2cU1jo/g7qlx9TayPFw9ig89ldh5uqEl7m91HOF
   k=;
X-IronPort-AV: E=Sophos;i="5.98,274,1673913600"; 
   d="scan'208";a="195191682"
Received: from pdx4-co-svc-p1-lb2-vlan3.amazon.com (HELO email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com) ([10.25.36.214])
  by smtp-border-fw-80007.pdx80.corp.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 13:26:44 +0000
Received: from EX19D020EUA003.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1e-m6i4x-6e7a78d7.us-east-1.amazon.com (Postfix) with ESMTPS id 27CFF80E6D;
        Mon, 20 Mar 2023 13:26:39 +0000 (UTC)
Received: from EX19D028EUB003.ant.amazon.com (10.252.61.31) by
 EX19D020EUA003.ant.amazon.com (10.252.50.116) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 20 Mar 2023 13:26:39 +0000
Received: from u570694869fb251.ant.amazon.com (10.85.143.172) by
 EX19D028EUB003.ant.amazon.com (10.252.61.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.24; Mon, 20 Mar 2023 13:26:28 +0000
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
        "Abboud, Osama" <osamaabb@amazon.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        "Jie Wang" <wangjie125@huawei.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH v6 net-next 3/7] net: ena: Make few cosmetic preparations to support large LLQ
Date:   Mon, 20 Mar 2023 15:25:19 +0200
Message-ID: <20230320132523.3203254-4-shayagr@amazon.com>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20230320132523.3203254-1-shayagr@amazon.com>
References: <20230320132523.3203254-1-shayagr@amazon.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.85.143.172]
X-ClientProxiedBy: EX19D038UWC003.ant.amazon.com (10.13.139.209) To
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
index cbfe7f977270..794f8eec468a 100644
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
@@ -4162,72 +4227,6 @@ static void ena_release_bars(struct ena_com_dev *ena_dev, struct pci_dev *pdev)
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
@@ -4364,6 +4363,7 @@ static int ena_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 			"Failed to query interrupt moderation feature\n");
 		goto err_device_destroy;
 	}
+
 	ena_init_io_rings(adapter,
 			  0,
 			  adapter->xdp_num_queues +
@@ -4488,6 +4488,7 @@ static void __ena_shutoff(struct pci_dev *pdev, bool shutdown)
 	rtnl_lock(); /* lock released inside the below if-else block */
 	adapter->reset_reason = ENA_REGS_RESET_SHUTDOWN;
 	ena_destroy_device(adapter, true);
+
 	if (shutdown) {
 		netif_device_detach(netdev);
 		dev_close(netdev);
-- 
2.25.1


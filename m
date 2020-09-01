Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5224525A0FD
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:52:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729464AbgIAVwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727946AbgIAVwB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:52:01 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73738C061246
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:52:01 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id v11so2681069ybm.22
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:52:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=lxB3dDii8QkaIwUakotPkYx0le0Zs8cTAJF1yBNkccM=;
        b=MiBfy4Mcw4wELj+5kRHWM/+Jqzjfh7z3vzzz/Ez/FG2wiPo24PEDkhF9dAtvsX+EFj
         enS/SsfDI+3Tn6LpzB4NUPOGJwE8vVrgnBfwWsrz7DcXok5BDpIE6HDvQbfpx/+ZGp1R
         xcuVJOKsSz8yNQ9fM3ox51ck5w2SCF6xRfk9W8fEmytVkv14qOWt5DSMvpbTpdnJ1G82
         59b8N8EgFeF2Af+O6kJ3zhjgiZdv21RZsqmgwgPdzu0WvK3Tw0wyfiAYGyTnu6Xdh/rB
         gtVep8hxpKW8IqEPHW35HmAuwmskUEvxil1ZqKtJbr3ednmTM6d3wVkpe8lktgapZTAK
         XpYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=lxB3dDii8QkaIwUakotPkYx0le0Zs8cTAJF1yBNkccM=;
        b=BKVQdpS6X9TWkKF1sUEvS3GIj/AFkr/Wo4HEpsHauV/2JPtrHXNnHqR6pD5B5URvX0
         ggevuZ831mQdXw61wSuWNf6beKf/Zfp/n0Pco+5jK85HguLh47UcwodZ63LwjkQ4SlzM
         6iZFol9o22qyhaInXZISolXz2kMeuIU3ZJUNq8Q1XcfNgEOx2yCJmNybPpY2qYh1M/WM
         Lbiw1AEQm76VPSKmTJIzC5JksOrc+4OxRzMmSa1YV/18/fSmAPMA+cUt/Gc8o2FXILIJ
         UkaIdfBO08QjkH+LW2ECZgDYunUm3atBxU7UZ9ac5SxaFJF4X2L1Cofo5ZrN/rrEfBhV
         O+BQ==
X-Gm-Message-State: AOAM530DX5gSVJtKSu24EgmT3tLYYOsNI4IZkSyxoHmttPA+VlA+lisq
        Ckmn6AxvY9L/x+1bCQ66oSaXBkUn+T3rv8vENUe+SG6bRV9vT79W9HZJVW7VBfXC5t6jvHkgWG4
        LWJU23rVWiwDknekJEwnZDrFFpHtbdm+6sHYW9KIksgip5UZTbsl1U1IXAmbWcHiRViNsMQrE
X-Google-Smtp-Source: ABdhPJxTF7pD6oulzcubv2GDbDUoOz2Eippi/KmGgD1V/4BckjMOWpm4Xn0XyVJFfRNMVVbhMUm3Wolp7xsqKfgz
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a25:fc06:: with SMTP id
 v6mr6037646ybd.478.1598997120538; Tue, 01 Sep 2020 14:52:00 -0700 (PDT)
Date:   Tue,  1 Sep 2020 14:51:42 -0700
In-Reply-To: <20200901215149.2685117-1-awogbemila@google.com>
Message-Id: <20200901215149.2685117-3-awogbemila@google.com>
Mime-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next v2 2/9] gve: Add stats for gve.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     Kuo Zhao <kuozhao@google.com>, Yangchun Fu <yangchun@google.com>,
        David Awogbemila <awogbemila@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kuo Zhao <kuozhao@google.com>

Sample output of "ethtool -S <interface-name>" with 1 RX queue and 1 TX
queue:
NIC statistics:
     rx_packets: 1039
     tx_packets: 37
     rx_bytes: 822071
     tx_bytes: 4100
     rx_dropped: 0
     tx_dropped: 0
     tx_timeouts: 0
     rx_skb_alloc_fail: 0
     rx_buf_alloc_fail: 0
     rx_desc_err_dropped_pkt: 0
     interface_up_cnt: 1
     interface_down_cnt: 0
     reset_cnt: 0
     page_alloc_fail: 0
     dma_mapping_error: 0
     rx_posted_desc[0]: 1365
     rx_completed_desc[0]: 341
     rx_bytes[0]: 215094
     rx_dropped_pkt[0]: 0
     rx_copybreak_pkt[0]: 3
     rx_copied_pkt[0]: 3
     tx_posted_desc[0]: 6
     tx_completed_desc[0]: 6
     tx_bytes[0]: 420
     tx_wake[0]: 0
     tx_stop[0]: 0
     tx_event_counter[0]: 6
     adminq_prod_cnt: 34
     adminq_cmd_fail: 0
     adminq_timeouts: 0
     adminq_describe_device_cnt: 1
     adminq_cfg_device_resources_cnt: 1
     adminq_register_page_list_cnt: 16
     adminq_unregister_page_list_cnt: 0
     adminq_create_tx_queue_cnt: 8
     adminq_create_rx_queue_cnt: 8
     adminq_destroy_tx_queue_cnt: 0
     adminq_destroy_rx_queue_cnt: 0
     adminq_dcfg_device_resources_cnt: 0
     adminq_set_driver_parameter_cnt: 0

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Kuo Zhao <kuozhao@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  28 +++-
 drivers/net/ethernet/google/gve/gve_adminq.c  |  65 +++++++-
 drivers/net/ethernet/google/gve/gve_ethtool.c | 149 ++++++++++++++----
 drivers/net/ethernet/google/gve/gve_main.c    |  15 +-
 drivers/net/ethernet/google/gve/gve_rx.c      |  37 ++++-
 5 files changed, 246 insertions(+), 48 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index ebc37e256922..55b34b437764 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -71,6 +71,11 @@ struct gve_rx_ring {
 	u32 cnt; /* free-running total number of completed packets */
 	u32 fill_cnt; /* free-running total number of descs and buffs posted */
 	u32 mask; /* masks the cnt and fill_cnt to the size of the ring */
+	u64 rx_copybreak_pkt; /* free-running count of copybreak packets */
+	u64 rx_copied_pkt; /* free-running total number of copied packets */
+	u64 rx_skb_alloc_fail; /* free-running count of skb alloc fails */
+	u64 rx_buf_alloc_fail; /* free-running count of buffer alloc fails */
+	u64 rx_desc_err_dropped_pkt; /* free-running count of packets dropped by descriptor error */
 	u32 q_num; /* queue index */
 	u32 ntfy_id; /* notification block index */
 	struct gve_queue_resources *q_resources; /* head and tail pointer idx */
@@ -202,6 +207,26 @@ struct gve_priv {
 	dma_addr_t adminq_bus_addr;
 	u32 adminq_mask; /* masks prod_cnt to adminq size */
 	u32 adminq_prod_cnt; /* free-running count of AQ cmds executed */
+	u32 adminq_cmd_fail; /* free-running count of AQ cmds failed */
+	u32 adminq_timeouts; /* free-running count of AQ cmds timeouts */
+	/* free-running count of per AQ cmd executed */
+	u32 adminq_describe_device_cnt;
+	u32 adminq_cfg_device_resources_cnt;
+	u32 adminq_register_page_list_cnt;
+	u32 adminq_unregister_page_list_cnt;
+	u32 adminq_create_tx_queue_cnt;
+	u32 adminq_create_rx_queue_cnt;
+	u32 adminq_destroy_tx_queue_cnt;
+	u32 adminq_destroy_rx_queue_cnt;
+	u32 adminq_dcfg_device_resources_cnt;
+	u32 adminq_set_driver_parameter_cnt;
+
+	/* Global stats */
+	u32 interface_up_cnt; /* count of times interface turned up since last reset */
+	u32 interface_down_cnt; /* count of times interface turned down since last reset */
+	u32 reset_cnt; /* count of reset */
+	u32 page_alloc_fail; /* count of page alloc fails */
+	u32 dma_mapping_error; /* count of dma mapping errors */
 
 	struct workqueue_struct *gve_wq;
 	struct work_struct service_task;
@@ -426,7 +451,8 @@ static inline bool gve_can_recycle_pages(struct net_device *dev)
 }
 
 /* buffers */
-int gve_alloc_page(struct device *dev, struct page **page, dma_addr_t *dma,
+int gve_alloc_page(struct gve_priv *priv, struct device *dev,
+		   struct page **page, dma_addr_t *dma,
 		   enum dma_data_direction);
 void gve_free_page(struct device *dev, struct page *page, dma_addr_t dma,
 		   enum dma_data_direction);
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index c3ba7baf0107..529de756ff9b 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -23,6 +23,18 @@ int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
 
 	priv->adminq_mask = (PAGE_SIZE / sizeof(union gve_adminq_command)) - 1;
 	priv->adminq_prod_cnt = 0;
+	priv->adminq_cmd_fail = 0;
+	priv->adminq_timeouts = 0;
+	priv->adminq_describe_device_cnt = 0;
+	priv->adminq_cfg_device_resources_cnt = 0;
+	priv->adminq_register_page_list_cnt = 0;
+	priv->adminq_unregister_page_list_cnt = 0;
+	priv->adminq_create_tx_queue_cnt = 0;
+	priv->adminq_create_rx_queue_cnt = 0;
+	priv->adminq_destroy_tx_queue_cnt = 0;
+	priv->adminq_destroy_rx_queue_cnt = 0;
+	priv->adminq_dcfg_device_resources_cnt = 0;
+	priv->adminq_set_driver_parameter_cnt = 0;
 
 	/* Setup Admin queue with the device */
 	iowrite32be(priv->adminq_bus_addr / PAGE_SIZE,
@@ -81,17 +93,18 @@ static bool gve_adminq_wait_for_cmd(struct gve_priv *priv, u32 prod_cnt)
 	return false;
 }
 
-static int gve_adminq_parse_err(struct device *dev, u32 status)
+static int gve_adminq_parse_err(struct gve_priv *priv, u32 status)
 {
 	if (status != GVE_ADMINQ_COMMAND_PASSED &&
-	    status != GVE_ADMINQ_COMMAND_UNSET)
-		dev_err(dev, "AQ command failed with status %d\n", status);
-
+	    status != GVE_ADMINQ_COMMAND_UNSET) {
+		dev_err(&priv->pdev->dev, "AQ command failed with status %d\n", status);
+		priv->adminq_cmd_fail++;
+	}
 	switch (status) {
 	case GVE_ADMINQ_COMMAND_PASSED:
 		return 0;
 	case GVE_ADMINQ_COMMAND_UNSET:
-		dev_err(dev, "parse_aq_err: err and status both unset, this should not be possible.\n");
+		dev_err(&priv->pdev->dev, "parse_aq_err: err and status both unset, this should not be possible.\n");
 		return -EINVAL;
 	case GVE_ADMINQ_COMMAND_ERROR_ABORTED:
 	case GVE_ADMINQ_COMMAND_ERROR_CANCELLED:
@@ -116,7 +129,7 @@ static int gve_adminq_parse_err(struct device *dev, u32 status)
 	case GVE_ADMINQ_COMMAND_ERROR_UNIMPLEMENTED:
 		return -ENOTSUPP;
 	default:
-		dev_err(dev, "parse_aq_err: unknown status code %d\n", status);
+		dev_err(&priv->pdev->dev, "parse_aq_err: unknown status code %d\n", status);
 		return -EINVAL;
 	}
 }
@@ -130,22 +143,60 @@ int gve_adminq_execute_cmd(struct gve_priv *priv,
 	union gve_adminq_command *cmd;
 	u32 status = 0;
 	u32 prod_cnt;
+	u32 opcode;
 
 	cmd = &priv->adminq[priv->adminq_prod_cnt & priv->adminq_mask];
 	priv->adminq_prod_cnt++;
 	prod_cnt = priv->adminq_prod_cnt;
 
 	memcpy(cmd, cmd_orig, sizeof(*cmd_orig));
+	opcode = be32_to_cpu(READ_ONCE(cmd->opcode));
+
+	switch (opcode) {
+	case GVE_ADMINQ_DESCRIBE_DEVICE:
+		priv->adminq_describe_device_cnt++;
+		break;
+	case GVE_ADMINQ_CONFIGURE_DEVICE_RESOURCES:
+		priv->adminq_cfg_device_resources_cnt++;
+		break;
+	case GVE_ADMINQ_REGISTER_PAGE_LIST:
+		priv->adminq_register_page_list_cnt++;
+		break;
+	case GVE_ADMINQ_UNREGISTER_PAGE_LIST:
+		priv->adminq_unregister_page_list_cnt++;
+		break;
+	case GVE_ADMINQ_CREATE_TX_QUEUE:
+		priv->adminq_create_tx_queue_cnt++;
+		break;
+	case GVE_ADMINQ_CREATE_RX_QUEUE:
+		priv->adminq_create_rx_queue_cnt++;
+		break;
+	case GVE_ADMINQ_DESTROY_TX_QUEUE:
+		priv->adminq_destroy_tx_queue_cnt++;
+		break;
+	case GVE_ADMINQ_DESTROY_RX_QUEUE:
+		priv->adminq_destroy_rx_queue_cnt++;
+		break;
+	case GVE_ADMINQ_DECONFIGURE_DEVICE_RESOURCES:
+		priv->adminq_dcfg_device_resources_cnt++;
+		break;
+	case GVE_ADMINQ_SET_DRIVER_PARAMETER:
+		priv->adminq_set_driver_parameter_cnt++;
+		break;
+	default:
+		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
+	}
 
 	gve_adminq_kick_cmd(priv, prod_cnt);
 	if (!gve_adminq_wait_for_cmd(priv, prod_cnt)) {
 		dev_err(&priv->pdev->dev, "AQ command timed out, need to reset AQ\n");
+		priv->adminq_timeouts++;
 		return -ENOTRECOVERABLE;
 	}
 
 	memcpy(cmd_orig, cmd, sizeof(*cmd));
 	status = be32_to_cpu(READ_ONCE(cmd->status));
-	return gve_adminq_parse_err(&priv->pdev->dev, status);
+	return gve_adminq_parse_err(priv, status);
 }
 
 /* The device specifies that the management vector can either be the first irq
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 1a80d38e66ec..28d831d52701 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -34,17 +34,40 @@ static u32 gve_get_msglevel(struct net_device *netdev)
 static const char gve_gstrings_main_stats[][ETH_GSTRING_LEN] = {
 	"rx_packets", "tx_packets", "rx_bytes", "tx_bytes",
 	"rx_dropped", "tx_dropped", "tx_timeouts",
+	"rx_skb_alloc_fail", "rx_buf_alloc_fail", "rx_desc_err_dropped_pkt",
+	"interface_up_cnt", "interface_down_cnt", "reset_cnt",
+	"page_alloc_fail", "dma_mapping_error",
+};
+
+static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
+	"rx_posted_desc[%u]", "rx_completed_desc[%u]", "rx_bytes[%u]",
+	"rx_dropped_pkt[%u]", "rx_copybreak_pkt[%u]", "rx_copied_pkt[%u]",
+};
+
+static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
+	"tx_posted_desc[%u]", "tx_completed_desc[%u]", "tx_bytes[%u]",
+	"tx_wake[%u]", "tx_stop[%u]", "tx_event_counter[%u]",
+};
+
+static const char gve_gstrings_adminq_stats[][ETH_GSTRING_LEN] = {
+	"adminq_prod_cnt", "adminq_cmd_fail", "adminq_timeouts",
+	"adminq_describe_device_cnt", "adminq_cfg_device_resources_cnt",
+	"adminq_register_page_list_cnt", "adminq_unregister_page_list_cnt",
+	"adminq_create_tx_queue_cnt", "adminq_create_rx_queue_cnt",
+	"adminq_destroy_tx_queue_cnt", "adminq_destroy_rx_queue_cnt",
+	"adminq_dcfg_device_resources_cnt", "adminq_set_driver_parameter_cnt",
 };
 
 #define GVE_MAIN_STATS_LEN  ARRAY_SIZE(gve_gstrings_main_stats)
-#define NUM_GVE_TX_CNTS	5
-#define NUM_GVE_RX_CNTS	2
+#define GVE_ADMINQ_STATS_LEN  ARRAY_SIZE(gve_gstrings_adminq_stats)
+#define NUM_GVE_TX_CNTS	ARRAY_SIZE(gve_gstrings_tx_stats)
+#define NUM_GVE_RX_CNTS	ARRAY_SIZE(gve_gstrings_rx_stats)
 
 static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 	char *s = (char *)data;
-	int i;
+	int i, j;
 
 	if (stringset != ETH_SS_STATS)
 		return;
@@ -52,24 +75,24 @@ static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 	memcpy(s, *gve_gstrings_main_stats,
 	       sizeof(gve_gstrings_main_stats));
 	s += sizeof(gve_gstrings_main_stats);
+
 	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
-		snprintf(s, ETH_GSTRING_LEN, "rx_desc_cnt[%u]", i);
-		s += ETH_GSTRING_LEN;
-		snprintf(s, ETH_GSTRING_LEN, "rx_desc_fill_cnt[%u]", i);
-		s += ETH_GSTRING_LEN;
+		for (j = 0; j < NUM_GVE_RX_CNTS; j++) {
+			snprintf(s, ETH_GSTRING_LEN, gve_gstrings_rx_stats[j], i);
+			s += ETH_GSTRING_LEN;
+		}
 	}
+
 	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
-		snprintf(s, ETH_GSTRING_LEN, "tx_req[%u]", i);
-		s += ETH_GSTRING_LEN;
-		snprintf(s, ETH_GSTRING_LEN, "tx_done[%u]", i);
-		s += ETH_GSTRING_LEN;
-		snprintf(s, ETH_GSTRING_LEN, "tx_wake[%u]", i);
-		s += ETH_GSTRING_LEN;
-		snprintf(s, ETH_GSTRING_LEN, "tx_stop[%u]", i);
-		s += ETH_GSTRING_LEN;
-		snprintf(s, ETH_GSTRING_LEN, "tx_event_counter[%u]", i);
-		s += ETH_GSTRING_LEN;
+		for (j = 0; j < NUM_GVE_TX_CNTS; j++) {
+			snprintf(s, ETH_GSTRING_LEN, gve_gstrings_tx_stats[j], i);
+			s += ETH_GSTRING_LEN;
+		}
 	}
+
+	memcpy(s, *gve_gstrings_adminq_stats,
+	       sizeof(gve_gstrings_adminq_stats));
+	s += sizeof(gve_gstrings_adminq_stats);
 }
 
 static int gve_get_sset_count(struct net_device *netdev, int sset)
@@ -78,7 +101,7 @@ static int gve_get_sset_count(struct net_device *netdev, int sset)
 
 	switch (sset) {
 	case ETH_SS_STATS:
-		return GVE_MAIN_STATS_LEN +
+		return GVE_MAIN_STATS_LEN + GVE_ADMINQ_STATS_LEN +
 		       (priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS) +
 		       (priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS);
 	default:
@@ -90,24 +113,39 @@ static void
 gve_get_ethtool_stats(struct net_device *netdev,
 		      struct ethtool_stats *stats, u64 *data)
 {
-	struct gve_priv *priv = netdev_priv(netdev);
-	u64 rx_pkts, rx_bytes, tx_pkts, tx_bytes;
+	u64 tmp_rx_pkts, tmp_rx_bytes, tmp_rx_skb_alloc_fail,	tmp_rx_buf_alloc_fail,
+		tmp_rx_desc_err_dropped_pkt, tmp_tx_pkts, tmp_tx_bytes;
+	u64 rx_buf_alloc_fail, rx_desc_err_dropped_pkt, rx_pkts,
+		rx_skb_alloc_fail, rx_bytes, tx_pkts, tx_bytes;
+	struct gve_priv *priv;
 	unsigned int start;
 	int ring;
 	int i;
 
 	ASSERT_RTNL();
 
-	for (rx_pkts = 0, rx_bytes = 0, ring = 0;
+	priv = netdev_priv(netdev);
+	for (rx_pkts = 0, rx_bytes = 0, rx_skb_alloc_fail = 0,
+	     rx_buf_alloc_fail = 0, rx_desc_err_dropped_pkt = 0, ring = 0;
 	     ring < priv->rx_cfg.num_queues; ring++) {
 		if (priv->rx) {
 			do {
+				struct gve_rx_ring *rx = &priv->rx[ring];
 				start =
 				  u64_stats_fetch_begin(&priv->rx[ring].statss);
-				rx_pkts += priv->rx[ring].rpackets;
-				rx_bytes += priv->rx[ring].rbytes;
+				tmp_rx_pkts = rx->rpackets;
+				tmp_rx_bytes = rx->rbytes;
+				tmp_rx_skb_alloc_fail = rx->rx_skb_alloc_fail;
+				tmp_rx_buf_alloc_fail = rx->rx_buf_alloc_fail;
+				tmp_rx_desc_err_dropped_pkt =
+					rx->rx_desc_err_dropped_pkt;
 			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
 						       start));
+			rx_pkts += tmp_rx_pkts;
+			rx_bytes += tmp_rx_bytes;
+			rx_skb_alloc_fail += tmp_rx_skb_alloc_fail;
+			rx_buf_alloc_fail += tmp_rx_buf_alloc_fail;
+			rx_desc_err_dropped_pkt += tmp_rx_desc_err_dropped_pkt;
 		}
 	}
 	for (tx_pkts = 0, tx_bytes = 0, ring = 0;
@@ -116,10 +154,12 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			do {
 				start =
 				  u64_stats_fetch_begin(&priv->tx[ring].statss);
-				tx_pkts += priv->tx[ring].pkt_done;
-				tx_bytes += priv->tx[ring].bytes_done;
+				tmp_tx_pkts = priv->tx[ring].pkt_done;
+				tmp_tx_bytes = priv->tx[ring].bytes_done;
 			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
 						       start));
+			tx_pkts += tmp_tx_pkts;
+			tx_bytes += tmp_tx_bytes;
 		}
 	}
 
@@ -128,9 +168,21 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = tx_pkts;
 	data[i++] = rx_bytes;
 	data[i++] = tx_bytes;
-	/* Skip rx_dropped and tx_dropped */
-	i += 2;
+	/* total rx dropped packets */
+	data[i++] = rx_skb_alloc_fail + rx_buf_alloc_fail +
+		    rx_desc_err_dropped_pkt;
+	/* Skip tx_dropped */
+	i++;
+
 	data[i++] = priv->tx_timeo_cnt;
+	data[i++] = rx_skb_alloc_fail;
+	data[i++] = rx_buf_alloc_fail;
+	data[i++] = rx_desc_err_dropped_pkt;
+	data[i++] = priv->interface_up_cnt;
+	data[i++] = priv->interface_down_cnt;
+	data[i++] = priv->reset_cnt;
+	data[i++] = priv->page_alloc_fail;
+	data[i++] = priv->dma_mapping_error;
 	i = GVE_MAIN_STATS_LEN;
 
 	/* walk RX rings */
@@ -138,8 +190,25 @@ gve_get_ethtool_stats(struct net_device *netdev,
 		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
 			struct gve_rx_ring *rx = &priv->rx[ring];
 
-			data[i++] = rx->cnt;
 			data[i++] = rx->fill_cnt;
+			data[i++] = rx->cnt;
+			do {
+				start =
+				  u64_stats_fetch_begin(&priv->rx[ring].statss);
+				tmp_rx_bytes = rx->rbytes;
+				tmp_rx_skb_alloc_fail = rx->rx_skb_alloc_fail;
+				tmp_rx_buf_alloc_fail = rx->rx_buf_alloc_fail;
+				tmp_rx_desc_err_dropped_pkt =
+					rx->rx_desc_err_dropped_pkt;
+			} while (u64_stats_fetch_retry(&priv->rx[ring].statss,
+						       start));
+			data[i++] = tmp_rx_bytes;
+			/* rx dropped packets */
+			data[i++] = tmp_rx_skb_alloc_fail +
+				tmp_rx_buf_alloc_fail +
+				tmp_rx_desc_err_dropped_pkt;
+			data[i++] = rx->rx_copybreak_pkt;
+			data[i++] = rx->rx_copied_pkt;
 		}
 	} else {
 		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
@@ -151,6 +220,13 @@ gve_get_ethtool_stats(struct net_device *netdev,
 
 			data[i++] = tx->req;
 			data[i++] = tx->done;
+			do {
+				start =
+				  u64_stats_fetch_begin(&priv->tx[ring].statss);
+				tmp_tx_bytes = tx->bytes_done;
+			} while (u64_stats_fetch_retry(&priv->tx[ring].statss,
+						       start));
+			data[i++] = tmp_tx_bytes;
 			data[i++] = tx->wake_queue;
 			data[i++] = tx->stop_queue;
 			data[i++] = be32_to_cpu(gve_tx_load_event_counter(priv,
@@ -159,6 +235,20 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	} else {
 		i += priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS;
 	}
+	/* AQ Stats */
+	data[i++] = priv->adminq_prod_cnt;
+	data[i++] = priv->adminq_cmd_fail;
+	data[i++] = priv->adminq_timeouts;
+	data[i++] = priv->adminq_describe_device_cnt;
+	data[i++] = priv->adminq_cfg_device_resources_cnt;
+	data[i++] = priv->adminq_register_page_list_cnt;
+	data[i++] = priv->adminq_unregister_page_list_cnt;
+	data[i++] = priv->adminq_create_tx_queue_cnt;
+	data[i++] = priv->adminq_create_rx_queue_cnt;
+	data[i++] = priv->adminq_destroy_tx_queue_cnt;
+	data[i++] = priv->adminq_destroy_rx_queue_cnt;
+	data[i++] = priv->adminq_dcfg_device_resources_cnt;
+	data[i++] = priv->adminq_set_driver_parameter_cnt;
 }
 
 static void gve_get_channels(struct net_device *netdev,
@@ -245,7 +335,8 @@ static int gve_get_tunable(struct net_device *netdev,
 }
 
 static int gve_set_tunable(struct net_device *netdev,
-			   const struct ethtool_tunable *etuna, const void *value)
+			   const struct ethtool_tunable *etuna,
+			   const void *value)
 {
 	struct gve_priv *priv = netdev_priv(netdev);
 	u32 len;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index e032563ceefd..4f6c1fc9c58d 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -514,14 +514,18 @@ static void gve_free_rings(struct gve_priv *priv)
 	}
 }
 
-int gve_alloc_page(struct device *dev, struct page **page, dma_addr_t *dma,
+int gve_alloc_page(struct gve_priv *priv, struct device *dev,
+		   struct page **page, dma_addr_t *dma,
 		   enum dma_data_direction dir)
 {
 	*page = alloc_page(GFP_KERNEL);
-	if (!*page)
+	if (!*page) {
+		priv->page_alloc_fail++;
 		return -ENOMEM;
+	}
 	*dma = dma_map_page(dev, *page, 0, PAGE_SIZE, dir);
 	if (dma_mapping_error(dev, *dma)) {
+		priv->dma_mapping_error++;
 		put_page(*page);
 		return -ENOMEM;
 	}
@@ -556,7 +560,7 @@ static int gve_alloc_queue_page_list(struct gve_priv *priv, u32 id,
 		return -ENOMEM;
 
 	for (i = 0; i < pages; i++) {
-		err = gve_alloc_page(&priv->pdev->dev, &qpl->pages[i],
+		err = gve_alloc_page(priv, &priv->pdev->dev, &qpl->pages[i],
 				     &qpl->page_buses[i],
 				     gve_qpl_dma_dir(priv, id));
 		/* caller handles clean up */
@@ -697,6 +701,7 @@ static int gve_open(struct net_device *dev)
 
 	gve_turnup(priv);
 	netif_carrier_on(dev);
+	priv->interface_up_cnt++;
 	return 0;
 
 free_rings:
@@ -738,6 +743,7 @@ static int gve_close(struct net_device *dev)
 
 	gve_free_rings(priv);
 	gve_free_qpls(priv);
+	priv->interface_down_cnt++;
 	return 0;
 
 err:
@@ -1047,6 +1053,9 @@ int gve_reset(struct gve_priv *priv, bool attempt_teardown)
 	/* Set it all back up */
 	err = gve_reset_recovery(priv, was_up);
 	gve_clear_reset_in_progress(priv);
+	priv->reset_cnt++;
+	priv->interface_up_cnt = 0;
+	priv->interface_down_cnt = 0;
 	return err;
 }
 
diff --git a/drivers/net/ethernet/google/gve/gve_rx.c b/drivers/net/ethernet/google/gve/gve_rx.c
index 9f52e72ff641..008fa897a3e6 100644
--- a/drivers/net/ethernet/google/gve/gve_rx.c
+++ b/drivers/net/ethernet/google/gve/gve_rx.c
@@ -225,7 +225,8 @@ static enum pkt_hash_types gve_rss_type(__be16 pkt_flags)
 	return PKT_HASH_TYPE_L2;
 }
 
-static struct sk_buff *gve_rx_copy(struct net_device *dev,
+static struct sk_buff *gve_rx_copy(struct gve_rx_ring *rx,
+				   struct net_device *dev,
 				   struct napi_struct *napi,
 				   struct gve_rx_slot_page_info *page_info,
 				   u16 len)
@@ -242,6 +243,11 @@ static struct sk_buff *gve_rx_copy(struct net_device *dev,
 	skb_copy_to_linear_data(skb, va, len);
 
 	skb->protocol = eth_type_trans(skb, dev);
+
+	u64_stats_update_begin(&rx->statss);
+	rx->rx_copied_pkt++;
+	u64_stats_update_end(&rx->statss);
+
 	return skb;
 }
 
@@ -284,8 +290,12 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	u16 len;
 
 	/* drop this packet */
-	if (unlikely(rx_desc->flags_seq & GVE_RXF_ERR))
+	if (unlikely(rx_desc->flags_seq & GVE_RXF_ERR)) {
+		u64_stats_update_begin(&rx->statss);
+		rx->rx_desc_err_dropped_pkt++;
+		u64_stats_update_end(&rx->statss);
 		return true;
+	}
 
 	len = be16_to_cpu(rx_desc->len) - GVE_RX_PAD;
 	page_info = &rx->data.page_info[idx];
@@ -300,11 +310,14 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 	if (PAGE_SIZE == 4096) {
 		if (len <= priv->rx_copybreak) {
 			/* Just copy small packets */
-			skb = gve_rx_copy(dev, napi, page_info, len);
+			skb = gve_rx_copy(rx, dev, napi, page_info, len);
+			u64_stats_update_begin(&rx->statss);
+			rx->rx_copybreak_pkt++;
+			u64_stats_update_end(&rx->statss);
 			goto have_skb;
 		}
 		if (unlikely(!gve_can_recycle_pages(dev))) {
-			skb = gve_rx_copy(dev, napi, page_info, len);
+			skb = gve_rx_copy(rx, dev, napi, page_info, len);
 			goto have_skb;
 		}
 		pagecount = page_count(page_info->page);
@@ -314,8 +327,12 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 			 * stack.
 			 */
 			skb = gve_rx_add_frags(dev, napi, page_info, len);
-			if (!skb)
+			if (!skb) {
+				u64_stats_update_begin(&rx->statss);
+				rx->rx_skb_alloc_fail++;
+				u64_stats_update_end(&rx->statss);
 				return true;
+			}
 			/* Make sure the kernel stack can't release the page */
 			get_page(page_info->page);
 			/* "flip" to other packet buffer on this page */
@@ -324,21 +341,25 @@ static bool gve_rx(struct gve_rx_ring *rx, struct gve_rx_desc *rx_desc,
 			/* We have previously passed the other half of this
 			 * page up the stack, but it has not yet been freed.
 			 */
-			skb = gve_rx_copy(dev, napi, page_info, len);
+			skb = gve_rx_copy(rx, dev, napi, page_info, len);
 		} else {
 			WARN(pagecount < 1, "Pagecount should never be < 1");
 			return false;
 		}
 	} else {
-		skb = gve_rx_copy(dev, napi, page_info, len);
+		skb = gve_rx_copy(rx, dev, napi, page_info, len);
 	}
 
 have_skb:
 	/* We didn't manage to allocate an skb but we haven't had any
 	 * reset worthy failures.
 	 */
-	if (!skb)
+	if (!skb) {
+		u64_stats_update_begin(&rx->statss);
+		rx->rx_skb_alloc_fail++;
+		u64_stats_update_end(&rx->statss);
 		return true;
+	}
 
 	if (likely(feat & NETIF_F_RXCSUM)) {
 		/* NIC passes up the partial sum */
-- 
2.28.0.402.g5ffc5be6b7-goog


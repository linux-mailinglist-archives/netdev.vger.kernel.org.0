Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA4D0248EE5
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 21:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbgHRTov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 15:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726735AbgHRToj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 15:44:39 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B58EC061343
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:39 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id w23so5333187pll.21
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 12:44:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=LuFm8c4ufe5wpgh8QLgEb4Aejp7No/rsdwF6bNCiLnE=;
        b=Ga8ZDpqSdVY9DvhBgFl59Z2sMn5dWXsp9RiBx3CVktAJla/gXgZhSJ6KtFZN1lLkeE
         pWwDOdCZbhEep1jkbq4PdG0ZAU+oIlEDggly20YOB+AlLlreZFkC2p6nhhoqlGH3zL0/
         4FXgjmjNYA7isBvBEMwkeIvL8GFhwiumoe/vX4fDmTkdsVZOp/0Io7MNHefIKrQMBF5G
         lots9dkwHdp54mxXMjJzN8MZeWrvA1rX6uDyve7CEDU1aQKy0Tj0XnNco2TN+wdR8zi4
         oTJ1iPb67MpLPmgtvizkKu16rxTTn+jNtyTYlo5b2MlXdo2lWXnoLXA714ZTt1/IFVlq
         GVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=LuFm8c4ufe5wpgh8QLgEb4Aejp7No/rsdwF6bNCiLnE=;
        b=uaJa2+ReKKeKSq4ctGFwHKMHSEqIcM88jukjin7aqSiJEovfWHAZD2/7g/qn28vnHH
         GhIsvHQZLNqVT/BWwPjLUVYuJqpar0IQjFztrfJvsTtByAtMWfxIwZv1C+Hf+nLmTc5T
         WAM3zRaLEKngfuZ6gZphZQD5EETtM1luJzvKu9Rz8afRk4ZhHky215vaJlBUg4UygI/T
         cMMMBZ0rKqYFVuQQyMmbMBXLi4n6MjcFCU8jqx0eQyc/HDe0FZaKSxut4yTW/Xvq39nz
         Olq6qPnZQCBYvPBplQumrdTSAS0rtRFrnH1sZrISAedLgev/Fj4eCrvUZ5ze/G7HbmdL
         2ASA==
X-Gm-Message-State: AOAM530upJiyo7SW7vOAYgTCUQg1kXRqvKoNWQE4shujoy56YkFRG+mc
        i3G6rbMwJiSwF4ag/2HQ4YVLKKu3HJ6lnv+b+pKCGxN+gfpBpKDE/NkP0p54C61GIFCC+uh19m+
        0OFjJ7eUu7bqOP03Eg3up+pJvwWTt5EMMD1DSIQvnzfB3f9Jpmdpot1mVZ647cY/zst+GleKq
X-Google-Smtp-Source: ABdhPJy8VHVitWQFaY/afQcWLE8ywSCnpbo3UBTLwmwbo+qBykplyv4v/OlO7IBjaKigGf1dGFiPD9RJSwIa8WrC
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:90a:e687:: with SMTP id
 s7mr1227873pjy.48.1597779878927; Tue, 18 Aug 2020 12:44:38 -0700 (PDT)
Date:   Tue, 18 Aug 2020 12:44:04 -0700
In-Reply-To: <20200818194417.2003932-1-awogbemila@google.com>
Message-Id: <20200818194417.2003932-6-awogbemila@google.com>
Mime-Version: 1.0
References: <20200818194417.2003932-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.220.ged08abb693-goog
Subject: [PATCH net-next 05/18] gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.
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

Changes:
- Add a new flag in service_task_flags. Check both this flag and
ethtool flag when handle report stats. Update the stats when user turns
ethtool flag on.

- In order to expose the NIC stats to the guest even when the ethtool flag
is off, share the address and length of report at setup. When the
ethtool flag turned off, zero off the gve stats instead of detaching the
report. Only detach the report in free_stats_report.

- Adds the NIC stats to ethtool stats. These stats are always
exposed to guest no matter the report stats flag is turned
on or off.

- Update gve stats once every 20 seconds.

- Add a field for the interval of updating stats report to the AQ
command. It will be exposed to USPS so that USPS can use the same
interval to update its stats in the report.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Kuo Zhao <kuozhao@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  77 ++++++-
 drivers/net/ethernet/google/gve/gve_adminq.c  |  21 ++
 drivers/net/ethernet/google/gve/gve_adminq.h  |  43 ++++
 drivers/net/ethernet/google/gve/gve_ethtool.c | 204 ++++++++++++++++--
 drivers/net/ethernet/google/gve/gve_main.c    | 147 ++++++++++++-
 .../net/ethernet/google/gve/gve_register.h    |   1 +
 6 files changed, 458 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 37a3bbced36a..bc54059f9b2e 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -27,6 +27,17 @@
 /* 1 for management, 1 for rx, 1 for tx */
 #define GVE_MIN_MSIX 3
 
+/* Numbers of gve tx/rx stats in stats report. */
+#define GVE_TX_STATS_REPORT_NUM	5
+#define GVE_RX_STATS_REPORT_NUM	2
+
+/* Numbers of NIC tx/rx stats in stats report. */
+#define NIC_TX_STATS_REPORT_NUM	0
+#define NIC_RX_STATS_REPORT_NUM	4
+
+/* Interval to schedule a service task, 20000ms. */
+#define GVE_SERVICE_TIMER_PERIOD	20000
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
@@ -220,6 +231,7 @@ struct gve_priv {
 	u32 adminq_destroy_rx_queue_cnt;
 	u32 adminq_dcfg_device_resources_cnt;
 	u32 adminq_set_driver_parameter_cnt;
+	u32 adminq_report_stats_cnt;
 
 	/* Global stats */
 	u32 interface_up_cnt; /* count of times interface turned up since last reset */
@@ -227,27 +239,39 @@ struct gve_priv {
 	u32 reset_cnt; /* count of reset */
 	u32 page_alloc_fail; /* count of page alloc fails */
 	u32 dma_mapping_error; /* count of dma mapping errors */
-
 	struct workqueue_struct *gve_wq;
 	struct work_struct service_task;
 	unsigned long service_task_flags;
 	unsigned long state_flags;
 
+	struct gve_stats_report *stats_report;
+	u64 stats_report_len;
+	dma_addr_t stats_report_bus; /* dma address for the stats report */
+	unsigned long ethtool_flags;
+
+	unsigned long service_timer_period;
+	struct timer_list service_timer;
+
   /* Gvnic device's dma mask, set during probe. */
 	u8 dma_mask;
 };
 
-enum gve_service_task_flags {
-	GVE_PRIV_FLAGS_DO_RESET			= BIT(1),
-	GVE_PRIV_FLAGS_RESET_IN_PROGRESS	= BIT(2),
-	GVE_PRIV_FLAGS_PROBE_IN_PROGRESS	= BIT(3),
+enum gve_service_task_flags_bit {
+	GVE_PRIV_FLAGS_DO_RESET			= 1,
+	GVE_PRIV_FLAGS_RESET_IN_PROGRESS	= 2,
+	GVE_PRIV_FLAGS_PROBE_IN_PROGRESS	= 3,
+	GVE_PRIV_FLAGS_DO_REPORT_STATS = 4,
+};
+
+enum gve_state_flags_bit {
+	GVE_PRIV_FLAGS_ADMIN_QUEUE_OK		= 1,
+	GVE_PRIV_FLAGS_DEVICE_RESOURCES_OK	= 2,
+	GVE_PRIV_FLAGS_DEVICE_RINGS_OK		= 3,
+	GVE_PRIV_FLAGS_NAPI_ENABLED		= 4,
 };
 
-enum gve_state_flags {
-	GVE_PRIV_FLAGS_ADMIN_QUEUE_OK		= BIT(1),
-	GVE_PRIV_FLAGS_DEVICE_RESOURCES_OK	= BIT(2),
-	GVE_PRIV_FLAGS_DEVICE_RINGS_OK		= BIT(3),
-	GVE_PRIV_FLAGS_NAPI_ENABLED		= BIT(4),
+enum gve_ethtool_flags_bit {
+	GVE_PRIV_FLAGS_REPORT_STATS		= 0,
 };
 
 static inline bool gve_get_do_reset(struct gve_priv *priv)
@@ -297,6 +321,22 @@ static inline void gve_clear_probe_in_progress(struct gve_priv *priv)
 	clear_bit(GVE_PRIV_FLAGS_PROBE_IN_PROGRESS, &priv->service_task_flags);
 }
 
+static inline bool gve_get_do_report_stats(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_DO_REPORT_STATS,
+			&priv->service_task_flags);
+}
+
+static inline void gve_set_do_report_stats(struct gve_priv *priv)
+{
+	set_bit(GVE_PRIV_FLAGS_DO_REPORT_STATS, &priv->service_task_flags);
+}
+
+static inline void gve_clear_do_report_stats(struct gve_priv *priv)
+{
+	clear_bit(GVE_PRIV_FLAGS_DO_REPORT_STATS, &priv->service_task_flags);
+}
+
 static inline bool gve_get_admin_queue_ok(struct gve_priv *priv)
 {
 	return test_bit(GVE_PRIV_FLAGS_ADMIN_QUEUE_OK, &priv->state_flags);
@@ -357,6 +397,21 @@ static inline void gve_clear_napi_enabled(struct gve_priv *priv)
 	clear_bit(GVE_PRIV_FLAGS_NAPI_ENABLED, &priv->state_flags);
 }
 
+static inline bool gve_get_report_stats(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
+}
+
+static inline void gve_set_report_stats(struct gve_priv *priv)
+{
+	set_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
+}
+
+static inline void gve_clear_report_stats(struct gve_priv *priv)
+{
+	clear_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
+}
+
 /* Returns the address of the ntfy_blocks irq doorbell
  */
 static inline __be32 __iomem *gve_irq_doorbell(struct gve_priv *priv,
@@ -478,6 +533,8 @@ int gve_reset(struct gve_priv *priv, bool attempt_teardown);
 int gve_adjust_queues(struct gve_priv *priv,
 		      struct gve_queue_config new_rx_config,
 		      struct gve_queue_config new_tx_config);
+/* report stats handling */
+void gve_handle_report_stats(struct gve_priv *priv);
 /* exported by ethtool.c */
 extern const struct ethtool_ops gve_ethtool_ops;
 /* needed by ethtool */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 6a93fe8e6a2b..38e0c3066035 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -35,6 +35,7 @@ int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
 	priv->adminq_destroy_rx_queue_cnt = 0;
 	priv->adminq_dcfg_device_resources_cnt = 0;
 	priv->adminq_set_driver_parameter_cnt = 0;
+	priv->adminq_report_stats_cnt = 0;
 
 	/* Setup Admin queue with the device */
 	iowrite32be(priv->adminq_bus_addr / PAGE_SIZE,
@@ -183,6 +184,9 @@ int gve_adminq_execute_cmd(struct gve_priv *priv,
 	case GVE_ADMINQ_SET_DRIVER_PARAMETER:
 		priv->adminq_set_driver_parameter_cnt++;
 		break;
+	case GVE_ADMINQ_REPORT_STATS:
+		priv->adminq_report_stats_cnt++;
+		break;
 	default:
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
 	}
@@ -433,3 +437,20 @@ int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu)
 
 	return gve_adminq_execute_cmd(priv, &cmd);
 }
+
+int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
+			    dma_addr_t stats_report_addr, u64 interval)
+{
+	union gve_adminq_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_REPORT_STATS);
+	cmd.report_stats = (struct gve_adminq_report_stats) {
+		.stats_report_len = cpu_to_be64(stats_report_len),
+		.stats_report_addr = cpu_to_be64(stats_report_addr),
+		.interval = cpu_to_be64(interval),
+	};
+
+	return gve_adminq_execute_cmd(priv, &cmd);
+}
+
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 4dfa06edc0f8..a6c8c29f0d13 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -21,6 +21,7 @@ enum gve_adminq_opcodes {
 	GVE_ADMINQ_DESTROY_RX_QUEUE		= 0x8,
 	GVE_ADMINQ_DECONFIGURE_DEVICE_RESOURCES	= 0x9,
 	GVE_ADMINQ_SET_DRIVER_PARAMETER		= 0xB,
+	GVE_ADMINQ_REPORT_STATS			= 0xC,
 };
 
 /* Admin queue status codes */
@@ -172,6 +173,45 @@ struct gve_adminq_set_driver_parameter {
 
 static_assert(sizeof(struct gve_adminq_set_driver_parameter) == 16);
 
+struct gve_adminq_report_stats {
+	__be64 stats_report_len;
+	__be64 stats_report_addr;
+	__be64 interval;
+};
+
+static_assert(sizeof(struct gve_adminq_report_stats) == 24);
+
+struct stats {
+	__be32 stat_name;
+	__be32 queue_id;
+	__be64 value;
+};
+
+static_assert(sizeof(struct stats) == 16);
+
+struct gve_stats_report {
+	__be64 written_count;
+	struct stats stats[0];
+};
+
+static_assert(sizeof(struct gve_stats_report) == 8);
+
+enum gve_stat_names {
+	// stats from gve
+	TX_WAKE_CNT			= 1,
+	TX_STOP_CNT			= 2,
+	TX_FRAMES_SENT			= 3,
+	TX_BYTES_SENT			= 4,
+	TX_LAST_COMPLETION_PROCESSED	= 5,
+	RX_NEXT_EXPECTED_SEQUENCE	= 6,
+	RX_BUFFERS_POSTED		= 7,
+	// stats from NIC
+	RX_QUEUE_DROP_CNT		= 65,
+	RX_NO_BUFFERS_POSTED		= 66,
+	RX_DROPS_PACKET_OVER_MRU	= 67,
+	RX_DROPS_INVALID_CHECKSUM	= 68,
+};
+
 union gve_adminq_command {
 	struct {
 		__be32 opcode;
@@ -187,6 +227,7 @@ union gve_adminq_command {
 			struct gve_adminq_register_page_list reg_page_list;
 			struct gve_adminq_unregister_page_list unreg_page_list;
 			struct gve_adminq_set_driver_parameter set_driver_param;
+			struct gve_adminq_report_stats report_stats;
 		};
 	};
 	u8 reserved[64];
@@ -214,4 +255,6 @@ int gve_adminq_register_page_list(struct gve_priv *priv,
 				  struct gve_queue_page_list *qpl);
 int gve_adminq_unregister_page_list(struct gve_priv *priv, u32 page_list_id);
 int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu);
+int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
+			    dma_addr_t stats_report_addr, u64 interval);
 #endif /* _GVE_ADMINQ_H */
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index ebbf2c4c444e..9d778e04b9f4 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -6,6 +6,7 @@
 
 #include <linux/rtnetlink.h>
 #include "gve.h"
+#include "gve_adminq.h"
 
 static void gve_get_drvinfo(struct net_device *netdev,
 			    struct ethtool_drvinfo *info)
@@ -42,6 +43,8 @@ static const char gve_gstrings_main_stats[][ETH_GSTRING_LEN] = {
 static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
 	"rx_posted_desc[%u]", "rx_completed_desc[%u]", "rx_bytes[%u]",
 	"rx_dropped_pkt[%u]", "rx_copybreak_pkt[%u]", "rx_copied_pkt[%u]",
+	"rx_queue_drop_cnt[%u]", "rx_no_buffers_posted[%u]",
+	"rx_drops_packet_over_mru[%u]", "rx_drops_invalid_checksum[%u]",
 };
 
 static const char gve_gstrings_tx_stats[][ETH_GSTRING_LEN] = {
@@ -56,12 +59,18 @@ static const char gve_gstrings_adminq_stats[][ETH_GSTRING_LEN] = {
 	"adminq_create_tx_queue_cnt", "adminq_create_rx_queue_cnt",
 	"adminq_destroy_tx_queue_cnt", "adminq_destroy_rx_queue_cnt",
 	"adminq_dcfg_device_resources_cnt", "adminq_set_driver_parameter_cnt",
+	"adminq_report_stats_cnt",
+};
+
+static const char gve_gstrings_priv_flags[][ETH_GSTRING_LEN] = {
+	"report-stats",
 };
 
 #define GVE_MAIN_STATS_LEN  ARRAY_SIZE(gve_gstrings_main_stats)
 #define GVE_ADMINQ_STATS_LEN  ARRAY_SIZE(gve_gstrings_adminq_stats)
 #define NUM_GVE_TX_CNTS	ARRAY_SIZE(gve_gstrings_tx_stats)
 #define NUM_GVE_RX_CNTS	ARRAY_SIZE(gve_gstrings_rx_stats)
+#define GVE_PRIV_FLAGS_STR_LEN ARRAY_SIZE(gve_gstrings_priv_flags)
 
 static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 {
@@ -69,30 +78,42 @@ static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 	char *s = (char *)data;
 	int i, j;
 
-	if (stringset != ETH_SS_STATS)
-		return;
-
-	memcpy(s, *gve_gstrings_main_stats,
-	       sizeof(gve_gstrings_main_stats));
-	s += sizeof(gve_gstrings_main_stats);
-
-	for (i = 0; i < priv->rx_cfg.num_queues; i++) {
-		for (j = 0; j < NUM_GVE_RX_CNTS; j++) {
-			snprintf(s, ETH_GSTRING_LEN, gve_gstrings_rx_stats[j], i);
-			s += ETH_GSTRING_LEN;
+	switch (stringset) {
+	case ETH_SS_STATS:
+		memcpy(s, *gve_gstrings_main_stats,
+		       sizeof(gve_gstrings_main_stats));
+		s += sizeof(gve_gstrings_main_stats);
+
+		for (i = 0; i < priv->rx_cfg.num_queues; i++) {
+			for (j = 0; j < NUM_GVE_RX_CNTS; j++) {
+				snprintf(s, ETH_GSTRING_LEN,
+					 gve_gstrings_rx_stats[j], i);
+				s += ETH_GSTRING_LEN;
+			}
 		}
-	}
 
-	for (i = 0; i < priv->tx_cfg.num_queues; i++) {
-		for (j = 0; j < NUM_GVE_TX_CNTS; j++) {
-			snprintf(s, ETH_GSTRING_LEN, gve_gstrings_tx_stats[j], i);
-			s += ETH_GSTRING_LEN;
+		for (i = 0; i < priv->tx_cfg.num_queues; i++) {
+			for (j = 0; j < NUM_GVE_TX_CNTS; j++) {
+				snprintf(s, ETH_GSTRING_LEN,
+					 gve_gstrings_tx_stats[j], i);
+				s += ETH_GSTRING_LEN;
+			}
 		}
-	}
 
-	memcpy(s, *gve_gstrings_adminq_stats,
-	       sizeof(gve_gstrings_adminq_stats));
-	s += sizeof(gve_gstrings_adminq_stats);
+		memcpy(s, *gve_gstrings_adminq_stats,
+		       sizeof(gve_gstrings_adminq_stats));
+		s += sizeof(gve_gstrings_adminq_stats);
+		break;
+
+	case ETH_SS_PRIV_FLAGS:
+		memcpy(s, *gve_gstrings_priv_flags,
+		       sizeof(gve_gstrings_priv_flags));
+		s += sizeof(gve_gstrings_priv_flags);
+		break;
+
+	default:
+		break;
+	}
 }
 
 static int gve_get_sset_count(struct net_device *netdev, int sset)
@@ -104,6 +125,8 @@ static int gve_get_sset_count(struct net_device *netdev, int sset)
 		return GVE_MAIN_STATS_LEN + GVE_ADMINQ_STATS_LEN +
 		       (priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS) +
 		       (priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS);
+	case ETH_SS_PRIV_FLAGS:
+		return GVE_PRIV_FLAGS_STR_LEN;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -113,18 +136,36 @@ static void
 gve_get_ethtool_stats(struct net_device *netdev,
 		      struct ethtool_stats *stats, u64 *data)
 {
+	u64 rx_pkts, rx_bytes, rx_skb_alloc_fail, rx_buf_alloc_fail,
+		rx_desc_err_dropped_pkt, tx_pkts,
+		tx_bytes;
 	u64 tmp_rx_pkts, tmp_rx_bytes, tmp_rx_skb_alloc_fail,
 		tmp_rx_buf_alloc_fail, tmp_rx_desc_err_dropped_pkt,
 		tmp_tx_pkts, tmp_tx_bytes;
-	u64 rx_pkts, rx_bytes, rx_skb_alloc_fail, rx_buf_alloc_fail,
-		rx_desc_err_dropped_pkt, tx_pkts, tx_bytes;
+	int stats_idx, base_stats_idx, max_stats_idx;
 	struct gve_priv *priv = netdev_priv(netdev);
+	struct stats *report_stats;
+	int *rx_qid_to_stats_idx;
+	int *tx_qid_to_stats_idx;
+	bool skip_nic_stats;
 	unsigned int start;
 	int ring;
-	int i;
+	int i, j;
 
 	ASSERT_RTNL();
 
+	report_stats = priv->stats_report->stats;
+	rx_qid_to_stats_idx = kmalloc_array(priv->rx_cfg.num_queues,
+					    sizeof(int), GFP_KERNEL);
+	if (!rx_qid_to_stats_idx)
+		return;
+	tx_qid_to_stats_idx = kmalloc_array(priv->tx_cfg.num_queues,
+					    sizeof(int), GFP_KERNEL);
+	if (!tx_qid_to_stats_idx) {
+		kfree(rx_qid_to_stats_idx);
+		return;
+	}
+
 	for (rx_pkts = 0, rx_bytes = 0, rx_skb_alloc_fail = 0,
 	     rx_buf_alloc_fail = 0, rx_desc_err_dropped_pkt = 0, ring = 0;
 	     ring < priv->rx_cfg.num_queues; ring++) {
@@ -185,6 +226,25 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = priv->dma_mapping_error;
 	i = GVE_MAIN_STATS_LEN;
 
+	/* For rx cross-reporting stats, start from nic rx stats in report */
+	base_stats_idx = GVE_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
+		GVE_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues;
+	max_stats_idx = NIC_RX_STATS_REPORT_NUM * priv->rx_cfg.num_queues +
+		base_stats_idx;
+	/* Preprocess the stats report for rx, map queue id to start index */
+	skip_nic_stats = false;
+	for (stats_idx = base_stats_idx; stats_idx < max_stats_idx;
+		stats_idx += NIC_RX_STATS_REPORT_NUM) {
+		u32 stat_name = be32_to_cpu(report_stats[stats_idx].stat_name);
+		u32 queue_id = be32_to_cpu(report_stats[stats_idx].queue_id);
+
+		if (stat_name == 0) {
+			/* no stats written by NIC yet */
+			skip_nic_stats = true;
+			break;
+		}
+		rx_qid_to_stats_idx[queue_id] = stats_idx;
+	}
 	/* walk RX rings */
 	if (priv->rx) {
 		for (ring = 0; ring < priv->rx_cfg.num_queues; ring++) {
@@ -209,10 +269,41 @@ gve_get_ethtool_stats(struct net_device *netdev,
 				tmp_rx_desc_err_dropped_pkt;
 			data[i++] = rx->rx_copybreak_pkt;
 			data[i++] = rx->rx_copied_pkt;
+			/* stats from NIC */
+			if (skip_nic_stats) {
+				/* skip NIC rx stats */
+				i += NIC_RX_STATS_REPORT_NUM;
+				continue;
+			}
+			for (j = 0; j < NIC_RX_STATS_REPORT_NUM; j++) {
+				u64 value =
+				be64_to_cpu(report_stats[rx_qid_to_stats_idx[ring] + j].value);
+
+				data[i++] = value;
+			}
 		}
 	} else {
 		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
 	}
+
+	/* For tx cross-reporting stats, start from nic tx stats in report */
+	base_stats_idx = max_stats_idx;
+	max_stats_idx = NIC_TX_STATS_REPORT_NUM * priv->tx_cfg.num_queues +
+		max_stats_idx;
+	/* Preprocess the stats report for tx, map queue id to start index */
+	skip_nic_stats = false;
+	for (stats_idx = base_stats_idx; stats_idx < max_stats_idx;
+		stats_idx += NIC_TX_STATS_REPORT_NUM) {
+		u32 stat_name = be32_to_cpu(report_stats[stats_idx].stat_name);
+		u32 queue_id = be32_to_cpu(report_stats[stats_idx].queue_id);
+
+		if (stat_name == 0) {
+			/* no stats written by NIC yet */
+			skip_nic_stats = true;
+			break;
+		}
+		tx_qid_to_stats_idx[queue_id] = stats_idx;
+	}
 	/* walk TX rings */
 	if (priv->tx) {
 		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
@@ -231,10 +322,26 @@ gve_get_ethtool_stats(struct net_device *netdev,
 			data[i++] = tx->stop_queue;
 			data[i++] = be32_to_cpu(gve_tx_load_event_counter(priv,
 									  tx));
+			/* stats from NIC */
+			if (skip_nic_stats) {
+				/* skip NIC tx stats */
+				i += NIC_TX_STATS_REPORT_NUM;
+				continue;
+			}
+			for (j = 0; j < NIC_TX_STATS_REPORT_NUM; j++) {
+				u64 value =
+				be64_to_cpu(report_stats[tx_qid_to_stats_idx[ring] + j].value);
+
+				data[i++] = value;
+			}
 		}
 	} else {
 		i += priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS;
 	}
+
+	kfree(rx_qid_to_stats_idx);
+	kfree(tx_qid_to_stats_idx);
+
 	/* AQ Stats */
 	data[i++] = priv->adminq_prod_cnt;
 	data[i++] = priv->adminq_cmd_fail;
@@ -249,6 +356,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = priv->adminq_destroy_rx_queue_cnt;
 	data[i++] = priv->adminq_dcfg_device_resources_cnt;
 	data[i++] = priv->adminq_set_driver_parameter_cnt;
+	data[i++] = priv->adminq_report_stats_cnt;
 }
 
 static void gve_get_channels(struct net_device *netdev,
@@ -353,6 +461,54 @@ static int gve_set_tunable(struct net_device *netdev,
 	}
 }
 
+static u32 gve_get_priv_flags(struct net_device *netdev)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	u32 i, ret_flags = 0;
+
+	for (i = 0; i < GVE_PRIV_FLAGS_STR_LEN; i++) {
+		if (priv->ethtool_flags & BIT(i))
+			ret_flags |= BIT(i);
+	}
+	return ret_flags;
+}
+
+static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	u64 ori_flags, new_flags;
+	u32 i;
+
+	ori_flags = READ_ONCE(priv->ethtool_flags);
+	new_flags = ori_flags;
+
+	for (i = 0; i < GVE_PRIV_FLAGS_STR_LEN; i++) {
+		if (flags & BIT(i))
+			new_flags |= BIT(i);
+		else
+			new_flags &= ~(BIT(i));
+		priv->ethtool_flags = new_flags;
+		/* set report-stats */
+		if (strcmp(gve_gstrings_priv_flags[i], "report-stats") == 0) {
+			/* update the stats when user turns report-stats on */
+			if (flags & BIT(i))
+				gve_handle_report_stats(priv);
+			/* zero off gve stats when report-stats turned off */
+			if (!(flags & BIT(i)) && (ori_flags & BIT(i))) {
+				int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
+					priv->tx_cfg.num_queues;
+				int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
+					priv->rx_cfg.num_queues;
+				memset(priv->stats_report->stats, 0,
+				       (tx_stats_num + rx_stats_num) *
+				       sizeof(struct stats));
+			}
+		}
+	}
+
+	return 0;
+}
+
 const struct ethtool_ops gve_ethtool_ops = {
 	.get_drvinfo = gve_get_drvinfo,
 	.get_strings = gve_get_strings,
@@ -367,4 +523,6 @@ const struct ethtool_ops gve_ethtool_ops = {
 	.reset = gve_user_reset,
 	.get_tunable = gve_get_tunable,
 	.set_tunable = gve_set_tunable,
+	.get_priv_flags = gve_get_priv_flags,
+	.set_priv_flags = gve_set_priv_flags,
 };
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 449345d24f29..099d61f00bf0 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -78,6 +78,59 @@ static void gve_free_counter_array(struct gve_priv *priv)
 	priv->counter_array = NULL;
 }
 
+static void gve_service_task_schedule(struct gve_priv *priv)
+{
+	if (!gve_get_probe_in_progress(priv) &&
+	    !gve_get_reset_in_progress(priv)) {
+		gve_set_do_report_stats(priv);
+		queue_work(priv->gve_wq, &priv->service_task);
+	}
+}
+
+static void gve_service_timer(struct timer_list *t)
+{
+	struct gve_priv *priv = from_timer(priv, t, service_timer);
+
+	mod_timer(&priv->service_timer,
+		  round_jiffies(jiffies +
+		  msecs_to_jiffies(priv->service_timer_period)));
+	gve_service_task_schedule(priv);
+}
+
+static int gve_alloc_stats_report(struct gve_priv *priv)
+{
+	int tx_stats_num, rx_stats_num;
+
+	tx_stats_num = (GVE_TX_STATS_REPORT_NUM + NIC_TX_STATS_REPORT_NUM) *
+		       priv->tx_cfg.num_queues;
+	rx_stats_num = (GVE_RX_STATS_REPORT_NUM + NIC_RX_STATS_REPORT_NUM) *
+		       priv->rx_cfg.num_queues;
+	priv->stats_report_len = sizeof(struct gve_stats_report) +
+				 (tx_stats_num + rx_stats_num) *
+				 sizeof(struct stats);
+	priv->stats_report =
+		dma_alloc_coherent(&priv->pdev->dev, priv->stats_report_len,
+				   &priv->stats_report_bus, GFP_KERNEL);
+	if (!priv->stats_report)
+		return -ENOMEM;
+	/* Set up timer for periodic task */
+	timer_setup(&priv->service_timer, gve_service_timer, 0);
+	priv->service_timer_period = GVE_SERVICE_TIMER_PERIOD;
+	/* Start the service task timer */
+	mod_timer(&priv->service_timer,
+		  round_jiffies(jiffies +
+		  msecs_to_jiffies(priv->service_timer_period)));
+	return 0;
+}
+
+static void gve_free_stats_report(struct gve_priv *priv)
+{
+	del_timer_sync(&priv->service_timer);
+	dma_free_coherent(&priv->pdev->dev, priv->stats_report_len,
+			  priv->stats_report, priv->stats_report_bus);
+	priv->stats_report = NULL;
+}
+
 static irqreturn_t gve_mgmnt_intr(int irq, void *arg)
 {
 	struct gve_priv *priv = arg;
@@ -270,6 +323,9 @@ static int gve_setup_device_resources(struct gve_priv *priv)
 	err = gve_alloc_notify_blocks(priv);
 	if (err)
 		goto abort_with_counter;
+	err = gve_alloc_stats_report(priv);
+	if (err)
+		goto abort_with_ntfy_blocks;
 	err = gve_adminq_configure_device_resources(priv,
 						    priv->counter_array_bus,
 						    priv->num_event_counters,
@@ -279,10 +335,18 @@ static int gve_setup_device_resources(struct gve_priv *priv)
 		dev_err(&priv->pdev->dev,
 			"could not setup device_resources: err=%d\n", err);
 		err = -ENXIO;
-		goto abort_with_ntfy_blocks;
+		goto abort_with_stats_report;
 	}
+	err = gve_adminq_report_stats(priv, priv->stats_report_len,
+				      priv->stats_report_bus,
+				      GVE_SERVICE_TIMER_PERIOD);
+	if (err)
+		dev_err(&priv->pdev->dev,
+			"Failed to report stats: err=%d\n", err);
 	gve_set_device_resources_ok(priv);
 	return 0;
+abort_with_stats_report:
+	gve_free_stats_report(priv);
 abort_with_ntfy_blocks:
 	gve_free_notify_blocks(priv);
 abort_with_counter:
@@ -298,6 +362,13 @@ static void gve_teardown_device_resources(struct gve_priv *priv)
 
 	/* Tell device its resources are being freed */
 	if (gve_get_device_resources_ok(priv)) {
+		/* detach the stats report */
+		err = gve_adminq_report_stats(priv, 0, 0x0, GVE_SERVICE_TIMER_PERIOD);
+		if (err) {
+			dev_err(&priv->pdev->dev,
+				"Failed to detach stats report: err=%d\n", err);
+			gve_trigger_reset(priv);
+		}
 		err = gve_adminq_deconfigure_device_resources(priv);
 		if (err) {
 			dev_err(&priv->pdev->dev,
@@ -308,6 +379,7 @@ static void gve_teardown_device_resources(struct gve_priv *priv)
 	}
 	gve_free_counter_array(priv);
 	gve_free_notify_blocks(priv);
+	gve_free_stats_report(priv);
 	gve_clear_device_resources_ok(priv);
 }
 
@@ -830,6 +902,7 @@ static void gve_turndown(struct gve_priv *priv)
 	netif_tx_disable(priv->dev);
 
 	gve_clear_napi_enabled(priv);
+	gve_clear_report_stats(priv);
 }
 
 static void gve_turnup(struct gve_priv *priv)
@@ -880,6 +953,10 @@ static void gve_handle_status(struct gve_priv *priv, u32 status)
 		dev_info(&priv->pdev->dev, "Device requested reset.\n");
 		gve_set_do_reset(priv);
 	}
+	if (GVE_DEVICE_STATUS_REPORT_STATS_MASK & status) {
+		dev_info(&priv->pdev->dev, "Device report stats on.\n");
+		gve_set_do_report_stats(priv);
+	}
 }
 
 static void gve_handle_reset(struct gve_priv *priv)
@@ -898,7 +975,68 @@ static void gve_handle_reset(struct gve_priv *priv)
 	}
 }
 
-/* Handle NIC status register changes and reset requests */
+void gve_handle_report_stats(struct gve_priv *priv)
+{
+	int idx, stats_idx = 0, tx_bytes;
+	unsigned int start = 0;
+	struct stats *stats = priv->stats_report->stats;
+
+	if (!gve_get_report_stats(priv))
+		return;
+
+	be64_add_cpu(&priv->stats_report->written_count, 1);
+	/* tx stats */
+	if (priv->tx) {
+		for (idx = 0; idx < priv->tx_cfg.num_queues; idx++) {
+			do {
+				start = u64_stats_fetch_begin(&priv->tx[idx].statss);
+				tx_bytes = priv->tx[idx].bytes_done;
+			} while (u64_stats_fetch_retry(&priv->tx[idx].statss, start));
+			stats[stats_idx++] = (struct stats) {
+				.stat_name = cpu_to_be32(TX_WAKE_CNT),
+				.value = cpu_to_be64(priv->tx[idx].wake_queue),
+				.queue_id = cpu_to_be32(idx),
+			};
+			stats[stats_idx++] = (struct stats) {
+				.stat_name = cpu_to_be32(TX_STOP_CNT),
+				.value = cpu_to_be64(priv->tx[idx].stop_queue),
+				.queue_id = cpu_to_be32(idx),
+			};
+			stats[stats_idx++] = (struct stats) {
+				.stat_name = cpu_to_be32(TX_FRAMES_SENT),
+				.value = cpu_to_be64(priv->tx[idx].req),
+				.queue_id = cpu_to_be32(idx),
+			};
+			stats[stats_idx++] = (struct stats) {
+				.stat_name = cpu_to_be32(TX_BYTES_SENT),
+				.value = cpu_to_be64(tx_bytes),
+				.queue_id = cpu_to_be32(idx),
+			};
+			stats[stats_idx++] = (struct stats) {
+				.stat_name = cpu_to_be32(TX_LAST_COMPLETION_PROCESSED),
+				.value = cpu_to_be64(priv->tx[idx].done),
+				.queue_id = cpu_to_be32(idx),
+			};
+		}
+	}
+	/* rx stats */
+	if (priv->rx) {
+		for (idx = 0; idx < priv->rx_cfg.num_queues; idx++) {
+			stats[stats_idx++] = (struct stats) {
+				.stat_name = cpu_to_be32(RX_NEXT_EXPECTED_SEQUENCE),
+				.value = cpu_to_be64(priv->rx[idx].desc.seqno),
+				.queue_id = cpu_to_be32(idx),
+			};
+			stats[stats_idx++] = (struct stats) {
+				.stat_name = cpu_to_be32(RX_BUFFERS_POSTED),
+				.value = cpu_to_be64(priv->rx[0].fill_cnt),
+				.queue_id = cpu_to_be32(idx),
+			};
+		}
+	}
+}
+
+/* Handle NIC status register changes, reset requests and report stats */
 static void gve_service_task(struct work_struct *work)
 {
 	struct gve_priv *priv = container_of(work, struct gve_priv,
@@ -908,6 +1046,10 @@ static void gve_service_task(struct work_struct *work)
 			  ioread32be(&priv->reg_bar0->device_status));
 
 	gve_handle_reset(priv);
+	if (gve_get_do_report_stats(priv)) {
+		gve_handle_report_stats(priv);
+		gve_clear_do_report_stats(priv);
+	}
 }
 
 static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
@@ -1173,6 +1315,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->db_bar2 = db_bar;
 	priv->service_task_flags = 0x0;
 	priv->state_flags = 0x0;
+	priv->ethtool_flags = 0x0;
 	priv->dma_mask = dma_mask;
 
 	gve_set_probe_in_progress(priv);
diff --git a/drivers/net/ethernet/google/gve/gve_register.h b/drivers/net/ethernet/google/gve/gve_register.h
index fad8813d1bb1..776c2911842a 100644
--- a/drivers/net/ethernet/google/gve/gve_register.h
+++ b/drivers/net/ethernet/google/gve/gve_register.h
@@ -24,5 +24,6 @@ struct gve_registers {
 enum gve_device_status_flags {
 	GVE_DEVICE_STATUS_RESET_MASK		= BIT(1),
 	GVE_DEVICE_STATUS_LINK_STATUS_MASK	= BIT(2),
+	GVE_DEVICE_STATUS_REPORT_STATS_MASK	= BIT(3),
 };
 #endif /* _GVE_REGISTER_H_ */
-- 
2.28.0.220.ged08abb693-goog


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB70B25A0FF
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:52:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729581AbgIAVwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729489AbgIAVwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:52:06 -0400
Received: from mail-qv1-xf49.google.com (mail-qv1-xf49.google.com [IPv6:2607:f8b0:4864:20::f49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7C4C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:52:06 -0700 (PDT)
Received: by mail-qv1-xf49.google.com with SMTP id y30so2018141qvy.9
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Co7q+eGb4eiMkacnhldQSHOllbo/vtMYCSiqbc9L+Rs=;
        b=Xw8lcmm7JuX9GemxOgo+x67YsR1yOBHv0Ugj0S8lS1ansD4l21xj7on93Jf/2GsYEj
         ZQuhAWuFOseUKV+C71tN7gozYyk6SNxs5d5C9q0nfzuC7olDWHp4BSkxhEFknqDS8TEJ
         p6CUrp+6WbbVpXgeSO5AGyzRT0la5nJWDVZWZIO6OMHlWMzKJFZ3RDtt3/rdJi2E/BkD
         h2spgGQ9Th3yhfjyzWSh1ekwFtOv+fSRIseWCiVMXVgBpqrCRp+ZfF26Tab7qaXhxxcq
         uQrxbwOSUHbfZx3Tvt6ezoMqYlnN5k1NVM4C+NBNYSW19cm45Sei7Prkq+LiJpuv0mNs
         OfAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Co7q+eGb4eiMkacnhldQSHOllbo/vtMYCSiqbc9L+Rs=;
        b=rI7KoyCHz4X5k0vvZ7o2RPyXs3yAbJFozAHI/S+LwYhGau8xSyR+28nL+LEQCCeqRM
         LGJXCsWRktLB9jJfEm6hxFranO2l83DktM7mJ/vCFca+v62WXmzcjPbNWaK7UjrxyJma
         Q6/NYzfIRCEXFaB4+gpGS0eH+kLJ/iprBzu8I/QXfntpZgNmjYPc+y+uDy++T5qh0g7O
         QKQEh9ve0q/wduOpxEYKIgIk9ZZaTDyX6qyHMn7a9TkjGue1w7oX5IKIAo/BgKmUILCf
         3ATnqDhmsBpD/hUeOzabPrcYFir2yqNbWwCSW/I/wg3D4WJbDkI65LYKFz/7wZP/w/X2
         hxKw==
X-Gm-Message-State: AOAM533T/bEFiZykz1QdYfopaHXJutZWSeuZq4ga/0Em9kC7Y83Dn7GP
        H43f1kMEDLXHQrm7C2c6N6HUEiw1BvrfgHqXYZnd0e+OZBh26jllVefh51ApeEMHLiXBJwZe2FL
        GUcB+nrByVtSy2VU+3roHEmUOT804bHatJSi1onuWcQpe7a4xnEOc3FNglaZXs4C1W9RkWXRC
X-Google-Smtp-Source: ABdhPJyzLxCcQx4aMRrPZRq4k/0y2JOuv9G4IC9mtae0ZlwTYobqadzDzLABuELRw6dV08PQbZNFOJXW4P+qjHrD
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a0c:eac5:: with SMTP id
 y5mr3386616qvp.2.1598997125406; Tue, 01 Sep 2020 14:52:05 -0700 (PDT)
Date:   Tue,  1 Sep 2020 14:51:45 -0700
In-Reply-To: <20200901215149.2685117-1-awogbemila@google.com>
Message-Id: <20200901215149.2685117-6-awogbemila@google.com>
Mime-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next v2 5/9] gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.
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

This adds functionality to report driver stats to Hypervisor.
(Users may want to turn this feature off as a matter of privacy
so a "report-stats" flag is addied as an ethtool priv option.
It is also disabled by default.)

A timer is also added so that when report-stats is enabled, stat are
updated once every 20 seconds.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Kuo Zhao <kuozhao@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  73 +++++++--
 drivers/net/ethernet/google/gve/gve_adminq.c  |  21 +++
 drivers/net/ethernet/google/gve/gve_adminq.h  |  38 +++++
 drivers/net/ethernet/google/gve/gve_ethtool.c | 114 +++++++++++---
 drivers/net/ethernet/google/gve/gve_main.c    | 147 +++++++++++++++++-
 .../net/ethernet/google/gve/gve_register.h    |   1 +
 6 files changed, 362 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 37a3bbced36a..9957a7d535ad 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -27,6 +27,13 @@
 /* 1 for management, 1 for rx, 1 for tx */
 #define GVE_MIN_MSIX 3
 
+/* Numbers of gve tx/rx stats in stats report. */
+#define GVE_TX_STATS_REPORT_NUM	5
+#define GVE_RX_STATS_REPORT_NUM	2
+
+/* Interval to schedule a service task, 20000ms. */
+#define GVE_SERVICE_TIMER_PERIOD	20000
+
 /* Each slot in the desc ring has a 1:1 mapping to a slot in the data ring */
 struct gve_rx_desc_queue {
 	struct gve_rx_desc *desc_ring; /* the descriptor ring */
@@ -220,6 +227,7 @@ struct gve_priv {
 	u32 adminq_destroy_rx_queue_cnt;
 	u32 adminq_dcfg_device_resources_cnt;
 	u32 adminq_set_driver_parameter_cnt;
+	u32 adminq_report_stats_cnt;
 
 	/* Global stats */
 	u32 interface_up_cnt; /* count of times interface turned up since last reset */
@@ -227,27 +235,39 @@ struct gve_priv {
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
@@ -297,6 +317,22 @@ static inline void gve_clear_probe_in_progress(struct gve_priv *priv)
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
@@ -357,6 +393,21 @@ static inline void gve_clear_napi_enabled(struct gve_priv *priv)
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
@@ -478,6 +529,8 @@ int gve_reset(struct gve_priv *priv, bool attempt_teardown);
 int gve_adjust_queues(struct gve_priv *priv,
 		      struct gve_queue_config new_rx_config,
 		      struct gve_queue_config new_tx_config);
+/* report stats handling */
+void gve_handle_report_stats(struct gve_priv *priv);
 /* exported by ethtool.c */
 extern const struct ethtool_ops gve_ethtool_ops;
 /* needed by ethtool */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index d9aed217c1d6..69cdf92a2f21 100644
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
index 4dfa06edc0f8..b81a3bb76d5e 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -21,6 +21,7 @@ enum gve_adminq_opcodes {
 	GVE_ADMINQ_DESTROY_RX_QUEUE		= 0x8,
 	GVE_ADMINQ_DECONFIGURE_DEVICE_RESOURCES	= 0x9,
 	GVE_ADMINQ_SET_DRIVER_PARAMETER		= 0xB,
+	GVE_ADMINQ_REPORT_STATS			= 0xC,
 };
 
 /* Admin queue status codes */
@@ -172,6 +173,40 @@ struct gve_adminq_set_driver_parameter {
 
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
+};
+
 union gve_adminq_command {
 	struct {
 		__be32 opcode;
@@ -187,6 +222,7 @@ union gve_adminq_command {
 			struct gve_adminq_register_page_list reg_page_list;
 			struct gve_adminq_unregister_page_list unreg_page_list;
 			struct gve_adminq_set_driver_parameter set_driver_param;
+			struct gve_adminq_report_stats report_stats;
 		};
 	};
 	u8 reserved[64];
@@ -214,4 +250,6 @@ int gve_adminq_register_page_list(struct gve_priv *priv,
 				  struct gve_queue_page_list *qpl);
 int gve_adminq_unregister_page_list(struct gve_priv *priv, u32 page_list_id);
 int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu);
+int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
+			    dma_addr_t stats_report_addr, u64 interval);
 #endif /* _GVE_ADMINQ_H */
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index 28d831d52701..8d70df2447ef 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -6,6 +6,7 @@
 
 #include <linux/rtnetlink.h>
 #include "gve.h"
+#include "gve_adminq.h"
 
 static void gve_get_drvinfo(struct net_device *netdev,
 			    struct ethtool_drvinfo *info)
@@ -56,12 +57,18 @@ static const char gve_gstrings_adminq_stats[][ETH_GSTRING_LEN] = {
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
@@ -69,30 +76,42 @@ static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
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
@@ -104,6 +123,8 @@ static int gve_get_sset_count(struct net_device *netdev, int sset)
 		return GVE_MAIN_STATS_LEN + GVE_ADMINQ_STATS_LEN +
 		       (priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS) +
 		       (priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS);
+	case ETH_SS_PRIV_FLAGS:
+		return GVE_PRIV_FLAGS_STR_LEN;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -213,6 +234,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	} else {
 		i += priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS;
 	}
+
 	/* walk TX rings */
 	if (priv->tx) {
 		for (ring = 0; ring < priv->tx_cfg.num_queues; ring++) {
@@ -235,6 +257,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	} else {
 		i += priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS;
 	}
+
 	/* AQ Stats */
 	data[i++] = priv->adminq_prod_cnt;
 	data[i++] = priv->adminq_cmd_fail;
@@ -249,6 +272,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = priv->adminq_destroy_rx_queue_cnt;
 	data[i++] = priv->adminq_dcfg_device_resources_cnt;
 	data[i++] = priv->adminq_set_driver_parameter_cnt;
+	data[i++] = priv->adminq_report_stats_cnt;
 }
 
 static void gve_get_channels(struct net_device *netdev,
@@ -353,6 +377,54 @@ static int gve_set_tunable(struct net_device *netdev,
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
@@ -367,4 +439,6 @@ const struct ethtool_ops gve_ethtool_ops = {
 	.reset = gve_user_reset,
 	.get_tunable = gve_get_tunable,
 	.set_tunable = gve_set_tunable,
+	.get_priv_flags = gve_get_priv_flags,
+	.set_priv_flags = gve_set_priv_flags,
 };
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index b176fcef19de..b76fc547cf5d 100644
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
+	tx_stats_num = (GVE_TX_STATS_REPORT_NUM) *
+		       priv->tx_cfg.num_queues;
+	rx_stats_num = (GVE_RX_STATS_REPORT_NUM) *
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
2.28.0.402.g5ffc5be6b7-goog


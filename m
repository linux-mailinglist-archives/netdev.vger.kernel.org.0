Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CB30266731
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:39:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgIKRjk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:39:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726495AbgIKRjD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:39:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F0A2C061795
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:02 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id k26so6512667pgf.8
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Yjxm3mwlvjEjX/aGQkH6GSjC/7V4m+TGKH76cK0Qfwo=;
        b=rqp3pu7FIhXhpU65/C1+dElzJClgpVX9KBr6lJ1ZEvhjgibVUYxnSvYmip80kNXOPA
         GUkdwbZZU8/OTorwNDy+D1aZ6jRbGLFNqqWBhXD6+hCr+glU+YlfKC02sogbNacZOhdo
         qdcoaHv/HpH9Vn6bPc6whScV72ouaz5CdLNvp7yx72f2TQTr6vyR1gG3JT4bcDigrcjJ
         q4n3BLWF2yPTvyE26aKhn5IuJ0sBaqYMI87WfGOL9g7amKzR+sTlnwzOnP4LhupK96Zi
         MDC2Lj/pKB2YqbEey93jihf96yN82qTnmS6UQHmdfol4s2NvOmPYgW+/7DLINKGDFZat
         eUmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Yjxm3mwlvjEjX/aGQkH6GSjC/7V4m+TGKH76cK0Qfwo=;
        b=OmRMKyP8GrrVRhTNFBeoUrCNXHEi+gtwTBz4QqHBB83VraXTD+EIbECClVJyKCbFso
         aZnNRr2o9grDCFd2rtJ3D7tfX8aTFMU16D38k9UVJFSf+euRF6HG4qlNZHjkpAEZpmbe
         xKnUcvy4Bwt42Ghywix1UI/1KxmgUEdAxarOuIXyByyT81iiFRiysNZ4UYOApOJfP3mk
         bGWAkLelBkMsBEbYwyI8oEQm/566n5nVZLhTyoF0qLE1WD2H8HLWk13do5fSfhrjjJ5b
         +ntDB/8wcyJJN7Ilwk/+32ha9q5kUmOj+uSrr3E2OQJ1f1P9J6/LUGzViwxZOUEH+THI
         jwmw==
X-Gm-Message-State: AOAM530GnahzgwcpXYWuj4HS9qgURFFJq8CJbh1sqFyz2dRsvcxL+btu
        5yP77xYQ2Q3q0NJaVjtgQfwgYmWzZxP9MGQ8UvwR56FcaggDsKY/DkzLsKbPVczQA3WstFB7bHR
        RqhTVQ+Gm4+wChzDV4esKMlw4omlw7d2H92AR8jO+0rav1keTX6d5aSzzJEuUw+ekmb1hqmE6
X-Google-Smtp-Source: ABdhPJwf3vT0pSuS4steJa7oJuRJqpoah0dGopTK0ph0ABZIG6h4pVoz/btvtxBIv74zLZ3+vx+u+Mhcz2SAWko1
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:902:70cb:b029:d0:cbe1:e744 with
 SMTP id l11-20020a17090270cbb02900d0cbe1e744mr3308388plt.31.1599845941559;
 Fri, 11 Sep 2020 10:39:01 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:38:47 -0700
In-Reply-To: <20200911173851.2149095-1-awogbemila@google.com>
Message-Id: <20200911173851.2149095-5-awogbemila@google.com>
Mime-Version: 1.0
References: <20200911173851.2149095-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next v4 4/8] gve: Add Gvnic stats AQ command and ethtool show/set-priv-flags.
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
so a "report-stats" flag is added as an ethtool priv option.
It is also disabled by default.)
The hypervisor would trigger a stats report in case "too many"
packets dropped; the stats would be useful in debugging stuck
queues.
A "stats_report_trigger_cnt" stat is added to count the number of times
the hypervisor attempts to trigger stats report.

A timer is also added so that when report-stats is enabled, stat are
updated once every 20 seconds.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: Kuo Zhao <kuozhao@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  71 ++++++--
 drivers/net/ethernet/google/gve/gve_adminq.c  |  20 +++
 drivers/net/ethernet/google/gve/gve_adminq.h  |  38 +++++
 drivers/net/ethernet/google/gve/gve_ethtool.c | 113 ++++++++++---
 drivers/net/ethernet/google/gve/gve_main.c    | 158 +++++++++++++++++-
 .../net/ethernet/google/gve/gve_register.h    |   1 +
 6 files changed, 369 insertions(+), 32 deletions(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 55b34b437764..00697d5dcc27 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -27,6 +27,13 @@
 /* 1 for management, 1 for rx, 1 for tx */
 #define GVE_MIN_MSIX 3
 
+/* Numbers of gve tx/rx stats in stats report. */
+#define GVE_TX_STATS_REPORT_NUM	5
+#define GVE_RX_STATS_REPORT_NUM	2
+
+/* Interval to schedule a stats report update, 20000ms. */
+#define GVE_STATS_REPORT_TIMER_PERIOD	20000
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
@@ -227,24 +235,39 @@ struct gve_priv {
 	u32 reset_cnt; /* count of reset */
 	u32 page_alloc_fail; /* count of page alloc fails */
 	u32 dma_mapping_error; /* count of dma mapping errors */
-
+	u32 stats_report_trigger_cnt; /* count of device-requested stats-reports since last reset */
 	struct workqueue_struct *gve_wq;
 	struct work_struct service_task;
+	struct work_struct stats_report_task;
 	unsigned long service_task_flags;
 	unsigned long state_flags;
+
+	struct gve_stats_report *stats_report;
+	u64 stats_report_len;
+	dma_addr_t stats_report_bus; /* dma address for the stats report */
+	unsigned long ethtool_flags;
+
+	unsigned long stats_report_timer_period;
+	struct timer_list stats_report_timer;
+
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
 };
 
-enum gve_state_flags {
-	GVE_PRIV_FLAGS_ADMIN_QUEUE_OK		= BIT(1),
-	GVE_PRIV_FLAGS_DEVICE_RESOURCES_OK	= BIT(2),
-	GVE_PRIV_FLAGS_DEVICE_RINGS_OK		= BIT(3),
-	GVE_PRIV_FLAGS_NAPI_ENABLED		= BIT(4),
+enum gve_state_flags_bit {
+	GVE_PRIV_FLAGS_ADMIN_QUEUE_OK		= 1,
+	GVE_PRIV_FLAGS_DEVICE_RESOURCES_OK	= 2,
+	GVE_PRIV_FLAGS_DEVICE_RINGS_OK		= 3,
+	GVE_PRIV_FLAGS_NAPI_ENABLED		= 4,
+};
+
+enum gve_ethtool_flags_bit {
+	GVE_PRIV_FLAGS_REPORT_STATS		= 0,
 };
 
 static inline bool gve_get_do_reset(struct gve_priv *priv)
@@ -294,6 +317,22 @@ static inline void gve_clear_probe_in_progress(struct gve_priv *priv)
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
@@ -354,6 +393,16 @@ static inline void gve_clear_napi_enabled(struct gve_priv *priv)
 	clear_bit(GVE_PRIV_FLAGS_NAPI_ENABLED, &priv->state_flags);
 }
 
+static inline bool gve_get_report_stats(struct gve_priv *priv)
+{
+	return test_bit(GVE_PRIV_FLAGS_REPORT_STATS, &priv->ethtool_flags);
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
@@ -476,6 +525,8 @@ int gve_reset(struct gve_priv *priv, bool attempt_teardown);
 int gve_adjust_queues(struct gve_priv *priv,
 		      struct gve_queue_config new_rx_config,
 		      struct gve_queue_config new_tx_config);
+/* report stats handling */
+void gve_handle_report_stats(struct gve_priv *priv);
 /* exported by ethtool.c */
 extern const struct ethtool_ops gve_ethtool_ops;
 /* needed by ethtool */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index d9aed217c1d6..078e6e40880d 100644
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
@@ -433,3 +437,19 @@ int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu)
 
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
index e9bef1ff7ec3..67239faa7554 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -6,6 +6,7 @@
 
 #include <linux/rtnetlink.h>
 #include "gve.h"
+#include "gve_adminq.h"
 
 static void gve_get_drvinfo(struct net_device *netdev,
 			    struct ethtool_drvinfo *info)
@@ -36,7 +37,7 @@ static const char gve_gstrings_main_stats[][ETH_GSTRING_LEN] = {
 	"rx_dropped", "tx_dropped", "tx_timeouts",
 	"rx_skb_alloc_fail", "rx_buf_alloc_fail", "rx_desc_err_dropped_pkt",
 	"interface_up_cnt", "interface_down_cnt", "reset_cnt",
-	"page_alloc_fail", "dma_mapping_error",
+	"page_alloc_fail", "dma_mapping_error", "stats_report_trigger_cnt",
 };
 
 static const char gve_gstrings_rx_stats[][ETH_GSTRING_LEN] = {
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
@@ -69,28 +76,42 @@ static void gve_get_strings(struct net_device *netdev, u32 stringset, u8 *data)
 	char *s = (char *)data;
 	int i, j;
 
-	if (stringset != ETH_SS_STATS)
-		return;
-
-	memcpy(s, *gve_gstrings_main_stats,
-	       sizeof(gve_gstrings_main_stats));
-	s += sizeof(gve_gstrings_main_stats);
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
+
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
@@ -102,6 +123,8 @@ static int gve_get_sset_count(struct net_device *netdev, int sset)
 		return GVE_MAIN_STATS_LEN + GVE_ADMINQ_STATS_LEN +
 		       (priv->rx_cfg.num_queues * NUM_GVE_RX_CNTS) +
 		       (priv->tx_cfg.num_queues * NUM_GVE_TX_CNTS);
+	case ETH_SS_PRIV_FLAGS:
+		return GVE_PRIV_FLAGS_STR_LEN;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -182,6 +205,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = priv->reset_cnt;
 	data[i++] = priv->page_alloc_fail;
 	data[i++] = priv->dma_mapping_error;
+	data[i++] = priv->stats_report_trigger_cnt;
 	i = GVE_MAIN_STATS_LEN;
 
 	/* walk RX rings */
@@ -248,6 +272,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = priv->adminq_destroy_rx_queue_cnt;
 	data[i++] = priv->adminq_dcfg_device_resources_cnt;
 	data[i++] = priv->adminq_set_driver_parameter_cnt;
+	data[i++] = priv->adminq_report_stats_cnt;
 }
 
 static void gve_get_channels(struct net_device *netdev,
@@ -352,6 +377,52 @@ static int gve_set_tunable(struct net_device *netdev,
 	}
 }
 
+static u32 gve_get_priv_flags(struct net_device *netdev)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	u32 ret_flags = 0;
+
+	/* Only 1 flag exists currently: report-stats (BIT(O)), so set that flag. */
+	if (priv->ethtool_flags & BIT(0))
+		ret_flags |= BIT(0);
+	return ret_flags;
+}
+
+static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	u64 ori_flags, new_flags;
+
+	ori_flags = READ_ONCE(priv->ethtool_flags);
+	new_flags = ori_flags;
+
+	/* Only one priv flag exists: report-stats (BIT(0))*/
+	if (flags & BIT(0))
+		new_flags |= BIT(0);
+	else
+		new_flags &= ~(BIT(0));
+	priv->ethtool_flags = new_flags;
+	/* start report-stats timer when user turns report stats on. */
+	if (flags & BIT(0)) {
+		mod_timer(&priv->stats_report_timer,
+			  round_jiffies(jiffies +
+					msecs_to_jiffies(priv->stats_report_timer_period)));
+	}
+	/* Zero off gve stats when report-stats turned off and */
+	/* delete report stats timer. */
+	if (!(flags & BIT(0)) && (ori_flags & BIT(0))) {
+		int tx_stats_num = GVE_TX_STATS_REPORT_NUM *
+			priv->tx_cfg.num_queues;
+		int rx_stats_num = GVE_RX_STATS_REPORT_NUM *
+			priv->rx_cfg.num_queues;
+
+		memset(priv->stats_report->stats, 0, (tx_stats_num + rx_stats_num) *
+				   sizeof(struct stats));
+		del_timer_sync(&priv->stats_report_timer);
+	}
+	return 0;
+}
+
 const struct ethtool_ops gve_ethtool_ops = {
 	.get_drvinfo = gve_get_drvinfo,
 	.get_strings = gve_get_strings,
@@ -366,4 +437,6 @@ const struct ethtool_ops gve_ethtool_ops = {
 	.reset = gve_user_reset,
 	.get_tunable = gve_get_tunable,
 	.set_tunable = gve_set_tunable,
+	.get_priv_flags = gve_get_priv_flags,
+	.set_priv_flags = gve_set_priv_flags,
 };
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 0fc68f844edf..936ff4c9d250 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -78,6 +78,66 @@ static void gve_free_counter_array(struct gve_priv *priv)
 	priv->counter_array = NULL;
 }
 
+/* NIC requests to report stats */
+static void gve_stats_report_task(struct work_struct *work)
+{
+	struct gve_priv *priv = container_of(work, struct gve_priv,
+					     stats_report_task);
+	if (gve_get_do_report_stats(priv)) {
+		gve_handle_report_stats(priv);
+		gve_clear_do_report_stats(priv);
+	}
+}
+
+static void gve_stats_report_schedule(struct gve_priv *priv)
+{
+	if (!gve_get_probe_in_progress(priv) &&
+	    !gve_get_reset_in_progress(priv)) {
+		gve_set_do_report_stats(priv);
+		queue_work(priv->gve_wq, &priv->stats_report_task);
+	}
+}
+
+static void gve_stats_report_timer(struct timer_list *t)
+{
+	struct gve_priv *priv = from_timer(priv, t, stats_report_timer);
+
+	mod_timer(&priv->stats_report_timer,
+		  round_jiffies(jiffies +
+		  msecs_to_jiffies(priv->stats_report_timer_period)));
+	gve_stats_report_schedule(priv);
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
+	/* Set up timer for the report-stats task */
+	timer_setup(&priv->stats_report_timer, gve_stats_report_timer, 0);
+	priv->stats_report_timer_period = GVE_STATS_REPORT_TIMER_PERIOD;
+	return 0;
+}
+
+static void gve_free_stats_report(struct gve_priv *priv)
+{
+	del_timer_sync(&priv->stats_report_timer);
+	dma_free_coherent(&priv->pdev->dev, priv->stats_report_len,
+			  priv->stats_report, priv->stats_report_bus);
+	priv->stats_report = NULL;
+}
+
 static irqreturn_t gve_mgmnt_intr(int irq, void *arg)
 {
 	struct gve_priv *priv = arg;
@@ -270,6 +330,9 @@ static int gve_setup_device_resources(struct gve_priv *priv)
 	err = gve_alloc_notify_blocks(priv);
 	if (err)
 		goto abort_with_counter;
+	err = gve_alloc_stats_report(priv);
+	if (err)
+		goto abort_with_ntfy_blocks;
 	err = gve_adminq_configure_device_resources(priv,
 						    priv->counter_array_bus,
 						    priv->num_event_counters,
@@ -279,10 +342,18 @@ static int gve_setup_device_resources(struct gve_priv *priv)
 		dev_err(&priv->pdev->dev,
 			"could not setup device_resources: err=%d\n", err);
 		err = -ENXIO;
-		goto abort_with_ntfy_blocks;
+		goto abort_with_stats_report;
 	}
+	err = gve_adminq_report_stats(priv, priv->stats_report_len,
+				      priv->stats_report_bus,
+				      GVE_STATS_REPORT_TIMER_PERIOD);
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
@@ -298,6 +369,13 @@ static void gve_teardown_device_resources(struct gve_priv *priv)
 
 	/* Tell device its resources are being freed */
 	if (gve_get_device_resources_ok(priv)) {
+		/* detach the stats report */
+		err = gve_adminq_report_stats(priv, 0, 0x0, GVE_STATS_REPORT_TIMER_PERIOD);
+		if (err) {
+			dev_err(&priv->pdev->dev,
+				"Failed to detach stats report: err=%d\n", err);
+			gve_trigger_reset(priv);
+		}
 		err = gve_adminq_deconfigure_device_resources(priv);
 		if (err) {
 			dev_err(&priv->pdev->dev,
@@ -308,6 +386,7 @@ static void gve_teardown_device_resources(struct gve_priv *priv)
 	}
 	gve_free_counter_array(priv);
 	gve_free_notify_blocks(priv);
+	gve_free_stats_report(priv);
 	gve_clear_device_resources_ok(priv);
 }
 
@@ -699,6 +778,11 @@ static int gve_open(struct net_device *dev)
 		goto reset;
 	gve_set_device_rings_ok(priv);
 
+	if (gve_get_report_stats(priv))
+		mod_timer(&priv->stats_report_timer,
+			  round_jiffies(jiffies +
+				msecs_to_jiffies(priv->stats_report_timer_period)));
+
 	gve_turnup(priv);
 	netif_carrier_on(dev);
 	priv->interface_up_cnt++;
@@ -740,6 +824,7 @@ static int gve_close(struct net_device *dev)
 			goto err;
 		gve_clear_device_rings_ok(priv);
 	}
+	del_timer_sync(&priv->stats_report_timer);
 
 	gve_free_rings(priv);
 	gve_free_qpls(priv);
@@ -823,6 +908,7 @@ static void gve_turndown(struct gve_priv *priv)
 	netif_tx_disable(priv->dev);
 
 	gve_clear_napi_enabled(priv);
+	gve_clear_report_stats(priv);
 }
 
 static void gve_turnup(struct gve_priv *priv)
@@ -873,6 +959,10 @@ static void gve_handle_status(struct gve_priv *priv, u32 status)
 		dev_info(&priv->pdev->dev, "Device requested reset.\n");
 		gve_set_do_reset(priv);
 	}
+	if (GVE_DEVICE_STATUS_REPORT_STATS_MASK & status) {
+		priv->stats_report_trigger_cnt++;
+		gve_set_do_report_stats(priv);
+	}
 }
 
 static void gve_handle_reset(struct gve_priv *priv)
@@ -891,7 +981,68 @@ static void gve_handle_reset(struct gve_priv *priv)
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
@@ -1056,6 +1207,7 @@ int gve_reset(struct gve_priv *priv, bool attempt_teardown)
 	priv->reset_cnt++;
 	priv->interface_up_cnt = 0;
 	priv->interface_down_cnt = 0;
+	priv->stats_report_trigger_cnt = 0;
 	return err;
 }
 
@@ -1158,6 +1310,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	priv->db_bar2 = db_bar;
 	priv->service_task_flags = 0x0;
 	priv->state_flags = 0x0;
+	priv->ethtool_flags = 0x0;
 
 	gve_set_probe_in_progress(priv);
 	priv->gve_wq = alloc_ordered_workqueue("gve", 0);
@@ -1167,6 +1320,7 @@ static int gve_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto abort_with_netdev;
 	}
 	INIT_WORK(&priv->service_task, gve_service_task);
+	INIT_WORK(&priv->stats_report_task, gve_stats_report_task);
 	priv->tx_cfg.max_queues = max_tx_queues;
 	priv->rx_cfg.max_queues = max_rx_queues;
 
diff --git a/drivers/net/ethernet/google/gve/gve_register.h b/drivers/net/ethernet/google/gve/gve_register.h
index 84ab8893aadd..fb655463c357 100644
--- a/drivers/net/ethernet/google/gve/gve_register.h
+++ b/drivers/net/ethernet/google/gve/gve_register.h
@@ -23,5 +23,6 @@ struct gve_registers {
 enum gve_device_status_flags {
 	GVE_DEVICE_STATUS_RESET_MASK		= BIT(1),
 	GVE_DEVICE_STATUS_LINK_STATUS_MASK	= BIT(2),
+	GVE_DEVICE_STATUS_REPORT_STATS_MASK	= BIT(3),
 };
 #endif /* _GVE_REGISTER_H_ */
-- 
2.28.0.618.gf4bc123cb7-goog


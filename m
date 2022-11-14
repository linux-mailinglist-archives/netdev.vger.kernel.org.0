Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833D3628D81
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 00:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235838AbiKNXfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 18:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233300AbiKNXf2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 18:35:28 -0500
Received: from mail-pj1-x1049.google.com (mail-pj1-x1049.google.com [IPv6:2607:f8b0:4864:20::1049])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811729FFE
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:35:27 -0800 (PST)
Received: by mail-pj1-x1049.google.com with SMTP id b1-20020a17090a10c100b0020da29fa5e5so6544795pje.2
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 15:35:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=bJVd//vQtbleFtvFcG8fzgyb9kQJ6KV2/2TYKTnaUM0=;
        b=mSS/oeVpHNgBYUYQkgvF4OJc+Vn/+KADUo81EL+ORcP4TzfcKK1N6HvgJYsC/OQMZW
         7npx7X35mM5uURD8C+pEtGZVd7zDlqWI9BGHkyhOVLc3piV1ObxoLU+XyWTXM6fS10nh
         n0WLGWtawPuNxr/HWstZbL9BMkJiY9sEVx7tfLpUAtPFcmJJr1XPwn3K1RZI7J0Odlgr
         wY//UVtpMf+usxjHYDi5lufX9tSPTP+/tsrD1IUv+sjrfIXIIngbtwFOYCTLksTRVjys
         6MXSbrOZGqskJPtLlaRwvXyO3WfvvpYjV5B3JWkdQV/JZPIWv9RHrdlq+6v8692gSY9g
         mWLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bJVd//vQtbleFtvFcG8fzgyb9kQJ6KV2/2TYKTnaUM0=;
        b=pW4JK4q07fnzIvkWqCBf8LQdNPZpfdTq3S2HN+CABvHxTNyisJq6eWpwzDbW8xumsu
         vSX67ybPLmqXkqkK9GZoxBSIz5y++Ma6uJxY9PHURL0uxFylWFUQXJzWTF+GwOPSnBQD
         I8V2rdaibMRfR7PS6Eu5zYkFTJ+T71ARCNLh+VPFnJY0mNquJsYftpAwZfAD6WBOrwPJ
         rC7EOj6aQbQBD8l/gNvB23xMj68FNLKOEMfpGgPYnayyi9rpdP95/sGFuuyZ5QOTWKrd
         bdBGI4s7iG3hGUh3mEiOleDtjeZT2j0cLKZRxL0WuXp0SAnLoMpgO86TpcQ+qyb+CLWz
         Rjcg==
X-Gm-Message-State: ANoB5pkmc6MJjvT1f0KNCMrn5xuzgqG5aslHgcFaXJxFn+4CqYXZzz9r
        zXEM5p3yJ47YkaU13ERaRwB8tCvH8lyZ7BNB6PzlpIOGNZ2B0JK6Kdh1x56J3DmmPztaNJbIpZl
        hNW9cGxbTwGetufkASFO6eEJrBBjL3CM4Tr2JPJT/KWAs7hwxMPUyoaKjUtjpN9suqhA=
X-Google-Smtp-Source: AA0mqf7rgkIQsixmCEa88ZWQ5cptPzl5CfA8FEyzNpZkoKtJQWzwBuW5QH/OHCZdf1NdQwQTH6bz2PnOgk+bWA==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:6a9:95e0:4212:73d])
 (user=jeroendb job=sendgmr) by 2002:aa7:8f0d:0:b0:560:ee47:81e1 with SMTP id
 x13-20020aa78f0d000000b00560ee4781e1mr16057595pfr.63.1668468926828; Mon, 14
 Nov 2022 15:35:26 -0800 (PST)
Date:   Mon, 14 Nov 2022 15:35:13 -0800
In-Reply-To: <20221114233514.1913116-1-jeroendb@google.com>
Mime-Version: 1.0
References: <20221114233514.1913116-1-jeroendb@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221114233514.1913116-2-jeroendb@google.com>
Subject: [PATCH net-next v3 1/2] gve: Adding a new AdminQ command to verify driver
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        Jeroen de Borst <jeroendb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check whether the driver is compatible with the device
presented.

Signed-off-by: Jeroen de Borst <jeroendb@google.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/google/gve/gve.h        |  1 +
 drivers/net/ethernet/google/gve/gve_adminq.c | 19 +++++++
 drivers/net/ethernet/google/gve/gve_adminq.h | 49 ++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_main.c   | 52 ++++++++++++++++++++
 4 files changed, 121 insertions(+)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index 5655da9cd236..64eb0442c82f 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -563,6 +563,7 @@ struct gve_priv {
 	u32 adminq_report_stats_cnt;
 	u32 adminq_report_link_speed_cnt;
 	u32 adminq_get_ptype_map_cnt;
+	u32 adminq_verify_driver_compatibility_cnt;
 
 	/* Global stats */
 	u32 interface_up_cnt; /* count of times interface turned up since last reset */
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index f7621ab672b9..6a12b30a9f87 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -407,6 +407,9 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 	case GVE_ADMINQ_GET_PTYPE_MAP:
 		priv->adminq_get_ptype_map_cnt++;
 		break;
+	case GVE_ADMINQ_VERIFY_DRIVER_COMPATIBILITY:
+		priv->adminq_verify_driver_compatibility_cnt++;
+		break;
 	default:
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
 	}
@@ -878,6 +881,22 @@ int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
 	return gve_adminq_execute_cmd(priv, &cmd);
 }
 
+int gve_adminq_verify_driver_compatibility(struct gve_priv *priv,
+					   u64 driver_info_len,
+					   dma_addr_t driver_info_addr)
+{
+	union gve_adminq_command cmd;
+
+	memset(&cmd, 0, sizeof(cmd));
+	cmd.opcode = cpu_to_be32(GVE_ADMINQ_VERIFY_DRIVER_COMPATIBILITY);
+	cmd.verify_driver_compatibility = (struct gve_adminq_verify_driver_compatibility) {
+		.driver_info_len = cpu_to_be64(driver_info_len),
+		.driver_info_addr = cpu_to_be64(driver_info_addr),
+	};
+
+	return gve_adminq_execute_cmd(priv, &cmd);
+}
+
 int gve_adminq_report_link_speed(struct gve_priv *priv)
 {
 	union gve_adminq_command gvnic_cmd;
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 83c0b40cd2d9..b9ee8be73f96 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -24,6 +24,7 @@ enum gve_adminq_opcodes {
 	GVE_ADMINQ_REPORT_STATS			= 0xC,
 	GVE_ADMINQ_REPORT_LINK_SPEED		= 0xD,
 	GVE_ADMINQ_GET_PTYPE_MAP		= 0xE,
+	GVE_ADMINQ_VERIFY_DRIVER_COMPATIBILITY	= 0xF,
 };
 
 /* Admin queue status codes */
@@ -146,6 +147,49 @@ enum gve_sup_feature_mask {
 
 #define GVE_DEV_OPT_LEN_GQI_RAW_ADDRESSING 0x0
 
+#define GVE_VERSION_STR_LEN 128
+
+enum gve_driver_capbility {
+	gve_driver_capability_gqi_qpl = 0,
+	gve_driver_capability_gqi_rda = 1,
+	gve_driver_capability_dqo_qpl = 2, /* reserved for future use */
+	gve_driver_capability_dqo_rda = 3,
+};
+
+#define GVE_CAP1(a) BIT((int)a)
+#define GVE_CAP2(a) BIT(((int)a) - 64)
+#define GVE_CAP3(a) BIT(((int)a) - 128)
+#define GVE_CAP4(a) BIT(((int)a) - 192)
+
+#define GVE_DRIVER_CAPABILITY_FLAGS1 \
+	(GVE_CAP1(gve_driver_capability_gqi_qpl) | \
+	 GVE_CAP1(gve_driver_capability_gqi_rda) | \
+	 GVE_CAP1(gve_driver_capability_dqo_rda))
+
+#define GVE_DRIVER_CAPABILITY_FLAGS2 0x0
+#define GVE_DRIVER_CAPABILITY_FLAGS3 0x0
+#define GVE_DRIVER_CAPABILITY_FLAGS4 0x0
+
+struct gve_driver_info {
+	u8 os_type;	/* 0x01 = Linux */
+	u8 driver_major;
+	u8 driver_minor;
+	u8 driver_sub;
+	__be32 os_version_major;
+	__be32 os_version_minor;
+	__be32 os_version_sub;
+	__be64 driver_capability_flags[4];
+	u8 os_version_str1[GVE_VERSION_STR_LEN];
+	u8 os_version_str2[GVE_VERSION_STR_LEN];
+};
+
+struct gve_adminq_verify_driver_compatibility {
+	__be64 driver_info_len;
+	__be64 driver_info_addr;
+};
+
+static_assert(sizeof(struct gve_adminq_verify_driver_compatibility) == 16);
+
 struct gve_adminq_configure_device_resources {
 	__be64 counter_array;
 	__be64 irq_db_addr;
@@ -345,6 +389,8 @@ union gve_adminq_command {
 			struct gve_adminq_report_stats report_stats;
 			struct gve_adminq_report_link_speed report_link_speed;
 			struct gve_adminq_get_ptype_map get_ptype_map;
+			struct gve_adminq_verify_driver_compatibility
+						verify_driver_compatibility;
 		};
 	};
 	u8 reserved[64];
@@ -372,6 +418,9 @@ int gve_adminq_unregister_page_list(struct gve_priv *priv, u32 page_list_id);
 int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu);
 int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
 			    dma_addr_t stats_report_addr, u64 interval);
+int gve_adminq_verify_driver_compatibility(struct gve_priv *priv,
+					   u64 driver_info_len,
+					   dma_addr_t driver_info_addr);
 int gve_adminq_report_link_speed(struct gve_priv *priv);
 
 struct gve_ptype_lut;
diff --git a/drivers/net/ethernet/google/gve/gve_main.c b/drivers/net/ethernet/google/gve/gve_main.c
index 5a229a01f49d..5b40f9c53196 100644
--- a/drivers/net/ethernet/google/gve/gve_main.c
+++ b/drivers/net/ethernet/google/gve/gve_main.c
@@ -12,6 +12,8 @@
 #include <linux/sched.h>
 #include <linux/timer.h>
 #include <linux/workqueue.h>
+#include <linux/utsname.h>
+#include <linux/version.h>
 #include <net/sch_generic.h>
 #include "gve.h"
 #include "gve_dqo.h"
@@ -30,6 +32,49 @@
 const char gve_version_str[] = GVE_VERSION;
 static const char gve_version_prefix[] = GVE_VERSION_PREFIX;
 
+static int gve_verify_driver_compatibility(struct gve_priv *priv)
+{
+	int err;
+	struct gve_driver_info *driver_info;
+	dma_addr_t driver_info_bus;
+
+	driver_info = dma_alloc_coherent(&priv->pdev->dev,
+					 sizeof(struct gve_driver_info),
+					 &driver_info_bus, GFP_KERNEL);
+	if (!driver_info)
+		return -ENOMEM;
+
+	*driver_info = (struct gve_driver_info) {
+		.os_type = 1, /* Linux */
+		.os_version_major = cpu_to_be32(LINUX_VERSION_MAJOR),
+		.os_version_minor = cpu_to_be32(LINUX_VERSION_SUBLEVEL),
+		.os_version_sub = cpu_to_be32(LINUX_VERSION_PATCHLEVEL),
+		.driver_capability_flags = {
+			cpu_to_be64(GVE_DRIVER_CAPABILITY_FLAGS1),
+			cpu_to_be64(GVE_DRIVER_CAPABILITY_FLAGS2),
+			cpu_to_be64(GVE_DRIVER_CAPABILITY_FLAGS3),
+			cpu_to_be64(GVE_DRIVER_CAPABILITY_FLAGS4),
+		},
+	};
+	strscpy(driver_info->os_version_str1, utsname()->release,
+		sizeof(driver_info->os_version_str1));
+	strscpy(driver_info->os_version_str2, utsname()->version,
+		sizeof(driver_info->os_version_str2));
+
+	err = gve_adminq_verify_driver_compatibility(priv,
+						     sizeof(struct gve_driver_info),
+						     driver_info_bus);
+
+	/* It's ok if the device doesn't support this */
+	if (err == -EOPNOTSUPP)
+		err = 0;
+
+	dma_free_coherent(&priv->pdev->dev,
+			  sizeof(struct gve_driver_info),
+			  driver_info, driver_info_bus);
+	return err;
+}
+
 static netdev_tx_t gve_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct gve_priv *priv = netdev_priv(dev);
@@ -1368,6 +1413,13 @@ static int gve_init_priv(struct gve_priv *priv, bool skip_describe_device)
 		return err;
 	}
 
+	err = gve_verify_driver_compatibility(priv);
+	if (err) {
+		dev_err(&priv->pdev->dev,
+			"Could not verify driver compatibility: err=%d\n", err);
+		goto err;
+	}
+
 	if (skip_describe_device)
 		goto setup_device;
 
-- 
2.38.1.431.g37b22c650d-goog


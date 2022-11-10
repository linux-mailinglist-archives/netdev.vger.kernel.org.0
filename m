Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49AF1624859
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 18:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiKJR2g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 12:28:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231508AbiKJR2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 12:28:33 -0500
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9C421BE
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:28:30 -0800 (PST)
Received: by mail-yb1-xb49.google.com with SMTP id m4-20020a258004000000b006cbf32f7ed8so2283916ybk.9
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 09:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nxfLpHXvxWFgVKtLfXk3OteR0wZJBlIBEx+kkJWTVLk=;
        b=tKAir+4lZSKrFWX0PmHCCKl1cTQFrN3shzgSGzyMLaxEzZRdbeyXZ4rIJka48uGi5D
         DwvZ2xHdYhtvNmhj+dn4KFcaOpVR51vk4oGNtWAREykirMEhRtDHm3aMwvMRKqCoBg/C
         kiHFOvdRbsxgNcDwyCypaJSPpK08/YZmCOKmIrm6DXuGAeuYbyNrc3HrTVjuC4W99n7Y
         5oDO+GBp3u4O/efi8Mla2pZUgQDiAl/TSDZInwG+Yc1Rfa3zd/kOv6cPpNFUx7u29vJF
         vMkf5zRWMmE3tKtGGjpCeKieVMmFsovZp1FpF3ZeduAvX8akzzuwuFpvAu3c8Lly6m8F
         fE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nxfLpHXvxWFgVKtLfXk3OteR0wZJBlIBEx+kkJWTVLk=;
        b=56JxUkCui78zKWyVsamt+xF+M1oHQ4GX7fqoeUXVHy4vM4eP97cyjWKpBPqffFbTWG
         j4qbNnIbNJKphjdrUEl/NSzAlgNWKhxmvbfjtjG1YkJKWpzbxX2f4v2i+/Q7aFGq2qfH
         cfer4qcE2BwVJ5YBz5tvd1FZkUK8hlbBfTn6WL3PsPBFs+iFJ62VDGcdd66vhto24ySn
         x7OcWGBrnvmBLgPCzoCUAf9auTcxTY3Bxysa/re9Cj6pt69tmdBRjqY/jnJ7y/hwXDXq
         OvC0ChILIeBY4iEWVuSU5k9k1lDBNcHjHdpoISfLLNejCENCWP2gXy2Ba/Ru8Pyv32Jf
         5c3Q==
X-Gm-Message-State: ANoB5pkjCwBXXwYYWZjMqBY/IoKB5kIGjcB6y+z1Tl1piGrbu86J10x6
        LPEXu/Wc6xAtdngDmoPcrdUSFWj/nb+ZnFItVzUSN3EGK9KWB91p85UHwG1GQBs9JKylTBssI9X
        kZ17zI9dFDWSx422DQJoxv0k2WyYtpfz46ukESrVhmFkhK6DqRXg0J+lm8a1gZdloGX0=
X-Google-Smtp-Source: AA0mqf5axKJDziYF8p1KdB2A7pv8ns96LZUxpsMgoHgxMeoAf53aRiGij5M7yHm/EuWtYBG+K9Amx7GNVV+w6g==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:6a9:95e0:4212:73d])
 (user=jeroendb job=sendgmr) by 2002:a25:b986:0:b0:6dc:8fa4:5a1d with SMTP id
 r6-20020a25b986000000b006dc8fa45a1dmr184742ybg.439.1668101309354; Thu, 10 Nov
 2022 09:28:29 -0800 (PST)
Date:   Thu, 10 Nov 2022 09:27:59 -0800
In-Reply-To: <20221110172800.1228118-1-jeroendb@google.com>
Mime-Version: 1.0
References: <20221110172800.1228118-1-jeroendb@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221110172800.1228118-2-jeroendb@google.com>
Subject: [PATCH net-next 1/2] Adding a new AdminQ command to verify driver
From:   Jeroen de Borst <jeroendb@google.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org,
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


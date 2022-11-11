Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBF4625F96
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 17:35:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233592AbiKKQf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 11:35:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234231AbiKKQf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 11:35:27 -0500
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 503BC836A6
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:35:26 -0800 (PST)
Received: by mail-pf1-x449.google.com with SMTP id a8-20020a621a08000000b0056e3c6c0746so3003341pfa.20
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 08:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nxfLpHXvxWFgVKtLfXk3OteR0wZJBlIBEx+kkJWTVLk=;
        b=P1bPxDT3DXGKrNctTqfrqwvxb6kQ4OePwcAAdKjDmkoua5ObEx2milr8JtfXxrR2r+
         hHTvOioOODBZpAkURhtP+ShtCZtB/X6BkJlc73VIQDq2DTDC9dAHwUj13mrcbaG3E+hi
         +u706Orcs1gYfm0bS54wBzGVaeyhOTiqL+BSGAYs4DJGayzv2Erjd9JhXIm9Y3CErihe
         AtTHlWTNJyU1ZQYvujaEBc4o72atMoI87NGEca1yIY7uatwLpfYoQaxgZfs+MxW8teyr
         te+/LHM90ZwERCBf0UmBURdlgD8slRuUB2RksinwjLroCq6aXaRGQ3T+RVgRy+yj6l4V
         qNRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nxfLpHXvxWFgVKtLfXk3OteR0wZJBlIBEx+kkJWTVLk=;
        b=hJzFvr0JH8XE+Ibc4SHfuXGNAjAfQIjyJ63PnxpGX00wZSipicTkcQlpTrjdz5znfo
         a/c6WFwVXJPgn1mOzjuhtE7T2pN6ChBkGJh0+RXzVPWB2eoLB5BkyZFN75SCVS8qMSQn
         c3kfSAbjh8sVbn1pYK+fv0bhbOzo3IcEflj6YdUrwryrLL/qmgk9mjH08S5eHlYAK18Q
         NMpI/FIPQmFZ6K6Im/Z2F4A1Wp7vDkjJWS5HirT+xmisZiRa8PvA59n3M1U7QvwYxOgn
         SeCZFgDtuIUQVUSjD79WWfNrD2PAT2C+3HqPiaZ6Jb5+lGdCg3jvuIXTKAsI5TInbbx4
         X8Gw==
X-Gm-Message-State: ANoB5pl4XZfVsFgxU3OnjrnyXd9ykXJ2fOfH+LQdo/lbgNQc1w913fT9
        xbC8BZHYhDShxY7ZqeduwTZlbG0Tg4GLjJQeSJ89RfevzIrddyIwtfWC9Mnia+L0h0t86MQiM7I
        p/vUPGN4dX37AzAaOvDZR2dJ48iXEGRo8rIu6AVm+g10U6+n1sIfiVnUaWG+AzDY2xUA=
X-Google-Smtp-Source: AA0mqf6son1f/T9KmmHybwXyep7jO5PyEvS+Nx1xfP8l/0Ey9IjYZ0DAymDB1PHSfAKCW0WMVaEuGC7O/iAiaA==
X-Received: from jeroendb9128802.sea.corp.google.com ([2620:15c:100:202:6a9:95e0:4212:73d])
 (user=jeroendb job=sendgmr) by 2002:a17:902:e1d3:b0:188:4ea8:a687 with SMTP
 id t19-20020a170902e1d300b001884ea8a687mr3242440pla.120.1668184525568; Fri,
 11 Nov 2022 08:35:25 -0800 (PST)
Date:   Fri, 11 Nov 2022 08:35:20 -0800
In-Reply-To: <20221111163521.1373687-1-jeroendb@google.com>
Mime-Version: 1.0
References: <20221111163521.1373687-1-jeroendb@google.com>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
Message-ID: <20221111163521.1373687-2-jeroendb@google.com>
Subject: [PATCH net-next v2 1/2] gve: Adding a new AdminQ command to verify driver
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


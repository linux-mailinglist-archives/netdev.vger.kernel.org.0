Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412C5266732
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 19:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgIKRjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 13:39:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726312AbgIKRjK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 13:39:10 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE923C0613ED
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:09 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id b54so7133075qtk.17
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 10:39:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=M43mVHzBC1r26lIT9AdcEMvITq9xDC1DoOAE4BRsrNg=;
        b=U2Gqu5OclNC6JA+6rpWkN+bBBSfuHtT9CwNkoW6fbh8Yc2YuR2TqRUYnklYvL9vlRF
         y+lM6gT8WoMfondrDIjBLurXZL5wvn77CIn3IWboeAnAoYXsmYcM7s33l4HzeVAPDnZl
         ZtPCeSid2bIxmVG+2jZOfTLWnxG0l7Henc2VVp4EJ9m/6kl7RdudIkE1p4xutdF8U1mg
         wlkMeCV4gN1npoDm0VTowHnTSzak2X/q74YmuDiZWxeO9RW00N6uwY+J0Gu934l53Oxq
         kSIlo6aLfslq1gqZjkiUEqhzNcc0JI7wT2H+Snm5okiYN6e0nTJZVjGN1eHfmdrxVjSG
         xz+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M43mVHzBC1r26lIT9AdcEMvITq9xDC1DoOAE4BRsrNg=;
        b=HpLN02MPZ18OZm7+z5wTDF5amBk7RKeABXGsV3Ai1ky5uLuLURhbM+4cdrPYlnvuZj
         wADxlZcy3Xj694QUmS2e92Ku5UOmtBINJzm9YXDg3MR5Eo1hc+8RdldOXtmg4ONSeJM7
         fuINTKSXFsBeG99U4PRnl+fQ9OH1r+KgbFSv/SytI64oi20XVs9Qbsr/yekX4YoMDawW
         uCsamg1fbIiRm+lpyKeDb8l2dTH+f9mM6otzxEluV44LiyScwLdtmtD+uUx6O+MvTcyN
         IylukXipsKzfMWxVFXiurS9Ltl8Razii6/UBbluGuuTRZUA4C+ST1CQvr0tjnQD2cnsE
         sjiQ==
X-Gm-Message-State: AOAM533Zp6xkfOL5N5ACacTz+cyh6VRIbejaDmFakcX5yRqfJ3i5lUHr
        A5pzZyBqnQnwyRxYFJqybPbOWIl2xqqrMtQrYdmZdKHrLFbjcnnbeTU8ehVTBsH/BjtkkTP5e/R
        p1OioXPUVMqrFn2IAL1Axd/8TG0Jfs/cNw0e7awDgtL1fHivYzm9YZvSE1t+ckvSzblYJjw3T
X-Google-Smtp-Source: ABdhPJxGGy9VlZHhqAVQeRqp/s8ECBCGHBcbxLsPRWDCARJcJfhskcU/BXVBULqzgWcIm6xG0tLVJsaVgTgIJw/+
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:ad4:4527:: with SMTP id
 l7mr3091765qvu.2.1599845948310; Fri, 11 Sep 2020 10:39:08 -0700 (PDT)
Date:   Fri, 11 Sep 2020 10:38:51 -0700
In-Reply-To: <20200911173851.2149095-1-awogbemila@google.com>
Message-Id: <20200911173851.2149095-9-awogbemila@google.com>
Mime-Version: 1.0
References: <20200911173851.2149095-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.618.gf4bc123cb7-goog
Subject: [PATCH net-next v4 8/8] gve: Enable Link Speed Reporting in the driver.
From:   David Awogbemila <awogbemila@google.com>
To:     netdev@vger.kernel.org
Cc:     David Awogbemila <awogbemila@google.com>,
        Yangchun Fu <yangchun@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This change allows the driver to report the device link speed
when the ethtool command:
	ethtool <nic name>
is run.
Getting the link speed is done via a new admin queue command:
ReportLinkSpeed.

Reviewed-by: Yangchun Fu <yangchun@google.com>
Signed-off-by: David Awogbemila <awogbemila@google.com>
---
 drivers/net/ethernet/google/gve/gve.h         |  3 ++
 drivers/net/ethernet/google/gve/gve_adminq.c  | 31 +++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_adminq.h  |  9 ++++++
 drivers/net/ethernet/google/gve/gve_ethtool.c | 14 ++++++++-
 4 files changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index ebb770f955e9..f5c80229ea96 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -232,6 +232,7 @@ struct gve_priv {
 	u32 adminq_dcfg_device_resources_cnt;
 	u32 adminq_set_driver_parameter_cnt;
 	u32 adminq_report_stats_cnt;
+	u32 adminq_report_link_speed_cnt;
 
 	/* Global stats */
 	u32 interface_up_cnt; /* count of times interface turned up since last reset */
@@ -254,6 +255,8 @@ struct gve_priv {
 	unsigned long stats_report_timer_period;
 	struct timer_list stats_report_timer;
 
+	/* Gvnic device link speed from hypervisor. */
+	u64 link_speed;
 };
 
 enum gve_service_task_flags_bit {
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 6f5ccd591c3d..24ae6a28a806 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.c
+++ b/drivers/net/ethernet/google/gve/gve_adminq.c
@@ -36,6 +36,7 @@ int gve_adminq_alloc(struct device *dev, struct gve_priv *priv)
 	priv->adminq_dcfg_device_resources_cnt = 0;
 	priv->adminq_set_driver_parameter_cnt = 0;
 	priv->adminq_report_stats_cnt = 0;
+	priv->adminq_report_link_speed_cnt = 0;
 
 	/* Setup Admin queue with the device */
 	iowrite32be(priv->adminq_bus_addr / PAGE_SIZE,
@@ -238,6 +239,9 @@ static int gve_adminq_issue_cmd(struct gve_priv *priv,
 	case GVE_ADMINQ_REPORT_STATS:
 		priv->adminq_report_stats_cnt++;
 		break;
+	case GVE_ADMINQ_REPORT_LINK_SPEED:
+		priv->adminq_report_link_speed_cnt++;
+		break;
 	default:
 		dev_err(&priv->pdev->dev, "unknown AQ command opcode %d\n", opcode);
 	}
@@ -595,3 +599,30 @@ int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
 
 	return gve_adminq_execute_cmd(priv, &cmd);
 }
+
+int gve_adminq_report_link_speed(struct gve_priv *priv)
+{
+	union gve_adminq_command gvnic_cmd;
+	dma_addr_t link_speed_region_bus;
+	__be64 *link_speed_region;
+	int err;
+
+	link_speed_region =
+		dma_alloc_coherent(&priv->pdev->dev, sizeof(*link_speed_region),
+				   &link_speed_region_bus, GFP_KERNEL);
+
+	if (!link_speed_region)
+		return -ENOMEM;
+
+	memset(&gvnic_cmd, 0, sizeof(gvnic_cmd));
+	gvnic_cmd.opcode = cpu_to_be32(GVE_ADMINQ_REPORT_LINK_SPEED);
+	gvnic_cmd.report_link_speed.link_speed_address =
+		cpu_to_be64(link_speed_region_bus);
+
+	err = gve_adminq_execute_cmd(priv, &gvnic_cmd);
+
+	priv->link_speed = be64_to_cpu(*link_speed_region);
+	dma_free_coherent(&priv->pdev->dev, sizeof(*link_speed_region), link_speed_region,
+			  link_speed_region_bus);
+	return err;
+}
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.h b/drivers/net/ethernet/google/gve/gve_adminq.h
index 784830f75b7c..281de8326bc5 100644
--- a/drivers/net/ethernet/google/gve/gve_adminq.h
+++ b/drivers/net/ethernet/google/gve/gve_adminq.h
@@ -22,6 +22,7 @@ enum gve_adminq_opcodes {
 	GVE_ADMINQ_DECONFIGURE_DEVICE_RESOURCES	= 0x9,
 	GVE_ADMINQ_SET_DRIVER_PARAMETER		= 0xB,
 	GVE_ADMINQ_REPORT_STATS			= 0xC,
+	GVE_ADMINQ_REPORT_LINK_SPEED	= 0xD
 };
 
 /* Admin queue status codes */
@@ -181,6 +182,12 @@ struct gve_adminq_report_stats {
 
 static_assert(sizeof(struct gve_adminq_report_stats) == 24);
 
+struct gve_adminq_report_link_speed {
+	__be64 link_speed_address;
+};
+
+static_assert(sizeof(struct gve_adminq_report_link_speed) == 8);
+
 struct stats {
 	__be32 stat_name;
 	__be32 queue_id;
@@ -228,6 +235,7 @@ union gve_adminq_command {
 			struct gve_adminq_unregister_page_list unreg_page_list;
 			struct gve_adminq_set_driver_parameter set_driver_param;
 			struct gve_adminq_report_stats report_stats;
+			struct gve_adminq_report_link_speed report_link_speed;
 		};
 	};
 	u8 reserved[64];
@@ -255,4 +263,5 @@ int gve_adminq_unregister_page_list(struct gve_priv *priv, u32 page_list_id);
 int gve_adminq_set_mtu(struct gve_priv *priv, u64 mtu);
 int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
 			    dma_addr_t stats_report_addr, u64 interval);
+int gve_adminq_report_link_speed(struct gve_priv *priv);
 #endif /* _GVE_ADMINQ_H */
diff --git a/drivers/net/ethernet/google/gve/gve_ethtool.c b/drivers/net/ethernet/google/gve/gve_ethtool.c
index c5bb8846fd26..7b44769bd87c 100644
--- a/drivers/net/ethernet/google/gve/gve_ethtool.c
+++ b/drivers/net/ethernet/google/gve/gve_ethtool.c
@@ -59,7 +59,7 @@ static const char gve_gstrings_adminq_stats[][ETH_GSTRING_LEN] = {
 	"adminq_create_tx_queue_cnt", "adminq_create_rx_queue_cnt",
 	"adminq_destroy_tx_queue_cnt", "adminq_destroy_rx_queue_cnt",
 	"adminq_dcfg_device_resources_cnt", "adminq_set_driver_parameter_cnt",
-	"adminq_report_stats_cnt",
+	"adminq_report_stats_cnt", "adminq_report_link_speed_cnt"
 };
 
 static const char gve_gstrings_priv_flags[][ETH_GSTRING_LEN] = {
@@ -355,6 +355,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = priv->adminq_dcfg_device_resources_cnt;
 	data[i++] = priv->adminq_set_driver_parameter_cnt;
 	data[i++] = priv->adminq_report_stats_cnt;
+	data[i++] = priv->adminq_report_link_speed_cnt;
 }
 
 static void gve_get_channels(struct net_device *netdev,
@@ -505,6 +506,16 @@ static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
 	return 0;
 }
 
+static int gve_get_link_ksettings(struct net_device *netdev,
+				  struct ethtool_link_ksettings *cmd)
+{
+	struct gve_priv *priv = netdev_priv(netdev);
+	int err = gve_adminq_report_link_speed(priv);
+
+	cmd->base.speed = priv->link_speed;
+	return err;
+}
+
 const struct ethtool_ops gve_ethtool_ops = {
 	.get_drvinfo = gve_get_drvinfo,
 	.get_strings = gve_get_strings,
@@ -521,4 +532,5 @@ const struct ethtool_ops gve_ethtool_ops = {
 	.set_tunable = gve_set_tunable,
 	.get_priv_flags = gve_get_priv_flags,
 	.set_priv_flags = gve_set_priv_flags,
+	.get_link_ksettings = gve_get_link_ksettings
 };
-- 
2.28.0.618.gf4bc123cb7-goog


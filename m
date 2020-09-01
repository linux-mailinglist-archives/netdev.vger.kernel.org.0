Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2533825A105
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 23:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729832AbgIAVw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 17:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729520AbgIAVwN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 17:52:13 -0400
Received: from mail-pl1-x649.google.com (mail-pl1-x649.google.com [IPv6:2607:f8b0:4864:20::649])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0881FC061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 14:52:13 -0700 (PDT)
Received: by mail-pl1-x649.google.com with SMTP id y13so1311279plr.1
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 14:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=CZOU5zNBV7YhreEpl/ZEvsx5azVAeeK7Om2FNRiEDWc=;
        b=YQ8ryqvG4mlgnTuOKdOdPXJiTFgnoYN/VnEpah/ALSxc2cpBcRZ/TJ8sh/MODzz50n
         6gAlb4xtoATrwCMvTpJRmksBCO6h+px6J/+kmv3wIAPpaeskfpxAVoumjccEpQsm7C6e
         13NVTr7FAsFuUyFDwsdyN2e+17+rY5+bKjXyF54W7qdQxFIwwp2fXXAzGFFjBP0u8val
         8uo3m0Nsl8dU9vjHPL6ar8PDo7h7d8qsI0HZq5EQmWaQSy+P4IpJ1EhOtLqpnjSWDSI9
         I8azsIzhd7b2RBnrjXUlN88mh2P4CIxknTsWenPqn1phJKv+SDuR26IJrPfcvG6H7sG+
         HIDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=CZOU5zNBV7YhreEpl/ZEvsx5azVAeeK7Om2FNRiEDWc=;
        b=lZuJMeV+sa5oX7wfkPeiwk1raFnf+csBq9jXqC9z/E1EcxIXLcjN3s+Nsot/gaHWwZ
         9bZVeyO9XBlHCGhTB8TIk+XxBjBrcvGBtARdhw4FGI6LoYnypjj3QXJPL6By4WkLpabJ
         ANIRuzrKd7s/htBawa0O1R9+HrkVouAOPxGA0iH6uU4chpurW61uGJHx2j8UoH3j0AEh
         ya3fhuCryjp+5igsnbP1jPuIG8s/9ARxJRw2RpzB2DT7VxoYgm1EhPK8Y/OHT0sQU2Ea
         bUoaGOhm0GnPVGAEf3Mwe6+Lwtny85k2WDiwxm+hy1Z+kHL0lT0PVo6fnZ6UD6W/xLvc
         II1g==
X-Gm-Message-State: AOAM533lfezSeY9NCE5lCHjSuRoz/zo0TGPTQJLc75fHk/Vjudpd1cZ/
        ZzMfFvgwTPoPKI62Ro8HIrDUkT/3wqTJo2JAAdkOCp99RH/BkCUk62brYmh/hKCwmamJzSUeEEx
        nxpPYiyjwrS3wkCwZPbJvhqc3XVDyjzCJOW14Cb/3Oh/Xum5KzTnUAwqHfrU75OnGSSy4bPEK
X-Google-Smtp-Source: ABdhPJytCp2/XLOMlTBB0VJ/Wj4TJc3zYWe3phfQndPbuJOkHSjFr8IdVzPN8Ik+AU5QOgCKwVpkgkPpH0/SxxXc
X-Received: from awogbemila.sea.corp.google.com ([2620:15c:100:202:1ea0:b8ff:fe73:6cc0])
 (user=awogbemila job=sendgmr) by 2002:a17:90b:4b89:: with SMTP id
 lr9mr3542807pjb.126.1598997132456; Tue, 01 Sep 2020 14:52:12 -0700 (PDT)
Date:   Tue,  1 Sep 2020 14:51:49 -0700
In-Reply-To: <20200901215149.2685117-1-awogbemila@google.com>
Message-Id: <20200901215149.2685117-10-awogbemila@google.com>
Mime-Version: 1.0
References: <20200901215149.2685117-1-awogbemila@google.com>
X-Mailer: git-send-email 2.28.0.402.g5ffc5be6b7-goog
Subject: [PATCH net-next v2 9/9] gve: Enable Link Speed Reporting in the driver.
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
 drivers/net/ethernet/google/gve/gve.h         |  4 +++
 drivers/net/ethernet/google/gve/gve_adminq.c  | 31 +++++++++++++++++++
 drivers/net/ethernet/google/gve/gve_adminq.h  |  9 ++++++
 drivers/net/ethernet/google/gve/gve_ethtool.c | 14 ++++++++-
 4 files changed, 57 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/google/gve/gve.h b/drivers/net/ethernet/google/gve/gve.h
index bc54059f9b2e..4a8d77013ebe 100644
--- a/drivers/net/ethernet/google/gve/gve.h
+++ b/drivers/net/ethernet/google/gve/gve.h
@@ -232,6 +232,7 @@ struct gve_priv {
 	u32 adminq_dcfg_device_resources_cnt;
 	u32 adminq_set_driver_parameter_cnt;
 	u32 adminq_report_stats_cnt;
+	u32 adminq_report_link_speed_cnt;
 
 	/* Global stats */
 	u32 interface_up_cnt; /* count of times interface turned up since last reset */
@@ -252,6 +253,9 @@ struct gve_priv {
 	unsigned long service_timer_period;
 	struct timer_list service_timer;
 
+	/* Gvnic device link speed from hypervisor. */
+	u64 link_speed;
+
   /* Gvnic device's dma mask, set during probe. */
 	u8 dma_mask;
 };
diff --git a/drivers/net/ethernet/google/gve/gve_adminq.c b/drivers/net/ethernet/google/gve/gve_adminq.c
index 341a17b36f06..2372e18943b8 100644
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
@@ -596,3 +600,30 @@ int gve_adminq_report_stats(struct gve_priv *priv, u64 stats_report_len,
 	return gve_adminq_execute_cmd(priv, &cmd);
 }
 
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
+
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
index db5642fe966f..4830c873cd78 100644
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
@@ -354,6 +354,7 @@ gve_get_ethtool_stats(struct net_device *netdev,
 	data[i++] = priv->adminq_dcfg_device_resources_cnt;
 	data[i++] = priv->adminq_set_driver_parameter_cnt;
 	data[i++] = priv->adminq_report_stats_cnt;
+	data[i++] = priv->adminq_report_link_speed_cnt;
 }
 
 static void gve_get_channels(struct net_device *netdev,
@@ -506,6 +507,16 @@ static int gve_set_priv_flags(struct net_device *netdev, u32 flags)
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
@@ -522,4 +533,5 @@ const struct ethtool_ops gve_ethtool_ops = {
 	.set_tunable = gve_set_tunable,
 	.get_priv_flags = gve_get_priv_flags,
 	.set_priv_flags = gve_set_priv_flags,
+	.get_link_ksettings = gve_get_link_ksettings
 };
-- 
2.28.0.402.g5ffc5be6b7-goog


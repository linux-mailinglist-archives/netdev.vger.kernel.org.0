Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9185682FFF
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 15:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjAaO7E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 09:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232396AbjAaO6p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 09:58:45 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2047.outbound.protection.outlook.com [40.107.93.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E43446A2;
        Tue, 31 Jan 2023 06:58:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N23RvslmW7hHCUyBcY2WCyiUXLdTjuZCsX/XgRjm9Pjxtn3eaJvePKz/KA+LIxxPOYwjsXIVBH7goD8BbEVnZ1lKSzZl5tzZfmGUlImTOPO1DNSBQE/jPqtSaPpiv8Jb91zcQ68IzDLnYc3vtloy/MPv4m938PgS3auOifm5rnuhZ6BeOmhEXDj9u/ZsQWORDjIAu6IsQB7aqVPDVc/AUWO+2tqO6eI4khSYnVK+TS+L1cvwgxDzP8WfdDtMN31QUV5QwLxFUddcec6C3vSmOQf7D4C9j6fOA78CBH6tdejW0ucN5JPowUStlO22fpvNFqvNtPmIFKgE24GZRf9nvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ev/BYxe0mYIWIcl8dWTcGiCoyZUM0AYLbiPwiUXPVnU=;
 b=d99lciTbzzSVUljgEp0rXC8aircqnFynIJfgyWNyXJtX+wWbd7HOHLf95LaAU7M0sF7PBK3MMpmWpZ5XeN3uBtL91AUoKTbw+NDW7RPbpYh08ZWIF8VnPDq2v9obyhYjkDm9Ain26ck1TjkBvXPmAFSqTkjWfLQe8Ad5nub+URfnN+Uo+/wnMe+5j/MMeIdf09TPq0XreuserYNlL1LE4PuRoOaTxQiWiZ3w9RH5xM8L+T+c5JgrlwRCZ+K/1ZpGOad8+WNRjZSCkdM1htCQ1SwP/xsPjiyqelljdJEiveSJBr/N1jggpal9jHslDkwLTyh/CduJcUqB2KR3n2SS6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ev/BYxe0mYIWIcl8dWTcGiCoyZUM0AYLbiPwiUXPVnU=;
 b=eLtD9nwGUj42dZTEpG02Wd0gCxKQmA1RLLdRt/x5rUNvk64JrnBeD7WMwX7VW3kEyYsbmsWoISLs9TE2bKlvkOm4kdYkbcjWqgNUjM7p7trO+bO24UMwP6asey/OwPqNLyWXAXHiRXerOI/ZU5QHs+oozXVbxwMEAM2jnrA1GRE=
Received: from BN9P221CA0027.NAMP221.PROD.OUTLOOK.COM (2603:10b6:408:10a::21)
 by MN0PR12MB5955.namprd12.prod.outlook.com (2603:10b6:208:37e::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.36; Tue, 31 Jan
 2023 14:58:39 +0000
Received: from BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10a:cafe::63) by BN9P221CA0027.outlook.office365.com
 (2603:10b6:408:10a::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38 via Frontend
 Transport; Tue, 31 Jan 2023 14:58:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT039.mail.protection.outlook.com (10.13.177.169) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6043.21 via Frontend Transport; Tue, 31 Jan 2023 14:58:39 +0000
Received: from SATLEXMB05.amd.com (10.181.40.146) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 08:58:35 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB05.amd.com
 (10.181.40.146) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 31 Jan
 2023 08:58:34 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Tue, 31 Jan 2023 08:58:33 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v4 net-next 1/8] sfc: add devlink support for ef100
Date:   Tue, 31 Jan 2023 14:58:15 +0000
Message-ID: <20230131145822.36208-2-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
References: <20230131145822.36208-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT039:EE_|MN0PR12MB5955:EE_
X-MS-Office365-Filtering-Correlation-Id: 829632df-c7d5-4fa8-6380-08db039ba354
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QzYZgILRefcs58yl/NjlBxr/DIyA4Fx2kjLVrwxPEMELYjBegDHWQCUB8LxEIWGNtGFz7S+W1doDkL0VzFKsXd3cJQsnP1V/kpT7cHUd/tnMZeYPh/wjfB5n/G2DRzbuo6RYeWLfYCoDSEPKr/kabJDw6FojY/h8LXpV5W+/Wl+QJAgTk7gGylrwpa4ieNYKw3++Sm8YaTN2M+G6bGDduTApOz+/d8p//xBC1r+ICgF7pQG0yrbKOwPRtMXI/k28tkcAxKq0yscU7o96bFx6a2sX09P3XWvB/WXwJr+mvAPiFmdvZll2xJ1JcnizmuJpTo7qSupgMWb43jk43FtHMxItNVGP2hGfTkb0HU7XN1P64ct2gJrXcjj93PtXijv/Edjq87HLLKjKatEykyqgCEzsntw+64xWJRoA7mwxZOwMgz7k179Z3fV4ZlRgDAc0tWT7C89oXs4hnsHE0Z5epUrmkH2dsfYrnTV4Z8jyE4n/LqOal7ey67/OqHtvJYrC4goFCe/8XDaDnrCD2mFPvGxNNxtNCsitBXhVB1BPmPJBMp3++sL8ci71uFwzbIJt4qeu4t1ifo6Iox9KHbq1osTEfcxjgBA8sXzXmDn4RBMcQiHMtG8IgtkrbGlGM4x6SKYYGdFbUDWCEaE5d+Vbw6jxCa2FBp8Zm0MAFBu1vdMa6DR8zV2qrXOVAVhwL29dWFdg6Jmw1Nn3+tF98J7X4+//YFpK14dcTeLC/0QGMyJIhFwPkfsoiH3IpbABGSZk
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(376002)(136003)(39860400002)(451199018)(40470700004)(46966006)(36840700001)(356005)(86362001)(70206006)(81166007)(82740400003)(36756003)(110136005)(6636002)(5660300002)(316002)(8676002)(4326008)(36860700001)(54906003)(8936002)(70586007)(40460700003)(82310400005)(40480700001)(2906002)(41300700001)(336012)(2876002)(83380400001)(2616005)(426003)(47076005)(7416002)(478600001)(26005)(6666004)(186003)(1076003)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Jan 2023 14:58:39.7619
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 829632df-c7d5-4fa8-6380-08db039ba354
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB5955
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alejandro Lucero <alejandro.lucero-palau@amd.com>

Basic devlink infrastructure support.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
---
 drivers/net/ethernet/sfc/Kconfig        |  1 +
 drivers/net/ethernet/sfc/Makefile       |  3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c | 12 +++++
 drivers/net/ethernet/sfc/ef100_nic.c    |  3 +-
 drivers/net/ethernet/sfc/efx_devlink.c  | 71 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h  | 22 ++++++++
 drivers/net/ethernet/sfc/net_driver.h   |  2 +
 7 files changed, 111 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.c
 create mode 100644 drivers/net/ethernet/sfc/efx_devlink.h

diff --git a/drivers/net/ethernet/sfc/Kconfig b/drivers/net/ethernet/sfc/Kconfig
index 0950e6b0508f..4af36ba8906b 100644
--- a/drivers/net/ethernet/sfc/Kconfig
+++ b/drivers/net/ethernet/sfc/Kconfig
@@ -22,6 +22,7 @@ config SFC
 	depends on PTP_1588_CLOCK_OPTIONAL
 	select MDIO
 	select CRC32
+	select NET_DEVLINK
 	help
 	  This driver supports 10/40-gigabit Ethernet cards based on
 	  the Solarflare SFC9100-family controllers.
diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index 712a48d00069..55b9c73cd8ef 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -6,7 +6,8 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   mcdi.o mcdi_port.o mcdi_port_common.o \
 			   mcdi_functions.o mcdi_filters.o mcdi_mon.o \
 			   ef100.o ef100_nic.o ef100_netdev.o \
-			   ef100_ethtool.o ef100_rx.o ef100_tx.o
+			   ef100_ethtool.o ef100_rx.o ef100_tx.o \
+			   efx_devlink.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
 sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o \
                            mae.o tc.o tc_bindings.o tc_counters.o
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index ddcc325ed570..b10a226f4a07 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -24,6 +24,7 @@
 #include "rx_common.h"
 #include "ef100_sriov.h"
 #include "tc_bindings.h"
+#include "efx_devlink.h"
 
 static void ef100_update_name(struct efx_nic *efx)
 {
@@ -332,6 +333,8 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 		efx_ef100_pci_sriov_disable(efx, true);
 #endif
 
+	/* devlink lock */
+	efx_fini_devlink_start(efx);
 	ef100_unregister_netdev(efx);
 
 #ifdef CONFIG_SFC_SRIOV
@@ -345,6 +348,9 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 	kfree(efx->phy_data);
 	efx->phy_data = NULL;
 
+	/* devlink unlock */
+	efx_fini_devlink(efx);
+
 	free_netdev(efx->net_dev);
 	efx->net_dev = NULL;
 	efx->state = STATE_PROBED;
@@ -405,6 +411,10 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	/* Don't fail init if RSS setup doesn't work. */
 	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
 
+	/* devlink creation, registration and lock */
+	if (efx_probe_devlink(efx))
+		pci_info(efx->pci_dev, "devlink registration failed");
+
 	rc = ef100_register_netdev(efx);
 	if (rc)
 		goto fail;
@@ -424,5 +434,7 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	}
 
 fail:
+	/* devlink unlock */
+	efx_probe_devlink_done(efx);
 	return rc;
 }
diff --git a/drivers/net/ethernet/sfc/ef100_nic.c b/drivers/net/ethernet/sfc/ef100_nic.c
index ad686c671ab8..e4aacb4ec666 100644
--- a/drivers/net/ethernet/sfc/ef100_nic.c
+++ b/drivers/net/ethernet/sfc/ef100_nic.c
@@ -1120,11 +1120,10 @@ int ef100_probe_netdev_pf(struct efx_nic *efx)
 		return rc;
 
 	rc = efx_ef100_get_base_mport(efx);
-	if (rc) {
+	if (rc)
 		netif_warn(efx, probe, net_dev,
 			   "Failed to probe base mport rc %d; representors will not function\n",
 			   rc);
-	}
 
 	rc = efx_init_tc(efx);
 	if (rc) {
diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
new file mode 100644
index 000000000000..fab06aaa4b8a
--- /dev/null
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -0,0 +1,71 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for AMD network controllers and boards
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include <linux/rtc.h>
+#include "net_driver.h"
+#include "ef100_nic.h"
+#include "efx_devlink.h"
+#include "nic.h"
+#include "mcdi.h"
+#include "mcdi_functions.h"
+#include "mcdi_pcol.h"
+
+struct efx_devlink {
+	struct efx_nic *efx;
+};
+
+static const struct devlink_ops sfc_devlink_ops = {
+};
+
+void efx_fini_devlink_start(struct efx_nic *efx)
+{
+	if (efx->devlink)
+		devl_lock(efx->devlink);
+}
+
+void efx_fini_devlink(struct efx_nic *efx)
+{
+	if (efx->devlink) {
+		devl_unregister(efx->devlink);
+		devl_unlock(efx->devlink);
+		devlink_free(efx->devlink);
+		efx->devlink = NULL;
+	}
+}
+
+int efx_probe_devlink(struct efx_nic *efx)
+{
+	struct efx_devlink *devlink_private;
+
+	if (efx->type->is_vf)
+		return 0;
+
+	efx->devlink = devlink_alloc(&sfc_devlink_ops,
+				     sizeof(struct efx_devlink),
+				     &efx->pci_dev->dev);
+	if (!efx->devlink)
+		return -ENOMEM;
+
+	devl_lock(efx->devlink);
+	devlink_private = devlink_priv(efx->devlink);
+	devlink_private->efx = efx;
+
+	devl_register(efx->devlink);
+
+	return 0;
+}
+
+void efx_probe_devlink_done(struct efx_nic *efx)
+{
+	if (!efx->devlink)
+		return;
+
+	devl_unlock(efx->devlink);
+}
diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
new file mode 100644
index 000000000000..55d0d8aeca1e
--- /dev/null
+++ b/drivers/net/ethernet/sfc/efx_devlink.h
@@ -0,0 +1,22 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for AMD network controllers and boards
+ * Copyright (C) 2023, Advanced Micro Devices, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#ifndef _EFX_DEVLINK_H
+#define _EFX_DEVLINK_H
+
+#include "net_driver.h"
+#include <net/devlink.h>
+
+int efx_probe_devlink(struct efx_nic *efx);
+void efx_probe_devlink_done(struct efx_nic *efx);
+void efx_fini_devlink_start(struct efx_nic *efx);
+void efx_fini_devlink(struct efx_nic *efx);
+
+#endif	/* _EFX_DEVLINK_H */
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 3b49e216768b..d036641dc043 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -994,6 +994,7 @@ enum efx_xdp_tx_queues_mode {
  *      xdp_rxq_info structures?
  * @netdev_notifier: Netdevice notifier.
  * @tc: state for TC offload (EF100).
+ * @devlink: reference to devlink structure owned by this device
  * @mem_bar: The BAR that is mapped into membase.
  * @reg_base: Offset from the start of the bar to the function control window.
  * @monitor_work: Hardware monitor workitem
@@ -1179,6 +1180,7 @@ struct efx_nic {
 	struct notifier_block netdev_notifier;
 	struct efx_tc_state *tc;
 
+	struct devlink *devlink;
 	unsigned int mem_bar;
 	u32 reg_base;
 
-- 
2.17.1


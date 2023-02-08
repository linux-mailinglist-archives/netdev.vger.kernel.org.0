Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D57B68F0B1
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231138AbjBHOZv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:25:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231280AbjBHOZn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:25:43 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2041.outbound.protection.outlook.com [40.107.95.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4E69298E9;
        Wed,  8 Feb 2023 06:25:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IT9ZYeP10WVY0uuUCxbe8h4qkZPLjYixefuo4bhS3yGd5qd99pU8WUIeI+PSWMWOh98O2lX+RXSgi0ot8GT4MQF3mfE2xUwlgrNxxWKyDtk4Vl6GdWfbtCXzLJ1uEm8rUqhTOFHWASVdFjEFfCyDlbv1VJ+kKsOGZvT555Y+rRzFWCCxSgFr24OqcE4UiH5oM8cdNMd+cjKpbquxbEDoxo4vkbj9m7W8UC2O4eYp+C9ceG/YYSXQP4SLPJaDn6kp6FvGtOe3jiN3fJLaVjgqKwDXdizFQm4gojO6ZqsQAUAE+w6gybTS2SFB+qVOQQrbx976i1WfyGr0/HNvSI/x5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FyZlvbu1HchaQ380XkNqRKfXH/G4FbL73ntQIiA5zis=;
 b=We8eHpCZNUhOMQEOszEJJzSdBxS/VtUK0TEpdqdjdAcgybGCc0R59WheEbD/hPzEichkg/Yr6V6Vk/xssTeMl8HyCv6gzj+mqUtUT1irBVv2NZY4iZa6824i1OhSMVzVNxdwF6z7mzVzz1NTDonqYmIQeksgrYzJGhejaN4hQlBjXdvLhbC/aB1P3hyRXygAEaG1AyBPINhM3GkxEqQbNhhRqEsDSUxCLZB4S6g7TnjfiZXjp3bZVDs13lj8BGKv1a4rpbWtVK6mcHGNa1zpNfZSm09YMh4nwGP9wkuCGRWXVwCSMskGlHHD/fL9zY3mSt2CbnPpTon5v+wWsf+d+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FyZlvbu1HchaQ380XkNqRKfXH/G4FbL73ntQIiA5zis=;
 b=GdfAlwLFdQbFuF7MJxEtDZK21o2FIzp1b2RnCd+uKONBqDnLzEWETvU6lUpkwfJO9/IbiV2jDvBGBtZ0RkH2CCwJ2cOgcMbZmavLNG7L6L/hMtfsSW4DjiHI0qEIwsqBDr8RQg6aqVuKkjg7cq5vJUVrk1RS1xN7Rs+Yycr82Tk=
Received: from MW4PR04CA0040.namprd04.prod.outlook.com (2603:10b6:303:6a::15)
 by BL0PR12MB4915.namprd12.prod.outlook.com (2603:10b6:208:1c9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Wed, 8 Feb
 2023 14:25:33 +0000
Received: from CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::7e) by MW4PR04CA0040.outlook.office365.com
 (2603:10b6:303:6a::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.17 via Frontend
 Transport; Wed, 8 Feb 2023 14:25:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT055.mail.protection.outlook.com (10.13.175.129) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.18 via Frontend Transport; Wed, 8 Feb 2023 14:25:33 +0000
Received: from SATLEXMB07.amd.com (10.181.41.45) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 08:25:32 -0600
Received: from SATLEXMB03.amd.com (10.181.40.144) by SATLEXMB07.amd.com
 (10.181.41.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Feb
 2023 06:25:32 -0800
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB03.amd.com (10.181.40.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Wed, 8 Feb 2023 08:25:30 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v6 net-next 1/8] sfc: add devlink support for ef100
Date:   Wed, 8 Feb 2023 14:25:12 +0000
Message-ID: <20230208142519.31192-2-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
References: <20230208142519.31192-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT055:EE_|BL0PR12MB4915:EE_
X-MS-Office365-Filtering-Correlation-Id: 63a875c8-5ca1-4f89-81ce-08db09e05698
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: anQsTymocCH4JCgzbRr3gtSswSKw3414O9/1bEIeIdXIKf52YPccjll72nMgTfnNXRVfUWphamHY5WJw2H5uEuPhBb4puS5/TlxYc6Br0pTR/8C5N2NwnDyxd2LLjnh0wtxzimjnk7tkngnvk056lxCCKTaYNG7aCLkmvmSTJpqP2yP55PBa0mVWCmgN/7FSWoIvG3Snm+CmTaxb0yNCq8vOc+6lM51u9/zLKPXt1eUBJpl4+ZQx1QpWoRoN2vRer0UL/bOJdgsuA+pjRIHH/pS7M/vEF0hBm9OXKu5ptHyF58QM9dpWphapmrt6fbQQCa0Nq4qioB4TRp7jTiPx3ursJPTgMp3Ps3nsI6KfVtRYWVwXltA5tU6SWlQT92O3ClCNSKROor4zckajUxPkP24exfHcLkgnBjsjA0v12BUk6x1ZcVNZ01unCPxy2skDslgbRieay29PnPlKU+d2JwHMSvh7rF71F6Hx2AR45Bj2CxNtrnhRcvC63YcYBqiL4EihjtsGoQXQui9XrlB5foXrKFezlznjjM/qdHVjHt646mTj6ifxmOtn2NlneF1D4170iP+dR/05NDxkmL3omDDIYUTe5s1XpUnWW4xVLbR/qQuNxZwuTS1CGufdbGfNsRBU6IZ4C6iCi9UAWhiWdMH7b3YfNikKXR3NmXcXwU6V+zRu9KDvpY9A9eZ62KgbLow56F39zSN7EcS3A4AmuO/s4QDA8vFevygAQ0ykL4uKQ7XxvijE/w1ANBSVNhJy
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(396003)(346002)(39860400002)(451199018)(40470700004)(36840700001)(46966006)(82740400003)(36860700001)(41300700001)(8936002)(186003)(26005)(4326008)(8676002)(70586007)(70206006)(1076003)(81166007)(356005)(47076005)(336012)(2616005)(40480700001)(36756003)(7416002)(426003)(5660300002)(86362001)(316002)(54906003)(6636002)(6666004)(40460700003)(82310400005)(478600001)(2876002)(2906002)(110136005)(83380400001)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2023 14:25:33.1654
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a875c8-5ca1-4f89-81ce-08db09e05698
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT055.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4915
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

Add devlink infrastructure support. Further patches add devlink
info and devlink port support.

Signed-off-by: Alejandro Lucero <alejandro.lucero-palau@amd.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/sfc/Kconfig        |  1 +
 drivers/net/ethernet/sfc/Makefile       |  3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c | 10 ++++
 drivers/net/ethernet/sfc/efx_devlink.c  | 64 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h  | 22 +++++++++
 drivers/net/ethernet/sfc/net_driver.h   |  2 +
 6 files changed, 101 insertions(+), 1 deletion(-)
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
index ddcc325ed570..6cf74788b27a 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -24,6 +24,7 @@
 #include "rx_common.h"
 #include "ef100_sriov.h"
 #include "tc_bindings.h"
+#include "efx_devlink.h"
 
 static void ef100_update_name(struct efx_nic *efx)
 {
@@ -332,6 +333,7 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 		efx_ef100_pci_sriov_disable(efx, true);
 #endif
 
+	efx_fini_devlink_lock(efx);
 	ef100_unregister_netdev(efx);
 
 #ifdef CONFIG_SFC_SRIOV
@@ -345,6 +347,8 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 	kfree(efx->phy_data);
 	efx->phy_data = NULL;
 
+	efx_fini_devlink_and_unlock(efx);
+
 	free_netdev(efx->net_dev);
 	efx->net_dev = NULL;
 	efx->state = STATE_PROBED;
@@ -405,6 +409,11 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	/* Don't fail init if RSS setup doesn't work. */
 	efx_mcdi_push_default_indir_table(efx, efx->n_rx_channels);
 
+	/* devlink creation, registration and lock */
+	rc = efx_probe_devlink_and_lock(efx);
+	if (rc)
+		pci_info(efx->pci_dev, "devlink registration failed");
+
 	rc = ef100_register_netdev(efx);
 	if (rc)
 		goto fail;
@@ -424,5 +433,6 @@ int ef100_probe_netdev(struct efx_probe_data *probe_data)
 	}
 
 fail:
+	efx_probe_devlink_unlock(efx);
 	return rc;
 }
diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
new file mode 100644
index 000000000000..57a7023d3cb6
--- /dev/null
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -0,0 +1,64 @@
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
+#include "efx_devlink.h"
+
+struct efx_devlink {
+	struct efx_nic *efx;
+};
+
+static const struct devlink_ops sfc_devlink_ops = {
+};
+
+void efx_fini_devlink_lock(struct efx_nic *efx)
+{
+	if (efx->devlink)
+		devl_lock(efx->devlink);
+}
+
+void efx_fini_devlink_and_unlock(struct efx_nic *efx)
+{
+	if (efx->devlink) {
+		devl_unregister(efx->devlink);
+		devl_unlock(efx->devlink);
+		devlink_free(efx->devlink);
+		efx->devlink = NULL;
+	}
+}
+
+int efx_probe_devlink_and_lock(struct efx_nic *efx)
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
+void efx_probe_devlink_unlock(struct efx_nic *efx)
+{
+	if (!efx->devlink)
+		return;
+
+	devl_unlock(efx->devlink);
+}
diff --git a/drivers/net/ethernet/sfc/efx_devlink.h b/drivers/net/ethernet/sfc/efx_devlink.h
new file mode 100644
index 000000000000..8ff85b035e87
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
+int efx_probe_devlink_and_lock(struct efx_nic *efx);
+void efx_probe_devlink_unlock(struct efx_nic *efx);
+void efx_fini_devlink_lock(struct efx_nic *efx);
+void efx_fini_devlink_and_unlock(struct efx_nic *efx);
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


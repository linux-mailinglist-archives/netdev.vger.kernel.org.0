Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDF5694F71
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjBMSfS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:35:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbjBMSfR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:35:17 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2055.outbound.protection.outlook.com [40.107.94.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DBCC729D;
        Mon, 13 Feb 2023 10:35:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gAOjD1QrVn4zksLilPRI4OKBveDitNyWt9aI2hIupol09oAaF1N2D+jAGBLFCpZZoVpim1yL6LVQSMnD7Rx/yaErvsQ5xM4L9JsnveTfw41RXtxsqenqBpmSG5MkzY30H26/PsYNX5japgH+uw6I6eJCHhqTedKMgMApPGYD2Hnnj/c4eC0pPx6cdDrpiGzkvd+R9Sa1Jf8AjRu5dw0+5MWK+/DMWdYmGiHRqn8fVIPGbfD28FyG7rLNIuQGsyFYaeKuUij99y02fytFJYNcemZhh+HhiGDmVp50exyL1SSrE0NJeHrbgdKK5yqRET5wOPUxdS6mW67Ybu5xg1ZYig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/yG/NiDjff3ZnK1mXl7rRDT++qzgC3LQQhupV7VwdFY=;
 b=gilWjqW8bW7Cq3DaGFx65mNBXd4zQ9N3nywsiDqBOvQhaaRNSWtNTwqMNmhGN5uNvhnLIeoUkLiE9rd+BkWv4Ys8MRiZWXwXaOtSSRfpTgsoysbMK5RtiCsWMjFJEnAhWhjIJz24ovyKHtI4g1EUz/Zu+kISmhgPlv7fqW38Zzey8kecWW77wpOQphckzuqSZ+pF34rLBQT9s9YupBc31sMydOABOrG33JyGaDluzksw7PgZOr2efqTH8TlWQr1zUV31YTlAY03pLRaClTP28oF7+3z34BTQSRg9H8JYk0jCqzb9By8rbHTHv53ZXgqdPNj7RAzUS8Qm60hpIKALCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/yG/NiDjff3ZnK1mXl7rRDT++qzgC3LQQhupV7VwdFY=;
 b=YSsGEeOLlFwD/YnoTRAx6yu1Hys8AQCr87RAZFU3I/eCBhIBvTKvEXuslMABPWSYcAGjf0zXC2YvEhW2o5CFyEE09YnLdCaKNE35cicjAZXXEFWX3YfagQ4R4aLBd+tBM4Sy8AnlPjKHHb62oDAsMS417aflPX8XgyNud5QcVys=
Received: from MW4PR04CA0116.namprd04.prod.outlook.com (2603:10b6:303:83::31)
 by IA1PR12MB8080.namprd12.prod.outlook.com (2603:10b6:208:3fd::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Mon, 13 Feb
 2023 18:35:13 +0000
Received: from CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:83:cafe::e6) by MW4PR04CA0116.outlook.office365.com
 (2603:10b6:303:83::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24 via Frontend
 Transport; Mon, 13 Feb 2023 18:35:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT089.mail.protection.outlook.com (10.13.175.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6086.24 via Frontend Transport; Mon, 13 Feb 2023 18:35:12 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 13 Feb
 2023 12:35:10 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Mon, 13 Feb 2023 12:35:09 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v7 net-next 1/8] sfc: add devlink support for ef100
Date:   Mon, 13 Feb 2023 18:34:21 +0000
Message-ID: <20230213183428.10734-2-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
References: <20230213183428.10734-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT089:EE_|IA1PR12MB8080:EE_
X-MS-Office365-Filtering-Correlation-Id: 8d5ec3d9-6241-47a5-80f2-08db0df10b41
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pLC/T4y5cKjQV6gknFZAW8VY1oXcIioaO6lXbZR9+kEuXmDYtsc1IHUQik2rVqSA/HuiRm3qtllYZptcXKXxg+3vepZ9I/0zxJpcLVuEXcsUAU2YWzk8yehqDS9ujoSlqQOuPKmbuElVcZa8FQS8KHEElSetNYDtc9gseYA7fL+ZV4n/xTaNP4BmIOw/51/0bmG/UnvTqChWOJQ78MJ0TW5iiAcHPAro173rA1h5NwDKt7SEv36OAiQ13CrRVOqkLUYaeUwkRbOs/u/P0S6pxgxIThHvJKKHFiWOAxIuInFJMNP4bRkfNg0GxUUtF5cusX2wc94LAtMvHjuaOS/J90h+rcUDAogO2B1reeNru8a7yJcfaOj3w/cjSrSU0nApsJB4FkTwkP0d/HbbVULpqXW1dM9N5Q0sfoQqN4fWk7RJz527CvCL5kKa4Jbjdsi9DIyyba0XM9rKYzhqmcO1qBfrNfhTWpaZ75wZtT4fVbWHijPt+gnT7izDxZlvFEOT9pDzZYudgNdDp92OnddT+mRkpX4GiRlPsNJlSBtPqvbLJC6Xww02V/ZA3YNBsMShEO7j+LG0AUKdDFXTgnsYL2Y4uIL0HmQCGOKrpRzfz9A+J3tRYY1dxJginKVtj3iCfo8dI8unlA27d8XVBU7IkBgrg1Jllifxw1BTzF4eyfAn/edNElc7NQYn9L4rMnyX4I6MuDHo/ERz7U8cNCdZQIjx4KZx+VtbOS2gwPTs6BXaa9Z9ETOqkO3+4x4bSBta
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199018)(40470700004)(36840700001)(46966006)(316002)(8676002)(40480700001)(47076005)(82310400005)(2616005)(426003)(83380400001)(86362001)(81166007)(356005)(336012)(36860700001)(82740400003)(6636002)(110136005)(54906003)(1076003)(6666004)(40460700003)(36756003)(186003)(26005)(478600001)(5660300002)(7416002)(41300700001)(8936002)(2906002)(2876002)(70206006)(4326008)(70586007)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Feb 2023 18:35:12.8772
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d5ec3d9-6241-47a5-80f2-08db0df10b41
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8080
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
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Kconfig        |  1 +
 drivers/net/ethernet/sfc/Makefile       |  3 +-
 drivers/net/ethernet/sfc/ef100_netdev.c | 10 ++++
 drivers/net/ethernet/sfc/efx_devlink.c  | 65 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h  | 22 +++++++++
 drivers/net/ethernet/sfc/net_driver.h   |  2 +
 6 files changed, 102 insertions(+), 1 deletion(-)
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
index 000000000000..10c96a9d6f3c
--- /dev/null
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -0,0 +1,65 @@
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
+#include "net_driver.h"
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


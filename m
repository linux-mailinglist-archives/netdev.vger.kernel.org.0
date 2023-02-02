Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F41687BE9
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 12:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231726AbjBBLOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 06:14:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjBBLOl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 06:14:41 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2084.outbound.protection.outlook.com [40.107.237.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D8586EBE;
        Thu,  2 Feb 2023 03:14:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KMJU72vgPzZ0sdMDP0NmbLP6q9j4QJ0K++0lsGk3kNFhDlnVhGQtIv03y583vNhzt/FPKKRCJpA4MVnkpH9GvRMBUM3mDPDmd2+PrHQ0fswU9FlX7B8Hb0ouoPRJXgpJR4xeLxqY02Hmp89SI1evtUos2mJFS67oVQGGdWjgKKQq3OQRn5a5E3V5K15CBuMoO8jjHAhb7Is96+RWsJU9sKVk51OkAS42bCrX6HyMtUvKLBMSpQoiNvWL5u6b0bImnfaOWZ5jzgEn6HjXWKborWOncHds6prldfhbFfvshSCt1+XV7fTOwiIJdyoEIOnaBjwZQMJJRweldxPmZyp54A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u587GgXu3BUNF5dDi42eKSdZhQFScupxryDmJsLKM5g=;
 b=NozBcc0CW4ZXGMcuiIABI2KX9FBvKj7z9AySsMkvFIBApVdjdjf2TpjaIGgJjIqs9M4I5Vd40921OuArNK5afbfmvarga20jpVMmIgynyO1cy2apiBi1XvksbOVqfVY7ANCF8woblw20yPT047Nm6swMAb3xNRRi9TewB+Zn86nSOkqvvFJU5zMpfDgKVv+f+Q+qV7+v5MvPUTNxU59iWnE8KgpTxklKM8EtFkIVq2KEH2c/+YZ5lxZ+KlqxSVKyFEe5h0OhPnpg/ZoG0QH7vqyVWZtMvXLsWpYVPP7PI5v2k6oNSZVt/nhCHhzmZOc6h5STXgvSXNIfVzlpg84SOg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u587GgXu3BUNF5dDi42eKSdZhQFScupxryDmJsLKM5g=;
 b=TVD2cZc5apYMcWqr3wp3VHW5sAriksNvrbZUJDfKsNuIkt/wmCe9Z6Wvvv0CEVJngUsxRQODn6TYVqfiAHugOJvRPHNW2KjSPA5b3WJNibJtXq7LFAvmCtL7++Cyex+xYE7cL66Lr9eD8huLU7hVSfnBxJJuMkVVgTv7umJx4kM=
Received: from DM6PR14CA0050.namprd14.prod.outlook.com (2603:10b6:5:18f::27)
 by SN7PR12MB6743.namprd12.prod.outlook.com (2603:10b6:806:26d::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.22; Thu, 2 Feb
 2023 11:14:38 +0000
Received: from DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::71) by DM6PR14CA0050.outlook.office365.com
 (2603:10b6:5:18f::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.25 via Frontend
 Transport; Thu, 2 Feb 2023 11:14:38 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 DM6NAM11FT088.mail.protection.outlook.com (10.13.172.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6064.27 via Frontend Transport; Thu, 2 Feb 2023 11:14:37 +0000
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 2 Feb
 2023 05:14:37 -0600
Received: from xcbalucerop41x.xilinx.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34 via Frontend Transport; Thu, 2 Feb 2023 05:14:34 -0600
From:   <alejandro.lucero-palau@amd.com>
To:     <netdev@vger.kernel.org>, <linux-net-drivers@amd.com>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <habetsm.xilinx@gmail.com>,
        <ecree.xilinx@gmail.com>, <linux-doc@vger.kernel.org>,
        <corbet@lwn.net>, <jiri@nvidia.com>,
        "Alejandro Lucero" <alejandro.lucero-palau@amd.com>
Subject: [PATCH v5 net-next 1/8] sfc: add devlink support for ef100
Date:   Thu, 2 Feb 2023 11:14:16 +0000
Message-ID: <20230202111423.56831-2-alejandro.lucero-palau@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT088:EE_|SN7PR12MB6743:EE_
X-MS-Office365-Filtering-Correlation-Id: f7c390a8-1225-4890-a500-08db050eac3a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: H4inZfgYUic8H5C5FMUgc9SSKg/Rf7q10HMoFkZYZwuODJikj0mtdnPuaqe/LeJtK2OHKct32FEpnMryn7aRxp4Wb4Hw6RxrSZj/JHxf65pTPjCOcklqe7i+WeSKBtdqjWnfu6qhJY80RpF5i4o1qLij9o/Jo7Z9rpOoATsv8OsJ32M6XsFuZJPzQetZqYDbeN/tW+Shvif3zHckOZf40N5KuADdhLQIF4g6zZH4q+retoJQBPKTKKm08Va/Sv+X+Ww/X++1SCRDP7wn9lrfyF+JsfIqn9AgBWsUSpgsN/gDfUPt1OzPUrcBz4qBMdAi2bQGF9yQI+vZfmT7thDDYQ/kjuiqN6TYT6v8dw2+rTvwijf7Xq/uR/kLVcD/Qao4551a8CtG99D90KANTD6QUE9EERz64VfDdQWMm44jMRoBca338UoJ1OItHBbo0xh+A6Czl4qzKr6gbRy5/Qn3JczLS1NQztbf+oBO+uVLlxKPwIr0SwLywYL56KpBMJ8ywsmFlXGBa43SPOdmXts1+mTmFEeXMhdLjIE8LxuIeOgf2rrnhLRVv55gERJ8G5l5HvMbW1NW2PN6tI+f0nJPB/Pj7ggVgY1ck9s+JcuHyxHqdWPGUn72UxEBUmoMopmhpmcut/MuTNwUagFnuKGDNruX+r0J9rCp5vlDaHe7668Wp130o+I8TDrp4XBuon0bB2yKjQkkPXreKM7onE0arfXR7kDnqDPQdCTeo47C2t+N48tjytccalMdmy5u+R7Q
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199018)(46966006)(36840700001)(40470700004)(81166007)(86362001)(82310400005)(356005)(36756003)(6666004)(83380400001)(82740400003)(1076003)(336012)(36860700001)(186003)(426003)(47076005)(26005)(2616005)(70586007)(6636002)(2876002)(316002)(2906002)(478600001)(110136005)(8676002)(54906003)(40480700001)(4326008)(70206006)(7416002)(5660300002)(41300700001)(40460700003)(8936002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Feb 2023 11:14:37.9481
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f7c390a8-1225-4890-a500-08db050eac3a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6743
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
 drivers/net/ethernet/sfc/ef100_netdev.c | 10 ++++
 drivers/net/ethernet/sfc/efx_devlink.c  | 71 +++++++++++++++++++++++++
 drivers/net/ethernet/sfc/efx_devlink.h  | 22 ++++++++
 drivers/net/ethernet/sfc/net_driver.h   |  2 +
 6 files changed, 108 insertions(+), 1 deletion(-)
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
index 000000000000..933e60876a93
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


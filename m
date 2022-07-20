Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9022357BDCE
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 20:31:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbiGTSbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 14:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240780AbiGTSbG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 14:31:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2084.outbound.protection.outlook.com [40.107.94.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C1670E58
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 11:31:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exeDAG5q/b6mB7P1fZLKpXs/Jaoqh3ZbkDGHeYHa/mF/aopi13VIhHy35uF0a93ul718Y80R04hRTXDLw5HMXZamioBfRkKt8te/MrW2YKMdV3uqX1StUc24wtTJO8Rzp0mMszWu8eZeFLoxYHa0+8drGOMy3PcHYnQ4RE69oy/hniUPwWrTKiBEZ1HkPQxdmT3uK1P75C7G4aq+LJPKObYzpZJNuCD1v5/VAvFMEsv/yceUedJ6PEWcBeUlUhrDtCQqYOVtMEXNA6nhfjb85xLhaycbJGX8kcFG7op5DZAw26PhsRBLyfUi8JzVcUCDgE4y8GVS1Do/xUET8VC/Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Pv2m/A0KeVRnCccx3IE38omnw82zClPfwE4aWVprL2s=;
 b=Wru0QfQEmKtZbQYBUza2ND8wqbHQMt02Mw2QTEBMlsM89z92Zt3BySdXxlA79X9AnoYP8P9o1IRRJeYGXqPx6fzMt1SfkB1O+VdvlFXtizD97n1yQHRw0P4Oo/cTeqtaUMt4eGmwVOmtBASDMjBq55kYqimnTPqE0hJgF6eWUpNUgZ8BjQ5H8ydIPS/QQk0AmCGL0hIdXGPd1ctG05D5y+SZfUCjx0YjVZVwKZTJShaupz6MSCWL3crUic+LltL2LhyZRevxII/7arDLJRmagTOLCVVa0COIc6B4u9thcSj3jj3s6SpuYoVoAaZe3BXk5feoHaV8OBN+Uibziepx2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Pv2m/A0KeVRnCccx3IE38omnw82zClPfwE4aWVprL2s=;
 b=EHvr/mtqUW2m8T+nDbjR7ngOr1MqVjoXPPPJmPI6MIY5tjBJfLwjJm162Pp1PUFP5GbmUGy/qer0MoefTYZ84zfHCl32jtFWYVp82Pm8JxyDaMv1AhFrrm65tdohmvqm5fOFPeWDExrOc3AsYRCxAPSDnQb0jmA2pV7gMaZop2xlS8HtM2wSrhG9IjOE4D86No03K1G2EfkFJU/nR+xUnoITkAeNtNhVBqxrlQ+x9IeyegP2aIH8SUc1jKcbbBxgspLsQDw9hQb+PA7OHPJfZNTcNtudrDQv8dS+rZNAYBMU2Utv8bzW65+fS7KwFlgH20+s1kyM7vJJene6xxAW8w==
Received: from MW4PR03CA0015.namprd03.prod.outlook.com (2603:10b6:303:8f::20)
 by CY4PR12MB1909.namprd12.prod.outlook.com (2603:10b6:903:124::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Wed, 20 Jul
 2022 18:31:02 +0000
Received: from CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8f:cafe::c2) by MW4PR03CA0015.outlook.office365.com
 (2603:10b6:303:8f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.23 via Frontend
 Transport; Wed, 20 Jul 2022 18:31:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB03.amd.com; pr=C
Received: from SATLEXMB03.amd.com (165.204.84.17) by
 CO1NAM11FT036.mail.protection.outlook.com (10.13.174.124) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5458.17 via Frontend Transport; Wed, 20 Jul 2022 18:31:01 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB03.amd.com
 (10.181.40.144) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 13:30:59 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Wed, 20 Jul
 2022 11:30:59 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Wed, 20 Jul 2022 13:30:58 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH v2 net-next 04/10] sfc: add skeleton ef100 VF representors
Date:   Wed, 20 Jul 2022 19:29:31 +0100
Message-ID: <c137c4aac047254df584899d508b3cf33a84e8e0.1658158016.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1658158016.git.ecree.xilinx@gmail.com>
References: <cover.1658158016.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7c26b51c-70a6-4388-c08c-08da6a7dff8a
X-MS-TrafficTypeDiagnostic: CY4PR12MB1909:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QfHQLa7znllPx7nlqv3Jb4dxvbk35A8TJ3qeJCrfHmOyItHib5Fnr1Atrs8o4dSvnCHoMwfJIVAbQ5glNnQEn3MrAtDzgjzeQTDm+d2JaqqUiNWBuxFTADxPSw9E7RuntinzAXHl66Wre4ZBp1d5fSc6ZUnhK8rt62T7lbtAyB7tfTK0Ru6hBmdcJUZDq3/nzT+Sk6CnllMkNDTye333GbLYaybxs29osu8V3qZeEkeLUVGHfe0h/kKrgbMh2sr330QJaHDRTuvZeeWNIyq2eMiClQtnu1PmvwAp11/D5xVtpSAjTOsGnIZY4MmCEk+MHqoERcAn7Q2dRcPUmx2sF8aPYlH2yGCKlHvVYYu33gz+MYQ4Vs0pFNkHWpd3nKBFjgnOlwOIGBlcRe80gK0kGCpWuAccMCTVkey5dXZpg2nCaB0TFHOpqieZjVWrMrHxqzB7JIPJlVkB4ukFRM/ZyeYfAs4MjQD1K46YjNHflKDL+l5Z3Ss2u8hnE0sWMEMqWsDYcEwBqJK1m2YiElq7zadgo2+w5a3YutiNM1bZYZITYIoriNNNeoNVyl9ovl0k7q4ViZM0Ryqq6YLpiTU55Yc1FJb7f5MvJet1rs9+U7Gcg1ReexK4xxjHL/uJmJWgklWqOkYUD/A5R0HyPCXRC8+SOH9H+CTLhIIWLr8q9Aa4qzufcJyqf50TH5HUV+5Vj9YS8NhnW3raznzfNyYjuXTAn/3x40Vh5fBtjbCUioWO1QBfHwUbyckS7qqaiDbyDZP2v03TEMQmkvRiQGqGnMhHEbb1B64koeel0dbU/W9jiSppbzTF/GoKFwcwN+GPdwr349WIgIsqdmp+j1wNhKQBah7Fn+4fhtGwjy/YUpo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB03.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(39860400002)(136003)(376002)(36840700001)(40470700004)(46966006)(70586007)(82740400003)(356005)(36756003)(83380400001)(83170400001)(36860700001)(40460700003)(55446002)(81166007)(186003)(42882007)(47076005)(8936002)(336012)(478600001)(110136005)(6666004)(70206006)(30864003)(54906003)(2906002)(41300700001)(26005)(316002)(4326008)(9686003)(40480700001)(82310400005)(2876002)(5660300002)(8676002)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Jul 2022 18:31:01.5211
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c26b51c-70a6-4388-c08c-08da6a7dff8a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB03.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT036.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1909
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree.xilinx@gmail.com>

No net_device_ops yet, just a placeholder netdev created per VF.

Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
---
 drivers/net/ethernet/sfc/Makefile       |   2 +-
 drivers/net/ethernet/sfc/ef100_netdev.c |   2 +-
 drivers/net/ethernet/sfc/ef100_rep.c    | 126 ++++++++++++++++++++++++
 drivers/net/ethernet/sfc/ef100_rep.h    |  37 +++++++
 drivers/net/ethernet/sfc/ef100_sriov.c  |  32 ++++--
 drivers/net/ethernet/sfc/ef100_sriov.h  |   2 +-
 drivers/net/ethernet/sfc/efx_common.c   |   2 +
 drivers/net/ethernet/sfc/net_driver.h   |   4 +
 8 files changed, 196 insertions(+), 11 deletions(-)
 create mode 100644 drivers/net/ethernet/sfc/ef100_rep.c
 create mode 100644 drivers/net/ethernet/sfc/ef100_rep.h

diff --git a/drivers/net/ethernet/sfc/Makefile b/drivers/net/ethernet/sfc/Makefile
index b9298031ea51..7a6772bfde06 100644
--- a/drivers/net/ethernet/sfc/Makefile
+++ b/drivers/net/ethernet/sfc/Makefile
@@ -8,7 +8,7 @@ sfc-y			+= efx.o efx_common.o efx_channels.o nic.o \
 			   ef100.o ef100_nic.o ef100_netdev.o \
 			   ef100_ethtool.o ef100_rx.o ef100_tx.o
 sfc-$(CONFIG_SFC_MTD)	+= mtd.o
-sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o
+sfc-$(CONFIG_SFC_SRIOV)	+= sriov.o ef10_sriov.o ef100_sriov.o ef100_rep.o
 
 obj-$(CONFIG_SFC)	+= sfc.o
 
diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 060392ddd612..f4a124b8ffbe 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -312,7 +312,7 @@ void ef100_remove_netdev(struct efx_probe_data *probe_data)
 	unregister_netdevice_notifier(&efx->netdev_notifier);
 #if defined(CONFIG_SFC_SRIOV)
 	if (!efx->type->is_vf)
-		efx_ef100_pci_sriov_disable(efx);
+		efx_ef100_pci_sriov_disable(efx, true);
 #endif
 
 	ef100_unregister_netdev(efx);
diff --git a/drivers/net/ethernet/sfc/ef100_rep.c b/drivers/net/ethernet/sfc/ef100_rep.c
new file mode 100644
index 000000000000..f10c25d6f134
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_rep.c
@@ -0,0 +1,126 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2020-2022 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+#include "ef100_rep.h"
+#include "ef100_nic.h"
+
+static int efx_ef100_rep_init_struct(struct efx_nic *efx, struct efx_rep *efv)
+{
+	efv->parent = efx;
+	INIT_LIST_HEAD(&efv->list);
+	efv->msg_enable = NETIF_MSG_DRV | NETIF_MSG_PROBE |
+			  NETIF_MSG_LINK | NETIF_MSG_IFDOWN |
+			  NETIF_MSG_IFUP | NETIF_MSG_RX_ERR |
+			  NETIF_MSG_TX_ERR | NETIF_MSG_HW;
+	return 0;
+}
+
+static const struct net_device_ops efx_ef100_rep_netdev_ops = {
+};
+
+static const struct ethtool_ops efx_ef100_rep_ethtool_ops = {
+};
+
+static struct efx_rep *efx_ef100_rep_create_netdev(struct efx_nic *efx,
+						   unsigned int i)
+{
+	struct net_device *net_dev;
+	struct efx_rep *efv;
+	int rc;
+
+	net_dev = alloc_etherdev_mq(sizeof(*efv), 1);
+	if (!net_dev)
+		return ERR_PTR(-ENOMEM);
+
+	efv = netdev_priv(net_dev);
+	rc = efx_ef100_rep_init_struct(efx, efv);
+	if (rc)
+		goto fail1;
+	efv->net_dev = net_dev;
+	rtnl_lock();
+	spin_lock_bh(&efx->vf_reps_lock);
+	list_add_tail(&efv->list, &efx->vf_reps);
+	spin_unlock_bh(&efx->vf_reps_lock);
+	netif_carrier_off(net_dev);
+	netif_tx_stop_all_queues(net_dev);
+	rtnl_unlock();
+
+	net_dev->netdev_ops = &efx_ef100_rep_netdev_ops;
+	net_dev->ethtool_ops = &efx_ef100_rep_ethtool_ops;
+	net_dev->min_mtu = EFX_MIN_MTU;
+	net_dev->max_mtu = EFX_MAX_MTU;
+	return efv;
+fail1:
+	free_netdev(net_dev);
+	return ERR_PTR(rc);
+}
+
+static void efx_ef100_rep_destroy_netdev(struct efx_rep *efv)
+{
+	struct efx_nic *efx = efv->parent;
+
+	spin_lock_bh(&efx->vf_reps_lock);
+	list_del(&efv->list);
+	spin_unlock_bh(&efx->vf_reps_lock);
+	free_netdev(efv->net_dev);
+}
+
+int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i)
+{
+	struct efx_rep *efv;
+	int rc;
+
+	efv = efx_ef100_rep_create_netdev(efx, i);
+	if (IS_ERR(efv)) {
+		rc = PTR_ERR(efv);
+		pci_err(efx->pci_dev,
+			"Failed to create representor for VF %d, rc %d\n", i,
+			rc);
+		return rc;
+	}
+	rc = register_netdev(efv->net_dev);
+	if (rc) {
+		pci_err(efx->pci_dev,
+			"Failed to register representor for VF %d, rc %d\n",
+			i, rc);
+		goto fail;
+	}
+	pci_dbg(efx->pci_dev, "Representor for VF %d is %s\n", i,
+		efv->net_dev->name);
+	return 0;
+fail:
+	efx_ef100_rep_destroy_netdev(efv);
+	return rc;
+}
+
+void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv)
+{
+	struct net_device *rep_dev;
+
+	rep_dev = efv->net_dev;
+	if (!rep_dev)
+		return;
+	netif_dbg(efx, drv, rep_dev, "Removing VF representor\n");
+	unregister_netdev(rep_dev);
+	efx_ef100_rep_destroy_netdev(efv);
+}
+
+void efx_ef100_fini_vfreps(struct efx_nic *efx)
+{
+	struct ef100_nic_data *nic_data = efx->nic_data;
+	struct efx_rep *efv, *next;
+
+	if (!nic_data->grp_mae)
+		return;
+
+	list_for_each_entry_safe(efv, next, &efx->vf_reps, list)
+		efx_ef100_vfrep_destroy(efx, efv);
+}
diff --git a/drivers/net/ethernet/sfc/ef100_rep.h b/drivers/net/ethernet/sfc/ef100_rep.h
new file mode 100644
index 000000000000..7d85811f0adb
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -0,0 +1,37 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/****************************************************************************
+ * Driver for Solarflare network controllers and boards
+ * Copyright 2019 Solarflare Communications Inc.
+ * Copyright 2020-2022 Xilinx Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published
+ * by the Free Software Foundation, incorporated herein by reference.
+ */
+
+/* Handling for ef100 representor netdevs */
+#ifndef EF100_REP_H
+#define EF100_REP_H
+
+#include "net_driver.h"
+
+/**
+ * struct efx_rep - Private data for an Efx representor
+ *
+ * @parent: the efx PF which manages this representor
+ * @net_dev: representor netdevice
+ * @msg_enable: log message enable flags
+ * @list: entry on efx->vf_reps
+ */
+struct efx_rep {
+	struct efx_nic *parent;
+	struct net_device *net_dev;
+	u32 msg_enable;
+	struct list_head list;
+};
+
+int efx_ef100_vfrep_create(struct efx_nic *efx, unsigned int i);
+void efx_ef100_vfrep_destroy(struct efx_nic *efx, struct efx_rep *efv);
+void efx_ef100_fini_vfreps(struct efx_nic *efx);
+
+#endif /* EF100_REP_H */
diff --git a/drivers/net/ethernet/sfc/ef100_sriov.c b/drivers/net/ethernet/sfc/ef100_sriov.c
index 664578176bfe..94bdbfcb47e8 100644
--- a/drivers/net/ethernet/sfc/ef100_sriov.c
+++ b/drivers/net/ethernet/sfc/ef100_sriov.c
@@ -11,46 +11,62 @@
 
 #include "ef100_sriov.h"
 #include "ef100_nic.h"
+#include "ef100_rep.h"
 
 static int efx_ef100_pci_sriov_enable(struct efx_nic *efx, int num_vfs)
 {
+	struct ef100_nic_data *nic_data = efx->nic_data;
 	struct pci_dev *dev = efx->pci_dev;
-	int rc;
+	struct efx_rep *efv, *next;
+	int rc, i;
 
 	efx->vf_count = num_vfs;
 	rc = pci_enable_sriov(dev, num_vfs);
 	if (rc)
-		goto fail;
+		goto fail1;
 
+	if (!nic_data->grp_mae)
+		return 0;
+
+	for (i = 0; i < num_vfs; i++) {
+		rc = efx_ef100_vfrep_create(efx, i);
+		if (rc)
+			goto fail2;
+	}
 	return 0;
 
-fail:
+fail2:
+	list_for_each_entry_safe(efv, next, &efx->vf_reps, list)
+		efx_ef100_vfrep_destroy(efx, efv);
+	pci_disable_sriov(dev);
+fail1:
 	netif_err(efx, probe, efx->net_dev, "Failed to enable SRIOV VFs\n");
 	efx->vf_count = 0;
 	return rc;
 }
 
-int efx_ef100_pci_sriov_disable(struct efx_nic *efx)
+int efx_ef100_pci_sriov_disable(struct efx_nic *efx, bool force)
 {
 	struct pci_dev *dev = efx->pci_dev;
 	unsigned int vfs_assigned;
 
 	vfs_assigned = pci_vfs_assigned(dev);
-	if (vfs_assigned) {
+	if (vfs_assigned && !force) {
 		netif_info(efx, drv, efx->net_dev, "VFs are assigned to guests; "
 			   "please detach them before disabling SR-IOV\n");
 		return -EBUSY;
 	}
 
-	pci_disable_sriov(dev);
-
+	efx_ef100_fini_vfreps(efx);
+	if (!vfs_assigned)
+		pci_disable_sriov(dev);
 	return 0;
 }
 
 int efx_ef100_sriov_configure(struct efx_nic *efx, int num_vfs)
 {
 	if (num_vfs == 0)
-		return efx_ef100_pci_sriov_disable(efx);
+		return efx_ef100_pci_sriov_disable(efx, false);
 	else
 		return efx_ef100_pci_sriov_enable(efx, num_vfs);
 }
diff --git a/drivers/net/ethernet/sfc/ef100_sriov.h b/drivers/net/ethernet/sfc/ef100_sriov.h
index c48fccd46c57..8ffdf464dd1d 100644
--- a/drivers/net/ethernet/sfc/ef100_sriov.h
+++ b/drivers/net/ethernet/sfc/ef100_sriov.h
@@ -11,4 +11,4 @@
 #include "net_driver.h"
 
 int efx_ef100_sriov_configure(struct efx_nic *efx, int num_vfs);
-int efx_ef100_pci_sriov_disable(struct efx_nic *efx);
+int efx_ef100_pci_sriov_disable(struct efx_nic *efx, bool force);
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index 56eb717bb07a..fb6b66b8707b 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -1021,6 +1021,8 @@ int efx_init_struct(struct efx_nic *efx, struct pci_dev *pci_dev)
 	efx->rps_hash_table = kcalloc(EFX_ARFS_HASH_TABLE_SIZE,
 				      sizeof(*efx->rps_hash_table), GFP_KERNEL);
 #endif
+	spin_lock_init(&efx->vf_reps_lock);
+	INIT_LIST_HEAD(&efx->vf_reps);
 	INIT_WORK(&efx->mac_work, efx_mac_work);
 	init_waitqueue_head(&efx->flush_wq);
 
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 2228c88a7f31..037cfa184764 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -966,6 +966,8 @@ enum efx_xdp_tx_queues_mode {
  * @vf_count: Number of VFs intended to be enabled.
  * @vf_init_count: Number of VFs that have been fully initialised.
  * @vi_scale: log2 number of vnics per VF.
+ * @vf_reps_lock: Protects vf_reps list
+ * @vf_reps: local VF reps
  * @ptp_data: PTP state data
  * @ptp_warned: has this NIC seen and warned about unexpected PTP events?
  * @vpd_sn: Serial number read from VPD
@@ -1145,6 +1147,8 @@ struct efx_nic {
 	unsigned vf_init_count;
 	unsigned vi_scale;
 #endif
+	spinlock_t vf_reps_lock;
+	struct list_head vf_reps;
 
 	struct efx_ptp_data *ptp_data;
 	bool ptp_warned;

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD295761CA
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 14:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234245AbiGOMgT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 08:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbiGOMgS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 08:36:18 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900F254CBA
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:36:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQr0C0Wv7nuNedpbDMo9xoCvqMdlqd9WX2hNSl3DtOJBZgsNRuhO6Q+PnW9+s+5Ifco+5t1uV9eEe61u5yH6Zju4Kj8v1VX5B4QCtqZNGvrFJNYgYbzg4f7FnHcVVlktxcgB4Im0LtfdqJBRb2ChKabEqfbe0MOwTyQJy5dvtT51Ep4dd3kzeb9s9NYTTNmfcE7tivcUzlCCRcM142lwmzFiQzfzSWDxycDrVy+qqZDKWArSq/2aSzbwTP02BK9vKvz0pwOeiAwsuVr2aWwuwQZgaUCcINMV7dyAND1gvskR+05Pp26JSC0wbFldKt1trbdcctDqr0dkMjQREztDuA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1epFQZM6lNy6S794Q+lRHm+o7rFu0OqlCKUKgA8OAEk=;
 b=NRJyoP447KseVb1RnA7x0tMtQL30Ap499OjumRT0EFd5BLZ4FDi7Ao8g9FnNYfj08e5ix80P/tKO3EHdRqHc/iBN2wmGaZauQ4yFCkk5RKnrY+oHfCdeCWnavPswFYEKQ+LoKqzP5ctBIce1BLOkVL980x6ZtwNgK5qFnNt6p8/AYWatnue/oA5iU1sx9GmL2PYuMFbOd26u7lj+bHNuFLp+gua8AVfmkG2Uwv1koP2QtrEtguM6hoxsrpYAf7MwVFPC10kDZoGPntpWxbY4DdFJrMoGECQNNbyhayP+JbkrFjUS+3CgfPoNuO3MupcTyfjudgY2ESJfCAA0ZGusNg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=fail (p=none sp=none pct=100) action=none header.from=xilinx.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector1-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1epFQZM6lNy6S794Q+lRHm+o7rFu0OqlCKUKgA8OAEk=;
 b=Rhtz6ODLhL+5bdaSUlKhVUT846lOCE61A2SFAmVHfd08XNSy7A8MZ3h91ENxxkGvhFYGSQqcD/2HyACZT0TtNPff7N0pazXk9FiONWVT/fUoIjlvUIJcxNLiwft7WQHV6Tn+hem3OoDeCb43TnT+bLe8Se0J+65dJd1769p8bGz2E0cnXCmRV4zzykmVx/H3q7A6RXfhQ4hD4yMaNEystBC4daqI4hvYMCfh5ImN+Md33NWm/tqHXl3HqU4g+TpEnE/Rrfe3UqnOQcLS2xDUramOzHi5LMt9idgyl6HoZMbioUdYQK6+qHpYa/CL6U+B2zrRXzvxuV22ftGv/QlJvQ==
Received: from BN0PR04CA0131.namprd04.prod.outlook.com (2603:10b6:408:ed::16)
 by BN8PR12MB2996.namprd12.prod.outlook.com (2603:10b6:408:48::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.14; Fri, 15 Jul
 2022 12:36:14 +0000
Received: from BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ed:cafe::5a) by BN0PR04CA0131.outlook.office365.com
 (2603:10b6:408:ed::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.20 via Frontend
 Transport; Fri, 15 Jul 2022 12:36:14 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=fail action=none header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT054.mail.protection.outlook.com (10.13.177.102) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5438.12 via Frontend Transport; Fri, 15 Jul 2022 12:36:13 +0000
Received: from SATLEXMB08.amd.com (10.181.40.132) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 07:36:13 -0500
Received: from SATLEXMB04.amd.com (10.181.40.145) by SATLEXMB08.amd.com
 (10.181.40.132) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28; Fri, 15 Jul
 2022 05:36:12 -0700
Received: from xcbecree41x.xilinx.com (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.28 via Frontend
 Transport; Fri, 15 Jul 2022 07:36:11 -0500
From:   <ecree@xilinx.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <linux-net-drivers@amd.com>
CC:     <netdev@vger.kernel.org>, Edward Cree <ecree.xilinx@gmail.com>
Subject: [PATCH net-next 04/10] sfc: add skeleton ef100 VF representors
Date:   Fri, 15 Jul 2022 13:33:26 +0100
Message-ID: <c5a89a7a6221938695bbc35ea75945e761f4bb8c.1657878101.git.ecree.xilinx@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <cover.1657878101.git.ecree.xilinx@gmail.com>
References: <cover.1657878101.git.ecree.xilinx@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91d7c88b-a2cc-4498-8c08-08da665e9ae1
X-MS-TrafficTypeDiagnostic: BN8PR12MB2996:EE_
X-MS-Exchange-SenderADCheck: 0
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZE8eFLM/N5LJDviYDytFcZHz0h3f1Fq69fxFK0dcTiX4d+YkcDL83opOv8S6SJoM+hrvSPw5f4Z1anNwOpNwfpxxseFpFD2dv/vja6+Av6QS0QdqFuF3LchShxN78n2d0sPv7m2ET7dv6pjksQT8NZVJUv2giTv7Ga52G/WNCPk8sVdO8tRiE4keIisxQDFkL52gtzg0RmHz2rd7AGxEK6HGXcZ7odXRDgMBS/1gp+7STDW0EJZmZc1W7ckdFvLmDEsxN2hLfeceysbD1JhZjwKWa6HqIp9X3N5gEVy9RLXEXR8MC0N6jtyZclzeEIY29ZlxaQNlmI9oezNe3N/5YVy4VsYEqRipSq6aN9MAA8GPr8m08jscYM8kBZ0lcM3lbQEdH/w11SyducohFnDII92qRbc3DEKSdkm1lOgmJlITiiNP2OnLIxYGVyeGdqSam5A0kG8JmvCVfeHAVEVJhHropMQhFsQbJTO1ydvZ0G+O0RtRsvEQ0PWMNHBMfRzGcm45FwET44I+ikRooOpczawhttx4Iij+GvyXe3bgQ3nuanMmjTebX7UDKgQk0v1qKCDmO/HKtWiZtwpa/gKlWePdSOpxX8tw5G54gS8XWwQeZe357VfsbR+snsfMqOU79DK75Yoi3nirfvyrpgyGbjunMIm32lF4yE0a5wP/Mq8SXP7as0aFXsAqnPKGmuj/symF+OIwyUw83qFE7JzwsKN6inivoJLfR1mgcuVvGum3mc76IWepvZMRUunJ/ZIKablHPL+tMJyIcm/PDXentxEah+Z/Vk6EZivASCl2StScJkhw1GI4dQ4p/fHG9bTQCe55tXihKBi5rNGKehUHYaWofTEePwg6aADvKYvp/9ko7QA31ko+uhf0fefkz6T0
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230016)(4636009)(376002)(396003)(346002)(39860400002)(136003)(36840700001)(46966006)(40470700004)(8676002)(36860700001)(5660300002)(478600001)(36756003)(4326008)(70586007)(40460700003)(41300700001)(6666004)(70206006)(110136005)(54906003)(82310400005)(8936002)(316002)(9686003)(2906002)(47076005)(336012)(42882007)(26005)(186003)(2876002)(55446002)(40480700001)(83380400001)(356005)(82740400003)(81166007)(83170400001)(2004002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 12:36:13.6372
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 91d7c88b-a2cc-4498-8c08-08da665e9ae1
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT054.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR12MB2996
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
 drivers/net/ethernet/sfc/ef100_rep.h    |  30 ++++++
 drivers/net/ethernet/sfc/ef100_sriov.c  |  32 ++++--
 drivers/net/ethernet/sfc/ef100_sriov.h  |   2 +-
 drivers/net/ethernet/sfc/efx_common.c   |   2 +
 drivers/net/ethernet/sfc/net_driver.h   |   2 +
 8 files changed, 187 insertions(+), 11 deletions(-)
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
index 000000000000..559f1f74db5e
--- /dev/null
+++ b/drivers/net/ethernet/sfc/ef100_rep.h
@@ -0,0 +1,30 @@
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
+/* Private data for an Efx representor */
+struct efx_rep {
+	struct efx_nic *parent;
+	struct net_device *net_dev;
+	u32 msg_enable;
+	struct list_head list; /* entry on efx->vf_reps */
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
index 2228c88a7f31..80ee2c936f59 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -1145,6 +1145,8 @@ struct efx_nic {
 	unsigned vf_init_count;
 	unsigned vi_scale;
 #endif
+	spinlock_t vf_reps_lock; /* Protects vf_reps list */
+	struct list_head vf_reps; /* local VF reps */
 
 	struct efx_ptp_data *ptp_data;
 	bool ptp_warned;

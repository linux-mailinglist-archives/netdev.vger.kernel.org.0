Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4CD6DA653
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231223AbjDFXnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:43:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238744AbjDFXmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:42:32 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 584B89764
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:42:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jrd+HcNn0krO1YikUJyKyQoiNdCRwdnKsHd3CRO6JzTAfUR3kqr0jKGkG2aWfF2CIUHopOvRWGIuaboJ0bQuBN+2W+fdKqVQJfZWr8B6sSThbGfdVYHfrauoOmFSea4ivlFqW5m2hFyP+YP02hSDP3kV10mux43vDhh84WZnEGpcvptXGk24ABoWJqMeOx/A2AwV6w8I5sDLoe4HQrweDMG9GeOPbLZ3yMvxlhohmTUmkLxs9nWEiL5MFxB9Wa5cgbhdzyVnXf0nDFtgQBQPRDn1sBAgPYNl2UItlcchk/4EE6p4jWo1f5o+ts6a/04bAg97k8sLnjLvJGPZdYMDfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2Ae0iaUUXszC7d77NDhaj+w6NA5taAPw8FRwkXCAMis=;
 b=SL4T7J9DiD7C7tRwkNEPPY5iRDxjysbypcsxA0usaS/T0/lsne1k2PviTfMuc1+pbGLLieSyJYW/4yn6t08Y/0VK523zSzB6h1OcoYz2J7YGkKCKCpjX8ZL9wd4SozHud2NK/kskgAuT9n5ThqEfzEhptso23u5MTWbc1wKqm5eG/dVxxkXFurLssT1bd+9wbe48XClcRVk7f2Fib7ZRKPg+oleNKkW+7DqLcunYBK7JDRvFgRfyhC/ybyWnSZ82Yk9++xPIwSUOvNbCdv3R0TVxiyJkHRW+oJD7jjz3c+3jNvPrfroG4h6/Eup69VtMprP3yqLPG3ng3L6aFoG/ww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2Ae0iaUUXszC7d77NDhaj+w6NA5taAPw8FRwkXCAMis=;
 b=UcU9xo16RH4FYHl/vPFNk4jT0CXTpdqRlEUWuRigxUMATWTLxowwmLNsMBgCGOy7j29f8ilk5P3PbC+RzDcKU/oY0V/cRqB3tw3bAXYwmrcte0yYmBcmUpbz/YgW0mVh0jrWQTQ2Wt+bwPXOzX9Kd2d2A9i14NMPxoeS7FYHZmQ=
Received: from DM6PR04CA0023.namprd04.prod.outlook.com (2603:10b6:5:334::28)
 by PH7PR12MB8178.namprd12.prod.outlook.com (2603:10b6:510:2b3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 23:42:26 +0000
Received: from DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:334:cafe::40) by DM6PR04CA0023.outlook.office365.com
 (2603:10b6:5:334::28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 23:42:26 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT011.mail.protection.outlook.com (10.13.172.108) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.31 via Frontend Transport; Thu, 6 Apr 2023 23:42:25 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 18:42:24 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v9 net-next 10/14] pds_core: add auxiliary_bus devices
Date:   Thu, 6 Apr 2023 16:41:39 -0700
Message-ID: <20230406234143.11318-11-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230406234143.11318-1-shannon.nelson@amd.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT011:EE_|PH7PR12MB8178:EE_
X-MS-Office365-Filtering-Correlation-Id: b1f0f9fa-e7bc-4010-9950-08db36f893aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K1uEhXp+9RN8qBmNEOnOisDjlopATYiNKnBtCE6z0fwKyyqonsxA2R3/dBWIMd3RwczTurgXCOdNDjjGZ1IAb22G1KHGiZCSKhMVmL1sH23mWCx95D9ytgXM0bVZUB/xkEWqYbNy7UqC1NM54eIm4cYdJxDbNC5NhqaXMVbFEYAQUXS3O3P6kGhHPH6fkon+Kt/mlIUGXtZKQnUDyW94d8iAag5RliXYTzHo+jXaCy4bfgkH8biPQaCD18WEjltirwtr3Ty8sIIxsCNq4PDoY+PSDAGRX62SZ+bKa8IpJ2qoAz4Whmz4TR+XJEnx0NGufDm6DvJgzhApCp84lfPoBzgE8IoOYVOphmTAuy07xLhy76Td/o+fRcjPj6JcHcKwwjQgyOUi7MwYgvAeHbkgHHKVNPL2XtZ6Vrm8FLNpNvRa80MtHxPL5aEk486Ju1Eem1qv2tp+mbRM0m0vkC1sFkGJXefzVN5rOPiHW22kh55KzJjZdL8q0XACcC9653Ry2LDpqeRuMUCmPMVqL845lrQpmBpzqdaqlG/yk4aPdyb7ZiQmdvcF6mLK9Z1zFi6J+R/iqTH9wQ+XwjeSd8Zh/nzDOCEwEdonJyjioyw42HQf6hBDItWDqxHe5o+EYfOCqbOAdnq4lg4Qs3wzcuMFfq3hNv2osv8jEFQXUE7GCqcS691JcrCRIC/9xBr1ed6Szt38UL6hFGSA7q7dAJT8EFijcRxwYj5cwDz+SzvnL4gJ4rck1IrxohWwxbTU14cR
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199021)(40470700004)(36840700001)(46966006)(6666004)(2616005)(186003)(44832011)(8936002)(16526019)(2906002)(5660300002)(110136005)(82740400003)(26005)(81166007)(1076003)(356005)(54906003)(36860700001)(4326008)(8676002)(426003)(41300700001)(336012)(70586007)(70206006)(86362001)(40460700003)(316002)(40480700001)(478600001)(82310400005)(36756003)(47076005)(83380400001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:42:25.9496
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: b1f0f9fa-e7bc-4010-9950-08db36f893aa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB8178
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An auxiliary_bus device is created for each vDPA type VF at VF
probe and destroyed at VF remove.  The aux device name comes
from the driver name + VIF type + the unique id assigned at PCI
probe.  The VFs are always removed on PF remove, so there should
be no issues with VFs trying to access missing PF structures.

The auxiliary_device names will look like "pds_core.vDPA.nn"
where 'nn' is the VF's uid.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile |   1 +
 drivers/net/ethernet/amd/pds_core/auxbus.c | 112 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |   6 ++
 drivers/net/ethernet/amd/pds_core/main.c   |  36 ++++++-
 include/linux/pds/pds_auxbus.h             |  16 +++
 include/linux/pds/pds_common.h             |   1 +
 6 files changed, 170 insertions(+), 2 deletions(-)
 create mode 100644 drivers/net/ethernet/amd/pds_core/auxbus.c
 create mode 100644 include/linux/pds/pds_auxbus.h

diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
index 6d1d6c58a1fa..0abc33ce826c 100644
--- a/drivers/net/ethernet/amd/pds_core/Makefile
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_PDS_CORE) := pds_core.o
 
 pds_core-y := main.o \
 	      devlink.o \
+	      auxbus.o \
 	      dev.o \
 	      adminq.o \
 	      core.o \
diff --git a/drivers/net/ethernet/amd/pds_core/auxbus.c b/drivers/net/ethernet/amd/pds_core/auxbus.c
new file mode 100644
index 000000000000..6757a5174eb7
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -0,0 +1,112 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/pci.h>
+
+#include "core.h"
+#include <linux/pds/pds_auxbus.h>
+
+static void pdsc_auxbus_dev_release(struct device *dev)
+{
+	struct pds_auxiliary_dev *padev =
+		container_of(dev, struct pds_auxiliary_dev, aux_dev.dev);
+
+	kfree(padev);
+}
+
+static struct pds_auxiliary_dev *pdsc_auxbus_dev_register(struct pdsc *vf,
+							  struct pdsc *pf,
+							  char *name)
+{
+	struct auxiliary_device *aux_dev;
+	struct pds_auxiliary_dev *padev;
+	int err;
+
+	padev = kzalloc(sizeof(*padev), GFP_KERNEL);
+	if (!padev)
+		return ERR_PTR(-ENOMEM);
+
+	padev->vf_pdev = vf->pdev;
+	padev->pf_pdev = pf->pdev;
+
+	aux_dev = &padev->aux_dev;
+	aux_dev->name = name;
+	aux_dev->id = vf->uid;
+	aux_dev->dev.parent = vf->dev;
+	aux_dev->dev.release = pdsc_auxbus_dev_release;
+
+	err = auxiliary_device_init(aux_dev);
+	if (err < 0) {
+		dev_warn(vf->dev, "auxiliary_device_init of %s failed: %pe\n",
+			 name, ERR_PTR(err));
+		goto err_out;
+	}
+
+	err = auxiliary_device_add(aux_dev);
+	if (err) {
+		dev_warn(vf->dev, "auxiliary_device_add of %s failed: %pe\n",
+			 name, ERR_PTR(err));
+		goto err_out_uninit;
+	}
+
+	return padev;
+
+err_out_uninit:
+	auxiliary_device_uninit(aux_dev);
+err_out:
+	kfree(padev);
+	return ERR_PTR(err);
+}
+
+int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf)
+{
+	struct pds_auxiliary_dev *padev;
+	int err = 0;
+
+	mutex_lock(&pf->config_lock);
+
+	padev = pf->vfs[vf->vf_id].padev;
+	if (padev) {
+		auxiliary_device_delete(&padev->aux_dev);
+		auxiliary_device_uninit(&padev->aux_dev);
+	}
+	pf->vfs[vf->vf_id].padev = NULL;
+
+	mutex_unlock(&pf->config_lock);
+	return err;
+}
+
+int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf)
+{
+	struct pds_auxiliary_dev *padev;
+	enum pds_core_vif_types vt;
+	int err = 0;
+
+	mutex_lock(&pf->config_lock);
+
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++) {
+		u16 vt_support;
+
+		/* Verify that the type is supported and enabled */
+		vt_support = !!le16_to_cpu(pf->dev_ident.vif_types[vt]);
+		if (!(vt_support &&
+		      pf->viftype_status[vt].supported &&
+		      pf->viftype_status[vt].enabled))
+			continue;
+
+		padev = pdsc_auxbus_dev_register(vf, pf,
+						 pf->viftype_status[vt].name);
+		if (IS_ERR(padev)) {
+			err = PTR_ERR(padev);
+			goto out_unlock;
+		}
+		pf->vfs[vf->vf_id].padev = padev;
+
+		/* We only support a single type per VF, so jump out here */
+		break;
+	}
+
+out_unlock:
+	mutex_unlock(&pf->config_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 5be2b986c4d9..16b20bd705e4 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -30,8 +30,11 @@ struct pdsc_dev_bar {
 	int res_index;
 };
 
+struct pdsc;
+
 struct pdsc_vf {
 	struct pds_auxiliary_dev *padev;
+	struct pdsc *vf;
 	u16     index;
 	__le16  vif_types[PDS_DEV_TYPE_MAX];
 };
@@ -300,6 +303,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf);
+int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf);
+
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 5bda66d2a0df..16a2d8a048a3 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -180,6 +180,12 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 static int pdsc_init_vf(struct pdsc *vf)
 {
 	struct devlink *dl;
+	struct pdsc *pf;
+	int err;
+
+	pf = pdsc_get_pf_struct(vf->pdev);
+	if (IS_ERR_OR_NULL(pf))
+		return PTR_ERR(pf) ?: -1;
 
 	vf->vf_id = pci_iov_vf_id(vf->pdev);
 
@@ -188,7 +194,15 @@ static int pdsc_init_vf(struct pdsc *vf)
 	devl_register(dl);
 	devl_unlock(dl);
 
-	return 0;
+	pf->vfs[vf->vf_id].vf = vf;
+	err = pdsc_auxbus_dev_add_vf(vf, pf);
+	if (err) {
+		devl_lock(dl);
+		devl_unregister(dl);
+		devl_unlock(dl);
+	}
+
+	return err;
 }
 
 static const struct devlink_health_reporter_ops pdsc_fw_reporter_ops = {
@@ -379,7 +393,19 @@ static void pdsc_remove(struct pci_dev *pdev)
 	}
 	devl_unlock(dl);
 
-	if (!pdev->is_virtfn) {
+	if (pdev->is_virtfn) {
+		struct pdsc *pf;
+
+		pf = pdsc_get_pf_struct(pdsc->pdev);
+		if (!IS_ERR(pf)) {
+			pdsc_auxbus_dev_del_vf(pdsc, pf);
+			pf->vfs[pdsc->vf_id].vf = NULL;
+		}
+	} else {
+		/* Remove the VFs and their aux_bus connections before other
+		 * cleanup so that the clients can use the AdminQ to cleanly
+		 * shut themselves down.
+		 */
 		pdsc_sriov_configure(pdev, 0);
 
 		del_timer_sync(&pdsc->wdtimer);
@@ -419,6 +445,12 @@ static struct pci_driver pdsc_driver = {
 	.sriov_configure = pdsc_sriov_configure,
 };
 
+void *pdsc_get_pf_struct(struct pci_dev *vf_pdev)
+{
+	return pci_iov_get_pf_drvdata(vf_pdev, &pdsc_driver);
+}
+EXPORT_SYMBOL_GPL(pdsc_get_pf_struct);
+
 static int __init pdsc_init_module(void)
 {
 	pdsc_debugfs_create();
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
new file mode 100644
index 000000000000..aa0192af4a29
--- /dev/null
+++ b/include/linux/pds/pds_auxbus.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDSC_AUXBUS_H_
+#define _PDSC_AUXBUS_H_
+
+#include <linux/auxiliary_bus.h>
+
+struct pds_auxiliary_dev {
+	struct auxiliary_device aux_dev;
+	struct pci_dev *vf_pdev;
+	struct pci_dev *pf_pdev;
+	u16 client_id;
+	void *priv;
+};
+#endif /* _PDSC_AUXBUS_H_ */
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 350295091d9d..898f3c7b14b7 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -91,4 +91,5 @@ enum pds_core_logical_qtype {
 	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
 };
 
+void *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
 #endif /* _PDS_COMMON_H_ */
-- 
2.17.1


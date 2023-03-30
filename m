Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1511F6D0EAE
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 21:24:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbjC3TYN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 15:24:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231583AbjC3TXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 15:23:44 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1221BB87
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 12:23:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFqyyLTHAbiKMxBUD5A8aLgxicwjGKfJpstm7V7R/Pk/Yae50Z5dHq34jGzZyxm+IxKRJn2raVeG7jBdwaueSCLdzewUafBRvRi9k2KS7AEOB7F7U+yCFxqMsXTFCkGHceDVZDuw2xHja+IyFz0cmoq/fY44cVC0M7Nm99woJJvv4btCmy1fdrQl/2iz768Ag7lFhXtYMi7uyo0PmLuXksRSX2aVGU+nm3vZjiHIIes5mhvB6Dcvq5jdj/QbMKtN1ksIP+WwU9a+yQBy6RBHdpvmFZqt3etgiMjGJfKOmtF8rsFh35K6VeK5HftSywA9u5CXwKWxDjg8vWbPboEsXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xm3ghrf1n/7YiHpafWwKexJXpE1Rchf3q6DTXhi+vSQ=;
 b=J4byNmtjAM5DxaY0NUmW39bTkkSDBw/UIn31jMHz8857o1Oczg7PTxDdkb3+GCtCf8UPPo94Q2OcwOzP2Qu/qakgDnC9VP4B2yi8nIDE8mJAbLwo/cBHLeF/9zmtOVN9x+pWhm0qrPo0SGe44Tm8StBmBLeFiCrx0sn7w7KisFJJ0f6CqVRFp4fTN4BikWS7/HaXwdyPpEaB/39Se1w1fj61ELh94oWfbbzYhQnV5L99hmryZZUTE6awToTRmoNrv101xd9q+HbxBS0V7BU5pJ8Hm6c6e4mw0ck3yRzmcPXvYLEycoF06SS9zJ8ImdKp5Ckj+hCxC1KxayRsJjn/og==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xm3ghrf1n/7YiHpafWwKexJXpE1Rchf3q6DTXhi+vSQ=;
 b=kgjk1uNE5ejKQiJZ4sLnxFx/pJkZOZyr0lXbigrUJtWJaxRqekKkwdxUs+I4ztoTUizsoQJPKY6RCBerLKo7KUmvBkU/kGedsry9dSxNhs6BYAxKkCeiNF5utNUCKf1KUsrxVDfODB17oRMse3nqxZU2VBpdvqA2gc7zCpEvpSk=
Received: from MW4PR03CA0060.namprd03.prod.outlook.com (2603:10b6:303:8e::35)
 by IA0PR12MB8983.namprd12.prod.outlook.com (2603:10b6:208:490::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 19:23:40 +0000
Received: from CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8e:cafe::37) by MW4PR03CA0060.outlook.office365.com
 (2603:10b6:303:8e::35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Thu, 30 Mar 2023 19:23:39 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT114.mail.protection.outlook.com (10.13.174.103) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.22 via Frontend Transport; Thu, 30 Mar 2023 19:23:39 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 14:23:37 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v7 net-next 10/14] pds_core: add auxiliary_bus devices
Date:   Thu, 30 Mar 2023 12:23:08 -0700
Message-ID: <20230330192313.62018-11-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330192313.62018-1-shannon.nelson@amd.com>
References: <20230330192313.62018-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT114:EE_|IA0PR12MB8983:EE_
X-MS-Office365-Filtering-Correlation-Id: a5189782-4a01-4342-6260-08db3154444e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JdJlTcfcMBDhdI2OC6kDGG6NTVtFPEsatT17kk5FgfbtQkU+sXFCGZ4iKrqwTJpDWrYDQgBG1WBSLn978HWrPVeuq2obp/4pzqdazuAeb+qKkPHRqAl6Nh61DVOGXlEfGFdGiQWHDZqz/OXPnidNIvB8TLzrQRFF+PzZSThG/ehPqXgTFJP/JcD8zpAei1LTFlk5Ea6VYSVPOUGV40X0Y4vSNjUZ8nwPKAFqeK6LmuL6iG/5G97N3odb7VhH/QbHz9ek5xSmuIVekFogYFlQMz8rn81iD+WLdHF+WFkyoqCVwB77cvVJHZ2rKzyWuFynw9HE/tUQHwobsX/8kT/LUvmRfZBUFUZKRCMBALJM+48BFMMoz0FIAh7kgVk43PKrD+Pg3NDEiEOQfmS1LBPpAPNxdcMTG3v6cH/K+ZZjadoFinnZfsP7Da+KxjBmL4UW+09KBU14jrOCunV6MsWWYvIGwXzl8AZleSCgfxgOexcHL3ppSup0kQuIrvhdJuGpwix0tPYSNel56kSh+8BviXwwFRZw1j1I8y7QdGfxPYRFLKdT8rtadslzzA4rg2PZ/gR4veMMQXxGm7i/tCKBrse98pdOZtUdK08kIcDVCOOq8QvVjfSwzOqnE6GxC79GmD9Mic0FL4ImOmZP2ixe7i6A0RguqK90/eY5L+etPxz1mukZLsEzBtsEdSbNOoqVTpnVUFYNr73w2Jb7CFL7jRSlm9MzbpawWOibgEBFclYdCLo7KhwBmry6UWgXZBtt
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(346002)(136003)(396003)(376002)(451199021)(46966006)(40470700004)(36840700001)(47076005)(426003)(2616005)(83380400001)(36860700001)(336012)(54906003)(478600001)(316002)(16526019)(186003)(6666004)(110136005)(1076003)(26005)(2906002)(5660300002)(82310400005)(8936002)(70206006)(40460700003)(36756003)(81166007)(44832011)(356005)(40480700001)(82740400003)(8676002)(41300700001)(4326008)(86362001)(70586007)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 19:23:39.4340
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a5189782-4a01-4342-6260-08db3154444e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8983
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An auxiliary_bus device is created for each vDPA type VF at VF probe
and destroyed at VF remove.  The VFs are always removed on PF remove, so
there should be no issues with VFs trying to access missing PF structures.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile |   1 +
 drivers/net/ethernet/amd/pds_core/auxbus.c | 142 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.h   |   6 +
 drivers/net/ethernet/amd/pds_core/main.c   |  36 +++++-
 include/linux/pds/pds_auxbus.h             |  16 +++
 include/linux/pds/pds_common.h             |   1 +
 6 files changed, 200 insertions(+), 2 deletions(-)
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
index 000000000000..7c6a84009558
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -0,0 +1,142 @@
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
+	aux_dev->id = vf->id;
+	aux_dev->dev.parent = vf->dev;
+	aux_dev->dev.release = pdsc_auxbus_dev_release;
+
+	err = auxiliary_device_init(aux_dev);
+	if (err < 0) {
+		dev_warn(vf->dev, "auxiliary_device_init of %s id %d failed: %pe\n",
+			 name, vf->id, ERR_PTR(err));
+		goto err_out;
+	}
+
+	err = auxiliary_device_add(aux_dev);
+	if (err) {
+		dev_warn(vf->dev, "auxiliary_device_add of %s id %d failed: %pe\n",
+			 name, vf->id, ERR_PTR(err));
+		auxiliary_device_uninit(aux_dev);
+		goto err_out;
+	}
+
+	return padev;
+
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
+	if (pf->state) {
+		dev_warn(vf->dev, "%s: PF in a transition state (%lu)\n",
+			 __func__, pf->state);
+		err = -EBUSY;
+	} else if (vf->vf_id >= pf->num_vfs) {
+		dev_warn(vf->dev, "%s: vfid %d out of range\n",
+			 __func__, vf->vf_id);
+		err = -ERANGE;
+	}
+	if (err)
+		goto out_unlock;
+
+	padev = pf->vfs[vf->vf_id].padev;
+	if (padev) {
+		auxiliary_device_delete(&padev->aux_dev);
+		auxiliary_device_uninit(&padev->aux_dev);
+	}
+	pf->vfs[vf->vf_id].padev = NULL;
+
+out_unlock:
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
+	if (pf->state) {
+		dev_warn(vf->dev, "%s: PF in a transition state (%lu)\n",
+			 __func__, pf->state);
+		err = -EBUSY;
+	} else if (!pf->vfs) {
+		dev_warn(vf->dev, "%s: PF vfs array not ready\n",
+			 __func__);
+		err = -ENOTTY;
+	} else if (vf->vf_id >= pf->num_vfs) {
+		dev_warn(vf->dev, "%s: vfid %d out of range\n",
+			 __func__, vf->vf_id);
+		err = -ERANGE;
+	} else if (pf->vfs[vf->vf_id].padev) {
+		dev_warn(vf->dev, "%s: vfid %d already running\n",
+			 __func__, vf->vf_id);
+		err = -ENODEV;
+	}
+	if (err)
+		goto out_unlock;
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
index bfe0274942d1..27aaffdc5056 100644
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
@@ -301,6 +304,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf);
+int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf);
+
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 8eaace786efa..0ca5399314a2 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -201,6 +201,12 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
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
 
@@ -209,7 +215,15 @@ static int pdsc_init_vf(struct pdsc *vf)
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
@@ -400,7 +414,19 @@ static void pdsc_remove(struct pci_dev *pdev)
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
@@ -440,6 +466,12 @@ static struct pci_driver pdsc_driver = {
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


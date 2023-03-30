Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2F56D1398
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 01:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231761AbjC3Xrs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 19:47:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231724AbjC3XrW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 19:47:22 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7854D51E
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 16:46:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZnWZyB+CETLh58zzJ4E2xkI9K6/fLNB2i0RFdNLu+2YtrUsqIE77tf8ruQQJSRplNaWj3dLeFrPHd0iM90ef6pOsgm9ZBvoW+aNQ7UjS7SWhc1990P5EVTS6PNJKIyFRfZHBGXKERGrhITzKRyZVHwKgE4QJVL9lyOuP03+yN6morHpbXPDvlAXlcBk5cpJOOr9Iak7esbyb5AXoD793ykJy4U2kBbGsNQn5wJJsK98+TKjYFdtLsaPLBHfQ2TFYphiJ/YxVzpgci1Ggfnh4h422nOIkrnQtUpp5+u6G16fJ0x4Kswddb5V2Gv8Vhe//HW5zk+wG48OfOIUdVItLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RXx3YltFQyhGXLc+d5M+7/IgEU6ea7YMi6IcPk8VYrw=;
 b=K0VKimd9NlITk5Iwd+ZbkBksUCmmmbzj+IocKPecKXP8PTxZo2yg4jmZiaonD7gNgdbmk/5YuzXb48sv3Cehye1fSqmrC4UE6cqgXrRbYdjtK7R2UH1175rrMK6DeRM4WGOegB3d/+P0a2H5Zopj270e5OJyzcQKLHDjEuUI3H2Bfhj9ERf/IgTxnqQUvuG3ZSQqjFiWZiAEg7G5f+7Z3bNi4/u0xDf59s35HBI6wE8qMhKV+CZJsVsMhhMFXLHFuRcqQWLERJZpuvAmyompIiH6099dxlRMeP0j0SjdRdfYUHRRCQJBL19+Xe2tueY7yBQ+Dv9VXcgUtP84r6DxJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RXx3YltFQyhGXLc+d5M+7/IgEU6ea7YMi6IcPk8VYrw=;
 b=CaRg7JGsbQwWQ4fqLxJJWOOKXnGC5gF91C3+T4ThnsUM4Miw+m8ga+/P74cagEmpnP+ccZLqvPSOUFgf9FC3cNhrlcynfJnb62RvFkQD5NufqXDa8dUwAKD1JotZLchYknq+An1dCbP2gzdufVJk4W3gE4OX5W1LFk3KqQYSY2g=
Received: from MN2PR15CA0028.namprd15.prod.outlook.com (2603:10b6:208:1b4::41)
 by PH7PR12MB7235.namprd12.prod.outlook.com (2603:10b6:510:206::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Thu, 30 Mar
 2023 23:46:55 +0000
Received: from BL02EPF000100D2.namprd05.prod.outlook.com
 (2603:10b6:208:1b4:cafe::80) by MN2PR15CA0028.outlook.office365.com
 (2603:10b6:208:1b4::41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Thu, 30 Mar 2023 23:46:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BL02EPF000100D2.mail.protection.outlook.com (10.167.241.206) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Thu, 30 Mar 2023 23:46:55 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 18:46:53 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v8 net-next 10/14] pds_core: add auxiliary_bus devices
Date:   Thu, 30 Mar 2023 16:46:24 -0700
Message-ID: <20230330234628.14627-11-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230330234628.14627-1-shannon.nelson@amd.com>
References: <20230330234628.14627-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BL02EPF000100D2:EE_|PH7PR12MB7235:EE_
X-MS-Office365-Filtering-Correlation-Id: ded5aed6-cb74-450d-d59f-08db31790b36
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SfPIBDdr1JLBw4FiqhdqogrKNM4DNRuQu+lK0A37/6965VSj1YsrTaHNmQ/jhsEBTbHWOea76gKW7FVcC9O1sxMKAGnrHNKd01gm+0yAnLj4jE6RCCgcwpxDFtt4PgV9JMcR5qtGFOVtV9W3V14dbVCaigLLXOFqyuNnV1SN0yXIbWWMd+rxFMQv/WNwTrar/SJlioO8x3HiWhSwPvfNf1y66ix25RG2RgkkC85484xI9n1wnv4oH9btm9x1+HXCAcdo4Y7npbgXmesBaTKf7AGgvUiGreisC/9rL8471Yl5s4OMhLLt+HuXyHryZq4UFEATI6muUDHmn1WUvF3pMn2qcCCpAFXjYG/3T5XybSfq19rvcilZpAahx6GFvaYCKAOXrYDKAWNoQ3x8R1t9Ud/HifCrGtKyWeudPK149T6N6U1HfrHFLgTK5aErtpKA1iawOnf6uW5ClH7t5SHVrI74J56nA6cmgoODb+fMcVMtjJr9+PtOczMLo4KOUbk6K0tNkV8vaSoVuFeS2ZeGZZu9W/6CL3GVgW3OAkzAuITv8YLAur+0/jWUgVhiWRDp5S19EzK7v8cjQnLpAB5qCzzXXnCXDwU82szskVKs5/2vBsGlicHVJQ1T1tSmbmw1cizEqEY9D9RQAGF0hy7DF7VPlITY5/XCzSc4JA23xpaR+zC/43dWWf4lq9b0nUW9Hyp1LeBwKtmSAEdCurMaae25DgizEEFlhp+Cs2JSYSTKL+tz9aKqDXPzkw9Aphh6
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(39860400002)(346002)(396003)(451199021)(46966006)(40470700004)(36840700001)(47076005)(356005)(36756003)(70586007)(81166007)(4326008)(5660300002)(82310400005)(8936002)(44832011)(40460700003)(86362001)(82740400003)(70206006)(41300700001)(40480700001)(8676002)(2906002)(2616005)(336012)(426003)(83380400001)(36860700001)(54906003)(1076003)(6666004)(110136005)(26005)(478600001)(316002)(186003)(16526019)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2023 23:46:55.1535
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ded5aed6-cb74-450d-d59f-08db31790b36
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BL02EPF000100D2.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7235
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
index 313057a57deb..900158135938 100644
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


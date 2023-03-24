Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647416C8586
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:03:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbjCXTD4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCXTDU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:20 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2071.outbound.protection.outlook.com [40.107.93.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 196201ADC2
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L8kcEg42+UyweVTsujMrQ4V9+THFpE6r/0KudsV+YyIdzPhwf+9F4jnGN4xDu13/p7uTB+NGiaRMPabpoj3C6HLM6/92fQFiLtzXrB0cBQJPKfMWj/GsH8JPEjJFHAVPygB6RuHqDsn4S0InAQRk+CtbiZt8d//q/dSrhYVt3kPbHpcHM2Cui4rA4lJEMUpQkvNtHjq/wQBnHCiUDBlWg0DTTmaGJYeBKkOj1Vlk5a+p3KujFBppEss9n9CPcljEe3UTWq45b7Nftt7sB5rVEqooaicBWWSHKvG4zeEB6MJUAOThoQPTWje2i3zp8cA3rHvmgKoZdJZRtMjtqmKykg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qHPOtVupX1tlZfj+oE+PBY85t6Wb26H0+UKyvZ0KMlc=;
 b=XfNtpBsQnUzQMxtHfYryi4uZXUrp0eQm49z8pgKUQjP9sTKFNrPhxuB2vMx6I7x1bNygWRVOTv9ffdp1n6TgCBXfp7CsjaOkGG01k8czKRlhGz/oPcKqlyjdqgBMOhKhqhBnegGNi3TAHIxxfWX2ZNyeHMLtRxLn0/OG5eGg/Rx8dA514CAlsum8/FSyfMqc7PNVNvVJWzFdZJ4IjnosPZZaV/MHuOabmPF//UtkmZnD9TU4uZal3ug+fqzEqXCNyDD+JzSkI8bgDnqV/u4Lf6R6NhPa/7EolwV9KqhVZiBvoyLy1k4AqyuPatKrC2Hs05GGbaTKunKvDj7ZCbjwAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qHPOtVupX1tlZfj+oE+PBY85t6Wb26H0+UKyvZ0KMlc=;
 b=a3pjkx7hi9sYPlQL60LYl5oEyTMNl1ftaD3O0NR779HVes5qQ2oNBqgu4H+OJ6lfhVFjMvH6d5E5P+3Vl8tYVoTK68GB7rqC/6J3J6VFBScMvcUBuiEhQ+EjKOefjeYOPgj/eDauVkl+KjhcyZHKDTewo9RVs8HB3fGasG842g8=
Received: from DM6PR21CA0009.namprd21.prod.outlook.com (2603:10b6:5:174::19)
 by SA0PR12MB4384.namprd12.prod.outlook.com (2603:10b6:806:9f::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 19:03:15 +0000
Received: from DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:174:cafe::78) by DM6PR21CA0009.outlook.office365.com
 (2603:10b6:5:174::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.9 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT076.mail.protection.outlook.com (10.13.173.204) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6254.9 via Frontend Transport; Fri, 24 Mar 2023 19:03:15 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:13 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 10/14] pds_core: add auxiliary_bus devices
Date:   Fri, 24 Mar 2023 12:02:39 -0700
Message-ID: <20230324190243.27722-11-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230324190243.27722-1-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT076:EE_|SA0PR12MB4384:EE_
X-MS-Office365-Filtering-Correlation-Id: ebcf4330-6a94-40ef-a21a-08db2c9a6c0f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: P01xUIkxWbY/nI0LkFqH4q13WKZu9jrVXzLjhsSxyJjBw9ma5vNQR1XMxDJ/kuzsiTIhe1/VCv7KtLC8PNd0v5yLPk6bG0zyjAvtlWOdbhT6rlc4UCyfOj2KEFWNzkYfSPvFfgZdMARB+qgL050jXCwSyDe5eUrdj2sxQssPZoeP+863HmMDyae8sJ1PkNZnNQKmCUwZ1l9DohP9VMtULwLvtoQpXJhiOEIbJBT9ZQH673Pn33v94/4+yQAVEg4FKGHZmpyU7a6izUDphI6RDlx+MR6NCMeEUltoKuOaD6B4cfO4GzRE+Vkry6YoFmvOJ46EKyoIIrk1V1U04z/IXoDNIO4+NiQxVMauTFUT84PYh6fVuM3peQmb01ddg4ic3MIYn2a32G1xEAFonAOL6oE0CmQi2jwQ8R8LGvsbHBOfXkCHamlvZSzrfL2J/FWefUTcPGJiy52/rfwOzj9wPyCx5e1jH6VXk82vyeGweCywnqOMJz9ktiI9+iiUErxYmKh+/IokuLf2KCbUJKIXT2Da3FTDFbr++ebKRWIVEoAOq25Gc+Qu3S3M5jxki47PBSKapo46lCkX6Z28NCFd/YWF8uPJCXi/k4neEBP1dj4dgREa3Jbpu9LCkolDrBJuw1rTE4uAYcud78LnqFJ3u43ALCfNNQ8FLf4v5f5ZEfFbcIELgurZLylQCnSgm/fltR36CCdFkKhcm660cKRO9poAecCMuAV+8UIKRioedc/mESDikmXBW4FQtmZvhiEz
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(136003)(346002)(39860400002)(376002)(451199021)(46966006)(40470700004)(36840700001)(82310400005)(40480700001)(2906002)(356005)(4326008)(70206006)(70586007)(6666004)(8676002)(5660300002)(41300700001)(44832011)(82740400003)(54906003)(36860700001)(478600001)(426003)(1076003)(186003)(8936002)(336012)(2616005)(26005)(81166007)(40460700003)(36756003)(47076005)(110136005)(86362001)(16526019)(316002)(83380400001)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:15.1825
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ebcf4330-6a94-40ef-a21a-08db2c9a6c0f
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT076.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4384
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
 drivers/net/ethernet/amd/pds_core/main.c   |  37 +++++-
 include/linux/pds/pds_auxbus.h             |  16 +++
 include/linux/pds/pds_common.h             |   1 +
 6 files changed, 201 insertions(+), 2 deletions(-)
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
index 74f80af53067..ce3598cf8de1 100644
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
@@ -299,6 +302,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_auxbus_dev_add_vf(struct pdsc *vf, struct pdsc *pf);
+int pdsc_auxbus_dev_del_vf(struct pdsc *vf, struct pdsc *pf);
+
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 486eb87a0520..d2ff64046db8 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -200,15 +200,36 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 
 static int pdsc_init_vf(struct pdsc *vf)
 {
+	struct pdsc *pf;
 	int err;
 
+	pf = pdsc_get_pf_struct(vf->pdev);
+	if (IS_ERR_OR_NULL(pf))
+		return PTR_ERR(pf) ?: -1;
+
 	vf->vf_id = pci_iov_vf_id(vf->pdev);
 
 	err = pdsc_dl_register(vf);
 	if (err)
 		return err;
 
-	return 0;
+	pf->vfs[vf->vf_id].vf = vf;
+	err = pdsc_auxbus_dev_add_vf(vf, pf);
+	if (err)
+		pdsc_dl_unregister(vf);
+
+	return err;
+}
+
+static void pdsc_del_vf(struct pdsc *vf)
+{
+	struct pdsc *pf;
+
+	pf = pdsc_get_pf_struct(vf->pdev);
+	if (IS_ERR(pf))
+		return;
+	pdsc_auxbus_dev_del_vf(vf, pf);
+	pf->vfs[vf->vf_id].vf = NULL;
 }
 
 #define PDSC_WQ_NAME_LEN 24
@@ -361,7 +382,13 @@ static void pdsc_remove(struct pci_dev *pdev)
 	 */
 	pdsc_dl_unregister(pdsc);
 
-	if (!pdev->is_virtfn) {
+	if (pdev->is_virtfn) {
+		pdsc_del_vf(pdsc);
+	} else {
+		/* Remove the VFs and their aux_bus connections before other
+		 * cleanup so that the clients can use the AdminQ to cleanly
+		 * shut themselves down.
+		 */
 		pdsc_sriov_configure(pdev, 0);
 
 		del_timer_sync(&pdsc->wdtimer);
@@ -401,6 +428,12 @@ static struct pci_driver pdsc_driver = {
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


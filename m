Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CECB6AFE24
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:14:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjCHFN6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:13:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbjCHFNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:13:45 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2045.outbound.protection.outlook.com [40.107.243.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FE587A3B
        for <netdev@vger.kernel.org>; Tue,  7 Mar 2023 21:13:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cL+MiuMD+viYztA0fdhokiFPjv8TyjVlnzg4Z2+9GBdccBkQlWX6a38PVmTpshDMXFYa8KJE4eykBoooM6KNsYWFLg/SQzdIuzGldnc8OqgsLJJq3IFarWVzZ8RBZnbhWuxE2VunEZfJ8kQqa1HmilCL4oisIpc1hpKlyN+s2UzeUJI2GIeqVkXlbMfTu7i6+BZdrVk7sFVRDYaPF1HMKY8X3OikuG4z3+KxRojt8HZSUbNhfuZ+VFnE68aJfZRz5sIKCyJxBZNl7hevznWEb0Q5hDCinNdGN+VsV0Tfrp/ypVFSMNcOx6IhXXBj+7Gw/1zT/NZmJHdhCd9QyKj31Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3hizKF3hGdIG0Mbo+J42ZAOdpolRImjmWKH9M1BTQf4=;
 b=RdhoeFY7i3U3VTkrY0fvq/2Pdpnw6hlpZcnauCXxxiBfnLPZM4KEXeIIAH59ZAJjOzD9uIzQsCAfefWVOLmHb7c1xNwvWt2+pO0OWZ4LtA6QvFj8oIWlBWBUURJVAWMf+cDzrGMywJuGQTFVTyXHTqRH66NP7PDn4fHahodY5HlqYDQHv8Sft26dVxuvAQAtffPQHZaJoivqvS6F3YPkBCnfrie/lmD2CVXXrcquPHiYlkOhrLPtt5tEwyOYtfco4Uvb1NnxqO57g4APJBRtcTnCCg1sdfmIJEXm5BzXGFq0FBGrlWegIF4hZ5AWkEUHNKqhicM95EzO2KpbAQwiKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3hizKF3hGdIG0Mbo+J42ZAOdpolRImjmWKH9M1BTQf4=;
 b=VqBSIp+0oFT+C5IkERAUG6QnoQG4GWFdyaQRqtWc2FNfb1y44eZ2ZHd1oOD+uqvpjw532/sGYpCsbExgdh3zjJykbz6SrJBIt4RT8Fu7dWajKp4BEjiQSSDXyFV4a7yY4oVLH08oToDzpqSiCDBeQcx4zUJC1/dNrkn4XNXvabY=
Received: from BN9P223CA0016.NAMP223.PROD.OUTLOOK.COM (2603:10b6:408:10b::21)
 by MW4PR12MB7381.namprd12.prod.outlook.com (2603:10b6:303:219::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17; Wed, 8 Mar
 2023 05:13:42 +0000
Received: from BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:10b:cafe::ae) by BN9P223CA0016.outlook.office365.com
 (2603:10b6:408:10b::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Wed, 8 Mar 2023 05:13:42 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT080.mail.protection.outlook.com (10.13.176.82) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:13:41 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:13:40 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH RFC v4 net-next 09/13] pds_core: add auxiliary_bus devices
Date:   Tue, 7 Mar 2023 21:13:06 -0800
Message-ID: <20230308051310.12544-10-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230308051310.12544-1-shannon.nelson@amd.com>
References: <20230308051310.12544-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT080:EE_|MW4PR12MB7381:EE_
X-MS-Office365-Filtering-Correlation-Id: d5c253eb-9282-45c5-6d83-08db1f93e248
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NebllhzXnSYrS2jCUeYXTUDSJDeuIfn/gJdVI+5zURtAU7Xys5OTKVPw2P4nbL4uanaVMtedrHLeZ2WcRtodApaybkBowwUAj+a70zvbgwFnIRRMiYRWOXdqwWVl43/+xjfvJMoPLrqRNf2adYVhUaakpDjvbu5iEXzAEnzyhJsvfno8j7ogawASy3wNpr8nwv0IhmYgGB1JGBG2AV80EzDPYPav4Y69zWBJCz7W0G//gpVaE2SlN+JgAhzUILFLWnu1hRiWMxRMNsvmV3YIh7ghEN3k+3qh1elN3j4p17kPzOP6+nZCvB+MxSGfXMKNeM40/BhrazRzdXtMADbEMep4vJe4hNsFjTP+Bf/Wig8N2PJZoGZbwy6Cpqi6ZlcbfZ/WiC/lRRcj1+kOMv55ejlawcwDqjqBVSPqnIdJDaBBrN4KM33bBW5eiYgPFp93bGT+/dGVx5u7a/R44II7ddiPqFrrlsN92wKix7sNbMnMCrHc37IkkDTCWz9VywHRQdsSWTikJveE6NGLhj1qnEvp31UHoQw/NTE/LGXNIpyKeEEFmpiUQxa2gv2A6GkW5yyxNaCumXsXdA5iAJBolgBJsIraF7NbABdFnCobGrA8hMvs6L+dmFFikA9xbtTHwKWxX7tTa8AhwXR6Bm3Keq4yQRZPDkc2RSmiKSOPd9AqtRJvJNpTVLEBerCqIiiFsXby6P1ZL7X5vFP9sEN1mj3Dtg+4e9w+V6/K6IjI0wWuYQjcR32rIBIEh6d3Obqa
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39860400002)(396003)(136003)(451199018)(36840700001)(40470700004)(46966006)(36860700001)(36756003)(82740400003)(83380400001)(47076005)(426003)(1076003)(186003)(41300700001)(26005)(16526019)(6666004)(2616005)(40460700003)(8936002)(70206006)(86362001)(70586007)(2906002)(8676002)(4326008)(5660300002)(44832011)(356005)(40480700001)(81166007)(316002)(54906003)(478600001)(110136005)(336012)(82310400005)(36900700001)(309714004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:13:41.9639
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: d5c253eb-9282-45c5-6d83-08db1f93e248
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT080.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7381
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An auxiliary_bus device is created for each VF at VF probe and destroyed
at VF remove.  The VFs are always removed on PF remove, so there should
be no issues with VFs trying to access missing PF structures.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile |   1 +
 drivers/net/ethernet/amd/pds_core/auxbus.c | 138 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/main.c   |  35 +++++-
 include/linux/pds/pds_auxbus.h             |  16 +++
 include/linux/pds/pds_core.h               |   7 ++
 5 files changed, 195 insertions(+), 2 deletions(-)
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
index 000000000000..535fee627874
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/auxbus.c
@@ -0,0 +1,138 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/pds/pds_core.h>
+#include <linux/pds/pds_adminq.h>
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
+		return NULL;
+
+	padev->vf = vf;
+	padev->pf = pf;
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
+	return NULL;
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
+	pf->vfs[vf->vf_id].vf = vf;
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
+		padev = pdsc_auxbus_dev_register(vf, pf, pf->viftype_status[vt].name);
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
+	pf->vfs[vf->vf_id].vf = NULL;
+
+out_unlock:
+	mutex_unlock(&pf->config_lock);
+	return err;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index db260fe149ff..1a81a6de1ece 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -196,15 +196,34 @@ static int pdsc_sriov_configure(struct pci_dev *pdev, int num_vfs)
 
 static int pdsc_init_vf(struct pdsc *pdsc)
 {
+	struct pdsc *pdsc_pf;
 	int err;
 
+	pdsc_pf = pdsc_get_pf_struct(pdsc->pdev);
+	if (IS_ERR_OR_NULL(pdsc_pf))
+		return PTR_ERR(pdsc_pf) ?: -1;
+
 	pdsc->vf_id = pci_iov_vf_id(pdsc->pdev);
 
 	err = pdsc_dl_register(pdsc);
 	if (err)
 		return err;
 
-	return 0;
+	err = pdsc_auxbus_dev_add_vf(pdsc, pdsc_pf);
+	if (err)
+		pdsc_dl_unregister(pdsc);
+
+	return err;
+}
+
+static void pdsc_del_vf(struct pdsc *pdsc)
+{
+	struct pdsc *pdsc_pf;
+
+	pdsc_pf = pdsc_get_pf_struct(pdsc->pdev);
+	if (IS_ERR(pdsc_pf))
+		return;
+	pdsc_auxbus_dev_del_vf(pdsc, pdsc_pf);
 }
 
 #define PDSC_WQ_NAME_LEN 24
@@ -355,7 +374,13 @@ static void pdsc_remove(struct pci_dev *pdev)
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
 
 		mutex_lock(&pdsc->config_lock);
@@ -395,6 +420,12 @@ static struct pci_driver pdsc_driver = {
 	.sriov_configure = pdsc_sriov_configure,
 };
 
+struct pdsc *pdsc_get_pf_struct(struct pci_dev *vf_pdev)
+{
+	return pci_iov_get_pf_drvdata(vf_pdev, &pdsc_driver);
+};
+EXPORT_SYMBOL_GPL(pdsc_get_pf_struct);
+
 static int __init pdsc_init_module(void)
 {
 	pdsc_debugfs_create();
diff --git a/include/linux/pds/pds_auxbus.h b/include/linux/pds/pds_auxbus.h
new file mode 100644
index 000000000000..30c643878a2b
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
+	struct pdsc *vf;
+	struct pdsc *pf;
+	u16 client_id;
+	void *priv;
+};
+#endif /* _PDSC_AUXBUS_H_ */
diff --git a/include/linux/pds/pds_core.h b/include/linux/pds/pds_core.h
index 7f59b3fbe451..e6d18f219033 100644
--- a/include/linux/pds/pds_core.h
+++ b/include/linux/pds/pds_core.h
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
@@ -238,6 +241,7 @@ static inline void pds_core_dbell_ring(u64 __iomem *db_page,
 	writeq(val, &db_page[qtype]);
 }
 
+struct pdsc *pdsc_get_pf_struct(struct pci_dev *vf_pdev);
 void pdsc_queue_health_check(struct pdsc *pdsc);
 void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
 
@@ -301,6 +305,9 @@ int pdsc_start(struct pdsc *pdsc);
 void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+int pdsc_auxbus_dev_add_vf(struct pdsc *pdsc_vf, struct pdsc *pdsc_pf);
+int pdsc_auxbus_dev_del_vf(struct pdsc *pdsc_vf, struct pdsc *pdsc_pf);
+
 void pdsc_process_adminq(struct pdsc_qcq *qcq);
 void pdsc_work_thread(struct work_struct *work);
 irqreturn_t pdsc_adminq_isr(int irq, void *data);
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 581266450B9
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:07:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229861AbiLGBH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiLGBH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:07:28 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2057.outbound.protection.outlook.com [40.107.92.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302954F198;
        Tue,  6 Dec 2022 17:07:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EN/5OpqOi5X0YkrJlszuROlrOE3ombCE4SAr9v/OoslyG7+WWxEMATIY7uroKgMK93cYM+Bx3uoBpfbXsEqAuI/DoeSBMbWVvh0fUw2j8ciyXucsqqMpPdm8qX6G5kmqmUIzwFutMKG8kUWS6IMcqNTeCpr7zj7PRzzgvwBr2mwEwvfzZ/rzrcyQZNuJorOmYkz9I0F1AAOHnXpdfef7jo7cDo01ZkF9tcLQ4uSMv82sv0TpzdZ9VWar59wA7oJt1fQrwh1gctSZDGlseTR4xy3ZBiq/Q5WG9e4VZONS60flbX0DIMgpM07S2/kZUbUMHXqPMAgWig3fejGtQDnlag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u+MjFcPPH7D9x2CdyTbnR3T+BkmiJjgn8Sy3DohSJJM=;
 b=R114gO67XCSirAzn6+yuTCPfnLi/Rqh7aFFpBomkKpz8hsXjHy0P5b5UnL+OOElwCUvne3Cu0edrye4jEiP366Ug81bgiLkEVm9Tm3p/s09EMWtWe4q3UoC/uxz4b59W8bH4o4Q3O8l//wLhrrI8ja7FBXbJTKNvm7Tc/D+AYNEPcg7N7u8ooNnHFG7a8oS2atPHf8PXH2NXJm2DQDLvIOVF9j8cAaLM4QxaCjpOLJv7dAH53owvPYLcmN8CHdEk82+z2D3T2hBaPYvObNMRvP0PIWYzzMlKyY3m8PxaHemphenNZ4lD1DAToYFF0GnaiHGhHKwC66F3MA0rRSLmZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u+MjFcPPH7D9x2CdyTbnR3T+BkmiJjgn8Sy3DohSJJM=;
 b=haNkZtstbJPts5BbPgcBjfmWsQYdHsETCSRLjAEQfnRAwmh9izDDQslKBWX/cOvKHk8DeAs5YLV/pGtdTaZkM/tI0mH8+w/zFdVziPKcOo/j8N+kDRPtLPBoXTAq+c2mNTUDqZVPqXMsTLGuAL9wJabJ6YTryPmJf58E7duGlNY=
Received: from MW4PR04CA0388.namprd04.prod.outlook.com (2603:10b6:303:81::33)
 by CY8PR12MB8338.namprd12.prod.outlook.com (2603:10b6:930:7b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 01:07:25 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::5e) by MW4PR04CA0388.outlook.office365.com
 (2603:10b6:303:81::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 01:07:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 01:07:25 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 19:07:23 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [RFC PATCH vfio 1/7] vfio/pds: Initial support for pds_vfio VFIO driver
Date:   Tue, 6 Dec 2022 17:06:59 -0800
Message-ID: <20221207010705.35128-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207010705.35128-1-brett.creeley@amd.com>
References: <20221207010705.35128-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT021:EE_|CY8PR12MB8338:EE_
X-MS-Office365-Filtering-Correlation-Id: 1ae61ab8-60b9-4d66-0d6f-08dad7ef6710
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uGVv+aLJWj4R42rDGY5yxvOFbkIjy+KSip26uSTWmnCub1wno3yCtY3Aalx9uE2m4ThpVQFc53EgxZKaJ3z4ECXHvPLK0uddHbf+t1T3ok8xgIQ7wvjSaytEPXZVmgt6vD6Leau3dC3AJtbfvqjtA2zRuSxoNmno3hdmOG/smH9Nu/pdKA/1883sfdlEA5MJH/DHPxgZpuWZJV6Jp6w8HzpRAneP99IoJouhE2965ia5ITh0TRDfif/skuoWYjhUZkGT8ug/hHCJ9fIMhoBdBtzrRYPFCufQkSl8Lh5/6ymv4q1AIaXzy5rcJ0Cv/7jT6DDbZXtAspP/Gc210fn4P3Q4lgtQ19IDKgBonVn2gvhQhVS2sUUf/9CbnAGUGka40rc8J3jq5AZMcr/qWS2G4UPv7XzIn3qQLp/H/shuzFHXQVybgT/Jg62IoTqIHBleEUob90mzaJfImCJl2NWFHTwzwLRxf+EX2zbhSx4gZElcJm5aNysLu5uCJiASaq+L2994rJLvS6tqu26rm5e6EG7g3waRZNZ0FoLcGOJ95ItRRtLtsXp9Glb/Zc3ViG29wpAryQdg9HVCP9uHQHEIh0wLnHbxNh5ojjgO3fDRASMOf3Gh7RjfRdJADQ91KwrBH40Smy1vJlAXAQRIi8eA6vWd+HDDuZhNQ1TCQpQ9F5aXbehUpArHkpovf+UPc8mHmMS6635EXlDTLn3Io6gXrUIm0p8vcuSaTs40O/3OI5M=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199015)(46966006)(40470700004)(36840700001)(36756003)(5660300002)(86362001)(356005)(81166007)(8936002)(44832011)(40460700003)(4326008)(41300700001)(2906002)(36860700001)(83380400001)(54906003)(316002)(70206006)(70586007)(2616005)(110136005)(82740400003)(40480700001)(82310400005)(8676002)(16526019)(478600001)(6666004)(426003)(47076005)(26005)(186003)(1076003)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 01:07:25.0888
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ae61ab8-60b9-4d66-0d6f-08dad7ef6710
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8338
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the initial framework for the new pds_vfio device driver. This
does the very basics of registering the PCI device 1dd8:1006 and
configuring as a VFIO PCI device.

With this change, the VF device can be bound to the pds_vfio driver on
the host and presented to the VM as an NVMe VF.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/Makefile   |   8 +++
 drivers/vfio/pci/pds/pci_drv.c  | 100 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.c |  74 +++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.h |  23 ++++++++
 include/linux/pds/pds_core_if.h |   1 +
 5 files changed, 206 insertions(+)
 create mode 100644 drivers/vfio/pci/pds/Makefile
 create mode 100644 drivers/vfio/pci/pds/pci_drv.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
new file mode 100644
index 000000000000..cd012648a655
--- /dev/null
+++ b/drivers/vfio/pci/pds/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
+
+pds_vfio-y := \
+	pci_drv.o	\
+	vfio_dev.o
+
+
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
new file mode 100644
index 000000000000..9a601194201d
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -0,0 +1,100 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/module.h>
+#include <linux/pci.h>
+#include <linux/types.h>
+#include <linux/vfio.h>
+
+#include <linux/pds/pds_core_if.h>
+
+#include "vfio_dev.h"
+
+#define PDS_VFIO_DRV_NAME		"pds_vfio"
+#define PDS_VFIO_DRV_DESCRIPTION	"Pensando VFIO Device Driver"
+#define PCI_VENDOR_ID_PENSANDO		0x1dd8
+
+static int
+pds_vfio_pci_probe(struct pci_dev *pdev,
+		   const struct pci_device_id *id)
+{
+	struct pds_vfio_pci_device *pds_vfio;
+	int err;
+
+	pds_vfio = vfio_alloc_device(pds_vfio_pci_device, vfio_coredev.vdev,
+				     &pdev->dev,  pds_vfio_ops_info());
+	if (IS_ERR(pds_vfio))
+		return PTR_ERR(pds_vfio);
+
+	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
+	pds_vfio->pdev = pdev;
+
+	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
+	if (err)
+		goto out_put_vdev;
+
+	return 0;
+
+out_put_vdev:
+	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
+	return err;
+}
+
+static void
+pds_vfio_pci_remove(struct pci_dev *pdev)
+{
+	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
+
+	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
+	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
+}
+
+static const struct pci_device_id
+pds_vfio_pci_table[] = {
+	{
+		.class = PCI_CLASS_STORAGE_EXPRESS,
+		.class_mask = 0xffffff,
+		.vendor = PCI_VENDOR_ID_PENSANDO,
+		.device = PCI_DEVICE_ID_PENSANDO_NVME_VF,
+		.subvendor = PCI_ANY_ID,
+		.subdevice = PCI_ANY_ID,
+		.override_only = PCI_ID_F_VFIO_DRIVER_OVERRIDE,
+	},
+	{ 0, }
+};
+MODULE_DEVICE_TABLE(pci, pds_vfio_pci_table);
+
+static struct pci_driver
+pds_vfio_pci_driver = {
+	.name = PDS_VFIO_DRV_NAME,
+	.id_table = pds_vfio_pci_table,
+	.probe = pds_vfio_pci_probe,
+	.remove = pds_vfio_pci_remove,
+	.driver_managed_dma = true,
+};
+
+static void __exit
+pds_vfio_pci_cleanup(void)
+{
+	pci_unregister_driver(&pds_vfio_pci_driver);
+}
+module_exit(pds_vfio_pci_cleanup);
+
+static int __init
+pds_vfio_pci_init(void)
+{
+	int err;
+
+	err = pci_register_driver(&pds_vfio_pci_driver);
+	if (err) {
+		pr_err("pci driver register failed: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+module_init(pds_vfio_pci_init);
+
+MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
+MODULE_AUTHOR("Pensando Systems, Inc");
+MODULE_LICENSE("GPL");
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
new file mode 100644
index 000000000000..f8f4006c0915
--- /dev/null
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
+
+#include "vfio_dev.h"
+
+struct pds_vfio_pci_device *
+pds_vfio_pci_drvdata(struct pci_dev *pdev)
+{
+	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
+
+	return container_of(core_device, struct pds_vfio_pci_device,
+			    vfio_coredev);
+}
+
+static int
+pds_vfio_init_device(struct vfio_device *vdev)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+	struct pci_dev *pdev = to_pci_dev(vdev->dev);
+	int err;
+
+	err = vfio_pci_core_init_dev(vdev);
+	if (err)
+		return err;
+
+	pds_vfio->vf_id = pci_iov_vf_id(pdev);
+	pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
+
+	return 0;
+}
+
+static int
+pds_vfio_open_device(struct vfio_device *vdev)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+	int err;
+
+	err = vfio_pci_core_enable(&pds_vfio->vfio_coredev);
+	if (err)
+		return err;
+
+	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
+
+	return 0;
+}
+
+static const struct vfio_device_ops
+pds_vfio_ops = {
+	.name = "pds-vfio",
+	.init = pds_vfio_init_device,
+	.release = vfio_pci_core_release_dev,
+	.open_device = pds_vfio_open_device,
+	.close_device = vfio_pci_core_close_device,
+	.ioctl = vfio_pci_core_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read = vfio_pci_core_read,
+	.write = vfio_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+};
+
+const struct vfio_device_ops *
+pds_vfio_ops_info(void)
+{
+	return &pds_vfio_ops;
+}
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
new file mode 100644
index 000000000000..289479a08dce
--- /dev/null
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -0,0 +1,23 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifndef _VFIO_DEV_H_
+#define _VFIO_DEV_H_
+
+#include <linux/pci.h>
+#include <linux/vfio_pci_core.h>
+
+struct pds_vfio_pci_device {
+	struct vfio_pci_core_device vfio_coredev;
+	struct pci_dev *pdev;
+
+	int vf_id;
+	int pci_id;
+};
+
+const struct vfio_device_ops *
+pds_vfio_ops_info(void);
+struct pds_vfio_pci_device *
+pds_vfio_pci_drvdata(struct pci_dev *pdev);
+
+#endif /* _VFIO_DEV_H_ */
diff --git a/include/linux/pds/pds_core_if.h b/include/linux/pds/pds_core_if.h
index 6e92697657e4..4362b94a7666 100644
--- a/include/linux/pds/pds_core_if.h
+++ b/include/linux/pds/pds_core_if.h
@@ -9,6 +9,7 @@
 #define PCI_VENDOR_ID_PENSANDO			0x1dd8
 #define PCI_DEVICE_ID_PENSANDO_CORE_PF		0x100c
 #define PCI_DEVICE_ID_PENSANDO_VDPA_VF          0x100b
+#define PCI_DEVICE_ID_PENSANDO_NVME_VF		0x1006
 
 #define PDS_CORE_BARS_MAX			4
 #define PDS_CORE_PCI_BAR_DBELL			1
-- 
2.17.1


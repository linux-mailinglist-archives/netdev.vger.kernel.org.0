Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C28876AFE4D
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:25:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbjCHFZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjCHFZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:25:24 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2046.outbound.protection.outlook.com [40.107.93.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD1B392BDE;
        Tue,  7 Mar 2023 21:25:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W9vMLl6eCEdg+z9pAltMpgE3RSEvyDgqxvIMIgdDvQBJe/1lPhVrE7pCskbxhC/KFJrTSpXqGuusiUuIcg+bVlos7i/e6oBVMpx9Z4GatO6D3zhGj9R0pXV3hBBGZeiB5t2J+TT8JLjZJ13hfYpIbYyqfvU47hZpPiyRiLpuZTuCcfX7ZH2Gx3Cq8O7umbyJcsCJdVT4HXH3fUMN3WvzJUjY1kLGeDTH93Yo7OUFETvXBcwi9lKzawkIkmUNafc52Ftb7J5TYr2AzIwAjKJ+YclPOnLgpLGARgAyS3RtFiX5Yi54Lu6o8bdJ3sIIdpYGXQgw2qN7v/hVcKjH8U3bNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iZ/eG4aTOjg76fRpnznw2pP/FWbjk5ZONqmqurYfl40=;
 b=kBFoZVzUN9lUylTwHxg6fW/wzB+n2uDFa4x0apxzNYQbLybrkGROpP8H7t6k5cLSUTX3ImRoXm+4UF5NRiIxRo6hzquZnmpXYy1/iyVBYt4mTcdrLY8GlaRwZww+GCSp3Xh1+/irx9j2LlxIe95UJuiovvDpp7/pFNWuS5gtS8aOOv+QJlWBvKq0fI66EIATA2kNhvFdRTIW5UQtV3wIj4QO2eIwH0UxYQ78S4lDD+LjlQ3Luv1N/m1yp4PtyZK+EdwQumJAigMRCy8OntcKTHx6WEGF5phxeuqWBscVK+8sDNvNDqihNS3nVz3xTG+kjjhHmcd/OJLU8MpPc5lm0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iZ/eG4aTOjg76fRpnznw2pP/FWbjk5ZONqmqurYfl40=;
 b=eG8VNbW3ZRdjJa3TMh4TkMPWVd77hgFciVewuS1O5giUD9vIOU+gFvhKfGXd00fBAzZhDQCoRBRTdIOA+nBEayQSpoIR69eHnI9IPGGSKFB8aagWEZ+yee7OnETUAwcvEEqJ0Wb5Lz5W65jCAlmDMVPjFQyIpAhrz6eIUIIX/ZI=
Received: from BN9PR03CA0216.namprd03.prod.outlook.com (2603:10b6:408:f8::11)
 by BL1PR12MB5849.namprd12.prod.outlook.com (2603:10b6:208:384::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 05:25:08 +0000
Received: from BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f8:cafe::ef) by BN9PR03CA0216.outlook.office365.com
 (2603:10b6:408:f8::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Wed, 8 Mar 2023 05:25:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT011.mail.protection.outlook.com (10.13.176.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:25:08 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:25:06 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [RFC PATCH v4 2/7] vfio/pds: Initial support for pds_vfio VFIO driver
Date:   Tue, 7 Mar 2023 21:24:45 -0800
Message-ID: <20230308052450.13421-3-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230308052450.13421-1-brett.creeley@amd.com>
References: <20230308052450.13421-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT011:EE_|BL1PR12MB5849:EE_
X-MS-Office365-Filtering-Correlation-Id: 7bcf5814-89ff-41e9-904f-08db1f957b4e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: BZit3dBwxyrhGuSZaYvBgq4qcTFzEVIVxmqE4j0dbrFYaEwOV6TqCVXIl3BY154GW0TX5GS38vDFJ8wMoE45oKMSvmPFhU2+VSbc+Y3n2xuFjxhyzOguoF0erf8b4pRioHuOV3BsSF2PtmJMPFUmiY3gnZLvQ21a9rj4UIF84bK5wg29h52yyjokF+eKNDA9fwTAS9NEUVS7WSxH2yKVznpAU7/9R0R3f5K9NmJwKN+Vp9T8qsYXG/Ln4CHYGSpfCwqz+qaJbbiiTHDukkDL+uPmhqBocmq6UQiprVD2PX3Uzb9bhzJ3X10lhM6ae2X8WDIeY/ar9T2w5XbUWJsPB0ickAtvym5+KykP52l1jUISzeD0AnQo4sz5DveRp7zhSYcbCPCzkyHUsdv5lTpillMZvaA04xDDzcEQlaatlwuOPqPeIf47eEOcB0D+3NyWcRsPSvgmcsEuYRdWB4svIOwXfGPerBERqIQe2mAA9Famqn/t2iFgGkkXsqSH0mDFfrpKiNJKFb7u5XkBBQIRnNlnORsjWXeEvJXPR0Zcgj+8JiyZCpyG8NFBXWA0MlFXxYYh408IsLqRAcO5V2bB308+U9uNNB7COOXi2hjT2iMfyH7V8/FEqTrQcBJIluqiV3CUEm21ZaZrKeJHw2+H8Z1vCwMutFGVC7hH9D0zg0CjGum50LuVOVq0LbygAhjdo1xHsTqD3At2S1LdJMk6T1jUqoZUTxlAqJEae0en8aM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(396003)(136003)(376002)(39860400002)(346002)(451199018)(36840700001)(40470700004)(46966006)(70586007)(70206006)(8676002)(4326008)(44832011)(2616005)(6666004)(426003)(36756003)(47076005)(5660300002)(356005)(316002)(83380400001)(82310400005)(110136005)(54906003)(86362001)(8936002)(478600001)(36860700001)(40460700003)(336012)(40480700001)(186003)(16526019)(2906002)(82740400003)(41300700001)(26005)(1076003)(81166007)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:25:08.1922
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7bcf5814-89ff-41e9-904f-08db1f957b4e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT011.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5849
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the initial framework for the new pds_vfio device driver. This
does the very basics of registering the PDS PCI device and configuring
it as a VFIO PCI device.

With this change, the VF device can be bound to the pds_vfio driver on
the host and presented to the VM as the VF's device type.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/Makefile       |  2 +
 drivers/vfio/pci/pds/Makefile   |  8 ++++
 drivers/vfio/pci/pds/pci_drv.c  | 74 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.c | 74 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.h | 21 ++++++++++
 5 files changed, 179 insertions(+)
 create mode 100644 drivers/vfio/pci/pds/Makefile
 create mode 100644 drivers/vfio/pci/pds/pci_drv.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.h

diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 24c524224da5..45167be462d8 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -11,3 +11,5 @@ obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
 obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
 
 obj-$(CONFIG_HISI_ACC_VFIO_PCI) += hisilicon/
+
+obj-$(CONFIG_PDS_VFIO_PCI) += pds/
diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
new file mode 100644
index 000000000000..e1a55ae0f079
--- /dev/null
+++ b/drivers/vfio/pci/pds/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Advanced Micro Devices, Inc.
+
+obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
+
+pds_vfio-y := \
+	pci_drv.o	\
+	vfio_dev.o
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
new file mode 100644
index 000000000000..5e554420792e
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
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
+#define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
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
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_PENSANDO, 0x1003) }, /* Ethernet VF */
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
+module_pci_driver(pds_vfio_pci_driver);
+
+MODULE_DESCRIPTION(PDS_VFIO_DRV_DESCRIPTION);
+MODULE_AUTHOR("Advanced Micro Devices, Inc.");
+MODULE_LICENSE("GPL");
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
new file mode 100644
index 000000000000..f1221f14e4f6
--- /dev/null
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -0,0 +1,74 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
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
index 000000000000..d9f0203c1649
--- /dev/null
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -0,0 +1,21 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
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
+const struct vfio_device_ops *pds_vfio_ops_info(void);
+struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
+
+#endif /* _VFIO_DEV_H_ */
-- 
2.17.1


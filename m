Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2771C69BF22
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 09:39:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjBSIje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 03:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjBSIjd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 03:39:33 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2086.outbound.protection.outlook.com [40.107.93.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C584FE061;
        Sun, 19 Feb 2023 00:39:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e97puKAc8+/bXOBYXPjggNU2QBvnjeZHDafSe1VRMjzwVEXMoe2pcLY0qlEa5xIV3XPGr1XEfW97Y8W0rgtRD2AsVbEicC4iBbCyZ/0zAK1bVu8RDpLDSUlx1FZg3kmu6H4suLa9dcaqk5HMbMY2qSnv3lxJn5ONS7FhvRrBOcLkf0wp42nbkW4LnfVZunq/LqNNHIatP43QiGW+YRwnxuRxnWEaov5qTkPOgdV86dBgwyqM3+bFLMZ9qzHDwfA4oIggrVyFiWc5Ze6cWbvev4Ww3CgD0IE2VyhDKxSqTJulNloS85cWsyx8+vYwarpmIfJvSob65OwtBLCUGDkIxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qtT1WE3KlJpxveho+U9/cEr8uZ0TuKuR0LbRAnDyd4w=;
 b=CSzVRInRy3EaB7w6nXqj6m13jpZfgo7xX1wXS3C2qh/rpy8lRHdNDEbLBr72kL44GtJju1XZObgUZjfUNw3miMRfCn2WI9T51G6vDzdNHEsXhoj2cDSaqMJ61/GBf1vDRpADpMv66yLXg+jNjLOMoejRU1pmjZhXBK4eG5hD5VUbEy/KWAiPFCZqYAcHDh/ccn3LUIa/6HDgFqxyBTjM6LdAzzGK7RvijEVSLHb3f7a0szrjtl5ZcW0lRCt7X2Np07Fe5wplxpJqoEgXHATNMy+OHlJ2AcBiHWBDwCiWcAMpis9ERlLXkEixrAf0CtiUrdoXjonKvxACARt4sNsP8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qtT1WE3KlJpxveho+U9/cEr8uZ0TuKuR0LbRAnDyd4w=;
 b=LiXeWEHLwQ9gNXJRRBW6f44w46LieOcuKo/inmfZdpSegIj+ysE5NR1wAFt4/r4iaC/vKG5uj74v0sc0qzmxf6apPicCfOB/IC6hPuQZi4qRZtNXv1WzuehD8+yozJjIHBBAO1+zBD8oodZyLkkahU/Fqdoa6EkIgRBAi+oAFtM=
Received: from MW4PR04CA0382.namprd04.prod.outlook.com (2603:10b6:303:81::27)
 by DM4PR12MB5771.namprd12.prod.outlook.com (2603:10b6:8:62::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 08:39:29 +0000
Received: from CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:81:cafe::6e) by MW4PR04CA0382.outlook.office365.com
 (2603:10b6:303:81::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18 via Frontend
 Transport; Sun, 19 Feb 2023 08:39:29 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT096.mail.protection.outlook.com (10.13.175.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.18 via Frontend Transport; Sun, 19 Feb 2023 08:39:29 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 19 Feb
 2023 02:39:27 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        <brett.creeley@amd.com>
Subject: [PATCH v3 1/7] vfio/pds: Initial support for pds_vfio VFIO driver
Date:   Sun, 19 Feb 2023 00:39:02 -0800
Message-ID: <20230219083908.40013-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230219083908.40013-1-brett.creeley@amd.com>
References: <20230219083908.40013-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT096:EE_|DM4PR12MB5771:EE_
X-MS-Office365-Filtering-Correlation-Id: 15be097b-5a86-4a3f-7987-08db1254d10a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +86Cb2jUkxZ6Hp/wHyc8HhcfriUVaS9W7nGV0rBnT21bKgQuqo6zI4m4fbe/W7roSOeG0/QXzkSUaGVcohVNnEnn7Km8AR7Bk2JkoiKFjEbBoyun9wJBtIlK5ZcofqZqQNM5qLX8Tspsq5lOr3Mut7NqrBriDkcpdtncpNwZRL515qOwtVpDFPw8kQnq5USZird1ltDC1NwAd/8pf81hvYpCLGu1zKhcHN/9fS8o0CeC+KGZtyLgyv4JOZPD0PuFaX2xzUbSNNABFaSqQN7717yw06DAtLqhzfc8AfMcUCOdn0Vmfi8xJy+BfxIFAFPgLsi9QHPcL8QeDGKesV+g79Duod+bpNc7j7Gn2bMV8eiPbUmCEMiM9B4pJucLXtaJHQyvSpURvSolQI75UPWJYgIYRC4/Gjl7H5u/gr0tyZEis6ubDTBSQmepafLikSE06onhq/OZJlEauLEwMSOaiPtipGehSJfLhr72F47U6fn59yothhCufhx2rE8+i4VZ3tLPpBVmAVr76JOON5ymMPCOYaDxIel2e+UtXsGLRfGM1PQzxM7rssbkxvEcyTUa3W1eYaYsk7OIYx8ajZ2az91dv6+15E042YLCFMsTEz/jhMEP47WJO9j9daxnHnYKNttC95RUqWQVrdOZ1e2YV5OKhHAAZ3hYp+b2dMbEirucRD1TvVZ4Z+25g/b+cWckSoYvWVHZw97kGdvzi0d+I7mUTYFY+XorNeRWAF3UzL0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(396003)(346002)(376002)(451199018)(46966006)(40470700004)(36840700001)(40460700003)(82310400005)(81166007)(356005)(16526019)(2616005)(6666004)(336012)(186003)(26005)(36860700001)(426003)(40480700001)(83380400001)(47076005)(41300700001)(8936002)(70586007)(70206006)(2906002)(44832011)(5660300002)(4326008)(8676002)(36756003)(316002)(82740400003)(86362001)(1076003)(110136005)(54906003)(478600001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 08:39:29.4703
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 15be097b-5a86-4a3f-7987-08db1254d10a
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5771
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is the initial framework for the new pds_vfio device driver. This
does the very basics of registering any PDS PCI device and configuring
as a VFIO PCI device.

With this change, the VF device can be bound to the pds_vfio driver on
the host and presented to the VM as the VF's device type.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/Makefile   |  8 +++
 drivers/vfio/pci/pds/pci_drv.c  | 94 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.c | 74 ++++++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.h | 23 ++++++++
 4 files changed, 199 insertions(+)
 create mode 100644 drivers/vfio/pci/pds/Makefile
 create mode 100644 drivers/vfio/pci/pds/pci_drv.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.h

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
index 000000000000..96e155598a50
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -0,0 +1,94 @@
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
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_PENSANDO, PCI_ANY_ID) },
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
index 000000000000..4d497695c4e9
--- /dev/null
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -0,0 +1,23 @@
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
+const struct vfio_device_ops *
+pds_vfio_ops_info(void);
+struct pds_vfio_pci_device *
+pds_vfio_pci_drvdata(struct pci_dev *pdev);
+
+#endif /* _VFIO_DEV_H_ */
-- 
2.17.1


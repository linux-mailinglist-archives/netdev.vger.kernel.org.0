Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B3AD6EB698
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 03:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234113AbjDVBHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 21:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233915AbjDVBHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 21:07:15 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2044.outbound.protection.outlook.com [40.107.237.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28DEF1727;
        Fri, 21 Apr 2023 18:07:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bEfdDEHhrlTrYvp0yYse/MDeRt+k7TFmdyayhppvlSWdqSCeVla+U32R3FUjMujSrUFWmiLABDqv8isKdiznmKaRUnax1V0J67LjS+shQFWrEFRm5FWIs+3+ozsQQvXiM5VbdXgZl1MNJTxnF89dxfZkYJQC1uDEsSUl6qzGJzj7+WuNhH8NksmTotqMLLQf3Za5Jxqolrs+9oXbFB+obLZP/MTsj9YL5UkVnrG6gXt9bGG5feUWBtqwmnxtzN7WrO6zjWTZpGwlJeJGmc1Rn/zSn6NIVh6+4E9sr/UdWeV2QJ/YSVuBF+G4WyAj8Y8XoZvBZguphPOGT63b75hExQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wkw3Y/dalVq9PbonM9EQsefpr/ggrfIAEWPLjJvPV4Y=;
 b=AA2UOOS9ysWsOAia3EaVj6U1rGoh8YjfpjllwRhcN1zvgMU7xlP1wXlQuSpHKWPN+lXIK4CplwmRYKp3QTRXsK6eDxFkTvNaKJC1u27KRMuFId/0KNdsVTWo8K+BfOJ4sAzrfaX/9Wc8uT/LHRFIGeTFqKmGI5CT0WMfnCYFmt1zHxZfmF4OUOHbSSSOGaFvSXM/P2RCnZAhgZWC14mggcpuY26pxbUghUzmxOVmyRT/fwl6WYBcpEIk2aQ0xh4TSZV55DZuEV4VC+QUbol3Yf8OmKmVvSH00YtuAiPkR99kNpR/iC0mIyX4cNKYZgFmzJ3tKEb2Ul+vJXyRCsNivg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wkw3Y/dalVq9PbonM9EQsefpr/ggrfIAEWPLjJvPV4Y=;
 b=wUKK5BJuMz4tvc11QQ6BF8DLR3rMV65csuqks0UxaPgOp9Xq2h8RcMSCQEpShLBkKRX9PA9OJUqnzlU/JHqCyN1JrAZPnbnwdoc+0yJKeN1qsv2HNMWGszbejlnemYm2olxbhsR34L3DDw4sMlxQjsoSTdRUzABwAOHHHVGwqpQ=
Received: from BN8PR03CA0025.namprd03.prod.outlook.com (2603:10b6:408:94::38)
 by SA1PR12MB8967.namprd12.prod.outlook.com (2603:10b6:806:38b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sat, 22 Apr
 2023 01:07:11 +0000
Received: from BN8NAM11FT099.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:94:cafe::e0) by BN8PR03CA0025.outlook.office365.com
 (2603:10b6:408:94::38) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Sat, 22 Apr 2023 01:07:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT099.mail.protection.outlook.com (10.13.177.197) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Sat, 22 Apr 2023 01:07:10 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 20:07:08 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [PATCH v9 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO driver
Date:   Fri, 21 Apr 2023 18:06:37 -0700
Message-ID: <20230422010642.60720-3-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230422010642.60720-1-brett.creeley@amd.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT099:EE_|SA1PR12MB8967:EE_
X-MS-Office365-Filtering-Correlation-Id: 66f55d3e-6d53-4e5c-f2d2-08db42cde676
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RSu6sx07JnA2sxciiK8UdJdvjPfpDNaPnZwrwI9vYQY/cFzM1dEjSZkYzywoavEfePTpl9pQ04eoyCXKY1qwvVkEFPh43IW178/N8iWs20KH8WH94dxr4qNHQUNbCiaKnhpxzyZhA+fcKmE1yfPMij3P+A4D+6jA4T/WhbmaiWigxr+0Qzps3o43fybQ0UqHXd2r6m2+iG7Z1GouiFLH+8lm7XKphTvT0/XAgB6KNIVeJefcUuZjYPr7A/w4PGTMpU0Y+sWigA0htDQ5FD8ymK5l+pNIGhH3EdR1+g0/opSP0K0pUduxkLAmzHygaxITNVvJMjOHj95X4goP5ARsRAW2Ek4ov5LXsA9chNXwYifO3MxPlgZEKxmBOHC4GaoBoMXGxT6pNzyW26KQ5KWQeW3gWTT2UgnXCCP6nWIFNlbLj99jYKjvPTlGI68DUfAZP8dIjblhoW5bSMxRJ+7GciLb39Z+Ew61BmDbMfDeGEUmgA/KeTfrnmD8GCCUYp/mpThu6y44ESV7JEpdcl7kTgrxQrqllnuqWiF//kT72VtbDRoV4NVTTirtLqDQ1AtNGvTG0KwGDYhCTeaKp7Ae7eeW3RC9xAUtXVlxbNwrVkKgn8Nk0MwK41+5HVt9uCLmbA3xfAQMJ15aSvb1VuLjPi2dwnIhk7LReu2LpsYx8JXzwc8jXjk2oUm999W+rHqlm4Q535h+UNQdRykl561WT4u9CP+nbf1riO/kc+BY25g=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(396003)(39860400002)(451199021)(46966006)(40470700004)(36840700001)(316002)(110136005)(54906003)(70206006)(70586007)(4326008)(16526019)(1076003)(40460700003)(26005)(47076005)(186003)(36860700001)(336012)(426003)(2616005)(83380400001)(40480700001)(82310400005)(41300700001)(5660300002)(8676002)(8936002)(478600001)(6666004)(86362001)(82740400003)(36756003)(81166007)(2906002)(44832011)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 01:07:10.4872
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 66f55d3e-6d53-4e5c-f2d2-08db42cde676
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT099.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8967
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
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
 drivers/vfio/pci/pds/pci_drv.c  | 72 ++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.c | 77 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.h | 20 +++++++++
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
index 000000000000..3856a4e78c8d
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -0,0 +1,72 @@
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
+	.name = KBUILD_MODNAME,
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
index 000000000000..0f70efec01e1
--- /dev/null
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -0,0 +1,77 @@
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
+	.bind_iommufd = vfio_iommufd_physical_bind,
+	.unbind_iommufd = vfio_iommufd_physical_unbind,
+	.attach_ioas = vfio_iommufd_physical_attach_ioas,
+};
+
+const struct vfio_device_ops *
+pds_vfio_ops_info(void)
+{
+	return &pds_vfio_ops;
+}
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
new file mode 100644
index 000000000000..66cfcab5b5bf
--- /dev/null
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -0,0 +1,20 @@
+/* SPDX-License-Identifier: GPL-2.0 */
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


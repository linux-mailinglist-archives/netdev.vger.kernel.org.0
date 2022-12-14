Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8E7564D34A
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbiLNXX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbiLNXWz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:22:55 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2063.outbound.protection.outlook.com [40.107.244.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14B0B528B8;
        Wed, 14 Dec 2022 15:21:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eB1xOjSSM+vjCZbvLXCljR4wXX9WUalSYbdGRkwvEJ9JwV48arM/2QLPS/O+gk6zQO48aCiI5h8tfeHJJDjW2r3sSK0lb2DbnRZfKHcgo+JEZPrGWSvG81JtS57wmRGjtTmeUhOz1murgRfwFFsIXUUICYlJzgWEXIMGjLoYYMFyzOq07fzt76sH1dZ4akub0Ssou7zVMtfHDzyBEKnzAI1tOksbpOCDV2nmKexC49AFQC03+5XNmB+QoUuChihNTfhutuRSjIZLLmycN2vlHRFGs+IoNGpUtN4GQ/sfXHfVZ2W9JXaUMz65ozi+cecpXEXqiQ4y7OC5wCN/ufSlog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UfkRcRmQorOe2Uv4FbiZ+lbSjqaDBqEieiUvJLpyZk0=;
 b=WN+M3rnIlXneYlj6b1MtJHU0ZHZq8z7PYCklJvO8JyKmw5XL1kfFUCY7U+sNbkNT6xOT6fKEaQERqDd/JIYaqD3o54wYy+A127EU6AVuSyjUBVqCdP0YkhMBn3qIe5bmxhjNFly3Nrgz/3ZBVtdFl8e+XNrWFNfwrYAZYZGw1s3az0C8PW0pDuB3QD7kQULJQt/L7JOeIVbK6p436BYkOt5iB4BfSy5d7QLI4L1a3Ry/t5YlBh2WVi9aWRC5CM5JXleTs2qAeNXHCELqFH0PlmL35vPr84k0bALx5MtrE5ZChAIdNol45czPkSlSScWzu6aGqmfBCUinY0rGmMAJQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UfkRcRmQorOe2Uv4FbiZ+lbSjqaDBqEieiUvJLpyZk0=;
 b=fBpWoweseV0Ho6HTheJtHcNNz6BHC2fIuJiUVncEjlt43m5znV4OdYXZ5V7o7gNSj3zfPtHjw0mOzQ6HxiWuM3eyzePHKfIZfCWV4AWmFlCGdJsKzMJIP4tMna3DTqUiaQf4QMid3o5upCNkLFGbT1ICFd6IaSQD6eLJL6/v014=
Received: from BN9PR03CA0638.namprd03.prod.outlook.com (2603:10b6:408:13b::13)
 by MW4PR12MB6973.namprd12.prod.outlook.com (2603:10b6:303:20a::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11; Wed, 14 Dec
 2022 23:21:55 +0000
Received: from BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:13b:cafe::ad) by BN9PR03CA0638.outlook.office365.com
 (2603:10b6:408:13b::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.11 via Frontend
 Transport; Wed, 14 Dec 2022 23:21:55 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT009.mail.protection.outlook.com (10.13.176.65) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5924.12 via Frontend Transport; Wed, 14 Dec 2022 23:21:55 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 14 Dec
 2022 17:21:53 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [RFC PATCH v2 vfio 1/7] vfio/pds: Initial support for pds_vfio VFIO driver
Date:   Wed, 14 Dec 2022 15:21:30 -0800
Message-ID: <20221214232136.64220-2-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221214232136.64220-1-brett.creeley@amd.com>
References: <20221214232136.64220-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT009:EE_|MW4PR12MB6973:EE_
X-MS-Office365-Filtering-Correlation-Id: 80790a4a-f6d0-4df5-70a0-08dade29fd64
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: miu6K7KrhI8XMtz4PWyRdlMIGY/6M+l1THJUlysSoY22s2t9PrU05Y8pEAR5XdHzUp+ucywPrzdK3bmx1nydroOSHolsCUgUng4dn+puNSfmzQ00N1zzKn2AjtDhIBfY8PXL9YHozbA/p235BmOoPmq4rNPzJx3AJLdGZgPyrxQ03PcZTJnpv187vkPWVCXuCDwmMmROiZESR7GArxesXxT5iZ8LGjn+5dGWUQ4WlNZfdCWpR1e/LufcJ0/QSnKHIxHg9BjRG50pIBL5k3xrqVgcLyLVuVHwQfAsdKA/+bFwYmjK/mQNresnBl5ETYWtdb0RA80MD1C66QZM36YQrPvSZEKsP9Hu1HR6ai3aMDE+KZ5nT3XTTqU1jnMJyiXtKwLGLIy3OXphNWSAGWF4TbbeXEuqQ0UY9UqJqXMfoOSt59PhPun07zwpnlLU+3aFr6p8ia6zZtMogKZlH8WKQAChQSHijWk2UMRpMN1kpGK0NCPSeZUFYzDAzgsnXQvMIloU+7EgXMo/ascduXsRt5jroDDYOO9NaHf+4SjRL9Vpj320gC/TZyIHmmWyiqX8BBtG0kubG5RMccWBwIcxCPt3RdOZvuk6WygcAAFuIZXDO8GIC7vZxVBPFnVQrzh2CntnO+u72IoYnDaHT/F0X9N5nVvTLTAAtAaPFelzI29g7PKnHsZbL5EJf9PmHn7MelsDpE7xn+I9yzPyIzUtrm9Y4qc4uTsc6c26+mbB4Qo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:CA;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(346002)(136003)(396003)(451199015)(46966006)(36840700001)(40470700004)(54906003)(110136005)(478600001)(70586007)(2616005)(26005)(186003)(70206006)(4326008)(16526019)(8676002)(47076005)(336012)(1076003)(41300700001)(426003)(8936002)(5660300002)(83380400001)(2906002)(36860700001)(44832011)(36756003)(356005)(40460700003)(81166007)(82740400003)(6666004)(82310400005)(316002)(86362001)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Dec 2022 23:21:55.2121
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 80790a4a-f6d0-4df5-70a0-08dade29fd64
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT009.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB6973
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
 drivers/vfio/pci/pds/Makefile   |   6 ++
 drivers/vfio/pci/pds/pci_drv.c  | 102 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.c |  74 +++++++++++++++++++++++
 drivers/vfio/pci/pds/vfio_dev.h |  23 +++++++
 include/linux/pds/pds_core_if.h |   1 +
 5 files changed, 206 insertions(+)
 create mode 100644 drivers/vfio/pci/pds/Makefile
 create mode 100644 drivers/vfio/pci/pds/pci_drv.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.c
 create mode 100644 drivers/vfio/pci/pds/vfio_dev.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
new file mode 100644
index 000000000000..dcc8f6beffe2
--- /dev/null
+++ b/drivers/vfio/pci/pds/Makefile
@@ -0,0 +1,6 @@
+# SPDX-License-Identifier: GPL-2.0
+obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
+
+pds_vfio-y := \
+	pci_drv.o	\
+	vfio_dev.o
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
new file mode 100644
index 000000000000..09cab0dbb0e9
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -0,0 +1,102 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
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


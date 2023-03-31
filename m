Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C05EA6D142A
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:36:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbjCaAgj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:36:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbjCaAgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:36:37 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on20611.outbound.protection.outlook.com [IPv6:2a01:111:f400:7eaa::611])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C940C11149;
        Thu, 30 Mar 2023 17:36:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ccaMqxoJSnbak6k/SOVVR7675FyhcuuyzzNWcF7Rr1IhHOomjfesoKKV8MAgJsFWmjRMmth5foxkTtRwd94zANHlkTITQRVR0F5ucb5E7v/Ja9zGTB3eDVzecRm9WFPNvc5jXag6t6eE/vDex1J2pHc0cdeWHvJqiYX3XRBQua7kXLpcWfX2QIxPOB15/o8xkEHaU1SeOmFRnVKV65YLA7ORHjtK7qUTpbygF+UJCLphwtB2YlAQtBc7nEUsJtoRdBQ14kMWEegPSY+Y5/uf3Ovc5XGgw8lrNMjejXzQ9wwbltcno2ktpxqbwrK2zhegFiT9eaP6L8f5rQWuQsbOrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzK/w1vd6Li0LQY7LTuCkLfGsx3aHDUf3UGs6gH2I8U=;
 b=bZzFsmk39zLp7qpCQYdmwEhIx1PzjduiUExrwHmdWOf+pz65K/BJDHUyNgqtVmKu/5ZHgXJQvSVQnqJy2icJaRHX4UhfZEZJnRdl7GnuiaCMAQ2+IT58HFhx7sXTevEYeF/SfW3BLj060Y6P52q+lBMcQz2fUKLO/oM2pL6lZ2IXJEt2xYGKOX0uAbk+bsg0WWyAreRqIF9UFJalLdWINfi0TQNQrcW9fWsg0+Kpguh7lUgzIFUc3UeFTPKILFXrTw3hu/gQqPAtlvFW9l9jsThWtJXbygzi1mPXYfZcbirG4bnyBJS73HgPZ9fcxSqMcKA5NFM8Gni4nwDufCEFow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzK/w1vd6Li0LQY7LTuCkLfGsx3aHDUf3UGs6gH2I8U=;
 b=POcRySQ4cZBKu28NInjYeeEwQlOdym4Uo/bu79xw/h+cnlJ6p6aCGdX/ThnlfUDHAOIiY5DHeZqEk+CTqezL6zZyF8eesIR/cgeTt7RPg7SAYKzFC+W5CD+NtsAulpCIdZilREb41iebXKgjbwNbC/81aqWbCHbzu5JEw7tuD38=
Received: from DM6PR11CA0017.namprd11.prod.outlook.com (2603:10b6:5:190::30)
 by LV2PR12MB5726.namprd12.prod.outlook.com (2603:10b6:408:17e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 00:36:28 +0000
Received: from DS1PEPF0000E654.namprd02.prod.outlook.com
 (2603:10b6:5:190:cafe::52) by DM6PR11CA0017.outlook.office365.com
 (2603:10b6:5:190::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.20 via Frontend
 Transport; Fri, 31 Mar 2023 00:36:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E654.mail.protection.outlook.com (10.167.18.10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Fri, 31 Mar 2023 00:36:28 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 19:36:26 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: [PATCH v7 vfio 2/7] vfio/pds: Initial support for pds_vfio VFIO driver
Date:   Thu, 30 Mar 2023 17:36:07 -0700
Message-ID: <20230331003612.17569-3-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230331003612.17569-1-brett.creeley@amd.com>
References: <20230331003612.17569-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E654:EE_|LV2PR12MB5726:EE_
X-MS-Office365-Filtering-Correlation-Id: 8c2f59ec-bbb6-47e4-89da-08db317ff764
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IrXRrDJNoKjYDEAF/vE79hCBDe4wM+O7jJv1hPb2kr0SHrPVHrj6HDPmK1R4/zOQy8Y/sQbwvtkJYg6oXeVq2rsvHUoSkQc19sriXK/V5eHgwOI0MJ5f3pZYvurgIYSVS6Y+oD2Rv+xA079g5GNhF1Ii6VQM0Pa4C3CB6CHAeULXNTE2UjL87kqshWeXrgu8PABuJUeAueyQz2HktqmezZWCphM/pZKiF1AkZO85OsnP6+0cDYLbmyiFLSDr4zK5m8NML41cwKeFAY0MWgGjAXb8fL3fQ7APBTJynt7t5UyIvnnhwOn6G6KmGlgfrqxIUzTkRxd6Dx2yCW5AG1N9ImDX+7Ij0JR6ART/dClxwIl8/9A0o9Ho8eN34QNZ2BMnJFd3UOc8KGKGj6EYXraZ0RU03nviYutZ6kK2r/CtVitCSyd+MdhtoqTkflYscQDeNfpwGvVo0Z/JMHdH1Li4VpWTsujToOWaFEAjZN3UaOk4zPSCTzLIcw1pC4YBrpPVPqR2OtPMsu+WHN7nxMgGSZvS9Z02EezXAOC/OPJ1RYURakR+Z8IxR25r8k5ksjNqUe+aW7B0DY6F9W7N3PhFGnPSGpPvBTClWO34Yc/EtQr1c+Tz2zE5CmrBlaWDbn/jqaOK3XB14EGymUddbLdtdAaqQkMdzCXeZqyJ2Nu1P7hCdLPdAEnNrFuDzEfSMIiewga7Ql5s8Pb1YSFpFqtYI7iKLDuR7CWdXXy/j9Io4as=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(396003)(136003)(376002)(451199021)(46966006)(36840700001)(40470700004)(36756003)(82310400005)(86362001)(2906002)(83380400001)(40480700001)(6666004)(2616005)(478600001)(47076005)(426003)(336012)(1076003)(26005)(16526019)(186003)(36860700001)(70586007)(70206006)(316002)(40460700003)(110136005)(4326008)(54906003)(81166007)(82740400003)(8936002)(356005)(41300700001)(8676002)(44832011)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 00:36:28.3444
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c2f59ec-bbb6-47e4-89da-08db317ff764
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E654.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR12MB5726
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 000000000000..a66f8069b88c
--- /dev/null
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -0,0 +1,21 @@
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9FC6EB692
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 03:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234125AbjDVBHY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 21:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234107AbjDVBHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 21:07:18 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2056.outbound.protection.outlook.com [40.107.92.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F14E51725;
        Fri, 21 Apr 2023 18:07:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TY5ypDxq5bbcfMr9nI8DMQVAf/3yAA/qrIUpgBb0yZlt8JZwIRrReLW0CSf4oIpezNoJIVeh+E8Kn7y70EALNe0SVVt4PXDdmcisGcFpScGX1thSy/9QHgkc1K4D8aECV+A549kUODMXJZlBf0Et4slgnBwH+iI9WkBErQ5My1A5pflUmYzoxZqylPq1ov4IQQp8OsDWWmjQ62nI+NmcFflJRTKU/52CtmwmJHR14kT/wej6D9KcbURbbSsTvnjGrxB0RYJcSn5qTkkeqby/j3xoPH0XjvMlGkg/m8/pZ9QBlzRZ25poAMdiDKjmSHLFlR4VhZdIbsHwB/2dwi8B/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3qghWjfthKkBM5V5uU4oyRi5Y0wIoOPp/olQE6Dg0wQ=;
 b=aeuUsLwLd03wzSeEk6KRLu+91sV6uMWuY/SDyFVDQdYnKog/9MjFw0cEohaPaQSRkU6FY6W/VPHxh42d9utISCdiilCz3+CxzUyf7seB2WO8WYqkn+130EsSN1507i2Qbkl5hb2vbNMz4s0ZAcrB62WpW3wlatz63OqAQytaGOv7qAGUiK+zJOofH/YXdwu7ofoSQAHilIlmsGNnScJ28gbjJhj6BItAliPNBYNgOnT3HdbaQOtAZO/4+XXnR1hfttyYxXZHdehsPoxvCs/M3ErqEwNdTmX8KH6MXyxdfUZL+GsiZUM+5Bz0tUUeRZQ5gLjhvSKUyRzlnE1AJM9Y4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3qghWjfthKkBM5V5uU4oyRi5Y0wIoOPp/olQE6Dg0wQ=;
 b=JvEJTUgZnbaEfTY1pnz4izOkgNZrYb+m3QktalEloyxePZRflbgl8e4BbcZEFiHUlSCbmMRvRinxKgqrDA0dh/kzXFnet7x9v5CwAAxO8bAt8RLNITFJAF8cg4+5Vr3dy3qV0rmEChZM0eY4bftHsE3QILXDfHxJpl3OsVCLyP8=
Received: from BN8PR04CA0043.namprd04.prod.outlook.com (2603:10b6:408:d4::17)
 by CH3PR12MB8330.namprd12.prod.outlook.com (2603:10b6:610:12c::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sat, 22 Apr
 2023 01:07:12 +0000
Received: from BN8NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:d4:cafe::ea) by BN8PR04CA0043.outlook.office365.com
 (2603:10b6:408:d4::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.27 via Frontend
 Transport; Sat, 22 Apr 2023 01:07:12 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT092.mail.protection.outlook.com (10.13.176.180) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Sat, 22 Apr 2023 01:07:12 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 20:07:11 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [PATCH v9 vfio 3/7] vfio/pds: register with the pds_core PF
Date:   Fri, 21 Apr 2023 18:06:38 -0700
Message-ID: <20230422010642.60720-4-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT092:EE_|CH3PR12MB8330:EE_
X-MS-Office365-Filtering-Correlation-Id: f521dd34-45a5-488b-5c3f-08db42cde7aa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jPNda+nTEmlR4RLdZNhQ84B/uXHtmvCD/FqMRt2N/XIIr5M0/snnAZr/Vsd5fDdx7PTY76SEAT40evamVOIJObUVi0UBAcLMy5cwHc3xcZChYmCO7Dq1kcE8PvlRmFAf/zlxz8tT465tsh9NO5V4gaJbPq82MQPphZnbdRySsY4ANky7xoBZmChUU3wYx98Z8knxZA7ynB8EfveRZ19dFS+fPUHOIaO9ljN+f55eGE/wRr4AEvvSLPKVVGofA9h+0JAV98Ln/kyuWfP/TZJvUjDz811JSqeauJa0Y92olwLhVYQWgpbwJSPODuOyUnhjGTOrLfDza9UXvPPYhVvcHtljQl4Pkonj2swQwM1fsjscapCkNSzPjelfBxRKdJnEG9bqlJv66eXjozuzYvl/bxfi3bXMRV3ry22k995e0nz4f6tefH7ttzyGWJ6dbbVtYhjYGYKPz1EGzGlfePDEzIbvO4v/ppZLfWmbu53ZFz2YrmzmwKydS28lQAbaaPFd3nEUux1txZF9N8LARhWmqkzMX3gs2TrKGwIW+EAsF7VHLKCCPX3Dp/EV8h5E5YDdfq9s4G55c4v912x9pGqB3hF+32Kkmev7hSUDRJIveX030uh/E5b4L4jc44dgZNeocJ1PatpUDQBShNPw/LAtrLVH3BflL9ImjT+tN2MnPZ6xfuqqGqVDaFPRznnsUQNin4CZPQQKnu1+qV4paqUs3V/LPLoW2usuds49w/H+Yec=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(136003)(346002)(39860400002)(451199021)(40470700004)(36840700001)(46966006)(44832011)(2906002)(82740400003)(356005)(81166007)(40460700003)(86362001)(82310400005)(40480700001)(478600001)(110136005)(316002)(41300700001)(70206006)(70586007)(4326008)(26005)(54906003)(8676002)(1076003)(6666004)(36756003)(36860700001)(186003)(16526019)(47076005)(8936002)(83380400001)(336012)(426003)(5660300002)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 01:07:12.5018
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f521dd34-45a5-488b-5c3f-08db42cde7aa
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR12MB8330
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

The pds_core driver will supply adminq services, so find the PF
and register with the DSC services.

Use the following commands to enable a VF:
echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/Makefile   |  1 +
 drivers/vfio/pci/pds/cmds.c     | 47 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h     | 10 +++++++
 drivers/vfio/pci/pds/pci_drv.c  | 19 +++++++++++++
 drivers/vfio/pci/pds/pci_drv.h  |  9 +++++++
 drivers/vfio/pci/pds/vfio_dev.c | 11 ++++++++
 drivers/vfio/pci/pds/vfio_dev.h |  6 +++++
 include/linux/pds/pds_lm.h      | 11 ++++++++
 8 files changed, 114 insertions(+)
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h
 create mode 100644 include/linux/pds/pds_lm.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
index e1a55ae0f079..87581111fa17 100644
--- a/drivers/vfio/pci/pds/Makefile
+++ b/drivers/vfio/pci/pds/Makefile
@@ -4,5 +4,6 @@
 obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
 
 pds_vfio-y := \
+	cmds.o		\
 	pci_drv.o	\
 	vfio_dev.o
diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
new file mode 100644
index 000000000000..29a350cb5df5
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -0,0 +1,47 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/io.h>
+#include <linux/types.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_lm.h>
+
+#include "vfio_dev.h"
+#include "cmds.h"
+
+int
+pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
+	char devname[PDS_DEVNAME_LEN];
+	int ci;
+
+	snprintf(devname, sizeof(devname),
+		 "%s.%d-%u", PDS_LM_DEV_NAME, pci_domain_nr(pdev->bus),
+		 pds_vfio->pci_id);
+
+	ci = pds_client_register(pci_physfn(pdev), devname);
+	if (ci <= 0)
+		return ci;
+
+	pds_vfio->client_id = ci;
+
+	return 0;
+}
+
+void
+pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
+	int err;
+
+	err = pds_client_unregister(pci_physfn(pdev), pds_vfio->client_id);
+	if (err)
+		dev_err(&pdev->dev, "unregister from DSC failed: %pe\n",
+			ERR_PTR(err));
+
+	pds_vfio->client_id = 0;
+}
diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
new file mode 100644
index 000000000000..4c592afccf89
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _CMDS_H_
+#define _CMDS_H_
+
+int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
+
+#endif /* _CMDS_H_ */
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index 3856a4e78c8d..dca7d457bd8c 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -8,9 +8,13 @@
 #include <linux/types.h>
 #include <linux/vfio.h>
 
+#include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
 
 #include "vfio_dev.h"
+#include "pci_drv.h"
+#include "cmds.h"
 
 #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
 #define PCI_VENDOR_ID_PENSANDO		0x1dd8
@@ -28,13 +32,27 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
 		return PTR_ERR(pds_vfio);
 
 	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
+	pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
+	if (IS_ERR_OR_NULL(pds_vfio->pdsc)) {
+		err = PTR_ERR(pds_vfio->pdsc) ?: -ENODEV;
+		goto out_put_vdev;
+	}
 
 	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
 	if (err)
 		goto out_put_vdev;
 
+	err = pds_vfio_register_client_cmd(pds_vfio);
+	if (err) {
+		dev_err(&pdev->dev, "failed to register as client: %pe\n",
+			ERR_PTR(err));
+		goto out_unregister_coredev;
+	}
+
 	return 0;
 
+out_unregister_coredev:
+	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
 out_put_vdev:
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
 	return err;
@@ -45,6 +63,7 @@ pds_vfio_pci_remove(struct pci_dev *pdev)
 {
 	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
 
+	pds_vfio_unregister_client_cmd(pds_vfio);
 	vfio_pci_core_unregister_device(&pds_vfio->vfio_coredev);
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
 }
diff --git a/drivers/vfio/pci/pds/pci_drv.h b/drivers/vfio/pci/pds/pci_drv.h
new file mode 100644
index 000000000000..e79bed12ed14
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.h
@@ -0,0 +1,9 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _PCI_DRV_H
+#define _PCI_DRV_H
+
+#include <linux/pci.h>
+
+#endif /* _PCI_DRV_H */
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 0f70efec01e1..228b27a0aa60 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -6,6 +6,12 @@
 
 #include "vfio_dev.h"
 
+struct pci_dev *
+pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
+{
+	return  pds_vfio->vfio_coredev.pdev;
+}
+
 struct pds_vfio_pci_device *
 pds_vfio_pci_drvdata(struct pci_dev *pdev)
 {
@@ -31,6 +37,11 @@ pds_vfio_init_device(struct vfio_device *vdev)
 	pds_vfio->vf_id = pci_iov_vf_id(pdev);
 	pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
 
+	dev_dbg(&pdev->dev, "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d pds_vfio %p\n",
+		__func__, pci_dev_id(pdev->physfn),
+		pds_vfio->pci_id, pds_vfio->pci_id, pds_vfio->vf_id,
+		pci_domain_nr(pdev->bus), pds_vfio);
+
 	return 0;
 }
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index 66cfcab5b5bf..92e8ff241ca8 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -7,14 +7,20 @@
 #include <linux/pci.h>
 #include <linux/vfio_pci_core.h>
 
+struct pdsc;
+
 struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
+	struct pdsc *pdsc;
 
 	int vf_id;
 	int pci_id;
+	u16 client_id;
 };
 
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
 
+struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio);
+
 #endif /* _VFIO_DEV_H_ */
diff --git a/include/linux/pds/pds_lm.h b/include/linux/pds/pds_lm.h
new file mode 100644
index 000000000000..26d17efeff28
--- /dev/null
+++ b/include/linux/pds/pds_lm.h
@@ -0,0 +1,11 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDS_LM_H_
+#define _PDS_LM_H_
+
+#include "pds_common.h"
+
+#define PDS_LM_DEV_NAME		PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR
+
+#endif /* _PDS_LM_H_ */
-- 
2.17.1


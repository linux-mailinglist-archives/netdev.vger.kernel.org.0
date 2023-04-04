Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37F566D6CDB
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236314AbjDDTCp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:02:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235153AbjDDTCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:02:37 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2072.outbound.protection.outlook.com [40.107.93.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EE059D8;
        Tue,  4 Apr 2023 12:02:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z4SaqH11AN0WXOHXDv7FUlVrEAuEBaLvBKs1CG1cB9JMZV0LQiSypIIJMT50YVB+zsRLgjsJ11re68hPpYbiwQcb6nUhup1vj7I00gGRewX1fuuJHnKS/j/UZwEv6iqZdat/zEBL7rhXHJYiYji+5Tu+W9BKMTG8byDk3mRs4n/OG5XaSdX8kPsybuBwUma25O+uAmCM2ZUJJkl7W/EJXUBoeZ/6am3Jv2DGdaZ27PtyLGDFattCSz2X/+EwuQcqjMnt0mpdaZB+s+sqZB6nNcG9bNE/JM3BtaYLbU82WYmZu5R58TN89nvzDl/yzKOQ5eQcwFS3KsFJS8FxxmlfMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4swuNByLzd6+SNc8A1ivYwSdWTMpKjvwvX603wk3A6Y=;
 b=Ru0XwH5ExYbThZBpcT8POntL/B738INt+uezx3b9ym6K3Dklyo7IuB0c5QPUKemO21nCTx+dTXbpGedUe2jt2Q6Ikka7AdxVEZlWmG33Oi1vJ8ds3RvjkGOUBz1UtCMjnyIeYvaSxIWrCz6NDRgUpNeSkVR+PMjyoQy6lbv8mwihfy4KQH+nPixQvh7FuiTV9D7t0WukiQOietgz/m22Xl1RQEWj8TL+WEv8q3WCk89QdIBD2LQnTcztJOiTGJEYatHYw9NVW/v9hkNECQLJMNh/5NjaFGQ2gPAcJ9PxpIrY5TatWWASLoajWb9EogJx/lV5vpZHX3bM1B6/WfaFbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4swuNByLzd6+SNc8A1ivYwSdWTMpKjvwvX603wk3A6Y=;
 b=ejthV+mgRBXjL6c0auigJKjUJu7a8HJtDRlw56D4v+PBmHTrEo5ccHo2EgUZoEHWKCR59tqbH77Xig296j/srDcWx/vLQwue82DDxcbPhwa/cf3VETRqEWyQoHvM7IggxpX25YlEbzJb/GkF8urD+Quc0NzpXYTk4N8PIf9Rq5s=
Received: from MW4P220CA0009.NAMP220.PROD.OUTLOOK.COM (2603:10b6:303:115::14)
 by SJ2PR12MB7893.namprd12.prod.outlook.com (2603:10b6:a03:4c6::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.33; Tue, 4 Apr
 2023 19:02:05 +0000
Received: from CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:115:cafe::e) by MW4P220CA0009.outlook.office365.com
 (2603:10b6:303:115::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22 via Frontend
 Transport; Tue, 4 Apr 2023 19:02:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT096.mail.protection.outlook.com (10.13.175.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.14 via Frontend Transport; Tue, 4 Apr 2023 19:02:05 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 4 Apr
 2023 14:02:03 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: [PATCH v8 vfio 3/7] vfio/pds: register with the pds_core PF
Date:   Tue, 4 Apr 2023 12:01:37 -0700
Message-ID: <20230404190141.57762-4-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230404190141.57762-1-brett.creeley@amd.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT096:EE_|SJ2PR12MB7893:EE_
X-MS-Office365-Filtering-Correlation-Id: 4320f6eb-ee05-4505-06c0-08db353f14f8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: N8c7OBrdQH3WVsyesjcq8PUxzVvTznWhuIWHEA8gg38yz12VYI1xj+pEZJfuw3/qkGEc5OqN7rqzzaPas/bDVqchqbPxh4AD8CRaTuwztaTKG1yXrRPRvokvmMvhdiB2GbkDVT9AZ3Fn+tWtz3Av4qSo+OjHI7Tzc4TVoc/t5CggzYpoCxzTZ5enxZGCNzifDNaE8nI6HvUyDcLnUxNHLAJ0WS0JZXvws93bMQDYuZazPJw+z/snzC4qSbFaRApFMjrIP4s3m9sDeUH5cC8O6gX09iYWZ3Cp5nkasZGhLZpuytLwWc4qnoQ5UVDDxNo6kcdyspmO2OrUnGwEbh6sckVfIeNIVkSk5gTY+VFJG/WCPryAhqa+7X0DfOVglAoJD+is0xZYSZRJZXlJG7PiSQO0JMlWp3lCkdC8hiIVKpe8HQev6CCIdN7tJP1rPO+AZ6b1GxRm3xSVPeoSx0ZUJI6B2VQ2tYA7tpeq6hV0twOTVRdMFCb3YaxxWwLBnAIuuDdQbGyqJqIkEaMSOhlDNc8Pj8M1XlibdJMlWVEnPZvpbpui6GyIZ5DSrXgf4vEXbAxWL/XNu28bzTVirc39wb/6OGt6EvX3239UV8cJmQoC29h86kjmIS28Qfv8jm9TVbwn6yNo1Aes+m5FySH6ilncw9TWyygtwbfmapg5/OnQhdK/I8yKpTaFYw8iGmkv1V+9EEKgl4lkHAlDO+I63EYgIJ9LWYszSjrKeO5fFa8=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(396003)(451199021)(40470700004)(46966006)(36840700001)(40480700001)(40460700003)(82740400003)(70206006)(54906003)(36860700001)(4326008)(478600001)(70586007)(8676002)(81166007)(316002)(110136005)(41300700001)(44832011)(356005)(5660300002)(426003)(16526019)(83380400001)(186003)(47076005)(336012)(1076003)(6666004)(26005)(8936002)(86362001)(82310400005)(2906002)(36756003)(2616005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 19:02:05.2661
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4320f6eb-ee05-4505-06c0-08db353f14f8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT096.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB7893
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
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
 drivers/vfio/pci/pds/cmds.c     | 69 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h     | 10 +++++
 drivers/vfio/pci/pds/pci_drv.c  | 16 +++++++-
 drivers/vfio/pci/pds/pci_drv.h  |  9 +++++
 drivers/vfio/pci/pds/vfio_dev.c |  5 +++
 drivers/vfio/pci/pds/vfio_dev.h |  2 +
 include/linux/pds/pds_lm.h      | 12 ++++++
 8 files changed, 123 insertions(+), 1 deletion(-)
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
index 000000000000..7807dbb2c72c
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -0,0 +1,69 @@
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
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev;
+	int err;
+	u32 id;
+	u16 ci;
+
+	id = PCI_DEVID(pds_vfio->pdev->bus->number,
+		       pci_iov_virtfn_devfn(pds_vfio->pdev, pds_vfio->vf_id));
+
+	dev = &pds_vfio->pdev->dev;
+	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
+	snprintf(cmd.client_reg.devname, sizeof(cmd.client_reg.devname),
+		 "%s.%d-%u", PDS_LM_DEV_NAME,
+		 pci_domain_nr(pds_vfio->pdev->bus), id);
+
+	err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, &comp, false);
+	if (err) {
+		dev_info(dev, "register with DSC failed, status %d: %pe\n",
+			 comp.status, ERR_PTR(err));
+		return err;
+	}
+
+	ci = le16_to_cpu(comp.client_reg.client_id);
+	if (!ci) {
+		dev_err(dev, "%s: device returned null client_id\n", __func__);
+		return -EIO;
+	}
+	pds_vfio->client_id = ci;
+
+	return 0;
+}
+
+void
+pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	union pds_core_adminq_comp comp = { 0 };
+	union pds_core_adminq_cmd cmd = { 0 };
+	struct device *dev;
+	int err;
+
+	dev = &pds_vfio->pdev->dev;
+	cmd.client_unreg.opcode = PDS_AQ_CMD_CLIENT_UNREG;
+	cmd.client_unreg.client_id = cpu_to_le16(pds_vfio->client_id);
+
+	err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, &comp, false);
+	if (err)
+		dev_info(dev, "unregister from DSC failed, status %d: %pe\n",
+			 comp.status, ERR_PTR(err));
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
index 5e554420792e..46537afdee2d 100644
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
 
 #define PDS_VFIO_DRV_NAME		"pds_vfio"
 #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
@@ -30,13 +34,23 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
 
 	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
 	pds_vfio->pdev = pdev;
+	pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
+
+	err = pds_vfio_register_client_cmd(pds_vfio);
+	if (err) {
+		dev_err(&pdev->dev, "failed to register as client: %pe\n",
+			ERR_PTR(err));
+		goto out_put_vdev;
+	}
 
 	err = vfio_pci_core_register_device(&pds_vfio->vfio_coredev);
 	if (err)
-		goto out_put_vdev;
+		goto out_unreg_client;
 
 	return 0;
 
+out_unreg_client:
+	pds_vfio_unregister_client_cmd(pds_vfio);
 out_put_vdev:
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
 	return err;
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
index 0f70efec01e1..056715dea512 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -31,6 +31,11 @@ pds_vfio_init_device(struct vfio_device *vdev)
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
index a66f8069b88c..10557e8dc829 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -10,9 +10,11 @@
 struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
 	struct pci_dev *pdev;
+	void *pdsc;
 
 	int vf_id;
 	int pci_id;
+	u16 client_id;
 };
 
 const struct vfio_device_ops *pds_vfio_ops_info(void);
diff --git a/include/linux/pds/pds_lm.h b/include/linux/pds/pds_lm.h
new file mode 100644
index 000000000000..2bc2bf79426e
--- /dev/null
+++ b/include/linux/pds/pds_lm.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#ifndef _PDS_LM_H_
+#define _PDS_LM_H_
+
+#include "pds_common.h"
+
+#define PDS_DEV_TYPE_LM_STR	"LM"
+#define PDS_LM_DEV_NAME		PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR
+
+#endif /* _PDS_LM_H_ */
-- 
2.17.1


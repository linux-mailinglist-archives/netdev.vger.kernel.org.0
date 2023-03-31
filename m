Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00BB26D142D
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 02:36:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCaAgl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 20:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbjCaAgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 20:36:37 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2088.outbound.protection.outlook.com [40.107.93.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C03CE10AAB;
        Thu, 30 Mar 2023 17:36:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NbjXlgFrHzzs1IRNnrmOMl87SNKgoryIHQOkY6U+Kmu/4DFhBnongVvN6G7obI+lp2e9UnPU7HppIO/yWXq2J16M8LVGtNTQbgW0GcO0gKEXdqLt9W6rntgxsKAVu91+HsvvNIYhiSDENIwNJabrggV+MH/i2Xi/LgEuaM22Atne5VhSin8PbmJ4H2Pv4dAdYc8JxcB8VGstJqbrtcgrQIDwcdFj3lH1hfDukXUY0kJoBPpJutoa5EMWsCS5WN5pVxsAbHW4Waq5CNPgqSauRIQ5WF3m1BhxxDzJ3ZBaT4CPebXX9ZwfBL/bvSanWdxXKRWBQnKctTbzNjL2Kxd3BA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycLIVx0NWLwkUC0hoIdI3M2PCdfzw0oKQ/c032QlZjY=;
 b=cAxvydyf0ugGFWBnIcbSWMIEUghE5EDFDqDl9ntyqmMgO8O1Vm/vXuTPQQWcjuk1ui1cP+5HnnHbXVv5Mrur5g6Xe8sKZGYJ/fyDVNWGv7Bf6EwP71tfl/yFwfeMK/WyYpvVKnHnFYuZkftYEzGa0XEI+NaMaFkgbpW5oKz7qppvuJdTaT/A05MtmPOW66me+loZo9tnvIKQMp6eRILec9o0ueeRNcW5Tk/KLD+5u3NoaN35+m5yjghz9lESSiQXY8nQZNKZTv/T7NFzJVsrmsP6WYeqguJ2tfn0bnEWzdf5ksN5nSCLtn/1S6mAdR4LCxk55KI0r+NoioehB7Gcdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycLIVx0NWLwkUC0hoIdI3M2PCdfzw0oKQ/c032QlZjY=;
 b=zXFVKn5RclZCVowYtU5ZO6kzNIBJcO7Y9A69QAU192MWVEyG8qVay3G4FmvLgl0kRFVr63Ehq6H8Ug3IQWZQwmV+tklgAswQPzFc4Xwg2EdSUQq09WfMN/Oz56Ikez3XyCDA8V1I1G9soh4NveQ+H2kwHcZLYnzQPE5gKvqcgYM=
Received: from DM6PR21CA0003.namprd21.prod.outlook.com (2603:10b6:5:174::13)
 by CY8PR12MB7611.namprd12.prod.outlook.com (2603:10b6:930:9b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.23; Fri, 31 Mar
 2023 00:36:31 +0000
Received: from DS1PEPF0000E653.namprd02.prod.outlook.com
 (2603:10b6:5:174:cafe::a9) by DM6PR21CA0003.outlook.office365.com
 (2603:10b6:5:174::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.18 via Frontend
 Transport; Fri, 31 Mar 2023 00:36:31 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E653.mail.protection.outlook.com (10.167.18.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.30 via Frontend Transport; Fri, 31 Mar 2023 00:36:30 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 30 Mar
 2023 19:36:28 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: [PATCH v7 vfio 3/7] vfio/pds: register with the pds_core PF
Date:   Thu, 30 Mar 2023 17:36:08 -0700
Message-ID: <20230331003612.17569-4-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E653:EE_|CY8PR12MB7611:EE_
X-MS-Office365-Filtering-Correlation-Id: 7954cd99-094b-4abd-d59e-08db317ff87e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wrTxGj6eco3gIKkOHH0CF6uhntgEK+jIyDQDsgdKW9hsiGvZsKghVcMxKM/eVJttsr1sHIAKznFC99nWO9xTzMOEtP4NdISjJoVYHsLPNgqRc6w9ZPxbZQGz1zDm22o/u3jc2Nb1kRm9yvYW/T7AGbAXKPRgrLT16PIW0uWWZapnB91z91FgkhrPD+lOwvl6BeNxmCC2jSl/1QICTSOdwnoXN1Zt+m8CG0RZHxuXFh6tE1DR7djnU3exRiuc+hDYeBl4hacKKh3/GGk0jSOK6QA/ZtCKG7L5Q/rWs4Ui1tTRX3c8kZwGTtM4q9BPQDcQUMSqfX6oTr+fGiPihnFDgS9Z1QjK4DCO0DbvezmvTCVyppUQPBFQJv0iWjvz7CykgthwKD5ojgztb0bifuSPqbdO/4hlKOAQ/TrCMJOFARUn/sL1H0MMfnkPCkXsUL2M6PpNZJ8crfm/Lkg0izji+79ZhQkrnBm5pNlDDfYq8KAH7A3xyo2B7Zay5CnHvIF1b1xdi2i5kPAuZtC/WQDh2ej2z1vawl0qT8cOPkv37Ssgu53imFvC5KeE59lI6baJPU2fSas/R4jxX20Hrg0C68DOw5orAp2I/nmfCAiqqQ52n1gI6rUCN2tpy5ndua+aE4tYFSc/TgiKjqpDp/Tq+IefeI8QICbnLKieZoB+WAxmy/Hn15J+qOxkHNa+LbMUbUNqNgtRoKw8nHt9vubISN3HaMzRge7EzN+B3VjR+MY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(396003)(39860400002)(346002)(376002)(136003)(451199021)(46966006)(36840700001)(40470700004)(40480700001)(82310400005)(16526019)(186003)(6666004)(1076003)(26005)(83380400001)(47076005)(41300700001)(426003)(336012)(2616005)(54906003)(110136005)(478600001)(316002)(70206006)(70586007)(40460700003)(4326008)(8676002)(82740400003)(2906002)(81166007)(356005)(36756003)(86362001)(5660300002)(8936002)(36860700001)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 00:36:30.1945
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7954cd99-094b-4abd-d59e-08db317ff87e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E653.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7611
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
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
index f1221f14e4f6..592b10a279f0 100644
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


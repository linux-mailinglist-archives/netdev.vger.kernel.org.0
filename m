Return-Path: <netdev+bounces-7582-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A09B4720BB0
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 00:04:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2307A1C211DA
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 22:04:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5E5D9C126;
	Fri,  2 Jun 2023 22:03:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C551539C
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 22:03:45 +0000 (UTC)
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2066.outbound.protection.outlook.com [40.107.100.66])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882C21BF;
	Fri,  2 Jun 2023 15:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oUbb4HUDfCre4joOwgr0Jpvbg+EwlHOX87shxB2BvlcO0aeAjeCvl+hnIN9SwoIQMYubDh+NedgjrQhRBEu5a5ZpsTKZPHi4uZeO0fW4Fv8cdxH61FakEOhKSdtBLP7XtFxm0tAV9ivbp+cjffkWDpVaul2lXkUUBl6DRP2FWKqoPEc16d+fJ51MWVldjcaRPFH7xblJQV0fCrkweg0xEwdwbM9gOAnv1kcxbFRWfvft8V/Pn0Zy7w7+8S/4f0yRHUSobOUB6i7TA2E2iVn+EBCC6RK+t8IKLDVrY+LLqxy+iAtrUCrWiTp0ddFvOQgGI9TZs5PQwse8CDpOWV8rUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HnKMJoMbFkOxVw2XMnAShmXkDLoS4iS6CKm7Ygimbk0=;
 b=MZPhY6r+u0vuYghFRB0uq68eww6W5Q87RAVdXEOJGTJZe+3235t3E5DmQGkQi448xgPpomq4DPC1zab+/J3xjP1jhvWo0Dpcjr5vvzQnCMfK8vqQgnxCbkIamdBik0VRX3L9WfjMRuoLbpakdTPhTOQCPHEuIA0hdIjRLUzfCxMaXX6rV91aTgot5L7EDz/cW6UJFDgOCZpVjBYkIMRj2CnZOSJvhDLvghTWBjCsyB9jHd63qVhHDSdmeVHxTqb0k/meSzPLEn9w4kW23oYYS2gjEgVwhxcOi54h98LX5fXZ71fjQ9zmL+II9JbaNLgkEOwa+XWSZf2MMy4WspXl0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HnKMJoMbFkOxVw2XMnAShmXkDLoS4iS6CKm7Ygimbk0=;
 b=5HH9NEPIoXuXG1Fu+EyzFGWFf/gFr5EnYHNVcUpYZtfcZ1LaGCiu2Nb2TLmDFXI7pI8fOAUJ5FUCjamFCAIp1nDeEkemdRi4pzS/9u6jDgNKpbneqZ3Ups1o0AX/F3hivojND4JZV0TYYdHpRBTqgYkJJkIkEjWCcV45j3M4RyY=
Received: from DS7PR05CA0090.namprd05.prod.outlook.com (2603:10b6:8:56::13) by
 CY8PR12MB7098.namprd12.prod.outlook.com (2603:10b6:930:62::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.26; Fri, 2 Jun 2023 22:03:41 +0000
Received: from DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:56:cafe::12) by DS7PR05CA0090.outlook.office365.com
 (2603:10b6:8:56::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.12 via Frontend
 Transport; Fri, 2 Jun 2023 22:03:41 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT039.mail.protection.outlook.com (10.13.172.83) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6455.26 via Frontend Transport; Fri, 2 Jun 2023 22:03:40 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 2 Jun
 2023 17:03:38 -0500
From: Brett Creeley <brett.creeley@amd.com>
To: <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
	<alex.williamson@redhat.com>, <jgg@nvidia.com>, <yishaih@nvidia.com>,
	<shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC: <brett.creeley@amd.com>, <shannon.nelson@amd.com>
Subject: [PATCH v10 vfio 3/7] vfio/pds: register with the pds_core PF
Date: Fri, 2 Jun 2023 15:03:14 -0700
Message-ID: <20230602220318.15323-4-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230602220318.15323-1-brett.creeley@amd.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT039:EE_|CY8PR12MB7098:EE_
X-MS-Office365-Filtering-Correlation-Id: 59ecb709-492b-45cc-919c-08db63b53992
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	+u6QlfSJ4R+y5ZPC9J33OP/pn4BPfpIy+mu6ody90JWAbZGPQ1mMmKWSnBxIAmQDD7lQWWpc+7nk4IKPTMe69svuZVusC8h37zNwD/msykjW4vixa13GJpib1tjhX6CM8EuoPSMPTO4xWujM9TSmVBSLpiFN+uCA8UmfxTVhIJCP91uv8Bo+jhdkJeAr643djCq8e3QVKwbrxo1uVXV4hclH3xH4WPPe2HbtFKRtTzRq9OEh2vB7M6qQWTKXvNOfqQLMgTe+B0QZUMYrxjGeeGEp5g8OynB6ylYiVCwcaVpBFQIHQFsUYetTjFfh/qz/apaBOtv1EzspjifPqbm7MVZU+rVXoQGz52Ck6Y23EoEAJMqi+SOO9lUIU9FZ0uTS/7/1gCdcE46xRu0OR9hunoTPup7J0e+zynBZHbs00SyQ+4LYreQ6FlQ6w/EUPBEquKY+dQcZSMmoyn1wdDXvng4E8wQsRhxqIwGwXmYURB+s3/RxQsCOxec5yP0EUe469e+VDZ3KcZfoDQurV4U8VIr38eT/xwrurKqOrKlOJPki9kX4mr8+7ZQFDr3qhzDbM55rMABpmfc7q5ofFQg5hThEz1LY9iI+15oua8mFcJmxJvtNfepotP0gGC96sWMH5tGNDSM1P+UKvCMcHTPGf8ZNbi0mbdYoBhcVW8Y1NphLGRqRumnemrju0Wq99JgBeNgeKZFmTjWqH3jRPaHhHL7NBvcRnFfU7cS7OGuGLBiB9sAGNRTtYNtHAiBTshvQWoZr5POEX3DdpMU3Qxk2fw==
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199021)(36840700001)(40470700004)(46966006)(356005)(82740400003)(81166007)(82310400005)(40460700003)(40480700001)(110136005)(54906003)(86362001)(70586007)(70206006)(4326008)(36756003)(478600001)(6666004)(1076003)(16526019)(186003)(26005)(8936002)(8676002)(5660300002)(44832011)(2616005)(36860700001)(316002)(47076005)(426003)(83380400001)(2906002)(41300700001)(336012)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jun 2023 22:03:40.8413
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 59ecb709-492b-45cc-919c-08db63b53992
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT039.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7098
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The pds_core driver will supply adminq services, so find the PF
and register with the DSC services.

Use the following commands to enable a VF:
echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/Makefile   |  1 +
 drivers/vfio/pci/pds/cmds.c     | 43 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h     | 10 ++++++++
 drivers/vfio/pci/pds/pci_drv.c  | 19 +++++++++++++++
 drivers/vfio/pci/pds/pci_drv.h  |  9 +++++++
 drivers/vfio/pci/pds/vfio_dev.c | 11 +++++++++
 drivers/vfio/pci/pds/vfio_dev.h |  6 +++++
 include/linux/pds/pds_common.h  |  2 ++
 8 files changed, 101 insertions(+)
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h

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
index 000000000000..ae01f5df2f5c
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/io.h>
+#include <linux/types.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+
+#include "vfio_dev.h"
+#include "cmds.h"
+
+int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
+	char devname[PDS_DEVNAME_LEN];
+	int ci;
+
+	snprintf(devname, sizeof(devname), "%s.%d-%u", PDS_LM_DEV_NAME,
+		 pci_domain_nr(pdev->bus), pds_vfio->pci_id);
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
+void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
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
index 0e84249069d4..a49420aa9736 100644
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
@@ -27,13 +31,27 @@ static int pds_vfio_pci_probe(struct pci_dev *pdev,
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
@@ -43,6 +61,7 @@ static void pds_vfio_pci_remove(struct pci_dev *pdev)
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
index 4038dac90a97..39771265b78f 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -6,6 +6,11 @@
 
 #include "vfio_dev.h"
 
+struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
+{
+	return pds_vfio->vfio_coredev.pdev;
+}
+
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev)
 {
 	struct vfio_pci_core_device *core_device = dev_get_drvdata(&pdev->dev);
@@ -29,6 +34,12 @@ static int pds_vfio_init_device(struct vfio_device *vdev)
 	pds_vfio->vf_id = pci_iov_vf_id(pdev);
 	pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
 
+	dev_dbg(&pdev->dev,
+		"%s: PF %#04x VF %#04x (%d) vf_id %d domain %d pds_vfio %p\n",
+		__func__, pci_dev_id(pdev->physfn), pds_vfio->pci_id,
+		pds_vfio->pci_id, pds_vfio->vf_id, pci_domain_nr(pdev->bus),
+		pds_vfio);
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
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 060331486d50..721453bdf975 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -39,6 +39,8 @@ enum pds_core_vif_types {
 #define PDS_DEV_TYPE_RDMA_STR	"RDMA"
 #define PDS_DEV_TYPE_LM_STR	"LM"
 
+#define PDS_LM_DEV_NAME		PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR
+
 #define PDS_CORE_IFNAMSIZ		16
 
 /**
-- 
2.17.1



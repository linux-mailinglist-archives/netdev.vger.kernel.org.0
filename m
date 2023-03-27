Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 866616CAF5F
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 22:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbjC0UG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 16:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231927AbjC0UGW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 16:06:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2062.outbound.protection.outlook.com [40.107.244.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B50235A1;
        Mon, 27 Mar 2023 13:06:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXSxfh/HXF7yKNc7y1ZjE9500eIQcsBw0YQgGn59aAuvK+fh7qw7Wm9W9qcE0bPCX28+6d1fZ7MbvpIN0T5BRJnNIc/Z22o/7bdk77aaH0gcw9jrdPV2SZDNnTXcvHon4784OTYO3Hc67HBnnSoK1u7eecQW9NDYr/eWMss9GttqEG8e9ZRIEveRGl5bHlXEmF7A0EJRUZOq91nxtIqYPnM0QG+ULNnWFu23zx5yj3Qi8i5Jz90cxCte5Onn9nvXCdpghv+fwUVCznq+CZucdnFskBfChM+QoIADdwVTyjrpWDJwSue6247mBQoM2FzYbdI2oOKM+JM2D4NZUiGGqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycLIVx0NWLwkUC0hoIdI3M2PCdfzw0oKQ/c032QlZjY=;
 b=CVZ6KyUc6EateNLb86vos7gzQT9e0SdP6rksxnSnZcn9n2tKgQMyECpLKXL/zpsL+NiOiYAAsdHzqsIfNqVH5I09L+ayW0X3iEeQ5imuvoK25nsmAI+XPxbyVhAZC1bmHwBGUGUdYto9p4fE6YnucdjUtP9I0ogBamBYLX8Arm9z7K1UXBgVdYpSethV62izSC6ZshuZ+oVyKyR1AalH6MOlK1Eeyj6rQlwmPF93IW3haZydgbBLzrbBCvfTlMm5/1jBhE497aCa0zaBNvq/e3iGDTX9+bNpdBqcT+MIZ/4t5l8TpY9hV1+LaAtq6hetIC5cP9APss/pEnJkZq4Fng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycLIVx0NWLwkUC0hoIdI3M2PCdfzw0oKQ/c032QlZjY=;
 b=EfXeRHl1tDjGJdxfM45f/ijcbcbJ1kZsnxGiQnmCh913SvI7drQ+6vqs4JrSbMBwZUL0bUUDnt0QwfNlRsyij7cmOxk4JI6L4UbH3IJCCWp1/fvFUUh+h5HTmsXPiHheg/H/YfV3D6J1rMhoiKom5UoTRdulWP1xKOTyjdaDcF4=
Received: from MW4PR04CA0048.namprd04.prod.outlook.com (2603:10b6:303:6a::23)
 by CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Mon, 27 Mar
 2023 20:06:13 +0000
Received: from CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6a:cafe::78) by MW4PR04CA0048.outlook.office365.com
 (2603:10b6:303:6a::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.41 via Frontend
 Transport; Mon, 27 Mar 2023 20:06:13 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT103.mail.protection.outlook.com (10.13.174.252) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Mon, 27 Mar 2023 20:06:13 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Mon, 27 Mar
 2023 15:06:11 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [PATCH v6 vfio 3/7] vfio/pds: register with the pds_core PF
Date:   Mon, 27 Mar 2023 13:05:49 -0700
Message-ID: <20230327200553.13951-4-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230327200553.13951-1-brett.creeley@amd.com>
References: <20230327200553.13951-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT103:EE_|CY5PR12MB6179:EE_
X-MS-Office365-Filtering-Correlation-Id: 43945b5c-b58e-403f-9b8c-08db2efeb748
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6ace+4tMRd/avs4PS82beKGBndNxv/nn9YFE19JOdglwNMx/ByJkTNcL3zgtFmQjH+lRcF/sHAJwPcfUO86cfcVDneUVvYW7nECCj9PMCVhAgBr/f24rRVuxA7RmpTC9Evt5ABIL/SCkecHimpyrlkLTCJ3+BybBimJd0Wm0AfKE9Drj8L33oJGAbJA8UAlW81VYSf2FL5bD4QEsR8z1RHmv/AmB5d35qLOAdebg+9eTHCcZIyvI/6OrzWR9/pSZfJxY5QmMWTVgg3sjaop5P1rPlhyaXawSPKmW+TjEibu0gPeDQuLIPhRWuCE3dVaxROWRepN9QhZFdO52Nuz3fdrgHVqBbMmGo2DJMBA9kHbgv+W6Cua56p4UwTn1+P1Mui4DELLl0cvHg12WmBxYfJ4rnhBD/atWjNK5X66een9Kx043SsjWEX6Nr7fFgNE++FZjhgf6LAJRpo3rBa4/2VhfU1HivwmElvlsL673kr5tmjo3AeHvJyzTDxA1qP5wnGPBv6xVqpslYPrgaFa3hpLhf/655TWjR8v16XlBOFBrql0MnGVv8DtFPj/2DFNopr7ytDJeAzNkaTd+5fz44UHSb7EvzsRd7/v3wnXx6cbOJYm0/nQh7oJ9pqK0Bbcg7qhUXBSRFW+VJsklJJTyWsMTA55aVnkTsHxeh4I3s3clwW1N23C1Br1AyVY5qSAAcvHZJO4dOML2uV4QiW1dDfDQQaJ3xbfCNh2cQ7XTNjU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199021)(46966006)(36840700001)(40470700004)(86362001)(70586007)(70206006)(36756003)(40480700001)(82740400003)(2906002)(16526019)(316002)(36860700001)(44832011)(478600001)(54906003)(40460700003)(110136005)(8676002)(6666004)(2616005)(26005)(82310400005)(81166007)(1076003)(186003)(47076005)(8936002)(4326008)(41300700001)(356005)(336012)(426003)(83380400001)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 20:06:13.2898
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 43945b5c-b58e-403f-9b8c-08db2efeb748
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT103.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6179
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


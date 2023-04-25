Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 872FE6EE9A5
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbjDYV0o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236400AbjDYV0c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:26:32 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2084.outbound.protection.outlook.com [40.107.223.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF70F17A23
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:26:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fnLv+xc/IBY/ehLip42BSTyI3Fe+jpN00LAk6qKk4WfpBknDgPnI2btvW4Wi4+vYtf8lfB42zPuePQI/ckTCHM7lBBr7pxz1k9KibXyEzTwdoVSMV8w5Hm7QDCqSabGV7qoMge3ctD6fzPu0yTnMRjc6d/khOQYuBXO6YNMOf8kwq0OWfcKAU9gjqB6Cr+fdCbJg9iGWGuRIlgav+jAoHIj7dtyQCjzWpebOvVt9llIv7v5ld47NZQzPjre3x0IAawKyGEXre9iowrRe0IHqK/NGg5tCFaM6usfGslLJbMBHqf3mvNXAEqkx7itJhLC/6PnZo2sY/U1L3S6IQFJSQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hO1OVx/y4DC3hfqDreSo0ry+yyEDQnOq9eb9/2WQ+PA=;
 b=iMTO4yFInxMpGpxjBHMnuHlCR9t89EPeZN+n2WT57VblXWHfQIO2IVo2Hgx5mipmO9WMmE1/eHwLs7G1yMzC4hIsDAyrP6NUKDE55QWkSt1ylz3QTihSBbogTs2CrSgtmSmF68EIQ1kYkMUzGYOZo9Z1C4jobidAir8Nt9VgSMPhfoSsduLj9Gueh4mH9BPrdQWEvOx/2tdbul+wcwNHxRKCI0yqkhSfLjmn/IxWw6a1WaUpnzjojEhA5/1C6CUD5VtG8LqkAQoTBu9BKq/3EnhvPVUp5+5hkUsKOr8WLiSPGJTOV82p57IuwQ+XCQbNRwzv6j3SUqlRPti08AzGVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hO1OVx/y4DC3hfqDreSo0ry+yyEDQnOq9eb9/2WQ+PA=;
 b=l4/Q5LHTCuoXDBAkSlRV8EFlVHqejLNGLrEFeoKuJwDV36Uu8ug7Fv6OzgeFVSu67iQO2iq8a9LLzYP/OfrY+kSZ5DSubyJh7d81VGRRcrCj82SZabnzz9cgxrMb0+901Pa2jgKHfv7x7Zv2wed11lC/sZfWN2CSNAa4mTXN59o=
Received: from DM6PR14CA0043.namprd14.prod.outlook.com (2603:10b6:5:18f::20)
 by BY5PR12MB4193.namprd12.prod.outlook.com (2603:10b6:a03:20c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Tue, 25 Apr
 2023 21:26:19 +0000
Received: from DM6NAM11FT114.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:18f:cafe::a9) by DM6PR14CA0043.outlook.office365.com
 (2603:10b6:5:18f::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20 via Frontend
 Transport; Tue, 25 Apr 2023 21:26:19 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT114.mail.protection.outlook.com (10.13.172.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.21 via Frontend Transport; Tue, 25 Apr 2023 21:26:19 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 25 Apr
 2023 16:26:18 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v4 virtio 02/10] pds_vdpa: Add new vDPA driver for AMD/Pensando DSC
Date:   Tue, 25 Apr 2023 14:25:54 -0700
Message-ID: <20230425212602.1157-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230425212602.1157-1-shannon.nelson@amd.com>
References: <20230425212602.1157-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT114:EE_|BY5PR12MB4193:EE_
X-MS-Office365-Filtering-Correlation-Id: cc0ad769-4536-4cb2-642c-08db45d3b614
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WAfBfu4JtlyO/qOUkYHeLIGogyLtJnmbSrbxZNyiST/EbQZgTajb+dBfI6en3EF2g7M7M/5o6wHs+T/H/8R+RlkXxqey2i9NmTATtMxbxUlTHVYaDjv0RHIYdjFrB/kgoWbDuwCB1cM+SwOIB8KYlzvppvTaXiXU1wRk8BVSe4hr2G/1g6vd2IJTOIZXmtsSGsT/SgZWdbxEB5WnipKj+scBBp4hCmSn6YXzU6BpBew6vIqF3+VWxxg/JZIttU1oVEXlZ+AJDmhvFsvc/BtYvyw7j5qwwQdArt1fdVvnskDu3eMx3QZqHGIb/AOZfWuRmTbdzJgBpVz3sqPgjp7K7q+9lmJGFZu6oxrf6G8ODtLApHmbtiG0QtLR6MBQnchu9O+O3bJGsPWPVYsisPMF10E80l5GV+wLtNXCUkhqhZhv4WUx8x+K5U5eP2p2m1Dvw7Yxsc+gZFojjyxXm8TwjWIqDWvstSTwvM/CkCMKOcS17fXTblEzZXs100ZZGB5itKBByiQHnurmNWdKy4z8s6NVs91rknDISAwluCj8hO+X3Y5krBcREJK3DSb6aynVAzIAZjaDvdtg9NMkBGZlqIFQ1HcPmh1kW9OPUoJ3H7vVxlxQieqPTvHDD0mVzoOse9x3BLIzq38fdGiGXPtEhSRKRiBu2T3U8G6nDnDJWVrdtTzWa70gRE1hifFJMhUORUrZskwOcs3/CxVc71gz/4Gcxxwi3bTJRz+d8w2gaFI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(396003)(346002)(136003)(451199021)(36840700001)(40470700004)(46966006)(478600001)(2616005)(83380400001)(36860700001)(40480700001)(1076003)(26005)(6666004)(110136005)(70586007)(70206006)(186003)(16526019)(336012)(426003)(47076005)(81166007)(41300700001)(356005)(5660300002)(40460700003)(44832011)(316002)(82740400003)(4326008)(86362001)(2906002)(8936002)(8676002)(82310400005)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 21:26:19.6856
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cc0ad769-4536-4cb2-642c-08db45d3b614
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT114.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4193
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

This is the initial auxiliary driver framework for a new vDPA
device driver, an auxiliary_bus client of the pds_core driver.
The pds_core driver supplies the PCI services for the VF device
and for accessing the adminq in the PF device.

This patch adds the very basics of registering for the auxiliary
device and setting up debugfs entries.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/Makefile          |  1 +
 drivers/vdpa/pds/Makefile      |  8 ++++
 drivers/vdpa/pds/aux_drv.c     | 83 ++++++++++++++++++++++++++++++++++
 drivers/vdpa/pds/aux_drv.h     | 15 ++++++
 drivers/vdpa/pds/debugfs.c     | 25 ++++++++++
 drivers/vdpa/pds/debugfs.h     | 12 +++++
 include/linux/pds/pds_common.h |  2 +
 7 files changed, 146 insertions(+)
 create mode 100644 drivers/vdpa/pds/Makefile
 create mode 100644 drivers/vdpa/pds/aux_drv.c
 create mode 100644 drivers/vdpa/pds/aux_drv.h
 create mode 100644 drivers/vdpa/pds/debugfs.c
 create mode 100644 drivers/vdpa/pds/debugfs.h

diff --git a/drivers/vdpa/Makefile b/drivers/vdpa/Makefile
index 59396ff2a318..8f53c6f3cca7 100644
--- a/drivers/vdpa/Makefile
+++ b/drivers/vdpa/Makefile
@@ -7,3 +7,4 @@ obj-$(CONFIG_MLX5_VDPA) += mlx5/
 obj-$(CONFIG_VP_VDPA)    += virtio_pci/
 obj-$(CONFIG_ALIBABA_ENI_VDPA) += alibaba/
 obj-$(CONFIG_SNET_VDPA) += solidrun/
+obj-$(CONFIG_PDS_VDPA) += pds/
diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
new file mode 100644
index 000000000000..a9cd2f450ae1
--- /dev/null
+++ b/drivers/vdpa/pds/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright(c) 2023 Advanced Micro Devices, Inc
+
+obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
+
+pds_vdpa-y := aux_drv.o
+
+pds_vdpa-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
new file mode 100644
index 000000000000..e4a0ad61ea22
--- /dev/null
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -0,0 +1,83 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/auxiliary_bus.h>
+#include <linux/pci.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+
+#include "aux_drv.h"
+#include "debugfs.h"
+
+static const struct auxiliary_device_id pds_vdpa_id_table[] = {
+	{ .name = PDS_VDPA_DEV_NAME, },
+	{},
+};
+
+static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
+			  const struct auxiliary_device_id *id)
+
+{
+	struct pds_auxiliary_dev *padev =
+		container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
+	struct pds_vdpa_aux *vdpa_aux;
+
+	vdpa_aux = kzalloc(sizeof(*vdpa_aux), GFP_KERNEL);
+	if (!vdpa_aux)
+		return -ENOMEM;
+
+	vdpa_aux->padev = padev;
+	auxiliary_set_drvdata(aux_dev, vdpa_aux);
+
+	return 0;
+}
+
+static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
+{
+	struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
+	struct device *dev = &aux_dev->dev;
+
+	kfree(vdpa_aux);
+	auxiliary_set_drvdata(aux_dev, NULL);
+
+	dev_info(dev, "Removed\n");
+}
+
+static struct auxiliary_driver pds_vdpa_driver = {
+	.name = PDS_DEV_TYPE_VDPA_STR,
+	.probe = pds_vdpa_probe,
+	.remove = pds_vdpa_remove,
+	.id_table = pds_vdpa_id_table,
+};
+
+static void __exit pds_vdpa_cleanup(void)
+{
+	auxiliary_driver_unregister(&pds_vdpa_driver);
+
+	pds_vdpa_debugfs_destroy();
+}
+module_exit(pds_vdpa_cleanup);
+
+static int __init pds_vdpa_init(void)
+{
+	int err;
+
+	pds_vdpa_debugfs_create();
+
+	err = auxiliary_driver_register(&pds_vdpa_driver);
+	if (err) {
+		pr_err("%s: aux driver register failed: %pe\n",
+		       PDS_VDPA_DRV_NAME, ERR_PTR(err));
+		pds_vdpa_debugfs_destroy();
+	}
+
+	return err;
+}
+module_init(pds_vdpa_init);
+
+MODULE_DESCRIPTION(PDS_VDPA_DRV_DESCRIPTION);
+MODULE_AUTHOR("Advanced Micro Devices, Inc");
+MODULE_LICENSE("GPL");
diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
new file mode 100644
index 000000000000..f1e99359424e
--- /dev/null
+++ b/drivers/vdpa/pds/aux_drv.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _AUX_DRV_H_
+#define _AUX_DRV_H_
+
+#define PDS_VDPA_DRV_DESCRIPTION    "AMD/Pensando vDPA VF Device Driver"
+#define PDS_VDPA_DRV_NAME           KBUILD_MODNAME
+
+struct pds_vdpa_aux {
+	struct pds_auxiliary_dev *padev;
+
+	struct dentry *dentry;
+};
+#endif /* _AUX_DRV_H_ */
diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
new file mode 100644
index 000000000000..5be22fb7a76a
--- /dev/null
+++ b/drivers/vdpa/pds/debugfs.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/pci.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+
+#include "aux_drv.h"
+#include "debugfs.h"
+
+static struct dentry *dbfs_dir;
+
+void pds_vdpa_debugfs_create(void)
+{
+	dbfs_dir = debugfs_create_dir(PDS_VDPA_DRV_NAME, NULL);
+}
+
+void pds_vdpa_debugfs_destroy(void)
+{
+	debugfs_remove_recursive(dbfs_dir);
+	dbfs_dir = NULL;
+}
diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
new file mode 100644
index 000000000000..658849591a99
--- /dev/null
+++ b/drivers/vdpa/pds/debugfs.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDS_VDPA_DEBUGFS_H_
+#define _PDS_VDPA_DEBUGFS_H_
+
+#include <linux/debugfs.h>
+
+void pds_vdpa_debugfs_create(void);
+void pds_vdpa_debugfs_destroy(void);
+
+#endif /* _PDS_VDPA_DEBUGFS_H_ */
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 060331486d50..2a0d1669cfd0 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -39,6 +39,8 @@ enum pds_core_vif_types {
 #define PDS_DEV_TYPE_RDMA_STR	"RDMA"
 #define PDS_DEV_TYPE_LM_STR	"LM"
 
+#define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
+
 #define PDS_CORE_IFNAMSIZ		16
 
 /**
-- 
2.17.1


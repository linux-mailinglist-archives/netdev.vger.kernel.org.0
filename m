Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B266F6C5490
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbjCVTLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:11:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjCVTLA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:11:00 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2078.outbound.protection.outlook.com [40.107.212.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAC1956166
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:10:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YxJLqoxl0porhzsm6y0//87A8sqaK1wIEMoMFJEveGdhR7XgDNTj0EngRdFHmqnkNJoI++H2OxM/pgp9EacO7t82Rpmzdz54SLZG1jX7/nh1dKJt/j0KUmE8iPIDF0NjkmvBRAfV6/tobXvtBRpcy3Y2Hki7luj1dsCS2KQocX3yuCKcWeh/zvZDpGkOEEWImDuMBlMPP7WdYybFid1x+H9vXpx3w9MtCYKvM+ZS82GfPKrstJ0ztM2gX5w3BHO34/kPIK7wJGEjv0Yqit5ruQITqrwMNReXJOjspLRm3y3Dmvq6yKvVApDnhehNlrJfV8ZNMrcFXxiCQqTik47o5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QYwIWBnGRCaVAaP0RkkPrcZxBI9REJPJPfdaiLoGuM0=;
 b=cAcvc5Fl0GNVHlq9FUW/Z2gD5YR4qEOAjXGsBUVXNctRysI7LZOFn1106dNLqujmd3S1M1WIRAAeGk9wQlBhYuaUrAK0zfkqKSM2Pu+lrRx/b55LY0Dj+T/o/rGA2YQgxE1aVxMMWhXzC+aUFgBNmTD2tnRig0JvqyHCcrDdSU2/Zh5ljEqkYETIJHmb73dfFwqGsyJNSWgcZWUf/1NhldNz56rPBApF15CTLOIq2YncXCSdQ83sUa+ysRgmkPBXFdJWM0KkclF5h3AMJLgXJxII2GUCcGs6in8sPohWqJ0rvL3JJ2Z+jsnTU1p5NtojNsr0GwKlFS6BiL9PuP9lxA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QYwIWBnGRCaVAaP0RkkPrcZxBI9REJPJPfdaiLoGuM0=;
 b=ZyLiD4XLCkDRMOGHTxz1EEoBN+GBVg7XuWmexeResxYj5nAZIOUxN9yA+35yTT38BJacYFFIpqpm34BS7E401YPe8Y+xGNnluxmophyP+KvaVhGWnZBeTAvhfVpOk4Va9KyZvll7/mcubUnSusR1eHsw2wWrD2UwBEES0EKXMYc=
Received: from DS7PR03CA0297.namprd03.prod.outlook.com (2603:10b6:5:3ad::32)
 by CY8PR12MB7588.namprd12.prod.outlook.com (2603:10b6:930:9b::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:10:56 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::fe) by DS7PR03CA0297.outlook.office365.com
 (2603:10b6:5:3ad::32) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 19:10:56 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 19:10:56 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 14:10:54 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v3 virtio 2/8] pds_vdpa: Add new vDPA driver for AMD/Pensando DSC
Date:   Wed, 22 Mar 2023 12:10:32 -0700
Message-ID: <20230322191038.44037-3-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230322191038.44037-1-shannon.nelson@amd.com>
References: <20230322191038.44037-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|CY8PR12MB7588:EE_
X-MS-Office365-Filtering-Correlation-Id: e14bdba5-8cce-4b9c-aa4a-08db2b0929fb
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ewfb8r6dQhMix+wTh1xSaG+KbjRLzoQG216GA1CWMJK3PRv2ftzTwQBB27hjXzr5nGTyFvbmrzZlv5ns6Ryq8gL1BRAVW4SF+aQuF/Jp2l39SgSgdZ626csjDsZAp6HoFl95rVm6ulax7uovTjUjeRq3uqiLrhVO6ueW7PQoYQ8hRFNo41o5SFcF2ge7GLqdYgsvpd+eA7Zo7X5AhxpsQOGpmvjqBUJef/Niuk+lNUUok9lLBBXPCygP0XW73Y3A1TM1qs/Leu9GeoZMeEDdBPsJDa++WuS/ixkZIrBdWunMudAPQLkEZMwuvvD499XcxN8DglTQiEB+ldDtMl18DFpXFg8FaapCuzcjUGW9BvrOgExcsAZOjgUKpFP6IlXENzg2zJc6AZ5rgY1PAdGK4CpwFRYB3SmXW1ehz0BxyNd09PPhM4QD1dFl8Q0vdOQkTc/jnVSKpS3TYqcT8+zHO8KgNVhbPNj1UyzhFQpyiCdHrfxmcAodoDkjRbcIEZXPxfZTgcW6j5aJl6LxuyKSRq5F9vcKZ4SWpzJloRu2PdCHZbjH30JLmI1wXFIYgtsysay6jsWCzPBXe6Oy3QSJOaqLioY93dNEQlnTM2rdLkfSSPoy4n67EPQVqChdk4Nn++UEXQ1/dICwwpHfZkV07FNEsoVzxD8QHIy6g2f/qf7EMZT+YTq+N9BBz6DuSAiKfWc10RAL4JPTjyRu6QYkwREoIJN019IedKqeIcvbYKM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(376002)(39860400002)(346002)(451199018)(46966006)(36840700001)(40470700004)(426003)(186003)(47076005)(6666004)(336012)(16526019)(478600001)(26005)(83380400001)(8676002)(110136005)(2616005)(316002)(70586007)(70206006)(8936002)(5660300002)(40480700001)(41300700001)(82740400003)(81166007)(1076003)(4326008)(36860700001)(2906002)(40460700003)(356005)(86362001)(36756003)(82310400005)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 19:10:56.0241
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e14bdba5-8cce-4b9c-aa4a-08db2b0929fb
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7588
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
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
---
 drivers/vdpa/Makefile        |  1 +
 drivers/vdpa/pds/Makefile    |  8 ++++
 drivers/vdpa/pds/aux_drv.c   | 84 ++++++++++++++++++++++++++++++++++++
 drivers/vdpa/pds/aux_drv.h   | 15 +++++++
 drivers/vdpa/pds/debugfs.c   | 29 +++++++++++++
 drivers/vdpa/pds/debugfs.h   | 18 ++++++++
 include/linux/pds/pds_vdpa.h | 10 +++++
 7 files changed, 165 insertions(+)
 create mode 100644 drivers/vdpa/pds/Makefile
 create mode 100644 drivers/vdpa/pds/aux_drv.c
 create mode 100644 drivers/vdpa/pds/aux_drv.h
 create mode 100644 drivers/vdpa/pds/debugfs.c
 create mode 100644 drivers/vdpa/pds/debugfs.h
 create mode 100644 include/linux/pds/pds_vdpa.h

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
index 000000000000..39c03f067b77
--- /dev/null
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -0,0 +1,84 @@
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
+#include <linux/pds/pds_vdpa.h>
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
index 000000000000..14e465944dfd
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
+#define PDS_VDPA_DRV_NAME           "pds_vdpa"
+
+struct pds_vdpa_aux {
+	struct pds_auxiliary_dev *padev;
+
+	struct dentry *dentry;
+};
+#endif /* _AUX_DRV_H_ */
diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
new file mode 100644
index 000000000000..12e844f96ccc
--- /dev/null
+++ b/drivers/vdpa/pds/debugfs.c
@@ -0,0 +1,29 @@
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
+#ifdef CONFIG_DEBUG_FS
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
+
+#endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/vdpa/pds/debugfs.h b/drivers/vdpa/pds/debugfs.h
new file mode 100644
index 000000000000..fff078a869e5
--- /dev/null
+++ b/drivers/vdpa/pds/debugfs.h
@@ -0,0 +1,18 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDS_VDPA_DEBUGFS_H_
+#define _PDS_VDPA_DEBUGFS_H_
+
+#include <linux/debugfs.h>
+
+#ifdef CONFIG_DEBUG_FS
+
+void pds_vdpa_debugfs_create(void);
+void pds_vdpa_debugfs_destroy(void);
+#else
+static inline void pds_vdpa_debugfs_create(void) { }
+static inline void pds_vdpa_debugfs_destroy(void) { }
+#endif
+
+#endif /* _PDS_VDPA_DEBUGFS_H_ */
diff --git a/include/linux/pds/pds_vdpa.h b/include/linux/pds/pds_vdpa.h
new file mode 100644
index 000000000000..d3414536985d
--- /dev/null
+++ b/include/linux/pds/pds_vdpa.h
@@ -0,0 +1,10 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDS_VDPA_H_
+#define _PDS_VDPA_H_
+
+#define PDS_DEV_TYPE_VDPA_STR	"vDPA"
+#define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
+
+#endif /* _PDS_VDPA_H_ */
-- 
2.17.1


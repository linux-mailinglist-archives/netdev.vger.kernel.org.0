Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 459486B18C3
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 02:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbjCIBbl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 20:31:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjCIBbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 20:31:34 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2055.outbound.protection.outlook.com [40.107.223.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 262CD94397
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 17:31:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CuZkT8EKgMgwmbtetkXtGEvmvC8DmdDIMT1eBdzevYO7QZOZ/oBoKmEF+Br7a2818WEqGdR1ySsqwGNHaVYp3W7h5nbJBWyoz+n7ly24R3D5oUHFFi9m9xYo5NG3F2XFdSrd6SRul5FzA9KE0EDLfdzT3AcbKfl3bBi00rWgKAm1YKMxY78Acu4W7vmiTKbpJ5dfCfvVfjSNAkq06f3I61VOpG4N4FCAZo2KEx1ERrIFU5T5OKK9A3oD9BkoClzh+gC6TnHHY0FpTH3VEWBt9Chm1HapjiTQC4tLHg5oPFaLqz3TTtLX8dLc1WefHZzwiz8wofdG6c08+XvvTiFTbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N6r3LOs18LEl+8qCDQg2zhXaO8hz2HKSyiOCJEjDmEs=;
 b=f/XPO8g77B3pjDA8cRmlXYEtylwsMW+GkzmGo/8lmtKpZG3AnCkFkmUgr7YSweDeDosGzdTAqU70j7pGU+FGnrMZVppasVV9X8hYge8zD5hFUXP3k+6o6fvWobJ/tzoIHHEJBVlyFudCbC2cnGgOQG4T6SPM8TvgPhVvoZ0+ajeSlCuXUJ9MQAYcrPi13yrjJgsI69qHr6LIoYESKhBrlqiRweXCyIdJsMiLKrXaZmbUMs7Ph6rmuy+yW1BtaSzC6e3X8zd97KCyLDi99z0xCbav5C/m5d3MLiRKAdkLG+2tr6Us9H+urVDBntyQ7Ir2twiv7l2DXtFpS/HBTf/4cw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N6r3LOs18LEl+8qCDQg2zhXaO8hz2HKSyiOCJEjDmEs=;
 b=zLd/2ET7SJIPY+14Q09fQbcglXbyoPLENBGt6D/lHf8u6RwzeSWxZPpukVmmjDocMMAAMqWaGyCH0PnpLt+aQZ70JoLFlFJUC6TsxieguHi0bUEy9L1tgwk2GHoUQUnt6oTZSkvoILAgUxrE8fZBzA9bkQxuQh9laIWHU2unmog=
Received: from BN9PR03CA0351.namprd03.prod.outlook.com (2603:10b6:408:f6::26)
 by IA0PR12MB7700.namprd12.prod.outlook.com (2603:10b6:208:430::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Thu, 9 Mar
 2023 01:31:27 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::cc) by BN9PR03CA0351.outlook.office365.com
 (2603:10b6:408:f6::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Thu, 9 Mar 2023 01:31:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Thu, 9 Mar 2023 01:31:27 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Mar
 2023 19:31:23 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH RFC v2 virtio 1/7] pds_vdpa: Add new vDPA driver for AMD/Pensando DSC
Date:   Wed, 8 Mar 2023 17:30:40 -0800
Message-ID: <20230309013046.23523-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230309013046.23523-1-shannon.nelson@amd.com>
References: <20230309013046.23523-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT047:EE_|IA0PR12MB7700:EE_
X-MS-Office365-Filtering-Correlation-Id: f6971bcb-9b5c-4059-1b7b-08db203e00d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DazaTpG3P9bkKhin/xmFstXatyjEzUzVXGvB+a4tGe+61uvRYGH/N1UfV5EpQ2jCfKFbkAkhxwIXbgC7U0HnSh2fs8ilFOP7v3gaBER/MLhZN4aM/PaLIlJJwwOSNec05FcedGRRMqqSDehD1PU+Lg8Hl3YNGir7IYtdezJ1DamNXOmYcuP8TJI7KyymLOidoAkd5iVXS441RAFZRuIwHYc6rvRQnPd4d/qWp8eBaRk/4oK3NVtJ6IytbtzHRBQKZ37IeEAyOMW/L4K14ZpP6YTGP9Czi0zgl18hJeXp9J9DMxUBQrcDCr3Oz3rqSGYAPEwPasJuqc2Yaxtw8g8uPyB9m2gTQn4ILMRafHcmCirXVLh3ptrWousd5o5KrKEyHSdOO5+taTmxiY4039xqJBu8h5dn9xse3wUVkrJPXvC5yCt1Ops6XKItxL7N69Tj7e2FUBJU6sTBVEUClLYLNEN+biyPrDojbgOWx3n+gDNbKwqTAXosTC2k/fPu1hpkJm5WnyOb8v1elbTh/+jl/g5S0Kj1Fghe40nnPRUiosYd0PSukZkx4bABzSuOX24I906nI8KeIyqcNKW30mXoi5s51A995WirtEX5/24PIUn1umP0ge69NQTp7ujKpMtRgKRGjPtPXwi1eGKggqWoncxRiZxUmn2tVsjnFpWaAY0EPsAXjWd4A/q7A2NVGhMmVfooH+usGTHuu9z7lgcaJwu2b6kVPVBIxRqccrPQxOA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(376002)(451199018)(40470700004)(36840700001)(46966006)(36756003)(41300700001)(8676002)(70206006)(4326008)(8936002)(70586007)(5660300002)(44832011)(2906002)(82740400003)(81166007)(36860700001)(40480700001)(356005)(86362001)(316002)(478600001)(6666004)(1076003)(110136005)(47076005)(82310400005)(40460700003)(426003)(83380400001)(2616005)(16526019)(186003)(336012)(26005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 01:31:27.6681
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: f6971bcb-9b5c-4059-1b7b-08db203e00d6
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB7700
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
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
device, setting up debugfs entries, and registering with devlink.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vdpa/Makefile        |  1 +
 drivers/vdpa/pds/Makefile    |  8 +++
 drivers/vdpa/pds/aux_drv.c   | 99 ++++++++++++++++++++++++++++++++++++
 drivers/vdpa/pds/aux_drv.h   | 15 ++++++
 drivers/vdpa/pds/debugfs.c   | 25 +++++++++
 drivers/vdpa/pds/debugfs.h   | 18 +++++++
 include/linux/pds/pds_vdpa.h | 12 +++++
 7 files changed, 178 insertions(+)
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
index 000000000000..b3f36170253c
--- /dev/null
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -0,0 +1,99 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/auxiliary_bus.h>
+
+#include <linux/pds/pds_core.h>
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
+	struct device *dev = &aux_dev->dev;
+	struct pds_vdpa_aux *vdpa_aux;
+	int err;
+
+	vdpa_aux = kzalloc(sizeof(*vdpa_aux), GFP_KERNEL);
+	if (!vdpa_aux)
+		return -ENOMEM;
+
+	vdpa_aux->padev = padev;
+	auxiliary_set_drvdata(aux_dev, vdpa_aux);
+
+	/* Register our PDS client with the pds_core */
+	err = padev->ops->register_client(padev);
+	if (err) {
+		dev_err(dev, "%s: Failed to register as client: %pe\n",
+			__func__, ERR_PTR(err));
+		goto err_free_mem;
+	}
+
+	return 0;
+
+err_free_mem:
+	kfree(vdpa_aux);
+	auxiliary_set_drvdata(aux_dev, NULL);
+
+	return err;
+}
+
+static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
+{
+	struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
+	struct device *dev = &aux_dev->dev;
+
+	vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
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
+MODULE_AUTHOR("AMD/Pensando Systems, Inc");
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
index 000000000000..3c163dc7b66f
--- /dev/null
+++ b/drivers/vdpa/pds/debugfs.c
@@ -0,0 +1,25 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/pds/pds_core.h>
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
index 000000000000..b5154e3b298e
--- /dev/null
+++ b/include/linux/pds/pds_vdpa.h
@@ -0,0 +1,12 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDS_VDPA_IF_H_
+#define _PDS_VDPA_IF_H_
+
+#include <linux/pds/pds_common.h>
+
+#define PDS_DEV_TYPE_VDPA_STR	"vDPA"
+#define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
+
+#endif /* _PDS_VDPA_IF_H_ */
-- 
2.17.1


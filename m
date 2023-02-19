Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7941169BF24
	for <lists+netdev@lfdr.de>; Sun, 19 Feb 2023 09:40:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbjBSIjp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Feb 2023 03:39:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBSIjl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Feb 2023 03:39:41 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2062.outbound.protection.outlook.com [40.107.93.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A67910A92;
        Sun, 19 Feb 2023 00:39:38 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYFJBbQQldI2Ap9S+koslgCW/cBHDVkgADLVc2BCvCtlI0xb6rJB0Dx20d8R6o8FHR+pf57BwDGB41L/wibTxFLHueSag0D7wpnAywIt2leaTodmVf3gNlVSk+aY1iPx6ZLWvz+UBlcLhAAiB0LXZAMgiF1xWXs3Yc1xlF8tBhP4hDxbhWMN7/33cyGCwjgGhVUkFYGRNi197B7z8015WOA9wE0203Bh2kzFG4HvXtJsfQLh8UKzl5lETHKCqjHjDoltU5kJ153hgWfqLiKrhtteNmWfktFpEZ67KYkDBhQiAEw4R1pBqlKPhL2pwBMMvn5tTVkSyXoBRlWSzLkXIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yVEi2gyRLTTrIVYo/HaEtSd6fFFSk2jl0LISrkNj4gM=;
 b=VwEA7RHJCbfdCbmc86FO0McHKdc68KhWwf8wjTXlWjR5ckMxjIMaZhTE/CMMB72/SN8HLHTZWVgFZtfVquD7PWpaAEcgZjwIr/I14yjw+/Jf0nBcphLx90LAdXmAc9+bMOna+ItvWotP0DyCNc3zpwUAkmhS51IZiIgeyMoFs7FXKTeOT1x+mlhIOFBxlS/jUT98wNisNC7EWCovqDVaGjA/9CH6H9xRIvHImH3dQPY+gbdGiCxJk+RnDP42jFfi3ZnFRJkgKXbEZHWogjrAgr4SODYLuVXrXq9cv/7w0xkIv+VfP6yinyZoLcJDWgNCccwuZB89YRageV2LTvprbQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yVEi2gyRLTTrIVYo/HaEtSd6fFFSk2jl0LISrkNj4gM=;
 b=rRGkCPsEmuJ9cnSJGVfIgtlVP9Dg/tV8SOOF966+31D25qXDV3P0ySJDzNkAb1u5JwLZU8NCGN99ilRkxqkFdRLtIIOpyCCH1w/FPGxdistli59Ibdueah81NdDL8WiRq4urHuu7R965cEHbmd80iqHB02OW7PhGwVYlOSnNNrI=
Received: from MWH0EPF000554DF.namprd21.prod.outlook.com
 (2603:10b6:30f:fff2:0:1:0:4) by PH0PR12MB7485.namprd12.prod.outlook.com
 (2603:10b6:510:1e9::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.18; Sun, 19 Feb
 2023 08:39:33 +0000
Received: from CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2a01:111:f400:7eab::204) by MWH0EPF000554DF.outlook.office365.com
 (2603:1036:d20::b) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.5 via Frontend
 Transport; Sun, 19 Feb 2023 08:39:33 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT089.mail.protection.outlook.com (10.13.175.179) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6111.18 via Frontend Transport; Sun, 19 Feb 2023 08:39:32 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Sun, 19 Feb
 2023 02:39:30 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        <brett.creeley@amd.com>
Subject: [PATCH v3 2/7] vfio/pds: Add support to register as PDS client
Date:   Sun, 19 Feb 2023 00:39:03 -0800
Message-ID: <20230219083908.40013-3-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230219083908.40013-1-brett.creeley@amd.com>
References: <20230219083908.40013-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT089:EE_|PH0PR12MB7485:EE_
X-MS-Office365-Filtering-Correlation-Id: 74be17a7-f577-48d2-e5a8-08db1254d2ce
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: soQAdDH59VVSBlSeYTy/VPmDhokt6jzT6i2sTU3A0h1UmfO1rrA1Uol+kJR9g+Jhfpz4pcziXQBXgyp5BqCtJKseVVzeqaJevUqKckUPeCLDWYKdi0r0KLVimpGrbtLrmFleH9iwgEH5+BtBrD4qC39ihQVVjwGc3gfLcM0nqtizUImmud6GcsaFzQQFRJ2MIDOZgJCz9c5+eBWJpdeETdE/RQkjVV/E3xVfKdTAzAU5MLccxgOOnOkhiGDFfAMPGtt7/48Dm1u5OaiFwuSk+t/U+5tG1KPvEyXlKaxp9b36aALc2wrmlT5ZTjZwFkWgQgYtpk5MN1hDV0K7UuzfMgOVk8bshgibgFnD1yRbOH6aRCIhYISqYxepxwc/Z5eTreyOH4PjZ3VfStxH3m12jezykjYNcFyoor1hIbCjx4wVbGpLWFyMMZdGRDcKSjGRNzLkaxxWzod9KXIY8CrhMxkonHrPXjUewn6KMcPZBSxph1QTP3xjqKeA3FXG/coS2Y3TAq2hnH8KWJ2ECQopgKExEMUaEV56GpDzMu5zExSg07PdGExSQhCf20x5xT3LcmUSjxASUxJGEdg1Cxbkip6tg/V09CoDHVayjBVCpDb/dcONeCavvCTiufFzQALhxvGnAQrJNvOCFy5bF8G5sH0qxwVEBxbH8M8zTb25hGgwDk/X24oOKPM6Jt0GkHJ7k1hsxi1AHNlTEJ74S5CUvj889B6+0u7QT6h8JK8KXzI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(376002)(136003)(346002)(396003)(39860400002)(451199018)(36840700001)(40470700004)(46966006)(26005)(6666004)(1076003)(186003)(16526019)(54906003)(110136005)(478600001)(82310400005)(30864003)(8936002)(44832011)(40460700003)(36756003)(356005)(2906002)(82740400003)(81166007)(83380400001)(316002)(40480700001)(5660300002)(41300700001)(70586007)(70206006)(8676002)(4326008)(47076005)(86362001)(426003)(336012)(2616005)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Feb 2023 08:39:32.4665
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 74be17a7-f577-48d2-e5a8-08db1254d2ce
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB7485
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The pds_core driver will create auxiliary devices for each PCI device
supported by pds_vfio. In order to communicate with the device, the
pds_vfio driver needs to register as an auxiliary driver for the
previously mentioned auxiliary device. Once the auxiliary device
is probed, the pds_vfio driver can send admin queue commands and
receive events from the device by way of pds_core.

Use the following commands to enable a VF and tell pds_core to
create its corresponding auxiliary device:

echo 1 > /sys/bus/pci/drivers/pds_core/$PF_BDF/sriov_numvfs
devlink dev param set pci/$PF_BDF name enable_migration value true cmode runtime

This functionality is needed to support live migration commands, which
are added later in the series.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/Makefile   |   2 +
 drivers/vfio/pci/pds/aux_drv.c  | 148 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/aux_drv.h  |  27 ++++++
 drivers/vfio/pci/pds/cmds.c     |  30 +++++++
 drivers/vfio/pci/pds/cmds.h     |  14 +++
 drivers/vfio/pci/pds/pci_drv.c  |  17 ++++
 drivers/vfio/pci/pds/pci_drv.h  |  14 +++
 drivers/vfio/pci/pds/vfio_dev.c |   6 ++
 drivers/vfio/pci/pds/vfio_dev.h |   1 +
 include/linux/pds/pds_lm.h      |  12 +++
 10 files changed, 271 insertions(+)
 create mode 100644 drivers/vfio/pci/pds/aux_drv.c
 create mode 100644 drivers/vfio/pci/pds/aux_drv.h
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h
 create mode 100644 include/linux/pds/pds_lm.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
index e1a55ae0f079..92cc392fd487 100644
--- a/drivers/vfio/pci/pds/Makefile
+++ b/drivers/vfio/pci/pds/Makefile
@@ -4,5 +4,7 @@
 obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
 
 pds_vfio-y := \
+	aux_drv.o	\
+	cmds.o		\
 	pci_drv.o	\
 	vfio_dev.o
diff --git a/drivers/vfio/pci/pds/aux_drv.c b/drivers/vfio/pci/pds/aux_drv.c
new file mode 100644
index 000000000000..eda262e7d895
--- /dev/null
+++ b/drivers/vfio/pci/pds/aux_drv.c
@@ -0,0 +1,148 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/auxiliary_bus.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+#include <linux/pds/pds_lm.h>
+
+#include "aux_drv.h"
+#include "vfio_dev.h"
+#include "pci_drv.h"
+#include "cmds.h"
+
+static const
+struct auxiliary_device_id pds_vfio_aux_id_table[] = {
+	{ .name = PDS_LM_DEV_NAME, },
+	{},
+};
+
+static void
+pds_vfio_aux_notify_handler(struct pds_auxiliary_dev *padev,
+			    union pds_core_notifyq_comp *event)
+{
+	struct device *dev = &padev->aux_dev.dev;
+	u16 ecode = le16_to_cpu(event->ecode);
+
+	dev_dbg(dev, "%s: event code %d\n", __func__, ecode);
+}
+
+static int
+pds_vfio_aux_probe(struct auxiliary_device *aux_dev,
+		   const struct auxiliary_device_id *id)
+
+{
+	struct pds_auxiliary_dev *padev =
+		container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
+	struct pds_vfio_pci_device *pds_vfio;
+	struct device *dev = &aux_dev->dev;
+	struct pds_vfio_aux *vfio_aux;
+	struct pci_dev *pdev;
+	struct pci_bus *bus;
+	int busnr;
+	u16 devfn;
+	int err;
+
+	/* Find our VF PCI device */
+	busnr = PCI_BUS_NUM(padev->id);
+	devfn = padev->id & 0xff;
+	bus = pci_find_bus(0, busnr);
+	pdev = pci_get_slot(bus, devfn);
+
+	if (!pds_vfio_is_vfio_pci_driver(pdev)) {
+		dev_dbg(&aux_dev->dev, "unbind %s from %s driver and bind to %s driver for live migration support\n",
+			pci_name(pdev), dev_driver_string(&pdev->dev), PDS_VFIO_DRV_NAME);
+		return -EPROBE_DEFER;
+	}
+
+	pds_vfio = pci_get_drvdata(pdev);
+	if (!pds_vfio) {
+		dev_dbg(&pdev->dev, "PCI device not probed yet, defer until PCI device is probed by %s driver\n",
+			PDS_VFIO_DRV_NAME);
+		return -EPROBE_DEFER;
+	}
+
+	vfio_aux = kzalloc(sizeof(*vfio_aux), GFP_KERNEL);
+	if (!vfio_aux)
+		return -ENOMEM;
+
+	vfio_aux->padev = padev;
+	vfio_aux->pds_vfio = pds_vfio;
+	auxiliary_set_drvdata(aux_dev, vfio_aux);
+
+	dev_dbg(dev, "%s: id %#04x busnr %#x devfn %#x bus %p pds_vfio %p\n",
+		__func__, padev->id, busnr, devfn, bus, vfio_aux->pds_vfio);
+
+	vfio_aux->pds_vfio->vfio_aux = vfio_aux;
+
+	vfio_aux->padrv.event_handler = pds_vfio_aux_notify_handler;
+	err = pds_vfio_register_client_cmd(vfio_aux->pds_vfio);
+	if (err) {
+		dev_err(dev, "failed to register as client: %pe\n",
+			ERR_PTR(err));
+		goto err_out;
+	}
+
+	return 0;
+
+err_out:
+	auxiliary_set_drvdata(aux_dev, NULL);
+	kfree(vfio_aux);
+
+	return err;
+}
+
+static void
+pds_vfio_aux_remove(struct auxiliary_device *aux_dev)
+{
+	struct pds_vfio_aux *vfio_aux = auxiliary_get_drvdata(aux_dev);
+	struct pds_vfio_pci_device *pds_vfio = vfio_aux->pds_vfio;
+
+	if (pds_vfio) {
+		pds_vfio_unregister_client_cmd(pds_vfio);
+		vfio_aux->pds_vfio->vfio_aux = NULL;
+		pci_dev_put(pds_vfio->pdev);
+	}
+
+	kfree(vfio_aux);
+	auxiliary_set_drvdata(aux_dev, NULL);
+}
+
+static struct auxiliary_driver
+pds_vfio_aux_driver = {
+	.name = PDS_DEV_TYPE_LM_STR,
+	.probe = pds_vfio_aux_probe,
+	.remove = pds_vfio_aux_remove,
+	.id_table = pds_vfio_aux_id_table,
+};
+
+struct auxiliary_driver *
+pds_vfio_aux_driver_info(void)
+{
+	return &pds_vfio_aux_driver;
+}
+
+static int
+pds_vfio_aux_match_id(struct device *dev, const void *data)
+{
+	dev_dbg(dev, "%s: %s\n", __func__, (char *)data);
+	return !strcmp(dev_name(dev), data);
+}
+
+struct pds_vfio_aux *
+pds_vfio_aux_get_drvdata(int vf_pci_id)
+{
+	struct auxiliary_device *aux_dev;
+	char name[32];
+
+	snprintf(name, sizeof(name), "%s.%d", PDS_LM_DEV_NAME, vf_pci_id);
+	aux_dev = auxiliary_find_device(NULL, name, pds_vfio_aux_match_id);
+	if (!aux_dev)
+		return NULL;
+
+	return auxiliary_get_drvdata(aux_dev);
+}
diff --git a/drivers/vfio/pci/pds/aux_drv.h b/drivers/vfio/pci/pds/aux_drv.h
new file mode 100644
index 000000000000..be5948575a0c
--- /dev/null
+++ b/drivers/vfio/pci/pds/aux_drv.h
@@ -0,0 +1,27 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _AUX_DRV_H_
+#define _AUX_DRV_H_
+
+#include <linux/auxiliary_bus.h>
+
+#include <linux/pds/pds_intr.h>
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+
+struct pds_vfio_pci_device;
+
+struct pds_vfio_aux {
+	struct pds_auxiliary_dev *padev;
+	struct pds_auxiliary_drv padrv;
+	struct pds_vfio_pci_device *pds_vfio;
+};
+
+struct auxiliary_driver *
+pds_vfio_aux_driver_info(void);
+struct pds_vfio_aux *
+pds_vfio_aux_get_drvdata(int vf_pci_id);
+
+#endif /* _AUX_DRV_H_ */
diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
new file mode 100644
index 000000000000..6ac39703cb54
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/io.h>
+#include <linux/types.h>
+
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+
+#include "vfio_dev.h"
+#include "aux_drv.h"
+#include "cmds.h"
+
+int
+pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pds_vfio_aux *vfio_aux = pds_vfio->vfio_aux;
+	struct pds_auxiliary_dev *padev = vfio_aux->padev;
+
+	return padev->ops->register_client(padev, &vfio_aux->padrv);
+}
+
+void
+pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pds_auxiliary_dev *padev = pds_vfio->vfio_aux->padev;
+
+	padev->ops->unregister_client(padev);
+}
diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
new file mode 100644
index 000000000000..eb39a3ad5089
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.h
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _CMDS_H_
+#define _CMDS_H_
+
+struct pds_vfio_pci_device;
+
+int
+pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
+void
+pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
+
+#endif /* _CMDS_H_ */
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index 96e155598a50..3861a80c4706 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -11,6 +11,8 @@
 #include <linux/pds/pds_core_if.h>
 
 #include "vfio_dev.h"
+#include "aux_drv.h"
+#include "pci_drv.h"
 
 #define PDS_VFIO_DRV_NAME		"pds_vfio"
 #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
@@ -67,9 +69,17 @@ pds_vfio_pci_driver = {
 	.driver_managed_dma = true,
 };
 
+bool
+pds_vfio_is_vfio_pci_driver(struct pci_dev *pdev)
+{
+	return (to_pci_driver(pdev->dev.driver) == &pds_vfio_pci_driver);
+}
+
 static void __exit
 pds_vfio_pci_cleanup(void)
 {
+	auxiliary_driver_unregister(pds_vfio_aux_driver_info());
+
 	pci_unregister_driver(&pds_vfio_pci_driver);
 }
 module_exit(pds_vfio_pci_cleanup);
@@ -85,6 +95,13 @@ pds_vfio_pci_init(void)
 		return err;
 	}
 
+	err = auxiliary_driver_register(pds_vfio_aux_driver_info());
+	if (err) {
+		pr_err("aux driver register failed: %pe\n", ERR_PTR(err));
+		pci_unregister_driver(&pds_vfio_pci_driver);
+		return err;
+	}
+
 	return 0;
 }
 module_init(pds_vfio_pci_init);
diff --git a/drivers/vfio/pci/pds/pci_drv.h b/drivers/vfio/pci/pds/pci_drv.h
new file mode 100644
index 000000000000..3394715bfe7b
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.h
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _PCI_DRV_H
+#define _PCI_DRV_H
+
+#include <linux/pci.h>
+
+#define PDS_VFIO_DRV_NAME	"pds_vfio"
+
+bool
+pds_vfio_is_vfio_pci_driver(struct pci_dev *pdev);
+
+#endif /* _PCI_DRV_H */
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index f1221f14e4f6..e882276f9788 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -5,6 +5,7 @@
 #include <linux/vfio_pci_core.h>
 
 #include "vfio_dev.h"
+#include "aux_drv.h"
 
 struct pds_vfio_pci_device *
 pds_vfio_pci_drvdata(struct pci_dev *pdev)
@@ -31,6 +32,11 @@ pds_vfio_init_device(struct vfio_device *vdev)
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
index 4d497695c4e9..48083002d1ad 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -10,6 +10,7 @@
 struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
 	struct pci_dev *pdev;
+	struct pds_vfio_aux *vfio_aux;
 
 	int vf_id;
 	int pci_id;
diff --git a/include/linux/pds/pds_lm.h b/include/linux/pds/pds_lm.h
new file mode 100644
index 000000000000..fdaf2bf71d35
--- /dev/null
+++ b/include/linux/pds/pds_lm.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
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


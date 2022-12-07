Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5481C6450BB
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 02:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiLGBHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 20:07:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbiLGBHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 20:07:32 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2053.outbound.protection.outlook.com [40.107.237.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 183964FF88;
        Tue,  6 Dec 2022 17:07:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ay4efvK9RfaxJvGJPvWu7JU+elMYm2Smt9g6DEv4M4ty+f80OH7lBu+pqM0k/Y9z/Pu2FSc9MO+D28MxQHgVRt6lXpkw0lpNqK/jh/blFzuyTUIzfA3ueN63raoxoLJ7o5Zfyy7C+hCKG5Ix3tneDfVnnE2IyzIJRqRb9g64jM0ZD/IzFv1A9bnFKSHtIKbr75UhCSOFr5jrtv7RJIJJqlf25ZCwjvA2MASWvsgtvspeT2w9ageaLx8YXkOzyjxC/mmfE9i1bBnzqjLsoMaJdENoMozcpxKKiDVGPRXeauk4wzHAyWj70erNdTM+Wp8ppmop5wrU4bE398nkufdntQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OV0yLUkg9HSDKpBTB1o4VoXRKlMFABjsV7Nm3cjUAL8=;
 b=f4SwP1QfpPDHNZRPL3Gj45pghBg52LPM2DUp/haJ7vdAMH5Jo1w81lMwpZ8M7EobGjCyjRhh7APp9NDRGKCWJeHfaVLc79DlWtcFGib7o2QA2NYIn49d/aAG4Wrv4gwpYMAYfJTQ1Dgxj9yFdkBF+F5oFr7baZRUZq17ACGiPErGswHsGtqvYW+URwpu7XgL3n4I2M1WH77SzuH0jX3cLklUYQqPBM2s7NEjTil+psntwPJp8MbNkgEaH/n9AHn1dzDfAIA14A9r7GniLC+XVc6790gm/73q4ApK1KwehCAq2Bk+3uiu/XFhZDPGqnC64t6zKlnEM+Xk8WlZC1QwUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OV0yLUkg9HSDKpBTB1o4VoXRKlMFABjsV7Nm3cjUAL8=;
 b=sLh4oEDwzamPCQko7IiZHUJBUGfyFst7lkmg0uobDcic+lG9T2v4szxh9PDsz7GRBK6kKNRHVHj0WHATssVaODrLj1Q4yJ5w0nlpWVmDfQ+2oMLBFuZe34n8ogXWfxjLqqu8VnuVyRbSsKvbr8xR326YgzhzJr14O5yPP9j2GKo=
Received: from MW4PR03CA0159.namprd03.prod.outlook.com (2603:10b6:303:8d::14)
 by SN7PR12MB6813.namprd12.prod.outlook.com (2603:10b6:806:267::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 01:07:27 +0000
Received: from CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8d:cafe::40) by MW4PR03CA0159.outlook.office365.com
 (2603:10b6:303:8d::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 01:07:27 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT021.mail.protection.outlook.com (10.13.175.51) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 01:07:26 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 19:07:25 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <cohuck@redhat.com>,
        <jgg@nvidia.com>, <yishaih@nvidia.com>,
        <shameerali.kolothum.thodi@huawei.com>, <kevin.tian@intel.com>
CC:     <shannon.nelson@amd.com>, <drivers@pensando.io>,
        Brett Creeley <brett.creeley@amd.com>
Subject: [RFC PATCH vfio 2/7] vfio/pds: Add support to register as PDS client
Date:   Tue, 6 Dec 2022 17:07:00 -0800
Message-ID: <20221207010705.35128-3-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207010705.35128-1-brett.creeley@amd.com>
References: <20221207010705.35128-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT021:EE_|SN7PR12MB6813:EE_
X-MS-Office365-Filtering-Correlation-Id: edeb6a13-fe02-4243-e782-08dad7ef6832
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2WH81829G3u+nmYs6/9ZWQ+sjazqn6RnsxV53mphRHbUurfhTntRVlwe3EKrrF2f10eM52CA/3/ZJk+WV1aLzTJ0jNgGimECqvtn8QvDx4L0kYtDDvKH0nLa8sglE+nt4z+2luNVbaOq+Kvlg6bTOQlD8zNv5MtP6E2/Mrx3GBc/1IhcT64hckwqFLkpUlhu5tBO2CqSPCuH0pP4CtRQ/HQc7cvkJEfeo2clVfMmMGrHWK/XtKGsTkVPHcFLFAt4Qt6iq3TuA/f6rOrtzua48NsK9pTIjXxjQp4JDrbOl83TAGg1bWjvnDpLctHEch5rxn0sk9F3h9IGjtM2eRgyUqOza9wdobFgaQ007/3heLN/89T+1+PjuKnysIfRoSmcWp/RP0v+Aipt/zOkn4MFSGUavbt8QH/GqBbd+20mYO3AMatEm4N5vNpYBSfkqPi2E/5FZxoAm1lIFx+djMBp3T2j84Qo9RdZDYRm+9d1nJoR73NyEI/kRwZvTs8N4Biw0PbkJGTQsdzIATSRLGBZPKXiFv6dxMpcXBI+O7ocszJMt+8nD2Dx1/NzXnIljOQuFH2i9rqI4ZXkXHPVDTIa43/1lA0upzUDH8fe8hxaMbeKkolHw4o0He9L9+Khl+naQ/bc2r+GjLJeuweXBVhDGbOou4fcq7/6MNvd5SH1Pp6AFFpyD0X1vduztKWaFjEQLUZ3Zxe6woyMrDFo7n/vxUM6CuZK7VKx0gmXvmnP8XU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(136003)(396003)(346002)(39860400002)(451199015)(40470700004)(36840700001)(46966006)(40480700001)(41300700001)(81166007)(356005)(5660300002)(30864003)(44832011)(8936002)(70586007)(186003)(8676002)(4326008)(1076003)(2616005)(336012)(426003)(36756003)(70206006)(82740400003)(36860700001)(16526019)(82310400005)(47076005)(2906002)(110136005)(40460700003)(6666004)(83380400001)(26005)(478600001)(316002)(54906003)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 01:07:26.9949
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: edeb6a13-fe02-4243-e782-08dad7ef6832
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT021.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR12MB6813
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
 drivers/vfio/pci/pds/aux_drv.c  | 155 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/aux_drv.h  |  29 ++++++
 drivers/vfio/pci/pds/cmds.c     |  30 +++++++
 drivers/vfio/pci/pds/cmds.h     |  14 +++
 drivers/vfio/pci/pds/pci_drv.c  |  17 ++++
 drivers/vfio/pci/pds/pci_drv.h  |   9 ++
 drivers/vfio/pci/pds/vfio_dev.c |   8 ++
 drivers/vfio/pci/pds/vfio_dev.h |   1 +
 include/linux/pds/pds_lm.h      |  12 +++
 10 files changed, 277 insertions(+)
 create mode 100644 drivers/vfio/pci/pds/aux_drv.c
 create mode 100644 drivers/vfio/pci/pds/aux_drv.h
 create mode 100644 drivers/vfio/pci/pds/cmds.c
 create mode 100644 drivers/vfio/pci/pds/cmds.h
 create mode 100644 drivers/vfio/pci/pds/pci_drv.h
 create mode 100644 include/linux/pds/pds_lm.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
index cd012648a655..1d927498b7bb 100644
--- a/drivers/vfio/pci/pds/Makefile
+++ b/drivers/vfio/pci/pds/Makefile
@@ -2,6 +2,8 @@
 obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
 
 pds_vfio-y := \
+	aux_drv.o	\
+	cmds.o		\
 	pci_drv.o	\
 	vfio_dev.o
 
diff --git a/drivers/vfio/pci/pds/aux_drv.c b/drivers/vfio/pci/pds/aux_drv.c
new file mode 100644
index 000000000000..ef8f67ff4152
--- /dev/null
+++ b/drivers/vfio/pci/pds/aux_drv.c
@@ -0,0 +1,155 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
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
+	struct device *dev = &aux_dev->dev;
+	struct pds_vfio_aux *vfio_aux;
+	struct pci_dev *pdev;
+	struct pci_bus *bus;
+	int busnr;
+	u16 devfn;
+	int err;
+
+	vfio_aux = kzalloc(sizeof(*vfio_aux), GFP_KERNEL);
+	if (!vfio_aux)
+		return -ENOMEM;
+
+	vfio_aux->padev = padev;
+	auxiliary_set_drvdata(aux_dev, vfio_aux);
+
+	/* Find our VF PCI device */
+	busnr = PCI_BUS_NUM(padev->id);
+	devfn = padev->id & 0xff;
+	bus = pci_find_bus(0, busnr);
+	pdev = pci_get_slot(bus, devfn);
+
+	vfio_aux->pds_vfio = pci_get_drvdata(pdev);
+	if (!vfio_aux->pds_vfio) {
+		dev_dbg(&pdev->dev, "PCI device not probed yet, defer until PCI device is probed by pds_vfio driver\n");
+		err = -EPROBE_DEFER;
+		goto err_pci_device_not_probed;
+	}
+
+	pdev = vfio_aux->pds_vfio->pdev;
+	if (!pds_vfio_is_vfio_pci_driver(pdev)) {
+		dev_err(&pdev->dev, "PCI driver is not pds_vfio_pci_driver\n");
+		err = -EINVAL;
+		goto err_invalid_driver;
+	}
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
+		goto err_register_client;
+	}
+
+	return 0;
+
+err_register_client:
+	auxiliary_set_drvdata(aux_dev, NULL);
+err_invalid_driver:
+err_pci_device_not_probed:
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
+
+void
+pds_vfio_put_aux_dev(struct pds_vfio_aux *vfio_aux)
+{
+	put_device(&vfio_aux->padev->aux_dev.dev);
+}
diff --git a/drivers/vfio/pci/pds/aux_drv.h b/drivers/vfio/pci/pds/aux_drv.h
new file mode 100644
index 000000000000..0f05a968bb00
--- /dev/null
+++ b/drivers/vfio/pci/pds/aux_drv.h
@@ -0,0 +1,29 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
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
+void
+pds_vfio_put_aux_dev(struct pds_vfio_aux *vfio_aux);
+
+#endif /* _AUX_DRV_H_ */
diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
new file mode 100644
index 000000000000..5a3fadcd38d8
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -0,0 +1,30 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
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
index 000000000000..7fe2d1efd894
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.h
@@ -0,0 +1,14 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
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
index 9a601194201d..f6483494031d 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -9,6 +9,8 @@
 #include <linux/pds/pds_core_if.h>
 
 #include "vfio_dev.h"
+#include "aux_drv.h"
+#include "pci_drv.h"
 
 #define PDS_VFIO_DRV_NAME		"pds_vfio"
 #define PDS_VFIO_DRV_DESCRIPTION	"Pensando VFIO Device Driver"
@@ -73,9 +75,17 @@ pds_vfio_pci_driver = {
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
@@ -91,6 +101,13 @@ pds_vfio_pci_init(void)
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
index 000000000000..e174cb1afd73
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.h
@@ -0,0 +1,9 @@
+#ifndef _PCI_DRV_H
+#define _PCI_DRV_H
+
+#include <linux/pci.h>
+
+bool
+pds_vfio_is_vfio_pci_driver(struct pci_dev *pdev);
+
+#endif /* _PCI_DRV_H */
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index f8f4006c0915..30c3bb47a2be 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -5,6 +5,7 @@
 #include <linux/vfio_pci_core.h>
 
 #include "vfio_dev.h"
+#include "aux_drv.h"
 
 struct pds_vfio_pci_device *
 pds_vfio_pci_drvdata(struct pci_dev *pdev)
@@ -22,6 +23,7 @@ pds_vfio_init_device(struct vfio_device *vdev)
 		container_of(vdev, struct pds_vfio_pci_device,
 			     vfio_coredev.vdev);
 	struct pci_dev *pdev = to_pci_dev(vdev->dev);
+	struct pds_vfio_aux *vfio_aux;
 	int err;
 
 	err = vfio_pci_core_init_dev(vdev);
@@ -30,6 +32,12 @@ pds_vfio_init_device(struct vfio_device *vdev)
 
 	pds_vfio->vf_id = pci_iov_vf_id(pdev);
 	pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
+	vfio_aux = pds_vfio_aux_get_drvdata(pds_vfio->pci_id);
+	if (vfio_aux) {
+		vfio_aux->pds_vfio = pds_vfio;
+		pds_vfio->vfio_aux = vfio_aux;
+		pds_vfio_put_aux_dev(vfio_aux);
+	}
 
 	return 0;
 }
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index 289479a08dce..b16668693e1f 100644
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FBFC6AFE4F
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 06:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbjCHFZa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 00:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbjCHFZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 00:25:25 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on20609.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe59::609])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5FF92F0E;
        Tue,  7 Mar 2023 21:25:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9wGuvz50cvgcFqE1bGq93Ixqskxw7ot1QXrGDd8Tlrwki/3jqUTmFJVJLQng0wmHqpdW30ba6Wytj8UsMUQI2PY2I2Amgn0CFe6WZykbr6CilkkgCYucrto0V/P1YwtKphlUzgpyzFaBJcUMnxdpDcPxND3lxp+oKbBL5TLmflIQ85xXUqqUBj/zx8IEhBTnZTsay59PPjuwn9NjX+tCltkLe+doQ4AP+XwI0JT4eXrDzq1rW7UWF+Ez7mUyTTwCWec9cEZgeUsB+4a39cTnIZ8jPC1f8vwbgOQ0jLpE7UeVHSFAr62RvW1x1ezvyUeVyoOKTDbBHe5+ELic4O5sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fJ8vwZA2Pk24lhfIA+O/FvkKSs8zEGjV8yzqxU0csgY=;
 b=MYRyxmH9VKe3xqaJvJc3liILr41ICMwEyBBU8pqgGE4qE0EWyStHHo0x0j5O+v0krnx7izAiix/VQ9gcM0kNUblk9CJOUu2ApN0fs2w+ITqyoyqNUOicQPsH9h8MZkDHQurWwwbLt3nPfXTmPisOo/Tqfw9QowAsyg6qTr1cVfmeDlc/r6+S/wfU3aZ2qIosOmenEfAi/ih1kyl8o1BRKbgyhn1341Rm2UTPi1JbyclaUytLLVxp295l1j1D2S5nAJ6BiRxyeNg/8t4m7EUg+ox/6vI97492Crn18srwcOoHVraQMjBuUc+cNfzIH4vGCPRqO35JsT2DWw/sPbGtog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fJ8vwZA2Pk24lhfIA+O/FvkKSs8zEGjV8yzqxU0csgY=;
 b=u/iCln8pnJL9RwqiXp47OAd5uwCI5kKPcD8AMacqbZly5Af4SEFBp8ofFyg7Ry2Sbfge03C5qhg4R1hQ4JyBJ4CJOXWuUom758zX0CdObXnJ4ouP6+vHBlccWYsGjI3wxhWf/fqihVZqy2nm2M/dDJ67ZSUwA7TukDOhvMo6Qfw=
Received: from BN9PR03CA0131.namprd03.prod.outlook.com (2603:10b6:408:fe::16)
 by PH8PR12MB7157.namprd12.prod.outlook.com (2603:10b6:510:22b::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Wed, 8 Mar
 2023 05:25:10 +0000
Received: from BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:fe:cafe::f1) by BN9PR03CA0131.outlook.office365.com
 (2603:10b6:408:fe::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29 via Frontend
 Transport; Wed, 8 Mar 2023 05:25:10 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT110.mail.protection.outlook.com (10.13.176.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Wed, 8 Mar 2023 05:25:10 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 7 Mar
 2023 23:25:08 -0600
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [RFC PATCH v4 3/7] vfio/pds: register with the pds_core PF
Date:   Tue, 7 Mar 2023 21:24:46 -0800
Message-ID: <20230308052450.13421-4-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230308052450.13421-1-brett.creeley@amd.com>
References: <20230308052450.13421-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT110:EE_|PH8PR12MB7157:EE_
X-MS-Office365-Filtering-Correlation-Id: 7d12ca9a-29b7-404d-8352-08db1f957c6d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X+xQbHPrQ6uRmUuhiQDIP0J7fQX/Hq5+XjFc8FHmEhiyzW2784mTupHagOJy76q2rUCU8JbJICZnELAkmERmtJ5fDJtd/mw0BJlYWFgm7842x8MKTY2ASSN6q43BsCqsZxj7pI/mRuw+1tRSpVjMd7cMUfCKIoRHaJnTyl+a+pP2HEu11LIcR2+GVvyttLxL8nIv18r+tvsYILswgSbUU7m0cWwX7qE0Jerawz5uRHVWAKGj4YK8JO0EBgRBLE0fE6n6rDFzR6wKIQ5sY2NaAAk7NxPeAt0z6cKMbrM1zjEaLfHJQMf1+cLYqGMqrl/dUELy6CPqjzNa/w20eHtbLpB7yFiHChkg8v6+YoAOVjI8a0Boe3gDzv+6/u0XEKkazF5HtPmq66PSUzHOyjrldSkcvPkEq73QMtgmzhw1WlPPn2NLEeXatJmmGukXCivH/LtcvNOtwoAcGj/5+x2kPfZKc3VIW6JpbPPJNLFUgDANGqm5FFIzJzYjCC8/5iw6v481Qbkk0NAXXniAsm8WmZ+VA9mwCVAbU10D8BQKjCiAaXTDG4ElD0TiSZm1rnjkPNNb9ubQmzAti+UhEk+XJ5BuHhiXFCmISgE9BvvGajxPgtwHpf5mZWHfwjTknYYVNFncqnn8PWHEDcNk5lAkK0ocxmywRceh2ebXG3OW9VW3fLKOxiPugwo7jL2FVWS3ItZMdfIOjB/sbyKEDh9BQrRUT8cNIpGIw2JN+M/ZXbI=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(40470700004)(46966006)(36840700001)(41300700001)(2906002)(70586007)(70206006)(86362001)(8676002)(4326008)(110136005)(82310400005)(36860700001)(16526019)(54906003)(83380400001)(356005)(82740400003)(316002)(186003)(81166007)(478600001)(26005)(8936002)(1076003)(2616005)(36756003)(5660300002)(40480700001)(426003)(336012)(47076005)(44832011)(6666004)(40460700003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 05:25:10.0728
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d12ca9a-29b7-404d-8352-08db1f957c6d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT110.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR12MB7157
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/vfio/pci/pds/cmds.c     | 66 +++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h     | 12 ++++++
 drivers/vfio/pci/pds/pci_drv.c  | 14 ++++++-
 drivers/vfio/pci/pds/pci_drv.h  |  9 +++++
 drivers/vfio/pci/pds/vfio_dev.c |  5 +++
 drivers/vfio/pci/pds/vfio_dev.h |  2 +
 include/linux/pds/pds_lm.h      | 12 ++++++
 8 files changed, 120 insertions(+), 1 deletion(-)
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
index 000000000000..e30ecea91e09
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -0,0 +1,66 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/io.h>
+#include <linux/types.h>
+
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_core.h>
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
+	u16 ci;
+
+	dev = &pds_vfio->pdev->dev;
+	cmd.client_reg.opcode = PDS_AQ_CMD_CLIENT_REG;
+	snprintf(cmd.client_reg.devname, sizeof(cmd.client_reg.devname),
+		 "%s.%d", PDS_LM_DEV_NAME, pds_vfio->pdsc->id);
+
+	err = pdsc_adminq_post(pds_vfio->pdsc, &pds_vfio->pdsc->adminqcq,
+			       &cmd, &comp, false);
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
+	err = pdsc_adminq_post(pds_vfio->pdsc, &pds_vfio->pdsc->adminqcq,
+			       &cmd, &comp, false);
+	if (err)
+		dev_info(dev, "unregister from DSC failed, status %d: %pe\n",
+			 comp.status, ERR_PTR(err));
+
+	pds_vfio->client_id = 0;
+}
diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
new file mode 100644
index 000000000000..5efc54a7b9b9
--- /dev/null
+++ b/drivers/vfio/pci/pds/cmds.h
@@ -0,0 +1,12 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _CMDS_H_
+#define _CMDS_H_
+
+struct pds_vfio_pci_device;
+
+int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
+
+#endif /* _CMDS_H_ */
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index 5e554420792e..b1e5ea854200 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -9,8 +9,11 @@
 #include <linux/vfio.h>
 
 #include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_core.h>
 
 #include "vfio_dev.h"
+#include "pci_drv.h"
+#include "cmds.h"
 
 #define PDS_VFIO_DRV_NAME		"pds_vfio"
 #define PDS_VFIO_DRV_DESCRIPTION	"AMD/Pensando VFIO Device Driver"
@@ -30,13 +33,22 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
 
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
 out_put_vdev:
 	vfio_put_device(&pds_vfio->vfio_coredev.vdev);
 	return err;
diff --git a/drivers/vfio/pci/pds/pci_drv.h b/drivers/vfio/pci/pds/pci_drv.h
new file mode 100644
index 000000000000..1b192aecf343
--- /dev/null
+++ b/drivers/vfio/pci/pds/pci_drv.h
@@ -0,0 +1,9 @@
+// SPDX-License-Identifier: GPL-2.0
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
index d9f0203c1649..614640194c36 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -10,9 +10,11 @@
 struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
 	struct pci_dev *pdev;
+	struct pdsc *pdsc;
 
 	int vf_id;
 	int pci_id;
+	u16 client_id;
 };
 
 const struct vfio_device_ops *pds_vfio_ops_info(void);
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


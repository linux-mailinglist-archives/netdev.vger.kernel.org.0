Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DE0D6C5493
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbjCVTLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230247AbjCVTLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:11:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2049.outbound.protection.outlook.com [40.107.94.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB215C117
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:11:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g1iEuclIZncNHHyGAiA+mgVAfzkEHQWkhIm8oQtuIRhrpnqdL/fwNVFDQS63ers5/DgyspKDuG/5fhlCAZNRXgBaXtGxmHN3dSlSpj8xc4fiJ2lHJoNNxV+Sfy+YJt2L8el3PmxWQsBUKGrLeVVrQBzy+FhoIrZ/X2FZa5HW/dQg3V+KY6yJgsmSiBnfcDOkiPTiOJYmFQ74R+qCkQqqyEnAv/yJdit4GHl8d0VAZB523qxGuE3mkOFu/Ku1tfPgBUW7lEuPk7PpLjNByBEzFV3cDzzQwINIQGk7AfVZlaH7FwrXz2MTDsf6T/zXNPQyumimrO2Bf9IdxrZRJKXwxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DGKz7RV1kOCcEp8ITGCtwf2PPxYkKJ+kuqsVu3N39Rk=;
 b=PDkhD0hGOoOBdXnFR/QVwuiXOGVweNBdOns+uArsVpJMtJxUBUrzECeijHXSpRvbp3X51zYziPavWYEMlzAxYba8mJZdQKyaVln846sv1QbRljmsPo4rYpVNkyo91+dkH8l6R7kFoKXtK9iOVBw8zv63GyU4cNCy2KvIdWOH9p4mq85yC7SD4366Ab1+XcA65XgjCblrITRXpFhB2fznHQTlVU8oL2dbrwd+3TOOWeRYqNl0SkLi2xRNR+VLDbNdxbaEgDrs3zVTRYKDLXDym5xzrGHZs364DfvH9VkbV1g70wV76PA9lFMRaXU7h+svzy1/ntzwPEnTC3Z8seiYZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DGKz7RV1kOCcEp8ITGCtwf2PPxYkKJ+kuqsVu3N39Rk=;
 b=p/8gDL8oLFYlo1II8sxu74kQebJgtFHLR/LxsrfbzmyVwHjQ+Z0ePdHWEoMdFpzKd+2w1jk9+MeY37s61gWGBP7lugLocSkZS+gXPAq0tQizOjLCP0Vt296qt4enTKMnJB4QNv4hGrdNMFQd1pQ5h8wsGfMe7IuJX/YmuDoYrZU=
Received: from DS7PR03CA0298.namprd03.prod.outlook.com (2603:10b6:5:3ad::33)
 by MN2PR12MB4176.namprd12.prod.outlook.com (2603:10b6:208:1d5::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:11:00 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::9) by DS7PR03CA0298.outlook.office365.com
 (2603:10b6:5:3ad::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 19:11:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 19:10:59 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 14:10:55 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v3 virtio 3/8] pds_vdpa: get vdpa management info
Date:   Wed, 22 Mar 2023 12:10:33 -0700
Message-ID: <20230322191038.44037-4-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|MN2PR12MB4176:EE_
X-MS-Office365-Filtering-Correlation-Id: cb0a4ae1-1c2d-4ec1-71c7-08db2b092c54
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lIwiwqcGMpbjh9s2G23j8C88gZXe1j1rMwFBeGkn+N1pAKE/NedUb9khBhGa8T3GFaG+XgtlhOJ9J/7ySQj9bHqp28uN4u5uTJT2vtEvUL1W/cVpbb3mpkP2UEfW7G0U+U4tKbWieUC15t3qaWxtSDgJHF5us3JGFcylvLVQ5Rqw2M2lyUfnTgnkpMMuIuSl+jttWZELhPK+gV9An1vWIU+IZGL7sdAGYi+F/8Lj240AMZWh+YybXKdlP/NR1lJOvLW6QE9tLKvrD7YLsYtclmCaxmMZCwIYk2KdLz7loUyFImObFSDftiRA1nux01p9eWakOLjpJtAUVnBL9Xb2Mf86LVYz8au6h7CPTI21J8/2CG5oJ9kjgEnTH6GTi7VrcLT84g3Ln32glb/KYwdFxpi9SN7kCmPjARPKHyWstpv5IO9HX4HZw6KaBW5I6CrsZMCspa7xkz0H+WhtSzmtRaq6dGBF6wLO2bNb658IMmSp0yP6WnFgK6HCIEC3vc7Uj5NzhcgX7wxcGDvln8ispoPeLywgyoa0m9SnstKFYFJ1q1Xjh98sPQW1aIXWJa97bloQi/we0L6MotO1F54mdubaZl2rhgLjsCc8Jc0Y/TgagZjdoXcSgi+M5K7sNZTA22IzHhdkMHO1T1w2WEkvjonqrBx8nLPQsoVmigDvUuFsEUB6GxO7IsuMKDqpyN5/RO6+hgglzTbzP/6m0BPu1v+tcm9yGO74CmcPCX6y+Ag=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(136003)(346002)(376002)(451199018)(36840700001)(40470700004)(46966006)(2616005)(186003)(47076005)(16526019)(83380400001)(478600001)(426003)(6666004)(1076003)(336012)(70206006)(110136005)(316002)(70586007)(8676002)(26005)(4326008)(36860700001)(41300700001)(5660300002)(8936002)(44832011)(30864003)(81166007)(82740400003)(40460700003)(2906002)(356005)(86362001)(82310400005)(40480700001)(36756003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 19:10:59.8676
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: cb0a4ae1-1c2d-4ec1-71c7-08db2b092c54
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4176
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Find the vDPA management information from the DSC in order to
advertise it to the vdpa subsystem.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vdpa/pds/Makefile    |   3 +-
 drivers/vdpa/pds/aux_drv.c   |  17 ++++++
 drivers/vdpa/pds/aux_drv.h   |   7 +++
 drivers/vdpa/pds/debugfs.c   |   2 +
 drivers/vdpa/pds/vdpa_dev.c  | 114 +++++++++++++++++++++++++++++++++++
 drivers/vdpa/pds/vdpa_dev.h  |  15 +++++
 include/linux/pds/pds_vdpa.h |  90 +++++++++++++++++++++++++++
 7 files changed, 247 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vdpa/pds/vdpa_dev.c
 create mode 100644 drivers/vdpa/pds/vdpa_dev.h

diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
index a9cd2f450ae1..13b50394ec64 100644
--- a/drivers/vdpa/pds/Makefile
+++ b/drivers/vdpa/pds/Makefile
@@ -3,6 +3,7 @@
 
 obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
 
-pds_vdpa-y := aux_drv.o
+pds_vdpa-y := aux_drv.o \
+	      vdpa_dev.o
 
 pds_vdpa-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
index 39c03f067b77..881acd869a9d 100644
--- a/drivers/vdpa/pds/aux_drv.c
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -3,6 +3,7 @@
 
 #include <linux/auxiliary_bus.h>
 #include <linux/pci.h>
+#include <linux/vdpa.h>
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
@@ -12,6 +13,7 @@
 
 #include "aux_drv.h"
 #include "debugfs.h"
+#include "vdpa_dev.h"
 
 static const struct auxiliary_device_id pds_vdpa_id_table[] = {
 	{ .name = PDS_VDPA_DEV_NAME, },
@@ -25,15 +27,28 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
 	struct pds_auxiliary_dev *padev =
 		container_of(aux_dev, struct pds_auxiliary_dev, aux_dev);
 	struct pds_vdpa_aux *vdpa_aux;
+	int err;
 
 	vdpa_aux = kzalloc(sizeof(*vdpa_aux), GFP_KERNEL);
 	if (!vdpa_aux)
 		return -ENOMEM;
 
 	vdpa_aux->padev = padev;
+	vdpa_aux->vf_id = pci_iov_vf_id(padev->vf_pdev);
 	auxiliary_set_drvdata(aux_dev, vdpa_aux);
 
+	/* Get device ident info and set up the vdpa_mgmt_dev */
+	err = pds_vdpa_get_mgmt_info(vdpa_aux);
+	if (err)
+		goto err_free_mem;
+
 	return 0;
+
+err_free_mem:
+	kfree(vdpa_aux);
+	auxiliary_set_drvdata(aux_dev, NULL);
+
+	return err;
 }
 
 static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
@@ -41,6 +56,8 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
 	struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
 	struct device *dev = &aux_dev->dev;
 
+	pci_free_irq_vectors(vdpa_aux->padev->vf_pdev);
+
 	kfree(vdpa_aux);
 	auxiliary_set_drvdata(aux_dev, NULL);
 
diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
index 14e465944dfd..94ba7abcaa43 100644
--- a/drivers/vdpa/pds/aux_drv.h
+++ b/drivers/vdpa/pds/aux_drv.h
@@ -10,6 +10,13 @@
 struct pds_vdpa_aux {
 	struct pds_auxiliary_dev *padev;
 
+	struct vdpa_mgmt_dev vdpa_mdev;
+
+	struct pds_vdpa_ident ident;
+
+	int vf_id;
 	struct dentry *dentry;
+
+	int nintrs;
 };
 #endif /* _AUX_DRV_H_ */
diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
index 12e844f96ccc..f4275fe667c3 100644
--- a/drivers/vdpa/pds/debugfs.c
+++ b/drivers/vdpa/pds/debugfs.c
@@ -2,10 +2,12 @@
 /* Copyright(c) 2023 Advanced Micro Devices, Inc */
 
 #include <linux/pci.h>
+#include <linux/vdpa.h>
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
 #include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_vdpa.h>
 #include <linux/pds/pds_auxbus.h>
 
 #include "aux_drv.h"
diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
new file mode 100644
index 000000000000..6345b3fa2440
--- /dev/null
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -0,0 +1,114 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/pci.h>
+#include <linux/vdpa.h>
+#include <uapi/linux/vdpa.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+#include <linux/pds/pds_vdpa.h>
+
+#include "vdpa_dev.h"
+#include "aux_drv.h"
+
+static struct virtio_device_id pds_vdpa_id_table[] = {
+	{VIRTIO_ID_NET, VIRTIO_DEV_ANY_ID},
+	{0},
+};
+
+static int pds_vdpa_dev_add(struct vdpa_mgmt_dev *mdev, const char *name,
+			    const struct vdpa_dev_set_config *add_config)
+{
+	return -EOPNOTSUPP;
+}
+
+static void pds_vdpa_dev_del(struct vdpa_mgmt_dev *mdev,
+			     struct vdpa_device *vdpa_dev)
+{
+}
+
+static const struct vdpa_mgmtdev_ops pds_vdpa_mgmt_dev_ops = {
+	.dev_add = pds_vdpa_dev_add,
+	.dev_del = pds_vdpa_dev_del
+};
+
+int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux)
+{
+	struct pds_vdpa_ident_cmd ident_cmd = {
+		.opcode = PDS_VDPA_CMD_IDENT,
+		.vf_id = cpu_to_le16(vdpa_aux->vf_id),
+	};
+	struct pds_vdpa_comp ident_comp = {0};
+	struct vdpa_mgmt_dev *mgmt;
+	struct device *pf_dev;
+	struct pci_dev *pdev;
+	dma_addr_t ident_pa;
+	struct device *dev;
+	u16 max_vqs;
+	int err;
+
+	dev = &vdpa_aux->padev->aux_dev.dev;
+	pdev = vdpa_aux->padev->vf_pdev;
+	mgmt = &vdpa_aux->vdpa_mdev;
+
+	/* Get resource info through the PF's adminq.  It is a block of info,
+	 * so we need to map some memory for PF to make available to the
+	 * firmware for writing the data.
+	 */
+	pf_dev = &vdpa_aux->padev->pf_pdev->dev;
+	ident_pa = dma_map_single(pf_dev, &vdpa_aux->ident,
+				  sizeof(vdpa_aux->ident), DMA_FROM_DEVICE);
+	if (dma_mapping_error(pf_dev, ident_pa)) {
+		dev_err(dev, "Failed to map ident space\n");
+		return -ENOMEM;
+	}
+
+	ident_cmd.ident_pa = cpu_to_le64(ident_pa);
+	ident_cmd.len = cpu_to_le32(sizeof(vdpa_aux->ident));
+	err = vdpa_aux->padev->ops->adminq_cmd(vdpa_aux->padev,
+					       (union pds_core_adminq_cmd *)&ident_cmd,
+					       sizeof(ident_cmd),
+					       (union pds_core_adminq_comp *)&ident_comp,
+					       0);
+	dma_unmap_single(pf_dev, ident_pa,
+			 sizeof(vdpa_aux->ident), DMA_FROM_DEVICE);
+	if (err) {
+		dev_err(dev, "Failed to ident hw, status %d: %pe\n",
+			ident_comp.status, ERR_PTR(err));
+		return err;
+	}
+
+	max_vqs = le16_to_cpu(vdpa_aux->ident.max_vqs);
+	mgmt->max_supported_vqs = min_t(u16, PDS_VDPA_MAX_QUEUES, max_vqs);
+	if (max_vqs > PDS_VDPA_MAX_QUEUES)
+		dev_info(dev, "FYI - Device supports more vqs (%d) than driver (%d)\n",
+			 max_vqs, PDS_VDPA_MAX_QUEUES);
+
+	mgmt->ops = &pds_vdpa_mgmt_dev_ops;
+	mgmt->id_table = pds_vdpa_id_table;
+	mgmt->device = dev;
+	mgmt->supported_features = le64_to_cpu(vdpa_aux->ident.hw_features);
+	mgmt->config_attr_mask = BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
+	mgmt->config_attr_mask |= BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MAX_VQP);
+
+	/* Set up interrupts now that we know how many we might want
+	 * each gets one, than add another for a control queue if supported
+	 */
+	vdpa_aux->nintrs = mgmt->max_supported_vqs;
+	if (mgmt->supported_features & BIT_ULL(VIRTIO_NET_F_CTRL_VQ))
+		vdpa_aux->nintrs++;
+
+	err = pci_alloc_irq_vectors(pdev, vdpa_aux->nintrs, vdpa_aux->nintrs,
+				    PCI_IRQ_MSIX);
+	if (err < 0) {
+		dev_err(dev, "Couldn't get %d msix vectors: %pe\n",
+			vdpa_aux->nintrs, ERR_PTR(err));
+		return err;
+	}
+	vdpa_aux->nintrs = err;
+
+	return 0;
+}
diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
new file mode 100644
index 000000000000..97fab833a0aa
--- /dev/null
+++ b/drivers/vdpa/pds/vdpa_dev.h
@@ -0,0 +1,15 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _VDPA_DEV_H_
+#define _VDPA_DEV_H_
+
+#define PDS_VDPA_MAX_QUEUES	65
+
+struct pds_vdpa_device {
+	struct vdpa_device vdpa_dev;
+	struct pds_vdpa_aux *vdpa_aux;
+};
+
+int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
+#endif /* _VDPA_DEV_H_ */
diff --git a/include/linux/pds/pds_vdpa.h b/include/linux/pds/pds_vdpa.h
index d3414536985d..c1d6a3fe2d61 100644
--- a/include/linux/pds/pds_vdpa.h
+++ b/include/linux/pds/pds_vdpa.h
@@ -7,4 +7,94 @@
 #define PDS_DEV_TYPE_VDPA_STR	"vDPA"
 #define PDS_VDPA_DEV_NAME	PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_VDPA_STR
 
+/*
+ * enum pds_vdpa_cmd_opcode - vDPA Device commands
+ */
+enum pds_vdpa_cmd_opcode {
+	PDS_VDPA_CMD_INIT		= 48,
+	PDS_VDPA_CMD_IDENT		= 49,
+	PDS_VDPA_CMD_RESET		= 51,
+	PDS_VDPA_CMD_VQ_RESET		= 52,
+	PDS_VDPA_CMD_VQ_INIT		= 53,
+	PDS_VDPA_CMD_STATUS_UPDATE	= 54,
+	PDS_VDPA_CMD_SET_FEATURES	= 55,
+	PDS_VDPA_CMD_SET_ATTR		= 56,
+	PDS_VDPA_CMD_VQ_SET_STATE	= 57,
+	PDS_VDPA_CMD_VQ_GET_STATE	= 58,
+};
+
+/**
+ * struct pds_vdpa_cmd - generic command
+ * @opcode:	Opcode
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ */
+struct pds_vdpa_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_vdpa_comp - generic command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd:	Word boundary padding
+ * @color:	Color bit
+ */
+struct pds_vdpa_comp {
+	u8 status;
+	u8 rsvd[14];
+	u8 color;
+};
+
+/**
+ * struct pds_vdpa_init_cmd - INIT command
+ * @opcode:	Opcode PDS_VDPA_CMD_INIT
+ * @vdpa_index: Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @len:	length of config info DMA space
+ * @config_pa:	address for DMA of virtio config struct
+ */
+struct pds_vdpa_init_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_vdpa_ident - vDPA identification data
+ * @hw_features:	vDPA features supported by device
+ * @max_vqs:		max queues available (2 queues for a single queuepair)
+ * @max_qlen:		log(2) of maximum number of descriptors
+ * @min_qlen:		log(2) of minimum number of descriptors
+ *
+ * This struct is used in a DMA block that is set up for the PDS_VDPA_CMD_IDENT
+ * transaction.  Set up the DMA block and send the address in the IDENT cmd
+ * data, the DSC will write the ident information, then we can remove the DMA
+ * block after reading the answer.  If the completion status is 0, then there
+ * is valid information, else there was an error and the data should be invalid.
+ */
+struct pds_vdpa_ident {
+	__le64 hw_features;
+	__le16 max_vqs;
+	__le16 max_qlen;
+	__le16 min_qlen;
+};
+
+/**
+ * struct pds_vdpa_ident_cmd - IDENT command
+ * @opcode:	Opcode PDS_VDPA_CMD_IDENT
+ * @rsvd:       Word boundary padding
+ * @vf_id:	VF id
+ * @len:	length of ident info DMA space
+ * @ident_pa:	address for DMA of ident info (struct pds_vdpa_ident)
+ *			only used for this transaction, then forgotten by DSC
+ */
+struct pds_vdpa_ident_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	__le32 len;
+	__le64 ident_pa;
+};
 #endif /* _PDS_VDPA_H_ */
-- 
2.17.1


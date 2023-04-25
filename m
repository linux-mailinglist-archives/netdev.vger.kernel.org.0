Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9069B6EE9A2
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 23:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236390AbjDYV0e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 17:26:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236389AbjDYV00 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 17:26:26 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2066.outbound.protection.outlook.com [40.107.96.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8F517DFE
        for <netdev@vger.kernel.org>; Tue, 25 Apr 2023 14:26:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V3/Y6dtmL3Gj+zzqQFF4FaJIGDazc0UfGi84l0MXqP3PVBwuKp/Fs8eXq0Ummp6AuedhuliEhDr5lGqVumMkrIoVBkcVg+VbBQDdCnrVWk9ocbak64FgUrAKEF7mNb+LC5rRJBcGQBT5WmSf4+hsJorvL8yNPQ8GwE6G4bU8AgkbHdGPUJ26XcBajBNFCGnr6zmyli5KGtFeqWUdBAk212mM4nzipknn9zFawyT4o1qpD8GsQ60UwBi1+b++1tOyzMpb2PF5utI8axehUpuA+oF8GqdmmrPUqdvvIC06q3g7JqZyap0IEm9hdxtO0XUOWD7mvh/PEKeV0S9tsb3RhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J7pl08gsZAq6M5LfC/8SmQl1rwIMMSjRMfx5i814uyA=;
 b=PQk4c6LLBn4oiXuMkyGuGuMtCz7KumKeGO+bQ8rYvxIHI7JU6g595QTWXhh/MSslUdABuC3UMRWXd3x8gpdCWaQcOjvN4v4QNbBRuZbyPRr0zwKgsQGh4QJDNzBwsqIcC/3V60YUuIbDBZY0Kl0Kq6c4ZLodg7FViDTLqtT78b4hhh93gRQBmEuTIFlFvjkI9EIUoiLezuayIOaZxEdbTFWvxuwTCp9+dWgdBmOBAYnAPtl4ESTwTgpwMRGwxmi/LFsC3huTkkXTKtnauJ2VLZyXHOF86ywFOrgn5JmjLJpUt+PoxpXlNFmedwRJNo0J3eH6HUQPiDvm3iXKwfjcSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7pl08gsZAq6M5LfC/8SmQl1rwIMMSjRMfx5i814uyA=;
 b=XIE/++hTfEolCwyDNEF+JV7gqpKt0rgFWqZIRfAS/moZWXp9PDsb/XrNbA2bG7VHW+6pVenvI+WHQndB8BXaGBe1Zx/tW9Kc4NFbGWUJvcr9rLzDlxwcR4+jDQMCcKWzXh5yKpxgR68hxewjv3wM6GMi2lrEHhb6iXLHfugTxss=
Received: from DM6PR11CA0050.namprd11.prod.outlook.com (2603:10b6:5:14c::27)
 by BL1PR12MB5143.namprd12.prod.outlook.com (2603:10b6:208:31b::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.34; Tue, 25 Apr
 2023 21:26:22 +0000
Received: from DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:14c:cafe::24) by DM6PR11CA0050.outlook.office365.com
 (2603:10b6:5:14c::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.20 via Frontend
 Transport; Tue, 25 Apr 2023 21:26:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT092.mail.protection.outlook.com (10.13.173.44) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.20 via Frontend Transport; Tue, 25 Apr 2023 21:26:22 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 25 Apr
 2023 16:26:21 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <netdev@vger.kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v4 virtio 05/10] pds_vdpa: get vdpa management info
Date:   Tue, 25 Apr 2023 14:25:57 -0700
Message-ID: <20230425212602.1157-6-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT092:EE_|BL1PR12MB5143:EE_
X-MS-Office365-Filtering-Correlation-Id: 153db43c-aa77-497e-262a-08db45d3b7d4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tLfFJSdMyYOwpTAEp0OJ6YTwKqD/5qfPE4iCexDMytyHqbn7wLeAnM5OJCfz26DKc4BeUeYB98LyaaiUT6sDOWlI7IPcYJSrzTXRXW5GdimFyByD8U6cV6gD/xhXjDQJvPP+sypfkmZQ8somrzG3eVmRB19LlsvrcLVydRocp+Iq2n1FPhKmuX70f8W4OkoL+euQIHng4ReciBi5FIDy4i4pcdQrvhq0VXWBtliZaO1WVthgdjI3uifImIkaywETGm+6bozCvMcFt8scb7wcONLWlEdsm5sAbHQJlEldRI2N1gQAMlbFqdvWxgl3bR1X2dCfPqV1EYkFN2yXsFsVAr8aKkhMr1arK5P9+hRkHbQiq99UXFJPZ0Fx5Ms52yP7FE5f9KSAy2MfVOROgODRHOlRnVYR+8u64riOeqSAVrZnxDQlB04gtslJfc1sL4wzEtEoOrNgobowROL0GAmRn/nzOHhzZ2vojmxJClLD65kzZEUItQhAMlU9jv5CzhhXaHZKvjiL2f7ql4WNJu4GrCbQggny6/PdV8eJp830oiwMct9tRazyesdOzv7srK+JsXI9JVK8ieREK/xiN7tgvyKkTcYG6puXS4qurcByGz+LGTtWveSGyuBF7Ly6bJVG0Zw2FZYPIfplbZQPbgjzKncvwZSOvETWVbWoRxWR1AjwhiFg/b8jio+WS8vSVQfD4ElGP8b/YtIiJKpHlMeP4xQ8av+nClk/Vv1fQTjHNDA=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(376002)(346002)(39860400002)(396003)(451199021)(40470700004)(46966006)(36840700001)(36860700001)(47076005)(86362001)(83380400001)(26005)(186003)(1076003)(16526019)(426003)(40480700001)(336012)(2616005)(36756003)(82740400003)(356005)(81166007)(40460700003)(44832011)(316002)(8936002)(5660300002)(8676002)(4326008)(41300700001)(6666004)(110136005)(70206006)(70586007)(478600001)(82310400005)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 21:26:22.6982
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 153db43c-aa77-497e-262a-08db45d3b7d4
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT092.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL1PR12MB5143
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

Find the vDPA management information from the DSC in order to
advertise it to the vdpa subsystem.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vdpa/pds/Makefile   |   3 +-
 drivers/vdpa/pds/aux_drv.c  |  17 ++++++
 drivers/vdpa/pds/aux_drv.h  |   7 +++
 drivers/vdpa/pds/debugfs.c  |   1 +
 drivers/vdpa/pds/vdpa_dev.c | 108 ++++++++++++++++++++++++++++++++++++
 drivers/vdpa/pds/vdpa_dev.h |  15 +++++
 6 files changed, 150 insertions(+), 1 deletion(-)
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
index e4a0ad61ea22..aa748cf55d2b 100644
--- a/drivers/vdpa/pds/aux_drv.c
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -3,6 +3,7 @@
 
 #include <linux/auxiliary_bus.h>
 #include <linux/pci.h>
+#include <linux/vdpa.h>
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
@@ -11,6 +12,7 @@
 
 #include "aux_drv.h"
 #include "debugfs.h"
+#include "vdpa_dev.h"
 
 static const struct auxiliary_device_id pds_vdpa_id_table[] = {
 	{ .name = PDS_VDPA_DEV_NAME, },
@@ -24,15 +26,28 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
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
@@ -40,6 +55,8 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
 	struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
 	struct device *dev = &aux_dev->dev;
 
+	pci_free_irq_vectors(vdpa_aux->padev->vf_pdev);
+
 	kfree(vdpa_aux);
 	auxiliary_set_drvdata(aux_dev, NULL);
 
diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
index f1e99359424e..dcec782e79eb 100644
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
index 5be22fb7a76a..d91dceb07380 100644
--- a/drivers/vdpa/pds/debugfs.c
+++ b/drivers/vdpa/pds/debugfs.c
@@ -2,6 +2,7 @@
 /* Copyright(c) 2023 Advanced Micro Devices, Inc */
 
 #include <linux/pci.h>
+#include <linux/vdpa.h>
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
new file mode 100644
index 000000000000..0f0f0ab8b811
--- /dev/null
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -0,0 +1,108 @@
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
+	union pds_core_adminq_cmd cmd = {
+		.vdpa_ident.opcode = PDS_VDPA_CMD_IDENT,
+		.vdpa_ident.vf_id = cpu_to_le16(vdpa_aux->vf_id),
+	};
+	union pds_core_adminq_comp comp = {};
+	struct vdpa_mgmt_dev *mgmt;
+	struct pci_dev *pf_pdev;
+	struct device *pf_dev;
+	struct pci_dev *pdev;
+	dma_addr_t ident_pa;
+	struct device *dev;
+	u16 dev_intrs;
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
+	pf_pdev = pci_physfn(vdpa_aux->padev->vf_pdev);
+	pf_dev = &pf_pdev->dev;
+	ident_pa = dma_map_single(pf_dev, &vdpa_aux->ident,
+				  sizeof(vdpa_aux->ident), DMA_FROM_DEVICE);
+	if (dma_mapping_error(pf_dev, ident_pa)) {
+		dev_err(dev, "Failed to map ident space\n");
+		return -ENOMEM;
+	}
+
+	cmd.vdpa_ident.ident_pa = cpu_to_le64(ident_pa);
+	cmd.vdpa_ident.len = cpu_to_le32(sizeof(vdpa_aux->ident));
+	err = pds_client_adminq_cmd(vdpa_aux->padev, &cmd,
+				    sizeof(cmd.vdpa_ident), &comp, 0);
+	dma_unmap_single(pf_dev, ident_pa,
+			 sizeof(vdpa_aux->ident), DMA_FROM_DEVICE);
+	if (err) {
+		dev_err(dev, "Failed to ident hw, status %d: %pe\n",
+			comp.status, ERR_PTR(err));
+		return err;
+	}
+
+	max_vqs = le16_to_cpu(vdpa_aux->ident.max_vqs);
+	dev_intrs = pci_msix_vec_count(pdev);
+	dev_dbg(dev, "ident.max_vqs %d dev_intrs %d\n", max_vqs, dev_intrs);
+
+	max_vqs = min_t(u16, dev_intrs, max_vqs);
+	mgmt->max_supported_vqs = min_t(u16, PDS_VDPA_MAX_QUEUES, max_vqs);
+	vdpa_aux->nintrs = mgmt->max_supported_vqs;
+
+	mgmt->ops = &pds_vdpa_mgmt_dev_ops;
+	mgmt->id_table = pds_vdpa_id_table;
+	mgmt->device = dev;
+	mgmt->supported_features = le64_to_cpu(vdpa_aux->ident.hw_features);
+	mgmt->config_attr_mask = BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MACADDR);
+	mgmt->config_attr_mask |= BIT_ULL(VDPA_ATTR_DEV_NET_CFG_MAX_VQP);
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
-- 
2.17.1


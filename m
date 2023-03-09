Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700586B18C6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 02:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCIBbp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 20:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229926AbjCIBbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 20:31:38 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2064.outbound.protection.outlook.com [40.107.94.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A92E49AFC3
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 17:31:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZSZeKVKSmHSpSd5WzK8hmDWBFnk2KMzA6VM1iDdvETLTokSdLhqcQYr1TY74ALYDLTTeP4p2DkhmhXoek/8Z+oAiiLQSOuj4Yt7rKfErML+Psca+lPOIzJFsTRd+DRgWGebHF5Fl8Yb2KKyP5Saf9N/ImXAPrsW/WHHNG8hoCczvvYRT+H9I/Rco3NcU1z2cl+242F0XbkOoTqTo3bu1fUlP4WJ7y6G/N04bNdnFC09WKjaET3OMJr5ennd5as9zsqS3WMImvCl6VXz6ZIN0vbmXTh/YrW4oCTleSl4/JEL1DF/V2jPQqe1zqOus3V0n24Y/+Z1DwMAdxPUxVJ5zag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QSDtJ+XkQ10yZTMF6PVjT5BXOMPpYCza/UEoYZoV760=;
 b=oCSH4IzPW4tJEieXW8y4ZBpxz62k3UE/KkW/VPkfZv0KERPqUYy3Mf2hlqNvmVDd0Os44oNsGSe0XSW9Jtr85G64dtMyBG3Kz9V9vxTibgn4IYXqGO9w9vjYFVF3fV+QW0TDXLBvyP8n/ctw4KrdqPcnzvQbmni4UyUvbhK3Dw5MwLbT74HVZlmcIhRextNMro78i1YCoj1jkBODNXXrHDXuEHCGCRzY6U2FIvDlIT/NHxaryMU9TU+1qeif+X04oHZTkwL/Aw1u4zZD68tnQAebvyS2U62INItslPwh31Xzha3UPnh8HqO9wW4tZH3xRxJNENWwDupbekc8h3TC/g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QSDtJ+XkQ10yZTMF6PVjT5BXOMPpYCza/UEoYZoV760=;
 b=ZereJTevIkcGure6Fw2Goiz2/JyEsoe/B1Hybb3KpIUOa9qM/TvSq6Bw0PmlZZA/Fw4L3S+j0rO63swlSzP1OYR1U2GWoV7gZK4aZIUsLM+gsDHnA4a15VfVi+fnm77Fx315uIylCe+/UIUlnPjyqJjRhjKoyNt3FPP97bzgu2U=
Received: from BN9PR03CA0350.namprd03.prod.outlook.com (2603:10b6:408:f6::25)
 by DM4PR12MB5375.namprd12.prod.outlook.com (2603:10b6:5:389::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 01:31:28 +0000
Received: from BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:f6:cafe::9c) by BN9PR03CA0350.outlook.office365.com
 (2603:10b6:408:f6::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.17 via Frontend
 Transport; Thu, 9 Mar 2023 01:31:28 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT047.mail.protection.outlook.com (10.13.177.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.17 via Frontend Transport; Thu, 9 Mar 2023 01:31:28 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 8 Mar
 2023 19:31:25 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH RFC v2 virtio 3/7] pds_vdpa: virtio bar setup for vdpa
Date:   Wed, 8 Mar 2023 17:30:42 -0800
Message-ID: <20230309013046.23523-4-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT047:EE_|DM4PR12MB5375:EE_
X-MS-Office365-Filtering-Correlation-Id: 18e61053-7ae9-4670-ea61-08db203e0169
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KTUQMzP1eiABYFDIm4hgoZ4mDF9jOvPcnXS92Oy7RfqkV9KjrqL2BBfqZnh3p4GLUu0AavOtcsFc9FXfw5ojzfnhKjQd/xMf1mxeloUv4wd0JDo6LMG2KgxE4ncuu2IWo399e2u7vTqQZNgtABLgBTtYWuEVxYffDwrYgH2819aCo6mQGZ5+leKftCzGNJdgqEZmIufO365Aaage2M0mfynVnIR12b/s+38Q3zZTHCKSPE1Rq01Nly4KxLHp8Sod3ZU/kNDRfTW0UAC/YHJOKgXrUj2zvsVNhOxR2501H6rMhVhWYydINb9X3zB2w4TsuemLNgaYeTS5oquuBmJqNjeANKmVxvV2vf9SApmE/0MCsF6DH0TNQg0oHAdN0qs4NTwW2iCL/TMTrngvVlL9i7F+5hJSlR39IWdpqA3fPImRYfR+vAWsEmyqnn216CcxIaEy2TC/ZEG8gb4gOVw9QJr0ZyOuBOxSeCJ9+4XXLri2mD/sDSlVgtxdY3JuS/qC8wChyaM+Yx2VZIqHjCOhR09davxaR3dmlsAS0DB01Gpr57re0ZsAbl/JLU2+r9bxFRPNV1BqcIXUW8gjpotzcrMDDgSnwylWTng8RdyoY98FPPKRkFaJvac8fJMIXbnjAD3Ake+F4XiLNwrYjGtHxunENUiLiyL8s5oNURZKMHWS5QzrwI/wEoEehU2www3/SpPP+oOocN/PsbzZmiRD3dwtBJPkf9TbGsmNtzBfM2Q=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(136003)(376002)(451199018)(36840700001)(46966006)(40470700004)(40460700003)(36756003)(110136005)(478600001)(316002)(5660300002)(4326008)(2906002)(8936002)(30864003)(70586007)(8676002)(70206006)(44832011)(41300700001)(82740400003)(81166007)(36860700001)(356005)(40480700001)(86362001)(186003)(16526019)(6666004)(2616005)(1076003)(26005)(83380400001)(82310400005)(336012)(47076005)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 01:31:28.6368
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 18e61053-7ae9-4670-ea61-08db203e0169
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT047.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5375
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The PDS vDPA device has a virtio BAR for describing itself, and
the pds_vdpa driver needs to access it.  Here we copy liberally
from the existing drivers/virtio/virtio_pci_modern_dev.c as it
has what we need, but we need to modify it so that it can work
with our device id and so we can use our own DMA mask.

We suspect there is room for discussion here about making the
existing code a little more flexible, but we thought we'd at
least start the discussion here.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vdpa/pds/Makefile     |   1 +
 drivers/vdpa/pds/aux_drv.c    |  14 ++
 drivers/vdpa/pds/aux_drv.h    |   1 +
 drivers/vdpa/pds/debugfs.c    |   1 +
 drivers/vdpa/pds/vdpa_dev.c   |   1 +
 drivers/vdpa/pds/virtio_pci.c | 281 ++++++++++++++++++++++++++++++++++
 drivers/vdpa/pds/virtio_pci.h |   8 +
 7 files changed, 307 insertions(+)
 create mode 100644 drivers/vdpa/pds/virtio_pci.c
 create mode 100644 drivers/vdpa/pds/virtio_pci.h

diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
index 13b50394ec64..ca2efa8c6eb5 100644
--- a/drivers/vdpa/pds/Makefile
+++ b/drivers/vdpa/pds/Makefile
@@ -4,6 +4,7 @@
 obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
 
 pds_vdpa-y := aux_drv.o \
+	      virtio_pci.o \
 	      vdpa_dev.o
 
 pds_vdpa-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/vdpa/pds/aux_drv.c b/drivers/vdpa/pds/aux_drv.c
index 63e40ae68211..28158d0d98a5 100644
--- a/drivers/vdpa/pds/aux_drv.c
+++ b/drivers/vdpa/pds/aux_drv.c
@@ -4,6 +4,7 @@
 #include <linux/auxiliary_bus.h>
 #include <linux/pci.h>
 #include <linux/vdpa.h>
+#include <linux/virtio_pci_modern.h>
 
 #include <linux/pds/pds_core.h>
 #include <linux/pds/pds_auxbus.h>
@@ -12,6 +13,7 @@
 #include "aux_drv.h"
 #include "debugfs.h"
 #include "vdpa_dev.h"
+#include "virtio_pci.h"
 
 static const struct auxiliary_device_id pds_vdpa_id_table[] = {
 	{ .name = PDS_VDPA_DEV_NAME, },
@@ -49,8 +51,19 @@ static int pds_vdpa_probe(struct auxiliary_device *aux_dev,
 	if (err)
 		goto err_aux_unreg;
 
+	/* Find the virtio configuration */
+	vdpa_aux->vd_mdev.pci_dev = padev->vf->pdev;
+	err = pds_vdpa_probe_virtio(&vdpa_aux->vd_mdev);
+	if (err) {
+		dev_err(dev, "Unable to probe for virtio configuration: %pe\n",
+			ERR_PTR(err));
+		goto err_free_mgmt_info;
+	}
+
 	return 0;
 
+err_free_mgmt_info:
+	pci_free_irq_vectors(padev->vf->pdev);
 err_aux_unreg:
 	padev->ops->unregister_client(padev);
 err_free_mem:
@@ -65,6 +78,7 @@ static void pds_vdpa_remove(struct auxiliary_device *aux_dev)
 	struct pds_vdpa_aux *vdpa_aux = auxiliary_get_drvdata(aux_dev);
 	struct device *dev = &aux_dev->dev;
 
+	pds_vdpa_remove_virtio(&vdpa_aux->vd_mdev);
 	pci_free_irq_vectors(vdpa_aux->padev->vf->pdev);
 
 	vdpa_aux->padev->ops->unregister_client(vdpa_aux->padev);
diff --git a/drivers/vdpa/pds/aux_drv.h b/drivers/vdpa/pds/aux_drv.h
index 94ba7abcaa43..87ac3c01c476 100644
--- a/drivers/vdpa/pds/aux_drv.h
+++ b/drivers/vdpa/pds/aux_drv.h
@@ -16,6 +16,7 @@ struct pds_vdpa_aux {
 
 	int vf_id;
 	struct dentry *dentry;
+	struct virtio_pci_modern_device vd_mdev;
 
 	int nintrs;
 };
diff --git a/drivers/vdpa/pds/debugfs.c b/drivers/vdpa/pds/debugfs.c
index 7b7e90fd6578..aa5e9677fe74 100644
--- a/drivers/vdpa/pds/debugfs.c
+++ b/drivers/vdpa/pds/debugfs.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /* Copyright(c) 2023 Advanced Micro Devices, Inc */
 
+#include <linux/virtio_pci_modern.h>
 #include <linux/vdpa.h>
 
 #include <linux/pds/pds_core.h>
diff --git a/drivers/vdpa/pds/vdpa_dev.c b/drivers/vdpa/pds/vdpa_dev.c
index bd840688503c..15d623297203 100644
--- a/drivers/vdpa/pds/vdpa_dev.c
+++ b/drivers/vdpa/pds/vdpa_dev.c
@@ -4,6 +4,7 @@
 #include <linux/pci.h>
 #include <linux/vdpa.h>
 #include <uapi/linux/vdpa.h>
+#include <linux/virtio_pci_modern.h>
 
 #include <linux/pds/pds_core.h>
 #include <linux/pds/pds_adminq.h>
diff --git a/drivers/vdpa/pds/virtio_pci.c b/drivers/vdpa/pds/virtio_pci.c
new file mode 100644
index 000000000000..cb879619dac3
--- /dev/null
+++ b/drivers/vdpa/pds/virtio_pci.c
@@ -0,0 +1,281 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+
+/*
+ * adapted from drivers/virtio/virtio_pci_modern_dev.c, v6.0-rc1
+ */
+
+#include <linux/virtio_pci_modern.h>
+#include <linux/pci.h>
+
+#include "virtio_pci.h"
+
+/*
+ * pds_vdpa_map_capability - map a part of virtio pci capability
+ * @mdev: the modern virtio-pci device
+ * @off: offset of the capability
+ * @minlen: minimal length of the capability
+ * @align: align requirement
+ * @start: start from the capability
+ * @size: map size
+ * @len: the length that is actually mapped
+ * @pa: physical address of the capability
+ *
+ * Returns the io address of for the part of the capability
+ */
+static void __iomem *
+pds_vdpa_map_capability(struct virtio_pci_modern_device *mdev, int off,
+			size_t minlen, u32 align, u32 start, u32 size,
+			size_t *len, resource_size_t *pa)
+{
+	struct pci_dev *dev = mdev->pci_dev;
+	u8 bar;
+	u32 offset, length;
+	void __iomem *p;
+
+	pci_read_config_byte(dev, off + offsetof(struct virtio_pci_cap,
+						 bar),
+			     &bar);
+	pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, offset),
+			      &offset);
+	pci_read_config_dword(dev, off + offsetof(struct virtio_pci_cap, length),
+			      &length);
+
+	/* Check if the BAR may have changed since we requested the region. */
+	if (bar >= PCI_STD_NUM_BARS || !(mdev->modern_bars & (1 << bar))) {
+		dev_err(&dev->dev,
+			"virtio_pci: bar unexpectedly changed to %u\n", bar);
+		return NULL;
+	}
+
+	if (length <= start) {
+		dev_err(&dev->dev,
+			"virtio_pci: bad capability len %u (>%u expected)\n",
+			length, start);
+		return NULL;
+	}
+
+	if (length - start < minlen) {
+		dev_err(&dev->dev,
+			"virtio_pci: bad capability len %u (>=%zu expected)\n",
+			length, minlen);
+		return NULL;
+	}
+
+	length -= start;
+
+	if (start + offset < offset) {
+		dev_err(&dev->dev,
+			"virtio_pci: map wrap-around %u+%u\n",
+			start, offset);
+		return NULL;
+	}
+
+	offset += start;
+
+	if (offset & (align - 1)) {
+		dev_err(&dev->dev,
+			"virtio_pci: offset %u not aligned to %u\n",
+			offset, align);
+		return NULL;
+	}
+
+	if (length > size)
+		length = size;
+
+	if (len)
+		*len = length;
+
+	if (minlen + offset < minlen ||
+	    minlen + offset > pci_resource_len(dev, bar)) {
+		dev_err(&dev->dev,
+			"virtio_pci: map virtio %zu@%u out of range on bar %i length %lu\n",
+			minlen, offset,
+			bar, (unsigned long)pci_resource_len(dev, bar));
+		return NULL;
+	}
+
+	p = pci_iomap_range(dev, bar, offset, length);
+	if (!p)
+		dev_err(&dev->dev,
+			"virtio_pci: unable to map virtio %u@%u on bar %i\n",
+			length, offset, bar);
+	else if (pa)
+		*pa = pci_resource_start(dev, bar) + offset;
+
+	return p;
+}
+
+/**
+ * virtio_pci_find_capability - walk capabilities to find device info.
+ * @dev: the pci device
+ * @cfg_type: the VIRTIO_PCI_CAP_* value we seek
+ * @ioresource_types: IORESOURCE_MEM and/or IORESOURCE_IO.
+ * @bars: the bitmask of BARs
+ *
+ * Returns offset of the capability, or 0.
+ */
+static inline int virtio_pci_find_capability(struct pci_dev *dev, u8 cfg_type,
+					     u32 ioresource_types, int *bars)
+{
+	int pos;
+
+	for (pos = pci_find_capability(dev, PCI_CAP_ID_VNDR);
+	     pos > 0;
+	     pos = pci_find_next_capability(dev, pos, PCI_CAP_ID_VNDR)) {
+		u8 type, bar;
+
+		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
+							 cfg_type),
+				     &type);
+		pci_read_config_byte(dev, pos + offsetof(struct virtio_pci_cap,
+							 bar),
+				     &bar);
+
+		/* Ignore structures with reserved BAR values */
+		if (bar >= PCI_STD_NUM_BARS)
+			continue;
+
+		if (type == cfg_type) {
+			if (pci_resource_len(dev, bar) &&
+			    pci_resource_flags(dev, bar) & ioresource_types) {
+				*bars |= (1 << bar);
+				return pos;
+			}
+		}
+	}
+	return 0;
+}
+
+/*
+ * pds_vdpa_probe_virtio: probe the modern virtio pci device, note that the
+ * caller is required to enable PCI device before calling this function.
+ * @mdev: the modern virtio-pci device
+ *
+ * Return 0 on succeed otherwise fail
+ */
+int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev)
+{
+	struct pci_dev *pci_dev = mdev->pci_dev;
+	int err, common, isr, notify, device;
+	u32 notify_length;
+	u32 notify_offset;
+
+	/* check for a common config: if not, use legacy mode (bar 0). */
+	common = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_COMMON_CFG,
+					    IORESOURCE_IO | IORESOURCE_MEM,
+					    &mdev->modern_bars);
+	if (!common) {
+		dev_info(&pci_dev->dev,
+			 "virtio_pci: missing common config\n");
+		return -ENODEV;
+	}
+
+	/* If common is there, these should be too... */
+	isr = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_ISR_CFG,
+					 IORESOURCE_IO | IORESOURCE_MEM,
+					 &mdev->modern_bars);
+	notify = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_NOTIFY_CFG,
+					    IORESOURCE_IO | IORESOURCE_MEM,
+					    &mdev->modern_bars);
+	if (!isr || !notify) {
+		dev_err(&pci_dev->dev,
+			"virtio_pci: missing capabilities %i/%i/%i\n",
+			common, isr, notify);
+		return -EINVAL;
+	}
+
+	/* Device capability is only mandatory for devices that have
+	 * device-specific configuration.
+	 */
+	device = virtio_pci_find_capability(pci_dev, VIRTIO_PCI_CAP_DEVICE_CFG,
+					    IORESOURCE_IO | IORESOURCE_MEM,
+					    &mdev->modern_bars);
+
+	err = pci_request_selected_regions(pci_dev, mdev->modern_bars,
+					   "virtio-pci-modern");
+	if (err)
+		return err;
+
+	err = -EINVAL;
+	mdev->common = pds_vdpa_map_capability(mdev, common,
+					       sizeof(struct virtio_pci_common_cfg),
+					       4, 0,
+					       sizeof(struct virtio_pci_common_cfg),
+					       NULL, NULL);
+	if (!mdev->common)
+		goto err_map_common;
+	mdev->isr = pds_vdpa_map_capability(mdev, isr, sizeof(u8), 1,
+					    0, 1, NULL, NULL);
+	if (!mdev->isr)
+		goto err_map_isr;
+
+	/* Read notify_off_multiplier from config space. */
+	pci_read_config_dword(pci_dev,
+			      notify + offsetof(struct virtio_pci_notify_cap,
+						notify_off_multiplier),
+			      &mdev->notify_offset_multiplier);
+	/* Read notify length and offset from config space. */
+	pci_read_config_dword(pci_dev,
+			      notify + offsetof(struct virtio_pci_notify_cap,
+						cap.length),
+			      &notify_length);
+
+	pci_read_config_dword(pci_dev,
+			      notify + offsetof(struct virtio_pci_notify_cap,
+						cap.offset),
+			      &notify_offset);
+
+	/* We don't know how many VQs we'll map, ahead of the time.
+	 * If notify length is small, map it all now.
+	 * Otherwise, map each VQ individually later.
+	 */
+	if ((u64)notify_length + (notify_offset % PAGE_SIZE) <= PAGE_SIZE) {
+		mdev->notify_base = pds_vdpa_map_capability(mdev, notify,
+							    2, 2,
+							    0, notify_length,
+							    &mdev->notify_len,
+							    &mdev->notify_pa);
+		if (!mdev->notify_base)
+			goto err_map_notify;
+	} else {
+		mdev->notify_map_cap = notify;
+	}
+
+	/* Again, we don't know how much we should map, but PAGE_SIZE
+	 * is more than enough for all existing devices.
+	 */
+	if (device) {
+		mdev->device = pds_vdpa_map_capability(mdev, device, 0, 4,
+						       0, PAGE_SIZE,
+						       &mdev->device_len,
+						       NULL);
+		if (!mdev->device)
+			goto err_map_device;
+	}
+
+	return 0;
+
+err_map_device:
+	if (mdev->notify_base)
+		pci_iounmap(pci_dev, mdev->notify_base);
+err_map_notify:
+	pci_iounmap(pci_dev, mdev->isr);
+err_map_isr:
+	pci_iounmap(pci_dev, mdev->common);
+err_map_common:
+	pci_release_selected_regions(pci_dev, mdev->modern_bars);
+	return err;
+}
+
+void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev)
+{
+	struct pci_dev *pci_dev = mdev->pci_dev;
+
+	if (mdev->device)
+		pci_iounmap(pci_dev, mdev->device);
+	if (mdev->notify_base)
+		pci_iounmap(pci_dev, mdev->notify_base);
+	pci_iounmap(pci_dev, mdev->isr);
+	pci_iounmap(pci_dev, mdev->common);
+	pci_release_selected_regions(pci_dev, mdev->modern_bars);
+}
diff --git a/drivers/vdpa/pds/virtio_pci.h b/drivers/vdpa/pds/virtio_pci.h
new file mode 100644
index 000000000000..f017cfa1173c
--- /dev/null
+++ b/drivers/vdpa/pds/virtio_pci.h
@@ -0,0 +1,8 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDS_VIRTIO_PCI_H_
+#define _PDS_VIRTIO_PCI_H_
+int pds_vdpa_probe_virtio(struct virtio_pci_modern_device *mdev);
+void pds_vdpa_remove_virtio(struct virtio_pci_modern_device *mdev);
+#endif /* _PDS_VIRTIO_PCI_H_ */
-- 
2.17.1


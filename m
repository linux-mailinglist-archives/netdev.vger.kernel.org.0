Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95E84AC748
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:28:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348002AbiBGR1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:27:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347970AbiBGRYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:24:04 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2072.outbound.protection.outlook.com [40.107.95.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9AA7C0401D5;
        Mon,  7 Feb 2022 09:24:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mGu+Z8FzZNEQPcfY1kDnao2BH5JQAszao9VhN4mIVE7f4ohixS1MesjNuQGo/yFvfUI0OWmFihn+Tc4y+SAorMsWp8D3DhFiuIX5Unqa/uiXEPeaN6jFb/1EzWSgAGGkOfoKpenhTR3mPdjsvA5gOCD5SHWvpSz4+fcH4IpbIxnzOsu6ur/oIEELlXoFwsIX5NVohgZIvKaZA3FCoglP7emreymxCRuKq8HXNsnS8rEMj9aATzbIEpLdW7YGlAYjw4lukrlamvsrkytbyVLoGeM046FURC5f2Lnlh+ghBczOEmkpUAWUmwPbhal/xSI53GWIiU2Hsxjy8b+BqIQfYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=B2gqo36AsqcOWsCRHVcyIRNnLFyVBClgs0dzR2caT94=;
 b=Kp2JIL7Qk3Fd1gpn3EkwzVbeBCygakfPcdR9C+/3nK3hIZJGrxRfNBTA8LKC3TsgIaxFKANg1cBzSj4XnZGjfbEh4hE4NpNO6ZEu2Ed1clmlxuKVpleNKQ8GWh5t61snUF27yQumURAFJWMH8EpDJWJdvAX3EX2bjuzuYC/syEyibbvZPuWwm8sZsl+kSN2r9tbV2Rlxg55uNN0oQM4uHKLHg6hysDr3nV3TGQZMydB2wg1db1ye0F9Zf3yDiA0X9WrrkZOgp946PQyw8dhptmX9gW8Eki2Sd2sCXvDnIVUlCpHYzz7Of5TKXaLsL2ZxsQ2Su07DZcpc5jq5RIb0Gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.235) smtp.rcpttodomain=intel.com smtp.mailfrom=nvidia.com; dmarc=pass
 (p=reject sp=reject pct=100) action=none header.from=nvidia.com; dkim=none
 (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=B2gqo36AsqcOWsCRHVcyIRNnLFyVBClgs0dzR2caT94=;
 b=dZAqPb9Rmx7SAR8dB2vwZBkUTtnMd2ERrx15dPp/2eVEzZ6SUwmSn1XcP68muVCxtlSf+p1wzEJNgPh1slQMi8Wo0Exqi7258ZPxcbQCyjwmEeOxDLPl9hKFSU/JgMQpUOtXbPKkimdNTdN585Ngv0XhjAJ8wndfBBjwl4Pcsj5+rib79BlyzPwiyasXuWRBuADuzSkhPN8kE2rTMHDk/TC1EPKPWs28SLdmreeKZMXfCzIcKbv3OxiQ2YUW3zMIw9y5FpTdlxLW+UwavXDciuwFCGZR197ewtVtRvEbvUjA16reCRK68+1vXr26+bxy8MDg/QBdzklyPa0rsDE4CQ==
Received: from BN0PR03CA0036.namprd03.prod.outlook.com (2603:10b6:408:e7::11)
 by BYAPR12MB2648.namprd12.prod.outlook.com (2603:10b6:a03:69::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.18; Mon, 7 Feb
 2022 17:24:00 +0000
Received: from BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e7:cafe::96) by BN0PR03CA0036.outlook.office365.com
 (2603:10b6:408:e7::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12 via Frontend
 Transport; Mon, 7 Feb 2022 17:23:59 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.235)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.235 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.235; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.235) by
 BN8NAM11FT017.mail.protection.outlook.com (10.13.177.93) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4951.12 via Frontend Transport; Mon, 7 Feb 2022 17:23:59 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL107.nvidia.com
 (10.27.9.16) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 7 Feb
 2022 17:23:58 +0000
Received: from rnnvmail201.nvidia.com (10.129.68.8) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Mon, 7 Feb 2022
 09:23:57 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.8)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Mon, 7 Feb
 2022 09:23:53 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <ashok.raj@intel.com>,
        <kevin.tian@intel.com>, <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V7 mlx5-next 12/15] vfio/mlx5: Implement vfio_pci driver for mlx5 devices
Date:   Mon, 7 Feb 2022 19:22:13 +0200
Message-ID: <20220207172216.206415-13-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220207172216.206415-1-yishaih@nvidia.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ec91a05-9af3-4c2e-ab59-08d9ea5ea0b8
X-MS-TrafficTypeDiagnostic: BYAPR12MB2648:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB2648BAA1FA7D50A690D2E8E4C32C9@BYAPR12MB2648.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:345;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gOLDBIDpPRWvpxLcU4uOWJYOSrJ1WNprVijg+fRBAfRbdzChavLl+OAun/keSdty9WpH5XC8sbMuZMRh1HMldy0xDivTuQ2ah5iPaBoMZKGfmpNE4kcHHEzKpooJnJBdGv9SlGo0ELAJOzwrvP16nvh28+dYtb8SdU3F+sDAjKsfeu8li0pvGTie/g5ZM0kZhvMAtS2gYcsGWb92JNIZF4njpaXcsKttnsr+yrC/nk21WMaQ80M544j1FXv5T4/gCMqGxfc5deNndL3enfIk6538v6mh3GbMroAIFCAcN3ocXk5HZUEFagOyT4LBMZNUkphiJdhJ0Zsu4PhcuMFSp0SQASBaR/kgKMSoBTwyPQPwPXVXfPiIneCiLvoV/aDd9rrRAyrgtiB+cRm3VOKPje8R6cQV9TyG3ldTFaxAe58QHUy6dbTQO4qUkgRsHLugvV0rGeGcAF45rNWjKb+O/v9dhDC/KW86Eag8uAqmFwqTJB1DkOy3lRf9veSMOTgg/sJ1zTc0W29Hdk2RFKAr2xpgpxeOX4hD5eFdTK/DuW+Zwlc/YXs/W0YLFEcdRz6cPy5q+MxdrBxc39X+CDVi21PqcApnqzIc8UyKzV4oZlsFEI6BBMgmHcOzmK6fAmw6ssi+AXA7sTTiaxU9Ca7GSxsMfK1dmBqoiVZtLUWmkkJrEqugk1JMFqPsKKmPJcsSPJiutESfEqCp4DmBLvus6g==
X-Forefront-Antispam-Report: CIP:12.22.5.235;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(36840700001)(46966006)(356005)(8676002)(86362001)(70586007)(82310400004)(8936002)(70206006)(2906002)(4326008)(30864003)(81166007)(508600001)(1076003)(2616005)(36756003)(7696005)(6666004)(110136005)(83380400001)(54906003)(26005)(186003)(6636002)(316002)(40460700003)(336012)(36860700001)(47076005)(426003)(5660300002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2022 17:23:59.1574
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ec91a05-9af3-4c2e-ab59-08d9ea5ea0b8
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.235];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT017.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB2648
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch adds support for vfio_pci driver for mlx5 devices.

It uses vfio_pci_core to register to the VFIO subsystem and then
implements the mlx5 specific logic in the migration area.

The migration implementation follows the definition from uapi/vfio.h and
uses the mlx5 VF->PF command channel to achieve it.

This patch implements the suspend/resume flows.

Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
---
 MAINTAINERS                    |   6 +
 drivers/vfio/pci/Kconfig       |   3 +
 drivers/vfio/pci/Makefile      |   2 +
 drivers/vfio/pci/mlx5/Kconfig  |  10 +
 drivers/vfio/pci/mlx5/Makefile |   4 +
 drivers/vfio/pci/mlx5/cmd.h    |   1 +
 drivers/vfio/pci/mlx5/main.c   | 623 +++++++++++++++++++++++++++++++++
 7 files changed, 649 insertions(+)
 create mode 100644 drivers/vfio/pci/mlx5/Kconfig
 create mode 100644 drivers/vfio/pci/mlx5/Makefile
 create mode 100644 drivers/vfio/pci/mlx5/main.c

diff --git a/MAINTAINERS b/MAINTAINERS
index ea3e6c914384..5c5216f5e43d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -20260,6 +20260,12 @@ L:	kvm@vger.kernel.org
 S:	Maintained
 F:	drivers/vfio/platform/
 
+VFIO MLX5 PCI DRIVER
+M:	Yishai Hadas <yishaih@nvidia.com>
+L:	kvm@vger.kernel.org
+S:	Maintained
+F:	drivers/vfio/pci/mlx5/
+
 VGA_SWITCHEROO
 R:	Lukas Wunner <lukas@wunner.de>
 S:	Maintained
diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 860424ccda1b..187b9c259944 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -43,4 +43,7 @@ config VFIO_PCI_IGD
 
 	  To enable Intel IGD assignment through vfio-pci, say Y.
 endif
+
+source "drivers/vfio/pci/mlx5/Kconfig"
+
 endif
diff --git a/drivers/vfio/pci/Makefile b/drivers/vfio/pci/Makefile
index 349d68d242b4..ed9d6f2e0555 100644
--- a/drivers/vfio/pci/Makefile
+++ b/drivers/vfio/pci/Makefile
@@ -7,3 +7,5 @@ obj-$(CONFIG_VFIO_PCI_CORE) += vfio-pci-core.o
 vfio-pci-y := vfio_pci.o
 vfio-pci-$(CONFIG_VFIO_PCI_IGD) += vfio_pci_igd.o
 obj-$(CONFIG_VFIO_PCI) += vfio-pci.o
+
+obj-$(CONFIG_MLX5_VFIO_PCI)           += mlx5/
diff --git a/drivers/vfio/pci/mlx5/Kconfig b/drivers/vfio/pci/mlx5/Kconfig
new file mode 100644
index 000000000000..29ba9c504a75
--- /dev/null
+++ b/drivers/vfio/pci/mlx5/Kconfig
@@ -0,0 +1,10 @@
+# SPDX-License-Identifier: GPL-2.0-only
+config MLX5_VFIO_PCI
+	tristate "VFIO support for MLX5 PCI devices"
+	depends on MLX5_CORE
+	depends on VFIO_PCI_CORE
+	help
+	  This provides migration support for MLX5 devices using the VFIO
+	  framework.
+
+	  If you don't know what to do here, say N.
diff --git a/drivers/vfio/pci/mlx5/Makefile b/drivers/vfio/pci/mlx5/Makefile
new file mode 100644
index 000000000000..689627da7ff5
--- /dev/null
+++ b/drivers/vfio/pci/mlx5/Makefile
@@ -0,0 +1,4 @@
+# SPDX-License-Identifier: GPL-2.0-only
+obj-$(CONFIG_MLX5_VFIO_PCI) += mlx5-vfio-pci.o
+mlx5-vfio-pci-y := main.o cmd.o
+
diff --git a/drivers/vfio/pci/mlx5/cmd.h b/drivers/vfio/pci/mlx5/cmd.h
index 69a1481ed953..1392a11a9cc0 100644
--- a/drivers/vfio/pci/mlx5/cmd.h
+++ b/drivers/vfio/pci/mlx5/cmd.h
@@ -12,6 +12,7 @@
 struct mlx5_vf_migration_file {
 	struct file *filp;
 	struct mutex lock;
+	bool disabled;
 
 	struct sg_append_table table;
 	size_t total_length;
diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
new file mode 100644
index 000000000000..acd205bcff70
--- /dev/null
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -0,0 +1,623 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/*
+ * Copyright (c) 2021-2022, NVIDIA CORPORATION & AFFILIATES. All rights reserved
+ */
+
+#include <linux/device.h>
+#include <linux/eventfd.h>
+#include <linux/file.h>
+#include <linux/interrupt.h>
+#include <linux/iommu.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/notifier.h>
+#include <linux/pci.h>
+#include <linux/pm_runtime.h>
+#include <linux/types.h>
+#include <linux/uaccess.h>
+#include <linux/vfio.h>
+#include <linux/sched/mm.h>
+#include <linux/vfio_pci_core.h>
+#include <linux/anon_inodes.h>
+
+#include "cmd.h"
+
+/* Arbitrary to prevent userspace from consuming endless memory */
+#define MAX_MIGRATION_SIZE (512*1024*1024)
+
+struct mlx5vf_pci_core_device {
+	struct vfio_pci_core_device core_device;
+	u8 migrate_cap:1;
+	/* protect migration state */
+	struct mutex state_mutex;
+	enum vfio_device_mig_state mig_state;
+	u16 vhca_id;
+	struct mlx5_vf_migration_file *resuming_migf;
+	struct mlx5_vf_migration_file *saving_migf;
+};
+
+static struct page *
+mlx5vf_get_migration_page(struct mlx5_vf_migration_file *migf,
+			  unsigned long offset)
+{
+	unsigned long cur_offset = 0;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	/* All accesses are sequential */
+	if (offset < migf->last_offset || !migf->last_offset_sg) {
+		migf->last_offset = 0;
+		migf->last_offset_sg = migf->table.sgt.sgl;
+		migf->sg_last_entry = 0;
+	}
+
+	cur_offset = migf->last_offset;
+
+	for_each_sg(migf->last_offset_sg, sg,
+			migf->table.sgt.orig_nents - migf->sg_last_entry, i) {
+		if (offset < sg->length + cur_offset) {
+			migf->last_offset_sg = sg;
+			migf->sg_last_entry += i;
+			migf->last_offset = cur_offset;
+			return nth_page(sg_page(sg),
+					(offset - cur_offset) / PAGE_SIZE);
+		}
+		cur_offset += sg->length;
+	}
+	return NULL;
+}
+
+static int mlx5vf_add_migration_pages(struct mlx5_vf_migration_file *migf,
+				      unsigned int npages)
+{
+	unsigned int to_alloc = npages;
+	struct page **page_list;
+	unsigned long filled;
+	unsigned int to_fill;
+	int ret;
+
+	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
+	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL);
+	if (!page_list)
+		return -ENOMEM;
+
+	do {
+		filled = alloc_pages_bulk_array(GFP_KERNEL, to_fill, page_list);
+		if (!filled) {
+			ret = -ENOMEM;
+			goto err;
+		}
+		to_alloc -= filled;
+		ret = sg_alloc_append_table_from_pages(
+			&migf->table, page_list, filled, 0,
+			filled << PAGE_SHIFT, UINT_MAX, SG_MAX_SINGLE_ALLOC,
+			GFP_KERNEL);
+
+		if (ret)
+			goto err;
+		migf->allocated_length += filled * PAGE_SIZE;
+		/* clean input for another bulk allocation */
+		memset(page_list, 0, filled * sizeof(*page_list));
+		to_fill = min_t(unsigned int, to_alloc,
+				PAGE_SIZE / sizeof(*page_list));
+	} while (to_alloc > 0);
+
+	kvfree(page_list);
+	return 0;
+
+err:
+	kvfree(page_list);
+	return ret;
+}
+
+static void mlx5vf_disable_fd(struct mlx5_vf_migration_file *migf)
+{
+	struct sg_page_iter sg_iter;
+
+	mutex_lock(&migf->lock);
+	/* Undo alloc_pages_bulk_array() */
+	for_each_sgtable_page(&migf->table.sgt, &sg_iter, 0)
+		__free_page(sg_page_iter_page(&sg_iter));
+	sg_free_append_table(&migf->table);
+	migf->disabled = true;
+	migf->total_length = 0;
+	migf->allocated_length = 0;
+	migf->filp->f_pos = 0;
+	mutex_unlock(&migf->lock);
+}
+
+static int mlx5vf_release_file(struct inode *inode, struct file *filp)
+{
+	struct mlx5_vf_migration_file *migf = filp->private_data;
+
+	mlx5vf_disable_fd(migf);
+	mutex_destroy(&migf->lock);
+	kfree(migf);
+	return 0;
+}
+
+static ssize_t mlx5vf_save_read(struct file *filp, char __user *buf, size_t len,
+			       loff_t *pos)
+{
+	struct mlx5_vf_migration_file *migf = filp->private_data;
+	ssize_t done = 0;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	mutex_lock(&migf->lock);
+	if (*pos > migf->total_length) {
+		done = -EINVAL;
+		goto out_unlock;
+	}
+	if (migf->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
+	len = min_t(size_t, migf->total_length - *pos, len);
+	while (len) {
+		size_t page_offset;
+		struct page *page;
+		size_t page_len;
+		u8 *from_buff;
+		int ret;
+
+		page_offset = (*pos) % PAGE_SIZE;
+		page = mlx5vf_get_migration_page(migf, *pos - page_offset);
+		if (!page) {
+			if (done == 0)
+				done = -EINVAL;
+			goto out_unlock;
+		}
+
+		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
+		from_buff = kmap_local_page(page);
+		ret = copy_to_user(buf, from_buff + page_offset, page_len);
+		kunmap_local(from_buff);
+		if (ret) {
+			done = -EFAULT;
+			goto out_unlock;
+		}
+		*pos += page_len;
+		len -= page_len;
+		done += page_len;
+		buf += page_len;
+	}
+
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static const struct file_operations mlx5vf_save_fops = {
+	.owner = THIS_MODULE,
+	.read = mlx5vf_save_read,
+	.release = mlx5vf_release_file,
+	.llseek = no_llseek,
+};
+
+static struct mlx5_vf_migration_file *
+mlx5vf_pci_save_device_data(struct mlx5vf_pci_core_device *mvdev)
+{
+	struct mlx5_vf_migration_file *migf;
+	int ret;
+
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->filp = anon_inode_getfile("mlx5vf_mig", &mlx5vf_save_fops, migf,
+					O_RDONLY);
+	if (IS_ERR(migf->filp)) {
+		int err = PTR_ERR(migf->filp);
+
+		kfree(migf);
+		return ERR_PTR(err);
+	}
+
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+
+	ret = mlx5vf_cmd_query_vhca_migration_state(
+		mvdev->core_device.pdev, mvdev->vhca_id, &migf->total_length);
+	if (ret)
+		goto out_free;
+
+	ret = mlx5vf_add_migration_pages(
+		migf, DIV_ROUND_UP_ULL(migf->total_length, PAGE_SIZE));
+	if (ret)
+		goto out_free;
+
+	ret = mlx5vf_cmd_save_vhca_state(mvdev->core_device.pdev,
+					 mvdev->vhca_id, migf);
+	if (ret)
+		goto out_free;
+	return migf;
+out_free:
+	fput(migf->filp);
+	return ERR_PTR(ret);
+}
+
+static ssize_t mlx5vf_resume_write(struct file *filp, const char __user *buf,
+				   size_t len, loff_t *pos)
+{
+	struct mlx5_vf_migration_file *migf = filp->private_data;
+	loff_t requested_length;
+	ssize_t done = 0;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	if (*pos < 0 ||
+	    check_add_overflow((loff_t)len, *pos, &requested_length))
+		return -EINVAL;
+
+	if (requested_length > MAX_MIGRATION_SIZE)
+		return -ENOMEM;
+
+	mutex_lock(&migf->lock);
+	if (migf->disabled) {
+		done = -ENODEV;
+		goto out_unlock;
+	}
+
+	if (migf->allocated_length < requested_length) {
+		done = mlx5vf_add_migration_pages(
+			migf,
+			DIV_ROUND_UP(requested_length - migf->allocated_length,
+				     PAGE_SIZE));
+		if (done)
+			goto out_unlock;
+	}
+
+	while (len) {
+		size_t page_offset;
+		struct page *page;
+		size_t page_len;
+		u8 *to_buff;
+		int ret;
+
+		page_offset = (*pos) % PAGE_SIZE;
+		page = mlx5vf_get_migration_page(migf, *pos - page_offset);
+		if (!page) {
+			if (done == 0)
+				done = -EINVAL;
+			goto out_unlock;
+		}
+
+		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
+		to_buff = kmap_local_page(page);
+		ret = copy_from_user(to_buff + page_offset, buf, page_len);
+		kunmap_local(to_buff);
+		if (ret) {
+			done = -EFAULT;
+			goto out_unlock;
+		}
+		*pos += page_len;
+		len -= page_len;
+		done += page_len;
+		buf += page_len;
+		migf->total_length += page_len;
+	}
+out_unlock:
+	mutex_unlock(&migf->lock);
+	return done;
+}
+
+static const struct file_operations mlx5vf_resume_fops = {
+	.owner = THIS_MODULE,
+	.write = mlx5vf_resume_write,
+	.release = mlx5vf_release_file,
+	.llseek = no_llseek,
+};
+
+static struct mlx5_vf_migration_file *
+mlx5vf_pci_resume_device_data(struct mlx5vf_pci_core_device *mvdev)
+{
+	struct mlx5_vf_migration_file *migf;
+
+	migf = kzalloc(sizeof(*migf), GFP_KERNEL);
+	if (!migf)
+		return ERR_PTR(-ENOMEM);
+
+	migf->filp = anon_inode_getfile("mlx5vf_mig", &mlx5vf_resume_fops, migf,
+					O_WRONLY);
+	if (IS_ERR(migf->filp)) {
+		int err = PTR_ERR(migf->filp);
+
+		kfree(migf);
+		return ERR_PTR(err);
+	}
+	stream_open(migf->filp->f_inode, migf->filp);
+	mutex_init(&migf->lock);
+	return migf;
+}
+
+static void mlx5vf_disable_fds(struct mlx5vf_pci_core_device *mvdev)
+{
+	if (mvdev->resuming_migf) {
+		mlx5vf_disable_fd(mvdev->resuming_migf);
+		fput(mvdev->resuming_migf->filp);
+		mvdev->resuming_migf = NULL;
+	}
+	if (mvdev->saving_migf) {
+		mlx5vf_disable_fd(mvdev->saving_migf);
+		fput(mvdev->saving_migf->filp);
+		mvdev->saving_migf = NULL;
+	}
+}
+
+static struct file *
+mlx5vf_pci_step_device_state_locked(struct mlx5vf_pci_core_device *mvdev,
+				    u32 new)
+{
+	u32 cur = mvdev->mig_state;
+	int ret;
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_STOP) {
+		ret = mlx5vf_cmd_suspend_vhca(
+			mvdev->core_device.pdev, mvdev->vhca_id,
+			MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_SLAVE);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+		ret = mlx5vf_cmd_resume_vhca(
+			mvdev->core_device.pdev, mvdev->vhca_id,
+			MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_SLAVE);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING && new == VFIO_DEVICE_STATE_RUNNING_P2P) {
+		ret = mlx5vf_cmd_suspend_vhca(
+			mvdev->core_device.pdev, mvdev->vhca_id,
+			MLX5_SUSPEND_VHCA_IN_OP_MOD_SUSPEND_MASTER);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && new == VFIO_DEVICE_STATE_RUNNING) {
+		ret = mlx5vf_cmd_resume_vhca(
+			mvdev->core_device.pdev, mvdev->vhca_id,
+			MLX5_RESUME_VHCA_IN_OP_MOD_RESUME_MASTER);
+		if (ret)
+			return ERR_PTR(ret);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_STOP_COPY) {
+		struct mlx5_vf_migration_file *migf;
+
+		migf = mlx5vf_pci_save_device_data(mvdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		mvdev->saving_migf = migf;
+		return migf->filp;
+	}
+
+	if ((cur == VFIO_DEVICE_STATE_STOP_COPY && new == VFIO_DEVICE_STATE_STOP)) {
+		mlx5vf_disable_fds(mvdev);
+		return 0;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && new == VFIO_DEVICE_STATE_RESUMING) {
+		struct mlx5_vf_migration_file *migf;
+
+		migf = mlx5vf_pci_resume_device_data(mvdev);
+		if (IS_ERR(migf))
+			return ERR_CAST(migf);
+		get_file(migf->filp);
+		mvdev->resuming_migf = migf;
+		return migf->filp;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RESUMING && new == VFIO_DEVICE_STATE_STOP) {
+		ret = mlx5vf_cmd_load_vhca_state(mvdev->core_device.pdev,
+						 mvdev->vhca_id,
+						 mvdev->resuming_migf);
+		if (ret)
+			return ERR_PTR(ret);
+		mlx5vf_disable_fds(mvdev);
+		return 0;
+	}
+
+	/*
+	 * vfio_mig_get_next_state() does not use arcs other than the above
+	 */
+	WARN_ON(true);
+	return ERR_PTR(-EINVAL);
+}
+
+static struct file *
+mlx5vf_pci_set_device_state(struct vfio_device *vdev,
+			    enum vfio_device_mig_state new_state)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+	enum vfio_device_mig_state next_state;
+	struct file *res = NULL;
+	int ret;
+
+	mutex_lock(&mvdev->state_mutex);
+	while (new_state != mvdev->mig_state) {
+		ret = vfio_mig_get_next_state(vdev, mvdev->mig_state,
+					      new_state, &next_state);
+		if (ret) {
+			res = ERR_PTR(ret);
+			break;
+		}
+		res = mlx5vf_pci_step_device_state_locked(mvdev, next_state);
+		if (IS_ERR(res))
+			break;
+		mvdev->mig_state = next_state;
+		if (WARN_ON(res && new_state != mvdev->mig_state)) {
+			fput(res);
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	mutex_unlock(&mvdev->state_mutex);
+	return res;
+}
+
+static int mlx5vf_pci_get_device_state(struct vfio_device *vdev,
+				       enum vfio_device_mig_state *curr_state)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+
+	mutex_lock(&mvdev->state_mutex);
+	*curr_state = mvdev->mig_state;
+	mutex_unlock(&mvdev->state_mutex);
+	return 0;
+}
+
+static int mlx5vf_pci_open_device(struct vfio_device *core_vdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+	struct vfio_pci_core_device *vdev = &mvdev->core_device;
+	int vf_id;
+	int ret;
+
+	ret = vfio_pci_core_enable(vdev);
+	if (ret)
+		return ret;
+
+	if (!mvdev->migrate_cap) {
+		vfio_pci_core_finish_enable(vdev);
+		return 0;
+	}
+
+	vf_id = pci_iov_vf_id(vdev->pdev);
+	if (vf_id < 0) {
+		ret = vf_id;
+		goto out_disable;
+	}
+
+	ret = mlx5vf_cmd_get_vhca_id(vdev->pdev, vf_id + 1, &mvdev->vhca_id);
+	if (ret)
+		goto out_disable;
+
+	mvdev->mig_state = VFIO_DEVICE_STATE_RUNNING;
+	vfio_pci_core_finish_enable(vdev);
+	return 0;
+out_disable:
+	vfio_pci_core_disable(vdev);
+	return ret;
+}
+
+static void mlx5vf_pci_close_device(struct vfio_device *core_vdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = container_of(
+		core_vdev, struct mlx5vf_pci_core_device, core_device.vdev);
+
+	mlx5vf_disable_fds(mvdev);
+	vfio_pci_core_close_device(core_vdev);
+}
+
+static const struct vfio_device_ops mlx5vf_pci_ops = {
+	.name = "mlx5-vfio-pci",
+	.open_device = mlx5vf_pci_open_device,
+	.close_device = mlx5vf_pci_close_device,
+	.ioctl = vfio_pci_core_ioctl,
+	.device_feature = vfio_pci_core_ioctl_feature,
+	.read = vfio_pci_core_read,
+	.write = vfio_pci_core_write,
+	.mmap = vfio_pci_core_mmap,
+	.request = vfio_pci_core_request,
+	.match = vfio_pci_core_match,
+	.migration_set_state = mlx5vf_pci_set_device_state,
+	.migration_get_state = mlx5vf_pci_get_device_state,
+};
+
+static int mlx5vf_pci_probe(struct pci_dev *pdev,
+			    const struct pci_device_id *id)
+{
+	struct mlx5vf_pci_core_device *mvdev;
+	int ret;
+
+	mvdev = kzalloc(sizeof(*mvdev), GFP_KERNEL);
+	if (!mvdev)
+		return -ENOMEM;
+	vfio_pci_core_init_device(&mvdev->core_device, pdev, &mlx5vf_pci_ops);
+
+	if (pdev->is_virtfn) {
+		struct mlx5_core_dev *mdev =
+			mlx5_vf_get_core_dev(pdev);
+
+		if (mdev) {
+			if (MLX5_CAP_GEN(mdev, migration)) {
+				mvdev->migrate_cap = 1;
+				mvdev->core_device.vdev.migration_flags =
+					VFIO_MIGRATION_STOP_COPY |
+					VFIO_MIGRATION_P2P;
+				mutex_init(&mvdev->state_mutex);
+			}
+			mlx5_vf_put_core_dev(mdev);
+		}
+	}
+
+	ret = vfio_pci_core_register_device(&mvdev->core_device);
+	if (ret)
+		goto out_free;
+
+	dev_set_drvdata(&pdev->dev, mvdev);
+	return 0;
+
+out_free:
+	vfio_pci_core_uninit_device(&mvdev->core_device);
+	kfree(mvdev);
+	return ret;
+}
+
+static void mlx5vf_pci_remove(struct pci_dev *pdev)
+{
+	struct mlx5vf_pci_core_device *mvdev = dev_get_drvdata(&pdev->dev);
+
+	vfio_pci_core_unregister_device(&mvdev->core_device);
+	vfio_pci_core_uninit_device(&mvdev->core_device);
+	kfree(mvdev);
+}
+
+static const struct pci_device_id mlx5vf_pci_table[] = {
+	{ PCI_DRIVER_OVERRIDE_DEVICE_VFIO(PCI_VENDOR_ID_MELLANOX, 0x101e) }, /* ConnectX Family mlx5Gen Virtual Function */
+	{}
+};
+
+MODULE_DEVICE_TABLE(pci, mlx5vf_pci_table);
+
+static struct pci_driver mlx5vf_pci_driver = {
+	.name = KBUILD_MODNAME,
+	.id_table = mlx5vf_pci_table,
+	.probe = mlx5vf_pci_probe,
+	.remove = mlx5vf_pci_remove,
+};
+
+static void __exit mlx5vf_pci_cleanup(void)
+{
+	pci_unregister_driver(&mlx5vf_pci_driver);
+}
+
+static int __init mlx5vf_pci_init(void)
+{
+	return pci_register_driver(&mlx5vf_pci_driver);
+}
+
+module_init(mlx5vf_pci_init);
+module_exit(mlx5vf_pci_cleanup);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Max Gurtovoy <mgurtovoy@nvidia.com>");
+MODULE_AUTHOR("Yishai Hadas <yishaih@nvidia.com>");
+MODULE_DESCRIPTION(
+	"MLX5 VFIO PCI - User Level meta-driver for MLX5 device family");
-- 
2.18.1


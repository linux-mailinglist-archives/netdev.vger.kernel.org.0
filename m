Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69AD34BCDFC
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 11:21:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243616AbiBTKAI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 05:00:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243618AbiBTJ7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 04:59:55 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam08on2055.outbound.protection.outlook.com [40.107.101.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2406454BE2;
        Sun, 20 Feb 2022 01:59:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H3MO+YUindNvO+C/3b2YXtDtwqvxv8xNEZPuas6p2wuUd7ZIIIuyK5yDx5wuJlDfOKI+URUZkFhswa0J5amupMN7s4XF7llaQaucogv1EflJmU4it3tvzn8/lPiA0PPRUD0K2nYrnLYwLkDepdCPVUS65GJg6Vv+x660PxeKea1JwTLw1rK9ImNHVyH4zgIbktCHMmS0DFriklxEOaEtAGIcQU44Y7ra8gVSZa64g00Nz/eLo9nC9ZPkFKaWaL5sdbIrGNDB/O5xmFl0GCS6oRsAQoIwoNzN2vz6wb/V3nw4a4CIvIhlsxKTBk6KW/zkVirXD7YN+DpcPT7c1JTRtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=h85Ed9cXh7fKv7P+w7OeQTFxr/J+CgydcYFcQplq+r4=;
 b=m+87bibwr3YqgaNkrdznzzztqTQcNwmncHWQySeU8Ox7nxl5ycvzl3LeERtXsWUmkX4N/29XhRXAeLRXmXSwLJDAloQK7jrsSDb/5FZkXm5ewViKfXhxrDDExU94rzvpEEdtuXZRMT35/M/plpjjTngE+yhbKElSz81NcYArhfmhZ9RzHCpd03WT2DiQD0dML4rEBtvfCZrJ8FSwO8w+/d3M0rrSlcYRpzF5uJWwi4jeugnDrzrFd5OXUYYZ491GgQvIqCGUkQOy9GKz0xkGsmHhmYcjh51Lmlu+ntQ+J1tvzTa0yU5uZunyhriIviwHpHnaXcc9qL8ZCk5ME+u0Pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 12.22.5.238) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h85Ed9cXh7fKv7P+w7OeQTFxr/J+CgydcYFcQplq+r4=;
 b=ZmBGhWm0YsI/VbhOyTs4k6O6r5iYh30w4HvQgoT2aPJPAI0ybVu5WwuzRyZbV169G2J/S56Z82kkq0N5rYHXqQpceDkEN+Kt2I7URsS7DYpn6Ci+0KsJewBHhHMm4IjnPXu5VIIkFiCtbTxVpj3x+D2CqkAN96A3HTtwNLdK6ykcuXcBjbGZn8kaPNybJWevwG3nQzqr1OvOicy40zm7g8LiuLXGNDNTIY2cHHUtVM6L9g9CLGDogKYz3upaHhOPh/TU2/zTF7TBdyuS+U/FtIRy5hlF71y2ZTWQB0HQxy7MOPv5ZYNmL0Sj8VddUfNq9S+gcAeJuPLgfGfg1h+MCg==
Received: from BN8PR15CA0009.namprd15.prod.outlook.com (2603:10b6:408:c0::22)
 by DM5PR1201MB2489.namprd12.prod.outlook.com (2603:10b6:3:e2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.24; Sun, 20 Feb
 2022 09:59:24 +0000
Received: from BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:c0:cafe::9d) by BN8PR15CA0009.outlook.office365.com
 (2603:10b6:408:c0::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.26 via Frontend
 Transport; Sun, 20 Feb 2022 09:59:24 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 12.22.5.238)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 12.22.5.238 as permitted sender) receiver=protection.outlook.com;
 client-ip=12.22.5.238; helo=mail.nvidia.com;
Received: from mail.nvidia.com (12.22.5.238) by
 BN8NAM11FT040.mail.protection.outlook.com (10.13.177.166) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4995.15 via Frontend Transport; Sun, 20 Feb 2022 09:59:22 +0000
Received: from rnnvmail204.nvidia.com (10.129.68.6) by DRHQMAIL105.nvidia.com
 (10.27.9.14) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Sun, 20 Feb
 2022 09:59:22 +0000
Received: from rnnvmail202.nvidia.com (10.129.68.7) by rnnvmail204.nvidia.com
 (10.129.68.6) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.9; Sun, 20 Feb 2022
 01:59:21 -0800
Received: from vdi.nvidia.com (10.127.8.10) by mail.nvidia.com (10.129.68.7)
 with Microsoft SMTP Server id 15.2.986.9 via Frontend Transport; Sun, 20 Feb
 2022 01:59:16 -0800
From:   Yishai Hadas <yishaih@nvidia.com>
To:     <alex.williamson@redhat.com>, <bhelgaas@google.com>,
        <jgg@nvidia.com>, <saeedm@nvidia.com>
CC:     <linux-pci@vger.kernel.org>, <kvm@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kuba@kernel.org>, <leonro@nvidia.com>,
        <kwankhede@nvidia.com>, <mgurtovoy@nvidia.com>,
        <yishaih@nvidia.com>, <maorg@nvidia.com>, <cohuck@redhat.com>,
        <ashok.raj@intel.com>, <kevin.tian@intel.com>,
        <shameerali.kolothum.thodi@huawei.com>
Subject: [PATCH V8 mlx5-next 13/15] vfio/mlx5: Implement vfio_pci driver for mlx5 devices
Date:   Sun, 20 Feb 2022 11:57:14 +0200
Message-ID: <20220220095716.153757-14-yishaih@nvidia.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20220220095716.153757-1-yishaih@nvidia.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a680239a-2606-4504-7b01-08d9f457ac79
X-MS-TrafficTypeDiagnostic: DM5PR1201MB2489:EE_
X-Microsoft-Antispam-PRVS: <DM5PR1201MB2489C9B1E5216E45AB8F922AC3399@DM5PR1201MB2489.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZBT9lMli5yP2Lf1Svy9Uzm+1bxaj038NWYbnVZW0hQY9d0Paxy/jw5WMaRrP9vhk4wMoPaWEPuiLDj3Up1TX41TcgyBF9sT9mzIofdXYznIAAbZ44NrrHozw5cVBAR8auZLhwNRF3nnILiA5OGRg148bSfNeeaeNvf/1pNnpnDEVKiO2ZFEyOY0tNj4VeQzOYoceGrXBO/zafzCFk0Dbdsp93r2BDf8PGf8ykMW9g48ybuXTNjLLnrhJDci9xlJv0NuvCZ4C5EmD46eDYUXq1qGWAUColUNs/yxXh1YOyW2KE23EnhJdSRiu50a4EYB4/2z/YBOPwnVEO5iBocJjXJETv+rfzdvRuuOywVr7hcqSrY0qdyM5pbBYlrFONZVD8rWfT9fdANaqbGuiB3fEbCk4F9x6S5csSuAOYcv7NaW2xnN8Gru6BlFL/9cX+L6W05bfCr73pYY6zeNgmsEtVrrV+uaQVkwHVLRgn6Z4EJempHojmkxp1lALOPfggdKfVQD6fX/AeKqJtOCOmFmiR5uXGTs2LMWMNEF/3IFx9+s75GcBHThDZgtGSIS+LctxGrnNTKnO0BJUOk1bSN6AuGpStYsgWc4M9ButUllxQy5kauHMqXLDFwNARvl9HsVs5hHe8sGOFhGM/l/P114F83pILR8D5DEQjAIiScIrvkwM4aKKWgzegV9apBjqhN+AHnPVZyxrdQtUdG32Quwq/Q==
X-Forefront-Antispam-Report: CIP:12.22.5.238;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230001)(4636009)(46966006)(40470700004)(36840700001)(186003)(30864003)(26005)(1076003)(8936002)(47076005)(2906002)(36860700001)(83380400001)(36756003)(40460700003)(70586007)(82310400004)(54906003)(316002)(2616005)(8676002)(426003)(336012)(4326008)(70206006)(81166007)(7696005)(7416002)(5660300002)(356005)(110136005)(508600001)(6636002)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Feb 2022 09:59:22.9486
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a680239a-2606-4504-7b01-08d9f457ac79
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.238];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT040.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2489
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 000000000000..2be78cc78928
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
+	u16 vhca_id;
+	u8 migrate_cap:1;
+	/* protect migration state */
+	struct mutex state_mutex;
+	enum vfio_device_mig_state mig_state;
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


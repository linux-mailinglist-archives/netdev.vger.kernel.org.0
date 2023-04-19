Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F00A6E800E
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:05:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233494AbjDSRFN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:05:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbjDSRFG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:06 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2066.outbound.protection.outlook.com [40.107.237.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713BE7696
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KQgzAN7AmQ5IFenlepgizIyCCKT+q3DWZrx5ln4pBLP4LT9Advidk8ubbD/4EakoHUIXuqHZFrtNMVj/S090SXm+3eHsHwIWQLohMFpX9N72KoYahNjNhGDwahfMZPOC01KU8Nt8BmY84VYaSPmc+T/vCi/ZdqUCUgl62V2/YaOlNFgwIjg0Hu0z6jUasgA9TkbrYvWryxEPmes3ZxfOL/ErJz63GpbV8R00bB35Cn6gVJZOYax41k/4uSs7BltrGjbqbjAk7jbGLIiSVTigXvmCFKwkf7RbrxSlQJYR7hBhO+0KDHhakDjDRCu3weo7pXCNOTdxQgoayBovDObL+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ntugBjq6M/iVoPHsztLnk8TosJHBy6uS+7tQGqmdlAk=;
 b=Gy/061FMpQOS3hLRFwaTzCukkegQJ7GhxN0x+kCpafE5aBcZu8BBHskzYC0mhy8RAVx6UnGbiBmR+2zmAWyLJyfH5YgIw05yXZMYH1EKCsBG5TbXDxXCoCVRoC4dEdvo4O9gQDy4JoAUN/uoVtyuopukjVeic6QtP5ghr4XAeVYBHLyifcsC09uJ1UjY+7gocuyr0IokxiDUDFvvxbBpZ0FCNCRLwjJ0vXhXVdWJzeHdpFdKuo0p4JzeUeMz6z0s4oBXoSVF127vFWbMdLxZ0cRkuFEWm+tLROAN//CYSketHti8ugSTLf8c2nla4sZstfyxVCoOx5e/VTqFg2OROg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ntugBjq6M/iVoPHsztLnk8TosJHBy6uS+7tQGqmdlAk=;
 b=WMLn4mSCUCw18gVuPQlMGJlRSPfuTyA7hV6qRmlJ2ckWZfMZTEN4fenwtsjpglUn1upmPEU3JCAX+nnLooYk54oEJfSfhmQIgDGLvVA1U2/h9G3FEykHxv32fNdD3CKwcPpQoqoFu5EsUMhuoQWz4dKHbhXbaW42KpwTMtf4Xtw=
Received: from MW4PR04CA0062.namprd04.prod.outlook.com (2603:10b6:303:6b::7)
 by MW4PR12MB7465.namprd12.prod.outlook.com (2603:10b6:303:212::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 17:04:58 +0000
Received: from CO1NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:6b:cafe::3c) by MW4PR04CA0062.outlook.office365.com
 (2603:10b6:303:6b::7) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 17:04:58 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT074.mail.protection.outlook.com (10.13.174.254) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.21 via Frontend Transport; Wed, 19 Apr 2023 17:04:58 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:04:56 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 01/14] pds_core: initial framework for pds_core PF driver
Date:   Wed, 19 Apr 2023 10:04:14 -0700
Message-ID: <20230419170427.1108-2-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230419170427.1108-1-shannon.nelson@amd.com>
References: <20230419170427.1108-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT074:EE_|MW4PR12MB7465:EE_
X-MS-Office365-Filtering-Correlation-Id: 46076d48-0f43-4056-f406-08db40f834c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VSN0htI1bFclrxUVMW85HWXkvwu69vYzH5XG2MDhQb1pXQlJ83Ox4OiTvTl574QddYYRbdzT5b7/QAWwKmbN2VQm5ATRmt/zpv3J4Y04jNIv/L5bjrcUHYQcmrq5yUVFrC2X+pDo1vPk7XiHJgEBHz78YXq6dR/Yn8lxSRL+FvQOu9GEVPLxaX2e4VE0QJc7VeOchamS5x/ZxOn+NTiwTpExVZEBpRuoC8FvvUOFKQGcSSCHtg9Ikn3QscZkSHXnzaVS0JDN04dDuuLfWHWOQ0uYp3R+Rti+GosolrhcdE9vgfsWVVtcHdbv6xd9um1Wkuyqg5vnxCF/59/jCe7ZDAM9X+WhipPIXeTtPU8xkKu0IyUVLgeyYVndfqKjPgwjS2pLRmqwY+qqbApk6j5FgfUSdTf92SJic/i+m4XCZLqHQqUya6F6/P9U+jpxRIQ+uECAQLio7MrJ70VCoFQvrC0IkMc+0LRlyX1UOSoPVFc5x0j6Fta6sY1ntfnlzfsglq2QcU8orAmsME+fMmnOa/ckoeVjdlTrtwYBAbWBEelEX02MNfRkVpgjYooSXcSDK7EUoZQ2lUkrBcdB4ZUhnDiw/cB8+yDbUaGVbmzhI62ttTt//mqrJaqr9ePB2jxhFsOV1o0LWe0mw2RLGn0E8aYuWJ1D0gKaUGEcRhWnBkhBZMCsFwQ+UmPlldGdROFNdbDCKTNDKUcmxYd50nZgaLSB/CFTl5DZYftgJ+sVHxnoli6H5Lf42W+U72llgilwrV/sDNs7ksDDnXN4BPJenA==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(346002)(136003)(39860400002)(396003)(451199021)(36840700001)(40470700004)(46966006)(36860700001)(316002)(110136005)(2616005)(54906003)(26005)(1076003)(478600001)(70586007)(70206006)(82740400003)(47076005)(83380400001)(43170500006)(6666004)(186003)(16526019)(336012)(426003)(4326008)(30864003)(8676002)(41300700001)(2906002)(8936002)(356005)(5660300002)(81166007)(36756003)(44832011)(82310400005)(40460700003)(40480700001)(86362001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:04:58.3106
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 46076d48-0f43-4056-f406-08db40f834c5
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7465
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

This is the initial PCI driver framework for the new pds_core device
driver and its family of devices.  This does the very basics of
registering for the new PF PCI device 1dd8:100c, setting up debugfs
entries, and registering with devlink.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 .../device_drivers/ethernet/amd/pds_core.rst  |  35 ++
 .../device_drivers/ethernet/index.rst         |   1 +
 drivers/net/ethernet/amd/pds_core/Makefile    |   8 +
 drivers/net/ethernet/amd/pds_core/core.h      |  56 ++
 drivers/net/ethernet/amd/pds_core/debugfs.c   |  31 +
 drivers/net/ethernet/amd/pds_core/main.c      | 277 +++++++++
 include/linux/pds/pds_common.h                |  14 +
 include/linux/pds/pds_core_if.h               | 571 ++++++++++++++++++
 8 files changed, 993 insertions(+)
 create mode 100644 Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
 create mode 100644 drivers/net/ethernet/amd/pds_core/Makefile
 create mode 100644 drivers/net/ethernet/amd/pds_core/core.h
 create mode 100644 drivers/net/ethernet/amd/pds_core/debugfs.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/main.c
 create mode 100644 include/linux/pds/pds_common.h
 create mode 100644 include/linux/pds/pds_core_if.h

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
new file mode 100644
index 000000000000..99a70026f1bc
--- /dev/null
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
@@ -0,0 +1,35 @@
+.. SPDX-License-Identifier: GPL-2.0+
+
+========================================================
+Linux Driver for the AMD/Pensando(R) DSC adapter family
+========================================================
+
+Copyright(c) 2023 Advanced Micro Devices, Inc
+
+Identifying the Adapter
+=======================
+
+To find if one or more AMD/Pensando PCI Core devices are installed on the
+host, check for the PCI devices::
+
+  # lspci -d 1dd8:100c
+  b5:00.0 Processing accelerators: Pensando Systems Device 100c
+  b6:00.0 Processing accelerators: Pensando Systems Device 100c
+
+If such devices are listed as above, then the pds_core.ko driver should find
+and configure them for use.  There should be log entries in the kernel
+messages such as these::
+
+  $ dmesg | grep pds_core
+  pds_core 0000:b5:00.0: 252.048 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x16 link)
+  pds_core 0000:b5:00.0: FW: 1.60.0-73
+  pds_core 0000:b6:00.0: 252.048 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x16 link)
+  pds_core 0000:b6:00.0: FW: 1.60.0-73
+
+Support
+=======
+
+For general Linux networking support, please use the netdev mailing
+list, which is monitored by AMD/Pensando personnel::
+
+  netdev@vger.kernel.org
diff --git a/Documentation/networking/device_drivers/ethernet/index.rst b/Documentation/networking/device_drivers/ethernet/index.rst
index 6e9e7012d000..417ca514a4d0 100644
--- a/Documentation/networking/device_drivers/ethernet/index.rst
+++ b/Documentation/networking/device_drivers/ethernet/index.rst
@@ -14,6 +14,7 @@ Contents:
    3com/vortex
    amazon/ena
    altera/altera_tse
+   amd/pds_core
    aquantia/atlantic
    chelsio/cxgb
    cirrus/cs89x0
diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
new file mode 100644
index 000000000000..de3bf1d1886c
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -0,0 +1,8 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 Advanced Micro Devices, Inc.
+
+obj-$(CONFIG_PDS_CORE) := pds_core.o
+
+pds_core-y := main.o
+
+pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
new file mode 100644
index 000000000000..34ef837e8cfe
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -0,0 +1,56 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDSC_H_
+#define _PDSC_H_
+
+#include <linux/debugfs.h>
+#include <net/devlink.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+
+#define PDSC_DRV_DESCRIPTION	"AMD/Pensando Core Driver"
+
+struct pdsc_dev_bar {
+	void __iomem *vaddr;
+	phys_addr_t bus_addr;
+	unsigned long len;
+	int res_index;
+};
+
+/* No state flags set means we are in a steady running state */
+enum pdsc_state_flags {
+	PDSC_S_FW_DEAD,		    /* stopped, wait on startup or recovery */
+	PDSC_S_INITING_DRIVER,	    /* initial startup from probe */
+	PDSC_S_STOPPING_DRIVER,	    /* driver remove */
+
+	/* leave this as last */
+	PDSC_S_STATE_SIZE
+};
+
+struct pdsc {
+	struct pci_dev *pdev;
+	struct dentry *dentry;
+	struct device *dev;
+	struct pdsc_dev_bar bars[PDS_CORE_BARS_MAX];
+	int hw_index;
+	int uid;
+
+	unsigned long state;
+
+	struct pds_core_dev_info_regs __iomem *info_regs;
+	struct pds_core_dev_cmd_regs __iomem *cmd_regs;
+	struct pds_core_intr __iomem *intr_ctrl;
+	u64 __iomem *intr_status;
+	u64 __iomem *db_pages;
+	dma_addr_t phy_db_pages;
+	u64 __iomem *kern_dbpage;
+};
+
+void pdsc_debugfs_create(void);
+void pdsc_debugfs_destroy(void);
+void pdsc_debugfs_add_dev(struct pdsc *pdsc);
+void pdsc_debugfs_del_dev(struct pdsc *pdsc);
+
+#endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
new file mode 100644
index 000000000000..b2f7cb795c20
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -0,0 +1,31 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/pci.h>
+
+#include "core.h"
+
+static struct dentry *pdsc_dir;
+
+void pdsc_debugfs_create(void)
+{
+	pdsc_dir = debugfs_create_dir(PDS_CORE_DRV_NAME, NULL);
+}
+
+void pdsc_debugfs_destroy(void)
+{
+	debugfs_remove_recursive(pdsc_dir);
+}
+
+void pdsc_debugfs_add_dev(struct pdsc *pdsc)
+{
+	pdsc->dentry = debugfs_create_dir(pci_name(pdsc->pdev), pdsc_dir);
+
+	debugfs_create_ulong("state", 0400, pdsc->dentry, &pdsc->state);
+}
+
+void pdsc_debugfs_del_dev(struct pdsc *pdsc)
+{
+	debugfs_remove_recursive(pdsc->dentry);
+	pdsc->dentry = NULL;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
new file mode 100644
index 000000000000..c2b12f226959
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -0,0 +1,277 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/pci.h>
+
+#include <linux/pds/pds_common.h>
+
+#include "core.h"
+
+MODULE_DESCRIPTION(PDSC_DRV_DESCRIPTION);
+MODULE_AUTHOR("Advanced Micro Devices, Inc");
+MODULE_LICENSE("GPL");
+
+/* Supported devices */
+static const struct pci_device_id pdsc_id_table[] = {
+	{ PCI_VDEVICE(PENSANDO, PCI_DEVICE_ID_PENSANDO_CORE_PF) },
+	{ 0, }	/* end of table */
+};
+MODULE_DEVICE_TABLE(pci, pdsc_id_table);
+
+static void pdsc_unmap_bars(struct pdsc *pdsc)
+{
+	struct pdsc_dev_bar *bars = pdsc->bars;
+	unsigned int i;
+
+	for (i = 0; i < PDS_CORE_BARS_MAX; i++) {
+		if (bars[i].vaddr)
+			pci_iounmap(pdsc->pdev, bars[i].vaddr);
+	}
+}
+
+static int pdsc_map_bars(struct pdsc *pdsc)
+{
+	struct pdsc_dev_bar *bar = pdsc->bars;
+	struct pci_dev *pdev = pdsc->pdev;
+	struct device *dev = pdsc->dev;
+	struct pdsc_dev_bar *bars;
+	unsigned int i, j;
+	int num_bars = 0;
+	int err;
+	u32 sig;
+
+	bars = pdsc->bars;
+
+	/* Since the PCI interface in the hardware is configurable,
+	 * we need to poke into all the bars to find the set we're
+	 * expecting.
+	 */
+	for (i = 0, j = 0; i < PDS_CORE_BARS_MAX; i++) {
+		if (!(pci_resource_flags(pdev, i) & IORESOURCE_MEM))
+			continue;
+
+		bars[j].len = pci_resource_len(pdev, i);
+		bars[j].bus_addr = pci_resource_start(pdev, i);
+		bars[j].res_index = i;
+
+		/* only map the whole bar 0 */
+		if (j > 0) {
+			bars[j].vaddr = NULL;
+		} else {
+			bars[j].vaddr = pci_iomap(pdev, i, bars[j].len);
+			if (!bars[j].vaddr) {
+				dev_err(dev, "Cannot map BAR %d, aborting\n", i);
+				return -ENODEV;
+			}
+		}
+
+		j++;
+	}
+	num_bars = j;
+
+	/* BAR0: dev_cmd and interrupts */
+	if (num_bars < 1) {
+		dev_err(dev, "No bars found\n");
+		err = -EFAULT;
+		goto err_out;
+	}
+
+	if (bar->len < PDS_CORE_BAR0_SIZE) {
+		dev_err(dev, "Resource bar size %lu too small\n", bar->len);
+		err = -EFAULT;
+		goto err_out;
+	}
+
+	pdsc->info_regs = bar->vaddr + PDS_CORE_BAR0_DEV_INFO_REGS_OFFSET;
+	pdsc->cmd_regs = bar->vaddr + PDS_CORE_BAR0_DEV_CMD_REGS_OFFSET;
+	pdsc->intr_status = bar->vaddr + PDS_CORE_BAR0_INTR_STATUS_OFFSET;
+	pdsc->intr_ctrl = bar->vaddr + PDS_CORE_BAR0_INTR_CTRL_OFFSET;
+
+	sig = ioread32(&pdsc->info_regs->signature);
+	if (sig != PDS_CORE_DEV_INFO_SIGNATURE) {
+		dev_err(dev, "Incompatible firmware signature %x", sig);
+		err = -EFAULT;
+		goto err_out;
+	}
+
+	/* BAR1: doorbells */
+	bar++;
+	if (num_bars < 2) {
+		dev_err(dev, "Doorbell bar missing\n");
+		err = -EFAULT;
+		goto err_out;
+	}
+
+	pdsc->db_pages = bar->vaddr;
+	pdsc->phy_db_pages = bar->bus_addr;
+
+	return 0;
+
+err_out:
+	pdsc_unmap_bars(pdsc);
+	return err;
+}
+
+static int pdsc_init_vf(struct pdsc *vf)
+{
+	return -1;
+}
+
+static int pdsc_init_pf(struct pdsc *pdsc)
+{
+	struct devlink *dl;
+	int err;
+
+	pcie_print_link_status(pdsc->pdev);
+
+	err = pci_request_regions(pdsc->pdev, PDS_CORE_DRV_NAME);
+	if (err) {
+		dev_err(pdsc->dev, "Cannot request PCI regions: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	err = pdsc_map_bars(pdsc);
+	if (err)
+		goto err_out_release_regions;
+
+	dl = priv_to_devlink(pdsc);
+	devl_lock(dl);
+	devl_register(dl);
+	devl_unlock(dl);
+
+	return 0;
+
+err_out_release_regions:
+	pci_release_regions(pdsc->pdev);
+
+	return err;
+}
+
+static const struct devlink_ops pdsc_dl_ops = {
+};
+
+static const struct devlink_ops pdsc_dl_vf_ops = {
+};
+
+static DEFINE_IDA(pdsc_ida);
+
+static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
+{
+	struct device *dev = &pdev->dev;
+	const struct devlink_ops *ops;
+	struct devlink *dl;
+	struct pdsc *pdsc;
+	bool is_pf;
+	int err;
+
+	is_pf = !pdev->is_virtfn;
+	ops = is_pf ? &pdsc_dl_ops : &pdsc_dl_vf_ops;
+	dl = devlink_alloc(ops, sizeof(struct pdsc), dev);
+	if (!dl)
+		return -ENOMEM;
+	pdsc = devlink_priv(dl);
+
+	pdsc->pdev = pdev;
+	pdsc->dev = &pdev->dev;
+	set_bit(PDSC_S_INITING_DRIVER, &pdsc->state);
+	pci_set_drvdata(pdev, pdsc);
+	pdsc_debugfs_add_dev(pdsc);
+
+	err = ida_alloc(&pdsc_ida, GFP_KERNEL);
+	if (err < 0) {
+		dev_err(pdsc->dev, "%s: id alloc failed: %pe\n",
+			__func__, ERR_PTR(err));
+		goto err_out_free_devlink;
+	}
+	pdsc->uid = err;
+
+	/* Query system for DMA addressing limitation for the device. */
+	err = dma_set_mask_and_coherent(dev, DMA_BIT_MASK(PDS_CORE_ADDR_LEN));
+	if (err) {
+		dev_err(dev, "Unable to obtain 64-bit DMA for consistent allocations, aborting: %pe\n",
+			ERR_PTR(err));
+		goto err_out_free_ida;
+	}
+
+	err = pci_enable_device(pdev);
+	if (err) {
+		dev_err(dev, "Cannot enable PCI device: %pe\n", ERR_PTR(err));
+		goto err_out_free_ida;
+	}
+	pci_set_master(pdev);
+
+	if (is_pf)
+		err = pdsc_init_pf(pdsc);
+	else
+		err = pdsc_init_vf(pdsc);
+	if (err) {
+		dev_err(dev, "Cannot init device: %pe\n", ERR_PTR(err));
+		goto err_out_clear_master;
+	}
+
+	clear_bit(PDSC_S_INITING_DRIVER, &pdsc->state);
+	return 0;
+
+err_out_clear_master:
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+err_out_free_ida:
+	ida_free(&pdsc_ida, pdsc->uid);
+err_out_free_devlink:
+	pdsc_debugfs_del_dev(pdsc);
+	devlink_free(dl);
+
+	return err;
+}
+
+static void pdsc_remove(struct pci_dev *pdev)
+{
+	struct pdsc *pdsc = pci_get_drvdata(pdev);
+	struct devlink *dl;
+
+	/* Unhook the registrations first to be sure there
+	 * are no requests while we're stopping.
+	 */
+	dl = priv_to_devlink(pdsc);
+	devl_lock(dl);
+	devl_unregister(dl);
+	devl_unlock(dl);
+
+	pdsc_unmap_bars(pdsc);
+	pci_release_regions(pdev);
+
+	pci_clear_master(pdev);
+	pci_disable_device(pdev);
+
+	ida_free(&pdsc_ida, pdsc->uid);
+	pdsc_debugfs_del_dev(pdsc);
+	devlink_free(dl);
+}
+
+static struct pci_driver pdsc_driver = {
+	.name = PDS_CORE_DRV_NAME,
+	.id_table = pdsc_id_table,
+	.probe = pdsc_probe,
+	.remove = pdsc_remove,
+};
+
+static int __init pdsc_init_module(void)
+{
+	if (strcmp(KBUILD_MODNAME, PDS_CORE_DRV_NAME))
+		return -EINVAL;
+
+	pdsc_debugfs_create();
+	return pci_register_driver(&pdsc_driver);
+}
+
+static void __exit pdsc_cleanup_module(void)
+{
+	pci_unregister_driver(&pdsc_driver);
+	pdsc_debugfs_destroy();
+}
+
+module_init(pdsc_init_module);
+module_exit(pdsc_cleanup_module);
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
new file mode 100644
index 000000000000..bd041a5170a6
--- /dev/null
+++ b/include/linux/pds/pds_common.h
@@ -0,0 +1,14 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _PDS_COMMON_H_
+#define _PDS_COMMON_H_
+
+#define PDS_CORE_DRV_NAME			"pds_core"
+
+/* the device's internal addressing uses up to 52 bits */
+#define PDS_CORE_ADDR_LEN	52
+#define PDS_CORE_ADDR_MASK	(BIT_ULL(PDS_ADDR_LEN) - 1)
+#define PDS_PAGE_SIZE		4096
+
+#endif /* _PDS_COMMON_H_ */
diff --git a/include/linux/pds/pds_core_if.h b/include/linux/pds/pds_core_if.h
new file mode 100644
index 000000000000..e838a2b90440
--- /dev/null
+++ b/include/linux/pds/pds_core_if.h
@@ -0,0 +1,571 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _PDS_CORE_IF_H_
+#define _PDS_CORE_IF_H_
+
+#define PCI_VENDOR_ID_PENSANDO			0x1dd8
+#define PCI_DEVICE_ID_PENSANDO_CORE_PF		0x100c
+#define PCI_DEVICE_ID_VIRTIO_NET_TRANS		0x1000
+#define PCI_DEVICE_ID_PENSANDO_IONIC_ETH_VF	0x1003
+#define PCI_DEVICE_ID_PENSANDO_VDPA_VF		0x100b
+#define PDS_CORE_BARS_MAX			4
+#define PDS_CORE_PCI_BAR_DBELL			1
+
+/* Bar0 */
+#define PDS_CORE_DEV_INFO_SIGNATURE		0x44455649 /* 'DEVI' */
+#define PDS_CORE_BAR0_SIZE			0x8000
+#define PDS_CORE_BAR0_DEV_INFO_REGS_OFFSET	0x0000
+#define PDS_CORE_BAR0_DEV_CMD_REGS_OFFSET	0x0800
+#define PDS_CORE_BAR0_DEV_CMD_DATA_REGS_OFFSET	0x0c00
+#define PDS_CORE_BAR0_INTR_STATUS_OFFSET	0x1000
+#define PDS_CORE_BAR0_INTR_CTRL_OFFSET		0x2000
+#define PDS_CORE_DEV_CMD_DONE			0x00000001
+
+#define PDS_CORE_DEVCMD_TIMEOUT			5
+
+#define PDS_CORE_CLIENT_ID			0
+#define PDS_CORE_ASIC_TYPE_CAPRI		0
+
+/*
+ * enum pds_core_cmd_opcode - Device commands
+ */
+enum pds_core_cmd_opcode {
+	/* Core init */
+	PDS_CORE_CMD_NOP		= 0,
+	PDS_CORE_CMD_IDENTIFY		= 1,
+	PDS_CORE_CMD_RESET		= 2,
+	PDS_CORE_CMD_INIT		= 3,
+
+	PDS_CORE_CMD_FW_DOWNLOAD	= 4,
+	PDS_CORE_CMD_FW_CONTROL		= 5,
+
+	/* SR/IOV commands */
+	PDS_CORE_CMD_VF_GETATTR		= 60,
+	PDS_CORE_CMD_VF_SETATTR		= 61,
+	PDS_CORE_CMD_VF_CTRL		= 62,
+
+	/* Add commands before this line */
+	PDS_CORE_CMD_MAX,
+	PDS_CORE_CMD_COUNT
+};
+
+/*
+ * enum pds_core_status_code - Device command return codes
+ */
+enum pds_core_status_code {
+	PDS_RC_SUCCESS	= 0,	/* Success */
+	PDS_RC_EVERSION	= 1,	/* Incorrect version for request */
+	PDS_RC_EOPCODE	= 2,	/* Invalid cmd opcode */
+	PDS_RC_EIO	= 3,	/* I/O error */
+	PDS_RC_EPERM	= 4,	/* Permission denied */
+	PDS_RC_EQID	= 5,	/* Bad qid */
+	PDS_RC_EQTYPE	= 6,	/* Bad qtype */
+	PDS_RC_ENOENT	= 7,	/* No such element */
+	PDS_RC_EINTR	= 8,	/* operation interrupted */
+	PDS_RC_EAGAIN	= 9,	/* Try again */
+	PDS_RC_ENOMEM	= 10,	/* Out of memory */
+	PDS_RC_EFAULT	= 11,	/* Bad address */
+	PDS_RC_EBUSY	= 12,	/* Device or resource busy */
+	PDS_RC_EEXIST	= 13,	/* object already exists */
+	PDS_RC_EINVAL	= 14,	/* Invalid argument */
+	PDS_RC_ENOSPC	= 15,	/* No space left or alloc failure */
+	PDS_RC_ERANGE	= 16,	/* Parameter out of range */
+	PDS_RC_BAD_ADDR	= 17,	/* Descriptor contains a bad ptr */
+	PDS_RC_DEV_CMD	= 18,	/* Device cmd attempted on AdminQ */
+	PDS_RC_ENOSUPP	= 19,	/* Operation not supported */
+	PDS_RC_ERROR	= 29,	/* Generic error */
+	PDS_RC_ERDMA	= 30,	/* Generic RDMA error */
+	PDS_RC_EVFID	= 31,	/* VF ID does not exist */
+	PDS_RC_BAD_FW	= 32,	/* FW file is invalid or corrupted */
+	PDS_RC_ECLIENT	= 33,   /* No such client id */
+};
+
+/**
+ * struct pds_core_drv_identity - Driver identity information
+ * @drv_type:         Driver type (enum pds_core_driver_type)
+ * @os_dist:          OS distribution, numeric format
+ * @os_dist_str:      OS distribution, string format
+ * @kernel_ver:       Kernel version, numeric format
+ * @kernel_ver_str:   Kernel version, string format
+ * @driver_ver_str:   Driver version, string format
+ */
+struct pds_core_drv_identity {
+	__le32 drv_type;
+	__le32 os_dist;
+	char   os_dist_str[128];
+	__le32 kernel_ver;
+	char   kernel_ver_str[32];
+	char   driver_ver_str[32];
+};
+
+#define PDS_DEV_TYPE_MAX	16
+/**
+ * struct pds_core_dev_identity - Device identity information
+ * @version:	      Version of device identify
+ * @type:	      Identify type (0 for now)
+ * @state:	      Device state
+ * @rsvd:	      Word boundary padding
+ * @nlifs:	      Number of LIFs provisioned
+ * @nintrs:	      Number of interrupts provisioned
+ * @ndbpgs_per_lif:   Number of doorbell pages per LIF
+ * @intr_coal_mult:   Interrupt coalescing multiplication factor
+ *		      Scale user-supplied interrupt coalescing
+ *		      value in usecs to device units using:
+ *		      device units = usecs * mult / div
+ * @intr_coal_div:    Interrupt coalescing division factor
+ *		      Scale user-supplied interrupt coalescing
+ *		      value in usecs to device units using:
+ *		      device units = usecs * mult / div
+ * @vif_types:        How many of each VIF device type is supported
+ */
+struct pds_core_dev_identity {
+	u8     version;
+	u8     type;
+	u8     state;
+	u8     rsvd;
+	__le32 nlifs;
+	__le32 nintrs;
+	__le32 ndbpgs_per_lif;
+	__le32 intr_coal_mult;
+	__le32 intr_coal_div;
+	__le16 vif_types[PDS_DEV_TYPE_MAX];
+};
+
+#define PDS_CORE_IDENTITY_VERSION_1	1
+
+/**
+ * struct pds_core_dev_identify_cmd - Driver/device identify command
+ * @opcode:	Opcode PDS_CORE_CMD_IDENTIFY
+ * @ver:	Highest version of identify supported by driver
+ *
+ * Expects to find driver identification info (struct pds_core_drv_identity)
+ * in cmd_regs->data.  Driver should keep the devcmd interface locked
+ * while preparing the driver info.
+ */
+struct pds_core_dev_identify_cmd {
+	u8 opcode;
+	u8 ver;
+};
+
+/**
+ * struct pds_core_dev_identify_comp - Device identify command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @ver:	Version of identify returned by device
+ *
+ * Device identification info (struct pds_core_dev_identity) can be found
+ * in cmd_regs->data.  Driver should keep the devcmd interface locked
+ * while reading the results.
+ */
+struct pds_core_dev_identify_comp {
+	u8 status;
+	u8 ver;
+};
+
+/**
+ * struct pds_core_dev_reset_cmd - Device reset command
+ * @opcode:	Opcode PDS_CORE_CMD_RESET
+ *
+ * Resets and clears all LIFs, VDevs, and VIFs on the device.
+ */
+struct pds_core_dev_reset_cmd {
+	u8 opcode;
+};
+
+/**
+ * struct pds_core_dev_reset_comp - Reset command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ */
+struct pds_core_dev_reset_comp {
+	u8 status;
+};
+
+/*
+ * struct pds_core_dev_init_data - Pointers and info needed for the Core
+ * initialization PDS_CORE_CMD_INIT command.  The in and out structs are
+ * overlays on the pds_core_dev_cmd_regs.data space for passing data down
+ * to the firmware on init, and then returning initialization results.
+ */
+struct pds_core_dev_init_data_in {
+	__le64 adminq_q_base;
+	__le64 adminq_cq_base;
+	__le64 notifyq_cq_base;
+	__le32 flags;
+	__le16 intr_index;
+	u8     adminq_ring_size;
+	u8     notifyq_ring_size;
+};
+
+struct pds_core_dev_init_data_out {
+	__le32 core_hw_index;
+	__le32 adminq_hw_index;
+	__le32 notifyq_hw_index;
+	u8     adminq_hw_type;
+	u8     notifyq_hw_type;
+};
+
+/**
+ * struct pds_core_dev_init_cmd - Core device initialize
+ * @opcode:          opcode PDS_CORE_CMD_INIT
+ *
+ * Initializes the core device and sets up the AdminQ and NotifyQ.
+ * Expects to find initialization data (struct pds_core_dev_init_data_in)
+ * in cmd_regs->data.  Driver should keep the devcmd interface locked
+ * while preparing the driver info.
+ */
+struct pds_core_dev_init_cmd {
+	u8     opcode;
+};
+
+/**
+ * struct pds_core_dev_init_comp - Core init completion
+ * @status:     Status of the command (enum pds_core_status_code)
+ *
+ * Initialization result data (struct pds_core_dev_init_data_in)
+ * is found in cmd_regs->data.
+ */
+struct pds_core_dev_init_comp {
+	u8     status;
+};
+
+/**
+ * struct pds_core_fw_download_cmd - Firmware download command
+ * @opcode:     opcode
+ * @rsvd:	Word boundary padding
+ * @addr:       DMA address of the firmware buffer
+ * @offset:     offset of the firmware buffer within the full image
+ * @length:     number of valid bytes in the firmware buffer
+ */
+struct pds_core_fw_download_cmd {
+	u8     opcode;
+	u8     rsvd[3];
+	__le32 offset;
+	__le64 addr;
+	__le32 length;
+};
+
+/**
+ * struct pds_core_fw_download_comp - Firmware download completion
+ * @status:     Status of the command (enum pds_core_status_code)
+ */
+struct pds_core_fw_download_comp {
+	u8     status;
+};
+
+/**
+ * enum pds_core_fw_control_oper - FW control operations
+ * @PDS_CORE_FW_INSTALL_ASYNC:     Install firmware asynchronously
+ * @PDS_CORE_FW_INSTALL_STATUS:    Firmware installation status
+ * @PDS_CORE_FW_ACTIVATE_ASYNC:    Activate firmware asynchronously
+ * @PDS_CORE_FW_ACTIVATE_STATUS:   Firmware activate status
+ * @PDS_CORE_FW_UPDATE_CLEANUP:    Cleanup any firmware update leftovers
+ * @PDS_CORE_FW_GET_BOOT:          Return current active firmware slot
+ * @PDS_CORE_FW_SET_BOOT:          Set active firmware slot for next boot
+ * @PDS_CORE_FW_GET_LIST:          Return list of installed firmware images
+ */
+enum pds_core_fw_control_oper {
+	PDS_CORE_FW_INSTALL_ASYNC          = 0,
+	PDS_CORE_FW_INSTALL_STATUS         = 1,
+	PDS_CORE_FW_ACTIVATE_ASYNC         = 2,
+	PDS_CORE_FW_ACTIVATE_STATUS        = 3,
+	PDS_CORE_FW_UPDATE_CLEANUP         = 4,
+	PDS_CORE_FW_GET_BOOT               = 5,
+	PDS_CORE_FW_SET_BOOT               = 6,
+	PDS_CORE_FW_GET_LIST               = 7,
+};
+
+enum pds_core_fw_slot {
+	PDS_CORE_FW_SLOT_INVALID    = 0,
+	PDS_CORE_FW_SLOT_A	    = 1,
+	PDS_CORE_FW_SLOT_B          = 2,
+	PDS_CORE_FW_SLOT_GOLD       = 3,
+};
+
+/**
+ * struct pds_core_fw_control_cmd - Firmware control command
+ * @opcode:    opcode
+ * @rsvd:      Word boundary padding
+ * @oper:      firmware control operation (enum pds_core_fw_control_oper)
+ * @slot:      slot to operate on (enum pds_core_fw_slot)
+ */
+struct pds_core_fw_control_cmd {
+	u8  opcode;
+	u8  rsvd[3];
+	u8  oper;
+	u8  slot;
+};
+
+/**
+ * struct pds_core_fw_control_comp - Firmware control copletion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd:	Word alignment space
+ * @slot:	Slot number (enum pds_core_fw_slot)
+ * @rsvd1:	Struct padding
+ * @color:	Color bit
+ */
+struct pds_core_fw_control_comp {
+	u8     status;
+	u8     rsvd[3];
+	u8     slot;
+	u8     rsvd1[10];
+	u8     color;
+};
+
+struct pds_core_fw_name_info {
+#define PDS_CORE_FWSLOT_BUFLEN		8
+#define PDS_CORE_FWVERS_BUFLEN		32
+	char   slotname[PDS_CORE_FWSLOT_BUFLEN];
+	char   fw_version[PDS_CORE_FWVERS_BUFLEN];
+};
+
+struct pds_core_fw_list_info {
+#define PDS_CORE_FWVERS_LIST_LEN	16
+	u8 num_fw_slots;
+	struct pds_core_fw_name_info fw_names[PDS_CORE_FWVERS_LIST_LEN];
+} __packed;
+
+enum pds_core_vf_attr {
+	PDS_CORE_VF_ATTR_SPOOFCHK	= 1,
+	PDS_CORE_VF_ATTR_TRUST		= 2,
+	PDS_CORE_VF_ATTR_MAC		= 3,
+	PDS_CORE_VF_ATTR_LINKSTATE	= 4,
+	PDS_CORE_VF_ATTR_VLAN		= 5,
+	PDS_CORE_VF_ATTR_RATE		= 6,
+	PDS_CORE_VF_ATTR_STATSADDR	= 7,
+};
+
+/**
+ * enum pds_core_vf_link_status - Virtual Function link status
+ * @PDS_CORE_VF_LINK_STATUS_AUTO:   Use link state of the uplink
+ * @PDS_CORE_VF_LINK_STATUS_UP:     Link always up
+ * @PDS_CORE_VF_LINK_STATUS_DOWN:   Link always down
+ */
+enum pds_core_vf_link_status {
+	PDS_CORE_VF_LINK_STATUS_AUTO = 0,
+	PDS_CORE_VF_LINK_STATUS_UP   = 1,
+	PDS_CORE_VF_LINK_STATUS_DOWN = 2,
+};
+
+/**
+ * struct pds_core_vf_setattr_cmd - Set VF attributes on the NIC
+ * @opcode:     Opcode
+ * @attr:       Attribute type (enum pds_core_vf_attr)
+ * @vf_index:   VF index
+ * @macaddr:	mac address
+ * @vlanid:	vlan ID
+ * @maxrate:	max Tx rate in Mbps
+ * @spoofchk:	enable address spoof checking
+ * @trust:	enable VF trust
+ * @linkstate:	set link up or down
+ * @stats:	stats addr struct
+ * @stats.pa:	set DMA address for VF stats
+ * @stats.len:	length of VF stats space
+ * @pad:	force union to specific size
+ */
+struct pds_core_vf_setattr_cmd {
+	u8     opcode;
+	u8     attr;
+	__le16 vf_index;
+	union {
+		u8     macaddr[6];
+		__le16 vlanid;
+		__le32 maxrate;
+		u8     spoofchk;
+		u8     trust;
+		u8     linkstate;
+		struct {
+			__le64 pa;
+			__le32 len;
+		} stats;
+		u8     pad[60];
+	} __packed;
+};
+
+struct pds_core_vf_setattr_comp {
+	u8     status;
+	u8     attr;
+	__le16 vf_index;
+	__le16 comp_index;
+	u8     rsvd[9];
+	u8     color;
+};
+
+/**
+ * struct pds_core_vf_getattr_cmd - Get VF attributes from the NIC
+ * @opcode:     Opcode
+ * @attr:       Attribute type (enum pds_core_vf_attr)
+ * @vf_index:   VF index
+ */
+struct pds_core_vf_getattr_cmd {
+	u8     opcode;
+	u8     attr;
+	__le16 vf_index;
+};
+
+struct pds_core_vf_getattr_comp {
+	u8     status;
+	u8     attr;
+	__le16 vf_index;
+	union {
+		u8     macaddr[6];
+		__le16 vlanid;
+		__le32 maxrate;
+		u8     spoofchk;
+		u8     trust;
+		u8     linkstate;
+		__le64 stats_pa;
+		u8     pad[11];
+	} __packed;
+	u8     color;
+};
+
+enum pds_core_vf_ctrl_opcode {
+	PDS_CORE_VF_CTRL_START_ALL	= 0,
+	PDS_CORE_VF_CTRL_START		= 1,
+};
+
+/**
+ * struct pds_core_vf_ctrl_cmd - VF control command
+ * @opcode:         Opcode for the command
+ * @ctrl_opcode:    VF control operation type
+ * @vf_index:       VF Index. It is unused if op START_ALL is used.
+ */
+
+struct pds_core_vf_ctrl_cmd {
+	u8	opcode;
+	u8	ctrl_opcode;
+	__le16	vf_index;
+};
+
+/**
+ * struct pds_core_vf_ctrl_comp - VF_CTRL command completion.
+ * @status:     Status of the command (enum pds_core_status_code)
+ */
+struct pds_core_vf_ctrl_comp {
+	u8	status;
+};
+
+/*
+ * union pds_core_dev_cmd - Overlay of core device command structures
+ */
+union pds_core_dev_cmd {
+	u8     opcode;
+	u32    words[16];
+
+	struct pds_core_dev_identify_cmd identify;
+	struct pds_core_dev_init_cmd     init;
+	struct pds_core_dev_reset_cmd    reset;
+	struct pds_core_fw_download_cmd  fw_download;
+	struct pds_core_fw_control_cmd   fw_control;
+
+	struct pds_core_vf_setattr_cmd   vf_setattr;
+	struct pds_core_vf_getattr_cmd   vf_getattr;
+	struct pds_core_vf_ctrl_cmd      vf_ctrl;
+};
+
+/*
+ * union pds_core_dev_comp - Overlay of core device completion structures
+ */
+union pds_core_dev_comp {
+	u8                                status;
+	u8                                bytes[16];
+
+	struct pds_core_dev_identify_comp identify;
+	struct pds_core_dev_reset_comp    reset;
+	struct pds_core_dev_init_comp     init;
+	struct pds_core_fw_download_comp  fw_download;
+	struct pds_core_fw_control_comp   fw_control;
+
+	struct pds_core_vf_setattr_comp   vf_setattr;
+	struct pds_core_vf_getattr_comp   vf_getattr;
+	struct pds_core_vf_ctrl_comp      vf_ctrl;
+};
+
+/**
+ * struct pds_core_dev_hwstamp_regs - Hardware current timestamp registers
+ * @tick_low:        Low 32 bits of hardware timestamp
+ * @tick_high:       High 32 bits of hardware timestamp
+ */
+struct pds_core_dev_hwstamp_regs {
+	u32    tick_low;
+	u32    tick_high;
+};
+
+/**
+ * struct pds_core_dev_info_regs - Device info register format (read-only)
+ * @signature:       Signature value of 0x44455649 ('DEVI')
+ * @version:         Current version of info
+ * @asic_type:       Asic type
+ * @asic_rev:        Asic revision
+ * @fw_status:       Firmware status
+ *			bit 0   - 1 = fw running
+ *			bit 4-7 - 4 bit generation number, changes on fw restart
+ * @fw_heartbeat:    Firmware heartbeat counter
+ * @serial_num:      Serial number
+ * @fw_version:      Firmware version
+ * @oprom_regs:      oprom_regs to store oprom debug enable/disable and bmp
+ * @rsvd_pad1024:    Struct padding
+ * @hwstamp:         Hardware current timestamp registers
+ * @rsvd_pad2048:    Struct padding
+ */
+struct pds_core_dev_info_regs {
+#define PDS_CORE_DEVINFO_FWVERS_BUFLEN 32
+#define PDS_CORE_DEVINFO_SERIAL_BUFLEN 32
+	u32    signature;
+	u8     version;
+	u8     asic_type;
+	u8     asic_rev;
+#define PDS_CORE_FW_STS_F_STOPPED	0x00
+#define PDS_CORE_FW_STS_F_RUNNING	0x01
+#define PDS_CORE_FW_STS_F_GENERATION	0xF0
+	u8     fw_status;
+	__le32 fw_heartbeat;
+	char   fw_version[PDS_CORE_DEVINFO_FWVERS_BUFLEN];
+	char   serial_num[PDS_CORE_DEVINFO_SERIAL_BUFLEN];
+	u8     oprom_regs[32];     /* reserved */
+	u8     rsvd_pad1024[916];
+	struct pds_core_dev_hwstamp_regs hwstamp;   /* on 1k boundary */
+	u8     rsvd_pad2048[1016];
+} __packed;
+
+/**
+ * struct pds_core_dev_cmd_regs - Device command register format (read-write)
+ * @doorbell:	Device Cmd Doorbell, write-only
+ *              Write a 1 to signal device to process cmd
+ * @done:	Command completed indicator, poll for completion
+ *              bit 0 == 1 when command is complete
+ * @cmd:	Opcode-specific command bytes
+ * @comp:	Opcode-specific response bytes
+ * @rsvd:	Struct padding
+ * @data:	Opcode-specific side-data
+ */
+struct pds_core_dev_cmd_regs {
+	u32                     doorbell;
+	u32                     done;
+	union pds_core_dev_cmd  cmd;
+	union pds_core_dev_comp comp;
+	u8                      rsvd[48];
+	u32                     data[478];
+} __packed;
+
+/**
+ * struct pds_core_dev_regs - Device register format for bar 0 page 0
+ * @info:            Device info registers
+ * @devcmd:          Device command registers
+ */
+struct pds_core_dev_regs {
+	struct pds_core_dev_info_regs info;
+	struct pds_core_dev_cmd_regs  devcmd;
+} __packed;
+
+#ifndef __CHECKER__
+static_assert(sizeof(struct pds_core_drv_identity) <= 1912);
+static_assert(sizeof(struct pds_core_dev_identity) <= 1912);
+static_assert(sizeof(union pds_core_dev_cmd) == 64);
+static_assert(sizeof(union pds_core_dev_comp) == 16);
+static_assert(sizeof(struct pds_core_dev_info_regs) == 2048);
+static_assert(sizeof(struct pds_core_dev_cmd_regs) == 2048);
+static_assert(sizeof(struct pds_core_dev_regs) == 4096);
+#endif /* __CHECKER__ */
+
+#endif /* _PDS_CORE_IF_H_ */
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65E3264508E
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 01:45:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiLGAp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 19:45:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229790AbiLGApN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 19:45:13 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2042.outbound.protection.outlook.com [40.107.220.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A8D2AE3E
        for <netdev@vger.kernel.org>; Tue,  6 Dec 2022 16:45:10 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=klACIoC9Qfn1DjX7wH6yXw/3Tq/9VxFw594ELixLiWXn8hSuU6ymP7OoL9jgt5NszDXn9Hdzu+iXbRv8lM7F8rMUvbNSDOsNxCQzxM8R2DlRpcibJShqyNpq/qKJxARD7Mi9Y5SjAP8CJanr/Y0uF5oeuMbP10L0EorvMaRls539uhaCNdnj6pbFeNxeEjOoAutPGVYu+B8RLsr4UliS8TBnHpPhm+EVpO2QN68lg8OpuyMPUDQoMUlUgXZ/1cks+qKkg0eh1uf2KQ//pocC5j4kWAFOXhsczjNdJNqLwzaR9rxOiufOuKakcFvtsTwf9hl7ZMyAhRF3rJeVKCLzTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=H3GikLoi5QhjYyBpPiQGInfW5aoc0DDhPA2UjFnZaQE=;
 b=MdjY2j/NyAxDoN3KIQwqOGuFoyQDweyNOtO9U1/nNbgHLiFuV7kTJaIZeH+zLfuMJZfRRadhKAQJf+Kg5X7No+//M73IMvMLEDgDgY9LAoSdCNWhlQzL/0ixPdqW2oXCdUUiZ1j17Erqihdsp4jaEnQ+1a/B2Do1Ak9X5E/EV/KZcQzhgq02dkwNAudAUOzH9MpNaHx8sb0aG1OarkAdVXPAkHhH7YQq1qFgVHni3Jd6ZVij+26brtmWR+3P1MtbUEl+zQl6S4hqFyQya1zg+IUsEapkNGdFXAeSniKqumtwrZSy9A6DX8axrFmQwAVDX6S6n+2gtO1zyVPkDXLR3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=H3GikLoi5QhjYyBpPiQGInfW5aoc0DDhPA2UjFnZaQE=;
 b=f3nxct5mmR+wafjWFBOmTkx2t9JFrO2GffFAc2JmC6D1FI9dr6g4GNeCuxttu/hfzhfi0u/PSZDyYd2Tu/N908QGsdmnz7++HOOCJgrJl+IzW0Z5/kk7kDxWV3SBHFLlv3Eruc2ZPVmLVeY1WCU+Rztc5SHjRLT6ILJbDS+5S8s=
Received: from BN0PR03CA0018.namprd03.prod.outlook.com (2603:10b6:408:e6::23)
 by DM4PR12MB6352.namprd12.prod.outlook.com (2603:10b6:8:a0::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 7 Dec
 2022 00:45:08 +0000
Received: from BN8NAM11FT105.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:e6:cafe::1b) by BN0PR03CA0018.outlook.office365.com
 (2603:10b6:408:e6::23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14 via Frontend
 Transport; Wed, 7 Dec 2022 00:45:08 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT105.mail.protection.outlook.com (10.13.176.183) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.5901.14 via Frontend Transport; Wed, 7 Dec 2022 00:45:08 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 6 Dec
 2022 18:45:07 -0600
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <netdev@vger.kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, Shannon Nelson <shannon.nelson@amd.com>
Subject: [PATCH v2 net-next 04/16] pds_core: add devcmd device interfaces
Date:   Tue, 6 Dec 2022 16:44:31 -0800
Message-ID: <20221207004443.33779-5-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20221207004443.33779-1-shannon.nelson@amd.com>
References: <20221207004443.33779-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT105:EE_|DM4PR12MB6352:EE_
X-MS-Office365-Filtering-Correlation-Id: bf117fd8-1b6f-44e4-2dea-08dad7ec4a1e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OHfahXsNA+jMaog5omOpS8/idoRB9dPUr5KeZ69DgHFztvMTSEqOkTy5BI0OfS7nrnxMXF2ziAwf70JzZiXH2r923FWiSPQskU7nNayo7l3PTIyCdxKa+PPyYIMvuieKmAa2qntQzIOF2zUUVaCtIRQZFo0NSeREkuvjQE8I6X9e1S/cmWc6Gy74iupP4U4YkJhOkgZRvOh9jgMDRWa3Nj6gUciSTijibamFZabdCNZraP+s7p0DHWleARvazO8zjKOUlEBjoGb+xALWS6h3QulWOfWS6bE5DCO/IxSb1SATspMHqj+hTSeWnjKMw8ybHOv4bbRMIE9BPuEAHoUn3gK8kR+G1eSWOFBQpuVNGn/QCOBEzO9Yo48/X7tBmMz/VrI2U6RwS6FOmsSLE1GJaQj95a4R+cW4k4xhUbPkjl2ufcYcY0ZWi6SWKXFQPsor0/Js9m6IyNZiQ+NqI8YclZFIRlLz32rEj1KGQ+0UzxsHIME8SOKg+3w9pTGOoCuUpjAfDSLSWaLVgJkw2GccZVGehByCN+YG2q2jrRZaCUSiCd5/IZzDFYzP8dWD7d0+4D704+q8FTfrDNlbkrprdEqH+9mRx7gnxxPT04z9pnQXHaNIXpZuG4JH3RSgb+GUd/cQ+0ozb9SuTDwljTbcCc+YA2GRN9tJiN/FSJZ4/tocigszmSACTsbDdv6pfkOlzYOtULTyuhjZ3BgeZq7ap8oGfedwTHv4Z0Q1HSIS4N0=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(39860400002)(136003)(346002)(451199015)(40470700004)(46966006)(36840700001)(6666004)(82740400003)(81166007)(478600001)(82310400005)(356005)(8936002)(316002)(36860700001)(26005)(110136005)(36756003)(54906003)(86362001)(5660300002)(40460700003)(40480700001)(8676002)(70586007)(1076003)(70206006)(41300700001)(2616005)(83380400001)(44832011)(426003)(186003)(30864003)(47076005)(336012)(4326008)(16526019)(2906002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Dec 2022 00:45:08.1623
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: bf117fd8-1b6f-44e4-2dea-08dad7ec4a1e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT105.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6352
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The devcmd interface is the basic connection to the device through the
PCI BAR for low level identification and command services.  This does
the early device initialization and finds the identity data, and adds
devcmd routines to be used by later driver bits.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 .../net/ethernet/pensando/pds_core/Makefile   |   4 +-
 drivers/net/ethernet/pensando/pds_core/core.c |  43 +++
 drivers/net/ethernet/pensando/pds_core/core.h |  55 +++
 .../net/ethernet/pensando/pds_core/debugfs.c  |  67 ++++
 drivers/net/ethernet/pensando/pds_core/dev.c  | 355 ++++++++++++++++++
 drivers/net/ethernet/pensando/pds_core/main.c |  30 ++
 include/linux/pds/pds_common.h                |  67 ++++
 include/linux/pds/pds_intr.h                  | 160 ++++++++
 8 files changed, 780 insertions(+), 1 deletion(-)
 create mode 100644 drivers/net/ethernet/pensando/pds_core/core.c
 create mode 100644 drivers/net/ethernet/pensando/pds_core/dev.c
 create mode 100644 include/linux/pds/pds_intr.h

diff --git a/drivers/net/ethernet/pensando/pds_core/Makefile b/drivers/net/ethernet/pensando/pds_core/Makefile
index 72bbc5fa68ad..446054206b6a 100644
--- a/drivers/net/ethernet/pensando/pds_core/Makefile
+++ b/drivers/net/ethernet/pensando/pds_core/Makefile
@@ -4,6 +4,8 @@
 obj-$(CONFIG_PDS_CORE) := pds_core.o
 
 pds_core-y := main.o \
-	      devlink.o
+	      devlink.o \
+	      dev.o \
+	      core.o
 
 pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/pensando/pds_core/core.c b/drivers/net/ethernet/pensando/pds_core/core.c
new file mode 100644
index 000000000000..d846e8b93575
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/core.c
@@ -0,0 +1,43 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <net/devlink.h>
+
+#include "core.h"
+
+int pdsc_setup(struct pdsc *pdsc, bool init)
+{
+	int err = 0;
+
+	if (init)
+		err = pdsc_dev_init(pdsc);
+	else
+		err = pdsc_dev_reinit(pdsc);
+	if (err)
+		return err;
+
+	clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
+	return 0;
+}
+
+void pdsc_teardown(struct pdsc *pdsc, bool removing)
+{
+	pdsc_devcmd_reset(pdsc);
+
+	if (removing && pdsc->intr_info) {
+		devm_kfree(pdsc->dev, pdsc->intr_info);
+		pdsc->intr_info = NULL;
+	}
+
+	if (pdsc->kern_dbpage) {
+		iounmap(pdsc->kern_dbpage);
+		pdsc->kern_dbpage = NULL;
+	}
+
+	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
+}
diff --git a/drivers/net/ethernet/pensando/pds_core/core.h b/drivers/net/ethernet/pensando/pds_core/core.h
index 022adc4aea01..d0d2c395ba25 100644
--- a/drivers/net/ethernet/pensando/pds_core/core.h
+++ b/drivers/net/ethernet/pensando/pds_core/core.h
@@ -9,8 +9,13 @@
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_intr.h>
 
 #define PDSC_DRV_DESCRIPTION	"Pensando Core PF Driver"
+#define PDSC_TEARDOWN_RECOVERY	false
+#define PDSC_TEARDOWN_REMOVING	true
+#define PDSC_SETUP_RECOVERY	false
+#define PDSC_SETUP_INIT		true
 
 struct pdsc_dev_bar {
 	void __iomem *vaddr;
@@ -19,6 +24,22 @@ struct pdsc_dev_bar {
 	int res_index;
 };
 
+struct pdsc_devinfo {
+	u8 asic_type;
+	u8 asic_rev;
+	char fw_version[PDS_CORE_DEVINFO_FWVERS_BUFLEN + 1];
+	char serial_num[PDS_CORE_DEVINFO_SERIAL_BUFLEN + 1];
+};
+
+#define PDSC_INTR_NAME_MAX_SZ		32
+
+struct pdsc_intr_info {
+	char name[PDSC_INTR_NAME_MAX_SZ];
+	unsigned int index;
+	unsigned int vector;
+	void *data;
+};
+
 /* No state flags set means we are in a steady running state */
 enum pdsc_state_flags {
 	PDSC_S_FW_DEAD,		    /* fw stopped, waiting for startup or recovery */
@@ -34,11 +55,24 @@ struct pdsc {
 	struct dentry *dentry;
 	struct device *dev;
 	struct pdsc_dev_bar bars[PDS_CORE_BARS_MAX];
+	int num_vfs;
 	int hw_index;
 	int id;
 
 	unsigned long state;
+	u8 fw_status;
+	u8 fw_generation;
+	unsigned long last_fw_time;
+	u32 last_hb;
 
+	struct pdsc_devinfo dev_info;
+	struct pds_core_dev_identity dev_ident;
+	unsigned int nintrs;
+	struct pdsc_intr_info *intr_info;	/* array of nintrs elements */
+
+	unsigned int devcmd_timeout;
+	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
+	struct mutex config_lock;	/* lock for configuration operations */
 	struct pds_core_dev_info_regs __iomem *info_regs;
 	struct pds_core_dev_cmd_regs __iomem *cmd_regs;
 	struct pds_core_intr __iomem *intr_ctrl;
@@ -48,6 +82,8 @@ struct pdsc {
 	u64 __iomem *kern_dbpage;
 };
 
+void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
+
 struct pdsc *pdsc_dl_alloc(struct device *dev);
 void pdsc_dl_free(struct pdsc *pdsc);
 int pdsc_dl_register(struct pdsc *pdsc);
@@ -58,11 +94,30 @@ void pdsc_debugfs_create(void);
 void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
 void pdsc_debugfs_del_dev(struct pdsc *pdsc);
+void pdsc_debugfs_add_ident(struct pdsc *pdsc);
+void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
 #else
 static inline void pdsc_debugfs_create(void) { }
 static inline void pdsc_debugfs_destroy(void) { }
 static inline void pdsc_debugfs_add_dev(struct pdsc *pdsc) { }
 static inline void pdsc_debugfs_del_dev(struct pdsc *pdsc) { }
+static inline void pdsc_debugfs_add_ident(struct pdsc *pdsc) { }
+static inline void pdsc_debugfs_add_irqs(struct pdsc *pdsc) { }
 #endif
 
+int pdsc_err_to_errno(enum pds_core_status_code code);
+bool pdsc_is_fw_running(struct pdsc *pdsc);
+bool pdsc_is_fw_good(struct pdsc *pdsc);
+int pdsc_devcmd(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
+		union pds_core_dev_comp *comp, int max_seconds);
+int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
+		       union pds_core_dev_comp *comp, int max_seconds);
+int pdsc_devcmd_init(struct pdsc *pdsc);
+int pdsc_devcmd_reset(struct pdsc *pdsc);
+int pdsc_dev_reinit(struct pdsc *pdsc);
+int pdsc_dev_init(struct pdsc *pdsc);
+
+int pdsc_setup(struct pdsc *pdsc, bool init);
+void pdsc_teardown(struct pdsc *pdsc, bool removing);
+
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/pensando/pds_core/debugfs.c b/drivers/net/ethernet/pensando/pds_core/debugfs.c
index 3f876dcc5431..698fd6d09387 100644
--- a/drivers/net/ethernet/pensando/pds_core/debugfs.c
+++ b/drivers/net/ethernet/pensando/pds_core/debugfs.c
@@ -44,4 +44,71 @@ void pdsc_debugfs_del_dev(struct pdsc *pdsc)
 	debugfs_remove_recursive(pdsc->dentry);
 	pdsc->dentry = NULL;
 }
+
+static int identity_show(struct seq_file *seq, void *v)
+{
+	struct pdsc *pdsc = seq->private;
+	struct pds_core_dev_identity *ident;
+	int vt;
+
+	ident = &pdsc->dev_ident;
+
+	seq_printf(seq, "asic_type:        0x%x\n", pdsc->dev_info.asic_type);
+	seq_printf(seq, "asic_rev:         0x%x\n", pdsc->dev_info.asic_rev);
+	seq_printf(seq, "serial_num:       %s\n", pdsc->dev_info.serial_num);
+	seq_printf(seq, "fw_version:       %s\n", pdsc->dev_info.fw_version);
+	seq_printf(seq, "fw_status:        0x%x\n",
+		   ioread8(&pdsc->info_regs->fw_status));
+	seq_printf(seq, "fw_heartbeat:     0x%x\n",
+		   ioread32(&pdsc->info_regs->fw_heartbeat));
+
+	seq_printf(seq, "nlifs:            %d\n", le32_to_cpu(ident->nlifs));
+	seq_printf(seq, "nintrs:           %d\n", le32_to_cpu(ident->nintrs));
+	seq_printf(seq, "ndbpgs_per_lif:   %d\n", le32_to_cpu(ident->ndbpgs_per_lif));
+	seq_printf(seq, "intr_coal_mult:   %d\n", le32_to_cpu(ident->intr_coal_mult));
+	seq_printf(seq, "intr_coal_div:    %d\n", le32_to_cpu(ident->intr_coal_div));
+
+	seq_puts(seq, "vif_types:        ");
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++)
+		seq_printf(seq, "%d ", le16_to_cpu(pdsc->dev_ident.vif_types[vt]));
+	seq_puts(seq, "\n");
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(identity);
+
+void pdsc_debugfs_add_ident(struct pdsc *pdsc)
+{
+	debugfs_create_file("identity", 0400, pdsc->dentry, pdsc, &identity_fops);
+}
+
+static int irqs_show(struct seq_file *seq, void *v)
+{
+	struct pdsc *pdsc = seq->private;
+	struct pdsc_intr_info *intr_info;
+	int i;
+
+	seq_printf(seq, "index  vector  name (nintrs %d)\n", pdsc->nintrs);
+
+	if (!pdsc->intr_info)
+		return 0;
+
+	for (i = 0; i < pdsc->nintrs; i++) {
+		intr_info = &pdsc->intr_info[i];
+		if (!intr_info->vector)
+			continue;
+
+		seq_printf(seq, "% 3d    % 3d     %s\n",
+			   i, intr_info->vector, intr_info->name);
+	}
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(irqs);
+
+void pdsc_debugfs_add_irqs(struct pdsc *pdsc)
+{
+	debugfs_create_file("irqs", 0400, pdsc->dentry, pdsc, &irqs_fops);
+}
+
 #endif /* CONFIG_DEBUG_FS */
diff --git a/drivers/net/ethernet/pensando/pds_core/dev.c b/drivers/net/ethernet/pensando/pds_core/dev.c
new file mode 100644
index 000000000000..1f1193706407
--- /dev/null
+++ b/drivers/net/ethernet/pensando/pds_core/dev.c
@@ -0,0 +1,355 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2022 Pensando Systems, Inc */
+
+#include <linux/version.h>
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/delay.h>
+#include <linux/utsname.h>
+#include <linux/ctype.h>
+
+#include "core.h"
+
+int pdsc_err_to_errno(enum pds_core_status_code code)
+{
+	switch (code) {
+	case PDS_RC_SUCCESS:
+		return 0;
+	case PDS_RC_EVERSION:
+	case PDS_RC_EQTYPE:
+	case PDS_RC_EQID:
+	case PDS_RC_EINVAL:
+	case PDS_RC_ENOSUPP:
+		return -EINVAL;
+	case PDS_RC_EPERM:
+		return -EPERM;
+	case PDS_RC_ENOENT:
+		return -ENOENT;
+	case PDS_RC_EAGAIN:
+		return -EAGAIN;
+	case PDS_RC_ENOMEM:
+		return -ENOMEM;
+	case PDS_RC_EFAULT:
+		return -EFAULT;
+	case PDS_RC_EBUSY:
+		return -EBUSY;
+	case PDS_RC_EEXIST:
+		return -EEXIST;
+	case PDS_RC_EVFID:
+		return -ENODEV;
+	case PDS_RC_ECLIENT:
+		return -ECHILD;
+	case PDS_RC_ENOSPC:
+		return -ENOSPC;
+	case PDS_RC_ERANGE:
+		return -ERANGE;
+	case PDS_RC_BAD_ADDR:
+		return -EFAULT;
+	case PDS_RC_EOPCODE:
+	case PDS_RC_EINTR:
+	case PDS_RC_DEV_CMD:
+	case PDS_RC_ERROR:
+	case PDS_RC_ERDMA:
+	case PDS_RC_EIO:
+	default:
+		return -EIO;
+	}
+}
+
+bool pdsc_is_fw_running(struct pdsc *pdsc)
+{
+	pdsc->fw_status = ioread8(&pdsc->info_regs->fw_status);
+	pdsc->last_fw_time = jiffies;
+	pdsc->last_hb = ioread32(&pdsc->info_regs->fw_heartbeat);
+
+	/* Firmware is useful only if the running bit is set and
+	 * fw_status != 0xff (bad PCI read)
+	 */
+	return (pdsc->fw_status != 0xff) &&
+		(pdsc->fw_status & PDS_CORE_FW_STS_F_RUNNING);
+}
+
+bool pdsc_is_fw_good(struct pdsc *pdsc)
+{
+	return pdsc_is_fw_running(pdsc) &&
+		(pdsc->fw_status & PDS_CORE_FW_STS_F_GENERATION) == pdsc->fw_generation;
+}
+
+static u8 pdsc_devcmd_status(struct pdsc *pdsc)
+{
+	return ioread8(&pdsc->cmd_regs->comp.status);
+}
+
+static bool pdsc_devcmd_done(struct pdsc *pdsc)
+{
+	return ioread32(&pdsc->cmd_regs->done) & PDS_CORE_DEV_CMD_DONE;
+}
+
+static void pdsc_devcmd_dbell(struct pdsc *pdsc)
+{
+	iowrite32(0, &pdsc->cmd_regs->done);
+	iowrite32(1, &pdsc->cmd_regs->doorbell);
+}
+
+static void pdsc_devcmd_clean(struct pdsc *pdsc)
+{
+	iowrite32(0, &pdsc->cmd_regs->doorbell);
+	memset_io(&pdsc->cmd_regs->cmd, 0, sizeof(pdsc->cmd_regs->cmd));
+}
+
+static const char *pdsc_devcmd_str(int opcode)
+{
+	switch (opcode) {
+	case PDS_CORE_CMD_NOP:
+		return "PDS_CORE_CMD_NOP";
+	case PDS_CORE_CMD_IDENTIFY:
+		return "PDS_CORE_CMD_IDENTIFY";
+	case PDS_CORE_CMD_RESET:
+		return "PDS_CORE_CMD_RESET";
+	case PDS_CORE_CMD_INIT:
+		return "PDS_CORE_CMD_INIT";
+	case PDS_CORE_CMD_FW_DOWNLOAD:
+		return "PDS_CORE_CMD_FW_DOWNLOAD";
+	case PDS_CORE_CMD_FW_CONTROL:
+		return "PDS_CORE_CMD_FW_CONTROL";
+	default:
+		return "PDS_CORE_CMD_UNKNOWN";
+	}
+}
+
+static int pdsc_devcmd_wait(struct pdsc *pdsc, int max_seconds)
+{
+	struct device *dev = pdsc->dev;
+	unsigned long start_time;
+	unsigned long max_wait;
+	unsigned long duration;
+	int timeout = 0;
+	int status = 0;
+	int done = 0;
+	int err = 0;
+	int opcode;
+
+	opcode = ioread8(&pdsc->cmd_regs->cmd.opcode);
+
+	start_time = jiffies;
+	max_wait = start_time + (max_seconds * HZ);
+
+	while (!done && !timeout) {
+		done = pdsc_devcmd_done(pdsc);
+		if (done)
+			break;
+
+		timeout = time_after(jiffies, max_wait);
+		if (timeout)
+			break;
+
+		usleep_range(100, 200);
+	}
+	duration = jiffies - start_time;
+
+	if (done && duration > HZ)
+		dev_dbg(dev, "DEVCMD %d %s after %ld secs\n",
+			opcode, pdsc_devcmd_str(opcode), duration / HZ);
+
+	if (!done || timeout) {
+		dev_err(dev, "DEVCMD %d %s timeout, done %d timeout %d max_seconds=%d\n",
+			opcode, pdsc_devcmd_str(opcode), done, timeout,
+			max_seconds);
+		err = -ETIMEDOUT;
+		pdsc_devcmd_clean(pdsc);
+	}
+
+	status = pdsc_devcmd_status(pdsc);
+	err = pdsc_err_to_errno(status);
+	if (status != PDS_RC_SUCCESS && status != PDS_RC_EAGAIN)
+		dev_err(dev, "DEVCMD %d %s failed, status=%d err %d %pe\n",
+			opcode, pdsc_devcmd_str(opcode), status, err,
+			ERR_PTR(err));
+
+	return err;
+}
+
+int pdsc_devcmd_locked(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
+		       union pds_core_dev_comp *comp, int max_seconds)
+{
+	int err;
+
+	memcpy_toio(&pdsc->cmd_regs->cmd, cmd, sizeof(*cmd));
+	pdsc_devcmd_dbell(pdsc);
+	err = pdsc_devcmd_wait(pdsc, max_seconds);
+	memcpy_fromio(comp, &pdsc->cmd_regs->comp, sizeof(*comp));
+
+	return err;
+}
+
+int pdsc_devcmd(struct pdsc *pdsc, union pds_core_dev_cmd *cmd,
+		union pds_core_dev_comp *comp, int max_seconds)
+{
+	int err;
+
+	mutex_lock(&pdsc->devcmd_lock);
+	err = pdsc_devcmd_locked(pdsc, cmd, comp, max_seconds);
+	mutex_unlock(&pdsc->devcmd_lock);
+
+	return err;
+}
+
+int pdsc_devcmd_init(struct pdsc *pdsc)
+{
+	union pds_core_dev_comp comp = { 0 };
+	union pds_core_dev_cmd cmd = {
+		.opcode = PDS_CORE_CMD_INIT,
+	};
+
+	return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+int pdsc_devcmd_reset(struct pdsc *pdsc)
+{
+	union pds_core_dev_comp comp = { 0 };
+	union pds_core_dev_cmd cmd = {
+		.reset.opcode = PDS_CORE_CMD_RESET,
+	};
+
+	return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+static int pdsc_devcmd_identify_locked(struct pdsc *pdsc)
+{
+	union pds_core_dev_comp comp = { 0 };
+	union pds_core_dev_cmd cmd = {
+		.identify.opcode = PDS_CORE_CMD_IDENTIFY,
+		.identify.ver = PDS_CORE_IDENTITY_VERSION_1,
+	};
+
+	return pdsc_devcmd_locked(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+static void pdsc_init_devinfo(struct pdsc *pdsc)
+{
+	pdsc->dev_info.asic_type = ioread8(&pdsc->info_regs->asic_type);
+	pdsc->dev_info.asic_rev = ioread8(&pdsc->info_regs->asic_rev);
+
+	memcpy_fromio(pdsc->dev_info.fw_version,
+		      pdsc->info_regs->fw_version,
+		      PDS_CORE_DEVINFO_FWVERS_BUFLEN);
+
+	memcpy_fromio(pdsc->dev_info.serial_num,
+		      pdsc->info_regs->serial_num,
+		      PDS_CORE_DEVINFO_SERIAL_BUFLEN);
+
+	pdsc->dev_info.fw_version[PDS_CORE_DEVINFO_FWVERS_BUFLEN] = 0;
+	pdsc->dev_info.serial_num[PDS_CORE_DEVINFO_SERIAL_BUFLEN] = 0;
+
+	dev_dbg(pdsc->dev, "fw_version %s\n", pdsc->dev_info.fw_version);
+}
+
+static int pdsc_identify(struct pdsc *pdsc)
+{
+	struct pds_core_drv_identity drv = { 0 };
+	size_t sz;
+	int err;
+
+	drv.drv_type = cpu_to_le32(PDS_DRIVER_LINUX);
+	drv.kernel_ver = cpu_to_le32(LINUX_VERSION_CODE);
+	snprintf(drv.kernel_ver_str, sizeof(drv.kernel_ver_str),
+		 "%s %s", utsname()->release, utsname()->version);
+	snprintf(drv.driver_ver_str, sizeof(drv.driver_ver_str),
+		 "%s %s", PDS_CORE_DRV_NAME, utsname()->release);
+
+	/* Next let's get some info about the device
+	 * We use the devcmd_lock at this level in order to
+	 * get safe access to the cmd_regs->data before anyone
+	 * else can mess it up
+	 */
+	mutex_lock(&pdsc->devcmd_lock);
+
+	sz = min_t(size_t, sizeof(drv), sizeof(pdsc->cmd_regs->data));
+	memcpy_toio(&pdsc->cmd_regs->data, &drv, sz);
+
+	err = pdsc_devcmd_identify_locked(pdsc);
+	if (!err) {
+		sz = min_t(size_t, sizeof(pdsc->dev_ident), sizeof(pdsc->cmd_regs->data));
+		memcpy_fromio(&pdsc->dev_ident, &pdsc->cmd_regs->data, sz);
+	}
+	mutex_unlock(&pdsc->devcmd_lock);
+
+	if (err) {
+		dev_err(pdsc->dev, "Cannot identify device: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
+	if (isprint(pdsc->dev_info.fw_version[0]) &&
+	    isascii(pdsc->dev_info.fw_version[0]))
+		dev_info(pdsc->dev, "FW: %.*s\n",
+			 (int)(sizeof(pdsc->dev_info.fw_version) - 1),
+			 pdsc->dev_info.fw_version);
+	else
+		dev_info(pdsc->dev, "FW: (invalid string) 0x%02x 0x%02x 0x%02x 0x%02x ...\n",
+			 (u8)pdsc->dev_info.fw_version[0],
+			 (u8)pdsc->dev_info.fw_version[1],
+			 (u8)pdsc->dev_info.fw_version[2],
+			 (u8)pdsc->dev_info.fw_version[3]);
+
+	return 0;
+}
+
+int pdsc_dev_reinit(struct pdsc *pdsc)
+{
+	pdsc_init_devinfo(pdsc);
+
+	return pdsc_identify(pdsc);
+}
+
+int pdsc_dev_init(struct pdsc *pdsc)
+{
+	unsigned int nintrs;
+	int err;
+
+	/* Initial init and reset of device */
+	pdsc_init_devinfo(pdsc);
+	pdsc->devcmd_timeout = PDS_CORE_DEVCMD_TIMEOUT;
+
+	err = pdsc_devcmd_reset(pdsc);
+	if (err)
+		return err;
+
+	err = pdsc_identify(pdsc);
+	if (err)
+		return err;
+
+	pdsc_debugfs_add_ident(pdsc);
+
+	/* Now we can reserve interrupts */
+	nintrs = le32_to_cpu(pdsc->dev_ident.nintrs);
+	nintrs = min_t(unsigned int, num_online_cpus(), nintrs);
+
+	/* Get intr_info struct array for tracking */
+	pdsc->intr_info = devm_kcalloc(pdsc->dev, nintrs,
+				       sizeof(*pdsc->intr_info), GFP_KERNEL);
+	if (!pdsc->intr_info) {
+		err = -ENOSPC;
+		goto err_out;
+	}
+
+	err = pci_alloc_irq_vectors(pdsc->pdev, nintrs, nintrs, PCI_IRQ_MSIX);
+	if (err != nintrs) {
+		dev_err(pdsc->dev, "Can't get %d intrs from OS: %pe\n",
+			nintrs, ERR_PTR(err));
+		err = -ENOSPC;
+		goto err_out;
+	}
+	pdsc->nintrs = nintrs;
+	pdsc_debugfs_add_irqs(pdsc);
+
+	return 0;
+
+err_out:
+	if (pdsc->intr_info) {
+		devm_kfree(pdsc->dev, pdsc->intr_info);
+		pdsc->intr_info = NULL;
+	}
+	return err;
+}
diff --git a/drivers/net/ethernet/pensando/pds_core/main.c b/drivers/net/ethernet/pensando/pds_core/main.c
index 4bdbcc1c17a7..770b3f895bbb 100644
--- a/drivers/net/ethernet/pensando/pds_core/main.c
+++ b/drivers/net/ethernet/pensando/pds_core/main.c
@@ -189,6 +189,15 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	if (err)
 		goto err_out_pci_disable_device;
 
+	/* PDS device setup */
+	mutex_init(&pdsc->devcmd_lock);
+	mutex_init(&pdsc->config_lock);
+
+	mutex_lock(&pdsc->config_lock);
+	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
+	if (err)
+		goto err_out_unmap_bars;
+
 	/* publish devlink device */
 	err = pdsc_dl_register(pdsc);
 	if (err) {
@@ -196,10 +205,21 @@ static int pdsc_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 		goto err_out;
 	}
 
+	mutex_unlock(&pdsc->config_lock);
+
+	pdsc->fw_generation = PDS_CORE_FW_STS_F_GENERATION &
+			      ioread8(&pdsc->info_regs->fw_status);
+
 	clear_bit(PDSC_S_INITING_DRIVER, &pdsc->state);
 	return 0;
 
 err_out:
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
+err_out_unmap_bars:
+	mutex_unlock(&pdsc->config_lock);
+	mutex_destroy(&pdsc->config_lock);
+	mutex_destroy(&pdsc->devcmd_lock);
+	pci_free_irq_vectors(pdev);
 	pci_clear_master(pdev);
 	pdsc_unmap_bars(pdsc);
 	pci_release_regions(pdev);
@@ -224,10 +244,20 @@ static void pdsc_remove(struct pci_dev *pdev)
 	 */
 	pdsc_dl_unregister(pdsc);
 
+	/* Now we can lock it up and tear it down */
+	mutex_lock(&pdsc->config_lock);
+	set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
+
 	/* Device teardown */
+	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
+	pdsc_debugfs_del_dev(pdsc);
+	mutex_unlock(&pdsc->config_lock);
+	mutex_destroy(&pdsc->config_lock);
+	mutex_destroy(&pdsc->devcmd_lock);
 	ida_free(&pdsc_pf_ida, pdsc->id);
 
 	/* PCI teardown */
+	pci_free_irq_vectors(pdev);
 	pci_clear_master(pdev);
 	pdsc_unmap_bars(pdsc);
 	pci_release_regions(pdev);
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index 7de3c1b8526b..e7fe84379a2f 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -10,4 +10,71 @@
 #define PDS_CORE_ADDR_LEN	52
 #define PDS_CORE_ADDR_MASK	(BIT_ULL(PDS_ADDR_LEN) - 1)
 
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
+enum pds_core_driver_type {
+	PDS_DRIVER_LINUX   = 1,
+	PDS_DRIVER_WIN     = 2,
+	PDS_DRIVER_DPDK    = 3,
+	PDS_DRIVER_FREEBSD = 4,
+	PDS_DRIVER_IPXE    = 5,
+	PDS_DRIVER_ESXI    = 6,
+};
+
+/* PDSC interface uses identity version 1 and PDSC uses 2 */
+#define PDSC_IDENTITY_VERSION_1		1
+#define PDSC_IDENTITY_VERSION_2		2
+
+#define PDS_CORE_IFNAMSIZ		16
+
+/**
+ * enum pds_core_logical_qtype - Logical Queue Types
+ * @PDS_CORE_QTYPE_ADMINQ:    Administrative Queue
+ * @PDS_CORE_QTYPE_NOTIFYQ:   Notify Queue
+ * @PDS_CORE_QTYPE_RXQ:       Receive Queue
+ * @PDS_CORE_QTYPE_TXQ:       Transmit Queue
+ * @PDS_CORE_QTYPE_EQ:        Event Queue
+ * @PDS_CORE_QTYPE_MAX:       Max queue type supported
+ */
+enum pds_core_logical_qtype {
+	PDS_CORE_QTYPE_ADMINQ  = 0,
+	PDS_CORE_QTYPE_NOTIFYQ = 1,
+	PDS_CORE_QTYPE_RXQ     = 2,
+	PDS_CORE_QTYPE_TXQ     = 3,
+	PDS_CORE_QTYPE_EQ      = 4,
+
+	PDS_CORE_QTYPE_MAX     = 16   /* don't change - used in struct size */
+};
+
+typedef void (*pds_core_cb)(void *cb_arg);
+
 #endif /* _PDS_COMMON_H_ */
diff --git a/include/linux/pds/pds_intr.h b/include/linux/pds/pds_intr.h
new file mode 100644
index 000000000000..bcdafd492e65
--- /dev/null
+++ b/include/linux/pds/pds_intr.h
@@ -0,0 +1,160 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
+/* Copyright (c) 2022 Pensando Systems, Inc.  All rights reserved. */
+
+#ifndef _PDS_INTR_H_
+#define _PDS_INTR_H_
+
+/*
+ * Interrupt control register
+ * @coal_init:        Coalescing timer initial value, in
+ *                    device units.  Use @identity->intr_coal_mult
+ *                    and @identity->intr_coal_div to convert from
+ *                    usecs to device units:
+ *
+ *                      coal_init = coal_usecs * coal_mutl / coal_div
+ *
+ *                    When an interrupt is sent the interrupt
+ *                    coalescing timer current value
+ *                    (@coalescing_curr) is initialized with this
+ *                    value and begins counting down.  No more
+ *                    interrupts are sent until the coalescing
+ *                    timer reaches 0.  When @coalescing_init=0
+ *                    interrupt coalescing is effectively disabled
+ *                    and every interrupt assert results in an
+ *                    interrupt.  Reset value: 0
+ * @mask:             Interrupt mask.  When @mask=1 the interrupt
+ *                    resource will not send an interrupt.  When
+ *                    @mask=0 the interrupt resource will send an
+ *                    interrupt if an interrupt event is pending
+ *                    or on the next interrupt assertion event.
+ *                    Reset value: 1
+ * @credits:          Interrupt credits.  This register indicates
+ *                    how many interrupt events the hardware has
+ *                    sent.  When written by software this
+ *                    register atomically decrements @int_credits
+ *                    by the value written.  When @int_credits
+ *                    becomes 0 then the "pending interrupt" bit
+ *                    in the Interrupt Status register is cleared
+ *                    by the hardware and any pending but unsent
+ *                    interrupts are cleared.
+ *                    !!!IMPORTANT!!! This is a signed register.
+ * @flags:            Interrupt control flags
+ *                       @unmask -- When this bit is written with a 1
+ *                       the interrupt resource will set mask=0.
+ *                       @coal_timer_reset -- When this
+ *                       bit is written with a 1 the
+ *                       @coalescing_curr will be reloaded with
+ *                       @coalescing_init to reset the coalescing
+ *                       timer.
+ * @mask_on_assert:   Automatically mask on assertion.  When
+ *                    @mask_on_assert=1 the interrupt resource
+ *                    will set @mask=1 whenever an interrupt is
+ *                    sent.  When using interrupts in Legacy
+ *                    Interrupt mode the driver must select
+ *                    @mask_on_assert=0 for proper interrupt
+ *                    operation.
+ * @coalescing_curr:  Coalescing timer current value, in
+ *                    microseconds.  When this value reaches 0
+ *                    the interrupt resource is again eligible to
+ *                    send an interrupt.  If an interrupt event
+ *                    is already pending when @coalescing_curr
+ *                    reaches 0 the pending interrupt will be
+ *                    sent, otherwise an interrupt will be sent
+ *                    on the next interrupt assertion event.
+ */
+struct pds_core_intr {
+	u32 coal_init;
+	u32 mask;
+	u16 credits;
+	u16 flags;
+#define PDS_CORE_INTR_F_UNMASK		0x0001
+#define PDS_CORE_INTR_F_TIMER_RESET	0x0002
+	u32 mask_on_assert;
+	u32 coalescing_curr;
+	u32 rsvd6[3];
+};
+#ifndef __CHECKER__
+static_assert(sizeof(struct pds_core_intr) == 32);
+#endif /* __CHECKER__ */
+
+#define PDS_CORE_INTR_CTRL_REGS_MAX		2048
+#define PDS_CORE_INTR_CTRL_COAL_MAX		0x3F
+#define PDS_CORE_INTR_INDEX_NOT_ASSIGNED	-1
+
+struct pds_core_intr_status {
+	u32 status[2];
+};
+
+/**
+ * enum pds_core_intr_mask_vals - valid values for mask and mask_assert.
+ * @PDS_CORE_INTR_MASK_CLEAR:	unmask interrupt.
+ * @PDS_CORE_INTR_MASK_SET:	mask interrupt.
+ */
+enum pds_core_intr_mask_vals {
+	PDS_CORE_INTR_MASK_CLEAR	= 0,
+	PDS_CORE_INTR_MASK_SET		= 1,
+};
+
+/**
+ * enum pds_core_intr_credits_bits - Bitwise composition of credits values.
+ * @PDS_CORE_INTR_CRED_COUNT:	bit mask of credit count, no shift needed.
+ * @PDS_CORE_INTR_CRED_COUNT_SIGNED: bit mask of credit count, including sign bit.
+ * @PDS_CORE_INTR_CRED_UNMASK:	unmask the interrupt.
+ * @PDS_CORE_INTR_CRED_RESET_COALESCE: reset the coalesce timer.
+ * @PDS_CORE_INTR_CRED_REARM:	unmask the and reset the timer.
+ */
+enum pds_core_intr_credits_bits {
+	PDS_CORE_INTR_CRED_COUNT		= 0x7fffu,
+	PDS_CORE_INTR_CRED_COUNT_SIGNED		= 0xffffu,
+	PDS_CORE_INTR_CRED_UNMASK		= 0x10000u,
+	PDS_CORE_INTR_CRED_RESET_COALESCE	= 0x20000u,
+	PDS_CORE_INTR_CRED_REARM		= (PDS_CORE_INTR_CRED_UNMASK |
+					   PDS_CORE_INTR_CRED_RESET_COALESCE),
+};
+
+static inline void pds_core_intr_coal_init(struct pds_core_intr __iomem *intr_ctrl,
+					   u32 coal)
+{
+	iowrite32(coal, &intr_ctrl->coal_init);
+}
+
+static inline void pds_core_intr_mask(struct pds_core_intr __iomem *intr_ctrl,
+				      u32 mask)
+{
+	iowrite32(mask, &intr_ctrl->mask);
+}
+
+static inline void pds_core_intr_credits(struct pds_core_intr __iomem *intr_ctrl,
+					 u32 cred, u32 flags)
+{
+	if (WARN_ON_ONCE(cred > PDS_CORE_INTR_CRED_COUNT)) {
+		cred = ioread32(&intr_ctrl->credits);
+		cred &= PDS_CORE_INTR_CRED_COUNT_SIGNED;
+	}
+
+	iowrite32(cred | flags, &intr_ctrl->credits);
+}
+
+static inline void pds_core_intr_clean_flags(struct pds_core_intr __iomem *intr_ctrl,
+					     u32 flags)
+{
+	u32 cred;
+
+	cred = ioread32(&intr_ctrl->credits);
+	cred &= PDS_CORE_INTR_CRED_COUNT_SIGNED;
+	cred |= flags;
+	iowrite32(cred, &intr_ctrl->credits);
+}
+
+static inline void pds_core_intr_clean(struct pds_core_intr __iomem *intr_ctrl)
+{
+	pds_core_intr_clean_flags(intr_ctrl, PDS_CORE_INTR_CRED_RESET_COALESCE);
+}
+
+static inline void pds_core_intr_mask_assert(struct pds_core_intr __iomem *intr_ctrl,
+					     u32 mask)
+{
+	iowrite32(mask, &intr_ctrl->mask_on_assert);
+}
+
+#endif /* _PDS_INTR_H_ */
-- 
2.17.1


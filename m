Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A37586E800F
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbjDSRFO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:05:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233478AbjDSRFI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:08 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2084.outbound.protection.outlook.com [40.107.243.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C956772B4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zz+MatDGW8ESWJPkShpA78UgeQ5lvvbFIe8biJMCMe/0Q1cRKLPBwFCfGz19NxM82ibvs88oEmjDU0XN7uD4uv9M7bQlv4jvT+KgjZ6FxgjFkVp6N8M6aQB6oEK4RbKaGzwaMkDYHEsFIgQv3zZlIIHGxljRJV+QZrsLGU6HxfM7b69vc9QkaoXq7cKZ+u/V5l9Po7UUTBc7CWU0/NlE221SN04EfAubxm9ftLGQXq44g/g/g/03Tqz3ai+Gm9ECa+ypySBCYP4gnhiH60GqW1X+4cnXSnND8QJF81kVzXkgVUWGiEWwRS1KNJLT3tAEjRfHUuEF6dl7DUGBufewbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gAlxFZzgfAIxxP7MlFU2glnll53+mdjSDaJvhkIm2hU=;
 b=cDu/HIclzNwVK5lbifcyq0IzZw88Rv/4F7BDwlOS8unvXNTrmNGgRS+ehQyppYv4j/cdPLNXXDru83tNB13BsJFmY7vbB94mI3GtrU/0EUsu8wwTybWcPDNxVgnQ76cdKLgGtGbutXEy1xHPO77ev4+mRi5qbuQ9oo4gVudI/3jRtUt5KrIw3t7N6y91PxM/QWwnIGdidvJiw+7VC0aQG8bDNVqH4X6RWGV2+w1QIBemuSBoFeQxHOOi1oVb6ZS9djS3wBC+UraBIxrzsM/rVjQqJwrRU/yOwYDkAS/ZeVg82qsFnEkIxvqPcsC3OR6DA/OqoZt6xg0SGkwmIiZepw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gAlxFZzgfAIxxP7MlFU2glnll53+mdjSDaJvhkIm2hU=;
 b=Wmh1k/TWy4UIMtNJ0LmqSv+ebzVdgS4PGZWWTcELKw+y/KIZv+wd7/okOD6Kzr38f4Ncnc+punqrnZLHKSRGJ28imw1dUVV8zLaH3Xnve1FQ/vOluVK2neo09UwW1qcdtVUxuWop/Z7vJ7dpnoblgGrCxbU/qiP+OaE9Aw3fvhg=
Received: from MW4PR04CA0284.namprd04.prod.outlook.com (2603:10b6:303:89::19)
 by SA0PR12MB7090.namprd12.prod.outlook.com (2603:10b6:806:2d5::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Wed, 19 Apr
 2023 17:05:01 +0000
Received: from CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:89:cafe::36) by MW4PR04CA0284.outlook.office365.com
 (2603:10b6:303:89::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:00 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT030.mail.protection.outlook.com (10.13.174.125) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.30 via Frontend Transport; Wed, 19 Apr 2023 17:04:59 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:04:57 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 02/14] pds_core: add devcmd device interfaces
Date:   Wed, 19 Apr 2023 10:04:15 -0700
Message-ID: <20230419170427.1108-3-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: CO1NAM11FT030:EE_|SA0PR12MB7090:EE_
X-MS-Office365-Filtering-Correlation-Id: 7cfd3bae-14d2-4e42-da68-08db40f835ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uWSZ0yvcW+Sc13Zuo4egdfhy21VWHbArCRMHh2S5z9r+mWvwxjfkDag5G9oFFafXCyN0vnBxHvtfuFPsEbeVVDGW+ztG+55har4d8KpXdCzHLgs2nMV5+zLMmSB2EGjj4PrjWjdNiazgFjoELQId7233stjaMYGOqcJZr6W+AOGpT0DtSdAcQR8VcamSRyXmLSqVGFsbSq5v7PcWaHbmi0E4c3NttNXDvcd5B8hlHnh3jkWimoCE4MhXOumjW4N3rHR7KlCb97O2CLHKl4qCjUmo5nmhxC25r9r5ZjVUrebxster/CjWE4jVkh/o9bISoU4WxwsYvI6EsHWya4EaEfQtqW29fpzNENvXzoDqYfXYQif8j3pZzNqWYbscMKIYqh30zxpfBMiv7hTvFg6AgOTNELOmS4BS7FG9hNmH520MzOtRFCkqcTASjkhA68zDbJaBmGeDtqeHxzFLzXwdMC4LpbgHKtqnqsjGNfqHGb4c3hQC+wT2cxhhvUutDpHUjNFTAf4felGltmndhmvZjk+RdvKBEJqr1zYflr2lEAA9RCril00g38eMsAM4Hv+pM2fGc8M9OYHALYwb4ZgkZQKRG+olB3ex1Z+tJ2Pwn1dnxUMhxJhgIJL2udT7ItW6gBxSS6C6GzRd4BKQVfC72KzRrhsb7xxM2tSzkIDh2Ow2h48sVomYpGbhNLtNbVspQUf7lWZ73D/P6z7i5GEyrU4dq7ivKKyuExmIqaPJngo=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(396003)(376002)(136003)(346002)(451199021)(40470700004)(46966006)(36840700001)(110136005)(336012)(426003)(1076003)(26005)(54906003)(40480700001)(186003)(47076005)(83380400001)(16526019)(36860700001)(2616005)(40460700003)(5660300002)(82740400003)(6666004)(82310400005)(8676002)(316002)(356005)(8936002)(81166007)(86362001)(41300700001)(478600001)(70586007)(70206006)(36756003)(30864003)(4326008)(2906002)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:04:59.8057
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cfd3bae-14d2-4e42-da68-08db40f835ae
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT030.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7090
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

The devcmd interface is the basic connection to the device through the
PCI BAR for low level identification and command services.  This does
the early device initialization and finds the identity data, and adds
devcmd routines to be used by later driver bits.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/Makefile  |   4 +-
 drivers/net/ethernet/amd/pds_core/core.c    |  36 ++
 drivers/net/ethernet/amd/pds_core/core.h    |  50 +++
 drivers/net/ethernet/amd/pds_core/debugfs.c |  38 +++
 drivers/net/ethernet/amd/pds_core/dev.c     | 348 ++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/main.c    |  33 +-
 include/linux/pds/pds_common.h              |  30 ++
 include/linux/pds/pds_intr.h                | 163 +++++++++
 8 files changed, 699 insertions(+), 3 deletions(-)
 create mode 100644 drivers/net/ethernet/amd/pds_core/core.c
 create mode 100644 drivers/net/ethernet/amd/pds_core/dev.c
 create mode 100644 include/linux/pds/pds_intr.h

diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
index de3bf1d1886c..95a6c31e92d2 100644
--- a/drivers/net/ethernet/amd/pds_core/Makefile
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -3,6 +3,8 @@
 
 obj-$(CONFIG_PDS_CORE) := pds_core.o
 
-pds_core-y := main.o
+pds_core-y := main.o \
+	      dev.o \
+	      core.o
 
 pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
new file mode 100644
index 000000000000..80d2ecb045df
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -0,0 +1,36 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
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
+	if (removing) {
+		kfree(pdsc->intr_info);
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
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 34ef837e8cfe..fcf6c6545c49 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -9,8 +9,13 @@
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_intr.h>
 
 #define PDSC_DRV_DESCRIPTION	"AMD/Pensando Core Driver"
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
 	PDSC_S_FW_DEAD,		    /* stopped, wait on startup or recovery */
@@ -38,7 +59,19 @@ struct pdsc {
 	int uid;
 
 	unsigned long state;
+	u8 fw_status;
+	u8 fw_generation;
+	unsigned long last_fw_time;
+	u32 last_hb;
+
+	struct pdsc_devinfo dev_info;
+	struct pds_core_dev_identity dev_ident;
+	unsigned int nintrs;
+	struct pdsc_intr_info *intr_info;	/* array of nintrs elements */
 
+	unsigned int devcmd_timeout;
+	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
+	struct mutex config_lock;	/* lock for configuration operations */
 	struct pds_core_dev_info_regs __iomem *info_regs;
 	struct pds_core_dev_cmd_regs __iomem *cmd_regs;
 	struct pds_core_intr __iomem *intr_ctrl;
@@ -52,5 +85,22 @@ void pdsc_debugfs_create(void);
 void pdsc_debugfs_destroy(void);
 void pdsc_debugfs_add_dev(struct pdsc *pdsc);
 void pdsc_debugfs_del_dev(struct pdsc *pdsc);
+void pdsc_debugfs_add_ident(struct pdsc *pdsc);
+void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
+
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
 
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index b2f7cb795c20..601431b41abb 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -29,3 +29,41 @@ void pdsc_debugfs_del_dev(struct pdsc *pdsc)
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
+	seq_printf(seq, "fw_heartbeat:     0x%x\n",
+		   ioread32(&pdsc->info_regs->fw_heartbeat));
+
+	seq_printf(seq, "nlifs:            %d\n",
+		   le32_to_cpu(ident->nlifs));
+	seq_printf(seq, "nintrs:           %d\n",
+		   le32_to_cpu(ident->nintrs));
+	seq_printf(seq, "ndbpgs_per_lif:   %d\n",
+		   le32_to_cpu(ident->ndbpgs_per_lif));
+	seq_printf(seq, "intr_coal_mult:   %d\n",
+		   le32_to_cpu(ident->intr_coal_mult));
+	seq_printf(seq, "intr_coal_div:    %d\n",
+		   le32_to_cpu(ident->intr_coal_div));
+
+	seq_puts(seq, "vif_types:        ");
+	for (vt = 0; vt < PDS_DEV_TYPE_MAX; vt++)
+		seq_printf(seq, "%d ",
+			   le16_to_cpu(pdsc->dev_ident.vif_types[vt]));
+	seq_puts(seq, "\n");
+
+	return 0;
+}
+DEFINE_SHOW_ATTRIBUTE(identity);
+
+void pdsc_debugfs_add_ident(struct pdsc *pdsc)
+{
+	debugfs_create_file("identity", 0400, pdsc->dentry,
+			    pdsc, &identity_fops);
+}
diff --git a/drivers/net/ethernet/amd/pds_core/dev.c b/drivers/net/ethernet/amd/pds_core/dev.c
new file mode 100644
index 000000000000..f082d69c5128
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/dev.c
@@ -0,0 +1,348 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/errno.h>
+#include <linux/pci.h>
+#include <linux/utsname.h>
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
+	u8 gen = pdsc->fw_status & PDS_CORE_FW_STS_F_GENERATION;
+
+	return pdsc_is_fw_running(pdsc) && gen == pdsc->fw_generation;
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
+	int done = 0;
+	int err = 0;
+	int status;
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
+	if (err && err != -EAGAIN)
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
+	union pds_core_dev_comp comp = {};
+	union pds_core_dev_cmd cmd = {
+		.opcode = PDS_CORE_CMD_INIT,
+	};
+
+	return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+int pdsc_devcmd_reset(struct pdsc *pdsc)
+{
+	union pds_core_dev_comp comp = {};
+	union pds_core_dev_cmd cmd = {
+		.reset.opcode = PDS_CORE_CMD_RESET,
+	};
+
+	return pdsc_devcmd(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+}
+
+static int pdsc_devcmd_identify_locked(struct pdsc *pdsc)
+{
+	union pds_core_dev_comp comp = {};
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
+	pdsc->fw_generation = PDS_CORE_FW_STS_F_GENERATION &
+			      ioread8(&pdsc->info_regs->fw_status);
+
+	memcpy_fromio(pdsc->dev_info.fw_version,
+		      pdsc->info_regs->fw_version,
+		      PDS_CORE_DEVINFO_FWVERS_BUFLEN);
+	pdsc->dev_info.fw_version[PDS_CORE_DEVINFO_FWVERS_BUFLEN] = 0;
+
+	memcpy_fromio(pdsc->dev_info.serial_num,
+		      pdsc->info_regs->serial_num,
+		      PDS_CORE_DEVINFO_SERIAL_BUFLEN);
+	pdsc->dev_info.serial_num[PDS_CORE_DEVINFO_SERIAL_BUFLEN] = 0;
+
+	dev_dbg(pdsc->dev, "fw_version %s\n", pdsc->dev_info.fw_version);
+}
+
+static int pdsc_identify(struct pdsc *pdsc)
+{
+	struct pds_core_drv_identity drv = {};
+	size_t sz;
+	int err;
+
+	drv.drv_type = cpu_to_le32(PDS_DRIVER_LINUX);
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
+		sz = min_t(size_t, sizeof(pdsc->dev_ident),
+			   sizeof(pdsc->cmd_regs->data));
+		memcpy_fromio(&pdsc->dev_ident, &pdsc->cmd_regs->data, sz);
+	}
+	mutex_unlock(&pdsc->devcmd_lock);
+
+	if (err) {
+		dev_err(pdsc->dev, "Cannot identify device: %pe\n",
+			ERR_PTR(err));
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
+	pdsc->intr_info = kcalloc(nintrs, sizeof(*pdsc->intr_info), GFP_KERNEL);
+	if (!pdsc->intr_info) {
+		err = -ENOMEM;
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
+
+	return 0;
+
+err_out:
+	kfree(pdsc->intr_info);
+	pdsc->intr_info = NULL;
+
+	return err;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index c2b12f226959..09afb069dcb3 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -137,6 +137,18 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	if (err)
 		goto err_out_release_regions;
 
+	mutex_init(&pdsc->devcmd_lock);
+	mutex_init(&pdsc->config_lock);
+
+	mutex_lock(&pdsc->config_lock);
+	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
+
+	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
+	if (err)
+		goto err_out_unmap_bars;
+
+	mutex_unlock(&pdsc->config_lock);
+
 	dl = priv_to_devlink(pdsc);
 	devl_lock(dl);
 	devl_register(dl);
@@ -144,6 +156,12 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	return 0;
 
+err_out_unmap_bars:
+	mutex_unlock(&pdsc->config_lock);
+	mutex_destroy(&pdsc->config_lock);
+	mutex_destroy(&pdsc->devcmd_lock);
+	pci_free_irq_vectors(pdsc->pdev);
+	pdsc_unmap_bars(pdsc);
 err_out_release_regions:
 	pci_release_regions(pdsc->pdev);
 
@@ -240,8 +258,19 @@ static void pdsc_remove(struct pci_dev *pdev)
 	devl_unregister(dl);
 	devl_unlock(dl);
 
-	pdsc_unmap_bars(pdsc);
-	pci_release_regions(pdev);
+	if (!pdev->is_virtfn) {
+		mutex_lock(&pdsc->config_lock);
+		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
+
+		pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
+		mutex_unlock(&pdsc->config_lock);
+		mutex_destroy(&pdsc->config_lock);
+		mutex_destroy(&pdsc->devcmd_lock);
+
+		pci_free_irq_vectors(pdev);
+		pdsc_unmap_bars(pdsc);
+		pci_release_regions(pdev);
+	}
 
 	pci_clear_master(pdev);
 	pci_disable_device(pdev);
diff --git a/include/linux/pds/pds_common.h b/include/linux/pds/pds_common.h
index bd041a5170a6..f0798ce01acf 100644
--- a/include/linux/pds/pds_common.h
+++ b/include/linux/pds/pds_common.h
@@ -11,4 +11,34 @@
 #define PDS_CORE_ADDR_MASK	(BIT_ULL(PDS_ADDR_LEN) - 1)
 #define PDS_PAGE_SIZE		4096
 
+enum pds_core_driver_type {
+	PDS_DRIVER_LINUX   = 1,
+	PDS_DRIVER_WIN     = 2,
+	PDS_DRIVER_DPDK    = 3,
+	PDS_DRIVER_FREEBSD = 4,
+	PDS_DRIVER_IPXE    = 5,
+	PDS_DRIVER_ESXI    = 6,
+};
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
 #endif /* _PDS_COMMON_H_ */
diff --git a/include/linux/pds/pds_intr.h b/include/linux/pds/pds_intr.h
new file mode 100644
index 000000000000..56277c37248c
--- /dev/null
+++ b/include/linux/pds/pds_intr.h
@@ -0,0 +1,163 @@
+/* SPDX-License-Identifier: (GPL-2.0 OR Linux-OpenIB) OR BSD-2-Clause */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
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
+
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
+static inline void
+pds_core_intr_coal_init(struct pds_core_intr __iomem *intr_ctrl, u32 coal)
+{
+	iowrite32(coal, &intr_ctrl->coal_init);
+}
+
+static inline void
+pds_core_intr_mask(struct pds_core_intr __iomem *intr_ctrl, u32 mask)
+{
+	iowrite32(mask, &intr_ctrl->mask);
+}
+
+static inline void
+pds_core_intr_credits(struct pds_core_intr __iomem *intr_ctrl,
+		      u32 cred, u32 flags)
+{
+	if (WARN_ON_ONCE(cred > PDS_CORE_INTR_CRED_COUNT)) {
+		cred = ioread32(&intr_ctrl->credits);
+		cred &= PDS_CORE_INTR_CRED_COUNT_SIGNED;
+	}
+
+	iowrite32(cred | flags, &intr_ctrl->credits);
+}
+
+static inline void
+pds_core_intr_clean_flags(struct pds_core_intr __iomem *intr_ctrl, u32 flags)
+{
+	u32 cred;
+
+	cred = ioread32(&intr_ctrl->credits);
+	cred &= PDS_CORE_INTR_CRED_COUNT_SIGNED;
+	cred |= flags;
+	iowrite32(cred, &intr_ctrl->credits);
+}
+
+static inline void
+pds_core_intr_clean(struct pds_core_intr __iomem *intr_ctrl)
+{
+	pds_core_intr_clean_flags(intr_ctrl, PDS_CORE_INTR_CRED_RESET_COALESCE);
+}
+
+static inline void
+pds_core_intr_mask_assert(struct pds_core_intr __iomem *intr_ctrl, u32 mask)
+{
+	iowrite32(mask, &intr_ctrl->mask_on_assert);
+}
+
+#endif /* _PDS_INTR_H_ */
-- 
2.17.1


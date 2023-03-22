Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF806C5492
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 20:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230440AbjCVTLK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 15:11:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230191AbjCVTLG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 15:11:06 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2046.outbound.protection.outlook.com [40.107.94.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6917D59429
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 12:11:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQsjUkz+Gh2PnWo85F1X+qlXuSpuve6YmlsCzIxbB2qcOcS0zDVRLGw07E+zLSllqnQuTI2XeLe1Jl0t0wAxXNgJPZ817czEz68Ugg9WWEoH1URwVwtIvIiXB037fp+InW1TGyV2wtkn8nngeWRdZJTTNVkKP/j8bld6rxm1c+Rzy8LD/dFfNF1SFpyPToP7Rq1vQXBEy7THyKeRMdcHR5nlGt5Hhg1u4EPjcot3k+5IlcsUIH31lz5SGAoPVDUAfsqgZTLIyOYh6BQ1s33toQbhAXQISeLLn+ErGdD30Qq7bb3GMVXRFU7Wm+VMRYK4yfmiX5yXc6KqlZJz/mTwOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=chVEa0pW/5KqXfMLKL7x2LR6Dgk+iSHXRoqbgi5Tbk8=;
 b=HHdWTgQKpQ6dA+GSJG/Q+wRAzDv7qbcddI5FiISgn6tiuIufZHDDdJYvLoe+VXw45t6OqxCwj2wBo+b+tpCNZkr1QQ7K7G5LZ5+5Zcq76U8Q7Qn5asgCV3nbaLbLZzrreZQ3IaMa2vNJFH5c8IpvvcF28wxEmh6LxzyZrKADshYC4zSwq/tG3OAwKI/9xAaAytmi+VNLIEyQfxcCTNjUQeghtHh3odKheYMLKT2DdUNNEOcy9gBUIQ5h6ZLWGdo/KCjytJHqUH7yHZjbhl/ncqV5Z56btqK6RerpuMp1IBiEkWFiZOwyz2nC5/HC0FNl87jHHP8zcx9eT5/RPUo5XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chVEa0pW/5KqXfMLKL7x2LR6Dgk+iSHXRoqbgi5Tbk8=;
 b=VyRnlWvUySkQuPxGPoVuy4lcAOGnBlrZvai7vDIHpBa6CAUXN1GE3qeXnstH2W4GvCzxjgSOFEDpq/2FJWrliYiurOC0lKwwRcxOffMgFIo1O3EM7Cn+kkednfceV//Yb3Nu+88BgOwAGGGufi3+XjvQ5IA+0qG5re3GO9kqobo=
Received: from DS7PR03CA0296.namprd03.prod.outlook.com (2603:10b6:5:3ad::31)
 by CH0PR12MB5169.namprd12.prod.outlook.com (2603:10b6:610:b8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Wed, 22 Mar
 2023 19:11:01 +0000
Received: from DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:3ad:cafe::a1) by DS7PR03CA0296.outlook.office365.com
 (2603:10b6:5:3ad::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37 via Frontend
 Transport; Wed, 22 Mar 2023 19:11:01 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT004.mail.protection.outlook.com (10.13.172.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.17 via Frontend Transport; Wed, 22 Mar 2023 19:11:01 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 22 Mar
 2023 14:10:57 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <jasowang@redhat.com>, <mst@redhat.com>,
        <virtualization@lists.linux-foundation.org>,
        <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>
Subject: [PATCH v3 virtio 5/8] pds_vdpa: add vdpa config client commands
Date:   Wed, 22 Mar 2023 12:10:35 -0700
Message-ID: <20230322191038.44037-6-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: DM6NAM11FT004:EE_|CH0PR12MB5169:EE_
X-MS-Office365-Filtering-Correlation-Id: ca532e54-b2b3-436d-2916-08db2b092d32
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hdhVuAXwYtWxX8nT2/4V21BLmSFfHmmbJKp5sIPMMNaROlWqPPqLMC/jvBch7+3dU/+hnW9y2oCM4tjwWXxhzWyhWv9ozht4KtbQD55Xsx1herR4MWioes+pCMKUCfR4y0tGcYbLvS/KjbvYwhsKV1JqelkAZB4k+M7/lcMbHyCVDrDU1H5NtqLB8YCcnNjgd6zdiJFtxAYl18OHi5Etc2Yzptp3SLVd9f0sG3xeNRphqCFdT1q/czWMl4LzYnYTFmnqdTWu1uUrrUyLnHxAiERUP4AHjzgiOhEgwMcZ+Z0tBSHaDUPD/2Xcv6RuUPghLsT31e9HcKVV/BAjJb6W2uVjmu7XCNCR48FgeopEUINMptC21t2zM1trEJvBeFSfT+38LUo/r+k2BQtJc42P5P8ooOgtyUUwyLTDnEtHfc4Bw24dY7ltPYk+0hzox9RhH54AnbHxph54qPHa6+7lFr0K5wN7ghomAbVMNYOfnq0tu3+Fj3rTv7NljhTy2TcBH8Wi1ZH9LTjMRPHUKAUL1E26ob8ro1FVfEavjXUV00a1UqWw3kg+hghQNV1hhLDtOp4mIlQYk/NlD3g39F5tkzs4MaipqINbSgEBBSirBHYQ69do9cmxotSdEzhmDaBwh4rHzMJkAeed2QDtya8RB8/0SF/ZiEJnc7Ux4PONjLr9fWeXe+nOeiXRiKXZyh0m3lcbLCuY47AoRh6UM+0GYGFX+6kSMPq5qIDMomcpgOY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(376002)(39860400002)(451199018)(46966006)(40470700004)(36840700001)(316002)(6666004)(81166007)(4326008)(8676002)(70206006)(110136005)(478600001)(70586007)(336012)(47076005)(82740400003)(426003)(2906002)(2616005)(41300700001)(186003)(40460700003)(26005)(86362001)(16526019)(356005)(36860700001)(8936002)(83380400001)(36756003)(40480700001)(5660300002)(44832011)(30864003)(1076003)(82310400005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Mar 2023 19:11:01.4456
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: ca532e54-b2b3-436d-2916-08db2b092d32
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT004.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5169
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These are the adminq commands that will be needed for
setting up and using the vDPA device.  There are a number
of commands defined in the FW's API, but by making use of
the FW's virtio BAR we only need a few of these commands
for vDPA support.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vdpa/pds/Makefile    |   1 +
 drivers/vdpa/pds/cmds.c      | 178 +++++++++++++++++++++++++++++++++++
 drivers/vdpa/pds/cmds.h      |  16 ++++
 drivers/vdpa/pds/vdpa_dev.h  |  33 ++++++-
 include/linux/pds/pds_vdpa.h | 175 ++++++++++++++++++++++++++++++++++
 5 files changed, 402 insertions(+), 1 deletion(-)
 create mode 100644 drivers/vdpa/pds/cmds.c
 create mode 100644 drivers/vdpa/pds/cmds.h

diff --git a/drivers/vdpa/pds/Makefile b/drivers/vdpa/pds/Makefile
index 13b50394ec64..2e22418e3ab3 100644
--- a/drivers/vdpa/pds/Makefile
+++ b/drivers/vdpa/pds/Makefile
@@ -4,6 +4,7 @@
 obj-$(CONFIG_PDS_VDPA) := pds_vdpa.o
 
 pds_vdpa-y := aux_drv.o \
+	      cmds.o \
 	      vdpa_dev.o
 
 pds_vdpa-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/vdpa/pds/cmds.c b/drivers/vdpa/pds/cmds.c
new file mode 100644
index 000000000000..b847d708e4cc
--- /dev/null
+++ b/drivers/vdpa/pds/cmds.c
@@ -0,0 +1,178 @@
+// SPDX-License-Identifier: GPL-2.0-only
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/vdpa.h>
+#include <linux/virtio_pci_modern.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+#include <linux/pds/pds_auxbus.h>
+#include <linux/pds/pds_vdpa.h>
+
+#include "vdpa_dev.h"
+#include "aux_drv.h"
+#include "cmds.h"
+
+int pds_vdpa_init_hw(struct pds_vdpa_device *pdsv)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_init_cmd init_cmd = {
+		.opcode = PDS_VDPA_CMD_INIT,
+		.vdpa_index = pdsv->vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+	};
+	struct pds_vdpa_comp init_comp = {0};
+	int err;
+
+	/* Initialize the vdpa/virtio device */
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&init_cmd,
+				     sizeof(init_cmd),
+				     (union pds_core_adminq_comp *)&init_comp,
+				     0);
+	if (err)
+		dev_dbg(dev, "Failed to init hw, status %d: %pe\n",
+			init_comp.status, ERR_PTR(err));
+
+	return err;
+}
+
+int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_RESET,
+		.vdpa_index = pdsv->vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err)
+		dev_dbg(dev, "Failed to reset hw, status %d: %pe\n",
+			comp.status, ERR_PTR(err));
+
+	return err;
+}
+
+int pds_vdpa_cmd_set_mac(struct pds_vdpa_device *pdsv, u8 *mac)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_setattr_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_SET_ATTR,
+		.vdpa_index = pdsv->vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.attr = PDS_VDPA_ATTR_MAC,
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	ether_addr_copy(cmd.mac, mac);
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err)
+		dev_dbg(dev, "Failed to set mac address %pM, status %d: %pe\n",
+			mac, comp.status, ERR_PTR(err));
+
+	return err;
+}
+
+int pds_vdpa_cmd_set_max_vq_pairs(struct pds_vdpa_device *pdsv, u16 max_vqp)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_setattr_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_SET_ATTR,
+		.vdpa_index = pdsv->vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.attr = PDS_VDPA_ATTR_MAX_VQ_PAIRS,
+		.max_vq_pairs = cpu_to_le16(max_vqp),
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err)
+		dev_dbg(dev, "Failed to set max vq pairs %u, status %d: %pe\n",
+			max_vqp, comp.status, ERR_PTR(err));
+
+	return err;
+}
+
+int pds_vdpa_cmd_init_vq(struct pds_vdpa_device *pdsv, u16 qid,
+			 struct pds_vdpa_vq_info *vq_info)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_vq_init_comp comp = {0};
+	struct pds_vdpa_vq_init_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_VQ_INIT,
+		.vdpa_index = pdsv->vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.qid = cpu_to_le16(qid),
+		.len = cpu_to_le16(ilog2(vq_info->q_len)),
+		.desc_addr = cpu_to_le64(vq_info->desc_addr),
+		.avail_addr = cpu_to_le64(vq_info->avail_addr),
+		.used_addr = cpu_to_le64(vq_info->used_addr),
+		.intr_index = cpu_to_le16(qid),
+	};
+	int err;
+
+	dev_dbg(dev, "%s: qid %d len %d desc_addr %#llx avail_addr %#llx used_addr %#llx\n",
+		__func__, qid, ilog2(vq_info->q_len),
+		vq_info->desc_addr, vq_info->avail_addr, vq_info->used_addr);
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err) {
+		dev_dbg(dev, "Failed to init vq %d, status %d: %pe\n",
+			qid, comp.status, ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+
+int pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	struct pds_vdpa_vq_reset_cmd cmd = {
+		.opcode = PDS_VDPA_CMD_VQ_RESET,
+		.vdpa_index = pdsv->vdpa_index,
+		.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.qid = cpu_to_le16(qid),
+	};
+	struct pds_vdpa_comp comp = {0};
+	int err;
+
+	err = padev->ops->adminq_cmd(padev,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+	if (err)
+		dev_dbg(dev, "Failed to reset vq %d, status %d: %pe\n",
+			qid, comp.status, ERR_PTR(err));
+
+	return err;
+}
diff --git a/drivers/vdpa/pds/cmds.h b/drivers/vdpa/pds/cmds.h
new file mode 100644
index 000000000000..72e19f4efde6
--- /dev/null
+++ b/drivers/vdpa/pds/cmds.h
@@ -0,0 +1,16 @@
+/* SPDX-License-Identifier: GPL-2.0-only */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _VDPA_CMDS_H_
+#define _VDPA_CMDS_H_
+
+int pds_vdpa_init_hw(struct pds_vdpa_device *pdsv);
+
+int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv);
+int pds_vdpa_cmd_set_mac(struct pds_vdpa_device *pdsv, u8 *mac);
+int pds_vdpa_cmd_set_max_vq_pairs(struct pds_vdpa_device *pdsv, u16 max_vqp);
+int pds_vdpa_cmd_init_vq(struct pds_vdpa_device *pdsv, u16 qid,
+			 struct pds_vdpa_vq_info *vq_info);
+int pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid);
+int pds_vdpa_cmd_set_features(struct pds_vdpa_device *pdsv, u64 features);
+#endif /* _VDPA_CMDS_H_ */
diff --git a/drivers/vdpa/pds/vdpa_dev.h b/drivers/vdpa/pds/vdpa_dev.h
index 97fab833a0aa..a21596f438c1 100644
--- a/drivers/vdpa/pds/vdpa_dev.h
+++ b/drivers/vdpa/pds/vdpa_dev.h
@@ -4,11 +4,42 @@
 #ifndef _VDPA_DEV_H_
 #define _VDPA_DEV_H_
 
-#define PDS_VDPA_MAX_QUEUES	65
+#include <linux/pci.h>
+#include <linux/vdpa.h>
+
+struct pds_vdpa_vq_info {
+	bool ready;
+	u64 desc_addr;
+	u64 avail_addr;
+	u64 used_addr;
+	u32 q_len;
+	u16 qid;
+	int irq;
+	char irq_name[32];
+
+	void __iomem *notify;
+	dma_addr_t notify_pa;
+
+	u64 doorbell;
+	u16 avail_idx;
+	u16 used_idx;
 
+	struct vdpa_callback event_cb;
+	struct pds_vdpa_device *pdsv;
+};
+
+#define PDS_VDPA_MAX_QUEUES	65
+#define PDS_VDPA_MAX_QLEN	32768
 struct pds_vdpa_device {
 	struct vdpa_device vdpa_dev;
 	struct pds_vdpa_aux *vdpa_aux;
+
+	struct pds_vdpa_vq_info vqs[PDS_VDPA_MAX_QUEUES];
+	u64 req_features;		/* features requested by vdpa */
+	u64 actual_features;		/* features negotiated and in use */
+	u8 vdpa_index;			/* rsvd for future subdevice use */
+	u8 num_vqs;			/* num vqs in use */
+	struct vdpa_callback config_cb;
 };
 
 int pds_vdpa_get_mgmt_info(struct pds_vdpa_aux *vdpa_aux);
diff --git a/include/linux/pds/pds_vdpa.h b/include/linux/pds/pds_vdpa.h
index c1d6a3fe2d61..785909a6daf6 100644
--- a/include/linux/pds/pds_vdpa.h
+++ b/include/linux/pds/pds_vdpa.h
@@ -97,4 +97,179 @@ struct pds_vdpa_ident_cmd {
 	__le32 len;
 	__le64 ident_pa;
 };
+
+/**
+ * struct pds_vdpa_status_cmd - STATUS_UPDATE command
+ * @opcode:	Opcode PDS_VDPA_CMD_STATUS_UPDATE
+ * @vdpa_index: Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @status:	new status bits
+ */
+struct pds_vdpa_status_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	u8     status;
+};
+
+/**
+ * enum pds_vdpa_attr - List of VDPA device attributes
+ * @PDS_VDPA_ATTR_MAC:          MAC address
+ * @PDS_VDPA_ATTR_MAX_VQ_PAIRS: Max virtqueue pairs
+ */
+enum pds_vdpa_attr {
+	PDS_VDPA_ATTR_MAC          = 1,
+	PDS_VDPA_ATTR_MAX_VQ_PAIRS = 2,
+};
+
+/**
+ * struct pds_vdpa_setattr_cmd - SET_ATTR command
+ * @opcode:		Opcode PDS_VDPA_CMD_SET_ATTR
+ * @vdpa_index:		Index for vdpa subdevice
+ * @vf_id:		VF id
+ * @attr:		attribute to be changed (enum pds_vdpa_attr)
+ * @pad:		Word boundary padding
+ * @mac:		new mac address to be assigned as vdpa device address
+ * @max_vq_pairs:	new limit of virtqueue pairs
+ */
+struct pds_vdpa_setattr_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	u8     attr;
+	u8     pad[3];
+	union {
+		u8 mac[6];
+		__le16 max_vq_pairs;
+	} __packed;
+};
+
+/**
+ * struct pds_vdpa_vq_init_cmd - queue init command
+ * @opcode: Opcode PDS_VDPA_CMD_VQ_INIT
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @qid:	Queue id (bit0 clear = rx, bit0 set = tx, qid=N is ctrlq)
+ * @len:	log(2) of max descriptor count
+ * @desc_addr:	DMA address of descriptor area
+ * @avail_addr:	DMA address of available descriptors (aka driver area)
+ * @used_addr:	DMA address of used descriptors (aka device area)
+ * @intr_index:	interrupt index
+ */
+struct pds_vdpa_vq_init_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le16 qid;
+	__le16 len;
+	__le64 desc_addr;
+	__le64 avail_addr;
+	__le64 used_addr;
+	__le16 intr_index;
+};
+
+/**
+ * struct pds_vdpa_vq_init_comp - queue init completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @hw_qtype:	HW queue type, used in doorbell selection
+ * @hw_qindex:	HW queue index, used in doorbell selection
+ * @rsvd:	Word boundary padding
+ * @color:	Color bit
+ */
+struct pds_vdpa_vq_init_comp {
+	u8     status;
+	u8     hw_qtype;
+	__le16 hw_qindex;
+	u8     rsvd[11];
+	u8     color;
+};
+
+/**
+ * struct pds_vdpa_vq_reset_cmd - queue reset command
+ * @opcode:	Opcode PDS_VDPA_CMD_VQ_RESET
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @qid:	Queue id
+ */
+struct pds_vdpa_vq_reset_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le16 qid;
+};
+
+/**
+ * struct pds_vdpa_set_features_cmd - set hw features
+ * @opcode: Opcode PDS_VDPA_CMD_SET_FEATURES
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @rsvd:       Word boundary padding
+ * @features:	Feature bit mask
+ */
+struct pds_vdpa_set_features_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le32 rsvd;
+	__le64 features;
+};
+
+/**
+ * struct pds_vdpa_vq_set_state_cmd - set vq state
+ * @opcode:	Opcode PDS_VDPA_CMD_VQ_SET_STATE
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @qid:	Queue id
+ * @avail:	Device avail index.
+ * @used:	Device used index.
+ *
+ * If the virtqueue uses packed descriptor format, then the avail and used
+ * index must have a wrap count.  The bits should be arranged like the upper
+ * 16 bits in the device available notification data: 15 bit index, 1 bit wrap.
+ */
+struct pds_vdpa_vq_set_state_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le16 qid;
+	__le16 avail;
+	__le16 used;
+};
+
+/**
+ * struct pds_vdpa_vq_get_state_cmd - get vq state
+ * @opcode:	Opcode PDS_VDPA_CMD_VQ_GET_STATE
+ * @vdpa_index:	Index for vdpa subdevice
+ * @vf_id:	VF id
+ * @qid:	Queue id
+ */
+struct pds_vdpa_vq_get_state_cmd {
+	u8     opcode;
+	u8     vdpa_index;
+	__le16 vf_id;
+	__le16 qid;
+};
+
+/**
+ * struct pds_vdpa_vq_get_state_comp - get vq state completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd0:      Word boundary padding
+ * @avail:	Device avail index.
+ * @used:	Device used index.
+ * @rsvd:       Word boundary padding
+ * @color:	Color bit
+ *
+ * If the virtqueue uses packed descriptor format, then the avail and used
+ * index will have a wrap count.  The bits will be arranged like the "next"
+ * part of device available notification data: 15 bit index, 1 bit wrap.
+ */
+struct pds_vdpa_vq_get_state_comp {
+	u8     status;
+	u8     rsvd0;
+	__le16 avail;
+	__le16 used;
+	u8     rsvd[9];
+	u8     color;
+};
+
 #endif /* _PDS_VDPA_H_ */
-- 
2.17.1


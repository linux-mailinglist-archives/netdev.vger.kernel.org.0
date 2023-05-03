Return-Path: <netdev+bounces-204-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB8756F5DB7
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 20:16:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1A3671C20F93
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 18:15:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B854DF45;
	Wed,  3 May 2023 18:13:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF012773B
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 18:13:13 +0000 (UTC)
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2065.outbound.protection.outlook.com [40.107.212.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16AF1272C
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 11:13:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Js0AOWv9gU/hlxCuaOCTf4AysWFNs3RYVMoVBp/ZtA8t0foZBJZa7RkBlyBF9ADXmIzAl65M84q516znfTG126OrlahsHDWfYfy4RRxpfy5+T8dOgQDi/u0c6oRGJfnJv/1mdUCOSVEB66Gi22t7H7Wyg5JfPUy7ZW6PXxayqisexGpcemY+RAp282DAxcVvpg3CBlI5QLLi760LLLRLsGm2L2anjAwA+ivoaDcn/mNf3tjtV8FWtw6J2p7hISP9YY6dRL7RiTWwriY2bJGEp19iyuid12nh8Z2HRdz5jnHPunta1CfSMl3KQb8+CWDaruwNu+NeinXXxoZb5dWe9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PjzdWXpVKbGNv1DIOZ7CcwHtYKAlLbSfzErEWBCZw04=;
 b=Z9xHTjYjhkC2HcXahV5hmYfacoi4SfBKCWPoq7HHUoMsfS3RppkkjVRUs6n2sRL1G+FZ27pLNhLoK54XHIqqk4DP+M18F9W0lfbRUiPjh70zQZGmKhMEQALxEilj3CqHq2zGcyYUqeI5aScZ7r2CKVYGUu+YsJhzGTBzGfXlsek8bo/lb3PNplB0cmxU8Srzs1Ue2ptgK1FJGK7UnNHXw9J4uveWkZxaqnmXvtX57fppglvLMLdxRfdtZQTimzVsND7HTbJ2/DPcrrLKHq9lb5t09ZcdTwSnSOgzPg49h/4IcVjLnsMbJYIAvkgFKwYx/EyzeZMM+IxtWPaQAZ7rkg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=redhat.com smtp.mailfrom=amd.com; dmarc=pass
 (p=quarantine sp=quarantine pct=100) action=none header.from=amd.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PjzdWXpVKbGNv1DIOZ7CcwHtYKAlLbSfzErEWBCZw04=;
 b=UR4eb1rskCPpqVlFZ0a0j5CNnJAQhHQmFgBZVrxzD8yo/MROyJCaiAioTx3ZRRjrQbOYaVZOP8gRN91cMwDUBYZTQLvmBPHVw8oAwN4M7w4YZgzJr9CVHCEc5C0kyEyUf4xRT34MR8ErkJDuydJNWuJngv5z9XWvIllXxMRH2yw=
Received: from DM6PR03CA0068.namprd03.prod.outlook.com (2603:10b6:5:100::45)
 by IA1PR12MB8360.namprd12.prod.outlook.com (2603:10b6:208:3d8::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.30; Wed, 3 May
 2023 18:13:06 +0000
Received: from DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:100:cafe::9e) by DM6PR03CA0068.outlook.office365.com
 (2603:10b6:5:100::45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6363.22 via Frontend
 Transport; Wed, 3 May 2023 18:13:06 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT109.mail.protection.outlook.com (10.13.173.178) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6363.22 via Frontend Transport; Wed, 3 May 2023 18:13:06 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 3 May
 2023 13:13:04 -0500
From: Shannon Nelson <shannon.nelson@amd.com>
To: <jasowang@redhat.com>, <mst@redhat.com>,
	<virtualization@lists.linux-foundation.org>, <shannon.nelson@amd.com>,
	<brett.creeley@amd.com>, <netdev@vger.kernel.org>
CC: <simon.horman@corigine.com>, <drivers@pensando.io>
Subject: [PATCH v5 virtio 08/11] pds_vdpa: add vdpa config client commands
Date: Wed, 3 May 2023 11:12:37 -0700
Message-ID: <20230503181240.14009-9-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230503181240.14009-1-shannon.nelson@amd.com>
References: <20230503181240.14009-1-shannon.nelson@amd.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT109:EE_|IA1PR12MB8360:EE_
X-MS-Office365-Filtering-Correlation-Id: 478baa25-bbc5-4e69-71da-08db4c020b61
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	XD6wzWhEclDQVMj0I40MATKjBARk3cRhmDhTrDYo2JgjN89Pw8E83omVGNMisCEbV9WbQKTJdOreJEkUh11RorM49rdacjEOTrhHQPjDZneIdWmlhdQlt4mps+Rzc9p56Rfg2MDswImiJ8DtpOxikHUtOkvYON34yY5/gTUpfrfnz6ck+pwvthVXmenRhF6I9RQM5dFD3nU990zfLmhQXJUGum8mo9MTA7JasL4bza9J1t21xirWsYAhmmL22BnWP7ALHP5NXdjiReMR7FWKrHqS2wUncO9/jz3HiuiJ27KqLf8+slemzWqGLbKubwGL12TQkFfUJy4Hch5aNoY3e5aOPkVZ9nD16hu0COX3LKzLYzIYKyiWBnlTqyeqW8u8EU7Q9lm4+rLoKNAK29UuFagcuIS3PttsG4G8wXbtUS/83TfL7CVc2kU4jQqvvk7JEYASOB7aXVNxCJOMmO+x7GtcInV57VeNmCPMEITR5pWrbDw2oUotJlRJwtpsrbNbnQk17QSD9SQwIaltMezDUoBCgdBMzpUOwZ5YQd5N+0cCELG1Wj8u9bQUEY4L0C66Jd1cAEX/cMOvLOXz356erO5DQyYbbR6MHwOo2akqfYF3Z4CCSHW5/YCD5DY6w3CM9vNo6Okqq3K7BLUZVQyK1jL2QuinYAaDtVwFyLcyTeSYxM7B0RYRHoSUy0YfRhq/D87beXWuEdjKLg820lTU6aJMHSqHs8pU5PHbGLYbeBc=
X-Forefront-Antispam-Report:
	CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(39860400002)(376002)(396003)(136003)(451199021)(46966006)(40470700004)(36840700001)(2906002)(70586007)(70206006)(44832011)(86362001)(336012)(2616005)(5660300002)(82310400005)(4326008)(8936002)(478600001)(8676002)(6666004)(40460700003)(40480700001)(41300700001)(36756003)(54906003)(316002)(110136005)(82740400003)(186003)(81166007)(26005)(16526019)(356005)(83380400001)(47076005)(36860700001)(1076003)(426003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 May 2023 18:13:06.6857
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 478baa25-bbc5-4e69-71da-08db4c020b61
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource:
	DM6NAM11FT109.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8360
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

These are the adminq commands that will be needed for
setting up and using the vDPA device.  There are a number
of commands defined in the FW's API, but by making use of
the FW's virtio BAR we only need a few of these commands
for vDPA support.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vdpa/pds/Makefile   |   1 +
 drivers/vdpa/pds/cmds.c     | 207 ++++++++++++++++++++++++++++++++++++
 drivers/vdpa/pds/cmds.h     |  20 ++++
 drivers/vdpa/pds/vdpa_dev.h |  33 +++++-
 4 files changed, 260 insertions(+), 1 deletion(-)
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
index 000000000000..405711a0a0f8
--- /dev/null
+++ b/drivers/vdpa/pds/cmds.c
@@ -0,0 +1,207 @@
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
+
+#include "vdpa_dev.h"
+#include "aux_drv.h"
+#include "cmds.h"
+
+int pds_vdpa_init_hw(struct pds_vdpa_device *pdsv)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	union pds_core_adminq_cmd cmd = {
+		.vdpa_init.opcode = PDS_VDPA_CMD_INIT,
+		.vdpa_init.vdpa_index = pdsv->vdpa_index,
+		.vdpa_init.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+	};
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	/* Initialize the vdpa/virtio device */
+	err = pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_init),
+				    &comp, 0);
+	if (err)
+		dev_dbg(dev, "Failed to init hw, status %d: %pe\n",
+			comp.status, ERR_PTR(err));
+
+	return err;
+}
+
+int pds_vdpa_cmd_reset(struct pds_vdpa_device *pdsv)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	union pds_core_adminq_cmd cmd = {
+		.vdpa.opcode = PDS_VDPA_CMD_RESET,
+		.vdpa.vdpa_index = pdsv->vdpa_index,
+		.vdpa.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+	};
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	err = pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa), &comp, 0);
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
+	union pds_core_adminq_cmd cmd = {
+		.vdpa_setattr.opcode = PDS_VDPA_CMD_SET_ATTR,
+		.vdpa_setattr.vdpa_index = pdsv->vdpa_index,
+		.vdpa_setattr.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.vdpa_setattr.attr = PDS_VDPA_ATTR_MAC,
+	};
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	ether_addr_copy(cmd.vdpa_setattr.mac, mac);
+	err = pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_setattr),
+				    &comp, 0);
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
+	union pds_core_adminq_cmd cmd = {
+		.vdpa_setattr.opcode = PDS_VDPA_CMD_SET_ATTR,
+		.vdpa_setattr.vdpa_index = pdsv->vdpa_index,
+		.vdpa_setattr.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.vdpa_setattr.attr = PDS_VDPA_ATTR_MAX_VQ_PAIRS,
+		.vdpa_setattr.max_vq_pairs = cpu_to_le16(max_vqp),
+	};
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	err = pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_setattr),
+				    &comp, 0);
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
+	union pds_core_adminq_cmd cmd = {
+		.vdpa_vq_init.opcode = PDS_VDPA_CMD_VQ_INIT,
+		.vdpa_vq_init.vdpa_index = pdsv->vdpa_index,
+		.vdpa_vq_init.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.vdpa_vq_init.qid = cpu_to_le16(qid),
+		.vdpa_vq_init.len = cpu_to_le16(ilog2(vq_info->q_len)),
+		.vdpa_vq_init.desc_addr = cpu_to_le64(vq_info->desc_addr),
+		.vdpa_vq_init.avail_addr = cpu_to_le64(vq_info->avail_addr),
+		.vdpa_vq_init.used_addr = cpu_to_le64(vq_info->used_addr),
+		.vdpa_vq_init.intr_index = cpu_to_le16(qid),
+	};
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	dev_dbg(dev, "%s: qid %d len %d desc_addr %#llx avail_addr %#llx used_addr %#llx\n",
+		__func__, qid, ilog2(vq_info->q_len),
+		vq_info->desc_addr, vq_info->avail_addr, vq_info->used_addr);
+
+	err = pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_vq_init),
+				    &comp, 0);
+	if (err)
+		dev_dbg(dev, "Failed to init vq %d, status %d: %pe\n",
+			qid, comp.status, ERR_PTR(err));
+
+	return err;
+}
+
+int pds_vdpa_cmd_reset_vq(struct pds_vdpa_device *pdsv, u16 qid)
+{
+	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	union pds_core_adminq_cmd cmd = {
+		.vdpa_vq_reset.opcode = PDS_VDPA_CMD_VQ_RESET,
+		.vdpa_vq_reset.vdpa_index = pdsv->vdpa_index,
+		.vdpa_vq_reset.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.vdpa_vq_reset.qid = cpu_to_le16(qid),
+	};
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	err = pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_vq_reset),
+				    &comp, 0);
+	if (err)
+		dev_dbg(dev, "Failed to reset vq %d, status %d: %pe\n",
+			qid, comp.status, ERR_PTR(err));
+
+	return err;
+}
+
+int pds_vdpa_cmd_set_vq_state(struct pds_vdpa_device *pdsv,
+			      u16 qid, u16 avail, u16 used)
+{	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	union pds_core_adminq_cmd cmd = {
+		.vdpa_vq_set_state.opcode = PDS_VDPA_CMD_VQ_SET_STATE,
+		.vdpa_vq_set_state.vdpa_index = pdsv->vdpa_index,
+		.vdpa_vq_set_state.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.vdpa_vq_set_state.qid = cpu_to_le16(qid),
+		.vdpa_vq_set_state.avail = cpu_to_le16(avail),
+		.vdpa_vq_set_state.used = cpu_to_le16(used),
+	};
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	err = pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_vq_set_state),
+				    &comp, 0);
+	if (err)
+		dev_dbg(dev, "Failed to set state vq %d, status %d: %pe\n",
+			qid, comp.status, ERR_PTR(err));
+
+	return err;
+}
+
+int pds_vdpa_cmd_get_vq_state(struct pds_vdpa_device *pdsv,
+			      u16 qid, u16 *avail, u16 *used)
+{	struct pds_auxiliary_dev *padev = pdsv->vdpa_aux->padev;
+	struct device *dev = &padev->aux_dev.dev;
+	union pds_core_adminq_cmd cmd = {
+		.vdpa_vq_get_state.opcode = PDS_VDPA_CMD_VQ_SET_STATE,
+		.vdpa_vq_get_state.vdpa_index = pdsv->vdpa_index,
+		.vdpa_vq_get_state.vf_id = cpu_to_le16(pdsv->vdpa_aux->vf_id),
+		.vdpa_vq_get_state.qid = cpu_to_le16(qid),
+	};
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	err = pds_client_adminq_cmd(padev, &cmd, sizeof(cmd.vdpa_vq_set_state),
+				    &comp, 0);
+	if (err) {
+		dev_dbg(dev, "Failed to set state vq %d, status %d: %pe\n",
+			qid, comp.status, ERR_PTR(err));
+		return err;
+	}
+
+	*avail = le16_to_cpu(comp.vdpa_vq_get_state.avail);
+	*used = le16_to_cpu(comp.vdpa_vq_get_state.used);
+
+	return 0;
+}
diff --git a/drivers/vdpa/pds/cmds.h b/drivers/vdpa/pds/cmds.h
new file mode 100644
index 000000000000..cf4f8764e73c
--- /dev/null
+++ b/drivers/vdpa/pds/cmds.h
@@ -0,0 +1,20 @@
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
+int pds_vdpa_cmd_set_vq_state(struct pds_vdpa_device *pdsv,
+			      u16 qid, u16 avail, u16 used);
+int pds_vdpa_cmd_get_vq_state(struct pds_vdpa_device *pdsv,
+			      u16 qid, u16 *avail, u16 *used);
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
-- 
2.17.1



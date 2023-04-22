Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9486EB69A
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 03:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbjDVBHl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 21:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234137AbjDVBHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 21:07:36 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2050.outbound.protection.outlook.com [40.107.212.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7B826AF;
        Fri, 21 Apr 2023 18:07:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mS5/pymlrV5fECkLXE+I9+k5WUAKfBWfBW8GRudPSvYxXFxsWsZb87+QRun6k+8496mnUl/sppv0PCq6BwXBfRzsP5O1FxIlCpgnKY71hqyaumYzW0/ANw6ot0xhSP5ot2sCdbTDesnnG9mZNEzczu/TV44MY7NmV1O79xp6cfgP+n2V7E3X3v6ACfl4V/fwcytAZCtTRWP4qTbspb1FwRwi4NK4hKuTv6NbvGrxWaDcCFc96ZJl1ojIYb7OnBoSAfPv0EW0QSBDJDIgDpwrvMxyzJMlwk4g5UakLIjlIyvZgPc3GIvR8WfzicdJbNX6y0ACFKqngo+Kk46rQR45Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8ZrzHsXhhIXLyC7BkmzYu6BUFYS09U6hqyk2pOXBens=;
 b=PJogCvSj98rNCcOLqKez7ZGRAVyy7XnpL3wFzL+RNxg2aJjgdgGP+6kuuo5ZtvQLvOREUnehu3rH/J1dzwPn/RTGW6tbGw54ONLnP7sPTGeCGqr4SOOnvWgCpBe6Bu7DcL0K+ai+zgI+bXc7jM/OClhQSM1bOZRszMuYHD31NoaNPw/dasipqTkYVmpjTC1ADucHvSMXcWN4tU4uBIR0XCbvd7JjV9N4nzNgtVG9hPx2MWovb2gq2MyPpdczgT/J87m0Sce2Wluw8gRPkHa0ZpdCUD2/bUuU1Lifp7oVCIkhtKbCyTyxZxh66qF9BALvTZldtPBolGYChEyVIx0UgA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8ZrzHsXhhIXLyC7BkmzYu6BUFYS09U6hqyk2pOXBens=;
 b=PVuiyh5rOI1NiSz7nxkHNtZBXyJBtLZxBaURj/lvSMOTOKpvG6eTTp+NlrYIhNBT6A3CurmwH7j8kcI5hu0yWVFXMXlaXRkOJGsiKXoS+asoU+GTFlh5vJBbRPbekzr0xUnevWPOBeV3+thS6MnjxOLyoAoeC/hCs1x235eciMc=
Received: from BN8PR07CA0003.namprd07.prod.outlook.com (2603:10b6:408:ac::16)
 by CY8PR12MB8411.namprd12.prod.outlook.com (2603:10b6:930:6e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Sat, 22 Apr
 2023 01:07:18 +0000
Received: from BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:ac:cafe::76) by BN8PR07CA0003.outlook.office365.com
 (2603:10b6:408:ac::16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.25 via Frontend
 Transport; Sat, 22 Apr 2023 01:07:17 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT038.mail.protection.outlook.com (10.13.176.246) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6340.15 via Frontend Transport; Sat, 22 Apr 2023 01:07:17 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 20:07:15 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [PATCH v9 vfio 5/7] vfio/pds: Add support for dirty page tracking
Date:   Fri, 21 Apr 2023 18:06:40 -0700
Message-ID: <20230422010642.60720-6-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230422010642.60720-1-brett.creeley@amd.com>
References: <20230422010642.60720-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT038:EE_|CY8PR12MB8411:EE_
X-MS-Office365-Filtering-Correlation-Id: 0a2b035e-653e-483d-84ae-08db42cdeaad
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XMy+hitrkImJw/RwhfmU6vNG8ls/zlaAkUAV9hp3U5iPFqham9HFlerBTuRdmayZXVmR/59RDi69aevDw4aHSs2U02xmdl5dhAcmTUBZftJTj1qVk/DXpha2M1SHJTMLLJ6wdm0/B9BqrUT7/IgywvWWR68OEdpDeVzRra9hMCdQffQ2xO45I1MhZ9iCZbNFWh9Xwo+KdfMFXvOMReQRzAqRMtge/GsXxG93T8OqUkSXMntXshn+RDgLGU7wYETsCUrXhBLkT28zREpkzZIvl3Rf3+xNjw/KoXvwww7MSTUJVN5uDuI1NUb4X+Pmp8J2R+yzT40beqKnOgA7xT7HrLZ8RY2sm2fmTR3Z5D7Q59XFFyx+UWyeaSmguDcRxERrUbymtoCIHnERKFTZHezBDNTCKVNb8HSZ9claU9MN58GxIpvb5WEsCj8V0BfGglhJF9b5B/YIYTKkaPAaV2bx0u9rFRNj0hawbcxh6eZ05yEZy5pVmB2YodaTe0f50VdRf4IBHHOgpVoChVhLuiLd2yD38CYBpo31FfHSEbqMLEPOLRpj60cn3IvgB81y70iVln/e+yqEWMpGadZOXY6EuC5Mg6Hhr5CAW0+fgvvUYvrt4qc5OxVxqihCnjmwz6/EjBYXS03EGXASGtE6qgTiuOBlWbvzDr4ZklzMDlgDOQyKU4TD7Fy26BmnBhE+x5ty8uCH5ZjeQZ19ylpDrzOSVSGM5GS5topHQzuF/hibdtYh/B/cdrgsuyjGh8RH8MEWs2Dklfw9LhfURu+aVBa+3g==
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(376002)(396003)(39860400002)(451199021)(36840700001)(40470700004)(46966006)(81166007)(2906002)(30864003)(356005)(40460700003)(41300700001)(5660300002)(44832011)(8936002)(8676002)(36756003)(86362001)(40480700001)(6666004)(26005)(1076003)(83380400001)(54906003)(82310400005)(2616005)(478600001)(36860700001)(47076005)(336012)(426003)(186003)(16526019)(316002)(4326008)(82740400003)(70586007)(110136005)(70206006)(14143004)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 01:07:17.5557
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a2b035e-653e-483d-84ae-08db42cdeaad
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8411
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

In order to support dirty page tracking, the driver has to implement
the VFIO subsystem's vfio_log_ops. This includes log_start, log_stop,
and log_read_and_clear.

All of the tracker resources are allocated and dirty tracking on the
device is started during log_start. The resources are cleaned up and
dirty tracking on the device is stopped during log_stop. The dirty
pages are determined and reported during log_read_and_clear.

In order to support these callbacks admin queue commands are used.
All of the adminq queue command structures and implementations
are included as part of this patch.

PDS_LM_CMD_DIRTY_STATUS is added to query the current status of
dirty tracking on the device. This includes if it's enabled (i.e.
number of regions being tracked from the device's perspective) and
the maximum number of regions supported from the device's perspective.

PDS_LM_CMD_DIRTY_ENABLE is added to enable dirty tracking on the
specified number of regions and their iova ranges.

PDS_LM_CMD_DIRTY_DISABLE is added to disable dirty tracking for all
regions on the device.

PDS_LM_CMD_READ_SEQ and PDS_LM_CMD_DIRTY_WRITE_ACK are added to
support reading and acknowledging the currently dirtied pages.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/Makefile   |   1 +
 drivers/vfio/pci/pds/cmds.c     | 124 +++++++
 drivers/vfio/pci/pds/cmds.h     |   9 +
 drivers/vfio/pci/pds/dirty.c    | 562 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/dirty.h    |  45 +++
 drivers/vfio/pci/pds/lm.c       |   3 +-
 drivers/vfio/pci/pds/vfio_dev.c |  12 +-
 drivers/vfio/pci/pds/vfio_dev.h |   5 +
 include/linux/pds/pds_adminq.h  |   5 +
 include/linux/pds/pds_lm.h      | 173 ++++++++++
 10 files changed, 936 insertions(+), 3 deletions(-)
 create mode 100644 drivers/vfio/pci/pds/dirty.c
 create mode 100644 drivers/vfio/pci/pds/dirty.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
index dbaf613d3794..805176f7be9f 100644
--- a/drivers/vfio/pci/pds/Makefile
+++ b/drivers/vfio/pci/pds/Makefile
@@ -5,6 +5,7 @@ obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
 
 pds_vfio-y := \
 	cmds.o		\
+	dirty.o		\
 	lm.o		\
 	pci_drv.o	\
 	vfio_dev.o
diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
index b51873dace96..c7edcb7b91a1 100644
--- a/drivers/vfio/pci/pds/cmds.c
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -361,3 +361,127 @@ pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio,
 		dev_warn(dev, "failed to send host VF migration status: %pe\n",
 			 ERR_PTR(err));
 }
+
+int
+pds_vfio_dirty_status_cmd(struct pds_vfio_pci_device *pds_vfio,
+			  u64 regions_dma, u8 *max_regions,
+			  u8 *num_regions)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_dirty_status.opcode = PDS_LM_CMD_DIRTY_STATUS,
+		.lm_dirty_status.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	dev_dbg(dev, "vf%u: Dirty status\n", pds_vfio->vf_id);
+
+	cmd.lm_dirty_status.regions_dma = cpu_to_le64(regions_dma);
+	cmd.lm_dirty_status.max_regions = *max_regions;
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+					 &comp, 0);
+	if (err) {
+		dev_err(dev, "failed to get dirty status: %pe\n", ERR_PTR(err));
+		return err;
+	}
+
+	/* only support seq_ack approach for now */
+	if (!(le32_to_cpu(comp.lm_dirty_status.bmp_type_mask) &
+	      BIT(PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK))) {
+		dev_err(dev, "Dirty bitmap tracking SEQ_ACK not supported\n");
+		return -EOPNOTSUPP;
+	}
+
+	*num_regions = comp.lm_dirty_status.num_regions;
+	*max_regions = comp.lm_dirty_status.max_regions;
+
+	dev_dbg(dev, "Page Tracking Status command successful, max_regions: %d, num_regions: %d, bmp_type: %s\n",
+		*max_regions, *num_regions, "PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK");
+
+	return 0;
+}
+
+int
+pds_vfio_dirty_enable_cmd(struct pds_vfio_pci_device *pds_vfio,
+			  u64 regions_dma, u8 num_regions)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_dirty_enable.opcode = PDS_LM_CMD_DIRTY_ENABLE,
+		.lm_dirty_enable.vf_id = cpu_to_le16(pds_vfio->vf_id),
+		.lm_dirty_enable.regions_dma = cpu_to_le64(regions_dma),
+		.lm_dirty_enable.bmp_type = PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK,
+		.lm_dirty_enable.num_regions = num_regions,
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+					 &comp, 0);
+	if (err) {
+		dev_err(dev, "failed dirty tracking enable: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
+
+int
+pds_vfio_dirty_disable_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_dirty_disable.opcode = PDS_LM_CMD_DIRTY_DISABLE,
+		.lm_dirty_disable.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+					 &comp, 0);
+	if (err || comp.lm_dirty_status.num_regions != 0) {
+		/* in case num_regions is still non-zero after disable */
+		err = err ? err : -EIO;
+		dev_err(dev, "failed dirty tracking disable: %pe, num_regions %d\n",
+			ERR_PTR(err), comp.lm_dirty_status.num_regions);
+		return err;
+	}
+
+	return 0;
+}
+
+int
+pds_vfio_dirty_seq_ack_cmd(struct pds_vfio_pci_device *pds_vfio,
+			   u64 sgl_dma, u16 num_sge, u32 offset,
+			   u32 total_len, bool read_seq)
+{
+	const char *cmd_type_str = read_seq ? "read_seq" : "write_ack";
+	union pds_core_adminq_cmd cmd = {
+		.lm_dirty_seq_ack.vf_id = cpu_to_le16(pds_vfio->vf_id),
+		.lm_dirty_seq_ack.len_bytes = cpu_to_le32(total_len),
+		.lm_dirty_seq_ack.off_bytes = cpu_to_le32(offset),
+		.lm_dirty_seq_ack.sgl_addr = cpu_to_le64(sgl_dma),
+		.lm_dirty_seq_ack.num_sge = cpu_to_le16(num_sge),
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	if (read_seq)
+		cmd.lm_dirty_seq_ack.opcode = PDS_LM_CMD_DIRTY_READ_SEQ;
+	else
+		cmd.lm_dirty_seq_ack.opcode = PDS_LM_CMD_DIRTY_WRITE_ACK;
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+					 &comp, 0);
+	if (err) {
+		dev_err(dev, "failed cmd Page Tracking %s: %pe\n",
+			cmd_type_str, ERR_PTR(err));
+		return err;
+	}
+
+	return 0;
+}
diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
index 3d8a5508c733..fc1f4ae611eb 100644
--- a/drivers/vfio/pci/pds/cmds.h
+++ b/drivers/vfio/pci/pds/cmds.h
@@ -13,4 +13,13 @@ int pds_vfio_get_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio);
 int pds_vfio_set_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio);
 void pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio,
 					 enum pds_lm_host_vf_status vf_status);
+int pds_vfio_dirty_status_cmd(struct pds_vfio_pci_device *pds_vfio,
+			      u64 regions_dma, u8 *max_regions,
+			      u8 *num_regions);
+int pds_vfio_dirty_enable_cmd(struct pds_vfio_pci_device *pds_vfio,
+			      u64 regions_dma, u8 num_regions);
+int pds_vfio_dirty_disable_cmd(struct pds_vfio_pci_device *pds_vfio);
+int pds_vfio_dirty_seq_ack_cmd(struct pds_vfio_pci_device *pds_vfio,
+			       u64 sgl_dma, u16 num_sge, u32 offset,
+			       u32 total_len, bool read_seq);
 #endif /* _CMDS_H_ */
diff --git a/drivers/vfio/pci/pds/dirty.c b/drivers/vfio/pci/pds/dirty.c
new file mode 100644
index 000000000000..bd480bb74970
--- /dev/null
+++ b/drivers/vfio/pci/pds/dirty.c
@@ -0,0 +1,562 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/interval_tree.h>
+#include <linux/vfio.h>
+
+#include <linux/pds/pds_common.h>
+#include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
+
+#include "vfio_dev.h"
+#include "cmds.h"
+#include "dirty.h"
+
+#define READ_SEQ	true
+#define WRITE_ACK	false
+
+bool
+pds_vfio_dirty_is_enabled(struct pds_vfio_pci_device *pds_vfio)
+{
+	return pds_vfio->dirty.is_enabled;
+}
+
+void
+pds_vfio_dirty_set_enabled(struct pds_vfio_pci_device *pds_vfio)
+{
+	pds_vfio->dirty.is_enabled = true;
+}
+
+void
+pds_vfio_dirty_set_disabled(struct pds_vfio_pci_device *pds_vfio)
+{
+	pds_vfio->dirty.is_enabled = false;
+}
+
+static void
+pds_vfio_print_guest_region_info(struct pds_vfio_pci_device *pds_vfio,
+				 u8 max_regions)
+{
+	int len = max_regions * sizeof(struct pds_lm_dirty_region_info);
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	struct pds_lm_dirty_region_info *region_info;
+	dma_addr_t regions_dma;
+	u8 num_regions;
+	int err;
+
+	region_info = kcalloc(max_regions,
+			      sizeof(struct pds_lm_dirty_region_info),
+			      GFP_KERNEL);
+	if (!region_info)
+		return;
+
+	regions_dma = dma_map_single(pdsc_dev, region_info, len,
+				     DMA_FROM_DEVICE);
+	if (dma_mapping_error(pdsc_dev, regions_dma))
+		goto err_out;
+
+	err = pds_vfio_dirty_status_cmd(pds_vfio, regions_dma,
+					&max_regions, &num_regions);
+	dma_unmap_single(pdsc_dev, regions_dma, len, DMA_FROM_DEVICE);
+	if (err)
+		goto err_out;
+
+	for (unsigned int i = 0; i < num_regions; i++)
+		dev_dbg(&pdev->dev, "region_info[%d]: dma_base 0x%llx page_count %u page_size_log2 %u\n",
+			i, le64_to_cpu(region_info[i].dma_base),
+			le32_to_cpu(region_info[i].page_count),
+			region_info[i].page_size_log2);
+
+err_out:
+	kfree(region_info);
+}
+
+static int
+pds_vfio_dirty_alloc_bitmaps(struct pds_vfio_dirty *dirty,
+			     u32 nbits)
+{
+	unsigned long *host_seq_bmp, *host_ack_bmp;
+
+	host_seq_bmp = bitmap_zalloc(nbits, GFP_KERNEL);
+	if (!host_seq_bmp)
+		return -ENOMEM;
+
+	host_ack_bmp = bitmap_zalloc(nbits, GFP_KERNEL);
+	if (!host_ack_bmp) {
+		bitmap_free(host_seq_bmp);
+		return -ENOMEM;
+	}
+
+	dirty->host_seq.bmp = host_seq_bmp;
+	dirty->host_ack.bmp = host_ack_bmp;
+
+	return 0;
+}
+
+static void
+pds_vfio_dirty_free_bitmaps(struct pds_vfio_dirty *dirty)
+{
+	if (dirty->host_seq.bmp)
+		bitmap_free(dirty->host_seq.bmp);
+	if (dirty->host_ack.bmp)
+		bitmap_free(dirty->host_ack.bmp);
+
+	dirty->host_seq.bmp = NULL;
+	dirty->host_ack.bmp = NULL;
+}
+
+static void
+__pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio,
+			  struct pds_vfio_bmp_info *bmp_info)
+{
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+
+	dma_unmap_single(pdsc_dev, bmp_info->sgl_addr,
+			 bmp_info->num_sge * sizeof(struct pds_lm_sg_elem),
+			 DMA_TO_DEVICE);
+	kfree(bmp_info->sgl);
+
+	bmp_info->num_sge = 0;
+	bmp_info->sgl = NULL;
+	bmp_info->sgl_addr = 0;
+}
+
+static void
+pds_vfio_dirty_free_sgl(struct pds_vfio_pci_device *pds_vfio)
+{
+	if (pds_vfio->dirty.host_seq.sgl)
+		__pds_vfio_dirty_free_sgl(pds_vfio,
+					  &pds_vfio->dirty.host_seq);
+	if (pds_vfio->dirty.host_ack.sgl)
+		__pds_vfio_dirty_free_sgl(pds_vfio,
+					  &pds_vfio->dirty.host_ack);
+}
+
+static int
+__pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
+			   struct pds_vfio_bmp_info *bmp_info,
+			   u32 page_count)
+{
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	struct pds_lm_sg_elem *sgl;
+	dma_addr_t sgl_addr;
+	size_t sgl_size;
+	u32 max_sge;
+
+	max_sge = DIV_ROUND_UP(page_count, PAGE_SIZE * 8);
+	sgl_size = max_sge * sizeof(struct pds_lm_sg_elem);
+
+	sgl = kzalloc(sgl_size, GFP_KERNEL);
+	if (!sgl)
+		return -ENOMEM;
+
+	sgl_addr = dma_map_single(pdsc_dev, sgl, sgl_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(pdsc_dev, sgl_addr)) {
+		kfree(sgl);
+		return -EIO;
+	}
+
+	bmp_info->sgl = sgl;
+	bmp_info->num_sge = max_sge;
+	bmp_info->sgl_addr = sgl_addr;
+
+	return 0;
+}
+
+static int
+pds_vfio_dirty_alloc_sgl(struct pds_vfio_pci_device *pds_vfio,
+			 u32 page_count)
+{
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	int err;
+
+	err = __pds_vfio_dirty_alloc_sgl(pds_vfio,
+					 &dirty->host_seq,
+					 page_count);
+	if (err)
+		return err;
+
+	err = __pds_vfio_dirty_alloc_sgl(pds_vfio,
+					 &dirty->host_ack,
+					 page_count);
+	if (err) {
+		__pds_vfio_dirty_free_sgl(pds_vfio, &dirty->host_seq);
+		return err;
+	}
+
+	return 0;
+}
+
+static int
+pds_vfio_dirty_enable(struct pds_vfio_pci_device *pds_vfio,
+		      struct rb_root_cached *ranges, u32 nnodes,
+		      u64 *page_size)
+{
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	u64 region_start, region_size, region_page_size;
+	struct pds_lm_dirty_region_info *region_info;
+	struct interval_tree_node *node = NULL;
+	u8 max_regions = 0, num_regions;
+	dma_addr_t regions_dma = 0;
+	u32 num_ranges = nnodes;
+	u32 page_count;
+	u16 len;
+	int err;
+
+	dev_dbg(&pdev->dev, "vf%u: Start dirty page tracking\n", pds_vfio->vf_id);
+
+	if (pds_vfio_dirty_is_enabled(pds_vfio))
+		return -EINVAL;
+
+	pds_vfio_dirty_set_enabled(pds_vfio);
+
+	/* find if dirty tracking is disabled, i.e. num_regions == 0 */
+	err = pds_vfio_dirty_status_cmd(pds_vfio, 0, &max_regions, &num_regions);
+	if (num_regions) {
+		dev_err(&pdev->dev, "Dirty tracking already enabled for %d regions\n",
+			num_regions);
+		err = -EEXIST;
+		goto err_out;
+	} else if (!max_regions) {
+		dev_err(&pdev->dev, "Device doesn't support dirty tracking, max_regions %d\n",
+			max_regions);
+		err = -EOPNOTSUPP;
+		goto err_out;
+	} else if (err) {
+		dev_err(&pdev->dev, "Failed to get dirty status, err %pe\n",
+			ERR_PTR(err));
+		goto err_out;
+	}
+
+	/*
+	 * Only support 1 region for now. If there are any large gaps in the
+	 * VM's address regions, then this would be a waste of memory as we are
+	 * generating 2 bitmaps (ack/seq) from the min address to the max
+	 * address of the VM's address regions. In the future, if we support
+	 * more than one region in the device/driver we can split the bitmaps
+	 * on the largest address region gaps. We can do this split up to the
+	 * max_regions times returned from the dirty_status command.
+	 */
+	max_regions = 1;
+	if (num_ranges > max_regions) {
+		vfio_combine_iova_ranges(ranges, nnodes, max_regions);
+		num_ranges = max_regions;
+	}
+
+	node = interval_tree_iter_first(ranges, 0, ULONG_MAX);
+	if (!node) {
+		err = -EINVAL;
+		goto err_out;
+	}
+
+	region_size = node->last - node->start + 1;
+	region_start = node->start;
+	region_page_size = *page_size;
+
+	len = sizeof(*region_info);
+	region_info = kzalloc(len, GFP_KERNEL);
+	if (!region_info) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	page_count = DIV_ROUND_UP(region_size, region_page_size);
+
+	region_info->dma_base = cpu_to_le64(region_start);
+	region_info->page_count = cpu_to_le32(page_count);
+	region_info->page_size_log2 = ilog2(region_page_size);
+
+	regions_dma = dma_map_single(pdsc_dev, (void *)region_info, len,
+				     DMA_BIDIRECTIONAL);
+	if (dma_mapping_error(pdsc_dev, regions_dma)) {
+		err = -ENOMEM;
+		kfree(region_info);
+		goto err_out;
+	}
+
+	err = pds_vfio_dirty_enable_cmd(pds_vfio, regions_dma, max_regions);
+	dma_unmap_single(pdsc_dev, regions_dma, len, DMA_BIDIRECTIONAL);
+	/*
+	 * page_count might be adjusted by the device,
+	 * update it before freeing region_info DMA
+	 */
+	page_count = le32_to_cpu(region_info->page_count);
+
+	dev_dbg(&pdev->dev, "region_info: regions_dma 0x%llx dma_base 0x%llx page_count %u page_size_log2 %u\n",
+		regions_dma, region_start, page_count, (u8)ilog2(region_page_size));
+
+	kfree(region_info);
+	if (err)
+		goto err_out;
+
+	err = pds_vfio_dirty_alloc_bitmaps(dirty, page_count);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to alloc dirty bitmaps: %pe\n",
+			ERR_PTR(err));
+		goto err_out;
+	}
+
+	err = pds_vfio_dirty_alloc_sgl(pds_vfio, page_count);
+	if (err) {
+		dev_err(&pdev->dev, "Failed to alloc dirty sg lists: %pe\n",
+			ERR_PTR(err));
+		goto err_free_bitmaps;
+	}
+
+	dirty->region_start = region_start;
+	dirty->region_size = region_size;
+	dirty->region_page_size = region_page_size;
+
+	pds_vfio_print_guest_region_info(pds_vfio, max_regions);
+
+	return 0;
+
+err_free_bitmaps:
+	pds_vfio_dirty_free_bitmaps(dirty);
+err_out:
+	pds_vfio_dirty_set_disabled(pds_vfio);
+	return err;
+}
+
+int
+pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio)
+{
+	int err;
+
+	if (!pds_vfio_dirty_is_enabled(pds_vfio)) {
+		err = 0;
+		goto out;
+	}
+
+	pds_vfio_dirty_set_disabled(pds_vfio);
+	err = pds_vfio_dirty_disable_cmd(pds_vfio);
+	pds_vfio_dirty_free_sgl(pds_vfio);
+	pds_vfio_dirty_free_bitmaps(&pds_vfio->dirty);
+
+out:
+	pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_NONE);
+	return err;
+}
+
+static int
+pds_vfio_dirty_seq_ack(struct pds_vfio_pci_device *pds_vfio,
+		       struct pds_vfio_bmp_info *bmp_info,
+		       u32 offset, u32 bmp_bytes,
+		       bool read_seq)
+{
+	const char *bmp_type_str = read_seq ? "read_seq" : "write_ack";
+	struct pci_dev *pdev = pds_vfio->vfio_coredev.pdev;
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	int bytes_remaining;
+	dma_addr_t bmp_dma;
+	u8 dma_direction;
+	u16 num_sge = 0;
+	u64 *bmp;
+	int err;
+
+	bmp = (u64 *)((u64)bmp_info->bmp + offset);
+
+	dma_direction = read_seq ? DMA_FROM_DEVICE : DMA_TO_DEVICE;
+	bmp_dma = dma_map_single(pdsc_dev, bmp, bmp_bytes,
+				 dma_direction);
+	if (dma_mapping_error(pdsc_dev, bmp_dma))
+		return -EINVAL;
+
+	bytes_remaining = bmp_bytes;
+
+	for (int i = 0; i < bmp_info->num_sge && bytes_remaining > 0; i++) {
+		struct pds_lm_sg_elem *sg_elem = &bmp_info->sgl[i];
+		u32 len = (bytes_remaining > PAGE_SIZE) ?
+			PAGE_SIZE : bytes_remaining;
+
+		sg_elem->addr = cpu_to_le64(bmp_dma + i * PAGE_SIZE);
+		sg_elem->len = cpu_to_le32(len);
+
+		bytes_remaining -= len;
+		++num_sge;
+	}
+
+	err = pds_vfio_dirty_seq_ack_cmd(pds_vfio, bmp_info->sgl_addr,
+					 num_sge, offset, bmp_bytes, read_seq);
+	if (err)
+		dev_err(&pdev->dev, "Dirty bitmap %s failed offset %u bmp_bytes %u num_sge %u DMA 0x%llx: %pe\n",
+			bmp_type_str, offset, bmp_bytes, num_sge, bmp_info->sgl_addr, ERR_PTR(err));
+
+	dma_unmap_single(pdsc_dev, bmp_dma, bmp_bytes, dma_direction);
+
+	return err;
+}
+
+static int
+pds_vfio_dirty_write_ack(struct pds_vfio_pci_device *pds_vfio, u32 offset,
+			 u32 len)
+{
+	return pds_vfio_dirty_seq_ack(pds_vfio,
+				      &pds_vfio->dirty.host_ack, offset,
+				      len, WRITE_ACK);
+}
+
+static int
+pds_vfio_dirty_read_seq(struct pds_vfio_pci_device *pds_vfio, u32 offset,
+			u32 len)
+{
+	return pds_vfio_dirty_seq_ack(pds_vfio,
+					  &pds_vfio->dirty.host_seq, offset,
+					  len, READ_SEQ);
+}
+
+static int
+pds_vfio_dirty_process_bitmaps(struct pds_vfio_pci_device *pds_vfio,
+			       struct iova_bitmap *dirty_bitmap, u32 bmp_offset,
+			       u32 len_bytes)
+{
+	u64 page_size = pds_vfio->dirty.region_page_size;
+	u64 region_start = pds_vfio->dirty.region_start;
+	u32 bmp_offset_bit;
+	__le64 *seq, *ack;
+	int dword_count;
+
+	dword_count = len_bytes / sizeof(u64);
+	seq = (__le64 *)((u64)pds_vfio->dirty.host_seq.bmp + bmp_offset);
+	ack = (__le64 *)((u64)pds_vfio->dirty.host_ack.bmp + bmp_offset);
+	bmp_offset_bit = bmp_offset * 8;
+
+	for (int i = 0; i < dword_count; i++) {
+		u64 xor = le64_to_cpu(seq[i]) ^ le64_to_cpu(ack[i]);
+
+		/* prepare for next write_ack call */
+		ack[i] = seq[i];
+
+		for (u8 bit_i = 0; bit_i < BITS_PER_TYPE(u64); ++bit_i) {
+			if (xor & BIT(bit_i)) {
+				u64 abs_bit_i = bmp_offset_bit + i *
+					BITS_PER_TYPE(u64) + bit_i;
+				u64 addr = abs_bit_i * page_size + region_start;
+
+				iova_bitmap_set(dirty_bitmap, addr, page_size);
+			}
+		}
+	}
+
+	return 0;
+}
+
+static int
+pds_vfio_dirty_sync(struct pds_vfio_pci_device *pds_vfio,
+		    struct iova_bitmap *dirty_bitmap,
+		    unsigned long iova, unsigned long length)
+{
+	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
+	struct pds_vfio_dirty *dirty = &pds_vfio->dirty;
+	u64 bmp_offset, bmp_bytes;
+	u64 bitmap_size, pages;
+	int err;
+
+	dev_dbg(dev, "vf%u: Get dirty page bitmap\n", pds_vfio->vf_id);
+
+	if (!pds_vfio_dirty_is_enabled(pds_vfio)) {
+		dev_err(dev, "vf%u: Sync failed, dirty tracking is disabled\n",
+			pds_vfio->vf_id);
+		return -EINVAL;
+	}
+
+	pages = DIV_ROUND_UP(length, pds_vfio->dirty.region_page_size);
+	bitmap_size = round_up(pages, sizeof(u64) * BITS_PER_BYTE) /
+		BITS_PER_BYTE;
+
+	dev_dbg(dev, "vf%u: iova 0x%lx length %lu page_size %llu pages %llu bitmap_size %llu\n",
+		pds_vfio->vf_id, iova, length,
+		pds_vfio->dirty.region_page_size, pages, bitmap_size);
+
+	if (!length ||
+	    ((dirty->region_start + iova + length) >
+	     (dirty->region_start + dirty->region_size))) {
+		dev_err(dev, "Invalid iova 0x%lx and/or length 0x%lx to sync\n",
+			iova, length);
+		return -EINVAL;
+	}
+
+	/* bitmap is modified in 64 bit chunks */
+	bmp_bytes = ALIGN(DIV_ROUND_UP(length / dirty->region_page_size,
+				       sizeof(u64)), sizeof(u64));
+	if (bmp_bytes != bitmap_size) {
+		dev_err(dev, "Calculated bitmap bytes %llu not equal to bitmap size %llu\n",
+			bmp_bytes, bitmap_size);
+		return -EINVAL;
+	}
+
+	bmp_offset = DIV_ROUND_UP(iova / dirty->region_page_size, sizeof(u64));
+
+	dev_dbg(dev, "Syncing dirty bitmap, iova 0x%lx length 0x%lx, bmp_offset %llu bmp_bytes %llu\n",
+		iova, length, bmp_offset, bmp_bytes);
+
+	err = pds_vfio_dirty_read_seq(pds_vfio, bmp_offset, bmp_bytes);
+	if (err)
+		return err;
+
+	err = pds_vfio_dirty_process_bitmaps(pds_vfio, dirty_bitmap,
+					     bmp_offset, bmp_bytes);
+	if (err)
+		return err;
+
+	err = pds_vfio_dirty_write_ack(pds_vfio, bmp_offset, bmp_bytes);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+int
+pds_vfio_dma_logging_report(struct vfio_device *vdev, unsigned long iova,
+			    unsigned long length,
+			    struct iova_bitmap *dirty)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+	int err;
+
+	mutex_lock(&pds_vfio->state_mutex);
+	err = pds_vfio_dirty_sync(pds_vfio, dirty, iova, length);
+	pds_vfio_state_mutex_unlock(pds_vfio);
+
+	return err;
+}
+
+int
+pds_vfio_dma_logging_start(struct vfio_device *vdev,
+			   struct rb_root_cached *ranges, u32 nnodes,
+			   u64 *page_size)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+	int err;
+
+	mutex_lock(&pds_vfio->state_mutex);
+	pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_IN_PROGRESS);
+	err = pds_vfio_dirty_enable(pds_vfio, ranges, nnodes, page_size);
+	pds_vfio_state_mutex_unlock(pds_vfio);
+
+	return err;
+}
+
+int
+pds_vfio_dma_logging_stop(struct vfio_device *vdev)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+	int err;
+
+	mutex_lock(&pds_vfio->state_mutex);
+	err = pds_vfio_dirty_disable(pds_vfio);
+	pds_vfio_state_mutex_unlock(pds_vfio);
+
+	return err;
+}
diff --git a/drivers/vfio/pci/pds/dirty.h b/drivers/vfio/pci/pds/dirty.h
new file mode 100644
index 000000000000..ea289fd830df
--- /dev/null
+++ b/drivers/vfio/pci/pds/dirty.h
@@ -0,0 +1,45 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _DIRTY_H_
+#define _DIRTY_H_
+
+struct pds_vfio_bmp_info {
+	unsigned long *bmp;
+	u32 bmp_bytes;
+	struct pds_lm_sg_elem *sgl;
+	dma_addr_t sgl_addr;
+	u16 num_sge;
+};
+
+struct pds_vfio_dirty {
+	struct pds_vfio_bmp_info host_seq;
+	struct pds_vfio_bmp_info host_ack;
+	u64 region_size;
+	u64 region_start;
+	u64 region_page_size;
+	bool is_enabled;
+};
+
+struct pds_vfio_pci_device;
+
+bool
+pds_vfio_dirty_is_enabled(struct pds_vfio_pci_device *pds_vfio);
+void
+pds_vfio_dirty_set_enabled(struct pds_vfio_pci_device *pds_vfio);
+void
+pds_vfio_dirty_set_disabled(struct pds_vfio_pci_device *pds_vfio);
+int
+pds_vfio_dirty_disable(struct pds_vfio_pci_device *pds_vfio);
+
+int
+pds_vfio_dma_logging_report(struct vfio_device *vdev, unsigned long iova,
+			    unsigned long length,
+			    struct iova_bitmap *dirty);
+int
+pds_vfio_dma_logging_start(struct vfio_device *vdev,
+			   struct rb_root_cached *ranges, u32 nnodes,
+			   u64 *page_size);
+int
+pds_vfio_dma_logging_stop(struct vfio_device *vdev);
+#endif /* _DIRTY_H_ */
diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
index 4e736f415df2..2b8876eb1bfd 100644
--- a/drivers/vfio/pci/pds/lm.c
+++ b/drivers/vfio/pci/pds/lm.c
@@ -386,8 +386,7 @@ pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
 
 	if (cur == VFIO_DEVICE_STATE_STOP_COPY && next == VFIO_DEVICE_STATE_STOP) {
 		pds_vfio_put_save_file(pds_vfio);
-		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
-						    PDS_LM_STA_NONE);
+		pds_vfio_dirty_disable(pds_vfio);
 		return NULL;
 	}
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 0c6e6c645f34..1adb00ea0114 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -5,6 +5,7 @@
 #include <linux/vfio_pci_core.h>
 
 #include "lm.h"
+#include "dirty.h"
 #include "vfio_dev.h"
 
 struct pci_dev *
@@ -28,7 +29,7 @@ pds_vfio_pci_drvdata(struct pci_dev *pdev)
 			    vfio_coredev);
 }
 
-static void
+void
 pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
 {
 again:
@@ -125,6 +126,13 @@ pds_vfio_lm_ops = {
 	.migration_get_data_size = pds_vfio_get_device_state_size
 };
 
+static const struct vfio_log_ops
+pds_vfio_log_ops = {
+	.log_start = pds_vfio_dma_logging_start,
+	.log_stop = pds_vfio_dma_logging_stop,
+	.log_read_and_clear = pds_vfio_dma_logging_report,
+};
+
 static int
 pds_vfio_init_device(struct vfio_device *vdev)
 {
@@ -143,6 +151,7 @@ pds_vfio_init_device(struct vfio_device *vdev)
 
 	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
 	vdev->mig_ops = &pds_vfio_lm_ops;
+	vdev->log_ops = &pds_vfio_log_ops;
 
 	dev_dbg(&pdev->dev, "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d pds_vfio %p\n",
 		__func__, pci_dev_id(pdev->physfn),
@@ -182,6 +191,7 @@ pds_vfio_close_device(struct vfio_device *vdev)
 	mutex_lock(&pds_vfio->state_mutex);
 	pds_vfio_put_restore_file(pds_vfio);
 	pds_vfio_put_save_file(pds_vfio);
+	pds_vfio_dirty_disable(pds_vfio);
 	mutex_unlock(&pds_vfio->state_mutex);
 	mutex_destroy(&pds_vfio->state_mutex);
 	vfio_pci_core_close_device(vdev);
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index df6208a7140b..2271f6af2a85 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -7,6 +7,7 @@
 #include <linux/pci.h>
 #include <linux/vfio_pci_core.h>
 
+#include "dirty.h"
 #include "lm.h"
 
 struct pdsc;
@@ -17,6 +18,7 @@ struct pds_vfio_pci_device {
 
 	struct pds_vfio_lm_file *save_file;
 	struct pds_vfio_lm_file *restore_file;
+	struct pds_vfio_dirty dirty;
 	struct mutex state_mutex; /* protect migration state */
 	enum vfio_device_mig_state state;
 	spinlock_t reset_lock; /* protect reset_done flow */
@@ -27,6 +29,9 @@ struct pds_vfio_pci_device {
 	u16 client_id;
 };
 
+void
+pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio);
+
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
 void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
index 897b966c52ea..8338722c74d2 100644
--- a/include/linux/pds/pds_adminq.h
+++ b/include/linux/pds/pds_adminq.h
@@ -610,6 +610,10 @@ union pds_core_adminq_cmd {
 	struct pds_lm_save_cmd			lm_save;
 	struct pds_lm_restore_cmd		lm_restore;
 	struct pds_lm_host_vf_status_cmd	lm_host_vf_status;
+	struct pds_lm_dirty_status_cmd		lm_dirty_status;
+	struct pds_lm_dirty_enable_cmd		lm_dirty_enable;
+	struct pds_lm_dirty_disable_cmd		lm_dirty_disable;
+	struct pds_lm_dirty_seq_ack_cmd		lm_dirty_seq_ack;
 };
 
 union pds_core_adminq_comp {
@@ -633,6 +637,7 @@ union pds_core_adminq_comp {
 	struct pds_core_q_init_comp       q_init;
 
 	struct pds_lm_status_comp		lm_status;
+	struct pds_lm_dirty_status_comp		lm_dirty_status;
 };
 
 #ifndef __CHECKER__
diff --git a/include/linux/pds/pds_lm.h b/include/linux/pds/pds_lm.h
index f1b0beb3c87b..37312f92f3b0 100644
--- a/include/linux/pds/pds_lm.h
+++ b/include/linux/pds/pds_lm.h
@@ -24,6 +24,13 @@ enum pds_lm_cmd_opcode {
 	PDS_LM_CMD_RESUME          = 20,
 	PDS_LM_CMD_SAVE            = 21,
 	PDS_LM_CMD_RESTORE         = 22,
+
+	/* Dirty page tracking commands */
+	PDS_LM_CMD_DIRTY_STATUS    = 32,
+	PDS_LM_CMD_DIRTY_ENABLE    = 33,
+	PDS_LM_CMD_DIRTY_DISABLE   = 34,
+	PDS_LM_CMD_DIRTY_READ_SEQ  = 35,
+	PDS_LM_CMD_DIRTY_WRITE_ACK = 36,
 };
 
 /**
@@ -214,4 +221,170 @@ struct pds_lm_host_vf_status_cmd {
 	u8     status;
 };
 
+/**
+ * struct pds_lm_dirty_region_info - Memory region info for STATUS and ENABLE
+ * @dma_base:		Base address of the DMA-contiguous memory region
+ * @page_count:		Number of pages in the memory region
+ * @page_size_log2:	Log2 page size in the memory region
+ * @rsvd:		Word boundary padding
+ */
+struct pds_lm_dirty_region_info {
+	__le64 dma_base;
+	__le32 page_count;
+	u8     page_size_log2;
+	u8     rsvd[3];
+};
+
+/**
+ * struct pds_lm_dirty_status_cmd - DIRTY_STATUS command
+ * @opcode:		Opcode PDS_LM_CMD_DIRTY_STATUS
+ * @rsvd:		Word boundary padding
+ * @vf_id:		VF id
+ * @max_regions:	Capacity of the region info buffer
+ * @rsvd2:		Word boundary padding
+ * @regions_dma:	DMA address of the region info buffer
+ *
+ * The minimum of max_regions (from the command) and num_regions (from the
+ * completion) of struct pds_lm_dirty_region_info will be written to
+ * regions_dma.
+ *
+ * The max_regions may be zero, in which case regions_dma is ignored.  In that
+ * case, the completion will only report the maximum number of regions
+ * supported by the device, and the number of regions currently enabled.
+ */
+struct pds_lm_dirty_status_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     max_regions;
+	u8     rsvd2[3];
+	__le64 regions_dma;
+} __packed;
+
+/**
+ * enum pds_lm_dirty_bmp_type - Type of dirty page bitmap
+ * @PDS_LM_DIRTY_BMP_TYPE_NONE: No bitmap / disabled
+ * @PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK: Seq/Ack bitmap representation
+ */
+enum pds_lm_dirty_bmp_type {
+	PDS_LM_DIRTY_BMP_TYPE_NONE     = 0,
+	PDS_LM_DIRTY_BMP_TYPE_SEQ_ACK  = 1,
+};
+
+/**
+ * struct pds_lm_dirty_status_comp - STATUS command completion
+ * @status:		Status of the command (enum pds_core_status_code)
+ * @rsvd:		Word boundary padding
+ * @comp_index:		Index in the desc ring for which this is the completion
+ * @max_regions:	Maximum number of regions supported by the device
+ * @num_regions:	Number of regions currently enabled
+ * @bmp_type:		Type of dirty bitmap representation
+ * @rsvd2:		Word boundary padding
+ * @bmp_type_mask:	Mask of supported bitmap types, bit index per type
+ * @rsvd3:		Word boundary padding
+ * @color:		Color bit
+ *
+ * This completion descriptor is used for STATUS, ENABLE, and DISABLE.
+ */
+struct pds_lm_dirty_status_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	u8     max_regions;
+	u8     num_regions;
+	u8     bmp_type;
+	u8     rsvd2;
+	__le32 bmp_type_mask;
+	u8     rsvd3[3];
+	u8     color;
+};
+
+/**
+ * struct pds_lm_dirty_enable_cmd - DIRTY_ENABLE command
+ * @opcode:		Opcode PDS_LM_CMD_DIRTY_ENABLE
+ * @rsvd:		Word boundary padding
+ * @vf_id:		VF id
+ * @bmp_type:		Type of dirty bitmap representation
+ * @num_regions:	Number of entries in the region info buffer
+ * @rsvd2:		Word boundary padding
+ * @regions_dma:	DMA address of the region info buffer
+ *
+ * The num_regions must be nonzero, and less than or equal to the maximum
+ * number of regions supported by the device.
+ *
+ * The memory regions should not overlap.
+ *
+ * The information should be initialized by the driver.  The device may modify
+ * the information on successful completion, such as by size-aligning the
+ * number of pages in a region.
+ *
+ * The modified number of pages will be greater than or equal to the page count
+ * given in the enable command, and at least as coarsly aligned as the given
+ * value.  For example, the count might be aligned to a multiple of 64, but
+ * if the value is already a multiple of 128 or higher, it will not change.
+ * If the driver requires its own minimum alignment of the number of pages, the
+ * driver should account for that already in the region info of this command.
+ *
+ * This command uses struct pds_lm_dirty_status_comp for its completion.
+ */
+struct pds_lm_dirty_enable_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     bmp_type;
+	u8     num_regions;
+	u8     rsvd2[2];
+	__le64 regions_dma;
+} __packed;
+
+/**
+ * struct pds_lm_dirty_disable_cmd - DIRTY_DISABLE command
+ * @opcode:	Opcode PDS_LM_CMD_DIRTY_DISABLE
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ *
+ * Dirty page tracking will be disabled.  This may be called in any state, as
+ * long as dirty page tracking is supported by the device, to ensure that dirty
+ * page tracking is disabled.
+ *
+ * This command uses struct pds_lm_dirty_status_comp for its completion.  On
+ * success, num_regions will be zero.
+ */
+struct pds_lm_dirty_disable_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_lm_dirty_seq_ack_cmd - DIRTY_READ_SEQ or _WRITE_ACK command
+ * @opcode:	Opcode PDS_LM_CMD_DIRTY_[READ_SEQ|WRITE_ACK]
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @off_bytes:	Byte offset in the bitmap
+ * @len_bytes:	Number of bytes to transfer
+ * @num_sge:	Number of DMA scatter gather elements
+ * @rsvd2:	Word boundary padding
+ * @sgl_addr:	DMA address of scatter gather list
+ *
+ * Read bytes from the SEQ bitmap, or write bytes into the ACK bitmap.
+ *
+ * This command treats the entire bitmap as a byte buffer.  It does not
+ * distinguish between guest memory regions.  The driver should refer to the
+ * number of pages in each region, according to PDS_LM_CMD_DIRTY_STATUS, to
+ * determine the region boundaries in the bitmap.  Each region will be
+ * represented by exactly the number of bits as the page count for that region,
+ * immediately following the last bit of the previous region.
+ */
+struct pds_lm_dirty_seq_ack_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	__le32 off_bytes;
+	__le32 len_bytes;
+	__le16 num_sge;
+	u8     rsvd2[2];
+	__le64 sgl_addr;
+} __packed;
+
 #endif /* _PDS_LM_H_ */
-- 
2.17.1


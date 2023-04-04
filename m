Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF1036D6CE9
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 21:03:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236297AbjDDTDN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 15:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236278AbjDDTCj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 15:02:39 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2062b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e83::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 649F055B4;
        Tue,  4 Apr 2023 12:02:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NrYWxpeUHAydsEArOAA9Zd6JrXpfBjhjNaqMM65wj8jov6+xy2Qu8NPLWKQdxI/6X6ErpclgBrAgI+ikVOt0yEHOPw2fqNYhTfVCn1PW5h3wzbcoOwvqmXAoNjRFaOWk8/CMwfeoA+0o14AB1DK6LEYqnJoLHn/0nzT+ADg/l3Z4EBpvF/HkYIrBoBygjXgDSIR320VzT/rpLOwTgr3oZ+A69P5hJ9vQp7mfHADx+6TgKkxFCoGxrnAxCDFFwSo5oPxeXpHi1KhHsQpB+oHnRicXLfYEvkZOVPoWjWOg7OqMtBTzZEINzwFcz+lciJtvPIn3RYZkWfOIxAwma/tzsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YDw9UsD91GIeADX2qQ4qDIjAhneMtgZJpKeLSjxLGVk=;
 b=Av2yck2+wTomjhh5gjrs9jn08S7lyvnDv+siHPQ2T/lW7Bh/woiotFNdywn9nQLCsSRwSUdzUbkQNtBwX3sx1lRv/Huo4YehTW4JRoUjdh4SZ3apyRFhykt6e2AnPirTrCx0Qe+9NDYKcTm++puFvsJ31Ibz3MG8jluWGMitxeihXkaN++JJ2PKRsdZ77ZIc0y50/EIcWETKzKDfYDIVIfF2r+K7o5FRr1YUnodlUOcGDlFrs5WkXaLuegi845bZ6UxkgaEloFPtWz8FqUVUsZNgU+Ul3PInaZylzjG+tZ+bC8Ld08nWm0+51zH+B4ntFfYIaaOkZjhNMT37kK1egg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YDw9UsD91GIeADX2qQ4qDIjAhneMtgZJpKeLSjxLGVk=;
 b=AMKoasGjQsH4i1y0ZDKJqv5DEQaUEc30ck7WTlWimEOVkpCk54BHwWY98tAZ3wz700Omnh2NJFF1270lxDx0xg7lLAH43FJKF2MqrMfuE51rcerJTxds54QTsvUJEjCjzDNzPVnqziiw1K2kFwx687aGvsY6G3TJ3oq5z1Acn4c=
Received: from MW4PR04CA0260.namprd04.prod.outlook.com (2603:10b6:303:88::25)
 by IA0PR12MB8984.namprd12.prod.outlook.com (2603:10b6:208:492::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Tue, 4 Apr
 2023 19:02:08 +0000
Received: from CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:88:cafe::20) by MW4PR04CA0260.outlook.office365.com
 (2603:10b6:303:88::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35 via Frontend
 Transport; Tue, 4 Apr 2023 19:02:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 CO1NAM11FT088.mail.protection.outlook.com (10.13.175.131) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6277.28 via Frontend Transport; Tue, 4 Apr 2023 19:02:07 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Tue, 4 Apr
 2023 14:02:05 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>, <simon.horman@corigine.com>
Subject: [PATCH v8 vfio 4/7] vfio/pds: Add VFIO live migration support
Date:   Tue, 4 Apr 2023 12:01:38 -0700
Message-ID: <20230404190141.57762-5-brett.creeley@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230404190141.57762-1-brett.creeley@amd.com>
References: <20230404190141.57762-1-brett.creeley@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT088:EE_|IA0PR12MB8984:EE_
X-MS-Office365-Filtering-Correlation-Id: db6da99a-5ecf-4cf7-dff3-08db353f1659
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ivcQhEgIbbqh75kbHrHVm7Scn4Q2ECWqEIBYjTqBjwAeA52MsC8XzprDnVO/A13Vp3pOs+H4jt0zXwO5ZFnDrhXlLr2NYQwvUbmWnX36WDnynWJnXuttRQpaYJMRl6Ev4xOLdJWJy91aT4uElMMS/EHN4hynSa/9/fmD1zYF2tDXRQEGe6YM4G3mlJ0nyvGqQr+PWHwoMV358XyZ3xBD0kixgQ8PYQG2hGSQ2c+ct/ZwVS17xyHBOWpK7r++pfAjTdWNPZ2yW9wgzRJMCV8uTcJrx/MkncGiWwPfz9A2bscmQ1XymT/wFSKQbKyxYkBysjQqtblPpR149zCaLQnrnklfETnEtVyegOnH0AiDM0NMLDh0XMlZ6LjDePtXZnlQvSOnJHGoue3Ke7NNEjx2DZJZpbmx44vcPtif0ogZQA+NHWv2FeylcfwDhD3/YEMhp6jU3v2qCzDhKImn2epG2DCJmGW8CbvMyuQaex1jkwbxEoII3rApfBj9OK0GdhfqY9u3CNNeUD+NgOLw59ekgeV/r+svj/Ljwo0eYor58FET9ZQxlRYfUNq4D0Pv7TiTNDZCVnBQsybjd0A7EWMThH3j/ydGEQTWRITPs/0HEm3pM/KplHhifny0yAopPWswkzv4CHpe2qZDW2C6OebLhpBr241Nuhff2Zfoek+f045l0E5E2XDE15/yHdQjTmR9EEoQNdo4DcNp7HJ8rihXOG+dH4C5FousgvkB+YIY3JY=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199021)(36840700001)(46966006)(40470700004)(8936002)(82740400003)(70206006)(70586007)(41300700001)(316002)(110136005)(2906002)(54906003)(478600001)(336012)(426003)(2616005)(4326008)(26005)(6666004)(44832011)(8676002)(30864003)(5660300002)(186003)(1076003)(16526019)(47076005)(83380400001)(36860700001)(81166007)(356005)(82310400005)(40460700003)(86362001)(36756003)(40480700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Apr 2023 19:02:07.5695
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: db6da99a-5ecf-4cf7-dff3-08db353f1659
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT088.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR12MB8984
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add live migration support via the VFIO subsystem. The migration
implementation aligns with the definition from uapi/vfio.h and uses
the pds_core PF's adminq for device configuration.

The ability to suspend, resume, and transfer VF device state data is
included along with the required admin queue command structures and
implementations.

PDS_LM_CMD_SUSPEND and PDS_LM_CMD_SUSPEND_STATUS are added to support
the VF device suspend operation.

PDS_LM_CMD_RESUME is added to support the VF device resume operation.

PDS_LM_CMD_STATUS is added to determine the exact size of the VF
device state data.

PDS_LM_CMD_SAVE is added to get the VF device state data.

PDS_LM_CMD_RESTORE is added to restore the VF device with the
previously saved data from PDS_LM_CMD_SAVE.

PDS_LM_CMD_HOST_VF_STATUS is added to notify the device when
a migration is in/not-in progress from the host's perspective.

Signed-off-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/vfio/pci/pds/Makefile   |   1 +
 drivers/vfio/pci/pds/cmds.c     | 322 +++++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h     |   8 +-
 drivers/vfio/pci/pds/lm.c       | 479 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/lm.h       |  52 ++++
 drivers/vfio/pci/pds/pci_drv.c  |  16 ++
 drivers/vfio/pci/pds/vfio_dev.c | 119 +++++++-
 drivers/vfio/pci/pds/vfio_dev.h |  11 +
 include/linux/pds/pds_lm.h      | 210 +++++++++++++-
 9 files changed, 1213 insertions(+), 5 deletions(-)
 create mode 100644 drivers/vfio/pci/pds/lm.c
 create mode 100644 drivers/vfio/pci/pds/lm.h

diff --git a/drivers/vfio/pci/pds/Makefile b/drivers/vfio/pci/pds/Makefile
index 87581111fa17..dbaf613d3794 100644
--- a/drivers/vfio/pci/pds/Makefile
+++ b/drivers/vfio/pci/pds/Makefile
@@ -5,5 +5,6 @@ obj-$(CONFIG_PDS_VFIO_PCI) += pds_vfio.o
 
 pds_vfio-y := \
 	cmds.o		\
+	lm.o		\
 	pci_drv.o	\
 	vfio_dev.o
diff --git a/drivers/vfio/pci/pds/cmds.c b/drivers/vfio/pci/pds/cmds.c
index 7807dbb2c72c..bcd9f92e30b5 100644
--- a/drivers/vfio/pci/pds/cmds.c
+++ b/drivers/vfio/pci/pds/cmds.c
@@ -3,6 +3,7 @@
 
 #include <linux/io.h>
 #include <linux/types.h>
+#include <linux/delay.h>
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
@@ -12,6 +13,35 @@
 #include "vfio_dev.h"
 #include "cmds.h"
 
+#define SUSPEND_TIMEOUT_S		5
+#define SUSPEND_CHECK_INTERVAL_MS	1
+
+static int
+pds_client_adminq_cmd(struct pds_vfio_pci_device *pds_vfio,
+		      union pds_core_adminq_cmd *req,
+		      size_t req_len,
+		      union pds_core_adminq_comp *resp,
+		      u64 flags)
+{
+	union pds_core_adminq_cmd cmd = { 0 };
+	size_t cp_len;
+	int err;
+
+	/* Wrap the client request */
+	cmd.client_request.opcode = PDS_AQ_CMD_CLIENT_CMD;
+	cmd.client_request.client_id = cpu_to_le16(pds_vfio->client_id);
+	cp_len = min_t(size_t, req_len, sizeof(cmd.client_request.client_cmd));
+	memcpy(cmd.client_request.client_cmd, req, cp_len);
+
+	err = pdsc_adminq_post(pds_vfio->pdsc, &cmd, resp,
+			       !!(flags & PDS_AQ_FLAG_FASTPOLL));
+	if (err && err != -EAGAIN)
+		dev_info(&pds_vfio->pdev->dev, "client admin cmd failed: %pe\n",
+			 ERR_PTR(err));
+
+	return err;
+}
+
 int
 pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
 {
@@ -67,3 +97,295 @@ pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
 
 	pds_vfio->client_id = 0;
 }
+
+static int
+pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pds_lm_suspend_status_cmd cmd = {
+		.opcode = PDS_LM_CMD_SUSPEND_STATUS,
+		.vf_id	= cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct pci_dev *pdev = pds_vfio->pdev;
+	struct pds_lm_comp comp = { 0 };
+	unsigned long time_limit;
+	unsigned long time_start;
+	unsigned long time_done;
+	int err;
+
+	time_start = jiffies;
+	time_limit = time_start + HZ * SUSPEND_TIMEOUT_S;
+	do {
+		err = pds_client_adminq_cmd(pds_vfio,
+					    (union pds_core_adminq_cmd *)&cmd,
+					    sizeof(cmd),
+					    (union pds_core_adminq_comp *)&comp,
+					    PDS_AQ_FLAG_FASTPOLL);
+		if (err != -EAGAIN)
+			break;
+
+		msleep(SUSPEND_CHECK_INTERVAL_MS);
+	} while (time_before(jiffies, time_limit));
+
+	time_done = jiffies;
+	dev_dbg(&pdev->dev, "%s: vf%u: Suspend comp received in %d msecs\n",
+		__func__, pds_vfio->vf_id,
+		jiffies_to_msecs(time_done - time_start));
+
+	/* Check the results */
+	if (time_after_eq(time_done, time_limit)) {
+		dev_err(&pdev->dev, "%s: vf%u: Suspend comp timeout\n", __func__,
+			pds_vfio->vf_id);
+		err = -ETIMEDOUT;
+	}
+
+	return err;
+}
+
+int
+pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pds_lm_suspend_cmd cmd = {
+		.opcode = PDS_LM_CMD_SUSPEND,
+		.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct pds_lm_suspend_comp comp = {0};
+	struct pci_dev *pdev = pds_vfio->pdev;
+	int err;
+
+	dev_dbg(&pdev->dev, "vf%u: Suspend device\n", pds_vfio->vf_id);
+
+	err = pds_client_adminq_cmd(pds_vfio,
+				    (union pds_core_adminq_cmd *)&cmd,
+				    sizeof(cmd),
+				    (union pds_core_adminq_comp *)&comp,
+				    PDS_AQ_FLAG_FASTPOLL);
+	if (err) {
+		dev_err(&pdev->dev, "vf%u: Suspend failed: %pe\n",
+			pds_vfio->vf_id, ERR_PTR(err));
+		return err;
+	}
+
+	return pds_vfio_suspend_wait_device_cmd(pds_vfio);
+}
+
+int
+pds_vfio_resume_device_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pds_lm_resume_cmd cmd = {
+		.opcode = PDS_LM_CMD_RESUME,
+		.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct pds_lm_comp comp = {0};
+
+	dev_dbg(&pds_vfio->pdev->dev, "vf%u: Resume device\n", pds_vfio->vf_id);
+
+	return pds_client_adminq_cmd(pds_vfio,
+				     (union pds_core_adminq_cmd *)&cmd,
+				     sizeof(cmd),
+				     (union pds_core_adminq_comp *)&comp,
+				     0);
+}
+
+int
+pds_vfio_get_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio, u64 *size)
+{
+	struct pds_lm_status_cmd cmd = {
+		.opcode = PDS_LM_CMD_STATUS,
+		.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct pds_lm_status_comp comp = {0};
+	int err;
+
+	dev_dbg(&pds_vfio->pdev->dev, "vf%u: Get migration status\n",
+		pds_vfio->vf_id);
+
+	err = pds_client_adminq_cmd(pds_vfio,
+				    (union pds_core_adminq_cmd *)&cmd,
+				    sizeof(cmd),
+				    (union pds_core_adminq_comp *)&comp,
+				    0);
+	if (err)
+		return err;
+
+	*size = le64_to_cpu(comp.size);
+	return 0;
+}
+
+static int
+pds_vfio_dma_map_lm_file(struct device *dev, enum dma_data_direction dir,
+			 struct pds_vfio_lm_file *lm_file)
+{
+	struct pds_lm_sg_elem *sgl, *sge;
+	struct scatterlist *sg;
+	int err;
+	int i;
+
+	if (!lm_file)
+		return -EINVAL;
+
+	/* dma map file pages */
+	err = dma_map_sgtable(dev, &lm_file->sg_table, dir, 0);
+	if (err)
+		return err;
+
+	lm_file->num_sge = lm_file->sg_table.nents;
+
+	/* alloc sgl */
+	sgl = dma_alloc_coherent(dev, lm_file->num_sge *
+				 sizeof(struct pds_lm_sg_elem),
+				 &lm_file->sgl_addr, GFP_KERNEL);
+	if (!sgl) {
+		err = -ENOMEM;
+		goto err_alloc_sgl;
+	}
+
+	lm_file->sgl = sgl;
+
+	/* fill sgl */
+	sge = sgl;
+	for_each_sgtable_dma_sg(&lm_file->sg_table, sg, i) {
+		sge->addr = cpu_to_le64(sg_dma_address(sg));
+		sge->len  = cpu_to_le32(sg_dma_len(sg));
+		dev_dbg(dev, "addr = %llx, len = %u\n", sge->addr, sge->len);
+		sge++;
+	}
+
+	return 0;
+
+err_alloc_sgl:
+	dma_unmap_sgtable(dev, &lm_file->sg_table, dir, 0);
+	return err;
+}
+
+static void
+pds_vfio_dma_unmap_lm_file(struct device *dev, enum dma_data_direction dir,
+			   struct pds_vfio_lm_file *lm_file)
+{
+	if (!lm_file)
+		return;
+
+	/* free sgl */
+	if (lm_file->sgl) {
+		dma_free_coherent(dev, lm_file->num_sge *
+				  sizeof(struct pds_lm_sg_elem),
+				  lm_file->sgl, lm_file->sgl_addr);
+		lm_file->sgl = NULL;
+		lm_file->sgl_addr = DMA_MAPPING_ERROR;
+		lm_file->num_sge = 0;
+	}
+
+	/* dma unmap file pages */
+	dma_unmap_sgtable(dev, &lm_file->sg_table, dir, 0);
+}
+
+int
+pds_vfio_get_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pds_lm_save_cmd cmd = {
+		.opcode = PDS_LM_CMD_SAVE,
+		.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct pci_dev *pdev = pds_vfio->pdev;
+	struct pds_vfio_lm_file *lm_file;
+	struct pds_lm_comp comp = {0};
+	int err;
+
+	dev_dbg(&pdev->dev, "vf%u: Get migration state\n", pds_vfio->vf_id);
+
+	lm_file = pds_vfio->save_file;
+
+	err = pds_vfio_dma_map_lm_file(pds_vfio->coredev, DMA_FROM_DEVICE, lm_file);
+	if (err) {
+		dev_err(&pdev->dev, "failed to map save migration file: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	cmd.sgl_addr = cpu_to_le64(lm_file->sgl_addr);
+	cmd.num_sge = cpu_to_le32(lm_file->num_sge);
+
+	err = pds_client_adminq_cmd(pds_vfio,
+				    (union pds_core_adminq_cmd *)&cmd,
+				    sizeof(cmd),
+				    (union pds_core_adminq_comp *)&comp,
+				    0);
+	if (err)
+		dev_err(&pdev->dev, "failed to get migration state: %pe\n",
+			ERR_PTR(err));
+
+	pds_vfio_dma_unmap_lm_file(pds_vfio->coredev, DMA_FROM_DEVICE, lm_file);
+
+	return err;
+}
+
+int
+pds_vfio_set_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pds_lm_restore_cmd cmd = {
+		.opcode = PDS_LM_CMD_RESTORE,
+		.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct pci_dev *pdev = pds_vfio->pdev;
+	struct pds_vfio_lm_file *lm_file;
+	struct pds_lm_comp comp = {0};
+	int err;
+
+	dev_dbg(&pdev->dev, "vf%u: Set migration state\n", pds_vfio->vf_id);
+
+	lm_file = pds_vfio->restore_file;
+
+	err = pds_vfio_dma_map_lm_file(pds_vfio->coredev, DMA_TO_DEVICE, lm_file);
+	if (err) {
+		dev_err(&pdev->dev, "failed to map restore migration file: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	cmd.sgl_addr = cpu_to_le64(lm_file->sgl_addr);
+	cmd.num_sge = cpu_to_le32(lm_file->num_sge);
+
+	err = pds_client_adminq_cmd(pds_vfio,
+				    (union pds_core_adminq_cmd *)&cmd,
+				    sizeof(cmd),
+				    (union pds_core_adminq_comp *)&comp,
+				    0);
+	if (err)
+		dev_err(&pdev->dev, "failed to set migration state: %pe\n",
+			ERR_PTR(err));
+
+	pds_vfio_dma_unmap_lm_file(pds_vfio->coredev, DMA_TO_DEVICE, lm_file);
+
+	return err;
+}
+
+void
+pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio,
+				    enum pds_lm_host_vf_status vf_status)
+{
+	struct pds_lm_host_vf_status_cmd cmd = {
+		.opcode = PDS_LM_CMD_HOST_VF_STATUS,
+		.vf_id = cpu_to_le16(pds_vfio->vf_id),
+		.status = vf_status,
+	};
+	struct pci_dev *pdev = pds_vfio->pdev;
+	struct pds_lm_comp comp = {0};
+	int err;
+
+	dev_dbg(&pdev->dev, "vf%u: Set host VF LM status: %u",
+		pds_vfio->vf_id, cmd.status);
+	if (vf_status != PDS_LM_STA_IN_PROGRESS &&
+	    vf_status != PDS_LM_STA_NONE) {
+		dev_warn(&pdev->dev, "Invalid host VF migration status, %d\n",
+			 vf_status);
+		return;
+	}
+
+	err = pds_client_adminq_cmd(pds_vfio,
+				    (union pds_core_adminq_cmd *)&cmd,
+				    sizeof(cmd),
+				    (union pds_core_adminq_comp *)&comp,
+				    0);
+	if (err)
+		dev_warn(&pdev->dev, "failed to send host VF migration status: %pe\n",
+			 ERR_PTR(err));
+}
diff --git a/drivers/vfio/pci/pds/cmds.h b/drivers/vfio/pci/pds/cmds.h
index 4c592afccf89..3d8a5508c733 100644
--- a/drivers/vfio/pci/pds/cmds.h
+++ b/drivers/vfio/pci/pds/cmds.h
@@ -6,5 +6,11 @@
 
 int pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio);
 void pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio);
-
+int pds_vfio_suspend_device_cmd(struct pds_vfio_pci_device *pds_vfio);
+int pds_vfio_resume_device_cmd(struct pds_vfio_pci_device *pds_vfio);
+int pds_vfio_get_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio, u64 *size);
+int pds_vfio_get_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio);
+int pds_vfio_set_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio);
+void pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio,
+					 enum pds_lm_host_vf_status vf_status);
 #endif /* _CMDS_H_ */
diff --git a/drivers/vfio/pci/pds/lm.c b/drivers/vfio/pci/pds/lm.c
new file mode 100644
index 000000000000..855f5da9b99a
--- /dev/null
+++ b/drivers/vfio/pci/pds/lm.c
@@ -0,0 +1,479 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#include <linux/anon_inodes.h>
+#include <linux/file.h>
+#include <linux/fs.h>
+#include <linux/highmem.h>
+#include <linux/vfio.h>
+#include <linux/vfio_pci_core.h>
+
+#include "vfio_dev.h"
+#include "cmds.h"
+
+#define PDS_VFIO_LM_FILENAME	"pds_vfio_lm"
+
+const char *
+pds_vfio_lm_state(enum vfio_device_mig_state state)
+{
+	switch (state) {
+	case VFIO_DEVICE_STATE_ERROR:
+		return "VFIO_DEVICE_STATE_ERROR";
+	case VFIO_DEVICE_STATE_STOP:
+		return "VFIO_DEVICE_STATE_STOP";
+	case VFIO_DEVICE_STATE_RUNNING:
+		return "VFIO_DEVICE_STATE_RUNNING";
+	case VFIO_DEVICE_STATE_STOP_COPY:
+		return "VFIO_DEVICE_STATE_STOP_COPY";
+	case VFIO_DEVICE_STATE_RESUMING:
+		return "VFIO_DEVICE_STATE_RESUMING";
+	case VFIO_DEVICE_STATE_RUNNING_P2P:
+		return "VFIO_DEVICE_STATE_RUNNING_P2P";
+	default:
+		return "VFIO_DEVICE_STATE_INVALID";
+	}
+
+	return "VFIO_DEVICE_STATE_INVALID";
+}
+
+static struct pds_vfio_lm_file *
+pds_vfio_get_lm_file(const char *name, const struct file_operations *fops,
+		     int flags, u64 size)
+{
+	struct pds_vfio_lm_file *lm_file = NULL;
+	unsigned long long npages;
+	struct page **pages;
+	int err = 0;
+
+	if (!size)
+		return NULL;
+
+	/* Alloc file structure */
+	lm_file = kzalloc(sizeof(*lm_file), GFP_KERNEL);
+	if (!lm_file)
+		return NULL;
+
+	/* Create file */
+	lm_file->filep = anon_inode_getfile(name, fops, lm_file, flags);
+	if (!lm_file->filep)
+		goto err_get_file;
+
+	stream_open(lm_file->filep->f_inode, lm_file->filep);
+	mutex_init(&lm_file->lock);
+
+	lm_file->size = size;
+
+	/* Allocate memory for file pages */
+	npages = DIV_ROUND_UP_ULL(lm_file->size, PAGE_SIZE);
+
+	pages = kcalloc(npages, sizeof(*pages), GFP_KERNEL);
+	if (!pages)
+		goto err_alloc_pages;
+
+	for (unsigned long long i = 0; i < npages; i++) {
+		pages[i] = alloc_page(GFP_KERNEL);
+		if (!pages[i])
+			goto err_alloc_page;
+	}
+
+	lm_file->pages = pages;
+	lm_file->npages = npages;
+	lm_file->alloc_size = npages * PAGE_SIZE;
+
+	/* Create scatterlist of file pages to use for DMA mapping later */
+	err = sg_alloc_table_from_pages(&lm_file->sg_table, pages, npages,
+					0, size, GFP_KERNEL);
+	if (err)
+		goto err_alloc_sg_table;
+
+	return lm_file;
+
+err_alloc_sg_table:
+err_alloc_page:
+	/* free allocated pages */
+	for (unsigned long long i = 0; i < npages && pages[i]; i++)
+		__free_page(pages[i]);
+	kfree(pages);
+err_alloc_pages:
+	fput(lm_file->filep);
+	mutex_destroy(&lm_file->lock);
+err_get_file:
+	kfree(lm_file);
+
+	return NULL;
+}
+
+static void
+pds_vfio_put_lm_file(struct pds_vfio_lm_file *lm_file)
+{
+	mutex_lock(&lm_file->lock);
+
+	lm_file->size = 0;
+	lm_file->alloc_size = 0;
+
+	/* Free scatter list of file pages*/
+	sg_free_table(&lm_file->sg_table);
+
+	/* Free allocated file pages */
+	for (unsigned long long i = 0;
+	     i < lm_file->npages && lm_file->pages[i]; i++)
+		__free_page(lm_file->pages[i]);
+	kfree(lm_file->pages);
+	lm_file->pages = NULL;
+
+	mutex_unlock(&lm_file->lock);
+}
+
+void
+pds_vfio_put_save_file(struct pds_vfio_pci_device *pds_vfio)
+{
+	if (!pds_vfio->save_file)
+		return;
+
+	pds_vfio_put_lm_file(pds_vfio->save_file);
+	pds_vfio->save_file = NULL;
+}
+
+void
+pds_vfio_put_restore_file(struct pds_vfio_pci_device *pds_vfio)
+{
+	if (!pds_vfio->restore_file)
+		return;
+
+	pds_vfio_put_lm_file(pds_vfio->restore_file);
+	pds_vfio->restore_file = NULL;
+}
+
+static struct page *
+pds_vfio_get_file_page(struct pds_vfio_lm_file *lm_file,
+		       unsigned long offset)
+{
+	unsigned long cur_offset = 0;
+	struct scatterlist *sg;
+	unsigned int i;
+
+	/* All accesses are sequential */
+	if (offset < lm_file->last_offset || !lm_file->last_offset_sg) {
+		lm_file->last_offset = 0;
+		lm_file->last_offset_sg = lm_file->sg_table.sgl;
+		lm_file->sg_last_entry = 0;
+	}
+
+	cur_offset = lm_file->last_offset;
+
+	for_each_sg(lm_file->last_offset_sg, sg,
+		    lm_file->sg_table.orig_nents - lm_file->sg_last_entry,
+		    i) {
+		if (offset < sg->length + cur_offset) {
+			lm_file->last_offset_sg = sg;
+			lm_file->sg_last_entry += i;
+			lm_file->last_offset = cur_offset;
+			return nth_page(sg_page(sg),
+					(offset - cur_offset) / PAGE_SIZE);
+		}
+		cur_offset += sg->length;
+	}
+
+	return NULL;
+}
+
+static int
+pds_vfio_release_file(struct inode *inode, struct file *filp)
+{
+	struct pds_vfio_lm_file *lm_file = filp->private_data;
+
+	mutex_lock(&lm_file->lock);
+	lm_file->filep->f_pos = 0;
+	lm_file->size = 0;
+	mutex_unlock(&lm_file->lock);
+	mutex_destroy(&lm_file->lock);
+	kfree(lm_file);
+
+	return 0;
+}
+
+static ssize_t
+pds_vfio_save_read(struct file *filp, char __user *buf, size_t len, loff_t *pos)
+{
+	struct pds_vfio_lm_file *lm_file = filp->private_data;
+	ssize_t done = 0;
+
+	if (pos)
+		return -ESPIPE;
+	pos = &filp->f_pos;
+
+	mutex_lock(&lm_file->lock);
+	if (*pos > lm_file->size) {
+		done = -EINVAL;
+		goto out_unlock;
+	}
+
+	len = min_t(size_t, lm_file->size - *pos, len);
+	while (len) {
+		size_t page_offset;
+		struct page *page;
+		size_t page_len;
+		u8 *from_buff;
+		int err;
+
+		page_offset = (*pos) % PAGE_SIZE;
+		page = pds_vfio_get_file_page(lm_file, *pos - page_offset);
+		if (!page) {
+			if (done == 0)
+				done = -EINVAL;
+			goto out_unlock;
+		}
+
+		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
+		from_buff = kmap_local_page(page);
+		err = copy_to_user(buf, from_buff + page_offset, page_len);
+		kunmap_local(from_buff);
+		if (err) {
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
+	mutex_unlock(&lm_file->lock);
+	return done;
+}
+
+static const struct file_operations
+pds_vfio_save_fops = {
+	.owner = THIS_MODULE,
+	.read = pds_vfio_save_read,
+	.release = pds_vfio_release_file,
+	.llseek = no_llseek,
+};
+
+static int
+pds_vfio_get_save_file(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pci_dev *pdev = pds_vfio->pdev;
+	struct pds_vfio_lm_file *lm_file;
+	int err;
+	u64 size;
+
+	/* Get live migration state size in this state */
+	err = pds_vfio_get_lm_status_cmd(pds_vfio, &size);
+	if (err) {
+		dev_err(&pdev->dev, "failed to get save status: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	dev_dbg(&pdev->dev, "save status, size = %lld\n", size);
+
+	if (!size) {
+		dev_err(&pdev->dev, "invalid state size\n");
+		return -EIO;
+	}
+
+	lm_file = pds_vfio_get_lm_file(PDS_VFIO_LM_FILENAME,
+				       &pds_vfio_save_fops,
+				       O_RDONLY, size);
+	if (!lm_file) {
+		dev_err(&pdev->dev, "failed to create save file\n");
+		return -ENOENT;
+	}
+
+	dev_dbg(&pdev->dev, "size = %lld, alloc_size = %lld, npages = %lld\n",
+		lm_file->size, lm_file->alloc_size, lm_file->npages);
+
+	pds_vfio->save_file = lm_file;
+
+	return 0;
+}
+
+static ssize_t
+pds_vfio_restore_write(struct file *filp, const char __user *buf, size_t len, loff_t *pos)
+{
+	struct pds_vfio_lm_file *lm_file = filp->private_data;
+	loff_t requested_length;
+	ssize_t done = 0;
+
+	if (pos)
+		return -ESPIPE;
+
+	pos = &filp->f_pos;
+
+	if (*pos < 0 ||
+	    check_add_overflow((loff_t)len, *pos, &requested_length))
+		return -EINVAL;
+
+	mutex_lock(&lm_file->lock);
+
+	while (len) {
+		size_t page_offset;
+		struct page *page;
+		size_t page_len;
+		u8 *to_buff;
+		int err;
+
+		page_offset = (*pos) % PAGE_SIZE;
+		page = pds_vfio_get_file_page(lm_file, *pos - page_offset);
+		if (!page) {
+			if (done == 0)
+				done = -EINVAL;
+			goto out_unlock;
+		}
+
+		page_len = min_t(size_t, len, PAGE_SIZE - page_offset);
+		to_buff = kmap_local_page(page);
+		err = copy_from_user(to_buff + page_offset, buf, page_len);
+		kunmap_local(to_buff);
+		if (err) {
+			done = -EFAULT;
+			goto out_unlock;
+		}
+		*pos += page_len;
+		len -= page_len;
+		done += page_len;
+		buf += page_len;
+		lm_file->size += page_len;
+	}
+out_unlock:
+	mutex_unlock(&lm_file->lock);
+	return done;
+}
+
+static const struct file_operations
+pds_vfio_restore_fops = {
+	.owner = THIS_MODULE,
+	.write = pds_vfio_restore_write,
+	.release = pds_vfio_release_file,
+	.llseek = no_llseek,
+};
+
+static int
+pds_vfio_get_restore_file(struct pds_vfio_pci_device *pds_vfio)
+{
+	struct pci_dev *pdev = pds_vfio->pdev;
+	struct pds_vfio_lm_file *lm_file;
+	int err = 0;
+	u64 size;
+
+	size = sizeof(union pds_lm_dev_state);
+
+	dev_dbg(&pdev->dev, "restore status, size = %lld\n", size);
+
+	if (!size) {
+		err = -EIO;
+		dev_err(&pdev->dev, "invalid state size");
+		goto err_get_lm_status;
+	}
+
+	lm_file = pds_vfio_get_lm_file(PDS_VFIO_LM_FILENAME,
+				       &pds_vfio_restore_fops,
+				       O_WRONLY, size);
+	if (!lm_file) {
+		err = -ENOENT;
+		dev_err(&pdev->dev, "failed to create restore file");
+		goto err_get_lm_file;
+	}
+	pds_vfio->restore_file = lm_file;
+
+	return 0;
+
+err_get_lm_file:
+err_get_lm_status:
+	return err;
+}
+
+struct file *
+pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
+				  enum vfio_device_mig_state next)
+{
+	enum vfio_device_mig_state cur = pds_vfio->state;
+	struct device *dev = &pds_vfio->pdev->dev;
+	int err = 0;
+
+	dev_dbg(dev, "%s => %s\n",
+		pds_vfio_lm_state(cur), pds_vfio_lm_state(next));
+
+	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_STOP_COPY) {
+		/* Device is already stopped
+		 * create save device data file & get device state from firmware
+		 */
+		err = pds_vfio_get_save_file(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		/* Get device state */
+		err = pds_vfio_get_lm_state_cmd(pds_vfio);
+		if (err) {
+			pds_vfio_put_save_file(pds_vfio);
+			return ERR_PTR(err);
+		}
+
+		return pds_vfio->save_file->filep;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP_COPY && next == VFIO_DEVICE_STATE_STOP) {
+		/* Device is already stopped
+		 * delete the save device state file
+		 */
+		pds_vfio_put_save_file(pds_vfio);
+		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
+						    PDS_LM_STA_NONE);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RESUMING) {
+		/* create resume device data file */
+		err = pds_vfio_get_restore_file(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		return pds_vfio->restore_file->filep;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RESUMING && next == VFIO_DEVICE_STATE_STOP) {
+		/* Set device state */
+		err = pds_vfio_set_lm_state_cmd(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		/* delete resume device data file */
+		pds_vfio_put_restore_file(pds_vfio);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING && next == VFIO_DEVICE_STATE_RUNNING_P2P) {
+		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_IN_PROGRESS);
+		/* Device should be stopped
+		 * no interrupts, dma or change in internal state
+		 */
+		err = pds_vfio_suspend_device_cmd(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_RUNNING) {
+		/* Device should be functional
+		 * interrupts, dma, mmio or changes to internal state is allowed
+		 */
+		err = pds_vfio_resume_device_cmd(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
+						    PDS_LM_STA_NONE);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RUNNING_P2P)
+		return NULL;
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_STOP)
+		return NULL;
+
+	return ERR_PTR(-EINVAL);
+}
diff --git a/drivers/vfio/pci/pds/lm.h b/drivers/vfio/pci/pds/lm.h
new file mode 100644
index 000000000000..7b71ee2d1e77
--- /dev/null
+++ b/drivers/vfio/pci/pds/lm.h
@@ -0,0 +1,52 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc. */
+
+#ifndef _LM_H_
+#define _LM_H_
+
+#include <linux/fs.h>
+#include <linux/mutex.h>
+#include <linux/scatterlist.h>
+#include <linux/types.h>
+
+#include <linux/pds/pds_lm.h>
+
+struct pds_vfio_lm_file {
+	struct file *filep;
+	struct mutex lock;	/* protect live migration data file */
+	u64 size;		/* Size with valid data */
+	u64 alloc_size;		/* Total allocated size. Always >= len */
+	struct page **pages;	/* Backing pages for file */
+	unsigned long long npages;
+	struct sg_table sg_table;	/* SG table for backing pages */
+	struct pds_lm_sg_elem *sgl;	/* DMA mapping */
+	dma_addr_t sgl_addr;
+	u16 num_sge;
+	struct scatterlist *last_offset_sg;	/* Iterator */
+	unsigned int sg_last_entry;
+	unsigned long last_offset;
+};
+
+struct pds_vfio_pci_device;
+
+struct file *
+pds_vfio_step_device_state_locked(struct pds_vfio_pci_device *pds_vfio,
+				  enum vfio_device_mig_state next);
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
+const char *
+pds_vfio_lm_state(enum vfio_device_mig_state state);
+void
+pds_vfio_put_save_file(struct pds_vfio_pci_device *pds_vfio);
+void
+pds_vfio_put_restore_file(struct pds_vfio_pci_device *pds_vfio);
+
+#endif /* _LM_H_ */
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index 46537afdee2d..b0781d9f4246 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -34,6 +34,7 @@ pds_vfio_pci_probe(struct pci_dev *pdev,
 
 	dev_set_drvdata(&pdev->dev, &pds_vfio->vfio_coredev);
 	pds_vfio->pdev = pdev;
+	pds_vfio->coredev = &pdev->dev;
 	pds_vfio->pdsc = pdsc_get_pf_struct(pdev);
 
 	err = pds_vfio_register_client_cmd(pds_vfio);
@@ -72,12 +73,27 @@ pds_vfio_pci_table[] = {
 };
 MODULE_DEVICE_TABLE(pci, pds_vfio_pci_table);
 
+static void
+pds_vfio_pci_aer_reset_done(struct pci_dev *pdev)
+{
+	struct pds_vfio_pci_device *pds_vfio = pds_vfio_pci_drvdata(pdev);
+
+	pds_vfio_reset(pds_vfio);
+}
+
+static const struct
+pci_error_handlers pds_vfio_pci_err_handlers = {
+	.reset_done = pds_vfio_pci_aer_reset_done,
+	.error_detected = vfio_pci_core_aer_err_detected,
+};
+
 static struct pci_driver
 pds_vfio_pci_driver = {
 	.name = PDS_VFIO_DRV_NAME,
 	.id_table = pds_vfio_pci_table,
 	.probe = pds_vfio_pci_probe,
 	.remove = pds_vfio_pci_remove,
+	.err_handler = &pds_vfio_pci_err_handlers,
 	.driver_managed_dma = true,
 };
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 056715dea512..e6d431347c26 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -4,6 +4,7 @@
 #include <linux/vfio.h>
 #include <linux/vfio_pci_core.h>
 
+#include "lm.h"
 #include "vfio_dev.h"
 
 struct pds_vfio_pci_device *
@@ -15,6 +16,103 @@ pds_vfio_pci_drvdata(struct pci_dev *pdev)
 			    vfio_coredev);
 }
 
+static void
+pds_vfio_state_mutex_unlock(struct pds_vfio_pci_device *pds_vfio)
+{
+again:
+	spin_lock(&pds_vfio->reset_lock);
+	if (pds_vfio->deferred_reset) {
+		pds_vfio->deferred_reset = false;
+		if (pds_vfio->state == VFIO_DEVICE_STATE_ERROR) {
+			pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+			pds_vfio_put_restore_file(pds_vfio);
+			pds_vfio_put_save_file(pds_vfio);
+		}
+		spin_unlock(&pds_vfio->reset_lock);
+		goto again;
+	}
+	mutex_unlock(&pds_vfio->state_mutex);
+	spin_unlock(&pds_vfio->reset_lock);
+}
+
+void
+pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio)
+{
+	spin_lock(&pds_vfio->reset_lock);
+	pds_vfio->deferred_reset = true;
+	if (!mutex_trylock(&pds_vfio->state_mutex)) {
+		spin_unlock(&pds_vfio->reset_lock);
+		return;
+	}
+	spin_unlock(&pds_vfio->reset_lock);
+	pds_vfio_state_mutex_unlock(pds_vfio);
+}
+
+static struct file *
+pds_vfio_set_device_state(struct vfio_device *vdev,
+			  enum vfio_device_mig_state new_state)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+	struct file *res = NULL;
+
+	mutex_lock(&pds_vfio->state_mutex);
+	while (new_state != pds_vfio->state) {
+		enum vfio_device_mig_state next_state;
+
+		int err = vfio_mig_get_next_state(vdev, pds_vfio->state,
+						  new_state, &next_state);
+		if (err) {
+			res = ERR_PTR(err);
+			break;
+		}
+
+		res = pds_vfio_step_device_state_locked(pds_vfio, next_state);
+		if (IS_ERR(res))
+			break;
+
+		pds_vfio->state = next_state;
+
+		if (WARN_ON(res && new_state != pds_vfio->state)) {
+			res = ERR_PTR(-EINVAL);
+			break;
+		}
+	}
+	pds_vfio_state_mutex_unlock(pds_vfio);
+
+	return res;
+}
+
+static int
+pds_vfio_get_device_state(struct vfio_device *vdev,
+			  enum vfio_device_mig_state *current_state)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+
+	mutex_lock(&pds_vfio->state_mutex);
+	*current_state = pds_vfio->state;
+	pds_vfio_state_mutex_unlock(pds_vfio);
+	return 0;
+}
+
+static int
+pds_vfio_get_device_state_size(struct vfio_device *vdev,
+			       unsigned long *stop_copy_length)
+{
+	*stop_copy_length = PDS_LM_DEVICE_STATE_LENGTH;
+	return 0;
+}
+
+static const struct vfio_migration_ops
+pds_vfio_lm_ops = {
+	.migration_set_state = pds_vfio_set_device_state,
+	.migration_get_state = pds_vfio_get_device_state,
+	.migration_get_data_size = pds_vfio_get_device_state_size
+};
+
 static int
 pds_vfio_init_device(struct vfio_device *vdev)
 {
@@ -31,6 +129,9 @@ pds_vfio_init_device(struct vfio_device *vdev)
 	pds_vfio->vf_id = pci_iov_vf_id(pdev);
 	pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
 
+	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
+	vdev->mig_ops = &pds_vfio_lm_ops;
+
 	dev_dbg(&pdev->dev, "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d pds_vfio %p\n",
 		__func__, pci_dev_id(pdev->physfn),
 		pds_vfio->pci_id, pds_vfio->pci_id, pds_vfio->vf_id,
@@ -51,18 +152,34 @@ pds_vfio_open_device(struct vfio_device *vdev)
 	if (err)
 		return err;
 
+	mutex_init(&pds_vfio->state_mutex);
+	dev_dbg(&pds_vfio->pdev->dev, "%s: %s => VFIO_DEVICE_STATE_RUNNING\n",
+		__func__, pds_vfio_lm_state(pds_vfio->state));
+	pds_vfio->state = VFIO_DEVICE_STATE_RUNNING;
+
 	vfio_pci_core_finish_enable(&pds_vfio->vfio_coredev);
 
 	return 0;
 }
 
+static void
+pds_vfio_close_device(struct vfio_device *vdev)
+{
+	struct pds_vfio_pci_device *pds_vfio =
+		container_of(vdev, struct pds_vfio_pci_device,
+			     vfio_coredev.vdev);
+
+	mutex_destroy(&pds_vfio->state_mutex);
+	vfio_pci_core_close_device(vdev);
+}
+
 static const struct vfio_device_ops
 pds_vfio_ops = {
 	.name = "pds-vfio",
 	.init = pds_vfio_init_device,
 	.release = vfio_pci_core_release_dev,
 	.open_device = pds_vfio_open_device,
-	.close_device = vfio_pci_core_close_device,
+	.close_device = pds_vfio_close_device,
 	.ioctl = vfio_pci_core_ioctl,
 	.device_feature = vfio_pci_core_ioctl_feature,
 	.read = vfio_pci_core_read,
diff --git a/drivers/vfio/pci/pds/vfio_dev.h b/drivers/vfio/pci/pds/vfio_dev.h
index 10557e8dc829..3f55861ffc7c 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -7,10 +7,20 @@
 #include <linux/pci.h>
 #include <linux/vfio_pci_core.h>
 
+#include "lm.h"
+
 struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
 	struct pci_dev *pdev;
 	void *pdsc;
+	struct device *coredev;
+
+	struct pds_vfio_lm_file *save_file;
+	struct pds_vfio_lm_file *restore_file;
+	struct mutex state_mutex; /* protect migration state */
+	enum vfio_device_mig_state state;
+	spinlock_t reset_lock; /* protect reset_done flow */
+	u8 deferred_reset;
 
 	int vf_id;
 	int pci_id;
@@ -19,5 +29,6 @@ struct pds_vfio_pci_device {
 
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
+void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
 
 #endif /* _VFIO_DEV_H_ */
diff --git a/include/linux/pds/pds_lm.h b/include/linux/pds/pds_lm.h
index 2bc2bf79426e..06c1c1bd6c66 100644
--- a/include/linux/pds/pds_lm.h
+++ b/include/linux/pds/pds_lm.h
@@ -1,12 +1,216 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-/* Copyright(c) 2022 Pensando Systems, Inc */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
 
 #ifndef _PDS_LM_H_
 #define _PDS_LM_H_
 
-#include "pds_common.h"
-
 #define PDS_DEV_TYPE_LM_STR	"LM"
 #define PDS_LM_DEV_NAME		PDS_CORE_DRV_NAME "." PDS_DEV_TYPE_LM_STR
+#define PDS_LM_DEVICE_STATE_LENGTH		65536
+#define PDS_LM_CHECK_DEVICE_STATE_LENGTH(X)					\
+			PDS_CORE_SIZE_CHECK(union, PDS_LM_DEVICE_STATE_LENGTH, X)
+
+/*
+ * enum pds_lm_cmd_opcode - Live Migration Device commands
+ */
+enum pds_lm_cmd_opcode {
+	PDS_LM_CMD_HOST_VF_STATUS  = 1,
+
+	/* Device state commands */
+	PDS_LM_CMD_STATUS          = 16,
+	PDS_LM_CMD_SUSPEND         = 18,
+	PDS_LM_CMD_SUSPEND_STATUS  = 19,
+	PDS_LM_CMD_RESUME          = 20,
+	PDS_LM_CMD_SAVE            = 21,
+	PDS_LM_CMD_RESTORE         = 22,
+};
+
+/**
+ * struct pds_lm_cmd - generic command
+ * @opcode:	Opcode
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @rsvd2:	Structure padding to 60 Bytes
+ */
+struct pds_lm_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     rsvd2[56];
+};
+
+/**
+ * struct pds_lm_comp - generic command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd:	Structure padding to 16 Bytes
+ */
+struct pds_lm_comp {
+	u8 status;
+	u8 rsvd[15];
+};
+
+/**
+ * struct pds_lm_status_cmd - STATUS command
+ * @opcode:	Opcode
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ */
+struct pds_lm_status_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_lm_status_comp - STATUS command completion
+ * @status:		Status of the command (enum pds_core_status_code)
+ * @rsvd:		Word boundary padding
+ * @comp_index:		Index in the desc ring for which this is the completion
+ * @size:		Size of the device state
+ * @rsvd2:		Word boundary padding
+ * @color:		Color bit
+ */
+struct pds_lm_status_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	union {
+		__le64 size;
+		u8     rsvd2[11];
+	} __packed;
+	u8     color;
+};
+
+/**
+ * struct pds_lm_suspend_cmd - SUSPEND command
+ * @opcode:	Opcode PDS_LM_CMD_SUSPEND
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ */
+struct pds_lm_suspend_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_lm_suspend_comp - SUSPEND command completion
+ * @status:		Status of the command (enum pds_core_status_code)
+ * @rsvd:		Word boundary padding
+ * @comp_index:		Index in the desc ring for which this is the completion
+ * @state_size:		Size of the device state computed post suspend
+ * @rsvd2:		Word boundary padding
+ * @color:		Color bit
+ */
+struct pds_lm_suspend_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	union {
+		__le64 state_size;
+		u8     rsvd2[11];
+	} __packed;
+	u8     color;
+};
+
+/**
+ * struct pds_lm_suspend_status_cmd - SUSPEND status command
+ * @opcode:	Opcode PDS_AQ_CMD_LM_SUSPEND_STATUS
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ */
+struct pds_lm_suspend_status_cmd {
+	u8 opcode;
+	u8 rsvd;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_lm_resume_cmd - RESUME command
+ * @opcode:	Opcode PDS_LM_CMD_RESUME
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ */
+struct pds_lm_resume_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+};
+
+/**
+ * struct pds_lm_sg_elem - Transmit scatter-gather (SG) descriptor element
+ * @addr:	DMA address of SG element data buffer
+ * @len:	Length of SG element data buffer, in bytes
+ * @rsvd:	Word boundary padding
+ */
+struct pds_lm_sg_elem {
+	__le64 addr;
+	__le32 len;
+	__le16 rsvd[2];
+};
+
+/**
+ * struct pds_lm_save_cmd - SAVE command
+ * @opcode:	Opcode PDS_LM_CMD_SAVE
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @rsvd2:	Word boundary padding
+ * @sgl_addr:	IOVA address of the SGL to dma the device state
+ * @num_sge:	Total number of SG elements
+ */
+struct pds_lm_save_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     rsvd2[4];
+	__le64 sgl_addr;
+	__le32 num_sge;
+} __packed;
+
+/**
+ * struct pds_lm_restore_cmd - RESTORE command
+ * @opcode:	Opcode PDS_LM_CMD_RESTORE
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @rsvd2:	Word boundary padding
+ * @sgl_addr:	IOVA address of the SGL to dma the device state
+ * @num_sge:	Total number of SG elements
+ */
+struct pds_lm_restore_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     rsvd2[4];
+	__le64 sgl_addr;
+	__le32 num_sge;
+} __packed;
+
+/**
+ * union pds_lm_dev_state - device state information
+ * @words:	Device state words
+ */
+union pds_lm_dev_state {
+	__le32 words[PDS_LM_DEVICE_STATE_LENGTH / sizeof(__le32)];
+};
+
+enum pds_lm_host_vf_status {
+	PDS_LM_STA_NONE = 0,
+	PDS_LM_STA_IN_PROGRESS,
+	PDS_LM_STA_MAX,
+};
+
+/**
+ * struct pds_lm_host_vf_status_cmd - HOST_VF_STATUS command
+ * @opcode:	Opcode PDS_LM_CMD_HOST_VF_STATUS
+ * @rsvd:	Word boundary padding
+ * @vf_id:	VF id
+ * @status:	Current LM status of host VF driver (enum pds_lm_host_status)
+ */
+struct pds_lm_host_vf_status_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 vf_id;
+	u8     status;
+};
 
 #endif /* _PDS_LM_H_ */
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42C1B6EB69D
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 03:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234144AbjDVBHp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 21:07:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234138AbjDVBHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 21:07:36 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2061.outbound.protection.outlook.com [40.107.94.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44EBC268D;
        Fri, 21 Apr 2023 18:07:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g9Fa0Z5M/lsB3rCrFne8CwzjTEgzQS3hF7mX1N4IqTmxlTdvQyLE4cjJ28CTYsKoYh195vHV5xyakVnc8a/bAecZpwSUOwdyq92qONcMv3QJO4UcUbGm02GK9CaP+1IiM/5Cb2Gk+BRHgwhDwBaYkJ8SZCWk3z3aKV5Le9jIg0juuwQNBiAdRuLtsfYI8QNh+Gs7qAUGm7xRojcXnzFu1nlRLj0d9/ytB1QrtxYzSkVvtqZaUAzgK7HKuyGx9yLXbLGQCMLqyvoXCTiL0X2IBmyctH9HK2paof2jdC8WFAjgvW3Bdirh+zTQV4bnDNo8AqBOJUoh4VWDCQS6A3bL2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NCtnbogc7SWqb/0JaQrg5HRLKm0KmsW25GfiEYYy4ro=;
 b=E1baAAx8S0s8o1DEPw864ts+9he27scZI1JFovFxBCdYdTTvc6I5vJofnA+qYf6NfgMfqABvlb9ViH3iBSZxUYu58tfM/FLf+QW1ELsYv0nA54WxXU5+XsgalRFle7vZbbMv8tfOUxkrYANkWstfV9niZUTDBq9s4QSVl3THmB0PnyL2WgP6i5Tvgi3EH0hU9UwJQTs/8hVqzKpLh6FVb0Ab8rcXHoREZU83/ZuM3Ex2MS+XpO+aizhZSSx0hTET1J3mJmz2U+B/9saX4K982M7nKi1qsFX0yjIlMMHVFpi74klln7f7MrflWUxbyj9654WlMHfvTYcl2QQMYFWhVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NCtnbogc7SWqb/0JaQrg5HRLKm0KmsW25GfiEYYy4ro=;
 b=4BHu2+8Cw/NMsPRsBPihDimIpYZGdlzK+tJ4674+mDfg2Mpyj1RhyGGk0fEJwFvZ7P+iZxh5XnIRUKaiGaf9/ImLkc9g/mjcp4XMhBsXCCi5Mqba8DG9rnR+VHKlhkDmdaxldfoVVudhfD/6R4/t9Om8a7kR8VkLrvjXPHEN+yA=
Received: from BN9PR03CA0908.namprd03.prod.outlook.com (2603:10b6:408:107::13)
 by SJ2PR12MB8036.namprd12.prod.outlook.com (2603:10b6:a03:4c1::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Sat, 22 Apr
 2023 01:07:15 +0000
Received: from BN8NAM11FT074.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:107:cafe::f6) by BN9PR03CA0908.outlook.office365.com
 (2603:10b6:408:107::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.27 via Frontend
 Transport; Sat, 22 Apr 2023 01:07:15 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT074.mail.protection.outlook.com (10.13.176.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.27 via Frontend Transport; Sat, 22 Apr 2023 01:07:15 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 21 Apr
 2023 20:07:13 -0500
From:   Brett Creeley <brett.creeley@amd.com>
To:     <kvm@vger.kernel.org>, <netdev@vger.kernel.org>,
        <alex.williamson@redhat.com>, <jgg@nvidia.com>,
        <yishaih@nvidia.com>, <shameerali.kolothum.thodi@huawei.com>,
        <kevin.tian@intel.com>
CC:     <brett.creeley@amd.com>, <shannon.nelson@amd.com>,
        <drivers@pensando.io>
Subject: [PATCH v9 vfio 4/7] vfio/pds: Add VFIO live migration support
Date:   Fri, 21 Apr 2023 18:06:39 -0700
Message-ID: <20230422010642.60720-5-brett.creeley@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT074:EE_|SJ2PR12MB8036:EE_
X-MS-Office365-Filtering-Correlation-Id: 5a886db4-c663-43b2-cf96-08db42cde93d
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WgM+mxX9hQeRNZfQjt2Y7db1cYisM1bB4za4QGcr2i19NnAzC4rIfrRoKAXcIBIVr4WQLRKmPckXecX3V3t8A5ODJBODnA8+/D6y3AjCkNg/IYVPBVUFsVnQNh41KifGBAKnx/FWdnmGxVUKgF4r111yNXkr4J1IjPUYKyXNC29Km/5NGzxvYtLvY5UbivkHNcksuzP64IxMwumGPoiCiq+yBHr07bOMuff+pw7UzPzao22unzTJk8ESf3QE3qJgriCT8pFRF2FK4hqRbpMXMeTapsTF5/kINHtHmQjIBVRHTgO6o9HBVoA9TrDDflyO8alp8zTGcQBcKLq9qf4lWlaT67qHSojWym+7uoxiktT4azbIM9U2FsM/+c2cbmdEX+o38NCI1yTXCLh9vBkE36cg61XD8/8lnUpgqU4jEoW9THfHZsY0StSND6KgVAq7OdukvQDrN2PImGr05WpbYrAGHevvya2w0/tZOrGg9sTO92eGj0OH6pNACHeulUUlNDpdTZ1sH4BouDKEWxq0VeFmQloRIEB34bmvy744j0szAqX2NFWG5jDhy9EpN6TzLgsGubDHCIREY6t3E+TMUc90bC7ofjeKOvEZ3Z3HxyVDOSlDLp4y3AkAoeSfiMxwQqwsWVU6l7KS6q2iVp4zKrk/6GpeuWi6phsCUmWlwXERB4Q09e4sQZAAVKt0VMaeGGUEsn+MJfCtIKtQu+3wrSa4LzkugBqcxzTxrxTXlKM=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199021)(40470700004)(46966006)(36840700001)(478600001)(6666004)(8936002)(8676002)(316002)(82740400003)(41300700001)(4326008)(70586007)(40480700001)(70206006)(54906003)(110136005)(81166007)(356005)(40460700003)(186003)(30864003)(2906002)(16526019)(83380400001)(1076003)(26005)(426003)(336012)(47076005)(82310400005)(36756003)(36860700001)(5660300002)(86362001)(2616005)(44832011)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2023 01:07:15.1615
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a886db4-c663-43b2-cf96-08db42cde93d
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT074.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR12MB8036
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
 drivers/vfio/pci/pds/cmds.c     | 316 +++++++++++++++++++++++
 drivers/vfio/pci/pds/cmds.h     |   8 +-
 drivers/vfio/pci/pds/lm.c       | 437 ++++++++++++++++++++++++++++++++
 drivers/vfio/pci/pds/lm.h       |  41 +++
 drivers/vfio/pci/pds/pci_drv.c  |  15 ++
 drivers/vfio/pci/pds/vfio_dev.c | 127 +++++++++-
 drivers/vfio/pci/pds/vfio_dev.h |  11 +
 include/linux/pds/pds_adminq.h  |  12 +
 include/linux/pds/pds_lm.h      | 206 +++++++++++++++
 10 files changed, 1172 insertions(+), 2 deletions(-)
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
index 29a350cb5df5..b51873dace96 100644
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
+pds_vfio_client_adminq_cmd(struct pds_vfio_pci_device *pds_vfio,
+			   union pds_core_adminq_cmd *req,
+			   size_t req_len,
+			   union pds_core_adminq_comp *resp,
+			   u64 flags)
+{
+	union pds_core_adminq_cmd cmd = {};
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
+		dev_info(pds_vfio_to_dev(pds_vfio), "client admin cmd failed: %pe\n",
+			 ERR_PTR(err));
+
+	return err;
+}
+
 int
 pds_vfio_register_client_cmd(struct pds_vfio_pci_device *pds_vfio)
 {
@@ -45,3 +75,289 @@ pds_vfio_unregister_client_cmd(struct pds_vfio_pci_device *pds_vfio)
 
 	pds_vfio->client_id = 0;
 }
+
+static int
+pds_vfio_suspend_wait_device_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_suspend_status.opcode = PDS_LM_CMD_SUSPEND_STATUS,
+		.lm_suspend_status.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	unsigned long time_limit;
+	unsigned long time_start;
+	unsigned long time_done;
+	int err;
+
+	time_start = jiffies;
+	time_limit = time_start + HZ * SUSPEND_TIMEOUT_S;
+	do {
+		err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+						 &comp, PDS_AQ_FLAG_FASTPOLL);
+		if (err != -EAGAIN)
+			break;
+
+		msleep(SUSPEND_CHECK_INTERVAL_MS);
+	} while (time_before(jiffies, time_limit));
+
+	time_done = jiffies;
+	dev_dbg(dev, "%s: vf%u: Suspend comp received in %d msecs\n",
+		__func__, pds_vfio->vf_id,
+		jiffies_to_msecs(time_done - time_start));
+
+	/* Check the results */
+	if (time_after_eq(time_done, time_limit)) {
+		dev_err(dev, "%s: vf%u: Suspend comp timeout\n", __func__,
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
+	union pds_core_adminq_cmd cmd = {
+		.lm_suspend.opcode = PDS_LM_CMD_SUSPEND,
+		.lm_suspend.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	dev_dbg(dev, "vf%u: Suspend device\n", pds_vfio->vf_id);
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+					 &comp, PDS_AQ_FLAG_FASTPOLL);
+	if (err) {
+		dev_err(dev, "vf%u: Suspend failed: %pe\n",
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
+	union pds_core_adminq_cmd cmd = {
+		.lm_resume.opcode = PDS_LM_CMD_RESUME,
+		.lm_resume.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+
+	dev_dbg(dev, "vf%u: Resume device\n", pds_vfio->vf_id);
+
+	return pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+					  &comp, 0);
+}
+
+int
+pds_vfio_get_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio, u64 *size)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_status.opcode = PDS_LM_CMD_STATUS,
+		.lm_status.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	dev_dbg(dev, "vf%u: Get migration status\n",
+		pds_vfio->vf_id);
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+					 &comp, 0);
+	if (err)
+		return err;
+
+	*size = le64_to_cpu(comp.lm_status.size);
+	return 0;
+}
+
+static int
+pds_vfio_dma_map_lm_file(struct device *dev, enum dma_data_direction dir,
+			 struct pds_vfio_lm_file *lm_file)
+{
+	struct pds_lm_sg_elem *sgl, *sge;
+	struct scatterlist *sg;
+	dma_addr_t sgl_addr;
+	size_t sgl_size;
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
+	sgl_size = lm_file->num_sge * sizeof(struct pds_lm_sg_elem);
+	sgl = kzalloc(sgl_size, GFP_KERNEL);
+	if (!sgl) {
+		err = -ENOMEM;
+		goto err_alloc_sgl;
+	}
+
+	sgl_addr = dma_map_single(dev, sgl, sgl_size, DMA_TO_DEVICE);
+	if (dma_mapping_error(dev, sgl_addr)) {
+		err = -EIO;
+		goto err_map_sgl;
+	}
+
+	lm_file->sgl = sgl;
+	lm_file->sgl_addr = sgl_addr;
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
+err_map_sgl:
+	kfree(sgl);
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
+		dma_unmap_single(dev, lm_file->sgl_addr,
+				 lm_file->num_sge * sizeof(struct pds_lm_sg_elem),
+				 DMA_TO_DEVICE);
+		kfree(lm_file->sgl);
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
+	union pds_core_adminq_cmd cmd = {
+		.lm_save.opcode = PDS_LM_CMD_SAVE,
+		.lm_save.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	union pds_core_adminq_comp comp = {};
+	struct pds_vfio_lm_file *lm_file;
+	int err;
+
+	dev_dbg(&pdev->dev, "vf%u: Get migration state\n", pds_vfio->vf_id);
+
+	lm_file = pds_vfio->save_file;
+
+	err = pds_vfio_dma_map_lm_file(pdsc_dev, DMA_FROM_DEVICE, lm_file);
+	if (err) {
+		dev_err(&pdev->dev, "failed to map save migration file: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	cmd.lm_save.sgl_addr = cpu_to_le64(lm_file->sgl_addr);
+	cmd.lm_save.num_sge = cpu_to_le32(lm_file->num_sge);
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+					 &comp, 0);
+	if (err)
+		dev_err(&pdev->dev, "failed to get migration state: %pe\n",
+			ERR_PTR(err));
+
+	pds_vfio_dma_unmap_lm_file(pdsc_dev, DMA_FROM_DEVICE, lm_file);
+
+	return err;
+}
+
+int
+pds_vfio_set_lm_state_cmd(struct pds_vfio_pci_device *pds_vfio)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_restore.opcode = PDS_LM_CMD_RESTORE,
+		.lm_restore.vf_id = cpu_to_le16(pds_vfio->vf_id),
+	};
+	struct pci_dev *pdev = pds_vfio_to_pci_dev(pds_vfio);
+	struct device *pdsc_dev = &pci_physfn(pdev)->dev;
+	union pds_core_adminq_comp comp = {};
+	struct pds_vfio_lm_file *lm_file;
+	int err;
+
+	dev_dbg(&pdev->dev, "vf%u: Set migration state\n", pds_vfio->vf_id);
+
+	lm_file = pds_vfio->restore_file;
+
+	err = pds_vfio_dma_map_lm_file(pdsc_dev, DMA_TO_DEVICE, lm_file);
+	if (err) {
+		dev_err(&pdev->dev, "failed to map restore migration file: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	cmd.lm_restore.sgl_addr = cpu_to_le64(lm_file->sgl_addr);
+	cmd.lm_restore.num_sge = cpu_to_le32(lm_file->num_sge);
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+					 &comp, 0);
+	if (err)
+		dev_err(&pdev->dev, "failed to set migration state: %pe\n",
+			ERR_PTR(err));
+
+	pds_vfio_dma_unmap_lm_file(pdsc_dev, DMA_TO_DEVICE, lm_file);
+
+	return err;
+}
+
+void
+pds_vfio_send_host_vf_lm_status_cmd(struct pds_vfio_pci_device *pds_vfio,
+				    enum pds_lm_host_vf_status vf_status)
+{
+	union pds_core_adminq_cmd cmd = {
+		.lm_host_vf_status.opcode = PDS_LM_CMD_HOST_VF_STATUS,
+		.lm_host_vf_status.vf_id = cpu_to_le16(pds_vfio->vf_id),
+		.lm_host_vf_status.status = vf_status,
+	};
+	struct device *dev = pds_vfio_to_dev(pds_vfio);
+	union pds_core_adminq_comp comp = {};
+	int err;
+
+	dev_dbg(dev, "vf%u: Set host VF LM status: %u",
+		pds_vfio->vf_id, vf_status);
+	if (vf_status != PDS_LM_STA_IN_PROGRESS &&
+	    vf_status != PDS_LM_STA_NONE) {
+		dev_warn(dev, "Invalid host VF migration status, %d\n",
+			 vf_status);
+		return;
+	}
+
+	err = pds_vfio_client_adminq_cmd(pds_vfio, &cmd, sizeof(cmd),
+					 &comp, 0);
+	if (err)
+		dev_warn(dev, "failed to send host VF migration status: %pe\n",
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
index 000000000000..4e736f415df2
--- /dev/null
+++ b/drivers/vfio/pci/pds/lm.c
@@ -0,0 +1,437 @@
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
+static struct pds_vfio_lm_file *
+pds_vfio_get_lm_file(const struct file_operations *fops, int flags, u64 size)
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
+	lm_file->filep = anon_inode_getfile("pds_vfio_lm", fops, lm_file, flags);
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
+	/* prevent file from being released before we are done with it */
+	get_file(lm_file->filep);
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
+	/* Free scatter list of file pages */
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
+
+	/* allow file to be released since we are done with it */
+	fput(lm_file->filep);
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
+	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
+	struct pds_vfio_lm_file *lm_file;
+	int err;
+	u64 size;
+
+	/* Get live migration state size in this state */
+	err = pds_vfio_get_lm_status_cmd(pds_vfio, &size);
+	if (err) {
+		dev_err(dev, "failed to get save status: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	dev_dbg(dev, "save status, size = %lld\n", size);
+
+	if (!size) {
+		dev_err(dev, "invalid state size\n");
+		return -EIO;
+	}
+
+	lm_file = pds_vfio_get_lm_file(&pds_vfio_save_fops,
+				       O_RDONLY, size);
+	if (!lm_file) {
+		dev_err(dev, "failed to create save file\n");
+		return -ENOENT;
+	}
+
+	dev_dbg(dev, "size = %lld, alloc_size = %lld, npages = %lld\n",
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
+	struct device *dev = &pds_vfio->vfio_coredev.pdev->dev;
+	struct pds_vfio_lm_file *lm_file;
+	int err = 0;
+	u64 size;
+
+	size = sizeof(union pds_lm_dev_state);
+
+	dev_dbg(dev, "restore status, size = %lld\n", size);
+
+	if (!size) {
+		err = -EIO;
+		dev_err(dev, "invalid state size");
+		goto err_get_lm_status;
+	}
+
+	lm_file = pds_vfio_get_lm_file(&pds_vfio_restore_fops,
+				       O_WRONLY, size);
+	if (!lm_file) {
+		err = -ENOENT;
+		dev_err(dev, "failed to create restore file");
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
+	int err;
+
+	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_STOP_COPY) {
+		err = pds_vfio_get_save_file(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
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
+		pds_vfio_put_save_file(pds_vfio);
+		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio,
+						    PDS_LM_STA_NONE);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_STOP && next == VFIO_DEVICE_STATE_RESUMING) {
+		err = pds_vfio_get_restore_file(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		return pds_vfio->restore_file->filep;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RESUMING && next == VFIO_DEVICE_STATE_STOP) {
+		err = pds_vfio_set_lm_state_cmd(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		pds_vfio_put_restore_file(pds_vfio);
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING && next == VFIO_DEVICE_STATE_RUNNING_P2P) {
+		pds_vfio_send_host_vf_lm_status_cmd(pds_vfio, PDS_LM_STA_IN_PROGRESS);
+		err = pds_vfio_suspend_device_cmd(pds_vfio);
+		if (err)
+			return ERR_PTR(err);
+
+		return NULL;
+	}
+
+	if (cur == VFIO_DEVICE_STATE_RUNNING_P2P && next == VFIO_DEVICE_STATE_RUNNING) {
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
index 000000000000..72d439819994
--- /dev/null
+++ b/drivers/vfio/pci/pds/lm.h
@@ -0,0 +1,41 @@
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
+
+void
+pds_vfio_put_save_file(struct pds_vfio_pci_device *pds_vfio);
+void
+pds_vfio_put_restore_file(struct pds_vfio_pci_device *pds_vfio);
+
+#endif /* _LM_H_ */
diff --git a/drivers/vfio/pci/pds/pci_drv.c b/drivers/vfio/pci/pds/pci_drv.c
index dca7d457bd8c..91d9a66d847a 100644
--- a/drivers/vfio/pci/pds/pci_drv.c
+++ b/drivers/vfio/pci/pds/pci_drv.c
@@ -75,12 +75,27 @@ pds_vfio_pci_table[] = {
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
 	.name = KBUILD_MODNAME,
 	.id_table = pds_vfio_pci_table,
 	.probe = pds_vfio_pci_probe,
 	.remove = pds_vfio_pci_remove,
+	.err_handler = &pds_vfio_pci_err_handlers,
 	.driver_managed_dma = true,
 };
 
diff --git a/drivers/vfio/pci/pds/vfio_dev.c b/drivers/vfio/pci/pds/vfio_dev.c
index 228b27a0aa60..0c6e6c645f34 100644
--- a/drivers/vfio/pci/pds/vfio_dev.c
+++ b/drivers/vfio/pci/pds/vfio_dev.c
@@ -4,6 +4,7 @@
 #include <linux/vfio.h>
 #include <linux/vfio_pci_core.h>
 
+#include "lm.h"
 #include "vfio_dev.h"
 
 struct pci_dev *
@@ -12,6 +13,12 @@ pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio)
 	return  pds_vfio->vfio_coredev.pdev;
 }
 
+struct device *
+pds_vfio_to_dev(struct pds_vfio_pci_device *pds_vfio)
+{
+	return &pds_vfio_to_pci_dev(pds_vfio)->dev;
+}
+
 struct pds_vfio_pci_device *
 pds_vfio_pci_drvdata(struct pci_dev *pdev)
 {
@@ -21,6 +28,103 @@ pds_vfio_pci_drvdata(struct pci_dev *pdev)
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
@@ -37,6 +141,9 @@ pds_vfio_init_device(struct vfio_device *vdev)
 	pds_vfio->vf_id = pci_iov_vf_id(pdev);
 	pds_vfio->pci_id = PCI_DEVID(pdev->bus->number, pdev->devfn);
 
+	vdev->migration_flags = VFIO_MIGRATION_STOP_COPY | VFIO_MIGRATION_P2P;
+	vdev->mig_ops = &pds_vfio_lm_ops;
+
 	dev_dbg(&pdev->dev, "%s: PF %#04x VF %#04x (%d) vf_id %d domain %d pds_vfio %p\n",
 		__func__, pci_dev_id(pdev->physfn),
 		pds_vfio->pci_id, pds_vfio->pci_id, pds_vfio->vf_id,
@@ -57,18 +164,36 @@ pds_vfio_open_device(struct vfio_device *vdev)
 	if (err)
 		return err;
 
+	mutex_init(&pds_vfio->state_mutex);
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
+	mutex_lock(&pds_vfio->state_mutex);
+	pds_vfio_put_restore_file(pds_vfio);
+	pds_vfio_put_save_file(pds_vfio);
+	mutex_unlock(&pds_vfio->state_mutex);
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
index 92e8ff241ca8..df6208a7140b 100644
--- a/drivers/vfio/pci/pds/vfio_dev.h
+++ b/drivers/vfio/pci/pds/vfio_dev.h
@@ -7,12 +7,21 @@
 #include <linux/pci.h>
 #include <linux/vfio_pci_core.h>
 
+#include "lm.h"
+
 struct pdsc;
 
 struct pds_vfio_pci_device {
 	struct vfio_pci_core_device vfio_coredev;
 	struct pdsc *pdsc;
 
+	struct pds_vfio_lm_file *save_file;
+	struct pds_vfio_lm_file *restore_file;
+	struct mutex state_mutex; /* protect migration state */
+	enum vfio_device_mig_state state;
+	spinlock_t reset_lock; /* protect reset_done flow */
+	u8 deferred_reset;
+
 	int vf_id;
 	int pci_id;
 	u16 client_id;
@@ -20,7 +29,9 @@ struct pds_vfio_pci_device {
 
 const struct vfio_device_ops *pds_vfio_ops_info(void);
 struct pds_vfio_pci_device *pds_vfio_pci_drvdata(struct pci_dev *pdev);
+void pds_vfio_reset(struct pds_vfio_pci_device *pds_vfio);
 
 struct pci_dev *pds_vfio_to_pci_dev(struct pds_vfio_pci_device *pds_vfio);
+struct device *pds_vfio_to_dev(struct pds_vfio_pci_device *pds_vfio);
 
 #endif /* _VFIO_DEV_H_ */
diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
index 98a60ce87b92..897b966c52ea 100644
--- a/include/linux/pds/pds_adminq.h
+++ b/include/linux/pds/pds_adminq.h
@@ -4,6 +4,8 @@
 #ifndef _PDS_CORE_ADMINQ_H_
 #define _PDS_CORE_ADMINQ_H_
 
+#include "pds_lm.h"
+
 #define PDSC_ADMINQ_MAX_POLL_INTERVAL	256
 
 enum pds_core_adminq_flags {
@@ -600,6 +602,14 @@ union pds_core_adminq_cmd {
 
 	struct pds_core_q_identify_cmd    q_ident;
 	struct pds_core_q_init_cmd        q_init;
+
+	struct pds_lm_suspend_cmd		lm_suspend;
+	struct pds_lm_suspend_status_cmd	lm_suspend_status;
+	struct pds_lm_resume_cmd		lm_resume;
+	struct pds_lm_status_cmd		lm_status;
+	struct pds_lm_save_cmd			lm_save;
+	struct pds_lm_restore_cmd		lm_restore;
+	struct pds_lm_host_vf_status_cmd	lm_host_vf_status;
 };
 
 union pds_core_adminq_comp {
@@ -621,6 +631,8 @@ union pds_core_adminq_comp {
 
 	struct pds_core_q_identify_comp   q_ident;
 	struct pds_core_q_init_comp       q_init;
+
+	struct pds_lm_status_comp		lm_status;
 };
 
 #ifndef __CHECKER__
diff --git a/include/linux/pds/pds_lm.h b/include/linux/pds/pds_lm.h
index 26d17efeff28..f1b0beb3c87b 100644
--- a/include/linux/pds/pds_lm.h
+++ b/include/linux/pds/pds_lm.h
@@ -7,5 +7,211 @@
 #include "pds_common.h"
 
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


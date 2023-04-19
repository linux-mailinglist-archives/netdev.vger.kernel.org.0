Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C572B6E8015
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbjDSRFp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233528AbjDSRFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:33 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2087.outbound.protection.outlook.com [40.107.243.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F859769D
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A+2jz+CfhiQJWgGQKz1PqhSpm1RhfzoBIRlvzVM6ab1eL687WwubJN2zPF9eqqvksdQgt5ec8z7Hqb5XN3U0C4c1ig5rSHkzaNg4/PfJXk9FnwIkObd9PLkBt/Puf2je3MAlLwYm/cz7B3UomneIvlQd+RpnUyrTgsF/VlY7qSAL9xaFVUYNVMqkBmAEXEFWnhRbBzLG8FIVNo0wqyj/66u9LYPo7HB33YWDVvzJnPXcRx0gP7qbNjgohRdzfDqJ0E6qQ3/gMzGydqjnVe3JR8kRpp4Pb9EUTd/CIYNlq5gjOQKkhUWKU4tt7pWBEEmVAKsVpyXiJUz52G4NMVyoLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Udb8UI3hq1SVy8WjFkAVKbWVP8aCKdvNJuTL6M8EmRk=;
 b=DwvCW26wnuYwRHp5E+ufX2Kp6Uws1cgdtPpgRS19Evbf9gN9y/fcIP5u0ceQznfoBWM4ExwfYGFF0fLdQ68HLWIclhVP9dBBwxJ/clsRQib2d+zmC+UNku1LEkeOe2l1WTBUiZeo1Lbbxf2yqZ5prhJQOtCKk8DUeNZMRWYq6arHmHa1CC9Wzn4SYTu3cwAHZFWotpYeTaBmWBJnXgeeI7b5cOKJS3JzoQykq9sTFMWldN+LAQGotFfsF94IEoHo+ufFG5Wc1117DzXNCIzhE2EXGZBCzmojyXHHNw3peJ9GqcGogEnez7pwp7vQuFzf2271gqh5gWdosPr3dSrOLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Udb8UI3hq1SVy8WjFkAVKbWVP8aCKdvNJuTL6M8EmRk=;
 b=xosh/fa5tzr9/wp5nirL7+VA1IBDuAshN3S3iUyA5mVoUI6HgP9TwjxTW/3MTj/HXP579pWn5HkLKVfSrMxj8Zysvcd92A3f1kolNwp+iTJS7i9LC1VuCkAKPl6B39bAFUGZKTt+//B2w/rLrICmyoecRZcgdep6MW/DHje5y4I=
Received: from BN9PR03CA0406.namprd03.prod.outlook.com (2603:10b6:408:111::21)
 by BY5PR12MB4999.namprd12.prod.outlook.com (2603:10b6:a03:1da::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Wed, 19 Apr
 2023 17:05:24 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::6e) by BN9PR03CA0406.outlook.office365.com
 (2603:10b6:408:111::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.47 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:23 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 17:05:23 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:05:15 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 05/14] pds_core: set up device and adminq
Date:   Wed, 19 Apr 2023 10:04:18 -0700
Message-ID: <20230419170427.1108-6-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT066:EE_|BY5PR12MB4999:EE_
X-MS-Office365-Filtering-Correlation-Id: 4147ae8f-d3b8-4848-c076-08db40f843b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gu1v4qtbjyU75u5U8kmV0rQ0qJG6h5kivhB5V+wVcE29jE/CPCggjgUrBxdB1KTQl0zl2KBJW9gsnRC5uaSAKd0uxAq/H2S7Qm1Az5r1aT+aI1UM6q5gJEPgk01n2bY+l1j1gr+Hmsp+PqxEUqTbDHRJQICCEMzNUPqh6Gt2rCK9+vMOAZeklvwkdE3HZe9DHrHAG8eP09MULzxlLa6q/UXhkPiZfgG/On4VXbibgJd981ozbFp/uDk4ClwXpMnZ7nFZZ5gVahE35Axj1OLpA9uVqUQjuxPjmReusXTmpR3RR1L00OQ4CISHgFUT/r4YZ9ml/V0qXUQ7y9wLp8WSKw6+xYg9BFnVAwG7kjAe3IXQUqK3GdJFAbslNnpJvGAMw32VyopAGpxK7EqHgPdRXswFqrbvquPfk64BVGk0a3yOGgI+keaHDpSKIfMMBgBKYXbH1EDF5AfB84Iqkk8VrAtpP81JLQfswKFHkeMEJk3xOKxMK11C2eGhImgB/Zn2s2KxNDTO0QNWOGmOXXoSyRO+BSnIuHByzNkF5H0KmRx5k7j+3nppIMzElc8NetkcNwPbUiUbfqsCXDW5ykipp+R4p5pxI1vGL5Si/TsnDQKpQP+9podcTsIIg81rJUvQjBwb5I7F0v64UedH3k77j930SaykI3WGEdvx9jWyWYaBvBKbjiIRoI6G6VsTNlk94/zc/r4dt0n1mJiSiKU7cjDkb+Q88LI6PzopJcbEa94=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(39860400002)(136003)(396003)(451199021)(36840700001)(46966006)(40470700004)(86362001)(4326008)(316002)(110136005)(70586007)(41300700001)(54906003)(8676002)(70206006)(478600001)(36756003)(40480700001)(5660300002)(8936002)(82310400005)(2906002)(44832011)(30864003)(356005)(36860700001)(81166007)(82740400003)(16526019)(186003)(2616005)(26005)(1076003)(336012)(47076005)(426003)(83380400001)(40460700003)(36900700001)(579004);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:05:23.4509
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 4147ae8f-d3b8-4848-c076-08db40f843b3
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4999
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

Set up the basic adminq and notifyq queue structures.  These are
used mostly by the client drivers for feature configuration.
These are essentially the same adminq and notifyq as in the
ionic driver.

Part of this includes querying for device identity and FW
information, so we can make that available to devlink dev info.

  $ devlink dev info pci/0000:b5:00.0
  pci/0000:b5:00.0:
    driver pds_core
    serial_number FLM18420073
    versions:
        fixed:
          asic.id 0x0
          asic.rev 0x0
        running:
          fw 1.51.0-73
        stored:
          fw.goldfw 1.15.9-C-22
          fw.mainfwa 1.60.0-73
          fw.mainfwb 1.60.0-57

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 .../device_drivers/ethernet/amd/pds_core.rst  |  47 ++
 drivers/net/ethernet/amd/pds_core/core.c      | 431 +++++++++++-
 drivers/net/ethernet/amd/pds_core/core.h      | 151 +++++
 drivers/net/ethernet/amd/pds_core/debugfs.c   |  77 +++
 drivers/net/ethernet/amd/pds_core/devlink.c   |  61 ++
 drivers/net/ethernet/amd/pds_core/main.c      |  17 +-
 include/linux/pds/pds_adminq.h                | 638 ++++++++++++++++++
 7 files changed, 1418 insertions(+), 4 deletions(-)
 create mode 100644 include/linux/pds/pds_adminq.h

diff --git a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
index 5b88173a20ff..a48eafb3d0d3 100644
--- a/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
+++ b/Documentation/networking/device_drivers/ethernet/amd/pds_core.rst
@@ -26,6 +26,53 @@ messages such as these::
   pds_core 0000:b6:00.0: 252.048 Gb/s available PCIe bandwidth (16.0 GT/s PCIe x16 link)
   pds_core 0000:b6:00.0: FW: 1.60.0-73
 
+Driver and firmware version information can be gathered with devlink::
+
+  $ devlink dev info pci/0000:b5:00.0
+  pci/0000:b5:00.0:
+    driver pds_core
+    serial_number FLM18420073
+    versions:
+        fixed:
+          asic.id 0x0
+          asic.rev 0x0
+        running:
+          fw 1.51.0-73
+        stored:
+          fw.goldfw 1.15.9-C-22
+          fw.mainfwa 1.60.0-73
+          fw.mainfwb 1.60.0-57
+
+Info versions
+=============
+
+The ``pds_core`` driver reports the following versions
+
+.. list-table:: devlink info versions implemented
+   :widths: 5 5 90
+
+   * - Name
+     - Type
+     - Description
+   * - ``fw``
+     - running
+     - Version of firmware running on the device
+   * - ``fw.goldfw``
+     - stored
+     - Version of firmware stored in the goldfw slot
+   * - ``fw.mainfwa``
+     - stored
+     - Version of firmware stored in the mainfwa slot
+   * - ``fw.mainfwb``
+     - stored
+     - Version of firmware stored in the mainfwb slot
+   * - ``asic.id``
+     - fixed
+     - The ASIC type for this device
+   * - ``asic.rev``
+     - fixed
+     - The revision of the ASIC for this device
+
 Health Reporters
 ================
 
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index ab8531386226..8c0dbdb5efc5 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -1,10 +1,365 @@
 // SPDX-License-Identifier: GPL-2.0
 /* Copyright(c) 2023 Advanced Micro Devices, Inc */
 
+#include <linux/pci.h>
+#include <linux/vmalloc.h>
+
 #include "core.h"
 
+void pdsc_work_thread(struct work_struct *work)
+{
+	/* stub */
+}
+
+irqreturn_t pdsc_adminq_isr(int irq, void *data)
+{
+	/* stub */
+	return IRQ_HANDLED;
+}
+
+void pdsc_intr_free(struct pdsc *pdsc, int index)
+{
+	struct pdsc_intr_info *intr_info;
+
+	if (index >= pdsc->nintrs || index < 0) {
+		WARN(true, "bad intr index %d\n", index);
+		return;
+	}
+
+	intr_info = &pdsc->intr_info[index];
+	if (!intr_info->vector)
+		return;
+	dev_dbg(pdsc->dev, "%s: idx %d vec %d name %s\n",
+		__func__, index, intr_info->vector, intr_info->name);
+
+	pds_core_intr_mask(&pdsc->intr_ctrl[index], PDS_CORE_INTR_MASK_SET);
+	pds_core_intr_clean(&pdsc->intr_ctrl[index]);
+
+	free_irq(intr_info->vector, intr_info->data);
+
+	memset(intr_info, 0, sizeof(*intr_info));
+}
+
+int pdsc_intr_alloc(struct pdsc *pdsc, char *name,
+		    irq_handler_t handler, void *data)
+{
+	struct pdsc_intr_info *intr_info;
+	unsigned int index;
+	int err;
+
+	/* Find the first available interrupt */
+	for (index = 0; index < pdsc->nintrs; index++)
+		if (!pdsc->intr_info[index].vector)
+			break;
+	if (index >= pdsc->nintrs) {
+		dev_warn(pdsc->dev, "%s: no intr, index=%d nintrs=%d\n",
+			 __func__, index, pdsc->nintrs);
+		return -ENOSPC;
+	}
+
+	pds_core_intr_clean_flags(&pdsc->intr_ctrl[index],
+				  PDS_CORE_INTR_CRED_RESET_COALESCE);
+
+	intr_info = &pdsc->intr_info[index];
+
+	intr_info->index = index;
+	intr_info->data = data;
+	strscpy(intr_info->name, name, sizeof(intr_info->name));
+
+	/* Get the OS vector number for the interrupt */
+	err = pci_irq_vector(pdsc->pdev, index);
+	if (err < 0) {
+		dev_err(pdsc->dev, "failed to get intr vector index %d: %pe\n",
+			index, ERR_PTR(err));
+		goto err_out_free_intr;
+	}
+	intr_info->vector = err;
+
+	/* Init the device's intr mask */
+	pds_core_intr_clean(&pdsc->intr_ctrl[index]);
+	pds_core_intr_mask_assert(&pdsc->intr_ctrl[index], 1);
+	pds_core_intr_mask(&pdsc->intr_ctrl[index], PDS_CORE_INTR_MASK_SET);
+
+	/* Register the isr with a name */
+	err = request_irq(intr_info->vector, handler, 0, intr_info->name, data);
+	if (err) {
+		dev_err(pdsc->dev, "failed to get intr irq vector %d: %pe\n",
+			intr_info->vector, ERR_PTR(err));
+		goto err_out_free_intr;
+	}
+
+	return index;
+
+err_out_free_intr:
+	pdsc_intr_free(pdsc, index);
+	return err;
+}
+
+static void pdsc_qcq_intr_free(struct pdsc *pdsc, struct pdsc_qcq *qcq)
+{
+	if (!(qcq->flags & PDS_CORE_QCQ_F_INTR) ||
+	    qcq->intx == PDS_CORE_INTR_INDEX_NOT_ASSIGNED)
+		return;
+
+	pdsc_intr_free(pdsc, qcq->intx);
+	qcq->intx = PDS_CORE_INTR_INDEX_NOT_ASSIGNED;
+}
+
+static int pdsc_qcq_intr_alloc(struct pdsc *pdsc, struct pdsc_qcq *qcq)
+{
+	char name[PDSC_INTR_NAME_MAX_SZ];
+	int index;
+
+	if (!(qcq->flags & PDS_CORE_QCQ_F_INTR)) {
+		qcq->intx = PDS_CORE_INTR_INDEX_NOT_ASSIGNED;
+		return 0;
+	}
+
+	snprintf(name, sizeof(name), "%s-%d-%s",
+		 PDS_CORE_DRV_NAME, pdsc->pdev->bus->number, qcq->q.name);
+	index = pdsc_intr_alloc(pdsc, name, pdsc_adminq_isr, qcq);
+	if (index < 0)
+		return index;
+	qcq->intx = index;
+
+	return 0;
+}
+
+void pdsc_qcq_free(struct pdsc *pdsc, struct pdsc_qcq *qcq)
+{
+	struct device *dev = pdsc->dev;
+
+	if (!(qcq && qcq->pdsc))
+		return;
+
+	pdsc_debugfs_del_qcq(qcq);
+
+	pdsc_qcq_intr_free(pdsc, qcq);
+
+	if (qcq->q_base)
+		dma_free_coherent(dev, qcq->q_size,
+				  qcq->q_base, qcq->q_base_pa);
+
+	if (qcq->cq_base)
+		dma_free_coherent(dev, qcq->cq_size,
+				  qcq->cq_base, qcq->cq_base_pa);
+
+	if (qcq->cq.info)
+		vfree(qcq->cq.info);
+
+	if (qcq->q.info)
+		vfree(qcq->q.info);
+
+	memset(qcq, 0, sizeof(*qcq));
+}
+
+static void pdsc_q_map(struct pdsc_queue *q, void *base, dma_addr_t base_pa)
+{
+	struct pdsc_q_info *cur;
+	unsigned int i;
+
+	q->base = base;
+	q->base_pa = base_pa;
+
+	for (i = 0, cur = q->info; i < q->num_descs; i++, cur++)
+		cur->desc = base + (i * q->desc_size);
+}
+
+static void pdsc_cq_map(struct pdsc_cq *cq, void *base, dma_addr_t base_pa)
+{
+	struct pdsc_cq_info *cur;
+	unsigned int i;
+
+	cq->base = base;
+	cq->base_pa = base_pa;
+
+	for (i = 0, cur = cq->info; i < cq->num_descs; i++, cur++)
+		cur->comp = base + (i * cq->desc_size);
+}
+
+int pdsc_qcq_alloc(struct pdsc *pdsc, unsigned int type, unsigned int index,
+		   const char *name, unsigned int flags, unsigned int num_descs,
+		   unsigned int desc_size, unsigned int cq_desc_size,
+		   unsigned int pid, struct pdsc_qcq *qcq)
+{
+	struct device *dev = pdsc->dev;
+	void *q_base, *cq_base;
+	dma_addr_t cq_base_pa;
+	dma_addr_t q_base_pa;
+	int err;
+
+	qcq->q.info = vzalloc(num_descs * sizeof(*qcq->q.info));
+	if (!qcq->q.info) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	qcq->pdsc = pdsc;
+	qcq->flags = flags;
+	INIT_WORK(&qcq->work, pdsc_work_thread);
+
+	qcq->q.type = type;
+	qcq->q.index = index;
+	qcq->q.num_descs = num_descs;
+	qcq->q.desc_size = desc_size;
+	qcq->q.tail_idx = 0;
+	qcq->q.head_idx = 0;
+	qcq->q.pid = pid;
+	snprintf(qcq->q.name, sizeof(qcq->q.name), "%s%u", name, index);
+
+	err = pdsc_qcq_intr_alloc(pdsc, qcq);
+	if (err)
+		goto err_out_free_q_info;
+
+	qcq->cq.info = vzalloc(num_descs * sizeof(*qcq->cq.info));
+	if (!qcq->cq.info) {
+		err = -ENOMEM;
+		goto err_out_free_irq;
+	}
+
+	qcq->cq.bound_intr = &pdsc->intr_info[qcq->intx];
+	qcq->cq.num_descs = num_descs;
+	qcq->cq.desc_size = cq_desc_size;
+	qcq->cq.tail_idx = 0;
+	qcq->cq.done_color = 1;
+
+	if (flags & PDS_CORE_QCQ_F_NOTIFYQ) {
+		/* q & cq need to be contiguous in case of notifyq */
+		qcq->q_size = PDS_PAGE_SIZE +
+			      ALIGN(num_descs * desc_size, PDS_PAGE_SIZE) +
+			      ALIGN(num_descs * cq_desc_size, PDS_PAGE_SIZE);
+		qcq->q_base = dma_alloc_coherent(dev,
+						 qcq->q_size + qcq->cq_size,
+						 &qcq->q_base_pa,
+						 GFP_KERNEL);
+		if (!qcq->q_base) {
+			err = -ENOMEM;
+			goto err_out_free_cq_info;
+		}
+		q_base = PTR_ALIGN(qcq->q_base, PDS_PAGE_SIZE);
+		q_base_pa = ALIGN(qcq->q_base_pa, PDS_PAGE_SIZE);
+		pdsc_q_map(&qcq->q, q_base, q_base_pa);
+
+		cq_base = PTR_ALIGN(q_base +
+				    ALIGN(num_descs * desc_size, PDS_PAGE_SIZE),
+				    PDS_PAGE_SIZE);
+		cq_base_pa = ALIGN(qcq->q_base_pa +
+				   ALIGN(num_descs * desc_size, PDS_PAGE_SIZE),
+				   PDS_PAGE_SIZE);
+
+	} else {
+		/* q DMA descriptors */
+		qcq->q_size = PDS_PAGE_SIZE + (num_descs * desc_size);
+		qcq->q_base = dma_alloc_coherent(dev, qcq->q_size,
+						 &qcq->q_base_pa,
+						 GFP_KERNEL);
+		if (!qcq->q_base) {
+			err = -ENOMEM;
+			goto err_out_free_cq_info;
+		}
+		q_base = PTR_ALIGN(qcq->q_base, PDS_PAGE_SIZE);
+		q_base_pa = ALIGN(qcq->q_base_pa, PDS_PAGE_SIZE);
+		pdsc_q_map(&qcq->q, q_base, q_base_pa);
+
+		/* cq DMA descriptors */
+		qcq->cq_size = PDS_PAGE_SIZE + (num_descs * cq_desc_size);
+		qcq->cq_base = dma_alloc_coherent(dev, qcq->cq_size,
+						  &qcq->cq_base_pa,
+						  GFP_KERNEL);
+		if (!qcq->cq_base) {
+			err = -ENOMEM;
+			goto err_out_free_q;
+		}
+		cq_base = PTR_ALIGN(qcq->cq_base, PDS_PAGE_SIZE);
+		cq_base_pa = ALIGN(qcq->cq_base_pa, PDS_PAGE_SIZE);
+	}
+
+	pdsc_cq_map(&qcq->cq, cq_base, cq_base_pa);
+	qcq->cq.bound_q = &qcq->q;
+
+	pdsc_debugfs_add_qcq(pdsc, qcq);
+
+	return 0;
+
+err_out_free_q:
+	dma_free_coherent(dev, qcq->q_size, qcq->q_base, qcq->q_base_pa);
+err_out_free_cq_info:
+	vfree(qcq->cq.info);
+err_out_free_irq:
+	pdsc_qcq_intr_free(pdsc, qcq);
+err_out_free_q_info:
+	vfree(qcq->q.info);
+	memset(qcq, 0, sizeof(*qcq));
+err_out:
+	dev_err(dev, "qcq alloc of %s%d failed %d\n", name, index, err);
+	return err;
+}
+
+static int pdsc_core_init(struct pdsc *pdsc)
+{
+	union pds_core_dev_comp comp = {};
+	union pds_core_dev_cmd cmd = {
+		.init.opcode = PDS_CORE_CMD_INIT,
+	};
+	struct pds_core_dev_init_data_out cido;
+	struct pds_core_dev_init_data_in cidi;
+	u32 dbid_count;
+	u32 dbpage_num;
+	size_t sz;
+	int err;
+
+	cidi.adminq_q_base = cpu_to_le64(pdsc->adminqcq.q_base_pa);
+	cidi.adminq_cq_base = cpu_to_le64(pdsc->adminqcq.cq_base_pa);
+	cidi.notifyq_cq_base = cpu_to_le64(pdsc->notifyqcq.cq.base_pa);
+	cidi.flags = cpu_to_le32(PDS_CORE_QINIT_F_IRQ | PDS_CORE_QINIT_F_ENA);
+	cidi.intr_index = cpu_to_le16(pdsc->adminqcq.intx);
+	cidi.adminq_ring_size = ilog2(pdsc->adminqcq.q.num_descs);
+	cidi.notifyq_ring_size = ilog2(pdsc->notifyqcq.q.num_descs);
+
+	mutex_lock(&pdsc->devcmd_lock);
+
+	sz = min_t(size_t, sizeof(cidi), sizeof(pdsc->cmd_regs->data));
+	memcpy_toio(&pdsc->cmd_regs->data, &cidi, sz);
+
+	err = pdsc_devcmd_locked(pdsc, &cmd, &comp, pdsc->devcmd_timeout);
+	if (!err) {
+		sz = min_t(size_t, sizeof(cido), sizeof(pdsc->cmd_regs->data));
+		memcpy_fromio(&cido, &pdsc->cmd_regs->data, sz);
+	}
+
+	mutex_unlock(&pdsc->devcmd_lock);
+	if (err) {
+		dev_err(pdsc->dev, "Device init command failed: %pe\n",
+			ERR_PTR(err));
+		return err;
+	}
+
+	pdsc->hw_index = le32_to_cpu(cido.core_hw_index);
+
+	dbid_count = le32_to_cpu(pdsc->dev_ident.ndbpgs_per_lif);
+	dbpage_num = pdsc->hw_index * dbid_count;
+	pdsc->kern_dbpage = pdsc_map_dbpage(pdsc, dbpage_num);
+	if (!pdsc->kern_dbpage) {
+		dev_err(pdsc->dev, "Cannot map dbpage, aborting\n");
+		return -ENOMEM;
+	}
+
+	pdsc->adminqcq.q.hw_type = cido.adminq_hw_type;
+	pdsc->adminqcq.q.hw_index = le32_to_cpu(cido.adminq_hw_index);
+	pdsc->adminqcq.q.dbval = PDS_CORE_DBELL_QID(pdsc->adminqcq.q.hw_index);
+
+	pdsc->notifyqcq.q.hw_type = cido.notifyq_hw_type;
+	pdsc->notifyqcq.q.hw_index = le32_to_cpu(cido.notifyq_hw_index);
+	pdsc->notifyqcq.q.dbval = PDS_CORE_DBELL_QID(pdsc->notifyqcq.q.hw_index);
+
+	pdsc->last_eid = 0;
+
+	return err;
+}
+
 int pdsc_setup(struct pdsc *pdsc, bool init)
 {
+	int numdescs;
 	int err;
 
 	if (init)
@@ -14,17 +369,60 @@ int pdsc_setup(struct pdsc *pdsc, bool init)
 	if (err)
 		return err;
 
+	/* Scale the descriptor ring length based on number of CPUs and VFs */
+	numdescs = max_t(int, PDSC_ADMINQ_MIN_LENGTH, num_online_cpus());
+	numdescs += 2 * pci_sriov_get_totalvfs(pdsc->pdev);
+	numdescs = roundup_pow_of_two(numdescs);
+	err = pdsc_qcq_alloc(pdsc, PDS_CORE_QTYPE_ADMINQ, 0, "adminq",
+			     PDS_CORE_QCQ_F_CORE | PDS_CORE_QCQ_F_INTR,
+			     numdescs,
+			     sizeof(union pds_core_adminq_cmd),
+			     sizeof(union pds_core_adminq_comp),
+			     0, &pdsc->adminqcq);
+	if (err)
+		goto err_out_teardown;
+
+	err = pdsc_qcq_alloc(pdsc, PDS_CORE_QTYPE_NOTIFYQ, 0, "notifyq",
+			     PDS_CORE_QCQ_F_NOTIFYQ,
+			     PDSC_NOTIFYQ_LENGTH,
+			     sizeof(struct pds_core_notifyq_cmd),
+			     sizeof(union pds_core_notifyq_comp),
+			     0, &pdsc->notifyqcq);
+	if (err)
+		goto err_out_teardown;
+
+	/* NotifyQ rides on the AdminQ interrupt */
+	pdsc->notifyqcq.intx = pdsc->adminqcq.intx;
+
+	/* Set up the Core with the AdminQ and NotifyQ info */
+	err = pdsc_core_init(pdsc);
+	if (err)
+		goto err_out_teardown;
+
 	clear_bit(PDSC_S_FW_DEAD, &pdsc->state);
 	return 0;
+
+err_out_teardown:
+	pdsc_teardown(pdsc, init);
+	return err;
 }
 
 void pdsc_teardown(struct pdsc *pdsc, bool removing)
 {
+	int i;
+
 	pdsc_devcmd_reset(pdsc);
+	pdsc_qcq_free(pdsc, &pdsc->notifyqcq);
+	pdsc_qcq_free(pdsc, &pdsc->adminqcq);
+
+	if (pdsc->intr_info) {
+		for (i = 0; i < pdsc->nintrs; i++)
+			pdsc_intr_free(pdsc, i);
 
-	if (removing) {
-		kfree(pdsc->intr_info);
-		pdsc->intr_info = NULL;
+		if (removing) {
+			kfree(pdsc->intr_info);
+			pdsc->intr_info = NULL;
+		}
 	}
 
 	if (pdsc->kern_dbpage) {
@@ -35,6 +433,28 @@ void pdsc_teardown(struct pdsc *pdsc, bool removing)
 	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
 }
 
+int pdsc_start(struct pdsc *pdsc)
+{
+	pds_core_intr_mask(&pdsc->intr_ctrl[pdsc->adminqcq.intx],
+			   PDS_CORE_INTR_MASK_CLEAR);
+
+	return 0;
+}
+
+void pdsc_stop(struct pdsc *pdsc)
+{
+	int i;
+
+	if (!pdsc->intr_info)
+		return;
+
+	/* Mask interrupts that are in use */
+	for (i = 0; i < pdsc->nintrs; i++)
+		if (pdsc->intr_info[i].vector)
+			pds_core_intr_mask(&pdsc->intr_ctrl[i],
+					   PDS_CORE_INTR_MASK_SET);
+}
+
 static void pdsc_fw_down(struct pdsc *pdsc)
 {
 	if (test_and_set_bit(PDSC_S_FW_DEAD, &pdsc->state)) {
@@ -44,6 +464,7 @@ static void pdsc_fw_down(struct pdsc *pdsc)
 
 	devlink_health_report(pdsc->fw_reporter, "FW down reported", pdsc);
 
+	pdsc_stop(pdsc);
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_RECOVERY);
 }
 
@@ -60,6 +481,10 @@ static void pdsc_fw_up(struct pdsc *pdsc)
 	if (err)
 		goto err_out;
 
+	err = pdsc_start(pdsc);
+	if (err)
+		goto err_out;
+
 	pdsc->fw_recoveries++;
 	devlink_health_reporter_state_update(pdsc->fw_reporter,
 					     DEVLINK_HEALTH_REPORTER_STATE_HEALTHY);
diff --git a/drivers/net/ethernet/amd/pds_core/core.h b/drivers/net/ethernet/amd/pds_core/core.h
index 32aa38c40024..7adbd10cb6d9 100644
--- a/drivers/net/ethernet/amd/pds_core/core.h
+++ b/drivers/net/ethernet/amd/pds_core/core.h
@@ -9,11 +9,15 @@
 
 #include <linux/pds/pds_common.h>
 #include <linux/pds/pds_core_if.h>
+#include <linux/pds/pds_adminq.h>
 #include <linux/pds/pds_intr.h>
 
 #define PDSC_DRV_DESCRIPTION	"AMD/Pensando Core Driver"
 
 #define PDSC_WATCHDOG_SECS	5
+#define PDSC_QUEUE_NAME_MAX_SZ  32
+#define PDSC_ADMINQ_MIN_LENGTH	16	/* must be a power of two */
+#define PDSC_NOTIFYQ_LENGTH	64	/* must be a power of two */
 #define PDSC_TEARDOWN_RECOVERY	false
 #define PDSC_TEARDOWN_REMOVING	true
 #define PDSC_SETUP_RECOVERY	false
@@ -33,6 +37,28 @@ struct pdsc_devinfo {
 	char serial_num[PDS_CORE_DEVINFO_SERIAL_BUFLEN + 1];
 };
 
+struct pdsc_queue {
+	struct pdsc_q_info *info;
+	u64 dbval;
+	u16 head_idx;
+	u16 tail_idx;
+	u8 hw_type;
+	unsigned int index;
+	unsigned int num_descs;
+	u64 dbell_count;
+	u64 features;
+	unsigned int type;
+	unsigned int hw_index;
+	union {
+		void *base;
+		struct pds_core_admin_cmd *adminq;
+	};
+	dma_addr_t base_pa;	/* must be page aligned */
+	unsigned int desc_size;
+	unsigned int pid;
+	char name[PDSC_QUEUE_NAME_MAX_SZ];
+};
+
 #define PDSC_INTR_NAME_MAX_SZ		32
 
 struct pdsc_intr_info {
@@ -42,6 +68,61 @@ struct pdsc_intr_info {
 	void *data;
 };
 
+struct pdsc_cq_info {
+	void *comp;
+};
+
+struct pdsc_buf_info {
+	struct page *page;
+	dma_addr_t dma_addr;
+	u32 page_offset;
+	u32 len;
+};
+
+struct pdsc_q_info {
+	union {
+		void *desc;
+		struct pdsc_admin_cmd *adminq_desc;
+	};
+	unsigned int bytes;
+	unsigned int nbufs;
+	struct pdsc_buf_info bufs[PDS_CORE_MAX_FRAGS];
+	struct pdsc_wait_context *wc;
+	void *dest;
+};
+
+struct pdsc_cq {
+	struct pdsc_cq_info *info;
+	struct pdsc_queue *bound_q;
+	struct pdsc_intr_info *bound_intr;
+	u16 tail_idx;
+	bool done_color;
+	unsigned int num_descs;
+	unsigned int desc_size;
+	void *base;
+	dma_addr_t base_pa;	/* must be page aligned */
+} ____cacheline_aligned_in_smp;
+
+struct pdsc_qcq {
+	struct pdsc *pdsc;
+	void *q_base;
+	dma_addr_t q_base_pa;	/* might not be page aligned */
+	void *cq_base;
+	dma_addr_t cq_base_pa;	/* might not be page aligned */
+	u32 q_size;
+	u32 cq_size;
+	bool armed;
+	unsigned int flags;
+
+	struct work_struct work;
+	struct pdsc_queue q;
+	struct pdsc_cq cq;
+	int intx;
+
+	u32 accum_work;
+	struct dentry *dentry;
+};
+
 /* No state flags set means we are in a steady running state */
 enum pdsc_state_flags {
 	PDSC_S_FW_DEAD,		    /* stopped, wait on startup or recovery */
@@ -81,6 +162,7 @@ struct pdsc {
 	unsigned int devcmd_timeout;
 	struct mutex devcmd_lock;	/* lock for dev_cmd operations */
 	struct mutex config_lock;	/* lock for configuration operations */
+	spinlock_t adminq_lock;		/* lock for adminq operations */
 	struct pds_core_dev_info_regs __iomem *info_regs;
 	struct pds_core_dev_cmd_regs __iomem *cmd_regs;
 	struct pds_core_intr __iomem *intr_ctrl;
@@ -88,11 +170,64 @@ struct pdsc {
 	u64 __iomem *db_pages;
 	dma_addr_t phy_db_pages;
 	u64 __iomem *kern_dbpage;
+
+	struct pdsc_qcq adminqcq;
+	struct pdsc_qcq notifyqcq;
+	u64 last_eid;
 };
 
+/** enum pds_core_dbell_bits - bitwise composition of dbell values.
+ *
+ * @PDS_CORE_DBELL_QID_MASK:	unshifted mask of valid queue id bits.
+ * @PDS_CORE_DBELL_QID_SHIFT:	queue id shift amount in dbell value.
+ * @PDS_CORE_DBELL_QID:		macro to build QID component of dbell value.
+ *
+ * @PDS_CORE_DBELL_RING_MASK:	unshifted mask of valid ring bits.
+ * @PDS_CORE_DBELL_RING_SHIFT:	ring shift amount in dbell value.
+ * @PDS_CORE_DBELL_RING:	macro to build ring component of dbell value.
+ *
+ * @PDS_CORE_DBELL_RING_0:	ring zero dbell component value.
+ * @PDS_CORE_DBELL_RING_1:	ring one dbell component value.
+ * @PDS_CORE_DBELL_RING_2:	ring two dbell component value.
+ * @PDS_CORE_DBELL_RING_3:	ring three dbell component value.
+ *
+ * @PDS_CORE_DBELL_INDEX_MASK:	bit mask of valid index bits, no shift needed.
+ */
+enum pds_core_dbell_bits {
+	PDS_CORE_DBELL_QID_MASK		= 0xffffff,
+	PDS_CORE_DBELL_QID_SHIFT		= 24,
+
+#define PDS_CORE_DBELL_QID(n) \
+	(((u64)(n) & PDS_CORE_DBELL_QID_MASK) << PDS_CORE_DBELL_QID_SHIFT)
+
+	PDS_CORE_DBELL_RING_MASK		= 0x7,
+	PDS_CORE_DBELL_RING_SHIFT		= 16,
+
+#define PDS_CORE_DBELL_RING(n) \
+	(((u64)(n) & PDS_CORE_DBELL_RING_MASK) << PDS_CORE_DBELL_RING_SHIFT)
+
+	PDS_CORE_DBELL_RING_0		= 0,
+	PDS_CORE_DBELL_RING_1		= PDS_CORE_DBELL_RING(1),
+	PDS_CORE_DBELL_RING_2		= PDS_CORE_DBELL_RING(2),
+	PDS_CORE_DBELL_RING_3		= PDS_CORE_DBELL_RING(3),
+
+	PDS_CORE_DBELL_INDEX_MASK		= 0xffff,
+};
+
+static inline void pds_core_dbell_ring(u64 __iomem *db_page,
+				       enum pds_core_logical_qtype qtype,
+				       u64 val)
+{
+	writeq(val, &db_page[qtype]);
+}
+
 int pdsc_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
 			      struct devlink_fmsg *fmsg,
 			      struct netlink_ext_ack *extack);
+int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+		     struct netlink_ext_ack *extack);
+
+void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num);
 
 void pdsc_debugfs_create(void);
 void pdsc_debugfs_destroy(void);
@@ -100,6 +235,8 @@ void pdsc_debugfs_add_dev(struct pdsc *pdsc);
 void pdsc_debugfs_del_dev(struct pdsc *pdsc);
 void pdsc_debugfs_add_ident(struct pdsc *pdsc);
 void pdsc_debugfs_add_irqs(struct pdsc *pdsc);
+void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq);
+void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq);
 
 int pdsc_err_to_errno(enum pds_core_status_code code);
 bool pdsc_is_fw_running(struct pdsc *pdsc);
@@ -113,8 +250,22 @@ int pdsc_devcmd_reset(struct pdsc *pdsc);
 int pdsc_dev_reinit(struct pdsc *pdsc);
 int pdsc_dev_init(struct pdsc *pdsc);
 
+int pdsc_intr_alloc(struct pdsc *pdsc, char *name,
+		    irq_handler_t handler, void *data);
+void pdsc_intr_free(struct pdsc *pdsc, int index);
+void pdsc_qcq_free(struct pdsc *pdsc, struct pdsc_qcq *qcq);
+int pdsc_qcq_alloc(struct pdsc *pdsc, unsigned int type, unsigned int index,
+		   const char *name, unsigned int flags, unsigned int num_descs,
+		   unsigned int desc_size, unsigned int cq_desc_size,
+		   unsigned int pid, struct pdsc_qcq *qcq);
 int pdsc_setup(struct pdsc *pdsc, bool init);
 void pdsc_teardown(struct pdsc *pdsc, bool removing);
+int pdsc_start(struct pdsc *pdsc);
+void pdsc_stop(struct pdsc *pdsc);
 void pdsc_health_thread(struct work_struct *work);
 
+void pdsc_process_adminq(struct pdsc_qcq *qcq);
+void pdsc_work_thread(struct work_struct *work);
+irqreturn_t pdsc_adminq_isr(int irq, void *data);
+
 #endif /* _PDSC_H_ */
diff --git a/drivers/net/ethernet/amd/pds_core/debugfs.c b/drivers/net/ethernet/amd/pds_core/debugfs.c
index 601431b41abb..b83e5016644b 100644
--- a/drivers/net/ethernet/amd/pds_core/debugfs.c
+++ b/drivers/net/ethernet/amd/pds_core/debugfs.c
@@ -67,3 +67,80 @@ void pdsc_debugfs_add_ident(struct pdsc *pdsc)
 	debugfs_create_file("identity", 0400, pdsc->dentry,
 			    pdsc, &identity_fops);
 }
+
+static const struct debugfs_reg32 intr_ctrl_regs[] = {
+	{ .name = "coal_init", .offset = 0, },
+	{ .name = "mask", .offset = 4, },
+	{ .name = "credits", .offset = 8, },
+	{ .name = "mask_on_assert", .offset = 12, },
+	{ .name = "coal_timer", .offset = 16, },
+};
+
+void pdsc_debugfs_add_qcq(struct pdsc *pdsc, struct pdsc_qcq *qcq)
+{
+	struct dentry *qcq_dentry, *q_dentry, *cq_dentry;
+	struct dentry *intr_dentry;
+	struct debugfs_regset32 *intr_ctrl_regset;
+	struct pdsc_intr_info *intr = &pdsc->intr_info[qcq->intx];
+	struct pdsc_queue *q = &qcq->q;
+	struct pdsc_cq *cq = &qcq->cq;
+
+	qcq_dentry = debugfs_create_dir(q->name, pdsc->dentry);
+	if (IS_ERR_OR_NULL(qcq_dentry))
+		return;
+	qcq->dentry = qcq_dentry;
+
+	debugfs_create_x64("q_base_pa", 0400, qcq_dentry, &qcq->q_base_pa);
+	debugfs_create_x32("q_size", 0400, qcq_dentry, &qcq->q_size);
+	debugfs_create_x64("cq_base_pa", 0400, qcq_dentry, &qcq->cq_base_pa);
+	debugfs_create_x32("cq_size", 0400, qcq_dentry, &qcq->cq_size);
+	debugfs_create_x32("accum_work", 0400, qcq_dentry, &qcq->accum_work);
+
+	q_dentry = debugfs_create_dir("q", qcq->dentry);
+	if (IS_ERR_OR_NULL(q_dentry))
+		return;
+
+	debugfs_create_u32("index", 0400, q_dentry, &q->index);
+	debugfs_create_u32("num_descs", 0400, q_dentry, &q->num_descs);
+	debugfs_create_u32("desc_size", 0400, q_dentry, &q->desc_size);
+	debugfs_create_u32("pid", 0400, q_dentry, &q->pid);
+
+	debugfs_create_u16("tail", 0400, q_dentry, &q->tail_idx);
+	debugfs_create_u16("head", 0400, q_dentry, &q->head_idx);
+
+	cq_dentry = debugfs_create_dir("cq", qcq->dentry);
+	if (IS_ERR_OR_NULL(cq_dentry))
+		return;
+
+	debugfs_create_x64("base_pa", 0400, cq_dentry, &cq->base_pa);
+	debugfs_create_u32("num_descs", 0400, cq_dentry, &cq->num_descs);
+	debugfs_create_u32("desc_size", 0400, cq_dentry, &cq->desc_size);
+	debugfs_create_bool("done_color", 0400, cq_dentry, &cq->done_color);
+	debugfs_create_u16("tail", 0400, cq_dentry, &cq->tail_idx);
+
+	if (qcq->flags & PDS_CORE_QCQ_F_INTR) {
+		intr_dentry = debugfs_create_dir("intr", qcq->dentry);
+		if (IS_ERR_OR_NULL(intr_dentry))
+			return;
+
+		debugfs_create_u32("index", 0400, intr_dentry, &intr->index);
+		debugfs_create_u32("vector", 0400, intr_dentry, &intr->vector);
+
+		intr_ctrl_regset = kzalloc(sizeof(*intr_ctrl_regset),
+					   GFP_KERNEL);
+		if (!intr_ctrl_regset)
+			return;
+		intr_ctrl_regset->regs = intr_ctrl_regs;
+		intr_ctrl_regset->nregs = ARRAY_SIZE(intr_ctrl_regs);
+		intr_ctrl_regset->base = &pdsc->intr_ctrl[intr->index];
+
+		debugfs_create_regset32("intr_ctrl", 0400, intr_dentry,
+					intr_ctrl_regset);
+	}
+};
+
+void pdsc_debugfs_del_qcq(struct pdsc_qcq *qcq)
+{
+	debugfs_remove_recursive(qcq->dentry);
+	qcq->dentry = NULL;
+}
diff --git a/drivers/net/ethernet/amd/pds_core/devlink.c b/drivers/net/ethernet/amd/pds_core/devlink.c
index 3b05b1af65d1..89f23d620d1d 100644
--- a/drivers/net/ethernet/amd/pds_core/devlink.c
+++ b/drivers/net/ethernet/amd/pds_core/devlink.c
@@ -3,6 +3,67 @@
 
 #include "core.h"
 
+static char *fw_slotnames[] = {
+	"fw.goldfw",
+	"fw.mainfwa",
+	"fw.mainfwb",
+};
+
+int pdsc_dl_info_get(struct devlink *dl, struct devlink_info_req *req,
+		     struct netlink_ext_ack *extack)
+{
+	union pds_core_dev_cmd cmd = {
+		.fw_control.opcode = PDS_CORE_CMD_FW_CONTROL,
+		.fw_control.oper = PDS_CORE_FW_GET_LIST,
+	};
+	struct pds_core_fw_list_info fw_list;
+	struct pdsc *pdsc = devlink_priv(dl);
+	union pds_core_dev_comp comp;
+	char buf[16];
+	int listlen;
+	int err;
+	int i;
+
+	mutex_lock(&pdsc->devcmd_lock);
+	err = pdsc_devcmd_locked(pdsc, &cmd, &comp, pdsc->devcmd_timeout * 2);
+	memcpy_fromio(&fw_list, pdsc->cmd_regs->data, sizeof(fw_list));
+	mutex_unlock(&pdsc->devcmd_lock);
+	if (err && err != -EIO)
+		return err;
+
+	listlen = fw_list.num_fw_slots;
+	for (i = 0; i < listlen; i++) {
+		if (i < ARRAY_SIZE(fw_slotnames))
+			strscpy(buf, fw_slotnames[i], sizeof(buf));
+		else
+			snprintf(buf, sizeof(buf), "fw.slot_%d", i);
+		err = devlink_info_version_stored_put(req, buf,
+						      fw_list.fw_names[i].fw_version);
+	}
+
+	err = devlink_info_version_running_put(req,
+					       DEVLINK_INFO_VERSION_GENERIC_FW,
+					       pdsc->dev_info.fw_version);
+	if (err)
+		return err;
+
+	snprintf(buf, sizeof(buf), "0x%x", pdsc->dev_info.asic_type);
+	err = devlink_info_version_fixed_put(req,
+					     DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
+					     buf);
+	if (err)
+		return err;
+
+	snprintf(buf, sizeof(buf), "0x%x", pdsc->dev_info.asic_rev);
+	err = devlink_info_version_fixed_put(req,
+					     DEVLINK_INFO_VERSION_GENERIC_ASIC_REV,
+					     buf);
+	if (err)
+		return err;
+
+	return devlink_info_serial_number_put(req, pdsc->dev_info.serial_num);
+}
+
 int pdsc_fw_reporter_diagnose(struct devlink_health_reporter *reporter,
 			      struct devlink_fmsg *fmsg,
 			      struct netlink_ext_ack *extack)
diff --git a/drivers/net/ethernet/amd/pds_core/main.c b/drivers/net/ethernet/amd/pds_core/main.c
index 54f3aed7adb1..eaff311d4a10 100644
--- a/drivers/net/ethernet/amd/pds_core/main.c
+++ b/drivers/net/ethernet/amd/pds_core/main.c
@@ -125,6 +125,13 @@ static int pdsc_map_bars(struct pdsc *pdsc)
 	return err;
 }
 
+void __iomem *pdsc_map_dbpage(struct pdsc *pdsc, int page_num)
+{
+	return pci_iomap_range(pdsc->pdev,
+			       pdsc->bars[PDS_CORE_PCI_BAR_DBELL].res_index,
+			       (u64)page_num << PAGE_SHIFT, PAGE_SIZE);
+}
+
 static int pdsc_init_vf(struct pdsc *vf)
 {
 	return -1;
@@ -166,6 +173,7 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	mutex_init(&pdsc->devcmd_lock);
 	mutex_init(&pdsc->config_lock);
+	spin_lock_init(&pdsc->adminq_lock);
 
 	mutex_lock(&pdsc->config_lock);
 	set_bit(PDSC_S_FW_DEAD, &pdsc->state);
@@ -173,6 +181,9 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 	err = pdsc_setup(pdsc, PDSC_SETUP_INIT);
 	if (err)
 		goto err_out_unmap_bars;
+	err = pdsc_start(pdsc);
+	if (err)
+		goto err_out_teardown;
 
 	mutex_unlock(&pdsc->config_lock);
 
@@ -184,7 +195,7 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 		dev_warn(pdsc->dev, "Failed to create fw reporter: %pe\n", hr);
 		err = PTR_ERR(hr);
 		devl_unlock(dl);
-		goto err_out_teardown;
+		goto err_out_stop;
 	}
 	pdsc->fw_reporter = hr;
 
@@ -196,6 +207,8 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 
 	return 0;
 
+err_out_stop:
+	pdsc_stop(pdsc);
 err_out_teardown:
 	pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 err_out_unmap_bars:
@@ -214,6 +227,7 @@ static int pdsc_init_pf(struct pdsc *pdsc)
 }
 
 static const struct devlink_ops pdsc_dl_ops = {
+	.info_get	= pdsc_dl_info_get,
 };
 
 static const struct devlink_ops pdsc_dl_vf_ops = {
@@ -315,6 +329,7 @@ static void pdsc_remove(struct pci_dev *pdev)
 		mutex_lock(&pdsc->config_lock);
 		set_bit(PDSC_S_STOPPING_DRIVER, &pdsc->state);
 
+		pdsc_stop(pdsc);
 		pdsc_teardown(pdsc, PDSC_TEARDOWN_REMOVING);
 		mutex_unlock(&pdsc->config_lock);
 		mutex_destroy(&pdsc->config_lock);
diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
new file mode 100644
index 000000000000..dd5fbe3ee141
--- /dev/null
+++ b/include/linux/pds/pds_adminq.h
@@ -0,0 +1,638 @@
+/* SPDX-License-Identifier: GPL-2.0 */
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#ifndef _PDS_CORE_ADMINQ_H_
+#define _PDS_CORE_ADMINQ_H_
+
+enum pds_core_adminq_flags {
+	PDS_AQ_FLAG_FASTPOLL	= BIT(1),	/* completion poll at 1ms */
+};
+
+/*
+ * enum pds_core_adminq_opcode - AdminQ command opcodes
+ * These commands are only processed on AdminQ, not available in devcmd
+ */
+enum pds_core_adminq_opcode {
+	PDS_AQ_CMD_NOP			= 0,
+
+	/* Client control */
+	PDS_AQ_CMD_CLIENT_REG		= 6,
+	PDS_AQ_CMD_CLIENT_UNREG		= 7,
+	PDS_AQ_CMD_CLIENT_CMD		= 8,
+
+	/* LIF commands */
+	PDS_AQ_CMD_LIF_IDENTIFY		= 20,
+	PDS_AQ_CMD_LIF_INIT		= 21,
+	PDS_AQ_CMD_LIF_RESET		= 22,
+	PDS_AQ_CMD_LIF_GETATTR		= 23,
+	PDS_AQ_CMD_LIF_SETATTR		= 24,
+	PDS_AQ_CMD_LIF_SETPHC		= 25,
+
+	PDS_AQ_CMD_RX_MODE_SET		= 30,
+	PDS_AQ_CMD_RX_FILTER_ADD	= 31,
+	PDS_AQ_CMD_RX_FILTER_DEL	= 32,
+
+	/* Queue commands */
+	PDS_AQ_CMD_Q_IDENTIFY		= 39,
+	PDS_AQ_CMD_Q_INIT		= 40,
+	PDS_AQ_CMD_Q_CONTROL		= 41,
+
+	/* SR/IOV commands */
+	PDS_AQ_CMD_VF_GETATTR		= 60,
+	PDS_AQ_CMD_VF_SETATTR		= 61,
+};
+
+/*
+ * enum pds_core_notifyq_opcode - NotifyQ event codes
+ */
+enum pds_core_notifyq_opcode {
+	PDS_EVENT_LINK_CHANGE		= 1,
+	PDS_EVENT_RESET			= 2,
+	PDS_EVENT_XCVR			= 5,
+	PDS_EVENT_CLIENT		= 6,
+};
+
+#define PDS_COMP_COLOR_MASK  0x80
+
+/**
+ * struct pds_core_notifyq_event - Generic event reporting structure
+ * @eid:   event number
+ * @ecode: event code
+ *
+ * This is the generic event report struct from which the other
+ * actual events will be formed.
+ */
+struct pds_core_notifyq_event {
+	__le64 eid;
+	__le16 ecode;
+};
+
+/**
+ * struct pds_core_link_change_event - Link change event notification
+ * @eid:		event number
+ * @ecode:		event code = PDS_EVENT_LINK_CHANGE
+ * @link_status:	link up/down, with error bits
+ * @link_speed:		speed of the network link
+ *
+ * Sent when the network link state changes between UP and DOWN
+ */
+struct pds_core_link_change_event {
+	__le64 eid;
+	__le16 ecode;
+	__le16 link_status;
+	__le32 link_speed;	/* units of 1Mbps: e.g. 10000 = 10Gbps */
+};
+
+/**
+ * struct pds_core_reset_event - Reset event notification
+ * @eid:		event number
+ * @ecode:		event code = PDS_EVENT_RESET
+ * @reset_code:		reset type
+ * @state:		0=pending, 1=complete, 2=error
+ *
+ * Sent when the NIC or some subsystem is going to be or
+ * has been reset.
+ */
+struct pds_core_reset_event {
+	__le64 eid;
+	__le16 ecode;
+	u8     reset_code;
+	u8     state;
+};
+
+/**
+ * struct pds_core_client_event - Client event notification
+ * @eid:		event number
+ * @ecode:		event code = PDS_EVENT_CLIENT
+ * @client_id:          client to sent event to
+ * @client_event:       wrapped event struct for the client
+ *
+ * Sent when an event needs to be passed on to a client
+ */
+struct pds_core_client_event {
+	__le64 eid;
+	__le16 ecode;
+	__le16 client_id;
+	u8     client_event[54];
+};
+
+/**
+ * struct pds_core_notifyq_cmd - Placeholder for building qcq
+ * @data:      anonymous field for building the qcq
+ */
+struct pds_core_notifyq_cmd {
+	__le32 data;	/* Not used but needed for qcq structure */
+};
+
+/*
+ * union pds_core_notifyq_comp - Overlay of notifyq event structures
+ */
+union pds_core_notifyq_comp {
+	struct {
+		__le64 eid;
+		__le16 ecode;
+	};
+	struct pds_core_notifyq_event     event;
+	struct pds_core_link_change_event link_change;
+	struct pds_core_reset_event       reset;
+	u8     data[64];
+};
+
+#define PDS_DEVNAME_LEN		32
+/**
+ * struct pds_core_client_reg_cmd - Register a new client with DSC
+ * @opcode:         opcode PDS_AQ_CMD_CLIENT_REG
+ * @rsvd:           word boundary padding
+ * @devname:        text name of client device
+ * @vif_type:       what type of device (enum pds_core_vif_types)
+ *
+ * Tell the DSC of the new client, and receive a client_id from DSC.
+ */
+struct pds_core_client_reg_cmd {
+	u8     opcode;
+	u8     rsvd[3];
+	char   devname[PDS_DEVNAME_LEN];
+	u8     vif_type;
+};
+
+/**
+ * struct pds_core_client_reg_comp - Client registration completion
+ * @status:     Status of the command (enum pdc_core_status_code)
+ * @rsvd:       Word boundary padding
+ * @comp_index: Index in the descriptor ring for which this is the completion
+ * @client_id:  New id assigned by DSC
+ * @rsvd1:      Word boundary padding
+ * @color:      Color bit
+ */
+struct pds_core_client_reg_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	__le16 client_id;
+	u8     rsvd1[9];
+	u8     color;
+};
+
+/**
+ * struct pds_core_client_unreg_cmd - Unregister a client from DSC
+ * @opcode:     opcode PDS_AQ_CMD_CLIENT_UNREG
+ * @rsvd:       word boundary padding
+ * @client_id:  id of client being removed
+ *
+ * Tell the DSC this client is going away and remove its context
+ * This uses the generic completion.
+ */
+struct pds_core_client_unreg_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 client_id;
+};
+
+/**
+ * struct pds_core_client_request_cmd - Pass along a wrapped client AdminQ cmd
+ * @opcode:     opcode PDS_AQ_CMD_CLIENT_CMD
+ * @rsvd:       word boundary padding
+ * @client_id:  id of client being removed
+ * @client_cmd: the wrapped client command
+ *
+ * Proxy post an adminq command for the client.
+ * This uses the generic completion.
+ */
+struct pds_core_client_request_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 client_id;
+	u8     client_cmd[60];
+};
+
+#define PDS_CORE_MAX_FRAGS		16
+
+#define PDS_CORE_QCQ_F_INITED		BIT(0)
+#define PDS_CORE_QCQ_F_SG		BIT(1)
+#define PDS_CORE_QCQ_F_INTR		BIT(2)
+#define PDS_CORE_QCQ_F_TX_STATS		BIT(3)
+#define PDS_CORE_QCQ_F_RX_STATS		BIT(4)
+#define PDS_CORE_QCQ_F_NOTIFYQ		BIT(5)
+#define PDS_CORE_QCQ_F_CMB_RINGS	BIT(6)
+#define PDS_CORE_QCQ_F_CORE		BIT(7)
+
+enum pds_core_lif_type {
+	PDS_CORE_LIF_TYPE_DEFAULT = 0,
+};
+
+/**
+ * union pds_core_lif_config - LIF configuration
+ * @state:	    LIF state (enum pds_core_lif_state)
+ * @rsvd:           Word boundary padding
+ * @name:	    LIF name
+ * @rsvd2:          Word boundary padding
+ * @features:	    LIF features active (enum pds_core_hw_features)
+ * @queue_count:    Queue counts per queue-type
+ * @words:          Full union buffer size
+ */
+union pds_core_lif_config {
+	struct {
+		u8     state;
+		u8     rsvd[3];
+		char   name[PDS_CORE_IFNAMSIZ];
+		u8     rsvd2[12];
+		__le64 features;
+		__le32 queue_count[PDS_CORE_QTYPE_MAX];
+	} __packed;
+	__le32 words[64];
+};
+
+/**
+ * struct pds_core_lif_status - LIF status register
+ * @eid:	     most recent NotifyQ event id
+ * @rsvd:            full struct size
+ */
+struct pds_core_lif_status {
+	__le64 eid;
+	u8     rsvd[56];
+};
+
+/**
+ * struct pds_core_lif_info - LIF info structure
+ * @config:	LIF configuration structure
+ * @status:	LIF status structure
+ */
+struct pds_core_lif_info {
+	union pds_core_lif_config config;
+	struct pds_core_lif_status status;
+};
+
+/**
+ * struct pds_core_lif_identity - LIF identity information (type-specific)
+ * @features:		LIF features (see enum pds_core_hw_features)
+ * @version:		Identify structure version
+ * @hw_index:		LIF hardware index
+ * @rsvd:		Word boundary padding
+ * @max_nb_sessions:	Maximum number of sessions supported
+ * @rsvd2:		buffer padding
+ * @config:		LIF config struct with features, q counts
+ */
+struct pds_core_lif_identity {
+	__le64 features;
+	u8     version;
+	u8     hw_index;
+	u8     rsvd[2];
+	__le32 max_nb_sessions;
+	u8     rsvd2[120];
+	union pds_core_lif_config config;
+};
+
+/**
+ * struct pds_core_lif_identify_cmd - Get LIF identity info command
+ * @opcode:	Opcode PDS_AQ_CMD_LIF_IDENTIFY
+ * @type:	LIF type (enum pds_core_lif_type)
+ * @client_id:	Client identifier
+ * @ver:	Version of identify returned by device
+ * @rsvd:       Word boundary padding
+ * @ident_pa:	DMA address to receive identity info
+ *
+ * Firmware will copy LIF identity data (struct pds_core_lif_identity)
+ * into the buffer address given.
+ */
+struct pds_core_lif_identify_cmd {
+	u8     opcode;
+	u8     type;
+	__le16 client_id;
+	u8     ver;
+	u8     rsvd[3];
+	__le64 ident_pa;
+};
+
+/**
+ * struct pds_core_lif_identify_comp - LIF identify command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @ver:	Version of identify returned by device
+ * @bytes:	Bytes copied into the buffer
+ * @rsvd:       Word boundary padding
+ * @color:      Color bit
+ */
+struct pds_core_lif_identify_comp {
+	u8     status;
+	u8     ver;
+	__le16 bytes;
+	u8     rsvd[11];
+	u8     color;
+};
+
+/**
+ * struct pds_core_lif_init_cmd - LIF init command
+ * @opcode:	Opcode PDS_AQ_CMD_LIF_INIT
+ * @type:	LIF type (enum pds_core_lif_type)
+ * @client_id:	Client identifier
+ * @rsvd:       Word boundary padding
+ * @info_pa:	Destination address for LIF info (struct pds_core_lif_info)
+ */
+struct pds_core_lif_init_cmd {
+	u8     opcode;
+	u8     type;
+	__le16 client_id;
+	__le32 rsvd;
+	__le64 info_pa;
+};
+
+/**
+ * struct pds_core_lif_init_comp - LIF init command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd:       Word boundary padding
+ * @hw_index:	Hardware index of the initialized LIF
+ * @rsvd1:      Word boundary padding
+ * @color:      Color bit
+ */
+struct pds_core_lif_init_comp {
+	u8 status;
+	u8 rsvd;
+	__le16 hw_index;
+	u8     rsvd1[11];
+	u8     color;
+};
+
+/**
+ * struct pds_core_lif_reset_cmd - LIF reset command
+ * Will reset only the specified LIF.
+ * @opcode:	Opcode PDS_AQ_CMD_LIF_RESET
+ * @rsvd:       Word boundary padding
+ * @client_id:	Client identifier
+ */
+struct pds_core_lif_reset_cmd {
+	u8     opcode;
+	u8     rsvd;
+	__le16 client_id;
+};
+
+/**
+ * enum pds_core_lif_attr - List of LIF attributes
+ * @PDS_CORE_LIF_ATTR_STATE:		LIF state attribute
+ * @PDS_CORE_LIF_ATTR_NAME:		LIF name attribute
+ * @PDS_CORE_LIF_ATTR_FEATURES:		LIF features attribute
+ * @PDS_CORE_LIF_ATTR_STATS_CTRL:	LIF statistics control attribute
+ */
+enum pds_core_lif_attr {
+	PDS_CORE_LIF_ATTR_STATE		= 0,
+	PDS_CORE_LIF_ATTR_NAME		= 1,
+	PDS_CORE_LIF_ATTR_FEATURES	= 4,
+	PDS_CORE_LIF_ATTR_STATS_CTRL	= 6,
+};
+
+/**
+ * struct pds_core_lif_setattr_cmd - Set LIF attributes on the NIC
+ * @opcode:	Opcode PDS_AQ_CMD_LIF_SETATTR
+ * @attr:	Attribute type (enum pds_core_lif_attr)
+ * @client_id:	Client identifier
+ * @state:	LIF state (enum pds_core_lif_state)
+ * @name:	The name string, 0 terminated
+ * @features:	Features (enum pds_core_hw_features)
+ * @stats_ctl:	Stats control commands (enum pds_core_stats_ctl_cmd)
+ * @rsvd:       Command Buffer padding
+ */
+struct pds_core_lif_setattr_cmd {
+	u8     opcode;
+	u8     attr;
+	__le16 client_id;
+	union {
+		u8      state;
+		char    name[PDS_CORE_IFNAMSIZ];
+		__le64  features;
+		u8      stats_ctl;
+		u8      rsvd[60];
+	} __packed;
+};
+
+/**
+ * struct pds_core_lif_setattr_comp - LIF set attr command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd:       Word boundary padding
+ * @comp_index: Index in the descriptor ring for which this is the completion
+ * @features:	Features (enum pds_core_hw_features)
+ * @rsvd2:      Word boundary padding
+ * @color:	Color bit
+ */
+struct pds_core_lif_setattr_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	union {
+		__le64  features;
+		u8      rsvd2[11];
+	} __packed;
+	u8     color;
+};
+
+/**
+ * struct pds_core_lif_getattr_cmd - Get LIF attributes from the NIC
+ * @opcode:	Opcode PDS_AQ_CMD_LIF_GETATTR
+ * @attr:	Attribute type (enum pds_core_lif_attr)
+ * @client_id:	Client identifier
+ */
+struct pds_core_lif_getattr_cmd {
+	u8     opcode;
+	u8     attr;
+	__le16 client_id;
+};
+
+/**
+ * struct pds_core_lif_getattr_comp - LIF get attr command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd:       Word boundary padding
+ * @comp_index: Index in the descriptor ring for which this is the completion
+ * @state:	LIF state (enum pds_core_lif_state)
+ * @name:	LIF name string, 0 terminated
+ * @features:	Features (enum pds_core_hw_features)
+ * @rsvd2:      Word boundary padding
+ * @color:	Color bit
+ */
+struct pds_core_lif_getattr_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	union {
+		u8      state;
+		__le64  features;
+		u8      rsvd2[11];
+	} __packed;
+	u8     color;
+};
+
+/**
+ * union pds_core_q_identity - Queue identity information
+ * @version:	Queue type version that can be used with FW
+ * @supported:	Bitfield of queue versions, first bit = ver 0
+ * @rsvd:       Word boundary padding
+ * @features:	Queue features
+ * @desc_sz:	Descriptor size
+ * @comp_sz:	Completion descriptor size
+ * @rsvd2:      Word boundary padding
+ */
+struct pds_core_q_identity {
+	u8      version;
+	u8      supported;
+	u8      rsvd[6];
+#define PDS_CORE_QIDENT_F_CQ	0x01	/* queue has completion ring */
+	__le64  features;
+	__le16  desc_sz;
+	__le16  comp_sz;
+	u8      rsvd2[6];
+};
+
+/**
+ * struct pds_core_q_identify_cmd - queue identify command
+ * @opcode:	Opcode PDS_AQ_CMD_Q_IDENTIFY
+ * @type:	Logical queue type (enum pds_core_logical_qtype)
+ * @client_id:	Client identifier
+ * @ver:	Highest queue type version that the driver supports
+ * @rsvd:       Word boundary padding
+ * @ident_pa:   DMA address to receive the data (struct pds_core_q_identity)
+ */
+struct pds_core_q_identify_cmd {
+	u8     opcode;
+	u8     type;
+	__le16 client_id;
+	u8     ver;
+	u8     rsvd[3];
+	__le64 ident_pa;
+};
+
+/**
+ * struct pds_core_q_identify_comp - queue identify command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd:       Word boundary padding
+ * @comp_index:	Index in the descriptor ring for which this is the completion
+ * @ver:	Queue type version that can be used with FW
+ * @rsvd1:      Word boundary padding
+ * @color:      Color bit
+ */
+struct pds_core_q_identify_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	u8     ver;
+	u8     rsvd1[10];
+	u8     color;
+};
+
+/**
+ * struct pds_core_q_init_cmd - Queue init command
+ * @opcode:	  Opcode PDS_AQ_CMD_Q_INIT
+ * @type:	  Logical queue type
+ * @client_id:	  Client identifier
+ * @ver:	  Queue type version
+ * @rsvd:         Word boundary padding
+ * @index:	  (LIF, qtype) relative admin queue index
+ * @intr_index:	  Interrupt control register index, or Event queue index
+ * @pid:	  Process ID
+ * @flags:
+ *    IRQ:	  Interrupt requested on completion
+ *    ENA:	  Enable the queue.  If ENA=0 the queue is initialized
+ *		  but remains disabled, to be later enabled with the
+ *		  Queue Enable command. If ENA=1, then queue is
+ *		  initialized and then enabled.
+ * @cos:	  Class of service for this queue
+ * @ring_size:	  Queue ring size, encoded as a log2(size), in
+ *		  number of descriptors.  The actual ring size is
+ *		  (1 << ring_size).  For example, to select a ring size
+ *		  of 64 descriptors write ring_size = 6. The minimum
+ *		  ring_size value is 2 for a ring of 4 descriptors.
+ *		  The maximum ring_size value is 12 for a ring of 4k
+ *		  descriptors. Values of ring_size <2 and >12 are
+ *		  reserved.
+ * @ring_base:	  Queue ring base address
+ * @cq_ring_base: Completion queue ring base address
+ */
+struct pds_core_q_init_cmd {
+	u8     opcode;
+	u8     type;
+	__le16 client_id;
+	u8     ver;
+	u8     rsvd[3];
+	__le32 index;
+	__le16 pid;
+	__le16 intr_index;
+	__le16 flags;
+#define PDS_CORE_QINIT_F_IRQ	0x01	/* Request interrupt on completion */
+#define PDS_CORE_QINIT_F_ENA	0x02	/* Enable the queue */
+	u8     cos;
+#define PDS_CORE_QSIZE_MIN_LG2	2
+#define PDS_CORE_QSIZE_MAX_LG2	12
+	u8     ring_size;
+	__le64 ring_base;
+	__le64 cq_ring_base;
+} __packed;
+
+/**
+ * struct pds_core_q_init_comp - Queue init command completion
+ * @status:	Status of the command (enum pds_core_status_code)
+ * @rsvd:       Word boundary padding
+ * @comp_index:	Index in the descriptor ring for which this is the completion
+ * @hw_index:	Hardware Queue ID
+ * @hw_type:	Hardware Queue type
+ * @rsvd2:      Word boundary padding
+ * @color:	Color
+ */
+struct pds_core_q_init_comp {
+	u8     status;
+	u8     rsvd;
+	__le16 comp_index;
+	__le32 hw_index;
+	u8     hw_type;
+	u8     rsvd2[6];
+	u8     color;
+};
+
+union pds_core_adminq_cmd {
+	u8     opcode;
+	u8     bytes[64];
+
+	struct pds_core_client_reg_cmd     client_reg;
+	struct pds_core_client_unreg_cmd   client_unreg;
+	struct pds_core_client_request_cmd client_request;
+
+	struct pds_core_lif_identify_cmd  lif_ident;
+	struct pds_core_lif_init_cmd      lif_init;
+	struct pds_core_lif_reset_cmd     lif_reset;
+	struct pds_core_lif_setattr_cmd   lif_setattr;
+	struct pds_core_lif_getattr_cmd   lif_getattr;
+
+	struct pds_core_q_identify_cmd    q_ident;
+	struct pds_core_q_init_cmd        q_init;
+};
+
+union pds_core_adminq_comp {
+	struct {
+		u8     status;
+		u8     rsvd;
+		__le16 comp_index;
+		u8     rsvd2[11];
+		u8     color;
+	};
+	u32    words[4];
+
+	struct pds_core_client_reg_comp   client_reg;
+
+	struct pds_core_lif_identify_comp lif_ident;
+	struct pds_core_lif_init_comp     lif_init;
+	struct pds_core_lif_setattr_comp  lif_setattr;
+	struct pds_core_lif_getattr_comp  lif_getattr;
+
+	struct pds_core_q_identify_comp   q_ident;
+	struct pds_core_q_init_comp       q_init;
+};
+
+#ifndef __CHECKER__
+static_assert(sizeof(union pds_core_adminq_cmd) == 64);
+static_assert(sizeof(union pds_core_adminq_comp) == 16);
+static_assert(sizeof(union pds_core_notifyq_comp) == 64);
+#endif /* __CHECKER__ */
+
+/* The color bit is a 'done' bit for the completion descriptors
+ * where the meaning alternates between '1' and '0' for alternating
+ * passes through the completion descriptor ring.
+ */
+static inline u8 pdsc_color_match(u8 color, u8 done_color)
+{
+	return (!!(color & PDS_COMP_COLOR_MASK)) == done_color;
+}
+#endif /* _PDS_CORE_ADMINQ_H_ */
-- 
2.17.1


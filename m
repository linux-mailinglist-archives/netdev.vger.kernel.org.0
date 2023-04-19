Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCB4F6E8012
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 19:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbjDSRFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 13:05:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbjDSRFc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 13:05:32 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2060.outbound.protection.outlook.com [40.107.92.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB117DAA
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 10:05:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NEa0jtk/CdCeJ30Z5zHgJFHaxDEWgcaXDkv9QLjPvaWqFM+oM7nWWyOIi9T3Fj1CJvOkd8+CJ2e5ho975chyy2p/+JrTb0nH81MRkMEmMHykvBBCQIBxEj8lt9060ZGFvMdYehZJcaTX6DN+1hRAKTCX3RXuogGJH0Dd7Iy7qJKrZFs8ZRf6Zk46AkasmtWw4OCiSloaKUm/wqQshmzhaIusmnB5B5H3uaa/K9ByShsXvksgLLtHUE+C0XwQdivAAtuPw23JxyuaZBlF5ngvkydh046IXBEplcUich8GAV44x7fQxmEWNaMSK+BR/VD4bUPfhyl2n1kXm4YlDi4k1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=reYw/ymsh+WT/qi53GO9TwSm1TkZi+fxRJCtIjJQn7Y=;
 b=nfg3KmPqKi84qVq6m5PXwU9akZiSrEsrx+687A5SgO1sy/2L4+Kp08YfdLQCzaz4YTqo83kvy+I/hBhfreshdWVzXMjSP5MvIR+ReEKGXq4XgkntS65ZeKdzv7TeWZz4w853kXEj6m+cEZRuWHyzk/BQKbxpxrY5nSqWhjHNXWFGRvR5yx7ZDyys8Jj1JUog55cIhLWh6aKGa8MyEtnkniwglcMBi8WTFlSma9Ce5OH8WJB0dCUqx+CgANG3G63l4RveTdfL7P2g6ZP7sRe2WtxF5TAJtiZg4a6+xmZgRK3auhBcHCafkZNfSVJDd+yxPt2NUYHHbS5F1znuYXV0Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=reYw/ymsh+WT/qi53GO9TwSm1TkZi+fxRJCtIjJQn7Y=;
 b=oTGcoiqLxqpjhFnSQVdDmW/YPvSalTAf5sYealmeU4+4WeLdGFrHwYkSY9o6EVr1SKhX9bNTqKe4DOQ97prOTDztmkOzdtLPYvLuKjuq8eHU7NV6bLsERN+DR0PtI0KTWS6qRSrW/QhvdYBzbxI79OdnqPQJV9jT+ML0augZ5GU=
Received: from BN9PR03CA0402.namprd03.prod.outlook.com (2603:10b6:408:111::17)
 by CY8PR12MB7490.namprd12.prod.outlook.com (2603:10b6:930:91::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22; Wed, 19 Apr
 2023 17:05:26 +0000
Received: from BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:111:cafe::8a) by BN9PR03CA0402.outlook.office365.com
 (2603:10b6:408:111::17) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 17:05:25 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 BN8NAM11FT066.mail.protection.outlook.com (10.13.177.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 17:05:25 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Wed, 19 Apr
 2023 12:05:17 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>,
        <simon.horman@corigine.com>
Subject: [PATCH v11 net-next 06/14] pds_core: Add adminq processing and commands
Date:   Wed, 19 Apr 2023 10:04:19 -0700
Message-ID: <20230419170427.1108-7-shannon.nelson@amd.com>
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
X-MS-TrafficTypeDiagnostic: BN8NAM11FT066:EE_|CY8PR12MB7490:EE_
X-MS-Office365-Filtering-Correlation-Id: 0568efcd-c85b-4fdb-bdec-08db40f8451b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /1XxJdmNrJvgKs8cnIGF5Kug229yrzF1vkhERNQCDocVglamQji7w+CUS6tofdoGHBVlzH60kjEnuM5Ni/EPgesSzyYzEYoACxO9OtlD3eTySOWoxiKgQ9k+0XAJ7e0tIZVHGNJzf7w90N++4NRftmDJO5Z63WXmPpllAGrVLDdIVXfeV5fG5aURKs660h6ZNE/rlBSapd6xtg/fNWURE6mSqsbq0tEfpuQ62am0N9vn0lMvvIRQ2O1OkMaYs5KeNSY8dCh5AloE4MrwfRcBETVKahXl1PXgNkwWiED42lvXAnlP7FyhclfSt/3kb2UU1uQGvZYYGbZNppLrrOP0OfAKT+TrlNFQDtw4w/uWbjo0K8nPDi2Yw7Lpu8VyZ4xd5DppM+lRrUti8cySxqM6ZCr/SMEv2FU+PkiSWt4zP377h3qtP9RfJmQ4l8pDaRqiD/gInbbzUYBXd7YYvOUIStEt+ywvblSabRwCmoZqlsa7b0LCT5RKp7p6TchroqL5aYxd5qjgW1D6S/Nfm52IwW6ot6PzQ3AI3LG0mQvg1CRglPBrU6BNKzQh2Vk5F8s6sORvqz51Inv/0aZKZ/rcSoye3c3PADIcNIMWge6xFOek1pqGGOQ1mYLVPC230Qt8uEXuAoO7VGGuxCOb5BOX/dIZk8S59o2q2gUpoh+jGn62LKNyusdszbT1hJcWWS8SdduAV+IiDecNlSIw3uaS4hybi6o2ziNEdtqFW/oqaQU=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(376002)(39860400002)(396003)(346002)(136003)(451199021)(40470700004)(36840700001)(46966006)(82740400003)(26005)(110136005)(478600001)(86362001)(426003)(336012)(47076005)(2616005)(1076003)(186003)(16526019)(40480700001)(36756003)(82310400005)(81166007)(356005)(40460700003)(83380400001)(36860700001)(4326008)(316002)(70206006)(30864003)(70586007)(2906002)(44832011)(8676002)(8936002)(5660300002)(41300700001)(54906003)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 17:05:25.8101
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0568efcd-c85b-4fdb-bdec-08db40f8451b
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT066.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7490
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

Add the service routines for submitting and processing
the adminq messages and for handling notifyq events.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
 drivers/net/ethernet/amd/pds_core/Makefile |   1 +
 drivers/net/ethernet/amd/pds_core/adminq.c | 288 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.c   |  11 -
 include/linux/pds/pds_adminq.h             |  11 +-
 4 files changed, 299 insertions(+), 12 deletions(-)
 create mode 100644 drivers/net/ethernet/amd/pds_core/adminq.c

diff --git a/drivers/net/ethernet/amd/pds_core/Makefile b/drivers/net/ethernet/amd/pds_core/Makefile
index eaca8557ba66..ef76dcd7fccd 100644
--- a/drivers/net/ethernet/amd/pds_core/Makefile
+++ b/drivers/net/ethernet/amd/pds_core/Makefile
@@ -6,6 +6,7 @@ obj-$(CONFIG_PDS_CORE) := pds_core.o
 pds_core-y := main.o \
 	      devlink.o \
 	      dev.o \
+	      adminq.o \
 	      core.o
 
 pds_core-$(CONFIG_DEBUG_FS) += debugfs.o
diff --git a/drivers/net/ethernet/amd/pds_core/adminq.c b/drivers/net/ethernet/amd/pds_core/adminq.c
new file mode 100644
index 000000000000..fb2ba3f62480
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -0,0 +1,288 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
+
+#include <linux/dynamic_debug.h>
+
+#include "core.h"
+
+struct pdsc_wait_context {
+	struct pdsc_qcq *qcq;
+	struct completion wait_completion;
+};
+
+static int pdsc_process_notifyq(struct pdsc_qcq *qcq)
+{
+	union pds_core_notifyq_comp *comp;
+	struct pdsc *pdsc = qcq->pdsc;
+	struct pdsc_cq *cq = &qcq->cq;
+	struct pdsc_cq_info *cq_info;
+	int nq_work = 0;
+	u64 eid;
+
+	cq_info = &cq->info[cq->tail_idx];
+	comp = cq_info->comp;
+	eid = le64_to_cpu(comp->event.eid);
+	while (eid > pdsc->last_eid) {
+		u16 ecode = le16_to_cpu(comp->event.ecode);
+
+		switch (ecode) {
+		case PDS_EVENT_LINK_CHANGE:
+			dev_info(pdsc->dev, "NotifyQ LINK_CHANGE ecode %d eid %lld\n",
+				 ecode, eid);
+			break;
+
+		case PDS_EVENT_RESET:
+			dev_info(pdsc->dev, "NotifyQ RESET ecode %d eid %lld\n",
+				 ecode, eid);
+			break;
+
+		case PDS_EVENT_XCVR:
+			dev_info(pdsc->dev, "NotifyQ XCVR ecode %d eid %lld\n",
+				 ecode, eid);
+			break;
+
+		default:
+			dev_info(pdsc->dev, "NotifyQ ecode %d eid %lld\n",
+				 ecode, eid);
+			break;
+		}
+
+		pdsc->last_eid = eid;
+		cq->tail_idx = (cq->tail_idx + 1) & (cq->num_descs - 1);
+		cq_info = &cq->info[cq->tail_idx];
+		comp = cq_info->comp;
+		eid = le64_to_cpu(comp->event.eid);
+
+		nq_work++;
+	}
+
+	qcq->accum_work += nq_work;
+
+	return nq_work;
+}
+
+void pdsc_process_adminq(struct pdsc_qcq *qcq)
+{
+	union pds_core_adminq_comp *comp;
+	struct pdsc_queue *q = &qcq->q;
+	struct pdsc *pdsc = qcq->pdsc;
+	struct pdsc_cq *cq = &qcq->cq;
+	struct pdsc_q_info *q_info;
+	unsigned long irqflags;
+	int nq_work = 0;
+	int aq_work = 0;
+	int credits;
+
+	/* Don't process AdminQ when shutting down */
+	if (pdsc->state & BIT_ULL(PDSC_S_STOPPING_DRIVER)) {
+		dev_err(pdsc->dev, "%s: called while PDSC_S_STOPPING_DRIVER\n",
+			__func__);
+		return;
+	}
+
+	/* Check for NotifyQ event */
+	nq_work = pdsc_process_notifyq(&pdsc->notifyqcq);
+
+	/* Check for empty queue, which can happen if the interrupt was
+	 * for a NotifyQ event and there are no new AdminQ completions.
+	 */
+	if (q->tail_idx == q->head_idx)
+		goto credits;
+
+	/* Find the first completion to clean,
+	 * run the callback in the related q_info,
+	 * and continue while we still match done color
+	 */
+	spin_lock_irqsave(&pdsc->adminq_lock, irqflags);
+	comp = cq->info[cq->tail_idx].comp;
+	while (pdsc_color_match(comp->color, cq->done_color)) {
+		q_info = &q->info[q->tail_idx];
+		q->tail_idx = (q->tail_idx + 1) & (q->num_descs - 1);
+
+		/* Copy out the completion data */
+		memcpy(q_info->dest, comp, sizeof(*comp));
+
+		complete_all(&q_info->wc->wait_completion);
+
+		if (cq->tail_idx == cq->num_descs - 1)
+			cq->done_color = !cq->done_color;
+		cq->tail_idx = (cq->tail_idx + 1) & (cq->num_descs - 1);
+		comp = cq->info[cq->tail_idx].comp;
+
+		aq_work++;
+	}
+	spin_unlock_irqrestore(&pdsc->adminq_lock, irqflags);
+
+	qcq->accum_work += aq_work;
+
+credits:
+	/* Return the interrupt credits, one for each completion */
+	credits = nq_work + aq_work;
+	if (credits)
+		pds_core_intr_credits(&pdsc->intr_ctrl[qcq->intx],
+				      credits,
+				      PDS_CORE_INTR_CRED_REARM);
+}
+
+void pdsc_work_thread(struct work_struct *work)
+{
+	struct pdsc_qcq *qcq = container_of(work, struct pdsc_qcq, work);
+
+	pdsc_process_adminq(qcq);
+}
+
+irqreturn_t pdsc_adminq_isr(int irq, void *data)
+{
+	struct pdsc_qcq *qcq = data;
+	struct pdsc *pdsc = qcq->pdsc;
+
+	/* Don't process AdminQ when shutting down */
+	if (pdsc->state & BIT_ULL(PDSC_S_STOPPING_DRIVER)) {
+		dev_err(pdsc->dev, "%s: called while PDSC_S_STOPPING_DRIVER\n",
+			__func__);
+		return IRQ_HANDLED;
+	}
+
+	queue_work(pdsc->wq, &qcq->work);
+	pds_core_intr_mask(&pdsc->intr_ctrl[irq], PDS_CORE_INTR_MASK_CLEAR);
+
+	return IRQ_HANDLED;
+}
+
+static int __pdsc_adminq_post(struct pdsc *pdsc,
+			      struct pdsc_qcq *qcq,
+			      union pds_core_adminq_cmd *cmd,
+			      union pds_core_adminq_comp *comp,
+			      struct pdsc_wait_context *wc)
+{
+	struct pdsc_queue *q = &qcq->q;
+	struct pdsc_q_info *q_info;
+	unsigned long irqflags;
+	unsigned int avail;
+	int index;
+	int ret;
+
+	spin_lock_irqsave(&pdsc->adminq_lock, irqflags);
+
+	/* Check for space in the queue */
+	avail = q->tail_idx;
+	if (q->head_idx >= avail)
+		avail += q->num_descs - q->head_idx - 1;
+	else
+		avail -= q->head_idx + 1;
+	if (!avail) {
+		ret = -ENOSPC;
+		goto err_out_unlock;
+	}
+
+	/* Check that the FW is running */
+	if (!pdsc_is_fw_running(pdsc)) {
+		u8 fw_status = ioread8(&pdsc->info_regs->fw_status);
+
+		dev_info(pdsc->dev, "%s: post failed - fw not running %#02x:\n",
+			 __func__, fw_status);
+		ret = -ENXIO;
+
+		goto err_out_unlock;
+	}
+
+	/* Post the request */
+	index = q->head_idx;
+	q_info = &q->info[index];
+	q_info->wc = wc;
+	q_info->dest = comp;
+	memcpy(q_info->desc, cmd, sizeof(*cmd));
+
+	dev_dbg(pdsc->dev, "head_idx %d tail_idx %d\n",
+		q->head_idx, q->tail_idx);
+	dev_dbg(pdsc->dev, "post admin queue command:\n");
+	dynamic_hex_dump("cmd ", DUMP_PREFIX_OFFSET, 16, 1,
+			 cmd, sizeof(*cmd), true);
+
+	q->head_idx = (q->head_idx + 1) & (q->num_descs - 1);
+
+	pds_core_dbell_ring(pdsc->kern_dbpage,
+			    q->hw_type, q->dbval | q->head_idx);
+	ret = index;
+
+err_out_unlock:
+	spin_unlock_irqrestore(&pdsc->adminq_lock, irqflags);
+	return ret;
+}
+
+int pdsc_adminq_post(struct pdsc *pdsc,
+		     union pds_core_adminq_cmd *cmd,
+		     union pds_core_adminq_comp *comp,
+		     bool fast_poll)
+{
+	struct pdsc_wait_context wc = {
+		.wait_completion =
+			COMPLETION_INITIALIZER_ONSTACK(wc.wait_completion),
+	};
+	unsigned long poll_interval = 1;
+	unsigned long poll_jiffies;
+	unsigned long time_limit;
+	unsigned long time_start;
+	unsigned long time_done;
+	unsigned long remaining;
+	int err = 0;
+	int index;
+
+	wc.qcq = &pdsc->adminqcq;
+	index = __pdsc_adminq_post(pdsc, &pdsc->adminqcq, cmd, comp, &wc);
+	if (index < 0) {
+		err = index;
+		goto err_out;
+	}
+
+	time_start = jiffies;
+	time_limit = time_start + HZ * pdsc->devcmd_timeout;
+	do {
+		/* Timeslice the actual wait to catch IO errors etc early */
+		poll_jiffies = msecs_to_jiffies(poll_interval);
+		remaining = wait_for_completion_timeout(&wc.wait_completion,
+							poll_jiffies);
+		if (remaining)
+			break;
+
+		if (!pdsc_is_fw_running(pdsc)) {
+			u8 fw_status = ioread8(&pdsc->info_regs->fw_status);
+
+			dev_dbg(pdsc->dev, "%s: post wait failed - fw not running %#02x:\n",
+				__func__, fw_status);
+			err = -ENXIO;
+			break;
+		}
+
+		/* When fast_poll is not requested, prevent aggressive polling
+		 * on failures due to timeouts by doing exponential back off.
+		 */
+		if (!fast_poll && poll_interval < PDSC_ADMINQ_MAX_POLL_INTERVAL)
+			poll_interval <<= 1;
+	} while (time_before(jiffies, time_limit));
+	time_done = jiffies;
+	dev_dbg(pdsc->dev, "%s: elapsed %d msecs\n",
+		__func__, jiffies_to_msecs(time_done - time_start));
+
+	/* Check the results */
+	if (time_after_eq(time_done, time_limit))
+		err = -ETIMEDOUT;
+
+	dev_dbg(pdsc->dev, "read admin queue completion idx %d:\n", index);
+	dynamic_hex_dump("comp ", DUMP_PREFIX_OFFSET, 16, 1,
+			 comp, sizeof(*comp), true);
+
+	if (remaining && comp->status)
+		err = pdsc_err_to_errno(comp->status);
+
+err_out:
+	if (err) {
+		dev_dbg(pdsc->dev, "%s: opcode %d status %d err %pe\n",
+			__func__, cmd->opcode, comp->status, ERR_PTR(err));
+		if (err == -ENXIO || err == -ETIMEDOUT)
+			queue_work(pdsc->wq, &pdsc->health_work);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(pdsc_adminq_post);
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index 8c0dbdb5efc5..59daf8a67ac6 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -6,17 +6,6 @@
 
 #include "core.h"
 
-void pdsc_work_thread(struct work_struct *work)
-{
-	/* stub */
-}
-
-irqreturn_t pdsc_adminq_isr(int irq, void *data)
-{
-	/* stub */
-	return IRQ_HANDLED;
-}
-
 void pdsc_intr_free(struct pdsc *pdsc, int index)
 {
 	struct pdsc_intr_info *intr_info;
diff --git a/include/linux/pds/pds_adminq.h b/include/linux/pds/pds_adminq.h
index dd5fbe3ee141..98a60ce87b92 100644
--- a/include/linux/pds/pds_adminq.h
+++ b/include/linux/pds/pds_adminq.h
@@ -4,6 +4,8 @@
 #ifndef _PDS_CORE_ADMINQ_H_
 #define _PDS_CORE_ADMINQ_H_
 
+#define PDSC_ADMINQ_MAX_POLL_INTERVAL	256
+
 enum pds_core_adminq_flags {
 	PDS_AQ_FLAG_FASTPOLL	= BIT(1),	/* completion poll at 1ms */
 };
@@ -631,8 +633,15 @@ static_assert(sizeof(union pds_core_notifyq_comp) == 64);
  * where the meaning alternates between '1' and '0' for alternating
  * passes through the completion descriptor ring.
  */
-static inline u8 pdsc_color_match(u8 color, u8 done_color)
+static inline bool pdsc_color_match(u8 color, bool done_color)
 {
 	return (!!(color & PDS_COMP_COLOR_MASK)) == done_color;
 }
+
+struct pdsc;
+int pdsc_adminq_post(struct pdsc *pdsc,
+		     union pds_core_adminq_cmd *cmd,
+		     union pds_core_adminq_comp *comp,
+		     bool fast_poll);
+
 #endif /* _PDS_CORE_ADMINQ_H_ */
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FF206DA635
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 01:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjDFXmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 19:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238238AbjDFXmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 19:42:32 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2059.outbound.protection.outlook.com [40.107.243.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96929AD0A
        for <netdev@vger.kernel.org>; Thu,  6 Apr 2023 16:42:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mN+pewmujJBrCVJIb7vaKzW74qWj9mkrFXr0VWTM4qmJ5XOIBI9WUQ59+riODRB6Gd3Z38TyDV5LHaohHGgr6YWCUrpips3XbWGZ2KuUDJBJWJEi0LbOC5Vd0tg0+d2CH/W8iH/IJwDk9tEMvQd5gbbwZtUeuuvARiVAVz3TRrChQgRsw13prCf0YSsnAWy9QOt2JX06zDjCyB/lBlnpiPwN94ah7o57SX1yjA5h6/YjcuNHHs3zLQKec3HFzsUyUGuy/8k8db6teF8kUxTi3Dnamt1lfJkOmXumg5ZSiw6Ah+racY0WjyjIQtJzOeC6jnplfgTyMJQ55yO4fdIyjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XmlKh4fpRX3NrTcXgOs+HQzRJCDxaYG2g/lYkBSWgmk=;
 b=gaUGXudVlpVgHdYEzfzSz2D/fGvICN43vi09N02eLSz813+rq9rQIPxmx9SzsfpkRsf8PeYkopENxIQ4km+PdE/WBIDH4LL8hU+DAdziqr6lvfX3VFJ+vFJ5/mWt1hQHe7zrIhDE7xRSPA+Tc3APlX8k/Y9ITswRP6NsYRvqyxWXh3/xFLaV5D2qTPUWNp62Ec1D508JoiFm0KknYnIKHvblWO431+jHd9y8rCvXf7bLax9fvd4vjGTCcvF6tS3z8DX1iJzx2elOQEmoBbN0CjFDIg4nmtWsakkHI5221gfDqa2s+VrnVrW+HnCZkY/6dcE8pCv3yt2AFTD5xtpq6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XmlKh4fpRX3NrTcXgOs+HQzRJCDxaYG2g/lYkBSWgmk=;
 b=cdXm9XmYR2aoeSJRsAXehMgqv0Ega3oPnfXKQQdUIiTPWXPRIjHUXS2fZRgcGkRTzbyw3ok2MnB6yQoioRAwgBKjduDJrmT8IMZcHWuoUaaroPogBk2SEnieR/Xon7POvYOe8rb4Ck60iweEP5jR/76G6JlQdbLN30/eYomtjwg=
Received: from DS7PR06CA0012.namprd06.prod.outlook.com (2603:10b6:8:2a::22) by
 MW4PR12MB7013.namprd12.prod.outlook.com (2603:10b6:303:218::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.35; Thu, 6 Apr
 2023 23:42:22 +0000
Received: from DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
 (2603:10b6:8:2a:cafe::17) by DS7PR06CA0012.outlook.office365.com
 (2603:10b6:8:2a::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.31 via Frontend
 Transport; Thu, 6 Apr 2023 23:42:22 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT038.mail.protection.outlook.com (10.13.173.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6298.19 via Frontend Transport; Thu, 6 Apr 2023 23:42:22 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Thu, 6 Apr
 2023 18:42:21 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v9 net-next 06/14] pds_core: Add adminq processing and commands
Date:   Thu, 6 Apr 2023 16:41:35 -0700
Message-ID: <20230406234143.11318-7-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230406234143.11318-1-shannon.nelson@amd.com>
References: <20230406234143.11318-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB03.amd.com (10.181.40.144) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT038:EE_|MW4PR12MB7013:EE_
X-MS-Office365-Filtering-Correlation-Id: e292e748-8139-411a-2e3b-08db36f89183
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iBLZPJ8TcMl7BsmeKPtKx1ZxcPZcznRd2zGefq8q4xcy+/wH97IdBlkct9kLThE2LTJCiUaCMlNoChjA9IdjnuIPboa2c9lxv4wraoHy9g1kImSsNsfqK9WftYBlfLYu6mwvK5CcgcEV0NIMDEoRVT9DmaKGbhv/8QW0hGatF4smwcz3429x/sVcExgtjpMxcShbHqAZThW0v5bKnVFvRXTU+rDH0oTee14K8UWX9Mn/CaoCs5VRlLc1vqEOBSl76DHaFWCU4rwaOPf96LHhgpU1JHc4GYzsYKxnX+yZwDICfIhyC/oLhYRb1G8yIpszrz8VcOstbQifN0Tt3Nh7frh5mHqJTb5TPkBFOOT0hFB0r/bVvFojQMMWs+s/Ked+I5iMiGJOY7EFj3eQoB3Dzw7+Pc4bmo33+oz7f80DZr1i1bC1GU7bM3SpFhSodxXcnk9ZnTsPCmavdpPEy/bWJXujXO/mt7tdKRJeCIfWXQ3Zf5M+GhKfY34r6sT/MuOZisClLjux9R9tC/UsiLPnZZeWs0cbrTxY31+ri8o5i9dfD/OJ9KZNBISupNmB49qUFw9x7V4dEftyHpbtf62LJSY5KWwCGkVp65azDl2jdcNlDwUpUFsfQ0PN7oHHskbLZPSPlTrgPjoXm5BElOv9j7v1vDVkDvscnVpWtsKcveb8dUZHmAgxI8h0SGivFvFUP1zr77UTF8QAVOl+kixa4HIIgoDJUOFM89y/t0Moj/k=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(136003)(396003)(346002)(451199021)(40470700004)(46966006)(36840700001)(40460700003)(54906003)(478600001)(110136005)(4326008)(41300700001)(316002)(70206006)(70586007)(36756003)(86362001)(336012)(2616005)(426003)(83380400001)(26005)(36860700001)(1076003)(47076005)(16526019)(6666004)(44832011)(2906002)(8936002)(82310400005)(8676002)(40480700001)(186003)(81166007)(82740400003)(5660300002)(356005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2023 23:42:22.3514
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: e292e748-8139-411a-2e3b-08db36f89183
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT038.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR12MB7013
X-Spam-Status: No, score=0.8 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the service routines for submitting and processing
the adminq messages and for handling notifyq events.

Signed-off-by: Shannon Nelson <shannon.nelson@amd.com>
---
 drivers/net/ethernet/amd/pds_core/Makefile |   1 +
 drivers/net/ethernet/amd/pds_core/adminq.c | 289 +++++++++++++++++++++
 drivers/net/ethernet/amd/pds_core/core.c   |  11 -
 include/linux/pds/pds_adminq.h             |   8 +
 4 files changed, 298 insertions(+), 11 deletions(-)
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
index 000000000000..25c7dd0d37e5
--- /dev/null
+++ b/drivers/net/ethernet/amd/pds_core/adminq.c
@@ -0,0 +1,289 @@
+// SPDX-License-Identifier: GPL-2.0
+/* Copyright(c) 2023 Advanced Micro Devices, Inc */
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
+	int ret = 0;
+	int index;
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
+int pdsc_adminq_post(void *pdsc_void,
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
+	struct pdsc *pdsc;
+	int err = 0;
+	int index;
+
+	pdsc = (struct pdsc *)pdsc_void;
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
index ec78510fcce7..7c5ccff4005c 100644
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
index 9cd58b7f5fb2..797d93fd0473 100644
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
@@ -634,4 +636,10 @@ static inline u8 pdsc_color_match(u8 color, u8 done_color)
 {
 	return (!!(color & PDS_COMP_COLOR_MASK)) == done_color;
 }
+
+int pdsc_adminq_post(void *pdsc,
+		     union pds_core_adminq_cmd *cmd,
+		     union pds_core_adminq_comp *comp,
+		     bool fast_poll);
+
 #endif /* _PDS_CORE_ADMINQ_H_ */
-- 
2.17.1


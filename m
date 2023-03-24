Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C5436C8580
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 20:03:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230377AbjCXTDZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 15:03:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbjCXTDQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 15:03:16 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2083.outbound.protection.outlook.com [40.107.237.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E605210402
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 12:03:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OjnuntL9e4nSo1G0+NZMpn4h6rKBiTksXJYf6xoQ9enrJiWOvZ+4SRZtgu80kQmJQP/F4K+WBU8wd+wG8qpKWZpf1V2ExpiHbBnYHqnXd2wVU89p97tA2hKDmGJ+DmwPbv31kUABryIDct6UZR/7tC/Gj1SViIUQwH0EUn1ueD7CAdVNIQf5QbK4ojwjdysoXRWbc8FrCiAyF6ScDjl8/ta+e0ARaA1DlFL6TkWW5iGH/UVKR9LsPr+mtsRj2y7hfL9nDh5ob3Fhq9Cgf4W/WDQ17crRgJKd53p9XMHYFjBMRe4lsfQG0gWcBggswbQ4Vd2QhUy5Rs4STj02hiXCPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+xHNIZqXVBKQp6fHotPsqZ2yTpCbzFtUarbkN7tMcJg=;
 b=X3rENDBqxRaTQ8HM0Mpt1lMug2beT7skW1JjJgrqLNV4QkspfNAcSlzeN9hXwCIamolbNBvpaUiDKaRDgSqkIRp6k/Qime2lB/fVPwSVIRp0/r8ghe7DqMAkQt3qDcdYHkC9SZ/OHk7m9X+QRIIO9iMgILAK6F4jRW73WoTXXRGzoEkiRi/02L86RCDB0GaRRQabcIhT5e0kKIYZQLYwqxWGjwTEQjd74T28Dn5wssJxpdo6rz5wMksNd7EirbCPVkBCaBXdVpABrVK0PQZPIaHx5UPpcpLv3FWWkabHl+CnfUCr80Q5yIzSwaAqHNMQoUu7TyE0bFL3A7nL6AyE+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=davemloft.net smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+xHNIZqXVBKQp6fHotPsqZ2yTpCbzFtUarbkN7tMcJg=;
 b=3FcBKIQcQYN01ekoUzK8FM/uBymxux8YBBb6upqfH1t8kAaMVKlraNkBbSu24mL+z1dqbp8Ex9pdire26Foj4/lwROOWY2EIcI5mH39TjpKce3dUhxGROqUIjTesioR6ztV27u0WmRQhUMzr4YellCyo5rdVxYqlKyFPAVibBBA=
Received: from DM6PR02CA0155.namprd02.prod.outlook.com (2603:10b6:5:332::22)
 by DM4PR12MB6229.namprd12.prod.outlook.com (2603:10b6:8:a8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38; Fri, 24 Mar
 2023 19:03:11 +0000
Received: from DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:332:cafe::8f) by DM6PR02CA0155.outlook.office365.com
 (2603:10b6:5:332::22) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.38 via Frontend
 Transport; Fri, 24 Mar 2023 19:03:11 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DM6NAM11FT051.mail.protection.outlook.com (10.13.172.243) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6222.22 via Frontend Transport; Fri, 24 Mar 2023 19:03:11 +0000
Received: from driver-dev1.pensando.io (10.180.168.240) by SATLEXMB04.amd.com
 (10.181.40.145) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.34; Fri, 24 Mar
 2023 14:03:10 -0500
From:   Shannon Nelson <shannon.nelson@amd.com>
To:     <shannon.nelson@amd.com>, <brett.creeley@amd.com>,
        <davem@davemloft.net>, <netdev@vger.kernel.org>, <kuba@kernel.org>
CC:     <drivers@pensando.io>, <leon@kernel.org>, <jiri@resnulli.us>
Subject: [PATCH v6 net-next 06/14] pds_core: Add adminq processing and commands
Date:   Fri, 24 Mar 2023 12:02:35 -0700
Message-ID: <20230324190243.27722-7-shannon.nelson@amd.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20230324190243.27722-1-shannon.nelson@amd.com>
References: <20230324190243.27722-1-shannon.nelson@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6NAM11FT051:EE_|DM4PR12MB6229:EE_
X-MS-Office365-Filtering-Correlation-Id: 2f9fd29a-b883-4907-926d-08db2c9a69c8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q6U2HIfgkQ4QX164xKAZ6r8WsWKI6Z2kWJJfm7QKsCsX39Qog5rJREiueJSIDvUZ2EBqENt+/I56Q/P5Q3JCw3IK2zNg+3A/rFuGGfz6FzTcRkEjvq7uQpRYTkjsod3+/F3m8hlGx2BMenLtDE4nTeZxlrTc+nsLd/iNYBemv9bhCqhFb4fVcBz87naSPtqZ61y4dsZgcXQfNskVp9SQd3vG+S/2Y+GIXVkKnxKdDlpUDbdLNBactkvxvFEdIvH3hc8natQV1DrsQwi2p9AbVfh5bQ602dR+GBGBpQbYjOnihDTQtaEHRJ4Dy7rc4A4Ddu8+PY8rg4g/r1wZ+BymY8RskKVWB3ELXCee8MEBZsjvmRW8LQvSpnGdxHPyszW30vB9i0z3m+IwhFzugOgVO6wzgSAggoUo3fYE9g+Cf1MWk/EexYrR11ADyvJjVOHjWm+SzbCgYUMPtT8rF79RSHC7XGuko6FRWEfXP4+4f9h+n/fR3sSRMDdfdm+EeMcBUxGW5j4aSFuswNWz+HWLH18znVxz6GEPnTpFV69Hss2z7g7TVcERThdJJJSwnKSXILIm3imNBO+Yr8YNjWknBziyFRhlikoQ75/WJp+qN/VNjY86W4+5Xh1WmIJP1b/AJfO7BdlZMJ+abGclrVuNc6BbaMB5y6jQ7Wl6NKnu0V+TT1W8PyVjTo2fmY5r6sa/VX/pNQcOdlrpyLBr/kPeCvg1DDlhlPK/jm53Ul4aJEE=
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(39860400002)(346002)(376002)(451199021)(36840700001)(46966006)(40470700004)(8676002)(5660300002)(41300700001)(4326008)(8936002)(83380400001)(426003)(40480700001)(82310400005)(70586007)(316002)(478600001)(70206006)(2616005)(16526019)(186003)(36756003)(1076003)(47076005)(26005)(81166007)(336012)(54906003)(44832011)(40460700003)(82740400003)(356005)(110136005)(6666004)(2906002)(86362001)(36860700001)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Mar 2023 19:03:11.3770
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f9fd29a-b883-4907-926d-08db2c9a69c8
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT051.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6229
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE autolearn=unavailable
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
index 000000000000..f9fb04308eff
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
+			pdsc_queue_health_check(pdsc);
+	}
+
+	return err;
+}
+EXPORT_SYMBOL_GPL(pdsc_adminq_post);
diff --git a/drivers/net/ethernet/amd/pds_core/core.c b/drivers/net/ethernet/amd/pds_core/core.c
index e93ec596a25d..1babb1b4c04c 100644
--- a/drivers/net/ethernet/amd/pds_core/core.c
+++ b/drivers/net/ethernet/amd/pds_core/core.c
@@ -5,17 +5,6 @@
 
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


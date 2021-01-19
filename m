Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC7512FB8D2
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394826AbhASNsv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 08:48:51 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:41230 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389321AbhASKCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jan 2021 05:02:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10JA0Uk1030432;
        Tue, 19 Jan 2021 02:01:29 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=y4dEcxHXOsZw/EpcF/5zqNqd0m3rmjwAihA139rb+o4=;
 b=GFrhW+YzVXKQxshV5I+UStNXaJMiERjpbA+PTvwD1wwIhFk+KJ7iXSspHMRHXix2JO1E
 g+/QLO72pybiE8FZUanCaYq4HkkEGGNxIVnpyyu01+z9nENIf0lvfQigR/dIGrE32ydd
 koawQ9JnbkdhWd1WjAxNeghXH/FvOB6frmyelGYfqsYi5WsteFDrmdh6J0bUnjQ0p6g2
 d2dk+ArTq3dq6EF9cDEFSFLqI2XeLi2sg4XrNx7IubdbQ5kQefcgcNUHkblxaGaD7UCU
 azv46aoAtAdEpI3ogDvMqw+tbn8g2UXz8PBAjOcEaC4c4e1hTMd0KYJkt5DoM7/RT26P EQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 363xcue7uf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 19 Jan 2021 02:01:29 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 19 Jan
 2021 02:01:28 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 19 Jan 2021 02:01:28 -0800
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 1EFB63F7040;
        Tue, 19 Jan 2021 02:01:24 -0800 (PST)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>,
        <george.cherian@marvell.com>, <corbet@lwn.net>
Subject: [PATCH net-next 1/2] octeontx2-af: Add devlink health reporters for NIX
Date:   Tue, 19 Jan 2021 15:31:19 +0530
Message-ID: <20210119100120.2614730-2-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210119100120.2614730-1-george.cherian@marvell.com>
References: <20210119100120.2614730-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-19_02:2021-01-18,2021-01-19 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add health reporters for RVU NIX block.
NIX Health reporters handle following HW event groups
- GENERAL events
- ERROR events
- RAS events
- RVU event

Output:

 # devlink health
 pci/0002:01:00.0:
   reporter hw_npa_intr
     state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
   reporter hw_npa_gen
     state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
   reporter hw_npa_err
     state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
   reporter hw_npa_ras
     state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
   reporter hw_nix_intr
     state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
   reporter hw_nix_gen
     state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
   reporter hw_nix_err
     state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true
   reporter hw_nix_ras
     state healthy error 0 recover 0 grace_period 0 auto_recover true auto_dump true

 # devlink health dump show pci/0002:01:00.0 reporter hw_nix_intr
  NIX_AF_RVU:
	NIX RVU Interrupt Reg : 1
	Unmap Slot Error
 # devlink health dump show pci/0002:01:00.0 reporter hw_nix_gen
  NIX_AF_GENERAL:
	NIX General Interrupt Reg : 1
	Rx multicast pkt drop

Each reporter dump shows the Register value and the description of the cause.

Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 652 +++++++++++++++++-
 .../marvell/octeontx2/af/rvu_devlink.h        |  27 +
 .../marvell/octeontx2/af/rvu_struct.h         |  10 +
 3 files changed, 688 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index bc0e4113370e..10a98bcb7c54 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -52,6 +52,650 @@ static bool rvu_common_request_irq(struct rvu *rvu, int offset,
 	return rvu->irq_allocated[offset];
 }
 
+static void rvu_nix_intr_work(struct work_struct *work)
+{
+	struct rvu_nix_health_reporters *rvu_nix_health_reporter;
+
+	rvu_nix_health_reporter = container_of(work, struct rvu_nix_health_reporters, intr_work);
+	devlink_health_report(rvu_nix_health_reporter->rvu_hw_nix_intr_reporter,
+			      "NIX_AF_RVU Error",
+			      rvu_nix_health_reporter->nix_event_ctx);
+}
+
+static irqreturn_t rvu_nix_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu_nix_event_ctx *nix_event_context;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	nix_event_context = rvu_dl->rvu_nix_health_reporter->nix_event_ctx;
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RVU_INT);
+	nix_event_context->nix_af_rvu_int = intr;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT, intr);
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1C, ~0ULL);
+	queue_work(rvu_dl->devlink_wq, &rvu_dl->rvu_nix_health_reporter->intr_work);
+
+	return IRQ_HANDLED;
+}
+
+static void rvu_nix_gen_work(struct work_struct *work)
+{
+	struct rvu_nix_health_reporters *rvu_nix_health_reporter;
+
+	rvu_nix_health_reporter = container_of(work, struct rvu_nix_health_reporters, gen_work);
+	devlink_health_report(rvu_nix_health_reporter->rvu_hw_nix_gen_reporter,
+			      "NIX_AF_GEN Error",
+			      rvu_nix_health_reporter->nix_event_ctx);
+}
+
+static irqreturn_t rvu_nix_af_rvu_gen_handler(int irq, void *rvu_irq)
+{
+	struct rvu_nix_event_ctx *nix_event_context;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	nix_event_context = rvu_dl->rvu_nix_health_reporter->nix_event_ctx;
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_GEN_INT);
+	nix_event_context->nix_af_rvu_gen = intr;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_GEN_INT, intr);
+	rvu_write64(rvu, blkaddr, NIX_AF_GEN_INT_ENA_W1C, ~0ULL);
+	queue_work(rvu_dl->devlink_wq, &rvu_dl->rvu_nix_health_reporter->gen_work);
+
+	return IRQ_HANDLED;
+}
+
+static void rvu_nix_err_work(struct work_struct *work)
+{
+	struct rvu_nix_health_reporters *rvu_nix_health_reporter;
+
+	rvu_nix_health_reporter = container_of(work, struct rvu_nix_health_reporters, err_work);
+	devlink_health_report(rvu_nix_health_reporter->rvu_hw_nix_err_reporter,
+			      "NIX_AF_ERR Error",
+			      rvu_nix_health_reporter->nix_event_ctx);
+}
+
+static irqreturn_t rvu_nix_af_rvu_err_handler(int irq, void *rvu_irq)
+{
+	struct rvu_nix_event_ctx *nix_event_context;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	nix_event_context = rvu_dl->rvu_nix_health_reporter->nix_event_ctx;
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_ERR_INT);
+	nix_event_context->nix_af_rvu_err = intr;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT, intr);
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1C, ~0ULL);
+	queue_work(rvu_dl->devlink_wq, &rvu_dl->rvu_nix_health_reporter->err_work);
+
+	return IRQ_HANDLED;
+}
+
+static void rvu_nix_ras_work(struct work_struct *work)
+{
+	struct rvu_nix_health_reporters *rvu_nix_health_reporter;
+
+	rvu_nix_health_reporter = container_of(work, struct rvu_nix_health_reporters, ras_work);
+	devlink_health_report(rvu_nix_health_reporter->rvu_hw_nix_ras_reporter,
+			      "NIX_AF_RAS Error",
+			      rvu_nix_health_reporter->nix_event_ctx);
+}
+
+static irqreturn_t rvu_nix_af_rvu_ras_handler(int irq, void *rvu_irq)
+{
+	struct rvu_nix_event_ctx *nix_event_context;
+	struct rvu_devlink *rvu_dl = rvu_irq;
+	struct rvu *rvu;
+	int blkaddr;
+	u64 intr;
+
+	rvu = rvu_dl->rvu;
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	nix_event_context = rvu_dl->rvu_nix_health_reporter->nix_event_ctx;
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_ERR_INT);
+	nix_event_context->nix_af_rvu_ras = intr;
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS, intr);
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1C, ~0ULL);
+	queue_work(rvu_dl->devlink_wq, &rvu_dl->rvu_nix_health_reporter->ras_work);
+
+	return IRQ_HANDLED;
+}
+
+static void rvu_nix_unregister_interrupts(struct rvu *rvu)
+{
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	int offs, i, blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return;
+
+	offs = rvu_read64(rvu, blkaddr, NIX_PRIV_AF_INT_CFG) & 0x3ff;
+	if (!offs)
+		return;
+
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NIX_AF_GEN_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1C, ~0ULL);
+
+	if (rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU]) {
+		free_irq(pci_irq_vector(rvu->pdev, offs + NIX_AF_INT_VEC_RVU),
+			 rvu_dl);
+		rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU] = false;
+	}
+
+	for (i = NIX_AF_INT_VEC_AF_ERR; i < NIX_AF_INT_VEC_CNT; i++)
+		if (rvu->irq_allocated[offs + i]) {
+			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu_dl);
+			rvu->irq_allocated[offs + i] = false;
+		}
+}
+
+static int rvu_nix_register_interrupts(struct rvu *rvu)
+{
+	int blkaddr, base;
+	bool rc;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	/* Get NIX AF MSIX vectors offset. */
+	base = rvu_read64(rvu, blkaddr, NIX_PRIV_AF_INT_CFG) & 0x3ff;
+	if (!base) {
+		dev_warn(rvu->dev,
+			 "Failed to get NIX%d NIX_AF_INT vector offsets\n",
+			 blkaddr - BLKADDR_NIX0);
+		return 0;
+	}
+	/* Register and enable NIX_AF_RVU_INT interrupt */
+	rc = rvu_common_request_irq(rvu, base +  NIX_AF_INT_VEC_RVU,
+				    "NIX_AF_RVU_INT",
+				    rvu_nix_af_rvu_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_GEN_INT interrupt */
+	rc = rvu_common_request_irq(rvu, base +  NIX_AF_INT_VEC_GEN,
+				    "NIX_AF_GEN_INT",
+				    rvu_nix_af_rvu_gen_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_GEN_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_ERR_INT interrupt */
+	rc = rvu_common_request_irq(rvu, base + NIX_AF_INT_VEC_AF_ERR,
+				    "NIX_AF_ERR_INT",
+				    rvu_nix_af_rvu_err_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_RAS interrupt */
+	rc = rvu_common_request_irq(rvu, base + NIX_AF_INT_VEC_POISON,
+				    "NIX_AF_RAS",
+				    rvu_nix_af_rvu_ras_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1S, ~0ULL);
+
+	return 0;
+err:
+	rvu_nix_unregister_interrupts(rvu);
+	return rc;
+}
+
+static int rvu_nix_report_show(struct devlink_fmsg *fmsg, void *ctx,
+			       enum nix_af_rvu_health health_reporter)
+{
+	struct rvu_nix_event_ctx *nix_event_context;
+	u64 intr_val;
+	int err;
+
+	nix_event_context = ctx;
+	switch (health_reporter) {
+	case NIX_AF_RVU_INTR:
+		intr_val = nix_event_context->nix_af_rvu_int;
+		err = rvu_report_pair_start(fmsg, "NIX_AF_RVU");
+		if (err)
+			return err;
+		err = devlink_fmsg_u64_pair_put(fmsg, "\tNIX RVU Interrupt Reg ",
+						nix_event_context->nix_af_rvu_int);
+		if (err)
+			return err;
+		if (intr_val & BIT_ULL(0)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tUnmap Slot Error");
+			if (err)
+				return err;
+		}
+		err = rvu_report_pair_end(fmsg);
+		if (err)
+			return err;
+		break;
+	case NIX_AF_RVU_GEN:
+		intr_val = nix_event_context->nix_af_rvu_gen;
+		err = rvu_report_pair_start(fmsg, "NIX_AF_GENERAL");
+		if (err)
+			return err;
+		err = devlink_fmsg_u64_pair_put(fmsg, "\tNIX General Interrupt Reg ",
+						nix_event_context->nix_af_rvu_gen);
+		if (err)
+			return err;
+		if (intr_val & BIT_ULL(0)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tRx multicast pkt drop");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(1)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tRx mirror pkt drop");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(4)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tSMQ flush done");
+			if (err)
+				return err;
+		}
+		err = rvu_report_pair_end(fmsg);
+		if (err)
+			return err;
+		break;
+	case NIX_AF_RVU_ERR:
+		intr_val = nix_event_context->nix_af_rvu_err;
+		err = rvu_report_pair_start(fmsg, "NIX_AF_ERR");
+		if (err)
+			return err;
+		err = devlink_fmsg_u64_pair_put(fmsg, "\tNIX Error Interrupt Reg ",
+						nix_event_context->nix_af_rvu_err);
+		if (err)
+			return err;
+		if (intr_val & BIT_ULL(14)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFault on NIX_AQ_INST_S read");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(13)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFault on NIX_AQ_RES_S write");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(12)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tAQ Doorbell Error");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(6)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tRx on unmapped PF_FUNC");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(5)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tRx multicast replication error");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(4)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFault on NIX_RX_MCE_S read");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(3)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFault on multicast WQE read");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(2)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFault on mirror WQE read");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(1)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFault on mirror pkt write");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(0)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tFault on multicast pkt write");
+			if (err)
+				return err;
+		}
+		err = rvu_report_pair_end(fmsg);
+		if (err)
+			return err;
+		break;
+	case NIX_AF_RVU_RAS:
+		intr_val = nix_event_context->nix_af_rvu_err;
+		err = rvu_report_pair_start(fmsg, "NIX_AF_RAS");
+		if (err)
+			return err;
+		err = devlink_fmsg_u64_pair_put(fmsg, "\tNIX RAS Interrupt Reg ",
+						nix_event_context->nix_af_rvu_err);
+		if (err)
+			return err;
+		err = devlink_fmsg_string_put(fmsg, "\n\tPoison Data on:");
+		if (err)
+			return err;
+		if (intr_val & BIT_ULL(34)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX_AQ_INST_S");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(33)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX_AQ_RES_S");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(32)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tHW ctx");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(4)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tPacket from mirror buffer");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(3)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tPacket from multicast buffer");
+
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(2)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tWQE read from mirror buffer");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(1)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tWQE read from multicast buffer");
+			if (err)
+				return err;
+		}
+		if (intr_val & BIT_ULL(0)) {
+			err = devlink_fmsg_string_put(fmsg, "\n\tNIX_RX_MCE_S read");
+			if (err)
+				return err;
+		}
+		err = rvu_report_pair_end(fmsg);
+		if (err)
+			return err;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int rvu_hw_nix_intr_dump(struct devlink_health_reporter *reporter,
+				struct devlink_fmsg *fmsg, void *ctx,
+				struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	struct rvu_nix_event_ctx *nix_ctx;
+
+	nix_ctx = rvu_dl->rvu_nix_health_reporter->nix_event_ctx;
+
+	return ctx ? rvu_nix_report_show(fmsg, ctx, NIX_AF_RVU_INTR) :
+		     rvu_nix_report_show(fmsg, nix_ctx, NIX_AF_RVU_INTR);
+}
+
+static int rvu_hw_nix_intr_recover(struct devlink_health_reporter *reporter,
+				   void *ctx, struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_nix_event_ctx *nix_event_ctx = ctx;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	if (nix_event_ctx->nix_af_rvu_int)
+		rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1S, ~0ULL);
+
+	return 0;
+}
+
+static int rvu_hw_nix_gen_dump(struct devlink_health_reporter *reporter,
+			       struct devlink_fmsg *fmsg, void *ctx,
+			       struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	struct rvu_nix_event_ctx *nix_ctx;
+
+	nix_ctx = rvu_dl->rvu_nix_health_reporter->nix_event_ctx;
+
+	return ctx ? rvu_nix_report_show(fmsg, ctx, NIX_AF_RVU_GEN) :
+		     rvu_nix_report_show(fmsg, nix_ctx, NIX_AF_RVU_GEN);
+}
+
+static int rvu_hw_nix_gen_recover(struct devlink_health_reporter *reporter,
+				  void *ctx, struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_nix_event_ctx *nix_event_ctx = ctx;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	if (nix_event_ctx->nix_af_rvu_gen)
+		rvu_write64(rvu, blkaddr, NIX_AF_GEN_INT_ENA_W1S, ~0ULL);
+
+	return 0;
+}
+
+static int rvu_hw_nix_err_dump(struct devlink_health_reporter *reporter,
+			       struct devlink_fmsg *fmsg, void *ctx,
+			       struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	struct rvu_nix_event_ctx *nix_ctx;
+
+	nix_ctx = rvu_dl->rvu_nix_health_reporter->nix_event_ctx;
+
+	return ctx ? rvu_nix_report_show(fmsg, ctx, NIX_AF_RVU_ERR) :
+		     rvu_nix_report_show(fmsg, nix_ctx, NIX_AF_RVU_ERR);
+}
+
+static int rvu_hw_nix_err_recover(struct devlink_health_reporter *reporter,
+				  void *ctx, struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_nix_event_ctx *nix_event_ctx = ctx;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	if (nix_event_ctx->nix_af_rvu_err)
+		rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1S, ~0ULL);
+
+	return 0;
+}
+
+static int rvu_hw_nix_ras_dump(struct devlink_health_reporter *reporter,
+			       struct devlink_fmsg *fmsg, void *ctx,
+			       struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_devlink *rvu_dl = rvu->rvu_dl;
+	struct rvu_nix_event_ctx *nix_ctx;
+
+	nix_ctx = rvu_dl->rvu_nix_health_reporter->nix_event_ctx;
+
+	return ctx ? rvu_nix_report_show(fmsg, ctx, NIX_AF_RVU_RAS) :
+		     rvu_nix_report_show(fmsg, nix_ctx, NIX_AF_RVU_RAS);
+}
+
+static int rvu_hw_nix_ras_recover(struct devlink_health_reporter *reporter,
+				  void *ctx, struct netlink_ext_ack *netlink_extack)
+{
+	struct rvu *rvu = devlink_health_reporter_priv(reporter);
+	struct rvu_nix_event_ctx *nix_event_ctx = ctx;
+	int blkaddr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	if (nix_event_ctx->nix_af_rvu_int)
+		rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1S, ~0ULL);
+
+	return 0;
+}
+
+RVU_REPORTERS(hw_nix_intr);
+RVU_REPORTERS(hw_nix_gen);
+RVU_REPORTERS(hw_nix_err);
+RVU_REPORTERS(hw_nix_ras);
+
+static void rvu_nix_health_reporters_destroy(struct rvu_devlink *rvu_dl);
+
+static int rvu_nix_register_reporters(struct rvu_devlink *rvu_dl)
+{
+	struct rvu_nix_health_reporters *rvu_reporters;
+	struct rvu_nix_event_ctx *nix_event_context;
+	struct rvu *rvu = rvu_dl->rvu;
+
+	rvu_reporters = kzalloc(sizeof(*rvu_reporters), GFP_KERNEL);
+	if (!rvu_reporters)
+		return -ENOMEM;
+
+	rvu_dl->rvu_nix_health_reporter = rvu_reporters;
+	nix_event_context = kzalloc(sizeof(*nix_event_context), GFP_KERNEL);
+	if (!nix_event_context)
+		return -ENOMEM;
+
+	rvu_reporters->nix_event_ctx = nix_event_context;
+	rvu_reporters->rvu_hw_nix_intr_reporter =
+		devlink_health_reporter_create(rvu_dl->dl, &rvu_hw_nix_intr_reporter_ops, 0, rvu);
+	if (IS_ERR(rvu_reporters->rvu_hw_nix_intr_reporter)) {
+		dev_warn(rvu->dev, "Failed to create hw_nix_intr reporter, err=%ld\n",
+			 PTR_ERR(rvu_reporters->rvu_hw_nix_intr_reporter));
+		return PTR_ERR(rvu_reporters->rvu_hw_nix_intr_reporter);
+	}
+
+	rvu_reporters->rvu_hw_nix_gen_reporter =
+		devlink_health_reporter_create(rvu_dl->dl, &rvu_hw_nix_gen_reporter_ops, 0, rvu);
+	if (IS_ERR(rvu_reporters->rvu_hw_nix_gen_reporter)) {
+		dev_warn(rvu->dev, "Failed to create hw_nix_gen reporter, err=%ld\n",
+			 PTR_ERR(rvu_reporters->rvu_hw_nix_gen_reporter));
+		return PTR_ERR(rvu_reporters->rvu_hw_nix_gen_reporter);
+	}
+
+	rvu_reporters->rvu_hw_nix_err_reporter =
+		devlink_health_reporter_create(rvu_dl->dl, &rvu_hw_nix_err_reporter_ops, 0, rvu);
+	if (IS_ERR(rvu_reporters->rvu_hw_nix_err_reporter)) {
+		dev_warn(rvu->dev, "Failed to create hw_nix_err reporter, err=%ld\n",
+			 PTR_ERR(rvu_reporters->rvu_hw_nix_err_reporter));
+		return PTR_ERR(rvu_reporters->rvu_hw_nix_err_reporter);
+	}
+
+	rvu_reporters->rvu_hw_nix_ras_reporter =
+		devlink_health_reporter_create(rvu_dl->dl, &rvu_hw_nix_ras_reporter_ops, 0, rvu);
+	if (IS_ERR(rvu_reporters->rvu_hw_nix_ras_reporter)) {
+		dev_warn(rvu->dev, "Failed to create hw_nix_ras reporter, err=%ld\n",
+			 PTR_ERR(rvu_reporters->rvu_hw_nix_ras_reporter));
+		return PTR_ERR(rvu_reporters->rvu_hw_nix_ras_reporter);
+	}
+
+	rvu_dl->devlink_wq = create_workqueue("rvu_devlink_wq");
+	if (!rvu_dl->devlink_wq)
+		goto err;
+
+	INIT_WORK(&rvu_reporters->intr_work, rvu_nix_intr_work);
+	INIT_WORK(&rvu_reporters->gen_work, rvu_nix_gen_work);
+	INIT_WORK(&rvu_reporters->err_work, rvu_nix_err_work);
+	INIT_WORK(&rvu_reporters->ras_work, rvu_nix_ras_work);
+
+	return 0;
+err:
+	rvu_nix_health_reporters_destroy(rvu_dl);
+	return -ENOMEM;
+}
+
+static int rvu_nix_health_reporters_create(struct rvu_devlink *rvu_dl)
+{
+	struct rvu *rvu = rvu_dl->rvu;
+	int err;
+
+	err = rvu_nix_register_reporters(rvu_dl);
+	if (err) {
+		dev_warn(rvu->dev, "Failed to create nix reporter, err =%d\n",
+			 err);
+		return err;
+	}
+	rvu_nix_register_interrupts(rvu);
+
+	return 0;
+}
+
+static void rvu_nix_health_reporters_destroy(struct rvu_devlink *rvu_dl)
+{
+	struct rvu_nix_health_reporters *nix_reporters;
+	struct rvu *rvu = rvu_dl->rvu;
+
+	nix_reporters = rvu_dl->rvu_nix_health_reporter;
+
+	if (!nix_reporters->rvu_hw_nix_ras_reporter)
+		return;
+	if (!IS_ERR_OR_NULL(nix_reporters->rvu_hw_nix_intr_reporter))
+		devlink_health_reporter_destroy(nix_reporters->rvu_hw_nix_intr_reporter);
+
+	if (!IS_ERR_OR_NULL(nix_reporters->rvu_hw_nix_gen_reporter))
+		devlink_health_reporter_destroy(nix_reporters->rvu_hw_nix_gen_reporter);
+
+	if (!IS_ERR_OR_NULL(nix_reporters->rvu_hw_nix_err_reporter))
+		devlink_health_reporter_destroy(nix_reporters->rvu_hw_nix_err_reporter);
+
+	if (!IS_ERR_OR_NULL(nix_reporters->rvu_hw_nix_ras_reporter))
+		devlink_health_reporter_destroy(nix_reporters->rvu_hw_nix_ras_reporter);
+
+	rvu_nix_unregister_interrupts(rvu);
+	kfree(rvu_dl->rvu_nix_health_reporter->nix_event_ctx);
+	kfree(rvu_dl->rvu_nix_health_reporter);
+}
+
 static void rvu_npa_intr_work(struct work_struct *work)
 {
 	struct rvu_npa_health_reporters *rvu_npa_health_reporter;
@@ -698,9 +1342,14 @@ static void rvu_npa_health_reporters_destroy(struct rvu_devlink *rvu_dl)
 static int rvu_health_reporters_create(struct rvu *rvu)
 {
 	struct rvu_devlink *rvu_dl;
+	int err;
 
 	rvu_dl = rvu->rvu_dl;
-	return rvu_npa_health_reporters_create(rvu_dl);
+	err = rvu_npa_health_reporters_create(rvu_dl);
+	if (err)
+		return err;
+
+	return rvu_nix_health_reporters_create(rvu_dl);
 }
 
 static void rvu_health_reporters_destroy(struct rvu *rvu)
@@ -712,6 +1361,7 @@ static void rvu_health_reporters_destroy(struct rvu *rvu)
 
 	rvu_dl = rvu->rvu_dl;
 	rvu_npa_health_reporters_destroy(rvu_dl);
+	rvu_nix_health_reporters_destroy(rvu_dl);
 }
 
 static int rvu_devlink_info_get(struct devlink *devlink, struct devlink_info_req *req,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
index d7578fa92ac1..471e57dedb20 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.h
@@ -41,11 +41,38 @@ struct rvu_npa_health_reporters {
 	struct work_struct              ras_work;
 };
 
+enum nix_af_rvu_health {
+	NIX_AF_RVU_INTR,
+	NIX_AF_RVU_GEN,
+	NIX_AF_RVU_ERR,
+	NIX_AF_RVU_RAS,
+};
+
+struct rvu_nix_event_ctx {
+	u64 nix_af_rvu_int;
+	u64 nix_af_rvu_gen;
+	u64 nix_af_rvu_err;
+	u64 nix_af_rvu_ras;
+};
+
+struct rvu_nix_health_reporters {
+	struct rvu_nix_event_ctx *nix_event_ctx;
+	struct devlink_health_reporter *rvu_hw_nix_intr_reporter;
+	struct work_struct		intr_work;
+	struct devlink_health_reporter *rvu_hw_nix_gen_reporter;
+	struct work_struct		gen_work;
+	struct devlink_health_reporter *rvu_hw_nix_err_reporter;
+	struct work_struct		err_work;
+	struct devlink_health_reporter *rvu_hw_nix_ras_reporter;
+	struct work_struct		ras_work;
+};
+
 struct rvu_devlink {
 	struct devlink *dl;
 	struct rvu *rvu;
 	struct workqueue_struct *devlink_wq;
 	struct rvu_npa_health_reporters *rvu_npa_health_reporter;
+	struct rvu_nix_health_reporters *rvu_nix_health_reporter;
 };
 
 /* Devlink APIs */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index e2153d47c373..5e15f4fc11e3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -74,6 +74,16 @@ enum npa_af_int_vec_e {
 	NPA_AF_INT_VEC_CNT	= 0x5,
 };
 
+/* NIX Admin function Interrupt Vector Enumeration */
+enum nix_af_int_vec_e {
+	NIX_AF_INT_VEC_RVU	= 0x0,
+	NIX_AF_INT_VEC_GEN	= 0x1,
+	NIX_AF_INT_VEC_AQ_DONE	= 0x2,
+	NIX_AF_INT_VEC_AF_ERR	= 0x3,
+	NIX_AF_INT_VEC_POISON	= 0x4,
+	NIX_AF_INT_VEC_CNT	= 0x5,
+};
+
 /**
  * RVU PF Interrupt Vector Enumeration
  */
-- 
2.25.1


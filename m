Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A45811022DA
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbfKSLSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:18:16 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:34760 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSLSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:18:15 -0500
Received: by mail-pf1-f195.google.com with SMTP id n13so12031849pff.1
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 03:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=uNOJH+eEecxbLqy0SSHY3X6DMsajrYx/XCTbqETxmYg=;
        b=U0kJxDp41gnKpmvj8Ufu/PqHgOE7u+4cHalnBrg0accywkwbeYDrRxQDmZdMxpR0ZZ
         oiGEpBaoXOMswGk38r5AyPARu308jyaVOJlYhCFycpswa+0mvqlV3/bcreAIXe7XAj+K
         A16Q+Pwhp/HunCK1/se2aKo5c88MUet49Zu3iE7htbW88dBFGhrJV5IOA5fCJvm4Q3qA
         LbiRKtTI63cfaW0pP/fmH7ehu4D+/YxoswVlvJ5Ud+pktORsf/JzrTECKOvtxFrd09Ej
         IoRxy5xloy12+awDixuym6HpdRKLKc7rX3FQBYTm2XXAK92tzkr9Q1H0/80jzWUqyvWr
         jBNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=uNOJH+eEecxbLqy0SSHY3X6DMsajrYx/XCTbqETxmYg=;
        b=Uh9HqaHD6PQudd7jRexZLb2DAj7DRMo89r4/QZ+uNuURyerGE7ScjoCwZd05n3JX+g
         Nx1aMc3nM38/41fiM4jdxu2HeKlFjNs35+/0NaBKC+vy6bKQ6PwlQShc1zoOATzRo3ET
         G9VyHDsERvCmMRzzUXqNT9WLU5vx7yU0porwNdFtjWpE1tLXecgjvSbP++uQwvN6zr2r
         Hz3goLQgvd3k7X1vC4j1CFX2L2imvyLhzu6rHtZ6y/eeZTBHxwTEn/h11MLtUHQVqHHf
         GbtF+WWempilshmXz4/OB7IiBJHaOr0jMjuZOvDNah6sOebAUd5NEe5UgO5zCLX0ju6u
         akqg==
X-Gm-Message-State: APjAAAXijXbQc7SqkeEFnsWOkYk3lf0SutpIH6xhKiof9NJI+1/wtk/v
        phE92qhlH8WmOwt1aKVc8gOLOoHZhAw=
X-Google-Smtp-Source: APXvYqwUBATIBtppm+DsqbIiv4yy5Rw9T1LldwftI8exX2LnR9NFzoZfIRr2TBa/a3UZGFpl6gF3mw==
X-Received: by 2002:a63:c644:: with SMTP id x4mr5031625pgg.223.1574162294527;
        Tue, 19 Nov 2019 03:18:14 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id 6sm25918453pfy.43.2019.11.19.03.18.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Nov 2019 03:18:13 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Jerin Jacob <jerinj@marvell.com>,
        Pavan Nikhilesh <pbhagavatula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 07/15] octeontx2-af: add debug msgs for NIX block errors
Date:   Tue, 19 Nov 2019 16:47:31 +0530
Message-Id: <1574162259-28181-8-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerin Jacob <jerinj@marvell.com>

Added debug messages for NIX_AF_RVU_INT, NIX_AF_ERR_INT and NIX_AF_RAS
error AF interrupts.

These will help in detecting issues wrt AQ instruction faults,
LF misconfiguration, NPC MCAM entry trying to forward pkt to PF_FUNC
with no NIXLF mapped etc.

Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: Pavan Nikhilesh <pbhagavatula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   5 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 202 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |  10 +
 4 files changed, 219 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 37f673a..a7166c9 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2127,6 +2127,7 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 	int irq;
 
 	rvu_npa_unregister_interrupts(rvu);
+	rvu_nix_unregister_interrupts(rvu);
 
 	/* Disable the Mbox interrupt */
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFAF_MBOX_INT_ENA_W1C,
@@ -2340,6 +2341,10 @@ static int rvu_register_interrupts(struct rvu *rvu)
 	if (ret)
 		goto fail;
 
+	ret = rvu_nix_register_interrupts(rvu);
+	if (ret)
+		goto fail;
+
 	return 0;
 fail:
 	rvu_unregister_interrupts(rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index d1dffcd..b7cc667 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -465,6 +465,8 @@ void rvu_nix_freemem(struct rvu *rvu);
 int rvu_get_nixlf_count(struct rvu *rvu);
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int npalf);
 int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf);
+int rvu_nix_register_interrupts(struct rvu *rvu);
+void rvu_nix_unregister_interrupts(struct rvu *rvu);
 
 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 10b49e5..f1201e0 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3407,3 +3407,205 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,
 
 	return 0;
 }
+
+static irqreturn_t rvu_nix_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RVU_INT);
+
+	if (intr & BIT_ULL(0))
+		dev_err(rvu->dev, "NIX: Unmapped slot error\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_nix_af_err_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_ERR_INT);
+
+	if (intr & BIT_ULL(14))
+		dev_err(rvu->dev, "NIX: Memory fault on NIX_AQ_INST_S read\n");
+
+	if (intr & BIT_ULL(13))
+		dev_err(rvu->dev, "NIX: Memory fault on NIX_AQ_RES_S write\n");
+
+	if (intr & BIT_ULL(12))
+		dev_err(rvu->dev, "NIX: AQ doorbell error\n");
+
+	if (intr & BIT_ULL(6))
+		dev_err(rvu->dev, "NIX: Rx on unmapped PF_FUNC\n");
+
+	if (intr & BIT_ULL(5))
+		dev_err(rvu->dev, "NIX: Rx multicast replication error\n");
+
+	if (intr & BIT_ULL(4))
+		dev_err(rvu->dev, "NIX: Memory fault on NIX_RX_MCE_S read\n");
+
+	if (intr & BIT_ULL(3))
+		dev_err(rvu->dev, "NIX: Memory fault on multicast WQE read\n");
+
+	if (intr & BIT_ULL(2))
+		dev_err(rvu->dev, "NIX: Memory fault on mirror WQE read\n");
+
+	if (intr & BIT_ULL(1))
+		dev_err(rvu->dev, "NIX: Memory fault on mirror pkt write\n");
+
+	if (intr & BIT_ULL(0))
+		dev_err(rvu->dev, "NIX: Memory fault on multicast pkt write\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_nix_af_ras_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RAS);
+
+	if (intr & BIT_ULL(34))
+		dev_err(rvu->dev, "NIX: Poisoned data on NIX_AQ_INST_S read\n");
+
+	if (intr & BIT_ULL(33))
+		dev_err(rvu->dev, "NIX: Poisoned data on NIX_AQ_RES_S write\n");
+
+	if (intr & BIT_ULL(32))
+		dev_err(rvu->dev, "NIX: Poisoned data on HW context read\n");
+
+	if (intr & BIT_ULL(4))
+		dev_err(rvu->dev, "NIX: Poisoned data on packet read from mirror buffer\n");
+
+	if (intr & BIT_ULL(3))
+		dev_err(rvu->dev, "NIX: Poisoned data on packet read from multicast buffer\n");
+
+	if (intr & BIT_ULL(2))
+		dev_err(rvu->dev, "NIX: Poisoned data on WQE read from mirror buffer\n");
+
+	if (intr & BIT_ULL(1))
+		dev_err(rvu->dev, "NIX: Poisoned data on WQE read from multicast buffer\n");
+
+	if (intr & BIT_ULL(0))
+		dev_err(rvu->dev, "NIX: Poisoned data on NIX_RX_MCE_S read\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS, intr);
+	return IRQ_HANDLED;
+}
+
+static bool rvu_nix_af_request_irq(struct rvu *rvu, int blkaddr, int offset,
+				   const char *name, irq_handler_t fn)
+{
+	int rc;
+
+	WARN_ON(rvu->irq_allocated[offset]);
+	rvu->irq_allocated[offset] = false;
+	sprintf(&rvu->irq_name[offset * NAME_SIZE], name);
+	rc = request_irq(pci_irq_vector(rvu->pdev, offset), fn, 0,
+			 &rvu->irq_name[offset * NAME_SIZE], rvu);
+	if (rc)
+		dev_warn(rvu->dev, "Failed to register %s irq\n", name);
+	else
+		rvu->irq_allocated[offset] = true;
+
+	return rvu->irq_allocated[offset];
+}
+
+int rvu_nix_register_interrupts(struct rvu *rvu)
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
+			 "Failed to get NIX_AF_INT vector offsets\n");
+		return 0;
+	}
+
+	/* Register and enable NIX_AF_RVU_INT interrupt */
+	rc = rvu_nix_af_request_irq(rvu, blkaddr, base +  NIX_AF_INT_VEC_RVU,
+				    "NIX_AF_RVU_INT",
+				    rvu_nix_af_rvu_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_ERR_INT interrupt */
+	rc = rvu_nix_af_request_irq(rvu, blkaddr, base + NIX_AF_INT_VEC_AF_ERR,
+				    "NIX_AF_ERR_INT",
+				    rvu_nix_af_err_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NIX_AF_RAS interrupt */
+	rc = rvu_nix_af_request_irq(rvu, blkaddr, base + NIX_AF_INT_VEC_POISON,
+				    "NIX_AF_RAS",
+				    rvu_nix_af_ras_intr_handler);
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
+void rvu_nix_unregister_interrupts(struct rvu *rvu)
+{
+	int blkaddr, offs, i;
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
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1C, ~0ULL);
+
+	if (rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU]) {
+		free_irq(pci_irq_vector(rvu->pdev, offs + NIX_AF_INT_VEC_RVU),
+			 rvu);
+		rvu->irq_allocated[offs + NIX_AF_INT_VEC_RVU] = false;
+	}
+
+	for (i = NIX_AF_INT_VEC_AF_ERR; i < NIX_AF_INT_VEC_CNT; i++)
+		if (rvu->irq_allocated[offs + i]) {
+			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu);
+			rvu->irq_allocated[offs + i] = false;
+		}
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index bf5f03a..a665fa2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -70,6 +70,16 @@ enum npa_af_int_vec_e {
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
2.7.4


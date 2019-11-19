Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390181022D9
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 12:18:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727854AbfKSLSM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 06:18:12 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39784 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725904AbfKSLSL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 06:18:11 -0500
Received: by mail-pf1-f193.google.com with SMTP id x28so12025017pfo.6
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 03:18:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jQu7uq2FtMfTuXcaCpSZIhwePt/adX8x3B53AY2Ow/w=;
        b=ZvNResrU38dWPyxlJo2Ubwftojk975m+geDMhcHEdBKkj6eFK3kIsxnjzxjLvPZasP
         wJPVcDW3z0QpRX1Q4tNVN0HbxOt3U+sc/421Rn654ywsJoU3+VSEYC/0PES86XdQ5blO
         gCEd+v41+Nsgg/V1h45Bqdjt+jMou2da+M3uR1I0jkmYpAkn4t+cJTTOXwZzr9G2O2E/
         hsfInTQO/hoJk8Dz+rqncunfCboIit14HEeTJGlxDlkxoKwBgFpbju2gU5bWLjyY26Od
         c19h5oD+ifQ5muHbPE/LX2ACu4KEtv1TGz590QJ6c4nWg5I6bhqT4xO1pc0lnk64OUUP
         B2eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=jQu7uq2FtMfTuXcaCpSZIhwePt/adX8x3B53AY2Ow/w=;
        b=I+z0sgz3o5huEU/PlKtTS0gar/WzxDV/JzdjqwY2BAFvBnZ/q7Z/MhcyNIK9k3+EqM
         m2MOGm8N6/oLP9ZZSYgxxZ86TRWPN5CoFpeCmWA+RuCkZ67Hxyt5iTraUOPs5NVzUYKR
         mVRsuin45i2ChGTgzqMPIantCxP1A+UxgJlMlf56my5yGY9ntCxH5fsPCcg210F+jA/B
         9j7GcEaGam2TnQjr5WiVvcZDb/12ibAEOehY4T1utGc6ySlDI5XqSs5+LdSRNFnR0/Qt
         vh85OfCz7dBPg0Jjwz/Lu1xe6NhZCct5h22uOl+BhG0saLpztpZr9Ta20E/yBvsIYc5R
         CChg==
X-Gm-Message-State: APjAAAWvQeW6mYN8t+HM5soRM0A4owNgGJv8LFKaJ63fLiK/yX0MsQQ3
        T9jPFEcX4blW/w9YmQaHIWgumKlvQl4=
X-Google-Smtp-Source: APXvYqznjdsj0QpzGOVBR7wguqbBBma46zPtS5Ru4a8R8J2BEW6n/UcKYktNYx7DT3LszBFYt320xA==
X-Received: by 2002:a65:6253:: with SMTP id q19mr4955683pgv.226.1574162290561;
        Tue, 19 Nov 2019 03:18:10 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id 6sm25918453pfy.43.2019.11.19.03.18.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 19 Nov 2019 03:18:09 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Jerin Jacob <jerinj@marvell.com>,
        Pavan Nikhilesh <pbhagavatula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v2 06/15] octeontx2-af: add debug msgs for NPA block errors
Date:   Tue, 19 Nov 2019 16:47:30 +0530
Message-Id: <1574162259-28181-7-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574162259-28181-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerin Jacob <jerinj@marvell.com>

Added debug messages for NPA NPA_AF_RVU_INT, NPA_AF_GEN_INT, NPA_AF_ERR_INT
and NPA_AF_RAS error AF interrupts.

Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: Pavan Nikhilesh <pbhagavatula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   8 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_npa.c    | 230 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |  23 +++
 4 files changed, 262 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 35ad21d..37f673a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2126,6 +2126,8 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 {
 	int irq;
 
+	rvu_npa_unregister_interrupts(rvu);
+
 	/* Disable the Mbox interrupt */
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFAF_MBOX_INT_ENA_W1C,
 		    INTR_MASK(rvu->hw->total_pfs) & ~1ULL);
@@ -2333,8 +2335,12 @@ static int rvu_register_interrupts(struct rvu *rvu)
 		goto fail;
 	}
 	rvu->irq_allocated[offset] = true;
-	return 0;
 
+	ret = rvu_npa_register_interrupts(rvu);
+	if (ret)
+		goto fail;
+
+	return 0;
 fail:
 	rvu_unregister_interrupts(rvu);
 	return ret;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 48d3ffb..d1dffcd 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -453,6 +453,8 @@ void rvu_npa_freemem(struct rvu *rvu);
 void rvu_npa_lf_teardown(struct rvu *rvu, u16 pcifunc, int npalf);
 int rvu_npa_aq_enq_inst(struct rvu *rvu, struct npa_aq_enq_req *req,
 			struct npa_aq_enq_rsp *rsp);
+int rvu_npa_register_interrupts(struct rvu *rvu);
+void rvu_npa_unregister_interrupts(struct rvu *rvu);
 
 /* NIX APIs */
 bool is_nixlf_attached(struct rvu *rvu, u16 pcifunc);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
index 67471cb..2476d20 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npa.c
@@ -8,8 +8,10 @@
  * published by the Free Software Foundation.
  */
 
+#include <linux/bitfield.h>
 #include <linux/module.h>
 #include <linux/pci.h>
+#include <linux/stringify.h>
 
 #include "rvu_struct.h"
 #include "rvu_reg.h"
@@ -541,3 +543,231 @@ void rvu_npa_lf_teardown(struct rvu *rvu, u16 pcifunc, int npalf)
 
 	npa_ctx_free(rvu, pfvf);
 }
+
+static irqreturn_t rvu_npa_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_RVU_INT);
+
+	if (intr & BIT_ULL(0))
+		dev_err(rvu->dev, "NPA: Unmapped slot error\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static const char *rvu_npa_inpq_to_str(u16 in)
+{
+	switch (in) {
+	case 0:
+		return NULL;
+	case BIT(NPA_INPQ_NIX0_RX):
+		return __stringify(NPA_INPQ_NIX0_RX);
+	case BIT(NPA_INPQ_NIX0_TX):
+		return __stringify(NPA_INPQ_NIX0_TX);
+	case BIT(NPA_INPQ_NIX1_RX):
+		return __stringify(NPA_INPQ_NIX1_RX);
+	case BIT(NPA_INPQ_NIX1_TX):
+		return __stringify(NPA_INPQ_NIX1_TX);
+	case BIT(NPA_INPQ_SSO):
+		return __stringify(NPA_INPQ_SSO);
+	case BIT(NPA_INPQ_TIM):
+		return __stringify(NPA_INPQ_TIM);
+	case BIT(NPA_INPQ_DPI):
+		return __stringify(NPA_INPQ_DPI);
+	case BIT(NPA_INPQ_AURA_OP):
+		return __stringify(NPA_INPQ_AURA_OP);
+	case BIT(NPA_INPQ_INTERNAL_RSV):
+		return __stringify(NPA_INPQ_INTERNAL_RSV);
+	}
+
+	return "Reserved";
+}
+
+static irqreturn_t rvu_npa_af_gen_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	const char *err_msg;
+	int blkaddr, val;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_GEN_INT);
+
+	if (intr & BIT_ULL(32))
+		dev_err(rvu->dev, "NPA: Unmapped PF func error\n");
+
+	val = FIELD_GET(GENMASK(31, 16), intr);
+	err_msg = rvu_npa_inpq_to_str(val);
+	if (err_msg)
+		dev_err(rvu->dev, "NPA: Alloc disabled for %s\n", err_msg);
+
+	val = FIELD_GET(GENMASK(15, 0), intr);
+	err_msg = rvu_npa_inpq_to_str(val);
+	if (err_msg)
+		dev_err(rvu->dev, "NPA: Free disabled for %s\n", err_msg);
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_npa_af_err_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_ERR_INT);
+
+	if (intr & BIT_ULL(14))
+		dev_err(rvu->dev, "NPA: Memory fault on NPA_AQ_INST_S read\n");
+
+	if (intr & BIT_ULL(13))
+		dev_err(rvu->dev, "NPA: Memory fault on NPA_AQ_RES_S write\n");
+
+	if (intr & BIT_ULL(12))
+		dev_err(rvu->dev, "NPA: AQ doorbell error\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_npa_af_ras_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = (struct rvu *)rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NPA_AF_RAS);
+
+	if (intr & BIT_ULL(34))
+		dev_err(rvu->dev, "NPA: Poisoned data on NPA_AQ_INST_S read\n");
+
+	if (intr & BIT_ULL(33))
+		dev_err(rvu->dev, "NPA: Poisoned data on NPA_AQ_RES_S write\n");
+
+	if (intr & BIT_ULL(32))
+		dev_err(rvu->dev, "NPA: Poisoned data on HW context read\n");
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NPA_AF_RAS, intr);
+	return IRQ_HANDLED;
+}
+
+static bool rvu_npa_af_request_irq(struct rvu *rvu, int blkaddr, int offset,
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
+int rvu_npa_register_interrupts(struct rvu *rvu)
+{
+	int blkaddr, base;
+	bool rc;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	/* Get NPA AF MSIX vectors offset. */
+	base = rvu_read64(rvu, blkaddr, NPA_PRIV_AF_INT_CFG) & 0x3ff;
+	if (!base) {
+		dev_warn(rvu->dev,
+			 "Failed to get NPA_AF_INT vector offsets\n");
+		return 0;
+	}
+
+	/* Register and enable NPA_AF_RVU_INT interrupt */
+	rc = rvu_npa_af_request_irq(rvu, blkaddr, base +  NPA_AF_INT_VEC_RVU,
+				    "NPA_AF_RVU_INT",
+				    rvu_npa_af_rvu_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NPA_AF_GEN_INT interrupt */
+	rc = rvu_npa_af_request_irq(rvu, blkaddr, base + NPA_AF_INT_VEC_GEN,
+				    "NPA_AF_RVU_GEN",
+				    rvu_npa_af_gen_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NPA_AF_ERR_INT interrupt */
+	rc = rvu_npa_af_request_irq(rvu, blkaddr, base + NPA_AF_INT_VEC_AF_ERR,
+				    "NPA_AF_ERR_INT",
+				    rvu_npa_af_err_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT_ENA_W1S, ~0ULL);
+
+	/* Register and enable NPA_AF_RAS interrupt */
+	rc = rvu_npa_af_request_irq(rvu, blkaddr, base + NPA_AF_INT_VEC_POISON,
+				    "NPA_AF_RAS",
+				    rvu_npa_af_ras_intr_handler);
+	if (!rc)
+		goto err;
+	rvu_write64(rvu, blkaddr, NPA_AF_RAS_ENA_W1S, ~0ULL);
+
+	return 0;
+err:
+	rvu_npa_unregister_interrupts(rvu);
+	return rc;
+}
+
+void rvu_npa_unregister_interrupts(struct rvu *rvu)
+{
+	int i, offs, blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPA, 0);
+	if (blkaddr < 0)
+		return;
+
+	reg = rvu_read64(rvu, blkaddr, NPA_PRIV_AF_INT_CFG);
+	offs = reg & 0x3FF;
+
+	rvu_write64(rvu, blkaddr, NPA_AF_RVU_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NPA_AF_GEN_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NPA_AF_ERR_INT_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, NPA_AF_RAS_ENA_W1C, ~0ULL);
+
+	for (i = 0; i < NPA_AF_INT_VEC_CNT; i++)
+		if (rvu->irq_allocated[offs + i]) {
+			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu);
+			rvu->irq_allocated[offs + i] = false;
+		}
+}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index a3ecb5d..bf5f03a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -60,6 +60,16 @@ enum rvu_af_int_vec_e {
 	RVU_AF_INT_VEC_CNT    = 0x5,
 };
 
+/* NPA Admin function Interrupt Vector Enumeration */
+enum npa_af_int_vec_e {
+	NPA_AF_INT_VEC_RVU	= 0x0,
+	NPA_AF_INT_VEC_GEN	= 0x1,
+	NPA_AF_INT_VEC_AQ_DONE	= 0x2,
+	NPA_AF_INT_VEC_AF_ERR	= 0x3,
+	NPA_AF_INT_VEC_POISON	= 0x4,
+	NPA_AF_INT_VEC_CNT	= 0x5,
+};
+
 /**
  * RVU PF Interrupt Vector Enumeration
  */
@@ -100,6 +110,19 @@ enum npa_aq_instop {
 	NPA_AQ_INSTOP_UNLOCK = 0x5,
 };
 
+/* ALLOC/FREE input queues Enumeration from coprocessors */
+enum npa_inpq {
+	NPA_INPQ_NIX0_RX       = 0x0,
+	NPA_INPQ_NIX0_TX       = 0x1,
+	NPA_INPQ_NIX1_RX       = 0x2,
+	NPA_INPQ_NIX1_TX       = 0x3,
+	NPA_INPQ_SSO           = 0x4,
+	NPA_INPQ_TIM           = 0x5,
+	NPA_INPQ_DPI           = 0x6,
+	NPA_INPQ_AURA_OP       = 0xe,
+	NPA_INPQ_INTERNAL_RSV  = 0xf,
+};
+
 /* NPA admin queue instruction structure */
 struct npa_aq_inst_s {
 #if defined(__BIG_ENDIAN_BITFIELD)
-- 
2.7.4


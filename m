Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 67058FFAAE
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 17:15:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKQQPM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 11:15:12 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:39811 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfKQQPM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 11:15:12 -0500
Received: by mail-pj1-f67.google.com with SMTP id t103so770586pjb.6
        for <netdev@vger.kernel.org>; Sun, 17 Nov 2019 08:15:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=lkQaP/dr8TupjL3IS10etUzdnWc3snbWoQT5cBCbQLE=;
        b=IBk+iz5MWb9lTuu5qwbEHwrgl3lhQPF138u6irs5bP+A/EvZCpx+hkbGxPLNmFBYvr
         Cwx7RyGq+hVr079Cwus0chbyqFBs/spn9RMa6ecdvnXjwcE2Fj7vJG9QH+C97G8uW2t2
         BE2qx6nehxfWiHXDqYhu9fAsgJGd0uMXGMok2AwFcjdhDPL7k2uwFl8JtEpeCkX0t8Ap
         3boC0ze9PqQjl02ixq/a2dXz6kvNnjawtlYS+4q6eFAWPml5U2aT280eRCCUAGGsR7jN
         /piPYsbATgT2iWh30rcmCiB4qZ4gNcEKa3vHE2qUV/37Ft0dbbkLq3yfwh3aITms0l4T
         dJjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=lkQaP/dr8TupjL3IS10etUzdnWc3snbWoQT5cBCbQLE=;
        b=gq9dAr4yuDjV2Lw3RCyQ5AqL3FISdnIISheivKw3DmfUa2N7wztuyuJU0jL4Pzy09d
         2jyNCftCvdx8czBzxre5f+W80HiC9Ovz9ERwjpWS5HtFMiUkmmjRLVt++aCianvp3ebY
         1PFiFOrlLtHCyJ+Fgi/1jnf4/H29mIIc6aBS+AifgrXfgFx4EeKnE9H02oiAU9QKZKjO
         ac0/I8xkxXza/7ga2jzgMLzMEPwbeajB5wYspRSMcw3EHVcATYfCr75UYb3D0tzXhwHb
         h6AfNDbqkZ9BHYopIKqOv1VD0FeKZt8rHnQqiKt35r+PfPDhcnpeJXGL+wvoqH8bUjuv
         xgiw==
X-Gm-Message-State: APjAAAUWlnaIgIdIt7lC7ndmZQNlIOsQ2NOBcepSTK6UrRy27JofKWwH
        +TIV5QhqaO29Uv32IlHu+ruLkQ327zY=
X-Google-Smtp-Source: APXvYqyOY4/+Rd3I2eqBjIA4Ri2HR5bZy/B2yM96UcAbm8tS+DTc4sCcuNL5vMU0whf1LpfTALCasg==
X-Received: by 2002:a17:902:9b85:: with SMTP id y5mr3749650plp.334.1574007310831;
        Sun, 17 Nov 2019 08:15:10 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id v2sm2675231pgi.79.2019.11.17.08.15.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 17 Nov 2019 08:15:10 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Jerin Jacob <jerinj@marvell.com>,
        Pavan Nikhilesh <pbhagavatula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 06/15] octeontx2-af: add debug msgs for NPA block errors
Date:   Sun, 17 Nov 2019 21:44:17 +0530
Message-Id: <1574007266-17123-7-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574007266-17123-1-git-send-email-sunil.kovvuri@gmail.com>
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
index 0bf4096..a13a055 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2125,6 +2125,8 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 {
 	int irq;
 
+	rvu_npa_unregister_interrupts(rvu);
+
 	/* Disable the Mbox interrupt */
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFAF_MBOX_INT_ENA_W1C,
 		    INTR_MASK(rvu->hw->total_pfs) & ~1ULL);
@@ -2332,8 +2334,12 @@ static int rvu_register_interrupts(struct rvu *rvu)
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
index b7002f4..a6fe840 100644
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
index 627c649..2940b6d 100644
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


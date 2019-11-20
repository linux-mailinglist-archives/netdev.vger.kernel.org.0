Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 094FF10427B
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 18:49:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728352AbfKTRti (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 12:49:38 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:38113 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728342AbfKTRth (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 12:49:37 -0500
Received: by mail-pg1-f193.google.com with SMTP id 15so86413pgh.5
        for <netdev@vger.kernel.org>; Wed, 20 Nov 2019 09:49:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=oes3ExT1zK2uH1mDG/DWyYySa8RZ4DjsuU3+HNIeaoo=;
        b=gImA6NegRk3Soxbyr/YiVTbRnx+3wvoQ9q5cMMPGU6D9ipG66FC0GqXZjrBs10TjAg
         3laHi1weL8OjzG/dIISrmmF2WQqJEf8S41nnS3UYGUekPtnsIxAlYfrG7wWy1GShI0Un
         ba/e9TktdPJnNdUI25pLj67V4d9VyOtUAd/8lld6DyMJctfaAuyJdeJ8oPbDMTJqPq4N
         H69Tobap5R630PQTjB+mwiZF94j7rHooJNP81JJyVG4qBLvcpPp9kFNPhoxvUqfzO6Z8
         WlmxicSu7q0/C2KIhkVi2KfudDm2aSTktA+d5WcMdpRucugIklasbt8/y+y89AtuOTIC
         OrDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=oes3ExT1zK2uH1mDG/DWyYySa8RZ4DjsuU3+HNIeaoo=;
        b=TWtyGqYVx0oyyl8pL14GFN5HpEOY7MsmsIKzbvTlvfHUbiRwKH4yiMEjeMkNjJd9Do
         i45Wd9bwzb5yOwYScGoQDAmnf0+Z4FWBXt3kV5+HYL4G5No4zGbQm4TV0R5tkreo3aaj
         GHJksKl0E6ZQSft7hLD88W5tOFpub7gxkAUNNAbqeh23NGuayRh+Or1q1tzgo6SWbk+0
         Kh/7rT3jmnYFLFBmZgfp4q7r4Cb8aa4boZTPFVWaUaPpacA8nzmWysqNr7TI6upFSYCL
         NflhqeOWL/s8oSw+IHOTuqjbPTamqANhvHfzBomj8ncMvuwCmuYn4M6Cy5xYU1Rpw7qi
         nqFQ==
X-Gm-Message-State: APjAAAXClofdiy2I9FGAtIqJ40lw5G2SHnHJBw0E3Od3oIjjfqmKwpJC
        FUbE/rTshJYrG/b9g9EO5TX4xGbe
X-Google-Smtp-Source: APXvYqwTZWHgqp1o+0C9JGj1CTl6a+seA0eNg/cQbLkm2sMNFl+3qw9Lrt65Bhy2crPPkZrye0yksg==
X-Received: by 2002:a63:b20f:: with SMTP id x15mr4572255pge.65.1574272175966;
        Wed, 20 Nov 2019 09:49:35 -0800 (PST)
Received: from machine421.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id y24sm32230522pfr.116.2019.11.20.09.49.33
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 20 Nov 2019 09:49:35 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        Pavan Nikhilesh <pbhagavatula@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH v3 10/16] octeontx2-af: add debug msgs for SSO block errors
Date:   Wed, 20 Nov 2019 23:18:00 +0530
Message-Id: <1574272086-21055-11-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pavan Nikhilesh <pbhagavatula@marvell.com>

Added debug messages for SSO_AF_ERR0, SSO_AF_ERR2 and SSO_AF_RAS SSO AF
error interrupts.

Signed-off-by: Pavan Nikhilesh <pbhagavatula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c    |   5 +
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   2 +
 .../net/ethernet/marvell/octeontx2/af/rvu_sso.c    | 208 +++++++++++++++++++++
 .../net/ethernet/marvell/octeontx2/af/rvu_struct.h |   8 +
 4 files changed, 223 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index c1229e5..bbc0ab7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2152,6 +2152,7 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 
 	rvu_npa_unregister_interrupts(rvu);
 	rvu_nix_unregister_interrupts(rvu);
+	rvu_sso_unregister_interrupts(rvu);
 
 	/* Disable the Mbox interrupt */
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFAF_MBOX_INT_ENA_W1C,
@@ -2369,6 +2370,10 @@ static int rvu_register_interrupts(struct rvu *rvu)
 	if (ret)
 		goto fail;
 
+	ret = rvu_sso_register_interrupts(rvu);
+	if (ret)
+		goto fail;
+
 	return 0;
 fail:
 	rvu_unregister_interrupts(rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index df3cd2b..2216482 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -467,6 +467,8 @@ int rvu_cgx_nix_cuml_stats(struct rvu *rvu, void *cgxd, int lmac_id, int index,
 /* SSO APIs */
 int rvu_sso_init(struct rvu *rvu);
 void rvu_sso_freemem(struct rvu *rvu);
+int rvu_sso_register_interrupts(struct rvu *rvu);
+void rvu_sso_unregister_interrupts(struct rvu *rvu);
 int rvu_sso_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot_id);
 int rvu_ssow_lf_teardown(struct rvu *rvu, u16 pcifunc, int lf, int slot_id);
 void rvu_sso_hwgrp_config_thresh(struct rvu *rvu, int blkaddr, int lf);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
index 8e0d3df..832771a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_sso.c
@@ -33,6 +33,13 @@
 	} while (0)
 #endif
 
+#define SSO_AF_INT_DIGEST_PRNT(reg)					\
+	for (i = 0; i < block->lf.max / 64; i++) {			\
+		reg0 = rvu_read64(rvu, blkaddr, reg##X(i));		\
+		dev_err(rvu->dev, #reg "(%d) : 0x%llx", i, reg0);	\
+		rvu_write64(rvu, blkaddr, reg##X(i), reg0);		\
+	}
+
 void rvu_sso_hwgrp_config_thresh(struct rvu *rvu, int blkaddr, int lf)
 {
 	struct rvu_hwinfo *hw = rvu->hw;
@@ -808,6 +815,207 @@ int rvu_mbox_handler_ssow_lf_free(struct rvu *rvu,
 	return 0;
 }
 
+static int rvu_sso_do_register_interrupt(struct rvu *rvu, int irq_offs,
+					 irq_handler_t handler,
+					 const char *name)
+{
+	int ret = 0;
+
+	ret = request_irq(pci_irq_vector(rvu->pdev, irq_offs), handler, 0,
+			  name, rvu);
+	if (ret) {
+		dev_err(rvu->dev, "SSOAF: %s irq registration failed", name);
+		goto err;
+	}
+
+	WARN_ON(rvu->irq_allocated[irq_offs]);
+	rvu->irq_allocated[irq_offs] = true;
+err:
+	return ret;
+}
+
+static irqreturn_t rvu_sso_af_err0_intr_handler(int irq, void *ptr)
+{
+	struct rvu *rvu = (struct rvu *)ptr;
+	struct rvu_block *block;
+	int i, blkaddr;
+	u64 reg, reg0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	block = &rvu->hw->block[blkaddr];
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_ERR0);
+	dev_err(rvu->dev, "Received SSO_AF_ERR0 irq : 0x%llx", reg);
+
+	if (reg & BIT_ULL(15)) {
+		dev_err(rvu->dev, "Received Bad-fill-packet NCB error");
+		SSO_AF_INT_DIGEST_PRNT(SSO_AF_POISON)
+	}
+
+	if (reg & BIT_ULL(14)) {
+		dev_err(rvu->dev, "An FLR was initiated, but SSO_LF_GGRP_AQ_CNT[AQ_CNT] != 0");
+		SSO_AF_INT_DIGEST_PRNT(SSO_AF_FLR_AQ_DIGEST)
+	}
+
+	if (reg & BIT_ULL(13)) {
+		dev_err(rvu->dev, "Add work dropped due to XAQ pointers not yet initialized.");
+		SSO_AF_INT_DIGEST_PRNT(SSO_AF_XAQDIS_DIGEST)
+	}
+
+	if (reg & (0xF << 9)) {
+		dev_err(rvu->dev, "PF_FUNC mapping error.");
+		dev_err(rvu->dev, "SSO_AF_UNMAP_INFO : 0x%llx",
+			rvu_read64(rvu, blkaddr, SSO_AF_UNMAP_INFO));
+	}
+
+	if (reg & BIT_ULL(8)) {
+		dev_err(rvu->dev, "Add work dropped due to QTL being disabled, 0x0");
+		SSO_AF_INT_DIGEST_PRNT(SSO_AF_QCTLDIS_DIGEST)
+	}
+
+	if (reg & BIT_ULL(7)) {
+		dev_err(rvu->dev, "Add work dropped due to WQP being 0x0");
+		SSO_AF_INT_DIGEST_PRNT(SSO_AF_WQP0_DIGEST)
+	}
+
+	if (reg & BIT_ULL(6))
+		dev_err(rvu->dev, "Add work dropped due to 64 bit write");
+
+	if (reg & BIT_ULL(5))
+		dev_err(rvu->dev, "Set when received add work with tag type is specified as EMPTY");
+
+	if (reg & BIT_ULL(4)) {
+		dev_err(rvu->dev, "Add work to disabled hardware group. An ADDWQ was received and dropped to a hardware group with SSO_AF_HWGRP(0..255)_IAQ_THR[RSVD_THR] = 0.");
+		SSO_AF_INT_DIGEST_PRNT(SSO_AF_GRPDIS_DIGEST)
+	}
+
+	if (reg & BIT_ULL(3)) {
+		dev_err(rvu->dev, "Bad-fill-packet NCB error");
+		SSO_AF_INT_DIGEST_PRNT(SSO_AF_BFPN_DIGEST)
+	}
+
+	if (reg & BIT_ULL(2)) {
+		dev_err(rvu->dev, "Bad-fill-packet error.");
+		SSO_AF_INT_DIGEST_PRNT(SSO_AF_BFP_DIGEST)
+	}
+
+	if (reg & BIT_ULL(1)) {
+		dev_err(rvu->dev, "The NPA returned an error indication");
+		SSO_AF_INT_DIGEST_PRNT(SSO_AF_NPA_DIGEST)
+	}
+
+	rvu_write64(rvu, blkaddr, SSO_AF_ERR0, reg);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_sso_af_err2_intr_handler(int irq, void *ptr)
+{
+	struct rvu *rvu = (struct rvu *)ptr;
+	int blkaddr;
+	u64 reg;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_ERR2);
+	dev_err(rvu->dev, "received SSO_AF_ERR2 irq : 0x%llx", reg);
+	rvu_write64(rvu, blkaddr, SSO_AF_ERR2, reg);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_sso_af_ras_intr_handler(int irq, void *ptr)
+{
+	struct rvu *rvu = (struct rvu *)ptr;
+	struct rvu_block *block;
+	int i, blkaddr;
+	u64 reg, reg0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	block = &rvu->hw->block[blkaddr];
+
+	reg = rvu_read64(rvu, blkaddr, SSO_AF_RAS);
+	dev_err(rvu->dev, "received SSO_AF_RAS irq : 0x%llx", reg);
+	rvu_write64(rvu, blkaddr, SSO_AF_RAS, reg);
+	SSO_AF_INT_DIGEST_PRNT(SSO_AF_POISON)
+
+	return IRQ_HANDLED;
+}
+
+void rvu_sso_unregister_interrupts(struct rvu *rvu)
+{
+	int i, blkaddr, offs;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return;
+
+	offs = rvu_read64(rvu, blkaddr, SSO_PRIV_AF_INT_CFG) & 0x7FF;
+	if (!offs)
+		return;
+
+	rvu_write64(rvu, blkaddr, SSO_AF_RAS_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, SSO_AF_ERR2_ENA_W1C, ~0ULL);
+	rvu_write64(rvu, blkaddr, SSO_AF_ERR0_ENA_W1C, ~0ULL);
+
+	for (i = 0; i < SSO_AF_INT_VEC_CNT; i++)
+		if (rvu->irq_allocated[offs + i]) {
+			free_irq(pci_irq_vector(rvu->pdev, offs + i), rvu);
+			rvu->irq_allocated[offs + i] = false;
+		}
+}
+
+int rvu_sso_register_interrupts(struct rvu *rvu)
+{
+	int blkaddr, offs, ret = 0;
+
+	if (!is_block_implemented(rvu->hw, BLKADDR_SSO))
+		return 0;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_SSO, 0);
+	if (blkaddr < 0)
+		return blkaddr;
+
+	offs = rvu_read64(rvu, blkaddr, SSO_PRIV_AF_INT_CFG) & 0x7FF;
+	if (!offs) {
+		dev_warn(rvu->dev,
+			 "Failed to get SSO_AF_INT vector offsets\n");
+		return 0;
+	}
+
+	ret = rvu_sso_do_register_interrupt(rvu, offs + SSO_AF_INT_VEC_ERR0,
+					    rvu_sso_af_err0_intr_handler,
+					    "SSO_AF_ERR0");
+	if (ret)
+		goto err;
+	rvu_write64(rvu, blkaddr, SSO_AF_ERR0_ENA_W1S, ~0ULL);
+
+	ret = rvu_sso_do_register_interrupt(rvu, offs + SSO_AF_INT_VEC_ERR2,
+					    rvu_sso_af_err2_intr_handler,
+					    "SSO_AF_ERR2");
+	if (ret)
+		goto err;
+	rvu_write64(rvu, blkaddr, SSO_AF_ERR2_ENA_W1S, ~0ULL);
+
+	ret = rvu_sso_do_register_interrupt(rvu, offs + SSO_AF_INT_VEC_RAS,
+					    rvu_sso_af_ras_intr_handler,
+					    "SSO_AF_RAS");
+	if (ret)
+		goto err;
+	rvu_write64(rvu, blkaddr, SSO_AF_RAS_ENA_W1S, ~0ULL);
+
+	return 0;
+err:
+	rvu_sso_unregister_interrupts(rvu);
+	return ret;
+}
+
 int rvu_sso_init(struct rvu *rvu)
 {
 	u64 iaq_free_cnt, iaq_rsvd, iaq_max, iaq_rsvd_cnt = 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index a665fa2..3c60abe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -80,6 +80,14 @@ enum nix_af_int_vec_e {
 	NIX_AF_INT_VEC_CNT	= 0x5,
 };
 
+/* SSO Admin function Interrupt Vector Enumeration */
+enum sso_af_int_vec_e {
+	SSO_AF_INT_VEC_ERR0 = 0x0,
+	SSO_AF_INT_VEC_ERR2 = 0x1,
+	SSO_AF_INT_VEC_RAS  = 0x2,
+	SSO_AF_INT_VEC_CNT  = 0x3,
+};
+
 /**
  * RVU PF Interrupt Vector Enumeration
  */
-- 
2.7.4


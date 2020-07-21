Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1E5E2275CC
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 04:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbgGUCmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 22:42:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgGUCmB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 22:42:01 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65095C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 19:42:01 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id w17so9579052ply.11
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 19:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references;
        bh=JTL/7giMEL6EWId4qJAvNmPtljonoJ6k9AkEo7BNMjY=;
        b=pYwnr4q1YaIXYrjcs4liqlYEOGLVJhaUyViBwb4Odh8xncNbQSX8ivWPBc4q2g9nbX
         XmzfSkrMiUkbHJUaLlVmIm/v7i4Cooyv6wlUZTLSoNi4B5whJy24FDTtwhlxTw0kYbno
         6h7/vZ1LM3zBXSEZvQOxqepD1HQ+ISC//DKGLssOmgrLnsbCtL8uSu9x8ECMlu2GqhkI
         NeG8XtYQzfli8wIiHyozo2spzF7QXTbW5IlRMq/K0ISVooD4NJk3VxtP3bp0Fkidid3l
         uMkzU0eQ0dl/p3IcAhQBEcakm4ABR+tmQedNnDkTGKZUShm13s2fkTvVZjW/ZySDRxkj
         QASQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references;
        bh=JTL/7giMEL6EWId4qJAvNmPtljonoJ6k9AkEo7BNMjY=;
        b=U2bP5a6l+Wqlyq74YLSjnsc0wkH8WkcAF68xcehX1jSqz01dXqy6JH2xzzMZtttoFv
         c+/g4qKUsjkZcBtfH7QdSRC7JA1Xb0a8tqhQmlOLsGPsMHYvrxZutN3ZYayGbDmwqJfR
         rO7W3GpN0bQCdakDysRUwmqaTUWz5D/c+hTaZDyU40OQT5TOi+2YwGwZOh+1yerewHRN
         9rRzfuz0G9e1hFAduP+wt31BzH/0VC39bOrRf73qDlrzJrLz+CVpWsYSSfPdvSplh8KL
         mfTvdom9DSN3LhDl0mAuHHSah8lSFQK2YxX8PStc41HAQLfcLXSms0GM+nGzBFbs/KVD
         DKtQ==
X-Gm-Message-State: AOAM531cS7Cz2pWQx/p468UUOTlwEbsB/yq7qDYnbF2OiSiiJz9Z97I2
        xKIifPHVqzgVj35ybxqSwE4SguGfi3E=
X-Google-Smtp-Source: ABdhPJw2pA82RaGJYEHPo198pp0eh0HXaf61UExEtcBQ6moEGcVqKXD8aR45lMd842WiJwc/VLrpYA==
X-Received: by 2002:a17:90a:d48a:: with SMTP id s10mr2206723pju.116.1595299320975;
        Mon, 20 Jul 2020 19:42:00 -0700 (PDT)
Received: from hyd1soter3.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id i21sm18499114pfa.18.2020.07.20.19.41.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 19:42:00 -0700 (PDT)
From:   rakeshs.lkm@gmail.com
To:     sbhatta@marvell.com, sgoutham@marvell.com, jerinj@marvell.com,
        rsaladi2@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v2 2/2] octeontx2-af: add nix error af interrupt handlers
Date:   Tue, 21 Jul 2020 08:08:47 +0530
Message-Id: <20200721023847.2567-3-rakeshs.lkm@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721023847.2567-1-rakeshs.lkm@gmail.com>
References: <20200721023847.2567-1-rakeshs.lkm@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerin Jacob <jerinj@marvell.com>

Added debug messages for NIX_AF_RVU_INT, NIX_AF_ERR_INT and NIX_AF_RAS
error AF interrupts.

Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 148 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_struct.h         |  10 ++
 4 files changed, 165 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 6c4027f04cfc..9a36ce5fc57a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -2131,6 +2131,7 @@ static void rvu_unregister_interrupts(struct rvu *rvu)
 	int irq;

 	rvu_npa_unregister_interrupts(rvu);
+	rvu_nix_unregister_interrupts(rvu);

 	/* Disable the Mbox interrupt */
 	rvu_write64(rvu, BLKADDR_RVUM, RVU_AF_PFAF_MBOX_INT_ENA_W1C,
@@ -2344,6 +2345,10 @@ static int rvu_register_interrupts(struct rvu *rvu)
 	if (ret)
 		goto fail;

+	ret = rvu_nix_register_interrupts(rvu);
+	if (ret)
+		goto fail;
+
 	return 0;

 fail:
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 63c9f6049ad5..44d25a8f598d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -465,6 +465,8 @@ void rvu_nix_freemem(struct rvu *rvu);
 int rvu_get_nixlf_count(struct rvu *rvu);
 void rvu_nix_lf_teardown(struct rvu *rvu, u16 pcifunc, int blkaddr, int npalf);
 int nix_get_nixlf(struct rvu *rvu, u16 pcifunc, int *nixlf, int *nix_blkaddr);
+int rvu_nix_register_interrupts(struct rvu *rvu);
+void rvu_nix_unregister_interrupts(struct rvu *rvu);

 /* NPC APIs */
 int rvu_npc_init(struct rvu *rvu);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 36953d4f51c7..eba8dd730877 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3369,3 +3369,151 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,

 	return 0;
 }
+
+static irqreturn_t rvu_nix_af_rvu_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RVU_INT);
+	dev_err(rvu->dev, "NIX: RVU Interrupt  : 0x%llx\n", intr);
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_RVU_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_nix_af_err_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_ERR_INT);
+	dev_err(rvu->dev, "NIX: Error Interrupt : 0x%llx\n", intr);
+
+	/* Clear interrupts */
+	rvu_write64(rvu, blkaddr, NIX_AF_ERR_INT, intr);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t rvu_nix_af_ras_intr_handler(int irq, void *rvu_irq)
+{
+	struct rvu *rvu = rvu_irq;
+	int blkaddr;
+	u64 intr;
+
+	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NIX, 0);
+	if (blkaddr < 0)
+		return IRQ_NONE;
+
+	intr = rvu_read64(rvu, blkaddr, NIX_AF_RAS);
+	dev_err(rvu->dev, "NIX: RAS Interrupt : 0x%llx\n", intr);
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
index cc06a9242300..5d868eb80115 100644
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
2.17.1

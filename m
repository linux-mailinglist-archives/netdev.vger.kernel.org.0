Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAD521E86A
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 08:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726630AbgGNGk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 02:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgGNGk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 02:40:28 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6977AC061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 23:40:28 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mn17so1105414pjb.4
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 23:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=BnAHK0bP2N2xz5NBMgcIxYPxY9vMYYlQan1Kqz0oNAU=;
        b=ovL9TWIZWCignW8XpHQYgwRxtQvw0tx5OhZX8ZEK7QIl+Ra6U2pEXhcJhAfgyluWRJ
         R1r/CbeETYgUMttJWHEQM1462tFKAkN/YghIEZ1kZKyy1G/3bOWRpb29YiKr0eL7Yk3A
         /tejMatSex4ErnMhC2P6ChjXquf+Apn2zLyLe5EekzzQ84BNNHibM1+9dw6akknjEsan
         BOFsqJhOTsnTFhRYPfdy7iTWEd2yEGduvQAGUxXkQm8D1PKvBG0vbdfzk5VAZCg+8DhX
         emvEBMUQIu1COCr4r2uuARi0QnUPHcggc7oZvfEDsJeXJcDgDJ6pX1UiqfXX3/9+PCy6
         2yWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=BnAHK0bP2N2xz5NBMgcIxYPxY9vMYYlQan1Kqz0oNAU=;
        b=QenTL7wRCm18ACAhtVYwu3uRndM+QCTmtPauxxocQyievI+a3BusL8Mu7V+2Rl2URr
         Fl95GrsmTIGOU39kz6HjmNxY8AeUtgCYvAD/c/GHdfIZCupVAFbTGCE44x+GgXTsWL/l
         WpZsw9SvQDpCq4UwLz8ygYcNERsMoIwB50RMnF/6e1LvcUhKVSGVdGyRZ78EhSNSbujE
         CZGwViACwKnypSdkLqbBDqfG5xDycK9rHCfUe03aZA767Rwm5aE+Ox0w4wl+HaexPQvN
         neE/dQjUbthWOuZPEFS/ASfgvTZ0203wMMbb1mkD2EppPCZe7wdQet2suvJgvTmJ3Hzn
         7iqA==
X-Gm-Message-State: AOAM531+k9IGt6cE/vPnoX09axSq26Mtfn/WUwFyreeS0x5hUbA7Vaci
        m5x3toaIBqA3h3+CfwXftfg=
X-Google-Smtp-Source: ABdhPJwNfzS1kd0Vp1g9oAdwf4PpyT4K34tL5/kDAINRTL+F8VHfy5yDexCZUCHDh7UIRKjyNtZrkQ==
X-Received: by 2002:a17:90a:a106:: with SMTP id s6mr3059417pjp.53.1594708827976;
        Mon, 13 Jul 2020 23:40:27 -0700 (PDT)
Received: from hyd1soter3.caveonetworks.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id f29sm14620209pga.59.2020.07.13.23.40.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 23:40:27 -0700 (PDT)
From:   rakeshs.lkm@gmail.com
To:     sbhatta@marvell.com, sgoutham@marvell.com, jerinj@marvell.com,
        rsaladi2@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org
Cc:     Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Subject: [net-next PATCH 2/2] octeontx2-af: add nix error af interrupt handlers
Date:   Tue, 14 Jul 2020 12:08:25 +0530
Message-Id: <20200714063825.24369-3-rakeshs.lkm@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200714063825.24369-1-rakeshs.lkm@gmail.com>
References: <20200714063825.24369-1-rakeshs.lkm@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jerin Jacob <jerinj@marvell.com>

Added debug messages for NIX_AF_RVU_INT, NIX_AF_ERR_INT and NIX_AF_RAS
error AF interrupts.

Signed-off-by: Jerin Jacob <jerinj@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <Sunil.Goutham@cavium.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/rvu.c   |   5 +
 .../net/ethernet/marvell/octeontx2/af/rvu.h   |   2 +
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 202 ++++++++++++++++++
 .../marvell/octeontx2/af/rvu_struct.h         |  10 +
 4 files changed, 219 insertions(+)

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
index 36953d4f51c7..99bf7003bd2d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3369,3 +3369,205 @@ int rvu_mbox_handler_nix_lso_format_cfg(struct rvu *rvu,

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
index bf5f03aeb5f0..a665fa242926 100644
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

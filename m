Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E51817545D
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 08:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgCBHUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 02:20:18 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36581 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726282AbgCBHUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 02:20:18 -0500
Received: by mail-pf1-f195.google.com with SMTP id i13so5139329pfe.3
        for <netdev@vger.kernel.org>; Sun, 01 Mar 2020 23:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2uzR3oZahrcDQwuXAKKJQPB5rR+AljjEOBcvXNKMtRk=;
        b=miZ4C/x4EgfqKpyGy9deBiLTROVuLszihwZ8cpdoX/b2p6UDOmM/QVjgWv+utot/8f
         EU7gMIg5ES6tVJuqk8JS9h+pT3r4yXFKEyFBd2XhZ+sS2TNnX15c1rrxaX442w7uNGzY
         RHYQfTI6yE4V6jQzGoiK8bAAwO65XX2suuuMku//cshxkFJNBFMasCwV4aC7BezPQH/+
         Dh+xqBVeoA9c4vtpHl3JxBBduqSgFD1aMR/al9WofRSp7NKllY2fCV17PZR+H5Byghee
         XaiTuiwVI47QDIdDsmJ3ViHU0dKJIJkpNOx+8D/WR4OrWi7fzhHXyQVBBtr03L55LEZK
         vJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2uzR3oZahrcDQwuXAKKJQPB5rR+AljjEOBcvXNKMtRk=;
        b=jeZyvgRi29Mg1UfSMh/9DgL3ea1x3oZaP43CGy4NB22OzLved29nhPilhW+GfJqFRO
         SwUbffLyvImZuCOgFrp1VPLPNTR3EISi4Y/4r+EKyGifKUG9nIFKsU18ImZTG/NfS2/e
         uk5z1qhPRLaR+ZRmXy4U50vdaPhnlamxaahmH18Bdcl+/Y4kGfCd1CXBjFXjMHurMzSp
         XMAaqNHABaPUKmmIVhMdqQuQcjcc8s3Xw7wUI2wzrsisXkTB4+dKIGRNzcSqw/QtJUYs
         fUp1OXduq7XJWts3x8cPR6L2/LtGkCDv2lxzHao8GFtSRcaHdwX+Gaona5S1IH7NGroY
         z+xA==
X-Gm-Message-State: ANhLgQ1zlZtDaF/E2iQCygQdPU/PgVPMO5JQek/C1223vRrCtkYaBJWq
        6BkYg9fHxCApLAEl6IK8ZKf0r3QW81I=
X-Google-Smtp-Source: ADFU+vuwZnEehsMuMoRnxWpHmDRXdTLkqEtGlWy4Vw9p5P/SYKe4TjSkUlt7vUse6tFzbQGeCSVGCA==
X-Received: by 2002:aa7:9a1b:: with SMTP id w27mr9274585pfj.248.1583133617716;
        Sun, 01 Mar 2020 23:20:17 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id j4sm19835042pfh.152.2020.03.01.23.20.15
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 01 Mar 2020 23:20:17 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 5/7] octeontx2-af: Set discovery ID for RVUM block
Date:   Mon,  2 Mar 2020 12:49:26 +0530
Message-Id: <1583133568-5674-6-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1583133568-5674-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Currently there is no way for AF dependent drivers in
any domain to check if the AF driver is loaded. This
patch sets an ID for RVUM block which will automatically
reflects in PF/VFs discovery register which they can
check and defer their probe until AF is up.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu.c        | 18 +++++++++++++++++-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h |  3 +++
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index e56b1f8..e851477 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -421,6 +421,19 @@ static void rvu_check_block_implemented(struct rvu *rvu)
 	}
 }
 
+static void rvu_setup_rvum_blk_revid(struct rvu *rvu)
+{
+	rvu_write64(rvu, BLKADDR_RVUM,
+		    RVU_PRIV_BLOCK_TYPEX_REV(BLKTYPE_RVUM),
+		    RVU_BLK_RVUM_REVID);
+}
+
+static void rvu_clear_rvum_blk_revid(struct rvu *rvu)
+{
+	rvu_write64(rvu, BLKADDR_RVUM,
+		    RVU_PRIV_BLOCK_TYPEX_REV(BLKTYPE_RVUM), 0x00);
+}
+
 int rvu_lf_reset(struct rvu *rvu, struct rvu_block *block, int lf)
 {
 	int err;
@@ -2591,6 +2604,8 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_flr;
 
+	rvu_setup_rvum_blk_revid(rvu);
+
 	/* Enable AF's VFs (if any) */
 	err = rvu_enable_sriov(rvu);
 	if (err)
@@ -2611,6 +2626,7 @@ static int rvu_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	rvu_fwdata_exit(rvu);
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
+	rvu_clear_rvum_blk_revid(rvu);
 err_release_regions:
 	pci_release_regions(pdev);
 err_disable_device:
@@ -2635,7 +2651,7 @@ static void rvu_remove(struct pci_dev *pdev)
 	rvu_disable_sriov(rvu);
 	rvu_reset_all_blocks(rvu);
 	rvu_free_hw_resources(rvu);
-
+	rvu_clear_rvum_blk_revid(rvu);
 	pci_release_regions(pdev);
 	pci_disable_device(pdev);
 	pci_set_drvdata(pdev, NULL);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index 9d8942a..a3ecb5d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -11,6 +11,9 @@
 #ifndef RVU_STRUCT_H
 #define RVU_STRUCT_H
 
+/* RVU Block revision IDs */
+#define RVU_BLK_RVUM_REVID		0x01
+
 /* RVU Block Address Enumeration */
 enum rvu_block_addr_e {
 	BLKADDR_RVUM		= 0x0ULL,
-- 
2.7.4


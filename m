Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5226628CB9B
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 12:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731116AbgJMK11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 06:27:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731041AbgJMK1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 06:27:18 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CDFC0613D2
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:27:17 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ds1so1882112pjb.5
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 03:27:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hwlp2aUmr6TNN5TAYGfNLUVYLrXZCDFF7QupBJSaA4I=;
        b=LSTwnmf82vURiCc94NQvm1rBUs1I4RktXmcH5QBZo+1rb4TRzz+d+OZHePzOreVcnA
         GW7BjYbQJgsbPA6fenKCSAkTrg6dh4xH9k/VT8nojm5YsbTkXT0wu5gn5aATV0wUAv+b
         vnrmIiqB/aPX8QDyVSHYhy0Vy7OR3/Qk8aYu2pLk36XSc2GuH72KT4jDxyLLV6bpCAGS
         E3/lMMziGD9be2ybfuP9LcN36FyGWV0fRqXEJLbGYqcOfgotNfd6Iv9fzHHB9YabASEC
         1pJ6jaRs7UGhHlunZ1oYPW/TvQ5FX2nN66psj30uVby8ugYP8jS0ANYfOkzupKVDkNNo
         M3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hwlp2aUmr6TNN5TAYGfNLUVYLrXZCDFF7QupBJSaA4I=;
        b=AtdenVkmj86Ml4eyyYKyhtIm9zZhLR3zdjhcJy8MbUPC3ZC7LVpAi/YIK4gFkqs7H8
         EsGIzfdHysB+d5a7KYa04P294M4Jr/EjeARfwrZxY/+WC0kg8sAlW7XXOB0602WWVyjG
         XMpTmO4A2rBcZWDDRAz/rCbYAFXxqgZGSfNiPo8kX4Xhxd5C4qG3lpFBal401fRGz2Hd
         2Ktpmp1FC2XyDRxnK81GLsg+lEoGaxN1kD/Nd3iVQ7sUvascLhkwF9b4Kp+qe2t82lsh
         gyohajh95Mno8a0yqzB2fANEisjxC69be7sWZnWhAnXSUszYRAHXfh8XDhGkzd7v4sez
         /knA==
X-Gm-Message-State: AOAM5305GQ4FEkg2njD3xthteyJ6rcanzVCz/HDJUVltYKc411GKlonv
        hSjA40q9rVB6KiTosU1FXNg=
X-Google-Smtp-Source: ABdhPJyBWiIiAN3vSFTjwkmq68ludd+Z5jq6yxrlIqUXso3y3MW18yii1wmAnY9N+xRENgUqAJvysA==
X-Received: by 2002:a17:90a:668e:: with SMTP id m14mr24560335pjj.61.1602584836767;
        Tue, 13 Oct 2020 03:27:16 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id g4sm22034444pgj.15.2020.10.13.03.27.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 03:27:16 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     rsaladi2@marvell.com, sgoutham@marvell.com,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net-next PATCH 10/10] octeontx2-af: Display CGX, NIX and PF map in debugfs.
Date:   Tue, 13 Oct 2020 15:56:32 +0530
Message-Id: <1602584792-22274-11-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
References: <1602584792-22274-1-git-send-email-sundeep.lkml@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rakesh Babu <rsaladi2@marvell.com>

Unlike earlier silicon variants, OcteonTx2 98xx
silicon has 2 NIX blocks and each of the CGX is
mapped to either of the NIX blocks. Each NIX
block supports 100G. Mapping btw NIX blocks and
CGX is done by firmware based on CGX speed config
to have a maximum possible network bandwidth.
Since the mapping is not fixed, it's difficult
for a user to figure out. Hence added a debugfs
entry which displays mapping between CGX LMAC,
NIX block and RVU PF.
Sample result of this entry ::

~# cat /sys/kernel/debug/octeontx2/rvu_pf_cgx_map
PCI dev         RVU PF Func     NIX block       CGX     LMAC
0002:02:00.0    0x400           NIX0            CGX0    LMAC0

Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
---
 .../ethernet/marvell/octeontx2/af/rvu_debugfs.c    | 47 ++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index b1b54cb..b7b6b6f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -224,6 +224,48 @@ static ssize_t rvu_dbg_rsrc_attach_status(struct file *filp,
 
 RVU_DEBUG_FOPS(rsrc_status, rsrc_attach_status, NULL);
 
+static int rvu_dbg_rvu_pf_cgx_map_display(struct seq_file *filp, void *unused)
+{
+	struct rvu *rvu = filp->private;
+	struct pci_dev *pdev = NULL;
+	char cgx[10], lmac[10];
+	struct rvu_pfvf *pfvf;
+	int pf, domain, blkid;
+	u8 cgx_id, lmac_id;
+	u16 pcifunc;
+
+	domain = 2;
+	seq_puts(filp, "PCI dev\t\tRVU PF Func\tNIX block\tCGX\tLMAC\n");
+	for (pf = 0; pf < rvu->hw->total_pfs; pf++) {
+		if (!is_pf_cgxmapped(rvu, pf))
+			continue;
+
+		pdev =  pci_get_domain_bus_and_slot(domain, pf + 1, 0);
+		if (!pdev)
+			continue;
+
+		cgx[0] = 0;
+		lmac[0] = 0;
+		pcifunc = pf << 10;
+		pfvf = rvu_get_pfvf(rvu, pcifunc);
+
+		if (pfvf->nix_blkaddr == BLKADDR_NIX0)
+			blkid = 0;
+		else
+			blkid = 1;
+
+		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id,
+				    &lmac_id);
+		sprintf(cgx, "CGX%d", cgx_id);
+		sprintf(lmac, "LMAC%d", lmac_id);
+		seq_printf(filp, "%s\t0x%x\t\tNIX%d\t\t%s\t%s\n",
+			   dev_name(&pdev->dev), pcifunc, blkid, cgx, lmac);
+	}
+	return 0;
+}
+
+RVU_DEBUG_SEQ_FOPS(rvu_pf_cgx_map, rvu_pf_cgx_map_display, NULL);
+
 static bool rvu_dbg_is_valid_lf(struct rvu *rvu, int blkaddr, int lf,
 				u16 *pcifunc)
 {
@@ -1769,6 +1811,11 @@ void rvu_dbg_init(struct rvu *rvu)
 	if (!pfile)
 		goto create_failed;
 
+	pfile = debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_dbg.root,
+				    rvu, &rvu_dbg_rvu_pf_cgx_map_fops);
+	if (!pfile)
+		goto create_failed;
+
 	rvu_dbg_npa_init(rvu);
 	rvu_dbg_nix_init(rvu, BLKADDR_NIX0);
 
-- 
2.7.4


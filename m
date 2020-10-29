Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B432829E42D
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:36:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729206AbgJ2Hfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgJ2HY4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 03:24:56 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2682C0610CF
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w21so1374492pfc.7
        for <netdev@vger.kernel.org>; Wed, 28 Oct 2020 22:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Hwlp2aUmr6TNN5TAYGfNLUVYLrXZCDFF7QupBJSaA4I=;
        b=Y9fkLSInRzVqiMtwDRH4OhM+ZhVeLJumgtrYTyETCd5rHVt1K1g1zJewGP2GBZBBnL
         +f37sSjRbnwAxjwMElkO92faeMEcjFe6sacEIMnJOazHTfRzTSX8nRIgSEenqItY9RY3
         fFmKHeztRkAdBRgiX/QeGDoJ/Gr30aCPhho+NvckNzKO30fOO90tI+J33EulNg3B+wxK
         8kKX77ZDvKLrGhTwZRev/RcmCClsTpDy8uKiY9E/lIDjv1nMOWmwGbtMTASCDdkojXwV
         es21wtz9XJukynDJ1nTdEP5mZUMIAgil1w4txjI/5oLzFC3AcCT4GJ33LgytGzwLjMWl
         XLrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Hwlp2aUmr6TNN5TAYGfNLUVYLrXZCDFF7QupBJSaA4I=;
        b=p8VydXb8mFl431hWYEyymARyboJyG7Q0TSgKBX4mB0wqma60/kV9IFehPf27IbX36v
         5yzfL6n8O2HbGudOZPsjyQf89RuqIEm7fy4ccIje71ff8Ag/6i3zR/lIrDZPCm8pEpGF
         xQtpjDLrjhPjkA03rW/5hsOUt3sirBl9pPTDJP2y9iMk0DQTdl7SSd+zAEY2OKjtgQf7
         0G560feS9+JF+RBLDW3eY1vLfq4nCWy704MfP58S6TvG5/Cj0AfqO4CA0ceOcaPnQvpC
         P9WlCQNynnWrkT9Uy4yNiUEodArw2pu62I5xU7E/2DKhuv/D5ewQC9dtLIMyZTCMVI+e
         ipCQ==
X-Gm-Message-State: AOAM53159k+gpe/dXZqd1YHip3n37MqDWJic7riPKdW4Q0LbBLp9iVcN
        1H7jindOdF5czSeyypA/oME=
X-Google-Smtp-Source: ABdhPJyIiyvvqTQWGfHQ/pHO6WAP8KUzL3gge60eyYP84iOL/g5oRGX2YbjWm6rBDMBD8m1totHVzA==
X-Received: by 2002:a17:90a:7bc9:: with SMTP id d9mr2537226pjl.74.1603948591215;
        Wed, 28 Oct 2020 22:16:31 -0700 (PDT)
Received: from hyd1358.caveonetworks.com ([1.6.215.26])
        by smtp.googlemail.com with ESMTPSA id k7sm1292242pfa.184.2020.10.28.22.16.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Oct 2020 22:16:30 -0700 (PDT)
From:   sundeep.lkml@gmail.com
To:     davem@davemloft.net, kuba@kernel.org, sgoutham@marvell.com,
        netdev@vger.kernel.org
Cc:     Rakesh Babu <rsaladi2@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [v2 net-next PATCH 10/10] octeontx2-af: Display CGX, NIX and PF map in debugfs.
Date:   Thu, 29 Oct 2020 10:45:49 +0530
Message-Id: <1603948549-781-11-git-send-email-sundeep.lkml@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
References: <1603948549-781-1-git-send-email-sundeep.lkml@gmail.com>
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


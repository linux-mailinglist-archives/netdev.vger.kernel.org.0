Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53DB943CFCB
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237542AbhJ0Rfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:35:53 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5446 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229612AbhJ0Rfw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:35:52 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RFW64B032300;
        Wed, 27 Oct 2021 10:33:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Fq7rkFnyF49XDIrXhiWhXP6g7fddIB/mpQ9VvtCOYz0=;
 b=JhubMZJfcB6droJIZYTuZAewdpdl2U3FJmIxiMueGWWFWgl8Or5nfb5pf/5ndod5nays
 VTzVtckEYVoNPceKgoX2hPkpnbHeVIRhEBPmjkCA8wQWP2CZhgdosioN09Ax5OAJsfTm
 t+ZtBgnduhvBil2BELc9Iuq9Vb59TSdirBgh7cN6RDZKnKkI6flKLeqg9utxcwTBLdSJ
 rYU24B03NCsC8wwutBTRYbgSPnkQzts6Kkzk8KX2ymnFSh0qp+SFOelVQOeqUax5TmRK
 v24SBLFXRKugC9Tq8G8KCETv40Ah05zWsqoXPpg/bH/YPZB7zNOVE6YwqCB17wonnlMr Zw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3by1caaptu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:33:24 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 10:33:22 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 10:33:22 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 9EE963F709D;
        Wed, 27 Oct 2021 10:33:16 -0700 (PDT)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Rakesh Babu <rsaladi2@marvell.com>
Subject: [net PATCH v3 1/3] octeontx2-af: Check whether ipolicers exists
Date:   Wed, 27 Oct 2021 23:02:32 +0530
Message-ID: <20211027173234.23559-2-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211027173234.23559-1-rsaladi2@marvell.com>
References: <20211027173234.23559-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: T2JFx6orsHzy2FGd-mWjokpuF3H0AoY7
X-Proofpoint-ORIG-GUID: T2JFx6orsHzy2FGd-mWjokpuF3H0AoY7
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_05,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

While displaying ingress policers information in
debugfs check whether ingress policers exist in
the hardware or not because some platforms(CN9XXX)
do not have this feature.

Fixes: e7d8971763f3 ("octeontx2-af: cn10k: Debugfs support for bandwidth")
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Rakesh Babu <rsaladi2@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 9338765da048..6c589ca9b577 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -1719,6 +1719,10 @@ static int rvu_dbg_nix_band_prof_ctx_display(struct seq_file *m, void *unused)
 	u16 pcifunc;
 	char *str;
 
+	/* Ingress policers do not exist on all platforms */
+	if (!nix_hw->ipolicer)
+		return 0;
+
 	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
 		if (layer == BAND_PROF_INVAL_LAYER)
 			continue;
@@ -1768,6 +1772,10 @@ static int rvu_dbg_nix_band_prof_rsrc_display(struct seq_file *m, void *unused)
 	int layer;
 	char *str;
 
+	/* Ingress policers do not exist on all platforms */
+	if (!nix_hw->ipolicer)
+		return 0;
+
 	seq_puts(m, "\nBandwidth profile resource free count\n");
 	seq_puts(m, "=====================================\n");
 	for (layer = 0; layer < BAND_PROF_NUM_LAYERS; layer++) {
-- 
2.17.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0917C439EDC
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 21:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233793AbhJYTDr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 15:03:47 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:64666 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S233742AbhJYTDq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 15:03:46 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19PIMU7j001231;
        Mon, 25 Oct 2021 12:01:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=Fq7rkFnyF49XDIrXhiWhXP6g7fddIB/mpQ9VvtCOYz0=;
 b=Xbgr3SeUNQ+VJ8DC+X5TWn8JOo2iE7aPSPygS95vrfMfkOVhM0k7HhjssPi3usRTxWmP
 od3gfFZk/X7TOuurRLJs5vT1Psk0qCNYZc8FaRfcusGeOSzce34KmOwH5dKaLGz2j1WP
 xX679fSb3XSox0DeB9Wr+vjplV8yAHOVxUsjeYLdbisydG1piuo1BrS02eXYBDIEkhE+
 i16V3BPo2/GILGBdRUNUdnRLgcAdzN6lYliFMG8E774yZkvRJBPY+M/26D3MvKMSwIcK
 Nl0VM7O1AP4XIMg13HPjDDUGqszHGyEhxzxJSgoW/Eof6kXV/ddH+Irz8oOhNG5rAx88 pQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3bwtjrj6y7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 25 Oct 2021 12:01:23 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Mon, 25 Oct
 2021 12:01:21 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Mon, 25 Oct 2021 12:01:21 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 38A4C3F70B1;
        Mon, 25 Oct 2021 12:01:18 -0700 (PDT)
From:   Rakesh Babu <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>
CC:     Rakesh Babu <rsaladi2@marvell.com>
Subject: [net PATCH 1/2] octeontx2-af: Check whether ipolicers exists
Date:   Tue, 26 Oct 2021 00:30:44 +0530
Message-ID: <20211025190045.7462-2-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211025190045.7462-1-rsaladi2@marvell.com>
References: <20211025190045.7462-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: 4RUEs4YLZDwGWxhzZk9WYaNi5Ri4I4Rv
X-Proofpoint-GUID: 4RUEs4YLZDwGWxhzZk9WYaNi5Ri4I4Rv
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-25_06,2021-10-25_02,2020-04-07_01
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

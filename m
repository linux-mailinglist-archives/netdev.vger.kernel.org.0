Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A00DC43CFD0
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 19:33:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243308AbhJ0RgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 13:36:12 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:54126 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243307AbhJ0RgL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 13:36:11 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19RFo9Xx011395;
        Wed, 27 Oct 2021 10:33:45 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=L+NlKhelSvgM9MtD5+jKKXS80K0DFKDQ+yOpHQYMv3w=;
 b=eRnPz1c1fYh35uwnSGq3w30mueypok3Rf5y6pg0cUNCOVLJ9M/xvWKwR7bo2cGC6qrqR
 +tAcBfsDXEnG0DQ+9BkDR85H7GqpHbypYTCeqh+vhg/zUnRUkvvb5U2LpNvPTsvdJoUZ
 /AAk7XCoRFJOzTXCgZAllR0uSbQJRp2SPrKpsE/Kv+1sq01Y+lX6UBsCYteHTar0IbmX
 7RLxGWWUTtVhYjYT0zA/0awvnJibzrR7JL5QB/rX0IF3qQB7fAQIuvCtWWY+1IMfyU0p
 TGvGjw0o//14UXrc9GCHObecShmVPM0NYpCNTaukGtRfigWkmVdHxrs0kmTt9Bf/5QQy Dw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3by9rtrfmp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Oct 2021 10:33:44 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 27 Oct
 2021 10:33:43 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 27 Oct 2021 10:33:43 -0700
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 39CA33F709D;
        Wed, 27 Oct 2021 10:33:37 -0700 (PDT)
From:   Rakesh Babu Saladi <rsaladi2@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Rakesh Babu Saladi <rsaladi2@marvell.com>
Subject: [net PATCH v3 3/3] octeontx2-af: Fix possible null pointer dereference.
Date:   Wed, 27 Oct 2021 23:02:34 +0530
Message-ID: <20211027173234.23559-4-rsaladi2@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20211027173234.23559-1-rsaladi2@marvell.com>
References: <20211027173234.23559-1-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: DDBBY3navrn6Zsz_sjhrZpoNeHl5u3G4
X-Proofpoint-GUID: DDBBY3navrn6Zsz_sjhrZpoNeHl5u3G4
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-27_05,2021-10-26_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes possible null pointer dereference in files
"rvu_debugfs.c" and "rvu_nix.c"

Fixes: 8756828a8148 ("octeontx2-af: Add NPA aura and pool contexts to debugfs")
Fixes: 9a946def264d ("octeontx2-af: Modify nix_vtag_cfg mailbox to support TX VTAG entries")
Signed-off-by: Rakesh Babu Saladi <rsaladi2@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c | 2 +-
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c     | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index c7e12464c243..49d822a98ada 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -578,7 +578,7 @@ static ssize_t rvu_dbg_qsize_write(struct file *filp,
 	if (cmd_buf)
 		ret = -EINVAL;
 
-	if (!strncmp(subtoken, "help", 4) || ret < 0) {
+	if (ret < 0 || !strncmp(subtoken, "help", 4)) {
 		dev_info(rvu->dev, "Use echo <%s-lf > qsize\n", blk_string);
 		goto qsize_write_done;
 	}
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 9ef4e942e31e..6970540dc470 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2507,6 +2507,9 @@ static void nix_free_tx_vtag_entries(struct rvu *rvu, u16 pcifunc)
 		return;
 
 	nix_hw = get_nix_hw(rvu->hw, blkaddr);
+	if (!nix_hw)
+		return;
+
 	vlan = &nix_hw->txvlan;
 
 	mutex_lock(&vlan->rsrc_lock);
-- 
2.17.1


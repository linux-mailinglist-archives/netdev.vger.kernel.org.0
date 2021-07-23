Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1303D3620
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234315AbhGWHZy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 03:25:54 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:44960 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234263AbhGWHZy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 03:25:54 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16N7jGoE010875;
        Fri, 23 Jul 2021 01:06:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=P60HCWtWNShwbF/tw9DwBABZlf8um6tIckjuaefb1vw=;
 b=SGmFg1dpgCmqHqkvAfbZblr+s//of6PmJs4jXL/IQZfgSpKsJdWH0naj4J2dQc/72VUO
 TJxdw4JbpgI0wjL6OCbYH73/QX764nVciVR8OLQYBOCG1rUDdGP824RyL/syB+ovBHi3
 r0wNF1A1UMIuPZ63fUWhoy+7cLz6SGl8AO2TfBGHChtrOT/ppycWsVUFyulfBNb7MLMy
 OTVO+QrJ0OObdKHv8WKJQDhmnwfxBaEynP37S/7BaPhxJ55CX3iyga2DlReIoO5gzNSf
 4/GsEm1zcVwtfxbXnKWfHk4sclElZPOwhr9pMEHmf2ZoPT8CWts2p78gG9+AvFnww3QG ag== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 39y972bwug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 23 Jul 2021 01:06:25 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 23 Jul
 2021 01:06:23 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 23 Jul 2021 01:06:23 -0700
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id 699653F708A;
        Fri, 23 Jul 2021 01:06:21 -0700 (PDT)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <hkelam@marvell.com>, <gakula@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH v2] octeontx2-af: Fix uninitialized variables in rvu_switch
Date:   Fri, 23 Jul 2021 13:36:18 +0530
Message-ID: <1627027578-24848-1-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 8jDX2x3ecYzmWgIsuY4oPS9DeVgImf2B
X-Proofpoint-ORIG-GUID: 8jDX2x3ecYzmWgIsuY4oPS9DeVgImf2B
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.790
 definitions=2021-07-23_03:2021-07-23,2021-07-23 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Get the number of VFs of a PF correctly by calling
rvu_get_pf_numvfs in rvu_switch_disable function.
Also hwvf is not required hence remove it.

Fixes: 23109f8dd06d ("octeontx2-af: Introduce internal packet switching")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---

v2:
 Added Reported-by: tags in commit message


 drivers/net/ethernet/marvell/octeontx2/af/rvu.c        |  6 ++++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c | 11 ++++++-----
 2 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
index 017163f..5fe277e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.c
@@ -391,8 +391,10 @@ void rvu_get_pf_numvfs(struct rvu *rvu, int pf, int *numvfs, int *hwvf)
 
 	/* Get numVFs attached to this PF and first HWVF */
 	cfg = rvu_read64(rvu, BLKADDR_RVUM, RVU_PRIV_PFX_CFG(pf));
-	*numvfs = (cfg >> 12) & 0xFF;
-	*hwvf = cfg & 0xFFF;
+	if (numvfs)
+		*numvfs = (cfg >> 12) & 0xFF;
+	if (hwvf)
+		*hwvf = cfg & 0xFFF;
 }
 
 static int rvu_get_hwvf(struct rvu *rvu, int pcifunc)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
index 2e53797..820adf3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_switch.c
@@ -71,8 +71,8 @@ static int rvu_switch_install_rules(struct rvu *rvu)
 	struct rvu_switch *rswitch = &rvu->rswitch;
 	u16 start = rswitch->start_entry;
 	struct rvu_hwinfo *hw = rvu->hw;
-	int pf, vf, numvfs, hwvf;
 	u16 pcifunc, entry = 0;
+	int pf, vf, numvfs;
 	int err;
 
 	for (pf = 1; pf < hw->total_pfs; pf++) {
@@ -110,8 +110,8 @@ static int rvu_switch_install_rules(struct rvu *rvu)
 
 		rswitch->entry2pcifunc[entry++] = pcifunc;
 
-		rvu_get_pf_numvfs(rvu, pf, &numvfs, &hwvf);
-		for (vf = 0; vf < numvfs; vf++, hwvf++) {
+		rvu_get_pf_numvfs(rvu, pf, &numvfs, NULL);
+		for (vf = 0; vf < numvfs; vf++) {
 			pcifunc = pf << 10 | ((vf + 1) & 0x3FF);
 			rvu_get_nix_blkaddr(rvu, pcifunc);
 
@@ -198,7 +198,7 @@ void rvu_switch_disable(struct rvu *rvu)
 	struct npc_mcam_free_entry_req free_req = { 0 };
 	struct rvu_switch *rswitch = &rvu->rswitch;
 	struct rvu_hwinfo *hw = rvu->hw;
-	int pf, vf, numvfs, hwvf;
+	int pf, vf, numvfs;
 	struct msg_rsp rsp;
 	u16 pcifunc;
 	int err;
@@ -217,7 +217,8 @@ void rvu_switch_disable(struct rvu *rvu)
 				"Reverting RX rule for PF%d failed(%d)\n",
 				pf, err);
 
-		for (vf = 0; vf < numvfs; vf++, hwvf++) {
+		rvu_get_pf_numvfs(rvu, pf, &numvfs, NULL);
+		for (vf = 0; vf < numvfs; vf++) {
 			pcifunc = pf << 10 | ((vf + 1) & 0x3FF);
 			err = rvu_switch_install_rx_rule(rvu, pcifunc, 0xFFF);
 			if (err)
-- 
2.7.4


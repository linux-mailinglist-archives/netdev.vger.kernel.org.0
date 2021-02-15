Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DADC31C10C
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 18:56:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbhBORzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 12:55:05 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:60202 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229604AbhBORy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 12:54:58 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11FHk2ak023127;
        Mon, 15 Feb 2021 09:54:16 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=Yx/+lX5qolgCsudpAc5IFXP2Ew66SHSIG3lA0SX1djk=;
 b=HwUuJ8mAeSHgFC1vZHjcgqsw6pbIAT+Xrkn+se/jDHjlAWOA49E1p3c19KORGlfL8bcN
 826ziIPmJhaHEySY5ygyjagQUG5tjnUXVrFk4wZnS+o8k3DMH7BKCs1ky5iD5DbqMmRA
 M1tzHv1WaIkGFa4IVn1pBldJ6cKW0qHhonl0s2rLf34WbQkZgaN8K/XIMMZBwIv8boQS
 LKkqapeBvPbWcVs7YBduba0bbv1AukAp84OefThsakAXzfp2ofcKw2SoLI7X+d4mwfM7
 ZMsVXLfktCQtbq+12MZfMpVYZwjX+A3jYplk+6n08YySH+KCUgVruf2gEdrfBGkEHlzX IA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36pd0vmys2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 15 Feb 2021 09:54:16 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 15 Feb
 2021 09:54:15 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Mon, 15 Feb 2021 09:54:15 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 8A3A73F7040;
        Mon, 15 Feb 2021 09:54:12 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <jerinj@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next PATCH] octeontx2-af: cn10k: Fixes CN10K RPM reference issue
Date:   Mon, 15 Feb 2021 23:24:00 +0530
Message-ID: <20210215175400.13126-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-15_14:2021-02-12,2021-02-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes references to uninitialized variables and
debugfs entry name for CN10K platform and HW_TSO flag check. 

Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

This patch fixes the bug introduced by the commit
3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support".
These changes are not yet merged into net branch, hence submitting
to net-next.

---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c   |  2 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c    | 11 ++++++-----
 3 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 3a1809c28e83..e668e482383a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -722,12 +722,14 @@ u32 rvu_cgx_get_fifolen(struct rvu *rvu)
 
 static int rvu_cgx_config_intlbk(struct rvu *rvu, u16 pcifunc, bool en)
 {
+	int pf = rvu_get_pf(pcifunc);
 	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
 
 	if (!is_cgx_config_permitted(rvu, pcifunc))
 		return -EPERM;
 
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
 	mac_ops = get_mac_ops(rvu_cgx_pdata(cgx_id, rvu));
 
 	return mac_ops->mac_lmac_intl_lbk(rvu_cgx_pdata(cgx_id, rvu),
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
index 48a84c65804c..094124b695dc 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_debugfs.c
@@ -2432,7 +2432,7 @@ void rvu_dbg_init(struct rvu *rvu)
 		debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_dbg.root,
 				    rvu, &rvu_dbg_rvu_pf_cgx_map_fops);
 	else
-		debugfs_create_file("rvu_pf_cgx_map", 0444, rvu->rvu_dbg.root,
+		debugfs_create_file("rvu_pf_rpm_map", 0444, rvu->rvu_dbg.root,
 				    rvu, &rvu_dbg_rvu_pf_cgx_map_fops);
 
 create:
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
index 3f778fc054b5..22ec03a618b1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -816,22 +816,23 @@ static bool is_hw_tso_supported(struct otx2_nic *pfvf,
 {
 	int payload_len, last_seg_size;
 
+	if (test_bit(HW_TSO, &pfvf->hw.cap_flag))
+		return true;
+
+	/* On 96xx A0, HW TSO not supported */
+	if (!is_96xx_B0(pfvf->pdev))
+		return false;
 
 	/* HW has an issue due to which when the payload of the last LSO
 	 * segment is shorter than 16 bytes, some header fields may not
 	 * be correctly modified, hence don't offload such TSO segments.
 	 */
-	if (!is_96xx_B0(pfvf->pdev))
-		return true;
 
 	payload_len = skb->len - (skb_transport_offset(skb) + tcp_hdrlen(skb));
 	last_seg_size = payload_len % skb_shinfo(skb)->gso_size;
 	if (last_seg_size && last_seg_size < 16)
 		return false;
 
-	if (!test_bit(HW_TSO, &pfvf->hw.cap_flag))
-		return false;
-
 	return true;
 }
 
-- 
2.17.1


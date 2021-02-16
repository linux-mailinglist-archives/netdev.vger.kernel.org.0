Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16BFD31CA05
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 12:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbhBPLnd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 06:43:33 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:16608 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230333AbhBPLkf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 06:40:35 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GBVQf7007994;
        Tue, 16 Feb 2021 03:39:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-type; s=pfpt0220;
 bh=mwQPIoyeymJ4KhwI06kM5MhpkEAfjMT02S2UniYtLmk=;
 b=SBaRQQgm6BMauPGA4DAaqRW8PqbZNkEvvK+AN4C/RJy8hE+oXbUo2a29ptV0yeDoOpoC
 VDRFU8MJ16PsJ/TDCvdjkaQVo33dpLNUGhSuoDndAkubMazSu+jXtJIHawEkE4wVpGhY
 HKmMRN8dITojRBgYOMGdirONondhN6eHLLjQWd8vTVX3RXDFz/slgt689UWzaLXXV7Sv
 M/LkHfTDqe3IAEp0hKVOXJzJfWvHz5AviFn3rzfD7vF1CApFMyj5zLw0aTGhxpBt6mx8
 Z8Nj0eDKVt1Eq695RVLw9L+ORmKzj7MHylynu2HpTQbqUcJTuLM3Xgk3g4w/88E+YCrz mg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36pd0vq81p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 03:39:52 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 03:39:51 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 16 Feb
 2021 03:39:51 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 16 Feb 2021 03:39:51 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 3BA403F703F;
        Tue, 16 Feb 2021 03:39:47 -0800 (PST)
From:   Geetha sowjanya <gakula@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <jerinj@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>
Subject: [net-next v2] octeontx2-af: cn10k: Fixes CN10K RPM reference issue
Date:   Tue, 16 Feb 2021 17:09:36 +0530
Message-ID: <20210216113936.26580-1-gakula@marvell.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_01:2021-02-16,2021-02-15 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch fixes references to uninitialized variables and
debugfs entry name for CN10K platform and HW_TSO flag check.

Fixes: 3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support").
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

v1-v2
- Clear HW_TSO flag for 96xx B0 version.

This patch fixes the bug introduced by the commit
3ad3f8f93c81 ("octeontx2-af: cn10k: MAC internal loopback support").
These changes are not yet merged into net branch, hence submitting
to net-next.

---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c   |  2 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_debugfs.c   |  2 +-
 .../net/ethernet/marvell/octeontx2/nic/otx2_common.h  |  3 +++
 .../net/ethernet/marvell/octeontx2/nic/otx2_txrx.c    | 11 ++++++-----
 4 files changed, 12 insertions(+), 6 deletions(-)

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
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
index 4c472646a0ac..f14d388efb51 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_common.h
@@ -407,6 +407,9 @@ static inline void otx2_setup_dev_hw_settings(struct otx2_nic *pfvf)
 		pfvf->hw.rq_skid = 600;
 		pfvf->qset.rqe_cnt = Q_COUNT(Q_SIZE_1K);
 	}
+	if (is_96xx_B0(pfvf->pdev))
+		__clear_bit(HW_TSO, &hw->cap_flag);
+
 	if (!is_dev_otx2(pfvf->pdev)) {
 		__set_bit(CN10K_MBOX, &hw->cap_flag);
 		__set_bit(CN10K_LMTST, &hw->cap_flag);
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


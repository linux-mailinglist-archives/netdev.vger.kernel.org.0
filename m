Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83B064959FB
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378715AbiAUGfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:35:12 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:16956 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233954AbiAUGfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 01:35:12 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20L05jDq029262;
        Thu, 20 Jan 2022 22:35:08 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=G2o8szT6YNFPo3bEfLB50Z4NHtrvx5+Jd0GIL5gP77U=;
 b=UffB71YGjaoRrfCqto+LpiXrx7uVJnP4s5X3hhJw2ndC2VT2HTmAeiQzh1emN/NsbKl+
 J4T9y81OGwCYhJnGAOmbM+eS/HAgAnfM9S6E2GaMPdtbx1jYOYyj14rZFq3q8P/s1q5A
 U8YDkV2p68rPNwCJS3OJ0+oBDQ78fu3hMZEjF4aBwpu4NsTwQ1EqRz8c2nngAc5LiFUU
 dtKJcQAy0sPWSJR9kFRGHzNUZZ75UAy58C0EUqfULEwe/G39+gPmIk6h1ugZXK7WMgDF
 wSwibanwODV8BgCAlulKHGUHdxEWJwf98ovnCnL5ixPilaUg+0w3JVdnK9P3W0PpuW1O EA== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3dqj05gxwp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 20 Jan 2022 22:35:08 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Thu, 20 Jan
 2022 22:35:06 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 20 Jan 2022 22:35:06 -0800
Received: from hyd1358.marvell.com (unknown [10.29.37.11])
        by maili.marvell.com (Postfix) with ESMTP id E17123F7097;
        Thu, 20 Jan 2022 22:35:03 -0800 (PST)
From:   Subbaraya Sundeep <sbhatta@marvell.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <sundeep.lkml@gmail.com>
CC:     <hkelam@marvell.com>, <gakula@marvell.com>, <sgoutham@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>
Subject: [net PATCH 4/9] octeontx2-af: cn10k: Use appropriate register for LMAC enable
Date:   Fri, 21 Jan 2022 12:04:42 +0530
Message-ID: <1642746887-30924-5-git-send-email-sbhatta@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
References: <1642746887-30924-1-git-send-email-sbhatta@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-GUID: 0XR9F5Y-m7TAG2L87cZ9XSa_BHd40JsJ
X-Proofpoint-ORIG-GUID: 0XR9F5Y-m7TAG2L87cZ9XSa_BHd40JsJ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-21_02,2022-01-20_01,2021-12-02_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Geetha sowjanya <gakula@marvell.com>

CN10K platforms uses RPM(0..2)_MTI_MAC100(0..3)_COMMAND_CONFIG
register for lmac TX/RX enable whereas CN9xxx platforms use
CGX_CMRX_CONFIG register. This config change was missed when
adding support for CN10K RPM.

Fixes: 91c6945ea1f9 ("octeontx2-af: cn10k: Add RPM MAC support")
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    |  2 ++
 .../ethernet/marvell/octeontx2/af/lmac_common.h    |  3 ++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.c    | 39 ++++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rpm.h    |  4 +++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 14 ++++++--
 .../net/ethernet/marvell/octeontx2/af/rvu_nix.c    | 10 +++---
 7 files changed, 66 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 186d00a9..3631d61 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -1570,6 +1570,8 @@ static struct mac_ops	cgx_mac_ops    = {
 	.mac_enadis_pause_frm =		cgx_lmac_enadis_pause_frm,
 	.mac_pause_frm_config =		cgx_lmac_pause_frm_config,
 	.mac_enadis_ptp_config =	cgx_lmac_ptp_config,
+	.mac_rx_tx_enable =		cgx_lmac_rx_tx_enable,
+	.mac_tx_enable =		cgx_lmac_tx_enable,
 };
 
 static int cgx_probe(struct pci_dev *pdev, const struct pci_device_id *id)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
index fc6e742..b33e7d1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/lmac_common.h
@@ -107,6 +107,9 @@ struct mac_ops {
 	void			(*mac_enadis_ptp_config)(void  *cgxd,
 							 int lmac_id,
 							 bool enable);
+
+	int			(*mac_rx_tx_enable)(void *cgxd, int lmac_id, bool enable);
+	int			(*mac_tx_enable)(void *cgxd, int lmac_id, bool enable);
 };
 
 struct cgx {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index e695fa0..4cbd915 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -30,6 +30,8 @@ static struct mac_ops	rpm_mac_ops   = {
 	.mac_enadis_pause_frm =		rpm_lmac_enadis_pause_frm,
 	.mac_pause_frm_config =		rpm_lmac_pause_frm_config,
 	.mac_enadis_ptp_config =	rpm_lmac_ptp_config,
+	.mac_rx_tx_enable =		rpm_lmac_rx_tx_enable,
+	.mac_tx_enable =		rpm_lmac_tx_enable,
 };
 
 struct mac_ops *rpm_get_mac_ops(void)
@@ -54,6 +56,43 @@ int rpm_get_nr_lmacs(void *rpmd)
 	return hweight8(rpm_read(rpm, 0, CGXX_CMRX_RX_LMACS) & 0xFULL);
 }
 
+int rpm_lmac_tx_enable(void *rpmd, int lmac_id, bool enable)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg, last;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	last = cfg;
+	if (enable)
+		cfg |= RPM_TX_EN;
+	else
+		cfg &= ~(RPM_TX_EN);
+
+	if (cfg != last)
+		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	return !!(last & RPM_TX_EN);
+}
+
+int rpm_lmac_rx_tx_enable(void *rpmd, int lmac_id, bool enable)
+{
+	rpm_t *rpm = rpmd;
+	u64 cfg;
+
+	if (!is_lmac_valid(rpm, lmac_id))
+		return -ENODEV;
+
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	if (enable)
+		cfg |= RPM_RX_EN | RPM_TX_EN;
+	else
+		cfg &= ~(RPM_RX_EN | RPM_TX_EN);
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	return 0;
+}
+
 void rpm_lmac_enadis_rx_pause_fwding(void *rpmd, int lmac_id, bool enable)
 {
 	rpm_t *rpm = rpmd;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
index 57c8a68..ff58031 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.h
@@ -43,6 +43,8 @@
 #define RPMX_MTI_STAT_DATA_HI_CDC            0x10038
 
 #define RPM_LMAC_FWI			0xa
+#define RPM_TX_EN			BIT_ULL(0)
+#define RPM_RX_EN			BIT_ULL(1)
 
 /* Function Declarations */
 int rpm_get_nr_lmacs(void *rpmd);
@@ -57,4 +59,6 @@ int rpm_lmac_enadis_pause_frm(void *rpmd, int lmac_id, u8 tx_pause,
 int rpm_get_tx_stats(void *rpmd, int lmac_id, int idx, u64 *tx_stat);
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat);
 void rpm_lmac_ptp_config(void *rpmd, int lmac_id, bool enable);
+int rpm_lmac_rx_tx_enable(void *rpmd, int lmac_id, bool enable);
+int rpm_lmac_tx_enable(void *rpmd, int lmac_id, bool enable);
 #endif /* RPM_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index 66e45d7..5ed94cf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -806,6 +806,7 @@ bool is_mac_feature_supported(struct rvu *rvu, int pf, int feature);
 u32  rvu_cgx_get_fifolen(struct rvu *rvu);
 void *rvu_first_cgx_pdata(struct rvu *rvu);
 int cgxlmac_to_pf(struct rvu *rvu, int cgx_id, int lmac_id);
+int rvu_cgx_config_tx(void *cgxd, int lmac_id, bool enable);
 
 int npc_get_nixlf_mcam_index(struct npc_mcam *mcam, u16 pcifunc, int nixlf,
 			     int type);
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 2ca182a..8a7ac5a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -441,16 +441,26 @@ void rvu_cgx_enadis_rx_bp(struct rvu *rvu, int pf, bool enable)
 int rvu_cgx_config_rxtx(struct rvu *rvu, u16 pcifunc, bool start)
 {
 	int pf = rvu_get_pf(pcifunc);
+	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
+	void *cgxd;
 
 	if (!is_cgx_config_permitted(rvu, pcifunc))
 		return LMAC_AF_ERR_PERM_DENIED;
 
 	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	cgxd = rvu_cgx_pdata(cgx_id, rvu);
+	mac_ops = get_mac_ops(cgxd);
+
+	return mac_ops->mac_rx_tx_enable(cgxd, lmac_id, start);
+}
 
-	cgx_lmac_rx_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, start);
+int rvu_cgx_config_tx(void *cgxd, int lmac_id, bool enable)
+{
+	struct mac_ops *mac_ops;
 
-	return 0;
+	mac_ops = get_mac_ops(cgxd);
+	return mac_ops->mac_tx_enable(cgxd, lmac_id, enable);
 }
 
 void rvu_cgx_disable_dmac_entries(struct rvu *rvu, u16 pcifunc)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index b74ab0d..de6e5a1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -2068,8 +2068,8 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	/* enable cgx tx if disabled */
 	if (is_pf_cgxmapped(rvu, pf)) {
 		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-		restore_tx_en = !cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu),
-						    lmac_id, true);
+		restore_tx_en = !rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu),
+						   lmac_id, true);
 	}
 
 	cfg = rvu_read64(rvu, blkaddr, NIX_AF_SMQX_CFG(smq));
@@ -2092,7 +2092,7 @@ static int nix_smq_flush(struct rvu *rvu, int blkaddr,
 	rvu_cgx_enadis_rx_bp(rvu, pf, true);
 	/* restore cgx tx state */
 	if (restore_tx_en)
-		cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
+		rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
 	return err;
 }
 
@@ -3878,7 +3878,7 @@ nix_config_link_credits(struct rvu *rvu, int blkaddr, int link,
 	/* Enable cgx tx if disabled for credits to be back */
 	if (is_pf_cgxmapped(rvu, pf)) {
 		rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
-		restore_tx_en = !cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu),
+		restore_tx_en = !rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu),
 						    lmac_id, true);
 	}
 
@@ -3918,7 +3918,7 @@ nix_config_link_credits(struct rvu *rvu, int blkaddr, int link,
 
 	/* Restore state of cgx tx */
 	if (restore_tx_en)
-		cgx_lmac_tx_enable(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
+		rvu_cgx_config_tx(rvu_cgx_pdata(cgx_id, rvu), lmac_id, false);
 
 	mutex_unlock(&rvu->rsrc_lock);
 	return rc;
-- 
2.7.4


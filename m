Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEE754AD6C3
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 12:29:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238301AbiBHL3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 06:29:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349455AbiBHKvA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 05:51:00 -0500
X-Greylist: delayed 3344 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 02:50:57 PST
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3BAC03FEC0;
        Tue,  8 Feb 2022 02:50:57 -0800 (PST)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 2187sJBI000850;
        Tue, 8 Feb 2022 01:55:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=HmDmdaqFc6mlTNUc6VCJQyDSkG97ZNkiLElcbfGwqAk=;
 b=eDyU2vLiTM7XXbJXbRyBD5O1qWYRnFe4LNgXmQUygzAGZ8RsNLZJlaqYOGtrzC/yrbb8
 dUOj7Gkp2gr1CSkKttB0CohruVHeYPb2wBTYV16zhw4Hk8FwILrQB94AFzFqsuVuSXXb
 X1WEUBuMm+Fq+a/rrSxy0tmRuPfFXyToKDCbePXO0r6DqsRaObMeJMyFZepqgGdNEoCt
 bBjjnyt9N4NPXXz5koR9+28AEVljbFge/LNx1r7RLIuec5ENVfaUZqgO7rhetpHCh8KA
 1rUeV41NM4Fsi/MtllWY+kKppcg4pH4RAN4K3sSGFnmGvt8FfJ1prlyBD/xfXofmH6Uc Kw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3e3mhsgecj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 08 Feb 2022 01:55:05 -0800
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 8 Feb
 2022 01:55:04 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 8 Feb 2022 01:55:04 -0800
Received: from hyd1soter3.marvell.com (unknown [10.29.37.12])
        by maili.marvell.com (Postfix) with ESMTP id 6790F3F7095;
        Tue,  8 Feb 2022 01:55:01 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <sgoutham@marvell.com>,
        <lcherian@marvell.com>, <gakula@marvell.com>, <jerinj@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>
Subject: [net-next PATCH 1/4] octeontx2-af: Don't enable Pause frames by default
Date:   Tue, 8 Feb 2022 15:24:53 +0530
Message-ID: <20220208095456.6122-2-hkelam@marvell.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20220208095456.6122-1-hkelam@marvell.com>
References: <20220208095456.6122-1-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: NhRb48mfvg2dtnJoguAMUZXaqINnOXEQ
X-Proofpoint-GUID: NhRb48mfvg2dtnJoguAMUZXaqINnOXEQ
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-02-08_02,2022-02-07_02,2021-12-02_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Current implementation is such that 802.3x pause frames are
enabled by default.  As CGX and RPM blocks support PFC
(priority flow control) also, instead of driver enabling one
between them enable them upon request from PF or its VFs.
Also add support to disable pause frames in driver unbind.

Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Signed-off-by: Sunil Kovvuri Goutham <sgoutham@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/cgx.c   | 41 ++++++----------
 .../net/ethernet/marvell/octeontx2/af/rpm.c   | 47 +++++--------------
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   |  8 ----
 .../ethernet/marvell/octeontx2/nic/otx2_pf.c  | 15 +++---
 .../ethernet/marvell/octeontx2/nic/otx2_vf.c  | 12 +++--
 5 files changed, 43 insertions(+), 80 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 3631d612aaca..fb7069c757f5 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -782,21 +782,8 @@ static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 
 	if (!is_lmac_valid(cgx, lmac_id))
 		return;
-	if (enable) {
-		/* Enable receive pause frames */
-		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
-		cfg |= CGX_SMUX_RX_FRM_CTL_CTL_BCK;
-		cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
-
-		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
-		cfg |= CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
-		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
-
-		/* Enable pause frames transmission */
-		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
-		cfg |= CGX_SMUX_TX_CTL_L2P_BP_CONV;
-		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
 
+	if (enable) {
 		/* Set pause time and interval */
 		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_PAUSE_PKT_TIME,
 			  DEFAULT_PAUSE_TIME);
@@ -813,21 +800,21 @@ static void cgx_lmac_pause_frm_config(void *cgxd, int lmac_id, bool enable)
 		cfg &= ~0xFFFFULL;
 		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_TX_PAUSE_PKT_INTERVAL,
 			  cfg | (DEFAULT_PAUSE_TIME / 2));
-	} else {
-		/* ALL pause frames received are completely ignored */
-		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
-		cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
-		cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
+	}
 
-		cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
-		cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
-		cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+	/* ALL pause frames received are completely ignored */
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL);
+	cfg &= ~CGX_SMUX_RX_FRM_CTL_CTL_BCK;
+	cgx_write(cgx, lmac_id, CGXX_SMUX_RX_FRM_CTL, cfg);
 
-		/* Disable pause frames transmission */
-		cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
-		cfg &= ~CGX_SMUX_TX_CTL_L2P_BP_CONV;
-		cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
-	}
+	cfg = cgx_read(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL);
+	cfg &= ~CGX_GMP_GMI_RXX_FRM_CTL_CTL_BCK;
+	cgx_write(cgx, lmac_id, CGXX_GMP_GMI_RXX_FRM_CTL, cfg);
+
+	/* Disable pause frames transmission */
+	cfg = cgx_read(cgx, lmac_id, CGXX_SMUX_TX_CTL);
+	cfg &= ~CGX_SMUX_TX_CTL_L2P_BP_CONV;
+	cgx_write(cgx, lmac_id, CGXX_SMUX_TX_CTL, cfg);
 }
 
 void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
index 9ea2f6ac38ec..8c0b35a868cf 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rpm.c
@@ -167,26 +167,6 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 	u64 cfg;
 
 	if (enable) {
-		/* Enable 802.3 pause frame mode */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_PFC_MODE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-
-		/* Enable receive pause frames */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-
-		/* Enable forward pause to TX block */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-
-		/* Enable pause frames transmission */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg &= ~RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-
 		/* Set pause time and interval */
 		cfg = rpm_read(rpm, lmac_id,
 			       RPMX_MTI_MAC100X_CL01_PAUSE_QUANTA);
@@ -199,23 +179,22 @@ void rpm_lmac_pause_frm_config(void *rpmd, int lmac_id, bool enable)
 		cfg &= ~0xFFFFULL;
 		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_CL01_QUANTA_THRESH,
 			  cfg | (RPM_DEFAULT_PAUSE_TIME / 2));
+	}
 
-	} else {
-		/* ALL pause frames received are completely ignored */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	/* ALL pause frames received are completely ignored */
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_RX_P_DISABLE;
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
 
-		/* Disable forward pause to TX block */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
+	/* Disable forward pause to TX block */
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_PAUSE_IGNORE;
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
 
-		/* Disable pause frames transmission */
-		cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
-		cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
-		rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
-	}
+	/* Disable pause frames transmission */
+	cfg = rpm_read(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG);
+	cfg |= RPMX_MTI_MAC100X_COMMAND_CONFIG_TX_P_DISABLE;
+	rpm_write(rpm, lmac_id, RPMX_MTI_MAC100X_COMMAND_CONFIG, cfg);
 }
 
 int rpm_get_rx_stats(void *rpmd, int lmac_id, int idx, u64 *rx_stat)
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 97fb61915379..811d775a9752 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -296,7 +296,6 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf,
 	struct rvu_hwinfo *hw = rvu->hw;
 	struct sdp_node_info *sdp_info;
 	int pkind, pf, vf, lbkid, vfid;
-	struct mac_ops *mac_ops;
 	u8 cgx_id, lmac_id;
 	bool from_vf;
 	int err;
@@ -326,13 +325,6 @@ static int nix_interface_init(struct rvu *rvu, u16 pcifunc, int type, int nixlf,
 		cgx_set_pkind(rvu_cgx_pdata(cgx_id, rvu), lmac_id, pkind);
 		rvu_npc_set_pkind(rvu, pkind, pfvf);
 
-		mac_ops = get_mac_ops(rvu_cgx_pdata(cgx_id, rvu));
-
-		/* By default we enable pause frames */
-		if ((pcifunc & RVU_PFVF_FUNC_MASK) == 0)
-			mac_ops->mac_enadis_pause_frm(rvu_cgx_pdata(cgx_id,
-								    rvu),
-						      lmac_id, true, true);
 		break;
 	case NIX_INTF_TYPE_LBK:
 		vf = (pcifunc & RVU_PFVF_FUNC_MASK) - 1;
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
index 86c1c2f77bd7..67fbe6ec0030 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_pf.c
@@ -1697,9 +1697,6 @@ int otx2_open(struct net_device *netdev)
 	if (pf->linfo.link_up && !(pf->pcifunc & RVU_PFVF_FUNC_MASK))
 		otx2_handle_link_event(pf);
 
-	/* Restore pause frame settings */
-	otx2_config_pause_frm(pf);
-
 	/* Install DMAC Filters */
 	if (pf->flags & OTX2_FLAG_DMACFLTR_SUPPORT)
 		otx2_dmacflt_reinstall_flows(pf);
@@ -2782,10 +2779,6 @@ static int otx2_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Enable link notifications */
 	otx2_cgx_config_linkevents(pf, true);
 
-	/* Enable pause frames by default */
-	pf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
-	pf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
-
 	return 0;
 
 err_pf_sriov_init:
@@ -2929,6 +2922,14 @@ static void otx2_remove(struct pci_dev *pdev)
 	if (pf->flags & OTX2_FLAG_RX_TSTAMP_ENABLED)
 		otx2_config_hw_rx_tstamp(pf, false);
 
+	/* Disable 802.3x pause frames */
+	if (pf->flags & OTX2_FLAG_RX_PAUSE_ENABLED ||
+	    (pf->flags & OTX2_FLAG_TX_PAUSE_ENABLED)) {
+		pf->flags &= ~OTX2_FLAG_RX_PAUSE_ENABLED;
+		pf->flags &= ~OTX2_FLAG_TX_PAUSE_ENABLED;
+		otx2_config_pause_frm(pf);
+	}
+
 	cancel_work_sync(&pf->reset_task);
 	/* Disable link notifications */
 	otx2_cgx_config_linkevents(pf, false);
diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
index d96c8903c67e..c154b09ec12f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_vf.c
@@ -702,10 +702,6 @@ static int otx2vf_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	if (err)
 		goto err_unreg_netdev;
 
-	/* Enable pause frames by default */
-	vf->flags |= OTX2_FLAG_RX_PAUSE_ENABLED;
-	vf->flags |= OTX2_FLAG_TX_PAUSE_ENABLED;
-
 	return 0;
 
 err_unreg_netdev:
@@ -740,6 +736,14 @@ static void otx2vf_remove(struct pci_dev *pdev)
 
 	vf = netdev_priv(netdev);
 
+	/* Disable 802.3x pause frames */
+	if (vf->flags & OTX2_FLAG_RX_PAUSE_ENABLED ||
+	    (vf->flags & OTX2_FLAG_TX_PAUSE_ENABLED)) {
+		vf->flags &= ~OTX2_FLAG_RX_PAUSE_ENABLED;
+		vf->flags &= ~OTX2_FLAG_TX_PAUSE_ENABLED;
+		otx2_config_pause_frm(vf);
+	}
+
 	cancel_work_sync(&vf->reset_task);
 	otx2_unregister_dl(vf);
 	unregister_netdev(netdev);
-- 
2.17.1


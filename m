Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A881314D4D
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 11:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhBIKln (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 05:41:43 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:12158 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231200AbhBIKhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 05:37:01 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 119ATsDv022163;
        Tue, 9 Feb 2021 02:35:47 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type; s=pfpt0220; bh=6jXgiteuOTT/CzaEanZL1sh/N883zggwnwz98iQ99R0=;
 b=W3iypI5kLn0ztdSTn3EYhyg71cQ4KE1ZTEmTMHg6DQf6SvfEei0arKx9/oUbzP2fSQjt
 NiEynyPwux35wFLCz0eJt9qJhz3wZ0UHHD5PF5h0lORnfDQhHMvCXUeVLuazfxSby1GQ
 6I859yymj8BxMbIBuGGiu5tvCJeS/lCZfVRtrKcKgJD3+BK3vrXbilBm5ohwgBan4LWj
 EmrwQLNyQICXEezYYDdlR7EaXnPHn3j6Bxl1FnkAInc/qt+SsPE8txexpWdTK8EpqXid
 rXBnZ3fc4zJDlXA62xsZ5MJNqk3XZJx++b904hbj53iPw6eLQzMmr8oYll2t1U16ILfU AQ== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrg136-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 09 Feb 2021 02:35:47 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 02:35:45 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 9 Feb
 2021 02:35:45 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Tue, 9 Feb 2021 02:35:45 -0800
Received: from hyd1soter2.marvell.com (unknown [10.29.37.45])
        by maili.marvell.com (Postfix) with ESMTP id D59883F703F;
        Tue,  9 Feb 2021 02:35:41 -0800 (PST)
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>,
        <willemdebruijn.kernel@gmail.com>, <andrew@lunn.ch>,
        <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <sbhatta@marvell.com>,
        <hkelam@marvell.com>
Subject: [Patch v4 net-next 2/7] octeontx2-af: Add new CGX_CMD to get PHY FEC statistics
Date:   Tue, 9 Feb 2021 16:05:26 +0530
Message-ID: <1612866931-79299-3-git-send-email-hkelam@marvell.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1612866931-79299-1-git-send-email-hkelam@marvell.com>
References: <1612866931-79299-1-git-send-email-hkelam@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-09_03:2021-02-09,2021-02-09 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Felix Manlunas <fmanlunas@marvell.com>

This patch adds support to fetch fec stats from PHY. The stats are
put in the shared data struct fwdata.  A PHY driver indicates
that it has FEC stats by setting the flag fwdata.phy.misc.has_fec_stats

Besides CGX_CMD_GET_PHY_FEC_STATS, also add CGX_CMD_PRBS and
CGX_CMD_DISPLAY_EYE to enum cgx_cmd_id so that Linux's enum list is in sync
with firmware's enum list.

Signed-off-by: Felix Manlunas <fmanlunas@marvell.com>
Signed-off-by: Christina Jacob <cjacob@marvell.com>
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 12 ++++++
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  1 +
 .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  5 +++
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h   | 43 ++++++++++++++++++++++
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |  4 ++
 .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    | 32 ++++++++++++++++
 6 files changed, 97 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index fe5512d..b636341 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -861,6 +861,18 @@ int cgx_set_fec(u64 fec, int cgx_id, int lmac_id)
 	return cgx->lmac_idmap[lmac_id]->link_info.fec;
 }

+int cgx_get_phy_fec_stats(void *cgxd, int lmac_id)
+{
+	struct cgx *cgx = cgxd;
+	u64 req = 0, resp;
+
+	if (!cgx)
+		return -ENODEV;
+
+	req = FIELD_SET(CMDREG_ID, CGX_CMD_GET_PHY_FEC_STATS, req);
+	return cgx_fwi_cmd_generic(req, &resp, cgx, lmac_id);
+}
+
 static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool enable)
 {
 	u64 req = 0;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 1824e95..c5294b7 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -154,5 +154,6 @@ void cgx_lmac_ptp_config(void *cgxd, int lmac_id, bool enable);
 u8 cgx_lmac_get_p2x(int cgx_id, int lmac_id);
 int cgx_set_fec(u64 fec, int cgx_id, int lmac_id);
 int cgx_get_fec_stats(void *cgxd, int lmac_id, struct cgx_fec_stats_rsp *rsp);
+int cgx_get_phy_fec_stats(void *cgxd, int lmac_id);

 #endif /* CGX_H */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index 3485596..65f832a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -89,6 +89,11 @@ enum cgx_cmd_id {
 	CGX_CMD_SET_AN,
 	CGX_CMD_GET_ADV_LINK_MODES,
 	CGX_CMD_GET_ADV_FEC,
+	CGX_CMD_GET_PHY_MOD_TYPE, /* line-side modulation type: NRZ or PAM4 */
+	CGX_CMD_SET_PHY_MOD_TYPE,
+	CGX_CMD_PRBS,
+	CGX_CMD_DISPLAY_EYE,
+	CGX_CMD_GET_PHY_FEC_STATS,
 };

 /* async event ids */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 0591621..b8b8cd3 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -151,6 +151,8 @@ M(CGX_CFG_PAUSE_FRM,	0x20E, cgx_cfg_pause_frm, cgx_pause_frm_cfg,	\
 			       cgx_pause_frm_cfg)			\
 M(CGX_FEC_SET,		0x210, cgx_set_fec_param, fec_mode, fec_mode)   \
 M(CGX_FEC_STATS,	0x211, cgx_fec_stats, msg_req, cgx_fec_stats_rsp) \
+M(CGX_GET_PHY_FEC_STATS, 0x212, cgx_get_phy_fec_stats, msg_req, msg_rsp) \
+M(CGX_FW_DATA_GET,	0x213, cgx_get_aux_link_info, msg_req, cgx_fw_data) \
  /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 /* NPA mbox IDs (range 0x400 - 0x5FF) */				\
 M(NPA_LF_ALLOC,		0x400, npa_lf_alloc,				\
@@ -413,6 +415,47 @@ struct fec_mode {
 	int fec;
 };

+struct sfp_eeprom_s {
+#define SFP_EEPROM_SIZE 256
+	u16 sff_id;
+	u8 buf[SFP_EEPROM_SIZE];
+	u64 reserved;
+};
+
+struct phy_s {
+	struct {
+		u64 can_change_mod_type:1;
+		u64 mod_type:1;
+		u64 has_fec_stats:1;
+	} misc;
+	struct fec_stats_s {
+		u32 rsfec_corr_cws;
+		u32 rsfec_uncorr_cws;
+		u32 brfec_corr_blks;
+		u32 brfec_uncorr_blks;
+	} fec_stats;
+};
+
+struct cgx_lmac_fwdata_s {
+	u16 rw_valid;
+	u64 supported_fec;
+	u64 supported_an;
+	u64 supported_link_modes;
+	/* only applicable if AN is supported */
+	u64 advertised_fec;
+	u64 advertised_link_modes;
+	/* Only applicable if SFP/QSFP slot is present */
+	struct sfp_eeprom_s sfp_eeprom;
+	struct phy_s phy;
+#define LMAC_FWDATA_RESERVED_MEM 1021
+	u64 reserved[LMAC_FWDATA_RESERVED_MEM];
+};
+
+struct cgx_fw_data {
+	struct mbox_msghdr hdr;
+	struct cgx_lmac_fwdata_s fwdata;
+};
+
 /* NPA mbox message formats */

 /* NPA mailbox error codes
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index b1a6ecf..49b493b 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -350,6 +350,10 @@ struct rvu_fwdata {
 	u64 msixtr_base;
 #define FWDATA_RESERVED_MEM 1023
 	u64 reserved[FWDATA_RESERVED_MEM];
+#define CGX_MAX         5
+#define CGX_LMACS_MAX   4
+	struct cgx_lmac_fwdata_s cgx_fw_data[CGX_MAX][CGX_LMACS_MAX];
+	/* Do not add new fields below this line */
 };

 struct ptp;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
index 22b1a21..38ff973 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_cgx.c
@@ -692,6 +692,19 @@ int rvu_mbox_handler_cgx_cfg_pause_frm(struct rvu *rvu,
 	return 0;
 }

+int rvu_mbox_handler_cgx_get_phy_fec_stats(struct rvu *rvu, struct msg_req *req,
+					   struct msg_rsp *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+	return cgx_get_phy_fec_stats(rvu_cgx_pdata(cgx_id, rvu), lmac_id);
+}
+
 /* Finds cumulative status of NIX rx/tx counters from LF of a PF and those
  * from its VFs as well. ie. NIX rx/tx counters at the CGX port level
  */
@@ -800,3 +813,22 @@ int rvu_mbox_handler_cgx_set_fec_param(struct rvu *rvu,
 	rsp->fec = cgx_set_fec(req->fec, cgx_id, lmac_id);
 	return 0;
 }
+
+int rvu_mbox_handler_cgx_get_aux_link_info(struct rvu *rvu, struct msg_req *req,
+					   struct cgx_fw_data *rsp)
+{
+	int pf = rvu_get_pf(req->hdr.pcifunc);
+	u8 cgx_id, lmac_id;
+
+	if (!rvu->fwdata)
+		return -ENXIO;
+
+	if (!is_pf_cgxmapped(rvu, pf))
+		return -EPERM;
+
+	rvu_get_cgx_lmac_id(rvu->pf2cgxlmac_map[pf], &cgx_id, &lmac_id);
+
+	memcpy(&rsp->fwdata, &rvu->fwdata->cgx_fw_data[cgx_id][lmac_id],
+	       sizeof(struct cgx_lmac_fwdata_s));
+	return 0;
+}
--
2.7.4

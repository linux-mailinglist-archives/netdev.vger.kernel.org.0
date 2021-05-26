Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26DD9391C8A
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 17:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235505AbhEZP6q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 11:58:46 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:65100 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S235470AbhEZP6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 11:58:41 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 14QFsvdo003111;
        Wed, 26 May 2021 08:57:08 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=IRCu9FhnsP6TpI5fPps2JB0albwaSmetIusHcuHrrtE=;
 b=j7HUICb4mH4D1BgI6iyql9Kr3kdiSKPdVul5Wso4v7qbJsvrcIgMrAk5FG+WGii15d0h
 0JRu/CQO1b50yOdfsoEN9cB65Q4Ejv1uiMgxN2cFpirIP1W+oBv1RqiImdcxQDBaL65T
 o894vtYqKMPkuyEZIVNIv5oNEnIIAPxoNDYd+zA0A7uO2w0Ky6xG7HX/OYpMGv9wxxEw
 mXTrwk6Ei01GnG82SrYmU9zhWF1WifZh8X/M7hejRRWph59pYFsb6LRBQmchHMJQCoE4
 pgdkTlO6f8gvPOod8kUANuUeeRtaEb1clVkwYO00hGrciq7cjKNyQu5tJasdY6zcw5OU sw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 38spf38tnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 26 May 2021 08:57:08 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 26 May
 2021 08:57:07 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Wed, 26 May 2021 08:57:07 -0700
Received: from hyd1584.marvell.com (unknown [10.29.37.82])
        by maili.marvell.com (Postfix) with ESMTP id 55DFB3F7043;
        Wed, 26 May 2021 08:57:05 -0700 (PDT)
From:   George Cherian <george.cherian@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <kuba@kernel.org>, <davem@davemloft.net>, <gcherian@marvell.com>,
        <sgoutham@marvell.com>
Subject: [net-next PATCH 3/5] octeontx2-af: adding new lt def registers support
Date:   Wed, 26 May 2021 21:26:54 +0530
Message-ID: <20210526155656.2689892-4-george.cherian@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210526155656.2689892-1-george.cherian@marvell.com>
References: <20210526155656.2689892-1-george.cherian@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: KW5iru3ME5r4srhKws8W9Ur0NDkoBPii
X-Proofpoint-ORIG-GUID: KW5iru3ME5r4srhKws8W9Ur0NDkoBPii
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-05-26_10:2021-05-26,2021-05-26 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Harman Kalra <hkalra@marvell.com>

CN10k introduces following new LT DEF registers:
1. APAD (alignment padding) LT DEF registers are
enhancement to existing apad calculation algorithm
where not just ipv4 and ipv6 but also other protocols
can be matched and required alignment can be added by NIX.

2. ET LT DEF register defines layer information in NPC_RESULT_S
to identify the Ethertype location in L2 header. Used for
Ethertype overwriting in inline IPsec flow.

This patch adds required structures and some header changes. Also
strict version check (based on minor field) is imposed to highlight
version mismatch between the kernel headers and KPU profile.

Signed-off-by: Harman Kalra <hkalra@marvell.com>
Signed-off-by: Jerin Jacob Kollanukkaran <jerinj@marvell.com>
Signed-off-by: Kiran Kumar Kokkilagadda <kirankumark@marvell.com>
Signed-off-by: George Cherian <george.cherian@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   | 32 ++++++++++++++++-
 .../marvell/octeontx2/af/npc_profile.h        | 26 +++++++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 34 +++++++++++++++++++
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 20 ++++++++++-
 .../ethernet/marvell/octeontx2/af/rvu_reg.h   |  4 ++-
 5 files changed, 112 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index db40b1d780ec..d5837ec91d1e 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -468,6 +468,29 @@ struct npc_lt_def_ipsec {
 	u8	spi_nz;
 };
 
+struct npc_lt_def_apad {
+	u8	ltype_mask;
+	u8	ltype_match;
+	u8	lid;
+	u8	valid;
+} __packed;
+
+struct npc_lt_def_color {
+	u8	ltype_mask;
+	u8	ltype_match;
+	u8	lid;
+	u8	noffset;
+	u8	offset;
+} __packed;
+
+struct npc_lt_def_et {
+	u8	ltype_mask;
+	u8	ltype_match;
+	u8	lid;
+	u8	valid;
+	u8	offset;
+} __packed;
+
 struct npc_lt_def_cfg {
 	struct npc_lt_def	rx_ol2;
 	struct npc_lt_def	rx_oip4;
@@ -485,7 +508,14 @@ struct npc_lt_def_cfg {
 	struct npc_lt_def	pck_oip4;
 	struct npc_lt_def	pck_oip6;
 	struct npc_lt_def	pck_iip4;
-};
+	struct npc_lt_def_apad	rx_apad0;
+	struct npc_lt_def_apad	rx_apad1;
+	struct npc_lt_def_color	rx_ovlan;
+	struct npc_lt_def_color	rx_ivlan;
+	struct npc_lt_def_color	rx_gen0_color;
+	struct npc_lt_def_color	rx_gen1_color;
+	struct npc_lt_def_et	rx_et[2];
+} __packed;
 
 /* Loadable KPU profile firmware data */
 struct npc_kpu_profile_fwdata {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index ccb28f4321ed..15a707f6766a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -11,7 +11,7 @@
 #ifndef NPC_PROFILE_H
 #define NPC_PROFILE_H
 
-#define NPC_KPU_PROFILE_VER	0x0000000100050000
+#define NPC_KPU_PROFILE_VER	0x0000000100060000
 #define NPC_KPU_VER_MAJ(ver)	(u16()(((ver) >> 32) & 0xFFFF))
 #define NPC_KPU_VER_MIN(ver)	((u16)(((ver) >> 16) & 0xFFFF))
 #define NPC_KPU_VER_PATCH(ver)	((u16)((ver) & 0xFFFF))
@@ -13480,6 +13480,30 @@ static const struct npc_lt_def_cfg npc_lt_defaults = {
 			.ltype_match = NPC_LT_LG_TU_IP,
 			.ltype_mask = 0x0F,
 	},
+	.rx_apad0 = {
+		.valid = 0,
+		.lid = NPC_LID_LC,
+		.ltype_match = NPC_LT_LC_IP6,
+		.ltype_mask = 0x0F,
+	},
+	.rx_apad1 = {
+		.valid = 0,
+		.lid = NPC_LID_LC,
+		.ltype_match = NPC_LT_LC_IP6,
+		.ltype_mask = 0x0F,
+	},
+	.rx_et = {
+		{
+			.lid = NPC_LID_LB,
+			.ltype_match = NPC_LT_NA,
+			.ltype_mask = 0x0,
+		},
+		{
+			.lid = NPC_LID_LB,
+			.ltype_match = NPC_LT_NA,
+			.ltype_mask = 0x0,
+		},
+	},
 };
 
 static struct npc_mcam_kex npc_mkex_default = {
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 0a8bd667cb11..174ef09f9069 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3523,6 +3523,40 @@ static int rvu_nix_block_init(struct rvu *rvu, struct nix_hw *nix_hw)
 			    (ltdefs->rx_isctp.lid << 8) | (ltdefs->rx_isctp.ltype_match << 4) |
 			    ltdefs->rx_isctp.ltype_mask);
 
+		if (!is_rvu_otx2(rvu)) {
+			/* Enable APAD calculation for other protocols
+			 * matching APAD0 and APAD1 lt def registers.
+			 */
+			rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_CST_APAD0,
+				    (ltdefs->rx_apad0.valid << 11) |
+				    (ltdefs->rx_apad0.lid << 8) |
+				    (ltdefs->rx_apad0.ltype_match << 4) |
+				    ltdefs->rx_apad0.ltype_mask);
+			rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_CST_APAD1,
+				    (ltdefs->rx_apad1.valid << 11) |
+				    (ltdefs->rx_apad1.lid << 8) |
+				    (ltdefs->rx_apad1.ltype_match << 4) |
+				    ltdefs->rx_apad1.ltype_mask);
+
+			/* Receive ethertype defination register defines layer
+			 * information in NPC_RESULT_S to identify the Ethertype
+			 * location in L2 header. Used for Ethertype overwriting
+			 * in inline IPsec flow.
+			 */
+			rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_ET(0),
+				    (ltdefs->rx_et[0].offset << 12) |
+				    (ltdefs->rx_et[0].valid << 11) |
+				    (ltdefs->rx_et[0].lid << 8) |
+				    (ltdefs->rx_et[0].ltype_match << 4) |
+				    ltdefs->rx_et[0].ltype_mask);
+			rvu_write64(rvu, blkaddr, NIX_AF_RX_DEF_ET(1),
+				    (ltdefs->rx_et[1].offset << 12) |
+				    (ltdefs->rx_et[1].valid << 11) |
+				    (ltdefs->rx_et[1].lid << 8) |
+				    (ltdefs->rx_et[1].ltype_match << 4) |
+				    ltdefs->rx_et[1].ltype_mask);
+		}
+
 		err = nix_rx_flowkey_alg_cfg(rvu, blkaddr);
 		if (err)
 			return err;
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index 61df80cfed1a..a5dc2ac8bc4a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1365,6 +1365,19 @@ static int npc_apply_custom_kpu(struct rvu *rvu,
 			 NPC_KPU_VER_MAJ(NPC_KPU_PROFILE_VER));
 		return -EINVAL;
 	}
+	/* Verify if profile is aligned with the required kernel changes */
+	if (NPC_KPU_VER_MIN(profile->version) <
+	    NPC_KPU_VER_MIN(NPC_KPU_PROFILE_VER)) {
+		dev_warn(rvu->dev,
+			 "Invalid KPU profile version: %d.%d.%d expected vesion <= %d.%d.%d\n",
+			 NPC_KPU_VER_MAJ(profile->version),
+			 NPC_KPU_VER_MIN(profile->version),
+			 NPC_KPU_VER_PATCH(profile->version),
+			 NPC_KPU_VER_MAJ(NPC_KPU_PROFILE_VER),
+			 NPC_KPU_VER_MIN(NPC_KPU_PROFILE_VER),
+			 NPC_KPU_VER_PATCH(NPC_KPU_PROFILE_VER));
+		return -EINVAL;
+	}
 	/* Verify if profile fits the HW */
 	if (fw->kpus > profile->kpus) {
 		dev_warn(rvu->dev, "Not enough KPUs: %d > %ld\n", fw->kpus,
@@ -1443,6 +1456,7 @@ static void npc_load_kpu_profile(struct rvu *rvu)
 	struct npc_kpu_profile_adapter *profile = &rvu->kpu;
 	const char *kpu_profile = rvu->kpu_pfl_name;
 	const struct firmware *fw = NULL;
+	bool retry_fwdb = false;
 
 	/* If user not specified profile customization */
 	if (!strncmp(kpu_profile, def_pfl_name, KPU_NAME_LEN))
@@ -1464,6 +1478,7 @@ static void npc_load_kpu_profile(struct rvu *rvu)
 			rvu->kpu_fwdata_sz = fw->size;
 		}
 		release_firmware(fw);
+		retry_fwdb = true;
 		goto program_kpu;
 	}
 
@@ -1488,7 +1503,10 @@ static void npc_load_kpu_profile(struct rvu *rvu)
 			}
 			rvu->kpu_fwdata = NULL;
 			rvu->kpu_fwdata_sz = 0;
-			goto load_image_fwdb;
+			if (retry_fwdb) {
+				retry_fwdb = false;
+				goto load_image_fwdb;
+			}
 		}
 
 		dev_warn(rvu->dev,
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index ac71c0f2f960..ce365ae80352 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -208,7 +208,7 @@
 #define NIX_AF_RVU_INT_ENA_W1S		(0x01D0)
 #define NIX_AF_RVU_INT_ENA_W1C		(0x01D8)
 #define NIX_AF_TCP_TIMER		(0x01E0)
-#define NIX_AF_RX_WQE_TAG_CTL		(0x01F0)
+#define NIX_AF_RX_DEF_ET(a)		(0x01F0ull | (uint64_t)(a) << 3)
 #define NIX_AF_RX_DEF_OL2		(0x0200)
 #define NIX_AF_RX_DEF_OIP4		(0x0210)
 #define NIX_AF_RX_DEF_IIP4		(0x0220)
@@ -219,8 +219,10 @@
 #define NIX_AF_RX_DEF_OUDP		(0x0270)
 #define NIX_AF_RX_DEF_IUDP		(0x0280)
 #define NIX_AF_RX_DEF_OSCTP		(0x0290)
+#define NIX_AF_RX_DEF_CST_APAD0		(0x0298)
 #define NIX_AF_RX_DEF_ISCTP		(0x02A0)
 #define NIX_AF_RX_DEF_IPSECX		(0x02B0)
+#define NIX_AF_RX_DEF_CST_APAD1		(0x02A8)
 #define NIX_AF_RX_IPSEC_GEN_CFG		(0x0300)
 #define NIX_AF_RX_CPTX_INST_ADDR	(0x0310)
 #define NIX_AF_NDC_TX_SYNC		(0x03F0)
-- 
2.25.1


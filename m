Return-Path: <netdev+bounces-9189-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A2E6F727D3B
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 12:51:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 071061C20FF6
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:51:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B9E0C8CD;
	Thu,  8 Jun 2023 10:50:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A2D810974
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 10:50:36 +0000 (UTC)
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D102D57;
	Thu,  8 Jun 2023 03:50:34 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
	by mx0b-0016f401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35838QYX023519;
	Thu, 8 Jun 2023 03:50:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=Ax/yq4NvinpMK8sJ/K+gDkMxqN6eTkspj5OjglVD590=;
 b=Axo9Eo7fdadz1X/0vNv7dhNZglsIvJHge3iqS2RhCy5oMTUJc6S4DfBZW4W/P9N87N/C
 gNO9nnLKWRsW6egNKe/jf++REG5u8WQsdCwnJgBZNnhf4GKsnxLAnh3uuDI0Byl4Wt8J
 X9il6lKXBL3AE0Ieh35Mx6q+8pXuWkEtCSzpenEVnauH7p5F816+UOBCly8aVIKDxa6z
 9Mq9UlyCisMTg83dYa1uphW69rB4vhhqVjJC7oz0tlJ+t15hKTUiOCtPXPGRWD4GFx4n
 ExbaY/Ft50ZlLAQ47y8383zjfl0/r7N7UOQ4vl3+Ckdn8MvyEMOtRaooT5obDJ3kf33n Xw== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
	by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3r30eu27cx-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
	Thu, 08 Jun 2023 03:50:21 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Thu, 8 Jun
 2023 03:50:19 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.48 via Frontend
 Transport; Thu, 8 Jun 2023 03:50:18 -0700
Received: from #hyd1583.marvell.com (unknown [10.29.37.44])
	by maili.marvell.com (Postfix) with ESMTP id CCC183F70B6;
	Thu,  8 Jun 2023 03:50:15 -0700 (PDT)
From: Naveen Mamindlapalli <naveenm@marvell.com>
To: <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>
CC: Kiran Kumar K <kirankumark@marvell.com>,
        Geetha sowjanya
	<gakula@marvell.com>,
        Naveen Mamindlapalli <naveenm@marvell.com>
Subject: [net-next PATCH 2/6] octeontx2-af: extend RSS supported offload types
Date: Thu, 8 Jun 2023 16:20:03 +0530
Message-ID: <20230608105007.26924-3-naveenm@marvell.com>
X-Mailer: git-send-email 2.39.0.198.ga38d39a4c5
In-Reply-To: <20230608105007.26924-1-naveenm@marvell.com>
References: <20230608105007.26924-1-naveenm@marvell.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: zB_6fweu-mb1lf41PfabjLNfBp-D11ag
X-Proofpoint-GUID: zB_6fweu-mb1lf41PfabjLNfBp-D11ag
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_07,2023-06-08_01,2023-05-22_02
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
	SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

From: Kiran Kumar K <kirankumark@marvell.com>

Add support to select L3 SRC or DST only, L4 SRC or DST only for RSS
calculation.

AF consumer may have requirement as we can select only SRC or DST data for
RSS calculation in L3, L4 layers. With this requirement there will be
following combinations, IPV[4,6]_SRC_ONLY, IPV[4,6]_DST_ONLY,
[TCP,UDP,SCTP]_SRC_ONLY, [TCP,UDP,SCTP]_DST_ONLY. So, instead of creating
a bit for each combination, we are using upper 4 bits (31:28) in the
flow_key_cfg to represent the SRC, DST selection. 31 => L3_SRC,
30 => L3_DST, 29 => L4_SRC, 28 => L4_DST. These won't be part of flow_cfg,
so that we don't need to change the existing ABI.

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
Signed-off-by: Geetha sowjanya <gakula@marvell.com>
Signed-off-by: Naveen Mamindlapalli <naveenm@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/mbox.h  |  6 ++
 .../ethernet/marvell/octeontx2/af/rvu_nix.c   | 57 +++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index d2584ebb7a70..43968f0b6218 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1074,6 +1074,8 @@ struct nix_vtag_config_rsp {
 	 */
 };
 
+#define NIX_FLOW_KEY_TYPE_L3_L4_MASK (~(0xf << 28))
+
 struct nix_rss_flowkey_cfg {
 	struct mbox_msghdr hdr;
 	int	mcam_index;  /* MCAM entry index to modify */
@@ -1099,6 +1101,10 @@ struct nix_rss_flowkey_cfg {
 #define NIX_FLOW_KEY_TYPE_IPV4_PROTO	BIT(21)
 #define NIX_FLOW_KEY_TYPE_AH		BIT(22)
 #define NIX_FLOW_KEY_TYPE_ESP		BIT(23)
+#define NIX_FLOW_KEY_TYPE_L4_DST_ONLY BIT(28)
+#define NIX_FLOW_KEY_TYPE_L4_SRC_ONLY BIT(29)
+#define NIX_FLOW_KEY_TYPE_L3_DST_ONLY BIT(30)
+#define NIX_FLOW_KEY_TYPE_L3_SRC_ONLY BIT(31)
 	u32	flowkey_cfg; /* Flowkey types selected */
 	u8	group;       /* RSS context or group */
 };
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 6b8747ebc08c..d40bde3948b4 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -3287,6 +3287,7 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 	struct nix_rx_flowkey_alg *field;
 	struct nix_rx_flowkey_alg tmp;
 	u32 key_type, valid_key;
+	u32 l3_l4_src_dst;
 	int l4_key_offset = 0;
 
 	if (!alg)
@@ -3314,6 +3315,15 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 	 * group_member - Enabled when protocol is part of a group.
 	 */
 
+	/* Last 4 bits (31:28) are reserved to specify SRC, DST
+	 * selection for L3, L4 i.e IPV[4,6]_SRC, IPV[4,6]_DST,
+	 * [TCP,UDP,SCTP]_SRC, [TCP,UDP,SCTP]_DST
+	 * 31 => L3_SRC, 30 => L3_DST, 29 => L4_SRC, 28 => L4_DST
+	 */
+	l3_l4_src_dst = flow_cfg;
+	/* Reset these 4 bits, so that these won't be part of key */
+	flow_cfg &= NIX_FLOW_KEY_TYPE_L3_L4_MASK;
+
 	keyoff_marker = 0; max_key_off = 0; group_member = 0;
 	nr_field = 0; key_off = 0; field_marker = 1;
 	field = &tmp; max_bit_pos = fls(flow_cfg);
@@ -3351,6 +3361,22 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 			}
 			field->hdr_offset = 12; /* SIP offset */
 			field->bytesm1 = 7; /* SIP + DIP, 8 bytes */
+
+			/* Only SIP */
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L3_SRC_ONLY)
+				field->bytesm1 = 3; /* SIP, 4 bytes */
+
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L3_DST_ONLY) {
+				/* Both SIP + DIP */
+				if (field->bytesm1 == 3) {
+					field->bytesm1 = 7; /* SIP + DIP, 8B */
+				} else {
+					/* Only DIP */
+					field->hdr_offset = 16; /* DIP off */
+					field->bytesm1 = 3; /* DIP, 4 bytes */
+				}
+			}
+
 			field->ltype_mask = 0xF; /* Match only IPv4 */
 			keyoff_marker = false;
 			break;
@@ -3364,6 +3390,22 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 			}
 			field->hdr_offset = 8; /* SIP offset */
 			field->bytesm1 = 31; /* SIP + DIP, 32 bytes */
+
+			/* Only SIP */
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L3_SRC_ONLY)
+				field->bytesm1 = 15; /* SIP, 16 bytes */
+
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L3_DST_ONLY) {
+				/* Both SIP + DIP */
+				if (field->bytesm1 == 15) {
+					/* SIP + DIP, 32 bytes */
+					field->bytesm1 = 31;
+				} else {
+					/* Only DIP */
+					field->hdr_offset = 24; /* DIP off */
+					field->bytesm1 = 15; /* DIP,16 bytes */
+				}
+			}
 			field->ltype_mask = 0xF; /* Match only IPv6 */
 			break;
 		case NIX_FLOW_KEY_TYPE_TCP:
@@ -3379,6 +3421,21 @@ static int set_flowkey_fields(struct nix_rx_flowkey_alg *alg, u32 flow_cfg)
 				field->lid = NPC_LID_LH;
 			field->bytesm1 = 3; /* Sport + Dport, 4 bytes */
 
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L4_SRC_ONLY)
+				field->bytesm1 = 1; /* SRC, 2 bytes */
+
+			if (l3_l4_src_dst & NIX_FLOW_KEY_TYPE_L4_DST_ONLY) {
+				/* Both SRC + DST */
+				if (field->bytesm1 == 1) {
+					/* SRC + DST, 4 bytes */
+					field->bytesm1 = 3;
+				} else {
+					/* Only DIP */
+					field->hdr_offset = 2; /* DST off */
+					field->bytesm1 = 1; /* DST, 2 bytes */
+				}
+			}
+
 			/* Enum values for NPC_LID_LD and NPC_LID_LG are same,
 			 * so no need to change the ltype_match, just change
 			 * the lid for inner protocols
-- 
2.39.0.198.ga38d39a4c5



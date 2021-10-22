Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21CBC437763
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 14:45:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232830AbhJVMsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 08:48:12 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64516 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232640AbhJVMsJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 08:48:09 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19M9qaNf002743;
        Fri, 22 Oct 2021 05:45:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=pfpt0220; bh=UmhW988wvPyz9SHxcI4xg/JxJLKuRC6JlAMxvHsHRAY=;
 b=ZzNZoVqgYxGXR91xeIXaET4LYU1sIH4kWHfmVUo9L3WCXdJ+XJDrgBhOCqYh4YS+IXEb
 sbc1ubpJN7x62mnFiAahZyCROuURWfcOxeAD+lyLX9SuDQj6Ucrspa65XCWqecAfavZ1
 kdjTtTVJh7p91GQSECN6aMp+h1f9GV1l6KW7e/0bCregsNSmK7n54NY0XfjTJcx/AuUe
 4GYAWnefXBJJAaimKXVhW7wnIDeo5zu1kCQR/Yb1/ALtbAV5k7cK7qXJiNQd/HvnKnp0
 VeONGrIv9lHCbKF38R545M9WAxgGE9WfEKQe8JFcT1d60zKSbNP/7kq8vYvdnD5vfqSo 5Q== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 3buu218k0w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 22 Oct 2021 05:45:47 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Fri, 22 Oct
 2021 05:45:45 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Fri, 22 Oct 2021 05:45:45 -0700
Received: from cavium-kiran.marvell.com (unknown [10.28.34.15])
        by maili.marvell.com (Postfix) with ESMTP id 94EFB3F7073;
        Fri, 22 Oct 2021 05:45:42 -0700 (PDT)
From:   <kirankumark@marvell.com>
To:     <sgoutham@marvell.com>, <lcherian@marvell.com>,
        <gakula@marvell.com>, <jerinj@marvell.com>, <hkelam@marvell.com>,
        <sbhatta@marvell.com>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     Kiran Kumar K <kirankumark@marvell.com>
Subject: [net-next PATCH] octeontx2-af: Increase number of reserved entries in KPU
Date:   Fri, 22 Oct 2021 18:15:37 +0530
Message-ID: <20211022124537.3101126-1-kirankumark@marvell.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: Shc_gAv0RVJTFPUnW9nx6vruAhpPsTZM
X-Proofpoint-ORIG-GUID: Shc_gAv0RVJTFPUnW9nx6vruAhpPsTZM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.182.1,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-10-22_03,2021-10-22_01,2020-04-07_01
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kiran Kumar K <kirankumark@marvell.com>

With current KPU profile, we have 2 reserved entries which can
be loaded from firmware to parse custom headers. Adding changes
to increase these reserved entries to 6.
And also removed KPU entries for unused LTYPEs like
NPC_LT_LA_IH_8_ETHER, NPC_LT_LA_IH_4_ETHER, NPC_LT_LA_IH_2_ETHER

Signed-off-by: Kiran Kumar K <kirankumark@marvell.com>
---
 .../net/ethernet/marvell/octeontx2/af/npc.h   |   7 +-
 .../marvell/octeontx2/af/npc_profile.h        | 388 ++++++------------
 2 files changed, 132 insertions(+), 263 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 6e1192f52608..3144d309783c 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -25,10 +25,7 @@ enum npc_kpu_la_ltype {
 	NPC_LT_LA_8023 = 1,
 	NPC_LT_LA_ETHER,
 	NPC_LT_LA_IH_NIX_ETHER,
-	NPC_LT_LA_IH_8_ETHER,
-	NPC_LT_LA_IH_4_ETHER,
-	NPC_LT_LA_IH_2_ETHER,
-	NPC_LT_LA_HIGIG2_ETHER,
+	NPC_LT_LA_HIGIG2_ETHER = 7,
 	NPC_LT_LA_IH_NIX_HIGIG2_ETHER,
 	NPC_LT_LA_CUSTOM_L2_90B_ETHER,
 	NPC_LT_LA_CPT_HDR,
@@ -554,7 +551,7 @@ struct npc_kpu_profile_fwdata {
 #define KPU_SIGN	0x00666f727075706b
 #define KPU_NAME_LEN	32
 /** Maximum number of custom KPU entries supported by the built-in profile. */
-#define KPU_MAX_CST_ENT	2
+#define KPU_MAX_CST_ENT	6
 	/* KPU Profle Header */
 	__le64	signature; /* "kpuprof\0" (8 bytes/ASCII characters) */
 	u8	name[KPU_NAME_LEN]; /* KPU Profile name */
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 1a8c5376297c..0fe7ad35e36f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -8,7 +8,7 @@
 #ifndef NPC_PROFILE_H
 #define NPC_PROFILE_H
 
-#define NPC_KPU_PROFILE_VER	0x0000000100060000
+#define NPC_KPU_PROFILE_VER	0x0000000100070000
 #define NPC_KPU_VER_MAJ(ver)	((u16)(((ver) >> 32) & 0xFFFF))
 #define NPC_KPU_VER_MIN(ver)	((u16)(((ver) >> 16) & 0xFFFF))
 #define NPC_KPU_VER_PATCH(ver)	((u16)((ver) & 0xFFFF))
@@ -184,7 +184,6 @@ enum npc_kpu_parser_state {
 	NPC_S_KPU2_SBTAG,
 	NPC_S_KPU2_QINQ,
 	NPC_S_KPU2_ETAG,
-	NPC_S_KPU2_PREHEADER,
 	NPC_S_KPU2_EXDSA,
 	NPC_S_KPU2_NGIO,
 	NPC_S_KPU2_CPT_CTAG,
@@ -1010,7 +1009,7 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 		NPC_S_KPU1_CPT_HDR, 40, 0,
 		NPC_LID_LA, NPC_LT_NA,
 		0,
-		7, 7, 0, 0,
+		0, 7, 0, 0,
 
 	},
 	{
@@ -1061,6 +1060,10 @@ static struct npc_kpu_profile_action ikpu_action_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -1378,33 +1381,6 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
-	{
-		NPC_S_KPU1_IH, 0xff,
-		NPC_IH_W | NPC_IH_UTAG,
-		NPC_IH_W | NPC_IH_UTAG,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_IH, 0xff,
-		NPC_IH_W,
-		NPC_IH_W | NPC_IH_UTAG,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU1_IH, 0xff,
-		0x0000,
-		NPC_IH_W | NPC_IH_UTAG,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
 	{
 		NPC_S_KPU1_IH, 0xff,
 		0x0000,
@@ -1903,6 +1879,10 @@ static struct npc_kpu_profile_cam kpu1_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -2625,114 +2605,6 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 		0x0000,
 		0x0000,
 	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_IP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_IP6,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_ARP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_RARP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_PTP,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_FCOE,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_CTAG,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_SBTAG,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_QINQ,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_MPLSU,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_MPLSM,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
-	{
-		NPC_S_KPU2_PREHEADER, 0xff,
-		NPC_ETYPE_NSH,
-		0xffff,
-		0x0000,
-		0x0000,
-		0x0000,
-		0x0000,
-	},
 	{
 		NPC_S_KPU2_EXDSA, 0xff,
 		NPC_DSA_EDSA,
@@ -2934,6 +2806,10 @@ static struct npc_kpu_profile_cam kpu2_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu3_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -3911,6 +3787,10 @@ static struct npc_kpu_profile_cam kpu3_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu4_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -4222,6 +4102,10 @@ static struct npc_kpu_profile_cam kpu4_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -5217,6 +5101,10 @@ static struct npc_kpu_profile_cam kpu5_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu6_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -5888,6 +5776,10 @@ static struct npc_kpu_profile_cam kpu6_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu7_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -6208,6 +6100,10 @@ static struct npc_kpu_profile_cam kpu7_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu8_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -6951,6 +6847,10 @@ static struct npc_kpu_profile_cam kpu8_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu9_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -7415,6 +7315,10 @@ static struct npc_kpu_profile_cam kpu9_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu10_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -7582,6 +7486,10 @@ static struct npc_kpu_profile_cam kpu10_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu11_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -7893,6 +7801,10 @@ static struct npc_kpu_profile_cam kpu11_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu12_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -8150,6 +8062,10 @@ static struct npc_kpu_profile_cam kpu12_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu13_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -8164,6 +8080,10 @@ static struct npc_kpu_profile_cam kpu13_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu14_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -8178,6 +8098,10 @@ static struct npc_kpu_profile_cam kpu14_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu15_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -8381,6 +8305,10 @@ static struct npc_kpu_profile_cam kpu15_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_cam kpu16_cam_entries[] = {
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
+	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	NPC_KPU_NOP_CAM,
 	{
@@ -8440,6 +8368,10 @@ static struct npc_kpu_profile_cam kpu16_cam_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu1_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -8727,30 +8659,6 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 		NPC_F_LA_U_HAS_IH_NIX | NPC_F_LA_L_UNK_ETYPE,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		12, 14, 16, 0, 0,
-		NPC_S_KPU2_PREHEADER, 8, 1,
-		NPC_LID_LA, NPC_LT_LA_IH_8_ETHER,
-		0,
-		1, 0xff, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		12, 14, 16, 0, 0,
-		NPC_S_KPU2_PREHEADER, 4, 1,
-		NPC_LID_LA, NPC_LT_LA_IH_4_ETHER,
-		0,
-		1, 0xff, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		12, 14, 16, 0, 0,
-		NPC_S_KPU2_PREHEADER, 2, 1,
-		NPC_LID_LA, NPC_LT_LA_IH_2_ETHER,
-		0,
-		1, 0xff, 0, 0,
-	},
 	{
 		NPC_ERRLEV_LA, NPC_EC_IH_LENGTH,
 		0, 0, 0, 0, 1,
@@ -9208,6 +9116,10 @@ static struct npc_kpu_profile_action kpu1_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu2_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -9850,102 +9762,6 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 		NPC_F_LB_U_UNK_ETYPE,
 		0, 0, 0, 0,
 	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		8, 0, 6, 2, 0,
-		NPC_S_KPU5_IP, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		6, 0, 0, 2, 0,
-		NPC_S_KPU5_IP6, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 2, 0,
-		NPC_S_KPU5_ARP, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 2, 0,
-		NPC_S_KPU5_RARP, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 2, 0,
-		NPC_S_KPU5_PTP, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		0, 0, 0, 2, 0,
-		NPC_S_KPU5_FCOE, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 0, 0, 0,
-		NPC_S_KPU3_CTAG_C, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 20, 0, 0,
-		NPC_S_KPU3_STAG_C, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 0, 0, 0,
-		NPC_S_KPU3_QINQ_C, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 10, 1, 0,
-		NPC_S_KPU4_MPLS, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 6, 10, 1, 0,
-		NPC_S_KPU4_MPLS, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
-	{
-		NPC_ERRLEV_RE, NPC_EC_NOERR,
-		2, 0, 0, 1, 0,
-		NPC_S_KPU4_NSH, 14, 0,
-		NPC_LID_LB, NPC_LT_NA,
-		0,
-		0, 0, 0, 0,
-	},
 	{
 		NPC_ERRLEV_RE, NPC_EC_NOERR,
 		8, 0, 6, 2, 0,
@@ -10125,6 +9941,10 @@ static struct npc_kpu_profile_action kpu2_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu3_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -10994,6 +10814,10 @@ static struct npc_kpu_profile_action kpu3_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu4_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -11271,6 +11095,10 @@ static struct npc_kpu_profile_action kpu4_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu5_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -12156,6 +11984,10 @@ static struct npc_kpu_profile_action kpu5_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu6_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -12753,6 +12585,10 @@ static struct npc_kpu_profile_action kpu6_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu7_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -13038,6 +12874,10 @@ static struct npc_kpu_profile_action kpu7_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu8_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -13699,6 +13539,10 @@ static struct npc_kpu_profile_action kpu8_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu9_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -14112,6 +13956,10 @@ static struct npc_kpu_profile_action kpu9_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu10_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -14261,6 +14109,10 @@ static struct npc_kpu_profile_action kpu10_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu11_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -14538,6 +14390,10 @@ static struct npc_kpu_profile_action kpu11_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu12_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -14767,6 +14623,10 @@ static struct npc_kpu_profile_action kpu12_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu13_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -14780,6 +14640,10 @@ static struct npc_kpu_profile_action kpu13_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu14_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -14793,6 +14657,10 @@ static struct npc_kpu_profile_action kpu14_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu15_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
@@ -14974,6 +14842,10 @@ static struct npc_kpu_profile_action kpu15_action_entries[] = {
 };
 
 static struct npc_kpu_profile_action kpu16_action_entries[] = {
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
+	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	NPC_KPU_NOP_ACTION,
 	{
-- 
2.25.1


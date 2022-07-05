Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 618AF566899
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 12:51:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiGEKv1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 06:51:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232736AbiGEKuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 06:50:23 -0400
Received: from mx0b-0016f401.pphosted.com (mx0a-0016f401.pphosted.com [67.231.148.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57FF615A1A;
        Tue,  5 Jul 2022 03:50:20 -0700 (PDT)
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 264MrHFP006865;
        Tue, 5 Jul 2022 03:50:15 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=HoWCvTwYonjl2bNuWgM9xrBjTlRBRBc+1uV2qqCjA1Q=;
 b=KuAnmeRzr9CVEGKy77zrdGhBr5krZOEb/hft2HUqthCa0M1ono5ifUNccJ2X3iMM235W
 SI7eAOmWF5MoWS2Rt+5uW9gJUH2ZiDgb+6L0vhkKBU6CYo9jNLuo2N/1rdIMr/ndviY6
 sJQYrI+Ov7qtG5rq2j+hNUTXdjtQX80VysPeZWD7ZpSEuZsiqgdXIbyDQ0Tdt0O1S8f+
 XBgjmD6RVwsdo7Kdb3dyhOjiMvD9eYVgf9KUr7nnwNmKPa+jUz4vifJTqro0wXqxm4zo
 vVyYewqnu3eaeoI90ANLZa4qS8vK46JKLfs1Hnetdxu4bdiAl2AogNgBrE0XrZ2THhN+ aw== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com (PPS) with ESMTPS id 3h2kcrh7w1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 05 Jul 2022 03:50:15 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Tue, 5 Jul
 2022 03:50:13 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Tue, 5 Jul 2022 03:50:13 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id DF9C73F70EA;
        Tue,  5 Jul 2022 03:50:08 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [PATCH 12/12] octeontx2-af: Enable Exact match flag in kex profile
Date:   Tue, 5 Jul 2022 16:19:23 +0530
Message-ID: <20220705104923.2113935-13-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220705104923.2113935-1-rkannoth@marvell.com>
References: <20220705104923.2113935-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: cjYcNNoqLZA8Qv4R_fck5MzqX1U16S6J
X-Proofpoint-ORIG-GUID: cjYcNNoqLZA8Qv4R_fck5MzqX1U16S6J
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-05_08,2022-06-28_01,2022-06-22_01
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Enabled EXACT match flag in Kex default profile. Since
there is no space in key, NPC_PARSE_NIBBLE_ERRCODE
is removed

Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Change-Id: I77a1d8ea19d935aab93579823254b432bf63e7a8
---
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index 4180376fa676..a820bad3abb2 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -155,7 +155,7 @@
 
 /* Rx parse key extract nibble enable */
 #define NPC_PARSE_NIBBLE_INTF_RX	(NPC_PARSE_NIBBLE_CHAN | \
-					 NPC_PARSE_NIBBLE_ERRCODE | \
+					 NPC_PARSE_NIBBLE_L2L3_BCAST | \
 					 NPC_PARSE_NIBBLE_LA_LTYPE | \
 					 NPC_PARSE_NIBBLE_LB_LTYPE | \
 					 NPC_PARSE_NIBBLE_LC_LTYPE | \
@@ -15123,7 +15123,8 @@ static struct npc_mcam_kex npc_mkex_default = {
 	.kpu_version = NPC_KPU_PROFILE_VER,
 	.keyx_cfg = {
 		/* nibble: LA..LE (ltype only) + Error code + Channel */
-		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | NPC_PARSE_NIBBLE_INTF_RX,
+		[NIX_INTF_RX] = ((u64)NPC_MCAM_KEY_X2 << 32) | NPC_PARSE_NIBBLE_INTF_RX |
+						(u64)NPC_EXACT_NIBBLE_HIT,
 		/* nibble: LA..LE (ltype only) */
 		[NIX_INTF_TX] = ((u64)NPC_MCAM_KEY_X2 << 32) | NPC_PARSE_NIBBLE_INTF_TX,
 	},
-- 
2.25.1


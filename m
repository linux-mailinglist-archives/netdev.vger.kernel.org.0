Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C65D756996A
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 06:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbiGGErL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 00:47:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234946AbiGGEqR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 00:46:17 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7516431219;
        Wed,  6 Jul 2022 21:45:42 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2674cuWs020719;
        Wed, 6 Jul 2022 21:45:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=QuNfcQhY+JPBowd3H/lN1VuqQOCw4DFZgGxLjGNGm9E=;
 b=XVeMxA1f8UEtnmtimvYPBD2wg8pmyBaHQL/OS9beq7jXl3OGgzaNCaUiTesj1KxaBD8C
 WQKFA2bmrHqgkjS9x9e9NG6p1YLAOIkZM3JlwJgPd+aASJ0SN3i3JwAAmYzAct//NUbu
 KxSLUslyzhGYiBm29xohjUS2QIBFVCfKzhcU/HCrANUJxqIxu7uOqqpzye3E9YH49b8R
 6TlGI0K8MK0yRfUNwAeMyEbrt3QT0EZSCKCEa9eD9OQiAuN4jG7vu9cobTfDXhPAUufP
 A6gv0H4tHPBjGufLeXAk/7FkuREhwqPvTcc7IOJzoT+o2YNgxIop3qg5z3PJHVRdLUy2 FQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h56wt48gy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 06 Jul 2022 21:45:37 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.18; Wed, 6 Jul
 2022 21:45:35 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.18 via Frontend
 Transport; Wed, 6 Jul 2022 21:45:35 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id C11AC3F706D;
        Wed,  6 Jul 2022 21:45:32 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [PATCH V2 12/12] octeontx2-af: Enable Exact match flag in kex profile
Date:   Thu, 7 Jul 2022 10:14:04 +0530
Message-ID: <20220707044404.2723378-13-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220707044404.2723378-1-rkannoth@marvell.com>
References: <20220707044404.2723378-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-ORIG-GUID: fH_v8WsNi-YaPxCQYYLGSjlo42HuJoeB
X-Proofpoint-GUID: fH_v8WsNi-YaPxCQYYLGSjlo42HuJoeB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-07_02,2022-06-28_01,2022-06-22_01
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


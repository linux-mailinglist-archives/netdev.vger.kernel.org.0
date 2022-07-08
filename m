Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5759856B1A3
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 06:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237284AbiGHEdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jul 2022 00:33:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237215AbiGHEcR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jul 2022 00:32:17 -0400
Received: from mx0b-0016f401.pphosted.com (mx0b-0016f401.pphosted.com [67.231.156.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E43B2A40B;
        Thu,  7 Jul 2022 21:32:14 -0700 (PDT)
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 26849rtt010914;
        Thu, 7 Jul 2022 21:31:57 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=QuNfcQhY+JPBowd3H/lN1VuqQOCw4DFZgGxLjGNGm9E=;
 b=KzUW09X1AuolrUmElqR+3EkyfHI/bBF/fEkdT2LW1njlsOYO5mz5x8XBNoyPL/MHwI8K
 16zoS6oaftz08mlTgFsS8O/8vOxYIwNDIoP+GsckwIQ5gYgbaxe6fJSDKc+ig1sNO2Yu
 hcimz3dagFiSWXH+rWBO9wwL02FoovLFMb2ksl1HFAgXpK6aZA/PZgk5GkuEqx0eiu5a
 GJ5Qbl+3a5xJT9q0lBXjxWKHOU2rt7NcPA/72iXywthlsOAI1eGlZ15sMXf+PWkr/6O6
 5KeqS9G9GQuLF/45aWcHz2CFCIe4Gqp0FdKrn9hDzZRw6c+OaOwH4u+pX/hby2aTofmo iA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com (PPS) with ESMTPS id 3h635w2c4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Jul 2022 21:31:57 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 7 Jul
 2022 21:31:55 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 7 Jul 2022 21:31:55 -0700
Received: from IPBU-BLR-SERVER1.marvell.com (IPBU-BLR-SERVER1.marvell.com [10.28.8.41])
        by maili.marvell.com (Postfix) with ESMTP id D78E53F7074;
        Thu,  7 Jul 2022 21:31:52 -0700 (PDT)
From:   Ratheesh Kannoth <rkannoth@marvell.com>
To:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC:     <sgoutham@marvell.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        Ratheesh Kannoth <rkannoth@marvell.com>
Subject: [net-next PATCH v4 12/12] octeontx2-af: Enable Exact match flag in kex profile
Date:   Fri, 8 Jul 2022 10:01:00 +0530
Message-ID: <20220708043100.2971020-13-rkannoth@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220708043100.2971020-1-rkannoth@marvell.com>
References: <20220708043100.2971020-1-rkannoth@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-GUID: rbFQ6i4zjJAu-xQuqjwhPzHnedUvOU8r
X-Proofpoint-ORIG-GUID: rbFQ6i4zjJAu-xQuqjwhPzHnedUvOU8r
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-07-08_02,2022-06-28_01,2022-06-22_01
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


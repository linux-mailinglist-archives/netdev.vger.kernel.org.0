Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A74F4DB8DB
	for <lists+netdev@lfdr.de>; Wed, 16 Mar 2022 20:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241540AbiCPT0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 15:26:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241391AbiCPT0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 15:26:36 -0400
Received: from EUR01-VE1-obe.outbound.protection.outlook.com (mail-eopbgr140127.outbound.protection.outlook.com [40.107.14.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9C96D3AB;
        Wed, 16 Mar 2022 12:25:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6KykUUOeRV5Bjzvr7cFGmm+5lUA6byG3E+/CVmaSKAvhjj2DuXNHHQ1frMZQKY8Gv+kk5ETU9ClqEYxVqnECBg9T5zVNEJbMjaY91FXcRWSJ2ltDDNG3jWKCMPXp82Xov4ZCyBQZrOJzlm6cLH767s/Xb6rpbRhU5+AekPiCx7+Yhy/tvfbqblyqQ+f5OqLn4E/QpAMcjLKU0izTj/l7wGlpax/FPGXUpEQU0D244byl7OHBQkXP65q369ke/UuizYcqU1SbAIOdLBqXJZNr36ht/SjBVA9qS0fw70dCoCKTQ0SGu1dN7/+6SZR9fFv3pLHGlhKwvvr062bchuIcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EADwajGJsULJdDoLFAxdbsPsbszPc0YvOcEalN1wOUc=;
 b=lKZFncJC9gJtn2L9D4xKRlibr2BjK/rJ4y9lhhyFgQWLEcEwRX8Mk8umIttmps7A4Vjkx+5EyQpT60sQ6c8IhrQAedRFCJW5325k5IYqpji/javTFqU6EZrxM2YQand2/PC63sdLOIL5ZDR51T5werG7KLR5TKS+wE9FbtFz2t/8VGvn1cyQwRsM56cULP/5IERZIiYZdmmf08nCd5DJ39S2otTXUc5bCG3/YEnjm5HkZ0ZVUecFpyBskACx6F+K6HcVJs0C/DJNY8XQh2OQbOQ5Wvzy5rbsCi0jzQWEO8Sjen73x/wo2VD1NGBS+nX92L+yyVoLy3bko7dFeSIxGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom-usa.com; dmarc=pass action=none
 header.from=silicom-usa.com; dkim=pass header.d=silicom-usa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EADwajGJsULJdDoLFAxdbsPsbszPc0YvOcEalN1wOUc=;
 b=t/dNk/hXyLdGvw1TxiQaiqBR2HxFz3iWAHM8viPOYMjcY/oxBu5WknQsJvAbi4+epNMlsq2nXTcWqvrlOpghaH9cWaqqI7+LZVQNXXa8CDjKzK04LWxKrFPTFG72xWihtIC0uOWZig+r51K/m2G74J+3aC7O/1vSiIsqsqUsS4w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silicom-usa.com;
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com (2603:10a6:803:b::16)
 by AM0PR0402MB3860.eurprd04.prod.outlook.com (2603:10a6:208:7::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5081.15; Wed, 16 Mar
 2022 19:25:18 +0000
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::3c4b:12e1:8c6b:dbb5]) by VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::3c4b:12e1:8c6b:dbb5%6]) with mapi id 15.20.5081.015; Wed, 16 Mar 2022
 19:25:18 +0000
From:   Jeff Daly <jeffd@silicom-usa.com>
To:     intel-wired-lan@lists.osuosl.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] ixgbe: Manual AN-37 for troublesome link partners for X550 SFI
Date:   Wed, 16 Mar 2022 15:24:58 -0400
Message-Id: <20220316192458.9847-1-jeffd@silicom-usa.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0115.namprd02.prod.outlook.com
 (2603:10b6:208:35::20) To VI1PR0402MB3517.eurprd04.prod.outlook.com
 (2603:10a6:803:b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 88393ebb-7e5c-46e9-3418-08da0782b484
X-MS-TrafficTypeDiagnostic: AM0PR0402MB3860:EE_
X-Microsoft-Antispam-PRVS: <AM0PR0402MB38608B7D92A62C4B4B304326EA119@AM0PR0402MB3860.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gc0NMiuWXRwRJJG7nlEPC0tZ+59n1yk2o7WklJfR4wWtKgHdENs4SXr7ftLaWvkKJx6bpzfnM7ho8b43Fy+jxc6bbjHNPhhBeSpMTdU8bu6CloIHjWrmuDoKsetdfh/lyI1tkmNF7lh0gVV5dySN6vWGbCSWXtCM+QCawWZ0zQvWiROLVLGFJWNCLmRmO8sj03n3oiqG/m21A9luLoSc+xWJuy5gCR/MFnDnGVFkN9iRBOjMp6SVi1Y7Vr1nRW2wJF6fxLZXcn1enFgpLPTTuq2KjJAFFRXOqXK2cvfZuaz75fwdlGlaXSxnhnhT2mAXNbJG3C7L4jwaPFNYGeQwubzQBCazuq+3jkDBXci6aBANT5kFU5lQ/nAo3Zv9cpNU3gAEbqiXDbNBAtDrSqsL/XYezBi6FOy0wpnGvgFfc6BT65RKjMLM9f7pxnzXd6gdlns1IMhtB11nOzbWVSW9i4OVDxWicGtUTJOJ3898X5kEx/LUdyTw1hZyzUh5SIDmdj4wUG6mdqJhb4nKMfrYqCObV3bau924hKxvEcDpcTzlqNR/d29DU3rM52c84tQcDXtHDcw5lum4MWjSTMIgUk/uhzLBVrps29W6jabgk7YOtoOto2sGuQ5awiwllGbRL+a8AyCwyb8oTKI/ErWoRMCW6c0IrzHcjIiu9vS6OW/tH8N+JnXV9FYC0XCSGguonku7KuwCs4PW6fVd7tbPbw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3517.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66476007)(66556008)(66946007)(6666004)(86362001)(6486002)(186003)(1076003)(5660300002)(26005)(508600001)(8676002)(38350700002)(38100700002)(8936002)(6916009)(36756003)(6506007)(52116002)(316002)(54906003)(2616005)(2906002)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KvxuEYot8TxrNmWiB4H+PKGjgbefDNCWO0D9hP/Nd/3ifuFkYc68jHktqHOw?=
 =?us-ascii?Q?KMV5vSQ4oD1Jji/Knb1AeKt3eGg7kwpzClUYd42YPMOBuLAVbuTzqL0mTFqD?=
 =?us-ascii?Q?Wvvux624OrIjylu5Tu6lZB+QoSom50q6QdGfnYC2QaOPexYKanodeQpgNV0H?=
 =?us-ascii?Q?jgEah9nqG8JEivmbPJ3BFXdhgriT7D7lB+izm9lqJsCJuRuEgzNgIUwnmTdB?=
 =?us-ascii?Q?qkNFSQ/tlgbKcADTyt6rUUIE9pQ1gVMkcW0tjpmHafCbHF46YBvE91LMgLW5?=
 =?us-ascii?Q?g6t2RtV/iODsMO0iQ7JutHyvjArkWUO4pm7nkx2knhDfG0quaZz5R1i4FzcO?=
 =?us-ascii?Q?8KS2dVng5WznSePRSwM5U5y67BmgZfR+T44elywWMEcw0J61IqGx0iO3NxfP?=
 =?us-ascii?Q?yYkVgyFrcx0EgKyIeILToIQeSQq+cRsyIsC/hm+ww5XtCaNi6XPMIu5JRY4Q?=
 =?us-ascii?Q?pst5JuAdMmpIlirzwo7Z0/1qCO9u3iSaBrWIPz72YDVKwf1h5KiIoMAMcfLz?=
 =?us-ascii?Q?eZOTJlSSecbWYvhNIWRR0ky26kuii4H4+2s9B31QUk2y7w/9ZbZhmg9BmWy2?=
 =?us-ascii?Q?XmOyWFK7bZVxRzdDvv1Og1v13gxwcx5IWGJyRDFdAdzc2/148A2SPFVlPoLZ?=
 =?us-ascii?Q?sZaJDXgIeslwpig2RVU5GAOx3AnJ/ffa6v+gqRXwbEZpoPLSPJzT1gUrPdc6?=
 =?us-ascii?Q?TGtNUun4DtJXfHXXNuF2IuI8TvVGHg5hGXbhqeqR3AIKAyud8XNAO2UbPqDP?=
 =?us-ascii?Q?BlN7Rr9M1TRZxPplzaGDDanQ16elPQH8KohVu1DsXQ2yGeCLORy/vQzKTPWh?=
 =?us-ascii?Q?ztdp2FHs3s5xEUGJ2yLMl55eLu8tcejqggGhQraBOH80dNPi8N/jPlMRE7ye?=
 =?us-ascii?Q?N3+TuxIpKKkQzYdprZ0kZ1ezWX7PD9Wlfwt+WeBiVVZSkSG/fK5ldjuQL6dO?=
 =?us-ascii?Q?vwzlSn8zMU3+Z0AcreSSg/6afwYwXolbiud207cd754slHNhMFt7tDY8zxyr?=
 =?us-ascii?Q?5+/FUaZcSpp7H4qriitiCuSUf7c4xgwz3SzRM35EA4KWvYpWmX5ZvTSwp9xX?=
 =?us-ascii?Q?SUjZX39XnHkyqHzfdBoNz/rxaJ0OEUsHbF6ZjNFXXQpwT5gnT62/KJwP+Su0?=
 =?us-ascii?Q?bXi5RfjOgh9/6oYQ+i1VcyNMDep60HTjXwTynLEL3Y2hG5V+zfowa104HBDE?=
 =?us-ascii?Q?tA1byGFDb7QL7arWWanC+g9faM9twN6VT2Mb6//cVsp9/lUIIcDsKzMYSOJu?=
 =?us-ascii?Q?Gxpqd9tOawiw9N9SKaQdL8oGagwsGG4Pi7u0Dz/AMZxEBFOy/HuXxStLIjTF?=
 =?us-ascii?Q?QfrhLXT5aVH3r26XC1k3kM1L5VskOVrAOhzvtvXfBUczrB9IDENKBJ10DVWt?=
 =?us-ascii?Q?cD2dlZetQ/k5nR4Av8VLx63v0Lt3H6XDjgsN3ICP1dEQb2e0xr6eCR3xCDLy?=
 =?us-ascii?Q?qhdtK51bBT+I9QzWI1CPORhzQ3U9pv5w?=
X-OriginatorOrg: silicom-usa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88393ebb-7e5c-46e9-3418-08da0782b484
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3517.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2022 19:25:18.3614
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Hg4HiHwDZDI29p4gs66hAtAawSjf0Al5zW20sQ/gLmI2m2K1kO7PsM25Y/mQenRCKxAaNCOj50l3IH0C70pDHg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0402MB3860
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some (Juniper MX5) SFP link partners exhibit a disinclination to
autonegotiate with X550 configured in SFI mode.  This patch enables
a manual AN-37 restart to work around the problem.

Signed-off-by: Jeff Daly <jeffd@silicom-usa.com>
---
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  3 ++
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 50 +++++++++++++++++++
 2 files changed, 53 insertions(+)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
index 2647937f7f4d..dc8a259fda5f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_type.h
@@ -3705,7 +3705,9 @@ struct ixgbe_info {
 #define IXGBE_KRM_LINK_S1(P)		((P) ? 0x8200 : 0x4200)
 #define IXGBE_KRM_LINK_CTRL_1(P)	((P) ? 0x820C : 0x420C)
 #define IXGBE_KRM_AN_CNTL_1(P)		((P) ? 0x822C : 0x422C)
+#define IXGBE_KRM_AN_CNTL_4(P)		((P) ? 0x8238 : 0x4238)
 #define IXGBE_KRM_AN_CNTL_8(P)		((P) ? 0x8248 : 0x4248)
+#define IXGBE_KRM_PCS_KX_AN(P)		((P) ? 0x9918 : 0x5918)
 #define IXGBE_KRM_SGMII_CTRL(P)		((P) ? 0x82A0 : 0x42A0)
 #define IXGBE_KRM_LP_BASE_PAGE_HIGH(P)	((P) ? 0x836C : 0x436C)
 #define IXGBE_KRM_DSP_TXFFE_STATE_4(P)	((P) ? 0x8634 : 0x4634)
@@ -3715,6 +3717,7 @@ struct ixgbe_info {
 #define IXGBE_KRM_PMD_FLX_MASK_ST20(P)	((P) ? 0x9054 : 0x5054)
 #define IXGBE_KRM_TX_COEFF_CTRL_1(P)	((P) ? 0x9520 : 0x5520)
 #define IXGBE_KRM_RX_ANA_CTL(P)		((P) ? 0x9A00 : 0x5A00)
+#define IXGBE_KRM_FLX_TMRS_CTRL_ST31(P)	((P) ? 0x9180 : 0x5180)
 
 #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_DA		~(0x3 << 20)
 #define IXGBE_KRM_PMD_FLX_MASK_ST20_SFI_10G_SR		BIT(20)
diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
index e4b50c7781ff..f48a422ae83f 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -1725,6 +1725,56 @@ static s32 ixgbe_setup_sfi_x550a(struct ixgbe_hw *hw, ixgbe_link_speed *speed)
 				IXGBE_KRM_PMD_FLX_MASK_ST20(hw->bus.lan_id),
 				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
 
+	/* change mode enforcement rules to hybrid */
+	status = mac->ops.read_iosf_sb_reg(hw,
+				IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x0400;
+
+	status = mac->ops.write_iosf_sb_reg(hw,
+				IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* manually control the config */
+	status = mac->ops.read_iosf_sb_reg(hw,
+				IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x20002240;
+
+	status = mac->ops.write_iosf_sb_reg(hw,
+				IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* move the AN base page values */
+	status = mac->ops.read_iosf_sb_reg(hw,
+				IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x1;
+
+	status = mac->ops.write_iosf_sb_reg(hw,
+				IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* set the AN37 over CB mode */
+	status = mac->ops.read_iosf_sb_reg(hw,
+				IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x20000000;
+
+	status = mac->ops.write_iosf_sb_reg(hw,
+				IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* restart AN manually */
+	status = mac->ops.read_iosf_sb_reg(hw,
+				IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= IXGBE_KRM_LINK_CTRL_1_TETH_AN_RESTART;
+
+	status = mac->ops.write_iosf_sb_reg(hw,
+				IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
 	/* Toggle port SW reset by AN reset. */
 	status = ixgbe_restart_an_internal_phy_x550em(hw);
 
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18E2057CCEF
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 16:11:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229985AbiGUOLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 10:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiGUOL2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 10:11:28 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70113.outbound.protection.outlook.com [40.107.7.113])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A9A5481E1;
        Thu, 21 Jul 2022 07:11:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LFf5ZPwgQ2eqvb7phNY54iPBtPs3QvVV7CzWTGWiRZJWB3+NjZeI7wHmHJe1tIinGg4RGr4OCwfvskpDn9Pf3IyEQVd9G24r0lYKp7+oX1tXx+AhKwoTrlgaC7zESmBXnDhjOQPFUjeflMMGRguTOzN3Ghxb/6N29730yUOLVFUDqn5krSRIXF0bFCPdIz4/uuUZv5Z8bdO/TbNpLIrvq3gSvivl0XhpkuVlhhjz1GEFWbm8S9Br+YyzwwP1sWTvNgoQdost3m8brSR7dcLiVMAAXd0hEGCeKFif7rGG2T/UQ9UWhqHnB2oFirc164V+WY8LQJFfM1tJfhzskVe6uw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/1tsxSbgGZIY+t4W9LMlKeN8qqN80NnnnRC4h1eTGug=;
 b=eSpy1x7yhZWd90RVZ6dJQqYlsS3GMjMbF1zwW+Sffb/dIgd6+3LoiUq9+BV1OxhNwewISidJzRZuK/caS55CMbC/pjieN+AKfoNyeP51YVm176AA6qhLjRsw5YfvqGSEDJ9/aEw4o4GG7uY15DawOO26Q878TZxg1cBHnYzTqfhYmbh/KatitPoYFDDSdefmE2U0hKhW4LSwSKVDx1aNd8+Gs/HBoReB9tVG3ZUYCPLa5mbpo03x8/JC/R30bmliE0oBnsIYktTsAjSNe8VYFiHNQAgWO18c/hysKA4jWWn/bqqwIMPWt1spYeY6UVZO2QDv2DKvz7d0ct+OCHPEiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silicom-usa.com; dmarc=pass action=none
 header.from=silicom-usa.com; dkim=pass header.d=silicom-usa.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=SILICOMLTD.onmicrosoft.com; s=selector2-SILICOMLTD-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1tsxSbgGZIY+t4W9LMlKeN8qqN80NnnnRC4h1eTGug=;
 b=mGyRs8x/L5YF3MNKYwG3SDvGuVhnm/LyRf+6BXpEZvmlkXI3OWnAwg9vKajXnbZF48tWV2j9UJoF5LR4Ue5S3HsCxjzpvntO97IU4cU19pJj2t7R5pt0dTRLNMV96slLmYZ+GFJzJSw0MyZIwfxNkZRSz1u0UW2Py5In+17sgxE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silicom-usa.com;
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com (2603:10a6:803:b::16)
 by VI1PR0402MB2879.eurprd04.prod.outlook.com (2603:10a6:800:b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.18; Thu, 21 Jul
 2022 14:11:24 +0000
Received: from VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::d00f:d6d0:6a7e:4d12]) by VI1PR0402MB3517.eurprd04.prod.outlook.com
 ([fe80::d00f:d6d0:6a7e:4d12%4]) with mapi id 15.20.5438.023; Thu, 21 Jul 2022
 14:11:23 +0000
From:   Jeff Daly <jeffd@silicom-usa.com>
To:     intel-wired-lan@osuosl.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] ixgbe: Manual AN-37 for troublesome link partners for X550 SFI
Date:   Thu, 21 Jul 2022 10:10:30 -0400
Message-Id: <20220721141104.4898-1-jeffd@silicom-usa.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR02CA0011.namprd02.prod.outlook.com
 (2603:10b6:207:3c::24) To VI1PR0402MB3517.eurprd04.prod.outlook.com
 (2603:10a6:803:b::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 32dbf040-e561-40de-1f42-08da6b22e4b2
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2879:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0wxdlEEgYf6wAOyIwpcnLllyUTewOtmRKrBmv/exqkrLD1NLBI+WYKTQxVNiMFwG+ZWvxqWd8FY0Jf8SC3MTvBmpJvdgnRAF2GxW4dzflKsa6pxwUxiyLbqM2+7m/2Ed+b68NiiFFz5Jum62uIaX4d4MdZgPxbVwbyTyrHkwBccFwB+9WWGiTCLSlJtfNUM6Bksk20TLqLUcPXRmAVtHcD/qiljwiiQidaXVIHl4OxWhKjIQ2BKATQLW6cOvr/Vh3DMe0IHy6ZHutwWqvwMuoNFlkU9zsEYjYnz1aIKa9C+wGv1gvcKQZHJ3rvXOZ2KDdyI8x9lgnC3UtDIgAKgVLO+Bqmn78EFSy1WYpxzLIUqmqJqzVD/xrzyvUwscQnTaWLqg6KSZIGb9w/7/lDp1nUkeQqusKWpZC4XVNym8ByUav4LYXiYkAmuoJoL7y66k9DvM1UbhYxMaHTSzCFoaZKu32ciNvsNAz+51ALUw3RVUo0mLzu+aTItnPOy0l2e2H5lm5IRZ5VGcP4QHTtGWtiOcdTEEaxoCEvyR+nDFUT82oWzxzMGGJL2WinyoRboruEAzPBc0MMxDa1yKxAONTyQia1zwwWSpAplVJUgNRiW/yffwFW586y0Dzvc/k6gXFFE7sz7HfwgKa3WE1RtRM8EPUwGIor/13nzQrz066HmV4XDYJgy0pe+1pdN6VO6TMzJioIhOiZ2PsUTOeR0zVpKXivzCiOBrxMuBYcBBAIDwHvqH5aadOhLRpERYJMGLlNbkiRgiK5oo4l//XC3KwXzYhIdX00Txktu6ecUB+NA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3517.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(346002)(136003)(366004)(39850400004)(376002)(186003)(66556008)(1076003)(83380400001)(2616005)(38100700002)(38350700002)(316002)(4326008)(66476007)(36756003)(6916009)(66946007)(54906003)(8676002)(6506007)(52116002)(2906002)(41300700001)(8936002)(6486002)(5660300002)(6512007)(478600001)(6666004)(86362001)(26005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DpZXgOiERJZe66k7ttmIRX3mjHh72Us3ghXrVZtpC8hhaTDr1oJkYFzTles/?=
 =?us-ascii?Q?UahzyNfuUX7S/k4YowIJepNWOQkqBhpSZqhNOo2s+/jNJ2wMq21JeeHasbIi?=
 =?us-ascii?Q?GXsGo8/CAhaIFIuammcMyg0XfsYZXMyrzny5BHBweAHEjVnYeCstLX3vLaqd?=
 =?us-ascii?Q?CYkfNkExhQqJoTc3wZM0OLbdt4Mzrt++Q2UjMGEPoJnjHc0FExE4w2F4M4TI?=
 =?us-ascii?Q?P8qI6+MV0Y7ZvZsyd1hZXaDuLR+72CVCt7CoaJi+zzghLgRfvUoVer+2mMcY?=
 =?us-ascii?Q?32+DUMWJGEqKOWY+qm3xaCbgWngJ61SC4w2UQbU6LyvQaK+Iz1Tkr2t659JS?=
 =?us-ascii?Q?EAAYvKkbrCt5HRI2a/uCxqCOdy2//2bPzgvLsuvOOKXHnpXK8uubG20G7GmX?=
 =?us-ascii?Q?mKFHaGVf4ZQxjDIkgdvR0w0bsVBAsh8bk/jhoD+W1OhYZiET0IC7l+70JyT9?=
 =?us-ascii?Q?bAW/jSF6GNGLpOvtCMiJozq0Ba2YTIg6qe2U+o/mVziRV6MWxIkeSy/V9ZOB?=
 =?us-ascii?Q?2LPdQ/fhG7GSK4xHE403QRO/k5f8iTjbDxsdARTIQLf9u6Z+2Nt0oQf7VyGi?=
 =?us-ascii?Q?z9uhpQ5IEcQY0HYeR/vCs//B57jFxGMm1b461ESZzYMccpngi7BzqcCAa/Ql?=
 =?us-ascii?Q?Z4h0GcrHdK6kjsHRTxUnn77esCaO+TJy/ryiTHBopyfuB4yuaMRu4ZsS5wrU?=
 =?us-ascii?Q?NBMSvhcbNqvrCTUxz5DoFhGCNobj2o7qPrALBLrakuWoGZi9z+a+vwwA2Y34?=
 =?us-ascii?Q?+3ozvIqvu2JDDUTHgBErkAh8cYkZjWafNxb/SAJXMsyPLHSbxWx+kQ92cUcL?=
 =?us-ascii?Q?/nTxg1ZOV0ts1DQVZFwov4PqyaDxRpAPHmsBKLTJXMcptnS4VeEZLzh6o/Mw?=
 =?us-ascii?Q?gS1IWkVPUumsUtnlpAAyZ97n+Jn5I52UeAG5SEUbOAtqCfdR3q7FZ19kbI49?=
 =?us-ascii?Q?vJIFBOyYfgp7WwRv1wpB+PZ0NjdbIztWK4PdJLOV/5zeUcWx5l/mso4qX+EO?=
 =?us-ascii?Q?qER4PDbTxZptR2qnHtF+l1RqWLVSB2qgqCNwZ2yiYI+oYj42S1mQSooomw6H?=
 =?us-ascii?Q?y4DvofFnMdYSleXWYNSiFpfz88A0u+/ij+tPPFa80er1Pm7zR707BPvmW7KJ?=
 =?us-ascii?Q?dyZlyRnJmKE3a3YbX0dUXyf1wdiwyH2m4uiCIoq0PLNRQqKBgWKAOGzRWSnE?=
 =?us-ascii?Q?1igP1k42LK4C4s3sYBPcUdBsox+UVmtgd5g1ZfCfVAiAwyANw6M3FW8yxSXP?=
 =?us-ascii?Q?KfeQxDeZCev86KPSRVCAlxKvrjGbqbSqD0gcINYska9cSV1PHesT1NYO1Lc8?=
 =?us-ascii?Q?9WKi5lqQvetxRDIYC7JCsiWypVt1T7RW2QB5P2MzzP7YElC3Yh7jQPUXh2N6?=
 =?us-ascii?Q?Q84Qb1++VslBMfhhtPNdu5Esq7HeWebVgqaD/YGpSrP6kdGAuNjuOax3kZY3?=
 =?us-ascii?Q?uWhC94rA5jTDI3DZIAr9Fkjac8tJZ9izlohPeTr+nqRgQaDi2uEZj5lT1zmA?=
 =?us-ascii?Q?ARJDoYsprPz6mfKItI1WFHJ62iwnRdheWDO1YAyayxQ801eX+mqsMZd1pB7G?=
 =?us-ascii?Q?MSHTmPvfobrjuz/s4dANRExI2BNr9K61naIUBsNa?=
X-OriginatorOrg: silicom-usa.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32dbf040-e561-40de-1f42-08da6b22e4b2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3517.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jul 2022 14:11:23.8785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: c9e326d8-ce47-4930-8612-cc99d3c87ad1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LR32Qbq+5lSoA38uMztPTj3WuK0MD48ZTTP5jYeG3w+Mbg8yPY6flujQSgqQOCUIIbYfSm1jKGF7O76H26O5LA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2879
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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
 drivers/net/ethernet/intel/ixgbe/ixgbe_type.h |  3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c | 56 ++++++++++++++++++-
 2 files changed, 56 insertions(+), 3 deletions(-)

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
index e4b50c7781ff..427073757373 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_x550.c
@@ -1721,9 +1721,59 @@ static s32 ixgbe_setup_sfi_x550a(struct ixgbe_hw *hw, ixgbe_link_speed *speed)
 		return IXGBE_ERR_LINK_SETUP;
 	}
 
-	status = mac->ops.write_iosf_sb_reg(hw,
-				IXGBE_KRM_PMD_FLX_MASK_ST20(hw->bus.lan_id),
-				IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_PMD_FLX_MASK_ST20(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* change mode enforcement rules to hybrid */
+	(void)mac->ops.read_iosf_sb_reg(hw,
+			IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x0400;
+
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_FLX_TMRS_CTRL_ST31(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* manually control the config */
+	(void)mac->ops.read_iosf_sb_reg(hw,
+			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x20002240;
+
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* move the AN base page values */
+	(void)mac->ops.read_iosf_sb_reg(hw,
+			IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x1;
+
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_PCS_KX_AN(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* set the AN37 over CB mode */
+	(void)mac->ops.read_iosf_sb_reg(hw,
+			IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= 0x20000000;
+
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_AN_CNTL_4(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
+
+	/* restart AN manually */
+	(void)mac->ops.read_iosf_sb_reg(hw,
+			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, &reg_val);
+	reg_val |= IXGBE_KRM_LINK_CTRL_1_TETH_AN_RESTART;
+
+	(void)mac->ops.write_iosf_sb_reg(hw,
+			IXGBE_KRM_LINK_CTRL_1(hw->bus.lan_id),
+			IXGBE_SB_IOSF_TARGET_KR_PHY, reg_val);
 
 	/* Toggle port SW reset by AN reset. */
 	status = ixgbe_restart_an_internal_phy_x550em(hw);
-- 
2.25.1


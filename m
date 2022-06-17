Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575C854FEC3
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380282AbiFQUfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356225AbiFQUeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:15 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAA4E5D5EB;
        Fri, 17 Jun 2022 13:33:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Tf3CT2LnzQXLFx+jJMmCP58GtrLUYGxYX3zATrYEX1sGHPDn0WFyjYQbUYobBEDDIbbGOxkeOowYAlrdVdDd4LCvm63ommpv2SUmqy7UCiDetH5lh+FVh8gT194evfR+qMVAKnzeSBIhn5n+N8H0bDHxwFYBwLZRIyoHWbARK4HjDOKwv8naS466bIlnznqfuhYTu6EfrUAwuoN/VBYblwUhAcDVhB9UPD7cxeuewlIjr0fs4q0CYoVwu3DaWTAUpBwbZul7i+0hbJb3B8+OqNdcPpBUvCwMqr99A7+GRu4ySFzbkpm4PCcjTDcmm8mFVIkzPPr/AVM3MWWr1PnV0w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d+y16VQC1oW/rdss5dl3TAPZohiMfyoZswy9Xv/m09Q=;
 b=Cwb41M+tce6FoQ34OR+Ni588l1lKs+g16pVmmWV03M4HWbuVoyB+t5pOPQ6bRr0mipAbIm5iFTtXpeM/NMwIruyx/DPDgis4+64w9NB+iGD6F3i4dbbS7GiqGUf0Vmnc+S4c0qSc9q6w8zFMW97qEPIbkn9Q7JAOh1em1SIrfLp1kgsPEX64LChGll8BJI1egLdxPFaMVMA5omVqu6Jzim7MQZF7mGI4mJmhvkxZFmq/0S5lKxvlYbnbjRCS4+BxWJ629FVPBNRcxK6I/6XFzv7Vx2fDmYrRczSjgfbFhtU7ZmANVpWJ3h3UpNnj/Tsf5dKSW11DClTbXOFH4trnXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+y16VQC1oW/rdss5dl3TAPZohiMfyoZswy9Xv/m09Q=;
 b=le+aPe0CG0/xF3atici8ab+hPFKTjTCqd+3sOwOxV8cMhtRWj9dcS+xMd3uV36Vrd91qthNM19mA0h8UN3jLVwI2WyIiEPavip6gGGT5uIqpS6n5YJbHAd8/hebyEqGxPPsxfiH0y1HH05EBC6+Q1pW/3tDxzvEUxxMwTSFF76jp9HOMnwx6fiNLJy68DMy8ckI2B35nRDcl03ankd1vHDxQ8YuxCUwDQRjYXKY7l2zBbUFQJs53EC/s7cLjESq9a9OcMwXoxGA/bMTL9AcQuYcL/1X8PTl1wmVGbf1h6DBGZy71io0mfTitv733gyasrX8HaR2Bumj7uFV9AdDPow==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:53 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:53 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 09/28] net: fman: Store initialization function in match data
Date:   Fri, 17 Jun 2022 16:32:53 -0400
Message-Id: <20220617203312.3799646-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220617203312.3799646-1-sean.anderson@seco.com>
References: <20220617203312.3799646-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0384.namprd13.prod.outlook.com
 (2603:10b6:208:2c0::29) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b0906e91-5fcd-447b-1231-08da50a0b16e
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB643886F3D7A34AF0944E11EC96AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZpuNVrQMROfBBfdlzypehIFXxx3lH1CVdStaxPCjtGvSWZAZ516rnj0Rtop9tYPf9aoEE1jGEqTtpglszOrUbUGsR6SYwDmC3yJ7JN04cr/I03w9VpeRCzdZaNem9t516Trq9ekyHsJr9xmUBNmcrPzjrW4/pBiPPUWXFmf65tzxpNyJC7Aq7ob3AdvG1RcRnN+0tY9Nc74bwKnih9ep9fR0Sw4+TMQsovj7tc4iGYK+BYjG2A5STCfJ/Jr5a0f+G7Tnj6U5wt/sFhP3j61U9zpUYLQmXeUHgH+kolsW2zoTg0TarqyR8S+YZ02+zsY2Rmbqbxlz2arFcMBGE71yA0VnBGWjxEdlu/F1qdjKCvzDk4L4irJQckIht3CfXVW/vil07sLCdPnTm7BpIM6RV5lcCqmoA20kyfh0wZhpoACxxpx4mnSWrRs9MRLPAwj6b0FLmqTYTl4MyMuwT3K7BbMSI6+Fry3PmdKnYPePAjde+nFK0irjjgg4u0RLg+/apL+46M3JCTY0lP3+ASwgrSVvQMOhvbIB5MDFIXPHfe4WSYVQkCqPhrKbwGkKgutguOsRtvlDVnb4VnI6/f17hg4uMx/aYIM+sLb8NV7P0PfF/C0ZI8kQh6JzwNjUX1YwpB7BjDjLPSjNSHJ7k5EjuubSPLKtY+os55/iR7ZYvXLLJYzQ42hpXBJ7MCpLDMp4kcbSTtxRpKhFQgFdjtZtlQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(54906003)(498600001)(8936002)(110136005)(6486002)(52116002)(2906002)(6506007)(4326008)(26005)(83380400001)(66476007)(66556008)(8676002)(316002)(1076003)(36756003)(30864003)(66946007)(38100700002)(107886003)(38350700002)(44832011)(86362001)(2616005)(5660300002)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zxP/GWQSLPsNt/WIxXJ6KU0DZXKSkOj3Izyk1NeEb7Kq49dWEnM/CqT2XJLV?=
 =?us-ascii?Q?P2236AMxnhIE3lRvna1fLyYwFW/bmnpbaJLQFV3Hdzr63UZV0CNA0+87FngP?=
 =?us-ascii?Q?RId2bKeQhFsGVTni6TMkynrAoftVqhhUjMHGuggfeog2YeoYtwEtCZgujjpb?=
 =?us-ascii?Q?QWfj9HKNIz2LzMCOaxH+VND/ORjMx/FB+Bl6WO+3e/PlWzVmhB8/Pw5pQegI?=
 =?us-ascii?Q?LxeEN7H0G2CVtXgmic2n29ANaGHUCOAiutJYHlJgk/qhJqDS/gFf1QCvfL2/?=
 =?us-ascii?Q?c3e87gaTBYiW/9+WgUr6d9MZVLDZdz5I/frUIXsDTX1/1lh1R7CSniYe8VXQ?=
 =?us-ascii?Q?kYN71KtD/OGl0rx6btknbF74pFrNxQDZ+S7AVx7XiFi+mMS4riiO26iUkqB2?=
 =?us-ascii?Q?YG+PvlvoTxWFdrv0XGYSxx1I04nDy7pY1qzko8gzNiQTDt7t/Jf+8D4dBexj?=
 =?us-ascii?Q?JOlBi1XTJwSXwKVrJ+Q7ICrSAS1GPnu9gaL15YupdC3X2N1CHnyXEmmeXa0s?=
 =?us-ascii?Q?KLfYoD0ypVUoJSxxnNSD3yjJbD0Pyhl7DVMW34PkFGjCho8Hb2BifCTV+tsW?=
 =?us-ascii?Q?oHnSjrJZmVB1lxMNVGNNDUi1xhWTbVCAfqhOh3trnSaQ9ycPBKOoR8DtNiwr?=
 =?us-ascii?Q?jZ7mYcCAgktvuWGp3qBJwyCfB5YQ5skYiXVHdfIV2V7aRpuiE4B2eSc8W9Vj?=
 =?us-ascii?Q?3mWGpLgqr/TDWW4ONCh6VvurRXkDLHB1i+9o7Fxar5bWO77LX0J4n59Mmj4V?=
 =?us-ascii?Q?M6Fc+KvG4Uf7cTq+qfxlEAgGi7qZVNhNcbnPnjgRug2jAcLDdP3OIhfAE16+?=
 =?us-ascii?Q?rR5qDWh/lJ2IoF8ch+WmBFlqJqOsxtiNNkz9l7yxbCTNCdkDmelSc9zeS3Qt?=
 =?us-ascii?Q?fsCpnDtWXinc6PEFP6rvc/4aw3srta1BM2unG4i1r3qb4cVExUYw2PDuRdSf?=
 =?us-ascii?Q?7+oId04SdiwyU75hoVlBPq5GRcLoxREkd+JAdapr+wIgcnYKjAHym/zPLpHP?=
 =?us-ascii?Q?V+QSJT21P4NsxkinHNFAKAbRp1uM6HOJCo1zIZlfX2hOLX+46T6TIUvV6v45?=
 =?us-ascii?Q?v1IQnhxNeJTFdEsGPhxiVyDWlFblJyFRHeQKpya3STdFABf/s+XZDA5oJAt8?=
 =?us-ascii?Q?tj2NG+mR+frKeFWk+QEIBp5JuzbBQ82ldVqWFlyEJx0ytAknq3Im5PGIMzg9?=
 =?us-ascii?Q?69lTSFidOg72fkAIl+B4eQX129tPMPEnaPuqTrn44B9rxqqC1NiQK0ExHIkG?=
 =?us-ascii?Q?CjxuCwvV4MXAst5aoIUnCWtLczmr0S8hYYuXOdOpPC/IXBH94h2hNEVZ17Io?=
 =?us-ascii?Q?GeYXLkFQLFz1SHasRmzhKcQSNvggZ5+E9lCbYCRw9ACxiQp+s59JnUZnnm+a?=
 =?us-ascii?Q?eTkuCNQz3ryGvwDgG78++Ys65wqcBHSss1iG6V4nlUGvMRAoRkFgljATNG5a?=
 =?us-ascii?Q?K+Z4eKdIQtgqGmCinxWyAqJ2L8Zie67mK3gKK780/7H3drlcJ1ZMILDFvC/6?=
 =?us-ascii?Q?QcYIEluLd5mBqEtM6lAXx4t9L8ceSo2aWip0mULYZD4PtzGOQx2fOU5vMZvJ?=
 =?us-ascii?Q?TBdjDUzwivbMSVO1/5zDQkVky6YlAASzVaMPzVajC4xzf4Vi4038MFSLqhDB?=
 =?us-ascii?Q?4pydlSsVuofo6QOb63Nu9klzqxIez6+5vHpgXSTMHaxYcJlecPaV59CvDHqL?=
 =?us-ascii?Q?gRJdqCr0le0fycuxCSySTtwWAmeD99DAAWhiLfGI/Z5aqfdNwWBG2+qdnDrM?=
 =?us-ascii?Q?APCHaCLqbQOfu85BO+W2onT2OgINgzg=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b0906e91-5fcd-447b-1231-08da50a0b16e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:53.0460
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ihEAMcUx5FeVfqdWP9TrIZHyCTegKGisKc17ZKCkEb41f7e7mRWSEjzNvsLXVhoLgIQqohSEVdZrx/B/rtim6w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6438
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Instead of re-matching the compatible string in order to determine the
init function, just store it in the match data. This also move the setting
of the rest of the functions into init as well. To ensure everything
compiles correctly, we move them to the bottom of the file.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/freescale/fman/mac.c | 356 ++++++++++------------
 drivers/net/ethernet/freescale/fman/mac.h |   1 -
 2 files changed, 165 insertions(+), 192 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 0af6f6c49284..8dd6a5b12922 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -88,159 +88,6 @@ static int set_fman_mac_params(struct mac_device *mac_dev,
 	return 0;
 }
 
-static int tgec_initialization(struct mac_device *mac_dev,
-			       struct device_node *mac_node)
-{
-	int err;
-	struct mac_priv_s	*priv;
-	struct fman_mac_params	params;
-	u32			version;
-
-	priv = mac_dev->priv;
-
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-
-	mac_dev->fman_mac = tgec_config(&params);
-	if (!mac_dev->fman_mac) {
-		err = -EINVAL;
-		goto _return;
-	}
-
-	err = tgec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = tgec_init(mac_dev->fman_mac);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	/* For 10G MAC, disable Tx ECC exception */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_10G_TX_ECC_ER, false);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = tgec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(priv->dev, "FMan XGEC version: 0x%08x\n", version);
-
-	goto _return;
-
-_return_fm_mac_free:
-	tgec_free(mac_dev->fman_mac);
-
-_return:
-	return err;
-}
-
-static int dtsec_initialization(struct mac_device *mac_dev,
-				struct device_node *mac_node)
-{
-	int			err;
-	struct mac_priv_s	*priv;
-	struct fman_mac_params	params;
-	u32			version;
-
-	priv = mac_dev->priv;
-
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
-
-	mac_dev->fman_mac = dtsec_config(&params);
-	if (!mac_dev->fman_mac) {
-		err = -EINVAL;
-		goto _return;
-	}
-
-	err = dtsec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_cfg_pad_and_crc(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_init(mac_dev->fman_mac);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	/* For 1G MAC, disable by default the MIB counters overflow interrupt */
-	err = mac_dev->set_exception(mac_dev->fman_mac,
-				     FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = dtsec_get_version(mac_dev->fman_mac, &version);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(priv->dev, "FMan dTSEC version: 0x%08x\n", version);
-
-	goto _return;
-
-_return_fm_mac_free:
-	dtsec_free(mac_dev->fman_mac);
-
-_return:
-	return err;
-}
-
-static int memac_initialization(struct mac_device *mac_dev,
-				struct device_node *mac_node)
-{
-	int			 err;
-	struct mac_priv_s	*priv;
-	struct fman_mac_params	 params;
-
-	priv = mac_dev->priv;
-
-	err = set_fman_mac_params(mac_dev, &params);
-	if (err)
-		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
-
-	if (priv->max_speed == SPEED_10000)
-		params.phy_if = PHY_INTERFACE_MODE_XGMII;
-
-	mac_dev->fman_mac = memac_config(&params);
-	if (!mac_dev->fman_mac) {
-		err = -EINVAL;
-		goto _return;
-	}
-
-	err = memac_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = memac_cfg_reset_on_init(mac_dev->fman_mac, true);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = memac_cfg_fixed_link(mac_dev->fman_mac, priv->fixed_link);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	err = memac_init(mac_dev->fman_mac);
-	if (err < 0)
-		goto _return_fm_mac_free;
-
-	dev_info(priv->dev, "FMan MEMAC\n");
-
-	goto _return;
-
-_return_fm_mac_free:
-	memac_free(mac_dev->fman_mac);
-
-_return:
-	return err;
-}
-
 static int set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
@@ -418,27 +265,15 @@ static void adjust_link_memac(struct mac_device *mac_dev)
 			err);
 }
 
-static void setup_dtsec(struct mac_device *mac_dev)
+static int tgec_initialization(struct mac_device *mac_dev,
+			       struct device_node *mac_node)
 {
-	mac_dev->init			= dtsec_initialization;
-	mac_dev->set_promisc		= dtsec_set_promiscuous;
-	mac_dev->change_addr		= dtsec_modify_mac_address;
-	mac_dev->add_hash_mac_addr	= dtsec_add_hash_mac_address;
-	mac_dev->remove_hash_mac_addr	= dtsec_del_hash_mac_address;
-	mac_dev->set_tx_pause		= dtsec_set_tx_pause_frames;
-	mac_dev->set_rx_pause		= dtsec_accept_rx_pause_frames;
-	mac_dev->set_exception		= dtsec_set_exception;
-	mac_dev->set_allmulti		= dtsec_set_allmulti;
-	mac_dev->set_tstamp		= dtsec_set_tstamp;
-	mac_dev->set_multi		= set_multi;
-	mac_dev->adjust_link            = adjust_link_dtsec;
-	mac_dev->enable			= dtsec_enable;
-	mac_dev->disable		= dtsec_disable;
-}
+	int err;
+	struct mac_priv_s	*priv;
+	struct fman_mac_params	params;
+	u32			version;
 
-static void setup_tgec(struct mac_device *mac_dev)
-{
-	mac_dev->init			= tgec_initialization;
+	priv = mac_dev->priv;
 	mac_dev->set_promisc		= tgec_set_promiscuous;
 	mac_dev->change_addr		= tgec_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= tgec_add_hash_mac_address;
@@ -452,11 +287,121 @@ static void setup_tgec(struct mac_device *mac_dev)
 	mac_dev->adjust_link            = adjust_link_void;
 	mac_dev->enable			= tgec_enable;
 	mac_dev->disable		= tgec_disable;
+
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
+
+	mac_dev->fman_mac = tgec_config(&params);
+	if (!mac_dev->fman_mac) {
+		err = -EINVAL;
+		goto _return;
+	}
+
+	err = tgec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = tgec_init(mac_dev->fman_mac);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	/* For 10G MAC, disable Tx ECC exception */
+	err = mac_dev->set_exception(mac_dev->fman_mac,
+				     FM_MAC_EX_10G_TX_ECC_ER, false);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = tgec_get_version(mac_dev->fman_mac, &version);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	dev_info(priv->dev, "FMan XGEC version: 0x%08x\n", version);
+
+	goto _return;
+
+_return_fm_mac_free:
+	tgec_free(mac_dev->fman_mac);
+
+_return:
+	return err;
+}
+
+static int dtsec_initialization(struct mac_device *mac_dev,
+				struct device_node *mac_node)
+{
+	int			err;
+	struct mac_priv_s	*priv;
+	struct fman_mac_params	params;
+	u32			version;
+
+	priv = mac_dev->priv;
+	mac_dev->set_promisc		= dtsec_set_promiscuous;
+	mac_dev->change_addr		= dtsec_modify_mac_address;
+	mac_dev->add_hash_mac_addr	= dtsec_add_hash_mac_address;
+	mac_dev->remove_hash_mac_addr	= dtsec_del_hash_mac_address;
+	mac_dev->set_tx_pause		= dtsec_set_tx_pause_frames;
+	mac_dev->set_rx_pause		= dtsec_accept_rx_pause_frames;
+	mac_dev->set_exception		= dtsec_set_exception;
+	mac_dev->set_allmulti		= dtsec_set_allmulti;
+	mac_dev->set_tstamp		= dtsec_set_tstamp;
+	mac_dev->set_multi		= set_multi;
+	mac_dev->adjust_link            = adjust_link_dtsec;
+	mac_dev->enable			= dtsec_enable;
+	mac_dev->disable		= dtsec_disable;
+
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
+
+	mac_dev->fman_mac = dtsec_config(&params);
+	if (!mac_dev->fman_mac) {
+		err = -EINVAL;
+		goto _return;
+	}
+
+	err = dtsec_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = dtsec_cfg_pad_and_crc(mac_dev->fman_mac, true);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = dtsec_init(mac_dev->fman_mac);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	/* For 1G MAC, disable by default the MIB counters overflow interrupt */
+	err = mac_dev->set_exception(mac_dev->fman_mac,
+				     FM_MAC_EX_1G_RX_MIB_CNT_OVFL, false);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = dtsec_get_version(mac_dev->fman_mac, &version);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	dev_info(priv->dev, "FMan dTSEC version: 0x%08x\n", version);
+
+	goto _return;
+
+_return_fm_mac_free:
+	dtsec_free(mac_dev->fman_mac);
+
+_return:
+	return err;
 }
 
-static void setup_memac(struct mac_device *mac_dev)
+static int memac_initialization(struct mac_device *mac_dev,
+				struct device_node *mac_node)
 {
-	mac_dev->init			= memac_initialization;
+	int			 err;
+	struct mac_priv_s	*priv;
+	struct fman_mac_params	 params;
+
+	priv = mac_dev->priv;
 	mac_dev->set_promisc		= memac_set_promiscuous;
 	mac_dev->change_addr		= memac_modify_mac_address;
 	mac_dev->add_hash_mac_addr	= memac_add_hash_mac_address;
@@ -470,6 +415,46 @@ static void setup_memac(struct mac_device *mac_dev)
 	mac_dev->adjust_link            = adjust_link_memac;
 	mac_dev->enable			= memac_enable;
 	mac_dev->disable		= memac_disable;
+
+	err = set_fman_mac_params(mac_dev, &params);
+	if (err)
+		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
+
+	if (priv->max_speed == SPEED_10000)
+		params.phy_if = PHY_INTERFACE_MODE_XGMII;
+
+	mac_dev->fman_mac = memac_config(&params);
+	if (!mac_dev->fman_mac) {
+		err = -EINVAL;
+		goto _return;
+	}
+
+	err = memac_cfg_max_frame_len(mac_dev->fman_mac, fman_get_max_frm());
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = memac_cfg_reset_on_init(mac_dev->fman_mac, true);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = memac_cfg_fixed_link(mac_dev->fman_mac, priv->fixed_link);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	err = memac_init(mac_dev->fman_mac);
+	if (err < 0)
+		goto _return_fm_mac_free;
+
+	dev_info(priv->dev, "FMan MEMAC\n");
+
+	goto _return;
+
+_return_fm_mac_free:
+	memac_free(mac_dev->fman_mac);
+
+_return:
+	return err;
 }
 
 #define DTSEC_SUPPORTED \
@@ -546,9 +531,9 @@ static struct platform_device *dpaa_eth_add_device(int fman_id,
 }
 
 static const struct of_device_id mac_match[] = {
-	{ .compatible	= "fsl,fman-dtsec" },
-	{ .compatible	= "fsl,fman-xgec" },
-	{ .compatible	= "fsl,fman-memac" },
+	{ .compatible	= "fsl,fman-dtsec", .data = dtsec_initialization },
+	{ .compatible	= "fsl,fman-xgec", .data = tgec_initialization },
+	{ .compatible	= "fsl,fman-memac", .data = memac_initialization },
 	{}
 };
 MODULE_DEVICE_TABLE(of, mac_match);
@@ -556,6 +541,7 @@ MODULE_DEVICE_TABLE(of, mac_match);
 static int mac_probe(struct platform_device *_of_dev)
 {
 	int			 err, i, nph;
+	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
 	struct device		*dev;
 	struct device_node	*mac_node, *dev_node;
 	struct mac_device	*mac_dev;
@@ -568,6 +554,7 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	dev = &_of_dev->dev;
 	mac_node = dev->of_node;
+	init = of_device_get_match_data(dev);
 
 	mac_dev = devm_kzalloc(dev, sizeof(*mac_dev), GFP_KERNEL);
 	if (!mac_dev) {
@@ -584,19 +571,6 @@ static int mac_probe(struct platform_device *_of_dev)
 	mac_dev->priv = priv;
 	priv->dev = dev;
 
-	if (of_device_is_compatible(mac_node, "fsl,fman-dtsec")) {
-		setup_dtsec(mac_dev);
-	} else if (of_device_is_compatible(mac_node, "fsl,fman-xgec")) {
-		setup_tgec(mac_dev);
-	} else if (of_device_is_compatible(mac_node, "fsl,fman-memac")) {
-		setup_memac(mac_dev);
-	} else {
-		dev_err(dev, "MAC node (%pOF) contains unsupported MAC\n",
-			mac_node);
-		err = -EINVAL;
-		goto _return;
-	}
-
 	INIT_LIST_HEAD(&priv->mc_addr_list);
 
 	/* Get the FM node */
@@ -782,7 +756,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		put_device(&phy->mdio.dev);
 	}
 
-	err = mac_dev->init(mac_dev, mac_node);
+	err = init(mac_dev, mac_node);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index e4329c7d5001..fed3835a8473 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -35,7 +35,6 @@ struct mac_device {
 	bool promisc;
 	bool allmulti;
 
-	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
 	int (*enable)(struct fman_mac *mac_dev);
 	int (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
-- 
2.35.1.1320.gc452695387.dirty


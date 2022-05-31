Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF13539774
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 22:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347601AbiEaT71 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 15:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347562AbiEaT7M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 15:59:12 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2052.outbound.protection.outlook.com [40.107.22.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D506007A;
        Tue, 31 May 2022 12:59:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KLizP/mgdmF//R/6jbvHGk0wijkguIHvfaLbNDapLORxb1SeEx+2a1ewTo7MzNU3LUj0xIH1Cu8ucU0KkAvH9/gVgDbn7aT0MSeCwDseNfjgeG37q6c15Aoslh7YZV0gUzXQMvC+/o3VC+j1gzeEMkxWQeyEpoVZly1w1YkhSKbN6hL1zRD71gSK6yd40GC8XeDv0Rk83f9eXulPCv89nvXozWrwsLsRMe7LunNYC/QcrenL0jVUBKnAhUY4qYi2L09ldDjOBOFSC7QZn/e8XjPMgFgrjJALZcGkbNvmEojbEeSo9mzuj9v/kCNasDzFs8NmD8C6jBMN10RgObBHZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0QpUpo+M6ccZxAbfYkoczcKnaaxNjmV9Xiyyaj4XMSE=;
 b=F2vjZNE34jPrx9ll4vgorW4dL4OesEKV6KASmsZVTTYcRIzsCyM09vL0nGvjQ/WVee/wuvlc/PzXNGK3/v61lKqEA23aG5SEpvb9t/HjyiOcg6S8Z3cIV1bekCRDmuIANmHoVIRZ+CwWIFHPTywdXj7aNfmK9+eLUP3wr1aNjPE2KSgq2SnxlMOEQOzl7+uviQqbBqeb6QYXECXkCwC3EZGg+GVs6JMcHQCjVNJRClNjz5zRQUoOccjPmAMtZaOJUY6Cx4C+ka2aMkiQtOj7uLB8DqZL7rbUoWV3TCqAuz97G9UXFBywBDQrEdp4WiEHhg9/ONqN7u+XJMwe1L+tQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0QpUpo+M6ccZxAbfYkoczcKnaaxNjmV9Xiyyaj4XMSE=;
 b=utsJcgvNumHBOgD7n2fh1AmEtpbenreHLOVLmHkm2jQK4ynM6hFd/8aGsjvQn0LUsYAfMHhRzxvYnw7ihXGQcLk3bgIBdSyvK14VvtXwJlpIRezJ3AKbTE4B9/ElY9mQK5N35e32ux/wxZAybXiRr9XaXEj5ZWhF50wzn28KHB7DpUuB5+Ca04W16+d94TLL1wvdfcp2386pH1fhSgxFUgbXO7MDFlZgfr0LLPNE2Y1k+2tWURF3YpUpCVeINj/8BgYDsEUfI4AhcUH3BKg9ADO83dk8x+oIbfdBCTAaYfh4sk08W0fUr2BfQaEhnyIeo10AEgys1m+aEQCMiLKlNw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PA4PR03MB7309.eurprd03.prod.outlook.com (2603:10a6:102:102::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5293.19; Tue, 31 May
 2022 19:59:05 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::c84e:a022:78f4:a3cf%6]) with mapi id 15.20.5293.019; Tue, 31 May 2022
 19:59:05 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH 3/4] net: fman: Store en/disable in mac_device instead of mac_priv_s
Date:   Tue, 31 May 2022 15:58:49 -0400
Message-Id: <20220531195851.1592220-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220531195851.1592220-1-sean.anderson@seco.com>
References: <20220531195851.1592220-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0113.namprd13.prod.outlook.com
 (2603:10b6:208:2b9::28) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cac81537-11e0-41b4-6b36-08da4340044f
X-MS-TrafficTypeDiagnostic: PA4PR03MB7309:EE_
X-Microsoft-Antispam-PRVS: <PA4PR03MB7309F9C5218FDB71D90C483E96DC9@PA4PR03MB7309.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6UHk7d0glcBFHcskx2rgGtJ22zwI33Ma4t1dZo0p5wE0/hJSjF52bxO6oTgVD0dbyQGZzyunVRB+bjj3KKPmF6v7fPJOIUYCoGh4uZRlR3sBgdlnIVe/0RM9m8TRNVJDUcS5AokpLz6tEPPF7/j2cf4lbZKjpijytBce0ucKLzcBIH2ZMoW+xyZi3rZeX8D0CM6OmEQrmF+5d0bL1dl4RPzNNfVGVFa6cbFzMsMvhwhp0HoJuRBr3ntWpY4Ce+nnwJ/23p3FVEHgaDRCqjyhhQwPEFwE7aZ/QTF4+WbE18jWwo1CkeHIdLeYMxxQf4gbsDSZSOJAj5kGXcdy7GpPz9M0eSE96L7jMgK3Fkts6ra7MJwDMAvMaNvC+NhfqsNYxH+mocli0DD1BIiZtVSZ7QlAbR2wG2Hiac4lEJH4deKKu5yJqZQtRlhSnoKljJFN1xJ5xC9ibfYabNUjhC3MTP3hzmHlscpxBLVc3n9FvpuOQWa5XoYxQcDlsT6iAaYi1Pt0m+Seh5O3KmAzhQKyqK+bgXjoxyoSKGifuHktaDvuTIRhJrFZAxLg83iZuUhEi2Pfa+iifmx+tP+PsuOxSHgtMQJ5S1TOr4B/LzLXaSy1xHsmtsOvJfIPSE7ZHn66ZfNC8QCmsvspZi+5rfRQhdx8ZlISAdeK/zi4UC1x2lrS2V3GVrxxMPsusaCtNy1ocCPMrjXEwcs/ZwgNyA8+6UMsFNzdzhmF/bNfK1KguBEtSIizNLmazqn7FZRS8H8b
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38100700002)(186003)(1076003)(107886003)(2616005)(38350700002)(110136005)(54906003)(36756003)(316002)(4326008)(8676002)(66476007)(66556008)(66946007)(83380400001)(8936002)(508600001)(6506007)(86362001)(6486002)(52116002)(44832011)(5660300002)(6512007)(26005)(6666004)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?dP6LdF5WNjlFHNft/QbmbtIr0JH8hOpB5psRDxRplRGO5H3x4vBVjubJMtZs?=
 =?us-ascii?Q?ItpuLn00dDz55bGUF7bJwzxehpCXpczX4DXKqBpzquwvRdjHRN+arDuXD09a?=
 =?us-ascii?Q?oSDb37MnHXyY16VKw6sWn8iA9TcqEnSzsKa72Iljdp2BvLLH2zK7oLL7xvO0?=
 =?us-ascii?Q?VpT5DyitzkizURUI53wLnCVMtjRzee9jhuewpqB1IbeS4qSEKCzzETSYd8t1?=
 =?us-ascii?Q?8v6wdvbtVi+BDLtY4A+ObLMrcXlTE5GYqadtB8mqeEij8q9M9EaDiT11Dt+Q?=
 =?us-ascii?Q?rCKKIb1r2Y8qjI9NI9PeU1DvvZHbPw+BZC6jRmb0/H//rhof23DA0KOVZu87?=
 =?us-ascii?Q?M4U07N8vPlp8SQTYO0xnD0EdnKNhwTBgW9iNuzTD8uYcPrvKHVWnUjp26wEg?=
 =?us-ascii?Q?+wTGgDKwYrVQ4gY5b+H7EqxvjH3NLQ/fNyQfsGZ43CepyxxvdaDMhEp5BJK1?=
 =?us-ascii?Q?A1U0kUKBmxK01SsV7+1/ahiZFMswy5owdh4cS7VDhlgjgV9PsUeAAFk/9Qdb?=
 =?us-ascii?Q?4s5u28yJN4CiH86kGSRiibK8f4Ly7uAxyQRVonrmwFaQJ7h4FwgatBDPSo8O?=
 =?us-ascii?Q?PU4mvEcpKVVmDnHKjHcSudzPxfY+ecfBRDeUY27Gy0XtDbs/1dB9uLEH3Sse?=
 =?us-ascii?Q?K+jfIby7Ags48y9DKr1XD1kUFpjx+35EOP9ere4jIcnIFC1AYlE1OSSXHtrd?=
 =?us-ascii?Q?ldu/XQjPVB+36EjdvQB6yZCo7YZ9h11aarfyIPqT5r7VfBRVBYAo3/BevWdl?=
 =?us-ascii?Q?axO6qTKnSaPb71LZWMf4Km85uBH2ysULnthuLo2iNlDqkOxDpBW4HrHd396I?=
 =?us-ascii?Q?B1f8jv5ujfG51I0Xiv0Wj/TnhSWHsDfFqfNqDWe9ezcyLtZWDRjUZw34egv3?=
 =?us-ascii?Q?iywN+mpqMPxDDjLvFLX9IcPaGJzs+IGSVojmRWzLXXrghlteBUINhu7BziC3?=
 =?us-ascii?Q?+hUEyscWOWkBuP8KU1jvPX4gKoL6QMEGGYnKVMi1JaImvnqZwMYUajCKsOWx?=
 =?us-ascii?Q?12xaGn4nNi2CdcHAt/AiBND2NesbqsIE46AU/IMIAwuxyEBtepvDiaGIm0CI?=
 =?us-ascii?Q?XRJWKd3Nrvz7QccMtIaq8pcbuwlcAaAdWuH40D2wpq5fa2LmEDbUAIeXkLB8?=
 =?us-ascii?Q?G3AbupmJGsUtqjcDpE9mcLiubSXXkF3ICEkgQb2aGhid4o59s8k8Da8JmN/+?=
 =?us-ascii?Q?4FBjexM9fB6qD5kpkMpB5cru+FQtEDBommpBxyTgOxdzH0eNuNVzytNTC9Bl?=
 =?us-ascii?Q?YfFufwkUT9hrOMaplMygVyCJrFWaONZYAYaahkCKE0ifCCozohRVNvPCHUYQ?=
 =?us-ascii?Q?1MEzY1yoGjKvVMu7lwydq0CZA8OGLgT5JZrX1ICqJ1skAI/LNPXnRvyxhVdv?=
 =?us-ascii?Q?FMd2nMzFRDJ9KSFz9e370tClRQ9wbeKIHiC77nCmachvhxtx5gBHy++ut5Se?=
 =?us-ascii?Q?vPmo3eZGuzg01BaORDdWbgUTJn1PA6na2C3G4svMkS7JTpeinfqUxyc2xHgJ?=
 =?us-ascii?Q?0FqXYGTp49ePjp8eJ2Vjl2+5LEIfQXcS6g+6rbg9y7WVixSuaV0cNJbVJBWw?=
 =?us-ascii?Q?3ax06dlyoM6reF4JKXYlCgzqdiYN3SLFefQRBxZq7nMcCBOqljWuS1Npx6Cn?=
 =?us-ascii?Q?78sdZwUsHASNCSNIw3H7h41TwIHdjm31YuMA7wCIF5yupiAzkU00IUWWJ4I8?=
 =?us-ascii?Q?gEk57yasVLJtfIREMF1idn59RB9py1D1ubUVDeoz7SxoXZY6DJnPvJq+trXd?=
 =?us-ascii?Q?w56bw/l9YPbyb+VGullJ3O6enVAruhQ=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac81537-11e0-41b4-6b36-08da4340044f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 May 2022 19:59:05.7034
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HWDiU0GO6031SZqRNbfScuxGO7UL8MeZLQv9BLIbeAQUrK866QxW+bwVoPXIkBVMKDSgmYg3FfklykpFCmWK3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR03MB7309
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All macs use the same start/stop functions. The actual mac-specific code
lives in enable/disable. Move these functions to an appropriate struct,
and inline the phy enable/disable calls to the caller of start/stop.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 .../net/ethernet/freescale/dpaa/dpaa_eth.c    | 11 +++--
 drivers/net/ethernet/freescale/fman/mac.c     | 44 +++----------------
 drivers/net/ethernet/freescale/fman/mac.h     |  4 +-
 3 files changed, 15 insertions(+), 44 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
index 906d392da4e3..fe2572b492b2 100644
--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -288,9 +288,11 @@ static int dpaa_stop(struct net_device *net_dev)
 	 */
 	msleep(200);
 
-	err = mac_dev->stop(mac_dev);
+	if (mac_dev->phy_dev)
+		phy_stop(mac_dev->phy_dev);
+	err = mac_dev->disable(mac_dev->fman_mac);
 	if (err < 0)
-		netif_err(priv, ifdown, net_dev, "mac_dev->stop() = %d\n",
+		netif_err(priv, ifdown, net_dev, "mac_dev->disable() = %d\n",
 			  err);
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -2942,11 +2944,12 @@ static int dpaa_open(struct net_device *net_dev)
 			goto mac_start_failed;
 	}
 
-	err = priv->mac_dev->start(mac_dev);
+	err = priv->mac_dev->enable(mac_dev->fman_mac);
 	if (err < 0) {
-		netif_err(priv, ifup, net_dev, "mac_dev->start() = %d\n", err);
+		netif_err(priv, ifup, net_dev, "mac_dev->enable() = %d\n", err);
 		goto mac_start_failed;
 	}
+	phy_start(priv->mac_dev->phy_dev);
 
 	netif_tx_start_all_queues(net_dev);
 
diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index a8d521760ffc..6a4eaca83700 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -39,9 +39,6 @@ struct mac_priv_s {
 	struct fixed_phy_status		*fixed_link;
 	u16				speed;
 	u16				max_speed;
-
-	int (*enable)(struct fman_mac *mac_dev);
-	int (*disable)(struct fman_mac *mac_dev);
 };
 
 struct mac_address {
@@ -241,29 +238,6 @@ static int memac_initialization(struct mac_device *mac_dev)
 	return err;
 }
 
-static int start(struct mac_device *mac_dev)
-{
-	int	 err;
-	struct phy_device *phy_dev = mac_dev->phy_dev;
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	err = priv->enable(mac_dev->fman_mac);
-	if (!err && phy_dev)
-		phy_start(phy_dev);
-
-	return err;
-}
-
-static int stop(struct mac_device *mac_dev)
-{
-	struct mac_priv_s *priv = mac_dev->priv;
-
-	if (mac_dev->phy_dev)
-		phy_stop(mac_dev->phy_dev);
-
-	return priv->disable(mac_dev->fman_mac);
-}
-
 static int set_multi(struct net_device *net_dev, struct mac_device *mac_dev)
 {
 	struct mac_priv_s	*priv;
@@ -454,11 +428,9 @@ static void setup_dtsec(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= dtsec_set_allmulti;
 	mac_dev->set_tstamp		= dtsec_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_dtsec;
-	mac_dev->priv->enable		= dtsec_enable;
-	mac_dev->priv->disable		= dtsec_disable;
+	mac_dev->enable			= dtsec_enable;
+	mac_dev->disable		= dtsec_disable;
 }
 
 static void setup_tgec(struct mac_device *mac_dev)
@@ -474,11 +446,9 @@ static void setup_tgec(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= tgec_set_allmulti;
 	mac_dev->set_tstamp		= tgec_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_void;
-	mac_dev->priv->enable		= tgec_enable;
-	mac_dev->priv->disable		= tgec_disable;
+	mac_dev->enable			= tgec_enable;
+	mac_dev->disable		= tgec_disable;
 }
 
 static void setup_memac(struct mac_device *mac_dev)
@@ -494,11 +464,9 @@ static void setup_memac(struct mac_device *mac_dev)
 	mac_dev->set_allmulti		= memac_set_allmulti;
 	mac_dev->set_tstamp		= memac_set_tstamp;
 	mac_dev->set_multi		= set_multi;
-	mac_dev->start			= start;
-	mac_dev->stop			= stop;
 	mac_dev->adjust_link            = adjust_link_memac;
-	mac_dev->priv->enable		= memac_enable;
-	mac_dev->priv->disable		= memac_disable;
+	mac_dev->enable			= memac_enable;
+	mac_dev->disable		= memac_disable;
 }
 
 #define DTSEC_SUPPORTED \
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 1ea5fd32f689..4c9fdfab8813 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -36,8 +36,8 @@ struct mac_device {
 	bool allmulti;
 
 	int (*init)(struct mac_device *mac_dev);
-	int (*start)(struct mac_device *mac_dev);
-	int (*stop)(struct mac_device *mac_dev);
+	int (*enable)(struct fman_mac *mac_dev);
+	int (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
 	int (*set_promisc)(struct fman_mac *mac_dev, bool enable);
 	int (*change_addr)(struct fman_mac *mac_dev, enet_addr_t *enet_addr);
-- 
2.35.1.1320.gc452695387.dirty


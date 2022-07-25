Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50D0C58013F
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235835AbiGYPLe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:11:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiGYPLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:24 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10078.outbound.protection.outlook.com [40.107.1.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF53E186D8;
        Mon, 25 Jul 2022 08:11:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+cc+5touLdySxcvtChoZBAhuY3ng7ygoLVxlZX7qCUxt4JxQczP6ndJ2fPaYUqbWj2Q+CNtdSPOaxZVhnOws9+O2Y8RpEHwrAjXRcLdIIv8lQaVseVUy4bLNcr6Gv9dAV8h2gkCaOQQq0GVKSVGQuSPUKquvWKcxnfYhn/rZNt+OhPq5JZGMojyJZTztgcPPKkE+4T3OLLY/3kn1SuHAV7nHzIJE+o6jYCdZGOoiS0GKNmhMfsryVUBPaev5sAf1qai1NLbcko1AZi5f6aDyz4T32ow6lCkP46bladpQGHzvsOlHNvZBuBpJHQfMe8akOhxlcCGXCJ8Kwg9Mp8+/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ikmed1H2u8yYjG0yC0+OW7IBD8A+JO361DVKp96y2Wc=;
 b=kzLxkwANXSNc9UqAt6wKtu0qjYn0uCfAlfBs8qqclN/FLwWiMGbWpavsJm6tk76U+vKZhQDYSSkG8F8cUv7Iy1KYD0BJDjg+q5Hvqlgs4RYxgx9qAc+ZwKIAzBd5b47BLJUxskw6P9BIIw/RVA7AE9NvZsvQl2uXcSYJ33GBu0i9vjN0QG47/Vue0Y6uopsJNc/BPoAvyaWe8y8jE4keuOM7rXHOxhA+oFpxGdFgcukGj1LlUsXVdJ6xC3c6fYKcUr57fz8b5g3IIurKjgrdj0pPVfw0fvH9HrQGC1VKcSBey6OSJliLws+ehmBOeyHcAG7lBO92R5slFd4v3OsPMg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ikmed1H2u8yYjG0yC0+OW7IBD8A+JO361DVKp96y2Wc=;
 b=t00mocFGigi/57JjMos3c1KWGryevoBiH0cyMviwc23aarStlgWxtZHlbl0j+qUvywUAON6iyZFl/g+g06RRMFpOmIHQAJUYrBonV71Jp032e1mLWQ/+AWugVY7IwgMM12LGRUv93BTiWwLDYkk9KeoW4J8d2WNVJcI6v+zcTaBTiBI/GtQqCGlOW68v4X70h7dWtLJt8EQXZK2wspnXYQ3mkRC/KOUbLFLneWW1D53HavaGsEHjU63Z3SQbrrHSz2G0vRdr35SKDFNPOSpL6YfzjnvknKb1+NRptJ2Sn4LdB7dueDnKwP+EtNR0uVLQUr6DiRHiBvM6+BG9lxxi+A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:11:08 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:08 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH v4 06/25] net: fman: Get PCS node in per-mac init
Date:   Mon, 25 Jul 2022 11:10:20 -0400
Message-Id: <20220725151039.2581576-7-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a3370923-7b06-4d83-ca8e-08da6e4fe738
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LWx/yidFVIFN6HvhXRjE/La+pkrYg+qv307Wp5sQh571RHi8QMDuK/Cn7eUkfmE94Vo0nX3EmeuLHJ4dvCvlCQSzOCpzhTGNOCssAUbcRlKsPUYNfTcAAPr1795vSeiuZW+vLd+F1woF/QyHcus+xSNKb2e+fZ2RMlmZIDZiLx59SHXoMAXNcRb8XvAC33QSN4X8inBP94SYkK2nYLaSWvqLxRt+/xaWRFIn7Xuf/tbfHvfmEEDNk9p5vYa45KHko6UoE+mAsVuFuJ6qMEMwA06aXS+A/iuImz1KwXZFxWd/X9gN65KsjqgcHJDRf2mRHeZifs/1gWdhhVShbiMQT68ymayMCsqYdPSqUGHW3bQWZsoLo89VTsLd9IPwfeUC82iSKyg1t2a714X7+dC7IxR3hHWDPTNlYEwtD+FZCJhPR4ku3S/odLlLsqG7xo6YPvJY2/fw7AuiHapp+Fdz4Kjx6PJCBr43RGL+fUuKV0RdZ9+1urCtMuJaFNDU5l8QuiZNamPWs+DO/6KmhC527MM212vMYgBeNeQzgbyGiM8KZnozC+u1bS82yIEg/t9MKatzpNUL3UqiTVge1rzBU1QKs38YRNZTLM96q/+7i/2U9CYmEq6UfWyq2HBpq9sEXbupilgmeVQTFQmDstDrIbmy5Z0XpXQdxh9muFjaGTzY7ItBgQ4+7uUVXMVC/lgJhLxxXVPzPxb4ENlJlKmOijUqbG6Z6omYrCgAMFVGQmq+eV32Bjl/GWfPRRSQqjGIC8nv6UKLjhIakOxKkBkaVrn21Btz4jfpmbg7j31FzsQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(107886003)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Gwr52nhdGDyg+8DpQAoRrbCQWb+UqRXwTP9EFaQNCQOdDfrgsEJKzgS0dqJF?=
 =?us-ascii?Q?6GmjAxPVM3q30CnJ+x47kPAAEV26yAiq7UVZobOaeHxkKLHYuTDkpCt3IYPN?=
 =?us-ascii?Q?7kvnoqVzcrI8tYCcPx1rxn0cTjdj44bVfN9pqHui1BxSmfdEwvaPr5PNZFKU?=
 =?us-ascii?Q?Ap6mHQ1GI337MqQsAZXgd1fBvYJDWQHrhL/vKLeCWnYqrLdWwgHXvShF1dqb?=
 =?us-ascii?Q?eK3dqbqFg7yRAZqwIjBW61d+Yik7mJW52UYV0owS1YcvEEpBxegzLZAP73pq?=
 =?us-ascii?Q?J9bia0LtBJqnPuVoY8BvBVaWQQPJkL9eK5oGjXyA3nMAHggC3KmIVEFi0UYE?=
 =?us-ascii?Q?MjKiz8hiy06U9JdsjQylpPL+mqu1J0/a6uJrHFonB8z1BzOmBjOgJhQdj3w0?=
 =?us-ascii?Q?4W99HDc8p/oCvzRz/DfQCceE2NeCLRuXnYHgkOQAFNmKEODDZh4pkKNPEnQ9?=
 =?us-ascii?Q?q4wLuZX7S4DKmXzHsj0/DaUBFC2ASw7s/oWHPpwvyE0AsmDapV804qwn+a6U?=
 =?us-ascii?Q?c9LcEcggoc23YS7HOvoJoR48EMlbIzS6f2HyOhLrbozUT68+IASWrJMJvSIW?=
 =?us-ascii?Q?mgOhitf8UMSAZc9vvVINqobFo8raAvwKQ0LIgl/n10nX9wq7XGVrMFLaIfU7?=
 =?us-ascii?Q?Ey0rfuNZzlG2XHFhYiF0OxKZLJFUCjjHN8WjLVGmfxpWfXKgJ3IbVjhwDhLw?=
 =?us-ascii?Q?A3U/l2YtnnGPCh5mKMGwTtu0nHVPp/5MWuFoxqRMMuqCvF+ny2cS2X1ljc3z?=
 =?us-ascii?Q?p2xKlBFc9m3TkJhrqT08pgffVwPXLTStY9+n70YuC3ggbjcmB89Nt1CEaueZ?=
 =?us-ascii?Q?VKk8vSKzTNs6X599mYD+Kwwo854PGp2xKZAdWfHOJCCxXTaNeuvfFO2SA8g6?=
 =?us-ascii?Q?+34uAZT8KGJK1f0H2sKxSBpr63grmaqz9aFr1mOnp10nnOrpEc+HLZxHEluK?=
 =?us-ascii?Q?Ux80Ld/VntXvtiGoaNIGKoXJxWxwXhp5AbGbp/cOfQCY3dizd417B2/QKobH?=
 =?us-ascii?Q?wuhm2OPh6D93+RBxUskQtkT9fdju10BIr41oOwEQZr9qeh9371gPsG5+qZib?=
 =?us-ascii?Q?mH93BwBOQewZDSgUEDNwg6X1TAYtQeRgKJWBwv7VTIg9ta6lsXFPZwwXf06/?=
 =?us-ascii?Q?KZsli0Qcjx8Ax17e5z2VK/alg+sJ5KZkoZ+Ftfmzlna/qeKgBqUQam1NQZPS?=
 =?us-ascii?Q?1jxPOwn/RHY8peBH7iGixNOphoxCNnAw+fiIPdcpGwoFNz93gzJv8bs4dHZZ?=
 =?us-ascii?Q?QB62GzMKQHP1tiBP28ygw6f6cd4YNkUVUJNG66zPcHLzSE234gKuE9EQTmU5?=
 =?us-ascii?Q?dz5bdRF47sDXZoPHp62bp0dC6PDcxMnSD2pU/G6N+lfBeZV/gyf28nqeruN4?=
 =?us-ascii?Q?ZA1U2QGfDrAQFX0E+uxwqnhqlHIDznEuzJ+ekhcIpPnP77Blqhh9Q2GskFOI?=
 =?us-ascii?Q?OC1Kqbx6YuNqlYqLKUEp27AtANEgpx/qpSfWXXLBt5nvGczv7J2BhxdkvEao?=
 =?us-ascii?Q?tdgtWT7gx2t7v0OGSHvs7ow3j6V/Eft0NSU99vbCnvzdhOm1/12Y/aOkTOKS?=
 =?us-ascii?Q?8S7O/0y9o2F7l4jXQQuS5sckam/pcmyRRn2Hq58JEGbOIG5KDeQ43mzemr+k?=
 =?us-ascii?Q?0Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3370923-7b06-4d83-ca8e-08da6e4fe738
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:08.8170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KMRogFKW0J3At9gztaTZv/10aDsJ2Zg8WzCn89m5O/cCt4kuHqE5Zihy4kQQ6u3k4UJTIQdeOQelvhbq9DmkwA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7817
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This moves the reading of the PCS property out of the generic probe and
into the mac-specific initialization function. This reduces the
mac-specific jobs done in the top-level probe function.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 19 +++++++++----------
 drivers/net/ethernet/freescale/fman/mac.h |  2 +-
 2 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 6a4eaca83700..0af6f6c49284 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -32,7 +32,6 @@ struct mac_priv_s {
 	void __iomem			*vaddr;
 	u8				cell_index;
 	struct fman			*fman;
-	struct device_node		*internal_phy_node;
 	/* List of multicast addresses */
 	struct list_head		mc_addr_list;
 	struct platform_device		*eth_dev;
@@ -85,12 +84,12 @@ static int set_fman_mac_params(struct mac_device *mac_dev,
 	params->exception_cb	= mac_exception;
 	params->event_cb	= mac_exception;
 	params->dev_id		= mac_dev;
-	params->internal_phy_node = priv->internal_phy_node;
 
 	return 0;
 }
 
-static int tgec_initialization(struct mac_device *mac_dev)
+static int tgec_initialization(struct mac_device *mac_dev,
+			       struct device_node *mac_node)
 {
 	int err;
 	struct mac_priv_s	*priv;
@@ -138,7 +137,8 @@ static int tgec_initialization(struct mac_device *mac_dev)
 	return err;
 }
 
-static int dtsec_initialization(struct mac_device *mac_dev)
+static int dtsec_initialization(struct mac_device *mac_dev,
+				struct device_node *mac_node)
 {
 	int			err;
 	struct mac_priv_s	*priv;
@@ -150,6 +150,7 @@ static int dtsec_initialization(struct mac_device *mac_dev)
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
 
 	mac_dev->fman_mac = dtsec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -190,7 +191,8 @@ static int dtsec_initialization(struct mac_device *mac_dev)
 	return err;
 }
 
-static int memac_initialization(struct mac_device *mac_dev)
+static int memac_initialization(struct mac_device *mac_dev,
+				struct device_node *mac_node)
 {
 	int			 err;
 	struct mac_priv_s	*priv;
@@ -201,6 +203,7 @@ static int memac_initialization(struct mac_device *mac_dev)
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
+	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
 	if (priv->max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
@@ -583,14 +586,10 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	if (of_device_is_compatible(mac_node, "fsl,fman-dtsec")) {
 		setup_dtsec(mac_dev);
-		priv->internal_phy_node = of_parse_phandle(mac_node,
-							  "tbi-handle", 0);
 	} else if (of_device_is_compatible(mac_node, "fsl,fman-xgec")) {
 		setup_tgec(mac_dev);
 	} else if (of_device_is_compatible(mac_node, "fsl,fman-memac")) {
 		setup_memac(mac_dev);
-		priv->internal_phy_node = of_parse_phandle(mac_node,
-							  "pcsphy-handle", 0);
 	} else {
 		dev_err(dev, "MAC node (%pOF) contains unsupported MAC\n",
 			mac_node);
@@ -783,7 +782,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		put_device(&phy->mdio.dev);
 	}
 
-	err = mac_dev->init(mac_dev);
+	err = mac_dev->init(mac_dev, mac_node);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
diff --git a/drivers/net/ethernet/freescale/fman/mac.h b/drivers/net/ethernet/freescale/fman/mac.h
index 95f67b4efb61..e4329c7d5001 100644
--- a/drivers/net/ethernet/freescale/fman/mac.h
+++ b/drivers/net/ethernet/freescale/fman/mac.h
@@ -35,7 +35,7 @@ struct mac_device {
 	bool promisc;
 	bool allmulti;
 
-	int (*init)(struct mac_device *mac_dev);
+	int (*init)(struct mac_device *mac_dev, struct device_node *mac_node);
 	int (*enable)(struct fman_mac *mac_dev);
 	int (*disable)(struct fman_mac *mac_dev);
 	void (*adjust_link)(struct mac_device *mac_dev);
-- 
2.35.1.1320.gc452695387.dirty


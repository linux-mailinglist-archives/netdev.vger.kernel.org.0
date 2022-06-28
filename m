Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E64155F14E
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbiF1WPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiF1WO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:57 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA0539156;
        Tue, 28 Jun 2022 15:14:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yi+ykHFxrukPHtKu6XbzCxIPx3G/6JEP2W63RE2DA+UubfuM5wJ4A8WCJvx2nwB2W4XeXDOVGgGKbMHPYRX1QSkOm7bIiX7VXC9jFq9fFbBFvdNj8itrDZCerg0kXuImkFItqV90krCqAA+gCmTgi2Lgilw6FpYs7O9J8XJSbsZ7F1WaEmTA3jKC5jYZ9RDdVQdfXQ5sGwhj2HZm5JTLDpiS5CUK97VgHVZdntSRikzOoh3yur6Amg9vzZmSnyQJnMO5tsBLkmvs1EDS1w29dBquYHnq2I0UdlMal8zJpu5fJPiOSN/WUrdxdnXMjSr05GpdIdpDAymdolRtUKkq5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=olcQBbmzRcg1gnh3qf6bLgAGov4YUNKRcu6ttbNphqI=;
 b=LieFkWcx4YDOAzQq86v/ZZz+ytvjZijHDTI3kiYITs2iJI3t17E6KV4tFde0jL4HZHJInjRse3dfZvZCWDqfbso1EwO1AaMLX1S5+/3JcQSvuIuV3sgiTh6RIlPuigN1A13sAR+w24rh/kRVWnaq7TxDHcDt1zwdkV0d17jfQFb8M2NNJ88CY3FtkOvI4QI4SWIMKLl5nwQoul/POfKWm0+iSQTV7XdLJ6NPsb8SDc/bpBp6E+oFRNSGKuINkgJ12CilQ74yITPL9CnzyuhtTbdufQuzM292Pp218GE7bqi59wXEi8uXzb7zp3/ruaer7gZ8WDPxAiGg4OQblR4ZkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olcQBbmzRcg1gnh3qf6bLgAGov4YUNKRcu6ttbNphqI=;
 b=esHaUh2WlT3H8s+0xJM8xZDhP2BBCGCTHcG3Pj/c8l45f63c42cgFdAZh7Nc7ThXQB0nmrF7976Xtv14Zg0yCJApfjt/z0x1Zz+QTxoJGqPPgC9KvUHQKXiVpxbSsqCW3Yk+r4GYYvaCDh/EO6Mr1UP5vVXfIQ0FDGR8688TSmmleeG0TKqfTRV42NijOmYoulyHOrwff+aew42+EfBYkfSi/1hC40+jw3v4FZTsNH7bAXAY7ns+Mz7HUvWrV9VMnWwNKUIb8QjO4cGgvEFbNXLLYDRpImpazSoZg/ypHTSlJI9sLXWk+CIcMoXK0wHTO6g6V09zJrygB+jbgEo47Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:34 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:34 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v2 09/35] net: fman: Get PCS node in per-mac init
Date:   Tue, 28 Jun 2022 18:13:38 -0400
Message-Id: <20220628221404.1444200-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220628221404.1444200-1-sean.anderson@seco.com>
References: <20220628221404.1444200-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P222CA0011.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:208:2c7::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6ff96db7-9063-4b5c-1098-08da595394ef
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0DYpzNVA7tCOsxtgrqBScsiFrBAlFEdp5OiPsTyBCYj/k4m6NXsaKWEfOQwiJXy5w0Kez3Csw29qf9AbbIgnTPOWTf8MOvK7wMSi3ULiUffK+m7VShznpBEnzKYNx5On45Q2U266bUX5VcLPKAJapVqgeHk6DyRpnHRl3sUDzXRFRz+T1wy/ehyvfniz+obYpQP+8lzVPsLOhpTg/GaDlPkMm0c9vvTkgSQK8gUq+gqFB+npWt7vVR8/pZTggZDuC7NZugMcqsqJp7FOCuQN1oUzE0YUz/JLtT28t9wg+pvylQbqT/mV/Q5wJxwmQyH4TSVVfQYnSnPvcfIZzh7pX1v+Gnkz3OUCbbsOLUA031h88Jyxf5R4bNsfzNI0NrTVQyfEzLynigrF8PnA7fTEmCpV66fJYJBdvlhD0+oBbkFUqnwSOpThCzb+BJXpXVktnZlKgZw1ixgQ6bOv6fssmxuGYN8xWX/SCVPHd/vRmANP5l7tPS5If26zKbNdBfJWXJBpHGYvIQaX1pnrdJdHi9ZRytUwn6Uv+avsAOv2G5VCFTdTZnJxoJuGX3b9tYLGSt1RT/3SatipcL9hHkcsUp/Srkz8KJqP9aoMOYUmz61UYC23aGOznjCUF97YA0zseW5k20U/ubhb41cprSWivBHc88Ll7ohk5sOqO+WdtNsmwMMmod9QN5hCLumK+DM8j0zmrLhopvybLcXTG8OJHsoZGAmxUm7+6lxCOv8tO//DCytmLZ48JcK+48NcwMK5u326lsKp2p2WPgI2E87RHtLzxw5fYALxQOoGt4XPCkE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2JW76E8upatzGyOJc1lGdxijCapAdzhNOG5i9a7LZiYrenEc8+HjiVwDp5ei?=
 =?us-ascii?Q?z+7mJYkfWrAkktNub0O9dAXQul7p1Zq6O2dJI+dVNpOqWMWLTtlinBTafsQT?=
 =?us-ascii?Q?+9WY18VbXixmVf4a8rUyHdgDIK2TvItYbmgTIVAtAPemb9HlVItBxCS/t6jw?=
 =?us-ascii?Q?eGGSVOyrdrnM7Hy9K0oFMzO0Gpqoa6bTMNpMWxnmI6eebFlidF7Z4wFABxwr?=
 =?us-ascii?Q?DmqQhNkfgHPv/m/t2PsxRxkGKj6+FMePkVPqHFpzivy7bBSGToBJYjHg5hCP?=
 =?us-ascii?Q?ws1FCLMVvSs1aRo9OyztUJBLGrVcInOmvR70zSap/s8iDgvstxUKnuOs1tv+?=
 =?us-ascii?Q?OWvV0KXKtAdQfmdW54vRsuLGIkrRh1a9mSzMydS3hAIJuBLwRr0AQDwcyV7y?=
 =?us-ascii?Q?td1Z3f8p1Uw9tb0JRkIuoMW/UyS2tc+MftMkNJRhBNtzrdyv9bAj3EGfwdKL?=
 =?us-ascii?Q?NFFrnSX6ePPYJF3RrJ5iK1GCTTgqdjqD8b2orZKPe1GSypPoDPr/sooE3Gv2?=
 =?us-ascii?Q?XXSiny3OvdTd1lbA6c14Px75zXNHdroVKB3gDo5zSYkuYTwlRJu5cyw4mV/y?=
 =?us-ascii?Q?QDRgzRftlzVLjGM01WQV+iweDPa/D+1js0BwbSrYfqN2CY5lJ7mq93RP/arM?=
 =?us-ascii?Q?QAhHIJi0w7xS5tX8ammpywz1DuCDu3QWC4SLcG+EGIN0V6O/3klnPXDQB/wk?=
 =?us-ascii?Q?1byIZcAJEFL6QC7oWsFKY89PYngaAlQ0JJxSlWqEuJBu1qlfR+tMWtLPpBa1?=
 =?us-ascii?Q?bTdy/DSF6BvmKwmT6OqYiJYkWw+TNU7yasY6FiRTaFKh3DJKMrGOkyhaiCg4?=
 =?us-ascii?Q?xQbLaRJMxZFoLwIOx7n75pYLojXlLgVajvnYGe6Bus/gi9du7Du/zH9RZzCk?=
 =?us-ascii?Q?0f8yFPJfmNRB95yNU3PMQzdcudqK5hpZxfFP32SneEYpyvf4EHOiH7Nm1rfL?=
 =?us-ascii?Q?l8YRmfwrakPMrl3LJrZ96x1QfJ2efSL+VfTCilxzP1NbZDgICshRJOZIjvLR?=
 =?us-ascii?Q?FrKVReXXd1ciWuN5p14Avvk+LEgtix6bsph+pfPA5TlDbpEBRTRflgirf6np?=
 =?us-ascii?Q?CtACr2iuHayEeVrkWWA8z5SOYT/FLJHN4sRVoNfXtYcards1VIXV0AGsv8X0?=
 =?us-ascii?Q?ISB8wci4h2V8Ptj1SpqIp8d0Cr9j9Sk4BrUxiB+0UmQk6k31GNpV5BpeEO3O?=
 =?us-ascii?Q?DRSUh9w3+p6jalUWsHe+TulWcnWPgps4VLJ/88aDteuo7vuQmFi7JZAir/K8?=
 =?us-ascii?Q?XsNr6r3nHEK7W7sln8weSihwMNXGRJtpyP/Uvl3WEtMa+b8mECl/nI/RbkqK?=
 =?us-ascii?Q?tbEjWeWPCNgRWxI/6fxUgioKIRP3uT4qw8uTJoBcuHU+JoPdQ8pZwv52UxzL?=
 =?us-ascii?Q?H4fT7C5F/hadBn0R/fkMiOr38wvz1qgrcT1sJXAYSCFoiSYz0WZEEDQA775l?=
 =?us-ascii?Q?G2UxV99HSwmcqvOnF+ekNO3avzcTKTY22+RZ3Fjt5lo8fAZc1OfNMCk1R7Mn?=
 =?us-ascii?Q?SMywBuAHpshHVHY5c65Mvj324nmpnIH8shlerAHvpo3Mf3ZefMeETGfJe6JB?=
 =?us-ascii?Q?SB65sP0ZMGmCFqKebf/KU+vJ/wnCcvCGGwpbmTDsQSLyBNBXmc6mh8EK8rTE?=
 =?us-ascii?Q?bg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ff96db7-9063-4b5c-1098-08da595394ef
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:34.3605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: icMy9mXW8sJh1oJSxPhTGwd31n87BgdnWdWvSNhmZy7RNU5z+P6PLNbcVxDCrVLeGacItse8MjvbtbZC0kyW9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This moves the reading of the PCS property out of the generic probe and
into the mac-specific initialization function. This reduces the
mac-specific jobs done in the top-level probe function.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
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


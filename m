Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12588580161
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:14:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbiGYPOR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236038AbiGYPNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:13:33 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130088.outbound.protection.outlook.com [40.107.13.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 348BC1C916;
        Mon, 25 Jul 2022 08:12:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RksUMukzD2qWaDHmSybo2oq31VA9T1GmNKue8iGV4ml56IDhoO1wbZjlPPjM2tgEGekNj2w+5dV1n+9vd03xy2D6PEq3mVTUBlmL8K1FJo2BPrl7cwwre31i3fiJkSZlss1IGCoJCf1Na1Jcr4rDB3vDSvFfu6I0KChqfgN+9Pd4S0zrpBHhbF+dDLHG0bS3HrLMGTT7k8ve6mWGeCV2xSGTHzu48OWrAp/wLYLFtdubwljwbvq8LC+NQpyNdBVntG3GFUbGXFXBx5sSyl0friuSAEOb4y09zSkYRD45zN3DVUKntr16CBZMEpUmeWP1DEi4VxLghJw9JUnEwsD1OA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F39VOWHdbomM6yNOWWJ7eMkODFt7MS7bR17qY8C8kTQ=;
 b=dnrMksz37jeQ1QazZXnO35A47VSXkdd8mkmQqHFP1d7phKtA47Pxg9eDyjCRyb3GyR5/HHYebuX6cnabJFYX113RuioJvUmGMJ3pfpkj0+8D9b5ExxhPs3p7wRRKSuNkCgb9xuqjpIvMzZpEvPAm63pUr8zGcG4I1TTpplTLlwqaz0JgVv4KHQSWA7rhdd8l1rfGNg9sh2t+MX+HTTEM15pJakbP4qKtrA5GfBlZgJrz8minD/9RSSVDSZkMBesba1QIpSkf2MEVbZXOTLhB8NCsjKvGCW19y27KAoCYmhsnAhO7C7ld5iol7ZKqkd+cjNDjaCClCvu+K91LGmjEhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F39VOWHdbomM6yNOWWJ7eMkODFt7MS7bR17qY8C8kTQ=;
 b=KZf4plhVNCCSlpLgYf9xqFH13sHDZeCDkGjrEG2juhHMN9ORg2K+h9DViJ3dsWIkUIHh+3DKny+UlIIB5IwUz7q183d9JpZK0Iu2IGpMDgY+GYqSt43yaqZ5UQvvX6gxVr5Cji26NihqSdyhib1WjBDt76w5+4uejAlksDiqObQQhdmMgf2ngoNZ4P16BkRCBlWDJ7BJhx+vK2bL/nbsUfPRk4aZMz8Mf217NjD1G4Rp9k/0/J6ZN40jfer2hgd2d/WY4AqNJxpPcChA3I1+vRT509QpcH7ikfCWX/aE2te09QP9ACZb4uT15z0asLrC2+wbonv2ZgiDpkefqoAB/A==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB7PR03MB3723.eurprd03.prod.outlook.com (2603:10a6:5:6::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Mon, 25 Jul 2022 15:11:35 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:11:35 +0000
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
Subject: [PATCH v4 20/25] net: fman: Clean up error handling
Date:   Mon, 25 Jul 2022 11:10:34 -0400
Message-Id: <20220725151039.2581576-21-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: a49599f8-d676-4921-e548-08da6e4ff6ca
X-MS-TrafficTypeDiagnostic: DB7PR03MB3723:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCXwuiQjvbbWP0CsWXQGW+L8337Jldga4Mur5e1V0Q82c66BOp/i1bOMy6VGr3RLuDkx90pv2IYA8kn2etyH+HDs67FNUeWMUVkzAC8jNsOWt5S85Zg8QAXerd2VnYsNTMMBtzNpB029qRaD4MK/9ypGXqwQuXVwbyVfMUmwdm54bJNfg2mX8PuLEjHxSJjYq+pAmMrXXSH+7h45rnb7yFIXXUH2EWCvtx05KW0kybbGFc+m2raEm/fH0KI6ErgaQ6IYtMYQZfzlyPKxle9yC4v/yHUeGG7E9I/9W0sIn20bTlh2+ygZhZ4Vbrs9AblrOMxzi1Hh+UDtsJRMusZ32eB1quPPSHM4ZQhKO0+HdoXqNiINBsFINgrCFnnMyNGC+Ly5CBInS0qA7iTM/LdbLt7t+pSSdjzu99a4ZDwvleeYM+dq4R7dsTTpnmsFbZ3MbFk1f6llZupPAwv85Rb1uW/1QT9JQMhC48bQXvyLHbgfMAyZ3DbiKl06ZjoEM+Uv5zHnxYQoVN/XbfXCm9yIrRHPnaw+ABTYjSOAg4TlnFxh6OWsV+xb/yWe2N5tiTeD2v2zLWpGNmBXoyDxH9xSQ3TghXV4ncah9JqwvNLxN9MMbCJdXWZtLsoi2EK9x1Yg8P6WoqGwLwrEutVBbX0u83AdRbAUFApOU+CTr3ALpmfgdcU7GhP7ASgS1LorttpDHQlFV9udhOgXnRat4z+aHF5Ecdb9znytLMI8Ju965k+l+7stRog/CtC+3IJuy9UHSOFKNXMn7lumtvBnjjXXZk42SvMfA9Nyw0TTh+eXEnQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(346002)(39850400004)(376002)(366004)(186003)(6512007)(2616005)(107886003)(66946007)(1076003)(316002)(5660300002)(44832011)(66556008)(4326008)(66476007)(8936002)(6506007)(7416002)(52116002)(54906003)(110136005)(26005)(8676002)(6486002)(2906002)(38350700002)(86362001)(83380400001)(38100700002)(36756003)(478600001)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Hiqi9/UjrdI7QDOU/bgBoqUEW+N8/H2kzOZdu8t5WNMaVK9f7zeDL32G151C?=
 =?us-ascii?Q?YdRE6Lyrgv6UfBSHYkzSzydqFIB/y6DQLB0ASE+zY4yvGqR3TTMV3fZpOE1N?=
 =?us-ascii?Q?X9J8PFT1jFp/pP/QjezuTXSnMr3FmLHRQ8mil/mgqXq1NLnKo9k7pEsOCQbY?=
 =?us-ascii?Q?ULuZCam9RElNqFxZG8bCs36e2EA6t775yg3k7yh6ocw9UPAGvq6tA7jbRKdQ?=
 =?us-ascii?Q?JC4Vg1pS23CupAiAqYzCH6DJ/pEkY1iZXyeRa63LEPhoi6cdPjXeDtkC1R0k?=
 =?us-ascii?Q?SJ/BP+0DmTS/w79YgchVsKXgEub3wifnyipiLs5lXPb7wGNEDYfmv8I3ZAQ4?=
 =?us-ascii?Q?e+lD4kS5tITFIwIIuA6U1WhLO9FMGKZQ+cHhZR8JZryfzqsZFoyQIA5RhzHc?=
 =?us-ascii?Q?7cceuUH0VCcxYVNKUkFy9BZcn/UmpFA3DqM2ssFeaS6zt6Dlb0AeeFz/sy1v?=
 =?us-ascii?Q?yAwyNKMji/YRkDWfsv1jESKQLq9uFaEFZ1TkQFN33dAISapLkZm/QjNLQczF?=
 =?us-ascii?Q?VFVID4BbCz7xTp9UU5+ovP6fArP7s/cJN2BZglFjUeYvTVbnWRNjDVPbo5Lp?=
 =?us-ascii?Q?eAIhqoSNT8QBF5FE3dBDu0x+CT9U1PmfYDcxqUCWxUWveJPz9cH7Fqh8wFgw?=
 =?us-ascii?Q?QdS+yU8I8FysVSmHv9c7rokUfCkmVHpP/wUlQBHtMNsacEmUk/quFH6haGLM?=
 =?us-ascii?Q?X1AsTbF6qb+OTgozxwmtHehWyaiDM69OreSiFe00+buzN4QoxP9s2ev6LSCF?=
 =?us-ascii?Q?AjYMRB1LiwyKSwekyIoIwW2jnmR/nFDSeviaOEv99R+mZmGvJi4YYP2QMCRq?=
 =?us-ascii?Q?IjNjqelw/1Wm+7+7wW4rMgjF5fw3VjPXDxJG56HIsHsrJ2eMdUHdepEWST/G?=
 =?us-ascii?Q?mrSQ9AiqcebQ5ZtrHvC5WiPPjexbBenYGNXIsFHk9Gt72dPYPMWFKkZyZn9p?=
 =?us-ascii?Q?r3+emvF9B2uhWte4FqQ1hYbsf1xl9PipKST+y6s/w0RV45NeEceys3puDUHi?=
 =?us-ascii?Q?qmaKS0P7SiduKZeGbXp8NteR4pVWprDWfaIYdVRKHX2XoPkhaey7K+wDPSzU?=
 =?us-ascii?Q?k6Eg7OXRCvtFXUYw/5mBYn0hgvAGepOSokmgVQrOrH4fPEF3PQVkf7/ZsfpD?=
 =?us-ascii?Q?L75l4gSwNo1ogDyeihXyI9M5n5SylIvYBTTRMm6kiHmBqSZMmVditjWjn7DL?=
 =?us-ascii?Q?hQA96wk9Q1LwjJgbshz2QqSUil3W1NI9pL0wXLFHqES9x4DchwQ0EsT3Q0gM?=
 =?us-ascii?Q?gBjHHWeMvFMwaaXhHSxlb16QHDUTFh6fyNR95qiJiSOKq0WZ75fRmLMQyNs3?=
 =?us-ascii?Q?CBGCllVYxJX+QKoH7Wj1fUlk/OcbukmpY75ahmWjNp7FIEpS37VDUubbeBBA?=
 =?us-ascii?Q?1gmlPRIdXbMCYqFvbUNGlYLEPDx7oDJF+6IzITuR63sk+lX8ba6xGFX+wGLb?=
 =?us-ascii?Q?/RcIHog+fE+B7sKuFIkw1s/zKZ/tjXPmFGi+q28x2Lxd7kmhIPHrEor4xUmu?=
 =?us-ascii?Q?VLFSPCTxbES+wZ1T/wwOxPy4qIk1VEPSkuk7TNhC5lq8PihUKvFuU7n/cs/8?=
 =?us-ascii?Q?uRkUHtmKI5FcZjU6NpMrJkRkwbE5/z+5xZylDo3i3s6fK/dsT8gHGuEfOY2Y?=
 =?us-ascii?Q?Sg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a49599f8-d676-4921-e548-08da6e4ff6ca
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:11:34.9404
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 47yl723nG0ElJ6LY1L2b9xcu37aZg1dVZY5dAJwuWR1N4QhNDwZSAGZkga4mccraAIVrWw8ZDdJoosL4bchUGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3723
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This removes the _return label, since something like

	err = -EFOO;
	goto _return;

can be replaced by the briefer

	return -EFOO;

Additionally, this skips going to _return_of_node_put when dev_node has
already been put (preventing a double put).

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 43 ++++++++---------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 66a3742a862b..7b7526fd7da3 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -291,15 +291,11 @@ static int mac_probe(struct platform_device *_of_dev)
 	init = of_device_get_match_data(dev);
 
 	mac_dev = devm_kzalloc(dev, sizeof(*mac_dev), GFP_KERNEL);
-	if (!mac_dev) {
-		err = -ENOMEM;
-		goto _return;
-	}
+	if (!mac_dev)
+		return -ENOMEM;
 	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
-	if (!priv) {
-		err = -ENOMEM;
-		goto _return;
-	}
+	if (!priv)
+		return -ENOMEM;
 
 	/* Save private information */
 	mac_dev->priv = priv;
@@ -312,8 +308,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!dev_node) {
 		dev_err(dev, "of_get_parent(%pOF) failed\n",
 			mac_node);
-		err = -EINVAL;
-		goto _return_of_node_put;
+		return -EINVAL;
 	}
 
 	of_dev = of_find_device_by_node(dev_node);
@@ -352,28 +347,24 @@ static int mac_probe(struct platform_device *_of_dev)
 	err = devm_request_resource(dev, fman_get_mem_region(priv->fman), res);
 	if (err) {
 		dev_err_probe(dev, err, "could not request resource\n");
-		goto _return_of_node_put;
+		return err;
 	}
 
 	mac_dev->vaddr = devm_ioremap(dev, res->start, resource_size(res));
 	if (!mac_dev->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
-		err = -EIO;
-		goto _return_of_node_put;
+		return -EIO;
 	}
 	mac_dev->vaddr_end = mac_dev->vaddr + resource_size(res);
 
-	if (!of_device_is_available(mac_node)) {
-		err = -ENODEV;
-		goto _return_of_node_put;
-	}
+	if (!of_device_is_available(mac_node))
+		return -ENODEV;
 
 	/* Get the cell-index */
 	err = of_property_read_u32(mac_node, "cell-index", &val);
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", mac_node);
-		err = -EINVAL;
-		goto _return_of_node_put;
+		return -EINVAL;
 	}
 	priv->cell_index = (u8)val;
 
@@ -387,15 +378,13 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (unlikely(nph < 0)) {
 		dev_err(dev, "of_count_phandle_with_args(%pOF, fsl,fman-ports) failed\n",
 			mac_node);
-		err = nph;
-		goto _return_of_node_put;
+		return nph;
 	}
 
 	if (nph != ARRAY_SIZE(mac_dev->port)) {
 		dev_err(dev, "Not supported number of fman-ports handles of mac node %pOF from device tree\n",
 			mac_node);
-		err = -EINVAL;
-		goto _return_of_node_put;
+		return -EINVAL;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -404,8 +393,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		if (!dev_node) {
 			dev_err(dev, "of_parse_phandle(%pOF, fsl,fman-ports) failed\n",
 				mac_node);
-			err = -EINVAL;
-			goto _return_of_node_put;
+			return -EINVAL;
 		}
 
 		of_dev = of_find_device_by_node(dev_node);
@@ -465,7 +453,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
-		goto _return_of_node_put;
+		return err;
 	}
 
 	/* pause frame autonegotiation enabled */
@@ -492,11 +480,10 @@ static int mac_probe(struct platform_device *_of_dev)
 		priv->eth_dev = NULL;
 	}
 
-	goto _return;
+	return err;
 
 _return_of_node_put:
 	of_node_put(dev_node);
-_return:
 	return err;
 }
 
-- 
2.35.1.1320.gc452695387.dirty


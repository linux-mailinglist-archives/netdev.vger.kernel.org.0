Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1F5A5988A4
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344617AbiHRQUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344733AbiHRQT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:19:58 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150082.outbound.protection.outlook.com [40.107.15.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45A78C3F71;
        Thu, 18 Aug 2022 09:17:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A4w55kNqjeik88HgVMYkmpIuOZsjbZftcznLqqbGQN678TEGnn0+frS8SHSIy5ruX8feG20gqIyndmKtVwESHBWqVf0ToiaFnkQUyYffpuVBaEw1nsQf1IO/mXwO7Ky92DFo3PIlLcJEjulWW9IK798a7bIFDy9fr+YHX7R50wgLvHzpe0lPv3xP4yNsWFIPkgnlDOlpLkXtyOLE6GVGze/YIlpoF4RD56m4b6eKy0IvESAMjSyW4XfvHJ0++kTRwRtpRuRo3iwtNBwC9SXZ7rnlTx/AHxJanGMd6SCoa3WOFRI1xXHpT8RvBs0Ni1hH96lbqvUVVHN10sBnt/dioA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F39VOWHdbomM6yNOWWJ7eMkODFt7MS7bR17qY8C8kTQ=;
 b=JLQqN0NcZCZQbHUh/sLzBM0M0zI9RR53bP5NcvR5NPlKItWKBoBciilmYBUENhW62sM84c+VuZ4xMRiHPgVDxY3Ez1OjRBHU4Y1rUnJWnX8FWDjzJbGk+C3ycbNws+LMeWVRD6t7lAKjJaUs9Xpfei6w6HTXYWASGiNvDBLKMjz/+oHow9AaOvOiwaW6PF9yw9xtahdI6FCtfNO7jo10Wi0mi6J2idWB8ftgMZRO9MS1CJD4QOsWbBbzHRCF8jVfIDF6yMGVtr6HumoD9kbnx1Dk/lTzKNBoASGGTSkJTJGQc/WgFC2xSxg+/aH5Gmx+i3xk75NJ4c5uhTW9PyXzkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F39VOWHdbomM6yNOWWJ7eMkODFt7MS7bR17qY8C8kTQ=;
 b=0p5mqzwpPBXQ4SS8miLYY3eCyv6shh4+UnFNIbhklbcLCDg1rYARwwQRqVEK3V4BhgNLUgEHyq9TMUK/XRAwJVpaOIuexe14rU8lnknS6q2e5kjd1mrNPI81ffrGcgSJfR50JDi/49++6lHIAultfwFfD3pKf+cSsPg3GyzHGV4wcX1eGkNgxca2q9aweuyP3cOW7FJEohyEozgov3RqtjA62oX/ElkE7hVSg373xqrSyryEqDH/HKMclFjGrCfiw79CwwqsgTpUUEWrdfc74Q7B4JGIvdRCOJ7wN46ouax5fBZPnfxxaAyP3MG6Vvq/UvRK7dYy9OW8ma1dhf9/aA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB5621.eurprd03.prod.outlook.com (2603:10a6:20b:f6::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.11; Thu, 18 Aug
 2022 16:17:37 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:37 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [RESEND PATCH net-next v4 20/25] net: fman: Clean up error handling
Date:   Thu, 18 Aug 2022 12:16:44 -0400
Message-Id: <20220818161649.2058728-21-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f2e4fe0a-df80-4e10-de74-08da81352a59
X-MS-TrafficTypeDiagnostic: AM6PR03MB5621:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /yXVOXKADuWAsmSsmXZgw4nr43H+NvmRuytgne7rhsYT1RcrUvmFYaPnjcJTJVdvLvqAt5JUek9eIYNFLWkj6g11LRhOaEirG1x9mkI3mh8MJRAib8LjvfI8tp9p3UVEsOLe4f5I7UL0KyVyV55O6XXFxkD5d1s1Qk+m6XcALzW3Qw3V2UPP0sZQiHiOuEGaOt6TI2CyoJ0VHQIZWvJDOlYHHpjrqwbnSpciprcW5ifq+Ps1s1CadQwLLl6KFHiJsZHnSW4AhugqGDxkUKfvdmPpKEtMFzosCWbVNXULLdlXmRRq2DruwSCPlhOiR8WOa6H9qr1rTOr25c/yZV0OQSEhXmkZBqSf4Pw/BMSAIAP6yUsypO1rXr3HYElT8p05LgTD78B06wHHRL8xgLVlVR9jr1kTXAngh/UWKgROuTD4RzxxSVPFNDTjJfPYB5hqmXvlr+V/ndy90IxYHofWgFwSSc+HOkaqSFDm96qxiwa3P2Iy8ZsuaBRNLVVPmYOxnnGkKT0pMSuscA0TD4Gd5sEhQi1rDh3oWhfvpxlUpdgqSg/NCjZoEomnjpX3imC9QXko56Pj/8So0imVdPjcM6+N4Kk82ADyxFOP1Fm6tfGiEU0OJ8MzXptNbYEXEmVNXIYT7/uW1deYifkwOEcUUikxn7/gb9zD0CiBC3xj4WcUCUeto/TE6CUkHlXKIpjihy36/z8y5R9UfWyKnSDUkvNh29WVF6gox14VgSAKUr7G1rIvw/9FbqJcEpEEuGlN+AFmcG+0vXrAyUXf67X5/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(136003)(346002)(396003)(376002)(39850400004)(41300700001)(316002)(478600001)(54906003)(38350700002)(5660300002)(38100700002)(6486002)(66946007)(7416002)(110136005)(66556008)(66476007)(8936002)(44832011)(8676002)(4326008)(2906002)(36756003)(6506007)(186003)(86362001)(107886003)(26005)(1076003)(6666004)(2616005)(52116002)(6512007)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?f2r/OW356i1NL9ALG+IERHr78W4buFJ7WLhV9IkzBY7hhJiRTun/oH+/yt1a?=
 =?us-ascii?Q?nR9rlS2oqjL+ctXjtoe30a+K+c1oiQoZg1sAzG14fBxbPO3tTig3pKJbN7mC?=
 =?us-ascii?Q?VGs+LS5Y2MpjYcgrKwmbgsEsTYTETC1ciq23tMGPfW6Kt0EiAJe3Wl4uGU39?=
 =?us-ascii?Q?qMtmkABd69uqOp2I71fJk8Drs64xtfWRmH7UKRhqTVADdyzqPE0i6Jyftk1j?=
 =?us-ascii?Q?BbXWkYryXEpqJPxdCThNxcVVoU5qlG7I9pYholDP6/48u+rCsSEYkMYzomxV?=
 =?us-ascii?Q?Qoe114CeApOeWJlsPqOiQqrN972FugAbs3DEbGVl3H219uJvBjHj+oMM3Hll?=
 =?us-ascii?Q?Y6hxRC9rL4au6pMAsTjtb0/uyeBdK9cQZ+ABcYEU3w7ScV5b+MIcopaC3m62?=
 =?us-ascii?Q?8Jt0bYrty5jvs4ySRKcmECsFwi/9Ouc+Tpzd2KerygFBOTFNwHF0XD1cJeqz?=
 =?us-ascii?Q?OputBcEZo+MEGT2qLPA3X4zPJA8xRLfw8QG1p2JvU/m3IaRC+xCQI0PX4aMh?=
 =?us-ascii?Q?y7JAFBKW66wThZT0nQlGkSAfV18oz6dS1N+xKS7CNfYVjejv6n+XJ4BbLRLU?=
 =?us-ascii?Q?L5mqll4vQg1O444597bsATzJhKUtNFzVyc/wugIByyfEaV4TXrHFzhla9k0t?=
 =?us-ascii?Q?L0BjBwA/7jkjplHypXAq2i0KAJN6cNop2Yk7qdoXhM5RXJrou4YYcwfMcWpE?=
 =?us-ascii?Q?8m4WNVCs0t7QnJ358ZRw+81QaFBws7d8Tf0kMG2TAeRYkteIjjc+H8CQFAhd?=
 =?us-ascii?Q?z+JJFQKqeSA0vA9kkR80/LWUC9hLUAjcGzl/C74E/sP8nVu2bdYB11dSf6oz?=
 =?us-ascii?Q?HckWV310aD3Nv6PBlrW2CJBMzBo4KpLuZu9VJaPv9LfRmAa4p1G5FGFIeFZI?=
 =?us-ascii?Q?Sr8p/8qikU9WP+Z3y+ln1SDASUEyplgOC7EYdfETYzsS9kXxrAwBVwNDlgVM?=
 =?us-ascii?Q?kLnS5WwBmKSqBWNp5xhn5MN4CSuxEX0eBZIKoY+0m0Fvg/rZia7jEyfUoU14?=
 =?us-ascii?Q?7absq7briNMDW3Bmenmttd6xzwntAMTjr8iyFINhB1myd6WA+waTzbCW765v?=
 =?us-ascii?Q?fsHgWThWeqsBdSmY15FBlLvVIQsFv3lzNmvvRkA+q41T57PTe4h24OQxDNTb?=
 =?us-ascii?Q?yyT4jLDur8ZZBKQbUZFJhueGYlfiBLD0YvPL11ZMSloSi9ur6Rbv56X8itNj?=
 =?us-ascii?Q?HAttqi0Qj5xwv2qv2yEtjErMBexPqfIbQ8K3tPxFqPtt34v3T3Ttw+QQqPD4?=
 =?us-ascii?Q?fC8HOjGAkvh+3ofcLAYk/CxZp7/d3BvDL0rARuqbL2KnJRwi0rJaXmrg7iuo?=
 =?us-ascii?Q?81GPM7K9ehbKz5zeqAocfzMsduTQeJn1J+RnlHdsRXWvT4H4M+TfZXCeRiYR?=
 =?us-ascii?Q?bQwh5lqWWsbcW+Bp8OtM2fiCEBcH1FyOQcUrtAn5VtV/p8qeHMNP9B3kL2vx?=
 =?us-ascii?Q?nhNyosyT62cNuE6KSh6lsSLmOjhGQvj/5ViFgVXA4ZBvWHZmqMokyHsB1E5c?=
 =?us-ascii?Q?WWzNB7fJttu/8UPVzTtbjuzxFERDc83Bir0ZWhxJPnR5ETj4TBfXdy6ppOET?=
 =?us-ascii?Q?ENghWwmy2hfwb8Jpc19wxh5s256HIRhbzMj0rA136/sD26SICX6UInNbiTKY?=
 =?us-ascii?Q?Mg=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f2e4fe0a-df80-4e10-de74-08da81352a59
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:37.1847
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A/8EWccXJT1LcQletAebKG+o/d4QAVzcDdLjFlQdW2vzB6i7YFwRUykSfUtDTopGhcGX6Xkxa4zmI4a10/L2LQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB5621
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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


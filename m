Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 452B955F12F
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231592AbiF1WPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:15:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiF1WO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:57 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CB1039692;
        Tue, 28 Jun 2022 15:14:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i2MRVxC8B/kVzlB5u5Zd4j5N9fLqF8vW6JAYmA/RACVAywUeqBBYneSDlGigvsoQRhIOWf/unb8ZHc78ZjXqYABHd5fj53WkEMXFoRQRaw/2gbedcjuDu8VbqfVZVbQQWc9JGmzIm2wIi5Ifa3+s7NZ5StqCy8cbKtR5QtmgQUod0Q8IiVHAfWic4FZnC4vWNA3CUDph7l9dZCN0QEqAb/bJ8fNlp+sLFLjUPiTkBvAI7caDXRaBSlxOnTagEvOppk4ka84UtU+FmapNCFeK/uzTB69pzhczgkjlgkqcVwLkk9SSSdNBV6WJPLQjhR8hXmP1jcNDSzMOkB5kZLVqcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X8nna6V9FR6z3TQeYzJFwbNUncpaCJL9LdjjV9RUVos=;
 b=IRlTL3bfB9/ikfYqHF5G/woeRB5vklsD3OHhAb1ObDfMmav1JyuYzv7RiRLUD2nmGjzcJIKpHKGDkis2JcYmm0cAKFKZN4nyDEzAn/9D6iXwB7jZEbge3yOMvzNY79KkrwLf/AYn6XPkVaJIeEuDpZot9hlEiwnMAmhPGe7MU6wiORxVfSRDE+P5c3l1ld68cN3tmKtqpNCaYvlGHhbQQTI2WTCMcpTd3yhxj7M6/FzkmLkJe+9ckJIyk3D0RGB9YgLQxQMSlX6eP6OGqww06F7uhe0t2U4eKYJ6ve1h8YiJSxIfo2QMdW9E1FdIeTRv4bAuPxrMHuj2H3u2PVcO9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X8nna6V9FR6z3TQeYzJFwbNUncpaCJL9LdjjV9RUVos=;
 b=19Ehu7mGKGSBbyXXcv20Qt7UryJjHiMCv09yv/9wYKmRODjlEfDTh6OncMDlbxt0ee4sETtSU+6Qtg5ns1vsi3hKHaitewMyDiYcz5lHWlIdEA2AP5F5S4z864ZUrhVjg/o69N2zxo3C5VlCUsaf8q1pf3Os0IVTSPV0MZtqIWrSAVm/W72CB70+M10hn+MTSvV+IiCs4mmFyIxqg9fjlmIrtRhU/hNRlSe2HPg77JYyP549TDJnCjwlTmplaniffdkg9L3RYb0MlqPO+YjWc1xUt2JKyT0joTLmAaVhYp8TL0QWCu7bC7NAS6YZoSusdJAiQWdnd8hV8ehxG+KMHQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:38 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:38 +0000
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
Subject: [PATCH net-next v2 12/35] net: fman: Configure fixed link in memac_initialization
Date:   Tue, 28 Jun 2022 18:13:41 -0400
Message-Id: <20220628221404.1444200-13-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: d53fd346-fb90-43dc-d2d2-08da59539785
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LXTaf84QeaR6lhGyTQjE2vRCHT65b4+eT6zlIzqm/ucXQsGVD5C/uq8ZjM8Utz7J6Y0WaAFSIckB/pB9phvVlEEx9R8OmeTlaXYXiW1nT6NYz8oX5yRHhqbuznKneb7x1amisyvowYWzmZfgbjihO+HRfrhZ+K8FR+e9kXoCdLFB8LsWyw4oNTi2jXRjSu+jPNMmEgj+wRJ51UWvxPgFH7YJpCoSb8Bxk7bQFRBMUh83S9vEvtIDhPOJTs6ID9mcXmSZmJ3uOPDwutpRItGRJC6QLfhbVQSCbSHHP5tvnYx5W5UH3oNtEkJPJ8cYN1Y+bTkufAWRKFFCLYyZK3Ml8lPLFAqJCV6R9K5cXcsjgSYGxI678EfFKSO+uDHhMzBHF70IKdVvJYEsLRYlqd6lh0Ke+Ixz/lBnZbnWkVK6/okLjBMFfcKHI+HE/JHA1arYbXjKGy7dOYu2t5OzUJAXFgnOnWRkVGOQ38h8E86/mEA2le+u+Xmh18Ap8L4QQhucglQM3mAnBYpcFf+o6xj7sJXMAxdDwr6Qf1DeItgtN0Eexvl+hOLldI9jLI4RvLcx2VvWNSmt3f9cR3Pz6VQ7oI6KCkQFzYm8t1+VA/3z6jV+XpbWBZDZMkO2DmPxELpy/rJ8sxylFrpCVcgjn1ok3ixwfpxUjK/UjwXX93mmfBbE+5aS2vumfABDFP/GuQTgNiUiXjYC87/PtfLXskhtv5L45MvPIwgJgmFTOCtkTHI63YjDEKsVmd83zGYMCrzTooBpdzRO160l+dXL9zpHuvoTB5SrSbM1+MAPLar+Oqs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(6666004)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Koztm8CvIUEEgMPx3OpRojyiCKaIytZTDXAXO8i102K6XHtf3SO0wOifm8uk?=
 =?us-ascii?Q?3liOHOVYGSkh4AOkjVPg9JkyGJehlXC+qjkFb4ikx3QeOBIVe5qAyWWi9h+K?=
 =?us-ascii?Q?hCBpFfA9C7W/tXQX0Eu4fYjU1uOjEyVGQVV0Ve/III2pNl/9hlNWcKO2WMEi?=
 =?us-ascii?Q?rAT8eks2L6tBqtz4r7PQBcFzFAyTYjgtlLISlsCE6+976b8PWcuTHadMptpl?=
 =?us-ascii?Q?qwVE4d30t8Ff/lghibkIiOJTrSGWxeh7Vfn1gSKUvhV3mf19vaL6SJHU1cHn?=
 =?us-ascii?Q?nRvZsCS6lWiUm5GXXuq5yqdzBkMtvmjmnJZugKrRxAn9gybTZOabDzLBbJmk?=
 =?us-ascii?Q?HL4onfZ7q4LmS9kecBM48WqbDgVjj9STxt8/iX2BS7ePDQEiOH2RpqNDwJ2p?=
 =?us-ascii?Q?+DlXQ9K8Od3Ylxcu+4//0pBKPineQ/0MiD0LGMdf6nYNfqB1TjvqUJzFnImU?=
 =?us-ascii?Q?GKOqbkiUOQGyBFXf2bUdnXklAKowVRj9EdTM1DSxpIaRSNF+u0KD+sPrXbXt?=
 =?us-ascii?Q?pVRK1I6f8Yw8Muz0molxFtluTnhdIr7B8oyIY4mGfyvL2EeRevw8kz8mGTcF?=
 =?us-ascii?Q?DpuYEOQLTvNORQOjpiKfjveTm4U6T56W79H2kik6fvM8GI+yaCPlcm6XRsqD?=
 =?us-ascii?Q?QDjvqmcLxi9uX+tboTh/MDKxRZqRX1JBUE1dZrCRJsHEor0Z/jfIIUL19uVe?=
 =?us-ascii?Q?zX3LmCLOYKrxEd67zHQvZfVdX+s/rE3lKOOfqYVaF55MB86x0mhbR0yxDnHh?=
 =?us-ascii?Q?gWXNQH5wcQkRl523uhU3T00PjPZhNGvnak+06OkXwjhw3zLyA4p/bfF863nS?=
 =?us-ascii?Q?fP8q7x95Njhta4qvcBsXVaUY1K88sUN9JXzKUoZC9oCsu/J9rKSpfRHCeoFs?=
 =?us-ascii?Q?7nDC+bg/2V1+ucBltbZOyzs5+WyAzijrtK9imQdtm67eYTly0p+BL9wVAkHN?=
 =?us-ascii?Q?U0zGKnUDKPh8HGLEvvfCfxRe5K9gPv/XfLD/aBQ0lxCPds4LfvkitSDGwAAE?=
 =?us-ascii?Q?0oQ/EObHlYoniGbAFyGC2VQOxyKWeck+4zVltA1LvsPE3OXaQn5s/dvMZ0CG?=
 =?us-ascii?Q?HlsC60R7GgYzAbuWzYWufJaEkvbeRcIfztO55gpK1blO3w7UlTtXeDRROmzE?=
 =?us-ascii?Q?/VhZB2aW/k5KSj8SU4HWov75r+DzmX0wGQStjeURN9PYCUvbpqJogkA3GS4R?=
 =?us-ascii?Q?CGCb5Qeu25dYGxvBUBrf9N3H17IPb76pSfDguX5ok3YW9ZmMP7AtgtTMPCC2?=
 =?us-ascii?Q?d0oTMf5lSaUACsyf1+0PQMelg/tEUWUzrl+ZZMFUdo17A0BRPLHIUVQFZUOu?=
 =?us-ascii?Q?uH1LHXKygxMYmU8oMZcUTt/sEcobFj6DB+l36INfPxKTNK+NA6beBJb6Db1A?=
 =?us-ascii?Q?AmhMQyUniYOjAYCgsTNuoAYLGv3e6T5L+jBRMuv9TA5amA6tpNDJ6NOJZOnn?=
 =?us-ascii?Q?LrV1eHwHeszqYn7ElOwBhx0+1V5OSykoQCKjUC6ROfIRHABWPp2Uw+N3RsSo?=
 =?us-ascii?Q?K/9nh0bOrbD8kF4s+UszJyOHf5xSGKGqCI/Pxxvt/5l8ana/oGgz1LZIPB4w?=
 =?us-ascii?Q?0xvfEoNGtdtY2wCkVBWgebd6AcsU/hVauuip0/Mg1kHQfcoDa6+Q3iiomMJj?=
 =?us-ascii?Q?pw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d53fd346-fb90-43dc-d2d2-08da59539785
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:38.6415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CX7wum14BZOmRl5vBmKWLmg3OkEa/31uZxrTiE8zvQ6QDZdbWq7bk9jnti4O1o/BPjwrfZKa+ySRnWbjNYYyiQ==
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

memac is the only mac which parses fixed links. Move the
parsing/configuring to its initialization function.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 drivers/net/ethernet/freescale/fman/mac.c | 93 +++++++++++------------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 5b3a6ea2d0e2..af5e5d98e23e 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -34,7 +34,6 @@ struct mac_priv_s {
 	/* List of multicast addresses */
 	struct list_head		mc_addr_list;
 	struct platform_device		*eth_dev;
-	struct fixed_phy_status		*fixed_link;
 	u16				speed;
 	u16				max_speed;
 };
@@ -391,6 +390,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 	int			 err;
 	struct mac_priv_s	*priv;
 	struct fman_mac_params	 params;
+	struct fixed_phy_status *fixed_link;
 
 	priv = mac_dev->priv;
 	mac_dev->set_promisc		= memac_set_promiscuous;
@@ -429,21 +429,52 @@ static int memac_initialization(struct mac_device *mac_dev,
 	if (err < 0)
 		goto _return_fm_mac_free;
 
-	err = memac_cfg_fixed_link(mac_dev->fman_mac, priv->fixed_link);
-	if (err < 0)
-		goto _return_fm_mac_free;
+	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
+		struct phy_device *phy;
+
+		err = of_phy_register_fixed_link(mac_node);
+		if (err)
+			goto _return_fm_mac_free;
+
+		fixed_link = kzalloc(sizeof(*fixed_link), GFP_KERNEL);
+		if (!fixed_link) {
+			err = -ENOMEM;
+			goto _return_fm_mac_free;
+		}
+
+		mac_dev->phy_node = of_node_get(mac_node);
+		phy = of_phy_find_device(mac_dev->phy_node);
+		if (!phy) {
+			err = -EINVAL;
+			of_node_put(mac_dev->phy_node);
+			goto _return_fixed_link_free;
+		}
+
+		fixed_link->link = phy->link;
+		fixed_link->speed = phy->speed;
+		fixed_link->duplex = phy->duplex;
+		fixed_link->pause = phy->pause;
+		fixed_link->asym_pause = phy->asym_pause;
+
+		put_device(&phy->mdio.dev);
+
+		err = memac_cfg_fixed_link(mac_dev->fman_mac, fixed_link);
+		if (err < 0)
+			goto _return_fixed_link_free;
+	}
 
 	err = memac_init(mac_dev->fman_mac);
 	if (err < 0)
-		goto _return_fm_mac_free;
+		goto _return_fixed_link_free;
 
 	dev_info(mac_dev->dev, "FMan MEMAC\n");
 
 	goto _return;
 
+_return_fixed_link_free:
+	kfree(fixed_link);
 _return_fm_mac_free:
 	memac_free(mac_dev->fman_mac);
-
 _return:
 	return err;
 }
@@ -570,7 +601,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		dev_err(dev, "of_get_parent(%pOF) failed\n",
 			mac_node);
 		err = -EINVAL;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	of_dev = of_find_device_by_node(dev_node);
@@ -604,7 +635,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err < 0) {
 		dev_err(dev, "of_address_to_resource(%pOF) = %d\n",
 			mac_node, err);
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	mac_dev->res = __devm_request_region(dev,
@@ -614,7 +645,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!mac_dev->res) {
 		dev_err(dev, "__devm_request_mem_region(mac) failed\n");
 		err = -EBUSY;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	priv->vaddr = devm_ioremap(dev, mac_dev->res->start,
@@ -622,12 +653,12 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!priv->vaddr) {
 		dev_err(dev, "devm_ioremap() failed\n");
 		err = -EIO;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	if (!of_device_is_available(mac_node)) {
 		err = -ENODEV;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	/* Get the cell-index */
@@ -635,7 +666,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", mac_node);
 		err = -EINVAL;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 	priv->cell_index = (u8)val;
 
@@ -650,14 +681,14 @@ static int mac_probe(struct platform_device *_of_dev)
 		dev_err(dev, "of_count_phandle_with_args(%pOF, fsl,fman-ports) failed\n",
 			mac_node);
 		err = nph;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	if (nph != ARRAY_SIZE(mac_dev->port)) {
 		dev_err(dev, "Not supported number of fman-ports handles of mac node %pOF from device tree\n",
 			mac_node);
 		err = -EINVAL;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	for (i = 0; i < ARRAY_SIZE(mac_dev->port); i++) {
@@ -716,42 +747,12 @@ static int mac_probe(struct platform_device *_of_dev)
 
 	/* Get the rest of the PHY information */
 	mac_dev->phy_node = of_parse_phandle(mac_node, "phy-handle", 0);
-	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
-		struct phy_device *phy;
-
-		err = of_phy_register_fixed_link(mac_node);
-		if (err)
-			goto _return_of_get_parent;
-
-		priv->fixed_link = kzalloc(sizeof(*priv->fixed_link),
-					   GFP_KERNEL);
-		if (!priv->fixed_link) {
-			err = -ENOMEM;
-			goto _return_of_get_parent;
-		}
-
-		mac_dev->phy_node = of_node_get(mac_node);
-		phy = of_phy_find_device(mac_dev->phy_node);
-		if (!phy) {
-			err = -EINVAL;
-			of_node_put(mac_dev->phy_node);
-			goto _return_of_get_parent;
-		}
-
-		priv->fixed_link->link = phy->link;
-		priv->fixed_link->speed = phy->speed;
-		priv->fixed_link->duplex = phy->duplex;
-		priv->fixed_link->pause = phy->pause;
-		priv->fixed_link->asym_pause = phy->asym_pause;
-
-		put_device(&phy->mdio.dev);
-	}
 
 	err = init(mac_dev, mac_node);
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	/* pause frame autonegotiation enabled */
@@ -782,8 +783,6 @@ static int mac_probe(struct platform_device *_of_dev)
 
 _return_of_node_put:
 	of_node_put(dev_node);
-_return_of_get_parent:
-	kfree(priv->fixed_link);
 _return:
 	return err;
 }
-- 
2.35.1.1320.gc452695387.dirty


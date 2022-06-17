Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B6054FF02
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381868AbiFQUfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244773AbiFQUeR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:34:17 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2065.outbound.protection.outlook.com [40.107.22.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5421A5C858;
        Fri, 17 Jun 2022 13:34:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1q4FjpB23LfDMbpiyKS0Hf5Xtw0Jto0PehxVY3e5+D744beR6n8WoEGBVwtrkXvwc54MtihQVfUiolivla1FP6mvYL12ZajuUcgWjC63I4nm87zCm7zi7dufje8wZs5pTht2ISrNV7G2QyLfqK7G+xdS5+kOron+5uDfpUh7xyRsNaZ2LKJpQyK6VpxBNL9FQoxpCYIk/zlm34SpIOjCPiQRehpmTVgL1dtKcGFicaNMzhhBLy3cqseshtjFSb8geq3J8MWOgrzWn9wGZCskJ58rZkbaeYS4qNNk/AjTeCukYBK6uGtLPnRgE2+yqtTMbL3fX5sqoYuZBausjvHug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A+394x0fruddNELh0FR4mRd8DK2yOozb09PjPd55S3w=;
 b=hh/+ZU1b5a4eIfr6V0vJa7mEZOcpHB9EGx7BpxguhRXk9s1fWkbsPQUDoqluHctVP/JYfhg6Wyz5wIjtbRrZHhZJa4+gDCOsZVlXPm0aewFT92MzEwBea759Pzijz33YfyVGezbmdF+MWM2Zt6Bw3AbCrgSKzIAYf46hig1BBbU6WlY7qeWNZBzvlX/wxkwGBYJ3xFRwch0nC1+WcPA2EVulIMRA5RNnfueMA/4br6GFIbOOecoWLUQvCi46K+uWX+N/SchLEmgJOMR8NxJ8fiIODLz3Ff5iQ5+C3/89cieFMNYflMSrGK1pqROyGv020tfKUyVaTKW5uxZ5Eog1WA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+394x0fruddNELh0FR4mRd8DK2yOozb09PjPd55S3w=;
 b=fs8IyhNz2YP/rO/zzpE6jIPq46pnyyBWEQaDnBIgOlTXzOHUYVpnXntzsxAnQQLd2jz91yX2xvg4K4I0iK2qHKB9G+/Br9dYaPjbLV2Zc8BwRxqz74+EQ0TU4SWxSOHAHp6GZEkeIBJxshJoStAsUEXBRAXFf2i46lWvR3jlPo4SLF4Ssq+u7gybefRnMZADABXec5pKFC3rDzdik5S1Akj2JYQ1Jj4YZAeS2K9q8v6AfxXjlco9dhhDzGSl9rWdwV1JridguqhiHyv+OOf0ZWYf96kjQo2dBElL03t09l4cr3OUk5QTvlC9/EHt+Wb/EPkqzj/3Ho79WRWV8+IEgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DBAPR03MB6438.eurprd03.prod.outlook.com (2603:10a6:10:19f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:33:56 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:33:56 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 11/28] net: fman: Configure fixed link in memac_initialization
Date:   Fri, 17 Jun 2022 16:32:55 -0400
Message-Id: <20220617203312.3799646-12-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: e87488f0-d225-4cd4-8d4c-08da50a0b3b8
X-MS-TrafficTypeDiagnostic: DBAPR03MB6438:EE_
X-Microsoft-Antispam-PRVS: <DBAPR03MB6438D84CC49544ECBDB5B10296AF9@DBAPR03MB6438.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: WNWFmTTppgifNyBlDd+ioBJvXoZCMujtE2mgbcL/fV6H6e6t7SI9heao2T+L2glw+H+hAnjtORa+U9RjEp3XA2tndMGn3BYNf87YEsfJkxKgz2+cpF/q8g/CylLAf01qiPHJMwbEsdpxCHtX0qEd7Af4rK9EWNL6a5S+k6d+Wx4u57sIYNnH9cdOOVSll8+kD0gZx20xTaWi9ekF8CRqz51FbB45ln8fGL4KBmsywG/jN7FRrA1Bm5qg/SiBBlN9KyyfA//F7/JdjZQawNiiRQoM8QrS3JWLkVihf8U9ivf/gDDSv8N3lVzSrA/kuvhUGNB7rVWYZQrt15PmHHTelKUZA13IZfvARqpv+FfdO2RwmnvvAH1IlyocUEhaqNjIr093fmM7TpsQIR9/xIL6B+Sven3G+tj1KrH4HT52rjgOir+wH+Xsu1PRdUmOk7lvNNbME7oran1KhNqz7jY5slX+zjDd1pwgppFiW83FGnd64PWZrXsdzEntdteWRK8FimzmS3wa3md6e+oZejDq1cw2PWZ5kXjonlr99kGsE6d6n1fmtrqccb8D7U2J/kfadl3KLvbCsr5QjqK5WqPilH50ih4g1D9LJm4TL66vUK4SPm26pchE0NEWqiSLewOLyHMYtPWjM5C22//ub5GsKRWHUyRjjsp/zLVoCkhh6tmIJGz6hIyDKjA2YhI779/OlFHezIZFFJ0AYekqVzgFhQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(54906003)(498600001)(8936002)(110136005)(6486002)(52116002)(2906002)(6506007)(4326008)(26005)(83380400001)(66476007)(66556008)(8676002)(316002)(1076003)(36756003)(66946007)(38100700002)(107886003)(38350700002)(44832011)(86362001)(2616005)(5660300002)(6512007)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?99KzZMEZrl4sj//d7CUuXSSRMf96SkrvhtoAEBbhGFKF0lvOkVXcJW15+CBu?=
 =?us-ascii?Q?ykHgIacfI8F2U3S43e94P252afVTUfBaAXi1jJQ/pZmv5qs109Td7DiiOf+P?=
 =?us-ascii?Q?c0YQyGjvo/4hnHqxbTXXdsgI24h7xCV/GdLBmNJNYZ9cxdMYA3dSldW5y/w+?=
 =?us-ascii?Q?T9dnBbBQ0FXE95xPWNuHaR6YuY7+crDm1GRIKTkP9K6yY8GwvnPTxML9H3m0?=
 =?us-ascii?Q?ntB/9I3/9fE/WVbc/1HfOdQc0EgZ5PHR7Nxo+qIAH5VCP6FE2r91QTzaodHO?=
 =?us-ascii?Q?Psh1JLEXUfALtUy13cX8NAFZ+r3AhzPFrgJWTACJQgwWL3qFffdbqR8wKy+b?=
 =?us-ascii?Q?VsweBpEHpVPLkcOYjYv7rV6763EZl8LSlio5A3QDu7luxXqUdAHp5aIIVcMN?=
 =?us-ascii?Q?pgb+dXykfJU5W48Qqlf8XbJrK+8q1d6oEkNPcB+FdL23QMtoSvGm86WP1srZ?=
 =?us-ascii?Q?TSR75ABg28PSLwdi43POcxieq9sPSOZkwSq0ta7Eeh5dTR0Tdg1c0eBNQCur?=
 =?us-ascii?Q?BH+nvyPh7LPJnCBmfM2Sc31FZunHy0+sIij5CwcJAdMvL9YdRShULwuS8+1s?=
 =?us-ascii?Q?y7Gh6jwoHyBpFzjkx8DBY/djNuFogIvPnjjvHsuOpP7hsOKQGleLyEMjTUde?=
 =?us-ascii?Q?sn7fQXz3qq/fQk/VFwIOcQQl0CssiP0yF024zHSuibIiLO+GrPrBZTwlwcni?=
 =?us-ascii?Q?I/LnucFMk1oR9G+g8qzRaVjt6qglIEjShhhfMeNg5Af0EoARc/PPvDsO8lMx?=
 =?us-ascii?Q?+WWwm5wQD478jCyaqFCquiCuis2eG3uUAvkzDumzFGvcWHf1xEWzQIgOn2Hg?=
 =?us-ascii?Q?5t47Igyp6hLKyE5SFgx1Neh8xKCgUvZfhi7AxjqLJ50oqNyygfJsk5SWIltv?=
 =?us-ascii?Q?iAsR+XNXUwaEAzQBz/pB2X/qFE/2g/yqBjMcj3skea5MXeTwdDxqSFACM2BW?=
 =?us-ascii?Q?aU4P2ooRUElptio3An/LEExEag+o/3Gdek/5lEGHyfFjjJua1dMFruVV2OTb?=
 =?us-ascii?Q?TyR0OhnAXt9HN5CPI83LOSpxB50K2CKXnGyxtCfkoG+LB0f17DZmV27KvcAw?=
 =?us-ascii?Q?Csk5eZ7OAUoWnM4dUbLgZr1tVQL/OKNXSRxIiASVhBMVrfOdBV/KluKfcJ2D?=
 =?us-ascii?Q?E+V4Wgm7H2kzhgQFozqdIFEDF1jq1Gg+aZQ3cbBltARUpOG1bHLh5XZBeM/y?=
 =?us-ascii?Q?empINi3Aim/gNtpotsqswRaUtSD3gEju+h6s1qr2fXiD6z3CbT6s0E0lw53K?=
 =?us-ascii?Q?pAt+ZdyNiH1aglitf+RV6EqK+T3+uu89XsMAOhwS3UKy7nIfzY9DJ3wLEqXU?=
 =?us-ascii?Q?Y7f517ZcmFh2LhwkZPbTawetkNHJIer2CGcB9r5hoOLboPf0HfDz8HRwDKUh?=
 =?us-ascii?Q?Fu4gaiBFE90tp8hewSe/bYJr+OhBn6ITKOz8x1X6YSxCmqSjW+8WOicrGL6X?=
 =?us-ascii?Q?6LD3nPYNRGVw8/mFXLEgHQv8eHkIXo1N1nqdo1pyv5QczES3sNakvHqn6l8w?=
 =?us-ascii?Q?4p2Mudm6AZttPKpnc0R+iAmXWLrSHJLjoi6Jip7UkGp62ck4k9uD79O8smyK?=
 =?us-ascii?Q?9lJmUWhjh1rqOTz8yxII1Dzk0ZQubsv5Bp5Z3Hd3lTZvUS4VrrbHimar7Mq1?=
 =?us-ascii?Q?qEtQx00FHniquEC3h/+BT0TvrUuK0cfnIdLVds7Nqa94F8j2sjo9ZsNgyenW?=
 =?us-ascii?Q?IwJ2gRGWmBL5LIvojyQLIZ/8LaQx2QvjruJo7qdOcFngMxBwMSTtmLXUsWXg?=
 =?us-ascii?Q?YzDMG/cqBXylLpwayhGu9aTdf4s1ttk=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e87488f0-d225-4cd4-8d4c-08da50a0b3b8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:33:56.8114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tDRzACstNMV4Js01I8qGn74gcn/rVidkl+isTF1cHUPKW35sCjVoQ4p9m1+VgZizQbItvn4Hf0T0kqmPSKrujQ==
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

memac is the only mac which parses fixed links. Move the
parsing/configuring to its initialization function.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

 drivers/net/ethernet/freescale/fman/mac.c | 93 +++++++++++------------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 5d6159c0e1f0..248108b15cb0 100644
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
@@ -399,6 +398,7 @@ static int memac_initialization(struct mac_device *mac_dev,
 	int			 err;
 	struct mac_priv_s	*priv;
 	struct fman_mac_params	 params;
+	struct fixed_phy_status *fixed_link;
 
 	priv = mac_dev->priv;
 	mac_dev->set_promisc		= memac_set_promiscuous;
@@ -437,21 +437,52 @@ static int memac_initialization(struct mac_device *mac_dev,
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
@@ -578,7 +609,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		dev_err(dev, "of_get_parent(%pOF) failed\n",
 			mac_node);
 		err = -EINVAL;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	of_dev = of_find_device_by_node(dev_node);
@@ -612,7 +643,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err < 0) {
 		dev_err(dev, "of_address_to_resource(%pOF) = %d\n",
 			mac_node, err);
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	mac_dev->res = __devm_request_region(dev,
@@ -622,7 +653,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!mac_dev->res) {
 		dev_err(dev, "__devm_request_mem_region(mac) failed\n");
 		err = -EBUSY;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 
 	priv->vaddr = devm_ioremap(dev, mac_dev->res->start,
@@ -630,12 +661,12 @@ static int mac_probe(struct platform_device *_of_dev)
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
@@ -643,7 +674,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err) {
 		dev_err(dev, "failed to read cell-index for %pOF\n", mac_node);
 		err = -EINVAL;
-		goto _return_of_get_parent;
+		goto _return_of_node_put;
 	}
 	priv->cell_index = (u8)val;
 
@@ -658,14 +689,14 @@ static int mac_probe(struct platform_device *_of_dev)
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
@@ -724,42 +755,12 @@ static int mac_probe(struct platform_device *_of_dev)
 
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
@@ -790,8 +791,6 @@ static int mac_probe(struct platform_device *_of_dev)
 
 _return_of_node_put:
 	of_node_put(dev_node);
-_return_of_get_parent:
-	kfree(priv->fixed_link);
 _return:
 	return err;
 }
-- 
2.35.1.1320.gc452695387.dirty


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07EF155F154
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbiF1WRB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231281AbiF1WPA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:00 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C908939B8F;
        Tue, 28 Jun 2022 15:14:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I33RLkdqZWvxftyR1wXjz9JAuZ9h1x5VP+LJ58S+0JoMFVn2Frsv8Pdgbbg0u7/6DRQZm6olALj4yzIMimFwx/JSkihKT9dsSCTUvze9ZuAFjf+WZlor2v8ChfcIlqD7e4eObhivNgXB61ehcOpJRzUHLy2HIu3qrNRbPr9Vus5YJHZA7r/+EgFjN5YTeT1pDQJWYEue9AToajBDH/NSMyG6eAYcmLGxGrkNn01qo8u4J3zrXQNEEdAra2nb1i8YYZSg5ZBgQQvry7yM2ZpyEUIIQG7xIq4ea/BsjIEi1YoC0TP5DrnALUP33uXlv0hsQu7oZ+oKKUQkRkvP7WPRzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GDp9p2z19h9IzDM8RWXvgmOXQ38jj8WkWnhniK7X7A=;
 b=DTCDSAF2YdQatXWZWJZOh6FCOaFsn0yumKnCXWKGXkqaQek7KpdDqJHPnrhi0tKmrCr499teDjQ1d8apexMNuc5yXNO4Z5vryI7FOarkZFUU3U3/lYzZ0Otobk74VRNfuBWRxOlm9Br2IGsIgVVGfYf+vgy8Y80608St0YD2s1E8AxWBCD8AnSQolL71+fguzV3nxhVaLb4iL9shkJLC53z/iD41gvmH1Zo+VudPgyrBXYCs/sVYGGyQ/vHz9QjzXOq5x9di5G1OAYYJnOM5Rdq6joAhwxl0OdK2XpRcx+/BG1OzmI7cBfsW9VJXGlSqpEoPtrdzXHvzWVXGEXDegw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GDp9p2z19h9IzDM8RWXvgmOXQ38jj8WkWnhniK7X7A=;
 b=wOxTdf4dVRwTFAF79vn9118sdejM/LN42CHsrcXjUj+XSlPY6+t10OMCtSff0x4nB0l438bNjmAiJP6bDuQQMfERcV1IIq9iYcNou67PC5TXYcEDAX9FyLet4mbTasHy8oZ7SKCfzfuCtbwLpgfrcxo0CHouYu+hosgQW9QMfHHigRdY5OhtEuxpYrV/cx3PcVS82RpfyreWbSq4sVgFm+m2prGPzSVvxGXXbur9c/Rbj8U2FCFL05D12+jgjgEsGtjJCSy++/52UxykH8n69QVTazqMx6bi5Y7dhbE29OVISdvHdzV7sAs5WLuQO0FB6t2Z2ONpFIMRzQZry+mbqQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:47 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:47 +0000
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
Subject: [PATCH net-next v2 18/35] net: fman: Remove internal_phy_node from params
Date:   Tue, 28 Jun 2022 18:13:47 -0400
Message-Id: <20220628221404.1444200-19-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 08ee8187-2267-4854-dcb7-08da59539cfa
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OzlCwpVoSiCpcozBjlXSKk7XFGQOJkzamrLR8VLBTYVsMZiQObgbrnRlElicLXxNPaVqsYo19bNY8tnKUDX8EJXvmUNL6c55PfpLVz1b1SCGaCDPaUWdaXTfl5ejtmfGNXMMWzL8Mjo/4fzUzDWJ5OuqFMPPLnbm+ZXcQTvj8SmsIFkp3vHvryd/axHTfDo/0FEdIypfN+yBaz+dnWgcDW2rmKs3TLXzyisb3l2G8LQzqELhz5B/dzAtSCsrJcQys/cXxIEW14FSyF0UI91lJoIcSAK7U+sfuZbEYcA4uCSE1aP8vZxMJsG3DPYUaYgQYPhTF4Zknin8QtAaIREQH7FfSqm5p+mSh9LlFKqyZKVh58fK6mqAXGgDZwcaO3oBTwgtGnfm5yoeHE5/FEogW5eLmugwDmR05kjpllXrbBUL1OJGenU7esqM6kh2Q9AzFc583K5OZ/YPxDil9kI6WFmgjBTNGW55VDaijEFAsBybsj19RVWxvGHJFWxoAsz9Ndqq+Hf7d5qehMtZMl3cvdyuHz7WEyYv+NaNQ0ZLT51TWqSOKpViYP/qfieHzYoIzsacekPQk2g5Nmb9EPH0bvGbyV77NHP3LTU6VJxqa7WTREgnNR9W2B0dfKqSgxk6KL09cF4h7iie2jX+HqN58t+EU9X2wS2hGefuWJbbDshQI9rFGMhdg6tGrk+pOF/4hudg6uw3ZdNR3pJ8iWvTdmXXuvTeCrka8472fc6YGNK5ds+x61RoyOMIUp8BAO4Amp3i/VxSXJbYKxxuq+lxUeigBT8e8vLjR5jONSEa2Uw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(44832011)(6512007)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(107886003)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5Fq1J9cOVpDlwsFaCDB8xa/vocUD8A+vfPQ03drxeCiMsq87841jXqs5vhus?=
 =?us-ascii?Q?H1cBhy8GhsFqKrdqIjx21eR78gwOIW0n4GW5zrioAT0s7mcD0tDagkn02Bo0?=
 =?us-ascii?Q?NW+qso7DDfBTe7fb13MlxFwZyDWAOfFXgruIc8K+0YZpuYNpsipWFnCmG8VA?=
 =?us-ascii?Q?bVs+zsakpksKEpb1RXAnA6dSOxJbO6UBS9GHAiJBmS2gm/M5PG4JEH8piGo7?=
 =?us-ascii?Q?Ubb0pDavS+pQ7/XkM4zIVvkd3S6+yri5YwgBKTJ1t2OLjjVGYVW9WUs+9TNY?=
 =?us-ascii?Q?pFewY2BehqzhUWPw2F+YAq+JEX0z4Lqf+ksXfsFC5HlOFTBsOVGYiBny7Ih1?=
 =?us-ascii?Q?FuGifKU5ROPxFnvTfE3lYwGz6+LsTeDQCNPfBjgExFOzO0q0oLkgYKyR8Mlv?=
 =?us-ascii?Q?917vmUBl8Vng7LfNlP2D3uzIRhzk2XeQ0fBH8OTlm0bTk6j52c6PqoBHzVUa?=
 =?us-ascii?Q?M9Fpy18gJ3XzXPlSkj4qS5xNWE4Z6/nc9C/n5GRh0wwRSa9YeqQzXsvPAL5E?=
 =?us-ascii?Q?4+1IMqSj47jp2tG/u4qAm3MUNtPENrsVczRP/vXdeNjNHx7KfIuO3QlZsmt1?=
 =?us-ascii?Q?fQpEPlwhZ0O6633SmssAPxbVeJCg6DQUyApIOrQUDyU/tEg6uQ0s754Q5q8F?=
 =?us-ascii?Q?wKoisLP7wiodBkyrFt3Ee3A7df9yWXcbVDiPW1faCZxhVllF9NU+l/ovuyI0?=
 =?us-ascii?Q?UvuHl58KyxoW0HB3IzFBFTHxZS3ZTIURkHVCLagLBN6o4qc/28QQfl5+hfwH?=
 =?us-ascii?Q?12DDjwfPxs3CH4IJGKtiw4Wh6iXZlpM8qTZoKDIHFC5j+M/fUkNDkHQhemrP?=
 =?us-ascii?Q?UIy/Fvxk1wQqT1nWZQj2y9Jrc3zHUlP7yQxalAcnG8K1kxlj4qWCOLJ4QqOY?=
 =?us-ascii?Q?mfbxMDAvDPmPxBlZBEZ6TA6ssUd7xWZT7hS2L+VpCIGJqO6LwaeQMOjahRlo?=
 =?us-ascii?Q?Q+qJQIEzLNbCwg14SjlBVwBIHJrx28WfxAoQsSREn1npMoPpC9oTln5M+fov?=
 =?us-ascii?Q?A8rSw7eaSj1QB0lq8Y4rLJhFYdKCSDNGJPCqCOBRZ3oKahsmeF1MsDrcb2H4?=
 =?us-ascii?Q?EEWhCd5oXPgXQDN02NBPgel/5514f3l/D+ybft6IAD1LhC5VSrNDvaUMl8XD?=
 =?us-ascii?Q?9ORmsQlZ15hr/OqJJY9dmxVAAUDtWw9LVRe2C2YasiJK2iA7JcDYfCCKBlps?=
 =?us-ascii?Q?Dd/TojZONjotJrI1R1rG07nujuc18DYnhrCVCcZzSXqhYYuA6l+bYfcENAqG?=
 =?us-ascii?Q?aL14f19eyvBIb88/DWJuRdkfWDumc3AjtzpU9zuyDyVqtc8vi5k8wHj4606s?=
 =?us-ascii?Q?rYVRVsnjOogL3QCXaBktbd716hVBOSKH77GUaiufd6LB7mzZBgztLrfyHI1V?=
 =?us-ascii?Q?Lp/eoay9xEayXSKKeZko6ONWhqPQgN9rC8y3HuTTJYSz+JajiVOUKwVQGNvQ?=
 =?us-ascii?Q?duObGLJq4Ndf/yamfl7gdBvAKNocuUCQdgsziWOKtzPfY0YTogEY5pDwPQ00?=
 =?us-ascii?Q?g0QO4Xis49PQx44rtlsMrb+pIlzx7dmC9opk5pexL29PibCkhHe9JK+WkISZ?=
 =?us-ascii?Q?DhFZQ36ZesEazt9pJDjyRsdpZuCozkIwujbye8rnPadrExJ9e2fvBho7QbW7?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08ee8187-2267-4854-dcb7-08da59539cfa
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:47.8284
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TyTkw6YQpbxu3TSRynHPdLujXOHrBTxd2qUq2jV/2UBXgh3Nwdn1ipZ2Riwu8MYzgIKt2vLNk/oOXaFhuEfEOw==
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

This member was used to pass the phy node between mac_probe and the
mac-specific initialization function. But now that the phy node is
gotten in the initialization function, this parameter does not serve a
purpose. Remove it, and do the grabbing of the node/grabbing of the phy
in the same place.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v1)

 .../net/ethernet/freescale/fman/fman_dtsec.c  | 33 +++++++++---------
 .../net/ethernet/freescale/fman/fman_mac.h    |  2 --
 .../net/ethernet/freescale/fman/fman_memac.c  | 34 +++++++++----------
 3 files changed, 34 insertions(+), 35 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/fman_dtsec.c b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
index 84205be3a817..c2c4677451a9 100644
--- a/drivers/net/ethernet/freescale/fman/fman_dtsec.c
+++ b/drivers/net/ethernet/freescale/fman/fman_dtsec.c
@@ -1463,26 +1463,11 @@ static struct fman_mac *dtsec_config(struct fman_mac_params *params)
 	dtsec->fm = params->fm;
 	dtsec->basex_if = params->basex_if;
 
-	if (!params->internal_phy_node) {
-		pr_err("TBI PHY node is not available\n");
-		goto err_dtsec_drv_param;
-	}
-
-	dtsec->tbiphy = of_phy_find_device(params->internal_phy_node);
-	if (!dtsec->tbiphy) {
-		pr_err("of_phy_find_device (TBI PHY) failed\n");
-		goto err_dtsec_drv_param;
-	}
-
-	put_device(&dtsec->tbiphy->mdio.dev);
-
 	/* Save FMan revision */
 	fman_get_revision(dtsec->fm, &dtsec->fm_rev_info);
 
 	return dtsec;
 
-err_dtsec_drv_param:
-	kfree(dtsec_drv_param);
 err_dtsec:
 	kfree(dtsec);
 	return NULL;
@@ -1494,6 +1479,7 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	int			err;
 	struct fman_mac_params	params;
 	struct fman_mac		*dtsec;
+	struct device_node	*phy_node;
 
 	mac_dev->set_promisc		= dtsec_set_promiscuous;
 	mac_dev->change_addr		= dtsec_modify_mac_address;
@@ -1512,7 +1498,6 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
 
 	mac_dev->fman_mac = dtsec_config(&params);
 	if (!mac_dev->fman_mac) {
@@ -1523,6 +1508,22 @@ int dtsec_initialization(struct mac_device *mac_dev,
 	dtsec = mac_dev->fman_mac;
 	dtsec->dtsec_drv_param->maximum_frame = fman_get_max_frm();
 	dtsec->dtsec_drv_param->tx_pad_crc = true;
+
+	phy_node = of_parse_phandle(mac_node, "tbi-handle", 0);
+	if (!phy_node) {
+		pr_err("TBI PHY node is not available\n");
+		err = -EINVAL;
+		goto _return_fm_mac_free;
+	}
+
+	dtsec->tbiphy = of_phy_find_device(phy_node);
+	if (!dtsec->tbiphy) {
+		pr_err("of_phy_find_device (TBI PHY) failed\n");
+		err = -EINVAL;
+		goto _return_fm_mac_free;
+	}
+	put_device(&dtsec->tbiphy->mdio.dev);
+
 	err = dtsec_init(dtsec);
 	if (err < 0)
 		goto _return_fm_mac_free;
diff --git a/drivers/net/ethernet/freescale/fman/fman_mac.h b/drivers/net/ethernet/freescale/fman/fman_mac.h
index 418d1de85702..7774af6463e5 100644
--- a/drivers/net/ethernet/freescale/fman/fman_mac.h
+++ b/drivers/net/ethernet/freescale/fman/fman_mac.h
@@ -190,8 +190,6 @@ struct fman_mac_params {
 	 * synchronize with far-end phy at 10Mbps, 100Mbps or 1000Mbps
 	*/
 	bool basex_if;
-	/* Pointer to TBI/PCS PHY node, used for TBI/PCS PHY access */
-	struct device_node *internal_phy_node;
 };
 
 struct eth_hash_t {
diff --git a/drivers/net/ethernet/freescale/fman/fman_memac.c b/drivers/net/ethernet/freescale/fman/fman_memac.c
index 039f71e31efc..5c0b837ebcbc 100644
--- a/drivers/net/ethernet/freescale/fman/fman_memac.c
+++ b/drivers/net/ethernet/freescale/fman/fman_memac.c
@@ -1150,22 +1150,6 @@ static struct fman_mac *memac_config(struct fman_mac_params *params)
 	/* Save FMan revision */
 	fman_get_revision(memac->fm, &memac->fm_rev_info);
 
-	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
-	    memac->phy_if == PHY_INTERFACE_MODE_QSGMII) {
-		if (!params->internal_phy_node) {
-			pr_err("PCS PHY node is not available\n");
-			memac_free(memac);
-			return NULL;
-		}
-
-		memac->pcsphy = of_phy_find_device(params->internal_phy_node);
-		if (!memac->pcsphy) {
-			pr_err("of_phy_find_device (PCS PHY) failed\n");
-			memac_free(memac);
-			return NULL;
-		}
-	}
-
 	return memac;
 }
 
@@ -1173,6 +1157,7 @@ int memac_initialization(struct mac_device *mac_dev,
 			 struct device_node *mac_node)
 {
 	int			 err;
+	struct device_node	*phy_node;
 	struct fman_mac_params	 params;
 	struct fixed_phy_status *fixed_link;
 	struct fman_mac		*memac;
@@ -1194,7 +1179,6 @@ int memac_initialization(struct mac_device *mac_dev,
 	err = set_fman_mac_params(mac_dev, &params);
 	if (err)
 		goto _return;
-	params.internal_phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
 
 	if (params.max_speed == SPEED_10000)
 		params.phy_if = PHY_INTERFACE_MODE_XGMII;
@@ -1208,6 +1192,22 @@ int memac_initialization(struct mac_device *mac_dev,
 	memac = mac_dev->fman_mac;
 	memac->memac_drv_param->max_frame_length = fman_get_max_frm();
 	memac->memac_drv_param->reset_on_init = true;
+	if (memac->phy_if == PHY_INTERFACE_MODE_SGMII ||
+	    memac->phy_if == PHY_INTERFACE_MODE_QSGMII) {
+		phy_node = of_parse_phandle(mac_node, "pcsphy-handle", 0);
+		if (!phy_node) {
+			pr_err("PCS PHY node is not available\n");
+			err = -EINVAL;
+			goto _return_fm_mac_free;
+		}
+
+		memac->pcsphy = of_phy_find_device(phy_node);
+		if (!memac->pcsphy) {
+			pr_err("of_phy_find_device (PCS PHY) failed\n");
+			err = -EINVAL;
+			goto _return_fm_mac_free;
+		}
+	}
 
 	if (!mac_dev->phy_node && of_phy_is_fixed_link(mac_node)) {
 		struct phy_device *phy;
-- 
2.35.1.1320.gc452695387.dirty


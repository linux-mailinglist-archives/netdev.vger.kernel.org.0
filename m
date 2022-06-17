Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A03F554FEFF
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 23:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383372AbiFQUhP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jun 2022 16:37:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381567AbiFQUfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 16:35:38 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150041.outbound.protection.outlook.com [40.107.15.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC0565E779;
        Fri, 17 Jun 2022 13:34:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wnoce2BoY/C0mvGtRCylImoD/xLLFQIaLed+O9pa/wFn3Q+y0GMTU54cZn+/t3+bi4cOVJ3u3+nms6vm9N3OezwuLMRhmfdu6DohRxSY8dKdC33jNnMXn5kMzxLSqazJucj75uLV5kD2xJ/RwruHVLrEsg6LsOgxmRG/gQiiHxLEBDv8vUbMWeHZoPzsZOP37+yZE60J//OlvGl5/Nb+6Ez2tnHznE1thVh+QZkfWO0o+EG8WRYKaaCB+W57B59qvusVQwUZAgFNFwJE7bWVwQWaqYczWQO8IK7/Y6olNSR8Bpsm4Zp+SdlqKeLqUycbthdpNFXdIB729K1V02D5AQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRXdOzZCVi20cnxpkis9AW2G3rEewNquMykS9YgRyYk=;
 b=MZ7ogTCtVRDLwCfZP0Iz8xWul5YoceAosReRUv8oqsjZT3xh479a+vvJZ6XkAa1P8I2G7ZJY6ONlhPIIwn/pVbN/YkEZDnjq/hK2CcfBPV7CZnOlZRr9d37pEmVA4zAbrrpXuqcpc4QjqVSr7zX3CgWI6ILdZlpMB3M2ov7gS44caYgcNPctJarnWscQUXwI0XJRpuStZITVSLUcnA4KpM/lOoCdb//ttc/EsPxxbZresWcpuXvC4uRQDJoGqOrjQ0erOqnJd9t6LeKVlCPysKPovUkFZEfUqCJAlZiLnJOk8SXyZouz7f+sMvaZ4+Mp0yuZxGfrX1ZTyFRjngV/yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRXdOzZCVi20cnxpkis9AW2G3rEewNquMykS9YgRyYk=;
 b=KnFo6HHBXrV44zc0VSJe/qeDQLgbdzj7Nt4sJ6JSFepA319DtfzePjRibtZtucEY2omeKxRk/5puspzwNUgSrkxYbXvRgP/+B23vlxun4yc0fa7hQpLRg+ng/Kg3zgythCPQjfNvaYWVjlY4u9IPN+HNlV/ffEShxhBRflNS2Zhqjkjvo9/Rh5M7snjM+wuehICwHHJCPmVcLxx5/15bbs0nDAxnI4puAh9zF0VR5AvZLoKCeTJ2fBzMnW54oiJ6yPoFmI49o2G2tMAKSQvVxr1GNTASDgj175Mq7ipk832+c376mX8Rpgbws1qO/R57immg063nAo2YwJRU/4aCmg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by AS8PR03MB6838.eurprd03.prod.outlook.com (2603:10a6:20b:29b::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 20:34:16 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::d18f:e481:f1fa:3e8d%7]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 20:34:16 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Eric Dumazet <edumazet@google.com>,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next 21/28] net: fman: Clean up error handling
Date:   Fri, 17 Jun 2022 16:33:05 -0400
Message-Id: <20220617203312.3799646-22-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: f72d07c8-f5f6-4fc1-6bf3-08da50a0bf23
X-MS-TrafficTypeDiagnostic: AS8PR03MB6838:EE_
X-Microsoft-Antispam-PRVS: <AS8PR03MB6838D24CF85B5E241B969C5796AF9@AS8PR03MB6838.eurprd03.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3N70+p3NObThny4OeH2VsT1NB0CxnOvmr2KIuuqAp//0Q0nUNAxwsnb3UW18WX3kZNE2HdSZRqm0XmYGLNSnFPI+TkBV7KFBPS1w/t+bifPQeqN4NzU2S3AgygGZ4jfzBQWHKzjbBBBpEGkB6DCwbJBxaisItW/j8jkxeczQrra6QQMTuYMYrqRQ02r+G8/IhkK2f/QdQMPYUmDde8bPXNyNOnQ56YRCn0wQfLKf/VLrRopaSsXr/HbdOJ2D+Zuxpcd1U4NwgXhgQQb7XfbqBmQ7JK4SfK5LDPwxSrGhR/zk9YzsmD2mWPj1ug3RlvC5AtC83IRaecV9mzpnDorAZ3RJInFNUFG9UopdJvhA483nglmdIyLe3hP2+hRQ7G4GkyJFFLN24gfmX3eCIc9NEvz4DGZxrX5JQSFMnynC7G+EITuHSR05/d+B8kGT/6VvwoO16b6/ebgwtgvBI78b79QyY3FYt7GjT3wNfrMcweoToB+5D14+XFxEsafIcoI0z1U8svRi6zGyFbup3g4USJD4KFm9A2CZw14TVI4Jv55Uu+E6Gj7vo/QE+5qWQUKbWfSNlj67g/hEUh+mXqOfm8x8earum5l9k8WAG/dwNK1K5UDD927avoDo8Psj7iAsHFurjBrxJbKmEonatiHeuLe3r2x6WAfbhgccXpNADaLsxJIDwCbpjdxztyobkfEx5c+ZC7CtPoJ/U84cSDiucw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(44832011)(2616005)(38100700002)(38350700002)(8936002)(52116002)(26005)(316002)(36756003)(6512007)(2906002)(4326008)(66476007)(6486002)(66556008)(6506007)(5660300002)(107886003)(83380400001)(8676002)(86362001)(186003)(66946007)(6666004)(1076003)(54906003)(110136005)(498600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?TnsvjU0xPekrL+Q2VSC8HlHYhF9T3woZiGJg7ylBjlMQGLbLMMvSJN1ZyKAn?=
 =?us-ascii?Q?5lUJsump2MxkYqb73aQ4EX0iAEFBVbdQPf24CZuadKkq9T+Y5xbrQJdwGGes?=
 =?us-ascii?Q?jjPOcXDuUYIzvaD0ok+ktq9OY98yWtyknsmbJcATWQ5BhswykAuzUMfNVU5b?=
 =?us-ascii?Q?fuhH8OxXEyGqcAX4bXiTr6m+zdPh0SMwOWeOEDE2uKRFFZMRvvUKJnizkQxA?=
 =?us-ascii?Q?YY6yAUQeQ87EsIM00hsQs9NcHgQIpf2ark3hfwKEtGycxE1Inw1XOmWB+2+E?=
 =?us-ascii?Q?DOhmCFn8/zEsCTxR87FNWwVWi91FAoweaXBiiEBty9qNOdM9vN0zQYu/QiqW?=
 =?us-ascii?Q?JzGACH79TAXiPRBM+8CNmWdx2o7IIjuhzY1r7KIAjw7NTYzJFQuyyCEZsh/+?=
 =?us-ascii?Q?woFpMKGWWnLgyPP4pLRhOTNtNXyYJJ+XCMILVKqoK6+rJRC8CsHlzmflusll?=
 =?us-ascii?Q?zjolqRrUNV6vVr/q+e+ogzx1+PsobDt5sL8Tkl2gt7TTambCD0IZsUNSRgSG?=
 =?us-ascii?Q?BgjvA3+PHV+FlDZ5j2mqCqEXIvsg4ziSCjhZJd5BIZRHJ0XnPEDAXMERfe1J?=
 =?us-ascii?Q?iUJCJxTapu0jtH4qrZcOy7Lnl8D9uVWfFyZGv/U/uqTCgT2sRIYZFqKwkWki?=
 =?us-ascii?Q?QG4N16u78WfVopoq+7/v/ubQUnU3kAsojd6t4FyAsp6HER+nQ86aX48ipwgt?=
 =?us-ascii?Q?7/t5XnnP4sWu10M7Bs7dHbqC55B0Ucp9POkmXo6WpoNTPA+U5iOV7ZySo7gk?=
 =?us-ascii?Q?AJ+GXV3/DsqzGb2cs18li6gN87/DXqxRZiOoZ3UAKX/sXo86WtA/kQNPzcC5?=
 =?us-ascii?Q?sl93So8fpjhb2NEWVwi3k5mFEoCnD5s48Owz/AIr9ACTnf1fYCbncvaaeIpw?=
 =?us-ascii?Q?SqM7OzX+/L0AJ7DEAKquKwvaM0OfZ5G1ZretyO2ROYf+LF8j30mvQhoyE9MQ?=
 =?us-ascii?Q?VLUyAwgC8BZdAQ2u89qlvfO37zz3aIPoYiVVvjQlGlzEZdlsdFj8weL7DU+G?=
 =?us-ascii?Q?awSEEB5iIgLL47Edp5sJoXK4unbitED0StQ5sICfQ3eCGGeBbeoyaFi4cMmM?=
 =?us-ascii?Q?DqPNHaLanhpg5ZzCZGha1YULXWkhPzIykj7LM+fh1jTlNcQFWbUUWAUK/YZp?=
 =?us-ascii?Q?B423zK/6raqk87mbsKpt98JHuzwGyzrXJ601sbQsPNUPJFuxBNh0caRT47O/?=
 =?us-ascii?Q?N3Mu9zGTXHFmeTiO5lBoxmxca0uCCZwRNUcRnIc6ScTindt9sObyiCn5CZmV?=
 =?us-ascii?Q?nHr7F3G/HP+cgL1g3J2mH0nogyKtYWLeM74l0zA1Iy2cv5uhC/JA0Sdpdqvw?=
 =?us-ascii?Q?Oje1y4rl6DTKN0kzK7qhF8pZzcW9S35F8KODYY1XfnRKltLyALMz5/fTulvH?=
 =?us-ascii?Q?EEi0mnC2fdiB2Ks9HSgxXLK6olLVr7EOtLyHrQELiGSOXy3pwfgfEt+t1puU?=
 =?us-ascii?Q?/htCj8zdE6Gt5AewpXujXYGbtpyCU5imnvrK624xcwbXw/5H2u5WfhZfyW0q?=
 =?us-ascii?Q?OzWOIUGL5gWDCg3zGS/THyDZQPnZ3n1iyt7aseiiyPH7uboPg3GCu0CN5rAC?=
 =?us-ascii?Q?kaZJuYwXwqNmSXgi6wP9RW2F7gASaojBP+rFgnRSx7ZQIUjwcOdkVwDV2Lx8?=
 =?us-ascii?Q?mNBZqVYZ8qOutdHOHSBmVo3jySN8lSpatS+nDFQiMyNgXZUSf5Fw03nUrrvg?=
 =?us-ascii?Q?rqLd4/uehg+WB9acSNUZ6KFWvJ3ngTibqtP+yYoVtpYjfdm6Agkq8ZiGKOTB?=
 =?us-ascii?Q?93SgtmM59VCSdltZY4ojBgiUKlAb+/w=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f72d07c8-f5f6-4fc1-6bf3-08da50a0bf23
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 20:34:15.9355
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3fp5DLcABROY7He1UDJ9xTklarL7b4OAL3g2DVsBwYG3hZI3uREdDyh4JT915QSr7N/zaxfFyECMFTmTi6Usag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB6838
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
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
---

 drivers/net/ethernet/freescale/fman/mac.c | 43 ++++++++---------------
 1 file changed, 15 insertions(+), 28 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fman/mac.c b/drivers/net/ethernet/freescale/fman/mac.c
index 88b9174531a6..c02f38ab335e 100644
--- a/drivers/net/ethernet/freescale/fman/mac.c
+++ b/drivers/net/ethernet/freescale/fman/mac.c
@@ -296,15 +296,11 @@ static int mac_probe(struct platform_device *_of_dev)
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
@@ -317,8 +313,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (!dev_node) {
 		dev_err(dev, "of_get_parent(%pOF) failed\n",
 			mac_node);
-		err = -EINVAL;
-		goto _return_of_node_put;
+		return -EINVAL;
 	}
 
 	of_dev = of_find_device_by_node(dev_node);
@@ -357,28 +352,24 @@ static int mac_probe(struct platform_device *_of_dev)
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
 	mac_dev->vaddr_end = (void *)res->end;
 
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
 
@@ -392,15 +383,13 @@ static int mac_probe(struct platform_device *_of_dev)
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
@@ -409,8 +398,7 @@ static int mac_probe(struct platform_device *_of_dev)
 		if (!dev_node) {
 			dev_err(dev, "of_parse_phandle(%pOF, fsl,fman-ports) failed\n",
 				mac_node);
-			err = -EINVAL;
-			goto _return_of_node_put;
+			return -EINVAL;
 		}
 
 		of_dev = of_find_device_by_node(dev_node);
@@ -470,7 +458,7 @@ static int mac_probe(struct platform_device *_of_dev)
 	if (err < 0) {
 		dev_err(dev, "mac_dev->init() = %d\n", err);
 		of_node_put(mac_dev->phy_node);
-		goto _return_of_node_put;
+		return err;
 	}
 
 	/* pause frame autonegotiation enabled */
@@ -497,11 +485,10 @@ static int mac_probe(struct platform_device *_of_dev)
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


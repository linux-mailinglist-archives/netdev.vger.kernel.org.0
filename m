Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A92175ABA84
	for <lists+netdev@lfdr.de>; Sat,  3 Sep 2022 00:00:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbiIBWAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 18:00:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbiIBV6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 17:58:30 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150079.outbound.protection.outlook.com [40.107.15.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BE0F8EE6;
        Fri,  2 Sep 2022 14:58:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2+q45ED9FE73+iCNUqLi9OC4o3vB8MMWJrs9CYF5spDE1RcFS/Enr7aFC2e+r+tnhPF1F88+5nVMgOn1qnu8PgnqCYXnGwkE1gvRMiNfIX7A5eA4EovcgYSkWRNXzRYMblj+w3KPlSuSBPE2xIRTkAjZ/8r0c4Z3dvTfNaFfYO24WHDKuR4Ei6xgGEkb6l65hdDU/1ZKPDu/MagSMzczlveqje0bcO2/2OWZInyjiHjGtfvUNSYtRdNvTF1VVWoYsgo4msk5v9LF87NT2Y0I6bSCTZdhJl8vCObSeiO+vsOFFn9grc9LF9G7xpNQpYVHWNXGW7wy0BUMn+sIi1Zpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=F39VOWHdbomM6yNOWWJ7eMkODFt7MS7bR17qY8C8kTQ=;
 b=S5RqtxAPCSUiMOtfDiKOMhijLKnV8Stbql83sKYB2K8lq1PN391anw7RIUSVzzdLZZbkA3FmKvCn3Rn+PlLjlPsZtKFZZ/1+3V6YXC74zKg5vYn7r4s2h7NE3xjKTU/6wIMEX97kWMgMEPYycdVgs96QD5EJ+lFTVRmwLJqIA9Y45UcDZxCexPbwRBC7pTUm1ESZNMYEkfmbIxxiA68vPEK1TjfzQxuIcAP9t9mbiYprD3bkmWQCtUAzRX52qLrgv2vjstcHNIQgSJXY5WqujkvwfkZ9MLTAzedKtwho/xx7Kw5mfo+JvFy5f78q6WmGXCPyspRB35A2KvXwDbZtWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F39VOWHdbomM6yNOWWJ7eMkODFt7MS7bR17qY8C8kTQ=;
 b=pS1V3JL70y8vxeXNNszEyRGCZADgtSXi5Cgka4sdxQKM7vU4ZbYsyZ4H7PW3kzbs8Kh227IANtGiLwSeNbTz4n5Pp6pYVpB3MXx0+83IQ3iBcFFR/Sd8mdVPLownOJ41fE6YZ6G3sUGWoztX9Y2DuSUNsR8c7d5ep2EQlKrXnHos66Ax9LZ5JUiMXi7tBrBhFyH2O5fjviyS7vyze2SPCqn1vRnKuPyIB8s6jRa7kIl3ephza3Bom7GhIAAO/2YjSk1gVWLGGztjzaQRJpjIce7kNudfYMqtc2U+3XuSn/QVgQyQfbRDhuAtYURdSDfyZ04v5O/+cwTfGEYWEibbAQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM6PR03MB4085.eurprd03.prod.outlook.com (2603:10a6:20b:1b::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.14; Fri, 2 Sep
 2022 21:58:07 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5566.019; Fri, 2 Sep 2022
 21:58:07 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org,
        Sean Anderson <sean.anderson@seco.com>
Subject: [PATCH net-next v5 09/14] net: fman: Clean up error handling
Date:   Fri,  2 Sep 2022 17:57:31 -0400
Message-Id: <20220902215737.981341-10-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220902215737.981341-1-sean.anderson@seco.com>
References: <20220902215737.981341-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0315.namprd03.prod.outlook.com
 (2603:10b6:610:118::15) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50911eee-2a36-43c4-12b8-08da8d2e3782
X-MS-TrafficTypeDiagnostic: AM6PR03MB4085:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TVJ5TGBy4HOikSQf6CS57HfAF5mz9vTxl2Ifpg+xSZNrlMut8DsKoRyqBe3Z+Qs+CmPa0Rk9WCWuXV1N+38bB0mRIxDR6mGmqxgjb+xt09IZLLWprZrAP+y/OhW+RJ+kt6haiCSuXJ5HU+6YZLZhMporVIk/bzyI7EIrq+rpPszdzecjJwE9yz8ZHDG9LuYV8AMwwh4mCawmEtcncj/BYlqc98HK4ohoZUfLI4DXJ2VBF6pKs8HmqWowvT/cq3r1nhS+fX6oGPg+pWxXtq2fliBP1h+4rDZKb7Ok/NAjQZJUyNtxakZs2/U9j1TreM4vEyzReusORLeoBPFcfJQTSfI5Xa6PUt4oBBZhJonAN6Bc4OatvTU3JQjPT0S8Yh7qdxTVcHPkMQB0jRQw+W3RPIs6pC7cHcSnFnAYHsDTAfPYI5rRXYijLn/JIW2c0191TceOOuoZAIKe0ADZM6h5PhsOa8o/N1qQRF+BbDk5UNFkUFgySyysqcBrxkZ4JAmqgLAHh0PAfZuOVxjTR9vGsfskU5vQKRGT/WTTQtlq73nsobDKWOuIlkqoDok50zoDWfbdW8VUYDUcXXQkxk1D0W8mVsEGmuiNNt55MkA3nJmRY6ZvMtGx1lLBxZHYVdimITbFAnGZ9YQV+dmXfeIASn6DurTuDnzFvDsBfec+5r/07ot1w5kx6HYtRwcMYMUVU7fNzxqBb2HRgx5HEMUZcqS9DO9/lFB2avwBFf5lDkgSdSz12jyhKxfxnLOmvCKpp2Pm/RA7M8FxEg2cMvKcZw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(376002)(396003)(366004)(6506007)(6512007)(26005)(2616005)(186003)(1076003)(7416002)(44832011)(52116002)(8936002)(5660300002)(86362001)(6486002)(41300700001)(6666004)(107886003)(478600001)(83380400001)(36756003)(2906002)(4326008)(8676002)(110136005)(316002)(38350700002)(38100700002)(66476007)(54906003)(66946007)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SM3y6GswtlxeHcuVj4E4S8docDs9j6+ybl3/8lV/DSoR0ggsxn/LFJL1CUVa?=
 =?us-ascii?Q?93FvJj3L9tLqxQszJlLPXP3/BlSUcL9H8NgjnklsPVA/veq8VCW/QMAuGjFQ?=
 =?us-ascii?Q?F38cvd7GGC9rhafRmaetFQ4YwQ6jTtfQM2tm/ueUPeSSKXetGAnBxubDCoy6?=
 =?us-ascii?Q?GPtGVC7uklcbwpB9MLDN20MIVzCGTSBVNBnhgegnKx/55p5XKiElVZDPzzxz?=
 =?us-ascii?Q?8hT1HC009UUWkcNaRxwpDO8wlaxDtrxtFax5CS91gThS7Lbf+sRQ4tB0mHLK?=
 =?us-ascii?Q?J6HMBKm5nwLomiTE2hA+NTK/UF/l/oecEWUxOSi/7sQI8C3JJXKGDZid4Ce/?=
 =?us-ascii?Q?mSmHhuVgnmY7nzURVG2mcz0DHummlX1UZcMo2ESQlPsuh+i1Gndr9cWvZ3gc?=
 =?us-ascii?Q?wGHizGXo0nXKezlacvLFq59RdZ9yS9CM5HK74DfSZm1bl7rsZT2S8NzDs9DF?=
 =?us-ascii?Q?gX0JAKqU10sQ4XQ22hNtIDuEE5orbf1L9BwMUPXTjEhWtS+KBp5IizCr/hx6?=
 =?us-ascii?Q?CV5ZALkR/G4aUdfeuv2uPBH69Nc2aCL+0Wke6b6p32jLvwfpCl6qK5nIMQMl?=
 =?us-ascii?Q?DYvPTU/XhFRWNRcxddVTe3ENjrIDJKn19w/BeBBDeW5kLPuxG0r8QgxYvJYQ?=
 =?us-ascii?Q?cVMNRqk0+8OpZBPSrwP5AON8dloAs3NmqXh0HkcL4RCGsUiLktFnT+TC2xKV?=
 =?us-ascii?Q?6Gu8VQad22JZbb3lBNfudQH/NWpST1tj0/vygXKEGQYDo4FWrMnOfwDK1YXr?=
 =?us-ascii?Q?bn/kY5f1tjF1NkelJL5Pnw9jtwPzd7JIAwaI2SfO81Qyd/AvG2Uc27bnr+/h?=
 =?us-ascii?Q?ZNF88T9i/0+qjHA7tyjVEIUQuagGTATGe5iTY0PgrUEHHYSmdawf+8G3UUWg?=
 =?us-ascii?Q?Tjn+N98hhufcIMp6EOVaebV789J6fNIMmw4WmJabOoRStLmr35y2+BegEL5U?=
 =?us-ascii?Q?yljZmHT4FkCb7LZ03JP51fAYf8KR18dww14EimieoO4PqDiIWd35sRwFr1y/?=
 =?us-ascii?Q?HuWcxg12WeFeDVtJQQbavp/88JxgbpCIhzp+la+5aCPcqSnCR4Al2kmcQ646?=
 =?us-ascii?Q?+dXqOYfieNy4usUXEfL6ZWHiAwFaqmy3r5OdS7C1DY3Q7cm8RufbfW1PRs7E?=
 =?us-ascii?Q?gRtzynmVIh3/yRFUvY8kWDZNBLcAZ5CUdrvjdl4atL+VaVQaivHyygGPtX//?=
 =?us-ascii?Q?yGh+JyVOwL5IKFZtZEIvch5VWdRNSK+QP+VIshzQfdOekJNxgWWDXjHeeNxY?=
 =?us-ascii?Q?QYL6S1786kGkeIooggSg8qUvtNkMyE4RRm138QvtEIPX4JcxiHOlubq1uU+M?=
 =?us-ascii?Q?f5AgAQGqhIUI2+FQLe4y4fTbNH7DaQ4KbPkSRwPh2ohN3QCrpR7G1HT3mGnl?=
 =?us-ascii?Q?/cUWd5GzrM3xG5rMvjhtgjP7qOqORekfcw/NU3u4zqOkWuLPk9jFjsX8+R16?=
 =?us-ascii?Q?cdHu/NQuH7QCHHDVsZ5+T5/rfywp0fBTZ+yoCST4XOYyrENOpqFeUYSqIWKs?=
 =?us-ascii?Q?YLv+E/Q3RzJWSnHWGK6uoRI+YdP8RRVSG7HqTj3hjaQ6sICtREBEQuCNSzR+?=
 =?us-ascii?Q?yrQ2iMh5ue+nS+WdhgvBt6No36SeSbC4h1aFBvOmlLWuOJwEMuqoU73kc8DQ?=
 =?us-ascii?Q?6A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50911eee-2a36-43c4-12b8-08da8d2e3782
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Sep 2022 21:58:07.1098
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uyBgAIyxTKw26l+lacoJXHUmPKXhhXlwxqgNUqqS/1Xo0VRGLM6E6L35SeUWLEaKuhW4dxLVnhTXNLPxhlV6Qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB4085
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


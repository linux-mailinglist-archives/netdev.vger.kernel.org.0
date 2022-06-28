Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F6D55F11D
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbiF1WRw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:17:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231537AbiF1WPl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:15:41 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00086.outbound.protection.outlook.com [40.107.0.86])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF6283A1A6;
        Tue, 28 Jun 2022 15:15:06 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFuq4Jn99nKyf5Cmbjur73WrOicv88pI/IULRa71B/BcnIDsf4zgkmK+T+tKPlZB2buzXhL+vtzd0JS4FdFF5F/8u7AVBp5Qa/91lhw3OlROtQBX/CfP34/VEu/u2uwlQxzm4RigpCts0LHbOPzuDuZwDNm3fmZ4QjhF4k6Cb70pBTnwaMGYSMeoCdDtvhIY4M7jvgFXCRVzOXTI5HFc8SfTYTNFtPkf+rnLRAxmnocqZQd5YW8jz7BvPuAp3w63XUSqGFJlpt51mzmCsesQUhuRMHE4WzIBuKotiJ7L9kSwuRJcnPHF7aI3YCBUoHAqlKxzyWajAX0jIaoQfeouWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=t6F6kJr389oREnPSKtMqwsCZtWk3wAG2vXWfopMgx64=;
 b=EhgYznS9dDZKA2An13/L7mcBdo+dxu1YzugBcRKGTzm0RcPxmOSsd+xUaHIUaeE3Myf7oxK24BN32TbdAy5N6+sv0+F6pqAybWIvGs8bGSjg1LyTdhLY8r/aH/8bUq627NXqeZVJLP+/2KiZjpGhPmU4T/LDQSlecheEGiJDJCbcs+JjpG4sB2UHCZ1YWtm0soRwpb21pE3GwifxV3jz+OToI9ftiqxyj7igjsSgh+9pOJyXDbsYBI8khf1sjQ5+XyHC5+NWjd650oun8tvccOrjAxvBTLonZx0lwOc2aO0hLCWC2yc9N7x6k7V5624C+SzSLm95EZMqAm8t9yZtiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t6F6kJr389oREnPSKtMqwsCZtWk3wAG2vXWfopMgx64=;
 b=BidmpD+gSDDZCvObghMndCHfUrc4EorHLFqhGhnhJujh9Q9qr99/M2EVxkFqFJz4gJxFOyd0xSnBbZzsmKLGLJHEQ0dyo7hm74M5IkihB98hNqOuia3k3BS+mM5pp4e6HcKslu4+hrdFBna753selT12xaHvQcXpkRqsZOMSIGXCK0KMuHpYkaZ3z8TB0b5Kj/4nXcO/bXUvJguaGngsAnPL0tACcE7LuIFV8fQo0kmAAttXiMCEMEghh7Zo8IzeFrtLQpqijPlFRkd2q+GbuTx7QyGBB7gJO9WzTF3t0u+sBvUtgaWXEd/KFcDTVERlD7425PnyaUoKxFPWWOSQJA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:55 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:54 +0000
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
Subject: [PATCH net-next v2 23/35] net: fman: Clean up error handling
Date:   Tue, 28 Jun 2022 18:13:52 -0400
Message-Id: <20220628221404.1444200-24-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 40525e28-6bb8-4004-359c-08da5953a135
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 78qwrstOVu44Tf1X18w59fUtPct+QyghECNMH58SNrO5jP0vQ1zd7gbZ1whRXhkl19QucgSWiAyQJAkn9nh5kTVyucODewUKd7ZbmeV4hD0Lhp1C04OYShfK1y89ivRnFkbzUHCev403q0fvTCGHgZOu/ylcSTVSACQys0pCkWHcvcKoemkFJK7tPAeZRHKNQdcs4vwDWkN2brAkRjXpVSJx5Du3Tu+9oUDXFB791UEaySYYKVejcaYb708ehz/HtMy1ocFQMdNNSvd3xPofoiTYY0yO3tYjfH4y7TcTquys5skqt31j0KQH7o29zHu8HC2nevm0R4fD010CjoVgVZWh6ibMY+2uu0CZugRSbduNbBbzDV0YOYd904i3A3pfVTGEV8oLiz9Ubnq/5ClhVdpmB2iEU3ZosrzDGaXicR0/71IF8j3OZcTq/Bukxn57BSlCQEerws2xRkixfFVOz/CHZ1T2jU5oG/vll5UoW6vpjBYX/5tuAxOfIqUZMkanGX0R/8HqZK3E/r3Rd3I88Dmx+XvEhSk9FqeGBqW5p40V0Bd7qZfxcmivnsGFNX2nFFm7+716Im9lyLeubS/7gJZ1IeH7ZCKrkuPKSMAQJlMF6ruOc/9SmHRE3iXiA8ennRhKZU0xCiq3QsKmmHdsQXFlrYCvSLoUB5VZUada/Z6rF4pSLCvikUxXz7PQ2SpSHsCtkjhkyVcVhWRLgY4noHKyuYqQPyVVQYp4pVPI+Krcf6S3HTXZ2nyN0vbyHh+7sn6t2S/zCZBan38DG5zM2jamfwHobRn+wv1PMr2LJ10=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(107886003)(1076003)(66946007)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/OGx9e/UbdYdm0bqg/Ei5l3MRoQvxE8l9qXEAjMbCjcB7pGKc5GG6lQ0xj0k?=
 =?us-ascii?Q?CsRUUdrpSawnh/FcybhjpTKz+ZAdAJg0yOE9hFHRSGSgRcR6IYVLLAR9IaNc?=
 =?us-ascii?Q?+Fn0eeoaPdljmNOGpOzlZ+VjHKvWPbc0aza/EW3tDrt6gKjQfGfGo5xajPo4?=
 =?us-ascii?Q?npeKNdJVIRnFwqMjvXpII3Op9GPzuygwIIbRRB2bTOM0kE5zPoEK3wM63Sf5?=
 =?us-ascii?Q?zC3pzZdQ85c8xBM97RJyXXadqkaJWbb2EjH06UmUlGDTI0BvmK3PjE9Xt1kQ?=
 =?us-ascii?Q?h7rGTtQva+SHw7H+uuk/f9ZOSvihij6cWLr+1PGlCUxSaR7NYv0iCRgvqLxz?=
 =?us-ascii?Q?8zpJtrMAFHp0uR2x8N3FsgIs8rkzZtPRDSrHJ8BCo1LVKcE1GVliRjMOO0eK?=
 =?us-ascii?Q?0Anzf8zVkkPc4rHMl/5oBlRXPBIgbhSWdZYeVllgq6u3DLuCIxke6GDUxKPX?=
 =?us-ascii?Q?8SX1lKRWgWUXaQpO4yaNi02Cfi+v6as38SQT3T7eCSH/s0M1pwT/kgVnI7eU?=
 =?us-ascii?Q?2Fr8dYBR+F8A4Fu2I20sGIc0CHrOxBzZy6ba8Y8gLqm4VPxh1sDzifLihJtS?=
 =?us-ascii?Q?Ss0gLrtI7kt9j7BTMNfCJLqXsVtpJywLDQEV1e6BC3Irj+Ht3UWPyVjX6NSG?=
 =?us-ascii?Q?yN3OK0x5/CFMpQl7obWTubraRkGGJSZJxXAAUwrzHo4d6myhbQDmY42g6/4b?=
 =?us-ascii?Q?+PnvmzkgIXtcExSWtADSEoFw9I+kPB4+ckY6yM/wInCL2VVrejCRqGCiejWS?=
 =?us-ascii?Q?/iGGcyBuwzZVpTLfuZb7DOI8osMjUzo74hI8gXQKQZwWtLZLKbReeL2KtNrG?=
 =?us-ascii?Q?Qw8idMh4oitpXO3JGl9UMgOZ2GTvkF5tnETioWOZdGUlfVU8dqLuAvR4zh3k?=
 =?us-ascii?Q?ld1nBdXkjwU8Wbs44rwa+nGI1rcp+FVQt3tzGfHV6Y+1ZZMak1vXUt2U8m5Q?=
 =?us-ascii?Q?WK2F9xzfqcRsdko06Af9mlYVtbaE+65F183iJUhnbz1+XbTrz5yzaGa+p6zu?=
 =?us-ascii?Q?FjVB5Ie64EZ7Lo5vtEHXZ8WFOJ29WMuxe9HbLeJyAR4H0UD1EhCau56U2Iak?=
 =?us-ascii?Q?uFNNVSw28ELyoK/0PldJlroUsMfy1cjkKwwdmnl7w7E93q32obReDZ187wZG?=
 =?us-ascii?Q?ZtD7pT0osG9c+psUqk8ZmncXpdXtRcGKYDsLvd4Zd2b61Bra8siTRo3+4trz?=
 =?us-ascii?Q?NNTbiv5jDgESbZ+45xL4MqsphcAevZqgD4ilPAGQXDfTdX4xozfnD7wotBDS?=
 =?us-ascii?Q?1WnnMMlB749wIGTtTBTD8su4FrgmgdwPNFkYSsfHNgRms+rJxsVpUpgCpkzD?=
 =?us-ascii?Q?Q/lcKo8CHXXFy3+vFpYiFL8F2Qeo1G5cMf0odEqRar/q8lHf6kdIoiMUsp9D?=
 =?us-ascii?Q?AT87oD7T1FiRup1Yg9pgqZoNM+1W8Sfr1MpEw7kd9mwbKoOXLMqpVGy23GDQ?=
 =?us-ascii?Q?0Du7i16dqAkmv2lrmdWBtOTsBLTyP5/lOUOBI71ElBqVh+5fbZZ5Z9wGwwhN?=
 =?us-ascii?Q?mri15dC4iKhMj9q3ECoJ3/6pAFfZwmrSrbUlrpII13J+3RE0UFC7qItWZ4Lw?=
 =?us-ascii?Q?94flCtTu3d8NNjR6WOJVZywOCKl/YL46a6735jgqHr5JZ3L4L5rE0r4QJ214?=
 =?us-ascii?Q?tw=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40525e28-6bb8-4004-359c-08da5953a135
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:54.9060
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jrGaG26RZE3FT+11rgDLEWcWomxpZ6RqD0ZndZrD1obIaOhqNdMn4OKYxtybl3Brl1at3iygJZutb2R2R0ixVg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3013
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


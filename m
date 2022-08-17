Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 139DD59672E
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 04:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238227AbiHQCD3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 22:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234362AbiHQCDS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 22:03:18 -0400
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-eopbgr150053.outbound.protection.outlook.com [40.107.15.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29429183B1;
        Tue, 16 Aug 2022 19:03:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W+UeL5LXXr+1i4gFfPUfdK0CEB9goZNtGreruAs7dPwThcnl5BwYCf9g1qtnyjBrEICWSBJgLkP2824iutj1LlgWwrmqSnDs4cAlNp6YxiO1xxxjpOQ7ABMUJb8UUXCpLtFr0mv2nkE9lCVkk3/+t6XswoE/JtxROx21ssBxgST4LrJw6cW+vnOA8L4vbJYQJyIEYryW2Fc0CcjolrCIO7G5ppHR22XU8y9fBKA6rqsePcNGAcjZ2fNybjgNeULavJmldw72im8UMnyKTZA7a3v3ARx2ybADktEBmi9U+bjuRHKBRNf1nOIPIWrwkamfkWpzOvFpt94+3Og7bJDSsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=++l6IoKuMI0UpVYL4ZVKcPVoDnsrTJBFm1eCe7AUuAc=;
 b=PREFZNDvmEo5twiflXdj0a1PyvB4Wyrc0nl3NCcFH4wOVLhkevHvc78Ckbrgw018uBDhL20LLueiFD7ie12EsX79malx3Ux1McC28ZXI2KABFt7Rm6KwjsII7WxTmR1GrHH2R8aG6ZxU8sOGbxIVCBz22+hQMgmdHjI+U4O9mMlWmqEZE3/0Kwn3sqN//6+X3HfDpRgiNCILXXIrlj0Zcv18segWACpBmyKB4BurtrZ8OD7TtMLvtDQUU2Sra1XeVfK8iYqvNp/AsN2h39GDP43+ghvwFrI5w3VZ9tK7MVa4TAknb5ZWw8hEqcE10Ont5rmgsABBwbZa8XYRKzGS4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=++l6IoKuMI0UpVYL4ZVKcPVoDnsrTJBFm1eCe7AUuAc=;
 b=pxtAuJc4me3C9xUEOZ5L3dHUypT2gMCU3f9y/R/f7lpGNQ85QZzc9/3Rj/NZRgNuzpdfJx5ghIprx39fK9IDyXfoDBeKYMZ8yU+zetFYtIe0EBo9H7sodkZn6s59fyo53rzlLVlsU3VWK1268la7tI+gTlQj+oGgjq4YMkIpiqM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by VI1PR0401MB2350.eurprd04.prod.outlook.com (2603:10a6:800:2a::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.28; Wed, 17 Aug
 2022 02:03:14 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5598:eebf:2288:f279%9]) with mapi id 15.20.5525.010; Wed, 17 Aug 2022
 02:03:14 +0000
From:   wei.fang@nxp.com
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, f.fainelli@gmail.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 net 1/2] dt-bindings: net: ar803x: add disable-hibernation-mode propetry
Date:   Wed, 17 Aug 2022 10:03:21 +0800
Message-Id: <20220817020322.454369-2-wei.fang@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220817020322.454369-1-wei.fang@nxp.com>
References: <20220817020322.454369-1-wei.fang@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR01CA0191.apcprd01.prod.exchangelabs.com
 (2603:1096:4:189::6) To DB9PR04MB8106.eurprd04.prod.outlook.com
 (2603:10a6:10:24b::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9bb9849e-45d6-4822-f402-08da7ff4a506
X-MS-TrafficTypeDiagnostic: VI1PR0401MB2350:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3AjXF40AGkYIWBMch9p04lirCNEXSTVbbHVIIwEBtxh6Xq5kFNXF6TFXrL/gR5SgZhn05UXAOmP/hWaA1lhqKmjLw6Yz9USYkY6nHbu9zUeRvFuUEB3xlVSnGG4aVzm6fex9u1hH8yQDQXRTs0q1S940EVdLAj+I7uxelKcozkbPxI+YUuIa8jVWAAY7rsva+5l1FXKVjM9u9vT8pUT7vuMC1XGoAPxwjFe2ybVtrTz5dhlYg5tkUWQaZ9eYf4MKPcNsnSa7dkCVzmCipgJRbhTDUwUK6R4l1vK6KBEH9NwgTtFTvVO5OVATAboY/1lscFMnofgxhSk2zvHOdiILh2tzTtwIHzKP9xB0Pe65uiQiSZMEe6liCrGjev4144WaEmEY1e4U40qHHC2xWcIMjveRjx43jSe9r+QJ8EQ0HerRDjr8o5NQcBYhfnruLHGwtMnJdaNoahCYQ6AdkLBrLP2CHzdqTcfRmXu1iwmTAcUTqU2wd6LdpRBpxGN7M8RlBQdTBxf1pRKn6kjbNlSVi9qOKhAe7xHPD6FStiCkpC+8d9yMWklrpQp3jKY9JY2HXtgLFf9T8aoKfdljw0eSQAgXgX0OxAZjXocR7PrRiDaQHeT0hZq08PPg6jQFpwf7ptAegSbnlYD+jDqfmM3snOMnxIT7vjHP7qFQRPZEOF+PyYp0elMEga9nU1qqQpISrwCyR5i+xrn3PfP01UbRyEphFLZ7n6XfW8k26zi9bi98egFBmjDpVA9BaI2dlCVRigRLmN6jElnlRS+1KNZ32uzVHxbPzRcJW6xlEDaHPZdA+AqVTSlz7xYdrKrvBgAO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(346002)(396003)(136003)(376002)(316002)(83380400001)(6506007)(186003)(5660300002)(2616005)(41300700001)(7416002)(921005)(6666004)(1076003)(38350700002)(52116002)(38100700002)(9686003)(6512007)(26005)(2906002)(36756003)(478600001)(8936002)(86362001)(8676002)(66556008)(66476007)(66946007)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KmbJq5q2fhj19kxCpB7vg1IMnml7toXcfXETxNONm48mDj1YnoZ0nWisxj2Z?=
 =?us-ascii?Q?BeSCowKkleFj8LxEF9qPbapwrznd2XldDc635GIm9gCpFE5u9Iq8QIM9ml1e?=
 =?us-ascii?Q?/p3CPGQXKeXX7MqoZIapQAquc1Wo5vFtfnXYlv14sbml5cIT9KOIPNmYd6aB?=
 =?us-ascii?Q?IRXUUfhYlteNJQlDT8LRvwKfyyjDr1uNCCf/4KGVJP96nYhQjzN66w1YkSmV?=
 =?us-ascii?Q?JM8v70TNF4j19tJZeUgcR5H2EYQsLieUHaYuiBQl/3gvz7IScKsV6e0MfbB3?=
 =?us-ascii?Q?xxTOLYuMV5F7XbYasJ1mLO1J9+siiGE3VENXd/+6YiWAIbka44ZICEBXnGqW?=
 =?us-ascii?Q?Y5R9/zVGjFzf0HFDJSQD/jMUAXbCmuEapvGD+R90QhWa9BRsMTssOkjsq5xr?=
 =?us-ascii?Q?y4bYMuSkVWwmQZuMrx2/65F0oY3Hmmt3EjCzpEY5iJk8729cTmqLwq8NyBSR?=
 =?us-ascii?Q?h7gpWsw2LspPrgB+4Q6ggsNMea7JnxQPJ02/sQtADBc5bKRr/iwoD+8sPxSj?=
 =?us-ascii?Q?7efuigCtnAJNAvJ+NvDLnp+WKoUvNTHabGtCWKaYdHOEhoruAJgOx3a/6con?=
 =?us-ascii?Q?gQkuvBz0AtUK5H7Aapm7L8suqoGSD48IlF4OiAv8tayStfQfmqUxHPz+KkV1?=
 =?us-ascii?Q?3RIhlJ6qiuq+RasyL9sK8a4GEl1S82Vy+eiJJRQDnrckFqjFTmUM7hRDg/kE?=
 =?us-ascii?Q?yoaksvG6o+YvNx2oZdYbV0OutbCUSg6SwmVqUngchBqaUFbtV3Nv9c7s00XB?=
 =?us-ascii?Q?HR1V7FVmMggRytaYJyMS/u3jpbNcyRvHLNVJxpYZzUb5NzdZy6Vs8xp+Smxz?=
 =?us-ascii?Q?bNAAheFNS8FjBiV+zJR4XwnpEG+uCEuNnqhZDjC6hUEm/xNpdeDtcO2zayGH?=
 =?us-ascii?Q?1c9lVHQReuaa1AUzov/GwuoKQytaCnV6wfAkA5znwY59R3VoJtz5hVc+ZO5C?=
 =?us-ascii?Q?nXZdoH4jrNN2LZt4iYuHN/VZT8UIlv22V0pLelWwgFM3wEf+Sg83qPDfCnkQ?=
 =?us-ascii?Q?Vc28iv4+B/MoXxxibuqCUUxHo8UJfoPmV+QrrkzkQEj4/efH1N2GVF5kQy7z?=
 =?us-ascii?Q?Ji+iA2Jw3pdvLTrPzfpeQir4wwTXpI93VeuucDu490QbepsaKHqo3ZCVknbM?=
 =?us-ascii?Q?stM0d1o7C0OnGKG5nGI+N1MrepdQ6YZIK7VEi36c6APFktkJn2ip5ywS+JKL?=
 =?us-ascii?Q?1C7TE4SyUG/1tJjoNnGdcKQGbKNFkUwZqmaXJERXQXr8sJFAyn4FuHLQynqn?=
 =?us-ascii?Q?vLrxq4HfZmZoRQD/JbONaivqnaI5hZprnaUMmEpL/uF8G3Yy19HA5v1gAGvj?=
 =?us-ascii?Q?TOwyXwVQOkqAKnaZxBjHaZyc8uMT4TGggtcUFsV37dYuo4M/WBe/WZd9qHMY?=
 =?us-ascii?Q?5zTVvJNYVY6EwC6mmzbrW9bhpbrUis8bscgLbP5cWpckyKWJI/ch1Gh/A2Rl?=
 =?us-ascii?Q?skeoz3rBu1Son//4BO17+VpZPR4wpZKaJZroBOALY0S6HEYx6a5LiMAUOtyE?=
 =?us-ascii?Q?q4+5MgECgtAu2uRu+N6rOEHdtvEPS9Vlxfy4qUhgfIv1T64cGBAAssaXHRuJ?=
 =?us-ascii?Q?u4wyKJ5hM5m7LBj9WMth2mHoHIADkBCclS5yi7iE?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9bb9849e-45d6-4822-f402-08da7ff4a506
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2022 02:03:14.5508
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: g41gu57+ppv7wnzTqcfgmH4N0g4l8kltRPt/X9B/uR5HOO5Bi0hq0Wl+wnB/I/qdempQO6/VCxTVULQztRCw5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2350
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Fang <wei.fang@nxp.com>

The hibernation mode of Atheros AR803x PHYs defaults to be
enabled after hardware reset. When the cable is unplugged,
the PHY will enter hibernation mode after about 10 seconds
and the PHY clocks will be stopped to save power.
However, some MACs need the phy output clock for proper
functioning of their logic. For instance, stmmac needs the
RX_CLK of PHY for software reset to complete.
Therefore, add a DT property to configure the PHY to disable
this hardware hibernation mode.

Signed-off-by: Wei Fang <wei.fang@nxp.com>
---
V2 change:
1. Add subject prefix.
2. Modify the property name and description to make them
clear.
---
 Documentation/devicetree/bindings/net/qca,ar803x.yaml | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/qca,ar803x.yaml b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
index b3d4013b7ca6..9450cadad116 100644
--- a/Documentation/devicetree/bindings/net/qca,ar803x.yaml
+++ b/Documentation/devicetree/bindings/net/qca,ar803x.yaml
@@ -40,6 +40,13 @@ properties:
       Only supported on the AR8031.
     type: boolean
 
+  qca,disable-hibernation-mode:
+    description: |
+      Disable Atheros AR803X PHYs hibernation mode. If present, indicates
+      that the hardware of PHY will not enter power saving mode when the
+      cable is disconnected.
+    type: boolean
+
   qca,smarteee-tw-us-100m:
     description: EEE Tw parameter for 100M links.
     $ref: /schemas/types.yaml#/definitions/uint32
-- 
2.25.1


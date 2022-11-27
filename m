Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CD01639DB4
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 23:48:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiK0WsC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 17:48:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiK0Wr4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 17:47:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2096.outbound.protection.outlook.com [40.107.94.96])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD7BFCF2;
        Sun, 27 Nov 2022 14:47:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OvMD4omNXKplXstaOnBRS7i3umk3BPaJzfoh5dmTD0kKehxQjRXD9HtwY3U/i/Zf9QfXcQfUzECPM1xGhlYic/IOyZs98n/F91QviKQiDTEmscShR3JVgWvg8Res+/IOpFEnhEidamauzesAexlQ7JM5CTNScEgBt/5r2ffjwLe539F2QsfaHAuAjID+azuKVHa1rXees3LStilWmZMmZHmaUFbUquKfHS+MWdaIxXnL907MRb8ZA1Sq9d7oA3flrueUphTIIfOxzdu3SZqPn46Olg8cGW3S/9RFWmHlAgORNGaxCQq1KyxLSGxmCpXSbOubIm3doJWmD6yA257CPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SSteeDlnUgk0qYhjpkGtjB2C9sS8xX4R7s250jERe9Q=;
 b=Y5N+g2pGUmj4sNu5+CNdGiBEnsUA2nyCp2qeHi1BO/paW1dt/HFtg0BIzQgtp3dMZTOnTMK6qiZekI5qtAdlqrmPmUtQ/CtBBwJ0lSQllHXUcX76QtqDM6pS7cUG/uByverdp3nx9czUNhdpFLPRTs36ve3uB+/ms6k1VKnq4WGEJ3i2vAOXpUroc7fXV7ao7Tj+09b+xkMwBHh+N5v7MwWTHOuQn3to/235GBUCZVGjKLVvHlWhkHdOj/TG8B0COmfdnliNsAMW8EFl6Su+PK4+vCpcqiZWTu+xSUb5SMTap65b5e1kdNLGO9J4oefHuWyMrGAgL5h/Dhul+k+0MA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SSteeDlnUgk0qYhjpkGtjB2C9sS8xX4R7s250jERe9Q=;
 b=nzd4MeuHTpMkqNZTu8+NwSagPBA647SIzHtnN3/fpu9q1j45mE/TNMUVPPk7Tul1uGVn04BsgMxU65rcNYRC3y7c2+fMG2qh4rbZc6o7rxFVrA8KlookAvL8wvaS6KveJFKXb7tqPTbb9po8a1FvpvIlYGCpdYwvkDyLRPG7hE8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BN0PR10MB4998.namprd10.prod.outlook.com
 (2603:10b6:408:120::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.22; Sun, 27 Nov
 2022 22:47:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.022; Sun, 27 Nov 2022
 22:47:54 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v3 net-next 04/10] dt-bindings: net: dsa: allow additional ethernet-port properties
Date:   Sun, 27 Nov 2022 14:47:28 -0800
Message-Id: <20221127224734.885526-5-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221127224734.885526-1-colin.foster@in-advantage.com>
References: <20221127224734.885526-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR05CA0027.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|BN0PR10MB4998:EE_
X-MS-Office365-Filtering-Correlation-Id: 5005b04d-26e2-4adc-9965-08dad0c96bd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aeegcg5i+jn/jmaS1pZh3WuzxKy4ozhCXuZihlv29rKqVSkvFE5C09NzeagPtAfqeeQaNUf7mX3UGlOt/aNgfOfeq0vf/raiZ22vKHqRnG0lFRsHBRZcEIUyIHSNCC2uvLPaoiXgwtv2iXkTTi8MchCX0e9sM3qIh9UUNxyMP63Aq2xmPHcuJ+40elHuUtXZeqhCXhTGGAIU+g3uc0F1wEJV3UQlBn6iwgW20RsmsVhNAU9oGsS24GCmEi7NM4s+Ctu3Bv8R2daOCMYVyOjwxx+2o4KONPwW7V+voncOiIzdvj+Kpq9Mou0uWRSHQ4qkUiJdt3pbKuN/zOJtFnybM65RPluThuXOaOztqou2jj6w/mjrdeuzq1HBc7SXuym80eW6uViHbeccOSO6+5jeoxZZp4FDPRb5qUz8224I/RYaVm4vAVP5uqMZ6HWEEk1IJUSdKquVQurzpzCe/N2OnPOtjYKZKY7vPPf8ctiC407RaCwlqFzsi42seE0h4qvsup+g4VIp1AmtUsda2AHZz6hUbGBw64xo0enCh/fhVhzluZKP1EUp3WA7t1luMYmVSsGIfOanwAjNywYsoDjVeMBJ4zfZuN5SnbWvdTY7VDv8f+NFZA0MzjBF9wWZqNjNMsHRZBvX959MNWQXRIIp1g6ecOZIJlcWBilsQGXdbwuXC1H4dNF72213Jmd+i3B3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39830400003)(376002)(346002)(366004)(451199015)(6506007)(2906002)(36756003)(86362001)(7416002)(7406005)(6486002)(478600001)(52116002)(316002)(4744005)(66946007)(66556008)(66476007)(6666004)(41300700001)(4326008)(5660300002)(8936002)(54906003)(8676002)(44832011)(38100700002)(38350700002)(2616005)(26005)(186003)(1076003)(83380400001)(6512007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fyiwJWtNBLLFr9Rt5xdJq72VocLXXk5nXkouuwV+hmisAF69+DzJI50aV3r2?=
 =?us-ascii?Q?+FU1g5OW0tEf9ngUaHyMn5PhWOly1etUJ43pNuQEN8pjiuuVJyuhlliDE6Uc?=
 =?us-ascii?Q?i0ZdA+DnRg2HxD1i7cocXtezT57+ZiBQmHP7c2Jym8B1dz8uCDqXidEoeaj3?=
 =?us-ascii?Q?6i71m9Q9vNywikoUDOFiVxfv15FisW1J+P0iGYEUhK5edr0Lku82u3WYTXJo?=
 =?us-ascii?Q?hQjpL4xIPWmwOxMvXqXfIgddfg9XfHtQNAjv6PP1/ZmkTvC62fpZTtQUgX4B?=
 =?us-ascii?Q?LbeMqmboDSoNszsLEqm87aY5gxDw0UWgkbpHmQVyXoO8iLD14XFkoi2OeOcn?=
 =?us-ascii?Q?ZG0xmhSwYoW/2USwPIPJ5o5wAOmT1n+hb6eKGiO0oxWrkdbGPO707PEoHfxq?=
 =?us-ascii?Q?kISTaDNnaQi04ik9FIJjV4JnbtoNybBWr0dcWlQVOxzyixZqA1iRa17ObKNn?=
 =?us-ascii?Q?rTxs2Bqma5q1ylPx8BR2mQj+lAn0ZEd/DvEAFpuVXsXQr2mOIJEakH+RZbSM?=
 =?us-ascii?Q?dmLOT+sOoTbdBWD/bDYg0IxJ1xLUdMMtn8wzbkH40hVRmqdbjgRnN1XWJlmQ?=
 =?us-ascii?Q?hyzqGS0s/70ZNrW2fmSZEJ0OyOHmmdhYDR3hBIdBwmYENArDK1g9cCFgeUa2?=
 =?us-ascii?Q?0zHb4mbAHdddtk4UjQNjgVL24Tm48oXTq7d7F1/p75CGH4/HGv9vEUjPWY4L?=
 =?us-ascii?Q?MVbjEN7zg5yx489OG3iCxlw1OwrT524d9fvudg0mTaV7BMEU8sO5pvxab1mB?=
 =?us-ascii?Q?Qxbsxatrzm8Pm1s8qQm8JKNU4hYznXs/Heb8SGXxmL7K0BLArbYxskjoG7uI?=
 =?us-ascii?Q?QZIaO3adn2wGN0YDMZJXVW7c/9oNKy0hvC4+IO6VZswVj6i6CWS1dUUgrQ1n?=
 =?us-ascii?Q?OaDFGsjmqKCnaZjNQiZw8+3if1KPIEafLpKRLjCDVizzXl9GckjIphyDB9xM?=
 =?us-ascii?Q?4IhQvAHiPReZfBvtky5qXDJounMspHEn8MyfGjKwHTSuRHHvLNIbxnSEVy6S?=
 =?us-ascii?Q?ggsaSFm592wOboBd5unCRCqa8qIQ9S2znEEOc7GSMu5HRGlK9YBtdEuTYNBO?=
 =?us-ascii?Q?QTcFu8130MQe5V6glxChvn9MsXEIx3ukaO5qdW/C2cillALT6gObGQL2vvfW?=
 =?us-ascii?Q?Jb2aydoQgsBSZcqGGqZ9khojKs4vW1HDW0x+y0mpv9lgSQj0AUnHQHIIPpVs?=
 =?us-ascii?Q?XvQqKd3VZICmhJDlXhFT8zZkftROgXyjR9W2Imtj+ksC/iJPa9F3HS+5lqPh?=
 =?us-ascii?Q?Z9lu7pMZ3L7z82OSga3NxVnBycR0XjkH7XX9vLZAG8jx4bNKwm/HYIdsML0B?=
 =?us-ascii?Q?B5jnAE4uZN4stXk0tB+bRcedOZKVUUgoOGZWaBqh3kQ8asfiLlqGtqhXh/+q?=
 =?us-ascii?Q?OcLYLSQkfRdZxdgGuHqi6NmAtq3qkKV4kk6sjrAY30A1jpvARX8hmGRdlVjs?=
 =?us-ascii?Q?6WlLg8l8WT6Lk0571h2l+tC4OhecTQfVp3u0GDc6OWspMQL23mlU6CDApj/u?=
 =?us-ascii?Q?VMf3UTj/GEGMltBWqidUGTrQGgo+53xzgA6VK7UP90IfFkONm/RRR2BtLYpY?=
 =?us-ascii?Q?TSpX7j2mAW6Ba/W8AlwQIHzpCuStglPh1hLIJw8OdU2rABS7Y+uj1ojUV7Py?=
 =?us-ascii?Q?mw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5005b04d-26e2-4adc-9965-08dad0c96bd0
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Nov 2022 22:47:54.4214
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8HedE+sKyJHQ+qWgMOlKBg6WMwAi5+Y5812nxnUIAYyH0CwoEDwyioTxNJtm6bm5Gltpyf4cmzMWTT/AYpYP9N9wp2KRJSUvs8DwcRiUmfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4998
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly allow additional properties for both the ethernet-port and
ethernet-ports properties. This specifically will allow the qca8k.yaml
binding to use shared properties.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---

v2 -> v3
  * No change

v1 -> v2
  * New patch

---
 Documentation/devicetree/bindings/net/dsa/dsa.yaml | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index bd1f0f7c14a8..87475c2ab092 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -38,6 +38,8 @@ patternProperties:
       '#size-cells':
         const: 0
 
+    additionalProperties: true
+
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         type: object
@@ -45,7 +47,7 @@ patternProperties:
 
         $ref: dsa-port.yaml#
 
-        unevaluatedProperties: false
+        unevaluatedProperties: true
 
 oneOf:
   - required:
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E126576949
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:01:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231696AbiGOWBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbiGOWAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:00:35 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50072.outbound.protection.outlook.com [40.107.5.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3A7E8149B;
        Fri, 15 Jul 2022 15:00:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPr/ZdjMjGNaQ7Up96Z9Y6516ci6cBjqYL0QnOhRo2ymCaD1t6NRXZfdwZXCAykMcqnsMYDtl0B8RDna0/E2qYoPR2KRXaMSTGRUtJufJLzG5lezwpiS8CTf+UxQoxmaGmVu2Jjpvwdra3g7qmonhHEpZDDrt4JFXxlYyCzU760BntqQV01Q9E+KoousGyx218Vjf7RGf2OhXEvlbM4GSUt8tX3czuzBg2ZUaaJFUYfbFQ5qzidzcR1mRbXTaD7MKY8frlNiKFX2pc7B76bxNnRWS9TvHbrfADIK4N5cmqUIoFTC6C5b1kFProPx7b/8jEgMbH9e/qMO/rC7kFGWMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ve9pJWJMASAwB2OXaGeelUfBiI+3VPKgKeX7hfLraVU=;
 b=dmurX1lVFuzEbFCCM00eOJZwPBnT62g7FdOF9ZBrN1Y+jtZ3W+UlFVobaIzcc6nE+Xq5AHKIbUXcCAsollAeKke9pxtvz+LajkdqaA3/ca3QaP1cb6HSXBo8MovKrb6ffx7+OsA2kMo0N/SU7jtmSz50dgRttRBe3Iu6gS8pb6EhsOfNfcqHok6ZsRIOyC83DCwSNAF9G3lclmOwsgzTs70sRZYD7fw+O+zSQ2pdPEC+r5U/BkgX1EcBJSlHzqhcQKYUk5QOFOMAgQqlURZq7uI88HqPvwK7ogmjMPFE4xvoOerZPOpx7TgwMBEITg3gQTdHQkxG2qCexdMJtu381g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ve9pJWJMASAwB2OXaGeelUfBiI+3VPKgKeX7hfLraVU=;
 b=kHgD0s579DAeTdsd8jqvLicpGWCpD3YogI5foIy1Aa8Ix/ZxnnOwk/hBKMsGrbJdEsSaibB14cipb8Mm1c7hZRmIdyNJoZMmOA+1vn8LvO/sgOS9XaRLKn3QZDhL3UAYGMBZRbPrTvTVuxeV0i5DFN8ahUNyBcn+ALoxSOwTS8C6J49RHjzqC8ru/+bWfWpGQhtZXJg1mwKTY6MaCUxsPxltgIwf3SMH0yMR9tWZN7yvHkKZsUvbYdQ+s6fDkD2DEw+293lAumENaco7tgg4VkkMBUGVTYYTwrDL+vvzRWaxb9T/i55YQU0+G5Da+A4QXnjnbqYcyoZTOhgf3Bc+8Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DU0PR03MB8598.eurprd03.prod.outlook.com (2603:10a6:10:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 22:00:20 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:20 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@armlinux.org.uk>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v3 04/47] dt-bindings: net: fman: Add additional interface properties
Date:   Fri, 15 Jul 2022 17:59:11 -0400
Message-Id: <20220715215954.1449214-5-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220715215954.1449214-1-sean.anderson@seco.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH2PR10CA0009.namprd10.prod.outlook.com
 (2603:10b6:610:4c::19) To VI1PR03MB4973.eurprd03.prod.outlook.com
 (2603:10a6:803:c5::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ea68d7c-9f95-4b56-7d75-08da66ad68e3
X-MS-TrafficTypeDiagnostic: DU0PR03MB8598:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G+IRDmspXC0J/Y+w5GUAb8QwGUSAFzdhQWJkUXIOcf8SUgRGFdAR8RlTb1SgzfPbInCwWntlTnd1cfIqUh0ZwRAxoopZpxkidvROI1wudQXXYdO8BnY4ZvtbOjr6U+pBhsscUmuU8ez5cwS+qT9OuJ08lJujw7rx+ONRDVaBEtLCi/GXT3P3fhaxcsD2q9qI4tYk6wF8+ca5lGzsWFuRuIinMJy2h3+MnGL1q7pfq8OSsvEWP+a+C9A8b9On5xM077JZfhbdbXO/jVHk37ycoTF/fQag4JCqAo2lOAh8EFs64kQTIHkEHzM24vv4wAeT1nf4pe4V4sq8h+IzrC+S7ZnKL6b7PPY6BSDNpPQMd3c8JO5mnVaWmHo76Uxfr0G/Q4y026DqpTQnW0GF3aiWmBnhMEu+pbxZ8Z2lWo82jENkxEhZ+PVAP9CiP1ydI97PY//wPg7ulCYqgFG46pg811P9HkQuuPmVGOyOw6oUAHisgSCYV02j65BohHkJL/IpMjM8nVXTqHhVZDmo/X3dnX4KvDIi1opgBPuwosOfctZIhPwfxhvohnpvw34Xx+QJ9dI9sMKdmragPS7B2BVtLew5sCpeYMXYTyL1RRanh5Zun58dXEsHV6lCm6G9kuGk9ripELgo3nv6j0qPJGM8oXQSznRhNBSWQ2tpXI31N8GVRWDrSZPXwKg/W10SxkYiql0351t5fNoH++BQBsBdEVByr0fafjZFzup6ZQUQGASM32ZbJEe2Rv6hBqEXzQNoflxf2xFqUNV+tvabVmrzfLdhkodHVUt4m221MgqPsGjHlbaVuZ6AL+RYHU0FIutH
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(376002)(346002)(396003)(5660300002)(8936002)(44832011)(7416002)(2906002)(54906003)(66556008)(4326008)(8676002)(66476007)(66946007)(110136005)(86362001)(316002)(186003)(2616005)(26005)(38350700002)(52116002)(36756003)(6666004)(41300700001)(478600001)(6486002)(1076003)(6506007)(83380400001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?wVV1UL/E+6gGXUUaAAac+GH/cTP6gntEdy4Xn2IPg7Npl/+Lt5rswwa5CEXM?=
 =?us-ascii?Q?ueI8BEVjMy9AB0NnLcsx+PkMb3kz/2XqwGLgonWHMsX4/KQ8S6UQSQ1f2GWS?=
 =?us-ascii?Q?V7JveFttpG2P9D0lwa9J7cgyYmu+yMbb8INP5P4aRtbMjLASnFXyHT8aI7M/?=
 =?us-ascii?Q?9HEfeUejb5ziQ+3jmY0UL0sLr2wRU34NMiSKvxaG2RYo6/XecwZ1Ymmem7Sp?=
 =?us-ascii?Q?6JXrw1KdFCuAfQP1pzY0TvSrIWq1OTM2rcoU7MZl1FIIUA+22RWvEneSCgEW?=
 =?us-ascii?Q?GJLYO/n4p1z8MVKFCAYi9fH8epYIMoir7WJ5QF6IXhLuHadnYlgM1Q2rOnPW?=
 =?us-ascii?Q?wapMAEnrDhjSnSua1dLs6i5Hi699X30Vb5FqEn+WkU+aNa4P1qc+SOgKICNc?=
 =?us-ascii?Q?+P9ZMmmJq/uDUcn2IYKEngUp5qqf2EMesxm3EnJXzCIFOgpD2RYQfhzlTFgY?=
 =?us-ascii?Q?cFhe9gLTQXLm7Pedhi6WV7zCjmJh4snvpcmDq1E71xaAPQDCkBEvX2jUxNhb?=
 =?us-ascii?Q?t95/aJQXTvgCkmZbCfczsBmUOUaD8c3N/QYTt4ddmtNGdcxZLBzjAmgMLjxT?=
 =?us-ascii?Q?jrZQkThPjgvVG3HAy9veRxvtCwc3fex/ZqT6izCgIza3yoPMNB+6mrt8c7PV?=
 =?us-ascii?Q?tNJq5Y9kB743RAUTJOeNFxMkVPz0X9BrRWsocpyM15jFgDUp6YMyzYltMpD7?=
 =?us-ascii?Q?qjw5qj/3/LwOgrNE94mvHm4u0mvv06Si1Op5qILYmFY1SkjL/YID2doBYHKl?=
 =?us-ascii?Q?eAbq3y+X7F58DrzjhO6niWkQDZ2N+5Be6KLRUHWZdhRhuEZ3Ignh40yp0anh?=
 =?us-ascii?Q?02IqaaG5zVsLqllR2orRbOOIi2IdP3AgtEUwQ4vyRdedTUn/AA/aXGP9TdUp?=
 =?us-ascii?Q?obnPgoVnef7wY9ItAGEE91l3IxLWuUCYyUGXDiV5a7sHdj0a8GgJdmKwzxI1?=
 =?us-ascii?Q?FKY1gyF9ekzCFu671ngPCyneVTrd+/0SMJGZGDMrnumyqaPiQbgXVKFdNSj2?=
 =?us-ascii?Q?VVN5v9YuRShFEN1ay8kjhvTh9dZVZC3w1U100U+VbUrcMKpmhWsdgTK1SFXq?=
 =?us-ascii?Q?cgJ4sxdxMp0Da3gJUl7OleQbE3TpHHdbjRoKFZRk1cX6v4UO2Ga6mJI8DAiV?=
 =?us-ascii?Q?kCj7DP20XFWlj4Gfx/qGDYCSrn3y44zs8pGCjiqRuYefrCnCtB6E7quL8/Yk?=
 =?us-ascii?Q?zvKOzzUw5o3boAskcMd2ZM0JmmttK+DfrUNdUU7ql+T+coWiyuSj8k5lLGeG?=
 =?us-ascii?Q?cMdKnK7rRnRHFcyNmu7w/zwmmyfluF/cgCQGqkz4X/ilqXLw6UbK/pZoScvw?=
 =?us-ascii?Q?vqGcoSW7eXtgTHNEWyCda9e7o1VuaBaWf1y/D7gWoBMzz5iYqTZO1/wtOLEk?=
 =?us-ascii?Q?VYO2CswOiqpc8IqdojkOC+S59V3D+LeATAsLCaMYLQT/uf6CKQZ6+8iyH+iW?=
 =?us-ascii?Q?s2IG21lZ4q/a1VnvHW8Mh0Wo3tmb/AIaRMvmzUUhK7gZDCwSQA5IZft/9Gvu?=
 =?us-ascii?Q?ojHTqrZqW8ZB40wdcA9Dkn856iFMtOfvx4+4kwkr8iuB4T2M/KIgmMtUnz9U?=
 =?us-ascii?Q?IajiCXkh93HzfDeCYo719ekXDVGnawKOARxLBV7ERs+MyNyS3qBOyt7YMiX1?=
 =?us-ascii?Q?DA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ea68d7c-9f95-4b56-7d75-08da66ad68e3
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:20.2554
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iGkFXs2tTrOb3Q005D8eo0RVuSh8y48XawjQ07Ds1HWbkmh+AEmANvqEauFFkW7F1akeRjLIE64y2R80qevruw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8598
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, mEMACs are configured almost completely based on the
phy-connection-type. That is, if the phy interface is RGMII, it assumed
that RGMII is supported. For some interfaces, it is assumed that the
RCW/bootloader has set up the SerDes properly. This is generally OK, but
restricts runtime reconfiguration. The actual link state is never
reported.

To address these shortcomings, the driver will need additional
information. First, it needs to know how to access the PCS/PMAs (in
order to configure them and get the link status). The SGMII PCS/PMA is
the only currently-described PCS/PMA. Add the XFI and QSGMII PCS/PMAs as
well. The XFI (and 10GBASE-KR) PCS/PMA is a c45 "phy" which sits on the
same MDIO bus as SGMII PCS/PMA. By default they will have conflicting
addresses, but they are also not enabled at the same time by default.
Therefore, we can let the XFI PCS/PMA be the default when
phy-connection-type is xgmii. This will allow for
backwards-compatibility.

QSGMII, however, cannot work with the current binding. This is because
the QSGMII PCS/PMAs are only present on one MAC's MDIO bus. At the
moment this is worked around by having every MAC write to the PCS/PMA
addresses (without checking if they are present). This only works if
each MAC has the same configuration, and only if we don't need to know
the status. Because the QSGMII PCS/PMA will typically be located on a
different MDIO bus than the MAC's SGMII PCS/PMA, there is no fallback
for the QSGMII PCS/PMA.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- Add vendor prefix 'fsl,' to rgmii and mii properties.
- Set maxItems for pcs-names
- Remove phy-* properties from example because dt-schema complains and I
  can't be bothered to figure out how to make it work.
- Add pcs-handle as a preferred version of pcsphy-handle
- Deprecate pcsphy-handle
- Remove mii/rmii properties

Changes in v2:
- Better document how we select which PCS to use in the default case

 .../bindings/net/fsl,fman-dtsec.yaml          | 53 ++++++++++++++-----
 .../devicetree/bindings/net/fsl-fman.txt      |  5 +-
 2 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
index 78579ef839bf..4abf2f93667e 100644
--- a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
@@ -85,9 +85,39 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle
     description: A reference to the IEEE1588 timer
 
+  phys:
+    description: A reference to the SerDes lane(s)
+    maxItems: 1
+
+  phy-names:
+    items:
+      - const: serdes
+
   pcsphy-handle:
-    $ref: /schemas/types.yaml#/definitions/phandle
-    description: A reference to the PCS (typically found on the SerDes)
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    minItems: 1
+    maxItems: 3
+    deprecated: true
+    description: See pcs-handle.
+
+  pcs-handle:
+    minItems: 1
+    maxItems: 3
+    description: |
+      A reference to the various PCSs (typically found on the SerDes). If
+      pcs-names is absent, and phy-connection-type is "xgmii", then the first
+      reference will be assumed to be for "xfi". Otherwise, if pcs-names is
+      absent, then the first reference will be assumed to be for "sgmii".
+
+  pcs-names:
+    minItems: 1
+    maxItems: 3
+    items:
+      enum:
+        - sgmii
+        - qsgmii
+        - xfi
+    description: The type of each PCS in pcsphy-handle.
 
   tbi-handle:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -100,6 +130,10 @@ required:
   - fsl,fman-ports
   - ptp-timer
 
+dependencies:
+  pcs-names:
+    - pcs-handle
+
 allOf:
   - $ref: ethernet-controller.yaml#
   - if:
@@ -110,14 +144,6 @@ allOf:
     then:
       required:
         - tbi-handle
-  - if:
-      properties:
-        compatible:
-          contains:
-            const: fsl,fman-memac
-    then:
-      required:
-        - pcsphy-handle
 
 additionalProperties: false
 
@@ -138,8 +164,9 @@ examples:
             reg = <0xe8000 0x1000>;
             fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
             ptp-timer = <&ptp_timer0>;
-            pcsphy-handle = <&pcsphy4>;
-            phy-handle = <&sgmii_phy1>;
-            phy-connection-type = "sgmii";
+            pcs-handle = <&pcsphy4>, <&qsgmiib_pcs1>;
+            pcs-names = "sgmii", "qsgmii";
+            phys = <&serdes1 1>;
+            phy-names = "serdes";
     };
 ...
diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index b9055335db3b..bda4b41af074 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -320,8 +320,9 @@ For internal PHY device on internal mdio bus, a PHY node should be created.
 See the definition of the PHY node in booting-without-of.txt for an
 example of how to define a PHY (Internal PHY has no interrupt line).
 - For "fsl,fman-mdio" compatible internal mdio bus, the PHY is TBI PHY.
-- For "fsl,fman-memac-mdio" compatible internal mdio bus, the PHY is PCS PHY,
-  PCS PHY addr must be '0'.
+- For "fsl,fman-memac-mdio" compatible internal mdio bus, the PHY is PCS PHY.
+  The PCS PHY address should correspond to the value of the appropriate
+  MDEV_PORT.
 
 EXAMPLE
 
-- 
2.35.1.1320.gc452695387.dirty


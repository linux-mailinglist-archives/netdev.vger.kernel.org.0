Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDDD542CDDC
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 00:25:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231392AbhJMW0w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 18:26:52 -0400
Received: from mail-db8eur05on2069.outbound.protection.outlook.com ([40.107.20.69]:19889
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231204AbhJMW0j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 18:26:39 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GBLsbaEaknpqFY7sewK3Uvx/mou3FzXgSoV0eRHw3kOYqp9RIwlujZyNtpJfGGCLFpRB5Ie58ilSzyGYGwIUFnPuRWKDI0QTTxtJwwOCJKB2qBEXQxhCoAKdOMJRnSRzq8IHCR+RD2CqZnOZWlkpNqkwKULsMjoo4Bj9gl6ZvnD4XJA4MSeg97gdbuuI1yvuOEiNACzpONH4wWkMXLcSSZ47xj8IpPKptSWd4lAVlXNdBA8Y0VXYQiARQ5cJEStpOn6CKDxpDCralWD56t+caDhfpI6eX0ay6+fFI9LGiVfnN+0euCgDshBqmIKzv3UwSfdrf79H1GahR9OWR2gN3Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fP2W43y4NZhUeiHwnoOz9f1Gg3lG4GAcNsaDHuu8td8=;
 b=nP80FVYy3UovL3WFyBOB+PbEENWEBgBZKhpcL3l1PkWI6hnOKZwoCHnPcHUsJw3puEyqVnnGV23fhgukxDvMate6O9eZwqLOSX+ClNcYGkHV0wTjnxXaHG8BivlV2rd1CkooFhaLowuap6UCBBrMEvi1e6XS6Wcadg87hg+WOTyupnNGHKP6Y7vxHb0jOzi8jNr2dkwW2mZfcfQiB+ycKW1WWqTwcj3yKiIoeGWam9oyXbNIlv/HREGDc053oy0mZlu42Yy7E3C42zIEAeZ5kjOhRfIjaa/tcTA9Mmyd+isLGPiIutlC8xM+/ZBk3yoIzmhVdY+qijhSSkO7KKSXUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fP2W43y4NZhUeiHwnoOz9f1Gg3lG4GAcNsaDHuu8td8=;
 b=g6n44D3F59rmYlKYa0RBcmv3x9fpsDt8pJsMrw/OZwXv0NPfzHKPAe6kHDfpY8i40fkBNXZiVrGgq81QFhUrszW6Zj/4vFDC6rxuKl7r6sEnUfkttrVrklO4wxpQ4tUxyagUqnCoUBXhOklezHYudKS0pDPM1VUdZL80OsVTQ/Y=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB4816.eurprd04.prod.outlook.com (2603:10a6:803:5b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15; Wed, 13 Oct
 2021 22:24:25 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 22:24:25 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH net-next 5/6] dt-bindings: net: dsa: sja1105: add {rx,tx}-internal-delay-ps
Date:   Thu, 14 Oct 2021 01:23:12 +0300
Message-Id: <20211013222313.3767605-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR05CA0154.eurprd05.prod.outlook.com
 (2603:10a6:207:3::32) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by AM3PR05CA0154.eurprd05.prod.outlook.com (2603:10a6:207:3::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Wed, 13 Oct 2021 22:24:23 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5244aee5-9555-41cd-2571-08d98e98366c
X-MS-TrafficTypeDiagnostic: VI1PR04MB4816:
X-Microsoft-Antispam-PRVS: <VI1PR04MB4816BC96CCCDB10F4BF30F9CE0B79@VI1PR04MB4816.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +ErV0lFk03rRGOtptc+25nydymfxbTZiexGL5H6lq77ApaVZj14knmt0SVE0udQjug21ZY2bUYf4gaIN5WN53SkhkfC3D6ghRLGfoCv+26VlMMyai4mqGdh4mHTLUba1lYywnB1M84n4NUCfMMiA4c1q+Y5D/Mb227YHwd4MO9XGtkEx1AKWw672WR8dfSpCxJ5D4O30sqjG5j8lCkvql+JU5jO+zCANYqULuD2GYFgKf0xsfcbWNxdP/l2NAHSeRWUyJp2WeK/BT4ZP60OZnYiWdT/t8mTBBL1SWcqQwgCgicqnGCHxh422dJFQWZCxJKOoqXwPZTSOMExud67O+2RAXWhOdM0OYfLQoGgzyZany7YZiiL7aITYpamtJFkfk8hhej1yf2EkX4EaG6lDgNyAb6t3i2nbhSTY448H61/dgypQOgSHYg8+YGS+jh9WCjz/bN5ogQQB9SdMLgaisHxM/8HCrT4YwFxfFWW1HUno6agWQ1+9KoGUonqX8sJrxtM+vl5+T6HAHsVMiQ4yXL00g+KLuO9yqq02wziZlAiIyX+8IZlArnw/jVQGe4TsfMHrS9fynb6jEOZ3Xz7dKGGpZbnG7K9twwjspIdm/ilLMWR6n96NKn8CH0E0osz7xIWTqCySCpl+nEQnFKfbn1+gcBDjQbIn0KtzQKp98F7Y0b0xK+p9KkM8DSJAFa2ArZnVDkDpuzcDCHP8BalIvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(956004)(38350700002)(1076003)(38100700002)(6666004)(2616005)(6486002)(26005)(316002)(54906003)(110136005)(2906002)(8676002)(6506007)(36756003)(66946007)(6512007)(66556008)(66476007)(8936002)(186003)(4326008)(86362001)(508600001)(44832011)(5660300002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FtMbOcs8uRORZa77Pd9z/avsBR1m5idoDeaycp1ULDEuzlCnpY/AynuVibAl?=
 =?us-ascii?Q?BL5sv7fFkKZ6JeduL7gIQi3LifMxfwxl2QC2+KFpVFNUsi+C/yMfU3CXIx1i?=
 =?us-ascii?Q?mnOHCoLWkebu+CGm08QpbGN862hwTLQQW5qJsupeLTUoeZWcuuQa+qy3+RcQ?=
 =?us-ascii?Q?lH1A+cra1j7fKY8NnFMp8l+0RMaMJbeRmH5YppEYyJ0R+GgqiO9Wv9XXQdxz?=
 =?us-ascii?Q?m3+6G2WJ2JKEwQmlEZ8MRYes0LW+BVBIe31SoLbO6GfPSgCpEEyvCzFN14+O?=
 =?us-ascii?Q?gZd+hmKYMsmuCyR/qGyj7lpC8e7LmGjG/y6/xh9I3itJV/+eXFW9ORYiLIMH?=
 =?us-ascii?Q?TQfkRBS+DAEKmObVh4oLUP09uWu0mvrEr4uJ3UJ1tWUaEdJwpkH6R13aXRYc?=
 =?us-ascii?Q?VSo0SUa9CwG2t47yfiKMfgRBB2HDDqbM2ZoIUHaH5KRC0wtMo+WTVrDRQb22?=
 =?us-ascii?Q?yOHLlEuzh+g4m5FyRF5Slz7iJ3aRTelnUS6x4EXuwbGrrGkraN+4HqLI/JiW?=
 =?us-ascii?Q?B17SVO7j6667I1qg1u/0dsY8yupX2bQIqJrqcXWYECtVNKnvA+HkWfCnH3EA?=
 =?us-ascii?Q?2tjPavKthTrXnlir3w+XdL/hxMiOQQ82JasQCPgLht8/9cBnde23fRXlFq7n?=
 =?us-ascii?Q?5yqc8E064mbCsULsFJaT9vSh78b3oeU1b3Y16asEb6EDmFnmcPL3OOM+0lCV?=
 =?us-ascii?Q?O3hg5fpoYqKoHExXev7R0dJ+arzTTiuGkJu4bV2FNEkJeIeS9QnFLfSVvbFT?=
 =?us-ascii?Q?GnITlJzjHBklK3IMzzPJcGuQOnrYs9YwBdK284tGfXZ8YOJivaMUiBMR0muZ?=
 =?us-ascii?Q?ndydIz6x+8SPKnk7U78T+TTelmC7B7hmYg9hyPGT8eReL1iIx5sX4SV4u6jI?=
 =?us-ascii?Q?djmUFHXVrOKI6KyI6eQ0eQdI7NgO49UJj5U/8Xxlg9K/rYUyfAHfIo18Zu7p?=
 =?us-ascii?Q?GOpSF2h72PO9tTAtQddQztXXwYha/ohRYo0Jk3q1QFrHb9skI0joGTsNHzlP?=
 =?us-ascii?Q?apQH15yu8+3Pae/KCtsYxj2mBIA4qqCgrBiaO2WxzxUl81GhTW6uuwjKNia3?=
 =?us-ascii?Q?NgZPIid0Pt39PkBgG+qtJyvVFnR2jFEBrGQdVORgKGMqlFHpkhn0gNDEUzgg?=
 =?us-ascii?Q?vMzMLVxgvgqu6VJ+lkp/z661evg40WMrOMsjqDUVw8AqxFJGXmlgjS5TYZ4o?=
 =?us-ascii?Q?KW6RMsxON2h4JP4PObUy7r+xcJEYhMZj7s0T6+Sqaixz/f6M/XQOEQ03nWc7?=
 =?us-ascii?Q?++yHFIOrLuBxukdPf7QzgyQRmT9LvGKGpgdbSv5VrfcegI1VTlEhrLsz00sx?=
 =?us-ascii?Q?IT5X5Oh2jjxgYzru0q+lu542?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5244aee5-9555-41cd-2571-08d98e98366c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Oct 2021 22:24:25.0235
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zu8P/M3oWUIXBada5goXS4rCwr0sH3RLvK6ARsspgBq5wqt1arnrVhe0zwxBdp5jiYNBuRhc9XnMINj2kkeaEQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4816
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a schema validator to nxp,sja1105.yaml and to dsa.yaml for explicit
MAC-level RGMII delays. These properties must be per port and must be
present only for a phy-mode that represents RGMII.

We tell dsa.yaml that these port properties might be present, we also
define their valid values for SJA1105. We create a common definition for
the RX and TX valid range, since it's quite a mouthful.

We also modify the example to include the explicit RGMII delay properties.
On the fixed-link ports (in the example, port 4), having these explicit
delays is actually mandatory, since with the new behavior, the driver
shouts that it is interpreting what delays to apply based on phy-mode.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../devicetree/bindings/net/dsa/dsa.yaml      |  4 ++
 .../bindings/net/dsa/nxp,sja1105.yaml         | 42 +++++++++++++++++++
 2 files changed, 46 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 9cfd08cd31da..2ad7f79ad371 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -97,6 +97,10 @@ patternProperties:
 
           managed: true
 
+          rx-internal-delay-ps: true
+
+          tx-internal-delay-ps: true
+
         required:
           - reg
 
diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
index f97a22772e6f..0bbaefacdaba 100644
--- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
@@ -74,10 +74,42 @@ properties:
           - compatible
           - reg
 
+patternProperties:
+  "^(ethernet-)?ports$":
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        allOf:
+        - if:
+            properties:
+                phy-mode:
+                    contains:
+                        enum:
+                          - rgmii
+                          - rgmii-rxid
+                          - rgmii-txid
+                          - rgmii-id
+          then:
+            properties:
+                rx-internal-delay-ps:
+                    $ref: "#/$defs/internal-delay-ps"
+                tx-internal-delay-ps:
+                    $ref: "#/$defs/internal-delay-ps"
+
 required:
   - compatible
   - reg
 
+$defs:
+    internal-delay-ps:
+        description:
+            Disable tunable delay lines using 0 ps, or enable them and select
+            the phase between 1640 ps (73.8 degree shift at 1Gbps) and 2260 ps
+            (101.7 degree shift) in increments of 0.9 degrees (20 ps).
+        enum:
+            [0, 1640, 1660, 1680, 1700, 1720, 1740, 1760, 1780, 1800, 1820,
+            1840, 1860, 1880, 1900, 1920, 1940, 1960, 1980, 2000, 2020, 2040,
+            2060, 2080, 2100, 2120, 2140, 2160, 2180, 2200, 2220, 2240, 2260]
+
 unevaluatedProperties: false
 
 examples:
@@ -97,30 +129,40 @@ examples:
                             port@0 {
                                     phy-handle = <&rgmii_phy6>;
                                     phy-mode = "rgmii-id";
+                                    rx-internal-delay-ps = <0>;
+                                    tx-internal-delay-ps = <0>;
                                     reg = <0>;
                             };
 
                             port@1 {
                                     phy-handle = <&rgmii_phy3>;
                                     phy-mode = "rgmii-id";
+                                    rx-internal-delay-ps = <0>;
+                                    tx-internal-delay-ps = <0>;
                                     reg = <1>;
                             };
 
                             port@2 {
                                     phy-handle = <&rgmii_phy4>;
                                     phy-mode = "rgmii-id";
+                                    rx-internal-delay-ps = <0>;
+                                    tx-internal-delay-ps = <0>;
                                     reg = <2>;
                             };
 
                             port@3 {
                                     phy-handle = <&rgmii_phy4>;
                                     phy-mode = "rgmii-id";
+                                    rx-internal-delay-ps = <0>;
+                                    tx-internal-delay-ps = <0>;
                                     reg = <3>;
                             };
 
                             port@4 {
                                     ethernet = <&enet2>;
                                     phy-mode = "rgmii";
+                                    rx-internal-delay-ps = <0>;
+                                    tx-internal-delay-ps = <0>;
                                     reg = <4>;
 
                                     fixed-link {
-- 
2.25.1


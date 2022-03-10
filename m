Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D96F24D4C99
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245452AbiCJPBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:01:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343823AbiCJO6l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 09:58:41 -0500
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2042.outbound.protection.outlook.com [40.107.20.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AFE096805;
        Thu, 10 Mar 2022 06:52:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bpEev455qHMSDDCWecLpwjgeOcm0JiC6u3edK9i7mS9vZqzi2SQ+bceM165RBXHJuYbNaQVAbxKxuICcqolQFndxMwxS5Z4pFHkrcKaRblWpUl5/JTE/XjP+El2hZMrhw4ZVbUb6+RuAqZishs+/GeG/g2L+p58H51r35TJ+oPpc0kzzJqCv+thhm33kqMCAIrnxbUYBlRY5P4+8iJNEvls24rtmwhTttF3sfwNeEp0BYUAFc9gC1r/DpfCeQrwvqWAwTcEIdSDss09/nIJauWmBeIvYHRa/pdYFJiWoRERJFSx42eivW4OWzkkOO6cuJI2mIV2g+bBCrgm22P3New==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJ8c32OgR01WllKOwSrObJuplCpzsU4NwnbyPJ+yDQY=;
 b=A0w/HWN5K9seZxrvQpeKQHaP8hLHEDJ5pE21E3DPPwOirYHyzYoTvrllgzoVMeQV6zdjWeH2pv+e9LonixYmFOBUVUttfEeKoE+1EeWUBo/kutlqeE9lg68JLdD+Xzc4BKNeVgVCI0SdrgFlVH5LELv2qG1d3MeQandaTlVVDXgcfyn3l3e6YzUoIp3hwfXhdP27jGAT659G1yFtVZs3mpB7629/zxAUrlTKDtIgKPkYycOsSiHrcw6CWkN/cg9B/J5NMNHEijxMTSB5VcMFxClwUtz2pjS4Tob1v6M9ufde9bTKA/3BBlocAv7d+/3RWBHXRUeXnODEmZiwk0NFbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJ8c32OgR01WllKOwSrObJuplCpzsU4NwnbyPJ+yDQY=;
 b=VUIKbSbcB46VAJKQWaL4XHSoP/s/AwVjt/ILqRZxI46V6DqU6VuaObJ4rYWUQQp4wwLpOGhshRlsFVu5lHqI+Kwq6tx5gpE3hLc6XwZbSt9+TZfLSpk7uH//gLB7whHN2vY0zvug9XELv1saUsr5HllhUozIpC+LYNyET3coh3c=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com (2603:10a6:20b:436::16)
 by AM8PR04MB7281.eurprd04.prod.outlook.com (2603:10a6:20b:1d4::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.29; Thu, 10 Mar
 2022 14:52:24 +0000
Received: from AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579]) by AM9PR04MB8555.eurprd04.prod.outlook.com
 ([fe80::c58c:4cac:5bf9:5579%7]) with mapi id 15.20.5038.027; Thu, 10 Mar 2022
 14:52:24 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     kishon@ti.com, vkoul@kernel.org, robh+dt@kernel.org,
        leoyang.li@nxp.com, linux-phy@lists.infradead.org,
        devicetree@vger.kernel.org, linux@armlinux.org.uk,
        shawnguo@kernel.org, hongxing.zhu@nxp.com,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next v3 2/8] dt-bindings: phy: add the "fsl,lynx-28g" compatible
Date:   Thu, 10 Mar 2022 16:51:54 +0200
Message-Id: <20220310145200.3645763-3-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
References: <20220310145200.3645763-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS9PR06CA0288.eurprd06.prod.outlook.com
 (2603:10a6:20b:45a::19) To AM9PR04MB8555.eurprd04.prod.outlook.com
 (2603:10a6:20b:436::16)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b3a80f98-ab32-417f-11a0-08da02a5965a
X-MS-TrafficTypeDiagnostic: AM8PR04MB7281:EE_
X-Microsoft-Antispam-PRVS: <AM8PR04MB7281D1827E7E5C712507CC26E00B9@AM8PR04MB7281.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: O0hIIyx6U6U4FuYOicTnFlsg3YTb+Dx6NwlZtS3Y6o1foI9JLHBAfOfyKtaklSBTSlnKA3gW5KmXtdBkc8ZaMNflyku5cW6vTWlewVLCDPxJ02PGGnq9Hp6bXTPFmMT7SowIbmpo2826MqPhHPM6ushYc64lFN8rRB/92pJL1X8Fr8UZ5ffiJUZs3mIMg+8eGbi2vaZ8E6+tle7h86f0yPq1tLwrcVbDiQzOmO8MMtcSE8x6driB3qG9VkPi/RxFh1bH49AWplRnHPbt9cszdWTa6uiymTJwF121lJp1Rn7zBctwvbWDMTS4mvbB4HikO0/D56Ev5sxKO8rWsXVElcgVrkIK0fjuZnxVRCK7KJDFUFnvLUfSvJWYgt4iHQfVitEP0uQW7aO28vNRRBK4MX70tskRfTbjNJabIVHhQ4Llb4Gxg6HRijofcyQlW7DgrktfhvKJNAE/6GRCtKuTqwqvbZoK6VwrIFyvmRbydspCqGMSMdrsX3D1mQ3sjVhiBQAmZjL7DIqVNUsP8EwRPHvNi1lUK4d+pkFowlBuVKnV0y5iT2ITVBVxxqPKCH6Ly9NyvRM24IOG730EFqMdmVLEmApqW9kHLFsMrR+/EXTJHpVnh5w7a+F9SYyqn/qiK0k+mrLacQitkCEj5CmYC+qmOvGqVLPoxEqaBfdUG4kxzYzJW8FrGl6VuoBg0yJWsUBcrXu2LbINdO18ZOHdu99XvlHnA2N2/azWPkgFZzS9EPFg3FaAD0e7CDJNxMhBq+8K2nUHcMt1b0iYPawxZbUa9nsmyu5M49y6h9WNz88KL0oOjVTHcbwZFSgS5azrcfK1gEqhBG7Xi7bRKTzRKQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8555.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(1076003)(316002)(66556008)(6486002)(966005)(52116002)(66476007)(8676002)(5660300002)(6506007)(66946007)(4326008)(2616005)(2906002)(8936002)(86362001)(186003)(44832011)(38350700002)(38100700002)(6666004)(508600001)(36756003)(26005)(7416002)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qUMUPxJn/Qa9VAzwLCGGBN1TrB7gfOUG9gONH9zL2YEM3wIhjJuNHKu/yv8n?=
 =?us-ascii?Q?/G8V14/TVreHfs4rZKxxds/Az226KxD18aDu4ZuLKGfVTASpmYYazWk+zGJ1?=
 =?us-ascii?Q?RVDthm8RJCna6d18fzxa40rvTiHn1E5UaYY+GlbA0GxTrNpgV1FW1Q6BODIx?=
 =?us-ascii?Q?ycHueuZoFDeV7msFqAfEN+vs+3SXap1UJ02DuhdQldy7yX8zhyjq/utmVg5I?=
 =?us-ascii?Q?Y0LDTk5gL4E5fW2cuf/RziOIgRMvu6TtcqLKXEp+YVk0ORQOXGSpr9EYqZ6x?=
 =?us-ascii?Q?924gqufBH51k/93fcltblxEwELehY7DIVj0OV/Cm68pdps8IdWIt1zUaiKsM?=
 =?us-ascii?Q?iJ4MrUg5Af7HdzkzPoj9y8KydtHOzX2lTAxjNkMMp5M/Faari50qxXNqHrBi?=
 =?us-ascii?Q?Qzm7T3L3Gq6116VHmGxoMlkuhnoqVZsqlScujvbyLV4+9xhKeKneDmCz3k01?=
 =?us-ascii?Q?YKQ978HPfLiP+Gr6Ko8oIUgh29OwSDdKWDX3Bz9lLL3ERWiRxTFgprwB02hP?=
 =?us-ascii?Q?9lB3JTrhDsPi6CJZdKUbiqY6TGVx3qeIAzeQ5VNkx2V8Wibdl3+IJaqIu7fA?=
 =?us-ascii?Q?R77ldhOP4eoKWOHia3Pvz6QzVCfUWWgFoPHKtRAXr0QLKQcST4BH+MbWoian?=
 =?us-ascii?Q?t1dWHHdJ2v8MVeb5SBW+CmZnw3uXY5aX8TlzXSGTR+cmdOvNPsgBJ3Wp8kAj?=
 =?us-ascii?Q?WifbhlQBsVb3fthlCXGXXtW6a6G9+kEpLJLDOCGCBe+wPfzIsAaMufqzax7q?=
 =?us-ascii?Q?El/nPYL5DtJpdv0IpG9kLYn+ZM03CWOIwhEcWJO3WQMfvoTu3Spuj+00ibbN?=
 =?us-ascii?Q?dCnDMhBIHNIzJocG8yOxYx9PPQFdk1H1FD7hWNLsmRz1Bm2QshiS7ErvK1fr?=
 =?us-ascii?Q?7XT7UKLr9S2JsAjfzvAwd/z3xc7Cw9VUSuikWxCeTeXMDlp86hg0sBDF+DOD?=
 =?us-ascii?Q?LaliEv21c0kdukYYPU5uv5hzTOOzE/YM7/b1T54g/3nYsccN3K9fnVFIe8RW?=
 =?us-ascii?Q?j8hY96hDP+lsz3/SeMLCaelyMZ92SIzhbFj7Vwo5KOdK6QL3POC2ImHkVVEl?=
 =?us-ascii?Q?8cE7XQbrGL7//OLgIJTI0CIuMrA2t4Silsf7Tk8CMFqGRFtMd0Vkw9LVAuUT?=
 =?us-ascii?Q?XwAkJU8psXYd3ql/C8c42agokFY/j32c+HDWM3fxY3Tzd9M+MJ4FMtfXV2sd?=
 =?us-ascii?Q?z3L3bcBxncA3UPSZh3iO7XhmFDqzjkR5BZfC74uoudsBYKSdrfr7wsQyN9se?=
 =?us-ascii?Q?g8U3KIX0nH+gEZVfddJtnzhhR5PwZyy9J75upsyD879mWyJ7UO3guR4Wm7AH?=
 =?us-ascii?Q?QQSirszU3IUW2ncFP1gCg/eVEYmye9wXfm5yt6/lbdvxh4g5udPfpqrY296w?=
 =?us-ascii?Q?2gPaPsY6jBv2sOIuYzRwMYdHqHrCtkmZYm6f+F+Ay5vPv1KjcgqKKF3F8XDE?=
 =?us-ascii?Q?0jgfBjZEtzBDoAeowCIEhL+13swsGBh4Tz4WB2nKMCpbaMFBpuykZl2wTlLY?=
 =?us-ascii?Q?9PfcWe2SpMtHE4J6V7liHT9IznJNqZZSmxXqI2p0QZ+C5FaZqo4FRDHlXAlb?=
 =?us-ascii?Q?UMqKMbxyDRbxM1iTgYXmWRLI/staUCAwGadQMzCDQsYO/s89ssBw9KNfFIWL?=
 =?us-ascii?Q?y7q9Vx6SbLmwshNmYL8zfMs=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b3a80f98-ab32-417f-11a0-08da02a5965a
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8555.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2022 14:52:24.3231
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6RHqRS/zurPKxypljJZJ4AyBZGZ5SHzl1h1qW0GRflPwhpmcAVekxpNGVOrlAD61bv1QrLd8mDe8bl5to4NFvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR04MB7281
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe the "fsl,lynx-28g" compatible used by the Lynx 28G SerDes PHY
driver on Layerscape based SoCs.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
Changes in v2:
	- none
Changes in v3:
	- 2/8: fix 'make dt_binding_check' errors

 .../devicetree/bindings/phy/fsl,lynx-28g.yaml | 98 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 2 files changed, 99 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml

diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
new file mode 100644
index 000000000000..e98339ec83a7
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
@@ -0,0 +1,98 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/fsl,lynx-28g.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Freescale Lynx 28G SerDes PHY binding
+
+maintainers:
+  - Ioana Ciornei <ioana.ciornei@nxp.com>
+
+properties:
+  compatible:
+    enum:
+      - fsl,lynx-28g
+
+  reg:
+    maxItems: 1
+
+  "#phy-cells":
+    const: 1
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+required:
+  - compatible
+  - reg
+  - "#phy-cells"
+  - "#address-cells"
+  - "#size-cells"
+
+patternProperties:
+  '^phy@[0-9a-f]$':
+    type: object
+    properties:
+      reg:
+        description:
+          Number of the SerDes lane.
+        minimum: 0
+        maximum: 7
+
+      "#phy-cells":
+        const: 0
+
+    additionalProperties: false
+
+additionalProperties: false
+
+examples:
+  - |
+    soc {
+      #address-cells = <2>;
+      #size-cells = <2>;
+      serdes_1: serdes_phy@1ea0000 {
+        compatible = "fsl,lynx-28g";
+        reg = <0x0 0x1ea0000 0x0 0x1e30>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+        #phy-cells = <1>;
+
+        serdes1_lane_a: phy@0 {
+          reg = <0>;
+          #phy-cells = <0>;
+        };
+        serdes1_lane_b: phy@1 {
+          reg = <1>;
+          #phy-cells = <0>;
+        };
+        serdes1_lane_c: phy@2 {
+          reg = <2>;
+          #phy-cells = <0>;
+        };
+        serdes1_lane_d: phy@3 {
+          reg = <3>;
+          #phy-cells = <0>;
+        };
+        serdes1_lane_e: phy@4 {
+          reg = <4>;
+          #phy-cells = <0>;
+        };
+        serdes1_lane_f: phy@5 {
+          reg = <5>;
+          #phy-cells = <0>;
+        };
+        serdes1_lane_g: phy@6 {
+          reg = <6>;
+          #phy-cells = <0>;
+        };
+        serdes1_lane_h: phy@7 {
+          reg = <7>;
+          #phy-cells = <0>;
+        };
+      };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 383c4754096e..15670690527b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11340,6 +11340,7 @@ LYNX 28G SERDES PHY DRIVER
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Supported
+F:	Documentation/devicetree/bindings/phy/fsl,lynx-28g.yaml
 F:	drivers/phy/freescale/phy-fsl-lynx-28g.c
 
 LYNX PCS MODULE
-- 
2.33.1


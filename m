Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DD95B5D52
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 17:37:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiILPhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 11:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230102AbiILPhU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 11:37:20 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2065.outbound.protection.outlook.com [40.107.21.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4A6E25595;
        Mon, 12 Sep 2022 08:37:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZK0Iyk5jOnTPq/4UyWz789CuuO8Nl3seBi8w5fSV1pG5SZCds522guzg/mK0IszvUvZWly2mwa6jpR4EAUrrrx5ArQXiD9jBvCXVWVCu7UHgFx2iVuyUmkcJIsusR7nw6JVDQBphN+10VrO9TsMS11uG31u8j0ebpqsn4ZpraG3wafNpnIIHbOW8SlWmCOYWhWtnfz/7KG7AtOzfO3Y8rIcXbS1EvJOIdzhoRQ5Hb8qkpUYjBh+r6BsD58r06pTHgdp6bVMLnyqX/4HCcIVCurLPBRi0Smd8StBpSE4JJNO2MolAI8rl1xr3VBM051hADPnT1sGk6U1KUCvrnfJuYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AFgxgBS/7L2TXroJUJqhIvFVIKvEUVUWHLfSJiM3F/0=;
 b=PLMkKmMpBNawU1PSscu1fvjewhrbiz9if7/wGgpUM2w/dRprKDL6PreQbPupFCgJqSLNJfJkEwWJmyoPc9oHtC0JYVYPDNnSLOqkJQqce6RYklkKpNUhBregmGCUejqoOer11Z+K6sSPnRqnmPmJZtLh06IGly3AWKC7wtyua7PbJqArYEJsHOjn2gcpPZQNILwy2UvpdBLSql48D1mMx/0Ev1gISA8VmZ76vCCqvIeIAOdNY6d0TciNV341vFnc8bm6KkTEbinW/rwzr1VnsLe+/dirDyn5kO8YID79EU6YyS19Grk/le6mM+CV8h7ugZ2cYgpAaPcok5C5RKl1fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AFgxgBS/7L2TXroJUJqhIvFVIKvEUVUWHLfSJiM3F/0=;
 b=boeu1iRSyd47Q4tO6GPcc9YqRdVtytGE5iCcloNZ+4KT+Abv/mNrRV8h44zALjBTntc3EV39iLMATktZtjPK3DmOeZhaF0xy88xHyHoqbaEzUqy1Cjzk41hMNj4OC4LpFxkT86mDgbXj8+c2xioEGc3iLnttA5OCSn3A54NDKn0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by DB8PR04MB6987.eurprd04.prod.outlook.com (2603:10a6:10:118::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 15:37:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::a67a:849c:aeff:cad1%7]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 15:37:15 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next] dt-bindings: net: dsa: convert ocelot.txt to dt-schema
Date:   Mon, 12 Sep 2022 18:37:02 +0300
Message-Id: <20220912153702.246206-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BEXP281CA0001.DEUP281.PROD.OUTLOOK.COM (2603:10a6:b10::11)
 To VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|DB8PR04MB6987:EE_
X-MS-Office365-Filtering-Correlation-Id: 01f44400-7ed1-4c83-7bc6-08da94d4ab5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lZI4+q34qrEx3IQN7qZNCj6xWiXe1EIF/JQrBlAGfm82FQ/5UgLO3EGJsdqEKCKU2EenePQ3z99045mcKgIcN/60asQRpvpYRwe18t0JepyvLrRkpAVRdYgKDhOFI61Y6R4EGQ8l2r9GLDo8dwwaRiCeSvm9jRmLxujQYwhjGjd1hGweGDYGGXBqfrKZVK/d0HQWg4rMWQLmOngtxhT5WLqPHiJqV9YjG31qnXPORMwpXfeFW+dzod+H3/PEeE/ka0XBtr75fAYEq6ZU6sSCQz5RgKe8XuwCXr5LFj/rgJwtleNYRN7PihODYa3udI6KUABT0Z2JSlmWApmvNG0/80iVx6MEcJ9oBZqj2KhgmAQGwFWjP7HvWtjqmxhBh5ht/sDSbDmlLz9nVDAtRLIErM3/5nldSLrnAIO9pJy5l0rHdmIBl4LLtI3zL12RvJQ7WopwMdsvTYSi8hS/k57ZJT71oLKghCKsmVA340PcDmUgxYf2ZFOLcP0gzE4YNhiYh/S3kW2aY2VeRfGNHDsQvwUWo68w7jSVLGMOOUn2UlVxDxY4L2MmKXPWK5kNUOiTUyMecPUehPj62BJ6Jn87dUWKIhzFIXRkUSlW9qlxZBYsLukvsHFlMvgYgfQSDvdKq0+jIvwN9hh50dfl4/C80RNkZ6xBKDcfcS7sLbaN2Hevn9Typ6ZZXJNL0/kpIqRobRqquga3LZPpki12uUHiXr+FpU8Q7j+mGiPqFt0YWoVaRPlt/G83imejXuFhIiBMm4LcBmplkQOou73DN9Hb08Ue1uE33JZUgh7ZKyZ7eynRLRK5tCxQI8OCGlxg4sCq9ERCmfGMJRchdf6ZTPFJ8A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(6506007)(52116002)(26005)(6512007)(86362001)(6666004)(966005)(478600001)(41300700001)(6486002)(1076003)(186003)(2616005)(83380400001)(36756003)(5660300002)(7416002)(66946007)(38100700002)(2906002)(6916009)(66476007)(66556008)(44832011)(38350700002)(8936002)(8676002)(316002)(4326008)(54906003)(30864003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?s2tqSDJ4NmaD5c3XnyFaI22P9HB3xtc6ujkxkZjkkPusItxskTL0EMI01MrS?=
 =?us-ascii?Q?31nFR0N6lfBXFBjsiYMKpRGil95Lb+xKFSZkm6PGp04ftKFnX2CJ9gKXeb6h?=
 =?us-ascii?Q?8g1t0L5rA82Lz0tUdHnlOlCq1haYbhKilZ0AcKUaldVNUD0fyNGH4WCfl9Ju?=
 =?us-ascii?Q?j+kPpjr9BtlBOAWXaBwh6nXEOcJXV0AGwyMziHGrVQQOsOAOZwvrSoqsJ5Sl?=
 =?us-ascii?Q?UnYjf9RWj2MuPgGPMSNO8QDK2i9jPRE6yX6TlD7garWPBVOx07lfw/7Qutnq?=
 =?us-ascii?Q?iNXHZDSy66B4UknB9O78NTW+Fw4Vfj8/4+jPRx6OJsYQXvBgyVssNLo4wFEv?=
 =?us-ascii?Q?VKwSwB/TRVzpuNmMomP6lcbXLQhlbk/XaE3M9PSH5XFAzAtzcAf/pEZcHan9?=
 =?us-ascii?Q?bo9azut4KNxnqjFLDY7xLIBlvAJZJdvgFtWqpI66PD6jJsPT0zPRG1arv+nf?=
 =?us-ascii?Q?f3F23BXFEue18dme8T9B+BdgwkdxK0qosdYHTwPQAqv2qKG9+1SNjTH6gFj/?=
 =?us-ascii?Q?B+Xry/oz3X6VUejhCzMNDshhKIZXS+NRZMP5lIKfVJ+gwZA8XjLI2PifA6MJ?=
 =?us-ascii?Q?1F0FxCVuZIKFqUVCfbPnmE23P8WTNUuxCX3MwbHju89Ofw5lihOHRyt8Nd9R?=
 =?us-ascii?Q?y39dVlR6Sn6B6r00lIy6rgJ+tTLVWmCDU/pRiwXkty1YrPdh/fb1ZMnUVQmF?=
 =?us-ascii?Q?vUMazieYMRTyZt8Z72g2CpHTxX777sdPmxnzG/+GGw9VJredsXQ10zK8ZS/Q?=
 =?us-ascii?Q?3mCPDp5hKIyp4H9QtSspTeDOPkM1EN85ayT2Nz15BaTitWXHQw6JfL1ANZwc?=
 =?us-ascii?Q?VF5NkP0Ys0UYnIG6R/e9AxwH0JcxXPqF5ww3O9euQ7i5eVO1hooI3RtTw2qg?=
 =?us-ascii?Q?iO5OsfvU016DZZz87Y9j+2f+57Lzb4R08QnRdjdHQZH4JkhxFT7pL4nFDCBH?=
 =?us-ascii?Q?rm1lIafVEj4X6dFXOtvLijjfhBzvMj+1TjO644JxwoI5RWkk9yfVBfoNOIfm?=
 =?us-ascii?Q?3WXOGnShAfT9swFlk2ORVV934Yd3lw3xpFSUGnXxnDC2iaADHXP6gH4CXWgT?=
 =?us-ascii?Q?27fqGUgXMTxm6N9lG0dswoyXmqTKmfe1aAftVd7qJVQPzh+Q/BBEjfrYog40?=
 =?us-ascii?Q?RE603xQA9TOEGph+3oYjeqkgX9I1kL/OBXtbDw9zUg2H8l5z/yMGylJCwLg7?=
 =?us-ascii?Q?DEEfmuaB9T/cyAUOPAW2XBTJWeDYHgBDpLzm4xZnqHAxTNacPXTLUQFhMeAw?=
 =?us-ascii?Q?Ik5GcEg2MvUJdRwwdYlx2Z9iE1bO/DznytKWmd1P80IDtquXlxRYpA0GYOvB?=
 =?us-ascii?Q?+DoN7upwwJRL7WBEmd1DZ7lzlHLOZupgW+Cf6WCdiLkVBBZQAprD7x3+ASSU?=
 =?us-ascii?Q?+OdiQlEWSJSyRDbtM8W7sM/aDb6iNfpJxwzP7U58ITPoo5fvdu6D3D7mZGzT?=
 =?us-ascii?Q?kqOXRmgPezHyKu4CIHrOlTkOxfXoDqHy7q0niBzgNXWEN6mb/UQyU3WK9ord?=
 =?us-ascii?Q?Fp9aKql+3tb+Nfu4fyutVuoGSRuluLWA/1oHOr+dkjnMvxhoMDfK9+a6EFLv?=
 =?us-ascii?Q?3IgnNG3wR2Gf8gOiarE+Bklf+qdPne7yOYZQpNW6uUTpa9nWFrgZWAlquaXR?=
 =?us-ascii?Q?4g=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 01f44400-7ed1-4c83-7bc6-08da94d4ab5e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 15:37:15.7919
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ijgPiwcwYax4OLWewsAi7KM0XcSMN9hdSli5Do+Ndjy5xL1AXK3FL0KmDhFFcE7l5LwQGv4T4mQW5VYSPf9L3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6987
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Replace the free-form description of device tree bindings for VSC9959
and VSC9953 with a YAML formatted dt-schema description. This contains
more or less the same information, but reworded to be a bit more
succint.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../bindings/net/dsa/mscc,ocelot.yaml         | 239 ++++++++++++++++++
 .../devicetree/bindings/net/dsa/ocelot.txt    | 213 ----------------
 2 files changed, 239 insertions(+), 213 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/ocelot.txt

diff --git a/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
new file mode 100644
index 000000000000..36c63ec16c05
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/dsa/mscc,ocelot.yaml
@@ -0,0 +1,239 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/dsa/mscc,ocelot.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Microchip Ocelot Switch Family Device Tree Bindings
+
+maintainers:
+  - Vladimir Oltean <vladimir.oltean@nxp.com>
+  - Claudiu Manoil <claudiu.manoil@nxp.com>
+  - Alexandre Belloni <alexandre.belloni@bootlin.com>
+  - UNGLinuxDriver@microchip.com
+
+description: |
+  There are multiple switches part of the Ocelot family.
+
+  VSC9953 (Seville):
+
+    This is found in the NXP T1040, where it is a memory-mapped platform
+    device.
+
+    The following PHY interface types are supported:
+
+      - phy-mode = "internal": on ports 8 and 9
+      - phy-mode = "sgmii": on ports 0, 1, 2, 3, 4, 5, 6, 7
+      - phy-mode = "qsgmii": on ports 0, 1, 2, 3, 4, 5, 6, 7
+      - phy-mode = "1000base-x": on ports 0, 1, 2, 3, 4, 5, 6, 7
+
+  VSC9959 (Felix):
+
+    This is found in the NXP LS1028A. It is a PCI device, part of the larger
+    ENETC root complex. As a result, the ethernet-switch node is a sub-node of
+    the PCIe root complex node and its "reg" property conforms to the parent
+    node bindings, describing it as PF 5 of device 0, bus 0.
+
+    If any external switch port is enabled, the ENETC PF2 (enetc_port2) should
+    be enabled as well, regardless of whether it is configured as the DSA
+    master or not. This is because the Felix PHYLINK implementation accesses
+    the MAC PCS registers, which in hardware truly belong to the ENETC port 2
+    and not to Felix.
+
+    The following PHY interface types are supported:
+
+      - phy-mode = "internal": on ports 4 and 5
+      - phy-mode = "sgmii": on ports 0, 1, 2, 3
+      - phy-mode = "qsgmii": on ports 0, 1, 2, 3
+      - phy-mode = "usxgmii": on ports 0, 1, 2, 3
+      - phy-mode = "1000base-x": on ports 0, 1, 2, 3
+      - phy-mode = "2500base-x": on ports 0, 1, 2, 3
+
+allOf:
+  - $ref: dsa.yaml#
+
+properties:
+  compatible:
+    enum:
+      - mscc,vsc9953-switch
+      - pci1957,eef0
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  # Felix VSC9959 (NXP LS1028A)
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    pcie { /* Integrated Endpoint Root Complex */
+            #address-cells = <3>;
+            #size-cells = <2>;
+
+            ethernet-switch@0,5 {
+                    compatible = "pci1957,eef0";
+                    reg = <0x000500 0 0 0 0>;
+                    /* IEP INT_B */
+                    interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
+
+                    ethernet-ports {
+                            #address-cells = <1>;
+                            #size-cells = <0>;
+
+                            port@0 {
+                                    reg = <0>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy0>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@1 {
+                                    reg = <1>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy1>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@2 {
+                                    reg = <2>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy2>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@3 {
+                                    reg = <3>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy3>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@4 {
+                                    reg = <4>;
+                                    ethernet = <&enetc_port2>;
+                                    phy-mode = "internal";
+
+                                    fixed-link {
+                                            speed = <2500>;
+                                            full-duplex;
+                                            pause;
+                                    };
+                            };
+
+                            port@5 {
+                                    reg = <5>;
+                                    ethernet = <&enetc_port3>;
+                                    phy-mode = "internal";
+
+                                    fixed-link {
+                                            speed = <1000>;
+                                            full-duplex;
+                                            pause;
+                                    };
+                            };
+                    };
+            };
+    };
+  # Seville VSC9953 (NXP T1040)
+  - |
+    soc {
+            #address-cells = <1>;
+            #size-cells = <1>;
+
+            ethernet-switch@800000 {
+                    compatible = "mscc,vsc9953-switch";
+                    reg = <0x800000 0x290000>;
+                    little-endian;
+
+                    ethernet-ports {
+                            #address-cells = <1>;
+                            #size-cells = <0>;
+
+                            port@0 {
+                                    reg = <0>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy0>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@1 {
+                                    reg = <1>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy1>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@2 {
+                                    reg = <2>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy2>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@3 {
+                                    reg = <3>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy3>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@4 {
+                                    reg = <4>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy4>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@5 {
+                                    reg = <5>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy5>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@6 {
+                                    reg = <6>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy6>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@7 {
+                                    reg = <7>;
+                                    phy-mode = "qsgmii";
+                                    phy-handle = <&phy7>;
+                                    managed = "in-band-status";
+                            };
+
+                            port@8 {
+                                    reg = <8>;
+                                    phy-mode = "internal";
+                                    ethernet = <&enet0>;
+
+                                    fixed-link {
+                                            speed = <2500>;
+                                            full-duplex;
+                                            pause;
+                                    };
+                            };
+
+                            port@9 {
+                                    reg = <9>;
+                                    phy-mode = "internal";
+                                    ethernet = <&enet1>;
+
+                                    fixed-link {
+                                            speed = <2500>;
+                                            full-duplex;
+                                            pause;
+                                    };
+                            };
+                    };
+            };
+    };
diff --git a/Documentation/devicetree/bindings/net/dsa/ocelot.txt b/Documentation/devicetree/bindings/net/dsa/ocelot.txt
deleted file mode 100644
index 7a271d070b72..000000000000
--- a/Documentation/devicetree/bindings/net/dsa/ocelot.txt
+++ /dev/null
@@ -1,213 +0,0 @@
-Microchip Ocelot switch driver family
-=====================================
-
-Felix
------
-
-Currently the switches supported by the felix driver are:
-
-- VSC9959 (Felix)
-- VSC9953 (Seville)
-
-The VSC9959 switch is found in the NXP LS1028A. It is a PCI device, part of the
-larger ENETC root complex. As a result, the ethernet-switch node is a sub-node
-of the PCIe root complex node and its "reg" property conforms to the parent
-node bindings:
-
-* reg: Specifies PCIe Device Number and Function Number of the endpoint device,
-  in this case for the Ethernet L2Switch it is PF5 (of device 0, bus 0).
-
-It does not require a "compatible" string.
-
-The interrupt line is used to signal availability of PTP TX timestamps and for
-TSN frame preemption.
-
-For the external switch ports, depending on board configuration, "phy-mode" and
-"phy-handle" are populated by board specific device tree instances. Ports 4 and
-5 are fixed as internal ports in the NXP LS1028A instantiation.
-
-The CPU port property ("ethernet") configures the feature called "NPI port" in
-the Ocelot hardware core. The CPU port in Ocelot is a set of queues, which are
-connected, in the Node Processor Interface (NPI) mode, to an Ethernet port.
-By default, in fsl-ls1028a.dtsi, the NPI port is assigned to the internal
-2.5Gbps port@4, but can be moved to the 1Gbps port@5, depending on the specific
-use case.  Moving the NPI port to an external switch port is hardware possible,
-but there is no platform support for the Linux system on the LS1028A chip to
-operate as an entire slave DSA chip.  NPI functionality (and therefore DSA
-tagging) is supported on a single port at a time.
-
-Any port can be disabled (and in fsl-ls1028a.dtsi, they are indeed all disabled
-by default, and should be enabled on a per-board basis). But if any external
-switch port is enabled at all, the ENETC PF2 (enetc_port2) should be enabled as
-well, regardless of whether it is configured as the DSA master or not. This is
-because the Felix PHYLINK implementation accesses the MAC PCS registers, which
-in hardware truly belong to the ENETC port #2 and not to Felix.
-
-Supported PHY interface types (appropriate SerDes protocol setting changes are
-needed in the RCW binary):
-
-* phy_mode = "internal": on ports 4 and 5
-* phy_mode = "sgmii": on ports 0, 1, 2, 3
-* phy_mode = "qsgmii": on ports 0, 1, 2, 3
-* phy_mode = "usxgmii": on ports 0, 1, 2, 3
-* phy_mode = "2500base-x": on ports 0, 1, 2, 3
-
-For the rest of the device tree binding definitions, which are standard DSA and
-PCI, refer to the following documents:
-
-Documentation/devicetree/bindings/net/dsa/dsa.txt
-Documentation/devicetree/bindings/pci/pci.txt
-
-Example:
-
-&soc {
-	pcie@1f0000000 { /* Integrated Endpoint Root Complex */
-		ethernet-switch@0,5 {
-			reg = <0x000500 0 0 0 0>;
-			/* IEP INT_B */
-			interrupts = <GIC_SPI 95 IRQ_TYPE_LEVEL_HIGH>;
-
-			ports {
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				/* External ports */
-				port@0 {
-					reg = <0>;
-					label = "swp0";
-				};
-
-				port@1 {
-					reg = <1>;
-					label = "swp1";
-				};
-
-				port@2 {
-					reg = <2>;
-					label = "swp2";
-				};
-
-				port@3 {
-					reg = <3>;
-					label = "swp3";
-				};
-
-				/* Tagging CPU port */
-				port@4 {
-					reg = <4>;
-					ethernet = <&enetc_port2>;
-					phy-mode = "internal";
-
-					fixed-link {
-						speed = <2500>;
-						full-duplex;
-					};
-				};
-
-				/* Non-tagging CPU port */
-				port@5 {
-					reg = <5>;
-					phy-mode = "internal";
-					status = "disabled";
-
-					fixed-link {
-						speed = <1000>;
-						full-duplex;
-					};
-				};
-			};
-		};
-	};
-};
-
-The VSC9953 switch is found inside NXP T1040. It is a platform device with the
-following required properties:
-
-- compatible:
-	Must be "mscc,vsc9953-switch".
-
-Supported PHY interface types (appropriate SerDes protocol setting changes are
-needed in the RCW binary):
-
-* phy_mode = "internal": on ports 8 and 9
-* phy_mode = "sgmii": on ports 0, 1, 2, 3, 4, 5, 6, 7
-* phy_mode = "qsgmii": on ports 0, 1, 2, 3, 4, 5, 6, 7
-
-Example:
-
-&soc {
-	ethernet-switch@800000 {
-		#address-cells = <0x1>;
-		#size-cells = <0x0>;
-		compatible = "mscc,vsc9953-switch";
-		little-endian;
-		reg = <0x800000 0x290000>;
-
-		ports {
-			#address-cells = <0x1>;
-			#size-cells = <0x0>;
-
-			port@0 {
-				reg = <0x0>;
-				label = "swp0";
-			};
-
-			port@1 {
-				reg = <0x1>;
-				label = "swp1";
-			};
-
-			port@2 {
-				reg = <0x2>;
-				label = "swp2";
-			};
-
-			port@3 {
-				reg = <0x3>;
-				label = "swp3";
-			};
-
-			port@4 {
-				reg = <0x4>;
-				label = "swp4";
-			};
-
-			port@5 {
-				reg = <0x5>;
-				label = "swp5";
-			};
-
-			port@6 {
-				reg = <0x6>;
-				label = "swp6";
-			};
-
-			port@7 {
-				reg = <0x7>;
-				label = "swp7";
-			};
-
-			port@8 {
-				reg = <0x8>;
-				phy-mode = "internal";
-				ethernet = <&enet0>;
-
-				fixed-link {
-					speed = <2500>;
-					full-duplex;
-				};
-			};
-
-			port@9 {
-				reg = <0x9>;
-				phy-mode = "internal";
-				status = "disabled";
-
-				fixed-link {
-					speed = <2500>;
-					full-duplex;
-				};
-			};
-		};
-	};
-};
-- 
2.34.1


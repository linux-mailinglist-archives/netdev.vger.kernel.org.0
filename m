Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6454B576943
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 00:00:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbiGOWAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 18:00:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230477AbiGOWAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 18:00:19 -0400
Received: from EUR03-VE1-obe.outbound.protection.outlook.com (mail-eopbgr50072.outbound.protection.outlook.com [40.107.5.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CF04B497;
        Fri, 15 Jul 2022 15:00:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IGVeSd/4QEFE7w5e7WRs7qOh/oO3ZASAgRM2ST3G4mgqvKE/9b+31Seskqotge9weWkZpkTqtVvRD1WnjJ0o2/q1lXcbYu1dhzo7BI3wogkfMapQkTGZWju2AcCy+M6UdWk4B+dksIDRu8uhHj+UnD3hBw0i8xm3nHhJJGnd8zj+XiCGqhGYEUhuhZz+65g5pPds5Bto9nbDM42VCVvhpEWNEM2wSDIp74ZXOLkCSTW84oHwndDctmbKG7oXGjsqqaNwm/tqhbIbpiA5MOwHH4VL6wcyDkM/IkX/wzXL4VTT6z5kTiEfYq5QAXAoJY7hUlyItBSI3DkTz2fPlYsl/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rzVIwzNMrkwZxhxqNQ3gDqq2qVzLHZ0a671vqf+uEB0=;
 b=PCs4/uMnAPkViyU9Q8YPU/KJKEHkXYnWLzdyUkfoBMZtz69dfGJOyI8Zx/R9lalFKZqMVFeDdS8W9aojiO18jpLKFf1qEHHkJqJkWSQCzC60si9tXBssnXWNdo0VRQ3N3ZkX8x2RLqNNgYX1WLTVXlG2x8cS3dFxrlDmNrKZCR5OoZVHHHhv8bp7DHs4D1CswPS2Wi46fem13AYJCfNxlJWhtiqY1v88+So+NU3ovm1WFQF568DT1l7Dq3/HOuhsL//5AB8rTOsJ0Fk0e5AIvsTq/F8T5yX8BFhBcpFENtEJU68znVA9zaEJ2r2n3EtciHjLlSGFh++chySDnPUoZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rzVIwzNMrkwZxhxqNQ3gDqq2qVzLHZ0a671vqf+uEB0=;
 b=lGWv5W48rRzeJHA/9RJJCDg0bZSEbNGxWpfN1hVwsAUfSWcSdGXBNSjshWQPTXHJTxm8hGVN8PUuuZK6JUPDhijtcaiv/nPjCyts2AgurjnqxLpP1h+GXKc+qJLF98loMzrjDVuu+kbvFiE2hDvdQjpgzjBhxzwmq7r2W3Ho3glFSMP2IGdjlK/jPQsMq8Ix77N9cXK81Eu40GPyG088GAtzMkruBV+ap3+QVDzbX5kH0cKK6M5iXBQsrco7HyeyU8IYg57TEjvbjS2kfeoBqOvEMPcz/Wh8YfzOGtVyBzmxOlypW/h1M2/8X7EJwZT4Ide0G5kmCAk8a6wER2O8og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com (2603:10a6:803:c5::12)
 by DU0PR03MB8598.eurprd03.prod.outlook.com (2603:10a6:10:3e5::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.15; Fri, 15 Jul
 2022 22:00:13 +0000
Received: from VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558]) by VI1PR03MB4973.eurprd03.prod.outlook.com
 ([fe80::5c3e:4e46:703b:8558%7]) with mapi id 15.20.5438.015; Fri, 15 Jul 2022
 22:00:13 +0000
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
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: [PATCH net-next v3 01/47] dt-bindings: phy: Add Lynx 10G phy binding
Date:   Fri, 15 Jul 2022 17:59:08 -0400
Message-Id: <20220715215954.1449214-2-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 6240f76b-e7a4-4004-5bbd-08da66ad6466
X-MS-TrafficTypeDiagnostic: DU0PR03MB8598:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3+izDLO+KLazzR4qUGmePmnUo0C7c9hQpG5NdS9tXukCO2NMkKVOcdidMtD5BOA/a0LUHdRLNjAvS2FlJm4YcQfxs+JCFOWjMVvqN5UYHru6MEJiN/nkPwhgi9xbPJ/Nb4xWeXgQ6fMg5fLnkXKT6Nl4TiGQ6hO+Wp4WYXrRaFmsl6XwMNDsKk+AfBgFthyM5xosrUMKsk/dYb+WeDX0IzF2DhkErs88GMn9zxsFDe2ybSGK1B8EnQTzJTdqCB0yLzbzxdBPffg6nPpuWkKh5rIkBqCrBZQB8Q4l2Ed1YnKukF96CNjzzkO//qvXjZe4zQY6razAB5HQrr8t8yACcf7xkxsN6bnCtN+f9J6vg+4lOS1pferovib3QlxQCCOFfNx87VLR9PwCP892M35LCoQSjRZyOpkTDr1j45xMtBAyTbiDL4MVRZ3rnP/hSd9u35FAYS7z8mnVUzfAVhDDB/NfM1x+fWVdXFKqLzjhWUQxWIOvsdli61vk/Ls9C1nxGRyNql9eOv/bci9gas7itKeVgVEgwCLUeiTCWofcNeWjfZwbBDNqnWURd7j2U7s/ZB9aRPy9evXkBUqey2uaQGo7EyhwTYQMRjA+qIMI0Hog1r/CNObFlPLtWJuf+IXPvnViMLR9Sm2LPW+99bPKP57+o7ejXl3FaHy986LZ6G7DuaC5zXJ98odqn9d2NnAKXFVtQqh2xAQPZuXfs6+dloVlqJfaH7JacTSu8PVrV7yH++J4AGtH9a8mVqN4e7xVIRAZ24lOdLbt6G/f536Fd85yissMLJ18hWEMF6RioIRSOesiyCNWIdDM0NqIbWtvNCgospvBhCOdHk6TC+e8Hw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB4973.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(39850400004)(376002)(346002)(396003)(5660300002)(8936002)(44832011)(7416002)(2906002)(54906003)(66556008)(4326008)(8676002)(66476007)(66946007)(110136005)(86362001)(316002)(186003)(2616005)(26005)(38350700002)(52116002)(36756003)(6666004)(41300700001)(478600001)(6486002)(966005)(1076003)(6506007)(83380400001)(6512007)(38100700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ATpelNNnp6VEa6TR42bVtnGYs/9iMOcFopwmShzjY5jI+hEdUuB0ArHGzRgv?=
 =?us-ascii?Q?0Ypjzabr56SlY4jm5JjMtkSNfgDdgN4coUHiY+Th3qmY/CNrVfnd7Ghpe+CS?=
 =?us-ascii?Q?AAGvYzUfYkaFRPvzyH28igtk44CK8M3IHzmt4fshkPYviRVk8QgLza5b5fTC?=
 =?us-ascii?Q?RNuUltyGcHdQ/BgU1H5FSiW9FyMDSpKfSvfU1IEqpLLEPYDu2kmJ9C9M9VJ1?=
 =?us-ascii?Q?lvauGSWKMJULW9QCth20komEPiyeq7TUf8SoppAFJpEFCvr4hg6mvDbakiig?=
 =?us-ascii?Q?4vp6/JwuAz6/PrW8kRxL0oiDCOGmfhMaGFyyAG4CLjaGKIy2PzAjl66yVHrM?=
 =?us-ascii?Q?GBRGPutNJnFjfnzWFopUngk/MzrMhqKGPePYpkPTQrUIwiVVHHPu+NrOKZzr?=
 =?us-ascii?Q?4OsHjQ8/ZB/aBf23fQn2D/eKbfr3fsO0JiBp8xa9skI84hhtn+JfnIGWfzqn?=
 =?us-ascii?Q?1GiwS60bDrD5DsjInuhklPypb4Gs1sjyBDiCqTSTz0rW3ki2xkBnaR938eeY?=
 =?us-ascii?Q?yKlEKTyy9Q8tZcOVYHhWfHG71HAW1bWCHYx9voiHGayyJ50pYKdgEiQQ8AVX?=
 =?us-ascii?Q?ZEH7FSv8kGvTe50YPbTFIdACYs51GJ7fE6Z23WmhIMxSyQL2jJYay4Qzbau3?=
 =?us-ascii?Q?xNf1Tabyz9S9VTTQkBMFF4zvqFNBi/0ee08+wHdmL4KvdLxufkPbnDJi0Nhy?=
 =?us-ascii?Q?Z3szfa1ixCm/narJIqwZ2Zn0taBT3s4gG6nPOEgFM75zRQfwqQq0nKPl3Un8?=
 =?us-ascii?Q?2rHeEfg7JGrvC+bVzy6tGVAyQIUh6O6ho4unNOJ/Mulnea7dSI7B+Zse2psK?=
 =?us-ascii?Q?A1VlnoIRDc89foCvNs678ofDVyvT5FPZZkUpPkoSfzSI5YIpLRJPpcvrsqoc?=
 =?us-ascii?Q?JLo2HdJBrA/Z9q8F047SinZQIuHYW1fJzNkfhyJIs1jePBHb59vSV/RnRghe?=
 =?us-ascii?Q?GXy7M7zPiV2y6zX7+lOOwRMOSxpaa/6qORedvtBZ9lrbWK7KgAoHZaAlZZHt?=
 =?us-ascii?Q?d6hhL0CgzIk78DjK4JOfZIYpkQdD6Imu87qCQDVMH/W6ujV3R1BEJfMvICdi?=
 =?us-ascii?Q?uLx5Ze0aPvaZQ921a+Yt/RnB8AzZb1MYFArD+Xu/NslYAN8ZWRjon7hBQNGE?=
 =?us-ascii?Q?iQtE0waQ0qa5NcQSwKYtU2jH5R/5yG4QJzPqZhaHWXk8gnX9qGUkbG2GG5TV?=
 =?us-ascii?Q?mTKeMTHUy5jy//beSUDhnofW3Hay5Qg1kzr+IXh6twJqfraBiD6axRQaQ7ZV?=
 =?us-ascii?Q?bIYeXlwlbmea4fcr/+KBDNOrGncx1O/CdvmrCZmrQFX4SXjiwU5h2OMD/UW3?=
 =?us-ascii?Q?T5BLSlzZXgnt9vhYZg19FsImG3jP6UyrexBchxO4ASWaIWdJfDeQSl+1Fugf?=
 =?us-ascii?Q?CLfGExY6DaPzRZ74gJsLL3051jEBtEB1J/Yw8JIlhsYNEkYer3CJ5CU3mXAt?=
 =?us-ascii?Q?HrexJoCsZ18CdwSz6MrHobAbLE4OKJiSE1awBYSjwNXRFirq8tzE0gZgYKk2?=
 =?us-ascii?Q?urPz9UP8AV+nVKgq6ucQ+Hc8vZ0cH6eePqvkHst+JCtiDuytaOh7XfVWi+Vf?=
 =?us-ascii?Q?kwue5IAV/j9WYrPk6jtZUl7POGMYYPAVYmhgGLuSZ1FemV5+885TDF5S/iwg?=
 =?us-ascii?Q?9A=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6240f76b-e7a4-4004-5bbd-08da66ad6466
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB4973.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jul 2022 22:00:12.9588
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Me/zVX2WDrRCdj8zMuw17NDmsft3zh9cXL63w3zHVtqavuPFLbWpbiHLzhYSRA84fj93nzT+n3uiLnt/Yo27iQ==
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

This adds a binding for the SerDes module found on QorIQ processors. The
phy reference has two cells, one for the first lane and one for the
last. This should allow for good support of multi-lane protocols when
(if) they are added. There is no protocol option, because the driver is
designed to be able to completely reconfigure lanes at runtime.
Generally, the phy consumer can select the appropriate protocol using
set_mode. For the most part there is only one protocol controller
(consumer) per lane/protocol combination. The exception to this is the
B4860 processor, which has some lanes which can be connected to
multiple MACs. For that processor, I anticipate the easiest way to
resolve this will be to add an additional cell with a "protocol
controller instance" property.

Each serdes has a unique set of supported protocols (and lanes). The
support matrix is configured in the device tree. The format of each
PCCR (protocol configuration register) is modeled. Although the general
format is typically the same across different SoCs, the specific
supported protocols (and the values necessary to select them) are
particular to individual SerDes. A nested structure is used to reduce
duplication of data.

There are two PLLs, each of which can be used as the master clock for
each lane. Each PLL has its own reference. For the moment they are
required, because it simplifies the driver implementation. Absent
reference clocks can be modeled by a fixed-clock with a rate of 0.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v3:
- Manually expand yaml references
- Add mode configuration to device tree

Changes in v2:
- Rename to fsl,lynx-10g.yaml
- Refer to the device in the documentation, rather than the binding
- Move compatible first
- Document phy cells in the description
- Allow a value of 1 for phy-cells. This allows for compatibility with
  the similar (but according to Ioana Ciornei different enough) lynx-28g
  binding.
- Remove minItems
- Use list for clock-names
- Fix example binding having too many cells in regs
- Add #clock-cells. This will allow using assigned-clocks* to configure
  the PLLs.
- Document the structure of the compatible strings

 .../devicetree/bindings/phy/fsl,lynx-10g.yaml | 311 ++++++++++++++++++
 1 file changed, 311 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml

diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
new file mode 100644
index 000000000000..a2c37225bb67
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
@@ -0,0 +1,311 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/fsl,lynx-10g.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Lynx 10G SerDes
+
+maintainers:
+  - Sean Anderson <sean.anderson@seco.com>
+
+description: |
+  These Lynx "SerDes" devices are found in NXP's QorIQ line of processors. The
+  SerDes provides up to eight lanes. Each lane may be configured individually,
+  or may be combined with adjacent lanes for a multi-lane protocol. The SerDes
+  supports a variety of protocols, including up to 10G Ethernet, PCIe, SATA, and
+  others. The specific protocols supported for each lane depend on the
+  particular SoC.
+
+definitions:
+  fsl,cfg:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 1
+    description: |
+      The configuration value to program into the field.
+
+  fsl,first-lane:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 0
+    maximum: 7
+    description: |
+      The first lane in the group configured by fsl,cfg. This lane will have
+      the FIRST_LANE bit set in GCR0. The reset direction will also be set
+      based on whether this property is less than or greater than
+      fsl,last-lane.
+
+  fsl,last-lane:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    minimum: 0
+    maximum: 7
+    description: |
+      The last lane configured by fsl,cfg. If this property is absent,
+      then it will default to the value of fsl,first-lane.
+
+properties:
+  compatible:
+    items:
+      - enum:
+          - fsl,ls1046a-serdes
+          - fsl,ls1088a-serdes
+      - const: fsl,lynx-10g
+
+  "#clock-cells":
+    const: 1
+    description: |
+      The cell contains the index of the PLL, starting from 0. Note that when
+      assigning a rate to a PLL, the PLLs' rates are divided by 1000 to avoid
+      overflow. A rate of 5000000 corresponds to 5GHz.
+
+  "#phy-cells":
+    minimum: 1
+    maximum: 2
+    description: |
+      The cells contain the following arguments:
+      - The first lane in the group. Lanes are numbered based on the register
+        offsets, not the I/O ports. This corresponds to the letter-based ("Lane
+        A") naming scheme, and not the number-based ("Lane 0") naming scheme. On
+        most SoCs, "Lane A" is "Lane 0", but not always.
+      - Last lane. For single-lane protocols, this should be the same as the
+        first lane.
+      If no lanes in a SerDes can be grouped, then #phy-cells may be 1, and the
+      first cell will specify the only lane in the group.
+
+  clocks:
+    maxItems: 2
+    description: |
+      Clock for each PLL reference clock input.
+
+  clock-names:
+    minItems: 2
+    maxItems: 2
+    items:
+      enum:
+        - ref0
+        - ref1
+
+  reg:
+    maxItems: 1
+
+patternProperties:
+  '^pccr-':
+    type: object
+
+    description: |
+      One of the protocol configuration registers (PCCRs). These contains
+      several fields, each of which mux a particular protocol onto a particular
+      lane.
+
+    properties:
+      fsl,pccr:
+        $ref: /schemas/types.yaml#/definitions/uint32
+        description: |
+          The index of the PCCR. This is the same as the register name suffix.
+          For example, a node for PCCRB would use a value of '0xb' for an
+          offset of 0x22C (0x200 + 4 * 0xb).
+
+    patternProperties:
+      '^(q?sgmii|xfi|pcie|sata)-':
+        type: object
+
+        description: |
+          A configuration field within a PCCR. Each field configures one
+          protocol controller. The value of the field determines the lanes the
+          controller is connected to, if any.
+
+        properties:
+          fsl,index:
+            $ref: /schemas/types.yaml#/definitions/uint32
+            description: |
+              The index of the field. This corresponds to the suffix in the
+              documentation. For example, PEXa would be 0, PEXb 1, etc.
+              Generally, higher fields occupy lower bits.
+
+              If there are any subnodes present, they will be preferred over
+              fsl,cfg et. al.
+
+          fsl,cfg:
+            $ref: "#/definitions/fsl,cfg"
+
+          fsl,first-lane:
+            $ref: "#/definitions/fsl,first-lane"
+
+          fsl,last-lane:
+            $ref: "#/definitions/fsl,last-lane"
+
+          fsl,proto:
+            $ref: /schemas/types.yaml#/definitions/string
+            enum:
+              - sgmii
+              - sgmii25
+              - qsgmii
+              - xfi
+              - pcie
+              - sata
+            description: |
+              Indicates the basic group protocols supported by this field.
+              Individual protocols are selected by configuring the protocol
+              controller.
+
+              - sgmii: 1000BASE-X, SGMII, and 1000BASE-KX (depending on the
+                       SoC)
+              - sgmii25: 2500BASE-X, 1000BASE-X, SGMII, and 1000BASE-KX
+                         (depending on the SoC)
+              - qsgmii: QSGMII
+              - xfi: 10GBASE-R and 10GBASE-KR (depending on the SoC)
+              - pcie: PCIe
+              - sata: SATA
+
+        patternProperties:
+          '^cfg-':
+            type: object
+
+            description: |
+              A single field may have multiple values which, when programmed,
+              connect the protocol controller to different lanes. If this is the
+              case, multiple sub-nodes may be provided, each describing a
+              single muxing.
+
+            properties:
+              fsl,cfg:
+                $ref: "#/definitions/fsl,cfg"
+
+              fsl,first-lane:
+                $ref: "#/definitions/fsl,first-lane"
+
+              fsl,last-lane:
+                $ref: "#/definitions/fsl,last-lane"
+
+            required:
+              - fsl,cfg
+              - fsl,first-lane
+
+            dependencies:
+              fsl,last-lane:
+                - fsl,first-lane
+
+            additionalProperties: false
+
+        required:
+          - fsl,index
+          - fsl,proto
+
+        dependencies:
+          fsl,last-lane:
+            - fsl,first-lane
+          fsl,cfg:
+            - fsl,first-lane
+          fsl,first-lane:
+            - fsl,cfg
+
+        # I would like to require either a config subnode or the config
+        # properties (and not both), but from what I can tell that can't be
+        # expressed in json schema. In particular, it is not possible to
+        # require a pattern property.
+
+        additionalProperties: false
+
+    required:
+      - fsl,pccr
+
+    additionalProperties: false
+
+required:
+  - "#clock-cells"
+  - "#phy-cells"
+  - compatible
+  - clocks
+  - clock-names
+  - reg
+
+additionalProperties: false
+
+examples:
+  - |
+    serdes1: phy@1ea0000 {
+      #clock-cells = <1>;
+      #phy-cells = <2>;
+      compatible = "fsl,ls1088a-serdes", "fsl,lynx-10g";
+      reg = <0x1ea0000 0x2000>;
+      clocks = <&clk_100mhz>, <&clk_156_mhz>;
+      clock-names = "ref0", "ref1";
+      assigned-clocks = <&serdes1 0>;
+      assigned-clock-rates = <5000000>;
+
+      pccr-8 {
+        fsl,pccr = <0x8>;
+
+        sgmii-0 {
+          fsl,index = <0>;
+          fsl,cfg = <0x1>;
+          fsl,first-lane = <3>;
+          fsl,proto = "sgmii";
+        };
+
+        sgmii-1 {
+          fsl,index = <1>;
+          fsl,cfg = <0x1>;
+          fsl,first-lane = <2>;
+          fsl,proto = "sgmii";
+        };
+
+        sgmii-2 {
+          fsl,index = <2>;
+          fsl,cfg = <0x1>;
+          fsl,first-lane = <1>;
+          fsl,proto = "sgmii25";
+        };
+
+        sgmii-3 {
+          fsl,index = <3>;
+          fsl,cfg = <0x1>;
+          fsl,first-lane = <0>;
+          fsl,proto = "sgmii25";
+        };
+      };
+
+      pccr-9 {
+        fsl,pccr = <0x9>;
+
+        qsgmii-0 {
+          fsl,index = <0>;
+          fsl,cfg = <0x1>;
+          fsl,first-lane = <3>;
+          fsl,proto = "qsgmii";
+        };
+
+        qsgmii-1 {
+          fsl,index = <1>;
+          fsl,proto = "qsgmii";
+
+          cfg-1 {
+            fsl,cfg = <0x1>;
+            fsl,first-lane = <2>;
+          };
+
+          cfg-2 {
+            fsl,cfg = <0x2>;
+            fsl,first-lane = <0>;
+          };
+        };
+      };
+
+      pccr-b {
+        fsl,pccr = <0xb>;
+
+        xfi-0 {
+          fsl,index = <0>;
+          fsl,cfg = <0x1>;
+          fsl,first-lane = <1>;
+          fsl,proto = "xfi";
+        };
+
+        xfi-1 {
+          fsl,index = <1>;
+          fsl,cfg = <0x1>;
+          fsl,first-lane = <0>;
+          fsl,proto = "xfi";
+        };
+      };
+    };
+...
-- 
2.35.1.1320.gc452695387.dirty


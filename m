Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2C055F0F0
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229897AbiF1WO1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:14:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiF1WOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:25 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2071.outbound.protection.outlook.com [40.107.22.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F32932EDC;
        Tue, 28 Jun 2022 15:14:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IV7fXN8Kc/mtxGCmkO1XbbSsayJ9Pah1bZtF/Ju+05hOZrrIW6rxlOGaE9AgJOHdiLJ7tgNo2y34GLk/7CfUeOQbfJDLP8P4lyJ+NM5acfg+7jBNGnFErNDfz26MRZqbtbWkvWj9agbafy+CgHBug4kBmDcdzSdZojpKd3JJZDbHjIWsCNR1xLpUMDYboUGqERPRdIjBZrOLcxuZcYhlsKTuJ/LWZ8e9xawuyiy6ZIygiFY0oInhtG+vMEfwdUFfmnfzYTzHPQG3N+Kdk1JQc0eNLS5kHEfd7ZKPCqMIfHZJqPG2ZY/3kKY683evGCAAzk2Q2DJrqbbJXQfbz9GemQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n2TOaa23voSbHbIev1E+i5kpuNcV3elS/tbw71Sc9dA=;
 b=nvulD4D2Z+5ziHPjih16w/OPqgZVa6FjG2BMZbOqk7RpXiNrQQ8n82eY5CpjlKa7S6pdFrfTgHbis8N0MuO2sTuM6x2LsmPMAlPgOlHB6c6kRx0TC574yo3mMyxUH3zJYkpJEDE0OduUfBZv51QAy0r4zaI0djdzOnpwEG3QW8u0cyydeEO31OQ8S18lSyflVu1tqgdNPqkSyyAw0Pi21Mh7Q2DX9GRpxD+LQkgzm7Dxa6dvRamRtglwhErBa+SALHobLMmoYuyQRYaLFgkOyO7kpQsqQv5qKan1mfEqN7j2mvRRxhRO2kWqMWdjkoZhhISevWzbf0D+R+UTF3S6Kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n2TOaa23voSbHbIev1E+i5kpuNcV3elS/tbw71Sc9dA=;
 b=qpqwumtIK3919D35Uf21+RnQ1r5mAWmO0jB4XqrPOGJ2xZ6snL4UhL768XkvcIB2JyTaVErh4umGY0ORqq9f4Li2U1ytphlu912ZkAr0AYSokiUkgA/mX2pX33nlmcKVIIAtITtuDhn5ko9aEZ08Fgqjvq5VBvc6D2iXA9MTRM2ter+/zJS45KEjLI1yOtA5BWUXd40Onmiio6Ug6QDCtj/4fJpZe1YcEaU4zu0Bdd7Yh0y5VFlQf1rPPWkz+1d85jnoC8CVW2wCBIaK6RD003dHqOL2p03hL0zHSsk/JK8evO8yLiBzZXbz7FyZVOd8WqMKJb7IqXYELEnPjGifRA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB6PR03MB3013.eurprd03.prod.outlook.com (2603:10a6:6:3c::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:20 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:20 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>, netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org,
        Sean Anderson <sean.anderson@seco.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org
Subject: [PATCH net-next v2 01/35] dt-bindings: phy: Add QorIQ SerDes binding
Date:   Tue, 28 Jun 2022 18:13:30 -0400
Message-Id: <20220628221404.1444200-2-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3d1e0234-b661-4db6-81cc-08da59538cbf
X-MS-TrafficTypeDiagnostic: DB6PR03MB3013:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4BQ5Ej6Bt6b/45hwnHw9cEqPXV3dP3UQVTKdzH2NLEWivAIohIlpvj0TcAVJy0csI2/5d/MCR8zcFvploqP9RWcXl5940BtNt9R0qAJuxub3ng/YgTxTAlbcK3rBS4w6yNrHTbTRBjlb1noG1EZ71tbAWDyV5VkHg6ZtBjPU2DgU5QvPONvtsZ6njO/ZdFe5iSx2Pi0tOLRA5yUoMGjrbNFkO+zSQQ4b4XWqQleQMgMKS6LQpty6YMWrlpF3Ko6HyQbtnw7qf8G0CZzQ/P8rvb6PqyxTEkn1TqZmGNIBlB9yVl+PY7JWXBCHczQqwHb1BX3J0ur+G+hTOYQtn72DcmRwSeLxK7/z9QPAKZnyRYY2MOzSo5hpLIdsbdfJFmof89wgZpaV4huQNOeJktDAqH+527Lwq19Rrz/Ouos5pv3odg2Hq+54hNO0+b2+Z0C1vaaiUhLziIIIVxUEquwJmMBd2YSaZedjWiQaWvh10Be2agQT54cMiTrKI+8COv3ZEgai3v88bgvjo+u6Q7qRlE2/XgMn8ZubXup3/l0w91YzjSszkDUyh7/500s96Y2XE3B25LqQrvwq/3IEZTIh/kocVsznybItb1aQTYjHtHVuKupURWk1PduxBOeRCpB+NzJzhTjACEwE+tGnHUGpXJIZKAugdUgg2qmkNM6WrnNgBdeIXrdUF5bxguARcurDfyg1jErdJWniZsmphZ1Z7QKIGdrsHYxWDl1hF8aH1SKW/wjxIhYfebpQDa3UcDNA2UVZl4wb5jhnsTcboX+WxUbIvknSjY+7YlBXJntavtSxDmvYXz66mv8ayiOXP2O10KX0V2TD/IU8JR7nIepS75O74AAMbNywSAahylz+g4M=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(39850400004)(376002)(366004)(136003)(346002)(2616005)(41300700001)(26005)(1076003)(966005)(66946007)(6666004)(8676002)(6506007)(6512007)(52116002)(186003)(38350700002)(83380400001)(44832011)(6486002)(8936002)(7416002)(66476007)(38100700002)(2906002)(66556008)(86362001)(5660300002)(54906003)(36756003)(110136005)(4326008)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pw7IRmaMfp8kPOgleu0iwyX+kaemhCxR4+nVnFljBw4BmN09/F39oCkrQZmu?=
 =?us-ascii?Q?o6DWN9yWhkQuivh54+C1lCf7YZr/mAsdhxjWN6OPh4q1L00ek/lpqtKnNYsa?=
 =?us-ascii?Q?rLKE/SnxbLz/rVQ1Lt3eN3e8QcvMtRa1TzKGmm4O78sWqMpBBid3GEdVxE2h?=
 =?us-ascii?Q?Uih2ArU3UEEQZra7znYzaliXO63lK9gzm0Fg4PNTUFW1jC3ZQWFUSX2i7zU2?=
 =?us-ascii?Q?6Zm9pKNb3EBO2Zqa9iNJ2Lt/3PSBZEgUSxoah5gbUTUXWzP7vq7lDd4Gft9s?=
 =?us-ascii?Q?gN50rOZ/LxgQJybM86XlcvqlPLS3efqN3FKtfx1eYkfgnR3qg4ljG/T2mO8f?=
 =?us-ascii?Q?SEqPCNzf/jz3YdBLaRcO/W6CGRVz50dY2/4HXQYZb147z68w5lLjWCMdGHwB?=
 =?us-ascii?Q?FWFl2QYKltRpapnLvDRgMcgCRzE9O23fn+bdV+ayd+tuKcvzRjGIFEnl5E5J?=
 =?us-ascii?Q?PH+4OXYBZjHR9CP8Xnp+QaZooKXNTS45ha82XjRvID6QMB13xIiThqF5S6Hl?=
 =?us-ascii?Q?P0MxBTtz/AtfrWTuOTe4PYDj8PGBlzz5ilap6hsJHO+meYP3eoyUUopE690Z?=
 =?us-ascii?Q?xtKrHegwwacFsgjztR4iu6dl/RZDYfZUIaY63hNUkjiqUUyRNggsUMmsZW8O?=
 =?us-ascii?Q?LWzaAPzLoe4u0fdu/3InzxyBWpiExTa3yEFUtUMIEuChRMAu5U5RCDa0atyO?=
 =?us-ascii?Q?OD2e5vl+ePGuczsNqKcrI5Pfb/1/Ien9uNXm5Dr13X2TZsSUK0pfxIjZB0l6?=
 =?us-ascii?Q?mMG8pFXYCTUYSez1Z9K9tCMmQvRAKoL6bOzqHQY5XU+18crytoC6UyTOzHf+?=
 =?us-ascii?Q?0RwNWMg0ZDwUCAastGNrhvGDUm8gM8Q/OtTtCyRcSoG5VYCWqR7FeWfhiIYg?=
 =?us-ascii?Q?s4r99dP7dpe+Nluu+UxMrFxzp8jXXj2ghn+VnGSeYQ988Xw0dd5D2i7nOlNS?=
 =?us-ascii?Q?DVIfA5YbCTmAVipYNQevtqrgDYTvBEVSMq2udZMLmxPN/gpiR6QFxf6TJcxw?=
 =?us-ascii?Q?DxTSnl5YgB/Z0vteaqNAHtx79/vEzYoH8piNwoWamV037ExxN3UVB1vIGqGA?=
 =?us-ascii?Q?/6oqCpH5peR2fV96UynfEdVEN7TCPg3K6CuNoJsqO2w6DlIJjF1RZQAGaQuX?=
 =?us-ascii?Q?HSKt9z95qrZvYGBg5C4ltd2c7BJUw1hliNb2fN+bISSOlSCces7+zphdBZn2?=
 =?us-ascii?Q?2ct7Ozdc+lPX6NQzlbRI/1Z0cJ4uUlK/4NmTNME8hdwP1htbT7ZVk9h3WTwU?=
 =?us-ascii?Q?xsX+MDjG5yJfIR5l2osnT3ZvQmgZJiukKBuoeXxPe3GfCGIjhZmGKD7cAgwZ?=
 =?us-ascii?Q?uNudDSiotC2Zn/mBo5SzW/gkjS6vlVhwHvupM3/8UVBtLGAMyYWqpZjMupez?=
 =?us-ascii?Q?Vwv3t3xUD5t1HVb1MjkIZdoFOxfBKsUjMkcVhk+9EM/Lerlw9/2Td/+gDO+o?=
 =?us-ascii?Q?NgCCNa0lCmUVbqNPYz1RBXTEovsopLdJXxZH67QVEx+AIpTRdJKs8YORUv2k?=
 =?us-ascii?Q?dw3QKNMzAdWUgKXncXYe8sr6kS58UsUrk8NSf869Z7JzPKCl/7C37FFOT04P?=
 =?us-ascii?Q?0GU9FBEjWMga7rIr0CzM//T1fisc9YJTwrg23eO8s6PPZODHm0QqYfZUQtOj?=
 =?us-ascii?Q?RQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d1e0234-b661-4db6-81cc-08da59538cbf
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:20.5646
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LtUQLoHLKOQIyUUFuoQnsRtp8rMbTVgG6jxHFLNARlr1y9chZUIgGxzT6OaiJ2V743ap8m23MjXGSW7xEjzIrg==
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
support matrix is stored in the driver and is selected based on the
compatible string. It is anticipated that a new compatible string will
need to be added for each serdes on each SoC that drivers support is
added for. There is no "generic" compatible string for this reason.

There are two PLLs, each of which can be used as the master clock for
each lane. Each PLL has its own reference. For the moment they are
required, because it simplifies the driver implementation. Absent
reference clocks can be modeled by a fixed-clock with a rate of 0.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Add #clock-cells. This will allow using assigned-clocks* to configure
  the PLLs.
- Allow a value of 1 for phy-cells. This allows for compatibility with
  the similar (but according to Ioana Ciornei different enough) lynx-28g
  binding.
- Document phy cells in the description
- Document the structure of the compatible strings
- Fix example binding having too many cells in regs
- Move compatible first
- Refer to the device in the documentation, rather than the binding
- Remove minItems
- Rename to fsl,lynx-10g.yaml
- Use list for clock-names

 .../devicetree/bindings/phy/fsl,lynx-10g.yaml | 93 +++++++++++++++++++
 1 file changed, 93 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml

diff --git a/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
new file mode 100644
index 000000000000..b5a6f631df9f
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/fsl,lynx-10g.yaml
@@ -0,0 +1,93 @@
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
+properties:
+  compatible:
+    description: |
+      Each compatible is of the form "fsl,<soc-name>-serdes-<instance>".
+      Although many registers are compatible between different SoCs, the
+      supported protocols and lane assignments tend to be unique to each SerDes.
+      Additionally, the method of activating protocols may also be unique.
+      Because of this, each SerDes instance will need its own compatible string.
+      In cases where two SoCs share the same SerDes implementation (such as the
+      LS1046A and LS1026A), both SoCs should share the same compatible strings.
+    enum:
+      - fsl,ls1046a-serdes-1
+      - fsl,ls1046a-serdes-2
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
+    items:
+      - enum: &clocks
+          - ref0
+          - ref1
+      - enum: *clocks
+
+  reg:
+    maxItems: 1
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
+      compatible = "fsl,ls1046a-serdes-1";
+      reg = <0x1ea0000 0x2000>;
+      clocks = <&clk_100mhz>, <&clk_156mhz>;
+      clock-names = "ref0", "ref1";
+      assigned-clocks = <&serdes1 0>;
+      assigned-clock-rates = <5000000>;
+    };
+
+...
-- 
2.35.1.1320.gc452695387.dirty


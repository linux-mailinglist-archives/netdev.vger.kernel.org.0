Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC055613358
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 11:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbiJaKLl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 06:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230397AbiJaKLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 06:11:35 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2087.outbound.protection.outlook.com [40.107.104.87])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3EF2DF7A;
        Mon, 31 Oct 2022 03:11:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qididk6yo9AiDPTB3pWZVYm9oRqsHj3o1mWOPx8XpWUC+4XHPEBDC10sVaX2j2GYO9vBrxe9hiIm6ZRlxCXu9DvW2ZmulGiexp7vcDeggb0jEzfhJkuRytoDeHSYc40LVOZ01ObpStlqbWXhSHfDCHE8P6FRWQ9uDtuR1JxS7d8wFHeaXXL4+tSIeFseKqWN5eebWXWcXd91hozOUnUcuu8PtfAaQlcx+3Ro4qjnQHUJMADdUevl4byYwel8sSFkmaFKqLcm94/eMxqR/JfanDHk0GvN95ELgRrr79/Row+iTuqSLBkwoqU81fqfClpyxsbNVI9rsvmh6ThiBQnXfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Zn2ro5pLzd/AgGErCLQjExxP3xd0AXsaLXFhRxpZhWE=;
 b=oPP8h/0p1zLxPzqKkAOu4hs13B1oXiJht44Ofvv7EcZSypNmP2yw6bNjkwxoIYubU4dpOG88HMyLGkjFQQLS8X9JgBMpUwQkGrjvaK5aaIqAiUtaVm3d7Fi/ug1znq8eoWI156R+w0RmQdeQ0A1CN2VCRJvYoI/limhhytraJqlPxCOhO0TOrTi5k19wbqTzPKA7Yr5CFRwmlfN5EiZj6Mj3TzSUtexN8T0FAOp6SOgWVq46FVF8M9GK9t981AH87ymg/EZ6TUgmGzoerr7qmVtSl1kD6SdHOxPbC3KYxDHHZ1gqTjfnEvCOktJ15LJOiPN+60tKI3LSe1igKYHPcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zn2ro5pLzd/AgGErCLQjExxP3xd0AXsaLXFhRxpZhWE=;
 b=mcC9BPoEdKLfpDn/qipYEwwDK3p0EULJw2/CjDF60JiXPysMKaMHGv8tp90I7RZa5tTenMn/XBbEns4Ngfd1NqEBbHyI33ATRtoF5llgKwPdl8IKDnYcUnGIQUmXqvBpXO9rvdeHftSeQd/LMUWKn2LbAd0C1Zu+7DyTkqZqYz7aRSg5OwTz8i2o3xa85ocKrP1P2UgrS4n8AvP6E1H4Q+Sjk5ZMISoJueyRYMTCpuTTQEv39RIa7p0xcE7he76vgaNn6O79sBqH082t52rC0w1clExSzRvMSW8BeqCRJP2/cchqUreuMhk7W1E/LVasJcvT0+vS02eJE/p6bWMyFQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com (2603:10a6:803:4::13)
 by VE1PR04MB7261.eurprd04.prod.outlook.com (2603:10a6:800:1a3::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.15; Mon, 31 Oct
 2022 10:11:28 +0000
Received: from VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963]) by VI1PR0402MB3439.eurprd04.prod.outlook.com
 ([fe80::41c4:5b70:6fec:a963%7]) with mapi id 15.20.5746.028; Mon, 31 Oct 2022
 10:11:28 +0000
From:   Chester Lin <clin@suse.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jan Petrous <jan.petrous@nxp.com>
Cc:     Chester Lin <clin@suse.com>, netdev@vger.kernel.org, s32@nxp.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Matthias Brugger <mbrugger@suse.com>
Subject: [PATCH 2/5] dt-bindings: net: add schema for NXP S32CC dwmac glue driver
Date:   Mon, 31 Oct 2022 18:10:49 +0800
Message-Id: <20221031101052.14956-3-clin@suse.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221031101052.14956-1-clin@suse.com>
References: <20221031101052.14956-1-clin@suse.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0214.jpnprd01.prod.outlook.com
 (2603:1096:404:29::34) To VI1PR0402MB3439.eurprd04.prod.outlook.com
 (2603:10a6:803:4::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3439:EE_|VE1PR04MB7261:EE_
X-MS-Office365-Filtering-Correlation-Id: 0094a077-81af-4d5f-b6a6-08dabb28467a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7QrfLYy7NyiSe6ygjSnLT4oUUWVbrED0gs/GiLE4vMdD6NCg79N9GU4cyIfUNb448NYQZXzbSOuL7ZmILNH6h68clGCj7zne2GDZCwTbJDjPdRhFcee/fm/fdAtWCmYP8Mos4MeJCY6REsSNf80gV7CW1QZURJpzfbsvjL4JWivUK5w3aZ7+8MZMVvXaYMlWILZqXK0EtpBiARLWVh9g7ZS1yJQ4hPNNXRKV5cd7lia+I0d6HEAVnFIwuzO4HDYIX4F8YPrNFx+HA/GbSNMNRjy3Dyq2vIJZk6l3h1ffWe0TE+8QM7RxrMMHap5QYdDJEw0iWeepxY47jVXKx6JuE4y7QFGwBw8B56sqGb6ERoTxi+LLkgg2A2cvR8/5JWKGMZlnDRat4Lku3F7Hs4DW/qkH92Q+GAMp2MJZh17Ig0ZzPEKePk9lbcT9DYTxjhveRapa4ggod7zo9ekynVZu8ktEpf3+l7v+8CpE/8TE6GDhK7KE1RDdx14d009e5+jeYxTmDoP3DJPxvzlo4eDhC4Pj3x43EmWGVGoDJJGEa098PJrYArNe0p/pAiqZ6y9QQBjZ/CrRlSwj54yqp76CzTcTSI/mInXVGvTflM52wMJDZ5XMwsKiFpGllILToBgO4O4zpV/1EeLO5L0/DbAhgyVzCjlro/3YQPxuSzBqQ4tkBD58gGYpiOSk/ednoASBPOcDPcwwiqVQnb0GfP8XorZHtSHrLT7qFhurlzjrzEM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR0402MB3439.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39850400004)(376002)(366004)(346002)(451199015)(6486002)(107886003)(478600001)(110136005)(54906003)(316002)(6666004)(86362001)(8676002)(6506007)(4326008)(66476007)(66946007)(66556008)(2906002)(26005)(38100700002)(41300700001)(6512007)(2616005)(186003)(1076003)(83380400001)(8936002)(36756003)(7416002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WtrLQMznBhE4C7xMc2WcjeyAwn2m+XGYwQ1lDLusqV1TTpEOxv5Rbyau6Fam?=
 =?us-ascii?Q?aD452Gna2tb0+xJnhl0VD2x+/1dQBnjTLoqTtzPlRNynbJJIuq36gMW1iz+C?=
 =?us-ascii?Q?dsdTdda9L5Q2KEalfBzVNYVwkkwob9r2kn+rDwuFT4MoGgTJDQazis0IaHp2?=
 =?us-ascii?Q?TcFyr4CpwLUjYLDQ1Jsri9qvRr8+wcnqNiaGp/H+sGWqIwQMiXVr/jR0ZH3T?=
 =?us-ascii?Q?Eyukq0cIMKhgoGY72hNj+DjomPktKMBQTgucBMtcjsx27DpRof79fjiUT/+/?=
 =?us-ascii?Q?rYB77tJx+WXO+Ic4X4N2fyV1QEnh1yNXJ7fK61dFLMTG7jxZmQCwfLbhFrO9?=
 =?us-ascii?Q?RirvPsaJh1I+zwNK4cIHoGfS0iTG5wVwRWYbBJPbKqZYvwLT3WROPIPUuTkq?=
 =?us-ascii?Q?FBwcuW4RUfPh4QL2Q/zifGITzaG6KmKUPEZYNYfQaok7/9fjFd6CUuEF8PYC?=
 =?us-ascii?Q?I3WPE7tnSKJKPy+7rcMxnDbH6wAfcmU3nhFW12aOR6AYOW+edvBC7OHeQA1K?=
 =?us-ascii?Q?4y1dp3h3DjKlNk5uXPcvHfjngRgLNntmMcyiKLJwco+bXPf0lqfc0iJ1BvcD?=
 =?us-ascii?Q?u7/GxtaxHbhYNTl480hjj/6++1yJXcNpgYkmjbZUKBUMYjsnaeEpoR5FQuwf?=
 =?us-ascii?Q?KmIuD34up5x9YIiyrDTIAHTlpbrTfEmFjKh15FDA3ccbw9Ur3tGc0t6iwoJt?=
 =?us-ascii?Q?1VtjWXw7v2pnNMN2jNSyuhDQJcbBrttisD1NHAxREFi1UtRgV7PDMVjfM+KP?=
 =?us-ascii?Q?J9Bptsg4TdNy68fMVC4N2J8jS/df8EoH3pB/bp8bivV15DWgJW32EYZc68zc?=
 =?us-ascii?Q?4Jetp0Y37/ayf5WNmL9f4Snp+iNAxTQTETPWUPWYyD/tY1cx7MsY3kgBTvUc?=
 =?us-ascii?Q?pOST77NLs1+Sv3ZhIVH6O95XrPP3O7wBzhcKLKGjit7SCGH1mXqotu3vokXN?=
 =?us-ascii?Q?8RwLqZWTSz4UoA4q10bAxr+YEUcDeCuPDdE58MW6SCosJbon8bf9fFG1FBbD?=
 =?us-ascii?Q?vBAZ1vkmDyne+y0Dwn8yZn0Q37A7urRJ/TocKZYjQh3FizXOtC6mfJe0jn1a?=
 =?us-ascii?Q?xVf1h8lIKk0p788ZP/xrzNc7C5hzgOBBpzWhOzjsk31S3hhNWHalsdjr+c+5?=
 =?us-ascii?Q?IXB8wRc/XGWm0fGAiCp0K15IQva5pYGeoQ18sT/vBrHXKKgs41yignoYH56r?=
 =?us-ascii?Q?tqDKxnhsMP9H6MaIWNGB8xAFwBYqWmc8NTKn9Mw/aiIkndC6xnPme+FNw2Td?=
 =?us-ascii?Q?bvjaaIqjUZnl6Xy7swjFSGdNPRi+gGW9ALXfK49XAudveaQ03ZXo0ItS1J4i?=
 =?us-ascii?Q?asKQiO6HlpMlwBWSwbeat4dc0oMCMsNrLTjebSVFrf7zQtPhvH4Dy8MIRxg2?=
 =?us-ascii?Q?Y+4h2RNUANiC/BnDZNDNVrZEMTdSomMtPgArYD/ypYOzMGj1Xk8XbmoOSPsL?=
 =?us-ascii?Q?uTNINB39m+pTdHSYM9rhudCYrs/fddaB0NvZ1rQQZoAftEQwKgkrUqZ8Q3ZO?=
 =?us-ascii?Q?2MHJPvN2GYCmI4ojmq9tC7DKZGgho6qahpZocsXOFOz0QIPuXBQ6kmip+u/S?=
 =?us-ascii?Q?b9FiWcym3y9ICbkNvEc=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0094a077-81af-4d5f-b6a6-08dabb28467a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR0402MB3439.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Oct 2022 10:11:28.3442
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6O3TGAn7HknYPrF7820NIs5vXYk/qw406ccS+oxgznPYImmIY7rDgFGNU12LkDx9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7261
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the DT schema for the DWMAC Ethernet controller on NXP S32 Common
Chassis.

Signed-off-by: Jan Petrous <jan.petrous@nxp.com>
Signed-off-by: Chester Lin <clin@suse.com>
---
 .../bindings/net/nxp,s32cc-dwmac.yaml         | 145 ++++++++++++++++++
 1 file changed, 145 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml

diff --git a/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
new file mode 100644
index 000000000000..f6b8486f9d42
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nxp,s32cc-dwmac.yaml
@@ -0,0 +1,145 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+# Copyright 2021-2022 NXP
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/nxp,s32cc-dwmac.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: NXP S32CC DWMAC Ethernet controller
+
+maintainers:
+  - Jan Petrous <jan.petrous@nxp.com>
+  - Chester Lin <clin@suse.com>
+
+select:
+  properties:
+    compatible:
+      contains:
+        enum:
+          - nxp,s32cc-dwmac
+  required:
+    - compatible
+
+allOf:
+  - $ref: "snps,dwmac.yaml#"
+
+properties:
+  compatible:
+    contains:
+      enum:
+        - nxp,s32cc-dwmac
+
+  reg:
+    items:
+      - description: Main GMAC registers
+      - description: S32 MAC control registers
+
+  dma-coherent:
+    description:
+      Declares GMAC device as DMA coherent
+
+  clocks:
+    items:
+      - description: Main GMAC clock
+      - description: Peripheral registers clock
+      - description: Transmit SGMII clock
+      - description: Transmit RGMII clock
+      - description: Transmit RMII clock
+      - description: Transmit MII clock
+      - description: Receive SGMII clock
+      - description: Receive RGMII clock
+      - description: Receive RMII clock
+      - description: Receive MII clock
+      - description:
+          PTP reference clock. This clock is used for programming the
+          Timestamp Addend Register. If not passed then the system
+          clock will be used.
+
+  clock-names:
+    items:
+      - const: stmmaceth
+      - const: pclk
+      - const: tx_sgmii
+      - const: tx_rgmii
+      - const: tx_rmii
+      - const: tx_mii
+      - const: rx_sgmii
+      - const: rx_rgmii
+      - const: rx_rmii
+      - const: rx_mii
+      - const: ptp_ref
+
+  tx-fifo-depth:
+    const: 20480
+
+  rx-fifo-depth:
+    const: 20480
+
+required:
+  - compatible
+  - reg
+  - tx-fifo-depth
+  - rx-fifo-depth
+  - clocks
+  - clock-names
+
+additionalProperties: true
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+
+    #define S32GEN1_SCMI_CLK_GMAC0_AXI
+    #define S32GEN1_SCMI_CLK_GMAC0_TX_SGMII
+    #define S32GEN1_SCMI_CLK_GMAC0_TX_RGMII
+    #define S32GEN1_SCMI_CLK_GMAC0_TX_RMII
+    #define S32GEN1_SCMI_CLK_GMAC0_TX_MII
+    #define S32GEN1_SCMI_CLK_GMAC0_RX_SGMII
+    #define S32GEN1_SCMI_CLK_GMAC0_RX_RGMII
+    #define S32GEN1_SCMI_CLK_GMAC0_RX_RMII
+    #define S32GEN1_SCMI_CLK_GMAC0_RX_MII
+    #define S32GEN1_SCMI_CLK_GMAC0_TS
+
+    soc {
+      #address-cells = <1>;
+      #size-cells = <1>;
+
+      gmac0: ethernet@4033c000 {
+        compatible = "nxp,s32cc-dwmac";
+        reg = <0x4033c000 0x2000>, /* gmac IP */
+              <0x4007C004 0x4>;    /* S32 CTRL_STS reg */
+        interrupt-parent = <&gic>;
+        interrupts = <GIC_SPI 57 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "macirq";
+        phy-mode = "rgmii-id";
+        tx-fifo-depth = <20480>;
+        rx-fifo-depth = <20480>;
+        dma-coherent;
+        clocks = <&clks S32GEN1_SCMI_CLK_GMAC0_AXI>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_AXI>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_SGMII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_RGMII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_RMII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_TX_MII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_SGMII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_RGMII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_RMII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_RX_MII>,
+                 <&clks S32GEN1_SCMI_CLK_GMAC0_TS>;
+        clock-names = "stmmaceth", "pclk",
+                      "tx_sgmii", "tx_rgmii", "tx_rmii", "tx_mii",
+                      "rx_sgmii", "rx_rgmii", "rx_rmii", "rx_mii",
+                      "ptp_ref";
+
+        gmac0_mdio: mdio {
+          #address-cells = <1>;
+          #size-cells = <0>;
+          compatible = "snps,dwmac-mdio";
+
+          ethernet-phy@4 {
+            reg = <0x04>;
+          };
+        };
+      };
+    };
-- 
2.37.3


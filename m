Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9123B6B7A9E
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 15:41:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbjCMOlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 10:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231410AbjCMOlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 10:41:20 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2041.outbound.protection.outlook.com [40.107.7.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A22D6A438;
        Mon, 13 Mar 2023 07:41:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MIE/Haq0w+JnhKtWKHsWQLFI0UXVgZFO80iZ+Zdz3u/uLfP7fWgB61x6pCNxF1yI2J3oX8WSBbktEWdft18UhzE0xBK4rk3p3bXMi9zK4+nmGn+0BsV5VgTHJT3ckyRgafaQF/8bycr/L/1owAPbf7Gh330hsoUEKmyfCFPgLqcj2yi55QipA6w2WT2HpcLlAglG7qm6nJpkTVUiFmpgkPnt1uFlg/GH7vClbSrxHBgMph7ph5cXrMw0Cd1QrT7u+9MeiqbzxHDRe+ECbapbxJ5oB0GGM/sKy7scliCPD1stUTR0PPEIU5sdpWk64XM/PQFw4I/+B9S9wzo8m7QAqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lXvJmWsKiEDF7bGa7efvlLRdaiR9wPwcnWO5lzbjF8=;
 b=GIJ+tElGurPYpWhq+977cVbGugHeyO4k3fNrOkPkrqG+P8m/dN8+gMHggbSqTekokvghF439HesQIa/1wfubyEx8vt2SDG6wjn/HLRmU/dSkYWk5BQ+EQ0DUItAppWOt76/ugMO48S7j0W/jxGAI/Ep7s/OHJ3GiJtioYqlqhV79mKBM3nqi3DWc6vCmW6fuesQyNnp2hyQgOyWfg+xlV3n6oyasQANWQwa62ZTOKrRwIZsYmPN04svSTH6+b6Sr8YPUaJQabbeLA8cVGYeM0tCFvVH5njgLpa0HRn1wnO3BmZfAdqyrEugJsqLeHh+N+jAhsxry+N+j8g55x8ofpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lXvJmWsKiEDF7bGa7efvlLRdaiR9wPwcnWO5lzbjF8=;
 b=JBTULiuLRDY0NNhWSf063cW8+M0VzSKwBV3RNuk2jz9NwZLdEaP+NfPZ02MoVAETuPz+1ffG3LGiba24HrLCYW/vHv8pVTMrheoEve+8hN0tm+gJ3nhpVahjXkOHcFJS4EGLF9vHGVJziUuOKdE7O68MR/Kqu7Hj9NXMDiohSjg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com (2603:10a6:20b:43a::10)
 by PA4PR04MB7744.eurprd04.prod.outlook.com (2603:10a6:102:c9::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.24; Mon, 13 Mar
 2023 14:41:15 +0000
Received: from AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762]) by AM9PR04MB8603.eurprd04.prod.outlook.com
 ([fe80::45d2:ce51:a1c4:8762%5]) with mapi id 15.20.6178.024; Mon, 13 Mar 2023
 14:41:15 +0000
From:   Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        gregkh@linuxfoundation.org, jirislaby@kernel.org,
        alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, leon@kernel.org,
        simon.horman@corigine.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-serial@vger.kernel.org, amitkumar.karwar@nxp.com,
        rohit.fule@nxp.com, sherry.sun@nxp.com, neeraj.sanjaykale@nxp.com
Subject: [PATCH v10 2/3] dt-bindings: net: bluetooth: Add NXP bluetooth support
Date:   Mon, 13 Mar 2023 20:10:27 +0530
Message-Id: <20230313144028.3156825-3-neeraj.sanjaykale@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
References: <20230313144028.3156825-1-neeraj.sanjaykale@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SG2PR02CA0115.apcprd02.prod.outlook.com
 (2603:1096:4:92::31) To AM9PR04MB8603.eurprd04.prod.outlook.com
 (2603:10a6:20b:43a::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR04MB8603:EE_|PA4PR04MB7744:EE_
X-MS-Office365-Filtering-Correlation-Id: 47493fb2-4813-4626-c0d2-08db23d0ffa7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xp9vGAiraiqxBFVVTZRDpCwOgdJzYTz1lbjgHM96W64/xLMbrtVZHlXSXxPp95BX71c2jNFHaZaVYltYxKYsehNGhyusz2vs2KF3eagb7XQg3WjblaH8BoumH5fAOSjxca9G6mk1kRs7gfPQCAs3jE6c9EpI7sbbwohEepFas//5gAVrQ/XhguMHA6clcrGsSCqfNd0H0NNmbotDrwu8xid01FZa23Z7f6gvsRdAKi4/OJW6+uR9kKP7Be10shNrerZ+dZAanTcmVQvQaSnSXNE2x25HkyGZTOheSwGe3S+B7KWJS2JHsGc5Kd80ENVRmsOmlM7bW3WACLrjutR2d2wYf93RM+I7dLBnHgvrHslCN/XqjyhFBCe9nn/od+ZuiAdoUoY1pYvzufu2E1z0tVNcw2Fw6FLcSLUZo4F+hhk7vuoya19w7E82qQO1hucZKzouWPDoU0ms64YhH9NayJ53DBYmOaVRLzAOiY2yDjBAhKBGqg4GmjNO1/cbBIp7TX8Xe73+AgM35/+zqBQxYccCWbHsM00ZvikzXXieWCkhMOO0q2Wls67h5BE3gPoomSgu5fjGYHE2h34kdQ56sR+HG7+qaftchiL5Em6JxH33rI5XC4VH3gRqB5C7PU0pHWKnnV89TuAQUleD9hNKKf2RMZAgyaX/3MFSaYwMcnHWd03xBotQZ3LUBIAit25sWqEED7fH+itlJFGaJBAXL4xdWooCxIaYYTMH2siDNpD5+GCWDiBTE9jGu+ZWx/EF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB8603.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(396003)(346002)(136003)(376002)(366004)(451199018)(36756003)(86362001)(186003)(41300700001)(26005)(6506007)(1076003)(6512007)(7416002)(5660300002)(4326008)(2616005)(8936002)(316002)(52116002)(478600001)(966005)(8676002)(66476007)(6666004)(66556008)(66946007)(6486002)(38350700002)(38100700002)(921005)(2906002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?38sHNEuTucZIN0ZYUuAm2ZIbQJagQ6vhodCyfM/C2eArGE3OdplITDZoaLOH?=
 =?us-ascii?Q?0/UU2PYuLl00kwlxO8ze0K1ubsgtlKtreh08fXBrJwmSx2swCjEWd6iQMJJp?=
 =?us-ascii?Q?uVmFJ2PlxPPH5ui2Oet6BTVYCt86S6kSqnwi1m1xyQPRgV7CQLuBeF5/eT+C?=
 =?us-ascii?Q?H30W7WHWObkgHec+PDWpwPETJiBDqEpL7ENsdmZ1kYKuwnDpZjAI2/uh3fJ5?=
 =?us-ascii?Q?LPbJ6vQ02IXyQvXMteKaSHdnzbLhSZHa8/e5FCzdlUZOBDP6iQDvyLQ6CaRM?=
 =?us-ascii?Q?GFgYVeaNY5dTa0kwlCbAWJfYwiz1u9/UUoXw9udL/vGS4uT7KOvL3eCxRMBa?=
 =?us-ascii?Q?EUD1PM5XT6K6qSMbav3X9Bbs0ShmN2B7Mp1HoaLdq+SyaAejwD0DpXw7xeW+?=
 =?us-ascii?Q?1r+kkLgFn+E8TOb0aGlvUI423egKSpLGDmSAgQNxzVNkDRRF6mZDgJSilY+9?=
 =?us-ascii?Q?UT9j5D6cF16a7mIOE3DoMXUa9i1Lb9R219wUmWhnUMyD63Bitx4Gkhq++UZ/?=
 =?us-ascii?Q?fYTN0+apY40Dy/DoBBXjWU6zqjUAvQiuexcLqNMCvDgz9LgXhZunZ76FEylD?=
 =?us-ascii?Q?ZwNJuRWQlkTu6Sz07t4Hl09aLFiVF1uAwm7RSks1aSYX8U4h7MaClUYSqyzi?=
 =?us-ascii?Q?Cd6dxwwLJEjEdcuno7x/n6aieKXE8rJDrJTTdUPEfy5HiUXLhyYsJAkG1PR0?=
 =?us-ascii?Q?4KPgnuiRkyozKx5A/nhxehjbYEnsJgOWptgu7ACJIDpf21UBAr4VmlQYeS4G?=
 =?us-ascii?Q?tNfq9ndmAiMLh0aLhY8YBqNc4ChFzcP3ne3pDSp+eLaxk0uAmeMJkK/CzNxj?=
 =?us-ascii?Q?mmuUKqKWrisLSGebKkvLDMQeQzZWcPsG2GomhA58ojfv/kiKq4wtX7jSz5VY?=
 =?us-ascii?Q?1OUrcKrtl3Lqr7g3ma4qFwafsOm9z5O+Fj61NXk079aS+pym5nWTN23M+JgR?=
 =?us-ascii?Q?GR5r0/ro4gd7UNJ1Y4nthz7Iho586qpTvKOU+YNrQlCIsvkzKTno58pLFZnt?=
 =?us-ascii?Q?LTZ+p8cgEuTtAs95tkjLxytHWb6rSscv0FKrHlSuueVzu+gyTiEzOvuOC/9m?=
 =?us-ascii?Q?ewLHRqZkTqWaCctUbnMRibB31hlm0hT3MytRmB/LFghgKfYTNvevzyycAYhr?=
 =?us-ascii?Q?X45BUYIOD6XWLYissdfgwHMpgIF1XvDIkvyQuFsr70FJH7sMWGiIfaUFHDpg?=
 =?us-ascii?Q?CKwxAS6fy3dkBIOI72Oki2zUO1N58uCr283HP6iYPu4tqF2htMr2ZoECf8WJ?=
 =?us-ascii?Q?/jn9MM8KFKxCwml3xGic3J1/4BFwnP5cMPkCdMtlyB2SceXT9WQwMt3mFipk?=
 =?us-ascii?Q?VT2aeQa15Vh85/LJwSQpTUggxI77NFJfqr3x/YOAewA+wR3HeEPDzRjAeYUa?=
 =?us-ascii?Q?5x5noCr9mfIaNoLudS644daw7Brq2/9TnBb5UkdnsjDTxJ20nx5H3nRAOPjl?=
 =?us-ascii?Q?bHsO7++uFG3CYB4IPf4bAT4OpNJHjmQJDSq0ZY0f0HATr4sTHM9QcEcYK2D4?=
 =?us-ascii?Q?Tt+TMPxJhnMurYOsYxbEzOtet64VUIpb3seXZX1JL2YcsxuKhQbbNSU1gp41?=
 =?us-ascii?Q?gf5UcDNIyQLXMcVANsjk5j0d6c5DEGEo5EtncP81ULzjI1lDL4HzuRoi69t7?=
 =?us-ascii?Q?YQ=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47493fb2-4813-4626-c0d2-08db23d0ffa7
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB8603.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Mar 2023 14:41:15.4129
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: x+lPea/cc49vRKRkvRymSy2PriMR6+/BqRDb6unxVYcBIc/kbs80fuvdNJ89hUrVlL9bsv0hyCbQfzYQaJaMud58hiHsAG16fWx2+WUE5K8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7744
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add binding document for NXP bluetooth chipsets attached over UART.

Signed-off-by: Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
---
v2: Resolved dt_binding_check errors. (Rob Herring)
v2: Modified description, added specific compatibility devices, corrected
indentations. (Krzysztof Kozlowski)
v3: Modified description, renamed file (Krzysztof Kozlowski)
v4: Resolved dt_binding_check errors, corrected indentation.
(Rob Herring, Krzysztof Kozlowski)
v5: Corrected serial device name in example. (Krzysztof Kozlowski)
---
 .../net/bluetooth/nxp,88w8987-bt.yaml         | 46 +++++++++++++++++++
 MAINTAINERS                                   |  6 +++
 2 files changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
new file mode 100644
index 000000000000..b913ca59b489
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/bluetooth/nxp,88w8987-bt.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP Bluetooth chips
+
+description:
+  This binding describes UART-attached NXP bluetooth chips.
+  These chips are dual-radio chips supporting WiFi and Bluetooth.
+  The bluetooth works on standard H4 protocol over 4-wire UART.
+  The RTS and CTS lines are used during FW download.
+  To enable power save mode, the host asserts break signal
+  over UART-TX line to put the chip into power save state.
+  De-asserting break wakes-up the BT chip.
+
+maintainers:
+  - Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
+
+properties:
+  compatible:
+    enum:
+      - nxp,88w8987-bt
+      - nxp,88w8997-bt
+
+  fw-init-baudrate:
+    description:
+      Chip baudrate after FW is downloaded and initialized.
+      This property depends on the module vendor's
+      configuration. If this property is not specified,
+      115200 is set as default.
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    serial {
+        bluetooth {
+            compatible = "nxp,88w8987-bt";
+            fw-init-baudrate = <3000000>;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 32dd41574930..030ec6fe89df 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -22835,6 +22835,12 @@ L:	linux-mm@kvack.org
 S:	Maintained
 F:	mm/zswap.c
 
+NXP BLUETOOTH WIRELESS DRIVERS
+M:	Amitkumar Karwar <amitkumar.karwar@nxp.com>
+M:	Neeraj Kale <neeraj.sanjaykale@nxp.com>
+S:	Maintained
+F:	Documentation/devicetree/bindings/net/bluetooth/nxp,88w8987-bt.yaml
+
 THE REST
 M:	Linus Torvalds <torvalds@linux-foundation.org>
 L:	linux-kernel@vger.kernel.org
-- 
2.34.1


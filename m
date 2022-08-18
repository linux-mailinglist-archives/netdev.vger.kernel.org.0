Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 305CB598882
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344473AbiHRQRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:17:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344457AbiHRQRN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:17:13 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70070.outbound.protection.outlook.com [40.107.7.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CC6BD08F;
        Thu, 18 Aug 2022 09:17:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fWhtKdCumVF0jZHfQZj3ALCltmT//StqPe4nwynqKE00VKubD6OVZBuRe9W2nw68AgCSdLY881hubHFwKRfqHwbDpHqa38XIfDYyVLTnCy8x845YA5Okq+TIj/u/B6Y++6LXX3O4TQicJw01kXGCqisAeLTkM9F2sT0ck1WCVQVcRRJ4v/1WX6Y5v35Nkigv6gCbG2KBwGqhzczRK8ucnZo2eokD/8/n6f4eKRw5kr/7rAj0+KMtA7czLA9o1sgSQ6ckHTWUAPTCXZcgo45/rmn/CaJZDrQhA3v9jX/5W2i6KLD8P9OVTjsUAjizoOKdrVTBuVyP8YphQkdOf/JI1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SZuUDFAVgiNf2kcEotKjgbq3pqDMPDtsajTe/iQusEI=;
 b=ckuenD+RZTjewgDCSF2nmwH+vhXS5cHrVWOI+NZQNNRI/vTXmYvpKAxX+mNhYvoBArZdJVSHshzLoEftmx/B1zksMd2yJPAxNFrxo5Eb8EoLXLsesJCbwdPL5nP0tp/TYAw6VpnjgvnF76PjjBs+mdn0zqwiPH0rKNAN8bcyteykWmUC0SQseSfaDfdqyvsv3POT+fw02CX3xoWcT9naJ/d7XUP17TmdtqWDYBZxP3V27T4KzjG1Q6pMLO97ffSR4KMNUjMilGbTeX2a4a/c/P9e1RXuAR253sS8aWs0M1oAwCuAs8iiHTlxyiv63csy5BM45zcPD4Vb+Tw9WWfuVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SZuUDFAVgiNf2kcEotKjgbq3pqDMPDtsajTe/iQusEI=;
 b=NIn/S+LbQlkbo5pPJfIyp+eljX7fYQ4dPz+dOZGrFGAyre2SpMKgkYHqYsExGvJFa0LxY71rhDW2Tq/CXOqMtlMuZb9rB4s6fIwnpTWAHgjZL4gYaj4/FiLy7SkviL8Px/MxoQmx3IQoDU7jGCAWFkDqs9e6uf68dZETxtTaPBRrEpCr8n038LJpMQAF7GRe1urnFaYcxEokqoL1F5+D3lc72t7r0p1u3SWApXFKxZzwkKGHHAiceo+XX5zMwz9PUTPJJXxhypUKrLkEKfKdDNSyfk5KMYkToyLalb0lTZeXpRrvtoMzTpqCbwIMa2XPb/5vj/KyI94cWEFcDG3SDg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DB3PR0302MB3211.eurprd03.prod.outlook.com (2603:10a6:8:11::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.16; Thu, 18 Aug
 2022 16:17:08 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.019; Thu, 18 Aug 2022
 16:17:08 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [RESEND PATCH net-next v4 01/25] dt-bindings: net: Convert FMan MAC bindings to yaml
Date:   Thu, 18 Aug 2022 12:16:25 -0400
Message-Id: <20220818161649.2058728-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220818161649.2058728-1-sean.anderson@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MN2PR20CA0009.namprd20.prod.outlook.com
 (2603:10b6:208:e8::22) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0efe07a0-3059-422d-062f-08da8135195b
X-MS-TrafficTypeDiagnostic: DB3PR0302MB3211:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B1WsPvcDaQYKDkTEiXC6KWVs7kWmhTsNtl4QeVaSf0puw39jk3p5+m2FmaWqUgJt4IMCQSyr9KKVmSqAcbxvi+pqN/SyHg+mfQKyvEs7xfzH/SqRidAOKRRswYi/WZTpGfUnz2aUlrvCcIPXKIgC1CgN7R0MVNJgiB4YXOI8jbuJzCvDfbU9FKEW1X2Zy9Fb7GYUntzlF+sUAB/KrnIf0Nx1jdR0ubUzF2JbSDPscqYMM3JRiYPOxXfN3SErgdq4yUAEfDqKfGQeuOEgn/LaN0ixJH7Tp2E2n5Be/J2D5FLAXzhigVNYHsCIvtjE362Y5vflAWDs95wREx1MSj/Y9sSQjQ7kLbxroEkwHF4veZKIwgjLtWefaPDIKiEdCf5Bff/t1aG2/MhaBfFhVwLnEvFYy2l6stQFu+gMN+kqJ8sIz+gt/R/W3cjdCKRTorMacfhnF8YJg6W65LIk8PBcPjFGYnN/+N2eX3Q7ZR3BkXd6I07+LFFMkTZCdCKlM68V4Vk8JO7no5zyd2aeEypD3TwZ1aNJ/Kp++LqXVChmghkUF/vyITH33DZnP+HiDAaWKboq1Sw/iGJRPep6s6unwGORp8tVphiE71tmPylOC5yeUoMP7kEZ8rO0XSl4uEr6PnyM5PI06NxMCm0reHV0F3iy30T40dmchOWEstmuDfUXX9A8buNd2QiSeKa+f/YvULfFmoXaS6PjIqyqCq3MgZ0nIoC9qiYf2QpjyPya4DQvQn0FRoG3PNixx/DjqebzsJTGLZvzoOURc+cakhB6W41lAG12dH+M6XUek12bgJ4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(396003)(346002)(39840400004)(136003)(366004)(376002)(2616005)(38350700002)(8936002)(38100700002)(4326008)(6512007)(26005)(6506007)(52116002)(6666004)(2906002)(8676002)(36756003)(66556008)(1076003)(66946007)(66476007)(54906003)(110136005)(44832011)(478600001)(966005)(86362001)(41300700001)(6486002)(316002)(83380400001)(186003)(5660300002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Iq31MqBf4ml7M6ZFIxwrHzGypUVUbvto9urB7ebKojGRG/NOJ2pVlp3T4uBC?=
 =?us-ascii?Q?MJfwtbmXh2pdg7fHKGIZg66FpzuvDj7p918eYPH50HChEHAVA0lqa80c5tKM?=
 =?us-ascii?Q?AdEds9hLReFmYXfnREy2aI3RrGXerW4IR3GB7e/uy+R0OCb3cF6hTmhl8Yrm?=
 =?us-ascii?Q?WKXuR1YvImfuSg7JQYRQbWOpUsFkSKYS0vYXQqG7MmUg1pbz67RknTQGFIBk?=
 =?us-ascii?Q?ZkswceryGFVwjiPhDcZdueyESEGH2Plf3RGQlZ0MtDGOhOsHrrkK4s58Go1g?=
 =?us-ascii?Q?sacMcnQyGMRRm3Yl3uD1KRO/6Ji9kS5W9jdFXYRxlO9T7RPhQMk818xfBxlC?=
 =?us-ascii?Q?tkklcH+cGaImRDpzQBETeksSfayLt50SRImjYQa5juNgJ9wS+D8ZogO4ySZu?=
 =?us-ascii?Q?18ozKUNhcdoocmI2yKhFCRLZ8n+LzNvIWjZwDZxZlrR3bLZojXQFuMU3Wa5n?=
 =?us-ascii?Q?bE+NLWB+dJqMpt+ul73w3BnDav6ln6zSnk8k1Z8IHU0bozGgthWsRIwDMEfo?=
 =?us-ascii?Q?TOu3wZFXfZnjSZIk74+C7+WbENNvNOABUzx9EtCn00TWm4Jbzr/WPj00p3lm?=
 =?us-ascii?Q?idOC+DFThzyo4c1GLVsHQ+piybFVskmxqoZ6gJbWv4T/lqacGUQaYx0Jc++9?=
 =?us-ascii?Q?/lOS5X2aABfe00su3VHC94GuXmCDPYlojNtPZb2kNEiJQhyAz7HLl5KNDmJk?=
 =?us-ascii?Q?1DzSAp3Dd9DUZt7xhksMrU2kxutyC9KwP700X+uedQCgdFkLD6m1mszDY7D1?=
 =?us-ascii?Q?oZluLdQsCp+SGHKNswTq5Y9UEcv1j89xwvLjIlCHXK/1FcpaBHYLVNxjhiQe?=
 =?us-ascii?Q?Li5gTl8cqsN8RW5ju5GjgoK7wGG7DGR0tCotXeA8AzlB7gY99zKyXgO8PpWv?=
 =?us-ascii?Q?yNcd0qNjIGBPwUQq7itm7nKjm72FQl1VCvtBeqpBf8s7gnj21L9PA2NyWdo2?=
 =?us-ascii?Q?StqLXiQRa6diKDkjsP4AcNFm2QnqGPwkyeOA62Eu1mCCgO/vkV+0q62dwyxb?=
 =?us-ascii?Q?1sOVNcB1qD9cbgq7ELxqbjo36JfaA6yQGR+Hex1j4e7HTpfLm410aRFoIO4y?=
 =?us-ascii?Q?62XXlsW7Bh5lva7Efyls9oXMhBowXPt1t5oSycnoADOe11akv/6JnfLrF5VY?=
 =?us-ascii?Q?wJFwsP/eqh1rjTYZ70fbd53KtJJ9K/KTBPS9G01FHzeddVSzQv1Tz0MYZCB2?=
 =?us-ascii?Q?lVchbBoR7uKfVoITdrnryR2VJFwquR6hkzgd6vXFcgE+VURXpX4/Gq5AH986?=
 =?us-ascii?Q?qU7YtuyoYWG1w7g0INlN8bubtUqTly2PUEKTZR8tmhWDp+va8Lr0lHrgmWNZ?=
 =?us-ascii?Q?b6L+FxWzQIdMVdP55wYQ8LQ2SWiZBCMbkW6lsDWf1kX2uIOBiGRNu7VsirVP?=
 =?us-ascii?Q?m9u859qM2kT150YZAQY1nO/XE3RAXMdUzCliYh3LdVW5I4Rc1gXDY+Ijpgxd?=
 =?us-ascii?Q?8c5a+K6AUsXEHTfWkxTwksj3/lqh6FawfAdR69KSiuOunEjblAUd0w7WiV78?=
 =?us-ascii?Q?QpZ6aRrW1sT6S8qAnaleE3jWlo0OWEinD/593qsMFNbg4d154fV9oSlrUVIN?=
 =?us-ascii?Q?mMIfjpmXowybtKt0YNnKkwA17gzRv5RTIZjGQ5Am6vqmO+J+4HNzbxHszfL5?=
 =?us-ascii?Q?Ng=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0efe07a0-3059-422d-062f-08da8135195b
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Aug 2022 16:17:08.7023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TfAw7VK7e4HAz59eDHlzQwIG9SBM2CyvKONcnxMOO9X30SB4gVWS9xzEXmp6mXwulsbNFBuEMnFE7nVEJ5UF0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0302MB3211
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the MAC portion of the FMan MAC bindings to yaml.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Rob Herring <robh@kernel.org>
Acked-by: Camelia Groza <camelia.groza@nxp.com>
---

(no changes since v3)

Changes in v3:
- Incorperate some minor changes into the first FMan binding commit

Changes in v2:
- New

 .../bindings/net/fsl,fman-dtsec.yaml          | 145 ++++++++++++++++++
 .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
 2 files changed, 146 insertions(+), 127 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml

diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
new file mode 100644
index 000000000000..3a35ac1c260d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
@@ -0,0 +1,145 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/fsl,fman-dtsec.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NXP FMan MAC
+
+maintainers:
+  - Madalin Bucur <madalin.bucur@nxp.com>
+
+description: |
+  Each FMan has several MACs, each implementing an Ethernet interface. Earlier
+  versions of FMan used the Datapath Three Speed Ethernet Controller (dTSEC) for
+  10/100/1000 MBit/s speeds, and the 10-Gigabit Ethernet Media Access Controller
+  (10GEC) for 10 Gbit/s speeds. Later versions of FMan use the Multirate
+  Ethernet Media Access Controller (mEMAC) to handle all speeds.
+
+properties:
+  compatible:
+    enum:
+      - fsl,fman-dtsec
+      - fsl,fman-xgec
+      - fsl,fman-memac
+
+  cell-index:
+    maximum: 64
+    description: |
+      FManV2:
+      register[bit]           MAC             cell-index
+      ============================================================
+      FM_EPI[16]              XGEC            8
+      FM_EPI[16+n]            dTSECn          n-1
+      FM_NPI[11+n]            dTSECn          n-1
+              n = 1,..,5
+
+      FManV3:
+      register[bit]           MAC             cell-index
+      ============================================================
+      FM_EPI[16+n]            mEMACn          n-1
+      FM_EPI[25]              mEMAC10         9
+
+      FM_NPI[11+n]            mEMACn          n-1
+      FM_NPI[10]              mEMAC10         9
+      FM_NPI[11]              mEMAC9          8
+              n = 1,..8
+
+      FM_EPI and FM_NPI are located in the FMan memory map.
+
+      2. SoC registers:
+
+      - P2041, P3041, P4080 P5020, P5040:
+      register[bit]           FMan            MAC             cell
+                              Unit                            index
+      ============================================================
+      DCFG_DEVDISR2[7]        1               XGEC            8
+      DCFG_DEVDISR2[7+n]      1               dTSECn          n-1
+      DCFG_DEVDISR2[15]       2               XGEC            8
+      DCFG_DEVDISR2[15+n]     2               dTSECn          n-1
+              n = 1,..5
+
+      - T1040, T2080, T4240, B4860:
+      register[bit]                   FMan    MAC             cell
+                                      Unit                    index
+      ============================================================
+      DCFG_CCSR_DEVDISR2[n-1]         1       mEMACn          n-1
+      DCFG_CCSR_DEVDISR2[11+n]        2       mEMACn          n-1
+              n = 1,..6,9,10
+
+      EVDISR, DCFG_DEVDISR2 and DCFG_CCSR_DEVDISR2 are located in
+      the specific SoC "Device Configuration/Pin Control" Memory
+      Map.
+
+  reg:
+    maxItems: 1
+
+  fsl,fman-ports:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    maxItems: 2
+    description: |
+      An array of two references: the first is the FMan RX port and the second
+      is the TX port used by this MAC.
+
+  ptp-timer:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: A reference to the IEEE1588 timer
+
+  pcsphy-handle:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: A reference to the PCS (typically found on the SerDes)
+
+  tbi-handle:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description: A reference to the (TBI-based) PCS
+
+required:
+  - compatible
+  - cell-index
+  - reg
+  - fsl,fman-ports
+  - ptp-timer
+
+allOf:
+  - $ref: ethernet-controller.yaml#
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: fsl,fman-dtsec
+    then:
+      required:
+        - tbi-handle
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: fsl,fman-memac
+    then:
+      required:
+        - pcsphy-handle
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    ethernet@e0000 {
+            compatible = "fsl,fman-dtsec";
+            cell-index = <0>;
+            reg = <0xe0000 0x1000>;
+            fsl,fman-ports = <&fman1_rx8 &fman1_tx28>;
+            ptp-timer = <&ptp_timer>;
+            tbi-handle = <&tbi0>;
+    };
+  - |
+    ethernet@e8000 {
+            cell-index = <4>;
+            compatible = "fsl,fman-memac";
+            reg = <0xe8000 0x1000>;
+            fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
+            ptp-timer = <&ptp_timer0>;
+            pcsphy-handle = <&pcsphy4>;
+            phy-handle = <&sgmii_phy1>;
+            phy-connection-type = "sgmii";
+    };
+...
diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index 801efc7d6818..b9055335db3b 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -232,133 +232,7 @@ port@81000 {
 =============================================================================
 FMan dTSEC/XGEC/mEMAC Node
 
-DESCRIPTION
-
-mEMAC/dTSEC/XGEC are the Ethernet network interfaces
-
-PROPERTIES
-
-- compatible
-		Usage: required
-		Value type: <stringlist>
-		Definition: A standard property.
-		Must include one of the following:
-		- "fsl,fman-dtsec" for dTSEC MAC
-		- "fsl,fman-xgec" for XGEC MAC
-		- "fsl,fman-memac" for mEMAC MAC
-
-- cell-index
-		Usage: required
-		Value type: <u32>
-		Definition: Specifies the MAC id.
-
-		The cell-index value may be used by the FMan or the SoC, to
-		identify the MAC unit in the FMan (or SoC) memory map.
-		In the tables below there's a description of the cell-index
-		use, there are two tables, one describes the use of cell-index
-		by the FMan, the second describes the use by the SoC:
-
-		1. FMan Registers
-
-		FManV2:
-		register[bit]		MAC		cell-index
-		============================================================
-		FM_EPI[16]		XGEC		8
-		FM_EPI[16+n]		dTSECn		n-1
-		FM_NPI[11+n]		dTSECn		n-1
-			n = 1,..,5
-
-		FManV3:
-		register[bit]		MAC		cell-index
-		============================================================
-		FM_EPI[16+n]		mEMACn		n-1
-		FM_EPI[25]		mEMAC10		9
-
-		FM_NPI[11+n]		mEMACn		n-1
-		FM_NPI[10]		mEMAC10		9
-		FM_NPI[11]		mEMAC9		8
-			n = 1,..8
-
-		FM_EPI and FM_NPI are located in the FMan memory map.
-
-		2. SoC registers:
-
-		- P2041, P3041, P4080 P5020, P5040:
-		register[bit]		FMan		MAC		cell
-					Unit				index
-		============================================================
-		DCFG_DEVDISR2[7]	1		XGEC		8
-		DCFG_DEVDISR2[7+n]	1		dTSECn		n-1
-		DCFG_DEVDISR2[15]	2		XGEC		8
-		DCFG_DEVDISR2[15+n]	2		dTSECn		n-1
-			n = 1,..5
-
-		- T1040, T2080, T4240, B4860:
-		register[bit]			FMan	MAC		cell
-						Unit			index
-		============================================================
-		DCFG_CCSR_DEVDISR2[n-1]		1	mEMACn		n-1
-		DCFG_CCSR_DEVDISR2[11+n]	2	mEMACn		n-1
-			n = 1,..6,9,10
-
-		EVDISR, DCFG_DEVDISR2 and DCFG_CCSR_DEVDISR2 are located in
-		the specific SoC "Device Configuration/Pin Control" Memory
-		Map.
-
-- reg
-		Usage: required
-		Value type: <prop-encoded-array>
-		Definition: A standard property.
-
-- fsl,fman-ports
-		Usage: required
-		Value type: <prop-encoded-array>
-		Definition: An array of two phandles - the first references is
-		the FMan RX port and the second is the TX port used by this
-		MAC.
-
-- ptp-timer
-		Usage required
-		Value type: <phandle>
-		Definition: A phandle for 1EEE1588 timer.
-
-- pcsphy-handle
-		Usage required for "fsl,fman-memac" MACs
-		Value type: <phandle>
-		Definition: A phandle for pcsphy.
-
-- tbi-handle
-		Usage required for "fsl,fman-dtsec" MACs
-		Value type: <phandle>
-		Definition: A phandle for tbiphy.
-
-EXAMPLE
-
-fman1_tx28: port@a8000 {
-	cell-index = <0x28>;
-	compatible = "fsl,fman-v2-port-tx";
-	reg = <0xa8000 0x1000>;
-};
-
-fman1_rx8: port@88000 {
-	cell-index = <0x8>;
-	compatible = "fsl,fman-v2-port-rx";
-	reg = <0x88000 0x1000>;
-};
-
-ptp-timer: ptp_timer@fe000 {
-	compatible = "fsl,fman-ptp-timer";
-	reg = <0xfe000 0x1000>;
-};
-
-ethernet@e0000 {
-	compatible = "fsl,fman-dtsec";
-	cell-index = <0>;
-	reg = <0xe0000 0x1000>;
-	fsl,fman-ports = <&fman1_rx8 &fman1_tx28>;
-	ptp-timer = <&ptp-timer>;
-	tbi-handle = <&tbi0>;
-};
+Refer to Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
 
 ============================================================================
 FMan IEEE 1588 Node
-- 
2.35.1.1320.gc452695387.dirty


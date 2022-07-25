Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88F71580131
	for <lists+netdev@lfdr.de>; Mon, 25 Jul 2022 17:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiGYPLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Jul 2022 11:11:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235126AbiGYPLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jul 2022 11:11:03 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10066.outbound.protection.outlook.com [40.107.1.66])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E1E99FEB;
        Mon, 25 Jul 2022 08:11:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DWwBnV/ZVGWVQkBqPSQwKA/K3YXUtwvT7DRybPzw+BonjOmA9xN55RW6DN7E8T3Ggki0n7+JwvhiPtWqhQzlB8pJDLKv/CgzObJWMYlv5FmLYHVMg7gnnA1gMuAiMISwLjKzevFUcKo04iJ5Zn/DXE5pJfcXmRrOcLAHMNQHv/4ksJMgqIhTjNVi9QTJQ1QM5A8otM7I3SGxUxYkso/r4EUiGZl8kru5LqLiFWeQ3EkFzfHPFAsSRAtq7Hq5nljjPQBFWEzCSuUU7nl7wluxidwvsBxnXgDokS1RCHSc7tjhKaLThUV03zdWP+KLkFN3CelsZCzmeMZy6KCFoRF5nA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ztt4rIUBOPc1xIJSVIQjxGh+cKK9SDDVoQDd3WCk7MY=;
 b=YphxfoTzuPDeEQKQ9hj0RKceIlp5HUFOeKJbBkJDInFGYJApgNe5v/iBffft7SBOB4SLyjGlwjNZi7mfPlfqdbUedS+/tX/8vE0XLpxKaGSSGMWDAxqVxYdvT2V+htor2uEaKPb8RrOTZRdWeYuI/lHzR3m0i7TM6uM1EKS0BxFWHXuGKaCXyoO2M9/i4vGndSXDMqBTtbhSjSVVqOcaCqguENZoPyoFSOxraxE1B4sUWPForN/hKt2sjW8mCys4X/VldrCZMvgE3z9VABj0gHLWVXHeNbO+LaxOJhAYThjgGll/xeg90bDpS+kmDn7qisgJ5Fnjg7bSM9Ct27cO2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ztt4rIUBOPc1xIJSVIQjxGh+cKK9SDDVoQDd3WCk7MY=;
 b=vVPvFKjbHSchE0KPauMIn76qv+yFmnLIUc6nabYkQc3N12sv592fotz0bqbZ9Kud5XSa1/+2KFEN9HgI9bwuMv1quCOUVWmbXrH+8nCr45QsYbW7bpb6r9NysMNN1LWNn2WbHPh65nTIL1ypBCW8OSKlkggAMmMAPCuQ7B85JyESgQ/QpwAW2UjU16fMmq2KOKKLe3lWO54qV7ymL5zF9Lst1y3b2WXShQDdbysco9sfNg+6H1EYRdV1hVxsqJRp2ZX8zBxf0FSUGUztQ74nZHLN4HIAkB33wjDOcQfjlDwX3xWrIy+ZU0hgbzTW1t/YOqWFgfVJIrtaII5Sq77BPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AM9PR03MB7817.eurprd03.prod.outlook.com (2603:10a6:20b:415::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Mon, 25 Jul
 2022 15:10:59 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::59ef:35d2:2f27:e98b%4]) with mapi id 15.20.5458.018; Mon, 25 Jul 2022
 15:10:59 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Cc:     linuxppc-dev@lists.ozlabs.org,
        Camelia Groza <camelia.groza@nxp.com>,
        linux-kernel@vger.kernel.org (open list),
        Madalin Bucur <madalin.bucur@nxp.com>,
        linux-arm-kernel@lists.infradead.org,
        Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH v4 01/25] dt-bindings: net: Convert FMan MAC bindings to yaml
Date:   Mon, 25 Jul 2022 11:10:15 -0400
Message-Id: <20220725151039.2581576-2-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220725151039.2581576-1-sean.anderson@seco.com>
References: <20220725151039.2581576-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR03CA0229.namprd03.prod.outlook.com
 (2603:10b6:610:e7::24) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c0a077f3-f893-4ef1-4c4e-08da6e4fe18f
X-MS-TrafficTypeDiagnostic: AM9PR03MB7817:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MhfPGcHW5C56e1+lloN74aUx8oZDhEY2H9dNmLqwZshKC1KGwBHai/ggsbMP5xdzuQFpZoiverEpTMNPeS35SF4R8QseWIlNrehntOe9rMp9gtJKVGGJs2AcgaNqGjZ8SO5kx/nqQVHO7M2YGF0ohBCndWHVEHa+7FFoHzl+OZJ5B0AjvgiNBexFTBQTLdz3GEon8uq+C0zq9Nl1pIG4dMQgyTZhyM4GkCnriwNCNhS/6KPjUFs7PQw/GwpJSN/2KhnWgcHj/J7DFM0WWXpwUt76m5H+FDhchMht7gnpbPlLd8y34isjZQkGTlP17MWY7c7z3RWFzcjy27XkOju3b4nbfbfuL7E8XYYLOzI1+FEGXQPt4zVJo+lweP+zUepbxqzwFDnX991oZgVEgoPjvxb1MmFcEn1BTmmLGu3i12jL6LgKc2QHEAzvisowDZqyABBpZV4H0O1CkB7gjO0+sCOhAfR6G3KgAjrOoOjHsIng6FLqgSx+wH02yr2hN41ecJmKo6qSv3xduP1jd1JEtnnE/GOriDfzePjjJEipbK/1IyfMHGuxIMw4kvRc8E4txgL5yQ2zDgB+ViZe1+8wgVWLMpzrG/WwuLHvx2nqd64LsVW2wGuTtZT5aCOH6Idr5An1SEJ1myHAquMCyWd3jm474nqMt4MWeuGKYDW5dp/U5ALzcWK7erh6di8CdnsSEWB2U8o/Nh1PdTwLWASf38st/r4IdvYUuw/umunCqUQEcPbNpphi1SoWcJA2qyAj0ZGg9BFfskoubaPIyFeSKxJZxNXeIPsWk6ugIlrzufILZ1EnbLl/lh/zjxy8UgZwMM1WZlq5h6S5pvGeInGpm0Ftbeo7WogwObTo7gtnTYML6K7+fVbnhjAESurlq09f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(396003)(346002)(366004)(376002)(36756003)(110136005)(54906003)(186003)(38350700002)(8676002)(66556008)(66946007)(316002)(66476007)(38100700002)(8936002)(86362001)(2616005)(478600001)(4326008)(5660300002)(6666004)(966005)(83380400001)(7416002)(6506007)(41300700001)(6486002)(44832011)(26005)(6512007)(52116002)(1076003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oXoZ8el4KJTq8IKDswgblYFll0cnGNA2c+JPTmydpL2HY94ZwLqZB5bRIfld?=
 =?us-ascii?Q?7j+RkMdkIrO4leMNXL1weBnk7shLzNx75tq/LJWSD4nQA7Q+GFVmy96tIsEg?=
 =?us-ascii?Q?AtmxYbreQQ5WfrR3pZQccwDw3GC70myoWUecSUVntZw4BlWTyTBp851BtAoM?=
 =?us-ascii?Q?NzcP3uYO7k5rGN3K6BmAdEsy5hThcIe1qD2mnwmM2XqmzhAsUwSzA76u+7PS?=
 =?us-ascii?Q?06LGhCBNs4HGjZT4ndJjIalv0RooE/kInt248ts/W+tIrqKTFGcFuXDWuOj6?=
 =?us-ascii?Q?fvOQGKyC+4KHu7rj7vSRNWXWjSSVVvZeNGo8/QL6G7t7HB1sL/S2FRjecm4m?=
 =?us-ascii?Q?XbzwuMwxNAqj3uPV7D5YkscRNQtpIf3m8g0EMwupPJyNMQw4lKvEnheUMo1W?=
 =?us-ascii?Q?PguOeqOlZErJ2WnBlUCEeHeapjIidNNS0Bo3udAzZHsiHAnY85pB1LWM+7sm?=
 =?us-ascii?Q?j+iXNmkAHaF4d/tpu/Eij6F32Wf0ZzMo1/q/2CvLKuOHEUK0FQIekVm5s/mz?=
 =?us-ascii?Q?z+c0q68JzjXJWj2lBaNLDdO5HO8L5PITyQ+wj7zPYkJS5wlSoBAb75GZ9G3G?=
 =?us-ascii?Q?fkNMfN97mfx9SqloqVC8d7qRO+ZXK1/JJ+A2AWtCK4o4JSqT5agyYUnvVbhO?=
 =?us-ascii?Q?MjArA4afEiePVUR4kiEfyWAqJ+NRyp3cRYWRKuG7BoPe1r4ACAkhoMi2H1dw?=
 =?us-ascii?Q?w/aJC4D7IWJdXQSJBFUxj/dfyD9Qq51y/PvbtiNevqQbsp9Xj97goEORXu8x?=
 =?us-ascii?Q?0do8ixyCrWilQVaCLKsvIZBuH25QqFQzfu7O5gYJXh0emP1mMNqPJxiIraZE?=
 =?us-ascii?Q?lfAKwBYWZ/8sIczrkrwIsAZ8tq+BgKBw7D4oRljewriqynsb0cBOvokJ5eHC?=
 =?us-ascii?Q?Ry0TpzxReguIB3FIYfwsDPwe9K3qVXuFxcEa508UyTrws8sWbGdyi6kXQqXZ?=
 =?us-ascii?Q?hmfWc2XI2FXj7nK3iW3lqqDprrzx5aIfAfWc97vJC5PoskJ4cuUva+OfUyx4?=
 =?us-ascii?Q?BOjX19b/VuvQhlk0juuIl+50m8+vQ8XYwVtCHl97r+lbCKL/Wn/lanbYiyhq?=
 =?us-ascii?Q?DQn/dL274PF5mJmsEhRI85W1VWhXKN9unY+iiGHSaQ5I2jEJ7jVz2LXRcoGY?=
 =?us-ascii?Q?ljRT97Zt9F9vYcIqWmbZ80KR5PhvmIM+gbWtYE21sSYX8mxSnpi8H8+kC3Nw?=
 =?us-ascii?Q?rdI4CcdGZVlKzO8vTwI1Fz2WX0YOYm4vFgyFS2P3PCnKtcjxw+flrO0SSeLG?=
 =?us-ascii?Q?0Vvuf+omA9V5ECjzF8EYsfdJinSPf5Yg5DTX4CLpau+6hHc1JGAixHthmsRV?=
 =?us-ascii?Q?f569gyHw3Kd7R0A0WNKqFefTziaK2ffseKzyqoNcWggXEmRFvZNMo+R42tK+?=
 =?us-ascii?Q?+oX8CSdvb/idUxWU3qiPWfilc6wIUzT2oYORN5X/VHJebgUoxkZaifDgM0w/?=
 =?us-ascii?Q?62W120QufKrY7LsQTRMbwipCrT2JJREQeu/H+bac5QdM9TuhipAdhUjqkaRv?=
 =?us-ascii?Q?0Hkblw59uxxiqLF7mXBBODK7X1XbyAlfdntBAgzkg+H1Ehtbl0MyhaiPHaJy?=
 =?us-ascii?Q?WKwUxDGn69T1HGr4OjaGs3bmWqJykkthGaQbpMjpP86IgTez2wVw0E67dy4m?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a077f3-f893-4ef1-4c4e-08da6e4fe18f
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jul 2022 15:10:59.4114
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mUVryMKgIh33LYSR59VWEQafUfGqdrZeL6oZd8VfwTPLDPrdo93/WelxE6PwvHM4h1ST9+kX01dk8MdgEwlxFQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR03MB7817
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the MAC portion of the FMan MAC bindings to yaml.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
Reviewed-by: Rob Herring <robh@kernel.org>
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


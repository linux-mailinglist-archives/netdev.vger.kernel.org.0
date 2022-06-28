Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D35555F130
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230479AbiF1WOx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:14:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230151AbiF1WO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:29 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD8F35264;
        Tue, 28 Jun 2022 15:14:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dNVCstv0nCQ5Amn/YkliiVeWCsTcLQ8gzsVHgKk/ZWsv0JOUNlhM9aJTRBPybMd39RHSe5sN4+YlT3DpWGUke85iGzUgsxdny0VXsRnB09n4vsmc1BmvEW0Ik3IFnkN+dEYBzX9muqhccPZz6nW2bgpKpeu0VT+PXcSaRAdEDjZxh3eexMnyA73Cs35IjwsWzkRIBCIvqLOH9CekHRIhfEVbEGzXClstXDE2pnXlj2BGSDWte415fCUK4p/iSc7fx8KgLIKlw0+DSoRlrZJb3Br14bUXpbTub0jwzPFQqgGD8P9tcOCQFxwlBrkrAtZGiGUQ22wjOB7jtN1+cWACdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cLnSmuKT/lPvS4Ez3izPO9ww9g2gJ+DfRGEU13yGhU4=;
 b=NN/tQ6dwx6GxEh0XV24vVICJJNFIKIlZsDq9vB3vGJAl71//Z5sQCERGRj41cDJ3D1Z+JTbRIjQRTY4xqS/FtBfl+P4nd4uS9ELCeH3UEHHEDT8kEmZdOBAKSTgD6QpwXOyanHz4aMQvseXTrplfoK+7YGYQ6K9XLCPugAzqnKsbeM/wlRWZaycZlyFIeywQ+otxWzRVI9pUxC0LDp2vhcqH/LYszF1QF1bti/evJNfjaYeI6oggf7KTOaJxfb5cS2bZPmXNmKHlFGAo6nNg8ssGc0AFgRkHWytsEuzJOgcCCSYfbFG/LQtPBwViZpGkoNp5wEJ7lUKb4/RE1EOlog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cLnSmuKT/lPvS4Ez3izPO9ww9g2gJ+DfRGEU13yGhU4=;
 b=WjKTeaBRaFg1NwSQ4JG0dYv3Ae3JMMaA4aQJ+h+pPmCO4Gz0Kvw7Q/q3PIw5R2jCHbb5R01OSJjF+RdROuMFZ/B4HddTow4IoxTmB4+j/zkCE5srXkL8AKSiUxMOyxwUCemsdR/Fp06APNrktPAL2tQaXUypA96UqNTFCtd0T5Z8ECQFvh92hVZMiS6xlL1+0fmFlLWCrUtsWSrbGy1/U/DfLPsney6NkI3Pgz9mxCpeLEAKYakv0VDQZfqsSk7sooaCKC5vcAVHP2R6mAqdSGH123ZWrjHHVznPfzX1M8Mv4TfuFxzF0ioSXOFRjHZrBSjQE5kh0gQW/aI1+5oNzw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:22 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:22 +0000
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
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v2 02/35] dt-bindings: net: Convert FMan MAC bindings to yaml
Date:   Tue, 28 Jun 2022 18:13:31 -0400
Message-Id: <20220628221404.1444200-3-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: fc0d5d39-c2b7-474f-36b1-08da59538dbc
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SFmTYc6MvfIFH2RIYkZ3MQPsyTmjuQNwY56kLCkfnEgI9Qnaay7HvFhuTlmZqSmGHaqAgfoj9kT9mBBKR4TImcvYM9os5wgrdn+r7H4kQ4fjbZtYIWFdW8VuG6PPUpLIWiIHocg5mHNso2DTcIBCEjbLhIPWCLZ9moeC5w0g602z1jWExw+2QShZsGbQOIJ1Eg/bmgIirX5Ar9G4eoWxW+NOSqaL76p8Olhj0oQMB5UvNBJzo+HjtEvMV6Q3aPDE7VH67lP0xR88jOaWI3oBkA87zMZS7+hhuiennUWsug53ES/0I7TO1Ss4F1FGy05WKJXu5nQ2qH/7meLextnuPojBN9gy2jZkg2IrlXjjQRhMQAvZG+2xyF3vY+WIdd+3wvNiA39fMm4nroOT/fiFsgFvMZIrYV/8qaIGom53Jt9gJZshMkdgxc82l+jwFCPFus89QWgWDEkUJV3QRdF6m0ZvTqCxX5nroJcv37Ai1YKKV2PmMT/F8rvKBOCX3wlYeXUfX1uXwmGMSg6D6HaDl8IXML4ay7Q8ETqGJOesydllNOWwlFwvqn9YZwcJrd+xxx5Q+HhHk2IIAZ2uuPE6VUR/XT5DX1C4ZB2tqFBzCSpyZ3tpy2GEaZ/mBMEnUAD3MYiGR7j+3ncNaOaXf1NTzgtqkVkOnX+fUeGc2fpBwerHlWzFAVbPW+SViKL5Ed1TomhFn6zjbdZwFuZpg4LpRDYXVIYkfFehtNYoOvzZ0ir9+xQXGD0qesq+WBBTgqmniKOTFwVxnFcOTyR1HHoUsiADUA83myQLeHE51KgqXd+jJTFTuFjCF2KN5oLWVLDV24ljwkTQEBeWX7FqzC+Cu7wJmH3WWae3x4jA+cL8XQk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(7416002)(44832011)(6512007)(6666004)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(966005)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fHyW0o3ByRBJybjOP5dmXVPxjSE7NE7n64MIhSI1QgbvLIzBnC1Mp5+0x/Ge?=
 =?us-ascii?Q?kU5kala4nOE3K6tpf6g/FvMJIY+FY+56nkaBWt2vj5fRibZgY4GNcq4ltnUs?=
 =?us-ascii?Q?jyjyU4gsVyPM5ChwB195dhsvF13skeGmuIbJHhu1YX4yCr6OV6k/RQmAasjx?=
 =?us-ascii?Q?MKroGHO8SLuLnxTdjHHAM8dMOKwP3ER9S4vbjZzzzFMiveSdwcGA9XyRiFUB?=
 =?us-ascii?Q?2WQaqU0kA0i8N898uRlKd0IS3cnEnqcpPHsQ1QZJ0lckSlEkKzuaZCj2iiJI?=
 =?us-ascii?Q?NXwq85zXV6k/pItzIYtYUXR16eQqO077FcSIyjqcEcNcik9KHGLDh7DHzo0w?=
 =?us-ascii?Q?06R7elqOpj6cMbUlZ+uRjDW7JkmRCARA26dM499vya1kUeaNNhdgkHx+WgHL?=
 =?us-ascii?Q?j3hLSJ9apTkSxwMeNJWGwt9rEZWAWQPgpeGHWJSrQLpXUzEPhYBsnEQikSc+?=
 =?us-ascii?Q?tJ9s46aUeufy0ukBH8qlMs4eowWxB19OlndRTX9opTAQSPkqY+GD5XbPCCKF?=
 =?us-ascii?Q?2iw+3jk2z6gCBjfb8RAyaU7PPjyv3hMI0IEydmTlobxcu/h/k7k/JMpTpXpn?=
 =?us-ascii?Q?m9Y32PGoHHzIZ/egRHzgh+qZaHXUtEwFnQx6qGsz7/kT8V5/h15Mtd4VTKQl?=
 =?us-ascii?Q?TrAKWgbPk24uZ8wKnVIksVTxZrmp8ioEbKJ6qmAQqUWwgbDffgkbhjGkH48O?=
 =?us-ascii?Q?IH5RaDf30/EHxNNLVEiQ7whK4avUBj6Efizq9LJQVW4E+xofaehWofpkH+8z?=
 =?us-ascii?Q?rTpmMUZknv/cjGwoidiecIc2kkraAvX2R0KYNIorQ2Wpbf3ScpqsYBYDzh/K?=
 =?us-ascii?Q?3zN50EJDDGM7vubV/BX8LywlWssY6Pa9hcyW30r3yl8T0GtJWyPD97/mhobw?=
 =?us-ascii?Q?HfJx107fApBF37Fwld4gkiD0r1gjEs1QZ/zpuRVFzwI8q3jPAjypXu2uj2JO?=
 =?us-ascii?Q?buAbrRFjlVmMve6h1SWXAaO9s2NKobhZ78CoGcNPp/f1oktcpfZP2LvGsiUU?=
 =?us-ascii?Q?XrxXQkeuE7ASJEgoHr235+2nPpRQePBOtqYW+Y8CAAZfC02QpewP8WKPmqZT?=
 =?us-ascii?Q?yQ/w9W7HW1i5lDLkFaRXFWMuG/VbNTqRpd+u1e59fqUclDMqK8vxUfXEZlF1?=
 =?us-ascii?Q?gYrW+hLjyti2IWxcP8OwR0xD6ogbcRjnKl1zyE0gBNWjiDAcAQdQgvinKS/v?=
 =?us-ascii?Q?qyLZScEQsgpxeR/7no0BTPJTi9hBdCbqIWHu7Lwf/JleQ21BvtC2fQhu3b3D?=
 =?us-ascii?Q?976MXrb+s0Gf7XNNtMKMGWNXA0dxIDUhD8DD+cNAOS70Yw+4BzC5bHZHfjph?=
 =?us-ascii?Q?HaB1saaj2l479p5+t42LBXq8BInx+/CNCzo3xJbRorRmvzqak/9dzi1WbUSu?=
 =?us-ascii?Q?Jur6FNfkcrxTGdto9aviXOZ+Vjq+IImGChIxPF0UbylMcg6DXlh132iZiDwP?=
 =?us-ascii?Q?gxRpblGdIbXFhiofsGiqb77tUIfsam0tuPrtRln8pzOsVcf7GnxYcUy5JdD2?=
 =?us-ascii?Q?GK1YuYKGcBBnqVvA4kMt/pBKMPJZM1UsoCK1JHo5tzXMrUfQQ1mg5ReuZSVR?=
 =?us-ascii?Q?/5PnWtE8Qax3mJWKbI+pNwm8twGKfpANc/ZO2Bm+fZyQvIaEZ5n9CHT0TEX3?=
 =?us-ascii?Q?6Q=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc0d5d39-c2b7-474f-36b1-08da59538dbc
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:22.2988
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: hJWWbYMqBBPZM//ARcAoAFhg6FQOI8DLFThJIYgxl8zknSzt4fmb5yv1dGhWUjIhUPupfbaGzeLB3hSgZHUvvA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7399
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This converts the MAC portion of the FMan MAC bindings to yaml.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- New

 .../bindings/net/fsl,fman-dtsec.yaml          | 144 ++++++++++++++++++
 .../devicetree/bindings/net/fsl-fman.txt      | 128 +---------------
 2 files changed, 145 insertions(+), 127 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml

diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
new file mode 100644
index 000000000000..809df1589f20
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
@@ -0,0 +1,144 @@
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
+  - $ref: "ethernet-controller.yaml#"
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


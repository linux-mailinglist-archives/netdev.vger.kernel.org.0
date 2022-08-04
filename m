Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB9C58A172
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 21:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbiHDTri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 15:47:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237097AbiHDTrf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 15:47:35 -0400
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-eopbgr130085.outbound.protection.outlook.com [40.107.13.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039BB6BD53;
        Thu,  4 Aug 2022 12:47:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dgo0D1DYkVuBOCwXfdtZOFykEyUBKTvaR7eyaDM3Ms3vSYCdJ3k/Sg7eDDDnf4kAoXgV/VInJNmdMoBFW8xpPH6Dk/jFMFeimXHg8KIkFmC1QQ9UHzQZgWGoJsGaW78UBLjQYsCL0mxdkTS8jTpXVcZXVQYoWC7DulvxhpL0vGews40JCPh6P2rUPvO9c7D4lzMZF3sD00bdyLsu/ycN5e6FOUjZQpvVOSOH426tsHBts7smneFuLlrm7Ok5SF2jrn1fCByBxD/Sk35R7h1ysgXz/NhkjaPEL6tn8YXh3Z3+3+9JLnrwMed3XuWfUfYp2ZhnMyUgNiYwjDTd8MI3Bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/rFDiaVxvOHtQ65IrquHz2bwl4lCXIK1BRND8yyrpwM=;
 b=WhwRl48dYi/oLPDQtRcaEh9DxdywCdZDqFTSCZyTAPan1gDiJO2y72mkwEn96e5cRYlvzgZdW1xeXuI4CfXMawdxrX9mYtPv6ETxOWgFEK4bG+sDXWqixPSgIbw1pccTHQ9zzQBSFunBCrRFynvJIw+ZcctxIi484+AIh/jbNIqQ4aGmJb0kjFtuZcab49CENYGSrQfNwYPumeLnd8JZLJhgpWVZO1DlpeTkcT10I8R+AVZD1h0eTo2JrTwq6fcXZ8txGSojPsZ8m7IMdYV77RrJ334xM2v+jhu6tRi/L32piG3lOe8thiIuXw6VrRoewtXF6RxiON8Deygeh7UUtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/rFDiaVxvOHtQ65IrquHz2bwl4lCXIK1BRND8yyrpwM=;
 b=rzf6CYQo1whxTqtGc2qpY2tHkNR6J238nQbS7RkWrJG7nQoiRk6E4D4JijYyjN/qulYwXb5COzTafi8VKJBUcOTkX6wFLZEh7e8bTVRr8E+YvZNKQCsaL8Y6qudKhoB7BB9FG+vstMmv5YwXHolVLiLdZo1kUHDVqARBZ101WcoqDadHVlKyDXjEKoDgYJHal23V4Tl/MG4bRMoGlOnFwksMxzHxJjV61uWyLT53tcoXT7pRt/pRe96u39vjvw3V2YPF9E+nKBN9Qfv9y/pW11711LEJs2u9INxHKUoyxQ9Tesgd313KACI/f3NerPhh5qk5BPUFlzLPzsKZriTJPA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by HE1PR0301MB2297.eurprd03.prod.outlook.com (2603:10a6:3:25::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Thu, 4 Aug
 2022 19:47:28 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::ecaa:a5a9:f0d5:27a2%4]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 19:47:28 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org,
        Eric Dumazet <edumazet@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Anderson <sean.anderson@seco.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v4 2/8] dt-bindings: net: fman: Add additional interface properties
Date:   Thu,  4 Aug 2022 15:46:59 -0400
Message-Id: <20220804194705.459670-3-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220804194705.459670-1-sean.anderson@seco.com>
References: <20220804194705.459670-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1P223CA0012.NAMP223.PROD.OUTLOOK.COM
 (2603:10b6:208:2c4::17) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b993829-0345-401d-228a-08da7652295e
X-MS-TrafficTypeDiagnostic: HE1PR0301MB2297:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W/8vAQpoxTYc2AbrUW0na47iwP6XEjetfpWTBmkNWrU/K6sqeL+qcCHWxVJuSN/t3BqfUIynKmo7R+OhuIxf3CxvThTa+cDa173uJg87ctTrDG+tG3YKcVPKE/IZGU+WMISd0oZOHuAinozQ2HluQu5wt6kEDfzN1fbEJeDTrMDEVtilk4Z1dL6m3lsb4mcmYyo/jUZZhIuAHlwepar3xQvpxnJJ6oTnjjObHCnvG2zfrq+en1KKFnbAAvdppVZQiAMG/4sO0Q6hk3kY29TnOClc2GbHyOGjM0Qz4PSikecNsMXVI3OxQuO4S2u8g4ABo1EW6SBunLvU2iD0vB+jtTU6bgp3u8VvDoP0fuzz+XVtF1wwQNeGXlqHtRQme/eACUsinRalNXFhuam4pJwLvN3GPgkqR0ilQz6VimcYEcMDeS38oaOCjQPloVmfpDU4GQ5WhzScwXfHcfa+9uvjW8V8e0T2fwCO+y6EHcrORSqaeSDzEFNTPPweEygydt8S6v6E6kpCj9U2+yE/4C+G3n9XdLN5ntq50f+x1+c958v6vqUj9cwPNd+QOKcBXWfK5tSV5AIKm3fqIJL4rsZ/eggALTCwKHZqjt/JOKRJdozX1wVlt9ODcppB02omhNOQdeGJZ2hXiUgQWA6FLcDOWR/H0yMlPhysmYzRsZSGy4HhoSSGm8GDDZaDe5iEMTXvppux9daHxxN7BD31s7JMPTm53rFw6ISDdyFH0hY3t6L+sX1Tok+9K6f2e8FAE069GABD0hibTEgJomCvCt24JT1D2sjrP26WLM+Tz6VVQagZRy6PcVBSQN8+SjWqYjsO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(366004)(346002)(376002)(136003)(396003)(6486002)(478600001)(186003)(1076003)(26005)(7416002)(6506007)(6666004)(2906002)(6512007)(8936002)(83380400001)(44832011)(41300700001)(38350700002)(110136005)(38100700002)(86362001)(316002)(5660300002)(54906003)(8676002)(36756003)(66946007)(66556008)(4326008)(2616005)(66476007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3Mpf+df4u76op3CJLR9l/mgNxO+EZPHzPvg/66c0AQ1RuAsg6kWDJ55Tg9d3?=
 =?us-ascii?Q?gGvp3ZWXWucYTzk9QG3GuRUnXdtrA+g+27eAz94TszzWNRDITOZ8JiMsNukj?=
 =?us-ascii?Q?o7+sU1jhj9GJtmqJEGSNC14CMlP13RK8sF3y8EeR1sK3vPoRH2EBdbZEr7s0?=
 =?us-ascii?Q?ELBh8E8J5cuhptxiWgqfvPUAHDLx4byhXOd5XsWvn1xLiq+IKQcRdejDJxHs?=
 =?us-ascii?Q?5exCYI4avDbx+OzjkWc3LQohA9wozup+6KN3RtYYNNw3iW0xyoIBSm+zgw0/?=
 =?us-ascii?Q?O1uIJdek3DFmG8jZzPm7P3sivnDRlLsbWF4SzxJVVPD9hOzUDSVJL3MAAXLZ?=
 =?us-ascii?Q?7Nc6+ZYquWYwsI49d7UjUenHkP81WXLJt/JRv4KIOEs1yfg80lMInL08ENbs?=
 =?us-ascii?Q?yOm+ZRObGB98DDNoM0Pf4PMTgoOxtYwKoY0Hz9eY5ZVO10tmkE+qTpQfaul+?=
 =?us-ascii?Q?loqs1vyANzGq4lbhuBKBSQNyaHi4WNirecm6p/EjBOEcQ70IcOtuEK17RN6o?=
 =?us-ascii?Q?VwRDWo2uxVMb65KF/kFLuUpFn7OfYr4Tki+3M63OFx+mMiPe58bPMIpbGhCP?=
 =?us-ascii?Q?R0t3DptR8Cg6sQtjh3ZG9PI4GTOl6XTER8XDTQ14OikefSSNX2UG8hPynJyz?=
 =?us-ascii?Q?Lj042c8/zsS74hmSggOVTBeO6LwPdDN+fRrYct2G9qaGv3DdmDrTJDqG2eHP?=
 =?us-ascii?Q?v7DlodLsgHdf/3Bg0h9c27hlJAHiC+0fkVLkURH7DtAcUvi5Zn/RYhwS1W0F?=
 =?us-ascii?Q?al4abCxEiPGes54azZaCa6Qz1XNpkeOUqbOPjAebbDvEKv7RVIawkHAMJLQO?=
 =?us-ascii?Q?XnLZ9K9BJymaWx0y3JFmPX6ASCWApCiziVa+4spK0mT55sZnoyFM751QYUMm?=
 =?us-ascii?Q?vdEIpli+gIQ03y/NSxqPEzPtUGJ4EGTB2/9zAjqvkFaTKr/cAub2Ib3BAqW5?=
 =?us-ascii?Q?E6E5RZd32zYU/fEBGgtuaSSbe3C48EoeHLB7sbU2qKKDPBZBAe4P7seu2I7q?=
 =?us-ascii?Q?TcIwUHUgMKOTPFx1VlFEi2P1Oxo83hRrVwacKd9U8JIVKHOLDltAmPXbKyy7?=
 =?us-ascii?Q?+sSAagKo82zFECHE61q5prlf/Gi/cE8L+id9hMSNm2zhP2yd+DuW+e9VR0lA?=
 =?us-ascii?Q?JQLPJNy1FmE9jgg8qMWaZOCpSRxJYZtco1lAFfb3ch/L+2P2m1VSc470Uhhj?=
 =?us-ascii?Q?SCO3R0HWJHmzR8IVq0yVz+hKm19vwvQ2SNFKe87Tbus1gwSeWst6SNtp6pbP?=
 =?us-ascii?Q?Wu91c+sDiI+JEzToxVW0oa+c65gaerHI8lyisW1s2kgzmeZKkKqcwBFxFbxD?=
 =?us-ascii?Q?iCUgCI9vaPl5xA8COIyeytTSKNm1eyqsRyq4qivneJJpNcUqLJYo9ZVet/Bl?=
 =?us-ascii?Q?9dmIFBhMYQ9D3ButMfyvDX7lD7JUQUJjT6AVy1PNGP5G5rEUE7zZhB+g1tvY?=
 =?us-ascii?Q?e7kYi+AKH9nVWzPtb51Xy0HH8icgzXjjb0XDEP30+6b2B50qp9gENUmnCrCq?=
 =?us-ascii?Q?cz6SBSgQEbHLMFh43ucT4YkakWLP95CN+5TDFn+v9GxSD86XFGAMANgqHhgk?=
 =?us-ascii?Q?VC3UCt3bClrwvfEo0Elrcc+xPYEZAcAZn0FP96U2GfWj4ZpavcyyV5AGU8nc?=
 =?us-ascii?Q?yA=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b993829-0345-401d-228a-08da7652295e
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 19:47:28.1496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jvI2IxT13BFxZ/e8/Sc7MKy+48pW6yl1+uVFaO2DJRebDghoaJA8twdrCoQLTSUlKxuJE+yMQ/jPJ3IpBXyGAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2297
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At the moment, mEMACs are configured almost completely based on the
phy-connection-type. That is, if the phy interface is RGMII, it assumed
that RGMII is supported. For some interfaces, it is assumed that the
RCW/bootloader has set up the SerDes properly. This is generally OK, but
restricts runtime reconfiguration. The actual link state is never
reported.

To address these shortcomings, the driver will need additional
information. First, it needs to know how to access the PCS/PMAs (in
order to configure them and get the link status). The SGMII PCS/PMA is
the only currently-described PCS/PMA. Add the XFI and QSGMII PCS/PMAs as
well. The XFI (and 10GBASE-KR) PCS/PMA is a c45 "phy" which sits on the
same MDIO bus as SGMII PCS/PMA. By default they will have conflicting
addresses, but they are also not enabled at the same time by default.
Therefore, we can let the XFI PCS/PMA be the default when
phy-connection-type is xgmii. This will allow for
backwards-compatibility.

QSGMII, however, cannot work with the current binding. This is because
the QSGMII PCS/PMAs are only present on one MAC's MDIO bus. At the
moment this is worked around by having every MAC write to the PCS/PMA
addresses (without checking if they are present). This only works if
each MAC has the same configuration, and only if we don't need to know
the status. Because the QSGMII PCS/PMA will typically be located on a
different MDIO bus than the MAC's SGMII PCS/PMA, there is no fallback
for the QSGMII PCS/PMA.

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

(no changes since v3)

Changes in v3:
- Add vendor prefix 'fsl,' to rgmii and mii properties.
- Set maxItems for pcs-names
- Remove phy-* properties from example because dt-schema complains and I
  can't be bothered to figure out how to make it work.
- Add pcs-handle as a preferred version of pcsphy-handle
- Deprecate pcsphy-handle
- Remove mii/rmii properties

Changes in v2:
- Better document how we select which PCS to use in the default case

 .../bindings/net/fsl,fman-dtsec.yaml          | 53 ++++++++++++++-----
 .../devicetree/bindings/net/fsl-fman.txt      |  5 +-
 2 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
index 3a35ac1c260d..c80c880a9dab 100644
--- a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
@@ -85,9 +85,39 @@ properties:
     $ref: /schemas/types.yaml#/definitions/phandle
     description: A reference to the IEEE1588 timer
 
+  phys:
+    description: A reference to the SerDes lane(s)
+    maxItems: 1
+
+  phy-names:
+    items:
+      - const: serdes
+
   pcsphy-handle:
-    $ref: /schemas/types.yaml#/definitions/phandle
-    description: A reference to the PCS (typically found on the SerDes)
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    minItems: 1
+    maxItems: 3
+    deprecated: true
+    description: See pcs-handle.
+
+  pcs-handle:
+    minItems: 1
+    maxItems: 3
+    description: |
+      A reference to the various PCSs (typically found on the SerDes). If
+      pcs-handle-names is absent, and phy-connection-type is "xgmii", then the first
+      reference will be assumed to be for "xfi". Otherwise, if pcs-handle-names is
+      absent, then the first reference will be assumed to be for "sgmii".
+
+  pcs-handle-names:
+    minItems: 1
+    maxItems: 3
+    items:
+      enum:
+        - sgmii
+        - qsgmii
+        - xfi
+    description: The type of each PCS in pcsphy-handle.
 
   tbi-handle:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -100,6 +130,10 @@ required:
   - fsl,fman-ports
   - ptp-timer
 
+dependencies:
+  pcs-handle-names:
+    - pcs-handle
+
 allOf:
   - $ref: ethernet-controller.yaml#
   - if:
@@ -110,14 +144,6 @@ allOf:
     then:
       required:
         - tbi-handle
-  - if:
-      properties:
-        compatible:
-          contains:
-            const: fsl,fman-memac
-    then:
-      required:
-        - pcsphy-handle
 
 unevaluatedProperties: false
 
@@ -138,8 +164,9 @@ examples:
             reg = <0xe8000 0x1000>;
             fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
             ptp-timer = <&ptp_timer0>;
-            pcsphy-handle = <&pcsphy4>;
-            phy-handle = <&sgmii_phy1>;
-            phy-connection-type = "sgmii";
+            pcs-handle = <&pcsphy4>, <&qsgmiib_pcs1>;
+            pcs-handle-names = "sgmii", "qsgmii";
+            phys = <&serdes1 1>;
+            phy-names = "serdes";
     };
 ...
diff --git a/Documentation/devicetree/bindings/net/fsl-fman.txt b/Documentation/devicetree/bindings/net/fsl-fman.txt
index b9055335db3b..bda4b41af074 100644
--- a/Documentation/devicetree/bindings/net/fsl-fman.txt
+++ b/Documentation/devicetree/bindings/net/fsl-fman.txt
@@ -320,8 +320,9 @@ For internal PHY device on internal mdio bus, a PHY node should be created.
 See the definition of the PHY node in booting-without-of.txt for an
 example of how to define a PHY (Internal PHY has no interrupt line).
 - For "fsl,fman-mdio" compatible internal mdio bus, the PHY is TBI PHY.
-- For "fsl,fman-memac-mdio" compatible internal mdio bus, the PHY is PCS PHY,
-  PCS PHY addr must be '0'.
+- For "fsl,fman-memac-mdio" compatible internal mdio bus, the PHY is PCS PHY.
+  The PCS PHY address should correspond to the value of the appropriate
+  MDEV_PORT.
 
 EXAMPLE
 
-- 
2.35.1.1320.gc452695387.dirty


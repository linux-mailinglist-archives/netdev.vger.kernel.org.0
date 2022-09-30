Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9F95F1344
	for <lists+netdev@lfdr.de>; Fri, 30 Sep 2022 22:10:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232414AbiI3UKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 16:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbiI3UKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 16:10:12 -0400
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2054.outbound.protection.outlook.com [40.107.104.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BF0D74CDD;
        Fri, 30 Sep 2022 13:10:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sd1GB1Mqg65p6Q699ntQ1p8+VCmKltBHykUcmnLlmtekcjw5+4GKs46+pYY7AC9aH866/p1TORDU14jcEV37wWcDWCn15rptsAd+qLnddloMRFSzd0ZT6zg99qjyL/U4xR0Um6g6jSyORcnW65qKuOrrxfwj++30SEc405SguoK7go5gRY9k/1prfMaIomFBxxcbznT+5dYBl+8rpePP3yz1wXwqrSKnJuYvzL6vk9Sgy8DKkPuMkNj7Q2hz3mK3YLfGQ7YZJCy/vivQcZp9bqt3Bw1vVGKcqp9UhcaQ35ICLXP8YiIZ1x6CawVun92J2Zf4EM8pkhthZwlKHipUQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjABrl/nqtklpdfa6OE0UzmntYkgGRDZDSkLSpYm2PA=;
 b=emY2/4Ea1kMTevcbLnxhsmm9hJrGnIBSLAUAoIx2EByBvEi9uRG8NbSH2i6yPAfp0CHVnKm0TXBXE33Vv4lv0q0eVqPE7JyNgmmXZjn66fHc5ZBzSXOqL01nlEokawz3b2LM/gOQLAtIxV8fpi+Cm0HVQs12oh8s2J5lMs/mLcXohrml4eiGKS9S7LXNyYQRe2z6juRYwg2ju07puo+O68qQq0cRkz4Tn1kD1FJxn8TMYvm947rJA3TWKMNenGDCFg3cRpqoHtHjphwzS5CITAJ/nffIFMNGxDQ+BEtuRqs6EJjyNC+hou0lxxBUCryADRW4kF+tWwHPN2/j7Qew5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjABrl/nqtklpdfa6OE0UzmntYkgGRDZDSkLSpYm2PA=;
 b=LAwDKvGuSy+zGB7thll7gEAV9zqCEARZw6ZYTDOmM0FfDv8CY7FKRN9WmrjDqYFxHjCMDYIun7kJrUPRU2PPQQEOiSJCRJIqFNfi48vmABdqKfFbQIAMLvEo1SVY4672Arac/OF6RWUM/5wsWM9X1uYXc1BhmHyy0agvQZy+CSQ69JSsfYMQttT+w5TBVG8F2K8xp0StemmJJYgthzb7viIcdliJ4MH0uatFbOObhi3rh9ha192dkKNRSf/5LpO7v6OZqydS7UP4MuOzRB6JW39RTgaLsU56zqjrTo48GdBSpuGWU5kX9CbPyEvm5K8G4LQuKH1OGwruN0NyoRmqVw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7749.eurprd03.prod.outlook.com (2603:10a6:20b:404::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.23; Fri, 30 Sep
 2022 20:09:52 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5676.023; Fri, 30 Sep 2022
 20:09:52 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v6 3/9] dt-bindings: net: fman: Add additional interface properties
Date:   Fri, 30 Sep 2022 16:09:27 -0400
Message-Id: <20220930200933.4111249-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220930200933.4111249-1-sean.anderson@seco.com>
References: <20220930200933.4111249-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL1PR13CA0144.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::29) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|AS8PR03MB7749:EE_
X-MS-Office365-Filtering-Correlation-Id: 46550492-2dfb-46cb-929e-08daa31fbc34
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hcazLOyKsjq5D0EP5g807IMRitFQBIJGs3z4IgpF6atNzceaDZcaoeeNERvo0GFIbwuVEdmBMmk0WtwTPRNkizByC+JI3tiIrWr+7DG85h4vAkq8rGz1OzbxOTSSV7J5xlQc/6J9p3b0+BdvJ7DjDNUwKKd+BU/Uh/h9P6FAKr++RhV6a+tVMe4Ko4utZablYgFvpTytLIlDpqEUjl92/Y/Do5dCo+gm+whgboPLA/SYYWyd/HyDXcHcXgUeNA2kz7cYlbZI32RzUjWVSFC9TnNEKXcAdiQh9v9oABgn+vuKLRaMeoZYYAT/jVu+XWnsa3gj1HJn4vIiCrxU4stOO8Cv7aScMVY7A7bbaBqSEx/T3e6Yk/AbJvja6bIaa343DL1KRWHCqQ5Omtgr8kjYhfigxqD5kffz9cVPBSoZedysHdScl7+3kDxRPWIA9wng8GvsBXyxpCHMdZ1lMn8Zam59DJFUisjMrgmNwreOT4t9Xzj1wFZYdVsQhDKHgcc2kLbVidP0BV4MpVb9ZK7k1lBDIpjlQB1i1ux5lesP4BFLanDqRt/m1yOipo89Ivsp/jxjQ6XqPGZiNBkZo+O/gBlDhEcBmzFuByFLVP/8Bcrh95R1QhsWs0rCHO330CJICBEMh+nq60YGlh7aWce3NXw5ZjkkPge810IlJQO/k1KSUIONIfAYED2OXsYzEHWqbJ1xSfLVjE21ja+NIbeEUik073IcZsF1CcfyqYP0Bb8HCSPXRY48MuPf8qkJPE0S3W6QDeYWfKsGaX2n6dfPPw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(396003)(346002)(39850400004)(451199015)(66946007)(2906002)(6666004)(38350700002)(38100700002)(8676002)(66476007)(66556008)(4326008)(83380400001)(41300700001)(36756003)(6486002)(6512007)(478600001)(6506007)(52116002)(26005)(110136005)(316002)(54906003)(186003)(1076003)(2616005)(86362001)(8936002)(7416002)(44832011)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ev+swq5SDQrlgTkPmmXyByC6mWCcFzAUKzanojGQPYuCowWRHWUf1lnet525?=
 =?us-ascii?Q?VMvgxDGBj9M2RP2ZKNPlBizgx6aklu9DHdTuwL16pPpmADBOZ5mvb3FQyQH4?=
 =?us-ascii?Q?nnxt5S5HtUZ/iNz2HvLsGNWk182/ABgd1XMYPMr1Gp7ffNdLKU9RQ3RdZ5ch?=
 =?us-ascii?Q?1i7XBvOe9fXRNv8Z6esA1aKiQW1qsVgppx+k8AN4ArNZlhQXt7+XQNE+7bzS?=
 =?us-ascii?Q?eZXHLid9fgXmknVWSf7bMQ2r3o+W1WTHoKt+ztD0JBIdrlugwYV8B40n1AwT?=
 =?us-ascii?Q?on1p/zN/9OzcMfCJDyZhmrgeoNs3Gjo3iFQII6+XbhtRUZPOPnSbpxlCqgPf?=
 =?us-ascii?Q?8JuIHEH/ep7uKWMxM/x/By4IzCTR6PrT2h1f13dVGU9h+o0UkCVMYpKy3mKM?=
 =?us-ascii?Q?9em5shayIMOYqi9ikIHliitJxWL4L4TUXrzzN1ESNPfBqPvwZF4D9eci5TI/?=
 =?us-ascii?Q?X9QLmFdFyPrwIdRaByGZcKtlKJUMgZtICNiKDyyBbVBPeBCV5mEuOFcNBvEG?=
 =?us-ascii?Q?L8RqBoOatZQWMTcCrnnARx0TR+qd4GeI6+GKyEvPNoTJXAQJad1r9Oc1OjkZ?=
 =?us-ascii?Q?T3b6CCprfdHYD/tLNHQW0/1CgaJfH0jmUrkHbmmhSSKiyVPeRp4pUI3x9r5G?=
 =?us-ascii?Q?3L6IS/7E7dbmg9gK+RCxU1rldzNj8VaZP+BK8zmPiGkM7E+ritOft44E7W19?=
 =?us-ascii?Q?YVx10HRUHGgtGyYIpLKycgAiVioGyGkcFFfmCouO1NygPQK2ClF076eHTTCQ?=
 =?us-ascii?Q?zaR33Hm+v0OB7nsUoCPyVfxraJIDqJKfN0fUfq5FzhzeCssVXGsiOdojhJ7K?=
 =?us-ascii?Q?YyXAd6kKJlLBPfQy7Hmxeek9uz7GxNJ2S2iZeU0f5dt0VjgQhncyV5AopN7q?=
 =?us-ascii?Q?IRDZIQJW7US4dSe4hbKD0Dl7yy1eyV9ik7J0ljX2O0putHBsbi4ypJvMCskK?=
 =?us-ascii?Q?kxOSggcBoE7KjMaU1CtT5044Nrek5KsyJ2kwgzX2t5tbX9TaZSywcOiyOGGi?=
 =?us-ascii?Q?RlKBeoa8nh9G4rPZFIrl0d51AxlxEpmHROh2STw7xPncvKOTIBVoqGx1oD+L?=
 =?us-ascii?Q?tnFkN0hjkbXSnqlsRn3Z8dp2WqWr6e0C0ucJmeAozkn0VFclv+0BYipCEDei?=
 =?us-ascii?Q?jSYGLAr3qvlD62UnC/10XtgcdCLZ7kyC/lKgk55Did4Iy3frFy240nCBCBTu?=
 =?us-ascii?Q?MJMHWip5Q6Lz4dtWgQVHO8iwpkhnpVTkVn7Nw2o+HNTgsdLPGLEbcLQQY7At?=
 =?us-ascii?Q?/FDeGna7GKAn/S+Hm+yOMWeDq972z5GiLPqwR1x2F6uLFJFpxKTq6ZmD/efu?=
 =?us-ascii?Q?TcgANPlEwHXoAoriglJ0t8AHFGoQCh5EOb0hqv2URM46mlpJVtxr8amDqWvp?=
 =?us-ascii?Q?oQsy3xN5DTJbViQh0VhiRRMh5+Li+aADT5X6lFcmGDMdWmzBV90CmYaUJj6X?=
 =?us-ascii?Q?MKlixtvHlMYLwqi0rRwigIqQVI6/SxrXvdF2tJNyw5AtfbbuISCpcL9gqVNJ?=
 =?us-ascii?Q?/eKSgMo16wcHNV2mARSIjTYTmVOMOTdxVdtRXPMZb2pjEX3i837QAXm562Tl?=
 =?us-ascii?Q?NKKtLLjSRqp2g8JBoL5ut+/HPHlqugjqIc6TS5rr3vF0slxvpUfoNf5y9CqQ?=
 =?us-ascii?Q?hQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46550492-2dfb-46cb-929e-08daa31fbc34
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Sep 2022 20:09:52.4003
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WnupCx4Mhr8wKubPB01M6/6J/rTJ8mHG/dECvGPB9N5WZyHWb1LH8ULOKudx2TdAMw8YOKwU3XjfRATb83PjLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR03MB7749
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
Reviewed-by: Rob Herring <robh@kernel.org>
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


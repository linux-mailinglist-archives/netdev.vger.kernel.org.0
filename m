Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CECB60194F
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 22:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiJQUXe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 16:23:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiJQUXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 16:23:22 -0400
Received: from EUR02-DB5-obe.outbound.protection.outlook.com (mail-db5eur02on2062d.outbound.protection.outlook.com [IPv6:2a01:111:f400:fe12::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D11B5073A;
        Mon, 17 Oct 2022 13:23:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D3W5a2OH2pYsLjvUTu0NDClvuZmOuGrzKiGaMlFQWvEXXCGO6GTsrhLBMV4BUkWLJdtjLzrI2obuetCLtsrDGWpAhSFoqXZOE9512ykjLNvqTpQY756KCya9wkqtxtF92MxYSrRxRRO2b9TtZs9v+5kdWbA7Q5N3XuZW0Gcmgh7zeoA1OECeglYWNqYl/eyGz9oKQZ1D/xGzf9rsgsLoiBGnsBKw7/UM98vp5lAZ1NfHLtbkHnG8D2LVGqrJviFJhN1BFXOa5luNIH9UtuDg1Bb6om2HWBpoW+zie2tGVdFltf2FUmuDURiy6zJPiT5+5vwYP7J3ujH3iwZd9yxaeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjABrl/nqtklpdfa6OE0UzmntYkgGRDZDSkLSpYm2PA=;
 b=A4j89Qn347bBXhBMpYtb4N8X/pEQZr0KsNSOi0My83howoVKz8rhqlZrig151UE9WJsY6dilhhPdQUdhN2moWU/LdS4HRl39RYfG+mcMSukrcXcf5s+InSvJrnz00vnVrGJDMhwBoRvHaExGlapBoVqRrI/aXeIGnFhzaNxwUJwjPauitWzkogAFv3oFOq6/9QwgclMxtbrG9liEe8TVfdWndConc5pHhyMWYgvp91Dvr7GuscJYT2OyOo43koFOd9x4vNdX314aDDM8NS065AMfnOOC4ackjmwqeRBEgOTO4rh7seSCi0EXri2PSRWgsUAOs53eE6ri9cKq662neA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjABrl/nqtklpdfa6OE0UzmntYkgGRDZDSkLSpYm2PA=;
 b=wntb8BrwK8Ao57WbBjfY0Um1KtExsIp8uCT4i3qM1UbGBBwVaM6FUav5swSItjkDOLyJYy1V8XJwi8YSMbgJR8MnepvVL55RdhUC4FNAibNoc7SJUmSe2SG1uujVDmUivCdyTjW0qZjs6K9ySOG8veS9yvcriX4jQswaF2GI3kdq/IGYMUPh6RFxb1PllFlA/Z/ka6uEw2YkIKoecti3VgNllpV1TIWn5uI/uH3l75piNfy+1NNwAPB/O+2cgsBpHcJQWCYexpsaoRWMK845FUJpdYQGAUMhGztBKIK6odzoLFTQC9ytBQ++QfC91c2x/G+p4YMdO/9rZeVywc7s/Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by DBBPR03MB6761.eurprd03.prod.outlook.com (2603:10a6:10:1f4::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.32; Mon, 17 Oct
 2022 20:23:14 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5723.033; Mon, 17 Oct 2022
 20:23:14 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v7 03/10] dt-bindings: net: fman: Add additional interface properties
Date:   Mon, 17 Oct 2022 16:22:34 -0400
Message-Id: <20221017202241.1741671-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20221017202241.1741671-1-sean.anderson@seco.com>
References: <20221017202241.1741671-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0251.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::16) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|DBBPR03MB6761:EE_
X-MS-Office365-Filtering-Correlation-Id: 34f8d1d0-17ca-4d38-12c9-08dab07d6ae0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mt/ulac9ApGfdPlEmGcSsCU68lwMT3NrwjpR6Yld5kN+u+jVZbr5CO2Jz/mafkPKOg0c+epdwa/jhLvOqCYmAXbziZQLq/t8McVBpyj0mk87sKgdvDSd6R+It3K5IDF45hsu4OpgHF2JBomH3myVx1weCfly7Zff9rOpP60NXKgmfxeLsk6rf4FJcLzC0fTmUxhs/UFDH8H0HS8IT4tssB9i+FwTZJLX3V3SVJ1g7mzvTK7ZGr7/Q1Jeo3WFe2Io+p3W9LwKFpCZFtCc0sjanKaOpTuatLPPaUxNY5WaXHjDnkVmJPm0sJpiVB42wOpKu7ei4/4ZBa6+YPX88DfUu9t0/PeXRGfnGB5bT23TzSk4Fosifp8jC9/iS63PmnO90/G/xCyw3Gig2MB09fGf7H0/I1PT6pgm25x3NfLyhIwqN/7XquuRxoF7tbzA1v77T0GvgM4r4CCFTVryGdaaRKPG+QGdsLh4m7kh7+76fPrGyqbvWPO4+EcfvZZsrZFEIXaCGJ1Mj9m/gxIYSiHIdfEsOS+gQQlI+q0XPH9o9HwViq6cUHww2dqtBeK6I3SenDIYSB5h1ioEomKDIGUwyj4JpnCaqZJd+eBTiXDJPbvEp7x2dMbZosk/SdVIwYXIofaQiBPuxI2K8/envSXi+/KE0jIm2OHr1PmfK2MMnO3nVpVjVmIXPRxi/O6MbEAZntVhcSSwGJVwPy7T3n2iIQluV2ejpJ/1kKf4JbXKvCODIWzyOH7SWqM++/eh/RlvrFreOXi7qPRbFaPuufwCQA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(396003)(39850400004)(376002)(346002)(451199015)(2906002)(5660300002)(7416002)(66946007)(66556008)(4326008)(110136005)(54906003)(8676002)(316002)(36756003)(478600001)(6666004)(6506007)(8936002)(41300700001)(6486002)(38350700002)(6512007)(83380400001)(26005)(44832011)(52116002)(66476007)(38100700002)(1076003)(186003)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?D5RShH1NvMCM870ktyi8RggFgxqlVWz65Rc0IVJMvAc/nPYPy/BERglrqVo/?=
 =?us-ascii?Q?hwspsHZDrDCx6ZGX3kPOOTcnCwJTpzmAavBg4gNIpsL5EGQCxqSJoZcZoHrS?=
 =?us-ascii?Q?+h9rmNNYuM7xCUskp3nOzaHRSCCX7UjoMkbfB1LJd6H3Eyirt0R7pZuNyj8D?=
 =?us-ascii?Q?l4Xt4yXkSqTWZVzu4ZlkyG2IJnpCKjpqobEsn8jtqW05o9PHFoU7RN2sdgR7?=
 =?us-ascii?Q?E2ntdXqUQgr820lEDdMq+qMh8zbcn5QvgVFAWGb90zDLtbe3qy33WPgci89g?=
 =?us-ascii?Q?ht2OsyMXlp6qFZvfsyBcFL6rpmRA69hpgl21JSg0IikkktsOZBOHYP60Qb5u?=
 =?us-ascii?Q?3lrmM0tvxWRjdCyh5gD74/0l64eLk4VQxmcesB/iUw51dXU+nuNz8tsHvf4N?=
 =?us-ascii?Q?CXWVJ1bZnLc45BA5sW4dbIAMIDYTP8VpFsrh+VQl8gBSDoHclvGMqeogznPc?=
 =?us-ascii?Q?EVkRhivlP5HwmL1BhaYexZLJsdBchOnCh6nkhR2TeOe0E5rd9PztYkQHl0Gc?=
 =?us-ascii?Q?NKWRMB+9CVQDkNYJncEbDLaAwAAosJZtBozShcpPyUpD4O3Vv7daHUMY/Gk8?=
 =?us-ascii?Q?GTpdzt7eyclPh+/dfPh3sIzMXxcWVpTw0ARXkB0l6JcXHA3Nt4HF/qVTgN6A?=
 =?us-ascii?Q?I0MpHftA0w1EW6FW5qgi0AqNnCdKhnxPgpKzG1VVUbnJXwrsGlSKsmmgnDMe?=
 =?us-ascii?Q?ELO5Zg/rF3pmNg0U4xb+QhF2/AkQjzYfI0uzXVQpn62TKo7xfd55md3z6XLH?=
 =?us-ascii?Q?vGDA+Exsi8PP1jtu6PXJ+HkimGckpaCBCYvHCoXaYSMs5iYVc88bfYzHtShC?=
 =?us-ascii?Q?RNUCy8OkvxPk7djdHf3Bfhl1WkJNVVT0gJbk631x2os6gBMeVz3gtVKElNyU?=
 =?us-ascii?Q?fn00SA23KcnDCwot8mtXhgGmmxg+jZXUBcu2geB00U5rQEo2zi5TkdVaPYGC?=
 =?us-ascii?Q?yCA/J2NeYfUG90CAIKa0pJZZfxwiRYos3Zmo4QOEo/kKWAidMYulgc32YMK9?=
 =?us-ascii?Q?3zgEYY5V7uTpFp9yCEoGv7MIG15S6f+lRXjmJRHstuaLvAssVfRoCorbdflf?=
 =?us-ascii?Q?pc3gtyyIiFkLAxtI2++Ghzegs4F3z64+HVP8xdQRwrbQRi0KPSn/aumleIa0?=
 =?us-ascii?Q?oYuIB1G3Vm98GchIRuFXCO9+6963D0/eShK8kUwCk2ivzPzDOjSs19qcTDov?=
 =?us-ascii?Q?45dvXiVlIxhSID6TTGSHVTmRo1mbvFYVfrvAJrOm76Q1A3yzYBEiXsGy6atf?=
 =?us-ascii?Q?dYEznGHOJW26enjAVY/RNRrqtrX2MMiD6yy5tbrdhn8wn6pRX8pVDVzs1kP9?=
 =?us-ascii?Q?V7dJ1XkM0YNC0WdKGpxfuttxF1tFVXIHltF5EsSnnM6Y4OdQYQ4rUJvzCG/A?=
 =?us-ascii?Q?yGd1b4fLdvCERVZhNmk+GNQZ+9F84e++7LEMjNYeTpW0/B2qnKncCioQaL3Z?=
 =?us-ascii?Q?Xx8LaYQ74hL2QQQH6hskbGqZtzoBr2y77kR9N9XvjuiiwY6WheHRSbFc0qdO?=
 =?us-ascii?Q?/9xVFNaGO4vcKg6cySXcaigLCN0oRqYQvQXAdhynlFCn+tXxvMYocrROzKqS?=
 =?us-ascii?Q?Xn/yifiEwSb1DSlrVOtrg9Ut7xHyrF/oh86aMru16kjqKswAeZu5Wsaw3wPC?=
 =?us-ascii?Q?BQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 34f8d1d0-17ca-4d38-12c9-08dab07d6ae0
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2022 20:23:13.9785
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V9RundkvJ42wK/qcrkNfj/hpk7n8CR4TXYwVOwLCL0BJ8LThBbulQAWp+JNGZruwoNbGSrPyDF32vFkY6M+IZw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR03MB6761
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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


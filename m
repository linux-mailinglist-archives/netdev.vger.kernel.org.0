Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1F755F114
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 00:32:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiF1WOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 18:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbiF1WO2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 18:14:28 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80074.outbound.protection.outlook.com [40.107.8.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDA334BA2;
        Tue, 28 Jun 2022 15:14:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iPnmcvqNrETsshstt+Gs57zEJDswvWmu2JiN8AgqAkjZbKSyJPBp7I0+S0SfwvRRp/vRHETHpkqibGrFBIS1ICuoSHkOrpjyhzD2m7GG1VEwfFxR54jhvKIuBjC51tsYJ9yczm6/9JVdqahRIPXnltElIdvJYuxPBSwOyZk+on4vIxqpb9WpWOoTEi1JZ9TkWOlSI5GnLjMlpHjSuHwVcei4uSBNxjrqVu8Lerm+HIh6ri+/3GMuSJKO3Ii9bwLV47bd+PVP3XirYcq6GuekKWDO9+QV3d6WIS9nOeLBPSI5lsnG1yAV376K/VzapaysNchnoTnd5D0MrxDURMeqig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oNBB+gwuLH9EjBRC8EkMePDCkfdtxLDNgHDR4IM0L5M=;
 b=culEfWa2VFHBxww05uf8oa8biLZc9maRQIWlAMC/phMA6uqstfq4Q6lmIQBhjyFOU7f0GaWwcrTU3nAA8jHMXNWc/w8Kh9tbVLwpBakhbxsyob+Ios6Gai2yCUDjTbsJ6rbIqAxZcd/UiyKtpf92tSZdmRNgU2Iji25ibNClSpt1axSxCU7e02bZQfeMe9ZMt451+/dkUtiNnsIcPB2CAJy9BHBTBE/0pUV/EKI3jnj1bv6ElYA8OD5YAT2uH6+5KPtIQpwTk5eZ9Fz/AjvKmYmgDC26cwh1YrpLbLkzz6SfVW3qUIXV0VHmwaO44ui28NyhWGbnAN1/VaIynl/FPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oNBB+gwuLH9EjBRC8EkMePDCkfdtxLDNgHDR4IM0L5M=;
 b=JfAvV1dF/2Ja8T6QkO5tk3G5SwLeDc+jGeSdeFqiD+591mdq4+30M624shh0gDpn+tqyg4ZPPIFG+E5Jhni6CLqrixEzIIxBXspD/Nas77LkaNJ5B/o9yb71ofaw7lFD1AhXRUAPC/FrTrVCEV82Bj9StfqnWfJSAZc1Ov9lAnSfxU5BApmEwX7MVgc2GRFfStYuMso6VIYIYDBdVpnIJScPo1IgAnRBqV+lpakCJOgtuId+MFX3si/ekso7JqiyGTtGnIaU9NqxgFixldlxhFS8onhFivnvoJ+ikWC9rZdjrs0fzsAi0PedEFfGmocT/HomEQFQ9THVlFbfqmSySA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by AS8PR03MB7399.eurprd03.prod.outlook.com (2603:10a6:20b:2e2::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Tue, 28 Jun
 2022 22:14:24 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::757e:b75f:3449:45b1%6]) with mapi id 15.20.5373.018; Tue, 28 Jun 2022
 22:14:24 +0000
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
Subject: [PATCH net-next v2 03/35] dt-bindings: net: fman: Add additional interface properties
Date:   Tue, 28 Jun 2022 18:13:32 -0400
Message-Id: <20220628221404.1444200-4-sean.anderson@seco.com>
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
X-MS-Office365-Filtering-Correlation-Id: 3227cfc8-f545-4e48-d72a-08da59538ec4
X-MS-TrafficTypeDiagnostic: AS8PR03MB7399:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OKOtJAsce2KU+Y37ei39130FhmwDWIv+A7xKvP7qMsLLn66VLOvydqWosEXKT7PGVTsuuze4EKtPvdjcnPM7QmfUk1uZVoRFTyir9oXNNdVyr/djwm+zu6jhI6viAZY67oM9viT9dRjF177JA/XtjwQg7eqbPvd0xIFmXd1sOSG3pOZlWPZ4juw09svKPme8eCTS61eRDx7D4EKu+4Dj1RYTGoJ/WldmActXyamQiq3IUTVUh4LaXKqlZ6Fff7ad/izsg2lNRGVM2NPRkiG1j4s51g8PgjgURSJuvNIG6iZRDrh4SE1MWVTvSJhSD6FH9c/fYdUNVsk/j3G5fNQ0CgE/qJOKjdFDrjd7wMvPERue0hCtK7hPTIT3D6CiNJDlzyGwbX6zMaQMv7eeS1StTBVfEbCrWv6tLdJQ0mYTZW6V2EFuOE9bDHhtTHJsbdUZVOlYwvu+ZJgkI7RCcJGQaY9Ssew9x/0bjxv8SD0K/UWXR+mFziyBnHWGP6eDUGRkqltkty8fuU9niBPuxN//kMmCJ5tKg83GB4YPeCqE2BRICaUE1riq05bEpzdiVtpkwudvdm353+WVt3LcvHp+SEqPf90K45ai7NrEI6y8rqO+t9iw0WM8fpgYuHPVt8f6KO6G+Uv5EinHgv+B63Frz/Y+X/Mu8/HoJ1slg4lV65A0lT6tO2CvtgnbQo/vT1YNORBfTxJ2Yhqj3/TxskQY5IV5KIRdevAZ3PZyWlsi6qJ5uZs4VSMh7TmGxhMYPCBE9VMLnABTuzLfrSLgxewWYArjolZTgRB9q07uDcBGXqc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(136003)(396003)(39850400004)(346002)(366004)(38100700002)(5660300002)(7416002)(44832011)(6512007)(6666004)(186003)(38350700002)(1076003)(83380400001)(86362001)(2906002)(66476007)(8936002)(6486002)(4326008)(41300700001)(8676002)(26005)(52116002)(36756003)(478600001)(66946007)(2616005)(6506007)(316002)(54906003)(66556008)(110136005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/u4+5wr1NlDsyNJMH65UBkqROZmbKtIc52cW21ByLmkVi5iuooQto8zSjpfi?=
 =?us-ascii?Q?wkl5OXOicGoi6/+c1eCcg7JFAW+7gMiAH0ZnxUfnunIDsGc4BuHzqPCB79ON?=
 =?us-ascii?Q?M0xMuVvVpN3RI/ahM7aEyDX2FZy8hGmGXXpa80DE4z9C1m0RAKniHyvX/4eH?=
 =?us-ascii?Q?e+ikD4G4fW3KNuQG2bPiC2U1yS/C8J1dmEmAXTdyQtBl4f2/4QF8ynyatbF3?=
 =?us-ascii?Q?3W6SG0dL9PavIAQV8mDS3lGTA/0NmDQF5p5yhqqc6kE7cbQLFtOxD7xQ2Xug?=
 =?us-ascii?Q?LMy3BSuVt8rNQcQsrGVro1LiqJnH8jJDGklZIM+SeuckNmV7pNJAmY61XmW3?=
 =?us-ascii?Q?lvg2VpguDNR66puqxTSgxnuonNlRJG7QG/aWq7Gdun/v1pRpUfCMl5SCxjqc?=
 =?us-ascii?Q?2xD1Nopx81Y4K0AU2m4oYLLMT0+XpDMwSifUqVRdGjsQaHWx54PTA5NizRCw?=
 =?us-ascii?Q?MWSdG/Hj/WyEMUO6dBk80Jj/sumeB20cugkPoCYAQCex84WX8/sRMST3rAe6?=
 =?us-ascii?Q?AqeTt23c5i3iY40Fdv47WMNxM7bH8bg1SPuBo2mZPKG/cwoy2sCca6o4jkmG?=
 =?us-ascii?Q?JGcH3SMx18ACZrtxwF4u/yihcwdCZNjSNJpyk8kIlikpmjZ6salEUBCRtj2p?=
 =?us-ascii?Q?B4c9u43YU97/OH5yJV0esQHjwk5JbV+m46bnCBDeWGRjdgeBwjngVNlb4Lkr?=
 =?us-ascii?Q?uGpSdmmOCu6ahEf7yHe57//eU/TGFpREgrTfJgJrwRXIUMbTmwQaNKEqCAUO?=
 =?us-ascii?Q?DARTCs+9E/UYLLFMkohn0roBJ1k+OJhlS5dtDSwUYlb+SenVOCy1l4kGC/D1?=
 =?us-ascii?Q?heOVQh+fplhskuRp2AdVFfgiS40aIvZiMJ1c9mri+cZqzud2U0zns6gZhL7k?=
 =?us-ascii?Q?dg9dQ4LF3hl4O5snFH1iVCoYtdedzowYlrUWJWZ5f8muxhd4MuwfuOXVSFMu?=
 =?us-ascii?Q?eM1IbAyCp7vvEzY3gAPSOVZRIFgIGBqWvpdwKQuLU2MUiMR+JqBJDa0ZlMi/?=
 =?us-ascii?Q?jD7WcQUrC3lNKFH3P+WImnZQc3whKenbp0Qu0AtncI9P/T6j+gQ/Kf6dADgC?=
 =?us-ascii?Q?jmd45V4i4WkkpoX+KWcw1HH5Vc7udE+Nh2AD0FPxMFgNhH/4h7vRyoWSMkkZ?=
 =?us-ascii?Q?E/z5C3lfBF+yNd8UGXllIaBboHNg2mSSszlerJOeQ4PDNz8qCtZTjLZqggtR?=
 =?us-ascii?Q?3mBM/G39nbQnK9F7D6NRhjrC5Yyht3P7BBiLmj8zTumWoBn5c1vntxVE9EWQ?=
 =?us-ascii?Q?1G2M5000hPcPkge282YLfuX/1nqKD1zw8hQ24wLC3Sllxw3RTE+4aakvHS21?=
 =?us-ascii?Q?UJgmKTrxDuuQl+9ZQkYhBAvC2oHCVZtEKn9w0EohWybww1uS9NpPfFxIpGnw?=
 =?us-ascii?Q?F8g3ZBuD1YeXVZzDM3jtakWm+EZHWoyY9DDe4TLd8TfpkolLZ3EpxfPZxq8L?=
 =?us-ascii?Q?mIqz2ap8isBS4PKR0pMuKnc4HfjGdC7MKWZdCpG81eRrdS0BXI/b4nsQArKP?=
 =?us-ascii?Q?D8ugXJEa6ENCpv72KzEq7YiLdLKfvPU1hrXsU7AV7FM5UZVgMQ1EjuxoItc2?=
 =?us-ascii?Q?CAzjiFAs+aaihbgO0kXRwWa5zdWOFtgMkLghK+ajrrS4fIrEukHu3MgXb4B5?=
 =?us-ascii?Q?qQ=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3227cfc8-f545-4e48-d72a-08da59538ec4
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jun 2022 22:14:24.0800
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: s+S8R0JwA6VofSPTyfjfYDj+riEnyiojUAgNOPwHwzWV3y4Bhv12WCS0DvK7Pn1shdTHyEbLEIKg0SPtvp9NuQ==
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
well. The XFI (and 1GBase-KR) PCS/PMA is a c45 "phy" which sits on the
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

mEMACs (across all SoCs) support the following protocols:

- MII
- RGMII
- SGMII, 1000Base-X, and 1000Base-KX
- 2500Base-X (aka 2.5G SGMII)
- QSGMII
- 10GBase-R (aka XFI) and 10GBase-KR
- XAUI and HiGig

Each line documents a set of orthogonal protocols (e.g. XAUI is
supported if and only if HiGig is supported). Additionally,

- XAUI implies support for 10GBase-R
- 10GBase-R is supported if and only if RGMII is not supported
- 2500Base-X implies support for 1000Base-X
- MII implies support for RGMII

To switch between different protocols, we must reconfigure the SerDes.
This is done by using the standard phys property. We can also use it to
validate whether different protocols are supported (e.g. using
phy_validate). This will work for serial protocols, but not RGMII or
MII. Additionally, we still need to be compatible when there is no
SerDes.

While we can detect 10G support by examining the port speed (as set by
fsl,fman-10g-port), we cannot determine support for any of the other
protocols based on the existing binding. In fact, the binding works
against us in some respects, because pcsphy-handle is required even if
there is no possible PCS/PMA for that MAC. To allow for backwards-
compatibility, we use a boolean-style property for RGMII (instead of
presence/absence-style). When the property for RGMII is missing, we will
assume that it is supported. The exception is MII, since no existing
device trees use it (as far as I could tell).

Unfortunately, QSGMII support will be broken for old device trees. There
is nothing we can do about this because of the PCS/PMA situation (as
described above).

Signed-off-by: Sean Anderson <sean.anderson@seco.com>
---

Changes in v2:
- Better document how we select which PCS to use in the default case

 .../bindings/net/fsl,fman-dtsec.yaml          | 52 +++++++++++++++++--
 .../devicetree/bindings/net/fsl-fman.txt      |  5 +-
 2 files changed, 51 insertions(+), 6 deletions(-)

diff --git a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
index 809df1589f20..ecb772258164 100644
--- a/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fman-dtsec.yaml
@@ -85,9 +85,41 @@ properties:
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
+    description: |
+      A reference to the various PCSs (typically found on the SerDes). If
+      pcs-names is absent, and phy-connection-type is "xgmii", then the first
+      reference will be assumed to be for "xfi". Otherwise, if pcs-names is
+      absent, then the first reference will be assumed to be for "sgmii".
+
+  pcs-names:
+    $ref: /schemas/types.yaml#/definitions/string-array
+    minItems: 1
+    maxItems: 3
+    contains:
+      enum:
+        - sgmii
+        - qsgmii
+        - xfi
+    description: The type of each PCS in pcsphy-handle.
+
+  rgmii:
+    enum: [0, 1]
+    description: 1 indicates RGMII is supported, and 0 indicates it is not.
+
+  mii:
+    description: If present, indicates that MII is supported.
 
   tbi-handle:
     $ref: /schemas/types.yaml#/definitions/phandle
@@ -100,6 +132,10 @@ required:
   - fsl,fman-ports
   - ptp-timer
 
+dependencies:
+  pcs-names: [pcsphy-handle]
+  mii: [rgmii]
+
 allOf:
   - $ref: "ethernet-controller.yaml#"
   - if:
@@ -117,7 +153,11 @@ allOf:
             const: fsl,fman-memac
     then:
       required:
-        - pcsphy-handle
+        - rgmii
+    else:
+      properties:
+        rgmii: false
+        mii: false
 
 unevaluatedProperties: false
 
@@ -138,7 +178,11 @@ examples:
             reg = <0xe8000 0x1000>;
             fsl,fman-ports = <&fman0_rx_0x0c &fman0_tx_0x2c>;
             ptp-timer = <&ptp_timer0>;
-            pcsphy-handle = <&pcsphy4>;
+            pcsphy-handle = <&pcsphy4>, <&qsgmiib_pcs1>;
+            pcs-names = "sgmii", "qsgmii";
+            rgmii = <0>;
             phy-handle = <&sgmii_phy1>;
             phy-connection-type = "sgmii";
+            phys = <&serdes1 1>;
+            phy-names = "serdes";
     };
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


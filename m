Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A235EB0CA
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:04:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230269AbiIZTED (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:04:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiIZTDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:03:42 -0400
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2042.outbound.protection.outlook.com [40.107.21.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7DEF915C2;
        Mon, 26 Sep 2022 12:03:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H1gGP2T4TDhyU7ECNO2UZoxxIUNy46/VmyTzepFwFFmEZdItGZe4/zvkA+5OB9+LOkiuBk6O9B9CL3dOkMbBPZ0wIE15VTNR+nrCSp5D2ZDOZU4coxOHOTyEvs5kstpQhKvKaJ1Sp5tnk9OwMqFJ0OKMLMxMC6RblnLUQUQI/g3l5nO/yYDDaWJi7OSJsUlgNuBih9pl9GhbYMgq8NjhYbmlyIwG8wrcof1zkdEQloK+rmvuTTFc4U5yYwt6yc4rP5+WNaMNFF6/cDtUsiLx7gwU1WTBUgpePKbxOql6W80p1Q1h/3xXg0Kg6YMLs32mjaMNHExmjA5DQjwom1El7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tjABrl/nqtklpdfa6OE0UzmntYkgGRDZDSkLSpYm2PA=;
 b=M2VeJnwnP8ntjPohVS4S3E2IvRb1RgN2Shb3P6zB6BSvJKRNyCziDIGSUUcOjfca5f9lGnRAFRlwINmWL6Tl4+7pIusy4utK9THFRBS9eA1rkG16WnAPGwwUjx/kSmvUQNO0OszrfGixNfhK1LcHjXPMUwJLQbz6sS1hoTEHmWm4t12D9cktzInaSLd/VS/1N43p5y5hPvrS3OPgoGo8n63mYkZtZwnYxjg33m19hVe2OrGb+oipZKeMZmKTqiF1xAPc2j4Gv7MmXWR26B8Hgd/Q2ktDviudKDuRS25I3ogRq/LvsWC8q8qeltN07/dT1dEFF4brIfMbrdYyPvJzmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=seco.com; dmarc=pass action=none header.from=seco.com;
 dkim=pass header.d=seco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=seco.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tjABrl/nqtklpdfa6OE0UzmntYkgGRDZDSkLSpYm2PA=;
 b=cysxedJDmU2D/NyJ3ak9xuPpkbUqAEzcGBhmuIYF2gl6Qwtv5sY5u9hO0E/DdwQfD3DnhCi+TaSBhwaR4xy4AzFNanbkd7846bUl3WQ7uXnpsULKCrLKkcN4Q2fGxKvmHgJ7oo3pd+8FOuhK9HjYiQjmtMuX94zi6fvMMXuhCAsFse4vAVO8wqr/0sIigG6bQBWcYpjSZi07jKBml3BdjajcXJplHna82g4wK0ieFdZxoqjt8/nA7PXyCVvDD9stlrKn9cEEaTebp8WRB6bbqGkFTPXx9CbgP0lOuXU+R4VdzLbEQbP4EWuiyKmiLLDhK8IhxungpgGpoYvNMk/EbA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=seco.com;
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com (2603:10a6:10:7d::22)
 by PAWPR03MB9246.eurprd03.prod.outlook.com (2603:10a6:102:342::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.25; Mon, 26 Sep
 2022 19:03:37 +0000
Received: from DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d]) by DB7PR03MB4972.eurprd03.prod.outlook.com
 ([fe80::204a:de22:b651:f86d%6]) with mapi id 15.20.5654.014; Mon, 26 Sep 2022
 19:03:37 +0000
From:   Sean Anderson <sean.anderson@seco.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        Camelia Alexandra Groza <camelia.groza@nxp.com>,
        netdev@vger.kernel.org
Cc:     Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@armlinux.org.uk>,
        "linuxppc-dev @ lists . ozlabs . org" <linuxppc-dev@lists.ozlabs.org>,
        Sean Anderson <sean.anderson@seco.com>,
        Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next v5 3/9] dt-bindings: net: fman: Add additional interface properties
Date:   Mon, 26 Sep 2022 15:03:15 -0400
Message-Id: <20220926190322.2889342-4-sean.anderson@seco.com>
X-Mailer: git-send-email 2.35.1.1320.gc452695387.dirty
In-Reply-To: <20220926190322.2889342-1-sean.anderson@seco.com>
References: <20220926190322.2889342-1-sean.anderson@seco.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BL0PR1501CA0019.namprd15.prod.outlook.com
 (2603:10b6:207:17::32) To DB7PR03MB4972.eurprd03.prod.outlook.com
 (2603:10a6:10:7d::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB7PR03MB4972:EE_|PAWPR03MB9246:EE_
X-MS-Office365-Filtering-Correlation-Id: e25bbad9-9d47-4ca5-e6ef-08da9ff1d148
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ISUvsdvg3toldEf6Wacdu4TqbyB7iv6SrrqJhpdSlwHT4pUFoaoCMNoelpaz35erck4BCVepi/akJaIMK++nGs1WMryny3aXiqJwg3GGt+K7Hskh1n73Rjtfw+DL4YnYZ7EChak66cuKh7YR3Ysp+LIQqSq5tFXeMDKy/Le4PmWIpPSBxFosW8nQJCHE5PQnxC0rsHRfSSTnlU+CfK4E7yjGU4qB866dMkfsCNtr1gIFLWkVUeOTEoVYauGOCApFe3JEukpwLrj+VN4k8pIdqM+KWz5PJAvubA781mplBCUyG5aApnl2kAIV6RqvH7ddF7nW4js2neJFmrb2Iov3bRtx0cLP8qM01EnwyfJWSSgGgt5QXqDiK/pbQqEv29yPCKYhc/ZtAkP9QlOdyFiFff0BemChDEFkubv+TmWuKIcPzJAnRUdFpfVHYW1CIrENgT4IE9DgMUcEEDJ4pKRAC0QcvHjFmIhjSkhTOfx8rS5GzDW44/+Tl9qdjGwhUYNpVE6dA3URrncXy8jshg2BLX9ACPLCFARUiAGtMebl1eSYqEUJZBQ+nPipWVHleu1gt3HvpnwfBDmDG2DUpVAYSwkssrFsZl3Ij3OjTOPdzjQA8BxP1+wdPjEJUUlqKtlgB0OTWPScn3c1fwv++UBltwooCqL9kwJUOe4weICIBxZoWGJ4Ozh1QlW7g6g/3ShxFEEw9v7TDNPBPhlmysAiQQWz5JO18jU1RJ9MayDHUUa2LFwlB+GR8Qhl8e9omiMEuJhegCdgdPOJ5RWl2KIE/A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB7PR03MB4972.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(39850400004)(346002)(451199015)(36756003)(86362001)(66946007)(66476007)(66556008)(6486002)(110136005)(54906003)(4326008)(316002)(478600001)(38350700002)(38100700002)(41300700001)(6666004)(8676002)(5660300002)(7416002)(44832011)(6512007)(26005)(2616005)(2906002)(1076003)(186003)(83380400001)(8936002)(6506007)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?erO9tN1G9lehaKifhNxmXUnCOOBT8CXdciUuQHJPnKOz+2B1pa4zaZWJjHXb?=
 =?us-ascii?Q?2Q13wHLny/jbwu4Qk8OO508tl7J3ef9PM12nzupjv7M6yAtDbQQHUIdAY/9e?=
 =?us-ascii?Q?SHwOGr2Kh8nJ44/SKmp1cAG9M00qQx3UzhUBgQ5NgqI/7oeJRvKjYKzjCBol?=
 =?us-ascii?Q?sjmv3NPey3d6aZWoOxFsyWVDredzI46qgh3COhop10sp0qmZBJWkH4QMsU+A?=
 =?us-ascii?Q?mJR6+y+CjnKhEOlb8Oo57djQTdUx6wde7EFonwIOczpiw68mWAaXCMKBed6S?=
 =?us-ascii?Q?0fW6xvG7pfycw2P7SglrfG6q4dxnqSSl4PJ4dS+G663Tmwp0n+eJo5cFDhtF?=
 =?us-ascii?Q?1062JFXDRW38x0D2Jb89MVMfngJtNdtd8DdncJUXFLTLFU+Up9/FUxfmAU8/?=
 =?us-ascii?Q?BI+jLqWUHn30ZZldn7PcLeSEJzwk435NICY0EpqajDTUom1AJEpewv8nA4+S?=
 =?us-ascii?Q?CEc6akbX9a4ACWzPYnuMCTqyomaTbbz+VisMe18VOK0PO5ghysr1PVEuBbBL?=
 =?us-ascii?Q?bp+u4UBPwMjqmwaXfNqqKh2apnt+3symIBVqLpQxAh0beFIV8J1vomzwlqz1?=
 =?us-ascii?Q?xyIaiwfOs4wDb8CdLg827sy+2d+59kV8w9eNi2/lBNvB9CEJ/UQwRGF4btxL?=
 =?us-ascii?Q?AW97v1mcxQPFGUOYiSYuBfHWuskrh+Ydsp3eTsrNH3IIJ8CqisY+qQaVM7EJ?=
 =?us-ascii?Q?GYBmTb+0WuTwMncWtwpg6LPKie+Z7Qdf0AYF93O4o5Ecihsyymzqwthc+m7n?=
 =?us-ascii?Q?rLBPRvhR6gIKNijyxFwklo+AFXT0Dy156G9T3cQaLP8vWjYHB6g2XQMS7L2O?=
 =?us-ascii?Q?14QjLHmwlpru7DylfTZEkh4RPwGQ5M5XgjSKraGBTlnyfhWpsL8zqcKzsUUL?=
 =?us-ascii?Q?T4KNrXS5K9mlNXsnBkpDiZLvq2ZEeSjiQlDx7772/GNJsodUVrF7cYoWQb98?=
 =?us-ascii?Q?VywjQh3H6IpbErlyKVMrPFrq912sBzq+wguVUPB4FXgYryuZJueDWWQmeaZ8?=
 =?us-ascii?Q?2kK8u/X+JAVlhQhvNOL0crsBTh8z0mAMTiKuvZ2RryEVDOXmRZUKqQ1qPwuP?=
 =?us-ascii?Q?d28uPUkIuyuwH5dd7MF7lUoCJvCUdLYRcT7gJRNN3/0BYQWJpB2CjEpbNfbM?=
 =?us-ascii?Q?enUbYKRnqocMhbCj1UvAEWB6CwrGAz2yNCZyjPnz9wMN9KoCtlOGbjUPssBw?=
 =?us-ascii?Q?Kh3TS7FoVWo4ejKUZHLwzSn05PVgX49ScjTl3cpYIqjfKBr0EFomeNstcmgI?=
 =?us-ascii?Q?qoR1l4wB5JH7ncIRyKSuburM4588y4PZDX/5xPvrevr60AkvgvDl5j1LGnI6?=
 =?us-ascii?Q?E6U2GKCxOgDCc5fhqlQBJUILnEfiX+CPM6n98kmVchVjGOH/2g5houa0alX4?=
 =?us-ascii?Q?5YubQH3lYl3bKtY7ErksjxPUHipBo76uCvOp1R/C8Ynto8I0JaR0AfI0dHe0?=
 =?us-ascii?Q?Cnhid0uYjPu33HhcGn8/coIkpd3lVfccTVr75s/02+Cwknvt4Ko9+I9Ew6h7?=
 =?us-ascii?Q?ILjN42VOW28VwPOIYx9SjUR0ubfQI4A0u7vamwfDMmEcRnn33QGd3x1jw8V4?=
 =?us-ascii?Q?1dZ8qD1fuuAdT9dHDSwJzO4G3ubSjYWd4bhzNVoq+e7a++a+bsciyFJaL86v?=
 =?us-ascii?Q?Og=3D=3D?=
X-OriginatorOrg: seco.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e25bbad9-9d47-4ca5-e6ef-08da9ff1d148
X-MS-Exchange-CrossTenant-AuthSource: DB7PR03MB4972.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Sep 2022 19:03:37.5059
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bebe97c3-6438-442e-ade3-ff17aa50e733
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Nn1s6En8qzhRk64oNnXoSLaj/yARp7bIpOri86mL/u4r0Q4nH7siIHPMCV18LjTqIb0IiLajAcZBk2DOxkhu+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR03MB9246
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


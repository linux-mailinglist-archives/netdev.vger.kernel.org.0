Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2AAA648CE6
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbiLJDcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:32:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbiLJDbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:31:34 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2091.outbound.protection.outlook.com [40.107.223.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399E98BD0E;
        Fri,  9 Dec 2022 19:31:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F/p6fTO7OIGpIe2iA4pbInJ+zs5VyRG/oLEJH7h8SMnWY42K9CVQu764WLtJ0CRimVHwxM17kFoX1h9DyMBE0LX7bphu5CetxS1XF+mJUfc4EvJfVv99EfmGgbKqbfYYJXhUgU8s1SDnlS8jGIalFKfOqwa++KYijkE0SX8nt7a4b3oaXBSXjnvgP68nImCfhf8QlqFrrV07JMfqA1DLXoiNHkSO5kDWay000m/aTiT5U4uABO1FntS08H2qEsrPol+xpnfU/doyNPaVKCi50vjKSyXKCfIRE2yRykobXiVkIaaWUjgpdhfFFLUM4EciXrD0oKk+UzLiEnI7iQMJ7g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q5hNntqGzN9rH0fjC8DcpkCZvtk9WSt9ek01aV71mT8=;
 b=VPtVqYU8NjqDiN9JaCgVE7hdqH+gpnTxuWxG2tEuolcTmfv7r42MFqcD4es3UaVJL/QS8BMIAM7ATwqRc78hfYS+7awRgOVH8r33rZYK2FKG6tUD4/NcfbY9+mN0H+Rp7kgK6Y5/d1QdOxw9+cKpqHC4EZYlVeR3oIQN6KloniqhevoBpCkekVYXCzvD6YFE4U8xZ3AUt2ZA4msxq5b0yHXzeR1k2CZ+h8KZsT3c5HDRHRMW5uaYvkJ/CufFlIh7cFZ/LV0l1fKpgMizOF4mnsvLjwXl/jhDYeCgGYInv0KbyMGA9e0ehDdlvVS9/xBLlhtgIxgXF11rsHe5mf1oaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Q5hNntqGzN9rH0fjC8DcpkCZvtk9WSt9ek01aV71mT8=;
 b=hJFXO1NJSmL7Vv9kia0NubWX5RhQHAWIenbtfrFuZ1UUNGppxQUZr2nYmhFJyMzNSIgFUO9KjrTRoi11z76iPVCLpic8afi4V9AB5MRKzloxA8MQwDFzgKxUE33GpBduCm6nWqjx+gE5hiLLUTTXzoqQTTgtMqUMogr7ANiLFOY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by SA2PR10MB4779.namprd10.prod.outlook.com
 (2603:10b6:806:11f::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 03:31:06 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 03:31:06 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-renesas-soc@vger.kernel.org,
        linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Cc:     John Crispin <john@phrozen.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Marek Vasut <marex@denx.de>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        George McCollister <george.mccollister@gmail.com>,
        Rob Herring <robh@kernel.org>
Subject: [PATCH v5 net-next 08/10] dt-bindings: net: add generic ethernet-switch
Date:   Fri,  9 Dec 2022 19:30:31 -0800
Message-Id: <20221210033033.662553-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221210033033.662553-1-colin.foster@in-advantage.com>
References: <20221210033033.662553-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR13CA0002.namprd13.prod.outlook.com
 (2603:10b6:a03:180::15) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|SA2PR10MB4779:EE_
X-MS-Office365-Filtering-Correlation-Id: fcb39849-5549-4407-0e7f-08dada5ef8ec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EIxvGSBe0xtBdKNA7ZI26EejtJtHTJWSUqmco/0Dfn9VqGN14JXaHM/4fKXFFHCdRHv1VWGxYC5kZ7ObFgNU/T8D04WP54mUJil/Wl/zs+ZbDNdutZBFMMvLS3XIP8sLE5lfXrzCfF/VsKXqi65rSKb9w5foWmiukmwbYhI/XGgbKCEoQtY7wOULxBRPj+W/o4Umd7MAKX4+sNLgST48mbdnBwkbm7HVClZwQlAmSOcQb7ILeUNZG6E3tSvstU90CD9L5IznxEmF7O+YX4Hh4uoBKoBEyk1912TGROP5tiBc5FksmnsVgCOmjIQJK7ZjU6MSdlyRfjQ+gUKPk8QMZSfreAYZ3Co0H8hUw5mKKSQ+3/P4+LFORyt3dXOMmTuAm1RJhMf3oWs9nbPQfoz9oWcHaS6zCVOIQJHEmq/jDcYy1zmrhNJJQ5PaXyCOctPzf0qOtNUNcPro3D51Tgugtx59dJLrEEyk3QmgSs+v6cjRrFKGk8mT7u22jWBE6BW1L1oUZWRjcMCpreAzZ8RQA7x1GXv+nZKhZI13WOtg/Dc97gK2H2AgzekkZz4oUOO/MK5fp8/hB+V446ecEZx0fEOA1E3W2FQxsC1K1nqoxXBKSvbcoznqWvh527UJS/0+3GWed0pj7r4gZ59WjaPmQHG/lp97lJWFmJUgMC24V6NtlapcMRlYLLcNaQECvEWFSooiSGTx0MUYMh6L4gNO0ymj232xMzLWaVt6Tl6k3Grv7jdYuFGBstVUaV4mYM9a
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(136003)(366004)(376002)(346002)(396003)(451199015)(6486002)(966005)(478600001)(52116002)(2906002)(6506007)(6666004)(86362001)(36756003)(6512007)(26005)(44832011)(186003)(7406005)(7416002)(8936002)(5660300002)(38100700002)(1076003)(38350700002)(2616005)(4326008)(41300700001)(83380400001)(54906003)(66476007)(66556008)(8676002)(66946007)(316002)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?YL1xNeTLduoFr5UQyGviGC29Smd/6HacrWuUPdMK9mpNtrGXgTWuAl34ev6P?=
 =?us-ascii?Q?NxbB9DjM5rzxpYB/HsZEXGDDklIerAlCBGmJxXJ0eFK/Dmwr0OSrw5dX02d2?=
 =?us-ascii?Q?TvND7jPddA2Rm8PBoWK/5tNRJvNDjNGacvWye3vOY0s4bR5X+CShDpO2ET7Q?=
 =?us-ascii?Q?rp+HToHemhcs/Y9e2oF+LQIkEaeECQ0Nm83hsOuCp8cZ5S3lg5wxrIOvQ9++?=
 =?us-ascii?Q?P1O6GTwGOCv3ajJLnm8j1weoTHS5kCLx8C7ymCPSR9jBJrtYXs3fpXc3VFZf?=
 =?us-ascii?Q?YzmjNYPNLIrGLe/Tu63qNqOXZzbZftD9TcSrKHLq2TB47aoFUZaiC3Tb/f5Y?=
 =?us-ascii?Q?QJ+FPAFD1A5ZIbzUcPsVXWFhMkOmGj1FPbpGS2IO3X2Cc4sk++cGdxvRUpGT?=
 =?us-ascii?Q?3wELsKYU35eFTcBEdl7xSA8fKUcQZOHpvqVzIU+nkSECEy73JdkVZEeZy+Cs?=
 =?us-ascii?Q?l1Q0LOntwlRabVZ3i2WjKjzM3qgM8y+/I/0vbnRalb3KlUnu2W1ReMBpUBpB?=
 =?us-ascii?Q?lI6Ky34cP2g4BoW9fZiRKw4CPoVDgSFEIpqnG/KlTtezkkijapykRPY+7HfS?=
 =?us-ascii?Q?gv7Cs0JjGj2IyBEgwVuMeIHi8PKCHSscE9w3eeaaQk6NJIvBHg1xTaW1Q/sS?=
 =?us-ascii?Q?PBomC6DYD+wllOKLCVGlbLqUuffyKNVio+PAbZODqwEXtHZLfySbaK9L65wX?=
 =?us-ascii?Q?v9fZe66TDR49658r2BaFmjrT/5kqm9Fk2BWa2SQI+yyFeeIOAFo1VAory2ZW?=
 =?us-ascii?Q?X9KgBS11bGTU70aez+M+xypGDpZDyENfARgLghJd7bENQbZ1bv2Lxuz/tuK1?=
 =?us-ascii?Q?Y/17Qg1VKuVdGpXRbUHpAP44vnJ5UFD2xebACQ29KnNFp7YOLuvD62psPkTQ?=
 =?us-ascii?Q?jnPUbtMSSFcoc6hurWsYRba6ujENc7y2hVf1pYFcYDtfwp8O7dpLDH7MslY/?=
 =?us-ascii?Q?IqYcqWH0jLsuXFhJ6iXo1CA/ydibklroFtNBNI2P/COeH33h32mvs6g2MPs2?=
 =?us-ascii?Q?gAPvoqb9Xp+vgkowt5w/kQQlldgzxo5pVL9/SlB8BM1BynaOhT9mtRTKF8DS?=
 =?us-ascii?Q?6sVV+HC2wv3KeXWaHkr+vkafwQbwZZ0B6t8ftOi7eHqCbwf2w35r7Ylztuw2?=
 =?us-ascii?Q?zniEw5KQZMbmr3uJUdIIcFpS1iKdNruhsyJhNziZU4V0dknQcSlMWeMdTTYN?=
 =?us-ascii?Q?n0MjFsnEmDBVo1aU8cYMsSlR33dyDY73GgoA5NvllogvuI/IEkkOR9+My69q?=
 =?us-ascii?Q?qahpMuYZFJpQNQmyK5oVbC+4cK+nZM4M9pSLIzGn7SLFjbFSku/UB3T5ixsw?=
 =?us-ascii?Q?mATukPoXWD+dI9MV6uSpbh5599+Thdxw002ZfeejCZ/fXFKJ05HbNcSPrRmV?=
 =?us-ascii?Q?BxRce54CLY5wGhbulG+BcahzFon9pSBbb3z06cAcaq3I8qzQ9eRF2MLdxJRe?=
 =?us-ascii?Q?jbIyYLaP7ZjFbxFdyYGqSbJH07YVRE1G2B9nX9N6BU2Klv5kthhDCeqXk4l1?=
 =?us-ascii?Q?JnxtTjtqc9hAyxdtdE83dFs4UJGRPh6i25KkGgI5tTFWwThaZXCB26wWT8tn?=
 =?us-ascii?Q?KmsRGYkAlItcMAB/YxO+gmqVt0G6rjVFos8kPR3OQjf++1cLGzqk5LroFlt1?=
 =?us-ascii?Q?j3xf5dZ5WKCMkCkIYWCtG6c=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcb39849-5549-4407-0e7f-08dada5ef8ec
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 03:31:06.6065
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h/VWv1x0QMaJ1tMyH5sP1AnCbxCSKjT0fJvjxTsFCo4e6DO+1mNuAEkIQzAkSXke6O9S7FR3F49Eb076ol9VUqjv9MErva9WIUE14mtJ/DE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4779
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa.yaml bindings had references that can apply to non-dsa switches. To
prevent duplication of this information, keep the dsa-specific information
inside dsa.yaml and move the remaining generic information to the newly
created ethernet-switch.yaml.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v4 -> v5
  * Add Rob Reviewed tag
  * Remove "^(ethernet-)?switch(@.*)?$" from dsa.yaml in this patch, instead
    of dt-bindings: net: dsa: allow additional ethernet-port properties
  * Change Vivien to Vladimir to sync with MAINTAINERS
  * Remove quotes around ref: /schemas/net/ethernet-switch.yaml#

v3 -> v4
  * Update ethernet-ports and ethernet-port nodes to match what the new
    dsa.yaml has. Namely:
      "unevaluatedProperties: false" instead of "additionalProperties: true"
      "additionalProperties: true" instead of "unevaluatedProperties: true"
    for ethernet-ports and ethernet-port, respectively.
  * Add Florian Reviewed tag

v2 -> v3
  * Change ethernet-switch.yaml title from "Ethernet Switch Device
    Tree Bindings" to "Generic Ethernet Switch"
  * Rework ethernet-switch.yaml description
  * Add base defs structure for switches that don't have any additional
    properties.
  * Add "additionalProperties: true" under "^(ethernet-)?ports$" node
  * Correct port reference from /schemas/net/dsa/dsa-port.yaml# to
    ethernet-controller.yaml#

v1 -> v2
  * No net change, but deletions from dsa.yaml included the changes for
    "addionalProperties: true" under ports and "unevaluatedProperties:
    true" under port.

---
 .../devicetree/bindings/net/dsa/dsa.yaml      | 31 +--------
 .../bindings/net/ethernet-switch.yaml         | 66 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 69 insertions(+), 29 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 98a79be3bffe..4a90168b15b7 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -18,10 +18,9 @@ description:
 
 select: false
 
-properties:
-  $nodename:
-    pattern: "^(ethernet-)?switch(@.*)?$"
+$ref: /schemas/net/ethernet-switch.yaml#
 
+properties:
   dsa,member:
     minItems: 2
     maxItems: 2
@@ -32,32 +31,6 @@ properties:
       (single device hanging off a CPU port) must not specify this property
     $ref: /schemas/types.yaml#/definitions/uint32-array
 
-patternProperties:
-  "^(ethernet-)?ports$":
-    type: object
-    properties:
-      '#address-cells':
-        const: 1
-      '#size-cells':
-        const: 0
-
-    unevaluatedProperties: false
-
-    patternProperties:
-      "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        $ref: dsa-port.yaml#
-
-        additionalProperties: true
-
-oneOf:
-  - required:
-      - ports
-  - required:
-      - ethernet-ports
-
 additionalProperties: true
 
 $defs:
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
new file mode 100644
index 000000000000..2466d05f9a6f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -0,0 +1,66 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ethernet-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Generic Ethernet Switch
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
+
+description:
+  Ethernet switches are multi-port Ethernet controllers. Each port has
+  its own number and is represented as its own Ethernet controller.
+  The minimum required functionality is to pass packets to software.
+  They may or may not be able to forward packets automonously between
+  ports.
+
+select: false
+
+properties:
+  $nodename:
+    pattern: "^(ethernet-)?switch(@.*)?$"
+
+patternProperties:
+  "^(ethernet-)?ports$":
+    type: object
+    unevaluatedProperties: false
+
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        type: object
+        description: Ethernet switch ports
+
+        $ref: ethernet-controller.yaml#
+
+        additionalProperties: true
+
+oneOf:
+  - required:
+      - ports
+  - required:
+      - ethernet-ports
+
+additionalProperties: true
+
+$defs:
+  base:
+    description: An ethernet switch without any extra port properties
+    $ref: '#/'
+
+    patternProperties:
+      "^(ethernet-)?port@[0-9]+$":
+        description: Ethernet switch ports
+        $ref: ethernet-controller.yaml#
+        unevaluatedProperties: false
+
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index 52aeb86c1167..d574cae901b3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14337,6 +14337,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
 F:	include/linux/platform_data/dsa.h
-- 
2.25.1


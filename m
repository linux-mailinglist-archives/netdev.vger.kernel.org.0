Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66486640F64
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 21:47:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234388AbiLBUrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 15:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiLBUqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 15:46:39 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2100.outbound.protection.outlook.com [40.107.236.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE42FF3C1C;
        Fri,  2 Dec 2022 12:46:24 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eCggDoZ98Hp2BZjo4b/AkHITGKG7MD1VAvfGlwZcU4FXvcqfkDkGuUPZFXdJO7M86wVZqRTDr/nRatpZ1/KKipQYwkrSyUSh0gQwG24i7DiffLR+NL9ESVzVN+mmC368F0BeeDW1d11e+3sQ7NSPjq00r3RdUfzDBo6x0QMMh6tY2SmrbXVqg5AG+PE6UhB++oUDwn3o+CEAj7wLP1SW6nbqxpn8XHAiRyPpht0CZBSbcfDUW5fHjlgp8PdazJT98iqeA2XmivFwCq0pPz727OB6vwO6aUlNZvBcgieNkw52F8sEWLuo1QZPmPw1P3CmsQY10r9c7g4cv9rmoSLAYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tSkb6ui12r5CNdsQ31HTjM49LQkjL5sPJ7zGzzHnv14=;
 b=J50w73sGiUDcWvzvuiWDgFNiUw7SO3RlXdGIBeL4mACPnhN7BLbdiTkh7TUPpVbs1+QtSexEh/TFDmO/As+/2/jBuM7/gGqHST+UUvnZxXCuLr31kXHGg1iP+AxiKuvyDCz0DqQOJpmAbcLyzFOqJxtwqBIN1lsAUlp7lSVWUG1HZLxWaNRSDB64x6o5IU+N80aTdZCFtA7CXDIFLRyDPlcEL/Zu9AMruXJeLNbhrKut5YaOdB1ahRUWJIq7mZLSPYETACHyjhVCXNZ3dwM+HV8/Tx1o3ivjdTwidltBXg39ErZ451SNOzfOIfAUUVSy6FeLhnENzPC23+QJcKF6hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tSkb6ui12r5CNdsQ31HTjM49LQkjL5sPJ7zGzzHnv14=;
 b=jW72srcB8hBfCwQTW9P5IC7KXSCbu+Ivv4Eou4584cG1KFWlz6rxUBBLynKS4rqXgaCAc1fBGz6p9di/VMVoFC3SoXcbVQBUXyie131cSckH+UZUyHppsx/aLxB4qk+yorweFkYfABsBZ+cYrgIO24XbucoeKFi/i/28ENEnqg8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4944.namprd10.prod.outlook.com
 (2603:10b6:5:38d::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 2 Dec
 2022 20:46:22 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5857.023; Fri, 2 Dec 2022
 20:46:22 +0000
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
        George McCollister <george.mccollister@gmail.com>
Subject: [PATCH v4 net-next 7/9] dt-bindings: net: add generic ethernet-switch
Date:   Fri,  2 Dec 2022 12:45:57 -0800
Message-Id: <20221202204559.162619-8-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221202204559.162619-1-colin.foster@in-advantage.com>
References: <20221202204559.162619-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4PR03CA0201.namprd03.prod.outlook.com
 (2603:10b6:303:b8::26) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB4944:EE_
X-MS-Office365-Filtering-Correlation-Id: 4939aae8-f884-47f5-9682-08dad4a6432e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YgCCbXHah2q9nAaMNuZWrB/NwOocZPW5a3L5t3AkHktiELkvht2nRHA+WXBFhRzbhJE0b6ctKJJQFDrytSpfbl+o569UKiPrggJbgkYPgKSHof7cutzSolrdq2uQ3BaWJybu1EFNNlX8gbbRMcjNsJX2dLiJOdTKIhYngaY4y9EnGBPe6sxSJibnG84YPmW0I7M+RrMZBCCDef3JUZ+dCWNaFQQY5fzRaadnMGj7G5/rSfzL/LENHCDyAyYN9bAPjBlngXlppZqmaX2xd9OWiDtfCBqiyW+/LQomDfVCudATVOsadfR5LJd2UPj3xex7htINnbHHWkztycoJ/AHnGSeqo02HJCv+/CNSFLXmwynLQSfoetucgbZrGUdS35PrmOebmWe4P0ibkJj9hofwkmCltfdShCWw/nM6DFzLdUzeKfECJfw6phINt1OoVcXzKYjOPO/Vfg7HPIpQzj08lODLaTW/YJ7zvydZL9ZOoWTae6Iz2iPMjBlU5FlNgDvPSPWOUcAeTBxS7svTM2/8ud6EbRk7+2LgIII38im4HVuMFj84GsgaO9iUXGpVRxhqhGfccC5jFC7G/BhBuaz4Pq3ZE+xB6DjBpFn3Zl5g2cp9LXmDp2/f3zlZ+ygd5OLkWm7hztGQEjSb6fIYp/sGNzMmYv1nPFgnfWQbppstbVeHyfbCacMgnQzyk+I0R00K3q1vz8YD0+0LwpDjtzVwOTrNWrkEKL9IA1BlMDYsSe5IlkDRDtwylzscGz12HAfG
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39840400004)(396003)(376002)(346002)(136003)(366004)(451199015)(38100700002)(38350700002)(8676002)(66476007)(66556008)(66946007)(186003)(26005)(6512007)(316002)(4326008)(54906003)(44832011)(5660300002)(7416002)(7406005)(83380400001)(2906002)(41300700001)(36756003)(2616005)(1076003)(8936002)(966005)(478600001)(6506007)(6666004)(6486002)(86362001)(52116002)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?V/1y4S8gdwYIVYA+ka0IYzsfSdVtbgISNIemkeurKHDg8L33BI8E2U8NWnMf?=
 =?us-ascii?Q?8l1UwgWpIuJ21vfqHEVpkhVK7EXJVEif8PsEutJrX2Cxy+4D4coRodWKAe/M?=
 =?us-ascii?Q?EYAsF8n1MTzXiNyxV5bUMaD4npbOW8fYy2rFSY/fL3slzJ2mKzeCQ7eJq7H5?=
 =?us-ascii?Q?F2ak9r8ZWTOjCi6JJ9Y+Gev3YqL3ML8lsHszl18s+OQCCW7R20+vl1133nWk?=
 =?us-ascii?Q?l1aCxMn1APu+rA4J0tBZ/XvSZEILDli1/tInG43g6z8iRKnOtKIlH7J5sZUT?=
 =?us-ascii?Q?xfHuqH/Xg2v2O/uxf87pvcZATu696wHBdSScdIpjA0rVmTF+yXYd4PlLH4jw?=
 =?us-ascii?Q?6IH58ORM/gmDwhe9bgA4zge+u2CTwNoPllTGpL1RfHabj7OfFzh3AWSwBFzq?=
 =?us-ascii?Q?i2GF0eeW5qK1QqrgoMGpAdsqb8ihXKZXCKXiBC4kzSm9crjT4HjhKtgIp/W+?=
 =?us-ascii?Q?BQNL1MS3El6MX9cRU8OcR9Im1tKqizAe2Ly9+gK+7bhQoUc0eOvFs+jS+bhP?=
 =?us-ascii?Q?djvtXwIisiStZDmbm9CDuyNN45y+JfAc13/sOAWKDjfIaWQV1axtEi+fLM3G?=
 =?us-ascii?Q?9hPF8z5/tGiCaZrfSzsNDhWldJFowGRTYSOfU06XRA8tfuEhdRrC1mW3pV5R?=
 =?us-ascii?Q?s53yOO6nax4Nk0gGQNzeganSE/5NVN+NxFp8ujeypf+nykiQcH6px/Tof1Oj?=
 =?us-ascii?Q?42b8OfxaOIichn4GyoelOy9knaWa39htqW5ZbkuU0o380hTvY9CldSe8zh+E?=
 =?us-ascii?Q?84cMkl5ZpkbDpfem5VXpHEgvtPSLJ1QCvfPoza40TiSM7Bzk08fbSWu4EyiP?=
 =?us-ascii?Q?fybKIfCHqYZrv6TTMcMRNVtIZz8y6WdW+ACzQQ2vnxJv97qPeJM6SnkO7sB3?=
 =?us-ascii?Q?+2lNaAS30Y6VJvCrnTwUb3ft7fdtaBwAiawhR7ZVmIj+SDghXNAuJzXtEswe?=
 =?us-ascii?Q?skCXk0Pca6BCdCpH/arOeBmNJ06MgdWUBeyC0uhB3U8puFjPQihsWdaeAogY?=
 =?us-ascii?Q?3eRLHRvA8mFY1Sx5FqkwHTGkPc95sg6KJJdiDkV3MtbZbp8DKZx1ic/3VauN?=
 =?us-ascii?Q?3ENhLRJtwFpNG2aOgfFpzPWbJgqJGPfgKjAEC87cOnBLjAwm0GEESAJbX151?=
 =?us-ascii?Q?9lQq9gO3O8vieSSJC4jZiWAGOI34cq6n/9Gk9/dJDtOKSYbeuZQm9NROEUMW?=
 =?us-ascii?Q?Iv5HQ92xu5aL2sjevH19V59QuZTZ5x5yMRXamJKOOpUCI9KSogvZIA1SFf4v?=
 =?us-ascii?Q?Qm+nUndV2KDlXT/UcOXrt5aZySIXZhVAmqa5e4jfu4wunxkGayWSMvgC8RPs?=
 =?us-ascii?Q?y67qcZVgBs7QBJxR/JLC6QVmH/FJAvezHIhc6Pt4xL5x+kYDu21SW40BjWvn?=
 =?us-ascii?Q?J/w8i144bZ4uLbD93q/drcWvJc2FcNj6j8WWCtP2d/VDAoNrJBK0jDEYqy6x?=
 =?us-ascii?Q?TXW2G+g7Ws/Bb0KVns+wuxA3uSRGXDRHTrHnHI0rBfLH/WZGEOEHX/Hkx9jy?=
 =?us-ascii?Q?nIn/VQENvHEUMlBbqfHSv7xarbmyBlzF35aGqsjwSMqVBUX0bS8DOBHPJRJR?=
 =?us-ascii?Q?dH9ogNZnbIMAP0kEGv1VK+vF7vY3y2pUdrxSLVRnmC20yKdZgxQ3gqOKaXXt?=
 =?us-ascii?Q?XhV0XQqJtL1LyfvTyECcpFQ=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4939aae8-f884-47f5-9682-08dad4a6432e
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Dec 2022 20:46:18.5163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 397WAyS3+ZiNa9P7SDiBKCwUm7pQ8FjdqgnOLGgrH1OhvWvxveRVs6DEj8q4aWXVruKwz3cmophwmbWC1Nd79pxEOxzc+o5jLUYvYs32+gs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4944
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
---

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
 .../devicetree/bindings/net/dsa/dsa.yaml      | 28 +-------
 .../bindings/net/ethernet-switch.yaml         | 66 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 69 insertions(+), 26 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index 5081f4979f1b..843205ea722d 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -18,6 +18,8 @@ description:
 
 select: false
 
+$ref: "/schemas/net/ethernet-switch.yaml#"
+
 properties:
   dsa,member:
     minItems: 2
@@ -29,32 +31,6 @@ properties:
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
index 000000000000..afeb9ffd84c8
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
+  - Vivien Didelot <vivien.didelot@gmail.com>
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


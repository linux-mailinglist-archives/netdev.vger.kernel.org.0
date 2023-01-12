Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F731667DFB
	for <lists+netdev@lfdr.de>; Thu, 12 Jan 2023 19:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240030AbjALSWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Jan 2023 13:22:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240628AbjALSV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Jan 2023 13:21:26 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2090.outbound.protection.outlook.com [40.107.244.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 795E61EEEE;
        Thu, 12 Jan 2023 09:57:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZUR28J2agQi2hW1ZSK6KEfFEt3tlsScVXZomfNu/h4fJtuUT0IMGG2kQF4rbQM4nnk/pxQNY7d3DKWMAEObWOeY7cRbZYBEll7R802OYK2BHY+RtW/yGXVRgucnnWoqZ5cDDlv7eFJdRlw4Gax1muunYmsweql090jHcfM2gi9Cr7w53mBMa7XmUErBPnHuFxGB1nsFRqY6kt48GMLPWfrnwwcK0NN7EyzQI5/vPUUo4xsCTkExn4q7k8EruVID64+/wcP5iPtyZbNN6xmnQegLwihOjiFWZlrsPTrHjauR4O5bkKSTydPaGYMsMEcNklx8VWq5lgto2SGSHlqmQ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c4Zuxm4iTOEtL44cdEmQL3p9S3C/kpo8CZoUiolp6Fw=;
 b=CdYl2sp7mBqe37idRzoZyFqfVTFnQv1t3+8YkHiv2D53VYlp2KxJY4EKQcAUbrroGBphmwnoHMz34WP9AMHfArepfZhI28tiLMeXcszO+IN+vXl9T0XQMeLvge5MON6esNqLbPzphPawhd+rMHOpreAdKgujZCX1hMXXE7e/Ppgzd8Y2QesmxClNNvAuXWBeXXpZ9sc5/q5YH8dSmfW/f+f6dF02hEfuB1bqQgY3iJ5uQoDnRsdwwP4qhxF4N6qFSLtTEA51cVUdCOUAA6GcJzDg0M+t7h0noHE/mITJwXR+q7hhBgceELccooWu/ps2Kt35dA9+XBgyRovfKFP06Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c4Zuxm4iTOEtL44cdEmQL3p9S3C/kpo8CZoUiolp6Fw=;
 b=XkRgZJp/9Gxj5efPsrZXK5OYeaLNoLNE61L6wSIlpGOxXf8qvD8te6phMc8jieNAOGfmJUbHTPJEzooH26pbKP0eP9lOHEXSfZu2iR+yk4f9a1G0nRtKJ9CyqBtwhJmEkkOSDguwMShmPpsmTTWyIrpkmSU97tAWR9wdcFQGfjo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH0PR10MB4520.namprd10.prod.outlook.com
 (2603:10b6:510:43::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 12 Jan
 2023 17:56:57 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2015:3589:3e96:2acd%5]) with mapi id 15.20.6002.012; Thu, 12 Jan 2023
 17:56:57 +0000
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
        =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
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
Subject: [PATCH v7 net-next 08/10] dt-bindings: net: add generic ethernet-switch
Date:   Thu, 12 Jan 2023 07:56:11 -1000
Message-Id: <20230112175613.18211-9-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230112175613.18211-1-colin.foster@in-advantage.com>
References: <20230112175613.18211-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR03CA0002.namprd03.prod.outlook.com
 (2603:10b6:a03:39a::7) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH0PR10MB4520:EE_
X-MS-Office365-Filtering-Correlation-Id: 692bb27b-dce4-468e-b9fc-08daf4c665cf
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nVZgVEga05PNoEDTfU14rMhLgdSMu4ysPP/scnU2Zwn5Kbh0USLsTf5eXutvjVguM4uqSNH8SRMB+uSrHZKTkJSC3wxiLcGhKF7EsriOJJJPWkt5+KzUVRDE9pgDqW2vkKKxcklsZCzbWMgsz1QLJkMmdJF8+3hyv0WOpNdeq2vRYTHExADPqNMMU4+zjYLwd+KCdlqx+/BETHtSczf0VghltPwoYih8IA/lAjFbgSjQIFgIlyzqI4inM/DB1H7z34hEyz2qDSGtDz/hsTAuo4dgYBQ2tWLNEsHx/eBzy1fGIzDUwjLnS2NlRIHFejkN9MkTcd2sElf5ixTh5AaB8JcR9J7KKcIQXkRm2OxzIUzB0ZMcHD/Nd1cd4JvG8UJA2/ZfzE32dXYE04mHMAuylZVTuxM72j+LPhe9Qhe4WOmYV/PFSCJ8oem5M//6PtrbibEvpQYoAy+kY0XngvMSOXivyhF72CjecpJYZ9/v5m3V1fCSyIRdqqqs5FUq1Yvj60qE1+0f/zUMszaIjLrCLefR+BJomEyXZVvxfzQo8jsgLL2iliRUtWQqIcvF8WxuYe5raPkm1aknmC0XBXFC48sVEXcw2NgLTeFEEi9qEKkkCfH4ZtnlWPuFuczrICKz1HDpl+7zk/ht/I5XOYur52RqB3Qupc1b33sMDjDf+Qe5bkMambCh8nIdpxxJINm/Gydk1JEVY26ibRw0FgJ3LA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(136003)(396003)(39830400003)(346002)(451199015)(966005)(6486002)(478600001)(52116002)(86362001)(38100700002)(36756003)(186003)(83380400001)(2616005)(1076003)(6512007)(6506007)(6666004)(2906002)(7406005)(66476007)(7416002)(5660300002)(66946007)(8936002)(8676002)(41300700001)(66556008)(4326008)(316002)(54906003)(44832011)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VEGWjCBjuA4U5M6F0qxHXXbPIEhcyRfLIHMhItslCrBnPyUXIxkftgQiTp99?=
 =?us-ascii?Q?C37ESrO6aFoW8ElrYwL6yUvBpeoSYhqB5TrtIbkWyQQWfXp9XyT0oLz39ns4?=
 =?us-ascii?Q?QKEdR1nafmysGhbcfFT99LgAmKUfFp+Er+87mCjQwL/zJ4ZgDPZub1FlCcZj?=
 =?us-ascii?Q?l1QKiS6WlSCCXbvPnbDrrTYZ24f+oEd1QZTaFFBOIHD8A49ibcGB/4z/qd2F?=
 =?us-ascii?Q?wMvp3j/5G5gW2IgGWXYMC+iDq4fm0nteb/3j8OR0hIKIA1V/Zt2eH7J3LBz8?=
 =?us-ascii?Q?1TgF4kDVdYuqxFpROg28ShWqL3zOhMYbPgcILaLP3ecLusukYW7DTqfbzY5V?=
 =?us-ascii?Q?f6iLKZ/Wvm1BhhI0wcD11XFVEfuMaYuTdkx/0ur34UKfVOOorGnTEw/S6dGT?=
 =?us-ascii?Q?U8bLx795SKrz4Bg6RKrFtJ1bVM91AxGaT1PchAf57sgYXlQvoW1uwBlc4D1B?=
 =?us-ascii?Q?ZENdVdxlPkO/DaxSI7KdbQCFSW/HYHnKhBeun9l9C4ueRgK5wCb7BsQqULim?=
 =?us-ascii?Q?AJDVF34mFSgIL/rYXiPcFErQ2wBYxdl15FSoJG7aIoeL40bx4D38l0Ecj4Ak?=
 =?us-ascii?Q?MMyq7r8PVNuzF1XcEImrDRf/7aQKy8VbZeTH/pl9EMb+2xGCdt3RuJXfOdpG?=
 =?us-ascii?Q?Sh+LKINaB07iPY59eD4jzay1YNSWHLxgnGGrwyfDf1ztgqLEZ+iOpdaschln?=
 =?us-ascii?Q?9g5X+0REQU3Wqh6Ol+uUOlpRzGviaMxpD4abm5QC8uQUslfEETgd8Up47TQV?=
 =?us-ascii?Q?07x2OC5NI10V8+IljM5hCDzlTERxGUnX7DmwAB89RBf2FYBkV1mx0/0m+UW5?=
 =?us-ascii?Q?KDekKdM+u54yrcg29GAI9To9Y1tMsV8XukKji2jhBtoHwtgdsslYkgpGDhVX?=
 =?us-ascii?Q?ynMdgtQvhAFKufu/WZtiD31Z4ReRDEvdEdX7Oe2aug3U3+v9Pj/cCbvCik+k?=
 =?us-ascii?Q?gxc2J6Oh9Oyyd1KYZ92i5oEjMWiy1sI/Q3aMcNS98cAkMeK9iHS9IfnYI5Fv?=
 =?us-ascii?Q?32TwT8UMrViuVstHERDkdo+Ant+yVy90vs+x6bLVWUEHK2ntE4AM1LIYz8JT?=
 =?us-ascii?Q?TL6hqzkjo6tVSoe8z8nRZdYPM7KOVxkguZe2z4+PpSl/BJ6vjIjRSy33/l7U?=
 =?us-ascii?Q?VQoLXmYJLntl7ENU0EYrdy8w+c+zDp6Zr3tlmIcaaMJP4TYF6VTLMFjXkGGq?=
 =?us-ascii?Q?U7gP2WflxW5QzOANWtfq+fCU7k9yCIgKk9SbXXX6l1SAWMZOlbtYVX/p9zss?=
 =?us-ascii?Q?M1+Mu2+rEg/ypaeW3QyKoTgDzkkpNQ0POIeU6jkONsg6qoebDFGhfiYnJz9Y?=
 =?us-ascii?Q?rAghNxqBXfuaTWzx5f3/IvhHBgZKWRVJo83PZQn7x+kkH6OjbLzdTibka2KV?=
 =?us-ascii?Q?fNr05GnPQm5OBn/HbHFVf6G7zVRwbvloK16+X1qpWnziRF1cCtqxEYlDKmsE?=
 =?us-ascii?Q?VGddBQlRchOzqWJASsn0nW9Xw6MDkJdi0J9RlF6f8/dGI3k/+xI9rlI1633m?=
 =?us-ascii?Q?PxKYbrEWAkPlHjj88UYSZs+8mfoX65QBoq8f00lujGu5ZmLlmeGB7BzgRXOy?=
 =?us-ascii?Q?X01R//7sZuoHcX4j0owEJ6QLIWUxZLSz1jt8Rz3elycneFuvqQjzw9s+L+YX?=
 =?us-ascii?Q?mICjhc9tCtPCS97n+pFw+3or1RQijIZhG9GutWLDPypNfiib7+GKt286MKl7?=
 =?us-ascii?Q?cCpb9rdHXXAkabXBzJrP3KrJ+T8=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 692bb27b-dce4-468e-b9fc-08daf4c665cf
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2023 17:56:57.8441
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eTj4DnamVRuAri6d0FPIUuJkReH+fvWSyc2BjcoSkM+bEKfWRskuyTnAGjfThzirkIBFyglyOtHRyvgT/4NEnrNFwJHqhZA0txb0o5Ef1Oc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4520
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

v5 -> v7
  * No change

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
index 7487ac0d6bb9..8d971813bab6 100644
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
index d346d586ea1a..b582e0835b46 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14542,6 +14542,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
 F:	include/linux/platform_data/dsa.h
-- 
2.25.1


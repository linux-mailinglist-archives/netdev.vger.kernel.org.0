Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB9A460C308
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 07:04:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiJYFEy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 01:04:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiJYFE3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 01:04:29 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2111.outbound.protection.outlook.com [40.107.92.111])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D39710AC3C;
        Mon, 24 Oct 2022 22:04:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3j/Ue1TldNGrTLnUhb3d7kBdAt1u6CfwIVufGhC1oA1tl8dxhEWLDbgAONsbQ4mWkeeezSso3qTRaMavRyno/c/jcfwhHB8jAmNXVIYOOXHkXK10lIbV3DzNpSRmvnLtw0ZsFZuHGL3DkB57BLSZfto43u7JCZDyUG+EHYHi21xSE2JKGQCbMw8GUnEG8KuVCGSaklge9uO1NRZJKXXad4QCL3ddpuBTXDCuO9SGmIAXvYJwmQzW3gKeDFR6b/Atiq+wnliHrLmtn/jhLUe51PV/shr/01eX8bNbeJTjuE31p9jtFLXymtec5oJLwmDnvbd2oAfgSPM72TXJVjpMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vSLf/dDWfNWq84PuNNvI4A64NEe+fH09jtiOye0zEEY=;
 b=TsQPEdNk0+22ofT1EaTougmlGqA2HvYHb+wHOsuJVPLdJNvy2lZO/ykRa6RGVLvlQIlsVsM4iPD2DEJFlSiKCOY7kL4Rx5a4sxOFAYRjUxosSwq/7qI0rco4VQNjJ4zB/yCQ4hyePcRWSkNfGniD9AEDs0vzcNxYvgm8tQWCPxI7nWFkecJDV6zNKqJleSPKv2v+bql0lerbb9d3MhgRilBvIf/AGZprRk/Tq3fAcdYiL1fvlgwN9+K/bkT6dQOyeVZLiHGupGqUSnXzGTT84Cv23t7IsetO9o8ja1z24PBiWEUICBiam6feK0g6HJwFn524usem64ewlUwCJDw9yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vSLf/dDWfNWq84PuNNvI4A64NEe+fH09jtiOye0zEEY=;
 b=dWXmR7La08J1lzNfoH+WPMkNwtEXwOemZ3fHutmH6vNFbO5MN0ABoleuykRhe5d+5ynFaBSiAZsRVomGdwQqp83o/iWt8vSzABTVWYwar53O0OXq555Sd6gxE+08LjcGsOqrK9C2H4GKnRaTlDdyGjUG4/uJYrEVhSrtPaYnWYo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DS7PR10MB4989.namprd10.prod.outlook.com
 (2603:10b6:5:3a9::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.26; Tue, 25 Oct
 2022 05:04:16 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::8eaf:edf0:dbd3:d492%5]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 05:04:16 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        =?UTF-8?q?n=C3=A7=20=C3=9CNAL?= <arinc.unal@arinc9.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
Subject: [PATCH v1 net-next 5/7] dt-bindings: net: add generic ethernet-switch
Date:   Mon, 24 Oct 2022 22:03:53 -0700
Message-Id: <20221025050355.3979380-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221025050355.3979380-1-colin.foster@in-advantage.com>
References: <20221025050355.3979380-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0189.namprd03.prod.outlook.com
 (2603:10b6:a03:2ef::14) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|DS7PR10MB4989:EE_
X-MS-Office365-Filtering-Correlation-Id: db25b5f8-e5ba-43d1-2497-08dab6465dd7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kKC21tfAt+57FJCBYEyCxHociZ9pusf944ZCf2icak6kKYB7iCfsyn0fy2C5y1xCqqEBLhYG54peR7/L9PjAZLSebyIsCw27+Scp43Kx2ldnOVZWjC46OSzwKwbX2C9jgpVGu6Jlxw5fa3eFARRJYoo/KL9ZCYYNTJp5SNthI0I5X4kNzuLZThUHoAKrZEK23523izz85qJD4HLTaT4Jng8RrcR7e9zT6GoYSQ3c4kznNu6+kQmlK9ZIl/XRIlXlcsegaZsoXA2xsbYzs9Di6iTK2Cdg5+GezVySLIXAnd2ksc1LlhKyfYCkXofRngY/EZWTRCvOLp8anXTt7ro+tSpQdD+s6tG+566vPNXQ73caJ40zqKVrCqVair9EOBTKi6NTF+XoFFv00ziwX7ioircaoZBIrn/AsLJZjnDnWMBNTAGdNWqwRDVBqnT7w8Xf6rHwKy+SqPP4Q3DiuAIqh/F2I1qmE7KNbbOVnC6KSvBBqbsjreBWHGZ+BLNRzG101DP7QGgl9wJuV9bt8ZnF28aGub3Sqf//155Wec26/VVVebAWW/l0QWllHH4homPJHMn+8O1kXdvFm4LWhE07IG4EN/iwqzYqYBSvGVK63KmgVZrUt9wTVRMyerLMCDiUEw9htZI4beN0dxscDzIFz+o9IMx6400G9OnMM4Yi6Exqvco0XEaHITJvZxqqQzE82HZ/BhKKNyDFowzvXbwi4sfaN6ziuN145v2aBzPes3M28jqaK/FsN81khBOUmHdv71KQ6kn1s73wekdgQxFJgJURPw89a0zXNeet0BTKaMPRrdrSKT4sFVb8a2l4rKKN
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(39840400004)(136003)(346002)(376002)(451199015)(316002)(52116002)(66476007)(6512007)(26005)(54906003)(44832011)(36756003)(7416002)(66556008)(4326008)(41300700001)(8676002)(66946007)(86362001)(8936002)(5660300002)(2906002)(6666004)(478600001)(966005)(6486002)(83380400001)(6506007)(1076003)(38100700002)(186003)(38350700002)(2616005)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?sLaqWI6mgfU3mx8Lo3oyhd/QFJPyjgrJm8Dz2hiT7MPDoz2DORSwRoLOzyyC?=
 =?us-ascii?Q?voBjXLWsM2fxe+tjuhPj5SUXW9lVU6CdHlrFSkMFNeYwVgtxhByOqSAxHfVw?=
 =?us-ascii?Q?0tey0Wg1pFWc8rD1pn4hlUoVCpH2M9Onh8YQIslIi8/9skRGla0wi9s3Yy4K?=
 =?us-ascii?Q?XIhiVGQauLG1SWtCzZrFtzeRyjDIzz1+BlThDAlMYcDni7lhZLDU8bG+Hj96?=
 =?us-ascii?Q?J2zbdtP5Nxwn0p0RICsq23Soxh8CDavmPF3ZHX4bN35m/763/YWS7eLns+YG?=
 =?us-ascii?Q?ppFmmE0l7mnXlrwuog0vwkmU1FX1/dfogsYT4CC3IR3sVoAWBOnSrPvtAcww?=
 =?us-ascii?Q?4N/jpym0i97JYAmOC41MnXuI56iwxj1KCn5vHInEWU3EmM2EdyFQlEehFDZe?=
 =?us-ascii?Q?qpdakiDB/1JSKLlaC17ADurnV0mWSmJdY0uRX/SRmUPavpxCLqMQZ+0GAVRU?=
 =?us-ascii?Q?w3jHz/gVW9+FXdl19jkAeLfdDvLZt6GFFSKO9FVYqwPbb4Hi8/5R/DXhe1vv?=
 =?us-ascii?Q?RILXiTJHXk3Jv2hTAnm1sw/tTJ/tqkPLnjv4i58PSTWOupeL1k5zXZEa6Xsf?=
 =?us-ascii?Q?Vkb0DkFb/5mYJY1hQeqUithtXHcdsoZWZ+J/h9B52e9A1nNcIvWNEbl8s+GE?=
 =?us-ascii?Q?rFlZstbVooRL5I897bHje7BlyXG/wQIk+t6OAemkwPEh1c/JOLhiEqk5xiJ1?=
 =?us-ascii?Q?tUOB8QfsQ1AjX2HS77WNYXEhv9+N1tkrAYz3FA6FoXhd3PRF0wneslA05PKs?=
 =?us-ascii?Q?9hF1YW50K6nPEa412G3InFqjBaF4XfeliK8OBoIUGQuG+4x069Z7dDqQgIew?=
 =?us-ascii?Q?eSRoHKocA4eDHBDt9xDbPnlUvXTVWtBs6gBFDdkm7VS+Cxc02I++K12d3ycF?=
 =?us-ascii?Q?s2F92YKEFTIt8n4NkeQmIANplPBrRlxcYlm7ZtUBDbDP7sV9yxL0Qo65ODzU?=
 =?us-ascii?Q?g0qgwbUco6S4Hdop6kkiq6RS0ZQqZwop/iClGHgWbULdgHnPxIsMsef1VHiA?=
 =?us-ascii?Q?SsX2SB/YP1KSVMSftT1oPYM25hL7tFOj8Kj10bkbqdxV/0xz1UIoMPmelgAf?=
 =?us-ascii?Q?wMG6jdbsoBTNM35+TQoimgURXPwsUohEdmB6eHyHqmBGezvnY33goTPVxmuC?=
 =?us-ascii?Q?byF1dVyPWHeT7bACm5syqVLXrtUbJLwfZqUC5YLqY9M1KiMZ7e+pTvgA+M7I?=
 =?us-ascii?Q?0DhqTYPAabUSJlTJZnysT5rDULEk5vILjlpotgSqY+eEuZHzzwzJ9ODgFo1i?=
 =?us-ascii?Q?sYNtkkk3OYHqjRBrfBuEY+2Np9w/M9ypr1RT2YPJe9+QW9C4r6MVTPZ9FpSs?=
 =?us-ascii?Q?B0MzP7pAekLgVuBDFdwmb4aUGjla9C7C0gllTfqQM0/VwwZf7deR/cyGxOKC?=
 =?us-ascii?Q?7iQgKY5tkFfHxnouqwRupjrx+oaDJ7qQmlFEHo+CJ9gXdnNTagGYYyLczWq8?=
 =?us-ascii?Q?lp9IOA8e+bV2bjC5aqWCHLbub0WNqg8GZc6WVfjMKjQ5XKbKTpbs3Kx2TUFE?=
 =?us-ascii?Q?Dff9Cm7JKY2xtUOPTeUtC8xRPWpCJSs95b8ELU/7k26S8iPovq23gNMgSyql?=
 =?us-ascii?Q?PEuNf2CxfF0RUoK4p2O9RX2AH6WkXZeK5FRO4rybjIX7yvxevYU4+U72Eu2t?=
 =?us-ascii?Q?dw=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: db25b5f8-e5ba-43d1-2497-08dab6465dd7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 05:04:16.6880
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cuPZjFpH4G/3b1ZAmwYsN6lzChg6dKB/F3jFtSZU18U+9c2lrnBaKUrSWfJ/rUWnAjKgkSnLNVftwykigO0+2756czauh7Oq2/LjiEfZJMY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4989
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
---
 .../devicetree/bindings/net/dsa/dsa.yaml      | 26 +---------
 .../bindings/net/ethernet-switch.yaml         | 49 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 52 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
index b9d48e357e77..2290a9d32b21 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
@@ -18,6 +18,8 @@ description:
 
 select: false
 
+$ref: "/schemas/net/ethernet-switch.yaml#"
+
 properties:
   $nodename:
     pattern: "^(ethernet-)?switch(@.*)?$"
@@ -32,30 +34,6 @@ properties:
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
-    patternProperties:
-      "^(ethernet-)?port@[0-9]+$":
-        type: object
-        description: Ethernet switch ports
-
-        $ref: dsa-port.yaml#
-
-        unevaluatedProperties: false
-
-oneOf:
-  - required:
-      - ports
-  - required:
-      - ethernet-ports
-
 additionalProperties: true
 
 ...
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
new file mode 100644
index 000000000000..fbaac536673d
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ethernet-switch.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Ethernet Switch Device Tree Bindings
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vivien Didelot <vivien.didelot@gmail.com>
+
+description:
+  This binding represents Ethernet Switches which have a dedicated CPU
+  port. That port is usually connected to an Ethernet Controller of the
+  SoC. Such setups are typical for embedded devices.
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
+        $ref: /schemas/net/dsa/dsa-port.yaml#
+
+oneOf:
+  - required:
+      - ports
+  - required:
+      - ethernet-ports
+
+additionalProperties: true
+
+...
diff --git a/MAINTAINERS b/MAINTAINERS
index 3106a9f0567a..3b6c3989c419 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14326,6 +14326,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
 F:	include/linux/platform_data/dsa.h
-- 
2.25.1


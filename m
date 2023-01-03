Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFFE65BA54
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 06:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236880AbjACFQE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 00:16:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236792AbjACFPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 00:15:18 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2115.outbound.protection.outlook.com [40.107.92.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51655D2CC;
        Mon,  2 Jan 2023 21:14:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXhLvs5AmBO+ax5zwKM17uJlgyEt1ZDDEVDbh79oFgA/gbnPXzprZJvzXbOluXbrYsM8/b1CJraLYL8aDzMt71sbBRhtXoEfLlAYRyqYPZL77Fu31I2ZLcYFTMQv67aQXRckXaDQoMux8tk+G/5rfwyskxEbQgWMKLFROqTazUwtZyZnZgqvfs7AgBDGre47dT2SNtjXuBLVhbkg9h7LWfeyW2WNX5Jxq41VPuy2MJY7aiJpbHhQ6bCgbiy/IwVyq6hIuoTIXRnny4v5BmIc8K6MBw1zfjWEOzDmbGJDYsvc8GIYHspFG+eCtKvJVU56DV4WoInfBGzVVp3KMSlS4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UwKGZxoIlKI+1ny+F9KXMWaao7wM3hbOUARGvWwOHgw=;
 b=g452igh9QW7ADK2Aa0NkC3SdO5CPlKBMN1DonnscFejvBnU5mqG4uIy4zvqX055wiZGekAuvZM9J2eUidYQM5j6/zf9K8ZXBKJnJ/H4niXTfAnWsqNEXQqlLD53o4+gWuxSxJqy1aX8PdNa8GKp7v4iP2j8vSjLgUbOe7u7g5pm0ViLa67yHbT6Ws2tBIri2Mi/ukWbFYUPDZQGLcDEXMenr3Iy2Xj5WWbBdCBusENr54CW+ozP6x3WmaX1YEjSevoQ9nOftH7+iWMxzjhNuKeIiMAG+qSMwGxcfiY/o8NmJ7wZwAqGCTA0MUQFlTRLWkr5H+A6P0BgTD5J2FtGkLg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UwKGZxoIlKI+1ny+F9KXMWaao7wM3hbOUARGvWwOHgw=;
 b=F1g+8R2DEvdW2zT9sw8P/v7PLt2rI1MsxK+RnCuXUoXq4N1WHxkNevqZJj96OfiEIaQ8hKAM4+cC23WXrURiXrS6EHtphKGdTKtFqsqWn+QTyOgFr109pXqRD28YEzNclptK+1SoYDDvk5iiLL5x1FeCf/n5RhO+UnVbUGTGpJg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by PH7PR10MB6252.namprd10.prod.outlook.com
 (2603:10b6:510:210::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 05:14:33 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::45b5:a860:9cea:a74c%4]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 05:14:33 +0000
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
Subject: [PATCH v6 net-next 09/10] dt-bindings: net: add generic ethernet-switch-port binding
Date:   Mon,  2 Jan 2023 21:14:00 -0800
Message-Id: <20230103051401.2265961-10-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230103051401.2265961-1-colin.foster@in-advantage.com>
References: <20230103051401.2265961-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0057.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::32) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2351:EE_|PH7PR10MB6252:EE_
X-MS-Office365-Filtering-Correlation-Id: 807889c3-64c2-43f4-be7e-08daed496670
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gico0KrcoG11GI3enFIKITuLy/35izFmClK6J4pqWdEWqo+piSgc+3S3Jpa1UqK4Oxyqlay+7l+mJolS3E6cbqQAexCeD67HRxmANtY1EUZ8ZLksiG5LN40dzNzX1j2d9H7u/pOX1u4WkXmh+G10smy2fC9siRkIR4GtDi1QZNkFSyorAKxWSXLj75hgBCAnxpRlogCG4OUCc5ZQ2Ub6BfvLIgT0wJKF42AapwTnYwBe98SciXKAJj7dZv51pWQu0Ur//i8xGzsI8F8G2uQNtVNktyk0WOe5jDQbHS4z/xmdpS/ry0965iVBwnajL8tc5q1/jrBiUtNn51ek0dJX3l1HLrs1LfhtrPuxBLtsdTR5S0qqIMrnRXemX4wrATWUY67Ndo8BuF+ipJW9aeNV99SsgkEiksczs9PgXI56Ks/sL3fLCdAkeOozIXpQvBnzEOwv+i6XjQIdSxiEvzc6NjETS2Eyk61msLrByPrmQXVJQJEqFzM9dFekl75a0XpSus2yQa4+pPGGtt5TOWgaep3XJh40oTs9hqOfK9UIixlSQaysUX1bRPQ1sBh6exljIe/2KlL5toM/Bs5/DaKP0wq773mtAoZ9lxllSbkwxn5snoqPWSvWM90zIwkFwR87Z9SK2vWMTKjDXmwPCt9mElwsN/VAHgHxQwLHVESR3Xvk7B9AUZ/QfNSZqNF3HiZsTSTS6k5lXYhtySZEGWBssWzA124bz8WKBU6iTkLzergtaw8S9wh37EORDxuijb/tNwTfcpzd6gfrN9YLKzq6UQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(346002)(39830400003)(451199015)(41300700001)(4326008)(8936002)(66946007)(7406005)(8676002)(7416002)(5660300002)(316002)(54906003)(2906002)(6486002)(52116002)(966005)(6506007)(478600001)(6666004)(66556008)(66476007)(1076003)(2616005)(186003)(86362001)(26005)(6512007)(83380400001)(38350700002)(38100700002)(36756003)(44832011)(22166006)(41533002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?9MvRHZpOHDEIpTjSc/J9zAeszDkOlz4Wj85yde2uLr/LJLCV5Uuyu6iIeMvs?=
 =?us-ascii?Q?JPc2I9sUfo2u4jdt5EavFnD/y8WSXfhZNbyooz4w80/E513ZyiKxaNyGdWQC?=
 =?us-ascii?Q?Jj7X5BxHV6i5E7hV899mC6ZZPpPYLZZhX5O4izaxbBMt3P12c68hqWJaQhcN?=
 =?us-ascii?Q?bqeQPt5INOWQ258T73P6PVYvhueD/Jrqg6Mmhew37dPvyZBHBwm2TFDqJijE?=
 =?us-ascii?Q?Wm+RHNxZ9tGGmBu9oLvKQ9OpN84FiqYODnwkKUj3zpl8f4Q8HTlCnmpfyofb?=
 =?us-ascii?Q?lX7zZudKo7ptc765EMOFXA2TGGmL9HE09VjHSbNflUdis66snA6zSMEhVvOj?=
 =?us-ascii?Q?47qtCZ3tmIwVPYKp8hPk1ff1Qxsdzei52NF20NyEi7RwDYf+H+qAQPkhjKYe?=
 =?us-ascii?Q?udVK5cS8F00C+wQ7onj6zunrDE0hYpV4yqEGGJBhUcbU07gtj8B5CK+aGxOX?=
 =?us-ascii?Q?A49fa0JI133i3s1lebiEAmaTLPKenO2cdoQOgVR+wD6AXeGcyg8L1ggxVwSJ?=
 =?us-ascii?Q?iuTWTttBX3CARFAPbFR5Ai1yJjaKfHFKVPpavX0AoISpwDOsRKRn6pxvTjo6?=
 =?us-ascii?Q?Ql3iD760YpbTop1RAexFepdfPQ5ncSUCyZRb9Uy7OJjb37gowDGrGSSHuQ+o?=
 =?us-ascii?Q?5bBibZ42tiLsI5OD/FQF4wB8lUAmjsQpdPQyPjm/Dfzq2DS9eWn5/1as8u2h?=
 =?us-ascii?Q?lNwhjYKNvAN99h/AcjfWxInNhTXKfda2NMpAQnQL9eqL6SYIBhA+47FmGX6p?=
 =?us-ascii?Q?By00GTWAazgfpgh2eP8xkOVjBEHoGr+Jg/Og+ijlUJHxvS8UbwogoOqFNwIE?=
 =?us-ascii?Q?ElYkSxRqDvAn8P1HROvq8i7dWv9nqNqkPv2I2UBCz2D8kRa3V20yS1IypDcL?=
 =?us-ascii?Q?pnjImPSUIhc+2aVERdSvipshpz71V0pkg3YlPW08H8OqRzi/VFdQJAJXpgXn?=
 =?us-ascii?Q?UJB1bhOUaOway9roddHn5NJfRPYzSQ/2pVMW/0rwjRR16ftsvc4rVagesfjy?=
 =?us-ascii?Q?O3MgC2QcC4oc2dmtQTmmxC5iTemJ0JB/hDvPT64Zc2bZoBl2kuEPVDKIlS5r?=
 =?us-ascii?Q?SPrpkOdCPIN3QSrS7EuTshs3gkC+Dbtbrt26rVUc44K2aY4XG/o30pXuQhBp?=
 =?us-ascii?Q?fH6jLR/kn7YGxfh55lsUOXQbygygq5L8EDlVZZVlF2P0EvJe21Bure3yAEbJ?=
 =?us-ascii?Q?M8UdmmpDxZha6Sie46ATAFv42Ph0C5RwLBcXzTzW+r/X4iTSjrQ3W0bOsMN6?=
 =?us-ascii?Q?h0iosRenkJ1Fos52nOhr4mQLwjkB8wx94LIelQZTdokeTJnGxpT11dMggMN0?=
 =?us-ascii?Q?4zmmucwDEXb/Bp75+658PTrfYxjEprvrRC9E+pFo2ryMASTlHnjRUthxyVPo?=
 =?us-ascii?Q?krlvHto3B1Sbmo57HDDU/yBq7/aBY4mew7GaHXuwC2uE5ty1V/rvfRKbXc2m?=
 =?us-ascii?Q?jZSOWgBRavzB715HjblGigW7gSIT4tCF/dsPBcLM4cyHoQ/UI3IOhn4ep0cw?=
 =?us-ascii?Q?h2F3aL1FxKwGzjx2VA13BMAq0jbV0n9XL69eLLRRZVb6tnxcjc2Nwis+sJWU?=
 =?us-ascii?Q?vAKfR+Pp2k49Z87fF3swSybGgdY9Ghcx/5q+yxlJTOni9+4xb5LXCsDU4oPr?=
 =?us-ascii?Q?XGnBM6UEHHy21GL/ExTd/pc=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 807889c3-64c2-43f4-be7e-08daed496670
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 05:14:33.6375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: shqZuEiKZ5+6gHjoOLs2Hz95R1yyIRBJNUs7ybEls5q8jGw202d3bTyAjGJI6XnDak+l9MRijb8A98dG6U1g42odwVgeKMyust4z6/zQ1xA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6252
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dsa-port.yaml binding had several references that can be common to all
ethernet ports, not just dsa-specific ones. Break out the generic bindings
to ethernet-switch-port.yaml they can be used by non-dsa drivers.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Suggested-by: Vladimir Oltean <olteanv@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Rob Herring <robh@kernel.org>
---

v5 -> v6
  * Minor change to fix conflict with the removal of "Device Tree
    Binding" in the title line

v4 -> v5
  * Add Rob Reviewed tag
  * Change Vivien to Vladimir to match MAINTAINERS
  * Capitalize all words in title line (Generic DSA Switch Port)
  * Add better description of an Ethernet switch port

v3 -> v4
  * Add Florian Reviewed tag

v2 -> v3
  * Change dsa-port title from "DSA Switch port Device Tree Bindings"
    to "Generic DSA Switch port"
  * Add reference to ethernet-switch-port.yaml# in dsa-port.yaml
  * Change title of ethernet-switch-port.yaml from "Ethernet Switch
    port Device Tree Bindings" to "Generic Ethernet Switch port"
  * Remove most properties from ethernet-switch-port.yaml. They're
    all in ethernet-controller, and are all allowed.
  * ethernet-switch.yaml now only references ethernet-switch-port.yaml#
    under the port node.

v1 -> v2
  * Remove accidental addition of
    "$ref: /schemas/net/ethernet-switch-port.yaml" which should be kept
    out of dsa-port so that it doesn't get referenced multiple times
    through both ethernet-switch and dsa-port.

---
 .../devicetree/bindings/net/dsa/dsa-port.yaml | 27 +++----------------
 .../bindings/net/ethernet-switch-port.yaml    | 25 +++++++++++++++++
 .../bindings/net/ethernet-switch.yaml         |  6 +----
 MAINTAINERS                                   |  1 +
 4 files changed, 31 insertions(+), 28 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/ethernet-switch-port.yaml

diff --git a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
index fb338486ce85..8a29b4c140fb 100644
--- a/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/dsa-port.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/dsa/dsa-port.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Ethernet Switch port
+title: Generic DSA Switch Port
 
 maintainers:
   - Andrew Lunn <andrew@lunn.ch>
@@ -12,10 +12,10 @@ maintainers:
   - Vladimir Oltean <olteanv@gmail.com>
 
 description:
-  Ethernet switch port Description
+  An Ethernet switch port is a component of a switch that manages one MAC, and
+  can pass Ethernet frames.
 
-allOf:
-  - $ref: /schemas/net/ethernet-controller.yaml#
+$ref: /schemas/net/ethernet-switch-port.yaml#
 
 properties:
   reg:
@@ -58,25 +58,6 @@ properties:
       - rtl8_4t
       - seville
 
-  phy-handle: true
-
-  phy-mode: true
-
-  fixed-link: true
-
-  mac-address: true
-
-  sfp: true
-
-  managed: true
-
-  rx-internal-delay-ps: true
-
-  tx-internal-delay-ps: true
-
-required:
-  - reg
-
 # CPU and DSA ports must have phylink-compatible link descriptions
 if:
   oneOf:
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
new file mode 100644
index 000000000000..126bc0c12cb8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
@@ -0,0 +1,25 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ethernet-switch-port.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Generic Ethernet Switch Port
+
+maintainers:
+  - Andrew Lunn <andrew@lunn.ch>
+  - Florian Fainelli <f.fainelli@gmail.com>
+  - Vladimir Oltean <olteanv@gmail.com>
+
+description:
+  Ethernet switch port Description
+
+$ref: ethernet-controller.yaml#
+
+properties:
+  reg:
+    description: Port number
+
+additionalProperties: true
+
+...
diff --git a/Documentation/devicetree/bindings/net/ethernet-switch.yaml b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
index 2466d05f9a6f..a04f8ef744aa 100644
--- a/Documentation/devicetree/bindings/net/ethernet-switch.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-switch.yaml
@@ -40,10 +40,6 @@ patternProperties:
         type: object
         description: Ethernet switch ports
 
-        $ref: ethernet-controller.yaml#
-
-        additionalProperties: true
-
 oneOf:
   - required:
       - ports
@@ -60,7 +56,7 @@ $defs:
     patternProperties:
       "^(ethernet-)?port@[0-9]+$":
         description: Ethernet switch ports
-        $ref: ethernet-controller.yaml#
+        $ref: ethernet-switch-port.yaml#
         unevaluatedProperties: false
 
 ...
diff --git a/MAINTAINERS b/MAINTAINERS
index b2c8cb05bdc5..e58f0143cadc 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14541,6 +14541,7 @@ M:	Florian Fainelli <f.fainelli@gmail.com>
 M:	Vladimir Oltean <olteanv@gmail.com>
 S:	Maintained
 F:	Documentation/devicetree/bindings/net/dsa/
+F:	Documentation/devicetree/bindings/net/ethernet-switch-port.yaml
 F:	Documentation/devicetree/bindings/net/ethernet-switch.yaml
 F:	drivers/net/dsa/
 F:	include/linux/dsa/
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053F21B75C2
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 14:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgDXMq4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 08:46:56 -0400
Received: from mail-am6eur05on2078.outbound.protection.outlook.com ([40.107.22.78]:39617
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726667AbgDXMqz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 08:46:55 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uxcx601CMbdcfZ+97BW2X2OqfRqzLocIRzcMkB7vh2TkYAVNPyfnydt4ZrUTM26XrpiWCWyOL66TplgTlnc4M+HksBHViz00cT5Mg8D3jnxtAgMx5wK3zvxsinC7uQ22ONaHPZ8sVQTJWR6p4TmJiebuF4PsIuQF8NnT7ARfAE99FMdINvIlR/zU5PiroamnboxToU2yEbTy62NJeFVUHau8QIpaAoP4pTbeJGjzhlMI2TTSZ066xZtQXhKrStYvR4neXRyyxzkN5zdze4fv5dqe6JlBi4c4kaGy59ij/Fd47jbFQDSiuJ95tgiCm3teRYUz/39YlzgUd84KbXmzyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KU5al8vOs/FBkr2VFZ31ZgIASh32pppJZo11zQWENdc=;
 b=I7L4L8jj/Pfv7BWLDH2YylR9wGzROSfOSXMikkbI5BcBHTMpUBVeSuhiyCGIn/qxbe92+vrW46sfo801gWwTkMNtak/P8VAOIvcGhu31ZtveYsbe3tv5Q8eTrpa0bsL0rLWqqRwY+RL8ONZrXTc7tAgMW344I5Pv1lV6rnvvVv18sUL3FDg7zs/nxsS6QjIW4bnT+wUP+y3ikitj3ukB74lfnGHh4ewxXsQ5PuTlgtfc6qPRDs0iL9SVB9VNMxzIUtwjaoBdzV0pLZPpN2fgFaJCWyToJAcNxW+Jb0N/zfMMf7T5mpQ5LXkO+P5bfGZQMhreL6QOULUygoWXu/UhQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KU5al8vOs/FBkr2VFZ31ZgIASh32pppJZo11zQWENdc=;
 b=Enw1rWVzL0sjWcNF/kg+TfDND0U3XGFm4DzKGieBraUH8TKE1Qg6XmydEemRkapOixHs80m/o246xnjnaZ7LSRLphK6t5xZ62SijYW1vhKZSQN+qE1g4eWyiVCeKfa3e83OFnPaKFMBQVVU6NA5vPWwDgjttglhyOqLEVzF/GE4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5937.eurprd04.prod.outlook.com (2603:10a6:208:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Fri, 24 Apr
 2020 12:46:45 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::8cc9:252:1c77:5860%2]) with mapi id 15.20.2937.012; Fri, 24 Apr 2020
 12:46:45 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v2 2/9] dt-bindings: net: add backplane dt bindings
Date:   Fri, 24 Apr 2020 15:46:24 +0300
Message-Id: <1587732391-3374-3-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0P190CA0025.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:208:190::35) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM0P190CA0025.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:190::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2937.13 via Frontend Transport; Fri, 24 Apr 2020 12:46:43 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7d05bc3f-3be4-41d8-da07-08d7e84d8b67
X-MS-TrafficTypeDiagnostic: AM0PR04MB5937:|AM0PR04MB5937:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5937BC825118FA2D98B11C2BFBD00@AM0PR04MB5937.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 03838E948C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39860400002)(346002)(376002)(366004)(52116002)(2616005)(86362001)(44832011)(6486002)(2906002)(8676002)(4326008)(66476007)(66946007)(6666004)(66556008)(8936002)(5660300002)(81156014)(6512007)(3450700001)(16526019)(956004)(186003)(6506007)(36756003)(316002)(26005)(966005)(7416002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iZjC5ixBDTWfQzlr/yn6cN9zFueNqHtak1rkJXbtByndcPa/cPHUb5w9ls8ZAJzlOKJNY9NUBbVJxfDd1B3oiigVYPih6Ggs8SMpLYku6/wKoQoQxxjAI8PPabo1730cpZsXjLoVINd9JF7QIuoAW5k+t/de4yfqMXYC/CI+4N1jzix0m6Hn2hy3ygCnlOtrUkzT9NVTyKc7vwRvC0lcbRvYJrlg3PMPF7SVavNictXza4EGfy2JvFpj5SoRM1H9xQEF/QcMj6HOYAxEL+MvaHOnHQJEVgjtP1QFPNBIhypeJdY0zJs2hYG7nq7pNzyay8H0tBWEdWF5bvbO0gJD43mkCq0IPhUpQ7xhbb35suHwmnxG7s+nuoWHMw8bVW0kXkQ7erLd1zgLj0OG0sSIatad7CXIKIZws8Ci336LWe0PppIaSi4pWo7orIQ6euKU174l4Be0sPx4LNbGsqbrKWsnFIqO2vAv6X2i6JsC7UKwjZ9YogHHV5/4gEbM6uNdfsHcrS8GVkQoMKgQr7enLw==
X-MS-Exchange-AntiSpam-MessageData: WVzQEXheQpM0lUVPyOJxhcWqs9ZCwiOq665QznA6rSKkKcGDNUhO9CaNJq0j2epnjN5JpXv6xVrUTOVFNVP7TviU8UnD5cnFz5aZpxtMpBTIjpLulY2vF4zwo+l8qasF2sFWrHlI+vVcIRC79ztSOw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7d05bc3f-3be4-41d8-da07-08d7e84d8b67
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Apr 2020 12:46:45.0626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PXR31337qukiDY5/zNK3ZactTvdYwDzVAwp9tWLYrdFA1fpfD+j/WQYQS6LqFA2zPbztr/rHxLhTq9tjaXYWSenyCP0I7ZS7QTfQmXvP59U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5937
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethernet backplane device tree bindings

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 .../bindings/net/ethernet-controller.yaml          |  3 +-
 .../devicetree/bindings/net/ethernet-phy.yaml      | 50 +++++++++++++++++++++
 .../devicetree/bindings/net/serdes-lane.yaml       | 51 ++++++++++++++++++++++
 Documentation/devicetree/bindings/net/serdes.yaml  | 44 +++++++++++++++++++
 4 files changed, 147 insertions(+), 1 deletion(-)
 create mode 100644 Documentation/devicetree/bindings/net/serdes-lane.yaml
 create mode 100644 Documentation/devicetree/bindings/net/serdes.yaml

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index ac471b6..541cee5 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -93,8 +93,9 @@ properties:
       - rxaui
       - xaui
 
-      # 10GBASE-KR, XFI, SFI
+      # 10GBASE-KR, 40GBASE-KR4, XFI, SFI
       - 10gbase-kr
+      - 40gbase-kr4
       - usxgmii
 
   phy-mode:
diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 5aa141c..436b5a7 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -161,6 +161,42 @@ properties:
     description:
       Specifies a reference to a node representing a SFP cage.
 
+  eq-algorithm:
+    description:
+      Specifies the desired equalization algorithm to be used
+      by the KR link training
+    oneOf:
+      - const: fixed
+        description:
+          Backplane KR using fixed coefficients meaning no
+          equalization algorithm
+      - const: bee
+        description:
+          Backplane KR using 3-Taps Bit Edge Equalization (BEE)
+          algorithm
+
+  eq-init:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 3
+    maxItems: 3
+    description:
+      Triplet of KR coefficients. Specifies the initialization
+      values for standard KR equalization coefficients used by
+      the link training (pre-cursor, main-cursor, post-cursor)
+
+  eq-params:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    description:
+      Variable size array of KR parameters. Specifies the HW
+      specific parameters used by the link training.
+
+  lane-handle:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Specifies a reference (or array of references) to a node
+      representing the desired SERDES lane (or lanes) used in
+      backplane mode.
+
 required:
   - reg
 
@@ -183,3 +219,17 @@ examples:
             reset-deassert-us = <2000>;
         };
     };
+  - |
+    ethernet {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        ethernet-phy@0 {
+            compatible = "ethernet-phy-ieee802.3-c45";
+            reg = <0x0>;
+            lane-handle = <&lane_d>;
+            eq-algorithm = "fixed";
+            eq-init = <0x2 0x29 0x5>;
+            eq-params = <0>;
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/serdes-lane.yaml b/Documentation/devicetree/bindings/net/serdes-lane.yaml
new file mode 100644
index 0000000..ce3581e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/serdes-lane.yaml
@@ -0,0 +1,51 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/serdes-lane.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Serdes Lane Binding
+
+maintainers:
+  - Florinel Iordache <florinel.iordache@nxp.com>
+
+properties:
+  $nodename:
+    pattern: "^lane(@[a-f0-9]+)?$"
+
+  compatible:
+    oneOf:
+      - const: lane-10g
+        description: Lane part of a 10G SerDes module
+      - const: lane-28g
+        description: Lane part of a 28G SerDes module
+
+  reg:
+    description:
+      Registers memory map offset and size for this lane
+
+  reg-names:
+    description:
+      Names of the register map given in "reg" node.
+
+examples:
+  - |
+    serdes1: serdes@1ea0000 {
+        compatible = "serdes-10g";
+        reg = <0x0 0x1ea0000 0 0x00002000>;
+        reg-names = "serdes", "serdes-10g";
+        little-endian;
+
+        #address-cells = <1>;
+        #size-cells = <1>;
+        lane_a: lane@800 {
+            compatible = "lane-10g";
+            reg = <0x800 0x40>;
+            reg-names = "lane", "serdes-lane";
+        };
+        lane_b: lane@840 {
+            compatible = "lane-10g";
+            reg = <0x840 0x40>;
+            reg-names = "lane", "serdes-lane";
+        };
+    };
diff --git a/Documentation/devicetree/bindings/net/serdes.yaml b/Documentation/devicetree/bindings/net/serdes.yaml
new file mode 100644
index 0000000..fd3da85
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/serdes.yaml
@@ -0,0 +1,44 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/serdes.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Serdes Module Binding
+
+maintainers:
+  - Florinel Iordache <florinel.iordache@nxp.com>
+
+properties:
+  $nodename:
+    pattern: "^serdes(@[a-f0-9]+)?$"
+
+  compatible:
+    oneOf:
+      - const: serdes-10g
+        description: SerDes module type of 10G
+      - const: serdes-28g
+        description: SerDes module type of 28G
+
+  reg:
+    description:
+      Registers memory map offset and size for this serdes module
+
+  reg-names:
+    description:
+      Names of the register map given in "reg" node.
+
+  little-endian:
+    description:
+      Specifies the endianness of serdes module
+      For complete definition see
+      Documentation/devicetree/bindings/common-properties.txt
+
+examples:
+  - |
+    serdes1: serdes@1ea0000 {
+        compatible = "serdes-10g";
+        reg = <0x0 0x1ea0000 0 0x00002000>;
+        reg-names = "serdes", "serdes-10g";
+        little-endian;
+    };
-- 
1.9.1


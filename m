Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F24E203825
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 15:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729093AbgFVNgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 09:36:09 -0400
Received: from mail-db8eur05on2051.outbound.protection.outlook.com ([40.107.20.51]:36110
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728259AbgFVNgE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 09:36:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PDZWT/syNaNtKKo/4+uD2ESS3WRpKuxiHlBg4ojctjrj8VFkN4w9oxvEkgccaa5YmWgBSEHPIUzoGqRddeQlUnBLxuZFeT2J4KJpAotd5wEaX5MGyRczC48jplppKCf7qG/5AKM8B5kXo4irCY1n7AnbhjRD+OylzAkrwuokpsdgaNWhmt0Oj9ACGePT5sifev+tBhK41YHjh8GgrxPHd5wNGs8K2OivCVN0Z1TNAtTiFPaivw0vQTfIQXEiUsDfBOHqV733cETyAcxK9Rs3SRqHbMSTJvD4vb1DTAfU3elU6P7GVUh2CxEEmlLZDxJpG7MkRVWVz+vBZNbmm+n6dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jPICUlJxMub93j+6Chh4K8Kuj2oMgzO4E6FeYty6SA=;
 b=cVzZRtBXexai/WsPzEZuXKZup8wyywAr+TXOXUC2R72RLWyZiQRWRkdHK03Bl5wrhY4kuslpstVh8TN2G2/ywvq34inesiHDv0pUXA15HCHILx5dY52YbrDDxTYoak/wgu6i+ljERBv7QkmMUWo8jjo9OdpHUQYfQ+IgtaO01KgPTJuxBKDQjJ8VbVbLUOdvYOg82hC0oDfa6e2ls+nKzJtmzcfpD4RMmKVIZnNEvfrck/2KxIy6nhDn5TggHWHtMRwodBC6fmJKPo73vivQdrcUe1+rdoyfnnx8s3V0E2dOGvd4WYbvrjhPphDKTa3dC1UEIGhqM9e13KdwUsKfQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9jPICUlJxMub93j+6Chh4K8Kuj2oMgzO4E6FeYty6SA=;
 b=KxqZvsqdNl5pwPLhOd1pnUawqh526dYGL1UJcewbPxrBA69B4HYSn/v4yxQY8uS6CJtXVl7juxASGHXp0XlceJrZB88AwloOsGKCQxvbtxjm6ya+aM5J+CgAJshPgv6p1eei64rHQeT6IA9W+UcijaoCmK8vufgxKVJnbrdaLTc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com (2603:10a6:208:119::33)
 by AM0PR04MB5075.eurprd04.prod.outlook.com (2603:10a6:208:bf::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Mon, 22 Jun
 2020 13:35:53 +0000
Received: from AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd]) by AM0PR04MB5443.eurprd04.prod.outlook.com
 ([fe80::f0b7:8439:3b5a:61bd%7]) with mapi id 15.20.3109.027; Mon, 22 Jun 2020
 13:35:53 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next v3 2/7] dt-bindings: net: add backplane dt bindings
Date:   Mon, 22 Jun 2020 16:35:19 +0300
Message-Id: <1592832924-31733-3-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
References: <1592832924-31733-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0086.eurprd07.prod.outlook.com
 (2603:10a6:207:6::20) To AM0PR04MB5443.eurprd04.prod.outlook.com
 (2603:10a6:208:119::33)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (83.217.231.2) by AM3PR07CA0086.eurprd07.prod.outlook.com (2603:10a6:207:6::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.3131.12 via Frontend Transport; Mon, 22 Jun 2020 13:35:52 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [83.217.231.2]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 765a6a81-38b9-4111-7d59-08d816b12f9f
X-MS-TrafficTypeDiagnostic: AM0PR04MB5075:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5075C2E31748EBC8298AC1FFFB970@AM0PR04MB5075.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0442E569BC
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8zQEWGWd4NUxCgIVEPSHJH82JxyR9TOs2XxKb1SWAuSGVgw/KBPhcHm5K4VTWXaKcb5BsXBF4xuFX1mJy/P4nZn8IYKgwEKr0GYvw6wAx6+6oS8z0l4hvLp8QCGyVG32P9Rj9+B75bBhrNOGbEpoUrEyRtg4FLvE7/6wMVYRDmF5uGsvTk4ldiEqoJWeuAqLTLWSRmhdaS+BhwV4GKYNe2IY+aLZ6vM0Gcf0AiAXNUZy+I1RQgEfBAA46EEuZ9jpaCkbnzIDPIEyDvCDUDZTEtOAuc7Pxkw7LJnNDWuxYipgV3xALCeY/sQeuHVwu6piZOKEWl/qfxoD9wzOLgCcGT6bGE2Jwx3v9d3K9kXKCkA7EuUxlA4lqMDa3MdFRdF92BPiSDPaGCe6n1vkMgYGiA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5443.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(376002)(346002)(39860400002)(366004)(396003)(66476007)(66556008)(66946007)(83380400001)(5660300002)(2616005)(956004)(44832011)(86362001)(6666004)(2906002)(8676002)(6512007)(52116002)(16526019)(186003)(26005)(3450700001)(6506007)(4326008)(6486002)(966005)(316002)(478600001)(8936002)(7416002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: /Py8OFL2uNPETKk1FbAAYXfFM92aDU/qK/Xq+UV8ZE4gEUku/HfsF62nCxEPTGkBp3zMtjqeqmnILYu96zRw7+cb965xVRfCd53i5dSK0U6zKm7nKV/rYeaLvEo19bznoxH3oRTUGZBntLGy+LxZbxhq0aeC1xc0HFXtIz+Ma7nYgFj8UKHcxgGJsqDD8E5B3aX7uObUyqTuK4K/kqScnoqmY2LcEROQkKuoZAOnhDkD32C7YrRWFOTYvFrFm9F9mGwOhxMW3x6DC4P5L8+FxI/nALuKDIwaTGXAWkZyuQRSAmcX3wJyNbfSY5WQb1DXPYbRPJj8OADFP0ssgxSKadZFneLjRhIo6xW3nI9bZTaVdkbTmT1oTs1JwlLNF5WfXvFdDbGZUHVk11Zc8WVSnhRNbKidFhn+W6Y0C7pyh+cScgdNfowzI2SLP2uHSRlAQD4Rz3j97nUalYgsO2wKuYFNkaUk6Bzt9hl/kEyuDq0=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 765a6a81-38b9-4111-7d59-08d816b12f9f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Jun 2020 13:35:53.8228
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ffNJP54skKIFVxSIfSjDOqFOqomNM+r278FaY7CE+U9DhyURi72jnpajlaV/tonUf0ncX1zcrB+Zqpk1Dl0nZxgh43dwsZp6x4DuGoefoHU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5075
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethernet backplane device tree bindings

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 .../bindings/net/ethernet-controller.yaml          |  7 ++-
 .../devicetree/bindings/net/ethernet-phy.yaml      | 50 ++++++++++++++++++++++
 .../devicetree/bindings/net/serdes-lane.yaml       | 49 +++++++++++++++++++++
 Documentation/devicetree/bindings/net/serdes.yaml  | 42 ++++++++++++++++++
 4 files changed, 146 insertions(+), 2 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/serdes-lane.yaml
 create mode 100644 Documentation/devicetree/bindings/net/serdes.yaml

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index 1c44740..6c4c7d8 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -91,10 +91,13 @@ properties:
       - rxaui
       - xaui
 
-      # 10GBASE-KR, XFI, SFI
-      - 10gbase-kr
+      # 10GBASE-R, XFI, SFI
+      - 10gbase-r
       - usxgmii
 
+      # 10GBASE-KR (10G Ethernet Backplane with autonegotiation)
+      - 10gbase-kr
+
   phy-mode:
     $ref: "#/properties/phy-connection-type"
 
diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index 9b1f114..a23a7d6 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -162,6 +162,42 @@ properties:
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
 
@@ -184,3 +220,17 @@ examples:
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
index 0000000..d83a6a9
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/serdes-lane.yaml
@@ -0,0 +1,49 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
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
index 0000000..ed77689c
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/serdes.yaml
@@ -0,0 +1,42 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
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


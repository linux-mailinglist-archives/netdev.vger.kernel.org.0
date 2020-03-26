Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A681194066
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 14:52:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgCZNwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 09:52:01 -0400
Received: from mail-eopbgr60078.outbound.protection.outlook.com ([40.107.6.78]:40267
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726359AbgCZNwA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Mar 2020 09:52:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IZZyjiEiy9uXFLlvZz01tzn/8NwKiZE0h1teSGYwe2QWxTaEvNfr5uOynHu0sRLFA450EFFjOQGxvfdvZVhfIFzsz1wKRv629YLKhUSxjg96cQW7zqDjBHizHz3UWUsZ5JhS6KZvIlb9Kp88LtvYRkYacSMKa/yrGWMoYzmXtCKKRS32Dn/KXKLqzU2A8po7sXh6YPs+MHiTNXC9Gwx35S/GbnoDphzSA7cPh2+pEHSvyOtmH5+uKdc9klDpu/NvHX1FhAgmzKxu5t46tuzqqZhFiEiT0GIlGFEyNCWSwtI9JcxHslZL7tDXU2sW5e4WEsuVROhyrq8tPMrEQv+0YA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FFivp8tz3G38wecI4lXkwHnDs4U1tWrqQQc5c6et3I=;
 b=Ef5vyuLwYori/qgmn8iKLJFpf77fE9JZ8awwiA/JpwD3wCkrpE24a3ei9vEZNnYhKxFJ8eaKfh7IBraFA3GlQr4vyTayiedMlKUpFQoiQO2RrqesbY346uvh2l/SlMXIAXtg8/7kcmTBd7qa/teHODf8G1reWOU4p0PQjMmbNmGKxa1Q1PNA1wvLbqqltXtKVQxjd0hImZfjBKRdHHXS23MDkLfUfkmcfMRYnfqri+PvlDXHd+Aaq5CqQQQM/pCsVb3oC4Py6KrjgHSJeH4U+iYO1l9P3SD6QP86xrm5GeizyjP61GxwKq+0dI1fQV910gaVX6PwxdXHyYHffV6PqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8FFivp8tz3G38wecI4lXkwHnDs4U1tWrqQQc5c6et3I=;
 b=IuJVFRF2Ov6+8g9rybeKI6I+2Y5SHvDKp399x7e4H+SMPZouen8XC+1vLD1zmUYrhpxB09Er0Y9MmrItbStXpzjNSbc7J3WC9OtF6/p+Zk059pGmOFTlAO/D/wKoxdvNLvCotA4G7pfttqGFjP7MiWQ8ARinioHa8ADMCgCjZ50=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=florinel.iordache@nxp.com; 
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com (20.178.122.87) by
 VI1PR04MB4272.eurprd04.prod.outlook.com (10.171.182.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.20; Thu, 26 Mar 2020 13:51:57 +0000
Received: from VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8]) by VI1PR04MB5454.eurprd04.prod.outlook.com
 ([fe80::69f6:5d59:b505:a6c8%3]) with mapi id 15.20.2835.023; Thu, 26 Mar 2020
 13:51:57 +0000
From:   Florinel Iordache <florinel.iordache@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        robh+dt@kernel.org, mark.rutland@arm.com, kuba@kernel.org,
        corbet@lwn.net, shawnguo@kernel.org, leoyang.li@nxp.com,
        madalin.bucur@oss.nxp.com, ioana.ciornei@nxp.com,
        linux-kernel@vger.kernel.org,
        Florinel Iordache <florinel.iordache@nxp.com>
Subject: [PATCH net-next 2/9] dt-bindings: net: add backplane dt bindings
Date:   Thu, 26 Mar 2020 15:51:15 +0200
Message-Id: <1585230682-24417-3-git-send-email-florinel.iordache@nxp.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
References: <1585230682-24417-1-git-send-email-florinel.iordache@nxp.com>
Reply-to: florinel.iordache@nxp.com
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0142.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::47) To VI1PR04MB5454.eurprd04.prod.outlook.com
 (2603:10a6:803:d1::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from fsr-ub1464-128.ea.freescale.net (89.37.124.34) by AM0PR01CA0142.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::47) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.20.2835.20 via Frontend Transport; Thu, 26 Mar 2020 13:51:55 +0000
X-Mailer: git-send-email 1.9.1
X-Originating-IP: [89.37.124.34]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5dea79be-c766-4c07-8da8-08d7d18cd92f
X-MS-TrafficTypeDiagnostic: VI1PR04MB4272:|VI1PR04MB4272:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB427255C212EC0D154E5C52ABFBCF0@VI1PR04MB4272.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-Forefront-PRVS: 0354B4BED2
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(366004)(396003)(26005)(478600001)(186003)(16526019)(956004)(81166006)(3450700001)(36756003)(81156014)(8936002)(44832011)(4326008)(8676002)(5660300002)(2616005)(7416002)(2906002)(66946007)(86362001)(6486002)(966005)(66556008)(316002)(6506007)(6512007)(6666004)(66476007)(52116002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB4272;H:VI1PR04MB5454.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
Received-SPF: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gkLON4Mzbk2cX/7Rq5p5FXCX0XD2i1kyABJ1LRETMLah4vCQu/hJFXu0o2LhrO5y2fP55VM+HtEfIGXSkMv6GTH2OjZ3+BYvd/ceIaM04F4i1ErRC91mp5jVit8CxCLsMHRoaI2UND822Znu76ENHR1AZfl48dvxT2KvjM3jSNYxjI/EqBw3cTKyh1Tlt371zwOVbczTApcBKuf5GhEIzCMShUGZB83q4PPU667I3gXc0PX/vi3k+jmWQvgcYyRZduBVRZVWTRrsYrcA4Tnn3a4nuOU+2C9ko8PQ7JVTR+12TI932J7sssytGQ3jTVRj+l2F/tyNBNjOd8+0u83jq0TmLsXTaUfZzOwnV17nx01TIr1fWj7d9HjtnmaAN3pfB7hXOnkAXDGNq9NHYJk4jp7CGw/WjvOfTrxSBXupQ/wKwotF+f0KHryuIW9rpkfh5CDcYbt4ASikbx/OKMpzYCSBe4j9rzFZztowwGof1lB6M5yf2ivQgWyQZK8noGaB
X-MS-Exchange-AntiSpam-MessageData: dY6QC0acehI2kBNxKNaH5nyXdmjTfeSKhgdhuwXF2YrQmZHyG3DUBhPUBFG69uXWyylD76dvDlmw0gQKzzxuh+hUU45Uytm2MxKJCMlB4JEfBZhnmzc3PEvkeuJtQ2mahEiVB26zpktblb9O1jSJdw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5dea79be-c766-4c07-8da8-08d7d18cd92f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Mar 2020 13:51:56.8961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zgD/RQKAPVxlVfHEsrEXvZFviVSpigvXXu/EMFZo5ku1VNGLD3/vvjEc8LJvpZfO1SD/5a0ngy40eAWUW7owhW1SfIQ5Ez39PKKF1I8xhR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB4272
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add ethernet backplane device tree bindings

Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
---
 .../bindings/net/ethernet-controller.yaml          |  3 +-
 .../devicetree/bindings/net/ethernet-phy.yaml      | 53 +++++++++++++
 Documentation/devicetree/bindings/net/serdes.yaml  | 90 ++++++++++++++++++++++
 3 files changed, 145 insertions(+), 1 deletion(-)
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
index 8927941..2fb377e 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -158,6 +158,42 @@ properties:
     description:
       Specifies a reference to a node representing a SFP cage.
 
+  eq-algorithm:
+    oneOf:
+      - const: fixed
+        description:
+          Backplane KR using fixed coefficients meaning no
+          equalization algorithm
+      - const: bee
+        description:
+          Backplane KR using 3-Taps Bit Edge Equalization (BEE)
+          algorithm
+        description:
+          Specifies the desired equalization algorithm to be used
+          by the KR link training
+
+  eq-init:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+    minItems: 3
+    maxItems: 3
+        description:
+          Triplet of KR coefficients. Specifies the initialization
+	  values for standard KR equalization coefficients used by
+	  the link training: pre-cursor, post-cursor, main-cursor
+
+  eq-params:
+    $ref: /schemas/types.yaml#/definitions/uint32-array
+        description:
+          Variable size array of KR parameters. Specifies the HW
+	  specific parameters used by the link training
+
+  lane-handle:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Specifies a reference (or array of references) to a node
+      representing the desired SERDES lane (or lanes) used in
+      backplane mode
+
 required:
   - reg
 
@@ -180,3 +216,20 @@ examples:
             reset-deassert-us = <2000>;
         };
     };
+  - |
+    /* Backplane configurations for specific setup */
+    &mdio9 {
+        bpphy6: ethernet-phy@0 {
+            compatible = "ethernet-phy-ieee802.3-c45";
+            reg = <0x0>;
+            lane-handle = <&lane_d>; /* use lane D */
+            eq-algorithm = "bee";
+            /* 10G Short cables setup: up to 30 cm cable */
+            eq-init = <0x2 0x5 0x29>;
+            eq-params = <0>;
+        };
+    };
+    &mac9 {
+        phy-connection-type = "10gbase-kr";
+        phy-handle = <&bpphy6>;
+    };
diff --git a/Documentation/devicetree/bindings/net/serdes.yaml b/Documentation/devicetree/bindings/net/serdes.yaml
new file mode 100644
index 0000000..965152f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/serdes.yaml
@@ -0,0 +1,90 @@
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
+      Should be one of the following according to serdes type:
+      "serdes", "serdes-10g", "serdes-28g"
+
+  little-endian:
+    description:
+      Specifies the endianness of serdes module
+      For complete definition see:
+      Documentation/devicetree/bindings/common-properties.txt
+
+  #address-cells:
+    description: Must be <1>
+
+  #size-cells:
+    description: Must be <1>
+
+  ranges:
+    description:
+      Address range of serdes module.
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
+      Should be one of the following: "lane", "serdes-lane"
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
+        ranges = <0x0 0x00 0x1ea0000 0x00002000>;
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
-- 
1.9.1


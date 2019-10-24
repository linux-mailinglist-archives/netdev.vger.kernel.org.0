Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4EFE2F56
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 12:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392696AbfJXKrZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 06:47:25 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:45406 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732651AbfJXKrZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 06:47:25 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id x9OAlLHa005491;
        Thu, 24 Oct 2019 05:47:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1571914041;
        bh=+DDrtZysaxPLyifnU1qVZm7pk/NXlX6sB+O3fJqQGJw=;
        h=From:To:CC:Subject:Date;
        b=F9I02n+Nwc8puY6dhryjllP809hT/3MW+IUnaoEfVQkiRfb8M0MZLusu/sl/4jIut
         mmbsI/el3wE8HhS/FVfki1UY5DPbVuaTGr07M+AG6H8nqtbkAz/Y/9iuU7j/QbN1uy
         BMp4sJrpljwu5mjnOHlwtUwRFsfvKl2rm0fj91Zo=
Received: from DLEE113.ent.ti.com (dlee113.ent.ti.com [157.170.170.24])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x9OAlLAt048090
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 24 Oct 2019 05:47:21 -0500
Received: from DLEE114.ent.ti.com (157.170.170.25) by DLEE113.ent.ti.com
 (157.170.170.24) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 24
 Oct 2019 05:47:11 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 24 Oct 2019 05:47:11 -0500
Received: from localhost (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x9OAlJNe039669;
        Thu, 24 Oct 2019 05:47:20 -0500
From:   Grygorii Strashko <grygorii.strashko@ti.com>
To:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
CC:     Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: [RFC PATCH] dt-bindings: net: davinci-mdio: convert bindings to json-schema
Date:   Thu, 24 Oct 2019 13:47:30 +0300
Message-ID: <20191024104730.17708-1-grygorii.strashko@ti.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we have the DT validation in place, let's convert the device tree
bindings for the TI SoC Davinci/OMAP/Keystone2 MDIO Controllerr over to a
YAML schemas.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
This my first attempt to work with YAML schemas, hence RFC.

 .../bindings/net/ti,davinci-mdio.yaml         | 64 +++++++++++++++++++
 1 file changed, 64 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml

diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
new file mode 100644
index 000000000000..e51054d2e0fa
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
@@ -0,0 +1,64 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/ti,davinci-mdio.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: TI SoC Davinci/Keystone2 MDIO Controller
+
+maintainers:
+  - Grygorii Strashko <grygorii.strashko@ti.com>
+
+description:
+  TI SoC Davinci/Keystone2 MDIO Controller Device Tree Bindings
+
+allOf:
+  - $ref: "mdio.yaml#"
+
+properties:
+  compatible:
+    oneOf:
+       - const: ti,davinci_mdio
+       - items:
+         - const: ti,keystone_mdio
+         - const: ti,davinci_mdio
+       - items:
+         - const: ti,cpsw-mdio
+         - const: ti,davinci_mdio
+       - items:
+         - const: ti,am4372-mdio
+         - const: ti,cpsw-mdio
+         - const: ti,davinci_mdio
+
+  reg:
+    maxItems: 1
+
+  bus_freq:
+      maximum: 2500000
+      description:
+        Mdio Bus frequency
+
+  ti,hwmods:
+    description: TI hwmod name
+    deprecated: true
+    allOf:
+      - $ref: /schemas/types.yaml#/definitions/string-array
+      - items:
+          const: davinci_mdio
+
+required:
+  - compatible
+  - reg
+  - bus_freq
+  - "#address-cells"
+  - "#size-cells"
+
+examples:
+  - |
+    davinci_mdio: mdio@4a101000 {
+         compatible = "ti,davinci_mdio";
+         #address-cells = <1>;
+         #size-cells = <0>;
+         reg = <0x4A101000 0x1000>;
+         bus_freq = <1000000>;
+    };
-- 
2.17.1


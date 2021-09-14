Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6632840BA26
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 23:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234593AbhINVWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 17:22:46 -0400
Received: from mx3.wp.pl ([212.77.101.9]:14914 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234918AbhINVWk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 17:22:40 -0400
Received: (wp-smtpd smtp.wp.pl 13353 invoked from network); 14 Sep 2021 23:21:20 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1631654480; bh=6jrua0eS5ienxyZS61iro3wSOi/DKo1d2lOYonLE/w0=;
          h=From:To:Subject;
          b=S845hWxbInVvbtB9lmSMs0xLHkP+w4fj6k/L83w2LQ8CYrjA7iJPA6rWjkHl/Nd7m
           gJbl17UWpoEut9lhHiuqc0twImc/MCeIXKGxt5+9m71wJA3P12aBtM9jDRUgEfQafN
           Jy3CgJOXRRxufOl8iGM1y6qMLonWhVv1fVIOPUHc=
Received: from 46.204.52.243.nat.umts.dynamic.t-mobile.pl (HELO LAPTOP-OLEK.Free) (olek2@wp.pl@[46.204.52.243])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <john@phrozen.org>; 14 Sep 2021 23:21:20 +0200
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     john@phrozen.org, tsbogend@alpha.franken.de, olek2@wp.pl,
        maz@kernel.org, ralf@linux-mips.org, ralph.hempel@lantiq.com,
        davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        hauke@hauke-m.de, dev@kresin.me, arnd@arndb.de, jgg@ziepe.ca,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 6/8] dt-bindings: net: lantiq-xrx200-net: convert to the json-schema
Date:   Tue, 14 Sep 2021 23:21:03 +0200
Message-Id: <20210914212105.76186-6-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210914212105.76186-1-olek2@wp.pl>
References: <20210914212105.76186-1-olek2@wp.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: f8db21619301958f4b0c02e7b1612c2c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [wcMh]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Lantiq PMAC Device Tree binding documentation to json-schema.

Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
---
 .../bindings/net/lantiq,xrx200-net.txt        | 21 -------
 .../bindings/net/lantiq,xrx200-net.yaml       | 59 +++++++++++++++++++
 2 files changed, 59 insertions(+), 21 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/lantiq,xrx200-net.txt
 create mode 100644 Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml

diff --git a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.txt b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.txt
deleted file mode 100644
index 5ff5e68bbbb6..000000000000
--- a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.txt
+++ /dev/null
@@ -1,21 +0,0 @@
-Lantiq xRX200 GSWIP PMAC Ethernet driver
-==================================
-
-Required properties:
-
-- compatible	: "lantiq,xrx200-net" for the PMAC of the embedded
-		: GSWIP in the xXR200
-- reg		: memory range of the PMAC core inside of the GSWIP core
-- interrupts	: TX and RX DMA interrupts. Use interrupt-names "tx" for
-		: the TX interrupt and "rx" for the RX interrupt.
-
-Example:
-
-ethernet@e10b308 {
-	#address-cells = <1>;
-	#size-cells = <0>;
-	compatible = "lantiq,xrx200-net";
-	reg = <0xe10b308 0xcf8>;
-	interrupts = <73>, <72>;
-	interrupt-names = "tx", "rx";
-};
diff --git a/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
new file mode 100644
index 000000000000..7bc074a42369
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/lantiq,xrx200-net.yaml
@@ -0,0 +1,59 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/lantiq,xrx200-net.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Lantiq xRX200 GSWIP PMAC Ethernet driver
+
+maintainers:
+  - Hauke Mehrtens <hauke@hauke-m.de>
+
+properties:
+  $nodename:
+    pattern: "^ethernet@[0-9a-f]+$"
+
+  compatible:
+    const: lantiq,xrx200-net
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    items:
+      - description: TX interrupt
+      - description: RX interrupt
+
+  interrupt-names:
+    items:
+      - const: tx
+      - const: rx
+
+  '#address-cells':
+    const: 1
+
+  '#size-cells':
+    const: 0
+
+required:
+  - compatible
+  - reg
+  - interrupt-parent
+  - interrupts
+  - interrupt-names
+  - "#address-cells"
+  - "#size-cells"
+
+additionalProperties: false
+
+examples:
+  - |
+    ethernet@e10b308 {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        compatible = "lantiq,xrx200-net";
+        reg = <0xe10b308 0xcf8>;
+        interrupt-parent = <&icu0>;
+        interrupts = <73>, <72>;
+        interrupt-names = "tx", "rx";
+    };
-- 
2.30.2


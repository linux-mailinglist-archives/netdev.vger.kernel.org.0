Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFFF4809EC
	for <lists+netdev@lfdr.de>; Tue, 28 Dec 2021 15:26:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233837AbhL1O0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 09:26:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233706AbhL1O0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 09:26:19 -0500
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D94C06173E;
        Tue, 28 Dec 2021 06:26:17 -0800 (PST)
Received: from mwalle01.kontron.local. (unknown [IPv6:2a02:810b:4340:43bf:fa59:71ff:fe9b:b851])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 29F19223ED;
        Tue, 28 Dec 2021 15:26:15 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1640701575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=02iOmurDIl5gzz8NoU1dQeDN4gDFtGDQPI42B09jExw=;
        b=S8Qa3rFSfHGbDtfs00//SU0AqVJwqu3c15mjlL9u1qDcnIj8885OuUt4vYGhjJ3kBH48Jz
        S1XnkMikSYyQW3mkQkx/hIsvmSmvMqQ0WwanA/M1k9eLQaDtdX+xrGa+OKGSTSBo41IZnl
        E95WFs7BTat/Gez3vTF1RRgml0Ip73g=
From:   Michael Walle <michael@walle.cc>
To:     linux-mtd@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org
Cc:     Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, Michael Walle <michael@walle.cc>
Subject: [PATCH 2/8] dt-bindings: nvmem: add transformation bindings
Date:   Tue, 28 Dec 2021 15:25:43 +0100
Message-Id: <20211228142549.1275412-3-michael@walle.cc>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211228142549.1275412-1-michael@walle.cc>
References: <20211228142549.1275412-1-michael@walle.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Just add a simple list of the supported devices which need a nvmem
transformations.

Also, since the compatible string is prepended to the actual nvmem
compatible string, we need to match using "contains" instead of an exact
match.

Signed-off-by: Michael Walle <michael@walle.cc>
---
 .../devicetree/bindings/mtd/mtd.yaml          |  7 +--
 .../bindings/nvmem/nvmem-transformations.yaml | 46 +++++++++++++++++++
 2 files changed, 50 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml

diff --git a/Documentation/devicetree/bindings/mtd/mtd.yaml b/Documentation/devicetree/bindings/mtd/mtd.yaml
index 376b679cfc70..0291e439b6a6 100644
--- a/Documentation/devicetree/bindings/mtd/mtd.yaml
+++ b/Documentation/devicetree/bindings/mtd/mtd.yaml
@@ -33,9 +33,10 @@ patternProperties:
 
     properties:
       compatible:
-        enum:
-          - user-otp
-          - factory-otp
+        contains:
+          enum:
+            - user-otp
+            - factory-otp
 
     required:
       - compatible
diff --git a/Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml b/Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml
new file mode 100644
index 000000000000..8c8d85fd6d27
--- /dev/null
+++ b/Documentation/devicetree/bindings/nvmem/nvmem-transformations.yaml
@@ -0,0 +1,46 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/nvmem/nvmem-transformations.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NVMEM transformations Device Tree Bindings
+
+maintainers:
+  - Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
+
+description: |
+  This is a list NVMEM devices which need transformations.
+
+properties:
+  compatible:
+    oneOf:
+      - items:
+        - enum:
+          - kontron,sl28-vpd
+        - const: user-otp
+      - const: user-otp
+
+required:
+  - compatible
+
+additionalProperties: true
+
+examples:
+  - |
+    otp-1 {
+            compatible = "kontron,sl28-vpd", "user-otp";
+            #address-cells = <1>;
+            #size-cells = <1>;
+
+            serial@2 {
+                    reg = <2 15>;
+            };
+
+            base_mac_address: base-mac-address@17 {
+                    #nvmem-cell-cells = <1>;
+                    reg = <17 6>;
+            };
+    };
+
+...
-- 
2.30.2


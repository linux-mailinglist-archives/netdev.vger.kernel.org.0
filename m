Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19811610D03
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 11:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJ1JXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 05:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbiJ1JXq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 05:23:46 -0400
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ECBF1C5A44;
        Fri, 28 Oct 2022 02:23:45 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 74CD610000F;
        Fri, 28 Oct 2022 09:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1666949024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MZ/yZgTa81hnw0HFvxGrTGClMz2ZbHdXcriFnwHnOiY=;
        b=i7ZnyCOsiLCqD552SFIgCXU24QxcRIL4DmvTxIl6B/HkA02h0XOVyxFfcPBq/APLZfoUEz
        Wbk6GJ5S5jGHO3UcOiPn+o1V2OLbeSrc52eJdlCeaOTdU3wWlRFwDqINCy0g8Xdt/Gn80B
        IC8RfqRL//NKLDfBQc537fZGIoTd2G4beS64yzSpstN+qekRe4FXnyES01qmeNw1dBZz8i
        iCTrkTKt6+jHVhbNg5XF+fNgB4CRBK1ujxPDr4lVI2Xx5ffCQESPqyDQBn2ovUPylDor09
        HxTk4LNhiwaaaGM9+aI8pf+WDPuJsDZbAWgI8M/jnv2qjbiZuIVwrzLfU9Zigw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        <linux-kernel@vger.kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org
Cc:     Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 2/5] dt-bindings: nvmem: add YAML schema for the ONIE tlv layout
Date:   Fri, 28 Oct 2022 11:23:34 +0200
Message-Id: <20221028092337.822840-3-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221028092337.822840-1-miquel.raynal@bootlin.com>
References: <20221028092337.822840-1-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add a schema for the ONIE tlv NVMEM layout that can be found on any ONIE
compatible networking device.

Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
---
 .../nvmem/layouts/onie,tlv-layout.yaml        | 96 +++++++++++++++++++
 1 file changed, 96 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.yaml

diff --git a/Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.yaml b/Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.yaml
new file mode 100644
index 000000000000..388547d46646
--- /dev/null
+++ b/Documentation/devicetree/bindings/nvmem/layouts/onie,tlv-layout.yaml
@@ -0,0 +1,96 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/nvmem/layouts/onie,tlv-layout.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: NVMEM layout of the ONIE tlv table
+
+maintainers:
+  - Miquel Raynal <miquel.raynal@bootlin.com>
+
+description:
+  Modern networking hardware implementing the Open Compute Project ONIE
+  infrastructure shall provide a non-volatile memory with a table whose the
+  content is well specified and gives many information about the manufacturer
+  (name, country of manufacture, etc) as well as device caracteristics (serial
+  number, hardware version, mac addresses, etc). The underlaying device type
+  (flash, EEPROM,...) is not specified. The exact location of each value is also
+  dynamic and should be discovered at run time because it depends on the
+  parameters the manufacturer decided to embed.
+
+allOf:
+  - $ref: "../nvmem.yaml#"
+
+select:
+  properties:
+    compatible:
+      contains:
+        const: onie,tlv-layout
+  required:
+    - compatible
+
+properties:
+  compatible: true
+
+  product-name: true
+
+  part-number: true
+
+  serial-number: true
+
+  mac-address:
+    type: object
+    description:
+      Base MAC address for all on-module network interfaces. The first
+      argument of the phandle will be treated as an offset.
+
+    properties:
+      "#nvmem-cell-cells":
+        const: 1
+
+    additionalProperties: false
+
+  manufacture-date: true
+
+  device-version: true
+
+  label-revision: true
+
+  platforn-name: true
+
+  onie-version: true
+
+  num-macs: true
+
+  manufacturer: true
+
+  country-code: true
+
+  vendor: true
+
+  diag-version: true
+
+  service-tag: true
+
+  vendor-extension: true
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+        onie {
+            compatible = "onie,tlv-layout", "vendor,device";
+
+            serial_number: serial-number {
+            };
+
+            mac_address: mac-address {
+                #nvmem-cell-cells = <1>;
+            };
+        };
+
+...
-- 
2.34.1


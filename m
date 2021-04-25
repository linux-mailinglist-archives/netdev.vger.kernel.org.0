Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAEE236A3B0
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 02:31:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229882AbhDYAbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Apr 2021 20:31:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhDYAbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Apr 2021 20:31:33 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4190C061574
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 17:30:52 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 124so1835747lff.5
        for <netdev@vger.kernel.org>; Sat, 24 Apr 2021 17:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GWMZ3joFDXAfixsaT3M1mL9BXCqmaTfhrxyajNcq/7M=;
        b=Nse9hLCSJYQ8gYGGbutxJq0dJTWct2loAtnwFpLBlNUPSClQLOb4Rebe77I5YgTh3O
         xwKgfyf+hg6kJNaQbvPDkggyFtqhzt0Ej9r6Jym1oos+JJB0G23f8p+K7lEh9Vcnjq3s
         rWpN8digbAv+eVpqIqqdwN7Nqz9YTQRwUcdLLQstPjTZYmPs00Y9QfuWnFpULQFhwpMm
         nq/4LxDvHT8kfFNVJhcXCdRoJyW8C/WJ0R+UAJ6f2I0dNTLyv6Y9U6fbSNtoQzc3OzzD
         LewKAxtCZivQuIAJDB4blLvTHtlV3nnj/HKnLpw5z9DFkpzPp5Z2m+DxavI211WxP9+y
         ru2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GWMZ3joFDXAfixsaT3M1mL9BXCqmaTfhrxyajNcq/7M=;
        b=jxTRg0WMcFRjlQevInt+XJjpsqBAZ7LZWVJMnN/VHHQtnq1WqGpIaiLIcYBEfc+AXe
         FIgGiZjAeu/UPWPerHte/wCnuBoVg1Dv9EPo8jTT1lp//FwZlv3feKYSdNMUUVWF0ihM
         C5NFR40uaojHrrCocc17G5HKB33SEAEmqRMHkQZAMVNKKkvMJYO60soNw0roF99PUNrt
         RUB9du7XF9NFQhDLRNl8DgabvsobZbv6swMeDBuUEWfff46vQ0+EW5vS4YZsEPBrJ5PQ
         jK/H9/3shzSkicD8fu10e3V73oFcUXIsuklT2Mph4sWZwshW0J4MtVWBmQ9t87znxCFF
         9TIw==
X-Gm-Message-State: AOAM530q9uSwbwtrxEcIxNnMi7Q45s8oBeHzdznmfieTnxQWwlIUmFl3
        pJU89xfNb2NBTh+ziOIAG+cQVyaWd9qwxg==
X-Google-Smtp-Source: ABdhPJyzfYYlfkJ0nNn+UV6oub7WXr9QW5+g6MlLlaikSiTLeHGA44Wrqo4MnsOaJEKrUGX1CEMEQQ==
X-Received: by 2002:a05:6512:3e1:: with SMTP id n1mr7434540lfq.31.1619310650872;
        Sat, 24 Apr 2021 17:30:50 -0700 (PDT)
Received: from localhost.localdomain (c-fdcc225c.014-348-6c756e10.bbcust.telenor.se. [92.34.204.253])
        by smtp.gmail.com with ESMTPSA id t5sm950352lfe.211.2021.04.24.17.30.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Apr 2021 17:30:50 -0700 (PDT)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>, devicetree@vger.kernel.org
Subject: [PATCH 1/3 net-next v4] net: ethernet: ixp4xx: Add DT bindings
Date:   Sun, 25 Apr 2021 02:30:36 +0200
Message-Id: <20210425003038.2937498-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds device tree bindings for the IXP4xx ethernet
controller with optional MDIO bridge.

Cc: Zoltan HERPAI <wigyori@uid0.hu>
Cc: Raylynn Knight <rayknight@me.com>
Cc: devicetree@vger.kernel.org
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v3->v4:
- Use a phandle to reference the NPE
- Make a more verbose example with two ethernet devices
  sharing a MDIO bus on just one of them
- Spelling fix
ChangeLog v2->v3:
- Designate phy nodes with ethernet-phy@
- Include phy-mode in the schema
ChangeLog v1->v2:
- Add schema for the (optional) embedded MDIO bus inside
  the ethernet controller in an "mdio" node instead of just
  letting the code randomly populate and present it to
  the operating system.
- Reference the standard schemas for ethernet controller and
  MDIO buses.
- Add intel,npe to indentify the NPE unit used with each
  ethernet adapter.
---
 .../bindings/net/intel,ixp4xx-ethernet.yaml   | 102 ++++++++++++++++++
 1 file changed, 102 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml

diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
new file mode 100644
index 000000000000..f2e91d1bf7d7
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.yaml
@@ -0,0 +1,102 @@
+# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
+# Copyright 2018 Linaro Ltd.
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/intel,ixp4xx-ethernet.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Intel IXP4xx ethernet
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+maintainers:
+  - Linus Walleij <linus.walleij@linaro.org>
+
+description: |
+  The Intel IXP4xx ethernet makes use of the IXP4xx NPE (Network
+  Processing Engine) and the IXP4xx Queue Manager to process
+  the ethernet frames. It can optionally contain an MDIO bus to
+  talk to PHYs.
+
+properties:
+  compatible:
+    const: intel,ixp4xx-ethernet
+
+  reg:
+    maxItems: 1
+    description: Ethernet MMIO address range
+
+  queue-rx:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the RX queue on the NPE
+
+  queue-txready:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the TX READY queue on the NPE
+
+  phy-mode: true
+
+  phy-handle: true
+
+  intel,npe-handle:
+    $ref: '/schemas/types.yaml#/definitions/phandle-array'
+    maxItems: 1
+    description: phandle to the NPE this ethernet instance is using
+      and the instance to use in the second cell
+
+  mdio:
+    type: object
+    $ref: "mdio.yaml#"
+    description: optional node for embedded MDIO controller
+
+required:
+  - compatible
+  - reg
+  - queue-rx
+  - queue-txready
+  - intel,npe-handle
+
+additionalProperties: false
+
+examples:
+  - |
+    npe: npe@c8006000 {
+      compatible = "intel,ixp4xx-network-processing-engine";
+      reg = <0xc8006000 0x1000>, <0xc8007000 0x1000>, <0xc8008000 0x1000>;
+    };
+
+    ethernet@c8009000 {
+      compatible = "intel,ixp4xx-ethernet";
+      reg = <0xc8009000 0x1000>;
+      status = "disabled";
+      queue-rx = <&qmgr 4>;
+      queue-txready = <&qmgr 21>;
+      intel,npe-handle = <&npe 1>;
+      phy-mode = "rgmii";
+      phy-handle = <&phy1>;
+    };
+
+    ethernet@c800c000 {
+      compatible = "intel,ixp4xx-ethernet";
+      reg = <0xc800c000 0x1000>;
+      status = "disabled";
+      queue-rx = <&qmgr 3>;
+      queue-txready = <&qmgr 20>;
+      intel,npe-handle = <&npe 2>;
+      phy-mode = "rgmii";
+      phy-handle = <&phy2>;
+
+      mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+        phy1: ethernet-phy@1 {
+          reg = <1>;
+        };
+        phy2: ethernet-phy@2 {
+          reg = <2>;
+        };
+      };
+    };
-- 
2.29.2


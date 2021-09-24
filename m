Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DB3D417D20
	for <lists+netdev@lfdr.de>; Fri, 24 Sep 2021 23:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348608AbhIXVql (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Sep 2021 17:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348588AbhIXVqj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Sep 2021 17:46:39 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B34BC0614ED;
        Fri, 24 Sep 2021 14:45:06 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id x191so4156355pgd.9;
        Fri, 24 Sep 2021 14:45:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=gFs+xx2qBOTJUs4a6bSmi6bDzVEq4nz1xAMrovAUtoE=;
        b=Mg9Bxa76EEKyFK6smxpytkPNqX1zOloVPCNYTPB+ewz8nni7T0chkGlsHthrKQBHRH
         AkYCGLypsd1QFl16fL14fMXdfRPotaj6F53OdxRVgy6aaBH+fkAzMteSriYqU8SmV1/u
         2LxFhXGtJVE0AA3o1Wa86oCfef97pnqJ4p+dRgCVaIe9EfiZAjThlxBQ4hQoOnFPpk1c
         UACo3RM/+tqE7l3LT1JinN41+OotSw5UhjF7YfzO0OrfRt6D25prucmo5AfaUKXOapXy
         s8ng3fkvgJkFT9ytXzZucyqagdO0/jR9a9QU3C//wZ0XttcZNn7vC98crqf2wAzIwuON
         MRFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=gFs+xx2qBOTJUs4a6bSmi6bDzVEq4nz1xAMrovAUtoE=;
        b=MxJcECQ4cbOGWqVIeqwtH0AFTuxn7Vc9gTmBKEhOw4nuEHkZa0sCwRDtpfo2rNGcTt
         tQVunnoxZrjRfflCJJs1pLdkxbAC6J+sDPRWPtIHWl/gqSXovJY257oAOV9b8QLF9yI3
         h0gkr6Ni1sD5adghymYrKL548TGNc1vj1mhMqLQRI792AWZpimDHgk/qg6KiusfrQ41L
         KDpJfC5D3JWF1kE6yLScu7v/6DcfI3vxE/TbJFpzb63FrHgmmoyDGrHRhG928vHJr3Fk
         IG4NQODoP+Nhk7CRro1UMAHrAt+cVzZEvOAzTsAJJBDiRwdrY7MKbkhcazQUQuxwbsla
         kmvA==
X-Gm-Message-State: AOAM5312q6xB1hlK/uJhf7ulfLqalhrNYsuVplJR1EDPWA0bXP9FL8Fx
        Pmp/LvbMAhNBZZcxvyvsDI4JQMmvs7V9+g==
X-Google-Smtp-Source: ABdhPJzI7wVCm7EJ7b/pazQsMAKQyZzjxKf3+EJXPlBB22bv9G7FimypjJ0FhwNg17XfS1Gsxhb2Vg==
X-Received: by 2002:a63:3504:: with SMTP id c4mr5389911pga.203.1632519905278;
        Fri, 24 Sep 2021 14:45:05 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n66sm9842029pfn.142.2021.09.24.14.45.03
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Sep 2021 14:45:04 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org
Cc:     bcm-kernel-feedback-list@broadcom.com,
        Florian Fainelli <f.fainelli@gmail.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Doug Berger <opendmb@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        Randy Dunlap <rdunlap@infradead.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Michael Chan <michael.chan@broadcom.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-media@vger.kernel.org (open list:DMA BUFFER SHARING FRAMEWORK),
        dri-devel@lists.freedesktop.org (open list:DMA BUFFER SHARING FRAMEWORK),
        linaro-mm-sig@lists.linaro.org (moderated list:DMA BUFFER SHARING
        FRAMEWORK)
Subject: [PATCH net-next 1/5] dt-bindings: net: Brcm ASP 2.0 Ethernet controller
Date:   Fri, 24 Sep 2021 14:44:47 -0700
Message-Id: <1632519891-26510-2-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
References: <1632519891-26510-1-git-send-email-justinpopo6@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

Add a binding document for the Broadcom ASP 2.0 Ethernet controller.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 147 +++++++++++++++++++++
 1 file changed, 147 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
new file mode 100644
index 0000000..bab31d9
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
@@ -0,0 +1,147 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: "http://devicetree.org/schemas/net/brcm,asp-v2.0.yaml#"
+$schema: "http://devicetree.org/meta-schemas/core.yaml#"
+
+title: Broadcom ASP 2.0 Ethernet controller
+
+maintainers:
+  - Justin Chen <justinpopo6@gmail.com>
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+description: Broadcom Ethernet controller first introduced with 72165
+
+properties:
+  '#address-cells':
+    const: 1
+  '#size-cells':
+    const: 1
+
+  compatible:
+    enum:
+      - brcm,bcm72165-asp-v2.0
+      - brcm,asp-v2.0
+
+  reg:
+    maxItems: 1
+    description: ASP registers
+
+  ranges: true
+
+  interrupts:
+    minItems: 1
+    maxItems: 3
+    items:
+      - description: RX/TX interrupt
+      - description: Port 0 Wake-on-LAN
+      - description: Port 1 Wake-on-LAN
+
+  clocks:
+    $ref: /schemas/types.yaml#/definitions/phandle-array
+    description: Phandle to clock controller
+
+  clock-names:
+    const: sw_asp
+
+  brcm,reserved-net-filters-mask:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description: bitmap of reserved network filters that the driver will not use.
+
+  mdio:
+    type: object
+    $ref: brcm,unimac-mdio.yaml#
+
+  ethernet-ports:
+    type: object
+    properties:
+      '#address-cells':
+        const: 1
+      '#size-cells':
+        const: 0
+
+    patternProperties:
+      "^port@[0-9]+$":
+        type: object
+
+        $ref: ethernet-controller.yaml#
+
+        properties:
+          reg:
+            maxItems: 1
+            description: Port number
+
+          channel:
+            maxItems: 1
+            description: ASP channel number
+
+        required:
+         - reg
+         - channel
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - ranges
+
+additionalProperties: false
+
+examples:
+  - |
+    asp@9c00000 {
+        compatible = "brcm,asp-v2.0";
+        reg = <0x9c00000 0x1fff14>;
+        interrupts = <0x0 0x33 0x4>;
+        ranges;
+        clocks = <&scmi 14>;
+        clock-names = "sw_asp";
+        brcm,reserved-net-filters-mask = <0xff>;
+        #address-cells = <1>;
+        #size-cells = <1>;
+
+        mdio@c614 {
+            compatible = "brcm,asp-v2.0-mdio";
+            reg = <0xc614 0x8>;
+            reg-names = "mdio";
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            phy0: ethernet-phy@1 {
+                reg = <1>;
+            };
+       };
+
+        mdio@ce14 {
+            compatible = "brcm,asp-v2.0-mdio";
+            reg = <0xce14 0x8>;
+            reg-names = "mdio";
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            phy1: ethernet-phy@1 {
+                reg = <1>;
+            };
+        };
+
+        ethernet-ports {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            port@0 {
+                reg = <0>;
+                channel = <8>;
+                phy-mode = "rgmii";
+                phy-handle = <&phy0>;
+            };
+
+            port@1 {
+                reg = <1>;
+                channel = <9>;
+                phy-mode = "rgmii";
+                phy-handle = <&phy1>;
+            };
+        };
+    };
-- 
2.7.4


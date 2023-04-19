Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2386E703D
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 02:10:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231580AbjDSAKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 20:10:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjDSAKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 20:10:35 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C68D5659D;
        Tue, 18 Apr 2023 17:10:33 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id me15so10790506qvb.4;
        Tue, 18 Apr 2023 17:10:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681863033; x=1684455033;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=x24IGLY9CVBMTbD8Qpvp/dsz7w6tF7pOSZxQkUNrMtE=;
        b=KshvSsuFZS3y13v1ZRqbqOghv6PiMcSMtZwjpLe+PyX9XUgJkdCb73ST5GILY+QZCk
         i9SCXhUQaCUr++cK37HGZdaj7mNqt6bTvtKBS0gdZOuM4eUwsm9Uj0rHAFExXMj0fJmk
         3s4LvRbsUSmumgNoWgmjRKoyGUKEdlaSXdYKirG3IgDiyhu3V85JFYx5x+IIjOzfprvB
         nZPxvDS/xmQhZq0hgwPeL3Hj9wBQGNjaXjalh44JmT7KDPm34/rl/nkaM0LXvVfnHwmp
         hP0Nr9jAWHKbLNvsbDFmdfc3sHthCrknAb++tKDrHqxweIi8JbBEiu0kB0JXP+iMdd5K
         J3zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681863033; x=1684455033;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=x24IGLY9CVBMTbD8Qpvp/dsz7w6tF7pOSZxQkUNrMtE=;
        b=fF7lpVKriZ8KPuPKfmRy30sdju9ItCEyMhenYiK/vZk6BWjpu5OH308Pe01bwBex//
         48WR4VfgmCwOSQZgziOl5K2O12+QJJNP+ASCp5bgoMt3c3SiSdF8QrCLi94Pfnzhyqmx
         fuYBg9tReYSCnhm87+dNy4XmBFuk9xR++ULTJ+WRzp0Xo/NHv9vJFU58wg1kMDRKyL/N
         SjI3R0/CyzP+i28szf9mstPhX522XCGL6mYu4KIuBAYwos7czTghGWYYYZCKqgmWRk66
         GpE/dNOMCFDvchjXsXCofmSmjuw3LFgBi39aRmhciWlx3yYIWH90b1peJdrxps39Q8Vd
         v3xQ==
X-Gm-Message-State: AAQBX9e8Kcr6z6vPR2EAecIVarLw9Rpds15e6oE0zZnE/wzX0TaFIcKq
        2I5z846+gPZerZa3wHLVE1ntyqcATJIgyg==
X-Google-Smtp-Source: AKy350ZSx682zuDgvKTodV2CK7QDBAFVawTHif5JDzhca5MOxfNKZX5KI3ypZElcbz3e2JL3OPdkeQ==
X-Received: by 2002:a05:6214:c8d:b0:5ef:5250:c5e0 with SMTP id r13-20020a0562140c8d00b005ef5250c5e0mr21737097qvr.7.1681863032718;
        Tue, 18 Apr 2023 17:10:32 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d14-20020a37680e000000b0074d1b6a8187sm2639035qkc.130.2023.04.18.17.10.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Apr 2023 17:10:32 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justin.chen@broadcom.com, f.fainelli@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com, Justin Chen <justinpopo6@gmail.com>
Subject: [PATCH net-next 1/6] dt-bindings: net: Brcm ASP 2.0 Ethernet controller
Date:   Tue, 18 Apr 2023 17:10:13 -0700
Message-Id: <1681863018-28006-2-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
References: <1681863018-28006-1-git-send-email-justinpopo6@gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

Add a binding document for the Broadcom ASP 2.0 Ethernet
controller.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Justin Chen <justinpopo6@gmail.com>
---
 .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 146 +++++++++++++++++++++
 1 file changed, 146 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
new file mode 100644
index 000000000000..3817d722244f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
@@ -0,0 +1,146 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
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
+      - brcm,asp-v2.1
+
+  reg:
+    maxItems: 1
+    description: ASP registers
+
+  ranges: true
+
+  interrupts:
+    minItems: 1
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
+          - reg
+          - channel
+
+patternProperties:
+  "^mdio@[0-9a-f]+$":
+    type: object
+    $ref: "brcm,unimac-mdio.yaml"
+
+    description:
+      ASP internal UniMAC MDIO bus
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


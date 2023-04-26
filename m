Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB1D76EFA5D
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 20:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236414AbjDZSyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 14:54:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236239AbjDZSyv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 14:54:51 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D77997EF4;
        Wed, 26 Apr 2023 11:54:49 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-63b5ce4f069so9136789b3a.1;
        Wed, 26 Apr 2023 11:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682535289; x=1685127289;
        h=references:in-reply-to:message-id:date:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iM7yHvskaolGftzNm95k8IypdA4jTvJQMSV2F9l/cTA=;
        b=o2FFatoUcP8+xgxqGj+c8PIW6Js+DXt84udPry/z1iaYiwKDBufs1id2aPvGoG2bWb
         MojkF2qaAc9GRI5t7JzWVAwEW4gAiTFKTMhNU0cnemH931eJvww8JpDhLNJ9So6xGPG3
         oTSwdTJQCmCMzC7dQjHTbtG/fVKBX8Cu4MTBSwZlEkGfAX5OWjwU9ueo5eQLLrUjaZA1
         fxzuHtC5iiV+oz8uTenZOVJkV5vOp4Sg47dS4DNNhhoLmLJqdqfyoN36z3MDbmRl1pLt
         qhbHXa8QS2eEkXE8RYdHB00SXHeaz4JRpeBgx3gJ0c4hlHdh4bUR8PXYT4w7KtNvaf6K
         ROFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682535289; x=1685127289;
        h=references:in-reply-to:message-id:date:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iM7yHvskaolGftzNm95k8IypdA4jTvJQMSV2F9l/cTA=;
        b=CAjoix+639FCcU0bZAvode5KQ7IgFmCAtpuJdwlOkh2Xw2K2RDU3qe/oCRqH+cj6f1
         MTfK3foWcLxKJSQ8mlNO0Qq3mWpFIFejQfG6zGTqNKJL9qGj6J41hWtrXPr1DAA5NhIz
         koZ4vCXdOwBoUsXiJABnZSVCXrhAUJPI0TdHEPK3cnpu6yqlUIerwijxMv9WVhPNjI67
         MH6IFmHMlGY/I9441kH6x/iQ2+wTYhYbDOrXoDuVhJAGYuPImE37oFGCkfyVBofdQ4R2
         HqAA/OcZDjRVKFdeB8WDdHzkMjISwNwcp9CYm9DoNSyTGt9D/fWxkj94DxP1ugS6y6fE
         IhvQ==
X-Gm-Message-State: AAQBX9f3Rv12dDDQnZRkO/2ynJQC4I9G6qF3n5CGLUzgDAV8OAjRShuN
        X+yBMU4LX7OhNLqKDUKaLpbXTXf4LuG3Ig==
X-Google-Smtp-Source: AKy350ZYLKm1bNzUe0VmzPx17UI4K/U+ouMYqOszjyIJHUEhOFP9wOtjYG3TD9hmCgJsPHIG6nInxw==
X-Received: by 2002:a05:6a00:b51:b0:628:1b3:d499 with SMTP id p17-20020a056a000b5100b0062801b3d499mr30210734pfo.21.1682535289077;
        Wed, 26 Apr 2023 11:54:49 -0700 (PDT)
Received: from stbirv-lnx-2.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y72-20020a62644b000000b006372791d708sm11639254pfb.104.2023.04.26.11.54.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 26 Apr 2023 11:54:48 -0700 (PDT)
From:   Justin Chen <justinpopo6@gmail.com>
To:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        bcm-kernel-feedback-list@broadcom.com
Cc:     justinpopo6@gmail.com, justin.chen@broadcom.com,
        f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, opendmb@gmail.com,
        andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        richardcochran@gmail.com, sumit.semwal@linaro.org,
        christian.koenig@amd.com
Subject: [PATCH v2 net-next 2/6] dt-bindings: net: Brcm ASP 2.0 Ethernet controller
Date:   Wed, 26 Apr 2023 11:54:28 -0700
Message-Id: <1682535272-32249-3-git-send-email-justinpopo6@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
References: <1682535272-32249-1-git-send-email-justinpopo6@gmail.com>
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
 .../devicetree/bindings/net/brcm,asp-v2.0.yaml     | 145 +++++++++++++++++++++
 1 file changed, 145 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
new file mode 100644
index 000000000000..818d91692e6e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,asp-v2.0.yaml
@@ -0,0 +1,145 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,asp-v2.0.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
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
+      - brcm,asp-v2.0
+      - brcm,bcm72165-asp-v2.0
+      - brcm,asp-v2.1
+      - brcm,bcm74165-asp-v2.1
+
+  reg:
+    maxItems: 1
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
+    maxItems: 1
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
+    additionalProperties: false
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
+  - ranges
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ethernet@9c00000 {
+        compatible = "brcm,asp-v2.0";
+        reg = <0x9c00000 0x1fff14>;
+        interrupts = <GIC_SPI 51 IRQ_TYPE_LEVEL_HIGH>;
+        ranges;
+        clocks = <&scmi 14>;
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


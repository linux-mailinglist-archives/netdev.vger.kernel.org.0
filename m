Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CACB3435B6
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 00:30:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhCUXaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Mar 2021 19:30:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbhCUX3v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Mar 2021 19:29:51 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB336C061574;
        Sun, 21 Mar 2021 16:29:50 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id b7so18363786ejv.1;
        Sun, 21 Mar 2021 16:29:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qNggA0OtlrRL1GIUsOsl6TjvwVb3lCSvVXY+lMXrBx0=;
        b=IIpLdzLqyXKLBcpUksJgtBOeh8JqeQ+qPms6pwWJI7IJ87Tk8ikJl3DPNpFyoe5KOo
         T1U9iVR3SqKSJ3v1yF6ZxBwkft/Vv1CjnUj9eD8IXvOld0ynVcq5aPR5Em5FzAinGYXl
         26nuxCgEXqJEQE5RrDLBhu0GOtyba+P5TJr7VIgPvruMByvO8xyoxGw6XcPWwY4159FT
         iT0PiYmjjUPVFlIoWmWDz6IxPhv7T5nxJrPPlgWLvuMGv8eNgC+GQOoewLAfHUs9BEig
         8m0YTdzdnPprWHc3lJiiQ8Ta3to0YtA4CTedMvl4K9ao+nduHcYNKgjDw0ghUcYYbyt4
         jiQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qNggA0OtlrRL1GIUsOsl6TjvwVb3lCSvVXY+lMXrBx0=;
        b=QMnF24Bc2OQdqiP5UsrwhwtKcgdM0HX+D9dKfWFE2F5tOSEEP5+7+Rr5V9HFoKRgnP
         lO9xaIM3buJArSkGiAs6zU7pAyc7Mrv3/DHMF35WvCii6hugf0j5TfVKYqZWhAK16iT6
         eeqUZ1Ey/gQBQQvE3d10SjU2WR+U68c2T/b6Hi41oj1qO899AjWhqvNf4/IQm5ISZ3O0
         VLzKGpUO1hxtDX2NtlupfJQs5bUl1Q2Ty8x9LXwp/kfpBKzGrgkMAPRalos0eaLWZJ8D
         3gT7p2D8hnXm9VDPECjT7Xs04f7j8LxpYHWFRjTQokAwBwD34EJv40BxI6UQrdPO8weO
         hgWQ==
X-Gm-Message-State: AOAM5323MtL1Se2u/NCGWAi3gjlKVBlnGqBZTYcn2kWOvhNBGvY+3JXm
        O1V/5MrWAVYHrlEdZ6GHw8w=
X-Google-Smtp-Source: ABdhPJxIvAtHEE13r/cgg3rR8PWrDCVLFyG62lXIwQu9VkXgKLenTxSNfYkGatootLqSe9x0cVN0TQ==
X-Received: by 2002:a17:906:f9db:: with SMTP id lj27mr16542614ejb.399.1616369389572;
        Sun, 21 Mar 2021 16:29:49 -0700 (PDT)
Received: from localhost.localdomain ([188.24.140.160])
        by smtp.gmail.com with ESMTPSA id bt14sm9801472edb.92.2021.03.21.16.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Mar 2021 16:29:49 -0700 (PDT)
From:   Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Andreas=20F=C3=A4rber?= <afaerber@suse.de>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-actions@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/3] dt-bindings: net: Add Actions Semi Owl Ethernet MAC binding
Date:   Mon, 22 Mar 2021 01:29:43 +0200
Message-Id: <91db9904359c5e749d0362c5358f1e770911e01d.1616368101.git.cristian.ciocaltea@gmail.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
References: <cover.1616368101.git.cristian.ciocaltea@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add devicetree binding for the Ethernet MAC present on the Actions
Semi Owl family of SoCs.

For the moment advertise only the support for the Actions Semi S500 SoC
variant.

Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
---
 .../bindings/net/actions,owl-emac.yaml        | 92 +++++++++++++++++++
 1 file changed, 92 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/actions,owl-emac.yaml

diff --git a/Documentation/devicetree/bindings/net/actions,owl-emac.yaml b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
new file mode 100644
index 000000000000..1626e0a821b0
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/actions,owl-emac.yaml
@@ -0,0 +1,92 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/actions,owl-emac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Actions Semi Owl SoCs Ethernet MAC Controller
+
+maintainers:
+  - Cristian Ciocaltea <cristian.ciocaltea@gmail.com>
+
+description: |
+  This Ethernet MAC is used on the Owl family of SoCs from Actions Semi.
+  It provides the RMII and SMII interfaces and is compliant with the
+  IEEE 802.3 CSMA/CD standard, supporting both half-duplex and full-duplex
+  operation modes at 10/100 Mb/s data transfer rates.
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+properties:
+  compatible:
+    oneOf:
+      - const: actions,owl-emac
+      - items:
+          - enum:
+              - actions,s500-emac
+          - const: actions,owl-emac
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 2
+    maxItems: 2
+
+  clock-names:
+    additionalItems: false
+    items:
+      - const: eth
+      - const: rmii
+
+  resets:
+    maxItems: 1
+
+  actions,ethcfg:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the device containing custom config.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - resets
+  - phy-mode
+  - phy-handle
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/actions,s500-cmu.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/reset/actions,s500-reset.h>
+
+    ethernet@b0310000 {
+        compatible = "actions,s500-emac", "actions,owl-emac";
+        reg = <0xb0310000 0x10000>;
+        interrupts = <GIC_SPI 0 IRQ_TYPE_LEVEL_HIGH>;
+        clocks = <&cmu 59 /*CLK_ETHERNET*/>, <&cmu CLK_RMII_REF>;
+        clock-names = "eth", "rmii";
+        resets = <&cmu RESET_ETHERNET>;
+        phy-mode = "rmii";
+        phy-handle = <&eth_phy>;
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            eth_phy: ethernet-phy@3 {
+                reg = <0x3>;
+                interrupt-parent = <&sirq>;
+                interrupts = <0 IRQ_TYPE_LEVEL_LOW>;
+            };
+        };
+    };
-- 
2.31.0


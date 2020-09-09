Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B35FC2631CB
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbgIIQ1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:27:31 -0400
Received: from mail.nic.cz ([217.31.204.67]:34622 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731052AbgIIQ0D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 12:26:03 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:cac7:3539:7f1f:463])
        by mail.nic.cz (Postfix) with ESMTP id C2F08140A64;
        Wed,  9 Sep 2020 18:25:54 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599668754; bh=GiMyA6x4ElsGNt3VmolCaxWgc8p8+8SuvAMrXWbJfso=;
        h=From:To:Date;
        b=f87YnBrkbGhc0mIVSyThy0I8tEFadbY7bRevzKURZ9u8FsqdUpA2/lTT/7rnUADVz
         YpnEVtE4a7UcqDL5SUwko8Q7h8/8pJC0mgawuhLM6VqjkGqnUJPvleJRn4k2ROwRdS
         kCtCRgAacYXe2/ZszbGkdU37lhlonyDym53MpG/s=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: [PATCH net-next + leds v2 1/7] dt-bindings: leds: document binding for HW controlled LEDs
Date:   Wed,  9 Sep 2020 18:25:46 +0200
Message-Id: <20200909162552.11032-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909162552.11032-1-marek.behun@nic.cz>
References: <20200909162552.11032-1-marek.behun@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.nic.cz
X-Spam-Status: No, score=0.00
X-Spamd-Bar: /
X-Virus-Scanned: clamav-milter 0.102.2 at mail
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document binding for LEDs connected to and controlled by various chips
(such as ethernet PHY chips).

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
---
 .../leds/linux,hw-controlled-leds.yaml        | 99 +++++++++++++++++++
 1 file changed, 99 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml

diff --git a/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
new file mode 100644
index 0000000000000..eaf6e5d80c5f5
--- /dev/null
+++ b/Documentation/devicetree/bindings/leds/linux,hw-controlled-leds.yaml
@@ -0,0 +1,99 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/leds/linux,hw-controlled-leds.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: LEDs that can be controlled by hardware (eg. by an ethernet PHY chip)
+
+maintainers:
+  - Marek Behún <marek.behun@nic.cz>
+
+description:
+  Many an ethernet PHY (and other chips) supports various HW control modes
+  for LEDs connected directly to them. With this binding such LEDs can be
+  described.
+
+properties:
+  compatible:
+    const: linux,hw-controlled-leds
+
+  "#address-cells":
+    const: 1
+
+  "#size-cells":
+    const: 0
+
+patternProperties:
+  "^led@[0-9a-f]+$":
+    type: object
+    allOf:
+      - $ref: common.yaml#
+    description:
+      This node represents a LED device connected to a chip that can control
+      the LED in various HW controlled modes.
+
+    properties:
+      reg:
+        maxItems: 1
+        description:
+          This property identifies the LED to the chip the LED is connected to
+          (eg. an ethernet PHY chip can have multiple LEDs connected to it).
+
+      enable-active-high:
+        description:
+          Polarity of LED is active high. If missing, assumed default is active
+          low.
+        type: boolean
+
+      led-tristate:
+        description:
+          LED pin is tristate type. If missing, assumed false.
+        type: boolean
+
+      linux,default-hw-mode:
+        description:
+          This parameter, if present, specifies the default HW triggering mode
+          of the LED when LED trigger is set to `dev-hw-mode`.
+          Available values are specific per device the LED is connected to and
+          per LED itself.
+        $ref: /schemas/types.yaml#definitions/string
+
+    required:
+      - reg
+
+additionalProperties: false
+
+examples:
+  - |
+
+    #include <dt-bindings/leds/common.h>
+
+    ethernet-phy@0 {
+        compatible = "ethernet-phy-ieee802.3-c45";
+        reg = <0>;
+
+        leds {
+            compatible = "linux,hw-controlled-leds";
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            led@0 {
+                reg = <0>;
+                color = <LED_COLOR_ID_GREEN>;
+                function = <LED_FUNCTION_STATUS>;
+                linux,default-trigger = "dev-hw-mode";
+                linux,default-hw-mode = "1Gbps";
+            };
+
+            led@1 {
+                reg = <1>;
+                color = <LED_COLOR_ID_YELLOW>;
+                function = <LED_FUNCTION_ACTIVITY>;
+                linux,default-trigger = "dev-hw-mode";
+                linux,default-hw-mode = "activity";
+            };
+        };
+    };
+
+...
-- 
2.26.2


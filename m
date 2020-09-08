Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9FD260758
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:03:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728104AbgIHADF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:03:05 -0400
Received: from lists.nic.cz ([217.31.204.67]:51566 "EHLO mail.nic.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727819AbgIHADD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 20:03:03 -0400
Received: from dellmb.labs.office.nic.cz (unknown [IPv6:2001:1488:fffe:6:8982:ed8c:62b1:c0c8])
        by mail.nic.cz (Postfix) with ESMTP id 9A0D814004F;
        Tue,  8 Sep 2020 02:03:01 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=nic.cz; s=default;
        t=1599523381; bh=KJLbvvPf3CNkGwBOxwMT2kh3dnbZ2rdGErRO9MBVcvw=;
        h=From:To:Date;
        b=SZfogk/yX5tpva+/dx/6CVc+cOfcMbn0cpy7z1Mh6ygUm2qLYfLvIUYmfvH3h3FRO
         0SncuqXRqF2BrYNGOJGbZYJEa3hrtOznOoAFww76U+n8evuFXhAG6naVGlZ1wZUlTg
         jFgem5HqWS9DgWs42yc/3HNKDk8pnoTeoMJ9hT/8=
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>
To:     netdev@vger.kernel.org
Cc:     linux-leds@vger.kernel.org, Pavel Machek <pavel@ucw.cz>,
        Dan Murphy <dmurphy@ti.com>,
        =?UTF-8?q?Ond=C5=99ej=20Jirman?= <megous@megous.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <marek.behun@nic.cz>,
        Rob Herring <robh+dt@kernel.org>
Subject: [PATCH net-next v1 1/3] dt-bindings: net: ethernet-phy: add description for PHY LEDs
Date:   Tue,  8 Sep 2020 02:02:58 +0200
Message-Id: <20200908000300.6982-2-marek.behun@nic.cz>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908000300.6982-1-marek.behun@nic.cz>
References: <20200908000300.6982-1-marek.behun@nic.cz>
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

Document binding for LEDs connected to and controlled by ethernet PHY
chips.

Signed-off-by: Marek Behún <marek.behun@nic.cz>
Cc: Rob Herring <robh+dt@kernel.org>
---
 .../devicetree/bindings/net/ethernet-phy.yaml | 31 +++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
index a9e547ac79051..11839265cc2f9 100644
--- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
@@ -174,6 +174,37 @@ properties:
       PHY's that have configurable TX internal delays. If this property is
       present then the PHY applies the TX delay.
 
+patternProperties:
+  "^led@[0-9a-f]+$":
+    type: object
+    description:
+      This node represents a LED device connected to the PHY chip.
+    $ref: /schemas/leds/common.yaml#
+
+    properties:
+      reg:
+        maxItems: 1
+
+      enable-active-high:
+        description:
+          Polarity of LED is active high. If missing, assumed default is active low.
+        type: boolean
+
+      led-open-drain:
+        description:
+          LED pin is open drain type. If missing, assumed false.
+        type: boolean
+
+      linux,default-hw-mode:
+        description:
+          This parameter, if present, specifies the default HW triggering mode of the LED
+          when LED trigger is set to `phydev-hw-mode`.
+          Available values are specific per PHY chip and per LED.
+        $ref: /schemas/types.yaml#definitions/string
+
+    required:
+      - reg
+
 required:
   - reg
 
-- 
2.26.2


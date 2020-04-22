Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F08F21B35C9
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 05:54:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726447AbgDVDxm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 23:53:42 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:46385 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726422AbgDVDxm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 23:53:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0053E5801C2;
        Tue, 21 Apr 2020 23:53:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 21 Apr 2020 23:53:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=+EfqkUSWnK5oB5LHgnO1Rxb0VK
        C+TbEqPBLo0jnqFfY=; b=Vv5txikFjhlLvXI1tIKdx81CnUOtqX04ItqrZd++y+
        ylJ31YHwF9JMljYOhGIr0CzgOzvU/p2AtiHnJCBQO2aNv4D0S7Uo11jpZT9bzM3b
        k9Zvk2D00RhMXhgO0bdcOTcL0p+VteTb9+w+O6Sp/bh5YUTvtDUw94xN+Kbl9sFL
        kvMjh8pPqD7n9bVAdcJxSzMkKIbg3R4s/L249Gi4aYRjqieTpehR7x8+CvR+sok2
        hEbvykXcCj1lGXw8kV2i4sfjkJw6GFykcqpRq45d/fwJVKQIDOp582m9frc+CYjD
        rUBPqYpRaNU9Gl8V8XsQDtYHtXMP/LSu/peBI2yQRCQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=+EfqkUSWnK5oB5LHg
        nO1Rxb0VKC+TbEqPBLo0jnqFfY=; b=nZ+ub6QOBaRpvVC0ToDUQ/DS9jU1jSut6
        8xhF9m2WCT9D1g7LqyhyMWu+DMzvzYkRSfJVjb5hikK/Pg4rLuzPt+Rrp+DMnY/w
        qqE2v6M3Shup8k2wJxpf5T38BgSprvn72s9eTAeZBgiBi70/05lEkh42UNOQTEUz
        U3ZzTHD/xNt61V7THd04ZuTvHZgyWoV/kYz441BNOke/5wNGbtVtR0GL33p4ksRX
        ljtf6iLNfKk1dSpy4V3hqBUg2X5vfYSQ4vq/8PYsJgJocah0GLKl1UEmnNoMWOeY
        m6pe7yc3Ohrikuf93td82cEEmMDhnr3rL1+yGNIPymRV6neLJJ0xQ==
X-ME-Sender: <xms:xL-fXtryYa-E56bp_MQzrv-ZweNWTYg05pQAnuoEmzx1HfOe41hu5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeeigdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeetlhhishhtrghirhcuhfhrrghntghishcuoegrlhhishhtrghirhes
    rghlihhsthgrihhrvdefrdhmvgeqnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdroh
    hrghenucfkphepjeefrdelfedrkeegrddvtdeknecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlihhsthgrihhrsegrlhhishhtrghirhdvfe
    drmhgv
X-ME-Proxy: <xmx:xL-fXr8vh1tErFKMmMRrFOTVByOqqyMkfXEtEH26SDrz7EFWnS9uqA>
    <xmx:xL-fXs_3hyJxHZuB3nFymkNYyhhsZBAf5w077Be9d4wkzft2tzpbUQ>
    <xmx:xL-fXqsc8KlVQcN7vc5oQgLnA133RjHzuQpd1eKLFoSrVfeFhSkT9g>
    <xmx:xL-fXhodnDceTjkOrAp2U-6b0io9GgFzDco_ANuCj-16ht-gxFtHhg>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id 15DD33280063;
        Tue, 21 Apr 2020 23:53:39 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH v4 1/3] dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth
Date:   Tue, 21 Apr 2020 20:53:31 -0700
Message-Id: <20200422035333.1118351-1-alistair@alistair23.me>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Khoruzhick <anarsoul@gmail.com>

Add binding document for bluetooth part of RTL8723BS/RTL8723CS

Signed-off-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Alistair Francis <alistair@alistair23.me>
---
 .../bindings/net/realtek-bluetooth.yaml       | 54 +++++++++++++++++++
 1 file changed, 54 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek-bluetooth.yaml

diff --git a/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
new file mode 100644
index 000000000000..4eb141b00fcb
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
@@ -0,0 +1,54 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/realtek,rtl8723bs-bt.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: RTL8723BS/RTL8723CS/RTL8822CS Bluetooth Device Tree Bindings
+
+maintainers:
+  - Vasily Khoruzhick <anarsoul@gmail.com>
+  - Alistair Francis <alistair@alistair23.me>
+
+description:
+  RTL8723CS/RTL8723CS/RTL8822CS is WiFi + BT chip. WiFi part is connected over
+  SDIO, while BT is connected over serial. It speaks H5 protocol with few
+  extra commands to upload firmware and change module speed.
+
+properties:
+  compatible:
+    oneOf:
+      - const: "realtek,rtl8723bs-bt"
+      - const: "realtek,rtl8723cs-bt"
+      - const: "realtek,rtl8822cs-bt"
+
+  device-wake-gpios:
+    maxItems: 1
+    description: GPIO specifier, used to wakeup the BT module
+
+  enable-gpios:
+    maxItems: 1
+    description: GPIO specifier, used to enable the BT module
+
+  host-wake-gpios:
+    maxItems: 1
+    description: GPIO specifier, used to wakeup the host processor
+
+required:
+  - compatible
+
+examples:
+  - |
+    #include <dt-bindings/gpio/gpio.h>
+
+    uart1 {
+        pinctrl-names = "default";
+        pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
+        uart-has-rtscts = <1>;
+
+        bluetooth {
+            compatible = "realtek,rtl8723bs-bt";
+            device-wake-gpios = <&r_pio 0 5 GPIO_ACTIVE_HIGH>; /* PL5 */
+            host-wakeup-gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
+        };
+    };
-- 
2.26.0


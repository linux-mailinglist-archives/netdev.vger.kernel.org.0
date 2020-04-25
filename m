Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412051B8784
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 17:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726186AbgDYPzn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 11:55:43 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:44051 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726112AbgDYPzm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 11:55:42 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 3BF3E5803BF;
        Sat, 25 Apr 2020 11:55:41 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 25 Apr 2020 11:55:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=xudYb/gSOwoNebonFD9XGdvc59
        XtcGplDNYOwu4XiUI=; b=oLRotAyWbPWDaOLtuIJgzBAtTHjhY7DmziVPQmclZl
        WUo4BDGpu3mn2Ur5v5gJkCuI2FuyjbSV5vWiUO5y83wQqfcs0k3MAC7HufB+e1RG
        dAYPuJ0HKdiIgqTwVBhFhSnrGzch43Kt7w0D+QArp5ixAgJBTZGgarIVdnLahwVx
        +b18cyqBFvA85lzInhHG+3gxFQ7wPdh1+mvsn6HeOL/PYhI02pwsP7Tp9xGUTp16
        bIcRDYlcnuDpmb9UV4Jt9+VpifYEPliJvzSE3rl+BlXuWbphsflPDjJv0byVxYqm
        BM1JSHXt5UZduBdMGegE3V35ZWN6ce8c/prlQKKpHSpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=xudYb/gSOwoNebonF
        D9XGdvc59XtcGplDNYOwu4XiUI=; b=cGUmEnNLLNp/LIyM+YdFX1OIhSj5qWbs7
        xdYdpL+kmZWHj45VdWNmP6C1NU15B0om5vI6EXHh5sE8H+fSyHN7xKeZXSjQHtQu
        eGCe6mvlh0n7udr4Pk6Qjra5Et7eKo6F4CZ7tJobdRKloU4pDFu/iBf8c+dZ7Mub
        7AQgWu39oJ/Lc/xaIzlt9a2hbX8YikFobNGkS1FRabHivuUwlXmI26XhptbpZM/5
        0aCVCogvbXeMRGJ05zglZkDEQTtdBNHLzQ16CnoznJ362tK2jJnR0KCgXBVgd+DU
        teqVfQCS3u85DKHxZ9lJKqrJrVPHx2KC+n1L6lwxJ3OTgiv+czeUw==
X-ME-Sender: <xms:d12kXppr3YaNqcTfGxpZ5rYR479U31CJOFf3XhgySqVTuXtRy6toxw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheeggdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeetlhhishhtrghirhcuhfhrrghntghishcuoegrlhhishhtrghirhes
    rghlihhsthgrihhrvdefrdhmvgeqnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdroh
    hrghenucfkphepjeefrdelfedrkeegrddvtdeknecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlihhsthgrihhrsegrlhhishhtrghirhdvfe
    drmhgv
X-ME-Proxy: <xmx:d12kXv4hELo9Q_14xXo5RwPbJbeHJC6CGZmT8PWqL_06m5_k9nzW3g>
    <xmx:d12kXhOaOxPF7zvZn5xNuD2T8hgV1wuO92RlonMqQtf_vsJcjpyQoA>
    <xmx:d12kXpO1UE_kb03adDxVDTHdVyB2yIZCK8Hfs9t-grySCISP6JYpXA>
    <xmx:fV2kXm3Cn9faCTDQ2kM13sFSBciBs76a6XS8akneDfGoC3iYzbTHgw>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id 041E83280063;
        Sat, 25 Apr 2020 11:55:33 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH v4 1/3] dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth
Date:   Sat, 25 Apr 2020 08:55:29 -0700
Message-Id: <20200425155531.2816584-1-alistair@alistair23.me>
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
index 000000000000..f15a5e5e4859
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek-bluetooth.yaml
@@ -0,0 +1,54 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/realtek-bluetooth.yaml#
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


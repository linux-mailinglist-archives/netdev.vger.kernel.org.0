Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD7B1A5BE7
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 04:06:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgDLCGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Apr 2020 22:06:50 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:46813 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726182AbgDLCGu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Apr 2020 22:06:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.west.internal (Postfix) with ESMTP id 409EA7B6;
        Sat, 11 Apr 2020 22:06:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 11 Apr 2020 22:06:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=mJv36t1SJnnp+kHy+QoWeejovE
        tqzplumtCjfcbVuS0=; b=BAvR9SNeojzza4R55O1DNwI4mOY1L3ZEbCUW6irq9O
        ZKzSbknXwIXg5u9Y1ynW5mDvlSvDNS4iOwGcqkdVZ5vMn/ihyhVtLEvQlhiHv2q2
        V7SdWI3AIkUHAgHwh0RvIHFAAtq5wxX/4im7NYqYnil/2yMmeFlvDmn3en0X/Wep
        eFzz8wiZQJwb4Bq9SHEIF810jgrKiWT8jGBEE4rOAtBmn0e+/czKsFuCv4an0qSX
        nkiNEPRHL9kMLOMxp5hIvOBLurkRY7e7Cml7w+8ezdfkuH2NKax+jfOTPBxMQePG
        Gvn3WleLZ0iQ0OZnKwbEl5kwBTduNE9AQ4sVc0KyhdNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mJv36t1SJnnp+kHy+
        QoWeejovEtqzplumtCjfcbVuS0=; b=pQrWuEs87Y/MS9DrPtDbtpSddA2tyCukp
        165eO4XFQx5yf8MvIl639NZNDI7evSMpAav2E+C6qs/bSlCuF816+zf3Szty3Vqt
        JqjaUF2PkypRZ4CHtgiMZfECrjqkB8wviDjem30qpAuq3FWMz+hxrGudgzmMSrT8
        WgA7WXYpnjkH4Lq03cmJxATmuWFk4O9AwADDu8VDCqsm7zG9O5fp76brBKr2ye92
        ZeCLqBvOstcNm9IRzH52St83j5N+/UZKl0kTXXj9oTMu/TUlTBe8cWd8LV6slqWy
        oeWaQj5NPzD9rJ6WNK6VcPrAQ7LyYjQZ7kvMjpN/zOqIEAlj7UeQw==
X-ME-Sender: <xms:uHeSXs7CdNHuQDonf30CVDUev7wuVK4OpcyQxkxC77jmZN77hHT5Ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrvdehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeetlhhishhtrghirhcuhfhrrghntghishcuoegrlhhishhtrghirhes
    rghlihhsthgrihhrvdefrdhmvgeqnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdroh
    hrghenucfkphepjeefrdelfedrkeegrddvtdeknecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlihhsthgrihhrsegrlhhishhtrghirhdvfe
    drmhgv
X-ME-Proxy: <xmx:uHeSXhn5ae26nk5rVmHUay3in-XT8b6gEC9pg2PxvhNltF7pekrtmg>
    <xmx:uHeSXkHTbmTJwh5HUy7IEAij9UmrMrF9e5cgU5Qbb3VfjtictQ5Ylg>
    <xmx:uHeSXiigaKMrjSbGeAyrvlyYPCeZ1kr_xoQeHvSlFoauVib5buO1iA>
    <xmx:uHeSXmhzAhI7a7uWDNP8AFgtzi5NmT_p9j9lF5npaVUwMwKB1idG9o-F0yY>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id F2180328005E;
        Sat, 11 Apr 2020 22:06:46 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH v3 1/3] dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth
Date:   Sat, 11 Apr 2020 19:06:42 -0700
Message-Id: <20200412020644.355142-1-alistair@alistair23.me>
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
 .../bindings/net/realtek,rtl8723bs-bt.yaml    | 52 +++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml b/Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml
new file mode 100644
index 000000000000..ebb90356a96e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml
@@ -0,0 +1,52 @@
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
+    &uart1 {
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


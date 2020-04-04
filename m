Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA95619E79A
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 22:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726402AbgDDUtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 16:49:03 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:58825 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726297AbgDDUtD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 16:49:03 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 7778D5801D3;
        Sat,  4 Apr 2020 16:49:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 04 Apr 2020 16:49:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=KIJG0IcLzxmdwV/29oXvU5STaA
        F5Yt1sQAOEbJBudyg=; b=fwgHoggIwUNk27OoEb3usYPdeA9UCO0xb9BV76jWWy
        dLuWCX9T+VBcHNpivWvRCBaSLxJmHSFWfcVxy6BcaRBnquaMJhWcr7HP2LB0OupD
        ajqkX1w4xKcXIAvwkqwrSe30eVei42nWI0XWUaYXxNTCr242WyEUPxxI7EteHeRW
        7Pjv/DVXfGjqHD7+wQQ5ayiUkYwofUuZY2mCtgW8lcUBPDcQhWm0KCEOsjV7sSUJ
        k5FvMOweq1jyvTBZKa8eA9TUt4jGg8Tnjf8dbo1pwAL0TszwtNsxf6mzf89jhmfv
        ctfOfqqXMOtd0UtgMPk2EOa3xwWY6a95gFlWr1K7H7jg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=KIJG0IcLzxmdwV/29
        oXvU5STaAF5Yt1sQAOEbJBudyg=; b=YsKOgJsKal1FFidz1nafJNO9MUS4BeOsg
        ImS0Oul8/L/Ef9BTgMDusRFsa4PdvVu5000/AFykyjbuEqWiORva7uz7I1xbYi1h
        NBTC9uzaSLDHXguCRX6NK3RTn4QPKJTcT30aaInnL8R+oaac/6TnXQnyEu1DRZTJ
        x1yVG4+Oh8gj69jh+czllJihn/kpTAsE7QMobQyaSDkJwsqBGLs+mgYEqVaKLz7+
        KXjl5Zh1kNDcUxG0FY0XsG0E6QmAYO+iPhPNtyzTOukPSpZfx9kZ6vl2cvvnycjx
        w5TWkRREHXFh/KyhKf5L8/hHCBQQX6nZcgAkIrvSzb4IXolbgrikQ==
X-ME-Sender: <xms:vfKIXnnPLjQBsXhwm-4V265kssvsw8tP5tncSUhMuI8i4IKNrTk-9Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrtdekgdduheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomheptehlihhsthgrihhrucfhrhgrnhgtihhsuceorghlihhsthgrihhr
    segrlhhishhtrghirhdvfedrmhgvqeenucffohhmrghinhepuggvvhhitggvthhrvggvrd
    horhhgnecukfhppeejfedrleefrdekgedrvddtkeenucevlhhushhtvghrufhiiigvpedt
    necurfgrrhgrmhepmhgrihhlfhhrohhmpegrlhhishhtrghirhesrghlihhsthgrihhrvd
    efrdhmvg
X-ME-Proxy: <xmx:vfKIXstkpaJa-1MGh_rbimMwU1cSzFNnDg_KzfBBeHR2K-qRoezmrw>
    <xmx:vfKIXix-fL9JOyrj1gXNXN9hbLv1kQL1gVy3cCQ-XOXiqjLmEjxRAQ>
    <xmx:vfKIXvypviPSGQNwsQnflgudlGWAFDMLoahNMvsNrmqKh8fgYVefGA>
    <xmx:vvKIXgwBPwApEj8zw3xESkszjG3zce-c12K7RhfKR_UfGR7hwa9wlg>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD9663280065;
        Sat,  4 Apr 2020 16:48:59 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH 1/3] dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth
Date:   Sat,  4 Apr 2020 13:48:48 -0700
Message-Id: <20200404204850.405050-1-alistair@alistair23.me>
X-Mailer: git-send-email 2.25.1
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
 .../bindings/net/realtek,rtl8723bs-bt.yaml    | 56 +++++++++++++++++++
 1 file changed, 56 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml b/Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml
new file mode 100644
index 000000000000..9e212954f629
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml
@@ -0,0 +1,56 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/realtek,rtl8723bs-bt.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: RTL8723BS/RTL8723CS Bluetooth Device Tree Bindings
+
+maintainers:
+  - Vasily Khoruzhick <anarsoul@gmail.com>
+  - Alistair Francis <alistair@alistair23.me>
+
+description:
+  RTL8723CS/RTL8723CS is WiFi + BT chip. WiFi part is connected over SDIO, while
+  BT is connected over serial. It speaks H5 protocol with few extra commands
+  to upload firmware and change module speed.
+
+properties:
+  compatible:
+    oneOf:
+      - "realtek,rtl8723bs-bt"
+      - "realtek,rtl8723cs-bt"
+
+  device-wake-gpios:
+    description:
+      GPIO specifier, used to wakeup the BT module (active high)
+
+  enable-gpios:
+    description:
+      GPIO specifier, used to enable the BT module (active high)
+
+  host-wake-gpios:
+    desciption:
+      GPIO specifier, used to wakeup the host processor (active high)
+
+firmware-postfix: firmware postfix to be used for firmware config
+reset-gpios: GPIO specifier, used to reset the BT module (active high)
+
+required:
+  - compatible
+
+examples:
+  - |
+    &uart1 {
+        pinctrl-names = "default";
+        pinctrl-0 = <&uart1_pins>, <&uart1_rts_cts_pins>;
+        status = "okay";
+
+        bluetooth {
+            compatible = "realtek,rtl8723bs-bt";
+            reset-gpios = <&r_pio 0 4 GPIO_ACTIVE_LOW>; /* PL4 */
+            device-wake-gpios = <&r_pio 0 5 GPIO_ACTIVE_HIGH>; /* PL5 */
+            host-wakeup-gpios = <&r_pio 0 6 GPIO_ACTIVE_HIGH>; /* PL6 */
+            firmware-postfix="pine64";
+        };
+    };
-- 
2.25.1


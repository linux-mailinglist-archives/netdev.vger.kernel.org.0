Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBD931A06E3
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 07:59:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726992AbgDGF67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 01:58:59 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:38603 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725817AbgDGF6u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 01:58:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 678CC580307;
        Tue,  7 Apr 2020 01:58:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 07 Apr 2020 01:58:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alistair23.me;
         h=from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=luaDFvJ4QP7HzTgY7DFCyyfDI0
        BXcg59edPeu9moQnE=; b=iWAedFWIY7AyUqXyEMCmfDoc8Nak2DLftjwUhJLLQk
        KNRmOJFxDfJQelE4tQso8nqPqTCL31xTtxABsBPSsUcMfpIKe1bykpddaAqUbthw
        /vl/Z9Jq9bNHA24yGTdB69hoCYVyLgtsVsk7fePlLWGZWDXCGTMZdXa8TOgiK85V
        pd9dsCtIU1YBudJZhbVYYjac0Y5fLIArn6ezaAN9xQZ8SgqJ9uqFjcLMOMc8sYIz
        pRYAU02EllzACZNByxAtfsQAs/LYL+tVt3ON7SLv7vLHKb1/P6OhdK+5WTx2v1+/
        ZC3VWm3Fjv58Przl49QI2qupSTk3MVYS9A+WJ432J4eA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=luaDFvJ4QP7HzTgY7
        DFCyyfDI0BXcg59edPeu9moQnE=; b=HU2zYuIb3dTywfn6VPUoR6iQ4DvjVfA6a
        HM+TF/HO7pF27scVLRt1zH0A/0lI70UatZoD3GNQUy243gLrac3W2iCay50Ov+YT
        K27RqrE9PzGeydBTzz+TX34aCWjfjGqUSjOQiuF3Yrf8V7jEkGczMYXQUOxhp6dF
        /iBC2Hhu8aP65ZgX5Ldf7ZPKt3kIkaApsciNqonHlE920OwyE2Qfa78gcday7Qwp
        YgfzosNZnOFO2keUO9YaeEk0bycSC7uosnwKgi/xES5kl3cwi1NmXCK05r9Zp5xc
        7DftnpnfR8u1zPQkjZwM8FokfE80X/uvWlbHtWuIxC34zO2n7eDSQ==
X-ME-Sender: <xms:lBaMXql_AK8NiqoqaaeLDZYYzQWffz2wIKyiEM7Yw5BBFWfrk_F9yA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudeggdellecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertdertd
    dtnecuhfhrohhmpeetlhhishhtrghirhcuhfhrrghntghishcuoegrlhhishhtrghirhes
    rghlihhsthgrihhrvdefrdhmvgeqnecuffhomhgrihhnpeguvghvihgtvghtrhgvvgdroh
    hrghenucfkphepjeefrdelfedrkeegrddvtdeknecuvehluhhsthgvrhfuihiivgeptden
    ucfrrghrrghmpehmrghilhhfrhhomheprghlihhsthgrihhrsegrlhhishhtrghirhdvfe
    drmhgv
X-ME-Proxy: <xmx:lBaMXqBF7Q_unFFUXTNyMVF3JuktDwLWCQ_9obH00fUJqGWQx1og_w>
    <xmx:lBaMXgsRucZ3VE9D9WFeHAiyxWkz-QH1boPQTPKGfsc80MYKdVyEsQ>
    <xmx:lBaMXkuKECeRlmoFykZo8892QfqB5oSg-NiZ2_-VMXo7cF22NI8HZw>
    <xmx:mBaMXnCjFgTFBSbWfIFyKYlmRZ3ZfVedIjjlZJfkBnVEJqixEVUmBA>
Received: from alistair-xps-14z.alistair23.me (c-73-93-84-208.hsd1.ca.comcast.net [73.93.84.208])
        by mail.messagingengine.com (Postfix) with ESMTPA id 869D6328005A;
        Tue,  7 Apr 2020 01:58:43 -0400 (EDT)
From:   Alistair Francis <alistair@alistair23.me>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        linux-bluetooth@vger.kernel.org, mripard@kernel.org, wens@csie.org
Cc:     anarsoul@gmail.com, devicetree@vger.kernel.org,
        alistair23@gmail.com, linux-arm-kernel@lists.infradead.org,
        Alistair Francis <alistair@alistair23.me>
Subject: [PATCH v2 1/3] dt-bindings: net: bluetooth: Add rtl8723bs-bluetooth
Date:   Mon,  6 Apr 2020 22:58:35 -0700
Message-Id: <20200407055837.3508017-1-alistair@alistair23.me>
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
v2:
 - Update bindings based on upstream feedback
 - Add RTL8822CS
 - Remove unused/unsupported fields
 - Remove firmware-postfix field
 - Small formatting changes

 .../bindings/net/realtek,rtl8723bs-bt.yaml    | 55 +++++++++++++++++++
 1 file changed, 55 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml

diff --git a/Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml b/Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml
new file mode 100644
index 000000000000..a03ce1bbc56f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/realtek,rtl8723bs-bt.yaml
@@ -0,0 +1,55 @@
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
+      - "realtek,rtl8723bs-bt"
+      - "realtek,rtl8723cs-bt"
+      - "realtek,rtl8822cs-bt"
+
+  device-wake-gpios:
+    maxItems: 1
+    description:
+      GPIO specifier, used to wakeup the BT module
+
+  enable-gpios:
+    maxItems: 1
+    description:
+      GPIO specifier, used to enable the BT module
+
+  host-wake-gpios:
+    maxItems: 1
+    desciption:
+      GPIO specifier, used to wakeup the host processor
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
2.25.1


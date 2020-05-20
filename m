Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D708B1DB19B
	for <lists+netdev@lfdr.de>; Wed, 20 May 2020 13:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgETL0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 May 2020 07:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726821AbgETLZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 May 2020 07:25:37 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E70CC061A0E
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:37 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id t8so2814478wmi.0
        for <netdev@vger.kernel.org>; Wed, 20 May 2020 04:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=960aYk+7qjUCxv3nxz7wYsvEJGuss0o+v4xW/qsO27M=;
        b=BCU9kXcgsvnTCYmmZyMFbfP42lV36jvtBS7MrNYkfkrrmo3HLhXzrQaRbuVtmKyVfV
         u8oAXKigGlsQaAvdeMR6sDIJhCefW2ALF4+q5EhzHXXRPvfKz0EgUba3SViyRQRpin1d
         NSWplR0VuNi5j1Z7aarc+weRotaLhPkMBYeVc8iZzp8T3r5+VmSIIghbwiNRVJs+VKZg
         9rbeP1qMPEiVhkPLGa4FgvYqvBtt221vvYH9bhhK4gpsNHWnaDA7Irft3gU7NwZKbkG/
         y6iCo22tU0JVcq7RsXsC1cmzYc3Aj53hs8lEMHagIu3zRYu8tFUIcZSzmDsyM3c49QLX
         irzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=960aYk+7qjUCxv3nxz7wYsvEJGuss0o+v4xW/qsO27M=;
        b=W1WcXayPtg55iQhcnEwQW/hci0Qa0H4rg0hlVaL1aE6MGis+gFdL5LR9EpbrsLdQqh
         OJIAJAq6+qmdqbvwfvpc47npFDJM8mUwxB0VMAlqM9+7nU1Ldtrvuk46U7FYDaKDNzD+
         3AvjDRTrNCnCr4Q7CoFrUoPIdShBYMcUaYz/eZZ8oarXQy4VsZ694aW0CF0Lc3HgWnRf
         IqRV3ZpFlrPD10GC/yHsdiBfE/NLezSKADFACInVo/28VX2in4k9Z9quOFhd+GeUcXxJ
         TSZp1zd1Pup42GIOiRAFafsX+Sk1xGAveOW1aX+08cXF1E9hl310QNTrBFUmRRzRFRng
         IDVw==
X-Gm-Message-State: AOAM531O90NIkULWRWPvRIv5g/iNPpUcOtueKAqjW8nheP6vPPYaaskv
        e/aZCim75PNmKz2Or4zo1ps6mA==
X-Google-Smtp-Source: ABdhPJy4SpnpwlPGPJPzN38GikiMlV7NO71LX5pXKBL7PLUJyF7PJcw8jt3g08t08cBRGSxi8p0+2w==
X-Received: by 2002:a1c:9895:: with SMTP id a143mr4310060wme.172.1589973935855;
        Wed, 20 May 2020 04:25:35 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id v22sm2729265wml.21.2020.05.20.04.25.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 04:25:35 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Edwin Peer <edwin.peer@broadcom.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Stephane Le Provost <stephane.leprovost@mediatek.com>,
        Pedro Tsai <pedro.tsai@mediatek.com>,
        Andrew Perepech <andrew.perepech@mediatek.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v4 03/11] dt-bindings: net: add a binding document for MediaTek Ethernet MAC
Date:   Wed, 20 May 2020 13:25:15 +0200
Message-Id: <20200520112523.30995-4-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200520112523.30995-1-brgl@bgdev.pl>
References: <20200520112523.30995-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This adds yaml DT bindings for the MediaTek Ethernet MAC present on the
mt8* family of SoCs.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../bindings/net/mediatek,eth-mac.yaml        | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml

diff --git a/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml b/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
new file mode 100644
index 000000000000..8ffd0b762c0f
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
@@ -0,0 +1,89 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mediatek,eth-mac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek Ethernet MAC Controller
+
+maintainers:
+  - Bartosz Golaszewski <bgolaszewski@baylibre.com>
+
+description:
+  This Ethernet MAC is used on the MT8* family of SoCs from MediaTek.
+  It's compliant with 802.3 standards and supports half- and full-duplex
+  modes with flow-control as well as CRC offloading and VLAN tags.
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+properties:
+  compatible:
+    enum:
+      - mediatek,mt8516-eth
+      - mediatek,mt8518-eth
+      - mediatek,mt8175-eth
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 3
+    maxItems: 3
+
+  clock-names:
+    additionalItems: false
+    items:
+      - const: core
+      - const: reg
+      - const: trans
+
+  mediatek,pericfg:
+    $ref: /schemas/types.yaml#definitions/phandle
+    description:
+      Phandle to the device containing the PERICFG register range. This is used
+      to control the MII mode.
+
+  mdio:
+    type: object
+    description:
+      Creates and registers an MDIO bus.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - mediatek,pericfg
+  - phy-handle
+
+examples:
+  - |
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/clock/mt8516-clk.h>
+
+    ethernet: ethernet@11180000 {
+        compatible = "mediatek,mt8516-eth";
+        reg = <0x11180000 0x1000>;
+        mediatek,pericfg = <&pericfg>;
+        interrupts = <GIC_SPI 111 IRQ_TYPE_LEVEL_LOW>;
+        clocks = <&topckgen CLK_TOP_RG_ETH>,
+                 <&topckgen CLK_TOP_66M_ETH>,
+                 <&topckgen CLK_TOP_133M_ETH>;
+        clock-names = "core", "reg", "trans";
+        phy-handle = <&eth_phy>;
+        phy-mode = "rmii";
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            eth_phy: ethernet-phy@0 {
+                reg = <0>;
+            };
+        };
+    };
-- 
2.25.0


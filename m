Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF421C57CE
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 16:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729334AbgEEODL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 10:03:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729247AbgEEODI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 10:03:08 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BA9DC061A10
        for <netdev@vger.kernel.org>; Tue,  5 May 2020 07:03:08 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id g12so2468290wmh.3
        for <netdev@vger.kernel.org>; Tue, 05 May 2020 07:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1RBYv7clwofuc4RomuNetMbXz5K8VN7BlCrpLgWGuKQ=;
        b=exa1u54LNh7NcTBkr9fjj1LtLgzCEkb41a3/XAcPpRhDL8uYlIw1yKBcaC3npPnAq+
         iNlvvzM/LMlufPMoM4dQZJ662snagyOfwpwmeJEqzq61YYz64HYeJRj+t1eanmoFGCCm
         ddLdtP3LKdxRSHIxe+vrvt/nhHYJVAn1o3UPfgDEWejxezv/4+QjsbqAvxgBe7whd+5j
         77G9QNzigkGdn3zaHrl1amKuP74s0sgTujd8o+/gAP4984gyy9fEV9GjDIQFQWbcI7X3
         11cm8fOu0E7dE+1WWNOwcnos+18bfhkHGHvtTqVQaqq7TSYiyOSef5MYIBHFOkOkZSnf
         cUQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1RBYv7clwofuc4RomuNetMbXz5K8VN7BlCrpLgWGuKQ=;
        b=dUQ8cRdqOT6HHdk+DxFwdzvfgvmtUqqwHlALKfIm4ht0ZV0VUWbbVBlHQVU4ucZR3P
         vsvvrbRwI+peDTS0zIlFxlv8BEg9Q3dO7ojx6OtLLzfGjdbRliJdMXyyessOA5lUc8B1
         0wFn3nsBh1Y78k70hrWh2vyckWJHotG9NkNXRf215SfxwKswk2PYxrT4opX7oFSvhqZK
         bpDPl8xMAizzt1aecpt+X1uwQXWjLn+VWoj/vxAt9YRdJbQFqcXM1B7XzfsGN9THFMWs
         skeiSQ+V64OZb4vElr+3gOOjr6a3NYWWd7G8Vg+OaEo1r41h+Ho/F352JzE4tm3LWcZu
         wHuw==
X-Gm-Message-State: AGi0PubQ25IyOnsgHJvpuGmkSBXvpzBcctPwfXMKg8xU8p/lLmtu3p/N
        XN6Tes9XTnEhuiC7pbPlHY8JFg==
X-Google-Smtp-Source: APiQypKyODJ/h2tkRj/3s4Rn7dN4YkXrc4seYlCWxagOZmnAKutgDsCqy57VDKSasTPAC6+hVxwWqw==
X-Received: by 2002:a1c:9c0a:: with SMTP id f10mr3688664wme.139.1588687386996;
        Tue, 05 May 2020 07:03:06 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id c190sm4075755wme.4.2020.05.05.07.03.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2020 07:03:06 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@openwrt.org>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Fabien Parent <fparent@baylibre.com>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH 02/11] dt-bindings: new: add yaml bindings for MediaTek Ethernet MAC
Date:   Tue,  5 May 2020 16:02:22 +0200
Message-Id: <20200505140231.16600-3-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200505140231.16600-1-brgl@bgdev.pl>
References: <20200505140231.16600-1-brgl@bgdev.pl>
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
 .../bindings/net/mediatek,eth-mac.yaml        | 80 +++++++++++++++++++
 1 file changed, 80 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml

diff --git a/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml b/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
new file mode 100644
index 000000000000..7682fe9d8109
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
@@ -0,0 +1,80 @@
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
+      Phandle to the device containing the PERICFG register range.
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
+        reg = <0 0x11180000 0 0x1000>;
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


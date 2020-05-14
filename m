Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FAD51D2989
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 10:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgENIBh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 04:01:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726126AbgENIAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 04:00:10 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50463C061A0E
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:10 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id m24so19556292wml.2
        for <netdev@vger.kernel.org>; Thu, 14 May 2020 01:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=960aYk+7qjUCxv3nxz7wYsvEJGuss0o+v4xW/qsO27M=;
        b=1dSFkxErs5IgQZQB4I5++tl6Djzi/CzZEIBnYx339dfUV4I61PUyud3aT4fwNNzNcx
         v5HIcFgNEcVjDy1umMcmQchjN2Qm9/jz5aQZGBfG0MN7QYDwFq9SI1Lxl9wqtVPyNXFc
         6LVT/omKGSYddx9jUaMiEBeLSaLvclEwZmvDFtiBorLaMmC9DI3tPHSo/e3HeHXcx035
         ZJ0UbnRVUGYfNXOM4O1L/pR++et2VuIwgSxCs5Bq+wGGfbo8t7CvToEae+0071vFdSZq
         y9b/T2Cnn+xwyz6iyLCiSKg9xdF+OHQQZTBk87vITrH3/whLEgig++rjfdXFZNsyvHIz
         Am/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=960aYk+7qjUCxv3nxz7wYsvEJGuss0o+v4xW/qsO27M=;
        b=LvMG61sjcb0/QDtRcaQnYdl4Vxa1+dXfJ9egayVktHEsInbK7Nl/ulLkb04U8GHtCL
         8s6orc2xzms18eMXCasZbd+j+8vLAVDmB6NauRCDMJfjqx+Jus3C4bRTfEnDk0jLq+2k
         X6aRh0hZMei99GC0cRKlt0RFg3c+7Mok/WoL8x/RVcRo8Oz3EMWc7wE4zNmnrjj06Wc6
         4A2UqZ/gLye338Q+qFkMaosKjdqms1dT3ygiLjJiAQjlR+oLXRxZuWZl/7KAlQD9yH7Y
         soFOvBgbLCV/uQV6hjyRaPDk4SAZZQAkQNk9vh6n7RRIHpAKsrkJYNYfT5CV9lxghciP
         gE7w==
X-Gm-Message-State: AOAM5328THO1KYVAXRelmYn6nR6BmWU7hUtxTN3SiC0v+kjoIs4yM7+v
        hQTd4Nm1GEZz1EFiOROzORFsmA==
X-Google-Smtp-Source: ABdhPJxpTdP2zY7sNzXIcpkSTenXVHVMvIGknxxkl3kd2ljlHbFx4UsDatBg25EwP7kACYrAaYfLpw==
X-Received: by 2002:a1c:2707:: with SMTP id n7mr84160wmn.147.1589443208862;
        Thu, 14 May 2020 01:00:08 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id 81sm23337446wme.16.2020.05.14.01.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 01:00:08 -0700 (PDT)
From:   Bartosz Golaszewski <brgl@bgdev.pl>
To:     Jonathan Corbet <corbet@lwn.net>, Rob Herring <robh+dt@kernel.org>,
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
Subject: [PATCH v3 03/15] dt-bindings: net: add a binding document for MediaTek Ethernet MAC
Date:   Thu, 14 May 2020 09:59:30 +0200
Message-Id: <20200514075942.10136-4-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200514075942.10136-1-brgl@bgdev.pl>
References: <20200514075942.10136-1-brgl@bgdev.pl>
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


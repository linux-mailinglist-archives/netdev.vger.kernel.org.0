Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76BAF1DE64B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 14:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729967AbgEVMI1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 08:08:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729204AbgEVMH0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 08:07:26 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB087C08C5C4
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:25 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id l11so9976981wru.0
        for <netdev@vger.kernel.org>; Fri, 22 May 2020 05:07:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bgdev-pl.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/pmWjPydDcH2ECRLQQUecpuUxdBwIQiF7KV5PtBBYA0=;
        b=i0LAaJO4/OsiG8tHqQqh8QMJFnyB9fw0SVJmnxPGwVTC6c84IGU5mK5QyKhXXyAdJY
         gwxhvTbndWQZIPz4rlVu6qopD/zba+IYsJRc0V8W25aObCVlipS1HOIqHGeuz4IRwc0C
         3WkftM8s+RgwQxuqLazSX/TOdAZqK2SNnCMJCce1G8I5UroZMlsPaWtI1A3KC0M35wNv
         5PTjSWIHb9XdOhVpsE/mAichJ+oodz+TsK9zHPZGJCX7A4uGLz0CCB5ySpw+QlijqLzE
         utvl5/7gbRxf6t+9Os+RqahStxHmEBlGoJ9zX+YiptZIfhJagdJ0rLderVS/L4oc62u1
         vMHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/pmWjPydDcH2ECRLQQUecpuUxdBwIQiF7KV5PtBBYA0=;
        b=rHR1Ey9aLz8QNh07sinaHsEixg5xbIou2p6pg+L6Lp1YN+zYy32IyTzRFEM/nhdQ7v
         N0dRl0B0ER5aQggMHhT0pTyoKhULOVE7p2RUqY2hB54kYDN9S0Gqf4JaS8cysgAZYlNc
         y5a7Uf98xosZf1ZhcQKiUqLcg5G81LKMIX3ztKdsJPXV8qL9DxOVYX+X5UG6fewZ9VoL
         NKTnvtvVTOurJsx8wYw9hqZOprQv5IE+NcTmKcagdDFM6GeKRpJ5pD/yXteGuG02/sH1
         Q8SrWk4FpWpAlv5M4YNvRYJnqObJ/ta8MWkH5aBPensWY0XY1QzV02uA/vWCf2v0kj+p
         EROw==
X-Gm-Message-State: AOAM5328/LbPgoQo0Au7FBskRhYiUf6DTkDT6QAh+WZ+dcyTDMl4pWXK
        0cy80Rx60xyExKnu/qFDTxN2LA==
X-Google-Smtp-Source: ABdhPJyhBs1vuweSsT6UnZzHIxmupzWKr/Mklf9iaHHEzRP3oB0F6VGJEWNBq1p2UGylX27IQJUkew==
X-Received: by 2002:a5d:4dd0:: with SMTP id f16mr1475060wru.117.1590149244637;
        Fri, 22 May 2020 05:07:24 -0700 (PDT)
Received: from localhost.localdomain (lfbn-nic-1-65-232.w2-15.abo.wanadoo.fr. [2.15.156.232])
        by smtp.gmail.com with ESMTPSA id f128sm9946233wme.1.2020.05.22.05.07.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2020 05:07:24 -0700 (PDT)
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
Subject: [PATCH v5 03/11] dt-bindings: net: add a binding document for MediaTek STAR Ethernet MAC
Date:   Fri, 22 May 2020 14:06:52 +0200
Message-Id: <20200522120700.838-4-brgl@bgdev.pl>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200522120700.838-1-brgl@bgdev.pl>
References: <20200522120700.838-1-brgl@bgdev.pl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

This adds yaml DT bindings for the MediaTek STAR Ethernet MAC present
on the mt8* family of SoCs.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 .../bindings/net/mediatek,eth-mac.yaml        | 89 +++++++++++++++++++
 1 file changed, 89 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml

diff --git a/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml b/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
new file mode 100644
index 000000000000..f85d91a9d6e5
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/mediatek,eth-mac.yaml
@@ -0,0 +1,89 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/mediatek,eth-mac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MediaTek STAR Ethernet MAC Controller
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


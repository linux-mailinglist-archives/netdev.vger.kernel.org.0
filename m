Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 359284645C1
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346653AbhLAEQX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:16:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346579AbhLAEQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:16:09 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCFA0C061761;
        Tue, 30 Nov 2021 20:12:43 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so19971346pjb.5;
        Tue, 30 Nov 2021 20:12:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QnOl9pS4YwArjHGgjzz1ujnilCqfZpwQuY83gQxN+dA=;
        b=ju6S4vdD6ks7/xXMnbMwpIcH15H08wA41nE9cOZreOJUXUqkjNYmJZ952hyUOMBblI
         3N7PIEyU3n/37cwWztiUNK7FHp8sPHElKuVQ9v+2AlN2cRKiv/8QDAikpRDMl6ysBWES
         6KCa6BlcGGDWnaI9mfX568u+F0vB/pJiUd8WLbN6hE4NCV0WpMkfRDboYAPDtf0cN8zD
         oHT8ZbXGtIVdDEb90fc7yozBRL88ZPixijWyHKq9Eu64uNaLPbMLQmq0rhWg0wkDqPlT
         3w47CklvAjALTCLi8hJtPYVsMdguWKamknXlxWy3aZNi1XgOngenRW1oRQi2kkyrC9Na
         qpCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QnOl9pS4YwArjHGgjzz1ujnilCqfZpwQuY83gQxN+dA=;
        b=JSICXXB0jJynMTxFCTkq7f/3ydx6GPay5xVURsxGnjt/GvXek55HPNcIbPQq8juSaW
         lXUgdFD/ickH5gPpJ8x5/ixI3Aco7itngrkbYUkVapPGVT5O72n4X7pQ95MY+BiWvSB4
         aEnLxYSjZXTCLTrhGp82Cb5awpzai4HEOfdfnbzaOw6J0JN0xvYVmZBNaS+xVZFmW3OZ
         dVDxTBpQewMAIWnFQ30WWZB8YLb8RDcN1EXDfC6dvvW2705CEXRYdmEnS+ov+yBTvIbD
         0J0/FtOZIfPv7hX+xDWunwRkM+FEhqAr4ge88ZWhpxJuYOq2ekyebLqg5dZs8PZB2G2b
         6tPg==
X-Gm-Message-State: AOAM531JymPrc7UdnjQyh0TgFo3d4lKvlKhohBqThDAeJy9c2k0MLn8e
        JubYaWbNW/ofH8CQh98VHbYcZyBB24k=
X-Google-Smtp-Source: ABdhPJyfgo1kyazz8qEK1SyEP5TB48crf42REQ2nITGkQ11f66OA25gkuqq2y0t8Mv9suNP/ft1PXg==
X-Received: by 2002:a17:90a:6f61:: with SMTP id d88mr4338069pjk.109.1638331963052;
        Tue, 30 Nov 2021 20:12:43 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id s8sm4296451pfe.196.2021.11.30.20.12.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:12:42 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER), Doug Berger <opendmb@gmail.com>,
        Ray Jui <rjui@broadcom.com>,
        Scott Branden <sbranden@broadcom.com>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE)
Subject: [PATCH net-next 6/7] dt-bindings: net: Convert SYSTEMPORT to YAML
Date:   Tue, 30 Nov 2021 20:12:27 -0800
Message-Id: <20211201041228.32444-7-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201041228.32444-1-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Broadcom SYSTEMPORT Ethernet controller Device Tree binding
to YAML.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../bindings/net/brcm,systemport.txt          | 38 ---------
 .../bindings/net/brcm,systemport.yaml         | 83 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 84 insertions(+), 38 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,systemport.txt b/Documentation/devicetree/bindings/net/brcm,systemport.txt
deleted file mode 100644
index 75736739bfdd..000000000000
--- a/Documentation/devicetree/bindings/net/brcm,systemport.txt
+++ /dev/null
@@ -1,38 +0,0 @@
-* Broadcom BCM7xxx Ethernet Systemport Controller (SYSTEMPORT)
-
-Required properties:
-- compatible: should be one of:
-	      "brcm,systemport-v1.00"
-	      "brcm,systemportlite-v1.00" or
-	      "brcm,systemport"
-- reg: address and length of the register set for the device.
-- interrupts: interrupts for the device, first cell must be for the rx
-  interrupts, and the second cell should be for the transmit queues. An
-  optional third interrupt cell for Wake-on-LAN can be specified
-- local-mac-address: Ethernet MAC address (48 bits) of this adapter
-- phy-mode: Should be a string describing the PHY interface to the
-  Ethernet switch/PHY, see Documentation/devicetree/bindings/net/ethernet.txt
-- fixed-link: see Documentation/devicetree/bindings/net/fixed-link.txt for
-  the property specific details
-
-Optional properties:
-- systemport,num-tier2-arb: number of tier 2 arbiters, an integer
-- systemport,num-tier1-arb: number of tier 1 arbiters, an integer
-- systemport,num-txq: number of HW transmit queues, an integer
-- systemport,num-rxq: number of HW receive queues, an integer
-- clocks: When provided, must be two phandles to the functional clocks nodes of
-  the SYSTEMPORT block. The first phandle is the main SYSTEMPORT clock used
-  during normal operation, while the second phandle is the Wake-on-LAN clock.
-- clock-names: When provided, names of the functional clock phandles, first
-  name should be "sw_sysport" and second should be "sw_sysportwol".
-
-Example:
-ethernet@f04a0000 {
-	compatible = "brcm,systemport-v1.00";
-	reg = <0xf04a0000 0x4650>;
-	local-mac-address = [ 00 11 22 33 44 55 ];
-	fixed-link = <0 1 1000 0 0>;
-	phy-mode = "gmii";
-	interrupts = <0x0 0x16 0x0>,
-		<0x0 0x17 0x0>;
-};
diff --git a/Documentation/devicetree/bindings/net/brcm,systemport.yaml b/Documentation/devicetree/bindings/net/brcm,systemport.yaml
new file mode 100644
index 000000000000..f8bfc5474a19
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,systemport.yaml
@@ -0,0 +1,83 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,systemport.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom BCM7xxx Ethernet Systemport Controller (SYSTEMPORT)
+
+maintainers:
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+properties:
+  compatible:
+    enum:
+      - brcm,systemport-v1.00
+      - brcm,systemportlite-v1.00
+      - brcm,systemport
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    minItems: 2
+    maxItems: 3
+    items:
+      - description: interrupt line for RX queues
+      - description: interrupt line for TX queues
+      - description: interrupt line for Wake-on-LAN
+
+  clocks:
+    items:
+      - description: main clock
+      - description: Wake-on-LAN clock
+
+  clock-names:
+    items:
+      - const: sw_sysport
+      - const: sw_sysportwol
+
+  "systemport,num-tier2-arb":
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Number of tier 2 arbiters
+
+  "systemport,num-tier1-arb":
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Number of tier 2 arbiters
+
+  "systemport,num-txq":
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Number of HW transmit queues
+
+  "systemport,num-rxq":
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Number of HW receive queues
+
+required:
+  - reg
+  - interrupts
+  - phy-mode
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+
+additionalProperties: true
+
+examples:
+  - |
+    ethernet@f04a0000 {
+        compatible = "brcm,systemport-v1.00";
+        reg = <0xf04a0000 0x4650>;
+        local-mac-address = [ 00 11 22 33 44 55 ];
+        phy-mode = "gmii";
+        interrupts = <0x0 0x16 0x0>,
+                     <0x0 0x17 0x0>;
+        fixed-link {
+            speed = <1000>;
+            full-duplex;
+        };
+    };
diff --git a/MAINTAINERS b/MAINTAINERS
index 6b32420bd9bd..8f544447ef94 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3983,6 +3983,7 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/broadcom/bcmsysport.*
 F:	drivers/net/ethernet/broadcom/unimac.h
+F:	Documentation/devicetree/bindings/net/brcm,systemport.yaml
 
 BROADCOM TG3 GIGABIT ETHERNET DRIVER
 M:	Siva Reddy Kallam <siva.kallam@broadcom.com>
-- 
2.25.1


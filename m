Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB08546546D
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:57:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352114AbhLASAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352040AbhLASAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:00:37 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CCB7C061761;
        Wed,  1 Dec 2021 09:57:10 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id 133so6271263pgc.12;
        Wed, 01 Dec 2021 09:57:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=aa5Ws1F22vChn3gRvEo2dOdDM88h3YVq71TvWa1r5ug=;
        b=LAGe/R42jpeJqH8NCWEQkoXB5Rqxs/Tbu2WBmC1SKO9PEeqz43n0OINEglEZjUt1yJ
         UMFJ470LFcbnGxpGTf7jPYhsmNDW/a3WHuAXepFZ1G0XTFrl4uw30nW79WOECwYVze9D
         BEKl9Ha/ryoWzBiNgFu3us2+mp2GS45Mh6AUJcl6Phr7jRiQHN09wwqt/3E2S6XPSBs8
         GxHXDx1p/Irg22NXY+h1dYS3gLJ3pcIlOBKZsOLHe79Ry0qG1evCHwOfKuSIEXmpAlMg
         lEzetlgxNDaeWeVuNdpBJdx4+drfO8ZYYeXZd/njz4i32+SGCGF8WHIoIwqWAnzH4vDO
         5f+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aa5Ws1F22vChn3gRvEo2dOdDM88h3YVq71TvWa1r5ug=;
        b=CdI9EmWSHXh6BPW+4VL1fgoBQIPwmjqui76f/r11rQl47MMm90ELFUjvHPA02Uxu2Q
         rHxJw7qOxnZXiLj9CBzvw0tlOlKMdSXUogBfEVGI0D8VAv4RqScDlJOBBrB/6+EV1ZYo
         fzCK+Mh1f4Blx0dfbFDHm7cR8MNKU5n/eUJfCsjr0oXNVGsN3QeNstfVUkove5dxHaY2
         ndKu9pzetDGmWOYP6tSNkEoucPBU9xDxt42h1v0QNEutbEW0/rs9oxwZQfBJ4IiaQJ84
         bZCzQKWbzqvacUGzB5ZmNFg05k8BploG4nC9ZLyaTh5CLp7bLRU9VQw14qVtfBKUIc1N
         D1Gw==
X-Gm-Message-State: AOAM533RPaABOSo/EOl5TAijAwAl8FZBn9MxmqaL0qVwcBNj76AOZw5k
        ikNa5wAfmRqhD+8celyczWDBAMvtGy8=
X-Google-Smtp-Source: ABdhPJypwY1A1ipTzyB0dHar4IILUlsjTCrtk1ed8DjyW2mjy101JQkkR/NJoBKV3OonbusEhjFWmw==
X-Received: by 2002:a63:2c8c:: with SMTP id s134mr5726520pgs.221.1638381429226;
        Wed, 01 Dec 2021 09:57:09 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j13sm471546pfc.151.2021.12.01.09.57.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:57:08 -0800 (PST)
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
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND FLATTENED
        DEVICE TREE BINDINGS), linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH net-next v2 7/9] dt-bindings: net: Convert SYSTEMPORT to YAML
Date:   Wed,  1 Dec 2021 09:56:50 -0800
Message-Id: <20211201175652.4722-8-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201175652.4722-1-f.fainelli@gmail.com>
References: <20211201175652.4722-1-f.fainelli@gmail.com>
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
 .../bindings/net/brcm,systemport.yaml         | 82 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 83 insertions(+), 38 deletions(-)
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
index 000000000000..44781027ed37
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,systemport.yaml
@@ -0,0 +1,82 @@
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


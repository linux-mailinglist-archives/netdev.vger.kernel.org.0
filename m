Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50A5946A3BD
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239979AbhLFSG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346790AbhLFSEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:04:39 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6469EC0613F8;
        Mon,  6 Dec 2021 10:01:01 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id r5so11205007pgi.6;
        Mon, 06 Dec 2021 10:01:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UVNTosnM4u/yIXEa/LyWVTOOCpFmbmo5mKS9SOh7Wz8=;
        b=auz+ucFGlmqD2BqC9WFBo4dVqfETASPzVTRtljRXHuccp3+SZOgp7A6JaxTcyvG9eg
         aODjdqLdH5zlEeXHjLYg9d6hPLCQQu8s3JhCz+MVZ4lTeYzTcWCw/hF9GUXBCnAGXW1K
         pa+SziJt/63GqjdgQAAy90hqnZajQMMExqkWx2//32lIX/ihmzYDvbK31dOj/2O+Itz/
         sGKjREjT7mFAfWrNVS7jT/b5hOIf7//c6c8wPpicq874iyttVoslnLuGpAtVrwM3Rimj
         6o4Ul3y1W7mM6RikBalh77hzNrrv0qHHxryHx7XTDD9XEZnWsHptlLyFlj+lPvI+SK/I
         L1Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UVNTosnM4u/yIXEa/LyWVTOOCpFmbmo5mKS9SOh7Wz8=;
        b=m3401MqBsJtRVbeefoxuY+zexT91bVCSYXpApZ1sY3n/vSJ+xSNTMn1hcAWKgMTB0L
         EwXD7RV6fNr6vRfDPEwHcj2XsWUZ3zlr9/2v0GCIif83DR3Qph8YSzOV4lXiNzOIqUlp
         rae8k/FnCRB9W4LPtKED78M6HJsBQtzzES934arLd5PJXsDnzP4H673U5DCnFS+1VVqU
         2zPD9DPOQZSn4N2+HRmWxk+k1RHyrpkJgq//iW+brcujtJSsI3QvcN0BFoiu2t1eDA/Q
         n+/8AM+cn/nYngAZEcV0FgsNSApFP9CAJJZD/PFurcEGUJl2z9bar271QOtb+SUkho6v
         Ia7A==
X-Gm-Message-State: AOAM531NFNoV3jIR2tb28W3R8VGAKmvYQMVfdb6nlvcZw1Eyun8G0epu
        JGSjiTYb9vpwml0xUszRUwGL/bG428c=
X-Google-Smtp-Source: ABdhPJwkDk7LSBP5K9dd33jL6DSQ4OmFu0cjiIYYOgCe8vQwrJFBKayhp10szOtUQzs1j5OnSFwMrw==
X-Received: by 2002:a63:8f52:: with SMTP id r18mr19818348pgn.197.1638813660546;
        Mon, 06 Dec 2021 10:01:00 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u11sm5444070pfg.120.2021.12.06.10.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:01:00 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     devicetree@vger.kernel.org
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
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:BROADCOM IPROC ARM
        ARCHITECTURE),
        linux-phy@lists.infradead.org (open list:GENERIC PHY FRAMEWORK)
Subject: [PATCH v3 6/8] dt-bindings: net: Convert SYSTEMPORT to YAML
Date:   Mon,  6 Dec 2021 10:00:47 -0800
Message-Id: <20211206180049.2086907-7-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206180049.2086907-1-f.fainelli@gmail.com>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
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
index 404e76d625f1..ed8de605fe4b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3972,6 +3972,7 @@ L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/broadcom/bcmsysport.*
 F:	drivers/net/ethernet/broadcom/unimac.h
+F:	Documentation/devicetree/bindings/net/brcm,systemport.yaml
 
 BROADCOM TG3 GIGABIT ETHERNET DRIVER
 M:	Siva Reddy Kallam <siva.kallam@broadcom.com>
-- 
2.25.1


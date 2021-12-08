Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2321A46DD10
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240339AbhLHUbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236827AbhLHUbm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 15:31:42 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C58C061746;
        Wed,  8 Dec 2021 12:28:10 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id p18-20020a17090ad31200b001a78bb52876so5190128pju.3;
        Wed, 08 Dec 2021 12:28:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NXm4jcoY2wWZYcIB4pskJCyDvuGoy0M2H8ri6W/OWw0=;
        b=LcGUSWcvTgm6XCi0g/Ec6cMT4URqBwtWlK1qMKLjkJgmt4cRK2U6YFbxZIHnQqULcw
         DG75hxpBobuXy/ZtICaV5JgC+mfOawkLKznqKHRjkcqQhhM8OtLZ3o6sdhI5qyrBPDU3
         Y8MyTb1C6Dafl8JYzyKbiABB2m9YBJgqbLcKmLiASFMefGapV4g7o7QPHUM27JHJOlGs
         sxuk/EM/aizKpoEhifPBF/wYcRW+GwPE9ProxUcJclhcsr2lNH+kcV97pGfXmj/47Sx1
         zBDOgzP4l6vGV27WHILrYBgrevq3pLGOwj8gvVmZZs1gCjZRWtvDMe1/raMqQ9tOHqe7
         TIaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NXm4jcoY2wWZYcIB4pskJCyDvuGoy0M2H8ri6W/OWw0=;
        b=XeXZVvduRitRIOyjRixGLD3qHzlMDxb7NXeDvNHZUHDuANM54KYu3ch4ETUOhP1I2I
         AMw5sqc+ew20mLLYtDtjVGrtOsToib5yHyqykG1FNQLDInkYKdhAp14C8HJXkVoy+Nq+
         My3Dm510J+uz4ro9/fQwq6LFKPuMNOFGPJE6bNmqFRbK1vhOk3mlv0/DvvHfNyAPuYuZ
         euXONPEdfHSvN5ALHlVi9eXOYa4MXZIZMecNHmtT8tOZVMglaFl8G6a6T72XPSUjT5k1
         vIocu4rU7rkhi2BtO/K4soQjnqLiLP6P7iBNWq+F1RXABCKn2ijwJQi7s2WDKxikD5Nu
         hZig==
X-Gm-Message-State: AOAM532cYkPo16dPJhzJuVhQiSo/qH64d+BYk4kgds4H/kowgCVZby89
        dWARA23qegA8G4NDDEsu2ykPr8qrnaE=
X-Google-Smtp-Source: ABdhPJw6+sKrDGU/LW5yKAZEViMrKOUAV3zLCzS1/k/s4tCAJHPfGP1xTWIHLDNigNi9fj+RdAD7lA==
X-Received: by 2002:a17:90a:4894:: with SMTP id b20mr9845216pjh.121.1638995289993;
        Wed, 08 Dec 2021 12:28:09 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d17sm4592291pfj.124.2021.12.08.12.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 12:28:09 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     devicetree@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
        bcm-kernel-feedback-list@broadcom.com (maintainer:BROADCOM IPROC GBIT
        ETHERNET DRIVER),
        netdev@vger.kernel.org (open list:NETWORKING DRIVERS),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH v4 1/2] dt-bindings: net: Convert AMAC to YAML
Date:   Wed,  8 Dec 2021 12:28:00 -0800
Message-Id: <20211208202801.3706929-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208202801.3706929-1-f.fainelli@gmail.com>
References: <20211208202801.3706929-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Broadcom AMAC Device Tree binding to YAML to help with
schema and dtbs checking.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../devicetree/bindings/net/brcm,amac.txt     | 30 -------
 .../devicetree/bindings/net/brcm,amac.yaml    | 88 +++++++++++++++++++
 MAINTAINERS                                   |  2 +-
 3 files changed, 89 insertions(+), 31 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,amac.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,amac.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,amac.txt b/Documentation/devicetree/bindings/net/brcm,amac.txt
deleted file mode 100644
index 0120ebe93262..000000000000
--- a/Documentation/devicetree/bindings/net/brcm,amac.txt
+++ /dev/null
@@ -1,30 +0,0 @@
-Broadcom AMAC Ethernet Controller Device Tree Bindings
--------------------------------------------------------------
-
-Required properties:
- - compatible:	"brcm,amac"
-		"brcm,nsp-amac"
-		"brcm,ns2-amac"
- - reg:		Address and length of the register set for the device. It
-		contains the information of registers in the same order as
-		described by reg-names
- - reg-names:	Names of the registers.
-		"amac_base":	Address and length of the GMAC registers
-		"idm_base":	Address and length of the GMAC IDM registers
-				(required for NSP and Northstar2)
-		"nicpm_base":	Address and length of the NIC Port Manager
-				registers (required for Northstar2)
- - interrupts:	Interrupt number
-
-The MAC address will be determined using the optional properties
-defined in ethernet.txt.
-
-Examples:
-
-amac0: ethernet@18022000 {
-	compatible = "brcm,nsp-amac";
-	reg = <0x18022000 0x1000>,
-	      <0x18110000 0x1000>;
-	reg-names = "amac_base", "idm_base";
-	interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
-};
diff --git a/Documentation/devicetree/bindings/net/brcm,amac.yaml b/Documentation/devicetree/bindings/net/brcm,amac.yaml
new file mode 100644
index 000000000000..8f031932c8af
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,amac.yaml
@@ -0,0 +1,88 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,amac.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom AMAC Ethernet Controller Device Tree Bindings
+
+maintainers:
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,amac
+    then:
+      properties:
+        reg:
+          maxItems: 2
+        reg-names:
+          maxItems: 2
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,nsp-amac
+    then:
+      properties:
+        reg:
+          minItems: 2
+          maxItems: 2
+        reg-names:
+          minItems: 2
+          maxItems: 2
+
+  - if:
+      properties:
+        compatible:
+          contains:
+            enum:
+              - brcm,ns2-amac
+    then:
+      properties:
+        reg:
+          minItems: 3
+        reg-names:
+          minItems: 3
+
+properties:
+  compatible:
+    enum:
+      - brcm,amac
+      - brcm,nsp-amac
+      - brcm,ns2-amac
+
+  interrupts:
+    maxItems: 1
+
+  reg:
+    minItems: 1
+    maxItems: 3
+
+  reg-names:
+    minItems: 1
+    items:
+      - const: amac_base
+      - const: idm_base
+      - const: nicpm_base
+
+unevaluatedProperties: false
+
+examples:
+  - |
+   #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+   amac0: ethernet@18022000 {
+      compatible = "brcm,nsp-amac";
+      reg = <0x18022000 0x1000>,
+            <0x18110000 0x1000>;
+      reg-names = "amac_base", "idm_base";
+      interrupts = <GIC_SPI 147 IRQ_TYPE_LEVEL_HIGH>;
+   };
diff --git a/MAINTAINERS b/MAINTAINERS
index 5e1064c23f41..404e76d625f1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3861,7 +3861,7 @@ M:	Rafał Miłecki <rafal@milecki.pl>
 M:	bcm-kernel-feedback-list@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/brcm,amac.txt
+F:	Documentation/devicetree/bindings/net/brcm,amac.yaml
 F:	drivers/net/ethernet/broadcom/bgmac*
 F:	drivers/net/ethernet/broadcom/unimac.h
 
-- 
2.25.1


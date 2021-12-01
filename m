Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDEB046546C
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:57:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352096AbhLASAq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352038AbhLASAh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:00:37 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEBDCC06175D;
        Wed,  1 Dec 2021 09:57:08 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id p13so17656901pfw.2;
        Wed, 01 Dec 2021 09:57:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KYMDVSre6+yLu8zD+7T8spnd61FbSvWPFURC895A/Tk=;
        b=KcIbR+oPFhCoj00vXrvlusdYemqIiSOnE3GdyiYRztMB8Dy/rlm9R2MvyGGcvK1O9d
         cUgPkbAwPzfGzKYLY4AVmh0HqDvwtbdupglIiJmRQx7AqjhOHsFW8r9NZhHkf8lgVhy5
         BOPFsCFO246aG7YocvXhutSYzxpXXQnNILQvbDDsQyBdv9Dx9WbjJdbMjPHaepWuEij+
         ST9OkZqM40nFH/YP2ynakoFYX2BAtPcZYXYcuPPZ4OxeqgHPgRBRlkC8mOUUnSfWJ0Yv
         qaNq8/DkQzpqgdrsDZvPKec22B2xZfUfnhfrkBKCBkhH2P/UVu2lcmRJTQzpSR5IsucT
         2qcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KYMDVSre6+yLu8zD+7T8spnd61FbSvWPFURC895A/Tk=;
        b=2CBJuPfn8oowPTRa59mUr5YrhUl8tFUXBUh6a5i7ydJAzAcYxnxvaeLyEOIw21+FGv
         ukMZZQMG8CjgsvICu1KzOxPEaZcXWhbsgbjZF1l3xo5lCPPycUFDh2mgf+ao3jX4TnkM
         XpVQK+yM94KRFWafDBe9fUowdkloeCWBFl1E2nw2OvDqnlZNhi6LpDa2DUepOS4gpSLv
         NTJ5Xkwyr2G8F0GmrE5jO2FkNQua0HJ1F3gk6pXKgW9UM79Cnn492+ld8YCBY4ArlHdu
         wxGAGtPBgu+YDhuqV7Cnec183Jxa6adnxVQLMEk+We6vv8GMUMbaDwgTW/qGGmfJKexb
         KyiA==
X-Gm-Message-State: AOAM530a8l9dJhoEAU/Q+PLJfvn1QAoK5pOL239n+1J+9TCErcRU/kkz
        P8X8oWO77lJUL69nfktGxO40fWnuq+g=
X-Google-Smtp-Source: ABdhPJwJCTGDL3Jx21xteh0JyBvOYoagGEJ8sFjmkkeVQ65cWgvIiV7LDRhQeT7DVJ1qfm0XXh4Hrw==
X-Received: by 2002:a63:5520:: with SMTP id j32mr5904336pgb.443.1638381427878;
        Wed, 01 Dec 2021 09:57:07 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j13sm471546pfc.151.2021.12.01.09.57.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:57:07 -0800 (PST)
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
Subject: [PATCH net-next v2 6/9] dt-bindings: net: Convert AMAC to YAML
Date:   Wed,  1 Dec 2021 09:56:49 -0800
Message-Id: <20211201175652.4722-7-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201175652.4722-1-f.fainelli@gmail.com>
References: <20211201175652.4722-1-f.fainelli@gmail.com>
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
index 000000000000..d9de68aba7d3
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
+          minItems: 1
+          maxItems: 2
+        reg-names:
+          minItems: 1
+          maxItems: 2
+          items:
+            - const: amac_base
+            - const: idm_base
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
+          items:
+            - const: amac_base
+            - const: idm_base
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
+          maxItems: 3
+        reg-names:
+          items:
+            - const: amac_base
+            - const: idm_base
+            - const: nicpm_base
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
index eb0f6caf0062..6b32420bd9bd 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3872,7 +3872,7 @@ M:	Rafał Miłecki <rafal@milecki.pl>
 M:	bcm-kernel-feedback-list@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Maintained
-F:	Documentation/devicetree/bindings/net/brcm,amac.txt
+F:	Documentation/devicetree/bindings/net/brcm,amac.yaml
 F:	drivers/net/ethernet/broadcom/bgmac*
 F:	drivers/net/ethernet/broadcom/unimac.h
 
-- 
2.25.1


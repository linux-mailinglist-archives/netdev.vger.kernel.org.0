Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E01C46A3BF
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346074AbhLFSG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:06:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346010AbhLFSEj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:04:39 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06F02C061746;
        Mon,  6 Dec 2021 10:01:00 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id 137so11249968pgg.3;
        Mon, 06 Dec 2021 10:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7lGSpdbBtSUGX8TNpVCqyb1N9KeekyFB33Hw0tfwp0Q=;
        b=bub+lU47r+RTeRssGc2TDlza/a1TPsewO1uqfzgN9o/JJbyf3cZ0L5dGxmEUIrWixD
         3UsHOYdPyWgoumBTrdRJL5wnWQ7VY4HDhwvZ2h+FweNKg2j5Ihhua58YTIP2QpzxW1NE
         El4BexW8eoBGrkFkf7ZcdSkHfdUHHxqD2uEIJgd4HHefEf5cuDlmGfyP/qdWJMwft3MD
         H/DItoZDnVzUnFj/8Gxhbu1TIJ/li0W0CWSNHXRPVBl7YqtsXlAx1TRAx7R5lrWkutO2
         2LxTCFy43Yngc+P2txEuDifHiME3SSA7tgyITVuipGWFLHr38kBME2NcOmUvhkgJemhM
         yIkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7lGSpdbBtSUGX8TNpVCqyb1N9KeekyFB33Hw0tfwp0Q=;
        b=uyqyCZCCNXFGHqjaiodk5kNDtbsPkPVd0vX9EPDi/jcsc2VAg1BE2AFKUgw7B1OuPq
         w4QOk0kZ3XdGxSZPJWOrN+wtny91Qrqv+IIvc1ffvUqrpAUT4KvdARUmYiSEr3mrsjmo
         2ckzZJJwKZy+FRk9cLOO0Osxq5sKk1zBwd2E4mZvd6LOXnAcF7gXkFZ3q/tcME/i2cvJ
         KbXHvckzAQ4h5VSOdvmEepPUdn/MJ59NKCQH5ak2UWDZWm/wXK3p7aHJ+ZK4Y9TlmBvB
         83HthPqNqcbFCqNWuqs0WXDGJrhuSinMlXz7XEWQTatMNsbXb53muYSj801BAAENARXB
         zppA==
X-Gm-Message-State: AOAM530SqR7mDLgdrB4jtnFeqxsLBqDOmTbXDCk07Gq/2wXWbOu85+IB
        SU6omPK6kP/32IPaixJRI9cFUVL899Q=
X-Google-Smtp-Source: ABdhPJxnQRDGONRk3NqmP47XAMsozQQX7iGhAcfjk61t9xINQJ1Tdldn4MNeuLonI3UDKv/HrIQlFw==
X-Received: by 2002:a63:d04:: with SMTP id c4mr15932769pgl.472.1638813659070;
        Mon, 06 Dec 2021 10:00:59 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u11sm5444070pfg.120.2021.12.06.10.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:00:58 -0800 (PST)
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
Subject: [PATCH v3 5/8] dt-bindings: net: Convert AMAC to YAML
Date:   Mon,  6 Dec 2021 10:00:46 -0800
Message-Id: <20211206180049.2086907-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206180049.2086907-1-f.fainelli@gmail.com>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
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


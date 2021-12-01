Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA7D4645C2
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:13:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346672AbhLAEQZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:16:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346581AbhLAEQJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:16:09 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7BD8C061746;
        Tue, 30 Nov 2021 20:12:45 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id m24so16649749pls.10;
        Tue, 30 Nov 2021 20:12:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CofjtoS3C2UlVTL2mQI4/sEc5MpZ6MET1C9W9dcnuEY=;
        b=WwTtVH8Z3c6zD0ShZISOfu/kGJE/whdMm2FI4F47Th8gAWU7McZsvHpnzd5KfCojor
         qdCHDsk3A6Rpu58X61seBzh+21vOqcySL8ROjHTCNMtfxFLuEL+j0lTjD1bFkZUHnh7O
         /VcySZsgx1zC/9aCSNZjtKazzykacnpeq87/ZmvMDq1ujIjp0SbFz2JxbiE50uihBRGg
         fWf+/5Pt1Fdz8hpprsfZWwhxek3QX/53tKBRnUYWGrjtrPIF3Ki3XCdY5vLnAyBy1xAI
         vOr14unhuU1jTqfAzzaiH53JtVF94/9poTZJ9MufwgzZouFndXrYkFJY8JfhdmroiGsD
         qZgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CofjtoS3C2UlVTL2mQI4/sEc5MpZ6MET1C9W9dcnuEY=;
        b=CTn2WM+C5E52LJF7Vyf+l4fy+hpuCrgkiIMNkaF6YuH3YWl27SqXf1+exnDCvuuqRs
         UvDDW0AZP1S3QSunVH9qh7GqfgOkqRzGGygeV7eQVr5bRqeANUrgIHkWTbQZ66jhmiQw
         IWwfvFLRdk7+zBwUP9pyqVJqnzdtHauGWRFvxZShZ61lGbqfMMdujqdqP6+O/FrP2mUb
         vnxaT9LQnJNb744oYdzfq2SVO+lEaEnc3l8hpmnzH1ba8gRRU+hUMFfJVM62fVBZtL87
         IvNsz5eEQkJ1MjipzEJ/LsQqGGYCaJsA0qIl+g1p9LUo9UTKRxZITzfCxC26YbUBsVrY
         bOoQ==
X-Gm-Message-State: AOAM533p94vgUUhXCPrweeTExerCB4ys3XzLMHO80FeNwoJ4lbtZti+3
        bHUHPtuul471R2KAP5Qsn9MDrM0e2jw=
X-Google-Smtp-Source: ABdhPJxxYt/PiDYZyWCw34TS50zG8FJH0BRNSt/EgH7ruiIrxshWCy+ul8I8ucAmqKJx6Dq1x8ay5Q==
X-Received: by 2002:a17:90b:11c1:: with SMTP id gv1mr4300466pjb.208.1638331964916;
        Tue, 30 Nov 2021 20:12:44 -0800 (PST)
Received: from 7YHHR73.igp.broadcom.net ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id s8sm4296451pfe.196.2021.11.30.20.12.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Nov 2021 20:12:44 -0800 (PST)
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
Subject: [PATCH net-next 7/7] dt-bindings: net: Convert iProc MDIO mux to YAML
Date:   Tue, 30 Nov 2021 20:12:28 -0800
Message-Id: <20211201041228.32444-8-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201041228.32444-1-f.fainelli@gmail.com>
References: <20211201041228.32444-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Conver the Broadcom iProc MDIO mux Device Tree binding to YAML.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../bindings/net/brcm,mdio-mux-iproc.txt      | 62 --------------
 .../bindings/net/brcm,mdio-mux-iproc.yaml     | 80 +++++++++++++++++++
 2 files changed, 80 insertions(+), 62 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
 create mode 100644 Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml

diff --git a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
deleted file mode 100644
index deb9e852ea27..000000000000
--- a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.txt
+++ /dev/null
@@ -1,62 +0,0 @@
-Properties for an MDIO bus multiplexer found in Broadcom iProc based SoCs.
-
-This MDIO bus multiplexer defines buses that could be internal as well as
-external to SoCs and could accept MDIO transaction compatible to C-22 or
-C-45 Clause. When child bus is selected, one needs to select these two
-properties as well to generate desired MDIO transaction on appropriate bus.
-
-Required properties in addition to the generic multiplexer properties:
-
-MDIO multiplexer node:
-- compatible: brcm,mdio-mux-iproc.
-
-Every non-ethernet PHY requires a compatible so that it could be probed based
-on this compatible string.
-
-Optional properties:
-- clocks: phandle of the core clock which drives the mdio block.
-
-Additional information regarding generic multiplexer properties can be found
-at- Documentation/devicetree/bindings/net/mdio-mux.yaml
-
-
-for example:
-		mdio_mux_iproc: mdio-mux@66020000 {
-			compatible = "brcm,mdio-mux-iproc";
-			reg = <0x66020000 0x250>;
-			#address-cells = <1>;
-			#size-cells = <0>;
-
-			mdio@0 {
-				reg = <0x0>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				pci_phy0: pci-phy@0 {
-					compatible = "brcm,ns2-pcie-phy";
-					reg = <0x0>;
-					#phy-cells = <0>;
-				};
-			};
-
-			mdio@7 {
-				reg = <0x7>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				pci_phy1: pci-phy@0 {
-					compatible = "brcm,ns2-pcie-phy";
-					reg = <0x0>;
-					#phy-cells = <0>;
-				};
-			};
-			mdio@10 {
-				reg = <0x10>;
-				#address-cells = <1>;
-				#size-cells = <0>;
-
-				gphy0: eth-phy@10 {
-					reg = <0x10>;
-				};
-			};
-		};
diff --git a/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
new file mode 100644
index 000000000000..a576fb87bfc8
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,mdio-mux-iproc.yaml
@@ -0,0 +1,80 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/brcm,mdio-mux-iproc.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: MDIO bus multiplexer found in Broadcom iProc based SoCs.
+
+maintainers:
+  - Florian Fainelli <f.fainelli@gmail.com>
+
+description:
+  This MDIO bus multiplexer defines buses that could be internal as well as
+  external to SoCs and could accept MDIO transaction compatible to C-22 or
+  C-45 Clause. When child bus is selected, one needs to select these two
+  properties as well to generate desired MDIO transaction on appropriate bus.
+
+allOf:
+  - $ref: /schemas/net/mdio-mux.yaml#
+
+properties:
+  compatible:
+    const: brcm,mdio-mux-iproc
+
+  reg:
+    maxItems: 1
+
+  clocks:
+    maxItems: 1
+    description: core clock driving the MDIO block
+
+
+required:
+  - compatible
+  - reg
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    mdio_mux_iproc: mdio-mux@66020000 {
+        compatible = "brcm,mdio-mux-iproc";
+        reg = <0x66020000 0x250>;
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        mdio@0 {
+           reg = <0x0>;
+           #address-cells = <1>;
+           #size-cells = <0>;
+
+           pci_phy0: pci-phy@0 {
+              compatible = "brcm,ns2-pcie-phy";
+              reg = <0x0>;
+              #phy-cells = <0>;
+           };
+        };
+
+        mdio@7 {
+           reg = <0x7>;
+           #address-cells = <1>;
+           #size-cells = <0>;
+
+           pci_phy1: pci-phy@0 {
+              compatible = "brcm,ns2-pcie-phy";
+              reg = <0x0>;
+              #phy-cells = <0>;
+           };
+        };
+
+        mdio@10 {
+           reg = <0x10>;
+           #address-cells = <1>;
+           #size-cells = <0>;
+
+           gphy0: eth-phy@10 {
+              reg = <0x10>;
+           };
+        };
+    };
-- 
2.25.1


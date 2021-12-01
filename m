Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A494465478
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:58:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352216AbhLASBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352010AbhLASAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:00:45 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC62BC0613E0;
        Wed,  1 Dec 2021 09:57:12 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so332802pjb.5;
        Wed, 01 Dec 2021 09:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CofjtoS3C2UlVTL2mQI4/sEc5MpZ6MET1C9W9dcnuEY=;
        b=ZjxD5mfNKE0pXHW6k9ghM+tWQSVZYKoGXbrLill2uMs7FqfBnfkzmHZ+TbPfExjMWM
         BmlGqmvLnMaldY0AHFiDAdtmGCEtQwNjlZKkOIEvFidzRkIwEh94Rp426QFn5rM4P22y
         rEARxHCbXBsSMjzDC7C8DVUJDp87vkSpln1yMnlNYd6qVTAL07PQIArzI+4Rjc3aJ8g+
         6PlwKlrsbE13BT+6e6MRRNt2Mcq8u4gnnaJTkJtvoei3fPf/OQcGGN9hvz4Hk+LAijG/
         prWc0pdBHX5K38xsob1MvBRrfEA11/kN/T/1EmaBvAI9Nh2Zmrs0QTf3Qla9LFT5Qr1P
         iNfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CofjtoS3C2UlVTL2mQI4/sEc5MpZ6MET1C9W9dcnuEY=;
        b=GSFLTHt1HpiI8BGe7R8EAElFKvbCUVIHkic7epJC9u7ANScXTG7KnsfUsztleddoHV
         lcskkJHyL3TNcFkaaDvAr5yV2JNBtCYUQc0PR8yRIZXte1ycgMBj3V3JriccJQeuRnJV
         UofXTaGUThUVCI0/tdvNHB7VipsaW5WsvZhoj/sCesWGJi2ERF/n2rCB/KqVtLGiCVrY
         qjYBVmCdsiJNnzyJNJdMjF0ZKHw9PLS9eEWJZ+hsfq2WcKXT2MCE8awrcLhrxW/HhUEY
         ZUKFVQaavyH7R9mQPDqxC8bUAb+c/bC3xpDGNVPhCHvPC+5/ub+y9S9O9p5HtsAU1gOC
         gRmg==
X-Gm-Message-State: AOAM533Jvagg9HfS9GTGWPG1ot4rueq7sV45BHmDRchh5+SHwFOcNZ6n
        arpEpM7VuiJpHveZ4K8J9G8I8Em+lco=
X-Google-Smtp-Source: ABdhPJxf0xUb0pM/R2FfaUGrqutQC3ervh7m6lZSWlFbf/8bNQDZfoq9aeCNta6kbyPIKHx/iYK1vQ==
X-Received: by 2002:a17:90b:1e07:: with SMTP id pg7mr9256037pjb.93.1638381431891;
        Wed, 01 Dec 2021 09:57:11 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j13sm471546pfc.151.2021.12.01.09.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:57:11 -0800 (PST)
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
Subject: [PATCH net-next v2 9/9] dt-bindings: net: Convert iProc MDIO mux to YAML
Date:   Wed,  1 Dec 2021 09:56:52 -0800
Message-Id: <20211201175652.4722-10-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201175652.4722-1-f.fainelli@gmail.com>
References: <20211201175652.4722-1-f.fainelli@gmail.com>
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


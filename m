Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A986646A3AC
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346148AbhLFSFB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:05:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346811AbhLFSEk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Dec 2021 13:04:40 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBA1C0698C5;
        Mon,  6 Dec 2021 10:01:02 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id s137so11227982pgs.5;
        Mon, 06 Dec 2021 10:01:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJLAlkJ/cxw+eyGZ9fDi2T+PE+wgI5zX9dIEMcgJMjY=;
        b=Vsbea1qeX+VozmQU+9qsHXe41sBZrrJPx1VjDPnoXmM0p4Ji7o05DdpDm81w20UbIR
         V2IccRSmPAAcWbtnDZhDfBhZk/LmIXgKLWHwIoA4+d5HFaexboja2HLhHzi5q4ceLmTg
         EHSO9Bi6JKYzi8Be1m25k00al8rMKXQ0OlfUIxaPHO0bmZaPE4nTnHi5+n7n3Tdku45x
         FT0+fYe78Vo7OxK6mxTRp6e4QsldZVZ2a37JamIs+dd2WXNK2qUcQn8/9ptji2y8jqhR
         ZHJ2GPC3lvsTy32lFeaiipkM+psg36u/V1kYWMSU0RnN7eA8Z237KzHAGSeUlYA0rqmC
         FLWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJLAlkJ/cxw+eyGZ9fDi2T+PE+wgI5zX9dIEMcgJMjY=;
        b=hTHsbN265IlTLkcVjkzPmVJ5M6NE7CeHzRYqH+KmzyNKjeg+S8ZUPe0+0FuRk3YUaF
         czWYlcTMlc1Poa/SerXTFd1a3GPeVRK6lUvpb+Tzlz344Vy/eb40fqD/dGQhqLYjgsfP
         UOkHv3siBtXlQzU3MCQqxEI9wcmLOK2AugpbcUS47aQXnZQXO7H3SmpG4I0mWxLZ1z3L
         zsLH2uQ1yhShLJuCAO7L9XBWfcLgIy7XT4J4UeyERV7hRgGVllkOdgkgB3KKncyFDRKN
         SJi+RBZdmxY4yV8LxfBkiFihSj7agk+FJ0M1BDutp3u4Dn+LODOlQDUlHgY0S3Hjk0ap
         EUkw==
X-Gm-Message-State: AOAM530VU3isk8+P6+whWOQsWPkt2Vsl+Hd8bMDjwLJeIIt9oKBNOhHF
        h3jfqLl26caSUg/GAKnnIapEnIKs+TI=
X-Google-Smtp-Source: ABdhPJxa7mYehzO8+Juz3E+I0lmJ22iyBMG0h0pCrrhWf2iRDU31MS9gaVjwbeU/kbxUjZdIEfuzQg==
X-Received: by 2002:a63:9144:: with SMTP id l65mr20158872pge.52.1638813661855;
        Mon, 06 Dec 2021 10:01:01 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id u11sm5444070pfg.120.2021.12.06.10.01.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Dec 2021 10:01:01 -0800 (PST)
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
Subject: [PATCH v3 7/8] dt-bindings: phy: Convert Northstar 2 PCIe PHY to YAML
Date:   Mon,  6 Dec 2021 10:00:48 -0800
Message-Id: <20211206180049.2086907-8-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211206180049.2086907-1-f.fainelli@gmail.com>
References: <20211206180049.2086907-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Broadcom Northstar 2 PCIe PHY Device Tree binding to YAML
and rename it accordingly in the process since it had nothing to do with
a MDIO mux on the PCI(e) bus. This is a pre-requisite to updating
another binding file to YAML.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../bindings/phy/brcm,mdio-mux-bus-pci.txt    | 27 ------------
 .../bindings/phy/brcm,ns2-pcie-phy.yaml       | 41 +++++++++++++++++++
 2 files changed, 41 insertions(+), 27 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/phy/brcm,mdio-mux-bus-pci.txt
 create mode 100644 Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml

diff --git a/Documentation/devicetree/bindings/phy/brcm,mdio-mux-bus-pci.txt b/Documentation/devicetree/bindings/phy/brcm,mdio-mux-bus-pci.txt
deleted file mode 100644
index 5b51007c6f24..000000000000
--- a/Documentation/devicetree/bindings/phy/brcm,mdio-mux-bus-pci.txt
+++ /dev/null
@@ -1,27 +0,0 @@
-* Broadcom NS2 PCIe PHY binding document
-
-Required bus properties:
-- reg: MDIO Bus number for the MDIO interface
-- #address-cells: must be 1
-- #size-cells: must be 0
-
-Required PHY properties:
-- compatible: should be "brcm,ns2-pcie-phy"
-- reg: MDIO Phy ID for the MDIO interface
-- #phy-cells: must be 0
-
-This is a child bus node of "brcm,mdio-mux-iproc" node.
-
-Example:
-
-mdio@0 {
-	reg = <0x0>;
-	#address-cells = <1>;
-	#size-cells = <0>;
-
-	pci_phy0: pci-phy@0 {
-		compatible = "brcm,ns2-pcie-phy";
-		reg = <0x0>;
-		#phy-cells = <0>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml
new file mode 100644
index 000000000000..70eb48b391c9
--- /dev/null
+++ b/Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml
@@ -0,0 +1,41 @@
+# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/phy/brcm,ns2-pcie-phy.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Broadcom NS2 PCIe PHY binding document
+
+maintainers:
+  - Ray Jui <ray.jui@broadcom.com>
+  - Scott Branden <scott.branden@broadcom.com>
+
+properties:
+  compatible:
+    const: brcm,ns2-pcie-phy
+
+  reg:
+    maxItems: 1
+
+  "#phy-cells":
+    const: 0
+
+required:
+  - compatible
+  - reg
+  - "#phy-cells"
+
+additionalProperties: false
+
+examples:
+  - |
+    mdio {
+       #address-cells = <1>;
+       #size-cells = <0>;
+
+       pci-phy@0 {
+          compatible = "brcm,ns2-pcie-phy";
+          reg = <0x0>;
+          #phy-cells = <0>;
+       };
+    };
-- 
2.25.1


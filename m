Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA87465481
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243831AbhLASB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 13:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352009AbhLASAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 13:00:45 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B60EC0613D7;
        Wed,  1 Dec 2021 09:57:11 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id n85so25285687pfd.10;
        Wed, 01 Dec 2021 09:57:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bJLAlkJ/cxw+eyGZ9fDi2T+PE+wgI5zX9dIEMcgJMjY=;
        b=Qyo+pzKgsFCVfOlb4dyi73lunH8IE1N29oD+sxOyT4m+d4sd28zxj6gg8+vLA4juRi
         MWfJm962msCTfVYiYWMazlj0+sumH3CTiYjo18k3n2Xa6ScxYqrflfhLyeAdzFWrqe1g
         bnfASC/7k/90Ytjq5sz+V2vq3UoZeH3EwLAMQxrvdWNShPn0ExAVH6d3exdid4h0dxPr
         T8tMQgce8xJZhgn7Qf9j9Vy8Hv0kopRMLDMflmJkiuCrDCjZUenpG6rCFxxT+o5ef1Zo
         uwN1e2PYAspfjuGDheUmO5lAztUbwE46QHIpOZrykROM9/kK1F7PeZ/1Gr9R/h4yqopP
         T8ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bJLAlkJ/cxw+eyGZ9fDi2T+PE+wgI5zX9dIEMcgJMjY=;
        b=gNwJsHmUuJvs18/unykGO3HsJj1zFr+riheA2WsEdtihDaRXpRLQyxoI5cTiwsmx35
         LgkcAaMECD5ALyZDbTOcxJdTEywSiTcyOoS4ehFNYbRYzlxZmU8unfsFna8c+kI9SA60
         HVFn7COOMUdGu25koaEWzTb+Ejz9DRg311ADitco16n7FAQbPhKZFW1HZTriL8JsQOlh
         PfIlmrwsQDteB41Hx1a4A1QAX5l5ZRGvJ+zuJWlzKNWEFvNHrh0+rpb60RLQ9tZ0V3xw
         KLtflz+nmh8nBqBY0JMWNPBYe1fpQZR8bczVccTDCJDTqXRXCf2E1Yj0v7gNkLvo/6Q1
         iFgA==
X-Gm-Message-State: AOAM530DXUqkNrCYxnTYZRnag1/88oz85osIZRZks+anBrlr8SiGm0K+
        f9A858lzhlRZvqDF8X+kadIJV7bbkjM=
X-Google-Smtp-Source: ABdhPJwe3ruUZmU6OnzQoco26j6kjb+HTO53lAZezwc2l9peDxVHgobRFTRy7D35z4uvygUNiHSotA==
X-Received: by 2002:a63:6116:: with SMTP id v22mr5483761pgb.324.1638381430562;
        Wed, 01 Dec 2021 09:57:10 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j13sm471546pfc.151.2021.12.01.09.57.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 09:57:10 -0800 (PST)
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
Subject: [PATCH net-next v2 8/9] dt-bindings: phy: Convert Northstar 2 PCIe PHY to YAML
Date:   Wed,  1 Dec 2021 09:56:51 -0800
Message-Id: <20211201175652.4722-9-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211201175652.4722-1-f.fainelli@gmail.com>
References: <20211201175652.4722-1-f.fainelli@gmail.com>
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


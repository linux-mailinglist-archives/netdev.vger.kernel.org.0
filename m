Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85D546DD12
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 21:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240358AbhLHUbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 15:31:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240340AbhLHUbo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 15:31:44 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E62C061746;
        Wed,  8 Dec 2021 12:28:12 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 71so3054796pgb.4;
        Wed, 08 Dec 2021 12:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZcrOsR/AQ+n4Uph7jneW3qXk8Qg6SVv8+RA/13LAwKg=;
        b=XR9RIssxdowvw1Brc6a2iaFxNo8BlqDdECpczFShju1RkPXqB8qVOZc0+jwTL0lDiO
         3sSkFIIxk7yGIX8rWmA9Dqh7ttmiTGsSatsuQx6xROETW39UW7aH0rThL72bxqdcNleC
         Z2/NmRUuJy3gIGvIroOPF3UAOmeVWlOrQmZ979L664ALfxGiai0fDlP6vnYjpNtO0hpc
         qKsbK7NOUxrN2nTIQN1VvMKIuXSx+7UBwaARxmu8gO0CBWjFN44PD14Hf2D5BTlCDaGU
         HovHCNg/PFJTVhrL3h1EoBlEqmCyHQHyVt5mcCbHM7YAonji+v0hFkwsezXw3lAEJxjt
         EqrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZcrOsR/AQ+n4Uph7jneW3qXk8Qg6SVv8+RA/13LAwKg=;
        b=A/wimQZR9Y+M5G6SEXZeHjqv8sR95Tcnz1Xzv9VvMGqwzutQQ1+KHlllaSiQubzjDP
         CVBZ4eSWtaNs1BeEvxwRaUPUeWtG085Zm3qRcBKAAeGSkop2XSN9O7rnyIHdRatxvwQv
         GmvnJthSCGs3inSMoTi0YJ2w+ZIhg4UbBU8VvocZd81zW0ypaLwt3xj/QcFFK2xmtGdT
         9JpZNNS+/8x0lhjqt9k4LbxmXfZ0aoKJTwojWMYYKdeZBGjyUndzHCZP/ZifmK0a2ErS
         TcKDBnM0kmYtLLAEzE8qWJHOWfovYPsRky4v6WLFNOQSSgQkeF1QaRw38bs0UVvsCwDA
         Z6PA==
X-Gm-Message-State: AOAM532D/b4bld9xKz2Gj7pgOtcvWgLieZeCeWlB6w1VK8zQ0zKpSU63
        Oq4B77r9DgfaiInJGmYFOn4dd8Qyhs8=
X-Google-Smtp-Source: ABdhPJx6YEUJyLQk6gVDNPe8cz+qQRT4nfTKGx8C6oAIc/ISeR0uMN9dl5PyL28q+nQZoCsqeumgKQ==
X-Received: by 2002:a05:6a00:1145:b0:4a2:6a03:c592 with SMTP id b5-20020a056a00114500b004a26a03c592mr7490936pfm.65.1638995291503;
        Wed, 08 Dec 2021 12:28:11 -0800 (PST)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d17sm4592291pfj.124.2021.12.08.12.28.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 12:28:11 -0800 (PST)
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
Subject: [PATCH v4 2/2] dt-bindings: net: Convert SYSTEMPORT to YAML
Date:   Wed,  8 Dec 2021 12:28:01 -0800
Message-Id: <20211208202801.3706929-3-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211208202801.3706929-1-f.fainelli@gmail.com>
References: <20211208202801.3706929-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert the Broadcom SYSTEMPORT Ethernet controller Device Tree binding
to YAML.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 .../bindings/net/brcm,systemport.txt          | 38 --------
 .../bindings/net/brcm,systemport.yaml         | 88 +++++++++++++++++++
 MAINTAINERS                                   |  1 +
 3 files changed, 89 insertions(+), 38 deletions(-)
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
index 000000000000..53ecec8c864e
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/brcm,systemport.yaml
@@ -0,0 +1,88 @@
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
+  systemport,num-tier2-arb:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Number of tier 2 arbiters
+
+  systemport,num-tier1-arb:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    description:
+      Number of tier 2 arbiters
+
+  systemport,num-txq:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    items:
+      - minimum: 1
+      - maximum: 32
+    description:
+      Number of HW transmit queues
+
+  systemport,num-rxq:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    items:
+      - minimum: 1
+      - maximum: 32
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
+unevaluatedProperties: false
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


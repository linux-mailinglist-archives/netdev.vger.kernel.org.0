Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F15DC4EDE84
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 18:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239727AbiCaQQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 12:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238725AbiCaQQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 12:16:56 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D2926A055;
        Thu, 31 Mar 2022 09:15:09 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id i16so298703ejk.12;
        Thu, 31 Mar 2022 09:15:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+u7U4lkAOPwXzqxmTC35x80J2g9XLsoz+L2N9wyTohY=;
        b=PUC6N/Eg9LKVu5tj1jbTOigoGg7wLIGUd1C9HHwSnHBO6nwZT56KCotobFtRMOaeAT
         dIF1XO+SMxvmBabi4Su/N270JhrfT15ajm3aPgwrV0bmjUVr9/d4Q82c05hl8i9cEnqk
         nCD2DP0L7fWkb0RoIER/RgSR94dOClajIFWUyEHUDs0T87fgv0GIhX6DOs0jpvTPKNi/
         LQdNL4aCDLgHO3VhWe3tJgmEB+QqkXLlbiPQT1rfU7c5E0tmvEMayaUiq1s/2UtAGFpu
         JS/Qh6LZLqNWY/hx9RAOwOKvvEaNr7D9mzKHZJ36ffi0crgiOdmhDPXPScd/Ln9iWyOU
         8Krg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+u7U4lkAOPwXzqxmTC35x80J2g9XLsoz+L2N9wyTohY=;
        b=yJh/yO9bdP38Q93xv/5XahaAV4SLF5oNHmIfwT3ojdOaBqZA57Yia9UKkI9aAze0VH
         SA6qdlNVN/wrtnqgegD33/ZmIjCcS2MBjeFM0fTF6SFMk9oGyGHb1FAMZ1XJxymyo54r
         ZLxsV11NuqPIAS53K+k5yscUsRjuf8XQh8OZzC8KbVWqq8CaHjwwfvrI2RQDIy9gyfBQ
         9kqoNZRG8Gf5iT/Dzb/YgJHEDtJwH9McOTd0mgErLedwnGkYKDI1RDS2qY7dR5VxvtF0
         FC84rHn8Uzy/FEYPIq1tzd2c18OQz9VuZ4Nu1T/a7kXepquJcBwobqgBaGnjwp9j+cSb
         /+9w==
X-Gm-Message-State: AOAM532g1raiecNsN/sCax/UkpSpR4CeSP+g5NPRLr9d+/NWiQoKkct2
        7hKEGIifgEyqNdgDaH2qmG8=
X-Google-Smtp-Source: ABdhPJwxKCicJviIPSIyZMU1lu4jDR1x73XK4Lvn/gKq/VKorNpLelOeI1MdCC1fsJrVTXx6dLoLFg==
X-Received: by 2002:a17:906:2bc1:b0:6cf:d009:7f6b with SMTP id n1-20020a1709062bc100b006cfd0097f6bmr5522692ejg.17.1648743307481;
        Thu, 31 Mar 2022 09:15:07 -0700 (PDT)
Received: from debian.home (81-204-249-205.fixed.kpn.net. [81.204.249.205])
        by smtp.gmail.com with ESMTPSA id g4-20020a170906520400b006e0b798a0b8sm7600302ejm.94.2022.03.31.09.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Mar 2022 09:15:06 -0700 (PDT)
From:   Johan Jonker <jbx6244@gmail.com>
To:     heiko@sntech.de
Cc:     robh+dt@kernel.org, krzk+dt@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH v1 1/3] dt-bindings: net: convert emac_rockchip.txt to YAML
Date:   Thu, 31 Mar 2022 18:14:57 +0200
Message-Id: <20220331161459.16499-1-jbx6244@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert emac_rockchip.txt to YAML.

Changes against original bindings:
  Add mdio sub node.

Signed-off-by: Johan Jonker <jbx6244@gmail.com>
---
 .../devicetree/bindings/net/emac_rockchip.txt |  52 --------
 .../bindings/net/emac_rockchip.yaml           | 112 ++++++++++++++++++
 2 files changed, 112 insertions(+), 52 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/emac_rockchip.txt
 create mode 100644 Documentation/devicetree/bindings/net/emac_rockchip.yaml

diff --git a/Documentation/devicetree/bindings/net/emac_rockchip.txt b/Documentation/devicetree/bindings/net/emac_rockchip.txt
deleted file mode 100644
index 05bd7dafc..000000000
--- a/Documentation/devicetree/bindings/net/emac_rockchip.txt
+++ /dev/null
@@ -1,52 +0,0 @@
-* ARC EMAC 10/100 Ethernet platform driver for Rockchip RK3036/RK3066/RK3188 SoCs
-
-Required properties:
-- compatible: should be "rockchip,<name>-emac"
-   "rockchip,rk3036-emac": found on RK3036 SoCs
-   "rockchip,rk3066-emac": found on RK3066 SoCs
-   "rockchip,rk3188-emac": found on RK3188 SoCs
-- reg: Address and length of the register set for the device
-- interrupts: Should contain the EMAC interrupts
-- rockchip,grf: phandle to the syscon grf used to control speed and mode
-  for emac.
-- phy: see ethernet.txt file in the same directory.
-- phy-mode: see ethernet.txt file in the same directory.
-
-Optional properties:
-- phy-supply: phandle to a regulator if the PHY needs one
-
-Clock handling:
-- clocks: Must contain an entry for each entry in clock-names.
-- clock-names: Shall be "hclk" for the host clock needed to calculate and set
-  polling period of EMAC and "macref" for the reference clock needed to transfer
-  data to and from the phy.
-
-Child nodes of the driver are the individual PHY devices connected to the
-MDIO bus. They must have a "reg" property given the PHY address on the MDIO bus.
-
-Examples:
-
-ethernet@10204000 {
-	compatible = "rockchip,rk3188-emac";
-	reg = <0xc0fc2000 0x3c>;
-	interrupts = <6>;
-	mac-address = [ 00 11 22 33 44 55 ];
-
-	clocks = <&cru HCLK_EMAC>, <&cru SCLK_MAC>;
-	clock-names = "hclk", "macref";
-
-	pinctrl-names = "default";
-	pinctrl-0 = <&emac_xfer>, <&emac_mdio>, <&phy_int>;
-
-	rockchip,grf = <&grf>;
-
-	phy = <&phy0>;
-	phy-mode = "rmii";
-	phy-supply = <&vcc_rmii>;
-
-	#address-cells = <1>;
-	#size-cells = <0>;
-	phy0: ethernet-phy@0 {
-	      reg = <1>;
-	};
-};
diff --git a/Documentation/devicetree/bindings/net/emac_rockchip.yaml b/Documentation/devicetree/bindings/net/emac_rockchip.yaml
new file mode 100644
index 000000000..03173fa7b
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/emac_rockchip.yaml
@@ -0,0 +1,112 @@
+# SPDX-License-Identifier: GPL-2.0
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/emac_rockchip.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Rockchip RK3036/RK3066/RK3188 Ethernet Media Access Controller (EMAC)
+
+maintainers:
+  - Heiko Stuebner <heiko@sntech.de>
+
+properties:
+  compatible:
+    enum:
+      - rockchip,rk3036-emac
+      - rockchip,rk3066-emac
+      - rockchip,rk3188-emac
+
+  reg:
+    maxItems: 1
+
+  interrupts:
+    maxItems: 1
+
+  clocks:
+    minItems: 2
+    items:
+      - description: host clock
+      - description: reference clock
+      - description: mac TX/RX clock
+
+  clock-names:
+    minItems: 2
+    items:
+      - const: hclk
+      - const: macref
+      - const: macclk
+
+  rockchip,grf:
+    $ref: /schemas/types.yaml#/definitions/phandle
+    description:
+      Phandle to the syscon GRF used to control speed and mode for the EMAC.
+
+  phy-supply:
+    description:
+      Phandle to a regulator if the PHY needs one.
+
+  mdio:
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - clocks
+  - clock-names
+  - rockchip,grf
+
+allOf:
+  - $ref: "ethernet-controller.yaml#"
+  - if:
+      properties:
+        compatible:
+          contains:
+            const: rockchip,rk3036-emac
+
+    then:
+      properties:
+        clocks:
+          minItems: 3
+
+        clock-names:
+          minItems: 3
+
+    else:
+      properties:
+        clocks:
+          maxItems: 2
+
+        clock-names:
+          maxItems: 2
+
+unevaluatedProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/rk3188-cru-common.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+
+    ethernet@10204000 {
+      compatible = "rockchip,rk3188-emac";
+      reg = <0xc0fc2000 0x3c>;
+      interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+      clocks = <&cru HCLK_EMAC>, <&cru SCLK_MAC>;
+      clock-names = "hclk", "macref";
+      rockchip,grf = <&grf>;
+      pinctrl-0 = <&emac_xfer>, <&emac_mdio>, <&phy_int>;
+      pinctrl-names = "default";
+      phy-handle = <&phy0>;
+      phy-mode = "rmii";
+      phy-supply = <&vcc_rmii>;
+
+      mdio {
+        #address-cells = <1>;
+        #size-cells = <0>;
+
+        phy0: ethernet-phy@0 {
+          reg = <1>;
+        };
+      };
+    };
-- 
2.20.1


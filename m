Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92A06569C15
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbiGGHsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234941AbiGGHsb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:48:31 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDFACB45;
        Thu,  7 Jul 2022 00:48:29 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id a5so10395878wrx.12;
        Thu, 07 Jul 2022 00:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CPihCLn8/rDeZJoQSL1EemIx5OmDQP/lB4w5aYX64BY=;
        b=X0s61VdsrYiS2FHMbVU+aMNvAqAnfHRttgQwkeB0j9jMwWPfgQQIYFGg5w/2dyAade
         fXmZ6MTsCAPWYP9lShHhVAheOTvc60bqpPb6301Aec6R1EMZEFCQ7JwiP7+tV2bDFvyj
         qfDwa2CkEDSA7BsBBbC8jcnUWD9SC6XF29v+XLoYGI/6osvz0KNs9pvPJgH/qUkKGyUz
         1sKtahyTkJBkb8zOwPblW76uoKyx6s2SwPdLpNVaGwyjHWW5Gt+shkfv0WRTQYJMn1rp
         sujlKxL8xLtfdkORoBMcZXJMGg0s7HNoNtb9HObMFNFxxezOM7qxWFj3z+lt8hMVwW8O
         vrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CPihCLn8/rDeZJoQSL1EemIx5OmDQP/lB4w5aYX64BY=;
        b=5n6oss9OKUzmU4tt6f7JPvzcHnTZxi+dyNBJEwuE+hul8DU9Wl80YCUB9bbbxVwpCD
         2qbEDv1+9nDy0YgtXF40kkI15yWyPElWJGpqzHKjXtmTsbYlkHIg6L2X9UDIDsxGQDhu
         KzjsE87CR4RtSCbBsHW6E7chmWQKFp0nLgFb0fqO9hgCuBx6ZokPRMnFKFPlSyljFYcS
         E9hndSeNHhK+Fnr+V8gty7CaGHWbrvxzyYNcHMNX0ARn7MOBok0fu31C6OMx+GdoLQ7/
         KYSUN8Jmy44AazQi+wbCfcogaheyuMB3+yJZ6QdTYO9ASzc2AbEioiwsXXzA5TsqW9kE
         Qd6w==
X-Gm-Message-State: AJIora/7PMYSFKxbaRTGWnGVRNNTn8JI51K7kJ/5McIiWEWFG63oV86m
        3iE5YhXuw+iPpHESY8E9AB1Bm9bhSjw=
X-Google-Smtp-Source: AGRyM1tm8/xRBoGDWDTBaheP5Ue8MeTDAzM1KZtphSY53e0XvFRjEM+1q0mUnIt9/Wd6a4xeSSxwVA==
X-Received: by 2002:a05:6000:1549:b0:21b:c7fb:9dd0 with SMTP id 9-20020a056000154900b0021bc7fb9dd0mr39226823wry.446.1657180108273;
        Thu, 07 Jul 2022 00:48:28 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id i13-20020a0560001acd00b0021d78b570dfsm6266444wry.108.2022.07.07.00.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jul 2022 00:48:27 -0700 (PDT)
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Thierry Reding <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Bhadram Varka <vbhadram@nvidia.com>,
        devicetree@vger.kernel.org, linux-tegra@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 5/9] dt-bindings: net: Add Tegra234 MGBE
Date:   Thu,  7 Jul 2022 09:48:14 +0200
Message-Id: <20220707074818.1481776-6-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220707074818.1481776-1-thierry.reding@gmail.com>
References: <20220707074818.1481776-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bhadram Varka <vbhadram@nvidia.com>

Add device-tree binding documentation for the Multi-Gigabit Ethernet
(MGBE) controller found on NVIDIA Tegra234 SoCs.

Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Bhadram Varka <vbhadram@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
---
Changes in v4:
- uses fixed lists of items for clock-names and reset-names
- add missing maxItems to interrupts property
- drop minItems where it equals maxItems
- drop unnecessary blank lines
- drop redundant comment

Changes in v3:
- add macsec and macsec-ns interrupt names
- improve mdio bus node description
- drop power-domains description
- improve bindings title

Changes in v2:
- add supported PHY modes
- change to dual license

 .../bindings/net/nvidia,tegra234-mgbe.yaml    | 162 ++++++++++++++++++
 1 file changed, 162 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml

diff --git a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
new file mode 100644
index 000000000000..2bd3efff2485
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
@@ -0,0 +1,162 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/net/nvidia,tegra234-mgbe.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Tegra234 MGBE Multi-Gigabit Ethernet Controller
+
+maintainers:
+  - Thierry Reding <treding@nvidia.com>
+  - Jon Hunter <jonathanh@nvidia.com>
+
+properties:
+  compatible:
+    const: nvidia,tegra234-mgbe
+
+  reg:
+    maxItems: 3
+
+  reg-names:
+    items:
+      - const: hypervisor
+      - const: mac
+      - const: xpcs
+
+  interrupts:
+    minItems: 1
+    maxItems: 3
+
+  interrupt-names:
+    minItems: 1
+    items:
+      - const: common
+      - const: macsec-ns
+      - const: macsec
+
+  clocks:
+    maxItems: 12
+
+  clock-names:
+    items:
+      - const: mgbe
+      - const: mac
+      - const: mac-divider
+      - const: ptp-ref
+      - const: rx-input-m
+      - const: rx-input
+      - const: tx
+      - const: eee-pcs
+      - const: rx-pcs-input
+      - const: rx-pcs-m
+      - const: rx-pcs
+      - const: tx-pcs
+
+  resets:
+    maxItems: 2
+
+  reset-names:
+    items:
+      - const: mac
+      - const: pcs
+
+  interconnects:
+    items:
+      - description: memory read client
+      - description: memory write client
+
+  interconnect-names:
+    items:
+      - const: dma-mem
+      - const: write
+
+  iommus:
+    maxItems: 1
+
+  power-domains:
+    maxItems: 1
+
+  phy-handle: true
+
+  phy-mode:
+    contains:
+      enum:
+        - usxgmii
+        - 10gbase-kr
+
+  mdio:
+    $ref: mdio.yaml#
+    unevaluatedProperties: false
+    description:
+      Optional node for embedded MDIO controller.
+
+required:
+  - compatible
+  - reg
+  - interrupts
+  - interrupt-names
+  - clocks
+  - clock-names
+  - resets
+  - reset-names
+  - power-domains
+  - phy-handle
+  - phy-mode
+
+additionalProperties: false
+
+examples:
+  - |
+    #include <dt-bindings/clock/tegra234-clock.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
+    #include <dt-bindings/memory/tegra234-mc.h>
+    #include <dt-bindings/power/tegra234-powergate.h>
+    #include <dt-bindings/reset/tegra234-reset.h>
+
+    ethernet@6800000 {
+        compatible = "nvidia,tegra234-mgbe";
+        reg = <0x06800000 0x10000>,
+              <0x06810000 0x10000>,
+              <0x068a0000 0x10000>;
+        reg-names = "hypervisor", "mac", "xpcs";
+        interrupts = <GIC_SPI 384 IRQ_TYPE_LEVEL_HIGH>;
+        interrupt-names = "common";
+        clocks = <&bpmp TEGRA234_CLK_MGBE0_APP>,
+                 <&bpmp TEGRA234_CLK_MGBE0_MAC>,
+                 <&bpmp TEGRA234_CLK_MGBE0_MAC_DIVIDER>,
+                 <&bpmp TEGRA234_CLK_MGBE0_PTP_REF>,
+                 <&bpmp TEGRA234_CLK_MGBE0_RX_INPUT_M>,
+                 <&bpmp TEGRA234_CLK_MGBE0_RX_INPUT>,
+                 <&bpmp TEGRA234_CLK_MGBE0_TX>,
+                 <&bpmp TEGRA234_CLK_MGBE0_EEE_PCS>,
+                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_INPUT>,
+                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS_M>,
+                 <&bpmp TEGRA234_CLK_MGBE0_RX_PCS>,
+                 <&bpmp TEGRA234_CLK_MGBE0_TX_PCS>;
+        clock-names = "mgbe", "mac", "mac-divider", "ptp-ref", "rx-input-m",
+                      "rx-input", "tx", "eee-pcs", "rx-pcs-input", "rx-pcs-m",
+                      "rx-pcs", "tx-pcs";
+        resets = <&bpmp TEGRA234_RESET_MGBE0_MAC>,
+                 <&bpmp TEGRA234_RESET_MGBE0_PCS>;
+        reset-names = "mac", "pcs";
+        interconnects = <&mc TEGRA234_MEMORY_CLIENT_MGBEARD &emc>,
+                        <&mc TEGRA234_MEMORY_CLIENT_MGBEAWR &emc>;
+        interconnect-names = "dma-mem", "write";
+        iommus = <&smmu_niso0 TEGRA234_SID_MGBE>;
+        power-domains = <&bpmp TEGRA234_POWER_DOMAIN_MGBEA>;
+
+        phy-handle = <&mgbe0_phy>;
+        phy-mode = "usxgmii";
+
+        mdio {
+            #address-cells = <1>;
+            #size-cells = <0>;
+
+            mgbe0_phy: phy@0 {
+                compatible = "ethernet-phy-ieee802.3-c45";
+                reg = <0x0>;
+
+                #phy-cells = <0>;
+            };
+        };
+    };
-- 
2.36.1


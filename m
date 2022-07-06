Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 683BC569474
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234610AbiGFVdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:33:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234240AbiGFVdM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:33:12 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E25E27145;
        Wed,  6 Jul 2022 14:33:10 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id q9so23754028wrd.8;
        Wed, 06 Jul 2022 14:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HVZSEC+VenCeIo/8yTgKOXSfNE5opDjFHGiQ9pUUIZQ=;
        b=I4pmdpKoYpzTo0R0cK3zBQTv7GMk/4JjvJX/Bb7G70Pe55svcXBfQZq0IdjGCiskV+
         P0vZwx5cPexjitW+Q/8VvWOU5bhjJr45veMEq6CKbJEfePqNrDgTV4nArcAwQ/e50HU/
         JkgzzQ3H+DmLFLbxpg3WIP4ZXMkB2YPswlb5tGJAnJHD3C2fKVx8YDR8uvTDy4G8e5lJ
         3Df1EbJ9Luqo4LL/9q+aaHU8SDImw+drJ1Zt+KcZ8czRWWe5KTH+9oqhiMtSSM3J6+CO
         X6jWftEf3Mi2N7ni+hju2Ju1/lJYkSh7xcazJbarF6HP3ZJMzmAEl2Mv8qdqk2z9bBGT
         CjPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HVZSEC+VenCeIo/8yTgKOXSfNE5opDjFHGiQ9pUUIZQ=;
        b=Ytllck8HuLi2kXiHLxuVCwHZdN55jlMXUrc4WFfAHmTUrROZ4la0pw0JhrjSwJDJ86
         CBnpoOMjD98NvgWk4+Cev6Kqy+nE6pVzVeA6dDV+s5dY6wF/KLBoAyVp3Hhbm9LD62VD
         wjg7+gSh7Ruba8JBK1V/Q2PKGQKs35t85RG3CpYzTmdgqqwhh8EH1bQjFEXHghvm7tzD
         TZeVcx/rPr49akFy/8KPXi7trGsDdxOnEVZX1BDEuj4t9QFbHuYTJPTqL27470zN/5BJ
         IWtQBFgl/A7nhynHk4czSSUMfO3hyDxjkrFbb5hyjsQq8qfu4xa9eCke7VEEvjC9gyUK
         Uudg==
X-Gm-Message-State: AJIora/4T5QPksCSLyYUw1WCkRkOosYUeaHKcL+lIlQbJolZD1k9RXRk
        H/iOzMKHxuoY2akYwIvGiuo=
X-Google-Smtp-Source: AGRyM1vubie3i/VEfKiH+iR/HW2Dc7ZjSUlOMm50+gV42c6qtc1hWOltqsrSGwR6eWjVTiJj8LklRQ==
X-Received: by 2002:a05:6000:1152:b0:21d:7646:a976 with SMTP id d18-20020a056000115200b0021d7646a976mr9219831wrx.416.1657143190468;
        Wed, 06 Jul 2022 14:33:10 -0700 (PDT)
Received: from localhost (p200300e41f12c800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f12:c800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id j18-20020a05600c191200b003973ea7e725sm30611255wmq.0.2022.07.06.14.33.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 14:33:09 -0700 (PDT)
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
Subject: [PATCH v3 5/9] dt-bindings: net: Add Tegra234 MGBE
Date:   Wed,  6 Jul 2022 23:32:51 +0200
Message-Id: <20220706213255.1473069-6-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220706213255.1473069-1-thierry.reding@gmail.com>
References: <20220706213255.1473069-1-thierry.reding@gmail.com>
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
Changes in v3:
- add macsec and macsec-ns interrupt names
- improve mdio bus node description
- drop power-domains description
- improve bindings title

Changes in v2:
- add supported PHY modes
- change to dual license

 .../bindings/net/nvidia,tegra234-mgbe.yaml    | 169 ++++++++++++++++++
 1 file changed, 169 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml

diff --git a/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
new file mode 100644
index 000000000000..3d242ef1ca57
--- /dev/null
+++ b/Documentation/devicetree/bindings/net/nvidia,tegra234-mgbe.yaml
@@ -0,0 +1,169 @@
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
+
+  compatible:
+    const: nvidia,tegra234-mgbe
+
+  reg:
+    minItems: 3
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
+
+  interrupt-names:
+    minItems: 1
+    items:
+      - const: common
+      - const: macsec-ns
+      - const: macsec
+
+  clocks:
+    minItems: 12
+    maxItems: 12
+
+  clock-names:
+    minItems: 12
+    maxItems: 12
+    contains:
+      enum:
+        - mgbe
+        - mac
+        - mac-divider
+        - ptp-ref
+        - rx-input-m
+        - rx-input
+        - tx
+        - eee-pcs
+        - rx-pcs-input
+        - rx-pcs-m
+        - rx-pcs
+        - tx-pcs
+
+  resets:
+    minItems: 2
+    maxItems: 2
+
+  reset-names:
+    contains:
+      enum:
+        - mac
+        - pcs
+
+  interconnects:
+    items:
+      - description: memory read client
+      - description: memory write client
+
+  interconnect-names:
+    items:
+      - const: dma-mem # read
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


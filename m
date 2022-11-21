Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E377631FB8
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:09:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230433AbiKULJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:09:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbiKULI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:08:26 -0500
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3163DA417B
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:06:53 -0800 (PST)
Received: by mail-lf1-x130.google.com with SMTP id p8so18248556lfu.11
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 03:06:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g9G5glcqTTNsFXoqERQyI4nK43OsyCP6dvDkzTWOAug=;
        b=OFuE9/4kdVsIn6qlc00yVtvHA0GKVtlaitlxeGN0HFfGJciEczP9AL+wjsWnzfDhqd
         Nz6NBPtQho23iI0ddF/B8CEe/bpBMksdyauDp6PISQB0mpPvGGYywKu+mXKWb6Q/jCRp
         KOF6cdI1l3fbo5NfTALy9tepKPB4+LE4aFPWMRtemgh1ymmv8u5CLtjZEUtEhFWmYgaG
         gAvyDBINsOxx9dUs1qu3ZyyvC2bzxOYou/VTxBGUqHC+2Jacz+73YihChRkwpwobneby
         79R2HW3OyEadYioaN/xwWsapdkTXmo1zeyZL8ljl24lEU6Y4/3pQVPc5/P4IpdRCJys2
         /HjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g9G5glcqTTNsFXoqERQyI4nK43OsyCP6dvDkzTWOAug=;
        b=aTak3zVfbeWehEZCm/iZOFCdge7nupfz1ta8T4W+AG2KsTpx/ip2N73VCCtgyki3Er
         rqFhO4CXVUk4x1Da79gKeipa21wc4FMCZhROFYLVrnnlLiN28mKr91PXK4P44I/Y1w24
         WFD7n/Ndr7DfVtGHp0E/qhYOel9pfu7MHiYKfB3RrUSCKsj+7AFM0W9IhXt2W3R8qKyy
         JXiKtiP9wcp7h35lrZSP+rHcKlNfoL+ANb/ZSxYgmhOU/872LQI+TEKWFkgOeTnDydIA
         ilU5yRgWJs3jSO770Z2BLQdo63P2BEIV8oRuPCM0qruFKZvAsUHVdRzT+kthdRWw5nWh
         NXgA==
X-Gm-Message-State: ANoB5plaiBMO0aZKXXkuikcUs6Rl02A3+u772gne2aAyQeCamm7LsZWp
        ItFtsPAD/LUgDUBiL0iF0s2gyw==
X-Google-Smtp-Source: AA0mqf7/F1ua4aZQ+Td9IIhcrn7EFoeWJkLW7jdqkTK/poRoJKeWOiT10blX4mGbRkDfSyUP83WvhA==
X-Received: by 2002:a05:6512:104b:b0:4b4:cf91:3419 with SMTP id c11-20020a056512104b00b004b4cf913419mr1519807lfb.161.1669028791203;
        Mon, 21 Nov 2022 03:06:31 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id n1-20020a05651203e100b0049313f77755sm1991521lfq.213.2022.11.21.03.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Nov 2022 03:06:30 -0800 (PST)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-clk@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-serial@vger.kernel.org,
        alsa-devel@alsa-project.org, linux-spi@vger.kernel.org,
        linux-usb@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-watchdog@vger.kernel.org, Stephen Boyd <sboyd@kernel.org>,
        Vinod Koul <vkoul@kernel.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH v2 5/9] dt-bindings: drop redundant part of title (end, part two)
Date:   Mon, 21 Nov 2022 12:06:11 +0100
Message-Id: <20221121110615.97962-6-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
References: <20221121110615.97962-1-krzysztof.kozlowski@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The Devicetree bindings document does not have to say in the title that
it is a "binding", but instead just describe the hardware.

Drop trailing "Node|Tree|Generic bindings" in various forms (also with
trailling full stop):

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -not -name 'trivial-devices.yaml' \
    -exec sed -i -e 's/^title: \(.*\) [nN]ode [bB]indings\?\.\?$/title: \1/' {} \;

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -not -name 'trivial-devices.yaml' \
    -exec sed -i -e 's/^title: \(.*\) [tT]ree [bB]indings\?\.\?$/title: \1/' {} \;

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -not -name 'trivial-devices.yaml' \
    -exec sed -i -e 's/^title: \(.*\) [gG]eneric [bB]indings\?\.\?$/title: \1/' {} \;

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -not -name 'trivial-devices.yaml' \
    -exec sed -i -e 's/^title: \(.*\) [bB]indings\? description\.\?$/title: \1/' {} \;

  find Documentation/devicetree/bindings/ -type f -name '*.yaml' \
    -not -name 'trivial-devices.yaml' \
    -exec sed -i -e 's/^title: \(.*\) [bB]indings\? document\.\?$/title: \1/' {} \;

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
---
 Documentation/devicetree/bindings/clock/ti,sci-clk.yaml         | 2 +-
 Documentation/devicetree/bindings/cpu/idle-states.yaml          | 2 +-
 .../devicetree/bindings/net/dsa/microchip,lan937x.yaml          | 2 +-
 .../devicetree/bindings/net/wireless/mediatek,mt76.yaml         | 2 +-
 Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml   | 2 +-
 Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml | 2 +-
 Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml    | 2 +-
 Documentation/devicetree/bindings/phy/qcom,usb-hs-phy.yaml      | 2 +-
 Documentation/devicetree/bindings/phy/ti,phy-gmii-sel.yaml      | 2 +-
 Documentation/devicetree/bindings/power/domain-idle-state.yaml  | 2 +-
 .../devicetree/bindings/reserved-memory/shared-dma-pool.yaml    | 2 +-
 Documentation/devicetree/bindings/reset/ti,sci-reset.yaml       | 2 +-
 Documentation/devicetree/bindings/reset/ti,tps380x-reset.yaml   | 2 +-
 Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml     | 2 +-
 Documentation/devicetree/bindings/sound/audio-graph-port.yaml   | 2 +-
 15 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/ti,sci-clk.yaml b/Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
index 0e370289a053..63d976341696 100644
--- a/Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
+++ b/Documentation/devicetree/bindings/clock/ti,sci-clk.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/clock/ti,sci-clk.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: TI-SCI clock controller node bindings
+title: TI-SCI clock controller
 
 maintainers:
   - Nishanth Menon <nm@ti.com>
diff --git a/Documentation/devicetree/bindings/cpu/idle-states.yaml b/Documentation/devicetree/bindings/cpu/idle-states.yaml
index fa4d4142ac93..b8cc826c9501 100644
--- a/Documentation/devicetree/bindings/cpu/idle-states.yaml
+++ b/Documentation/devicetree/bindings/cpu/idle-states.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/cpu/idle-states.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Idle states binding description
+title: Idle states
 
 maintainers:
   - Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
index 630bf0f8294b..b34de303966b 100644
--- a/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
+++ b/Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/dsa/microchip,lan937x.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: LAN937x Ethernet Switch Series Tree Bindings
+title: LAN937x Ethernet Switch Series
 
 maintainers:
   - UNGLinuxDriver@microchip.com
diff --git a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
index 70e328589cfb..f0c78f994491 100644
--- a/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/mediatek,mt76.yaml
@@ -6,7 +6,7 @@
 $id: http://devicetree.org/schemas/net/wireless/mediatek,mt76.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: MediaTek mt76 wireless devices Generic Binding
+title: MediaTek mt76 wireless devices
 
 maintainers:
   - Felix Fietkau <nbd@nbd.name>
diff --git a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
index 7029cb1f38ff..0e5412cff2bc 100644
--- a/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qca,ath9k.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/net/wireless/qca,ath9k.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Atheros ath9k wireless devices Generic Binding
+title: Qualcomm Atheros ath9k wireless devices
 
 maintainers:
   - Toke Høiland-Jørgensen <toke@toke.dk>
diff --git a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
index f7cf135aa37f..556eb523606a 100644
--- a/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
+++ b/Documentation/devicetree/bindings/net/wireless/qcom,ath11k.yaml
@@ -6,7 +6,7 @@
 $id: http://devicetree.org/schemas/net/wireless/qcom,ath11k.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm Technologies ath11k wireless devices Generic Binding
+title: Qualcomm Technologies ath11k wireless devices
 
 maintainers:
   - Kalle Valo <kvalo@kernel.org>
diff --git a/Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml
index 70eb48b391c9..527010702f5e 100644
--- a/Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/brcm,ns2-pcie-phy.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/phy/brcm,ns2-pcie-phy.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Broadcom NS2 PCIe PHY binding document
+title: Broadcom NS2 PCIe PHY
 
 maintainers:
   - Ray Jui <ray.jui@broadcom.com>
diff --git a/Documentation/devicetree/bindings/phy/qcom,usb-hs-phy.yaml b/Documentation/devicetree/bindings/phy/qcom,usb-hs-phy.yaml
index 0655e485b260..aa97478dd016 100644
--- a/Documentation/devicetree/bindings/phy/qcom,usb-hs-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/qcom,usb-hs-phy.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/phy/qcom,usb-hs-phy.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Qualcomm's USB HS PHY binding description
+title: Qualcomm's USB HS PHY
 
 maintainers:
   - Bjorn Andersson <bjorn.andersson@linaro.org>
diff --git a/Documentation/devicetree/bindings/phy/ti,phy-gmii-sel.yaml b/Documentation/devicetree/bindings/phy/ti,phy-gmii-sel.yaml
index 3a6d686383cf..6d46f57fa1b4 100644
--- a/Documentation/devicetree/bindings/phy/ti,phy-gmii-sel.yaml
+++ b/Documentation/devicetree/bindings/phy/ti,phy-gmii-sel.yaml
@@ -5,7 +5,7 @@
 $id: "http://devicetree.org/schemas/phy/ti,phy-gmii-sel.yaml#"
 $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 
-title: CPSW Port's Interface Mode Selection PHY Tree Bindings
+title: CPSW Port's Interface Mode Selection PHY
 
 maintainers:
   - Kishon Vijay Abraham I <kishon@ti.com>
diff --git a/Documentation/devicetree/bindings/power/domain-idle-state.yaml b/Documentation/devicetree/bindings/power/domain-idle-state.yaml
index 4ee920a1de69..ec1f6f669e50 100644
--- a/Documentation/devicetree/bindings/power/domain-idle-state.yaml
+++ b/Documentation/devicetree/bindings/power/domain-idle-state.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/power/domain-idle-state.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: PM Domain Idle States binding description
+title: PM Domain Idle States
 
 maintainers:
   - Ulf Hansson <ulf.hansson@linaro.org>
diff --git a/Documentation/devicetree/bindings/reserved-memory/shared-dma-pool.yaml b/Documentation/devicetree/bindings/reserved-memory/shared-dma-pool.yaml
index 618105f079be..47696073b665 100644
--- a/Documentation/devicetree/bindings/reserved-memory/shared-dma-pool.yaml
+++ b/Documentation/devicetree/bindings/reserved-memory/shared-dma-pool.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/reserved-memory/shared-dma-pool.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: /reserved-memory DMA pool node bindings
+title: /reserved-memory DMA pool
 
 maintainers:
   - devicetree-spec@vger.kernel.org
diff --git a/Documentation/devicetree/bindings/reset/ti,sci-reset.yaml b/Documentation/devicetree/bindings/reset/ti,sci-reset.yaml
index 4639d2cec557..dcf9206e12be 100644
--- a/Documentation/devicetree/bindings/reset/ti,sci-reset.yaml
+++ b/Documentation/devicetree/bindings/reset/ti,sci-reset.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/reset/ti,sci-reset.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: TI-SCI reset controller node bindings
+title: TI-SCI reset controller
 
 maintainers:
   - Nishanth Menon <nm@ti.com>
diff --git a/Documentation/devicetree/bindings/reset/ti,tps380x-reset.yaml b/Documentation/devicetree/bindings/reset/ti,tps380x-reset.yaml
index afc835eda0ef..f436f2cf1df7 100644
--- a/Documentation/devicetree/bindings/reset/ti,tps380x-reset.yaml
+++ b/Documentation/devicetree/bindings/reset/ti,tps380x-reset.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/reset/ti,tps380x-reset.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: TI TPS380x reset controller node bindings
+title: TI TPS380x reset controller
 
 maintainers:
   - Marco Felsch <kernel@pengutronix.de>
diff --git a/Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml b/Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
index 9e6cb4ee9755..5df7688a1e1c 100644
--- a/Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
+++ b/Documentation/devicetree/bindings/soc/ti/sci-pm-domain.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/soc/ti/sci-pm-domain.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: TI-SCI generic power domain node bindings
+title: TI-SCI generic power domain
 
 maintainers:
   - Nishanth Menon <nm@ti.com>
diff --git a/Documentation/devicetree/bindings/sound/audio-graph-port.yaml b/Documentation/devicetree/bindings/sound/audio-graph-port.yaml
index 64654ceef208..f5b8b6d13077 100644
--- a/Documentation/devicetree/bindings/sound/audio-graph-port.yaml
+++ b/Documentation/devicetree/bindings/sound/audio-graph-port.yaml
@@ -4,7 +4,7 @@
 $id: http://devicetree.org/schemas/sound/audio-graph-port.yaml#
 $schema: http://devicetree.org/meta-schemas/core.yaml#
 
-title: Audio Graph Card 'port' Node Bindings
+title: Audio Graph Card 'port'
 
 maintainers:
   - Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
-- 
2.34.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4AC62DBC9
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240304AbiKQMme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239367AbiKQMk0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:40:26 -0500
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CD6D748F3
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:39:33 -0800 (PST)
Received: by mail-lf1-x12a.google.com with SMTP id c1so2566370lfi.7
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 04:39:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R8CmD7RbkL+ji5H/crPH42LzC8841fyb/TVI9PZsytk=;
        b=akgyKWsBf5JOVzUBq8UvEkZoJ6otNSr7tSbXScAFP37V9N27JC+GbZwfaI/dh+bGkP
         UYZrA3xVSRw7uJu9/IzQBV5XOsW8dDbLI7b6lg3hzHAUeEXnrT3aZoicmVl2T4Qhj51e
         +He82cpuB1NGbY/jsRdou+x44KghVgtmCAIgVtty7Ajdj+YFM2dQwWMB1X2prFuVvTEo
         Jl8JewWYn7GO+7hE8xhUCyXTM3/aUrvskStEZFHy2MUZt5GvVr61ysxm7yP385YLbfJn
         zvYJZufIh8SvuBRZdL3BDpok0859VTkJEuJxrbZY4aZjJTJCfKhSFNMis4139fpVGn7l
         dwSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R8CmD7RbkL+ji5H/crPH42LzC8841fyb/TVI9PZsytk=;
        b=3TxLpKuYJd81Lrss6zJzjKXRv/jt3UkRY1uUPy0z4NBzWwFP0KrvpBhvrbF/4w9q2g
         48HO9jjD760xhaiWSdcmOdOwxuslYCc2QF+sjaOaHz3ezxBXcr/jPaiAyaRvpF6+iOiz
         A1A9FFG+9WpnrPPgKnjwS+AmzSkEMyrdUBOR4dvk9oK01bnXbR79eX44snLcmad5JhIe
         LNy7Q9fvabscKy0GYt6OgfuyzxmcWRGlveaIowB/dmY7Dlpfo7DoliAAKm1KnGo5nSnO
         BMah++Gnr8TINPE0LZXKAfkc9pTrrqpWeDVrAKOSRCyH+7naBFYSfpgNcqmYQtBfTJcs
         h0yg==
X-Gm-Message-State: ANoB5pk9CefJurJvlkdlLbv2lkv71wFijusRPJH4xML+TaBrpPP9B6g/
        SkoM6Ezxta3QOh7fjfahnL8MNg==
X-Google-Smtp-Source: AA0mqf7y30IKvOOOde4f7vZWAb3iI/B/VqdojVIdarj+ydxO/NQfC24JkDmXGQARlyE0k2gXx1/exg==
X-Received: by 2002:a05:6512:340b:b0:4a2:5897:2b44 with SMTP id i11-20020a056512340b00b004a258972b44mr913826lfr.431.1668688754007;
        Thu, 17 Nov 2022 04:39:14 -0800 (PST)
Received: from krzk-bin.NAT.warszawa.vectranet.pl (088156142067.dynamic-2-waw-k-3-2-0.vectranet.pl. [88.156.142.67])
        by smtp.gmail.com with ESMTPSA id u28-20020ac24c3c000000b004972b0bb426sm127855lfq.257.2022.11.17.04.39.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 04:39:13 -0800 (PST)
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
        linux-watchdog@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [RFC PATCH 5/9] dt-bindings: drop redundant part of title (end, part two)
Date:   Thu, 17 Nov 2022 13:38:46 +0100
Message-Id: <20221117123850.368213-6-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221117123850.368213-1-krzysztof.kozlowski@linaro.org>
References: <20221117123850.368213-1-krzysztof.kozlowski@linaro.org>
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


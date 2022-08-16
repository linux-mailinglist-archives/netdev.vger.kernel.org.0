Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344D85958A5
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 12:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234874AbiHPKkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 06:40:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234868AbiHPKjZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 06:39:25 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE196E990E
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:56:34 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id h1so4977758wmd.3
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 02:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=c7OVXjrnshlQAhDd3JMeAgzq9zhrvCnPPY2leZaul9E=;
        b=sQDLODAmIgNV8pShx+tXdvf6RRWQjFZtQplGo1EB3m8ZZ0K2K8GslOR4Ck52XJEef9
         aro4ek/xESOdqrrSHqJGcqVV+bDHg3g5/0mRqNy/XVBgz23D8FAobaVkVQDhHZMHELGb
         sNbtHvwLE3l7v7NkGETw3YuLCC/ZEaXx8IOQz2T86y5mmS2ObNd1rn+GnBuZ9ufQEyQy
         7CQsi6V4RIq5IhqBMMSur/bVYToGTccKaWZcCYmABQ+i5bo2bqSqmzWHOMu44KUjvCrv
         w3SWhLb1H8CpX00CpQqbQRe/UM4eQGpH1R2cvPHpR9Ofpa04GX/DOdrxO3ViU0wGJG46
         9PoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=c7OVXjrnshlQAhDd3JMeAgzq9zhrvCnPPY2leZaul9E=;
        b=szz2acVRV36UAsyDwl95KxR/ExWrEReRPxNuld24qCLsfJNuTvS+HPOVR9p/iCjw4L
         E2biQtznYsFwFTOHINU/24mJAa7q/jO9LjCNlcuG++ZSDjWT2X7tjCNak4YeMOahQJMt
         iYchnsOufKO8psHXMqWCqBmcL3fLl4t6El8OiRkqcX7Bs6GQi2Jm3GLMLr2Im3K3CfGZ
         d/0gYdJ5A9PawdgsBogakUGmyQVdft2hpXIEfyN9wjY5ieNWpu6DNP3WxeulnEfn7OAD
         vrEgO83Hq6AtJCAEfb9+V0VSbkpIfvrurlIMngJ57D24LYgzZ6VPAHdVzP/THJqCen37
         yejw==
X-Gm-Message-State: ACgBeo0a5P/64dVMozsAdSzDuWBPjKgnlRaS99P69hVsZXJdULGHg7QN
        9lSqe7MtG6v6GMrlOYH/ZEkPGQ==
X-Google-Smtp-Source: AA6agR5ObiKbUJrgfx3vVrmLVjAXOeoqvGv/WDJV0Y54gZafu1cjk8NPJY8M0EJk9zHIyLQUADbwUg==
X-Received: by 2002:a05:600c:3c90:b0:3a3:8606:2df3 with SMTP id bg16-20020a05600c3c9000b003a386062df3mr18914335wmb.132.1660643792447;
        Tue, 16 Aug 2022 02:56:32 -0700 (PDT)
Received: from localhost.localdomain ([2a01:e0a:982:cbb0:ef0b:d58b:b15c:96e6])
        by smtp.gmail.com with ESMTPSA id p14-20020a5d4e0e000000b0020fff0ea0a3sm9630907wrt.116.2022.08.16.02.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Aug 2022 02:56:31 -0700 (PDT)
From:   Neil Armstrong <narmstrong@baylibre.com>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-i2c@vger.kernel.org, linux-media@vger.kernel.org,
        netdev@vger.kernel.org, linux-phy@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-spi@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Cc:     Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH] MAINTAINERS: Update email of Neil Armstrong
Date:   Tue, 16 Aug 2022 11:56:17 +0200
Message-Id: <20220816095617.948678-1-narmstrong@baylibre.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=21959; i=narmstrong@baylibre.com;
 h=from:subject; bh=+W0noluQF8xU8yPAYe4ORzlUL4SYSseTznxGoxJg6fo=;
 b=owEBbQKS/ZANAwAKAXfc29rIyEnRAcsmYgBi+2ln22eMpGar5uXv5y91Wcrj0KsgszzZS/dV7q+T
 wvMUFzKJAjMEAAEKAB0WIQQ9U8YmyFYF/h30LIt33NvayMhJ0QUCYvtpZwAKCRB33NvayMhJ0Q2RD/
 9or+KgrKSQArJboSeq8/2+3LOyY+dSZ4GtKWzh0FQPFgPBKCVZ5iYfleaxqYsrBeSr03jzNscy+2Ly
 8sQfktJVfLB6NUlAXgqyO9laLuPgAhuvLKbMajQBx0LpYyuGlZtSCxm/zDYrGgQ9AsxvChg11Z0r7x
 KeR1dN58U5D7bx4jCEcxeeDlhvgX4b9NpnT8YEc8MojWUjJ6vEmoCpPgg3MPLBePcV76jKlavoyrQb
 aXBmn+FdTYIDVKlvSWjAcbMnOH7Gh7JttiqPPTivuXXssGCEI5/RHUW+XqCMEbwzUT9ImcVQbV9W2u
 SFi30yk+getZvdAeRyZVfDFr7vVHT+r897ghB69guYt9Ljgs0KX1Gzyl6H3L4szHIA31opcQu/zwri
 aF5X9EbjihX3Nh3MoNhE0HyP7aNGF+igrW/N4x68/w7RvXg7fBHiCuOWHb4ea9YTWktxdrTosBOVv0
 xVXmT9Z+yjJVqJXFHo47UVYTf7FrHiKlTajfmhOJTO+CZQlfV89sh9Te2SkZcNUHDQACY46IpywddF
 DV6mZTYget/AR/E5eiRxe7HlWH2nZUGWXR45z0f8qZvz+GvdDVY356BWqXxAw0LGBC66LErBgWDs16
 RYtGFpeCaTZ2MffxA+jOfS3eUwlljFOTcLXKargSACQ27UfEbxgHGDZeN4kA==
X-Developer-Key: i=narmstrong@baylibre.com; a=openpgp; fpr=89EC3D058446217450F22848169AB7B1A4CFF8AE
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Armstrong <neil.armstrong@linaro.org>

My professional e-mail will change and the BayLibre one will
bounce after mid-september of 2022.

This updates the MAINTAINERS file, the YAML bindings and adds an
entry in the .mailmap file.

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
---
 .mailmap                                      |  1 +
 .../amlogic/amlogic,meson-gx-ao-secure.yaml   |  2 +-
 .../display/amlogic,meson-dw-hdmi.yaml        |  2 +-
 .../bindings/display/amlogic,meson-vpu.yaml   |  2 +-
 .../display/bridge/analogix,anx7814.yaml      |  2 +-
 .../bindings/display/bridge/ite,it66121.yaml  |  2 +-
 .../display/panel/sgd,gktw70sdae4se.yaml      |  2 +-
 .../bindings/i2c/amlogic,meson6-i2c.yaml      |  2 +-
 .../mailbox/amlogic,meson-gxbb-mhu.yaml       |  2 +-
 .../bindings/media/amlogic,axg-ge2d.yaml      |  2 +-
 .../bindings/media/amlogic,gx-vdec.yaml       |  2 +-
 .../media/amlogic,meson-gx-ao-cec.yaml        |  2 +-
 .../devicetree/bindings/mfd/khadas,mcu.yaml   |  2 +-
 .../bindings/net/amlogic,meson-dwmac.yaml     |  2 +-
 .../bindings/phy/amlogic,axg-mipi-dphy.yaml   |  2 +-
 .../phy/amlogic,meson-g12a-usb2-phy.yaml      |  2 +-
 .../phy/amlogic,meson-g12a-usb3-pcie-phy.yaml |  2 +-
 .../bindings/power/amlogic,meson-ee-pwrc.yaml |  2 +-
 .../bindings/reset/amlogic,meson-reset.yaml   |  2 +-
 .../bindings/rng/amlogic,meson-rng.yaml       |  2 +-
 .../bindings/serial/amlogic,meson-uart.yaml   |  2 +-
 .../bindings/soc/amlogic/amlogic,canvas.yaml  |  2 +-
 .../bindings/spi/amlogic,meson-gx-spicc.yaml  |  2 +-
 .../bindings/spi/amlogic,meson6-spifc.yaml    |  2 +-
 .../usb/amlogic,meson-g12a-usb-ctrl.yaml      |  2 +-
 .../watchdog/amlogic,meson-gxbb-wdt.yaml      |  2 +-
 MAINTAINERS                                   | 20 +++++++++----------
 27 files changed, 36 insertions(+), 35 deletions(-)

diff --git a/.mailmap b/.mailmap
index 2ed1cf869175..04fb67be9b0b 100644
--- a/.mailmap
+++ b/.mailmap
@@ -303,6 +303,7 @@ Morten Welinder <welinder@troll.com>
 Mythri P K <mythripk@ti.com>
 Nadia Yvette Chambers <nyc@holomorphy.com> William Lee Irwin III <wli@holomorphy.com>
 Nathan Chancellor <nathan@kernel.org> <natechancellor@gmail.com>
+Neil Armstrong <neil.armstrong@linaro.org> <narmstrong@baylibre.com>
 Nguyen Anh Quynh <aquynh@gmail.com>
 Nicholas Piggin <npiggin@gmail.com> <npiggen@suse.de>
 Nicholas Piggin <npiggin@gmail.com> <npiggin@kernel.dk>
diff --git a/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml b/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml
index 6cc74523ebfd..1748f1605cc7 100644
--- a/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml
+++ b/Documentation/devicetree/bindings/arm/amlogic/amlogic,meson-gx-ao-secure.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson Firmware registers Interface
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 description: |
   The Meson SoCs have a register bank with status and data shared with the
diff --git a/Documentation/devicetree/bindings/display/amlogic,meson-dw-hdmi.yaml b/Documentation/devicetree/bindings/display/amlogic,meson-dw-hdmi.yaml
index 2e208d2fc98f..7cdffdb131ac 100644
--- a/Documentation/devicetree/bindings/display/amlogic,meson-dw-hdmi.yaml
+++ b/Documentation/devicetree/bindings/display/amlogic,meson-dw-hdmi.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic specific extensions to the Synopsys Designware HDMI Controller
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 allOf:
   - $ref: /schemas/sound/name-prefix.yaml#
diff --git a/Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml b/Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml
index 047fd69e0377..6655a93b1874 100644
--- a/Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml
+++ b/Documentation/devicetree/bindings/display/amlogic,meson-vpu.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson Display Controller
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 description: |
   The Amlogic Meson Display controller is composed of several components
diff --git a/Documentation/devicetree/bindings/display/bridge/analogix,anx7814.yaml b/Documentation/devicetree/bindings/display/bridge/analogix,anx7814.yaml
index bce96b5b0db0..4a5e5d9d6f90 100644
--- a/Documentation/devicetree/bindings/display/bridge/analogix,anx7814.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/analogix,anx7814.yaml
@@ -8,7 +8,7 @@ title: Analogix ANX7814 SlimPort (Full-HD Transmitter)
 
 maintainers:
   - Andrzej Hajda <andrzej.hajda@intel.com>
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
   - Robert Foss <robert.foss@linaro.org>
 
 properties:
diff --git a/Documentation/devicetree/bindings/display/bridge/ite,it66121.yaml b/Documentation/devicetree/bindings/display/bridge/ite,it66121.yaml
index c6e81f532215..1b2185be92cd 100644
--- a/Documentation/devicetree/bindings/display/bridge/ite,it66121.yaml
+++ b/Documentation/devicetree/bindings/display/bridge/ite,it66121.yaml
@@ -8,7 +8,7 @@ title: ITE it66121 HDMI bridge Device Tree Bindings
 
 maintainers:
   - Phong LE <ple@baylibre.com>
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 description: |
   The IT66121 is a high-performance and low-power single channel HDMI
diff --git a/Documentation/devicetree/bindings/display/panel/sgd,gktw70sdae4se.yaml b/Documentation/devicetree/bindings/display/panel/sgd,gktw70sdae4se.yaml
index 44e02decdf3a..2e75e3738ff0 100644
--- a/Documentation/devicetree/bindings/display/panel/sgd,gktw70sdae4se.yaml
+++ b/Documentation/devicetree/bindings/display/panel/sgd,gktw70sdae4se.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Solomon Goldentek Display GKTW70SDAE4SE 7" WVGA LVDS Display Panel
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
   - Thierry Reding <thierry.reding@gmail.com>
 
 allOf:
diff --git a/Documentation/devicetree/bindings/i2c/amlogic,meson6-i2c.yaml b/Documentation/devicetree/bindings/i2c/amlogic,meson6-i2c.yaml
index 6ecb0270d88d..199a354ccb97 100644
--- a/Documentation/devicetree/bindings/i2c/amlogic,meson6-i2c.yaml
+++ b/Documentation/devicetree/bindings/i2c/amlogic,meson6-i2c.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson I2C Controller
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
   - Beniamino Galvani <b.galvani@gmail.com>
 
 allOf:
diff --git a/Documentation/devicetree/bindings/mailbox/amlogic,meson-gxbb-mhu.yaml b/Documentation/devicetree/bindings/mailbox/amlogic,meson-gxbb-mhu.yaml
index ea06976fbbc7..dfd26b998189 100644
--- a/Documentation/devicetree/bindings/mailbox/amlogic,meson-gxbb-mhu.yaml
+++ b/Documentation/devicetree/bindings/mailbox/amlogic,meson-gxbb-mhu.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson Message-Handling-Unit Controller
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 description: |
   The Amlogic's Meson SoCs Message-Handling-Unit (MHU) is a mailbox controller
diff --git a/Documentation/devicetree/bindings/media/amlogic,axg-ge2d.yaml b/Documentation/devicetree/bindings/media/amlogic,axg-ge2d.yaml
index bee93bd84771..e551be5e680e 100644
--- a/Documentation/devicetree/bindings/media/amlogic,axg-ge2d.yaml
+++ b/Documentation/devicetree/bindings/media/amlogic,axg-ge2d.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic GE2D Acceleration Unit
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml b/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
index 5044c4bb94e0..b827edabcafa 100644
--- a/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
+++ b/Documentation/devicetree/bindings/media/amlogic,gx-vdec.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Video Decoder
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
   - Maxime Jourdan <mjourdan@baylibre.com>
 
 description: |
diff --git a/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml b/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml
index d93aea6a0258..8d844f4312d1 100644
--- a/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml
+++ b/Documentation/devicetree/bindings/media/amlogic,meson-gx-ao-cec.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson AO-CEC Controller
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 description: |
   The Amlogic Meson AO-CEC module is present is Amlogic SoCs and its purpose is
diff --git a/Documentation/devicetree/bindings/mfd/khadas,mcu.yaml b/Documentation/devicetree/bindings/mfd/khadas,mcu.yaml
index a3b976f101e8..5750cc06e923 100644
--- a/Documentation/devicetree/bindings/mfd/khadas,mcu.yaml
+++ b/Documentation/devicetree/bindings/mfd/khadas,mcu.yaml
@@ -7,7 +7,7 @@ $schema: http://devicetree.org/meta-schemas/core.yaml#
 title: Khadas on-board Microcontroller Device Tree Bindings
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 description: |
   Khadas embeds a microcontroller on their VIM and Edge boards adding some
diff --git a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
index 608e1d62bed5..ddd5a073c3a8 100644
--- a/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
+++ b/Documentation/devicetree/bindings/net/amlogic,meson-dwmac.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson DWMAC Ethernet controller
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
   - Martin Blumenstingl <martin.blumenstingl@googlemail.com>
 
 # We need a select here so we don't match all nodes with 'snps,dwmac'
diff --git a/Documentation/devicetree/bindings/phy/amlogic,axg-mipi-dphy.yaml b/Documentation/devicetree/bindings/phy/amlogic,axg-mipi-dphy.yaml
index be485f500887..5eddaed3d853 100644
--- a/Documentation/devicetree/bindings/phy/amlogic,axg-mipi-dphy.yaml
+++ b/Documentation/devicetree/bindings/phy/amlogic,axg-mipi-dphy.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic AXG MIPI D-PHY
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
index 399ebde45409..f3a5fbabbbb5 100644
--- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb2-phy.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic G12A USB2 PHY
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml
index 453c083cf44c..868b4e6fde71 100644
--- a/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml
+++ b/Documentation/devicetree/bindings/phy/amlogic,meson-g12a-usb3-pcie-phy.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic G12A USB3 + PCIE Combo PHY
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml b/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
index f005abac7079..683c191c4921 100644
--- a/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
+++ b/Documentation/devicetree/bindings/power/amlogic,meson-ee-pwrc.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson Everything-Else Power Domains
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 description: |+
   The Everything-Else Power Domains node should be the child of a syscon
diff --git a/Documentation/devicetree/bindings/reset/amlogic,meson-reset.yaml b/Documentation/devicetree/bindings/reset/amlogic,meson-reset.yaml
index 494a454928ce..98db2aa74dc8 100644
--- a/Documentation/devicetree/bindings/reset/amlogic,meson-reset.yaml
+++ b/Documentation/devicetree/bindings/reset/amlogic,meson-reset.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson SoC Reset Controller
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml
index 444be32a8a29..09c6c906b1f9 100644
--- a/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml
+++ b/Documentation/devicetree/bindings/rng/amlogic,meson-rng.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson Random number generator
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 properties:
   compatible:
diff --git a/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml b/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml
index 72e8868db3e0..7822705ad16c 100644
--- a/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/amlogic,meson-uart.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson SoC UART Serial Interface
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 description: |
   The Amlogic Meson SoC UART Serial Interface is present on a large range
diff --git a/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml b/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml
index 17db87cb9dab..c3c599096353 100644
--- a/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml
+++ b/Documentation/devicetree/bindings/soc/amlogic/amlogic,canvas.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Canvas Video Lookup Table
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
   - Maxime Jourdan <mjourdan@baylibre.com>
 
 description: |
diff --git a/Documentation/devicetree/bindings/spi/amlogic,meson-gx-spicc.yaml b/Documentation/devicetree/bindings/spi/amlogic,meson-gx-spicc.yaml
index 50de0da42c13..0c10f7678178 100644
--- a/Documentation/devicetree/bindings/spi/amlogic,meson-gx-spicc.yaml
+++ b/Documentation/devicetree/bindings/spi/amlogic,meson-gx-spicc.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson SPI Communication Controller
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 allOf:
   - $ref: "spi-controller.yaml#"
diff --git a/Documentation/devicetree/bindings/spi/amlogic,meson6-spifc.yaml b/Documentation/devicetree/bindings/spi/amlogic,meson6-spifc.yaml
index 8a9d526d06eb..ac3b2ec300ac 100644
--- a/Documentation/devicetree/bindings/spi/amlogic,meson6-spifc.yaml
+++ b/Documentation/devicetree/bindings/spi/amlogic,meson6-spifc.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson SPI Flash Controller
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 allOf:
   - $ref: "spi-controller.yaml#"
diff --git a/Documentation/devicetree/bindings/usb/amlogic,meson-g12a-usb-ctrl.yaml b/Documentation/devicetree/bindings/usb/amlogic,meson-g12a-usb-ctrl.yaml
index e349fa5de606..daf2a859418d 100644
--- a/Documentation/devicetree/bindings/usb/amlogic,meson-g12a-usb-ctrl.yaml
+++ b/Documentation/devicetree/bindings/usb/amlogic,meson-g12a-usb-ctrl.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Amlogic Meson G12A DWC3 USB SoC Controller Glue
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 description: |
   The Amlogic G12A embeds a DWC3 USB IP Core configured for USB2 and USB3
diff --git a/Documentation/devicetree/bindings/watchdog/amlogic,meson-gxbb-wdt.yaml b/Documentation/devicetree/bindings/watchdog/amlogic,meson-gxbb-wdt.yaml
index c7459cf70e30..497d60408ea0 100644
--- a/Documentation/devicetree/bindings/watchdog/amlogic,meson-gxbb-wdt.yaml
+++ b/Documentation/devicetree/bindings/watchdog/amlogic,meson-gxbb-wdt.yaml
@@ -8,7 +8,7 @@ $schema: "http://devicetree.org/meta-schemas/core.yaml#"
 title: Meson GXBB SoCs Watchdog timer
 
 maintainers:
-  - Neil Armstrong <narmstrong@baylibre.com>
+  - Neil Armstrong <neil.armstrong@linaro.org>
 
 allOf:
   - $ref: watchdog.yaml#
diff --git a/MAINTAINERS b/MAINTAINERS
index 66bffb24a348..dd319665232f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1769,7 +1769,7 @@ N:	sun[x456789]i
 N:	sun50i
 
 ARM/Amlogic Meson SoC CLOCK FRAMEWORK
-M:	Neil Armstrong <narmstrong@baylibre.com>
+M:	Neil Armstrong <neil.armstrong@linaro.org>
 M:	Jerome Brunet <jbrunet@baylibre.com>
 L:	linux-amlogic@lists.infradead.org
 S:	Maintained
@@ -1794,7 +1794,7 @@ F:	Documentation/devicetree/bindings/sound/amlogic*
 F:	sound/soc/meson/
 
 ARM/Amlogic Meson SoC support
-M:	Neil Armstrong <narmstrong@baylibre.com>
+M:	Neil Armstrong <neil.armstrong@linaro.org>
 M:	Kevin Hilman <khilman@baylibre.com>
 R:	Jerome Brunet <jbrunet@baylibre.com>
 R:	Martin Blumenstingl <martin.blumenstingl@googlemail.com>
@@ -2489,7 +2489,7 @@ W:	http://www.digriz.org.uk/ts78xx/kernel
 F:	arch/arm/mach-orion5x/ts78xx-*
 
 ARM/OXNAS platform support
-M:	Neil Armstrong <narmstrong@baylibre.com>
+M:	Neil Armstrong <neil.armstrong@linaro.org>
 L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
 L:	linux-oxnas@groups.io (moderated for non-subscribers)
 S:	Maintained
@@ -6618,7 +6618,7 @@ F:	Documentation/devicetree/bindings/display/allwinner*
 F:	drivers/gpu/drm/sun4i/
 
 DRM DRIVERS FOR AMLOGIC SOCS
-M:	Neil Armstrong <narmstrong@baylibre.com>
+M:	Neil Armstrong <neil.armstrong@linaro.org>
 L:	dri-devel@lists.freedesktop.org
 L:	linux-amlogic@lists.infradead.org
 S:	Supported
@@ -6640,7 +6640,7 @@ F:	drivers/gpu/drm/atmel-hlcdc/
 
 DRM DRIVERS FOR BRIDGE CHIPS
 M:	Andrzej Hajda <andrzej.hajda@intel.com>
-M:	Neil Armstrong <narmstrong@baylibre.com>
+M:	Neil Armstrong <neil.armstrong@linaro.org>
 M:	Robert Foss <robert.foss@linaro.org>
 R:	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
 R:	Jonas Karlman <jonas@kwiboo.se>
@@ -10575,7 +10575,7 @@ F:	drivers/media/tuners/it913x*
 
 ITE IT66121 HDMI BRIDGE DRIVER
 M:	Phong LE <ple@baylibre.com>
-M:	Neil Armstrong <narmstrong@baylibre.com>
+M:	Neil Armstrong <neil.armstrong@linaro.org>
 S:	Maintained
 T:	git git://anongit.freedesktop.org/drm/drm-misc
 F:	Documentation/devicetree/bindings/display/bridge/ite,it66121.yaml
@@ -11081,7 +11081,7 @@ F:	kernel/debug/
 F:	kernel/module/kdb.c
 
 KHADAS MCU MFD DRIVER
-M:	Neil Armstrong <narmstrong@baylibre.com>
+M:	Neil Armstrong <neil.armstrong@linaro.org>
 L:	linux-amlogic@lists.infradead.org
 S:	Maintained
 F:	Documentation/devicetree/bindings/mfd/khadas,mcu.yaml
@@ -12951,7 +12951,7 @@ S:	Maintained
 F:	drivers/watchdog/menz69_wdt.c
 
 MESON AO CEC DRIVER FOR AMLOGIC SOCS
-M:	Neil Armstrong <narmstrong@baylibre.com>
+M:	Neil Armstrong <neil.armstrong@linaro.org>
 L:	linux-media@vger.kernel.org
 L:	linux-amlogic@lists.infradead.org
 S:	Supported
@@ -12962,7 +12962,7 @@ F:	drivers/media/cec/platform/meson/ao-cec-g12a.c
 F:	drivers/media/cec/platform/meson/ao-cec.c
 
 MESON GE2D DRIVER FOR AMLOGIC SOCS
-M:	Neil Armstrong <narmstrong@baylibre.com>
+M:	Neil Armstrong <neil.armstrong@linaro.org>
 L:	linux-media@vger.kernel.org
 L:	linux-amlogic@lists.infradead.org
 S:	Supported
@@ -12978,7 +12978,7 @@ F:	Documentation/devicetree/bindings/mtd/amlogic,meson-nand.txt
 F:	drivers/mtd/nand/raw/meson_*
 
 MESON VIDEO DECODER DRIVER FOR AMLOGIC SOCS
-M:	Neil Armstrong <narmstrong@baylibre.com>
+M:	Neil Armstrong <neil.armstrong@linaro.org>
 L:	linux-media@vger.kernel.org
 L:	linux-amlogic@lists.infradead.org
 S:	Supported
-- 
2.25.1


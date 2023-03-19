Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77BE26C0408
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 20:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbjCSTSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 15:18:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjCSTSi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 15:18:38 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591C013D53;
        Sun, 19 Mar 2023 12:18:36 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id m35so6196288wms.4;
        Sun, 19 Mar 2023 12:18:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679253515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=QVdWN7twwB5DLTJPLjg32SbMimhB6/vPXTAGXKUqWc0=;
        b=BJBa951crD93wsPpe+HSl88Zhjp6WeGer8DeI4I5sRK0IDB/wsQFB63KO2Ykl/4j+B
         4wnZewuKz5CTeJicY8FtJu4amq4XeJn6hFixwJyeEANydeHt4Gh9RVDvtGOF6HYKM1Kz
         Wc8BiHNOMHMYzbDlKA8+ahPgkcwVZ7mTdX4Eka5iu8eiQJRqu9lpFGxO0lhmlnI1XgOg
         E9XnvNeNcZlL8oC9VgHJGs1I7wAY5Jtm6EM/rR3+8CUDki1qV8vf1E4bScqVrXs2QPQi
         pa2vF4IumAHn2MNfWNfhupMttJv9o/823AbnBvZzu1JRy6rFyOMt0UbinG5667Te/Mp2
         lVnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679253515;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QVdWN7twwB5DLTJPLjg32SbMimhB6/vPXTAGXKUqWc0=;
        b=QXvBRaYMrfX75kQ7jBEI5PxPoQ+dek1E57e6Z0Tgn1DQYZ+dOh57iYh43axZgs5UFQ
         VdS/yzGB7uEVXiLHh0Q4rGQKNAS6A1m1GO+/S0+fbbf638LCcJtvLLJc25x8air/bzyH
         mOyMY/HRuRP+5/w4rxIYVR7K8Ok16cAKtYZfUr1Gg3o2Q3z3LvlJxCfkvS2Gg8imQQv4
         mrtUsWmuJwpE+CvoHrMmGeIx8ZuJuwMw+RIS7/yVpi0dyMzm/kpxzLXPVgNzpmg+DL5r
         3idbitYTCLaA+S9E2f6tdhjUnxfRfAxLlmJ6rtvmZP/iV1BrhJ02nFTERQN75oiY4PyY
         2jMQ==
X-Gm-Message-State: AO0yUKXXtb2KsM2XN3LoDE+mFzAWhDwAR8jorxHG5wOPTCPsXWNQH5BT
        +0OZgTYwopKePX2enIN23rw=
X-Google-Smtp-Source: AK7set+/SktzZDuS8tAI4fvQmhNRG9ul3HwWq3ZfIOOCLsWPDFLFmxED7Bed2+1p+2kYD8M4oe3T7w==
X-Received: by 2002:a7b:cb5a:0:b0:3ed:8d2e:59a0 with SMTP id v26-20020a7bcb5a000000b003ed8d2e59a0mr7086027wmj.10.1679253514479;
        Sun, 19 Mar 2023 12:18:34 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id b7-20020a5d4b87000000b002cfe0ab1246sm7165167wrt.20.2023.03.19.12.18.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Mar 2023 12:18:34 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v5 00/15] net: Add basic LED support for switch/phy
Date:   Sun, 19 Mar 2023 20:17:59 +0100
Message-Id: <20230319191814.22067-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a continue of [1]. It was decided to take a more gradual
approach to implement LEDs support for switch and phy starting with
basic support and then implementing the hw control part when we have all
the prereq done.

This series implements only the brightness_set() and blink_set() ops.
An example of switch implementation is done with qca8k.

For PHY a more generic approach is used with implementing the LED
support in PHY core and with the user (in this case marvell) adding all
the required functions.

Currently we set the default-state as "keep" to not change the default
configuration of the declared LEDs since almost every switch have a
default configuration.

[1] https://lore.kernel.org/lkml/20230216013230.22978-1-ansuelsmth@gmail.com/

Changes in new series v5:
- Rebase everything on top of net-next/main
- Add more info on LED probe fail for qca8k
- Drop some additional raw number and move to define in qca8k header
- Add additional info on LED mapping on qca8k regs
- Checks port number in qca8k switch port parse
- Changes in Andrew patch:
  - Add additional patch for stubs when CLASS_LED disabled
  - Drop CLASS_LED dependency for PHYLIB (to fix kbot errors reported)
Changes in new series v4:
- Changes in Andrew patch:
  - net: phy: Add a binding for PHY LEDs:
    - Rename phy_led: led_list to list
    - Rename phy_device: led_list to leds
    - Remove phy_leds_remove() since devm_ should do what is needed
    - Fixup documentation for struct phy_led
    - Fail probe on LED errors
  - net: phy: phy_device: Call into the PHY driver to set LED brightness
    - Moved phy_led::phydev from previous patch to here since it is first
      used here.
  - net: phy: marvell: Implement led_blink_set() 
    - Use int instead of unsigned
  - net: phy: marvell: Add software control of the LEDs
    - Use int instead of unsigned
- Add depends on LED_CLASS for qca8k Kconfig
- Fix Makefile for qca8k as suggested
- Move qca8k_setup_led_ctrl to separate header
- Move Documentation from dsa-port to ethernet-controller
- Drop trailing . from Andrew patch fro consistency
Changes in new series v3:
- Move QCA8K_LEDS Kconfig option from tristate to bool
- Use new helper led_init_default_state_get for default-state in qca8k
- Drop cled_qca8k_brightness_get() as there isn't a good way to describe
  the mode the led is currently in
- Rework qca8k_led_brightness_get() to return true only when LED is set
  to always ON
Changes in new series v2:
- Add LEDs node for rb3011
- Fix rb3011 switch node unevaluated properties while running 
  make dtbs_check
- Fix a copypaste error in qca8k-leds.c for port 4 required shift
- Drop phy-handle usage for qca8k and use qca8k_port_to_phy()
- Add review tag from Andrew
- Add Christian Marangi SOB in each Andrew patch
- Add extra description for dsa-port stressing that PHY have no access
  and LED are controlled by the related MAC
- Add missing additionalProperties for dsa-port.yaml and ethernet-phy.yaml

Changes from the old v8 series:
- Drop linux,default-trigger set to netdev.
- Dropped every hw control related patch and implement only
  blink_set and brightness_set
- Add default-state to "keep" for each LED node example

Andrew Lunn (7):
  leds: Provide stubs for when CLASS_LED is disabled
  net: phy: Add a binding for PHY LEDs
  net: phy: phy_device: Call into the PHY driver to set LED brightness
  net: phy: marvell: Add software control of the LEDs
  net: phy: phy_device: Call into the PHY driver to set LED blinking
  net: phy: marvell: Implement led_blink_set()
  arm: mvebu: dt: Add PHY LED support for 370-rd WAN port

Christian Marangi (8):
  net: dsa: qca8k: move qca8k_port_to_phy() to header
  net: dsa: qca8k: add LEDs basic support
  net: dsa: qca8k: add LEDs blink_set() support
  dt-bindings: net: ethernet-controller: Document support for LEDs node
  dt-bindings: net: dsa: qca8k: add LEDs definition example
  arm: qcom: dt: Drop unevaluated properties in switch nodes for rb3011
  arm: qcom: dt: Add Switch LED for each port for rb3011
  dt-bindings: net: phy: Document support for LEDs node

 .../devicetree/bindings/net/dsa/qca8k.yaml    |  24 ++
 .../bindings/net/ethernet-controller.yaml     |  21 ++
 .../devicetree/bindings/net/ethernet-phy.yaml |  31 ++
 arch/arm/boot/dts/armada-370-rd.dts           |  14 +
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts     | 124 +++++++-
 drivers/net/dsa/qca/Kconfig                   |   8 +
 drivers/net/dsa/qca/Makefile                  |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c              |  20 +-
 drivers/net/dsa/qca/qca8k-leds.c              | 270 ++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  74 +++++
 drivers/net/dsa/qca/qca8k_leds.h              |  16 ++
 drivers/net/phy/marvell.c                     |  81 +++++-
 drivers/net/phy/phy_device.c                  | 102 +++++++
 include/linux/leds.h                          |  18 ++
 include/linux/phy.h                           |  35 +++
 15 files changed, 817 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c
 create mode 100644 drivers/net/dsa/qca/qca8k_leds.h

-- 
2.39.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E94C56CA6DB
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 16:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232422AbjC0OLC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 10:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbjC0OLB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 10:11:01 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0144D3;
        Mon, 27 Mar 2023 07:10:59 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id l27so8958723wrb.2;
        Mon, 27 Mar 2023 07:10:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679926258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=vVVDHCbPWiNbeNPI9GbbrmHitQGGMZRXNj0Gu3LBxEs=;
        b=VAQwMYQG7JriewMHhoEGDwj30G074ZJbCRTkufhyLgqoENQD5b9kwF4fx659WpP/wi
         cJmfyNpn9Ja9WpyvzUdQ0t/R69NTx8HGjbJOGrDDL+0qya3XicFckzwzBHHwmNxagHdS
         Uej8QP0tdLtYuwcWG4FMp1VnVOQK9of081SZ+BvF1tep/NOr8ea8m90NpjgZMuqE/LaK
         NXtAs5tdHT7otSLs3nfuOXt1xEl4U88Pq0k0QeEDf1wkRfcl1skxY0o7oRioTVDag6u2
         i1/SS2pB0Fmcy+T222LuKwswIlJeXBNr41qEOvRjF8AXA4K6aidwG2zUI88106vYtH/a
         nCCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679926258;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vVVDHCbPWiNbeNPI9GbbrmHitQGGMZRXNj0Gu3LBxEs=;
        b=8HEO4uJMITkWJ6gtEFAqZHOTb2/c4Wm7/O3wU6DCSuzN4jpNKNU2a681WqDvmzT6vH
         pjbeHe910lqnXm32hKnbHwcHPw+QEE+tyzEu1TiIFnLb9EN6h/W+yg6w1E5O1IA59Dn4
         4xM5A7gp0yjFC7Dlk4XfXcUDPxYSU7lMeawgc3Q5BrP6MBDCS9wW8arH3MZ1ZxF2dGDG
         aYuBn80YD8TxVORXwP6Vg+nwqg3K5InHxK8LNYU9E+hAiqt99crHkRfYq12bF7dZ0v5e
         1fHGORmovNpsTLuL7V1u8BEB8tXrPndBzzESS2BMyxCIMiMYbGTLsLHYrWHHen2V/5gn
         gWzw==
X-Gm-Message-State: AAQBX9fnbtkl0Q0WFqFbeOTinlCcjdMdtXE+qpbJ6We01esvUX7+o72b
        H80FqV+pj3pzB9QJBjhZmmnrAQ0eoI4=
X-Google-Smtp-Source: AKy350Yu6KrXMJjrDYh215V99pF5TO7nOj6BfJpxQiDQsk1w1/HiNk4YymstByENESbRLsREvT+6ig==
X-Received: by 2002:a5d:554f:0:b0:2d7:3d7c:19cb with SMTP id g15-20020a5d554f000000b002d73d7c19cbmr9147426wrw.4.1679926257950;
        Mon, 27 Mar 2023 07:10:57 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id p17-20020adfcc91000000b002c71dd1109fsm25307591wrj.47.2023.03.27.07.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Mar 2023 07:10:57 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: [net-next PATCH v6 00/16] net: Add basic LED support for switch/phy
Date:   Mon, 27 Mar 2023 16:10:15 +0200
Message-Id: <20230327141031.11904-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
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

Changes in new series v6:
- Add leds-ethernet.yaml to document reg in led node
- Update ethernet-controller and ethernet-phy to follow new leds-ethernet schema
- Fix comments in qca8k-leds.c (at least -> at most)
  (wrong GENMASK for led phy 0 and 4)
- Add review and ack tag from Pavel Machek
- Changes in Andrew patch:
  - leds: Provide stubs for when CLASS_LED & NEW_LEDS are disabled
    - Change LED_CLASS to NEW_LEDS for led_init_default_state_get()
  - net: phy: Add a binding for PHY LEDs
    - Add dependency on LED_CLASS
    - Drop review tag from Michal Kubiak (patch modified)
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
  leds: Provide stubs for when CLASS_LED & NEW_LEDS are disabled
  net: phy: Add a binding for PHY LEDs
  net: phy: phy_device: Call into the PHY driver to set LED brightness
  net: phy: marvell: Add software control of the LEDs
  net: phy: phy_device: Call into the PHY driver to set LED blinking
  net: phy: marvell: Implement led_blink_set()
  arm: mvebu: dt: Add PHY LED support for 370-rd WAN port

Christian Marangi (9):
  net: dsa: qca8k: move qca8k_port_to_phy() to header
  net: dsa: qca8k: add LEDs basic support
  net: dsa: qca8k: add LEDs blink_set() support
  dt-bindings: leds: Document support for generic ethernet LEDs
  dt-bindings: net: ethernet-controller: Document support for LEDs node
  dt-bindings: net: dsa: qca8k: add LEDs definition example
  ARM: dts: qcom: ipq8064-rb3011: Drop unevaluated properties in switch
    nodes
  ARM: dts: qcom: ipq8064-rb3011: Add Switch LED for each port
  dt-bindings: net: phy: Document support for LEDs node

 .../bindings/leds/leds-ethernet.yaml          |  76 +++++
 .../devicetree/bindings/net/dsa/qca8k.yaml    |  24 ++
 .../bindings/net/ethernet-controller.yaml     |  10 +
 .../devicetree/bindings/net/ethernet-phy.yaml |  19 ++
 arch/arm/boot/dts/armada-370-rd.dts           |  14 +
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts     | 124 +++++++-
 drivers/net/dsa/qca/Kconfig                   |   8 +
 drivers/net/dsa/qca/Makefile                  |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c              |  20 +-
 drivers/net/dsa/qca/qca8k-leds.c              | 270 ++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  74 +++++
 drivers/net/dsa/qca/qca8k_leds.h              |  16 ++
 drivers/net/phy/Kconfig                       |   1 +
 drivers/net/phy/marvell.c                     |  81 +++++-
 drivers/net/phy/phy_device.c                  | 102 +++++++
 include/linux/leds.h                          |  18 ++
 include/linux/phy.h                           |  35 +++
 17 files changed, 871 insertions(+), 24 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/leds/leds-ethernet.yaml
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c
 create mode 100644 drivers/net/dsa/qca/qca8k_leds.h

-- 
2.39.2


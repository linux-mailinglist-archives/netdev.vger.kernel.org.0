Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF6706BDEA3
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 03:33:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCQCd0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 22:33:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQCdY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 22:33:24 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12EEA2E82F;
        Thu, 16 Mar 2023 19:33:22 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id r18so3199700wrx.1;
        Thu, 16 Mar 2023 19:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679020400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=SBufsd7TJN3UMnpjEy1Egh/dFft22er/s7/ID3KVYPo=;
        b=byEmfTSENjKFFC9uwnfGZlTY9UFaKr3FJKtC5xKcc5WTV1N+/bVfSR13w5C7JxsUDW
         EHbHd0lpuBuQwl6w9eepnG1RJVIoTqM6jJqjX/TMKYvdITSh9aagGX1pAc0QdCosSwpD
         Cr4FtyjPSKgnjSZVAIznm8DAehWqDUaRlVBTAY3BoPbKrTxVNs1rYFVBPXHEkbX7H/a1
         mP9kSAJ+GYk5UbBTDP2AMe5/8fTvmyaYQnYEqLm4ocUK7GNpYVZzk2dv4mf6ToRNpmey
         witomqFivJFN2wmfc8j8PCq5PAKFZaSW2R51gcWVoBz9UCsa6FtcQLH9oUUA8B5t8O5k
         sOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020400;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SBufsd7TJN3UMnpjEy1Egh/dFft22er/s7/ID3KVYPo=;
        b=yCHdGvJSxZJnzlWe7NOsq533VbHClHIUw4gGT3Chsxp2QZfIVpv63w7H0EHLvq/uui
         mSkfZyhFFRIsoiOWRb3F3azgsVzGHUkIKYIxlRU7dJYUxFb7xAN/BTboxf3GQR5Zy38N
         ZMdpwbpWL5htMAxZyuE3ZM/C6QFUq8X/DPJn4XnMhZyPlNqrqXAvHcf+0qbgb9M0tL1l
         igmcKQ0lTOhRDc3bRM0KWaRNdqGS7uiQPCVPxFYuin3cQm23Toy9crwHaXNTdBs6P9XS
         6yoFIO1PkqVMqqZwVcroVM/6v0Id1j5j3/TWRM20By0c7GCZeGEmJgBlpKz/cmNoFKT8
         ThsQ==
X-Gm-Message-State: AO0yUKXzsY3PpGqTTH+/9wqZ35DWm8j5hG1YhEVuD75Pk9qaPVMKg/By
        ZQyKbKhzLuS2iqNYy+Mmw7ePD3HmSf8=
X-Google-Smtp-Source: AK7set81mRaNdHd1iJzkewnqPyIV7y8Tk9nfpEIfIQFfGbqJ1l6OMKIsl55+jYbv3tdZS4Sz3a4Bwg==
X-Received: by 2002:adf:f0d0:0:b0:2cf:ea5d:f60a with SMTP id x16-20020adff0d0000000b002cfea5df60amr6634361wro.3.1679020399948;
        Thu, 16 Mar 2023 19:33:19 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id z15-20020a5d44cf000000b002ce9f0e4a8fsm782313wrr.84.2023.03.16.19.33.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Mar 2023 19:33:19 -0700 (PDT)
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
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH v4 00/14] net: Add basic LED support for switch/phy
Date:   Fri, 17 Mar 2023 03:31:11 +0100
Message-Id: <20230317023125.486-1-ansuelsmth@gmail.com>
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

Andrew Lunn (6):
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
 .../devicetree/bindings/net/ethernet-phy.yaml |  31 +++
 arch/arm/boot/dts/armada-370-rd.dts           |  14 ++
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts     | 124 +++++++++-
 drivers/net/dsa/qca/Kconfig                   |   8 +
 drivers/net/dsa/qca/Makefile                  |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c              |  20 +-
 drivers/net/dsa/qca/qca8k-leds.c              | 230 ++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  73 ++++++
 drivers/net/dsa/qca/qca8k_leds.h              |  16 ++
 drivers/net/phy/Kconfig                       |   1 +
 drivers/net/phy/marvell.c                     |  81 +++++-
 drivers/net/phy/phy_device.c                  | 102 ++++++++
 include/linux/phy.h                           |  35 +++
 15 files changed, 759 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c
 create mode 100644 drivers/net/dsa/qca/qca8k_leds.h

-- 
2.39.2


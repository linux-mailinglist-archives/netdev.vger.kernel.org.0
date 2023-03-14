Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A078E6B9AEB
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 17:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbjCNQRn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 12:17:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230461AbjCNQRg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 12:17:36 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA790B4817;
        Tue, 14 Mar 2023 09:17:22 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id p4so8688045wre.11;
        Tue, 14 Mar 2023 09:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678810641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=X7vTG+HM9wJv+2SsPq5Z6CfXlOJH/VnK+j1wp3/YuB0=;
        b=Fpzi+wzS1P1O8VnVg03SXwJEshPGh5Zws72EDrJO0L/xMVj+Fxd02Zu28TR/mZrPx3
         6mo03B9+EJve+qCX2jjp3HeBqa3Ewd4mJN7OwHCpzeSH5fsOEWqk9+R7uikwMhQuQyAN
         yFiZfzTq1XIpL+TL3v/swxavpL1fnFx9N0o1r4R92KcvBAQvgQYGl2+PcZ4lNKZAU65v
         2BOuzq6BpBxAfJ4kO+lKPM2Y4aiIckZB18Lvu/MpikuL3xdhNUpL8ewGUJhft5vUYRXC
         VdyRcnNH6wXZK33Xjc5Kb+3dj0VZRYcu1SG94H5RAV5Y1B+27YCzzx0B9Vc6gjoeR7lB
         BQCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678810641;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X7vTG+HM9wJv+2SsPq5Z6CfXlOJH/VnK+j1wp3/YuB0=;
        b=66haYn31UczgBJP1kemYg79zqEB6TBVNYbDO/thOTbGW6qMnHb5OHO1gRPkMWQAcw5
         4Ac8Kl8UZBc5zybcJbByIJ901XFdw8iX9b0hqyMP5BCZJvSBrCz5pFjfWMzgyl7ABAUB
         frkEHYKpPxAQPnzGAIwd0WchxVpLp9txroDzRF2ecCOMgrbNi+l7lZ6jR2LOSSI8vPl5
         d6sD0P0Xrz/HiLJcEygQaF40PdmuTokeAhUDTTwB95G/t8TwGgkqwauXmrMSIKYlpL0J
         aCzrTsQVkYip2NrGvuaqeTHUyI8VCZdWK9f2U+P+9pqZpfsPHYwwuucKKMNTzVrEJV6u
         /Vwg==
X-Gm-Message-State: AO0yUKUqzg1kBzg++UQZvLmZJ6RPfO/JEfRKrvCXhC+bytMG8Eqj4jn1
        49xTvoBjILOKXDWVW7H3XJg=
X-Google-Smtp-Source: AK7set+42EfdKL2fbiWypbrek1/lbnXDNrSKamn0m6MK6EhwrJ9cUjCNn6ivQtBty4le29YstiY1Tw==
X-Received: by 2002:a5d:58ce:0:b0:2ce:9819:1c1e with SMTP id o14-20020a5d58ce000000b002ce98191c1emr8160361wrf.30.1678810640781;
        Tue, 14 Mar 2023 09:17:20 -0700 (PDT)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id a16-20020a5d4570000000b002c5539171d1sm2426821wrc.41.2023.03.14.09.17.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 09:17:20 -0700 (PDT)
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
Subject: [net-next PATCH v3 00/14] net: Add basic LED support for switch/phy
Date:   Tue, 14 Mar 2023 11:15:02 +0100
Message-Id: <20230314101516.20427-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
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
  net: phy: phy_device: Call into the PHY driver to set LED brightness.
  net: phy: marvell: Add software control of the LEDs
  net: phy: phy_device: Call into the PHY driver to set LED blinking.
  net: phy: marvell: Implement led_blink_set()
  arm: mvebu: dt: Add PHY LED support for 370-rd WAN port

Christian Marangi (8):
  net: dsa: qca8k: move qca8k_port_to_phy() to header
  net: dsa: qca8k: add LEDs basic support
  net: dsa: qca8k: add LEDs blink_set() support
  dt-bindings: net: dsa: dsa-port: Document support for LEDs node
  dt-bindings: net: dsa: qca8k: add LEDs definition example
  arm: qcom: dt: Drop unevaluated properties in switch nodes for rb3011
  arm: qcom: dt: Add Switch LED for each port for rb3011
  dt-bindings: net: phy: Document support for LEDs node

 .../devicetree/bindings/net/dsa/dsa-port.yaml |  21 ++
 .../devicetree/bindings/net/dsa/qca8k.yaml    |  24 ++
 .../devicetree/bindings/net/ethernet-phy.yaml |  31 +++
 arch/arm/boot/dts/armada-370-rd.dts           |  14 ++
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts     | 124 +++++++++-
 drivers/net/dsa/qca/Kconfig                   |   7 +
 drivers/net/dsa/qca/Makefile                  |   1 +
 drivers/net/dsa/qca/qca8k-8xxx.c              |  19 +-
 drivers/net/dsa/qca/qca8k-leds.c              | 229 ++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  83 +++++++
 drivers/net/phy/marvell.c                     |  81 ++++++-
 drivers/net/phy/phy_device.c                  | 115 +++++++++
 include/linux/phy.h                           |  33 +++
 13 files changed, 758 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c

-- 
2.39.2


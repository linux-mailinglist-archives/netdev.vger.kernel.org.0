Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2756E4C9C
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 17:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230283AbjDQPST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 11:18:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjDQPSR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 11:18:17 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C3E19B;
        Mon, 17 Apr 2023 08:18:16 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id v3so955326wml.0;
        Mon, 17 Apr 2023 08:18:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681744694; x=1684336694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qYoLkAi32c0QgUmNBUHQGkHOtl/1ZnVGsu8NcSiTDC0=;
        b=KU3nXxB49MYxz6NPA6RChKt0/r7MfQr+owE3HJ2HUDtudOazz5mWdTxNU3VIul2sIP
         s30hOgiERyHsqmHenUT/fxUP8dYfpEZvcdPlV/odSBlpTHssPDnVOYFXy/0Zse2ieg/l
         hzyfMhRHI0mRdKpZj9r59lkjatKQQS06Xlt0PT8AX/P+CGVlIj6Vzl9Zu4/0/gTA1wpH
         iknFFf4MZ9QFXyQU/gcomdFNBW3nrv+ljpV2r0UOovcbBjASKvLeCMb6Kko7DkV1lvz4
         mQSWj25BBl1T0WUuDj/v+fk3bKq73KqM45gOhCqpTLABAyimBUJVwXh8uuYWoOwLuUBu
         Y3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681744694; x=1684336694;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qYoLkAi32c0QgUmNBUHQGkHOtl/1ZnVGsu8NcSiTDC0=;
        b=HY2VnAVjwSckVrgArVgGZ2a5YgB7uLKKZH+7AN7kPgP53LO3D5CSJ/56z32ssusAcw
         okahe3MtyZ6Jm2OOOwtO8XxkKcN8AiDZlI8ll7G7tOS9yHmuQlU0Pbr8tAyqdqKwTftQ
         q4jsDng2H7Xibid8E36mJXGXh5K1GVaLKYptWbxBZ/LiBRsNB7yi3rxBDMB0GwO/ZObp
         lXMzQNlcxMD7jI4tw0rbbepq15Rupxr07cnVpD9zfDEKIzoKORhQA6rWREPPGkQ0JAzG
         +9CcSbQH1c6giKBFKFAuPwGAvjNBrjVVnS/zHZWXvhDC/yupVDjMQ00Yu8zMPvAub1GO
         /vHA==
X-Gm-Message-State: AAQBX9dqaCn9/FLI2hNyWZBBVekgY2pZpMvpde96m6jxuiEY0+4OKZMn
        gBwUtetD3a+7jprEh7oLCvs=
X-Google-Smtp-Source: AKy350bqfgW5MuYrODX3oNWNi2JBQz51Xhd0/GLp2GsfxPJsPGIm0F2KWnJCW5PfzVaClkDWDx64uA==
X-Received: by 2002:a05:600c:2105:b0:3f1:7581:bba3 with SMTP id u5-20020a05600c210500b003f17581bba3mr1699114wml.10.1681744694207;
        Mon, 17 Apr 2023 08:18:14 -0700 (PDT)
Received: from localhost.localdomain (host-87-7-13-196.retail.telecomitalia.it. [87.7.13.196])
        by smtp.googlemail.com with ESMTPSA id j15-20020a05600c1c0f00b003f173be2ccfsm3501354wms.2.2023.04.17.08.17.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 08:17:52 -0700 (PDT)
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
        Jonathan Corbet <corbet@lwn.net>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [net-next PATCH v7 00/16] net: Add basic LED support for switch/phy
Date:   Mon, 17 Apr 2023 17:17:22 +0200
Message-Id: <20230417151738.19426-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
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

Changes in new series v7:
- Drop ethernet-leds schema and add unevaluatedProperties to
  ethernet-controller and ethernet-phy schema
- Drop function-enumerator binding from schema example and DT
- Set devname_mandatory for qca8k leds and assign better name to LEDs
  using the format {slave_mii_bus id}:0{port number}:{color}:{function}
- Add Documentation patch for Correct LEDs naming from Andrew
- Changes in Andrew patch:
  - net: phy: Add a binding for PHY LEDs
    - Convert index from u32 to u8
  - net: phy: phy_device: Call into the PHY driver to set LED brightness
    - Fixup kernel doc
    - Convert index from u32 to u8
  - net: phy: marvell: Add software control of the LEDs
    - Convert index from u32 to u8
  - net: phy: phy_device: Call into the PHY driver to set LED blinking
    - Kernel doc fix
    - Convert index from u32 to u8
  - net: phy: marvell: Implement led_blink_set()
    - Convert index from u32 to u8
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

Andrew Lunn (8):
  leds: Provide stubs for when CLASS_LED & NEW_LEDS are disabled
  net: phy: Add a binding for PHY LEDs
  net: phy: phy_device: Call into the PHY driver to set LED brightness
  net: phy: marvell: Add software control of the LEDs
  net: phy: phy_device: Call into the PHY driver to set LED blinking
  net: phy: marvell: Implement led_blink_set()
  arm: mvebu: dt: Add PHY LED support for 370-rd WAN port
  Documentation: LEDs: Describe good names for network LEDs

Christian Marangi (8):
  net: dsa: qca8k: move qca8k_port_to_phy() to header
  net: dsa: qca8k: add LEDs basic support
  net: dsa: qca8k: add LEDs blink_set() support
  dt-bindings: net: ethernet-controller: Document support for LEDs node
  dt-bindings: net: dsa: qca8k: add LEDs definition example
  ARM: dts: qcom: ipq8064-rb3011: Drop unevaluated properties in switch
    nodes
  ARM: dts: qcom: ipq8064-rb3011: Add Switch LED for each port
  dt-bindings: net: phy: Document support for LEDs node

 .../devicetree/bindings/net/dsa/qca8k.yaml    |  22 ++
 .../bindings/net/ethernet-controller.yaml     |  35 +++
 .../devicetree/bindings/net/ethernet-phy.yaml |  43 +++
 Documentation/leds/well-known-leds.txt        |  30 ++
 arch/arm/boot/dts/armada-370-rd.dts           |  12 +
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts     | 124 +++++++-
 drivers/net/dsa/qca/Kconfig                   |   8 +
 drivers/net/dsa/qca/Makefile                  |   3 +
 drivers/net/dsa/qca/qca8k-8xxx.c              |  20 +-
 drivers/net/dsa/qca/qca8k-leds.c              | 277 ++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  74 +++++
 drivers/net/dsa/qca/qca8k_leds.h              |  16 +
 drivers/net/phy/Kconfig                       |   1 +
 drivers/net/phy/marvell.c                     |  81 ++++-
 drivers/net/phy/phy_device.c                  | 103 +++++++
 include/linux/leds.h                          |  18 ++
 include/linux/phy.h                           |  41 +++
 17 files changed, 884 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c
 create mode 100644 drivers/net/dsa/qca/qca8k_leds.h

-- 
2.39.2


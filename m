Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F9D46B30DD
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 23:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231183AbjCIWiC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 17:38:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCIWiA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 17:38:00 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F49CEFA5;
        Thu,  9 Mar 2023 14:37:58 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id r19-20020a05600c459300b003eb3e2a5e7bso2295603wmo.0;
        Thu, 09 Mar 2023 14:37:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678401477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+YkCkrjJHa9Smmj/wJYS+f+10gt8i1v3+K2/QxqxGnI=;
        b=eJfOsBUED3fscQrc9JaP5TBDOF3Y46ECD0kikqu0swWAEZDbr/7Q1xoNQQMrD9lNx9
         W+PeULXJXFWvpKlIHkG8G1N4+dq2abOGvUilkFgqkJOkbqJQgihsrWMgxhWD1h+lv7nY
         6dyS/Dy9jmBtxRcRRPGb/kpgImyrlsqpUj9okXYvbTl7hh401KTNC4ttUfg+dmHGUvdY
         UWhybAzDCdqeU7gQNTHDu2ECQe685H3mSGscYauLFebmU0XgvwRQvKXCM5iOZG95pFWE
         2PWBrASaBvLFoXO4HQK8q934x5quNX3HR7E41wTrSvpekIAt7WqBt5nr3Z1/lyPGG+9N
         +dcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678401477;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+YkCkrjJHa9Smmj/wJYS+f+10gt8i1v3+K2/QxqxGnI=;
        b=EccjTut2iYLcXA2ng8HW/cpBX8JrkOiPm6j3wpGMq6k0Oqlw+t05IhedOljE1Ol93t
         vmxd+Q6wuh0iP5K5aQ6JT/601RGiMM4cfqmKtGfo0q1VbaXWbfo8/57uWySJ5EIXhpEk
         cNQ14SYyhaA5P4AmszNAFioOmzjGDTA+3XHUZJCvv9p3WsoxIYRgnTDE2KAgA6A2CtnW
         g+Nx6jPoOzVEgQS+1tc8F9L/NZUOWZPE1UsdPzbaq85+rgcYVaT8iRwzBtiq4uXegz1A
         Iy6Nj1AW6xmDHL5PMFrW5wTcTwk17NyH+WbBTcOH7prBuegYCCpX9sjggDeDeiVnGRPK
         ex+w==
X-Gm-Message-State: AO0yUKXQh0yS85w340zxrw94hEvlIvEXoo14vVYqMSaSuvl+E9GPHhf3
        OVZGQ/4qnEe8lPO0KWE9B8M=
X-Google-Smtp-Source: AK7set8NHhpkF76F1n+vl6zWoM3i7+IYLzBdgq5tR6J3qDrVLnoQ2La7K2evFiIWcHcaTNKePGLOxQ==
X-Received: by 2002:a05:600c:1e1f:b0:3eb:fc6:79cf with SMTP id ay31-20020a05600c1e1f00b003eb0fc679cfmr780797wmb.6.1678401476689;
        Thu, 09 Mar 2023 14:37:56 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id g12-20020a05600c310c00b003e209b45f6bsm1183981wmo.29.2023.03.09.14.37.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 14:37:56 -0800 (PST)
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
Subject: [net-next PATCH v2 00/14] net: Add basic LED support for switch/phy
Date:   Thu,  9 Mar 2023 23:35:10 +0100
Message-Id: <20230309223524.23364-1-ansuelsmth@gmail.com>
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
 arch/arm/boot/dts/qcom-ipq8064-rb3011.dts     | 124 ++++++++-
 drivers/net/dsa/qca/Kconfig                   |   7 +
 drivers/net/dsa/qca/Makefile                  |   1 +
 drivers/net/dsa/qca/qca8k-8xxx.c              |  19 +-
 drivers/net/dsa/qca/qca8k-leds.c              | 236 ++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  83 ++++++
 drivers/net/phy/marvell.c                     |  81 +++++-
 drivers/net/phy/phy_device.c                  | 115 +++++++++
 include/linux/phy.h                           |  33 +++
 13 files changed, 765 insertions(+), 24 deletions(-)
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c

-- 
2.39.2


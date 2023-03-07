Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88ACA6AF8C2
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 23:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjCGWd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 17:33:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbjCGWd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 17:33:27 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9D395E34;
        Tue,  7 Mar 2023 14:33:26 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so96478wms.2;
        Tue, 07 Mar 2023 14:33:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678228405;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=vy4nAJ52d9qly4N/eBpamNRw8G/Xs8TXNaSOjPeSnwo=;
        b=LEIqTiz2iyvbjkfbQ0JFXMuS5UBnCK76trtCCqGFHK5H6SCXDyDLuV68bNshL1qQKe
         ohV4Uyfz6JUdqjMpa8zlGCwlFUV/k5sTDLpxA86QnGF5hHmSACtkUnXaawWomSOEUrVx
         jaSJMSXC8yiZvKdiT8/vbg4Y3ar4MJXmP2kDPWojUsvA5eYOw2M1lNcEp1EbKuhSvVyO
         1gYbwt9YQJGT8TMZjf4ztVp7T2yfe3A4uFAQ3Ih0uDrB9zac4Zlcu7X7MUrz9LL33bTg
         Unv174q/7K+1+R7MVWhELDk7rB6D5KESQ/dE7BjO4HQhI8aW47tUfcDv7ZT6ZRG+FLoV
         GRlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678228405;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vy4nAJ52d9qly4N/eBpamNRw8G/Xs8TXNaSOjPeSnwo=;
        b=6MIyU+ENRVdcKg/tQx9/OSDs422qczL/I8PNWcB9+TvYsZE0PgsowRKcsQST2brIwE
         hJSLA9IX64sYCrltBL8AwLL6spHILF8AgJz1GQvEbEAzEhmeiKydixvk5K9VlUJNJb/j
         3+JVQpkVH2RF5rTcl4rTvK1EX4tiDget5nZjlhOaZD19WQGJ0DAo5hlYMiAznGpeo9m5
         DI30LWFVPuLlapm4hrroL8rEkvcJF4vSiGKarM6Y2VauzWLeUMxJEbqjViNc6305kERh
         z8ejCiwRyjVaHmRq11gNgmHcyFs5iXQ9igYCL/mEBpeeHqArkYZHAyt4CPMzYQ672nCV
         C4bQ==
X-Gm-Message-State: AO0yUKXkje/9biCyz+jpYsUmqC+klIGZEdxm2PJ1MW66ENDPvlVPRuqS
        VjOFbYxyzOHEpjPIZUHkbBO8wzx6jNw=
X-Google-Smtp-Source: AK7set+iISmhUNkN69tYI3z874X1mjN+SCBOpOBQFjZ6yWOi430CV4ezhe3Gmm24A0IprkHYwQo04w==
X-Received: by 2002:a05:600c:46c7:b0:3e7:f108:664c with SMTP id q7-20020a05600c46c700b003e7f108664cmr13776053wmo.40.1678228404628;
        Tue, 07 Mar 2023 14:33:24 -0800 (PST)
Received: from localhost.localdomain (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.googlemail.com with ESMTPSA id q11-20020a05600c46cb00b003dc1d668866sm19233101wmo.10.2023.03.07.14.33.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 14:33:24 -0800 (PST)
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
        Christian Marangi <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: [net-next PATCH 00/11] net: Add basic LED support for switch/phy
Date:   Tue,  7 Mar 2023 18:00:35 +0100
Message-Id: <20230307170046.28917-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
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

Andrew Lunn (6):
  net: phy: Add a binding for PHY LEDs
  net: phy: phy_device: Call into the PHY driver to set LED brightness.
  net: phy: marvell: Add software control of the LEDs
  net: phy: phy_device: Call into the PHY driver to set LED blinking.
  net: phy: marvell: Implement led_blink_set()
  arm: mvebu: dt: Add PHY LED support for 370-rd WAN port

Christian Marangi (5):
  net: dsa: qca8k: add LEDs basic support
  net: dsa: qca8k: add LEDs blink_set() support
  dt-bindings: net: dsa: dsa-port: Document support for LEDs node
  dt-bindings: net: dsa: qca8k: add LEDs definition example
  dt-bindings: net: phy: Document support for LEDs node

 .../devicetree/bindings/net/dsa/dsa-port.yaml |   7 +
 .../devicetree/bindings/net/dsa/qca8k.yaml    |  24 ++
 .../devicetree/bindings/net/ethernet-phy.yaml |  22 ++
 arch/arm/boot/dts/armada-370-rd.dts           |  14 ++
 drivers/net/dsa/qca/Kconfig                   |   7 +
 drivers/net/dsa/qca/Makefile                  |   1 +
 drivers/net/dsa/qca/qca8k-8xxx.c              |   4 +
 drivers/net/dsa/qca/qca8k-leds.c              | 238 ++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  69 +++++
 drivers/net/phy/marvell.c                     |  81 +++++-
 drivers/net/phy/phy_device.c                  | 115 +++++++++
 include/linux/phy.h                           |  33 +++
 12 files changed, 610 insertions(+), 5 deletions(-)
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c

-- 
2.39.2


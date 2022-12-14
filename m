Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4E464D413
	for <lists+netdev@lfdr.de>; Thu, 15 Dec 2022 00:58:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbiLNX6y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 18:58:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229832AbiLNX6b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 18:58:31 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C071C37F89;
        Wed, 14 Dec 2022 15:55:36 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id bg10so12639441wmb.1;
        Wed, 14 Dec 2022 15:55:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=g0acZiAt08vPMW/QCN34b28bDKVCUpWRirnFpjrDBh8=;
        b=oBa4p7v0MTw11EnJHwrSnuNi2eoVVvWAIf2Ys/jzUfa2IU/hs2sSEH0JsBwnXwnN3g
         ueNtvegrhMsYKkGirDyKyt3k8djsY5Z0bLh4dmgqlsvpLQ14GosnZiR3AGOr6MhY6CFC
         6flKl5/kRWaTPxpwI0PUBzHRzgohSfl7H9scj46EgGZ2/x32m6d82qHOWIHilLnauNsk
         SUjrioCmX3J0G00g3RgLi9sErOK0iXTuxi+6xwoVezWh90bGHQo36GQCxPhqUeAxiiR7
         PAWdP8D7jeyt63bdCz0vMGMM36AkdlWNJRFIbIeil8ECsQZo7cBhJXciPW/0Jaxatgy1
         JFHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=g0acZiAt08vPMW/QCN34b28bDKVCUpWRirnFpjrDBh8=;
        b=IeX2pNm1PjLTXlR/tN6/MboRuB63hriEYhbq/nG26P9YB6EEXZME4Hqx2cFkRtgvo6
         oEcywLDOY9UJFMXAkOsYU296by4/RXOYnRdhNYYI5fhOYjMXVmCHIbnLDg3QHGZjaEtL
         R3J2uGhHELN8sXwR1LJYSWPLLOUsepmYkoa2yOd1itb59BIAQYM8yruhvt/goUe5mrcx
         X5z6+Nm/aRxvLnAsckXXxdzZtAWILrCTOOcirbFwRV0i6NU+XAXQne5djEvdBrNpmVrX
         kRUUrGa2sm1lSkDt6xvLEEoj0fSEJPf9Li9tVxlHD5z22tUQQFwv5ZPtx5rxHT06hgYN
         xioA==
X-Gm-Message-State: ANoB5pm8cprtqQlre5q7EinLY6xjR7otFmXt0h9oSvc5swATiCHbtdr4
        UQHPHl751dCGqUW1GZ/2uxs=
X-Google-Smtp-Source: AA0mqf5eKk5Xt5xKisW4kLpGaP4bMina+srdRvA69aSzaFVS9eniboyL5Y9NaYXKn754SoAUD/nOpg==
X-Received: by 2002:a05:600c:3c90:b0:3cf:6f4d:c259 with SMTP id bg16-20020a05600c3c9000b003cf6f4dc259mr21151780wmb.39.1671062106592;
        Wed, 14 Dec 2022 15:55:06 -0800 (PST)
Received: from localhost.localdomain (93-42-71-18.ip85.fastwebnet.it. [93.42.71.18])
        by smtp.googlemail.com with ESMTPSA id u2-20020adff882000000b00241d21d4652sm4163549wrp.21.2022.12.14.15.55.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Dec 2022 15:55:05 -0800 (PST)
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
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Christian Marangi <ansuelsmth@gmail.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH v7 00/11] Adds support for PHY LEDs with offload triggers
Date:   Thu, 15 Dec 2022 00:54:27 +0100
Message-Id: <20221214235438.30271-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

This is another attempt on adding this feature on LEDs, hoping this is
the right time and someone finally notice this.


Most of the times Switch/PHY have connected multiple LEDs that are
controlled by HW based on some rules/event. Currently we lack any
support for a generic way to control the HW part and normally we
either never implement the feature or only add control for brightness
or hw blink.

This is based on Marek idea of providing some API to cled but use a
different implementation that in theory should be more generilized.

The current idea is:
- LED driver implement 3 API (hw_control_status/start/stop).
  They are used to put the LED in hardware mode and to configure the
  various trigger.
- We have hardware triggers that are used to expose to userspace the
  supported hardware mode and set the hardware mode on trigger
  activation.
- We can also have triggers that both support hardware and software mode.
- The LED driver will declare each supported hardware blink mode and
  communicate with the trigger all the supported blink modes that will
  be available by sysfs.
- A trigger will use blink_set to configure the blink mode to active
  in hardware mode.
- On hardware trigger activation, only the hardware mode is enabled but
  the blink modes are not configured. The LED driver should reset any
  link mode active by default.

Each LED driver will have to declare explicit support for the offload
trigger (or return not supported error code) as we the trigger_data that
the LED driver will elaborate and understand what is referring to (based
on the current active trigger).

I posted a user for this new implementation that will benefit from this
and will add a big feature to it. Currently qca8k can have up to 3 LEDs
connected to each PHY port and we have some device that have only one of
them connected and the default configuration won't work for that.

The netdev trigger is expanded and it does now support hardware only
triggers.
The idea is to use hardware mode when a device_name is not defined.
An additional sysfs entry is added to give some info about the available
trigger modes supported in the current configuration.


It was reported that at least 3 other switch family would benefits by
this as they all lack support for a generic way to setup their leds and
netdev team NACK each try to add special code to support LEDs present
on switch in favor of a generic solution.

v7:
- Rebase on top of net-next (for qca8k changes)
- Fix some typo in commit description
- Fix qca8k leds documentation warning
- Remove RFC tag
v6:
- Back to RFC.
- Drop additional trigger
- Rework netdev trigger to support common modes used by switch and
  hardware only triggers
- Refresh qca8k leds logic and driver
v5:
- Move out of RFC. (no comments from Andrew this is the right path?)
- Fix more spelling mistake (thx Randy)
- Fix error reported by kernel test bot
- Drop the additional HW_CONTROL flag. It does simplify CONFIG
  handling and hw control should be available anyway to support
  triggers as module.
v4:
- Rework implementation and drop hw_configure logic.
  We now expand blink_set.
- Address even more spelling mistake. (thx a lot Randy)
- Drop blink option and use blink_set delay.
- Rework phy-activity trigger to actually make the groups dynamic.
v3:
- Rework start/stop as Andrew asked.
- Introduce more logic to permit a trigger to run in hardware mode.
- Add additional patch with netdev hardware support.
- Use test_bit API to check flag passed to hw_control_configure.
- Added a new cmd to hw_control_configure to reset any active blink_mode.
- Refactor all the patches to follow this new implementation.
v2:
- Fix spelling mistake (sorry)
- Drop patch 02 "permit to declare supported offload triggers".
  Change the logic, now the LED driver declare support for them
  using the configure_offload with the cmd TRIGGER_SUPPORTED.
- Rework code to follow this new implementation.
- Update Documentation to better describe how this offload
  implementation work.

Christian Marangi (11):
  leds: add support for hardware driven LEDs
  leds: add function to configure hardware controlled LED
  leds: trigger: netdev: drop NETDEV_LED_MODE_LINKUP from mode
  leds: trigger: netdev: rename and expose NETDEV trigger enum modes
  leds: trigger: netdev: convert device attr to macro
  leds: trigger: netdev: add hardware control support
  leds: trigger: netdev: use mutex instead of spinlocks
  leds: trigger: netdev: add available mode sysfs attr
  leds: trigger: netdev: add additional hardware only triggers
  net: dsa: qca8k: add LEDs support
  dt-bindings: net: dsa: qca8k: add LEDs definition example

 .../devicetree/bindings/net/dsa/qca8k.yaml    |  24 ++
 Documentation/leds/leds-class.rst             |  53 +++
 drivers/leds/Kconfig                          |  11 +
 drivers/leds/led-class.c                      |  27 ++
 drivers/leds/led-triggers.c                   |  29 ++
 drivers/leds/trigger/ledtrig-netdev.c         | 385 ++++++++++++-----
 drivers/net/dsa/qca/Kconfig                   |   9 +
 drivers/net/dsa/qca/Makefile                  |   1 +
 drivers/net/dsa/qca/qca8k-8xxx.c              |   4 +
 drivers/net/dsa/qca/qca8k-leds.c              | 406 ++++++++++++++++++
 drivers/net/dsa/qca/qca8k.h                   |  62 +++
 include/linux/leds.h                          | 103 ++++-
 12 files changed, 1015 insertions(+), 99 deletions(-)
 create mode 100644 drivers/net/dsa/qca/qca8k-leds.c

-- 
2.37.2


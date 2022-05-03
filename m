Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87EDD518825
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 17:18:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238096AbiECPVu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 11:21:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236468AbiECPVs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 11:21:48 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2D93A5D1;
        Tue,  3 May 2022 08:18:15 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id y3so34028170ejo.12;
        Tue, 03 May 2022 08:18:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hj7+Fx1qxFXAGhjgQivL/sZ1+3IRshoKUQbn1Xsv+rU=;
        b=Q4Bu/xaeAW7QHdICsdR2KdPYwNBknQR7tNCxpLoYMBpN4KyHtVolYB4G0tdYsD4l7z
         664uGqmw5el2cIlMHtss7Kmr5R4jXC5gDkG9knDlCx9MSIzWvSTbO5LaE5LCDoLQ6npe
         oKRl5c2LCdrsiB6KtKW/W/pGhLHYkOP+b0EoBqrI7WIPpN6ba8RNASkEVpsSuEZPmNeC
         VJTvSGiloRuMQRZ9S9XnwWmPCqjucvRydzQO0E22Htsyt7G1cZujuoV20GwGfggEwuwn
         42FnisUQj1O/0kMiWhvzKmIPxIyTO8MTPy2dPqvghEWD1WIjexRgFbBcF+iNKJeb9Ady
         SHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Hj7+Fx1qxFXAGhjgQivL/sZ1+3IRshoKUQbn1Xsv+rU=;
        b=qIWL7Gtq3Z9on0+Ea9cQcuO/rF7GK8V0yDbMBpM60oFVf9DQuBZq+6TZJ9gv5oNG9D
         5+KCCZVytFxDw3ZTYMHr/BnZ5IhsjnOyDkcHozF5/YAjdeQTJ2/oRWoQAFCS/U2d/Ki3
         z67Y65/AlnNCeqrvRwcHhiRe9bcxZMSWBQcnNOjDtvz5nZ24KN24SMvLh8bUP/k1DPu2
         cU9Df+u2gKhBPwJHBNVIcSR/8fPCZKDvMF4tBE25YulLcAFlZs+CXfeYp6ITD1WQU7ri
         500AskUSMFqphDSROU0qr7aon4XhPQoMn4S+kYjrXi4rNGHJYIZw/HticIxhFhpH2wyf
         ADOw==
X-Gm-Message-State: AOAM531L2tgRp39KHTeOayzslqhR5bFfrZe6IaTxyHI1YgeN7kSGtn40
        3ljxw1r2aAEarlAsfdNuAFQ=
X-Google-Smtp-Source: ABdhPJzH3b5YFoLRjN/TbKqgEL7PdxZKBAYL6uF9i/AsCy6jvvLTRvFjFBl7zx++ua4Nl9hhT96STQ==
X-Received: by 2002:a17:906:1c12:b0:6f3:9eed:e0 with SMTP id k18-20020a1709061c1200b006f39eed00e0mr16550294ejg.656.1651591093976;
        Tue, 03 May 2022 08:18:13 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-190.ip85.fastwebnet.it. [93.42.70.190])
        by smtp.googlemail.com with ESMTPSA id v3-20020aa7d9c3000000b0042617ba63cesm7947507eds.88.2022.05.03.08.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 08:18:13 -0700 (PDT)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH v6 00/11] Adds support for PHY LEDs with offload triggers
Date:   Tue,  3 May 2022 17:16:22 +0200
Message-Id: <20220503151633.18760-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

This is another attempt on adding this feature on LEDs.

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

More polish is required but this is just to understand if I'm taking
the correct path with this implementation hoping we find a correct
implementation and we start working on the ""small details""

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

Ansuel Smith (11):
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

 .../devicetree/bindings/net/dsa/qca8k.yaml    |  20 +
 Documentation/leds/leds-class.rst             |  53 +++
 drivers/leds/Kconfig                          |  11 +
 drivers/leds/led-class.c                      |  27 ++
 drivers/leds/led-triggers.c                   |  29 ++
 drivers/leds/trigger/ledtrig-netdev.c         | 385 ++++++++++++-----
 drivers/net/dsa/Kconfig                       |   9 +
 drivers/net/dsa/Makefile                      |   1 +
 drivers/net/dsa/qca8k-leds.c                  | 408 ++++++++++++++++++
 drivers/net/dsa/qca8k.c                       |   4 +
 drivers/net/dsa/qca8k.h                       |  61 +++
 include/linux/leds.h                          | 103 ++++-
 12 files changed, 1012 insertions(+), 99 deletions(-)
 create mode 100644 drivers/net/dsa/qca8k-leds.c

-- 
2.34.1


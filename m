Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F6844CECC
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 02:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232736AbhKKBh4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 20:37:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232005AbhKKBhz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Nov 2021 20:37:55 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBD92C061766;
        Wed, 10 Nov 2021 17:35:06 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id d24so7152598wra.0;
        Wed, 10 Nov 2021 17:35:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jwqq2pe+WQgD85hWBRRaf4L09Fzexs7QXv8b+JM/QuQ=;
        b=WgAH6TM6E0zDFux9ky93ucwmaJ0Q/JqfoOLW4DQ9c8Z3a6AwtA2nIg+ablW7Bc8dxX
         hB3LXOJ9gaHAJZmN7eUfEup/genRK+WewtubjaBk8lPmlBh6U/2pcy8TzDCnxylbqcP4
         7hQzKqqwIpjZXv/O0m2DAYQmF2jK2oyNHz4flQyH34JYFJtKf4gC/MAWN6Xk+2+dJHEU
         yPp5vHt1k0iYmvcfXCA8+2FLhP3hYA/iF4KDTsMLS28hQYezCezFo1wXFJgWUQYFHLX7
         ODKDtaVxaVT6VY4UinQKnWp+74tqskuTk+S7gfG73RSN9s+RgzI1iPM23GTh7ZAD8Ib+
         P1jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=jwqq2pe+WQgD85hWBRRaf4L09Fzexs7QXv8b+JM/QuQ=;
        b=K1ZcREeoUu4qWyqoCoCOz08Xfsjv02cFZlxXUxm1RzQyHk6zLUuazG9LFYsapCS7sB
         ByIWRDPe/RALC2+Jnk3SuG1dFZwjBS53Oli8z0bkdWV1WR6PEBsQBg9xoj/CJdLxIlU0
         ldrvuBjsu1uVugI2kp/tGft3fW9BXWeSJWkuK5Oymsvq4ES/SExEILhJo2aMFgRmnaX4
         UItNjojWLRy3wSmXAfa8AgBzN4eb6nvlJ/qKr1qgVd3nKYBQ/UWF2VNu55d7inqUES/b
         Qm7xNY3UkLPTFMpA9gIakzCDmAmSi90qJ+pLH3brGP686bv2P+mkJr9RkVduB9sp69+7
         MA0A==
X-Gm-Message-State: AOAM5334uw9GkHWHY3+joNjoUkIH8rzyN4j5qFNRrB6SJipjQqJpjCfC
        BxqnKLagTfuUFHHkzsrj0pE=
X-Google-Smtp-Source: ABdhPJxqjLxwrL/9GuF2fgTUs8BDvThhn+l79UAAYEHUn3r3U2VDncKDMWUIfGgwNyufSHAKv5DAAg==
X-Received: by 2002:a5d:6707:: with SMTP id o7mr4270354wru.172.1636594504921;
        Wed, 10 Nov 2021 17:35:04 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id d8sm1369989wrm.76.2021.11.10.17.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 17:35:04 -0800 (PST)
From:   Ansuel Smith <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [RFC PATCH v4 0/8] Adds support for PHY LEDs with offload triggers
Date:   Thu, 11 Nov 2021 02:34:52 +0100
Message-Id: <20211111013500.13882-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is another attempt in adding support for PHY LEDs. Most of the
times Switch/PHY have connected multiple LEDs that are controlled by HW
based on some rules/event. Currently we lack any support for a generic
way to control the HW part and normally we either never implement the
feature or only add control for brightness or hw blink.

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

I also posted the netdev trigger expanded with the hardware support.

More polish is required but this is just to understand if I'm taking
the correct path with this implementation hoping we find a correct
implementation and we start working on the ""small details""

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

Ansuel Smith (8):
  leds: add support for hardware driven LEDs
  leds: document additional use of blink_set for hardware control
  leds: trigger: netdev: drop NETDEV_LED_MODE_LINKUP from mode
  leds: trigger: netdev: rename and expose NETDEV trigger enum and
    struct
  leds: trigger: netdev: add hardware control support
  leds: trigger: add hardware-phy-activity trigger
  net: dsa: qca8k: add LEDs support
  dt-bindings: net: dsa: qca8k: add LEDs definition example

 .../devicetree/bindings/net/dsa/qca8k.yaml    |  20 +
 Documentation/leds/leds-class.rst             |  49 ++
 drivers/leds/Kconfig                          |  11 +
 drivers/leds/led-class.c                      |  40 ++
 drivers/leds/led-triggers.c                   |  22 +
 drivers/leds/trigger/Kconfig                  |  28 ++
 drivers/leds/trigger/Makefile                 |   1 +
 .../trigger/ledtrig-hardware-phy-activity.c   | 180 ++++++++
 drivers/leds/trigger/ledtrig-netdev.c         |  92 ++--
 drivers/net/dsa/Kconfig                       |   9 +
 drivers/net/dsa/Makefile                      |   1 +
 drivers/net/dsa/qca8k-leds.c                  | 423 ++++++++++++++++++
 drivers/net/dsa/qca8k.c                       |   8 +-
 drivers/net/dsa/qca8k.h                       |  65 +++
 include/linux/leds.h                          |  97 +++-
 15 files changed, 999 insertions(+), 47 deletions(-)
 create mode 100644 drivers/leds/trigger/ledtrig-hardware-phy-activity.c
 create mode 100644 drivers/net/dsa/qca8k-leds.c

-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF69444A49A
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 03:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240905AbhKIC3G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 21:29:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239826AbhKIC3A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 21:29:00 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28879C061767;
        Mon,  8 Nov 2021 18:26:15 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id ee33so70828260edb.8;
        Mon, 08 Nov 2021 18:26:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ATv7QJLJGWA/jVTvZ8jIOs6JMQffIGJpisb3naCydY=;
        b=iLnnzMkMKOaSW8WZAkRUis6pzefQrk+lQOUsZjWFouEisWyeoxFBtRFVEqDcwnL/3j
         QOQDwwfDPxTE+QZxOMEwfKJQcIbzP1iHKx/8q3OJekP0lvJXIUPWeMb4eiwLdfyOFnv0
         z2uDOkHCsBnjCuyPatya69mzMQvxWbk3jU9iKz+rxMdbvhA39wS2g1Xo1NPBIumcrnSq
         z5iUhcJOgWLbP5mL1hIbENC1xBnoLTgH0CgXCsppRZlIqVLGd8m+Tnyb/2OobcyB3VmB
         4SF5NRY63fQGeVYZvMHV6OfwTOfJLfMiJtwGg/GTGycUINsII10GfZfy4KntXpHcWxfQ
         /c0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5ATv7QJLJGWA/jVTvZ8jIOs6JMQffIGJpisb3naCydY=;
        b=VFRpRdPAzjbSS99WVu7R51W5US1iDZiFc/CEiiClG4hU1WPrLfkm6CzXrZlifTwfnk
         cH58N+oghEFPsJg297vze6Y69iRwe1tSu0UGGBsSN/c1i8mRoTXtROOMillmf17Jbyzh
         wyR5F8gDfZea3ocCV65hpTTKOtoIs23Xi3yChzdDJOxV2sbqGtNTMCMp5fZO9SyhRgCd
         vvbd9dP2vCQQ0Q/zI08w73OwSsIFpKlMPDiDQf5IlidvrIIdZXDMJXODxLdeD21JSiVn
         HmOBjAU9Kx+/PqNQfEWDlBVQJCmoerHida3paCIo1fne4MdnJ1McyB4cWNStDNs2hD+i
         rlew==
X-Gm-Message-State: AOAM5313g5PtqjojqOouP/xSkZlpXjsone7b6LjyJsJ4dCzO8eXdtAoS
        HnS7NG8YRR2QPCRILspqzF4=
X-Google-Smtp-Source: ABdhPJxP4iaB7NvDrtN/dYQ0n5j+BUHoxDaa8LdU0ILc0h9s4G4rn8jXN3afAKr/k+hO4ieqScKW3Q==
X-Received: by 2002:a17:907:6d10:: with SMTP id sa16mr5122537ejc.532.1636424773605;
        Mon, 08 Nov 2021 18:26:13 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m5sm8760900ejc.62.2021.11.08.18.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 18:26:13 -0800 (PST)
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
Subject: [RFC PATCH v3 0/8] Adds support for PHY LEDs with offload triggers
Date:   Tue,  9 Nov 2021 03:26:00 +0100
Message-Id: <20211109022608.11109-1-ansuelsmth@gmail.com>
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
- LED driver implement 5 API (hw_control_status/start/stop/configure).
  They are used to put the LED in offload mode and to configure the
  various trigger.
- We have hardware triggers that are used to expose to userspace the
  supported offload triggers and set the offload mode on trigger
  activation.
- We can also have triggers that both support hardware and software mode.
- The LED driver will declare each supported hardware trigger and
  communicate with the trigger all the supported blink modes that will
  be available by sysfs.
- The LED driver will set how the hardware mode is activated/disabled and
  will set a configure function to set each supported triggers.
  This function provide 5 different mode enable/disable/read/supported/zero
  that will enable or disable the offload trigger, read the current status,
  check if supported or reset any active blink mode.
- On hardware trigger activation, only the hardware mode is enabled but
  the blink modes are not configured. This means that the LED will
  run in hardware mode but will have the default rules/event set by the
  device by default. To change this the user will have to operate via
  userspace (or we can consider adding another binding in the dts to
  declare also a default trigger configuration)

Each LED driver will have to declare explicit support for the offload
trigger (or return not supported error code) as we pass a flag that
the LED driver will elaborate and understand what is referring to (based
on the current active trigger).

I posted a user for this new implementation that will benefit from this
and will add a big feature to it. Currently qca8k can have up to 3 LEDs
connected to each PHY port and we have some device that have only one of
them connected and the default configuration won't work for that.

I also posted the netdev trigger expanded with the hardware support.

More polish is required but this is just to understand if I'm taking
the correct path with this implementation.

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
  leds: add function to configure hardware controlled LED
  leds: trigger: netdev: drop NETDEV_LED_MODE_LINKUP from mode
  leds: trigger: netdev: rename and expose NETDEV trigger enum modes
  leds: trigger: netdev: add hardware control support
  leds: trigger: add hardware-phy-activity trigger
  net: dsa: qca8k: add LEDs support
  dt-bindings: net: dsa: qca8k: add LEDs definition example

 .../devicetree/bindings/net/dsa/qca8k.yaml    |  20 +
 Documentation/leds/leds-class.rst             |  53 +++
 drivers/leds/Kconfig                          |  11 +
 drivers/leds/led-class.c                      |  27 ++
 drivers/leds/led-triggers.c                   |  29 ++
 drivers/leds/trigger/Kconfig                  |  28 ++
 drivers/leds/trigger/Makefile                 |   1 +
 .../trigger/ledtrig-hardware-phy-activity.c   | 171 +++++++
 drivers/leds/trigger/ledtrig-netdev.c         | 108 +++--
 drivers/net/dsa/Kconfig                       |   9 +
 drivers/net/dsa/Makefile                      |   1 +
 drivers/net/dsa/qca8k-leds.c                  | 429 ++++++++++++++++++
 drivers/net/dsa/qca8k.c                       |   8 +-
 drivers/net/dsa/qca8k.h                       |  65 +++
 include/linux/leds.h                          | 115 ++++-
 15 files changed, 1045 insertions(+), 30 deletions(-)
 create mode 100644 drivers/leds/trigger/ledtrig-hardware-phy-activity.c
 create mode 100644 drivers/net/dsa/qca8k-leds.c

-- 
2.32.0


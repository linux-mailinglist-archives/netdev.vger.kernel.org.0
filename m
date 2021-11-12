Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90DB244EA3B
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbhKLPiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:38:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233128AbhKLPiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:38:54 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC5CC061766;
        Fri, 12 Nov 2021 07:36:03 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id c4so16151650wrd.9;
        Fri, 12 Nov 2021 07:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vCjWdrV/gKX6Jy5Iea1WK43cQ1LMS/ERUU+iXaSrKbo=;
        b=nkDaIWtzIvZs1H2Gbx5SGNw50vQoWRW90V+DldNx+iivMJllUwpHlWC+da29GcrVku
         zVGBZXL1hkply2gby2DnW14TMkhUbXvaQArIXKu1M+au3JG8ehAgxJ+4mPiZ6wW4tghd
         QQuLz9rk0ugE/iX8BE63c8jiv1xLfCgKnVzCj7RBZcUKXyvyj01Syhy2aH9789zVQyyg
         aI0ZUwpKFYE1KW/YTTc3qZN1rw1iCqvoiqy5pCbd0Q2E4cDM2x3cRVzYgFU6rzLyLTVQ
         oalNoyutGxcBEm3i6xH3ievf7w6HxCusX2/tz1kn/qH6HygIkdZkdei8UCMGczJPDvz2
         n4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=vCjWdrV/gKX6Jy5Iea1WK43cQ1LMS/ERUU+iXaSrKbo=;
        b=BlCvYgBz6SCRinTkjtqSFNONp9R4RVW3KWiN+80vr3bN0SQCqZIGGHc0ebyyMf7SJe
         ljfizGdPidbwyL0TVyGxj718FCjkOHoAYJ6G14OjMvV/wWP7FrZijJBPNBwdeeNWaWgj
         oYlLx+GimxY9vAPCTTRNkbuVjytQ+LCIjhJ4YpRbONtcfsYItYm4GGsg1f+MF/6ayTSo
         GFVsoX3eqUwbyONgWqZ2NDriYGKN8a0ruwTKiWlAPIWxxxbgILvzLuDRTe4i8uUrVi6G
         MpMMkC4bbVaeLpoV033Mg2tUqg8rsxLgthUwFlJSdh1e4N50Da7jklyckAx5Cg4sgpl8
         UqJw==
X-Gm-Message-State: AOAM531aUYSFYU4IP6CDz25DQLLa26YfwQF4JhEU5w6QOcGaoQkN1iDZ
        rZhWmJMx5Ej34Tyuvmc/2NM=
X-Google-Smtp-Source: ABdhPJwkdTYC7RHTobuNac9fuvnGmQ64YJjHjEymtwLK1ClDgIjYac9Ha1gb+Mk6ztjs+qQRVRJ6JA==
X-Received: by 2002:a05:6000:15c6:: with SMTP id y6mr19344170wry.422.1636731361857;
        Fri, 12 Nov 2021 07:36:01 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id az4sm4217543wmb.20.2021.11.12.07.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Nov 2021 07:36:01 -0800 (PST)
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
Subject: [PATCH v5 0/8] Adds support for PHY LEDs with offload triggers
Date:   Fri, 12 Nov 2021 16:35:49 +0100
Message-Id: <20211112153557.26941-1-ansuelsmth@gmail.com>
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
 drivers/leds/led-class.c                      |  40 ++
 drivers/leds/led-triggers.c                   |  22 +
 drivers/leds/trigger/Kconfig                  |  37 +-
 drivers/leds/trigger/Makefile                 |   1 +
 .../trigger/ledtrig-hardware-phy-activity.c   | 180 ++++++++
 drivers/leds/trigger/ledtrig-netdev.c         |  92 ++--
 drivers/net/dsa/Kconfig                       |  11 +
 drivers/net/dsa/Makefile                      |   1 +
 drivers/net/dsa/qca8k-leds.c                  | 423 ++++++++++++++++++
 drivers/net/dsa/qca8k.c                       |   8 +-
 drivers/net/dsa/qca8k.h                       |  65 +++
 include/linux/leds.h                          |  94 +++-
 14 files changed, 995 insertions(+), 48 deletions(-)
 create mode 100644 drivers/leds/trigger/ledtrig-hardware-phy-activity.c
 create mode 100644 drivers/net/dsa/qca8k-leds.c

-- 
2.32.0


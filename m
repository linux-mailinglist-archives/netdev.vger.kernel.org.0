Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 109804476DB
	for <lists+netdev@lfdr.de>; Mon,  8 Nov 2021 01:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235180AbhKHA1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 19:27:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbhKHA1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 19:27:48 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA68C061570;
        Sun,  7 Nov 2021 16:25:05 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w1so55979786edd.10;
        Sun, 07 Nov 2021 16:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MONscSKyhvi2+SRKlBcGRiPlb7krpgUPlxLNPbjxYgo=;
        b=bad+zSa0E8ifLsxFIIjQOYUpj6cMP4QEQxAksHyC+dUEaJmhyqt5mMse6Z5zIMA6v4
         1JTVZB4rIye0fXMLmOgQPozH47hCaUtuIJq/NioXDoF48lXy8Ikqfl2jtGRlIQphLEG8
         e50FmCg4kKLtcPSNiMYGDDEYQoVsnretSCq62en/klNk28jGf1WnGEzZhQ5DX0tfUnaQ
         BV+OUNsqG2GkbkYE5wIxX0TMGrLOsEwLaaP2gdO3xGBkaEaJ8I3lxQdwzjV3b7LWnu/7
         OC6XpuVTzI80d4P5+T0ZgMcB5H6LVl0MX0VRVZGSmSv7609AOL3nhHX+TlYbOhuCOxpd
         kq/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MONscSKyhvi2+SRKlBcGRiPlb7krpgUPlxLNPbjxYgo=;
        b=TZJ16GckiqBqWJUvDeTVEEJBCILVRmeA8F0LDZcN5wWURjq1LnROysL+9mmnQ/aTbH
         497hJ/mn4Hq8L8ZjhUp3gJubUII0LQsgX3/h0yIzCHFGIHrs+VfpSs3vts9WR+WQe6iN
         ZNiSswIHrPIQFefGTTDVKqbaEh4agRHMEKcYQvEK7PVbprocHu/2ho1cGbmnabHG0oPS
         Rs3AH1gqdVE0wQrsS3n/Z3DqhFb8Sum5jXy4sVPKnCucEzb1t1HxPIHmPgC1NZGw4dUz
         xKZmxAJjfWauwEIBupkcBOFHrx6uVCBPpEt/qtTJ+pxWOa7N/THRASBaHz+wnhUG2oqG
         bt9Q==
X-Gm-Message-State: AOAM532PcPGE+wHelhOhHgNaRxoaC3/fhZ7Zaa7qqb4J5C4Umfyr/jV2
        pyEYPd8Hg1VL4k+HzOPUpY0=
X-Google-Smtp-Source: ABdhPJxwuWOpWvwWyszMr+He1assUHDS3DKb5+qzQypzgnqgp3iSmhDeLLoGhR6U6by6xxd+xNcTPg==
X-Received: by 2002:a05:6402:40d0:: with SMTP id z16mr73382067edb.340.1636331103501;
        Sun, 07 Nov 2021 16:25:03 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id bf8sm8537878edb.46.2021.11.07.16.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 16:25:03 -0800 (PST)
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
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: [RFC PATCH v2 0/5] Adds support for PHY LEDs with offload triggers
Date:   Mon,  8 Nov 2021 01:24:55 +0100
Message-Id: <20211108002500.19115-1-ansuelsmth@gmail.com>
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
- LED driver implement 2 API (trigger and configure). They are used to
  put the LED in offload mode and to configure the various trigger.
- We have offload triggers that are used to expose to userspace the
  supported offload triggers and set the offload mode on trigger
  activation.
- The LED driver will declare each supported trigger and each supported
  offloaded trigger and communicate it to the trigger that will expose them
  via sysfs.
- Only supported triggers from linux,supported-offload-triggers will be
  exposed by the offload trigger to userspace via sysfs. Other won't be
  configurable as they are not supported by the LED driver.
- The LED driver will set how the Offload mode is activated/disabled and
  will set a configure function to set each supported offload triggers.
  This function provide 3 different mode enable/disable/read that
  will enable or disable the offload trigger or read the current status.
- On offload trigger activation, only the offload mode is triggered but
  the offload triggers are not configured. This means that the LED will
  run in offload mode but will have the default rules/event set by the
  device by default. To change this the user will have to operate via
  userspace (or we can consider adding another binding in the dts to
  declare also a default trigger configuration)

Each LED driver will have to declare explicit support for the offload
trigger (or return not supported error code) as we pass a u32 flag that
the LED driver will elaborate and understand what is referring to (based
on the current active trigger).

I posted a user for this new implementation that will benefit from this
and will add a big feature to it. Currently qca8k can have up to 3 LEDs
connected to each PHY port and we have some device that have only one of
them connected and the default configuration won't work for that.

v2:
- Fix spelling mistake (sorry)
- Drop patch 02 "permit to declare supported offload triggers".
  Change the logic, now the LED driver declare support for them
  using the configure_offload with the cmd TRIGGER_SUPPORTED.
- Rework code to follow this new implementation.
- Update Documentation to better describe how this offload
  implementation work.

Ansuel Smith (4):
  leds: add function to configure offload leds
  leds: trigger: add offload-phy-activity trigger
  net: dsa: qca8k: add LEDs support
  dt-bindings: net: dsa: qca8k: add LEDs definition example

Marek Behún (1):
  leds: trigger: add API for HW offloading of triggers

 .../devicetree/bindings/net/dsa/qca8k.yaml    |  20 +
 Documentation/leds/leds-class.rst             |  44 +++
 drivers/leds/led-triggers.c                   |   1 +
 drivers/leds/trigger/Kconfig                  |  39 ++
 drivers/leds/trigger/Makefile                 |   1 +
 .../trigger/ledtrig-offload-phy-activity.c    | 145 +++++++
 drivers/net/dsa/Kconfig                       |   9 +
 drivers/net/dsa/Makefile                      |   1 +
 drivers/net/dsa/qca8k-leds.c                  | 364 ++++++++++++++++++
 drivers/net/dsa/qca8k.c                       |   8 +-
 drivers/net/dsa/qca8k.h                       |  64 +++
 include/linux/leds.h                          |  85 ++++
 12 files changed, 779 insertions(+), 2 deletions(-)
 create mode 100644 drivers/leds/trigger/ledtrig-offload-phy-activity.c
 create mode 100644 drivers/net/dsa/qca8k-leds.c

-- 
2.32.0


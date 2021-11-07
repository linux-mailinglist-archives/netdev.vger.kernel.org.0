Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53B7B4474BA
	for <lists+netdev@lfdr.de>; Sun,  7 Nov 2021 18:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236028AbhKGSAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Nov 2021 13:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229892AbhKGSAi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Nov 2021 13:00:38 -0500
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E9BFC061570;
        Sun,  7 Nov 2021 09:57:55 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id j21so53219108edt.11;
        Sun, 07 Nov 2021 09:57:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G3mP+YGCKggx5500tPqrkylkPVd3AA/X5efbd8Pm5Nw=;
        b=SyHl0gwgU95wsCHTnLovgxpELT1b3PqbDEhf8R3eZwkrdu1up6nbtnW1YLipKhlq6r
         pKFm0xwS4VML6UzPMwWE+nm7EPESD7C05V3sC7kjgHYsyUWCp+eTTXThcOgdG9XTZ/V9
         AnNbHxznINp6SdUFV1oRg5A6K4Rh7nTUZEejWaCDJrH4kyXpV80QGg77uCWeAiLFBTqM
         XiXv5Z4o0lkCZXV43Ux/w9kZWHYzaw7OVyji64mNxw8mphMoNetnJojjrVg+mwaR3oMG
         2q5pVGEeA5e0R+RWU6a9bX70x6gxFCOhJ6V16hLbme+XXj88mjL/7b5mbs598vboY2zk
         QX7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G3mP+YGCKggx5500tPqrkylkPVd3AA/X5efbd8Pm5Nw=;
        b=A1i1dM9zT2hqqAJCyWTznxoKjL5TAS+5MCeu224sVh+EyZjwZVG07YvVDsoBeboSlb
         sNH5kDxP3wA1QA8iasoOVo5C9rfIzr88VXYe9epzoWIc3/YYvcm0QWnhDcpSDrN8Tk53
         Kb/3SzBe556ojGPuic5R4s9r+ww4sR71epUy7bqcems7cSOkWyHzXFAuvWE+wghvvsxO
         w7FThhzZkaEbgqCgUfeGv3y7ZTHHqUas3MfbG8uGtKNOl8yYuhRrcPreBSEGqkdcNnMe
         Ll/NL12z/lnhKgGhee4/RH1KuAKI+SyrLJVRCrNLlQ4TMvkoPMiNnaQJGxRlQq8U9qYF
         U9Dw==
X-Gm-Message-State: AOAM531fYvUCW/yOpmfWSyaxQfMi0P0y3JiPzrDrNdZruncaNqJzUt9k
        b8JnMpJGuO2yg64vyTiw5r8=
X-Google-Smtp-Source: ABdhPJwGnCFgCDfYf7IlSKqxXlPtNxWC4nZUCINPgI+YnYhCjxKqXLgfb+3NUXiusHfk0YxY37lOsA==
X-Received: by 2002:a17:906:1599:: with SMTP id k25mr34857609ejd.298.1636307873408;
        Sun, 07 Nov 2021 09:57:53 -0800 (PST)
Received: from Ansuel-xps.localdomain (93-42-71-246.ip85.fastwebnet.it. [93.42.71.246])
        by smtp.googlemail.com with ESMTPSA id m11sm4251182edd.58.2021.11.07.09.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Nov 2021 09:57:53 -0800 (PST)
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
Subject: [RFC PATCH 0/6] Adds support for PHY LEDs with offload triggers
Date:   Sun,  7 Nov 2021 18:57:12 +0100
Message-Id: <20211107175718.9151-1-ansuelsmth@gmail.com>
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
- The PHY will declare the supported offload triggers using the
  linux,supported-offload-triggers binding in the dts.
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

Ansuel Smith (5):
  leds: permit to declare supported offload triggers
  leds: add function to configure offload leds
  leds: trigger: add offload-phy-activity trigger
  net: dsa: qca8k: add LEDs support
  dt-bindings: net: dsa: qca8k: add LEDs definition example

Marek Behún (1):
  leds: trigger: add API for HW offloading of triggers

 .../devicetree/bindings/net/dsa/qca8k.yaml    |  30 ++
 Documentation/leds/leds-class.rst             |  38 ++
 drivers/leds/led-class.c                      |  15 +-
 drivers/leds/led-triggers.c                   |   1 +
 drivers/leds/trigger/Kconfig                  |  35 ++
 drivers/leds/trigger/Makefile                 |   1 +
 .../trigger/ledtrig-offload-phy-activity.c    | 151 ++++++++
 drivers/net/dsa/Kconfig                       |   9 +
 drivers/net/dsa/Makefile                      |   1 +
 drivers/net/dsa/qca8k-leds.c                  | 361 ++++++++++++++++++
 drivers/net/dsa/qca8k.c                       |   4 +-
 drivers/net/dsa/qca8k.h                       |  64 ++++
 include/linux/leds.h                          |  76 ++++
 13 files changed, 783 insertions(+), 3 deletions(-)
 create mode 100644 drivers/leds/trigger/ledtrig-offload-phy-activity.c
 create mode 100644 drivers/net/dsa/qca8k-leds.c

-- 
2.32.0


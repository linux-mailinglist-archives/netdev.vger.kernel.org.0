Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34B156EFE4F
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242725AbjD0AS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239435AbjD0AS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:18:56 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F22262101;
        Wed, 26 Apr 2023 17:18:54 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id 5b1f17b1804b1-3f086770a50so52615785e9.2;
        Wed, 26 Apr 2023 17:18:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682554733; x=1685146733;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=mSvwzY2UlZlmB3HYmCg+9GgEn9N6fP96TrWBJYvA1GY=;
        b=oWX3zrV+c9w918yqvuiLWLGHRlWgHIbYGlmgRhWJEV1K5yOlaH68MFJyb7rhw4LQV4
         vnaG42/xjTrjJqvqnFiIImzpBozQsKfZJVSanM11hkgZqUIj4vdlN0vBmMPF68iLhpWz
         fbebcqqBSKgdplsZ022gP+ABGGgP1hBqsT71UQ4i7ofqS6KwPXddlvMnb5FwWvFHgIb6
         BBaWZpZqifUFBWAHY6BviWnX4DyEMZONMJKXOjLCpsigPZ/U5uNigPSdeR5yZ894+9qD
         GM8NTqCrLQ3rCgUAJEnaQ+Lbuq3ErHam8uwHaeRi39fGChbSfH80owsz5BPYgsbwwEGX
         WBuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682554733; x=1685146733;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mSvwzY2UlZlmB3HYmCg+9GgEn9N6fP96TrWBJYvA1GY=;
        b=VrtdqygOFbgYOJqe6STFh2btKYafwxIrXtBI3Xhf/2vF31HhmXu9uFL/m6KH4blzYF
         qKxY63IQmeh8f0SFxMuwgi1A7TFvmtYZxMl/oTzOmrIUUfwAelPwapMERl0HiS7r/nkl
         H4BPnGJQ0UwANkBX8PqiyPwQUq41F38s7fAtqqxKKkCXlCrm1oX3RoYQG5n/i53R0pfh
         RxjmevPViYKkWcBIpXevbWoAQdrEQN08tePvuGIjhcWwYEiO3tVqO6hItE3iNCU2th7v
         xWjdHu2QzGCmf0GHMjFCeRhP919LnvTlI6xbHnqMJidPbhCQOkoQSmPbCL8UDcdtAVOi
         Ddnw==
X-Gm-Message-State: AAQBX9eFe1ATWja7mtAxOXw8nyL/vHLX4/vx1ebHUq4FFHlNzKFXDS2q
        xKhrbUu95cgNGX5SwC8QXsZY4mQWgQE=
X-Google-Smtp-Source: AKy350aSmNWnTXa97z5pVcnWRXYztfHmrd1OsGs7y1DM145lmROIRumSTYrOHS7oM7fy4eG2e95sTQ==
X-Received: by 2002:a7b:c845:0:b0:3f1:9526:22be with SMTP id c5-20020a7bc845000000b003f1952622bemr12781700wml.23.1682554733112;
        Wed, 26 Apr 2023 17:18:53 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id r3-20020adfda43000000b003047ae72b14sm8624916wrl.82.2023.04.26.17.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 17:18:52 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        Lee Jones <lee@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 00/11] leds: introduce new LED hw control APIs
Date:   Thu, 27 Apr 2023 02:15:30 +0200
Message-Id: <20230427001541.18704-1-ansuelsmth@gmail.com>
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

This is the main part of the series, the one that actually implement the
hw control API.

Some history about this feature and why
=======================================

This proposal is highly requested by the entire net community but the API
is not strictly designed for net usage but for a more generic usage.

Initial version were very flexible and designed to try to support every
aspect of the LED driver with many complex function that served multiple
purpose. There was an idea to have sw only and hw only LEDs and sw only
and hw only LEDs.

With some heads up from Andrew from the net mailing list, it was suggested
to implement a more basic yet easy to implement system.

These API strictly work with a designated trigger to offload their
function.
This may be confused with hw blink offload but LED may have an even more
advanced configuration where the entire aspect of the trigger is
offloaded and completely handled by the hardware.

An example of this usage are PHY or switch port LEDs. Almost every of
these kind of device have multiple LED attached and provide info of the
current port state.

Currently we lack any support of them but these device always provide a
way to configure them, from basic feature like turning the LED off or no
(implemented in previous series related to this feature) or even entirely
driven by the hw and power on/off/blink based on some events, like tx/rx
traffic, ethernet cable attached, link speed of 10mbps, 100mbps, 1000mbps
or more. They can also support multiple logic like blink with traffic only
if a particular link speed is attached. (an example of this is when a LED
is designated to be turned on only with 100mbps link speed and configured
to blink on traffic and a secondary LED of a different color is present to
serve the same function but only when the link speed is 1000mbps)

These case are very common for a PHY or a switch but they were never
standardized so OEM support all kind of variant and configuration.

Again with Andrew we compared some feature and we reached a common set
of modes that are for sure present in every kind of devices.

And this concludes history and why.

What is present in this series
==============================

This patch contain the required API to support this feature, I decided on
the name of hw control to quickly describe this feature.

I documented each require API in the related Documentation for leds-class
so I think it might me redundant to expose them here. Feel free to tell me
how to improve it if anything is not clear.

On an abstract idea, this feature require this:

    - The trigger needs to make use of it, this is currently implemented
      for the netdev trigger but other trigger can be expanded if the
      device expose these function. An idea might be a anything that
      handle a storage disk and have the LED configurable to blink when
      there is any activity to the disk.

    - The LED driver needs to expose and implement these new API.

Currently a LED driver supports only a trigger. The trigger should use
the related helper to check if the LED can be driven hy hardware.

The different modes a trigger support are exposed in the kernel include
leds.h header and are used by the LED driver to understand what to do.

The LED driver expose a mask of the different modes supported and trigger
use this to validate the modes and decide what to enable.

From a user standpoint, he should enable modes as usual from sysfs and if
anything is not supported warned.

Final words and missing piece from this series
==============================================

I honestly hope this feature can finally be implemented.

This series originally had also additional modes and logic to add to the
netdev trigger, but I decided to strip them and implement only the API
and support basic tx and rx. After this is merged, I will quickly propose
these additional modes.

Currently this is limited to tx and rx and this is what the current user
qca8k use. Marvell PHY support link and a generic blink with any kind of
traffic (both rx and tx). qca8k switch supports keeping the LED on based on
link speed.

The next series will add the concept of hw control only modes to the netdev
trigger and support for these additional modes:
- link_10
- link_100
- link_1000
- activity

The current implementation is voluntary basic and limited to put the ground
work and have something easy to implement and usable. 99% part of the logic
is done on the trigger side, leaving to the LED driver only the validating
and the apply part.

As shown for the PHY led binding, people are really intrested in this
feature as quickly after they were merged, people were already working on
adding support for it.

[1] https://lore.kernel.org/lkml/20230216013230.22978-1-ansuelsmth@gmail.com/

Changes from previous v8 series:
- Rewrite Documentation from scratch and move to separate commit
- Strip additional trigger modes (to propose in a different series)
- Strip from qca8k driver additional modes (to implement in the different
  series)
- Split the netdev chages to smaller piece to permit easier review

Changelog in the previous v8 series: (stripped of unrelated changes)
v8:
- Improve the documentation of the new feature
- Rename to a more symbolic name
- Fix some bug in netdev trigger (not using BIT())
- Add more define for qca8k-leds driver
- Drop interval support
- Fix many bugs in the validate option in the netdev trigger
v7:
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
v3:
- Rework start/stop as Andrew asked.
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
  leds: add binding for LEDs hw control
  leds: add binding to check support for LED hw control
  leds: add helper function to use trigger in hw blink mode
  Documentation: leds: leds-class: Document new Hardware driven LEDs
    APIs
  leds: trigger: netdev: introduce validating requested mode
  leds: trigger: netdev: add knob to set hw control possible
  leds: trigger: netdev: reject interval and device store for hw_control
  leds: trigger: netdev: add support for LED hw control
  leds: trigger: netdev: init mode if hw control already active
  leds: trigger: netdev: expose netdev trigger modes in linux include
  net: dsa: qca8k: implement hw_control ops

 Documentation/leds/leds-class.rst     |  56 +++++++++
 drivers/leds/trigger/ledtrig-netdev.c | 111 +++++++++++++++---
 drivers/net/dsa/qca/qca8k-leds.c      | 156 ++++++++++++++++++++++++++
 include/linux/leds.h                  |  46 ++++++++
 4 files changed, 355 insertions(+), 14 deletions(-)

-- 
2.39.2


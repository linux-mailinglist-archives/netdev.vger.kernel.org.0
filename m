Return-Path: <netdev+bounces-6140-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A551714E55
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 18:34:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B50E81C20A98
	for <lists+netdev@lfdr.de>; Mon, 29 May 2023 16:34:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59227746E;
	Mon, 29 May 2023 16:34:46 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F4F33ED
	for <netdev@vger.kernel.org>; Mon, 29 May 2023 16:34:46 +0000 (UTC)
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC92AA3;
	Mon, 29 May 2023 09:34:43 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id ffacd0b85a97d-30adc51b65cso2949528f8f.0;
        Mon, 29 May 2023 09:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685378082; x=1687970082;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=+Am7a+wHpKOk5OFsVXHSbIdYxX/usU5ka2WcWHanWfY=;
        b=p79/40Kapo6QxF5CduIHkyC0FZ53pa9VC7iQ9G1QkBIMcPLAd584GVjVHgKK8S+5+L
         YB7VSHpb7dkgrRq+c5W1bUUt6Q7VTmGB5W6BrXQ94I6jAIXYjglHCnmwrIolwk3jFGUM
         hbyJ6F+kuXdyRDN56cvVcuM9WNnzxKzllRYnDeRcwq2tP+pSy28sgBXvOuh9bbnq5MaI
         opMPhNvjIyogOdjYmGknlVHqsNeh5aJZFzKSP8z2EKjfVMBBXiNwwMrXqzSv8ddCaxPQ
         ZnvR7IsydTdTaMOsc+aY94SKP0JOhvxkHRYXQQzRKqIXMuKDUQJ+XBcqY/kbnSVAUQ2u
         NcgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685378082; x=1687970082;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+Am7a+wHpKOk5OFsVXHSbIdYxX/usU5ka2WcWHanWfY=;
        b=ffULgZh7ieoucPlEFOxk/D41JIrlITybQ+RuDiouPyu7eteI5s8cpgyzV6uPxdUD3N
         pnQL0EeKpCQP7BIkbRcG9dVsMijkYhan4nwWcEf/4B03AVr7mwPyh6HtzbwFW1lmjjji
         k2SOB5XLeW15ClenwFbVOLisala8ZrxD+In3us9p85H+mcsCI/9+LaXL6Dg458dxqcoe
         y1quQDVp0vv22Pf4UJzDMgDgdI9ylz7C+n2FPtHFw+G07F1BA8d0u7yFf1hPPxuFhJ9v
         VUiZvSshecl35QtMKpAvdRivGjNyMiQvO93Dpf7fE4U8V9O9YMJ/Zb8asukrLkMzuMzc
         zRAw==
X-Gm-Message-State: AC+VfDymkag8bztpOPzocWw3xdoJLgsf1chUoJcyMks0cmX51a4TR12M
	UKcVdKiCurXt0e4z29Kk8hU=
X-Google-Smtp-Source: ACHHUZ6/WS/6kZOzkv4UzsJ3M6WllL3tEiAhFwz7zYSfQIa7/P0DEvAlQ9klHZwt0SUVHo22U1ykTQ==
X-Received: by 2002:a05:6000:1009:b0:30a:f0f0:1277 with SMTP id a9-20020a056000100900b0030af0f01277mr1235670wrx.2.1685378081972;
        Mon, 29 May 2023 09:34:41 -0700 (PDT)
Received: from localhost.localdomain (93-34-93-173.ip49.fastwebnet.it. [93.34.93.173])
        by smtp.googlemail.com with ESMTPSA id h14-20020a5d6e0e000000b002ff2c39d072sm417513wrz.104.2023.05.29.09.34.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 May 2023 09:34:41 -0700 (PDT)
From: Christian Marangi <ansuelsmth@gmail.com>
To: Pavel Machek <pavel@ucw.cz>,
	Lee Jones <lee@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Andrew Lunn <andrew@lunn.ch>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	linux-leds@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [net-next PATCH v4 00/13] leds: introduce new LED hw control APIs
Date: Mon, 29 May 2023 18:32:30 +0200
Message-Id: <20230529163243.9555-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Since this series is cross subsystem between LED and netdev,
a stable branch was created to facilitate merging process.

This is based on top of branch ib-leds-netdev-v6.5 present here [1]
and rebased on top of net-next since the LED stable branch got merged.

This is a continue of [2]. It was decided to take a more gradual
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

[1] https://git.kernel.org/pub/scm/linux/kernel/git/lee/leds.git/?h=ib-leds-netdev-6.5
[2] https://lore.kernel.org/lkml/20230216013230.22978-1-ansuelsmth@gmail.com/

Changes in v4:
- Added review tag from Andrew.
- Move default interval to a define to keep them synced.
- Apply suggested reword to improve Documentation rst.

Changes in v3:
- Rebased on top of net-next

Changes in v2:
- Drop helper as currently used only by one trigger
- Improve Documentation and document return error of some functions
- Squash some patch to reduce series size
- Drop trigger mode mask as currently not used
- Rework hw control validating function to a simple implementation

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

Andrew Lunn (4):
  leds: add API to get attached device for LED hw control
  leds: trigger: netdev: refactor code setting device name
  leds: trigger: netdev: validate configured netdev
  net: dsa: qca8k: add op to get ports netdev

Christian Marangi (9):
  leds: add APIs for LEDs hw control
  Documentation: leds: leds-class: Document new Hardware driven LEDs
    APIs
  leds: trigger: netdev: introduce check for possible hw control
  leds: trigger: netdev: add basic check for hw control support
  leds: trigger: netdev: reject interval store for hw_control
  leds: trigger: netdev: add support for LED hw control
  leds: trigger: netdev: init mode if hw control already active
  leds: trigger: netdev: expose netdev trigger modes in linux include
  net: dsa: qca8k: implement hw_control ops

 Documentation/leds/leds-class.rst     |  81 ++++++++++++
 drivers/leds/trigger/ledtrig-netdev.c | 141 +++++++++++++++++---
 drivers/net/dsa/qca/qca8k-leds.c      | 181 ++++++++++++++++++++++++++
 include/linux/leds.h                  |  53 ++++++++
 4 files changed, 437 insertions(+), 19 deletions(-)

-- 
2.39.2



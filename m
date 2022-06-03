Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A451053C8B5
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 12:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243665AbiFCK3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 06:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242361AbiFCK3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 06:29:19 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8692039B9B;
        Fri,  3 Jun 2022 03:29:14 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h1so6532612plf.11;
        Fri, 03 Jun 2022 03:29:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=DyUnKTbTTrTWWAesVwMk9Kzfanf/SKg/urvB+fwSQxU=;
        b=FAWRZP+fkRGsTr8WtBVZFuHEiXDG4JbT0tVUeZbAcQWw1VRnr8HeRfvjZkEKtVfiuU
         B9EelOHGUuTZD9hQRxvFO4UQR8wpp/tkRp7bKt91CrzOfoKBjB1+kCwHcH4bwOdh3QqP
         gZ0sryGjljjuPg6PHXbXiQdxyWHIELG3Rm+2rxANb9ntLPVn8lsSys77rohsbhigJU6O
         0vknCmcZkKyffz8m13hpLci3hHjIJyagdoS8kV82IAT2gCRLbaXFRROGCzLdTm1asgQ4
         G80mBrR0YcnyOhxbyGuhpVj6i63/8dbBCh2Qk38bQu8fgqxPtk4EaJJRqMeZMgeNu44L
         H7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=DyUnKTbTTrTWWAesVwMk9Kzfanf/SKg/urvB+fwSQxU=;
        b=KZaFNGRw0dwuiQIO4r9dk88EqCi9o07G9i8QGIUWojmNeyNtWrXVgX3APGt9ZE7bOU
         UbiR+UrPSIFXFoVPGMpeC67pYtmoPDv2fzyd4Ae8pFK+XydI8crpxG/UWUnzJPjE+/ix
         ubKqu6NUETj+ru/SASXT9BzEbGphVLn9rJU07YFenGSr4m/tS/3/GG0VddZvzMa+1Wqd
         FBs17qSuKuJ6EocGArlooP9Q0z8z484IlCT18zQDv/a1KH/SqEJELvAdgFipcVSJmTMm
         K2TrUmhQGrQArefvwy+bB8Ht9ldKsI3+OmHnb6tGo0f8j8/4udCFu9BdzAP5B4PvJQDG
         CiNg==
X-Gm-Message-State: AOAM530jxXCFBokAqKAgp7EWRIIv/jOKeAkXRboRTTTdg178N5HBnhyV
        T9YtK1L8q1H1qkPDg3A1sjoM16HyxEwA4Q==
X-Google-Smtp-Source: ABdhPJzvvPXr+/x2lkMW2FxqthqRIfPAqNmEN8ZSaf/pXZ6FBC0YpPHyz1ypSjwtuWaT6bqr+BijqQ==
X-Received: by 2002:a17:90a:eb17:b0:1e2:f569:6b60 with SMTP id j23-20020a17090aeb1700b001e2f5696b60mr10416973pjz.48.1654252154124;
        Fri, 03 Jun 2022 03:29:14 -0700 (PDT)
Received: from localhost.localdomain (124x33x176x97.ap124.ftth.ucom.ne.jp. [124.33.176.97])
        by smtp.gmail.com with ESMTPSA id b22-20020a056a0002d600b0050dc7628182sm3041676pft.92.2022.06.03.03.29.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 03:29:13 -0700 (PDT)
Sender: Vincent Mailhol <vincent.mailhol@gmail.com>
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: [PATCH v4 0/7] can: refactoring of can-dev module and of Kbuild
Date:   Fri,  3 Jun 2022 19:28:41 +0900
Message-Id: <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Aside of calc_bittiming.o which can be configured with
CAN_CALC_BITTIMING, all objects from drivers/net/can/dev/ get linked
unconditionally to can-dev.o even if not needed by the user.

This series first goal it to split the can-dev modules so that the
user can decide which features get built in during
compilation. Additionally, the CAN Device Drivers menu is moved from
the "Networking support" category to the "Device Drivers" category
(where all drivers are supposed to be).

Below diagrams illustrate the changes made.
The arrow symbol "x --> y" denotes that "y depends on x".

* menu before this series *

CAN bus subsystem support
  symbol: CONFIG_CAN
  |
  +-> CAN Device Drivers
      (no symbol)
      |
      +-> software/virtual CAN device drivers
      |   (at time of writing: slcan, vcan, vxcan)
      |
      +-> Platform CAN drivers with Netlink support
          symbol: CONFIG_CAN_DEV
	  |
          +-> CAN bit-timing calculation  (optional for hardware drivers)
          |   symbol: CONFIG_CAN_BITTIMING
	  |
	  +-> All other CAN devices

* menu after this series *

Network device support
  symbol: CONFIG_NETDEVICES
  |
  +-> CAN Device Drivers
      symbol: CONFIG_CAN_DEV
      |
      +-> software/virtual CAN device drivers
      |   (at time of writing: slcan, vcan, vxcan)
      |
      +-> CAN device drivers with Netlink support
          symbol: CONFIG_CAN_NETLINK (matches previous CONFIG_CAN_DEV)
          |
          +-> CAN bit-timing calculation (optional for all drivers)
          |   symbol: CONFIG_CAN_BITTIMING
	  |
	  +-> All other CAN devices not relying on RX offload
          |
          +-> CAN rx offload
              symbol: CONFIG_CAN_RX_OFFLOAD
              |
              +-> CAN devices relying on rx offload
                  (at time of writing: flexcan, ti_hecc and mcp251xfd)

Patches 1 to 5 of this series do above modification.

The last two patches add a check toward CAN_CTRLMODE_LISTENONLY in
can_dropped_invalid_skb() to discard tx skb (such skb can potentially
reach the driver if injected via the packet socket). In more details,
patch 6 moves can_dropped_invalid_skb() from skb.h to skb.o and patch
7 is the actual change.

Those last two patches are actually connected to the first five ones:
because slcan and v(x)can requires can_dropped_invalid_skb(), it was
necessary to add those three devices to the scope of can-dev before
moving the function to skb.o.


** N.B. **

This design results from the lengthy discussion in [1].

I did one change from Oliver's suggestions in [2]. The initial idea
was that the first two config symbols should be respectively
CAN_DEV_SW and CAN_DEV instead of CAN_DEV and CAN_NETLINK as proposed
in this series.

  * First symbol is changed from CAN_DEV_SW to CAN_DEV. The rationale
    is that it is this entry that will trigger the build of can-dev.o
    and it makes more sense for me to name the symbol share the same
    name as the module. Furthermore, this allows to create a menuentry
    with an explicit name that will cover both the virtual and
    physical devices (naming the menuentry "CAN Device Software" would
    be inconsistent with the fact that physical devices would also be
    present in a sub menu). And not using menuentry complexifies the
    menu.

  * Second symbol is renamed from CAN_DEV to CAN_NETLINK because
    CAN_DEV is now taken by the previous menuconfig and netlink is the
    predominant feature added at this level. I am opened to other
    naming suggestion (CAN_DEV_NETLINK, CAN_DEV_HW...?).

[1] https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vincent@wanadoo.fr/
[2] https://lore.kernel.org/linux-can/22590a57-c7c6-39c6-06d5-11c6e4e1534b@hartkopp.net/


** Changelog **

v3 -> v4:

  * Five additional patches added to split can-dev module and refactor
    Kbuild. c.f. below (lengthy) thread:
    https://lore.kernel.org/linux-can/20220514141650.1109542-1-mailhol.vincent@wanadoo.fr/


v2 -> v3:

  * Apply can_dropped_invalid_skb() to slcan.

  * Make vcan, vxcan and slcan dependent of CONFIG_CAN_DEV by
    modifying Kbuild.

  * fix small typos.

v1 -> v2:

  * move can_dropped_invalid_skb() to skb.c instead of dev.h

  * also move can_skb_headroom_valid() to skb.c

Vincent Mailhol (7):
  can: Kbuild: rename config symbol CAN_DEV into CAN_NETLINK
  can: Kconfig: turn menu "CAN Device Drivers" into a menuconfig using
    CAN_DEV
  can: bittiming: move bittiming calculation functions to
    calc_bittiming.c
  can: Kconfig: add CONFIG_CAN_RX_OFFLOAD
  net: Kconfig: move the CAN device menu to the "Device Drivers" section
  can: skb: move can_dropped_invalid_skb() and can_skb_headroom_valid()
    to skb.c
  can: skb: drop tx skb if in listen only mode

 drivers/net/Kconfig                   |   2 +
 drivers/net/can/Kconfig               |  66 +++++++--
 drivers/net/can/dev/Makefile          |  20 ++-
 drivers/net/can/dev/bittiming.c       | 197 -------------------------
 drivers/net/can/dev/calc_bittiming.c  | 202 ++++++++++++++++++++++++++
 drivers/net/can/dev/dev.c             |   9 +-
 drivers/net/can/dev/skb.c             |  72 +++++++++
 drivers/net/can/spi/mcp251xfd/Kconfig |   1 +
 include/linux/can/skb.h               |  59 +-------
 net/can/Kconfig                       |   5 +-
 10 files changed, 351 insertions(+), 282 deletions(-)
 create mode 100644 drivers/net/can/dev/calc_bittiming.c

-- 
2.35.1


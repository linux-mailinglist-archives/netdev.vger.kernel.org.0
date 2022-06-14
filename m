Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4E3E54B12C
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 14:38:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243561AbiFNM3l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 08:29:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243061AbiFNM2f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 08:28:35 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4ED423BC7
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:26 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id me5so16890420ejb.2
        for <netdev@vger.kernel.org>; Tue, 14 Jun 2022 05:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bhHRX/oRi5clzdn2dE/EY8/wgTCSEE9g8vSH+WhoX2I=;
        b=fXAyHR6wYOrAjEoa121kXDAMBiQuKOeHTZzLKSajLlgrarAw/anKuBKZGX+sWqZhKc
         u0w23AieZe9pPny/F0Sg5T27H2I61hCiOjE4KfV1SHvON11Iirp/kVren2/7s6BTdpDX
         s0GckUugcWpBj6AlHsAHWQpbmQ9EPo0wjK7+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bhHRX/oRi5clzdn2dE/EY8/wgTCSEE9g8vSH+WhoX2I=;
        b=bUtT3irG/jp3QIUBJNcppHcd2C+dInthe1t90oDYx97OD9p6adiCZ3vQIYhtTTbo37
         Tyf0J/hAwbYs12Xq1tkS1XVLzJ9QYaFmA8kKUnTcEV7fKz/2Eyu4fVwgdJc7eTQVEv0z
         5mVsno++N+RR8CXCsmX+H3T2Or7SXak+TVrXp77h+Wahmd/CNTaFnOvLyEyu9CruNnHc
         T1qyw2LF82wK5YqqJATMDiwUviFIUu/wzDiu0ajs1iOHi9/00iMi0G1mDwmv8+P+L5Na
         W6PlEeKYeqBsQ3p6dkhSEcQ/YXXMsfgb4fy+fGJcNPJ4rkClh6jeOfppnNKLmavIqbgh
         r8WA==
X-Gm-Message-State: AOAM531xXT61CjAzZ2U/kdSYVhb1426lfp8IHuODQFTgnheUvuvJYCCK
        R+C0qLgGMPFstMtFWkSI8xGJ5A==
X-Google-Smtp-Source: ABdhPJy4pF7H8NgtPphY1WJTnN9t4SyQU2HyYAAQHT08cCgUQ2lc4xy7jniRTEaogLds279Um4nTuQ==
X-Received: by 2002:a17:906:6a27:b0:708:1282:cbe9 with SMTP id qw39-20020a1709066a2700b007081282cbe9mr4290023ejc.186.1655209705333;
        Tue, 14 Jun 2022 05:28:25 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.amarulasolutions.com (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id z22-20020a17090655d600b006f3ef214e2csm5087043ejp.146.2022.06.14.05.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:28:24 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Dario Binacchi <dario.binacchi@amarulasolutions.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Slaby <jirislaby@kernel.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Paolo Abeni <pabeni@redhat.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH v4 00/12] can: slcan: extend supported features
Date:   Tue, 14 Jun 2022 14:28:09 +0200
Message-Id: <20220614122821.3646071-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series originated as a result of CAN communication tests for an
application using the USBtin adapter (https://www.fischl.de/usbtin/).
The tests showed some errors but for the driver everything was ok.
Also, being the first time I used the slcan driver, I was amazed that
it was not possible to configure the bitrate via the ip tool.
For these two reasons, I started looking at the driver code and realized
that it didn't use the CAN network device driver interface.

Starting from these assumptions, I tried to:
- Use the CAN network device driver interface.
- Set the bitrate via the ip tool.
- Send the open/close command to the adapter from the driver.
- Add ethtool support to reset the adapter errors.
- Extend the protocol to forward the adapter CAN communication
  errors and the CAN state changes to the netdev upper layers.

Except for the protocol extension patches (i. e. forward the adapter CAN
communication errors and the CAN state changes to the netdev upper
layers), the whole series has been tested under QEMU with Linux 4.19.208
using the USBtin adapter.
Testing the extension protocol patches requires updating the adapter
firmware. Before modifying the firmware I think it makes sense to know if
these extensions can be considered useful.

Before applying the series I used these commands:

slcan_attach -f -s6 -o /dev/ttyACM0
slcand ttyACM0 can0
ip link set can0 up

After applying the series I am using these commands:

slcan_attach /dev/ttyACM0
slcand ttyACM0 can0
ip link set dev can0 down
ip link set can0 type can bitrate 500000
ethtool --set-priv-flags can0 err-rst-on-open on
ip link set dev can0 up

Now there is a clearer separation between serial line and CAN,
but above all, it is possible to use the ip and ethtool commands
as it happens for any CAN device driver. The changes are backward
compatible, you can continue to use the slcand and slcan_attach
command options.


Changes in v4:
- Move the patch in front of the patch "[v3,04/13] can: slcan: use CAN network device driver API".
- Add the CAN_BITRATE_UNSET (0) and CAN_BITRATE_UNKNOWN (-1U) macros.
- Simplify the bitrate check to dump it.
- Update the commit description.
- Update the commit description.
- Use the CAN_BITRATE_UNKNOWN macro.
- Use kfree_skb() instead of can_put_echo_skb() in the slc_xmit().
- Remove the `if (slcan_devs)' check in the slc_dealloc().
- Replace `sl->tty == NULL' with `!sl->tty'.
- Use CAN_BITRATE_UNSET (0) and CAN_BITRATE_UNKNOWN (-1U) macros.
- Don't reset the bitrate in ndo_stop() if it has been configured.
- Squashed to the patch [v3,09/13] can: slcan: send the close command to the adapter.
- Use the CAN_BITRATE_UNKNOWN macro.
- Add description of slc_bump_err() function.
- Remove check for the 'e' character at the beggining of the function.
  It was already checked by the caller function.
- Protect decoding against the case the len value is longer than the
  received data.
- Some small changes to make the decoding more readable.
- Increment all the error counters at the end of the function.
- Add description of slc_bump_state() function.
- Remove check for the 's' character at the beggining of the function.
  It was already checked by the caller function.
- Protect decoding against the case the frame len is longer than the
  received data (add SLC_STATE_FRAME_LEN macro).
- Set cf to NULL in case of alloc_can_err_skb() failure.
- Some small changes to make the decoding more readable.
- Use the character 'b' instead of 'f' for bus-off state.

Changes in v3:
- Increment the error counter in case of decoding failure.
- Replace (-1) with (-1U) in the commit description.
- Update the commit description.
- Remove the slc_do_set_bittiming().
- Set the bitrate in the ndo_open().
- Replace -1UL with -1U in setting a fake value for the bitrate.
- Drop the patch "can: slcan: simplify the device de-allocation".
- Add the patch "can: netlink: dump bitrate 0 if can_priv::bittiming.bitrate is -1U".

Changes in v2:
- Put the data into the allocated skb directly instead of first
  filling the "cf" on the stack and then doing a memcpy().
- Move CAN_SLCAN Kconfig option inside CAN_DEV scope.
- Improve the commit message.
- Use the CAN framework support for setting fixed bit rates.
- Improve the commit message.
- Protect decoding against the case the len value is longer than the
  received data.
- Continue error handling even if no skb can be allocated.
- Continue error handling even if no skb can be allocated.

Dario Binacchi (12):
  can: slcan: use the BIT() helper
  can: slcan: use netdev helpers to print out messages
  can: slcan: use the alloc_can_skb() helper
  can: netlink: dump bitrate 0 if can_priv::bittiming.bitrate is -1U
  can: slcan: use CAN network device driver API
  can: slcan: allow to send commands to the adapter
  can: slcan: set bitrate by CAN device driver API
  can: slcan: send the open/close commands to the adapter
  can: slcan: move driver into separate sub directory
  can: slcan: add ethtool support to reset adapter errors
  can: slcan: extend the protocol with error info
  can: slcan: extend the protocol with CAN state info

 drivers/net/can/Kconfig                       |  40 +-
 drivers/net/can/Makefile                      |   2 +-
 drivers/net/can/dev/netlink.c                 |   3 +-
 drivers/net/can/slcan/Makefile                |   7 +
 .../net/can/{slcan.c => slcan/slcan-core.c}   | 527 ++++++++++++++----
 drivers/net/can/slcan/slcan-ethtool.c         |  65 +++
 drivers/net/can/slcan/slcan.h                 |  18 +
 include/linux/can/bittiming.h                 |   2 +
 8 files changed, 549 insertions(+), 115 deletions(-)
 create mode 100644 drivers/net/can/slcan/Makefile
 rename drivers/net/can/{slcan.c => slcan/slcan-core.c} (64%)
 create mode 100644 drivers/net/can/slcan/slcan-ethtool.c
 create mode 100644 drivers/net/can/slcan/slcan.h

-- 
2.32.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A04055E9E3
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 18:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238372AbiF1Qfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 12:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235933AbiF1Qen (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 12:34:43 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ECA73151C
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:49 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id pk21so26957917ejb.2
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 09:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bul38R93x//KNOyQi8klG2NZQTS/GpM9te9tWvCtSxw=;
        b=aZfzn3sb8w/YS2hcLL2B4c0d715KalCFCH+F93LNVlFdmDLTNzG+PshqN6U+C9fMmY
         XGRmmbuBnh2cl2ZFTI1l6ZyXZbnAdDwCi0gKOr3MZAd/gdZYyB5eDmWj0YgvJXJ7aUY3
         wsYAr0TZDzid3K3wzsibEtXlJRNIM7rRs5nF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bul38R93x//KNOyQi8klG2NZQTS/GpM9te9tWvCtSxw=;
        b=ck8yA60EzjKXqTIZmdkg0+aDvFKaAPiTbgG3Cf1ANO6tdBqjhUjdXgWJxG4NfoVcfZ
         Pwtufv8ivV4/Q7tU/1AeVnKaBKgST2uTJ9RKO67KeXZ+CDS/4ehCzc6kk+zXTf23KJcH
         7SHHTwCauuEq7pKA7Xt7SFfBLnLw1tUp6aneUgyUcjszB4lgsC2TuF45XIfnI4gmoXO6
         iDVzU2E8uddXRGiUBfK9otGORL4t2lFSaKXk9maDY7UaZIEl7I4BOhsumD2luDjpyWnt
         VSnU+fWqyJJxJn/VT3sH4XNUA+MKEkwgcMQcUch1ufzFfSqgEMH0ATjBeXroKoav8nnw
         bmDQ==
X-Gm-Message-State: AJIora+QUSm+TkYYSOJGkmpM2bjEHnwOKKauOoTiOoYjSKtirzCZ+tXk
        ZtgEcagOBg3RQ4rf007ZvqB/ZA==
X-Google-Smtp-Source: AGRyM1tHcXAjOHTgxJOkl0owaZUTlp2VvNesYHKFklptO0nkOnfG3bhhYHq3odMXDMlZjPpW2psiXg==
X-Received: by 2002:a17:907:1b14:b0:6ef:a5c8:afbd with SMTP id mp20-20020a1709071b1400b006efa5c8afbdmr18523050ejc.151.1656433907916;
        Tue, 28 Jun 2022 09:31:47 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id b20-20020a0564021f1400b0042e15364d14sm9916952edb.8.2022.06.28.09.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 09:31:47 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
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
Subject: [PATCH v5 00/12] can: slcan: extend supported features
Date:   Tue, 28 Jun 2022 18:31:24 +0200
Message-Id: <20220628163137.413025-1-dario.binacchi@amarulasolutions.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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


Changes in v5:
- Update the commit message.
- Restore the use of rtnl_lock() and rtnl_unlock().

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
 .../net/can/{slcan.c => slcan/slcan-core.c}   | 504 +++++++++++++++---
 drivers/net/can/slcan/slcan-ethtool.c         |  65 +++
 drivers/net/can/slcan/slcan.h                 |  18 +
 include/linux/can/bittiming.h                 |   2 +
 8 files changed, 536 insertions(+), 105 deletions(-)
 create mode 100644 drivers/net/can/slcan/Makefile
 rename drivers/net/can/{slcan.c => slcan/slcan-core.c} (65%)
 create mode 100644 drivers/net/can/slcan/slcan-ethtool.c
 create mode 100644 drivers/net/can/slcan/slcan.h

-- 
2.32.0


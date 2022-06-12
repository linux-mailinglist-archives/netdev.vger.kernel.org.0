Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 373AD547C84
	for <lists+netdev@lfdr.de>; Sun, 12 Jun 2022 23:39:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236425AbiFLVjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jun 2022 17:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236104AbiFLVjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Jun 2022 17:39:40 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BF0C18E28
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:39:39 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id o7so7729177eja.1
        for <netdev@vger.kernel.org>; Sun, 12 Jun 2022 14:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZyOL/5w2xsSU/Fg6Gmxyopr+VoCvVAaounzNIX8NZuw=;
        b=H0jOHpTEArc6aFV3dku0OMKVAUPHtxCcoGn0dSwOwoQ0At7I64G8hRrzwUSNktTRao
         Ooyt2OIk4bfaWETXqQl077knXU82vcVplP2dRiW/mOJWfGOM1015pTqzKGyxABKqjxRD
         uk3DbSfwtDdjPpxPMR7sPMLBZIeE4LKxTB2Qg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZyOL/5w2xsSU/Fg6Gmxyopr+VoCvVAaounzNIX8NZuw=;
        b=fyXsnRuoSd5H4Pc0JRe4Fv8KvhygcEZDIekXqdPLxIbN9PuRtMKlwTMTAJvo0OJN82
         BWwPsd5oiDsp6LPjVkEgaQo4pjFUhLllVU2Kn3bMoE6MSB3si/Snkft9AWDQhOAE+Y2h
         bMLyje9JlbeNjEheOOfYIPSRoIepiax4r2ZiZiOyYR10z+LLVYJOXX4acDe50DJfXVNt
         RGBD+oK0oZCqIteQQcwxyIaIJ7w8s8QOaeU4NuWi2wHID9QWP+xeKZYyBmKa39k4y135
         5C8lMm53ZNNlgJqm47PHO2LBfSgFgc102CqtyBwUI33bk1kUudpFQ7OF/GzKJA8V3sMf
         yeeA==
X-Gm-Message-State: AOAM533eLQpQnOc8nQPMTr7CfYjycOWkTZmRK0GTafM6h3Mmu+lGmFYJ
        KGWFBrnQHAs9hW6B5FMoOwx7GQ==
X-Google-Smtp-Source: ABdhPJwXzfhXp1V/nQIqocmiG3Ue9g+3FUfQkMXi7Tts8QAuV7jtyaxPcdKKO9JVvF3NrfOv3D0P3A==
X-Received: by 2002:a17:907:6d24:b0:70c:81d9:d5b9 with SMTP id sa36-20020a1709076d2400b0070c81d9d5b9mr45569744ejc.597.1655069977577;
        Sun, 12 Jun 2022 14:39:37 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id u10-20020a1709061daa00b00711d546f8a8sm2909398ejh.139.2022.06.12.14.39.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jun 2022 14:39:37 -0700 (PDT)
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
Subject: [PATCH v3 00/13] can: slcan: extend supported features
Date:   Sun, 12 Jun 2022 23:39:14 +0200
Message-Id: <20220612213927.3004444-1-dario.binacchi@amarulasolutions.com>
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
- Improve the commit message.
- Protect decoding against the case the len value is longer than the
  received data.
- Continue error handling even if no skb can be allocated.
- Continue error handling even if no skb can be allocated.

Dario Binacchi (13):
  can: slcan: use the BIT() helper
  can: slcan: use netdev helpers to print out messages
  can: slcan: use the alloc_can_skb() helper
  can: slcan: use CAN network device driver API
  can: netlink: dump bitrate 0 if can_priv::bittiming.bitrate is -1U
  can: slcan: allow to send commands to the adapter
  can: slcan: set bitrate by CAN device driver API
  can: slcan: send the open command to the adapter
  can: slcan: send the close command to the adapter
  can: slcan: move driver into separate sub directory
  can: slcan: add ethtool support to reset adapter errors
  can: slcan: extend the protocol with error info
  can: slcan: extend the protocol with CAN state info

 drivers/net/can/Kconfig                       |  40 +-
 drivers/net/can/Makefile                      |   2 +-
 drivers/net/can/dev/netlink.c                 |  12 +-
 drivers/net/can/slcan/Makefile                |   7 +
 .../net/can/{slcan.c => slcan/slcan-core.c}   | 518 ++++++++++++++----
 drivers/net/can/slcan/slcan-ethtool.c         |  65 +++
 drivers/net/can/slcan/slcan.h                 |  18 +
 7 files changed, 541 insertions(+), 121 deletions(-)
 create mode 100644 drivers/net/can/slcan/Makefile
 rename drivers/net/can/{slcan.c => slcan/slcan-core.c} (65%)
 create mode 100644 drivers/net/can/slcan/slcan-ethtool.c
 create mode 100644 drivers/net/can/slcan/slcan.h

-- 
2.32.0


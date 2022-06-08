Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AB185439BE
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 18:55:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231789AbiFHQyz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 12:54:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237331AbiFHQxR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 12:53:17 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B5753C6B22
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 09:51:25 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id m20so42554544ejj.10
        for <netdev@vger.kernel.org>; Wed, 08 Jun 2022 09:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amarulasolutions.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xYiKq2p8kde5xkKx+lFxNCjXxvmOUB4R02jax8DEbkQ=;
        b=cOcnVnvRoPE4wEsp18l0tLSX/XUtRRtnlFdZsIcm29DiJij9aKGDnwZdP8YZ0fEkpr
         6/uASQRuTcWHobz02/PViZ2yCnVlDok1iMUFXsQYo1Um1IaJyHxLU5aTpzXfS1NVYo5r
         GjH30VuPnJEWKvyKah7R2GM3f/fJ9NMucJT+o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xYiKq2p8kde5xkKx+lFxNCjXxvmOUB4R02jax8DEbkQ=;
        b=YjnEgDgMflEdQ7qcXdlQtVicHOD+gKeunqZ08mtab9bHTwCn4ypG2S9K7lOtEzm/Iy
         98orf1rxPaIGSmbMexPInbmpUYT4+QLhxg295+6pvKNdwBo1HiNW6qyi5f6+Zjg5K751
         jbxwPAYF5Gl2DPIEtwgGFE9F9/yzVRvEDdKnZPbMd9IF6LKeCkIG+/ymq/ZC4SCWjL+D
         TER0wsUoM7bfLCyxTuX0raDIt5Xy5B5+5UKiZNkdYn/1+dxHHJtwuVfkf9m/6kSwjL3C
         4M0k5ET47sU0MnksM8jqyPfSiigI1P6sHcMCD81IV8MKdL0B5M1NmGqzFibMJ5RIarPz
         KSWA==
X-Gm-Message-State: AOAM532W3dFsyx94H2wUAhFL9Em+cj3cQL0Pr0V5GBh6AH0ZXmSNUz2J
        ryJLQnu7KhGfaCStTosef+RO3cetGqYDTA==
X-Google-Smtp-Source: ABdhPJxE5tnvz8gR36ZLqMpY3yzr/5dtQPkCJKPgn5uDXI7WGAUy+tt5TSseOr+HCag71oYdMx0ZVQ==
X-Received: by 2002:a17:907:5010:b0:711:f093:3a93 with SMTP id fw16-20020a170907501000b00711f0933a93mr5628614ejc.620.1654707083946;
        Wed, 08 Jun 2022 09:51:23 -0700 (PDT)
Received: from dario-ThinkPad-T14s-Gen-2i.homenet.telecomitalia.it (host-80-116-90-174.pool80116.interbusiness.it. [80.116.90.174])
        by smtp.gmail.com with ESMTPSA id c22-20020a17090654d600b0070587f81bcfsm9569071ejp.19.2022.06.08.09.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 09:51:23 -0700 (PDT)
From:   Dario Binacchi <dario.binacchi@amarulasolutions.com>
To:     linux-kernel@vger.kernel.org
Cc:     Amarula patchwork <linux-amarula@amarulasolutions.com>,
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
Subject: [PATCH v2 00/13] can: slcan: extend supported features
Date:   Wed,  8 Jun 2022 18:51:03 +0200
Message-Id: <20220608165116.1575390-1-dario.binacchi@amarulasolutions.com>
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
  can: slcan: simplify the device de-allocation
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
 drivers/net/can/slcan/Makefile                |   7 +
 .../net/can/{slcan.c => slcan/slcan-core.c}   | 526 ++++++++++++++----
 drivers/net/can/slcan/slcan-ethtool.c         |  65 +++
 drivers/net/can/slcan/slcan.h                 |  18 +
 6 files changed, 539 insertions(+), 119 deletions(-)
 create mode 100644 drivers/net/can/slcan/Makefile
 rename drivers/net/can/{slcan.c => slcan/slcan-core.c} (65%)
 create mode 100644 drivers/net/can/slcan/slcan-ethtool.c
 create mode 100644 drivers/net/can/slcan/slcan.h

-- 
2.32.0


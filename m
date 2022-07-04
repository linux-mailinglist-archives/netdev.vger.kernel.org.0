Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FF7D565625
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 14:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234678AbiGDMxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 08:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234763AbiGDMwr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 08:52:47 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4F1F1208B
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 05:52:42 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1o8LZ5-0001Jv-9K
        for netdev@vger.kernel.org; Mon, 04 Jul 2022 14:52:35 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id DE8ACA7932
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 12:26:14 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 88E45A7921;
        Mon,  4 Jul 2022 12:26:14 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 62a2908a;
        Mon, 4 Jul 2022 12:26:14 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/15] pull-request: can 2022-07-04
Date:   Mon,  4 Jul 2022 14:25:58 +0200
Message-Id: <20220704122613.1551119-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 15 patches for net/master.

The 1st patch is by Oliver Hartkopp, targets the BCM CAN protocol and
converts a costly synchronize_rcu() to call_rcu() to fix a performance
regression.

Srinivas Neeli's patch for the xilinx_can driver drops the brp limit
down to 1, as only the pre-production silicon have an issue with a brp
of 1.

The next patch is by Duy Nguyen and fixes the data transmission on
R-Car V3U SoCs in the rcar_canfd driver.

Rhett Aultman's patch fixes a DMA memory leak in the gs_usb driver.

Liang He's patch removes an extra of_node_get() in the grcan driver.

The next 2 patches are by me, target the m_can driver and fix the
timestamp handling used for peripheral devices like the tcan4x5x.

Jimmy Assarsson contributes 3 patches for the kvaser_usb driver and
fixes CAN clock and bit timing related issues.

The remaining 5 patches target the mcp251xfd driver. Thomas Kopp
contributes 2 patches to improve the workaround for broken CRC when
reading the TBC register. 3 patches by me add a missing
hrtimer_cancel() during the ndo_stop() callback, and fix the reading
of the Device ID register.

regards,
Marc

---

The following changes since commit 280e3a857d96f9ca8e24632788e1e7a0fec4e9f7:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf (2022-07-03 12:29:18 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.19-20220704

for you to fetch changes up to 1c0e78a287e3493e22bde8553d02f3b89177eaf7:

  can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix endianness conversion (2022-07-04 12:51:43 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.19-20220704

----------------------------------------------------------------
Duy Nguyen (1):
      can: rcar_canfd: Fix data transmission failed on R-Car V3U

Jimmy Assarsson (3):
      can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info
      can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression
      can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits

Liang He (1):
      can: grcan: grcan_probe(): remove extra of_node_get()

Marc Kleine-Budde (5):
      can: m_can: m_can_chip_config(): actually enable internal timestamping
      can: m_can: m_can_{read_fifo,echo_tx_event}(): shift timestamp to full 32 bits
      can: mcp251xfd: mcp251xfd_stop(): add missing hrtimer_cancel()
      can: mcp251xfd: mcp251xfd_register_get_dev_id(): use correct length to read dev_id
      can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix endianness conversion

Oliver Hartkopp (1):
      can: bcm: use call_rcu() instead of costly synchronize_rcu()

Rhett Aultman (1):
      can: gs_usb: gs_usb_open/close(): fix memory leak

Srinivas Neeli (1):
      Revert "can: xilinx_can: Limit CANFD brp to 2"

Thomas Kopp (2):
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): improve workaround handling for mcp2517fd
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): update workaround broken CRC on TBC register

 drivers/net/can/grcan.c                           |   1 -
 drivers/net/can/m_can/m_can.c                     |   8 +-
 drivers/net/can/rcar/rcar_canfd.c                 |   5 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c    |   6 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c  |  22 +-
 drivers/net/can/usb/gs_usb.c                      |  23 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h       |  25 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  | 285 ++++++++++++----------
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |   4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 119 +++++----
 drivers/net/can/xilinx_can.c                      |   4 +-
 net/can/bcm.c                                     |  18 +-
 12 files changed, 304 insertions(+), 216 deletions(-)



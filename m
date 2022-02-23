Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF964C1EC0
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 23:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242200AbiBWWoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 17:44:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241320AbiBWWoH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 17:44:07 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1DE91D0DB
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 14:43:38 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nN0MD-0006O3-5s
        for netdev@vger.kernel.org; Wed, 23 Feb 2022 23:43:37 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CE3F33BB70
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 22:43:33 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 6D7673BB4A;
        Wed, 23 Feb 2022 22:43:33 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id ec7308b8;
        Wed, 23 Feb 2022 22:43:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/36] pull-request: can-next 2022-02-22
Date:   Wed, 23 Feb 2022 23:42:56 +0100
Message-Id: <20220223224332.2965690-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 36 patches for net-next/master.

The first 5 patches are by me and update various CAN DT bindings.

Eric Dumazet's patch for the CAN GW replaces a costly
synchronize_rcu() by a call_rcu().

The next 2 patches by me enhance the CAN bit rate handling, the bit
rate checking is simplified and the arguments and local variables of
functions are marked as const.

A patch by me for the kvaser_usb driver removes a redundant variable.

The next patch by me lets the c_can driver use the default ethtool
drvinfo.

Minghao Chi's patch for the softing driver removes a redundant
variable.

Srinivas Neeli contributes an enhancement for the xilinx_can NAPI poll
function.

Vincent Mailhol's patch for the etas_es58x driver converts to
BITS_PER_TYPE() from of manual calculation.

The next 23 patches target the mcp251xfd driver and are by me. The
first 15 patches, add support for the internal PLL, which includes
simplifying runtime PM handling, better chip detection and error
handling after wakeup, and the PLL handling. The last 8 patches
prepare the driver to support multiple RX-FIFOs and runtime
configurable RX/TX rings. The actual runtime ring configuration via
ethtool will be added in a later patch series.

regards,
Marc

---

The following changes since commit 48c77bdf729a91fa7f65765d3f60f01e0ac320c5:

  net: prestera: acl: fix 'client_map' buff overflow (2022-02-19 18:56:50 +0000)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.18-20220222

for you to fetch changes up to d6d27dfe2c58c11c0494c573665bfeffa2090d75:

  can: mcp251xfd: mcp251xfd_priv: introduce macros specifying the number of supported TEF/RX/TX rings (2022-02-20 12:00:44 +0100)

----------------------------------------------------------------
linux-can-next-for-5.18-20220222

----------------------------------------------------------------
Eric Dumazet (1):
      can: gw: use call_rcu() instead of costly synchronize_rcu()

Marc Kleine-Budde (32):
      dt-binding: can: mcp251xfd: include common CAN controller bindings
      dt-binding: can: sun4i_can: include common CAN controller bindings
      dt-binding: can: m_can: list Chandrasekar Ramakrishnan as maintainer
      dt-binding: can: m_can: fix indention of table in bosch,mram-cfg description
      dt-binding: can: m_can: include common CAN controller bindings
      can: bittiming: can_validate_bitrate(): simplify bit rate checking
      can: bittiming: mark function arguments and local variables as const
      can: kvaser_usb: kvaser_usb_send_cmd(): remove redundant variable actual_len
      can: c_can: ethtool: use default drvinfo
      can: mcp251xfd: mcp251xfd_reg_invalid(): rename from mcp251xfd_osc_invalid()
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): ignore CRC error only if solely OSC register is read
      can: mcp251xfd: mcp251xfd_unregister(): simplify runtime PM handling
      can: mcp251xfd: mcp251xfd_chip_sleep(): introduce function to bring chip into sleep mode
      can: mcp251xfd: mcp251xfd_chip_stop(): convert to a void function
      can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): factor out into separate function
      can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): improve chip detection and error handling
      can: mcp251xfd: mcp251xfd_chip_wait_for_osc_ready(): prepare for PLL support
      can: mcp251xfd: mcp251xfd_chip_softreset_check(): wait for OSC ready before accessing chip
      can: mcp251xfd: mcp251xfd_chip_timestamp_init(): factor out into separate function
      can: mcp251xfd: mcp251xfd_chip_wake(): renamed from mcp251xfd_chip_clock_enable()
      can: mcp251xfd: __mcp251xfd_chip_set_mode(): prepare for PLL support: improve error handling and diagnostics
      can: mcp251xfd: mcp251xfd_chip_clock_init(): prepare for PLL support, wait for OSC ready
      can: mcp251xfd: mcp251xfd_register(): prepare to activate PLL after softreset
      can: mcp251xfd: add support for internal PLL
      can: mcp251xfd: introduce struct mcp251xfd_tx_ring::nr and ::fifo_nr and make use of it
      can: mcp251xfd: mcp251xfd_ring_init(): split ring_init into separate functions
      can: mcp251xfd: ring: prepare to change order of TX and RX FIFOs
      can: mcp251xfd: ring: change order of TX and RX FIFOs
      can: mcp251xfd: ring: mcp251xfd_ring_init(): checked RAM usage of ring setup
      can: mcp251xfd: ring: update FIFO setup debug info
      can: mcp251xfd: prepare for multiple RX-FIFOs
      can: mcp251xfd: mcp251xfd_priv: introduce macros specifying the number of supported TEF/RX/TX rings

Minghao Chi (1):
      can: softing: softing_netdev_open(): remove redundant ret variable

Srinivas Neeli (1):
      can: xilinx_can: Add check for NAPI Poll function

Vincent Mailhol (1):
      can: etas_es58x: use BITS_PER_TYPE() instead of manual calculation

 .../bindings/net/can/allwinner,sun4i-a10-can.yaml  |   3 +
 .../devicetree/bindings/net/can/bosch,m_can.yaml   |   9 +-
 .../bindings/net/can/microchip,mcp251xfd.yaml      |   3 +
 drivers/net/can/c_can/c_can_ethtool.c              |   9 -
 drivers/net/can/dev/bittiming.c                    |  20 +-
 drivers/net/can/softing/softing_main.c             |   5 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c    |   4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     | 342 +++++++++++++++------
 drivers/net/can/spi/mcp251xfd/mcp251xfd-dump.c     |   4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |  24 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     | 203 ++++++++----
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c       |  12 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |  31 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |   3 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |   4 +-
 drivers/net/can/xilinx_can.c                       |   9 +-
 include/linux/can/bittiming.h                      |   6 +-
 net/can/gw.c                                       |  16 +-
 18 files changed, 478 insertions(+), 229 deletions(-)



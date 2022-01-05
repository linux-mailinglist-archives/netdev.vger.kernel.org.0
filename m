Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9042F4854D3
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 15:44:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiAEOoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 09:44:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiAEOoM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 09:44:12 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1169CC061761
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 06:44:12 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n57WM-0003yA-IO
        for netdev@vger.kernel.org; Wed, 05 Jan 2022 15:44:10 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A38B86D1AD7
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 14:44:06 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id AB4DB6D1ABA;
        Wed,  5 Jan 2022 14:44:04 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 4b671639;
        Wed, 5 Jan 2022 14:44:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/15] pull-request: can-next 2022-01-05
Date:   Wed,  5 Jan 2022 15:43:47 +0100
Message-Id: <20220105144402.1174191-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 15 patches for net-next/master.

The first patch is by me and removed an unused variable from the
usb_8dev driver.

Andy Shevchenko contributes a patch for the mcp251x driver, which
removes an unneeded assignment.

Jimmy Assarsson's patch for the kvaser_usb makes use of units.h in the
assignment of frequencies.

Lad Prabhakar provides 2 patches, converting the ti_hecc and the
sja1000 driver to make use of platform_get_irq().

The 10 remaining patches are by Vincent Mailhol. First the etas_es58x
driver populates the net_device::dev_port. The next 5 patches cleanup
the handling of CAN error and CAN RTR messages of all drivers. The
remaining 4 patches enhance the CAN controller mode flag handling and
export it via netlink to user space.

regards,
Marc

---

The following changes since commit ffd32ea6b13c97904cae59bdb13a843d52756578:

  Revert "net: wwan: iosm: Keep device at D0 for s2idle case" (2022-01-04 18:15:17 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.17-20220105

for you to fetch changes up to 383f0993fc77152b0773c85ed69d6734baf9cb48:

  can: netlink: report the CAN controller mode supported flags (2022-01-05 12:09:06 +0100)

----------------------------------------------------------------
linux-can-next-for-5.17-20220105

----------------------------------------------------------------
Andy Shevchenko (1):
      can: mcp251x: mcp251x_gpio_setup(): Get rid of duplicate of_node assignment

Jimmy Assarsson (1):
      can: kvaser_usb: make use of units.h in assignment of frequency

Lad Prabhakar (2):
      can: ti_hecc: ti_hecc_probe(): use platform_get_irq() to get the interrupt
      can: sja1000: sp_probe(): use platform_get_irq() to get the interrupt

Marc Kleine-Budde (1):
      can: usb_8dev: remove unused member echo_skb from struct usb_8dev_priv

Vincent Mailhol (10):
      can: etas_es58x: es58x_init_netdev: populate net_device::dev_port
      can: do not increase rx statistics when generating a CAN rx error message frame
      can: kvaser_usb: do not increase tx statistics when sending error message frames
      can: do not copy the payload of RTR frames
      can: do not increase rx_bytes statistics for RTR frames
      can: do not increase tx_bytes statistics for RTR frames
      can: dev: replace can_priv::ctrlmode_static by can_get_static_ctrlmode()
      can: dev: add sanity check in can_set_static_ctrlmode()
      can: dev: reorder struct can_priv members for better packing
      can: netlink: report the CAN controller mode supported flags

 drivers/net/can/at91_can.c                        | 18 ++----
 drivers/net/can/c_can/c_can.h                     |  1 -
 drivers/net/can/c_can/c_can_main.c                | 16 ++---
 drivers/net/can/cc770/cc770.c                     | 16 ++---
 drivers/net/can/dev/dev.c                         |  9 +--
 drivers/net/can/dev/netlink.c                     | 33 +++++++++-
 drivers/net/can/dev/rx-offload.c                  |  7 +-
 drivers/net/can/grcan.c                           | 23 ++-----
 drivers/net/can/ifi_canfd/ifi_canfd.c             | 11 +---
 drivers/net/can/janz-ican3.c                      |  6 +-
 drivers/net/can/kvaser_pciefd.c                   | 16 ++---
 drivers/net/can/m_can/m_can.c                     | 23 +++----
 drivers/net/can/mscan/mscan.c                     | 14 ++--
 drivers/net/can/pch_can.c                         | 33 ++++------
 drivers/net/can/peak_canfd/peak_canfd.c           | 14 ++--
 drivers/net/can/rcar/rcar_can.c                   | 22 +++----
 drivers/net/can/rcar/rcar_canfd.c                 | 17 ++---
 drivers/net/can/sja1000/sja1000.c                 | 11 ++--
 drivers/net/can/sja1000/sja1000_platform.c        | 15 +++--
 drivers/net/can/slcan.c                           |  7 +-
 drivers/net/can/softing/softing_main.c            |  8 +--
 drivers/net/can/spi/hi311x.c                      | 31 +++++----
 drivers/net/can/spi/mcp251x.c                     | 34 +++++-----
 drivers/net/can/sun4i_can.c                       | 22 +++----
 drivers/net/can/ti_hecc.c                         |  8 +--
 drivers/net/can/usb/ems_usb.c                     | 14 ++--
 drivers/net/can/usb/esd_usb2.c                    | 13 ++--
 drivers/net/can/usb/etas_es58x/es58x_core.c       |  8 +--
 drivers/net/can/usb/gs_usb.c                      |  7 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h       |  5 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  |  4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c | 78 +++++++++++------------
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 29 ++++-----
 drivers/net/can/usb/mcba_usb.c                    | 23 +++----
 drivers/net/can/usb/peak_usb/pcan_usb.c           |  9 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c      | 20 +++---
 drivers/net/can/usb/peak_usb/pcan_usb_core.h      |  1 -
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c        | 11 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c       | 12 ++--
 drivers/net/can/usb/ucan.c                        | 17 +++--
 drivers/net/can/usb/usb_8dev.c                    | 19 ++----
 drivers/net/can/vcan.c                            |  7 +-
 drivers/net/can/vxcan.c                           |  2 +-
 drivers/net/can/xilinx_can.c                      | 19 +++---
 include/linux/can/dev.h                           | 24 +++++--
 include/linux/can/skb.h                           |  5 +-
 include/uapi/linux/can/netlink.h                  | 13 ++++
 47 files changed, 351 insertions(+), 404 deletions(-)



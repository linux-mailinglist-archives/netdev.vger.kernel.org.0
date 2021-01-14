Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E04872F5BC6
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 08:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727678AbhANH5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 02:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727424AbhANH5G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 02:57:06 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3159C061795
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 23:56:25 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kzxUW-00070i-DC
        for netdev@vger.kernel.org; Thu, 14 Jan 2021 08:56:24 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 62FB05C361B
        for <netdev@vger.kernel.org>; Thu, 14 Jan 2021 07:56:21 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B6BB35C35F9;
        Thu, 14 Jan 2021 07:56:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1221f7c1;
        Thu, 14 Jan 2021 07:56:18 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-01-14
Date:   Thu, 14 Jan 2021 08:56:00 +0100
Message-Id: <20210114075617.1402597-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
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

this is the corrected version of yesterday's pull request, it consists of 17
patches for net-next/master.

The first two patches update the MAINTAINERS file, Lukas Bulwahn's patch fixes
the files entry for the tcan4x5x driver, which was broken by me in net-next.
A patch by me adds the a missing header file to the CAN Networking Layer.

The next 5 patches are by me and split the the CAN driver related
infrastructure code into more files in a separate subdir. The next two patches
by me clean up the CAN length related code. This is followed by 6 patches by
Vincent Mailhol and me, they add helper code for for CAN frame length
calculation neede for BQL support.

A patch by Vincent Mailhol adds software TX timestamp support.

The last patch is by me, targets the tcan4x5x driver, and removes the unneeded
__packed attribute from the struct tcan4x5x_map_buf.

regards,
Marc

---

The following changes since commit f50e2f9f791647aa4e5b19d0064f5cabf630bf6e:

  hci: llc_shdlc: style: Simplify bool comparison (2021-01-12 20:18:30 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.12-20210114

for you to fetch changes up to 1105592cb8fdfcc96f2c9c693ff4106bac5fac7c:

  can: tcan4x5x: remove __packed attribute from struct tcan4x5x_map_buf (2021-01-14 08:43:44 +0100)

----------------------------------------------------------------
linux-can-next-for-5.12-20210114

----------------------------------------------------------------
Lukas Bulwahn (1):
      MAINTAINERS: adjust entry to tcan4x5x file split

Marc Kleine-Budde (13):
      MAINTAINERS: CAN network layer: add missing header file can-ml.h
      can: dev: move driver related infrastructure into separate subdir
      can: dev: move bittiming related code into seperate file
      can: dev: move length related code into seperate file
      can: dev: move skb related into seperate file
      can: dev: move netlink related code into seperate file
      can: length: convert to kernel coding style
      can: length: can_fd_len2dlc(): simplify length calculcation
      can: length: canfd_sanitize_len(): add function to sanitize CAN-FD data length
      can: dev: extend struct can_skb_priv to hold CAN frame length
      can: dev: can_get_echo_skb(): extend to return can frame length
      can: dev: can_rx_offload_get_echo_skb(): extend to return can frame length
      can: tcan4x5x: remove __packed attribute from struct tcan4x5x_map_buf

Vincent Mailhol (3):
      can: length: can_skb_get_frame_len(): introduce function to get data length of frame in data link layer
      can: dev: can_put_echo_skb(): extend to handle frame_len
      can: dev: can_put_echo_skb(): add software tx timestamps

 MAINTAINERS                                       |    5 +-
 drivers/net/can/Makefile                          |    7 +-
 drivers/net/can/at91_can.c                        |    4 +-
 drivers/net/can/c_can/c_can.c                     |    4 +-
 drivers/net/can/cc770/cc770.c                     |    4 +-
 drivers/net/can/dev.c                             | 1338 ---------------------
 drivers/net/can/dev/Makefile                      |   11 +
 drivers/net/can/dev/bittiming.c                   |  261 ++++
 drivers/net/can/dev/dev.c                         |  467 +++++++
 drivers/net/can/dev/length.c                      |   90 ++
 drivers/net/can/dev/netlink.c                     |  379 ++++++
 drivers/net/can/{ => dev}/rx-offload.c            |    5 +-
 drivers/net/can/dev/skb.c                         |  231 ++++
 drivers/net/can/flexcan.c                         |    7 +-
 drivers/net/can/grcan.c                           |    4 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c             |    4 +-
 drivers/net/can/kvaser_pciefd.c                   |    6 +-
 drivers/net/can/m_can/m_can.c                     |    8 +-
 drivers/net/can/m_can/tcan4x5x.h                  |    2 +-
 drivers/net/can/mscan/mscan.c                     |    4 +-
 drivers/net/can/pch_can.c                         |    4 +-
 drivers/net/can/peak_canfd/peak_canfd.c           |    4 +-
 drivers/net/can/rcar/rcar_can.c                   |    4 +-
 drivers/net/can/rcar/rcar_canfd.c                 |    4 +-
 drivers/net/can/sja1000/sja1000.c                 |    4 +-
 drivers/net/can/softing/softing_main.c            |    4 +-
 drivers/net/can/spi/hi311x.c                      |    4 +-
 drivers/net/can/spi/mcp251x.c                     |    4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c    |    4 +-
 drivers/net/can/sun4i_can.c                       |    4 +-
 drivers/net/can/ti_hecc.c                         |    4 +-
 drivers/net/can/usb/ems_usb.c                     |    4 +-
 drivers/net/can/usb/esd_usb2.c                    |    4 +-
 drivers/net/can/usb/gs_usb.c                      |    4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c  |    2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |    2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  |    2 +-
 drivers/net/can/usb/mcba_usb.c                    |    4 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c      |    4 +-
 drivers/net/can/usb/ucan.c                        |    4 +-
 drivers/net/can/usb/usb_8dev.c                    |    4 +-
 drivers/net/can/xilinx_can.c                      |    6 +-
 include/linux/can/bittiming.h                     |   44 +
 include/linux/can/dev.h                           |  135 +--
 include/linux/can/length.h                        |  174 +++
 include/linux/can/rx-offload.h                    |    3 +-
 include/linux/can/skb.h                           |   80 ++
 47 files changed, 1819 insertions(+), 1542 deletions(-)
 delete mode 100644 drivers/net/can/dev.c
 create mode 100644 drivers/net/can/dev/Makefile
 create mode 100644 drivers/net/can/dev/bittiming.c
 create mode 100644 drivers/net/can/dev/dev.c
 create mode 100644 drivers/net/can/dev/length.c
 create mode 100644 drivers/net/can/dev/netlink.c
 rename drivers/net/can/{ => dev}/rx-offload.c (98%)
 create mode 100644 drivers/net/can/dev/skb.c
 create mode 100644 include/linux/can/bittiming.h
 create mode 100644 include/linux/can/length.h



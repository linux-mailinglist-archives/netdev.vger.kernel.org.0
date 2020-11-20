Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F8D62BAB2A
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 14:33:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbgKTNdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 08:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726553AbgKTNdW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 08:33:22 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AA57C0613CF
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 05:33:22 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kg6XQ-0006Fn-MW; Fri, 20 Nov 2020 14:33:20 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2020-11-20
Date:   Fri, 20 Nov 2020 14:32:53 +0100
Message-Id: <20201120133318.3428231-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

here's a pull request of 25 patches for net-next/master.

The first patch is by Yegor Yefremov and he improves the j1939 documentaton by
adding tables for the CAN identifier and its fields.

Then there are 8 patches by Oliver Hartkopp targeting the CAN driver
infrastructure and drivers. These add support for optional DLC element to the
Classical CAN frame structure. See patch ea7800565a12 ("can: add optional DLC
element to Classical CAN frame structure") for details. Oliver's last patch
adds len8_dlc support to several drivers. Stefan Mätje provides a patch to add 
len8_dlc support to the esd_usb2 driver.

The next patch is by Oliver Hartkopp, too and adds support for modification of
Classical CAN DLCs to CAN GW sockets.

The next 3 patches target the nxp,flexcan DT bindings. One patch by my adds the
missing uint32 reference to the clock-frequency property. Joakim Zhang's
patches fix the fsl,clk-source property and add the IMX_SC_R_CAN() macro to the
imx firmware header file, which will be used in the flexcan driver later.

Another patch by Joakim Zhang prepares the flexcan driver for SCU based
stop-mode, by giving the existing, GPR based stop-mode, a _GPR postfix.

The next 5 patches are by me, target the flexcan driver, and clean up the 
.ndo_open and .ndo_stop callbacks. These patches try to fix a sporadically 
hanging flexcan_close() during simultanious ifdown, sending of CAN messages and
probably open CAN bus. I was never aber to reproduce, but these seem to fix the 
problem at the reporting user. As these changes are rather big, I'd like to 
mainline them via net-next/master.

The next patches are by Jimmy Assarsson and Christer Beskow, they add support 
for new USB devices to the existing kvaser_usb driver.

The last patch is by Kaixu Xia and simplifies the return in the
mcp251xfd_chip_softreset() function in the mcp251xfd driver.

regrads,
Marc

---

The following changes since commit 4082c502bf9c8a6afe4268c654d4e93ab7dfeb69:

  Merge branch 'enetc-clean-endianness-warnings-up' (2020-11-19 22:05:44 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.11-20201120

for you to fetch changes up to 275f6010b6994ad286a859062c03be050e8073ad:

  can: mcp251xfd: remove useless code in mcp251xfd_chip_softreset (2020-11-20 12:06:47 +0100)

----------------------------------------------------------------
linux-can-next-for-5.11-20201120

----------------------------------------------------------------
Christer Beskow (1):
      can: kvaser_usb: kvaser_usb_hydra: Add support for new device variant

Jimmy Assarsson (3):
      can: kvaser_usb: Add USB_{LEAF,HYDRA}_PRODUCT_ID_END defines
      can: kvaser_usb: Add new Kvaser Leaf v2 devices
      can: kvaser_usb: Add new Kvaser hydra devices

Joakim Zhang (3):
      dt-bindings: can: fsl,flexcan: fix fsl,clk-source property
      dt-bindings: firmware: add IMX_SC_R_CAN(x) macro for CAN
      can: flexcan: rename macro FLEXCAN_QUIRK_SETUP_STOP_MODE -> FLEXCAN_QUIRK_SETUP_STOP_MODE_GPR

Kaixu Xia (1):
      can: mcp251xfd: remove useless code in mcp251xfd_chip_softreset

Marc Kleine-Budde (6):
      dt-bindings: can: fsl,flexcan: add uint32 reference to clock-frequency property
      can: flexcan: factor out enabling and disabling of interrupts into separate function
      can: flexcan: move enabling/disabling of interrupts from flexcan_chip_{start,stop}() to callers
      can: flexcan: flexcan_rx_offload_setup(): factor out mailbox and rx-offload setup into separate function
      can: flexcan: flexcan_open(): completely initialize controller before requesting IRQ
      can: flexcan: flexcan_close(): change order if commands to properly shut down the controller

Oliver Hartkopp (9):
      can: add optional DLC element to Classical CAN frame structure
      can: rename get_can_dlc() macro with can_cc_dlc2len()
      can: remove obsolete get_canfd_dlc() macro
      can: replace can_dlc as variable/element for payload length
      can: rename CAN FD related can_len2dlc and can_dlc2len helpers
      can: update documentation for DLC usage in Classical CAN
      can: drivers: introduce helpers to access Classical CAN DLC values
      can: drivers: add len8_dlc support for various CAN adapters
      can: gw: support modification of Classical CAN DLCs

Stefan Mätje (1):
      can: drivers: add len8_dlc support for esd_usb2 CAN adapter

Yegor Yefremov (1):
      can: j1939: add tables for the CAN identifier and its fields

 .../devicetree/bindings/net/can/fsl,flexcan.yaml   |   5 +-
 Documentation/networking/can.rst                   |  70 ++++++---
 Documentation/networking/j1939.rst                 |  46 +++++-
 drivers/net/can/at91_can.c                         |  14 +-
 drivers/net/can/c_can/c_can.c                      |  20 +--
 drivers/net/can/cc770/cc770.c                      |  14 +-
 drivers/net/can/dev.c                              |  16 +-
 drivers/net/can/flexcan.c                          | 161 ++++++++++++---------
 drivers/net/can/grcan.c                            |  10 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c              |  10 +-
 drivers/net/can/janz-ican3.c                       |  20 +--
 drivers/net/can/kvaser_pciefd.c                    |  10 +-
 drivers/net/can/m_can/m_can.c                      |  12 +-
 drivers/net/can/mscan/mscan.c                      |  20 +--
 drivers/net/can/pch_can.c                          |  14 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |  16 +-
 drivers/net/can/rcar/rcar_can.c                    |  14 +-
 drivers/net/can/rcar/rcar_canfd.c                  |  12 +-
 drivers/net/can/rx-offload.c                       |   2 +-
 drivers/net/can/sja1000/sja1000.c                  |  16 +-
 drivers/net/can/slcan.c                            |  32 ++--
 drivers/net/can/softing/softing_fw.c               |   2 +-
 drivers/net/can/softing/softing_main.c             |  14 +-
 drivers/net/can/spi/hi311x.c                       |  20 +--
 drivers/net/can/spi/mcp251x.c                      |  20 +--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  15 +-
 drivers/net/can/sun4i_can.c                        |  10 +-
 drivers/net/can/ti_hecc.c                          |   8 +-
 drivers/net/can/usb/Kconfig                        |   5 +
 drivers/net/can/usb/ems_usb.c                      |  16 +-
 drivers/net/can/usb/esd_usb2.c                     |  24 +--
 drivers/net/can/usb/gs_usb.c                       |  11 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |  22 ++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  61 ++++++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  22 +--
 drivers/net/can/usb/mcba_usb.c                     |  10 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  18 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  29 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |  14 +-
 drivers/net/can/usb/ucan.c                         |  20 +--
 drivers/net/can/usb/usb_8dev.c                     |  17 ++-
 drivers/net/can/xilinx_can.c                       |  16 +-
 include/dt-bindings/firmware/imx/rsrc.h            |   1 +
 include/linux/can/dev.h                            |  38 ++++-
 include/linux/can/dev/peak_canfd.h                 |   2 +-
 include/uapi/linux/can.h                           |  38 +++--
 include/uapi/linux/can/gw.h                        |   4 +-
 include/uapi/linux/can/netlink.h                   |   1 +
 net/can/af_can.c                                   |   2 +-
 net/can/gw.c                                       |  80 ++++++++--
 net/can/j1939/main.c                               |   4 +-
 51 files changed, 674 insertions(+), 404 deletions(-)


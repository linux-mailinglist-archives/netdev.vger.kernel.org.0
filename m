Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC5962A597B
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 23:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731052AbgKCWGm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 17:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731016AbgKCWGl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 17:06:41 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72928C0613D1
        for <netdev@vger.kernel.org>; Tue,  3 Nov 2020 14:06:41 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ka4Rq-0006Ui-QA; Tue, 03 Nov 2020 23:06:38 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-11-03
Date:   Tue,  3 Nov 2020 23:06:09 +0100
Message-Id: <20201103220636.972106-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

here's a pull request for net/master consisting of 27 patches for net/master.

The first two patches are by Oleksij Rempel and they add a generic
can-controller Device Tree yaml binding and convert the text based binding of
the flexcan driver to a yaml based binding.

Zhang Changzhong's patch fixes a remove_proc_entry warning in the AF_CAN core.

A patch by me fixes a kfree_skb() call from IRQ context in the rx-offload
helper.

Vincent Mailhol contributes a patch to prevent a call to kfree_skb() in hard
IRQ context in can_get_echo_skb().

Oliver Hartkopp's patch fixes the length calculation for RTR CAN frames in the
__can_get_echo_skb() helper.

Oleksij Rempel's patch fixes a use-after-free that shows up with j1939 in
can_create_echo_skb().

Yegor Yefremov contributes 4 patches to enhance the j1939 documentation.

Zhang Changzhong's patch fixes a hanging task problem in j1939_sk_bind() if the
netdev is down.

Then there are three patches for the newly added CAN_ISOTP protocol. Geert
Uytterhoeven enhances the kconfig help text. Oliver Hartkopp's patch adds
missing RX timeout handling in listen-only mode and Colin Ian King's patch
decreases the generated object code by 926 bytes.

Zhang Changzhong contributes a patch for the ti_hecc driver that fixes the
error path in the probe function.

Navid Emamdoost's patch for the xilinx_can driver fixes the error handling in
case of failing pm_runtime_get_sync().

There are two patches for the peak_usb driver. Dan Carpenter adds range
checking in decode operations and Stephane Grosjean's patch fixes a timestamp
wrapping problem.

Stephane Grosjean's patch for th peak_canfd driver fixes echo management if
loopback is on.

The next three patches all target the mcp251xfd driver. The first one is by me
and it increased the severity of CRC read error messages. The kernel test robot
removes an unneeded semicolon and Tom Rix removes unneeded break in several
switch-cases.

The last 4 patches are by Joakim Zhang and target the flexcan driver, the first
three fix ECC related device specific quirks for the LS1021A, LX2160A and the
VF610 SoC. The last patch disable wakeup completely upon driver remove.

regards,
Marc

---

The following changes since commit 9621618130bf7e83635367c13b9a6ee53935bb37:

  sfp: Fix error handing in sfp_probe() (2020-11-02 17:19:59 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.10-20201103

for you to fetch changes up to ab07ff1c92fa60f29438e655a1b4abab860ed0b6:

  can: flexcan: flexcan_remove(): disable wakeup completely (2020-11-03 22:30:34 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.10-20201103

----------------------------------------------------------------
Colin Ian King (1):
      can: isotp: padlen(): make const array static, makes object smaller

Dan Carpenter (1):
      can: peak_usb: add range checking in decode operations

Geert Uytterhoeven (1):
      can: isotp: Explain PDU in CAN_ISOTP help text

Joakim Zhang (4):
      can: flexcan: remove FLEXCAN_QUIRK_DISABLE_MECR quirk for LS1021A
      can: flexcan: add ECC initialization for LX2160A
      can: flexcan: add ECC initialization for VF610
      can: flexcan: flexcan_remove(): disable wakeup completely

Marc Kleine-Budde (2):
      can: rx-offload: don't call kfree_skb() from IRQ context
      can: mcp251xfd: mcp251xfd_regmap_crc_read(): increase severity of CRC read error messages

Navid Emamdoost (1):
      can: xilinx_can: handle failure cases of pm_runtime_get_sync

Oleksij Rempel (3):
      dt-bindings: can: add can-controller.yaml
      dt-bindings: can: flexcan: convert fsl,*flexcan bindings to yaml
      can: can_create_echo_skb(): fix echo skb generation: always use skb_clone()

Oliver Hartkopp (2):
      can: dev: __can_get_echo_skb(): fix real payload length return value for RTR frames
      can: isotp: isotp_rcv_cf(): enable RX timeout handling in listen-only mode

Stephane Grosjean (2):
      can: peak_usb: peak_usb_get_ts_time(): fix timestamp wrapping
      can: peak_canfd: pucan_handle_can_rx(): fix echo management when loopback is on

Tom Rix (1):
      can: mcp251xfd: remove unneeded break

Vincent Mailhol (1):
      can: dev: can_get_echo_skb(): prevent call to kfree_skb() in hard IRQ context

Yegor Yefremov (4):
      can: j1939: rename jacd tool
      can: j1939: fix syntax and spelling
      can: j1939: swap addr and pgn in the send example
      can: j1939: use backquotes for code samples

Zhang Changzhong (3):
      can: proc: can_remove_proc(): silence remove_proc_entry warning
      can: j1939: j1939_sk_bind(): return failure if netdev is down
      can: ti_hecc: ti_hecc_probe(): add missed clk_disable_unprepare() in error path

kernel test robot (1):
      can: mcp251xfd: mcp251xfd_regmap_nocrc_read(): fix semicolon.cocci warnings

 .../bindings/net/can/can-controller.yaml           |  18 +++
 .../devicetree/bindings/net/can/fsl,flexcan.yaml   | 135 +++++++++++++++++++++
 .../devicetree/bindings/net/can/fsl-flexcan.txt    |  57 ---------
 Documentation/networking/j1939.rst                 | 120 +++++++++---------
 drivers/net/can/dev.c                              |  14 ++-
 drivers/net/can/flexcan.c                          |  12 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |  11 +-
 drivers/net/can/rx-offload.c                       |   4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  22 ++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |  18 +--
 drivers/net/can/ti_hecc.c                          |   8 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |  51 +++++++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  48 ++++++--
 drivers/net/can/xilinx_can.c                       |   6 +-
 include/linux/can/skb.h                            |  20 ++-
 net/can/Kconfig                                    |   5 +-
 net/can/isotp.c                                    |  26 ++--
 net/can/j1939/socket.c                             |   6 +
 net/can/proc.c                                     |   6 +-
 19 files changed, 387 insertions(+), 200 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/can-controller.yaml
 create mode 100644 Documentation/devicetree/bindings/net/can/fsl,flexcan.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/fsl-flexcan.txt



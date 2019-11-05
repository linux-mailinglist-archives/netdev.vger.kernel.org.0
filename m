Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97668F02C2
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 17:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390264AbfKEQcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 11:32:35 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:59045 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390116AbfKEQce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 11:32:34 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1iS1kv-0002Hp-Eu; Tue, 05 Nov 2019 17:32:33 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2019-11-05
Date:   Tue,  5 Nov 2019 17:31:42 +0100
Message-Id: <20191105163215.30194-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0.rc1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

this is a pull request of 33 patches for net/master.

In the first patch Wen Yang's patch adds a missing of_node_put() to CAN device
infrastructure.

Navid Emamdoost's patch for the gs_usb driver fixes a memory leak in the
gs_can_open() error path.

Johan Hovold provides two patches, one for the mcba_usb, the other for the
usb_8dev driver. Both fix a use-after-free after USB-disconnect.

Joakim Zhang's patch improves the flexcan driver, the ECC mechanism is now
completely disabled instead of masking the interrupts.

The next three patches all target the peak_usb driver. Stephane Grosjean's
patch fixes a potential out-of-sync while decoding packets, Johan Hovold's
patch fixes a slab info leak, Jeroen Hofstee's patch adds missing reporting of
bus off recovery events.

Followed by three patches for the c_can driver. Kurt Van Dijck's patch fixes
detection of potential missing status IRQs, Jeroen Hofstee's patches add a chip
reset on open and add missing reporting of bus off recovery events.

Appana Durga Kedareswara rao's patch for the xilinx driver fixes the flags
field initialization for axi CAN.

The next seven patches target the rx-offload helper, they are by me and Jeroen
Hofstee. The error handling in case of a queue overflow is fixed removing a
memory leak. Further the error handling in case of queue overflow and skb OOM
is cleaned up.

The next two patches are by me and target the flexcan and ti_hecc driver. In
case of a error during can_rx_offload_queue_sorted() the error counters in the
drivers are incremented.

Jeroen Hofstee provides 6 patches for the ti_hecc driver, which properly stop
the device in ifdown, improve the rx-offload support (which hit mainline in
v5.4-rc1), and add missing FIFO overflow and state change reporting.

The following four patches target the j1939 protocol. Colin Ian King's patch
fixes a memory leak in the j1939_sk_errqueue() handling. Three patches by
Oleksij Rempel fix a memory leak on socket release and fix the EOMA packet in
the transport protocol.

Timo Schlüßler's patch fixes a potential race condition in the mcp251x driver
on after suspend.

The last patch is by Yegor Yefremov and updates the SPDX-License-Identifier to
v3.0.

regards,
Marc

---

The following changes since commit 3d1e5039f5f87a8731202ceca08764ee7cb010d3:

  dccp: do not leak jiffies on the wire (2019-11-04 11:36:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.4-20191105

for you to fetch changes up to 3926a3a025d443f6b7a58a2c0c33e7d77c1ca935:

  can: don't use deprecated license identifiers (2019-11-05 12:44:34 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.4-20191105

----------------------------------------------------------------
Appana Durga Kedareswara rao (1):
      can: xilinx_can: Fix flags field initialization for axi can

Colin Ian King (1):
      can: j1939: fix resource leak of skb on error return paths

Jeroen Hofstee (10):
      can: peak_usb: report bus recovery as well
      can: c_can: D_CAN: c_can_chip_config(): perform a sofware reset on open
      can: c_can: C_CAN: add bus recovery events
      can: rx-offload: can_rx_offload_irq_offload_timestamp(): continue on error
      can: ti_hecc: ti_hecc_stop(): stop the CPK on down
      can: ti_hecc: keep MIM and MD set
      can: ti_hecc: release the mailbox a bit earlier
      can: ti_hecc: add fifo overflow error reporting
      can: ti_hecc: properly report state changes
      can: ti_hecc: add missing state changes

Joakim Zhang (1):
      can: flexcan: disable completely the ECC mechanism

Johan Hovold (3):
      can: mcba_usb: fix use-after-free on disconnect
      can: usb_8dev: fix use-after-free on disconnect
      can: peak_usb: fix slab info leak

Kurt Van Dijck (1):
      can: c_can: c_can_poll(): only read status register after status IRQ

Marc Kleine-Budde (8):
      can: rx-offload: can_rx_offload_queue_sorted(): fix error handling, avoid skb mem leak
      can: rx-offload: can_rx_offload_queue_tail(): fix error handling, avoid skb mem leak
      can: rx-offload: can_rx_offload_offload_one(): do not increase the skb_queue beyond skb_queue_len_max
      can: rx-offload: can_rx_offload_offload_one(): increment rx_fifo_errors on queue overflow or OOM
      can: rx-offload: can_rx_offload_offload_one(): use ERR_PTR() to propagate error value in case of errors
      can: rx-offload: can_rx_offload_irq_offload_fifo(): continue on error
      can: flexcan: increase error counters if skb enqueueing via can_rx_offload_queue_sorted() fails
      can: ti_hecc: ti_hecc_error(): increase error counters if skb enqueueing via can_rx_offload_queue_sorted() fails

Navid Emamdoost (1):
      can: gs_usb: gs_can_open(): prevent memory leak

Oleksij Rempel (3):
      can: j1939: fix memory leak if filters was set
      can: j1939: transport: j1939_session_fresh_new(): make sure EOMA is send with the total message size set
      can: j1939: transport: j1939_xtp_rx_eoma_one(): Add sanity check for correct total message size

Stephane Grosjean (1):
      can: peak_usb: fix a potential out-of-sync while decoding packets

Timo Schlüßler (1):
      can: mcp251x: mcp251x_restart_work_handler(): Fix potential force_quit race condition

Wen Yang (1):
      can: dev: add missing of_node_put() after calling of_get_child_by_name()

Yegor Yefremov (1):
      can: don't use deprecated license identifiers

 drivers/net/can/c_can/c_can.c                |  71 +++++++-
 drivers/net/can/c_can/c_can.h                |   1 +
 drivers/net/can/dev.c                        |   1 +
 drivers/net/can/flexcan.c                    |  11 +-
 drivers/net/can/rx-offload.c                 | 102 ++++++++++--
 drivers/net/can/spi/mcp251x.c                |   2 +-
 drivers/net/can/ti_hecc.c                    | 232 +++++++++++++++++----------
 drivers/net/can/usb/gs_usb.c                 |   1 +
 drivers/net/can/usb/mcba_usb.c               |   3 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c      |  32 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |   2 +-
 drivers/net/can/usb/usb_8dev.c               |   3 +-
 drivers/net/can/xilinx_can.c                 |   1 -
 include/uapi/linux/can.h                     |   2 +-
 include/uapi/linux/can/bcm.h                 |   2 +-
 include/uapi/linux/can/error.h               |   2 +-
 include/uapi/linux/can/gw.h                  |   2 +-
 include/uapi/linux/can/j1939.h               |   2 +-
 include/uapi/linux/can/netlink.h             |   2 +-
 include/uapi/linux/can/raw.h                 |   2 +-
 include/uapi/linux/can/vxcan.h               |   2 +-
 net/can/j1939/socket.c                       |   9 +-
 net/can/j1939/transport.c                    |  20 ++-
 23 files changed, 369 insertions(+), 138 deletions(-)



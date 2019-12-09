Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9A42A1171B4
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:33:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726495AbfLIQdA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:33:00 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:43923 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726342AbfLIQdA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 11:33:00 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1ieLxz-0001up-ER; Mon, 09 Dec 2019 17:32:59 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2019-12-08
Date:   Mon,  9 Dec 2019 17:32:43 +0100
Message-Id: <20191209163256.12000-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
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

this is a pull request of 13 patches for net/master.

The first two patches are by Dan Murphy. He adds himself as a maintainer to the
m-can MMIO and tcan SPI driver.

The next two patches the j1939 stack. The first one is by Oleksij Rempel and
fixes a locking problem found by the syzbot, the second one is by me an fixes a
mistake in the documentation.

Srinivas Neeli fixes missing RX CAN packets on CANFD2.0 in the xilinx driver.

Sean Nyekjaer fixes a possible deadlock in the the flexcan driver after
suspend/resume. Joakim Zhang contributes two patches for the flexcan driver
that fix problems with the low power enter/exit.

The next 4 patches all target the tcan part of the m_can driver. Sean Nyekjaer
adds the required delay after reset and fixes the device tree binding example.
Dan Murphy's patches make the wake-gpio optional.

In the last patch Xiaolong Huang fixes several kernel memory info leaks to the
USB device in the kvaser_usb_leaf driver.

regards,
Marc

---

The following changes since commit 0fc75219fe9a3c90631453e9870e4f6d956f0ebc:

  r8169: fix rtl_hw_jumbo_disable for RTL8168evl (2019-12-07 14:23:06 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.5-20191208

for you to fetch changes up to da2311a6385c3b499da2ed5d9be59ce331fa93e9:

  can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices (2019-12-08 12:22:01 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.5-20191208

----------------------------------------------------------------
Dan Murphy (4):
      MAINTAINERS: Add myself as a maintainer for MMIO m_can
      MAINTAINERS: Add myself as a maintainer for TCAN4x5x
      dt-bindings: tcan4x5x: Make wake-gpio an optional gpio
      can: tcan45x: Make wake-up GPIO an optional GPIO

Joakim Zhang (2):
      can: flexcan: add low power enter/exit acknowledgment helper
      can: flexcan: poll MCR_LPM_ACK instead of GPR ACK for stop mode acknowledgment

Marc Kleine-Budde (1):
      can: j1939: fix address claim code example

Oleksij Rempel (1):
      can: j1939: j1939_sk_bind(): take priv after lock is held

Sean Nyekjaer (3):
      can: flexcan: fix possible deadlock and out-of-order reception after wakeup
      can: m_can: tcan4x5x: add required delay after reset
      dt-bindings: can: tcan4x5x: reset pin is active high

Srinivas Neeli (1):
      can: xilinx_can: Fix missing Rx can packets on CANFD2.0

Xiaolong Huang (1):
      can: kvaser_usb: kvaser_usb_leaf: Fix some info-leaks to USB devices

 .../devicetree/bindings/net/can/tcan4x5x.txt       |  4 +-
 Documentation/networking/j1939.rst                 |  2 +-
 MAINTAINERS                                        |  8 +++
 drivers/net/can/flexcan.c                          | 73 +++++++++++-----------
 drivers/net/can/m_can/tcan4x5x.c                   | 26 ++++++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  6 +-
 drivers/net/can/xilinx_can.c                       |  7 +++
 net/can/j1939/socket.c                             | 10 ++-
 8 files changed, 84 insertions(+), 52 deletions(-)



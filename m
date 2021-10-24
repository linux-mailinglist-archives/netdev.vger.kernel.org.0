Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5B73438BEB
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 22:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232140AbhJXUrW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 16:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232078AbhJXUrQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 16:47:16 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2C5C061767
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 13:44:55 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mekMP-0006NL-Sk
        for netdev@vger.kernel.org; Sun, 24 Oct 2021 22:44:53 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id A6BBF69C575
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 20:43:30 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9020E69C552;
        Sun, 24 Oct 2021 20:43:28 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 09a09ddf;
        Sun, 24 Oct 2021 20:43:27 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-10-24
Date:   Sun, 24 Oct 2021 22:43:10 +0200
Message-Id: <20211024204325.3293425-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.33.0
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

The first patch is by Thomas Gleixner and makes use of
hrtimer_forward_now() in the CAN broad cast manager (bcm).

The next patch is by me and changes the type of the variables used in
the CAN bit timing calculation can_fixup_bittiming() to unsigned int.

Vincent Mailhol provides 6 patches targeting the CAN device
infrastructure. The CAN-FD specific Transmitter Delay Compensation
(TDC) is updated and configuration via the CAN netlink interface is
added.

Qing Wang's patch updates the at91 and janz-ican3 drivers to use
sysfs_emit() instead of snprintf() in the sysfs show functions.

Geert Uytterhoeven's patch drops the unneeded ARM dependency from the
rar Kconfig.

Cai Huoqing's patch converts the mscan driver to make use of the
dev_err_probe() helper function.

A patch by me against the gsusb driver changes the printf format
strings to use %u to print unsigned values.

Stephane Grosjean's patch updates the peak_usb CAN-FD driver to use
the 64 bit timestamps provided by the hardware.

The last 2 patches target the xilinx_can driver. Michal Simek provides
a patch that removes repeated word from the kernel-doc and Dongliang
Mu's patch removes a redundant netif_napi_del() from the xcan_remove()
function.

regards,
Marc

---

The following changes since commit 4d98bb0d7ec2d0b417df6207b0bafe1868bad9f8:

  net: macb: Use mdio child node for MDIO bus if it exists (2021-10-24 13:44:39 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.16-20211024

for you to fetch changes up to b9b8218bb3c064628799f83c754dbebd124bd498:

  can: xilinx_can: xcan_remove(): remove redundant netif_napi_del() (2021-10-24 16:26:05 +0200)

----------------------------------------------------------------
linux-can-next-for-5.16-20211024

----------------------------------------------------------------
Cai Huoqing (1):
      can: mscan: mpc5xxx_can: Make use of the helper function dev_err_probe()

Dongliang Mu (1):
      can: xilinx_can: xcan_remove(): remove redundant netif_napi_del()

Geert Uytterhoeven (1):
      can: rcar: drop unneeded ARM dependency

Marc Kleine-Budde (2):
      can: bittiming: can_fixup_bittiming(): change type of tseg1 and alltseg to unsigned int
      can: gs_usb: use %u to print unsigned values

Michal Simek (1):
      can: xilinx_can: remove repeated word from the kernel-doc

Qing Wang (1):
      can: at91/janz-ican3: replace snprintf() in show functions with sysfs_emit()

Stephane Grosjean (1):
      can: peak_usb: CANFD: store 64-bits hw timestamps

Thomas Gleixner (1):
      can: bcm: Use hrtimer_forward_now()

Vincent Mailhol (6):
      can: bittiming: allow TDC{V,O} to be zero and add can_tdc_const::tdc{v,o,f}_min
      can: bittiming: change unit of TDC parameters to clock periods
      can: bittiming: change can_calc_tdco()'s prototype to not directly modify priv
      can: netlink: add interface for CAN-FD Transmitter Delay Compensation (TDC)
      can: netlink: add can_priv::do_get_auto_tdcv() to retrieve tdcv from device
      can: dev: add can_tdc_get_relative_tdco() helper function

 drivers/net/can/at91_can.c                   |   4 +-
 drivers/net/can/dev/bittiming.c              |  30 ++--
 drivers/net/can/dev/netlink.c                | 221 ++++++++++++++++++++++++++-
 drivers/net/can/janz-ican3.c                 |   2 +-
 drivers/net/can/mscan/mpc5xxx_can.c          |   6 +-
 drivers/net/can/rcar/Kconfig                 |   4 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c    |   7 +-
 drivers/net/can/usb/gs_usb.c                 |  12 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c |  13 ++
 drivers/net/can/usb/peak_usb/pcan_usb_core.h |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c   |   9 +-
 drivers/net/can/xilinx_can.c                 |   7 +-
 include/linux/can/bittiming.h                |  89 ++++++++---
 include/linux/can/dev.h                      |  34 +++++
 include/uapi/linux/can/netlink.h             |  31 +++-
 net/can/bcm.c                                |   2 +-
 16 files changed, 402 insertions(+), 70 deletions(-)



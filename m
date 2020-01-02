Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47E9D12E871
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 17:09:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728787AbgABQJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 11:09:38 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:49037 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728678AbgABQJi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 11:09:38 -0500
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1in32W-0000mM-I9; Thu, 02 Jan 2020 17:09:36 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2020-01-02
Date:   Thu,  2 Jan 2020 17:09:25 +0100
Message-Id: <20200102160934.1524-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.24.1
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

this is a pull request of 9 patches for net/master.

The first 5 patches target all the tcan4x5x driver. The first 3 patches
of them are by Dan Murphy and Sean Nyekjaer and improve the device
initialization (power on, reset and get device out of standby before
register access). The next patch is by Dan Murphy and disables the INH
pin device-state if the GPIO is unavailable. The last patch for the
tcan4x5x driver is by Gustavo A. R. Silva and fixes an inconsistent
PTR_ERR check in the tcan4x5x_parse_config() function.

The next patch is by Oliver Hartkopp and targets the generic CAN device
infrastructure. It ensures that an initialized headroom in outgoing CAN
sk_buffs (e.g. if injected by AF_PACKET).

The last 2 patches are by Johan Hovold and fix the kvaser_usb and gs_usb
drivers by always using the current alternate setting not blindly the
first one.

regards,
Marc

---

The following changes since commit 738d2902773e30939a982c8df7a7f94293659810:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2019-12-31 11:14:58 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.5-20200102

for you to fetch changes up to 2d77bd61a2927be8f4e00d9478fe6996c47e8d45:

  can: mscan: mscan_rx_poll(): fix rx path lockup when returning from polling to irq mode (2020-01-02 15:34:27 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.5-20200102

----------------------------------------------------------------
Dan Murphy (2):
      can: tcan4x5x: tcan4x5x_can_probe(): turn on the power before parsing the config
      can: tcan4x5x: tcan4x5x_parse_config(): Disable the INH pin device-state GPIO is unavailable

Florian Faber (1):
      can: mscan: mscan_rx_poll(): fix rx path lockup when returning from polling to irq mode

Gustavo A. R. Silva (1):
      can: tcan4x5x: tcan4x5x_parse_config(): fix inconsistent IS_ERR and PTR_ERR

Johan Hovold (2):
      can: kvaser_usb: fix interface sanity check
      can: gs_usb: gs_usb_probe(): use descriptors of current altsetting

Oliver Hartkopp (1):
      can: can_dropped_invalid_skb(): ensure an initialized headroom in outgoing CAN sk_buffs

Sean Nyekjaer (2):
      can: tcan4x5x: tcan4x5x_can_probe(): get the device out of standby before register access
      can: tcan4x5x: tcan4x5x_parse_config(): reset device before register access

 drivers/net/can/m_can/tcan4x5x.c                  | 63 +++++++++++++++++++----
 drivers/net/can/mscan/mscan.c                     | 21 ++++----
 drivers/net/can/usb/gs_usb.c                      |  4 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |  2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  |  2 +-
 include/linux/can/dev.h                           | 34 ++++++++++++
 6 files changed, 101 insertions(+), 25 deletions(-)



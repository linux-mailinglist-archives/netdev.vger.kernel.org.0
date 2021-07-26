Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 509163D5B09
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 16:12:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234253AbhGZNbd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 09:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234219AbhGZNb0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Jul 2021 09:31:26 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6FEC061757
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 07:11:54 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m81Kj-0000h7-C8
        for netdev@vger.kernel.org; Mon, 26 Jul 2021 16:11:53 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CDF8A658179
        for <netdev@vger.kernel.org>; Mon, 26 Jul 2021 14:11:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 524BB658158;
        Mon, 26 Jul 2021 14:11:46 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d44d4912;
        Mon, 26 Jul 2021 14:11:45 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-07-25
Date:   Mon, 26 Jul 2021 16:10:58 +0200
Message-Id: <20210726141144.862529-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.2
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

this is a pull request of 46 patches for net-next/master.

The first 6 patches target the CAN J1939 protocol. One is from
gushengxian, fixing a grammatical error, 5 are by me fixing a checkpatch
warning, make use of the fallthrough pseudo-keyword, and use
consistent variable naming.

The next 3 patches target the rx-offload helper, are by me and improve
the performance and fix the local softirq work pending error, when
napi_schedule() is called from threaded IRQ context.

The next 3 patches are by Vincent Mailhol and me update the CAN
bittiming and transmitter delay compensation, the documentation for
the struct can_tdc is fixed, clear data_bittiming if FD mode is turned
off and a redundant check is removed.

Followed by 4 patches targeting the m_can driver. Faiz Abbas's patches
add support for CAN PHY via the generic phy subsystem. Yang Yingliang
converts the driver to use devm_platform_ioremap_resource_byname().
And a patch by me which removes the unused support for custom bit
timing.

Andy Shevchenko contributes 2 patches for the mcp251xfd driver to
prepare the driver for ACPI support. A patch by me adds support for
shared IRQ handlers.

Zhen Lei contributes 3 patches to convert the esd_usb2, janz-ican3 and
the at91_can driver to make use of the DEVICE_ATTR_RO/RW() macros.

The next 8 patches are by Peng Li and provide general cleanups for the
at91_can driver.

The next 7 patches target the peak driver. Frist 2 cleanup patches by
me for the peak_pci driver, followed by Stephane Grosjean' patch to
print the name and firmware version of the detected hardware. The
peak_usb driver gets a cleanup patch, loopback and one-shot mode and
an upgrading of the bus state change handling in Stephane Grosjean's
patches.

Vincent Mailhol provides 6 cleanup patches for the etas_es58x driver.

In the last 3 patches Angelo Dureghello add support for the mcf5441x
SoC to the flexcan driver.

regards,
Marc

---

The following changes since commit 0e804326759de7b9991353dd66b03595b5c3f544:

  Merge branch 'nfc-const' (2021-07-25 09:21:32 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.15-20210725

for you to fetch changes up to 8dad5561c13ade87238d9de6dd410b43f7562447:

  can: flexcan: update Kconfig to enable coldfire (2021-07-25 11:36:29 +0200)

----------------------------------------------------------------
linux-can-next-for-5.15-20210725

----------------------------------------------------------------
Andy Shevchenko (2):
      can: mcp251xfd: mcp251xfd_probe(): try to get crystal clock rate from property
      can: mcp251xfd: Fix header block to clarify independence from OF

Angelo Dureghello (3):
      can: flexcan: add platform data header
      can: flexcan: add mcf5441x support
      can: flexcan: update Kconfig to enable coldfire

Faiz Abbas (2):
      dt-bindings: net: can: Document transceiver implementation as phy
      can: m_can: Add support for transceiver as phy

Marc Kleine-Budde (13):
      can: j1939: fix checkpatch warnings
      can: j1939: replace fall through comment by fallthrough pseudo-keyword
      can: j1939: j1939_session_completed(): use consistent name se_skb for the session skb
      can: j1939: j1939_session_tx_dat(): use consistent name se_skcb for session skb control buffer
      can: j1939: j1939_xtp_rx_dat_one(): use separate pointer for session skb control buffer
      can: rx-offload: add skb queue for use during ISR
      can: rx-offload: can_rx_offload_irq_finish(): directly call napi_schedule()
      can: rx-offload: can_rx_offload_threaded_irq_finish(): add new function to be called from threaded interrupt
      can: bittiming: fix documentation for struct can_tdc
      can: m_can: remove support for custom bit timing
      can: mcp251xfd: mcp251xfd_open(): request IRQ as shared
      can: peak_pci: convert comments to network style comments
      can: peak_pci: fix checkpatch warnings

Peng Li (8):
      net: at91_can: remove redundant blank lines
      net: at91_can: add blank line after declarations
      net: at91_can: fix the code style issue about macro
      net: at91_can: use BIT macro
      net: at91_can: fix the alignment issue
      net: at91_can: add braces {} to all arms of the statement
      net: at91_can: remove redundant space
      net: at91_can: fix the comments style issue

Stephane Grosjean (5):
      can: peak_pci: Add name and FW version of the card in kernel buffer
      can: peak_usb: pcan_usb_get_device_id(): read value only in case of success
      can: peak_usb: PCAN-USB: add support of loopback and one-shot mode
      can: peak_usb: pcan_usb_encode_msg(): add information
      can: peak_usb: pcan_usb_decode_error(): upgrade handling of bus state changes

Vincent Mailhol (8):
      can: netlink: clear data_bittiming if FD is turned off
      can: netlink: remove redundant check in can_validate()
      can: etas_es58x: fix three typos in author name and documentation
      can: etas_es58x: use error pointer during device probing
      can: etas_es58x: use devm_kzalloc() to allocate device resources
      can: etas_es58x: add es58x_free_netdevs() to factorize code
      can: etas_es58x: use sizeof and sizeof_field macros instead of constant values
      can: etas_es58x: rewrite the message cast in es58{1,_fd}_tx_can_msg to increase readability

Yang Yingliang (1):
      can: m_can: use devm_platform_ioremap_resource_byname

Zhen Lei (3):
      can: esd_usb2: use DEVICE_ATTR_RO() helper macro
      can: janz-ican3: use DEVICE_ATTR_RO/RW() helper macro
      can: at91_can: use DEVICE_ATTR_RW() helper macro

gushengxian (1):
      can: j1939: j1939_sk_sock_destruct(): correct a grammatical error

 .../devicetree/bindings/net/can/bosch,m_can.yaml   |   3 +
 drivers/net/can/Kconfig                            |   3 +-
 drivers/net/can/at91_can.c                         | 137 ++++++-------
 drivers/net/can/dev/netlink.c                      |   9 +-
 drivers/net/can/dev/rx-offload.c                   |  90 +++++---
 drivers/net/can/flexcan.c                          | 127 ++++++++++--
 drivers/net/can/janz-ican3.c                       |  23 +--
 drivers/net/can/m_can/m_can.c                      |  38 ++--
 drivers/net/can/m_can/m_can.h                      |   5 +-
 drivers/net/can/m_can/m_can_platform.c             |  16 +-
 drivers/net/can/sja1000/peak_pci.c                 | 119 ++++++-----
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |  28 ++-
 drivers/net/can/ti_hecc.c                          |   2 +
 drivers/net/can/usb/esd_usb2.c                     |  12 +-
 drivers/net/can/usb/etas_es58x/es581_4.c           |   5 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c        |  82 ++++----
 drivers/net/can/usb/etas_es58x/es58x_core.h        |   2 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |  19 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            | 228 +++++++++------------
 include/linux/can/bittiming.h                      |   4 +-
 include/linux/can/platform/flexcan.h               |  23 +++
 include/linux/can/rx-offload.h                     |   8 +-
 net/can/j1939/socket.c                             |   2 +-
 net/can/j1939/transport.c                          |  42 ++--
 24 files changed, 584 insertions(+), 443 deletions(-)
 create mode 100644 include/linux/can/platform/flexcan.h



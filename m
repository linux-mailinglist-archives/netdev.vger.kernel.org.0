Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31F873F1A96
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 15:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240040AbhHSNj6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 09:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239922AbhHSNj5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 09:39:57 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D03DAC061756
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 06:39:20 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGiGN-0004FJ-A7
        for netdev@vger.kernel.org; Thu, 19 Aug 2021 15:39:19 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id EAF6766A7D4
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 13:39:17 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D16B966A7CE;
        Thu, 19 Aug 2021 13:39:16 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 372fd788;
        Thu, 19 Aug 2021 13:39:15 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-08-19
Date:   Thu, 19 Aug 2021 15:38:51 +0200
Message-Id: <20210819133913.657715-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.32.0
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

this is a pull request of 22 patches for net-next/master.

The first patch is by me, for the mailmap file and maps the email
address of two former ESD employees to a newly created role account.

The next 3 patches are by Oleksij Rempel and add support for GPIO
based switchable CAN bus termination.

The next 3 patches are by Vincent Mailhol. The first one changes the
CAN netlink interface to not bail out if the user switched off
unsupported features. The next one adds Vincent as the maintainer of
the etas_es58x driver and the last one cleans up the documentation of
struct es58x_fd_tx_conf_msg.

The next patch is by me, for the mcp251xfd driver and marks some
instances of struct mcp251xfd_priv as const. Lad Prabhakar contributes
2 patches for the rcar_canfd driver, that add support for RZ/G2L
family.

The next 5 patches target the m_can/tcan45x5 driver. 2 are by me an
fix trivial checkpatch warnings. The remaining 3 patches are by Matt
Kline and improve the performance on the SPI based tcan4x5x chip by
batching FIFO reads and writes.

The last 7 patches are for the c_can driver. Dario Binacchi's patch
converts the DT bindings to yaml, 2 patches by me fix a typo and
rename a macro to properly represent the usage. The last 4 patches are
again by Dario Binacchi and provide a performance improvement for the
TX path by operating the TX mailboxes as a true FIFO.

regards,
Marc

---

The following changes since commit 19b8ece42c56aaa122f7e91eb391bb3dd7e193cd:

  net/mlx4: Use ARRAY_SIZE to get an array's size (2021-08-18 15:16:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.15-20210819

for you to fetch changes up to 387da6bc7a826cc6d532b1c0002b7c7513238d5f:

  can: c_can: cache frames to operate as a true FIFO (2021-08-19 15:07:06 +0200)

----------------------------------------------------------------
linux-can-next-for-5.15-20210819

----------------------------------------------------------------
Dario Binacchi (5):
      dt-bindings: net: can: c_can: convert to json-schema
      can: c_can: remove struct c_can_priv::priv field
      can: c_can: exit c_can_do_tx() early if no frames have been sent
      can: c_can: support tx ring algorithm
      can: c_can: cache frames to operate as a true FIFO

Lad Prabhakar (2):
      dt-bindings: net: can: renesas,rcar-canfd: Document RZ/G2L SoC
      can: rcar_canfd: Add support for RZ/G2L family

Marc Kleine-Budde (6):
      mailmap: update email address of Matthias Fuchs and Thomas Körper
      can: mcp251xfd: mark some instances of struct mcp251xfd_priv as const
      can: tcan4x5x: cdev_to_priv(): remove stray empty line
      can: m_can: fix block comment style
      can: c_can: c_can_do_tx(): fix typo in comment
      can: c_can: rename IF_RX -> IF_NAPI

Matt Kline (3):
      can: m_can: Disable IRQs on FIFO bus errors
      can: m_can: Batch FIFO reads during CAN receive
      can: m_can: Batch FIFO writes during CAN transmit

Oleksij Rempel (3):
      dt-bindings: can-controller: add support for termination-gpios
      dt-bindings: can: fsl,flexcan: enable termination-* bindings
      can: dev: provide optional GPIO based termination support

Vincent Mailhol (3):
      can: netlink: allow user to turn off unsupported features
      MAINTAINERS: add Vincent MAILHOL as maintainer for the ETAS ES58X CAN/USB driver
      can: etas_es58x: clean-up documentation of struct es58x_fd_tx_conf_msg

 .mailmap                                           |   2 +
 .../devicetree/bindings/net/can/bosch,c_can.yaml   | 119 ++++++++
 .../devicetree/bindings/net/can/c_can.txt          |  65 ----
 .../bindings/net/can/can-controller.yaml           |   9 +
 .../devicetree/bindings/net/can/fsl,flexcan.yaml   |  17 ++
 .../bindings/net/can/renesas,rcar-canfd.yaml       |  69 ++++-
 MAINTAINERS                                        |   6 +
 drivers/net/can/c_can/c_can.h                      |  25 +-
 drivers/net/can/c_can/c_can_main.c                 | 123 +++++---
 drivers/net/can/c_can/c_can_platform.c             |   1 -
 drivers/net/can/dev/dev.c                          |  66 ++++
 drivers/net/can/dev/netlink.c                      |   2 +-
 drivers/net/can/m_can/m_can.c                      | 228 +++++++++-----
 drivers/net/can/m_can/m_can.h                      |   6 +-
 drivers/net/can/m_can/m_can_pci.c                  |  11 +-
 drivers/net/can/m_can/m_can_platform.c             |  15 +-
 drivers/net/can/m_can/tcan4x5x-core.c              |  17 +-
 drivers/net/can/rcar/rcar_canfd.c                  | 338 ++++++++++++++++-----
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   2 +-
 .../net/can/spi/mcp251xfd/mcp251xfd-timestamp.c    |   4 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   2 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.h          |  23 +-
 include/linux/can/dev.h                            |   8 +
 23 files changed, 852 insertions(+), 306 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,c_can.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/c_can.txt



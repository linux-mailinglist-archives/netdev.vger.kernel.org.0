Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10BCB48864A
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 22:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbiAHVnz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Jan 2022 16:43:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231148AbiAHVnz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Jan 2022 16:43:55 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C196BC061401
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 13:43:54 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6JVB-0004AL-5B
        for netdev@vger.kernel.org; Sat, 08 Jan 2022 22:43:53 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E3B4B6D3A28
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 21:43:48 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1AEFE6D3A06;
        Sat,  8 Jan 2022 21:43:47 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 2cacaeb4;
        Sat, 8 Jan 2022 21:43:46 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/22] pull-request: can-next 2022-01-08
Date:   Sat,  8 Jan 2022 22:43:23 +0100
Message-Id: <20220108214345.1848470-1-mkl@pengutronix.de>
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

this is a pull request of 22 patches for net-next/master.

The first patch is by Tom Rix and fixes an uninitialized variable in
the janz-ican3 driver (introduced in linux-can-next-for-5.17-20220105).

The next 13 patches are by my and target the mcp251xfd driver. First
several cleanup patches, then the driver is prepared for the upcoming
ethtool ring parameter and IRQ coalescing support, which is added in a
later pull request.

The remaining 8 patches are by Dario Binacchi and me and enhance the
flexcan driver. The driver is moved into a sub directory. An ethtool
private flag is added to optionally disable CAN RTR frame reception,
to make use of more RX buffers. The resulting RX buffer configuration
can be read by ethtool ring parameter support. Finally documentation
for the ethtool private flag is added to the
Documentation/networking/device_drivers/can directory.

regards,
Marc

---

The following changes since commit 82192cb497f9eca6c0d44dbc173e68d59ea2f3c9:

  Merge branch 'ena-capabilities-field-and-cosmetic-changes' (2022-01-07 19:25:58 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.17-20220108

for you to fetch changes up to bc3897f79f7901902bb44d62dd1ad1b2b48e9378:

  docs: networking: device drivers: can: add flexcan (2022-01-08 21:22:58 +0100)

----------------------------------------------------------------
linux-can-next-for-5.17-20220108

----------------------------------------------------------------
Dario Binacchi (4):
      can: flexcan: allow to change quirks at runtime
      can: flexcan: add ethtool support to get rx/tx ring parameters
      docs: networking: device drivers: add can sub-folder
      docs: networking: device drivers: can: add flexcan

Marc Kleine-Budde (17):
      can: mcp251xfd: remove double blank lines
      can: mcp251xfd: mcp251xfd_tef_obj_read(): fix typo in error message
      can: mcp251xfd: add missing newline to printed strings
      can: mcp251xfd: mcp251xfd_open(): open_candev() first
      can: mcp251xfd: mcp251xfd_open(): make use of pm_runtime_resume_and_get()
      can: mcp251xfd: mcp251xfd_handle_rxovif(): denote RX overflow message to debug + add rate limiting
      can: mcp251xfd: mcp251xfd.h: sort function prototypes
      can: mcp251xfd: move RX handling into separate file
      can: mcp251xfd: move TX handling into separate file
      can: mcp251xfd: move TEF handling into separate file
      can: mcp251xfd: move chip FIFO init into separate file
      can: mcp251xfd: move ring init into separate function
      can: mcp251xfd: introduce and make use of mcp251xfd_is_fd_mode()
      can: flexcan: move driver into separate sub directory
      can: flexcan: rename RX modes
      can: flexcan: add more quirks to describe RX path capabilities
      can: flexcan: add ethtool support to change rx-rtr setting during runtime

Tom Rix (1):
      can: janz-ican3: initialize dlc variable

 .../device_drivers/can/freescale/flexcan.rst       |   54 +
 .../networking/device_drivers/can/index.rst        |   20 +
 Documentation/networking/device_drivers/index.rst  |    1 +
 drivers/net/can/Makefile                           |    2 +-
 drivers/net/can/flexcan/Makefile                   |    7 +
 .../net/can/{flexcan.c => flexcan/flexcan-core.c}  |  234 ++---
 drivers/net/can/flexcan/flexcan-ethtool.c          |  114 +++
 drivers/net/can/flexcan/flexcan.h                  |  163 +++
 drivers/net/can/janz-ican3.c                       |    2 +-
 drivers/net/can/spi/mcp251xfd/Makefile             |    5 +
 .../net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c    |  119 +++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     | 1083 +-------------------
 drivers/net/can/spi/mcp251xfd/mcp251xfd-regmap.c   |    1 -
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |  269 +++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c       |  260 +++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c      |  260 +++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c       |  205 ++++
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |   36 +-
 18 files changed, 1621 insertions(+), 1214 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/can/freescale/flexcan.rst
 create mode 100644 Documentation/networking/device_drivers/can/index.rst
 create mode 100644 drivers/net/can/flexcan/Makefile
 rename drivers/net/can/{flexcan.c => flexcan/flexcan-core.c} (90%)
 create mode 100644 drivers/net/can/flexcan/flexcan-ethtool.c
 create mode 100644 drivers/net/can/flexcan/flexcan.h
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-chip-fifo.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-rx.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-tef.c
 create mode 100644 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c



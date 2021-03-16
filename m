Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8540833CF9E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 09:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234450AbhCPIVh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 04:21:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234391AbhCPIVM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 04:21:12 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCB04C06174A
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 01:21:11 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lM4wv-0002wt-TG
        for netdev@vger.kernel.org; Tue, 16 Mar 2021 09:21:10 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 9959E5F641E
        for <netdev@vger.kernel.org>; Tue, 16 Mar 2021 08:21:07 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 35F7F5F640E;
        Tue, 16 Mar 2021 08:21:06 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7d61a76b;
        Tue, 16 Mar 2021 08:21:05 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-03-16
Date:   Tue, 16 Mar 2021 09:20:53 +0100
Message-Id: <20210316082104.4027260-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.30.1
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

this is a pull request of 11 patches for net/master.

The first patch is by Martin Willi and fixes the deletion of network
name spaces with physical CAN interfaces in them.

The next two patches are by me an fix the ISOTP protocol, to ensure
that unused flags in classical CAN frames are properly initialized to
zero.

Stephane Grosjean contributes a patch for the pcan_usb_fd driver,
which add MODULE_SUPPORTED_DEVICE lines for two supported devices.

Angelo Dureghello's patch for the flexcan driver fixes a potential div
by zero, if the bitrate is not set during driver probe.

Jimmy Assarsson's patch for the kvaser_pciefd disables bus load
reporting in the device, if it was previously enabled by the vendor's
out of tree drier. A patch for the kvaser_usb adds support for a new
device, by adding the appropriate USB product ID.

Tong Zhang contributes two patches for the c_can driver. First a
use-after-free in the c_can_pci driver is fixed, in the second patch
the runtime PM for the c_can_pci is fixed by moving the runtime PM
enable/disable from the core driver to the platform driver.

The last two patches are by Torin Cooper-Bennun for the m_can driver.
First a extraneous msg loss warning is removed then he fixes the
RX-path, which might be blocked by errors.

regards,
Marc

---

The following changes since commit 13832ae2755395b2585500c85b64f5109a44227e:

  mptcp: fix ADD_ADDR HMAC in case port is specified (2021-03-15 16:43:01 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.12-20210316

for you to fetch changes up to e98d9ee64ee2cc9b1d1a8e26610ec4d0392ebe50:

  can: m_can: m_can_rx_peripheral(): fix RX being blocked by errors (2021-03-16 08:41:27 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.12-20210316

----------------------------------------------------------------
Angelo Dureghello (1):
      can: flexcan: flexcan_chip_freeze(): fix chip freeze for missing bitrate

Jimmy Assarsson (2):
      can: kvaser_pciefd: Always disable bus load reporting
      can: kvaser_usb: Add support for USBcan Pro 4xHS

Marc Kleine-Budde (2):
      can: isotp: isotp_setsockopt(): only allow to set low level TX flags for CAN-FD
      can: isotp: TX-path: ensure that CAN frame flags are initialized

Martin Willi (1):
      can: dev: Move device back to init netns on owning netns delete

Stephane Grosjean (1):
      can: peak_usb: add forgotten supported devices

Tong Zhang (2):
      can: c_can_pci: c_can_pci_remove(): fix use-after-free
      can: c_can: move runtime PM enable/disable to c_can_platform

Torin Cooper-Bennun (2):
      can: m_can: m_can_do_rx_poll(): fix extraneous msg loss warning
      can: m_can: m_can_rx_peripheral(): fix RX being blocked by errors

 drivers/net/can/c_can/c_can.c                    | 24 +-----------------------
 drivers/net/can/c_can/c_can_pci.c                |  3 ++-
 drivers/net/can/c_can/c_can_platform.c           |  6 +++++-
 drivers/net/can/dev/netlink.c                    |  1 +
 drivers/net/can/flexcan.c                        |  8 +++++++-
 drivers/net/can/kvaser_pciefd.c                  |  4 ++++
 drivers/net/can/m_can/m_can.c                    |  5 +----
 drivers/net/can/usb/Kconfig                      |  1 +
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |  4 +++-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c       |  2 ++
 include/net/rtnetlink.h                          |  2 ++
 net/can/isotp.c                                  | 12 +++++-------
 net/core/dev.c                                   |  2 +-
 13 files changed, 35 insertions(+), 39 deletions(-)




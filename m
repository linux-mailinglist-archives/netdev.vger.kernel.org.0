Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E70272C8651
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 15:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgK3OPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 09:15:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725925AbgK3OPU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 09:15:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAD72C0613D2
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 06:14:39 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kjjws-0007Xu-Em
        for netdev@vger.kernel.org; Mon, 30 Nov 2020 15:14:38 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 348FC59FAD0
        for <netdev@vger.kernel.org>; Mon, 30 Nov 2020 14:14:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 1E5BD59FABF;
        Mon, 30 Nov 2020 14:14:34 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d205ae2a;
        Mon, 30 Nov 2020 14:14:33 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2020-11-30
Date:   Mon, 30 Nov 2020 15:14:18 +0100
Message-Id: <20201130141432.278219-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
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

here's a pull request of 14 patches for net-next/master.

Gustavo A. R. Silva's patch for the pcan_usb driver fixes fall-through warnings 
for Clang.

The next 5 patches target the mcp251xfd driver and are by Ursula Maplehurst and 
me. They optimizie the TEF and RX path by reducing number of SPI core requests
to set the UINC bit.

The remaining 8 patches target the m_can driver. The first 4 are various
cleanups for the SPI binding driver (tcan4x5x) by Sean Nyekjaer, Dan Murphy and
me. Followed by 4 cleanup patches by me for the m_can and m_can_platform
driver.

regards,
Marc

---

The following changes since commit e71d2b957ee49fe3ed35a384a4e31774de1316c1:

  Merge branch 'net-ipa-start-adding-ipa-v4-5-support' (2020-11-28 12:14:02 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.11-20201130

for you to fetch changes up to 6d9986b46fc12f4a36fc243698deb774323b76f3:

  can: m_can: m_can_class_unregister(): move right after m_can_class_register() (2020-11-30 14:55:41 +0100)

----------------------------------------------------------------
linux-can-next-for-5.11-20201130

----------------------------------------------------------------
Dan Murphy (1):
      can: tcan4x5x: rename parse_config() function

Gustavo A. R. Silva (1):
      can: pcan_usb_core: fix fall-through warnings for Clang

Marc Kleine-Budde (10):
      can: mcp251xfd: mcp25xxfd_ring_alloc(): add define instead open coding the maximum number of RX objects
      can: mcp251xfd: struct mcp251xfd_priv::tef to array of length 1
      can: mcp251xfd: move struct mcp251xfd_tef_ring definition
      can: mcp251xfd: tef-path: reduce number of SPI core requests to set UINC bit
      can: tcan4x5x: remove mram_start and reg_offset from struct tcan4x5x_priv
      can: tcan4x5x: tcan4x5x_can_probe(): remove probe failed error message
      can: m_can: Kconfig: convert the into menu
      can: m_can: remove not used variable struct m_can_classdev::freq
      can: m_can: m_can_plat_remove(): remove unneeded platform_set_drvdata()
      can: m_can: m_can_class_unregister(): move right after m_can_class_register()

Sean Nyekjaer (1):
      can: tcan4x5x: tcan4x5x_clear_interrupts(): remove redundant return statement

Ursula Maplehurst (1):
      can: mcp25xxfd: rx-path: reduce number of SPI core requests to set UINC bit

 drivers/net/can/m_can/Kconfig                  |   8 +-
 drivers/net/can/m_can/m_can.c                  |  16 +--
 drivers/net/can/m_can/m_can.h                  |   1 -
 drivers/net/can/m_can/m_can_platform.c         |   2 -
 drivers/net/can/m_can/tcan4x5x.c               |  28 ++---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 136 +++++++++++++++++++------
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h      |  30 +++---
 drivers/net/can/usb/peak_usb/pcan_usb_core.c   |   9 +-
 8 files changed, 151 insertions(+), 79 deletions(-)



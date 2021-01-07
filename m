Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 605E12ECDEF
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 11:35:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727209AbhAGKfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 05:35:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726371AbhAGKfh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 05:35:37 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22DCDC0612F5
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 02:34:57 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxSd5-0008MA-O9
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 11:34:55 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id AC6C85BBC84
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 10:34:53 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 069185BBC7A;
        Thu,  7 Jan 2021 10:34:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 446a9442;
        Thu, 7 Jan 2021 10:34:52 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-01-07
Date:   Thu,  7 Jan 2021 11:34:45 +0100
Message-Id: <20210107103451.183477-1-mkl@pengutronix.de>
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

this is a pull request of 6 patches for net/master.

The first patch is by me for the m_can driver and removes an erroneous
m_can_clk_stop() from the driver's unregister function.

The second patch targets the tcan4x5x driver, is by me, and fixes the bit
timing constant parameters.

The next two patches are by me, target the mcp251xfd driver, and fix a race
condition in the optimized TEF path (which was added in net-next for v5.11).
The similar code in the RX path is changed to look the same, although it
doesn't suffer from the race condition.

A patch by Lad Prabhakar updates the description and help text for the rcar CAN
driver to reflect all supported SoCs.

In the last patch Sriram Dash transfers the maintainership of the m_can driver
to Pankaj Sharma.

regards,
Marc

---

The following changes since commit 1f685e6adbbe3c7b1bd9053be771b898d9efa655:

  ptp: ptp_ines: prevent build when HAS_IOMEM is not set (2021-01-06 16:17:23 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.11-20210107

for you to fetch changes up to 6ee49118f87cf02b36f68812bc49855b7b627a2b:

  MAINTAINERS: Update MCAN MMIO device driver maintainer (2021-01-07 11:02:10 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.11-20210107

----------------------------------------------------------------
Lad Prabhakar (1):
      can: rcar: Kconfig: update help description for CAN_RCAR config

Marc Kleine-Budde (4):
      can: m_can: m_can_class_unregister(): remove erroneous m_can_clk_stop()
      can: tcan4x5x: fix bittiming const, use common bittiming from m_can driver
      can: mcp251xfd: mcp251xfd_handle_tefif(): fix TEF vs. TX race condition
      can: mcp251xfd: mcp251xfd_handle_rxif_ring(): first increment RX tail pointer in HW, then in driver

Sriram Dash (1):
      MAINTAINERS: Update MCAN MMIO device driver maintainer

 MAINTAINERS                                    |  2 +-
 drivers/net/can/m_can/m_can.c                  |  2 --
 drivers/net/can/m_can/tcan4x5x.c               | 26 --------------------------
 drivers/net/can/rcar/Kconfig                   |  4 ++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c | 17 ++++++++---------
 5 files changed, 11 insertions(+), 40 deletions(-)



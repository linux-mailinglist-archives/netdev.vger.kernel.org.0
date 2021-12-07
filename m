Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 685FB46B8D6
	for <lists+netdev@lfdr.de>; Tue,  7 Dec 2021 11:24:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbhLGK2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Dec 2021 05:28:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbhLGK2S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Dec 2021 05:28:18 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 704B1C061574
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 02:24:48 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muXeQ-0003Ee-V7
        for netdev@vger.kernel.org; Tue, 07 Dec 2021 11:24:47 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id E79D06BE8B1
        for <netdev@vger.kernel.org>; Tue,  7 Dec 2021 10:24:43 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D22526BE8A0;
        Tue,  7 Dec 2021 10:24:42 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d69f9be4;
        Tue, 7 Dec 2021 10:24:26 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/9] pull-request: can 2021-12-07
Date:   Tue,  7 Dec 2021 11:24:11 +0100
Message-Id: <20211207102420.120131-1-mkl@pengutronix.de>
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

this is a pull request of 9 patches for net/master.

The 1st patch is by Vincent Mailhol and fixes a use after free in the
pch_can driver.

Dan Carpenter fixes a use after free in the ems_pcmcia sja1000 driver.

The remaining 7 patches target the m_can driver. Brian Silverman
contributes a patch to disable and ignore the ELO interrupt, which is
currently not handled in the driver and may lead to an interrupt
storm. Vincent Mailhol's patch fixes a memory leak in the error path
of the m_can_read_fifo() function. The remaining patches are
contributed by Matthias Schiffer, first a iomap_read_fifo() and
iomap_write_fifo() functions are fixed in the PCI glue driver, then
the clock rate for the Intel Ekhart Lake platform is fixed, the last 3
patches add support for the custom bit timings on the Elkhart Lake
platform.

regards,
Marc

---

The following changes since commit 4dbb0dad8e63fcd0b5a117c2861d2abe7ff5f186:

  devlink: fix netns refcount leak in devlink_nl_cmd_reload() (2021-12-06 16:56:32 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.16-20211207

for you to fetch changes up to ea4c1787685dbf9842046f05b6390b6901ee6ba2:

  can: m_can: pci: use custom bit timings for Elkhart Lake (2021-12-07 09:51:41 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.16-20211207

----------------------------------------------------------------
Brian Silverman (1):
      can: m_can: Disable and ignore ELO interrupt

Dan Carpenter (1):
      can: sja1000: fix use after free in ems_pcmcia_add_card()

Matthias Schiffer (5):
      can: m_can: pci: fix iomap_read_fifo() and iomap_write_fifo()
      can: m_can: pci: fix incorrect reference clock rate
      Revert "can: m_can: remove support for custom bit timing"
      can: m_can: make custom bittiming fields const
      can: m_can: pci: use custom bit timings for Elkhart Lake

Vincent Mailhol (2):
      can: pch_can: pch_can_rx_normal: fix use after free
      can: m_can: m_can_read_fifo: fix memory leak in error branch

 drivers/net/can/m_can/m_can.c        | 42 +++++++++++++++---------
 drivers/net/can/m_can/m_can.h        |  3 ++
 drivers/net/can/m_can/m_can_pci.c    | 62 ++++++++++++++++++++++++++++++++----
 drivers/net/can/pch_can.c            |  2 +-
 drivers/net/can/sja1000/ems_pcmcia.c |  7 +++-
 5 files changed, 93 insertions(+), 23 deletions(-)



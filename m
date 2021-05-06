Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 903AF375049
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 09:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233537AbhEFHlW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 03:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233524AbhEFHlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 03:41:20 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7B18C06174A
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 00:40:22 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1leYcP-0003By-Dp
        for netdev@vger.kernel.org; Thu, 06 May 2021 09:40:21 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id ED96D61DD7C
        for <netdev@vger.kernel.org>; Thu,  6 May 2021 07:40:18 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 04DA061DD6C;
        Thu,  6 May 2021 07:40:18 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 3d0cd145;
        Thu, 6 May 2021 07:40:17 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-05-06
Date:   Thu,  6 May 2021 09:40:11 +0200
Message-Id: <20210506074015.1300591-1-mkl@pengutronix.de>
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

this is a pull request of 4 patches for net/master.

The first two patches target the mcp251xfd driver. Dan Carpenter's
patch fixes a NULL pointer dereference in the probe function's error
path. A patch by me adds the missing can_rx_offload_del() in error
path of the probe function.

Frieder Schrempf contributes a patch for the mcp251x driver, the patch
fixes the resume from sleep before interface was brought up.

The last patch is by me and fixes a race condition in the TX path of
the m_can driver for peripheral (SPI) based m_can cores.

regards,
Marc

---

The following changes since commit 8621436671f3a4bba5db57482e1ee604708bf1eb:

  smc: disallow TCP_ULP in smc_setsockopt() (2021-05-05 12:52:45 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.13-20210506

for you to fetch changes up to e04b2cfe61072c7966e1a5fb73dd1feb30c206ed:

  can: m_can: m_can_tx_work_queue(): fix tx_skb race condition (2021-05-06 09:24:07 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.13-20210506

----------------------------------------------------------------
Dan Carpenter (1):
      can: mcp251xfd: mcp251xfd_probe(): fix an error pointer dereference in probe

Frieder Schrempf (1):
      can: mcp251x: fix resume from sleep before interface was brought up

Marc Kleine-Budde (2):
      can: mcp251xfd: mcp251xfd_probe(): add missing can_rx_offload_del() in error path
      can: m_can: m_can_tx_work_queue(): fix tx_skb race condition

 drivers/net/can/m_can/m_can.c                  |  3 ++-
 drivers/net/can/spi/mcp251x.c                  | 35 +++++++++++++-------------
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |  8 +++---
 3 files changed, 25 insertions(+), 21 deletions(-)




Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263A648899D
	for <lists+netdev@lfdr.de>; Sun,  9 Jan 2022 14:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234099AbiAINkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 08:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233624AbiAINks (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 08:40:48 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BF3C061748
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 05:40:48 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1n6YRC-00045V-Dv
        for netdev@vger.kernel.org; Sun, 09 Jan 2022 14:40:46 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 6C3806D3EEC
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 13:40:43 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D3BDA6D3ED4;
        Sun,  9 Jan 2022 13:40:41 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id f5b05c5f;
        Sun, 9 Jan 2022 13:40:41 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/5] pull-request: can 2022-01-09
Date:   Sun,  9 Jan 2022 14:40:35 +0100
Message-Id: <20220109134040.1945428-1-mkl@pengutronix.de>
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

this is a pull request of 5 patches for net/master.

The first patch is by Johan Hovold and fixes a mem leak in the error
path of the softing_cs driver.

The next patch is by me and fixes a set but not used variable warning
in the softing driver.

Jiasheng Jiang's patch for the xilinx_can driver adds the missing
error checking when getting the IRQ.

Lad Prabhakar contributes a patch for the rcar_canfd driver to fix a
mem leak in the error path.

The last patch is by Brian Silverman and properly initializes the send
USB messages to avoid spurious CAN error frames.

regards,
Marc

---

The following changes since commit 6dc9a23e29061e50c36523270de60039ccf536fa:

  octeontx2-af: Fix interrupt name strings (2022-01-07 19:07:06 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.16-20220109

for you to fetch changes up to 89d58aebe14a365c25ba6645414afdbf4e41cea4:

  can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved} (2022-01-09 13:32:28 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.16-20220109

----------------------------------------------------------------
Brian Silverman (1):
      can: gs_usb: gs_can_start_xmit(): zero-initialize hf->{flags,reserved}

Jiasheng Jiang (1):
      can: xilinx_can: xcan_probe(): check for error irq

Johan Hovold (1):
      can: softing_cs: softingcs_probe(): fix memleak on registration failure

Lad Prabhakar (1):
      can: rcar_canfd: rcar_canfd_channel_probe(): make sure we free CAN network device

Marc Kleine-Budde (1):
      can: softing: softing_startstop(): fix set but not used variable warning

 drivers/net/can/rcar/rcar_canfd.c    |  5 ++---
 drivers/net/can/softing/softing_cs.c |  2 +-
 drivers/net/can/softing/softing_fw.c | 11 ++++++-----
 drivers/net/can/usb/gs_usb.c         |  2 ++
 drivers/net/can/xilinx_can.c         |  7 ++++++-
 5 files changed, 17 insertions(+), 10 deletions(-)



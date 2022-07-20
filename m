Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2BD57B272
	for <lists+netdev@lfdr.de>; Wed, 20 Jul 2022 10:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239842AbiGTILl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jul 2022 04:11:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239802AbiGTILb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jul 2022 04:11:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A273261D75
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 01:11:25 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oE4nj-0008VF-L7
        for netdev@vger.kernel.org; Wed, 20 Jul 2022 10:11:23 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7EDA8B5879
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 08:10:36 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id F00E2B586F;
        Wed, 20 Jul 2022 08:10:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 74ce5f34;
        Wed, 20 Jul 2022 08:10:35 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/29] pull-request: can-next 2022-07-20
Date:   Wed, 20 Jul 2022 10:10:05 +0200
Message-Id: <20220720081034.3277385-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 29 patches for net-next/master.

The first 6 patches target the slcan driver. Dan Carpenter contributes
a hardening patch, followed by 5 cleanup patches.

Biju Das contributes 5 patches to prepare the sja1000 driver to
support the Renesas RZ/N1 SJA1000 CAN controller.

Dario Binacchi's patch for the slcan driver fixes a sleep with held
spin lock.

Another patch by Dario Binacchi fixes a wrong comment in the c_can
driver.

Pavel Pisa updates the CTU CAN FD IP core registers.

Stephane Grosjean contributes 3 patches to the peak_usb driver for
cleanups and support of a new MCU.

The last 12 patches are by Vincent Mailhol, they fix and improve the
txerr and rxerr reporting in all CAN drivers.

regards,
Marc

---

The following changes since commit e22c88799f2629088504e1357384f2ec3798da46:

  Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue (2022-07-18 20:39:54 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.20-20220720

for you to fetch changes up to 1dbd8748a147c971747c8460e0cd1828cf2745d7:

  Merge branch 'can-error-set-of-fixes-and-improvement-on-txerr-and-rxerr-reporting' (2022-07-20 09:28:43 +0200)

----------------------------------------------------------------
linux-can-next-for-5.20-20220720

----------------------------------------------------------------
Biju Das (5):
      dt-bindings: can: sja1000: Convert to json-schema
      dt-bindings: can: nxp,sja1000: Document RZ/N1{D,S} support
      can: sja1000: Add Quirk for RZ/N1 SJA1000 CAN controller
      can: sja1000: Use device_get_match_data to get device data
      can: sja1000: Change the return type as void for SoC specific init

Dan Carpenter (1):
      can: slcan: use scnprintf() as a hardening measure

Dario Binacchi (2):
      can: slcan: do not sleep with a spin lock held
      can: c_can: remove wrong comment

Marc Kleine-Budde (9):
      can: slcan: convert comments to network style comments
      can: slcan: slcan_init() convert printk(LEVEL ...) to pr_level()
      can: slcan: fix whitespace issues
      can: slcan: convert comparison to NULL into !val
      can: slcan: clean up if/else
      Merge branch 'can-slcan-checkpatch-cleanups'
      Merge branch 'can-add-support-for-rz-n1-sja1000-can-controller'
      Merge branch 'can-peak_usb-cleanups-and-updates'
      Merge branch 'can-error-set-of-fixes-and-improvement-on-txerr-and-rxerr-reporting'

Pavel Pisa (1):
      can: ctucanfd: Update CTU CAN FD IP core registers to match version 3.x.

Stephane Grosjean (3):
      can: peak_usb: pcan_dump_mem(): mark input prompt and data pointer as const
      can: peak_usb: correction of an initially misnamed field name
      can: peak_usb: include support for a new MCU

Vincent Mailhol (12):
      can: pch_can: do not report txerr and rxerr during bus-off
      can: rcar_can: do not report txerr and rxerr during bus-off
      can: sja1000: do not report txerr and rxerr during bus-off
      can: slcan: do not report txerr and rxerr during bus-off
      can: hi311x: do not report txerr and rxerr during bus-off
      can: sun4i_can: do not report txerr and rxerr during bus-off
      can: kvaser_usb_hydra: do not report txerr and rxerr during bus-off
      can: kvaser_usb_leaf: do not report txerr and rxerr during bus-off
      can: usb_8dev: do not report txerr and rxerr during bus-off
      can: error: specify the values of data[5..7] of CAN error frames
      can: add CAN_ERR_CNT flag to notify availability of error counter
      can: error: add definitions for the different CAN error thresholds

 .../devicetree/bindings/net/can/nxp,sja1000.yaml   | 132 +++++++++++++++++++++
 .../devicetree/bindings/net/can/sja1000.txt        |  58 ---------
 drivers/net/can/c_can/c_can_main.c                 |   7 +-
 drivers/net/can/cc770/cc770.c                      |   1 +
 drivers/net/can/ctucanfd/ctucanfd_base.c           |   5 +-
 drivers/net/can/ctucanfd/ctucanfd_kregs.h          |  32 ++++-
 drivers/net/can/grcan.c                            |   1 +
 drivers/net/can/ifi_canfd/ifi_canfd.c              |   4 +-
 drivers/net/can/janz-ican3.c                       |   4 +-
 drivers/net/can/kvaser_pciefd.c                    |   2 +-
 drivers/net/can/m_can/m_can.c                      |   4 +-
 drivers/net/can/pch_can.c                          |   7 +-
 drivers/net/can/peak_canfd/peak_canfd.c            |   6 +-
 drivers/net/can/rcar/rcar_can.c                    |   9 +-
 drivers/net/can/rcar/rcar_canfd.c                  |   4 +-
 drivers/net/can/sja1000/sja1000.c                  |  16 ++-
 drivers/net/can/sja1000/sja1000.h                  |   3 +-
 drivers/net/can/sja1000/sja1000_platform.c         |  20 +---
 drivers/net/can/slcan/slcan-core.c                 | 117 +++++++++---------
 drivers/net/can/spi/hi311x.c                       |   6 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c     |   1 +
 drivers/net/can/sun4i_can.c                        |  10 +-
 drivers/net/can/ti_hecc.c                          |   1 +
 drivers/net/can/usb/esd_usb.c                      |   3 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  14 ++-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |   7 +-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |   1 +
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  68 +++++++++--
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |   2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h        |   2 +-
 drivers/net/can/usb/usb_8dev.c                     |   8 +-
 drivers/net/can/xilinx_can.c                       |   1 +
 include/uapi/linux/can/error.h                     |  20 +++-
 35 files changed, 376 insertions(+), 204 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/can/nxp,sja1000.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/can/sja1000.txt



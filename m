Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AA646D3A7
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 13:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbhLHMyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 07:54:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230162AbhLHMye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 07:54:34 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF89BC061746
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 04:51:02 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1muwPV-0003BO-8s
        for netdev@vger.kernel.org; Wed, 08 Dec 2021 13:51:01 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id ED8E96BFBD7
        for <netdev@vger.kernel.org>; Wed,  8 Dec 2021 12:50:58 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 0F4456BFBC7;
        Wed,  8 Dec 2021 12:50:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 678ed954;
        Wed, 8 Dec 2021 12:50:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/8] pull-request: can-next 2021-12-08
Date:   Wed,  8 Dec 2021 13:50:47 +0100
Message-Id: <20211208125055.223141-1-mkl@pengutronix.de>
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

this is a pull request of 8 patches for net-next/master.

The first patch is by Vincent Mailhol and replaces the custom CAN
units with generic one form linux/units.h.

The next 3 patches are by Evgeny Boger and add Allwinner R40 support
to the sun4i CAN driver.

Andy Shevchenko contributes 4 patches to the hi311x CAN driver,
consisting of cleanups and converting the driver to the device
property API.

regards,
Marc

---
The following changes since commit 1fe5b01262844be03de98afdd56d1d393df04d7e:

  Merge branch 's390-net-updates-2021-12-06' (2021-12-07 22:01:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.17-20211208

for you to fetch changes up to 6a93ea38217706ef8318efba672b960bcd5d0642:

  can: hi311x: hi3110_can_probe(): convert to use dev_err_probe() (2021-12-08 10:20:33 +0100)

----------------------------------------------------------------
linux-can-next-for-5.17-20211208

----------------------------------------------------------------
Andy Shevchenko (4):
      can: hi311x: hi3110_can_probe(): use devm_clk_get_optional() to get the input clock
      can: hi311x: hi3110_can_probe(): try to get crystal clock rate from property
      can: hi311x: hi3110_can_probe(): make use of device property API
      can: hi311x: hi3110_can_probe(): convert to use dev_err_probe()

Evgeny Boger (3):
      dt-bindings: net: can: add support for Allwinner R40 CAN controller
      can: sun4i_can: add support for R40 CAN controller
      ARM: dts: sun8i: r40: add node for CAN controller

Vincent Mailhol (1):
      can: bittiming: replace CAN units with the generic ones from linux/units.h

 .../bindings/net/can/allwinner,sun4i-a10-can.yaml  | 24 +++++++++
 arch/arm/boot/dts/sun8i-r40.dtsi                   | 19 +++++++
 drivers/net/can/dev/bittiming.c                    |  5 +-
 drivers/net/can/spi/hi311x.c                       | 52 +++++++++---------
 drivers/net/can/sun4i_can.c                        | 62 +++++++++++++++++++++-
 drivers/net/can/usb/etas_es58x/es581_4.c           |  5 +-
 drivers/net/can/usb/etas_es58x/es58x_fd.c          |  5 +-
 include/linux/can/bittiming.h                      |  7 ---
 8 files changed, 138 insertions(+), 41 deletions(-)



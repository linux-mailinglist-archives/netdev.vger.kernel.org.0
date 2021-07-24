Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902A03D48C8
	for <lists+netdev@lfdr.de>; Sat, 24 Jul 2021 19:20:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhGXQje (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Jul 2021 12:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229947AbhGXQj3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Jul 2021 12:39:29 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF2D0C061575
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 10:20:00 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1m7LJf-0002QJ-DA
        for netdev@vger.kernel.org; Sat, 24 Jul 2021 19:19:59 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 569D26569C4
        for <netdev@vger.kernel.org>; Sat, 24 Jul 2021 17:19:55 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id B7D256569AC;
        Sat, 24 Jul 2021 17:19:53 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id da0a1bc2;
        Sat, 24 Jul 2021 17:19:52 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-07-24
Date:   Sat, 24 Jul 2021 19:19:41 +0200
Message-Id: <20210724171947.547867-1-mkl@pengutronix.de>
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

this is a pull request of 6 patches for net/master.

The first patch is by Joakim Zhang targets the imx8mp device tree. It
removes the imx6 fallback from the flexcan binding, as the imx6 is not
compatible with the imx8mp.

Ziyang Xuan contributes a patch to fix a use-after-free in the CAN
raw's raw_setsockopt().

The next two patches target the CAN J1939 protocol. The first one is
by Oleksij Rempel and clarifies the lifetime of session object in
j1939_session_deactivate(). Zhang Changzhong's patch fixes the timeout
value between consecutive TP.DT.

Stephane Grosjean contributes a patch for the peak_usb driver to fix
reading of the rxerr/txerr values.

The last patch is by me for the mcp251xfd driver. It stops the
timestamp worker in case of a fatal error in the IRQ handler.

regards,
Marc

---

The following changes since commit 5aa1959d18003472cc741dc490c3335c5bd804e2:

  Merge branch 'ionic-fixes' (2021-07-23 21:57:52 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.14-20210724

for you to fetch changes up to ef68a717960658e6a1e5f08adb0574326e9a12c2:

  can: mcp251xfd: mcp251xfd_irq(): stop timestamping worker in case error in IRQ (2021-07-24 19:02:32 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.14-20210724

----------------------------------------------------------------
Joakim Zhang (1):
      arm64: dts: imx8mp: remove fallback compatible string for FlexCAN

Marc Kleine-Budde (1):
      can: mcp251xfd: mcp251xfd_irq(): stop timestamping worker in case error in IRQ

Oleksij Rempel (1):
      can: j1939: j1939_session_deactivate(): clarify lifetime of session object

Stephane Grosjean (1):
      can: peak_usb: pcan_usb_handle_bus_evt(): fix reading rxerr/txerr values

Zhang Changzhong (1):
      can: j1939: j1939_xtp_rx_dat_one(): fix rxtimer value between consecutive TP.DT to 750ms

Ziyang Xuan (1):
      can: raw: raw_setsockopt(): fix raw_rcv panic for sock UAF

 arch/arm64/boot/dts/freescale/imx8mp.dtsi      |  4 ++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |  1 +
 drivers/net/can/usb/peak_usb/pcan_usb.c        | 10 ++++++----
 net/can/j1939/transport.c                      | 11 ++++++++---
 net/can/raw.c                                  | 20 ++++++++++++++++++--
 5 files changed, 35 insertions(+), 11 deletions(-)



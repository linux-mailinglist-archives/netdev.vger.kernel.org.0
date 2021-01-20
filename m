Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF5B92FDA89
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 21:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389228AbhATOCm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Jan 2021 09:02:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732691AbhATMwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 07:52:49 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2690C0613CF
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 04:52:08 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1l2Cxz-00054Z-F5
        for netdev@vger.kernel.org; Wed, 20 Jan 2021 13:52:07 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id F264C5C8B0C
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 12:52:04 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id ED0215C8AFC;
        Wed, 20 Jan 2021 12:52:03 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 5cf185b5;
        Wed, 20 Jan 2021 12:52:03 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can 2021-01-20
Date:   Wed, 20 Jan 2021 13:51:59 +0100
Message-Id: <20210120125202.2187358-1-mkl@pengutronix.de>
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

this is a pull request of 3 patches for net/master.

All three patches are by Vincent Mailhol and fix a potential use after free bug
in the CAN device infrastructure, the vxcan driver, and the peak_usk driver. In
the TX-path the skb is used to read from after it was passed to the networking
stack with netif_rx_ni().

Note: Patch 1/3 touches "drivers/net/can/dev.c". In net-next/master this file
has been moved to drivers/net/can/dev/dev.c [1] and parts of it have been
transfered into separate files. This may result in a merge conflict. Please
carry this patch forward, the change is rather simple. Drop us a note if
needed. Are any actions needed with regards to linux-next?

[1] 3e77f70e7345 can: dev: move driver related infrastructure into separate subdir

regards,
Marc

---

The following changes since commit 9c30ae8398b0813e237bde387d67a7f74ab2db2d:

  tcp: fix TCP socket rehash stats mis-accounting (2021-01-19 19:47:20 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.11-20210120

for you to fetch changes up to 50aca891d7a554db0901b245167cd653d73aaa71:

  can: peak_usb: fix use after free bugs (2021-01-20 13:33:28 +0100)

----------------------------------------------------------------
linux-can-fixes-for-5.11-20210120

----------------------------------------------------------------
Vincent Mailhol (3):
      can: dev: can_restart: fix use after free bug
      can: vxcan: vxcan_xmit: fix use after free bug
      can: peak_usb: fix use after free bugs

 drivers/net/can/dev.c                      | 4 ++--
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c | 8 ++++----
 drivers/net/can/vxcan.c                    | 6 ++++--
 3 files changed, 10 insertions(+), 8 deletions(-)



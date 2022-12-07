Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C704164583A
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229728AbiLGKxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229778AbiLGKwx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:52:53 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1818F2E9FF
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:52:49 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1p2s2h-00073P-S1
        for netdev@vger.kernel.org; Wed, 07 Dec 2022 11:52:47 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 929F51387E0
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 10:52:46 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 829AC1387CA;
        Wed,  7 Dec 2022 10:52:45 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id bacd9f37;
        Wed, 7 Dec 2022 10:52:44 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/4] pull-request: can 2022-12-07
Date:   Wed,  7 Dec 2022 11:52:39 +0100
Message-Id: <20221207105243.2483884-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 4 patches for net/master.

The 1st patch is by Oliver Hartkopp and fixes a potential NULL pointer
deref found by syzbot in the AF_CAN protocol.

The next 2 patches are by Jiri Slaby and Max Staudt and add the
missing flush_work() before freeing the underlying memory in the slcan
and can327 driver.

The last patch is by Frank Jungclaus and target the esd_usb driver and
fixes the CAN error counters, allowing them to return to zero.

regards,
Marc

---

The following changes since commit 1799c1b85e292fbfad99892bbea0beee925149e8:

  Merge branch '40GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/net-queue (2022-12-06 20:46:33 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.1-20221207

for you to fetch changes up to 918ee4911f7a41fb4505dff877c1d7f9f64eb43e:

  can: esd_usb: Allow REC and TEC to return to zero (2022-12-07 10:32:48 +0100)

----------------------------------------------------------------
linux-can-fixes-for-6.1-20221207

----------------------------------------------------------------
Frank Jungclaus (1):
      can: esd_usb: Allow REC and TEC to return to zero

Jiri Slaby (SUSE) (1):
      can: slcan: fix freed work crash

Max Staudt (1):
      can: can327: flush TX_work on ldisc .close()

Oliver Hartkopp (1):
      can: af_can: fix NULL pointer dereference in can_rcv_filter

 drivers/net/can/can327.c           | 17 ++++++++++-------
 drivers/net/can/slcan/slcan-core.c | 10 ++++++----
 drivers/net/can/usb/esd_usb.c      |  6 ++++++
 net/can/af_can.c                   |  6 +++---
 4 files changed, 25 insertions(+), 14 deletions(-)



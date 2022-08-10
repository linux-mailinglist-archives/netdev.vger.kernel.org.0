Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D1858E7AA
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 09:15:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231459AbiHJHO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 03:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230382AbiHJHOy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 03:14:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6769E81B30
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 00:14:53 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oLfvX-0003RI-LU
        for netdev@vger.kernel.org; Wed, 10 Aug 2022 09:14:51 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 05686C6550
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 07:14:51 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9F507C654A;
        Wed, 10 Aug 2022 07:14:50 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id d60cb1da;
        Wed, 10 Aug 2022 07:14:50 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/n] pull-request: can 2022-08-10
Date:   Wed, 10 Aug 2022 09:14:44 +0200
Message-Id: <20220810071448.1627857-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 4 patches for net/master, with the
whitespace issue fixed.

Fedor Pchelkin contributes 2 fixes for the j1939 CAN protocol.

A patch by me for the ems_usb driver fixes an unaligned access
warning.

Sebastian Würl's patch for the mcp251x driver fixes a race condition
in the receive interrupt.

regards,
Marc

---

The following changes since commit b8c3bf0ed2edf2deaedba5f0bf0bb54c76dee71d:

  Merge tag 'for-net-2022-08-08' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth (2022-08-08 20:59:07 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.0-20220810

for you to fetch changes up to d80d60b0db6ff3dd2e29247cc2a5166d7e9ae37e:

  can: mcp251x: Fix race condition on receive interrupt (2022-08-09 21:40:22 +0200)

----------------------------------------------------------------
linux-can-fixes-for-6.0-20220810

----------------------------------------------------------------
Fedor Pchelkin (2):
      can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()
      can: j1939: j1939_session_destroy(): fix memory leak of skbs

Marc Kleine-Budde (1):
      can: ems_usb: fix clang's -Wunaligned-access warning

Sebastian Würl (1):
      can: mcp251x: Fix race condition on receive interrupt

 drivers/net/can/spi/mcp251x.c | 18 +++++++++++++++---
 drivers/net/can/usb/ems_usb.c |  2 +-
 net/can/j1939/socket.c        |  5 ++++-
 net/can/j1939/transport.c     |  8 +++++++-
 4 files changed, 27 insertions(+), 6 deletions(-)



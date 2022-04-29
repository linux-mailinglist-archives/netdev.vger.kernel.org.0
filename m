Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7EFA514A00
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 14:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359582AbiD2M7f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 08:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236806AbiD2M7e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 08:59:34 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C391CE84
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 05:56:16 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nkQAR-00007X-5e
        for netdev@vger.kernel.org; Fri, 29 Apr 2022 14:56:15 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CC0D970EE4
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 12:56:13 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9DD0470EDA;
        Fri, 29 Apr 2022 12:56:13 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 61612d92;
        Fri, 29 Apr 2022 12:56:13 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/5] pull-request: can 2022-04-29
Date:   Fri, 29 Apr 2022 14:56:07 +0200
Message-Id: <20220429125612.1792561-1-mkl@pengutronix.de>
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

this is a pull request of 5 patches for net/master.

The first patch is by Oliver Hartkopp and removes the ability to
re-binding bounds sockets from the ISOTP. It turned out to be not
needed and brings unnecessary complexity.

The last 4 patches all target the grcan driver. Duoming Zhou's patch
fixes a potential dead lock in the grcan_close() function. Daniel
Hellstrom's patch fixes the dma_alloc_coherent() to use the correct
device. Andreas Larsson's 1st patch fixes a broken system id check,
the 2nd patch fixes the NAPI poll budget usage.

regards,
Marc

---

The following changes since commit d9157f6806d1499e173770df1f1b234763de5c79:

  tcp: fix F-RTO may not work correctly when receiving DSACK (2022-04-28 10:35:38 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.18-20220429

for you to fetch changes up to 2873d4d52f7c52d60b316ba6c47bd7122b5a9861:

  can: grcan: only use the NAPI poll budget for RX (2022-04-29 12:09:32 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.18-20220429

----------------------------------------------------------------
Andreas Larsson (2):
      can: grcan: grcan_probe(): fix broken system id check for errata workaround needs
      can: grcan: only use the NAPI poll budget for RX

Daniel Hellstrom (1):
      can: grcan: use ofdev->dev when allocating DMA memory

Duoming Zhou (1):
      can: grcan: grcan_close(): fix deadlock

Oliver Hartkopp (1):
      can: isotp: remove re-binding of bound socket

 drivers/net/can/grcan.c | 46 ++++++++++++++++++++++++----------------------
 net/can/isotp.c         | 25 +++++--------------------
 2 files changed, 29 insertions(+), 42 deletions(-)



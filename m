Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67BD968791A
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 10:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbjBBJlo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 04:41:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231302AbjBBJln (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 04:41:43 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDCD483064
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 01:41:41 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pNW68-0000d9-1d
        for netdev@vger.kernel.org; Thu, 02 Feb 2023 10:41:40 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id CFB8916D0C0
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 09:41:38 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id A8D0016D0A6;
        Thu,  2 Feb 2023 09:41:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 7757cbcd;
        Thu, 2 Feb 2023 09:41:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/5] pull-request: can 2023-02-02
Date:   Thu,  2 Feb 2023 10:41:30 +0100
Message-Id: <20230202094135.2293939-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 5 patches for net/master.

The first patch is by Ziyang Xuan and removes a errant WARN_ON_ONCE()
in the CAN J1939 protocol.

The next 3 patches are by Oliver Hartkopp. The first 2 target the CAN
ISO-TP protocol and fix the state machine with respect to signals and
a regression found by the syzbot.

The last patch is by me an missing assignment during the ethtool ring
configuration callback.

regards,
Marc

---

The following changes since commit 917d5e04d4dd2bbbf36fc6976ba442e284ccc42d:

  octeontx2-af: Fix devlink unregister (2023-02-01 21:22:41 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.2-20230202

for you to fetch changes up to 1613fff7a32e1d9e2ac09db73feba0e71a188445:

  can: mcp251xfd: mcp251xfd_ring_set_ringparam(): assign missing tx_obj_num_coalesce_irq (2023-02-02 10:33:27 +0100)

----------------------------------------------------------------
linux-can-fixes-for-6.2-20230202

----------------------------------------------------------------
Marc Kleine-Budde (1):
      can: mcp251xfd: mcp251xfd_ring_set_ringparam(): assign missing tx_obj_num_coalesce_irq

Oliver Hartkopp (3):
      can: raw: fix CAN FD frame transmissions over CAN XL devices
      can: isotp: handle wait_event_interruptible() return values
      can: isotp: split tx timer into transmission and timeout

Ziyang Xuan (1):
      can: j1939: fix errant WARN_ON_ONCE in j1939_session_deactivate

 drivers/net/can/spi/mcp251xfd/mcp251xfd-ethtool.c |  1 +
 net/can/isotp.c                                   | 69 +++++++++++------------
 net/can/j1939/transport.c                         |  4 --
 net/can/raw.c                                     | 47 +++++++++------
 4 files changed, 65 insertions(+), 56 deletions(-)



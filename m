Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F167560F667
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 13:44:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235182AbiJ0LoI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 07:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234790AbiJ0LoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 07:44:03 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32CCA11CB75
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 04:44:02 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oo1Im-0000cg-Nn
        for netdev@vger.kernel.org; Thu, 27 Oct 2022 13:44:00 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 059E510B226
        for <netdev@vger.kernel.org>; Thu, 27 Oct 2022 11:43:59 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 9AEFD10B21A;
        Thu, 27 Oct 2022 11:43:58 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 09e96b0f;
        Thu, 27 Oct 2022 11:43:57 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/4] pull-request: can 2022-10-27
Date:   Thu, 27 Oct 2022 13:43:52 +0200
Message-Id: <20221027114356.1939821-1-mkl@pengutronix.de>
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

this is a pull request of 4 patches for net/master.

Anssi Hannula fixes the use of the completions in the kvaser_usb
driver.

Biju Das contributes 2 patches for the rcar_canfd driver. A IRQ storm
that can be triggered by high CAN bus load and channel specific IRQ
handlers are fixed.

Yang Yingliang fixes the j1939 transport protocol by moving a
kfree_skb() out of a spin_lock_irqsave protected section.

regards,
Marc

---

The following changes since commit e2badb4bd33abe13ddc35975bd7f7f8693955a4b:

  net: ethernet: ave: Fix MAC to be in charge of PHY PM (2022-10-26 20:21:34 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.1-20221027

for you to fetch changes up to c3c06c61890da80494bb196f75d89b791adda87f:

  can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb() (2022-10-27 13:34:23 +0200)

----------------------------------------------------------------
linux-can-fixes-for-6.1-20221027

----------------------------------------------------------------
Anssi Hannula (1):
      can: kvaser_usb: Fix possible completions during init_completion

Biju Das (2):
      can: rcar_canfd: rcar_canfd_handle_global_receive(): fix IRQ storm on global FIFO receive
      can: rcar_canfd: fix channel specific IRQ handling for RZ/G2L

Marc Kleine-Budde (1):
      Merge patch series "R-Car CAN-FD fixes"

Yang Yingliang (1):
      can: j1939: transport: j1939_session_skb_drop_old(): spin_unlock_irqrestore() before kfree_skb()

 drivers/net/can/rcar/rcar_canfd.c                 | 24 +++++++++++------------
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c |  4 ++--
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c  |  4 ++--
 net/can/j1939/transport.c                         |  4 +++-
 4 files changed, 18 insertions(+), 18 deletions(-)



Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 455C94ED612
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 10:46:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233197AbiCaIs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 04:48:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233207AbiCaIsZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 04:48:25 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF3661F89F1
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 01:46:38 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nZqRx-0000BY-A8
        for netdev@vger.kernel.org; Thu, 31 Mar 2022 10:46:37 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 7199D579DE
        for <netdev@vger.kernel.org>; Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 2D602579C9;
        Thu, 31 Mar 2022 08:46:35 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 1c0fb7d7;
        Thu, 31 Mar 2022 08:46:34 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/n] pull-request: can 2022-03-31
Date:   Thu, 31 Mar 2022 10:46:26 +0200
Message-Id: <20220331084634.869744-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 8 patches for net/master.

The first patch is by Oliver Hartkopp and fixes MSG_PEEK feature in
the CAN ISOTP protocol (broken in net-next for v5.18 only).

Tom Rix's patch for the mcp251xfd driver fixes the propagation of an
error value in case of an error.

A patch by me for the m_can driver fixes a use-after-free in the xmit
handler for m_can IP cores v3.0.x.

Hangyu Hua contributes 3 patches fixing the same double free in the
error path of the xmit handler in the ems_usb, usb_8dev and mcba_usb
USB CAN driver.

Pavel Skripkin contributes a patch for the mcba_usb driver to properly
check the endpoint type.

The last patch is by me and fixes a mem leak in the gs_usb, which was
introduced in net-next for v5.18.

regards,
Marc

---

The following changes since commit f9512d654f62604664251dedd437a22fe484974a:

  net: sparx5: uses, depends on BRIDGE or !BRIDGE (2022-03-30 19:16:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-5.18-20220331

for you to fetch changes up to 50d34a0d151dc7abbdbec781bd7f09f2b3cbf01a:

  can: gs_usb: gs_make_candev(): fix memory leak for devices with extended bit timing configuration (2022-03-31 09:55:27 +0200)

----------------------------------------------------------------
linux-can-fixes-for-5.18-20220331

----------------------------------------------------------------
Hangyu Hua (3):
      can: ems_usb: ems_usb_start_xmit(): fix double dev_kfree_skb() in error path
      can: usb_8dev: usb_8dev_start_xmit(): fix double dev_kfree_skb() in error path
      can: mcba_usb: mcba_usb_start_xmit(): fix double dev_kfree_skb in error path

Marc Kleine-Budde (2):
      can: m_can: m_can_tx_handler(): fix use after free of skb
      can: gs_usb: gs_make_candev(): fix memory leak for devices with extended bit timing configuration

Oliver Hartkopp (1):
      can: isotp: restore accidentally removed MSG_PEEK feature

Pavel Skripkin (1):
      can: mcba_usb: properly check endpoint type

Tom Rix (1):
      can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix return of error value

 drivers/net/can/m_can/m_can.c                  |  5 +++--
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |  2 +-
 drivers/net/can/usb/ems_usb.c                  |  1 -
 drivers/net/can/usb/gs_usb.c                   |  2 ++
 drivers/net/can/usb/mcba_usb.c                 | 27 +++++++++++++----------
 drivers/net/can/usb/usb_8dev.c                 | 30 ++++++++++++--------------
 net/can/isotp.c                                |  2 +-
 7 files changed, 37 insertions(+), 32 deletions(-)



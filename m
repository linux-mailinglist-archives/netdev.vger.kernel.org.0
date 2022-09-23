Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994365E7A69
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 14:18:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229993AbiIWMS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 08:18:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbiIWMQS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 08:16:18 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94D9F13C86C
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 05:09:05 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1obhUO-0007Ep-3z
        for netdev@vger.kernel.org; Fri, 23 Sep 2022 14:09:04 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 56D97EB112
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 12:09:03 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id D703DEB104;
        Fri, 23 Sep 2022 12:09:01 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id c8f4d511;
        Fri, 23 Sep 2022 12:09:00 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/11] pull-request: can-next 2022-09-23
Date:   Fri, 23 Sep 2022 14:08:48 +0200
Message-Id: <20220923120859.740577-1-mkl@pengutronix.de>
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

this is a pull request of 11 patches for net-next/main.

The first 2 patches are by Ziyang Xuan and optimize registration and
the sending in the CAN BCM protocol a bit.

The next 8 patches target the gs_usb driver. 7 are by me and first fix
the time hardware stamping support (added during this net-next cycle),
rename a variable, convert the usb_control_msg + manual
kmalloc()/kfree() to usb_control_msg_{send,rev}(), clean up the error
handling and add switchable termination support. The patch by Rhett
Aultman and Vasanth Sadhasivan convert the driver from
usb_alloc_coherent()/usb_free_coherent() to kmalloc()/URB_FREE_BUFFER.

The last patch is by Shang XiaoJing and removes an unneeded call to
dev_err() from the ctucanfd driver.

regards,
Marc

---

The following changes since commit d05d9eb79d0cd0f7a978621b4a56a1f2db444f86:

  Merge branch 'net-dsa-remove-unnecessary-set_drvdata' (2022-09-22 19:31:39 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-6.1-20220923

for you to fetch changes up to 6eed756408c69687613a83fd221431c8790cf0bb:

  can: ctucanfd: Remove redundant dev_err call (2022-09-23 13:55:01 +0200)

----------------------------------------------------------------
linux-can-next-for-6.1-20220923

----------------------------------------------------------------
Marc Kleine-Budde (8):
      Merge patch series "can: bcm: can: bcm: random optimizations"
      can: gs_usb: gs_usb_get_timestamp(): fix endpoint parameter for usb_control_msg_recv()
      can: gs_usb: add missing lock to protect struct timecounter::cycle_last
      can: gs_usb: gs_can_open(): initialize time counter before starting device
      can: gs_usb: gs_cmd_reset(): rename variable holding struct gs_can pointer to dev
      can: gs_usb: convert from usb_control_msg() to usb_control_msg_{send,recv}()
      can: gs_usb: gs_make_candev(): clean up error handling
      can: gs_usb: add switchable termination support

Shang XiaoJing (1):
      can: ctucanfd: Remove redundant dev_err call

Vasanth Sadhasivan (1):
      can: gs_usb: remove dma allocations

Ziyang Xuan (2):
      can: bcm: registration process optimization in bcm_module_init()
      can: bcm: check the result of can_send() in bcm_can_tx()

 drivers/net/can/ctucanfd/ctucanfd_platform.c |   1 -
 drivers/net/can/usb/gs_usb.c                 | 478 +++++++++++++--------------
 net/can/bcm.c                                |  25 +-
 3 files changed, 249 insertions(+), 255 deletions(-)



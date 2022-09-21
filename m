Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F110F5BF96E
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 10:36:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231288AbiIUIgW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 04:36:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbiIUIgR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 04:36:17 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ADF832D2
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 01:36:15 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oavDK-0000Sw-5B
        for netdev@vger.kernel.org; Wed, 21 Sep 2022 10:36:14 +0200
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id C55E1E8584
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 08:36:11 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id AA48FE8571;
        Wed, 21 Sep 2022 08:36:10 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 66c926ad;
        Wed, 21 Sep 2022 08:36:10 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/3] pull-request: can 2022-09-21
Date:   Wed, 21 Sep 2022 10:36:06 +0200
Message-Id: <20220921083609.419768-1-mkl@pengutronix.de>
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

until the mess with yesterdays pull request is sorted out, here's a
pull request with the remaining 3 patches for net/master.

The 1st patch is by me, targets the flexcan driver and fixes a
potential system hang on single core systems under high CAN packet
rate.

The next 2 patches are also by me and target the gs_usb driver. A
potential race condition during the ndo_open callback as well as the
return value if the ethtool identify feature is not supported are
fixed.

regards,
Marc

---

The following changes since commit 6a1dbfefdae4f7809b3e277cc76785dac0ac1cd0:

  net: sh_eth: Fix PHY state warning splat during system resume (2022-09-20 17:05:50 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.0-20220921

for you to fetch changes up to 0f2211f1cf58876f00d2fd8839e0fdadf0786894:

  can: gs_usb: gs_usb_set_phys_id(): return with error if identify is not supported (2022-09-21 09:48:52 +0200)

----------------------------------------------------------------
linux-can-fixes-for-6.0-20220921

----------------------------------------------------------------
Marc Kleine-Budde (3):
      can: flexcan: flexcan_mailbox_read() fix return value for drop = true
      can: gs_usb: gs_can_open(): fix race dev->can.state condition
      can: gs_usb: gs_usb_set_phys_id(): return with error if identify is not supported

 drivers/net/can/flexcan/flexcan-core.c | 10 +++++-----
 drivers/net/can/usb/gs_usb.c           | 21 +++++++++++++--------
 2 files changed, 18 insertions(+), 13 deletions(-)



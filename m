Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCCF6196FD
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 14:05:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231616AbiKDNFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 09:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbiKDNFl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 09:05:41 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3CB02E9CE
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 06:05:40 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oqwOB-0007vO-Cy
        for netdev@vger.kernel.org; Fri, 04 Nov 2022 14:05:39 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id D6E51112EF8
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 13:05:38 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 60B4C112EEC;
        Fri,  4 Nov 2022 13:05:37 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 0fac8381;
        Fri, 4 Nov 2022 13:05:36 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net 0/5] pull-request: can 2022-11-04
Date:   Fri,  4 Nov 2022 14:05:30 +0100
Message-Id: <20221104130535.732382-1-mkl@pengutronix.de>
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

The first patch is by Chen Zhongjin and adds a missing
dev_remove_pack() to the AF_CAN protocol.

Zhengchao Shao's patch fixes a potential NULL pointer deref in
AF_CAN's can_rx_register().

The next patch is by Oliver Hartkopp, targets the j1939 protocol and
adds a missing initialization of the CAN headers inside outgoing skbs.

Another patch by Oliver Hartkopp fixes an out of bounds read in the
check for invalid CAN frames in the xmit callback of virtual CAN
devices. This touches all non virtual device drivers as we decided to
rename the function requiring that netdev_priv points to a struct
can_priv.
(Note: This patch will create a merge conflict with net-next where the
 pch_can driver has removed.)

The last patch is by Geert Uytterhoeven and adds the missing ECC error
checks for the channels 2-7 in the rcar_canfd driver.

regards,
Marc

---

The following changes since commit 91018bbcc664b6c9410ddccacd2239a4acadcfc9:

  Merge tag 'wireless-2022-11-03' of git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2022-11-03 21:07:40 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can.git tags/linux-can-fixes-for-6.1-20221104

for you to fetch changes up to 07d79cb24535b0d801bf5fabe127c054276e2d38:

  can: rcar_canfd: Add missing ECC error checks for channels 2-7 (2022-11-04 13:29:29 +0100)

----------------------------------------------------------------
linux-can-fixes-for-6.1-20221104

----------------------------------------------------------------
Chen Zhongjin (1):
      can: af_can: can_exit(): add missing dev_remove_pack() of canxl_packet

Geert Uytterhoeven (1):
      can: rcar_canfd: Add missing ECC error checks for channels 2-7

Oliver Hartkopp (2):
      can: j1939: j1939_send_one(): fix missing CAN header initialization
      can: dev: fix skb drop check

Zhengchao Shao (1):
      can: af_can: fix NULL pointer dereference in can_rx_register()

 drivers/net/can/at91_can.c                       |  2 +-
 drivers/net/can/c_can/c_can_main.c               |  2 +-
 drivers/net/can/can327.c                         |  2 +-
 drivers/net/can/cc770/cc770.c                    |  2 +-
 drivers/net/can/ctucanfd/ctucanfd_base.c         |  2 +-
 drivers/net/can/dev/skb.c                        | 10 +---------
 drivers/net/can/flexcan/flexcan-core.c           |  2 +-
 drivers/net/can/grcan.c                          |  2 +-
 drivers/net/can/ifi_canfd/ifi_canfd.c            |  2 +-
 drivers/net/can/janz-ican3.c                     |  2 +-
 drivers/net/can/kvaser_pciefd.c                  |  2 +-
 drivers/net/can/m_can/m_can.c                    |  2 +-
 drivers/net/can/mscan/mscan.c                    |  2 +-
 drivers/net/can/pch_can.c                        |  2 +-
 drivers/net/can/peak_canfd/peak_canfd.c          |  2 +-
 drivers/net/can/rcar/rcar_can.c                  |  2 +-
 drivers/net/can/rcar/rcar_canfd.c                | 15 +++++----------
 drivers/net/can/sja1000/sja1000.c                |  2 +-
 drivers/net/can/slcan/slcan-core.c               |  2 +-
 drivers/net/can/softing/softing_main.c           |  2 +-
 drivers/net/can/spi/hi311x.c                     |  2 +-
 drivers/net/can/spi/mcp251x.c                    |  2 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd-tx.c     |  2 +-
 drivers/net/can/sun4i_can.c                      |  2 +-
 drivers/net/can/ti_hecc.c                        |  2 +-
 drivers/net/can/usb/ems_usb.c                    |  2 +-
 drivers/net/can/usb/esd_usb.c                    |  2 +-
 drivers/net/can/usb/etas_es58x/es58x_core.c      |  2 +-
 drivers/net/can/usb/gs_usb.c                     |  2 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c |  2 +-
 drivers/net/can/usb/mcba_usb.c                   |  2 +-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c     |  2 +-
 drivers/net/can/usb/ucan.c                       |  2 +-
 drivers/net/can/usb/usb_8dev.c                   |  2 +-
 drivers/net/can/xilinx_can.c                     |  2 +-
 include/linux/can/dev.h                          | 16 ++++++++++++++++
 net/can/af_can.c                                 |  3 ++-
 net/can/j1939/main.c                             |  3 +++
 38 files changed, 60 insertions(+), 53 deletions(-)



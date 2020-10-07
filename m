Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF47286A1B
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 23:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbgJGVcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 17:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbgJGVcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 17:32:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 821EEC061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 14:32:07 -0700 (PDT)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kQH2b-0005qi-UI; Wed, 07 Oct 2020 23:32:06 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2020-10-07
Date:   Wed,  7 Oct 2020 23:31:42 +0200
Message-Id: <20201007213159.1959308-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

this is a pull request of 17 patches for net-next/master.

The first 3 patches are by me and fix several warnings found when compiling the 
kernel with W=1.

Lukas Bulwahn's patch adjusts the MAINTAINERS file, to accommodate the renaming 
of the mcp251xfd driver.

Vincent Mailhol contributes 3 patches for the CAN networking layer. First error
queue support is added the the CAN RAW protocol. The second patch converts the
get_can_dlc() and get_canfd_dlc() in-Kernel-only macros from using __u8 to u8.
The third patch adds a helper function to calculate the length of one bit in in
multiple of time quanta.

Oliver Hartkopp's patch add support for the ISO 15765-2:2016 transport protocol
to the CAN stack.

Three patches by Lad Prabhakar add documentation for various new rcar
controllers to the device tree bindings of the rcar_can and rcan_canfd driver.

Michael Walle's patch adds various processors to the flexcan driver binding
documentation.

The next two patches are by me and target the flexcan driver aswell. The remove
the ack_grp and ack_bit from the fsl,stop-mode DT property and the driver, as
they are not used anymore. As these are the last two arguments this change will
not break existing device trees.

The last three patches are by Srinivas Neeli and target the xilinx_can driver.
The first one increases the lower limit for the bit rate prescaler to 2, the
other two fix sparse and coverity findings.

regards,
Marc

---

The following changes since commit 9faebeb2d80065926dfbc09cb73b1bb7779a89cd:

  Merge branch 'ethtool-allow-dumping-policies-to-user-space' (2020-10-06 06:25:56 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.10-20201007

for you to fetch changes up to 164ab90d0d8644d13ca498146a1732d1fff82d89:

  can: xilinx_can: Fix incorrect variable and initialize with a default value (2020-10-07 23:18:34 +0200)

----------------------------------------------------------------
linux-can-next-for-5.10-20201007

----------------------------------------------------------------
Lad Prabhakar (3):
      dt-bindings: can: rcar_can: Add r8a7742 support
      dt-bindings: can: rcar_canfd: Document r8a774e1 support
      dt-bindings: can: rcar_can: Document r8a774e1 support

Lukas Bulwahn (1):
      MAINTAINERS: adjust to mcp251xfd file renaming

Marc Kleine-Budde (5):
      can: af_can: can_rcv_list_find(): fix kernel doc after variable renaming
      can: softing: softing_card_shutdown(): add  braces around empty body in an 'if' statement
      can: c_can: reg_map_{c,d}_can: mark as __maybe_unused
      dt-bindings: can: flexcan: remove ack_grp and ack_bit from fsl,stop-mode
      can: flexcan: remove ack_grp and ack_bit handling from driver

Michael Walle (1):
      dt-bindings: can: flexcan: list supported processors

Oliver Hartkopp (1):
      can: add ISO 15765-2:2016 transport protocol

Srinivas Neeli (3):
      can: xilinx_can: Limit CANFD brp to 2
      can: xilinx_can: Check return value of set_reset_mode
      can: xilinx_can: Fix incorrect variable and initialize with a default value

Vincent Mailhol (3):
      can: raw: add missing error queue support
      can: dev: fix type of get_can_dlc() and get_canfd_dlc() macros
      can: dev: add a helper function to calculate the duration of one bit

 .../devicetree/bindings/net/can/fsl-flexcan.txt    |   10 +-
 .../devicetree/bindings/net/can/rcar_can.txt       |    8 +-
 .../devicetree/bindings/net/can/rcar_canfd.txt     |    5 +-
 MAINTAINERS                                        |    7 +-
 drivers/net/can/c_can/c_can.h                      |    4 +-
 drivers/net/can/dev.c                              |   13 +-
 drivers/net/can/flexcan.c                          |   13 +-
 drivers/net/can/softing/softing_main.c             |    3 +-
 drivers/net/can/xilinx_can.c                       |   14 +-
 include/linux/can/dev.h                            |   21 +-
 include/uapi/linux/can/isotp.h                     |  166 +++
 include/uapi/linux/can/raw.h                       |    3 +
 net/can/Kconfig                                    |   13 +
 net/can/Makefile                                   |    3 +
 net/can/af_can.c                                   |    2 +-
 net/can/isotp.c                                    | 1426 ++++++++++++++++++++
 net/can/raw.c                                      |    4 +
 17 files changed, 1676 insertions(+), 39 deletions(-)
 create mode 100644 include/uapi/linux/can/isotp.h
 create mode 100644 net/can/isotp.c



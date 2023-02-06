Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D47A68BDC6
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 14:19:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230391AbjBFNSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 08:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjBFNSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 08:18:10 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9573F24125
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 05:17:30 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pP1NA-0007kz-Jg
        for netdev@vger.kernel.org; Mon, 06 Feb 2023 14:17:28 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 8E8241712D0
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 13:16:23 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id 57C2D171296;
        Mon,  6 Feb 2023 13:16:22 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 891609d0;
        Mon, 6 Feb 2023 13:16:21 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: [PATCH net-next 0/47] pull-request: can-next 2023-02-06
Date:   Mon,  6 Feb 2023 14:15:33 +0100
Message-Id: <20230206131620.2758724-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.39.1
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

this is a pull request of 47 patches for net-next/master.

The first two patch is by Oliver Hartkopp. One adds missing error
checking to the CAN_GW protocol, the other adds a missing CAN address
family check to the CAN ISO TP protocol.

Thomas Kopp contributes a performance optimization to the mcp251xfd
driver.

The next 11 patches are by Geert Uytterhoeven and add support for
R-Car V4H systems to the rcar_canfd driver.

Stephane Grosjean and Lukas Magel contribute 8 patches to the peak_usb
driver, which add support for configurable CAN channel ID.

The last 17 patches are by me and target the CAN bit timing
configuration. The bit timing is cleaned up, error messages are
improved and forwarded to user space via NL_SET_ERR_MSG_FMT() instead
of netdev_err(), and the SJW handling is updated, including the
definition of a new default value that will benefit CAN-FD
controllers, by increasing their oscillator tolerance.

regards,
Marc

---

The following changes since commit 609aa68d60965f70485655def733d533f99b341b:

  octeontx2-af: Removed unnecessary debug messages. (2023-02-01 21:33:08 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-6.3-20230206

for you to fetch changes up to 3dafbe5cc1409dd2e3fc2955b0026c1ba7dfa323:

  Merge patch series "can: bittiming: cleanups and rework SJW handling" (2023-02-06 14:02:37 +0100)

----------------------------------------------------------------
linux-can-next-for-6.3-20230206

----------------------------------------------------------------
Geert Uytterhoeven (11):
      dt-bindings: can: renesas,rcar-canfd: R-Car V3U is R-Car Gen4
      dt-bindings: can: renesas,rcar-canfd: Document R-Car V4H support
      dt-bindings: can: renesas,rcar-canfd: Add transceiver support
      can: rcar_canfd: Fix R-Car V3U CAN mode selection
      can: rcar_canfd: Fix R-Car V3U GAFLCFG field accesses
      can: rcar_canfd: Abstract out DCFG address differences
      can: rcar_canfd: Add support for R-Car Gen4
      can: rcar_canfd: Fix R-Car Gen4 DCFG.DSJW field width
      can: rcar_canfd: Fix R-Car Gen4 CFCC.CFTML field width
      can: rcar_canfd: Sort included header files
      can: rcar_canfd: Add helper variable dev

Gerhard Uttenthaler (8):
      can: ems_pci: Fix code style, copyright and email address
      can: ems_pci: Add Asix AX99100 definitions
      can: ems_pci: Initialize BAR registers
      can: ems_pci: Add read/write register and post irq functions
      can: ems_pci: Initialize CAN controller base addresses
      can: ems_pci: Add IRQ enable
      can: ems_pci: Deassert hardware reset
      can: ems_pci: Add myself as module author

Lukas Magel (3):
      can: peak_usb: export PCAN CAN channel ID as sysfs device attribute
      can: peak_usb: align CAN channel ID format in log with sysfs attribute
      can: peak_usb: Reorder include directives alphabetically

Marc Kleine-Budde (21):
      Merge patch series "can: rcar_canfd: Add support for R-Car V4H systems"
      Merge patch series "can: ems_pci: Add support for CPC-PCIe v3"
      Merge patch series "can: peak_usb: Introduce configurable CAN channel ID"
      can: bittiming(): replace open coded variants of can_bit_time()
      can: bittiming: can_fixup_bittiming(): use CAN_SYNC_SEG instead of 1
      can: bittiming: can_fixup_bittiming(): set effective tq
      can: bittiming: can_get_bittiming(): use direct return and remove unneeded else
      can: dev: register_candev(): ensure that bittiming const are valid
      can: dev: register_candev(): bail out if both fixed bit rates and bit timing constants are provided
      can: netlink: can_validate(): validate sample point for CAN and CAN-FD
      can: netlink: can_changelink(): convert from netdev_err() to NL_SET_ERR_MSG_FMT()
      can: bittiming: can_changelink() pass extack down callstack
      can: bittiming: factor out can_sjw_set_default() and can_sjw_check()
      can: bittiming: can_fixup_bittiming(): report error via netlink and harmonize error value
      can: bittiming: can_sjw_check(): report error via netlink and harmonize error value
      can: bittiming: can_sjw_check(): check that SJW is not longer than either Phase Buffer Segment
      can: bittiming: can_sjw_set_default(): use Phase Seg2 / 2 as default for SJW
      can: bittiming: can_calc_bittiming(): clean up SJW handling
      can: bittiming: can_calc_bittiming(): convert from netdev_err() to NL_SET_ERR_MSG_FMT()
      can: bittiming: can_validate_bitrate(): report error via netlink
      Merge patch series "can: bittiming: cleanups and rework SJW handling"

Oliver Hartkopp (2):
      can: gw: give feedback on missing CGW_FLAGS_CAN_IIF_TX_OK flag
      can: isotp: check CAN address family in isotp_bind()

Stephane Grosjean (5):
      can: peak_usb: rename device_id to CAN channel ID
      can: peak_usb: add callback to read CAN channel ID of PEAK CAN-FD devices
      can: peak_usb: allow flashing of the CAN channel ID
      can: peak_usb: replace unregister_netdev() with unregister_candev()
      can: peak_usb: add ethtool interface to user-configurable CAN channel identifier

Thomas Kopp (1):
      can: mcp251xfd: regmap: optimizing transfer size for CRC transfers size 1

 Documentation/ABI/testing/sysfs-class-net-peak_usb |  19 ++
 .../bindings/net/can/renesas,rcar-canfd.yaml       |  16 +-
 drivers/net/can/dev/bittiming.c                    | 120 ++++++++---
 drivers/net/can/dev/calc_bittiming.c               |  34 ++--
 drivers/net/can/dev/dev.c                          |  21 ++
 drivers/net/can/dev/netlink.c                      |  49 ++++-
 drivers/net/can/rcar/rcar_canfd.c                  | 225 ++++++++++-----------
 drivers/net/can/sja1000/ems_pci.c                  | 154 ++++++++++----
 drivers/net/can/spi/mcp251xfd/mcp251xfd-ring.c     |  18 +-
 drivers/net/can/spi/mcp251xfd/mcp251xfd.h          |  26 ++-
 drivers/net/can/usb/peak_usb/pcan_usb.c            |  44 +++-
 drivers/net/can/usb/peak_usb/pcan_usb_core.c       | 122 ++++++++++-
 drivers/net/can/usb/peak_usb/pcan_usb_core.h       |  12 +-
 drivers/net/can/usb/peak_usb/pcan_usb_fd.c         |  68 ++++++-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.c        |  30 ++-
 drivers/net/can/usb/peak_usb/pcan_usb_pro.h        |   1 +
 include/linux/can/bittiming.h                      |  10 +-
 net/can/gw.c                                       |   7 +
 net/can/isotp.c                                    |   3 +
 19 files changed, 728 insertions(+), 251 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-class-net-peak_usb



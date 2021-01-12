Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3B592F30A4
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 14:15:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731438AbhALNJD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 08:09:03 -0500
Received: from smtp07.smtpout.orange.fr ([80.12.242.129]:52576 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730806AbhALNJC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jan 2021 08:09:02 -0500
Received: from localhost.localdomain ([153.202.107.157])
        by mwinf5d87 with ME
        id Fp712400H3PnFJp03p786t; Tue, 12 Jan 2021 14:07:14 +0100
X-ME-Helo: localhost.localdomain
X-ME-Auth: bWFpbGhvbC52aW5jZW50QHdhbmFkb28uZnI=
X-ME-Date: Tue, 12 Jan 2021 14:07:14 +0100
X-ME-IP: 153.202.107.157
From:   Vincent Mailhol <mailhol.vincent@wanadoo.fr>
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Arunachalam Santhanam <arunachalam.santhanam@in.bosch.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jimmy Assarsson <extja@kvaser.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        "open list : NETWORKING DRIVERS" <netdev@vger.kernel.org>
Subject: [PATCH v10 0/1] add support for ETAS ES58X CAN USB interfaces
Date:   Tue, 12 Jan 2021 22:05:37 +0900
Message-Id: <20210112130538.14912-1-mailhol.vincent@wanadoo.fr>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Here is the v10 of the patch.

Hope that we are now close to a release. Thanks for your comments!


Yours sincerely,
Vincent

---

Changes in v10 (2021-01-12):
  - Rebased on linux-can-next/testing and modified according to latest
    BQL patches.
Reference: https://lore.kernel.org/linux-can/20210111141930.693847-1-mkl@pengutronix.de/T/#m5f99d4da8e8934a75f9481ecc3137b59f3762413
  - Replaced __netdev_sent_queue() by netdev_sent_queue().

Changes in v9 (2021-01-09):
  - es58x_start_xmit(): do not use skb anymore after the call of
    can_put_echo_skb(). Rationale: can_put_echo_skb() calls
    skb_clone() and thus the original skb gets consumed (i.e. use
    after free issue).
  - es58x_start_xmit(): Add a "drop_skb" label to free the skb when
    errors occur.

Changes in v8 (2021-01-04):
  - The driver requires CRC16. Modified Kconfig accordingly.

Changes in v7 (2020-11-17):
  - Fix compilation issue if CONFIG_BQL is not set.
Reference: https://lkml.org/lkml/2020/11/15/163

Changes in v6 (2020-11-15):
  - Rebase the patch on the testing branch of linux-can-next.
  - Rename the helper functions according latest changes
    (e.g. can_cc_get_len() -> can_cc_dlc2len())
  - Fix comments of enum es58x_physical_layer and enum
    es58x_sync_edge.

Changes in v5 (2020-11-07):
  - Add support for DLC greater than 8.
  - All other patches from the previous series were either accepted or
    dismissed. As such, this is not a series any more but a single
    patch.

Changes in v4 (2020-10-17):
  - Remove struct es58x_abstracted_can_frame.
  - Fix formatting (spaces, comment style).
  - Transform macros into static inline functions when possible.
  - Fix the ctrlmode_supported flags in es581_4.c and removed
    misleading comments in enum es58x_samples_per_bit.
  - Rename enums according to the type.
  - Remove function es58x_can_put_echo_skb().
Reference: https://lkml.org/lkml/2020/10/10/53

Changes in v3 (2020-10-03):
  - Remove all the calls to likely() and unlikely().
Reference: https://lkml.org/lkml/2020/9/30/995

Changes in v2 (2020-09-30):
  - Fixed -W1 warnings (v1 was tested with GCC -WExtra but not with
    -W1).

v1 (2020-09-27):
 - First release

Vincent Mailhol (1):
  can: usb: etas_es58X: add support for ETAS ES58X CAN USB interfaces

 drivers/net/can/usb/Kconfig                 |   10 +
 drivers/net/can/usb/Makefile                |    1 +
 drivers/net/can/usb/etas_es58x/Makefile     |    3 +
 drivers/net/can/usb/etas_es58x/es581_4.c    |  552 ++++
 drivers/net/can/usb/etas_es58x/es581_4.h    |  206 ++
 drivers/net/can/usb/etas_es58x/es58x_core.c | 2589 +++++++++++++++++++
 drivers/net/can/usb/etas_es58x/es58x_core.h |  707 +++++
 drivers/net/can/usb/etas_es58x/es58x_fd.c   |  662 +++++
 drivers/net/can/usb/etas_es58x/es58x_fd.h   |  242 ++
 9 files changed, 4972 insertions(+)
 create mode 100644 drivers/net/can/usb/etas_es58x/Makefile
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es581_4.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_core.h
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.c
 create mode 100644 drivers/net/can/usb/etas_es58x/es58x_fd.h

-- 
2.26.2


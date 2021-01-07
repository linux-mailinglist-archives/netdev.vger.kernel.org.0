Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 722822ECD3D
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 10:53:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727866AbhAGJvj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 04:51:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727773AbhAGJv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jan 2021 04:51:27 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82693C0612B1
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 01:50:00 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kxRva-0001DL-Tj
        for netdev@vger.kernel.org; Thu, 07 Jan 2021 10:49:58 +0100
Received: from dspam.blackshift.org (localhost [127.0.0.1])
        by bjornoya.blackshift.org (Postfix) with SMTP id 839EF5BBA2E
        for <netdev@vger.kernel.org>; Thu,  7 Jan 2021 09:49:03 +0000 (UTC)
Received: from hardanger.blackshift.org (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bjornoya.blackshift.org (Postfix) with ESMTPS id BEE885BBA13;
        Thu,  7 Jan 2021 09:49:01 +0000 (UTC)
Received: from blackshift.org (localhost [::1])
        by hardanger.blackshift.org (OpenSMTPD) with ESMTP id 95ed9909;
        Thu, 7 Jan 2021 09:49:01 +0000 (UTC)
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: pull-request: can-next 2021-01-06
Date:   Thu,  7 Jan 2021 10:48:41 +0100
Message-Id: <20210107094900.173046-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jakub, hello David,

this is a pull request of 19 patches for net-next/master.

The first 16 patches are by me and target the tcan4x5x SPI glue driver for the
m_can CAN driver. First there are a several cleanup commits, then the SPI
regmap part is converted to 8 bits per word, to make it possible to use that
driver on SPI controllers that only support the 8 bit per word mode (such as
the SPI cores on the raspberry pi).

Oliver Hartkopp contributes a patch for the CAN_RAW protocol. The getsockopt()
for CAN_RAW_FILTER is changed to return -ERANGE if the filterset does not fit
into the provided user space buffer.

The last two patches are by Joakim Zhang and add wakeup support to the flexcan
driver for the i.MX8QM SoC. The dt-bindings docs are extended to describe the
added property.

regards,
Marc

---

The following changes since commit ede71cae72855f8d6f6268510895210adc317666:

  net-next: docs: Fix typos in snmp_counter.rst (2021-01-05 17:07:38 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git tags/linux-can-next-for-5.12-20210106

for you to fetch changes up to 812f0116c66a3ebaf0b6062226aa85574dd79f67:

  can: flexcan: add CAN wakeup function for i.MX8QM (2021-01-06 15:20:13 +0100)

----------------------------------------------------------------
linux-can-next-for-5.12-20210106

----------------------------------------------------------------
Joakim Zhang (2):
      dt-bindings: can: fsl,flexcan: add fsl,scu-index property to indicate a resource
      can: flexcan: add CAN wakeup function for i.MX8QM

Marc Kleine-Budde (16):
      can: tcan4x5x: replace DEVICE_NAME by KBUILD_MODNAME
      can: tcan4x5x: beautify indention of tcan4x5x_of_match and tcan4x5x_id_table
      can: tcan4x5x: rename tcan4x5x.c -> tcan4x5x-core.c
      can: tcan4x5x: move regmap code into seperate file
      can: tcan4x5x: mark struct regmap_bus tcan4x5x_bus as constant
      can: tcan4x5x: tcan4x5x_bus: remove not needed read_flag_mask
      can: tcan4x5x: remove regmap async support
      can: tcan4x5x: rename regmap_spi_gather_write() -> tcan4x5x_regmap_gather_write()
      can: tcan4x5x: tcan4x5x_regmap_write(): remove not needed casts and replace 4 by sizeof
      can: tcan4x5x: tcan4x5x_regmap_init(): use spi as context pointer
      can: tcan4x5x: fix max register value
      can: tcan4x5x: tcan4x5x_regmap: set reg_stride to 4
      can: tcan4x5x: add max_raw_{read,write} of 256
      can: tcan4x5x: add {wr,rd}_table
      can: tcan4x5x: rework SPI access
      can: tcan4x5x: add support for half-duplex controllers

Oliver Hartkopp (1):
      can: raw: return -ERANGE when filterset does not fit into user space buffer

 .../devicetree/bindings/net/can/fsl,flexcan.yaml   |  11 ++
 drivers/net/can/flexcan.c                          | 123 ++++++++++++++++---
 drivers/net/can/m_can/Makefile                     |   4 +
 .../net/can/m_can/{tcan4x5x.c => tcan4x5x-core.c}  | 126 +++----------------
 drivers/net/can/m_can/tcan4x5x-regmap.c            | 135 +++++++++++++++++++++
 drivers/net/can/m_can/tcan4x5x.h                   |  57 +++++++++
 net/can/raw.c                                      |  16 ++-
 7 files changed, 340 insertions(+), 132 deletions(-)
 rename drivers/net/can/m_can/{tcan4x5x.c => tcan4x5x-core.c} (80%)
 create mode 100644 drivers/net/can/m_can/tcan4x5x-regmap.c
 create mode 100644 drivers/net/can/m_can/tcan4x5x.h




Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B3162D1131
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 13:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgLGM5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Dec 2020 07:57:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726214AbgLGM5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Dec 2020 07:57:13 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8F86C0613D2
        for <netdev@vger.kernel.org>; Mon,  7 Dec 2020 04:56:32 -0800 (PST)
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kmG47-0002oZ-7E; Mon, 07 Dec 2020 13:56:31 +0100
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <mgr@pengutronix.de>)
        id 1kmG45-0008Nz-00; Mon, 07 Dec 2020 13:56:29 +0100
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, davem@davemloft.net,
        kernel@pengutronix.de, matthias.schiffer@ew.tq-group.com,
        woojung.huh@microchip.com, UNGLinuxDriver@microchip.com
Subject: [PATCH v5 0/6] microchip: add support for ksz88x3 driver family
Date:   Mon,  7 Dec 2020 13:56:21 +0100
Message-Id: <20201207125627.30843-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the ksz88x3 driver family to the dsa based ksz
drivers. The driver is making use of the already available ksz8795 driver
and moves it to an generic driver for the ksz8 based chips which have
similar functions but an totaly different register layout.

This branch is to be rebased on net-next/master

The mainlining discussion history of this branch:

v1: https://lore.kernel.org/netdev/20191107110030.25199-1-m.grzeschik@pengutronix.de/
v2: https://lore.kernel.org/netdev/20191218200831.13796-1-m.grzeschik@pengutronix.de/
v3: https://lore.kernel.org/netdev/20200508154343.6074-1-m.grzeschik@pengutronix.de/
v4: https://lore.kernel.org/netdev/20200803054442.20089-1-m.grzeschik@pengutronix.de/

Michael Grzeschik (6):
  net: dsa: microchip: ksz8795: change drivers prefix to be generic
  net: dsa: microchip: ksz8795: move cpu_select_interface to extra function
  net: dsa: microchip: ksz8795: move register offsets and shifts to separate struct
  net: dsa: microchip: ksz8795: add support for ksz88xx chips
  net: dsa: microchip: Add Microchip KSZ8863 SPI based driver support
  dt-bindings: net: dsa: document additional Microchip KSZ8863/8873 switch

 .../bindings/net/dsa/microchip,ksz.yaml       |   2 +
 drivers/net/dsa/microchip/ksz8.h              |  69 ++
 drivers/net/dsa/microchip/ksz8795.c           | 888 ++++++++++++------
 drivers/net/dsa/microchip/ksz8795_reg.h       | 125 +--
 drivers/net/dsa/microchip/ksz8795_spi.c       |  46 +-
 drivers/net/dsa/microchip/ksz_common.h        |   3 +-
 6 files changed, 730 insertions(+), 403 deletions(-)
 create mode 100644 drivers/net/dsa/microchip/ksz8.h

-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4016418183
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 23:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727608AbfEHVOE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 17:14:04 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:50109 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbfEHVOD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 17:14:03 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <mgr@pengutronix.de>)
        id 1hOTt0-0005Tl-HB; Wed, 08 May 2019 23:13:58 +0200
Received: from mgr by dude.hi.pengutronix.de with local (Exim 4.92-RC6)
        (envelope-from <mgr@pengutronix.de>)
        id 1hOTsz-000632-Vl; Wed, 08 May 2019 23:13:57 +0200
From:   Michael Grzeschik <m.grzeschik@pengutronix.de>
To:     Tristram.Ha@microchip.com
Cc:     kernel@pengutronix.de, UNGLinuxDriver@microchip.com,
        netdev@vger.kernel.org
Subject: [RFC 0/3] microchip: add support for ksz8863 driver family
Date:   Wed,  8 May 2019 23:13:27 +0200
Message-Id: <20190508211330.19328-1-m.grzeschik@pengutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: mgr@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the ksz8863 driver family to the
dsa based ksz drivers. For now the ksz8863 nad ksz8873 are compatible.

The driver is based on the ksz8895 RFC patch from Tristam Ha:

https://patchwork.ozlabs.org/patch/822712/

And the latest version of the ksz8863.h from Microchip:

https://raw.githubusercontent.com/Microchip-Ethernet/UNG8071_old_1.10/master/KSZ/linux-drivers/ksz8863/linux-3.14/drivers/net/ethernet/micrel/ksz8863.h

The driver works as expected on the machine including the switch. The
clients on the other hand behind the switch see some bandwidth issues
after the stack was bootet and configured appropriate via:

ip link add name br0 type bridge

ip link set dev eth1 master br0
ip link set dev eth2 master br0

@Tristam: Could you have a look if something obious was misconfigured?

Michael Grzeschik (3):
  mdio-bitbang: add SMI0 mode support
  ksz: Add Microchip KSZ8873 SMI-DSA driver
  dt-bindings: net: dsa: document additional Microchip KSZ8863 family
    switches

 .../devicetree/bindings/net/dsa/ksz.txt       |   44 +
 drivers/net/dsa/microchip/Kconfig             |   16 +
 drivers/net/dsa/microchip/Makefile            |    2 +
 drivers/net/dsa/microchip/ksz8863.c           | 1026 +++++++++++++++++
 drivers/net/dsa/microchip/ksz8863_reg.h       |  605 ++++++++++
 drivers/net/dsa/microchip/ksz8863_smi.c       |  105 ++
 drivers/net/dsa/microchip/ksz_priv.h          |    3 +
 drivers/net/phy/mdio-bitbang.c                |   10 +
 include/linux/phy.h                           |   12 +
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    7 +
 net/dsa/tag_ksz.c                             |   45 +
 12 files changed, 1877 insertions(+)
 create mode 100644 drivers/net/dsa/microchip/ksz8863.c
 create mode 100644 drivers/net/dsa/microchip/ksz8863_reg.h
 create mode 100644 drivers/net/dsa/microchip/ksz8863_smi.c

-- 
2.20.1


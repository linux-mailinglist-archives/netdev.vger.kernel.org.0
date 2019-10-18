Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB8DEDC161
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 11:40:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442397AbfJRJkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 05:40:06 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42039 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2442386AbfJRJjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 05:39:46 -0400
Received: from dude.hi.pengutronix.de ([2001:67c:670:100:1d::7])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iLOjQ-0006Z4-Ty; Fri, 18 Oct 2019 11:39:36 +0200
Received: from ore by dude.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1iLOjN-0007gV-De; Fri, 18 Oct 2019 11:39:33 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Andrew Lunn <andrew@lunn.ch>, Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, Russell King <linux@armlinux.org.uk>
Subject: [PATCH v2 0/5] add dsa switch support for ar9331
Date:   Fri, 18 Oct 2019 11:39:24 +0200
Message-Id: <20191018093929.19299-1-o.rempel@pengutronix.de>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::7
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

changes v2:
- move Atheros AR9331 TAG format to separate patch
- use netdev_warn_once in the tag driver to reduce potential message spam
- typo fixes
- reorder tag driver alphabetically 
- configure switch to maximal frame size
- use mdiobus_read/write
- fail if mdio sub node is not found
- add comment for post reset state
- remove deprecated comment about device id
- remove phy-handle option for node with fixed-link
- ag71xx: set 1G support only for GMII mode

This patch series provides dsa switch support for Atheros ar9331 WiSoC.
As side effect ag71xx needed to be ported to phylink to make the switch
driver (as well phylink based) work properly.

Oleksij Rempel (5):
  net: ag71xx: port to phylink
  dt-bindings: net: dsa: qca,ar9331 switch documentation
  MIPS: ath79: ar9331: add ar9331-switch node
  net: dsa: add support for Atheros AR9331 TAG format
  net: dsa: add support for Atheros AR9331 build-in switch

 .../devicetree/bindings/net/dsa/ar9331.txt    | 148 ++++
 arch/mips/boot/dts/qca/ar9331.dtsi            | 127 ++-
 arch/mips/boot/dts/qca/ar9331_dpt_module.dts  |  13 +
 drivers/net/dsa/Kconfig                       |   2 +
 drivers/net/dsa/Makefile                      |   1 +
 drivers/net/dsa/qca/Kconfig                   |  11 +
 drivers/net/dsa/qca/Makefile                  |   2 +
 drivers/net/dsa/qca/ar9331.c                  | 823 ++++++++++++++++++
 drivers/net/ethernet/atheros/Kconfig          |   2 +-
 drivers/net/ethernet/atheros/ag71xx.c         | 146 ++--
 include/net/dsa.h                             |   2 +
 net/dsa/Kconfig                               |   6 +
 net/dsa/Makefile                              |   1 +
 net/dsa/tag_ar9331.c                          |  97 +++
 14 files changed, 1319 insertions(+), 62 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/ar9331.txt
 create mode 100644 drivers/net/dsa/qca/Kconfig
 create mode 100644 drivers/net/dsa/qca/Makefile
 create mode 100644 drivers/net/dsa/qca/ar9331.c
 create mode 100644 net/dsa/tag_ar9331.c

-- 
2.23.0


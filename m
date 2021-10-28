Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3D1843E2AF
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 15:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231139AbhJ1Nyc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 09:54:32 -0400
Received: from mslow1.mail.gandi.net ([217.70.178.240]:35529 "EHLO
        mslow1.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231151AbhJ1NyW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 09:54:22 -0400
Received: from relay9-d.mail.gandi.net (unknown [217.70.183.199])
        by mslow1.mail.gandi.net (Postfix) with ESMTP id B6B1FC0124;
        Thu, 28 Oct 2021 13:51:26 +0000 (UTC)
Received: (Authenticated sender: clement.leger@bootlin.com)
        by relay9-d.mail.gandi.net (Postfix) with ESMTPSA id 1ADA0FF814;
        Thu, 28 Oct 2021 13:50:59 +0000 (UTC)
From:   =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Add FDMA support on ocelot switch driver
Date:   Thu, 28 Oct 2021 15:49:29 +0200
Message-Id: <20211028134932.658167-1-clement.leger@bootlin.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds support for the Frame DMA present on the VSC7514
switch. The FDMA is able to extract and inject packets on the various
ethernet interfaces present on the switch.

While adding FDMA support, bindings were switched from .txt to .yaml
and mac address read from device-tree was added to allow be set instead
of using random mac address.

Clément Léger (3):
  net: ocelot: add support to get mac from device-tree
  dt-bindings: net: convert mscc,vsc7514-switch bindings to yaml
  net: ocelot: add FDMA support

 .../bindings/net/mscc,vsc7514-switch.yaml     | 183 ++++
 .../devicetree/bindings/net/mscc-ocelot.txt   |  83 --
 drivers/net/ethernet/mscc/Makefile            |   1 +
 drivers/net/ethernet/mscc/ocelot.h            |   2 +
 drivers/net/ethernet/mscc/ocelot_fdma.c       | 811 ++++++++++++++++++
 drivers/net/ethernet/mscc/ocelot_fdma.h       |  60 ++
 drivers/net/ethernet/mscc/ocelot_net.c        |  30 +-
 drivers/net/ethernet/mscc/ocelot_vsc7514.c    |  20 +-
 include/linux/dsa/ocelot.h                    |  40 +-
 include/soc/mscc/ocelot.h                     |   2 +
 10 files changed, 1140 insertions(+), 92 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/mscc,vsc7514-switch.yaml
 delete mode 100644 Documentation/devicetree/bindings/net/mscc-ocelot.txt
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.c
 create mode 100644 drivers/net/ethernet/mscc/ocelot_fdma.h

-- 
2.33.0


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 150A5367DED
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235723AbhDVJnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:43:43 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:10004 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235491AbhDVJnm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:43:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1619084588; x=1650620588;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=tFPD8HhBT6SgmxtibGnTXt1w2OBO4z7RcENOq1+EVfQ=;
  b=tghPZ+0ZJ9rPoKXWiGLl8AdFaAu8gQMFNOG5ywUhl/hcj74AnzRLELpZ
   tqyyL/taUtVgY9S5RWA5Rf23sfVlCSn+iszRmIGZ7vjbCpjA+dO8dZzRd
   b+ICoJ2O3g8Gaj0vYJ28XeoJc/SqNrlZKwenlHc4stWPtYBqQD6yHuEEP
   g4neWpgNnR/39Ut3J4NnL/FcVslLlmasZzD4/TS1t2NqKL7lmF1PlS+Ij
   uUxywHgsq36cIsy2jIVpyvhgyXNuFMroTRZfC+o27soX+qaBt+s6fnTVW
   fxQfY7Sdw4BhMcQR6PzJtGlgjXvo6pO07XsUR5imifeLCIrUUksLHcRd3
   g==;
IronPort-SDR: rKJ6wxBUveqK4GPjDbRSvpNVeXAppfY1RXevkuxxCYnchRJ6YxMdo5I53cTPVpRuFCM4brGJAj
 +Flw19wsjPBH8nZEkYM0+7ulvf2GG5/KAtbFcHN2DvqYlDgIPqwK2J0hjcgjbdVvTeQzCKgrZt
 lyX/RSAN6wgQv8gXZuBXlHKMWNJsML22Mr1BJpMtTWMvxRoSBtHm0ho7qPI7sM6pmHAKx4jS7D
 XZ40M+tBNbDSYmgWUBV9lVvGXoOag06pRSOTSY5IjRFTPiJsLvh62IYd1JjFkxnrOXk328VoMb
 ku4=
X-IronPort-AV: E=Sophos;i="5.82,242,1613458800"; 
   d="scan'208";a="117417222"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Apr 2021 02:43:08 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 22 Apr 2021 02:43:07 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 22 Apr 2021 02:43:01 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v2 net-next 0/9] net: dsa: microchip: DSA driver support for LAN937x switch
Date:   Thu, 22 Apr 2021 15:12:48 +0530
Message-ID: <20210422094257.1641396-1-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN937x is a Multi-Port 100BASE-T1 Ethernet Physical Layer switch  
compliant with the IEEE 802.3bw-2015 specification. The device  
provides 100 Mbit/s transmit and receive capability over a single 
Unshielded Twisted Pair (UTP) cable. LAN937x is successive revision 
of KSZ series switch. This series of patches provide the DSA driver  
support for Microchip LAN937X switch and it configures through  
SPI interface. 

This driver shares some of the functions from KSZ common 
layer. 

The LAN937x switch series family consists of following SKUs: 

LAN9370: 
  - 4 T1 Phys 
  - 1 RGMII port 

LAN9371: 
  - 3 T1 Phys & 1 TX Phy 
  - 2 RGMII ports 

LAN9372: 
  - 5 T1 Phys & 1 TX Phy 
  - 2 RGMII ports 

LAN9373: 
  - 5 T1 Phys 
  - 2 RGMII & 1 SGMII port 

LAN9374: 
  - 6 T1 Phys 
  - 2 RGMII ports 

More support will be added at a later stage. 

Changes in v2: 
- return check for register read/writes
- dt compatible compatible check is added against chip id value 
- lan937x_internal_t1_tx_phy_write() is renamed to 
  lan937x_internal_phy_write()
- lan937x_is_internal_tx_phy_port is renamed to 
  lan937x_is_internal_100BTX_phy_port as it is 100Base-Tx phy
- Return value for lan937x_internal_phy_write() is -EOPNOTSUPP 
  in case of failures 
- Return value for lan937x_internal_phy_read() is 0xffff 
  for non existent phy 
- cpu_port checking is removed from lan937x_port_stp_state_set()
- lan937x_phy_link_validate: 100baseT_Full to 100baseT1_Full
- T1 Phy driver is moved to drivers/net/phy/microchip_t1.c 
- Tx phy driver support will be added later 
- Legacy switch checkings in dts file are removed.
- tag_ksz.c: Re-used ksz9477_rcv for lan937x_rcv 
- tag_ksz.c: Xmit() & rcv() Comments are corrected w.r.to host
- net/dsa/Kconfig: Family skew numbers altered in ascending order
- microchip,lan937x.yaml: eth is replaced with ethernet
- microchip,lan937x.yaml: spi1 is replaced with spi 
- microchip,lan937x.yaml: cpu labelling is removed 
- microchip,lan937x.yaml: port@x value will match the reg value now

Prasanna Vengateshan (9):
  dt-bindings: net: dsa: dt bindings for microchip lan937x
  net: phy: Add support for LAN937x T1 phy driver
  net: dsa: tag_ksz: add tag handling for Microchip LAN937x
  net: dsa: microchip: add DSA support for microchip lan937x
  net: dsa: microchip: add support for phylink management
  net: dsa: microchip: add support for ethtool port counters
  net: dsa: microchip: add support for port mirror operations
  net: dsa: microchip: add support for fdb and mdb management
  net: dsa: microchip: add support for vlan operations

 .../bindings/net/dsa/microchip,lan937x.yaml   |  142 ++
 MAINTAINERS                                   |    1 +
 drivers/net/dsa/microchip/Kconfig             |   12 +
 drivers/net/dsa/microchip/Makefile            |    5 +
 drivers/net/dsa/microchip/ksz_common.h        |    5 +
 drivers/net/dsa/microchip/lan937x_dev.c       |  674 +++++++++
 drivers/net/dsa/microchip/lan937x_dev.h       |   68 +
 drivers/net/dsa/microchip/lan937x_main.c      | 1204 +++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h       |  710 ++++++++++
 drivers/net/dsa/microchip/lan937x_spi.c       |  226 ++++
 drivers/net/phy/microchip_t1.c                |  361 ++++-
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    4 +-
 net/dsa/tag_ksz.c                             |   58 +
 14 files changed, 3409 insertions(+), 63 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_spi.c

-- 
2.27.0


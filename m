Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A55F39B544
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 10:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhFDI57 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 04:57:59 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:56614 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbhFDI56 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 04:57:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1622796973; x=1654332973;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ZOmo84dmSFlp+SMjGhp7N8oAVBpdR2QKekKnuDL6DkY=;
  b=iUIDARPMS6DW3aoxlf33a7mTgVtAoRz5MKtGhWqcR/RxLsRt//c76WGe
   RfUCguK+t+QR/zi98HRI35MyWSwQ1Svv+oWf20qaQQSMn/yrZ3tLQs4K2
   VWL8/L5KLgXxYXNgaWEF+Sw0BZNfsLs7Pk7hiXIObe7b9FHVKecVussP+
   mSgwASt7JKVe6zchS+9oyT5Byw1jGKV9D7SUSTtOPO7x0IP5RBaCHUr1c
   58X6vKMoDfZz7QvVUUMO2WsE9CMbHxsS55iVZnO3UO3FwqEchO5uQSLC+
   r88ncu7LaFvx0EL51ydnkwmBbkqeaBx0YDG/E7lWlHd6tR1jGkHQYRDxn
   g==;
IronPort-SDR: kttVdD2cKcIaGyps4Ajg2/46cwjEtIue7ib+tOICpnbQR/rvpJKiF8cnuYtBWA+GNH8iVhkSSG
 qvYJzsuwx5YT7RjZz0qGSQwUMYecTMgj1zSUfnf1V2LQM8Oa2/qg+iDC+7Ftbh/BMk7SGq1WR1
 WhVCWGAG0HGgk/45l0FJ8LKNYxKoC29ZdTT644Lzi/aH9KwcG2bzwjOZGsDxHpSVTNGNoEuRer
 GEP273emOx7006RvrWtsuY7JX0MAiz0JjeKehPUwSzoDhZjGqEQmmgk3udRk58O0UTORsC30+i
 PBs=
X-IronPort-AV: E=Sophos;i="5.83,247,1616482800"; 
   d="scan'208";a="123530962"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Jun 2021 01:56:12 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 4 Jun 2021 01:56:11 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 4 Jun 2021 01:56:08 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        "Microchip Linux Driver Support" <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        "Simon Horman" <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next v3 00/10] Adding the Sparx5 Switch Driver
Date:   Fri, 4 Jun 2021 10:55:50 +0200
Message-ID: <20210604085600.3014532-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides the Microchip Sparx5 Switch Driver

The Sparx5 Carrier Ethernet and Industrial switch family delivers 64
Ethernet ports and up to 200 Gbps of switching bandwidth.

It provides a rich set of Ethernet switching features such as hierarchical
QoS, hardware-based OAM  and service activation testing, protection
switching, IEEE 1588, and Synchronous Ethernet.

Using provider bridging (Q-in-Q) and MPLS/MPLS-TP technology, it delivers
MEF CE
2.0 Ethernet virtual connections (EVCs) and features advanced TCAM
  classification in both ingress and egress.

Per-EVC features include advanced L3-aware classification, a rich set of
statistics, OAM for end-to-end performance monitoring, and dual-rate
policing and shaping.

Time sensitive networking (TSN) is supported through a comprehensive set of
features including frame preemption, cut-through, frame replication and
elimination for reliability, enhanced scheduling: credit-based shaping,
time-aware shaping, cyclic queuing, and forwarding, and per-stream policing
and filtering.

Together with IEEE 1588 and IEEE 802.1AS support, this guarantees
low-latency deterministic networking for Fronthaul, Carrier, and Industrial
Ethernet.

The Sparx5 switch family consists of following SKUs:

- VSC7546 Sparx5-64 up to 64 Gbps of bandwidth with the following primary
  port configurations:
  - 6 *10G
  - 16 * 2.5G + 2 * 10G
  - 24 * 1G + 4 * 10G

- VSC7549 Sparx5-90 up to 90 Gbps of bandwidth with the following primary
  port configurations:
  - 9 * 10G
  - 16 * 2.5G + 4 * 10G
  - 48 * 1G + 4 * 10G

- VSC7552 Sparx5-128 up to 128 Gbps of bandwidth with the following primary
  port configurations:
  - 12 * 10G
  - 16 * 2.5G + 8 * 10G
  - 48 * 1G + 8 * 10G

- VSC7556 Sparx5-160 up to 160 Gbps of bandwidth with the following primary
  port configurations:
  - 16 * 10G
  - 10 * 10G + 2 * 25G
  - 16 * 2.5G + 10 * 10G
  - 48 * 1G + 10 * 10G

- VSC7558 Sparx5-200 up to 200 Gbps of bandwidth with the following primary
  port configurations:
  - 20 * 10G
  - 8 * 25G

In addition, the device supports one 10/100/1000/2500/5000 Mbps
SGMII/SerDes node processor interface (NPI) Ethernet port.

The Sparx5 support is developed on the PCB134 and PCB135 evaluation boards.

- PCB134 main networking features:
  - 12x SFP+ front 10G module slots (connected to Sparx5 through SFI).
  - 8x SFP28 front 25G module slots (connected to Sparx5 through SFI high
    speed).
  - Optional, one additional 10/100/1000BASE-T (RJ45) Ethernet port
    (on-board VSC8211 PHY connected to Sparx5 through SGMII).

- PCB135 main networking features:
  - 48x1G (10/100/1000M) RJ45 front ports using 12xVSC8514 QuadPHY’s each
    connected to VSC7558 through QSGMII.
  - 4x10G (1G/2.5G/5G/10G) RJ45 front ports using the AQR407 10G QuadPHY
    each port connects to VSC7558 through SFI.
  - 4x SFP28 25G module slots on back connected to VSC7558 through SFI high
    speed.
  - Optional, one additional 1G (10/100/1000M) RJ45 port using an on-board
    VSC8211 PHY, which can be connected to VSC7558 NPI port through SGMII
    using a loopback add-on PCB)

This series provides support for:
  - SFPs and DAC cables via PHYLINK with a number of 5G, 10G and 25G
    devices and media types.
  - Port module configuration for 10M to 25G speeds with SGMII, QSGMII,
    1000BASEX, 2500BASEX and 10GBASER as appropriate for these modes.
  - SerDes configuration via the Sparx5 SerDes driver (see below).
  - Host mode providing register based injection and extraction.
  - Switch mode providing MAC/VLAN table learning and Layer2 switching
    offloaded to the Sparx5 switch.
  - STP state, VLAN support, host/bridge port mode, Forwarding DB, and
    configuration and statistics via ethtool.

More support will be added at a later stage.

The Sparx5 Chip Register Model can be browsed at this location:
https://github.com/microchip-ung/sparx-5_reginfo
and the datasheet is available here:
https://ww1.microchip.com/downloads/en/DeviceDoc/SparX-5_Family_L2L3_Enterprise_10G_Ethernet_Switches_Datasheet_00003822B.pdf

The series depends on the following series currently on its way
into the kernel:

- Sparx5 Reset Driver
  Link: https://lore.kernel.org/r/20210416084054.2922327-1-steen.hegelund@microchip.com/

ChangeLog:
v3:
    - basic driver:
        - removed unneeded braces
        - release reference to ports node after use
        - use dev_err_probe to handle DEFER
        - update error value when bailing out (a few cases)
        - updated formatting of port struct and grouping of bool values
        - simplified the spx5_rmw and spx5_inst_rmw inline functions
    - host mode (netdev):
        - removed lockless flag
        - added port timer init
    - host mode (packet - manual injection):
        - updated error counters in error situations
        - implemented timer handling of watermark threshold: stop and
          restart netif queues.
        - fixed error message handling (rate limited)
        - fixed comment style error
        - used DIV_ROUND_UP macro
        - removed a debug message for open ports

v2:
    - Updated bindings:
        - drop minItems for the reg property
    - Statistics implementation:
        - Reorganized statistics into ethtool groups:
            eth-phy, eth-mac, eth-ctrl, rmon
          as defined by the IEEE 802.3 categories and RFC 2819.
        - The remaining statistics are provided by the classic ethtool
          statistics command.
    - Hostmode support:
        - Removed netdev renaming
        - Validate ethernet address in sparx5_set_mac_address()

Steen Hegelund (10):
  dt-bindings: net: sparx5: Add sparx5-switch bindings
  net: sparx5: add the basic sparx5 driver
  net: sparx5: add hostmode with phylink support
  net: sparx5: add port module support
  net: sparx5: add mactable support
  net: sparx5: add vlan support
  net: sparx5: add switching support
  net: sparx5: add calendar bandwidth allocation support
  net: sparx5: add ethtool configuration and statistics support
  arm64: dts: sparx5: Add the Sparx5 switch node

 .../bindings/net/microchip,sparx5-switch.yaml |  226 +
 arch/arm64/boot/dts/microchip/sparx5.dtsi     |   94 +-
 .../dts/microchip/sparx5_pcb134_board.dtsi    |  481 +-
 .../dts/microchip/sparx5_pcb135_board.dtsi    |  621 ++-
 drivers/net/ethernet/microchip/Kconfig        |    2 +
 drivers/net/ethernet/microchip/Makefile       |    2 +
 drivers/net/ethernet/microchip/sparx5/Kconfig |    9 +
 .../net/ethernet/microchip/sparx5/Makefile    |   10 +
 .../microchip/sparx5/sparx5_calendar.c        |  596 +++
 .../microchip/sparx5/sparx5_ethtool.c         | 1227 +++++
 .../microchip/sparx5/sparx5_mactable.c        |  500 ++
 .../ethernet/microchip/sparx5/sparx5_main.c   |  869 +++
 .../ethernet/microchip/sparx5/sparx5_main.h   |  366 ++
 .../microchip/sparx5/sparx5_main_regs.h       | 4642 +++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  249 +
 .../ethernet/microchip/sparx5/sparx5_packet.c |  320 ++
 .../microchip/sparx5/sparx5_phylink.c         |  195 +
 .../ethernet/microchip/sparx5/sparx5_port.c   | 1129 ++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |   98 +
 .../microchip/sparx5/sparx5_switchdev.c       |  508 ++
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |  224 +
 21 files changed, 12284 insertions(+), 84 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/microchip,sparx5-switch.yaml
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Kconfig
 create mode 100644 drivers/net/ethernet/microchip/sparx5/Makefile
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_calendar.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_ethtool.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_mactable.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_main_regs.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_netdev.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_packet.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_phylink.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_port.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_port.h
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_switchdev.c
 create mode 100644 drivers/net/ethernet/microchip/sparx5/sparx5_vlan.c

-- 
2.31.1


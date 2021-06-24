Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B813A3B2849
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 09:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbhFXHLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 03:11:15 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35859 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231601AbhFXHLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 03:11:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1624518533; x=1656054533;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=E4OlktWixIbVNlY3xAn9cvRCv7jfEy7N8kbsvQm680U=;
  b=LSbGTpW6ceaKm5+jbuX4/VyYPtVt7zfwrwaJ9GwOcmVlN4WSf5M0T9R8
   XtClgOpIepJ9BgaY0OhbLa6nwJePClIy0bW9aNXnb9VADmhXDAJAI56Q6
   EkeLdJD/kkRMb+GmoW5mtav3hM5LiA2JFlzIJFE8Y6VLY0OThu0jaE8mu
   Q+pXS4q0BoA9SRMjsoUSmCAnr2M4UNa6upM7rN9F/W/SanEqEDmV4vIDP
   aSqTqlAYFOxUI9yG4GAzr8qxIiJMsU8sRiw+FBqxDxLtH04oiUHvjZKLV
   vG9W8nVQ4i2gLXdPN3be3fOLOObSU3bUMnrK+evzQS9rHoy/qB5YyxN5w
   A==;
IronPort-SDR: jsFD+8FYQakUBDkEp2PASuV/T3Y7MFlHFjdUkhWBrGqO/vGpYLlvj1Mbd74eOjCfOAPAMusVjs
 ZBs13misTeLM0vnxwy1FLhCybVnxSC6mD/UwMAalZOs1BhU+7iQkuHQBfqbufIWDObUEq3Yyvu
 S1lVesQwZ8J3V4FyRtn6zPmfg7dVim0VsGRBR+NDjyHstAHb9TAAAYdXqnKKPxDdIvJuqZtjRB
 voQYo9T30d7lwWRVO+jhoKdajuL4qVbLsRvaOVYsuM/pUc6vOxbd+YS5HFpxOG52ftEFiaNUg/
 0nU=
X-IronPort-AV: E=Sophos;i="5.83,295,1616482800"; 
   d="scan'208";a="125891375"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2021 00:08:08 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 24 Jun 2021 00:08:07 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Thu, 24 Jun 2021 00:08:03 -0700
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
Subject: [PATCH net-next v5 00/10] Adding the Sparx5i Switch Driver
Date:   Thu, 24 Jun 2021 09:07:48 +0200
Message-ID: <20210624070758.515521-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series provides the Microchip Sparx5i Switch Driver

The SparX-5 Enterprise Ethernet switch family provides a rich set of
Enterprise switching features such as advanced TCAM-based VLAN and QoS
processing enabling delivery of differentiated services, and security
through TCAMbased frame processing using versatile content aware processor
(VCAP). IPv4/IPv6 Layer 3 (L3) unicast and multicast routing is supported
with up to 18K IPv4/9K IPv6 unicast LPM entries and up to 9K IPv4/3K IPv6
(S,G) multicast groups. L3 security features include source guard and
reverse path forwarding (uRPF) tasks. Additional L3 features include
VRF-Lite and IP tunnels (IP over GRE/IP).

The SparX-5 switch family features a highly flexible set of Ethernet ports
with support for 10G and 25G aggregation links, QSGMII, USGMII, and
USXGMII.  The device integrates a powerful 1 GHz dual-core ARM® Cortex®-A53
CPU enabling full management of the switch and advanced Enterprise
applications.

The SparX-5 switch family targets managed Layer 2 and Layer 3 equipment in
SMB, SME, and Enterprise where high port count 1G/2.5G/5G/10G switching
with 10G/25G aggregation links is required.

The SparX-5 switch family consists of following SKUs:

  VSC7546 SparX-5-64 supports up to 64 Gbps of bandwidth with the following
  primary port configurations.
   - 6 ×10G
   - 16 × 2.5G + 2 × 10G
   - 24 × 1G + 4 × 10G

  VSC7549 SparX-5-90 supports up to 90 Gbps of bandwidth with the following
  primary port configurations.
   - 9 × 10G
   - 16 × 2.5G + 4 × 10G
   - 48 × 1G + 4 × 10G

  VSC7552 SparX-5-128 supports up to 128 Gbps of bandwidth with the
  following primary port configurations.
   - 12 × 10G
   - 6 x 10G + 2 x 25G
   - 16 × 2.5G + 8 × 10G
   - 48 × 1G + 8 × 10G

  VSC7556 SparX-5-160 supports up to 160 Gbps of bandwidth with the
  following primary port configurations.
   - 16 × 10G
   - 10 × 10G + 2 × 25G
   - 16 × 2.5G + 10 × 10G
   - 48 × 1G + 10 × 10G

  VSC7558 SparX-5-200 supports up to 200 Gbps of bandwidth with the
  following primary port configurations.
   - 20 × 10G
   - 8 × 25G

In addition, the device supports one 10/100/1000/2500/5000 Mbps
SGMII/SerDes node processor interface (NPI) Ethernet port.

Time sensitive networking (TSN) is supported through a comprehensive set of
features including frame preemption, cut-through, frame replication and
elimination for reliability, enhanced scheduling: credit-based shaping,
time-aware shaping, cyclic queuing, and forwarding, and per-stream policing
and filtering.

Together with IEEE 1588 and IEEE 802.1AS support, this guarantees
low-latency deterministic networking for Industrial Ethernet.

The Sparx5i support is developed on the PCB134 and PCB135 evaluation boards.

- PCB134 main networking features:
  - 12x SFP+ front 10G module slots (connected to Sparx5i through SFI).
  - 8x SFP28 front 25G module slots (connected to Sparx5i through SFI high
    speed).
  - Optional, one additional 10/100/1000BASE-T (RJ45) Ethernet port
    (on-board VSC8211 PHY connected to Sparx5i through SGMII).

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
  - SerDes configuration via the Sparx5i SerDes driver (see below).
  - Host mode providing register based injection and extraction.
  - Switch mode providing MAC/VLAN table learning and Layer2 switching
    offloaded to the Sparx5i switch.
  - STP state, VLAN support, host/bridge port mode, Forwarding DB, and
    configuration and statistics via ethtool.

More support will be added at a later stage.

The Sparx5i Chip Register Model can be browsed at this location:
https://github.com/microchip-ung/sparx-5_reginfo
and the datasheet is available here:
https://ww1.microchip.com/downloads/en/DeviceDoc/SparX-5_Family_L2L3_Enterprise_10G_Ethernet_Switches_Datasheet_00003822B.pdf

The series depends on the following series currently on their way
into the kernel:

- 25G Base-R phy mode
  Link: https://lore.kernel.org/r/20210611125453.313308-1-steen.hegelund@microchip.com/
- Sparx5 Reset Driver
  Link: https://lore.kernel.org/r/20210416084054.2922327-1-steen.hegelund@microchip.com/

ChangeLog:
v5:
    - cover letter
        - updated the description to match the latest data sheets
    - basic driver
        - added error message in case of reset controller error
        - port struct: replacing has_sfp with inband, adding pause_adv
    - host mode
        - port cleanup: unregisters netdevs and then removes phylink etc
        - checking for pause_adv when comparing port config changes
        - getting duplex and pause state in the link_up callback.
        - getting inband, autoneg and pause_adv config in the pcs_config
          callback.
    - port
        - use only the pause_adv bits when getting aneg status
        - use the inband state when updating the PCS and port config
v4:
    - basic driver:
        Using devm_reset_control_get_optional_shared to get the reset
        control, and let the reset framework check if it is valid.
    - host mode (phylink):
        Use the PCS operations to get state and update configuration.
        Removed the setting of interface modes.  Let phylink control this.
        Using the new 5gbase-r and 25gbase-r modes.
        Using a helper function to check if one of the 3 base-r modes has
        been selected.
        Currently it will not be possible to change the interface mode by
        changing the speed (e.g via ethtool).  This will be added later.
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
 .../ethernet/microchip/sparx5/sparx5_main.c   |  852 +++
 .../ethernet/microchip/sparx5/sparx5_main.h   |  375 ++
 .../microchip/sparx5/sparx5_main_regs.h       | 4642 +++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  264 +
 .../ethernet/microchip/sparx5/sparx5_packet.c |  320 ++
 .../microchip/sparx5/sparx5_phylink.c         |  210 +
 .../ethernet/microchip/sparx5/sparx5_port.c   | 1146 ++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |   93 +
 .../microchip/sparx5/sparx5_switchdev.c       |  508 ++
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |  224 +
 21 files changed, 12318 insertions(+), 84 deletions(-)
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
2.32.0


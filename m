Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69BD62F7D4E
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 14:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733105AbhAONzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 08:55:12 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:20417 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733038AbhAONzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 08:55:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610718910; x=1642254910;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=k9+XkPitT3RGtZXtCrH8DwfqUOFo/Zwho/1sS7zAbBk=;
  b=G8e0YjS6RLWuDaksyzSMTLpQPuExdoiiAfl5i5c3trVtmXTidd0q+GyP
   bZq2Lj4Ftzp/yGIBQjh8G8qOn7sg05qDCwsm+e3xXio8HTPZRU2JH1ASW
   Z3ZpXy4CJkT0bBVCAVu22cHCagQZ7M9m3/5wXPiLifyE8xehnqhzcuWSk
   N7athnv7xXOzgDh9zR8Vdk0NVHLhlvcmgcGGuYSBJYKkzmtCd4wG/cNGc
   GeYrWHsK7b0glgcprebuqCpyNt8y7CdXEKq0NTI36QON8Vw9WJuZoMmOb
   83FLTltrPplxszMF8TWeaqFRdyEgeEZ54cKl14QQ7nRuEnkbw3Pb4Huh6
   A==;
IronPort-SDR: 3GKjn99KrMiK84GVKK48DfRvPkHoin6atBB2TKpn7pYSWuFWxt8GPRKwStLWy99NzRsLci515F
 qLs2NgERSN1SHBmPunPwxL0yKwSRUyPy/ZQk2LMXHlsX2l98GwS30yg78nYlKvXMtx9Sze7pk4
 7seZxCt5BeAHfcLM6Gh6ico1ATIEq2a5ROQVh0YThacu//VCytSVcv22qnwDZG7DJe7IOr5GD1
 Pt/PZYsg5NjUcp6a/IbyuyURTks06mEiNXNElsTl/vVPAyN/9qzyYpjSVhPAtJEI4SnUcSa5i5
 MyQ=
X-IronPort-AV: E=Sophos;i="5.79,349,1602572400"; 
   d="scan'208";a="103001373"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jan 2021 06:53:53 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 15 Jan 2021 06:53:53 -0700
Received: from mchp-dev-shegelun.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.1979.3 via Frontend Transport; Fri, 15 Jan 2021 06:53:49 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King <linux@armlinux.org.uk>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Mark Einon <mark.einon@gmail.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [RFC PATCH v3 0/8] Adding the Sparx5 Switch Driver
Date:   Fri, 15 Jan 2021 14:53:31 +0100
Message-ID: <20210115135339.3127198-1-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.29.2
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

The Sparx5 Switch chip register model can be browsed here:
Link: https://microchip-ung.github.io/sparx-5_reginfo/reginfo_sparx-5.html

The series depends on the following series currently on their way
into the kernel:

- Sparx5 SerDes Driver
  Link: https://lore.kernel.org/r/20201211090541.157926-1-steen.hegelund@microchip.com/

- Sparx5 Reset Driver
  Link: https://lore.kernel.org/lkml/20210114162432.3039657-1-steen.hegelund@microchip.com/

The 100 Base-X mode is being added to the kernel with this series:
Link: https://lore.kernel.org/netdev/20210113115626.17381-1-bjarni.jonasson@microchip.com/

ChangeLog:
    v3:
        - Updated the bindings with
            - adding maxItems: 1 to the port properties in general.
            - mac-address property added
            - sd-gpio property added
            - phy-mode is now required
        - Main module
            - Reworked the driver probe to have 3 stages:
                - Initalization, DT parsing and creating SerDes instances
                - Mapping IO targets
                - Creating ports using DT information and further
                  switch initialization.
            - Wrapped long lines to fit to 80 chars (netdev style)
            - Reworking the switch RAM initialization
            - Made the target table const
            - Return -EINVAL if no coreclock was found.
            - Applied the Reverse Christmas Tree pattern to several
              functions
            - Changes to DT properties:
                - max-speed changed to bandwidth
                - phy-mode is required
            - Removed the reset postcore_initcall code (will be provided in
              a reset driver, see link above)
            - Requesting the reset driver and using that for resetting the
              switch core.
            - Using a bool (has_sfp) to determine if an SFP is available
              for the particular port and removing the sparx5_use_cu_phy
              function.
            - For the basic driver patch: added comments to indicate where
              subsequent patches will be adding more functionality.
        - Netdev module
            - Increment Ethernet addresses correctly.
            - Removed  ether_setup() call.
        - Packet module
            - Used error codes instead of -1.
        - Phylink module
            - Include autoneg and pause when detecting port config changes
        - Port module
            - Added decode_* status functions
            - Removed the preliminary 100fx functionality.  There is
              phylink support on the way for 100 Base-X (see link above),
              so when that is available the 100fx mode will be added again.
            - Made the taxi dist table constant
            - Using named symbols in autoneg decoding
        - MAC table module
            - Removed inline from functions.
            - Changed the default aging to BR_DEFAULT_AGEING_TIME
        - Ethtool module
            - Removed the mutex. Copy statistic on request. Updating time
              is 1s.
        - Device tree
            - Added reset controller properties
        - Common
            - Remove the inclusion of the sparx5_main_regs.h in the
              sparx5_main.h

    v2:
        - The driver patch has been split into 6 patches by functionality
          like this:
            - the basic sparx5 driver
            - hostmode with phylink support
            - port module support
            - switching, vlan and mactable support
            - calendar bandwidth allocation support
            - ethtool configuration and statistics support
        - IO ranges have been collapsed into just 2 (the SerDes
          driver uses the area inbetween) and the driver uses an
          offset table to get the target instances.
        - register macros have been converted to functions
        - register_netdev() moved to the end of the switch initialization.
        - sparx5_update_port_stats: use reverse christmas tree
        - sparx5_get_sset_strings: copy individual strings
        - sparx5_port_open: updated to better use phylink: just call
          phylink_of_phy_connect directly
        - sparx5_destroy_netdev: always take the NL lock
        - sparx5_attr_stp_state_set: added learning state.
        - sparx5_phylink_mac_config: use phylink to provide the
          status for the devices phylink controls.
        - sparx5_get_1000basex_status: renamed to sparx5_get_dev2g5_status
          and corrected an error when combining the sync and link status
          information.
        - let phylink provide link status for cuPHYs and SFPs
        - corrected the pause mode status handling
        - use ethtool's get_link function directly
        - remove the use of the phy_validate function
        - sparx5_update_counter function: no longer inline
        - Removed the wrapper functions around the mactable mutex


Steen Hegelund (8):
  dt-bindings: net: sparx5: Add sparx5-switch bindings
  net: sparx5: add the basic sparx5 driver
  net: sparx5: add hostmode with phylink support
  net: sparx5: add port module support
  net: sparx5: add switching, vlan and mactable support
  net: sparx5: add calendar bandwidth allocation support
  net: sparx5: add ethtool configuration and statistics support
  arm64: dts: sparx5: Add the Sparx5 switch node

 .../bindings/net/microchip,sparx5-switch.yaml |  211 +
 arch/arm64/boot/dts/microchip/sparx5.dtsi     |   62 +
 .../dts/microchip/sparx5_pcb134_board.dtsi    |  444 +-
 .../dts/microchip/sparx5_pcb135_board.dtsi    |  606 ++-
 drivers/net/ethernet/microchip/Kconfig        |    2 +
 drivers/net/ethernet/microchip/Makefile       |    2 +
 drivers/net/ethernet/microchip/sparx5/Kconfig |    9 +
 .../net/ethernet/microchip/sparx5/Makefile    |   11 +
 .../microchip/sparx5/sparx5_calendar.c        |  596 +++
 .../microchip/sparx5/sparx5_ethtool.c         |  969 ++++
 .../microchip/sparx5/sparx5_mactable.c        |  500 +++
 .../ethernet/microchip/sparx5/sparx5_main.c   |  851 ++++
 .../ethernet/microchip/sparx5/sparx5_main.h   |  358 ++
 .../microchip/sparx5/sparx5_main_regs.h       | 3922 +++++++++++++++++
 .../ethernet/microchip/sparx5/sparx5_netdev.c |  247 ++
 .../ethernet/microchip/sparx5/sparx5_packet.c |  283 ++
 .../microchip/sparx5/sparx5_phylink.c         |  195 +
 .../ethernet/microchip/sparx5/sparx5_port.c   | 1123 +++++
 .../ethernet/microchip/sparx5/sparx5_port.h   |   98 +
 .../microchip/sparx5/sparx5_switchdev.c       |  517 +++
 .../ethernet/microchip/sparx5/sparx5_vlan.c   |  224 +
 21 files changed, 11170 insertions(+), 60 deletions(-)
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
2.29.2


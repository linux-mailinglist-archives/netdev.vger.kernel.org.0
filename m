Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 389F23D3EB4
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 19:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231633AbhGWQup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 12:50:45 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:10454 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbhGWQuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 12:50:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1627061478; x=1658597478;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=7q02+t9IdbPUK3xfkF8qG3zdY/QCcOJgPLbPDERww/U=;
  b=n+Ha82b7LOtGL8DO3lxvE2UjtKHPUXR5ksJlcKlu6AWGL0oHUPfqbTrX
   K53Z4NxYHb3jA4gpxbl9ZX6I1U3yj+90e2aIT0mmlNxkGZLf/AuHiO1wv
   W647aB1UBOjnQkb52XXSKw86suKbEsGo3NcKRl+un7BzUGXIjfIJvUS5j
   EFGiQ61eGzNQwOwenznczPq17wSvgzroCU9EdPPM0Pg8HMjTVRdqNvTIA
   U9EcwoEKsQCCA/jM8ZzdRu0d1suqDWN3b1wi9JLS4jj2zNqQ2b3XBODkE
   u8s8cdcx49KoRPPt3ZVrCJOT5WrljV3UhkCZNBxXPOKVJd+/ecJeQcbxL
   A==;
IronPort-SDR: yvE4mCD+FKZjBObLUQaLlR0GyMN0jBK9XB9ArcL9sDoCt52hK5D+c5q95FakLbYEOkYVFf6DDn
 v7vBb1N0sCD8QRAaPaB92GcXOeYYJx6qNutxlZhW10Y669hMi4FnucxfIwY461wnDVT6ElIOOC
 ISgFVPZFBwO50eCVo4Zj3YgFch0cwOmMA9PAw0N+s8DR3vWsfRBzG5OmKsLRoVUyG2qFNORRa4
 oQAEksIbW2nHIqlBiB1r/upJtSCR4ijYFuLCBKmAsKgd6CXBfQjFEHjWiHeKhiV0tXhtGoUTuL
 0nBapwL5/4tDs8njMaZv3rTU
X-IronPort-AV: E=Sophos;i="5.84,264,1620716400"; 
   d="scan'208";a="63393536"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2021 10:31:17 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 23 Jul 2021 10:31:17 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Fri, 23 Jul 2021 10:31:11 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v3 net-next 00/10] net: dsa: microchip: DSA driver support for LAN937x switch
Date:   Fri, 23 Jul 2021 23:00:58 +0530
Message-ID: <20210723173108.459770-1-prasanna.vengateshan@microchip.com>
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

Changes in v3: 
- Removed settings of cnt_ptr to zero and the memset() 
  added a cleanup patch which moves this into ksz_init_mib_timer().
- Used ret everywhere instead of rc
- microchip,lan937x.yaml: Remove mdio compatible
- microchip_t1.c: Renaming standard phy registers
- tag_ksz.c: LAN937X_TAIL_TAG_OVERRIDE renaming 
  LAN937X_TAIL_TAG_BLOCKING_OVERRIDE
- tag_ksz.c: Changed Ingress and Egress naming convention based on 
  Host
- tag_ksz.c: converted to skb_mac_header(skb) from 
  (is_link_local_ether_addr(hdr->h_dest))
- lan937x_dev.c: Removed BCAST Storm protection settings since we
  have Tc commands for them
- lan937x_dev.c: Flow control setting in lan937x_port_setup function
- lan937x_dev.c: RGMII internal delay added only for cpu port, 
- lan937x_dev.c: of_get_compatible_child(node, 
  "microchip,lan937x-mdio") to of_get_child_by_name(node, "mdio");
- lan937x_dev.c:lan937x_get_interface API: returned 
  PHY_INTERFACE_MODE_INTERNAL instead of PHY_INTERFACE_MODE_NA
- lan937x_main.c: Removed compat interface implementation in 
  lan937x_config_cpu_port() API & dev_info corrected as well
- lan937x_main.c: deleted ds->configure_vlan_while_not_filtering 
  = true
- lan937x_main.c: Added explanation for lan937x_setup lines
- lan937x_main.c: FR_MAX_SIZE correction in lan937x_get_max_mtu API 
- lan937x_main.c: removed lan937x_port_bridge_flags dummy functions
- lan937x_spi.c - mdiobus_unregister to be added to spi_remove 
  function
- lan937x_main.c: phy link layer changes  
- lan937x_main.c: port mirroring: sniff port selection limiting to
  one port
- lan937x_main.c: Changed to global vlan filtering
- lan937x_main.c: vlan_table array to structure
- lan937x_main.c -Use extack instead of reporting errors to Console
- lan937x_main.c - Remove cpu_port addition in vlan_add api
- lan937x_main.c - removed pvid resetting

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

Prasanna Vengateshan (10):
  dt-bindings: net: dsa: dt bindings for microchip lan937x
  net: dsa: move mib->cnt_ptr reset code to ksz_common.c
  net: phy: Add support for LAN937x T1 phy driver
  net: dsa: tag_ksz: add tag handling for Microchip LAN937x
  net: dsa: microchip: add DSA support for microchip lan937x
  net: dsa: microchip: add support for phylink management
  net: dsa: microchip: add support for ethtool port counters
  net: dsa: microchip: add support for port mirror operations
  net: dsa: microchip: add support for fdb and mdb management
  net: dsa: microchip: add support for vlan operations

 .../bindings/net/dsa/microchip,lan937x.yaml   |  148 ++
 MAINTAINERS                                   |    1 +
 drivers/net/dsa/microchip/Kconfig             |   12 +
 drivers/net/dsa/microchip/Makefile            |    5 +
 drivers/net/dsa/microchip/ksz8795.c           |    2 -
 drivers/net/dsa/microchip/ksz9477.c           |    3 -
 drivers/net/dsa/microchip/ksz_common.c        |    8 +-
 drivers/net/dsa/microchip/ksz_common.h        |    5 +
 drivers/net/dsa/microchip/lan937x_dev.c       |  696 ++++++++++
 drivers/net/dsa/microchip/lan937x_dev.h       |   83 ++
 drivers/net/dsa/microchip/lan937x_main.c      | 1231 +++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h       |  677 +++++++++
 drivers/net/dsa/microchip/lan937x_spi.c       |  223 +++
 drivers/net/phy/microchip_t1.c                |  319 ++++-
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    4 +-
 net/dsa/tag_ksz.c                             |   56 +
 17 files changed, 3408 insertions(+), 67 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_spi.c

-- 
2.27.0


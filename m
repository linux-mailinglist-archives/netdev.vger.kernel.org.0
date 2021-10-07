Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F98142564F
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 17:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233270AbhJGPOM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 11:14:12 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:53441 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242271AbhJGPOL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 11:14:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1633619537; x=1665155537;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=D70JVxMfSfmVMdTOKpBTDmpFGOLkWX+Th0+hTLH1Meo=;
  b=W6qfQIpULaAe05p98Z+6jKLk/GeoS4e8gPiGmRXxAZGFAE66wCqEGQ2j
   wIQFnCL8bTLDGfpnplcqnwvn93pghX4HPiJhc4C2zhlA0j27VshIdSBx7
   orUTsrp5Epdk6EPKM6ksQV3G1oc+wZtYvI9c7CgCyV5KWqJ3r73Jwxd78
   QNBp6rKA4y7xSHuWu4KlKm2ZmGd4J4oMFru/xyF41ABV98ZU0R0OitnID
   zHLde7WDnpFRJDg0fIjo56jfDv7HbeWsNEeCQkqDkthtWmvStiYFM7w4t
   2PdrpeJ4Wp5IyicmSh+3gfXC/NXTe62KmpXS6ub40f1m/pqEHmbWe7A+a
   g==;
IronPort-SDR: mTP/yqyaYfZ9eqHtC9SHbyzQCzK+gLn7k6Ho+GqkN24RYnnplvSKR9kx4QH6S4ysAxTUskxJh3
 SYcicyUCzEry0WA2DISoc10dv5etfazlYDUvsBMKDFYxny1OzVJBwFGMu1TaIfrKpZZm6otyc7
 Ak2nFeypUOBb3blCX7UKygHQlSOWwCzIb1oZ/EapH2IC7Z90LDjmRjjUBz/8qbjTOV7+/FzLWX
 dA30U0X0y3rL3iVxFjR5Wkt/rAK4Kanq3ubukrcyW1UEL3AzdvJlMZtziDJFpjb0ogp2NqASc3
 58Bm+X4WfWUqSojKoki3dItu
X-IronPort-AV: E=Sophos;i="5.85,355,1624345200"; 
   d="scan'208";a="72033694"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 07 Oct 2021 08:12:12 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 7 Oct 2021 08:12:12 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 7 Oct 2021 08:12:04 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v4 net-next 00/10] net: dsa: microchip: DSA driver support for LAN937x switch
Date:   Thu, 7 Oct 2021 20:41:50 +0530
Message-ID: <20211007151200.748944-1-prasanna.vengateshan@microchip.com>
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

Changes in v4:
- tag_ksz.c: cpu_to_be16 to  put_unaligned_be16
- correct spacing in comments
- tag_ksz.c: NETIF_F_HW_CSUM fix is integrated 
- lan937x_dev.c: mdio_np is removed from global and handled locally
- lan937x_dev.c: unused functions removed lan937x_cfg32 & lan937x_port_cfg32
- lan937x_dev.c: lan937x_is_internal_100BTX_phy_port function name changes
- lan937x_dev.c: RGMII internal delay handling for MAC. Delay values are
  retrieved from DTS and updated
- lan937x_dev.c: corrected mutex operations for few dev variables
- microchip,lan937x.yaml: introduced rx-internal-delay-ps & 
  tx-internal-delay-ps for RGMII internal delay
- lan937x_dev.c: Unnecessary mutex_lock has been removed
- lan937x_main.c: PHY_INTERFACE_MODE_NA handling for lan937x_phylink_validate
- lan937x_main.c: PORT_MIRROR_SNIFFER check in right place
- lan937x_main.c: memset is used instead of writing 0's individually in 
  lan937x_port_fdb_add function
- lan937x_main.c: Removed \n from NL_SET_ERR_MSG_MOD calls

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

 .../bindings/net/dsa/microchip,lan937x.yaml   |  160 ++
 MAINTAINERS                                   |    1 +
 drivers/net/dsa/microchip/Kconfig             |   12 +
 drivers/net/dsa/microchip/Makefile            |    5 +
 drivers/net/dsa/microchip/ksz8795.c           |    2 -
 drivers/net/dsa/microchip/ksz9477.c           |    3 -
 drivers/net/dsa/microchip/ksz_common.c        |    8 +-
 drivers/net/dsa/microchip/ksz_common.h        |    5 +
 drivers/net/dsa/microchip/lan937x_dev.c       |  725 +++++++++
 drivers/net/dsa/microchip/lan937x_dev.h       |   80 +
 drivers/net/dsa/microchip/lan937x_main.c      | 1310 +++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h       |  683 +++++++++
 drivers/net/dsa/microchip/lan937x_spi.c       |  227 +++
 drivers/net/phy/microchip_t1.c                |  339 ++++-
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    4 +-
 net/dsa/tag_ksz.c                             |   59 +
 17 files changed, 3554 insertions(+), 71 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_spi.c

-- 
2.27.0


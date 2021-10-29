Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08B4243F682
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 07:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhJ2FZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 01:25:37 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:21280 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230362AbhJ2FZg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 01:25:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1635484988; x=1667020988;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=lDSaBiCQ1m0EcFGL2hr9EMr5hCuhadEUvcGXFIeENwA=;
  b=iZgG5tLWLSiTjjsGW56IYzL+Y6aNOce3oLxG8yyb/AWaBdLdKmS4E/ei
   QnqRSW9NuOZDAbzRVwwgP5mtitQvc6YyPc3oSwf/8DFbWIjOjNlyUX04C
   vgYLb87sP0MWPwQJ8wOzhwDkxTm3GY7mAm2q9h3PBXgv9I+Qz0cJNaA+e
   jjMIM8fC57PYynYjuxkyBoYfbOCv8qqxBxZZPaw3YPx6E3kjmsXbsAtbV
   nAfM9226yD8eyqiz3XfLx4DrksuiMOvLgSKMYrU01MITz/aDKWmueGylj
   fP4AUxaxYU/4B1WbVep4jj8JqBcb3W5CRaHFVyWQvXM9g35ZjIfO7ELuE
   A==;
IronPort-SDR: Ab8CfMhUM39GAJkpwJhj1PJGMm+xBQhTHc7Pse/+07PmWqAckgujsmXbpgSNlbjuwDOpz/xfQE
 64wTp9Wj7UIjRws2cMPtN4cuq9Wfz0Gu1MniCd1iTtyOlspB4ZkwyorOzDp0CpaUeuDnQLc60N
 51MH6xdIO5/xYSKHjRhZMwqIL0jfhSFbmDTjAoEFcegWs3gfNHReljTjx1v8lPDiphU41yHS6g
 cu8ywOgylcW3gTTUtQz9y8AHYTwwVits5GqaHv90D3umb25223tcfkco2fTPvV3eb23Du39k8h
 3ep7U0skFyFy0te81sNKWato
X-IronPort-AV: E=Sophos;i="5.87,191,1631602800"; 
   d="scan'208";a="142107742"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Oct 2021 22:23:07 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 28 Oct 2021 22:23:07 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.14 via Frontend Transport; Thu, 28 Oct 2021 22:22:59 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <Woojung.Huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v6 net-next 00/10] net: dsa: microchip: DSA driver support for LAN937x switch
Date:   Fri, 29 Oct 2021 10:52:46 +0530
Message-ID: <20211029052256.144739-1-prasanna.vengateshan@microchip.com>
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

Changes in v6:
- microchip_t1.c: There was new merge done in the net-next tree for microchip_1.c
after the v5 submission. Hence rebased it for v6.

Changes in v5:
- microchip,lan937x.yaml: Added mdio properties detail
- microchip,lan937x.yaml: *-internal-delay-ps added under port node
- lan937x_dev.c: changed devm_mdiobus_alloc from of_mdiobus_register as suggested
  by Vladimir
- lan937x_dev.c: added dev_info for rgmii internal delay & error message to user
  in case of out of range values
- lan937x_dev.c: return -EOPNOTSUPP for C45 regnum values for lan937x_sw_mdio_read
  & write operations
- return from function with out storing in a variable
- lan937x_main.c: Added vlan_enable info in vlan_filtering API
- lan937x_main.c: lan937x_port_vlan_del: removed unintended PVID write

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

 .../bindings/net/dsa/microchip,lan937x.yaml   |  180 +++
 MAINTAINERS                                   |    1 +
 drivers/net/dsa/microchip/Kconfig             |   12 +
 drivers/net/dsa/microchip/Makefile            |    5 +
 drivers/net/dsa/microchip/ksz8795.c           |    2 -
 drivers/net/dsa/microchip/ksz9477.c           |    3 -
 drivers/net/dsa/microchip/ksz_common.c        |    8 +-
 drivers/net/dsa/microchip/ksz_common.h        |    5 +
 drivers/net/dsa/microchip/lan937x_dev.c       |  730 ++++++++++
 drivers/net/dsa/microchip/lan937x_dev.h       |   80 ++
 drivers/net/dsa/microchip/lan937x_main.c      | 1250 +++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h       |  683 +++++++++
 drivers/net/dsa/microchip/lan937x_spi.c       |  227 +++
 drivers/net/phy/microchip_t1.c                |  345 ++++-
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    4 +-
 net/dsa/tag_ksz.c                             |   59 +
 17 files changed, 3519 insertions(+), 77 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_spi.c

-- 
2.27.0


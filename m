Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 659924DD690
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 09:55:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233940AbiCRI5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 04:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231803AbiCRI5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 04:57:12 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 967BD1F3795;
        Fri, 18 Mar 2022 01:55:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1647593751; x=1679129751;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=JHdelzuv/N9zmmLP1oDfQI0Kd5uN9EjGWCC5ooso51A=;
  b=1FmhH0FArJ9k5RdcifXWa87W5UFdGsJi2/tfWLrNbn/KX4R741iYDGUn
   SrGK53y5E9T7bCaWpMer+cyJOm5PBkgwZDBVNnWEvuyzVD6KSqEfs75c9
   vABnUiu7G3zW8XIRMfFHDvJz+0yviMkLOjpoWDHh1DhfEEtT/sGAHczLO
   qrLOOfpBNjJbdn22gA+4x7bji/tgrUjFnU7cMXRQ/zsEnyJsQM4X2k6yZ
   G7Wbk5dKqB9a24Es5p6nvQiDjmW3KaYA9q89spCjm3Ya3jiyyVbsolxn/
   1E8j3mADa98ZsHQcrbkN31vELlbPEI0Pyfw/w3245GtwX1Z2TZmdDO4Yz
   g==;
X-IronPort-AV: E=Sophos;i="5.90,191,1643698800"; 
   d="scan'208";a="89373759"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Mar 2022 01:55:48 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 18 Mar 2022 01:55:48 -0700
Received: from CHE-LT-I21427LX.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 18 Mar 2022 01:55:43 -0700
From:   Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
To:     <andrew@lunn.ch>, <netdev@vger.kernel.org>, <olteanv@gmail.com>,
        <robh+dt@kernel.org>
CC:     <UNGLinuxDriver@microchip.com>, <woojung.huh@microchip.com>,
        <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <devicetree@vger.kernel.org>
Subject: [PATCH v9 net-next 00/11] net: dsa: microchip: DSA driver support for LAN937x switch
Date:   Fri, 18 Mar 2022 14:25:29 +0530
Message-ID: <20220318085540.281721-1-prasanna.vengateshan@microchip.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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

Changes in v9:
- lan937x_main.c: of_node_put() correction in lan937x_parse_dt_rgmii_delay
- lan937x_dev.c: removed the interface checks from lan937x_apply_rgmii_delay.
- changes in ethernet-controller.yaml, dsa.yaml and microchip,lan937x.yaml.
  subpatches (1/11) & (2/11) covered these changes and it is submitted as a RFC
  patch to get the feedback.

Changes in v8:
- lan937x_dev.c: fixed lan937x_r_mib_pkt warning in the sub patches
- lan937x_main.c: phylink_autoneg_inband() check removed in
  lan937x_phylink_mac_link_up()
- lan937x_main.c: made legacy_pre_march2020 = false as this is non-legacy driver
  and indentation correction in lan937x_phylink_mac_link_up()
- removed unnecessary parenthesis in lan937x_get_strings()

Changes in v7:
- microchip,lan937x.yaml: *-internal-delay-ps enum values & commit messages
  corrections
- lan937x_main.c: removed phylink_validate() and added phylink_get_caps()
- lan937x_main.c: added support for ethtool standard stats   (get_eth_*_stats
  and get_stats64)
- lan937x_main.c: removed unnecessary PVID read from lan937x_port_vlan_del()
- integrated the changes of ksz9477 multi bridging support to lan937x dev and
  tested both multi bridging and STP
- lan937x_port_vlan_del - dummy pvid read removed

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

Prasanna Vengateshan (11):
  dt-bindings: net: make internal-delay-ps based on phy-mode
  dt-bindings: net: add mdio property
  dt-bindings: net: dsa: dt bindings for microchip lan937x
  net: dsa: move mib->cnt_ptr reset code to ksz_common.c
  net: dsa: tag_ksz: add tag handling for Microchip LAN937x
  net: dsa: microchip: add DSA support for microchip lan937x
  net: dsa: microchip: add support for phylink management
  net: dsa: microchip: add support for ethtool port counters
  net: dsa: microchip: add support for port mirror operations
  net: dsa: microchip: add support for fdb and mdb management
  net: dsa: microchip: add support for vlan operations

 .../devicetree/bindings/net/dsa/dsa.yaml      |    4 +
 .../bindings/net/dsa/microchip,lan937x.yaml   |  156 ++
 .../bindings/net/ethernet-controller.yaml     |   37 +-
 MAINTAINERS                                   |    1 +
 drivers/net/dsa/microchip/Kconfig             |   12 +
 drivers/net/dsa/microchip/Makefile            |    5 +
 drivers/net/dsa/microchip/ksz8795.c           |    2 -
 drivers/net/dsa/microchip/ksz9477.c           |    3 -
 drivers/net/dsa/microchip/ksz_common.c        |    8 +-
 drivers/net/dsa/microchip/ksz_common.h        |    5 +
 drivers/net/dsa/microchip/lan937x_dev.c       |  742 ++++++++++
 drivers/net/dsa/microchip/lan937x_dev.h       |  122 ++
 drivers/net/dsa/microchip/lan937x_main.c      | 1312 +++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h       |  688 +++++++++
 drivers/net/dsa/microchip/lan937x_spi.c       |  236 +++
 include/net/dsa.h                             |    2 +
 net/dsa/Kconfig                               |    4 +-
 net/dsa/tag_ksz.c                             |   59 +
 18 files changed, 3378 insertions(+), 20 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_dev.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_spi.c

-- 
2.30.2


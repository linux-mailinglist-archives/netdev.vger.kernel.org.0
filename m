Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D25E563614
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 16:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232278AbiGAOrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 10:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232086AbiGAOr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 10:47:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32AD315A23;
        Fri,  1 Jul 2022 07:47:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656686844; x=1688222844;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=InPQjTtxtZt/cuIXvTi8e6zJruYYN0QpYqw3w6rX3q4=;
  b=WDDQtcpxVlz2CWCOiuy3Ib0SAA8Q/fknkoo0sOhmC/KWgDlCsjZFplTE
   L6B889pVsxEkVyTdMVoaYGVa1Pp9i2sEPB6VZ3CNCGqqvcWADOLtqiUqq
   ELak8WzAsqSd4nT+8Kzom92nzySR3oQVhPLzkwT1TzQWqxqkkwD/oRl0E
   UhO9hSPNVUAFxThKxdFyOL76BuijISl8pjRHLHI7dU+Vxh/2ZdahQHL4v
   31UGL5lLpTuIrF80f1AbZ01P66ZpZirMqXO7lPA/NwMsQeMlpHJ7ageFW
   gpEoCoEb2IVg+Em4xlZQHFcTy0A6+3gqVljTtP143mz3LeGAs9c6cbJ6+
   Q==;
X-IronPort-AV: E=Sophos;i="5.92,237,1650956400"; 
   d="scan'208";a="162955109"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 07:47:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 07:47:21 -0700
Received: from CHE-LT-I17769U.microchip.com (10.10.115.15) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2375.17 via Frontend Transport; Fri, 1 Jul 2022 07:47:01 -0700
From:   Arun Ramadoss <arun.ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     Woojung Huh <woojung.huh@microchip.com>,
        <UNGLinuxDriver@microchip.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "Rob Herring" <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        "Song Liu" <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Subject: [Patch net-next v15 00/13] net: dsa: microchip: DSA Driver support for LAN937x
Date:   Fri, 1 Jul 2022 20:16:39 +0530
Message-ID: <20220701144652.10526-1-arun.ramadoss@microchip.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LAN937x is a Multi-Port 100BASE-T1 Ethernet Physical Layer switch
compliant with the IEEE 802.3bw-2015 specification. The device provides
100 Mbit/s transmit and receive capability over a single Unshielded
Twisted Pair (UTP) cable. LAN937x is successive revision of KSZ series
switch.
This series of patches provide the DSA driver support for
Microchip LAN937X switch through MII/RMII interface. The RGMII interface
support will be added in the follow up series.  LAN937x uses the most of
functionality of KSZ9477.

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
  - 2 RGMII
  - 1 SGMII port

LAN9374:
  - 6 T1 Phys
  - 2 RGMII ports

Changes in v15:
- fixed compilation issue.
- Updated the phylink_mac_link_up to check only for 10/100/1000 speed.

Changes in v14:
- Updated the patch series to latest ksz code refactoring.
- RGMII register configuration is removed from the series. It will be added in
the follow up patch series.

Changes in v13:
- Fixed the compilation issue in patch 5 and 6

Changes in v12:
- Removed the reduntant spi indirect enable in lan937x_init
- Used the ksz_port_stp_state_set function
- Apply rgmii internal delay only if it is rgmii port
- Set the bit for 100baseTx in phylink_get_caps
- Moved the ethtool related API from patch 5 to 7
- Moved lan_alu_entry struct in lan937x_dev.h from patch 5 to 9
- Moved lan_vlan_entry in lan937x_dev.h from patch 5 to 10
- Used the ksz_get_stats64 function for get_stats64 hook
- Splitted the patch 5. one for port configuration, spi driver, phy read &
  write and mtu configuration.
- Updated the indentation in ethernet-controller.yaml
- lan937x.yaml: Removed the blank lines, updated the ethernet handle to macb0.
  Added the rgmii internal delay only for the ports.

Changes in v11:
- Tagged as RFC to get the feedback for the subpatches 1/10, 5/10 and 6/10

Changes in v10:
- dsa.yaml: dropped moving mdio properties to dsa.yaml as per the feedback
https://patchwork.kernel.org/project/netdevbpf/patch/20220318085540.281721-3-prasanna.vengateshan@microchip.com/#24787466
- microchip,lan937x.yaml: Naming convention changes in the example
- lan937x_main.c: Moving configurations from lan937x_reset_switch() to setup()
- lan937x_main.c: helper function has been introduced for
  lan937x_internal_phy_read & write
- lan937x_dev.h: lan_alu_struct struct data type changes
- lan937x_main.c: lan937x_get_stats64 make non blocking
- lan937x_main.c: modified lan937x_port_mirror_add to include extack

Changes in v9:
- lan937x_main.c: of_node_put() correction in lan937x_parse_dt_rgmii_delay
- lan937x_dev.c: removed the interface checks from lan937x_apply_rgmii_delay.
- changes in ethernet-controller.yaml and dsa.yaml

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
- microchip_t1.c: There was new merge done in the net-next tree for
  microchip_1.c after the v5 submission. Hence rebased it for v6.

Changes in v5:
- microchip,lan937x.yaml: Added mdio properties detail
- microchip,lan937x.yaml: *-internal-delay-ps added under port node
- lan937x_dev.c: changed devm_mdiobus_alloc from of_mdiobus_register as suggested
  by Vladimir
- lan937x_dev.c: added dev_info for rgmii internal delay & error message to user
  in case of out of range values
- lan937x_dev.c: return -EOPNOTSUPP for C45 regnum values for
  lan937x_sw_mdio_read & write operations
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

Arun Ramadoss (10):
  net: dsa: microchip: generic access to ksz9477 static and reserved
    table
  net: dsa: microchip: add DSA support for microchip LAN937x
  net: dsa: microchip: lan937x: add dsa_tag_protocol
  net: dsa: microchip: lan937x: add phy read and write support
  net: dsa: microchip: lan937x: register mdio-bus
  net: dsa: microchip: lan937x: add MTU and fast_age support
  net: dsa: microchip: lan937x: add phylink_get_caps support
  net: dsa: microchip: lan937x: add phylink_mac_link_up support
  net: dsa: microchip: lan937x: add phylink_mac_config support
  net: dsa: microchip: add LAN937x in the ksz spi probe

Prasanna Vengateshan (3):
  dt-bindings: net: make internal-delay-ps based on phy-mode
  dt-bindings: net: dsa: dt bindings for microchip lan937x
  net: dsa: tag_ksz: add tag handling for Microchip LAN937x

 .../bindings/net/dsa/microchip,lan937x.yaml   | 192 +++++++
 .../bindings/net/ethernet-controller.yaml     |  35 +-
 MAINTAINERS                                   |   1 +
 drivers/net/dsa/microchip/Kconfig             |   2 +-
 drivers/net/dsa/microchip/Makefile            |   1 +
 drivers/net/dsa/microchip/ksz9477.c           |  27 +-
 drivers/net/dsa/microchip/ksz9477_reg.h       |   3 -
 drivers/net/dsa/microchip/ksz_common.c        | 105 ++++
 drivers/net/dsa/microchip/ksz_common.h        |  20 +
 drivers/net/dsa/microchip/ksz_spi.c           |  26 +
 drivers/net/dsa/microchip/lan937x.h           |  27 +
 drivers/net/dsa/microchip/lan937x_main.c      | 484 ++++++++++++++++++
 drivers/net/dsa/microchip/lan937x_reg.h       | 180 +++++++
 include/net/dsa.h                             |   2 +
 net/dsa/Kconfig                               |   4 +-
 net/dsa/tag_ksz.c                             |  59 +++
 16 files changed, 1143 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/dsa/microchip,lan937x.yaml
 create mode 100644 drivers/net/dsa/microchip/lan937x.h
 create mode 100644 drivers/net/dsa/microchip/lan937x_main.c
 create mode 100644 drivers/net/dsa/microchip/lan937x_reg.h


base-commit: dbdd9a28e1406ab8218a69e60f10a168b968c81d
-- 
2.36.1


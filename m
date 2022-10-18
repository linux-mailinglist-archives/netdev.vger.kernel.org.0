Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F136602A41
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 13:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230238AbiJRLdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 07:33:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiJRLc7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 07:32:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 469ADB97AF;
        Tue, 18 Oct 2022 04:32:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1666092761; x=1697628761;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3laO/psLH7RBKyGCf9tLwxDFMqzoD+OfwuPWa6ZKInk=;
  b=Tg+UQGIh7ZQYvev+rQXec3NytA/wax/jBdWYHU+xKpqWlftRNc91eWej
   tfFGxJIEGr4PMOR+1cFFZE2nt9goVCDVWNYZTQ9tjrbGRccNjGZjE0hFz
   sRlHjuH0B5EB/d3q2qxW/XBin9W6iDJmLDKx0YUpMIiToWIQWd+guLwBz
   VTxJ/wJg1jc3NvYh0iCbL5PsEd5zdy6yVNwtSazByDH9soe1301erz+NT
   amcOKKAW3u3lUG5+SkSY3UeVXO1uraUgjx1cHsmDUwFPBQMC0blQhTGQ2
   HNr3473aqF+1gEad7NsxWcivd3eNzuuCodVcLn+mj57MKsiAYEGxeTh6u
   w==;
X-IronPort-AV: E=Sophos;i="5.95,193,1661842800"; 
   d="scan'208";a="182711108"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Oct 2022 04:32:40 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 18 Oct 2022 04:32:39 -0700
Received: from den-dk-m31857.microchip.com (10.10.115.15) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server id
 15.1.2507.12 via Frontend Transport; Tue, 18 Oct 2022 04:32:36 -0700
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     Steen Hegelund <steen.hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        "Casper Andersson" <casper.casan@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Wan Jiabing <wanjiabing@vivo.com>,
        "Nathan Huckleberry" <nhuck@google.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCH net-next 9/9] net: microchip: sparx5: Adding KUNIT test for the VCAP API
Date:   Tue, 18 Oct 2022 13:31:56 +0200
Message-ID: <20221018113156.2364533-10-steen.hegelund@microchip.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221018113156.2364533-1-steen.hegelund@microchip.com>
References: <20221018113156.2364533-1-steen.hegelund@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This provides a KUNIT test suite for the VCAP APIs encoding functionality.

Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
---
 drivers/net/ethernet/microchip/vcap/Kconfig   |  13 +
 .../microchip/vcap/vcap_ag_api_kunit.h        | 642 ++++++++++++
 .../net/ethernet/microchip/vcap/vcap_api.c    |   4 +
 .../net/ethernet/microchip/vcap/vcap_api.h    |   3 +
 .../ethernet/microchip/vcap/vcap_api_kunit.c  | 933 ++++++++++++++++++
 5 files changed, 1595 insertions(+)
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_ag_api_kunit.h
 create mode 100644 drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c

diff --git a/drivers/net/ethernet/microchip/vcap/Kconfig b/drivers/net/ethernet/microchip/vcap/Kconfig
index a78cbc6ce6bb..1af30a358a15 100644
--- a/drivers/net/ethernet/microchip/vcap/Kconfig
+++ b/drivers/net/ethernet/microchip/vcap/Kconfig
@@ -36,4 +36,17 @@ config VCAP
 	  characteristics. Look in the datasheet for the VCAP specifications for the
 	  specific switchcore.
 
+config VCAP_KUNIT_TEST
+	bool "KUnit test for VCAP library" if !KUNIT_ALL_TESTS
+	depends on KUNIT
+	depends on KUNIT=y && VCAP=y && y
+	default KUNIT_ALL_TESTS
+	help
+	  This builds unit tests for the VCAP library.
+
+	  For more information on KUnit and unit tests in general, please refer
+	  to the KUnit documentation in Documentation/dev-tools/kunit/.
+
+	  If unsure, say N.
+
 endif # NET_VENDOR_MICROCHIP
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_ag_api_kunit.h b/drivers/net/ethernet/microchip/vcap/vcap_ag_api_kunit.h
new file mode 100644
index 000000000000..ddd33b5f0d4c
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_ag_api_kunit.h
@@ -0,0 +1,642 @@
+/* SPDX-License-Identifier: BSD-3-Clause */
+/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
+ * Microchip VCAP API interface for kunit testing
+ * This is a different interface, to be able to include different VCAPs
+ */
+
+/* Use same include guard as the official API to be able to override it */
+#ifndef __VCAP_AG_API__
+#define __VCAP_AG_API__
+
+enum vcap_type {
+	VCAP_TYPE_ES2,
+	VCAP_TYPE_IS0,
+	VCAP_TYPE_IS2,
+	VCAP_TYPE_MAX
+};
+
+/* Keyfieldset names with origin information */
+enum vcap_keyfield_set {
+	VCAP_KFS_NO_VALUE,          /* initial value */
+	VCAP_KFS_ARP,               /* sparx5 is2 X6, sparx5 es2 X6 */
+	VCAP_KFS_ETAG,              /* sparx5 is0 X2 */
+	VCAP_KFS_IP4_OTHER,         /* sparx5 is2 X6, sparx5 es2 X6 */
+	VCAP_KFS_IP4_TCP_UDP,       /* sparx5 is2 X6, sparx5 es2 X6 */
+	VCAP_KFS_IP4_VID,           /* sparx5 es2 X3 */
+	VCAP_KFS_IP6_VID,           /* sparx5 is2 X6, sparx5 es2 X6 */
+	VCAP_KFS_IP_7TUPLE,         /* sparx5 is2 X12, sparx5 es2 X12 */
+	VCAP_KFS_LL_FULL,           /* sparx5 is0 X6 */
+	VCAP_KFS_MAC_ETYPE,         /* sparx5 is2 X6, sparx5 es2 X6 */
+	VCAP_KFS_MLL,               /* sparx5 is0 X3 */
+	VCAP_KFS_NORMAL,            /* sparx5 is0 X6 */
+	VCAP_KFS_NORMAL_5TUPLE_IP4,  /* sparx5 is0 X6 */
+	VCAP_KFS_NORMAL_7TUPLE,     /* sparx5 is0 X12 */
+	VCAP_KFS_PURE_5TUPLE_IP4,   /* sparx5 is0 X3 */
+	VCAP_KFS_TRI_VID,           /* sparx5 is0 X2 */
+};
+
+/* List of keyfields with description
+ *
+ * Keys ending in _IS are booleans derived from frame data
+ * Keys ending in _CLS are classified frame data
+ *
+ * VCAP_KF_8021BR_ECID_BASE: W12, sparx5: is0
+   Used by 802.1BR Bridge Port Extension in an E-Tag
+ * VCAP_KF_8021BR_ECID_EXT: W8, sparx5: is0
+   Used by 802.1BR Bridge Port Extension in an E-Tag
+ * VCAP_KF_8021BR_E_TAGGED: W1, sparx5: is0
+   Set for frames containing an E-TAG (802.1BR Ethertype 893f)
+ * VCAP_KF_8021BR_GRP: W2, sparx5: is0
+   E-Tag group bits in 802.1BR Bridge Port Extension
+ * VCAP_KF_8021BR_IGR_ECID_BASE: W12, sparx5: is0
+   Used by 802.1BR Bridge Port Extension in an E-Tag
+ * VCAP_KF_8021BR_IGR_ECID_EXT: W8, sparx5: is0
+   Used by 802.1BR Bridge Port Extension in an E-Tag
+ * VCAP_KF_8021Q_DEI0: W1, sparx5: is0
+   First DEI in multiple vlan tags (outer tag or default port tag)
+ * VCAP_KF_8021Q_DEI1: W1, sparx5: is0
+   Second DEI in multiple vlan tags (inner tag)
+ * VCAP_KF_8021Q_DEI2: W1, sparx5: is0
+   Third DEI in multiple vlan tags (not always available)
+ * VCAP_KF_8021Q_DEI_CLS: W1, sparx5: is2/es2
+   Classified DEI
+ * VCAP_KF_8021Q_PCP0: W3, sparx5: is0
+   First PCP in multiple vlan tags (outer tag or default port tag)
+ * VCAP_KF_8021Q_PCP1: W3, sparx5: is0
+   Second PCP in multiple vlan tags (inner tag)
+ * VCAP_KF_8021Q_PCP2: W3, sparx5: is0
+   Third PCP in multiple vlan tags (not always available)
+ * VCAP_KF_8021Q_PCP_CLS: W3, sparx5: is2/es2
+   Classified PCP
+ * VCAP_KF_8021Q_TPID0: W3, sparx5: is0
+   First TPIC in multiple vlan tags (outer tag or default port tag)
+ * VCAP_KF_8021Q_TPID1: W3, sparx5: is0
+   Second TPID in multiple vlan tags (inner tag)
+ * VCAP_KF_8021Q_TPID2: W3, sparx5: is0
+   Third TPID in multiple vlan tags (not always available)
+ * VCAP_KF_8021Q_VID0: W12, sparx5: is0
+   First VID in multiple vlan tags (outer tag or default port tag)
+ * VCAP_KF_8021Q_VID1: W12, sparx5: is0
+   Second VID in multiple vlan tags (inner tag)
+ * VCAP_KF_8021Q_VID2: W12, sparx5: is0
+   Third VID in multiple vlan tags (not always available)
+ * VCAP_KF_8021Q_VID_CLS: W13, sparx5: is2/es2
+   Classified VID
+ * VCAP_KF_8021Q_VLAN_TAGGED_IS: W1, sparx5: is2/es2
+   Sparx5: Set if frame was received with a VLAN tag, LAN966x: Set if frame has
+   one or more Q-tags. Independent of port VLAN awareness
+ * VCAP_KF_8021Q_VLAN_TAGS: W3, sparx5: is0
+   Number of VLAN tags in frame: 0: Untagged, 1: Single tagged, 3: Double
+   tagged, 7: Triple tagged
+ * VCAP_KF_ACL_GRP_ID: W8, sparx5: es2
+   Used in interface map table
+ * VCAP_KF_ARP_ADDR_SPACE_OK_IS: W1, sparx5: is2/es2
+   Set if hardware address is Ethernet
+ * VCAP_KF_ARP_LEN_OK_IS: W1, sparx5: is2/es2
+   Set if hardware address length = 6 (Ethernet) and IP address length = 4 (IP).
+ * VCAP_KF_ARP_OPCODE: W2, sparx5: is2/es2
+   ARP opcode
+ * VCAP_KF_ARP_OPCODE_UNKNOWN_IS: W1, sparx5: is2/es2
+   Set if not one of the codes defined in VCAP_KF_ARP_OPCODE
+ * VCAP_KF_ARP_PROTO_SPACE_OK_IS: W1, sparx5: is2/es2
+   Set if protocol address space is 0x0800
+ * VCAP_KF_ARP_SENDER_MATCH_IS: W1, sparx5: is2/es2
+   Sender Hardware Address = SMAC (ARP)
+ * VCAP_KF_ARP_TGT_MATCH_IS: W1, sparx5: is2/es2
+   Target Hardware Address = SMAC (RARP)
+ * VCAP_KF_COSID_CLS: W3, sparx5: es2
+   Class of service
+ * VCAP_KF_DST_ENTRY: W1, sparx5: is0
+   Selects whether the frame’s destination or source information is used for
+   fields L2_SMAC and L3_IP4_SIP
+ * VCAP_KF_ES0_ISDX_KEY_ENA: W1, sparx5: es2
+   The value taken from the IFH .FWD.ES0_ISDX_KEY_ENA
+ * VCAP_KF_ETYPE: W16, sparx5: is0/is2/es2
+   Ethernet type
+ * VCAP_KF_ETYPE_LEN_IS: W1, sparx5: is0/is2/es2
+   Set if frame has EtherType >= 0x600
+ * VCAP_KF_ETYPE_MPLS: W2, sparx5: is0
+   Type of MPLS Ethertype (or not)
+ * VCAP_KF_IF_EGR_PORT_MASK: W32, sparx5: es2
+   Egress port mask, one bit per port
+ * VCAP_KF_IF_EGR_PORT_MASK_RNG: W3, sparx5: es2
+   Select which 32 port group is available in IF_EGR_PORT (or virtual ports or
+   CPU queue)
+ * VCAP_KF_IF_IGR_PORT: sparx5 is0 W7, sparx5 es2 W9
+   Sparx5: Logical ingress port number retrieved from
+   ANA_CL::PORT_ID_CFG.LPORT_NUM or ERLEG, LAN966x: ingress port nunmber
+ * VCAP_KF_IF_IGR_PORT_MASK: sparx5 is0 W65, sparx5 is2 W32, sparx5 is2 W65
+   Ingress port mask, one bit per port/erleg
+ * VCAP_KF_IF_IGR_PORT_MASK_L3: W1, sparx5: is2
+   If set, IF_IGR_PORT_MASK, IF_IGR_PORT_MASK_RNG, and IF_IGR_PORT_MASK_SEL are
+   used to specify L3 interfaces
+ * VCAP_KF_IF_IGR_PORT_MASK_RNG: W4, sparx5: is2
+   Range selector for IF_IGR_PORT_MASK.  Specifies which group of 32 ports are
+   available in IF_IGR_PORT_MASK
+ * VCAP_KF_IF_IGR_PORT_MASK_SEL: W2, sparx5: is0/is2
+   Mode selector for IF_IGR_PORT_MASK, applicable when IF_IGR_PORT_MASK_L3 == 0.
+   Mapping: 0: DEFAULT 1: LOOPBACK 2: MASQUERADE 3: CPU_VD
+ * VCAP_KF_IF_IGR_PORT_SEL: W1, sparx5: es2
+   Selector for IF_IGR_PORT: physical port number or ERLEG
+ * VCAP_KF_IP4_IS: W1, sparx5: is0/is2/es2
+   Set if frame has EtherType = 0x800 and IP version = 4
+ * VCAP_KF_IP_MC_IS: W1, sparx5: is0
+   Set if frame is IPv4 frame and frame’s destination MAC address is an IPv4
+   multicast address (0x01005E0 /25). Set if frame is IPv6 frame and frame’s
+   destination MAC address is an IPv6 multicast address (0x3333/16).
+ * VCAP_KF_IP_PAYLOAD_5TUPLE: W32, sparx5: is0
+   Payload bytes after IP header
+ * VCAP_KF_IP_SNAP_IS: W1, sparx5: is0
+   Set if frame is IPv4, IPv6, or SNAP frame
+ * VCAP_KF_ISDX_CLS: W12, sparx5: is2/es2
+   Classified ISDX
+ * VCAP_KF_ISDX_GT0_IS: W1, sparx5: is2/es2
+   Set if classified ISDX > 0
+ * VCAP_KF_L2_BC_IS: W1, sparx5: is0/is2/es2
+   Set if frame’s destination MAC address is the broadcast address
+   (FF-FF-FF-FF-FF-FF).
+ * VCAP_KF_L2_DMAC: W48, sparx5: is0/is2/es2
+   Destination MAC address
+ * VCAP_KF_L2_FWD_IS: W1, sparx5: is2
+   Set if the frame is allowed to be forwarded to front ports
+ * VCAP_KF_L2_MC_IS: W1, sparx5: is0/is2/es2
+   Set if frame’s destination MAC address is a multicast address (bit 40 = 1).
+ * VCAP_KF_L2_PAYLOAD_ETYPE: W64, sparx5: is2/es2
+   Byte 0-7 of L2 payload after Type/Len field and overloading for OAM
+ * VCAP_KF_L2_SMAC: W48, sparx5: is0/is2/es2
+   Source MAC address
+ * VCAP_KF_L3_DIP_EQ_SIP_IS: W1, sparx5: is2/es2
+   Set if Src IP matches Dst IP address
+ * VCAP_KF_L3_DMAC_DIP_MATCH: W1, sparx5: is2
+   Match found in DIP security lookup in ANA_L3
+ * VCAP_KF_L3_DPL_CLS: W1, sparx5: es2
+   The frames drop precedence level
+ * VCAP_KF_L3_DSCP: W6, sparx5: is0
+   Frame’s DSCP value
+ * VCAP_KF_L3_DST_IS: W1, sparx5: is2
+   Set if lookup is done for egress router leg
+ * VCAP_KF_L3_FRAGMENT_TYPE: W2, sparx5: is0/is2/es2
+   L3 Fragmentation type (none, initial, suspicious, valid follow up)
+ * VCAP_KF_L3_FRAG_INVLD_L4_LEN: W1, sparx5: is0/is2
+   Set if frame's L4 length is less than ANA_CL:COMMON:CLM_FRAGMENT_CFG.L4_MIN_L
+   EN
+ * VCAP_KF_L3_IP4_DIP: W32, sparx5: is0/is2/es2
+   Destination IPv4 Address
+ * VCAP_KF_L3_IP4_SIP: W32, sparx5: is0/is2/es2
+   Source IPv4 Address
+ * VCAP_KF_L3_IP6_DIP: W128, sparx5: is0/is2/es2
+   Sparx5: Full IPv6 DIP, LAN966x: Either Full IPv6 DIP or a subset depending on
+   frame type
+ * VCAP_KF_L3_IP6_SIP: W128, sparx5: is0/is2/es2
+   Sparx5: Full IPv6 SIP, LAN966x: Either Full IPv6 SIP or a subset depending on
+   frame type
+ * VCAP_KF_L3_IP_PROTO: W8, sparx5: is0/is2/es2
+   IPv4 frames: IP protocol. IPv6 frames: Next header, same as for IPV4
+ * VCAP_KF_L3_OPTIONS_IS: W1, sparx5: is0/is2/es2
+   Set if IPv4 frame contains options (IP len > 5)
+ * VCAP_KF_L3_PAYLOAD: W96, sparx5: is2/es2
+   Sparx5: Payload bytes after IP header. IPv4: IPv4 options are not parsed so
+   payload is always taken 20 bytes after the start of the IPv4 header, LAN966x:
+   Bytes 0-6 after IP header
+ * VCAP_KF_L3_RT_IS: W1, sparx5: is2/es2
+   Set if frame has hit a router leg
+ * VCAP_KF_L3_SMAC_SIP_MATCH: W1, sparx5: is2
+   Match found in SIP security lookup in ANA_L3
+ * VCAP_KF_L3_TOS: W8, sparx5: is2/es2
+   Sparx5: Frame's IPv4/IPv6 DSCP and ECN fields, LAN966x: IP TOS field
+ * VCAP_KF_L3_TTL_GT0: W1, sparx5: is2/es2
+   Set if IPv4 TTL / IPv6 hop limit is greater than 0
+ * VCAP_KF_L4_ACK: W1, sparx5: is2/es2
+   Sparx5 and LAN966x: TCP flag ACK, LAN966x only: PTP over UDP: flagField bit 2
+   (unicastFlag)
+ * VCAP_KF_L4_DPORT: W16, sparx5: is2/es2
+   Sparx5: TCP/UDP destination port. Overloading for IP_7TUPLE: Non-TCP/UDP IP
+   frames: L4_DPORT = L3_IP_PROTO, LAN966x: TCP/UDP destination port
+ * VCAP_KF_L4_FIN: W1, sparx5: is2/es2
+   TCP flag FIN, LAN966x: TCP flag FIN, and for PTP over UDP: messageType bit 1
+ * VCAP_KF_L4_PAYLOAD: W64, sparx5: is2/es2
+   Payload bytes after TCP/UDP header Overloading for IP_7TUPLE: Non TCP/UDP
+   frames: Payload bytes 0–7 after IP header. IPv4 options are not parsed so
+   payload is always taken 20 bytes after the start of the IPv4 header for non
+   TCP/UDP IPv4 frames
+ * VCAP_KF_L4_PSH: W1, sparx5: is2/es2
+   Sparx5: TCP flag PSH, LAN966x: TCP: TCP flag PSH. PTP over UDP: flagField bit
+   1 (twoStepFlag)
+ * VCAP_KF_L4_RNG: sparx5 is0 W8, sparx5 is2 W16, sparx5 es2 W16
+   Range checker bitmask (one for each range checker). Input into range checkers
+   is taken from classified results (VID, DSCP) and frame (SPORT, DPORT, ETYPE,
+   outer VID, inner VID)
+ * VCAP_KF_L4_RST: W1, sparx5: is2/es2
+   Sparx5: TCP flag RST , LAN966x: TCP: TCP flag RST. PTP over UDP: messageType
+   bit 3
+ * VCAP_KF_L4_SEQUENCE_EQ0_IS: W1, sparx5: is2/es2
+   Set if TCP sequence number is 0, LAN966x: Overlayed with PTP over UDP:
+   messageType bit 0
+ * VCAP_KF_L4_SPORT: W16, sparx5: is0/is2/es2
+   TCP/UDP source port
+ * VCAP_KF_L4_SPORT_EQ_DPORT_IS: W1, sparx5: is2/es2
+   Set if UDP or TCP source port equals UDP or TCP destination port
+ * VCAP_KF_L4_SYN: W1, sparx5: is2/es2
+   Sparx5: TCP flag SYN, LAN966x: TCP: TCP flag SYN. PTP over UDP: messageType
+   bit 2
+ * VCAP_KF_L4_URG: W1, sparx5: is2/es2
+   Sparx5: TCP flag URG, LAN966x: TCP: TCP flag URG. PTP over UDP: flagField bit
+   7 (reserved)
+ * VCAP_KF_LOOKUP_FIRST_IS: W1, sparx5: is0/is2/es2
+   Selects between entries relevant for first and second lookup. Set for first
+   lookup, cleared for second lookup.
+ * VCAP_KF_LOOKUP_GEN_IDX: W12, sparx5: is0
+   Generic index - for chaining CLM instances
+ * VCAP_KF_LOOKUP_GEN_IDX_SEL: W2, sparx5: is0
+   Select the mode of the Generic Index
+ * VCAP_KF_LOOKUP_PAG: W8, sparx5: is2
+   Classified Policy Association Group: chains rules from IS1/CLM to IS2
+ * VCAP_KF_OAM_CCM_CNTS_EQ0: W1, sparx5: is2/es2
+   Dual-ended loss measurement counters in CCM frames are all zero
+ * VCAP_KF_OAM_MEL_FLAGS: W7, sparx5: is0
+   Encoding of MD level/MEG level (MEL)
+ * VCAP_KF_OAM_Y1731_IS: W1, sparx5: is0/is2/es2
+   Set if frame’s EtherType = 0x8902
+ * VCAP_KF_PROT_ACTIVE: W1, sparx5: es2
+   Protection is active
+ * VCAP_KF_TCP_IS: W1, sparx5: is0/is2/es2
+   Set if frame is IPv4 TCP frame (IP protocol = 6) or IPv6 TCP frames (Next
+   header = 6)
+ * VCAP_KF_TCP_UDP_IS: W1, sparx5: is0/is2/es2
+   Set if frame is IPv4/IPv6 TCP or UDP frame (IP protocol/next header equals 6
+   or 17)
+ * VCAP_KF_TYPE: sparx5 is0 W2, sparx5 is0 W1, sparx5 is2 W4, sparx5 is2 W2,
+   sparx5 es2 W3
+   Keyset type id - set by the API
+ */
+
+/* Keyfield names */
+enum vcap_key_field {
+	VCAP_KF_NO_VALUE,  /* initial value */
+	VCAP_KF_8021BR_ECID_BASE,
+	VCAP_KF_8021BR_ECID_EXT,
+	VCAP_KF_8021BR_E_TAGGED,
+	VCAP_KF_8021BR_GRP,
+	VCAP_KF_8021BR_IGR_ECID_BASE,
+	VCAP_KF_8021BR_IGR_ECID_EXT,
+	VCAP_KF_8021Q_DEI0,
+	VCAP_KF_8021Q_DEI1,
+	VCAP_KF_8021Q_DEI2,
+	VCAP_KF_8021Q_DEI_CLS,
+	VCAP_KF_8021Q_PCP0,
+	VCAP_KF_8021Q_PCP1,
+	VCAP_KF_8021Q_PCP2,
+	VCAP_KF_8021Q_PCP_CLS,
+	VCAP_KF_8021Q_TPID0,
+	VCAP_KF_8021Q_TPID1,
+	VCAP_KF_8021Q_TPID2,
+	VCAP_KF_8021Q_VID0,
+	VCAP_KF_8021Q_VID1,
+	VCAP_KF_8021Q_VID2,
+	VCAP_KF_8021Q_VID_CLS,
+	VCAP_KF_8021Q_VLAN_TAGGED_IS,
+	VCAP_KF_8021Q_VLAN_TAGS,
+	VCAP_KF_ACL_GRP_ID,
+	VCAP_KF_ARP_ADDR_SPACE_OK_IS,
+	VCAP_KF_ARP_LEN_OK_IS,
+	VCAP_KF_ARP_OPCODE,
+	VCAP_KF_ARP_OPCODE_UNKNOWN_IS,
+	VCAP_KF_ARP_PROTO_SPACE_OK_IS,
+	VCAP_KF_ARP_SENDER_MATCH_IS,
+	VCAP_KF_ARP_TGT_MATCH_IS,
+	VCAP_KF_COSID_CLS,
+	VCAP_KF_DST_ENTRY,
+	VCAP_KF_ES0_ISDX_KEY_ENA,
+	VCAP_KF_ETYPE,
+	VCAP_KF_ETYPE_LEN_IS,
+	VCAP_KF_ETYPE_MPLS,
+	VCAP_KF_IF_EGR_PORT_MASK,
+	VCAP_KF_IF_EGR_PORT_MASK_RNG,
+	VCAP_KF_IF_IGR_PORT,
+	VCAP_KF_IF_IGR_PORT_MASK,
+	VCAP_KF_IF_IGR_PORT_MASK_L3,
+	VCAP_KF_IF_IGR_PORT_MASK_RNG,
+	VCAP_KF_IF_IGR_PORT_MASK_SEL,
+	VCAP_KF_IF_IGR_PORT_SEL,
+	VCAP_KF_IP4_IS,
+	VCAP_KF_IP_MC_IS,
+	VCAP_KF_IP_PAYLOAD_5TUPLE,
+	VCAP_KF_IP_SNAP_IS,
+	VCAP_KF_ISDX_CLS,
+	VCAP_KF_ISDX_GT0_IS,
+	VCAP_KF_L2_BC_IS,
+	VCAP_KF_L2_DMAC,
+	VCAP_KF_L2_FWD_IS,
+	VCAP_KF_L2_MC_IS,
+	VCAP_KF_L2_PAYLOAD_ETYPE,
+	VCAP_KF_L2_SMAC,
+	VCAP_KF_L3_DIP_EQ_SIP_IS,
+	VCAP_KF_L3_DMAC_DIP_MATCH,
+	VCAP_KF_L3_DPL_CLS,
+	VCAP_KF_L3_DSCP,
+	VCAP_KF_L3_DST_IS,
+	VCAP_KF_L3_FRAGMENT_TYPE,
+	VCAP_KF_L3_FRAG_INVLD_L4_LEN,
+	VCAP_KF_L3_IP4_DIP,
+	VCAP_KF_L3_IP4_SIP,
+	VCAP_KF_L3_IP6_DIP,
+	VCAP_KF_L3_IP6_SIP,
+	VCAP_KF_L3_IP_PROTO,
+	VCAP_KF_L3_OPTIONS_IS,
+	VCAP_KF_L3_PAYLOAD,
+	VCAP_KF_L3_RT_IS,
+	VCAP_KF_L3_SMAC_SIP_MATCH,
+	VCAP_KF_L3_TOS,
+	VCAP_KF_L3_TTL_GT0,
+	VCAP_KF_L4_ACK,
+	VCAP_KF_L4_DPORT,
+	VCAP_KF_L4_FIN,
+	VCAP_KF_L4_PAYLOAD,
+	VCAP_KF_L4_PSH,
+	VCAP_KF_L4_RNG,
+	VCAP_KF_L4_RST,
+	VCAP_KF_L4_SEQUENCE_EQ0_IS,
+	VCAP_KF_L4_SPORT,
+	VCAP_KF_L4_SPORT_EQ_DPORT_IS,
+	VCAP_KF_L4_SYN,
+	VCAP_KF_L4_URG,
+	VCAP_KF_LOOKUP_FIRST_IS,
+	VCAP_KF_LOOKUP_GEN_IDX,
+	VCAP_KF_LOOKUP_GEN_IDX_SEL,
+	VCAP_KF_LOOKUP_PAG,
+	VCAP_KF_MIRROR_ENA,
+	VCAP_KF_OAM_CCM_CNTS_EQ0,
+	VCAP_KF_OAM_MEL_FLAGS,
+	VCAP_KF_OAM_Y1731_IS,
+	VCAP_KF_PROT_ACTIVE,
+	VCAP_KF_TCP_IS,
+	VCAP_KF_TCP_UDP_IS,
+	VCAP_KF_TYPE,
+};
+
+/* Actionset names with origin information */
+enum vcap_actionfield_set {
+	VCAP_AFS_NO_VALUE,          /* initial value */
+	VCAP_AFS_BASE_TYPE,         /* sparx5 is2 X3, sparx5 es2 X3 */
+	VCAP_AFS_CLASSIFICATION,    /* sparx5 is0 X2 */
+	VCAP_AFS_CLASS_REDUCED,     /* sparx5 is0 X1 */
+	VCAP_AFS_FULL,              /* sparx5 is0 X3 */
+	VCAP_AFS_MLBS,              /* sparx5 is0 X2 */
+	VCAP_AFS_MLBS_REDUCED,      /* sparx5 is0 X1 */
+};
+
+/* List of actionfields with description
+ *
+ * VCAP_AF_CLS_VID_SEL: W3, sparx5: is0
+   Controls the classified VID: 0: VID_NONE: No action. 1: VID_ADD: New VID =
+   old VID + VID_VAL. 2: VID_REPLACE: New VID = VID_VAL. 3: VID_FIRST_TAG: New
+   VID = VID from frame's first tag (outer tag) if available, otherwise VID_VAL.
+   4: VID_SECOND_TAG: New VID = VID from frame's second tag (middle tag) if
+   available, otherwise VID_VAL. 5: VID_THIRD_TAG: New VID = VID from frame's
+   third tag (inner tag) if available, otherwise VID_VAL.
+ * VCAP_AF_CNT_ID: sparx5 is2 W12, sparx5 es2 W11
+   Counter ID, used per lookup to index the 4K frame counters (ANA_ACL:CNT_TBL).
+   Multiple VCAP IS2 entries can use the same counter.
+ * VCAP_AF_COPY_PORT_NUM: W7, sparx5: es2
+   QSYS port number when FWD_MODE is redirect or copy
+ * VCAP_AF_COPY_QUEUE_NUM: W16, sparx5: es2
+   QSYS queue number when FWD_MODE is redirect or copy
+ * VCAP_AF_CPU_COPY_ENA: W1, sparx5: is2/es2
+   Setting this bit to 1 causes all frames that hit this action to be copied to
+   the CPU extraction queue specified in CPU_QUEUE_NUM.
+ * VCAP_AF_CPU_QUEUE_NUM: W3, sparx5: is2/es2
+   CPU queue number. Used when CPU_COPY_ENA is set.
+ * VCAP_AF_DEI_ENA: W1, sparx5: is0
+   If set, use DEI_VAL as classified DEI value. Otherwise, DEI from basic
+   classification is used
+ * VCAP_AF_DEI_VAL: W1, sparx5: is0
+   See DEI_ENA
+ * VCAP_AF_DP_ENA: W1, sparx5: is0
+   If set, use DP_VAL as classified drop precedence level. Otherwise, drop
+   precedence level from basic classification is used.
+ * VCAP_AF_DP_VAL: W2, sparx5: is0
+   See DP_ENA.
+ * VCAP_AF_DSCP_ENA: W1, sparx5: is0
+   If set, use DSCP_VAL as classified DSCP value. Otherwise, DSCP value from
+   basic classification is used.
+ * VCAP_AF_DSCP_VAL: W6, sparx5: is0
+   See DSCP_ENA.
+ * VCAP_AF_ES2_REW_CMD: W3, sparx5: es2
+   Command forwarded to REW: 0: No action. 1: SWAP MAC addresses. 2: Do L2CP
+   DMAC translation when entering or leaving a tunnel.
+ * VCAP_AF_FWD_MODE: W2, sparx5: es2
+   Forward selector: 0: Forward. 1: Discard. 2: Redirect. 3: Copy.
+ * VCAP_AF_HIT_ME_ONCE: W1, sparx5: is2/es2
+   Setting this bit to 1 causes the first frame that hits this action where the
+   HIT_CNT counter is zero to be copied to the CPU extraction queue specified in
+   CPU_QUEUE_NUM. The HIT_CNT counter is then incremented and any frames that
+   hit this action later are not copied to the CPU. To re-enable the HIT_ME_ONCE
+   functionality, the HIT_CNT counter must be cleared.
+ * VCAP_AF_IGNORE_PIPELINE_CTRL: W1, sparx5: is2/es2
+   Ignore ingress pipeline control. This enforces the use of the VCAP IS2 action
+   even when the pipeline control has terminated the frame before VCAP IS2.
+ * VCAP_AF_INTR_ENA: W1, sparx5: is2/es2
+   If set, an interrupt is triggered when this rule is hit
+ * VCAP_AF_ISDX_ADD_REPLACE_SEL: W1, sparx5: is0
+   Controls the classified ISDX. 0: New ISDX = old ISDX + ISDX_VAL. 1: New ISDX
+   = ISDX_VAL.
+ * VCAP_AF_ISDX_VAL: W12, sparx5: is0
+   See isdx_add_replace_sel
+ * VCAP_AF_LRN_DIS: W1, sparx5: is2
+   Setting this bit to 1 disables learning of frames hitting this action.
+ * VCAP_AF_MAP_IDX: W9, sparx5: is0
+   Index for QoS mapping table lookup
+ * VCAP_AF_MAP_KEY: W3, sparx5: is0
+   Key type for QoS mapping table lookup. 0: DEI0, PCP0 (outer tag). 1: DEI1,
+   PCP1 (middle tag). 2: DEI2, PCP2 (inner tag). 3: MPLS TC. 4: PCP0 (outer
+   tag). 5: E-DEI, E-PCP (E-TAG). 6: DSCP if available, otherwise none. 7: DSCP
+   if available, otherwise DEI0, PCP0 (outer tag) if available using MAP_IDX+8,
+   otherwise none
+ * VCAP_AF_MAP_LOOKUP_SEL: W2, sparx5: is0
+   Selects which of the two QoS Mapping Table lookups that MAP_KEY and MAP_IDX
+   are applied to. 0: No changes to the QoS Mapping Table lookup. 1: Update key
+   type and index for QoS Mapping Table lookup #0. 2: Update key type and index
+   for QoS Mapping Table lookup #1. 3: Reserved.
+ * VCAP_AF_MASK_MODE: W3, sparx5: is0/is2
+   Controls the PORT_MASK use. Sparx5: 0: OR_DSTMASK, 1: AND_VLANMASK, 2:
+   REPLACE_PGID, 3: REPLACE_ALL, 4: REDIR_PGID, 5: OR_PGID_MASK, 6: VSTAX, 7:
+   Not applicable. LAN966X: 0: No action, 1: Permit/deny (AND), 2: Policy
+   forwarding (DMAC lookup), 3: Redirect. The CPU port is untouched by
+   MASK_MODE.
+ * VCAP_AF_MATCH_ID: W16, sparx5: is0/is2
+   Logical ID for the entry. The MATCH_ID is extracted together with the frame
+   if the frame is forwarded to the CPU (CPU_COPY_ENA). The result is placed in
+   IFH.CL_RSLT.
+ * VCAP_AF_MATCH_ID_MASK: W16, sparx5: is0/is2
+   Mask used by MATCH_ID.
+ * VCAP_AF_MIRROR_PROBE: W2, sparx5: is2
+   Mirroring performed according to configuration of a mirror probe. 0: No
+   mirroring. 1: Mirror probe 0. 2: Mirror probe 1. 3: Mirror probe 2
+ * VCAP_AF_MIRROR_PROBE_ID: W2, sparx5: es2
+   Signals a mirror probe to be placed in the IFH. Only possible when FWD_MODE
+   is copy. 0: No mirroring. 1–3: Use mirror probe 0-2.
+ * VCAP_AF_NXT_IDX: W12, sparx5: is0
+   Index used as part of key (field G_IDX) in the next lookup.
+ * VCAP_AF_NXT_IDX_CTRL: W3, sparx5: is0
+   Controls the generation of the G_IDX used in the VCAP CLM next lookup
+ * VCAP_AF_PAG_OVERRIDE_MASK: W8, sparx5: is0
+   Bits set in this mask will override PAG_VAL from port profile.  New PAG =
+   (PAG (input) AND ~PAG_OVERRIDE_MASK) OR (PAG_VAL AND PAG_OVERRIDE_MASK)
+ * VCAP_AF_PAG_VAL: W8, sparx5: is0
+   See PAG_OVERRIDE_MASK.
+ * VCAP_AF_PCP_ENA: W1, sparx5: is0
+   If set, use PCP_VAL as classified PCP value. Otherwise, PCP from basic
+   classification is used.
+ * VCAP_AF_PCP_VAL: W3, sparx5: is0
+   See PCP_ENA.
+ * VCAP_AF_PIPELINE_FORCE_ENA: sparx5 is0 W2, sparx5 is2 W1
+   If set, use PIPELINE_PT unconditionally and set PIPELINE_ACT = NONE if
+   PIPELINE_PT == NONE. Overrules previous settings of pipeline point.
+ * VCAP_AF_PIPELINE_PT: W5, sparx5: is0/is2
+   Pipeline point used if PIPELINE_FORCE_ENA is set
+ * VCAP_AF_POLICE_ENA: W1, sparx5: is2/es2
+   Setting this bit to 1 causes frames that hit this action to be policed by the
+   ACL policer specified in POLICE_IDX. Only applies to the first lookup.
+ * VCAP_AF_POLICE_IDX: W6, sparx5: is2/es2
+   Selects VCAP policer used when policing frames (POLICE_ENA)
+ * VCAP_AF_POLICE_REMARK: W1, sparx5: es2
+   If set, frames exceeding policer rates are marked as yellow but not
+   discarded.
+ * VCAP_AF_PORT_MASK: sparx5 is0 W65, sparx5 is2 W68
+   Port mask applied to the forwarding decision based on MASK_MODE.
+ * VCAP_AF_QOS_ENA: W1, sparx5: is0
+   If set, use QOS_VAL as classified QoS class. Otherwise, QoS class from basic
+   classification is used.
+ * VCAP_AF_QOS_VAL: W3, sparx5: is0
+   See QOS_ENA.
+ * VCAP_AF_RT_DIS: W1, sparx5: is2
+   If set, routing is disallowed. Only applies when IS_INNER_ACL is 0. See also
+   IGR_ACL_ENA, EGR_ACL_ENA, and RLEG_STAT_IDX.
+ * VCAP_AF_TYPE: W1, sparx5: is0
+   Actionset type id - Set by the API
+ * VCAP_AF_VID_VAL: W13, sparx5: is0
+   New VID Value
+ */
+
+/* Actionfield names */
+enum vcap_action_field {
+	VCAP_AF_NO_VALUE,  /* initial value */
+	VCAP_AF_ACL_MAC,
+	VCAP_AF_ACL_RT_MODE,
+	VCAP_AF_CLS_VID_SEL,
+	VCAP_AF_CNT_ID,
+	VCAP_AF_COPY_PORT_NUM,
+	VCAP_AF_COPY_QUEUE_NUM,
+	VCAP_AF_COSID_ENA,
+	VCAP_AF_COSID_VAL,
+	VCAP_AF_CPU_COPY_ENA,
+	VCAP_AF_CPU_DIS,
+	VCAP_AF_CPU_ENA,
+	VCAP_AF_CPU_Q,
+	VCAP_AF_CPU_QUEUE_NUM,
+	VCAP_AF_CUSTOM_ACE_ENA,
+	VCAP_AF_CUSTOM_ACE_OFFSET,
+	VCAP_AF_DEI_ENA,
+	VCAP_AF_DEI_VAL,
+	VCAP_AF_DLB_OFFSET,
+	VCAP_AF_DMAC_OFFSET_ENA,
+	VCAP_AF_DP_ENA,
+	VCAP_AF_DP_VAL,
+	VCAP_AF_DSCP_ENA,
+	VCAP_AF_DSCP_VAL,
+	VCAP_AF_EGR_ACL_ENA,
+	VCAP_AF_ES2_REW_CMD,
+	VCAP_AF_FWD_DIS,
+	VCAP_AF_FWD_MODE,
+	VCAP_AF_FWD_TYPE,
+	VCAP_AF_GVID_ADD_REPLACE_SEL,
+	VCAP_AF_HIT_ME_ONCE,
+	VCAP_AF_IGNORE_PIPELINE_CTRL,
+	VCAP_AF_IGR_ACL_ENA,
+	VCAP_AF_INJ_MASQ_ENA,
+	VCAP_AF_INJ_MASQ_LPORT,
+	VCAP_AF_INJ_MASQ_PORT,
+	VCAP_AF_INTR_ENA,
+	VCAP_AF_ISDX_ADD_REPLACE_SEL,
+	VCAP_AF_ISDX_VAL,
+	VCAP_AF_IS_INNER_ACL,
+	VCAP_AF_L3_MAC_UPDATE_DIS,
+	VCAP_AF_LOG_MSG_INTERVAL,
+	VCAP_AF_LPM_AFFIX_ENA,
+	VCAP_AF_LPM_AFFIX_VAL,
+	VCAP_AF_LPORT_ENA,
+	VCAP_AF_LRN_DIS,
+	VCAP_AF_MAP_IDX,
+	VCAP_AF_MAP_KEY,
+	VCAP_AF_MAP_LOOKUP_SEL,
+	VCAP_AF_MASK_MODE,
+	VCAP_AF_MATCH_ID,
+	VCAP_AF_MATCH_ID_MASK,
+	VCAP_AF_MIP_SEL,
+	VCAP_AF_MIRROR_PROBE,
+	VCAP_AF_MIRROR_PROBE_ID,
+	VCAP_AF_MPLS_IP_CTRL_ENA,
+	VCAP_AF_MPLS_MEP_ENA,
+	VCAP_AF_MPLS_MIP_ENA,
+	VCAP_AF_MPLS_OAM_FLAVOR,
+	VCAP_AF_MPLS_OAM_TYPE,
+	VCAP_AF_NUM_VLD_LABELS,
+	VCAP_AF_NXT_IDX,
+	VCAP_AF_NXT_IDX_CTRL,
+	VCAP_AF_NXT_KEY_TYPE,
+	VCAP_AF_NXT_NORMALIZE,
+	VCAP_AF_NXT_NORM_W16_OFFSET,
+	VCAP_AF_NXT_NORM_W32_OFFSET,
+	VCAP_AF_NXT_OFFSET_FROM_TYPE,
+	VCAP_AF_NXT_TYPE_AFTER_OFFSET,
+	VCAP_AF_OAM_IP_BFD_ENA,
+	VCAP_AF_OAM_TWAMP_ENA,
+	VCAP_AF_OAM_Y1731_SEL,
+	VCAP_AF_PAG_OVERRIDE_MASK,
+	VCAP_AF_PAG_VAL,
+	VCAP_AF_PCP_ENA,
+	VCAP_AF_PCP_VAL,
+	VCAP_AF_PIPELINE_ACT_SEL,
+	VCAP_AF_PIPELINE_FORCE_ENA,
+	VCAP_AF_PIPELINE_PT,
+	VCAP_AF_PIPELINE_PT_REDUCED,
+	VCAP_AF_POLICE_ENA,
+	VCAP_AF_POLICE_IDX,
+	VCAP_AF_POLICE_REMARK,
+	VCAP_AF_PORT_MASK,
+	VCAP_AF_PTP_MASTER_SEL,
+	VCAP_AF_QOS_ENA,
+	VCAP_AF_QOS_VAL,
+	VCAP_AF_REW_CMD,
+	VCAP_AF_RLEG_DMAC_CHK_DIS,
+	VCAP_AF_RLEG_STAT_IDX,
+	VCAP_AF_RSDX_ENA,
+	VCAP_AF_RSDX_VAL,
+	VCAP_AF_RSVD_LBL_VAL,
+	VCAP_AF_RT_DIS,
+	VCAP_AF_RT_SEL,
+	VCAP_AF_S2_KEY_SEL_ENA,
+	VCAP_AF_S2_KEY_SEL_IDX,
+	VCAP_AF_SAM_SEQ_ENA,
+	VCAP_AF_SIP_IDX,
+	VCAP_AF_SWAP_MAC_ENA,
+	VCAP_AF_TCP_UDP_DPORT,
+	VCAP_AF_TCP_UDP_ENA,
+	VCAP_AF_TCP_UDP_SPORT,
+	VCAP_AF_TC_ENA,
+	VCAP_AF_TC_LABEL,
+	VCAP_AF_TPID_SEL,
+	VCAP_AF_TTL_DECR_DIS,
+	VCAP_AF_TTL_ENA,
+	VCAP_AF_TTL_LABEL,
+	VCAP_AF_TTL_UPDATE_ENA,
+	VCAP_AF_TYPE,
+	VCAP_AF_VID_VAL,
+	VCAP_AF_VLAN_POP_CNT,
+	VCAP_AF_VLAN_POP_CNT_ENA,
+	VCAP_AF_VLAN_PUSH_CNT,
+	VCAP_AF_VLAN_PUSH_CNT_ENA,
+	VCAP_AF_VLAN_WAS_TAGGED,
+};
+
+#endif /* __VCAP_AG_API__ */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
index 06290fd27cc1..5c3f689d7da7 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
@@ -1136,3 +1136,7 @@ int vcap_rule_add_action_u32(struct vcap_rule *rule,
 	return vcap_rule_add_action(rule, action, VCAP_FIELD_U32, &data);
 }
 EXPORT_SYMBOL_GPL(vcap_rule_add_action_u32);
+
+#ifdef CONFIG_VCAP_KUNIT_TEST
+#include "vcap_api_kunit.c"
+#endif
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.h b/drivers/net/ethernet/microchip/vcap/vcap_api.h
index 4444bf67ebec..eb2eae75c7e8 100644
--- a/drivers/net/ethernet/microchip/vcap/vcap_api.h
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api.h
@@ -11,6 +11,9 @@
 #include <linux/netdevice.h>
 
 /* Use the generated API model */
+#ifdef CONFIG_VCAP_KUNIT_TEST
+#include "vcap_ag_api_kunit.h"
+#endif
 #include "vcap_ag_api.h"
 
 #define VCAP_CID_LOOKUP_SIZE          100000 /* Chains in a lookup */
diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
new file mode 100644
index 000000000000..b01a6e5039b0
--- /dev/null
+++ b/drivers/net/ethernet/microchip/vcap/vcap_api_kunit.c
@@ -0,0 +1,933 @@
+// SPDX-License-Identifier: BSD-3-Clause
+/* Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries.
+ * Microchip VCAP API kunit test suite
+ */
+
+#include <kunit/test.h>
+#include "vcap_api.h"
+#include "vcap_api_client.h"
+#include "vcap_model_kunit.h"
+
+/* First we have the test infrastructure that emulates the platform
+ * implementation
+ */
+#define TEST_BUF_CNT 100
+#define TEST_BUF_SZ  350
+#define STREAMWSIZE 64
+
+static u32 test_updateaddr[STREAMWSIZE] = {};
+static int test_updateaddridx;
+static int test_cache_erase_count;
+static u32 test_init_start;
+static u32 test_init_count;
+static u32 test_hw_counter_id;
+static struct vcap_cache_data test_hw_cache;
+
+/* Callback used by the VCAP API */
+static enum vcap_keyfield_set test_val_keyset(struct net_device *ndev,
+					      struct vcap_admin *admin,
+					      struct vcap_rule *rule,
+					      struct vcap_keyset_list *kslist,
+					      u16 l3_proto)
+{
+	int idx;
+
+	if (kslist->cnt > 0) {
+		switch (admin->vtype) {
+		case VCAP_TYPE_IS0:
+			for (idx = 0; idx < kslist->cnt; idx++) {
+				if (kslist->keysets[idx] == VCAP_KFS_ETAG)
+					return kslist->keysets[idx];
+				if (kslist->keysets[idx] == VCAP_KFS_PURE_5TUPLE_IP4)
+					return kslist->keysets[idx];
+				if (kslist->keysets[idx] == VCAP_KFS_NORMAL_5TUPLE_IP4)
+					return kslist->keysets[idx];
+				if (kslist->keysets[idx] == VCAP_KFS_NORMAL_7TUPLE)
+					return kslist->keysets[idx];
+			}
+			break;
+		case VCAP_TYPE_IS2:
+			for (idx = 0; idx < kslist->cnt; idx++) {
+				if (kslist->keysets[idx] == VCAP_KFS_MAC_ETYPE)
+					return kslist->keysets[idx];
+				if (kslist->keysets[idx] == VCAP_KFS_ARP)
+					return kslist->keysets[idx];
+				if (kslist->keysets[idx] == VCAP_KFS_IP_7TUPLE)
+					return kslist->keysets[idx];
+			}
+			break;
+		default:
+			pr_info("%s:%d: no validation for VCAP %d\n",
+				__func__, __LINE__, admin->vtype);
+			break;
+		}
+	}
+	return -EINVAL;
+}
+
+/* Callback used by the VCAP API */
+static void test_add_def_fields(struct net_device *ndev,
+				struct vcap_admin *admin,
+				struct vcap_rule *rule)
+{
+	if (admin->vinst == 0 || admin->vinst == 2)
+		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_1);
+	else
+		vcap_rule_add_key_bit(rule, VCAP_KF_LOOKUP_FIRST_IS, VCAP_BIT_0);
+}
+
+/* Callback used by the VCAP API */
+static void test_cache_erase(struct vcap_admin *admin)
+{
+	if (test_cache_erase_count) {
+		memset(admin->cache.keystream, 0, test_cache_erase_count);
+		memset(admin->cache.maskstream, 0, test_cache_erase_count);
+		memset(admin->cache.actionstream, 0, test_cache_erase_count);
+		test_cache_erase_count = 0;
+	}
+}
+
+/* Callback used by the VCAP API */
+static void test_cache_init(struct net_device *ndev, struct vcap_admin *admin,
+			    u32 start, u32 count)
+{
+	test_init_start = start;
+	test_init_count = count;
+}
+
+/* Callback used by the VCAP API */
+static void test_cache_read(struct net_device *ndev, struct vcap_admin *admin,
+			    enum vcap_selection sel, u32 start, u32 count)
+{
+	u32 *keystr, *mskstr, *actstr;
+	int idx;
+
+	pr_debug("%s:%d: %d %d\n", __func__, __LINE__, start, count);
+	switch (sel) {
+	case VCAP_SEL_ENTRY:
+		keystr = &admin->cache.keystream[start];
+		mskstr = &admin->cache.maskstream[start];
+		for (idx = 0; idx < count; ++idx) {
+			pr_debug("%s:%d: keydata[%02d]: 0x%08x\n", __func__,
+				 __LINE__, start + idx, keystr[idx]);
+		}
+		for (idx = 0; idx < count; ++idx) {
+			/* Invert the mask before decoding starts */
+			mskstr[idx] = ~mskstr[idx];
+			pr_debug("%s:%d: mskdata[%02d]: 0x%08x\n", __func__,
+				 __LINE__, start + idx, mskstr[idx]);
+		}
+		break;
+	case VCAP_SEL_ACTION:
+		actstr = &admin->cache.actionstream[start];
+		for (idx = 0; idx < count; ++idx) {
+			pr_debug("%s:%d: actdata[%02d]: 0x%08x\n", __func__,
+				 __LINE__, start + idx, actstr[idx]);
+		}
+		break;
+	case VCAP_SEL_COUNTER:
+		pr_debug("%s:%d\n", __func__, __LINE__);
+		test_hw_counter_id = start;
+		admin->cache.counter = test_hw_cache.counter;
+		admin->cache.sticky = test_hw_cache.sticky;
+		break;
+	case VCAP_SEL_ALL:
+		pr_debug("%s:%d\n", __func__, __LINE__);
+		break;
+	}
+}
+
+/* Callback used by the VCAP API */
+static void test_cache_write(struct net_device *ndev, struct vcap_admin *admin,
+			     enum vcap_selection sel, u32 start, u32 count)
+{
+	u32 *keystr, *mskstr, *actstr;
+	int idx;
+
+	switch (sel) {
+	case VCAP_SEL_ENTRY:
+		keystr = &admin->cache.keystream[start];
+		mskstr = &admin->cache.maskstream[start];
+		for (idx = 0; idx < count; ++idx) {
+			pr_debug("%s:%d: keydata[%02d]: 0x%08x\n", __func__,
+				 __LINE__, start + idx, keystr[idx]);
+		}
+		for (idx = 0; idx < count; ++idx) {
+			/* Invert the mask before encoding starts */
+			mskstr[idx] = ~mskstr[idx];
+			pr_debug("%s:%d: mskdata[%02d]: 0x%08x\n", __func__,
+				 __LINE__, start + idx, mskstr[idx]);
+		}
+		break;
+	case VCAP_SEL_ACTION:
+		actstr = &admin->cache.actionstream[start];
+		for (idx = 0; idx < count; ++idx) {
+			pr_debug("%s:%d: actdata[%02d]: 0x%08x\n", __func__,
+				 __LINE__, start + idx, actstr[idx]);
+		}
+		break;
+	case VCAP_SEL_COUNTER:
+		pr_debug("%s:%d\n", __func__, __LINE__);
+		test_hw_counter_id = start;
+		test_hw_cache.counter = admin->cache.counter;
+		test_hw_cache.sticky = admin->cache.sticky;
+		break;
+	case VCAP_SEL_ALL:
+		pr_err("%s:%d: cannot write all streams at once\n",
+		       __func__, __LINE__);
+		break;
+	}
+}
+
+/* Callback used by the VCAP API */
+static void test_cache_update(struct net_device *ndev, struct vcap_admin *admin,
+			      enum vcap_command cmd,
+			      enum vcap_selection sel, u32 addr)
+{
+	if (test_updateaddridx < ARRAY_SIZE(test_updateaddr))
+		test_updateaddr[test_updateaddridx] = addr;
+	else
+		pr_err("%s:%d: overflow: %d\n", __func__, __LINE__, test_updateaddridx);
+	test_updateaddridx++;
+}
+
+static void test_cache_move(struct net_device *ndev, struct vcap_admin *admin,
+			    u32 addr, int offset, int count)
+{
+}
+
+/* Provide port information via a callback interface */
+static int vcap_test_port_info(struct net_device *ndev, enum vcap_type vtype,
+			       int (*pf)(void *out, int arg, const char *fmt, ...),
+			       void *out, int arg)
+{
+	return 0;
+}
+
+struct vcap_operations test_callbacks = {
+	.validate_keyset = test_val_keyset,
+	.add_default_fields = test_add_def_fields,
+	.cache_erase = test_cache_erase,
+	.cache_write = test_cache_write,
+	.cache_read = test_cache_read,
+	.init = test_cache_init,
+	.update = test_cache_update,
+	.move = test_cache_move,
+	.port_info = vcap_test_port_info,
+};
+
+struct vcap_control test_vctrl = {
+	.vcaps = kunit_test_vcaps,
+	.stats = &kunit_test_vcap_stats,
+	.ops = &test_callbacks,
+};
+
+static void vcap_test_api_init(struct vcap_admin *admin)
+{
+	/* Initialize the shared objects */
+	INIT_LIST_HEAD(&test_vctrl.list);
+	INIT_LIST_HEAD(&admin->list);
+	INIT_LIST_HEAD(&admin->rules);
+	list_add_tail(&admin->list, &test_vctrl.list);
+	memset(test_updateaddr, 0, sizeof(test_updateaddr));
+	test_updateaddridx = 0;
+}
+
+/* Define the test cases. */
+
+static void vcap_api_set_bit_1_test(struct kunit *test)
+{
+	struct vcap_stream_iter iter = {
+		.offset = 35,
+		.sw_width = 52,
+		.reg_idx = 1,
+		.reg_bitpos = 20,
+		.tg = 0
+	};
+	u32 stream[2] = {0};
+
+	vcap_set_bit(stream, &iter, 1);
+
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[0]);
+	KUNIT_EXPECT_EQ(test, (u32)BIT(20), stream[1]);
+}
+
+static void vcap_api_set_bit_0_test(struct kunit *test)
+{
+	struct vcap_stream_iter iter = {
+		.offset = 35,
+		.sw_width = 52,
+		.reg_idx = 2,
+		.reg_bitpos = 11,
+		.tg = 0
+	};
+	u32 stream[3] = {~0, ~0, ~0};
+
+	vcap_set_bit(stream, &iter, 0);
+
+	KUNIT_EXPECT_EQ(test, (u32)~0, stream[0]);
+	KUNIT_EXPECT_EQ(test, (u32)~0, stream[1]);
+	KUNIT_EXPECT_EQ(test, (u32)~BIT(11), stream[2]);
+}
+
+static void vcap_api_iterator_init_test(struct kunit *test)
+{
+	struct vcap_stream_iter iter;
+	struct vcap_typegroup typegroups[] = {
+		{ .offset = 0, .width = 2, .value = 2, },
+		{ .offset = 156, .width = 1, .value = 0, },
+		{ .offset = 0, .width = 0, .value = 0, },
+	};
+	struct vcap_typegroup typegroups2[] = {
+		{ .offset = 0, .width = 3, .value = 4, },
+		{ .offset = 49, .width = 2, .value = 0, },
+		{ .offset = 98, .width = 2, .value = 0, },
+	};
+
+	vcap_iter_init(&iter, 52, typegroups, 86);
+
+	KUNIT_EXPECT_EQ(test, 52, iter.sw_width);
+	KUNIT_EXPECT_EQ(test, 86 + 2, iter.offset);
+	KUNIT_EXPECT_EQ(test, 3, iter.reg_idx);
+	KUNIT_EXPECT_EQ(test, 4, iter.reg_bitpos);
+
+	vcap_iter_init(&iter, 49, typegroups2, 134);
+
+	KUNIT_EXPECT_EQ(test, 49, iter.sw_width);
+	KUNIT_EXPECT_EQ(test, 134 + 7, iter.offset);
+	KUNIT_EXPECT_EQ(test, 5, iter.reg_idx);
+	KUNIT_EXPECT_EQ(test, 11, iter.reg_bitpos);
+}
+
+static void vcap_api_iterator_next_test(struct kunit *test)
+{
+	struct vcap_stream_iter iter;
+	struct vcap_typegroup typegroups[] = {
+		{ .offset = 0, .width = 4, .value = 8, },
+		{ .offset = 49, .width = 1, .value = 0, },
+		{ .offset = 98, .width = 2, .value = 0, },
+		{ .offset = 147, .width = 3, .value = 0, },
+		{ .offset = 196, .width = 2, .value = 0, },
+		{ .offset = 245, .width = 1, .value = 0, },
+	};
+	int idx;
+
+	vcap_iter_init(&iter, 49, typegroups, 86);
+
+	KUNIT_EXPECT_EQ(test, 49, iter.sw_width);
+	KUNIT_EXPECT_EQ(test, 86 + 5, iter.offset);
+	KUNIT_EXPECT_EQ(test, 3, iter.reg_idx);
+	KUNIT_EXPECT_EQ(test, 10, iter.reg_bitpos);
+
+	vcap_iter_next(&iter);
+
+	KUNIT_EXPECT_EQ(test, 91 + 1, iter.offset);
+	KUNIT_EXPECT_EQ(test, 3, iter.reg_idx);
+	KUNIT_EXPECT_EQ(test, 11, iter.reg_bitpos);
+
+	for (idx = 0; idx < 6; idx++)
+		vcap_iter_next(&iter);
+
+	KUNIT_EXPECT_EQ(test, 92 + 6 + 2, iter.offset);
+	KUNIT_EXPECT_EQ(test, 4, iter.reg_idx);
+	KUNIT_EXPECT_EQ(test, 2, iter.reg_bitpos);
+}
+
+static void vcap_api_encode_typegroups_test(struct kunit *test)
+{
+	u32 stream[12] = {0};
+	struct vcap_typegroup typegroups[] = {
+		{ .offset = 0, .width = 4, .value = 8, },
+		{ .offset = 49, .width = 1, .value = 1, },
+		{ .offset = 98, .width = 2, .value = 3, },
+		{ .offset = 147, .width = 3, .value = 5, },
+		{ .offset = 196, .width = 2, .value = 2, },
+		{ .offset = 245, .width = 5, .value = 27, },
+		{ .offset = 0, .width = 0, .value = 0, },
+	};
+
+	vcap_encode_typegroups(stream, 49, typegroups, false);
+
+	KUNIT_EXPECT_EQ(test, (u32)0x8, stream[0]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[1]);
+	KUNIT_EXPECT_EQ(test, (u32)0x1, stream[2]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[3]);
+	KUNIT_EXPECT_EQ(test, (u32)0x3, stream[4]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[5]);
+	KUNIT_EXPECT_EQ(test, (u32)0x5, stream[6]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[7]);
+	KUNIT_EXPECT_EQ(test, (u32)0x2, stream[8]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[9]);
+	KUNIT_EXPECT_EQ(test, (u32)27, stream[10]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[11]);
+}
+
+static void vcap_api_encode_bit_test(struct kunit *test)
+{
+	struct vcap_stream_iter iter;
+	u32 stream[4] = {0};
+	struct vcap_typegroup typegroups[] = {
+		{ .offset = 0, .width = 4, .value = 8, },
+		{ .offset = 49, .width = 1, .value = 1, },
+		{ .offset = 98, .width = 2, .value = 3, },
+		{ .offset = 147, .width = 3, .value = 5, },
+		{ .offset = 196, .width = 2, .value = 2, },
+		{ .offset = 245, .width = 1, .value = 0, },
+	};
+
+	vcap_iter_init(&iter, 49, typegroups, 44);
+
+	KUNIT_EXPECT_EQ(test, 48, iter.offset);
+	KUNIT_EXPECT_EQ(test, 1, iter.reg_idx);
+	KUNIT_EXPECT_EQ(test, 16, iter.reg_bitpos);
+
+	vcap_encode_bit(stream, &iter, 1);
+
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[0]);
+	KUNIT_EXPECT_EQ(test, (u32)BIT(16), stream[1]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[2]);
+}
+
+static void vcap_api_encode_field_test(struct kunit *test)
+{
+	struct vcap_stream_iter iter;
+	u32 stream[16] = {0};
+	struct vcap_typegroup typegroups[] = {
+		{ .offset = 0, .width = 4, .value = 8, },
+		{ .offset = 49, .width = 1, .value = 1, },
+		{ .offset = 98, .width = 2, .value = 3, },
+		{ .offset = 147, .width = 3, .value = 5, },
+		{ .offset = 196, .width = 2, .value = 2, },
+		{ .offset = 245, .width = 5, .value = 27, },
+		{ .offset = 0, .width = 0, .value = 0, },
+	};
+	struct vcap_field rf = {
+		.type = VCAP_FIELD_U32,
+		.offset = 86,
+		.width = 4,
+	};
+	u8 value[] = {0x5};
+
+	vcap_iter_init(&iter, 49, typegroups, rf.offset);
+
+	KUNIT_EXPECT_EQ(test, 91, iter.offset);
+	KUNIT_EXPECT_EQ(test, 3, iter.reg_idx);
+	KUNIT_EXPECT_EQ(test, 10, iter.reg_bitpos);
+
+	vcap_encode_field(stream, &iter, rf.width, value);
+
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[0]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[1]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[2]);
+	KUNIT_EXPECT_EQ(test, (u32)(0x5 << 10), stream[3]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[4]);
+
+	vcap_encode_typegroups(stream, 49, typegroups, false);
+
+	KUNIT_EXPECT_EQ(test, (u32)0x8, stream[0]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[1]);
+	KUNIT_EXPECT_EQ(test, (u32)0x1, stream[2]);
+	KUNIT_EXPECT_EQ(test, (u32)(0x5 << 10), stream[3]);
+	KUNIT_EXPECT_EQ(test, (u32)0x3, stream[4]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[5]);
+	KUNIT_EXPECT_EQ(test, (u32)0x5, stream[6]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[7]);
+	KUNIT_EXPECT_EQ(test, (u32)0x2, stream[8]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[9]);
+	KUNIT_EXPECT_EQ(test, (u32)27, stream[10]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[11]);
+}
+
+/* In this testcase the subword is smaller than a register */
+static void vcap_api_encode_short_field_test(struct kunit *test)
+{
+	struct vcap_stream_iter iter;
+	int sw_width = 21;
+	u32 stream[6] = {0};
+	struct vcap_typegroup tgt[] = {
+		{ .offset = 0, .width = 3, .value = 7, },
+		{ .offset = 21, .width = 2, .value = 3, },
+		{ .offset = 42, .width = 1, .value = 1, },
+		{ .offset = 0, .width = 0, .value = 0, },
+	};
+	struct vcap_field rf = {
+		.type = VCAP_FIELD_U32,
+		.offset = 25,
+		.width = 4,
+	};
+	u8 value[] = {0x5};
+
+	vcap_iter_init(&iter, sw_width, tgt, rf.offset);
+
+	KUNIT_EXPECT_EQ(test, 1, iter.regs_per_sw);
+	KUNIT_EXPECT_EQ(test, 21, iter.sw_width);
+	KUNIT_EXPECT_EQ(test, 25 + 3 + 2, iter.offset);
+	KUNIT_EXPECT_EQ(test, 1, iter.reg_idx);
+	KUNIT_EXPECT_EQ(test, 25 + 3 + 2 - sw_width, iter.reg_bitpos);
+
+	vcap_encode_field(stream, &iter, rf.width, value);
+
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[0]);
+	KUNIT_EXPECT_EQ(test, (u32)(0x5 << (25 + 3 + 2 - sw_width)), stream[1]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[2]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[3]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[4]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, stream[5]);
+
+	vcap_encode_typegroups(stream, sw_width, tgt, false);
+
+	KUNIT_EXPECT_EQ(test, (u32)7, stream[0]);
+	KUNIT_EXPECT_EQ(test, (u32)((0x5 << (25 + 3 + 2 - sw_width)) + 3), stream[1]);
+	KUNIT_EXPECT_EQ(test, (u32)1, stream[2]);
+	KUNIT_EXPECT_EQ(test, (u32)0, stream[3]);
+	KUNIT_EXPECT_EQ(test, (u32)0, stream[4]);
+	KUNIT_EXPECT_EQ(test, (u32)0, stream[5]);
+}
+
+static void vcap_api_encode_keyfield_test(struct kunit *test)
+{
+	u32 keywords[16] = {0};
+	u32 maskwords[16] = {0};
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS2,
+		.cache = {
+			.keystream = keywords,
+			.maskstream = maskwords,
+			.actionstream = keywords,
+		},
+	};
+	struct vcap_rule_internal rule = {
+		.admin = &admin,
+		.data = {
+			.keyset = VCAP_KFS_MAC_ETYPE,
+		},
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_client_keyfield ckf = {
+		.ctrl.list = {},
+		.ctrl.key = VCAP_KF_ISDX_CLS,
+		.ctrl.type = VCAP_FIELD_U32,
+		.data.u32.value = 0xeef014a1,
+		.data.u32.mask = 0xfff,
+	};
+	struct vcap_field rf = {
+		.type = VCAP_FIELD_U32,
+		.offset = 56,
+		.width = 12,
+	};
+	struct vcap_typegroup tgt[] = {
+		{ .offset = 0, .width = 2, .value = 2, },
+		{ .offset = 156, .width = 1, .value = 1, },
+		{ .offset = 0, .width = 0, .value = 0, },
+	};
+
+	vcap_test_api_init(&admin);
+	vcap_encode_keyfield(&rule, &ckf, &rf, tgt);
+
+	/* Key */
+	KUNIT_EXPECT_EQ(test, (u32)0x0, keywords[0]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, keywords[1]);
+	KUNIT_EXPECT_EQ(test, (u32)(0x04a1 << 6), keywords[2]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, keywords[3]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, keywords[4]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, keywords[5]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, keywords[6]);
+
+	/* Mask */
+	KUNIT_EXPECT_EQ(test, (u32)0x0, maskwords[0]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, maskwords[1]);
+	KUNIT_EXPECT_EQ(test, (u32)(0x0fff << 6), maskwords[2]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, maskwords[3]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, maskwords[4]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, maskwords[5]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, maskwords[6]);
+}
+
+static void vcap_api_encode_max_keyfield_test(struct kunit *test)
+{
+	int idx;
+	u32 keywords[6] = {0};
+	u32 maskwords[6] = {0};
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS2,
+		/* IS2 sw_width = 52 bit */
+		.cache = {
+			.keystream = keywords,
+			.maskstream = maskwords,
+			.actionstream = keywords,
+		},
+	};
+	struct vcap_rule_internal rule = {
+		.admin = &admin,
+		.data = {
+			.keyset = VCAP_KFS_IP_7TUPLE,
+		},
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_client_keyfield ckf = {
+		.ctrl.list = {},
+		.ctrl.key = VCAP_KF_L3_IP6_DIP,
+		.ctrl.type = VCAP_FIELD_U128,
+		.data.u128.value = { 0xa1, 0xa2, 0xa3, 0xa4, 0, 0, 0x43, 0,
+			0, 0, 0, 0, 0, 0, 0x78, 0x8e, },
+		.data.u128.mask =  { 0xff, 0xff, 0xff, 0xff, 0, 0, 0xff, 0,
+			0, 0, 0, 0, 0, 0, 0xff, 0xff },
+	};
+	struct vcap_field rf = {
+		.type = VCAP_FIELD_U128,
+		.offset = 0,
+		.width = 128,
+	};
+	struct vcap_typegroup tgt[] = {
+		{ .offset = 0, .width = 2, .value = 2, },
+		{ .offset = 156, .width = 1, .value = 1, },
+		{ .offset = 0, .width = 0, .value = 0, },
+	};
+	u32 keyres[] = {
+		0x928e8a84,
+		0x000c0002,
+		0x00000010,
+		0x00000000,
+		0x0239e000,
+		0x00000000,
+	};
+	u32 mskres[] = {
+		0xfffffffc,
+		0x000c0003,
+		0x0000003f,
+		0x00000000,
+		0x03fffc00,
+		0x00000000,
+	};
+
+	vcap_encode_keyfield(&rule, &ckf, &rf, tgt);
+
+	/* Key */
+	for (idx = 0; idx < ARRAY_SIZE(keyres); ++idx)
+		KUNIT_EXPECT_EQ(test, keyres[idx], keywords[idx]);
+	/* Mask */
+	for (idx = 0; idx < ARRAY_SIZE(mskres); ++idx)
+		KUNIT_EXPECT_EQ(test, mskres[idx], maskwords[idx]);
+}
+
+static void vcap_api_encode_actionfield_test(struct kunit *test)
+{
+	u32 actwords[16] = {0};
+	int sw_width = 21;
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_ES2, /* act_width = 21 */
+		.cache = {
+			.actionstream = actwords,
+		},
+	};
+	struct vcap_rule_internal rule = {
+		.admin = &admin,
+		.data = {
+			.actionset = VCAP_AFS_BASE_TYPE,
+		},
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_client_actionfield caf = {
+		.ctrl.list = {},
+		.ctrl.action = VCAP_AF_POLICE_IDX,
+		.ctrl.type = VCAP_FIELD_U32,
+		.data.u32.value = 0x67908032,
+	};
+	struct vcap_field rf = {
+		.type = VCAP_FIELD_U32,
+		.offset = 35,
+		.width = 6,
+	};
+	struct vcap_typegroup tgt[] = {
+		{ .offset = 0, .width = 2, .value = 2, },
+		{ .offset = 21, .width = 1, .value = 1, },
+		{ .offset = 42, .width = 1, .value = 0, },
+		{ .offset = 0, .width = 0, .value = 0, },
+	};
+
+	vcap_encode_actionfield(&rule, &caf, &rf, tgt);
+
+	/* Action */
+	KUNIT_EXPECT_EQ(test, (u32)0x0, actwords[0]);
+	KUNIT_EXPECT_EQ(test, (u32)((0x32 << (35 + 2 + 1 - sw_width)) & 0x1fffff), actwords[1]);
+	KUNIT_EXPECT_EQ(test, (u32)((0x32 >> ((2 * sw_width) - 38 - 1))), actwords[2]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, actwords[3]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, actwords[4]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, actwords[5]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0, actwords[6]);
+}
+
+static void vcap_api_keyfield_typegroup_test(struct kunit *test)
+{
+	const struct vcap_typegroup *tg;
+
+	tg = vcap_keyfield_typegroup(&test_vctrl, VCAP_TYPE_IS2, VCAP_KFS_MAC_ETYPE);
+	KUNIT_EXPECT_PTR_NE(test, NULL, tg);
+	KUNIT_EXPECT_EQ(test, 0, tg[0].offset);
+	KUNIT_EXPECT_EQ(test, 2, tg[0].width);
+	KUNIT_EXPECT_EQ(test, 2, tg[0].value);
+	KUNIT_EXPECT_EQ(test, 156, tg[1].offset);
+	KUNIT_EXPECT_EQ(test, 1, tg[1].width);
+	KUNIT_EXPECT_EQ(test, 0, tg[1].value);
+	KUNIT_EXPECT_EQ(test, 0, tg[2].offset);
+	KUNIT_EXPECT_EQ(test, 0, tg[2].width);
+	KUNIT_EXPECT_EQ(test, 0, tg[2].value);
+
+	tg = vcap_keyfield_typegroup(&test_vctrl, VCAP_TYPE_ES2, VCAP_KFS_LL_FULL);
+	KUNIT_EXPECT_PTR_EQ(test, NULL, tg);
+}
+
+static void vcap_api_actionfield_typegroup_test(struct kunit *test)
+{
+	const struct vcap_typegroup *tg;
+
+	tg = vcap_actionfield_typegroup(&test_vctrl, VCAP_TYPE_IS0, VCAP_AFS_FULL);
+	KUNIT_EXPECT_PTR_NE(test, NULL, tg);
+	KUNIT_EXPECT_EQ(test, 0, tg[0].offset);
+	KUNIT_EXPECT_EQ(test, 3, tg[0].width);
+	KUNIT_EXPECT_EQ(test, 4, tg[0].value);
+	KUNIT_EXPECT_EQ(test, 110, tg[1].offset);
+	KUNIT_EXPECT_EQ(test, 2, tg[1].width);
+	KUNIT_EXPECT_EQ(test, 0, tg[1].value);
+	KUNIT_EXPECT_EQ(test, 220, tg[2].offset);
+	KUNIT_EXPECT_EQ(test, 2, tg[2].width);
+	KUNIT_EXPECT_EQ(test, 0, tg[2].value);
+	KUNIT_EXPECT_EQ(test, 0, tg[3].offset);
+	KUNIT_EXPECT_EQ(test, 0, tg[3].width);
+	KUNIT_EXPECT_EQ(test, 0, tg[3].value);
+
+	tg = vcap_actionfield_typegroup(&test_vctrl, VCAP_TYPE_IS2, VCAP_AFS_CLASSIFICATION);
+	KUNIT_EXPECT_PTR_EQ(test, NULL, tg);
+}
+
+static void vcap_api_vcap_keyfields_test(struct kunit *test)
+{
+	const struct vcap_field *ft;
+
+	ft = vcap_keyfields(&test_vctrl, VCAP_TYPE_IS2, VCAP_KFS_MAC_ETYPE);
+	KUNIT_EXPECT_PTR_NE(test, NULL, ft);
+
+	/* Keyset that is not available and within the maximum keyset enum value */
+	ft = vcap_keyfields(&test_vctrl, VCAP_TYPE_ES2, VCAP_KFS_PURE_5TUPLE_IP4);
+	KUNIT_EXPECT_PTR_EQ(test, NULL, ft);
+
+	/* Keyset that is not available and beyond the maximum keyset enum value */
+	ft = vcap_keyfields(&test_vctrl, VCAP_TYPE_ES2, VCAP_KFS_LL_FULL);
+	KUNIT_EXPECT_PTR_EQ(test, NULL, ft);
+}
+
+static void vcap_api_vcap_actionfields_test(struct kunit *test)
+{
+	const struct vcap_field *ft;
+
+	ft = vcap_actionfields(&test_vctrl, VCAP_TYPE_IS0, VCAP_AFS_FULL);
+	KUNIT_EXPECT_PTR_NE(test, NULL, ft);
+
+	ft = vcap_actionfields(&test_vctrl, VCAP_TYPE_IS2, VCAP_AFS_FULL);
+	KUNIT_EXPECT_PTR_EQ(test, NULL, ft);
+
+	ft = vcap_actionfields(&test_vctrl, VCAP_TYPE_IS2, VCAP_AFS_CLASSIFICATION);
+	KUNIT_EXPECT_PTR_EQ(test, NULL, ft);
+}
+
+static void vcap_api_encode_rule_keyset_test(struct kunit *test)
+{
+	u32 keywords[16] = {0};
+	u32 maskwords[16] = {0};
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS2,
+		.cache = {
+			.keystream = keywords,
+			.maskstream = maskwords,
+		},
+	};
+	struct vcap_rule_internal rule = {
+		.admin = &admin,
+		.data = {
+			.keyset = VCAP_KFS_MAC_ETYPE,
+		},
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_client_keyfield ckf[] = {
+		{
+			.ctrl.key = VCAP_KF_TYPE,
+			.ctrl.type = VCAP_FIELD_U32,
+			.data.u32.value = 0x00,
+			.data.u32.mask = 0x0f,
+		},
+		{
+			.ctrl.key = VCAP_KF_LOOKUP_FIRST_IS,
+			.ctrl.type = VCAP_FIELD_BIT,
+			.data.u1.value = 0x01,
+			.data.u1.mask = 0x01,
+		},
+		{
+			.ctrl.key = VCAP_KF_IF_IGR_PORT_MASK_L3,
+			.ctrl.type = VCAP_FIELD_BIT,
+			.data.u1.value = 0x00,
+			.data.u1.mask = 0x01,
+		},
+		{
+			.ctrl.key = VCAP_KF_IF_IGR_PORT_MASK_RNG,
+			.ctrl.type = VCAP_FIELD_U32,
+			.data.u32.value = 0x00,
+			.data.u32.mask = 0x0f,
+		},
+		{
+			.ctrl.key = VCAP_KF_IF_IGR_PORT_MASK,
+			.ctrl.type = VCAP_FIELD_U72,
+			.data.u72.value = {0x0, 0x00, 0x00, 0x00},
+			.data.u72.mask = {0xfd, 0xff, 0xff, 0xff},
+		},
+		{
+			.ctrl.key = VCAP_KF_L2_DMAC,
+			.ctrl.type = VCAP_FIELD_U48,
+			/* Opposite endianness */
+			.data.u48.value = {0x01, 0x02, 0x03, 0x04, 0x05, 0x06},
+			.data.u48.mask = {0xff, 0xff, 0xff, 0xff, 0xff, 0xff},
+		},
+		{
+			.ctrl.key = VCAP_KF_ETYPE_LEN_IS,
+			.ctrl.type = VCAP_FIELD_BIT,
+			.data.u1.value = 0x01,
+			.data.u1.mask = 0x01,
+		},
+		{
+			.ctrl.key = VCAP_KF_ETYPE,
+			.ctrl.type = VCAP_FIELD_U32,
+			.data.u32.value = 0xaabb,
+			.data.u32.mask = 0xffff,
+		},
+	};
+	int idx;
+	int ret;
+
+	/* Empty entry list */
+	INIT_LIST_HEAD(&rule.data.keyfields);
+	ret = vcap_encode_rule_keyset(&rule);
+	KUNIT_EXPECT_EQ(test, -EINVAL, ret);
+
+	for (idx = 0; idx < ARRAY_SIZE(ckf); idx++)
+		list_add_tail(&ckf[idx].ctrl.list, &rule.data.keyfields);
+	ret = vcap_encode_rule_keyset(&rule);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	/* The key and mask values below are from an actual Sparx5 rule config */
+	/* Key */
+	KUNIT_EXPECT_EQ(test, (u32)0x00000042, keywords[0]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, keywords[1]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, keywords[2]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00020100, keywords[3]);
+	KUNIT_EXPECT_EQ(test, (u32)0x60504030, keywords[4]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, keywords[5]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, keywords[6]);
+	KUNIT_EXPECT_EQ(test, (u32)0x0002aaee, keywords[7]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, keywords[8]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, keywords[9]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, keywords[10]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, keywords[11]);
+
+	/* Mask: they will be inverted when applied to the register */
+	KUNIT_EXPECT_EQ(test, (u32)~0x00b07f80, maskwords[0]);
+	KUNIT_EXPECT_EQ(test, (u32)~0xfff00000, maskwords[1]);
+	KUNIT_EXPECT_EQ(test, (u32)~0xfffffffc, maskwords[2]);
+	KUNIT_EXPECT_EQ(test, (u32)~0xfff000ff, maskwords[3]);
+	KUNIT_EXPECT_EQ(test, (u32)~0x00000000, maskwords[4]);
+	KUNIT_EXPECT_EQ(test, (u32)~0xfffffff0, maskwords[5]);
+	KUNIT_EXPECT_EQ(test, (u32)~0xfffffffe, maskwords[6]);
+	KUNIT_EXPECT_EQ(test, (u32)~0xfffc0001, maskwords[7]);
+	KUNIT_EXPECT_EQ(test, (u32)~0xffffffff, maskwords[8]);
+	KUNIT_EXPECT_EQ(test, (u32)~0xffffffff, maskwords[9]);
+	KUNIT_EXPECT_EQ(test, (u32)~0xffffffff, maskwords[10]);
+	KUNIT_EXPECT_EQ(test, (u32)~0xffffffff, maskwords[11]);
+}
+
+static void vcap_api_encode_rule_actionset_test(struct kunit *test)
+{
+	u32 actwords[16] = {0};
+	struct vcap_admin admin = {
+		.vtype = VCAP_TYPE_IS2,
+		.cache = {
+			.actionstream = actwords,
+		},
+	};
+	struct vcap_rule_internal rule = {
+		.admin = &admin,
+		.data = {
+			.actionset = VCAP_AFS_BASE_TYPE,
+		},
+		.vctrl = &test_vctrl,
+	};
+	struct vcap_client_actionfield caf[] = {
+		{
+			.ctrl.action = VCAP_AF_MATCH_ID,
+			.ctrl.type = VCAP_FIELD_U32,
+			.data.u32.value = 0x01,
+		},
+		{
+			.ctrl.action = VCAP_AF_MATCH_ID_MASK,
+			.ctrl.type = VCAP_FIELD_U32,
+			.data.u32.value = 0x01,
+		},
+		{
+			.ctrl.action = VCAP_AF_CNT_ID,
+			.ctrl.type = VCAP_FIELD_U32,
+			.data.u32.value = 0x64,
+		},
+	};
+	int idx;
+	int ret;
+
+	/* Empty entry list */
+	INIT_LIST_HEAD(&rule.data.actionfields);
+	ret = vcap_encode_rule_actionset(&rule);
+	/* We allow rules with no actions */
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	for (idx = 0; idx < ARRAY_SIZE(caf); idx++)
+		list_add_tail(&caf[idx].ctrl.list, &rule.data.actionfields);
+	ret = vcap_encode_rule_actionset(&rule);
+	KUNIT_EXPECT_EQ(test, 0, ret);
+
+	/* The action values below are from an actual Sparx5 rule config */
+	KUNIT_EXPECT_EQ(test, (u32)0x00000002, actwords[0]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[1]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[2]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[3]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[4]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00100000, actwords[5]);
+	KUNIT_EXPECT_EQ(test, (u32)0x06400010, actwords[6]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[7]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[8]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[9]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[10]);
+	KUNIT_EXPECT_EQ(test, (u32)0x00000000, actwords[11]);
+}
+
+static struct kunit_case vcap_api_encoding_test_cases[] = {
+	KUNIT_CASE(vcap_api_set_bit_1_test),
+	KUNIT_CASE(vcap_api_set_bit_0_test),
+	KUNIT_CASE(vcap_api_iterator_init_test),
+	KUNIT_CASE(vcap_api_iterator_next_test),
+	KUNIT_CASE(vcap_api_encode_typegroups_test),
+	KUNIT_CASE(vcap_api_encode_bit_test),
+	KUNIT_CASE(vcap_api_encode_field_test),
+	KUNIT_CASE(vcap_api_encode_short_field_test),
+	KUNIT_CASE(vcap_api_encode_keyfield_test),
+	KUNIT_CASE(vcap_api_encode_max_keyfield_test),
+	KUNIT_CASE(vcap_api_encode_actionfield_test),
+	KUNIT_CASE(vcap_api_keyfield_typegroup_test),
+	KUNIT_CASE(vcap_api_actionfield_typegroup_test),
+	KUNIT_CASE(vcap_api_vcap_keyfields_test),
+	KUNIT_CASE(vcap_api_vcap_actionfields_test),
+	KUNIT_CASE(vcap_api_encode_rule_keyset_test),
+	KUNIT_CASE(vcap_api_encode_rule_actionset_test),
+	{}
+};
+
+static struct kunit_suite vcap_api_encoding_test_suite = {
+	.name = "VCAP_API_Encoding_Testsuite",
+	.test_cases = vcap_api_encoding_test_cases,
+};
+
+kunit_test_suite(vcap_api_encoding_test_suite);
-- 
2.38.0


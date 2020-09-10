Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E25B264E55
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:10:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgIJTKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:10:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:39598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgIJTJY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Sep 2020 15:09:24 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 63FD4214F1;
        Thu, 10 Sep 2020 19:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599764962;
        bh=NPQX1pJwOpd8GrqDKM1E8oOzMxd+rsd8Fyitc1fhKWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ruA3ROACFzMccihEnvHM7agTIjKkLwho9nua/Lu2/3WscZqmo5SXxvUfIh7aP7BWH
         MQPvFVEiXESrBcsUYD+SkzWBKwHMfQakQKonfXh1INP1dDnFRQRmDnL5HOSaOzIj4z
         +8ZE0sTzmBVV/GjLL6le37ajZCc3LcHGD2eJ8KUs=
From:   Jakub Kicinski <kuba@kernel.org>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH ethtool v2 1/2] update UAPI header copies
Date:   Thu, 10 Sep 2020 12:09:14 -0700
Message-Id: <20200910190915.564904-2-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910190915.564904-1-kuba@kernel.org>
References: <20200910190915.564904-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update to kernel commit 4f6a5caf187f.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 uapi/linux/ethtool.h         |  17 +++
 uapi/linux/ethtool_netlink.h |  55 +++++++++
 uapi/linux/if_link.h         | 227 ++++++++++++++++++++++++++++++++---
 uapi/linux/rtnetlink.h       |  46 +++----
 4 files changed, 305 insertions(+), 40 deletions(-)

diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
index a1cfbe2ef40f..847ccd0b1fce 100644
--- a/uapi/linux/ethtool.h
+++ b/uapi/linux/ethtool.h
@@ -667,6 +667,7 @@ enum ethtool_link_ext_substate_cable_issue {
  * @ETH_SS_SOF_TIMESTAMPING: SOF_TIMESTAMPING_* flags
  * @ETH_SS_TS_TX_TYPES: timestamping Tx types
  * @ETH_SS_TS_RX_FILTERS: timestamping Rx filters
+ * @ETH_SS_UDP_TUNNEL_TYPES: UDP tunnel types
  */
 enum ethtool_stringset {
 	ETH_SS_TEST		= 0,
@@ -684,6 +685,7 @@ enum ethtool_stringset {
 	ETH_SS_SOF_TIMESTAMPING,
 	ETH_SS_TS_TX_TYPES,
 	ETH_SS_TS_RX_FILTERS,
+	ETH_SS_UDP_TUNNEL_TYPES,
 
 	/* add new constants above here */
 	ETH_SS_COUNT
@@ -1598,6 +1600,21 @@ enum ethtool_link_mode_bit_indices {
 	ETHTOOL_LINK_MODE_400000baseDR8_Full_BIT	 = 72,
 	ETHTOOL_LINK_MODE_400000baseCR8_Full_BIT	 = 73,
 	ETHTOOL_LINK_MODE_FEC_LLRS_BIT			 = 74,
+	ETHTOOL_LINK_MODE_100000baseKR_Full_BIT		 = 75,
+	ETHTOOL_LINK_MODE_100000baseSR_Full_BIT		 = 76,
+	ETHTOOL_LINK_MODE_100000baseLR_ER_FR_Full_BIT	 = 77,
+	ETHTOOL_LINK_MODE_100000baseCR_Full_BIT		 = 78,
+	ETHTOOL_LINK_MODE_100000baseDR_Full_BIT		 = 79,
+	ETHTOOL_LINK_MODE_200000baseKR2_Full_BIT	 = 80,
+	ETHTOOL_LINK_MODE_200000baseSR2_Full_BIT	 = 81,
+	ETHTOOL_LINK_MODE_200000baseLR2_ER2_FR2_Full_BIT = 82,
+	ETHTOOL_LINK_MODE_200000baseDR2_Full_BIT	 = 83,
+	ETHTOOL_LINK_MODE_200000baseCR2_Full_BIT	 = 84,
+	ETHTOOL_LINK_MODE_400000baseKR4_Full_BIT	 = 85,
+	ETHTOOL_LINK_MODE_400000baseSR4_Full_BIT	 = 86,
+	ETHTOOL_LINK_MODE_400000baseLR4_ER4_FR4_Full_BIT = 87,
+	ETHTOOL_LINK_MODE_400000baseDR4_Full_BIT	 = 88,
+	ETHTOOL_LINK_MODE_400000baseCR4_Full_BIT	 = 89,
 	/* must be last entry */
 	__ETHTOOL_LINK_MODE_MASK_NBITS
 };
diff --git a/uapi/linux/ethtool_netlink.h b/uapi/linux/ethtool_netlink.h
index 0922ca6e0d69..cebdb52e6a05 100644
--- a/uapi/linux/ethtool_netlink.h
+++ b/uapi/linux/ethtool_netlink.h
@@ -41,6 +41,7 @@ enum {
 	ETHTOOL_MSG_TSINFO_GET,
 	ETHTOOL_MSG_CABLE_TEST_ACT,
 	ETHTOOL_MSG_CABLE_TEST_TDR_ACT,
+	ETHTOOL_MSG_TUNNEL_INFO_GET,
 
 	/* add new constants above here */
 	__ETHTOOL_MSG_USER_CNT,
@@ -556,6 +557,60 @@ enum {
 	ETHTOOL_A_CABLE_TEST_TDR_NTF_MAX = __ETHTOOL_A_CABLE_TEST_TDR_NTF_CNT - 1
 };
 
+/* TUNNEL INFO */
+
+enum {
+	ETHTOOL_UDP_TUNNEL_TYPE_VXLAN,
+	ETHTOOL_UDP_TUNNEL_TYPE_GENEVE,
+	ETHTOOL_UDP_TUNNEL_TYPE_VXLAN_GPE,
+
+	__ETHTOOL_UDP_TUNNEL_TYPE_CNT
+};
+
+enum {
+	ETHTOOL_A_TUNNEL_UDP_ENTRY_UNSPEC,
+
+	ETHTOOL_A_TUNNEL_UDP_ENTRY_PORT,		/* be16 */
+	ETHTOOL_A_TUNNEL_UDP_ENTRY_TYPE,		/* u32 */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TUNNEL_UDP_ENTRY_CNT,
+	ETHTOOL_A_TUNNEL_UDP_ENTRY_MAX = (__ETHTOOL_A_TUNNEL_UDP_ENTRY_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_TUNNEL_UDP_TABLE_UNSPEC,
+
+	ETHTOOL_A_TUNNEL_UDP_TABLE_SIZE,		/* u32 */
+	ETHTOOL_A_TUNNEL_UDP_TABLE_TYPES,		/* bitset */
+	ETHTOOL_A_TUNNEL_UDP_TABLE_ENTRY,		/* nest - _UDP_ENTRY_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TUNNEL_UDP_TABLE_CNT,
+	ETHTOOL_A_TUNNEL_UDP_TABLE_MAX = (__ETHTOOL_A_TUNNEL_UDP_TABLE_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_TUNNEL_UDP_UNSPEC,
+
+	ETHTOOL_A_TUNNEL_UDP_TABLE,			/* nest - _UDP_TABLE_* */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TUNNEL_UDP_CNT,
+	ETHTOOL_A_TUNNEL_UDP_MAX = (__ETHTOOL_A_TUNNEL_UDP_CNT - 1)
+};
+
+enum {
+	ETHTOOL_A_TUNNEL_INFO_UNSPEC,
+	ETHTOOL_A_TUNNEL_INFO_HEADER,			/* nest - _A_HEADER_* */
+
+	ETHTOOL_A_TUNNEL_INFO_UDP_PORTS,		/* nest - _UDP_TABLE */
+
+	/* add new constants above here */
+	__ETHTOOL_A_TUNNEL_INFO_CNT,
+	ETHTOOL_A_TUNNEL_INFO_MAX = (__ETHTOOL_A_TUNNEL_INFO_CNT - 1)
+};
+
 /* generic netlink info */
 #define ETHTOOL_GENL_NAME "ethtool"
 #define ETHTOOL_GENL_VERSION 1
diff --git a/uapi/linux/if_link.h b/uapi/linux/if_link.h
index a8901a39a345..9d96890f9742 100644
--- a/uapi/linux/if_link.h
+++ b/uapi/linux/if_link.h
@@ -40,26 +40,197 @@ struct rtnl_link_stats {
 	__u32	rx_nohandler;		/* dropped, no handler found	*/
 };
 
-/* The main device statistics structure */
+/**
+ * struct rtnl_link_stats64 - The main device statistics structure.
+ *
+ * @rx_packets: Number of good packets received by the interface.
+ *   For hardware interfaces counts all good packets received from the device
+ *   by the host, including packets which host had to drop at various stages
+ *   of processing (even in the driver).
+ *
+ * @tx_packets: Number of packets successfully transmitted.
+ *   For hardware interfaces counts packets which host was able to successfully
+ *   hand over to the device, which does not necessarily mean that packets
+ *   had been successfully transmitted out of the device, only that device
+ *   acknowledged it copied them out of host memory.
+ *
+ * @rx_bytes: Number of good received bytes, corresponding to @rx_packets.
+ *
+ *   For IEEE 802.3 devices should count the length of Ethernet Frames
+ *   excluding the FCS.
+ *
+ * @tx_bytes: Number of good transmitted bytes, corresponding to @tx_packets.
+ *
+ *   For IEEE 802.3 devices should count the length of Ethernet Frames
+ *   excluding the FCS.
+ *
+ * @rx_errors: Total number of bad packets received on this network device.
+ *   This counter must include events counted by @rx_length_errors,
+ *   @rx_crc_errors, @rx_frame_errors and other errors not otherwise
+ *   counted.
+ *
+ * @tx_errors: Total number of transmit problems.
+ *   This counter must include events counter by @tx_aborted_errors,
+ *   @tx_carrier_errors, @tx_fifo_errors, @tx_heartbeat_errors,
+ *   @tx_window_errors and other errors not otherwise counted.
+ *
+ * @rx_dropped: Number of packets received but not processed,
+ *   e.g. due to lack of resources or unsupported protocol.
+ *   For hardware interfaces this counter should not include packets
+ *   dropped by the device which are counted separately in
+ *   @rx_missed_errors (since procfs folds those two counters together).
+ *
+ * @tx_dropped: Number of packets dropped on their way to transmission,
+ *   e.g. due to lack of resources.
+ *
+ * @multicast: Multicast packets received.
+ *   For hardware interfaces this statistic is commonly calculated
+ *   at the device level (unlike @rx_packets) and therefore may include
+ *   packets which did not reach the host.
+ *
+ *   For IEEE 802.3 devices this counter may be equivalent to:
+ *
+ *    - 30.3.1.1.21 aMulticastFramesReceivedOK
+ *
+ * @collisions: Number of collisions during packet transmissions.
+ *
+ * @rx_length_errors: Number of packets dropped due to invalid length.
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter should be equivalent to a sum
+ *   of the following attributes:
+ *
+ *    - 30.3.1.1.23 aInRangeLengthErrors
+ *    - 30.3.1.1.24 aOutOfRangeLengthField
+ *    - 30.3.1.1.25 aFrameTooLongErrors
+ *
+ * @rx_over_errors: Receiver FIFO overflow event counter.
+ *
+ *   Historically the count of overflow events. Such events may be
+ *   reported in the receive descriptors or via interrupts, and may
+ *   not correspond one-to-one with dropped packets.
+ *
+ *   The recommended interpretation for high speed interfaces is -
+ *   number of packets dropped because they did not fit into buffers
+ *   provided by the host, e.g. packets larger than MTU or next buffer
+ *   in the ring was not available for a scatter transfer.
+ *
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   This statistics was historically used interchangeably with
+ *   @rx_fifo_errors.
+ *
+ *   This statistic corresponds to hardware events and is not commonly used
+ *   on software devices.
+ *
+ * @rx_crc_errors: Number of packets received with a CRC error.
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter must be equivalent to:
+ *
+ *    - 30.3.1.1.6 aFrameCheckSequenceErrors
+ *
+ * @rx_frame_errors: Receiver frame alignment errors.
+ *   Part of aggregate "frame" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter should be equivalent to:
+ *
+ *    - 30.3.1.1.7 aAlignmentErrors
+ *
+ * @rx_fifo_errors: Receiver FIFO error counter.
+ *
+ *   Historically the count of overflow events. Those events may be
+ *   reported in the receive descriptors or via interrupts, and may
+ *   not correspond one-to-one with dropped packets.
+ *
+ *   This statistics was used interchangeably with @rx_over_errors.
+ *   Not recommended for use in drivers for high speed interfaces.
+ *
+ *   This statistic is used on software devices, e.g. to count software
+ *   packet queue overflow (can) or sequencing errors (GRE).
+ *
+ * @rx_missed_errors: Count of packets missed by the host.
+ *   Folded into the "drop" counter in `/proc/net/dev`.
+ *
+ *   Counts number of packets dropped by the device due to lack
+ *   of buffer space. This usually indicates that the host interface
+ *   is slower than the network interface, or host is not keeping up
+ *   with the receive packet rate.
+ *
+ *   This statistic corresponds to hardware events and is not used
+ *   on software devices.
+ *
+ * @tx_aborted_errors:
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *   For IEEE 802.3 devices capable of half-duplex operation this counter
+ *   must be equivalent to:
+ *
+ *    - 30.3.1.1.11 aFramesAbortedDueToXSColls
+ *
+ *   High speed interfaces may use this counter as a general device
+ *   discard counter.
+ *
+ * @tx_carrier_errors: Number of frame transmission errors due to loss
+ *   of carrier during transmission.
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter must be equivalent to:
+ *
+ *    - 30.3.1.1.13 aCarrierSenseErrors
+ *
+ * @tx_fifo_errors: Number of frame transmission errors due to device
+ *   FIFO underrun / underflow. This condition occurs when the device
+ *   begins transmission of a frame but is unable to deliver the
+ *   entire frame to the transmitter in time for transmission.
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ * @tx_heartbeat_errors: Number of Heartbeat / SQE Test errors for
+ *   old half-duplex Ethernet.
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices possibly equivalent to:
+ *
+ *    - 30.3.2.1.4 aSQETestErrors
+ *
+ * @tx_window_errors: Number of frame transmission errors due
+ *   to late collisions (for Ethernet - after the first 64B of transmission).
+ *   Part of aggregate "carrier" errors in `/proc/net/dev`.
+ *
+ *   For IEEE 802.3 devices this counter must be equivalent to:
+ *
+ *    - 30.3.1.1.10 aLateCollisions
+ *
+ * @rx_compressed: Number of correctly received compressed packets.
+ *   This counters is only meaningful for interfaces which support
+ *   packet compression (e.g. CSLIP, PPP).
+ *
+ * @tx_compressed: Number of transmitted compressed packets.
+ *   This counters is only meaningful for interfaces which support
+ *   packet compression (e.g. CSLIP, PPP).
+ *
+ * @rx_nohandler: Number of packets received on the interface
+ *   but dropped by the networking stack because the device is
+ *   not designated to receive packets (e.g. backup link in a bond).
+ */
 struct rtnl_link_stats64 {
-	__u64	rx_packets;		/* total packets received	*/
-	__u64	tx_packets;		/* total packets transmitted	*/
-	__u64	rx_bytes;		/* total bytes received 	*/
-	__u64	tx_bytes;		/* total bytes transmitted	*/
-	__u64	rx_errors;		/* bad packets received		*/
-	__u64	tx_errors;		/* packet transmit problems	*/
-	__u64	rx_dropped;		/* no space in linux buffers	*/
-	__u64	tx_dropped;		/* no space available in linux	*/
-	__u64	multicast;		/* multicast packets received	*/
+	__u64	rx_packets;
+	__u64	tx_packets;
+	__u64	rx_bytes;
+	__u64	tx_bytes;
+	__u64	rx_errors;
+	__u64	tx_errors;
+	__u64	rx_dropped;
+	__u64	tx_dropped;
+	__u64	multicast;
 	__u64	collisions;
 
 	/* detailed rx_errors: */
 	__u64	rx_length_errors;
-	__u64	rx_over_errors;		/* receiver ring buff overflow	*/
-	__u64	rx_crc_errors;		/* recved pkt with crc error	*/
-	__u64	rx_frame_errors;	/* recv'd frame alignment error */
-	__u64	rx_fifo_errors;		/* recv'r fifo overrun		*/
-	__u64	rx_missed_errors;	/* receiver missed packet	*/
+	__u64	rx_over_errors;
+	__u64	rx_crc_errors;
+	__u64	rx_frame_errors;
+	__u64	rx_fifo_errors;
+	__u64	rx_missed_errors;
 
 	/* detailed tx_errors */
 	__u64	tx_aborted_errors;
@@ -71,8 +242,7 @@ struct rtnl_link_stats64 {
 	/* for cslip etc */
 	__u64	rx_compressed;
 	__u64	tx_compressed;
-
-	__u64	rx_nohandler;		/* dropped, no handler found	*/
+	__u64	rx_nohandler;
 };
 
 /* The struct should be in sync with struct ifmap */
@@ -170,12 +340,22 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_PROTO_DOWN_REASON,
 	__IFLA_MAX
 };
 
 
 #define IFLA_MAX (__IFLA_MAX - 1)
 
+enum {
+	IFLA_PROTO_DOWN_REASON_UNSPEC,
+	IFLA_PROTO_DOWN_REASON_MASK,	/* u32, mask for reason bits */
+	IFLA_PROTO_DOWN_REASON_VALUE,   /* u32, reason bit value */
+
+	__IFLA_PROTO_DOWN_REASON_CNT,
+	IFLA_PROTO_DOWN_REASON_MAX = __IFLA_PROTO_DOWN_REASON_CNT - 1
+};
+
 /* backwards compatibility for userspace */
 #define IFLA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifinfomsg))))
 #define IFLA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifinfomsg))
@@ -342,6 +522,7 @@ enum {
 	IFLA_BRPORT_ISOLATED,
 	IFLA_BRPORT_BACKUP_PORT,
 	IFLA_BRPORT_MRP_RING_OPEN,
+	IFLA_BRPORT_MRP_IN_OPEN,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
@@ -904,7 +1085,14 @@ enum {
 #define IFLA_IPOIB_MAX (__IFLA_IPOIB_MAX - 1)
 
 
-/* HSR section */
+/* HSR/PRP section, both uses same interface */
+
+/* Different redundancy protocols for hsr device */
+enum {
+	HSR_PROTOCOL_HSR,
+	HSR_PROTOCOL_PRP,
+	HSR_PROTOCOL_MAX,
+};
 
 enum {
 	IFLA_HSR_UNSPEC,
@@ -914,6 +1102,9 @@ enum {
 	IFLA_HSR_SUPERVISION_ADDR,	/* Supervision frame multicast addr */
 	IFLA_HSR_SEQ_NR,
 	IFLA_HSR_VERSION,		/* HSR version */
+	IFLA_HSR_PROTOCOL,		/* Indicate different protocol than
+					 * HSR. For example PRP.
+					 */
 	__IFLA_HSR_MAX,
 };
 
diff --git a/uapi/linux/rtnetlink.h b/uapi/linux/rtnetlink.h
index bcb1ba4d0146..5ad84e663d01 100644
--- a/uapi/linux/rtnetlink.h
+++ b/uapi/linux/rtnetlink.h
@@ -257,12 +257,12 @@ enum {
 
 /* rtm_protocol */
 
-#define RTPROT_UNSPEC	0
-#define RTPROT_REDIRECT	1	/* Route installed by ICMP redirects;
-				   not used by current IPv4 */
-#define RTPROT_KERNEL	2	/* Route installed by kernel		*/
-#define RTPROT_BOOT	3	/* Route installed during boot		*/
-#define RTPROT_STATIC	4	/* Route installed by administrator	*/
+#define RTPROT_UNSPEC		0
+#define RTPROT_REDIRECT		1	/* Route installed by ICMP redirects;
+					   not used by current IPv4 */
+#define RTPROT_KERNEL		2	/* Route installed by kernel		*/
+#define RTPROT_BOOT		3	/* Route installed during boot		*/
+#define RTPROT_STATIC		4	/* Route installed by administrator	*/
 
 /* Values of protocol >= RTPROT_STATIC are not interpreted by kernel;
    they are just passed from user and back as is.
@@ -271,22 +271,23 @@ enum {
    avoid conflicts.
  */
 
-#define RTPROT_GATED	8	/* Apparently, GateD */
-#define RTPROT_RA	9	/* RDISC/ND router advertisements */
-#define RTPROT_MRT	10	/* Merit MRT */
-#define RTPROT_ZEBRA	11	/* Zebra */
-#define RTPROT_BIRD	12	/* BIRD */
-#define RTPROT_DNROUTED	13	/* DECnet routing daemon */
-#define RTPROT_XORP	14	/* XORP */
-#define RTPROT_NTK	15	/* Netsukuku */
-#define RTPROT_DHCP	16      /* DHCP client */
-#define RTPROT_MROUTED	17      /* Multicast daemon */
-#define RTPROT_BABEL	42      /* Babel daemon */
-#define RTPROT_BGP	186     /* BGP Routes */
-#define RTPROT_ISIS	187     /* ISIS Routes */
-#define RTPROT_OSPF	188     /* OSPF Routes */
-#define RTPROT_RIP	189     /* RIP Routes */
-#define RTPROT_EIGRP	192     /* EIGRP Routes */
+#define RTPROT_GATED		8	/* Apparently, GateD */
+#define RTPROT_RA		9	/* RDISC/ND router advertisements */
+#define RTPROT_MRT		10	/* Merit MRT */
+#define RTPROT_ZEBRA		11	/* Zebra */
+#define RTPROT_BIRD		12	/* BIRD */
+#define RTPROT_DNROUTED		13	/* DECnet routing daemon */
+#define RTPROT_XORP		14	/* XORP */
+#define RTPROT_NTK		15	/* Netsukuku */
+#define RTPROT_DHCP		16	/* DHCP client */
+#define RTPROT_MROUTED		17	/* Multicast daemon */
+#define RTPROT_KEEPALIVED	18	/* Keepalived daemon */
+#define RTPROT_BABEL		42	/* Babel daemon */
+#define RTPROT_BGP		186	/* BGP Routes */
+#define RTPROT_ISIS		187	/* ISIS Routes */
+#define RTPROT_OSPF		188	/* OSPF Routes */
+#define RTPROT_RIP		189	/* RIP Routes */
+#define RTPROT_EIGRP		192	/* EIGRP Routes */
 
 /* rtm_scope
 
@@ -775,6 +776,7 @@ enum {
 #define RTEXT_FILTER_BRVLAN	(1 << 1)
 #define RTEXT_FILTER_BRVLAN_COMPRESSED	(1 << 2)
 #define	RTEXT_FILTER_SKIP_STATS	(1 << 3)
+#define RTEXT_FILTER_MRP	(1 << 4)
 
 /* End of information exported to user level */
 
-- 
2.26.2


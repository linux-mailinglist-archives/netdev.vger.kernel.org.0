Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0913745950F
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 19:48:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239444AbhKVSvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 13:51:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238406AbhKVSv2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 13:51:28 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4C5C061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 10:48:19 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id j5-20020a17090a318500b001a6c749e697so416885pjb.1
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 10:48:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EdbX2ghpQ9vGCoe/NbD/OG/lZYeiPPnzJFNcnSnyP2o=;
        b=Ou/WfVj599hFmzv0DVuE+VHs9Iav+bjkgTz9UezWWGG8UTEker7fXO8El8xVD35+QD
         bKqve4L8VLQiRlaJzdcJEO1Pczms9p1OXjIQTuVNNbI8I+Gc8qzfzxbsWZ0Ohjy73uBo
         /gEAtR++d05g5WTI4Y+GNZkm9sMBC5XiJgGS1A0RYh8/93IhzIOuZLJFu7c3A6xhUmUz
         8n2xujJPgAe0HRVIO/gHWDHOlf//OWWlUS+QZpMS3ozoFbLwcB5Y2kghk6ZDVQNfZU02
         YvjhMjUQyEf+kifi8YGSV8XUX0qZngUn3lyuGuQJr66wmu1OiXUtZO8Ynm4KTvz2WTg0
         N0pQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EdbX2ghpQ9vGCoe/NbD/OG/lZYeiPPnzJFNcnSnyP2o=;
        b=jx7iG1qb+4QHTw5wX6iAOF00DaehQwFxHWVLIoQOmxjLT5lhr1ossv+O+QGz4N0QhM
         WwtTXq15QuGBEWYwsRg1XZpLTsIVjMvsId7yKXK5AyBgEbDitl8bh/1Kr2ap79VGYRMq
         S8EopVEcsJujoAVNd95I0S5EzdXj5CB/dWy1GwNPL05RHb55qbaH1rfWMj4FgG5AhLgd
         RRk1Pj5u4uIhCI43yG99QyOndYfpxIZ9ps8wpbYfC8CPrwx1BB68DVytzlrso+tlQI1Z
         IvWtQg9ySK8jRZKrMESB7OAM+IsrTuSXTyovqvZ+frsloRZEyH4/gcpygHnZqqR/7xoo
         pm/Q==
X-Gm-Message-State: AOAM533NTp8gtBsFbtdtG2WmXJV/NvZk3hb91LCZrV71kmAzOowio8Up
        lyGN3QyrKI+Qm2DESIDBlO8=
X-Google-Smtp-Source: ABdhPJyhao89GFct97pvduRERnU8ef9nNMdoU/0Yl+czS7UTrn2a4mDD/cjzG0lER1WfXnBWZbRJ5Q==
X-Received: by 2002:a17:90b:92:: with SMTP id bb18mr33336733pjb.133.1637606898575;
        Mon, 22 Nov 2021 10:48:18 -0800 (PST)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:8f75:d048:aad9:afb3])
        by smtp.gmail.com with ESMTPSA id f4sm9125816pfg.34.2021.11.22.10.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 10:48:18 -0800 (PST)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH net] tools: sync uapi/linux/if_link.h header
Date:   Mon, 22 Nov 2021 10:48:10 -0800
Message-Id: <20211122184810.769159-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.34.0.rc2.393.gf8c9666880-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

This file has not been updated for a while.

Sync it before BIG TCP patch series.

Signed-off-by: Eric Dumazet <edumazet@google.com>
---
 tools/include/uapi/linux/if_link.h | 293 +++++++++++++++++++++++++----
 1 file changed, 259 insertions(+), 34 deletions(-)

diff --git a/tools/include/uapi/linux/if_link.h b/tools/include/uapi/linux/if_link.h
index b3610fdd1feec345dee8df36bce3c9c4895c98a0..eebd3894fe89a0dfda36d79e1a291743220db613 100644
--- a/tools/include/uapi/linux/if_link.h
+++ b/tools/include/uapi/linux/if_link.h
@@ -7,24 +7,23 @@
 
 /* This struct should be in sync with struct rtnl_link_stats64 */
 struct rtnl_link_stats {
-	__u32	rx_packets;		/* total packets received	*/
-	__u32	tx_packets;		/* total packets transmitted	*/
-	__u32	rx_bytes;		/* total bytes received 	*/
-	__u32	tx_bytes;		/* total bytes transmitted	*/
-	__u32	rx_errors;		/* bad packets received		*/
-	__u32	tx_errors;		/* packet transmit problems	*/
-	__u32	rx_dropped;		/* no space in linux buffers	*/
-	__u32	tx_dropped;		/* no space available in linux	*/
-	__u32	multicast;		/* multicast packets received	*/
+	__u32	rx_packets;
+	__u32	tx_packets;
+	__u32	rx_bytes;
+	__u32	tx_bytes;
+	__u32	rx_errors;
+	__u32	tx_errors;
+	__u32	rx_dropped;
+	__u32	tx_dropped;
+	__u32	multicast;
 	__u32	collisions;
-
 	/* detailed rx_errors: */
 	__u32	rx_length_errors;
-	__u32	rx_over_errors;		/* receiver ring buff overflow	*/
-	__u32	rx_crc_errors;		/* recved pkt with crc error	*/
-	__u32	rx_frame_errors;	/* recv'd frame alignment error */
-	__u32	rx_fifo_errors;		/* recv'r fifo overrun		*/
-	__u32	rx_missed_errors;	/* receiver missed packet	*/
+	__u32	rx_over_errors;
+	__u32	rx_crc_errors;
+	__u32	rx_frame_errors;
+	__u32	rx_fifo_errors;
+	__u32	rx_missed_errors;
 
 	/* detailed tx_errors */
 	__u32	tx_aborted_errors;
@@ -37,29 +36,201 @@ struct rtnl_link_stats {
 	__u32	rx_compressed;
 	__u32	tx_compressed;
 
-	__u32	rx_nohandler;		/* dropped, no handler found	*/
+	__u32	rx_nohandler;
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
+ *   For hardware interfaces this counter may include packets discarded
+ *   due to L2 address filtering but should not include packets dropped
+ *   by the device due to buffer exhaustion which are counted separately in
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
@@ -170,12 +340,29 @@ enum {
 	IFLA_PROP_LIST,
 	IFLA_ALT_IFNAME, /* Alternative ifname */
 	IFLA_PERM_ADDRESS,
+	IFLA_PROTO_DOWN_REASON,
+
+	/* device (sysfs) name as parent, used instead
+	 * of IFLA_LINK where there's no parent netdev
+	 */
+	IFLA_PARENT_DEV_NAME,
+	IFLA_PARENT_DEV_BUS_NAME,
+
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
 #ifndef __KERNEL__
 #define IFLA_RTA(r)  ((struct rtattr*)(((char*)(r)) + NLMSG_ALIGN(sizeof(struct ifinfomsg))))
@@ -293,6 +480,7 @@ enum {
 	IFLA_BR_MCAST_MLD_VERSION,
 	IFLA_BR_VLAN_STATS_PER_PORT,
 	IFLA_BR_MULTI_BOOLOPT,
+	IFLA_BR_MCAST_QUERIER_STATE,
 	__IFLA_BR_MAX,
 };
 
@@ -346,6 +534,8 @@ enum {
 	IFLA_BRPORT_BACKUP_PORT,
 	IFLA_BRPORT_MRP_RING_OPEN,
 	IFLA_BRPORT_MRP_IN_OPEN,
+	IFLA_BRPORT_MCAST_EHT_HOSTS_LIMIT,
+	IFLA_BRPORT_MCAST_EHT_HOSTS_CNT,
 	__IFLA_BRPORT_MAX
 };
 #define IFLA_BRPORT_MAX (__IFLA_BRPORT_MAX - 1)
@@ -433,6 +623,7 @@ enum macvlan_macaddr_mode {
 };
 
 #define MACVLAN_FLAG_NOPROMISC	1
+#define MACVLAN_FLAG_NODST	2 /* skip dst macvlan if matching src macvlan */
 
 /* VRF section */
 enum {
@@ -597,6 +788,18 @@ enum ifla_geneve_df {
 	GENEVE_DF_MAX = __GENEVE_DF_END - 1,
 };
 
+/* Bareudp section  */
+enum {
+	IFLA_BAREUDP_UNSPEC,
+	IFLA_BAREUDP_PORT,
+	IFLA_BAREUDP_ETHERTYPE,
+	IFLA_BAREUDP_SRCPORT_MIN,
+	IFLA_BAREUDP_MULTIPROTO_MODE,
+	__IFLA_BAREUDP_MAX
+};
+
+#define IFLA_BAREUDP_MAX (__IFLA_BAREUDP_MAX - 1)
+
 /* PPP section */
 enum {
 	IFLA_PPP_UNSPEC,
@@ -899,7 +1102,14 @@ enum {
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
@@ -909,6 +1119,9 @@ enum {
 	IFLA_HSR_SUPERVISION_ADDR,	/* Supervision frame multicast addr */
 	IFLA_HSR_SEQ_NR,
 	IFLA_HSR_VERSION,		/* HSR version */
+	IFLA_HSR_PROTOCOL,		/* Indicate different protocol than
+					 * HSR. For example PRP.
+					 */
 	__IFLA_HSR_MAX,
 };
 
@@ -1033,6 +1246,8 @@ enum {
 #define RMNET_FLAGS_INGRESS_MAP_COMMANDS          (1U << 1)
 #define RMNET_FLAGS_INGRESS_MAP_CKSUMV4           (1U << 2)
 #define RMNET_FLAGS_EGRESS_MAP_CKSUMV4            (1U << 3)
+#define RMNET_FLAGS_INGRESS_MAP_CKSUMV5           (1U << 4)
+#define RMNET_FLAGS_EGRESS_MAP_CKSUMV5            (1U << 5)
 
 enum {
 	IFLA_RMNET_UNSPEC,
@@ -1048,4 +1263,14 @@ struct ifla_rmnet_flags {
 	__u32	mask;
 };
 
+/* MCTP section */
+
+enum {
+	IFLA_MCTP_UNSPEC,
+	IFLA_MCTP_NET,
+	__IFLA_MCTP_MAX,
+};
+
+#define IFLA_MCTP_MAX (__IFLA_MCTP_MAX - 1)
+
 #endif /* _UAPI_LINUX_IF_LINK_H */
-- 
2.34.0.rc2.393.gf8c9666880-goog


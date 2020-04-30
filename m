Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02C411C0153
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728153AbgD3QFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727882AbgD3QEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:40 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B36892499F;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262677;
        bh=EgeHxN61vwbDy776vGD0UlRK8ecLAQSYNofjgH/jKXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pyekXDi982lYcpQhFt/IHqO97lmEmiII9z1+D+K+QDmCtrH8Z8FRR8MqQs1B9znAW
         D47YpHAOj4nNRbByXpd+mXeey/Oc9ioUz74mAvTgUWvD8hu3D4KZllq7EnL4dQiq06
         apeh9Vwic0v1pR8C3IZ1w//A5W3GbGvpmuJJ9rSw=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxGz-Uz; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 36/37] docs: networking: convert timestamping.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:31 +0200
Message-Id: <0e3747adb1934eec46f92ad9cec79696de50498f.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add a document title;
- adjust titles and chapters, adding proper markups;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 Documentation/networking/packet_mmap.rst      |   4 +-
 .../{timestamping.txt => timestamping.rst}    | 154 ++++++++++--------
 include/uapi/linux/errqueue.h                 |   2 +-
 4 files changed, 91 insertions(+), 70 deletions(-)
 rename Documentation/networking/{timestamping.txt => timestamping.rst} (89%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index be65ee509669..8f9a84b8e3f2 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -109,6 +109,7 @@ Contents:
    tc-actions-env-rules
    tcp-thin
    team
+   timestamping
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/packet_mmap.rst b/Documentation/networking/packet_mmap.rst
index 884c7222b9e9..6c009ceb1183 100644
--- a/Documentation/networking/packet_mmap.rst
+++ b/Documentation/networking/packet_mmap.rst
@@ -1030,7 +1030,7 @@ the packet meta information for mmap(2)ed RX_RING and TX_RINGs.  If your
 NIC is capable of timestamping packets in hardware, you can request those
 hardware timestamps to be used. Note: you may need to enable the generation
 of hardware timestamps with SIOCSHWTSTAMP (see related information from
-Documentation/networking/timestamping.txt).
+Documentation/networking/timestamping.rst).
 
 PACKET_TIMESTAMP accepts the same integer bit field as SO_TIMESTAMPING::
 
@@ -1069,7 +1069,7 @@ TX_RING part only TP_STATUS_AVAILABLE is set, then the tp_sec and tp_{n,u}sec
 members do not contain a valid value. For TX_RINGs, by default no timestamp
 is generated!
 
-See include/linux/net_tstamp.h and Documentation/networking/timestamping.txt
+See include/linux/net_tstamp.h and Documentation/networking/timestamping.rst
 for more information on hardware timestamps.
 
 Miscellaneous bits
diff --git a/Documentation/networking/timestamping.txt b/Documentation/networking/timestamping.rst
similarity index 89%
rename from Documentation/networking/timestamping.txt
rename to Documentation/networking/timestamping.rst
index 8dd6333c3270..1adead6a4527 100644
--- a/Documentation/networking/timestamping.txt
+++ b/Documentation/networking/timestamping.rst
@@ -1,9 +1,16 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+============
+Timestamping
+============
+
 
 1. Control Interfaces
+=====================
 
 The interfaces for receiving network packages timestamps are:
 
-* SO_TIMESTAMP
+SO_TIMESTAMP
   Generates a timestamp for each incoming packet in (not necessarily
   monotonic) system time. Reports the timestamp via recvmsg() in a
   control message in usec resolution.
@@ -13,7 +20,7 @@ The interfaces for receiving network packages timestamps are:
   SO_TIMESTAMP_OLD and in struct __kernel_sock_timeval for
   SO_TIMESTAMP_NEW options respectively.
 
-* SO_TIMESTAMPNS
+SO_TIMESTAMPNS
   Same timestamping mechanism as SO_TIMESTAMP, but reports the
   timestamp as struct timespec in nsec resolution.
   SO_TIMESTAMPNS is defined as SO_TIMESTAMPNS_NEW or SO_TIMESTAMPNS_OLD
@@ -22,17 +29,18 @@ The interfaces for receiving network packages timestamps are:
   and in struct __kernel_timespec for SO_TIMESTAMPNS_NEW options
   respectively.
 
-* IP_MULTICAST_LOOP + SO_TIMESTAMP[NS]
+IP_MULTICAST_LOOP + SO_TIMESTAMP[NS]
   Only for multicast:approximate transmit timestamp obtained by
   reading the looped packet receive timestamp.
 
-* SO_TIMESTAMPING
+SO_TIMESTAMPING
   Generates timestamps on reception, transmission or both. Supports
   multiple timestamp sources, including hardware. Supports generating
   timestamps for stream sockets.
 
 
-1.1 SO_TIMESTAMP (also SO_TIMESTAMP_OLD and SO_TIMESTAMP_NEW):
+1.1 SO_TIMESTAMP (also SO_TIMESTAMP_OLD and SO_TIMESTAMP_NEW)
+-------------------------------------------------------------
 
 This socket option enables timestamping of datagrams on the reception
 path. Because the destination socket, if any, is not known early in
@@ -59,10 +67,11 @@ struct __kernel_timespec format.
 SO_TIMESTAMPNS_OLD returns incorrect timestamps after the year 2038
 on 32 bit machines.
 
-1.3 SO_TIMESTAMPING (also SO_TIMESTAMPING_OLD and SO_TIMESTAMPING_NEW):
+1.3 SO_TIMESTAMPING (also SO_TIMESTAMPING_OLD and SO_TIMESTAMPING_NEW)
+----------------------------------------------------------------------
 
 Supports multiple types of timestamp requests. As a result, this
-socket option takes a bitmap of flags, not a boolean. In
+socket option takes a bitmap of flags, not a boolean. In::
 
   err = setsockopt(fd, SOL_SOCKET, SO_TIMESTAMPING, &val, sizeof(val));
 
@@ -76,6 +85,7 @@ be enabled for individual sendmsg calls using cmsg (1.3.4).
 
 
 1.3.1 Timestamp Generation
+^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 Some bits are requests to the stack to try to generate timestamps. Any
 combination of them is valid. Changes to these bits apply to newly
@@ -106,7 +116,6 @@ SOF_TIMESTAMPING_TX_SOFTWARE:
   require driver support and may not be available for all devices.
   This flag can be enabled via both socket options and control messages.
 
-
 SOF_TIMESTAMPING_TX_SCHED:
   Request tx timestamps prior to entering the packet scheduler. Kernel
   transmit latency is, if long, often dominated by queuing delay. The
@@ -132,6 +141,7 @@ SOF_TIMESTAMPING_TX_ACK:
 
 
 1.3.2 Timestamp Reporting
+^^^^^^^^^^^^^^^^^^^^^^^^^
 
 The other three bits control which timestamps will be reported in a
 generated control message. Changes to the bits take immediate
@@ -151,11 +161,11 @@ SOF_TIMESTAMPING_RAW_HARDWARE:
 
 
 1.3.3 Timestamp Options
+^^^^^^^^^^^^^^^^^^^^^^^
 
 The interface supports the options
 
 SOF_TIMESTAMPING_OPT_ID:
-
   Generate a unique identifier along with each packet. A process can
   have multiple concurrent timestamping requests outstanding. Packets
   can be reordered in the transmit path, for instance in the packet
@@ -183,7 +193,6 @@ SOF_TIMESTAMPING_OPT_ID:
 
 
 SOF_TIMESTAMPING_OPT_CMSG:
-
   Support recv() cmsg for all timestamped packets. Control messages
   are already supported unconditionally on all packets with receive
   timestamps and on IPv6 packets with transmit timestamp. This option
@@ -193,7 +202,6 @@ SOF_TIMESTAMPING_OPT_CMSG:
 
 
 SOF_TIMESTAMPING_OPT_TSONLY:
-
   Applies to transmit timestamps only. Makes the kernel return the
   timestamp as a cmsg alongside an empty packet, as opposed to
   alongside the original packet. This reduces the amount of memory
@@ -202,7 +210,6 @@ SOF_TIMESTAMPING_OPT_TSONLY:
   This option disables SOF_TIMESTAMPING_OPT_CMSG.
 
 SOF_TIMESTAMPING_OPT_STATS:
-
   Optional stats that are obtained along with the transmit timestamps.
   It must be used together with SOF_TIMESTAMPING_OPT_TSONLY. When the
   transmit timestamp is available, the stats are available in a
@@ -213,7 +220,6 @@ SOF_TIMESTAMPING_OPT_STATS:
   data was limited by peer's receiver window.
 
 SOF_TIMESTAMPING_OPT_PKTINFO:
-
   Enable the SCM_TIMESTAMPING_PKTINFO control message for incoming
   packets with hardware timestamps. The message contains struct
   scm_ts_pktinfo, which supplies the index of the real interface which
@@ -223,7 +229,6 @@ SOF_TIMESTAMPING_OPT_PKTINFO:
   other fields, but they are reserved and undefined.
 
 SOF_TIMESTAMPING_OPT_TX_SWHW:
-
   Request both hardware and software timestamps for outgoing packets
   when SOF_TIMESTAMPING_TX_HARDWARE and SOF_TIMESTAMPING_TX_SOFTWARE
   are enabled at the same time. If both timestamps are generated,
@@ -242,12 +247,13 @@ combined with SOF_TIMESTAMPING_OPT_TSONLY.
 
 
 1.3.4. Enabling timestamps via control messages
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 In addition to socket options, timestamp generation can be requested
 per write via cmsg, only for SOF_TIMESTAMPING_TX_* (see Section 1.3.1).
 Using this feature, applications can sample timestamps per sendmsg()
 without paying the overhead of enabling and disabling timestamps via
-setsockopt:
+setsockopt::
 
   struct msghdr *msg;
   ...
@@ -264,7 +270,7 @@ The SOF_TIMESTAMPING_TX_* flags set via cmsg will override
 the SOF_TIMESTAMPING_TX_* flags set via setsockopt.
 
 Moreover, applications must still enable timestamp reporting via
-setsockopt to receive timestamps:
+setsockopt to receive timestamps::
 
   __u32 val = SOF_TIMESTAMPING_SOFTWARE |
 	      SOF_TIMESTAMPING_OPT_ID /* or any other flag */;
@@ -272,6 +278,7 @@ setsockopt to receive timestamps:
 
 
 1.4 Bytestream Timestamps
+-------------------------
 
 The SO_TIMESTAMPING interface supports timestamping of bytes in a
 bytestream. Each request is interpreted as a request for when the
@@ -331,6 +338,7 @@ unusual.
 
 
 2 Data Interfaces
+==================
 
 Timestamps are read using the ancillary data feature of recvmsg().
 See `man 3 cmsg` for details of this interface. The socket manual
@@ -339,20 +347,21 @@ SO_TIMESTAMP and SO_TIMESTAMPNS records can be retrieved.
 
 
 2.1 SCM_TIMESTAMPING records
+----------------------------
 
 These timestamps are returned in a control message with cmsg_level
 SOL_SOCKET, cmsg_type SCM_TIMESTAMPING, and payload of type
 
-For SO_TIMESTAMPING_OLD:
+For SO_TIMESTAMPING_OLD::
 
-struct scm_timestamping {
-	struct timespec ts[3];
-};
+	struct scm_timestamping {
+		struct timespec ts[3];
+	};
 
-For SO_TIMESTAMPING_NEW:
+For SO_TIMESTAMPING_NEW::
 
-struct scm_timestamping64 {
-	struct __kernel_timespec ts[3];
+	struct scm_timestamping64 {
+		struct __kernel_timespec ts[3];
 
 Always use SO_TIMESTAMPING_NEW timestamp to always get timestamp in
 struct scm_timestamping64 format.
@@ -377,6 +386,7 @@ in ts[0] when a real software timestamp is missing. This happens also
 on hardware transmit timestamps.
 
 2.1.1 Transmit timestamps with MSG_ERRQUEUE
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
 
 For transmit timestamps the outgoing packet is looped back to the
 socket's error queue with the send timestamp(s) attached. A process
@@ -393,6 +403,7 @@ embeds the struct scm_timestamping.
 
 
 2.1.1.2 Timestamp types
+~~~~~~~~~~~~~~~~~~~~~~~
 
 The semantics of the three struct timespec are defined by field
 ee_info in the extended error structure. It contains a value of
@@ -408,6 +419,7 @@ case the timestamp is stored in ts[0].
 
 
 2.1.1.3 Fragmentation
+~~~~~~~~~~~~~~~~~~~~~
 
 Fragmentation of outgoing datagrams is rare, but is possible, e.g., by
 explicitly disabling PMTU discovery. If an outgoing packet is fragmented,
@@ -416,6 +428,7 @@ socket.
 
 
 2.1.1.4 Packet Payload
+~~~~~~~~~~~~~~~~~~~~~~
 
 The calling application is often not interested in receiving the whole
 packet payload that it passed to the stack originally: the socket
@@ -427,6 +440,7 @@ however, the full packet is queued, taking up budget from SO_RCVBUF.
 
 
 2.1.1.5 Blocking Read
+~~~~~~~~~~~~~~~~~~~~~
 
 Reading from the error queue is always a non-blocking operation. To
 block waiting on a timestamp, use poll or select. poll() will return
@@ -436,6 +450,7 @@ ignored on request. See also `man 2 poll`.
 
 
 2.1.2 Receive timestamps
+^^^^^^^^^^^^^^^^^^^^^^^^
 
 On reception, there is no reason to read from the socket error queue.
 The SCM_TIMESTAMPING ancillary data is sent along with the packet data
@@ -447,16 +462,17 @@ is again deprecated and ts[2] holds a hardware timestamp if set.
 
 
 3. Hardware Timestamping configuration: SIOCSHWTSTAMP and SIOCGHWTSTAMP
+=======================================================================
 
 Hardware time stamping must also be initialized for each device driver
 that is expected to do hardware time stamping. The parameter is defined in
-include/uapi/linux/net_tstamp.h as:
+include/uapi/linux/net_tstamp.h as::
 
-struct hwtstamp_config {
-	int flags;	/* no flags defined right now, must be zero */
-	int tx_type;	/* HWTSTAMP_TX_* */
-	int rx_filter;	/* HWTSTAMP_FILTER_* */
-};
+	struct hwtstamp_config {
+		int flags;	/* no flags defined right now, must be zero */
+		int tx_type;	/* HWTSTAMP_TX_* */
+		int rx_filter;	/* HWTSTAMP_FILTER_* */
+	};
 
 Desired behavior is passed into the kernel and to a specific device by
 calling ioctl(SIOCSHWTSTAMP) with a pointer to a struct ifreq whose
@@ -487,44 +503,47 @@ Any process can read the actual configuration by passing this
 structure to ioctl(SIOCGHWTSTAMP) in the same way.  However, this has
 not been implemented in all drivers.
 
-/* possible values for hwtstamp_config->tx_type */
-enum {
-	/*
-	 * no outgoing packet will need hardware time stamping;
-	 * should a packet arrive which asks for it, no hardware
-	 * time stamping will be done
-	 */
-	HWTSTAMP_TX_OFF,
+::
 
-	/*
-	 * enables hardware time stamping for outgoing packets;
-	 * the sender of the packet decides which are to be
-	 * time stamped by setting SOF_TIMESTAMPING_TX_SOFTWARE
-	 * before sending the packet
-	 */
-	HWTSTAMP_TX_ON,
-};
+    /* possible values for hwtstamp_config->tx_type */
+    enum {
+	    /*
+	    * no outgoing packet will need hardware time stamping;
+	    * should a packet arrive which asks for it, no hardware
+	    * time stamping will be done
+	    */
+	    HWTSTAMP_TX_OFF,
 
-/* possible values for hwtstamp_config->rx_filter */
-enum {
-	/* time stamp no incoming packet at all */
-	HWTSTAMP_FILTER_NONE,
+	    /*
+	    * enables hardware time stamping for outgoing packets;
+	    * the sender of the packet decides which are to be
+	    * time stamped by setting SOF_TIMESTAMPING_TX_SOFTWARE
+	    * before sending the packet
+	    */
+	    HWTSTAMP_TX_ON,
+    };
 
-	/* time stamp any incoming packet */
-	HWTSTAMP_FILTER_ALL,
+    /* possible values for hwtstamp_config->rx_filter */
+    enum {
+	    /* time stamp no incoming packet at all */
+	    HWTSTAMP_FILTER_NONE,
 
-	/* return value: time stamp all packets requested plus some others */
-	HWTSTAMP_FILTER_SOME,
+	    /* time stamp any incoming packet */
+	    HWTSTAMP_FILTER_ALL,
 
-	/* PTP v1, UDP, any kind of event packet */
-	HWTSTAMP_FILTER_PTP_V1_L4_EVENT,
+	    /* return value: time stamp all packets requested plus some others */
+	    HWTSTAMP_FILTER_SOME,
 
-	/* for the complete list of values, please check
-	 * the include file include/uapi/linux/net_tstamp.h
-	 */
-};
+	    /* PTP v1, UDP, any kind of event packet */
+	    HWTSTAMP_FILTER_PTP_V1_L4_EVENT,
+
+	    /* for the complete list of values, please check
+	    * the include file include/uapi/linux/net_tstamp.h
+	    */
+    };
 
 3.1 Hardware Timestamping Implementation: Device Drivers
+--------------------------------------------------------
 
 A driver which supports hardware time stamping must support the
 SIOCSHWTSTAMP ioctl and update the supplied struct hwtstamp_config with
@@ -533,22 +552,23 @@ should also support SIOCGHWTSTAMP.
 
 Time stamps for received packets must be stored in the skb. To get a pointer
 to the shared time stamp structure of the skb call skb_hwtstamps(). Then
-set the time stamps in the structure:
+set the time stamps in the structure::
 
-struct skb_shared_hwtstamps {
-	/* hardware time stamp transformed into duration
-	 * since arbitrary point in time
-	 */
-	ktime_t	hwtstamp;
-};
+    struct skb_shared_hwtstamps {
+	    /* hardware time stamp transformed into duration
+	    * since arbitrary point in time
+	    */
+	    ktime_t	hwtstamp;
+    };
 
 Time stamps for outgoing packets are to be generated as follows:
+
 - In hard_start_xmit(), check if (skb_shinfo(skb)->tx_flags & SKBTX_HW_TSTAMP)
   is set no-zero. If yes, then the driver is expected to do hardware time
   stamping.
 - If this is possible for the skb and requested, then declare
   that the driver is doing the time stamping by setting the flag
-  SKBTX_IN_PROGRESS in skb_shinfo(skb)->tx_flags , e.g. with
+  SKBTX_IN_PROGRESS in skb_shinfo(skb)->tx_flags , e.g. with::
 
       skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
diff --git a/include/uapi/linux/errqueue.h b/include/uapi/linux/errqueue.h
index 0cca19670fd2..ca5cb3e3c6df 100644
--- a/include/uapi/linux/errqueue.h
+++ b/include/uapi/linux/errqueue.h
@@ -36,7 +36,7 @@ struct sock_extended_err {
  *
  *	The timestamping interfaces SO_TIMESTAMPING, MSG_TSTAMP_*
  *	communicate network timestamps by passing this struct in a cmsg with
- *	recvmsg(). See Documentation/networking/timestamping.txt for details.
+ *	recvmsg(). See Documentation/networking/timestamping.rst for details.
  *	User space sees a timespec definition that matches either
  *	__kernel_timespec or __kernel_old_timespec, in the kernel we
  *	require two structure definitions to provide both.
-- 
2.25.4


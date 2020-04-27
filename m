Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ED241BB0ED
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726548AbgD0WCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:02:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:48124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726405AbgD0WCD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:03 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2065D22277;
        Mon, 27 Apr 2020 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=B0tMPR6+mh208jit95b6cw+WD4mUBQOHposd+FXdKR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OIQ7XYjzVKwheJAka9NvRphrqclcqYWdQDB987T+sJA28+2L05PHu5rvxrS/UxvY/
         oHglwj1Ff8dyj7Ete/4md8PIlg6CFf76TThAiFo899Rtbw45wV7m/cakf4DuP1zdkV
         VOH5KSnAP6xq4voa/9b+BwrNnbqkaMTvyaml2ERw=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000IqN-Cr; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Subject: [PATCH 34/38] docs: networking: convert ip-sysctl.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:49 +0200
Message-Id: <b2e88882f8bd00bf6d0cad3d022761121391728b.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust titles and chapters, adding proper markups;
- mark code blocks and literals as such;
- mark lists as such;
- mark tables as such;
- use footnote markup;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/admin-guide/sysctl/net.rst      |   2 +-
 Documentation/networking/index.rst            |   1 +
 .../{ip-sysctl.txt => ip-sysctl.rst}          | 829 ++++++++++++------
 Documentation/networking/snmp_counter.rst     |   2 +-
 net/Kconfig                                   |   2 +-
 net/ipv4/Kconfig                              |   2 +-
 net/ipv4/icmp.c                               |   2 +-
 8 files changed, 559 insertions(+), 283 deletions(-)
 rename Documentation/networking/{ip-sysctl.txt => ip-sysctl.rst} (83%)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index cd68635370c6..ef9779398cee 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -4950,7 +4950,7 @@
 			Set the number of tcp_metrics_hash slots.
 			Default value is 8192 or 16384 depending on total
 			ram pages. This is used to specify the TCP metrics
-			cache size. See Documentation/networking/ip-sysctl.txt
+			cache size. See Documentation/networking/ip-sysctl.rst
 			"tcp_no_metrics_save" section for more details.
 
 	tdfx=		[HW,DRM]
diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index e043c9213388..84e3348a9543 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -353,7 +353,7 @@ socket's buffer. It will not take effect unless PF_UNIX flag is specified.
 
 3. /proc/sys/net/ipv4 - IPV4 settings
 -------------------------------------
-Please see: Documentation/networking/ip-sysctl.txt and ipvs-sysctl.txt for
+Please see: Documentation/networking/ip-sysctl.rst and ipvs-sysctl.txt for
 descriptions of these entries.
 
 
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 3efb4608649a..7d133d8dbe2a 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -69,6 +69,7 @@ Contents:
    ip_dynaddr
    iphase
    ipsec
+   ip-sysctl
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.rst
similarity index 83%
rename from Documentation/networking/ip-sysctl.txt
rename to Documentation/networking/ip-sysctl.rst
index 9375324aa8e1..65374ffaafb8 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1,8 +1,15 @@
-/proc/sys/net/ipv4/* Variables:
+.. SPDX-License-Identifier: GPL-2.0
+
+=========
+IP Sysctl
+=========
+
+/proc/sys/net/ipv4/* Variables
+==============================
 
 ip_forward - BOOLEAN
-	0 - disabled (default)
-	not 0 - enabled
+	- 0 - disabled (default)
+	- not 0 - enabled
 
 	Forward Packets between interfaces.
 
@@ -38,6 +45,7 @@ ip_no_pmtu_disc - INTEGER
 	could break other protocols.
 
 	Possible values: 0-3
+
 	Default: FALSE
 
 min_pmtu - INTEGER
@@ -51,16 +59,20 @@ ip_forward_use_pmtu - BOOLEAN
 	which tries to discover path mtus by itself and depends on the
 	kernel honoring this information. This is normally not the
 	case.
+
 	Default: 0 (disabled)
+
 	Possible values:
-	0 - disabled
-	1 - enabled
+
+	- 0 - disabled
+	- 1 - enabled
 
 fwmark_reflect - BOOLEAN
 	Controls the fwmark of kernel-generated IPv4 reply packets that are not
 	associated with a socket for example, TCP RSTs or ICMP echo replies).
 	If unset, these packets have a fwmark of zero. If set, they have the
 	fwmark of the packet they are replying to.
+
 	Default: 0
 
 fib_multipath_use_neigh - BOOLEAN
@@ -68,63 +80,80 @@ fib_multipath_use_neigh - BOOLEAN
 	multipath routes. If disabled, neighbor information is not used and
 	packets could be directed to a failed nexthop. Only valid for kernels
 	built with CONFIG_IP_ROUTE_MULTIPATH enabled.
+
 	Default: 0 (disabled)
+
 	Possible values:
-	0 - disabled
-	1 - enabled
+
+	- 0 - disabled
+	- 1 - enabled
 
 fib_multipath_hash_policy - INTEGER
 	Controls which hash policy to use for multipath routes. Only valid
 	for kernels built with CONFIG_IP_ROUTE_MULTIPATH enabled.
+
 	Default: 0 (Layer 3)
+
 	Possible values:
-	0 - Layer 3
-	1 - Layer 4
-	2 - Layer 3 or inner Layer 3 if present
+
+	- 0 - Layer 3
+	- 1 - Layer 4
+	- 2 - Layer 3 or inner Layer 3 if present
 
 fib_sync_mem - UNSIGNED INTEGER
 	Amount of dirty memory from fib entries that can be backlogged before
 	synchronize_rcu is forced.
-	  Default: 512kB   Minimum: 64kB   Maximum: 64MB
+
+	Default: 512kB   Minimum: 64kB   Maximum: 64MB
 
 ip_forward_update_priority - INTEGER
 	Whether to update SKB priority from "TOS" field in IPv4 header after it
 	is forwarded. The new SKB priority is mapped from TOS field value
 	according to an rt_tos2priority table (see e.g. man tc-prio).
+
 	Default: 1 (Update priority.)
+
 	Possible values:
-	0 - Do not update priority.
-	1 - Update priority.
+
+	- 0 - Do not update priority.
+	- 1 - Update priority.
 
 route/max_size - INTEGER
 	Maximum number of routes allowed in the kernel.  Increase
 	this when using large numbers of interfaces and/or routes.
+
 	From linux kernel 3.6 onwards, this is deprecated for ipv4
 	as route cache is no longer used.
 
 neigh/default/gc_thresh1 - INTEGER
 	Minimum number of entries to keep.  Garbage collector will not
 	purge entries if there are fewer than this number.
+
 	Default: 128
 
 neigh/default/gc_thresh2 - INTEGER
 	Threshold when garbage collector becomes more aggressive about
 	purging entries. Entries older than 5 seconds will be cleared
 	when over this number.
+
 	Default: 512
 
 neigh/default/gc_thresh3 - INTEGER
 	Maximum number of non-PERMANENT neighbor entries allowed.  Increase
 	this when using large numbers of interfaces and when communicating
 	with large numbers of directly-connected peers.
+
 	Default: 1024
 
 neigh/default/unres_qlen_bytes - INTEGER
 	The maximum number of bytes which may be used by packets
 	queued for each	unresolved address by other network layers.
 	(added in linux 3.3)
+
 	Setting negative value is meaningless and will return error.
+
 	Default: SK_WMEM_MAX, (same as net.core.wmem_default).
+
 		Exact value depends on architecture and kernel options,
 		but should be enough to allow queuing 256 packets
 		of medium size.
@@ -132,11 +161,14 @@ neigh/default/unres_qlen_bytes - INTEGER
 neigh/default/unres_qlen - INTEGER
 	The maximum number of packets which may be queued for each
 	unresolved address by other network layers.
+
 	(deprecated in linux 3.3) : use unres_qlen_bytes instead.
+
 	Prior to linux 3.3, the default value is 3 which may cause
 	unexpected packet loss. The current default value is calculated
 	according to default value of unres_qlen_bytes and true size of
 	packet.
+
 	Default: 101
 
 mtu_expires - INTEGER
@@ -183,7 +215,8 @@ ipfrag_max_dist - INTEGER
 	from different IP datagrams, which could result in data corruption.
 	Default: 64
 
-INET peer storage:
+INET peer storage
+=================
 
 inet_peer_threshold - INTEGER
 	The approximate size of the storage.  Starting from this threshold
@@ -203,7 +236,8 @@ inet_peer_maxttl - INTEGER
 	when the number of entries in the pool is very small).
 	Measured in seconds.
 
-TCP variables:
+TCP variables
+=============
 
 somaxconn - INTEGER
 	Limit of socket listen() backlog, known in userspace as SOMAXCONN.
@@ -222,18 +256,22 @@ tcp_adv_win_scale - INTEGER
 	Count buffering overhead as bytes/2^tcp_adv_win_scale
 	(if tcp_adv_win_scale > 0) or bytes-bytes/2^(-tcp_adv_win_scale),
 	if it is <= 0.
+
 	Possible values are [-31, 31], inclusive.
+
 	Default: 1
 
 tcp_allowed_congestion_control - STRING
 	Show/set the congestion control choices available to non-privileged
 	processes. The list is a subset of those listed in
 	tcp_available_congestion_control.
+
 	Default is "reno" and the default setting (tcp_congestion_control).
 
 tcp_app_win - INTEGER
 	Reserve max(window/2^tcp_app_win, mss) of window for application
 	buffer. Value 0 is special, it means that nothing is reserved.
+
 	Default: 31
 
 tcp_autocorking - BOOLEAN
@@ -244,6 +282,7 @@ tcp_autocorking - BOOLEAN
 	packet for the flow is waiting in Qdisc queues or device transmit
 	queue. Applications can still use TCP_CORK for optimal behavior
 	when they know how/when to uncork their sockets.
+
 	Default : 1
 
 tcp_available_congestion_control - STRING
@@ -265,6 +304,7 @@ tcp_mtu_probe_floor - INTEGER
 tcp_min_snd_mss - INTEGER
 	TCP SYN and SYNACK messages usually advertise an ADVMSS option,
 	as described in RFC 1122 and RFC 6691.
+
 	If this ADVMSS option is smaller than tcp_min_snd_mss,
 	it is silently capped to tcp_min_snd_mss.
 
@@ -277,6 +317,7 @@ tcp_congestion_control - STRING
 	Default is set as part of kernel configuration.
 	For passive connections, the listener congestion control choice
 	is inherited.
+
 	[see setsockopt(listenfd, SOL_TCP, TCP_CONGESTION, "name" ...) ]
 
 tcp_dsack - BOOLEAN
@@ -286,9 +327,12 @@ tcp_early_retrans - INTEGER
 	Tail loss probe (TLP) converts RTOs occurring due to tail
 	losses into fast recovery (draft-ietf-tcpm-rack). Note that
 	TLP requires RACK to function properly (see tcp_recovery below)
+
 	Possible values:
-		0 disables TLP
-		3 or 4 enables TLP
+
+		- 0 disables TLP
+		- 3 or 4 enables TLP
+
 	Default: 3
 
 tcp_ecn - INTEGER
@@ -297,12 +341,17 @@ tcp_ecn - INTEGER
 	support for it.  This feature is useful in avoiding losses due
 	to congestion by allowing supporting routers to signal
 	congestion before having to drop packets.
+
 	Possible values are:
-		0 Disable ECN.  Neither initiate nor accept ECN.
-		1 Enable ECN when requested by incoming connections and
-		  also request ECN on outgoing connection attempts.
-		2 Enable ECN when requested by incoming connections
-		  but do not request ECN on outgoing connections.
+
+		=  =====================================================
+		0  Disable ECN.  Neither initiate nor accept ECN.
+		1  Enable ECN when requested by incoming connections and
+		   also request ECN on outgoing connection attempts.
+		2  Enable ECN when requested by incoming connections
+		   but do not request ECN on outgoing connections.
+		=  =====================================================
+
 	Default: 2
 
 tcp_ecn_fallback - BOOLEAN
@@ -312,6 +361,7 @@ tcp_ecn_fallback - BOOLEAN
 	additional detection mechanisms could be implemented under this
 	knob. The value	is not used, if tcp_ecn or per route (or congestion
 	control) ECN settings are disabled.
+
 	Default: 1 (fallback enabled)
 
 tcp_fack - BOOLEAN
@@ -324,7 +374,9 @@ tcp_fin_timeout - INTEGER
 	valid "receive only" state for an un-orphaned connection, an
 	orphaned connection in FIN_WAIT_2 state could otherwise wait
 	forever for the remote to close its end of the connection.
+
 	Cf. tcp_max_orphans
+
 	Default: 60 seconds
 
 tcp_frto - INTEGER
@@ -390,7 +442,8 @@ tcp_l3mdev_accept - BOOLEAN
 	derived from the listen socket to be bound to the L3 domain in
 	which the packets originated. Only valid when the kernel was
 	compiled with CONFIG_NET_L3_MASTER_DEV.
-        Default: 0 (disabled)
+
+	Default: 0 (disabled)
 
 tcp_low_latency - BOOLEAN
 	This is a legacy option, it has no effect anymore.
@@ -410,10 +463,14 @@ tcp_max_orphans - INTEGER
 tcp_max_syn_backlog - INTEGER
 	Maximal number of remembered connection requests (SYN_RECV),
 	which have not received an acknowledgment from connecting client.
+
 	This is a per-listener limit.
+
 	The minimal value is 128 for low memory machines, and it will
 	increase in proportion to the memory of machine.
+
 	If server suffers from overload, try increasing this number.
+
 	Remember to also check /proc/sys/net/core/somaxconn
 	A SYN_RECV request socket consumes about 304 bytes of memory.
 
@@ -445,7 +502,9 @@ tcp_min_rtt_wlen - INTEGER
 	minimum RTT when it is moved to a longer path (e.g., due to traffic
 	engineering). A longer window makes the filter more resistant to RTT
 	inflations such as transient congestion. The unit is seconds.
+
 	Possible values: 0 - 86400 (1 day)
+
 	Default: 300
 
 tcp_moderate_rcvbuf - BOOLEAN
@@ -457,9 +516,10 @@ tcp_moderate_rcvbuf - BOOLEAN
 tcp_mtu_probing - INTEGER
 	Controls TCP Packetization-Layer Path MTU Discovery.  Takes three
 	values:
-	  0 - Disabled
-	  1 - Disabled by default, enabled when an ICMP black hole detected
-	  2 - Always enabled, use initial MSS of tcp_base_mss.
+
+	- 0 - Disabled
+	- 1 - Disabled by default, enabled when an ICMP black hole detected
+	- 2 - Always enabled, use initial MSS of tcp_base_mss.
 
 tcp_probe_interval - UNSIGNED INTEGER
 	Controls how often to start TCP Packetization-Layer Path MTU
@@ -481,6 +541,7 @@ tcp_no_metrics_save - BOOLEAN
 
 tcp_no_ssthresh_metrics_save - BOOLEAN
 	Controls whether TCP saves ssthresh metrics in the route cache.
+
 	Default is 1, which disables ssthresh metrics.
 
 tcp_orphan_retries - INTEGER
@@ -489,6 +550,7 @@ tcp_orphan_retries - INTEGER
 	See tcp_retries2 for more details.
 
 	The default value is 8.
+
 	If your machine is a loaded WEB server,
 	you should think about lowering this value, such sockets
 	may consume significant resources. Cf. tcp_max_orphans.
@@ -497,11 +559,15 @@ tcp_recovery - INTEGER
 	This value is a bitmap to enable various experimental loss recovery
 	features.
 
-	RACK: 0x1 enables the RACK loss detection for fast detection of lost
-	      retransmissions and tail drops. It also subsumes and disables
-	      RFC6675 recovery for SACK connections.
-	RACK: 0x2 makes RACK's reordering window static (min_rtt/4).
-	RACK: 0x4 disables RACK's DUPACK threshold heuristic
+	=========   =============================================================
+	RACK: 0x1   enables the RACK loss detection for fast detection of lost
+		    retransmissions and tail drops. It also subsumes and disables
+		    RFC6675 recovery for SACK connections.
+
+	RACK: 0x2   makes RACK's reordering window static (min_rtt/4).
+
+	RACK: 0x4   disables RACK's DUPACK threshold heuristic
+	=========   =============================================================
 
 	Default: 0x1
 
@@ -509,12 +575,14 @@ tcp_reordering - INTEGER
 	Initial reordering level of packets in a TCP stream.
 	TCP stack can then dynamically adjust flow reordering level
 	between this initial value and tcp_max_reordering
+
 	Default: 3
 
 tcp_max_reordering - INTEGER
 	Maximal reordering level of packets in a TCP stream.
 	300 is a fairly conservative value, but you might increase it
 	if paths are using per packet load balancing (like bonding rr mode)
+
 	Default: 300
 
 tcp_retrans_collapse - BOOLEAN
@@ -550,12 +618,14 @@ tcp_rfc1337 - BOOLEAN
 	If set, the TCP stack behaves conforming to RFC1337. If unset,
 	we are not conforming to RFC, but prevent TCP TIME_WAIT
 	assassination.
+
 	Default: 0
 
 tcp_rmem - vector of 3 INTEGERs: min, default, max
 	min: Minimal size of receive buffer used by TCP sockets.
 	It is guaranteed to each TCP socket, even under moderate memory
 	pressure.
+
 	Default: 4K
 
 	default: initial size of receive buffer used by TCP sockets.
@@ -592,12 +662,14 @@ tcp_slow_start_after_idle - BOOLEAN
 	window after an idle period.  An idle period is defined at
 	the current RTO.  If unset, the congestion window will not
 	be timed out after an idle period.
+
 	Default: 1
 
 tcp_stdurg - BOOLEAN
 	Use the Host requirements interpretation of the TCP urgent pointer field.
 	Most hosts use the older BSD interpretation, so if you turn this on
 	Linux might not communicate correctly with them.
+
 	Default: FALSE
 
 tcp_synack_retries - INTEGER
@@ -646,15 +718,18 @@ tcp_fastopen - INTEGER
 	the option value being the length of the syn-data backlog.
 
 	The values (bitmap) are
-	  0x1: (client) enables sending data in the opening SYN on the client.
-	  0x2: (server) enables the server support, i.e., allowing data in
+
+	=====  ======== ======================================================
+	  0x1  (client) enables sending data in the opening SYN on the client.
+	  0x2  (server) enables the server support, i.e., allowing data in
 			a SYN packet to be accepted and passed to the
 			application before 3-way handshake finishes.
-	  0x4: (client) send data in the opening SYN regardless of cookie
+	  0x4  (client) send data in the opening SYN regardless of cookie
 			availability and without a cookie option.
-	0x200: (server) accept data-in-SYN w/o any cookie option present.
-	0x400: (server) enable all listeners to support Fast Open by
+	0x200  (server) accept data-in-SYN w/o any cookie option present.
+	0x400  (server) enable all listeners to support Fast Open by
 			default without explicit TCP_FASTOPEN socket option.
+	=====  ======== ======================================================
 
 	Default: 0x1
 
@@ -668,6 +743,7 @@ tcp_fastopen_blackhole_timeout_sec - INTEGER
 	get detected right after Fastopen is re-enabled and will reset to
 	initial value when the blackhole issue goes away.
 	0 to disable the blackhole detection.
+
 	By default, it is set to 1hr.
 
 tcp_fastopen_key - list of comma separated 32-digit hexadecimal INTEGERs
@@ -698,20 +774,24 @@ tcp_syn_retries - INTEGER
 	for an active TCP connection attempt will happen after 127seconds.
 
 tcp_timestamps - INTEGER
-Enable timestamps as defined in RFC1323.
-	0: Disabled.
-	1: Enable timestamps as defined in RFC1323 and use random offset for
-	each connection rather than only using the current time.
-	2: Like 1, but without random offsets.
+	Enable timestamps as defined in RFC1323.
+
+	- 0: Disabled.
+	- 1: Enable timestamps as defined in RFC1323 and use random offset for
+	  each connection rather than only using the current time.
+	- 2: Like 1, but without random offsets.
+
 	Default: 1
 
 tcp_min_tso_segs - INTEGER
 	Minimal number of segments per TSO frame.
+
 	Since linux-3.12, TCP does an automatic sizing of TSO frames,
 	depending on flow rate, instead of filling 64Kbytes packets.
 	For specific usages, it's possible to force TCP to build big
 	TSO frames. Note that TCP stack might split too big TSO packets
 	if available window is too small.
+
 	Default: 2
 
 tcp_pacing_ss_ratio - INTEGER
@@ -720,6 +800,7 @@ tcp_pacing_ss_ratio - INTEGER
 	If TCP is in slow start, tcp_pacing_ss_ratio is applied
 	to let TCP probe for bigger speeds, assuming cwnd can be
 	doubled every other RTT.
+
 	Default: 200
 
 tcp_pacing_ca_ratio - INTEGER
@@ -727,6 +808,7 @@ tcp_pacing_ca_ratio - INTEGER
 	to current rate. (current_rate = cwnd * mss / srtt)
 	If TCP is in congestion avoidance phase, tcp_pacing_ca_ratio
 	is applied to conservatively probe for bigger throughput.
+
 	Default: 120
 
 tcp_tso_win_divisor - INTEGER
@@ -734,16 +816,20 @@ tcp_tso_win_divisor - INTEGER
 	can be consumed by a single TSO frame.
 	The setting of this parameter is a choice between burstiness and
 	building larger TSO frames.
+
 	Default: 3
 
 tcp_tw_reuse - INTEGER
 	Enable reuse of TIME-WAIT sockets for new connections when it is
 	safe from protocol viewpoint.
-	0 - disable
-	1 - global enable
-	2 - enable for loopback traffic only
+
+	- 0 - disable
+	- 1 - global enable
+	- 2 - enable for loopback traffic only
+
 	It should not be changed without advice/request of technical
 	experts.
+
 	Default: 2
 
 tcp_window_scaling - BOOLEAN
@@ -752,11 +838,14 @@ tcp_window_scaling - BOOLEAN
 tcp_wmem - vector of 3 INTEGERs: min, default, max
 	min: Amount of memory reserved for send buffers for TCP sockets.
 	Each TCP socket has rights to use it due to fact of its birth.
+
 	Default: 4K
 
 	default: initial size of send buffer used by TCP sockets.  This
 	value overrides net.core.wmem_default used by other protocols.
+
 	It is usually lower than net.core.wmem_default.
+
 	Default: 16K
 
 	max: Maximal amount of memory allowed for automatically tuned
@@ -764,6 +853,7 @@ tcp_wmem - vector of 3 INTEGERs: min, default, max
 	net.core.wmem_max.  Calling setsockopt() with SO_SNDBUF disables
 	automatic tuning of that socket's send buffer size, in which case
 	this value is ignored.
+
 	Default: between 64K and 4MB, depending on RAM size.
 
 tcp_notsent_lowat - UNSIGNED INTEGER
@@ -784,6 +874,7 @@ tcp_workaround_signed_windows - BOOLEAN
 	remote TCP is broken and treats the window as a signed quantity.
 	If unset, assume the remote TCP is not broken even if we do
 	not receive a window scaling option from them.
+
 	Default: 0
 
 tcp_thin_linear_timeouts - BOOLEAN
@@ -796,6 +887,7 @@ tcp_thin_linear_timeouts - BOOLEAN
 	non-aggressive thin streams, often found to be time-dependent.
 	For more information on thin streams, see
 	Documentation/networking/tcp-thin.txt
+
 	Default: 0
 
 tcp_limit_output_bytes - INTEGER
@@ -807,6 +899,7 @@ tcp_limit_output_bytes - INTEGER
 	flows, for typical pfifo_fast qdiscs.  tcp_limit_output_bytes
 	limits the number of bytes on qdisc or device to reduce artificial
 	RTT/cwnd and reduce bufferbloat.
+
 	Default: 1048576 (16 * 65536)
 
 tcp_challenge_ack_limit - INTEGER
@@ -822,7 +915,8 @@ tcp_rx_skb_cache - BOOLEAN
 
 	Default: 0 (disabled)
 
-UDP variables:
+UDP variables
+=============
 
 udp_l3mdev_accept - BOOLEAN
 	Enabling this option allows a "global" bound socket to work
@@ -830,7 +924,8 @@ udp_l3mdev_accept - BOOLEAN
 	being received regardless of the L3 domain in which they
 	originated. Only valid when the kernel was compiled with
 	CONFIG_NET_L3_MASTER_DEV.
-        Default: 0 (disabled)
+
+	Default: 0 (disabled)
 
 udp_mem - vector of 3 INTEGERs: min, pressure, max
 	Number of pages allowed for queueing by all UDP sockets.
@@ -849,15 +944,18 @@ udp_rmem_min - INTEGER
 	Minimal size of receive buffer used by UDP sockets in moderation.
 	Each UDP socket is able to use the size for receiving data, even if
 	total pages of UDP sockets exceed udp_mem pressure. The unit is byte.
+
 	Default: 4K
 
 udp_wmem_min - INTEGER
 	Minimal size of send buffer used by UDP sockets in moderation.
 	Each UDP socket is able to use the size for sending data, even if
 	total pages of UDP sockets exceed udp_mem pressure. The unit is byte.
+
 	Default: 4K
 
-RAW variables:
+RAW variables
+=============
 
 raw_l3mdev_accept - BOOLEAN
 	Enabling this option allows a "global" bound socket to work
@@ -865,9 +963,11 @@ raw_l3mdev_accept - BOOLEAN
 	being received regardless of the L3 domain in which they
 	originated. Only valid when the kernel was compiled with
 	CONFIG_NET_L3_MASTER_DEV.
+
 	Default: 1 (enabled)
 
-CIPSOv4 Variables:
+CIPSOv4 Variables
+=================
 
 cipso_cache_enable - BOOLEAN
 	If set, enable additions to and lookups from the CIPSO label mapping
@@ -875,6 +975,7 @@ cipso_cache_enable - BOOLEAN
 	miss.  However, regardless of the setting the cache is still
 	invalidated when required when means you can safely toggle this on and
 	off and the cache will always be "safe".
+
 	Default: 1
 
 cipso_cache_bucket_size - INTEGER
@@ -884,6 +985,7 @@ cipso_cache_bucket_size - INTEGER
 	more CIPSO label mappings that can be cached.  When the number of
 	entries in a given hash bucket reaches this limit adding new entries
 	causes the oldest entry in the bucket to be removed to make room.
+
 	Default: 10
 
 cipso_rbm_optfmt - BOOLEAN
@@ -891,6 +993,7 @@ cipso_rbm_optfmt - BOOLEAN
 	the CIPSO draft specification (see Documentation/netlabel for details).
 	This means that when set the CIPSO tag will be padded with empty
 	categories in order to make the packet data 32-bit aligned.
+
 	Default: 0
 
 cipso_rbm_structvalid - BOOLEAN
@@ -900,9 +1003,11 @@ cipso_rbm_structvalid - BOOLEAN
 	where in the CIPSO processing code but setting this to 0 (False) should
 	result in less work (i.e. it should be faster) but could cause problems
 	with other implementations that require strict checking.
+
 	Default: 0
 
-IP Variables:
+IP Variables
+============
 
 ip_local_port_range - 2 INTEGERS
 	Defines the local port range that is used by TCP and UDP to
@@ -931,12 +1036,12 @@ ip_local_reserved_ports - list of comma separated ranges
 	assignments.
 
 	You can reserve ports which are not in the current
-	ip_local_port_range, e.g.:
+	ip_local_port_range, e.g.::
 
-	$ cat /proc/sys/net/ipv4/ip_local_port_range
-	32000	60999
-	$ cat /proc/sys/net/ipv4/ip_local_reserved_ports
-	8080,9148
+	    $ cat /proc/sys/net/ipv4/ip_local_port_range
+	    32000	60999
+	    $ cat /proc/sys/net/ipv4/ip_local_reserved_ports
+	    8080,9148
 
 	although this is redundant. However such a setting is useful
 	if later the port range is changed to a value that will
@@ -956,6 +1061,7 @@ ip_unprivileged_port_start - INTEGER
 ip_nonlocal_bind - BOOLEAN
 	If set, allows processes to bind() to non-local IP addresses,
 	which can be quite useful - but may break some applications.
+
 	Default: 0
 
 ip_autobind_reuse - BOOLEAN
@@ -972,6 +1078,7 @@ ip_dynaddr - BOOLEAN
 	If set to a non-zero value larger than 1, a kernel log
 	message will be printed when dynamic address rewriting
 	occurs.
+
 	Default: 0
 
 ip_early_demux - BOOLEAN
@@ -981,6 +1088,7 @@ ip_early_demux - BOOLEAN
 
 	It may add an additional cost for pure routing workloads that
 	reduces overall throughput, in such case you should disable it.
+
 	Default: 1
 
 ping_group_range - 2 INTEGERS
@@ -992,21 +1100,25 @@ ping_group_range - 2 INTEGERS
 
 tcp_early_demux - BOOLEAN
 	Enable early demux for established TCP sockets.
+
 	Default: 1
 
 udp_early_demux - BOOLEAN
 	Enable early demux for connected UDP sockets. Disable this if
 	your system could experience more unconnected load.
+
 	Default: 1
 
 icmp_echo_ignore_all - BOOLEAN
 	If set non-zero, then the kernel will ignore all ICMP ECHO
 	requests sent to it.
+
 	Default: 0
 
 icmp_echo_ignore_broadcasts - BOOLEAN
 	If set non-zero, then the kernel will ignore all ICMP ECHO and
 	TIMESTAMP requests sent to it via broadcast/multicast.
+
 	Default: 1
 
 icmp_ratelimit - INTEGER
@@ -1016,46 +1128,55 @@ icmp_ratelimit - INTEGER
 	otherwise the minimal space between responses in milliseconds.
 	Note that another sysctl, icmp_msgs_per_sec limits the number
 	of ICMP packets	sent on all targets.
+
 	Default: 1000
 
 icmp_msgs_per_sec - INTEGER
 	Limit maximal number of ICMP packets sent per second from this host.
 	Only messages whose type matches icmp_ratemask (see below) are
 	controlled by this limit.
+
 	Default: 1000
 
 icmp_msgs_burst - INTEGER
 	icmp_msgs_per_sec controls number of ICMP packets sent per second,
 	while icmp_msgs_burst controls the burst size of these packets.
+
 	Default: 50
 
 icmp_ratemask - INTEGER
 	Mask made of ICMP types for which rates are being limited.
+
 	Significant bits: IHGFEDCBA9876543210
+
 	Default mask:     0000001100000011000 (6168)
 
 	Bit definitions (see include/linux/icmp.h):
+
+		= =========================
 		0 Echo Reply
-		3 Destination Unreachable *
-		4 Source Quench *
+		3 Destination Unreachable [1]_
+		4 Source Quench [1]_
 		5 Redirect
 		8 Echo Request
-		B Time Exceeded *
-		C Parameter Problem *
+		B Time Exceeded [1]_
+		C Parameter Problem [1]_
 		D Timestamp Request
 		E Timestamp Reply
 		F Info Request
 		G Info Reply
 		H Address Mask Request
 		I Address Mask Reply
+		= =========================
 
-	* These are rate limited by default (see default mask above)
+	.. [1] These are rate limited by default (see default mask above)
 
 icmp_ignore_bogus_error_responses - BOOLEAN
 	Some routers violate RFC1122 by sending bogus responses to broadcast
 	frames.  Such violations are normally logged via a kernel warning.
 	If this is set to TRUE, the kernel will not give such warnings, which
 	will avoid log file clutter.
+
 	Default: 1
 
 icmp_errors_use_inbound_ifaddr - BOOLEAN
@@ -1100,32 +1221,39 @@ igmp_max_memberships - INTEGER
 igmp_max_msf - INTEGER
 	Maximum number of addresses allowed in the source filter list for a
 	multicast group.
+
 	Default: 10
 
 igmp_qrv - INTEGER
 	Controls the IGMP query robustness variable (see RFC2236 8.1).
+
 	Default: 2 (as specified by RFC2236 8.1)
+
 	Minimum: 1 (as specified by RFC6636 4.5)
 
 force_igmp_version - INTEGER
-	0 - (default) No enforcement of a IGMP version, IGMPv1/v2 fallback
-	    allowed. Will back to IGMPv3 mode again if all IGMPv1/v2 Querier
-	    Present timer expires.
-	1 - Enforce to use IGMP version 1. Will also reply IGMPv1 report if
-	    receive IGMPv2/v3 query.
-	2 - Enforce to use IGMP version 2. Will fallback to IGMPv1 if receive
-	    IGMPv1 query message. Will reply report if receive IGMPv3 query.
-	3 - Enforce to use IGMP version 3. The same react with default 0.
+	- 0 - (default) No enforcement of a IGMP version, IGMPv1/v2 fallback
+	  allowed. Will back to IGMPv3 mode again if all IGMPv1/v2 Querier
+	  Present timer expires.
+	- 1 - Enforce to use IGMP version 1. Will also reply IGMPv1 report if
+	  receive IGMPv2/v3 query.
+	- 2 - Enforce to use IGMP version 2. Will fallback to IGMPv1 if receive
+	  IGMPv1 query message. Will reply report if receive IGMPv3 query.
+	- 3 - Enforce to use IGMP version 3. The same react with default 0.
 
-	Note: this is not the same with force_mld_version because IGMPv3 RFC3376
-	Security Considerations does not have clear description that we could
-	ignore other version messages completely as MLDv2 RFC3810. So make
-	this value as default 0 is recommended.
+	.. note::
 
-conf/interface/*  changes special settings per interface (where
-"interface" is the name of your network interface)
+	   this is not the same with force_mld_version because IGMPv3 RFC3376
+	   Security Considerations does not have clear description that we could
+	   ignore other version messages completely as MLDv2 RFC3810. So make
+	   this value as default 0 is recommended.
 
-conf/all/*	  is special, changes the settings for all interfaces
+``conf/interface/*``
+	changes special settings per interface (where
+	interface" is the name of your network interface)
+
+``conf/all/*``
+	  is special, changes the settings for all interfaces
 
 log_martians - BOOLEAN
 	Log packets with impossible addresses to kernel log.
@@ -1136,14 +1264,21 @@ log_martians - BOOLEAN
 accept_redirects - BOOLEAN
 	Accept ICMP redirect messages.
 	accept_redirects for the interface will be enabled if:
+
 	- both conf/{all,interface}/accept_redirects are TRUE in the case
 	  forwarding for the interface is enabled
+
 	or
+
 	- at least one of conf/{all,interface}/accept_redirects is TRUE in the
 	  case forwarding for the interface is disabled
+
 	accept_redirects for the interface will be disabled otherwise
-	default TRUE (host)
-		FALSE (router)
+
+	default:
+
+		- TRUE (host)
+		- FALSE (router)
 
 forwarding - BOOLEAN
 	Enable IP forwarding on this interface.  This controls whether packets
@@ -1168,12 +1303,14 @@ medium_id - INTEGER
 
 proxy_arp - BOOLEAN
 	Do proxy arp.
+
 	proxy_arp for the interface will be enabled if at least one of
 	conf/{all,interface}/proxy_arp is set to TRUE,
 	it will be disabled otherwise
 
 proxy_arp_pvlan - BOOLEAN
 	Private VLAN proxy arp.
+
 	Basically allow proxy arp replies back to the same interface
 	(from which the ARP request/solicitation was received).
 
@@ -1186,6 +1323,7 @@ proxy_arp_pvlan - BOOLEAN
 	proxy_arp.
 
 	This technology is known by different names:
+
 	  In RFC 3069 it is called VLAN Aggregation.
 	  Cisco and Allied Telesyn call it Private VLAN.
 	  Hewlett-Packard call it Source-Port filtering or port-isolation.
@@ -1194,26 +1332,33 @@ proxy_arp_pvlan - BOOLEAN
 shared_media - BOOLEAN
 	Send(router) or accept(host) RFC1620 shared media redirects.
 	Overrides secure_redirects.
+
 	shared_media for the interface will be enabled if at least one of
 	conf/{all,interface}/shared_media is set to TRUE,
 	it will be disabled otherwise
+
 	default TRUE
 
 secure_redirects - BOOLEAN
 	Accept ICMP redirect messages only to gateways listed in the
 	interface's current gateway list. Even if disabled, RFC1122 redirect
 	rules still apply.
+
 	Overridden by shared_media.
+
 	secure_redirects for the interface will be enabled if at least one of
 	conf/{all,interface}/secure_redirects is set to TRUE,
 	it will be disabled otherwise
+
 	default TRUE
 
 send_redirects - BOOLEAN
 	Send redirects, if router.
+
 	send_redirects for the interface will be enabled if at least one of
 	conf/{all,interface}/send_redirects is set to TRUE,
 	it will be disabled otherwise
+
 	Default: TRUE
 
 bootp_relay - BOOLEAN
@@ -1222,15 +1367,20 @@ bootp_relay - BOOLEAN
 	BOOTP relay daemon will catch and forward such packets.
 	conf/all/bootp_relay must also be set to TRUE to enable BOOTP relay
 	for the interface
+
 	default FALSE
+
 	Not Implemented Yet.
 
 accept_source_route - BOOLEAN
 	Accept packets with SRR option.
 	conf/all/accept_source_route must also be set to TRUE to accept packets
 	with SRR option on the interface
-	default TRUE (router)
-		FALSE (host)
+
+	default
+
+		- TRUE (router)
+		- FALSE (host)
 
 accept_local - BOOLEAN
 	Accept packets with local source addresses. In combination with
@@ -1241,18 +1391,19 @@ accept_local - BOOLEAN
 route_localnet - BOOLEAN
 	Do not consider loopback addresses as martian source or destination
 	while routing. This enables the use of 127/8 for local routing purposes.
+
 	default FALSE
 
 rp_filter - INTEGER
-	0 - No source validation.
-	1 - Strict mode as defined in RFC3704 Strict Reverse Path
-	    Each incoming packet is tested against the FIB and if the interface
-	    is not the best reverse path the packet check will fail.
-	    By default failed packets are discarded.
-	2 - Loose mode as defined in RFC3704 Loose Reverse Path
-	    Each incoming packet's source address is also tested against the FIB
-	    and if the source address is not reachable via any interface
-	    the packet check will fail.
+	- 0 - No source validation.
+	- 1 - Strict mode as defined in RFC3704 Strict Reverse Path
+	  Each incoming packet is tested against the FIB and if the interface
+	  is not the best reverse path the packet check will fail.
+	  By default failed packets are discarded.
+	- 2 - Loose mode as defined in RFC3704 Loose Reverse Path
+	  Each incoming packet's source address is also tested against the FIB
+	  and if the source address is not reachable via any interface
+	  the packet check will fail.
 
 	Current recommended practice in RFC3704 is to enable strict mode
 	to prevent IP spoofing from DDos attacks. If using asymmetric routing
@@ -1265,19 +1416,19 @@ rp_filter - INTEGER
 	in startup scripts.
 
 arp_filter - BOOLEAN
-	1 - Allows you to have multiple network interfaces on the same
-	subnet, and have the ARPs for each interface be answered
-	based on whether or not the kernel would route a packet from
-	the ARP'd IP out that interface (therefore you must use source
-	based routing for this to work). In other words it allows control
-	of which cards (usually 1) will respond to an arp request.
+	- 1 - Allows you to have multiple network interfaces on the same
+	  subnet, and have the ARPs for each interface be answered
+	  based on whether or not the kernel would route a packet from
+	  the ARP'd IP out that interface (therefore you must use source
+	  based routing for this to work). In other words it allows control
+	  of which cards (usually 1) will respond to an arp request.
 
-	0 - (default) The kernel can respond to arp requests with addresses
-	from other interfaces. This may seem wrong but it usually makes
-	sense, because it increases the chance of successful communication.
-	IP addresses are owned by the complete host on Linux, not by
-	particular interfaces. Only for more complex setups like load-
-	balancing, does this behaviour cause problems.
+	- 0 - (default) The kernel can respond to arp requests with addresses
+	  from other interfaces. This may seem wrong but it usually makes
+	  sense, because it increases the chance of successful communication.
+	  IP addresses are owned by the complete host on Linux, not by
+	  particular interfaces. Only for more complex setups like load-
+	  balancing, does this behaviour cause problems.
 
 	arp_filter for the interface will be enabled if at least one of
 	conf/{all,interface}/arp_filter is set to TRUE,
@@ -1287,26 +1438,27 @@ arp_announce - INTEGER
 	Define different restriction levels for announcing the local
 	source IP address from IP packets in ARP requests sent on
 	interface:
-	0 - (default) Use any local address, configured on any interface
-	1 - Try to avoid local addresses that are not in the target's
-	subnet for this interface. This mode is useful when target
-	hosts reachable via this interface require the source IP
-	address in ARP requests to be part of their logical network
-	configured on the receiving interface. When we generate the
-	request we will check all our subnets that include the
-	target IP and will preserve the source address if it is from
-	such subnet. If there is no such subnet we select source
-	address according to the rules for level 2.
-	2 - Always use the best local address for this target.
-	In this mode we ignore the source address in the IP packet
-	and try to select local address that we prefer for talks with
-	the target host. Such local address is selected by looking
-	for primary IP addresses on all our subnets on the outgoing
-	interface that include the target IP address. If no suitable
-	local address is found we select the first local address
-	we have on the outgoing interface or on all other interfaces,
-	with the hope we will receive reply for our request and
-	even sometimes no matter the source IP address we announce.
+
+	- 0 - (default) Use any local address, configured on any interface
+	- 1 - Try to avoid local addresses that are not in the target's
+	  subnet for this interface. This mode is useful when target
+	  hosts reachable via this interface require the source IP
+	  address in ARP requests to be part of their logical network
+	  configured on the receiving interface. When we generate the
+	  request we will check all our subnets that include the
+	  target IP and will preserve the source address if it is from
+	  such subnet. If there is no such subnet we select source
+	  address according to the rules for level 2.
+	- 2 - Always use the best local address for this target.
+	  In this mode we ignore the source address in the IP packet
+	  and try to select local address that we prefer for talks with
+	  the target host. Such local address is selected by looking
+	  for primary IP addresses on all our subnets on the outgoing
+	  interface that include the target IP address. If no suitable
+	  local address is found we select the first local address
+	  we have on the outgoing interface or on all other interfaces,
+	  with the hope we will receive reply for our request and
+	  even sometimes no matter the source IP address we announce.
 
 	The max value from conf/{all,interface}/arp_announce is used.
 
@@ -1317,32 +1469,37 @@ arp_announce - INTEGER
 arp_ignore - INTEGER
 	Define different modes for sending replies in response to
 	received ARP requests that resolve local target IP addresses:
-	0 - (default): reply for any local target IP address, configured
-	on any interface
-	1 - reply only if the target IP address is local address
-	configured on the incoming interface
-	2 - reply only if the target IP address is local address
-	configured on the incoming interface and both with the
-	sender's IP address are part from same subnet on this interface
-	3 - do not reply for local addresses configured with scope host,
-	only resolutions for global and link addresses are replied
-	4-7 - reserved
-	8 - do not reply for all local addresses
+
+	- 0 - (default): reply for any local target IP address, configured
+	  on any interface
+	- 1 - reply only if the target IP address is local address
+	  configured on the incoming interface
+	- 2 - reply only if the target IP address is local address
+	  configured on the incoming interface and both with the
+	  sender's IP address are part from same subnet on this interface
+	- 3 - do not reply for local addresses configured with scope host,
+	  only resolutions for global and link addresses are replied
+	- 4-7 - reserved
+	- 8 - do not reply for all local addresses
 
 	The max value from conf/{all,interface}/arp_ignore is used
 	when ARP request is received on the {interface}
 
 arp_notify - BOOLEAN
 	Define mode for notification of address and device changes.
-	0 - (default): do nothing
-	1 - Generate gratuitous arp requests when device is brought up
-	    or hardware address changes.
+
+	 ==  ==========================================================
+	  0  (default): do nothing
+	  1  Generate gratuitous arp requests when device is brought up
+	     or hardware address changes.
+	 ==  ==========================================================
 
 arp_accept - BOOLEAN
 	Define behavior for gratuitous ARP frames who's IP is not
 	already present in the ARP table:
-	0 - don't create new entries in the ARP table
-	1 - create new entries in the ARP table
+
+	- 0 - don't create new entries in the ARP table
+	- 1 - create new entries in the ARP table
 
 	Both replies and requests type gratuitous arp will trigger the
 	ARP table to be updated, if this setting is on.
@@ -1378,11 +1535,13 @@ disable_xfrm - BOOLEAN
 igmpv2_unsolicited_report_interval - INTEGER
 	The interval in milliseconds in which the next unsolicited
 	IGMPv1 or IGMPv2 report retransmit will take place.
+
 	Default: 10000 (10 seconds)
 
 igmpv3_unsolicited_report_interval - INTEGER
 	The interval in milliseconds in which the next unsolicited
 	IGMPv3 report retransmit will take place.
+
 	Default: 1000 (1 seconds)
 
 promote_secondaries - BOOLEAN
@@ -1393,19 +1552,23 @@ promote_secondaries - BOOLEAN
 drop_unicast_in_l2_multicast - BOOLEAN
 	Drop any unicast IP packets that are received in link-layer
 	multicast (or broadcast) frames.
+
 	This behavior (for multicast) is actually a SHOULD in RFC
 	1122, but is disabled by default for compatibility reasons.
+
 	Default: off (0)
 
 drop_gratuitous_arp - BOOLEAN
 	Drop all gratuitous ARP frames, for example if there's a known
 	good ARP proxy on the network and such frames need not be used
 	(or in the case of 802.11, must not be used to prevent attacks.)
+
 	Default: off (0)
 
 
 tag - INTEGER
 	Allows you to write a number, which can be used as required.
+
 	Default value is 0.
 
 xfrm4_gc_thresh - INTEGER
@@ -1417,21 +1580,24 @@ xfrm4_gc_thresh - INTEGER
 igmp_link_local_mcast_reports - BOOLEAN
 	Enable IGMP reports for link local multicast groups in the
 	224.0.0.X range.
+
 	Default TRUE
 
 Alexey Kuznetsov.
 kuznet@ms2.inr.ac.ru
 
 Updated by:
-Andi Kleen
-ak@muc.de
-Nicolas Delon
-delon.nicolas@wanadoo.fr
 
+- Andi Kleen
+  ak@muc.de
+- Nicolas Delon
+  delon.nicolas@wanadoo.fr
 
 
 
-/proc/sys/net/ipv6/* Variables:
+
+/proc/sys/net/ipv6/* Variables
+==============================
 
 IPv6 has no global variables such as tcp_*.  tcp_* settings under ipv4/ also
 apply to IPv6 [XXX?].
@@ -1440,8 +1606,9 @@ bindv6only - BOOLEAN
 	Default value for IPV6_V6ONLY socket option,
 	which restricts use of the IPv6 socket to IPv6 communication
 	only.
-		TRUE: disable IPv4-mapped address feature
-		FALSE: enable IPv4-mapped address feature
+
+		- TRUE: disable IPv4-mapped address feature
+		- FALSE: enable IPv4-mapped address feature
 
 	Default: FALSE (as specified in RFC3493)
 
@@ -1449,8 +1616,10 @@ flowlabel_consistency - BOOLEAN
 	Protect the consistency (and unicity) of flow label.
 	You have to disable it to use IPV6_FL_F_REFLECT flag on the
 	flow label manager.
-	TRUE: enabled
-	FALSE: disabled
+
+	- TRUE: enabled
+	- FALSE: disabled
+
 	Default: TRUE
 
 auto_flowlabels - INTEGER
@@ -1458,22 +1627,28 @@ auto_flowlabels - INTEGER
 	packet. This allows intermediate devices, such as routers, to
 	identify packet flows for mechanisms like Equal Cost Multipath
 	Routing (see RFC 6438).
-	0: automatic flow labels are completely disabled
-	1: automatic flow labels are enabled by default, they can be
+
+	=  ===========================================================
+	0  automatic flow labels are completely disabled
+	1  automatic flow labels are enabled by default, they can be
 	   disabled on a per socket basis using the IPV6_AUTOFLOWLABEL
 	   socket option
-	2: automatic flow labels are allowed, they may be enabled on a
+	2  automatic flow labels are allowed, they may be enabled on a
 	   per socket basis using the IPV6_AUTOFLOWLABEL socket option
-	3: automatic flow labels are enabled and enforced, they cannot
+	3  automatic flow labels are enabled and enforced, they cannot
 	   be disabled by the socket option
+	=  ===========================================================
+
 	Default: 1
 
 flowlabel_state_ranges - BOOLEAN
 	Split the flow label number space into two ranges. 0-0x7FFFF is
 	reserved for the IPv6 flow manager facility, 0x80000-0xFFFFF
 	is reserved for stateless flow labels as described in RFC6437.
-	TRUE: enabled
-	FALSE: disabled
+
+	- TRUE: enabled
+	- FALSE: disabled
+
 	Default: true
 
 flowlabel_reflect - INTEGER
@@ -1483,49 +1658,59 @@ flowlabel_reflect - INTEGER
 	https://tools.ietf.org/html/draft-wang-6man-flow-label-reflection-01
 
 	This is a bitmask.
-	1: enabled for established flows
 
-	Note that this prevents automatic flowlabel changes, as done
-	in "tcp: change IPv6 flow-label upon receiving spurious retransmission"
-	and "tcp: Change txhash on every SYN and RTO retransmit"
+	- 1: enabled for established flows
 
-	2: enabled for TCP RESET packets (no active listener)
-	If set, a RST packet sent in response to a SYN packet on a closed
-	port will reflect the incoming flow label.
+	  Note that this prevents automatic flowlabel changes, as done
+	  in "tcp: change IPv6 flow-label upon receiving spurious retransmission"
+	  and "tcp: Change txhash on every SYN and RTO retransmit"
 
-	4: enabled for ICMPv6 echo reply messages.
+	- 2: enabled for TCP RESET packets (no active listener)
+	  If set, a RST packet sent in response to a SYN packet on a closed
+	  port will reflect the incoming flow label.
+
+	- 4: enabled for ICMPv6 echo reply messages.
 
 	Default: 0
 
 fib_multipath_hash_policy - INTEGER
 	Controls which hash policy to use for multipath routes.
+
 	Default: 0 (Layer 3)
+
 	Possible values:
-	0 - Layer 3 (source and destination addresses plus flow label)
-	1 - Layer 4 (standard 5-tuple)
-	2 - Layer 3 or inner Layer 3 if present
+
+	- 0 - Layer 3 (source and destination addresses plus flow label)
+	- 1 - Layer 4 (standard 5-tuple)
+	- 2 - Layer 3 or inner Layer 3 if present
 
 anycast_src_echo_reply - BOOLEAN
 	Controls the use of anycast addresses as source addresses for ICMPv6
 	echo reply
-	TRUE:  enabled
-	FALSE: disabled
+
+	- TRUE:  enabled
+	- FALSE: disabled
+
 	Default: FALSE
 
 idgen_delay - INTEGER
 	Controls the delay in seconds after which time to retry
 	privacy stable address generation if a DAD conflict is
 	detected.
+
 	Default: 1 (as specified in RFC7217)
 
 idgen_retries - INTEGER
 	Controls the number of retries to generate a stable privacy
 	address if a DAD conflict is detected.
+
 	Default: 3 (as specified in RFC7217)
 
 mld_qrv - INTEGER
 	Controls the MLD query robustness variable (see RFC3810 9.1).
+
 	Default: 2 (as specified by RFC3810 9.1)
+
 	Minimum: 1 (as specified by RFC6636 4.5)
 
 max_dst_opts_number - INTEGER
@@ -1533,6 +1718,7 @@ max_dst_opts_number - INTEGER
 	options extension header. If this value is less than zero
 	then unknown options are disallowed and the number of known
 	TLVs allowed is the absolute value of this number.
+
 	Default: 8
 
 max_hbh_opts_number - INTEGER
@@ -1540,16 +1726,19 @@ max_hbh_opts_number - INTEGER
 	options extension header. If this value is less than zero
 	then unknown options are disallowed and the number of known
 	TLVs allowed is the absolute value of this number.
+
 	Default: 8
 
 max_dst_opts_length - INTEGER
 	Maximum length allowed for a Destination options extension
 	header.
+
 	Default: INT_MAX (unlimited)
 
 max_hbh_length - INTEGER
 	Maximum length allowed for a Hop-by-Hop options extension
 	header.
+
 	Default: INT_MAX (unlimited)
 
 skip_notify_on_dev_down - BOOLEAN
@@ -1558,6 +1747,7 @@ skip_notify_on_dev_down - BOOLEAN
 	generate this message; IPv6 does by default. Setting this sysctl
 	to true skips the message, making IPv4 and IPv6 on par in relying
 	on userspace caches to track link events and evict routes.
+
 	Default: false (generate message)
 
 IPv6 Fragmentation:
@@ -1580,18 +1770,20 @@ seg6_flowlabel - INTEGER
 	Controls the behaviour of computing the flowlabel of outer
 	IPv6 header in case of SR T.encaps
 
-	-1 set flowlabel to zero.
-	0 copy flowlabel from Inner packet in case of Inner IPv6
-		(Set flowlabel to 0 in case IPv4/L2)
-	1 Compute the flowlabel using seg6_make_flowlabel()
+	 == =======================================================
+	 -1  set flowlabel to zero.
+	  0  copy flowlabel from Inner packet in case of Inner IPv6
+	     (Set flowlabel to 0 in case IPv4/L2)
+	  1  Compute the flowlabel using seg6_make_flowlabel()
+	 == =======================================================
 
 	Default is 0.
 
-conf/default/*:
+``conf/default/*``:
 	Change the interface-specific default settings.
 
 
-conf/all/*:
+``conf/all/*``:
 	Change all the interface-specific settings.
 
 	[XXX:  Other special features than forwarding?]
@@ -1615,9 +1807,10 @@ fwmark_reflect - BOOLEAN
 	associated with a socket for example, TCP RSTs or ICMPv6 echo replies).
 	If unset, these packets have a fwmark of zero. If set, they have the
 	fwmark of the packet they are replying to.
+
 	Default: 0
 
-conf/interface/*:
+``conf/interface/*``:
 	Change special settings per interface.
 
 	The functional behaviour for certain settings is different
@@ -1632,31 +1825,40 @@ accept_ra - INTEGER
 	transmitted.
 
 	Possible values are:
-		0 Do not accept Router Advertisements.
-		1 Accept Router Advertisements if forwarding is disabled.
-		2 Overrule forwarding behaviour. Accept Router Advertisements
-		  even if forwarding is enabled.
 
-	Functional default: enabled if local forwarding is disabled.
-			    disabled if local forwarding is enabled.
+		==  ===========================================================
+		 0  Do not accept Router Advertisements.
+		 1  Accept Router Advertisements if forwarding is disabled.
+		 2  Overrule forwarding behaviour. Accept Router Advertisements
+		    even if forwarding is enabled.
+		==  ===========================================================
+
+	Functional default:
+
+		- enabled if local forwarding is disabled.
+		- disabled if local forwarding is enabled.
 
 accept_ra_defrtr - BOOLEAN
 	Learn default router in Router Advertisement.
 
-	Functional default: enabled if accept_ra is enabled.
-			    disabled if accept_ra is disabled.
+	Functional default:
+
+		- enabled if accept_ra is enabled.
+		- disabled if accept_ra is disabled.
 
 accept_ra_from_local - BOOLEAN
 	Accept RA with source-address that is found on local machine
-        if the RA is otherwise proper and able to be accepted.
-        Default is to NOT accept these as it may be an un-intended
-        network loop.
+	if the RA is otherwise proper and able to be accepted.
+
+	Default is to NOT accept these as it may be an un-intended
+	network loop.
 
 	Functional default:
-           enabled if accept_ra_from_local is enabled
-               on a specific interface.
-	   disabled if accept_ra_from_local is disabled
-               on a specific interface.
+
+	   - enabled if accept_ra_from_local is enabled
+	     on a specific interface.
+	   - disabled if accept_ra_from_local is disabled
+	     on a specific interface.
 
 accept_ra_min_hop_limit - INTEGER
 	Minimum hop limit Information in Router Advertisement.
@@ -1669,8 +1871,10 @@ accept_ra_min_hop_limit - INTEGER
 accept_ra_pinfo - BOOLEAN
 	Learn Prefix Information in Router Advertisement.
 
-	Functional default: enabled if accept_ra is enabled.
-			    disabled if accept_ra is disabled.
+	Functional default:
+
+		- enabled if accept_ra is enabled.
+		- disabled if accept_ra is disabled.
 
 accept_ra_rt_info_min_plen - INTEGER
 	Minimum prefix length of Route Information in RA.
@@ -1678,8 +1882,10 @@ accept_ra_rt_info_min_plen - INTEGER
 	Route Information w/ prefix smaller than this variable shall
 	be ignored.
 
-	Functional default: 0 if accept_ra_rtr_pref is enabled.
-			    -1 if accept_ra_rtr_pref is disabled.
+	Functional default:
+
+		* 0 if accept_ra_rtr_pref is enabled.
+		* -1 if accept_ra_rtr_pref is disabled.
 
 accept_ra_rt_info_max_plen - INTEGER
 	Maximum prefix length of Route Information in RA.
@@ -1687,33 +1893,41 @@ accept_ra_rt_info_max_plen - INTEGER
 	Route Information w/ prefix larger than this variable shall
 	be ignored.
 
-	Functional default: 0 if accept_ra_rtr_pref is enabled.
-			    -1 if accept_ra_rtr_pref is disabled.
+	Functional default:
+
+		* 0 if accept_ra_rtr_pref is enabled.
+		* -1 if accept_ra_rtr_pref is disabled.
 
 accept_ra_rtr_pref - BOOLEAN
 	Accept Router Preference in RA.
 
-	Functional default: enabled if accept_ra is enabled.
-			    disabled if accept_ra is disabled.
+	Functional default:
+
+		- enabled if accept_ra is enabled.
+		- disabled if accept_ra is disabled.
 
 accept_ra_mtu - BOOLEAN
 	Apply the MTU value specified in RA option 5 (RFC4861). If
 	disabled, the MTU specified in the RA will be ignored.
 
-	Functional default: enabled if accept_ra is enabled.
-			    disabled if accept_ra is disabled.
+	Functional default:
+
+		- enabled if accept_ra is enabled.
+		- disabled if accept_ra is disabled.
 
 accept_redirects - BOOLEAN
 	Accept Redirects.
 
-	Functional default: enabled if local forwarding is disabled.
-			    disabled if local forwarding is enabled.
+	Functional default:
+
+		- enabled if local forwarding is disabled.
+		- disabled if local forwarding is enabled.
 
 accept_source_route - INTEGER
 	Accept source routing (routing extension header).
 
-	>= 0: Accept only routing header type 2.
-	< 0: Do not accept routing header.
+	- >= 0: Accept only routing header type 2.
+	- < 0: Do not accept routing header.
 
 	Default: 0
 
@@ -1721,24 +1935,30 @@ autoconf - BOOLEAN
 	Autoconfigure addresses using Prefix Information in Router
 	Advertisements.
 
-	Functional default: enabled if accept_ra_pinfo is enabled.
-			    disabled if accept_ra_pinfo is disabled.
+	Functional default:
+
+		- enabled if accept_ra_pinfo is enabled.
+		- disabled if accept_ra_pinfo is disabled.
 
 dad_transmits - INTEGER
 	The amount of Duplicate Address Detection probes to send.
+
 	Default: 1
 
 forwarding - INTEGER
 	Configure interface-specific Host/Router behaviour.
 
-	Note: It is recommended to have the same setting on all
-	interfaces; mixed router/host scenarios are rather uncommon.
+	.. note::
+
+	   It is recommended to have the same setting on all
+	   interfaces; mixed router/host scenarios are rather uncommon.
 
 	Possible values are:
-		0 Forwarding disabled
-		1 Forwarding enabled
 
-	FALSE (0):
+		- 0 Forwarding disabled
+		- 1 Forwarding enabled
+
+	**FALSE (0)**:
 
 	By default, Host behaviour is assumed.  This means:
 
@@ -1749,7 +1969,7 @@ forwarding - INTEGER
 	   Advertisements (and do autoconfiguration).
 	4. If accept_redirects is TRUE (default), accept Redirects.
 
-	TRUE (1):
+	**TRUE (1)**:
 
 	If local forwarding is enabled, Router behaviour is assumed.
 	This means exactly the reverse from the above:
@@ -1760,19 +1980,22 @@ forwarding - INTEGER
 	4. Redirects are ignored.
 
 	Default: 0 (disabled) if global forwarding is disabled (default),
-		 otherwise 1 (enabled).
+	otherwise 1 (enabled).
 
 hop_limit - INTEGER
 	Default Hop Limit to set.
+
 	Default: 64
 
 mtu - INTEGER
 	Default Maximum Transfer Unit
+
 	Default: 1280 (IPv6 required minimum)
 
 ip_nonlocal_bind - BOOLEAN
 	If set, allows processes to bind() to non-local IPv6 addresses,
 	which can be quite useful - but may break some applications.
+
 	Default: 0
 
 router_probe_interval - INTEGER
@@ -1784,15 +2007,18 @@ router_probe_interval - INTEGER
 router_solicitation_delay - INTEGER
 	Number of seconds to wait after interface is brought up
 	before sending Router Solicitations.
+
 	Default: 1
 
 router_solicitation_interval - INTEGER
 	Number of seconds to wait between Router Solicitations.
+
 	Default: 4
 
 router_solicitations - INTEGER
 	Number of Router Solicitations to send until assuming no
 	routers are present.
+
 	Default: 3
 
 use_oif_addrs_only - BOOLEAN
@@ -1804,28 +2030,35 @@ use_oif_addrs_only - BOOLEAN
 
 use_tempaddr - INTEGER
 	Preference for Privacy Extensions (RFC3041).
-	  <= 0 : disable Privacy Extensions
-	  == 1 : enable Privacy Extensions, but prefer public
-	         addresses over temporary addresses.
-	  >  1 : enable Privacy Extensions and prefer temporary
-	         addresses over public addresses.
-	Default:  0 (for most devices)
-		 -1 (for point-to-point devices and loopback devices)
+
+	  * <= 0 : disable Privacy Extensions
+	  * == 1 : enable Privacy Extensions, but prefer public
+	    addresses over temporary addresses.
+	  * >  1 : enable Privacy Extensions and prefer temporary
+	    addresses over public addresses.
+
+	Default:
+
+		* 0 (for most devices)
+		* -1 (for point-to-point devices and loopback devices)
 
 temp_valid_lft - INTEGER
 	valid lifetime (in seconds) for temporary addresses.
+
 	Default: 604800 (7 days)
 
 temp_prefered_lft - INTEGER
 	Preferred lifetime (in seconds) for temporary addresses.
+
 	Default: 86400 (1 day)
 
 keep_addr_on_down - INTEGER
 	Keep all IPv6 addresses on an interface down event. If set static
 	global addresses with no expiration time are not flushed.
-	  >0 : enabled
-	   0 : system default
-	  <0 : disabled
+
+	*   >0 : enabled
+	*    0 : system default
+	*   <0 : disabled
 
 	Default: 0 (addresses are removed)
 
@@ -1834,11 +2067,13 @@ max_desync_factor - INTEGER
 	that ensures that clients don't synchronize with each
 	other and generate new addresses at exactly the same time.
 	value is in seconds.
+
 	Default: 600
 
 regen_max_retry - INTEGER
 	Number of attempts before give up attempting to generate
 	valid temporary addresses.
+
 	Default: 5
 
 max_addresses - INTEGER
@@ -1846,12 +2081,14 @@ max_addresses - INTEGER
 	to zero disables the limitation.  It is not recommended to set this
 	value too large (or to zero) because it would be an easy way to
 	crash the kernel by allowing too many addresses to be created.
+
 	Default: 16
 
 disable_ipv6 - BOOLEAN
 	Disable IPv6 operation.  If accept_dad is set to 2, this value
 	will be dynamically set to TRUE if DAD fails for the link-local
 	address.
+
 	Default: FALSE (enable IPv6 operation)
 
 	When this value is changed from 1 to 0 (IPv6 is being enabled),
@@ -1865,10 +2102,13 @@ disable_ipv6 - BOOLEAN
 
 accept_dad - INTEGER
 	Whether to accept DAD (Duplicate Address Detection).
-	0: Disable DAD
-	1: Enable DAD (default)
-	2: Enable DAD, and disable IPv6 operation if MAC-based duplicate
-	   link-local address has been found.
+
+	 == ==============================================================
+	  0  Disable DAD
+	  1  Enable DAD (default)
+	  2  Enable DAD, and disable IPv6 operation if MAC-based duplicate
+	     link-local address has been found.
+	 == ==============================================================
 
 	DAD operation and mode on a given interface will be selected according
 	to the maximum value of conf/{all,interface}/accept_dad.
@@ -1876,6 +2116,7 @@ accept_dad - INTEGER
 force_tllao - BOOLEAN
 	Enable sending the target link-layer address option even when
 	responding to a unicast neighbor solicitation.
+
 	Default: FALSE
 
 	Quoting from RFC 2461, section 4.4, Target link-layer address:
@@ -1893,9 +2134,10 @@ force_tllao - BOOLEAN
 
 ndisc_notify - BOOLEAN
 	Define mode for notification of address and device changes.
-	0 - (default): do nothing
-	1 - Generate unsolicited neighbour advertisements when device is brought
-	    up or hardware address changes.
+
+	* 0 - (default): do nothing
+	* 1 - Generate unsolicited neighbour advertisements when device is brought
+	  up or hardware address changes.
 
 ndisc_tclass - INTEGER
 	The IPv6 Traffic Class to use by default when sending IPv6 Neighbor
@@ -1904,33 +2146,38 @@ ndisc_tclass - INTEGER
 	These 8 bits can be interpreted as 6 high order bits holding the DSCP
 	value and 2 low order bits representing ECN (which you probably want
 	to leave cleared).
-	0 - (default)
+
+	* 0 - (default)
 
 mldv1_unsolicited_report_interval - INTEGER
 	The interval in milliseconds in which the next unsolicited
 	MLDv1 report retransmit will take place.
+
 	Default: 10000 (10 seconds)
 
 mldv2_unsolicited_report_interval - INTEGER
 	The interval in milliseconds in which the next unsolicited
 	MLDv2 report retransmit will take place.
+
 	Default: 1000 (1 second)
 
 force_mld_version - INTEGER
-	0 - (default) No enforcement of a MLD version, MLDv1 fallback allowed
-	1 - Enforce to use MLD version 1
-	2 - Enforce to use MLD version 2
+	* 0 - (default) No enforcement of a MLD version, MLDv1 fallback allowed
+	* 1 - Enforce to use MLD version 1
+	* 2 - Enforce to use MLD version 2
 
 suppress_frag_ndisc - INTEGER
 	Control RFC 6980 (Security Implications of IPv6 Fragmentation
 	with IPv6 Neighbor Discovery) behavior:
-	1 - (default) discard fragmented neighbor discovery packets
-	0 - allow fragmented neighbor discovery packets
+
+	* 1 - (default) discard fragmented neighbor discovery packets
+	* 0 - allow fragmented neighbor discovery packets
 
 optimistic_dad - BOOLEAN
 	Whether to perform Optimistic Duplicate Address Detection (RFC 4429).
-	0: disabled (default)
-	1: enabled
+
+	* 0: disabled (default)
+	* 1: enabled
 
 	Optimistic Duplicate Address Detection for the interface will be enabled
 	if at least one of conf/{all,interface}/optimistic_dad is set to 1,
@@ -1941,8 +2188,9 @@ use_optimistic - BOOLEAN
 	source address selection.  Preferred addresses will still be chosen
 	before optimistic addresses, subject to other ranking in the source
 	address selection algorithm.
-	0: disabled (default)
-	1: enabled
+
+	* 0: disabled (default)
+	* 1: enabled
 
 	This will be enabled if at least one of
 	conf/{all,interface}/use_optimistic is set to 1, disabled otherwise.
@@ -1964,12 +2212,14 @@ stable_secret - IPv6 address
 addr_gen_mode - INTEGER
 	Defines how link-local and autoconf addresses are generated.
 
-	0: generate address based on EUI64 (default)
-	1: do no generate a link-local address, use EUI64 for addresses generated
-	   from autoconf
-	2: generate stable privacy addresses, using the secret from
+	=  =================================================================
+	0  generate address based on EUI64 (default)
+	1  do no generate a link-local address, use EUI64 for addresses
+	   generated from autoconf
+	2  generate stable privacy addresses, using the secret from
 	   stable_secret (RFC7217)
-	3: generate stable privacy addresses, using a random secret if unset
+	3  generate stable privacy addresses, using a random secret if unset
+	=  =================================================================
 
 drop_unicast_in_l2_multicast - BOOLEAN
 	Drop any unicast IPv6 packets that are received in link-layer
@@ -1991,13 +2241,18 @@ enhanced_dad - BOOLEAN
 	detection of duplicates due to loopback of the NS messages that we send.
 	The nonce option will be sent on an interface unless both of
 	conf/{all,interface}/enhanced_dad are set to FALSE.
+
 	Default: TRUE
 
-icmp/*:
+``icmp/*``:
+===========
+
 ratelimit - INTEGER
 	Limit the maximal rates for sending ICMPv6 messages.
+
 	0 to disable any limiting,
 	otherwise the minimal space between responses in milliseconds.
+
 	Default: 1000
 
 ratemask - list of comma separated ranges
@@ -2018,16 +2273,19 @@ ratemask - list of comma separated ranges
 echo_ignore_all - BOOLEAN
 	If set non-zero, then the kernel will ignore all ICMP ECHO
 	requests sent to it over the IPv6 protocol.
+
 	Default: 0
 
 echo_ignore_multicast - BOOLEAN
 	If set non-zero, then the kernel will ignore all ICMP ECHO
 	requests sent to it over the IPv6 protocol via multicast.
+
 	Default: 0
 
 echo_ignore_anycast - BOOLEAN
 	If set non-zero, then the kernel will ignore all ICMP ECHO
 	requests sent to it over the IPv6 protocol destined to anycast address.
+
 	Default: 0
 
 xfrm6_gc_thresh - INTEGER
@@ -2043,43 +2301,52 @@ YOSHIFUJI Hideaki / USAGI Project <yoshfuji@linux-ipv6.org>
 
 
 /proc/sys/net/bridge/* Variables:
+=================================
 
 bridge-nf-call-arptables - BOOLEAN
-	1 : pass bridged ARP traffic to arptables' FORWARD chain.
-	0 : disable this.
+	- 1 : pass bridged ARP traffic to arptables' FORWARD chain.
+	- 0 : disable this.
+
 	Default: 1
 
 bridge-nf-call-iptables - BOOLEAN
-	1 : pass bridged IPv4 traffic to iptables' chains.
-	0 : disable this.
+	- 1 : pass bridged IPv4 traffic to iptables' chains.
+	- 0 : disable this.
+
 	Default: 1
 
 bridge-nf-call-ip6tables - BOOLEAN
-	1 : pass bridged IPv6 traffic to ip6tables' chains.
-	0 : disable this.
+	- 1 : pass bridged IPv6 traffic to ip6tables' chains.
+	- 0 : disable this.
+
 	Default: 1
 
 bridge-nf-filter-vlan-tagged - BOOLEAN
-	1 : pass bridged vlan-tagged ARP/IP/IPv6 traffic to {arp,ip,ip6}tables.
-	0 : disable this.
+	- 1 : pass bridged vlan-tagged ARP/IP/IPv6 traffic to {arp,ip,ip6}tables.
+	- 0 : disable this.
+
 	Default: 0
 
 bridge-nf-filter-pppoe-tagged - BOOLEAN
-	1 : pass bridged pppoe-tagged IP/IPv6 traffic to {ip,ip6}tables.
-	0 : disable this.
+	- 1 : pass bridged pppoe-tagged IP/IPv6 traffic to {ip,ip6}tables.
+	- 0 : disable this.
+
 	Default: 0
 
 bridge-nf-pass-vlan-input-dev - BOOLEAN
-	1: if bridge-nf-filter-vlan-tagged is enabled, try to find a vlan
-	interface on the bridge and set the netfilter input device to the vlan.
-	This allows use of e.g. "iptables -i br0.1" and makes the REDIRECT
-	target work with vlan-on-top-of-bridge interfaces.  When no matching
-	vlan interface is found, or this switch is off, the input device is
-	set to the bridge interface.
-	0: disable bridge netfilter vlan interface lookup.
+	- 1: if bridge-nf-filter-vlan-tagged is enabled, try to find a vlan
+	  interface on the bridge and set the netfilter input device to the
+	  vlan. This allows use of e.g. "iptables -i br0.1" and makes the
+	  REDIRECT target work with vlan-on-top-of-bridge interfaces.  When no
+	  matching vlan interface is found, or this switch is off, the input
+	  device is set to the bridge interface.
+
+	- 0: disable bridge netfilter vlan interface lookup.
+
 	Default: 0
 
-proc/sys/net/sctp/* Variables:
+``proc/sys/net/sctp/*`` Variables:
+==================================
 
 addip_enable - BOOLEAN
 	Enable or disable extension of  Dynamic Address Reconfiguration
@@ -2144,11 +2411,13 @@ addip_noauth_enable - BOOLEAN
 	we provide this variable to control the enforcement of the
 	authentication requirement.
 
-	1: Allow ADD-IP extension to be used without authentication.  This
+	== ===============================================================
+	1  Allow ADD-IP extension to be used without authentication.  This
 	   should only be set in a closed environment for interoperability
 	   with older implementations.
 
-	0: Enforce the authentication requirement
+	0  Enforce the authentication requirement
+	== ===============================================================
 
 	Default: 0
 
@@ -2158,8 +2427,8 @@ auth_enable - BOOLEAN
 	required for secure operation of Dynamic Address Reconfiguration
 	(ADD-IP) extension.
 
-	1: Enable this extension.
-	0: Disable this extension.
+	- 1: Enable this extension.
+	- 0: Disable this extension.
 
 	Default: 0
 
@@ -2167,8 +2436,8 @@ prsctp_enable - BOOLEAN
 	Enable or disable the Partial Reliability extension (RFC3758) which
 	is used to notify peers that a given DATA should no longer be expected.
 
-	1: Enable extension
-	0: Disable
+	- 1: Enable extension
+	- 0: Disable
 
 	Default: 1
 
@@ -2270,8 +2539,8 @@ cookie_preserve_enable - BOOLEAN
 	Enable or disable the ability to extend the lifetime of the SCTP cookie
 	that is used during the establishment phase of SCTP association
 
-	1: Enable cookie lifetime extension.
-	0: Disable
+	- 1: Enable cookie lifetime extension.
+	- 0: Disable
 
 	Default: 1
 
@@ -2279,9 +2548,11 @@ cookie_hmac_alg - STRING
 	Select the hmac algorithm used when generating the cookie value sent by
 	a listening sctp socket to a connecting client in the INIT-ACK chunk.
 	Valid values are:
+
 	* md5
 	* sha1
 	* none
+
 	Ability to assign md5 or sha1 as the selected alg is predicated on the
 	configuration of those algorithms at build time (CONFIG_CRYPTO_MD5 and
 	CONFIG_CRYPTO_SHA1).
@@ -2300,16 +2571,16 @@ rcvbuf_policy - INTEGER
 	to each association instead of the socket.  This prevents the described
 	blocking.
 
-	1: rcvbuf space is per association
-	0: rcvbuf space is per socket
+	- 1: rcvbuf space is per association
+	- 0: rcvbuf space is per socket
 
 	Default: 0
 
 sndbuf_policy - INTEGER
 	Similar to rcvbuf_policy above, this applies to send buffer space.
 
-	1: Send buffer is tracked per association
-	0: Send buffer is tracked per socket.
+	- 1: Send buffer is tracked per association
+	- 0: Send buffer is tracked per socket.
 
 	Default: 0
 
@@ -2342,19 +2613,23 @@ sctp_wmem  - vector of 3 INTEGERs: min, default, max
 addr_scope_policy - INTEGER
 	Control IPv4 address scoping - draft-stewart-tsvwg-sctp-ipv4-00
 
-	0   - Disable IPv4 address scoping
-	1   - Enable IPv4 address scoping
-	2   - Follow draft but allow IPv4 private addresses
-	3   - Follow draft but allow IPv4 link local addresses
+	- 0   - Disable IPv4 address scoping
+	- 1   - Enable IPv4 address scoping
+	- 2   - Follow draft but allow IPv4 private addresses
+	- 3   - Follow draft but allow IPv4 link local addresses
 
 	Default: 1
 
 
-/proc/sys/net/core/*
+``/proc/sys/net/core/*``
+========================
+
 	Please see: Documentation/admin-guide/sysctl/net.rst for descriptions of these entries.
 
 
-/proc/sys/net/unix/*
+``/proc/sys/net/unix/*``
+========================
+
 max_dgram_qlen - INTEGER
 	The maximum length of dgram socket receive queue
 
diff --git a/Documentation/networking/snmp_counter.rst b/Documentation/networking/snmp_counter.rst
index 10e11099e74a..4edd0d38779e 100644
--- a/Documentation/networking/snmp_counter.rst
+++ b/Documentation/networking/snmp_counter.rst
@@ -792,7 +792,7 @@ counters to indicate the ACK is skipped in which scenario. The ACK
 would only be skipped if the received packet is either a SYN packet or
 it has no data.
 
-.. _sysctl document: https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
+.. _sysctl document: https://www.kernel.org/doc/Documentation/networking/ip-sysctl.rst
 
 * TcpExtTCPACKSkippedSynRecv
 
diff --git a/net/Kconfig b/net/Kconfig
index df8d8c9bd021..8b1f85820a6b 100644
--- a/net/Kconfig
+++ b/net/Kconfig
@@ -86,7 +86,7 @@ config INET
 	  "Sysctl support" below, you can change various aspects of the
 	  behavior of the TCP/IP code by writing to the (virtual) files in
 	  /proc/sys/net/ipv4/*; the options are explained in the file
-	  <file:Documentation/networking/ip-sysctl.txt>.
+	  <file:Documentation/networking/ip-sysctl.rst>.
 
 	  Short answer: say Y.
 
diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index 25a8888826b8..5da4733067fb 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -49,7 +49,7 @@ config IP_ADVANCED_ROUTER
 
 	  Note that some distributions enable it in startup scripts.
 	  For details about rp_filter strict and loose mode read
-	  <file:Documentation/networking/ip-sysctl.txt>.
+	  <file:Documentation/networking/ip-sysctl.rst>.
 
 	  If unsure, say N here.
 
diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index fc61f51d87a3..956a806649f7 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -853,7 +853,7 @@ static bool icmp_unreach(struct sk_buff *skb)
 		case ICMP_FRAG_NEEDED:
 			/* for documentation of the ip_no_pmtu_disc
 			 * values please see
-			 * Documentation/networking/ip-sysctl.txt
+			 * Documentation/networking/ip-sysctl.rst
 			 */
 			switch (net->ipv4.sysctl_ip_no_pmtu_disc) {
 			default:
-- 
2.25.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75C61C0151
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727882AbgD3QFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:05:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727804AbgD3QEk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:40 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 614C52497B;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=OqKfYEWUJFcOEzHWGOpswKqGwVjxOYu4O53nxIx1wgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTKNhWSFq+Hg7EDn5aH/+qpnzZ/0fNqqyxI4oOc37wBVLryOtfcfydhz41VUkgkDr
         BPdHkljVYtoHV6MvJfUhHjta6QmUFRRc9AqMEXEJlZG/UWjWlXnIRpBm16kayCKXk0
         yufqvbZq/IKNPcT8z9aeekq6anYswHTLX6xgu+WE=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxG2-Kh; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        rds-devel@oss.oracle.com
Subject: [PATCH 24/37] docs: networking: convert rds.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:19 +0200
Message-Id: <6c2adf3f895bea317c2f69cb14e2cf0eb203ac64.1588261997.git.mchehab+huawei@kernel.org>
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
- mark code blocks and literals as such;
- mark tables as such;
- mark lists as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 Documentation/networking/{rds.txt => rds.rst} | 295 ++++++++++--------
 MAINTAINERS                                   |   2 +-
 3 files changed, 162 insertions(+), 136 deletions(-)
 rename Documentation/networking/{rds.txt => rds.rst} (59%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index b7e35b0d905c..e63a2cb2e4cb 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -97,6 +97,7 @@ Contents:
    proc_net_tcp
    radiotap-headers
    ray_cs
+   rds
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/rds.txt b/Documentation/networking/rds.rst
similarity index 59%
rename from Documentation/networking/rds.txt
rename to Documentation/networking/rds.rst
index eec61694e894..44936c27ab3a 100644
--- a/Documentation/networking/rds.txt
+++ b/Documentation/networking/rds.rst
@@ -1,3 +1,8 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==
+RDS
+===
 
 Overview
 ========
@@ -24,36 +29,39 @@ as IB.
 The high-level semantics of RDS from the application's point of view are
 
  *	Addressing
-        RDS uses IPv4 addresses and 16bit port numbers to identify
-        the end point of a connection. All socket operations that involve
-        passing addresses between kernel and user space generally
-        use a struct sockaddr_in.
 
-        The fact that IPv4 addresses are used does not mean the underlying
-        transport has to be IP-based. In fact, RDS over IB uses a
-        reliable IB connection; the IP address is used exclusively to
-        locate the remote node's GID (by ARPing for the given IP).
+	RDS uses IPv4 addresses and 16bit port numbers to identify
+	the end point of a connection. All socket operations that involve
+	passing addresses between kernel and user space generally
+	use a struct sockaddr_in.
 
-        The port space is entirely independent of UDP, TCP or any other
-        protocol.
+	The fact that IPv4 addresses are used does not mean the underlying
+	transport has to be IP-based. In fact, RDS over IB uses a
+	reliable IB connection; the IP address is used exclusively to
+	locate the remote node's GID (by ARPing for the given IP).
+
+	The port space is entirely independent of UDP, TCP or any other
+	protocol.
 
  *	Socket interface
-        RDS sockets work *mostly* as you would expect from a BSD
-        socket. The next section will cover the details. At any rate,
-        all I/O is performed through the standard BSD socket API.
-        Some additions like zerocopy support are implemented through
-        control messages, while other extensions use the getsockopt/
-        setsockopt calls.
 
-        Sockets must be bound before you can send or receive data.
-        This is needed because binding also selects a transport and
-        attaches it to the socket. Once bound, the transport assignment
-        does not change. RDS will tolerate IPs moving around (eg in
-        a active-active HA scenario), but only as long as the address
-        doesn't move to a different transport.
+	RDS sockets work *mostly* as you would expect from a BSD
+	socket. The next section will cover the details. At any rate,
+	all I/O is performed through the standard BSD socket API.
+	Some additions like zerocopy support are implemented through
+	control messages, while other extensions use the getsockopt/
+	setsockopt calls.
+
+	Sockets must be bound before you can send or receive data.
+	This is needed because binding also selects a transport and
+	attaches it to the socket. Once bound, the transport assignment
+	does not change. RDS will tolerate IPs moving around (eg in
+	a active-active HA scenario), but only as long as the address
+	doesn't move to a different transport.
 
  *	sysctls
-        RDS supports a number of sysctls in /proc/sys/net/rds
+
+	RDS supports a number of sysctls in /proc/sys/net/rds
 
 
 Socket Interface
@@ -66,89 +74,88 @@ Socket Interface
 	options.
 
   fd = socket(PF_RDS, SOCK_SEQPACKET, 0);
-        This creates a new, unbound RDS socket.
+	This creates a new, unbound RDS socket.
 
   setsockopt(SOL_SOCKET): send and receive buffer size
-        RDS honors the send and receive buffer size socket options.
-        You are not allowed to queue more than SO_SNDSIZE bytes to
-        a socket. A message is queued when sendmsg is called, and
-        it leaves the queue when the remote system acknowledges
-        its arrival.
+	RDS honors the send and receive buffer size socket options.
+	You are not allowed to queue more than SO_SNDSIZE bytes to
+	a socket. A message is queued when sendmsg is called, and
+	it leaves the queue when the remote system acknowledges
+	its arrival.
 
-        The SO_RCVSIZE option controls the maximum receive queue length.
-        This is a soft limit rather than a hard limit - RDS will
-        continue to accept and queue incoming messages, even if that
-        takes the queue length over the limit. However, it will also
-        mark the port as "congested" and send a congestion update to
-        the source node. The source node is supposed to throttle any
-        processes sending to this congested port.
+	The SO_RCVSIZE option controls the maximum receive queue length.
+	This is a soft limit rather than a hard limit - RDS will
+	continue to accept and queue incoming messages, even if that
+	takes the queue length over the limit. However, it will also
+	mark the port as "congested" and send a congestion update to
+	the source node. The source node is supposed to throttle any
+	processes sending to this congested port.
 
   bind(fd, &sockaddr_in, ...)
-        This binds the socket to a local IP address and port, and a
-        transport, if one has not already been selected via the
+	This binds the socket to a local IP address and port, and a
+	transport, if one has not already been selected via the
 	SO_RDS_TRANSPORT socket option
 
   sendmsg(fd, ...)
-        Sends a message to the indicated recipient. The kernel will
-        transparently establish the underlying reliable connection
-        if it isn't up yet.
+	Sends a message to the indicated recipient. The kernel will
+	transparently establish the underlying reliable connection
+	if it isn't up yet.
 
-        An attempt to send a message that exceeds SO_SNDSIZE will
-        return with -EMSGSIZE
+	An attempt to send a message that exceeds SO_SNDSIZE will
+	return with -EMSGSIZE
 
-        An attempt to send a message that would take the total number
-        of queued bytes over the SO_SNDSIZE threshold will return
-        EAGAIN.
+	An attempt to send a message that would take the total number
+	of queued bytes over the SO_SNDSIZE threshold will return
+	EAGAIN.
 
-        An attempt to send a message to a destination that is marked
-        as "congested" will return ENOBUFS.
+	An attempt to send a message to a destination that is marked
+	as "congested" will return ENOBUFS.
 
   recvmsg(fd, ...)
-        Receives a message that was queued to this socket. The sockets
-        recv queue accounting is adjusted, and if the queue length
-        drops below SO_SNDSIZE, the port is marked uncongested, and
-        a congestion update is sent to all peers.
+	Receives a message that was queued to this socket. The sockets
+	recv queue accounting is adjusted, and if the queue length
+	drops below SO_SNDSIZE, the port is marked uncongested, and
+	a congestion update is sent to all peers.
 
-        Applications can ask the RDS kernel module to receive
-        notifications via control messages (for instance, there is a
-        notification when a congestion update arrived, or when a RDMA
-        operation completes). These notifications are received through
-        the msg.msg_control buffer of struct msghdr. The format of the
-        messages is described in manpages.
+	Applications can ask the RDS kernel module to receive
+	notifications via control messages (for instance, there is a
+	notification when a congestion update arrived, or when a RDMA
+	operation completes). These notifications are received through
+	the msg.msg_control buffer of struct msghdr. The format of the
+	messages is described in manpages.
 
   poll(fd)
-        RDS supports the poll interface to allow the application
-        to implement async I/O.
+	RDS supports the poll interface to allow the application
+	to implement async I/O.
 
-        POLLIN handling is pretty straightforward. When there's an
-        incoming message queued to the socket, or a pending notification,
-        we signal POLLIN.
+	POLLIN handling is pretty straightforward. When there's an
+	incoming message queued to the socket, or a pending notification,
+	we signal POLLIN.
 
-        POLLOUT is a little harder. Since you can essentially send
-        to any destination, RDS will always signal POLLOUT as long as
-        there's room on the send queue (ie the number of bytes queued
-        is less than the sendbuf size).
+	POLLOUT is a little harder. Since you can essentially send
+	to any destination, RDS will always signal POLLOUT as long as
+	there's room on the send queue (ie the number of bytes queued
+	is less than the sendbuf size).
 
-        However, the kernel will refuse to accept messages to
-        a destination marked congested - in this case you will loop
-        forever if you rely on poll to tell you what to do.
-        This isn't a trivial problem, but applications can deal with
-        this - by using congestion notifications, and by checking for
-        ENOBUFS errors returned by sendmsg.
+	However, the kernel will refuse to accept messages to
+	a destination marked congested - in this case you will loop
+	forever if you rely on poll to tell you what to do.
+	This isn't a trivial problem, but applications can deal with
+	this - by using congestion notifications, and by checking for
+	ENOBUFS errors returned by sendmsg.
 
   setsockopt(SOL_RDS, RDS_CANCEL_SENT_TO, &sockaddr_in)
-        This allows the application to discard all messages queued to a
-        specific destination on this particular socket.
+	This allows the application to discard all messages queued to a
+	specific destination on this particular socket.
 
-        This allows the application to cancel outstanding messages if
-        it detects a timeout. For instance, if it tried to send a message,
-        and the remote host is unreachable, RDS will keep trying forever.
-        The application may decide it's not worth it, and cancel the
-        operation. In this case, it would use RDS_CANCEL_SENT_TO to
-        nuke any pending messages.
+	This allows the application to cancel outstanding messages if
+	it detects a timeout. For instance, if it tried to send a message,
+	and the remote host is unreachable, RDS will keep trying forever.
+	The application may decide it's not worth it, and cancel the
+	operation. In this case, it would use RDS_CANCEL_SENT_TO to
+	nuke any pending messages.
 
-  setsockopt(fd, SOL_RDS, SO_RDS_TRANSPORT, (int *)&transport ..)
-  getsockopt(fd, SOL_RDS, SO_RDS_TRANSPORT, (int *)&transport ..)
+  ``setsockopt(fd, SOL_RDS, SO_RDS_TRANSPORT, (int *)&transport ..), getsockopt(fd, SOL_RDS, SO_RDS_TRANSPORT, (int *)&transport ..)``
 	Set or read an integer defining  the underlying
 	encapsulating transport to be used for RDS packets on the
 	socket. When setting the option, integer argument may be
@@ -180,32 +187,39 @@ RDS Protocol
   Message header
 
     The message header is a 'struct rds_header' (see rds.h):
+
     Fields:
+
       h_sequence:
-          per-packet sequence number
+	  per-packet sequence number
       h_ack:
-          piggybacked acknowledgment of last packet received
+	  piggybacked acknowledgment of last packet received
       h_len:
-          length of data, not including header
+	  length of data, not including header
       h_sport:
-          source port
+	  source port
       h_dport:
-          destination port
+	  destination port
       h_flags:
-          CONG_BITMAP - this is a congestion update bitmap
-          ACK_REQUIRED - receiver must ack this packet
-          RETRANSMITTED - packet has previously been sent
+	  Can be:
+
+	  =============  ==================================
+	  CONG_BITMAP    this is a congestion update bitmap
+	  ACK_REQUIRED   receiver must ack this packet
+	  RETRANSMITTED  packet has previously been sent
+	  =============  ==================================
+
       h_credit:
-          indicate to other end of connection that
-          it has more credits available (i.e. there is
-          more send room)
+	  indicate to other end of connection that
+	  it has more credits available (i.e. there is
+	  more send room)
       h_padding[4]:
-          unused, for future use
+	  unused, for future use
       h_csum:
-          header checksum
+	  header checksum
       h_exthdr:
-          optional data can be passed here. This is currently used for
-          passing RDMA-related information.
+	  optional data can be passed here. This is currently used for
+	  passing RDMA-related information.
 
   ACK and retransmit handling
 
@@ -260,7 +274,7 @@ RDS Protocol
 
 
 RDS Transport Layer
-==================
+===================
 
   As mentioned above, RDS is not IB-specific. Its code is divided
   into a general RDS layer and a transport layer.
@@ -281,19 +295,25 @@ RDS Kernel Structures
     be sent and sets header fields as needed, based on the socket API.
     This is then queued for the individual connection and sent by the
     connection's transport.
+
   struct rds_incoming
     a generic struct referring to incoming data that can be handed from
     the transport to the general code and queued by the general code
     while the socket is awoken. It is then passed back to the transport
     code to handle the actual copy-to-user.
+
   struct rds_socket
     per-socket information
+
   struct rds_connection
     per-connection information
+
   struct rds_transport
     pointers to transport-specific functions
+
   struct rds_statistics
     non-transport-specific statistics
+
   struct rds_cong_map
     wraps the raw congestion bitmap, contains rbnode, waitq, etc.
 
@@ -317,53 +337,58 @@ The send path
 =============
 
   rds_sendmsg()
-    struct rds_message built from incoming data
-    CMSGs parsed (e.g. RDMA ops)
-    transport connection alloced and connected if not already
-    rds_message placed on send queue
-    send worker awoken
+    - struct rds_message built from incoming data
+    - CMSGs parsed (e.g. RDMA ops)
+    - transport connection alloced and connected if not already
+    - rds_message placed on send queue
+    - send worker awoken
+
   rds_send_worker()
-    calls rds_send_xmit() until queue is empty
+    - calls rds_send_xmit() until queue is empty
+
   rds_send_xmit()
-    transmits congestion map if one is pending
-    may set ACK_REQUIRED
-    calls transport to send either non-RDMA or RDMA message
-    (RDMA ops never retransmitted)
+    - transmits congestion map if one is pending
+    - may set ACK_REQUIRED
+    - calls transport to send either non-RDMA or RDMA message
+      (RDMA ops never retransmitted)
+
   rds_ib_xmit()
-    allocs work requests from send ring
-    adds any new send credits available to peer (h_credits)
-    maps the rds_message's sg list
-    piggybacks ack
-    populates work requests
-    post send to connection's queue pair
+    - allocs work requests from send ring
+    - adds any new send credits available to peer (h_credits)
+    - maps the rds_message's sg list
+    - piggybacks ack
+    - populates work requests
+    - post send to connection's queue pair
 
 The recv path
 =============
 
   rds_ib_recv_cq_comp_handler()
-    looks at write completions
-    unmaps recv buffer from device
-    no errors, call rds_ib_process_recv()
-    refill recv ring
+    - looks at write completions
+    - unmaps recv buffer from device
+    - no errors, call rds_ib_process_recv()
+    - refill recv ring
+
   rds_ib_process_recv()
-    validate header checksum
-    copy header to rds_ib_incoming struct if start of a new datagram
-    add to ibinc's fraglist
-    if competed datagram:
-      update cong map if datagram was cong update
-      call rds_recv_incoming() otherwise
-      note if ack is required
+    - validate header checksum
+    - copy header to rds_ib_incoming struct if start of a new datagram
+    - add to ibinc's fraglist
+    - if competed datagram:
+	 - update cong map if datagram was cong update
+	 - call rds_recv_incoming() otherwise
+	 - note if ack is required
+
   rds_recv_incoming()
-    drop duplicate packets
-    respond to pings
-    find the sock associated with this datagram
-    add to sock queue
-    wake up sock
-    do some congestion calculations
+    - drop duplicate packets
+    - respond to pings
+    - find the sock associated with this datagram
+    - add to sock queue
+    - wake up sock
+    - do some congestion calculations
   rds_recvmsg
-    copy data into user iovec
-    handle CMSGs
-    return to application
+    - copy data into user iovec
+    - handle CMSGs
+    - return to application
 
 Multipath RDS (mprds)
 =====================
diff --git a/MAINTAINERS b/MAINTAINERS
index 0d2005e8380e..d525b85a37a0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14254,7 +14254,7 @@ L:	linux-rdma@vger.kernel.org
 L:	rds-devel@oss.oracle.com (moderated for non-subscribers)
 S:	Supported
 W:	https://oss.oracle.com/projects/rds/
-F:	Documentation/networking/rds.txt
+F:	Documentation/networking/rds.rst
 F:	net/rds/
 
 RDT - RESOURCE ALLOCATION
-- 
2.25.4


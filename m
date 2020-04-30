Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 082A31C01BC
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgD3QIi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:50402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgD3QEh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:37 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BEB172076D;
        Thu, 30 Apr 2020 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262675;
        bh=/BdKHFSNyDbHVw0vpNwfTVV9aP7/cQNWyPNxpQEngRY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TnzOnpNhxy52GvCuYqXJJByjrVzgoNe9uvMDhvOhWPzJxfC8d3KNyetfZwMVv6sC0
         sa6STxUrXALFH9pNqbFIo7Qcfe5AMjdwkOz/ra7yV1ABaYO6KqyJt0XzpLDAZzCvun
         irMJ8miuGe8X8mKMgWTxGN9aLs+zO2ePQoDXVZiA=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxEB-01; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 01/37] docs: networking: convert l2tp.txt to ReST
Date:   Thu, 30 Apr 2020 18:03:56 +0200
Message-Id: <157b3aa863c15a4b8feeeb0cdd5475c2596c5dde.1588261997.git.mchehab+huawei@kernel.org>
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
- mark tables as such;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../networking/{l2tp.txt => l2tp.rst}         | 145 ++++++++++--------
 2 files changed, 80 insertions(+), 66 deletions(-)
 rename Documentation/networking/{l2tp.txt => l2tp.rst} (79%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index e1ff08b94d90..0c5d7a037983 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -74,6 +74,7 @@ Contents:
    ipvlan
    ipvs-sysctl
    kcm
+   l2tp
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/l2tp.txt b/Documentation/networking/l2tp.rst
similarity index 79%
rename from Documentation/networking/l2tp.txt
rename to Documentation/networking/l2tp.rst
index 9bc271cdc9a8..a48238a2ec09 100644
--- a/Documentation/networking/l2tp.txt
+++ b/Documentation/networking/l2tp.rst
@@ -1,3 +1,9 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+====
+L2TP
+====
+
 This document describes how to use the kernel's L2TP drivers to
 provide L2TP functionality. L2TP is a protocol that tunnels one or
 more sessions over an IP tunnel. It is commonly used for VPNs
@@ -121,14 +127,16 @@ Userspace may control behavior of the tunnel or session using
 setsockopt and ioctl on the PPPoX socket. The following socket
 options are supported:-
 
-DEBUG     - bitmask of debug message categories. See below.
-SENDSEQ   - 0 => don't send packets with sequence numbers
-            1 => send packets with sequence numbers
-RECVSEQ   - 0 => receive packet sequence numbers are optional
-            1 => drop receive packets without sequence numbers
-LNSMODE   - 0 => act as LAC.
-            1 => act as LNS.
-REORDERTO - reorder timeout (in millisecs). If 0, don't try to reorder.
+=========   ===========================================================
+DEBUG       bitmask of debug message categories. See below.
+SENDSEQ     - 0 => don't send packets with sequence numbers
+	    - 1 => send packets with sequence numbers
+RECVSEQ     - 0 => receive packet sequence numbers are optional
+	    - 1 => drop receive packets without sequence numbers
+LNSMODE     - 0 => act as LAC.
+	    - 1 => act as LNS.
+REORDERTO   reorder timeout (in millisecs). If 0, don't try to reorder.
+=========   ===========================================================
 
 Only the DEBUG option is supported by the special tunnel management
 PPPoX socket.
@@ -177,20 +185,22 @@ setsockopt on the PPPoX socket to set a debug mask.
 
 The following debug mask bits are available:
 
+================  ==============================
 L2TP_MSG_DEBUG    verbose debug (if compiled in)
 L2TP_MSG_CONTROL  userspace - kernel interface
 L2TP_MSG_SEQ      sequence numbers handling
 L2TP_MSG_DATA     data packets
+================  ==============================
 
 If enabled, files under a l2tp debugfs directory can be used to dump
 kernel state about L2TP tunnels and sessions. To access it, the
-debugfs filesystem must first be mounted.
+debugfs filesystem must first be mounted::
 
-# mount -t debugfs debugfs /debug
+	# mount -t debugfs debugfs /debug
 
-Files under the l2tp directory can then be accessed.
+Files under the l2tp directory can then be accessed::
 
-# cat /debug/l2tp/tunnels
+	# cat /debug/l2tp/tunnels
 
 The debugfs files should not be used by applications to obtain L2TP
 state information because the file format is subject to change. It is
@@ -211,14 +221,14 @@ iproute2's ip utility to support this.
 
 To create an L2TPv3 ethernet pseudowire between local host 192.168.1.1
 and peer 192.168.1.2, using IP addresses 10.5.1.1 and 10.5.1.2 for the
-tunnel endpoints:-
+tunnel endpoints::
 
-# ip l2tp add tunnel tunnel_id 1 peer_tunnel_id 1 udp_sport 5000 \
-  udp_dport 5000 encap udp local 192.168.1.1 remote 192.168.1.2
-# ip l2tp add session tunnel_id 1 session_id 1 peer_session_id 1
-# ip -s -d show dev l2tpeth0
-# ip addr add 10.5.1.2/32 peer 10.5.1.1/32 dev l2tpeth0
-# ip li set dev l2tpeth0 up
+	# ip l2tp add tunnel tunnel_id 1 peer_tunnel_id 1 udp_sport 5000 \
+	  udp_dport 5000 encap udp local 192.168.1.1 remote 192.168.1.2
+	# ip l2tp add session tunnel_id 1 session_id 1 peer_session_id 1
+	# ip -s -d show dev l2tpeth0
+	# ip addr add 10.5.1.2/32 peer 10.5.1.1/32 dev l2tpeth0
+	# ip li set dev l2tpeth0 up
 
 Choose IP addresses to be the address of a local IP interface and that
 of the remote system. The IP addresses of the l2tpeth0 interface can be
@@ -228,75 +238,78 @@ Repeat the above at the peer, with ports, tunnel/session ids and IP
 addresses reversed.  The tunnel and session IDs can be any non-zero
 32-bit number, but the values must be reversed at the peer.
 
+========================       ===================
 Host 1                         Host2
+========================       ===================
 udp_sport=5000                 udp_sport=5001
 udp_dport=5001                 udp_dport=5000
 tunnel_id=42                   tunnel_id=45
 peer_tunnel_id=45              peer_tunnel_id=42
 session_id=128                 session_id=5196755
 peer_session_id=5196755        peer_session_id=128
+========================       ===================
 
 When done at both ends of the tunnel, it should be possible to send
-data over the network. e.g.
+data over the network. e.g.::
 
-# ping 10.5.1.1
+	# ping 10.5.1.1
 
 
 Sample Userspace Code
 =====================
 
-1. Create tunnel management PPPoX socket
+1. Create tunnel management PPPoX socket::
 
-        kernel_fd = socket(AF_PPPOX, SOCK_DGRAM, PX_PROTO_OL2TP);
-        if (kernel_fd >= 0) {
-                struct sockaddr_pppol2tp sax;
-                struct sockaddr_in const *peer_addr;
+	kernel_fd = socket(AF_PPPOX, SOCK_DGRAM, PX_PROTO_OL2TP);
+	if (kernel_fd >= 0) {
+		struct sockaddr_pppol2tp sax;
+		struct sockaddr_in const *peer_addr;
 
-                peer_addr = l2tp_tunnel_get_peer_addr(tunnel);
-                memset(&sax, 0, sizeof(sax));
-                sax.sa_family = AF_PPPOX;
-                sax.sa_protocol = PX_PROTO_OL2TP;
-                sax.pppol2tp.fd = udp_fd;       /* fd of tunnel UDP socket */
-                sax.pppol2tp.addr.sin_addr.s_addr = peer_addr->sin_addr.s_addr;
-                sax.pppol2tp.addr.sin_port = peer_addr->sin_port;
-                sax.pppol2tp.addr.sin_family = AF_INET;
-                sax.pppol2tp.s_tunnel = tunnel_id;
-                sax.pppol2tp.s_session = 0;     /* special case: mgmt socket */
-                sax.pppol2tp.d_tunnel = 0;
-                sax.pppol2tp.d_session = 0;     /* special case: mgmt socket */
+		peer_addr = l2tp_tunnel_get_peer_addr(tunnel);
+		memset(&sax, 0, sizeof(sax));
+		sax.sa_family = AF_PPPOX;
+		sax.sa_protocol = PX_PROTO_OL2TP;
+		sax.pppol2tp.fd = udp_fd;       /* fd of tunnel UDP socket */
+		sax.pppol2tp.addr.sin_addr.s_addr = peer_addr->sin_addr.s_addr;
+		sax.pppol2tp.addr.sin_port = peer_addr->sin_port;
+		sax.pppol2tp.addr.sin_family = AF_INET;
+		sax.pppol2tp.s_tunnel = tunnel_id;
+		sax.pppol2tp.s_session = 0;     /* special case: mgmt socket */
+		sax.pppol2tp.d_tunnel = 0;
+		sax.pppol2tp.d_session = 0;     /* special case: mgmt socket */
 
-                if(connect(kernel_fd, (struct sockaddr *)&sax, sizeof(sax) ) < 0 ) {
-                        perror("connect failed");
-                        result = -errno;
-                        goto err;
-                }
-        }
+		if(connect(kernel_fd, (struct sockaddr *)&sax, sizeof(sax) ) < 0 ) {
+			perror("connect failed");
+			result = -errno;
+			goto err;
+		}
+	}
 
-2. Create session PPPoX data socket
+2. Create session PPPoX data socket::
 
-        struct sockaddr_pppol2tp sax;
-        int fd;
+	struct sockaddr_pppol2tp sax;
+	int fd;
 
-        /* Note, the target socket must be bound already, else it will not be ready */
-        sax.sa_family = AF_PPPOX;
-        sax.sa_protocol = PX_PROTO_OL2TP;
-        sax.pppol2tp.fd = tunnel_fd;
-        sax.pppol2tp.addr.sin_addr.s_addr = addr->sin_addr.s_addr;
-        sax.pppol2tp.addr.sin_port = addr->sin_port;
-        sax.pppol2tp.addr.sin_family = AF_INET;
-        sax.pppol2tp.s_tunnel  = tunnel_id;
-        sax.pppol2tp.s_session = session_id;
-        sax.pppol2tp.d_tunnel  = peer_tunnel_id;
-        sax.pppol2tp.d_session = peer_session_id;
+	/* Note, the target socket must be bound already, else it will not be ready */
+	sax.sa_family = AF_PPPOX;
+	sax.sa_protocol = PX_PROTO_OL2TP;
+	sax.pppol2tp.fd = tunnel_fd;
+	sax.pppol2tp.addr.sin_addr.s_addr = addr->sin_addr.s_addr;
+	sax.pppol2tp.addr.sin_port = addr->sin_port;
+	sax.pppol2tp.addr.sin_family = AF_INET;
+	sax.pppol2tp.s_tunnel  = tunnel_id;
+	sax.pppol2tp.s_session = session_id;
+	sax.pppol2tp.d_tunnel  = peer_tunnel_id;
+	sax.pppol2tp.d_session = peer_session_id;
 
-        /* session_fd is the fd of the session's PPPoL2TP socket.
-         * tunnel_fd is the fd of the tunnel UDP socket.
-         */
-        fd = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
-        if (fd < 0 )    {
-                return -errno;
-        }
-        return 0;
+	/* session_fd is the fd of the session's PPPoL2TP socket.
+	 * tunnel_fd is the fd of the tunnel UDP socket.
+	 */
+	fd = connect(session_fd, (struct sockaddr *)&sax, sizeof(sax));
+	if (fd < 0 )    {
+		return -errno;
+	}
+	return 0;
 
 Internal Implementation
 =======================
-- 
2.25.4


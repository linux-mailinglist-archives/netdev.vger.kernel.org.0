Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBA4A1BB0DF
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:02:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgD0WCE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:02:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgD0WCC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:02 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 423C122314;
        Mon, 27 Apr 2020 22:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024917;
        bh=XWSRuvHlX2fDgbkytqilwkTrzeheEmYKB9PQNJEdzhs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5Egj1akShGt9xE8DPZxFqyn3yA2/dE1bGjgLKzuQIae/FgRLt78xuWGvYdwchGW3
         EipQ/bR0CxnYKPhBfil3GakiuaLJpa+w1xQhAGybbAwyIbVA0kih9F3d2ts8k8vOn5
         ikrsusiRxDPgXOkDBpp4hL2SDZ6pWFRhionKsQ0U=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000Iqg-G5; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH 38/38] docs: networking: convert kcm.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:53 +0200
Message-Id: <2658edf4e16bc11fb9b3d7bc25ab8cda2f24f88a.1588024424.git.mchehab+huawei@kernel.org>
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
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 Documentation/networking/{kcm.txt => kcm.rst} | 83 ++++++++++---------
 2 files changed, 45 insertions(+), 39 deletions(-)
 rename Documentation/networking/{kcm.txt => kcm.rst} (84%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index bbd4e0041457..e1ff08b94d90 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -73,6 +73,7 @@ Contents:
    ipv6
    ipvlan
    ipvs-sysctl
+   kcm
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/kcm.txt b/Documentation/networking/kcm.rst
similarity index 84%
rename from Documentation/networking/kcm.txt
rename to Documentation/networking/kcm.rst
index b773a5278ac4..db0f5560ac1c 100644
--- a/Documentation/networking/kcm.txt
+++ b/Documentation/networking/kcm.rst
@@ -1,35 +1,38 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=============================
 Kernel Connection Multiplexor
------------------------------
+=============================
 
 Kernel Connection Multiplexor (KCM) is a mechanism that provides a message based
 interface over TCP for generic application protocols. With KCM an application
 can efficiently send and receive application protocol messages over TCP using
 datagram sockets.
 
-KCM implements an NxM multiplexor in the kernel as diagrammed below:
+KCM implements an NxM multiplexor in the kernel as diagrammed below::
 
-+------------+   +------------+   +------------+   +------------+
-| KCM socket |   | KCM socket |   | KCM socket |   | KCM socket |
-+------------+   +------------+   +------------+   +------------+
-      |                 |               |                |
-      +-----------+     |               |     +----------+
-                  |     |               |     |
-               +----------------------------------+
-               |           Multiplexor            |
-               +----------------------------------+
-                 |   |           |           |  |
-       +---------+   |           |           |  ------------+
-       |             |           |           |              |
-+----------+  +----------+  +----------+  +----------+ +----------+
-|  Psock   |  |  Psock   |  |  Psock   |  |  Psock   | |  Psock   |
-+----------+  +----------+  +----------+  +----------+ +----------+
-      |              |           |            |             |
-+----------+  +----------+  +----------+  +----------+ +----------+
-| TCP sock |  | TCP sock |  | TCP sock |  | TCP sock | | TCP sock |
-+----------+  +----------+  +----------+  +----------+ +----------+
+    +------------+   +------------+   +------------+   +------------+
+    | KCM socket |   | KCM socket |   | KCM socket |   | KCM socket |
+    +------------+   +------------+   +------------+   +------------+
+	|                 |               |                |
+	+-----------+     |               |     +----------+
+		    |     |               |     |
+		+----------------------------------+
+		|           Multiplexor            |
+		+----------------------------------+
+		    |   |           |           |  |
+	+---------+   |           |           |  ------------+
+	|             |           |           |              |
+    +----------+  +----------+  +----------+  +----------+ +----------+
+    |  Psock   |  |  Psock   |  |  Psock   |  |  Psock   | |  Psock   |
+    +----------+  +----------+  +----------+  +----------+ +----------+
+	|              |           |            |             |
+    +----------+  +----------+  +----------+  +----------+ +----------+
+    | TCP sock |  | TCP sock |  | TCP sock |  | TCP sock | | TCP sock |
+    +----------+  +----------+  +----------+  +----------+ +----------+
 
 KCM sockets
------------
+===========
 
 The KCM sockets provide the user interface to the multiplexor. All the KCM sockets
 bound to a multiplexor are considered to have equivalent function, and I/O
@@ -37,7 +40,7 @@ operations in different sockets may be done in parallel without the need for
 synchronization between threads in userspace.
 
 Multiplexor
------------
+===========
 
 The multiplexor provides the message steering. In the transmit path, messages
 written on a KCM socket are sent atomically on an appropriate TCP socket.
@@ -45,14 +48,14 @@ Similarly, in the receive path, messages are constructed on each TCP socket
 (Psock) and complete messages are steered to a KCM socket.
 
 TCP sockets & Psocks
---------------------
+====================
 
 TCP sockets may be bound to a KCM multiplexor. A Psock structure is allocated
 for each bound TCP socket, this structure holds the state for constructing
 messages on receive as well as other connection specific information for KCM.
 
 Connected mode semantics
-------------------------
+========================
 
 Each multiplexor assumes that all attached TCP connections are to the same
 destination and can use the different connections for load balancing when
@@ -60,7 +63,7 @@ transmitting. The normal send and recv calls (include sendmmsg and recvmmsg)
 can be used to send and receive messages from the KCM socket.
 
 Socket types
-------------
+============
 
 KCM supports SOCK_DGRAM and SOCK_SEQPACKET socket types.
 
@@ -110,23 +113,23 @@ User interface
 Creating a multiplexor
 ----------------------
 
-A new multiplexor and initial KCM socket is created by a socket call:
+A new multiplexor and initial KCM socket is created by a socket call::
 
   socket(AF_KCM, type, protocol)
 
-  - type is either SOCK_DGRAM or SOCK_SEQPACKET
-  - protocol is KCMPROTO_CONNECTED
+- type is either SOCK_DGRAM or SOCK_SEQPACKET
+- protocol is KCMPROTO_CONNECTED
 
 Cloning KCM sockets
 -------------------
 
 After the first KCM socket is created using the socket call as described
 above, additional sockets for the multiplexor can be created by cloning
-a KCM socket. This is accomplished by an ioctl on a KCM socket:
+a KCM socket. This is accomplished by an ioctl on a KCM socket::
 
   /* From linux/kcm.h */
   struct kcm_clone {
-        int fd;
+	int fd;
   };
 
   struct kcm_clone info;
@@ -142,11 +145,11 @@ Attach transport sockets
 ------------------------
 
 Attaching of transport sockets to a multiplexor is performed by calling an
-ioctl on a KCM socket for the multiplexor. e.g.:
+ioctl on a KCM socket for the multiplexor. e.g.::
 
   /* From linux/kcm.h */
   struct kcm_attach {
-        int fd;
+	int fd;
 	int bpf_fd;
   };
 
@@ -160,18 +163,19 @@ ioctl on a KCM socket for the multiplexor. e.g.:
   ioctl(kcmfd, SIOCKCMATTACH, &info);
 
 The kcm_attach structure contains:
-  fd: file descriptor for TCP socket being attached
-  bpf_prog_fd: file descriptor for compiled BPF program downloaded
+
+  - fd: file descriptor for TCP socket being attached
+  - bpf_prog_fd: file descriptor for compiled BPF program downloaded
 
 Unattach transport sockets
 --------------------------
 
 Unattaching a transport socket from a multiplexor is straightforward. An
-"unattach" ioctl is done with the kcm_unattach structure as the argument:
+"unattach" ioctl is done with the kcm_unattach structure as the argument::
 
   /* From linux/kcm.h */
   struct kcm_unattach {
-        int fd;
+	int fd;
   };
 
   struct kcm_unattach info;
@@ -190,7 +194,7 @@ When receive is disabled, any pending messages in the socket's
 receive buffer are moved to other sockets. This feature is useful
 if an application thread knows that it will be doing a lot of
 work on a request and won't be able to service new messages for a
-while. Example use:
+while. Example use::
 
   int val = 1;
 
@@ -200,7 +204,7 @@ BFP programs for message delineation
 ------------------------------------
 
 BPF programs can be compiled using the BPF LLVM backend. For example,
-the BPF program for parsing Thrift is:
+the BPF program for parsing Thrift is::
 
   #include "bpf.h" /* for __sk_buff */
   #include "bpf_helpers.h" /* for load_word intrinsic */
@@ -250,6 +254,7 @@ based on groups, or batches of messages, can be beneficial for performance.
 
 On transmit, there are three ways an application can batch (pipeline)
 messages on a KCM socket.
+
   1) Send multiple messages in a single sendmmsg.
   2) Send a group of messages each with a sendmsg call, where all messages
      except the last have MSG_BATCH in the flags of sendmsg call.
-- 
2.25.4


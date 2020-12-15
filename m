Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4ABD02DB1EC
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 17:53:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731129AbgLOQw5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Dec 2020 11:52:57 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:39043 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730884AbgLOQwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Dec 2020 11:52:53 -0500
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 44194440A8D;
        Tue, 15 Dec 2020 18:52:09 +0200 (IST)
From:   Baruch Siach <baruch@tkos.co.il>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        =?UTF-8?q?Ulisses=20Alonso=20Camar=C3=B3?= <uaca@alumni.uv.es>,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH net 2/2] docs: networking: packet_mmap: don't mention PACKET_MMAP
Date:   Tue, 15 Dec 2020 18:51:17 +0200
Message-Id: <1fc59ef61e324a969071ea537ccc2856adee3c5b.1608051077.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <425a2567dbf8ece01fb54fbb43ceee7b2eab9d05.1608051077.git.baruch@tkos.co.il>
References: <425a2567dbf8ece01fb54fbb43ceee7b2eab9d05.1608051077.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Before commit 889b8f964f2f ("packet: Kill CONFIG_PACKET_MMAP.") there
used to be a CONFIG_PACKET_MMAP config symbol that depended on
CONFIG_PACKET. The text still refers to PACKET_MMAP as the name of this
feature, implying that it can be disabled. Another naming variant is
"Packet MMAP".

Use "PACKET mmap()" everywhere to unify the terminology. Rephrase the
text the implied mmap() feature disable option.

Also, drop reference to broken link to information for pre 2.6.5
kernels.

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 Documentation/networking/packet_mmap.rst | 73 ++++++++++++------------
 1 file changed, 36 insertions(+), 37 deletions(-)

diff --git a/Documentation/networking/packet_mmap.rst b/Documentation/networking/packet_mmap.rst
index f3646c80b019..19c660f597e9 100644
--- a/Documentation/networking/packet_mmap.rst
+++ b/Documentation/networking/packet_mmap.rst
@@ -1,8 +1,8 @@
 .. SPDX-License-Identifier: GPL-2.0
 
-===========
-Packet MMAP
-===========
+=============
+PACKET mmap()
+=============
 
 Abstract
 ========
@@ -22,23 +22,23 @@ Please send your comments to
     - Ulisses Alonso Camaró <uaca@i.hate.spam.alumni.uv.es>
     - Johann Baudy
 
-Why use PACKET_MMAP
-===================
+Why use PACKET mmap()
+=====================
 
-In Linux 2.4/2.6/3.x if PACKET_MMAP is not enabled, the capture process is very
-inefficient. It uses very limited buffers and requires one system call to
-capture each packet, it requires two if you want to get packet's timestamp
-(like libpcap always does).
+In Linux 2.4/2.6/3.x non mmap() PACKET capture process is very inefficient. It
+uses very limited buffers and requires one system call to capture each packet,
+it requires two if you want to get packet's timestamp (like libpcap always
+does).
 
-In the other hand PACKET_MMAP is very efficient. PACKET_MMAP provides a size
-configurable circular buffer mapped in user space that can be used to either
-send or receive packets. This way reading packets just needs to wait for them,
-most of the time there is no need to issue a single system call. Concerning
-transmission, multiple packets can be sent through one system call to get the
-highest bandwidth. By using a shared buffer between the kernel and the user
-also has the benefit of minimizing packet copies.
+In the other hand PACKET mmap() is very efficient. PACKET mmap() provides a
+size configurable circular buffer mapped in user space that can be used to
+either send or receive packets. This way reading packets just needs to wait for
+them, most of the time there is no need to issue a single system call.
+Concerning transmission, multiple packets can be sent through one system call
+to get the highest bandwidth. By using a shared buffer between the kernel and
+the user also has the benefit of minimizing packet copies.
 
-It's fine to use PACKET_MMAP to improve the performance of the capture and
+It's fine to use PACKET mmap() to improve the performance of the capture and
 transmission process, but it isn't everything. At least, if you are capturing
 at high speeds (this is relative to the cpu speed), you should check if the
 device driver of your network interface card supports some sort of interrupt
@@ -54,13 +54,13 @@ From the user standpoint, you should use the higher level libpcap library, which
 is a de facto standard, portable across nearly all operating systems
 including Win32.
 
-Packet MMAP support was integrated into libpcap around the time of version 1.3.0;
-TPACKET_V3 support was added in version 1.5.0
+PACKET mmap() support was integrated into libpcap around the time of version
+1.3.0; TPACKET_V3 support was added in version 1.5.0.
 
 How to use mmap() directly to improve capture process
 =====================================================
 
-From the system calls stand point, the use of PACKET_MMAP involves
+From the system calls stand point, the use of PACKET mmap() involves
 the following process::
 
 
@@ -78,7 +78,7 @@ the following process::
 
 
 socket creation and destruction is straight forward, and is done
-the same way with or without PACKET_MMAP::
+the same way with or without PACKET mmap()::
 
  int fd = socket(PF_PACKET, mode, htons(ETH_P_ALL));
 
@@ -91,12 +91,12 @@ by the kernel.
 The destruction of the socket and all associated resources
 is done by a simple call to close(fd).
 
-Similarly as without PACKET_MMAP, it is possible to use one socket
+Similarly as without PACKET mmap(), it is possible to use one socket
 for capture and transmission. This can be done by mapping the
 allocated RX and TX buffer ring with a single mmap() call.
 See "Mapping and use of the circular buffer (ring)".
 
-Next I will describe PACKET_MMAP settings and its constraints,
+Next I will describe PACKET mmap() settings and its constraints,
 also the mapping of the circular buffer in the user process and
 the use of this buffer.
 
@@ -183,10 +183,10 @@ can set tp_net (with SOCK_DGRAM) or tp_mac (with SOCK_RAW). In order
 to make this work it must be enabled previously with setsockopt()
 and the PACKET_TX_HAS_OFF option.
 
-PACKET_MMAP settings
-====================
+PACKET mmap() settings
+======================
 
-To setup PACKET_MMAP from user level code is done with a call like
+To setup PACKET mmap() from user level code is done with a call like
 
  - Capture process::
 
@@ -247,13 +247,12 @@ be spawned across two blocks, so there are some details you have to take into
 account when choosing the frame_size. See "Mapping and use of the circular
 buffer (ring)".
 
-PACKET_MMAP setting constraints
-===============================
+PACKET mmap() setting constraints
+=================================
 
 In kernel versions prior to 2.4.26 (for the 2.4 branch) and 2.6.5 (2.6 branch),
-the PACKET_MMAP buffer could hold only 32768 frames in a 32 bit architecture or
-16384 in a 64 bit architecture. For information on these kernel versions
-see http://pusa.uv.es/~ulisses/packet_mmap/packet_mmap.pre-2.4.26_2.6.5.txt
+the PACKET mmap() buffer could hold only 32768 frames in a 32 bit architecture
+or 16384 in a 64 bit architecture.
 
 Block size limit
 ----------------
@@ -285,7 +284,7 @@ system call.
 Block number limit
 ------------------
 
-To understand the constraints of PACKET_MMAP, we have to see the structure
+To understand the constraints of PACKET mmap(), we have to see the structure
 used to hold the pointers to each block.
 
 Currently, this structure is a dynamically allocated vector with kmalloc
@@ -315,8 +314,8 @@ pointers to blocks is::
 
      131072/4 = 32768 blocks
 
-PACKET_MMAP buffer size calculator
-==================================
+PACKET mmap() buffer size calculator
+====================================
 
 Definitions:
 
@@ -372,9 +371,9 @@ Other constraints
 
 If you check the source code you will see that what I draw here as a frame
 is not only the link level frame. At the beginning of each frame there is a
-header called struct tpacket_hdr used in PACKET_MMAP to hold link level's frame
-meta information like timestamp. So what we draw here a frame it's really
-the following (from include/linux/if_packet.h)::
+header called struct tpacket_hdr used in PACKET mmap() to hold link level's
+frame meta information like timestamp. So what we draw here a frame it's
+really the following (from include/linux/if_packet.h)::
 
  /*
    Frame structure:
-- 
2.29.2


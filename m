Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0C281C1894
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 16:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730396AbgEAOrz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 10:47:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:52674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729374AbgEAOpI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 10:45:08 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F07A124954;
        Fri,  1 May 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588344305;
        bh=0GqCfM9Pak+Kvtv7JmtzSFjTvzefUCQusYq9G06vvZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ywMs4KS6M+ktZVwpYfW7vv+LCTix+aqywjwC1X/9VYCwwM9AMRESb3mcUE1Z8IcU2
         lZTD17RTwZ0+qP5/+wK1rLf6jG1ROjmsmK4cFfSVAA0P/dNW+HiAsxkmWP09g5//Nt
         FOCB23It2r0iwMAgoYFFUOWm4OyesWQD6Bq/w67s=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUWuT-00FCcZ-8z; Fri, 01 May 2020 16:45:01 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 02/37] docs: networking: convert udplite.txt to ReST
Date:   Fri,  1 May 2020 16:44:24 +0200
Message-Id: <1fda335aa18ec8348b99f40dde71a405764f82a3.1588344146.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588344146.git.mchehab+huawei@kernel.org>
References: <cover.1588344146.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust titles and chapters, adding proper markups;
- mark lists as such;
- mark tables as such;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |   1 +
 .../networking/{udplite.txt => udplite.rst}   | 175 ++++++++++--------
 2 files changed, 95 insertions(+), 81 deletions(-)
 rename Documentation/networking/{udplite.txt => udplite.rst} (65%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index e7a683f0528d..ca0b0dbfd9ad 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -112,6 +112,7 @@ Contents:
    timestamping
    tproxy
    tuntap
+   udplite
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/udplite.txt b/Documentation/networking/udplite.rst
similarity index 65%
rename from Documentation/networking/udplite.txt
rename to Documentation/networking/udplite.rst
index 53a726855e49..2c225f28b7b2 100644
--- a/Documentation/networking/udplite.txt
+++ b/Documentation/networking/udplite.rst
@@ -1,6 +1,8 @@
-  ===========================================================================
-                      The UDP-Lite protocol (RFC 3828)
-  ===========================================================================
+.. SPDX-License-Identifier: GPL-2.0
+
+================================
+The UDP-Lite protocol (RFC 3828)
+================================
 
 
   UDP-Lite is a Standards-Track IETF transport protocol whose characteristic
@@ -11,39 +13,43 @@
   This file briefly describes the existing kernel support and the socket API.
   For in-depth information, you can consult:
 
-   o The UDP-Lite Homepage:
-	http://web.archive.org/web/*/http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/ 
-       From here you can also download some example application source code.
+   - The UDP-Lite Homepage:
+     http://web.archive.org/web/%2E/http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/
 
-   o The UDP-Lite HOWTO on
-       http://web.archive.org/web/*/http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/
-	files/UDP-Lite-HOWTO.txt
+     From here you can also download some example application source code.
 
-   o The Wireshark UDP-Lite WiKi (with capture files):
-       https://wiki.wireshark.org/Lightweight_User_Datagram_Protocol
+   - The UDP-Lite HOWTO on
+     http://web.archive.org/web/%2E/http://www.erg.abdn.ac.uk/users/gerrit/udp-lite/files/UDP-Lite-HOWTO.txt
 
-   o The Protocol Spec, RFC 3828, http://www.ietf.org/rfc/rfc3828.txt
+   - The Wireshark UDP-Lite WiKi (with capture files):
+     https://wiki.wireshark.org/Lightweight_User_Datagram_Protocol
 
+   - The Protocol Spec, RFC 3828, http://www.ietf.org/rfc/rfc3828.txt
 
-  I) APPLICATIONS
+
+1. Applications
+===============
 
   Several applications have been ported successfully to UDP-Lite. Ethereal
-  (now called wireshark) has UDP-Litev4/v6 support by default. 
+  (now called wireshark) has UDP-Litev4/v6 support by default.
+
   Porting applications to UDP-Lite is straightforward: only socket level and
   IPPROTO need to be changed; senders additionally set the checksum coverage
   length (default = header length = 8). Details are in the next section.
 
-
-  II) PROGRAMMING API
+2. Programming API
+==================
 
   UDP-Lite provides a connectionless, unreliable datagram service and hence
   uses the same socket type as UDP. In fact, porting from UDP to UDP-Lite is
-  very easy: simply add `IPPROTO_UDPLITE' as the last argument of the socket(2)
-  call so that the statement looks like:
+  very easy: simply add ``IPPROTO_UDPLITE`` as the last argument of the
+  socket(2) call so that the statement looks like::
 
       s = socket(PF_INET, SOCK_DGRAM, IPPROTO_UDPLITE);
 
-                      or, respectively,
+  or, respectively,
+
+  ::
 
       s = socket(PF_INET6, SOCK_DGRAM, IPPROTO_UDPLITE);
 
@@ -56,10 +62,10 @@
 
     * Sender checksum coverage: UDPLITE_SEND_CSCOV
 
-      For example,
+      For example::
 
-        int val = 20;
-        setsockopt(s, SOL_UDPLITE, UDPLITE_SEND_CSCOV, &val, sizeof(int));
+	int val = 20;
+	setsockopt(s, SOL_UDPLITE, UDPLITE_SEND_CSCOV, &val, sizeof(int));
 
       sets the checksum coverage length to 20 bytes (12b data + 8b header).
       Of each packet only the first 20 bytes (plus the pseudo-header) will be
@@ -74,10 +80,10 @@
       that of a traffic filter: when enabled, it instructs the kernel to drop
       all packets which have a coverage _less_ than this value. For example, if
       RTP and UDP headers are to be protected, a receiver can enforce that only
-      packets with a minimum coverage of 20 are admitted:
+      packets with a minimum coverage of 20 are admitted::
 
-        int min = 20;
-        setsockopt(s, SOL_UDPLITE, UDPLITE_RECV_CSCOV, &min, sizeof(int));
+	int min = 20;
+	setsockopt(s, SOL_UDPLITE, UDPLITE_RECV_CSCOV, &min, sizeof(int));
 
   The calls to getsockopt(2) are analogous. Being an extension and not a stand-
   alone protocol, all socket options known from UDP can be used in exactly the
@@ -85,18 +91,18 @@
 
   A detailed discussion of UDP-Lite checksum coverage options is in section IV.
 
-
-  III) HEADER FILES
+3. Header Files
+===============
 
   The socket API requires support through header files in /usr/include:
 
     * /usr/include/netinet/in.h
-        to define IPPROTO_UDPLITE
+      to define IPPROTO_UDPLITE
 
     * /usr/include/netinet/udplite.h
-        for UDP-Lite header fields and protocol constants
+      for UDP-Lite header fields and protocol constants
 
-  For testing purposes, the following can serve as a `mini' header file:
+  For testing purposes, the following can serve as a ``mini`` header file::
 
     #define IPPROTO_UDPLITE       136
     #define SOL_UDPLITE           136
@@ -105,8 +111,9 @@
 
   Ready-made header files for various distros are in the UDP-Lite tarball.
 
+4. Kernel Behaviour with Regards to the Various Socket Options
+==============================================================
 
-  IV) KERNEL BEHAVIOUR WITH REGARD TO THE VARIOUS SOCKET OPTIONS
 
   To enable debugging messages, the log level need to be set to 8, as most
   messages use the KERN_DEBUG level (7).
@@ -136,13 +143,13 @@
   3) Disabling the Checksum Computation
 
   On both sender and receiver, checksumming will always be performed
-  and cannot be disabled using SO_NO_CHECK. Thus
+  and cannot be disabled using SO_NO_CHECK. Thus::
 
-        setsockopt(sockfd, SOL_SOCKET, SO_NO_CHECK,  ... );
+	setsockopt(sockfd, SOL_SOCKET, SO_NO_CHECK,  ... );
 
-  will always will be ignored, while the value of
+  will always will be ignored, while the value of::
 
-        getsockopt(sockfd, SOL_SOCKET, SO_NO_CHECK, &value, ...);
+	getsockopt(sockfd, SOL_SOCKET, SO_NO_CHECK, &value, ...);
 
   is meaningless (as in TCP). Packets with a zero checksum field are
   illegal (cf. RFC 3828, sec. 3.1) and will be silently discarded.
@@ -167,15 +174,15 @@
   first one contains the L4 header.
 
   The send buffer size has implications on the checksum coverage length.
-  Consider the following example:
+  Consider the following example::
 
-  Payload: 1536 bytes          Send Buffer:     1024 bytes
-  MTU:     1500 bytes          Coverage Length:  856 bytes
+    Payload: 1536 bytes          Send Buffer:     1024 bytes
+    MTU:     1500 bytes          Coverage Length:  856 bytes
 
-  UDP-Lite will ship the 1536 bytes in two separate packets:
+  UDP-Lite will ship the 1536 bytes in two separate packets::
 
-  Packet 1: 1024 payload + 8 byte header + 20 byte IP header = 1052 bytes
-  Packet 2:  512 payload + 8 byte header + 20 byte IP header =  540 bytes
+    Packet 1: 1024 payload + 8 byte header + 20 byte IP header = 1052 bytes
+    Packet 2:  512 payload + 8 byte header + 20 byte IP header =  540 bytes
 
   The coverage packet covers the UDP-Lite header and 848 bytes of the
   payload in the first packet, the second packet is fully covered. Note
@@ -184,17 +191,17 @@
   length in such cases.
 
   As an example of what happens when one UDP-Lite packet is split into
-  several tiny fragments, consider the following example.
+  several tiny fragments, consider the following example::
 
-  Payload: 1024 bytes            Send buffer size: 1024 bytes
-  MTU:      300 bytes            Coverage length:   575 bytes
+    Payload: 1024 bytes            Send buffer size: 1024 bytes
+    MTU:      300 bytes            Coverage length:   575 bytes
 
-  +-+-----------+--------------+--------------+--------------+
-  |8|    272    |      280     |     280      |     280      |
-  +-+-----------+--------------+--------------+--------------+
-               280            560            840           1032
-                                    ^
-  *****checksum coverage*************
+    +-+-----------+--------------+--------------+--------------+
+    |8|    272    |      280     |     280      |     280      |
+    +-+-----------+--------------+--------------+--------------+
+		280            560            840           1032
+					^
+    *****checksum coverage*************
 
   The UDP-Lite module generates one 1032 byte packet (1024 + 8 byte
   header). According to the interface MTU, these are split into 4 IP
@@ -208,7 +215,7 @@
   lengths), only the first fragment needs to be considered. When using
   larger checksum coverage lengths, each eligible fragment needs to be
   checksummed. Suppose we have a checksum coverage of 3062. The buffer
-  of 3356 bytes will be split into the following fragments:
+  of 3356 bytes will be split into the following fragments::
 
     Fragment 1: 1280 bytes carrying  1232 bytes of UDP-Lite data
     Fragment 2: 1280 bytes carrying  1232 bytes of UDP-Lite data
@@ -222,57 +229,63 @@
   performance over wireless (or generally noisy) links and thus smaller
   coverage lengths are likely to be expected.
 
-
-  V) UDP-LITE RUNTIME STATISTICS AND THEIR MEANING
+5. UDP-Lite Runtime Statistics and their Meaning
+================================================
 
   Exceptional and error conditions are logged to syslog at the KERN_DEBUG
   level.  Live statistics about UDP-Lite are available in /proc/net/snmp
-  and can (with newer versions of netstat) be viewed using
+  and can (with newer versions of netstat) be viewed using::
 
-                            netstat -svu
+			    netstat -svu
 
   This displays UDP-Lite statistics variables, whose meaning is as follows.
 
-   InDatagrams:     The total number of datagrams delivered to users.
+   ============     =====================================================
+   InDatagrams      The total number of datagrams delivered to users.
 
-   NoPorts:         Number of packets received to an unknown port.
-                    These cases are counted separately (not as InErrors).
+   NoPorts          Number of packets received to an unknown port.
+		    These cases are counted separately (not as InErrors).
 
-   InErrors:        Number of erroneous UDP-Lite packets. Errors include:
-                      * internal socket queue receive errors
-                      * packet too short (less than 8 bytes or stated
-                        coverage length exceeds received length)
-                      * xfrm4_policy_check() returned with error
-                      * application has specified larger min. coverage
-                        length than that of incoming packet
-                      * checksum coverage violated
-                      * bad checksum
+   InErrors         Number of erroneous UDP-Lite packets. Errors include:
 
-   OutDatagrams:    Total number of sent datagrams.
+		      * internal socket queue receive errors
+		      * packet too short (less than 8 bytes or stated
+			coverage length exceeds received length)
+		      * xfrm4_policy_check() returned with error
+		      * application has specified larger min. coverage
+			length than that of incoming packet
+		      * checksum coverage violated
+		      * bad checksum
+
+   OutDatagrams     Total number of sent datagrams.
+   ============     =====================================================
 
    These statistics derive from the UDP MIB (RFC 2013).
 
-
-  VI) IPTABLES
+6. IPtables
+===========
 
   There is packet match support for UDP-Lite as well as support for the LOG target.
-  If you copy and paste the following line into /etc/protocols,
+  If you copy and paste the following line into /etc/protocols::
 
-  udplite 136     UDP-Lite        # UDP-Lite [RFC 3828]
+    udplite 136     UDP-Lite        # UDP-Lite [RFC 3828]
 
-  then
-              iptables -A INPUT -p udplite -j LOG
+  then::
+
+	      iptables -A INPUT -p udplite -j LOG
 
   will produce logging output to syslog. Dropping and rejecting packets also works.
 
-
-  VII) MAINTAINER ADDRESS
+7. Maintainer Address
+=====================
 
   The UDP-Lite patch was developed at
-                    University of Aberdeen
-                    Electronics Research Group
-                    Department of Engineering
-                    Fraser Noble Building
-                    Aberdeen AB24 3UE; UK
+
+		    University of Aberdeen
+		    Electronics Research Group
+		    Department of Engineering
+		    Fraser Noble Building
+		    Aberdeen AB24 3UE; UK
+
   The current maintainer is Gerrit Renker, <gerrit@erg.abdn.ac.uk>. Initial
   code was developed by William  Stanislaus, <william@erg.abdn.ac.uk>.
-- 
2.25.4


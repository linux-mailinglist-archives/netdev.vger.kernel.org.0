Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF3D215D54
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 19:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbgGFRjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 13:39:06 -0400
Received: from smtp.al2klimov.de ([78.46.175.9]:45778 "EHLO smtp.al2klimov.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729636AbgGFRjG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 13:39:06 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        by smtp.al2klimov.de (Postfix) with ESMTPA id 73664BC126;
        Mon,  6 Jul 2020 17:38:58 +0000 (UTC)
From:   "Alexander A. Klimov" <grandmaster@al2klimov.de>
To:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        kuba@kernel.org, paul@paul-moore.com, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, edumazet@google.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Cc:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Subject: [PATCH] Replace HTTP links with HTTPS ones: IPv*
Date:   Mon,  6 Jul 2020 19:38:50 +0200
Message-Id: <20200706173850.19304-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: +++++
X-Spam-Level: *****
Authentication-Results: smtp.al2klimov.de;
        auth=pass smtp.auth=aklimov@al2klimov.de smtp.mailfrom=grandmaster@al2klimov.de
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Rationale:
Reduces attack surface on kernel devs opening the links for MITM
as HTTPS traffic is much harder to manipulate.

Deterministic algorithm:
For each file:
  If not .svg:
    For each line:
      If doesn't contain `\bxmlns\b`:
        For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
          If both the HTTP and HTTPS versions
          return 200 OK and serve the same content:
            Replace HTTP with HTTPS.

Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
---
 Continuing my work started at 93431e0607e5.

 If there are any URLs to be removed completely or at least not HTTPSified:
 Just clearly say so and I'll *undo my change*.
 See also https://lkml.org/lkml/2020/6/27/64

 If there are any valid, but yet not changed URLs:
 See https://lkml.org/lkml/2020/6/26/837

 net/ipv4/Kconfig                   | 8 ++++----
 net/ipv4/cipso_ipv4.c              | 4 ++--
 net/ipv4/fib_trie.c                | 2 +-
 net/ipv4/netfilter/ipt_CLUSTERIP.c | 2 +-
 net/ipv4/tcp_highspeed.c           | 2 +-
 net/ipv4/tcp_htcp.c                | 2 +-
 net/ipv4/tcp_input.c               | 2 +-
 net/ipv4/tcp_veno.c                | 2 +-
 net/ipv6/Kconfig                   | 2 +-
 9 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/ipv4/Kconfig b/net/ipv4/Kconfig
index e64e59b536d3..60db5a6487cc 100644
--- a/net/ipv4/Kconfig
+++ b/net/ipv4/Kconfig
@@ -10,7 +10,7 @@ config IP_MULTICAST
 	  intend to participate in the MBONE, a high bandwidth network on top
 	  of the Internet which carries audio and video broadcasts. More
 	  information about the MBONE is on the WWW at
-	  <http://www.savetz.com/mbone/>. For most people, it's safe to say N.
+	  <https://www.savetz.com/mbone/>. For most people, it's safe to say N.
 
 config IP_ADVANCED_ROUTER
 	bool "IP: advanced router"
@@ -73,7 +73,7 @@ config IP_MULTIPLE_TABLES
 
 	  If you need more information, see the Linux Advanced
 	  Routing and Traffic Control documentation at
-	  <http://lartc.org/howto/lartc.rpdb.html>
+	  <https://lartc.org/howto/lartc.rpdb.html>
 
 	  If unsure, say N.
 
@@ -280,7 +280,7 @@ config SYN_COOKIES
 	  continue to connect, even when your machine is under attack. There
 	  is no need for the legitimate users to change their TCP/IP software;
 	  SYN cookies work transparently to them. For technical information
-	  about SYN cookies, check out <http://cr.yp.to/syncookies.html>.
+	  about SYN cookies, check out <https://cr.yp.to/syncookies.html>.
 
 	  If you are SYN flooded, the source address reported by the kernel is
 	  likely to have been forged by the attacker; it is only reported as
@@ -525,7 +525,7 @@ config TCP_CONG_HSTCP
 	  A modification to TCP's congestion control mechanism for use
 	  with large congestion windows. A table indicates how much to
 	  increase the congestion window by when an ACK is received.
-	  For more detail see http://www.icir.org/floyd/hstcp.html
+	  For more detail see https://www.icir.org/floyd/hstcp.html
 
 config TCP_CONG_HYBLA
 	tristate "TCP-Hybla congestion control algorithm"
diff --git a/net/ipv4/cipso_ipv4.c b/net/ipv4/cipso_ipv4.c
index a23094b050f8..0f1b9065c0a6 100644
--- a/net/ipv4/cipso_ipv4.c
+++ b/net/ipv4/cipso_ipv4.c
@@ -10,9 +10,9 @@
  *
  * The CIPSO draft specification can be found in the kernel's Documentation
  * directory as well as the following URL:
- *   http://tools.ietf.org/id/draft-ietf-cipso-ipsecurity-01.txt
+ *   https://tools.ietf.org/id/draft-ietf-cipso-ipsecurity-01.txt
  * The FIPS-188 specification can be found at the following URL:
- *   http://www.itl.nist.gov/fipspubs/fip188.htm
+ *   https://www.itl.nist.gov/fipspubs/fip188.htm
  *
  * Author: Paul Moore <paul.moore@hp.com>
  */
diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index 248f1c1959a6..dcb0802a47d5 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -13,7 +13,7 @@
  *
  * An experimental study of compression methods for dynamic tries
  * Stefan Nilsson and Matti Tikkanen. Algorithmica, 33(1):19-33, 2002.
- * http://www.csc.kth.se/~snilsson/software/dyntrie2/
+ * https://www.csc.kth.se/~snilsson/software/dyntrie2/
  *
  * IP-address lookup using LC-tries. Stefan Nilsson and Gunnar Karlsson
  * IEEE Journal on Selected Areas in Communications, 17(6):1083-1092, June 1999
diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index f8755a4ae9d4..a8b980ad11d4 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -3,7 +3,7 @@
  * (C) 2003-2004 by Harald Welte <laforge@netfilter.org>
  * based on ideas of Fabio Olive Leite <olive@unixforge.org>
  *
- * Development of this code funded by SuSE Linux AG, http://www.suse.com/
+ * Development of this code funded by SuSE Linux AG, https://www.suse.com/
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/module.h>
diff --git a/net/ipv4/tcp_highspeed.c b/net/ipv4/tcp_highspeed.c
index bfdfbb972c57..349069d6cd0a 100644
--- a/net/ipv4/tcp_highspeed.c
+++ b/net/ipv4/tcp_highspeed.c
@@ -2,7 +2,7 @@
 /*
  * Sally Floyd's High Speed TCP (RFC 3649) congestion control
  *
- * See http://www.icir.org/floyd/hstcp.html
+ * See https://www.icir.org/floyd/hstcp.html
  *
  * John Heffner <jheffner@psc.edu>
  */
diff --git a/net/ipv4/tcp_htcp.c b/net/ipv4/tcp_htcp.c
index 88e1f011afe0..55adcfcf96fe 100644
--- a/net/ipv4/tcp_htcp.c
+++ b/net/ipv4/tcp_htcp.c
@@ -4,7 +4,7 @@
  * R.N.Shorten, D.J.Leith:
  *   "H-TCP: TCP for high-speed and long-distance networks"
  *   Proc. PFLDnet, Argonne, 2004.
- * http://www.hamilton.ie/net/htcp3.pdf
+ * https://www.hamilton.ie/net/htcp3.pdf
  */
 
 #include <linux/mm.h>
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index f3a0eb139b76..1355888b9354 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -518,7 +518,7 @@ EXPORT_SYMBOL(tcp_initialize_rcv_mss);
  *
  * The algorithm for RTT estimation w/o timestamps is based on
  * Dynamic Right-Sizing (DRS) by Wu Feng and Mike Fisk of LANL.
- * <http://public.lanl.gov/radiant/pubs.html#DRS>
+ * <https://public.lanl.gov/radiant/pubs.html#DRS>
  *
  * More detail on this code can be found at
  * <http://staff.psc.edu/jheffner/>,
diff --git a/net/ipv4/tcp_veno.c b/net/ipv4/tcp_veno.c
index 50a9a6e2c4cd..cd50a61c9976 100644
--- a/net/ipv4/tcp_veno.c
+++ b/net/ipv4/tcp_veno.c
@@ -7,7 +7,7 @@
  *    "TCP Veno: TCP Enhancement for Transmission over Wireless Access Networks."
  *    IEEE Journal on Selected Areas in Communication,
  *    Feb. 2003.
- * 	See http://www.ie.cuhk.edu.hk/fileadmin/staff_upload/soung/Journal/J3.pdf
+ * 	See https://www.ie.cuhk.edu.hk/fileadmin/staff_upload/soung/Journal/J3.pdf
  */
 
 #include <linux/mm.h>
diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
index f4f19e89af5e..76bff79d6fed 100644
--- a/net/ipv6/Kconfig
+++ b/net/ipv6/Kconfig
@@ -14,7 +14,7 @@ menuconfig IPV6
 	  <https://en.wikipedia.org/wiki/IPv6>.
 	  For specific information about IPv6 under Linux, see
 	  Documentation/networking/ipv6.rst and read the HOWTO at
-	  <http://www.tldp.org/HOWTO/Linux+IPv6-HOWTO/>
+	  <https://www.tldp.org/HOWTO/Linux+IPv6-HOWTO/>
 
 	  To compile this protocol support as a module, choose M here: the
 	  module will be called ipv6.
-- 
2.27.0


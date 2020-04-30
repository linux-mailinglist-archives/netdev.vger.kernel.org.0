Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58FA11C015F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728230AbgD3QFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:05:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727845AbgD3QEj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:39 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6C61249A0;
        Thu, 30 Apr 2020 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=2bKHDTVX1tmuy9i5+dwnxfglvtOh3JSyI/oVDrRUSO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWLvoBhZZlv7vj9lk38wbvbIb6wd0og1ZUBgUgWkTQAxubALwdo/8KPeE7QXVt01d
         bOR6DexKkB0stClC0cFspRqu7wnd0dxD7SosvYBPM3AMeSMoJGrX9xCSs2kqJfCOlL
         jo3L7FwAOREwwWlZ9G6usP3gVSTn4IjXysUCOdHs=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxH5-Vq; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: [PATCH 37/37] docs: networking: convert tproxy.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:32 +0200
Message-Id: <864518c020140359601ce16eda38f00e9cef5a44.1588261997.git.mchehab+huawei@kernel.org>
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
- adjust title markup;
- mark code blocks and literals as such;
- adjust identation, whitespaces and blank lines where needed;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/index.rst            |  1 +
 .../networking/{tproxy.txt => tproxy.rst}     | 55 ++++++++++---------
 net/netfilter/Kconfig                         |  2 +-
 3 files changed, 32 insertions(+), 26 deletions(-)
 rename Documentation/networking/{tproxy.txt => tproxy.rst} (70%)

diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 8f9a84b8e3f2..b423b2db5f96 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -110,6 +110,7 @@ Contents:
    tcp-thin
    team
    timestamping
+   tproxy
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/tproxy.txt b/Documentation/networking/tproxy.rst
similarity index 70%
rename from Documentation/networking/tproxy.txt
rename to Documentation/networking/tproxy.rst
index b9a188823d9f..00dc3a1a66b4 100644
--- a/Documentation/networking/tproxy.txt
+++ b/Documentation/networking/tproxy.rst
@@ -1,3 +1,6 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+=========================
 Transparent proxy support
 =========================
 
@@ -11,39 +14,39 @@ From Linux 4.18 transparent proxy support is also available in nf_tables.
 ================================
 
 The idea is that you identify packets with destination address matching a local
-socket on your box, set the packet mark to a certain value:
+socket on your box, set the packet mark to a certain value::
 
-# iptables -t mangle -N DIVERT
-# iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
-# iptables -t mangle -A DIVERT -j MARK --set-mark 1
-# iptables -t mangle -A DIVERT -j ACCEPT
+    # iptables -t mangle -N DIVERT
+    # iptables -t mangle -A PREROUTING -p tcp -m socket -j DIVERT
+    # iptables -t mangle -A DIVERT -j MARK --set-mark 1
+    # iptables -t mangle -A DIVERT -j ACCEPT
 
-Alternatively you can do this in nft with the following commands:
+Alternatively you can do this in nft with the following commands::
 
-# nft add table filter
-# nft add chain filter divert "{ type filter hook prerouting priority -150; }"
-# nft add rule filter divert meta l4proto tcp socket transparent 1 meta mark set 1 accept
+    # nft add table filter
+    # nft add chain filter divert "{ type filter hook prerouting priority -150; }"
+    # nft add rule filter divert meta l4proto tcp socket transparent 1 meta mark set 1 accept
 
 And then match on that value using policy routing to have those packets
-delivered locally:
+delivered locally::
 
-# ip rule add fwmark 1 lookup 100
-# ip route add local 0.0.0.0/0 dev lo table 100
+    # ip rule add fwmark 1 lookup 100
+    # ip route add local 0.0.0.0/0 dev lo table 100
 
 Because of certain restrictions in the IPv4 routing output code you'll have to
 modify your application to allow it to send datagrams _from_ non-local IP
 addresses. All you have to do is enable the (SOL_IP, IP_TRANSPARENT) socket
-option before calling bind:
+option before calling bind::
 
-fd = socket(AF_INET, SOCK_STREAM, 0);
-/* - 8< -*/
-int value = 1;
-setsockopt(fd, SOL_IP, IP_TRANSPARENT, &value, sizeof(value));
-/* - 8< -*/
-name.sin_family = AF_INET;
-name.sin_port = htons(0xCAFE);
-name.sin_addr.s_addr = htonl(0xDEADBEEF);
-bind(fd, &name, sizeof(name));
+    fd = socket(AF_INET, SOCK_STREAM, 0);
+    /* - 8< -*/
+    int value = 1;
+    setsockopt(fd, SOL_IP, IP_TRANSPARENT, &value, sizeof(value));
+    /* - 8< -*/
+    name.sin_family = AF_INET;
+    name.sin_port = htons(0xCAFE);
+    name.sin_addr.s_addr = htonl(0xDEADBEEF);
+    bind(fd, &name, sizeof(name));
 
 A trivial patch for netcat is available here:
 http://people.netfilter.org/hidden/tproxy/netcat-ip_transparent-support.patch
@@ -61,10 +64,10 @@ be able to find out the original destination address. Even in case of TCP
 getting the original destination address is racy.)
 
 The 'TPROXY' target provides similar functionality without relying on NAT. Simply
-add rules like this to the iptables ruleset above:
+add rules like this to the iptables ruleset above::
 
-# iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
-  --tproxy-mark 0x1/0x1 --on-port 50080
+    # iptables -t mangle -A PREROUTING -p tcp --dport 80 -j TPROXY \
+      --tproxy-mark 0x1/0x1 --on-port 50080
 
 Or the following rule to nft:
 
@@ -82,10 +85,12 @@ nf_tables implementation.
 ====================================
 
 To use tproxy you'll need to have the following modules compiled for iptables:
+
  - NETFILTER_XT_MATCH_SOCKET
  - NETFILTER_XT_TARGET_TPROXY
 
 Or the floowing modules for nf_tables:
+
  - NFT_SOCKET
  - NFT_TPROXY
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 468fea1aebba..3a3915d2e1ea 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -1043,7 +1043,7 @@ config NETFILTER_XT_TARGET_TPROXY
 	  on Netfilter connection tracking and NAT, unlike REDIRECT.
 	  For it to work you will have to configure certain iptables rules
 	  and use policy routing. For more information on how to set it up
-	  see Documentation/networking/tproxy.txt.
+	  see Documentation/networking/tproxy.rst.
 
 	  To compile it as a module, choose M here.  If unsure, say N.
 
-- 
2.25.4


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404B7419663
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:29:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234823AbhI0ObY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:31:24 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:46933 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234722AbhI0ObX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 10:31:23 -0400
Received: from localhost.localdomain (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 18RESscQ018014;
        Mon, 27 Sep 2021 23:28:55 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 18RESscQ018014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1632752935;
        bh=DUzwqlLK+2/bQgtMloSja7qeTr9DPQ8fH+wM1BKUl/s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CxM1Sim9BaTNy9pvaNxQ9mr1evMMnaVqno9p6WELvPas8axHeEXNmIDqCWW/nBwlM
         L2uzSeyQecM1mAPjFxkDjYZBJgkjyBddbVaqtBfXnWQ/g9h8lm0OSJxArYzwFDS0oq
         JL3ThdKChDxv3GW7fgUAtzRwKbqF7fCzd4A34BlohkKjx8swQDz6jj+FOUuYkksGDM
         wKsN5LjqHhUqS3PL6bsGpu+9gYHnq7DCeh408tSo/591vRMgmtYPeaCzt70zSseUz4
         Da39In60l87tR9dOzuXRQfCvmuAL7Ovm8a8GR1GkOOsurncUYIYK1LrIG2jDYiZYyX
         nxUAKmvrR9+ng==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: ipv6: use ipv6-y directly instead of ipv6-objs
Date:   Mon, 27 Sep 2021 23:28:40 +0900
Message-Id: <20210927142840.13286-2-masahiroy@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210927142840.13286-1-masahiroy@kernel.org>
References: <20210927142840.13286-1-masahiroy@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kbuild supports <modname>-y as well as <modname>-objs.
This simplifies the Makefile.

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/ipv6/Makefile | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 061b74d5563d..3036a45e8a1e 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -5,14 +5,14 @@
 
 obj-$(CONFIG_IPV6) += ipv6.o
 
-ipv6-objs :=	af_inet6.o anycast.o ip6_output.o ip6_input.o addrconf.o \
+ipv6-y :=	af_inet6.o anycast.o ip6_output.o ip6_input.o addrconf.o \
 		addrlabel.o \
 		route.o ip6_fib.o ipv6_sockglue.o ndisc.o udp.o udplite.o \
 		raw.o icmp.o mcast.o reassembly.o tcp_ipv6.o ping.o \
 		exthdrs.o datagram.o ip6_flowlabel.o inet6_connection_sock.o \
 		udp_offload.o seg6.o fib6_notifier.o rpl.o ioam6.o
 
-ipv6-$(CONFIG_SYSCTL) = sysctl_net_ipv6.o
+ipv6-$(CONFIG_SYSCTL) += sysctl_net_ipv6.o
 ipv6-$(CONFIG_IPV6_MROUTE) += ip6mr.o
 
 ipv6-$(CONFIG_XFRM) += xfrm6_policy.o xfrm6_state.o xfrm6_input.o \
@@ -27,8 +27,6 @@ ipv6-$(CONFIG_IPV6_SEG6_HMAC) += seg6_hmac.o
 ipv6-$(CONFIG_IPV6_RPL_LWTUNNEL) += rpl_iptunnel.o
 ipv6-$(CONFIG_IPV6_IOAM6_LWTUNNEL) += ioam6_iptunnel.o
 
-ipv6-objs += $(ipv6-y)
-
 obj-$(CONFIG_INET6_AH) += ah6.o
 obj-$(CONFIG_INET6_ESP) += esp6.o
 obj-$(CONFIG_INET6_ESP_OFFLOAD) += esp6_offload.o
-- 
2.30.2


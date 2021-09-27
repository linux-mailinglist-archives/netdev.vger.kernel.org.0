Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F98419664
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 16:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234884AbhI0Ob0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 10:31:26 -0400
Received: from conuserg-10.nifty.com ([210.131.2.77]:46932 "EHLO
        conuserg-10.nifty.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234706AbhI0ObX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 10:31:23 -0400
Received: from localhost.localdomain (133-32-232-101.west.xps.vectant.ne.jp [133.32.232.101]) (authenticated)
        by conuserg-10.nifty.com with ESMTP id 18RESscP018014;
        Mon, 27 Sep 2021 23:28:54 +0900
DKIM-Filter: OpenDKIM Filter v2.10.3 conuserg-10.nifty.com 18RESscP018014
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nifty.com;
        s=dec2015msa; t=1632752935;
        bh=Gjv9cJ+2iXb72Ddz9MRlVxEqBR7PSJ3W+fmsaSs4+Dg=;
        h=From:To:Cc:Subject:Date:From;
        b=riIcYJsCN2bgEfe43mHgtXRJjap8ccP9VR1t82ogzQu+wRMkHZ8/agrQY/YjsP26Z
         NXS9R5dKmB9GiglV5TaEPmT5txaghcWT03n0zc9lCu3mhrvA5/sDb0jgYRe//r3233
         gyvQobyZGYJgq1MoD1k/OVVRn7Wlx7Q/ijC84ESLhE/IUSsOkMaR6dZxzx0sV+vzJS
         20VgVUbfJhgb/b0Wk2eUexGayaWvh2i9dPnMFGSXRsFN4F9knGUY6xHy5qpsLcUeMi
         EzwTVUe9Z7JKHhMyJ0CZFZKQuAH7ebr1kOd4wmMNsNoSPR8JUibQCSDmDw2jb2Uai9
         RU6ETgJpabSvQ==
X-Nifty-SrcIP: [133.32.232.101]
From:   Masahiro Yamada <masahiroy@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] net: ipv6: squash $(ipv6-offload) in Makefile
Date:   Mon, 27 Sep 2021 23:28:39 +0900
Message-Id: <20210927142840.13286-1-masahiroy@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Assign the objects directly to obj-$(CONFIG_INET).

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
---

 net/ipv6/Makefile | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/net/ipv6/Makefile b/net/ipv6/Makefile
index 1bc7e143217b..061b74d5563d 100644
--- a/net/ipv6/Makefile
+++ b/net/ipv6/Makefile
@@ -12,8 +12,6 @@ ipv6-objs :=	af_inet6.o anycast.o ip6_output.o ip6_input.o addrconf.o \
 		exthdrs.o datagram.o ip6_flowlabel.o inet6_connection_sock.o \
 		udp_offload.o seg6.o fib6_notifier.o rpl.o ioam6.o
 
-ipv6-offload :=	ip6_offload.o tcpv6_offload.o exthdrs_offload.o
-
 ipv6-$(CONFIG_SYSCTL) = sysctl_net_ipv6.o
 ipv6-$(CONFIG_IPV6_MROUTE) += ip6mr.o
 
@@ -48,7 +46,8 @@ obj-$(CONFIG_IPV6_GRE) += ip6_gre.o
 obj-$(CONFIG_IPV6_FOU) += fou6.o
 
 obj-y += addrconf_core.o exthdrs_core.o ip6_checksum.o ip6_icmp.o
-obj-$(CONFIG_INET) += output_core.o protocol.o $(ipv6-offload)
+obj-$(CONFIG_INET) += output_core.o protocol.o \
+			ip6_offload.o tcpv6_offload.o exthdrs_offload.o
 
 obj-$(subst m,y,$(CONFIG_IPV6)) += inet6_hashtables.o
 
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5604D4A4E2
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 17:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729414AbfFRPNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 11:13:34 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:40723 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729042AbfFRPNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 11:13:33 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 709B922387;
        Tue, 18 Jun 2019 11:13:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 18 Jun 2019 11:13:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=i13v3CpHeTNF7IWlczgJyD7CqSAXcgczSLG+k8/RqKU=; b=Ui/G2xgD
        LbJCAKO1EUJF7I2i/VVnxfTvlcQ6YQoPZXtUxpeZ71c6L1jmpqw50FK8YjlCP5BI
        HAUNUIkGsjQvV4yGccS6HHOLuNAdA6mpIrdMdLapG3a9Phu0Fk01nBk9587+aTaB
        Xb9zlREwAjhbnmK6FNy5Ja2kJ+C1dtncSRrfnMuN8lGCDIOKweu8Ky70NGuFHh6C
        XStHa/lVNu+M9kSQMECtavFLI5/vhdEGK0NK+JFcGNVunIth94o0LC2mtwj7hFt4
        ki1ar2mRvo3Nu6rJNBc6L0v2DEg8kRXvXuOiD5Zm45WJ9wKEYyJSWWZE7VBjQkg8
        Z6RCd9aPfq4BYA==
X-ME-Sender: <xms:nP8IXY9EeHM0RjkpdMkzbiUm-9DA5TkpMjV0QuIb2b3LEJtUks0AOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrtddtgdehhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgepvd
X-ME-Proxy: <xmx:nP8IXXFBxCugAHJN0_EluBjRYa1Tfv41C_4W67kCVxKbWTzziooMAA>
    <xmx:nP8IXStjLZCYmk3Mvh9ZL27mSaWyEYmUnrPiZVyMCdmETraQM33GMw>
    <xmx:nP8IXbkBsrI5tpKTkdSbqjXEbVaxOfJeEPc5e-c3rVo3MROU2hvNiw>
    <xmx:nP8IXZ5GSRuc1hAaCOaV9vJWU0MgstXKss7Du1tIC6wdD1rjn5UTfQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id CBC7D380089;
        Tue, 18 Jun 2019 11:13:30 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, dsahern@gmail.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 03/16] ipv6: Extend notifier info for multipath routes
Date:   Tue, 18 Jun 2019 18:12:45 +0300
Message-Id: <20190618151258.23023-4-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190618151258.23023-1-idosch@idosch.org>
References: <20190618151258.23023-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Extend the IPv6 FIB notifier info with number of sibling routes being
notified.

This will later allow listeners to process one notification for a
multipath routes instead of N, where N is the number of nexthops.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 include/net/ip6_fib.h |  7 +++++++
 net/ipv6/ip6_fib.c    | 17 +++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 1e92f1500b87..7c3d5ab05879 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -377,6 +377,8 @@ typedef struct rt6_info *(*pol_lookup_t)(struct net *,
 struct fib6_entry_notifier_info {
 	struct fib_notifier_info info; /* must be first */
 	struct fib6_info *rt;
+	unsigned int nsiblings;
+	bool multipath_rt;
 };
 
 /*
@@ -450,6 +452,11 @@ int call_fib6_entry_notifiers(struct net *net,
 			      enum fib_event_type event_type,
 			      struct fib6_info *rt,
 			      struct netlink_ext_ack *extack);
+int call_fib6_multipath_entry_notifiers(struct net *net,
+					enum fib_event_type event_type,
+					struct fib6_info *rt,
+					unsigned int nsiblings,
+					struct netlink_ext_ack *extack);
 void fib6_rt_update(struct net *net, struct fib6_info *rt,
 		    struct nl_info *info);
 void inet6_rt_notify(int event, struct fib6_info *rt, struct nl_info *info,
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 1cce2082279c..df08ba8fe6fc 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -381,6 +381,23 @@ int call_fib6_entry_notifiers(struct net *net,
 	return call_fib6_notifiers(net, event_type, &info.info);
 }
 
+int call_fib6_multipath_entry_notifiers(struct net *net,
+					enum fib_event_type event_type,
+					struct fib6_info *rt,
+					unsigned int nsiblings,
+					struct netlink_ext_ack *extack)
+{
+	struct fib6_entry_notifier_info info = {
+		.info.extack = extack,
+		.rt = rt,
+		.nsiblings = nsiblings,
+		.multipath_rt = true,
+	};
+
+	rt->fib6_table->fib_seq++;
+	return call_fib6_notifiers(net, event_type, &info.info);
+}
+
 struct fib6_dump_arg {
 	struct net *net;
 	struct notifier_block *nb;
-- 
2.20.1


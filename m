Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9193303EAC
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:28:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403894AbhAZN1J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:27:09 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:57993 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391909AbhAZNZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:25:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 29874952;
        Tue, 26 Jan 2021 08:24:23 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Jan 2021 08:24:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=qRstLR66cRVCVoZccihpXfano4geLk5M4JtCAiYeI9w=; b=dIXOLvYD
        3n4opHMspDwoB+8JOzeT2hRPkgOiv8k2URvvBB+WMt6x1Pvwmz4C+l4jdQa8AFCf
        O/c+HwaEwpSkC/Kri6WtMeX/TZ1XudxxLMMhVZVNvDFHBt6uT242LgoR0BYKNrZA
        obJrOYyQ1x3Imq7ij6Y+Y6WwDzIBfkf5tqYJxOByGuQBwzTLrgmzlsjP1/0TqthR
        kz3iZCJzAoTE28sxmd2GDvL0fEGf/LLZVZrEAABmabZ3V2tyBMsnY2S6X42EwAXu
        cprjZVsMYcql8Efl8IA0oJPST2/2KkhPNULOBzwM5+FzckrgoSE6TYGr7pnY6fCX
        6XZlEGpAFDRguA==
X-ME-Sender: <xms:BhgQYACVkX-D2mSs7SF9OrrKX81F62UCxm0zAmxGdYKsXRuJ3tUIyg>
    <xme:BhgQYCiN0MC2LvmuSKcrY3qqLJpUAb4Cm4Lplnfys7M9LXSp5vBZ2XC4lxqs2Yu6Z
    cP1T2CyobwB9ww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:BhgQYDli3j_JtRjjeWUxoVus5cSkX7biEnLYyPnHRSyjSRUiHCu1Vg>
    <xmx:BhgQYGx0Xj0bF_JqTzpux7urYKtpJaU5CfjR45X5kMA4ObdPew8gEA>
    <xmx:BhgQYFRepDUiwF6CCeLDUBJ53bzDF1qPycsN54jInfIaW2rMVWOpeg>
    <xmx:BhgQYEE6jrYQ2HU-2O0Y_50PX5LLgB18WT_c_OwFB-cFHKCm3yErWA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4DEF0108005C;
        Tue, 26 Jan 2021 08:24:20 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/10] net: ipv4: Publish fib_nlmsg_size()
Date:   Tue, 26 Jan 2021 15:23:05 +0200
Message-Id: <20210126132311.3061388-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126132311.3061388-1-idosch@idosch.org>
References: <20210126132311.3061388-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Publish fib_nlmsg_size() to allow it to be used later on from
fib_alias_hw_flags_set().

Remove the inline keyword since it shouldn't be used inside C files.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/fib_lookup.h    | 1 +
 net/ipv4/fib_semantics.c | 2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index b75db4dcbf5e..aff454ef0fa3 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -42,6 +42,7 @@ int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event,
 		  const struct fib_rt_info *fri, unsigned int flags);
 void rtmsg_fib(int event, __be32 key, struct fib_alias *fa, int dst_len,
 	       u32 tb_id, const struct nl_info *info, unsigned int nlm_flags);
+size_t fib_nlmsg_size(struct fib_info *fi);
 
 static inline void fib_result_assign(struct fib_result *res,
 				     struct fib_info *fi)
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index dba56fa5e2cd..4c38facf91c0 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -452,7 +452,7 @@ int ip_fib_check_default(__be32 gw, struct net_device *dev)
 	return -1;
 }
 
-static inline size_t fib_nlmsg_size(struct fib_info *fi)
+size_t fib_nlmsg_size(struct fib_info *fi)
 {
 	size_t payload = NLMSG_ALIGN(sizeof(struct rtmsg))
 			 + nla_total_size(4) /* RTA_TABLE */
-- 
2.29.2


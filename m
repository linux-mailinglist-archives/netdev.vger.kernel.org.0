Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82261303EAE
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 14:28:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404434AbhAZN1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 08:27:55 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:56637 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391901AbhAZNZM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:25:12 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 6A360917;
        Tue, 26 Jan 2021 08:24:20 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Jan 2021 08:24:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=jgi9n1f2qHyTYbRAwwhSsY9Zh/Wso8NWEW8FESGQ5y0=; b=pooIr12C
        uDgnZ5p7Ai47eZFU1tpOMblDTsqWMWHK82ESJMPeHk3PA9Z9oMolYWN3okegnq9g
        3C5NjpaWTGvFJ/rvGDWt4PAOwkTlhyNc+aUJJBXFuWWHRzuUkXxtfoRCuO87y/FZ
        46A90m3Ui7+U+bHG9ng5rMvmMPfjcLS/tXBaXFynQRV7G/KZoAFwBhGi4Q57uRFu
        0h1bHa66CqiJ5G29cwWNIpYgMdsGtGW7a3cjw1L2M5DZr3t0vSjoyWaAjCwxAVPv
        yWErmH7kzIXRopC2m9tPkt23e1Msp5yVrIoL4vK5oR0LXfLSKp84lUbyNCNznmYt
        69dbUYI9gfgLjA==
X-ME-Sender: <xms:AxgQYHmhS3J9g6XMN11BcmfRuLvZoefGhEZ3aFYQH1bh22_fh8UAqQ>
    <xme:AxgQYK2SyK4pw5vQG6M4G81kcDwMwsYruFgrhbKLquoRKY1RJowgmIfxdHXv5Y8A7
    tvJKJ_xJQN4bvs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:AxgQYNo5CtTgAmT5Et5tY8VVj6JrNHIwXV_hLCndR5s5oq_kdcsu1A>
    <xmx:AxgQYPnpLx5hD5Wu6wLT_OWtJWNHHd1-nv9m-jvTPQ1XXJ7qgHS0Lg>
    <xmx:AxgQYF0ZbMLEXQ6d-t6mpyv90zfE6Z6-Cff3vxUWSzpu_13ZB-pdxQ>
    <xmx:BBgQYPpWuNLvdBuAZa6In6gex2Tawkqx82twcSY9l37cc60bIfovSA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 6E828108005B;
        Tue, 26 Jan 2021 08:24:17 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/10] net: ipv4: Pass fib_rt_info as const to fib_dump_info()
Date:   Tue, 26 Jan 2021 15:23:04 +0200
Message-Id: <20210126132311.3061388-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126132311.3061388-1-idosch@idosch.org>
References: <20210126132311.3061388-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

fib_dump_info() does not change 'fri', so pass it as 'const'.
It will later allow us to invoke fib_dump_info() from
fib_alias_hw_flags_set().

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/fib_lookup.h    | 2 +-
 net/ipv4/fib_semantics.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/fib_lookup.h b/net/ipv4/fib_lookup.h
index 818916b2a04d..b75db4dcbf5e 100644
--- a/net/ipv4/fib_lookup.h
+++ b/net/ipv4/fib_lookup.h
@@ -39,7 +39,7 @@ int fib_nh_match(struct net *net, struct fib_config *cfg, struct fib_info *fi,
 		 struct netlink_ext_ack *extack);
 bool fib_metrics_match(struct fib_config *cfg, struct fib_info *fi);
 int fib_dump_info(struct sk_buff *skb, u32 pid, u32 seq, int event,
-		  struct fib_rt_info *fri, unsigned int flags);
+		  const struct fib_rt_info *fri, unsigned int flags);
 void rtmsg_fib(int event, __be32 key, struct fib_alias *fa, int dst_len,
 	       u32 tb_id, const struct nl_info *info, unsigned int nlm_flags);
 
diff --git a/net/ipv4/fib_semantics.c b/net/ipv4/fib_semantics.c
index b5400cec4f69..dba56fa5e2cd 100644
--- a/net/ipv4/fib_semantics.c
+++ b/net/ipv4/fib_semantics.c
@@ -1733,7 +1733,7 @@ static int fib_add_multipath(struct sk_buff *skb, struct fib_info *fi)
 #endif
 
 int fib_dump_info(struct sk_buff *skb, u32 portid, u32 seq, int event,
-		  struct fib_rt_info *fri, unsigned int flags)
+		  const struct fib_rt_info *fri, unsigned int flags)
 {
 	unsigned int nhs = fib_info_num_path(fri->fi);
 	struct fib_info *fi = fri->fi;
-- 
2.29.2


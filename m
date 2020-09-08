Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF20260E64
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728940AbgIHJMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:12 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:48827 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729114AbgIHJLy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 17B34874;
        Tue,  8 Sep 2020 05:11:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=x2YE2HhGdMKfWQw9Vh0Y4bavvo5QW/xLJ2bswJqDrTQ=; b=MpQ1buaK
        68psyrbqsbSRLJOQq8nZGu47ukh81/QaJSGYk/ce/h92mVC5PxJdNRVK5MBCZlz6
        fw3P56Up4zHN6ln8fq9oYQxxJn9C+cPata8Ys+aO6RaIgDXZsNd8LMgiNER9iNqx
        0xG3zOh9YEL5DwqwWMVKhzzHLZERYfyuJmRNu/gEZ+ZXju9Prr/k4ygX3JoldV1h
        uy7+A2e0uis6AH5Tbm9QtgRKjXOh3lKjZ+bQ+Jai1xleE72mtA/Ezkm4g0LLuWRW
        Ji2p7f4GHI0OHuPvghQqfaiRrAGu7dvQgOSUNMhL73iygRqiCWnf7c9yQZghNdV5
        0bVSMfgfNFBD4g==
X-ME-Sender: <xms:2EpXX7Jphuxu2VeqISLQzQWd3s8bU_3vDKhdOmkdHJ-tO6Yld-FL5g>
    <xme:2EpXX_IIP4xMKU0e7iPcR2BfrtKGADJ6SfSUpqdhgQ2dmwhzGPYjHNSKrWYOMnDy-
    AegYP9b_N_detU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2EpXXzuTWGsYukjrszm3yV5BPvHbRj0q9KeGzTlt9Zx8HKmO9-6AYA>
    <xmx:2EpXX0YeRXJeow8FZ4gKLbjFt1iE3GhRuNDm5_501vHlFsek-31DwA>
    <xmx:2EpXXyaMbJnq1mW7PEHs4JCmVvnl6dbUG3ppt5Rm2LedFTCt_SCG-Q>
    <xmx:2EpXXyHiqereP9GOIrO7_SV4evjnwJ82ePVT3fhAjmhJLKC65gCGAw>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 42D183064605;
        Tue,  8 Sep 2020 05:11:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 18/22] nexthop: Remove in-kernel route notifications when nexthop changes
Date:   Tue,  8 Sep 2020 12:10:33 +0300
Message-Id: <20200908091037.2709823-19-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Remove in-kernel route notifications when the configuration of their
nexthop changes.

These notifications are unnecessary because the route still uses the
same nexthop ID. A separate notification for the nexthop change itself
is now sent in the nexthop notification chain.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/fib_trie.c | 9 ---------
 net/ipv6/route.c    | 5 -----
 2 files changed, 14 deletions(-)

diff --git a/net/ipv4/fib_trie.c b/net/ipv4/fib_trie.c
index ffc5332f1390..28117c05dc35 100644
--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2100,15 +2100,6 @@ static void __fib_info_notify_update(struct net *net, struct fib_table *tb,
 			rtmsg_fib(RTM_NEWROUTE, htonl(n->key), fa,
 				  KEYLENGTH - fa->fa_slen, tb->tb_id,
 				  info, NLM_F_REPLACE);
-
-			/* call_fib_entry_notifiers will be removed when
-			 * in-kernel notifier is implemented and supported
-			 * for nexthop objects
-			 */
-			call_fib_entry_notifiers(net, FIB_EVENT_ENTRY_REPLACE,
-						 n->key,
-						 KEYLENGTH - fa->fa_slen, fa,
-						 NULL);
 		}
 	}
 }
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 5e7e25e2523a..6fb4a01edf87 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -6037,11 +6037,6 @@ void fib6_rt_update(struct net *net, struct fib6_info *rt,
 	struct sk_buff *skb;
 	int err = -ENOBUFS;
 
-	/* call_fib6_entry_notifiers will be removed when in-kernel notifier
-	 * is implemented and supported for nexthop objects
-	 */
-	call_fib6_entry_notifiers(net, FIB_EVENT_ENTRY_REPLACE, rt, NULL);
-
 	skb = nlmsg_new(rt6_nlmsg_size(rt), gfp_any());
 	if (!skb)
 		goto errout;
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28EA6260E71
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729390AbgIHJNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:13:11 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:41699 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729057AbgIHJLm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:42 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 076FF88A;
        Tue,  8 Sep 2020 05:11:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=5jyeMJOWHFVkW/vJfjvRbZgQ5QsRWcRKGm7hc5K9SSE=; b=Ll6niGmv
        XI2TZLHov/UUVqtA6/4mJvz/nCPMpFH0nsZQhwAJD8zrAzUtZY631VWnzSz/igwy
        Bvol4NXfbnVWz1my/O6ktzJxPYrQFy0fptOECUqgRrrsrZig/NcmA4a3PCaw11+f
        gK9LMD5Y4YojTemZb6Bpk8Nl1tUHN3ZvWQ8aBQbb5fD9VycJNRnrNNoyUzcuz0OF
        9l7pM8LDwLe5BKobyU993l/iblS0JlwT2tlzSh+j7kAc7/3H+hTA2DRLhNPRopSA
        tzA0e2lPT4KXfRGGnhd8xR+i0Z0Si3gY9tjp2frnidhe0UuycHEAvtN59hGBDULP
        VrVZfNtQcrY/yA==
X-ME-Sender: <xms:zEpXX48YDnLX7akrlu6c06VUJahbgJ-vr4Aypomri32Clz-RJ-7ReQ>
    <xme:zEpXXwsL2yeQuMbH6huccLBrWjFDH69Ya-d6tmVjCjFtpgEaCqwVUhM6BGf5zElg7
    cCCPsznmQDqBJw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zEpXX-Dts3Mnj2sobjTwAxj2sAiNrpKdFFOnEm19_lQ-wipy8-z6UQ>
    <xmx:zEpXX4f0trq6uu61WvXzZyv1oBmYl6sUeH8BolHZqqkcKr7X6kDlLA>
    <xmx:zEpXX9MrT5rPG6JZ7k1uwpnEAq1h1zELEVImjwb8sZ9WuIylNyW0zA>
    <xmx:zEpXX-qYsmIpVOAh5S1JGJtpPGNGyeVNLpOd5gAYBuGlIKeZbgve3A>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F6403064605;
        Tue,  8 Sep 2020 05:11:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 10/22] nexthop: Allow setting "offload" and "trap" indications on nexthops
Date:   Tue,  8 Sep 2020 12:10:25 +0300
Message-Id: <20200908091037.2709823-11-idosch@idosch.org>
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

Add a function that can be called by device drivers to set "offload" or
"trap" indication on nexthops following nexthop notifications.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/net/nexthop.h |  1 +
 net/ipv4/nexthop.c    | 21 +++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index 0bde1aa867c0..4147681e86d2 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -146,6 +146,7 @@ struct nh_notifier_info {
 
 int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
 int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb);
+void nexthop_hw_flags_set(struct net *net, u32 id, bool offload, bool trap);
 
 /* caller is holding rcu or rtnl; no reference taken to nexthop */
 struct nexthop *nexthop_find_by_id(struct net *net, u32 id);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 70c8ab6906ec..71605c612458 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -2080,6 +2080,27 @@ int unregister_nexthop_notifier(struct net *net, struct notifier_block *nb)
 }
 EXPORT_SYMBOL(unregister_nexthop_notifier);
 
+void nexthop_hw_flags_set(struct net *net, u32 id, bool offload, bool trap)
+{
+	struct nexthop *nexthop;
+
+	rcu_read_lock();
+
+	nexthop = nexthop_find_by_id(net, id);
+	if (!nexthop)
+		goto out;
+
+	nexthop->nh_flags &= ~(RTNH_F_OFFLOAD | RTNH_F_TRAP);
+	if (offload)
+		nexthop->nh_flags |= RTNH_F_OFFLOAD;
+	if (trap)
+		nexthop->nh_flags |= RTNH_F_TRAP;
+
+out:
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(nexthop_hw_flags_set);
+
 static void __net_exit nexthop_net_exit(struct net *net)
 {
 	rtnl_lock();
-- 
2.26.2


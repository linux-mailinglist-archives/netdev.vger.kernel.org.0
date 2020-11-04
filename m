Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E043E2A6543
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:32:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730178AbgKDNcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:32:21 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58637 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730108AbgKDNbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:55 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id C02315C0056;
        Wed,  4 Nov 2020 08:31:54 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=tBvw3ndUDOtbB/EZEj0CmKz964u4Ww9i42k29i5is3E=; b=kB8hRIQy
        O7AzKRWWBfVLMa9T2zf1cQRJRZT4ho7NoZahP0JuONo/DCQiQiZ8d5AOrd9gD7vH
        wHBiXxVKeOJNc/mkjFGf/qalLsGmDX+z7XN43MpDnzLxLmq6mAbHXpe9vy2VYe8E
        h0F6bvUE9jp5oLAiRmNcBtIZQG02eaqqnahTNeAk7imRp9cdV4yb8+o3w+88CuwR
        jlSg0VPNc4Z6/tdN/8Tnez7a/eU2AZuRl/77eUvh4EJkyuAvmr/1q39wlQOLtUyp
        X8S5waWffzPN6eYWT5Ou0Rxfdjxuced18VIjkZpDScsMzdut3G+sSjUg/xKdTnlo
        6eLlUfuuEn4nzA==
X-ME-Sender: <xms:Sq2iX7NIZ7Db-An_nNGs0yFLVs41R8ZXK6B7eOUbZPCsXKu23DbYSA>
    <xme:Sq2iX1_iRG795HrW8qiZyDsAm-RX7yiQK8yxEdq9-oewEU177UHrv7-nnwhP5osAL
    MSLJVyG-Ne2zjU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpeeinecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Sq2iX6QUqt_bOpJZATGdV7V_oUrX6GHEt7Ikcx5q_dG_spfkLrzTBg>
    <xmx:Sq2iX_uNCY4cBHrsm9irlS7xEXfyesQm448YmKcWRx4iYrXMHXbTEg>
    <xmx:Sq2iXze6SNm8L2y_IeTEKwClH0sgQH2_ICK02xtFGtXJimaKI2ao8w>
    <xmx:Sq2iX_4PSVY0UULzZ5W1OZFPTojn-wL9fqkjyYm0XwaqetBT4JCPMw>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E9913064610;
        Wed,  4 Nov 2020 08:31:53 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/18] nexthop: Emit a notification when a nexthop group is modified
Date:   Wed,  4 Nov 2020 15:30:32 +0200
Message-Id: <20201104133040.1125369-11-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When a single nexthop is replaced, the configuration of all the groups
using the nexthop is effectively modified. In this case, emit a
notification in the nexthop notification chain for each modified group
so that listeners would not need to keep track of which nexthops are
member in which groups.

The notification can only be emitted after the new configuration (i.e.,
'struct nh_info') is pointed at by the old shell (i.e., 'struct
nexthop'). Before that the configuration of the nexthop groups is still
the same as before the replacement.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/nexthop.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 11bfb1eb7f84..0e8e753956f1 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1099,7 +1099,9 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 				  struct nexthop *new,
 				  struct netlink_ext_ack *extack)
 {
+	u8 old_protocol, old_nh_flags;
 	struct nh_info *oldi, *newi;
+	struct nh_grp_entry *nhge;
 	int err;
 
 	if (new->is_group) {
@@ -1122,18 +1124,29 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 	newi->nh_parent = old;
 	oldi->nh_parent = new;
 
+	old_protocol = old->protocol;
+	old_nh_flags = old->nh_flags;
+
 	old->protocol = new->protocol;
 	old->nh_flags = new->nh_flags;
 
 	rcu_assign_pointer(old->nh_info, newi);
 	rcu_assign_pointer(new->nh_info, oldi);
 
+	/* Send a replace notification for all the groups using the nexthop. */
+	list_for_each_entry(nhge, &old->grp_list, nh_list) {
+		struct nexthop *nhp = nhge->nh_parent;
+
+		err = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp,
+					     extack);
+		if (err)
+			goto err_notify;
+	}
+
 	/* When replacing an IPv4 nexthop with an IPv6 nexthop, potentially
 	 * update IPv4 indication in all the groups using the nexthop.
 	 */
 	if (oldi->family == AF_INET && newi->family == AF_INET6) {
-		struct nh_grp_entry *nhge;
-
 		list_for_each_entry(nhge, &old->grp_list, nh_list) {
 			struct nexthop *nhp = nhge->nh_parent;
 			struct nh_group *nhg;
@@ -1144,6 +1157,21 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 	}
 
 	return 0;
+
+err_notify:
+	rcu_assign_pointer(new->nh_info, newi);
+	rcu_assign_pointer(old->nh_info, oldi);
+	old->nh_flags = old_nh_flags;
+	old->protocol = old_protocol;
+	oldi->nh_parent = old;
+	newi->nh_parent = new;
+	list_for_each_entry_continue_reverse(nhge, &old->grp_list, nh_list) {
+		struct nexthop *nhp = nhge->nh_parent;
+
+		call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, nhp, extack);
+	}
+	call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, old, extack);
+	return err;
 }
 
 static void __nexthop_replace_notify(struct net *net, struct nexthop *nh,
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2063260E6D
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729365AbgIHJM5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:57 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:51681 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729095AbgIHJLs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:48 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0B94C646;
        Tue,  8 Sep 2020 05:11:46 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=JhSWxr0w7rKjf1M2bDvQvK7C1x2TeUl7zMY+/vQ01Kw=; b=ojHMSPt7
        siYWzjoNKzEJV5JKHXp++SaUC+SjGHadF0FlsxkF9hy/IO8AHOGvs38ceF6fAYRS
        4yIPGpBz4s9e8EYSC1KcR3SU9OWpUoq40yPNqxM4QzOYSnenesgzehTViCkIUd1A
        zb9x4X7eTF4IkMgJ4Tf8pvyOhYGvlQ/wXBCNcxh7Y9wTDFZLoUXwpyr25BXFG4V9
        FmzOcp+Ah0OxJ3uYahJNykFc4mgoCyn7gKTzdV+vqdsPO94Q7b5/X1lkp0/pkvcb
        ny/5ispPMrBj/2SUcKB62R//vif5SL3W5OZq+YHrbozVDLfBeyBoJGDvtGsvyhPq
        iPy4VNM61sY6jw==
X-ME-Sender: <xms:0kpXXyrQgMLM-gxnqYYKPdPJ_AWC2uVpTuZindcDgAFBiw9w0jUNnQ>
    <xme:0kpXXwp6jCaV9iiaRPr64xNbbzefJTgg5ZgeTOqvyKX5ZbIQjdWqWd9oyFsTAsVJp
    d5y-wbEZeY0OtU>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:0kpXX3NKDcQvftcK9M6f6uMSlePiHkUKpChrg2_g3ehgqVrtXj_xfw>
    <xmx:0kpXXx5xcwuG4fRam5qpaYcn975rxwAMS698cYImgq4WSnsq7JFkmg>
    <xmx:0kpXXx7isx8I8OHh3Tz6LqwJn1pi5ZgEDB7PuNvaLnwjVtzM5yzDJQ>
    <xmx:0kpXX7kHoFyPk7vOpt2Cf0GsLGfdohipiRe0-5Xk0IfjVeNlt1qC4w>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id 479EE3064605;
        Tue,  8 Sep 2020 05:11:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 14/22] nexthop: Emit a notification when a nexthop group is modified
Date:   Tue,  8 Sep 2020 12:10:29 +0300
Message-Id: <20200908091037.2709823-15-idosch@idosch.org>
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
---
 net/ipv4/nexthop.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index b8a4abc00146..0edc3e73d416 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1098,7 +1098,9 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
 				  struct nexthop *new,
 				  struct netlink_ext_ack *extack)
 {
+	u8 old_protocol, old_nh_flags;
 	struct nh_info *oldi, *newi;
+	struct nh_grp_entry *nhge;
 	int err;
 
 	if (new->is_group) {
@@ -1121,18 +1123,29 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
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
@@ -1143,6 +1156,21 @@ static int replace_nexthop_single(struct net *net, struct nexthop *old,
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5979F2A6533
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 14:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729718AbgKDNbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 08:31:47 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53741 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729089AbgKDNbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 08:31:45 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 556A85C005B;
        Wed,  4 Nov 2020 08:31:44 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 04 Nov 2020 08:31:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=D0YnxT3Vt7RYkJyD3X5LYVVg4YwIkby+ZZdQiQJfKDY=; b=dCI03tdD
        1sdGRBEkxXBVf/1vk9oiTPsqFzGu8wCSXMG1IJ4NzDqVy1wbCdNLG/pT2h5qA5R0
        yYFerp6NsdChqQRahOxEQFByLasaDzRhOqxQ8WKh8AHVPgsZBCEh42R2htib6w2C
        gLym+Zbvuhcy3eAiO4jzmPlxQhMsqXSEWeKW72ukZrgms2T7pnuel34dLr9kgt7E
        ex3bAFvPYOAbMqRNZTenpo45XlnYfa48xbNLnT7VbjPRE4jRcrsT11D/7AxzuNIY
        kYrFk4BQyNZVix0y22OEyrQvrL41DF6Ji9XOOeib68VEtI8yRuIi9Asy/aKHhWrB
        Pr4erYk3Nh5v9w==
X-ME-Sender: <xms:QK2iX9dTsYue8ORoSudMXSwoJthBaWBspDFY54TKOTYQMgdFKg5mrQ>
    <xme:QK2iX7P4_c8TywOWjXEw2V9AZI1FbuWGhDckugkk7qoCTQVW_ktkeBc365PIRwYno
    GTY4485Qsl3F7g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddthedgheehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrvdeh
    heenucevlhhushhtvghrufhiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:QK2iX2gO-DI-wIzm3ZqQRZdiPK_ODsI5a_Ave-xEKs7BCORUK47ERQ>
    <xmx:QK2iX2_-Uk0JGn6i4jGjnncXhQii75tw8c_Yof7oCkI29ujjwh1Gcw>
    <xmx:QK2iX5vThYmkqJQGmfODBFpnsQfbevNBR10ZCieVr79rmSllroJ5Gw>
    <xmx:QK2iXxKWOq-Ojsb6m1r8Hj98UFkrnCDt5xhZ39VFYFX8m-DJAlGnfg>
Received: from shredder.mtl.com (unknown [84.229.152.255])
        by mail.messagingengine.com (Postfix) with ESMTPA id E64E13064684;
        Wed,  4 Nov 2020 08:31:42 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/18] nexthop: Prepare new notification info
Date:   Wed,  4 Nov 2020 15:30:25 +0200
Message-Id: <20201104133040.1125369-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201104133040.1125369-1-idosch@idosch.org>
References: <20201104133040.1125369-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Prepare the new notification information so that it could be passed to
listeners in the new patch.

Changes since RFC:
* Add a blank line in __nh_notifier_single_info_init()

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
---
 net/ipv4/nexthop.c | 109 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 109 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index f677cb12fd56..85a595883222 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -36,15 +36,124 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
 	[NHA_FDB]		= { .type = NLA_FLAG },
 };
 
+static bool nexthop_notifiers_is_empty(struct net *net)
+{
+	return !net->nexthop.notifier_chain.head;
+}
+
+static void
+__nh_notifier_single_info_init(struct nh_notifier_single_info *nh_info,
+			       const struct nexthop *nh)
+{
+	struct nh_info *nhi = rtnl_dereference(nh->nh_info);
+
+	nh_info->dev = nhi->fib_nhc.nhc_dev;
+	nh_info->gw_family = nhi->fib_nhc.nhc_gw_family;
+	if (nh_info->gw_family == AF_INET)
+		nh_info->ipv4 = nhi->fib_nhc.nhc_gw.ipv4;
+	else if (nh_info->gw_family == AF_INET6)
+		nh_info->ipv6 = nhi->fib_nhc.nhc_gw.ipv6;
+
+	nh_info->is_reject = nhi->reject_nh;
+	nh_info->is_fdb = nhi->fdb_nh;
+	nh_info->has_encap = !!nhi->fib_nhc.nhc_lwtstate;
+}
+
+static int nh_notifier_single_info_init(struct nh_notifier_info *info,
+					const struct nexthop *nh)
+{
+	info->nh = kzalloc(sizeof(*info->nh), GFP_KERNEL);
+	if (!info->nh)
+		return -ENOMEM;
+
+	__nh_notifier_single_info_init(info->nh, nh);
+
+	return 0;
+}
+
+static void nh_notifier_single_info_fini(struct nh_notifier_info *info)
+{
+	kfree(info->nh);
+}
+
+static int nh_notifier_grp_info_init(struct nh_notifier_info *info,
+				     const struct nexthop *nh)
+{
+	struct nh_group *nhg = rtnl_dereference(nh->nh_grp);
+	u16 num_nh = nhg->num_nh;
+	int i;
+
+	info->nh_grp = kzalloc(struct_size(info->nh_grp, nh_entries, num_nh),
+			       GFP_KERNEL);
+	if (!info->nh_grp)
+		return -ENOMEM;
+
+	info->nh_grp->num_nh = num_nh;
+	info->nh_grp->is_fdb = nhg->fdb_nh;
+
+	for (i = 0; i < num_nh; i++) {
+		struct nh_grp_entry *nhge = &nhg->nh_entries[i];
+
+		info->nh_grp->nh_entries[i].id = nhge->nh->id;
+		info->nh_grp->nh_entries[i].weight = nhge->weight;
+		__nh_notifier_single_info_init(&info->nh_grp->nh_entries[i].nh,
+					       nhge->nh);
+	}
+
+	return 0;
+}
+
+static void nh_notifier_grp_info_fini(struct nh_notifier_info *info)
+{
+	kfree(info->nh_grp);
+}
+
+static int nh_notifier_info_init(struct nh_notifier_info *info,
+				 const struct nexthop *nh)
+{
+	info->id = nh->id;
+	info->is_grp = nh->is_group;
+
+	if (info->is_grp)
+		return nh_notifier_grp_info_init(info, nh);
+	else
+		return nh_notifier_single_info_init(info, nh);
+}
+
+static void nh_notifier_info_fini(struct nh_notifier_info *info)
+{
+	if (info->is_grp)
+		nh_notifier_grp_info_fini(info);
+	else
+		nh_notifier_single_info_fini(info);
+}
+
 static int call_nexthop_notifiers(struct net *net,
 				  enum nexthop_event_type event_type,
 				  struct nexthop *nh,
 				  struct netlink_ext_ack *extack)
 {
+	struct nh_notifier_info info = {
+		.net = net,
+		.extack = extack,
+	};
 	int err;
 
+	ASSERT_RTNL();
+
+	if (nexthop_notifiers_is_empty(net))
+		return 0;
+
+	err = nh_notifier_info_init(&info, nh);
+	if (err) {
+		NL_SET_ERR_MSG(extack, "Failed to initialize nexthop notifier info");
+		return err;
+	}
+
 	err = blocking_notifier_call_chain(&net->nexthop.notifier_chain,
 					   event_type, nh);
+	nh_notifier_info_fini(&info);
+
 	return notifier_to_errno(err);
 }
 
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F72E260E72
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729413AbgIHJNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:13:12 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:32769 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729044AbgIHJLh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:37 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 664BA646;
        Tue,  8 Sep 2020 05:11:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=EO03t2BI30geItAzcYU+Y+QiqUjStCuvtu8RrRvwvks=; b=LYjXdXKU
        pP0v8ne0IhBEWFPgZXvOOBkfOBRXGndvldtdJ/w0vDec0TDsWD4blchly21bCqOv
        1m0cGjzn61fVRBMZ6qI2hH/X7kJKMFIGL9TsMoxX791awOPRkDK3xhq/qoiQIeEs
        nOo+9HOqmeVORDUwBPxQHre0PGCqlu4IqI9rlEmZRbZbj97JKoveA+bFX3xu14pa
        ReNEdwnJxwHgCsRyMCHQYW0whGWK6x4pyjAozTqZrAQNxxqlw93sLpyZuLhrGKfg
        927eKqMCxgLhc2NMiudW9HdcuUfrXYZgbkQ40rcLN90P2hRtJFD5aX77oiawoGcl
        MfySIexKS1r7gQ==
X-ME-Sender: <xms:yEpXX88RygDHvsolgc08WZNKhy-PEN4SsVeSw8Ipw3M9qxUfMADUtg>
    <xme:yEpXX0ur0xYjMDIqM9k13Yv1x8NsWrnqVurhmpLLcv8IURjheKFDCGUFCbA6xTqv-
    BHo1aTLmWkbxn4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:yEpXXyCpic7_6yU_O218MaB9q6FLAEu8RNWk8wXl4d69Xki1LdKeTg>
    <xmx:yEpXX8cu84zy-JSLOoxJ5xQHtLvhhKP-7r3YGZReOctnH4ZtiEaoDQ>
    <xmx:yEpXXxN5SW2E0SWR1zsja309yTu0auLBz_Ar4ItNypbJJlE2vtF5uw>
    <xmx:yEpXXypFfTCmnampDX7h8H1HNEbLEK5E8LVwtjpfTW_vDxHG1--Atg>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id B64303064605;
        Tue,  8 Sep 2020 05:11:34 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 07/22] nexthop: Prepare new notification info
Date:   Tue,  8 Sep 2020 12:10:22 +0300
Message-Id: <20200908091037.2709823-8-idosch@idosch.org>
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

Prepare the new notification information so that it could be passed to
listeners in the new patch.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv4/nexthop.c | 108 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 108 insertions(+)

diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index dafcb9f17250..68fd25c6eec7 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -36,15 +36,123 @@ static const struct nla_policy rtm_nh_policy[NHA_MAX + 1] = {
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
+	nh_info->is_reject = nhi->reject_nh;
+	nh_info->is_fdb = nhi->fdb_nh;
+	nh_info->is_encap = !!nhi->fib_nhc.nhc_lwtstate;
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


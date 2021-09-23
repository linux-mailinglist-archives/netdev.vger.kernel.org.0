Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7860C415E7B
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241036AbhIWMjs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:42179 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240874AbhIWMjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:43 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 52FCF5C0120;
        Thu, 23 Sep 2021 08:38:12 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 23 Sep 2021 08:38:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=EV5hjNqK/Vu6I6IrdZuln6wQ4H+xDFmLUmZ8Keta75I=; b=VzzsJEw0
        uAdzFpgsKW9/6pzeYG+jtLPKqf84BKOQf/OomPkTQ47pGT6swxtZly6sL28bUDXa
        b3aC+pWABxMrfFob2/2L1Iu6pAh6pmDSrVIjgdIuNdJibhU1lUK0JW/2MF4/iYKf
        D5h2r0UmQs9lJjRlrg49VDHfi23wuFMqPmDNN0Kl4tRLlvetSnVVdi4WUuXT8VKQ
        g2T4mssX1QCbrrOdP58b1JGtYFMAhekfKRIw1Ukrbir8G5pU5P9Frdkpp42EaZpW
        8e3KSZtqZ3gm/ZFXp9VSwlxQ9fyuGHz5to1b7R2x4yAJ2W9HGQVsftwOQBQEL6fW
        P3PCoPohxgHpEA==
X-ME-Sender: <xms:NHVMYZZsJktn7T96rhWMMXyWLz5NeNXWHivQSZFakoBiC0EEHrhWSg>
    <xme:NHVMYQYcKftQMb2PRztjgk9-j1H6e-MVgdz6D0Y2YJHm2o4MxuXW2i1ooX-ceAM3a
    mosDi24k0wGED0>
X-ME-Received: <xmr:NHVMYb-qluDG6QXpKzjAsN9gJiG3Awbo6p9M5BCC5_dIfa8E5J0EWra2-i-PG6s3TnvX6gpe7zA5GSd97_5k6HgqCQgx1lsFNbIq58NRa77J1Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NHVMYXq5hUwpepgF5s4daUjc9mjGytbYXqh3HzFaLaFyjSmTy1stiA>
    <xmx:NHVMYUpZT765AEPoyG_keoJ_NVaHc55DD8O3D6rt-cLIfSbJLe3LVQ>
    <xmx:NHVMYdQcIE-RqiehokZhrmx4cESxIXmX-9H_g4zE0HF3qs_1SBomjA>
    <xmx:NHVMYZARk4h3z6mHnJQEQ5uvcFvhELLDuCOSBUsVA_0IRTuycDDZ9g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/14] mlxsw: spectrum_ipip: Create common function for mlxsw_sp_ipip_ol_netdev_change_gre()
Date:   Thu, 23 Sep 2021 15:36:50 +0300
Message-Id: <20210923123700.885466-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The function mlxsw_sp_ipip_ol_netdev_change_gre4() contains code that
can be shared between IPv4 and IPv6.
The only difference is the way that arguments are taken from tunnel
parameters, which are different between IPv4 and IPv6.

For that, add structure 'mlxsw_sp_ipip_parms' to hold all the required
parameters for the function and save it as part of
'struct mlxsw_sp_ipip_entry' instead of the existing structure that is
not shared between IPv4 and IPv6. Add new operation as part of
'mlxsw_sp_ipip_ops' to initialize the new structure.

Then mlxsw_sp_ipip_ol_netdev_change_gre{4,6}() will prepare the new
structure and both will call the same function.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 69 ++++++++++++-------
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   | 16 ++++-
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 11 +--
 3 files changed, 59 insertions(+), 37 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 9aeb6fe76c06..2164e940abba 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -125,6 +125,21 @@ bool mlxsw_sp_l3addr_is_zero(union mlxsw_sp_l3addr addr)
 	return !memcmp(&addr, &naddr, sizeof(naddr));
 }
 
+static struct mlxsw_sp_ipip_parms
+mlxsw_sp_ipip_netdev_parms_init_gre4(const struct net_device *ol_dev)
+{
+	struct ip_tunnel_parm parms = mlxsw_sp_ipip_netdev_parms4(ol_dev);
+
+	return (struct mlxsw_sp_ipip_parms) {
+		.proto = MLXSW_SP_L3_PROTO_IPV4,
+		.saddr = mlxsw_sp_ipip_parms4_saddr(&parms),
+		.daddr = mlxsw_sp_ipip_parms4_daddr(&parms),
+		.link = parms.link,
+		.ikey = mlxsw_sp_ipip_parms4_ikey(&parms),
+		.okey = mlxsw_sp_ipip_parms4_okey(&parms),
+	};
+}
+
 static int
 mlxsw_sp_ipip_nexthop_update_gre4(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 				  struct mlxsw_sp_ipip_entry *ipip_entry,
@@ -231,48 +246,39 @@ mlxsw_sp_ipip_ol_loopback_config_gre4(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int
-mlxsw_sp_ipip_ol_netdev_change_gre4(struct mlxsw_sp *mlxsw_sp,
-				    struct mlxsw_sp_ipip_entry *ipip_entry,
-				    struct netlink_ext_ack *extack)
+mlxsw_sp_ipip_ol_netdev_change_gre(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_ipip_entry *ipip_entry,
+				   const struct mlxsw_sp_ipip_parms *new_parms,
+				   struct netlink_ext_ack *extack)
 {
-	union mlxsw_sp_l3addr old_saddr, new_saddr;
-	union mlxsw_sp_l3addr old_daddr, new_daddr;
-	struct ip_tunnel_parm new_parms;
+	const struct mlxsw_sp_ipip_parms *old_parms = &ipip_entry->parms;
 	bool update_tunnel = false;
 	bool update_decap = false;
 	bool update_nhs = false;
 	int err = 0;
 
-	new_parms = mlxsw_sp_ipip_netdev_parms4(ipip_entry->ol_dev);
-
-	new_saddr = mlxsw_sp_ipip_parms4_saddr(&new_parms);
-	old_saddr = mlxsw_sp_ipip_parms4_saddr(&ipip_entry->parms4);
-	new_daddr = mlxsw_sp_ipip_parms4_daddr(&new_parms);
-	old_daddr = mlxsw_sp_ipip_parms4_daddr(&ipip_entry->parms4);
-
-	if (!mlxsw_sp_l3addr_eq(&new_saddr, &old_saddr)) {
+	if (!mlxsw_sp_l3addr_eq(&new_parms->saddr, &old_parms->saddr)) {
 		u16 ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(ipip_entry->ol_dev);
 
 		/* Since the local address has changed, if there is another
 		 * tunnel with a matching saddr, both need to be demoted.
 		 */
 		if (mlxsw_sp_ipip_demote_tunnel_by_saddr(mlxsw_sp,
-							 MLXSW_SP_L3_PROTO_IPV4,
-							 new_saddr, ul_tb_id,
+							 new_parms->proto,
+							 new_parms->saddr,
+							 ul_tb_id,
 							 ipip_entry)) {
 			mlxsw_sp_ipip_entry_demote_tunnel(mlxsw_sp, ipip_entry);
 			return 0;
 		}
 
 		update_tunnel = true;
-	} else if ((mlxsw_sp_ipip_parms4_okey(&ipip_entry->parms4) !=
-		    mlxsw_sp_ipip_parms4_okey(&new_parms)) ||
-		   ipip_entry->parms4.link != new_parms.link) {
+	} else if (old_parms->okey != new_parms->okey ||
+		   old_parms->link != new_parms->link) {
 		update_tunnel = true;
-	} else if (!mlxsw_sp_l3addr_eq(&new_daddr, &old_daddr)) {
+	} else if (!mlxsw_sp_l3addr_eq(&new_parms->daddr, &old_parms->daddr)) {
 		update_nhs = true;
-	} else if (mlxsw_sp_ipip_parms4_ikey(&ipip_entry->parms4) !=
-		   mlxsw_sp_ipip_parms4_ikey(&new_parms)) {
+	} else if (old_parms->ikey != new_parms->ikey) {
 		update_decap = true;
 	}
 
@@ -288,14 +294,29 @@ mlxsw_sp_ipip_ol_netdev_change_gre4(struct mlxsw_sp *mlxsw_sp,
 		err = __mlxsw_sp_ipip_entry_update_tunnel(mlxsw_sp, ipip_entry,
 							  false, false, false,
 							  extack);
+	if (err)
+		return err;
+
+	ipip_entry->parms = *new_parms;
+	return 0;
+}
+
+static int
+mlxsw_sp_ipip_ol_netdev_change_gre4(struct mlxsw_sp *mlxsw_sp,
+				    struct mlxsw_sp_ipip_entry *ipip_entry,
+				    struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_ipip_parms new_parms;
 
-	ipip_entry->parms4 = new_parms;
-	return err;
+	new_parms = mlxsw_sp_ipip_netdev_parms_init_gre4(ipip_entry->ol_dev);
+	return mlxsw_sp_ipip_ol_netdev_change_gre(mlxsw_sp, ipip_entry,
+						  &new_parms, extack);
 }
 
 static const struct mlxsw_sp_ipip_ops mlxsw_sp_ipip_gre4_ops = {
 	.dev_type = ARPHRD_IPGRE,
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV4,
+	.parms_init = mlxsw_sp_ipip_netdev_parms_init_gre4,
 	.nexthop_update = mlxsw_sp_ipip_nexthop_update_gre4,
 	.decap_config = mlxsw_sp_ipip_decap_config_gre4,
 	.can_offload = mlxsw_sp_ipip_can_offload_gre4,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index f0837b42d1d6..bc6866d1c070 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -24,21 +24,31 @@ enum mlxsw_sp_ipip_type {
 	MLXSW_SP_IPIP_TYPE_MAX,
 };
 
+struct mlxsw_sp_ipip_parms {
+	enum mlxsw_sp_l3proto proto;
+	union mlxsw_sp_l3addr saddr;
+	union mlxsw_sp_l3addr daddr;
+	int link;
+	u32 ikey;
+	u32 okey;
+};
+
 struct mlxsw_sp_ipip_entry {
 	enum mlxsw_sp_ipip_type ipipt;
 	struct net_device *ol_dev; /* Overlay. */
 	struct mlxsw_sp_rif_ipip_lb *ol_lb;
 	struct mlxsw_sp_fib_entry *decap_fib_entry;
 	struct list_head ipip_list_node;
-	union {
-		struct ip_tunnel_parm parms4;
-	};
+	struct mlxsw_sp_ipip_parms parms;
 };
 
 struct mlxsw_sp_ipip_ops {
 	int dev_type;
 	enum mlxsw_sp_l3proto ul_proto; /* Underlay. */
 
+	struct mlxsw_sp_ipip_parms
+	(*parms_init)(const struct net_device *ol_dev);
+
 	int (*nexthop_update)(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
 			      struct mlxsw_sp_ipip_entry *ipip_entry,
 			      bool force, char *ratr_pl);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 61f1e7d58128..b79662048ef7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1131,16 +1131,7 @@ mlxsw_sp_ipip_entry_alloc(struct mlxsw_sp *mlxsw_sp,
 
 	ipip_entry->ipipt = ipipt;
 	ipip_entry->ol_dev = ol_dev;
-
-	switch (ipip_ops->ul_proto) {
-	case MLXSW_SP_L3_PROTO_IPV4:
-		ipip_entry->parms4 = mlxsw_sp_ipip_netdev_parms4(ol_dev);
-		break;
-	case MLXSW_SP_L3_PROTO_IPV6:
-		WARN_ON(1);
-		break;
-	}
-
+	ipip_entry->parms = ipip_ops->parms_init(ol_dev);
 	return ipip_entry;
 
 err_ol_ipip_lb_create:
-- 
2.31.1


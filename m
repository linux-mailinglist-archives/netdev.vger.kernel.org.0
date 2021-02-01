Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6CE30B0D9
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232819AbhBATw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:52:59 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:33319 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232908AbhBATwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:52:21 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 334AD580510;
        Mon,  1 Feb 2021 14:48:55 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 01 Feb 2021 14:48:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=gJECSoGeoCSJ3/4h0+eCt/052aJO0YbscpMqFyKoy+w=; b=opq0KEiD
        Y8G/a1eyodmAujz1umbORHoNDVCBeAZXtP5b4LWUMfWL433ajef24uxLfABo34wz
        2j2xchlzZPR4Se2tmuNquaHoVQBzVHLPmCzrGrVespjAq1lHZI9vDXSrg4QcDm2l
        4ta6lthOuzLYLO6kij82POhvASOUz82HMKXmOPqHKN34hlRlxEPr/7wJz/8JF0Kn
        b5Rj1h8EHBZThgNPdmvX+DrygvKMA9hK4NBomPCrCrFTXy9Qx7FwB6rYV5BFItk+
        V4TSBvzpmQZkO6BfsWPAC0ixZ1cixtVgf+mqptgH6r+9+6C5BdXIFNJETUvMsWE2
        ktRmtKp/tSXqzQ==
X-ME-Sender: <xms:J1sYYBjuH_F3NEHyz2X6FWnR4AB2-qgXIeWS-5HaR201qCLMVAGyfA>
    <xme:J1sYYGAMmPAsNLgwU3BE37256iYWcTK0m8iuxG5wK7RgyuhoowTL0DSkNbeZKNWGo
    bMZi6q4SiiJe0s>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfeekgddufedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:J1sYYBHdu6tjfv1Ojpq3JQVbSycm5JkPp5UNTOWEyPFtlXT9f5-0XA>
    <xmx:J1sYYGTSKbZs10v5p3IY7tirNQ8q3XC_lf5qo__IDd_KljItRJ_KOA>
    <xmx:J1sYYOwwSAsjwTxVndM_O_GLwFhd4BF4X5HOfBaF1IucWor4HB9eAw>
    <xmx:J1sYYNkr0NUKeDnLKNBvIqPzX-37nk_TkoXLHnJBOvLKLxpPuUhxzQ>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 082AB24005C;
        Mon,  1 Feb 2021 14:48:52 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        yoshfuji@linux-ipv6.org, jiri@nvidia.com, amcohen@nvidia.com,
        roopa@nvidia.com, bpoirier@nvidia.com, sharpd@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 06/10] net: Pass 'net' struct as first argument to fib6_info_hw_flags_set()
Date:   Mon,  1 Feb 2021 21:47:53 +0200
Message-Id: <20210201194757.3463461-7-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210201194757.3463461-1-idosch@idosch.org>
References: <20210201194757.3463461-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The next patch will emit notification when hardware flags are changed,
in case that fib_notify_on_flag_change sysctl is set to 1.

To know sysctl values, net struct is needed.
This change is consistent with the IPv4 version, which gets 'net' struct
as its first argument.

Currently, the only callers of this function are mlxsw and netdevsim.
Patch the callers to pass net.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  7 ++++---
 drivers/net/netdevsim/fib.c                        | 14 ++++++++------
 include/net/ip6_fib.h                              |  5 +++--
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 0ac7014703aa..5516e141f5bf 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5004,8 +5004,8 @@ mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 	fib6_entry = container_of(fib_entry, struct mlxsw_sp_fib6_entry,
 				  common);
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list)
-		fib6_info_hw_flags_set(mlxsw_sp_rt6->rt, should_offload,
-				       !should_offload);
+		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), mlxsw_sp_rt6->rt,
+				       should_offload, !should_offload);
 }
 
 static void
@@ -5018,7 +5018,8 @@ mlxsw_sp_fib6_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 	fib6_entry = container_of(fib_entry, struct mlxsw_sp_fib6_entry,
 				  common);
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list)
-		fib6_info_hw_flags_set(mlxsw_sp_rt6->rt, false, false);
+		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), mlxsw_sp_rt6->rt,
+				       false, false);
 }
 
 static void
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index d557533d43dd..cb68f0cc6740 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -585,13 +585,15 @@ static int nsim_fib6_rt_append(struct nsim_fib_data *data,
 	return err;
 }
 
-static void nsim_fib6_rt_hw_flags_set(const struct nsim_fib6_rt *fib6_rt,
+static void nsim_fib6_rt_hw_flags_set(struct nsim_fib_data *data,
+				      const struct nsim_fib6_rt *fib6_rt,
 				      bool trap)
 {
+	struct net *net = devlink_net(data->devlink);
 	struct nsim_fib6_rt_nh *fib6_rt_nh;
 
 	list_for_each_entry(fib6_rt_nh, &fib6_rt->nh_list, list)
-		fib6_info_hw_flags_set(fib6_rt_nh->rt, false, trap);
+		fib6_info_hw_flags_set(net, fib6_rt_nh->rt, false, trap);
 }
 
 static int nsim_fib6_rt_add(struct nsim_fib_data *data,
@@ -607,7 +609,7 @@ static int nsim_fib6_rt_add(struct nsim_fib_data *data,
 		goto err_fib_dismiss;
 
 	msleep(1);
-	nsim_fib6_rt_hw_flags_set(fib6_rt, true);
+	nsim_fib6_rt_hw_flags_set(data, fib6_rt, true);
 
 	return 0;
 
@@ -641,9 +643,9 @@ static int nsim_fib6_rt_replace(struct nsim_fib_data *data,
 		return err;
 
 	msleep(1);
-	nsim_fib6_rt_hw_flags_set(fib6_rt, true);
+	nsim_fib6_rt_hw_flags_set(data, fib6_rt, true);
 
-	nsim_fib6_rt_hw_flags_set(fib6_rt_old, false);
+	nsim_fib6_rt_hw_flags_set(data, fib6_rt_old, false);
 	nsim_fib6_rt_destroy(fib6_rt_old);
 
 	return 0;
@@ -954,7 +956,7 @@ static void nsim_fib6_rt_free(struct nsim_fib_rt *fib_rt,
 	struct nsim_fib6_rt *fib6_rt;
 
 	fib6_rt = container_of(fib_rt, struct nsim_fib6_rt, common);
-	nsim_fib6_rt_hw_flags_set(fib6_rt, false);
+	nsim_fib6_rt_hw_flags_set(data, fib6_rt, false);
 	nsim_fib_account(&data->ipv6.fib, false);
 	nsim_fib6_rt_destroy(fib6_rt);
 }
diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index ac5ff3c3afb1..cc189e668adf 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -336,8 +336,9 @@ static inline void fib6_info_release(struct fib6_info *f6i)
 		call_rcu(&f6i->rcu, fib6_info_destroy_rcu);
 }
 
-static inline void fib6_info_hw_flags_set(struct fib6_info *f6i, bool offload,
-					  bool trap)
+static inline void
+fib6_info_hw_flags_set(struct net *net, struct fib6_info *f6i, bool offload,
+		       bool trap)
 {
 	f6i->offload = offload;
 	f6i->trap = trap;
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9E30304043
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 15:28:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405875AbhAZO1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 09:27:53 -0500
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:49231 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391709AbhAZN0I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 08:26:08 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 191C8953;
        Tue, 26 Jan 2021 08:24:28 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Jan 2021 08:24:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=0G3gHueoxYZTY+TEleBUiJ7EkRjCg6oNuMRvgnZPlgg=; b=lGnbGe8o
        bcxXqvsGyfxnkrwT3svKl2lMxBLBus5iN4b7IpgOp6f5TDRYRtCmHdOsQe71ltbP
        DbMsBEgK5wukCdFkhOCJY0nVW6QMEBODDCcRq5OkIqHUEAQJ025QGadDbWGNchmA
        OpPiOrQbe0bpjMz2zgQVL4jAcBxgNjwN8YfVCEoPn/SVkRKVrrTEozO7Ce6upnS+
        aWWM1tWUWaNnpxfLm+2N0iM4NhqS+3clpXjOoYFuSmxzpv1Ypl6SCqNw3s5QTzH0
        cDKt57DJZlsx7MMLZJhls0l8ZqguUMkwCPxMaMXvyf7qvG0JkkQA5LMv2tldhxYm
        CSPufNZMZVEJCA==
X-ME-Sender: <xms:CxgQYKIKGn5jAcKqfoegV4Qs6s0huBOdbNrK0oxOzIxGANFOKJh9Jg>
    <xme:CxgQYCIv8qc6eM-rnOq3gKNrgjk6060j75hL6cuLnZgfsVu_40K9YOlO7GteiBkuk
    dPFKADBIgwzZDk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:CxgQYKv1Lv8z7o3vCScjBUSoaWIzl86jUwyvnPeuy-Po921SbIZAcw>
    <xmx:CxgQYPanPeBFgkhiFO75PdyejdT9wxiLqFCnm2y8CwgXva2vm3fzUg>
    <xmx:CxgQYBZMM0aij-W0Fi1m0d07272zs_vu0XUVKfy3dKLDKvTVNM9pRg>
    <xmx:CxgQYGNch3VCC4wwI81M9RS2tDF9Udut-FtriG3KACawZ38M9alvEA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 527291080059;
        Tue, 26 Jan 2021 08:24:25 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        amcohen@nvidia.com, roopa@nvidia.com, sharpd@nvidia.com,
        bpoirier@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/10] net: Pass 'net' struct as first argument to fib6_info_hw_flags_set()
Date:   Tue, 26 Jan 2021 15:23:07 +0200
Message-Id: <20210126132311.3061388-7-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126132311.3061388-1-idosch@idosch.org>
References: <20210126132311.3061388-1-idosch@idosch.org>
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
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |  7 ++++---
 drivers/net/netdevsim/fib.c                        | 14 ++++++++------
 include/net/ip6_fib.h                              |  5 +++--
 3 files changed, 15 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 41424ee909a0..60acb9292451 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4976,8 +4976,8 @@ mlxsw_sp_fib6_entry_hw_flags_set(struct mlxsw_sp *mlxsw_sp,
 	fib6_entry = container_of(fib_entry, struct mlxsw_sp_fib6_entry,
 				  common);
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list)
-		fib6_info_hw_flags_set(mlxsw_sp_rt6->rt, should_offload,
-				       !should_offload);
+		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), mlxsw_sp_rt6->rt,
+				       should_offload, !should_offload);
 }
 
 static void
@@ -4990,7 +4990,8 @@ mlxsw_sp_fib6_entry_hw_flags_clear(struct mlxsw_sp *mlxsw_sp,
 	fib6_entry = container_of(fib_entry, struct mlxsw_sp_fib6_entry,
 				  common);
 	list_for_each_entry(mlxsw_sp_rt6, &fib6_entry->rt6_list, list)
-		fib6_info_hw_flags_set(mlxsw_sp_rt6->rt, false, false);
+		fib6_info_hw_flags_set(mlxsw_sp_net(mlxsw_sp), mlxsw_sp_rt6->rt,
+				       false, false);
 }
 
 static void
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index 779c272ad2ae..21858edd2ec9 100644
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


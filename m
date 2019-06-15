Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 594B847056
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 16:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727054AbfFOOJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 10:09:50 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:52017 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726400AbfFOOJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 10:09:50 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 151D321EBC;
        Sat, 15 Jun 2019 10:09:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 15 Jun 2019 10:09:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Q90LL3i0FAmBsBozRLdYNSPUrTYLpqeC5M37JHQ4MA4=; b=ih0prs90
        UJNeyHgPpC3ZvqRwILTXyT4pWw8dmjBYlDz1HE7KzZ0NrkGtjiXMVOpOSFGOJfez
        DtXX1aVLSlJXUSx3q4xJHrxvR5E+05ShRwXshi9GkTNhw9+J5ueLLNERj2GcUnXb
        ZJHfNRI5jEBBCCQAaXke+5J41g50AlrObNiCOwg8Bc4yP7lgoaxBkGlYV6fJGg6V
        bpFqSrxixoZFdN+yhu61Ac96z0qhw4h3J40eQu/MoEAMS1Kk6shoEXmrS2wK4pHQ
        jIAjSksPOLj6b9pxZLyZcA7OS1pqD7fPCxRqKiZ2FBMksGh7tnT5TARcn7VpS/+F
        hgVZOaEki3+Rjg==
X-ME-Sender: <xms:LPwEXaRrjup1vsKO0kk4EAA_jVHMSuzJwiO6hDn9Re6dDyNLlcMe6A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedgjeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudejkedrgeefrddvudeknecurfgrrhgrmhepmh
    grihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhgnecuvehluhhsthgvrhfu
    ihiivgeptd
X-ME-Proxy: <xmx:LPwEXV6cTpAwpmj1lOjKah-JNcZ4H-YmU6FWb3yautAd-7GKg1k6XQ>
    <xmx:LPwEXewsvyQVctBW4pxJTXgzBcnhwL1VNqt0afMFYGwiiApGruH_mw>
    <xmx:LPwEXdKleEjxzLVjcl4eHgQ4wqUG6MNbwz7juQ1fJAIC-aDPaurAGg>
    <xmx:LfwEXbA7pK2l1-zZdyQKBJAMyrJO7cak4-N2kc-dOWAgAlyqlV78fg>
Received: from splinter.mtl.com (bzq-79-178-43-218.red.bezeqint.net [79.178.43.218])
        by mail.messagingengine.com (Postfix) with ESMTPA id E85DE380073;
        Sat, 15 Jun 2019 10:09:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, dsahern@gmail.com, jiri@mellanox.com,
        alexpe@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 13/17] mlxsw: spectrum_router: Pass array of routes to route handling functions
Date:   Sat, 15 Jun 2019 17:07:47 +0300
Message-Id: <20190615140751.17661-14-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190615140751.17661-1-idosch@idosch.org>
References: <20190615140751.17661-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Prepare the driver to handle multiple routes in a single notification by
passing an array of routes to the functions that actually add / delete a
route.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 49557eca48e0..2788366329b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5489,10 +5489,12 @@ static void mlxsw_sp_fib6_entry_replace(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
-				    struct fib6_info *rt, bool replace)
+				    struct fib6_info **rt_arr,
+				    unsigned int nrt6, bool replace)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
+	struct fib6_info *rt = rt_arr[0];
 	int err;
 
 	if (mlxsw_sp->router->aborted)
@@ -5546,10 +5548,12 @@ static int mlxsw_sp_router_fib6_add(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
-				     struct fib6_info *rt)
+				     struct fib6_info **rt_arr,
+				     unsigned int nrt6)
 {
 	struct mlxsw_sp_fib6_entry *fib6_entry;
 	struct mlxsw_sp_fib_node *fib_node;
+	struct fib6_info *rt = rt_arr[0];
 
 	if (mlxsw_sp->router->aborted)
 		return;
@@ -5955,7 +5959,8 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 	case FIB_EVENT_ENTRY_ADD:
 		replace = fib_work->event == FIB_EVENT_ENTRY_REPLACE;
 		err = mlxsw_sp_router_fib6_add(mlxsw_sp,
-					       fib_work->fib6_work.rt_arr[0],
+					       fib_work->fib6_work.rt_arr,
+					       fib_work->fib6_work.nrt6,
 					       replace);
 		if (err)
 			mlxsw_sp_router_fib_abort(mlxsw_sp);
@@ -5963,7 +5968,8 @@ static void mlxsw_sp_router_fib6_event_work(struct work_struct *work)
 		break;
 	case FIB_EVENT_ENTRY_DEL:
 		mlxsw_sp_router_fib6_del(mlxsw_sp,
-					 fib_work->fib6_work.rt_arr[0]);
+					 fib_work->fib6_work.rt_arr,
+					 fib_work->fib6_work.nrt6);
 		mlxsw_sp_router_fib6_work_fini(&fib_work->fib6_work);
 		break;
 	case FIB_EVENT_RULE_ADD:
-- 
2.20.1


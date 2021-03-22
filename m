Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF809344A11
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 17:00:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231593AbhCVQAe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 12:00:34 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55097 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231150AbhCVP75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 11:59:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 66F4F5C01CA;
        Mon, 22 Mar 2021 11:59:57 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 22 Mar 2021 11:59:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=W3J1CCgnfqiYxXfJi5oeJHFZyLibHPwHCBh4S17HkNM=; b=A5EnbIyQ
        I9LJo12cdpGgYwdFLJhLT1aVJjf7t7QIC+GpTGasf3/8GQlA3mfdLkDm2tJK/FFi
        j86sdMZAMsbn7Za2VLsSH4KlbUk4NkVQ1ZvgQkv05MheW8cE6q7JueXVd5ZEpUEL
        RxghMg4RB5MBmkfOUyZIRQwzOGAe+5MppUohlOMJMj3mQFb2WYWsCp9YlDjI+bQV
        y7YvsaUcwmUiQ1jD4PXTbI9zH61cBO+KersSxfoRcwX8M2lW3Ck69VzvDW2HmBtr
        FK2nX/hJfQiqUEchd/9qAhumyj+htd7qeI6SuN7fYO1qMSeLQaWdJn9A53iNA3dt
        +OS6LWBVXgnfKw==
X-ME-Sender: <xms:_b5YYAegtHRJVtceLkjDpwZgNkjmbRkYqtkBMoTcBdwxF8AcE88tpA>
    <xme:_b5YYCLul_n09dIUefjdDhmSO8CaZ_Jp-ZzPO37VpD1BEnj-bJikvUSOpQ7lp_zQ5
    toakyr-khX803Y>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudeggedgkedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:_b5YYOblH2oAHntkluWHdaXobtJt7o7RVh8CNlOfjBDnrtFGFVDj2g>
    <xmx:_b5YYNtz1P1Fx4elpb0F-HTRlKe1rS6RnsVr55IeVwKIgziJmkdnrQ>
    <xmx:_b5YYLsfb7oBc8IkorDvLLeqJAAVJqm0yUEM6Wj8YyvZkOCLs86kAQ>
    <xmx:_b5YYBQVcID5psAPuHPoUejAVsye4esrHiDO_fv2tc5TWqC00Dvk_A>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 99B971080057;
        Mon, 22 Mar 2021 11:59:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 09/14] mlxsw: spectrum_router: Encapsulate nexthop update in a function
Date:   Mon, 22 Mar 2021 17:58:50 +0200
Message-Id: <20210322155855.3164151-10-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210322155855.3164151-1-idosch@idosch.org>
References: <20210322155855.3164151-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Encapsulate this functionality in a separate function, so that it could
be invoked by follow-up patches, when replacing a nexthop bucket that is
part of a resilient nexthop group.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 28 ++++++++++---------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1f1f8af63ef7..6be225ec1997 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3491,6 +3491,20 @@ static int mlxsw_sp_nexthop_ipip_update(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+static int mlxsw_sp_nexthop_update(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
+				   struct mlxsw_sp_nexthop *nh)
+{
+	/* When action is discard or trap, the nexthop must be
+	 * programmed as an Ethernet nexthop.
+	 */
+	if (nh->type == MLXSW_SP_NEXTHOP_TYPE_ETH ||
+	    nh->action == MLXSW_SP_NEXTHOP_ACTION_DISCARD ||
+	    nh->action == MLXSW_SP_NEXTHOP_ACTION_TRAP)
+		return mlxsw_sp_nexthop_eth_update(mlxsw_sp, adj_index, nh);
+	else
+		return mlxsw_sp_nexthop_ipip_update(mlxsw_sp, adj_index, nh);
+}
+
 static int
 mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_nexthop_group_info *nhgi,
@@ -3511,19 +3525,7 @@ mlxsw_sp_nexthop_group_update(struct mlxsw_sp *mlxsw_sp,
 		if (nh->update || reallocate) {
 			int err = 0;
 
-			/* When action is discard or trap, the nexthop must be
-			 * programmed as an Ethernet nexthop.
-			 */
-			if (nh->type == MLXSW_SP_NEXTHOP_TYPE_ETH ||
-			    nh->action == MLXSW_SP_NEXTHOP_ACTION_DISCARD ||
-			    nh->action == MLXSW_SP_NEXTHOP_ACTION_TRAP)
-				err = mlxsw_sp_nexthop_eth_update(mlxsw_sp,
-								  adj_index,
-								  nh);
-			else
-				err = mlxsw_sp_nexthop_ipip_update(mlxsw_sp,
-								   adj_index,
-								   nh);
+			err = mlxsw_sp_nexthop_update(mlxsw_sp, adj_index, nh);
 			if (err)
 				return err;
 			nh->update = 0;
-- 
2.29.2


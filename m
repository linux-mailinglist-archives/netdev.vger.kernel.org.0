Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E340133D65E
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:04:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237694AbhCPPEO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:04:14 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43255 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237684AbhCPPEF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:05 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DDBF05C0103;
        Tue, 16 Mar 2021 11:04:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 16 Mar 2021 11:04:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=CTaopQSv8FVkK16cIggel33prhiX3uzpgQK/mO5V2VI=; b=JtDFIrUW
        MKm9xaRdc5abpp6PSsQ1gRtRdu1TbAS+KpIfv/HGIit8nJjQ/2PhOoxbjIPj1uUi
        1ODfQyZuXQ/fO8KqSAzH56sEvO0V3F5EMLM3FSnFonLlghdERzegb0kFQZ6IvjBO
        w3C+C382WsnTorWY9xW8pTZElFlOwn72taMBLcaD5+k6hJZKpHaEB0t0f8jms/MS
        6ajd8zG1elKWoZc1dABU/CU7jlipsbqD2ZqzXUHDZoEQJLv81Vj37tja7ph4NhbQ
        ttJFXZHBG+A/keagK4Cj5zyxit0he1jGU6FRJxPMz0EqVHG8f8U7tBy33fBouJSG
        /NIDK/pNCsq8bA==
X-ME-Sender: <xms:5MhQYG7ZEUAKdnbtJlkyXpwpQl9jQqjOoIDp3Zx8LxaIe8NIelN9yw>
    <xme:5MhQYP6DUG5quW4xddby1Il5KFltQEbKEjwLL2tIExxLo0iZ_8ZWs0oZDyLoFjYi1
    FGl_xkC_HNRh1I>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:5MhQYFe_Zjgpgf4s5xXdeU5r-Q4NVWwbzAD5Z8rw6828UTHHfY8FHA>
    <xmx:5MhQYDIOv25Nra845x4LNDWbHIUr4tb05nxAusJVDE80FxqdV20svA>
    <xmx:5MhQYKK7dXzNx33TrtqasVSJrdGpNX2paUzR6jzG09uEORJmYFgjrQ>
    <xmx:5MhQYMjIoXKzr2nMrID-RyUgC9W19gdZd61dAAGaL-RBx5bN2pA-kg>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 756141080057;
        Tue, 16 Mar 2021 11:04:02 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 02/10] mlxsw: spectrum_matchall: Push sampling checks to per-ASIC operations
Date:   Tue, 16 Mar 2021 17:02:55 +0200
Message-Id: <20210316150303.2868588-3-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Push some sampling checks to the per-ASIC operations, as they are no
longer relevant for all ASICs.

The sampling rate validation against the MPSC maximum rate is only
relevant for Spectrum-1, as Spectrum-2 and later ASICs no longer use
MPSC register for sampling.

The ingress / egress validation is pushed down to the per-ASIC
operations since subsequent patches are going to remove it for
Spectrum-2 and later ASICs.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  4 +--
 .../mellanox/mlxsw/spectrum_matchall.c        | 32 ++++++++++++-------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 650294d64237..848ae949e521 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1035,8 +1035,8 @@ extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 /* spectrum_matchall.c */
 struct mlxsw_sp_mall_ops {
 	int (*sample_add)(struct mlxsw_sp *mlxsw_sp,
-			  struct mlxsw_sp_port *mlxsw_sp_port, u32 rate,
-			  struct netlink_ext_ack *extack);
+			  struct mlxsw_sp_port *mlxsw_sp_port, bool ingress,
+			  u32 rate, struct netlink_ext_ack *extack);
 	void (*sample_del)(struct mlxsw_sp *mlxsw_sp,
 			   struct mlxsw_sp_port *mlxsw_sp_port);
 };
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index d44a4c4b57f8..483b902c2dd7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -114,6 +114,7 @@ mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	rcu_assign_pointer(mlxsw_sp_port->sample, &mall_entry->sample);
 
 	err = mlxsw_sp->mall_ops->sample_add(mlxsw_sp, mlxsw_sp_port,
+					     mall_entry->ingress,
 					     mall_entry->sample.rate, extack);
 	if (err)
 		goto err_port_sample_set;
@@ -253,22 +254,12 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp *mlxsw_sp,
 		mall_entry->mirror.to_dev = act->dev;
 	} else if (act->id == FLOW_ACTION_SAMPLE &&
 		   protocol == htons(ETH_P_ALL)) {
-		if (!mall_entry->ingress) {
-			NL_SET_ERR_MSG(f->common.extack, "Sample is not supported on egress");
-			err = -EOPNOTSUPP;
-			goto errout;
-		}
 		if (flower_prio_valid &&
 		    mall_entry->priority >= flower_min_prio) {
 			NL_SET_ERR_MSG(f->common.extack, "Failed to add behind existing flower rules");
 			err = -EOPNOTSUPP;
 			goto errout;
 		}
-		if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
-			NL_SET_ERR_MSG(f->common.extack, "Sample rate not supported");
-			err = -EOPNOTSUPP;
-			goto errout;
-		}
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_SAMPLE;
 		mall_entry->sample.psample_group = act->sample.psample_group;
 		mall_entry->sample.truncate = act->sample.truncate;
@@ -375,8 +366,19 @@ int mlxsw_sp_mall_prio_get(struct mlxsw_sp_flow_block *block, u32 chain_index,
 
 static int mlxsw_sp1_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_port *mlxsw_sp_port,
-				     u32 rate, struct netlink_ext_ack *extack)
+				     bool ingress, u32 rate,
+				     struct netlink_ext_ack *extack)
 {
+	if (!ingress) {
+		NL_SET_ERR_MSG(extack, "Sampling is not supported on egress");
+		return -EOPNOTSUPP;
+	}
+
+	if (rate > MLXSW_REG_MPSC_RATE_MAX) {
+		NL_SET_ERR_MSG(extack, "Unsupported sampling rate");
+		return -EOPNOTSUPP;
+	}
+
 	return mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, true, rate);
 }
 
@@ -393,7 +395,8 @@ const struct mlxsw_sp_mall_ops mlxsw_sp1_mall_ops = {
 
 static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_port *mlxsw_sp_port,
-				     u32 rate, struct netlink_ext_ack *extack)
+				     bool ingress, u32 rate,
+				     struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
 	struct mlxsw_sp_span_agent_parms agent_parms = {
@@ -403,6 +406,11 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 	struct mlxsw_sp_port_sample *sample;
 	int err;
 
+	if (!ingress) {
+		NL_SET_ERR_MSG(extack, "Sampling is not supported on egress");
+		return -EOPNOTSUPP;
+	}
+
 	sample = rtnl_dereference(mlxsw_sp_port->sample);
 
 	err = mlxsw_sp_span_agent_get(mlxsw_sp, &sample->span_id, &agent_parms);
-- 
2.29.2


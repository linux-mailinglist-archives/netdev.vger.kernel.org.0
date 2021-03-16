Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E7933D662
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 16:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237713AbhCPPEk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 11:04:40 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33291 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237691AbhCPPEJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Mar 2021 11:04:09 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 30E025C0148;
        Tue, 16 Mar 2021 11:04:07 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 16 Mar 2021 11:04:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5URpcHu9P+QGaAWR2yn1yhkd7LWr/eAM7qURNytXDzY=; b=p1BVHcSL
        D2hwLDOf97D7JunHjYZXQKG0xOYINVbsxGzAdrsndSbNesOMB8CXvUJxm8oe8zWP
        yeOKwTCakAr4rWQTpzrOMiDflfdxEjW2GHgSXl5tfjpHwCAK/feJpyfsIclIjy5s
        9PcmBgtE/b+pNJCRky41jxhBA/z89GzzqnaGaKyB3dr3eW4nOiGgyazzdi2nWSKb
        Ly+zTTuj5X2qPppSKLgV4sf+MMDKoqivL3pRuZTD4FnZWJ2Jroa5N7wib0Mm37zS
        L62yeJdUKGBu2sT+X36A/j9N+lY0EFQBVNHPe1Rt8mPN31oAjb7+db8EqO8a3YnF
        shuXRT3oFnvk1g==
X-ME-Sender: <xms:5shQYE5ySMWM9TBp1c_GamYKrwJW66u_VyVundmwPSpAohL-yHAtoA>
    <xme:5shQYO08OQS70uidILLmdjpPqbFarzNa9XLh5gtpBFKZTJ2tFYPTsXXKmfrXFvlRO
    6PR8qwrfu5HkQg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefvddgjeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:5shQYFbKL4ftG5MBzcrljqNtwthe3twu2nLaST78k8-T2v-sI3_v7w>
    <xmx:5shQYGAd_3WdbHTJ_gTc8c7iLZ9CjStiGIuCZxfec5s5Iz3jQMJF8w>
    <xmx:5shQYH-5VXjoKY0RIfcKRb4Cv5KoZwMCnFAwnhH9o9B1-_B2OPp3Rw>
    <xmx:58hQYHOnSJR4ocS3u_8OBBLa1GjWkMjsx3TiEAHERUowDkkukHPczA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 22D75108005F;
        Tue, 16 Mar 2021 11:04:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        roopa@nvidia.com, peter.phaal@inmon.com, neil.mckee@inmon.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/10] mlxsw: spectrum_matchall: Pass matchall entry to sampling operations
Date:   Tue, 16 Mar 2021 17:02:56 +0200
Message-Id: <20210316150303.2868588-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210316150303.2868588-1-idosch@idosch.org>
References: <20210316150303.2868588-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The entry will be required by the next patches, so pass it. No
functional changes intended.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  9 ++++---
 .../mellanox/mlxsw/spectrum_matchall.c        | 27 +++++++++++--------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 848ae949e521..1d8afa6365d8 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -133,6 +133,7 @@ struct mlxsw_sp_ptp_state;
 struct mlxsw_sp_ptp_ops;
 struct mlxsw_sp_span_ops;
 struct mlxsw_sp_qdisc_state;
+struct mlxsw_sp_mall_entry;
 
 struct mlxsw_sp_port_mapping {
 	u8 module;
@@ -1035,10 +1036,12 @@ extern const struct mlxsw_afk_ops mlxsw_sp2_afk_ops;
 /* spectrum_matchall.c */
 struct mlxsw_sp_mall_ops {
 	int (*sample_add)(struct mlxsw_sp *mlxsw_sp,
-			  struct mlxsw_sp_port *mlxsw_sp_port, bool ingress,
-			  u32 rate, struct netlink_ext_ack *extack);
+			  struct mlxsw_sp_port *mlxsw_sp_port,
+			  struct mlxsw_sp_mall_entry *mall_entry,
+			  struct netlink_ext_ack *extack);
 	void (*sample_del)(struct mlxsw_sp *mlxsw_sp,
-			   struct mlxsw_sp_port *mlxsw_sp_port);
+			   struct mlxsw_sp_port *mlxsw_sp_port,
+			   struct mlxsw_sp_mall_entry *mall_entry);
 };
 
 extern const struct mlxsw_sp_mall_ops mlxsw_sp1_mall_ops;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index 483b902c2dd7..b189e84987db 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -114,8 +114,7 @@ mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	rcu_assign_pointer(mlxsw_sp_port->sample, &mall_entry->sample);
 
 	err = mlxsw_sp->mall_ops->sample_add(mlxsw_sp, mlxsw_sp_port,
-					     mall_entry->ingress,
-					     mall_entry->sample.rate, extack);
+					     mall_entry, extack);
 	if (err)
 		goto err_port_sample_set;
 	return 0;
@@ -126,14 +125,15 @@ mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static void
-mlxsw_sp_mall_port_sample_del(struct mlxsw_sp_port *mlxsw_sp_port)
+mlxsw_sp_mall_port_sample_del(struct mlxsw_sp_port *mlxsw_sp_port,
+			      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 
 	if (!mlxsw_sp_port->sample)
 		return;
 
-	mlxsw_sp->mall_ops->sample_del(mlxsw_sp, mlxsw_sp_port);
+	mlxsw_sp->mall_ops->sample_del(mlxsw_sp, mlxsw_sp_port, mall_entry);
 	RCU_INIT_POINTER(mlxsw_sp_port->sample, NULL);
 }
 
@@ -164,7 +164,7 @@ mlxsw_sp_mall_port_rule_del(struct mlxsw_sp_port *mlxsw_sp_port,
 		mlxsw_sp_mall_port_mirror_del(mlxsw_sp_port, mall_entry);
 		break;
 	case MLXSW_SP_MALL_ACTION_TYPE_SAMPLE:
-		mlxsw_sp_mall_port_sample_del(mlxsw_sp_port);
+		mlxsw_sp_mall_port_sample_del(mlxsw_sp_port, mall_entry);
 		break;
 	default:
 		WARN_ON(1);
@@ -366,10 +366,12 @@ int mlxsw_sp_mall_prio_get(struct mlxsw_sp_flow_block *block, u32 chain_index,
 
 static int mlxsw_sp1_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_port *mlxsw_sp_port,
-				     bool ingress, u32 rate,
+				     struct mlxsw_sp_mall_entry *mall_entry,
 				     struct netlink_ext_ack *extack)
 {
-	if (!ingress) {
+	u32 rate = mall_entry->sample.rate;
+
+	if (!mall_entry->ingress) {
 		NL_SET_ERR_MSG(extack, "Sampling is not supported on egress");
 		return -EOPNOTSUPP;
 	}
@@ -383,7 +385,8 @@ static int mlxsw_sp1_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void mlxsw_sp1_mall_sample_del(struct mlxsw_sp *mlxsw_sp,
-				      struct mlxsw_sp_port *mlxsw_sp_port)
+				      struct mlxsw_sp_port *mlxsw_sp_port,
+				      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, false, 1);
 }
@@ -395,7 +398,7 @@ const struct mlxsw_sp_mall_ops mlxsw_sp1_mall_ops = {
 
 static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 				     struct mlxsw_sp_port *mlxsw_sp_port,
-				     bool ingress, u32 rate,
+				     struct mlxsw_sp_mall_entry *mall_entry,
 				     struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
@@ -404,9 +407,10 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 		.session_id = MLXSW_SP_SPAN_SESSION_ID_SAMPLING,
 	};
 	struct mlxsw_sp_port_sample *sample;
+	u32 rate = mall_entry->sample.rate;
 	int err;
 
-	if (!ingress) {
+	if (!mall_entry->ingress) {
 		NL_SET_ERR_MSG(extack, "Sampling is not supported on egress");
 		return -EOPNOTSUPP;
 	}
@@ -444,7 +448,8 @@ static int mlxsw_sp2_mall_sample_add(struct mlxsw_sp *mlxsw_sp,
 }
 
 static void mlxsw_sp2_mall_sample_del(struct mlxsw_sp *mlxsw_sp,
-				      struct mlxsw_sp_port *mlxsw_sp_port)
+				      struct mlxsw_sp_port *mlxsw_sp_port,
+				      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	struct mlxsw_sp_span_trigger_parms trigger_parms = {};
 	struct mlxsw_sp_port_sample *sample;
-- 
2.29.2


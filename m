Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 560A82AD2C3
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbgKJJuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:20 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:42167 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgKJJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:19 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 7FF80E02;
        Tue, 10 Nov 2020 04:50:18 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=elYT3Jutfnk6WJqMrprpQCC2enjpU16l62f7dMX/YxA=; b=kFAT6bAW
        jDnLdRFR5/FiifHXZroU0Xl8nC0AFs1PkAOhMr7qiqf0Hq34+SSxUDrK3QnwJLgZ
        XOcmJ8cjV202mq6fbzziHpjqUSuBColmRUVS7yIbxsScAffLmPufTmKD2Ht/wL6c
        7Ok1CD83K/wxxFZD6lbE2lsQnnxoZg6wmOk6klp7wchVhXSQPYtL8rPbq3pQthtM
        rcm7ZoFMyKXeFKiHv3tPTHyk4bYWVr41erxSQagiYqs7NBRg1k159HYeeFiN2lSW
        BbpcrDl1W4HhH5vd3X2lRKkG9VAYPQEUPf6iQuKVAnc7TGgoYbmVDP6SSqrjAeKi
        krWsQv+YrE4A5g==
X-ME-Sender: <xms:WmKqX9Z6LlVmlGqV2nfZURzJdGv4I4mryOfqCkDHos56XxzmqwYq1A>
    <xme:WmKqX0atZCDOEHjFuTwfKeFE9f-9b8ZvyVAXRHBLVVzrnCZeUbKvrAlaMnh8dsZrL
    hbCdC_6roXPAKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:WmKqX_8Cc6YaSdaz23FwdheCeWprCnQj-TXGTskOqUHykTu-4ind7Q>
    <xmx:WmKqX7rMoF0ZvFH1T3JF0y8__Aw5ArLR-ip7cy0q3mKM8Wzd9K662A>
    <xmx:WmKqX4oLIpn2b7HpqX4Z9Ck1yKWkXzCnNU6gHGwi_0BJOoVExlkKoA>
    <xmx:WmKqX_0_SwAoMFqW1MhvFykdWtEW0ylNSvm0_7k59KVA-wBDWUQr0w>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id D9D24328006A;
        Tue, 10 Nov 2020 04:50:16 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/15] mlxsw: spectrum_router: Pass non-register proto enum to __mlxsw_sp_router_set_abort_trap()
Date:   Tue, 10 Nov 2020 11:48:46 +0200
Message-Id: <20201110094900.1920158-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Don't pass RALXX register enum and rather pass enum mlxsw_sp_l3proto
to __mlxsw_sp_router_set_abort_trap(). This is in preparation to fib
entry pack implementation by XMDR register.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 29fc47821ad7..a1424962472d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5685,15 +5685,17 @@ static void mlxsw_sp_router_fib6_del(struct mlxsw_sp *mlxsw_sp,
 }
 
 static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
-					    enum mlxsw_reg_ralxx_protocol proto,
+					    enum mlxsw_sp_l3proto proto,
 					    u8 tree_id)
 {
 	const struct mlxsw_sp_router_ll_ops *ll_ops = mlxsw_sp->router->proto_ll_ops[proto];
+	enum mlxsw_reg_ralxx_protocol ralxx_proto =
+				(enum mlxsw_reg_ralxx_protocol) proto;
 	char xralta_pl[MLXSW_REG_XRALTA_LEN];
 	char xralst_pl[MLXSW_REG_XRALST_LEN];
 	int i, err;
 
-	mlxsw_reg_xralta_pack(xralta_pl, true, proto, tree_id);
+	mlxsw_reg_xralta_pack(xralta_pl, true, ralxx_proto, tree_id);
 	err = ll_ops->ralta_write(mlxsw_sp, xralta_pl);
 	if (err)
 		return err;
@@ -5708,12 +5710,12 @@ static int __mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp,
 		char xraltb_pl[MLXSW_REG_XRALTB_LEN];
 		char ralue_pl[MLXSW_REG_RALUE_LEN];
 
-		mlxsw_reg_xraltb_pack(xraltb_pl, vr->id, proto, tree_id);
+		mlxsw_reg_xraltb_pack(xraltb_pl, vr->id, ralxx_proto, tree_id);
 		err = ll_ops->raltb_write(mlxsw_sp, xraltb_pl);
 		if (err)
 			return err;
 
-		mlxsw_reg_ralue_pack(ralue_pl, proto,
+		mlxsw_reg_ralue_pack(ralue_pl, ralxx_proto,
 				     MLXSW_REG_RALUE_OP_WRITE_WRITE, vr->id, 0);
 		mlxsw_reg_ralue_act_ip2me_pack(ralue_pl);
 		err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue),
@@ -5813,7 +5815,7 @@ mlxsw_sp_router_fibmr_vif_del(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp)
 {
-	enum mlxsw_reg_ralxx_protocol proto = MLXSW_REG_RALXX_PROTOCOL_IPV4;
+	enum mlxsw_sp_l3proto proto = MLXSW_SP_L3_PROTO_IPV4;
 	int err;
 
 	err = __mlxsw_sp_router_set_abort_trap(mlxsw_sp, proto,
@@ -5825,7 +5827,7 @@ static int mlxsw_sp_router_set_abort_trap(struct mlxsw_sp *mlxsw_sp)
 	 * packets that don't match any routes are trapped to the CPU.
 	 */
 
-	proto = MLXSW_REG_RALXX_PROTOCOL_IPV6;
+	proto = MLXSW_SP_L3_PROTO_IPV6;
 	return __mlxsw_sp_router_set_abort_trap(mlxsw_sp, proto,
 						MLXSW_SP_LPM_TREE_MIN + 1);
 }
-- 
2.26.2


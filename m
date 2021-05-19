Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90058388D96
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 14:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353349AbhESMKz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 08:10:55 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:37235 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1353350AbhESMKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 May 2021 08:10:53 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 3D0965C013E;
        Wed, 19 May 2021 08:09:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Wed, 19 May 2021 08:09:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=gmTc6/DKl5/lGXx2IyGnAEb0uk4cFNYev3x6xshlU5k=; b=WNhimzWP
        uwCPI9VdgJKkIE3hj3wfelJTF5ETFeSkobPl1MICOd7P+vZNXxo70Jta4d+If9lJ
        j+0V4IhUc0WiYFvGldaVSvwwIdXvApjDm9DWBzThMonSdgNU+PFZBvFieT1SFrjB
        rhCbMFv59ys5Iazeg4//473zJjIj1SrnfQtHp7nVBG6p+1rlJz2r6GZz59HfGy3b
        +mf6ewi8tUdlhax/9ySz5ViezzxQ33CeJXzoz7Q+EOrDQZrW87Vne7hInq813gXS
        8udy/kVWBUp/nU8jbrmIcR5pXtQwIE3h19i/nPkuZC0VDyebtC+EqGX8kykxqpS8
        7NOfQgQ++o9QZg==
X-ME-Sender: <xms:_v-kYBkKv9xLR9q2cBG-e0f8sd_Shu1NJWwricaBRFf-GrPSS0ahiw>
    <xme:_v-kYM3ea-VzAXxoHrsceR_GCmfn2Zt1GYNy9FInkdlqv31OVs8eB-ihj-3UNdnGh
    J6vtsusxU9YDsk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeiledggeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrudek
    jeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_v-kYHpjdrvkGTw051r07TyNnQaCSiCQ9onKFkwdEvM0OIi2Nf2cfw>
    <xmx:_v-kYBljI_SmJgQFY5FGYGEIROflHRUTvLMtzhLoFBs4-AAFt9f2ww>
    <xmx:_v-kYP1raQN93JZgmXLyzzq935JfGJkXD15oZpRZkV8qMKC08fJy7g>
    <xmx:_v-kYKSZLl1t4fRJ1uOHuG1XYq4E3DKtRNyQ_jzREBAZd-Q8fT3VaA>
Received: from shredder.mellanox.com (igld-84-229-153-187.inter.net.il [84.229.153.187])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 19 May 2021 08:09:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 2/7] mlxsw: spectrum_router: Replace if statement with a switch statement
Date:   Wed, 19 May 2021 15:08:19 +0300
Message-Id: <20210519120824.302191-3-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210519120824.302191-1-idosch@idosch.org>
References: <20210519120824.302191-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The code was written when only two multipath hash policies were present,
so the if statement was sufficient. The next patch and future patches
are going to add support for more policies, so move to a switch
statement.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 69 ++++++++++---------
 1 file changed, 38 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index ec2af77a126d..1762a790dd34 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9612,41 +9612,48 @@ static void mlxsw_sp_mp_hash_field_set(char *recr2_pl, int field)
 static void mlxsw_sp_mp4_hash_init(struct mlxsw_sp *mlxsw_sp, char *recr2_pl)
 {
 	struct net *net = mlxsw_sp_net(mlxsw_sp);
-	bool only_l3 = !net->ipv4.sysctl_fib_multipath_hash_policy;
-
-	mlxsw_sp_mp_hash_header_set(recr2_pl,
-				    MLXSW_REG_RECR2_IPV4_EN_NOT_TCP_NOT_UDP);
-	mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV4_EN_TCP_UDP);
-	mlxsw_reg_recr2_ipv4_sip_enable(recr2_pl);
-	mlxsw_reg_recr2_ipv4_dip_enable(recr2_pl);
-	if (only_l3)
-		return;
-	mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_EN_IPV4);
-	mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_IPV4_PROTOCOL);
-	mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_SPORT);
-	mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_DPORT);
+
+	switch (net->ipv4.sysctl_fib_multipath_hash_policy) {
+	case 0:
+		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV4_EN_NOT_TCP_NOT_UDP);
+		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV4_EN_TCP_UDP);
+		mlxsw_reg_recr2_ipv4_sip_enable(recr2_pl);
+		mlxsw_reg_recr2_ipv4_dip_enable(recr2_pl);
+		break;
+	case 1:
+		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV4_EN_NOT_TCP_NOT_UDP);
+		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV4_EN_TCP_UDP);
+		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_EN_IPV4);
+		mlxsw_reg_recr2_ipv4_sip_enable(recr2_pl);
+		mlxsw_reg_recr2_ipv4_dip_enable(recr2_pl);
+		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_IPV4_PROTOCOL);
+		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_SPORT);
+		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_DPORT);
+		break;
+	}
 }
 
 static void mlxsw_sp_mp6_hash_init(struct mlxsw_sp *mlxsw_sp, char *recr2_pl)
 {
-	bool only_l3 = !ip6_multipath_hash_policy(mlxsw_sp_net(mlxsw_sp));
-
-	mlxsw_sp_mp_hash_header_set(recr2_pl,
-				    MLXSW_REG_RECR2_IPV6_EN_NOT_TCP_NOT_UDP);
-	mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV6_EN_TCP_UDP);
-	mlxsw_reg_recr2_ipv6_sip_enable(recr2_pl);
-	mlxsw_reg_recr2_ipv6_dip_enable(recr2_pl);
-	mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_IPV6_NEXT_HEADER);
-	if (only_l3) {
-		mlxsw_sp_mp_hash_field_set(recr2_pl,
-					   MLXSW_REG_RECR2_IPV6_FLOW_LABEL);
-	} else {
-		mlxsw_sp_mp_hash_header_set(recr2_pl,
-					    MLXSW_REG_RECR2_TCP_UDP_EN_IPV6);
-		mlxsw_sp_mp_hash_field_set(recr2_pl,
-					   MLXSW_REG_RECR2_TCP_UDP_SPORT);
-		mlxsw_sp_mp_hash_field_set(recr2_pl,
-					   MLXSW_REG_RECR2_TCP_UDP_DPORT);
+	switch (ip6_multipath_hash_policy(mlxsw_sp_net(mlxsw_sp))) {
+	case 0:
+		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV6_EN_NOT_TCP_NOT_UDP);
+		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV6_EN_TCP_UDP);
+		mlxsw_reg_recr2_ipv6_sip_enable(recr2_pl);
+		mlxsw_reg_recr2_ipv6_dip_enable(recr2_pl);
+		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_IPV6_NEXT_HEADER);
+		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_IPV6_FLOW_LABEL);
+		break;
+	case 1:
+		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV6_EN_NOT_TCP_NOT_UDP);
+		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_IPV6_EN_TCP_UDP);
+		mlxsw_sp_mp_hash_header_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_EN_IPV6);
+		mlxsw_reg_recr2_ipv6_sip_enable(recr2_pl);
+		mlxsw_reg_recr2_ipv6_dip_enable(recr2_pl);
+		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_IPV6_NEXT_HEADER);
+		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_SPORT);
+		mlxsw_sp_mp_hash_field_set(recr2_pl, MLXSW_REG_RECR2_TCP_UDP_DPORT);
+		break;
 	}
 }
 
-- 
2.31.1


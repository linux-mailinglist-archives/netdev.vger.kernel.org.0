Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5C951BA78F
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgD0PNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:45 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41575 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728168AbgD0PNk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:40 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 4DB185C0065;
        Mon, 27 Apr 2020 11:13:39 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=wwUzpLY9vHpJLJqCgLO2+2GjzdcgISbGEUL/FjJ1xHU=; b=bNcZVTvA
        6gudchRcTyj7X6LaKS05WA9UMF141LNMV/BbgBz+1zEHiFuFhRDun0+BHzIPED6X
        1yRDb0baMBWqiow0YPy/+I+3y+0L+bKe6dn8jbKQiRDK2RG7PMFib025D9ng8dFs
        ON4IC6Tu5UI34JqmkodNwVL8kMUy1Z4OxV6HAvgnrxkktVHV65+KbKIDz/hyH1of
        KbqPwaEeTgzacgfC1LF1Ig0GRTqQP9ceR7qLP06wxTfpcQInl9A77a1kwQa483aa
        U+VIkbaQQjXJYSNsFMgBz0Jdny6rLUGHnKyP7Umr1iPOM4zpRzpiwfJO3FKP5HEc
        P0U+xxk6ZGrwoQ==
X-ME-Sender: <xms:o_amXmn4yQpB2k3clJfAtSQ-sW2fJUxF07HAJycJsC-vBAc4_GwqOg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:o_amXjRgpO-Wwib5L3YNP16R1GM1sZ6ryEUmxhJns3UrOgddLUVB_w>
    <xmx:o_amXtxHbOxH2e9OW066ZLPxY7w_rVWdCY2mFST2cZxc0QVVTP8Ldg>
    <xmx:o_amXlt56gFnc439Ny4oFdcPZG4MinlG4T41PihO7eTgXd2zxPV1IA>
    <xmx:o_amXo2fNQzkD92QTHV-aTIrInuLwMRkKvKa_6m2_DqHAdeVuvR5iA>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 10274328005A;
        Mon, 27 Apr 2020 11:13:37 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/13] mlxsw: spectrum_matchall: Pass mall_entry as arg to mlxsw_sp_mall_port_mirror_add()
Date:   Mon, 27 Apr 2020 18:13:03 +0300
Message-Id: <20200427151310.3950411-7-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200427151310.3950411-1-idosch@idosch.org>
References: <20200427151310.3950411-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

In the preparation for future changes, have the
mlxsw_sp_mall_port_mirror_add() function to accept mall_entry including
the "to_dev" originally obtained from act pointer.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_matchall.c        | 34 +++++++++----------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index 56f21cfdb48e..b57267f0c9a1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -16,6 +16,7 @@ enum mlxsw_sp_mall_action_type {
 };
 
 struct mlxsw_sp_mall_mirror_entry {
+	const struct net_device *to_dev;
 	int span_id;
 	bool ingress;
 };
@@ -43,32 +44,34 @@ mlxsw_sp_mall_entry_find(struct mlxsw_sp_port *port, unsigned long cookie)
 
 static int
 mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
-			      struct mlxsw_sp_mall_mirror_entry *mirror,
-			      const struct flow_action_entry *act,
+			      struct mlxsw_sp_mall_entry *mall_entry,
 			      bool ingress)
 {
 	enum mlxsw_sp_span_type span_type;
 
-	if (!act->dev) {
+	if (!mall_entry->mirror.to_dev) {
 		netdev_err(mlxsw_sp_port->dev, "Could not find requested device\n");
 		return -EINVAL;
 	}
 
-	mirror->ingress = ingress;
-	span_type = ingress ? MLXSW_SP_SPAN_INGRESS : MLXSW_SP_SPAN_EGRESS;
-	return mlxsw_sp_span_mirror_add(mlxsw_sp_port, act->dev, span_type,
-					true, &mirror->span_id);
+	mall_entry->mirror.ingress = ingress;
+	span_type = mall_entry->mirror.ingress ? MLXSW_SP_SPAN_INGRESS :
+						 MLXSW_SP_SPAN_EGRESS;
+	return mlxsw_sp_span_mirror_add(mlxsw_sp_port,
+					mall_entry->mirror.to_dev,
+					span_type, true,
+					&mall_entry->mirror.span_id);
 }
 
 static void
 mlxsw_sp_mall_port_mirror_del(struct mlxsw_sp_port *mlxsw_sp_port,
-			      struct mlxsw_sp_mall_mirror_entry *mirror)
+			      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	enum mlxsw_sp_span_type span_type;
 
-	span_type = mirror->ingress ? MLXSW_SP_SPAN_INGRESS :
-				      MLXSW_SP_SPAN_EGRESS;
-	mlxsw_sp_span_mirror_del(mlxsw_sp_port, mirror->span_id,
+	span_type = mall_entry->mirror.ingress ? MLXSW_SP_SPAN_INGRESS :
+						 MLXSW_SP_SPAN_EGRESS;
+	mlxsw_sp_span_mirror_del(mlxsw_sp_port, mall_entry->mirror.span_id,
 				 span_type, true);
 }
 
@@ -148,11 +151,9 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 	act = &f->rule->action.entries[0];
 
 	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
-		struct mlxsw_sp_mall_mirror_entry *mirror;
-
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_MIRROR;
-		mirror = &mall_entry->mirror;
-		err = mlxsw_sp_mall_port_mirror_add(mlxsw_sp_port, mirror, act,
+		mall_entry->mirror.to_dev = act->dev;
+		err = mlxsw_sp_mall_port_mirror_add(mlxsw_sp_port, mall_entry,
 						    ingress);
 	} else if (act->id == FLOW_ACTION_SAMPLE &&
 		   protocol == htons(ETH_P_ALL)) {
@@ -188,8 +189,7 @@ void mlxsw_sp_mall_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 
 	switch (mall_entry->type) {
 	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
-		mlxsw_sp_mall_port_mirror_del(mlxsw_sp_port,
-					      &mall_entry->mirror);
+		mlxsw_sp_mall_port_mirror_del(mlxsw_sp_port, mall_entry);
 		break;
 	case MLXSW_SP_MALL_ACTION_TYPE_SAMPLE:
 		mlxsw_sp_mall_port_sample_del(mlxsw_sp_port);
-- 
2.24.1


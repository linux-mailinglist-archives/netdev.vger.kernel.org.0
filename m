Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48E421BA78E
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:14:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbgD0PNo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:44 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:44433 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728196AbgD0PNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:41 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id BA8F25C00D1;
        Mon, 27 Apr 2020 11:13:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=f+gqWHPjNPV0zRjRUugpF5SBqOgxgvs/E6pMFy2nVHQ=; b=VG3GaOEV
        GTN9l50ql8cI85uOIqz71sGGDlME4hnbsDctYLdct08yvx4+JGw8IjiTB2wh+Sd4
        XHxsRxWY2XLmCKmCs55DaJQi47jAlBDYfeSxUBhntZHbWutaeqs+BumVZhesfqai
        8KEo3qufJH8SAjsTu+IG/pvN3kdCg0Yq8jcljv4Bi4Np5gwZEBLcV8C61AvXZLXO
        ItY3DfWUGL1SpvPcYpQP3WOydwoHZOu8eFP8oDzG2aCyEs9jGNECki5iJAKV3utx
        VJgxl+4TtEaKch/WPXkGyR927o+f0UAmtQcjlxzam2qtRIHdcgFvXmPGmUlNdgQC
        raRVl0JlUk55tA==
X-ME-Sender: <xms:pPamXs97FhfFE9tq0d_M4d41zfLU4BkClfkIPPpSbmvYjziz-5c25g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpedvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:pPamXp-6obvbFJgwsGiiS4j4i8WnjRt6jUb2YiSEMF4Y2pEV9pvqjw>
    <xmx:pPamXjvvrvbJvXAbrQwFmsK6kUxgFR4eqy0gl4h4XdxpgL53bXEDfg>
    <xmx:pPamXkrUFxyyLWW80aD4ZCuAY2rsMNFq4LyUFVdsFxhvhaKoha_htQ>
    <xmx:pPamXkqClCJnMmKG2YcufnxMbCVF3lfJg6IB9ZHZTX_fqzGX7O41hA>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 672E0328005A;
        Mon, 27 Apr 2020 11:13:39 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/13] mlxsw: spectrum_matchall: Pass mall_entry as arg to mlxsw_sp_mall_port_sample_add()
Date:   Mon, 27 Apr 2020 18:13:04 +0300
Message-Id: <20200427151310.3950411-8-idosch@idosch.org>
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
mlxsw_sp_mall_port_sample_add() function to accept mall_entry including
all needed info originally obtained from cls and act pointers.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_matchall.c        | 35 ++++++++++---------
 1 file changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index b57267f0c9a1..adaaee208655 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -27,6 +27,7 @@ struct mlxsw_sp_mall_entry {
 	enum mlxsw_sp_mall_action_type type;
 	union {
 		struct mlxsw_sp_mall_mirror_entry mirror;
+		struct mlxsw_sp_port_sample sample;
 	};
 };
 
@@ -87,8 +88,7 @@ static int mlxsw_sp_mall_port_sample_set(struct mlxsw_sp_port *mlxsw_sp_port,
 
 static int
 mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
-			      struct tc_cls_matchall_offload *cls,
-			      const struct flow_action_entry *act, bool ingress)
+			      struct mlxsw_sp_mall_entry *mall_entry)
 {
 	int err;
 
@@ -98,19 +98,14 @@ mlxsw_sp_mall_port_sample_add(struct mlxsw_sp_port *mlxsw_sp_port,
 		netdev_err(mlxsw_sp_port->dev, "sample already active\n");
 		return -EEXIST;
 	}
-	if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
-		netdev_err(mlxsw_sp_port->dev, "sample rate not supported\n");
-		return -EOPNOTSUPP;
-	}
-
 	rcu_assign_pointer(mlxsw_sp_port->sample->psample_group,
-			   act->sample.psample_group);
-	mlxsw_sp_port->sample->truncate = act->sample.truncate;
-	mlxsw_sp_port->sample->trunc_size = act->sample.trunc_size;
-	mlxsw_sp_port->sample->rate = act->sample.rate;
+			   mall_entry->sample.psample_group);
+	mlxsw_sp_port->sample->truncate = mall_entry->sample.truncate;
+	mlxsw_sp_port->sample->trunc_size = mall_entry->sample.trunc_size;
+	mlxsw_sp_port->sample->rate = mall_entry->sample.rate;
 
 	err = mlxsw_sp_mall_port_sample_set(mlxsw_sp_port, true,
-					    act->sample.rate);
+					    mall_entry->sample.rate);
 	if (err)
 		goto err_port_sample_set;
 	return 0;
@@ -157,20 +152,28 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 						    ingress);
 	} else if (act->id == FLOW_ACTION_SAMPLE &&
 		   protocol == htons(ETH_P_ALL)) {
+		if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
+			netdev_err(mlxsw_sp_port->dev, "sample rate not supported\n");
+			err = -EOPNOTSUPP;
+			goto errout;
+		}
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_SAMPLE;
-		err = mlxsw_sp_mall_port_sample_add(mlxsw_sp_port, f, act,
-						    ingress);
+		mall_entry->sample.psample_group = act->sample.psample_group;
+		mall_entry->sample.truncate = act->sample.truncate;
+		mall_entry->sample.trunc_size = act->sample.trunc_size;
+		mall_entry->sample.rate = act->sample.rate;
+		err = mlxsw_sp_mall_port_sample_add(mlxsw_sp_port, mall_entry);
 	} else {
 		err = -EOPNOTSUPP;
 	}
 
 	if (err)
-		goto err_add_action;
+		goto errout;
 
 	list_add_tail(&mall_entry->list, &mlxsw_sp_port->mall_list);
 	return 0;
 
-err_add_action:
+errout:
 	kfree(mall_entry);
 	return err;
 }
-- 
2.24.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B0B4330C7
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234563AbhJSIKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:10:30 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:60125 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234684AbhJSIK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:10:27 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 1FDB55C00E8;
        Tue, 19 Oct 2021 04:08:13 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 19 Oct 2021 04:08:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=WZCQIaDRwDV1a/AkHXjdff3f+8Jp6b731zdlQSN1rKQ=; b=fZfawzhq
        DuX32dkPXWpTdbhBwqOmmLa9QIRJIyhgxSppcujo3goR/a0YsTfsELBzC4MqdKsC
        sFJRrfteD5QX3M1/7hsGkZmJ+j3h2vG6CoZKdKKaEsiLyRO1IJ+Exavyg9BAn35X
        OGtmcPiPjquT0Vwl2MXrDBr6QORL9jegGRLyc36JA1e+oHsO1mwZx3I0THRC1d2h
        uhyv64IkqEDuOTpX3rLIDPgeBLOwrcsxM1QQl6g3K8jMoTNRPFZ1fJG9nL/OC5nU
        7/8fdSvV5mWayA6scNecHRlt/T5BK7XtE4VhClKf4YPC6ZJUtLQPbhEHCTwk67qP
        fIcog8vzcnXCWQ==
X-ME-Sender: <xms:7HxuYanUf5qUHoMUJ5ULxZRr8tRYb0qA7kFI4KSym192nIqD_eMFTw>
    <xme:7HxuYR1-P4N61fzvIRjnMk430R9lVdAAmXQqItYNwwQ70tjb6NROIfuNUaapb4sGP
    -rG9vQEJ8-wk7A>
X-ME-Received: <xmr:7HxuYYoYc009sYAWPw20z3T8eFXu-N_Tki4NUQmr1WKHXPlXsYmtTJr5J4MmlI1cPCUzsjxS3aymRkpmijoI1Wqjy3ueZ6B9J88XmrF8VGs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedtnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:7HxuYenaKPKwLAMHAVDQ6fweb9naRl2YI42Rga1A3lDxovefqDH2Ow>
    <xmx:7HxuYY1PIumDNZX79LjTCB_rzizOIWHImwnNMLizTe6QwfYIpodlFg>
    <xmx:7HxuYVsp9zN2NiFxP2acSnJxF3gkdlqVHTSVrW69F31B-mX9zq2mIg>
    <xmx:7XxuYSq2H6ICXGrj_ep4RlbJMpKhGmF4k36QJfqhA2aMxHV0fn81eA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 04:08:10 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/9] mlxsw: spectrum_qdisc: Unify graft validation
Date:   Tue, 19 Oct 2021 11:07:08 +0300
Message-Id: <20211019080712.705464-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019080712.705464-1-idosch@idosch.org>
References: <20211019080712.705464-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

Qdisc graft operations have so far been reported at PRIO, ETS and RED, with
RED events ignored, because RED was not considered a classful qdisc. A
following patch will make mlxsw recognize RED and TBF as classful qdiscs,
and thus it is necessary to validate grafting at these qdiscs as well.
Rename the existing graft validator to make it clear that it is a generic
function, and invoke for RED and TBF graft events as well. Drop the
unnecessary PRIO helper and invoke the graft validator directly for PRIO as
well.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 37 ++++++++++---------
 1 file changed, 19 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 8ececee1b79b..62ec3768c615 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -739,6 +739,10 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_red = {
 	.find_class = mlxsw_sp_qdisc_leaf_find_class,
 };
 
+static int mlxsw_sp_qdisc_graft(struct mlxsw_sp_port *mlxsw_sp_port,
+				struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				u8 band, u32 child_handle);
+
 static int __mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_sp_port,
 				   struct tc_red_qopt_offload *p)
 {
@@ -766,6 +770,9 @@ static int __mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_sp_port,
 	case TC_RED_STATS:
 		return mlxsw_sp_qdisc_get_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
 						&p->stats);
+	case TC_RED_GRAFT:
+		return mlxsw_sp_qdisc_graft(mlxsw_sp_port, mlxsw_sp_qdisc, 0,
+					    p->child_handle);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -976,6 +983,9 @@ static int __mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
 	case TC_TBF_STATS:
 		return mlxsw_sp_qdisc_get_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
 						&p->stats);
+	case TC_TBF_GRAFT:
+		return mlxsw_sp_qdisc_graft(mlxsw_sp_port, mlxsw_sp_qdisc, 0,
+					    p->child_handle);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1463,10 +1473,9 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_ets = {
  * grafted corresponds to the parent handle. If the two don't match, we
  * unoffload the child.
  */
-static int
-__mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
-			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
-			   u8 band, u32 child_handle)
+static int mlxsw_sp_qdisc_graft(struct mlxsw_sp_port *mlxsw_sp_port,
+				struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				u8 band, u32 child_handle)
 {
 	struct mlxsw_sp_qdisc *old_qdisc;
 	u32 parent;
@@ -1499,15 +1508,6 @@ __mlxsw_sp_qdisc_ets_graft(struct mlxsw_sp_port *mlxsw_sp_port,
 	return -EOPNOTSUPP;
 }
 
-static int
-mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_sp_port,
-			  struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
-			  struct tc_prio_qopt_offload_graft_params *p)
-{
-	return __mlxsw_sp_qdisc_ets_graft(mlxsw_sp_port, mlxsw_sp_qdisc,
-					  p->band, p->child_handle);
-}
-
 static int __mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
 				    struct tc_prio_qopt_offload *p)
 {
@@ -1533,8 +1533,9 @@ static int __mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
 		return mlxsw_sp_qdisc_get_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
 						&p->stats);
 	case TC_PRIO_GRAFT:
-		return mlxsw_sp_qdisc_prio_graft(mlxsw_sp_port, mlxsw_sp_qdisc,
-						 &p->graft_params);
+		return mlxsw_sp_qdisc_graft(mlxsw_sp_port, mlxsw_sp_qdisc,
+					    p->graft_params.band,
+					    p->graft_params.child_handle);
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -1577,9 +1578,9 @@ static int __mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
 		return mlxsw_sp_qdisc_get_stats(mlxsw_sp_port, mlxsw_sp_qdisc,
 						&p->stats);
 	case TC_ETS_GRAFT:
-		return __mlxsw_sp_qdisc_ets_graft(mlxsw_sp_port, mlxsw_sp_qdisc,
-						  p->graft_params.band,
-						  p->graft_params.child_handle);
+		return mlxsw_sp_qdisc_graft(mlxsw_sp_port, mlxsw_sp_qdisc,
+					    p->graft_params.band,
+					    p->graft_params.child_handle);
 	default:
 		return -EOPNOTSUPP;
 	}
-- 
2.31.1


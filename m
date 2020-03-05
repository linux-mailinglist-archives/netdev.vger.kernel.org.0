Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D475217A071
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 08:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbgCEHRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 02:17:42 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51991 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726498AbgCEHRl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 02:17:41 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 55250205EC;
        Thu,  5 Mar 2020 02:17:40 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 05 Mar 2020 02:17:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=GKc+3ApDXCsTXzAMUN0tclxcO3fhKWtkH7rbsqgBLoE=; b=Pog9bHa9
        yYIqFs8GDijl85DO7UKjYZm8I9a9mRd3z4kjsD1HaIUHb8QTaowuMIyVLrK5LDmk
        xcHz8St60uJMl+B5nSXs+hXBkP1RZxrf/ETOkPHr2mu8pTU3iFKB6LrwoKFxEEMO
        L3tszkhB6PRzO7KDuXi9Ga+AtN1vfGfu4r1b+96ixNZhAgC6A0XIti+uiWaoXMhS
        XYbASp/7xG50sDeGbmyPnX88lGvfqkE+ZrbScCDw6DO65lS6M7U74oxYDxXRwDkp
        rI7qUYaeJk2ed3uGd7RcZcDj3A9afv0SR8tjNtO/FL05CDSQtt9dRYmtHEPg2QmU
        N4KRmstNx9oLDw==
X-ME-Sender: <xms:lKdgXpEi90jTSVlotoJN33FJDkuBdyXNvb_qt8PhudUGg_OSpMNgtA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedruddtledguddtiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucfkphepudelfedrgeejrdduieehrddvhedunecuvehluhhsth
    gvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiugho
    shgthhdrohhrgh
X-ME-Proxy: <xmx:lKdgXoUb3SqXofkTjIJOBWUA9wPaTgOdEq7EZMDg11nMUMgRAqjndw>
    <xmx:lKdgXhzEuMPwMfvtRPyuKf0S4tFENlc_d16pH9wKdBLUsKTIhI6BcA>
    <xmx:lKdgXtSlZEiVFv3hdeLIn4j0y4Oow33Zg9fdgy-ine9sbWo33ZQjaA>
    <xmx:lKdgXufZT7tHel6HlmR58-dtd7CYjdglRMymc1FHRjf7Lp-CfCiBHQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id B068C328005E;
        Thu,  5 Mar 2020 02:17:38 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 3/5] mlxsw: spectrum_qdisc: Add handle parameter to ..._ops.replace
Date:   Thu,  5 Mar 2020 09:16:42 +0200
Message-Id: <20200305071644.117264-4-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305071644.117264-1-idosch@idosch.org>
References: <20200305071644.117264-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>

PRIO and ETS will need to check the value of qdisc handle in their
handlers. Add it to the callback and propagate through.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c   | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 250b0069d1c1..55751faa9fa4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -29,7 +29,7 @@ struct mlxsw_sp_qdisc_ops {
 	int (*check_params)(struct mlxsw_sp_port *mlxsw_sp_port,
 			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			    void *params);
-	int (*replace)(struct mlxsw_sp_port *mlxsw_sp_port,
+	int (*replace)(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 		       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc, void *params);
 	int (*destroy)(struct mlxsw_sp_port *mlxsw_sp_port,
 		       struct mlxsw_sp_qdisc *mlxsw_sp_qdisc);
@@ -156,7 +156,7 @@ mlxsw_sp_qdisc_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 	if (err)
 		goto err_bad_param;
 
-	err = ops->replace(mlxsw_sp_port, mlxsw_sp_qdisc, params);
+	err = ops->replace(mlxsw_sp_port, handle, mlxsw_sp_qdisc, params);
 	if (err)
 		goto err_config;
 
@@ -409,7 +409,7 @@ mlxsw_sp_qdisc_red_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int
-mlxsw_sp_qdisc_red_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+mlxsw_sp_qdisc_red_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			   void *params)
 {
@@ -657,7 +657,7 @@ mlxsw_sp_qdisc_tbf_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int
-mlxsw_sp_qdisc_tbf_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+mlxsw_sp_qdisc_tbf_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			   void *params)
 {
@@ -792,7 +792,7 @@ mlxsw_sp_qdisc_prio_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int
-__mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+__mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 			     unsigned int nbands,
 			     const unsigned int *quanta,
 			     const unsigned int *weights,
@@ -849,14 +849,14 @@ __mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int
-mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+mlxsw_sp_qdisc_prio_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 			    struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			    void *params)
 {
 	struct tc_prio_qopt_offload_params *p = params;
 	unsigned int zeroes[TCQ_ETS_MAX_BANDS] = {0};
 
-	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, p->bands,
+	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, handle, p->bands,
 					    zeroes, zeroes, p->priomap);
 }
 
@@ -955,13 +955,13 @@ mlxsw_sp_qdisc_ets_check_params(struct mlxsw_sp_port *mlxsw_sp_port,
 }
 
 static int
-mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port,
+mlxsw_sp_qdisc_ets_replace(struct mlxsw_sp_port *mlxsw_sp_port, u32 handle,
 			   struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
 			   void *params)
 {
 	struct tc_ets_qopt_offload_replace_params *p = params;
 
-	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, p->bands,
+	return __mlxsw_sp_qdisc_ets_replace(mlxsw_sp_port, handle, p->bands,
 					    p->quanta, p->weights, p->priomap);
 }
 
-- 
2.24.1


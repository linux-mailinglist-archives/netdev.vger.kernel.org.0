Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CEDFA4330C9
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 10:08:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234595AbhJSIKf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 04:10:35 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45297 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234642AbhJSIKb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 04:10:31 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id A60615C00E8;
        Tue, 19 Oct 2021 04:08:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 19 Oct 2021 04:08:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=E81/taQSShjLdJ2FIVFLJw2nG5ZzNy7DG7B2gy1w5Ig=; b=SWE7Z9Tf
        J/wZz0FE1LtnrgpquvBGO1KoKjy3umrvHb7Rh9BH71IvVwVASLFJPJSizE/6ykva
        goOvFLnVQZMScAGLkFgTO6xNBvrp8CJ4nQfoMrd0gW3pgOviQT0oU+M/hnraX12q
        NTQST4x0ci34M0qDH0960TMAY976rDulKiybr5EIMVmbQ8F8fcvmtm45GxayTkYf
        zv8UubVX3GSeFvG04H88LXZGr5sxKv4mcQTwbNaUuyMimETjkgUOB020T8XUPjN8
        8ms/AwmMq/iaK++biJ9EuQCrMV2kT07bQWdUosVVbBqReFcjLWAhdDOkIl90HrXo
        UtwehjNsCtrTdg==
X-ME-Sender: <xms:8nxuYdnsCtI1T3x4iNS28IgGiUvmE5i2ZIcijaBcVd1jPjGPrjQE6g>
    <xme:8nxuYY3qcw0gSbmicWNEO-yLvbJzoKTa19836r1lBTMTcmY3-38RWqVoum8PoZhQe
    mtfs5u3NkL4-ZM>
X-ME-Received: <xmr:8nxuYTrkcVYU9nGGtA8i3HcFY8EHMmZ9TVHHlrhI6ywcKb3toYtPQM7iLEo6OiNI80kA3M7tkm3zm9wGPyAfYCzO0AFWZS-oGMzgKYIOgJs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddvuddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucevlhhushhtvghrufhiiigvpedvnecu
    rfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:8nxuYdm05RcotXg1dQw2uMDSAjbNYJTx9U65ArOe-ghQrvP8f2JOCw>
    <xmx:8nxuYb26mK9q1Dde0xsAYunmxY2WUulMGQ7mG8OkmgLuG8rPnm7Y6g>
    <xmx:8nxuYcvs74g3cvx5-Js1DhNg-Nv7x0PNnwFhzEAIpDTQ0Fi-k8xn2A>
    <xmx:8nxuYVo6Ycitm_ByriL3mg7mxzANFvB2YcWxDV9Q1mr9GG3RN_3TOw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Oct 2021 04:08:16 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 7/9] mlxsw: spectrum_qdisc: Validate qdisc topology
Date:   Tue, 19 Oct 2021 11:07:10 +0300
Message-Id: <20211019080712.705464-8-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211019080712.705464-1-idosch@idosch.org>
References: <20211019080712.705464-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

A following patch will enable offloading qdiscs that are deeper than
directly under root qdisc. Currently the topology validation consists of
demanding a root qdisc position for ETS and PRIO. Since RED and TBF are
considered classless, this is enough. In order to prevent some nonsensical
combinations when RED and TBF become classful, introduce a more general
topology validator.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 91 +++++++++++++++++--
 1 file changed, 82 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 412394e02d2a..b865fd3ccf31 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -157,8 +157,7 @@ mlxsw_sp_qdisc_walk_cb_find(struct mlxsw_sp_qdisc *qdisc, void *data)
 }
 
 static struct mlxsw_sp_qdisc *
-mlxsw_sp_qdisc_find(struct mlxsw_sp_port *mlxsw_sp_port, u32 parent,
-		    bool root_only)
+mlxsw_sp_qdisc_find(struct mlxsw_sp_port *mlxsw_sp_port, u32 parent)
 {
 	struct mlxsw_sp_qdisc_state *qdisc_state = mlxsw_sp_port->qdisc;
 
@@ -166,8 +165,6 @@ mlxsw_sp_qdisc_find(struct mlxsw_sp_port *mlxsw_sp_port, u32 parent,
 		return NULL;
 	if (parent == TC_H_ROOT)
 		return &qdisc_state->root_qdisc;
-	if (root_only)
-		return NULL;
 	return mlxsw_sp_qdisc_walk(&qdisc_state->root_qdisc,
 				   mlxsw_sp_qdisc_walk_cb_find, &parent);
 }
@@ -268,6 +265,78 @@ mlxsw_sp_qdisc_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 	return err_hdroom ?: err;
 }
 
+struct mlxsw_sp_qdisc_tree_validate {
+	bool forbid_ets;
+	bool forbid_tbf;
+	bool forbid_red;
+};
+
+static int
+__mlxsw_sp_qdisc_tree_validate(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			       struct mlxsw_sp_qdisc_tree_validate validate);
+
+static int
+mlxsw_sp_qdisc_tree_validate_children(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+				      struct mlxsw_sp_qdisc_tree_validate validate)
+{
+	unsigned int i;
+	int err;
+
+	for (i = 0; i < mlxsw_sp_qdisc->num_classes; i++) {
+		err = __mlxsw_sp_qdisc_tree_validate(&mlxsw_sp_qdisc->qdiscs[i],
+						     validate);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
+static int
+__mlxsw_sp_qdisc_tree_validate(struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
+			       struct mlxsw_sp_qdisc_tree_validate validate)
+{
+	if (!mlxsw_sp_qdisc->ops)
+		return 0;
+
+	switch (mlxsw_sp_qdisc->ops->type) {
+	case MLXSW_SP_QDISC_FIFO:
+		break;
+	case MLXSW_SP_QDISC_RED:
+		if (validate.forbid_red)
+			return -EINVAL;
+		validate.forbid_red = true;
+		validate.forbid_ets = true;
+		break;
+	case MLXSW_SP_QDISC_TBF:
+		if (validate.forbid_tbf)
+			return -EINVAL;
+		validate.forbid_tbf = true;
+		validate.forbid_ets = true;
+		break;
+	case MLXSW_SP_QDISC_PRIO:
+	case MLXSW_SP_QDISC_ETS:
+		if (validate.forbid_ets)
+			return -EINVAL;
+		validate.forbid_ets = true;
+		break;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+
+	return mlxsw_sp_qdisc_tree_validate_children(mlxsw_sp_qdisc, validate);
+}
+
+static int mlxsw_sp_qdisc_tree_validate(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	struct mlxsw_sp_qdisc_tree_validate validate = {};
+	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
+
+	mlxsw_sp_qdisc = &mlxsw_sp_port->qdisc->root_qdisc;
+	return __mlxsw_sp_qdisc_tree_validate(mlxsw_sp_qdisc, validate);
+}
+
 static int mlxsw_sp_qdisc_create(struct mlxsw_sp_port *mlxsw_sp_port,
 				 u32 handle,
 				 struct mlxsw_sp_qdisc *mlxsw_sp_qdisc,
@@ -310,6 +379,10 @@ static int mlxsw_sp_qdisc_create(struct mlxsw_sp_port *mlxsw_sp_port,
 	mlxsw_sp_qdisc->num_classes = ops->num_classes;
 	mlxsw_sp_qdisc->ops = ops;
 	mlxsw_sp_qdisc->handle = handle;
+	err = mlxsw_sp_qdisc_tree_validate(mlxsw_sp_port);
+	if (err)
+		goto err_replace;
+
 	err = ops->replace(mlxsw_sp_port, handle, mlxsw_sp_qdisc, params);
 	if (err)
 		goto err_replace;
@@ -748,7 +821,7 @@ static int __mlxsw_sp_setup_tc_red(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
 
-	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent, false);
+	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent);
 	if (!mlxsw_sp_qdisc)
 		return -EOPNOTSUPP;
 
@@ -964,7 +1037,7 @@ static int __mlxsw_sp_setup_tc_tbf(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
 
-	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent, false);
+	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent);
 	if (!mlxsw_sp_qdisc)
 		return -EOPNOTSUPP;
 
@@ -1070,7 +1143,7 @@ static int __mlxsw_sp_setup_tc_fifo(struct mlxsw_sp_port *mlxsw_sp_port,
 	unsigned int band;
 	u32 parent_handle;
 
-	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent, false);
+	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent);
 	if (!mlxsw_sp_qdisc && p->handle == TC_H_UNSPEC) {
 		parent_handle = TC_H_MAJ(p->parent);
 		if (parent_handle != qdisc_state->future_handle) {
@@ -1534,7 +1607,7 @@ static int __mlxsw_sp_setup_tc_prio(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
 
-	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent, true);
+	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent);
 	if (!mlxsw_sp_qdisc)
 		return -EOPNOTSUPP;
 
@@ -1579,7 +1652,7 @@ static int __mlxsw_sp_setup_tc_ets(struct mlxsw_sp_port *mlxsw_sp_port,
 {
 	struct mlxsw_sp_qdisc *mlxsw_sp_qdisc;
 
-	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent, true);
+	mlxsw_sp_qdisc = mlxsw_sp_qdisc_find(mlxsw_sp_port, p->parent);
 	if (!mlxsw_sp_qdisc)
 		return -EOPNOTSUPP;
 
-- 
2.31.1


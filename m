Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C166B337286
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:25:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhCKMZR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:25:17 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:37005 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232878AbhCKMZK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:25:10 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 274055C0131;
        Thu, 11 Mar 2021 07:25:10 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 11 Mar 2021 07:25:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=8WQnWuvLLKvEEvwgZGWU4BnzGUGXXaC1ri7lDcOj7cw=; b=FqlGCsI+
        4ssDuuCWDqriTbGkv8rwd45/OOcwEERAZ8HSG9+1v6pmCIfEuYhVHj6HpWzetKtz
        jPzGlnn65vLL8FSIjzDuCDKjWXG0DLc5rrLp9rlT87ExNjiaZyeTl675Gjd+K3d0
        vxaRpfwdViIu5r6TbKU+rHIxL33SoUPcPfIYLYJUufiyjup43Xirgzq9Ifrva8JL
        +PdCddJfP2yp+Gu2OsJLq06z9EYS7iOiDMN47JlsAB85B/0EjdDlqy9DQo/+a+Pq
        t1Aja065xSfzgDJpZ+/56RQ2sW0zy6cw+pKtGBrdSpy1/k3hidBYkctXMZTaGZFf
        iw0dD50D7t85fQ==
X-ME-Sender: <xms:JgxKYOpp7ovFOE8QLYhMmovst9MGYCWoeTfDG5WVD2TJ58ypdL_dog>
    <xme:JgxKYMnV2L-nUPhuyi4GDU-fNL18dqyzCSoMeiEvawpxootMYUpMOEJknsH4aY8uJ
    bfFEBaBotcDzpM>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:JgxKYAGS1oPowYivHLTTAT3KixuHu9f1r7tvfZRlMdkmZK8I4gVT2w>
    <xmx:JgxKYFr9HyLOxzbNtZAAsTXJVkvF0vHZyKogJhfJtN_EB8vBszxrXw>
    <xmx:JgxKYM7ENO-hKMTaKCYG0ECWfRg2Gb_D1-OY6nPvSyeAUOqCfN9T_A>
    <xmx:JgxKYI1KTF1Jqtu0sL7RkRPDSgp2Rclii86gxyX5OoaTgu20Fvm9Tw>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id F370F108005C;
        Thu, 11 Mar 2021 07:25:08 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/6] mlxsw: spectrum_span: Add SPAN probability rate support
Date:   Thu, 11 Mar 2021 14:24:13 +0200
Message-Id: <20210311122416.2620300-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311122416.2620300-1-idosch@idosch.org>
References: <20210311122416.2620300-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Currently, every packet that matches a mirroring trigger (e.g., received
packets, buffer dropped packets) is mirrored. Spectrum-2 and later ASICs
support mirroring with probability, where every 1 in N matched packets
is mirrored.

Extend the API that creates the binding between the trigger and the SPAN
agent with a probability rate parameter, which is an attribute of the
trigger. Set it to '1' to maintain existing behavior.

Subsequent patches will use it to perform more sophisticated sampling,
by mirroring packets to the CPU with probability.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_matchall.c   |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c  |  1 +
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c   | 15 ++++++++++++---
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h   |  1 +
 4 files changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index f30599ad6019..2b7652b4b0bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -51,6 +51,7 @@ mlxsw_sp_mall_port_mirror_add(struct mlxsw_sp_port *mlxsw_sp_port,
 	trigger = mall_entry->ingress ? MLXSW_SP_SPAN_TRIGGER_INGRESS :
 					MLXSW_SP_SPAN_TRIGGER_EGRESS;
 	parms.span_id = mall_entry->mirror.span_id;
+	parms.probability_rate = 1;
 	err = mlxsw_sp_span_agent_bind(mlxsw_sp, trigger, mlxsw_sp_port,
 				       &parms);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 9d16823320ae..baf17c0b2702 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1341,6 +1341,7 @@ static int mlxsw_sp_qevent_span_configure(struct mlxsw_sp *mlxsw_sp,
 		goto err_analyzed_port_get;
 
 	trigger_parms.span_id = span_id;
+	trigger_parms.probability_rate = 1;
 	err = mlxsw_sp_span_agent_bind(mlxsw_sp, qevent_binding->span_trigger, mlxsw_sp_port,
 				       &trigger_parms);
 	if (err)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 7711ace07ec8..3398cc01e5ec 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -1231,8 +1231,12 @@ __mlxsw_sp_span_trigger_port_bind(struct mlxsw_sp_span *span,
 		return -EINVAL;
 	}
 
+	if (trigger_entry->parms.probability_rate > MLXSW_REG_MPAR_RATE_MAX)
+		return -EINVAL;
+
 	mlxsw_reg_mpar_pack(mpar_pl, trigger_entry->local_port, i_e, enable,
-			    trigger_entry->parms.span_id, 1);
+			    trigger_entry->parms.span_id,
+			    trigger_entry->parms.probability_rate);
 	return mlxsw_reg_write(span->mlxsw_sp->core, MLXSW_REG(mpar), mpar_pl);
 }
 
@@ -1366,8 +1370,11 @@ mlxsw_sp2_span_trigger_global_bind(struct mlxsw_sp_span_trigger_entry *
 		return -EINVAL;
 	}
 
+	if (trigger_entry->parms.probability_rate > MLXSW_REG_MPAGR_RATE_MAX)
+		return -EINVAL;
+
 	mlxsw_reg_mpagr_pack(mpagr_pl, trigger, trigger_entry->parms.span_id,
-			     1);
+			     trigger_entry->parms.probability_rate);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mpagr), mpagr_pl);
 }
 
@@ -1565,7 +1572,9 @@ int mlxsw_sp_span_agent_bind(struct mlxsw_sp *mlxsw_sp,
 							 trigger,
 							 mlxsw_sp_port);
 	if (trigger_entry) {
-		if (trigger_entry->parms.span_id != parms->span_id)
+		if (trigger_entry->parms.span_id != parms->span_id ||
+		    trigger_entry->parms.probability_rate !=
+		    parms->probability_rate)
 			return -EINVAL;
 		refcount_inc(&trigger_entry->ref_count);
 		goto out;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index 6e84cc049428..dea1c0d31310 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -48,6 +48,7 @@ enum mlxsw_sp_span_trigger {
 
 struct mlxsw_sp_span_trigger_parms {
 	int span_id;
+	u32 probability_rate;
 };
 
 struct mlxsw_sp_span_agent_parms {
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED524337284
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 13:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233106AbhCKMZP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 07:25:15 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58875 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232813AbhCKMZH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 07:25:07 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2D4375C017F;
        Thu, 11 Mar 2021 07:25:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 11 Mar 2021 07:25:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=PgS6RhO67ehT1TCJo8Tycn+TJV6U5MIq5a74k7NxfJU=; b=iVPQJfqf
        3vkpoUEEmTdjIYEWvPvsiOOvpEFVX+8ruu8JINXE7R0UnyTs2/LXx0RKQNB3C5yL
        rW3AVg9DdODKxDQU2Yu2mCly3gvnKiRSGBUZa4lfNBOmuEvp6P+elzZFu7ojISOY
        XxxnEQPYqeMvb4yLD/53T52F7o/37vAgAku+EUCMdZK/WPSiixQehHOCHYUDEhQS
        HxyLTueq1YIPtV6dgyxB+8/FxZ4YkEQ/ZxbaoKcnUpfPudZIs1Y49vluMnGxLgEK
        kZz8PVRSx9cirI0RM/hnZdF1rsmjS74rCr7y8ZZalJzaT0+o272/gfh7oonGoSPH
        UjTMRjPBnCuOhw==
X-ME-Sender: <xms:IwxKYBcEOikuaQbLHZQ-ZJEf0WI2-1gbAWWjmkipokjYyOyPwdwZDg>
    <xme:IwxKYPODiqxdpXWNLzA-9UoiZZZqMUGSpdAcc7hnCWRiG1DS2uzg8os5Byua598rj
    DcdnmFzmMXKc8U>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddggedtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:IwxKYKjY6j7yoJkv7MdMaJBrXAtfFrhzzM88rq4OY_UsUTl4zGLgzg>
    <xmx:IwxKYK-baHjp9oW2an6U9pfkjb6yV5yy0vi8uRgev8o2RGelUi16AQ>
    <xmx:IwxKYNtHAcSlWGobNf1msfR38quJ74baJRJTW8tnVF_T0TDr3iPMDg>
    <xmx:IwxKYG5VPTS8G_RUdqXlbvXSXMstKW1ayc-Gv-YcML7bZViqrzqzAA>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 626C91080068;
        Thu, 11 Mar 2021 07:25:05 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/6] mlxsw: spectrum_span: Add SPAN session identifier support
Date:   Thu, 11 Mar 2021 14:24:11 +0200
Message-Id: <20210311122416.2620300-2-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210311122416.2620300-1-idosch@idosch.org>
References: <20210311122416.2620300-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

When packets are mirrored to the CPU, the trap identifier with which the
packets are trapped is determined according to the session identifier of
the SPAN agent performing the mirroring. Packets that are trapped for
the same logical reason (e.g., buffer drops) should use the same session
identifier.

Currently, a single session is implicitly supported (identifier 0) and
is used for packets that are mirrored to the CPU due to buffer drops
(e.g., early drop).

Subsequent patches are going to mirror packets to the CPU due to
sampling, which will require a different session identifier.

Prepare for that by making the session identifier an attribute of the
SPAN agent.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_qdisc.c   |  4 +++-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |  6 +++++-
 .../net/ethernet/mellanox/mlxsw/spectrum_span.h    | 14 ++++++++++++++
 3 files changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index fd672c6c9133..9d16823320ae 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1404,7 +1404,9 @@ static int mlxsw_sp_qevent_trap_configure(struct mlxsw_sp *mlxsw_sp,
 					  struct mlxsw_sp_mall_entry *mall_entry,
 					  struct mlxsw_sp_qevent_binding *qevent_binding)
 {
-	struct mlxsw_sp_span_agent_parms agent_parms = {};
+	struct mlxsw_sp_span_agent_parms agent_parms = {
+		.session_id = MLXSW_SP_SPAN_SESSION_ID_BUFFER,
+	};
 	int err;
 
 	err = mlxsw_sp_trap_group_policer_hw_id_get(mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 1892cea05ee7..3287211819df 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -186,6 +186,7 @@ mlxsw_sp_span_entry_phys_configure(struct mlxsw_sp_span_entry *span_entry,
 	/* Create a new port analayzer entry for local_port. */
 	mlxsw_reg_mpat_pack(mpat_pl, pa_id, local_port, true,
 			    MLXSW_REG_MPAT_SPAN_TYPE_LOCAL_ETH);
+	mlxsw_reg_mpat_session_id_set(mpat_pl, sparms.session_id);
 	mlxsw_reg_mpat_pide_set(mpat_pl, sparms.policer_enable);
 	mlxsw_reg_mpat_pid_set(mpat_pl, sparms.policer_id);
 
@@ -203,6 +204,7 @@ mlxsw_sp_span_entry_deconfigure_common(struct mlxsw_sp_span_entry *span_entry,
 	int pa_id = span_entry->id;
 
 	mlxsw_reg_mpat_pack(mpat_pl, pa_id, local_port, false, span_type);
+	mlxsw_reg_mpat_session_id_set(mpat_pl, span_entry->parms.session_id);
 	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mpat), mpat_pl);
 }
 
@@ -938,7 +940,8 @@ mlxsw_sp_span_entry_find_by_parms(struct mlxsw_sp *mlxsw_sp,
 
 		if (refcount_read(&curr->ref_count) && curr->to_dev == to_dev &&
 		    curr->parms.policer_enable == sparms->policer_enable &&
-		    curr->parms.policer_id == sparms->policer_id)
+		    curr->parms.policer_id == sparms->policer_id &&
+		    curr->parms.session_id == sparms->session_id)
 			return curr;
 	}
 	return NULL;
@@ -1085,6 +1088,7 @@ int mlxsw_sp_span_agent_get(struct mlxsw_sp *mlxsw_sp, int *p_span_id,
 
 	sparms.policer_id = parms->policer_id;
 	sparms.policer_enable = parms->policer_enable;
+	sparms.session_id = parms->session_id;
 	span_entry = mlxsw_sp_span_entry_get(mlxsw_sp, to_dev, ops, sparms);
 	if (!span_entry)
 		return -ENOBUFS;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index aa1cd409c0e2..6e84cc049428 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -13,6 +13,18 @@
 struct mlxsw_sp;
 struct mlxsw_sp_port;
 
+/* SPAN session identifiers that correspond to MLXSW_TRAP_ID_MIRROR_SESSION<i>
+ * trap identifiers. The session identifier is an attribute of the SPAN agent,
+ * which determines the trap identifier of packets that are mirrored to the
+ * CPU. Packets that are trapped to the CPU for the same logical reason (e.g.,
+ * buffer drops) should use the same session identifier.
+ */
+enum mlxsw_sp_span_session_id {
+	MLXSW_SP_SPAN_SESSION_ID_BUFFER,
+
+	__MLXSW_SP_SPAN_SESSION_ID_MAX = 8,
+};
+
 struct mlxsw_sp_span_parms {
 	struct mlxsw_sp_port *dest_port; /* NULL for unoffloaded SPAN. */
 	unsigned int ttl;
@@ -23,6 +35,7 @@ struct mlxsw_sp_span_parms {
 	u16 vid;
 	u16 policer_id;
 	bool policer_enable;
+	enum mlxsw_sp_span_session_id session_id;
 };
 
 enum mlxsw_sp_span_trigger {
@@ -41,6 +54,7 @@ struct mlxsw_sp_span_agent_parms {
 	const struct net_device *to_dev;
 	u16 policer_id;
 	bool policer_enable;
+	enum mlxsw_sp_span_session_id session_id;
 };
 
 struct mlxsw_sp_span_entry_ops;
-- 
2.29.2


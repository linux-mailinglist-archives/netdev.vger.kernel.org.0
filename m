Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34E021B759
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgGJN6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:20 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:43831 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727906AbgGJN6T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:19 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 85A7758059A;
        Fri, 10 Jul 2020 09:58:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=blA7I+RWGFsXSmmtUbIYN0TNsaWuWKmmmdYwxNVmAK4=; b=J0wV6Rd+
        cjzn45er2TYhQIenB2sausG1vkuwbBJCzYn5Q1cpSmBh/Bwpy+HkE4DC6TdWqzcT
        fKCAKHCNUObrjAI6JuF9LClmpv2qrnJ1JQBC5MpMS7TG4GayDFneWLXIlYLbbXUB
        BpdMC3wi0UN9xSY41zHD8Ag3un6YdeQX0wGSkqQCcFhLV81swH19E6yNgu402g1i
        dIsdlWfDQ9r4WG874TJTOEXbr8pTmncwm+dTC8LiadQC8AsHQNhzaOVunD6ukRZo
        0BaBY8Z98Vo38HyzcrlhoiXJLBXc68m+Mu6Rx1xsLPTAFtwSx/47nlASZgrf+x+t
        wYexPzOr2umtkg==
X-ME-Sender: <xms:-nMIXz8wKcgHGZOjkx_KbzS045a6df8WNTWiEwlgLKyA_uaGiWpNuA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:-nMIX_tA7J4-FQAMFGW80l_4jSZwEuHsqMdc_nAwKAlQHYOoogoWbA>
    <xmx:-nMIXxCFvXVLkX9H7blSzmZ1BlQlRG39Cgjc-GHFysY79ximOYp80Q>
    <xmx:-nMIX_dz4TZ6X_GCFgqpR-5hO9avgaNrqEkmK1KowPPtWEhaisCshA>
    <xmx:-nMIXxnH6TuIkHVZ1gkcOn3ey1oNxI7CxyoETWsz4mhxwXGtbQwSIQ>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7C72D328005E;
        Fri, 10 Jul 2020 09:58:14 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 06/13] mlxsw: spectrum_span: Add support for global mirroring triggers
Date:   Fri, 10 Jul 2020 16:56:59 +0300
Message-Id: <20200710135706.601409-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200710135706.601409-1-idosch@idosch.org>
References: <20200710135706.601409-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Global mirroring triggers are triggers that are only keyed by their
trigger, as opposed to per-port triggers, which are keyed by their
trigger and port.

Such triggers allow mirroring packets that were tail/early dropped or
ECN marked to a SPAN agent.

Implement the previously added trigger operations for these global
triggers. Since such triggers are only supported from Spectrum-2
onwards, have the Spectrum-1 operations return an error.

Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 104 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |   3 +
 2 files changed, 104 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index b20422dde147..fa223c1351b4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -49,6 +49,7 @@ struct mlxsw_sp_span_trigger_entry {
 
 enum mlxsw_sp_span_trigger_type {
 	MLXSW_SP_SPAN_TRIGGER_TYPE_PORT,
+	MLXSW_SP_SPAN_TRIGGER_TYPE_GLOBAL,
 };
 
 struct mlxsw_sp_span_trigger_ops {
@@ -1140,9 +1141,101 @@ mlxsw_sp_span_trigger_port_ops = {
 	.matches = mlxsw_sp_span_trigger_port_matches,
 };
 
+static int
+mlxsw_sp1_span_trigger_global_bind(struct mlxsw_sp_span_trigger_entry *
+				   trigger_entry)
+{
+	return -EOPNOTSUPP;
+}
+
+static void
+mlxsw_sp1_span_trigger_global_unbind(struct mlxsw_sp_span_trigger_entry *
+				     trigger_entry)
+{
+}
+
+static bool
+mlxsw_sp1_span_trigger_global_matches(struct mlxsw_sp_span_trigger_entry *
+				      trigger_entry,
+				      enum mlxsw_sp_span_trigger trigger,
+				      struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	WARN_ON_ONCE(1);
+	return false;
+}
+
+static const struct mlxsw_sp_span_trigger_ops
+mlxsw_sp1_span_trigger_global_ops = {
+	.bind = mlxsw_sp1_span_trigger_global_bind,
+	.unbind = mlxsw_sp1_span_trigger_global_unbind,
+	.matches = mlxsw_sp1_span_trigger_global_matches,
+};
+
+static const struct mlxsw_sp_span_trigger_ops *
+mlxsw_sp1_span_trigger_ops_arr[] = {
+	[MLXSW_SP_SPAN_TRIGGER_TYPE_PORT] = &mlxsw_sp_span_trigger_port_ops,
+	[MLXSW_SP_SPAN_TRIGGER_TYPE_GLOBAL] =
+		&mlxsw_sp1_span_trigger_global_ops,
+};
+
+static int
+mlxsw_sp2_span_trigger_global_bind(struct mlxsw_sp_span_trigger_entry *
+				   trigger_entry)
+{
+	struct mlxsw_sp *mlxsw_sp = trigger_entry->span->mlxsw_sp;
+	enum mlxsw_reg_mpagr_trigger trigger;
+	char mpagr_pl[MLXSW_REG_MPAGR_LEN];
+
+	switch (trigger_entry->trigger) {
+	case MLXSW_SP_SPAN_TRIGGER_TAIL_DROP:
+		trigger = MLXSW_REG_MPAGR_TRIGGER_INGRESS_SHARED_BUFFER;
+		break;
+	case MLXSW_SP_SPAN_TRIGGER_EARLY_DROP:
+		trigger = MLXSW_REG_MPAGR_TRIGGER_INGRESS_WRED;
+		break;
+	case MLXSW_SP_SPAN_TRIGGER_ECN:
+		trigger = MLXSW_REG_MPAGR_TRIGGER_EGRESS_ECN;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	mlxsw_reg_mpagr_pack(mpagr_pl, trigger, trigger_entry->parms.span_id,
+			     1);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mpagr), mpagr_pl);
+}
+
+static void
+mlxsw_sp2_span_trigger_global_unbind(struct mlxsw_sp_span_trigger_entry *
+				     trigger_entry)
+{
+	/* There is no unbinding for global triggers. The trigger should be
+	 * disabled on all ports by now.
+	 */
+}
+
+static bool
+mlxsw_sp2_span_trigger_global_matches(struct mlxsw_sp_span_trigger_entry *
+				      trigger_entry,
+				      enum mlxsw_sp_span_trigger trigger,
+				      struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	return trigger_entry->trigger == trigger;
+}
+
+static const struct mlxsw_sp_span_trigger_ops
+mlxsw_sp2_span_trigger_global_ops = {
+	.bind = mlxsw_sp2_span_trigger_global_bind,
+	.unbind = mlxsw_sp2_span_trigger_global_unbind,
+	.matches = mlxsw_sp2_span_trigger_global_matches,
+};
+
 static const struct mlxsw_sp_span_trigger_ops *
-mlxsw_sp_span_trigger_ops_arr[] = {
+mlxsw_sp2_span_trigger_ops_arr[] = {
 	[MLXSW_SP_SPAN_TRIGGER_TYPE_PORT] = &mlxsw_sp_span_trigger_port_ops,
+	[MLXSW_SP_SPAN_TRIGGER_TYPE_GLOBAL] =
+		&mlxsw_sp2_span_trigger_global_ops,
 };
 
 static void
@@ -1156,6 +1249,11 @@ mlxsw_sp_span_trigger_ops_set(struct mlxsw_sp_span_trigger_entry *trigger_entry)
 	case MLXSW_SP_SPAN_TRIGGER_EGRESS:
 		type = MLXSW_SP_SPAN_TRIGGER_TYPE_PORT;
 		break;
+	case MLXSW_SP_SPAN_TRIGGER_TAIL_DROP: /* fall-through */
+	case MLXSW_SP_SPAN_TRIGGER_EARLY_DROP: /* fall-through */
+	case MLXSW_SP_SPAN_TRIGGER_ECN:
+		type = MLXSW_SP_SPAN_TRIGGER_TYPE_GLOBAL;
+		break;
 	default:
 		WARN_ON_ONCE(1);
 		return;
@@ -1286,7 +1384,7 @@ void mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 
 static int mlxsw_sp1_span_init(struct mlxsw_sp *mlxsw_sp)
 {
-	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp_span_trigger_ops_arr;
+	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp1_span_trigger_ops_arr;
 
 	return 0;
 }
@@ -1303,7 +1401,7 @@ const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops = {
 
 static int mlxsw_sp2_span_init(struct mlxsw_sp *mlxsw_sp)
 {
-	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp_span_trigger_ops_arr;
+	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp2_span_trigger_ops_arr;
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index b9acecaf6ee2..bb7939b3f09c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -26,6 +26,9 @@ struct mlxsw_sp_span_parms {
 enum mlxsw_sp_span_trigger {
 	MLXSW_SP_SPAN_TRIGGER_INGRESS,
 	MLXSW_SP_SPAN_TRIGGER_EGRESS,
+	MLXSW_SP_SPAN_TRIGGER_TAIL_DROP,
+	MLXSW_SP_SPAN_TRIGGER_EARLY_DROP,
+	MLXSW_SP_SPAN_TRIGGER_ECN,
 };
 
 struct mlxsw_sp_span_trigger_parms {
-- 
2.26.2


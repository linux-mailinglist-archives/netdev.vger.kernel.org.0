Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0681821B75F
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 15:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727906AbgGJN6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 09:58:25 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:44053 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726962AbgGJN6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 09:58:24 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id AD5C658058B;
        Fri, 10 Jul 2020 09:58:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Fri, 10 Jul 2020 09:58:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=MCQpCMz5d4VBJYiaWzCnTWcQsN9XpgaUMe53K0M2Bu4=; b=sRLCLnPm
        HGiQF7eMWlDheQy85ELvXoas6gJBQkopNx+RN9EM0SxW83nHBujdrfdpDBqlc8SQ
        YdBp800HTUU93Fo09ilsIltd1OicSIHOmqcwi1C45ijgpjfQNYbeoaT476Qt53Sf
        tARt0k1qOOWOpQa5qfGs+2r5v6mZ8dNlx6stBRxDfVG6siD5qyI/t2+4lZttVBvu
        juo9/P+xn5JQadfH6qkICAP2FQGqNx86rPQCqlBdiTgr246lZpxVz44Sl6hWGUoT
        laujt3yCMKYmiSFSm3gF0K1d32lydiOK4IWMD4Y+Bl07+QvDq3C5em7Z+cma+sJ2
        eaQZK9/Yd0lnAA==
X-ME-Sender: <xms:_nMIX8CHj3hPStBmPATp3x_dtlPbPfBTVfYi-oxq4_qgS2MNWa4hdQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrvddugdejgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepuddtledrieeirdduledrudeffeen
    ucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:_nMIX-hoCTarqBxMhDF20KFuSO5Gs2ylsZ8fT2zisTpgtuMm4VflKQ>
    <xmx:_nMIX_lyglPgYhTGogfASdMhOESmmuVsRPeg6ZyMVyvhxTei_usVhQ>
    <xmx:_nMIXywWRvJ5O0q4CzOq2KBudRaLdBdg0kQAsqG07NE9cuSY3j5WRg>
    <xmx:_nMIXxZKZEAI0VFmf1yNaukqY-1O3JtGybW3wYP7VxPa_4paH0sMsw>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id C54E8328005A;
        Fri, 10 Jul 2020 09:58:18 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/13] mlxsw: spectrum_span: Add APIs to enable / disable global mirroring triggers
Date:   Fri, 10 Jul 2020 16:57:00 +0300
Message-Id: <20200710135706.601409-8-idosch@idosch.org>
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

While the binding of global mirroring triggers to a SPAN agent is
global, packets are only mirrored if they belong to a port and TC on
which the trigger was enabled. This allows, for example, to mirror
packets that were tail-dropped on a specific netdev.

Implement the operations that allow to enable / disable a global
mirroring trigger on a specific port and TC.

Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_span.c   | 135 ++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_span.h   |   4 +
 2 files changed, 139 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index fa223c1351b4..6374765a112d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -58,6 +58,10 @@ struct mlxsw_sp_span_trigger_ops {
 	bool (*matches)(struct mlxsw_sp_span_trigger_entry *trigger_entry,
 			enum mlxsw_sp_span_trigger trigger,
 			struct mlxsw_sp_port *mlxsw_sp_port);
+	int (*enable)(struct mlxsw_sp_span_trigger_entry *trigger_entry,
+		      struct mlxsw_sp_port *mlxsw_sp_port, u8 tc);
+	void (*disable)(struct mlxsw_sp_span_trigger_entry *trigger_entry,
+			struct mlxsw_sp_port *mlxsw_sp_port, u8 tc);
 };
 
 static void mlxsw_sp_span_respin_work(struct work_struct *work);
@@ -1134,11 +1138,29 @@ mlxsw_sp_span_trigger_port_matches(struct mlxsw_sp_span_trigger_entry *
 	       trigger_entry->local_port == mlxsw_sp_port->local_port;
 }
 
+static int
+mlxsw_sp_span_trigger_port_enable(struct mlxsw_sp_span_trigger_entry *
+				  trigger_entry,
+				  struct mlxsw_sp_port *mlxsw_sp_port, u8 tc)
+{
+	/* Port trigger are enabled during binding. */
+	return 0;
+}
+
+static void
+mlxsw_sp_span_trigger_port_disable(struct mlxsw_sp_span_trigger_entry *
+				   trigger_entry,
+				   struct mlxsw_sp_port *mlxsw_sp_port, u8 tc)
+{
+}
+
 static const struct mlxsw_sp_span_trigger_ops
 mlxsw_sp_span_trigger_port_ops = {
 	.bind = mlxsw_sp_span_trigger_port_bind,
 	.unbind = mlxsw_sp_span_trigger_port_unbind,
 	.matches = mlxsw_sp_span_trigger_port_matches,
+	.enable = mlxsw_sp_span_trigger_port_enable,
+	.disable = mlxsw_sp_span_trigger_port_disable,
 };
 
 static int
@@ -1164,11 +1186,30 @@ mlxsw_sp1_span_trigger_global_matches(struct mlxsw_sp_span_trigger_entry *
 	return false;
 }
 
+static int
+mlxsw_sp1_span_trigger_global_enable(struct mlxsw_sp_span_trigger_entry *
+				     trigger_entry,
+				     struct mlxsw_sp_port *mlxsw_sp_port,
+				     u8 tc)
+{
+	return -EOPNOTSUPP;
+}
+
+static void
+mlxsw_sp1_span_trigger_global_disable(struct mlxsw_sp_span_trigger_entry *
+				      trigger_entry,
+				      struct mlxsw_sp_port *mlxsw_sp_port,
+				      u8 tc)
+{
+}
+
 static const struct mlxsw_sp_span_trigger_ops
 mlxsw_sp1_span_trigger_global_ops = {
 	.bind = mlxsw_sp1_span_trigger_global_bind,
 	.unbind = mlxsw_sp1_span_trigger_global_unbind,
 	.matches = mlxsw_sp1_span_trigger_global_matches,
+	.enable = mlxsw_sp1_span_trigger_global_enable,
+	.disable = mlxsw_sp1_span_trigger_global_disable,
 };
 
 static const struct mlxsw_sp_span_trigger_ops *
@@ -1224,11 +1265,71 @@ mlxsw_sp2_span_trigger_global_matches(struct mlxsw_sp_span_trigger_entry *
 	return trigger_entry->trigger == trigger;
 }
 
+static int
+__mlxsw_sp2_span_trigger_global_enable(struct mlxsw_sp_span_trigger_entry *
+				       trigger_entry,
+				       struct mlxsw_sp_port *mlxsw_sp_port,
+				       u8 tc, bool enable)
+{
+	struct mlxsw_sp *mlxsw_sp = trigger_entry->span->mlxsw_sp;
+	char momte_pl[MLXSW_REG_MOMTE_LEN];
+	enum mlxsw_reg_momte_type type;
+	int err;
+
+	switch (trigger_entry->trigger) {
+	case MLXSW_SP_SPAN_TRIGGER_TAIL_DROP:
+		type = MLXSW_REG_MOMTE_TYPE_SHARED_BUFFER_TCLASS;
+		break;
+	case MLXSW_SP_SPAN_TRIGGER_EARLY_DROP:
+		type = MLXSW_REG_MOMTE_TYPE_WRED;
+		break;
+	case MLXSW_SP_SPAN_TRIGGER_ECN:
+		type = MLXSW_REG_MOMTE_TYPE_ECN;
+		break;
+	default:
+		WARN_ON_ONCE(1);
+		return -EINVAL;
+	}
+
+	/* Query existing configuration in order to only change the state of
+	 * the specified traffic class.
+	 */
+	mlxsw_reg_momte_pack(momte_pl, mlxsw_sp_port->local_port, type);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(momte), momte_pl);
+	if (err)
+		return err;
+
+	mlxsw_reg_momte_tclass_en_set(momte_pl, tc, enable);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(momte), momte_pl);
+}
+
+static int
+mlxsw_sp2_span_trigger_global_enable(struct mlxsw_sp_span_trigger_entry *
+				     trigger_entry,
+				     struct mlxsw_sp_port *mlxsw_sp_port,
+				     u8 tc)
+{
+	return __mlxsw_sp2_span_trigger_global_enable(trigger_entry,
+						      mlxsw_sp_port, tc, true);
+}
+
+static void
+mlxsw_sp2_span_trigger_global_disable(struct mlxsw_sp_span_trigger_entry *
+				      trigger_entry,
+				      struct mlxsw_sp_port *mlxsw_sp_port,
+				      u8 tc)
+{
+	__mlxsw_sp2_span_trigger_global_enable(trigger_entry, mlxsw_sp_port, tc,
+					       false);
+}
+
 static const struct mlxsw_sp_span_trigger_ops
 mlxsw_sp2_span_trigger_global_ops = {
 	.bind = mlxsw_sp2_span_trigger_global_bind,
 	.unbind = mlxsw_sp2_span_trigger_global_unbind,
 	.matches = mlxsw_sp2_span_trigger_global_matches,
+	.enable = mlxsw_sp2_span_trigger_global_enable,
+	.disable = mlxsw_sp2_span_trigger_global_disable,
 };
 
 static const struct mlxsw_sp_span_trigger_ops *
@@ -1382,6 +1483,40 @@ void mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_span_trigger_entry_destroy(mlxsw_sp->span, trigger_entry);
 }
 
+int mlxsw_sp_span_trigger_enable(struct mlxsw_sp_port *mlxsw_sp_port,
+				 enum mlxsw_sp_span_trigger trigger, u8 tc)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_span_trigger_entry *trigger_entry;
+
+	ASSERT_RTNL();
+
+	trigger_entry = mlxsw_sp_span_trigger_entry_find(mlxsw_sp->span,
+							 trigger,
+							 mlxsw_sp_port);
+	if (WARN_ON_ONCE(!trigger_entry))
+		return -EINVAL;
+
+	return trigger_entry->ops->enable(trigger_entry, mlxsw_sp_port, tc);
+}
+
+void mlxsw_sp_span_trigger_disable(struct mlxsw_sp_port *mlxsw_sp_port,
+				   enum mlxsw_sp_span_trigger trigger, u8 tc)
+{
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_span_trigger_entry *trigger_entry;
+
+	ASSERT_RTNL();
+
+	trigger_entry = mlxsw_sp_span_trigger_entry_find(mlxsw_sp->span,
+							 trigger,
+							 mlxsw_sp_port);
+	if (WARN_ON_ONCE(!trigger_entry))
+		return;
+
+	return trigger_entry->ops->disable(trigger_entry, mlxsw_sp_port, tc);
+}
+
 static int mlxsw_sp1_span_init(struct mlxsw_sp *mlxsw_sp)
 {
 	mlxsw_sp->span->span_trigger_ops_arr = mlxsw_sp1_span_trigger_ops_arr;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
index bb7939b3f09c..29b96b222e25 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.h
@@ -89,6 +89,10 @@ mlxsw_sp_span_agent_unbind(struct mlxsw_sp *mlxsw_sp,
 			   enum mlxsw_sp_span_trigger trigger,
 			   struct mlxsw_sp_port *mlxsw_sp_port,
 			   const struct mlxsw_sp_span_trigger_parms *parms);
+int mlxsw_sp_span_trigger_enable(struct mlxsw_sp_port *mlxsw_sp_port,
+				 enum mlxsw_sp_span_trigger trigger, u8 tc);
+void mlxsw_sp_span_trigger_disable(struct mlxsw_sp_port *mlxsw_sp_port,
+				   enum mlxsw_sp_span_trigger trigger, u8 tc);
 
 extern const struct mlxsw_sp_span_ops mlxsw_sp1_span_ops;
 extern const struct mlxsw_sp_span_ops mlxsw_sp2_span_ops;
-- 
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 352971BA790
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 17:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgD0PNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 11:13:49 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:52485 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728038AbgD0PNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Apr 2020 11:13:44 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 645765C0098;
        Mon, 27 Apr 2020 11:13:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 27 Apr 2020 11:13:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=5IR4joumjEh1RF98nrq9DDJMFQOVlKaPyV0y+HkktxY=; b=X/Zs57gx
        xevjqy5QGF8npmX6O4SG8fUVx3pmqhEgYscDKlASprYEmpshsuBfINhavkAWlHzY
        CTZk22VjEnU49KRXR5kA9cIhHvpzVEKcDzb9oqt8pU07rPTdfjAmzw+04iRB6zlw
        R0PC7BOkpqswHG2EgHd8/NZkexVCBN3v7WPcRq9LVK/bgxwm9gKh7f/W+Yd7vdAi
        e4fXvPMSnccIztxsnCBEo2z9szDmWjIJSDxpipKZOdy26aovugj4BcvnHX3OIpO0
        DMsq22AyKpcYYuDtuk+1iv3omdOIAmGWJF3cmPJj6VaSo5r5E/+mpwiAN6Ga8QYt
        tqodgRXxG53Iug==
X-ME-Sender: <xms:p_amXh8sTEgObuijY1l8DPHAQYQZWHZY0zP16l21WbkDpAJOUZ-uZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdekgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucfkphepjeelrddukedtrdehgedrudduieenucevlhhushhtvghruf
    hiiigvpeejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghh
    rdhorhhg
X-ME-Proxy: <xmx:p_amXvHuDJhyVK_64i-TaWhn1IfL-FEG_qclBeKr1Z9VvVe6dyBM7Q>
    <xmx:p_amXniAWXBmadtOfo4BhS_n-ia2R3g31OztPR8ewcF8k8I-qOt8Cg>
    <xmx:p_amXk8BYPq_78WgKeKcPS_LORS0aQLCeHSrDRYnYi1B4d-86im-TA>
    <xmx:p_amXn-JCvFsFS9KkJ-kbt-V03ckpSQx8CTSBLAS72WIWSVg_d9RFw>
Received: from splinter.mtl.com (bzq-79-180-54-116.red.bezeqint.net [79.180.54.116])
        by mail.messagingengine.com (Postfix) with ESMTPA id 228C73280059;
        Mon, 27 Apr 2020 11:13:41 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/13] mlxsw: spectrum_matchall: Push per-port rule add/del into separate functions
Date:   Mon, 27 Apr 2020 18:13:06 +0300
Message-Id: <20200427151310.3950411-10-idosch@idosch.org>
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

As the replace/destroy is going to be used later on per-block, push
the per-port rule addition/deletion into separate functions.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_matchall.c        | 48 ++++++++++++++-----
 1 file changed, 35 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
index c05e28971d06..41301027a47c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_matchall.c
@@ -123,6 +123,37 @@ mlxsw_sp_mall_port_sample_del(struct mlxsw_sp_port *mlxsw_sp_port)
 	RCU_INIT_POINTER(mlxsw_sp_port->sample->psample_group, NULL);
 }
 
+static int
+mlxsw_sp_mall_port_rule_add(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct mlxsw_sp_mall_entry *mall_entry)
+{
+	switch (mall_entry->type) {
+	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
+		return mlxsw_sp_mall_port_mirror_add(mlxsw_sp_port, mall_entry);
+	case MLXSW_SP_MALL_ACTION_TYPE_SAMPLE:
+		return mlxsw_sp_mall_port_sample_add(mlxsw_sp_port, mall_entry);
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+}
+
+static void
+mlxsw_sp_mall_port_rule_del(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct mlxsw_sp_mall_entry *mall_entry)
+{
+	switch (mall_entry->type) {
+	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
+		mlxsw_sp_mall_port_mirror_del(mlxsw_sp_port, mall_entry);
+		break;
+	case MLXSW_SP_MALL_ACTION_TYPE_SAMPLE:
+		mlxsw_sp_mall_port_sample_del(mlxsw_sp_port);
+		break;
+	default:
+		WARN_ON(1);
+	}
+}
+
 int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 			  struct tc_cls_matchall_offload *f, bool ingress)
 {
@@ -147,7 +178,6 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 	if (act->id == FLOW_ACTION_MIRRED && protocol == htons(ETH_P_ALL)) {
 		mall_entry->type = MLXSW_SP_MALL_ACTION_TYPE_MIRROR;
 		mall_entry->mirror.to_dev = act->dev;
-		err = mlxsw_sp_mall_port_mirror_add(mlxsw_sp_port, mall_entry);
 	} else if (act->id == FLOW_ACTION_SAMPLE &&
 		   protocol == htons(ETH_P_ALL)) {
 		if (act->sample.rate > MLXSW_REG_MPSC_RATE_MAX) {
@@ -160,11 +190,12 @@ int mlxsw_sp_mall_replace(struct mlxsw_sp_port *mlxsw_sp_port,
 		mall_entry->sample.truncate = act->sample.truncate;
 		mall_entry->sample.trunc_size = act->sample.trunc_size;
 		mall_entry->sample.rate = act->sample.rate;
-		err = mlxsw_sp_mall_port_sample_add(mlxsw_sp_port, mall_entry);
 	} else {
 		err = -EOPNOTSUPP;
+		goto errout;
 	}
 
+	err = mlxsw_sp_mall_port_rule_add(mlxsw_sp_port, mall_entry);
 	if (err)
 		goto errout;
 
@@ -186,18 +217,9 @@ void mlxsw_sp_mall_destroy(struct mlxsw_sp_port *mlxsw_sp_port,
 		netdev_dbg(mlxsw_sp_port->dev, "tc entry not found on port\n");
 		return;
 	}
-	list_del(&mall_entry->list);
 
-	switch (mall_entry->type) {
-	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
-		mlxsw_sp_mall_port_mirror_del(mlxsw_sp_port, mall_entry);
-		break;
-	case MLXSW_SP_MALL_ACTION_TYPE_SAMPLE:
-		mlxsw_sp_mall_port_sample_del(mlxsw_sp_port);
-		break;
-	default:
-		WARN_ON(1);
-	}
+	mlxsw_sp_mall_port_rule_del(mlxsw_sp_port, mall_entry);
 
+	list_del(&mall_entry->list);
 	kfree(mall_entry);
 }
-- 
2.24.1


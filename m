Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FBD64280DF
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 13:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231937AbhJJLmk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 07:42:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:46385 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231892AbhJJLmi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 07:42:38 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 5D2965C00EA;
        Sun, 10 Oct 2021 07:40:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sun, 10 Oct 2021 07:40:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=UTAuwG8A60KcqsziSdeCskAqKIgdT+K4a7x1QHFJmH4=; b=U4NI+8Lf
        vj8RUi0t/YeiLHbE7E5U2rjN400Bk81vBIZi4efqv60YEBt6wijXZgmEy8Mh1hh5
        uhIPTRSzMh8akUNxxVZrbIfwbXyIaus5daxVjPkAxuYixXOdirYgZy5+gnc/wZW1
        46YCAX9BqmpicdHMYptqxLf3CyDfpKlox7xqFajEE45ZrS2MSng4t499wVq3RXaL
        ymAyyzY8qLQxmpnBXujCmLkY7LKvBnh/GQcsqEIwi4Z0FeVSzGLmWwRwVTXdNmQf
        cAuXCSoRZhxnhkk2ZoDowT3HLNWGUqQjlgeSGrqUYHxkyecAHR0S+eDIxJtw1gjB
        qcYF3PfcDZM88A==
X-ME-Sender: <xms:ONFiYQQZtzgFa9Xn9JrKvZ9bsNgBLJNd6EPz0i3vpafKtAK3gbMCnA>
    <xme:ONFiYdxaFXa-jgKVTQJhCqpKcrJctO42Eo5RzIAxJoygLGHOIY-gauf48NUETTOie
    a_bAyHzMMG1KdU>
X-ME-Received: <xmr:ONFiYd2v6fic3jdph4XwNI0vmm9iaIBKhP_2UYSo3k1MXhfR32FJvNt8gJxrPNv6z8mHcWqrV2Xc3IzxvKIjAUPMitR7BA3XQnM5owmYosGNlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ONFiYUDbH_q9e4phxu4KexUKcFRsYw3JVCnBB4SZKfW0hhLvrDDANA>
    <xmx:ONFiYZiez_mK8EKNm5egJtd-ePPt97dWMSXkF_1aRxl_7Iqs_frL2g>
    <xmx:ONFiYQqz6Wp8D2WGJC5HhTfwQyxE5x1v66fg8rIvL1_IQSRxVU2iZQ>
    <xmx:ONFiYZeo-Cv9M1Uw6crOlAeOgtgzmhmIZwGn1mS4f1Uc7TG7Ido__A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 10 Oct 2021 07:40:38 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/6] mlxsw: spectrum_qdisc: Pass extack to mlxsw_sp_qevent_entry_configure()
Date:   Sun, 10 Oct 2021 14:40:13 +0300
Message-Id: <20211010114018.190266-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211010114018.190266-1-idosch@idosch.org>
References: <20211010114018.190266-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@nvidia.com>

This function will report a new failure in the following patches.
Pass extack so that the failure is explicable.

Signed-off-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 29 ++++++++++++-------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 9958d503bf0e..14b87d672a9d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -1583,9 +1583,11 @@ static void mlxsw_sp_qevent_trap_deconfigure(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_qevent_span_deconfigure(mlxsw_sp, qevent_binding, mall_entry->trap.span_id);
 }
 
-static int mlxsw_sp_qevent_entry_configure(struct mlxsw_sp *mlxsw_sp,
-					   struct mlxsw_sp_mall_entry *mall_entry,
-					   struct mlxsw_sp_qevent_binding *qevent_binding)
+static int
+mlxsw_sp_qevent_entry_configure(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_mall_entry *mall_entry,
+				struct mlxsw_sp_qevent_binding *qevent_binding,
+				struct netlink_ext_ack *extack)
 {
 	switch (mall_entry->type) {
 	case MLXSW_SP_MALL_ACTION_TYPE_MIRROR:
@@ -1614,15 +1616,17 @@ static void mlxsw_sp_qevent_entry_deconfigure(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
-static int mlxsw_sp_qevent_binding_configure(struct mlxsw_sp_qevent_block *qevent_block,
-					     struct mlxsw_sp_qevent_binding *qevent_binding)
+static int
+mlxsw_sp_qevent_binding_configure(struct mlxsw_sp_qevent_block *qevent_block,
+				  struct mlxsw_sp_qevent_binding *qevent_binding,
+				  struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_mall_entry *mall_entry;
 	int err;
 
 	list_for_each_entry(mall_entry, &qevent_block->mall_entry_list, list) {
 		err = mlxsw_sp_qevent_entry_configure(qevent_block->mlxsw_sp, mall_entry,
-						      qevent_binding);
+						      qevent_binding, extack);
 		if (err)
 			goto err_entry_configure;
 	}
@@ -1646,13 +1650,17 @@ static void mlxsw_sp_qevent_binding_deconfigure(struct mlxsw_sp_qevent_block *qe
 						  qevent_binding);
 }
 
-static int mlxsw_sp_qevent_block_configure(struct mlxsw_sp_qevent_block *qevent_block)
+static int
+mlxsw_sp_qevent_block_configure(struct mlxsw_sp_qevent_block *qevent_block,
+				struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_qevent_binding *qevent_binding;
 	int err;
 
 	list_for_each_entry(qevent_binding, &qevent_block->binding_list, list) {
-		err = mlxsw_sp_qevent_binding_configure(qevent_block, qevent_binding);
+		err = mlxsw_sp_qevent_binding_configure(qevent_block,
+							qevent_binding,
+							extack);
 		if (err)
 			goto err_binding_configure;
 	}
@@ -1737,7 +1745,7 @@ static int mlxsw_sp_qevent_mall_replace(struct mlxsw_sp *mlxsw_sp,
 
 	list_add_tail(&mall_entry->list, &qevent_block->mall_entry_list);
 
-	err = mlxsw_sp_qevent_block_configure(qevent_block);
+	err = mlxsw_sp_qevent_block_configure(qevent_block, f->common.extack);
 	if (err)
 		goto err_block_configure;
 
@@ -1911,7 +1919,8 @@ static int mlxsw_sp_setup_tc_block_qevent_bind(struct mlxsw_sp_port *mlxsw_sp_po
 		goto err_binding_create;
 	}
 
-	err = mlxsw_sp_qevent_binding_configure(qevent_block, qevent_binding);
+	err = mlxsw_sp_qevent_binding_configure(qevent_block, qevent_binding,
+						f->extack);
 	if (err)
 		goto err_binding_configure;
 
-- 
2.31.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AF8112C68B
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 14:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727032AbfE1MbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 08:31:21 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:43131 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726824AbfE1MbV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 May 2019 08:31:21 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id 47749176C;
        Tue, 28 May 2019 08:22:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 28 May 2019 08:22:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=3MZEQNW7A1Njm8aFqO2nrrQ4u7z9vgAivWxUUON+4E4=; b=M2on0EKo
        bYq/LFOElWfGfQ8GE8ZbH/SYOoMfcu/YElvpYz/cqTOKYNUOZ7C/jUuGobKXorrC
        MgK5nQ6lsygbBuUWU1da57PwiW9HOZw6fLvXmCfYrZDuVD1Te3UicS8KLVvEkCye
        Gsa7oQ0t5sa+vevNLEICKHSyruUECMPYWifP8ektZTTMcfNV7O8iWq00knpnuQ6c
        +Xl+CIfCX41/lER4/cHCD1DWl6RwUw2yWyDthhy4UIlg4KGIPV6ekxMMLiZ/nJ/B
        bRmVXWX7JIZ41VwOOO1zcQYqe/dnS0ZKANkpufhs2e/tMVutaowiOSJj0FwQsEKq
        VtpToNTV99C/Zw==
X-ME-Sender: <xms:HijtXK7hC3zVzNZhRfb97NWKccq4cImWYm2ClcZ0Kz92Hdo0Z2QeUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddruddvhedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeei
X-ME-Proxy: <xmx:HijtXAi31arcsiou7K_evu_rGTQfTJhnWxYoBJh7RJCEsPD9El3E_A>
    <xmx:HijtXP2D8A5Mec3EVVDRJBxLRlV9u9-0tDZV2gikFXMopgoiWh1yxA>
    <xmx:HijtXBAXx2MxjxLzcN-wy4MxqkpazPAwilfi3hKOH413kdXTVnOrow>
    <xmx:HijtXD9eVITPwyOl_oPcYRkE0gLoNFEEG99xEJf2bs6z0uo7kamrPQ>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 7523A380085;
        Tue, 28 May 2019 08:22:51 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@savoirfairelinux.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [RFC PATCH net-next 08/12] mlxsw: core: Add API to set trap action
Date:   Tue, 28 May 2019 15:21:32 +0300
Message-Id: <20190528122136.30476-9-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190528122136.30476-1-idosch@idosch.org>
References: <20190528122136.30476-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Up until now the action of a trap was never changed during its lifetime.
This is going to change by subsequent patches that will allow devlink to
control the action of certain traps.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h |  3 +++
 2 files changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 6ee6de7f0160..7cd869327f4e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1452,6 +1452,18 @@ void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_trap_unregister);
 
+int mlxsw_core_trap_action_set(struct mlxsw_core *mlxsw_core,
+			       const struct mlxsw_listener *listener,
+			       enum mlxsw_reg_hpkt_action action)
+{
+	char hpkt_pl[MLXSW_REG_HPKT_LEN];
+
+	mlxsw_reg_hpkt_pack(hpkt_pl, action, listener->trap_id,
+			    listener->trap_group, listener->is_ctrl);
+	return mlxsw_reg_write(mlxsw_core, MLXSW_REG(hpkt), hpkt_pl);
+}
+EXPORT_SYMBOL(mlxsw_core_trap_action_set);
+
 static u64 mlxsw_core_tid_get(struct mlxsw_core *mlxsw_core)
 {
 	return atomic64_inc_return(&mlxsw_core->emad.tid);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 5add61a7514e..39c277edc807 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -126,6 +126,9 @@ int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
 void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
 				const struct mlxsw_listener *listener,
 				void *priv);
+int mlxsw_core_trap_action_set(struct mlxsw_core *mlxsw_core,
+			       const struct mlxsw_listener *listener,
+			       enum mlxsw_reg_hpkt_action action);
 
 typedef void mlxsw_reg_trans_cb_t(struct mlxsw_core *mlxsw_core, char *payload,
 				  size_t payload_len, unsigned long cb_priv);
-- 
2.20.1


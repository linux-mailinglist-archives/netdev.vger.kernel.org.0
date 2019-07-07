Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3271661452
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 10:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727283AbfGGIAL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 04:00:11 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:60807 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726330AbfGGIAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 04:00:09 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id E8B642779;
        Sun,  7 Jul 2019 04:00:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sun, 07 Jul 2019 04:00:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Aip6OODWzRJzpsO7Q0iKtlSZAiL1Tg1FXgROgrcmw+I=; b=cwgmQ/Fl
        Pw7irQwGLOTXtUUjSY6UymdkSuJJGOFsmXMUwlaEvYhHbAlki77GUB1DZNVGbAvz
        OfDIRj5bRLqLgNDSQHuQzGhLrR/VzpAffQG31/GVayvzq+hTSZS8zqHYaczbjEET
        ZHGVLAprANFksUYEVCrxUTrJurh04Nok9OK9OuxNNi/nJUF2pAUKCwvGmtzb/yel
        COTTTSowgzSRZJLwp7tgLD50ib9XlSx/M6NCc226Ygik+m60Foq+aGm4cmZdsLkC
        W1sN1VK2Juz2T4TjzX1A7lOxB/6vJuOiod1E5Iknhd312MrsUupMO5xF9cXJGcOd
        mus5j0uEQh7fUQ==
X-ME-Sender: <xms:iKYhXapjaO9vNw8DCsspX_5f0wmRkpJE9tSW0HOxLvwTff0mh8VjQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrfeejgdduvdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:iKYhXdWklU6LSce8HiFttzxVVtWV8GF1Go7W2jsz0HuRWrb19sGlvA>
    <xmx:iKYhXcCoGl7fGAM0lJ8aJP7uDCfmSwVFeh9bRVYo0U7b_ysTY0dVOw>
    <xmx:iKYhXWzNcFMp0uOYLGnCCpV13OH3szqYDTJZvXFI22k-vvsGnYTOmQ>
    <xmx:iKYhXei75erNxB6V-ScsSuM9eH-l5JBoYs06sb1LIqWN7AeNXF_j1g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4C7AC38008A;
        Sun,  7 Jul 2019 04:00:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, andy@greyhouse.net,
        pablo@netfilter.org, jakub.kicinski@netronome.com,
        pieter.jansenvanvuuren@netronome.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/11] mlxsw: core: Add API to set trap action
Date:   Sun,  7 Jul 2019 10:58:24 +0300
Message-Id: <20190707075828.3315-8-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190707075828.3315-1-idosch@idosch.org>
References: <20190707075828.3315-1-idosch@idosch.org>
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
index 17ceac7505e5..6ec07ecfb5f6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -1477,6 +1477,18 @@ void mlxsw_core_trap_unregister(struct mlxsw_core *mlxsw_core,
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
index 8efcff4b59cb..19cea16c30bb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -128,6 +128,9 @@ int mlxsw_core_trap_register(struct mlxsw_core *mlxsw_core,
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


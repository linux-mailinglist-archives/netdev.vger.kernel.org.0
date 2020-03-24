Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB00191A0E
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 20:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgCXTe5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 15:34:57 -0400
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:32781 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725927AbgCXTe5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 15:34:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id BCA695800D2;
        Tue, 24 Mar 2020 15:34:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 24 Mar 2020 15:34:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=7i6vS2e9nJkY7HZMUOvCbWXdPT4qZ0ey5gStrvCnYGg=; b=33I7EqB3
        /NdAHSAC37zR9Sk42N47omAYRaKc6Kul5gogWQH+rBxVYOUdhnlwCnpPWiATcMz6
        wAZIXhoGice/XEjyqxVwDi9rKUtcryJNog6xfRpoYQEICcAb1C6QKI+oXVK0D34t
        LXq5LyDC190DLQztRQbBQTgFDLPplVFd4522PSod9eFVqOfggLSHZlEgR58SnfUv
        CTgMDmqiJXPryeq4LiRjsBf0qY4FLwAOV1H4aXl885ATlGqBWSXwxgsyDvpo3RkG
        SxuBHGPlXRzPLkvqZ3Qg5Wozq5onapiyrtCdea0wxOpIRo2ESJ0LiANOElYe+K09
        LShAT+Znqtvsfw==
X-ME-Sender: <xms:4GB6Xt00GGnNPZhktQBbsiRLdUzZNdCyUQ1wxb9_E72WkmzGoUbVeA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudehuddgleeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeejledrudektddrleegrddvvdehnecuvehluhhsthgvrh
    fuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgt
    hhdrohhrgh
X-ME-Proxy: <xmx:4GB6Xm-Nr69mSNNLWiAHEPGbGz2BCISxPvXKngW_kGaV7akP1RFLGw>
    <xmx:4GB6Xm4lTq_LMjPYd1a31dHWd3HxPO8ujP0fodzhexSRsa5RvfsUTQ>
    <xmx:4GB6XqXSvVyediZHOu-ms-dYkTvA6E36lvoqJukcfV98HIvuOI2--g>
    <xmx:4GB6Xr6aG9b7aT85Yd1aguCG7k4lQ450vG8ViCOZLxpPRw1Rb2L3aw>
Received: from splinter.mtl.com (bzq-79-180-94-225.red.bezeqint.net [79.180.94.225])
        by mail.messagingengine.com (Postfix) with ESMTPA id E496B3065E45;
        Tue, 24 Mar 2020 15:34:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, kuba@kernel.org,
        andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 12/15] mlxsw: spectrum_trap: Do not initialize dedicated discard policer
Date:   Tue, 24 Mar 2020 21:32:47 +0200
Message-Id: <20200324193250.1322038-13-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200324193250.1322038-1-idosch@idosch.org>
References: <20200324193250.1322038-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

The policer is now initialized as part of the registration with devlink,
so there is no need to initialize it before the registration.

Remove the initialization.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
index cc536d06b3ac..a603d11686f2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_trap.c
@@ -300,8 +300,7 @@ static const u16 mlxsw_sp_listener_devlink_map[] = {
 	DEVLINK_TRAP_GENERIC_ID_EGRESS_FLOW_ACTION_DROP,
 };
 
-#define MLXSW_SP_DISCARD_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
-#define MLXSW_SP_THIN_POLICER_ID	(MLXSW_SP_DISCARD_POLICER_ID + 1)
+#define MLXSW_SP_THIN_POLICER_ID	(MLXSW_REG_HTGT_TRAP_GROUP_MAX + 1)
 
 static struct mlxsw_sp_trap_policer_item *
 mlxsw_sp_trap_policer_item_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
@@ -320,13 +319,6 @@ mlxsw_sp_trap_policer_item_lookup(struct mlxsw_sp *mlxsw_sp, u32 id)
 static int mlxsw_sp_trap_cpu_policers_set(struct mlxsw_sp *mlxsw_sp)
 {
 	char qpcr_pl[MLXSW_REG_QPCR_LEN];
-	int err;
-
-	mlxsw_reg_qpcr_pack(qpcr_pl, MLXSW_SP_DISCARD_POLICER_ID,
-			    MLXSW_REG_QPCR_IR_UNITS_M, false, 10 * 1024, 7);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(qpcr), qpcr_pl);
-	if (err)
-		return err;
 
 	/* The purpose of "thin" policer is to drop as many packets
 	 * as possible. The dummy group is using it.
-- 
2.24.1


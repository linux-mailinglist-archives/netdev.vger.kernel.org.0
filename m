Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C050B34A6
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 08:18:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbfIPGSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 02:18:48 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:59971 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729398AbfIPGSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 02:18:48 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 2ADE422050;
        Mon, 16 Sep 2019 02:18:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Mon, 16 Sep 2019 02:18:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=8mBw5NfSc8kaEJP4jTZpfBi3zdYoG/HtH1TXQIL80q0=; b=CntcxpU1
        PjOLVZFaomYXorA1rwJIC2Nj+b40x9OnH5gkhSmam1nlUZT6EGQxj1gWdWRWsjpZ
        w49pp6J5WpdVdA6KloY+hWkZF46KbVcYoMCNcaKIgTBQMeJglfGCWrp1pfVBNXMd
        mdf+jDsYImS/Pb5iLdoDXr9yzvNLOircb6MJ+f83soZbMGAlomBwJJStmuDIlBoA
        TkhX4PPHSc5yqX89VooXiKvygQFjayEAG9gI/7ABther9WZuvmY4MD3d0YVm5sXl
        uZSi+cigUSyecFnmncysG9hj6zDxWZTbu2aJ49+4ZQgwuCvPviVTu+rVQdYbrctU
        zE+BI7Xw0nu+LA==
X-ME-Sender: <xms:Ryl_XaU8Z-xNdNWRoLm73iAgBDp1Kyl8QV8cyXtwzc3F6A5IZMV_4A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddvgddutdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:Ryl_XeLfHr0oJbCZxy3FbInojHXKRXN9upPEeIyLerni2OZrUoD3CQ>
    <xmx:Ryl_XeBpTb7hmRvCf1QXsJGwIJ8Lk3aG4z9OeTpX8RdgjW718YcJTQ>
    <xmx:Ryl_XeGzSCKbcNQK75t8I00y3ougKgxTpBm-owy7Z8NgnW4CMRK6pA>
    <xmx:Ryl_XdD_rbfNbkoi1Fn6WJrggspLFVz0g6oj0owoX1n3tnvKx7Atig>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5DDC98006F;
        Mon, 16 Sep 2019 02:18:45 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 1/3] mlxsw: spectrum_buffers: Prevent changing CPU port's configuration
Date:   Mon, 16 Sep 2019 09:17:48 +0300
Message-Id: <20190916061750.26207-2-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190916061750.26207-1-idosch@idosch.org>
References: <20190916061750.26207-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Next patch is going to register the CPU port with devlink, but only so
that the CPU port's shared buffer configuration and occupancy could be
queried.

Prevent changing CPU port's shared buffer threshold and binding
configuration.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
index 888ba4300bcc..f1dbde73fa78 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_buffers.c
@@ -1085,6 +1085,11 @@ int mlxsw_sp_sb_port_pool_set(struct mlxsw_core_port *mlxsw_core_port,
 	u32 max_buff;
 	int err;
 
+	if (local_port == MLXSW_PORT_CPU_PORT) {
+		NL_SET_ERR_MSG_MOD(extack, "Changing CPU port's threshold is forbidden");
+		return -EINVAL;
+	}
+
 	err = mlxsw_sp_sb_threshold_in(mlxsw_sp, pool_index,
 				       threshold, &max_buff, extack);
 	if (err)
@@ -1130,6 +1135,11 @@ int mlxsw_sp_sb_tc_pool_bind_set(struct mlxsw_core_port *mlxsw_core_port,
 	u32 max_buff;
 	int err;
 
+	if (local_port == MLXSW_PORT_CPU_PORT) {
+		NL_SET_ERR_MSG_MOD(extack, "Changing CPU port's binding is forbidden");
+		return -EINVAL;
+	}
+
 	if (dir != mlxsw_sp->sb_vals->pool_dess[pool_index].dir) {
 		NL_SET_ERR_MSG_MOD(extack, "Binding egress TC to ingress pool and vice versa is forbidden");
 		return -EINVAL;
-- 
2.21.0


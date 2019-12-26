Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A503D12AD8B
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 17:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbfLZQmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 11:42:01 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:33815 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726755AbfLZQl6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 11:41:58 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id F167921E1C;
        Thu, 26 Dec 2019 11:41:57 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Thu, 26 Dec 2019 11:41:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=ADwHryBopwAXIZ+OiaHbfsDsV6KLYU6ov1nmqL0yPOs=; b=HtEwfdKJ
        U3SICpFcQejrwoQdcZ2Vha5ZLMvXVhn/ulfmfUrzhk+OS5mAHK1s/NUmVDHkimkA
        ggLaRGPWTBPp+ZnfFwFycufCjNnO0Ywz0JtvtvUvm8jnFdf0/rY4t4RkJXn5Ww/T
        ygtzBm+arKpB4QQtNjvEd/bFu3RJjQzMOyxuz3nr9CgtgtemKMcMKkz5GnPkxBOf
        bsm+kScz9QaG5b9rtZ40dPKxDUGa23x+Xcxq2CKCSuW0K66HPmpRp1vC+X7PuO7T
        lgXCLJ7nQ9oRkYKU8uxIxbCtbrw1hSyIPfgftdwWCtxChnYW4WErRZ0WDZtAjTwP
        1Hxm3U6iDABZcA==
X-ME-Sender: <xms:1eIEXv8uu3DGBy5lkK_SGxLpmJpu2tJBc7_G8lOgmriiOkidEqEVPw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrvddviedgkeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedu
X-ME-Proxy: <xmx:1eIEXm2Fc-WMl82VVijzKnc-2a1oeC6etPUyTq2LmCgbcXUHJ6VDzQ>
    <xmx:1eIEXjZkOZXsscVXmD4ZUMVZ9Ziyt7t_5Q-t4zrxMIOlQ0A8GEyw_w>
    <xmx:1eIEXmYf05EtGv6w55SxkL3m_O1wy5WPIyWvLLQw3dtEi-51rRGHfA>
    <xmx:1eIEXjBtsF7id1UWgUkeGgPPPJ5araNZB6UMcqWXFyz0jaLVgzLw6g>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id DD3C330607B4;
        Thu, 26 Dec 2019 11:41:56 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 2/5] mlxsw: spectrum_router: Eliminate dead code
Date:   Thu, 26 Dec 2019 18:41:14 +0200
Message-Id: <20191226164117.53794-3-idosch@idosch.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191226164117.53794-1-idosch@idosch.org>
References: <20191226164117.53794-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

Since the driver no longer maintains a list of identical routes there is
no route to promote when a route is deleted.

Remove that code that took care of it.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 87a010cb43b1..0439b2399a53 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4795,16 +4795,6 @@ static void mlxsw_sp_fib_node_entry_del(struct mlxsw_sp *mlxsw_sp,
 	if (!mlxsw_sp_fib_node_entry_is_first(fib_node, fib_entry))
 		return;
 
-	/* Promote the next entry by overwriting the deleted entry */
-	if (!list_is_singular(&fib_node->entry_list)) {
-		struct mlxsw_sp_fib_entry *n = list_next_entry(fib_entry, list);
-		enum mlxsw_reg_ralue_op op = MLXSW_REG_RALUE_OP_WRITE_DELETE;
-
-		mlxsw_sp_fib_entry_update(mlxsw_sp, n);
-		mlxsw_sp_fib_entry_offload_refresh(fib_entry, op, 0);
-		return;
-	}
-
 	mlxsw_sp_fib_entry_del(mlxsw_sp, fib_entry);
 }
 
-- 
2.24.1


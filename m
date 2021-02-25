Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7BE832543C
	for <lists+netdev@lfdr.de>; Thu, 25 Feb 2021 18:00:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234081AbhBYQ77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Feb 2021 11:59:59 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:46079 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233944AbhBYQ7U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Feb 2021 11:59:20 -0500
Received: from compute7.internal (compute7.nyi.internal [10.202.2.47])
        by mailout.west.internal (Postfix) with ESMTP id 359A7B45;
        Thu, 25 Feb 2021 11:58:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute7.internal (MEProxy); Thu, 25 Feb 2021 11:58:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=QmECGpZROMtWJ92h2qXj8yecWNHcnoZLGs7LrYDk7LQ=; b=PifPmB4H
        HhYnv8X0gDjPCvZ2/wzIQFM0reHgCzGf2q77R/P9SSAWzuZb96AOf/FWGqiDx5wj
        dwboUCo8hBVIhY3bJWs87XGa4M+VbPPk5wa0UmBzmcOFB6NKDBo0sR7gxpmwwxgg
        qDBNQ5Nt61RGrERtauFWLW5x8ugMleYI7eafroLWONQvgj3mFq40bDFqHZH8E1RI
        F6HPDj7DMtDNZm8T5MstRrCfAdESO8svMD19lXbU0FSvtMi5FcZvI9pb8f7ADMd9
        0CrtkcTb58I2ifae+cOPeapZhz6IjH8uFYLVbm46SPVe4ADnpQsQas/3CN6H1Dzs
        EW/lNYfVNM7nYQ==
X-ME-Sender: <xms:Jdc3YDrY3mKApDinsDhCCA6-1C5AUCagzvBaksmWNqPZmFH501A-kw>
    <xme:Jdc3YOb7E1eKa88Req4DjgWtrLm-AtoW_A3dg-3_gQ8phv4thZdipFMKka_M79o_A
    ZdgpbAW_ws4Tzc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrkeelgdeljecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihguohhs
    tghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhfekhe
    fgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeggeen
    ucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:Jdc3YMUDC0NlVnq6y3NuQ0MTUmvKNAyFC4WXRfFJi8nOsUnrqCkgig>
    <xmx:Jdc3YH8PuM7Kqtq02tTlerRTNAeOcI-HmGojw92PPZFURBJw3u6PKw>
    <xmx:Jdc3YF-3LMxiAv_wlnMtNJf7HRTXxVgLILDhG0p5NsHD3o1XgDcwoA>
    <xmx:Jdc3YCblmD9GqDYf_zaIKOCQKIOm3DQAdyAEmWFiHuOg_JGIbA825g>
Received: from shredder.lan (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id B724D24005B;
        Thu, 25 Feb 2021 11:58:11 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net 3/3] mlxsw: spectrum_router: Ignore routes using a deleted nexthop object
Date:   Thu, 25 Feb 2021 18:57:21 +0200
Message-Id: <20210225165721.1322424-4-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210225165721.1322424-1-idosch@idosch.org>
References: <20210225165721.1322424-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Routes are currently processed from a workqueue whereas nexthop objects
are processed in system call context. This can result in the driver not
finding a suitable nexthop group for a route and issuing a warning [1].

Fix this by ignoring such routes earlier in the process. The subsequent
deletion notification will be ignored as well.

[1]
 WARNING: CPU: 2 PID: 7754 at drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:4853 mlxsw_sp_router_fib_event_work+0x1112/0x1e00 [mlxsw_spectrum]
 [...]
 CPU: 2 PID: 7754 Comm: kworker/u8:0 Not tainted 5.11.0-rc6-cq-20210207-1 #16
 Hardware name: Mellanox Technologies Ltd. MSN2100/SA001390, BIOS 5.6.5 05/24/2018
 Workqueue: mlxsw_core_ordered mlxsw_sp_router_fib_event_work [mlxsw_spectrum]
 RIP: 0010:mlxsw_sp_router_fib_event_work+0x1112/0x1e00 [mlxsw_spectrum]

Fixes: cdd6cfc54c64 ("mlxsw: spectrum_router: Allow programming routes with nexthop objects")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reported-by: Alex Veber <alexve@nvidia.com>
Tested-by: Alex Veber <alexve@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 9ce90841f92d..eda99d82766a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -5951,6 +5951,10 @@ mlxsw_sp_router_fib4_replace(struct mlxsw_sp *mlxsw_sp,
 	if (mlxsw_sp->router->aborted)
 		return 0;
 
+	if (fen_info->fi->nh &&
+	    !mlxsw_sp_nexthop_obj_group_lookup(mlxsw_sp, fen_info->fi->nh->id))
+		return 0;
+
 	fib_node = mlxsw_sp_fib_node_get(mlxsw_sp, fen_info->tb_id,
 					 &fen_info->dst, sizeof(fen_info->dst),
 					 fen_info->dst_len,
@@ -6601,6 +6605,9 @@ static int mlxsw_sp_router_fib6_replace(struct mlxsw_sp *mlxsw_sp,
 	if (mlxsw_sp_fib6_rt_should_ignore(rt))
 		return 0;
 
+	if (rt->nh && !mlxsw_sp_nexthop_obj_group_lookup(mlxsw_sp, rt->nh->id))
+		return 0;
+
 	fib_node = mlxsw_sp_fib_node_get(mlxsw_sp, rt->fib6_table->tb6_id,
 					 &rt->fib6_dst.addr,
 					 sizeof(rt->fib6_dst.addr),
-- 
2.29.2


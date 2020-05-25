Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB211E1815
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 01:06:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388930AbgEYXGc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 19:06:32 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44293 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388895AbgEYXG3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 19:06:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 2B4E75C018F;
        Mon, 25 May 2020 19:06:29 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 25 May 2020 19:06:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=UgY6Reut4m/gZ1thqFGWG1bFhRJny2vq+38q18UlVxk=; b=ZFqYb4yG
        kHgyu0hjOwEGIT34mQvXmnnPmy7FEhyQWqd2GVzaSX0z5sdPSPOrppdQYhtICA5W
        NWogzlPfXzSL3Ky/RIcee8MKpvdNyuv1CYFxxeEtm3lJR7RIY5zy0/eKAgBelQ0R
        hlaXWi8rK749hi3rc2+3ZbO7bsvXf0p2KQfuMvXs7LDUSE9OCr4CgBK0Lg0LuuCw
        /SPp6s/gL4WBjDw/NfKHpNQqurUW+HGMnj3mvMORjcA0YMkAnGBkX0wV9oVcXASk
        /CS+j6TbpDbXVZpffuUlZesxokg15ShAW9xZ2Nv0nw3zKpdGxoBT8+RDggJ11DEH
        KjneIFOMmheEbA==
X-ME-Sender: <xms:dU_MXi9EuVXZr3v4QCPOAHP0llB1gEksmzESTHppZGilf5l46ilucQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddvuddgudejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgepleenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:dU_MXitebtgM2iJkyED9cyXLdn8X6T74HNTg1wbaHa80zychdGm6YA>
    <xmx:dU_MXoASnWBKmcO-kHxlJsMBPJSiJoTkTvhGMV5MGnSFeYNFhYfDzA>
    <xmx:dU_MXqdMY5Sw0CAbNQGVnnU5TePMRkfBklsymUbyj5LPWq9CgDoKxQ>
    <xmx:dU_MXt2l4rWTXC-VrmGqlrSgwJd_A4a1qRaVrfAMKoWxwd3p9bfA1g>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DC1923280059;
        Mon, 25 May 2020 19:06:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 10/14] mlxsw: reg: Move all trap groups under the same enum
Date:   Tue, 26 May 2020 02:05:52 +0300
Message-Id: <20200525230556.1455927-11-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@mellanox.com>

After the previous patch the split is no longer necessary and all the
trap groups can be moved under the same enum.

Signed-off-by: Ido Schimmel <idosch@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index fd5e18b71114..586a2f37fd12 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5548,18 +5548,14 @@ enum mlxsw_reg_htgt_trap_group {
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_PKT_SAMPLE,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_FLOW_LOGGING,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_FID_MISS,
-
-	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
-	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
-};
-
-enum mlxsw_reg_htgt_discard_trap_group {
-	MLXSW_REG_HTGT_DISCARD_TRAP_GROUP_BASE = MLXSW_REG_HTGT_TRAP_GROUP_MAX,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_DUMMY,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L2_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_L3_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_TUNNEL_DISCARDS,
 	MLXSW_REG_HTGT_TRAP_GROUP_SP_ACL_DISCARDS,
+
+	__MLXSW_REG_HTGT_TRAP_GROUP_MAX,
+	MLXSW_REG_HTGT_TRAP_GROUP_MAX = __MLXSW_REG_HTGT_TRAP_GROUP_MAX - 1
 };
 
 /* reg_htgt_trap_group
-- 
2.26.2


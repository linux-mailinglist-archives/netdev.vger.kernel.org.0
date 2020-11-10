Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9A2A2AD2C8
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730239AbgKJJua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:30 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:56443 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730361AbgKJJu2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:28 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id E38C9DE4;
        Tue, 10 Nov 2020 04:50:26 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=HOr8Er/Gz5QW6d8vyKNbJ9x7OdFjY3CwgKfb2QhrS5w=; b=mVk+BYLO
        jCtUSCQRiIaOn6jxPQCej3jIvv+wCqhD9NhokGCNb8gzNyb7ZRoafMIKXCAe/T2x
        oowYgDk2REWX5Z1shonwDbudxq8D+b3s8v7bQP8VTfQ/2o9sr897D4sFwhdCnDTA
        HNs94Iy/LaVkW1Sn4mqZdnvtVnXmUBmzaL6A8ncOWxlm1WuqMF1Yo1mcBMnit2z+
        fxnU8VtvRIeDaiEo9nP4P3RydNv/Jh3iQ41fpya5T3z3y8RecomlQPJ/RTgWY0b4
        FPnwUbVHeOnOHFh0P0nV7Zai9gA15uFYM2vZA0G7+aSj0OFlKdFiKXlrTMVHPO0o
        1YNekcm21Qag9g==
X-ME-Sender: <xms:YmKqX7i1CZSEggdUgahMDENInXnSv-TfqiU_NnTpKC3eA2DmwVsfnA>
    <xme:YmKqX4DL-x6D93usPypE7xoOw6Dzf8WRgH3xXquI_8t4JP6td44Q29QRXkvLA-lxQ
    mQ62PLUoJKkq64>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:YmKqX7H9avtjlkEC-WZ8bs-mCeno6G-S-UznBZeNNLn1OFEnklKrtg>
    <xmx:YmKqX4R2is6NCUd1mO9fsXEQDY4ioAmPBV1dSBqRfw1Dn5WukgrNmg>
    <xmx:YmKqX4zSYk31-pnhsRh7zrAZMqzeyvaxc2HEX1rczDwI5k1l6POoVg>
    <xmx:YmKqXz8liXl7nh8wd3eYY4jXABLRtfQF1MJrmcKMVetx1Vl3ZJkqDg>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id 4E1C63280060;
        Tue, 10 Nov 2020 04:50:25 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 07/15] mlxsw: spectrum_router: Pass destination IP as a pointer to mlxsw_reg_ralue_pack4()
Date:   Tue, 10 Nov 2020 11:48:52 +0200
Message-Id: <20201110094900.1920158-8-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Instead of passing destination IP as a u32 value, pass it as pointer to
u32. Avoid using local variable for the pointer store.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h             | 4 ++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 4 +---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 73aab72877fd..0da9f7e1eb9b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -7279,10 +7279,10 @@ static inline void mlxsw_reg_ralue_pack4(char *payload,
 					 enum mlxsw_reg_ralxx_protocol protocol,
 					 enum mlxsw_reg_ralue_op op,
 					 u16 virtual_router, u8 prefix_len,
-					 u32 dip)
+					 u32 *dip)
 {
 	mlxsw_reg_ralue_pack(payload, protocol, op, virtual_router, prefix_len);
-	mlxsw_reg_ralue_dip4_set(payload, dip);
+	mlxsw_reg_ralue_dip4_set(payload, *dip);
 }
 
 static inline void mlxsw_reg_ralue_pack6(char *payload,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 3ed9bd4afe95..4edb2eec8179 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4314,7 +4314,6 @@ mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl, enum mlxsw_sp_l3proto proto,
 {
 	enum mlxsw_reg_ralxx_protocol ralxx_proto;
 	enum mlxsw_reg_ralue_op ralue_op;
-	u32 *p_dip;
 
 	ralxx_proto = (enum mlxsw_reg_ralxx_protocol) proto;
 
@@ -4332,9 +4331,8 @@ mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl, enum mlxsw_sp_l3proto proto,
 
 	switch (proto) {
 	case MLXSW_SP_L3_PROTO_IPV4:
-		p_dip = (u32 *) addr;
 		mlxsw_reg_ralue_pack4(ralue_pl, ralxx_proto, ralue_op,
-				      virtual_router, prefix_len, *p_dip);
+				      virtual_router, prefix_len, (u32 *) addr);
 		break;
 	case MLXSW_SP_L3_PROTO_IPV6:
 		mlxsw_reg_ralue_pack6(ralue_pl, ralxx_proto, ralue_op,
-- 
2.26.2


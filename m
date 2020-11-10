Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 430842AD2C9
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 10:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730654AbgKJJub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 04:50:31 -0500
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:35539 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726467AbgKJJu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 04:50:26 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 8DE49DF9;
        Tue, 10 Nov 2020 04:50:25 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 10 Nov 2020 04:50:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=OH7VIbh2tYdRjRF9xMm4i3XS38PbbYrLP9cFGsho9vs=; b=fQeDc9Pf
        bSI5j1sYamPC8UM5bp1pqaGiS3Nqn2g8fKBomAcKB5t1As7SqU5jlU2ZxoBcyhn+
        PcJo+qGcvEbHj//hc92y4JgMPRO+uyk8lBxHlHHSlGWxsRdFNVEvOUJa2NrjStU8
        IyDPiLPYJ4XpFmJIqbfcygLH/OaWcr6ze8VBv9+wIUhq08p0hGU/2xeo4gP90fH9
        nNhL1vu/2oHo2gLg/2BkY2wmasToHlWNndGLgdZsQ14evGRFz/bB8nd65hx2C7h9
        q8Y74BjqyBpgDMnd4aa9c3csZWAIpRtNU2B4nPwIOMZIXSoTYjmZn2X+IadRDHfm
        64SOS0vQSDyvZA==
X-ME-Sender: <xms:YWKqX24l3eutqUQObFXF0dECuJPg1Dw0baMy45UAm_DLdVcqOPngxQ>
    <xme:YWKqX_7fJ0plO5UI2UxLK99ZP8Ps3ZffwtldCOaAAasdGOjvD_6gUocmeL4Y2y6K1
    hy_w9GGOmgFKpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedruddujedgtdekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehgedrudeg
    jeenucevlhhushhtvghrufhiiigvpeegnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:YWKqX1frwB8juBNC_HNm3ftq5BKrEXM10fVmgzkiwCQvsMhQ4VidoA>
    <xmx:YWKqXzLKq4P1WaZrY4f5DThzr9GmeJJ828IEIY7LAoKeRlCrxtR7rw>
    <xmx:YWKqX6LHKWYh9bKkbk4K3Ii1DLaYdvHNco04qNzYbwa3qrZFhSK_tw>
    <xmx:YWKqXxVnlVMbUxQgCV94iFiurpv_w6ko6y8XwI47lymjj8dOb1trog>
Received: from shredder.mtl.com (igld-84-229-154-147.inter.net.il [84.229.154.147])
        by mail.messagingengine.com (Postfix) with ESMTPA id E40E0328005A;
        Tue, 10 Nov 2020 04:50:23 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/15] mlxsw: spectrum: Export RALUE pack helper and use it from IPIP
Date:   Tue, 10 Nov 2020 11:48:51 +0200
Message-Id: <20201110094900.1920158-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201110094900.1920158-1-idosch@idosch.org>
References: <20201110094900.1920158-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

As the RALUE packing is going to be put into op, make the user from
IPIP code use the same helper as the router code does.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c | 17 ++---------------
 .../ethernet/mellanox/mlxsw/spectrum_router.c   |  2 +-
 .../ethernet/mellanox/mlxsw/spectrum_router.h   |  5 +++++
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index f8b9b5be8247..0f0064392468 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -188,22 +188,9 @@ mlxsw_sp_ipip_fib_entry_op_gre4_ralue(struct mlxsw_sp *mlxsw_sp,
 				      u32 tunnel_index)
 {
 	char *ralue_pl = op_ctx->ralue_pl;
-	enum mlxsw_reg_ralue_op ralue_op;
-
-	switch (op) {
-	case MLXSW_SP_FIB_ENTRY_OP_WRITE:
-		ralue_op = MLXSW_REG_RALUE_OP_WRITE_WRITE;
-		break;
-	case MLXSW_SP_FIB_ENTRY_OP_DELETE:
-		ralue_op = MLXSW_REG_RALUE_OP_WRITE_DELETE;
-		break;
-	default:
-		WARN_ON_ONCE(1);
-		return -EINVAL;
-	}
 
-	mlxsw_reg_ralue_pack4(ralue_pl, MLXSW_REG_RALXX_PROTOCOL_IPV4, ralue_op,
-			      ul_vr_id, prefix_len, dip);
+	mlxsw_sp_fib_entry_ralue_pack(ralue_pl, MLXSW_SP_L3_PROTO_IPV4, op,
+				      ul_vr_id, prefix_len, (unsigned char *) &dip);
 	mlxsw_reg_ralue_act_ip2me_tun_pack(ralue_pl, tunnel_index);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ralue), ralue_pl);
 }
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index cf186f1ff3f6..3ed9bd4afe95 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4307,7 +4307,7 @@ mlxsw_sp_fib_entry_hw_flags_refresh(struct mlxsw_sp *mlxsw_sp,
 	}
 }
 
-static void
+void
 mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl, enum mlxsw_sp_l3proto proto,
 			      enum mlxsw_sp_fib_entry_op op, u16 virtual_router,
 			      u8 prefix_len, unsigned char *addr)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 963825dff66b..1b071f872a3b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -173,4 +173,9 @@ static inline bool mlxsw_sp_l3addr_eq(const union mlxsw_sp_l3addr *addr1,
 int mlxsw_sp_ipip_ecn_encap_init(struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_ipip_ecn_decap_init(struct mlxsw_sp *mlxsw_sp);
 
+void
+mlxsw_sp_fib_entry_ralue_pack(char *ralue_pl, enum mlxsw_sp_l3proto proto,
+			      enum mlxsw_sp_fib_entry_op op, u16 virtual_router,
+			      u8 prefix_len, unsigned char *addr);
+
 #endif /* _MLXSW_ROUTER_H_*/
-- 
2.26.2


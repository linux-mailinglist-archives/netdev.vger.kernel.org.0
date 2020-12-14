Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3900F2D977B
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:38:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438344AbgLNLgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:36:54 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:41647 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437909AbgLNLcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:32:36 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9F6345C016A;
        Mon, 14 Dec 2020 06:31:12 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=bNTagCLn4h36ut/17O/vNWVonbqEXAVXqx2glJgQCzI=; b=NnSGqndb
        M1aTYNsO8QfujByLwTLRIkzM/YWb0a3wtjyv+WWD2saxiFCLsYVQDjBs2npkp5M3
        7rpRMwHwLcux2W9s5/8AnzNxTii3mlhDB6yfmfaVXcqnF1eMvcuUjDS5hokissby
        kievJQ90FJCfCnPfL/McldiQOTAnOui0ktuU1anORbT7zo015lbITurSo/GZcUP6
        FbjFXw0XT0WqU3zEEAqA3tCBSaJAWqXnDUhvyIkDctHRO1Vop3P83qCqBema6c84
        g2wjyCQesPFO5AzUaDp1KPT6SEqOtmj8J7juzba/5Dpxh4+OlgRJbVNTQAoeyvyn
        8wcuREUva+tGAA==
X-ME-Sender: <xms:AE3XX9ILsO5OonnR6ZlvPTltLuhuDI7iF8wuT0WHqd9cg8S7asVLIA>
    <xme:AE3XX5LQIRUTDZYGAymHWVXAakquS4AZQ3A1qF87hnL3bpbtr0CIw75nVI6cGpWcl
    lcN0ZqKEtSH2UQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:AE3XX1tSwTqz3Zy0OETlCIS4UVjJFGqdz5Pq34wL4Z5dZpPJPhO_9g>
    <xmx:AE3XX-Y-Fc_PbQ-qjRXa-uaIObsu2rFjHJ9ZqwjWF43ytLVEBsqRYw>
    <xmx:AE3XX0Yw2u5vViqmxGjr0cqSZfWyTvcSkkQbmNLa05VE4vvAi9DMGw>
    <xmx:AE3XXznABH-6EIdHs73O7Nda9BG-qu2KsdTj9wuDb7mw41qqtnPnXg>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id 70E121080059;
        Mon, 14 Dec 2020 06:31:11 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 09/15] mlxsw: reg: Add XM Router M Table Register
Date:   Mon, 14 Dec 2020 13:30:35 +0200
Message-Id: <20201214113041.2789043-10-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

The XRMT configures the M-Table for the XLT-LPM.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 33 +++++++++++++++++++++--
 1 file changed, 31 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 6db3a5b22f5d..0e3abb315e06 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8543,10 +8543,10 @@ static inline void mlxsw_reg_rxltm_pack(char *payload, u8 m0_val_v4, u8 m0_val_v
 	mlxsw_reg_rxltm_m0_val_v4_set(payload, m0_val_v4);
 }
 
-/* Note that XLTQ, XMDR and XRALXX register positions violate the rule
+/* Note that XLTQ, XMDR, XRMT and XRALXX register positions violate the rule
  * of ordering register definitions by the ID. However, XRALXX pack helpers are
  * using RALXX pack helpers, RALXX registers have higher IDs.
- * Also XMDR is using RALUE enums. XLTQ is just put alongside with the
+ * Also XMDR is using RALUE enums. XLRQ and XRMT are just put alongside with the
  * related registers.
  */
 
@@ -8874,6 +8874,34 @@ static inline void mlxsw_reg_xmdr_c_ltr_act_ip2me_tun_pack(char *xmdr_payload,
 	mlxsw_reg_xmdr_c_ltr_pointer_to_tunnel_set(payload, pointer_to_tunnel);
 }
 
+/* XRMT - XM Router M Table Register
+ * ---------------------------------
+ * The XRMT configures the M-Table for the XLT-LPM.
+ */
+#define MLXSW_REG_XRMT_ID 0x7810
+#define MLXSW_REG_XRMT_LEN 0x14
+
+MLXSW_REG_DEFINE(xrmt, MLXSW_REG_XRMT_ID, MLXSW_REG_XRMT_LEN);
+
+/* reg_xrmt_index
+ * Index in M-Table.
+ * Range 0..cap_xlt_mtable-1
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, xrmt, index, 0x04, 0, 20);
+
+/* reg_xrmt_l0_val
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, xrmt, l0_val, 0x10, 24, 8);
+
+static inline void mlxsw_reg_xrmt_pack(char *payload, u32 index, u8 l0_val)
+{
+	MLXSW_REG_ZERO(xrmt, payload);
+	mlxsw_reg_xrmt_index_set(payload, index);
+	mlxsw_reg_xrmt_l0_val_set(payload, l0_val);
+}
+
 /* XRALTA - XM Router Algorithmic LPM Tree Allocation Register
  * -----------------------------------------------------------
  * The XRALTA is used to allocate the XLT LPM trees.
@@ -11891,6 +11919,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rxltm),
 	MLXSW_REG(xltq),
 	MLXSW_REG(xmdr),
+	MLXSW_REG(xrmt),
 	MLXSW_REG(xralta),
 	MLXSW_REG(xralst),
 	MLXSW_REG(xraltb),
-- 
2.29.2


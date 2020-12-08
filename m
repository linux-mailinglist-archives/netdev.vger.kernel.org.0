Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F33F2D2779
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 10:25:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727132AbgLHJY5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 04:24:57 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44757 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbgLHJY5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 04:24:57 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 03EEE5C01E9;
        Tue,  8 Dec 2020 04:23:51 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 08 Dec 2020 04:23:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=V4nepsOC65nPIowQHM4J+9vRIdjj5EmVrR8IA8BAej8=; b=nQJvpivq
        pDqwMS0kS3kN3ezrhqUfEfTfOEseO+8xfqTXEQnEfnM/72YyozYgLx45eWNwUzee
        FQlNFZedwDDmZrlTENSetjWf4y0bDaLIzma125XeIi7Fcgwovdlhw3EM3lQBbSXL
        VYOCHgYx110tLrFDMAciXn05+Ls9Q6jCbqROZKM0/ZF4OcrQN0hZtQGeLQilqcm7
        83xeHlZe16lja1bLfAdHuuWiRzLYU++Xcy1KYAyFJuL7KFcVOwuYv9eLYMMgQZKF
        FvNfQihVdlD0PznolCqWV5UeqsEwfONIMV3L/cTQRnzHdahmya654fQYCZcukUsM
        lXAR8NgFxLiQfA==
X-ME-Sender: <xms:JkbPXyi35zCY-69zInIzb0w7WPkLa9DTjUw7VC5jID1umzcH-RU6IQ>
    <xme:JkbPXw36NmOS5RM5AxDr9Gd4sC8PmpO36D59XY9d1AGCZU4hYJsx_wQR1DwkqF_KH
    LNTNKYgKYjrJCo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejiedgtddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:JkbPX0hbTRrCJB3bZY36WzRBirsuJXpXrroBjwSzctIrPh8smKhJGg>
    <xmx:JkbPX4fb6JcJ2Uwg4mQseu96vf5QYFTY_a7uLlVneuwS8vl_fjJBNQ>
    <xmx:JkbPX_nVv932GhRT4IQK7Fw7_UTQx_Vuirw-PYFV8LWTJH8LdOo4Cw>
    <xmx:J0bPX65460FF6bj8g2jJx6FaraDOtNY8fHr0qXblPyX2dEf2DUYRAw>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 5E9501080068;
        Tue,  8 Dec 2020 04:23:49 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 01/13] mlxsw: Use one enum for all registers that contain tunnel_port field
Date:   Tue,  8 Dec 2020 11:22:41 +0200
Message-Id: <20201208092253.1996011-2-idosch@idosch.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201208092253.1996011-1-idosch@idosch.org>
References: <20201208092253.1996011-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently SFN, TNUMT and TNPC registers use separate enums for
tunnel_port.

Create one enum with a neutral name and use it.
Remove the enums that are not currently required.

The next patches add two more registers that contain tunnel_port field,
the new enum can be used for them also.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     | 32 ++++++-------------
 .../ethernet/mellanox/mlxsw/spectrum_nve.c    |  2 +-
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       |  2 +-
 3 files changed, 11 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 1077ed2046fe..0a3c5f89268c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -581,6 +581,13 @@ mlxsw_reg_sfd_uc_tunnel_pack(char *payload, int rec_index,
 	mlxsw_reg_sfd_uc_tunnel_protocol_set(payload, rec_index, proto);
 }
 
+enum mlxsw_reg_tunnel_port {
+	MLXSW_REG_TUNNEL_PORT_NVE,
+	MLXSW_REG_TUNNEL_PORT_VPLS,
+	MLXSW_REG_TUNNEL_PORT_FLEX_TUNNEL0,
+	MLXSW_REG_TUNNEL_PORT_FLEX_TUNNEL1,
+};
+
 /* SFN - Switch FDB Notification Register
  * -------------------------------------------
  * The switch provides notifications on newly learned FDB entries and
@@ -738,13 +745,6 @@ MLXSW_ITEM32_INDEXED(reg, sfn, uc_tunnel_protocol, MLXSW_REG_SFN_BASE_LEN, 27,
 MLXSW_ITEM32_INDEXED(reg, sfn, uc_tunnel_uip_lsb, MLXSW_REG_SFN_BASE_LEN, 0,
 		     24, MLXSW_REG_SFN_REC_LEN, 0x0C, false);
 
-enum mlxsw_reg_sfn_tunnel_port {
-	MLXSW_REG_SFN_TUNNEL_PORT_NVE,
-	MLXSW_REG_SFN_TUNNEL_PORT_VPLS,
-	MLXSW_REG_SFN_TUNNEL_FLEX_TUNNEL0,
-	MLXSW_REG_SFN_TUNNEL_FLEX_TUNNEL1,
-};
-
 /* reg_sfn_uc_tunnel_port
  * Tunnel port.
  * Reserved on Spectrum.
@@ -10507,13 +10507,6 @@ enum mlxsw_reg_tnumt_record_type {
  */
 MLXSW_ITEM32(reg, tnumt, record_type, 0x00, 28, 4);
 
-enum mlxsw_reg_tnumt_tunnel_port {
-	MLXSW_REG_TNUMT_TUNNEL_PORT_NVE,
-	MLXSW_REG_TNUMT_TUNNEL_PORT_VPLS,
-	MLXSW_REG_TNUMT_TUNNEL_FLEX_TUNNEL0,
-	MLXSW_REG_TNUMT_TUNNEL_FLEX_TUNNEL1,
-};
-
 /* reg_tnumt_tunnel_port
  * Tunnel port.
  * Access: RW
@@ -10561,7 +10554,7 @@ MLXSW_ITEM32_INDEXED(reg, tnumt, udip_ptr, 0x0C, 0, 24, 0x04, 0x00, false);
 
 static inline void mlxsw_reg_tnumt_pack(char *payload,
 					enum mlxsw_reg_tnumt_record_type type,
-					enum mlxsw_reg_tnumt_tunnel_port tport,
+					enum mlxsw_reg_tunnel_port tport,
 					u32 underlay_mc_ptr, bool vnext,
 					u32 next_underlay_mc_ptr,
 					u8 record_size)
@@ -10725,13 +10718,6 @@ static inline void mlxsw_reg_tndem_pack(char *payload, u8 underlay_ecn,
 
 MLXSW_REG_DEFINE(tnpc, MLXSW_REG_TNPC_ID, MLXSW_REG_TNPC_LEN);
 
-enum mlxsw_reg_tnpc_tunnel_port {
-	MLXSW_REG_TNPC_TUNNEL_PORT_NVE,
-	MLXSW_REG_TNPC_TUNNEL_PORT_VPLS,
-	MLXSW_REG_TNPC_TUNNEL_FLEX_TUNNEL0,
-	MLXSW_REG_TNPC_TUNNEL_FLEX_TUNNEL1,
-};
-
 /* reg_tnpc_tunnel_port
  * Tunnel port.
  * Access: Index
@@ -10751,7 +10737,7 @@ MLXSW_ITEM32(reg, tnpc, learn_enable_v6, 0x04, 1, 1);
 MLXSW_ITEM32(reg, tnpc, learn_enable_v4, 0x04, 0, 1);
 
 static inline void mlxsw_reg_tnpc_pack(char *payload,
-				       enum mlxsw_reg_tnpc_tunnel_port tport,
+				       enum mlxsw_reg_tunnel_port tport,
 				       bool learn_enable)
 {
 	MLXSW_REG_ZERO(tnpc, payload);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
index 54d3e7dcd303..ed0d334b5fd1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.c
@@ -368,7 +368,7 @@ mlxsw_sp_nve_mc_record_refresh(struct mlxsw_sp_nve_mc_record *mc_record)
 		next_valid = true;
 	}
 
-	mlxsw_reg_tnumt_pack(tnumt_pl, type, MLXSW_REG_TNUMT_TUNNEL_PORT_NVE,
+	mlxsw_reg_tnumt_pack(tnumt_pl, type, MLXSW_REG_TUNNEL_PORT_NVE,
 			     mc_record->kvdl_index, next_valid,
 			     next_kvdl_index, mc_record->num_entries);
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index 05517c7feaa5..e9bff13ec264 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -299,7 +299,7 @@ static bool mlxsw_sp2_nve_vxlan_learning_set(struct mlxsw_sp *mlxsw_sp,
 {
 	char tnpc_pl[MLXSW_REG_TNPC_LEN];
 
-	mlxsw_reg_tnpc_pack(tnpc_pl, MLXSW_REG_TNPC_TUNNEL_PORT_NVE,
+	mlxsw_reg_tnpc_pack(tnpc_pl, MLXSW_REG_TUNNEL_PORT_NVE,
 			    learning_en);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(tnpc), tnpc_pl);
 }
-- 
2.28.0


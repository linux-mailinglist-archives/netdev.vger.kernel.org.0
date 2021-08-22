Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF7BF3F3F13
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 13:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbhHVLjV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 07:39:21 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44663 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233569AbhHVLjQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 07:39:16 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0551C5C00D1;
        Sun, 22 Aug 2021 07:38:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 22 Aug 2021 07:38:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=TCWHrbq878s5L/broYdV24EDkC2XcQzn0xqLf0H/Rp4=; b=tME7XfKN
        cKKbsSpyz8LhceudRn27YaYnV5nTfYdFjtvVtt9GEFPdG4SyRsNgxWlMlyJjqg0T
        wjVHczjxPMqdmNflhG4GtNaiSnPHxPjeSAK0udVZHFpYVzRRVwI5MXVd5lTrPxTB
        UF4/EfGs28+1mMGNh5VXk2VtPkaoMTxV4waYHwzC3oYF6VlZXmFDgJsvzZznttHr
        6mdKcBZlsf/U7kJj9D4DsQSA8nXS///gtPm9RExEOOdFCutNV1i0nHBmtqTuTEp8
        nN6uMQ6hWeFhmPiso8dOTgwoCW1o5IPS7TDGUmeNMyR9WTbC1j141MWxsOYJJy61
        pYbZMrCCip3Gmg==
X-ME-Sender: <xms:OjciYdj7MSXudN9xbPsGK9MJ3Mao5mMxEpq9heZmcMrUfwj2q1zzXw>
    <xme:OjciYSBnooG96bCBxY_mB1z8hXeYdkE0CQHGjKCoBHnDc_Snj0rJGc--ljGYhZEel
    3IJFy0jQYVqK8s>
X-ME-Received: <xmr:OjciYdEAreOU4TqB-_F31LA3vbzlm74lEtk1tw3J_WO3xpVN2mSoRowakZMS6xwgHCd4KGfdHolNd1kVFrkogvVKEd9ZWNFcJG-9_iuRxvcEaA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtfedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:OjciYSSL9KJAxlCqAzAXg3lFb14dp6CioG_j5KYor-MPI3R_goAUcg>
    <xmx:OjciYaxaldCNmfEWWpbuv1drmd6yHT6I8FAeN3n7L7R1X9s0btdn0A>
    <xmx:OjciYY6_hD5_d_GtLracIKFUw-WOca3h4q98RmwtcwK5_e2h7Eg9xA>
    <xmx:OzciYUtngeJsnX9oM1ypbUsdXEJV19KooovcfOWZ14N4ld4XWbDNLg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Aug 2021 07:38:32 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/4] mlxsw: Remove old parsing depth infrastructure
Date:   Sun, 22 Aug 2021 14:37:15 +0300
Message-Id: <20210822113716.1440716-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210822113716.1440716-1-idosch@idosch.org>
References: <20210822113716.1440716-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The previous patches added new API to handle parsing depth and converted
the existing code to use it.

Remove the old infrastructure which is not needed anymore.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |  1 -
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 68 -------------------
 2 files changed, 69 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
index d8104fc6c900..98d1fdc25eac 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
@@ -29,7 +29,6 @@ struct mlxsw_sp_nve {
 	unsigned int num_max_mc_entries[MLXSW_SP_L3_PROTO_MAX];
 	u32 tunnel_index;
 	u16 ul_rif_index;	/* Reserved for Spectrum */
-	unsigned int inc_parsing_depth_refs;
 };
 
 struct mlxsw_sp_nve_ops {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index c722ac370fb6..d018d2da5949 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -10,14 +10,6 @@
 #include "spectrum.h"
 #include "spectrum_nve.h"
 
-/* Eth (18B) | IPv6 (40B) | UDP (8B) | VxLAN (8B) | Eth (14B) | IPv6 (40B)
- *
- * In the worst case - where we have a VLAN tag on the outer Ethernet
- * header and IPv6 in overlay and underlay - we need to parse 128 bytes
- */
-#define MLXSW_SP_NVE_VXLAN_PARSING_DEPTH 128
-#define MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH 96
-
 #define MLXSW_SP_NVE_VXLAN_SUPPORTED_FLAGS	(VXLAN_F_UDP_ZERO_CSUM_TX | \
 						 VXLAN_F_LEARN)
 
@@ -115,66 +107,6 @@ static void mlxsw_sp_nve_vxlan_config(const struct mlxsw_sp_nve *nve,
 	config->udp_dport = cfg->dst_port;
 }
 
-static int __mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
-				      unsigned int parsing_depth,
-				      __be16 udp_dport)
-{
-	char mprs_pl[MLXSW_REG_MPRS_LEN];
-
-	mlxsw_reg_mprs_pack(mprs_pl, parsing_depth, be16_to_cpu(udp_dport));
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mprs), mprs_pl);
-}
-
-static int mlxsw_sp_nve_parsing_set(struct mlxsw_sp *mlxsw_sp,
-				    __be16 udp_dport)
-{
-	int parsing_depth = mlxsw_sp->nve->inc_parsing_depth_refs ?
-				MLXSW_SP_NVE_VXLAN_PARSING_DEPTH :
-				MLXSW_SP_NVE_DEFAULT_PARSING_DEPTH;
-
-	return __mlxsw_sp_nve_parsing_set(mlxsw_sp, parsing_depth, udp_dport);
-}
-
-static int
-__mlxsw_sp_nve_inc_parsing_depth_get(struct mlxsw_sp *mlxsw_sp,
-				     __be16 udp_dport)
-{
-	int err;
-
-	mlxsw_sp->nve->inc_parsing_depth_refs++;
-
-	err = mlxsw_sp_nve_parsing_set(mlxsw_sp, udp_dport);
-	if (err)
-		goto err_nve_parsing_set;
-	return 0;
-
-err_nve_parsing_set:
-	mlxsw_sp->nve->inc_parsing_depth_refs--;
-	return err;
-}
-
-static void
-__mlxsw_sp_nve_inc_parsing_depth_put(struct mlxsw_sp *mlxsw_sp,
-				     __be16 udp_dport)
-{
-	mlxsw_sp->nve->inc_parsing_depth_refs--;
-	mlxsw_sp_nve_parsing_set(mlxsw_sp, udp_dport);
-}
-
-int mlxsw_sp_nve_inc_parsing_depth_get(struct mlxsw_sp *mlxsw_sp)
-{
-	__be16 udp_dport = mlxsw_sp->nve->config.udp_dport;
-
-	return __mlxsw_sp_nve_inc_parsing_depth_get(mlxsw_sp, udp_dport);
-}
-
-void mlxsw_sp_nve_inc_parsing_depth_put(struct mlxsw_sp *mlxsw_sp)
-{
-	__be16 udp_dport = mlxsw_sp->nve->config.udp_dport;
-
-	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, udp_dport);
-}
-
 static void
 mlxsw_sp_nve_vxlan_config_prepare(char *tngcr_pl,
 				  const struct mlxsw_sp_nve_config *config)
-- 
2.31.1


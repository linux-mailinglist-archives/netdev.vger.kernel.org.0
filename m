Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 692742D9770
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438134AbgLNLf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:35:27 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38235 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437994AbgLNLdB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:33:01 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 30F4D5C0195;
        Mon, 14 Dec 2020 06:31:19 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=/9UxObfiQuB8Zgv02Y+7mja7OyK4TLDPv6s4xo3hd38=; b=muR8cRP8
        xqEh8vlNJtfW1kvZ0WIC+twv5xaK1ksc0P1r/cE+ZP2T3xhzS8nxPNcr7bAyzgVk
        XwUis5dyORLhu9+rvCAZRXz0OQ01NGaAc/yoQhzI2y3ClvJqE8VXZ31DN0RPHT66
        nYoksQryEQj9fC6R5kXs6hFmHwRzEKm/ok5lSLcQYW71UyJ9O5Q5OjtLnJ1VeCGX
        XBB/RqQilvveCjGcuQYAwJLPNI6iyC5CE3J9iqnonneXktketPXO771zU2qRAODc
        Q3Uio5E+HA9mEv4H+tQ0zE6vs5i32Ehyj0hgg19fl7Iq1hTEzJSA4knkcrUBGuhw
        O3eCK9syL6zhGg==
X-ME-Sender: <xms:B03XX5I6jMKZdE85HPEzb4YXaiP2yA3DgKA9Wd5Vr1xLmUhHfgQibQ>
    <xme:B03XX1I44rR5J9r4pSpj5o49TaFn2MmikMizNfkp8pSFQa1pGOUr1fIJtLuBR81Eg
    AJgnnMXPHEQGLo>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgepuddtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:B03XXxv_40HiFsSYQBrTbCJtF4991D3h-5qq2LAfbpsWlcx6T1KXkw>
    <xmx:B03XX6ZMDcHW4SMa4_inDHmMuGCW-q67ZMnprMrtDfrc6OxmLguVsw>
    <xmx:B03XXwaL0v53MFB03YUlwrwVqEXCwhV9k43btEMKlsqszKc1dYE0aw>
    <xmx:B03XX_myJSxKaSnm4jkvzocN_Xq3UZIbaUTDdKtjhc1C34c5FzpT-w>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id 00A031080059;
        Mon, 14 Dec 2020 06:31:17 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 14/15] mlxsw: spectrum: Set KVH XLT cache mode for Spectrum2/3
Date:   Mon, 14 Dec 2020 13:30:40 +0200
Message-Id: <20201214113041.2789043-15-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Set a profile option to instruct FW to use 1/2 of KVH for XLT cache, not
the whole one.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/cmd.h      | 13 +++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h     |  4 +++-
 drivers/net/ethernet/mellanox/mlxsw/pci.c      |  6 ++++++
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  2 ++
 4 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/cmd.h b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
index 4de15c56542f..392ce3cb27f7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/cmd.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/cmd.h
@@ -674,6 +674,12 @@ MLXSW_ITEM32(cmd_mbox, config_profile, set_kvd_hash_double_size, 0x0C, 26, 1);
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, set_cqe_version, 0x08, 0, 1);
 
+/* cmd_mbox_config_set_kvh_xlt_cache_mode
+ * Capability bit. Setting a bit to 1 configures the profile
+ * according to the mailbox contents.
+ */
+MLXSW_ITEM32(cmd_mbox, config_profile, set_kvh_xlt_cache_mode, 0x08, 3, 1);
+
 /* cmd_mbox_config_profile_max_vepa_channels
  * Maximum number of VEPA channels per port (0 through 16)
  * 0 - multi-channel VEPA is disabled
@@ -800,6 +806,13 @@ MLXSW_ITEM32(cmd_mbox, config_profile, adaptive_routing_group_cap, 0x4C, 0, 16);
  */
 MLXSW_ITEM32(cmd_mbox, config_profile, arn, 0x50, 31, 1);
 
+/* cmd_mbox_config_profile_kvh_xlt_cache_mode
+ * KVH XLT cache mode:
+ * 0 - XLT can use all KVH as best-effort
+ * 1 - XLT cache uses 1/2 KVH
+ */
+MLXSW_ITEM32(cmd_mbox, config_profile, kvh_xlt_cache_mode, 0x50, 8, 4);
+
 /* cmd_mbox_config_kvd_linear_size
  * KVD Linear Size
  * Valid for Spectrum only
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 6558f9cde3d6..6b3ccbf6b238 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -256,7 +256,8 @@ struct mlxsw_config_profile {
 		used_max_pkey:1,
 		used_ar_sec:1,
 		used_adaptive_routing_group_cap:1,
-		used_kvd_sizes:1;
+		used_kvd_sizes:1,
+		used_kvh_xlt_cache_mode:1;
 	u8	max_vepa_channels;
 	u16	max_mid;
 	u16	max_pgt;
@@ -278,6 +279,7 @@ struct mlxsw_config_profile {
 	u32	kvd_linear_size;
 	u8	kvd_hash_single_parts;
 	u8	kvd_hash_double_parts;
+	u8	kvh_xlt_cache_mode;
 	struct mlxsw_swid_config swid_config[MLXSW_CONFIG_PROFILE_SWID_COUNT];
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/pci.c b/drivers/net/ethernet/mellanox/mlxsw/pci.c
index aae472f0e62f..4eeae8d78006 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/pci.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/pci.c
@@ -1196,6 +1196,12 @@ static int mlxsw_pci_config_profile(struct mlxsw_pci *mlxsw_pci, char *mbox,
 		mlxsw_cmd_mbox_config_profile_kvd_hash_double_size_set(mbox,
 					MLXSW_RES_GET(res, KVD_DOUBLE_SIZE));
 	}
+	if (profile->used_kvh_xlt_cache_mode) {
+		mlxsw_cmd_mbox_config_profile_set_kvh_xlt_cache_mode_set(
+			mbox, 1);
+		mlxsw_cmd_mbox_config_profile_kvh_xlt_cache_mode_set(
+			mbox, profile->kvh_xlt_cache_mode);
+	}
 
 	for (i = 0; i < MLXSW_CONFIG_PROFILE_SWID_COUNT; i++)
 		mlxsw_pci_config_profile_swid_config(mlxsw_pci, mbox, i,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 516d6cb45c9f..1650d9852b5b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2936,6 +2936,8 @@ static const struct mlxsw_config_profile mlxsw_sp2_config_profile = {
 	.max_ib_mc			= 0,
 	.used_max_pkey			= 1,
 	.max_pkey			= 0,
+	.used_kvh_xlt_cache_mode	= 1,
+	.kvh_xlt_cache_mode		= 1,
 	.swid_config			= {
 		{
 			.used_type	= 1,
-- 
2.29.2


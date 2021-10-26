Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B03A43AF48
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhJZJpd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:45:33 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:52451 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234827AbhJZJpb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:45:31 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 224395C02B7;
        Tue, 26 Oct 2021 05:43:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 26 Oct 2021 05:43:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=J4i8IDsK1v7XJpmEvRVjxjoyEMSo0iCHcvbOMUtnlPM=; b=K6u763kk
        qkSNJeUjrmsWxDJ2kRyZymxNZ0yqpI/Q1DGA8LP/hPnpIP5yc37MYXqTXO82DH/m
        7Io8vd2wZMOu+/duEokkVxadCdfQliZZVzDrDcR2xKiZ18AjV7gDvTwjgprTkprY
        H9ZUeI8B+OZqTfaxb1nSzl2l82MulkYXyZmEfgtOYU1cOcpl5PhlgagJxLJtPjsn
        Ws6bcLf54I0EsLXbfbJKBSGh/ZP1YcZCrt7gCgrJx+VQzlzKdBPqmzeK7LXsp/bV
        ysBGDgpa/dPLrZ3rSy0tKAqVQypHQ/iDKS2m7TbJOd9SHIlrpmH++1APg7GNcdvE
        WZw6cX6TuLfpWw==
X-ME-Sender: <xms:q813YRRKCat62OWpJC5w3BqGD9Z8fPW1EZP_BIHWWITtd8ICAirzsw>
    <xme:q813Yaye6BVetpWLcNj5RgQ4KSvcaoB8vOyIRFA1WZyIUNzNxY1aqBIZkNejVGzDH
    ihaQ_YsdR7kiCY>
X-ME-Received: <xmr:q813YW1virhtVdNn403wbsIcdBM3CoeuEw0leWURtW7VW7DwzLuQPVtm1zCY_tspiDbZAhNOymDvAJPCFnpj_b0l2JtO96CQyOB6LTVux3w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefjedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:q813YZDLbHZsHc5BvJ1lskfFD3mUI6aPHQsyokPiZranqPKa3TRr9g>
    <xmx:q813YajQOfBLc-ZChnUWy9BLYUU55MVUBBmSEtF2jmWrOTxPwzWXqQ>
    <xmx:q813Ydpj28V73XZ1su2oxFhRW3O6ICJ5KxwevUR9GXXOaraYnzRfjg>
    <xmx:rM13YcZnTxFZ1RZPy_mqW0heY3Cguzuc-0BhDZeeF4VaeVbO5KGJtg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 05:43:05 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/9] mlxsw: spectrum_router: Expose RIF MAC profiles to devlink resource
Date:   Tue, 26 Oct 2021 12:42:21 +0300
Message-Id: <20211026094225.1265320-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211026094225.1265320-1-idosch@idosch.org>
References: <20211026094225.1265320-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Expose via devlink-resource the maximum number of RIF MAC profiles and
their current occupancy, so it can be used for debug and writing generic
tests, like in the next patch.

Example for Spectrum-2 output:

$ devlink resource show pci/0000:06:00.0
...
  name rif_mac_profiles size 4 occ 0 unit entry dpipe_tables none

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 40 ++++++++++++++++++-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  8 ++++
 3 files changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 66c346a86ec5..5925db386b1b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3282,6 +3282,30 @@ static int mlxsw_sp_resources_span_register(struct mlxsw_core *mlxsw_core)
 					 &span_size_params);
 }
 
+static int
+mlxsw_sp_resources_rif_mac_profile_register(struct mlxsw_core *mlxsw_core)
+{
+	struct devlink *devlink = priv_to_devlink(mlxsw_core);
+	struct devlink_resource_size_params size_params;
+	u8 max_rif_mac_profiles;
+
+	if (!MLXSW_CORE_RES_VALID(mlxsw_core, MAX_RIF_MAC_PROFILES))
+		return -EIO;
+
+	max_rif_mac_profiles = MLXSW_CORE_RES_GET(mlxsw_core,
+						  MAX_RIF_MAC_PROFILES);
+	devlink_resource_size_params_init(&size_params, max_rif_mac_profiles,
+					  max_rif_mac_profiles, 1,
+					  DEVLINK_RESOURCE_UNIT_ENTRY);
+
+	return devlink_resource_register(devlink,
+					 "rif_mac_profiles",
+					 max_rif_mac_profiles,
+					 MLXSW_SP_RESOURCE_RIF_MAC_PROFILES,
+					 DEVLINK_RESOURCE_ID_PARENT_TOP,
+					 &size_params);
+}
+
 static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 {
 	int err;
@@ -3300,10 +3324,16 @@ static int mlxsw_sp1_resources_register(struct mlxsw_core *mlxsw_core)
 
 	err = mlxsw_sp_policer_resources_register(mlxsw_core);
 	if (err)
-		goto err_resources_counter_register;
+		goto err_policer_resources_register;
+
+	err = mlxsw_sp_resources_rif_mac_profile_register(mlxsw_core);
+	if (err)
+		goto err_resources_rif_mac_profile_register;
 
 	return 0;
 
+err_resources_rif_mac_profile_register:
+err_policer_resources_register:
 err_resources_counter_register:
 err_resources_span_register:
 	devlink_resources_unregister(priv_to_devlink(mlxsw_core), NULL);
@@ -3328,10 +3358,16 @@ static int mlxsw_sp2_resources_register(struct mlxsw_core *mlxsw_core)
 
 	err = mlxsw_sp_policer_resources_register(mlxsw_core);
 	if (err)
-		goto err_resources_counter_register;
+		goto err_policer_resources_register;
+
+	err = mlxsw_sp_resources_rif_mac_profile_register(mlxsw_core);
+	if (err)
+		goto err_resources_rif_mac_profile_register;
 
 	return 0;
 
+err_resources_rif_mac_profile_register:
+err_policer_resources_register:
 err_resources_counter_register:
 err_resources_span_register:
 	devlink_resources_unregister(priv_to_devlink(mlxsw_core), NULL);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 3ab57e98cad2..32fdd37657dd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -67,6 +67,7 @@ enum mlxsw_sp_resource_id {
 	MLXSW_SP_RESOURCE_COUNTERS_RIF,
 	MLXSW_SP_RESOURCE_GLOBAL_POLICERS,
 	MLXSW_SP_RESOURCE_SINGLE_RATE_POLICERS,
+	MLXSW_SP_RESOURCE_RIF_MAC_PROFILES,
 };
 
 struct mlxsw_sp_port;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index f7b18192e2c7..217e3b351dfe 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9762,6 +9762,7 @@ static const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[] = {
 static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 {
 	u64 max_rifs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	struct mlxsw_core *core = mlxsw_sp->core;
 
 	if (!MLXSW_CORE_RES_VALID(core, MAX_RIF_MAC_PROFILES))
@@ -9777,17 +9778,24 @@ static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 
 	idr_init(&mlxsw_sp->router->rif_mac_profiles_idr);
 	atomic_set(&mlxsw_sp->router->rif_mac_profiles_count, 0);
+	devlink_resource_occ_get_register(devlink,
+					  MLXSW_SP_RESOURCE_RIF_MAC_PROFILES,
+					  mlxsw_sp_rif_mac_profiles_occ_get,
+					  mlxsw_sp);
 
 	return 0;
 }
 
 static void mlxsw_sp_rifs_fini(struct mlxsw_sp *mlxsw_sp)
 {
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
 	int i;
 
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++)
 		WARN_ON_ONCE(mlxsw_sp->router->rifs[i]);
 
+	devlink_resource_occ_get_unregister(devlink,
+					    MLXSW_SP_RESOURCE_RIF_MAC_PROFILES);
 	WARN_ON(!idr_is_empty(&mlxsw_sp->router->rif_mac_profiles_idr));
 	idr_destroy(&mlxsw_sp->router->rif_mac_profiles_idr);
 	kfree(mlxsw_sp->router->rifs);
-- 
2.31.1


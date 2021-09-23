Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78496415E85
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241085AbhIWMkY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:40:24 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:39787 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241088AbhIWMkD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:40:03 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 6DD115C00D6;
        Thu, 23 Sep 2021 08:38:31 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 23 Sep 2021 08:38:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=oatNBtMFNpC+vOvxnR88LDmjk/D3rn36lvAJWCmfOT0=; b=mWOa+lbD
        jvwuGWZDNuy/sdezK3MSy1xM2NSwT2e9gxPm117z4VqoJsjpHwZDN7cPXAmZZii7
        FlfEY6YfXXBaqVzR5IkgekhwsvbVho+vZKM+4392m9XSQlHosnb1RJoSdacDcRJv
        pOdL1Klailq2MQGDdMOP01AC+NVa07oB7Pr0OaSciXxCdfx5zGmkIWYdzdBYFqDP
        YpwlisXOoABG9tUtcEbLt9BxgoKWsfw7bb5hWHT9xocK1i4j7AlYSicu9oOEgl8X
        tp6d4wUXpcHk1rgRpoJTrWdlh1g2QeYq9jRReqzujJK1rBhM7M5SU8rLhDYyN3x/
        6Yzbl7+lKgi6iw==
X-ME-Sender: <xms:R3VMYVV8OR6FCxnm7o3sDKDEloWfo7er_Sf0cXGLSiBRC93jTliRSQ>
    <xme:R3VMYVlqgCD5VdqU791Lj8jtNY5o-OcZYr0JYTRdrLTgQLDUp32OZ2Vqffnw1kdjq
    anqDwzpBclHiCQ>
X-ME-Received: <xmr:R3VMYRaWpWX98VU23giuRopfhP3iLASueX4FANB-hvulMtv3k63vC5OnrvtetD7grTdEyc5flegb-Njpz-loKjT3exJOgdae9Wxdoj6p7ttQRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepgeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:R3VMYYUXhMGpN4658kTxF9pUE2Jw6pB4mxelMbtyGr0qiMt_qEYSXw>
    <xmx:R3VMYflFP1M568ahZqPL1wzrjUG2XvPNh14T8_dOoR2XK-w4Jeopeg>
    <xmx:R3VMYVcdQTsSnuuQeFBw2fGukRmV09f9xmLlfJfWe7-5pSAZBL3x9Q>
    <xmx:R3VMYasBFJQXOoMTYQNztbNuH4weaMt3V3cao1hLVN4Ry6hsV3e06Q>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:29 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 13/14] mlxsw: spectrum_router: Increase parsing depth for IPv6 decapsulation
Date:   Thu, 23 Sep 2021 15:36:59 +0300
Message-Id: <20210923123700.885466-14-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The Spectrum ASIC has a configurable limit on how deep into the packet
it parses. By default, the limit is 96 bytes.

For IP-in-IP packets, with IPv6 outer and inner headers, the default
parsing depth is not enough and without increasing it such packets cannot
be properly decapsulated.

Use the existing API to set parsing depth, call it once for each
decapsulation entry when it is created/destroyed.
There is no need to protect the code with new mutex because 'router->lock'
is already taken in these code paths.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   |  2 +
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |  1 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 40 +++++++++++++++++++
 3 files changed, 43 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 4bb4a3e3a2aa..37a1ad92ac91 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -316,6 +316,7 @@ mlxsw_sp_ipip_ol_netdev_change_gre4(struct mlxsw_sp *mlxsw_sp,
 static const struct mlxsw_sp_ipip_ops mlxsw_sp_ipip_gre4_ops = {
 	.dev_type = ARPHRD_IPGRE,
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV4,
+	.inc_parsing_depth = false,
 	.parms_init = mlxsw_sp_ipip_netdev_parms_init_gre4,
 	.nexthop_update = mlxsw_sp_ipip_nexthop_update_gre4,
 	.decap_config = mlxsw_sp_ipip_decap_config_gre4,
@@ -379,6 +380,7 @@ mlxsw_sp1_ipip_ol_netdev_change_gre6(struct mlxsw_sp *mlxsw_sp,
 static const struct mlxsw_sp_ipip_ops mlxsw_sp1_ipip_gre6_ops = {
 	.dev_type = ARPHRD_IP6GRE,
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
+	.inc_parsing_depth = true,
 	.parms_init = mlxsw_sp1_ipip_netdev_parms_init_gre6,
 	.nexthop_update = mlxsw_sp1_ipip_nexthop_update_gre6,
 	.decap_config = mlxsw_sp1_ipip_decap_config_gre6,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index 5d93337b9a2d..2444f09d3fb1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -46,6 +46,7 @@ struct mlxsw_sp_ipip_entry {
 struct mlxsw_sp_ipip_ops {
 	int dev_type;
 	enum mlxsw_sp_l3proto ul_proto; /* Underlay. */
+	bool inc_parsing_depth;
 
 	struct mlxsw_sp_ipip_parms
 	(*parms_init)(const struct net_device *ol_dev);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 321f19f21d18..ed3f308d69cd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1157,6 +1157,32 @@ mlxsw_sp_ipip_entry_saddr_matches(struct mlxsw_sp *mlxsw_sp,
 	       mlxsw_sp_l3addr_eq(&tun_saddr, &saddr);
 }
 
+static int mlxsw_sp_ipip_decap_parsing_depth_inc(struct mlxsw_sp *mlxsw_sp,
+						 enum mlxsw_sp_ipip_type ipipt)
+{
+	const struct mlxsw_sp_ipip_ops *ipip_ops;
+
+	ipip_ops = mlxsw_sp->router->ipip_ops_arr[ipipt];
+
+	/* Not all tunnels require to increase the default pasing depth
+	 * (96 bytes).
+	 */
+	if (ipip_ops->inc_parsing_depth)
+		return mlxsw_sp_parsing_depth_inc(mlxsw_sp);
+
+	return 0;
+}
+
+static void mlxsw_sp_ipip_decap_parsing_depth_dec(struct mlxsw_sp *mlxsw_sp,
+						  enum mlxsw_sp_ipip_type ipipt)
+{
+	const struct mlxsw_sp_ipip_ops *ipip_ops =
+		mlxsw_sp->router->ipip_ops_arr[ipipt];
+
+	if (ipip_ops->inc_parsing_depth)
+		mlxsw_sp_parsing_depth_dec(mlxsw_sp);
+}
+
 static int
 mlxsw_sp_fib_entry_decap_init(struct mlxsw_sp *mlxsw_sp,
 			      struct mlxsw_sp_fib_entry *fib_entry,
@@ -1170,18 +1196,32 @@ mlxsw_sp_fib_entry_decap_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		return err;
 
+	err = mlxsw_sp_ipip_decap_parsing_depth_inc(mlxsw_sp,
+						    ipip_entry->ipipt);
+	if (err)
+		goto err_parsing_depth_inc;
+
 	ipip_entry->decap_fib_entry = fib_entry;
 	fib_entry->decap.ipip_entry = ipip_entry;
 	fib_entry->decap.tunnel_index = tunnel_index;
+
 	return 0;
+
+err_parsing_depth_inc:
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ, 1,
+			   fib_entry->decap.tunnel_index);
+	return err;
 }
 
 static void mlxsw_sp_fib_entry_decap_fini(struct mlxsw_sp *mlxsw_sp,
 					  struct mlxsw_sp_fib_entry *fib_entry)
 {
+	enum mlxsw_sp_ipip_type ipipt = fib_entry->decap.ipip_entry->ipipt;
+
 	/* Unlink this node from the IPIP entry that it's the decap entry of. */
 	fib_entry->decap.ipip_entry->decap_fib_entry = NULL;
 	fib_entry->decap.ipip_entry = NULL;
+	mlxsw_sp_ipip_decap_parsing_depth_dec(mlxsw_sp, ipipt);
 	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_ADJ,
 			   1, fib_entry->decap.tunnel_index);
 }
-- 
2.31.1


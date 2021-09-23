Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39371415E81
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241068AbhIWMj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:59 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:44233 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240995AbhIWMj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:56 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 8ABE85C0145;
        Thu, 23 Sep 2021 08:38:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 23 Sep 2021 08:38:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=OFsjwOWDaSXFcO0zEQVUZ5YI1iKKAEJMnkyTmq86pKs=; b=Fp1Qtbkn
        G9I56co/ksqEbXD3sBUkuZK3w/7ZG/YLh+r1EoU13/zphd6cuS2q4WmJB6uXsXsY
        1fKiZ4O97ifVuftas9XTM8tupSkCLfxdDPt79RX9qBe75X67WvJx0l/cAsvNzLJR
        cOkHRpdUWV7VUWQQDwTuzj6eHUshbvNtz2zCIzqun+MZMOqHM+JknZIu9t9pMKZz
        s00Aln62uAJRBlc+YkoM/9Q21svRxga1Ss59tMu6EviHi48OHkGUJxdGQdnhRsku
        TC9KcgbJpM8vRPlHbvQLZ8vZ1EK3ZtXnFbV0/o4Y3SD3/gH44fxZQ5RpZ3I+x3YH
        1B5b2M3fQw3iGg==
X-ME-Sender: <xms:QHVMYTNLGISa8qsewPfenD3lguSHWKxEUQ9M8FnGdO0q2BidtkETTQ>
    <xme:QHVMYd_y4ea7nsg_YqsX0SWPQFNXCVlr68siiz1Kuwp5DHYhuJBd-3hxW-I2-Xl9P
    XISHPpf-XrMit4>
X-ME-Received: <xmr:QHVMYSQbXY0cStf2-Dy5J-68Xw1SVyqGVwJNi51vzVo075Mup5fbEMS23TuBmeryf8SZSCrVKgwwOmbjxmgZjhp64ooIJS6yDxFWyeMs-jzpeQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:QHVMYXtSGlkvwRmgl4QFPqFghrFX-JmBGlYvFekxkRj5AaKCXnvyWQ>
    <xmx:QHVMYbdk94VO3mR5WCeAfCazJX3qlF0rJMz7gg2Zfom3QhStLfUapw>
    <xmx:QHVMYT3obFrZXzA1jB40J-y2nu0ZNykpjiKO9Zv5rtDDn6d4Tc_osg>
    <xmx:QHVMYcEqjV0Mg46FxWk3c9dLQFNRvYrfTB-w3KShw3Ug_x41RvM-BA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:22 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/14] mlxsw: Create separate ipip_ops_arr for different ASICs
Date:   Thu, 23 Sep 2021 15:36:56 +0300
Message-Id: <20210923123700.885466-11-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, there is support for IP-in-IP only with IPv4 underlay for all
supported Spectrum ASICs.
The next patches will add support for IPv6 underlay only for Spectrum-2
and above.

Add infrastructure for splitting IP-in-IP support between different
ASICs - create separate ipip_ops_arr and add ipips_init function to set the
right ops.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c    |  6 +++++-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h    |  3 ++-
 .../ethernet/mellanox/mlxsw/spectrum_router.c  | 18 ++++++++++++++++--
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 3c07e3a70fb6..93d183d5100d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -324,7 +324,11 @@ static const struct mlxsw_sp_ipip_ops mlxsw_sp_ipip_gre4_ops = {
 	.ol_netdev_change = mlxsw_sp_ipip_ol_netdev_change_gre4,
 };
 
-const struct mlxsw_sp_ipip_ops *mlxsw_sp_ipip_ops_arr[] = {
+const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[] = {
+	[MLXSW_SP_IPIP_TYPE_GRE4] = &mlxsw_sp_ipip_gre4_ops,
+};
+
+const struct mlxsw_sp_ipip_ops *mlxsw_sp2_ipip_ops_arr[] = {
 	[MLXSW_SP_IPIP_TYPE_GRE4] = &mlxsw_sp_ipip_gre4_ops,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index bc6866d1c070..4426a44d546f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -70,6 +70,7 @@ struct mlxsw_sp_ipip_ops {
 				struct netlink_ext_ack *extack);
 };
 
-extern const struct mlxsw_sp_ipip_ops *mlxsw_sp_ipip_ops_arr[];
+extern const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[];
+extern const struct mlxsw_sp_ipip_ops *mlxsw_sp2_ipip_ops_arr[];
 
 #endif /* _MLXSW_IPIP_H_*/
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 2582404043af..321f19f21d18 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -115,6 +115,7 @@ struct mlxsw_sp_rif_ops {
 
 struct mlxsw_sp_router_ops {
 	int (*init)(struct mlxsw_sp *mlxsw_sp);
+	int (*ipips_init)(struct mlxsw_sp *mlxsw_sp);
 };
 
 static struct mlxsw_sp_rif *
@@ -9468,7 +9469,6 @@ static int mlxsw_sp_ipips_init(struct mlxsw_sp *mlxsw_sp)
 {
 	int err;
 
-	mlxsw_sp->router->ipip_ops_arr = mlxsw_sp_ipip_ops_arr;
 	INIT_LIST_HEAD(&mlxsw_sp->router->ipip_list);
 
 	err = mlxsw_sp_ipip_ecn_encap_init(mlxsw_sp);
@@ -9481,6 +9481,18 @@ static int mlxsw_sp_ipips_init(struct mlxsw_sp *mlxsw_sp)
 	return mlxsw_sp_ipip_config_tigcr(mlxsw_sp);
 }
 
+static int mlxsw_sp1_ipips_init(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp->router->ipip_ops_arr = mlxsw_sp1_ipip_ops_arr;
+	return mlxsw_sp_ipips_init(mlxsw_sp);
+}
+
+static int mlxsw_sp2_ipips_init(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp->router->ipip_ops_arr = mlxsw_sp2_ipip_ops_arr;
+	return mlxsw_sp_ipips_init(mlxsw_sp);
+}
+
 static void mlxsw_sp_ipips_fini(struct mlxsw_sp *mlxsw_sp)
 {
 	WARN_ON(!list_empty(&mlxsw_sp->router->ipip_list));
@@ -9895,6 +9907,7 @@ static int mlxsw_sp1_router_init(struct mlxsw_sp *mlxsw_sp)
 
 const struct mlxsw_sp_router_ops mlxsw_sp1_router_ops = {
 	.init = mlxsw_sp1_router_init,
+	.ipips_init = mlxsw_sp1_ipips_init,
 };
 
 static int mlxsw_sp2_router_init(struct mlxsw_sp *mlxsw_sp)
@@ -9910,6 +9923,7 @@ static int mlxsw_sp2_router_init(struct mlxsw_sp *mlxsw_sp)
 
 const struct mlxsw_sp_router_ops mlxsw_sp2_router_ops = {
 	.init = mlxsw_sp2_router_init,
+	.ipips_init = mlxsw_sp2_ipips_init,
 };
 
 int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
@@ -9955,7 +9969,7 @@ int mlxsw_sp_router_init(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_rifs_init;
 
-	err = mlxsw_sp_ipips_init(mlxsw_sp);
+	err = mlxsw_sp->router_ops->ipips_init(mlxsw_sp);
 	if (err)
 		goto err_ipips_init;
 
-- 
2.31.1


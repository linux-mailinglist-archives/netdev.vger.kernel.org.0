Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59D6733EE6F
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 11:40:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhCQKjn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 06:39:43 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:48983 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230026AbhCQKjY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 06:39:24 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 9964D5C0145;
        Wed, 17 Mar 2021 06:39:23 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Wed, 17 Mar 2021 06:39:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=sCaJQgUhHFhXdKtZU4eEWANaoT3tJeOCTto+ZKBVsMQ=; b=qSAuSFR2
        tXngLzd42dLsSMXkpTGnyfvLmGfI+boirKF7oGi4bWij1MD60oYnlv9yanNTG1K5
        wcwoEbu533tqXK581GnInM+Y3SNtN0q3Ie89vE4HTKoVTbENjibxlftM4Ob5lbfV
        Idmq/AZTSOUzFnrY8ymi0p4mda5OCF4BOK0V8KCttpfkH3CpnTOfNA+aWsKVbmK/
        7hPT+s6htyy/i9jbZdxIXSUncDfHFzcNW4VKFSq28S4eaaMKZ5+qtNKRT1Z2lHFR
        KrUdwpvfKGTsnWKeoeLI1rYEZ1dUdWVKFMe6NZIXIOCnSpLhDYduYZ9YIrae4iIZ
        KL/WpUPt/2o3nw==
X-ME-Sender: <xms:W9xRYGIfOdX2iHzxYkvlsB3Cgc1ZzHCoACmfMk1TQymDIFq1680CDg>
    <xme:W9xRYOKE0k3Iv2DgOmyVRiroAvuJDAg1Bx3kW59UUjkfw_ST1OzuwT7D-XqFtbTCv
    oyczvaxKOnsnDY>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefgedgudelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrgeeg
    necuvehluhhsthgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:W9xRYGv4vbnT2w7ZOZlO8ckufBdc_sjKP6Nrcp6PZkQRN5RwJ8Sk2A>
    <xmx:W9xRYLZTmtTW95KKfFpZXkyy0M-QwIMWmIioxG5iJ_WjvzI-q-SaDg>
    <xmx:W9xRYNbs9mjabGNNmyRwue9Doys8363Fp0RQf9x-UGgp2BO11e6kBA>
    <xmx:W9xRYMXrnX5INE0B8tTrdt5xQl79edZ_SVZoPgoG_89zcqkCtX_WDA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id AFAA9108005C;
        Wed, 17 Mar 2021 06:39:21 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/7] mlxsw: Add struct mlxsw_sp_switchdev_ops per ASIC
Date:   Wed, 17 Mar 2021 12:35:26 +0200
Message-Id: <20210317103529.2903172-5-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210317103529.2903172-1-idosch@idosch.org>
References: <20210317103529.2903172-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

A subsequent patch will need to implement different set of operations
when a port joins / leaves an 802.1ad bridge, based on the ASIC type.

Prepare for this change by allowing to initialize the bridge module
based on the ASIC type via 'struct mlxsw_sp_switchdev_ops'.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    |  3 +++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  6 +++++
 .../mellanox/mlxsw/spectrum_switchdev.c       | 22 +++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 9aba4fe2c852..df4ec063adcb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2925,6 +2925,7 @@ static int mlxsw_sp1_init(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
+	mlxsw_sp->switchdev_ops = &mlxsw_sp1_switchdev_ops;
 	mlxsw_sp->kvdl_ops = &mlxsw_sp1_kvdl_ops;
 	mlxsw_sp->afa_ops = &mlxsw_sp1_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp1_afk_ops;
@@ -2955,6 +2956,7 @@ static int mlxsw_sp2_init(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
+	mlxsw_sp->switchdev_ops = &mlxsw_sp2_switchdev_ops;
 	mlxsw_sp->kvdl_ops = &mlxsw_sp2_kvdl_ops;
 	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp2_afk_ops;
@@ -2983,6 +2985,7 @@ static int mlxsw_sp3_init(struct mlxsw_core *mlxsw_core,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 
+	mlxsw_sp->switchdev_ops = &mlxsw_sp2_switchdev_ops;
 	mlxsw_sp->kvdl_ops = &mlxsw_sp2_kvdl_ops;
 	mlxsw_sp->afa_ops = &mlxsw_sp2_act_afa_ops;
 	mlxsw_sp->afk_ops = &mlxsw_sp2_afk_ops;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 180ffa41bf46..03655e418edb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -92,6 +92,11 @@ struct mlxsw_sp_rif_ops;
 extern const struct mlxsw_sp_rif_ops *mlxsw_sp1_rif_ops_arr[];
 extern const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[];
 
+struct mlxsw_sp_switchdev_ops;
+
+extern const struct mlxsw_sp_switchdev_ops mlxsw_sp1_switchdev_ops;
+extern const struct mlxsw_sp_switchdev_ops mlxsw_sp2_switchdev_ops;
+
 enum mlxsw_sp_fid_type {
 	MLXSW_SP_FID_TYPE_8021Q,
 	MLXSW_SP_FID_TYPE_8021D,
@@ -167,6 +172,7 @@ struct mlxsw_sp {
 	struct mlxsw_sp_counter_pool *counter_pool;
 	struct mlxsw_sp_span *span;
 	struct mlxsw_sp_trap *trap;
+	const struct mlxsw_sp_switchdev_ops *switchdev_ops;
 	const struct mlxsw_sp_kvdl_ops *kvdl_ops;
 	const struct mlxsw_afa_ops *afa_ops;
 	const struct mlxsw_afk_ops *afk_ops;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 23b7e8d6386b..51fdbdc8ac66 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -98,6 +98,10 @@ struct mlxsw_sp_bridge_ops {
 		       const struct mlxsw_sp_fid *fid);
 };
 
+struct mlxsw_sp_switchdev_ops {
+	void (*init)(struct mlxsw_sp *mlxsw_sp);
+};
+
 static int
 mlxsw_sp_bridge_port_fdb_flush(struct mlxsw_sp *mlxsw_sp,
 			       struct mlxsw_sp_bridge_port *bridge_port,
@@ -3535,6 +3539,22 @@ static void mlxsw_sp_fdb_fini(struct mlxsw_sp *mlxsw_sp)
 	unregister_switchdev_notifier(&mlxsw_sp_switchdev_notifier);
 }
 
+static void mlxsw_sp1_switchdev_init(struct mlxsw_sp *mlxsw_sp)
+{
+}
+
+const struct mlxsw_sp_switchdev_ops mlxsw_sp1_switchdev_ops = {
+	.init	= mlxsw_sp1_switchdev_init,
+};
+
+static void mlxsw_sp2_switchdev_init(struct mlxsw_sp *mlxsw_sp)
+{
+}
+
+const struct mlxsw_sp_switchdev_ops mlxsw_sp2_switchdev_ops = {
+	.init	= mlxsw_sp2_switchdev_init,
+};
+
 int mlxsw_sp_switchdev_init(struct mlxsw_sp *mlxsw_sp)
 {
 	struct mlxsw_sp_bridge *bridge;
@@ -3551,6 +3571,8 @@ int mlxsw_sp_switchdev_init(struct mlxsw_sp *mlxsw_sp)
 	bridge->bridge_8021d_ops = &mlxsw_sp_bridge_8021d_ops;
 	bridge->bridge_8021ad_ops = &mlxsw_sp_bridge_8021ad_ops;
 
+	mlxsw_sp->switchdev_ops->init(mlxsw_sp);
+
 	return mlxsw_sp_fdb_init(mlxsw_sp);
 }
 
-- 
2.29.2


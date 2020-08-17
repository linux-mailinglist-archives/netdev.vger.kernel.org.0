Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 404392466B5
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 14:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgHQMxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 08:53:23 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:60951 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728563AbgHQMxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Aug 2020 08:53:22 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id A6150714;
        Mon, 17 Aug 2020 08:53:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 17 Aug 2020 08:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=aVE32PImCPZl/J7SliC3bPsJtAIgs+EOzRaZs/BOa5Y=; b=AgjKSaC7
        UeGqop4sA56GAB/7Ee/13ZxsoJRxaSjL2F0IBw3IVVwc291FtOjngnS9vTPjB/IL
        mROTSIvbqTy6VjmQcO2LLzYMqKh/62Pljvz8Xh0x1v/L5Z0/3HJvaTMuaq2dJMbi
        as6+8UmjQZUX+Ag67UL736M/0TmJO0RJn2oEBem/KR9dkdXu9umMaZyx4jG49Wpo
        jTu7MPIDBLZ/72JxeUvVX+a5fU/OrrUbLQWvHeHJKShj8KGpYeYio9NQZ2RyKige
        rk5O9PuNa11BWVHzz6bnY329XttEdn6J+KOuGtBviOH0+vehsex1ni0GiUJ+ahCT
        MFpN69jtM92rRg==
X-ME-Sender: <xms:wH06X_EXYO3It2-_ZmHjGFUVY3OwV_m6nDBfx1yL5nAaGMDFp2-CHw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtfedgheeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudekvddrieefrdegvden
    ucevlhhushhtvghrufhiiigvpeehnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughosh
    gthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:wH06X8XTjr-Ht8qsI28CkqTuWWBgg-14BqvWKzHacBs_77f5Ix6pyQ>
    <xmx:wH06XxKBD-mL4lrIbJNRNVuid8zAiOcOuVjNTurjobx98cs3WVX1qw>
    <xmx:wH06X9GMCwe2ldEjfne4zPmmfT-c20h-qxUqQOyK4DNrK2RbeAuTTQ>
    <xmx:wH06X6UiG83zYNX5lm9HTKGJjNHuUgXXP5P4g_dMFBdF-UHbG_Rz1qxDrts>
Received: from localhost.localdomain (bzq-79-182-63-42.red.bezeqint.net [79.182.63.42])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0DACA30600B1;
        Mon, 17 Aug 2020 08:53:04 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        roopa@nvidia.com, dsahern@gmail.com, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com, saeedm@nvidia.com,
        tariqt@nvidia.com, ayal@nvidia.com, eranbe@nvidia.com,
        mkubecek@suse.cz, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 6/6] mlxsw: spectrum_nve: Expose VXLAN counters via devlink-metric
Date:   Mon, 17 Aug 2020 15:50:59 +0300
Message-Id: <20200817125059.193242-7-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200817125059.193242-1-idosch@idosch.org>
References: <20200817125059.193242-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The Spectrum ASICs have a single hardware VTEP that is able to perform
VXLAN encapsulation and decapsulation. The VTEP is logically mapped by
mlxsw to the multiple VXLAN netdevs that are using it. Exposing the
counters of this VTEP via the multiple VXLAN netdevs that are using it
would be both inaccurate and confusing for users.

Instead, expose the counters of the VTEP via devlink-metric. Note that
Spectrum-1 supports a different set of counters compared to newer ASICs
in the Spectrum family.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 Documentation/networking/devlink/mlxsw.rst    |  36 +++
 .../ethernet/mellanox/mlxsw/spectrum_nve.h    |  10 +
 .../mellanox/mlxsw/spectrum_nve_vxlan.c       | 285 ++++++++++++++++++
 3 files changed, 331 insertions(+)

diff --git a/Documentation/networking/devlink/mlxsw.rst b/Documentation/networking/devlink/mlxsw.rst
index cf857cb4ba8f..5d95056a571a 100644
--- a/Documentation/networking/devlink/mlxsw.rst
+++ b/Documentation/networking/devlink/mlxsw.rst
@@ -79,3 +79,39 @@ Driver-specific Traps
        routed through a disabled router interface (RIF). This can happen during
        RIF dismantle, when the RIF is first disabled before being removed
        completely
+
+Metrics
+=======
+
+.. list-table:: List of metrics registered by ``mlxsw``
+   :widths: 5 5 20 70
+
+   * - Name
+     - Type
+     - Supported platforms
+     - Description
+   * - ``nve_vxlan_encap``
+     - ``counter``
+     - Spectrum-1 only
+     - Counts number of packets that were VXLAN encapsulated by the device. A
+       packet sent to multiple VTEPs is counted multiple times
+   * - ``nve_vxlan_decap``
+     - ``counter``
+     - Spectrum-1 only
+     - Counts number of VXLAN packets that were decapsulated (successfully or
+       otherwise) by the device
+   * - ``nve_vxlan_decap_errors``
+     - ``counter``
+     - Spectrum-1 only
+     - Counts number of VXLAN packets that encountered decapsulation errors.
+       This includes overlay packets with a VLAN tag, ECN mismatch between
+       overlay and underlay, multicast overlay source MAC, overlay source MAC
+       equals overlay destination MAC and packets too short to decapsulate
+   * - ``nve_vxlan_decap_discards``
+     - ``counter``
+     - All
+     - Counts number of VXLAN packets that were discarded during decapsulation.
+       In Spectrum-1 this includes packets that had to be VXLAN decapsulated
+       when VXLAN decapsulation is disabled and fragmented overlay packets. In
+       Spectrum-2 this includes ``nve_vxlan_decap_errors`` errors and a missing
+       mapping between VNI and filtering identifier (FID)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
index 12f664f42f21..249adea4d547 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve.h
@@ -6,6 +6,7 @@
 
 #include <linux/netlink.h>
 #include <linux/rhashtable.h>
+#include <net/devlink.h>
 
 #include "spectrum.h"
 
@@ -20,10 +21,19 @@ struct mlxsw_sp_nve_config {
 	union mlxsw_sp_l3addr ul_sip;
 };
 
+struct mlxsw_sp_nve_metrics {
+	struct devlink_metric *counter_encap;
+	struct devlink_metric *counter_decap;
+	struct devlink_metric *counter_decap_errors;
+	struct devlink_metric *counter_decap_discards;
+	struct devlink_metric *counter_encap_discards;
+};
+
 struct mlxsw_sp_nve {
 	struct mlxsw_sp_nve_config config;
 	struct rhashtable mc_list_ht;
 	struct mlxsw_sp *mlxsw_sp;
+	struct mlxsw_sp_nve_metrics metrics;
 	const struct mlxsw_sp_nve_ops **nve_ops_arr;
 	unsigned int num_nve_tunnels;	/* Protected by RTNL */
 	unsigned int num_max_mc_entries[MLXSW_SP_L3_PROTO_MAX];
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
index 05517c7feaa5..7b71fecb3b96 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_nve_vxlan.c
@@ -4,6 +4,7 @@
 #include <linux/netdevice.h>
 #include <linux/netlink.h>
 #include <linux/random.h>
+#include <net/devlink.h>
 #include <net/vxlan.h>
 
 #include "reg.h"
@@ -220,6 +221,173 @@ static int mlxsw_sp1_nve_vxlan_rtdp_set(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rtdp), rtdp_pl);
 }
 
+static int
+mlxsw_sp1_nve_vxlan_common_counter_get(struct devlink_metric *metric,
+				       char *tncr_pl)
+{
+	struct mlxsw_sp *mlxsw_sp = devlink_metric_priv(metric);
+
+	mlxsw_reg_tncr_pack(tncr_pl, false);
+
+	return mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(tncr), tncr_pl);
+}
+
+static int
+mlxsw_sp1_nve_vxlan_encap_counter_get(struct devlink_metric *metric,
+				      u64 *p_val)
+{
+	char tncr_pl[MLXSW_REG_TNCR_LEN];
+	int err;
+
+	err = mlxsw_sp1_nve_vxlan_common_counter_get(metric, tncr_pl);
+	if (err)
+		return err;
+
+	*p_val = mlxsw_reg_tncr_count_encap_get(tncr_pl);
+
+	return 0;
+}
+
+static const struct devlink_metric_ops mlxsw_sp1_nve_vxlan_encap_ops = {
+	.counter_get = mlxsw_sp1_nve_vxlan_encap_counter_get,
+};
+
+static int
+mlxsw_sp1_nve_vxlan_decap_counter_get(struct devlink_metric *metric,
+				      u64 *p_val)
+{
+	char tncr_pl[MLXSW_REG_TNCR_LEN];
+	int err;
+
+	err = mlxsw_sp1_nve_vxlan_common_counter_get(metric, tncr_pl);
+	if (err)
+		return err;
+
+	*p_val = mlxsw_reg_tncr_count_decap_get(tncr_pl);
+
+	return 0;
+}
+
+static const struct devlink_metric_ops mlxsw_sp1_nve_vxlan_decap_ops = {
+	.counter_get = mlxsw_sp1_nve_vxlan_decap_counter_get,
+};
+
+static int
+mlxsw_sp1_nve_vxlan_decap_errors_counter_get(struct devlink_metric *metric,
+					     u64 *p_val)
+{
+	char tncr_pl[MLXSW_REG_TNCR_LEN];
+	int err;
+
+	err = mlxsw_sp1_nve_vxlan_common_counter_get(metric, tncr_pl);
+	if (err)
+		return err;
+
+	*p_val = mlxsw_reg_tncr_count_decap_errors_get(tncr_pl);
+
+	return 0;
+}
+
+static const struct devlink_metric_ops mlxsw_sp1_nve_vxlan_decap_errors_ops = {
+	.counter_get = mlxsw_sp1_nve_vxlan_decap_errors_counter_get,
+};
+
+static int
+mlxsw_sp1_nve_vxlan_decap_discards_counter_get(struct devlink_metric *metric,
+					       u64 *p_val)
+{
+	char tncr_pl[MLXSW_REG_TNCR_LEN];
+	int err;
+
+	err = mlxsw_sp1_nve_vxlan_common_counter_get(metric, tncr_pl);
+	if (err)
+		return err;
+
+	*p_val = mlxsw_reg_tncr_count_decap_discards_get(tncr_pl);
+
+	return 0;
+}
+
+static const struct devlink_metric_ops mlxsw_sp1_nve_vxlan_decap_discards_ops = {
+	.counter_get = mlxsw_sp1_nve_vxlan_decap_discards_counter_get,
+};
+
+static int mlxsw_sp1_nve_vxlan_counters_clear(struct mlxsw_sp *mlxsw_sp)
+{
+	char tncr_pl[MLXSW_REG_TNCR_LEN];
+
+	mlxsw_reg_tncr_pack(tncr_pl, true);
+
+	/* Clear operation is implemented on query. */
+	return mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(tncr), tncr_pl);
+}
+
+static int mlxsw_sp1_nve_vxlan_metrics_init(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_nve_metrics *metrics = &mlxsw_sp->nve->metrics;
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	int err;
+
+	err = mlxsw_sp1_nve_vxlan_counters_clear(mlxsw_sp);
+	if (err)
+		return err;
+
+	metrics->counter_encap =
+		devlink_metric_counter_create(devlink, "nve_vxlan_encap",
+					      &mlxsw_sp1_nve_vxlan_encap_ops,
+					      mlxsw_sp);
+	if (IS_ERR(metrics->counter_encap))
+		return PTR_ERR(metrics->counter_encap);
+
+	metrics->counter_decap =
+		devlink_metric_counter_create(devlink, "nve_vxlan_decap",
+					      &mlxsw_sp1_nve_vxlan_decap_ops,
+					      mlxsw_sp);
+	if (IS_ERR(metrics->counter_decap)) {
+		err = PTR_ERR(metrics->counter_decap);
+		goto err_counter_decap;
+	}
+
+	metrics->counter_decap_errors =
+		devlink_metric_counter_create(devlink, "nve_vxlan_decap_errors",
+					      &mlxsw_sp1_nve_vxlan_decap_errors_ops,
+					      mlxsw_sp);
+	if (IS_ERR(metrics->counter_decap_errors)) {
+		err = PTR_ERR(metrics->counter_decap_errors);
+		goto err_counter_decap_errors;
+	}
+
+	metrics->counter_decap_discards =
+		devlink_metric_counter_create(devlink, "nve_vxlan_decap_discards",
+					      &mlxsw_sp1_nve_vxlan_decap_discards_ops,
+					      mlxsw_sp);
+	if (IS_ERR(metrics->counter_decap_discards)) {
+		err = PTR_ERR(metrics->counter_decap_discards);
+		goto err_counter_decap_discards;
+	}
+
+	return 0;
+
+err_counter_decap_discards:
+	devlink_metric_destroy(devlink, metrics->counter_decap_errors);
+err_counter_decap_errors:
+	devlink_metric_destroy(devlink, metrics->counter_decap);
+err_counter_decap:
+	devlink_metric_destroy(devlink, metrics->counter_encap);
+	return err;
+}
+
+static void mlxsw_sp1_nve_vxlan_metrics_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_nve_metrics *metrics = &mlxsw_sp->nve->metrics;
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+
+	devlink_metric_destroy(devlink, metrics->counter_decap_discards);
+	devlink_metric_destroy(devlink, metrics->counter_decap_errors);
+	devlink_metric_destroy(devlink, metrics->counter_decap);
+	devlink_metric_destroy(devlink, metrics->counter_encap);
+}
+
 static int mlxsw_sp1_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 				    const struct mlxsw_sp_nve_config *config)
 {
@@ -238,6 +406,10 @@ static int mlxsw_sp1_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 	if (err)
 		goto err_rtdp_set;
 
+	err = mlxsw_sp1_nve_vxlan_metrics_init(mlxsw_sp);
+	if (err)
+		goto err_metrics_init;
+
 	err = mlxsw_sp_router_nve_promote_decap(mlxsw_sp, config->ul_tb_id,
 						config->ul_proto,
 						&config->ul_sip,
@@ -248,6 +420,8 @@ static int mlxsw_sp1_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 	return 0;
 
 err_promote_decap:
+	mlxsw_sp1_nve_vxlan_metrics_fini(mlxsw_sp);
+err_metrics_init:
 err_rtdp_set:
 	mlxsw_sp1_nve_vxlan_config_clear(mlxsw_sp);
 err_config_set:
@@ -262,6 +436,7 @@ static void mlxsw_sp1_nve_vxlan_fini(struct mlxsw_sp_nve *nve)
 
 	mlxsw_sp_router_nve_demote_decap(mlxsw_sp, config->ul_tb_id,
 					 config->ul_proto, &config->ul_sip);
+	mlxsw_sp1_nve_vxlan_metrics_fini(mlxsw_sp);
 	mlxsw_sp1_nve_vxlan_config_clear(mlxsw_sp);
 	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
 }
@@ -360,6 +535,109 @@ static int mlxsw_sp2_nve_vxlan_rtdp_set(struct mlxsw_sp *mlxsw_sp,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rtdp), rtdp_pl);
 }
 
+static int
+mlxsw_sp2_nve_vxlan_common_counter_get(struct devlink_metric *metric,
+				       char *tncr2_pl)
+{
+	struct mlxsw_sp *mlxsw_sp = devlink_metric_priv(metric);
+
+	mlxsw_reg_tncr2_pack(tncr2_pl, MLXSW_REG_TNCR2_TUNNEL_PORT_NVE, false);
+
+	return mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(tncr2), tncr2_pl);
+}
+
+static int
+mlxsw_sp2_nve_vxlan_decap_discards_counter_get(struct devlink_metric *metric,
+					       u64 *p_val)
+{
+	char tncr2_pl[MLXSW_REG_TNCR2_LEN];
+	int err;
+
+	err = mlxsw_sp2_nve_vxlan_common_counter_get(metric, tncr2_pl);
+	if (err)
+		return err;
+
+	*p_val = mlxsw_reg_tncr2_count_decap_discards_get(tncr2_pl);
+
+	return 0;
+}
+
+static const struct devlink_metric_ops mlxsw_sp2_nve_vxlan_decap_discards_ops = {
+	.counter_get = mlxsw_sp2_nve_vxlan_decap_discards_counter_get,
+};
+
+static int
+mlxsw_sp2_nve_vxlan_encap_discards_counter_get(struct devlink_metric *metric,
+					       u64 *p_val)
+{
+	char tncr2_pl[MLXSW_REG_TNCR2_LEN];
+	int err;
+
+	err = mlxsw_sp2_nve_vxlan_common_counter_get(metric, tncr2_pl);
+	if (err)
+		return err;
+
+	*p_val = mlxsw_reg_tncr2_count_encap_discards_get(tncr2_pl);
+
+	return 0;
+}
+
+static const struct devlink_metric_ops mlxsw_sp2_nve_vxlan_encap_discards_ops = {
+	.counter_get = mlxsw_sp2_nve_vxlan_encap_discards_counter_get,
+};
+
+static int mlxsw_sp2_nve_vxlan_counters_clear(struct mlxsw_sp *mlxsw_sp)
+{
+	char tncr2_pl[MLXSW_REG_TNCR2_LEN];
+
+	mlxsw_reg_tncr2_pack(tncr2_pl, MLXSW_REG_TNCR2_TUNNEL_PORT_NVE, true);
+
+	/* Clear operation is implemented on query. */
+	return mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(tncr2), tncr2_pl);
+}
+
+static int mlxsw_sp2_nve_vxlan_metrics_init(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_nve_metrics *metrics = &mlxsw_sp->nve->metrics;
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+	int err;
+
+	err = mlxsw_sp2_nve_vxlan_counters_clear(mlxsw_sp);
+	if (err)
+		return err;
+
+	metrics->counter_decap_discards =
+		devlink_metric_counter_create(devlink, "nve_vxlan_decap_discards",
+					      &mlxsw_sp2_nve_vxlan_decap_discards_ops,
+					      mlxsw_sp);
+	if (IS_ERR(metrics->counter_decap_discards))
+		return PTR_ERR(metrics->counter_decap_discards);
+
+	metrics->counter_encap_discards =
+		devlink_metric_counter_create(devlink, "nve_vxlan_encap_discards",
+					      &mlxsw_sp2_nve_vxlan_encap_discards_ops,
+					      mlxsw_sp);
+	if (IS_ERR(metrics->counter_encap_discards)) {
+		err = PTR_ERR(metrics->counter_encap_discards);
+		goto err_counter_encap_discards;
+	}
+
+	return 0;
+
+err_counter_encap_discards:
+	devlink_metric_destroy(devlink, metrics->counter_decap_discards);
+	return err;
+}
+
+static void mlxsw_sp2_nve_vxlan_metrics_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	struct mlxsw_sp_nve_metrics *metrics = &mlxsw_sp->nve->metrics;
+	struct devlink *devlink = priv_to_devlink(mlxsw_sp->core);
+
+	devlink_metric_destroy(devlink, metrics->counter_encap_discards);
+	devlink_metric_destroy(devlink, metrics->counter_decap_discards);
+}
+
 static int mlxsw_sp2_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 				    const struct mlxsw_sp_nve_config *config)
 {
@@ -379,6 +657,10 @@ static int mlxsw_sp2_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 	if (err)
 		goto err_rtdp_set;
 
+	err = mlxsw_sp2_nve_vxlan_metrics_init(mlxsw_sp);
+	if (err)
+		goto err_metrics_init;
+
 	err = mlxsw_sp_router_nve_promote_decap(mlxsw_sp, config->ul_tb_id,
 						config->ul_proto,
 						&config->ul_sip,
@@ -389,6 +671,8 @@ static int mlxsw_sp2_nve_vxlan_init(struct mlxsw_sp_nve *nve,
 	return 0;
 
 err_promote_decap:
+	mlxsw_sp2_nve_vxlan_metrics_fini(mlxsw_sp);
+err_metrics_init:
 err_rtdp_set:
 	mlxsw_sp2_nve_vxlan_config_clear(mlxsw_sp);
 err_config_set:
@@ -403,6 +687,7 @@ static void mlxsw_sp2_nve_vxlan_fini(struct mlxsw_sp_nve *nve)
 
 	mlxsw_sp_router_nve_demote_decap(mlxsw_sp, config->ul_tb_id,
 					 config->ul_proto, &config->ul_sip);
+	mlxsw_sp2_nve_vxlan_metrics_fini(mlxsw_sp);
 	mlxsw_sp2_nve_vxlan_config_clear(mlxsw_sp);
 	__mlxsw_sp_nve_inc_parsing_depth_put(mlxsw_sp, 0);
 }
-- 
2.26.2


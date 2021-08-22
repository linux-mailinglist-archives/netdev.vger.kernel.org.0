Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74F043F3F12
	for <lists+netdev@lfdr.de>; Sun, 22 Aug 2021 13:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233562AbhHVLjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Aug 2021 07:39:20 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:59575 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233189AbhHVLjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Aug 2021 07:39:11 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 1606B5C0039;
        Sun, 22 Aug 2021 07:38:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 22 Aug 2021 07:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Xz8uOoUuCWuHQpqqwhiKsXUKZw7tLN0KjR6+OIFLKhI=; b=I5cVLu0o
        ZNiYWs4YqsxS7BSB72otenZNEeZSecS5RwfKxI4lPQuITnGRjtThMqyjpn5mlVFw
        THiqiTVC7ligbEV32m0cT+QbLULjkQkPgWWZnmwLzQLAaXkESV/It5NYs9v2I4Wr
        UFLHBPiEwo4ffP5zHeFPNYLZ1yZCxrjMqWJ/nCfVXPoLbZXO/vwHIUgVDI0uzLxe
        VAI9R8ETwnheMn53JP/5CT9OPYmjW85aP60wljDDvJXVmkSCjuMD8sVnEBuseqq9
        5zs0NVr4RswYTtUQ+yowUZMfegzUs/JlPsMpOfZ/MBX+3MpHQqofQlBUR512YvtQ
        U/Dv5cyqx5XdYg==
X-ME-Sender: <xms:NTciYVUJDl1RXc3-rlx8fCtrOKfMgutBXnFP3MDX1WCTr7vJ6KR5NA>
    <xme:NTciYVlzrtOEUVGsmSlNpUMqlzmFdbGzZ5m-nasEXcA-oHYDI4hgp5WnFeQHAe0eO
    3_-x7UjsmdNfUA>
X-ME-Received: <xmr:NTciYRZrVVgzGww-JoHRYCyNaVjB4vkq_D3QKhqwi5m2RYIX8NYBNag4zKbVWUlVJ-XJoJZqwmpNHfbNhB8DeL4Y9ptwc--gF6vOU3JGgPjTTQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtfedggeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NTciYYXIv2uUifikskuta1hwiAPYTDiFweR2ZW_jJnQ8m5U61HW20g>
    <xmx:NTciYfmir5vPC7YBdMnGHR6H80Otsh3rlS1cdzYab7__1tH8eTI94Q>
    <xmx:NTciYVe2psL2kMW7aYVVSXF6AKpHqA_avu7MG1q9lNv32Z3cCxJw3g>
    <xmx:NjciYYDOLWSNgO9LrZntcu1QowGtSQvE1Rn2pLCreTkgd2QAomwRMg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 22 Aug 2021 07:38:27 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        amcohen@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/4] mlxsw: spectrum: Add infrastructure for parsing configuration
Date:   Sun, 22 Aug 2021 14:37:13 +0300
Message-Id: <20210822113716.1440716-2-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210822113716.1440716-1-idosch@idosch.org>
References: <20210822113716.1440716-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Spectrum ASICs have a configurable limit on how deep into the packet
they parse. By default, the limit is 96 bytes.

There are several cases where this parsing depth is not enough and there
is a need to increase it. Currently, increasing parsing depth is
maintained as part of VxLAN module, because the MPRS register which
configures parsing depth also configures UDP destination port number
used for VxLAN encapsulation and decapsulation.

Add an API for increasing parsing depth as part of spectrum.c code, so
that it will be possible to use it from other modules. In addition, add
an API for setting UDP destination port and protect it using a dedicated
lock for saving parsing configurations. The lock is needed as not all
the callers hold RTNL lock.

Maintain a counter for increased parsing depth consumers. For first
consumer subscription, increase the parsing depth and for last consumer
unsubscription, set parsing depth to default value.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 82 +++++++++++++++++++
 .../net/ethernet/mellanox/mlxsw/spectrum.h    | 12 +++
 2 files changed, 94 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 081408e892d5..250c5a24264d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2717,6 +2717,22 @@ mlxsw_sp_sample_trigger_params_unset(struct mlxsw_sp *mlxsw_sp,
 static int mlxsw_sp_netdevice_event(struct notifier_block *unused,
 				    unsigned long event, void *ptr);
 
+#define MLXSW_SP_DEFAULT_PARSING_DEPTH 96
+#define MLXSW_SP_INCREASED_PARSING_DEPTH 128
+#define MLXSW_SP_DEFAULT_VXLAN_UDP_DPORT 4789
+
+static void mlxsw_sp_parsing_init(struct mlxsw_sp *mlxsw_sp)
+{
+	mlxsw_sp->parsing.parsing_depth = MLXSW_SP_DEFAULT_PARSING_DEPTH;
+	mlxsw_sp->parsing.vxlan_udp_dport = MLXSW_SP_DEFAULT_VXLAN_UDP_DPORT;
+	mutex_init(&mlxsw_sp->parsing.lock);
+}
+
+static void mlxsw_sp_parsing_fini(struct mlxsw_sp *mlxsw_sp)
+{
+	mutex_destroy(&mlxsw_sp->parsing.lock);
+}
+
 static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 			 const struct mlxsw_bus_info *mlxsw_bus_info,
 			 struct netlink_ext_ack *extack)
@@ -2727,6 +2743,7 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp->core = mlxsw_core;
 	mlxsw_sp->bus_info = mlxsw_bus_info;
 
+	mlxsw_sp_parsing_init(mlxsw_sp);
 	mlxsw_core_emad_string_tlv_enable(mlxsw_core);
 
 	err = mlxsw_sp_base_mac_get(mlxsw_sp);
@@ -2926,6 +2943,7 @@ static int mlxsw_sp_init(struct mlxsw_core *mlxsw_core,
 	mlxsw_sp_fids_fini(mlxsw_sp);
 err_fids_init:
 	mlxsw_sp_kvdl_fini(mlxsw_sp);
+	mlxsw_sp_parsing_fini(mlxsw_sp);
 	return err;
 }
 
@@ -3046,6 +3064,7 @@ static void mlxsw_sp_fini(struct mlxsw_core *mlxsw_core)
 	mlxsw_sp_policers_fini(mlxsw_sp);
 	mlxsw_sp_fids_fini(mlxsw_sp);
 	mlxsw_sp_kvdl_fini(mlxsw_sp);
+	mlxsw_sp_parsing_fini(mlxsw_sp);
 }
 
 /* Per-FID flood tables are used for both "true" 802.1D FIDs and emulated
@@ -3611,6 +3630,69 @@ void mlxsw_sp_port_dev_put(struct mlxsw_sp_port *mlxsw_sp_port)
 	dev_put(mlxsw_sp_port->dev);
 }
 
+int mlxsw_sp_parsing_depth_inc(struct mlxsw_sp *mlxsw_sp)
+{
+	char mprs_pl[MLXSW_REG_MPRS_LEN];
+	int err = 0;
+
+	mutex_lock(&mlxsw_sp->parsing.lock);
+
+	if (refcount_inc_not_zero(&mlxsw_sp->parsing.parsing_depth_ref))
+		goto out_unlock;
+
+	mlxsw_reg_mprs_pack(mprs_pl, MLXSW_SP_INCREASED_PARSING_DEPTH,
+			    mlxsw_sp->parsing.vxlan_udp_dport);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mprs), mprs_pl);
+	if (err)
+		goto out_unlock;
+
+	mlxsw_sp->parsing.parsing_depth = MLXSW_SP_INCREASED_PARSING_DEPTH;
+	refcount_set(&mlxsw_sp->parsing.parsing_depth_ref, 1);
+
+out_unlock:
+	mutex_unlock(&mlxsw_sp->parsing.lock);
+	return err;
+}
+
+void mlxsw_sp_parsing_depth_dec(struct mlxsw_sp *mlxsw_sp)
+{
+	char mprs_pl[MLXSW_REG_MPRS_LEN];
+
+	mutex_lock(&mlxsw_sp->parsing.lock);
+
+	if (!refcount_dec_and_test(&mlxsw_sp->parsing.parsing_depth_ref))
+		goto out_unlock;
+
+	mlxsw_reg_mprs_pack(mprs_pl, MLXSW_SP_DEFAULT_PARSING_DEPTH,
+			    mlxsw_sp->parsing.vxlan_udp_dport);
+	mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mprs), mprs_pl);
+	mlxsw_sp->parsing.parsing_depth = MLXSW_SP_DEFAULT_PARSING_DEPTH;
+
+out_unlock:
+	mutex_unlock(&mlxsw_sp->parsing.lock);
+}
+
+int mlxsw_sp_parsing_vxlan_udp_dport_set(struct mlxsw_sp *mlxsw_sp,
+					 __be16 udp_dport)
+{
+	char mprs_pl[MLXSW_REG_MPRS_LEN];
+	int err;
+
+	mutex_lock(&mlxsw_sp->parsing.lock);
+
+	mlxsw_reg_mprs_pack(mprs_pl, mlxsw_sp->parsing.parsing_depth,
+			    be16_to_cpu(udp_dport));
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mprs), mprs_pl);
+	if (err)
+		goto out_unlock;
+
+	mlxsw_sp->parsing.vxlan_udp_dport = be16_to_cpu(udp_dport);
+
+out_unlock:
+	mutex_unlock(&mlxsw_sp->parsing.lock);
+	return err;
+}
+
 static void
 mlxsw_sp_port_lag_uppers_cleanup(struct mlxsw_sp_port *mlxsw_sp_port,
 				 struct net_device *lag_dev)
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index f99db88ee884..3a43cba6d23c 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -148,6 +148,13 @@ struct mlxsw_sp_port_mapping {
 	u8 lane;
 };
 
+struct mlxsw_sp_parsing {
+	refcount_t parsing_depth_ref;
+	u16 parsing_depth;
+	u16 vxlan_udp_dport;
+	struct mutex lock; /* Protects parsing configuration */
+};
+
 struct mlxsw_sp {
 	struct mlxsw_sp_port **ports;
 	struct mlxsw_core *core;
@@ -173,6 +180,7 @@ struct mlxsw_sp {
 	struct mlxsw_sp_counter_pool *counter_pool;
 	struct mlxsw_sp_span *span;
 	struct mlxsw_sp_trap *trap;
+	struct mlxsw_sp_parsing parsing;
 	const struct mlxsw_sp_switchdev_ops *switchdev_ops;
 	const struct mlxsw_sp_kvdl_ops *kvdl_ops;
 	const struct mlxsw_afa_ops *afa_ops;
@@ -652,6 +660,10 @@ struct mlxsw_sp_port *mlxsw_sp_port_dev_lower_find(struct net_device *dev);
 struct mlxsw_sp_port *mlxsw_sp_port_lower_dev_hold(struct net_device *dev);
 void mlxsw_sp_port_dev_put(struct mlxsw_sp_port *mlxsw_sp_port);
 struct mlxsw_sp_port *mlxsw_sp_port_dev_lower_find_rcu(struct net_device *dev);
+int mlxsw_sp_parsing_depth_inc(struct mlxsw_sp *mlxsw_sp);
+void mlxsw_sp_parsing_depth_dec(struct mlxsw_sp *mlxsw_sp);
+int mlxsw_sp_parsing_vxlan_udp_dport_set(struct mlxsw_sp *mlxsw_sp,
+					 __be16 udp_dport);
 
 /* spectrum_dcb.c */
 #ifdef CONFIG_MLXSW_SPECTRUM_DCB
-- 
2.31.1


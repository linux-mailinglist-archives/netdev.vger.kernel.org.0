Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8375020E09D
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 23:57:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388216AbgF2Ur6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 16:47:58 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:58021 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389708AbgF2Ur3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jun 2020 16:47:29 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id ADBD05800BF;
        Mon, 29 Jun 2020 16:47:24 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 29 Jun 2020 16:47:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=kclqT31+jNuj2KUe5sJNfksPGhS+pFbaGD6FiUWzJDs=; b=FxEGGM9P
        mHfT2CUUC8GUkrri9CqV9+PfAYW3+48Of0IA6kaJwBihK93wbLaP64qn1HClwUDE
        PV2YAdfxZifeJOg1+jOhmsAY75bpuoX1TBywaXIcD4yl4MRPinmTiUm+epDXtFFq
        aufDJ5ME7wm14bCJfzG7FrU02rG7TVeIgrUQp3JHAsyae6Xl8YVBme8X+yt0gUok
        qzEsNBhvZv9zW2yxjjkEoEQU9L+NDm0QmCsqPXEfY87q6QmZD4UgQoJXHKCRLRn8
        aLAz9YaA3j5qeEwSdGR2ZqIugXVpshZNRrNnUduXLIyAmeCdJ70BR4zdVZA5JUdM
        TdKqYHuTYD+sGw==
X-ME-Sender: <xms:XFP6XnF6aeX7ZKe4g0-DLgr0d8HkDI1iPyoFK91aeMuLf-NtCx57QA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudelledgkeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppedutdelrdeiiedrudelrddufeef
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:XFP6XkXEDJgYE7b5JprnjXFApxmkmXxI8FxvMG1lilaqMb_Nx1hU-Q>
    <xmx:XFP6XpLnwfICrXj8Yc5-UiWekGl2NTXooIVzlOuMf0Ls_ddCV8MMBw>
    <xmx:XFP6XlExGO6qTTwnGRaxYbScy06RCZgnsfNOPmwmANLMRCwTW_IxuQ>
    <xmx:XFP6XprY4QwUloCSTYkmaAkTVRt9mMyuZe3CrhRdaRCl8CIU2Lykjg>
Received: from shredder.mtl.com (bzq-109-66-19-133.red.bezeqint.net [109.66.19.133])
        by mail.messagingengine.com (Postfix) with ESMTPA id DCB1A328005A;
        Mon, 29 Jun 2020 16:47:20 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        petrm@mellanox.com, amitc@mellanox.com, mlxsw@mellanox.com,
        mkubecek@suse.cz, jacob.e.keller@intel.com, andrew@lunn.ch,
        f.fainelli@gmail.com, linux@rempel-privat.de,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 02/10] mlxsw: Move ethtool_ops to spectrum_ethtool.c
Date:   Mon, 29 Jun 2020 23:46:13 +0300
Message-Id: <20200629204621.377239-3-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200629204621.377239-1-idosch@idosch.org>
References: <20200629204621.377239-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amitc@mellanox.com>

Add spectrum_ethtool.c file for ethtool code.
Move ethtool_ops and the relevant code from spectrum.c to
spectrum_ethtool.c.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/Makefile  |   3 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 880 +-----------------
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |  43 +
 .../mellanox/mlxsw/spectrum_ethtool.c         | 841 +++++++++++++++++
 4 files changed, 892 insertions(+), 875 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c

diff --git a/drivers/net/ethernet/mellanox/mlxsw/Makefile b/drivers/net/ethernet/mellanox/mlxsw/Makefile
index 4aeabb35c943..3709983fbd77 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/Makefile
+++ b/drivers/net/ethernet/mellanox/mlxsw/Makefile
@@ -30,7 +30,8 @@ mlxsw_spectrum-objs		:= spectrum.o spectrum_buffers.o \
 				   spectrum_mr_tcam.o spectrum_mr.o \
 				   spectrum_qdisc.o spectrum_span.o \
 				   spectrum_nve.o spectrum_nve_vxlan.o \
-				   spectrum_dpipe.o spectrum_trap.o
+				   spectrum_dpipe.o spectrum_trap.o \
+				   spectrum_ethtool.o
 mlxsw_spectrum-$(CONFIG_MLXSW_SPECTRUM_DCB)	+= spectrum_dcb.o
 mlxsw_spectrum-$(CONFIG_PTP_1588_CLOCK)		+= spectrum_ptp.o
 obj-$(CONFIG_MLXSW_MINIMAL)	+= mlxsw_minimal.o
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index a5c5363915dc..d508edccc54b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -94,7 +94,6 @@ static const struct mlxsw_fw_rev mlxsw_sp3_fw_rev = {
 static const char mlxsw_sp1_driver_name[] = "mlxsw_spectrum";
 static const char mlxsw_sp2_driver_name[] = "mlxsw_spectrum2";
 static const char mlxsw_sp3_driver_name[] = "mlxsw_spectrum3";
-static const char mlxsw_sp_driver_version[] = "1.0";
 
 static const unsigned char mlxsw_sp1_mac_mask[ETH_ALEN] = {
 	0xff, 0xff, 0xff, 0xff, 0xfc, 0x00
@@ -176,39 +175,6 @@ struct mlxsw_sp_mlxfw_dev {
 	struct mlxsw_sp *mlxsw_sp;
 };
 
-struct mlxsw_sp_ptp_ops {
-	struct mlxsw_sp_ptp_clock *
-		(*clock_init)(struct mlxsw_sp *mlxsw_sp, struct device *dev);
-	void (*clock_fini)(struct mlxsw_sp_ptp_clock *clock);
-
-	struct mlxsw_sp_ptp_state *(*init)(struct mlxsw_sp *mlxsw_sp);
-	void (*fini)(struct mlxsw_sp_ptp_state *ptp_state);
-
-	/* Notify a driver that a packet that might be PTP was received. Driver
-	 * is responsible for freeing the passed-in SKB.
-	 */
-	void (*receive)(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			u8 local_port);
-
-	/* Notify a driver that a timestamped packet was transmitted. Driver
-	 * is responsible for freeing the passed-in SKB.
-	 */
-	void (*transmitted)(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
-			    u8 local_port);
-
-	int (*hwtstamp_get)(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct hwtstamp_config *config);
-	int (*hwtstamp_set)(struct mlxsw_sp_port *mlxsw_sp_port,
-			    struct hwtstamp_config *config);
-	void (*shaper_work)(struct work_struct *work);
-	int (*get_ts_info)(struct mlxsw_sp *mlxsw_sp,
-			   struct ethtool_ts_info *info);
-	int (*get_stats_count)(void);
-	void (*get_stats_strings)(u8 **p);
-	void (*get_stats)(struct mlxsw_sp_port *mlxsw_sp_port,
-			  u64 *data, int data_index);
-};
-
 struct mlxsw_sp_span_ops {
 	u32 (*buffsize_get)(int mtu, u32 speed);
 };
@@ -595,8 +561,8 @@ static int mlxsw_sp_base_mac_get(struct mlxsw_sp *mlxsw_sp)
 	return 0;
 }
 
-static int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
-					  bool is_up)
+int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				   bool is_up)
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
 	char paos_pl[MLXSW_REG_PAOS_LEN];
@@ -1010,8 +976,8 @@ int __mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port, int mtu,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(pbmc), pbmc_pl);
 }
 
-static int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				      int mtu, bool pause_en)
+int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       int mtu, bool pause_en)
 {
 	u8 def_prio_tc[IEEE_8021QAZ_MAX_TCS] = {0};
 	bool dcb_en = !!mlxsw_sp_port->dcb.ets;
@@ -1103,8 +1069,8 @@ static int mlxsw_sp_port_get_offload_stats(int attr_id, const struct net_device
 	return -EINVAL;
 }
 
-static int mlxsw_sp_port_get_stats_raw(struct net_device *dev, int grp,
-				       int prio, char *ppcnt_pl)
+int mlxsw_sp_port_get_stats_raw(struct net_device *dev, int grp,
+				int prio, char *ppcnt_pl)
 {
 	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
 	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
@@ -1562,635 +1528,6 @@ static const struct net_device_ops mlxsw_sp_port_netdev_ops = {
 	.ndo_do_ioctl		= mlxsw_sp_port_ioctl,
 };
 
-static void mlxsw_sp_port_get_drvinfo(struct net_device *dev,
-				      struct ethtool_drvinfo *drvinfo)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-
-	strlcpy(drvinfo->driver, mlxsw_sp->bus_info->device_kind,
-		sizeof(drvinfo->driver));
-	strlcpy(drvinfo->version, mlxsw_sp_driver_version,
-		sizeof(drvinfo->version));
-	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
-		 "%d.%d.%d",
-		 mlxsw_sp->bus_info->fw_rev.major,
-		 mlxsw_sp->bus_info->fw_rev.minor,
-		 mlxsw_sp->bus_info->fw_rev.subminor);
-	strlcpy(drvinfo->bus_info, mlxsw_sp->bus_info->device_name,
-		sizeof(drvinfo->bus_info));
-}
-
-static void mlxsw_sp_port_get_pauseparam(struct net_device *dev,
-					 struct ethtool_pauseparam *pause)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-
-	pause->rx_pause = mlxsw_sp_port->link.rx_pause;
-	pause->tx_pause = mlxsw_sp_port->link.tx_pause;
-}
-
-static int mlxsw_sp_port_pause_set(struct mlxsw_sp_port *mlxsw_sp_port,
-				   struct ethtool_pauseparam *pause)
-{
-	char pfcc_pl[MLXSW_REG_PFCC_LEN];
-
-	mlxsw_reg_pfcc_pack(pfcc_pl, mlxsw_sp_port->local_port);
-	mlxsw_reg_pfcc_pprx_set(pfcc_pl, pause->rx_pause);
-	mlxsw_reg_pfcc_pptx_set(pfcc_pl, pause->tx_pause);
-
-	return mlxsw_reg_write(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(pfcc),
-			       pfcc_pl);
-}
-
-static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
-					struct ethtool_pauseparam *pause)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	bool pause_en = pause->tx_pause || pause->rx_pause;
-	int err;
-
-	if (mlxsw_sp_port->dcb.pfc && mlxsw_sp_port->dcb.pfc->pfc_en) {
-		netdev_err(dev, "PFC already enabled on port\n");
-		return -EINVAL;
-	}
-
-	if (pause->autoneg) {
-		netdev_err(dev, "PAUSE frames autonegotiation isn't supported\n");
-		return -EINVAL;
-	}
-
-	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu, pause_en);
-	if (err) {
-		netdev_err(dev, "Failed to configure port's headroom\n");
-		return err;
-	}
-
-	err = mlxsw_sp_port_pause_set(mlxsw_sp_port, pause);
-	if (err) {
-		netdev_err(dev, "Failed to set PAUSE parameters\n");
-		goto err_port_pause_configure;
-	}
-
-	mlxsw_sp_port->link.rx_pause = pause->rx_pause;
-	mlxsw_sp_port->link.tx_pause = pause->tx_pause;
-
-	return 0;
-
-err_port_pause_configure:
-	pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
-	mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu, pause_en);
-	return err;
-}
-
-struct mlxsw_sp_port_hw_stats {
-	char str[ETH_GSTRING_LEN];
-	u64 (*getter)(const char *payload);
-	bool cells_bytes;
-};
-
-static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_stats[] = {
-	{
-		.str = "a_frames_transmitted_ok",
-		.getter = mlxsw_reg_ppcnt_a_frames_transmitted_ok_get,
-	},
-	{
-		.str = "a_frames_received_ok",
-		.getter = mlxsw_reg_ppcnt_a_frames_received_ok_get,
-	},
-	{
-		.str = "a_frame_check_sequence_errors",
-		.getter = mlxsw_reg_ppcnt_a_frame_check_sequence_errors_get,
-	},
-	{
-		.str = "a_alignment_errors",
-		.getter = mlxsw_reg_ppcnt_a_alignment_errors_get,
-	},
-	{
-		.str = "a_octets_transmitted_ok",
-		.getter = mlxsw_reg_ppcnt_a_octets_transmitted_ok_get,
-	},
-	{
-		.str = "a_octets_received_ok",
-		.getter = mlxsw_reg_ppcnt_a_octets_received_ok_get,
-	},
-	{
-		.str = "a_multicast_frames_xmitted_ok",
-		.getter = mlxsw_reg_ppcnt_a_multicast_frames_xmitted_ok_get,
-	},
-	{
-		.str = "a_broadcast_frames_xmitted_ok",
-		.getter = mlxsw_reg_ppcnt_a_broadcast_frames_xmitted_ok_get,
-	},
-	{
-		.str = "a_multicast_frames_received_ok",
-		.getter = mlxsw_reg_ppcnt_a_multicast_frames_received_ok_get,
-	},
-	{
-		.str = "a_broadcast_frames_received_ok",
-		.getter = mlxsw_reg_ppcnt_a_broadcast_frames_received_ok_get,
-	},
-	{
-		.str = "a_in_range_length_errors",
-		.getter = mlxsw_reg_ppcnt_a_in_range_length_errors_get,
-	},
-	{
-		.str = "a_out_of_range_length_field",
-		.getter = mlxsw_reg_ppcnt_a_out_of_range_length_field_get,
-	},
-	{
-		.str = "a_frame_too_long_errors",
-		.getter = mlxsw_reg_ppcnt_a_frame_too_long_errors_get,
-	},
-	{
-		.str = "a_symbol_error_during_carrier",
-		.getter = mlxsw_reg_ppcnt_a_symbol_error_during_carrier_get,
-	},
-	{
-		.str = "a_mac_control_frames_transmitted",
-		.getter = mlxsw_reg_ppcnt_a_mac_control_frames_transmitted_get,
-	},
-	{
-		.str = "a_mac_control_frames_received",
-		.getter = mlxsw_reg_ppcnt_a_mac_control_frames_received_get,
-	},
-	{
-		.str = "a_unsupported_opcodes_received",
-		.getter = mlxsw_reg_ppcnt_a_unsupported_opcodes_received_get,
-	},
-	{
-		.str = "a_pause_mac_ctrl_frames_received",
-		.getter = mlxsw_reg_ppcnt_a_pause_mac_ctrl_frames_received_get,
-	},
-	{
-		.str = "a_pause_mac_ctrl_frames_xmitted",
-		.getter = mlxsw_reg_ppcnt_a_pause_mac_ctrl_frames_transmitted_get,
-	},
-};
-
-#define MLXSW_SP_PORT_HW_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_hw_stats)
-
-static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_rfc_2863_stats[] = {
-	{
-		.str = "if_in_discards",
-		.getter = mlxsw_reg_ppcnt_if_in_discards_get,
-	},
-	{
-		.str = "if_out_discards",
-		.getter = mlxsw_reg_ppcnt_if_out_discards_get,
-	},
-	{
-		.str = "if_out_errors",
-		.getter = mlxsw_reg_ppcnt_if_out_errors_get,
-	},
-};
-
-#define MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN \
-	ARRAY_SIZE(mlxsw_sp_port_hw_rfc_2863_stats)
-
-static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_rfc_2819_stats[] = {
-	{
-		.str = "ether_stats_undersize_pkts",
-		.getter = mlxsw_reg_ppcnt_ether_stats_undersize_pkts_get,
-	},
-	{
-		.str = "ether_stats_oversize_pkts",
-		.getter = mlxsw_reg_ppcnt_ether_stats_oversize_pkts_get,
-	},
-	{
-		.str = "ether_stats_fragments",
-		.getter = mlxsw_reg_ppcnt_ether_stats_fragments_get,
-	},
-	{
-		.str = "ether_pkts64octets",
-		.getter = mlxsw_reg_ppcnt_ether_stats_pkts64octets_get,
-	},
-	{
-		.str = "ether_pkts65to127octets",
-		.getter = mlxsw_reg_ppcnt_ether_stats_pkts65to127octets_get,
-	},
-	{
-		.str = "ether_pkts128to255octets",
-		.getter = mlxsw_reg_ppcnt_ether_stats_pkts128to255octets_get,
-	},
-	{
-		.str = "ether_pkts256to511octets",
-		.getter = mlxsw_reg_ppcnt_ether_stats_pkts256to511octets_get,
-	},
-	{
-		.str = "ether_pkts512to1023octets",
-		.getter = mlxsw_reg_ppcnt_ether_stats_pkts512to1023octets_get,
-	},
-	{
-		.str = "ether_pkts1024to1518octets",
-		.getter = mlxsw_reg_ppcnt_ether_stats_pkts1024to1518octets_get,
-	},
-	{
-		.str = "ether_pkts1519to2047octets",
-		.getter = mlxsw_reg_ppcnt_ether_stats_pkts1519to2047octets_get,
-	},
-	{
-		.str = "ether_pkts2048to4095octets",
-		.getter = mlxsw_reg_ppcnt_ether_stats_pkts2048to4095octets_get,
-	},
-	{
-		.str = "ether_pkts4096to8191octets",
-		.getter = mlxsw_reg_ppcnt_ether_stats_pkts4096to8191octets_get,
-	},
-	{
-		.str = "ether_pkts8192to10239octets",
-		.getter = mlxsw_reg_ppcnt_ether_stats_pkts8192to10239octets_get,
-	},
-};
-
-#define MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN \
-	ARRAY_SIZE(mlxsw_sp_port_hw_rfc_2819_stats)
-
-static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_rfc_3635_stats[] = {
-	{
-		.str = "dot3stats_fcs_errors",
-		.getter = mlxsw_reg_ppcnt_dot3stats_fcs_errors_get,
-	},
-	{
-		.str = "dot3stats_symbol_errors",
-		.getter = mlxsw_reg_ppcnt_dot3stats_symbol_errors_get,
-	},
-	{
-		.str = "dot3control_in_unknown_opcodes",
-		.getter = mlxsw_reg_ppcnt_dot3control_in_unknown_opcodes_get,
-	},
-	{
-		.str = "dot3in_pause_frames",
-		.getter = mlxsw_reg_ppcnt_dot3in_pause_frames_get,
-	},
-};
-
-#define MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN \
-	ARRAY_SIZE(mlxsw_sp_port_hw_rfc_3635_stats)
-
-static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_ext_stats[] = {
-	{
-		.str = "ecn_marked",
-		.getter = mlxsw_reg_ppcnt_ecn_marked_get,
-	},
-};
-
-#define MLXSW_SP_PORT_HW_EXT_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_hw_ext_stats)
-
-static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_discard_stats[] = {
-	{
-		.str = "discard_ingress_general",
-		.getter = mlxsw_reg_ppcnt_ingress_general_get,
-	},
-	{
-		.str = "discard_ingress_policy_engine",
-		.getter = mlxsw_reg_ppcnt_ingress_policy_engine_get,
-	},
-	{
-		.str = "discard_ingress_vlan_membership",
-		.getter = mlxsw_reg_ppcnt_ingress_vlan_membership_get,
-	},
-	{
-		.str = "discard_ingress_tag_frame_type",
-		.getter = mlxsw_reg_ppcnt_ingress_tag_frame_type_get,
-	},
-	{
-		.str = "discard_egress_vlan_membership",
-		.getter = mlxsw_reg_ppcnt_egress_vlan_membership_get,
-	},
-	{
-		.str = "discard_loopback_filter",
-		.getter = mlxsw_reg_ppcnt_loopback_filter_get,
-	},
-	{
-		.str = "discard_egress_general",
-		.getter = mlxsw_reg_ppcnt_egress_general_get,
-	},
-	{
-		.str = "discard_egress_hoq",
-		.getter = mlxsw_reg_ppcnt_egress_hoq_get,
-	},
-	{
-		.str = "discard_egress_policy_engine",
-		.getter = mlxsw_reg_ppcnt_egress_policy_engine_get,
-	},
-	{
-		.str = "discard_ingress_tx_link_down",
-		.getter = mlxsw_reg_ppcnt_ingress_tx_link_down_get,
-	},
-	{
-		.str = "discard_egress_stp_filter",
-		.getter = mlxsw_reg_ppcnt_egress_stp_filter_get,
-	},
-	{
-		.str = "discard_egress_sll",
-		.getter = mlxsw_reg_ppcnt_egress_sll_get,
-	},
-};
-
-#define MLXSW_SP_PORT_HW_DISCARD_STATS_LEN \
-	ARRAY_SIZE(mlxsw_sp_port_hw_discard_stats)
-
-static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_prio_stats[] = {
-	{
-		.str = "rx_octets_prio",
-		.getter = mlxsw_reg_ppcnt_rx_octets_get,
-	},
-	{
-		.str = "rx_frames_prio",
-		.getter = mlxsw_reg_ppcnt_rx_frames_get,
-	},
-	{
-		.str = "tx_octets_prio",
-		.getter = mlxsw_reg_ppcnt_tx_octets_get,
-	},
-	{
-		.str = "tx_frames_prio",
-		.getter = mlxsw_reg_ppcnt_tx_frames_get,
-	},
-	{
-		.str = "rx_pause_prio",
-		.getter = mlxsw_reg_ppcnt_rx_pause_get,
-	},
-	{
-		.str = "rx_pause_duration_prio",
-		.getter = mlxsw_reg_ppcnt_rx_pause_duration_get,
-	},
-	{
-		.str = "tx_pause_prio",
-		.getter = mlxsw_reg_ppcnt_tx_pause_get,
-	},
-	{
-		.str = "tx_pause_duration_prio",
-		.getter = mlxsw_reg_ppcnt_tx_pause_duration_get,
-	},
-};
-
-#define MLXSW_SP_PORT_HW_PRIO_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_hw_prio_stats)
-
-static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_tc_stats[] = {
-	{
-		.str = "tc_transmit_queue_tc",
-		.getter = mlxsw_reg_ppcnt_tc_transmit_queue_get,
-		.cells_bytes = true,
-	},
-	{
-		.str = "tc_no_buffer_discard_uc_tc",
-		.getter = mlxsw_reg_ppcnt_tc_no_buffer_discard_uc_get,
-	},
-};
-
-#define MLXSW_SP_PORT_HW_TC_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_hw_tc_stats)
-
-#define MLXSW_SP_PORT_ETHTOOL_STATS_LEN (MLXSW_SP_PORT_HW_STATS_LEN + \
-					 MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN + \
-					 MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN + \
-					 MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN + \
-					 MLXSW_SP_PORT_HW_EXT_STATS_LEN + \
-					 MLXSW_SP_PORT_HW_DISCARD_STATS_LEN + \
-					 (MLXSW_SP_PORT_HW_PRIO_STATS_LEN * \
-					  IEEE_8021QAZ_MAX_TCS) + \
-					 (MLXSW_SP_PORT_HW_TC_STATS_LEN * \
-					  TC_MAX_QUEUE))
-
-static void mlxsw_sp_port_get_prio_strings(u8 **p, int prio)
-{
-	int i;
-
-	for (i = 0; i < MLXSW_SP_PORT_HW_PRIO_STATS_LEN; i++) {
-		snprintf(*p, ETH_GSTRING_LEN, "%.29s_%.1d",
-			 mlxsw_sp_port_hw_prio_stats[i].str, prio);
-		*p += ETH_GSTRING_LEN;
-	}
-}
-
-static void mlxsw_sp_port_get_tc_strings(u8 **p, int tc)
-{
-	int i;
-
-	for (i = 0; i < MLXSW_SP_PORT_HW_TC_STATS_LEN; i++) {
-		snprintf(*p, ETH_GSTRING_LEN, "%.29s_%.1d",
-			 mlxsw_sp_port_hw_tc_stats[i].str, tc);
-		*p += ETH_GSTRING_LEN;
-	}
-}
-
-static void mlxsw_sp_port_get_strings(struct net_device *dev,
-				      u32 stringset, u8 *data)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	u8 *p = data;
-	int i;
-
-	switch (stringset) {
-	case ETH_SS_STATS:
-		for (i = 0; i < MLXSW_SP_PORT_HW_STATS_LEN; i++) {
-			memcpy(p, mlxsw_sp_port_hw_stats[i].str,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-
-		for (i = 0; i < MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN; i++) {
-			memcpy(p, mlxsw_sp_port_hw_rfc_2863_stats[i].str,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-
-		for (i = 0; i < MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN; i++) {
-			memcpy(p, mlxsw_sp_port_hw_rfc_2819_stats[i].str,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-
-		for (i = 0; i < MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN; i++) {
-			memcpy(p, mlxsw_sp_port_hw_rfc_3635_stats[i].str,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-
-		for (i = 0; i < MLXSW_SP_PORT_HW_EXT_STATS_LEN; i++) {
-			memcpy(p, mlxsw_sp_port_hw_ext_stats[i].str,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-
-		for (i = 0; i < MLXSW_SP_PORT_HW_DISCARD_STATS_LEN; i++) {
-			memcpy(p, mlxsw_sp_port_hw_discard_stats[i].str,
-			       ETH_GSTRING_LEN);
-			p += ETH_GSTRING_LEN;
-		}
-
-		for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
-			mlxsw_sp_port_get_prio_strings(&p, i);
-
-		for (i = 0; i < TC_MAX_QUEUE; i++)
-			mlxsw_sp_port_get_tc_strings(&p, i);
-
-		mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_strings(&p);
-		break;
-	}
-}
-
-static int mlxsw_sp_port_set_phys_id(struct net_device *dev,
-				     enum ethtool_phys_id_state state)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	char mlcr_pl[MLXSW_REG_MLCR_LEN];
-	bool active;
-
-	switch (state) {
-	case ETHTOOL_ID_ACTIVE:
-		active = true;
-		break;
-	case ETHTOOL_ID_INACTIVE:
-		active = false;
-		break;
-	default:
-		return -EOPNOTSUPP;
-	}
-
-	mlxsw_reg_mlcr_pack(mlcr_pl, mlxsw_sp_port->local_port, active);
-	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mlcr), mlcr_pl);
-}
-
-static int
-mlxsw_sp_get_hw_stats_by_group(struct mlxsw_sp_port_hw_stats **p_hw_stats,
-			       int *p_len, enum mlxsw_reg_ppcnt_grp grp)
-{
-	switch (grp) {
-	case MLXSW_REG_PPCNT_IEEE_8023_CNT:
-		*p_hw_stats = mlxsw_sp_port_hw_stats;
-		*p_len = MLXSW_SP_PORT_HW_STATS_LEN;
-		break;
-	case MLXSW_REG_PPCNT_RFC_2863_CNT:
-		*p_hw_stats = mlxsw_sp_port_hw_rfc_2863_stats;
-		*p_len = MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN;
-		break;
-	case MLXSW_REG_PPCNT_RFC_2819_CNT:
-		*p_hw_stats = mlxsw_sp_port_hw_rfc_2819_stats;
-		*p_len = MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN;
-		break;
-	case MLXSW_REG_PPCNT_RFC_3635_CNT:
-		*p_hw_stats = mlxsw_sp_port_hw_rfc_3635_stats;
-		*p_len = MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN;
-		break;
-	case MLXSW_REG_PPCNT_EXT_CNT:
-		*p_hw_stats = mlxsw_sp_port_hw_ext_stats;
-		*p_len = MLXSW_SP_PORT_HW_EXT_STATS_LEN;
-		break;
-	case MLXSW_REG_PPCNT_DISCARD_CNT:
-		*p_hw_stats = mlxsw_sp_port_hw_discard_stats;
-		*p_len = MLXSW_SP_PORT_HW_DISCARD_STATS_LEN;
-		break;
-	case MLXSW_REG_PPCNT_PRIO_CNT:
-		*p_hw_stats = mlxsw_sp_port_hw_prio_stats;
-		*p_len = MLXSW_SP_PORT_HW_PRIO_STATS_LEN;
-		break;
-	case MLXSW_REG_PPCNT_TC_CNT:
-		*p_hw_stats = mlxsw_sp_port_hw_tc_stats;
-		*p_len = MLXSW_SP_PORT_HW_TC_STATS_LEN;
-		break;
-	default:
-		WARN_ON(1);
-		return -EOPNOTSUPP;
-	}
-	return 0;
-}
-
-static void __mlxsw_sp_port_get_stats(struct net_device *dev,
-				      enum mlxsw_reg_ppcnt_grp grp, int prio,
-				      u64 *data, int data_index)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	struct mlxsw_sp_port_hw_stats *hw_stats;
-	char ppcnt_pl[MLXSW_REG_PPCNT_LEN];
-	int i, len;
-	int err;
-
-	err = mlxsw_sp_get_hw_stats_by_group(&hw_stats, &len, grp);
-	if (err)
-		return;
-	mlxsw_sp_port_get_stats_raw(dev, grp, prio, ppcnt_pl);
-	for (i = 0; i < len; i++) {
-		data[data_index + i] = hw_stats[i].getter(ppcnt_pl);
-		if (!hw_stats[i].cells_bytes)
-			continue;
-		data[data_index + i] = mlxsw_sp_cells_bytes(mlxsw_sp,
-							    data[data_index + i]);
-	}
-}
-
-static void mlxsw_sp_port_get_stats(struct net_device *dev,
-				    struct ethtool_stats *stats, u64 *data)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	int i, data_index = 0;
-
-	/* IEEE 802.3 Counters */
-	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_IEEE_8023_CNT, 0,
-				  data, data_index);
-	data_index = MLXSW_SP_PORT_HW_STATS_LEN;
-
-	/* RFC 2863 Counters */
-	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_RFC_2863_CNT, 0,
-				  data, data_index);
-	data_index += MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN;
-
-	/* RFC 2819 Counters */
-	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_RFC_2819_CNT, 0,
-				  data, data_index);
-	data_index += MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN;
-
-	/* RFC 3635 Counters */
-	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_RFC_3635_CNT, 0,
-				  data, data_index);
-	data_index += MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN;
-
-	/* Extended Counters */
-	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_EXT_CNT, 0,
-				  data, data_index);
-	data_index += MLXSW_SP_PORT_HW_EXT_STATS_LEN;
-
-	/* Discard Counters */
-	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_DISCARD_CNT, 0,
-				  data, data_index);
-	data_index += MLXSW_SP_PORT_HW_DISCARD_STATS_LEN;
-
-	/* Per-Priority Counters */
-	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
-		__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_PRIO_CNT, i,
-					  data, data_index);
-		data_index += MLXSW_SP_PORT_HW_PRIO_STATS_LEN;
-	}
-
-	/* Per-TC Counters */
-	for (i = 0; i < TC_MAX_QUEUE; i++) {
-		__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_TC_CNT, i,
-					  data, data_index);
-		data_index += MLXSW_SP_PORT_HW_TC_STATS_LEN;
-	}
-
-	/* PTP counters */
-	mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats(mlxsw_sp_port,
-						    data, data_index);
-	data_index += mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_count();
-}
-
-static int mlxsw_sp_port_get_sset_count(struct net_device *dev, int sset)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-
-	switch (sset) {
-	case ETH_SS_STATS:
-		return MLXSW_SP_PORT_ETHTOOL_STATS_LEN +
-		       mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_count();
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
 struct mlxsw_sp1_port_link_mode {
 	enum ethtool_link_mode_bit_indices mask_ethtool;
 	u32 mask;
@@ -2851,211 +2188,6 @@ mlxsw_sp2_port_type_speed_ops = {
 	.reg_ptys_eth_unpack		= mlxsw_sp2_reg_ptys_eth_unpack,
 };
 
-static void
-mlxsw_sp_port_get_link_supported(struct mlxsw_sp *mlxsw_sp, u32 eth_proto_cap,
-				 u8 width, struct ethtool_link_ksettings *cmd)
-{
-	const struct mlxsw_sp_port_type_speed_ops *ops;
-
-	ops = mlxsw_sp->port_type_speed_ops;
-
-	ethtool_link_ksettings_add_link_mode(cmd, supported, Asym_Pause);
-	ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
-	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
-
-	ops->from_ptys_supported_port(mlxsw_sp, eth_proto_cap, cmd);
-	ops->from_ptys_link(mlxsw_sp, eth_proto_cap, width,
-			    cmd->link_modes.supported);
-}
-
-static void
-mlxsw_sp_port_get_link_advertise(struct mlxsw_sp *mlxsw_sp,
-				 u32 eth_proto_admin, bool autoneg, u8 width,
-				 struct ethtool_link_ksettings *cmd)
-{
-	const struct mlxsw_sp_port_type_speed_ops *ops;
-
-	ops = mlxsw_sp->port_type_speed_ops;
-
-	if (!autoneg)
-		return;
-
-	ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
-	ops->from_ptys_link(mlxsw_sp, eth_proto_admin, width,
-			    cmd->link_modes.advertising);
-}
-
-static u8
-mlxsw_sp_port_connector_port(enum mlxsw_reg_ptys_connector_type connector_type)
-{
-	switch (connector_type) {
-	case MLXSW_REG_PTYS_CONNECTOR_TYPE_UNKNOWN_OR_NO_CONNECTOR:
-		return PORT_OTHER;
-	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_NONE:
-		return PORT_NONE;
-	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_TP:
-		return PORT_TP;
-	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_AUI:
-		return PORT_AUI;
-	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_BNC:
-		return PORT_BNC;
-	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_MII:
-		return PORT_MII;
-	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_FIBRE:
-		return PORT_FIBRE;
-	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_DA:
-		return PORT_DA;
-	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_OTHER:
-		return PORT_OTHER;
-	default:
-		WARN_ON_ONCE(1);
-		return PORT_OTHER;
-	}
-}
-
-static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
-					    struct ethtool_link_ksettings *cmd)
-{
-	u32 eth_proto_cap, eth_proto_admin, eth_proto_oper;
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	const struct mlxsw_sp_port_type_speed_ops *ops;
-	char ptys_pl[MLXSW_REG_PTYS_LEN];
-	u8 connector_type;
-	bool autoneg;
-	int err;
-
-	ops = mlxsw_sp->port_type_speed_ops;
-
-	autoneg = mlxsw_sp_port->link.autoneg;
-	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
-			       0, false);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
-	if (err)
-		return err;
-	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap,
-				 &eth_proto_admin, &eth_proto_oper);
-
-	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap,
-					 mlxsw_sp_port->mapping.width, cmd);
-
-	mlxsw_sp_port_get_link_advertise(mlxsw_sp, eth_proto_admin, autoneg,
-					 mlxsw_sp_port->mapping.width, cmd);
-
-	cmd->base.autoneg = autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
-	connector_type = mlxsw_reg_ptys_connector_type_get(ptys_pl);
-	cmd->base.port = mlxsw_sp_port_connector_port(connector_type);
-	ops->from_ptys_speed_duplex(mlxsw_sp, netif_carrier_ok(dev),
-				    eth_proto_oper, cmd);
-
-	return 0;
-}
-
-static int
-mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
-				 const struct ethtool_link_ksettings *cmd)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	const struct mlxsw_sp_port_type_speed_ops *ops;
-	char ptys_pl[MLXSW_REG_PTYS_LEN];
-	u32 eth_proto_cap, eth_proto_new;
-	bool autoneg;
-	int err;
-
-	ops = mlxsw_sp->port_type_speed_ops;
-
-	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
-			       0, false);
-	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
-	if (err)
-		return err;
-	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap, NULL, NULL);
-
-	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
-	eth_proto_new = autoneg ?
-		ops->to_ptys_advert_link(mlxsw_sp, mlxsw_sp_port->mapping.width,
-					 cmd) :
-		ops->to_ptys_speed(mlxsw_sp, mlxsw_sp_port->mapping.width,
-				   cmd->base.speed);
-
-	eth_proto_new = eth_proto_new & eth_proto_cap;
-	if (!eth_proto_new) {
-		netdev_err(dev, "No supported speed requested\n");
-		return -EINVAL;
-	}
-
-	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
-			       eth_proto_new, autoneg);
-	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
-	if (err)
-		return err;
-
-	mlxsw_sp_port->link.autoneg = autoneg;
-
-	if (!netif_running(dev))
-		return 0;
-
-	mlxsw_sp_port_admin_status_set(mlxsw_sp_port, false);
-	mlxsw_sp_port_admin_status_set(mlxsw_sp_port, true);
-
-	return 0;
-}
-
-static int mlxsw_sp_get_module_info(struct net_device *netdev,
-				    struct ethtool_modinfo *modinfo)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	int err;
-
-	err = mlxsw_env_get_module_info(mlxsw_sp->core,
-					mlxsw_sp_port->mapping.module,
-					modinfo);
-
-	return err;
-}
-
-static int mlxsw_sp_get_module_eeprom(struct net_device *netdev,
-				      struct ethtool_eeprom *ee,
-				      u8 *data)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-	int err;
-
-	err = mlxsw_env_get_module_eeprom(netdev, mlxsw_sp->core,
-					  mlxsw_sp_port->mapping.module, ee,
-					  data);
-
-	return err;
-}
-
-static int
-mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
-{
-	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
-	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
-
-	return mlxsw_sp->ptp_ops->get_ts_info(mlxsw_sp, info);
-}
-
-static const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
-	.get_drvinfo		= mlxsw_sp_port_get_drvinfo,
-	.get_link		= ethtool_op_get_link,
-	.get_pauseparam		= mlxsw_sp_port_get_pauseparam,
-	.set_pauseparam		= mlxsw_sp_port_set_pauseparam,
-	.get_strings		= mlxsw_sp_port_get_strings,
-	.set_phys_id		= mlxsw_sp_port_set_phys_id,
-	.get_ethtool_stats	= mlxsw_sp_port_get_stats,
-	.get_sset_count		= mlxsw_sp_port_get_sset_count,
-	.get_link_ksettings	= mlxsw_sp_port_get_link_ksettings,
-	.set_link_ksettings	= mlxsw_sp_port_set_link_ksettings,
-	.get_module_info	= mlxsw_sp_get_module_info,
-	.get_module_eeprom	= mlxsw_sp_get_module_eeprom,
-	.get_ts_info		= mlxsw_sp_get_ts_info,
-};
-
 static int
 mlxsw_sp_port_speed_by_width_set(struct mlxsw_sp_port *mlxsw_sp_port)
 {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 3e794d58184b..e29678b65a8a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -178,6 +178,39 @@ struct mlxsw_sp {
 	u32 lowest_shaper_bs;
 };
 
+struct mlxsw_sp_ptp_ops {
+	struct mlxsw_sp_ptp_clock *
+		(*clock_init)(struct mlxsw_sp *mlxsw_sp, struct device *dev);
+	void (*clock_fini)(struct mlxsw_sp_ptp_clock *clock);
+
+	struct mlxsw_sp_ptp_state *(*init)(struct mlxsw_sp *mlxsw_sp);
+	void (*fini)(struct mlxsw_sp_ptp_state *ptp_state);
+
+	/* Notify a driver that a packet that might be PTP was received. Driver
+	 * is responsible for freeing the passed-in SKB.
+	 */
+	void (*receive)(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			u8 local_port);
+
+	/* Notify a driver that a timestamped packet was transmitted. Driver
+	 * is responsible for freeing the passed-in SKB.
+	 */
+	void (*transmitted)(struct mlxsw_sp *mlxsw_sp, struct sk_buff *skb,
+			    u8 local_port);
+
+	int (*hwtstamp_get)(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct hwtstamp_config *config);
+	int (*hwtstamp_set)(struct mlxsw_sp_port *mlxsw_sp_port,
+			    struct hwtstamp_config *config);
+	void (*shaper_work)(struct work_struct *work);
+	int (*get_ts_info)(struct mlxsw_sp *mlxsw_sp,
+			   struct ethtool_ts_info *info);
+	int (*get_stats_count)(void);
+	void (*get_stats_strings)(u8 **p);
+	void (*get_stats)(struct mlxsw_sp_port *mlxsw_sp_port,
+			  u64 *data, int data_index);
+};
+
 static inline struct mlxsw_sp_upper *
 mlxsw_sp_lag_get(struct mlxsw_sp *mlxsw_sp, u16 lag_id)
 {
@@ -393,6 +426,13 @@ enum mlxsw_sp_flood_type {
 	MLXSW_SP_FLOOD_TYPE_MC,
 };
 
+int mlxsw_sp_port_headroom_set(struct mlxsw_sp_port *mlxsw_sp_port,
+			       int mtu, bool pause_en);
+int mlxsw_sp_port_get_stats_raw(struct net_device *dev, int grp,
+				int prio, char *ppcnt_pl);
+int mlxsw_sp_port_admin_status_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				   bool is_up);
+
 /* spectrum_buffers.c */
 int mlxsw_sp_buffers_init(struct mlxsw_sp *mlxsw_sp);
 void mlxsw_sp_buffers_fini(struct mlxsw_sp *mlxsw_sp);
@@ -1126,4 +1166,7 @@ static inline struct net *mlxsw_sp_net(struct mlxsw_sp *mlxsw_sp)
 	return mlxsw_core_net(mlxsw_sp->core);
 }
 
+/* spectrum_ethtool.c */
+extern const struct ethtool_ops mlxsw_sp_port_ethtool_ops;
+
 #endif
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
new file mode 100644
index 000000000000..7c03c749b563
--- /dev/null
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -0,0 +1,841 @@
+// SPDX-License-Identifier: BSD-3-Clause OR GPL-2.0
+/* Copyright (c) 2020 Mellanox Technologies. All rights reserved */
+
+#include "reg.h"
+#include "spectrum.h"
+#include "core_env.h"
+
+static const char mlxsw_sp_driver_version[] = "1.0";
+
+static void mlxsw_sp_port_get_drvinfo(struct net_device *dev,
+				      struct ethtool_drvinfo *drvinfo)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+
+	strlcpy(drvinfo->driver, mlxsw_sp->bus_info->device_kind,
+		sizeof(drvinfo->driver));
+	strlcpy(drvinfo->version, mlxsw_sp_driver_version,
+		sizeof(drvinfo->version));
+	snprintf(drvinfo->fw_version, sizeof(drvinfo->fw_version),
+		 "%d.%d.%d",
+		 mlxsw_sp->bus_info->fw_rev.major,
+		 mlxsw_sp->bus_info->fw_rev.minor,
+		 mlxsw_sp->bus_info->fw_rev.subminor);
+	strlcpy(drvinfo->bus_info, mlxsw_sp->bus_info->device_name,
+		sizeof(drvinfo->bus_info));
+}
+
+static void mlxsw_sp_port_get_pauseparam(struct net_device *dev,
+					 struct ethtool_pauseparam *pause)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+
+	pause->rx_pause = mlxsw_sp_port->link.rx_pause;
+	pause->tx_pause = mlxsw_sp_port->link.tx_pause;
+}
+
+static int mlxsw_sp_port_pause_set(struct mlxsw_sp_port *mlxsw_sp_port,
+				   struct ethtool_pauseparam *pause)
+{
+	char pfcc_pl[MLXSW_REG_PFCC_LEN];
+
+	mlxsw_reg_pfcc_pack(pfcc_pl, mlxsw_sp_port->local_port);
+	mlxsw_reg_pfcc_pprx_set(pfcc_pl, pause->rx_pause);
+	mlxsw_reg_pfcc_pptx_set(pfcc_pl, pause->tx_pause);
+
+	return mlxsw_reg_write(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(pfcc),
+			       pfcc_pl);
+}
+
+static int mlxsw_sp_port_set_pauseparam(struct net_device *dev,
+					struct ethtool_pauseparam *pause)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	bool pause_en = pause->tx_pause || pause->rx_pause;
+	int err;
+
+	if (mlxsw_sp_port->dcb.pfc && mlxsw_sp_port->dcb.pfc->pfc_en) {
+		netdev_err(dev, "PFC already enabled on port\n");
+		return -EINVAL;
+	}
+
+	if (pause->autoneg) {
+		netdev_err(dev, "PAUSE frames autonegotiation isn't supported\n");
+		return -EINVAL;
+	}
+
+	err = mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu, pause_en);
+	if (err) {
+		netdev_err(dev, "Failed to configure port's headroom\n");
+		return err;
+	}
+
+	err = mlxsw_sp_port_pause_set(mlxsw_sp_port, pause);
+	if (err) {
+		netdev_err(dev, "Failed to set PAUSE parameters\n");
+		goto err_port_pause_configure;
+	}
+
+	mlxsw_sp_port->link.rx_pause = pause->rx_pause;
+	mlxsw_sp_port->link.tx_pause = pause->tx_pause;
+
+	return 0;
+
+err_port_pause_configure:
+	pause_en = mlxsw_sp_port_is_pause_en(mlxsw_sp_port);
+	mlxsw_sp_port_headroom_set(mlxsw_sp_port, dev->mtu, pause_en);
+	return err;
+}
+
+struct mlxsw_sp_port_hw_stats {
+	char str[ETH_GSTRING_LEN];
+	u64 (*getter)(const char *payload);
+	bool cells_bytes;
+};
+
+static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_stats[] = {
+	{
+		.str = "a_frames_transmitted_ok",
+		.getter = mlxsw_reg_ppcnt_a_frames_transmitted_ok_get,
+	},
+	{
+		.str = "a_frames_received_ok",
+		.getter = mlxsw_reg_ppcnt_a_frames_received_ok_get,
+	},
+	{
+		.str = "a_frame_check_sequence_errors",
+		.getter = mlxsw_reg_ppcnt_a_frame_check_sequence_errors_get,
+	},
+	{
+		.str = "a_alignment_errors",
+		.getter = mlxsw_reg_ppcnt_a_alignment_errors_get,
+	},
+	{
+		.str = "a_octets_transmitted_ok",
+		.getter = mlxsw_reg_ppcnt_a_octets_transmitted_ok_get,
+	},
+	{
+		.str = "a_octets_received_ok",
+		.getter = mlxsw_reg_ppcnt_a_octets_received_ok_get,
+	},
+	{
+		.str = "a_multicast_frames_xmitted_ok",
+		.getter = mlxsw_reg_ppcnt_a_multicast_frames_xmitted_ok_get,
+	},
+	{
+		.str = "a_broadcast_frames_xmitted_ok",
+		.getter = mlxsw_reg_ppcnt_a_broadcast_frames_xmitted_ok_get,
+	},
+	{
+		.str = "a_multicast_frames_received_ok",
+		.getter = mlxsw_reg_ppcnt_a_multicast_frames_received_ok_get,
+	},
+	{
+		.str = "a_broadcast_frames_received_ok",
+		.getter = mlxsw_reg_ppcnt_a_broadcast_frames_received_ok_get,
+	},
+	{
+		.str = "a_in_range_length_errors",
+		.getter = mlxsw_reg_ppcnt_a_in_range_length_errors_get,
+	},
+	{
+		.str = "a_out_of_range_length_field",
+		.getter = mlxsw_reg_ppcnt_a_out_of_range_length_field_get,
+	},
+	{
+		.str = "a_frame_too_long_errors",
+		.getter = mlxsw_reg_ppcnt_a_frame_too_long_errors_get,
+	},
+	{
+		.str = "a_symbol_error_during_carrier",
+		.getter = mlxsw_reg_ppcnt_a_symbol_error_during_carrier_get,
+	},
+	{
+		.str = "a_mac_control_frames_transmitted",
+		.getter = mlxsw_reg_ppcnt_a_mac_control_frames_transmitted_get,
+	},
+	{
+		.str = "a_mac_control_frames_received",
+		.getter = mlxsw_reg_ppcnt_a_mac_control_frames_received_get,
+	},
+	{
+		.str = "a_unsupported_opcodes_received",
+		.getter = mlxsw_reg_ppcnt_a_unsupported_opcodes_received_get,
+	},
+	{
+		.str = "a_pause_mac_ctrl_frames_received",
+		.getter = mlxsw_reg_ppcnt_a_pause_mac_ctrl_frames_received_get,
+	},
+	{
+		.str = "a_pause_mac_ctrl_frames_xmitted",
+		.getter = mlxsw_reg_ppcnt_a_pause_mac_ctrl_frames_transmitted_get,
+	},
+};
+
+#define MLXSW_SP_PORT_HW_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_hw_stats)
+
+static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_rfc_2863_stats[] = {
+	{
+		.str = "if_in_discards",
+		.getter = mlxsw_reg_ppcnt_if_in_discards_get,
+	},
+	{
+		.str = "if_out_discards",
+		.getter = mlxsw_reg_ppcnt_if_out_discards_get,
+	},
+	{
+		.str = "if_out_errors",
+		.getter = mlxsw_reg_ppcnt_if_out_errors_get,
+	},
+};
+
+#define MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN \
+	ARRAY_SIZE(mlxsw_sp_port_hw_rfc_2863_stats)
+
+static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_rfc_2819_stats[] = {
+	{
+		.str = "ether_stats_undersize_pkts",
+		.getter = mlxsw_reg_ppcnt_ether_stats_undersize_pkts_get,
+	},
+	{
+		.str = "ether_stats_oversize_pkts",
+		.getter = mlxsw_reg_ppcnt_ether_stats_oversize_pkts_get,
+	},
+	{
+		.str = "ether_stats_fragments",
+		.getter = mlxsw_reg_ppcnt_ether_stats_fragments_get,
+	},
+	{
+		.str = "ether_pkts64octets",
+		.getter = mlxsw_reg_ppcnt_ether_stats_pkts64octets_get,
+	},
+	{
+		.str = "ether_pkts65to127octets",
+		.getter = mlxsw_reg_ppcnt_ether_stats_pkts65to127octets_get,
+	},
+	{
+		.str = "ether_pkts128to255octets",
+		.getter = mlxsw_reg_ppcnt_ether_stats_pkts128to255octets_get,
+	},
+	{
+		.str = "ether_pkts256to511octets",
+		.getter = mlxsw_reg_ppcnt_ether_stats_pkts256to511octets_get,
+	},
+	{
+		.str = "ether_pkts512to1023octets",
+		.getter = mlxsw_reg_ppcnt_ether_stats_pkts512to1023octets_get,
+	},
+	{
+		.str = "ether_pkts1024to1518octets",
+		.getter = mlxsw_reg_ppcnt_ether_stats_pkts1024to1518octets_get,
+	},
+	{
+		.str = "ether_pkts1519to2047octets",
+		.getter = mlxsw_reg_ppcnt_ether_stats_pkts1519to2047octets_get,
+	},
+	{
+		.str = "ether_pkts2048to4095octets",
+		.getter = mlxsw_reg_ppcnt_ether_stats_pkts2048to4095octets_get,
+	},
+	{
+		.str = "ether_pkts4096to8191octets",
+		.getter = mlxsw_reg_ppcnt_ether_stats_pkts4096to8191octets_get,
+	},
+	{
+		.str = "ether_pkts8192to10239octets",
+		.getter = mlxsw_reg_ppcnt_ether_stats_pkts8192to10239octets_get,
+	},
+};
+
+#define MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN \
+	ARRAY_SIZE(mlxsw_sp_port_hw_rfc_2819_stats)
+
+static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_rfc_3635_stats[] = {
+	{
+		.str = "dot3stats_fcs_errors",
+		.getter = mlxsw_reg_ppcnt_dot3stats_fcs_errors_get,
+	},
+	{
+		.str = "dot3stats_symbol_errors",
+		.getter = mlxsw_reg_ppcnt_dot3stats_symbol_errors_get,
+	},
+	{
+		.str = "dot3control_in_unknown_opcodes",
+		.getter = mlxsw_reg_ppcnt_dot3control_in_unknown_opcodes_get,
+	},
+	{
+		.str = "dot3in_pause_frames",
+		.getter = mlxsw_reg_ppcnt_dot3in_pause_frames_get,
+	},
+};
+
+#define MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN \
+	ARRAY_SIZE(mlxsw_sp_port_hw_rfc_3635_stats)
+
+static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_ext_stats[] = {
+	{
+		.str = "ecn_marked",
+		.getter = mlxsw_reg_ppcnt_ecn_marked_get,
+	},
+};
+
+#define MLXSW_SP_PORT_HW_EXT_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_hw_ext_stats)
+
+static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_discard_stats[] = {
+	{
+		.str = "discard_ingress_general",
+		.getter = mlxsw_reg_ppcnt_ingress_general_get,
+	},
+	{
+		.str = "discard_ingress_policy_engine",
+		.getter = mlxsw_reg_ppcnt_ingress_policy_engine_get,
+	},
+	{
+		.str = "discard_ingress_vlan_membership",
+		.getter = mlxsw_reg_ppcnt_ingress_vlan_membership_get,
+	},
+	{
+		.str = "discard_ingress_tag_frame_type",
+		.getter = mlxsw_reg_ppcnt_ingress_tag_frame_type_get,
+	},
+	{
+		.str = "discard_egress_vlan_membership",
+		.getter = mlxsw_reg_ppcnt_egress_vlan_membership_get,
+	},
+	{
+		.str = "discard_loopback_filter",
+		.getter = mlxsw_reg_ppcnt_loopback_filter_get,
+	},
+	{
+		.str = "discard_egress_general",
+		.getter = mlxsw_reg_ppcnt_egress_general_get,
+	},
+	{
+		.str = "discard_egress_hoq",
+		.getter = mlxsw_reg_ppcnt_egress_hoq_get,
+	},
+	{
+		.str = "discard_egress_policy_engine",
+		.getter = mlxsw_reg_ppcnt_egress_policy_engine_get,
+	},
+	{
+		.str = "discard_ingress_tx_link_down",
+		.getter = mlxsw_reg_ppcnt_ingress_tx_link_down_get,
+	},
+	{
+		.str = "discard_egress_stp_filter",
+		.getter = mlxsw_reg_ppcnt_egress_stp_filter_get,
+	},
+	{
+		.str = "discard_egress_sll",
+		.getter = mlxsw_reg_ppcnt_egress_sll_get,
+	},
+};
+
+#define MLXSW_SP_PORT_HW_DISCARD_STATS_LEN \
+	ARRAY_SIZE(mlxsw_sp_port_hw_discard_stats)
+
+static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_prio_stats[] = {
+	{
+		.str = "rx_octets_prio",
+		.getter = mlxsw_reg_ppcnt_rx_octets_get,
+	},
+	{
+		.str = "rx_frames_prio",
+		.getter = mlxsw_reg_ppcnt_rx_frames_get,
+	},
+	{
+		.str = "tx_octets_prio",
+		.getter = mlxsw_reg_ppcnt_tx_octets_get,
+	},
+	{
+		.str = "tx_frames_prio",
+		.getter = mlxsw_reg_ppcnt_tx_frames_get,
+	},
+	{
+		.str = "rx_pause_prio",
+		.getter = mlxsw_reg_ppcnt_rx_pause_get,
+	},
+	{
+		.str = "rx_pause_duration_prio",
+		.getter = mlxsw_reg_ppcnt_rx_pause_duration_get,
+	},
+	{
+		.str = "tx_pause_prio",
+		.getter = mlxsw_reg_ppcnt_tx_pause_get,
+	},
+	{
+		.str = "tx_pause_duration_prio",
+		.getter = mlxsw_reg_ppcnt_tx_pause_duration_get,
+	},
+};
+
+#define MLXSW_SP_PORT_HW_PRIO_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_hw_prio_stats)
+
+static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_tc_stats[] = {
+	{
+		.str = "tc_transmit_queue_tc",
+		.getter = mlxsw_reg_ppcnt_tc_transmit_queue_get,
+		.cells_bytes = true,
+	},
+	{
+		.str = "tc_no_buffer_discard_uc_tc",
+		.getter = mlxsw_reg_ppcnt_tc_no_buffer_discard_uc_get,
+	},
+};
+
+#define MLXSW_SP_PORT_HW_TC_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_hw_tc_stats)
+
+#define MLXSW_SP_PORT_ETHTOOL_STATS_LEN (MLXSW_SP_PORT_HW_STATS_LEN + \
+					 MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN + \
+					 MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN + \
+					 MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN + \
+					 MLXSW_SP_PORT_HW_EXT_STATS_LEN + \
+					 MLXSW_SP_PORT_HW_DISCARD_STATS_LEN + \
+					 (MLXSW_SP_PORT_HW_PRIO_STATS_LEN * \
+					  IEEE_8021QAZ_MAX_TCS) + \
+					 (MLXSW_SP_PORT_HW_TC_STATS_LEN * \
+					  TC_MAX_QUEUE))
+
+static void mlxsw_sp_port_get_prio_strings(u8 **p, int prio)
+{
+	int i;
+
+	for (i = 0; i < MLXSW_SP_PORT_HW_PRIO_STATS_LEN; i++) {
+		snprintf(*p, ETH_GSTRING_LEN, "%.29s_%.1d",
+			 mlxsw_sp_port_hw_prio_stats[i].str, prio);
+		*p += ETH_GSTRING_LEN;
+	}
+}
+
+static void mlxsw_sp_port_get_tc_strings(u8 **p, int tc)
+{
+	int i;
+
+	for (i = 0; i < MLXSW_SP_PORT_HW_TC_STATS_LEN; i++) {
+		snprintf(*p, ETH_GSTRING_LEN, "%.29s_%.1d",
+			 mlxsw_sp_port_hw_tc_stats[i].str, tc);
+		*p += ETH_GSTRING_LEN;
+	}
+}
+
+static void mlxsw_sp_port_get_strings(struct net_device *dev,
+				      u32 stringset, u8 *data)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	u8 *p = data;
+	int i;
+
+	switch (stringset) {
+	case ETH_SS_STATS:
+		for (i = 0; i < MLXSW_SP_PORT_HW_STATS_LEN; i++) {
+			memcpy(p, mlxsw_sp_port_hw_stats[i].str,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN; i++) {
+			memcpy(p, mlxsw_sp_port_hw_rfc_2863_stats[i].str,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN; i++) {
+			memcpy(p, mlxsw_sp_port_hw_rfc_2819_stats[i].str,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN; i++) {
+			memcpy(p, mlxsw_sp_port_hw_rfc_3635_stats[i].str,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < MLXSW_SP_PORT_HW_EXT_STATS_LEN; i++) {
+			memcpy(p, mlxsw_sp_port_hw_ext_stats[i].str,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < MLXSW_SP_PORT_HW_DISCARD_STATS_LEN; i++) {
+			memcpy(p, mlxsw_sp_port_hw_discard_stats[i].str,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
+
+		for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++)
+			mlxsw_sp_port_get_prio_strings(&p, i);
+
+		for (i = 0; i < TC_MAX_QUEUE; i++)
+			mlxsw_sp_port_get_tc_strings(&p, i);
+
+		mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_strings(&p);
+		break;
+	}
+}
+
+static int mlxsw_sp_port_set_phys_id(struct net_device *dev,
+				     enum ethtool_phys_id_state state)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	char mlcr_pl[MLXSW_REG_MLCR_LEN];
+	bool active;
+
+	switch (state) {
+	case ETHTOOL_ID_ACTIVE:
+		active = true;
+		break;
+	case ETHTOOL_ID_INACTIVE:
+		active = false;
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	mlxsw_reg_mlcr_pack(mlcr_pl, mlxsw_sp_port->local_port, active);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(mlcr), mlcr_pl);
+}
+
+static int
+mlxsw_sp_get_hw_stats_by_group(struct mlxsw_sp_port_hw_stats **p_hw_stats,
+			       int *p_len, enum mlxsw_reg_ppcnt_grp grp)
+{
+	switch (grp) {
+	case MLXSW_REG_PPCNT_IEEE_8023_CNT:
+		*p_hw_stats = mlxsw_sp_port_hw_stats;
+		*p_len = MLXSW_SP_PORT_HW_STATS_LEN;
+		break;
+	case MLXSW_REG_PPCNT_RFC_2863_CNT:
+		*p_hw_stats = mlxsw_sp_port_hw_rfc_2863_stats;
+		*p_len = MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN;
+		break;
+	case MLXSW_REG_PPCNT_RFC_2819_CNT:
+		*p_hw_stats = mlxsw_sp_port_hw_rfc_2819_stats;
+		*p_len = MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN;
+		break;
+	case MLXSW_REG_PPCNT_RFC_3635_CNT:
+		*p_hw_stats = mlxsw_sp_port_hw_rfc_3635_stats;
+		*p_len = MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN;
+		break;
+	case MLXSW_REG_PPCNT_EXT_CNT:
+		*p_hw_stats = mlxsw_sp_port_hw_ext_stats;
+		*p_len = MLXSW_SP_PORT_HW_EXT_STATS_LEN;
+		break;
+	case MLXSW_REG_PPCNT_DISCARD_CNT:
+		*p_hw_stats = mlxsw_sp_port_hw_discard_stats;
+		*p_len = MLXSW_SP_PORT_HW_DISCARD_STATS_LEN;
+		break;
+	case MLXSW_REG_PPCNT_PRIO_CNT:
+		*p_hw_stats = mlxsw_sp_port_hw_prio_stats;
+		*p_len = MLXSW_SP_PORT_HW_PRIO_STATS_LEN;
+		break;
+	case MLXSW_REG_PPCNT_TC_CNT:
+		*p_hw_stats = mlxsw_sp_port_hw_tc_stats;
+		*p_len = MLXSW_SP_PORT_HW_TC_STATS_LEN;
+		break;
+	default:
+		WARN_ON(1);
+		return -EOPNOTSUPP;
+	}
+	return 0;
+}
+
+static void __mlxsw_sp_port_get_stats(struct net_device *dev,
+				      enum mlxsw_reg_ppcnt_grp grp, int prio,
+				      u64 *data, int data_index)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	struct mlxsw_sp_port_hw_stats *hw_stats;
+	char ppcnt_pl[MLXSW_REG_PPCNT_LEN];
+	int i, len;
+	int err;
+
+	err = mlxsw_sp_get_hw_stats_by_group(&hw_stats, &len, grp);
+	if (err)
+		return;
+	mlxsw_sp_port_get_stats_raw(dev, grp, prio, ppcnt_pl);
+	for (i = 0; i < len; i++) {
+		data[data_index + i] = hw_stats[i].getter(ppcnt_pl);
+		if (!hw_stats[i].cells_bytes)
+			continue;
+		data[data_index + i] = mlxsw_sp_cells_bytes(mlxsw_sp,
+							    data[data_index + i]);
+	}
+}
+
+static void mlxsw_sp_port_get_stats(struct net_device *dev,
+				    struct ethtool_stats *stats, u64 *data)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	int i, data_index = 0;
+
+	/* IEEE 802.3 Counters */
+	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_IEEE_8023_CNT, 0,
+				  data, data_index);
+	data_index = MLXSW_SP_PORT_HW_STATS_LEN;
+
+	/* RFC 2863 Counters */
+	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_RFC_2863_CNT, 0,
+				  data, data_index);
+	data_index += MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN;
+
+	/* RFC 2819 Counters */
+	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_RFC_2819_CNT, 0,
+				  data, data_index);
+	data_index += MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN;
+
+	/* RFC 3635 Counters */
+	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_RFC_3635_CNT, 0,
+				  data, data_index);
+	data_index += MLXSW_SP_PORT_HW_RFC_3635_STATS_LEN;
+
+	/* Extended Counters */
+	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_EXT_CNT, 0,
+				  data, data_index);
+	data_index += MLXSW_SP_PORT_HW_EXT_STATS_LEN;
+
+	/* Discard Counters */
+	__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_DISCARD_CNT, 0,
+				  data, data_index);
+	data_index += MLXSW_SP_PORT_HW_DISCARD_STATS_LEN;
+
+	/* Per-Priority Counters */
+	for (i = 0; i < IEEE_8021QAZ_MAX_TCS; i++) {
+		__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_PRIO_CNT, i,
+					  data, data_index);
+		data_index += MLXSW_SP_PORT_HW_PRIO_STATS_LEN;
+	}
+
+	/* Per-TC Counters */
+	for (i = 0; i < TC_MAX_QUEUE; i++) {
+		__mlxsw_sp_port_get_stats(dev, MLXSW_REG_PPCNT_TC_CNT, i,
+					  data, data_index);
+		data_index += MLXSW_SP_PORT_HW_TC_STATS_LEN;
+	}
+
+	/* PTP counters */
+	mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats(mlxsw_sp_port,
+						    data, data_index);
+	data_index += mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_count();
+}
+
+static int mlxsw_sp_port_get_sset_count(struct net_device *dev, int sset)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+
+	switch (sset) {
+	case ETH_SS_STATS:
+		return MLXSW_SP_PORT_ETHTOOL_STATS_LEN +
+			mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_count();
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void
+mlxsw_sp_port_get_link_supported(struct mlxsw_sp *mlxsw_sp, u32 eth_proto_cap,
+				 u8 width, struct ethtool_link_ksettings *cmd)
+{
+	const struct mlxsw_sp_port_type_speed_ops *ops;
+
+	ops = mlxsw_sp->port_type_speed_ops;
+
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Asym_Pause);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Autoneg);
+	ethtool_link_ksettings_add_link_mode(cmd, supported, Pause);
+
+	ops->from_ptys_supported_port(mlxsw_sp, eth_proto_cap, cmd);
+	ops->from_ptys_link(mlxsw_sp, eth_proto_cap, width,
+			    cmd->link_modes.supported);
+}
+
+static void
+mlxsw_sp_port_get_link_advertise(struct mlxsw_sp *mlxsw_sp,
+				 u32 eth_proto_admin, bool autoneg, u8 width,
+				 struct ethtool_link_ksettings *cmd)
+{
+	const struct mlxsw_sp_port_type_speed_ops *ops;
+
+	ops = mlxsw_sp->port_type_speed_ops;
+
+	if (!autoneg)
+		return;
+
+	ethtool_link_ksettings_add_link_mode(cmd, advertising, Autoneg);
+	ops->from_ptys_link(mlxsw_sp, eth_proto_admin, width,
+			    cmd->link_modes.advertising);
+}
+
+static u8
+mlxsw_sp_port_connector_port(enum mlxsw_reg_ptys_connector_type connector_type)
+{
+	switch (connector_type) {
+	case MLXSW_REG_PTYS_CONNECTOR_TYPE_UNKNOWN_OR_NO_CONNECTOR:
+		return PORT_OTHER;
+	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_NONE:
+		return PORT_NONE;
+	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_TP:
+		return PORT_TP;
+	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_AUI:
+		return PORT_AUI;
+	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_BNC:
+		return PORT_BNC;
+	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_MII:
+		return PORT_MII;
+	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_FIBRE:
+		return PORT_FIBRE;
+	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_DA:
+		return PORT_DA;
+	case MLXSW_REG_PTYS_CONNECTOR_TYPE_PORT_OTHER:
+		return PORT_OTHER;
+	default:
+		WARN_ON_ONCE(1);
+		return PORT_OTHER;
+	}
+}
+
+static int mlxsw_sp_port_get_link_ksettings(struct net_device *dev,
+					    struct ethtool_link_ksettings *cmd)
+{
+	u32 eth_proto_cap, eth_proto_admin, eth_proto_oper;
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	const struct mlxsw_sp_port_type_speed_ops *ops;
+	char ptys_pl[MLXSW_REG_PTYS_LEN];
+	u8 connector_type;
+	bool autoneg;
+	int err;
+
+	ops = mlxsw_sp->port_type_speed_ops;
+
+	autoneg = mlxsw_sp_port->link.autoneg;
+	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
+			       0, false);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
+	if (err)
+		return err;
+	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap,
+				 &eth_proto_admin, &eth_proto_oper);
+
+	mlxsw_sp_port_get_link_supported(mlxsw_sp, eth_proto_cap,
+					 mlxsw_sp_port->mapping.width, cmd);
+
+	mlxsw_sp_port_get_link_advertise(mlxsw_sp, eth_proto_admin, autoneg,
+					 mlxsw_sp_port->mapping.width, cmd);
+
+	cmd->base.autoneg = autoneg ? AUTONEG_ENABLE : AUTONEG_DISABLE;
+	connector_type = mlxsw_reg_ptys_connector_type_get(ptys_pl);
+	cmd->base.port = mlxsw_sp_port_connector_port(connector_type);
+	ops->from_ptys_speed_duplex(mlxsw_sp, netif_carrier_ok(dev),
+				    eth_proto_oper, cmd);
+
+	return 0;
+}
+
+static int
+mlxsw_sp_port_set_link_ksettings(struct net_device *dev,
+				 const struct ethtool_link_ksettings *cmd)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	const struct mlxsw_sp_port_type_speed_ops *ops;
+	char ptys_pl[MLXSW_REG_PTYS_LEN];
+	u32 eth_proto_cap, eth_proto_new;
+	bool autoneg;
+	int err;
+
+	ops = mlxsw_sp->port_type_speed_ops;
+
+	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
+			       0, false);
+	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
+	if (err)
+		return err;
+	ops->reg_ptys_eth_unpack(mlxsw_sp, ptys_pl, &eth_proto_cap, NULL, NULL);
+
+	autoneg = cmd->base.autoneg == AUTONEG_ENABLE;
+	eth_proto_new = autoneg ?
+		ops->to_ptys_advert_link(mlxsw_sp, mlxsw_sp_port->mapping.width,
+					 cmd) :
+		ops->to_ptys_speed(mlxsw_sp, mlxsw_sp_port->mapping.width,
+				   cmd->base.speed);
+
+	eth_proto_new = eth_proto_new & eth_proto_cap;
+	if (!eth_proto_new) {
+		netdev_err(dev, "No supported speed requested\n");
+		return -EINVAL;
+	}
+
+	ops->reg_ptys_eth_pack(mlxsw_sp, ptys_pl, mlxsw_sp_port->local_port,
+			       eth_proto_new, autoneg);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ptys), ptys_pl);
+	if (err)
+		return err;
+
+	mlxsw_sp_port->link.autoneg = autoneg;
+
+	if (!netif_running(dev))
+		return 0;
+
+	mlxsw_sp_port_admin_status_set(mlxsw_sp_port, false);
+	mlxsw_sp_port_admin_status_set(mlxsw_sp_port, true);
+
+	return 0;
+}
+
+static int mlxsw_sp_get_module_info(struct net_device *netdev,
+				    struct ethtool_modinfo *modinfo)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	int err;
+
+	err = mlxsw_env_get_module_info(mlxsw_sp->core,
+					mlxsw_sp_port->mapping.module,
+					modinfo);
+
+	return err;
+}
+
+static int mlxsw_sp_get_module_eeprom(struct net_device *netdev,
+				      struct ethtool_eeprom *ee, u8 *data)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+	int err;
+
+	err = mlxsw_env_get_module_eeprom(netdev, mlxsw_sp->core,
+					  mlxsw_sp_port->mapping.module, ee,
+					  data);
+
+	return err;
+}
+
+static int
+mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(netdev);
+	struct mlxsw_sp *mlxsw_sp = mlxsw_sp_port->mlxsw_sp;
+
+	return mlxsw_sp->ptp_ops->get_ts_info(mlxsw_sp, info);
+}
+
+const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
+	.get_drvinfo		= mlxsw_sp_port_get_drvinfo,
+	.get_link		= ethtool_op_get_link,
+	.get_pauseparam		= mlxsw_sp_port_get_pauseparam,
+	.set_pauseparam		= mlxsw_sp_port_set_pauseparam,
+	.get_strings		= mlxsw_sp_port_get_strings,
+	.set_phys_id		= mlxsw_sp_port_set_phys_id,
+	.get_ethtool_stats	= mlxsw_sp_port_get_stats,
+	.get_sset_count		= mlxsw_sp_port_get_sset_count,
+	.get_link_ksettings	= mlxsw_sp_port_get_link_ksettings,
+	.set_link_ksettings	= mlxsw_sp_port_set_link_ksettings,
+	.get_module_info	= mlxsw_sp_get_module_info,
+	.get_module_eeprom	= mlxsw_sp_get_module_eeprom,
+	.get_ts_info		= mlxsw_sp_get_ts_info,
+};
-- 
2.26.2


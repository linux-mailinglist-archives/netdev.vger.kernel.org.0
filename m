Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3885415E84
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241099AbhIWMkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:40:15 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59657 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241090AbhIWMkF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:40:05 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 70DAE5C0153;
        Thu, 23 Sep 2021 08:38:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 23 Sep 2021 08:38:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=k5ZNP7FJ1n2Ac89//0bUcDavnQ5QYoMac3yaiaQxScM=; b=Gv+AL51N
        ZbRPQQrYZJXiy63UhKxCWkBstbGoSWarynfr0u6LY4O023hkyiERceF+cv7/Uxo3
        Ys12/ZTqqfkiP03KiuFKC6yZY/Ase7JMyd0BSMkVAi31emIZhMgn/rLgeDZ2M1W4
        xb+M+4q08ibkUjArPNPgcv7oakyAniDgcqznngav6hp0p1XLcb8NqKlXxMRux31E
        TU7WmQ7VCZmayLpTCOPSzIGoNjCQOo3GkB/8ZaGiZNNLkgdp4A6OxENYiXJoVYc9
        gNY41Sy82oJqKl0HGZPygvsB1fD4k6gjiCcM6nIySAh6DQSOcvLBBVToQ5JdQzfl
        zC9hk+Idfdn5Hw==
X-ME-Sender: <xms:SXVMYX-wbQbKyo0-rxccpiLIZhVFuL93kPlFSw3Bf9VzwUtB9neU5w>
    <xme:SXVMYTtcUGjNMKUQ2TSV9AP2PcF-qs1GcSLjf1V4WMEWYltF_d3503YySUuIF0N9I
    acpIxC8DFdASD0>
X-ME-Received: <xmr:SXVMYVCf2MRa74CrlcjrFTRlfkeBo1UkNDYlJjsE3KJdo8WkPWw30MX2lpVP-sLIy8lJ0-wrcX7CFClZ0VbnsDSqJXHaHdUd9WBGul3GZN-9Eg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepgeenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:SXVMYTchAfJKetXzLC9YNvxKkvENRxjmRpwQLjOgE9i3nipd0cT1nA>
    <xmx:SXVMYcNSSptVh4ieypa1HN7enpgeLyvBdWGy7gZf9aef1GW38L13nA>
    <xmx:SXVMYVkLq8slwBOpltTKj4bmccJrOh6vB9vjZ_FRp_Y-77CNOoybfQ>
    <xmx:SXVMYb1804K8aUTQ9yB_WkXYgD_7sDCadkLabjxTf2hDsZgYNrxs5g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:31 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 14/14] mlxsw: Add support for IP-in-IP with IPv6 underlay for Spectrum-2 and above
Date:   Thu, 23 Sep 2021 15:37:00 +0300
Message-Id: <20210923123700.885466-15-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Currently, mlxsw driver supports IP-in-IP only with IPv4 underlay.
Add support for IPv6 underlay for Spectrum-2 and above.

Most of the configurations are same to IPv4, the main difference between
IPv4 and IPv6 is related to saving IP addresses.
IPv6 addresses are saved as part of KVD and the relevant registers hold
pointer to them.
Add API for that as part of ipip_ops, so then only Spectrum-2 and above
will save IPv6 addresses in this way.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 227 +++++++++++++++++-
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |   6 +
 .../ethernet/mellanox/mlxsw/spectrum_router.c |  86 ++++++-
 3 files changed, 309 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 37a1ad92ac91..ad3926de88f2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -29,23 +29,45 @@ static bool mlxsw_sp_ipip_parms4_has_ikey(const struct ip_tunnel_parm *parms)
 	return !!(parms->i_flags & TUNNEL_KEY);
 }
 
+static bool mlxsw_sp_ipip_parms6_has_ikey(const struct __ip6_tnl_parm *parms)
+{
+	return !!(parms->i_flags & TUNNEL_KEY);
+}
+
 static bool mlxsw_sp_ipip_parms4_has_okey(const struct ip_tunnel_parm *parms)
 {
 	return !!(parms->o_flags & TUNNEL_KEY);
 }
 
+static bool mlxsw_sp_ipip_parms6_has_okey(const struct __ip6_tnl_parm *parms)
+{
+	return !!(parms->o_flags & TUNNEL_KEY);
+}
+
 static u32 mlxsw_sp_ipip_parms4_ikey(const struct ip_tunnel_parm *parms)
 {
 	return mlxsw_sp_ipip_parms4_has_ikey(parms) ?
 		be32_to_cpu(parms->i_key) : 0;
 }
 
+static u32 mlxsw_sp_ipip_parms6_ikey(const struct __ip6_tnl_parm *parms)
+{
+	return mlxsw_sp_ipip_parms6_has_ikey(parms) ?
+		be32_to_cpu(parms->i_key) : 0;
+}
+
 static u32 mlxsw_sp_ipip_parms4_okey(const struct ip_tunnel_parm *parms)
 {
 	return mlxsw_sp_ipip_parms4_has_okey(parms) ?
 		be32_to_cpu(parms->o_key) : 0;
 }
 
+static u32 mlxsw_sp_ipip_parms6_okey(const struct __ip6_tnl_parm *parms)
+{
+	return mlxsw_sp_ipip_parms6_has_okey(parms) ?
+		be32_to_cpu(parms->o_key) : 0;
+}
+
 static union mlxsw_sp_l3addr
 mlxsw_sp_ipip_parms4_saddr(const struct ip_tunnel_parm *parms)
 {
@@ -313,6 +335,19 @@ mlxsw_sp_ipip_ol_netdev_change_gre4(struct mlxsw_sp *mlxsw_sp,
 						  &new_parms, extack);
 }
 
+static int
+mlxsw_sp_ipip_rem_addr_set_gre4(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_ipip_entry *ipip_entry)
+{
+	return 0;
+}
+
+static void
+mlxsw_sp_ipip_rem_addr_unset_gre4(struct mlxsw_sp *mlxsw_sp,
+				  const struct mlxsw_sp_ipip_entry *ipip_entry)
+{
+}
+
 static const struct mlxsw_sp_ipip_ops mlxsw_sp_ipip_gre4_ops = {
 	.dev_type = ARPHRD_IPGRE,
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV4,
@@ -323,6 +358,8 @@ static const struct mlxsw_sp_ipip_ops mlxsw_sp_ipip_gre4_ops = {
 	.can_offload = mlxsw_sp_ipip_can_offload_gre4,
 	.ol_loopback_config = mlxsw_sp_ipip_ol_loopback_config_gre4,
 	.ol_netdev_change = mlxsw_sp_ipip_ol_netdev_change_gre4,
+	.rem_ip_addr_set = mlxsw_sp_ipip_rem_addr_set_gre4,
+	.rem_ip_addr_unset = mlxsw_sp_ipip_rem_addr_unset_gre4,
 };
 
 static struct mlxsw_sp_ipip_parms
@@ -377,6 +414,21 @@ mlxsw_sp1_ipip_ol_netdev_change_gre6(struct mlxsw_sp *mlxsw_sp,
 	return -EINVAL;
 }
 
+static int
+mlxsw_sp1_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_ipip_entry *ipip_entry)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+
+static void
+mlxsw_sp1_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
+				   const struct mlxsw_sp_ipip_entry *ipip_entry)
+{
+	WARN_ON_ONCE(1);
+}
+
 static const struct mlxsw_sp_ipip_ops mlxsw_sp1_ipip_gre6_ops = {
 	.dev_type = ARPHRD_IP6GRE,
 	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
@@ -387,6 +439,8 @@ static const struct mlxsw_sp_ipip_ops mlxsw_sp1_ipip_gre6_ops = {
 	.can_offload = mlxsw_sp1_ipip_can_offload_gre6,
 	.ol_loopback_config = mlxsw_sp1_ipip_ol_loopback_config_gre6,
 	.ol_netdev_change = mlxsw_sp1_ipip_ol_netdev_change_gre6,
+	.rem_ip_addr_set = mlxsw_sp1_ipip_rem_addr_set_gre6,
+	.rem_ip_addr_unset = mlxsw_sp1_ipip_rem_addr_unset_gre6,
 };
 
 const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[] = {
@@ -394,9 +448,176 @@ const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[] = {
 	[MLXSW_SP_IPIP_TYPE_GRE6] = &mlxsw_sp1_ipip_gre6_ops,
 };
 
+static struct mlxsw_sp_ipip_parms
+mlxsw_sp2_ipip_netdev_parms_init_gre6(const struct net_device *ol_dev)
+{
+	struct __ip6_tnl_parm parms = mlxsw_sp_ipip_netdev_parms6(ol_dev);
+
+	return (struct mlxsw_sp_ipip_parms) {
+		.proto = MLXSW_SP_L3_PROTO_IPV6,
+		.saddr = mlxsw_sp_ipip_parms6_saddr(&parms),
+		.daddr = mlxsw_sp_ipip_parms6_daddr(&parms),
+		.link = parms.link,
+		.ikey = mlxsw_sp_ipip_parms6_ikey(&parms),
+		.okey = mlxsw_sp_ipip_parms6_okey(&parms),
+	};
+}
+
+static int
+mlxsw_sp2_ipip_nexthop_update_gre6(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
+				   struct mlxsw_sp_ipip_entry *ipip_entry,
+				   bool force, char *ratr_pl)
+{
+	u16 rif_index = mlxsw_sp_ipip_lb_rif_index(ipip_entry->ol_lb);
+	enum mlxsw_reg_ratr_op op;
+
+	op = force ? MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY :
+		     MLXSW_REG_RATR_OP_WRITE_WRITE_ENTRY_ON_ACTIVITY;
+	mlxsw_reg_ratr_pack(ratr_pl, op, true, MLXSW_REG_RATR_TYPE_IPIP,
+			    adj_index, rif_index);
+	mlxsw_reg_ratr_ipip6_entry_pack(ratr_pl,
+					ipip_entry->dip_kvdl_index);
+
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ratr), ratr_pl);
+}
+
+static int
+mlxsw_sp2_ipip_decap_config_gre6(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_ipip_entry *ipip_entry,
+				 u32 tunnel_index)
+{
+	u16 rif_index = mlxsw_sp_ipip_lb_rif_index(ipip_entry->ol_lb);
+	u16 ul_rif_id = mlxsw_sp_ipip_lb_ul_rif_id(ipip_entry->ol_lb);
+	char rtdp_pl[MLXSW_REG_RTDP_LEN];
+	struct __ip6_tnl_parm parms;
+	unsigned int type_check;
+	bool has_ikey;
+	u32 ikey;
+
+	parms = mlxsw_sp_ipip_netdev_parms6(ipip_entry->ol_dev);
+	has_ikey = mlxsw_sp_ipip_parms6_has_ikey(&parms);
+	ikey = mlxsw_sp_ipip_parms6_ikey(&parms);
+
+	mlxsw_reg_rtdp_pack(rtdp_pl, MLXSW_REG_RTDP_TYPE_IPIP, tunnel_index);
+	mlxsw_reg_rtdp_egress_router_interface_set(rtdp_pl, ul_rif_id);
+
+	type_check = has_ikey ?
+		MLXSW_REG_RTDP_IPIP_TYPE_CHECK_ALLOW_GRE_KEY :
+		MLXSW_REG_RTDP_IPIP_TYPE_CHECK_ALLOW_GRE;
+
+	/* Linux demuxes tunnels based on packet SIP (which must match tunnel
+	 * remote IP). Thus configure decap so that it filters out packets that
+	 * are not IPv6 or have the wrong SIP. IPIP_DECAP_ERROR trap is
+	 * generated for packets that fail this criterion. Linux then handles
+	 * such packets in slow path and generates ICMP destination unreachable.
+	 */
+	mlxsw_reg_rtdp_ipip6_pack(rtdp_pl, rif_index,
+				  MLXSW_REG_RTDP_IPIP_SIP_CHECK_FILTER_IPV6,
+				  type_check, has_ikey,
+				  ipip_entry->dip_kvdl_index, ikey);
+
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rtdp), rtdp_pl);
+}
+
+static bool mlxsw_sp2_ipip_can_offload_gre6(const struct mlxsw_sp *mlxsw_sp,
+					    const struct net_device *ol_dev)
+{
+	struct __ip6_tnl_parm tparm = mlxsw_sp_ipip_netdev_parms6(ol_dev);
+	bool inherit_tos = tparm.flags & IP6_TNL_F_USE_ORIG_TCLASS;
+	bool inherit_ttl = tparm.hop_limit == 0;
+	__be16 okflags = TUNNEL_KEY; /* We can't offload any other features. */
+
+	return (tparm.i_flags & ~okflags) == 0 &&
+	       (tparm.o_flags & ~okflags) == 0 &&
+	       inherit_ttl && inherit_tos &&
+	       mlxsw_sp_ipip_tunnel_complete(MLXSW_SP_L3_PROTO_IPV6, ol_dev);
+}
+
+static struct mlxsw_sp_rif_ipip_lb_config
+mlxsw_sp2_ipip_ol_loopback_config_gre6(struct mlxsw_sp *mlxsw_sp,
+				       const struct net_device *ol_dev)
+{
+	struct __ip6_tnl_parm parms = mlxsw_sp_ipip_netdev_parms6(ol_dev);
+	enum mlxsw_reg_ritr_loopback_ipip_type lb_ipipt;
+
+	lb_ipipt = mlxsw_sp_ipip_parms6_has_okey(&parms) ?
+		MLXSW_REG_RITR_LOOPBACK_IPIP_TYPE_IP_IN_GRE_KEY_IN_IP :
+		MLXSW_REG_RITR_LOOPBACK_IPIP_TYPE_IP_IN_GRE_IN_IP;
+	return (struct mlxsw_sp_rif_ipip_lb_config){
+		.lb_ipipt = lb_ipipt,
+		.okey = mlxsw_sp_ipip_parms6_okey(&parms),
+		.ul_protocol = MLXSW_SP_L3_PROTO_IPV6,
+		.saddr = mlxsw_sp_ipip_netdev_saddr(MLXSW_SP_L3_PROTO_IPV6,
+						    ol_dev),
+	};
+}
+
+static int
+mlxsw_sp2_ipip_ol_netdev_change_gre6(struct mlxsw_sp *mlxsw_sp,
+				     struct mlxsw_sp_ipip_entry *ipip_entry,
+				     struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_ipip_parms new_parms;
+
+	new_parms = mlxsw_sp2_ipip_netdev_parms_init_gre6(ipip_entry->ol_dev);
+	return mlxsw_sp_ipip_ol_netdev_change_gre(mlxsw_sp, ipip_entry,
+						  &new_parms, extack);
+}
+
+static int
+mlxsw_sp2_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_ipip_entry *ipip_entry)
+{
+	char rips_pl[MLXSW_REG_RIPS_LEN];
+	struct __ip6_tnl_parm parms6;
+	int err;
+
+	err = mlxsw_sp_kvdl_alloc(mlxsw_sp,
+				  MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS, 1,
+				  &ipip_entry->dip_kvdl_index);
+	if (err)
+		return err;
+
+	parms6 = mlxsw_sp_ipip_netdev_parms6(ipip_entry->ol_dev);
+	mlxsw_reg_rips_pack(rips_pl, ipip_entry->dip_kvdl_index,
+			    &parms6.raddr);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(rips), rips_pl);
+	if (err)
+		goto err_rips_write;
+
+	return 0;
+
+err_rips_write:
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS, 1,
+			   ipip_entry->dip_kvdl_index);
+	return err;
+}
+
+static void
+mlxsw_sp2_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
+				   const struct mlxsw_sp_ipip_entry *ipip_entry)
+{
+	mlxsw_sp_kvdl_free(mlxsw_sp, MLXSW_SP_KVDL_ENTRY_TYPE_IPV6_ADDRESS, 1,
+			   ipip_entry->dip_kvdl_index);
+}
+
+static const struct mlxsw_sp_ipip_ops mlxsw_sp2_ipip_gre6_ops = {
+	.dev_type = ARPHRD_IP6GRE,
+	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
+	.inc_parsing_depth = true,
+	.parms_init = mlxsw_sp2_ipip_netdev_parms_init_gre6,
+	.nexthop_update = mlxsw_sp2_ipip_nexthop_update_gre6,
+	.decap_config = mlxsw_sp2_ipip_decap_config_gre6,
+	.can_offload = mlxsw_sp2_ipip_can_offload_gre6,
+	.ol_loopback_config = mlxsw_sp2_ipip_ol_loopback_config_gre6,
+	.ol_netdev_change = mlxsw_sp2_ipip_ol_netdev_change_gre6,
+	.rem_ip_addr_set = mlxsw_sp2_ipip_rem_addr_set_gre6,
+	.rem_ip_addr_unset = mlxsw_sp2_ipip_rem_addr_unset_gre6,
+};
+
 const struct mlxsw_sp_ipip_ops *mlxsw_sp2_ipip_ops_arr[] = {
 	[MLXSW_SP_IPIP_TYPE_GRE4] = &mlxsw_sp_ipip_gre4_ops,
-	[MLXSW_SP_IPIP_TYPE_GRE6] = &mlxsw_sp1_ipip_gre6_ops,
+	[MLXSW_SP_IPIP_TYPE_GRE6] = &mlxsw_sp2_ipip_gre6_ops,
 };
 
 static int mlxsw_sp_ipip_ecn_encap_init_one(struct mlxsw_sp *mlxsw_sp,
@@ -461,11 +682,15 @@ mlxsw_sp_ipip_netdev_ul_dev_get(const struct net_device *ol_dev)
 {
 	struct net *net = dev_net(ol_dev);
 	struct ip_tunnel *tun4;
+	struct ip6_tnl *tun6;
 
 	switch (ol_dev->type) {
 	case ARPHRD_IPGRE:
 		tun4 = netdev_priv(ol_dev);
 		return dev_get_by_index_rcu(net, tun4->parms.link);
+	case ARPHRD_IP6GRE:
+		tun6 = netdev_priv(ol_dev);
+		return dev_get_by_index_rcu(net, tun6->parms.link);
 	default:
 		return NULL;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index 2444f09d3fb1..8cc259dcc8d0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -7,6 +7,7 @@
 #include "spectrum_router.h"
 #include <net/ip_fib.h>
 #include <linux/if_tunnel.h>
+#include <net/ip6_tunnel.h>
 
 struct ip_tunnel_parm
 mlxsw_sp_ipip_netdev_parms4(const struct net_device *ol_dev);
@@ -41,6 +42,7 @@ struct mlxsw_sp_ipip_entry {
 	struct mlxsw_sp_fib_entry *decap_fib_entry;
 	struct list_head ipip_list_node;
 	struct mlxsw_sp_ipip_parms parms;
+	u32 dip_kvdl_index;
 };
 
 struct mlxsw_sp_ipip_ops {
@@ -70,6 +72,10 @@ struct mlxsw_sp_ipip_ops {
 	int (*ol_netdev_change)(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_ipip_entry *ipip_entry,
 				struct netlink_ext_ack *extack);
+	int (*rem_ip_addr_set)(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_ipip_entry *ipip_entry);
+	void (*rem_ip_addr_unset)(struct mlxsw_sp *mlxsw_sp,
+				  const struct mlxsw_sp_ipip_entry *ipip_entry);
 };
 
 extern const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[];
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index ed3f308d69cd..1e141b5944cd 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1108,6 +1108,7 @@ mlxsw_sp_ipip_entry_alloc(struct mlxsw_sp *mlxsw_sp,
 	const struct mlxsw_sp_ipip_ops *ipip_ops;
 	struct mlxsw_sp_ipip_entry *ipip_entry;
 	struct mlxsw_sp_ipip_entry *ret = NULL;
+	int err;
 
 	ipip_ops = mlxsw_sp->router->ipip_ops_arr[ipipt];
 	ipip_entry = kzalloc(sizeof(*ipip_entry), GFP_KERNEL);
@@ -1124,16 +1125,29 @@ mlxsw_sp_ipip_entry_alloc(struct mlxsw_sp *mlxsw_sp,
 	ipip_entry->ipipt = ipipt;
 	ipip_entry->ol_dev = ol_dev;
 	ipip_entry->parms = ipip_ops->parms_init(ol_dev);
+
+	err = ipip_ops->rem_ip_addr_set(mlxsw_sp, ipip_entry);
+	if (err) {
+		ret = ERR_PTR(err);
+		goto err_rem_ip_addr_set;
+	}
+
 	return ipip_entry;
 
+err_rem_ip_addr_set:
+	mlxsw_sp_rif_destroy(&ipip_entry->ol_lb->common);
 err_ol_ipip_lb_create:
 	kfree(ipip_entry);
 	return ret;
 }
 
-static void
-mlxsw_sp_ipip_entry_dealloc(struct mlxsw_sp_ipip_entry *ipip_entry)
+static void mlxsw_sp_ipip_entry_dealloc(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_ipip_entry *ipip_entry)
 {
+	const struct mlxsw_sp_ipip_ops *ipip_ops =
+		mlxsw_sp->router->ipip_ops_arr[ipip_entry->ipipt];
+
+	ipip_ops->rem_ip_addr_unset(mlxsw_sp, ipip_entry);
 	mlxsw_sp_rif_destroy(&ipip_entry->ol_lb->common);
 	kfree(ipip_entry);
 }
@@ -1332,6 +1346,11 @@ mlxsw_sp_ipip_entry_find_decap(struct mlxsw_sp *mlxsw_sp,
 		saddr_len = 4;
 		saddr_prefix_len = 32;
 		break;
+	case MLXSW_SP_L3_PROTO_IPV6:
+		saddrp = &saddr.addr6;
+		saddr_len = 16;
+		saddr_prefix_len = 128;
+		break;
 	default:
 		WARN_ON(1);
 		return NULL;
@@ -1368,7 +1387,7 @@ mlxsw_sp_ipip_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 			    struct mlxsw_sp_ipip_entry *ipip_entry)
 {
 	list_del(&ipip_entry->ipip_list_node);
-	mlxsw_sp_ipip_entry_dealloc(ipip_entry);
+	mlxsw_sp_ipip_entry_dealloc(mlxsw_sp, ipip_entry);
 }
 
 static bool
@@ -1563,6 +1582,7 @@ mlxsw_sp_rif_ipip_lb_op(struct mlxsw_sp_rif_ipip_lb *lb_rif, u16 ul_vr_id,
 	struct mlxsw_sp_rif *rif = &lb_rif->common;
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	char ritr_pl[MLXSW_REG_RITR_LEN];
+	struct in6_addr *saddr6;
 	u32 saddr4;
 
 	ipip_options = MLXSW_REG_RITR_LOOPBACK_IPIP_OPTIONS_GRE_KEY_PRESET;
@@ -1578,7 +1598,14 @@ mlxsw_sp_rif_ipip_lb_op(struct mlxsw_sp_rif_ipip_lb *lb_rif, u16 ul_vr_id,
 		break;
 
 	case MLXSW_SP_L3_PROTO_IPV6:
-		return -EAFNOSUPPORT;
+		saddr6 = &lb_cf.saddr.addr6;
+		mlxsw_reg_ritr_pack(ritr_pl, enable, MLXSW_REG_RITR_LOOPBACK_IF,
+				    rif->rif_index, rif->vr_id, rif->dev->mtu);
+		mlxsw_reg_ritr_loopback_ipip6_pack(ritr_pl, lb_cf.lb_ipipt,
+						   ipip_options, ul_vr_id,
+						   ul_rif_id, saddr6,
+						   lb_cf.okey);
+		break;
 	}
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
@@ -6960,11 +6987,38 @@ mlxsw_sp_fib6_entry_nexthop_del(struct mlxsw_sp *mlxsw_sp,
 	mlxsw_sp_nexthop6_group_update(mlxsw_sp, op_ctx, fib6_entry);
 }
 
-static void mlxsw_sp_fib6_entry_type_set(struct mlxsw_sp *mlxsw_sp,
-					 struct mlxsw_sp_fib_entry *fib_entry,
-					 const struct fib6_info *rt)
+static int
+mlxsw_sp_fib6_entry_type_set_local(struct mlxsw_sp *mlxsw_sp,
+				   struct mlxsw_sp_fib_entry *fib_entry,
+				   const struct fib6_info *rt)
+{
+	struct mlxsw_sp_nexthop_group_info *nhgi = fib_entry->nh_group->nhgi;
+	union mlxsw_sp_l3addr dip = { .addr6 = rt->fib6_dst.addr };
+	int ifindex = nhgi->nexthops[0].ifindex;
+	struct mlxsw_sp_ipip_entry *ipip_entry;
+
+	fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_TRAP;
+	ipip_entry = mlxsw_sp_ipip_entry_find_by_decap(mlxsw_sp, ifindex,
+						       MLXSW_SP_L3_PROTO_IPV6,
+						       dip);
+
+	if (ipip_entry && ipip_entry->ol_dev->flags & IFF_UP) {
+		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_IPIP_DECAP;
+		return mlxsw_sp_fib_entry_decap_init(mlxsw_sp, fib_entry,
+						     ipip_entry);
+	}
+
+	return 0;
+}
+
+static int mlxsw_sp_fib6_entry_type_set(struct mlxsw_sp *mlxsw_sp,
+					struct mlxsw_sp_fib_entry *fib_entry,
+					const struct fib6_info *rt)
 {
-	if (rt->fib6_flags & (RTF_LOCAL | RTF_ANYCAST))
+	if (rt->fib6_flags & RTF_LOCAL)
+		return mlxsw_sp_fib6_entry_type_set_local(mlxsw_sp, fib_entry,
+							  rt);
+	if (rt->fib6_flags & RTF_ANYCAST)
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_TRAP;
 	else if (rt->fib6_type == RTN_BLACKHOLE)
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_BLACKHOLE;
@@ -6974,6 +7028,8 @@ static void mlxsw_sp_fib6_entry_type_set(struct mlxsw_sp *mlxsw_sp,
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_REMOTE;
 	else
 		fib_entry->type = MLXSW_SP_FIB_ENTRY_TYPE_LOCAL;
+
+	return 0;
 }
 
 static void
@@ -7031,12 +7087,16 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		goto err_nexthop_group_vr_link;
 
-	mlxsw_sp_fib6_entry_type_set(mlxsw_sp, fib_entry, rt_arr[0]);
+	err = mlxsw_sp_fib6_entry_type_set(mlxsw_sp, fib_entry, rt_arr[0]);
+	if (err)
+		goto err_fib6_entry_type_set;
 
 	fib_entry->fib_node = fib_node;
 
 	return fib6_entry;
 
+err_fib6_entry_type_set:
+	mlxsw_sp_nexthop_group_vr_unlink(fib_entry->nh_group, fib_node->fib);
 err_nexthop_group_vr_link:
 	mlxsw_sp_nexthop6_group_put(mlxsw_sp, fib_entry);
 err_nexthop6_group_get:
@@ -7055,11 +7115,19 @@ mlxsw_sp_fib6_entry_create(struct mlxsw_sp *mlxsw_sp,
 	return ERR_PTR(err);
 }
 
+static void
+mlxsw_sp_fib6_entry_type_unset(struct mlxsw_sp *mlxsw_sp,
+			       struct mlxsw_sp_fib6_entry *fib6_entry)
+{
+	mlxsw_sp_fib_entry_type_unset(mlxsw_sp, &fib6_entry->common);
+}
+
 static void mlxsw_sp_fib6_entry_destroy(struct mlxsw_sp *mlxsw_sp,
 					struct mlxsw_sp_fib6_entry *fib6_entry)
 {
 	struct mlxsw_sp_fib_node *fib_node = fib6_entry->common.fib_node;
 
+	mlxsw_sp_fib6_entry_type_unset(mlxsw_sp, fib6_entry);
 	mlxsw_sp_nexthop_group_vr_unlink(fib6_entry->common.nh_group,
 					 fib_node->fib);
 	mlxsw_sp_nexthop6_group_put(mlxsw_sp, &fib6_entry->common);
-- 
2.31.1


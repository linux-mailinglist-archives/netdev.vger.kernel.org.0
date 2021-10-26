Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB4D743AF47
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234845AbhJZJpa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:45:30 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:59391 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234508AbhJZJp3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:45:29 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 663E85C02B6;
        Tue, 26 Oct 2021 05:43:05 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Oct 2021 05:43:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=NdtCu+1s8BgGe0nRiB38voggtkgIuIDyXDSKyMTgBVg=; b=a2ibBVOT
        3sLrHfL4k+BhanC5xp3YpxviVgTikEeejt/6i1MX1Xe6TOV3YpU6f3O/g1+QHwba
        P7d8+H0hPU19y20S5Tnzege3aBlxK9MGZrlcOj0McKifo7ZK/zPyhSgY3RuImOHu
        L1xsAwamK0+GUlu7vhWQd5FddVMJcO4lNxi8IfD1Y0dT/h2DARWuar+L58p3GjYB
        8xwhvTZcYvUUc++ieMqUuZdv0Z/PcAa9RsJ+n8U3Reid/buThf8UPbS9+ZVUHMB/
        j6a1XF3Wq+bh1K8nPb2oCNFBiWn6BA0vr50Mmngb7+qj06SISo+SWaCW8hd2dfcb
        VUzwpOwACJdgqg==
X-ME-Sender: <xms:qc13YfvjXPzfXq90JHa5kOEmm2d3l6Xqd7ABrecrCBelnvRMANXPnw>
    <xme:qc13YQewugVykU2WuFmTRlw2PpCN1fEukvPGx520bZm5WRanA3HP65Lc74OXyOmn2
    cmbV5a_ooBiPxA>
X-ME-Received: <xmr:qc13YSyVd3p60MaleNUq4kIIe6ku4Dr8KqkSvL3gJgFMTCyNa9P3vdoKFBQq_SJ_ZQ9rQJq0ji9Gb0Vb-VB1mmwpazBXzWBdxywF6cLN77k>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefjedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:qc13YeN3Y4ZOZlLJFkqw9jjqBb_maxK_oPOGrve6_jHqFAioJvKpnw>
    <xmx:qc13Yf_BlzG5-XKVQdQVOlu2-nXaFUCOVfhuMyCflREWBHR0wE4h7g>
    <xmx:qc13YeVP4-9xmm1rKlPmTvacH-hRfQVhBtTG7Dgk00FmtIC6I6TMnw>
    <xmx:qc13YanTsWUy-ByEobFdjKM_xuYUDUlLXk-A1mqfMpD-c857135O5g>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 05:43:03 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/9] mlxsw: spectrum_router: Add RIF MAC profiles support
Date:   Tue, 26 Oct 2021 12:42:20 +0300
Message-Id: <20211026094225.1265320-5-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211026094225.1265320-1-idosch@idosch.org>
References: <20211026094225.1265320-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

Currently, mlxsw enforces that all the router interfaces (RIFs) have the
same MAC prefix.

Relax this limitation by using RIF MAC profiles. Each profile is
associated with a particular MAC prefix and multiple RIFs can use the
same profile. Therefore, the number of possible MAC prefixes is no
longer one, but the number of profiles supported by the device.

Store the profiles in an IDR and reference count them according to the
number of RIFs using them.

Associate a RIF with a profile when the RIF is created and remove the
association when the RIF is deleted.

Change the association following 'NETDEV_CHANGEADDR' events, except when
only one RIF is using the profile. In which case, change the MAC prefix
of the profile itself instead of associating the RIF with a new profile.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 316 +++++++++++++++---
 .../ethernet/mellanox/mlxsw/spectrum_router.h |   3 +
 2 files changed, 272 insertions(+), 47 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 6f2989a70cbb..f7b18192e2c7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -57,6 +57,7 @@ struct mlxsw_sp_rif {
 	unsigned char addr[ETH_ALEN];
 	int mtu;
 	u16 rif_index;
+	u8 mac_profile_id;
 	u16 vr_id;
 	const struct mlxsw_sp_rif_ops *ops;
 	struct mlxsw_sp *mlxsw_sp;
@@ -114,6 +115,12 @@ struct mlxsw_sp_rif_ops {
 	void (*fdb_del)(struct mlxsw_sp_rif *rif, const char *mac);
 };
 
+struct mlxsw_sp_rif_mac_profile {
+	unsigned char mac_prefix[ETH_ALEN];
+	refcount_t ref_count;
+	u8 id;
+};
+
 struct mlxsw_sp_router_ops {
 	int (*init)(struct mlxsw_sp *mlxsw_sp);
 	int (*ipips_init)(struct mlxsw_sp *mlxsw_sp);
@@ -8306,6 +8313,200 @@ static void mlxsw_sp_rif_subport_put(struct mlxsw_sp_rif *rif)
 	mlxsw_sp_rif_destroy(rif);
 }
 
+static int mlxsw_sp_rif_mac_profile_index_alloc(struct mlxsw_sp *mlxsw_sp,
+						struct mlxsw_sp_rif_mac_profile *profile,
+						struct netlink_ext_ack *extack)
+{
+	u8 max_rif_mac_profiles = mlxsw_sp->router->max_rif_mac_profile;
+	struct mlxsw_sp_router *router = mlxsw_sp->router;
+	int id;
+
+	id = idr_alloc(&router->rif_mac_profiles_idr, profile, 0,
+		       max_rif_mac_profiles, GFP_KERNEL);
+
+	if (id >= 0) {
+		profile->id = id;
+		return 0;
+	}
+
+	if (id == -ENOSPC)
+		NL_SET_ERR_MSG_MOD(extack,
+				   "Exceeded number of supported router interface MAC profiles");
+
+	return id;
+}
+
+static struct mlxsw_sp_rif_mac_profile *
+mlxsw_sp_rif_mac_profile_index_free(struct mlxsw_sp *mlxsw_sp, u8 mac_profile)
+{
+	struct mlxsw_sp_rif_mac_profile *profile;
+
+	profile = idr_remove(&mlxsw_sp->router->rif_mac_profiles_idr,
+			     mac_profile);
+	WARN_ON(!profile);
+	return profile;
+}
+
+static struct mlxsw_sp_rif_mac_profile *
+mlxsw_sp_rif_mac_profile_alloc(const char *mac)
+{
+	struct mlxsw_sp_rif_mac_profile *profile;
+
+	profile = kzalloc(sizeof(*profile), GFP_KERNEL);
+	if (!profile)
+		return NULL;
+
+	ether_addr_copy(profile->mac_prefix, mac);
+	refcount_set(&profile->ref_count, 1);
+	return profile;
+}
+
+static struct mlxsw_sp_rif_mac_profile *
+mlxsw_sp_rif_mac_profile_find(const struct mlxsw_sp *mlxsw_sp, const char *mac)
+{
+	struct mlxsw_sp_router *router = mlxsw_sp->router;
+	struct mlxsw_sp_rif_mac_profile *profile;
+	int id;
+
+	idr_for_each_entry(&router->rif_mac_profiles_idr, profile, id) {
+		if (!profile)
+			continue;
+
+		if (ether_addr_equal_masked(profile->mac_prefix, mac,
+					    mlxsw_sp->mac_mask))
+			return profile;
+	}
+
+	return NULL;
+}
+
+static u64 mlxsw_sp_rif_mac_profiles_occ_get(void *priv)
+{
+	const struct mlxsw_sp *mlxsw_sp = priv;
+
+	return atomic_read(&mlxsw_sp->router->rif_mac_profiles_count);
+}
+
+static struct mlxsw_sp_rif_mac_profile *
+mlxsw_sp_rif_mac_profile_create(struct mlxsw_sp *mlxsw_sp, const char *mac,
+				struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_rif_mac_profile *profile;
+	int err;
+
+	profile = mlxsw_sp_rif_mac_profile_alloc(mac);
+	if (!profile)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlxsw_sp_rif_mac_profile_index_alloc(mlxsw_sp, profile, extack);
+	if (err)
+		goto profile_index_alloc_err;
+
+	atomic_inc(&mlxsw_sp->router->rif_mac_profiles_count);
+	return profile;
+
+profile_index_alloc_err:
+	kfree(profile);
+	return ERR_PTR(err);
+}
+
+static void mlxsw_sp_rif_mac_profile_destroy(struct mlxsw_sp *mlxsw_sp,
+					     u8 mac_profile)
+{
+	struct mlxsw_sp_rif_mac_profile *profile;
+
+	atomic_dec(&mlxsw_sp->router->rif_mac_profiles_count);
+	profile = mlxsw_sp_rif_mac_profile_index_free(mlxsw_sp, mac_profile);
+	kfree(profile);
+}
+
+static int mlxsw_sp_rif_mac_profile_get(struct mlxsw_sp *mlxsw_sp,
+					const char *mac, u8 *p_mac_profile,
+					struct netlink_ext_ack *extack)
+{
+	struct mlxsw_sp_rif_mac_profile *profile;
+
+	profile = mlxsw_sp_rif_mac_profile_find(mlxsw_sp, mac);
+	if (profile) {
+		refcount_inc(&profile->ref_count);
+		goto out;
+	}
+
+	profile = mlxsw_sp_rif_mac_profile_create(mlxsw_sp, mac, extack);
+	if (IS_ERR(profile))
+		return PTR_ERR(profile);
+
+out:
+	*p_mac_profile = profile->id;
+	return 0;
+}
+
+static void mlxsw_sp_rif_mac_profile_put(struct mlxsw_sp *mlxsw_sp,
+					 u8 mac_profile)
+{
+	struct mlxsw_sp_rif_mac_profile *profile;
+
+	profile = idr_find(&mlxsw_sp->router->rif_mac_profiles_idr,
+			   mac_profile);
+	if (WARN_ON(!profile))
+		return;
+
+	if (!refcount_dec_and_test(&profile->ref_count))
+		return;
+
+	mlxsw_sp_rif_mac_profile_destroy(mlxsw_sp, mac_profile);
+}
+
+static bool mlxsw_sp_rif_mac_profile_is_shared(const struct mlxsw_sp_rif *rif)
+{
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+	struct mlxsw_sp_rif_mac_profile *profile;
+
+	profile = idr_find(&mlxsw_sp->router->rif_mac_profiles_idr,
+			   rif->mac_profile_id);
+	if (WARN_ON(!profile))
+		return false;
+
+	return refcount_read(&profile->ref_count) > 1;
+}
+
+static int mlxsw_sp_rif_mac_profile_edit(struct mlxsw_sp_rif *rif,
+					 const char *new_mac)
+{
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+	struct mlxsw_sp_rif_mac_profile *profile;
+
+	profile = idr_find(&mlxsw_sp->router->rif_mac_profiles_idr,
+			   rif->mac_profile_id);
+	if (WARN_ON(!profile))
+		return -EINVAL;
+
+	ether_addr_copy(profile->mac_prefix, new_mac);
+	return 0;
+}
+
+static int
+mlxsw_sp_rif_mac_profile_replace(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_rif *rif,
+				 const char *new_mac,
+				 struct netlink_ext_ack *extack)
+{
+	u8 mac_profile;
+	int err;
+
+	if (!mlxsw_sp_rif_mac_profile_is_shared(rif))
+		return mlxsw_sp_rif_mac_profile_edit(rif, new_mac);
+
+	err = mlxsw_sp_rif_mac_profile_get(mlxsw_sp, new_mac,
+					   &mac_profile, extack);
+	if (err)
+		return err;
+
+	mlxsw_sp_rif_mac_profile_put(mlxsw_sp, rif->mac_profile_id);
+	rif->mac_profile_id = mac_profile;
+	return 0;
+}
+
 static int
 __mlxsw_sp_port_vlan_router_join(struct mlxsw_sp_port_vlan *mlxsw_sp_port_vlan,
 				 struct net_device *l3_dev,
@@ -8654,36 +8855,6 @@ static int mlxsw_sp_inetaddr_macvlan_event(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
-static int mlxsw_sp_router_port_check_rif_addr(struct mlxsw_sp *mlxsw_sp,
-					       struct net_device *dev,
-					       const unsigned char *dev_addr,
-					       struct netlink_ext_ack *extack)
-{
-	struct mlxsw_sp_rif *rif;
-	int i;
-
-	/* A RIF is not created for macvlan netdevs. Their MAC is used to
-	 * populate the FDB
-	 */
-	if (netif_is_macvlan(dev) || netif_is_l3_master(dev))
-		return 0;
-
-	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++) {
-		rif = mlxsw_sp->router->rifs[i];
-		if (rif && rif->ops &&
-		    rif->ops->type == MLXSW_SP_RIF_TYPE_IPIP_LB)
-			continue;
-		if (rif && rif->dev && rif->dev != dev &&
-		    !ether_addr_equal_masked(rif->dev->dev_addr, dev_addr,
-					     mlxsw_sp->mac_mask)) {
-			NL_SET_ERR_MSG_MOD(extack, "All router interface MAC addresses must have the same prefix");
-			return -EINVAL;
-		}
-	}
-
-	return 0;
-}
-
 static int __mlxsw_sp_inetaddr_event(struct mlxsw_sp *mlxsw_sp,
 				     struct net_device *dev,
 				     unsigned long event,
@@ -8749,11 +8920,6 @@ int mlxsw_sp_inetaddr_valid_event(struct notifier_block *unused,
 	if (!mlxsw_sp_rif_should_config(rif, dev, event))
 		goto out;
 
-	err = mlxsw_sp_router_port_check_rif_addr(mlxsw_sp, dev, dev->dev_addr,
-						  ivi->extack);
-	if (err)
-		goto out;
-
 	err = __mlxsw_sp_inetaddr_event(mlxsw_sp, dev, event, ivi->extack);
 out:
 	mutex_unlock(&mlxsw_sp->router->lock);
@@ -8837,11 +9003,6 @@ int mlxsw_sp_inet6addr_valid_event(struct notifier_block *unused,
 	if (!mlxsw_sp_rif_should_config(rif, dev, event))
 		goto out;
 
-	err = mlxsw_sp_router_port_check_rif_addr(mlxsw_sp, dev, dev->dev_addr,
-						  i6vi->extack);
-	if (err)
-		goto out;
-
 	err = __mlxsw_sp_inetaddr_event(mlxsw_sp, dev, event, i6vi->extack);
 out:
 	mutex_unlock(&mlxsw_sp->router->lock);
@@ -8849,7 +9010,7 @@ int mlxsw_sp_inet6addr_valid_event(struct notifier_block *unused,
 }
 
 static int mlxsw_sp_rif_edit(struct mlxsw_sp *mlxsw_sp, u16 rif_index,
-			     const char *mac, int mtu)
+			     const char *mac, int mtu, u8 mac_profile)
 {
 	char ritr_pl[MLXSW_REG_RITR_LEN];
 	int err;
@@ -8861,6 +9022,7 @@ static int mlxsw_sp_rif_edit(struct mlxsw_sp *mlxsw_sp, u16 rif_index,
 
 	mlxsw_reg_ritr_mtu_set(ritr_pl, mtu);
 	mlxsw_reg_ritr_if_mac_memcpy_to(ritr_pl, mac);
+	mlxsw_reg_ritr_if_mac_profile_id_set(ritr_pl, mac_profile);
 	mlxsw_reg_ritr_op_set(ritr_pl, MLXSW_REG_RITR_RIF_CREATE);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
 }
@@ -8871,6 +9033,7 @@ mlxsw_sp_router_port_change_event(struct mlxsw_sp *mlxsw_sp,
 				  struct netlink_ext_ack *extack)
 {
 	struct net_device *dev = rif->dev;
+	u8 old_mac_profile;
 	u16 fid_index;
 	int err;
 
@@ -8880,8 +9043,14 @@ mlxsw_sp_router_port_change_event(struct mlxsw_sp *mlxsw_sp,
 	if (err)
 		return err;
 
+	old_mac_profile = rif->mac_profile_id;
+	err = mlxsw_sp_rif_mac_profile_replace(mlxsw_sp, rif, dev->dev_addr,
+					       extack);
+	if (err)
+		goto err_rif_mac_profile_replace;
+
 	err = mlxsw_sp_rif_edit(mlxsw_sp, rif->rif_index, dev->dev_addr,
-				dev->mtu);
+				dev->mtu, rif->mac_profile_id);
 	if (err)
 		goto err_rif_edit;
 
@@ -8911,8 +9080,11 @@ mlxsw_sp_router_port_change_event(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 
 err_rif_fdb_op:
-	mlxsw_sp_rif_edit(mlxsw_sp, rif->rif_index, rif->addr, rif->mtu);
+	mlxsw_sp_rif_edit(mlxsw_sp, rif->rif_index, rif->addr, rif->mtu,
+			  old_mac_profile);
 err_rif_edit:
+	mlxsw_sp_rif_mac_profile_replace(mlxsw_sp, rif, rif->addr, extack);
+err_rif_mac_profile_replace:
 	mlxsw_sp_rif_fdb_op(mlxsw_sp, rif->addr, fid_index, true);
 	return err;
 }
@@ -8920,11 +9092,28 @@ mlxsw_sp_router_port_change_event(struct mlxsw_sp *mlxsw_sp,
 static int mlxsw_sp_router_port_pre_changeaddr_event(struct mlxsw_sp_rif *rif,
 			    struct netdev_notifier_pre_changeaddr_info *info)
 {
+	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
+	struct mlxsw_sp_rif_mac_profile *profile;
 	struct netlink_ext_ack *extack;
+	u8 max_rif_mac_profiles;
+	u64 occ;
 
 	extack = netdev_notifier_info_to_extack(&info->info);
-	return mlxsw_sp_router_port_check_rif_addr(rif->mlxsw_sp, rif->dev,
-						   info->dev_addr, extack);
+
+	profile = mlxsw_sp_rif_mac_profile_find(mlxsw_sp, info->dev_addr);
+	if (profile)
+		return 0;
+
+	max_rif_mac_profiles = mlxsw_sp->router->max_rif_mac_profile;
+	occ = mlxsw_sp_rif_mac_profiles_occ_get(mlxsw_sp);
+	if (occ < max_rif_mac_profiles)
+		return 0;
+
+	if (!mlxsw_sp_rif_mac_profile_is_shared(rif))
+		return 0;
+
+	NL_SET_ERR_MSG_MOD(extack, "Exceeded number of supported router interface MAC profiles");
+	return -ENOBUFS;
 }
 
 int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
@@ -9070,6 +9259,7 @@ static int mlxsw_sp_rif_subport_op(struct mlxsw_sp_rif *rif, bool enable)
 	mlxsw_reg_ritr_pack(ritr_pl, enable, MLXSW_REG_RITR_SP_IF,
 			    rif->rif_index, rif->vr_id, rif->dev->mtu);
 	mlxsw_reg_ritr_mac_pack(ritr_pl, rif->dev->dev_addr);
+	mlxsw_reg_ritr_if_mac_profile_id_set(ritr_pl, rif->mac_profile_id);
 	mlxsw_reg_ritr_sp_if_pack(ritr_pl, rif_subport->lag,
 				  rif_subport->lag ? rif_subport->lag_id :
 						     rif_subport->system_port,
@@ -9081,11 +9271,18 @@ static int mlxsw_sp_rif_subport_op(struct mlxsw_sp_rif *rif, bool enable)
 static int mlxsw_sp_rif_subport_configure(struct mlxsw_sp_rif *rif,
 					  struct netlink_ext_ack *extack)
 {
+	u8 mac_profile;
 	int err;
 
-	err = mlxsw_sp_rif_subport_op(rif, true);
+	err = mlxsw_sp_rif_mac_profile_get(rif->mlxsw_sp, rif->addr,
+					   &mac_profile, extack);
 	if (err)
 		return err;
+	rif->mac_profile_id = mac_profile;
+
+	err = mlxsw_sp_rif_subport_op(rif, true);
+	if (err)
+		goto err_rif_subport_op;
 
 	err = mlxsw_sp_rif_fdb_op(rif->mlxsw_sp, rif->dev->dev_addr,
 				  mlxsw_sp_fid_index(rif->fid), true);
@@ -9097,6 +9294,8 @@ static int mlxsw_sp_rif_subport_configure(struct mlxsw_sp_rif *rif,
 
 err_rif_fdb_op:
 	mlxsw_sp_rif_subport_op(rif, false);
+err_rif_subport_op:
+	mlxsw_sp_rif_mac_profile_put(rif->mlxsw_sp, mac_profile);
 	return err;
 }
 
@@ -9109,6 +9308,7 @@ static void mlxsw_sp_rif_subport_deconfigure(struct mlxsw_sp_rif *rif)
 			    mlxsw_sp_fid_index(fid), false);
 	mlxsw_sp_rif_macvlan_flush(rif);
 	mlxsw_sp_rif_subport_op(rif, false);
+	mlxsw_sp_rif_mac_profile_put(rif->mlxsw_sp, rif->mac_profile_id);
 }
 
 static struct mlxsw_sp_fid *
@@ -9137,6 +9337,7 @@ static int mlxsw_sp_rif_vlan_fid_op(struct mlxsw_sp_rif *rif,
 	mlxsw_reg_ritr_pack(ritr_pl, enable, type, rif->rif_index, rif->vr_id,
 			    rif->dev->mtu);
 	mlxsw_reg_ritr_mac_pack(ritr_pl, rif->dev->dev_addr);
+	mlxsw_reg_ritr_if_mac_profile_id_set(ritr_pl, rif->mac_profile_id);
 	mlxsw_reg_ritr_fid_set(ritr_pl, type, vid_fid);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
@@ -9152,12 +9353,19 @@ static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
 {
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	u16 fid_index = mlxsw_sp_fid_index(rif->fid);
+	u8 mac_profile;
 	int err;
 
+	err = mlxsw_sp_rif_mac_profile_get(mlxsw_sp, rif->addr,
+					   &mac_profile, extack);
+	if (err)
+		return err;
+	rif->mac_profile_id = mac_profile;
+
 	err = mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index,
 				       true);
 	if (err)
-		return err;
+		goto err_rif_vlan_fid_op;
 
 	err = mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
 				     mlxsw_sp_router_port(mlxsw_sp), true);
@@ -9185,6 +9393,8 @@ static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
 			       mlxsw_sp_router_port(mlxsw_sp), false);
 err_fid_mc_flood_set:
 	mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index, false);
+err_rif_vlan_fid_op:
+	mlxsw_sp_rif_mac_profile_put(mlxsw_sp, mac_profile);
 	return err;
 }
 
@@ -9203,6 +9413,7 @@ static void mlxsw_sp_rif_fid_deconfigure(struct mlxsw_sp_rif *rif)
 	mlxsw_sp_fid_flood_set(rif->fid, MLXSW_SP_FLOOD_TYPE_MC,
 			       mlxsw_sp_router_port(mlxsw_sp), false);
 	mlxsw_sp_rif_vlan_fid_op(rif, MLXSW_REG_RITR_FID_IF, fid_index, false);
+	mlxsw_sp_rif_mac_profile_put(rif->mlxsw_sp, rif->mac_profile_id);
 }
 
 static struct mlxsw_sp_fid *
@@ -9551,6 +9762,12 @@ static const struct mlxsw_sp_rif_ops *mlxsw_sp2_rif_ops_arr[] = {
 static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 {
 	u64 max_rifs = MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS);
+	struct mlxsw_core *core = mlxsw_sp->core;
+
+	if (!MLXSW_CORE_RES_VALID(core, MAX_RIF_MAC_PROFILES))
+		return -EIO;
+	mlxsw_sp->router->max_rif_mac_profile =
+		MLXSW_CORE_RES_GET(core, MAX_RIF_MAC_PROFILES);
 
 	mlxsw_sp->router->rifs = kcalloc(max_rifs,
 					 sizeof(struct mlxsw_sp_rif *),
@@ -9558,6 +9775,9 @@ static int mlxsw_sp_rifs_init(struct mlxsw_sp *mlxsw_sp)
 	if (!mlxsw_sp->router->rifs)
 		return -ENOMEM;
 
+	idr_init(&mlxsw_sp->router->rif_mac_profiles_idr);
+	atomic_set(&mlxsw_sp->router->rif_mac_profiles_count, 0);
+
 	return 0;
 }
 
@@ -9568,6 +9788,8 @@ static void mlxsw_sp_rifs_fini(struct mlxsw_sp *mlxsw_sp)
 	for (i = 0; i < MLXSW_CORE_RES_GET(mlxsw_sp->core, MAX_RIFS); i++)
 		WARN_ON_ONCE(mlxsw_sp->router->rifs[i]);
 
+	WARN_ON(!idr_is_empty(&mlxsw_sp->router->rif_mac_profiles_idr));
+	idr_destroy(&mlxsw_sp->router->rif_mac_profiles_idr);
 	kfree(mlxsw_sp->router->rifs);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index 1d0d28f8ff05..99e8371a82a5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -39,6 +39,9 @@ mlxsw_sp_fib_entry_op_ctx_clear(struct mlxsw_sp_fib_entry_op_ctx *op_ctx)
 struct mlxsw_sp_router {
 	struct mlxsw_sp *mlxsw_sp;
 	struct mlxsw_sp_rif **rifs;
+	struct idr rif_mac_profiles_idr;
+	atomic_t rif_mac_profiles_count;
+	u8 max_rif_mac_profile;
 	struct mlxsw_sp_vr *vrs;
 	struct rhashtable neigh_ht;
 	struct rhashtable nexthop_group_ht;
-- 
2.31.1


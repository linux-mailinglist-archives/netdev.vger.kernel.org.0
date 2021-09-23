Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C15E2415E7C
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241042AbhIWMjt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:39:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51173 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241038AbhIWMjp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:45 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 367235C00C4;
        Thu, 23 Sep 2021 08:38:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 23 Sep 2021 08:38:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=1+xJW37dpQrxvPiqnHzjaUpDddRgIHIK3v2WFaT1/D8=; b=ZJ+uLjM3
        22XxVqLA/Z8jps5t+ic5arPZRS8Aj3UkefJEbYgRHFFTPs6g3TxnUG+o+4Q2oC3E
        fAXbkqApwZAjcJysExzqghhwsm9UIIfyy3fRNiG0c6HMikWR0BfSr/TOH5HWVNhq
        JlHA9JKkukIl3vP3Co6pkBrzEvLMxFIwUT30ZBrbGp94h5d0eHF3vE4umc0S6cOw
        OnO+R4bkmuFRZwRlMkgmnPUVlMEM7TDeZdyAt9rYc//+9pnYinOke2Dr06aV6e40
        HFsB45L1H9N185zN5idZsD58fHZkTYC7UBxe3N0EZPk/2jfadZEHin4a6LBxUpQ3
        hHRWQn6O5z6mhg==
X-ME-Sender: <xms:NnVMYd-zB-ma6K8v04iDV_aHXBXR3KaIt-97_u-DRxy1s3Co-HjXcw>
    <xme:NnVMYRsMbJ_5KjQC8TntQ-nvnO_xUnCl5TCLL0XacM2S_YX3NQjq1rlv3y0FkeHHY
    9AMzYQwP3zIS9c>
X-ME-Received: <xmr:NnVMYbDBJX67c-65pN2yBzBdUXyLws_mXVLpiyQg5vrAcRRbGEpMA59n-RZDSb5KKyEobJS9QAZBSqEYapwpvSV8whS3intYKtEpxq21-cVAow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:NnVMYRcEOxWUY-2IaaPV8ND-lMKZy7B8u4xgK6wHe3mFzMS5-el_4g>
    <xmx:NnVMYSMsRQPEjZ4T3i7cYKyNafI0XMgV6Wze-vXrs_NwHlvvPMrhrg>
    <xmx:NnVMYTnZRRXwYuRoFE5o6o5EhNq2bNYs1Bsnbq62O-spGM59RyI1rw>
    <xmx:NnVMYZ3pPeqJA9xK6hI8GoqvkjDEepCrtbP7ARZz64A4ZFYzFE8X4w>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:12 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/14] mlxsw: Take tunnel's type into account when searching underlay device
Date:   Thu, 23 Sep 2021 15:36:51 +0300
Message-Id: <20210923123700.885466-6-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The function __mlxsw_sp_ipip_netdev_ul_dev_get() returns the underlay
device that corresponds to the overlay device that it gets.
Currently, this function assumes that the tunnel is IPv4 GRE, because it
is the only one that is supported by mlxsw driver.

This assumption will no longer be correct when IPv6 GRE support is added,
resulting in wrong underlay device being returned.
Instead, check 'ol_dev->type' and return the underlay device accordingly.

Move the function to spectrum_ipip.c because spectrum_router.c should not
be aware to tunnel type.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_ipip.c | 15 +++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_router.c   | 17 ++++-------------
 .../ethernet/mellanox/mlxsw/spectrum_router.h   |  2 ++
 3 files changed, 21 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 2164e940abba..3c07e3a70fb6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -384,3 +384,18 @@ int mlxsw_sp_ipip_ecn_decap_init(struct mlxsw_sp *mlxsw_sp)
 
 	return 0;
 }
+
+struct net_device *
+mlxsw_sp_ipip_netdev_ul_dev_get(const struct net_device *ol_dev)
+{
+	struct net *net = dev_net(ol_dev);
+	struct ip_tunnel *tun4;
+
+	switch (ol_dev->type) {
+	case ARPHRD_IPGRE:
+		tun4 = netdev_priv(ol_dev);
+		return dev_get_by_index_rcu(net, tun4->parms.link);
+	default:
+		return NULL;
+	}
+}
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index b79662048ef7..2582404043af 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -1055,22 +1055,13 @@ static void mlxsw_sp_vrs_fini(struct mlxsw_sp *mlxsw_sp)
 	kfree(mlxsw_sp->router->vrs);
 }
 
-static struct net_device *
-__mlxsw_sp_ipip_netdev_ul_dev_get(const struct net_device *ol_dev)
-{
-	struct ip_tunnel *tun = netdev_priv(ol_dev);
-	struct net *net = dev_net(ol_dev);
-
-	return dev_get_by_index_rcu(net, tun->parms.link);
-}
-
 u32 mlxsw_sp_ipip_dev_ul_tb_id(const struct net_device *ol_dev)
 {
 	struct net_device *d;
 	u32 tb_id;
 
 	rcu_read_lock();
-	d = __mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
+	d = mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
 	if (d)
 		tb_id = l3mdev_fib_table(d) ? : RT_TABLE_MAIN;
 	else
@@ -1441,7 +1432,7 @@ mlxsw_sp_ipip_entry_find_by_ul_dev(const struct mlxsw_sp *mlxsw_sp,
 		struct net_device *ipip_ul_dev;
 
 		rcu_read_lock();
-		ipip_ul_dev = __mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
+		ipip_ul_dev = mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
 		rcu_read_unlock();
 
 		if (ipip_ul_dev == ul_dev)
@@ -1821,7 +1812,7 @@ static void mlxsw_sp_ipip_demote_tunnel_by_ul_netdev(struct mlxsw_sp *mlxsw_sp,
 		struct net_device *ipip_ul_dev;
 
 		rcu_read_lock();
-		ipip_ul_dev = __mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
+		ipip_ul_dev = mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
 		rcu_read_unlock();
 		if (ipip_ul_dev == ul_dev)
 			mlxsw_sp_ipip_entry_demote_tunnel(mlxsw_sp, ipip_entry);
@@ -4146,7 +4137,7 @@ static bool mlxsw_sp_ipip_netdev_ul_up(struct net_device *ol_dev)
 	bool is_up;
 
 	rcu_read_lock();
-	ul_dev = __mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
+	ul_dev = mlxsw_sp_ipip_netdev_ul_dev_get(ol_dev);
 	is_up = ul_dev ? (ul_dev->flags & IFF_UP) : true;
 	rcu_read_unlock();
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
index cc32d25c3bb2..1d0d28f8ff05 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.h
@@ -226,6 +226,8 @@ static inline bool mlxsw_sp_l3addr_eq(const union mlxsw_sp_l3addr *addr1,
 
 int mlxsw_sp_ipip_ecn_encap_init(struct mlxsw_sp *mlxsw_sp);
 int mlxsw_sp_ipip_ecn_decap_init(struct mlxsw_sp *mlxsw_sp);
+struct net_device *
+mlxsw_sp_ipip_netdev_ul_dev_get(const struct net_device *ol_dev);
 
 extern const struct mlxsw_sp_router_ll_ops mlxsw_sp_router_ll_xm_ops;
 
-- 
2.31.1


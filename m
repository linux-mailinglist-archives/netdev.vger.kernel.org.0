Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8EE243AF45
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 11:43:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234826AbhJZJp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 05:45:27 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51603 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234508AbhJZJp0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 05:45:26 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 23AFB5C013B;
        Tue, 26 Oct 2021 05:43:03 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 26 Oct 2021 05:43:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=EI5SR8U5zkOPIloAWLzBioI3nSoK+yhraP0rVpujpeg=; b=XjGvDQDx
        SHxN/4YP4VHXjJeCXvrnuFNFIOLepbVrNR87cLG+IHF2PI5eSMKwUyqyJhUKtA1C
        e++MDQat8kwbCM7HomHr1aWCMXXqIzCbkDTgrqJ3fNsKJrknSouHiDFjsZ7VQ5OV
        piAgSTUxGtxr+chU+3nhMEcoZy86V9PZrCajZxUyPuF5/24vIL7HjmtTOqMY6Hh3
        gYFnjzg4ywH8gpy2JWwB/8QwC2s+tQGQO9Opi9X3Kr1eL/nIWrFLCVejQu42bENt
        9Jj379yz0v916/o1+FvAco0Nks8O5aT/tQFCfBBiyrRW+yrcv2Qlt48x+qlK/pZg
        XEZngo2IuKpHZA==
X-ME-Sender: <xms:ps13YQdTRaHLrJsoZAIp8yT82LIOjVz62mSo4EkW4ne6FceUl6ivYw>
    <xme:ps13YSPAhteQDyDNT9hU5BbvQeo7A3HYRrIuSWR4G0-fBdvYz211Hg-_NiNj4TYc9
    b7ZDbKYaYfqnL4>
X-ME-Received: <xmr:ps13YRiZo0b13X5S_a9fJHXQSrxFxhin-xIHnLi9lpXnlOIX9jXMVLyCGMDa3bwrRiW_V2dcxjBF8aih-gvzIU72gORlY_54jsA1h8J3NMc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvdefjedgudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ps13YV8rN0bZGEcUZbNB2sEMW8kMMteoX4_-U7SkMcbdhAvWbbJALg>
    <xmx:ps13YcuVTBAtPg0t9SFblWvhWCh0Wtz2qLboC8vBv0lNV5i5EqI-Tw>
    <xmx:ps13YcHFOmGxnePyHmLvlQnuKXRyJNtCKp-vD82nEXQpKyJr884UsQ>
    <xmx:p813YWXuK4LjOV3tN57xdqcWNxTMXWa3Nj3owyMmn1ae5_dKOTylLA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Oct 2021 05:43:00 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, danieller@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 3/9] mlxsw: spectrum_router: Propagate extack further
Date:   Tue, 26 Oct 2021 12:42:19 +0300
Message-Id: <20211026094225.1265320-4-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20211026094225.1265320-1-idosch@idosch.org>
References: <20211026094225.1265320-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@nvidia.com>

The next patch will set the MAC profile of a router interface (RIF) as
part of its configure() callback. The operation can fail in case the
maximum number of profiles was exceeded.

Add extack to mlxsw_sp_rif_ops::configure() in order to communicate such
failures to user space.

In addition, the MAC profile of a RIF can change following a
'NETDEV_CHANGEADDR' notification. Propagate extack to
mlxsw_sp_router_port_change_event() so that failures could be
communicated in this path as well.

No functional changes intended.

Signed-off-by: Danielle Ratson <danieller@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 23 ++++++++++++-------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1e141b5944cd..6f2989a70cbb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -106,7 +106,8 @@ struct mlxsw_sp_rif_ops {
 
 	void (*setup)(struct mlxsw_sp_rif *rif,
 		      const struct mlxsw_sp_rif_params *params);
-	int (*configure)(struct mlxsw_sp_rif *rif);
+	int (*configure)(struct mlxsw_sp_rif *rif,
+			 struct netlink_ext_ack *extack);
 	void (*deconfigure)(struct mlxsw_sp_rif *rif);
 	struct mlxsw_sp_fid * (*fid_get)(struct mlxsw_sp_rif *rif,
 					 struct netlink_ext_ack *extack);
@@ -8186,7 +8187,7 @@ mlxsw_sp_rif_create(struct mlxsw_sp *mlxsw_sp,
 	if (ops->setup)
 		ops->setup(rif, params);
 
-	err = ops->configure(rif);
+	err = ops->configure(rif, extack);
 	if (err)
 		goto err_configure;
 
@@ -8866,7 +8867,8 @@ static int mlxsw_sp_rif_edit(struct mlxsw_sp *mlxsw_sp, u16 rif_index,
 
 static int
 mlxsw_sp_router_port_change_event(struct mlxsw_sp *mlxsw_sp,
-				  struct mlxsw_sp_rif *rif)
+				  struct mlxsw_sp_rif *rif,
+				  struct netlink_ext_ack *extack)
 {
 	struct net_device *dev = rif->dev;
 	u16 fid_index;
@@ -8928,6 +8930,7 @@ static int mlxsw_sp_router_port_pre_changeaddr_event(struct mlxsw_sp_rif *rif,
 int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 					 unsigned long event, void *ptr)
 {
+	struct netlink_ext_ack *extack = netdev_notifier_info_to_extack(ptr);
 	struct mlxsw_sp *mlxsw_sp;
 	struct mlxsw_sp_rif *rif;
 	int err = 0;
@@ -8944,7 +8947,7 @@ int mlxsw_sp_netdevice_router_port_event(struct net_device *dev,
 	switch (event) {
 	case NETDEV_CHANGEMTU:
 	case NETDEV_CHANGEADDR:
-		err = mlxsw_sp_router_port_change_event(mlxsw_sp, rif);
+		err = mlxsw_sp_router_port_change_event(mlxsw_sp, rif, extack);
 		break;
 	case NETDEV_PRE_CHANGEADDR:
 		err = mlxsw_sp_router_port_pre_changeaddr_event(rif, ptr);
@@ -9075,7 +9078,8 @@ static int mlxsw_sp_rif_subport_op(struct mlxsw_sp_rif *rif, bool enable)
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
 }
 
-static int mlxsw_sp_rif_subport_configure(struct mlxsw_sp_rif *rif)
+static int mlxsw_sp_rif_subport_configure(struct mlxsw_sp_rif *rif,
+					  struct netlink_ext_ack *extack)
 {
 	int err;
 
@@ -9143,7 +9147,8 @@ u8 mlxsw_sp_router_port(const struct mlxsw_sp *mlxsw_sp)
 	return mlxsw_core_max_ports(mlxsw_sp->core) + 1;
 }
 
-static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif)
+static int mlxsw_sp_rif_fid_configure(struct mlxsw_sp_rif *rif,
+				      struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp *mlxsw_sp = rif->mlxsw_sp;
 	u16 fid_index = mlxsw_sp_fid_index(rif->fid);
@@ -9302,7 +9307,8 @@ mlxsw_sp_rif_ipip_lb_setup(struct mlxsw_sp_rif *rif,
 }
 
 static int
-mlxsw_sp1_rif_ipip_lb_configure(struct mlxsw_sp_rif *rif)
+mlxsw_sp1_rif_ipip_lb_configure(struct mlxsw_sp_rif *rif,
+				struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_rif_ipip_lb *lb_rif = mlxsw_sp_rif_ipip_lb_rif(rif);
 	u32 ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(rif->dev);
@@ -9489,7 +9495,8 @@ void mlxsw_sp_router_ul_rif_put(struct mlxsw_sp *mlxsw_sp, u16 ul_rif_index)
 }
 
 static int
-mlxsw_sp2_rif_ipip_lb_configure(struct mlxsw_sp_rif *rif)
+mlxsw_sp2_rif_ipip_lb_configure(struct mlxsw_sp_rif *rif,
+				struct netlink_ext_ack *extack)
 {
 	struct mlxsw_sp_rif_ipip_lb *lb_rif = mlxsw_sp_rif_ipip_lb_rif(rif);
 	u32 ul_tb_id = mlxsw_sp_ipip_dev_ul_tb_id(rif->dev);
-- 
2.31.1


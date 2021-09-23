Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87CD415E82
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:38:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241083AbhIWMkG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:40:06 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:55545 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241082AbhIWMj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:39:58 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 06BD65C0160;
        Thu, 23 Sep 2021 08:38:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 23 Sep 2021 08:38:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=kxtVZPEmBSLXKz6+rBzGZvgIw9pdVuk7EhFU8nDcNSU=; b=IP/r/HOn
        kjuPHirUMyDR5s2hof7ouTiwVVgOUtBraWt2WLyHqKf93vb4AWI7YlLKCNAvqrmY
        VqWM//cwjhQrKj+8iVV5hcqFDHGn1wax/inGJO5xD2c8mJZbibxlfRJSFlHJhCtl
        29E0Nle8N23X2UDZYUcDr++fZTRvMw7qPDnKp5FcJ6KPZfRPFRpzZB+tUtCARGvC
        TFnm9nlGzS810ZMApDxvltXhhivsB7z6VKW+bvxbjlEBBdo5D7cFIqL8MewU40s7
        iI6+89iVKjcIAN37pCoz/L6DTYkpuWedrObqUuFKrLiHX3bDydic3a+tuUvbE+s2
        j7WbY220xCgQyg==
X-ME-Sender: <xms:QnVMYZeYmKvEjuUq_WEL6F_0U1EsXwXqM48Yp2ZF_PPwdwwH3URWoA>
    <xme:QnVMYXO-Og6KoZMp3Un66NtGh3XxeVwlMXMN7Ui_G6Ed2JebZNTPXR5H6cT4uK57Z
    95NMFnpF1feiGM>
X-ME-Received: <xmr:QnVMYSjBghm0ejgNpFfBKaHHiu6LGRMa2ZTjkWpAr02KaRvUouFnt5ypTXujJisqZRKoPWXbHbOKucIdm7A09hbfzIPUUUjZQMfaxQbnRMaixA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudeiledgheefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecuvehluhhsthgvrhfuihiivgepheenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:QnVMYS-a-VvBxo0xceDa0p4m0EBrBkSGRUCO1YT1UVCWR5HMhjAaOg>
    <xmx:QnVMYVukZIspXsvSvmvm7JseuoTBvepYPNIe9d8y3KvlMlSQhUbwGw>
    <xmx:QnVMYRFZTrQeT6gQrU-2_c3SRBHvH5RtbAnU32R0694FhGex_MmJXQ>
    <xmx:Q3VMYTUk7GP_VQ87tQ-2xE6yK3CFSS-a1mBmc0hrXeITStPBRcYqLA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 23 Sep 2021 08:38:24 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        petrm@nvidia.com, jiri@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 11/14] mlxsw: spectrum_ipip: Add mlxsw_sp_ipip_gre6_ops
Date:   Thu, 23 Sep 2021 15:36:57 +0300
Message-Id: <20210923123700.885466-12-idosch@idosch.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210923123700.885466-1-idosch@idosch.org>
References: <20210923123700.885466-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add operations for IP-in-IP GRE6. For now the function can_offload()
returns false and the other functions warn as they should never be called.

A later patch will add dedicated operations for Spectrum-2 which will
support IPv6 underlay, so use 'mlxsw_sp1_' prefix for the new operations.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_ipip.c   | 65 +++++++++++++++++++
 .../ethernet/mellanox/mlxsw/spectrum_ipip.h   |  1 +
 2 files changed, 66 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 93d183d5100d..4bb4a3e3a2aa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -324,12 +324,77 @@ static const struct mlxsw_sp_ipip_ops mlxsw_sp_ipip_gre4_ops = {
 	.ol_netdev_change = mlxsw_sp_ipip_ol_netdev_change_gre4,
 };
 
+static struct mlxsw_sp_ipip_parms
+mlxsw_sp1_ipip_netdev_parms_init_gre6(const struct net_device *ol_dev)
+{
+	struct mlxsw_sp_ipip_parms parms = {0};
+
+	WARN_ON_ONCE(1);
+	return parms;
+}
+
+static int
+mlxsw_sp1_ipip_nexthop_update_gre6(struct mlxsw_sp *mlxsw_sp, u32 adj_index,
+				   struct mlxsw_sp_ipip_entry *ipip_entry,
+				   bool force, char *ratr_pl)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+
+static int
+mlxsw_sp1_ipip_decap_config_gre6(struct mlxsw_sp *mlxsw_sp,
+				 struct mlxsw_sp_ipip_entry *ipip_entry,
+				 u32 tunnel_index)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+
+static bool mlxsw_sp1_ipip_can_offload_gre6(const struct mlxsw_sp *mlxsw_sp,
+					    const struct net_device *ol_dev)
+{
+	return false;
+}
+
+static struct mlxsw_sp_rif_ipip_lb_config
+mlxsw_sp1_ipip_ol_loopback_config_gre6(struct mlxsw_sp *mlxsw_sp,
+				       const struct net_device *ol_dev)
+{
+	struct mlxsw_sp_rif_ipip_lb_config config = {0};
+
+	WARN_ON_ONCE(1);
+	return config;
+}
+
+static int
+mlxsw_sp1_ipip_ol_netdev_change_gre6(struct mlxsw_sp *mlxsw_sp,
+				     struct mlxsw_sp_ipip_entry *ipip_entry,
+				     struct netlink_ext_ack *extack)
+{
+	WARN_ON_ONCE(1);
+	return -EINVAL;
+}
+
+static const struct mlxsw_sp_ipip_ops mlxsw_sp1_ipip_gre6_ops = {
+	.dev_type = ARPHRD_IP6GRE,
+	.ul_proto = MLXSW_SP_L3_PROTO_IPV6,
+	.parms_init = mlxsw_sp1_ipip_netdev_parms_init_gre6,
+	.nexthop_update = mlxsw_sp1_ipip_nexthop_update_gre6,
+	.decap_config = mlxsw_sp1_ipip_decap_config_gre6,
+	.can_offload = mlxsw_sp1_ipip_can_offload_gre6,
+	.ol_loopback_config = mlxsw_sp1_ipip_ol_loopback_config_gre6,
+	.ol_netdev_change = mlxsw_sp1_ipip_ol_netdev_change_gre6,
+};
+
 const struct mlxsw_sp_ipip_ops *mlxsw_sp1_ipip_ops_arr[] = {
 	[MLXSW_SP_IPIP_TYPE_GRE4] = &mlxsw_sp_ipip_gre4_ops,
+	[MLXSW_SP_IPIP_TYPE_GRE6] = &mlxsw_sp1_ipip_gre6_ops,
 };
 
 const struct mlxsw_sp_ipip_ops *mlxsw_sp2_ipip_ops_arr[] = {
 	[MLXSW_SP_IPIP_TYPE_GRE4] = &mlxsw_sp_ipip_gre4_ops,
+	[MLXSW_SP_IPIP_TYPE_GRE6] = &mlxsw_sp1_ipip_gre6_ops,
 };
 
 static int mlxsw_sp_ipip_ecn_encap_init_one(struct mlxsw_sp *mlxsw_sp,
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
index 4426a44d546f..5d93337b9a2d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.h
@@ -21,6 +21,7 @@ bool mlxsw_sp_l3addr_is_zero(union mlxsw_sp_l3addr addr);
 
 enum mlxsw_sp_ipip_type {
 	MLXSW_SP_IPIP_TYPE_GRE4,
+	MLXSW_SP_IPIP_TYPE_GRE6,
 	MLXSW_SP_IPIP_TYPE_MAX,
 };
 
-- 
2.31.1


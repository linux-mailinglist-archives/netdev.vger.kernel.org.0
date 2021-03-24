Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07323482B0
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238185AbhCXUPY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:24 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:58251 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238128AbhCXUPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:15:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E239F5C005E;
        Wed, 24 Mar 2021 16:15:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 24 Mar 2021 16:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=BoTD/kouP5QfDQztwHdSZontMOq9GzxbArMa49MJNso=; b=vnso8ifc
        MK/YBZeTyvU+ptnEiAg0XyBFbHNmHeAW63uiOb2OgUqxQMrjPUfWs5/Wn1QH20ZA
        lucmw+Wx61aG7phRBUhRdPRkK0aVS2N1vmrR2mig7uAln29DeyfCZO6AnEF7Xim8
        tPkR/fZ56Hgcm1Bh4nSmYRp1msm9l7uU+j46nvaUAWghnOwKUz+QRPiZxK+SKzR8
        fVnBc7dgahIAX+RzhYeT1JDUC5ymKBPyxLDyDvS+tbUKCBJmgjYiiB4sq/NfMTVB
        uMbkDk4AbNCOnFvhVeNnFaFIaivKIHXkNEo6GRvh6DtrgxImbJdBX9/lYBgO2PlM
        LLDNEOXvFk6Xfw==
X-ME-Sender: <xms:xZ1bYNZCc2iT6xsJ3KuyD3jlgMJFV9_L1ApFFE2jDOfW8wrMR36EHg>
    <xme:xZ1bYNU2LiJZdMfxXTlsh42Oy52p8g1F7v3SFk55YWZCHgEOfcOJBBB1JTIL9LqRT
    CrrJ_rWIYRBZ94>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:xZ1bYB6i5PIkX1_QhXvUX0tDL7vfVLfADzMe3IG94_BiSdXLHZUFbg>
    <xmx:xZ1bYIitPChou3mCV3j4sHVhoZ_iveM-oCJQvC_1I8t7P-nC5DmYuQ>
    <xmx:xZ1bYIcK8EDz2udd0t3KbC9A_tcGRuL2ueYs3vT0NaLhgo8WdlmGmQ>
    <xmx:xZ1bYPFb3b3T-73YUH0z-leHPrM0B-jZQsO05ibFKmRvOumUmL7sNg>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id BCC54240428;
        Wed, 24 Mar 2021 16:14:59 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 08/10] mlxsw: spectrum_router: Enable resilient nexthop groups to be programmed
Date:   Wed, 24 Mar 2021 22:14:22 +0200
Message-Id: <20210324201424.157387-9-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
References: <20210324201424.157387-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

Now that mlxsw supports resilient nexthop groups, allow them to be
programmed after validating that their configuration conforms to the
device's limitations (e.g., number of buckets is within predefined
range).

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_router.c | 86 ++++++++++++++++++-
 1 file changed, 85 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 1d74341596da..6ccaa194733b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -4519,11 +4519,86 @@ mlxsw_sp_nexthop_obj_group_validate(struct mlxsw_sp *mlxsw_sp,
 	return 0;
 }
 
+static int
+mlxsw_sp_nexthop_obj_res_group_size_validate(struct mlxsw_sp *mlxsw_sp,
+					     const struct nh_notifier_res_table_info *nh_res_table,
+					     struct netlink_ext_ack *extack)
+{
+	unsigned int alloc_size;
+	bool valid_size = false;
+	int err, i;
+
+	if (nh_res_table->num_nh_buckets < 32) {
+		NL_SET_ERR_MSG_MOD(extack, "Minimum number of buckets is 32");
+		return -EINVAL;
+	}
+
+	for (i = 0; i < mlxsw_sp->router->adj_grp_size_ranges_count; i++) {
+		const struct mlxsw_sp_adj_grp_size_range *size_range;
+
+		size_range = &mlxsw_sp->router->adj_grp_size_ranges[i];
+
+		if (nh_res_table->num_nh_buckets >= size_range->start &&
+		    nh_res_table->num_nh_buckets <= size_range->end) {
+			valid_size = true;
+			break;
+		}
+	}
+
+	if (!valid_size) {
+		NL_SET_ERR_MSG_MOD(extack, "Invalid number of buckets");
+		return -EINVAL;
+	}
+
+	err = mlxsw_sp_kvdl_alloc_count_query(mlxsw_sp,
+					      MLXSW_SP_KVDL_ENTRY_TYPE_ADJ,
+					      nh_res_table->num_nh_buckets,
+					      &alloc_size);
+	if (err || nh_res_table->num_nh_buckets != alloc_size) {
+		NL_SET_ERR_MSG_MOD(extack, "Number of buckets does not fit allocation size of any KVDL partition");
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static int
+mlxsw_sp_nexthop_obj_res_group_validate(struct mlxsw_sp *mlxsw_sp,
+					const struct nh_notifier_res_table_info *nh_res_table,
+					struct netlink_ext_ack *extack)
+{
+	int err;
+	u16 i;
+
+	err = mlxsw_sp_nexthop_obj_res_group_size_validate(mlxsw_sp,
+							   nh_res_table,
+							   extack);
+	if (err)
+		return err;
+
+	for (i = 0; i < nh_res_table->num_nh_buckets; i++) {
+		const struct nh_notifier_single_info *nh;
+		int err;
+
+		nh = &nh_res_table->nhs[i];
+		err = mlxsw_sp_nexthop_obj_group_entry_validate(mlxsw_sp, nh,
+								extack);
+		if (err)
+			return err;
+	}
+
+	return 0;
+}
+
 static int mlxsw_sp_nexthop_obj_validate(struct mlxsw_sp *mlxsw_sp,
 					 unsigned long event,
 					 struct nh_notifier_info *info)
 {
-	if (event != NEXTHOP_EVENT_REPLACE)
+	struct nh_notifier_single_info *nh;
+
+	if (event != NEXTHOP_EVENT_REPLACE &&
+	    event != NEXTHOP_EVENT_RES_TABLE_PRE_REPLACE &&
+	    event != NEXTHOP_EVENT_BUCKET_REPLACE)
 		return 0;
 
 	switch (info->type) {
@@ -4534,6 +4609,14 @@ static int mlxsw_sp_nexthop_obj_validate(struct mlxsw_sp *mlxsw_sp,
 		return mlxsw_sp_nexthop_obj_group_validate(mlxsw_sp,
 							   info->nh_grp,
 							   info->extack);
+	case NH_NOTIFIER_INFO_TYPE_RES_TABLE:
+		return mlxsw_sp_nexthop_obj_res_group_validate(mlxsw_sp,
+							       info->nh_res_table,
+							       info->extack);
+	case NH_NOTIFIER_INFO_TYPE_RES_BUCKET:
+		nh = &info->nh_res_bucket->new_nh;
+		return mlxsw_sp_nexthop_obj_group_entry_validate(mlxsw_sp, nh,
+								 info->extack);
 	default:
 		NL_SET_ERR_MSG_MOD(info->extack, "Unsupported nexthop type");
 		return -EOPNOTSUPP;
@@ -4551,6 +4634,7 @@ static bool mlxsw_sp_nexthop_obj_is_gateway(struct mlxsw_sp *mlxsw_sp,
 		return info->nh->gw_family || info->nh->is_reject ||
 		       mlxsw_sp_netdev_ipip_type(mlxsw_sp, dev, NULL);
 	case NH_NOTIFIER_INFO_TYPE_GRP:
+	case NH_NOTIFIER_INFO_TYPE_RES_TABLE:
 		/* Already validated earlier. */
 		return true;
 	default:
-- 
2.30.2


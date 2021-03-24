Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E0E3482AE
	for <lists+netdev@lfdr.de>; Wed, 24 Mar 2021 21:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238175AbhCXUPV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 16:15:21 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33283 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237868AbhCXUO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 16:14:57 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 236F35C015A;
        Wed, 24 Mar 2021 16:14:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 24 Mar 2021 16:14:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=kTxBMvuO1LcEfM3cWU8i1UoxNZTCC/5O6tnUCpvguS4=; b=dOeQDXJH
        dZoYSeUVFkUxuEROn0m0kXoZ2uaSK8pMVsO4FE/Iw9E/T5qPTu3NLhWzmg1KPiw6
        csS3YOjG7Bd3LPl3qBd291Rn52dzfPK9YqkcOOgbwziRdBdR0Exb4Ea0VAi8CJdh
        UVWCn4U9Y1QX/XVyYxWfo++rk+2Sw9ITOkwhzbwJQJZfzKxCkOddWqKyATdxtBqp
        1WusK87mHBoGtfJwZ5DCoVkpVRiTcJJTUhEsSGr9kPT1/CCuSYFMPBzRgueqCaIt
        Wd9u6os3vIVZScpvRPHJcZPGRUEAwko/VsOvrRceXdd7PyHyh/c1m0VlBzuu2Epq
        wJNC8gu4q3ILmg==
X-ME-Sender: <xms:wZ1bYJryNUcUFQLZ0Qk-kaU3FNiXTnnEHXU3OEEvF-CtbCyFlu4HKw>
    <xme:wZ1bYLrD3EMlNqV10FVgGh0kqp3qjBYF6_RbRo_9zTRmgVXdKKHEpWvwxlB4j2bOm
    suc3-8CjfcMOdc>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudegkedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpefkughoucfutghhihhmmhgvlhcuoehiughoshgthhesihgu
    ohhstghhrdhorhhgqeenucggtffrrghtthgvrhhnpeduteeiveffffevleekleejffekhf
    ekhefgtdfftefhledvjefggfehgfevjeekhfenucfkphepkeegrddvvdelrdduheefrdeg
    geenucevlhhushhtvghrufhiiigvpeefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:wZ1bYGPKsO8_WAzybVmhMWzfapcT6kLtGa_-JSouZgLi7yRxZmFLSQ>
    <xmx:wZ1bYE6KQpbXJkirmoby8ASnGgW-o_KQ5fzaWeNMGbE1WGjL7sWBlg>
    <xmx:wZ1bYI67wiIBfXnni7Lg6L_4nYAM_3iX0L-MjFxO0pdu1B2LEnmyaw>
    <xmx:wZ1bYD2c8UrlcEcX7GuVPO90SY5wES08iC9MdJVfVzLUWRHcJBpEIA>
Received: from shredder.mellanox.com (igld-84-229-153-44.inter.net.il [84.229.153.44])
        by mail.messagingengine.com (Postfix) with ESMTPA id 28A60240422;
        Wed, 24 Mar 2021 16:14:54 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        petrm@nvidia.com, dsahern@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/10] mlxsw: reg: Add Router Adjacency Table Activity Dump Register
Date:   Wed, 24 Mar 2021 22:14:20 +0200
Message-Id: <20210324201424.157387-7-idosch@idosch.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210324201424.157387-1-idosch@idosch.org>
References: <20210324201424.157387-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The RATRAD register is used to dump and optionally clear activity bits
of router adjacency table entries. Will be used by the next patch to
query and clear the activity of nexthop buckets in a resilient nexthop
group.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 55 +++++++++++++++++++++++
 1 file changed, 55 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index d33c79ad1810..900b4bf5bb5b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -8130,6 +8130,60 @@ mlxsw_reg_rtdp_ipip4_pack(char *payload, u16 irif,
 	mlxsw_reg_rtdp_ipip_expected_gre_key_set(payload, expected_gre_key);
 }
 
+/* RATRAD - Router Adjacency Table Activity Dump Register
+ * ------------------------------------------------------
+ * The RATRAD register is used to dump and optionally clear activity bits of
+ * router adjacency table entries.
+ */
+#define MLXSW_REG_RATRAD_ID 0x8022
+#define MLXSW_REG_RATRAD_LEN 0x210
+
+MLXSW_REG_DEFINE(ratrad, MLXSW_REG_RATRAD_ID, MLXSW_REG_RATRAD_LEN);
+
+enum {
+	/* Read activity */
+	MLXSW_REG_RATRAD_OP_READ_ACTIVITY,
+	/* Read and clear activity */
+	MLXSW_REG_RATRAD_OP_READ_CLEAR_ACTIVITY,
+};
+
+/* reg_ratrad_op
+ * Access: Operation
+ */
+MLXSW_ITEM32(reg, ratrad, op, 0x00, 30, 2);
+
+/* reg_ratrad_ecmp_size
+ * ecmp_size is the amount of sequential entries from adjacency_index. Valid
+ * ranges:
+ * Spectrum-1: 32-64, 512, 1024, 2048, 4096
+ * Spectrum-2/3: 32-128, 256, 512, 1024, 2048, 4096
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, ratrad, ecmp_size, 0x00, 0, 13);
+
+/* reg_ratrad_adjacency_index
+ * Index into the adjacency table.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, ratrad, adjacency_index, 0x04, 0, 24);
+
+/* reg_ratrad_activity_vector
+ * Activity bit per adjacency index.
+ * Bits higher than ecmp_size are reserved.
+ * Access: RO
+ */
+MLXSW_ITEM_BIT_ARRAY(reg, ratrad, activity_vector, 0x10, 0x200, 1);
+
+static inline void mlxsw_reg_ratrad_pack(char *payload, u32 adjacency_index,
+					 u16 ecmp_size)
+{
+	MLXSW_REG_ZERO(ratrad, payload);
+	mlxsw_reg_ratrad_op_set(payload,
+				MLXSW_REG_RATRAD_OP_READ_CLEAR_ACTIVITY);
+	mlxsw_reg_ratrad_ecmp_size_set(payload, ecmp_size);
+	mlxsw_reg_ratrad_adjacency_index_set(payload, adjacency_index);
+}
+
 /* RIGR-V2 - Router Interface Group Register Version 2
  * ---------------------------------------------------
  * The RIGR_V2 register is used to add, remove and query egress interface list
@@ -12114,6 +12168,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(rtar),
 	MLXSW_REG(ratr),
 	MLXSW_REG(rtdp),
+	MLXSW_REG(ratrad),
 	MLXSW_REG(rdpm),
 	MLXSW_REG(ricnt),
 	MLXSW_REG(rrcr),
-- 
2.30.2


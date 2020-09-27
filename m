Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77A7279F61
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:50:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730443AbgI0Huv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:50:51 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:37301 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730471AbgI0Huu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:50:50 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id CCE59475;
        Sun, 27 Sep 2020 03:50:48 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=8v1fSmIKinyWYn/g4KIqSlpy+yQbdpMoLr2P9YdQPKE=; b=ieM2obBN
        SwkuUfEHDUVnsiIlmO7Z31w+SkP/wPBJ7O5dHTlOTzn/WmRMmOuH1JSyzALDGwza
        BDZsmK2F7dM+YER4+cc7am/6EhOZScErTQ+YkmMFhYZXbeFNuGo5moCIYba1gKE9
        Ii2LJVEerhS5huA6DBtCpS2QX5Ry5jLcnrykVXuyyOYKI1iycUV+vY3Mk8xNylyq
        38QzobNg8KaewhADnjbyWkZZsTMxxJ+QOSmQwwR5YaCfbMXTHikRC3IA5NZ9isfi
        VeSRy+Y5m1qY4jg4OBk4aPcVLC+12TnbB1d9oA+e2S/sjAko5JJR5CvCz7D38FxY
        rSe2IIkn6I1IMw==
X-ME-Sender: <xms:WERwX7cJPnmPrBfn9GwXw4OylRiBkEShuZLpwPlgBhz510U_pcaa_A>
    <xme:WERwXxOpzkp2OrRmy0YwpRAuxaipm4elGAcdsu3DMwB1FJb99h5FuadUukMFmpZW9
    z441gRvoE9otjE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeejrddugeek
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:WERwX0hnydSIYKcLlUJTo-TGHd9dMLDcX3lquuJLONmq_lT7KUhx1A>
    <xmx:WERwX88Vz3dTvZxVUW2M0MqpxZNXBGwvTfhCpaxQeEpzA_0PCunzSQ>
    <xmx:WERwX3sH3OmgXgH20Zzq0rsJ6zRkw-fzWJQx7p4k6QP0V9ksBvGTDA>
    <xmx:WERwX3JYelXcx6pQz3Bhvj5IGs8QLmS8NZM45feTpGrQx3MXzNOX7g>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id CB1BB328005E;
        Sun, 27 Sep 2020 03:50:46 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 03/10] mlxsw: reg: Add Ports Module Administrative and Operational Status Register
Date:   Sun, 27 Sep 2020 10:50:08 +0300
Message-Id: <20200927075015.1417714-4-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

PMAOS register configures and retrieves the per module status.
The register is used also for enabling event for status change.

It will be used to enable PMPE (Port Module Plug/Unplug) event.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h | 59 +++++++++++++++++++++++
 1 file changed, 59 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 5878f14a6538..5fb76448ab76 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5405,6 +5405,64 @@ static inline void mlxsw_reg_pspa_pack(char *payload, u8 swid, u8 local_port)
 	mlxsw_reg_pspa_sub_port_set(payload, 0);
 }
 
+/* PMAOS - Ports Module Administrative and Operational Status
+ * ----------------------------------------------------------
+ * This register configures and retrieves the per module status.
+ */
+#define MLXSW_REG_PMAOS_ID 0x5012
+#define MLXSW_REG_PMAOS_LEN 0x10
+
+MLXSW_REG_DEFINE(pmaos, MLXSW_REG_PMAOS_ID, MLXSW_REG_PMAOS_LEN);
+
+/* reg_slot_index
+ * Slot index.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmaos, slot_index, 0x00, 24, 4);
+
+/* reg_pmaos_module
+ * Module number.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmaos, module, 0x00, 16, 8);
+
+/* reg_pmaos_ase
+ * Admin state update enable.
+ * If this bit is set, admin state will be updated based on admin_state field.
+ * Only relevant on Set() operations.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, pmaos, ase, 0x04, 31, 1);
+
+/* reg_pmaos_ee
+ * Event update enable.
+ * If this bit is set, event generation will be updated based on the e field.
+ * Only relevant on Set operations.
+ * Access: WO
+ */
+MLXSW_ITEM32(reg, pmaos, ee, 0x04, 30, 1);
+
+enum mlxsw_reg_pmaos_e {
+	MLXSW_REG_PMAOS_E_DO_NOT_GENERATE_EVENT,
+	MLXSW_REG_PMAOS_E_GENERATE_EVENT,
+	MLXSW_REG_PMAOS_E_GENERATE_SINGLE_EVENT,
+};
+
+/* reg_pmaos_e
+ * Event Generation on operational state change.
+ * Access: RW
+ */
+MLXSW_ITEM32(reg, pmaos, e, 0x04, 0, 2);
+
+static inline void mlxsw_reg_pmaos_pack(char *payload, u8 module,
+					enum mlxsw_reg_pmaos_e e)
+{
+	MLXSW_REG_ZERO(pmaos, payload);
+	mlxsw_reg_pmaos_module_set(payload, module);
+	mlxsw_reg_pmaos_e_set(payload, e);
+	mlxsw_reg_pmaos_ee_set(payload, true);
+}
+
 /* PPLR - Port Physical Loopback Register
  * --------------------------------------
  * This register allows configuration of the port's loopback mode.
@@ -11102,6 +11160,7 @@ static const struct mlxsw_reg_info *mlxsw_reg_infos[] = {
 	MLXSW_REG(pptb),
 	MLXSW_REG(pbmc),
 	MLXSW_REG(pspa),
+	MLXSW_REG(pmaos),
 	MLXSW_REG(pplr),
 	MLXSW_REG(pmpe),
 	MLXSW_REG(pddr),
-- 
2.26.2


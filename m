Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C80B12D9764
	for <lists+netdev@lfdr.de>; Mon, 14 Dec 2020 12:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438023AbgLNLdG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 06:33:06 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:53939 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2437747AbgLNLce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Dec 2020 06:32:34 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 4FC155C0143;
        Mon, 14 Dec 2020 06:31:07 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Mon, 14 Dec 2020 06:31:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=9WNoADTgn1nqJd/n49xMeBwUsm9R9L+YyEqzWf11NCU=; b=jmGaRFe4
        bSqSWrVY+wZ/vsgHLPofbq9lFVYhXvchET7paU978sJcQMNE3bKWg1pEekXL8tl9
        z1Un6RCaHyQataM2UAOlGGbdQ5iVJI0+yvTfYSMKBC6eTNNeO8InSdK0Tq2r14Ri
        7g0x11JPtnN27vXjpbSug/KKtS7sX+gnWXQeXGZjtRXvW1ZjMqxdr84Mp6B3PDdh
        0VS0Piul6h/XTMam2uy1ETX6JSaDub3jB6hLAAVRfLaKuBt16ude0etatD2yuavt
        8aqRJ63tmLRhGnwZ2dTJLMMW85khTdhbZCYwLncm2VuB+iEyQHdtwN88YBE+9KPW
        v195V1c5n6s36w==
X-ME-Sender: <xms:-0zXXysxuhSBEqbiuKGiUwRqRQa_73-1_N9vSgCKKwIHWfcxWyA_KQ>
    <xme:-0zXX3etDQH69Kj3W03Mh7vavSL77CvPYE97C94PDUWwXwNQHmO06MRUP49xPRVu9
    GsG2v3oTXTAB2A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekkedgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehvddrfedu
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-0zXX9wdwM8T5Bzc3c-xvLmA2hovOV_rbK5SD7QALOzXcVmbyU_7Fg>
    <xmx:-0zXX9PKU6OOqHK_FP7Al7UkyC76ZwqndnRhwcr-yTZri_X5KwJCFA>
    <xmx:-0zXXy-yrgN3Q7pLvO4G7anDReWX7TiMadem_a6Qx-tFI7i53Rvr1A>
    <xmx:-0zXX0I2xqiivA1_mWH_ZCbP1QrZOrzllxFyXZfkLJ0fsBPvtBsfDw>
Received: from shredder.mtl.com (igld-84-229-152-31.inter.net.il [84.229.152.31])
        by mail.messagingengine.com (Postfix) with ESMTPA id 350581080067;
        Mon, 14 Dec 2020 06:31:06 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 05/15] mlxsw: Ignore ports that are connected to eXtended mezanine
Date:   Mon, 14 Dec 2020 13:30:31 +0200
Message-Id: <20201214113041.2789043-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214113041.2789043-1-idosch@idosch.org>
References: <20201214113041.2789043-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@nvidia.com>

Use the info stored in the bus_info struct about the eXtended mezanine
connected ports and don't expose them.

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h     |  1 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  |  3 ++-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c |  3 +++
 4 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index c67825a68a26..685037e052af 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2856,6 +2856,18 @@ mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 }
 EXPORT_SYMBOL(mlxsw_core_port_devlink_port_get);
 
+bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u8 local_port)
+{
+	const struct mlxsw_bus_info *bus_info = mlxsw_core->bus_info;
+	int i;
+
+	for (i = 0; i < bus_info->xm_local_ports_count; i++)
+		if (bus_info->xm_local_ports[i] == local_port)
+			return true;
+	return false;
+}
+EXPORT_SYMBOL(mlxsw_core_port_is_xm);
+
 struct mlxsw_env *mlxsw_core_env(const struct mlxsw_core *mlxsw_core)
 {
 	return mlxsw_core->env;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index ec424d388ecc..6558f9cde3d6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -223,6 +223,7 @@ enum devlink_port_type mlxsw_core_port_type_get(struct mlxsw_core *mlxsw_core,
 struct devlink_port *
 mlxsw_core_port_devlink_port_get(struct mlxsw_core *mlxsw_core,
 				 u8 local_port);
+bool mlxsw_core_port_is_xm(const struct mlxsw_core *mlxsw_core, u8 local_port);
 struct mlxsw_env *mlxsw_core_env(const struct mlxsw_core *mlxsw_core);
 bool mlxsw_core_is_initialized(const struct mlxsw_core *mlxsw_core);
 int mlxsw_core_module_max_width(struct mlxsw_core *mlxsw_core, u8 module);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index c010db2c9dba..b34c44723f8b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -291,7 +291,8 @@ static int mlxsw_m_ports_create(struct mlxsw_m *mlxsw_m)
 
 	/* Create port objects for each valid entry */
 	for (i = 0; i < mlxsw_m->max_ports; i++) {
-		if (mlxsw_m->module_to_port[i] > 0) {
+		if (mlxsw_m->module_to_port[i] > 0 &&
+		    !mlxsw_core_port_is_xm(mlxsw_m->core, i)) {
 			err = mlxsw_m_port_create(mlxsw_m,
 						  mlxsw_m->module_to_port[i],
 						  i);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index df8175cd44ab..516d6cb45c9f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -1840,6 +1840,9 @@ static int mlxsw_sp_port_module_info_init(struct mlxsw_sp *mlxsw_sp)
 		return -ENOMEM;
 
 	for (i = 1; i < max_ports; i++) {
+		if (mlxsw_core_port_is_xm(mlxsw_sp->core, i))
+			continue;
+
 		err = mlxsw_sp_port_module_info_get(mlxsw_sp, i, &port_mapping);
 		if (err)
 			goto err_port_module_info_get;
-- 
2.29.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B61C2D7C80
	for <lists+netdev@lfdr.de>; Fri, 11 Dec 2020 18:11:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391714AbgLKRJa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Dec 2020 12:09:30 -0500
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:57075 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2394495AbgLKRHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Dec 2020 12:07:09 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 83D5BA7C;
        Fri, 11 Dec 2020 12:05:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Fri, 11 Dec 2020 12:05:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=9WNoADTgn1nqJd/n49xMeBwUsm9R9L+YyEqzWf11NCU=; b=IAva1gSR
        1QUV/6akYL87PG9qmpOuO2flJZHEE3H0lJ1/W3Us079AAUTXljF9lyXDXxVu9p7c
        HH73lowqCYrqY7cLoaVaxSl4boOpscOVH8KcpS+dPdb/Gi+/XrCpc9uuHVj4fYiT
        r/aETw/dpmyVCSvtvKAAQyggMhoKgvkTTbtTNCl3VS5/3VKQIAt8YefV6RzhpCEA
        AHorU8tqzFT6SKKFxDaFGDeHSjlroSAHyY48nC5pXT/pSXRaKhnyL9Ea4iBWUeJu
        G8gs1HIwQfcHXXSndxa9hGzK3Gv/OLNB1dNfVTPX32zmoVlbJKbN8XFh6Cg5sH+j
        sB+AHPcboAet5g==
X-ME-Sender: <xms:zqbTX-MuZYmUGfe6kHx0Re9cI28DYMhl8AiB5nVv0U8hpkBys52_1Q>
    <xme:zqbTX2YeuijKE3xcvzUU4Eq04g1nE3EOX7UafzgplzU9-5-d_9AG1SL0vEALEXnip
    yL2YI1Py3lniSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudekvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrudehfedrjeek
    necuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:zqbTX03jLFfDcUxt6e_o27na1SkBq0LjhD1QCo3gVGAMqWbbKWf16A>
    <xmx:zqbTX0cJO0t9OIsmXb0MQVKi0DmKmlE0vAz_gd-QUSEevij7ZgqnIg>
    <xmx:zqbTX9GjGU1FuTCOoDRRKSxNGu7Jy_NGlRRcxJt3uxXjl9tkc0jj5g>
    <xmx:zqbTXxjoU0u7vje_U_i9mhRi2BTVwqVNuwBlwM7ixX9pSnGzwDFEuQ>
Received: from shredder.lan (igld-84-229-153-78.inter.net.il [84.229.153.78])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A5E41080057;
        Fri, 11 Dec 2020 12:05:16 -0500 (EST)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 05/15] mlxsw: Ignore ports that are connected to eXtended mezanine
Date:   Fri, 11 Dec 2020 19:04:03 +0200
Message-Id: <20201211170413.2269479-6-idosch@idosch.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201211170413.2269479-1-idosch@idosch.org>
References: <20201211170413.2269479-1-idosch@idosch.org>
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


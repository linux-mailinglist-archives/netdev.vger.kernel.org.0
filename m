Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45BEE3D135
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 17:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391802AbfFKPpq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 11:45:46 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:60005 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391780AbfFKPpp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 11:45:45 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 6008122220;
        Tue, 11 Jun 2019 11:45:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 11 Jun 2019 11:45:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=Q2x6VpDi3QJmg6q7+vZjWASyDeKYYiFC525Y7aejnkU=; b=C2lQb1tJ
        X7amF01IvXi+PTnoiJuQ2I2yZnUR5O+ZQZqInogZCyo3lD43i/gpgGfDPi5fer2a
        E+9Ttj5AZgthfTbiSIKVHPjlI3CMbzbvfrSav/1nUEXzfD/vqotOsJ9iUgq085m+
        jK7Yn96bYLKqP4m6s/qz8YOrYJsBYNYHwZtDnIZkFJppW4y5PAItJB652imgkxJu
        GgQKaRjpy2o+9ZxXqAjQI3QsX+k5fNNsPhl4JmH+JWa2jiXuyce/O8NYr/MXKkDE
        TlVcapxjWQsq2PP0zyTrKdfoXTRzByVQLDWF1rWfq1gye+5wr9xXPo0zDvqiXZh7
        n6It5VB4G/1efw==
X-ME-Sender: <xms:qMz_XN99x0RzQleKxJA4hmrv3ZjzyydFWSFzzJajb9411EJl1fxKxQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudehhedgjeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpedt
X-ME-Proxy: <xmx:qMz_XFhx7H17LwfNa3wboReZr7cCR2GHxowwiyBVlms1wY5DmJbwdw>
    <xmx:qMz_XJOivsSGgAAQLvbbiOtSGr1ImTlJr9vJt_IxGLAMx2jw5cPHuA>
    <xmx:qMz_XLSnMeWR6J0a64G_n13a7fDWmFaAlRKJcfqEldNYhvx-Gzmo8Q>
    <xmx:qMz_XAgrdmxVIQHsAdTJ2hSXpgmFGi3RiPY3FtG879b1jM8krQ_RFg>
Received: from splinter.mtl.com (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 91627380085;
        Tue, 11 Jun 2019 11:45:42 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, shalomt@mellanox.com,
        petrm@mellanox.com, richardcochran@gmail.com, olteanv@gmail.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 2/9] mlxsw: core: Add a new interface for reading the hardware free running clock
Date:   Tue, 11 Jun 2019 18:45:05 +0300
Message-Id: <20190611154512.17650-3-idosch@idosch.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190611154512.17650-1-idosch@idosch.org>
References: <20190611154512.17650-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Shalom Toledo <shalomt@mellanox.com>

Add two new bus operations for reading the hardware free running clock.

Signed-off-by: Shalom Toledo <shalomt@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 12 ++++++++++++
 drivers/net/ethernet/mellanox/mlxsw/core.h |  8 +++++++-
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1c4ef8ed1706..30e0526a9cf6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2026,6 +2026,18 @@ int mlxsw_core_resources_query(struct mlxsw_core *mlxsw_core, char *mbox,
 }
 EXPORT_SYMBOL(mlxsw_core_resources_query);
 
+u32 mlxsw_core_read_frc_h(struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->bus->read_frc_h(mlxsw_core->bus_priv);
+}
+EXPORT_SYMBOL(mlxsw_core_read_frc_h);
+
+u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core)
+{
+	return mlxsw_core->bus->read_frc_l(mlxsw_core->bus_priv);
+}
+EXPORT_SYMBOL(mlxsw_core_read_frc_l);
+
 static int __init mlxsw_core_module_init(void)
 {
 	int err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index a44ad0fb9477..6dbb0ede502e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -309,6 +309,9 @@ int mlxsw_core_kvd_sizes_get(struct mlxsw_core *mlxsw_core,
 void mlxsw_core_fw_flash_start(struct mlxsw_core *mlxsw_core);
 void mlxsw_core_fw_flash_end(struct mlxsw_core *mlxsw_core);
 
+u32 mlxsw_core_read_frc_h(struct mlxsw_core *mlxsw_core);
+u32 mlxsw_core_read_frc_l(struct mlxsw_core *mlxsw_core);
+
 bool mlxsw_core_res_valid(struct mlxsw_core *mlxsw_core,
 			  enum mlxsw_res_id res_id);
 
@@ -339,6 +342,8 @@ struct mlxsw_bus {
 			char *in_mbox, size_t in_mbox_size,
 			char *out_mbox, size_t out_mbox_size,
 			u8 *p_status);
+	u32 (*read_frc_h)(void *bus_priv);
+	u32 (*read_frc_l)(void *bus_priv);
 	u8 features;
 };
 
@@ -356,7 +361,8 @@ struct mlxsw_bus_info {
 	struct mlxsw_fw_rev fw_rev;
 	u8 vsd[MLXSW_CMD_BOARDINFO_VSD_LEN];
 	u8 psid[MLXSW_CMD_BOARDINFO_PSID_LEN];
-	u8 low_frequency;
+	u8 low_frequency:1,
+	   read_frc_capable:1;
 };
 
 struct mlxsw_hwmon;
-- 
2.20.1


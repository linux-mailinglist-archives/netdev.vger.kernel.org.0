Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41E91279F69
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 09:51:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730524AbgI0HvF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Sep 2020 03:51:05 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:55779 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730517AbgI0HvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Sep 2020 03:51:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 759B248E;
        Sun, 27 Sep 2020 03:51:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 27 Sep 2020 03:51:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=3K4zOuFcYktPWxOpNFHTljrov4V3PvakVPwJTNoFVXE=; b=tUaU37cs
        bo1Db5u9oJYoCFgf7H7JUVsuU+hXTXAripQvXsGZf/5sKn+3pinfUm2/MAeFIXaX
        Mrf0yN07JOfZdaScsZzVtKh4cZfGhYSRkAaSkteOzuKlEQ8zb9D8D/7zm5L5zb/P
        XwPcLSU9q6VVFsmKBwhplNiG86uzTPvxul9aLOCXTmOF603yj/3moNn8/rikVz+h
        BTQf/D1kAWRfd9cxBytHEZFUSgAobd8A25XP/6fDgfHgvPFuO2mkEL/tB3wXGGwl
        a2x9+GiPyTVqvBWDIQ94L5hg7HmiOXiPtCxCr55iaQuy/P9aW3DR0WADXmVRqIeu
        qMKu/8L55okeXA==
X-ME-Sender: <xms:ZERwX_cekL2ljRSpio2o_m4bnkeOfRMH6mGyVnl_po7YRnA2bmtSbQ>
    <xme:ZERwX1M12Tf_2l3SCWr0-a0DBcly7O6vh-WDwohT3bxzyvD4t5sjj9jMM5Hh3NNeH
    XNMZpF5u3pkKwI>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvdefgdduudeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeejrddugeek
    necuvehluhhsthgvrhfuihiivgepjeenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:ZURwX4ieSAe0ooSgd43wZyNx0rZqNuNVU1s-WAtv97QYRJCU04j52w>
    <xmx:ZURwXw8cnbL7H3ORg0JH2TcOd2kFpT6eH3J2LmAJcBwEpAkgMI8nRQ>
    <xmx:ZURwX7swMlCMWPAH_YXi368M0Iv-RCarHnOcErMf7Jf6fvLt4lOWYg>
    <xmx:ZURwX7Iwc_Q8Xgo2wau5PDn-dX560ZxwieLoN9tuJ7jTQXUXYfxjTg>
Received: from shredder.lan (igld-84-229-37-148.inter.net.il [84.229.37.148])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1E73E328005A;
        Sun, 27 Sep 2020 03:50:58 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, amcohen@nvidia.com,
        jiri@nvidia.com, mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 10/10] mlxsw: spectrum_ethtool: Expose transceiver_overheat counter
Date:   Sun, 27 Sep 2020 10:50:15 +0300
Message-Id: <20200927075015.1417714-11-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200927075015.1417714-1-idosch@idosch.org>
References: <20200927075015.1417714-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

Add structures for port statistics which read from core and not directly
from registers.

When netdev's ethtool statistics are queried, query the corresponding
module's overheat counter from core and expose it as
"transceiver_overheat".

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_ethtool.c         | 57 ++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 6045d3df00ef..2096b6478958 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -2,6 +2,7 @@
 /* Copyright (c) 2020 Mellanox Technologies. All rights reserved */
 
 #include "reg.h"
+#include "core.h"
 #include "spectrum.h"
 #include "core_env.h"
 
@@ -552,6 +553,37 @@ static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_tc_stats[] = {
 
 #define MLXSW_SP_PORT_HW_TC_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_hw_tc_stats)
 
+struct mlxsw_sp_port_stats {
+	char str[ETH_GSTRING_LEN];
+	u64 (*getter)(struct mlxsw_sp_port *mlxsw_sp_port);
+};
+
+static u64
+mlxsw_sp_port_get_transceiver_overheat_stats(struct mlxsw_sp_port *mlxsw_sp_port)
+{
+	struct mlxsw_sp_port_mapping port_mapping = mlxsw_sp_port->mapping;
+	struct mlxsw_core *mlxsw_core = mlxsw_sp_port->mlxsw_sp->core;
+	u64 stats;
+	int err;
+
+	err = mlxsw_env_module_overheat_counter_get(mlxsw_core,
+						    port_mapping.module,
+						    &stats);
+	if (err)
+		return mlxsw_sp_port->module_overheat_initial_val;
+
+	return stats - mlxsw_sp_port->module_overheat_initial_val;
+}
+
+static struct mlxsw_sp_port_stats mlxsw_sp_port_transceiver_stats[] = {
+	{
+		.str = "transceiver_overheat",
+		.getter = mlxsw_sp_port_get_transceiver_overheat_stats,
+	},
+};
+
+#define MLXSW_SP_PORT_HW_TRANSCEIVER_STATS_LEN ARRAY_SIZE(mlxsw_sp_port_transceiver_stats)
+
 #define MLXSW_SP_PORT_ETHTOOL_STATS_LEN (MLXSW_SP_PORT_HW_STATS_LEN + \
 					 MLXSW_SP_PORT_HW_RFC_2863_STATS_LEN + \
 					 MLXSW_SP_PORT_HW_RFC_2819_STATS_LEN + \
@@ -561,7 +593,8 @@ static struct mlxsw_sp_port_hw_stats mlxsw_sp_port_hw_tc_stats[] = {
 					 (MLXSW_SP_PORT_HW_PRIO_STATS_LEN * \
 					  IEEE_8021QAZ_MAX_TCS) + \
 					 (MLXSW_SP_PORT_HW_TC_STATS_LEN * \
-					  TC_MAX_QUEUE))
+					  TC_MAX_QUEUE) + \
+					  MLXSW_SP_PORT_HW_TRANSCEIVER_STATS_LEN)
 
 static void mlxsw_sp_port_get_prio_strings(u8 **p, int prio)
 {
@@ -637,6 +670,12 @@ static void mlxsw_sp_port_get_strings(struct net_device *dev,
 			mlxsw_sp_port_get_tc_strings(&p, i);
 
 		mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_strings(&p);
+
+		for (i = 0; i < MLXSW_SP_PORT_HW_TRANSCEIVER_STATS_LEN; i++) {
+			memcpy(p, mlxsw_sp_port_transceiver_stats[i].str,
+			       ETH_GSTRING_LEN);
+			p += ETH_GSTRING_LEN;
+		}
 		break;
 	}
 }
@@ -732,6 +771,17 @@ static void __mlxsw_sp_port_get_stats(struct net_device *dev,
 	}
 }
 
+static void __mlxsw_sp_port_get_env_stats(struct net_device *dev, u64 *data, int data_index,
+					  struct mlxsw_sp_port_stats *port_stats,
+					  int len)
+{
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	int i;
+
+	for (i = 0; i < len; i++)
+		data[data_index + i] = port_stats[i].getter(mlxsw_sp_port);
+}
+
 static void mlxsw_sp_port_get_stats(struct net_device *dev,
 				    struct ethtool_stats *stats, u64 *data)
 {
@@ -786,6 +836,11 @@ static void mlxsw_sp_port_get_stats(struct net_device *dev,
 	mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats(mlxsw_sp_port,
 						    data, data_index);
 	data_index += mlxsw_sp_port->mlxsw_sp->ptp_ops->get_stats_count();
+
+	/* Transceiver counters */
+	__mlxsw_sp_port_get_env_stats(dev, data, data_index, mlxsw_sp_port_transceiver_stats,
+				      MLXSW_SP_PORT_HW_TRANSCEIVER_STATS_LEN);
+	data_index += MLXSW_SP_PORT_HW_TRANSCEIVER_STATS_LEN;
 }
 
 static int mlxsw_sp_port_get_sset_count(struct net_device *dev, int sset)
-- 
2.26.2


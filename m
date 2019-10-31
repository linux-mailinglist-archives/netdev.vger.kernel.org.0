Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1CEEACBA
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:43:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfJaJm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:42:58 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:44307 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727260AbfJaJm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:42:58 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 1AAE821FE5;
        Thu, 31 Oct 2019 05:42:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=DaqfTJWtf9Xx4M6DmXUfYx6a0ixw0y5paZbtyyB+9UQ=; b=hedMwiQy
        DqiSfHke7XHq8eqDlGvRZCBc/VhcSSD3Hg+cljvlKn+Q9Y1fI1xl1Unh6TC+9yIH
        OeP81Hm0FCQ4pAvmucE5edkXIaWEJkIPEa7qByjiKKhydVOHuWiYMmvik9sySc8c
        HGYXxCLRcYENGqni1j3PlVnrSTNLCG4Pyu6yasqSy3q7CK4n1R3ByAqCuWBUNTlC
        SQ6VuHAbNmxhOPhPh3t1kFLm5yf8rLNU8zU4RR7PmLTk9ayZOQtHkIIANy1F7mnO
        Fz9i0iG45xj19dJlkcO9lFFRhIGnlJhZQ1pBdGrL+yPwsAXdjQq7rRYv1fvY5hPl
        +Hq1TfnCcXWH2Q==
X-ME-Sender: <xms:oKy6Xf3vdZRRFmjpm6yKbrWzpFagh3clmD8i4QWedObd9njPd33Qbg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeej
X-ME-Proxy: <xmx:oKy6XaZGkny0wHOz8qN7IuBMsw7-ueBdGirdw8I8iQfkO8EYkzZTzw>
    <xmx:oKy6XRjbvkRWEoeuWT17-BJATTzY6amtUJ6iGLiATw5AxbLGetZY_g>
    <xmx:oKy6XR-Yf9Gb1eoRUWvE8SUmJG9P9qEAaq_be0DWOdeyf4gh9ZainQ>
    <xmx:oay6XT8AoqLHfwYjJyfFoiAn1DVlvXqPAbm9ZsHzBaGYnCN6JZcJTQ>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 88D2A80060;
        Thu, 31 Oct 2019 05:42:55 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 09/16] mlxsw: spectrum: Add sanity checks into module info get
Date:   Thu, 31 Oct 2019 11:42:14 +0200
Message-Id: <20191031094221.17526-10-idosch@idosch.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20191031094221.17526-1-idosch@idosch.org>
References: <20191031094221.17526-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@mellanox.com>

Driver assumes certain values in the PMLP register. Add checks that
verify that PMLP register provides fitting values.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 39 ++++++++++++++++++-
 1 file changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 68f1461d9919..938803cd29ca 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -22,6 +22,7 @@
 #include <linux/inetdevice.h>
 #include <linux/netlink.h>
 #include <linux/jhash.h>
+#include <linux/log2.h>
 #include <net/switchdev.h>
 #include <net/pkt_cls.h>
 #include <net/tc_act/tc_mirred.h>
@@ -753,14 +754,48 @@ mlxsw_sp_port_module_info_get(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 			      struct mlxsw_sp_port_mapping *port_mapping)
 {
 	char pmlp_pl[MLXSW_REG_PMLP_LEN];
+	bool separate_rxtx;
+	u8 module;
+	u8 width;
 	int err;
+	int i;
 
 	mlxsw_reg_pmlp_pack(pmlp_pl, local_port);
 	err = mlxsw_reg_query(mlxsw_sp->core, MLXSW_REG(pmlp), pmlp_pl);
 	if (err)
 		return err;
-	port_mapping->module = mlxsw_reg_pmlp_module_get(pmlp_pl, 0);
-	port_mapping->width = mlxsw_reg_pmlp_width_get(pmlp_pl);
+	module = mlxsw_reg_pmlp_module_get(pmlp_pl, 0);
+	width = mlxsw_reg_pmlp_width_get(pmlp_pl);
+	separate_rxtx = mlxsw_reg_pmlp_rxtx_get(pmlp_pl);
+
+	if (width && !is_power_of_2(width)) {
+		dev_err(mlxsw_sp->bus_info->dev, "Port %d: Unsupported module config: width value is not power of 2\n",
+			local_port);
+		return -EINVAL;
+	}
+
+	for (i = 0; i < width; i++) {
+		if (mlxsw_reg_pmlp_module_get(pmlp_pl, i) != module) {
+			dev_err(mlxsw_sp->bus_info->dev, "Port %d: Unsupported module config: contains multiple modules\n",
+				local_port);
+			return -EINVAL;
+		}
+		if (separate_rxtx &&
+		    mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, i) !=
+		    mlxsw_reg_pmlp_rx_lane_get(pmlp_pl, i)) {
+			dev_err(mlxsw_sp->bus_info->dev, "Port %d: Unsupported module config: TX and RX lane numbers are different\n",
+				local_port);
+			return -EINVAL;
+		}
+		if (mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, i) != i) {
+			dev_err(mlxsw_sp->bus_info->dev, "Port %d: Unsupported module config: TX and RX lane numbers are not sequential\n",
+				local_port);
+			return -EINVAL;
+		}
+	}
+
+	port_mapping->module = module;
+	port_mapping->width = width;
 	port_mapping->lane = mlxsw_reg_pmlp_tx_lane_get(pmlp_pl, 0);
 	return 0;
 }
-- 
2.21.0


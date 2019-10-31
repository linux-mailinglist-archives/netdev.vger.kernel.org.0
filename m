Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAE1EACB8
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 10:42:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727268AbfJaJm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 05:42:56 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:49087 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727260AbfJaJmz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 05:42:55 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 373D0210D8;
        Thu, 31 Oct 2019 05:42:54 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 31 Oct 2019 05:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; bh=Qx8cYBYeYvuyUPW8Zf8EnmubEXwBkAoVSgID8NCNLT8=; b=M23dSLV5
        cr80OCWJj0Awb/G5JGPd/AxqswDt/hz9cIveCKN8QGPjrcfkDKfdIJPIflI2uE71
        ZxElCUBxi/NX4p1KKKSayYqc3jXml7Tb+kezl/cZ4DSF0hLtuvuzyA3lLoGmse1Q
        G07w0r0aKix6u+z63HZanpAHP1OITv9mYAgW4Q1Zy8btOlATnwmf4tz0gNQbRb+Z
        vd+Vi+peqw09MMKo8EDiFUMjbhjZace0tQvDUbKM2lJ/a7/khE2HCW3tt+UTcNhC
        KNhFGmpwUvPid8WWojBSkk8s/5eJUDNw07papa/ByBW+NApbYZwYSaD6QhnoWfpg
        i0TkdnnrwvUfsw==
X-ME-Sender: <xms:nay6XQNhOA0DHcMUnsKiIYC6NHXxgNouqjs1i6iAIYCHbC7guRXvLQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedruddthedgtdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecukfhppeduleefrdegjedrudeihedrvdehudenucfrrghrrghmpe
    hmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrghenucevlhhushhtvghr
    ufhiiigvpeef
X-ME-Proxy: <xmx:nay6XXZ4AHBG47HJY0MCuHvi0vfNxniKJK6rWdGlAso5NOQkbV1Gfw>
    <xmx:nay6XYvklyn2KkhhO0VInvxJrkc7w9JGXaoml_oPvGsEJxje2DoPQA>
    <xmx:nay6XYtY0JNX92f4Ax8HzDnTBFTxeb00rQJ8dADdPYkKvXeomW34HQ>
    <xmx:nqy6XVZ1dQ5br0dq51aDHDcdVzNl2awIvqOiktXp5tXhfpGUmXdslg>
Received: from localhost.localdomain (unknown [193.47.165.251])
        by mail.messagingengine.com (Postfix) with ESMTPA id 74FED80070;
        Thu, 31 Oct 2019 05:42:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 07/16] mlxsw: spectrum: Use mapping of port being split for creating split ports
Date:   Thu, 31 Oct 2019 11:42:12 +0200
Message-Id: <20191031094221.17526-8-idosch@idosch.org>
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

Don't use constant max width value and instead of that, use the actual
width of the port. Also don't pass module value and use the value
stored in the same structure.

Signed-off-by: Jiri Pirko <jiri@mellanox.com>
Reviewed-by: Shalom Toledo <shalomt@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum.c    | 23 +++++++++++--------
 1 file changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index ee15428ca740..2145975af103 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -4074,16 +4074,18 @@ static u8 mlxsw_sp_cluster_base_port_get(u8 local_port, unsigned int max_width)
 	return local_port - offset;
 }
 
-static int mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
-				      u8 module, unsigned int count, u8 offset,
-				      unsigned int max_width)
+static int
+mlxsw_sp_port_split_create(struct mlxsw_sp *mlxsw_sp, u8 base_port,
+			   struct mlxsw_sp_port_mapping *port_mapping,
+			   unsigned int count, u8 offset)
 {
-	u8 width = max_width / count;
+	u8 width = port_mapping->width / count;
 	int err, i;
 
 	for (i = 0; i < count; i++) {
 		err = mlxsw_sp_port_create(mlxsw_sp, base_port + i * offset,
-					   true, module, width, i * width);
+					   true, port_mapping->module,
+					   width, i * width);
 		if (err)
 			goto err_port_create;
 	}
@@ -4127,9 +4129,10 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 {
 	struct mlxsw_sp *mlxsw_sp = mlxsw_core_driver_priv(mlxsw_core);
 	u8 local_ports_in_1x, local_ports_in_2x, offset;
+	struct mlxsw_sp_port_mapping port_mapping;
 	struct mlxsw_sp_port *mlxsw_sp_port;
-	u8 module, base_port;
 	int max_width;
+	u8 base_port;
 	int i;
 	int err;
 
@@ -4155,8 +4158,6 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		return -EINVAL;
 	}
 
-	module = mlxsw_sp_port->mapping.module;
-
 	max_width = mlxsw_core_module_max_width(mlxsw_core,
 						mlxsw_sp_port->mapping.module);
 	if (max_width < 0) {
@@ -4199,12 +4200,14 @@ static int mlxsw_sp_port_split(struct mlxsw_core *mlxsw_core, u8 local_port,
 		}
 	}
 
+	port_mapping = mlxsw_sp_port->mapping;
+
 	for (i = 0; i < count; i++)
 		if (mlxsw_sp_port_created(mlxsw_sp, base_port + i * offset))
 			mlxsw_sp_port_remove(mlxsw_sp, base_port + i * offset);
 
-	err = mlxsw_sp_port_split_create(mlxsw_sp, base_port, module, count,
-					 offset, max_width);
+	err = mlxsw_sp_port_split_create(mlxsw_sp, base_port, &port_mapping,
+					 count, offset);
 	if (err) {
 		dev_err(mlxsw_sp->bus_info->dev, "Failed to create split ports\n");
 		goto err_port_split_create;
-- 
2.21.0


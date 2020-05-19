Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 303951D9805
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 15:41:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbgESNlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 09:41:12 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:44789 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728633AbgESNlK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 09:41:10 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 441AF581896;
        Tue, 19 May 2020 09:41:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 19 May 2020 09:41:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=zxMDTFYee0OyJtOWLiF6/d3aTUhZSVJE2kNPLOfgW5k=; b=3GDMJrVn
        f+/S4W9EIOS4+hX5Ybb7bTRmTJC1prq8H808pfqt2SxjsF4aT7AlE/Nq5lVxDtX4
        BGdehU0FcbI3qcxSO//Bbaf1MQ+V/NWRb+mF9igolPzj94VRd0VDFScmUptqaTvv
        0+WDCW9OI29aguC2zdVNb4bVd9J+4NWXvWTBjNGL0H75ZyUmKYpUlsUHJ2vbXOrc
        cwqxbjeGs4yV6XkAp6XBQaD5xuCXUcZ/3YP2HNJEmw/AA0a8lU5xHjjxl4X+sYB/
        ljTTqPUycGwB5ByQFWlc42COnDnlMFc2sb/P11VEaPegGmkkfAk9qCxIIsuNCb5+
        ZFo/VT6JNSOfAA==
X-ME-Sender: <xms:9eHDXgiaJmUq7XKoeI8BOWF8dzHQWWVD-C6mvAEq_f7UYBzjPFYvKw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedruddtjedgieejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeejledrudejiedrvdegrddutdej
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:9eHDXpDhKPfKx0Yf_UA889NFBuPCuYNG2FSeDhTp_vTsvOg9krGMCg>
    <xmx:9eHDXoHCL787McWPWvnuzflGpCGGVMiuw83cPXpsRAOkOANESYjsrw>
    <xmx:9eHDXhQj5cF47p1VS9Xz-PC2Kh9VtfTN0MfcLMwpIfpf5eSwAQrAgQ>
    <xmx:9eHDXj6_Ts4t02VNKfgh1LrlFsssuQVOtf_FbknLv4V4MCuviOubNw>
Received: from splinter.mtl.com (bzq-79-176-24-107.red.bezeqint.net [79.176.24.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 81D31328006A;
        Tue, 19 May 2020 09:41:06 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/3] mlxsw: Set port width attribute in driver
Date:   Tue, 19 May 2020 16:40:30 +0300
Message-Id: <20200519134032.1006765-2-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200519134032.1006765-1-idosch@idosch.org>
References: <20200519134032.1006765-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Danielle Ratson <danieller@mellanox.com>

Currently, port attributes like flavour, port number and whether the
port was split are set when initializing a port.

Set the width of the port as well so that it could be easily passed to
devlink in the next patch.

Signed-off-by: Danielle Ratson <danieller@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
Signed-off-by: Ido Schimmel <idosch@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c     | 6 ++++--
 drivers/net/ethernet/mellanox/mlxsw/core.h     | 1 +
 drivers/net/ethernet/mellanox/mlxsw/minimal.c  | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 1 +
 drivers/net/ethernet/mellanox/mlxsw/switchib.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/switchx2.c | 2 +-
 6 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index e9ccd333f61d..8f1ef90c7f5a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -2122,6 +2122,7 @@ static int __mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 				  enum devlink_port_flavour flavour,
 				  u32 port_number, bool split,
 				  u32 split_port_subnumber,
+				  u32 width,
 				  const unsigned char *switch_id,
 				  unsigned char switch_id_len)
 {
@@ -2154,13 +2155,14 @@ static void __mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port)
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 			 u32 port_number, bool split,
 			 u32 split_port_subnumber,
+			 u32 width,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len)
 {
 	return __mlxsw_core_port_init(mlxsw_core, local_port,
 				      DEVLINK_PORT_FLAVOUR_PHYSICAL,
 				      port_number, split, split_port_subnumber,
-				      switch_id, switch_id_len);
+				      width, switch_id, switch_id_len);
 }
 EXPORT_SYMBOL(mlxsw_core_port_init);
 
@@ -2181,7 +2183,7 @@ int mlxsw_core_cpu_port_init(struct mlxsw_core *mlxsw_core,
 
 	err = __mlxsw_core_port_init(mlxsw_core, MLXSW_PORT_CPU_PORT,
 				     DEVLINK_PORT_FLAVOUR_CPU,
-				     0, false, 0,
+				     0, false, 0, 0,
 				     switch_id, switch_id_len);
 	if (err)
 		return err;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.h b/drivers/net/ethernet/mellanox/mlxsw/core.h
index 22b0dfa7cfae..28f7b1c156b0 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.h
@@ -193,6 +193,7 @@ void *mlxsw_core_port_driver_priv(struct mlxsw_core_port *mlxsw_core_port);
 int mlxsw_core_port_init(struct mlxsw_core *mlxsw_core, u8 local_port,
 			 u32 port_number, bool split,
 			 u32 split_port_subnumber,
+			 u32 width,
 			 const unsigned char *switch_id,
 			 unsigned char switch_id_len);
 void mlxsw_core_port_fini(struct mlxsw_core *mlxsw_core, u8 local_port);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/minimal.c b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
index c4caeeadcba9..f9c9d7baf3be 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/minimal.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/minimal.c
@@ -164,7 +164,7 @@ mlxsw_m_port_create(struct mlxsw_m *mlxsw_m, u8 local_port, u8 module)
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_m->core, local_port,
-				   module + 1, false, 0,
+				   module + 1, false, 0, 0,
 				   mlxsw_m->base_mac,
 				   sizeof(mlxsw_m->base_mac));
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index f78bde8bc16e..52e1c8263963 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -3250,6 +3250,7 @@ static int mlxsw_sp_port_create(struct mlxsw_sp *mlxsw_sp, u8 local_port,
 	err = mlxsw_core_port_init(mlxsw_sp->core, local_port,
 				   port_mapping->module + 1, split,
 				   port_mapping->lane / port_mapping->width,
+				   port_mapping->width,
 				   mlxsw_sp->base_mac,
 				   sizeof(mlxsw_sp->base_mac));
 	if (err) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchib.c b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
index 4ff1e623aa76..1b446e6071b2 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchib.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchib.c
@@ -281,7 +281,7 @@ static int mlxsw_sib_port_create(struct mlxsw_sib *mlxsw_sib, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sib->core, local_port,
-				   module + 1, false, 0,
+				   module + 1, false, 0, 0,
 				   mlxsw_sib->hw_id, sizeof(mlxsw_sib->hw_id));
 	if (err) {
 		dev_err(mlxsw_sib->bus_info->dev, "Port %d: Failed to init core port\n",
diff --git a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
index 90535820b559..5ec161409954 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/switchx2.c
@@ -1107,7 +1107,7 @@ static int mlxsw_sx_port_eth_create(struct mlxsw_sx *mlxsw_sx, u8 local_port,
 	int err;
 
 	err = mlxsw_core_port_init(mlxsw_sx->core, local_port,
-				   module + 1, false, 0,
+				   module + 1, false, 0, 0,
 				   mlxsw_sx->hw_id, sizeof(mlxsw_sx->hw_id));
 	if (err) {
 		dev_err(mlxsw_sx->bus_info->dev, "Port %d: Failed to init core port\n",
-- 
2.26.2


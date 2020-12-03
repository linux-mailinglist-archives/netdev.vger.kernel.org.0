Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8ED2CCDDB
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:23:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgLCEWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:22:08 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:16984 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727629AbgLCEWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:22:07 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc867c60001>; Wed, 02 Dec 2020 20:21:26 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:21:26 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next V2 07/15] net/mlx5e: Move MLX5E_RX_ERR_CQE macro
Date:   Wed, 2 Dec 2020 20:21:00 -0800
Message-ID: <20201203042108.232706-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201203042108.232706-1-saeedm@nvidia.com>
References: <20201203042108.232706-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.13.39]
X-ClientProxiedBy: HQMAIL107.nvidia.com (172.20.187.13) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606969286; bh=bS7d1Z192hH0vI/HioQ1z2/he6UPG/E+INAU1DFLVW8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=R1EqXoEgbhxejQsBoX85k48x8VpzJy+hkU+3wiHwWlqdZ3aQ7+ospKzXDcl1Y0spI
         vREnTsH72zFF9cF7KyEVIGpmECEKQzJsqTnmuyProvMQC0sgzzMpOvbAzw2/mcKJ0g
         wb9/2BElXym2de7eCkjVsV6G99VBPFbrWoxFqRtaDUpBmm77jAKoeJbyDlwzdnlF9d
         c2cpdahk2BlZu8x0IfJsSXnXYYo5SvjTElNHi9SMeiDOruhUGKloGLPA4oIO9nBmg+
         9/KDtAdNe3C57sprbblw49blgzZfBarx0r4i2kgrlYQ5yrf1FNgN15EixjSx/toHOx
         eKXVPgx5Y3Tfg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

MLX5E_RX_ERR_CQE Macro is used only in data-path, move it to the
appropriate header file.

Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/health.h | 2 --
 drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h   | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h b/drivers/=
net/ethernet/mellanox/mlx5/core/en/health.h
index f88fbbe06995..018262d0164b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/health.h
@@ -7,8 +7,6 @@
 #include "en.h"
 #include "diag/rsc_dump.h"
=20
-#define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) !=3D MLX5_CQE_RESP_SEND=
)
-
 static inline bool cqe_syndrome_needs_recover(u8 syndrome)
 {
 	return syndrome =3D=3D MLX5_CQE_SYNDROME_LOCAL_QP_OP_ERR ||
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h b/drivers/ne=
t/ethernet/mellanox/mlx5/core/en/txrx.h
index 115ab19ffab1..7943eb30b837 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/txrx.h
@@ -24,6 +24,8 @@
=20
 #define INL_HDR_START_SZ (sizeof(((struct mlx5_wqe_eth_seg *)NULL)->inline=
_hdr.start))
=20
+#define MLX5E_RX_ERR_CQE(cqe) (get_cqe_opcode(cqe) !=3D MLX5_CQE_RESP_SEND=
)
+
 enum mlx5e_icosq_wqe_type {
 	MLX5E_ICOSQ_WQE_NOP,
 	MLX5E_ICOSQ_WQE_UMR_RX,
--=20
2.26.2


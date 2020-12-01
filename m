Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC0D2CB061
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbgLAWnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:11 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15925 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbgLAWnG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:06 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6d10001>; Tue, 01 Dec 2020 14:42:25 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:25 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Eran Ben Elisha" <eranbe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "Saeed Mahameed" <saeedm@nvidia.com>
Subject: [net-next 07/15] net/mlx5e: Move MLX5E_RX_ERR_CQE macro
Date:   Tue, 1 Dec 2020 14:42:00 -0800
Message-ID: <20201201224208.73295-8-saeedm@nvidia.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201201224208.73295-1-saeedm@nvidia.com>
References: <20201201224208.73295-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [10.124.1.5]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1606862545; bh=bS7d1Z192hH0vI/HioQ1z2/he6UPG/E+INAU1DFLVW8=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=r2E8R9Myh6cXWfhtDVrt4N7d686p2DnL+k/+iTc7IVzSPtEYf503opfyucmSIOsZQ
         IMV7Dk5Jttl7TDkJKTFZEP/UPldfqlYDscfk4uj47kkdl4p0xH5IWUY9aYFtI/tfMp
         1qxOHzyQovLzdlj3qnLV+vwUtm37PADoFeDXFj05oN+xqkHNCh9AtHZOYmIH7fTIXN
         hpCd5koqsU2kP3RX/kAfRNLYLD5Vs69Olw/Z2ODMWHK2kS/XZlu1EAsR3YbazYvYjq
         BDLFijAV2V/PBfAlzPN/VAIlLOwvI8f6DQcon9axmnIXYJTlR/3R8MPOglAeC5WiM8
         nEiFQfn6D8LqQ==
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


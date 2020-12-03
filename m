Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDDEB2CCDE5
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 05:23:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728178AbgLCEWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 23:22:49 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:17029 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728030AbgLCEWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 23:22:48 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc867c90001>; Wed, 02 Dec 2020 20:21:29 -0800
Received: from sx1.mtl.com (172.20.13.39) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Thu, 3 Dec
 2020 04:21:29 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Zhu Yanjun" <yanjunz@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next V2 10/15] net/mlx5e: remove unnecessary memset
Date:   Wed, 2 Dec 2020 20:21:03 -0800
Message-ID: <20201203042108.232706-11-saeedm@nvidia.com>
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
        t=1606969289; bh=Bs8cuZ/pKDC1j13K+/EKdTN8ggDTH6qbij09U44VVtM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=lY4WTVoP3P2eqLD6ENy72Lh2UKKPcyL2dYeTrLKddik2qHmK5S1vVlTGlV+TUpkfr
         ZjoFxa9PjtM5fGkayfQ3NFCWO5psoVXlXLY2a9Yu9YoC/O6MIxNu7a/ATwuxxJPVDR
         2lo6mLPkcmvcgrJes8t7qYyX55z3RkKuS0CbqvvzZBzgyiasPx1ztNTMnN6KCpEusm
         0ynFHcnBXGHR+3IHqTIaQTJpYIch9jEAuqpfB0rqxqw96fJaxiBYsn/I9uzpS/Csw9
         omadBDhvA1R9o2PZdJZneIw1N0fvUOmTcZ591G4xmPs/pfzgkNB1f/NeVt1ZbaZ5/Y
         GN6ccxpseMyVg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjunz@nvidia.com>

Since kvzalloc will initialize the allocated memory, it is not
necessary to initialize it once again.

Fixes: 11b717d61526 ("net/mlx5: E-Switch, Get reg_c0 value on CQE")
Signed-off-by: Zhu Yanjun <yanjunz@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/d=
rivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index c9c2962ad49f..f68a4afeefb8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -1680,7 +1680,6 @@ static int esw_create_restore_table(struct mlx5_eswit=
ch *esw)
 		goto out_free;
 	}
=20
-	memset(flow_group_in, 0, inlen);
 	match_criteria =3D MLX5_ADDR_OF(create_flow_group_in, flow_group_in,
 				      match_criteria);
 	misc =3D MLX5_ADDR_OF(fte_match_param, match_criteria,
--=20
2.26.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDA82CB063
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 23:44:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgLAWnl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 17:43:41 -0500
Received: from hqnvemgate25.nvidia.com ([216.228.121.64]:9918 "EHLO
        hqnvemgate25.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgLAWnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 17:43:40 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate25.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fc6c6d40001>; Tue, 01 Dec 2020 14:42:28 -0800
Received: from sx1.mtl.com (10.124.1.5) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Dec
 2020 22:42:27 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Zhu Yanjun" <yanjunz@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/15] net/mlx5e: remove unnecessary memset
Date:   Tue, 1 Dec 2020 14:42:03 -0800
Message-ID: <20201201224208.73295-11-saeedm@nvidia.com>
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
        t=1606862548; bh=Bs8cuZ/pKDC1j13K+/EKdTN8ggDTH6qbij09U44VVtM=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Exj7hZL1YE8DiaMWpX2CtjUuTypbhznhHFmQFOx2YrYOn5x6zGqVtvuq97Fg5Xr2d
         bZSgKMMeALv4897XbXHa6vJjoAl9YXt2HRlVfzMobNZp+3djTOBPrGMch6UNNz8xPL
         BZ6x9LCBYbLUMmypAO2op/zQv02b7NcXufFrfpNK2s78siYQs3ArMx4JrT8RDvb/ia
         BrYOf5r4nn4Jv7TUPppQevbJ96h7pmG70TfYLNdiLG8MSrz/u4MLKr0Jj/Tl9nV5wc
         qx7O6ngjZnUAOjhDY/Rrgf5XMlBLN+9ACePaOFEc31C1eVG1MBGzA3OjnsbGfCPZT5
         NpoMXWWGwBI2A==
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


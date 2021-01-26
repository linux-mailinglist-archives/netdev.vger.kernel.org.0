Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507F33050C7
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 05:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238610AbhA0E0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 23:26:35 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:2354 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388678AbhAZXZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jan 2021 18:25:24 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B6010a4bb0001>; Tue, 26 Jan 2021 15:24:43 -0800
Received: from sx1.mtl.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 26 Jan
 2021 23:24:42 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, Aya Levin <ayal@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 04/14] net/mlx5: Register to devlink DMAC filter trap
Date:   Tue, 26 Jan 2021 15:24:09 -0800
Message-ID: <20210126232419.175836-5-saeedm@nvidia.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210126232419.175836-1-saeedm@nvidia.com>
References: <20210126232419.175836-1-saeedm@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL101.nvidia.com (172.20.187.10) To
 HQMAIL107.nvidia.com (172.20.187.13)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1611703483; bh=NrSiiixKttJ5MHEpdDtv063/vhkIDXYq1JkKDa99oDE=;
        h=From:To:CC:Subject:Date:Message-ID:X-Mailer:In-Reply-To:
         References:MIME-Version:Content-Transfer-Encoding:Content-Type:
         X-Originating-IP:X-ClientProxiedBy;
        b=Li+hSWvFOFLBNpL2LuLScFx0XIQeN3K19KHN6kQWWZh8Iq9ouLXiVPpO75noizegU
         g+tQ5tH75MP47376KCnZEGk1gnD/nivpNLpilQqN1DUGerOAmPF40HJmJOjZyznGnX
         3X4mC1npc5Z5opZm5zZfTmPUweEcUMTcHqbksFzfZVHueWwlFMqsII9R8Z7/tCG9DB
         ZHUhdxiG8/ARonITuCl2YN+jHX1fFykxlPCdUBornL1eW0InCIFtvYfe24+YhSQ9sF
         ZvowcMIp1N0cWQDbmV3QnUg/IeR31oT32seP3C/PzSlLlb+QiP3ZW/Vn8HVigUM1/S
         kYy3JYLoID9ug==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aya Levin <ayal@nvidia.com>

Core driver is registered to the devlink traps service, which enables the
admin to redeem packets that were destined to be dropped due to a
particular reason. Register to DMAC filter, allow visibility of packets
that were filtered out by the MAC table.

Signed-off-by: Aya Levin <ayal@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c b/drivers/ne=
t/ethernet/mellanox/mlx5/core/devlink.c
index 8c2f886ac78e..f081eff9be25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/devlink.c
@@ -449,6 +449,7 @@ static void mlx5_devlink_set_params_init_values(struct =
devlink *devlink)
=20
 static const struct devlink_trap mlx5_traps_arr[] =3D {
 	MLX5_TRAP_DROP(INGRESS_VLAN_FILTER, L2_DROPS),
+	MLX5_TRAP_DROP(DMAC_FILTER, L2_DROPS),
 };
=20
 static const struct devlink_trap_group mlx5_trap_groups_arr[] =3D {
--=20
2.29.2


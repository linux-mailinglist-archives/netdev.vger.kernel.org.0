Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0A5F383B23
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 19:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242684AbhEQRV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 13:21:29 -0400
Received: from azhdrrw-ex01.nvidia.com ([20.51.104.162]:1247 "EHLO
        AZHDRRW-EX01.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242681AbhEQRVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 13:21:25 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.170)
 by mxs.oss.nvidia.com (10.13.234.36) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.858.12; Mon, 17 May 2021 10:05:07 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oFncMk3ZhQusxQZwDt+pZcU9WdzzZy9J/ThGIOnj7v/G9+lJuuqrKmR6GEYO5A4Q7I6dYdfbP+4HopG3cDDW14YRWch2jxpFrlBQQ1Zk74TbOZbO9lrnEKO/QR9cojFImC4MDjheTe5hPzgu4e4bccHHbQ24156vqydppnelHMTcJnWIMDEdMi8qZNgCNMqZki3QMjeU+ZBuyQ3A8m54gP//GkLbBCUKqwvL4A0bjWI01VUZhQjqy6b3pL+ntYoXyiVsHXZfl7P8kOwp2te/qsIPqd9fxOiI25r3iAZcFY0Vd8mkDowUCr9WSfhcKDI2HgtLaaT7CGZpt1Y+L01eAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9IjEKhVWFFc+4IKGHN8/Wbq+8lnCzRT3eXCA4tTMV4=;
 b=P+B/EvbS6SMC9SsS9BI79K6vdXQrVZ9U3vnIoaaDezhX5c6LaqnGTTsF/XCRY6gljkOSVzQmCT9nitfu4DUu17T8eIKUIXWW71HqBgjgXoSg+vk4KfxGCJPsEhOqOnbyjL9Dcm65ACkuCwk5BVCsMumfBvR+WzgPZ5A5AuihtgPJfQTrL7gycIiBmbbPptFZP4FILE/C9zl11GCDAUKS9uHfm3kK8LI8r7Mn5/8kMcz2MGDXlt9A0nkFmA20rwM/YKye6EfAdOlRU/0cOsvjR9DIaOuUdKkN2wOuu34Ec0tUOykQEaJZ17nVWt6MNcWiIPOoKaMAtnZOCJxUpld6Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.112.34) smtp.rcpttodomain=oracle.com smtp.mailfrom=nvidia.com;
 dmarc=pass (p=none sp=none pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9IjEKhVWFFc+4IKGHN8/Wbq+8lnCzRT3eXCA4tTMV4=;
 b=m3DOQZU+oOkc27Ga0Q8Cj9Qz0AGBFnMNd9Q7wty6riqCJFm1NXOItxXpKG+hBep/X9uDpc+1CfExA18gb3Jrph7WmGFoe+pa9ZCt2NHRxskuP4GP4bywOZ2kqzkNmxb56VgOam8cjRrsjY+4ZOOXny0FTZx1PW0ZiO/x8X+yu2StUcoBAI6TvVC51slZmT12a7WszZx7pRV2jgxVv8F/J7SayPFNDWT48L2Ger//YszTUY31U9X2H8V90uvVrHUtuIWiVHsFqZtMnwIEufXp3fq36TP/TV87EiFPFLXClwlCCn0IjMtoZv0MgtvCG0NeTTjLXZSPQqdmnEhN0N6amA==
Received: from DM5PR07CA0136.namprd07.prod.outlook.com (2603:10b6:3:13e::26)
 by DM4PR12MB5168.namprd12.prod.outlook.com (2603:10b6:5:397::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Mon, 17 May
 2021 17:05:07 +0000
Received: from DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
 (2603:10b6:3:13e:cafe::1b) by DM5PR07CA0136.outlook.office365.com
 (2603:10b6:3:13e::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.28 via Frontend
 Transport; Mon, 17 May 2021 17:05:07 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.112.34)
 smtp.mailfrom=nvidia.com; oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.112.34 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.112.34; helo=mail.nvidia.com;
Received: from mail.nvidia.com (216.228.112.34) by
 DM6NAM11FT049.mail.protection.outlook.com (10.13.172.188) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4129.25 via Frontend Transport; Mon, 17 May 2021 17:05:06 +0000
Received: from shredder.mellanox.com (172.20.145.6) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 17 May
 2021 17:05:02 +0000
From:   Ido Schimmel <idosch@OSS.NVIDIA.COM>
To:     <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <jiri@OSS.NVIDIA.COM>,
        <petrm@OSS.NVIDIA.COM>, <danieller@OSS.NVIDIA.COM>,
        <amcohen@OSS.NVIDIA.COM>, <mlxsw@OSS.NVIDIA.COM>,
        Ido Schimmel <idosch@OSS.NVIDIA.COM>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH net-next 09/11] mlxsw: spectrum_router: Avoid missing error code warning
Date:   Mon, 17 May 2021 20:03:59 +0300
Message-ID: <20210517170401.188563-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517170401.188563-1-idosch@nvidia.com>
References: <20210517170401.188563-1-idosch@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.20.145.6]
X-ClientProxiedBy: HQMAIL105.nvidia.com (172.20.187.12) To
 HQMAIL107.nvidia.com (172.20.187.13)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0f665559-a444-43e0-2536-08d91955ebee
X-MS-TrafficTypeDiagnostic: DM4PR12MB5168:
X-Microsoft-Antispam-PRVS: <DM4PR12MB516803F7B254C3B52F44D52AB22D9@DM4PR12MB5168.namprd12.prod.outlook.com>
X-MS-Exchange-Transport-Forked: True
X-MS-Oob-TLC-OOBClassifiers: OLM:126;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nF6sNQJBt7WvvpVSIm7ehXdgk8CB6dfvcBFkCIOXYOBiL5K8YJuwoM1wsFr6KWsRw70+JKCjWu57f0URPRvDEl1vkqKeuvaif5Elcy40zOvQ1ADmOG4cD3m0NkVF4t41TChOG31+k/Sm18Pg+7O6GB24q1Gq8erCT+rPbI2z8r5ZlKcjg0f1M2OUfES2LrKMz6ovfRie2M083SjpfwRWBx9FVLQ03LBc4KUTKyTBVenT1620gpZkcy4JZDDFLDukjGjzlM+2O2gMQG/+fham9AbjRU6Ae9W4k07jWWNcuA4TK0cQFfJuIjPGnSwPZa8H9CQPzvqjBgpd8YpQsQ2ATMMAsljzyrtUICVWMPPTBMoKdOd/jh5/nSCcVOTWW42I2jV23Jx092AP44GJtrY7oALBkP1yBn6QJDcpqjLOw2OOweE7BQ5WWTNiK3quqfOiO4F7coHmuFqTmutW18jXmqdGUsrN9zko+ZHsacjgU/dIBYrreTg4oID4yi+tQVX+V60dQKrIRmOEJ/INOg4rSfgH3zmv73URfIApP/7okzu3uVg/Zo244V8kvQnGDA0QXT5rj1iGNZYEkkSGnRYiOCbkrw2F9nSGMlL4QWcQt8jYVKcpQ0JFGZqkw1O25zgE2fmjvw7pSzsZ0FKwSwaGvYtKBfU29ZY5KiN2Sfm+UsQNEMPgaYotf3AUQFayfX1OV+iTaSvFFOYmW8h1KXKpwzSk5ORjdfMIrqL5UE56cxA=
X-Forefront-Antispam-Report: CIP:216.228.112.34;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:schybrid03.nvidia.com;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(39860400002)(36840700001)(46966006)(426003)(186003)(16526019)(66574015)(47076005)(26005)(82310400003)(356005)(36756003)(316002)(7636003)(83380400001)(36906005)(54906003)(336012)(82740400003)(1076003)(966005)(2906002)(6666004)(107886003)(4326008)(36860700001)(86362001)(8676002)(2616005)(5660300002)(8936002)(70586007)(6916009)(70206006)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2021 17:05:06.9633
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f665559-a444-43e0-2536-08d91955ebee
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.112.34];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT049.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5168
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Explicitly set the error code to zero before the goto statement to avoid
the following smatch warning:

drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c:3598 mlxsw_sp_nexthop_group_refresh() warn: missing error code 'err'

The warning is a false positive, but the change both suppresses the
warning and makes it clear to future readers that this is not an error
path.

The original report and discussion can be found here [1].

[1] https://lore.kernel.org/lkml/202105141823.Td2h3Mbi-lkp@intel.com/

Cc: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 99015dca86c9..ec2af77a126d 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -3844,8 +3844,8 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 	bool offload_change = false;
 	u32 adj_index;
 	bool old_adj_index_valid;
-	int i, err2, err = 0;
 	u32 old_adj_index;
+	int i, err2, err;
 
 	if (!nhgi->gateway)
 		return mlxsw_sp_nexthop_fib_entries_update(mlxsw_sp, nh_grp);
@@ -3875,11 +3875,13 @@ mlxsw_sp_nexthop_group_refresh(struct mlxsw_sp *mlxsw_sp,
 		return 0;
 	}
 	mlxsw_sp_nexthop_group_normalize(nhgi);
-	if (!nhgi->sum_norm_weight)
+	if (!nhgi->sum_norm_weight) {
 		/* No neigh of this group is connected so we just set
 		 * the trap and let everthing flow through kernel.
 		 */
+		err = 0;
 		goto set_trap;
+	}
 
 	ecmp_size = nhgi->sum_norm_weight;
 	err = mlxsw_sp_fix_adj_grp_size(mlxsw_sp, &ecmp_size);
-- 
2.31.1


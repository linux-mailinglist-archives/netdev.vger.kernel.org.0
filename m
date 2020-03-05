Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E536B17B22A
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 00:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbgCEXSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 18:18:13 -0500
Received: from mail-am6eur05on2074.outbound.protection.outlook.com ([40.107.22.74]:62017
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726650AbgCEXSM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Mar 2020 18:18:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OeoUpvdFpG4FRRnmHn76Ra4KDK7GS8wMQJkQkMntiRZXwmYtz7sTGdvlr20tzNqSzhGOKePWT69/Wc+gYT9gFF0Lk7kyRVMsqsXAiA5q/AsBv5pfRWVoOM1qP8AgUoCY4cxm0+KJ3KU9JLTsY2wiIuz+wJ3fm6xYhEIDfFNqXZHj6HENOYBcUmbHMlHocukmQpXirtL8f16f9jUVmaS4eIhMYS7Uadu+RHAWOZk3gLErYptwr80PBhLezmRhFBsjs0D6lW1Qsqcmz/hJ7oCmoRHhjlE0Mov7VZ944yqu1Ow68gjEgsUyl/vFH9zuF8wY8Dr18R+t5Y/PzVgXGQ8RrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5aoJcwjehoZXvPPEy42xPuKtM9V/TQQoJWSGOK63vc=;
 b=hXvdRXHaLjOkMv2KAknvMUYUpRJXTXTa5sNZlvTXZV6vk/F2kbyO+qUMDhCadeEdvCprPr1Gn3AxCk1MDUk/C25297MBGjSKH3xvv0p9zQNakC5tiao3u4sYKGqLVFUQRKy4EGBVmMRM86JTHTPANOAuQnFM8uVhvmlR4kldfDiEI2i3+suhShbRgD4kjjNXHRMoc8hyW45imYtziQ5/BenSCB7wN+zf/vc22eo0BIpw2n/KpYf4N3rKwz57/RDjnaOkPH4b3gD+IdfPgYDp6oNry9UmGaEydmohbJcSeYCFKui0WmD8oH1taajij5XA3LkF6UQKgbdgg3l+N1N94A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=r5aoJcwjehoZXvPPEy42xPuKtM9V/TQQoJWSGOK63vc=;
 b=Gkgva3AKSLpuYf7eNIhSq7LgPAcKPf04SDGm87ukQVvyF25xDL48sWyXYmhQ3hMrPxkRUe1eg2YB50ttqjMjsfMheTjL50I7OrfknlcpBmXpwB1k3i93NJbO7STpa4WGygHCLhrNqCACp6ZQp/Ii/0OTEYfENSZjKTw++L5kVJ4=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.15; Thu, 5 Mar 2020 23:18:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Thu, 5 Mar 2020
 23:18:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, Eli Cohen <eli@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Raed Salem <raeds@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net 5/5] net/mlx5: Clear LAG notifier pointer after unregister
Date:   Thu,  5 Mar 2020 15:17:39 -0800
Message-Id: <20200305231739.227618-6-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200305231739.227618-1-saeedm@mellanox.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR06CA0042.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::19) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR06CA0042.namprd06.prod.outlook.com (2603:10b6:a03:14b::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.14 via Frontend Transport; Thu, 5 Mar 2020 23:18:02 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 28c76f60-7701-43f1-3aa4-08d7c15b74d2
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41895793CE89FDF9F9B5126ABEE20@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:765;
X-Forefront-PRVS: 03333C607F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(2906002)(81166006)(6506007)(5660300002)(6512007)(4326008)(81156014)(6486002)(52116002)(8676002)(54906003)(36756003)(8936002)(66556008)(66476007)(66946007)(2616005)(316002)(1076003)(86362001)(6666004)(956004)(186003)(6916009)(26005)(16526019)(478600001)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TbfdU+YHSiS49b6Tqqrn1WPe3ieH5h6vLHjmNlU9G7HTOJBn9hkielkrWNi0x/4gf/9XzGmhDCACLjG9LTtQc5OckTunYgCA4+qvuexVbv5X3SqG0sPOfR8c6a0W/I455d5iF2wzuveQuuEm9D7ccbrySWuXnZFxuU0mDnpdr1fwgxXrHPHOgfc2Kev86iJ/WOEac6XNosmZx053sfhbHALBIKhJT0yX9/K/B6+KwVsce9PHPLIuFzNptZHJ4yvYi5n4wW/0qJMNIAB4J9ZuAwq/W0uQjy+Qg0xRdiaIJW3ObKGA0xhU07qpNZZHEuV1LBZ63xalY07LkOUnGiw9KX1lOmNr8JuQ1jR1eij0cy2ZMrLBI+yMBiViwRgYAyzsS5oRzULZjqd7/iqpO9p9O2kfCMY4/sO6vZuD45ivLkzlYlAEzY22UUsir1thv0haw8gEjGXlbQ+7aA+W3dF2niYLeCt6dXO3hnQNqP748CysA+3yFuiDxt3TPhpXVxoyRKW0gHKll1MoMeia8nuO2Giqea6zyQ0e5rL7/w+eQ9k=
X-MS-Exchange-AntiSpam-MessageData: ALwAZRg5OiSTiPfWBpSPmVys5+9wL6NzuQFJiGv5gfAZyYo4NFV6XDhbLdqUkzPd/2GfB1L/WZ6NEqjB70shXVl53IuK5ORN1hbUbpAbhycJax7P4HCGwwMOtk63kjWnwHagrHFIpRcq7hx49onELQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28c76f60-7701-43f1-3aa4-08d7c15b74d2
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Mar 2020 23:18:04.5701
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: y7AhkbtruyDWkA1V8lLIV/RWHLi2plrQ+4jZNf0YSTfu4sd8Bs5t8iTkWtz5xeiQ1O0ctgOJKkrTa4buUX5hGQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eli Cohen <eli@mellanox.com>

After returning from unregister_netdevice_notifier_dev_net(), set the
notifier_call field to NULL so successive call to mlx5_lag_add() will
function as expected.

Fixes: 7907f23adc18 ("net/mlx5: Implement RoCE LAG feature")
Signed-off-by: Eli Cohen <eli@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Reviewed-by: Raed Salem <raeds@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/lag.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lag.c b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
index 8e19f6ab8393..93052b07c76c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lag.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lag.c
@@ -615,8 +615,10 @@ void mlx5_lag_remove(struct mlx5_core_dev *dev)
 			break;
 
 	if (i == MLX5_MAX_PORTS) {
-		if (ldev->nb.notifier_call)
+		if (ldev->nb.notifier_call) {
 			unregister_netdevice_notifier_net(&init_net, &ldev->nb);
+			ldev->nb.notifier_call = NULL;
+		}
 		mlx5_lag_mp_cleanup(ldev);
 		cancel_delayed_work_sync(&ldev->bond_work);
 		mlx5_lag_dev_free(ldev);
-- 
2.24.1


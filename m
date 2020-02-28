Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DA73F172DA2
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 01:45:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730506AbgB1Apq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 19:45:46 -0500
Received: from mail-eopbgr130081.outbound.protection.outlook.com ([40.107.13.81]:20112
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730441AbgB1Apq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Feb 2020 19:45:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dpd1VeRvL3ObewcodOggIZJ0Bm3dB2sa2HN2jkXjnh1hWQzw/hmQAqmlx9w/euMSmDiCQhbI9Qbrr0ncqzj33Z8gX7YFjJMDarnL143Ao5I+Uq45RGZ6FGOatjagPfEoaWKsu45TGjMRDmxleev8apA6+2kB8tTYMJEODPoaRbRNbIIGKt+Wn7spAiKreYU6C6kJoDMRZh182VNOEiaYAa1k74J8B3KvcozL1KDuvapWGsHhTHr7HtWPxAOoQseOh08gaPkOEvfMhsMb1U3qlJKckZntMQjgVqEoOLTJh1fwmD/Zvdo/frFIKlhbmv/DcMI+sjCgJo38T8u2gFPrXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvg4qxLfMsiRjK+hkSceltQ5XNPyaorYi/Lk1L7x7q8=;
 b=fdeLyOESwYKhyLJmUAfTscj9kk4qVhKbRurYVbFCT2UnIhE6bwdvF1zLhWt0WyINox3gBPw+3IKpo117uXX0qeYNzmbEbz1tdfQJdk1jA6kM+1tLy/TiFO1phoQ/b04sLuvvgP7ZXgoqS+s6bniT6BbXs0fiMnEHJix1x1KJqkrY4akYpxz8BAR1MXziq5gx/2djbxIgRhlivZJFFA/yEyBqUPN4EuvHvIrnFOAICeh27RbPYR3d/ueObGbo16I4ZXhQV5McpAilaPjPhhyXDDjiWTlTnKL8n/qpiZQvCzK/GF24pRxYcjQQy8RUrSt6eRHMA5q/195D0gm+a1ry0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uvg4qxLfMsiRjK+hkSceltQ5XNPyaorYi/Lk1L7x7q8=;
 b=RLurxxJnjwpe/oJQcaEq1TEJZIzuBqNl7b3O76T6WeoiXLbaE9hwr/m7VZwF/nqyKkNhL/JZ5BQgpfmLofQoleD7hGhLpWoss+iZqVK45Rfj1hXm7pCUVw7ez3OMvrJVzI8YQVEBk4lLuedGe2gvKbM2mZPs1qA94hM+aY/PzhM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4189.eurprd05.prod.outlook.com (52.133.14.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.14; Fri, 28 Feb 2020 00:45:34 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.024; Fri, 28 Feb 2020
 00:45:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@mellanox.com>,
        Vlad Buslov <vladbu@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 11/16] net/mlx5e: Use netdev_warn() for errors for added prefix
Date:   Thu, 27 Feb 2020 16:44:41 -0800
Message-Id: <20200228004446.159497-12-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200228004446.159497-1-saeedm@mellanox.com>
References: <20200228004446.159497-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0004.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BY5PR04CA0004.namprd04.prod.outlook.com (2603:10b6:a03:1d0::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.14 via Frontend Transport; Fri, 28 Feb 2020 00:45:32 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 81b118c1-7e69-44d9-25f8-08d7bbe78504
X-MS-TrafficTypeDiagnostic: VI1PR05MB4189:|VI1PR05MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB41891B0A2FDB983F04DE5ED9BEE80@VI1PR05MB4189.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-Forefront-PRVS: 0327618309
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(39860400002)(366004)(376002)(396003)(136003)(199004)(189003)(66556008)(66946007)(66476007)(6506007)(316002)(4326008)(6512007)(107886003)(478600001)(52116002)(54906003)(6486002)(26005)(8676002)(6666004)(81166006)(86362001)(8936002)(16526019)(186003)(36756003)(81156014)(5660300002)(2616005)(956004)(2906002)(1076003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4189;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ToXg+Sch/LvHTzyg3y5Nx+e/La8hQIGxXbB+l8fySSoklSUcV8DdQMA4tbeENz1vOzh+JzohP/g1gDDBgKBThVbc7xwx0yyv9Hmznh4hFDmc84FS947lQiNzoG+M/68yuQqtg8R3i74LZOxmvmcEIYXGF5jI4APp3QOnX7rtmHMiV7dkC9v45uXW/7wkysL0JMbhQEj3LTBqc4hCvIc8DhS4i3O7zCfHAPs1qGNSAmvPRYv8qipmVVTP5yyOIJd8O64gncYhlCC7b8XvXTDKNMxIQ3pGHFUr8oeRsnUHLIUQWFySyjKfKGvsa/VKU6y+uth7IFSdDfPDQjZCIlhBZB9JP99MGxVQqVvUFy7GnLMrrWpKa483uK9lNc1DR9CByhzm/ODRSy6QSp4uuVKbeykd47cRppW6Fo07zPEkjLuBClHVt1m7sANUNVCktXldlAsms1n3kjfhkr0oDXRvnK5iwRdyomDEu9jkj5J44D/GDkrwVfeu4Z99wVnyreyb1H8apovyOlPEqhqrzHjaxF+0LOXljDGUAQe7LAVLLf4=
X-MS-Exchange-AntiSpam-MessageData: 1MUloQUzKUHyG2xNINwGNKDb3J31MbnrxHJX4up6yOSzKTHoUdPi7cHTWKIIM6vUG3DVaFa9pTosoRoW1vwOa4OfsYyOV0TEshZ15rDBF2WIL393W8oE31mmiDdp6ENXSchKGRDuYgosdTqPPntqiA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 81b118c1-7e69-44d9-25f8-08d7bbe78504
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2020 00:45:34.1744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WerisfglzqT4MOlNdteNtekPoznIybc2ZGxGz8dfhhWCZRuiQCCZwSKUA9dbIXZMXfqqL0GBWSKnzh3xG9wipA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4189
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

This helps identify the source of the message.
If netdev still doesn't exists use mlx5_core_warn().

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Vlad Buslov <vladbu@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  | 27 +++++++++++--------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 045a40214425..b67ed0e62d37 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -192,7 +192,8 @@ static MLX5E_DECLARE_STATS_GRP_OP_UPDATE_STATS(vport_rep)
 
 	err = mlx5_eswitch_get_vport_stats(esw, rep->vport, &vf_stats);
 	if (err) {
-		pr_warn("vport %d error %d reading stats\n", rep->vport, err);
+		netdev_warn(priv->netdev, "vport %d error %d reading stats\n",
+			    rep->vport, err);
 		return;
 	}
 
@@ -2032,8 +2033,9 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 		  &mlx5e_uplink_rep_profile : &mlx5e_rep_profile;
 	netdev = mlx5e_create_netdev(dev, profile, nch, rpriv);
 	if (!netdev) {
-		pr_warn("Failed to create representor netdev for vport %d\n",
-			rep->vport);
+		mlx5_core_warn(dev,
+			       "Failed to create representor netdev for vport %d\n",
+			       rep->vport);
 		kfree(rpriv);
 		return -EINVAL;
 	}
@@ -2051,29 +2053,32 @@ mlx5e_vport_rep_load(struct mlx5_core_dev *dev, struct mlx5_eswitch_rep *rep)
 
 	err = mlx5e_attach_netdev(netdev_priv(netdev));
 	if (err) {
-		pr_warn("Failed to attach representor netdev for vport %d\n",
-			rep->vport);
+		netdev_warn(netdev,
+			    "Failed to attach representor netdev for vport %d\n",
+			    rep->vport);
 		goto err_destroy_mdev_resources;
 	}
 
 	err = mlx5e_rep_neigh_init(rpriv);
 	if (err) {
-		pr_warn("Failed to initialized neighbours handling for vport %d\n",
-			rep->vport);
+		netdev_warn(netdev,
+			    "Failed to initialized neighbours handling for vport %d\n",
+			    rep->vport);
 		goto err_detach_netdev;
 	}
 
 	err = register_devlink_port(dev, rpriv);
 	if (err) {
-		esw_warn(dev, "Failed to register devlink port %d\n",
-			 rep->vport);
+		netdev_warn(netdev, "Failed to register devlink port %d\n",
+			    rep->vport);
 		goto err_neigh_cleanup;
 	}
 
 	err = register_netdev(netdev);
 	if (err) {
-		pr_warn("Failed to register representor netdev for vport %d\n",
-			rep->vport);
+		netdev_warn(netdev,
+			    "Failed to register representor netdev for vport %d\n",
+			    rep->vport);
 		goto err_devlink_cleanup;
 	}
 
-- 
2.24.1


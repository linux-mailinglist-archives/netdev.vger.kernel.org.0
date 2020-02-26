Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1574C16F4D6
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 02:13:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730052AbgBZBNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 20:13:33 -0500
Received: from mail-eopbgr60067.outbound.protection.outlook.com ([40.107.6.67]:15414
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729908AbgBZBNb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 20:13:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NGJ7fI6t3ObHbr64laGCFxmV5CKKLxd4UcCZFqvuf5IT0H/3reK9mx4CDFeqk769Kt4UGgQLSqAsVeKVrxnuyMYHzKh/I8YMecrwcvxIw5LSxtg1XC586ZKY3AxA5yPiVM1SpTsbaBpHAUb0T5C+EdMLBeKK+XOtYl3lD9IKw2nHLJ0wfqGbjujE2VPRBYg+s83k+815J9InoJ8wQDs8vfypciDpZ9fXmFueDQfKmPGqaInVYIAl/PUCg1TCiTtzz2mJXpTqBaojUFn95X9sKjJ7nd152tnq9qcHhI3iUGI+bPPsxEAQzKTz0ci9Hafg9k/tBKnk4PfvZlDHGe1hZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHLFtiLCbUc5q892lgA97jhaNwDpPSHGBdrrzi0to8w=;
 b=c1c/Mqlq8gwC18sqUNWCBNdBJK162vRq97y+/IsdaTx3A88ou1Cx8aIhMwtV3fOKkcsV3lQFFJNLNKKJNxNUnWun1QKyc6hEfHHjXjyl8C0SErUWEBECHy5U0KWwqzewP3mBcKfDGIBgU4eJKcxBQAVfMh5A30R5Gnuuq3hXVbcb/weTJz5953HGCsJ2RXoFxnss4mSDrkyDZImnb8rG3DefgsKGu4QXQTywoDgU+BYoG3Z7DCKTmSFH24ARu+kZ995SR8zizfvrSXPZw+YkplKTcn6j/ZijWPg4n9UxqEF7ZCEKdmrUTq+PXd83bTLGV+jffcBazR09KjoEe6pRrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nHLFtiLCbUc5q892lgA97jhaNwDpPSHGBdrrzi0to8w=;
 b=OhcL0SGO/s2spsf9uQ16e3STqzsI032AbJrUCA1ICy6CVRMkqM6anmnfdyXRZeZYFNRSI+hkkbbYYjF6np3lpoc/6xQyO+0+rtl/gH23HBZ+rebzMvAu53I/NYwEaxj1y+dHkfQe3wlZ3H3eMJgNjG25MrdLmmDsbjHdtCwuKGA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5869.eurprd05.prod.outlook.com (20.178.205.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2750.18; Wed, 26 Feb 2020 01:13:27 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2750.021; Wed, 26 Feb 2020
 01:13:27 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>, kuba@kernel.org
Cc:     netdev@vger.kernel.org, Maxim Mikityanskiy <maximmi@mellanox.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 07/16] net/mlx5e: Remove unneeded netif_set_real_num_tx_queues
Date:   Tue, 25 Feb 2020 17:12:37 -0800
Message-Id: <20200226011246.70129-8-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200226011246.70129-1-saeedm@mellanox.com>
References: <20200226011246.70129-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR04CA0019.namprd04.prod.outlook.com
 (2603:10b6:a03:1d0::29) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR04CA0019.namprd04.prod.outlook.com (2603:10b6:a03:1d0::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Wed, 26 Feb 2020 01:13:24 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: fee3a6af-a34b-49c8-a15a-08d7ba591522
X-MS-TrafficTypeDiagnostic: VI1PR05MB5869:|VI1PR05MB5869:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB5869C0DD15C44E2A165C3971BEEA0@VI1PR05MB5869.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:334;
X-Forefront-PRVS: 0325F6C77B
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(66946007)(66556008)(2906002)(81166006)(66476007)(5660300002)(81156014)(6666004)(8936002)(86362001)(8676002)(54906003)(1076003)(4326008)(6512007)(316002)(52116002)(478600001)(2616005)(186003)(107886003)(956004)(36756003)(6506007)(26005)(6486002)(16526019)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5869;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2kq5jCK/4BBxJ9Gbauxjzy6IkgMZroDEX4WhKaqmMijUOMg7wFo3G1oEywQSuh0ydaC4w6v5Yxk4f7LLCKs6rPfy2FEUGzhEBMiEADcU6kXOjTHajvaJlRVUM73aT79ro40nTQ6CDtha7yEJdReA4B6sGYiuw6TXGC9YQiKZUrfR8HU2KWFAeAMErPffXwyLsgGWPb9M8BDKTGx6PRXHwqxoeC/TmPqwlptsJJa5pTFO36cuyfkyL1fMLYCaoKugxTWBrkV7rKLaEiWr47IPXzBdv9qpMGw3z0tNCVjD1TJnak6ZSTDn9lNT4J+exNlCxNXHH1WQgmw2hoaQpf+og9LkO9hRn+m6prIvLpd0d7LZskgdR4sjsjiVSb/xOsy45/x75OMbI6gllHA6aoDjxgw40mbgXc0QF666H7eV4rzR2Ku8ha3HnW+kyqMdUr/hWMRI+A4Wsd3c2qQIVVY8IADlT09xZfHNgbLN1XO6cgZTWZiQns1VsLgLOZ4mF0j5ckMflonO8SvwVu4ZQwcnlVo5CCqs7czZeoisuFsSQ5c=
X-MS-Exchange-AntiSpam-MessageData: 7vJtzSrD+3tdJMj5hAv5IcILgBJ4/5EyuW2aYLY0r+nQpT5nfJ1+gttfN+8emQF9z2GoGnPPX5KSqgZu0Qt++QTq5t2XVZavtTmjeo+tVGn+TL1lVfaRw7ojwH1euwOXDJ7MY4cIt1bs+3IktohZNw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fee3a6af-a34b-49c8-a15a-08d7ba591522
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2020 01:13:26.9509
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JK8TYtw55OK7WPb17/UCj/uiov0SLnPCp7iZD9g3qJ8H3V4f/mtSV3eAzDf2DEWehfWoc3k8RL2qZ5evUzBn5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5869
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

The number of queues is now updated by mlx5e_update_netdev_queues in a
centralized way, when no channels are active. Remove an extra occurrence
of netif_set_real_num_tx_queues to prepare it for the next commit.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Tariq Toukan <tariqt@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 4906d609aa55..ceeb9faad9ef 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -2942,17 +2942,11 @@ static void mlx5e_switch_priv_channels(struct mlx5e_priv *priv,
 				       mlx5e_fp_preactivate preactivate)
 {
 	struct net_device *netdev = priv->netdev;
-	int new_num_txqs;
 	int carrier_ok;
 
-	new_num_txqs = new_chs->num * new_chs->params.num_tc;
-
 	carrier_ok = netif_carrier_ok(netdev);
 	netif_carrier_off(netdev);
 
-	if (new_num_txqs < netdev->real_num_tx_queues)
-		netif_set_real_num_tx_queues(netdev, new_num_txqs);
-
 	mlx5e_deactivate_priv_channels(priv);
 	mlx5e_close_channels(&priv->channels);
 
-- 
2.24.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECCB01853C5
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:17:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgCNBRO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:17:14 -0400
Received: from mail-eopbgr50046.outbound.protection.outlook.com ([40.107.5.46]:31971
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726591AbgCNBRM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:17:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KI9/7xqwxsukIRJgG8Pzsw1CRZxM59jcBITg3eUXUnll2yBH6ZA1KsqGKCiwx4fbYwIUuKd0wSXROBR+4p8Ut9BLqppLzcmXMpsbjwaS5nrscK8Aj+ede0Np5Jj48i9Sy2WNAPstJ6WRcgm2lAF4ib53jI9qTpV8/GvaHb1ItvTxGi9q//Mecyd6zvlyy/fbOFriuE6vMV58HdtsWhYx0r5vv23XVZF0RriXhKM549KxISQb2DGluG+a7il1OR5vDwaIBSl+Ybe//sUtdMYo/qF1rm8Ma7Q/ty5gs13WD1ctmb6WQ/rZHFKY9HpJ5CydXUpBIRTtgtSjsJ1cjRWmtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXf/yby5mqbUoqtjUN+vF7Z/UG2W6x1PcnpB2QQ6ggI=;
 b=O3i5Pvmd8RX0rqMr4015KE7RkQOrEnmyNfLvYnKn6EMJ5L99/zIpFXjpEIIysddftb7jqlVJl3+FvblzSUvv1DfAY1Dlf86GpuxnF92g7rVFMXoKHySZOn1b3lWrAlRkiIY73vvmK3Xn/2XsAm+oBlUkHYYkijEKfHh3NKFyi4ym+1s7RzTHVvYp3CE2+sMV0LSTtQgnhVx8r+raR9ks/9FG4J12/bmzdzMlHiR7lBDzVC7YMejPOMl/72mjE/VNiiNdNH1HZAQxn2nNxGxj1wOxsRYKjULK6edxR5Ke42Y9nip50pFuRJoviyMMAv6TcIG3QGZv2mScrKpdxykk+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dXf/yby5mqbUoqtjUN+vF7Z/UG2W6x1PcnpB2QQ6ggI=;
 b=W3ltIj3nsTwYn3svU9G44eDgzkCyOIigTZtT4fFRugIzk/aMgMO6rf9gYE2Q9qo6GdPyniQ9CvHo2ZaNvd8OEkESanjWQrA/k+h+vAtEbUA9fWS2CEzdkIgonxw1jtob+Xg/fFMHr7gMhcpgA48wnaM9SIl1GTR+uKojCNaBi7w=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:17:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:17:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Parav Pandit <parav@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Bodong Wang <bodong@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 10/14] net/mlx5: E-switch, Annotate termtbl_mutex mutex destroy
Date:   Fri, 13 Mar 2020 18:16:18 -0700
Message-Id: <20200314011622.64939-11-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200314011622.64939-1-saeedm@mellanox.com>
References: <20200314011622.64939-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR03CA0005.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::15) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:17:03 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8ef884db-9129-45c0-e832-08d7c7b56882
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6845BB70351C786DE28DCC1CBEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2331;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jroZStDqbv5imKDBohKsM0bBgBoWmyYEt7X3e3KM3xvsEVoMhlbfDUhVgls0pfbpvrZaeieQCMwrhG2EWlReJ3FGDjmHEF0WwjdXuoxq1R9zWo+0/V1GKUcf+GoAQ+BRA+jd5aqZTvvBDGSw5DpqR+QCdaWiR7FoY45IncdcJd45nlz3PbhoznVUDCIVwKl/r9YBUHS7iXV5gZu7jH2fWoPNdFhtNB2MkuPbJhXM0APffruxHIR9SswtFSrX4hfi4DdHXDN3ow58iLTyRkcfLySXw954foT2hGnKuWQ0kjr3ccUkgNKezqni1mgmJQhmFhQRinzB9VIizNr+iezN0nZmuN0ma12krEdK0K/JWWAwHFSvvz9ZSyHX/TeC8l064PNjPzPkdWQPgNyC8zxYTEZ4nwQmY8niabI3WsX1JkoGuAWQUb45SwA35G4o/YaoM0AYeZm2FpDHOqXWxOCSbaU6vJGdYYmbe28gDSA48cDlqmivB/+5+1qZnHCPx1It4gc+sccWOuZZiaChdhcX0eAOqPTXxPI8t5IDtSHqjKU=
X-MS-Exchange-AntiSpam-MessageData: BiV0jYsAiKXR/2DaHaykFuUAs28ZIeXhz/8/RvQUmhfuoKsCSD1F+tBdNnkJo3TH03Jqh4BvJ9rV3CI99ntit28AnHZTHa1NcmETYv8VoNIur2xg2RGpnEKdruQxj7S7UzwEA4hxqf34mc7UwK3imQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ef884db-9129-45c0-e832-08d7c7b56882
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:17:05.4610
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UNQxqB9mcENoK0/gdLb4FtRgs17o2oroghzBxyJj7s/1LMYhPTK5ARHgsyevyz0bSfe10M6nmq13WcQLqC6c7w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@mellanox.com>

Annotate mutex destroy to keep it symmetric to init sequence.
It should be destroyed after its users (representor netdevices) are
destroyed in below flow.

esw_offloads_disable()
  esw_offloads_unload_rep()

Hence, initialize the mutex before creating the representors which uses
it.

Reviewed-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Bodong Wang <bodong@mellanox.com>
Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
index 8ff52e237bcb..5b05dec75808 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c
@@ -2332,6 +2332,7 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	else
 		esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 
+	mutex_init(&esw->offloads.termtbl_mutex);
 	mlx5_rdma_enable_roce(esw->dev);
 	err = esw_offloads_steering_init(esw);
 	if (err)
@@ -2355,7 +2356,6 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 		goto err_vports;
 
 	esw_offloads_devcom_init(esw);
-	mutex_init(&esw->offloads.termtbl_mutex);
 
 	return 0;
 
@@ -2367,6 +2367,7 @@ int esw_offloads_enable(struct mlx5_eswitch *esw)
 	esw_offloads_steering_cleanup(esw);
 err_steering_init:
 	mlx5_rdma_disable_roce(esw->dev);
+	mutex_destroy(&esw->offloads.termtbl_mutex);
 	return err;
 }
 
@@ -2397,6 +2398,7 @@ void esw_offloads_disable(struct mlx5_eswitch *esw)
 	esw_set_passing_vport_metadata(esw, false);
 	esw_offloads_steering_cleanup(esw);
 	mlx5_rdma_disable_roce(esw->dev);
+	mutex_destroy(&esw->offloads.termtbl_mutex);
 	esw->offloads.encap = DEVLINK_ESWITCH_ENCAP_MODE_NONE;
 }
 
-- 
2.24.1


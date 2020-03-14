Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 148471853BD
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 02:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgCNBQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 21:16:52 -0400
Received: from mail-eopbgr50063.outbound.protection.outlook.com ([40.107.5.63]:20602
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727693AbgCNBQv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Mar 2020 21:16:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EGrO5uGZz46wHC+gWiBbOIRhGUt3rCGSuJCCtbjlSS5ZM4fJZ1CcsdM84VYLxaZtEauOyhQOEVGfSODoGzSXSdtXKLaTCNrQf3mSOT48gnDJsB/EBv62XOnSCumeaTz3MSxgrlpPQza7L7yS6hiIS6sKDN30SRC648YSny75C/5CLTGcPVKcvgY5HWFDYzLr2N52MSOzuTCaxM3FixDzfJeLbjgwWrKhbr7Hl3oaJ2K/X6hC5yQREB34gF1kqGfN0jtGM1onQY6A2fJUmFWli51pcz6LeZGqWC2fYLdq1hx6FIeKNMwaJXSwQotjcCV/tMydYJA5pH1dIBdopCMahw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOl49G7JYILrGGjEfEFH/CCvmpodM44yrKBGlpND9ZY=;
 b=JfqN+xiRDCm59XyO+4eiwp6ZGrB7ZvqrzY/MeT1rRMbJAxJjKefrqmZss2bO0NGxjDkHRoYIx7uSwQvcZYCAsYQGL4ChSMwAjFlw0c/RRv1ZPA0XN+ehO5HBwcifmZXDEToWUVIWIt3Yut7KGvendvD8enCpJ29grNNU9OFQqCBF81GSpO6CpbsYJsGAcdaDwzwEPKibSAdIu96aPfeSDN3zBh3pJQcckaw8atbK0BXs0w+hwVl/9GVUwYzKsjXx2d+kbmVXcyX5DrMv0FEx6x8m9NlzOQw+Kn61zPEq7evGPNkHwdrMRtAXq056IJI+n0V8J5aWOS1qSti859n6jA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bOl49G7JYILrGGjEfEFH/CCvmpodM44yrKBGlpND9ZY=;
 b=IFp19J7ETgs+I6sAjSZcbuA4eem1nY7R2DX9CFRyEDcsqc18Rj6/orQ22caTShR9dHk9Ko6bSUcxJ4ZP68QRfdEpk1TW15WXtN9/tJuWGvPKbfp0W72MFxVtIkyL7YfYDhlscC/1c8ud6LkSQlSIE/PCPynQyYnFcIYu4uyFfmw=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6845.eurprd05.prod.outlook.com (10.186.163.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.16; Sat, 14 Mar 2020 01:16:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.018; Sat, 14 Mar 2020
 01:16:47 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        Bodong Wang <bodong@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 03/14] net/mlx5: E-Switch, Remove redundant warning when QoS enable failed
Date:   Fri, 13 Mar 2020 18:16:11 -0700
Message-Id: <20200314011622.64939-4-saeedm@mellanox.com>
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
Received: from smtp.office365.com (73.15.39.150) by BY5PR03CA0005.namprd03.prod.outlook.com (2603:10b6:a03:1e0::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2814.16 via Frontend Transport; Sat, 14 Mar 2020 01:16:45 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [73.15.39.150]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c9f9379c-68ed-4c3a-8848-08d7c7b55df3
X-MS-TrafficTypeDiagnostic: VI1PR05MB6845:|VI1PR05MB6845:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB6845004AB1854523A8D554DABEFB0@VI1PR05MB6845.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1417;
X-Forefront-PRVS: 034215E98F
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(39860400002)(366004)(346002)(376002)(199004)(86362001)(54906003)(6506007)(52116002)(4326008)(6486002)(6512007)(107886003)(2906002)(5660300002)(478600001)(316002)(66476007)(26005)(66946007)(8936002)(66556008)(8676002)(81166006)(81156014)(2616005)(36756003)(956004)(186003)(16526019)(1076003)(6916009)(6666004)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6845;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UGnDVTUcNm4mOyuLsTpkL2xJqa1//nAQQyxfUgtI7ZAzx8bLviDIBvdsc36FHP24fVp46zNpDfkWUCfGPpp8qselnOz50R/kDXfkorJaYuGRWKdM8hfNTfsDR2Wd+IXh/pNldP+ztOcjCBQFLL++TLe30eDYiuWV26d9UO2c4Q6q7pINL91qKyifMgJsWV4dNDnjSgUXlXJDOiHDRm/TOSD6CdmZu3ZjkldtaNHFaHqat1bfjHKTHzW0JMp4f6B2X42hOc4+hOnmEZYamZw4PdovvH3AKQIniFAYUaHkxDRKJQnQakj+axhxOuEbQ7XJanuo8li1dcHkB23NvXVCheM4O7hsUhqB0SQAl+PUfK1Wao9teLRE3eNLR9OKRyfKse1ntgOWOX6e13+8VscXroJj+c2mmrjp2MUtWjq7RDCQCEunY3fRaVeAdv6IAKmNrP+LPgX9WEvcBQV3OOs9Oqpt1gJVqEGdTw39rNSmlYUQbkt1A3mw3v7nCzQMfO3hbi3lPF1S1lID2FmnFL5xzTNPIzdsG2DoXLdwSBttQek=
X-MS-Exchange-AntiSpam-MessageData: zb1JfUdNMjrzeKghj858dg1KCOtMdNQYgnOyxWn+OG6zQlKuzAZ9XRzvjUXSXxIi4Bpv+gAFhy8ArqgrFB8Mg4SHYqH+swcAOzmfkBEHnK3nojcZL2fse0It4enFWDB5CMU1wjxlGbKykoF/Y1j/bw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9f9379c-68ed-4c3a-8848-08d7c7b55df3
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2020 01:16:47.9051
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9hOOictonoDGtO9FN+K9oEQJjZ/ZBshVuN1Mtm/fmohGefiPvLGT8tpgYZQi7U04BGkcw7zr8zYEyXHy/PS3qA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6845
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bodong Wang <bodong@mellanox.com>

esw_vport_enable_qos can return error in cases below:
1. QoS is already enabled. Warnning is useless in this case.
2. Create scheduling element cmd failed. There is already a warning.

Remove the redundant warnning if esw_vport_enable_qos returns err.

Signed-off-by: Bodong Wang <bodong@mellanox.com>
Reviewed-by: Parav Pandit <parav@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index b4b93d2322a9..deeedf211af0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1801,9 +1801,7 @@ static int esw_enable_vport(struct mlx5_eswitch *esw, struct mlx5_vport *vport,
 		goto done;
 
 	/* Attach vport to the eswitch rate limiter */
-	if (esw_vport_enable_qos(esw, vport, vport->info.max_rate,
-				 vport->qos.bw_share))
-		esw_warn(esw->dev, "Failed to attach vport %d to eswitch rate limiter", vport_num);
+	esw_vport_enable_qos(esw, vport, vport->info.max_rate, vport->qos.bw_share);
 
 	/* Sync with current vport context */
 	vport->enabled_events = enabled_events;
-- 
2.24.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB093159C50
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 23:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727740AbgBKWgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 17:36:10 -0500
Received: from mail-eopbgr30089.outbound.protection.outlook.com ([40.107.3.89]:23251
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727620AbgBKWgI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Feb 2020 17:36:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IeGkJXhBNSHwAusHPIJVEzcvALrcG5UhFXfDp29GQAe7QH/05ETQb41W31h+HsWNqoWBQe+y/Vqd4RaTAHy7S8XZsUL05rJBK/lB+JI2KvbTczSzQFoaDNwYSAT+VNBwobs7sNGrJSMllaeljYcNhu2qMDxJz2j1efwzsatQ7N3wyq5r1YRs6cN3LQV/ZCJIJlFbLGFkd5xHGqwaIKsM+SyiRxTrLWvJZLsqXVwGBrcWg4DrJY4aujAk6A7e3SDGzjAwNEGcwhdWIz6jCU8Gk9bReo8H0mbzakFXz/w0V3rtt5pfoYEiDsOQyHi6ihaH4ML+yxivAV9XvP1DQQnApw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LToOn2w+lQBlX3/0klFCjsyhQPix+Z4XlxVWRJwFIg=;
 b=NHlOdnQYCmnIR70NKjJaI3rjfFpwgPlsA4vNWAg1A4khZSUwLyZkKgSTqc6XatqP49GSYb7TD3hqXvppp4h2iF+vQyh3TLRU4PdEMZoI/6N49E57XHE6MkfFcIlTcWPDQchUpuFTz+bnZyYDmWRHfCXAbuk8QOYK6K8AzL/4yn9X9pBdEYc1YS0RfGpBlSuKDgZfdFIXhvtpNzV9XdZ6w0nmT+y2RQzku2V2fi16ub/y2bX1C21i/o6pm+XrKNncbi4GsI8lW0hEBObL26rZgIMtoRR9sXXCNugt/teKKlpvZ8NWxlgpJY/F4x/pHNre4i7g74DlUsDBlAGYZ+b5JQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LToOn2w+lQBlX3/0klFCjsyhQPix+Z4XlxVWRJwFIg=;
 b=ZWNsqhFVkY2RKqJ1dP57rD2xKJ6EQOWVO2s4Ux+6zMvjPs6PwHYwM3Gw5fy+SD6qB3hWVys02JbJ/atz6xw8ELQIy2CzSpHN8fIwVKdPsOMrdTu9N5ZbSDxGxqZC2uDnhvEAGG7/hQgO/7qZcEoPJQVc5cu97EWl4WRFQzKTyic=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4671.eurprd05.prod.outlook.com (20.176.3.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2707.21; Tue, 11 Feb 2020 22:36:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2707.030; Tue, 11 Feb 2020
 22:36:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next V3 13/13] net/mlx5: Remove a useless 'drain_workqueue()' call in 'mlx5e_ipsec_cleanup()'
Date:   Tue, 11 Feb 2020 14:32:54 -0800
Message-Id: <20200211223254.101641-14-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200211223254.101641-1-saeedm@mellanox.com>
References: <20200211223254.101641-1-saeedm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0001.namprd08.prod.outlook.com
 (2603:10b6:a03:100::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0001.namprd08.prod.outlook.com (2603:10b6:a03:100::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2707.21 via Frontend Transport; Tue, 11 Feb 2020 22:36:03 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 8e8f655a-77d7-4fcd-37e9-08d7af42c75d
X-MS-TrafficTypeDiagnostic: VI1PR05MB4671:|VI1PR05MB4671:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB46711A2CE51E6A832E278BEEBE180@VI1PR05MB4671.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:222;
X-Forefront-PRVS: 0310C78181
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(189003)(199004)(316002)(66476007)(66946007)(107886003)(66556008)(6666004)(54906003)(6512007)(110136005)(5660300002)(8676002)(81156014)(81166006)(16526019)(26005)(2906002)(186003)(1076003)(4744005)(478600001)(52116002)(86362001)(6486002)(6506007)(36756003)(2616005)(956004)(8936002)(4326008)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4671;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: f1ZLxpFXuCjEHsbplj/ToYFIVpgomzS2cDQ9D1umAyJuzjGWzVKYp4Y8RGGaDbh+i2Jtnbxce4x2tbwy48iGUX6kCUtM9DImsKJFUg5ofqbicGoW98l7VHxf42S0VeFguKOzMXDWCIxvwY6rqDfwyGmgo17P277h6/6TehpS/v+YnjqcKtzt+v3mTxlcKb7N9XPbOzgHqRpoXesdHFijreAzcecvN9uWz8UAagFphwezvUAr1Ll73Y96HTND8h1LOA9vhhdnOdNFO0Dl2/UlouapzG9em1aRzI535ovZkZzKC1jNhMFY4EHdkdUfih/e2d/L+NM9EQ0rJymZE3TAjD8PY2Ye5zUoffU54fXbrcakIDnGQeuC2In9vHdxm0LYp4oeR6OlCjBmsEqYe3zYH1I1MSfYKb12sBzNSBBqupRCWcjvAkNAVXAQXkAkdzzVg2THfwyMyuDSw25DOz/BOr3GL4IZYHltmBKj1XffHPzZEqlSAgmJo1oyGNT+/NqZBPSQ3n/Yy+7p5suM5CbtX2qKn3rieE3AvZBGlGUSZFI=
X-MS-Exchange-AntiSpam-MessageData: GRlqzTLJNieH+D3llZEcbRQPndb8kS9Vh46f3TVtXu0oSyTI4g2RM8h60VmYTyYEmlzyn0jhfufFfkpDWKvqQSz7rL1Jbuu+A0vMfWOAw+Krx/JsqrxIe5jY+IvsE4sPyS46hI+oPU1024kcLJ7Big==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e8f655a-77d7-4fcd-37e9-08d7af42c75d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Feb 2020 22:36:04.7369
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iEWFtfvWyu4DeE9l/zUfso9m9DnwJW7PNDIFR8jB0/mVYo0urcmNKuGpL3CNr9e57SXIhOaWScwnAlM8TYmHdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4671
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

'destroy_workqueue()' already calls 'drain_workqueue()', there is no need
to call it explicitly.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index cf58c9637904..29626c6c9c25 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -433,7 +433,6 @@ void mlx5e_ipsec_cleanup(struct mlx5e_priv *priv)
 	if (!ipsec)
 		return;
 
-	drain_workqueue(ipsec->wq);
 	destroy_workqueue(ipsec->wq);
 
 	ida_destroy(&ipsec->halloc);
-- 
2.24.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2712A430D8A
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 03:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242953AbhJRBe7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 21:34:59 -0400
Received: from mail-eopbgr1300092.outbound.protection.outlook.com ([40.107.130.92]:19905
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236049AbhJRBe7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 21:34:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dc8bchjpieQDW2o3D3JW0oqoGwlWAHTkvmKJPqcOh4hMizrQi/6SMWxzb5HhAv7GnhVMb8gvEp8AzgqTdM+lxnAc1hLlfOkRNCIPTDKn5XH0koRxW0aT7UGL8ayF+jufvV6jpBKMXtvkgBMqm7R06wwKDJqKf5xW0xu5FyGrjfimt5y9lylE5QTNLza4k/C9KszHQtZ+Zb9gL4HN1sKnP93pHNXWzQGYaNO6yfjI32Rl2aM6Y/vd2pJ8e9zrfsYPr5xZYTbbs/3rR/88VW0QAeZO45HAz5cqjTfXjfMLHq+6coMJa1y9LiDyU4XM3SC0J9tVWO8WxZ5Zmtorb9PdjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zCFEVWOBUB2uNEl2BgNISgiiQ72Yk59uGkz0TS0eDBI=;
 b=R0eK5UTndRb3tW6eyDKmOLBz2TUHWymTOd8/3BN/gusquC5HDFpOGAO5gvpvc8wg40MOUT3I3n5WUaSnHIbNjXg0+7KXqJ7eHiYtsDn+NVGGdlaUSd92KIv1uVTkDxosCuHwtIcE0pZq/HzDjQMCffLdiS+Wm2D8Lub6hd1ie25wU3WVFHawefcBGE5f0lrlVEVRYqbPH/380nMEIbBX5AnC7EwboBrQYfsjNrD/4dh1WNtjEnS+DOaOBT3LYQkQR+5uFtZiC09sAwsUXPNQqEckpbbocqK59Jy//1U2iBW8g3ujyo46lA1CU8eqAKtrOKgWMx0EOIQw+g+/sAbrhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo0.onmicrosoft.com;
 s=selector2-vivo0-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zCFEVWOBUB2uNEl2BgNISgiiQ72Yk59uGkz0TS0eDBI=;
 b=lyveDCq5fB5NYmNW4oFsq3py4aoRjx8ChfutfgXdpBcjKK/2cXnfl+Fzkd2h/k9Iew7K5kFwb+aTCU0B/SBDLvbca+4kdvah6q7OAQ5hxrtD3dcO2D33NM70U0f96EWH48A9JU3ZxHgNPnRa81sydWOXVSWxNJzI64bMFTkuPaY=
Authentication-Results: nxp.com; dkim=none (message not signed)
 header.d=none;nxp.com; dmarc=none action=none header.from=vivo.com;
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com (2603:1096:4:78::19) by
 SG2PR06MB2523.apcprd06.prod.outlook.com (2603:1096:4:5e::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.25; Mon, 18 Oct 2021 01:32:46 +0000
Received: from SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0]) by SG2PR06MB3367.apcprd06.prod.outlook.com
 ([fe80::fc12:4e1b:cc77:6c0%6]) with mapi id 15.20.4608.018; Mon, 18 Oct 2021
 01:32:46 +0000
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: mscc: ocelot: Add of_node_put() before goto
Date:   Sun, 17 Oct 2021 21:32:32 -0400
Message-Id: <20211018013232.3732-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.20.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: HKAPR04CA0015.apcprd04.prod.outlook.com
 (2603:1096:203:d0::25) To SG2PR06MB3367.apcprd06.prod.outlook.com
 (2603:1096:4:78::19)
MIME-Version: 1.0
Received: from localhost.localdomain (203.90.234.87) by HKAPR04CA0015.apcprd04.prod.outlook.com (2603:1096:203:d0::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.15 via Frontend Transport; Mon, 18 Oct 2021 01:32:44 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 07d083a1-5357-49a4-6829-08d991d72ff0
X-MS-TrafficTypeDiagnostic: SG2PR06MB2523:
X-Microsoft-Antispam-PRVS: <SG2PR06MB25230A8ADF1EFBCDD760D43CABBC9@SG2PR06MB2523.apcprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:312;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a6UGunSho84EnjqxOA1Y2TX7zqH2ZdOJDkkQaYHuaPyJvVFLAt3RkaLtcqhiP9i5l+L+01hYszBF8tcUJy5to17CGibGg6Dh1ypjn2GmEut0g4xHOLayICZQuZFWFOnVSaD9Z6dgq2x2i3lZlNNoEXUsMnQ8oJrPFAFMipVwlvxzwp3/4kr/B5CNf5ZbRU+4unBgQgt5hseyEMzpokMQ/kV+KSX3VmiCm8/wsCVVZPs5YBG4cFWXgzNUOBhxpaHZXALp3VRDHJmZ4EufSUZrOkkl/F8w3pn7j0bkXqXE0w5xtZ/Yj9Ip+NJ8u6C8B5jm1ZhOUeV2cWymih6N5MtfT/7OXhAZsmgHQFgWKouj2OFf4sDlq8TupHlq2MuEGvZHe60MJHKDJJQx4C5KVhUBDuX+ZXEtG+n4f3tbZ+Lr2LKDzOgaKEJ9cJVczEQATTWjgz3bPi9SVGyq/pheG6ge9LuXEcIv1hZRyHahvL/xZhQ5ArHRbS4EbXAlXquGIS4U0sP9ea7WeVwaI03EpMvtsE61/wQeJ8DCykcPLK1KhSwyLfTa+rlujZOBeVSk2L7S52hLhMZk9EkIbGB60NyrKcq9DXUz5NHHa33cJc+o43hUXSkbYIH7QKQ8BTFc/rv+XbKEZ4Ch1shRChg/D2Zo4AA57oO7WftLx9iCPMNkObrrZ557RGMGx1zgPmLoI6TqBdrPZq7N0LXf8Sqvw2sEog==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SG2PR06MB3367.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(86362001)(6512007)(26005)(316002)(5660300002)(36756003)(186003)(6486002)(6506007)(83380400001)(956004)(38100700002)(38350700002)(4326008)(66556008)(4744005)(66476007)(2906002)(107886003)(66946007)(110136005)(6666004)(2616005)(8676002)(508600001)(8936002)(1076003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lb/qAuxoYPK/vzuCaXfZcyEkx4xtj36YttbRAyc1Y2QKs71/qONm2lICw62K?=
 =?us-ascii?Q?GWUNyBuhMHqYiW2QDH0DdG2xAqohSGe1uN2BNV1kzpdaWsA6GugBl45+lfGY?=
 =?us-ascii?Q?Hj5nkuyjm/QGqmq3hWZqK+FeM/++oNnzpVlRZ9WnEkxglYUiJgAnmDF2z9iU?=
 =?us-ascii?Q?/9S7wiLNtrMj+RJVhqfzi8LBEMqygENNIAD8m2Ro4BM6ri2G+M89+6uTPLGK?=
 =?us-ascii?Q?swodyiWs4OHrCw6KEr4vkmkCJ14Bkf9FT4fJRpBcqY+txslPifXKELhZDExd?=
 =?us-ascii?Q?0YjDCH19HOpicrNhU+E/h2Ngim9J7grVew2rTkqLuET7dxWQlCk9bDW0E6Cv?=
 =?us-ascii?Q?K+pAgv5bjOpq5GN3Va0DF0qgK/2CDY+J6Ndn+pEnmasvnbaarn9N5KhFaJ1y?=
 =?us-ascii?Q?Tbkil0+GVhAD4QptskbwsISLmFxEp4597EhVT4HM5gCqZb3RI6AhNvvMfyXT?=
 =?us-ascii?Q?4czATD9sCcslwPunqhhTKzpCml/7yoFYXzXojgztD+OFsG9/9XYYu78BBVcE?=
 =?us-ascii?Q?I8AZ1nWdkdKL364gluR5x7SpcimNbvu8QP7pk4k0zZneNatyISxFu2OyMrqy?=
 =?us-ascii?Q?2M3uHTyOBMvAs9blmlTpr+u9NqIpytfQ8K4fKUxgAt8J8xRl87A6eO3p4s8J?=
 =?us-ascii?Q?Dc2kk+51LiFP95RZ4XKlF0MKpDasXQdpGVFiKot+CELtHKzSG/U7/bFGYVB2?=
 =?us-ascii?Q?m0fwM7INt+FJVO+WZbNOFnCHEseLcssKVsB8H01+04gAuZkTSkNNhLz9Gewz?=
 =?us-ascii?Q?s8nGpE+6ae1kcM0FCnvPOlGvVe+ETaphirJGGVOJfFQN7ARSnfQedtRYhnqi?=
 =?us-ascii?Q?pYfxR79P9+Y9XV5B3hdnLldpbwq7BsS8bqsrVcdyUpdT131o6Hs+Nywkk2lR?=
 =?us-ascii?Q?Ltqi7egLSNlnRF574a2CwLsx2tLT6i+2jcWUd8n5ayjYkx32EtBSFOy0cj1f?=
 =?us-ascii?Q?iqn9rKWMVB8HT5yzs6JfGVCnTSei0E84HSmu9mpZWQakSVjzZ024cgHTaKZ5?=
 =?us-ascii?Q?ABithng54BERqCEzJ9LsuXxmDuVylFnAb5hp9ahY5ieg+zJGgY/+F8d0V1gL?=
 =?us-ascii?Q?0arvyI9ZWsTZex8bUU9+H/JeCln0dWC4Cck5tMeF4w65KMypkBiqvbWQ8GdW?=
 =?us-ascii?Q?PHNuZvMh4FrvIJEqlLPz0FgvlIaZeuU4QYkG9b6PeYw4szKIn5O4ntSn9mh1?=
 =?us-ascii?Q?kK55UdsrtwnevDHt6i3kS50kfU2hSfOMzMiKqK17AoRJOMNSHOD8g1V7WBsY?=
 =?us-ascii?Q?/MEHq02k/gLv3Ga4RTSeletypF69F/49N/s/2+gt2eAojGiVtNQ9q69qmYDK?=
 =?us-ascii?Q?2ALw/cC25cJi+YVj2j26I9Hq?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 07d083a1-5357-49a4-6829-08d991d72ff0
X-MS-Exchange-CrossTenant-AuthSource: SG2PR06MB3367.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2021 01:32:46.0225
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /lLXTaAJz6ZHHWP75MGnBhGGiq/bWojQFXplOUs2cUJ7RUP1ullf7cpiA+m5/YFxZmE/sq6kxO//ke2ymP5zww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2523
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix following coccicheck warning:
./drivers/net/ethernet/mscc/ocelot_vsc7514.c:946:1-33: WARNING: Function
for_each_available_child_of_node should have of_node_put() before goto.

Early exits from for_each_available_child_of_node should decrement the
node reference counter.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 5d01993f6be0..38103b0255b0 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -969,6 +969,7 @@ static int mscc_ocelot_init_ports(struct platform_device *pdev,
 		target = ocelot_regmap_init(ocelot, res);
 		if (IS_ERR(target)) {
 			err = PTR_ERR(target);
+			of_node_put(portnp);
 			goto out_teardown;
 		}
 
-- 
2.20.1


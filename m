Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 450B430E04C
	for <lists+netdev@lfdr.de>; Wed,  3 Feb 2021 17:57:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231673AbhBCQ5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Feb 2021 11:57:40 -0500
Received: from mail-eopbgr60134.outbound.protection.outlook.com ([40.107.6.134]:37202
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231342AbhBCQ4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Feb 2021 11:56:43 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nwnRxInHV4DvL8I+Aa1uUAGxJS0uZ4fuaK7LyxRBaoVACHBRjxAll6oeP12x6RZv9CfIfrfyJwMKFrSZVkn3xjoWhc4NcyYwAbwFDS4rkM7Mf85ckrmSRAM2cPtKE3WN/q+BpvkWIBpBS+oR8iAEH4RWclgulMqbmPt3OOroiUqPHbD5y59v8kie888RF+OC50IROq8VOQxYGChmlpDAjEqkAABXErOz/WbKSJUu2GeAWXfpMZAzktKDiMpC2IwXbLAn1pY4kbENa0MeRF4RHbAq4KThHs4wzL3tZxMZybPOmsgoDUbn70dkn5M7j/O8mHetmtokFsabR7dBUQHjDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKobMlmUZCHuwXlAIZFEsm+k37mhXtc3v8hZd1Jag9k=;
 b=LPsu+haoDPJ5tUBlVbd89jrOegRvH/R6uyVwZypweHr7bUh0RyQ250AM4tk3EPcxT5oPXf55r4RzuC5Ysn3Aa08IGcwNvV5DWtgGqvbcnYtMn8nCd5k+fSQLmDIX9KT7YZaP6wKGidr0IoGnIs/7X0JI6lXoKDCN7f1wTd7bcGR3CmPd3uAIjRJFMa3OKYKQT4lrUZ/wRrBicer7C45BJwKhJF0cqQ5q322O8gx1vb+1CUuEA2lCzK4MJISPZts0avNCKGvF/s6I/EOkDliIHRLSzdOuzMssrpvkxekeYqROtV1a6mbOdvNYBLvuWCF7T5XFy+BobDORVbEOMtJZ5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FKobMlmUZCHuwXlAIZFEsm+k37mhXtc3v8hZd1Jag9k=;
 b=eyZ8LvG20fiwQrtKoeTzCbJzXI8jxoquG4A/REiGL9GUHf/+fix69aW/Jg7fR7yG0Dd2E55zQNGC75KC/pK5SV37mqxSM6oUwUHpNGEzxIoBFdvh3FXCeV8yj2mIlrYzcYxuAeiiEhtbzfIrE3yedKMEx0wIB8o8kjMB3C7wE1I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3805.16; Wed, 3 Feb 2021 16:55:53 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::bc8b:6638:a839:2a8f%5]) with mapi id 15.20.3805.023; Wed, 3 Feb 2021
 16:55:53 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        netdev@vger.kernel.org
Cc:     Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next 1/7] net: marvell: prestera: bump supported firmware version to 2.5
Date:   Wed,  3 Feb 2021 18:54:52 +0200
Message-Id: <20210203165458.28717-2-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210203165458.28717-1-vadym.kochan@plvision.eu>
References: <20210203165458.28717-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AS8PR04CA0145.eurprd04.prod.outlook.com
 (2603:10a6:20b:127::30) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AS8PR04CA0145.eurprd04.prod.outlook.com (2603:10a6:20b:127::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Wed, 3 Feb 2021 16:55:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4bd69fb8-11cc-4937-f01c-08d8c8649169
X-MS-TrafficTypeDiagnostic: HE1P190MB0539:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB05394617002FB6B06E711C8295B49@HE1P190MB0539.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QySS4O0hMVthFN9dHUYB4jajJXqozeRM7nROLASdgsvzbrX2tUrHB9tlpsZQlV1uMCXNGCXhZ/crk+ZLgbxYBCnFk8XQXzjRtXaKNbGgnGU0V/TW53m87SUX1Y2DiMcLL2AIVStbwhiu92JMtfjmH9vjkBgVwlFmNZ1yAffsEYpKg8qag3xC1vc1g7uH9aeM63mxx05FIu+jePoOYOp0Rw9SEAaz3PNia/JkfgXyhiuo2OqRsc4BDsJGI/ceNhKsZ0GTFUGwe+r3fQKy2j3m1D4DTZwEWRiPkDFiRKoeVnlSWltl6NoSACZsUVPGycj6cAA8zXpS19vr5qlAXTddplxqeezvg0nK1C3a2ivz66TaWGErwjYj0WWRTRxS49bFvBK8GaHejpiGWPiiAcBV2qy41ih57GILEAuhwtrnLZPLwFWNMQb0Nf2KuYGPmOkGqkhMeIQbZcMJhkvVr6KVD6cWwZcjl1qWFZPJ/x5kU0gi8KVGucNttv5U+yV30XPdpkOjUUJHoerbm5hFt5aHdQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(39830400003)(396003)(366004)(376002)(136003)(346002)(478600001)(6486002)(110136005)(54906003)(83380400001)(8676002)(66556008)(44832011)(5660300002)(956004)(4326008)(6506007)(16526019)(36756003)(86362001)(186003)(26005)(6512007)(52116002)(2906002)(316002)(2616005)(66946007)(8936002)(4744005)(1076003)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?Fyx+UlOBR4tKKAqTwN4/VB3E7uqqKV9XXXFRoL/snrT4UEWA+QxxUqKVH4qD?=
 =?us-ascii?Q?Z78PMtwDTPBm3mZ+eqftyKStYgNZL8PCDLQBrPdNGQQEgR7FFACeH/j874Oh?=
 =?us-ascii?Q?iBikWGIjY7DzIAfNcDS/CPXUHb5zDVyOco4wqCYcZLppWg9Fe8lxH0zNHk3c?=
 =?us-ascii?Q?xtOQfY+TGwrwYXP+6ZPj9ThWDhPcYIasDKDYhFF35PnTiQ5DZGSov/kaSvUk?=
 =?us-ascii?Q?X9fos3xmmAzbj/cb+gV/hpKLUK3Z2L5tZ6Ce4/dYe2ls2eH9B3F9pwZ+w/YJ?=
 =?us-ascii?Q?01Z/6S0cmL1j8bNjeaR5J1pqZZUrnqrhPx8bsse3uYx8gnWbruTD6gTQArIr?=
 =?us-ascii?Q?NkOWyQ2srz4scrmypbACcfHNbcnKhvStzDqqleSS7b7fVvL8aFf3u4+w5ntR?=
 =?us-ascii?Q?f+GYHESp621ir+26PQgA7tzgC0KJSwcSVvTLxXxgpJ/ZiedkS55P6UwaI05y?=
 =?us-ascii?Q?tU/myiEZpexqI8IPS5JvttDum5oEaYs1zgXoHJo69vy6t6M4ylovoT7ZxlZ9?=
 =?us-ascii?Q?nwjwJACtjN4vctcvM817ht8Dy3OWrXIh+xGqpBT/mwjrD+I/J2GWWrjoSSih?=
 =?us-ascii?Q?Dh0j7AYijMHQUG4yFhRFoaYku9qHjhupwau9zkZG4g83FWpjzL6Qx5Rrf8W4?=
 =?us-ascii?Q?KQ1/xes39KtfbJmlpPB0cbpgZrqhJrryRO3Tny1Slk68Ok4sQdpNo8r4i7OT?=
 =?us-ascii?Q?vgzTyl0sozvBJjGnX6nyPxLWvNo6Pn6Kfx5w/p5LiQgTB7nPSSSfIx+j/vMS?=
 =?us-ascii?Q?MC0ANZj2cKXNUqlCcvhIgKir9kpqsB2ZkSGaqvM58BY+spZePb7dz7YwDETp?=
 =?us-ascii?Q?ozK4gXdKL5xgciQ8wOcY/Zu0gbgTTEu8Lfzu+GqaSI3JMfKJhJC0tNZRlmwY?=
 =?us-ascii?Q?EQMz++P/SGvOooQeoEYh32ThUKRXDJuw2Aiy0N2mQgMHP6BzuiRgPV9zwoHr?=
 =?us-ascii?Q?sHg8rfu2BPkRV/AzNkMZ8L0eorksHyDIHnp8/OW4A42QkM65YCZ3Ncouj6nf?=
 =?us-ascii?Q?KpOhcQw28nSkd8SnjJm2cw53X5ct+vA/PpslBjSoWd4wVGFNhv42TbcSQLn5?=
 =?us-ascii?Q?k+PfbxU9mSpgJaeQDjjn8kYBxC/0kZwI765lt+qbnz9VHy8g52eEkkv+PBVy?=
 =?us-ascii?Q?wYJ0j3M+J/PlOg3pTG5ch5U1u3BoneCVAthctzRuCBBde4CVtv2psGICHDT8?=
 =?us-ascii?Q?17KSxa8pI8HtdO/Qwyw5lkbcF+ktsTMz/SdxdEllSAF7qTTuW0SGqu8rPqFv?=
 =?us-ascii?Q?IoBS33pzidAd9slBdwjylFZzudsrouyYhPwmHdjzp2uni5y/Sttfqo7usag2?=
 =?us-ascii?Q?ufayc0d57fUHfuCfFqUXs5PJ?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bd69fb8-11cc-4937-f01c-08d8c8649169
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Feb 2021 16:55:53.6827
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kxlxWAYvLNCcNln5PlTQRr/jxxBxm3HZiUYssZHOGnmZYpBV1GBgN5qLFShuelOrg9BlbVkg6Y2JS0jAn1W4Rnkd101jLeezyJ84+Jbf+zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0539
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New firmware version has some ABI and feature changes like:

    - LAG support
    - initial L3 support
    - changed events handling logic

Signed-off-by: Vadym Kochan <vadym.kochan@plvision.eu>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index be5677623455..b8a87d249647 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -14,7 +14,7 @@
 #define PRESTERA_MSG_MAX_SIZE 1500
 
 #define PRESTERA_SUPP_FW_MAJ_VER	2
-#define PRESTERA_SUPP_FW_MIN_VER	0
+#define PRESTERA_SUPP_FW_MIN_VER	5
 
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
 
-- 
2.17.1


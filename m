Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8367B38B355
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 17:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243837AbhETPhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 11:37:18 -0400
Received: from mail-vi1eur05on2090.outbound.protection.outlook.com ([40.107.21.90]:8577
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236975AbhETPhN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 20 May 2021 11:37:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Usxtu2m6CoRQgwDDFO/xw2AqMhrZtXuYLdhiJO3MzqzMmAopJNOExXMSEWB6G8lLyTtEhHZcD32XDKhQaN2AOyT/W9hA5bdrqhvv3doWEk0xA/S+0W2brM01mk3a71zK7AlHwDAruppO0ZcJDIE2D92uqIKcvrp3SUJAXodO6/5J/UyWOGYvJsiAun8gsOhY/u0URpUFF3tkAj1QSfGn37fQBgkQ1AYzfCi/gHDbLsmJSZ5ZvttK357je3Cg1q0pqwR4fuGhVgLFXaDRu1dcj/W8XMkEzJA64Te571RyDo1uoAoz4KEKwp8zisffbeg/ijOZs3dXjQpnybulc1lcdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nm5M0IGogy/b30i99jK4zCqxL/S9+iPH1g7g2oXLShg=;
 b=eXkwHRKmfVSeEHboAmLYLxIfMX8YPZE5U/5QvSopoLXiJbCOYmyvqzNtC95QdeaIS0V/fvxKHzqy6dAarbCpsqEjUYTbiZI41qEpaTMxEsRbjQ6Dsm4dUkmUYUSvcbX+R/TLmJgBeyGFuax8igSAviJYPZyeZVhg/8CSqbBJtA6EHV2R0D+vfOTUSJTqyM7bmcZMz6k8bIotpVm1yeEuTsKZLNd8YU87TidyQVxhToV4rdS2RlI0OrO8yCTHiYpOne+VMvtNIZkcaMfS6Y//PrRWe2IHkA/ijtfF9c1qjA6Nzx0sOK/UIYLPb5BXJxNgjcDMO2kGtk60Cx+LRd6QqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nm5M0IGogy/b30i99jK4zCqxL/S9+iPH1g7g2oXLShg=;
 b=pH+5spE8ucSgfGWU5T2HtrnvhHy5aLVYCDaLLNfl9W9TrPzB4TnJ/xUZomzBMFwxhuoxwlwllWYhhVmSz8PaLzHMCrqmOaZISYDje14hPcENaJVtr1Z+MwdTH4LYPHLb89L599YhI/NtGCw/+ymX2w65H64f1ZdL6YBlHSISg28=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=plvision.eu;
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:56::28) by
 HE1P190MB0268.EURP190.PROD.OUTLOOK.COM (2603:10a6:7:62::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.28; Thu, 20 May 2021 15:35:46 +0000
Received: from HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a]) by HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 ([fe80::edb4:ae92:2efe:8c8a%5]) with mapi id 15.20.4129.033; Thu, 20 May 2021
 15:35:46 +0000
From:   Vadym Kochan <vadym.kochan@plvision.eu>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Mickey Rachamim <mickeyr@marvell.com>,
        Vadym Kochan <vkochan@marvell.com>
Subject: [RFC net-next v2 3/4] net: marvell: prestera: bump supported firmware version to 3.0
Date:   Thu, 20 May 2021 18:34:59 +0300
Message-Id: <20210520153500.22930-4-vadym.kochan@plvision.eu>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210520153500.22930-1-vadym.kochan@plvision.eu>
References: <20210520153500.22930-1-vadym.kochan@plvision.eu>
Content-Type: text/plain
X-Originating-IP: [217.20.186.93]
X-ClientProxiedBy: AM4PR0101CA0065.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::33) To HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:7:56::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc60716vkochan.x.ow.s (217.20.186.93) by AM4PR0101CA0065.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Thu, 20 May 2021 15:35:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed1da5ef-3aff-40b7-df82-08d91ba4ef8b
X-MS-TrafficTypeDiagnostic: HE1P190MB0268:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1P190MB0268302DE0C5CD7516C94277952A9@HE1P190MB0268.EURP190.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:102;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: p9txhqJLiKDFc25CPgsLm71Qfi5bP7PCb6M6rrrvmFyWos/5NTQQtLGNh8rcTeGh494+XmkIx4oXwrbWuBQUfNhQIB/7phYPiO90u0Gr3jd23WF7Eigg+X/pO5ZB2DHBoqAHtjlBfeKA74Hf04PZntNwH7VsBIWyYlAymPY3qABNb7Z/Ysx65dv5cQRKn23apbeN+XrSoBKy+QjuMo1DBZdVm5wBP9f8aajLFD7UFweffb3A9Wrj2n2LB+MmMtEYg++G8CjrZlohHBaUcav39WCInAwIWAQ/ZVr088c1WUNMd2F192nqzHB/erSxeY2bkn9+R8ctjspIA8P4u1T94CFkKxLUkh111qaoakX+4iGUTETZ4A+P3qtLgpjnY+mrNXuH3ljiBh1OMB60WYeFyMb68eQPd9mfjqSIjUxmFLZna+kFV0aRhy5cUV3m7it1/METknU7LGT8k9tlqp7unkl2JgZOmi/n+kwjGVg9sUoKt/CSzcX+sSMvSJMOVhASpO/IwlwUwA2DH9wE9nzFWDiAKPIrNYEP2d2ZzcM9e1o4XPtlVjgG/Jhfn6tlhIZLvjzXt3ii7Gi/1yKDxD/BjAnryP1ZQt1a5CKZ+oxsjrFR2HPNVf3oXW7u8Hcni5I9NaoXR9rXl/F0gEN2BQ22nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1P190MB0539.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(396003)(136003)(376002)(39830400003)(346002)(366004)(6666004)(26005)(5660300002)(4326008)(6512007)(66476007)(8676002)(66946007)(316002)(66556008)(110136005)(956004)(54906003)(36756003)(186003)(16526019)(52116002)(1076003)(2906002)(8936002)(83380400001)(4744005)(38100700002)(38350700002)(86362001)(2616005)(44832011)(6506007)(6486002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PKR/TAzAPpe8fVcHuTzF9hthQ5rk5wBcxAP0p4sAHwxd0LE5zTI4foNK1W6Q?=
 =?us-ascii?Q?MXaY6idntHnI9elUX67uiL2KY4SV9qjb+gCdq2kfocZQhMqmovMw7AJX0tnc?=
 =?us-ascii?Q?VLqxCX9CIpD09CSK+C5SayhU3KyA0IOdm278rL1Dx6y4NskKDSJdZuVK2fXo?=
 =?us-ascii?Q?2lceq7Os2poggaUP0k5bKEeUbOenzO0t3OJ+So6I53EzzBfkqjdv3iSVZx6J?=
 =?us-ascii?Q?IAuIc6GTjbRQ4Mh7iuCex9kuRF//9c1MATW3pK5gyOfBXoN/l1P9urC+6hD9?=
 =?us-ascii?Q?Q1kuLY/KH89aYTgrIKDdWWFio7cYm3tKQq7ZUMNY2N6oZhLKtP0U8VO8jP6E?=
 =?us-ascii?Q?tH2fZtYCqGeo1wlunlczeFfsUb1bW4mCU7l9IMEgl+9b3MGQXq+KQCgqzzLx?=
 =?us-ascii?Q?Y73Su/hBBMq5MYhzY1GZSOpOJJfNicjbKcLiyz6+PhoErnf6Liu0+5Ori50w?=
 =?us-ascii?Q?vsqcB7VbSI5plYETPbPBLsVwKvyrBO6TAa8vHOhFV3TckEpDRw1MLH/20TBx?=
 =?us-ascii?Q?WhcT5/irhGyzjS+6hIAq7aXgemsA+tegjW85DwAYlxPnD7dB9jKOzTWiR54c?=
 =?us-ascii?Q?nccmW+aWetMBnQVNlpq7ktrqZkYyKPbQPBJaNcfGt0tsRPdLSAqj4jLxUke6?=
 =?us-ascii?Q?Wn3xGl4/2iSH99kMEGlx01g9y1Fev3wRn95H4IALdalO9fZEHkeOo9bumewa?=
 =?us-ascii?Q?Nbtw9mbAXzPrKitoQ+OBYRnRGdSDedoIOPe9nweFILaNydbmWIHl/H6b0iqd?=
 =?us-ascii?Q?EGySt6ZvK0P+ggJrGfnSVsqnNU7kkJP8aXHk8uzKP4bgc9ljC7qF84AP0EJO?=
 =?us-ascii?Q?jlJGrZ395dxmNYQ7wf0ONnEQccw75Rs+AhzlNxYZXN2Dr+UVFnBfETgAhiH6?=
 =?us-ascii?Q?DjSEtgaMBudGIwKWFufJNAyrNcFCskn3Mvj721qEWUJby6K6qt+KD0eK3tKJ?=
 =?us-ascii?Q?ZctYdLEUhjF5ZlTrC4sqU94mVGLqMQ9YlGylWmCh2knZO4qwdt7q9i/IYSIm?=
 =?us-ascii?Q?Bri7FzJmzJYB5khQ3x/ZDC0o3F8jqzXLnG1GbYM84bDHeoBQteQjDzxns3fe?=
 =?us-ascii?Q?kwo7eJXRw6Mnj1b/9QDjZRkmNmEX6av2juZS42t4bfuOw06bYkKKlGw8bmBw?=
 =?us-ascii?Q?gbL5sW8Y8B4R8Grw8JFyJE1NxDS37cRWXIduJU+c2clEFwVx+qUXz/cFj0yF?=
 =?us-ascii?Q?ZF6LFbbCN65P885OlCBHGjlzhsvxGFpkT2gH0lOEGx3n8NVmwMesnCxA1Ag+?=
 =?us-ascii?Q?sc+ifxDtXRwTNGlQVLi/bQkNB7ralFIB8kwfD3yjymgop5p9nWdWLksGf9U7?=
 =?us-ascii?Q?AJvopGIPatnSjiuNpeC2v4z/?=
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-Network-Message-Id: ed1da5ef-3aff-40b7-df82-08d91ba4ef8b
X-MS-Exchange-CrossTenant-AuthSource: HE1P190MB0539.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2021 15:35:45.9212
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iWBjPGvYbdDbxgxAgVCJkdIjw8g+qnEihq74jw/UqdiXocZNEgFQCU/784YeKBW2nsM1/oFCoNt7YKPHgv5WQnPC0aQ9kwniXRKtM/FUQa4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1P190MB0268
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadym Kochan <vkochan@marvell.com>

New firmware version has some ABI and feature changes like:

    - LAG support
    - initial L3 support
    - changed events handling logic

Signed-off-by: Vadym Kochan <vkochan@marvell.com>
---
 drivers/net/ethernet/marvell/prestera/prestera_pci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_pci.c b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
index dba6cacd7d9c..5edd4d2ac672 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_pci.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_pci.c
@@ -14,7 +14,7 @@
 
 #define PRESTERA_MSG_MAX_SIZE 1500
 
-#define PRESTERA_SUPP_FW_MAJ_VER	2
+#define PRESTERA_SUPP_FW_MAJ_VER	3
 #define PRESTERA_SUPP_FW_MIN_VER	0
 
 #define PRESTERA_FW_PATH_FMT	"mrvl/prestera/mvsw_prestera_fw-v%u.%u.img"
-- 
2.17.1


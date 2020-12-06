Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7A42D0868
	for <lists+netdev@lfdr.de>; Mon,  7 Dec 2020 01:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728641AbgLGAA5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 19:00:57 -0500
Received: from mail-eopbgr80054.outbound.protection.outlook.com ([40.107.8.54]:57805
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727661AbgLGAA4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 19:00:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T5kMenTQubz3YtWuXqa/9xqBvgk9EUZguTgfF22nikDfuSM9ltRVvqMBHXgsk/laS9Cfit2dTIfrA6c3ZrcrmbR8Jifh8EQ/ZGO+wCLKp8hhLZkFuP05lHg3/0Gpw3uw3sAJFjpkX54c0huiNLVM1tFgu3CIMzWmR2QrR8hR412EhefrCJytt8q8ib1GOpOXj59ndJ83+DQO9sUbVOlVOVgYMMg+9s1TROCBggY+buSxi08peCAeoW14B5ahNY80+PtcYhQwVoI2ApsAY5dwIPlh95m75tPFD5g8lmjMNkBfirAXv3RzohFzmGGT9mIzoZh9jzLyUlym2M1hmIrpsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xlyqz3yJ9njuGgQBhsUP396C/6uizMYwO6C+RU7vrhw=;
 b=oOIWH7C/pt794AsK3N2hWxIfxJ8I2VX4Ilo9Nj+wnU1EwTq6e2PgTSHkYemFNNkZv5IznRIsMtIiAz5J5LW6l5a2FMZGJiB5khMnwCwtle8xib3w3qjtKVTuJU0iGrqfzKq8GCnSdSQfotXISsS5MpetPO76E6f2nE946wMzb2dlaZVkQAe75O9bMCNJ26VbBDuv3bwc4ha8/SYYRdna0cIRvugN0tTUEwZPPCUQb/zP8pvBXB/YPbjU1vyPUqUEvcVYpJIq66lYPzFh441FTL5Lmj+TtqaDgqOoMwE0XD59r33RfKGHSK0HDQ13sTGeO0TNX+5V9e4JS8qEDhIZXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xlyqz3yJ9njuGgQBhsUP396C/6uizMYwO6C+RU7vrhw=;
 b=C1EmycvCPuskpujXPq/eDecYd4YnLh66xnt/4kk4qTJ+omeHPNP0fwxoOFP0HzKxE4/kzSv7MOEn/sfXBJMoxk4CVQM+RNBWN4VFpge7Jjo0Wq/3csRKUiluvjbIHrocd3F/QuvGKEw7sSPLNx8mHGBCEv9OyN2C44hpH8Eeg2I=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB6637.eurprd04.prod.outlook.com (2603:10a6:803:126::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17; Sun, 6 Dec
 2020 23:59:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Sun, 6 Dec 2020
 23:59:59 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jiri Benc <jbenc@redhat.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Leon Romanovsky <leon@kernel.org>
Subject: [RFC PATCH net-next 01/13] RDMA/mlx4: remove bogus dev_base_lock usage
Date:   Mon,  7 Dec 2020 01:59:07 +0200
Message-Id: <20201206235919.393158-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201206235919.393158-1-vladimir.oltean@nxp.com>
References: <20201206235919.393158-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0156.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::34) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0156.eurprd08.prod.outlook.com (2603:10a6:800:d5::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21 via Frontend Transport; Sun, 6 Dec 2020 23:59:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5cfb7128-4e78-46d4-663a-08d89a4309eb
X-MS-TrafficTypeDiagnostic: VE1PR04MB6637:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6637EE50877F4B301F0AA1B5E0CE0@VE1PR04MB6637.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: A8120M89+dz3pUb6PuMOQ8VegO934esILN2+3kjUb8CecTysNn32g41EjmjohYirkttJoxbYCdoK4ng74xAVE0DrQ7cM+PcEXMIw/C54mHGrt1CmDDoQ4gwVrl8BDFsRrYWslY4TOrVwp41KDGuvLMJpnNfyxh9y4H2bX7KQLiDzmjncIrg8hPstWB+cUXiPgoZP13t1AJUzl8XeEJCkbFwWtI3sFA9Ly6fdcb6nAS1DNN7eKoYZTTLGkXfrByNjzRuG4bc0BwbTx3Qxw31TkhEHKtmsCa4vno+dExmaqnpkICu12S9I4ImKGxaz808yQselNY1JXsfdADBYFy7ybXMReosYfSI1lb6EoLcQQnp1PdY3hNUnzRq4MNVTFbkT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(6506007)(52116002)(5660300002)(66946007)(66556008)(26005)(8676002)(2906002)(8936002)(1076003)(316002)(4744005)(110136005)(54906003)(478600001)(44832011)(7416002)(6512007)(186003)(6486002)(16526019)(6666004)(36756003)(956004)(4326008)(86362001)(66476007)(69590400008)(2616005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?qv0IIiYZQaBmM/S0e65Tu9ZnE9PleUGzGvs1/lZYu3bohZcJE3k2Jyp2qO7O?=
 =?us-ascii?Q?EHH+tCf6tHAnWpmQUzYoX29DbPhESWzFYan+na8Kx1AdAi6VvQ0+cn7sG03i?=
 =?us-ascii?Q?Snb4Hchk1i3sMuO4HNI82uvfgn75sB8Sxnijj+XAJrnbawIcUJRPY3rDG7aD?=
 =?us-ascii?Q?wgGfVI23Jgoa00lyKVDww0qj8U9QSaMuoqivwxIRxgX92rlEFKqfSTaY4F9O?=
 =?us-ascii?Q?+jf1zLC0MxUxwTPfRol8kgr4hKYeJeh3a6wTQgH/V3qSaeBusFqWx8besG7q?=
 =?us-ascii?Q?xyq1DtF1gwE2sMdWWoDMp0Ez+CSfQLLeLqMFLjOzi5DOHKMfWLCvVgpYnJKA?=
 =?us-ascii?Q?MRJSpR/eVlxgxHYwRi3934j7Yywx7PcsSR7xIG3rSwmCzKCB0if5jfOZ/ju8?=
 =?us-ascii?Q?psYTqjh6hbo47G/ASkG+s6uIuRRX8rDYQRYX9rNYcGBQMFS5xKGRWFVE57yg?=
 =?us-ascii?Q?ReNJqIuhJtH/xukjdYYtlplh5nX0R5gHSUESMiUoOt7ccPLmBbT/zM551flV?=
 =?us-ascii?Q?fmWcdkR+E4AGQdSVyvvasY2ERSuXG0fxYimfhu8h7zdrMtAiiiOe/WWNLhHJ?=
 =?us-ascii?Q?3VtkZRH3bKU/2NbFZB6ZTQ6nHqV6AandIQ8dhq0CbGPO4ENAUgQyNyFLT9bl?=
 =?us-ascii?Q?hoB9FeGBbUAnhJg/UwG8quMyrukYyEv4LS9j92E6VymiiDddBY1jTf225c1B?=
 =?us-ascii?Q?Ao2ltVNlKsCEzX77vHWZU2kQkx5DbrUiMJ1Hz1nE05BrS2m4qJIz0EbEQXiM?=
 =?us-ascii?Q?Jga/racZUQzfpr/YiS+whVZxML9ZmuIjh967lvS+maZxqUYWGxjndpXRlG6S?=
 =?us-ascii?Q?X4QOXX3zd6Ef7PTmEGsP9piNP4bDS7cXJOXLRX9gKVHgNuleychr3j2DBK+c?=
 =?us-ascii?Q?JIQ5pIdASpZbQhxs81xIDP27+SXdSK6nkFTuBNYO5l15rUOaTLUljGdy7fCy?=
 =?us-ascii?Q?TWYJ4W5o7JeMpbUeubgMGeM3P0tfcgj7cq2t2fnSCok9lRFnRlQfv9uffd5f?=
 =?us-ascii?Q?mnXs?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cfb7128-4e78-46d4-663a-08d89a4309eb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Dec 2020 23:59:59.6291
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uE8KA1pMOQRM6XqsNez5FZlKPNXDzq+iJ037BRWBfUmjkb78UeSwT3v/7jUm1RcsWEvfaSEkYQzFBesZqYuh+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6637
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The dev_base_lock does not protect dev->dev_addr, so it serves no
purpose here.

Cc: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/infiniband/hw/mlx4/main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index f0864f40ea1a..e3cd402c079a 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2265,10 +2265,7 @@ static void mlx4_ib_update_qps(struct mlx4_ib_dev *ibdev,
 	u64 release_mac = MLX4_IB_INVALID_MAC;
 	struct mlx4_ib_qp *qp;
 
-	read_lock(&dev_base_lock);
 	new_smac = mlx4_mac_to_u64(dev->dev_addr);
-	read_unlock(&dev_base_lock);
-
 	atomic64_set(&ibdev->iboe.mac[port - 1], new_smac);
 
 	/* no need for update QP1 and mac registration in non-SRIOV */
-- 
2.25.1


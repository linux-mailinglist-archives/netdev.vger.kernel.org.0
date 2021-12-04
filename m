Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D397468712
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 19:29:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355671AbhLDSct (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 13:32:49 -0500
Received: from mail-dm6nam11on2112.outbound.protection.outlook.com ([40.107.223.112]:6588
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233170AbhLDScq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 4 Dec 2021 13:32:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVb+F7SKKNhmMizSChh4YvJw2+IC14q7puTfRvARWzOsTufq8TuX/lD7fvZbfHH1ZHbCAe1Q+um7+D2ThoJR/+YeqKjAe1Pk1IPLP4w0aSSaCpEUHX/prZ4EiS7Z8pIMIXY2e9hByyWqSSS0ykT1aKR5r+DkAt6p8y0Mg5DL9XCL+w8M9FYliJCB2/1YvyrPXvIVRiipFOsz27YVvga/Bv9cqs5oO3KtI+7o2IFxBvMfZHKkfYa8inCYMeCcAMTppYmG2HbeO0Ct5cAidkw1Pv2m69T/NLiF3b91/jgJS3Q50r31f3Qvh+xGLWzI3PQMFMTqB/nR8hITKxYvadT+tQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tKsV0+aJT13foVJqdh7fX35si6lg1Y4VnWIc0IliEVY=;
 b=dqC24rq//RAxvAwoOaZTEAm/wwCtq4mrJrJy+OONWlg5JduM4vo+Ed1oCwEJwd0l7ZwrRslVNwVzymO3R+hIimu1TFFppkjSNcDm9UysjBprZpHrT5tuKMYJ8eAuAJUAOY4hku5xTeLHNLUbJayQGTsSHwJGoLcZrY2RfdqYfWB2K9tfsFjbjRfA9GFOPevkvrddkirOVM/PU28na6vrd9gz1UYfg3tvcln9Ic9b+KHEZkCqv9Pt1yFm0UrPQOF/DM/DVsOvHfzdlFu+9sydz9V8pdoT3nZ7ZFmNX2/CGQgST2N99YpaYxYSkG8IXYHwx65dxrG6fw3GOMWZ9QdRdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tKsV0+aJT13foVJqdh7fX35si6lg1Y4VnWIc0IliEVY=;
 b=WcIWgCwrChs2RUxgX7KwgSytEUb/oznZFp3SHvCoG7TT98/1LrrGkk4NXxEv0DaW7mOojf+GVEpUXAQzU8AQKfgmXHLufToxjJVysnG3COqEnEcs5E+Gn/AJGpdTLL4rsZWHSbZ711vq2ZP+Zlw+Nh0KDZzMG1Wv874NoIuZAn8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com (10.174.170.165) by
 MWHPR1001MB2063.namprd10.prod.outlook.com (10.174.170.29) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.23; Sat, 4 Dec 2021 18:29:17 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4755.020; Sat, 4 Dec 2021
 18:29:17 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH v4 net-next 3/5] net: dsa: ocelot: felix: add interface for custom regmaps
Date:   Sat,  4 Dec 2021 10:28:56 -0800
Message-Id: <20211204182858.1052710-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204182858.1052710-1-colin.foster@in-advantage.com>
References: <20211204182858.1052710-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR11CA0045.namprd11.prod.outlook.com
 (2603:10b6:300:115::31) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR11CA0045.namprd11.prod.outlook.com (2603:10b6:300:115::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.19 via Frontend Transport; Sat, 4 Dec 2021 18:29:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 214dd33e-4351-4975-c415-08d9b753f6b4
X-MS-TrafficTypeDiagnostic: MWHPR1001MB2063:
X-Microsoft-Antispam-PRVS: <MWHPR1001MB20636A3B90B44CDBEB63AB46A46B9@MWHPR1001MB2063.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pGdVtFMEEW8HEMZNAifIn7CQPyru19oBJ8PgH7BPugMAi+Zrw9jDCSLVrveQKW1/iDDvjyjsAz3/sjMptYyZRPvoosfdCU5xostv3zoQthjgKPRht7plZtc3MnA9bZ5wkcuyFuxCTrUA+VA2x45Gv/Qczy+9ILMJhVfR3ilFpHy9Y1LFOtrGq3hU+BLZD5WTxZDtYeCU8vf2IzWH6ySkMoMiGcJgJ/PBsf3ozm/fKNYRbtHkjiWEHU7cfoIJGDCYV4rgHbu9OuSXmUkWUr26Y0iEd1ezxh1W2bl2TMU7ke64lBQTugMrm5PrH0XAgacMcRNBla0rKIwQaUfe+44TvHsINB+XAvQxA3XsgOmiWd/4yR6NX0zW2/MTAcepYLNWD5frxBfkQECcP/EZEuwPik0TOs6don1Xj6n5KyyuJU3Pw+NFUOkmeG5SERwhYbqpNIlMu5eRK7g8mBeSIzI0YFNCRys0zBoNUQdLk9hX7xzeBtaN9uc81hB3+iZfOHxRYsoagTfs3rT/ldpGdSduNaYPeBp0OSQcHHab7JHZTxCtUOT7xdwN+RNYFkYiQw5hnfW9rs9S2BeEFvUXTotgV9bIVQZIKHc6o0SHrWjnA9trYWO5GkPfH+HkYpIP8BVDLtx8xdCoRkWPbCRt9vzmNHkfhnmZoy8cscscJKDznHsqLlq8C9rtfYwUq9+Qo6ohgtpgwY3oT6gThSx/m3k9bQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39830400003)(366004)(376002)(136003)(346002)(396003)(8936002)(2616005)(956004)(86362001)(4326008)(508600001)(1076003)(66556008)(7416002)(6486002)(66946007)(6506007)(52116002)(6512007)(36756003)(54906003)(66476007)(8676002)(83380400001)(26005)(5660300002)(44832011)(316002)(2906002)(38350700002)(6666004)(38100700002)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Q2BxTWgImi6I+xid1PmU95x4nrC/U39nmNKk9TDJdkx1j/AqrNo7Tsi3t/4c?=
 =?us-ascii?Q?diwLxFwcZQx52KwBeP/nnkVHOaHD1SwboSZFq4SvvMoxD+Pur2icb61MvAFj?=
 =?us-ascii?Q?0y7tEpO701g3cYs/N1n6AyOegRCW6CQHz2mOY6EGvJnRzGZcSjSGm5bMT964?=
 =?us-ascii?Q?RjtMb94fO7wdbp2e4ncTHGI+fwnVKbrdmwfiJvUBDDOaZeQpxOldcS7Llkr0?=
 =?us-ascii?Q?KHHVRqtgBpjFki5eku54FFi3EpRx0ZfARr41iTNHor1bBTkcNWRWxePiG7qm?=
 =?us-ascii?Q?K7X/T0qYJ0JzyIOdvzCVb9/9mgDJ7AcS5OMHcmuxrXZZXIoWI47t0yzbvzDU?=
 =?us-ascii?Q?iY/vLHFmu+cENCAQ/QjF6cMqvEYdwCYaq/o+LIQKGNBsiNUUn+LDhOEv186K?=
 =?us-ascii?Q?doifoxwRl7LRwA7roJ1GOgRjBNpwTtwRo6rhPum/6dkkk8hKw+WSYxBfcoGi?=
 =?us-ascii?Q?JByhhDvN5+v9a1VSbx/UvcqAYc1mMvJUr9oCnSgHZCPkJZIoAeCMPrDbAgwh?=
 =?us-ascii?Q?aRnezww34c25IssaTKYtlKpYnz2yywtfiWQBO3APSRjgkrU8WZ5NpTTvFhdz?=
 =?us-ascii?Q?93ntZFFp2KqgdYJRNFQ+ctbsZZumv7+AndAGHYE75kvmwqYkMM34t0f3gEGT?=
 =?us-ascii?Q?ALsAWjcyVh1HQzzxCuL0ieVCZoPwD+jPvHkQo33IZS6WEXRtIsJk1cJTwif7?=
 =?us-ascii?Q?NzIgJhESDESwRZu+8Afchu+Q7q4+9RFEdTG5PpQ3wJJ/sCNRpObU1p5oSymf?=
 =?us-ascii?Q?gfAG52I6ijTW9+X2Iq4C/l13a7JOVkq7Z369ykC3O5qACHcuBw6TDzUVFxcO?=
 =?us-ascii?Q?CsUhSjNanzvVx9RdJya+x8P+i1gpYJu/XuLlJTYqo8fzjRjlSyuTadhdx8Gr?=
 =?us-ascii?Q?lvu39ybdrJNjhouDUp9LJ8Vf1nBCh+lCDrwiIijD7iAPEr18k1Xa4WNhs20I?=
 =?us-ascii?Q?ulE/z5ZOvts8mZ50FwdfAwtQplKp4fu27J8GfD9ZW8NoBX5TpEDYcaUU5dlw?=
 =?us-ascii?Q?ELdD/9CjO+ca9tNbZDX2mn92QfvAgCaFEciYjYL+NK3fjpaKzhGNQp8a07Pu?=
 =?us-ascii?Q?M5DIGZHm3wzy5yk+1gBiBCFpfR6bp8j+u2A0w80LjLop9bz144dei7TS5DTN?=
 =?us-ascii?Q?ULsGZp/jR7ZNGhrXqwbBohKi3WLItZ+jQDlpv4HfMiCg1je4T0Adf44jxpvy?=
 =?us-ascii?Q?Gz4VIP2tV6fzN5lHSqDSKspCnPuXsToS8IqRpzusLmF2f8dLhUU9l7aKzgMO?=
 =?us-ascii?Q?e+3Nez8Fn7RW7dfR9OwSaEQZqIMMU/TurManVBTOrGTzt4RcDGC1EKLlA21D?=
 =?us-ascii?Q?7ZFGfFaTWJ2KUcu79rCl0Ft6+2pJfpcTuwjcgDU27JdF1sIyzemdHSGtdsfL?=
 =?us-ascii?Q?NLhMV/TqGIFLNQf+uAOjDK+HWqiPgDx7FeH7JKhc3CPuLYeIQYsmHn2ztiCI?=
 =?us-ascii?Q?kEJyNcqx6dDt+uAS6HNgDhX2RRcXEv4KQIg5ZL89fILtL6+kLs6NnPeI2KSW?=
 =?us-ascii?Q?o57VQIw7qAJRp84E++CUWFNSWZwStisJLNFmmelEfoykDPjIyaSBQGqWs6Yr?=
 =?us-ascii?Q?854nvV0IZeBsr01oPMU8C7frpGFiT+Q942o55nPFgkQ/p/IQFBO+az9pibgD?=
 =?us-ascii?Q?q6t9a0QYo6QXxRcDtuWXqOfgfD4Y1fh8SjqW2fYs3YOMEBAvWFCWr6popuJm?=
 =?us-ascii?Q?rdEVpZf+yQpf5gKQY4Sn1hn/wok=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 214dd33e-4351-4975-c415-08d9b753f6b4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 18:29:10.0655
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4Zv5nhFnqDv7QF0GM5rodMw/0z4xoYCbi4I6mE6f/ogMPRYgjPDU6DgmeBC26+4sf6yo74hXbF0EmDqK4mmAMO+nB3j3gfmJZDYb+i+uH/M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1001MB2063
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface so that non-mmio regmaps can be used

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/dsa/ocelot/felix.c           | 4 ++--
 drivers/net/dsa/ocelot/felix.h           | 2 ++
 drivers/net/dsa/ocelot/felix_vsc9959.c   | 1 +
 drivers/net/dsa/ocelot/seville_vsc9953.c | 1 +
 4 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/ocelot/felix.c b/drivers/net/dsa/ocelot/felix.c
index 4ead3ebe947b..57beab3d3ff3 100644
--- a/drivers/net/dsa/ocelot/felix.c
+++ b/drivers/net/dsa/ocelot/felix.c
@@ -1028,7 +1028,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map device memory space\n");
@@ -1065,7 +1065,7 @@ static int felix_init_structs(struct felix *felix, int num_phys_ports)
 		res.start += felix->switch_base;
 		res.end += felix->switch_base;
 
-		target = ocelot_regmap_init(ocelot, &res);
+		target = felix->info->init_regmap(ocelot, &res);
 		if (IS_ERR(target)) {
 			dev_err(ocelot->dev,
 				"Failed to map memory space for port %d\n",
diff --git a/drivers/net/dsa/ocelot/felix.h b/drivers/net/dsa/ocelot/felix.h
index 183dbf832db9..515bddc012c0 100644
--- a/drivers/net/dsa/ocelot/felix.h
+++ b/drivers/net/dsa/ocelot/felix.h
@@ -50,6 +50,8 @@ struct felix_info {
 				 enum tc_setup_type type, void *type_data);
 	void	(*port_sched_speed_set)(struct ocelot *ocelot, int port,
 					u32 speed);
+	struct regmap *(*init_regmap)(struct ocelot *ocelot,
+				      struct resource *res);
 };
 
 extern const struct dsa_switch_ops felix_switch_ops;
diff --git a/drivers/net/dsa/ocelot/felix_vsc9959.c b/drivers/net/dsa/ocelot/felix_vsc9959.c
index 0676e204c804..74c5c8cd664a 100644
--- a/drivers/net/dsa/ocelot/felix_vsc9959.c
+++ b/drivers/net/dsa/ocelot/felix_vsc9959.c
@@ -2240,6 +2240,7 @@ static const struct felix_info felix_info_vsc9959 = {
 	.prevalidate_phy_mode	= vsc9959_prevalidate_phy_mode,
 	.port_setup_tc		= vsc9959_port_setup_tc,
 	.port_sched_speed_set	= vsc9959_sched_speed_set,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static irqreturn_t felix_irq_handler(int irq, void *data)
diff --git a/drivers/net/dsa/ocelot/seville_vsc9953.c b/drivers/net/dsa/ocelot/seville_vsc9953.c
index b9be889016ce..e110550e3507 100644
--- a/drivers/net/dsa/ocelot/seville_vsc9953.c
+++ b/drivers/net/dsa/ocelot/seville_vsc9953.c
@@ -1104,6 +1104,7 @@ static const struct felix_info seville_info_vsc9953 = {
 	.mdio_bus_free		= vsc9953_mdio_bus_free,
 	.phylink_validate	= vsc9953_phylink_validate,
 	.prevalidate_phy_mode	= vsc9953_prevalidate_phy_mode,
+	.init_regmap		= ocelot_regmap_init,
 };
 
 static int seville_probe(struct platform_device *pdev)
-- 
2.25.1


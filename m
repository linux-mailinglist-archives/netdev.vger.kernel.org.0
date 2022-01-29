Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F3884A3237
	for <lists+netdev@lfdr.de>; Sat, 29 Jan 2022 23:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353362AbiA2WC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 17:02:56 -0500
Received: from mail-dm3nam07on2115.outbound.protection.outlook.com ([40.107.95.115]:64192
        "EHLO NAM02-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1353305AbiA2WCq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Jan 2022 17:02:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gEAV1pT1nBT0+KD3ebLlEJrN6P3hecq5EyR6W75IvnMpwjwNnbmBQ6/OhozDIbYsIuO99gxm00cvP8uIoien1sNBWMKOMK+45Q8rwBDCDQKytcOmnDxL64YRqBzIkCRJolmZYLOfD2Ca5d7N4YegsGJLcH1x+PLEkQZ645WB9LeRzIlINNyfxF+AuxuSA41FRk2kQ7SAvYvk3AxIkwgmdtPsUL4fheMTMwaqBzmtqWevHuJd6mz1w5Sg9GKsB52AiQjiUxIx0klomG4i2yiCC881oGz2ifoCFbTBP00Q57fBQpRdfAZ1H331wZ6QnV/DqYtzPYTA8eHTGSpns/OCsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l19gVSLOw5HzIj0qk6WuM2K7zkumJPbMEI9N3iDsGbM=;
 b=ZeAB63SeXjTqQ6wVrAU4nTtGIn7jbZOXbpbVeqQBi6vAUIvEswDk3DUIzXZEzv3r86czgzFc+dV/8jb6fKmznjpnzqSc7EzpelUbm867mzHQfQYBLehDOwPyiabmp89Y48dJhWdPkofY0ly5iVtuky4pFHD+sypPZrzGoxW8RuOGbbnPCRsuNrMncS69CO0J084U2iQg+4ouxh9pvcw+gGByp0002m//vYJLMy8cIs5rRWvuYN87CG4e7qe9qNm/2okGUMo7ro1NgFhJHOl2w3hdjJeIEjCkJT5lEeFpNSGNsGwqqI0q6XmwP0xRAoRz/QD7fhAGARyms2+bJBliYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l19gVSLOw5HzIj0qk6WuM2K7zkumJPbMEI9N3iDsGbM=;
 b=DQZlabjaVKdAdwgGgVDo49lndPsX+Gi2LgKGbhXn6wr7UhPAwOOsMlbbudr1FrGXJc+9YFBQM4tNzUrXui41gJrmLKiSYEBwwtGIFQ0tgNWTzPvvbhpGi2vYOMhI1qQ8REXsxTyQ0fSOwZs/tB//18loOs7tBA5FNW7HoVfT89A=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by BYAPR10MB2968.namprd10.prod.outlook.com
 (2603:10b6:a03:85::10) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.18; Sat, 29 Jan
 2022 22:02:43 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4930.020; Sat, 29 Jan 2022
 22:02:43 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Steen Hegelund <Steen.Hegelund@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Russell King <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Lee Jones <lee.jones@linaro.org>, katie.morris@in-advantage.com
Subject: [RFC v6 net-next 5/9] mfd: add interface to check whether a device is mfd
Date:   Sat, 29 Jan 2022 14:02:17 -0800
Message-Id: <20220129220221.2823127-6-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220129220221.2823127-1-colin.foster@in-advantage.com>
References: <20220129220221.2823127-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO1PR15CA0113.namprd15.prod.outlook.com
 (2603:10b6:101:21::33) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5a8abb1-2371-4709-a03a-08d9e3731303
X-MS-TrafficTypeDiagnostic: BYAPR10MB2968:EE_
X-Microsoft-Antispam-PRVS: <BYAPR10MB29686AE75D1258978CDE592AA4239@BYAPR10MB2968.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OjXE7PWmGirYtVnU+6+nZ0cLmhd/dopYWYDOQ5I7Y3n6SrPEhCSF+HsbrVVt9rQgHl6wvp28KEr9SKzZyzO49hB4GmOoneVNEbekpBi6MkhBJreu9qL+p9Fv1SQWdRyOofMRkMvBt0LiUSbSSfWmECaDD4ymOFzUsyM1WJ3hLXUBsncJhmsKYgkxF5VTw4JH5DtnYiNKC33AX6CCgvEllrVsAs6Vc7/r1UBqea/XfLfehwAizxdxvEaw6i1SMPZWEGgRFNJRZBkBiKFoLDS26zTGt6fPSh5TqC2JVYCWsCCVW1zr+w6CVID42bDShpFbr90rgPUFxXKDquPPFABAz2MwUvd18eNumGcfCAH2DQi3DHQdfx0gfb+jO0Q858lqAsbnwcf9o2b/wKMyEeOG7Ae2+6FVL65TbWkjYUkhxC/CnTIrK97DzEbl1lqF8ixkmSSKEY2RVGup87lu9Jws5Iu7z5eehzvdNU2Ki5ziZAM1sQKz1h7pXMldCXx1wKwbTU0hxpNF+G2ANkQ/hfzka5DVz3zvCnvvC+xYBcinm5MuSbfewu0/MafoS4yelqG1n6bUY3NJG9TN56wXRfnzZCbdbx9znD1fU7WL/qLaYMOg07Ey3IX8QnBlQrt4DjGYvI7STsshOGag8OKW8zqQpP/lloj30FOnbLbu17JmXPc3jWnObWzIdj1Z6QM14XYwmNBlcu7MDmqPnkZLvXnwjA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(376002)(346002)(42606007)(396003)(39830400003)(366004)(186003)(508600001)(5660300002)(6486002)(1076003)(86362001)(66946007)(8676002)(66476007)(26005)(4326008)(66556008)(8936002)(7416002)(107886003)(6506007)(38350700002)(6512007)(2906002)(44832011)(6666004)(2616005)(52116002)(38100700002)(83380400001)(316002)(36756003)(54906003)(20210929001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+mXanTi+Xlxscve8ICfwsm0adz3d46DiCTJzlLSfw4Gu9A6b9xfwsqpBvfRL?=
 =?us-ascii?Q?m4SY1stJCYiGvF9pd5UHMAPFOEpOLrIK7LdTFDcgmNShFBt9Je71yjhk/Bif?=
 =?us-ascii?Q?ERpAWIOOz5Z9AbOv/bUBYPBqfVNSJIKP1uLvBFo9WcONzHMG0gLrMfvRtjMd?=
 =?us-ascii?Q?8HLQv5757a2ZOvx4DKRg+Rl8gY+3oNoQ1mN172igwpTnKMSeekKOVyH5Wjdl?=
 =?us-ascii?Q?rgvsZrGYNbQnAGoSKksiokqtFBNty3hunFM1HyPANEj6EHbE93GT4Obsx7x3?=
 =?us-ascii?Q?kf99A7LuK60kHIlSt39SJS13L7JFlB8x4sYme1mwHlyUrhBO6k1WNbe5r2jW?=
 =?us-ascii?Q?OEpT5te+BTTqcRVUuHZ67jtw8a9PVdPgItykfgcHUPFPHl09jdyVUval21gA?=
 =?us-ascii?Q?j2jABqN3DAAlrYcqa3NdrtiCtqLK3XvqyxjMqUYc6lPKuupb1sqLnwmiXX/r?=
 =?us-ascii?Q?Fx1sQ3BHFYKht5fYulI0t0Xb8C+BBTHwZuP/PEPn9drmmcTBCFSXtH72KbCG?=
 =?us-ascii?Q?7vJ4UIbAGnmVqRrbU3LxzcNu5eZyZFjCTxSljdLil3qQ+Zgh/RsVmBGtKOgY?=
 =?us-ascii?Q?K2LAFvpUgUqKDPzaUv8Bsf+WBrCE3d/IF4ySSVdXUM0hYXYgNOzY5cE7QDrL?=
 =?us-ascii?Q?CjcFDgyXrZYrHVRfdOccQoJnOlTzdZSe/rWaWT51yP+WwEwD5BUSfytbbbl+?=
 =?us-ascii?Q?M1WYB6/I7MKcWnJDk8HM/2GRwlf+c8wIc4b2/LJXv5HNUzhvkTEo62JgtlER?=
 =?us-ascii?Q?LLQnXUF2FO/ou/Vw0QGcVzeAlgbcb49CuH+7ySsFBnog82oIq66qYHlOyTLz?=
 =?us-ascii?Q?v9GhcezjfBA3Q+3QXexwOV1b8fNkQmF6XBUl2XkyJxfxIAVcOSI9weuQvV8R?=
 =?us-ascii?Q?n7ysoLpLpoYDSj8bb0Q8wSUlIhXjmCnR/uhz8YF4HV3+aXroXlyUMo+THwwV?=
 =?us-ascii?Q?ZFr1MXkI4jGTK/M010yMz6k7xNtWNq8f+yk+5Ds2/qgrnhUXAiV+Aft6/wce?=
 =?us-ascii?Q?W9pCLMuPrK6YluqsIiAJwcAqYrnbo1jW6PWPDBFrxu0JExka74lXkXSwLSuc?=
 =?us-ascii?Q?WPH5rGT1t9X/dgYS/er9d4CN40cHXWx5VinQI09hP1VbZ4TXpGDjlv2zIUXS?=
 =?us-ascii?Q?E2sTc8bpXVn1QNOuN9p/pv0PZn1zS9vSipFsdWhYYHEuVpwXef4qsfIhkF97?=
 =?us-ascii?Q?RFwbiFdSnchAIFI6w3g2GHl38BMjlvKRbnNGOziHwthWR79z7fXJfmlV6sKR?=
 =?us-ascii?Q?Yk+Cgo5plFw178DZzElJaSoikofog+GEibV5vyIRQYOTQhB8DRnz36MpUDNF?=
 =?us-ascii?Q?IhYPbgh314HL32X/GG59pSLzF6pvB0vlwleSDyYFqOqQCSWKgaqcOWXPdiaC?=
 =?us-ascii?Q?WaJYZGUCN88bKOWNc2htk2mwD8CPN1GzArKXAzZYa0fASwP/vZP+zGP+C4I1?=
 =?us-ascii?Q?VvllvvAlJFZqZqtwDtuU5ub1AvWfqff+B/1L9KzoCdUtz6++Ehpv97yL9fEl?=
 =?us-ascii?Q?906puulOKnYAON1S9z3a+0o6WuCrvKCVivPOP45XQGYiF0m4w1uHyzgNgQ44?=
 =?us-ascii?Q?yYYQVwkFle4CESKco2tntDomstV8Hk9vLQzQ2W2hgfPmjxpacJx4ZlwsA9Da?=
 =?us-ascii?Q?3Hr04HLT3r5vNHLzm1QVTpSOjJqAI91wdB1OsR481qqP2tYu94lsyIu4N/Ok?=
 =?us-ascii?Q?7/Fivg=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5a8abb1-2371-4709-a03a-08d9e3731303
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2022 22:02:43.1415
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xk1yPu9KSGLRITdm4TIWUNy/u95hX1lndqCFIwKBLB7xSRXOFiT050MxFvfLaiE2tiENNssC2JdvHmT31VayV/iEHA4G2m86WeFPSbQgemA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2968
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some drivers will need to create regmaps differently based on whether they
are a child of an MFD or a standalone device. An example of this would be
if a regmap were directly memory-mapped or an external bus. In the
memory-mapped case a call to devm_regmap_init_mmio would return the correct
regmap. In the case of an MFD, the regmap would need to be requested from
the parent device.

This addition allows the driver to correctly reason about these scenarios.

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
---
 drivers/mfd/mfd-core.c   |  6 ++++++
 include/linux/mfd/core.h | 10 ++++++++++
 2 files changed, 16 insertions(+)

diff --git a/drivers/mfd/mfd-core.c b/drivers/mfd/mfd-core.c
index 684a011a6396..2ba6a692499b 100644
--- a/drivers/mfd/mfd-core.c
+++ b/drivers/mfd/mfd-core.c
@@ -33,6 +33,12 @@ static struct device_type mfd_dev_type = {
 	.name	= "mfd_device",
 };
 
+int device_is_mfd(struct platform_device *pdev)
+{
+	return (!strcmp(pdev->dev.type->name, mfd_dev_type.name));
+}
+EXPORT_SYMBOL(device_is_mfd);
+
 int mfd_cell_enable(struct platform_device *pdev)
 {
 	const struct mfd_cell *cell = mfd_get_cell(pdev);
diff --git a/include/linux/mfd/core.h b/include/linux/mfd/core.h
index 0bc7cba798a3..c0719436b652 100644
--- a/include/linux/mfd/core.h
+++ b/include/linux/mfd/core.h
@@ -10,6 +10,7 @@
 #ifndef MFD_CORE_H
 #define MFD_CORE_H
 
+#include <generated/autoconf.h>
 #include <linux/platform_device.h>
 
 #define MFD_RES_SIZE(arr) (sizeof(arr) / sizeof(struct resource))
@@ -123,6 +124,15 @@ struct mfd_cell {
 	int			num_parent_supplies;
 };
 
+#ifdef CONFIG_MFD_CORE
+int device_is_mfd(struct platform_device *pdev);
+#else
+static inline int device_is_mfd(struct platform_device *pdev)
+{
+	return 0;
+}
+#endif
+
 /*
  * Convenience functions for clients using shared cells.  Refcounting
  * happens automatically, with the cell's enable/disable callbacks
-- 
2.25.1


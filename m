Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B57074681AA
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:01:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383978AbhLDBEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:04:38 -0500
Received: from mail-dm6nam11on2113.outbound.protection.outlook.com ([40.107.223.113]:36640
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1383953AbhLDBEc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Dec 2021 20:04:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SIoHdK7GrY7ftP+S8hIHYq53p/AzYqTyaAsw6oT/dp0/9uMQuED59O/QYLL2pj0e3dvRhG9DLhN1x2P/QWoooXHAeCfB/ESdgKcGku+bBwIKhx0BiqKvdyfqQUw+SEF7ddyO0A+m9QwftOO30ZooqJjgHjpKXzwUxfRm4FCK3zcCFvn6tsj31iS3lHGC5wswMxAru0AsWnB2X8XG3ktP4h+YbyvPx/cff2eR1hTeBlubpECxIYAagEwc80Efg4iqNdR8xAq7chNtaoPeAhGTQp+TZgipXPffPcPsuzAfHNkqo+Cgu9eTNtF35bjDiQuhxRD+J3afEjbs5xuIpcR2GQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=th9ScbWDPw/DaWCBSLNCbdjKbC/QjWgQfEV1eslwZSk=;
 b=JjWxC/jf32tFl7BrCQkhbpr62z9+JPtpR3gDu+06Klt4TsmapYBIKeSVSYqsi3wDxkyRPNg5+d+Ij4a07iA+Xa1VWfI0fj1nGeaepQOGP8Bv09nqkUnwnnlBVRj6l5USLTw92YlYQxvV5BF7Atf55/yN4C6Bf6GxWLOdgEIj345EKUyZBr2O/x779o0F36fN6yjZoTx8oPTyFlYSdRZPNWjx+GeEf0rZd2SCSRmDe+uca2H7v6QmiSRSHk0Uxj8jHPAbDbxf6udtyg7zGMPvspM3DTPKJjmW9XyIPxBBj5l9HP52ZQRjyGagz66XZlFxB5F+h8IsbjhmsdHugdRyVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=in-advantage.com; dmarc=pass action=none
 header.from=in-advantage.com; dkim=pass header.d=in-advantage.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=th9ScbWDPw/DaWCBSLNCbdjKbC/QjWgQfEV1eslwZSk=;
 b=gfLSbJyKlygy6yP4HYvpY3v4lq1IZAZMKJNyjhtNHAvYeAuCrej21XdA9aW2dPM0FBJcP9Xm5viCVZzoMbwcMB8fyOSL798FhriZjY63PyFprZe3MZCA/W/5S7hEA0QNelCHJYVZOZ6XsuKN7w55zYgDGORFNDorFL6SxZHwUO4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by MW4PR10MB5701.namprd10.prod.outlook.com
 (2603:10b6:303:18b::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.28; Sat, 4 Dec
 2021 01:01:04 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::6430:b20:8805:cd9f%5]) with mapi id 15.20.4734.028; Sat, 4 Dec 2021
 01:01:04 +0000
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
Subject: [PATCH v2 net-next 3/5] net: dsa: ocelot: felix: add interface for custom regmaps
Date:   Fri,  3 Dec 2021 17:00:48 -0800
Message-Id: <20211204010050.1013718-4-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211204010050.1013718-1-colin.foster@in-advantage.com>
References: <20211204010050.1013718-1-colin.foster@in-advantage.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:300:4b::30) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
Received: from localhost.localdomain (67.185.175.147) by MWHPR02CA0020.namprd02.prod.outlook.com (2603:10b6:300:4b::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Sat, 4 Dec 2021 01:01:03 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e6dbbc48-9085-46e8-da72-08d9b6c18bec
X-MS-TrafficTypeDiagnostic: MW4PR10MB5701:
X-Microsoft-Antispam-PRVS: <MW4PR10MB5701A0CCB4BC09315AB44BDDA46B9@MW4PR10MB5701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Lo8Po+nrCqDKGcGkry4pGT8FZ2K9cXhi+tqgOurp11XxZdQVfC8mI55vWQKYOFkli3XnM4C0UT2rBgzW/OY3JTtT2ZWa/q+tuJgyA1yml/EqfBjXBN+XO2pySI8ghETf5ZbkJabuIFBZuIWNWFarMX5SzFUe4HjywMhuvbN4jeuIayWnhRxEtvtd2lb5SEV8uRc81yBD0SFvULwgA6FUARJz7UBXg9qYobAFHzd2zBwjQwpv0uEFWXeCD54R8y+KNbRI7IAZJO8GyuR7HQJ4VvCS95QZGYXfRFx+lLcnspvuEvU0O83zgGrWyD5r2gqq6fzutwMAqsFoQBQy/LSDAvxqCwaPSekDlRcmhS/L2iVKiAXWqMCsAumz9pYR/QWgGcoV+AmM1Mlli9bOKbIsUzowoyrpicBNVg+L3C8n9YVpZBW34vap8tpvx+g0OvXHSBJEyzt97LP7ym+4EI6bt1Ql2eRxVdLWKHFUqUVd87+eSgQcLPPLsbap5xnCMs89wQhg69Qzp2x3afHABfyk3+AErYjiaHNkqICBilxXcCUzZRmeGYVOycPEpvuV5eepaIScaDiA0W4mRrRS4TKF7hhLxj+J6YHa7pXC+apPFT/VSf4Bxqrbz7VEJ/aer11bA4GHVxzCJr6ihP3vKlgOedYDLsyBxCmrSCShXMFOlGWWro7F3eU3B32XkogmBhhnT3WULV4bLEaZPpijIy8OxQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39830400003)(376002)(346002)(5660300002)(7416002)(6666004)(83380400001)(6512007)(2906002)(8936002)(66946007)(6486002)(66556008)(1076003)(66476007)(316002)(186003)(8676002)(4326008)(54906003)(36756003)(86362001)(38100700002)(44832011)(956004)(52116002)(508600001)(26005)(38350700002)(2616005)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Jt8WM5xgApEeRyyznjblzrVUvcW8s591xmhN2hMnQ+OGA6CHaE5B0Shx3aLQ?=
 =?us-ascii?Q?4Y3UCsPEB+LvTwu1phM+/PaHU2s1fiJEt9Hgk8qQIzXY7/u+y7voVe+CdViZ?=
 =?us-ascii?Q?Gv8YW0HypJ0dgiXd0lMN/m8cJO5V4K0fnN2GROjiN7RDmzgfOKCSEEsw89Wi?=
 =?us-ascii?Q?OOnOPoWNxTsdMK1bjbW+SF5qKU7BnSyuaVRkphZoqm2x7yVtMJ16hNc4EqOF?=
 =?us-ascii?Q?otJ3pDV5nrmSmrh0M7pL9b2c6Tkuc0iXx4iq6Pzg+rwVTb6OKzwo0IT0pxaP?=
 =?us-ascii?Q?WDoVtMwutt07nFjUZHAZHNKjLVcn7UI72P1u0y7IU3FAjzyQwIx1s6Wx+Evr?=
 =?us-ascii?Q?jBjhn2FtgUs4xKbyZ5dZ9MGS7VfHATXEcRUXsX21I7u0kmWAYPFWprviYPq5?=
 =?us-ascii?Q?K3X2M5EUBDsjFuYejRPF9fx4sMtcWoyLzf1auXSMYDwOFVxpuOxWz9nRVgfh?=
 =?us-ascii?Q?ibX5/g/Sqk7imzSwPf4253TjgO+3EB0p1KDgRGSA4Lqg1yIY8dCazYSQc0TM?=
 =?us-ascii?Q?0am7nQhf594sCpu40K8WJVKSFgckEU5wpG18LVrA/YVSN0RlHWcJu7muneXB?=
 =?us-ascii?Q?aXS8rW32Rb1zjqbMr041JadAun/mk5VCl1Hvr6uD48Zmta/PNSJI7Yd+SMxf?=
 =?us-ascii?Q?emr1Stg00YvzgfRnHLg+nvaXMSWqJ7vkpvD/4zFgrE7j9mKYF44Bgklh0NJx?=
 =?us-ascii?Q?KQG25kYfUT/lW1p4Ca8f688SwvWfax8k1EVo0/mInUy4Bs90lNNBZU9O4vsx?=
 =?us-ascii?Q?nRWXzbdMhlR149CeOLnEdTjTR9N4sOWpYsKyFM/gMg3FoppvspWH8wtgKXX1?=
 =?us-ascii?Q?soaClHDVVVGNdcfBu7SYqUD9BZKApQP3CFIF97o6H6VKu0JSMEtq3wURb1Ea?=
 =?us-ascii?Q?DVb4Vi90o3KqJUfBmuHwD1gppcbKqoZRqJbzSOC41P5ykZ7MOUXjLkVbuTmS?=
 =?us-ascii?Q?CDzNcgGg9OGrJu7UhYmszXmkfQkooOffgpscfMcshYTNliKs2zhtvaepDzKO?=
 =?us-ascii?Q?7OZdMekF496LZrJHn5hQeVEoWrnbhVTam28J01u+XYyx43qyrcC6rqgc/C23?=
 =?us-ascii?Q?KsZepg+Kh+GQCtPMHF1o96/x9YiMCKyuQM3eaayIEzEs1u4gecauM4i6RHZP?=
 =?us-ascii?Q?++Zi7iFjVZM6967xzvNMTkjZBsn5oqlMRlIM/bJZcACyxTSg7d9F0isYwBEQ?=
 =?us-ascii?Q?w2FW9OBxpTKPWrPSQXCXKf1uKP/1F4fCQ2euJdJib9Qad2d3dOPhSMLGE3da?=
 =?us-ascii?Q?Hv3PEF3u43/FkovJIaUCdQXKOOeW1bbZ73r2FGuGhTaKpf8t9O6z8ZPNeePJ?=
 =?us-ascii?Q?TjWtsJcwTKR2cwpFKeJpKM4FLAXOUWlRCMSl80yl5gjYZFxPUiF5G2daeLYV?=
 =?us-ascii?Q?HNDpB6eVtBpOkJwYxLgxAV4BWNob7Qfk8OlWgGoihxmYmTjTn1l7xmmTWBuB?=
 =?us-ascii?Q?y/CC3GZPxR1fXHfr6q8cLw+SbzqTqgEFuxGCWUH5rWhqXfDQ7nqnRWI8Oxz6?=
 =?us-ascii?Q?rDEqzY6dyMqHUiwoe+uMsvT8clMdr/Lsx79n7/GyjT6ciTc+leC4gSd2BlqZ?=
 =?us-ascii?Q?mjcb1waExhnYMfCj1uqSOOcDakd7t5HrqT7oMhuY3ARPwM77b8BlPiswaFHu?=
 =?us-ascii?Q?xCI1omZgIiisVX85ufKJ7WHBwiHXFKjjMCih0tmNpE3JU9keokn0yNLZw4/S?=
 =?us-ascii?Q?bZjNag=3D=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e6dbbc48-9085-46e8-da72-08d9b6c18bec
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2021 01:01:04.3613
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iJ29AmWi5rFK1CxO8JCYGMGngj6ipr80vLa+5W6mP0mBzS4I7oBzw2+vAJMNWgnfAAtKX1jvkpIqmOZxjSXYrgIQ6794AZuQSUxXvFojiio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB5701
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an interface so that non-mmio regmaps can be used

Signed-off-by: Colin Foster <colin.foster@in-advantage.com>
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


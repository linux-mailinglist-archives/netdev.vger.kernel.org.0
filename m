Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BE322E0B14
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727330AbgLVNqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:46:34 -0500
Received: from mail-eopbgr70042.outbound.protection.outlook.com ([40.107.7.42]:47547
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726756AbgLVNqe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:46:34 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KOE1rvB5IDiCMmmBSDYEe6efX32DdOe6NRbphzdjRIVg1EIVH7qGXMR1U6HU58Hkjgt9Fg1aZUJQRyM5XgnOfZMOODcUwB8XhJgtX6oa9erudwHVc7qQ4ozpzkJivWpWIrqPvlp2FYfwGEMR8W75hPO3y5YyuQ81eINn2RhodSHRsMFmFMHAexvCatMAn8H5P5UOYLcwYCmz6ScHxcsdrbD+6l1Id2nacWjb8MLq72DS3+w6pZeKgerE/Aw7+BdZjkaHbJfBrL28D+J3c2bzJAUh0obXTZy/jgn0oJJ6ZFO2fCSF3d81RFidYvlGdUxVjuOKz9hugbsGtb3t9mxdoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfUgydAv81drvmSF1ar3q9enLI3WAJ30lDNRHh04vw0=;
 b=V8wFx/I3KeUg5+en968F80ejzDLKOlENSQwT5xzntaFejm8r2DWBv0130tetB2PFHaKjQ2lH1tw4/F3uaPum87F9RvJh9+uiFCFwMdZUugPf3XVO6ZKXlu1Xo/lzTYddyYip2N/BzT1Q2N+rLhkAKMfNpmzCU/XH4vIGRwtGDIL+Ult/EmRZhG3Tsjm4WtYAgzaUAhWJOp2NmxQDZ6NqoxidAtmonxSJnBHJMcgnk17yUMSW/kmtzC2nA8tEwp+Jdb4UuosuORHHMIQYAwsLSf6hSydxAyNyyEngHiOuzaJYA+jxj8TBtw6mxILYIMd+ZiIGIvB/qnHpx8+nDNbdAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PfUgydAv81drvmSF1ar3q9enLI3WAJ30lDNRHh04vw0=;
 b=STuWZW8ekWzGUZBFBRdH44sHqzItsCz6Xlmv6PXbrFdCaotXkw1+zCvKq2P2Dzb7z5Pnz33UkTs5kc5M1Q7VKo5SNPhLRrGGCFWSiM/7sBRyAMPr4bq/5w+xfWaHRKWKDNF38H4Da3NnQHpEhkppJcGjYEP0xSfGU0q2kGzeCAg=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:45:00 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:45:00 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>, Po Liu <po.liu@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com
Subject: [RFC PATCH v2 net-next 07/15] net: mscc: ocelot: just flush the CPU extraction group on error
Date:   Tue, 22 Dec 2020 15:44:31 +0200
Message-Id: <20201222134439.2478449-8-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
References: <20201222134439.2478449-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0169.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::23) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:44:59 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 403123e8-0b87-4f23-3a7e-08d8a67fc6d9
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB740867B2C62D3D5FD4074F9EE0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GdUeSsmgo0XuAzYHaxtTrphnx1wtvb0bhzE9UAmWpUHOVSMAfrmhbkFoNZ0HD5Xx9iAcwLxy6/A+WGuyTlehg0RWuq6GRjFxvabCep7dtl+xO2ETApwkDqSk3QBJAcTDE5dMfCPgi5Z68O0H/M3Iuw6h26j8fPg64UxvILGIbI/2m/w0vF0kmDpID23TAs5BR0zs5MIAKKz1Jy8V+1BJsmsUpdbjZTW4ljnAEu1CCpsiU1eHWiDrSctC7Y+E9ZMliJppWs6UMl++KM+m8qKX9SLH92KfJUg41k+6+5Ih4o06kCswYs+dGx2wz/zpybfKQVNlM9RRJEzc56MbGrUJjI8IPeI9+NAanZzgi+EUVLYiLhVCp0mrLwVnZtUdQkIBjixm7l9jmE54xRERvSiTxatbI5wpnSfjh3KfkarXvqh44IAaLFZ0rv2uqnPIQm/IcedJQ5D2n+9dObGFiCN6bA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(4744005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?6Be3Iol5T2ITmFaUObDTbm5dEuiexOMT+bnWGPBVRb0X13FTk2vhIcbDH111?=
 =?us-ascii?Q?qyfH3xSkVqSIthx2GPvoP0ft6Udt8NEpfO13xjBh4rAczACrC+bgCGb9M7qZ?=
 =?us-ascii?Q?hDwUXtTQ4+NXl0XtVfsx0zoCqCV6QjHLJOs3tn3/V2f2WJzxJ890tkUimYHI?=
 =?us-ascii?Q?aAX53C/JzM+GbdT8wfJ8q18OlUfwTBc8ommSSt36/RdMNhtrS+CmPKhCuWEN?=
 =?us-ascii?Q?fcq4XniyI2w2KxK0OOyLqaOApK6bl5narrbxemUEO6zBbacXyFH8C2tPcU+I?=
 =?us-ascii?Q?2gbCSEGlrudsybRnWmDJ46za5p4GwN9TOKsO1uqI3DyG9gXhXY9Ig2zeP9P+?=
 =?us-ascii?Q?CZdK+jD6yMHeshyYFFn5aoUXNr51gbzXvx3AVYk7zH83lavTdXhLfOwBT+6+?=
 =?us-ascii?Q?3bjTKdtPqfLZPumQU5pbEbfoRLShNGF7pV9qOGtB5a/rQuPfERZ9LIhC1ZXR?=
 =?us-ascii?Q?Ezu0sDxv+CNQBYe/LVEAPoBACstpgre6WV0rMV4jMfo56hJ2rV9r+mulaTrL?=
 =?us-ascii?Q?RhaaH51PXNxLf5erulIPmSZ8DsRzbe0du5cMk7KxdIyc/h4r87KaQy5OuCTv?=
 =?us-ascii?Q?k6qskgDwqeDFx23C1zt855cy92qu2oSD9aVIYY0sO6CwOithkH9bRTHfJOzm?=
 =?us-ascii?Q?JiN+TtNseYTzoFGpokb4yl0qRO0FyjMSIJW+zXqlmtvwPyyy6qf8HxyxNH12?=
 =?us-ascii?Q?EugKbiJb3ZeUIoL9FES3fwJ735TVmoVo2RY4zQqDVltS8kobn2CzshJ6c0xu?=
 =?us-ascii?Q?cQgqgYAHwe44qnJ6oocNWBHW3t5H3mV9rkOHiIwdT7r6uW9QpjatvTpXFnpP?=
 =?us-ascii?Q?H84qeStvelXFJZGhdMTdwnOowHBKQFZ8zqQFYIrosCguRIojgC0kUseN+JdK?=
 =?us-ascii?Q?ml0IQcTedcx/3dxpO6ELgFes0biWH/E4xkYc13nxqbTVSofl2wFn+ZVBmlT3?=
 =?us-ascii?Q?QjUVc0EUbhXtndzpZ/IjApumuXVP1tqGPB9vYbXsVDOEXW9lux4RS3MKsyEP?=
 =?us-ascii?Q?UT19?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:44:59.8898
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 403123e8-0b87-4f23-3a7e-08d8a67fc6d9
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZHtAX2/bhi6ci24cID6VxKS37EOO5mXcuTv6obs47zC8gNpRjL0LKRlJgFaee8gFDwqP/bnPgVx0emh9xuIsag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This procedure should yield the same effect as manually reading out the
extraction data just to discard it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index ed632dd79245..52ebc69a52cc 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -702,9 +702,10 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		dev->stats.rx_packets++;
 	}
 
-	if (err < 0)
-		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
-			ocelot_read_rix(ocelot, QS_XTR_RD, grp);
+	if (err < 0) {
+		ocelot_write(ocelot, QS_XTR_FLUSH, BIT(grp));
+		ocelot_write(ocelot, QS_XTR_FLUSH, 0);
+	}
 
 	return IRQ_HANDLED;
 }
-- 
2.25.1


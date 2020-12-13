Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A71F82D8AF4
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 03:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727663AbgLMCme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Dec 2020 21:42:34 -0500
Received: from mail-eopbgr140078.outbound.protection.outlook.com ([40.107.14.78]:44269
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728098AbgLMCmP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Dec 2020 21:42:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KiwdjrvhJZxEKe4fwXwfQjDS3up9wM+Ulf9x7lPoSVxnh9IwMSpf4Of7Iyf/caoqDPK/NdoM/jW49wLgHTNPf1WXL7sEE1R3brU2ACehAzNrcvWyDxADGqEwaAxNhgOkUYnNXNlZfxgne+Rnim9O0S8qd0bttDytmBUnB0Ps1LHx3yfYhL/GO/DBIbm8zfLfxjFK5zQ/Sf2LhSkWF6hetjb9Ae22LbJZVfDI2gxneABuivnN9scKpRhkVw+RJOOC6SQWnTSl6mA4+JjTYK6kb4INdvUK+pLetfI4IEwCE7Ld3xZHd7sTinu71sih1B9oe9NxGluX1crUcM8+P4g6fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NNYZEuAbyh5UJmXLCpQb6qOyS82108lYP7VSN+s2xg=;
 b=D6o9UWzL0c/epA9KetdF9mD2uD1xnNH7zoaq+rPxU3kza5/V7d6vS891tVzWT4ieIozIM4N8/CSEg5CgZy2n1qVB/GaQEudfy9/dsmh/8Ld+QRb65026SQamVJRsZup439dkc7r4pfOvcON8Js8c5LbPEie1eyHCvBnwoyLFqCkMZL+lD1Bwga+QTgRx2qUP0EbFCTu8sa6538b8Rw/iPFC9Zs31aQ2t6FMwhAz08U5RvFX3J5AvQLfKzpifVZGIienIWyLDycUVF/6cH+tF21rcYY3OVOIAN1yCCsEB7VTmIFYgp3CE9qdr+jBKDt+Q/ERciEqUC8o8l8kp7T9n8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5NNYZEuAbyh5UJmXLCpQb6qOyS82108lYP7VSN+s2xg=;
 b=ruLdulRUo5QocesI+5GneG4/GYss7UF2Cfd9eYT41Mdq6XEbCPngKFYXU+90Lhl2/bI+4qY8ZDDsghdfvwulHce63dnnCqhpYh0HKChy3ijMwh22sIgddKgNN+bA8qbX8lVo9UXjLcbxsW9rRzWy/mzwIhWvdSShtN+uwAA0aqA=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3407.eurprd04.prod.outlook.com (2603:10a6:803:5::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Sun, 13 Dec
 2020 02:41:13 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.020; Sun, 13 Dec 2020
 02:41:13 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Marek Behun <marek.behun@nic.cz>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v2 net-next 3/6] net: dsa: move switchdev event implementation under the same switch/case statement
Date:   Sun, 13 Dec 2020 04:40:15 +0200
Message-Id: <20201213024018.772586-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201213024018.772586-1-vladimir.oltean@nxp.com>
References: <20201213024018.772586-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VI1PR08CA0141.eurprd08.prod.outlook.com
 (2603:10a6:800:d5::19) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0141.eurprd08.prod.outlook.com (2603:10a6:800:d5::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Sun, 13 Dec 2020 02:41:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1a3724f4-8628-4082-7e85-08d89f108e95
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3407:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3407779A04D3506D5B1E8792E0C80@VI1PR0402MB3407.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 56C5thzdDCV6lGzbAlYAR8OA9HLKk/VapObZH1XW1GInVBYVR8x75ZORIrrgUP0+wYG/WHFrHT9QFRpS8k8M7Jp7dFCJi4i7GTe/p6muLBdejpEZ8togcg0y05OUviJ4n1DF3nFlqfYt/ZPCqiPyCg1AUrEjHe7AYX3aMplcLS3cybujWJZTYioaTBsqvS3ms2CPoFhk+drrdpdy+MURrCn1GcSN6adDx3ukDd3ljblz1ydYDCac6prjdqXiruL0C2SeMhD7NY6Ip8bjuOcJ521BgHzXVE5y5m4wxKak5XNSKogrfrrs/zOZskOiOnzWiLTm7ZIBTq2mBs1gE1hXF5asEazbYlpJMVP8pLs/DfyS1kyxAVukBQaOvPTgWlwfN5FKkcT3qoN+Yr3a4MPPfQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(39850400004)(396003)(376002)(52116002)(6512007)(66556008)(8676002)(316002)(478600001)(16526019)(44832011)(5660300002)(6506007)(6486002)(1076003)(7416002)(110136005)(26005)(921005)(2616005)(86362001)(54906003)(66946007)(2906002)(36756003)(8936002)(186003)(66476007)(4326008)(83380400001)(956004)(69590400008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?s01QFkfPIc/Yc344Weej3lhxYLuytitvGWzAcq1CXBwOntBCwX2jr/3LZgfs?=
 =?us-ascii?Q?JhkWBBWv+Ehsc3vWsMbtnEHYCHA567B7BIUEJiDU3EFZ3ku8PMH8OjElkue2?=
 =?us-ascii?Q?JMU3xFspgEz413xQ9Qzon6a/Kwi1d7QQWl9pGC3GQhvL7I3frqPmvR61RiW3?=
 =?us-ascii?Q?9xhdr47dLt/bjKQxxxHmt07yHHxMW3gZlH83EytE0RaAgrpk67TpQlicRP5h?=
 =?us-ascii?Q?IZ+U/TKpOyPtGXwkedNDDSU9D1VPEIsrIqACB6ZqjQYDkJs5uQU4/g3G0Ksd?=
 =?us-ascii?Q?8XeT6oEVxOPRSD41MV7zgPQDyk+IW1hwjd1Vo1G9iEXbaPQQvmKmvAvIEXDT?=
 =?us-ascii?Q?hqlNhJYpSzJPusxn2qmvyh/Erqr2j1cll/Cvs5l7MgmtkvWFy7+UtFJ6/jZd?=
 =?us-ascii?Q?7rXCFnTSe/ewjYIMQoAerlJqZrbiecFZN+LtNjsE5IlHUPOJFzhXnO0ICClk?=
 =?us-ascii?Q?y/Vfl47tTpunyxAqb8NTUyHkcw5fnyxHy9FUhFGSVk5DXZhd5wCCXxLL9oL4?=
 =?us-ascii?Q?Zt+4vOsFz5SikUUCcPVh9xy1cWH86Gvc/gvJ191JkGHgrd/pCNBEAYAmr9n2?=
 =?us-ascii?Q?C2sByTRlA5OXukxDkvD4NR0tl4q/ADvSbH6EnpBJyEyI6cggzPPbcSy0cqoG?=
 =?us-ascii?Q?pqSXrK/UlMTIf3UOD86/W6F/Qte6zP0gbdeqnTfviPFZeYGugU3tsZXCsKJl?=
 =?us-ascii?Q?V4qDKZ4dbOMvRMxjKSKT0Z75DiaUr7b/9jxkamNxEUG9chce97hAAzbKpYBn?=
 =?us-ascii?Q?w/J7hyiSBN2mHY30ASV6yj3zxwcdicyd5VlRcstyXXvaP1nK1L8RgRpJYznp?=
 =?us-ascii?Q?CNbFkHsjjHmo2op90fK6HvvAUSEolHwgholnLhiAG95Nm13Uej9NNoLg88X8?=
 =?us-ascii?Q?IXwpC4SxkMGEXLVmE+/boVS2Y1OSWUGJloxBGPF0D5Kn9+QIfEOGvTfHtylJ?=
 =?us-ascii?Q?kYoGX0CLpV+sTlZ/fV5sCaC37pRAHm95v3OUzDLOADqNTOv/aqda7Kbvrprk?=
 =?us-ascii?Q?ibi3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Dec 2020 02:41:12.3985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 1a3724f4-8628-4082-7e85-08d89f108e95
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mpbtp2MtAPtdJjsSuc0vzoTBhwYKpuIqO1iUdjCRjO3TJlxq7LArFGuoIcqEmi6X9wXPSSjhFVF/IZchggv0qw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3407
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We'll need to start listening to SWITCHDEV_FDB_{ADD,DEL}_TO_DEVICE
events even for interfaces where dsa_slave_dev_check returns false, so
we need that check inside the switch-case statement for SWITCHDEV_FDB_*.

This movement also avoids a useless allocation / free of switchdev_work
on the untreated "default event" case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
None.

 net/dsa/slave.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/net/dsa/slave.c b/net/dsa/slave.c
index 5079308a0206..99907e76770b 100644
--- a/net/dsa/slave.c
+++ b/net/dsa/slave.c
@@ -2116,31 +2116,29 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 	struct dsa_port *dp;
 	int err;
 
-	if (event == SWITCHDEV_PORT_ATTR_SET) {
+	switch (event) {
+	case SWITCHDEV_PORT_ATTR_SET:
 		err = switchdev_handle_port_attr_set(dev, ptr,
 						     dsa_slave_dev_check,
 						     dsa_slave_port_attr_set);
 		return notifier_from_errno(err);
-	}
-
-	if (!dsa_slave_dev_check(dev))
-		return NOTIFY_DONE;
+	case SWITCHDEV_FDB_ADD_TO_DEVICE:
+	case SWITCHDEV_FDB_DEL_TO_DEVICE:
+		if (!dsa_slave_dev_check(dev))
+			return NOTIFY_DONE;
 
-	dp = dsa_slave_to_port(dev);
+		dp = dsa_slave_to_port(dev);
 
-	switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
-	if (!switchdev_work)
-		return NOTIFY_BAD;
+		switchdev_work = kzalloc(sizeof(*switchdev_work), GFP_ATOMIC);
+		if (!switchdev_work)
+			return NOTIFY_BAD;
 
-	INIT_WORK(&switchdev_work->work,
-		  dsa_slave_switchdev_event_work);
-	switchdev_work->ds = dp->ds;
-	switchdev_work->port = dp->index;
-	switchdev_work->event = event;
+		INIT_WORK(&switchdev_work->work,
+			  dsa_slave_switchdev_event_work);
+		switchdev_work->ds = dp->ds;
+		switchdev_work->port = dp->index;
+		switchdev_work->event = event;
 
-	switch (event) {
-	case SWITCHDEV_FDB_ADD_TO_DEVICE:
-	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		fdb_info = ptr;
 
 		if (!fdb_info->added_by_user) {
@@ -2153,13 +2151,12 @@ static int dsa_slave_switchdev_event(struct notifier_block *unused,
 		switchdev_work->vid = fdb_info->vid;
 
 		dev_hold(dev);
+		dsa_schedule_work(&switchdev_work->work);
 		break;
 	default:
-		kfree(switchdev_work);
 		return NOTIFY_DONE;
 	}
 
-	dsa_schedule_work(&switchdev_work->work);
 	return NOTIFY_OK;
 }
 
-- 
2.25.1


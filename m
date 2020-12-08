Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375D92D2A66
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 13:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgLHMKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 07:10:44 -0500
Received: from mail-eopbgr80053.outbound.protection.outlook.com ([40.107.8.53]:11267
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729377AbgLHMKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 07:10:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uo87JvIjiR31xCEG8s3/7pTR1ParhQTrHxj6ZiPoCsxtwB6+yfWiEmp7lARUCXHwPXHJci9NA434pBHPIZIU9bKUGkxNWE/+aiB65Pw/uRrPdVXYp820RLqKp1F99VjrrKGzoLDEx2QwrduqMZbJnrl+PRgz/OjlfggfnF33wFLkXnqOYHfgJasmAlC2lWpUG+7ktvpK0UcTSdPVxOEI35frhH4ML+KsCdMWW0T9xVDVU0sdVmV83p09bx9TClNImLnqfzjYRYnLeMTniNqcVR0cVHS/j+I1C5WccNod+9k4O4iXw85IVP+nP1GgnzCFcdjIDa+KjoTguyNeUkax2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ehBH6TsgDRDrIphbpd5YlZ5x0mQB7cLsE95AIYHzoA=;
 b=angRSYc8CjOwBh7M51cBdxx2EFhhE1I5nOURX57LIkoMI8jxzW6JWUDop01m5SqA7g7cy54MQDLBqR/6BfC/KPap1M2Vyb0pMxaqm0NK9N0vG1Kkw8OTrTBxNnoIjsyEhauI1NhC8LGMIu4D/nP8LSfrnU+5i7Ls+FNzn0RjlX9RmmY6vnpgHow1V+0XVZlBQL9UQDBLL7/Ce/uz3LIUtq7vtfpvOoA8DmbatN8OAp60p1IxSSEmUwsrL8WY0483Agm0lE7v1NZEqxFZcTxZ5PKR+YWmhr0XeQhUvZtXSPsoUVhZgmRqmuwjmv7xJh0S6MP4mA4PUyBPfR1WHrOXzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+ehBH6TsgDRDrIphbpd5YlZ5x0mQB7cLsE95AIYHzoA=;
 b=rGPi7XF6uhStKOzcbx2HZeXKfBZXFKIOOMurVDqZe7q6I2ywb41fOTcAmpVxz8xP5aC242S9qRko2PjEsR8VPMfj/4MqBaFOUDXqQxOVPQE0oCEqyjS/T4ccQRrsNELk0cUIcjlqblZlDjVTONxuOpzZl1LWzMixhCbFnvZvgIk=
Authentication-Results: waldekranz.com; dkim=none (message not signed)
 header.d=none;waldekranz.com; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB5693.eurprd04.prod.outlook.com (2603:10a6:803:e2::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.21; Tue, 8 Dec
 2020 12:08:38 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3632.021; Tue, 8 Dec 2020
 12:08:38 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [RFC PATCH net-next 13/16] net: mscc: ocelot: rename aggr_count to num_ports_in_lag
Date:   Tue,  8 Dec 2020 14:07:59 +0200
Message-Id: <20201208120802.1268708-14-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
References: <20201208120802.1268708-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM9P192CA0016.EURP192.PROD.OUTLOOK.COM
 (2603:10a6:20b:21d::21) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM9P192CA0016.EURP192.PROD.OUTLOOK.COM (2603:10a6:20b:21d::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3632.17 via Frontend Transport; Tue, 8 Dec 2020 12:08:37 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: bde782da-f78d-47fb-0038-08d89b71fedb
X-MS-TrafficTypeDiagnostic: VI1PR04MB5693:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB569363F39D2CECE97DD24473E0CD0@VI1PR04MB5693.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4125;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: guO/a2426VUa8oR8qyGGpkz441hjRmEPfo6SAFQVacRsSQHJVkt5w1DwvP/gIH9m2CEybHQCECxRHl47KXDd1LvXDCkKPzDXawWRTCcsQV7EUoh6HR4p5GoGkWWHaaeR0W8+FAIMmb45lgAe2yLBI4RX/+yQB0uqRAtEgLQuoLCfGSVVoZ07tyO6gty/BvS4g25jGRBfwX3QBhMgEePJT9qdS1sUf/6Ox5YDurpynmldSUGqk75CMBL+aAymXojfDZBn38fHfcf69XmPsOSz9tvsSLkrHfhUte/ABiJp1xJjFpIUs3OKGeZxHcPvdO7Znd0Co1DJ2KARaGoCOpAJB6rLMeBowmvO0kjLe6uMmJc094tJ2tDztA3Twza04h9E
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(498600001)(5660300002)(956004)(83380400001)(2616005)(69590400008)(4326008)(54906003)(6506007)(6486002)(44832011)(66556008)(2906002)(36756003)(186003)(6512007)(6666004)(6916009)(66946007)(66476007)(26005)(16526019)(86362001)(52116002)(1076003)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ThofDMo6yTj012Pxa901nz3KR4kXwRBfiMNyCbLtQ3d7DqZ1EtHVNgN8YrmU?=
 =?us-ascii?Q?6loyDEjF0B9HkPPjM/IWpv9rrMqZdF1NqqCbT2X3z9Ez+xEjZFYqVb6PjQRI?=
 =?us-ascii?Q?OISdL+GSqetAT/C71xWc8S4FzhCCkXxrmBQvIwVuUCA/8rIKb/CzEUhKV8xE?=
 =?us-ascii?Q?SEoqkM//GvrEaFOZ2K8gtRMJsberAADnWNdopc2r+ksPlKbsRwAdbD/RHKLN?=
 =?us-ascii?Q?/m/+ZXMPE44FaIARKV1OtFk1j5KO5mzpeVakpYw+JwkcUV8irxBjeMVd2sgF?=
 =?us-ascii?Q?Ny9ukm3tGqc6Y3C2DT0OTYQzF+mdbtItFbQc1VtDBPY+dpgpSGmOoy00bOll?=
 =?us-ascii?Q?zGQ7rHYCtbSM82pOs5DyV1B0oYqpes99dwCbAN8yxRDVQunF53952pa+QkVv?=
 =?us-ascii?Q?Wea7Yfqw+ItFBp0aYr0qP+GXIT/AitafOkElglnmag1Lh3Lev4ODoC/BIWAA?=
 =?us-ascii?Q?EDRGjqVCuFWNsWhUZpvuCzupvMQ+ilWSe7ma1dYu8wNhMonb7m+TfamKg78i?=
 =?us-ascii?Q?BNDOYL+yfWJYEc/jNPEJd2vLrdS2jkXBqAhr8AUt2adRyEP4MVgRXYxJWUPy?=
 =?us-ascii?Q?rnLIpOqQZBUWowOPPZtyfuXeuOOipwi7xY7c7EQvZ0ckeIyBlcoK6uPQd4OK?=
 =?us-ascii?Q?wCdXHCpkJNmkFP/3IaGkquh30xFxH74iTLKmC1LRQqMFZUTAu1rUPXNIlzbr?=
 =?us-ascii?Q?5SIF5YUgJRCzW/WQg+7HW6IyaIbIue1ceHmTZsjhO89KQHxkCKPRGo+g1MUC?=
 =?us-ascii?Q?IDUjBm9PJbHGdEesQoowUTFWKsJtFRZQGrByJnt3dFoTSS2GJmde5/WCsrGt?=
 =?us-ascii?Q?KmBHjaGdzpeFMDNwMMMgGDjgX7j4yRPBig9+SwIt+BjLe7MFJm1N+ArJobew?=
 =?us-ascii?Q?x033hgMPBBGGc2m5s/bR8+X4iM3VvA+B0c8KZGLFvxKVWmGoe97AHKdWolTW?=
 =?us-ascii?Q?LvTPZdQtBF+mVHgig3vbKQY0bVjQQK9k0hkgEjm79RlVJ2jxK8DKHDN60lBw?=
 =?us-ascii?Q?c32G?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bde782da-f78d-47fb-0038-08d89b71fedb
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Dec 2020 12:08:38.4558
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sTcAvC0d7LsMC8TgAq/TrdzN0TOL1LSXtm5Cq5R1T23krtMLloShuUmQAYL/92fOV8JDRfWkfgGNr+KrthqWQg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5693
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It makes it a bit easier to read and understand the code that deals with
balancing the 16 aggregation codes among the ports in a certain LAG.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index d4dbba66aa65..d87e80a15ca5 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1263,8 +1263,8 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 	/* Now, set PGIDs for each LAG */
 	for (lag = 0; lag < ocelot->num_phys_ports; lag++) {
+		int num_ports_in_lag = 0;
 		unsigned long bond_mask;
-		int aggr_count = 0;
 		u8 aggr_idx[16];
 
 		if (!bonds[lag])
@@ -1276,8 +1276,7 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 			// Destination mask
 			ocelot_write_rix(ocelot, bond_mask,
 					 ANA_PGID_PGID, port);
-			aggr_idx[aggr_count] = port;
-			aggr_count++;
+			aggr_idx[num_ports_in_lag++] = port;
 		}
 
 		for_each_aggr_pgid(ocelot, i) {
@@ -1285,7 +1284,7 @@ static int ocelot_set_aggr_pgids(struct ocelot *ocelot)
 
 			ac = ocelot_read_rix(ocelot, ANA_PGID_PGID, i);
 			ac &= ~bond_mask;
-			ac |= BIT(aggr_idx[i % aggr_count]);
+			ac |= BIT(aggr_idx[i % num_ports_in_lag]);
 			ocelot_write_rix(ocelot, ac, ANA_PGID_PGID, i);
 		}
 
-- 
2.25.1


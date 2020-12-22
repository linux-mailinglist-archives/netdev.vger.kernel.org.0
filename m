Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8353C2E0B19
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbgLVNqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:46:43 -0500
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:35431
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727377AbgLVNqm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:46:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ut2Z5rhHMj9VKMFbm75IQr7ORO90c/NHrEOBIzQU/cH0SQCdqeaABDe7px2fAbEWNCY43YBVgcmScRQOzUlbzB6bWvkKisGEmnTVUu9MfLqbi2MlpUeiATFUlJR6PBAbM/W7ZZ+8tlGLa1RJJcCLXeHabccV7XcBKzsxkWTLgAllZ/dHGi0y0WjXh+497mQaRWINpgxkh+02y80/LIZBZhN13Iseqls/0/8F71vdcXt/pCVqqwDxEAGz+0j5CBzkrYVyVVVxIrt8Xa9i+Yg62B+18nrLNiMXLqmjyfm68IabeZljAIBABCm/o3eerAi+dPX9eqXSxdedb8aJ1o/X6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9QDmrt2i1e7NOxu9jGYSWG/E4mUywvq5IcTM12+mtE=;
 b=WSicxYRiMY5rmSV9EhpO39Ky6axugBCe20T4yMsjm+R3am9Mp28iw24n8bbRGN4BMNe3TF3ABaij671Dn1amqCHjrSe9tDvO2Fi5iq1syH77OoDDjJxWkcdt9HiULwSc/o8O9qIGrX7PATu4gOOqgR75IOLlHmcINmJvzmiTP2KD2QEAusjpUfW6qE8vsk6TIcLSw7a8IItmpKXqMRPuAbNwA17VsxK3NzehmjTQTeUENxWTKrEobdovC//lwMdYWYFUzrOWUZyhs1nV7zfuaMmfGNwKVcscnhVsq1XoH5buesUYeGr/Cl27WQwihPFSK7H57M8ADHl9UK4SlFkKvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9QDmrt2i1e7NOxu9jGYSWG/E4mUywvq5IcTM12+mtE=;
 b=nEEtEmVtS/U0mZ2aUDls2KtIP+/Wg/+CToq+cocz5zIn5YjU/FQgB+Oy3q84BXHpdLBRnW/FjuCdVCwXluVqoeyKp9Z3/su8DDn4lx1AtdTktZAwBnT1u/Z5ZyYvTgq6bsCYJGLTd3ZeDIS3EWRzhRSbtoFsQlE4Gut0JUCi7z4=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:45:01 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:45:01 +0000
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
Subject: [RFC PATCH v2 net-next 09/15] net: mscc: ocelot: use DIV_ROUND_UP helper in ocelot_port_inject_frame
Date:   Tue, 22 Dec 2020 15:44:33 +0200
Message-Id: <20201222134439.2478449-10-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:45:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 1e74b275-f04e-4dc7-a73f-08d8a67fc7d1
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB74088EEB98726A8B6D081577E0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:747;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o0ZLr5/rnmsbtN9/SI8aGORtdZrbfbSkTzXr/pFqWMmdXKbhsOn5b5grGg7ifwKPwEqn1bcDRq87PABNTvnadutbI6grlfpaaGVHF7NWVLgqDuUsazcwUVrJxq/gGjjr7bYAoL042QIF6fL2cNPLU//x8WwIXN0MrRMK+2MUA3tPY1V/cg1E8St5r7MEFpbJB2/2aQdXsIZeeUUfMMqlNFCZBTQb2FXVjVpw6i9gZyr9xqOBfBuAtFI2l1ckrGcSibIpfnBtahVmHpBBzH7Vtf7ZTORNWJgY9OW/s+NbTfp1tKCJn/GYi3+tTS6LjlU6TMfyF2UvkbQucLpYjapPz0wpewti8DFFWAJDY3XB5ui0TN8Rl29uxlW+zjklcEM+lsiVQwDhC9F/J/am7fgNmh4A+pxrvg7dMxQ8d5Ib1sVQuif3C3B0rPUm/b0R07cIljQxnF1N5ymt00mDDAtNsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(4744005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?JhOrydke4NDnIz2N2tTyCyaml5pV+rPDLKu0bohwnHOkpNQJ+bWKJaBPAO5a?=
 =?us-ascii?Q?h5+rOzzRMUbZ1mtiN1J9UwQaWMQiYaMh26I6UGJhwcSaPWUoXFKGcB5A2j8W?=
 =?us-ascii?Q?aWsw/oZVKKmQT3RZZ8EmQSsanmSWZmdd+rnmW+H82FdNhEPos6mKXFzv1hQN?=
 =?us-ascii?Q?6vQtQG/bYLgoEG9NYXcMYBoypDHyE9oL315xtbvvHBRE9uLYyemhCZWC7/XR?=
 =?us-ascii?Q?P5TMl7ZtJ5XYvUsnJ9xIzTKdkvgHvt8Hmmep6xUZc5gHaOfq/9pwS/toAXwo?=
 =?us-ascii?Q?FaIJ/HKu0ACk/AKob6yjIhHCO3iUZoYXS7ZKya9H4PHg0RlYZFZ2Y4m+bDIM?=
 =?us-ascii?Q?Ke1TAC5254IO7ro9xkVYL2tivNt5NSQKigKC/2m9sDPowXD5BbspL901jJJt?=
 =?us-ascii?Q?wT8ZDdeZqO3xNhtFlDaLVQMD83/LKNHQeup2/DgIUBgq/OzQUhkkDI6eilbl?=
 =?us-ascii?Q?nVb28pZTUoP5mhLB2bdncWHyR/x6ObuP9rKGABMMGgV+mrcGJ48f8jRCG3T1?=
 =?us-ascii?Q?+aJ2J2V2Tt3mtyXaS3OmRz1RyhoAX0HQMdzpFaFaclEGtzK8LztmtwjBFQqG?=
 =?us-ascii?Q?P2UgBnJbPAoED5NwsdtxhHu1J4Wkd8VbCyIY2Ro66hbeN5FmaI9Ze33sGOWk?=
 =?us-ascii?Q?E4PO+GQNsPMTRa2YstXNrBoKqBGAnmqpdA5q9/LvhXuhviOmCLDEwj2F+AD+?=
 =?us-ascii?Q?fTzCSB2Ju02GgHktBcNB9Te/x0Ia6wCAKoK+3BZcDf4ZEdPv+gPux2pOgCbp?=
 =?us-ascii?Q?YRg3ULzHPsr+7bgxB9cVAdilfh7ZQFhaEJ2cKPFbX2QeGdpkCArt4ycqbOyw?=
 =?us-ascii?Q?iNyWUUvegYttISAPPAjBODSTqK5milyAO2Xr//0PTHIVF/5vG0UxlUW3F8CO?=
 =?us-ascii?Q?SjSr4cXWWVIJRHXP15/cxFbtezYxS5KzyHT0xwFvN1FfeyBhQfDSWZNr4Oq6?=
 =?us-ascii?Q?BF6wpN96izGe3+HoyQkZV3wq1hqiqtvPKHOjsB8ODT8QEE4Jx+L+PxRHhA+6?=
 =?us-ascii?Q?5RR/?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:45:01.5309
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 1e74b275-f04e-4dc7-a73f-08d8a67fc7d1
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m4HWZflInsQPz9lsfWSyRFwIFgvpYs913b79Rev4EaPSvklXEM7kRBIo2yehyx7e99v016541qlOdEZKZsefag==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This looks a bit nicer than the open-coded "(x + 3) % 4" idiom.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_net.c b/drivers/net/ethernet/mscc/ocelot_net.c
index 3a3bbd5e7883..7cc0fcd1df8d 100644
--- a/drivers/net/ethernet/mscc/ocelot_net.c
+++ b/drivers/net/ethernet/mscc/ocelot_net.c
@@ -386,7 +386,7 @@ static int ocelot_port_xmit(struct sk_buff *skb, struct net_device *dev)
 		ocelot_write_rix(ocelot, (__force u32)cpu_to_be32(ifh[i]),
 				 QS_INJ_WR, grp);
 
-	count = (skb->len + 3) / 4;
+	count = DIV_ROUND_UP(skb->len, 4);
 	last = skb->len % 4;
 	for (i = 0; i < count; i++)
 		ocelot_write_rix(ocelot, ((u32 *)skb->data)[i], QS_INJ_WR, grp);
-- 
2.25.1


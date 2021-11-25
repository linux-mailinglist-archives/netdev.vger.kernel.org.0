Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DD845E34A
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 00:23:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232948AbhKYX06 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 18:26:58 -0500
Received: from mail-eopbgr70080.outbound.protection.outlook.com ([40.107.7.80]:55694
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1344487AbhKYXY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 18:24:57 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PemzPkJlAxqITOtf/ui81PYO/RKmrdREYS7kL3fbn+A7LqFa6+eii/D8pUIhQNNAduaEnb5qGuG/8iqN7MgqRdjT3vRC0gmTwqf1BVk2MbnlDV9fZrFo4BrW6B1ZGlFxfkpDYlZEaCT+oDtFPXki422jOoychzS+ASlvw0F/PUBmuLs50KMtqPxc2PWisiOZKaG+t1DecCayYMeX+cK2I1CC8f0JW3iFvDnNhNPuluqvSL9RAEbeGEnLBTWduJC9OM/04Siw9X4oL24wzWRc/uoDxFH+s/C99aTc+SpPI8SOvSBBf2PfULIWYHuK4Hio/5TR1xjJX7Akd0/xxiiMag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pF++x/GJsSDqkQdGgVXhzyndFSsjlYd5cVku1WnxaWo=;
 b=fXygSCy+4+/NQmQOHY0jBU+7/+Qsdr3dxAe8AUmeoBtV/xXyKAVdqynOOroDiztmc32Dj64DXhL7UoxoyTE6rL7Z2VQTzre3zQ3jXLKzCVnavi5FUzSZZ4bMQe6Oq+FIDoVkAqfG8YrJ85sqxXqofmyzJYldq2fcIDVIn0X+MdX8qZCUKtrYqqB7kXBqhvYHKKLTdW4uD1VSw+ljTXbTwKkqylNjk2P/9C5NHvyoFs3BJ8tUP/MlvpKQWw2lMKao8O5IEjTuPAR0j2GZCEZ/bPFAnUP49R7sXaJULe6BRxsWi9BkyX8dPzhRCqfuoJPhjgkKbxTjvq0gfkSoEBbjrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pF++x/GJsSDqkQdGgVXhzyndFSsjlYd5cVku1WnxaWo=;
 b=kPV62J8o18LecHL5N3i8ytck9PmI2wh4swD8UsGgTrSUXGQBTYQMu/8VVuSbJQx+nle2I3dSaDN5YuY3C02AlARSY8xniTw+0Iakv/sBjF3zONTQTkJca3RaHtK9g19fiY/4OtT2tZGbHt2Dv2BiLU+rxQVc+0GSFg65uTARE6o=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Thu, 25 Nov
 2021 23:21:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 23:21:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Po Liu <po.liu@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Antoine Tenart <atenart@kernel.org>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Yangbo Lu <yangbo.lu@nxp.com>, Rui Sousa <rui.sousa@nxp.com>,
        Richard Cochran <richardcochran@gmail.com>,
        "Allan W . Nielsen" <allan.nielsen@microchip.com>
Subject: [PATCH net-next 0/4] Fix broken PTP over IP on Ocelot switches
Date:   Fri, 26 Nov 2021 01:21:14 +0200
Message-Id: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR05CA0011.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.163.189) by AS8PR05CA0011.eurprd05.prod.outlook.com (2603:10a6:20b:311::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 23:21:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70a7c8d5-ef3a-4233-5e38-08d9b06a5718
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286294B690F63F7DCD1C1835E0629@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pCXz1TYdcbK3ILz2oA89vCTNURaEcnukF8X12ZJhFU5W2RDLSrqK8GA80OOii96kBRThWpwR/z+EHkBWubHATdIPGNGaT/2DZ06gf25Ay0qzoBPXh2Z9n5Yk+poM7v+B0YwTegHZoIE1X0eamZi03S8kLgKaSfAaKrd1bHvJfv4qKWhvayPuW56cCliFjUStM+yf8d16tlIEy0ksyLarNX8w97R0QIj2KdtbFrioLL3d3iQfdnTo7O31FwjFHt8DG3nF1XEC1k7II6tUqDjC4D9t7pDF2UBZkk2WxKiRwrMJmn095NqUi1/cnqzRWP7VkeENqaSOQv7N+Di3FQgulmini1uARqZwPn8PRiM0eobNzkCFbqSZd1d+4S2qNwmzXGg3C5Aydx3oxTw2W2o9PediegvXSt+a3wfiPAdCQHEuPoYAPD59nEFdcXmVv4KNmB0ZI7Cajtmce0uisfxRKKgJThY6vfiB6HWK+6RfqQqoBG6hfwXK/2E88kDQYEY9OJh5CbWtumBrj5kssWJHHVNzoaZnp9xVK9eOJhBQhBLSPmRQXGmGqSQ47NO/Tcyypmz/lIqF32DzwZYIFvumdd58X9JMFRrp/j+iIf72T9jSjqFYE0C4XTp8ifoLTDB34V9sXtbsnuRi/V4+HrzxEzkCCZD2PI0FE0sptmsl8IHUuX6KkWhB7V+irI6n2iiPH1cAHvyAK7ICuTr4XAT/7g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(1076003)(8676002)(5660300002)(52116002)(2616005)(8936002)(6506007)(44832011)(83380400001)(6636002)(6666004)(186003)(956004)(6512007)(6486002)(508600001)(66476007)(66946007)(66556008)(6862004)(37006003)(38350700002)(316002)(86362001)(38100700002)(36756003)(54906003)(2906002)(7416002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?+XN6XYcVsMcfuubap6W/QfrUQSCt5llJS6ec6wKW59kOnxirNK+/xcIGCZR8?=
 =?us-ascii?Q?V7fGvmXAfrhq0Y1hi3sEybMOaqgpWcUbYW3wELwOpMG9TbGVlpJJ89nDvsP9?=
 =?us-ascii?Q?QUUDPhV2pT2wofUA2lCgbQWs3NAx/0SW1at6HOPzPnd6Y199tYwW2GuOnu99?=
 =?us-ascii?Q?EqdoxfwQdaqcSXebfK3njxPCq4J3oJrsGbC63qvzenahV8DXaKvoDMG2bdSx?=
 =?us-ascii?Q?6aAO5c4uS3Od0Tn8f4zu35Z1bEpFBx1MucZOr/DsvI4GcR3xRPei0e4RO29f?=
 =?us-ascii?Q?ZUNb58SOfA96gbPVTIFJGlP44OlysgZkMDNeo6ttSgEvDsfk74V6bqLZtvM+?=
 =?us-ascii?Q?SQCMIzbUO4QD9lLsCF2RLgMKfA0zB30iL5WhYDzQPqqW4gl8bQAU8qKckq9h?=
 =?us-ascii?Q?iahnEqF5c21pXFeQBnmOHlbAEmnaA9FzsWyxWkxnCSFnx20D9wZ4PGmo3bY1?=
 =?us-ascii?Q?n9oLRiGy1ZXmUf/QFrthZAml2xuF8ugqFHtt0+thTl1cretvnYQRdBis/3Ri?=
 =?us-ascii?Q?eypJD2xlkff+aIU/+d09V0bBpDAfZs+9R5bdkXgI1AJC+PEaRY5G3gjMDLFJ?=
 =?us-ascii?Q?HFywaPZBRHME2xSksGE5c6gyb2FcxN5shFh+LrCHqYtY3T0epEghCSgPK+Me?=
 =?us-ascii?Q?AZPUbBSqg1acRJWPEuLhocF3K6Ml3rdJlDPwc+PYMmvWNCXANl2ykGn1/yBN?=
 =?us-ascii?Q?g0ejMsr2OGefsNBKi7GfOyopvKwGohX7IrAp4KheJgqjGCk6fcw2mjZkyXel?=
 =?us-ascii?Q?wxikjTmwwkYR5+8U3FTmH5wTn73XyQbB5gdYZrQ2/INQbMQqqBwaEUqNbxup?=
 =?us-ascii?Q?r/76lOM6SKvCVwHlr7YPXI2JxsTNk77QBKhYaUHBq4hB355J91pCDD/tY3U3?=
 =?us-ascii?Q?HT1Gy9ewri5zuQlqezND0sFGMbP83JLhyf5nsbylMKS6fz1PGg9/GxSBU7LE?=
 =?us-ascii?Q?lQ5uCkNVMVeL0hFiNGxdnpfAFOGDj8sZy/zACrvsMPESbQf414GMCYCMqU4A?=
 =?us-ascii?Q?duM/TZTGZa804842GnKRT7vc7pE90EnoZX54OenKGcYLrqWFTDsplFeqhLwt?=
 =?us-ascii?Q?KGgGBqMVjXE6TghCVhOoG5mGdPFcPwmsV+ufMrH+aJOHyEI2uaS3Rqfvkuwq?=
 =?us-ascii?Q?VmilD76EYOS8+4fRPwIBDSTjs4icSt2ShTGoCWP8IsfANeN4rrfUPIzZeV1q?=
 =?us-ascii?Q?wG9a5PD+KrIdODaqLatqnJy7BECwoLTbqqIhSTsR0r5NL3qRHbeGo52mh+2K?=
 =?us-ascii?Q?noZ8yQnObs88dRL6xi8zUAKG4uKGTMOwTOtz91iwsWv01r0/fxvqnSaMHSjY?=
 =?us-ascii?Q?GJ7/tvKraz/6aPLZm34R2K95Z54iEIVjzJhHtNhR7OviPI8Ww22bm0JfG1lI?=
 =?us-ascii?Q?n1PEexE+xz2rljdZym+6WbzNsBjpoOZklRNa0AlvLkuhFjWcoyzZbgyrAUmy?=
 =?us-ascii?Q?Kw8/DgawETxjyG2LndOxdavyf7YXjSwoqo60Oh25oXSvOLwMznLu6M2wlDB/?=
 =?us-ascii?Q?w46ioNDH/tVokAIKyqlc7/Ee27v5/utUmvlfcoGiYZ2FtAcWGSJyeetsCOQS?=
 =?us-ascii?Q?C8SImhU7z1vtbvpQ3dlJOohq+Qnki48X5UCpGM81/VByxM35IRJUetzBaqwE?=
 =?us-ascii?Q?TC2zeKpR2bu3mrYH/n0AS4Y=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70a7c8d5-ef3a-4233-5e38-08d9b06a5718
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 23:21:42.6191
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: O9cN3L+G2+AKf56L5RRBPsfcQs6dEW/o9sytEu2GHktkwE0dD93OVmB7Mw1F/PFYKvAmNFT4szFWYm0AYbjFrA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Po Liu reported recently that timestamping PTP over IPv4 is broken using
the felix driver on NXP LS1028A. This has been known for a while, of
course, since it has always been broken. The reason is because IP PTP
packets are currently treated as unknown IP multicast, which is not
flooded to the CPU port in the ocelot driver design, so packets don't
reach the ptp4l program.

The series solves the problem by installing packet traps per port when
the timestamping ioctl is called, depending on the RX filter selected
(L2, L4 or both).

Vladimir Oltean (4):
  net: mscc: ocelot: don't downgrade timestamping RX filters in
    SIOCSHWTSTAMP
  net: mscc: ocelot: create a function that replaces an existing VCAP
    filter
  net: ptp: add a definition for the UDP port for IEEE 1588 general
    messages
  net: mscc: ocelot: set up traps for PTP packets

 drivers/net/ethernet/mscc/ocelot.c      | 247 +++++++++++++++++++++++-
 drivers/net/ethernet/mscc/ocelot_vcap.c |  16 ++
 include/linux/ptp_classify.h            |   1 +
 include/soc/mscc/ocelot_vcap.h          |   2 +
 4 files changed, 259 insertions(+), 7 deletions(-)

-- 
2.25.1


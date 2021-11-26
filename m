Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10FE845F306
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbhKZRfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:35:30 -0500
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:13920
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236310AbhKZRd3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:33:29 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GpwhJ4WFaLBUX4UsyPd1RfxUZr6vpBuJw7pKoYOrAI2FM+DN4YQy9OwBTAfY/Rbw2chiX1wxiOxazcXYeH1MiBg4E3AiSwrgBBC9SAlHvq5XAhNPpNRwG7NqQlBbG2eQTlapeQxFEGG3v0GyE/ZqVhiyKkNklVb8uUrHutHWg5Pa5f3eWdM3vCYmMIjZBFUcI+fFUquFNSUV0JeZI2IjDEN8MmyACioL87fIJF+wWUhr/gJDiczvOK8oUJINYDLMYNeAJ78Cmkb+olPln++ltbnXn9i2nqDR6ns19LF2z9Haub1uMDUBseZ1r0XYOT0Zex/kqny8zK2KgtuF8js0dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KI13CnaeyIpKZbJY5UHfJe3UxJ/NONf6ICnlP67auNg=;
 b=hozVWVAfIMMeZUzO++fc3qaKr0RRZhhostIywv1w7mwWWsY3pcUbm6ypBiooGwjDlYmMfoPjJkwrgU8z3ybF1yxy2QiD2jboZSSskyDuhXY2Xnve/CzgCHTSdIopE/0PSySyD55tPGGRwkbKlKNklYepmybQZdz8+7KyK/CyEvGMX90TPC+GL+2aUVxjqtfknzgvJ4wu9L6u4wGX11t561WAp7dBdI1WHhoo7kxdKwPjlTVjDl1xIt9UPXiO/oYdYbueLD6w7R+KwOHWjSIV6r/yEsbwLenTUjB/S0l9VvxXqoW+DXiE8CrOODwVIKsUkWw3H9W9aVagjhVEM28ksg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KI13CnaeyIpKZbJY5UHfJe3UxJ/NONf6ICnlP67auNg=;
 b=ksnHsy0p2zX1uLNCJLEqdTUJ/BPoQ0x1vVPsyrj5VAOCpY2DlcfgukMd5m5NbPdEpiF+24Ha3XiZSAfdOUSo4HkGPJ56TSFhYLyWMtsxLcJ/dU341dpBwlxTbVAyD87LOdbrf2UxEtitamURJKwVbtY449Z43NikO9zh5UD61N0=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Fri, 26 Nov
 2021 17:29:06 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 17:29:06 +0000
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
Subject: [PATCH v2 net 3/5] net: ptp: add a definition for the UDP port for IEEE 1588 general messages
Date:   Fri, 26 Nov 2021 19:28:43 +0200
Message-Id: <20211126172845.3149260-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
References: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM0PR02CA0125.eurprd02.prod.outlook.com (2603:10a6:20b:28c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Fri, 26 Nov 2021 17:29:04 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 29989ed8-a9a2-4d90-61ab-08d9b1023f88
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB66397D465680B7D4E192D581E0639@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CZZd24qddxAs/6mGI3zzQmXAXmNDLwa8ulSCnGwflBNf+Haz99UQbbZxAIjf85+wCiyUy/X07KJLpueDrInpb+7twOEBVAViJYd6y99TUPni6q0VmpQQXalMyGSj5r65u8bRBDZXjpa0wbGW5laM1qnWDnfu8zsuqwruf+lscUccixkjwrzvFQP28JDkEsG8CQaOEKRUPNkZoaXAV6fGxLaR4UXcqLYngg8LhSSvxi4JYaBIs6+s+HSvNHpC/phJ0sSyCa1aUoGfJavQ8sl26dvm6b8y8UaHYVEZoMjJA2iVKcrcjk/M0t9ZJMSW1qa6WhZgP/8C2nWf1lKtcD1qmBcnM/6OBVWyIm79anatkOgFMQpEYG7ygMkh54fNbaSklSlJfRSy7VP1Rx6kFgJfCYy+WKMZGAz0vvuv/qw9RfnrH6+cpG7ByL1fS70O0n6vRr8euKGI4u7zZeCpw/lgTbrRO8UQmx3rrhJcqkx4rB13WMk6jHyrAkh9K0vys27eWwCJFKovpdKsy0eRik8Ig8qLa0JRL335Pydc4NgiemVQdPW4AD+8hbtQQvQqvOseJ/pX6bs9XvC3uWj4C3etL5bU2qcDnxJ4ZkgdDzBUO18KACrRCecULzCFJ+nrB7xOcRvYkCeDcjw1AeI/+SYfUi25oISU3aVCVpHx0i/KJWlY+5drZKq7w5UD5Ei2JzVI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6512007)(15650500001)(7416002)(86362001)(508600001)(956004)(26005)(8936002)(44832011)(6506007)(6486002)(8676002)(52116002)(66476007)(66556008)(83380400001)(2616005)(5660300002)(54906003)(36756003)(38100700002)(37006003)(186003)(6862004)(38350700002)(6666004)(316002)(2906002)(4326008)(6636002)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?m2IENvsc2LjAYVTsxTXAStF86cq1MsRKAeG8iCNay9xz9WFUcAGoZZQGsGkm?=
 =?us-ascii?Q?HeXOvxnull/OSXxb0gyok4EZW/t3WnjpbCyN0xo8Ae5QVenzqYwjFZ+ZQYVX?=
 =?us-ascii?Q?Fb2btkNVA+4CrZ9Rx5Tvgr2n/T/BKM5nyZqGJ1WB7bRrJhar+LTTIVqDCyeb?=
 =?us-ascii?Q?+/iDhzlZv+MVAUfT2h0x2ztyiBe6rrTkOMPJ0QUjElIt8uO21zGLa+SQNkC8?=
 =?us-ascii?Q?JjKUscQBRsgpq5COf5iniSeXvlRvCvFzcEnI3rcRyXciQy/q8TAQyDeh3yJV?=
 =?us-ascii?Q?mL1+A8ty+jyltudIWLm0fHRN576gVAX19mDSX9ycrodMhHux07c6379e7clD?=
 =?us-ascii?Q?VDUWRJCVgqwOtygtyvqmPm1lA26B7DnJA1LO+tG/5gSqQ9kJLM7o4rRZLNip?=
 =?us-ascii?Q?Ac0qp0CWzwc76uYcbLwxGqZORQuAz2pGTBZWx5AixwgmroNIAHQC628n6JIW?=
 =?us-ascii?Q?tJnuj29vBt8Z5C/s1QNK+YyzwwHtXZHV1fvNO4kKnkDHsqVxnfGczNrhZHQ9?=
 =?us-ascii?Q?jNWwqIfOxXVnDhyz/iaPk0mqeGkfxHfLTxMYD9tlAq58TLWhaE14APXjOOd0?=
 =?us-ascii?Q?vSMqyoh6bCimQJ9o2L1r6gnJbh7cNU0KUHRkCAUtQFqWHjTSAZarODJDZC5/?=
 =?us-ascii?Q?kakZCMCq8C71TmCzH9JfgcmzRKqK6ocWceyVPsoTG7qtSoDc7GnyIS+wqPO0?=
 =?us-ascii?Q?dGPoCPZrNnOYJO4huA0N0dlNbydboZJ+GNeG4kX7Kru+z8rv2ysdvaRHGaWE?=
 =?us-ascii?Q?oINZr4sTqiOsEt1m2sc+8QXCzLq6MQkYhposOgLdLFdqI8AbzRswK60HP+Of?=
 =?us-ascii?Q?iuhDomE79qqg3PsC7X/dueAsxVlRpLhnVOyaQzpeSsZRXL47G845X4or0VPt?=
 =?us-ascii?Q?3zD1okZONd3ZRCinNWvEnwSvGYaBhb7+GfkHTxdChmg65lQcUW6akc2tkSsl?=
 =?us-ascii?Q?0i3vtBC5pz9zcrqaSXgXf/GHxDZFWvhM0fL2PQJBO+B1cmT4fXlzS/hP9Pv7?=
 =?us-ascii?Q?sTaPfQrLZUVrU96xDR3pxOxQ8iOHRcmtr+RFjchO6mc8YE93SxK95OIEUuuq?=
 =?us-ascii?Q?wq2C55OeMuvnETUCz1gfF6Hh+8c++xhSiZsAOLIsOqiX1rHD62JkT2qpXh7D?=
 =?us-ascii?Q?hv3PA2GgoExoaYuvAEhH8lXJn6kRcXtWhtXGU5HuBoedeXPN3jQoK7R1qYPW?=
 =?us-ascii?Q?nwxhj45Bh7gWiyKIzpbvla96O3ipI+MYwJMXWHXyjKCWKyMilMoeWzSW35BU?=
 =?us-ascii?Q?eA0d6Ttw2jDRCXwx+kQbB6G0Hztn0i86vLtro1U0z7zgUZD6IryVf3VslSvE?=
 =?us-ascii?Q?dlOKSR6E/8SNAKkvEr+1+1kWxI6INNJORbtmgzY3O5RGwbdxFWcfWWmjf56L?=
 =?us-ascii?Q?0oV7FrpKFUbH/sRz6s7MX0gMl5EZjkcJRllKULt8hs/kHMYKwoRwy1JctJuC?=
 =?us-ascii?Q?fXcKnSdKYdkpoSk40FcPR2BtRXamFpz+BvXe5E60m/DqRHzwc2akA4JO7RCU?=
 =?us-ascii?Q?6KfAGOURC9bqkgsvE2c0sxdBj05VD/3KK3pkG5HfZqE0v6gYlvNjtviEjNcR?=
 =?us-ascii?Q?V2y4/SBHNlbFD5Gs9c1/8Ds+1WcWfW/89tkB+KITkZE5+qhuRiyw15Eg7OCb?=
 =?us-ascii?Q?lPVHVjawBzcsJi5m5pO7CmY=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 29989ed8-a9a2-4d90-61ab-08d9b1023f88
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 17:29:06.5638
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4rHI/OZjCwjqdFIrN7UYsTC55lD7Xmvcfkg0hp+OjssiYB0FmS0rCwvTnOAZD85zRxAFY37/EjhOvFPaspFTgQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As opposed to event messages (Sync, PdelayReq etc) which require
timestamping, general messages (Announce, FollowUp etc) do not.
In PTP they are part of different streams of data.

IEEE 1588-2008 Annex D.2 "UDP port numbers" states that the UDP
destination port assigned by IANA is 319 for event messages, and 320 for
general messages. Yet the kernel seems to be missing the definition for
general messages. This patch adds it.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 include/linux/ptp_classify.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index ae04968a3a47..9afd34a2d36c 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -37,6 +37,7 @@
 #define PTP_MSGTYPE_PDELAY_RESP 0x3
 
 #define PTP_EV_PORT 319
+#define PTP_GEN_PORT 320
 #define PTP_GEN_BIT 0x08 /* indicates general message, if set in message type */
 
 #define OFF_PTP_SOURCE_UUID	22 /* PTPv1 only */
-- 
2.25.1


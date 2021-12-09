Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBECA46F789
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 00:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbhLIXjH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 18:39:07 -0500
Received: from mail-am6eur05on2077.outbound.protection.outlook.com ([40.107.22.77]:21854
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234495AbhLIXjG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 18:39:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lN8doZ2oEfrMxstD0NjvtJxSM95jsc67IIwJFbwjhoZwCOMLFHvxKWh6aUukTpt6zpU5m8iq3YOJOSREdcn7uwbR8DWFlOuQEs6yHUyOI/XplC6RSM9rJ6G+H2Bh0oL1yRswUY6RfXbuw8nWumXpQU2go/WADcPatlUdPTWuLtK93Gw/bHz56H0QlFJWgq6Rfxg3sQbM2Uqz+rZ+z+PtL7It+R6op4Q7DBSx2CKyaODLSIdg1eBk9F25GOWiIlYGWBRxw5b5AxKVggE/YaKbPWUF/zlxsGbSrITlFsBdSiQQn1T8rKIF6I5jaauOh9Qdyrz1Fc3nH9GWToSdoo/A4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+RkG/X5v0iRoolPQoX6IEAtfiLOFgo781iOq9T4ddok=;
 b=SPzctYAi65NO7OrCCVJnr4Oyb4Vr15ctVZWJh5FjkdW8iH9jCqfkYLSxyl/Kh1u90hGkz9bdbR8KTkrX+ad1YKpQYNvOZOu3nlSkziix0Jx85JJPH4IdzKMlM/HvhPKuSJrU1zfySklpUUYj9nKEgPhYduaPm/mnYSG8WCMkLY5Vsn1nsYtppYrcEn44raatQySZEBnq9Vt15C8XCAgFELiaBd97SCiOUVJwGK79jCM50E5rldl9unoDGIHclhCz+dm23EEVwu+oMNPjlIt4+rliWmEM+Iwt9lq1ue05AovfjJneLxNKAknsXSOWGOKnRdTAM9+SePELPWqIC1tBAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+RkG/X5v0iRoolPQoX6IEAtfiLOFgo781iOq9T4ddok=;
 b=fBk73qWMd9WmbztJYA9EjsJsR4BUlFEkVOFVnMVy3tUaVJa390UEVXWBR9vbkGy6N5L9BxbBB67+zaZt6+mSv+ROqEzotjDnzTIIhSI85ps/Atct+nzzDZbse5rTelWIu9VNGrPni7MKz16vrT+tj28+WTTO6s2SKrWNmP/M1D8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3408.eurprd04.prod.outlook.com (2603:10a6:803:9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.22; Thu, 9 Dec
 2021 23:35:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::c84:1f0b:cc79:9226%3]) with mapi id 15.20.4755.024; Thu, 9 Dec 2021
 23:35:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Martin Kaistra <martin.kaistra@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>
Subject: [PATCH v2 net-next 11/11] net: dsa: remove dp->priv
Date:   Fri, 10 Dec 2021 01:34:47 +0200
Message-Id: <20211209233447.336331-12-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211209233447.336331-1-vladimir.oltean@nxp.com>
References: <20211209233447.336331-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:206:15::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM5PR1001CA0041.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:206:15::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.17 via Frontend Transport; Thu, 9 Dec 2021 23:35:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f442e19f-05ee-4c00-d0df-08d9bb6c90f0
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3408:EE_
X-LD-Processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3408D30225D3CFBF9269A655E0709@VI1PR0402MB3408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0Oa+nIB3srjCiNvncTyLZwSPnEylYyDpjdMVNoJBHtf0E3xO9La0K+16EcarRlmkBzbhO5B1v8EnDtn5XDseskyL+ZS1eGSEyNIF2gs5O+dOiltJRcDPZNkzgBpyFWk+Tn8Zd4WecA0+bDNiMjX9YLfGg9FCUoSiVizC56a1BAp7F8CDeyR9mP9hfwMlbOm2X0+ZfoQDtwU6UMHHuBWPh37jMEhjpgbnMb0Ov0s6txUfbc8ashZqz7M+jHOtHnFg52lkB/9ED4oiBe+iPIEMKTSnyOfpe1o+IlGrVkrO4x1yfT9eWmUbv5Gj8iUqpcGnttd8RtK088lLAbvNvgynSJCBBYWckO0owSrfNDxl0v1jUd6Wh9F/wEBBSb+V+ZIDbNbvXsDnFFSena9yHeHDQRgFGnRr+hcDpCOkUMV1cHrSBI8Azd18f1sF+U/RX7GT2aHXeRfPMaxt9rcMqJZzFwUsSmii12wyuNVdJ3EMGTu0TZspqiQFN1iPw9RKCgj/84BDjRKMjF1UCdeqbZajJA8KE6wOzFk234iEfrSTyW/laotESLC4POSne/HaIIRQ2KmTJpQmai1CnqH+2GFRUxKZQwJF33UJ1jXE+LiBIk/qmkAngJeudAbiG1mS0MO4WLDcJ/Rxa3c4LHA2pZo1R2gK56HqbFS6UBJTUjU6t4UPUtgZ0vAZsSNdq4nuY7WS0tpQI5AuQWylFw5ONTacMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(6512007)(316002)(83380400001)(66946007)(4744005)(6506007)(66476007)(1076003)(44832011)(86362001)(6666004)(7416002)(2616005)(36756003)(956004)(38350700002)(6916009)(26005)(5660300002)(186003)(38100700002)(4326008)(8676002)(8936002)(52116002)(54906003)(66556008)(6486002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SUW1+/3Yh2xZjDxYTZUTiSnZ8mLnCyYXwa1TLn567GY+W/xPYMIP430nvkfJ?=
 =?us-ascii?Q?YYGu4lkQUkSIE8dYWW/vAMDhm1I37tF1+tc9EzRB4Lhah86kAsOkISJIXSEG?=
 =?us-ascii?Q?Qx3Y+5aWBj4sDBFuhsAa5gFIHLS3PQlxd0xOtpo2ce2jVC8WjTe41iNOQcXR?=
 =?us-ascii?Q?9GSgynUxzDpjKdW+PalEXhlhkIYLDkMlWyLvnE/8DCH9baDSLjzJXxEaQhG/?=
 =?us-ascii?Q?7t90SaSYqnkfgJ8sYWO/dQagk8YKDqwvB+iTyKoyBcdaLXLCvz4ofbIRutar?=
 =?us-ascii?Q?FcfMqaUKwSGJlDuGbGVmZAKQzYTDIBy0CxX64QaYDN6+pdCV3QZ35JZhLZnY?=
 =?us-ascii?Q?HB7bH142CA9g4nVzocH4hlTH2p/tOYt04BDeTjhRW8DyNyRV1O0/Nd2Fq61A?=
 =?us-ascii?Q?TSGF1vtcS8AkFCv2EMC2h14kO43L/YPwCDvy1X8uTU6oYzGL+5y6dAOTfcwk?=
 =?us-ascii?Q?l4bJ/ivek13MlFNy1Um8wuyq1XvJPNRvMtI5SH+9uQ2+C2VKACMspDh9V40l?=
 =?us-ascii?Q?h9wvPukvmxm70hkHwk0ovozhd7A7KHrnSHS33eWrSRzPbMy7S4PEj9mLRZ0c?=
 =?us-ascii?Q?kavmSnjMKKN2M61OQ+DZIpwsnQ/YbotTYKNSbTaggzQ4cIr9ZSfqrwCLlbDj?=
 =?us-ascii?Q?slNyFJjNCsm6qecdUUp5R1j9xS0/Q5o82W5tr4+RVDYFqT0kOT9ndRko3svr?=
 =?us-ascii?Q?G2V2bK8PPqP37tIm/7K77NOAa9b224hxNncyp1tAd7nbXp0rnri0xpr3566k?=
 =?us-ascii?Q?IxYj71hID5MYC/EvqLXV06yRkPkuT48M6SAjh2i7kpEoGsWiZTleNUPq4k9Y?=
 =?us-ascii?Q?Bs2YWQUPpD2gngffkqGoiU+2JRXG1XXSv78otO8zdPoWLAdn/A1+R5bUhWR5?=
 =?us-ascii?Q?cALt3ZJw7EQygz/Iar03AoUcL+LXmKoPXXyxu0O5e7Ibi5b8NFjOgNZ6rGeU?=
 =?us-ascii?Q?BMT1nBSOh3yL06qNydSGp1MvQiCO2Kit+KE2jAndpLr36bdvGGA/oabgcOFo?=
 =?us-ascii?Q?y7Xcbenwvwr+CyH+CfcGkRboCUxOGo+RtMnefacRBk4OCZqSPd9sol+I80m5?=
 =?us-ascii?Q?wVHpFWVgXiE9FpSZIhIXmKSFy3l2H4Cths9vA0qSqnvVBmBS23hRZH8Lol5L?=
 =?us-ascii?Q?zJho6YCpfCIR0QcYUTs8PoUWmi1uJRxYT5x1wIQ+puMlAjoDOs4TXU0foIqL?=
 =?us-ascii?Q?JPAwaTbYA42yQmS54ntcE/AR2TIFwEsSLjVaBgP3K4fsZ29vJz0MIVXlqEoo?=
 =?us-ascii?Q?oP3gcMhTjDac0ynGH7vJ+q7h2eZmvjAkeM/I8ELDLRxL+LpJkmQj2AqaJbCw?=
 =?us-ascii?Q?7ud1/maZ54MDz/xxO5OggXqVViIUQ3tmi+Y3jyH2rA3YTlYGfYi2E6ZAoX59?=
 =?us-ascii?Q?0xxMS9C3AEaFCngAc3CKrqSFLhBnoXPeTnGqJQUHYmdwurHRcHpwyQw2KA59?=
 =?us-ascii?Q?WZ7DoA1gv59GGBu2WpR9JLIacTtrEZanw2/jUptHOMHye2o63dw1q8nRn9cx?=
 =?us-ascii?Q?zVa1XJs171xClfCF0sGcmg1i5/PMdtVJkglW5+6vY9Ls2mW2LiRXKCfXY5GA?=
 =?us-ascii?Q?ogDpEyVk2D8QPpNKNgONeYWCKCS5gQnHq+sYgHOveJmh/pp84TDn78qtLjq1?=
 =?us-ascii?Q?BI3lRVptz2GDu5kVxg9lpY4=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f442e19f-05ee-4c00-d0df-08d9bb6c90f0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 23:35:21.5167
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0DgbJyEqyKnxxZnc4dQQDjTwmq8cJ2mwmbfrUslAK1f6PBfY7z8ma8jsR5hoyym9tuGuCui11BprrNjCl/FMnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

All current in-tree uses of dp->priv have been replaced with
ds->tagger_data, which provides for a safer API especially when the
connection isn't the regular 1:1 link between one switch driver and one
tagging protocol driver, but could be either one switch to many taggers,
or many switches to one tagger.

Therefore, we can remove this unused pointer.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 include/net/dsa.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/net/dsa.h b/include/net/dsa.h
index 8b496c7e62ef..64d71968aa91 100644
--- a/include/net/dsa.h
+++ b/include/net/dsa.h
@@ -276,12 +276,6 @@ struct dsa_port {
 
 	struct list_head list;
 
-	/*
-	 * Give the switch driver somewhere to hang its per-port private data
-	 * structures (accessible from the tagger).
-	 */
-	void *priv;
-
 	/*
 	 * Original copy of the master netdev ethtool_ops
 	 */
-- 
2.25.1


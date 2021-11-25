Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8292445E34B
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 00:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243456AbhKYX1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 18:27:31 -0500
Received: from mail-eopbgr80087.outbound.protection.outlook.com ([40.107.8.87]:50560
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234576AbhKYXZb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 18:25:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jSW4ft6wnWnVXlWvrwvl2wM0rhhS5hwlFVRWo4Po53gMrG2JsPiaKIjr0x+5P3L+4aH0nzmkKnhtQp9WkGUZTJ80cERS63uxVKDIbgrdlxOlOpXYkrF/o/Irj3JzShtK9ZR73b64SMScPt7Qrvqx08sb4K040G2+HuMT7yyRiov1C+suygWbwgFImjbxZY+VJwkDNFLhC6layEnIG+lJ/gzw4XC9HpXuEmn1/huO7UMbUu6TKxom4jayzxixcMAFHje/38MW7hTMypNSedJC1n2Ou8IxhIJu3rXSO1CLTudsWDT5yY/L+MikdYGV7FB3g0rOYsWH9ydHcqxG4prcyA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SMOyNCcbc+DYVZ+GjAnhBH4wAUfl6tALasJZf0zlJ2g=;
 b=MNK4rpy9fVTfJ2o4RXmATQGxfC+pqayeDYPe0eG5pL0o2k1KeWkCi3mZiJ+o/I+r+j7VHnJrgXYKQKnNlCPj5DgvYuIV++PUlg3U55b6TXzDWGMSHqGGzir1n+vfu6ebxE6tOzTUy+gtm3xahS6e+DDmneSe9t5xgX8FdFivegvzJAXsJj29hHFpy1QAAXsVAitC9fkU8/qq4WWaNatXbDPHdGz1cKXUCckEc3nzQ+qv1DJoM3OvUPq1TpKPwmOQ09C0jie3ZVVxmVrpEq0us5MTzyJnGehLoFDgxwHRhFY0iKyysbHcRDzejbI3ehDBqA9SyWzSkiuOG/aUpN25Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SMOyNCcbc+DYVZ+GjAnhBH4wAUfl6tALasJZf0zlJ2g=;
 b=qydWHJ6VPjAgKe70fy8Akycz+ezaAaqY4AmEeFDpOURwtQKyc3PqfHmJHTp7SkPmJbndGPaRqRv3Yx/dZ+nFZUIkbbJa6Gh4j+jANTpCq56jqPqygUoZCtgQWSPvaROHJICpj3uuE++gguptjzXu/S7sRQepAD/ZZ0sFpZ2jQRc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20; Thu, 25 Nov
 2021 23:21:44 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.022; Thu, 25 Nov 2021
 23:21:44 +0000
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
Subject: [PATCH net-next 1/4] net: mscc: ocelot: don't downgrade timestamping RX filters in SIOCSHWTSTAMP
Date:   Fri, 26 Nov 2021 01:21:15 +0200
Message-Id: <20211125232118.2644060-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
References: <20211125232118.2644060-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS8PR05CA0011.eurprd05.prod.outlook.com
 (2603:10a6:20b:311::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.163.189) by AS8PR05CA0011.eurprd05.prod.outlook.com (2603:10a6:20b:311::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.22 via Frontend Transport; Thu, 25 Nov 2021 23:21:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cb0408e5-d3ad-4b64-14b8-08d9b06a580a
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862BAFF1A01645807B1F552E0629@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: idA6eVy0UGQmyZI/6My061VoOSk2v7w21ZNeeeGE9W3gtgNhKBrkKCY04+Oo5nDta0g3sa+Rd6BeLab48sZ92aDNEKxDhveTuGUjewIcPZQG1j3hh5xXDYcqfXQD1TcorO+F8AzTk+w1CjI+g+gkWY5RhGYM9EtOKVFupYmWfR64ek3QFs7xgY0JqKCnYOXAEPnv18bSlEKNtuSvD7ABYDO8VPHEgqZGljNa/GCVWFw9zylNuBzUNaliLE+cUZVK9TdXVRcr6tm7x12qoYnVpuBn8iNmgriqGuvxD/Hr2jC1VuKfU7AulmUhwDoQXfEjLkMcjFTWuJNCWy/tCKL9qfNjpsdHNVCSd04TAoNyH+nVd5w8F9pNB3bcggLxA058T0+1MiX77LF/w3q5XWGb2ea/KApOCvGEAJoOd9l59YKvTShNLURpYzxvzkmujocKlBVpxfOP8/ayDU4HfkPfucefnJsbixaQP9s8mJsUM57UqRqFobgm0rOqdqYDRsXS4I/gJEGsSACg6ccR+KKD826QmpgzYY8O4y9JV6Qrue948oYEikPoA4uMl2pEYWEdYOibzu/a5ayEYJ5RI3QaVRgGJ8MOcfSEGSS6b5TKvPz29bsU9fzCkvvUqcVCiBgGalYeA8rV1kaAhYZdFdPR7+wB22xPm3uq/HDIguVpHrSW5+KMDotw2SsYb+8j5NiNVj2TciMjr5GVInmPv6fWLcQdhK5adiOaTt02VyOZG9tesHwHmOiOc8M+JcZOMidOVgXjD2VUdWEMMcNHgZg5k1T/GAaDn9MpnxmIcGwrbZk8T++Xhf2/QOMa0t/iPCBO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(26005)(1076003)(8676002)(5660300002)(52116002)(2616005)(8936002)(6506007)(44832011)(83380400001)(6636002)(6666004)(186003)(956004)(966005)(6512007)(6486002)(508600001)(66476007)(66946007)(66556008)(6862004)(37006003)(38350700002)(316002)(86362001)(38100700002)(36756003)(54906003)(2906002)(7416002)(4326008)(156123004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/B027Hb8HMJ2VUBVFYCqfPK8wjJ3ro+V8F258PwhhVgSWoVkqQp16IzSvrw9?=
 =?us-ascii?Q?XIX6cOlCPsWgGjW3Rj6vd4O4HTgkWfF4AhrB+s95PElx4qg1CX5fEuwi+ghR?=
 =?us-ascii?Q?FY8DWuDFBdETy2Ni+QBdVibbQzT0+Mu4WxT/jFeXz+4ljarpyV4SHdDfCU2F?=
 =?us-ascii?Q?rT9ozN4lXYuUS7geg4XDvhU9k8VqfTjtOrf7PiQHZj9hWkNNmaXFyKP3RWWY?=
 =?us-ascii?Q?STFeKTy1WhwizXGMHuwhqlG/IncAUTRMyI01rVG4wirNCHo8w1UEEiY5ogAe?=
 =?us-ascii?Q?h++XEm5lzsOO83LMmZBpcalQ/LGej2Ql5aGzzRue7rSsqnuU4EetiU2O+hvf?=
 =?us-ascii?Q?lTFckXS1pPwOLv3nkyv3ibNcyvhDz1qvuXCalj0XEXSzMvnDVzKk5j6wkyJa?=
 =?us-ascii?Q?2NEr9epktLc0QIIdd+0u0LnyCn8IkjWK2H9IAg8MaJooaGnyf2WpzLVrIk5j?=
 =?us-ascii?Q?X25eA52d9JQi8BuaI/LSXFL9/7DSfFCb6sjOmGmC8z3ukUu53t86g48KLn5w?=
 =?us-ascii?Q?tf5c6elk1VSchpkTEZwsPjBwjIozAC3W+W1FbVbWlRzCa1BV6JCZYOMHMwSw?=
 =?us-ascii?Q?u7L5kjCKxwLEoRZbbWLNelHP21S8pG8YGtHi4xjtEQ1Aza/NkbvlqdJ8BtYn?=
 =?us-ascii?Q?3BiMGtE3+8LJcGDnu7kH7WysA9gSAdbuhlnruRhkNd+4QRTEqlxmN9Gohbfd?=
 =?us-ascii?Q?VerEVSzC1h+erf1NBVrdk4u8yJR4HQsCrXqnZn3uTSgBdu4bbbQfObz387de?=
 =?us-ascii?Q?hrftaaqvDLg2HibH8FHXCVFl3GizC5VNuchqefnZJocnQKkq1hLFMqdbgUhN?=
 =?us-ascii?Q?Awa+m1r3D5HZcKGMlJmazXMAo8jS7VbxP45KHrJ7v46qbC1u8RVsif6lANXS?=
 =?us-ascii?Q?FVGC/LBz+njntqksOG9LNJmlXm4adXQBe5C4QCBtyODRq5YRrU7jECnD+yks?=
 =?us-ascii?Q?4zeEwzdrUa+9IyBlghN+k8NJySZki6MLl7IszZLAKnqv6qa//6+Wf4oSXgQw?=
 =?us-ascii?Q?LirFttG7aVxLMI5z67bc17DB91DRdXbfBOdSaL39Rp96aFMK90GYEL2TKone?=
 =?us-ascii?Q?Fdv9ZVDJzCAK97lkY1bWI08k2hoDcO0bJhIT78Vi+M30w3jiViNFibCGBgOD?=
 =?us-ascii?Q?PybC4Rh/FVutOmlRjnsbSfei/lTQamGalZNlwPWrrNucPgCprOzpoZMb6LS2?=
 =?us-ascii?Q?58lS1XyfUlt7pr2vZuAZETeTiuE6OUtngY9sp1rGmvran3RWo/o6NZ8d18yD?=
 =?us-ascii?Q?NBggcGOpUJDIeipvor6vDyft2mfJkgd3h11tJBQ5yPbURkLFU8jMl1wG8rcJ?=
 =?us-ascii?Q?vhnU4Y9VzvAaFo1ice3tEKNiALZoEdQKPj7FGZ7Jk+Ev1pC3dcjc2OwtywyD?=
 =?us-ascii?Q?id0V3krLNDtX10SmnC0u/kftEsMO6I48ZWxChR21F0EDfsEeqkJLO8d6iIQx?=
 =?us-ascii?Q?jzBRmIIR2h+YdeaYYJ64R+pxHGXJj2TIDBrbAaoftzdzP3qUl6QkxrLxSJr3?=
 =?us-ascii?Q?MYlAZWAvEhbykHDRjjQYc5KvKo+15MfnykfaNjBSlIgv2DkApcjzMZ5n2ovs?=
 =?us-ascii?Q?p9KvtaYSjZ1uEnxoOBVhNpWj9ejFujlGMZbiupLePQOUch6vZLL+HCDECGsk?=
 =?us-ascii?Q?lM+xcGanIwMxZ2iQKJuxGZ0=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb0408e5-d3ad-4b64-14b8-08d9b06a580a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2021 23:21:44.1662
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qvJVYN5nO74M67T1ol8o8Lv/TqKDeIASYCatM8PfzzuhK6negKaZ1JZWbh6I39emSO2xI8Yrl7PSBtf6yJJf1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ocelot driver, when asked to timestamp all receiving packets, 1588
v1 or NTP, says "nah, here's 1588 v2 for you".

According to this discussion:
https://patchwork.kernel.org/project/netdevbpf/patch/20211104133204.19757-8-martin.kaistra@linutronix.de/#24577647
drivers that downgrade from a wider request to a narrower response (or
even a response where the intersection with the request is empty) are
buggy, and should return -ERANGE instead. This patch fixes that.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Suggested-by: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 95920668feb0..f5490533c884 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1389,12 +1389,6 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 	switch (cfg.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
 		break;
-	case HWTSTAMP_FILTER_ALL:
-	case HWTSTAMP_FILTER_SOME:
-	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
-	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
-	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
-	case HWTSTAMP_FILTER_NTP_ALL:
 	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
 	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
 	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
-- 
2.25.1


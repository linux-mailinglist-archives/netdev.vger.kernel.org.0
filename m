Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C7D45F2FF
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 18:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229703AbhKZRe3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 12:34:29 -0500
Received: from mail-eopbgr70078.outbound.protection.outlook.com ([40.107.7.78]:14467
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231638AbhKZRc2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 12:32:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jtS+wUFWMdRebtt8ZifV/2BkxC9HLiY0ia1it5Mu6R2BValOx0aozY4bcyU5j7KTNfwjBLVlts7btZ4CbHbryqptTfbf6+1EMDmCtsf+IuYw5pj20g1YMr7ZFEHmBOYsy54lUGc3wTZSyyB75JPklmLOgwPZ/SL78aZr8B8hPXC3sz9AWx2Ddu20gSEirYoRjSi6zk/F41OlBklNcT3DYhyTo4wiPjWtUcbV2Kp0/obKQORuvtOysAodgwuKWITSdXJsroMpm2UL6b/9M/BWhlJi/NJZJ0P6Aour4P5MFmHEewgqwyBZOvf/3kTa9V5PeBE9/pLyDO2B62M0UfY6Xw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O8eSDQ4QiyrMT4kS8NS2MpJ+1SEgcIiK/fS04P5icqs=;
 b=oC34MoTxlSU8aYnRhqZ+JXT5fKJZD2TTmej9QX5rriWdgdbStkOJIQstRG8IH1+o5Vg+QtawuwUYpWmfR+77WY9AQrj6sb5LkyaGaI06jwgm2qznr7HZqGf5vBZ+cuT1fLO2AwFqAycEXckcc1t8CLji7SSsMIdAvcKhOw51zJZtIKUcNyr/pbXq3Gna8/1CUsk71egvxmLfotzVpP8k6ic8zKch7QNvRLW8tU8KzTqiq5kclrhaSWbrxuoy3EDMsejH38i7fkrZt/pGh6do9QdiwPHZYbOrHX+lUstQQXc3HuJvr2+VC+VZqWtfzgqex/urpHFrLNOZJAZMHYHnmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O8eSDQ4QiyrMT4kS8NS2MpJ+1SEgcIiK/fS04P5icqs=;
 b=KC8aeWg0LAdVZUl7AdPoRWg7lSr7FRGK/+4YthSAoP6/dI5KusV2QK8T73BetTSVYOJImsbxMg6i/WG7uM0TZoo+ja1zLPBc27PACGdlOhJdqKbp+RjlfzDuNgk48ceORjZfRRcKW69bep2nfA/wwqjoT3JKcFOdZAvEukdFdvQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VE1PR04MB6639.eurprd04.prod.outlook.com (2603:10a6:803:129::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.20; Fri, 26 Nov
 2021 17:29:02 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e4ed:b009:ae4:83c5%7]) with mapi id 15.20.4734.023; Fri, 26 Nov 2021
 17:29:02 +0000
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
Subject: [PATCH v2 net 1/5] net: mscc: ocelot: don't downgrade timestamping RX filters in SIOCSHWTSTAMP
Date:   Fri, 26 Nov 2021 19:28:41 +0200
Message-Id: <20211126172845.3149260-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
References: <20211126172845.3149260-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0125.eurprd02.prod.outlook.com
 (2603:10a6:20b:28c::22) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.173.50) by AM0PR02CA0125.eurprd02.prod.outlook.com (2603:10a6:20b:28c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.20 via Frontend Transport; Fri, 26 Nov 2021 17:29:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cef609d3-8d64-477f-eb76-08d9b1023cf1
X-MS-TrafficTypeDiagnostic: VE1PR04MB6639:
X-Microsoft-Antispam-PRVS: <VE1PR04MB6639ECFD79C66EDD2F0D69B2E0639@VE1PR04MB6639.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LOrx3X8pcYp3UnhXTIZa+MlDBxTCJ/mYTyCkkZ9XGIhETRJhqGesaggkZZsnnYg7aWxYLBinHOdkDuUdOTAN33E5PnfJ7NF113K9PT5Q8lCjQFeD16+SCqeZtbV/lHn/JSgvCmk/xjE2l8sbW+R8XRRI7Igfz/tslx1epa4YKIOMHKAO0fe9fnvY9Osb1PXwt89hpoBs8avxkv8jfI/F8J8nmizEa3otMAiIVVL4IIUTas9oMza9w1eKfzscbkAvIsNNO03Yu96F4I/Y/+6gOsVGI3Qj6yuByE4OFSFnRBLsX3bFLhA1+DEq8UZp/SRuc+sci3ncKZvNuSkfUE7aRaJPU0bueSlruQItZorviqHB9AFvLB4MA6XdXi7I64qspX26jtQPDdvwMeSIQMtc2whXKOPKHS7w04FNlL/1J//DNjlOFK8CHBvauQ2s7duyRGvzW/lEG77tkIwAGzYl1d9Ig7JLo96u33RPtCsiV6uhUI74v/HZOuYR9RwHpB6hVYPrANE1aKWFamoNTU/l83jSHI+TK3IUdmCKdU3kbZ4qw2sM9lkMhujCEMrN/j3gPLP6HaCRTXTEOTVmpn/H4r3iykEiJSL6vY/FfCkecXbIMAZQ2LCGU6AL5pDNIvKN00csBcU+dPFNnvqE6CagV046o7mBFpL0ZEkC2Zwhe0SdrgPsN+q8g0fXOLPfWA1UJ2H3PBaTSvQvX5A4wbvLH5XFVmGzYevhCaXfWDWyyrXoSrlc4UA8mY7auwNGfFADU5AlHYIuvqK3g1g1Wpt2FYixo4fzKFf9Rc0uRPBEuyY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(6512007)(7416002)(86362001)(508600001)(956004)(26005)(8936002)(44832011)(6506007)(6486002)(8676002)(52116002)(66476007)(966005)(66556008)(83380400001)(2616005)(5660300002)(54906003)(36756003)(38100700002)(37006003)(186003)(6862004)(38350700002)(6666004)(316002)(2906002)(4326008)(6636002)(1076003)(156123004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WXad2QE7/zhPv9XOb2XvjYgXd3EJuT/zsb8IM2NlB4jMk9cgFrQcuk5eBNR6?=
 =?us-ascii?Q?eTKn2LpqfMx8j6F7GySfTLaQ2HNvrbQE8FUv1pfNMLOe3WTBVICeLvNG5+XT?=
 =?us-ascii?Q?JJD5C6pwmg204EmG0zCogi3T0KsTDdl+ncXWOp17aVITq38iVwbltJyAOkXE?=
 =?us-ascii?Q?IcSAhNhrNgq0F+kNejCrLR5jIbnmSnirjZvcHBYPe0+KTSwVXGCrIv2ZTuUk?=
 =?us-ascii?Q?wtXdnGwVQ12D62Fiu9CYbEYi42lLpvwj/DxfSE1lX/jzcPXav+6HhB3c5AoR?=
 =?us-ascii?Q?YnUS8cflJAhhfWqWeozoyzCKVtJAsRhz0D8rER1GSW1Vf6EELYG3lRozMoIz?=
 =?us-ascii?Q?szu3KUCdf18zZooMwxorbf4beng+hYvdCz7cP5B0owu4oi5i8PD2cm1Cvj2j?=
 =?us-ascii?Q?jNm4ykUfw86BRK4gIC8Ux3jD6nHKC+2Mw/t9JIzsVo6yRSf0+T2MOaTYEQTm?=
 =?us-ascii?Q?/F3DitcWhIgtjlkHTr7sdcB44RlDBZ66gl6VJ85hw9KiCDp18Uabcv5cWCD3?=
 =?us-ascii?Q?7bweOX3Oqt273LbsJPRLaP9lDOuucDe9IN28gewciut2q4fIBQInw5YBMO+1?=
 =?us-ascii?Q?TvuB19xSKFPb65jlgzFiUPT4EPxo1BmanfbD5fFvIqTyZ3QNYB7rrAxLxxyO?=
 =?us-ascii?Q?Q198U7+JhOqZpPMp7YT6ZuDbajhiGKJy/aEvnm8uQoaeqU9qRCLSxv21TKA7?=
 =?us-ascii?Q?GGyenTD2d5jVqPCiY32dZe5g8tdt9YRxqo5PKkIOUkEUxfiWegHsw0tj84fB?=
 =?us-ascii?Q?W6Nq0dMF7eXtceHK/vnAPDn3SsnM9qCe3uuqNrADe2lYMrN0gdMHsd5mM6BY?=
 =?us-ascii?Q?1s7Dh/g5lTlhbHnUP5yCtKjZGmIko4grZkhKLJcKTNENN/0OYoCyL6WDLO5L?=
 =?us-ascii?Q?aawlwADzLg/Mf3ctuwr8uRxL1Ryly4wg+6zS7l6KB/MHJZ3gr2bMAFHaIZXr?=
 =?us-ascii?Q?E/1HrMr5dWxGcpX0tpee/Ukc8ARnX5QePqjs9DGn0gXlIir1eZ0jEF6p5/UX?=
 =?us-ascii?Q?ckcr6qHWT5I1wSRS3C8wha4xkSckHfL/rCjfNS4Hwgrcl/vTxYgf4Rt5GTdZ?=
 =?us-ascii?Q?Si+6ohNEEPypQOOU0r1m1Eq5yaTK0owotKzv0P5hKrfjGqGnAPUvsFfHKkRT?=
 =?us-ascii?Q?UC2DysOSDGMl3VTUkZcvy60spyWypDtOs1fBGs+Wc7Ll5uXIsge6I/BPp+Rr?=
 =?us-ascii?Q?9YTESRCPJXYQv7lgWTx9LqKbIhoBejjwWhEX9wwArxrptmBt55JWe2SZ6wOs?=
 =?us-ascii?Q?yaZTc44fOsvMB7r0B/kpo8CCj383vFcFUr78GDhVuJGZYKB+rDv/m6UuDHgg?=
 =?us-ascii?Q?58yoocta4lfifivL2aE+0Zho5qzFk3ecH8b/zwOuPYlXP5dQwh1EDWiw+1di?=
 =?us-ascii?Q?JSAa7xLAcgZvH5ZTfG0W8QYO8JUSJIPjLvoF4ai52p8VNclrcBSX32WPQV7m?=
 =?us-ascii?Q?Wwm8wbp022eSALDpi5+Ug99ekv6BzlfH1M6ucF7eWXNmcEUzDMWpDMXfK9b8?=
 =?us-ascii?Q?R3xdNzojbPY+KZc4FCyM/wV4uxc6GHwxpbiGX83bY0eXa9xoWut9wuqAJ2KJ?=
 =?us-ascii?Q?tbxHRHsSqWteBgT5rWDKRpmCZ4QgASb3AuEsg4OeXxP3Nk432BvQII1nma9J?=
 =?us-ascii?Q?HAxlKhnEo4HJ6jZAWEnskUg=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cef609d3-8d64-477f-eb76-08d9b1023cf1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Nov 2021 17:29:02.2292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E3fqBbbY73YQbJBcH7eJhnPx/CXylCL6gZqW0pkO9b0AFtqliUgFdxHa4j/iD2YuWbiBnoKqxEHNU3AV543ylA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6639
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
Acked-by: Richard Cochran <richardcochran@gmail.com>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index e6c18b598d5c..bcc4f2f74ccc 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -1320,12 +1320,6 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
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


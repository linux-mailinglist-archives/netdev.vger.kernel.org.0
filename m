Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D35532E0B13
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 14:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727266AbgLVNqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 08:46:20 -0500
Received: from mail-eopbgr70089.outbound.protection.outlook.com ([40.107.7.89]:35431
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727271AbgLVNqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 08:46:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHDZMzJmEVD/0tyjn2KK2COJ6mS3iGEQpQ/U8VEBspQFZZyNLV1HF3Yx9kFIxX+/GlL3LCHbfzNpWyOlpjxbwnDe8AiE5kMVTPDZmfeXBVJJOwKEPGCs/edGIQNztYGFHSiMIi+qCbM+FwXPD1o3G9PsCH47HwVzdQi+Flhq+ZoEcwV1zcdZOoznVw1UEzX1QTahTmgGRXQ2uKqelCFBljuJ/LMFc1nXzrOUi6MZzN/o2zxny9tRjCdG+UgLywBM7wfKWB/1syr70H8WaJmXmJw69y4dZBhNWitDuzDa+T/zpGFnfc06Za2OC4P7ERZSsBRPSuPURr/XgO5k3p/01w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah+EXuMvY9bZ2ifh/HiQF2WNdLQxn71hVwR9LUfLoUo=;
 b=E+nEiUQ9J2iX/6InVygCLNKws4yAN4VpxbE03sXD3fSZAmMZ9Ru8a8BX++oi4TnA4ENa1Qz1Vki12wVMqk37Zne9JLjMLuYvfR3fJIOUE20y4w9dh1BRYjh8ZXQjlhBY3JIE/EKnIGO16xV7JaU/NYzl+hGETwFmK2aJZyDz34h+HUxFAnJAVBTqcl7Q0KemfdNLTKylx6oHqO9mpq/C4E/hbvRsyxRZwIz36mK3ZxtMwFziq3qiElzUy8LNIF3CISydk9/L6tM5Mw525LL0o0nAQdv+yltrYlzS5u3s4Yw7R/asys+z15silYI56/B5JW2mXdz6yBumy+0yHCHvRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ah+EXuMvY9bZ2ifh/HiQF2WNdLQxn71hVwR9LUfLoUo=;
 b=YVdnYo4bKvaKyPhD67dbKBPeL5MLp+QbEpr/loQpFNmG2TTj83/slRSZuopeE493wzxqZnguY7uS7ym896f6pqajMb7g9HIz9+S5/PHAKLXwUWm2cMItU+XjDlehkPsJiHXuEx35irplFQjYS277oitBMvIGtTAIdgdIPWOHe5A=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7408.eurprd04.prod.outlook.com (2603:10a6:800:1b3::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Tue, 22 Dec
 2020 13:44:59 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3676.033; Tue, 22 Dec 2020
 13:44:59 +0000
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
Subject: [RFC PATCH v2 net-next 06/15] net: mscc: ocelot: only drain extraction queue on error
Date:   Tue, 22 Dec 2020 15:44:30 +0200
Message-Id: <20201222134439.2478449-7-vladimir.oltean@nxp.com>
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
Received: from localhost.localdomain (188.25.2.120) by VI1PR08CA0169.eurprd08.prod.outlook.com (2603:10a6:800:d1::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.29 via Frontend Transport; Tue, 22 Dec 2020 13:44:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: b7cab140-b285-4576-7f5e-08d8a67fc663
X-MS-TrafficTypeDiagnostic: VE1PR04MB7408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB740885A5B6BD40C0679241F4E0DF0@VE1PR04MB7408.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcyEw6ZwLO8OeeU6mhE7msUA9IDlRPlZoFr42vv5WvZURewyKdhO2ihrXZrnriSa6iWjIbxDP0MayJdCYVYM6bCKOYlieSr316wzfe+nY6B7Mqf0keslbnPHHIZs4LNuU1B+pvFm1wAfEwk4hMwgssplPlNnizVV2vCeO49MEwoV86jl2aFUHUyyI++a3yg9rctYRW7r7+X0pKOrteRVdzEts8S3804g9YjF6KRy8s0XqiM+kbZ7TDDJpZQ3Zda0yZoc+Sl8NPzJiKNV+qAKRKIwnsmpaILogkG6OWDWKYOTUmONPw1iCtdKYRNVEhXcbzQ48xCIrPXIRKJWfZ1jQKV6w1LLg0Ych/mIW17xs9OGSCzQ481cZEhnahNOawCskuder28oqHB+9BtotcSIAMU/M8FewFHcAH4SatoBO1m6Yp5dMqI7RhuIhxTgams0O3Wc53xig2cqx3Xq9Ql0rg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(52116002)(69590400010)(8676002)(956004)(186003)(4326008)(36756003)(2616005)(6512007)(498600001)(16526019)(44832011)(2906002)(83380400001)(8936002)(110136005)(54906003)(26005)(6666004)(66476007)(5660300002)(6486002)(86362001)(6506007)(66946007)(1076003)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?4gmueqGKC+hpZ8mPqZySMtkxo+Za9M6nJbaK8NIX5uU2EFdJfIFEkLgo0wyL?=
 =?us-ascii?Q?rbg8/dBu0q/qA+BykOGtcBmulJ5fiz6fXJV6bMNGrBe9G4zw2/isRQbw/Ncf?=
 =?us-ascii?Q?2kgvO0GHcoWDssw1UNCyEmnvLsZkk6m1jqYGIDe2vPC/jrYDmcOHRNqk/JsE?=
 =?us-ascii?Q?VtwQdMsGwRnEMZkRWmvwEbSkUIu8f83Tj5pyT2vZHtqvL4LjcUTkqVrih4JX?=
 =?us-ascii?Q?1MW8MDq5yiShOPjoPJUw6yNhEOPNKYGM8ygFogn/mfIGCdCfBB7FmiG5xWbj?=
 =?us-ascii?Q?qpTDsUF0Q3ITieslh2Lj11CV3Bz7D2RvWuJbSbvaUoaYhUed0Ff7mb63lpeK?=
 =?us-ascii?Q?7zTW/fnqn0MWVE+SHkpC/1OrnXyQnAQdLyON6fd61CPXQPCKKtyj2s6R0MyP?=
 =?us-ascii?Q?uu0bZTpp1wwmcHLbIGrhVpBiPo2hH4Wxfxt2pbOoQ8nl6cmUUhcPsvdcqzM3?=
 =?us-ascii?Q?QqHmG5pTTQr4sJZGc/mHyENH2fR4ZHLaMtZD4a2hS8+OrEDfJXJ2VBA/k9DS?=
 =?us-ascii?Q?lK4MnuC8arzQiEHH5yN5IvI+1QnVvKhQwz3e1Ii/jUhuuOdjVsaoSBMnkDup?=
 =?us-ascii?Q?zT6XVHBM7hfAlE9iPGT6eFHU35KfdMbXjm1cQJDlqy/ONfGiIwmluWOCTQTc?=
 =?us-ascii?Q?sgLRQL70lVMMxKNlD1tslyveQ1h2UYZHazFAb4fcV23uW50HQ0Z7gxdQKl+h?=
 =?us-ascii?Q?zZ3q0KV7N1v/yzdhI6/uEhPnnQR1ZcaT97lMTHSrgdUie9pmvz6izqgmCNG2?=
 =?us-ascii?Q?x4QJ6IiwBbjb1IpL1+vyGuGwoZiannSsszdi+Ou/0CVJNdLxXwT6t9R0kA4W?=
 =?us-ascii?Q?ujIJElRtIz91IlRAhy9FmyyhdktRMVlC2t3uD3hZf/My5ivlC8nqj6xS3/xh?=
 =?us-ascii?Q?Zq84k5KHPo/faifgLnaMpeGyOn37XKdPEGPi07rFtAGzIwkfZ6YEswrJnfsj?=
 =?us-ascii?Q?zuTbfIb3C7Pv//Ll3cVCspDhEMag/vhuwKulcKDPTBnnyhBos742M8KZp9oa?=
 =?us-ascii?Q?5o3t?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Dec 2020 13:44:59.0792
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: b7cab140-b285-4576-7f5e-08d8a67fc663
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6Mc5MH9ikpeYo7SzqcnerHwYyh8aM4wJAki2MbG95uCa3Ka0dYArFp2dkfGAz3ECp/qBLiANRFJGYpneMf7vuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7408
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It appears that the intention of this snippet of code is to not exit
ocelot_xtr_irq_handler() while in the middle of extracting a frame.
The problem in extracting it word by word is that future extraction
attempts are really easy to get desynchronized, since the IRQ handler
assumes that the first 16 bytes are the IFH, which give further
information about the frame, such as frame length.

But during normal operation, "err" will not be 0, but 4, set from here:

		for (i = 0; i < OCELOT_TAG_LEN / 4; i++) {
			err = ocelot_rx_frame_word(ocelot, grp, true, &ifh[i]);
			if (err != 4)
				break;
		}

		if (err != 4)
			break;

In that case, draining the extraction queue is a no-op. So explicitly
make this code execute only on negative err.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v2:
Patch is new.

 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index 00c6d9838970..ed632dd79245 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -702,7 +702,7 @@ static irqreturn_t ocelot_xtr_irq_handler(int irq, void *arg)
 		dev->stats.rx_packets++;
 	}
 
-	if (err)
+	if (err < 0)
 		while (ocelot_read(ocelot, QS_XTR_DATA_PRESENT) & BIT(grp))
 			ocelot_read_rix(ocelot, QS_XTR_RD, grp);
 
-- 
2.25.1


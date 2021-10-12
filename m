Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CBC942A376
	for <lists+netdev@lfdr.de>; Tue, 12 Oct 2021 13:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236253AbhJLLnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Oct 2021 07:43:08 -0400
Received: from mail-vi1eur05on2048.outbound.protection.outlook.com ([40.107.21.48]:6177
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236177AbhJLLnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Oct 2021 07:43:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iz5KUW68V/XGUNF4i1zo+Z7OiqkzSm8W3ESNnpnM7+Nncq17TktHDi20qu8JhtlFNgdbNeIY/r/Ggpinz+N39h8H76n2S/PmcZT06UsKYgjS+eiHP1Ck+3shgEi9+Jn+hMGzKTcYxamsaJS6S3/SD3Lkat/SN++8jCR6lGm0xoqpmPmEi3BJ9/e13Ejqmk6vkumDv6aO8fhGS+smzT5fC1LvEyJjNzl4ooLRj6Ubw0FOzlOkTomgZXFp6HjFG2AUNdYJdfMq1Dmt0mccm4lwAy1pBvYhYB4GPAM/rn+NqlYRXNt2ErAP9ZE6ISb28Iub676+xZHeutemb/c9x8CLAg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91Nz26/xz/sFrWPHwdlkVDYW0rUnPI+pKjFadjEfqZc=;
 b=BkvovpZMUul1thgarJvLm1FERdEnKCSuIXGlen9v7LEwfxVvbjgdpzqHS4GN9MrRRQhrs5n7scISDA/kf5MLRFHsgmznCDR2DbHlqXE8BNkS/wCN+DeoXLb1es90WZutO76Ma6rOfvKlRpkmPhNEF5oKYRFWH6oWv3ixDYJDVH0gNl/uUWmz17Sj0lhoF97G0M/NB9WTPAStnFZhBEABdt86bePM8VlezbFFXiGdgbLfaW9QXqtP/jz4ndnoEXc1O3gr3ybGi/CSrdN0k7Qw7y7SM6WwZ2yhkI9kN/Tlq2KzEwRKCEqq5oZmlv1vfl8vDFEEYjZBKuOVF5i2mkdzfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91Nz26/xz/sFrWPHwdlkVDYW0rUnPI+pKjFadjEfqZc=;
 b=eLcAUmkCMdvFlidimbKh64754I/1dRKVBsdBQVx8GvIMKiDYHKVUmSMA8zjxMSGOSekP/wRKKr9EWNiEVrGufKevKTTYH6A2Ks8ehEmWKhdAZuz9wu2nuLaQXCln6zP3o6hF5zyQFVfkql/mtB1TKqzN/ahWSrMkWlLUjInP048=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3709.eurprd04.prod.outlook.com (2603:10a6:803:1e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Tue, 12 Oct
 2021 11:40:56 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4587.026; Tue, 12 Oct 2021
 11:40:56 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Po Liu <po.liu@nxp.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Michael Walle <michael@walle.cc>,
        Rui Sousa <rui.sousa@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        UNGLinuxDriver@microchip.com
Subject: [PATCH v2 net 01/10] net: mscc: ocelot: make use of all 63 PTP timestamp identifiers
Date:   Tue, 12 Oct 2021 14:40:35 +0300
Message-Id: <20211012114044.2526146-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
References: <20211012114044.2526146-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR07CA0150.eurprd07.prod.outlook.com
 (2603:10a6:802:16::37) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.26.53.217) by VI1PR07CA0150.eurprd07.prod.outlook.com (2603:10a6:802:16::37) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.14 via Frontend Transport; Tue, 12 Oct 2021 11:40:55 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c13b39d7-0e16-4092-95f9-08d98d752726
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3709:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR0402MB370911AA21C45433B78B3114E0B69@VI1PR0402MB3709.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zsO0AkMT9OrAE7X6McjnA9DZY7MVZ06LX0yBkyI7yBv8i/Rwrgw5UJb4QftIqSzrc4N1RFN33sLABiMdoKAVanrO7OMVWwMnKJ70P20KBRCEzO7WWlRaaF5aV/Z8BNozNl47frJiGPbgAcKDhy2toV6gdtCChGt/zov5icIZ44WHfHaut2vP2jrPC5xKSIG/Yf3kcS4Cipx0erRJjnoeAD+e5c9IR44z6JqzCB+4mjbcsf7CKqvZvNkivPiLCAkTGSTxiUEePdsUbjhrWASBXi64zr8/hu1gtS+E1uVMVKmYlegC3xfMRjv6VfrUDmfpbaywX4W0OGYyXLwCSjT/KUnXjqE63pmp79HWa5Z3DofBkt6hgk3b725qBl3bqPdgjo4ev0mLbv90Xa8dLmCHBQwr6hCY072DTFY5UL70/Y191SNA+jrmI15+YYdBk/YL742S9ZsjI+bU4kiBnl27vVgHNFVFjHlSqueRCfA6W3ggRkCl6J/OaadyVrCSiqYemdk5oAkh8D1KyMNvS2S5noyQbHuNji26FGkUixmZ5Lf9y0COz3sX9lHZaxxnSvctFJnRz5o1Blsk+oQHzmQcyD09fa443DT9SEYbn4qevtqYNbbaCVOFiKjc2zGzEy2aw6EmYGgu/hcVQiwo05C7V7reyWe57ZIhlz9FF7Alrb++c91V0tUSTFMHyI57DJFkBAF+7VxLxLEHiXqsvhO1SA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(86362001)(2906002)(83380400001)(2616005)(44832011)(38350700002)(38100700002)(956004)(508600001)(52116002)(4326008)(6486002)(6506007)(66946007)(36756003)(6512007)(1076003)(186003)(26005)(8936002)(8676002)(54906003)(110136005)(6636002)(5660300002)(6666004)(66556008)(66476007)(316002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?am7BrqXI5JG+Kt8opIpcvwd2wTYNWj1TVYMkQvM59j3uOzq82Nhxh4sZaHIn?=
 =?us-ascii?Q?rCDmyqlR6vRGd4XZa5zrTDvEB4XAPkHEOuhR/BDOKhj2/srC9uZxhzYHpVK8?=
 =?us-ascii?Q?xFG0wu3u0mkvq+ie3b78RzNzkfmlvrcIfc0A5n9oc1x0rCN6EZ6slgmy6+J2?=
 =?us-ascii?Q?jWdTh5Tn4GCuA1IBwN7Vn/M96Www1KoxP6KlNVgxnrE1wnGAzlmeXSpMf0EV?=
 =?us-ascii?Q?vhi16kPSXUskUxD7w55wEnht+uukON2Vd0HwxvFOj7XvscCfNZeLWKC7Two+?=
 =?us-ascii?Q?bZUUX4RTU1aZVRte5WfPiI+ciUWt6g/EMKANucCxQjkYk7UU42eVSPrAc2c8?=
 =?us-ascii?Q?angE/UCxdW7BDQ5eJHyqkihpejGB84ipVAewPZ/JTIcB/HGw2zDnOOMP9wYi?=
 =?us-ascii?Q?qqjUfAwBhjQzwYEXZvz9bEWWHjXCXuUGIygnlIDJ/TW0qbpKYDjIpomtf/h+?=
 =?us-ascii?Q?l4NCBNNUo1s3888YC8MrGAdt3kaAfZyv/15RFdeqrp0Mn8whBcjXLs9WtKWo?=
 =?us-ascii?Q?fwWMeLoLsn7s4etNL5QekJVEJIKQ2TYRAe52D73AU2CLDKVTrlSh5L/K60I6?=
 =?us-ascii?Q?Q4mg1AfcgWl/v4nzMUGJeui6D5zJbBDlGgXOr0eJqBvA6GKWm0JUYDTagMOB?=
 =?us-ascii?Q?bbxr3QSibsXPd1teJ01W+PwXujRKOVKjAYabHC3OhHfRQYvMwBkP/wMyLZRj?=
 =?us-ascii?Q?6ezBh0FNwfhl/VPnPExntZFobsUaIT4eUO/Q9gXiYQg5n76ula+8nG78pKyk?=
 =?us-ascii?Q?hElxPr+L3S2i76beW0tf5MJ2ml2xMNg4E4IBXJg02dcvntwugGCldxtDIdf3?=
 =?us-ascii?Q?maJMm2w/tmqujofhJGV6IEbJTeU8WCY25pnY1nQvqTpy/my3B1mNbiD/GFYk?=
 =?us-ascii?Q?72Sixf2Kv2yr5NKZWmRqVVvkSpz52CBV2DiRUCg6f3s5SNGhi2M6HVsBjOdH?=
 =?us-ascii?Q?nGpnGl7nAFkFeLABu4yxDrHzqLYsFUYxPmfI5Adzz4eCb2cAax82bUqORnDP?=
 =?us-ascii?Q?NajPb6XO0+4k7CcebzFnQ6Fe3+ZQH2veFbOrz/XveDur5IcliF5cZnth+Tdm?=
 =?us-ascii?Q?AORbmXFJ0Y9cTk+n04WqgEHNVSgx0lbNSEHJgEZ4rpNFwcJ7MHjGyh9vP4sH?=
 =?us-ascii?Q?RisKFJvb2UL/laQhxY3LmepzZ0pVRJnslTiHjJ3FUqUXp89MFhkmeMlJLSBR?=
 =?us-ascii?Q?Fbc+cA4fMLNJJU0oyP3Cf/qnMpdVfVnfZ9k3V4G3SXBDMa8GfOJBC2uSZvht?=
 =?us-ascii?Q?8Qe2buthOc7OMR5+KnPAaOP1k3fPg8BP/YMCmMk6BaQUA04hli6Ummg1vJiU?=
 =?us-ascii?Q?kgiuconmNlbvXXEwAoOa3WoY?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c13b39d7-0e16-4092-95f9-08d98d752726
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Oct 2021 11:40:55.8605
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zpMGuOlVHb9DlgD9N52vND+VbNqzDvxIxxVSIP37lV7vtIhZ/NYoC7QHRhyc8kl6r3W2XjzJUDkws7MGbvHIcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3709
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

At present, there is a problem when user space bombards a port with PTP
event frames which have TX timestamping requests (or when a tc-taprio
offload is installed on a port, which delays the TX timestamps by a
significant amount of time). The driver will happily roll over the 2-bit
timestamp ID and this will cause incorrect matches between an skb and
the TX timestamp collected from the FIFO.

The Ocelot switches have a 6-bit PTP timestamp identifier, and the value
63 is reserved, so that leaves identifiers 0-62 to be used.

The timestamp identifiers are selected by the REW_OP packet field, and
are actually shared between CPU-injected frames and frames which match a
VCAP IS2 rule that modifies the REW_OP. The hardware supports
partitioning between the two uses of the REW_OP field through the
PTP_ID_LOW and PTP_ID_HIGH registers, and by default reserves the PTP
IDs 0-3 for CPU-injected traffic and the rest for VCAP IS2.

The driver does not use VCAP IS2 to set REW_OP for 2-step timestamping,
and it also writes 0xffffffff to both PTP_ID_HIGH and PTP_ID_LOW in
ocelot_init_timestamp() which makes all timestamp identifiers available
to CPU injection.

Therefore, we can make use of all 63 timestamp identifiers, which should
allow more timestampable packets to be in flight on each port. This is
only part of the solution, more issues will be addressed in future changes.

Fixes: 4e3b0468e6d7 ("net: mscc: PTP Hardware Clock (PHC) support")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v2: none

 drivers/net/ethernet/mscc/ocelot.c | 4 +++-
 include/soc/mscc/ocelot_ptp.h      | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index 559177e6ded4..a65e80827a09 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -579,7 +579,9 @@ static void ocelot_port_add_txtstamp_skb(struct ocelot *ocelot, int port,
 	skb_shinfo(clone)->tx_flags |= SKBTX_IN_PROGRESS;
 	/* Store timestamp ID in OCELOT_SKB_CB(clone)->ts_id */
 	OCELOT_SKB_CB(clone)->ts_id = ocelot_port->ts_id;
-	ocelot_port->ts_id = (ocelot_port->ts_id + 1) % 4;
+	ocelot_port->ts_id++;
+	if (ocelot_port->ts_id == OCELOT_MAX_PTP_ID)
+		ocelot_port->ts_id = 0;
 	skb_queue_tail(&ocelot_port->tx_skbs, clone);
 
 	spin_unlock(&ocelot_port->ts_id_lock);
diff --git a/include/soc/mscc/ocelot_ptp.h b/include/soc/mscc/ocelot_ptp.h
index ded497d72bdb..6e54442b49ad 100644
--- a/include/soc/mscc/ocelot_ptp.h
+++ b/include/soc/mscc/ocelot_ptp.h
@@ -13,6 +13,8 @@
 #include <linux/ptp_clock_kernel.h>
 #include <soc/mscc/ocelot.h>
 
+#define OCELOT_MAX_PTP_ID		63
+
 #define PTP_PIN_CFG_RSZ			0x20
 #define PTP_PIN_TOD_SEC_MSB_RSZ		PTP_PIN_CFG_RSZ
 #define PTP_PIN_TOD_SEC_LSB_RSZ		PTP_PIN_CFG_RSZ
-- 
2.25.1


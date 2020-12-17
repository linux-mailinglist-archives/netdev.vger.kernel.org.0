Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 782442DCABF
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 03:01:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbgLQCAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 21:00:30 -0500
Received: from mail-am6eur05on2048.outbound.protection.outlook.com ([40.107.22.48]:59936
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727230AbgLQCA0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 21:00:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PZgIfKO0IChpTNGznMQQkFBskjO/shNBLvaOmKxEltvVRN6YH/AtaxlJTwvScomL3fvsHEmi5JfLtTCyl7bzCfu73qrB8u6ynAKbT1XplYZY6XJl1B1nV4GJTgY2TwGfBQ8//zB7hqyjwdUfaXiVeZhvjui7kMxIIzVPVJg3BFJuVkW4ufyVc30L6dchPO77eeubdCQ7xhAyIm4bvHx7m6Nus6Rpl0cS92O3gDl2/CU75utpDRIe/O+OF8P1z3qtCRsmy5bizfoPL3HqObVKE4DO5fMfl+Rf2vItivok5kKg39Vg2pngNBEaS/BJuPXfRIvm3PR8/f2clGg0LSBKog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccZMtTqB+Pbud3JD6fI3xmO3GmtK8uMrABxLTkQyCzw=;
 b=CvLzYGBo4OS+k7BuPG7vWjV8xI0EWiruTxVoSBWQgCbfwJYkSHf1eDWB78FyHqtWIHiRpoDwIoIW6quzMXfeN4st62ITGU0B2lpajW1zUmJ21swmLZ8DQyr4rO7SsLxN+XIvsitygAr4w6MRb3N2QzLsJnLKlemuWzXpaZWJAgXZmNNDQL13M1/OiaokpGicAbrYdrFvE98Pw852ifnVBzXLNkzRPS7wXJtBlho2sEtbJysqFuzCyto55UKUdLs/OuglbMvrIW2D19Mk2tizcgKEtNrF3tKbmAleH7s4e6DX/XjDnJj5Y2TGfgn/vWt5OczqgdSdNxyLeyu38ezL0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ccZMtTqB+Pbud3JD6fI3xmO3GmtK8uMrABxLTkQyCzw=;
 b=fWfNxR0yepHdpIckUOgSzN384yUaf04SrkX7ZsobjpnbisyZ77dd1wLhcI657HfzwQyFpl4Ov6YIqMDoQU30qRwZHL7qjfMPHTBfk+yj7NSClhat+e7xiA32r/ki897l6GohNytbsS05zgpGcncj6V+0pPmj63jaScuReVbO3aM=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR04MB6943.eurprd04.prod.outlook.com (2603:10a6:803:13a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.17; Thu, 17 Dec
 2020 01:59:07 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 01:59:06 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vadym Kochan <vkochan@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        Jiri Pirko <jiri@nvidia.com>, Ido Schimmel <idosch@nvidia.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Ivan Vecera <ivecera@redhat.com>
Subject: [RFC PATCH net-next 4/9] net: dsa: remove the transactional logic from ageing time notifiers
Date:   Thu, 17 Dec 2020 03:58:17 +0200
Message-Id: <20201217015822.826304-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201217015822.826304-1-vladimir.oltean@nxp.com>
References: <20201217015822.826304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: VE1PR08CA0028.eurprd08.prod.outlook.com
 (2603:10a6:803:104::41) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by VE1PR08CA0028.eurprd08.prod.outlook.com (2603:10a6:803:104::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12 via Frontend Transport; Thu, 17 Dec 2020 01:59:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 19f56514-3dbc-4f24-a32c-08d8a22f5668
X-MS-TrafficTypeDiagnostic: VI1PR04MB6943:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB69439C6A252327D05AACA67CE0C40@VI1PR04MB6943.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ydz1Y1Qr30OwJU1eiIEtntxVmEiG0M7iNf5/ByqkeI+wgBdY9WN9BqSpkLcyySI/7aldTW3UL6+dz0Gd1sWdoZCD4ydkNaksPAPUMxnh5pM31MF8bPpqz0d/VvDo/iAsfo1ggyleX8bvIH1Nm6bLGs2V1yJ+zGom1crsij1gdni3Hk4heMEPIFcZFONmD5LkSR03O8w/GyJAWibWMX8gyQx9TUnjos4zQUj/7Nd0MdcrBX+XQMDratvu641A8HUQFAAUieoZiLFIhPRt9KRrffUTZdYDvm2OF6HWAA9tN32RNXxPjfgdzDXMdS24Q3om3dJWnpLrgtTUq+09D+/TVzlc9WAkr1uQjn9r2PG/hHde0N20cGCNoWnbVJF7gUcv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(366004)(39850400004)(396003)(6666004)(6506007)(16526019)(478600001)(956004)(2616005)(26005)(7416002)(83380400001)(36756003)(66476007)(66556008)(110136005)(86362001)(1076003)(5660300002)(66946007)(316002)(186003)(52116002)(6486002)(54906003)(69590400008)(6512007)(44832011)(2906002)(8676002)(4326008)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PiMx51uo7pkIdaawK0TtettCaMAGKgPY8lUoWQ4oouHPQaC88ULOUarhQJiW?=
 =?us-ascii?Q?C6Q7H8hVvZ5+YFm/yQ3U6MNTpL6mN3c2Cr3dlDZy1E9rY4etcZ271u9GlRUC?=
 =?us-ascii?Q?y05q7jbz1kWX9V9sQcRNm7poY9DNocI9lPZCJM202s36in3jAGVik3YXML/W?=
 =?us-ascii?Q?XyPQF6HjRoEsh8E1QWbCZAEQgKEj9uxOKY+2K0VaRs/uBRC8p/IDZIm26FA6?=
 =?us-ascii?Q?qCog2Lk/1I7jmW4bsklpuwtelw6F0BZt6YPzeWXsMvnH1eP5Ayt1VBNJmS13?=
 =?us-ascii?Q?cR0h/B+T8Ka1Zs7+UCg5LbpguRU4G7lk0ObkG+m5cw1wC5mIe0xCLemiiash?=
 =?us-ascii?Q?z8jHNnaSSn6HTceWxpCBsxpuBxWeFh4LGx4RUlUl/yGOi3lnUZ0hkmuh08Fx?=
 =?us-ascii?Q?u19y8Xq0Lv1HTmFpFZGq8/vOIiW5ftvTVTzbpgSAOybYrJeGOoxr15q6HT7V?=
 =?us-ascii?Q?iUYJBdwj8YrEmtyvKEEMLboogIGfN2MVOhSBfAkhY4LDIEeQ7nzKoXjjMO/Y?=
 =?us-ascii?Q?FEKb5iBbMyAAcCde11EKuhLcwvJXLvDeHZoM8CRCAfR5kFoXlw1SA0MTCn28?=
 =?us-ascii?Q?AbK5t1x9VnkzMkAfwFemIsm/AITc1y7PgqwaXp30fb51ZPnAAH5M8lpzLALg?=
 =?us-ascii?Q?mxrYKhrwk1o3wlys84JYfRDyZHs25cx64IxNFV1+/V7IzIyy0f3nL7GSM9eP?=
 =?us-ascii?Q?/chbPVO7UwEr0F8ee6608ioofLHSMyf6OQYQOzwELaWU1la4e8yDJQDvXMhq?=
 =?us-ascii?Q?QYOzJPbwrEijepZ5eFHQTOSPqK/cgDxTvlU16T6FG6TENfSC2B0RTc1lbPWc?=
 =?us-ascii?Q?1tg98WcTIgUbD2KpcP+Oci50DIUTn+smME1qfRwi84SEzElgmBNqAbY05csY?=
 =?us-ascii?Q?JtsfZatDgUk6FyZIW7kFxwHxkSVw+xhqgX3/rLsqAH6cHhyIkTuaepylOQNI?=
 =?us-ascii?Q?LOCRuSOA3kypTlwgkq31jZHAutRA+KOJxU8djPY8p4JE/f4bfuNYMptEhFHx?=
 =?us-ascii?Q?RzQ7?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Dec 2020 01:59:06.8886
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-Network-Message-Id: 19f56514-3dbc-4f24-a32c-08d8a22f5668
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /ZlZnqZBQ571lIOFUvpsXsyxd3hq0Zo9I5JQNbe4LmmmQHd6Lj9kcBb6GhHtiGI3daUGRFDQBIJRYOJnRl6zbw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6943
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the shim introduced in DSA for offloading the bridge ageing time
from switchdev, by first checking whether the ageing time is within the
range limits requested by the driver.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/dsa/dsa_priv.h |  1 -
 net/dsa/port.c     |  6 +-----
 net/dsa/switch.c   | 13 +++++--------
 3 files changed, 6 insertions(+), 14 deletions(-)

diff --git a/net/dsa/dsa_priv.h b/net/dsa/dsa_priv.h
index 54e2ee1a2131..90a879322b21 100644
--- a/net/dsa/dsa_priv.h
+++ b/net/dsa/dsa_priv.h
@@ -29,7 +29,6 @@ enum {
 
 /* DSA_NOTIFIER_AGEING_TIME */
 struct dsa_notifier_ageing_time_info {
-	struct switchdev_trans *trans;
 	unsigned int ageing_time;
 };
 
diff --git a/net/dsa/port.c b/net/dsa/port.c
index 62f38a36386f..b39a5eebbe27 100644
--- a/net/dsa/port.c
+++ b/net/dsa/port.c
@@ -310,21 +310,17 @@ int dsa_port_ageing_time(struct dsa_port *dp, clock_t ageing_clock)
 	unsigned long ageing_jiffies = clock_t_to_jiffies(ageing_clock);
 	unsigned int ageing_time = jiffies_to_msecs(ageing_jiffies);
 	struct dsa_notifier_ageing_time_info info;
-	struct switchdev_trans trans;
 	int err;
 
 	info.ageing_time = ageing_time;
-	info.trans = &trans;
 
-	trans.ph_prepare = true;
 	err = dsa_port_notify(dp, DSA_NOTIFIER_AGEING_TIME, &info);
 	if (err)
 		return err;
 
 	dp->ageing_time = ageing_time;
 
-	trans.ph_prepare = false;
-	return dsa_port_notify(dp, DSA_NOTIFIER_AGEING_TIME, &info);
+	return 0;
 }
 
 int dsa_port_pre_bridge_flags(const struct dsa_port *dp, unsigned long flags)
diff --git a/net/dsa/switch.c b/net/dsa/switch.c
index 54f8861e937e..39848eac1da8 100644
--- a/net/dsa/switch.c
+++ b/net/dsa/switch.c
@@ -33,15 +33,12 @@ static int dsa_switch_ageing_time(struct dsa_switch *ds,
 				  struct dsa_notifier_ageing_time_info *info)
 {
 	unsigned int ageing_time = info->ageing_time;
-	struct switchdev_trans *trans = info->trans;
 
-	if (switchdev_trans_ph_prepare(trans)) {
-		if (ds->ageing_time_min && ageing_time < ds->ageing_time_min)
-			return -ERANGE;
-		if (ds->ageing_time_max && ageing_time > ds->ageing_time_max)
-			return -ERANGE;
-		return 0;
-	}
+	if (ds->ageing_time_min && ageing_time < ds->ageing_time_min)
+		return -ERANGE;
+
+	if (ds->ageing_time_max && ageing_time > ds->ageing_time_max)
+		return -ERANGE;
 
 	/* Program the fastest ageing time in case of multiple bridges */
 	ageing_time = dsa_switch_fastest_ageing_time(ds, ageing_time);
-- 
2.25.1


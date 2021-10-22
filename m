Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF2A9437CBA
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:44:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232324AbhJVSqv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:46:51 -0400
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:37921
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232133AbhJVSqt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:46:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Fr/wsPFX3ufm7I6relE9Q4NUAnJCz5kulU6LBk98flO8y39SVcO1FCF7NGhj703Rm9Ym9RcQ4eRiuALZsvjp5lbYbti1HKg/IpLz3gV0wRVgUXkNue1bXGhH5sgwd3i/VYRzzL4WDMKfIRqz5krcV0P/uIBFT+IwtYCzvHw5IAIzbd85/nznQH+sPf3+glAOf3mikH4s4RF53rrCwarx4cKANzmpeG9ODVUmUNM9/mTF2Ag4EMMsIRx9aKiwaut325nIFGN7vNEoBoCIMyLiRl1U9bcUuj6JsmuOEYbN0qEAbjwJr2j8CKpILMeiKpsxqnzj4JWrZbKA9fSLIaOkNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sBdC782UZkM/yWhoDg+6wYhkF5/RenlaAHFVNcRwwo0=;
 b=K+rGOdeq9mq9x2Qul5FqwpDW4VTl9dPq782aj9upJy1Y1p3xI9pLux5rLM8atWpLLc4taaiIwRXPwSaQyDkL39ik9Rs/OW/G0RBNUlbQgLGFtfUKwO7BwWvYy+zcodv1dke/EsiePf4mBqSZFqqC1xXUXSbYeTNMlKtmjNhWbF/pMTFLA0S6wj02XIg0PJT08pr/klzETrGe5KXndC89ECjC3BdK7gXMQx6hd8hV+EMds4nlw7HaWhak+C1utIfJ5cZlmSahYiH48AprKx6neNmSFX73HAtvcHNzMHcEENMtKTn2uebnunHIvIYHkWEItF0eDQ/S58b+lKAGwQoVJg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sBdC782UZkM/yWhoDg+6wYhkF5/RenlaAHFVNcRwwo0=;
 b=iRp3/hqCPK4qordAXyKqhYWVZJT0axwUsBtqk7rNGTd4YBH7igu+mr3p2dipSWcdmi4+13E54Tuz80D4cP75YcSGuTZa5yC0935hOEdkg9hUaJvBcs1rIHVUrkHNDZ3C9VEFh3+T5RbY2o4rDU8xDXo79wrpkIuszZr5Vf97iAQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 18:44:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 18:44:30 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        UNGLinuxDriver@microchip.com, DENG Qingfang <dqfext@gmail.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Woojung Huh <woojung.huh@microchip.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        George McCollister <george.mccollister@gmail.com>,
        John Crispin <john@phrozen.org>,
        Aleksander Jan Bajkowski <olek2@wp.pl>,
        Egil Hjelmeland <privat@egil-hjelmeland.no>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: [PATCH v4 net-next 5/9] net: dsa: lantiq_gswip: serialize access to the PCE table
Date:   Fri, 22 Oct 2021 21:43:08 +0300
Message-Id: <20211022184312.2454746-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:44:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 48ed52c2-39e2-48cb-3f1f-08d9958bfb44
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862626BE4918CA10DDCAB48E0809@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yf4bLSTLyT23lDDUKcHzaq31p5Twnmv0KqnRMQxRo2Pv8cWFg7dSuxvpK8i8zEY+UlmAXgyIBFKasma2GXFYjbA498y7atoXeCU5i1ewxqPEzmI1VoWTHgCCWKhSJG+weL1ccD36iQqlYBEe6vgCjVn/uCTTAa5Osc+FMierHsL0VXICQR7rz6KyUAitLTHsk+ThxuvPmMGi/6ieoS8FZIPqsCYdKuX5+smbU5bZ42LJv/Kj8cpZpVQ/dowCnS8fJFBzsEEFYIGebJuizsOpiH7KBws+GMqwgqZl0WvT7mnCAnoHjqXkpJjMgeUKj0R4OheQ2TVrCrWFH5GSqVqGFfjF0Bbsh7/ooNAgB+yDCVyjU+VWZCSL9FNOQ7BwoUJxnzVXhIRRn+BX9A1lk5AiZDKTO5dDrV6H3q4DDLnv1TE8+iokPTkphkgf7MnDQ1OD25S38bNJx4h1RKrrW/rbU9jUJG7Ftk7jHMDe+2IBTU7YbFIPuiMqB664hyFMECNSggouKn8N+XlLz6ubwtpiK8kudetwkDY/ycolRpQ6qaHVplJO2idn+4lZnh7qgXX7+10CgZJBc8cJmHBpEzdVV9iY3FR22GlhhliHoWPtBC5ErW0pe2u/hVT3vw2WqarqdstQ4+GCZf7PuvW/lAzwM56XQ1MDxY1cMDAK+o9UrH2leIj+izcenatjIyxxHyh+I6flDD4oPYtKh+nufzCeRA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(2906002)(38100700002)(83380400001)(52116002)(508600001)(1076003)(36756003)(6512007)(6666004)(54906003)(6916009)(86362001)(6486002)(316002)(956004)(66946007)(2616005)(44832011)(4326008)(186003)(7416002)(6506007)(8676002)(8936002)(26005)(5660300002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3xl0Hi7n0/oydW7/ESVZtx6bHhStljGWRdfvsyLYrFNI4wRAjzi48Ko+2wGA?=
 =?us-ascii?Q?WYdti3MD3EUUjuU7WtFxX4HJ9UUaw5V5Hr+YOSkcR4iDjXzdzFX1ZgtadxMT?=
 =?us-ascii?Q?+hJiwBBX7BI6gP+ycm4ZsxSbpJwGKSbKGPz3bLsI8lm0A+a+m6yp2k1gXRBH?=
 =?us-ascii?Q?A+J/y5e7sLpG//kwTxwHYMgP0GOLxH4EtMHEbU1/pGotr5rrvvPtF2HZM8si?=
 =?us-ascii?Q?UQe1uObeWCxM3tMDtQnisvaSxh0pRTMcdNg3RqIf1jWtCxjy8OFN10aXXKOr?=
 =?us-ascii?Q?IM830Tl6bNwLcSQUqXw5YpNRKZ4Ftr2k988FAzfZFQmkSsdVR4pSO91seO29?=
 =?us-ascii?Q?+U+I3KNli33ttahxFOwczDWJ49OkFwkYIWACZikK1DvEsqO2rSPxln6XlUv2?=
 =?us-ascii?Q?vbfrqFeHF/ZzRhTha4VA7/N3kNkjjwjdNU54dLZZYb7QpQXMaPFuqp0yUf5L?=
 =?us-ascii?Q?+FCzsVLD/5poTMKNfdFQ4DUfA2gmRs3hdA1PdcH7zip+SnPr9T05/ecbMRXp?=
 =?us-ascii?Q?6nHJgtZpSHKEhRsGKOA05eLI1Cxvn6zFYaGO84N4jlPb5i6ipok15eR7tf1e?=
 =?us-ascii?Q?2jB+t5lCaXE5dOdMob5LiLpvo+BzKVNDYdz2K9b/s+rr+jeA7pTN+0rRG6DL?=
 =?us-ascii?Q?Vm23Cg9aSU0s7v769WtSvU852AihyfdqAuvWpjIofVyK5ViLVo+D3Owu3tjv?=
 =?us-ascii?Q?gVOsCbOF7cvkzvioba7rwKa5UyonMZOA5K8+pI2Oxy09rGdv6GsxR5Ng/eWW?=
 =?us-ascii?Q?2yPfdKm4Ar7SQYuSXKSThndQph5tVtxBkjM9ix2G2jjrbbsCv4t5Mm5UElWN?=
 =?us-ascii?Q?hOWBqCVAAulQ0i+zMKZL2/BVQkp/37wIkUGBg4K0Gdim63EPfEeqUmBj640F?=
 =?us-ascii?Q?0g2MVd0lBJdvv0c5NWq+tZRnHd82h3W5Zv0xT8rii+JXDDy1JfjWfSvzCW0l?=
 =?us-ascii?Q?WANjNEm+WIq8DsngbFvYTFR/uHbYwZ98oaLFX2loicnXzfuEkudrRGpIAt0R?=
 =?us-ascii?Q?ObkrXV4K+WahI4LlY7a8+Y/CvFBlP8kiL5OwmjzJWUWW2Q5zb5EatezLw/qu?=
 =?us-ascii?Q?xCA3hRmExGLYyt2vXZcDtR1IbC360pjVSsmTRLZwYC2ETIZLjSbDqIj9ahh6?=
 =?us-ascii?Q?Yd0UXUguAz4BOuP90wHrg6ixXooAnws3xncy0H+kEbSixAOLkAnCm3KKRhGk?=
 =?us-ascii?Q?/fJPMfN5RU8FFfw9R8VJU/Mackxtbx+TTXlKfR5rQzUF9JJBq2Hvi5DT+w6L?=
 =?us-ascii?Q?2rp2jJJmACOVfgPjVTFRv7aXA5PRCwaOM21W4xRpa6hgMI33xBvNCm4OjX1l?=
 =?us-ascii?Q?5DNEJWpUWyNbjP2HWyzSBGTThVGtg7kjFjNNJHobhgumwtrvD68FuGuti4P6?=
 =?us-ascii?Q?PPL41+p7ZIHeyduVGcXnFLDd2aDHClQtBoRbfNoTQhZ7YEmbTPcadTbDk5Xd?=
 =?us-ascii?Q?tW5MMlI9ObgsnUO4gKPdx4Yze3HP62BO?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 48ed52c2-39e2-48cb-3f1f-08d9958bfb44
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:44:30.0061
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Looking at the code, the GSWIP switch appears to hold bridging service
structures (VLANs, FDBs, forwarding rules) in PCE table entries.
Hardware access to the PCE table is non-atomic, and is comprised of
several register reads and writes.

These accesses are currently serialized by the rtnl_lock, but DSA is
changing its driver API and that lock will no longer be held when
calling ->port_fdb_add() and ->port_fdb_del().

So this driver needs to serialize the access to the PCE table using its
own locking scheme. This patch adds that.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v3->v4: call mutex_init

 drivers/net/dsa/lantiq_gswip.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/lantiq_gswip.c b/drivers/net/dsa/lantiq_gswip.c
index dbd4486a173f..1a96df70d1e8 100644
--- a/drivers/net/dsa/lantiq_gswip.c
+++ b/drivers/net/dsa/lantiq_gswip.c
@@ -276,6 +276,7 @@ struct gswip_priv {
 	int num_gphy_fw;
 	struct gswip_gphy_fw *gphy_fw;
 	u32 port_vlan_filter;
+	struct mutex pce_table_lock;
 };
 
 struct gswip_pce_table_entry {
@@ -523,10 +524,14 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSRD :
 					GSWIP_PCE_TBL_CTRL_OPMOD_ADRD;
 
+	mutex_lock(&priv->pce_table_lock);
+
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
 	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
@@ -536,8 +541,10 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(tbl->key); i++)
 		tbl->key[i] = gswip_switch_r(priv, GSWIP_PCE_TBL_KEY(i));
@@ -553,6 +560,8 @@ static int gswip_pce_table_entry_read(struct gswip_priv *priv,
 	tbl->valid = !!(crtl & GSWIP_PCE_TBL_CTRL_VLD);
 	tbl->gmap = (crtl & GSWIP_PCE_TBL_CTRL_GMAP_MASK) >> 7;
 
+	mutex_unlock(&priv->pce_table_lock);
+
 	return 0;
 }
 
@@ -565,10 +574,14 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
 	u16 addr_mode = tbl->key_mode ? GSWIP_PCE_TBL_CTRL_OPMOD_KSWR :
 					GSWIP_PCE_TBL_CTRL_OPMOD_ADWR;
 
+	mutex_lock(&priv->pce_table_lock);
+
 	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
 				     GSWIP_PCE_TBL_CTRL_BAS);
-	if (err)
+	if (err) {
+		mutex_unlock(&priv->pce_table_lock);
 		return err;
+	}
 
 	gswip_switch_w(priv, tbl->index, GSWIP_PCE_TBL_ADDR);
 	gswip_switch_mask(priv, GSWIP_PCE_TBL_CTRL_ADDR_MASK |
@@ -600,8 +613,12 @@ static int gswip_pce_table_entry_write(struct gswip_priv *priv,
 	crtl |= GSWIP_PCE_TBL_CTRL_BAS;
 	gswip_switch_w(priv, crtl, GSWIP_PCE_TBL_CTRL);
 
-	return gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
-				      GSWIP_PCE_TBL_CTRL_BAS);
+	err = gswip_switch_r_timeout(priv, GSWIP_PCE_TBL_CTRL,
+				     GSWIP_PCE_TBL_CTRL_BAS);
+
+	mutex_unlock(&priv->pce_table_lock);
+
+	return err;
 }
 
 /* Add the LAN port into a bridge with the CPU port by
@@ -2106,6 +2123,7 @@ static int gswip_probe(struct platform_device *pdev)
 	priv->ds->priv = priv;
 	priv->ds->ops = priv->hw_info->ops;
 	priv->dev = dev;
+	mutex_init(&priv->pce_table_lock);
 	version = gswip_switch_r(priv, GSWIP_VERSION);
 
 	np = dev->of_node;
-- 
2.25.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FDF3437CB9
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:44:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbhJVSqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:46:49 -0400
Received: from mail-vi1eur05on2068.outbound.protection.outlook.com ([40.107.21.68]:37921
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232268AbhJVSqs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:46:48 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WbnM0yd50rz8l2zS5Zr19WQB/SFjd43rsFsN/fcNZKYF0A5LJqSoifLsVYFfpFMt5EZ/APsqk/8x/MRCP9kL3Y1cJoT5+Y4mK2REI8ATw8UtVd49bdkqYQ28/CuIaPWPCBaLgBX++fjyTXr3c0lURqKjHbRJOZhA1ibdS2IHG/xTi8AWoESX0YABtEyn37VsGXAe6xnU78a6ndmzcMRy1ubAyKxaCk1YnyoYZo+8lJPrdaCpqdSUIeoowINuZeJDX5HEoLEIJLNfTX/xS7mGFN32pue+bsLzpt85o1pZBd6L8semR+Jn+4Mu6Vz1otdTNW/9xtznu4UpJiEHknJFRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MF5Ws5yg2aXqzbaXdVSRiv4YVjJfi2LFV2+F8mWEnTA=;
 b=CE9tWs+FN1O777PUQhfAAjpJsKCe3xqyacRblqYEzWI9pE+HJNt9HTZPN5KiqVJGefUGZKS1TkccnbYlqkL255PLic1VGfp3VQ6hyp64qv2+iTITHU9USt03PFLHssD+qLdby+jbUsWjtWYNUyats1vMWq78+6JepoWak3m0WD6moYBkX4bviZ/g8xWptgA/1eJIFO4JnooaYUzcllbcCd42QmCvEqXB0ZdZI3PfNn6O/4Lxp9Z3jPG/kreBKKBRG0xvpiFhnpM9NB/4nGTlfat5b2yhGORoBip5pSrVJ5I5i1XZ5NX/rzVnpOChTi4+dmHjMgCO4GeXzQFxZC+8sA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MF5Ws5yg2aXqzbaXdVSRiv4YVjJfi2LFV2+F8mWEnTA=;
 b=XgPv7UmFuCSIdw9IbkL0oc8IFBYPNG+G2r3biYPAtLX2s0zb9JVpQMyeda1Av9beUJJ3+ZjQlKPuDRclYKfC4tGWi4nLYRz1XWz46QFpMJZ2lh6EWsGA/3rapZ9WaNqgTgXirpmiMqrmzMUuiXmW5fuFGj7LpReryN2qu2Nyqew=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 18:44:28 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 18:44:28 +0000
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
Subject: [PATCH v4 net-next 4/9] net: dsa: b53: serialize access to the ARL table
Date:   Fri, 22 Oct 2021 21:43:07 +0300
Message-Id: <20211022184312.2454746-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:44:26 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cb77a92-14ee-4a78-3a93-08d9958bfa15
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB28628DC96231F50C9A378237E0809@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DETjIUallUEY8JOyFtBOXtx9U25umonBHRXtN1PFgP0DxSdofn7Jks02TBzShqDCiSV2kKmn4PWko/rGFtmGEQ6MrqByzQgeigQCI2A6aREEkh/23pT8fnOvKFUfNevRoUeQNVjwMYSpYNrGHpC9TwA3uwQf3Idsc1d9xuUYkFenvJYNziDb6svmDJPT6sFvNWlq5MQjKvaN8W8gh5utmZOIaM7VgTwkO4hy28UL8dYuQp9bxANZnmo/IfHP3F8Xe/wbqn7otOkBRZajaHs6AXFJr8pNyQ03GI6vDh7bvgPfosbjHx1C2ijLtsYh2668Sc6EfLgcdYyiJaBHVH4gZuOZ0s0F52RyZJgssVlRzai6tNx8SjorgkNxNGYaNxJKUdwpTnoxI4IHane/5ndVXB7c9OVRctS9Yavb2Y4UIkn6817bFR5XDkGguHbcWNsWv5H0QAsv9p5KkpHtpWSTKMq4DjYC5nIVeb5EbAVpEJ4Mkc0+x2ewAE71QAvsjgGIIcu7H04J8YyyOXvkJdQzaUqdc0gg902GFpjWn+AEnNZ1Wbbqf2YU7HKHVjM3vvXLp9XIuXp1WtmfO13+j6DNtN5WJKUPrh8dgfuVQipzyaU8QnkwnsJ11xEHdR/O6ksjRYrQqC75QNw//d2LcDfoxPyO0PEocuRm+t7FIIXKY0+RM4OorNEaUakTHGPGoOlO27wINatXTU4Gi8cm9JJMDg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(2906002)(38100700002)(83380400001)(52116002)(508600001)(1076003)(36756003)(6512007)(6666004)(54906003)(6916009)(86362001)(6486002)(316002)(956004)(66946007)(2616005)(44832011)(4326008)(186003)(7416002)(6506007)(8676002)(8936002)(26005)(5660300002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2LTrLNIBMXpPxG1KyzQ+zve9+X/7xPeYK6V0jo/2DZyqBArIZk++bFIs2QhF?=
 =?us-ascii?Q?QauYQweQ9t/c11HgCBcO5a7h+tvQUucccOR1IB6rEiMtZu6oCIymh48TCPgd?=
 =?us-ascii?Q?OhIfQs37koIzJhUYBoPAVbyWKErQ5BdxBBU3j4O/swVdCGRb/75Q2eoRDNN4?=
 =?us-ascii?Q?G0ZDvWZtHnsvQDAyu0qVN4ujWEkVBJe11OfAPuXk47+YfWKUlwa4q/YFaJs/?=
 =?us-ascii?Q?are5UHvpQORT8oXg3BWzJeROWIX+sdWo8F3SWzUkW9SFENPtYTwyWWlE9HrW?=
 =?us-ascii?Q?Gf97H10zU/mWdbu9paP/zCi2ENmyzIhdYW2cFaKEnx/0HyxoqVMlQhgIOUyG?=
 =?us-ascii?Q?YI9Li6wWnaChtPBuQehhMYYOy7ZKMaHq9RTmOrxumR8eR/0M5f+ff2HCTUXz?=
 =?us-ascii?Q?cK+jp+6xrx2SQrDHWC648G26xS9CvgyyvxbVCZm6bWYbcL66fsBivgf4jgz6?=
 =?us-ascii?Q?+OafiYIqHQTHX2BIlK5lFobFGi+hIs0D6VNsd/K8gpB70tpKAjfTmC32SMY9?=
 =?us-ascii?Q?rtGpwJTCb1NKLuLSz7kRFYLtU99ERfO/uVtYnCiyIpoOmug+rzY05/mFT9sq?=
 =?us-ascii?Q?z1VBH+Og0Aru7TD5SHPSwFKlRyL6keWMst5Y7MyNZzeVwrtBLV5RaYV0TX4I?=
 =?us-ascii?Q?sVwpObWhMI9VPHfE46qmM7NkKRkYppbmxxGr17zPUhlV4QydRa4uta7jcov7?=
 =?us-ascii?Q?/2rkiFBNlSMLZNUEIaiPC9FWvkkjbLJH+Pv4tariABYhzRzMB/6ZidC8/9zT?=
 =?us-ascii?Q?tJ2/LSZcAWwZCV1WYKHQJwQDjmf1IWZ3jtK7uPHCsa36kqJDFrhbJoFx8pD6?=
 =?us-ascii?Q?jYiZkXii5h0EshqHft9SaZTD7jhpkZpN494SqbtxTVijDvCdZpcIIE7Oh/go?=
 =?us-ascii?Q?lt7qyD9eLF41peIC2NKfgHXkzxZMhAMjAkDt9bY8vOwWiigMsH9TOI1vdx/N?=
 =?us-ascii?Q?3yI2fYIaYAeJ71IzGr30+++ysjHQdGVlW462n7/30EOftbwr8cFHrWx1Hzsc?=
 =?us-ascii?Q?CRzm3KEAXA8FtrdyGV67U3OaIrVOZDvP61w+9MusDaGMmoxMVKIIzZF+vw3w?=
 =?us-ascii?Q?ZeEUQ0PYSaEn1Nvy+kDytBk6ZRBV8szCisF2cLT9JHuBzPqjwNoq7VOhKWC5?=
 =?us-ascii?Q?f9bssZ0emBlRiaeZz5VLHQhKKDODhfKXU1WnErbsE7dKWcORnBDYJcym/R0R?=
 =?us-ascii?Q?FkDo5YSdHRs/Q1pIVHNm7vh1k4meY1D3oVBc0FUqBDwKR5aJK52U0diOhp2b?=
 =?us-ascii?Q?B/mUNyeSwQDo3FDEY+CAsz6QwiOf1Ls0Yl3+5bk2oM/KmbjdTjgCSYjk7ddb?=
 =?us-ascii?Q?mud/L613L0+l6GOjhmt+tivj1BiMhuBoGDOruMYAK0Cu8Ydd+5PTwUMFeBc9?=
 =?us-ascii?Q?AI/RoT64POFCX+EK4xn1NC0VClMANDbZGN7bPbv31md0jtO9/4NHXlgNUFV1?=
 =?us-ascii?Q?YkAADGTt8wssA97XomL+VBo531+brAkL?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb77a92-14ee-4a78-3a93-08d9958bfa15
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:44:28.0402
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The b53 driver performs non-atomic transactions to the ARL table when
adding, deleting and reading FDB and MDB entries.

Traditionally these were all serialized by the rtnl_lock(), but now it
is possible that DSA calls ->port_fdb_add and ->port_fdb_del without
holding that lock.

So the driver must have its own serialization logic. Add a mutex and
hold it from all entry points (->port_fdb_{add,del,dump},
->port_mdb_{add,del}).

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v2->v3: unlock arl_mutex centrally in b53_fdb_dump
v3->v4: use __must_hold

 drivers/net/dsa/b53/b53_common.c | 40 +++++++++++++++++++++++++++-----
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 06279ba64cc8..9c80ca17b155 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1546,6 +1546,7 @@ EXPORT_SYMBOL(b53_vlan_del);
 
 /* Address Resolution Logic routines */
 static int b53_arl_op_wait(struct b53_device *dev)
+	__must_hold(&dev->arl_mutex)
 {
 	unsigned int timeout = 10;
 	u8 reg;
@@ -1564,6 +1565,7 @@ static int b53_arl_op_wait(struct b53_device *dev)
 }
 
 static int b53_arl_rw_op(struct b53_device *dev, unsigned int op)
+	__must_hold(&dev->arl_mutex)
 {
 	u8 reg;
 
@@ -1587,6 +1589,7 @@ static int b53_arl_rw_op(struct b53_device *dev, unsigned int op)
 
 static int b53_arl_read(struct b53_device *dev, u64 mac,
 			u16 vid, struct b53_arl_entry *ent, u8 *idx)
+	__must_hold(&dev->arl_mutex)
 {
 	DECLARE_BITMAP(free_bins, B53_ARLTBL_MAX_BIN_ENTRIES);
 	unsigned int i;
@@ -1632,6 +1635,7 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 
 static int b53_arl_op(struct b53_device *dev, int op, int port,
 		      const unsigned char *addr, u16 vid, bool is_valid)
+	__must_hold(&dev->arl_mutex)
 {
 	struct b53_arl_entry ent;
 	u32 fwd_entry;
@@ -1709,6 +1713,7 @@ int b53_fdb_add(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid)
 {
 	struct b53_device *priv = ds->priv;
+	int ret;
 
 	/* 5325 and 5365 require some more massaging, but could
 	 * be supported eventually
@@ -1716,7 +1721,11 @@ int b53_fdb_add(struct dsa_switch *ds, int port,
 	if (is5325(priv) || is5365(priv))
 		return -EOPNOTSUPP;
 
-	return b53_arl_op(priv, 0, port, addr, vid, true);
+	mutex_lock(&priv->arl_mutex);
+	ret = b53_arl_op(priv, 0, port, addr, vid, true);
+	mutex_unlock(&priv->arl_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL(b53_fdb_add);
 
@@ -1724,12 +1733,18 @@ int b53_fdb_del(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid)
 {
 	struct b53_device *priv = ds->priv;
+	int ret;
 
-	return b53_arl_op(priv, 0, port, addr, vid, false);
+	mutex_lock(&priv->arl_mutex);
+	ret = b53_arl_op(priv, 0, port, addr, vid, false);
+	mutex_unlock(&priv->arl_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL(b53_fdb_del);
 
 static int b53_arl_search_wait(struct b53_device *dev)
+	__must_hold(&dev->arl_mutex)
 {
 	unsigned int timeout = 1000;
 	u8 reg;
@@ -1750,6 +1765,7 @@ static int b53_arl_search_wait(struct b53_device *dev)
 
 static void b53_arl_search_rd(struct b53_device *dev, u8 idx,
 			      struct b53_arl_entry *ent)
+	__must_hold(&dev->arl_mutex)
 {
 	u64 mac_vid;
 	u32 fwd_entry;
@@ -1782,6 +1798,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 	int ret;
 	u8 reg;
 
+	mutex_lock(&priv->arl_mutex);
+
 	/* Start search operation */
 	reg = ARL_SRCH_STDN;
 	b53_write8(priv, B53_ARLIO_PAGE, B53_ARL_SRCH_CTL, reg);
@@ -1789,18 +1807,18 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 	do {
 		ret = b53_arl_search_wait(priv);
 		if (ret)
-			return ret;
+			break;
 
 		b53_arl_search_rd(priv, 0, &results[0]);
 		ret = b53_fdb_copy(port, &results[0], cb, data);
 		if (ret)
-			return ret;
+			break;
 
 		if (priv->num_arl_bins > 2) {
 			b53_arl_search_rd(priv, 1, &results[1]);
 			ret = b53_fdb_copy(port, &results[1], cb, data);
 			if (ret)
-				return ret;
+				break;
 
 			if (!results[0].is_valid && !results[1].is_valid)
 				break;
@@ -1808,6 +1826,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 
 	} while (count++ < b53_max_arl_entries(priv) / 2);
 
+	mutex_unlock(&priv->arl_mutex);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_fdb_dump);
@@ -1816,6 +1836,7 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
 		const struct switchdev_obj_port_mdb *mdb)
 {
 	struct b53_device *priv = ds->priv;
+	int ret;
 
 	/* 5325 and 5365 require some more massaging, but could
 	 * be supported eventually
@@ -1823,7 +1844,11 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
 	if (is5325(priv) || is5365(priv))
 		return -EOPNOTSUPP;
 
-	return b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, true);
+	mutex_lock(&priv->arl_mutex);
+	ret = b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, true);
+	mutex_unlock(&priv->arl_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL(b53_mdb_add);
 
@@ -1833,7 +1858,9 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 	struct b53_device *priv = ds->priv;
 	int ret;
 
+	mutex_lock(&priv->arl_mutex);
 	ret = b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, false);
+	mutex_unlock(&priv->arl_mutex);
 	if (ret)
 		dev_err(ds->dev, "failed to delete MDB entry\n");
 
@@ -2670,6 +2697,7 @@ struct b53_device *b53_switch_alloc(struct device *base,
 
 	mutex_init(&dev->reg_mutex);
 	mutex_init(&dev->stats_mutex);
+	mutex_init(&dev->arl_mutex);
 
 	return dev;
 }
diff --git a/drivers/net/dsa/b53/b53_priv.h b/drivers/net/dsa/b53/b53_priv.h
index 544101e74bca..579da74ada64 100644
--- a/drivers/net/dsa/b53/b53_priv.h
+++ b/drivers/net/dsa/b53/b53_priv.h
@@ -107,6 +107,7 @@ struct b53_device {
 
 	struct mutex reg_mutex;
 	struct mutex stats_mutex;
+	struct mutex arl_mutex;
 	const struct b53_io_ops *ops;
 
 	/* chip specific data */
-- 
2.25.1


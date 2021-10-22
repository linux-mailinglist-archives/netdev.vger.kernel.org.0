Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B12DA437BE9
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233738AbhJVRcf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:32:35 -0400
Received: from mail-eopbgr150044.outbound.protection.outlook.com ([40.107.15.44]:23297
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233733AbhJVRce (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:32:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mrIoUO5rlCDjTQAUxw7fbpM2l/ZfiXyov4hypXumlMSL1AjuW0lEiEQL2X7EJbCbiu1uO2TqoVhzMd0TkrP/Rc98MSgpx7aokgcPzKa2dVPLuPBJGEDEGQJ5Q/z3KfhCXA/4uRkOXB60KEG8MuPb5hnxfoOiHhpiBRnTttfexx4hf2PIO4iZN6cbRioY5hQbVbQB6kH68Bm4i0FhSddduPEhrmTwjCiphRHmbVYXZWIyPOC0e9CQl/RAJ+NFPj63VAQXICwNvNzKFSZcrPx0Va5bl0tVcBzjMKPyuOHqL75eTGUzy65BvMGbuuqi1wU6iUKxrQs7utHIwMKPiAqhEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMYoKB6OsN50Mj3dNTNpoeehqn9Se5oqGyB2lrzaD0c=;
 b=DcM4gpjyoI+NTPHw5qpb8v6AR6sMbFS16llhrfEc0TWLrzDHJN43kdcHobwPEpdbjIPK1Zj9b3lwWWP9GQSeYlNQiUoihaWx/ajlFodVclMldKVln1LvWI8cmAchVs0KBo8D1ZfPg0/5ITlZlQtZM/8D5oDD6IA9xL2w9aMcO9PRfgcGZPBAFWApXS059Snhpm3qKlhcPg8ZzVkIMZ2leL8svv8wBYc/99GQ27XdC43W4gOf67aIvGONiCsYnvzYId6i8yMmviVNshkzN+xz33a5c/kek9gkysykgF/SsAkRhFFD23X/iw40/8cbh9w3WQHqIAq9cSdXmP1Hhwoc/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMYoKB6OsN50Mj3dNTNpoeehqn9Se5oqGyB2lrzaD0c=;
 b=rFrMEAYSm/jeAuQIGwRn+A1Y+HIKhZwTnVrPywO/do5GGluzdDu1PL26K1y1z6oDlRXp36/mGSAj1Soav6qqFnmmkWlOU5CsT51LJ+AyfZHp/X+yaCmInf2/Z1TjY0nwDL05csV87iT5AlGhAUSPHJypP7689sUlL+NGSLTBFa8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:30:14 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:30:14 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
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
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>
Subject: [PATCH v3 net-next 4/9] net: dsa: b53: serialize access to the ARL table
Date:   Fri, 22 Oct 2021 20:27:23 +0300
Message-Id: <20211022172728.2379321-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:30:12 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0c25dd5c-6497-42dd-6e41-08d995819b6a
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504A8104DB7785B80967E67E0809@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cENGdttbX85VwX4D82CbT9YHcKkreYcUQDm7iLjMDzKE869ZGWY8UzCxlVks1AjGKFuj8u2hnEvoMDNyLaD8siP63lAeScZ8m0A73x/6O9r/KM2HpjXgzHS+bMgAIF7qnrMjym8hZlQgjwNq6yxu7VeZZxJRG4VOl61kj641PGC77oeFyErf8WPct16Sd1b+sVQi9ro/yFVRgISbVmDzCcfzncMVcfX2TsrFbU9mRYbbbtnQtBhDyfn03ciQZG02zorc5xcQ0u1t5TBK5ZefVO+zSZoNrQA14g27B96Sk4IdFA5Lo7K6CA4LHdGdOMBrMM4JvPke63PyELZ0zgiSUJBTnGEFelPiDONAERzopulY6eR36JgID//gTRR4ewmlI6uTxJ0WJezx1VzYJeISkPpREE1XAIX1UzbIKYNmnIx6RObqlkipl5TKTgaZJIREk5f0+ptMTkBSCBF6MZurV4SoH37apKHA/682Kcw9dSjz1AKG0NaBweQAb3S89MOolOKK8wKxbvfXiHd0S+WPJV5bbUW7GVrY60AiZnJT/Fe5c5M0+QYOiA3WuwAgxGpQs/0NXzXRU1IOQ1vgosF/cCwTES1NIlCuXVz+zShv9kUQXfAjTRS4+c5ZgKX5gmKjJzoS4fwRM4P4eftvgzBAVrqkYWlYlntoDvqe5nD9oWrUsLCsBEsIAjIimSN8PA38MXohWv9YC5z2B6WFuhR9sg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(6506007)(83380400001)(4326008)(6916009)(52116002)(66556008)(38350700002)(38100700002)(66946007)(44832011)(6486002)(956004)(8676002)(2616005)(86362001)(36756003)(8936002)(6512007)(26005)(2906002)(66476007)(5660300002)(186003)(7416002)(316002)(54906003)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?2YaW1fTpwg6wOmDyLs0eP8Wq64dhbiWOz3EZ1Ckvz5Rvq2NDe3QuxwsFiiz6?=
 =?us-ascii?Q?zeEObLpuiTKK1tNCK6JHGEH9sXQbmnJwJ2WTjaDiv+qTR9zTYkh0nVjlh9bY?=
 =?us-ascii?Q?btQcmpBXWDvgMiQAqBlNeT5exekIKJ9cnfCSnBUUtDAda9enqe69i2cBufj8?=
 =?us-ascii?Q?aJwZIjtCvzT2kLrFUDUUsWLEV/TI0eoLYOFKHEjypM7I+woGUu7UneUtE9lv?=
 =?us-ascii?Q?FbPbZt5v8fZhLxi/ItrUzEvQtjgGOr+eABuoKAatcUMUTpgApQxY7HRlTrk/?=
 =?us-ascii?Q?l3EvuUf6Yr93XXT8YYrSlRndnfi3mAAuz+t3mf3yTSxbRW/p/xGsrH+zaDo/?=
 =?us-ascii?Q?N8qQA4HR3PIecOEC8v4AvNJr0RdwEJ0q891IinxAfWbzsTS4QIEvcjwnxcme?=
 =?us-ascii?Q?cB7axcXPtiMLGt/bBGWHun10+F3Ym6rYGR0l+ewyUPTKZMAcn0YeU7PA/Ozg?=
 =?us-ascii?Q?9BJDP6EAJIijhBqrFjn2hbx5mX4xhozl9NrXOi7zWrDB2JtzWScWs9gJKOgr?=
 =?us-ascii?Q?KaDO/xsWvRO5SlFz9I6FOrFKoEbeage0cqc07X/FSpraM5JsGRCvfBvVJksS?=
 =?us-ascii?Q?7BwgcN2Cq6d0Z6iZD7IOTaR3QLESGmrKzI/OTOjkmXpfyCc5tUpwr47Ck7vq?=
 =?us-ascii?Q?Rx1vf2/TkJTUac8w5d2LE9ZEkZZMZi/4K0TUbVlZlfK9wXg8ZlhiZqcY5aze?=
 =?us-ascii?Q?wHNOubbWAGXQ3F2ofzm8Oz7+5cktG9i6kmSY8qDnENblkrPEu9IgFpF6mGEk?=
 =?us-ascii?Q?jC1oTFmjYxp+hklW04s+ICbAJ6CKnQYyf7SSIMJlYo6t1cAYfPsK3jpOFbuV?=
 =?us-ascii?Q?WaYOQuDnruqnBVaH1npFYewD5B3g+/SQw5Z2X8VYvY/HKPry2IEgYp1hCSUe?=
 =?us-ascii?Q?X4fw9DKnrfAHOKKCdx/q6NxhmH/+baCAek02byJCwL9ucotQFNcfiNom4wag?=
 =?us-ascii?Q?JKqFuMp9S+79wIpXX0VreAJMq4d2QZa3pzgTYRmspO4SGYRKnRgAJ6LVap9r?=
 =?us-ascii?Q?FNG7HG3G8UXQZNaIFF9K8UUx9dfaTEGvBPnEaKYngTMZbXF+7n56msnbLdcW?=
 =?us-ascii?Q?5MVzmrXcHNJ9ai5FlhofwbIg2x+S1xuj5BjBbSsr5YBmjG/Xj0jOxyqQVHIW?=
 =?us-ascii?Q?mgXTCldnpL2MrynJawuziu5fN8Ax/qfQW9/XD5P/edPbbgfSxYrnPf5xVXZR?=
 =?us-ascii?Q?+Bk2CQycru0x4hQx1kuSdIcgOqYu2iyiOpQrEwOMqPS4cmrq1VZoi7n3s+2u?=
 =?us-ascii?Q?B5dnezv49lLciiILAPfnrijlPww2jK5A+27kFKuVUQVSkQ1DZSNaYIuVW0Kt?=
 =?us-ascii?Q?53qZUmWCmw1+LWoK6g6qgq2vmikG6RcjUiL1/cVH6OWRAsuU5lQsRWhfPDCu?=
 =?us-ascii?Q?1dz3A2tcGGd0NLaWNbCb5YDFC+9blZEackyDAd+SJKBvtx0wmLt72xxnZqIA?=
 =?us-ascii?Q?CWiSHy6hoCQy98BDEKN88MtvXfNnlMdT?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c25dd5c-6497-42dd-6e41-08d995819b6a
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:30:14.2667
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
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
 drivers/net/dsa/b53/b53_common.c | 37 ++++++++++++++++++++++++++------
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 2 files changed, 31 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 06279ba64cc8..d7431ba20457 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1630,6 +1630,7 @@ static int b53_arl_read(struct b53_device *dev, u64 mac,
 	return -ENOENT;
 }
 
+/* Caller must hold &dev->arl_mutex */
 static int b53_arl_op(struct b53_device *dev, int op, int port,
 		      const unsigned char *addr, u16 vid, bool is_valid)
 {
@@ -1709,6 +1710,7 @@ int b53_fdb_add(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid)
 {
 	struct b53_device *priv = ds->priv;
+	int ret;
 
 	/* 5325 and 5365 require some more massaging, but could
 	 * be supported eventually
@@ -1716,7 +1718,11 @@ int b53_fdb_add(struct dsa_switch *ds, int port,
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
 
@@ -1724,8 +1730,13 @@ int b53_fdb_del(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid)
 {
 	struct b53_device *priv = ds->priv;
+	int ret;
+
+	mutex_lock(&priv->arl_mutex);
+	ret = b53_arl_op(priv, 0, port, addr, vid, false);
+	mutex_unlock(&priv->arl_mutex);
 
-	return b53_arl_op(priv, 0, port, addr, vid, false);
+	return ret;
 }
 EXPORT_SYMBOL(b53_fdb_del);
 
@@ -1782,6 +1793,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 	int ret;
 	u8 reg;
 
+	mutex_lock(&priv->arl_mutex);
+
 	/* Start search operation */
 	reg = ARL_SRCH_STDN;
 	b53_write8(priv, B53_ARLIO_PAGE, B53_ARL_SRCH_CTL, reg);
@@ -1789,18 +1802,18 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
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
@@ -1808,7 +1821,9 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 
 	} while (count++ < b53_max_arl_entries(priv) / 2);
 
-	return 0;
+	mutex_unlock(&priv->arl_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL(b53_fdb_dump);
 
@@ -1816,6 +1831,7 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
 		const struct switchdev_obj_port_mdb *mdb)
 {
 	struct b53_device *priv = ds->priv;
+	int ret;
 
 	/* 5325 and 5365 require some more massaging, but could
 	 * be supported eventually
@@ -1823,7 +1839,11 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
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
 
@@ -1833,7 +1853,9 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 	struct b53_device *priv = ds->priv;
 	int ret;
 
+	mutex_lock(&priv->arl_mutex);
 	ret = b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, false);
+	mutex_unlock(&priv->arl_mutex);
 	if (ret)
 		dev_err(ds->dev, "failed to delete MDB entry\n");
 
@@ -2670,6 +2692,7 @@ struct b53_device *b53_switch_alloc(struct device *base,
 
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


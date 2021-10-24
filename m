Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274CF438AEC
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:18:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbhJXRVF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:21:05 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:57952
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231722AbhJXRU7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:20:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XW+9U6pVSAf6BJr2Kj8a6fU/2dp72/BTsH6kxKBL3+/oaIbwbmTjUwFRaDWXWxhN2Pep8sY4htUAnZ5ojLSPAA7GBi8CmETiQXcwNYE68uKzJgFhgQjh0Ws4EwgPkM67VFWXJkdyQ4fahU/Eo/XzZ6Lcjl3FaW7fS/7K5Iix3HOpjigjXce3rOAHdKT4EhR17uJOxVpzEYDWoW2wfoLEvoo4Dhu87A4JVBbW0Av+0EkK8TxdPpeygBRus/iTkSiX+98mL0HRsBJfHvAGXMvMhN5SjjG4HYgzgWsuA15qI9xRm0NjM2cVD8q7S+lCF+yBEoAvZWlfQafgr9kENe84Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Tvfr3WGvmQ8qzx7BveEKan7WyK5HZF3GuDvHnhgBrUU=;
 b=BigfToBkR18vAm6aGfsA9vCS2XnYjFyAjjLAw+mU/2fkF0K3c6G7afPEmsCHxeHKnqNmyQAWSc1M7CEfgP9A9yJWGVpEEdVRt0E8XmTFjfZunKg+bszMWiKRUy9Bz/FZhV6FGU78BINgjDVKXLjilGHsnHuW4kghcCJRR0+ItJsM/AWJFKK61NuW77mGrvs4WIsv/yAPdm2/pmKtwUXmC71S2RNxNDs6p0n1fG2xBVuLWSlTRodreX3sf+SC/t6Ne4QUBkk3c0gmx/3mcprgaKEVD4tRR8LnK33yYrTDBUBl6yOsfogJETKeGAP/uS+Bt+zSyRi3DjoHYiDwzAZSAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tvfr3WGvmQ8qzx7BveEKan7WyK5HZF3GuDvHnhgBrUU=;
 b=jFn/AyagMY+Bgyvb+HFFgaDU3F+bt1Ux8psQf+GcELulI9ye5Bgj20pRT2tF7CC3Fq65XsBa7TOR1ZlNOh5o+9GNubjwnMGvGkpAkBKUbNcVbxdx7/e8C+E56cYHPMkC1vMIINdermJNgqfIhxSe2eHxlUWBradvc+iwiruwPGU=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:34 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:34 +0000
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
Subject: [PATCH v5 net-next 05/10] net: dsa: b53: serialize access to the ARL table
Date:   Sun, 24 Oct 2021 20:17:52 +0300
Message-Id: <20211024171757.3753288-6-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1297cc72-1616-4ac6-39b2-08d997124f4e
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3552:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB35521BB229A05D6A1226825FE0829@VI1PR0402MB3552.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ZIIurYiz3ywlY+pq21/5kgO1hAw5DCr0jqC7jDq7r/CbddqPyPS/r+qzR77SpZRGwmn/Rn+SiSex5ZZFRqxc0B+6oV1R5GM90Rpd2D/B1SBK7G+0o1jTGixWmeQj2fPc3F868yeggl6bXKOfjA+dH0UMzC0rhwKOf50Jsue5+/wwFZJENCtZ698pFXzHGvzZ5ng7ogFLQsefPac0vJhkOl8A7pm20QP7njV5pEo/O/hxKkXJ7ZxSXHQG8tCxoBznveNC5/qDBAyeM9QqmauY4OzorQXnDqjnRaWlp9SAmepD5hHJGp/4JmUufbSqLUyoXHQriiOw6u1JTCLZcEFthwiq9K+a4WJoagLUBo+YCouvX8mduvC9T1+QKJ7+TYQFVJ748B8sRaeQdUf9gYuJdkB5RFasKp26Okj6IAlyyOh6FORJcVv/WaaK/Duu3/Lr5ZzzqkqhOz28LjGkNf4OkdyGJqV/NCJZk/0Nq4MqRPUZrruFXnUyywXyDlb2La7jQhk2VgOwblVqWwx9tQWrnpPVnr9+KsEVz2uBiaUoTWNGhoCE2Nli8qYYwClCZdKlbdlxYxWmXSTHycnEtMoosxnrMeHgZX2JssE6PBZHYv+0SjKDHQUtVLc5SDew6WnXSr94+dB9jZYVnsk+8kabOif2CXbzyWurZ13x1R/izKgIaaCPjy8TYGOZa7gqPXOX73Q5wxeFIQyqS84Rb3wKMQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(6666004)(316002)(54906003)(6512007)(38350700002)(38100700002)(26005)(2616005)(6486002)(956004)(36756003)(86362001)(7416002)(8936002)(1076003)(186003)(8676002)(508600001)(44832011)(83380400001)(2906002)(66476007)(6506007)(66556008)(52116002)(5660300002)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Vv5si5Kng3zCzcnQpmpF8t02jmSYXT9g51o1vuhJ8Vp2wCiOf1cB1ugd5noR?=
 =?us-ascii?Q?FfINrC/7rPVHhsMmt/csX6TaOtrzVxlpXCoVrWRBZj3t7XYSKg1KYQ/+s6Xl?=
 =?us-ascii?Q?GXCOkageVqjiRuR23up+80oXAeYIsm3mE9LsKS78swyexYweTjZLir/w69sK?=
 =?us-ascii?Q?pYTiNppGye2R6pOqsX/m8YkhBrF9xrjS8wBW1yqucwS/oChiXlJaFj45khXG?=
 =?us-ascii?Q?J50s2uCSOyUxW7BAYJppgyfcdo+KBGeXcvqnhYLI3IB2kez9j+jXqrA9qYPK?=
 =?us-ascii?Q?Q55xb/G1jMaFhZsNtSF20GC+GRF675LL+HUMMWVMGu9HKrze9N6xDhyct+29?=
 =?us-ascii?Q?eSP5s00N1AVHMXtagWxb26jmesd6IfHtfdeO3fGLS3Q3E2keGrOyj4awrF1F?=
 =?us-ascii?Q?3KL3LmdxQWCtkRKhxd9WbEN66Eal5ON2Q0z9PpB+SvBtXyXIxj1cRDWaaXtf?=
 =?us-ascii?Q?g+QXsiZbVKKYUcz+N+K2B49LeB9rl9+SOelY78dz0FQ2JGrmY/vlMjze/YHp?=
 =?us-ascii?Q?jQ8U9zHaochKngOy/a08yYXMD1JWgFrRNBHe6D4uCTg8h1s9iuuNV2Zn5xob?=
 =?us-ascii?Q?Fdh/xltrprOKobsEcuDkqYbHQs7CRQkRnfW671DmBK3BM7dOyxiVt0Q/47fr?=
 =?us-ascii?Q?y8kCI9+m5ehq+Ws9swtfFO/tVbf43xza7LFG4YORr85YO53A6UmyZc/NVV/r?=
 =?us-ascii?Q?Y6DDnPgVya3TlJyTr2Jae1/ih5LGWnd6runaLjs/RsEFnZuJn5zlTrgAiPOE?=
 =?us-ascii?Q?7S3VV4RoJfDHytgPG5Awc9KELSGsleq6ytdkukIqRkSrmxaUTOq34lnX3CZ9?=
 =?us-ascii?Q?Pn2r3YXuNUJcJGrp9Evk6mm4uy8Z1kjqfi25iCh+Xg1jjRcuPQ3pY8moYlcv?=
 =?us-ascii?Q?mTfIHS4aUCWjYWhWbM9Ew3RD9dy2KOC8RJD7VqNn1KSPkzt5Ur7sCReeqFNw?=
 =?us-ascii?Q?OHKn8DFvS1KlW3mYyVhaidxggI1iNqUdLG7mOluETy+sFutwmFdiDeHV6mhT?=
 =?us-ascii?Q?/98pcelhDwp0MX59foFTkNnR5Cp91PtZ5CjiZprtKHL6A9BY+1ZTto/7a/KK?=
 =?us-ascii?Q?u5iufD6xA3IrVO8XNKek97gf4D13kx8A7rJGp2GE4OMa62UDMsFyntgFAh0z?=
 =?us-ascii?Q?yLVzZ4ag1hCeGu+jn8I4oVkjkVvXhHjE92lyw+2nxVjLoiAgEMhb8wqECief?=
 =?us-ascii?Q?UWP/H49SiNOubPscrwadnPCGYeqfV4Tt2R49IEXpU1+/sZ3q5KVlSl1qjBS4?=
 =?us-ascii?Q?unzcUOXhyh+U9oeqljd1l5lkIClKe0yEgrGS8Bbze1s8LHkgSFjtN0KLU0dD?=
 =?us-ascii?Q?BlljSiEHJJkOCMumieDmvO/KAb3dSYkUyS1/eUenD9dSI8YeDJe2HEQ+yLyV?=
 =?us-ascii?Q?RpXCrMqa4aeHLiGNssl6GEkQiqJyo5SBeEgvXveYr40KtvoSfMTYmVCAOurq?=
 =?us-ascii?Q?tiNM3f3hLbUHU2AuJH8YAZ0ejhzqOTZ1VtNGhLUnY8b4TNruWmqY3Gayi8+Y?=
 =?us-ascii?Q?0gu8WOJ+6A642XjmOYcCcj6EdP7QlQDm3rjskXBJOvSH2vsAppNS380JZcPq?=
 =?us-ascii?Q?oRfxHuzD8Z5tZoE+7v7+xo3eOgagF/F8G4hvRDwTqdAH0jF9W3qVSyKiNbgK?=
 =?us-ascii?Q?Ozt/o8BEFYfHt2OrHTvSpdc=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1297cc72-1616-4ac6-39b2-08d997124f4e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:34.6647
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cqPaNPtkKhgcgI5sdMc9Z31zQ4hcPL2L6+TZmqTCVYa98BnAxdcxawrl31Q9ZPprjOMj/ikV3Jryt7Yn22Sqww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
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
v4->v5: revert changes made in v4

 drivers/net/dsa/b53/b53_common.c | 36 +++++++++++++++++++++++++-------
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 2 files changed, 30 insertions(+), 7 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 06279ba64cc8..651ac72eed7f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1544,7 +1544,7 @@ int b53_vlan_del(struct dsa_switch *ds, int port,
 }
 EXPORT_SYMBOL(b53_vlan_del);
 
-/* Address Resolution Logic routines */
+/* Address Resolution Logic routines. Caller must hold &dev->arl_mutex. */
 static int b53_arl_op_wait(struct b53_device *dev)
 {
 	unsigned int timeout = 10;
@@ -1709,6 +1709,7 @@ int b53_fdb_add(struct dsa_switch *ds, int port,
 		const unsigned char *addr, u16 vid)
 {
 	struct b53_device *priv = ds->priv;
+	int ret;
 
 	/* 5325 and 5365 require some more massaging, but could
 	 * be supported eventually
@@ -1716,7 +1717,11 @@ int b53_fdb_add(struct dsa_switch *ds, int port,
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
 
@@ -1724,8 +1729,13 @@ int b53_fdb_del(struct dsa_switch *ds, int port,
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
 
@@ -1782,6 +1792,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 	int ret;
 	u8 reg;
 
+	mutex_lock(&priv->arl_mutex);
+
 	/* Start search operation */
 	reg = ARL_SRCH_STDN;
 	b53_write8(priv, B53_ARLIO_PAGE, B53_ARL_SRCH_CTL, reg);
@@ -1789,18 +1801,18 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
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
@@ -1808,6 +1820,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 
 	} while (count++ < b53_max_arl_entries(priv) / 2);
 
+	mutex_unlock(&priv->arl_mutex);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_fdb_dump);
@@ -1816,6 +1830,7 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
 		const struct switchdev_obj_port_mdb *mdb)
 {
 	struct b53_device *priv = ds->priv;
+	int ret;
 
 	/* 5325 and 5365 require some more massaging, but could
 	 * be supported eventually
@@ -1823,7 +1838,11 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
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
 
@@ -1833,7 +1852,9 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 	struct b53_device *priv = ds->priv;
 	int ret;
 
+	mutex_lock(&priv->arl_mutex);
 	ret = b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, false);
+	mutex_unlock(&priv->arl_mutex);
 	if (ret)
 		dev_err(ds->dev, "failed to delete MDB entry\n");
 
@@ -2670,6 +2691,7 @@ struct b53_device *b53_switch_alloc(struct device *base,
 
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


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319E34378EA
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:18:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbhJVOUP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:20:15 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:37344
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232825AbhJVOUN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 10:20:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mOCWKtxuF9Vn7HkJ7ePO4SvnnzusI8T1ZiBYiQvNk/lpenUKCheZPUygAIF7k9sNMRf+EXH4wsU07skdKX3y87V5ezTOmt0DXFw54DrMkE3Ewu5q6lnLryWUMFhLZpYS0Nlnm/Yea8h6WMu+Bye+vg5DnYClOmA3IHThYu3Du2wSvNaiyb2mnckWR94VnDhK2u0rrOGRXYzEfuF6zsTCMUFovb/GWPNYN9JpzmXFHvJzxLtf1C8CyTgQFDSifntuAHQDKKuDWpn9dWtf6zYuWV3HGgu8b5kuak8+BSR7Bk8CHIv1prYEo0q8FqV4lqHfAVxpfAPt5n2872ZKKlco1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8tuqUgp79V7Am++ArotmvPBOiP/B4srEdjqcUJtZYk=;
 b=W+7jzfv5USMt7ATJMFRANbhcZWj404vutj4QYFbFNs8DlwbdDBR+3cZ5Usj1bW4w34n9muXwNAiXtOytyj6mShHSTtZPJMM0hgGUdu8DgaV6WNadyaWfLtrnjA2zmlbsj3U8zQrHZ19XpkVrr5OFGGy5vrl083LGB9yCx86IVdvhFf4eMvzBw5ObiE+7i/ErUt26mfHfbDRlZaiGcTw4qkdo3D2eE+jrcIJsoPmMBnkVTw+W132SLfzy4jbKGKkUNWnNpOaSYCg6BdlYd8JMTgcFS6rr2dyEvvRYdMNTc0vQPcI0/BiicDzoqjygJpauDNpK5TCxytidvG/R3K2mfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8tuqUgp79V7Am++ArotmvPBOiP/B4srEdjqcUJtZYk=;
 b=QcWgQd5rTSY0WrIwmrytna2kdpEjmzi1WQG6xPPLpQr2y9Eq4OmO/mucQr1zZayrnKqhBmXm+if+iOqnTrEcz1pedLRhkHTIWf4E33IyeMhieUhmgFjKocrUpa3DUkosI92OK8hep4xdU06mp1RUl4BymvsjnotKNkTTvKo4v5w=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 14:17:54 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 14:17:54 +0000
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
Subject: [PATCH v2 net-next 4/9] net: dsa: b53: serialize access to the ARL table
Date:   Fri, 22 Oct 2021 17:16:11 +0300
Message-Id: <20211022141616.2088304-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
References: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 14:17:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 856e81ee-d414-4207-82e2-08d99566bd16
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3406E5D2E389145B01F1D220E0809@VI1PR0402MB3406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: a7OF++HiZJ91IIofPCfn7/r3/pIHVUY8Rl68+gcj/vrezxo8ZhWNoNebC2BlZUmCc99s6JqHOVkjQL2P2/1R0eqTHbd/zDjFTCClvEk9fY0cbSsWaSTEwn99kN9DxA72fxHQ48WDcMLp5e5ME+mSPLDRN8ctH1VeicYUJvLAgJ24dokOBszIllTWJGudjce1Q4t4Oiq7I7VK69POTML0UzsMjcAmKInPhvcTk/KtBd4gosmjVALWvzFJxKdAUeCMJD7UdSVunDWPR+mCoknHdJMRTi2sWF1iq1XtsBgbh0akQSON38D2JrRgVE39c5VhnOOGNOaMdhBkC4UfxCLZjwRWzuoTW3koLCaSS8EmdFkzb+eIcQgEI//1PtJs20WWR9N3mLvFxd1D9MpgrpPyWJ1/eg1xVAyhPLP3ElrgIgdnYLFWFOdVslMLQ7Yqq6hfZRA37SXOhmYNJSJFv/sp0vmB1C7tncMtbIXVqRXNCgar1Il/MJCOyXVpVMc3d/IoLA2zIqVF/rizB7kALnW6oIey6f0NVEpUqWbRR/k5De0+4KdKyx+PugOIvBrxnWKGciKmZHw6BR9NDFGEOcxgWnYRHlo3KWXMjwhQ+4mXaAHIOL4EaI91wHbR+wkeZGc0tE0oFlYg8qmgKy1Jt4yPw68ATioVzDbbDg75w5xVhre6IzOun0yRNuVKgKKevG5ZIrptqIsN6nbeouhV0NrIcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(8936002)(44832011)(38350700002)(6916009)(956004)(83380400001)(54906003)(66556008)(508600001)(66476007)(66946007)(6512007)(86362001)(4326008)(6486002)(52116002)(5660300002)(2616005)(316002)(6506007)(1076003)(8676002)(36756003)(2906002)(186003)(38100700002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?PtEFbFmjsGX9f4HgE5/+7bfA8aRr0Mdi543N2K8Z7ppvp1Xz5Idy10do92Jg?=
 =?us-ascii?Q?ny6dCTuPQAZxZxaB+6pKBl3i20KU55hVEJXFb8GbKxvEPFKy2UO0YFjQFfhA?=
 =?us-ascii?Q?xwAH9mw34xmSSbjfjofo5iCFWZnbPdVYIqU2tspJ7W3Jk+lwOMl9iaGei+KN?=
 =?us-ascii?Q?zYjFFtlN4dW9TBnwhkdr+iH7NLd3Cs+Hku+SJV5DGVqi/uWmiwjlIJj3dkox?=
 =?us-ascii?Q?Gptn0VChE7zv+EJAUXPP+S/rRzbSBGJS6D3gcZmUpR527OXxkpics3l+11uZ?=
 =?us-ascii?Q?sJuEOe9EAOaGFErBHyJlu8EnmJklrw4wd28GLGEBqRl+LooCLU5QswqpEwHN?=
 =?us-ascii?Q?QQQFInjiXODDYzpZJs+ZA89rWSc0THmfMAAVpnN/NjicRInIChtr1F2ciE72?=
 =?us-ascii?Q?Hng2oxP7nqMgLN0Zu+SSTlqFOnU83p7bmMJ5KS8C9bbMtW44pBUzVC3mC73u?=
 =?us-ascii?Q?AECdkIcDXDAIk2U4D0DlcW+XnxcjGstNbrFddy57gl2aOXZoeW9I/+GMOONT?=
 =?us-ascii?Q?ZYazvI9K6dQPYmmDGhCgwXbWZpwt70GvtZHH+ToiJsDS8kNDdAeqg4K+5BpD?=
 =?us-ascii?Q?+eMD5OoeKM/VHRAPPTuuRQCc5+ZRFl9Gzsac4OGeO3hcSh8wWvpfy3DUk7i8?=
 =?us-ascii?Q?V3m2uzo1xDYEDj5fa6g3jB4aX3Yi2oj36Z2zuBw+cSB+EClzxP9jRhHAPNuV?=
 =?us-ascii?Q?FQtJxoqemVzdVFxzUAWE0gYCupzuF/2oy07fCRgZGcsFVK7qsE37ZFQ3P67e?=
 =?us-ascii?Q?Hrz+UdKY9WCvDAJS1H9quLKeRJC8X8qqLAzgluXexfxaeGmDjziefTVXtexz?=
 =?us-ascii?Q?ybvUPeM7exeirQKtvWO5BdHuZNyv6y8TxYk+CHxplnIwQO2ll8IILQc43vn6?=
 =?us-ascii?Q?H0sUP1SNrQwwgLHE4ZWHArrsdJ8njFy/2mewsCBfojO/FV/xw/MbY4mtD8e2?=
 =?us-ascii?Q?zgx8LN5WHiBtNyMkhLnDhdRZNQJcyptwGDxO4cGHVGpHSfFOE43wXlkjsrgs?=
 =?us-ascii?Q?64GRfSAlLDE6CLki2YHgPIhEs+GLK7AEkgibSo4ybUQPLTxA1VD1Ii7CfmKR?=
 =?us-ascii?Q?kVF0aFa4d1gwaUpwpV0L4o/VLF4XgTXY/TyUtoWMwHFXELNzjS1eV9mBLR1Z?=
 =?us-ascii?Q?4F3u9qIlx9ydGHed6r4DTglpD8vHYlLORyYH1mpzS95Q9UV+VUi3XokFHA6j?=
 =?us-ascii?Q?oX15GkTDtuGu3ftA7qPd1IbFMYbS3ihqTIsW6vx/5hv9fpqg5JV3JAQ6Fu1D?=
 =?us-ascii?Q?f4aqCHlmMBuEw7KtHBeN2tmNfRomhkx0G/UFAO7APQEoV7yHI2R4uj2xWw98?=
 =?us-ascii?Q?qbq092xgrdc7011ZshZDL7lUY4CXK2RXL3B89rAinDXVFKHSnvfevnZeWdci?=
 =?us-ascii?Q?nIKoc4viHJ68P4NsYcteAD9sn3eAoRdm+uYsux9PoCI4esnnQbcOKuKPP+2A?=
 =?us-ascii?Q?0V/d8IjVf9JVbzIzinZ/ne0sCeSCh5jn?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856e81ee-d414-4207-82e2-08d99566bd16
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 14:17:54.2437
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
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
---
 drivers/net/dsa/b53/b53_common.c | 41 +++++++++++++++++++++++++++-----
 drivers/net/dsa/b53/b53_priv.h   |  1 +
 2 files changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 06279ba64cc8..22a6e3934a6f 100644
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
 
-	return b53_arl_op(priv, 0, port, addr, vid, false);
+	mutex_lock(&priv->arl_mutex);
+	ret = b53_arl_op(priv, 0, port, addr, vid, false);
+	mutex_unlock(&priv->arl_mutex);
+
+	return ret;
 }
 EXPORT_SYMBOL(b53_fdb_del);
 
@@ -1782,25 +1793,33 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 	int ret;
 	u8 reg;
 
+	mutex_lock(&priv->arl_mutex);
+
 	/* Start search operation */
 	reg = ARL_SRCH_STDN;
 	b53_write8(priv, B53_ARLIO_PAGE, B53_ARL_SRCH_CTL, reg);
 
 	do {
 		ret = b53_arl_search_wait(priv);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&priv->arl_mutex);
 			return ret;
+		}
 
 		b53_arl_search_rd(priv, 0, &results[0]);
 		ret = b53_fdb_copy(port, &results[0], cb, data);
-		if (ret)
+		if (ret) {
+			mutex_unlock(&priv->arl_mutex);
 			return ret;
+		}
 
 		if (priv->num_arl_bins > 2) {
 			b53_arl_search_rd(priv, 1, &results[1]);
 			ret = b53_fdb_copy(port, &results[1], cb, data);
-			if (ret)
+			if (ret) {
+				mutex_unlock(&priv->arl_mutex);
 				return ret;
+			}
 
 			if (!results[0].is_valid && !results[1].is_valid)
 				break;
@@ -1808,6 +1827,8 @@ int b53_fdb_dump(struct dsa_switch *ds, int port,
 
 	} while (count++ < b53_max_arl_entries(priv) / 2);
 
+	mutex_unlock(&priv->arl_mutex);
+
 	return 0;
 }
 EXPORT_SYMBOL(b53_fdb_dump);
@@ -1816,6 +1837,7 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
 		const struct switchdev_obj_port_mdb *mdb)
 {
 	struct b53_device *priv = ds->priv;
+	int ret;
 
 	/* 5325 and 5365 require some more massaging, but could
 	 * be supported eventually
@@ -1823,7 +1845,11 @@ int b53_mdb_add(struct dsa_switch *ds, int port,
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
 
@@ -1833,7 +1859,9 @@ int b53_mdb_del(struct dsa_switch *ds, int port,
 	struct b53_device *priv = ds->priv;
 	int ret;
 
+	mutex_lock(&priv->arl_mutex);
 	ret = b53_arl_op(priv, 0, port, mdb->addr, mdb->vid, false);
+	mutex_unlock(&priv->arl_mutex);
 	if (ret)
 		dev_err(ds->dev, "failed to delete MDB entry\n");
 
@@ -2670,6 +2698,7 @@ struct b53_device *b53_switch_alloc(struct device *base,
 
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


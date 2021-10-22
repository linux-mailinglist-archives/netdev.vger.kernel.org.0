Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5B03437CB7
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232226AbhJVSqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:46:45 -0400
Received: from mail-vi1eur05on2062.outbound.protection.outlook.com ([40.107.21.62]:2528
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231883AbhJVSqo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:46:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kvVChFa/aR8N8zOhL8nqVwOoeSnMepRL9ZvxeJA+c8+6k0GUb0sK41by4P2dKEtCu1uvXoyZACTTpS9gI6CttIXtTdY9tdJ1dAGn+Qh9BNiAwufXzAsUic9jqkeBR5jm+1VKV0yX6OzpEOIlI6cT3WA7+GP6l2Py/1qCxDTGMIjNSIJyFYLiABj5W1k1JuGlQAJyHfEscDoc6RfJMlZHlJOWoZ935uaaPmTyLfYrL7FVtmMiv0aOCBP5KNj+bJli2DRQa9Ox2e7rkEVbb28VpFPXnEhRvgLWvVCEWxf/fcBG0/Msho4dfHc8mVGwn81BDQk8rRPU+Lop8jJ3ybJDqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JXSI1Bhetr75MbZTxZJ7pTnnuC6KlBf0m3wBCvOQDEk=;
 b=bj2ro+1RPPz4RwOY9PoT3IaTewXX76SLhiYYUZeBxEYSrluRRq427R5r1e4QPt8FatbOTYkI6xx0Moho2uCVC5lw01NVmYxszmbHUVEyhAE4sb3mvZd92tkgsRAtCKdT1pQdXxbgBWzXz6do3nQkqWKhBjN8zfs+38Ld8Ar7uSRBpHTH7g2Yfetq6/Zo3ofYHRNCER6zK6xICqDqhebfPgmTHinDl3qyG9l+7PKMhN40dfNllzgKeN7Nid/RQO8n9oD8XS0fbTxxnGI7wji5GuYG8pUDX/gs1JfSkQAJUEYBY6nVusVuz0rhu/JCvhFfz1Yg4lmjsRUVBpcjZ93D0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JXSI1Bhetr75MbZTxZJ7pTnnuC6KlBf0m3wBCvOQDEk=;
 b=PBoBZVhd0DnhoY6wL/26rFeste6Ivy+67lMlWyZ8sgIk/h68FANsiXkrL/EzGEoF1V+3waCtMZ1r9tVPR2nn5+qpHnxPrI+angg+r0Us3UNxiEWDRY+R61D4RRqhcUoQgD86l1EuMeYJtjWlfH8BhidfmWuEQyrkoiO9DjoG8NA=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 18:44:24 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 18:44:24 +0000
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
Subject: [PATCH v4 net-next 2/9] net: dsa: sja1105: serialize access to the dynamic config interface
Date:   Fri, 22 Oct 2021 21:43:05 +0300
Message-Id: <20211022184312.2454746-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:44:22 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1958d0a4-7ddd-4ee5-d5f1-08d9958bf7bc
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB286252553DAF739BEC93F81AE0809@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TfatTUq/eQLOe6Q6TvWl2bS2pKR9Xn2AoLw713JYi+Mk/WTKamPDRRFe8Zq6MxFt6FCBqP87V9golDLJEZNKijGzhsx3dC/MVx7Gy8WCWAok36HMh230aWqwh62hV5q7rCNoBRiieOEdk8AwGCnyPsdBtYjzS7yWJRUyYwgT3XqAwOMx8zDCbmHIN2Ugt5hEZMT/SlRpHzJgxvAOC4Ou/aS560Wj4ms/mkt8aNnoyK7yiywg9L+Hy8RbHMNmUQxMZdXGsZ2xjLGxRLsiiPKyXiQY4Qbw2VT0GALFVvIeEGv3uR4iXSX7xqqGUECIC5eoeAzs3WrGOD5ISggnxVlDIMVAw83YMA1ITib/QhTWMfDlsASqmcYAXIB8Lak/RRaUtbrz8pWM5h2Y9RNFfGOBiizkgxetIB3/bk40BBw1fXAlWXtWw6XufOMw+OQnXoCWVePoDt9mW1VwL7v43D0I3QvvZxfbe31MJISlY5UiKA0NVkB86vyWblybkOC6L2vomkS0S5/lORBjUYbFGcBTdwjjiVa3DXN3M2u5pGXgJMpUlNLGfwBIIouzlF4K6rZzHISCHiJ8jnNO0cb00EclxQEU81G5Q9t1a9GA7EEI9Hi3OBXS0gNveTtdt5z89RqT1t65H3uEhqKr6Ktfd5ShW7znF9MUIKcQB2O67F82B6s413LUwRhv7rAwHCeH1ynt6olhniN6xWaKWFV/9sAAv05zA7TySTNs3sarhytI1+w=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(2906002)(38100700002)(83380400001)(52116002)(508600001)(1076003)(36756003)(6512007)(6666004)(54906003)(6916009)(86362001)(6486002)(316002)(956004)(66946007)(2616005)(44832011)(4326008)(186003)(7416002)(6506007)(8676002)(8936002)(26005)(5660300002)(66556008)(66476007)(290074003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?fXaCk5vVbTM+DuACsQ4+8kBSKTyz1qADM0Z7kwXMa6YAj4KkZIGIUZVtWanE?=
 =?us-ascii?Q?a57jSj/IOcfUQjaLRRilwTGmoNLCWQMugtW2x080ckhvtSy7H8NprCATrntw?=
 =?us-ascii?Q?d44XmAUbW6r2kKMBpqNvV75SkoxVaCQ4Opxi2RTonGwDj0oR5fAlc9Gk+nxT?=
 =?us-ascii?Q?oX3pPB2ZxqjgL1IScmPkJHL35g7rQX9HyKjoTJsc3frvtrYfuVgzK02A7eKn?=
 =?us-ascii?Q?htpTF1nQdyvlqlKppf4CrbeDLIFiAjXWPUmRyzn28SHMK2jgbqVU+bQdp5t7?=
 =?us-ascii?Q?MHF+lVyNwTlDQ8ueyPnaEPeGaDJ6Rkhtj41TclOphepK5RrsWsxmfGAuZAKJ?=
 =?us-ascii?Q?/SYEmPIGS09a/ZvqG3cpj+obAuZfLqmuXetrMudzKUtPSmHimYJKROm7ytG4?=
 =?us-ascii?Q?TR+S8GcD2zNmdVvp78g0yzmsLE0MNUWQZudbMiMcOb7V4zI1WPS/EEeSHi2w?=
 =?us-ascii?Q?Jq233GVajwBu4NPCJZ4NvlXlaoWrEjvE1Vqf0pTQZIyWSadEkcpLfMy/fwql?=
 =?us-ascii?Q?W4z3+ticsl5GQ72BZtvFKNM0kJIvEgYZBHJdNNDY7uLEmjOD0T1YUEb/RxKc?=
 =?us-ascii?Q?LCjcycd3g8g5BLUqyKvc9OYEWB6p87dyOFDXZHKsbtaw9+/Eclrl+kUZwrCt?=
 =?us-ascii?Q?u2oJQahwLBhQCYENmWXRIGp0qfBQgvJw2Vo7cT7pq/cQNDyTouJerv3oEPcF?=
 =?us-ascii?Q?AKF95K3dlOc3dR5pc5odeZgahTngcNfGUk6uiR60ejZUrsjLgK1pxYYahAas?=
 =?us-ascii?Q?M793D8VXIsPwROQrJBc1waOoM3s+YZyz3cdGcGg+eX5NhO5JytPnl20mb1dR?=
 =?us-ascii?Q?FGFgx7dgHtxX2FVR4rLk3fLTEgKZbh+w95z0bQhl9ek9fy+ZaCOHywNDxLRj?=
 =?us-ascii?Q?QgnaFQ/3GWRq8JJ42VvgRwPPAz/9K8AutiLQz9t0w2jPOV4hLLd1NgsRn0al?=
 =?us-ascii?Q?b4KNT/0a1FqYz3rRtT/ssLETFyqs4WSidVrXuvHcWFXhoM4RNet5Zo7+r7rB?=
 =?us-ascii?Q?VTPAjuCBMFyJz0FhBDKtVUuKdC+hXpl9ricr3GYVQvyC7ep83WnLbeIXp4W+?=
 =?us-ascii?Q?GMLrQN7HmjLW7lSfTw5RyT6wcBL1RqBQllQew4h8YGNJkSzDgdBrCVTgZw95?=
 =?us-ascii?Q?RwLQpMzk2BaHkg8AEcREGWhtA7q23lF3OOqRUSDt3Bk+IOB8o2WxeoqKAreE?=
 =?us-ascii?Q?/V8Biy3cieg+CVfCdBv/DvB5WMLxzQ1MuTubgr2yiuMlyANa9wgnizWES9IZ?=
 =?us-ascii?Q?76Y4cr3Oc8r5GVVebHteYpjKjZY39UzNj040z+mm8gHZ5Tk16k7EqOn66wuQ?=
 =?us-ascii?Q?/cL7y0m4BrUoVJXLom/wY84+h6KErGEiquew9q6ga5QubAi5iyJ6B4rxMb65?=
 =?us-ascii?Q?p+rymVJ6kStxwxHHryQvoCN88pzChS3iqMuExz+Tf29rgMaqkR/1usEdQIed?=
 =?us-ascii?Q?mR2RybAQDYgopaX8B4pDA49fWZ5HVrRJ?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1958d0a4-7ddd-4ee5-d5f1-08d9958bf7bc
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:44:24.0985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The sja1105 hardware seems as concurrent as can be, but when we create a
background script that adds/removes a rain of FDB entries without the
rtnl_mutex taken, then in parallel we do another operation like run
'bridge fdb show', we can notice these errors popping up:

sja1105 spi2.0: port 2 failed to read back entry for 00:01:02:03:00:40 vid 0: -ENOENT
sja1105 spi2.0: port 2 failed to add 00:01:02:03:00:40 vid 0 to fdb: -2
sja1105 spi2.0: port 2 failed to read back entry for 00:01:02:03:00:46 vid 0: -ENOENT
sja1105 spi2.0: port 2 failed to add 00:01:02:03:00:46 vid 0 to fdb: -2

Luckily what is going on does not require a major rework in the driver.
The sja1105_dynamic_config_read() function sends multiple SPI buffers to
the peripheral until the operation completes. We should not do anything
until the hardware clears the VALID bit.

But since there is no locking (i.e. right now we are implicitly
serialized by the rtnl_mutex, but if we remove that), it might be
possible that the process which performs the dynamic config read is
preempted and another one performs a dynamic config write.

What will happen in that case is that sja1105_dynamic_config_read(),
when it resumes, expects to see VALIDENT set for the entry it reads
back. But it won't.

This can be corrected by introducing a mutex for serializing SPI
accesses to the dynamic config interface which should be atomic with
respect to each other.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
v1->v4: none

 drivers/net/dsa/sja1105/sja1105.h                |  2 ++
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c | 12 ++++++++++--
 drivers/net/dsa/sja1105/sja1105_main.c           |  1 +
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105.h b/drivers/net/dsa/sja1105/sja1105.h
index 808419f3b808..21dba16af097 100644
--- a/drivers/net/dsa/sja1105/sja1105.h
+++ b/drivers/net/dsa/sja1105/sja1105.h
@@ -261,6 +261,8 @@ struct sja1105_private {
 	 * the switch doesn't confuse them with one another.
 	 */
 	struct mutex mgmt_lock;
+	/* Serializes access to the dynamic config interface */
+	struct mutex dynamic_config_lock;
 	struct devlink_region **regions;
 	struct sja1105_cbs_entry *cbs;
 	struct mii_bus *mdio_base_t1;
diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index 32ec34f181de..7729d3f8b7f5 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -1283,12 +1283,16 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 		ops->entry_packing(packed_buf, entry, PACK);
 
 	/* Send SPI write operation: read config table entry */
+	mutex_lock(&priv->dynamic_config_lock);
 	rc = sja1105_xfer_buf(priv, SPI_WRITE, ops->addr, packed_buf,
 			      ops->packed_size);
-	if (rc < 0)
+	if (rc < 0) {
+		mutex_unlock(&priv->dynamic_config_lock);
 		return rc;
+	}
 
 	rc = sja1105_dynamic_config_wait_complete(priv, &cmd, ops);
+	mutex_unlock(&priv->dynamic_config_lock);
 	if (rc < 0)
 		return rc;
 
@@ -1349,12 +1353,16 @@ int sja1105_dynamic_config_write(struct sja1105_private *priv,
 		ops->entry_packing(packed_buf, entry, PACK);
 
 	/* Send SPI write operation: read config table entry */
+	mutex_lock(&priv->dynamic_config_lock);
 	rc = sja1105_xfer_buf(priv, SPI_WRITE, ops->addr, packed_buf,
 			      ops->packed_size);
-	if (rc < 0)
+	if (rc < 0) {
+		mutex_unlock(&priv->dynamic_config_lock);
 		return rc;
+	}
 
 	rc = sja1105_dynamic_config_wait_complete(priv, &cmd, ops);
+	mutex_unlock(&priv->dynamic_config_lock);
 	if (rc < 0)
 		return rc;
 
diff --git a/drivers/net/dsa/sja1105/sja1105_main.c b/drivers/net/dsa/sja1105/sja1105_main.c
index 1832d4bd3440..6b4a76bbe548 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3364,6 +3364,7 @@ static int sja1105_probe(struct spi_device *spi)
 	priv->ds = ds;
 
 	mutex_init(&priv->ptp_data.lock);
+	mutex_init(&priv->dynamic_config_lock);
 	mutex_init(&priv->mgmt_lock);
 
 	rc = sja1105_parse_dt(priv);
-- 
2.25.1


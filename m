Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C41E437BE7
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbhJVRca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:32:30 -0400
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:27678
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231453AbhJVRca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:32:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrSept2hjWJi1tB0kSOvNvCz8DiG/XqNv0XkgFj23C2pGZ2DQZQlDCuxJ0bv9mgsYfcV6EJFGaM7IqYa01E5dmgTq5mongPGPx7Z2c6oogQ3dVI/w0wlgxTBJfLfKUnNtb9aVj5juWFvus5tRxOL5yteVXG9GJRuMQWt5/zS86m/ypkgDn4zN+BjrhePNNetghwYSur/XxN/X7TAULM79xcF6GvILTXT6fy61nfHPrehnO5Dr30sy5ghbhMHqg6q8JTJsHV7cM9S5f2PGtZZtctoumNBN7gco/kdlljSr8SvGBv8dBxJ+mAUV2dgMURtG2NGJOitBD3sMUssKXBHgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+b+nnj4MngZr97T0VE4bizcVWlZgndCASvnj52NTuU=;
 b=TOUS9p50z0Mt+6dYK0CInLY4i9QOqSm921M0HlTXKXWsY3HPRI5G0KMdA7ImJQvucU5A4W2Nf5Q/bbKUwJGh9KulQmvXy7Uxum0ZWABDlIe+5frLW8oSn4X2wTMGqujua2WHAXYE4v+lvwoUBgslvj4QZ0SuoS2T3OuGUHxbb1I7THXV+0ZVcNcAoMLYGK7ehFkR83w4aySOOCFjXhAAyyZpbUM/sTS1E3e2hOni9KzNZoEE2jaV8OSuRtluaHeynHG47Wfo0U2JSq7hy/volnV9E0BlAagnYdCVjrJxwbiizSX5QuxZUcuUNLgTDOCXQuatSSwE0Ps0fTD+cngZiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+b+nnj4MngZr97T0VE4bizcVWlZgndCASvnj52NTuU=;
 b=AWSFfh1AkapfIvkfYRDVck6CzT6BVxzxNdOPly/kpwmObohucIbajNyKndnOaZHPvIvRuBK6En2gk7QsEQbMJVScos19aIMBa/QLmRr1te26qpnbx4Trmx0drwRScolhvNGWF82bxZmIvboTPIx8XAITrw4rG53snDHBisFi9S4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:30:10 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:30:10 +0000
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
Subject: [PATCH v3 net-next 2/9] net: dsa: sja1105: serialize access to the dynamic config interface
Date:   Fri, 22 Oct 2021 20:27:21 +0300
Message-Id: <20211022172728.2379321-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:30:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 233c53d8-d7aa-4053-8e02-08d99581992e
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB55041970E82D11ABEFC7CAB0E0809@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hmooLeIu3bKx9TM+CxBVpXPMQBHJnQ+g+dt+3bgTsJXqkPfC+KUFZbOko9pmV9oWN8YqZ0XkCrMmeJR5m4Q+YwIKXn+YOeyT0HMeAga9k3FFmw+HiIs8W+2DgujoME6VbISVnhRosV8iMpMPakV8cS3bRKIR8tF5f1Mv0q28rYsK5U0qwzZ0BXufBuWDQpXhgGFzddMII5y9Yq/QqaCRT3q1dnBn9grVVNeGtf0kQ5X3b/C3E98ijmXw4g24D8+mA7b6f93UPvdPC4G3ZGyD6tH8xhDx/5ZNR0e61mJGxpAOsxPnaWV/oLvkQeR1+OYR0bxWtV00gquOHpQdLlrjFaPk2+RMmoapoBHil+trrN04WJ3YtGr8aVaSf65JgOfrraZfXUC9LUnRzxhxuHVWcOh55kkHSwAj9BGSgKihGT/lRr/DAui3IVjV9vnUKR7S7rv4GWNPe7B2DA0J7b0S6THNaNs5hIvMmaq+8AzPuXjzqVDum4IBhT9cCEr2NdEyILNkH7jmJ3+3WY6BT1PrROcOG4Kma1saS227O+5GAzF7YpFOi5QMlndBVNlMStIICI6pZyBrr4KjejpCGhIsfNpIZRvHTvuq3FOiv7CKPomzCpLj7HX9beUJ2FBfeowktJVTNcX47RlwnZ6GO/upLxRvdjTiCRwSYjeIVBiJ+OeWB66nZvgpdTY7yB3YHsYY7Ovx/gSPAsGF1Hp0DERwGmdNDwveWAUvLVUH+307e+Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(6506007)(83380400001)(4326008)(6916009)(52116002)(66556008)(38350700002)(38100700002)(66946007)(44832011)(6486002)(956004)(8676002)(2616005)(86362001)(36756003)(8936002)(6512007)(26005)(2906002)(66476007)(5660300002)(186003)(7416002)(316002)(54906003)(508600001)(1076003)(290074003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eTCycCALbOvvAL5zNdJuJJHOpNdy6if5YGkwKb2ZpJ3al2k89Iw+V+d0q3Nh?=
 =?us-ascii?Q?O+eLzmJIE98uLXd+uBV6yEv1VKBHn0nwBfOLSYxFzom4dM0IHIAEJjJDw0Xx?=
 =?us-ascii?Q?FJCxMOWFJZzX2w672AKc5RPxAVAP9U0Is0AAiKyhJqrY8zIqZ1bSUmJtxKEc?=
 =?us-ascii?Q?3Kc56lq3JAXTDG9393Gv5puMlIG9KsrEgiYTYjMPcVLx02Qd7zzW4Bbeb/M+?=
 =?us-ascii?Q?xDqqmEJB0vt6JjBDCwMFRMajeytCmejt6t+CQOJa1HyY2tchlYCXsgKeSrFA?=
 =?us-ascii?Q?3uJ8pvEpB8jm3jSN2LKcXggB5t2W8pLBO+8VRKATjFjE/I2b8UlVhNrEGHCH?=
 =?us-ascii?Q?GV6kDN0vhAZeABnvrTkj0EXivlIYkzbKgIbFDwFBYqT5Dz9dcL5m8tVPR/7/?=
 =?us-ascii?Q?1N3IybdlIPvHc+PTlwEZ2JfSXmVGCkHqdFntOTS9YDX+B3pSMYh4MraCtMU4?=
 =?us-ascii?Q?ktEFWA2uQ3UVyRE3kbJgG+j6Qdl5Se7Hb3WU8u/9ofBvM6RT4mkxniogpKgl?=
 =?us-ascii?Q?CPgSB0sRYRQPn+noQZkKBJ0hLHwKBH/q3bJi3gxADjjhUS8ylI7xO1uOlG2t?=
 =?us-ascii?Q?RZ5u4dKG/8F0u0tpeeFo64fh+jfW8i6T5NgUrxvxo2Wb6Qq16hbISdmrmRaj?=
 =?us-ascii?Q?FSWli2be8whfKKnLeZH0NQUedO5W7zRARPZ04piLjA6HofRucYbJhQFK6EJd?=
 =?us-ascii?Q?9gXb6iQHTxWFfcTdfHK/NfavXG6TBT+Bnarluo0WCZDTcmCGsW5CU1W2tRts?=
 =?us-ascii?Q?7JBVhHGwLIFMeuIynQD7j5h7xAkYoK3FwMuGkVzowSmqMY7UJ8+rsKKstzmS?=
 =?us-ascii?Q?yqSjsZXeDoTV72I544PrCqfGF1ajSksojOJ3G5fnKH6bMOZ18Hjv71hqZ2pA?=
 =?us-ascii?Q?cr89217FN5vNl5WWAbpYDMallDGujVOjp9HuQN6QvfxKZCAOZjUAIvnMI7O5?=
 =?us-ascii?Q?4719lQKtmbBM/2lhLLIZT+susozklTQiFm9SYJOiXykJdx0NNI9HUBvskbBI?=
 =?us-ascii?Q?FjxWwnbzL8XsmATVyUf3vwkyb5xzjpDyx0ckSWO1pyxZkjju0AhEsLEJ06Hf?=
 =?us-ascii?Q?k7y+Zz7W+q1CUiHaKvCwWDytJl9gEJznT5GQNJxLZWWNGeUX32mzk/sd3ZvN?=
 =?us-ascii?Q?DUwsXAhIQoBsQNOYR4IR9rWmhB3VhQNHYA7v7mZvDrbK3FB2pyw2QfOq2qBW?=
 =?us-ascii?Q?CnajJtMhDkV5gH6ge2nx2cHw3Ag8OaFeG8lq01+UfaVpLTjFXbXAgAql1pE/?=
 =?us-ascii?Q?RtBy85IRK4ZqkVvQ2WZsNwpFUWNpLs+IJKn0i414qmcATshWpGWSGWyiGu5w?=
 =?us-ascii?Q?GmqFZuCXNPnPP6AW3a2DXiJxIY1gQUqxUb9koaLwXBnTUdwT3hpNB9OhWiTV?=
 =?us-ascii?Q?QHmX5MNXx2k81o7Pa+XC3AIXTbUsrTlYjpZfWVC46uw35z5IGiFCyX0/FyIk?=
 =?us-ascii?Q?RRvesVjpc6XjRm50qHj/1R1tmWrhNMRU?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 233c53d8-d7aa-4053-8e02-08d99581992e
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:30:10.4939
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
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
---
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


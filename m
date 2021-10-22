Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 868964378E8
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:18:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhJVOUM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:20:12 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:37344
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232825AbhJVOUK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 10:20:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZCIAi7RqK2InI0RUuadxWfpkPAyTJO5odE5vUCZndPg9cDoLQOuJhIYgQnrj+eGCiNi/RM+/c6LaIhThxeP277eT26+mAwN38QNQ2rVlI0Ud3ikUFTvCgL/pc9pIddUDNFaYoPnJDJm+SYiyHB6e3QPGf9klIxvmdCTXC1ExfPHPyZua2VDv1I1guEIfBK7eh4B7hEH7vegG9G5Lsba3usMePhtgi2949Fug946Sgf2f2e79sqmLzqSGLriK9dhAKrE+K7SZ/x1Vp1PE22cdr7S3A54BBoXfS0bcvUVIXFK7zDXT8npEubAKnRUlE9QBbM39sMBDJYp+94X0hlthw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=O+b+nnj4MngZr97T0VE4bizcVWlZgndCASvnj52NTuU=;
 b=k48gV3y2Bb8mB+dKB7uXc7VNuhU3dJwVaZbQjJ/NkwXMkqNNdeJ20ByW6C98PBiS6cWr/wMnuFJu03qEpqy9TDf66WEiZQj/Aqqtpem24/FY1MZ0zrZDhlh3nOnZoBhVTj1H2v5n0N9pVNG54TRnbnpG97F2ynhgDTLVcGmek3HIYT5EUrwKhtFJnJGEXntIV6pEIy8kQMXFO0CYPVbC/la5B1yi8xKRG2BiCpL40+/VR6SH5sZjn3Io3w9cjZX8SYt9IvCNt9Xj8DDmnnrET/VueY1awlYwXtZshVL66YpiGgNSzo1p4dlv0cF8CXzw+qqLa8m9I55YbMVREtiwrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+b+nnj4MngZr97T0VE4bizcVWlZgndCASvnj52NTuU=;
 b=p1sJQDrJsTuyQEw+FfzS1NFEiaRz2UE7yW+98aaAvuUGxKr6rFjs8uSZYouPaHgVZK1euHo4+H856Rnm5jh4TQ0gaaCGdGID0Vb6vw3kMvsysYIV6pTaJlwuwEXLYlQwwgWQThCh0B23ZE1eq1A7T1Z4ekZRudqAzFhIqU9aggM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 14:17:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 14:17:50 +0000
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
Subject: [PATCH v2 net-next 2/9] net: dsa: sja1105: serialize access to the dynamic config interface
Date:   Fri, 22 Oct 2021 17:16:09 +0300
Message-Id: <20211022141616.2088304-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
References: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 14:17:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 422da8bf-a9e2-4e9d-d0b6-08d99566baf1
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB340665ED5EB06ED8BAC1A45EE0809@VI1PR0402MB3406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ijgKs3Q6K5ZKLRwHbZYvrUwgzCt0jw0E3Np8VJvR+KjwAJk1d7tyAl+CbHn74qMj6hr4eKIFalr5kbHt/enTUxikpJtaXIknWKH55EykM6nqSsUA4TIRq41vP49EfFkgFFejY7s38UCXcKwzCQmERBifmf1phxQXiASCoz5WRi1ZbERg/poThQopH45dGXi6fijjdcWkYty1Mt/vMCOJeE/6n+xwSItboT64tZV8tHQQaQ/wykkWeCHb00kIqOeJLD6lek1vGFaJzNE7lFhongcgW5L8Jis4N0CRZbRKb+2sj/FreYuDP231aVw9YFb9bodLRC5EiGpfR8FlcneCuCm+siYKN15cUPSuN20cERicFGirawZ1ismh184atx72kA6zKywqu7Kv74wiP5CHsEQerBBiBwPtNsrvxGgV5rpL9rXhXARCITgMb8xSp/GJ8nmgWPl8OXdlHpdzhAn6t9la40mpB4EG7oYx0VsL/RvsyOFnL0KUT1+4WTQuiFmjkLjJiqUGdiUqyoY7L0Km2YI3KYRi8/K1Y7r+k3RxwVdw0PvDsdoVdzUQekmqhJMCnvx39qwu0Nsn3l386gzq9QTJr93Cn1sx0U0VcWPXT4QeQn70lsN5VWWnRHzfuaw5lBQhQwhNHEMhZ8SQDQ1rzZsBWSJjZfKbF3Vq8tXo8tJMpZqSJ5kFDmcoqU6Z6HomUdcRF04YNG2NhhuILUMjgvKgRs6H8/crkM9pbO10Wpg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(8936002)(44832011)(38350700002)(6916009)(956004)(83380400001)(54906003)(66556008)(508600001)(66476007)(66946007)(6512007)(86362001)(4326008)(6486002)(52116002)(5660300002)(2616005)(316002)(6506007)(1076003)(8676002)(36756003)(2906002)(186003)(38100700002)(26005)(6666004)(290074003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?tzWYtNXYiZXtEA2DwMAxU2p8ZJ2WoWrNPk7H1bbik+oPVejg0b1W2AHedowH?=
 =?us-ascii?Q?+P2hR4HCk6Fz7psdKoFtapfH5WkEn+9LfYrf4BnGLVeMPnAk8GSQAiIqus92?=
 =?us-ascii?Q?ta48e7YQViyyt1srOxAFIRLuoUV4oZanJmVH7AEpcZHsnv41a1LtZdaOwzh7?=
 =?us-ascii?Q?/v+gilIuW3ymr7pt4F6WMZuM3wmnh8FmiEuvJuvc9w1vlxJZBLZb4ZnT/LVB?=
 =?us-ascii?Q?cc9jk29ymNIKqkJQRe0MaZNc+kVELeOOFz5GzxzuwgaLBS4Xs4a+dAeFarkd?=
 =?us-ascii?Q?TSiT/AtxynIo89xicdc7a7KPKEui/NHaIIN3x3SbQzrUAk4qqQl52B9A4QJ3?=
 =?us-ascii?Q?XkCJhg3+o39EAtasUoB4dmG8VkxgrpOjcRJmy457l03m1mtT0lG+uJWds33a?=
 =?us-ascii?Q?uShdGXu8OC1gKxZIcxdY2NqyxDg19nHM724OPkw/DxpVAOcEcpqEQQUa6dy2?=
 =?us-ascii?Q?Xpig1FoQNtKCXFr/9r9kl0Pp4AJK3OqCnEe2Amprfdn1o6af8tqdKCWsvG4V?=
 =?us-ascii?Q?cx1HyR0+Y7QA0z8RUotxpeq/cfsLe1flVh6mqzLL13d4HvYjtbXBM9zJG3Jv?=
 =?us-ascii?Q?wjgJvpSBsfkg+Meg5CbxuGNG7gjxzYjtbQu5GWYUDzlzwOQbhkvURKrquOtn?=
 =?us-ascii?Q?lNkbsDs4pl/vE3k3pO/SWlXdvsFzJM5imJUHZb4A8PY9mgntGadvP1ZMx1sz?=
 =?us-ascii?Q?knOHF0QS1n+LXXF5G15T37lltYtnURFQZiPJfxJjbn0Nrqy6ZN3MPqFM4g9Z?=
 =?us-ascii?Q?UJCA7A0boYvdYtnN5vc6ebNdRIu94GBCjHEQWCSMVbl/+APh+zDTMysSVVu8?=
 =?us-ascii?Q?kZU2KOWwit55QLZmWPOT2N5lAY+qlb5cmtYC+l9GMJOznDRmGhrNPchcYyYc?=
 =?us-ascii?Q?KYH6Sw4i0ak7LP4NEoKqn9UQb4iGLPgswQCokYmx07lL/8mnHL32T84W5tQA?=
 =?us-ascii?Q?mhTFM+DYWR5IS7xFQBEcAxp5COvqfUYaEEvwZxmSn7hM1WTyniQiEgFFw+NZ?=
 =?us-ascii?Q?MHfscGAgiDKawJ6r7rgNsgYCDCGlWTS/vByA6DjUqU/6oiW0Mna6rKxb1Z33?=
 =?us-ascii?Q?ALBFraLoB+TnaOoKLcvbAqhlKCEp4LIQB6U37BkU/dZhBL0tjFlGxuj7iHO0?=
 =?us-ascii?Q?zhdvBXuoBVLgHoDQUliCsLP95AMHDUG9biHQSfR+anSdzz+32rVGKOr/28Xu?=
 =?us-ascii?Q?i8U7gRioAK4fRojZ0s8SZV7ZT1s128yoL1Kv8KWUSwAkqesCd/cl+6rYUXVR?=
 =?us-ascii?Q?WyiHVxf1mDiy2Una43LfqYE2zdx7pUfOV9eCy+7VmezgDYXIZJIvYCdWnZr3?=
 =?us-ascii?Q?biYqMw7872JEL5S+trsuCKROT0ygVyPZVREKj6TYu6MK8zRiDAmp03gfqL2u?=
 =?us-ascii?Q?Eyf0YhZdoraVkr/Ka4rbX7rjEsp6Pf/rbsSrisIi0T0jb6ztRgA9Y2/Qo00d?=
 =?us-ascii?Q?bwB/2uGbTbYkzHTDCBc7Gh7djr5mzboy?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 422da8bf-a9e2-4e9d-d0b6-08d99566baf1
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 14:17:50.6527
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
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


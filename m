Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670F8438AEA
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231700AbhJXRU6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:20:58 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:57952
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229821AbhJXRU5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:20:57 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CFFaU7RnXiX718tkohdrBTtgmN74XHxPf5+W+MJ8/XnLCQEJYZMDoXOc4sfevIKQ3eWi7/ZhUO3YeSE460C7yaWPNyjUAVjLzm+DBiKo1fDU/AwJ1uXuiwgq8ZaLsCVo2TknS17hVhbq4PYg8FnkplkVhxlHjTtMEh/mWru/vKeLgoRvdJt6TAq/4gVZTie6qUf4QPwdVv0xBJvw4i6dbOZe6oKJ359UiQ2AZ4MV945U2QWvAgxA5Z8esAuBMP/U/moLBSj81DJxFj1vmf6e2W+hOGm5I405/6t0x7f50Lz1PsQotGOFH2snpWcGdT8WwlkekZMsLtv0hLCSXXPoow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dcsNOwsJG5F1wgxp+1PmzQukHBuZc7BsBduVI7R73S0=;
 b=maKac9KYi2zQewCHyC9+5sJS7ndPt4L3bhxZLwo66xoPuY6/bllZZcEkQGWNP+MIIqv/yp+7YclKHeSoXOA440rh5IsabC2ccHNHHad1fnVAC9Sn6+8JNU1/DqkdA2cVNvZDUmPZZGfmEPzyEuMEEDEgKirIIHhS3Iti6j0QIn0gqFBefBz/cQBr0+3I/QrgOxqX7yl6OpGaBiFNn8eYVPzI3GTY6dFDEU2v1q4ExZuLqGt7S9CJmDyiY/OxKkNULQxy82Y2gqs56PkSMIaeH89z7SWDJU/XYooBLEC+zynp1W0Cj+s+hQKAbozqJmVwDUYAY6jJFLBhU7VAEtUuTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dcsNOwsJG5F1wgxp+1PmzQukHBuZc7BsBduVI7R73S0=;
 b=pQ4URDz4lYVT9aUpFcBRlevJioPnntwmuiPw8vtmHWhNg7ieOgw/2MGQfVmqYeWPX26ZRdL0zvm9m3lX2PJwg6GcbYA9cWUch2sCwZ/zLzQ1Z4m1GsaxIIBpPXMxGkryRl+3wQnwSY4RazhuFkQ5o4GKqVx2UNDSsiWPjEqA4QY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:30 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:30 +0000
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
Subject: [PATCH v5 net-next 03/10] net: dsa: sja1105: serialize access to the dynamic config interface
Date:   Sun, 24 Oct 2021 20:17:50 +0300
Message-Id: <20211024171757.3753288-4-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 768af97b-b2f3-49a6-dc28-08d997124d03
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3552:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB355290260558B53D5369CC73E0829@VI1PR0402MB3552.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Kb3pfr6OHIKkFwxD/Nm/eIE2Nqbt8gqwQGqzQ9eOVc/8EbSFlKOhSzw42devecEez1LtcmRcIncFtbE/xh8srtAFvKaNNWKHnIthyqCYY/JiGJoUkgum8lbGDU8yyLZ1TEgkHVcCwP0THfqNfj83AsvB7Z61g4bEvgOzUa+bDh5dNVN3bhvj508k1jEbjAy2jA+5968uva0PxIqc1rksYlkTVMb7SDSjdZDerzFFCBOIdVhtxzmzXy41WfX1LU9xCMH8XBQadX09IavW7COJY0HTuiVNc9SG944JkVdJUaHvqBDmr2R5Hlwd/yxEgpkkhXHw8NyCzPl2aa42gRweF87QysDnqv40pvr6BPl2Z9gryPXOJ29az0lDVd9nQ7w/W3Y70KO/xSFqf9aOqZtyTHVFoLdp9ugQa18gdC9BRbk7cBa2Bg1648/Se7PszDgqQWmwE5Hosbrwuy/qT26hHInAyfSF0IDT0xlS4ZmRGGBZmO4vzbRGjPlwK/Id49AyT6g3rZuCBnBCfx/yltBq9iUxgfc+0LH7rO5F9vHtZX7Fo4e6sC5ujCOeRX9pFdnqc7CpU2NbdvnaIE86m8glQxqBepY56wS3Dg/NhZteUF+k6ZbmA88T2uGyGG+54SPumrawb7T7H+0WMoHQHqsU+rnxo0E4/aO3ZrssWEvOFzNLsG43OPHxseMmJ+sFr4pC3n3vSy87kia/L9+MiuNuBi0BP7xfUnBwESnkTzcG7bQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(6666004)(316002)(54906003)(6512007)(38350700002)(38100700002)(26005)(2616005)(6486002)(956004)(36756003)(86362001)(7416002)(8936002)(1076003)(186003)(8676002)(508600001)(44832011)(83380400001)(2906002)(66476007)(6506007)(66556008)(52116002)(5660300002)(4326008)(66946007)(290074003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EKOQKpuywIonAjn4e4kKGCD2J2mxxEYBaD9kFVXt68f5XulVD3jOqRWFfWvS?=
 =?us-ascii?Q?fe0/s+Ryd0l+/9kM/u7x4YsXTtpuNTcVecZ5sqA7Lv/8K9VJUid4soktVoc0?=
 =?us-ascii?Q?td9JENTI1yvKakEE+bHQA8YD88ollF26KbDsCxrJYGqhMJFbdOXcvVRY3DbW?=
 =?us-ascii?Q?q3ZX1ORp2l8H0VBtytwxFEXIUklEqkqsI8lVPspZbWQa3+TuO/NHdsU12b01?=
 =?us-ascii?Q?VRXJFg5Vw+tJZOPQ7jr3BX3Cs6v/BZlGDUsFQEdGhkQXondY44qFAZLe8b4r?=
 =?us-ascii?Q?27XlHrZj7zB3gcYv2uvrF78VCRv6loAye/r7aDV6qvYKlrIy2ZDouI7FPxwn?=
 =?us-ascii?Q?uFbe+oq+r2Chi7OdvKxyHM9oXLAE9hGhiXTxPHRW9kqCffmRB9sj4O6CXq1t?=
 =?us-ascii?Q?MM9wfpB7sClppjmHX3r2V4I1eZxmOucc/8Qi3zH1gSw9yS9mxcJYwNzopsWC?=
 =?us-ascii?Q?30EPXWloVcUvPNY3pf/mECTONOTZcG9PPaffLeVo9iwr5/NUmd3G1BoNz9vR?=
 =?us-ascii?Q?dVqjSzGARz1llG5K5x6oEriwFzOotXUJ1djOZ7wHZiE5akr5kzqgbH6Hl/l9?=
 =?us-ascii?Q?stFrw1VvzGD26bf3p+RuhkgImZzl/30S/uWGEjM1ynxJDMaX7PuXSWTT/BgQ?=
 =?us-ascii?Q?AglISZcVzBw6hV1ANhaTTymUrLTskNwx3Zny99NbHwyYGPYiO8hYMkB5RuZr?=
 =?us-ascii?Q?NS5Gevot/fh15d+0oWQH72IWk8MZA9l43Hz+0tZJHQP+XPbonOxT/yKQrbxa?=
 =?us-ascii?Q?oHp/ebXRAG7C7ikTkSr8/3M82I7Xdcg8HUN8DFqleh9nH3wY4jgN165GBEM5?=
 =?us-ascii?Q?uo/LlYpSbwiuEoTMjxiOT/8DVX01Y1IIknqUrI7PTpkhxSO6TTNSqmyU2VML?=
 =?us-ascii?Q?8Pq2r0ena1T3LM+5p44ImsJ/EnOsxV+J1f7iviemfWb9vKcWnvocNE+cIPlX?=
 =?us-ascii?Q?oOFw/EZz/3hFrrlXi54CiApQxCwCsxf+reGnA2B8tWyRVQiwwJVmB/LL+fSG?=
 =?us-ascii?Q?UK1OFfaIbhUaLkbzLfrr9/YHvPDviT4vpoVR01DaNWHHPgS1rz1mlYCTHo5Q?=
 =?us-ascii?Q?/skbR8uDx65OOc3LlXhiQW+RL4/AZausRrarmnMNDKymBFUNBcCp2zvlsajP?=
 =?us-ascii?Q?9RtfqgiPpuoBfTS6DE8tpyC5fEJl3XJ9Y6bY0cpPEHI0SrwxgIjP5QzAsEwP?=
 =?us-ascii?Q?4AuLKHFjQEqCZD5Z4sagVv8GUsamie8EFm1K2+gs87dWFqyD2G1MWgySGQXk?=
 =?us-ascii?Q?Iv4oQOznBNoDYg9CFKBYwWHLXkq+c0JuQvMwswjCS7Rnigy81D9OQcnsj2Og?=
 =?us-ascii?Q?sduMyB3RudbtNEa9qEvVRKgb2CN98fxMJgRLUzFb+wWtqDjqXORf/lewiv6S?=
 =?us-ascii?Q?kNpY+uRwBL2SetVMdj3C747SVxswLfX98GPX6AuwHBiYEKgExNdFUjeU79PU?=
 =?us-ascii?Q?uPXN/FNDW9B30hIf9+hDRpC/hXAchDK5VXvBXbPMPzMQ0Wogfc42mEiMEnzx?=
 =?us-ascii?Q?PQ75B5VVd5aMY8TYZHQHFMhfIoxRYJtF7Ezsm19artRtHdSqbaBSIYObpikj?=
 =?us-ascii?Q?tLmaWKoK7eyHT+EDUYp1F72QDDFL7+m5dMBAopc3NprrjavWTE/5AdAcoaPv?=
 =?us-ascii?Q?wlrB0xMA6MkatbWfaK9MOfk=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768af97b-b2f3-49a6-dc28-08d997124d03
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:30.8688
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oQhM2EYbwESz7Vt6zPgw+SxC/qwKNxkpYdgs4afAs8ADVUI/VxJ0LBK+8EbrshwMrSXRov/CLXrr1AIpX3oelQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
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
v1->v5: none

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
index 70ece441b3b8..d6788a010024 100644
--- a/drivers/net/dsa/sja1105/sja1105_main.c
+++ b/drivers/net/dsa/sja1105/sja1105_main.c
@@ -3366,6 +3366,7 @@ static int sja1105_probe(struct spi_device *spi)
 	priv->ds = ds;
 
 	mutex_init(&priv->ptp_data.lock);
+	mutex_init(&priv->dynamic_config_lock);
 	mutex_init(&priv->mgmt_lock);
 
 	rc = sja1105_parse_dt(priv);
-- 
2.25.1


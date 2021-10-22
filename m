Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5446C437CB6
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 20:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbhJVSqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 14:46:42 -0400
Received: from mail-vi1eur05on2043.outbound.protection.outlook.com ([40.107.21.43]:44121
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231883AbhJVSql (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 14:46:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M6fZ567shelTuDGS3IPAF1WhYeZgLyHzeWC6e1M/6sAo3mjUeB0QFiO/rzy6NLJXDWeOO1wRXtYYH9RQUv5YMVSsZeFvuUpadvLCAOTMBBMEWsBdHAYIcxJeQb9Kp58rxpfc3l0sFIJdxam6mhipb3vGn8rl5K6ZSC2ABV+2dXbJ2oi9OOZFDA5+FWyCLjidb04nI7R+e0SPF92B9PY9nsabC05TZaZNFi4JL1+7dVWZQ+Xt4O+EhvgOBpnLHzRRr4HG7seoONxbYMkVWjaL7weHcVFuOiL3uZ3RfInumaBXKxTIu96sFEcGyY91nteFUxPutIOPil/7wggxr8v29g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=77xVtbBaEee/U9wT+1XH1y613W4Z1ZDdLqMrF1HhTvs=;
 b=DMHl/kKNOzZWsZ2CVI6jwA91EQOqgNiY2DyHhMO0zfCu3aQV+gQHnHA5TwMsM7jMC8jGXQ8R/rn/fIz4a5bivQiYXkPatJ535qZHk0KV8eyccrkt6sVIx8X2Ou9qSHMhqCIu1ijtb/lYdfOQ6I9u5GEZR/hlf8IBC+A2GDWuU9yUwKVQdgM6tpiQ86HzTiPcn6cVB58GmA9IPPpfArYLpAP0uJeuPvqN17gN33Z1ypS5nqIPSYPlTAeiqpzDpbMWWx8NCHTfjbkLzWRmDp6vZ5/exlYtyV/m8Ll0fLhDUYag8COImpzjIu0roCXX/I5TXV9m6g+pQkhsO/1pQI+ruw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=77xVtbBaEee/U9wT+1XH1y613W4Z1ZDdLqMrF1HhTvs=;
 b=dqJXZkmvkM4tO3Tr8ItKwkHyCbGmgAW0QhHRYpERrhSiOb/yjwswWLEcRsSx8DUt3Z+vXjCyvAIMIaF6NPsL/HZXVEWaZw0cTgih2BAQ4n1Dxma85vfIMHcTgFsG8RS11UKrXAw/o3Uu3xasLs0Ono0eRz9o2IqfIJy1YfdWv0k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB2862.eurprd04.prod.outlook.com (2603:10a6:800:b6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 18:44:22 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 18:44:22 +0000
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
Subject: [PATCH v4 net-next 1/9] net: dsa: sja1105: wait for dynamic config command completion on writes too
Date:   Fri, 22 Oct 2021 21:43:04 +0300
Message-Id: <20211022184312.2454746-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
References: <20211022184312.2454746-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR01CA0103.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:10e::44) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR01CA0103.eurprd01.prod.exchangelabs.com (2603:10a6:208:10e::44) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 18:44:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 236abfe5-c5de-4c1f-eb04-08d9958bf693
X-MS-TrafficTypeDiagnostic: VI1PR0402MB2862:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB2862B27483BA95B040050689E0809@VI1PR0402MB2862.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hahyPTvevVtECeTKMcjde6ctEsPdbaenv689Y4IghNx1Q1fJ9V5hoHr8CGmYtR1PeFwMb8sWLXVZG7kxKclcOUVoPxW6xWXRw89h1uC/MmWDkoNJZdJUX1br4VUhTWkV1T77oMgNHD/08sT8vnRCKQ8oiZjI48BbAvX1unUcj09XGxi3VK2GNzE/+DVa+8tiM3HPocqBgDvFaGDHIE82tJ5hrl5GldsxhruiSN/yPMjaei+PPiiCn6xSMWTMUq8RTx133kY9Hk7W1eRAFy+oPoMpNjyKW7dQ4VQcwbHeK6qIlZy/YfBODP9WWskUH3D8LaxigT8t33dIt3393IZIphW6GDQVeG2u163MHnTee4uAKaXOQYnAIzcTFgIYl2QPfyXfmMgMJw8H+C8/pfifUNn3QuzauKDGaXoIuhyGbrw1brKt9G1hzbBaRarMe/zs3f4Jy5TccMTEZOm3dFgEKgNBhmc7cG/qbrXfwxtu7DT4jrx2dn4/JMMU65chZq0yGX+A2NhDhvne/8ccaAgmlVrLx7PIMhBiQlkYaMo11wb4ejMuV1VyHOCmwOHL4XZML6FC/6WFiSOvedHcwGEfxI7qsP1CWbxAvHbtngXLH3gzzbA6CumTZOwYowSpSWuuIatClSaNnuZCaZyxe/XQ9aHXeg9hJ21SmGEZG9IqrihBZdOCKN8YuCyTDZ/enhV8ghAekmbC06HZOYYghnHnOQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(38350700002)(2906002)(38100700002)(83380400001)(52116002)(508600001)(1076003)(36756003)(6512007)(6666004)(54906003)(6916009)(86362001)(6486002)(316002)(956004)(66946007)(2616005)(44832011)(4326008)(186003)(7416002)(6506007)(8676002)(8936002)(26005)(5660300002)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lOwNOwjO+GebKNmkfPp5oWEeu686sKdm06lPljrZAur67ZvVyTIoUK53IJWI?=
 =?us-ascii?Q?qoi2T6hPe8aTWXaaFbzBgRGvLl2ERLjOeqv++XprV09Lz2ORKGbzqOKmWLrk?=
 =?us-ascii?Q?/LZOVuUf4eexR7+tMe6mvezLL+SI7tNLxXLr6hX9bmfav9iEvZbxjlVW3V9L?=
 =?us-ascii?Q?99K0BG7BNl3KOtqhCIK0k2BjM3TedbZuupLntXE7/Z/LpkkoSBN62xFtwcAv?=
 =?us-ascii?Q?X+HqAu4UOD6SOe7s6g15OHzBuA3gBeHaIajWSPAsM5pb8Sk3qoy/X/LksAU/?=
 =?us-ascii?Q?CcbaEFC+JpqAvAMIXBpwVd1QsQJfzdTD+GYj/S1FBBDV/6DEuQqzmpBRZglh?=
 =?us-ascii?Q?WdIoyzkF415QHHAavEt6xsXNqKPKqwHBgY5Sa/hY2CEGXnyhqNY4qAsMVWWi?=
 =?us-ascii?Q?htG8ejuiGjrykH5Bl6/xVvEJ5C9SFaWPSpQjzoPDdOwDwHlEGxJBCcjgC8h5?=
 =?us-ascii?Q?agnsj8sNTJDKtwKf1eGlJM24wGi5lBL7SlGgRCuke5ekmDmpljMRNh/Itvw0?=
 =?us-ascii?Q?IYWI6YImp61OOnTstKONxh4A7RuTfgxFeO490Rww9/xZO24Lo6sWsqYG/dvh?=
 =?us-ascii?Q?A231m8Cw0QsLSPFNxSZjjXPRzHlkBBEd8nuLWAxDbXItim1s3mtVIa/Hw2w5?=
 =?us-ascii?Q?YG8gK33zv7Prb7QWlX3DsbDP8RZm8xNBRiR+c//yQHhIAqXd+pOCWMtM9uGm?=
 =?us-ascii?Q?KmFeLYRKI3TJ1nVu2YLjLLwn9orkySbAr0KIaDYgLDItCZbXXDC3Q/SafGJI?=
 =?us-ascii?Q?8WUkqK7Uh49nA3VBXR40GwpFJOVwHpH37ystJHg6DAZUNTFt3Sj3CIJAdFa8?=
 =?us-ascii?Q?y4GhJC2vZbRgj3/Tn1zUMKF9+wTx54zxyGCOIaAk3bS2PcU/iUjBaO6rIAb9?=
 =?us-ascii?Q?X948OztBu7PziIW7RD/YraC8btcx/Ngm0MHafKBYRwdcYi9M4Gi8rDL1c/k7?=
 =?us-ascii?Q?cjz0dY2xIjGZ216INrWk0r3b7LCPQYPX7pNHq96NtZVDcdhzqnLM32xssoxH?=
 =?us-ascii?Q?7QRW11mG14kHzk0PdJrGz1OdZFQn9QJIMIDgMju5IL4dl5a0+ufVY120GV1I?=
 =?us-ascii?Q?uXkbI+InBbDPsBtLpgxBq88H3pBVlaIaygwXzJYzH/8W8vBp73t0zXkz4Pk2?=
 =?us-ascii?Q?AC8QyZnQxE6+vPfyc/ZMixc2kYU2w05U971rQipripJHUQQloU+BEBcgTD4F?=
 =?us-ascii?Q?1bicrBUVfa6k7g8FlQ7U4SY0q6BDILsO9HUsqDoSSa+vHCFCr+j2Vm1VOwO+?=
 =?us-ascii?Q?63kXg7Jm9n8UEp87Vj/vBlkeMXF7cXqgSdAyuLP9NiWFPFaTdRAChrppLuST?=
 =?us-ascii?Q?/yJuAXWoo2WHlnBhISpCPvvC+P7SKCDguNftpaLi2V9NDMUTpqoGSpnkzALP?=
 =?us-ascii?Q?daX32zA5RovUYITKn4S6zHiwM3IJ7alZ4gS9ihRhvoPvMu16KWcZ5tgYzNmi?=
 =?us-ascii?Q?rJwANdLNWO3qEgHCilPfnapvmFu93BgI?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 236abfe5-c5de-4c1f-eb04-08d9958bf693
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 18:44:22.1486
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB2862
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hardware manual says that software should attempt a new dynamic
config access (be it a a write or a read-back) only while the VALID bit
is cleared. The VALID bit is set by software to 1, and it remains set as
long as the hardware is still processing the request.

Currently the driver only polls for the command completion only for
reads, because that's when we need the actual data read back. Writes
have been more or less "asynchronous", although this has never been an
observable issue.

This change makes sja1105_dynamic_config_write poll the VALID bit as
well, to absolutely ensure that a follow-up access to the static config
finds the VALID bit cleared.

So VALID means "work in progress", while VALIDENT means "entry being
read is valid". On reads we check the VALIDENT bit too, while on writes
that bit is not always defined. So we need to factor it out of the loop,
and make the loop provide back the unpacked command structure, so that
sja1105_dynamic_config_read can check the VALIDENT bit.

The change also attempts to convert the open-coded loop to use the
read_poll_timeout macro, since I know this will come up during review.
It's more code, but hey, it uses read_poll_timeout!

Tested on SJA1105T, SJA1105S, SJA1110A.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
v1->v4: none

 .../net/dsa/sja1105/sja1105_dynamic_config.c  | 81 ++++++++++++++-----
 1 file changed, 59 insertions(+), 22 deletions(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
index f2049f52833c..32ec34f181de 100644
--- a/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
+++ b/drivers/net/dsa/sja1105/sja1105_dynamic_config.c
@@ -1170,6 +1170,56 @@ const struct sja1105_dynamic_table_ops sja1110_dyn_ops[BLK_IDX_MAX_DYN] = {
 	},
 };
 
+#define SJA1105_DYNAMIC_CONFIG_SLEEP_US		10
+#define SJA1105_DYNAMIC_CONFIG_TIMEOUT_US	100000
+
+static int
+sja1105_dynamic_config_poll_valid(struct sja1105_private *priv,
+				  struct sja1105_dyn_cmd *cmd,
+				  const struct sja1105_dynamic_table_ops *ops)
+{
+	u8 packed_buf[SJA1105_MAX_DYN_CMD_SIZE] = {};
+	int rc;
+
+	/* We don't _need_ to read the full entry, just the command area which
+	 * is a fixed SJA1105_SIZE_DYN_CMD. But our cmd_packing() API expects a
+	 * buffer that contains the full entry too. Additionally, our API
+	 * doesn't really know how many bytes into the buffer does the command
+	 * area really begin. So just read back the whole entry.
+	 */
+	rc = sja1105_xfer_buf(priv, SPI_READ, ops->addr, packed_buf,
+			      ops->packed_size);
+	if (rc)
+		return rc;
+
+	/* Unpack the command structure, and return it to the caller in case it
+	 * needs to perform further checks on it (VALIDENT).
+	 */
+	memset(cmd, 0, sizeof(*cmd));
+	ops->cmd_packing(packed_buf, cmd, UNPACK);
+
+	/* Hardware hasn't cleared VALID => still working on it */
+	return cmd->valid ? -EAGAIN : 0;
+}
+
+/* Poll the dynamic config entry's control area until the hardware has
+ * cleared the VALID bit, which means we have confirmation that it has
+ * finished processing the command.
+ */
+static int
+sja1105_dynamic_config_wait_complete(struct sja1105_private *priv,
+				     struct sja1105_dyn_cmd *cmd,
+				     const struct sja1105_dynamic_table_ops *ops)
+{
+	int rc;
+
+	return read_poll_timeout(sja1105_dynamic_config_poll_valid,
+				 rc, rc != -EAGAIN,
+				 SJA1105_DYNAMIC_CONFIG_SLEEP_US,
+				 SJA1105_DYNAMIC_CONFIG_TIMEOUT_US,
+				 false, priv, cmd, ops);
+}
+
 /* Provides read access to the settings through the dynamic interface
  * of the switch.
  * @blk_idx	is used as key to select from the sja1105_dynamic_table_ops.
@@ -1196,7 +1246,6 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 	struct sja1105_dyn_cmd cmd = {0};
 	/* SPI payload buffer */
 	u8 packed_buf[SJA1105_MAX_DYN_CMD_SIZE] = {0};
-	int retries = 3;
 	int rc;
 
 	if (blk_idx >= BLK_IDX_MAX_DYN)
@@ -1239,28 +1288,12 @@ int sja1105_dynamic_config_read(struct sja1105_private *priv,
 	if (rc < 0)
 		return rc;
 
-	/* Loop until we have confirmation that hardware has finished
-	 * processing the command and has cleared the VALID field
-	 */
-	do {
-		memset(packed_buf, 0, ops->packed_size);
-
-		/* Retrieve the read operation's result */
-		rc = sja1105_xfer_buf(priv, SPI_READ, ops->addr, packed_buf,
-				      ops->packed_size);
-		if (rc < 0)
-			return rc;
-
-		cmd = (struct sja1105_dyn_cmd) {0};
-		ops->cmd_packing(packed_buf, &cmd, UNPACK);
-
-		if (!cmd.valident && !(ops->access & OP_VALID_ANYWAY))
-			return -ENOENT;
-		cpu_relax();
-	} while (cmd.valid && --retries);
+	rc = sja1105_dynamic_config_wait_complete(priv, &cmd, ops);
+	if (rc < 0)
+		return rc;
 
-	if (cmd.valid)
-		return -ETIMEDOUT;
+	if (!cmd.valident && !(ops->access & OP_VALID_ANYWAY))
+		return -ENOENT;
 
 	/* Don't dereference possibly NULL pointer - maybe caller
 	 * only wanted to see whether the entry existed or not.
@@ -1321,6 +1354,10 @@ int sja1105_dynamic_config_write(struct sja1105_private *priv,
 	if (rc < 0)
 		return rc;
 
+	rc = sja1105_dynamic_config_wait_complete(priv, &cmd, ops);
+	if (rc < 0)
+		return rc;
+
 	cmd = (struct sja1105_dyn_cmd) {0};
 	ops->cmd_packing(packed_buf, &cmd, UNPACK);
 	if (cmd.errors)
-- 
2.25.1


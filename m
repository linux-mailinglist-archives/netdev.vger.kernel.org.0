Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF182438AE8
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 19:18:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230520AbhJXRU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 13:20:56 -0400
Received: from mail-am6eur05on2062.outbound.protection.outlook.com ([40.107.22.62]:57952
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231481AbhJXRUx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 13:20:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gSVG181AP1ePvY/zucqUMA9LYuyUZmt2LU9tKiR6OqCRwAoiy59iNtekgp/tvd8AEqSBxBBbrqUvUIeEkh0SMxW4f1a6hKr7f8Nfm8iyI9Xoq313KCLf+DrScTUyi26JP9ix3b0zrzdaCoDr01N4F05aZb28yhT7iZc2fdRS91zgO35yVeRq3qQgPDUyrDZm6zRozMHR3hVreSuDcfSAT7OCQ9FwRw9NAVXlTfNZEx1QqHPPsV2/dSoUeq7LBFd1bgOGj1F7jzcZZc59iL4khVNkbZJOOlSninwTWhUYtpexDyf/8SjhsQqqvIlQmfeF9P0nmafW/UVuoccc2u1BjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WTFXxD6Y98RsdCw5gmJ4qs+ze/l0MmXH55q7J4eClDw=;
 b=fw6sRtgxFIoeN12pi3zJEhca/KzX2jYGodUZX64LovUu9yokVLgXhQrK7zRFbnkvkYQPU1kljiOl97THC7RBamWpO5zre1MrcHZajQsgd8AYLzAgE1Nsl5tpOYrA26tkdGttWbnfvz09BtZnIEFek9vsjXl1oGEE2ddKEqdrwoJ/Br41hal8USI0xt//+KN37jNn4UXLygtL1j3BQL14QgnetwHd+HbVO2CuTa4Khw//zUP0alOw/HXI3n5eSdbU1AcUlfolnri2yL5unHNX1Wyda0d7zRX7Xlh+6oJHrfpwRZRsD0G3mulEDevPyZoAxR60U5Czhftzd0dOdc0klQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WTFXxD6Y98RsdCw5gmJ4qs+ze/l0MmXH55q7J4eClDw=;
 b=poyWdxgFbfhCo83QfkNiV4rb+BbWSTFihX/OW4cNhrSeBBVtxcvsn9Dqu5Gcedy/9nUxBLYIVZh9+Kx05aXbQnhe/Nqi9Bk5P0XieZfBEV16iIJVEvTZAYpLiNHVqWX/OrFJYCh9LCNQmDYuOjtJSqFN0WrJ9HYjI9REbCeNnhg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3552.eurprd04.prod.outlook.com (2603:10a6:803:9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Sun, 24 Oct
 2021 17:18:29 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4628.020; Sun, 24 Oct 2021
 17:18:29 +0000
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
Subject: [PATCH v5 net-next 02/10] net: dsa: sja1105: wait for dynamic config command completion on writes too
Date:   Sun, 24 Oct 2021 20:17:49 +0300
Message-Id: <20211024171757.3753288-3-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
References: <20211024171757.3753288-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM6P193CA0123.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::28) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM6P193CA0123.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Sun, 24 Oct 2021 17:18:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30507183-ab00-4729-837a-08d997124be8
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3552:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB355253ED9DECD62C8BB59F91E0829@VI1PR0402MB3552.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: m1vhBMIjS2xwI/T4S5etRZFAK+g2JQBB9INZsCh5dZJPJt4+1CuE8+h71KPGBtQhJpsx8pMUiz5GagwdLecVKW0B8UCKpWtF8Ybomv0XUMp/GDV/OHJEQHHYGvc5W3cGEeqIufRg+BPcm86OEE1dtu6Qdk6FfT7zoyEnrcTOahOChDCB9opDNEi2URaJ/MxImDa77pUpXynQuPMnXIdm0JCJoFGa/sVIrPJXe4H7N6K7e4nG0pfVcQbtFr3CQd+dypofX+wmAKIFSLQBrCWJGrhPDYEnV3Nm/Ut3nOqc3Oyc7B0boS9DfWeGZ9KIVmWRIbFNgoqJHmMc5cpoJ9VffJ4J3VHGl/WIyRbzSsV0Q5Xc3wb2ffSuU6q+vrL5yC/xKBvmRoop11rnQL58fqCuR4Rj31LykBCAUOip9dEryM+3sOirUsD2JJsYJRsGttwWmGERy5A8+9zLY4g+OZ4CrPMoSU2gMFkXv3Yn3MxAhWNkJF08JETpUZIst3AEJQkJf2bwSCfcAV3GizT/OzvW9nyiPPPO02Gy5eSPn17d53q5R/FeT367Frtmtes4SHZvnqavMHOJw136XuiVyfD8IyGjdetRF10JNtntkiCYp9qQRMfw7c/dA1InIQSsQcenpMmmRPr+7LGYeha78oVJ/JS24SuXTPNKZgZiMyR2Azju2tOIoIxXBKcC5hG4GXxL6Z3ZM9ZEAZKkpCz4lDLg5w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6916009)(6666004)(316002)(54906003)(6512007)(38350700002)(38100700002)(26005)(2616005)(6486002)(956004)(36756003)(86362001)(7416002)(8936002)(1076003)(186003)(8676002)(508600001)(44832011)(83380400001)(2906002)(66476007)(6506007)(66556008)(52116002)(5660300002)(4326008)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?rPs4vL0jRpXZQj9iZ5cCiHOIGJswdv7QDS46vGm9W2AzNuUDMJ1pCmVrasFj?=
 =?us-ascii?Q?xGacDPZo7OWWisn3R2pPM+GsAtzy7ORLCijRB70Dzi6E2g4SLD1gXBAcCRrl?=
 =?us-ascii?Q?FuQY1rtU0XnFekQtaQM/9q5WHoxF3GKLykICliU1WR10/wSFiZ+MFkqjzLlh?=
 =?us-ascii?Q?5Dp9EBHrJ4qhlc5O3YEniCv4paXya4Hr9jLjb7lfnMTsvmdHwuNrAaiTpfVu?=
 =?us-ascii?Q?s4E2PQATCEKMeTUQIn9h6iWLXsufr2YYfguRz41TBWbvLbY0hZeWVYyDuV9C?=
 =?us-ascii?Q?CoNvTOcSy5fHu6iAUTk6KMLHkWi/wcs35luSQL838B0z1EbuvcU7HEYbh/Qh?=
 =?us-ascii?Q?fLqRwvctpYURUBctFbVqDWy9LbyoBmXR8EHZZyzP3r2Xo6IeDLinTBKRSCka?=
 =?us-ascii?Q?4q7SAeFaf6c62wzkmkhP06aOXhE9Qa9oaWGCuVBHa3OMFf6lIRR0P7UiO8Qk?=
 =?us-ascii?Q?g5/izWfuZYmQnSuI+Z5QsyA6eGxtwvm6NdPlItR0vgvSG+p6fIYpc5aXE/57?=
 =?us-ascii?Q?Okdw+3HDOMmYDG3qnZZMEu6ciq15SjzdPH20pReba2zopy+95wCbwI4eNHZf?=
 =?us-ascii?Q?nnmJKVLMu6e8d+xv8bgM+Pd5apzm5svMo9s4GxAfnno5J3ltVER+hVzmgPOT?=
 =?us-ascii?Q?KGeda9zklAIk3mpDccPkZai/KzV904Gq7wMspS55c3soQMl3ROUPVfuGqVyG?=
 =?us-ascii?Q?tQsTP6AzF8uOVIZJ11Y4LTxYZl4X1ycLayc4WDqKKc3Vr8eWQ49KZYpbK6V/?=
 =?us-ascii?Q?MecoTDMVjV/2RMGOveIsfxb3rNuNkxae1zOqiVSKJUp553SlyXGd4eZJjXJu?=
 =?us-ascii?Q?I3mcMxb0q+BizP4sk2qhalljYOGHJw5cIPG9qP4aCg2qbX1siOp6h7QlDmhB?=
 =?us-ascii?Q?3QeeyDzPk71ozVMQDXmhsDAM+LqWOZj0+OhkEQoLQ8HfTvaj5i/Eng/7/s4a?=
 =?us-ascii?Q?myTO8VZ2MjRYOsmi8c4WigQrlKL4HEaDZcASFAivSpkVUXjZRZZtPC8fLJyB?=
 =?us-ascii?Q?QpdrSnutVUaUfG9rTkskB3kzyV/MYih2g/vjdxykUjuN4Qs36ls5p6avoU/M?=
 =?us-ascii?Q?kvcQJ/1ZfNVojoDI2pn+Bt/BsF/r8ot4Ynhh0/gaHbQx5DfoqD4tfBspQi5F?=
 =?us-ascii?Q?mJVNs6GBYM3BmhUDdyo61Y0zqkQfelsQeJS99DZxwyHx5+Aw655rBMtbLBqr?=
 =?us-ascii?Q?5CZniDS1pSSqQDr3KRjEA//4v7eBcvm4PYpVwYgW9x/vWbgTrC8c/At3Ml9m?=
 =?us-ascii?Q?6ldHQxrflgFMCl04+dpi5HJ20Ukoe/ucf62KSFeLTn2bD9xFOA2QCLP1uIr6?=
 =?us-ascii?Q?nXQRHAqPhqSkt8P6pKVwoDiOxHFFEsPwGJluNkRkYCxNTs6mLXCNJNBToC+7?=
 =?us-ascii?Q?Jdn4k3fG2S4400H7cWEVUkK+bXlq0oNR57Kxn5w1O+VcWSJBRKO4fJpB7Th6?=
 =?us-ascii?Q?IFU8Ccgm8V6SFMKiUpijEvtL6I0VRLVcNgIIih/q/YOs0KhIroy1BX499ZG7?=
 =?us-ascii?Q?74o1hV3i73Zyw6DuHemca7OuA9yHHa1g3gpo3nLzHHbahlCVJbSCsVO1v8lR?=
 =?us-ascii?Q?r+qa+rmnubvImiluRGKh84xG1U4EOYl4FxlGbWvkQMcHANEEwNZw9TyD1C0R?=
 =?us-ascii?Q?6LfiLQwqLghUjuFaopYWhSQ=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30507183-ab00-4729-837a-08d997124be8
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2021 17:18:28.9669
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6ejFCOL77K2jXWuAElUha0dyG8n+pO5CpQTE7CM9lGp38QVa2bp7LTz727Onwb9OhtJcs/ShTVJQ3FuRN74Lzg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3552
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
v1->v5: none

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


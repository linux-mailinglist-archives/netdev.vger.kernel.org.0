Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE833F5D3A
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 13:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236740AbhHXLmN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 07:42:13 -0400
Received: from mail-eopbgr80078.outbound.protection.outlook.com ([40.107.8.78]:43248
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S236550AbhHXLmE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 07:42:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Z23HGec50iXriQvD/7SPF8RBSmmSeeR7m7bEoh3/Y/2wOakJUotiPRDzvaS/ezVjNt6iJkO4Cva7QYx1jmgWHC0OUvHSXqaWh9poPNwGZaATgHIamABtxvRl4mh2bBHq9BwIS3LfGFXXPK/CHhyP2sZtjBG16l8WQ8e/9f5SgauGTkyOH0KidEuKBiK7i6MRuwsKatJHV4PFgz9CdnKbtVU7dx0nlxjKRAJhNe1VtB26fScriIMGJLWEiz3xK8ShRDSqVQ5EFNlQl30Qi/YcnjNDZsPTgLYsRQXdcujCgYKJnfi7iyjd1ljlsfRf8XXZDRA5oRVAOvRm0t3JVwWfIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXPQ1kGmLDc4MxjhE3mZ9yd1U45r/8dJzMYU0u1a4cU=;
 b=NlbOZcwYtGCGgHu7O5Px1EsmnR/0h059pWIXxmGWbrfYNbi9DQr7kCQmET5NZ4Drr/unV5CeK0U7U5Cx9BVo1xTkU4baGcDgs11G5qFzNv+hWZAAaOWQ3WGFk0PEsMMDmQP6WUh8fVjg7nVWyxje5VLIRzjcKvTVgRecpgTRvOJJzipkpx2uLJ0yxrIXInPDwVI6oyfYFoTFQSOp8kiMIuURV4+dhK5OLQLMY5YOy6NBUPDCCr6RAUKWIEP2x5kCYqpooii2VnBInRaT216eMQOOxLskL58x6/IESc+5usJZb8/rc0Nul8JydAhQWowrkyhxgjylKNeRPajHlXQGPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXPQ1kGmLDc4MxjhE3mZ9yd1U45r/8dJzMYU0u1a4cU=;
 b=Pbl4nBpLaExShG0AckTHS2m3wmDTaiVyb11cGSuBCc7BTZXqvb/IeoSkRM6nUHRahi+DwGCy7zLsdUaV9O/aFixDMWX0L5LVJkjr1PvQnijCDeR8ky4i2Lj1keIOBbEaZTtSCjWKggzS/FK8B336kAyKfCFpQnzAVSVZyqyYkLo=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 11:41:16 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::109:1995:3e6b:5bd0%2]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 11:41:16 +0000
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
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: [RFC PATCH net-next 1/8] net: dsa: sja1105: wait for dynamic config command completion on writes too
Date:   Tue, 24 Aug 2021 14:40:42 +0300
Message-Id: <20210824114049.3814660-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
References: <20210824114049.3814660-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1e::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.144.60) by FR0P281CA0083.DEUP281.PROD.OUTLOOK.COM (2603:10a6:d10:1e::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.6 via Frontend Transport; Tue, 24 Aug 2021 11:41:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a413f88-a326-47a7-4524-08d966f414de
X-MS-TrafficTypeDiagnostic: VI1PR04MB5696:
X-Microsoft-Antispam-PRVS: <VI1PR04MB569681F18C156CF4497D10BAE0C59@VI1PR04MB5696.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u31KE/hRn429QqBsuuDpWzI3gzi7Ii9/pYxZzDNVzlWr59OaFdeE3WEg7FBlqFcyHhbad5U98QksIk28bsrsNPbYtamuNbQU1mN/7MXdMEl/bCeseHVW7IQENksM4YAG4Pu+0uI8MoqpOEF6UCjGHKIcldvO6O2shGHauS4Sh96OXX5JspK+oxSm9TMm7PMb1axC6qwiJq6u4GwMchtlf8lMPPiJUjneQNQn5+T55lj+OpHv5MU1A9FrJWVv1iTp+PdN0heAiy32NxEsbSHZB7mi8TmaNK/n5dDGMD2fQNvgB5a6fgupxvcyl4+zW/D3ayBVZkITmHkbd6lE5JAvWHZtLsUTDylh/9nTXfWFB9gOrXi/2AKYYY/WaNDXeewWXMQtdHZGIBIwaXXS6ayL2Ulu1uf34heVsvVJjUJ/I1izOz7q1GPETvJLw7KYbx2gUf9OJw/M96bkJFxo8K3Jov81DCodQ8ioTHpc+xm/CvWKgDFs9QedV9O7fUzO08WHm6h9aWbj1ucda+0YdmObi/C9a775ExjghAQkjx3Y34nMR/52CmJoODfow4Qet6cac9cGLNP/fdajJnZQYuGEaSqcy95cueQlT12AQUaD8WFU0WQtF9c3Gk5O8dRJtvXvMns1MRDVedp91n7sQ+1sWH5MCV5rgZVBqbyNgPalozJYTX2PwNiwX+n//CLSXTynVRYkr7N1rmPpHmds1deLXg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(136003)(39850400004)(376002)(52116002)(4326008)(478600001)(5660300002)(6916009)(66476007)(66556008)(26005)(83380400001)(1076003)(36756003)(66946007)(6486002)(6666004)(6512007)(7416002)(6506007)(186003)(8676002)(8936002)(2616005)(86362001)(44832011)(38100700002)(38350700002)(956004)(2906002)(54906003)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?mEsWH+N6eD7omlYC2jXdB/3VrmQEKVYTrq60Kh9vvhCARM0zuAvu8ff+nKb6?=
 =?us-ascii?Q?omGduGmW91Ai6wp9c4AqAoblhFncEMAe4YmYn3ryzs+Rz5ZO/IJxetQ7gIwK?=
 =?us-ascii?Q?F+Q93ZoSNIqdtxGl4GEvFMefQ/MHzxtYWfNHBFDDvhxEDb/AWIfR/vKZsDmH?=
 =?us-ascii?Q?DZeIOH7DI4hir2/AM+anV68bJINRP87COzcBpwOaQr/IqbzNcrnB7PwXhxqn?=
 =?us-ascii?Q?IjnPPwRhiUffnJhMQdewt/nPoGu+5ql8vj5FD8okDtgHM2hrTTqcuVb54zko?=
 =?us-ascii?Q?7sC+s1Kk3es/zl3fS2w43S9HLu+Lc+iCYHeYN410Ohs9SgEy3ZTctGo+4v4J?=
 =?us-ascii?Q?x6iqzXyFc70Scye54nODtUD3bY5sEBE8nWsYg+GxBT9d7xggwitvkYhMiF+z?=
 =?us-ascii?Q?7/d7WkwdUJjXARpDcDWf17vuiSm4R3hsF4+atELrhMrfAVBU12GYBgtTH6NH?=
 =?us-ascii?Q?Cq5uTQldbuAKMcd74XOfwCJCn6kuhBvlx/0AwMlhEzOevvZQY92WkAdQNtJA?=
 =?us-ascii?Q?BoPqj533wWanqox6HM3JVlZ+olNM3lTg2dhhkdDLAERc/QFnbN4zstcwFA7K?=
 =?us-ascii?Q?DYT658FOfSOkpgfIkAIsvQGnj48ySBHVtDYY3qrH+KAgMUAw7cgPGTw9Qqkv?=
 =?us-ascii?Q?6u8sDPLA+1rJxZ6BJRStqdSGWoavod2d9QLUP+2VRR85Rkj9jnJMe+VJsqXo?=
 =?us-ascii?Q?DgkHJWoLhiHHVteY+c0MYTpOjV1iM7NKU7mTX/oI2Tn/tPM9AWZNXF8AUkVP?=
 =?us-ascii?Q?NNziZgzUUXdwa9pmYyIXWeKX21V7w5uy3JuYJaP9cjS/dE9nscPEFzUbN7wy?=
 =?us-ascii?Q?SeA8NZXVfZRphkqK84yKe89A7oyc1flIxF2jAzIn2FDINa5DiZYGH5WIw50B?=
 =?us-ascii?Q?AwbZbtuKAO9suOKsQI48FWsRRk8GMcBhuvbpWiua+ZshIhez9ULRgC8ekfNv?=
 =?us-ascii?Q?bYoxxUiyF/hQVvJdA254ewYhaxrVcteIWI1sYaAdCkON69nPQ0XWZilGKXz6?=
 =?us-ascii?Q?ir90XqE3RsfukplIc+2rhqwQUUHeEhoHP4063W5BYWvR8esmLUxT1zjSW/yb?=
 =?us-ascii?Q?AGdy+R3yV6v246zaXiD3MEDFbFM3Y/9kfyphkMMUnEAfCu6P8dZoftR3flm6?=
 =?us-ascii?Q?XDUe4DFvlsqYW40Ze/6qZzh5puWkMU5SaeOWlA2IqTKdJfwdAdQpbUP7HavK?=
 =?us-ascii?Q?0yIwQGIqOrdjMRgp72mThy2Fzlv7/B9ZfmysyT0Y07x+2qR8FR9pjjJ9f8Fe?=
 =?us-ascii?Q?z3do5osU1W2Q2VBAFFghgm/OjSxfdyk0Y4thrZ3SKYXBx8Snwp0b/qk8wP37?=
 =?us-ascii?Q?gTE+V3pckrM7iVY89QvQ7MzG?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a413f88-a326-47a7-4524-08d966f414de
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 11:41:16.0388
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2NFpZVuih2PEZkXx2I8avQ5sTb6uu+c1jaVXMzJRqN5nIeqZUT3zqJw6SSW6qBr+IIRSJRGgAjf4vcoJ4od4ZQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5696
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


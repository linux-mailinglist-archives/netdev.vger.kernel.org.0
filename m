Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E91244378E7
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 16:18:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhJVOUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 10:20:10 -0400
Received: from mail-eopbgr60040.outbound.protection.outlook.com ([40.107.6.40]:37344
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232974AbhJVOUI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 10:20:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jWyfdRfiIbGW5/a0+HfHfagdTnZ31nOsuItMOmkh6zJzq+gKMVQm3AWx+TS7smWgvXCJYY9viNLWe9GoStgXgDqWJiuJY2YhAz/NdtldLGJY4TZqcpfgp3mXmvtqkXJOaaXhz91r0nCAKRVQ/aBx7JeauzJFZKj+0KxBXbq5jLpARMiC1faLxVCH1KOJP4fkpEI5DHqkX9e1rh6ouheGzhS5YHbbLI46wrNhjDInO9xm1OxzfBOVivTiJWjen8Yz2xDZ8G3AJPsFbekpdf97T3O+gYW2IcwYQIMb6Gslp3TQw7HMn7PuortbWN7wJrOw6V9S/aP62bspf3U+EY9K2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uXPQ1kGmLDc4MxjhE3mZ9yd1U45r/8dJzMYU0u1a4cU=;
 b=SfKYXi3W8Bog0Tr2EU9wf6sX+OhGoie6CXT+VOeD8U7Z43wqII5Xeg8Pg6X6/2ZOZp9+sYR6JMJlwW+VB1O3jxK1sYjaorjAxG4mGNzBC6Vc2liUbMUeIX0lnkR8lpnAzyBmoRSAjQb7ansgS3mcsne4ZM490TfNNEY0l1VNwLzFhYW+DzO5cwR1mQR02vrINiQzZ0uKoYtKv7CotrPOED2GJxCaeixw4mnqDuQG31pcXhoS0N3ptJVPusRvg5ZXBMDLPBsC/9inJeY6ZXEk0rHprHjMpwEWtgcFgdkyQYFlmlmKoSJrj+SHFPEp1j20fnCoJNcJ3qxm0tWWHW29ug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXPQ1kGmLDc4MxjhE3mZ9yd1U45r/8dJzMYU0u1a4cU=;
 b=pIrq/cA4O7cuejio4ZXBhyKdA9E0hruCL3nWSDOIEn6LQiAmBZJpGlL/5vJur2q+SDQzT1EqRywh3gRqGbT5IqpYve06ixOZVOiGXYpDrQ5NTHNU8sZCw9pP1N+KbjIZhPFzOKxezxKoySvIcXtJ4rSLeMRmtXC977RWexZz0s4=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR0402MB3406.eurprd04.prod.outlook.com (2603:10a6:803:c::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 14:17:49 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 14:17:49 +0000
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
Subject: [PATCH v2 net-next 1/9] net: dsa: sja1105: wait for dynamic config command completion on writes too
Date:   Fri, 22 Oct 2021 17:16:08 +0300
Message-Id: <20211022141616.2088304-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
References: <20211022141616.2088304-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR02CA0159.eurprd02.prod.outlook.com
 (2603:10a6:20b:28d::26) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR02CA0159.eurprd02.prod.outlook.com (2603:10a6:20b:28d::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.16 via Frontend Transport; Fri, 22 Oct 2021 14:17:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7449d8bd-16e6-4735-88e6-08d99566b9e0
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3406:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB3406852AFBDC43DC46D27323E0809@VI1PR0402MB3406.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QIY8hlXDmfaEtbTn1IJKNQSipxZDy84xh9ynhrpYDuHBytQDE0zP5Ay7nZmkN9pALcHGOj2axYAdgCUtaxetu75hGaL8wKQzS0Wu+EG3Jof+JKROUYXO7rKkvFN5rApKZ9aRKRtKbUIFNeLUnSQhETA9jcIfh5TLzX597NSOuTzhU+ZxrqY1HY5wYTqBxvOpF87qHxBPleYisHqdW3a2PzORIAXEUqXKKTqsTM5tcr68rK+4wriXW0jCBw0JJXczgXHhPLzXteLpOeF0eXv/mdFL0/FHnVu4NfFM9fuXqDEto4S4VGyUlSHc75ASdv3Uvq0g+wm6boRWYjq70dWEJi3B0YqHpjdQjQIWF9p6oRb3ZG8h4irGYx0h4r5tWQAQFBoa4tMCY0o3L92W3RAYO13ND8jfIfyE11mugSGwuuHq545a6l1kvcJYmvh4P1W11Fzlss7phCqnDyB2MtNf1eFxi4nnaPa1IgW/6DAJ1L8OE2J0ziDcRbf/kQtkbfqw6eiwucOUZ9ChsgmGPXlXEcZrkVeVhy7qLYl4ytKy+O/UxRdigQSI1Gf3y5xmtii8youH8TjCzQOUEEbXtCraGa6kLfXTyyz1KxjJCFR1g9VuzeH0LT/3ULaGWcf85nrEwnfw8cHoPnLyTQb4e49qFYMX0Dt/WMOafXB40WHv3GYBJgKdr/+1BX7bixJ+o3edXa8jl62IDD1mJmUVATNxng==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(7416002)(8936002)(44832011)(38350700002)(6916009)(956004)(83380400001)(54906003)(66556008)(508600001)(66476007)(66946007)(6512007)(86362001)(4326008)(6486002)(52116002)(5660300002)(2616005)(316002)(6506007)(1076003)(8676002)(36756003)(2906002)(186003)(38100700002)(26005)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?36E+/rtCU7WvFpS8wMOD/yMkgaDvNVH7qIMA4Y9U+7JQ4KZD4bxMzS4zz6gB?=
 =?us-ascii?Q?UyVGStB5jkFjqyuxrYI+Y+P83vTM0TOHt18oL6VjxGvXrhx422P4o7RGQpKT?=
 =?us-ascii?Q?6E749i9lPIBKxae08O7IpP8WQZJwSMOcyGfCgXQJkpoVqxZiJINRFuylEqvs?=
 =?us-ascii?Q?wSV9fIXiU4Obj2U4GEVArg35ITCZhuW4jZhNuNhrthL+Z2Iqx9Hh2lxAwzXh?=
 =?us-ascii?Q?rDTU8Tzf7W3l+O8RZXEK51Uhbsugk0Z5X43yB6rP1Y5n88yLdRjLcdozN4dd?=
 =?us-ascii?Q?AUHKqonO4sihUKcpHZ9qP709CIncDOeT/v2LLyffmtctZVUzvIhKLsp712LM?=
 =?us-ascii?Q?YBpGPGTRUTZPRYpc6jitdAjgW7h+Lv1PLVRtT39YxNgPJ49kQpix3hMFNRxQ?=
 =?us-ascii?Q?McHKryeSUnqTDWfGgwQG/Z1gKYgTrI1oyooBXI1vn20W9lPnCRlWGjCQLoLt?=
 =?us-ascii?Q?2G/sJgQbWp6WBL8Tcm9ZEk6SiyAhD05GFJmHm95wdfmxG9h9r8DRnFjeh9cw?=
 =?us-ascii?Q?1e33oLFsdJEZysWglQ8qrOcyOI6m/k0GUGj3XB7jfk57+c2E7p7w2Dgz+s8Q?=
 =?us-ascii?Q?NJeBnqwHfU44SUtqBCDLF6hRv4ebOfMtKzix3QCdiwC442V2eD0h1Hz7ksaG?=
 =?us-ascii?Q?YcOdsk/zQOdxjdyq6qRBef1GyJMENLMz8uNUFkkSXRbLau9RP3ReOnnN2Dp1?=
 =?us-ascii?Q?KCah+ygT6DoR98rnUpPLZ2sNyzRxu9kxBMAGzXcS2Tjglgp2l/JJAw1BawOv?=
 =?us-ascii?Q?nufhH1MtM3pVk6U02y5Zjb/zopmEGHiemLu3GY2Y2ThLZg2dSBTQvPpP68Vc?=
 =?us-ascii?Q?2QxO8KZb8sF7zIegYZHhzjKRL3LYm6yt4QYqsDsBhwHdAVydX6v28y0qc0J2?=
 =?us-ascii?Q?L+pfHgouPOeGEduv8JOHalQjOChX3q9yHoOv6sU/IZzyBqGs2jb2wXam78VN?=
 =?us-ascii?Q?l5LUK839t4nvJ17qNHacT3HsTkPa3OTj5UsDjj55AMSK/6vk3cAq1fJN6mQk?=
 =?us-ascii?Q?Y/Tk81pdx/SUdbRzi4RyUTOkTCXNKE0zuYmieUm3ZZ/k4b4gYGAg7fzziISU?=
 =?us-ascii?Q?evOqpD+XXaxfdFfMaHrYefvVZvjAdrIkgfncgi+QUPmXycqbJG1ORxjeIt+0?=
 =?us-ascii?Q?gQWLUeg89YSs7UhNErTY5g1nxxLz/ocgs/Ro6fqTH7Fd02nyI1kchohizRhn?=
 =?us-ascii?Q?uZytFjq95OzcrSoRaoPsFfR1Pm9NUZHHnYV4dEBBUFGVsUHdn7aLGg+cg67a?=
 =?us-ascii?Q?xabuardtmVNIGeJFmsW3a0+tGeNTuEf2TOoxRqCW8ib5CpgaopwzFJA0f3zX?=
 =?us-ascii?Q?fOgtlT7js84Ztsz8E8je3b6Sq/mXNHN4PfNpzDrj9UZa4+6/i5euOjGnW3c0?=
 =?us-ascii?Q?W0BdBxUKPCg/blFhLWTgue9/z9FfmbRcorqKvA+lXiEtRkQOpCsmY1e4bGy4?=
 =?us-ascii?Q?rjUY3nNXzUmXt3HaTDQfP8GTLUqYVyII?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7449d8bd-16e6-4735-88e6-08d99566b9e0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 14:17:48.8707
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3406
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


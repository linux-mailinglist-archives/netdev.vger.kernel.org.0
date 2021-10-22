Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 236D4437BE6
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233657AbhJVRca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:32:30 -0400
Received: from mail-eopbgr150072.outbound.protection.outlook.com ([40.107.15.72]:27678
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231893AbhJVRc1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:32:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GxsDp1d0B488A01x85QkPHpEUkL99gZn+g+PFqCerXXZTRufPmVGW1qYsywycUODp1vygHHhtSsc3FVI9QD2AQKyy++5tZdJfFEt8safzb818GSLb6zVkxlbheg/lGXIi/mz2MMjggbb4laFyRatiWXB9ErjhaKzx5adIeKjQou9pMEvnQIfvmEWCyBaZIhvZy+Ipmqb6GOz8BT0JumT0MpxuQJ7uAE/Wi0Cv0NfpDQLkmPh4VRB+uMwE0XCVhXHMH/bVMBN3+Ed/v1sKQLkwanNnKUscRUwBKe1DFQUwdt13OlYzX2y9xhyEcbczW+rRaxAQ/R3GGxJFmVmP5OHXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uXPQ1kGmLDc4MxjhE3mZ9yd1U45r/8dJzMYU0u1a4cU=;
 b=kUKYjH1Tzr2fet8uUYib8iqej/yad9+X4t9pStzRSYLByOUw/tkocf4Aj/BcQjroUzEuyrI4lVTd4cps9rebjaEFqdFzsItvFeSmy3fy9RSZSaoAYdr6VbaRRr3JfuofRlaap6vhi0wCA2jxRoNgZird9yeQGKBStZ1QvXFaoH54kH3Onu23mVlIhT/JNfQi5EzImwWG8+Y3RJAlIpX3xxpAxoDzNR6GA8j+9anDYXxd8BKIpP78bAbpADPpteVJGUoKRWZ/dGOOt04VREeNqR0yGvDgTZqyJGjmWVty5/Q/kzO5GRJ447/MNEGx1xLcCTnGxf7X45ofmZP3ugyxkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uXPQ1kGmLDc4MxjhE3mZ9yd1U45r/8dJzMYU0u1a4cU=;
 b=gV+OqJa7qUSDs5vqsASxX5CIXXdkUlnk+pSnTIv1/kFgk0D+liqYxtnKRnbgqR4RHEombDDPcVos8pJ51heM4CGGLrWTJCw6b0ok6q45IfZe31/j3OnCd6Akboo5Vb2Fq5LJMGjgyN2TkltsBuIZsWCnsZB+zlNutp5XD+GKTVw=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5504.eurprd04.prod.outlook.com (2603:10a6:803:d8::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18; Fri, 22 Oct
 2021 17:30:08 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::e157:3280:7bc3:18c4%5]) with mapi id 15.20.4608.018; Fri, 22 Oct 2021
 17:30:08 +0000
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
Subject: [PATCH v3 net-next 1/9] net: dsa: sja1105: wait for dynamic config command completion on writes too
Date:   Fri, 22 Oct 2021 20:27:20 +0300
Message-Id: <20211022172728.2379321-2-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
References: <20211022172728.2379321-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0003.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::16) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
Received: from localhost.localdomain (188.25.174.251) by AM0PR08CA0003.eurprd08.prod.outlook.com (2603:10a6:208:d2::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4628.18 via Frontend Transport; Fri, 22 Oct 2021 17:30:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d77cdb2c-44d6-4774-a6df-08d99581980c
X-MS-TrafficTypeDiagnostic: VI1PR04MB5504:
X-Microsoft-Antispam-PRVS: <VI1PR04MB5504B9F1928E63C887D6C6A8E0809@VI1PR04MB5504.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fz/g92h6/VAUR01esbZQU+ohrI4p5FvYLihm5WmlGSQu0UzofLZ4c2krh/cpfFDEodrWB2JHLhRDAHFLVXKuoLpe+PbbXim0m9OPtEEMEnAIlvkTH6q7Zzvbd6CE7y7x2Qng5jPW5V+HDCN0e6tPmNLuSopu5ogYDhHQvB2UiaZzhq0IpitRr9nqMoMNNlrm+j1JJ6wK9k40NlryylMPGebLalTkUvodZZEl+wkKag26PPT+1ePw52Q77vurHuLRuk/vCjWtHsfR5A788Uu2lE6WfyG8upvKhMZhMUCPydgI0ajMPwYH9gxzmnfVaC5IPRuikNxN7xQxVBEKiHBDRcYMdiWPhPnQoCwX/LmeseO4nzkCn5ey9OoP0czlEmX17kSyL/idiSxJAVohGVkSBitaGhjrpA+vT/LDR0QcUX5trKOqrVWTWwoFB1MbW23xdEPY/vtZNquMnO+ttOa3L8Up3Rwux6kg9O2cTXs0cSpj8prtfL632Z/qjosm2j0lJFHGtDSl64ek4+N/xM/0/O+TU/TSrgr3zKzOJLF5OvVcS98W64A0UecnsWyNmijTMFKLTf9owttZIw5yPAEhMfd0yQBgKi7/fy5SywZpY/7uSkHP/xVtxb8n3MLCvRP/lBXf+68rxsR3+tKr+6NyyV3dD5TTNN6shvKFF2iilLuWJOC+KZ+QAzMSFGKHeAbkRhzuVHr+yFDy+IP+XGoPww==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(6506007)(83380400001)(4326008)(6916009)(52116002)(66556008)(38350700002)(38100700002)(66946007)(44832011)(6486002)(956004)(8676002)(2616005)(86362001)(36756003)(8936002)(6512007)(26005)(2906002)(66476007)(5660300002)(186003)(7416002)(316002)(54906003)(508600001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?vs2A1uwOceKTyn07tCfNOSf2HPBS7B9+9NDwGitV+B32H1uaHGcmniucJMGA?=
 =?us-ascii?Q?zPVlXrWXwlSXPTTIAkNtPXUUHSVl0vdyzMDxLJY1xqqqRHfAGJ9ogmpn3ywh?=
 =?us-ascii?Q?7XYI/3UHFeeCo6vnPBJACvEI7Bo3qYZ9yV2ha+idebBCbfTcDAi7Cm26/ioe?=
 =?us-ascii?Q?/KgjWCOZfUI5xS9FXx4BKQDhFeLLr1k3l98VAFmm1F/krnvoZaLB3JHkK5Yb?=
 =?us-ascii?Q?1g4wKd9n9H+CV1DIE7398kb3Aq+xbp3IZDztDQZr1rWQBh5/S11TSQrO4A3/?=
 =?us-ascii?Q?jeT4SkxEIhY7OW5oepTWTMxsYRlz1aDWNT4Qu/2dYdfZ5fBGPGnLZ2m4foLR?=
 =?us-ascii?Q?DR5RthY0qUpkAHy1ZcHJkk90NltHXQ9npU7EkGe5iOfzU0hBVG9pps2zR3G9?=
 =?us-ascii?Q?yL9k71sJ2RhGxGA0X2BCtVNpHJTgJQWHk36evN8O40ZIjyYgyjIz5qv13kSU?=
 =?us-ascii?Q?8ZsYpNX4m6nDpQUIL/oQohW4ESrLxE/5yIavXwidRkdU1/M5seg19hugWdRg?=
 =?us-ascii?Q?PIjNFCdqGFM+qYBnmBD6ekhBkt/9UW4ABmUNeAMJGtduj5G1Cy+9Opih0iVf?=
 =?us-ascii?Q?7DBsezJ3gWfVdqjG+B7Fga25i2AnouITqgA+WG/Q6UErL07wpePTVFsoO9QX?=
 =?us-ascii?Q?OUH0zDNpPjMG9z9nzUsk5wPmD9z15JsH8elfRuqpFhgtmUyNmhTDBXaf7xMZ?=
 =?us-ascii?Q?Z6UCePKFObqKMhZYVlal/AqMiVCGui6K2TZUD2kJXpB7uoOQAz/Kuw6zi34e?=
 =?us-ascii?Q?ITJrHWl7RgQRET/Q34nTy7y4s1nIsMETWqw5FnkLZm746JzoUNrtuIvzQx5s?=
 =?us-ascii?Q?fBS95DPFLxWWhw4AhATGrG+XWHyOeFbaD3mKpfBvmuRgX7oQbR+9j6Z0t9AG?=
 =?us-ascii?Q?jEE80Mme/wVFQk8Wh3lWcve6fIzIJC7paMol5/x4gONxs1riBwzPicPneohH?=
 =?us-ascii?Q?9IsL3B8lF5bEA97hW3n5pRsFMGO63MMoOf5Q6RpDYTIZ3UbJeUelnS7qVPFq?=
 =?us-ascii?Q?c6j8rKjNzSQYIK0v/OeKgo+pYnvLnJkyGM1D4lbVwFNH8ZMP6pM3bC+En2Pf?=
 =?us-ascii?Q?Nnjweuzpu6EMMza+CBFuhT44a3K3GqVv8aRlRCmjgXtXulbE5mNpF7cxDJNl?=
 =?us-ascii?Q?2/d7oBiGsvs2/rZflqBZJ/6KycpVAc/80G97bOvZXYjqGFZnzvdpCwlijOBg?=
 =?us-ascii?Q?m58uYfu6qZQl8gWCNYNB0UklSozZ1+6lGy0jH8dsIQzFyoEionaxitsIK4k3?=
 =?us-ascii?Q?DH9zENpeBgEmAYgKxeWSOOplB/c0ProSiwGp9WCwxSaDOqZDcOCXWfdNSUIj?=
 =?us-ascii?Q?67KcIXjuenIykcjzjwCyAECROU+jAcmOULwpYgXwW/ScNH3bUgLfgeoxqoLs?=
 =?us-ascii?Q?VcWU4Rlq54LmwCAhI68vjb80A1G9FrxrbN37P+cEwG+AwoJThKa0w1xwL57I?=
 =?us-ascii?Q?RQXr8/XOqrmQnMugoDTUBmSUOpDflaS3?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d77cdb2c-44d6-4774-a6df-08d99581980c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Oct 2021 17:30:08.5760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vladimir.oltean@nxp.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5504
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


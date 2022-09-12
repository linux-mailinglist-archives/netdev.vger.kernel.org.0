Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902575B6105
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbiILSey (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:34:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbiILSdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:33:43 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20042.outbound.protection.outlook.com [40.107.2.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518CE4D255
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:30:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LXzkZXz+r/NYEH04/0AhZUUhHMsnKEseBnAb474QqHoZXGxQhx2TCu0vz85JdXVOTzLUTMMlqvHYzoeWcIb4yKB8Rr0rX43948xlE78Q8D99Nqaucv6zrL9TCbQppJJB21UvaOnd6LcLhwWUiEr0TVQqAIOTDsoabGYdYJ9P/1HnfoBK0rkUirVoqsYQ3kOAWwb/CMYW/kFleVqvbjSJqTm0AuSxKKJi1uCQ3ZG1B08bSYo2eayb21INyHM/xoUFMgdU2ac7VGHh3bWjT5W79yH8TXQtW1xTeiy6D+M7EM/uGG9FZYxxBXNJbihe33bb0H8h/tY0yQ2aKH5qdT5Dxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PdgiY55nIelkND3JN3Z82Lz0ILVOIEBB2drJqxiK5A4=;
 b=D8z94FbShDB5IH2c7fgNGXec57xU2gatMfLxc8pwOkOlXYA39pdw7Ty8hdw6KXhjM2MUw/BmKMNbS3PTX4WOxUcgCM5fEjeTZW8L/MTJuJMx8WdX6t63ne/jLTYBMwfExt32/I8+1V6xeQp8+UetPuNYalhMw0mY1pg/vXqMD+RIn/7e2QgEm0cbLsXDorYrXNNpkZyBLVpOWAhi/EZmB7YcKIaiZ/lYyy9mCQZMpp2VCrFznHrit4zpCeDZVCNQ4yD9pcYnShFOZEAOuIjQD+A9ymYJvzNdi1ax3dhEyfmlitvR8kLpnq9U/jTMj6sGPXjcowHdRtDiKt1zG+aR5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PdgiY55nIelkND3JN3Z82Lz0ILVOIEBB2drJqxiK5A4=;
 b=bfMg+zeCvEqiUSBEn57Rj9OGeqKYRVPEfI+AhpyJUKk/uTaX9YKGRXG1esr1P662boDiruUYezR2ndtbJFswxxINP/KuIZoUnUzgJsHBjgIr2nOqCDaeP/WccNMdH1KwxnitFCIY+D/jLQ2YydAH3Ncmthk6BmHxbJxwEK4hBZ8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:28:59 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:28:59 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 05/12] net: dpaa2-eth: export buffer pool info into a new debugfs file
Date:   Mon, 12 Sep 2022 21:28:22 +0300
Message-Id: <20220912182829.160715-6-ioana.ciornei@nxp.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220912182829.160715-1-ioana.ciornei@nxp.com>
References: <20220912182829.160715-1-ioana.ciornei@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AS4P190CA0009.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:20b:5de::16) To GV1PR04MB9055.eurprd04.prod.outlook.com
 (2603:10a6:150:1e::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR04MB9055:EE_|AS8PR04MB8023:EE_
X-MS-Office365-Filtering-Correlation-Id: 684d6288-9ef4-47c7-9382-08da94eca880
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 07trAltgCOgK2sP97JE2LfVOQRX/n+mfsbFuZGDhENIU2uFQyM/GNWzWR1f4/mBLROv1ZQc5zIZOs+x+rj6l4oRVIfot2zLH/nT5Y0KdxPhbrkwTYLCQY5kAURbc+EmTNAfDUMm5Ygl0OU2zrQyb+sbCt2N3SGV5xtpvYWvVv9olE6QbePuLEn6PL0gFN+85u/4Rr9YRK5HZxuPMrzyCTU3bFUzu1E0RSgQezais94E9L0w0sR9N49VbZCzHAY/aDnxBoAyY93dpobPrFPbD2fIs0gD03B6of7d8xYCqy0td6VMlH3ZtXQCKVP2MI0k3NwknNWr5j1XS0ZnUDQcX9SQj/Q7i9kIwjbSshrjveShmpfsytZzhN7bjsTjAXQqhHD5uVZMeokNvgN0xMF0OqW3so5FNdVXhx3lwnNW+VcCfREnCPoJlO75NThMVOvXUgrI/x/0FDzV3JvJhn4cpCgduPQRSbJCMLkMwsBLPFVFQrLUYgXc9YkCFM5FjqP3d4RaGpPiNRFvM7xQVU+ZnwdzHCc1leEw5qWkLN6wYW0lbHFMVBxjz64EXR9hLbgbvTa4jFsAyzJFI/3eoyqajanwXTv+vDXY1yFvSyDXjDmzqr0L3ChPToo6Zz2CSqg8QOMuJ0BzSkCm2i1qrzdf92dZIyIqp/3dlHUwF/cL+4wgvjFfBjSkFdzmRTrnLiZEr/Szw8ledLfY62wtP3E0VHIRB/0ZUTy3VlwG2/dndun6AShYHtmShMquVw86xVq4O6rjM5IjD2hEUBIUHc89Glw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(186003)(66946007)(52116002)(478600001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8iwgf474M2ntUWMBf/COPMSMu1wXhuihZxv4jQRrAI/txqDuI2d9p8xq6FWP?=
 =?us-ascii?Q?5gA8k9SEJ3B3B9ZEWtwQvfcXBPwj9ZVzWH3qePKGCBRyMCDJTGUdTj9B8XR0?=
 =?us-ascii?Q?J0DOdekUCEvE5IjmVlkBk0Oyp/VH9rE1xwuvun9w6PeqWx1rcJkdGn7IAPgc?=
 =?us-ascii?Q?YWXv/gvkkZ2S5OvKxaCZTUmkXxxMD8kBBjJm2i+TXlUcurlJT8uN7WQD4ipC?=
 =?us-ascii?Q?hvPLIZTc86ojDLKIB+7H3Webv/uvSjlGJ6629lyAh7nyknsP1um2YsQuRxTG?=
 =?us-ascii?Q?t56As1zfJxDKayA3XYtrue6rCsfJu+1fxGw4/dcTF0AI4PqZn3QQLN3QqLJ6?=
 =?us-ascii?Q?2kyW2fvzocM/oACDIw/m3+3B4yfVnkqw27i0rajN48R12ECEL/rGs0JpRAho?=
 =?us-ascii?Q?U+jVvfaLk3VNukjxpmXRCJhj056SD3Rea6LO+4ocN3uzQRtIX9slF7WufCyV?=
 =?us-ascii?Q?ugF4vhQWSk5q17j1/0zsDut7bG14vCTmjDkPfErBplSTgTeZvH2FxgsaVcAF?=
 =?us-ascii?Q?gN7NIVLwAyCVmvKXleW0v94dVC7ct+iovg+jHNXrbepWa+VbZPMdlDV/pY5s?=
 =?us-ascii?Q?slF6/XpdCgSbBWCdZRYamwI2zexZlH6mjRR2z6pSjfDNv1fVBGYDk3BWTs9k?=
 =?us-ascii?Q?BbP77Jv56X9iFzGjIKethZ58cxQlcX1QuzZ3mchOPZ3yzwzb2oakBa32HgGw?=
 =?us-ascii?Q?wca0Z5izBojXgWsNXqNAJX5yl54oBRYNCWBcahCWPvxA/IDuFoOtXsQVN/Ks?=
 =?us-ascii?Q?CPVDdJSENI6qHp8Xr9/Ev2hXQKVMcuFaV3OOHvzEG8KQP22OILllDPzNJpBL?=
 =?us-ascii?Q?HFxnMp4Rz9XNQhOW+DSaocjSlbGW7RCGgiCb6k19zD2NU8lM54NdBre5xn6R?=
 =?us-ascii?Q?gbFu4dEHkvEB2eVRcqtL8XZ9BjYYKmNEMsYF8R7iP+YGSdlTgADhmfZlpBaC?=
 =?us-ascii?Q?+x+K0KgoisbwrNOt7m+xc8hEpeCRmbfH/KuxKlw2CZiSmIrhnQuDf9kKF3jy?=
 =?us-ascii?Q?51xweln61hVvdsILsY7psAwueSMVos3f825lWfH3wlMVbYlCN5fsQkY+mWml?=
 =?us-ascii?Q?WzcfSbsHySbhsU6niV7WvvMSFaV0V+ABi1ApbIZOUVIlJ6OK+OYqRevjPVhQ?=
 =?us-ascii?Q?cIfvw5Qvrq4DoLKKwiauH6Em10hkiTT2858xaNt+xLICDoK6/P7050Fe9Kwl?=
 =?us-ascii?Q?5I+lemztUjFS+zWqwVe8nHNeWP9pV53QqNCLIx6gfUncpcx57T4nR9fhyOmF?=
 =?us-ascii?Q?4t/Y4vXGDztcBubrdqQisvOmTLFS+0anMjGEe4DAY3Zve3bQLJ9GbJ4KUAcr?=
 =?us-ascii?Q?VVBysRW10bMpcUnv2v6QkZVkerGhtGuW7KTxjIQUwkiu1hFTtYDFPtpCBSPP?=
 =?us-ascii?Q?nyrHqPHurJUVFk029VufTfe7IfBrmx4e/R1ooDUz25zqJ+qQJ9iYgBBzmDWA?=
 =?us-ascii?Q?/wIsVwSMsDSG1ALwLKQdhj59eqqvQr6XOaf3ClCVHTLkdXd+GMzPs+LIM5Mv?=
 =?us-ascii?Q?JDYXw0fE5ZKmD/8gmu0kbLqzRRKEPtZSl3m+GTjhouoNjTsErxfbeA+k3Z0E?=
 =?us-ascii?Q?/AMpt5MpeUMHQSdLT8OREI/sPe8iE62CIef28Wai?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 684d6288-9ef4-47c7-9382-08da94eca880
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:28:59.8090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JYuFNZnp0jxURyFyv7mHyjqXi/CWps699VMh9LxZpc5Nr8C+gNtM0dtvxzM0lursQQWKUv/zvyWylaXktVzEUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB8023
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export the allocated buffer pools, the number of buffers that they have
currently and which channels are using which BP.

The output looks like below:

Buffer pool info for eth2:
IDX        BPID      Buf count      CH#0      CH#1      CH#2      CH#3
BP#0         1           5124         x         x         x         x

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/dpaa2-eth-debugfs.c       | 49 +++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 54e7fcf95c89..1af254caeb0d 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -119,6 +119,51 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 
 DEFINE_SHOW_ATTRIBUTE(dpaa2_dbg_ch);
 
+static int dpaa2_dbg_bp_show(struct seq_file *file, void *offset)
+{
+	struct dpaa2_eth_priv *priv = (struct dpaa2_eth_priv *)file->private;
+	int i, j, num_queues, buf_cnt;
+	struct dpaa2_eth_bp *bp;
+	char ch_name[10];
+	int err;
+
+	/* Print out the header */
+	seq_printf(file, "Buffer pool info for %s:\n", priv->net_dev->name);
+	seq_printf(file, "%s  %10s%15s", "IDX", "BPID", "Buf count");
+	num_queues = dpaa2_eth_queue_count(priv);
+	for (i = 0; i < num_queues; i++) {
+		snprintf(ch_name, sizeof(ch_name), "CH#%d", i);
+		seq_printf(file, "%10s", ch_name);
+	}
+	seq_printf(file, "\n");
+
+	/* For each buffer pool, print out its BPID, the number of buffers in
+	 * that buffer pool and the channels which are using it.
+	 */
+	for (i = 0; i < priv->num_bps; i++) {
+		bp = priv->bp[i];
+
+		err = dpaa2_io_query_bp_count(NULL, bp->bpid, &buf_cnt);
+		if (err) {
+			netdev_warn(priv->net_dev, "Buffer count query error %d\n", err);
+			return err;
+		}
+
+		seq_printf(file, "%3s%d%10d%15d", "BP#", i, bp->bpid, buf_cnt);
+		for (j = 0; j < num_queues; j++) {
+			if (priv->channel[j]->bp == bp)
+				seq_printf(file, "%10s", "x");
+			else
+				seq_printf(file, "%10s", "");
+		}
+		seq_printf(file, "\n");
+	}
+
+	return 0;
+}
+
+DEFINE_SHOW_ATTRIBUTE(dpaa2_dbg_bp);
+
 void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
 {
 	struct fsl_mc_device *dpni_dev;
@@ -139,6 +184,10 @@ void dpaa2_dbg_add(struct dpaa2_eth_priv *priv)
 
 	/* per-fq stats file */
 	debugfs_create_file("ch_stats", 0444, dir, priv, &dpaa2_dbg_ch_fops);
+
+	/* per buffer pool stats file */
+	debugfs_create_file("bp_stats", 0444, dir, priv, &dpaa2_dbg_bp_fops);
+
 }
 
 void dpaa2_dbg_remove(struct dpaa2_eth_priv *priv)
-- 
2.33.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D662D5B6110
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 20:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230369AbiILSfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 14:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiILSdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 14:33:38 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20042.outbound.protection.outlook.com [40.107.2.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447684BD0A
        for <netdev@vger.kernel.org>; Mon, 12 Sep 2022 11:30:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T/gHl6tRtnIoKeG5KcX5tnkbplXM75c/t5hQygK+ln1BlKQWVDzBiipRU7lKuldpJA4OVHEDQIIyFU+JGkbIMWRvTqczluSlQg25jX4adbZBLIKe6jG//N5OQLKCALYpk3NAK5icRbb19HUFOkDXB6gDLYLt2Xa/Av79D85qzipscAlom7TFmeRQEq4Iuo4sJqQl905GogvqKm+mbcsb4hkMdOGYPloy0ZUTztXD7X8cTyPhiK/Wa5OI8LyqQgf0OtpNMUw1odUzMu5/U3U6S/1aPb3yqCw8O7uG39G/qCJiSi3Jj0pSMb8629uN11mxzQXNY1U9ceFUJWx+rc8TkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wRBl1u6VsBeC1vnom6AL7Nm2sAD1vN68dEkrP156Um8=;
 b=LO1XZXjTGJqRJXYL/YNgKwAZQXhc6zWKVNnKZvkSaIy8hQ9r0kxcYPnbJX3TtD6drBRkZBTw5y5CWucx9lrwKL6OdSdVCqFkJFDTOBYDQS/9tyi0wo3KbX42t45Cl6rhrnKK5lKR1cwTCfKjR0pNUJ/wPXC+vJ8wjvPoMU31cON70xskxIcA3u8NtWQORNXsXdoVp5VDBH9J/XHbFrv0kInBUvj6Qdt32qZRv2Hj9PQMcLDKzghWr/ASZhFY0y524W3TA2tdCPU6aWQZavhm/yNYciHsrvslYwr6lzumezHNtGleYKtrAtSwKRDsXuBYJG3GFPMLEiTeD8/5b5jKlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wRBl1u6VsBeC1vnom6AL7Nm2sAD1vN68dEkrP156Um8=;
 b=QZZX+IWV41h+2+B2HPwA4lG/Veps1wMfQrCmztM+7n82QReky+PXqYVq7Zsli0jVuCAp+ghK00nu3fzzn1MhEzpETOz+fJdQhSzSv1Tbj4WsXGLgcL/pNgDEsLTer4+Se5BrwXIpCVsdpvJ1JylKDjVS/r0yf/6grCx0AXH7vIg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com (2603:10a6:150:1e::22)
 by AS8PR04MB8023.eurprd04.prod.outlook.com (2603:10a6:20b:2a9::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 18:28:57 +0000
Received: from GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90]) by GV1PR04MB9055.eurprd04.prod.outlook.com
 ([fe80::d06:e64e:5f94:eb90%4]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 18:28:57 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
Cc:     ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 04/12] net: dpaa2-eth: export the CH#<index> in the 'ch_stats' debug file
Date:   Mon, 12 Sep 2022 21:28:21 +0300
Message-Id: <20220912182829.160715-5-ioana.ciornei@nxp.com>
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
X-MS-Office365-Filtering-Correlation-Id: 17350a67-7df7-49b0-f81a-08da94eca796
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nHgIvptRyCw+QF3/6igxZc3HIrs/DwVT/obpT0VPfFqqRgguN9y7sjggrOqnSu1yUB0EzArR8Uctmv0rcjwp6GKJiIIp6rauxSYAvKvcfrMTzEELTpMV/L/8uyc8KxARPDObWFFjcDJq8WO2oqU8cZzg4p0sgdZ1NWaBVm05sKTKimaj4stw/O897zSO5nbSV2a/IKkeqsMkbF2gKDeSBEf+Da6eHwcEI+nTuxIdVCRCfzVsgfQIatNhWgSCRLwACVFLFm1JB2KwfitBiPCw/hQb9889sYpYCbAIxTmsli4mp1CqeS+WbbsINGEm5LYgNZrKEpJNgHHPwZBDWJTv+ohXqVwfrCo4unewu5Y4oR6NH4Jd8zZS+DOeO76gVk8/EmEY9M3kSVZNUaYKuZCkNMExots413cQ6e84i8bkN5kr0ZFDEgl7YoaqdIrabjIMLpnPHGDtaic0I5+DixZWlUev/J8+uS2PmHV9jumOkqDXtX5o9QdkEYyX34HWUAg4FI2lKypqBS+giwSNvjk4otKlonOhUQeUCSaTDbdZ9fEEd2r46DvmaD+JinF2Z/nom8Ra5OMd6N17f4uCJul6Sb2P3DLsACj5f8K7mqv+WD9MtreNoFdDxXZObVY+Jo7G8TV1jFtdqbXfTdkCwsQLoodGSsbekYCffJNFg7LnUuT+rB5nGo9KXuUHUaGHhchqbvVfKSZP9ea9SihJDEKH+iK16AJmXwLNU8VBwcpr3lyGXCtc1iKTA7DlOqS6C4veejEdfgii+hMV+T3SkiFyxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GV1PR04MB9055.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(39860400002)(136003)(376002)(396003)(346002)(451199015)(4326008)(5660300002)(8936002)(2616005)(6486002)(1076003)(2906002)(8676002)(6666004)(316002)(36756003)(41300700001)(86362001)(38350700002)(38100700002)(66476007)(44832011)(6506007)(6512007)(66556008)(186003)(66946007)(52116002)(478600001)(83380400001)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6HWJVfvqXT2PrxrkEad73ixkjdkLS38+acm5ilm2YVjb68dwNzU4/dkDRK6P?=
 =?us-ascii?Q?KPyFpwGG6OjLzSdNJxE9Vt6Q3NV0mKfo/l0bYoLevPuPbgvER7mpCwc6vaAw?=
 =?us-ascii?Q?g3fjSoBr/Yo7b7pTVTk5BjQwm1y0B1b20AK0rt23JgYNtXOMPYTO2mdOQv4g?=
 =?us-ascii?Q?KLmH1mSRGrLJ4cs75R/2nKNY2RIb6rk48wIg8HaT5QQymrEqAU6rKEOVKl/m?=
 =?us-ascii?Q?9Rq6jyQugKyKH7VwjlmKNUTu/2WXTLWWzpzjiLqliTyxqWvSV4JyCZLPjhHA?=
 =?us-ascii?Q?q2Y349o355++96EH5dZW46toqfS7mPaZDvp0hxqRLDZQCcIFK49B8wsPJ8W0?=
 =?us-ascii?Q?loMdUM0tRPymI/l1mU7qSibLSNxQiNCYrH0ScFYygRmBEj1s6jHiIqeZLJs3?=
 =?us-ascii?Q?Fs9NoSERtaK8HJQnRagZUgGJ2UflbRliWOR8UUBlNDKMXkbFofLG4cP+S4bz?=
 =?us-ascii?Q?4uLPgiGC53bxXfO1vhcH5i1DrM2jNsQPvtoFcuN8ekS5n1INDvrimRqFOnaT?=
 =?us-ascii?Q?4ccigPG9b9JX8ptiJyuaPY922Pea8+pXTHkOYQL3zEPLp38v106W7yJvc5/Z?=
 =?us-ascii?Q?HZtR5carT3tIW1dy2D4V4/7VIH5NIPDyzk4eXwbqkWT8CBJMMmE/hO9Q6D2P?=
 =?us-ascii?Q?ZYQup5eHnWW7b6iRZQya9fBr9QrAVah6JaRM0ciclxSvFaiw1XFgyrPQ4+UA?=
 =?us-ascii?Q?4TjusEqJba6TrugzZjS+7leSyw8ZeKEBz3X70BxbAibm0UpfpFDmMRp+Je4H?=
 =?us-ascii?Q?+nJlDsOscsOcqDODh+Nzf3k+nVwfUwr+s2TtrECyFMGTS2Sp4UFhqC5++Lks?=
 =?us-ascii?Q?Le0rO4p9e7Z9SeoMbXuGgLqaopnYWG0/xo8Ot2G8nJ2+sgfdcW7a3EWHcRRT?=
 =?us-ascii?Q?LhTogXT2bGFX6NPLNjo+oTn0MUAt20XlV10SZYbAatugllqrJx0fzjQObLf7?=
 =?us-ascii?Q?DotLMbEvGboZ4lXQolrbLvPZp5q0XlMv+f8E6PNl79LskWfNTVEtt5E6XCm7?=
 =?us-ascii?Q?/zl281Sz1k4RBHvGPAIyDxpdltZ8tXeaZ89bk0gKP403MNgTo9rQZhSIR3Xc?=
 =?us-ascii?Q?ELBYQm7w0AdvvkbhQMCIXGSHzu/ZjuUKQM4EDv2Aw5ZxsmU3o9K17lLwbEfT?=
 =?us-ascii?Q?KBTJUTmIMQ8iiWWmTzQAUlIZ/JswjwgoZQaIvb35ZmbyQtozUJabkMCb1ncr?=
 =?us-ascii?Q?if3U5bobTx+sCmz3SwzDT3g/e63MX2dekD4+wCPNQE8uxlRJVd5whsErPzQY?=
 =?us-ascii?Q?+tg5XbYSRFn6OzKlXZm+ufT1l4OKUcwQL3s1TTmRN+7fjgFzWDWkdFdooJRG?=
 =?us-ascii?Q?ZuI8/NJS2x/RKSToHqfJr0EIVEvIqrL4wX47MXquMwIYh4W3NAEuBuBT7vwh?=
 =?us-ascii?Q?6kSqO0bzXVEC/BbYKcfcj/g8d4V3qoOC6j3OxLZhMOruXYLvDzBy5HuhjtUn?=
 =?us-ascii?Q?sXNOSnOWrM1b05QVnUYZkQC0+RmmFzh6LdBnArxE6Xepb8+bhWVYNWQZTW57?=
 =?us-ascii?Q?6bRFNbOtMo1OiCM/cxNajkXiYW1uL/xxXFbOSGOY7gVDRQeHYV76/t9DrU2b?=
 =?us-ascii?Q?DF794IW7/f4rsSFcZxAOFxactFRUNhxqlh6/5JTV?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17350a67-7df7-49b0-f81a-08da94eca796
X-MS-Exchange-CrossTenant-AuthSource: GV1PR04MB9055.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2022 18:28:57.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: svTZN8q6YmrvB/WkiNN1yMb7Sgjin3wJ7PNg7BuKrfw3N/LC3YIKld+Lr55ox6+eddJON2Ul4d7lsorUWA5L/Q==
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

Just give out an index for each channel that we export into the debug
file in the form of CH#<index>. This is purely to help corelate each
channel information from one debugfs file to another one.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 8356af4631fd..54e7fcf95c89 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -98,14 +98,14 @@ static int dpaa2_dbg_ch_show(struct seq_file *file, void *offset)
 	int i;
 
 	seq_printf(file, "Channel stats for %s:\n", priv->net_dev->name);
-	seq_printf(file, "%s%16s%16s%16s%16s%16s%16s\n",
-		   "CHID", "CPU", "Deq busy", "Frames", "CDANs",
+	seq_printf(file, "%s  %5s%16s%16s%16s%16s%16s%16s\n",
+		   "IDX", "CHID", "CPU", "Deq busy", "Frames", "CDANs",
 		   "Avg Frm/CDAN", "Buf count");
 
 	for (i = 0; i < priv->num_channels; i++) {
 		ch = priv->channel[i];
-		seq_printf(file, "%4d%16d%16llu%16llu%16llu%16llu%16d\n",
-			   ch->ch_id,
+		seq_printf(file, "%3s%d%6d%16d%16llu%16llu%16llu%16llu%16d\n",
+			   "CH#", i, ch->ch_id,
 			   ch->nctx.desired_cpu,
 			   ch->stats.dequeue_portal_busy,
 			   ch->stats.frames,
-- 
2.33.1


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE2C520575
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 21:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240669AbiEITvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 15:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240639AbiEITvV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 15:51:21 -0400
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D11B248FF
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 12:47:26 -0700 (PDT)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 249JYU8V007872;
        Mon, 9 May 2022 15:47:06 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2169.outbound.protection.outlook.com [104.47.75.169])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fwnp40wq0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 09 May 2022 15:47:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G1Tjk75hFYUrS7/c2iu02hV1yGybhMy3mUO/1FejcHssxEJfLSG69+Ceh2EE/l5oGNzLV9jI85jT1eAPd14dYun0SEHy6Uv4gc5v4okWiBdT3zHifKUzhqoETPsmt49yi8fXIaq4GXn2tXu5/BjJS+pRjoVMfBKfvwwHMv31KyitXEkpocDe8lxbpXLkhuXHsyOU2+VsiiTjtBWnJE8hu6LKqUeEcHwY2vTMa1/xeD0LuSn5oYCV4CIVIanHNGdRazhcmmjxBp3pREfVVi+JpQKpl5M/aP7Vw6L+B8PRZjkXmuh2WKvvH/Uqm3wYqFTyzrTtFE11tCvm1h8QlVpz6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trSxq4evSUgRS9zcY07+Vli3az9XHfM28VbK2LfYQYg=;
 b=gqmRbIp23g5/qlrZ1RGwtL/52mkDMsn25sTKVnLEXJ7ubeyrbpa4xw8mYeNMUMzp1kQFFtDYWlsvm5BI1bVYwKrG/tRy63q3OOafXkksNntUXpsuflo9QePJlYPIapMMHB9omacG+67ajETnP8kDFgyMVygSxx1bEIO3evt0ucIcDFOxF9W2tDHc8QPHjOzVwQFBLPVZwvW2nvFUR0juLOQmtjGXhbuwxuFTn468h7eooVfbyGPE1YFSD8BqeNRQkSF007gW3nn5VjnEmFpUKpuXuQAQkDmJXAxWP5MvFC2JcC69Xxz7dwzqwWns9WxLT3qiUeG0Lqdy1PEA6zwVDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trSxq4evSUgRS9zcY07+Vli3az9XHfM28VbK2LfYQYg=;
 b=0ePg4KjAvdhiWSPhLq8Zx/LV/Zpwb7sfnKTd5+1XTLQKw8P7F5gH/oPo7PoCtSxso5iRQeWqUtf3oLenlzwbgstifVGkJddAGRZ7oVU0CaBb2/ZPH37H5sQPSz0MLn7Zp0DpxuD9Ex1xjJHcShjgocPt8y7zS/0g5g2mihjtVtU=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT2PR01MB5904.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:58::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.20; Mon, 9 May
 2022 19:47:05 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5227.023; Mon, 9 May 2022
 19:47:05 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux@armlinux.org.uk, tomas.melin@vaisala.com,
        harinik@xilinx.com, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v2 1/2] net: macb: simplify/cleanup NAPI reschedule checking
Date:   Mon,  9 May 2022 13:46:34 -0600
Message-Id: <20220509194635.3094080-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220509194635.3094080-1-robert.hancock@calian.com>
References: <20220509194635.3094080-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0002.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::10) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b929053-1a35-4935-ea27-08da31f4b1be
X-MS-TrafficTypeDiagnostic: YT2PR01MB5904:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB5904E1D904414661EB77CABFECC69@YT2PR01MB5904.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AUzcxEtW0l8L3QjJHwn9O1VmyTA15Z4Zk2DvlDRobR+DrQvDz5qlwmCbH3d5Sx2Nt7Fd+5W5aC4feGHAyLmFmh+6WcgdeTlZ38r19sLRPSBICAvGVRBEHTIjZDcOifQTkZ2Qcp9THt6s/65JICYYl0WfyEQMikcNNzE5n3Y4nAJql4kAboz/5IfN92VGfnBT3hytFEneteX47rEYnJyB0mlXWvvwvqlDY04BPVPIzjzkNBM2ogRF9WL24pquyu/85LGeA1lwJLat2NyWFzy8m5S7CG7cr9Ljdm1R6f4kEp4JSo1ltp0+03cN0hGNcwnjP/PdeFSV8X+WtIIyFo78ZA4QtpUfk/V9W9YovykVJTpWWNocCmXbu11sRVXG9EQhgIaSmJWHLKrfQsZJt4CC+/Lr9mnJkaMPEJSjkb6X8Jp3qdgd5DKE4QjNAZmnAg1pL6B+3Uwqa2IQd8jKCGlef1xA3Hwoj0B+yCjwXmaQlFZ5dD04YcT+Tb0dWVPKf7Wo/2J0enYFbIdga/2sc9U/aNhJrP4ml/EVbnBGcu3ql7qPOh/PbfKD+5iWlu6PdM6AVLYIA9i53XknQ6Hjfq7DOliLe9ejcH9BsapEGFWU6pI93alMUE/lEhO704A9OkkHjyG3GCd2+GhUa/gGiwtx3B7IqYiJo8EDzcu3cD1yyaWQqc1GodguR6mx4PHDucOwo+2WnTqsuapCXdZ2Hn2gOA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(52116002)(38350700002)(6506007)(6916009)(86362001)(316002)(6486002)(2906002)(6666004)(38100700002)(186003)(66946007)(36756003)(26005)(83380400001)(2616005)(5660300002)(6512007)(107886003)(1076003)(7416002)(8676002)(4326008)(44832011)(66556008)(8936002)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QaidtaH0E/mtqQcYd0U0Y+Nvt+ew8k5vvsWCRNCUhlCHAzKGTqrf1LXBTZdX?=
 =?us-ascii?Q?TSxnzB/EWSVd090FfQbfKrcpnYnNt1fNWEceyBf5C8xs5bPMTyK/yHKN/Eo8?=
 =?us-ascii?Q?SK3Tgc81MTnHOa8uxqecLgGCETqCuB4POCqYnwhozjDz1VudE5Xp2RC7veWv?=
 =?us-ascii?Q?Eg69rTGY3gJmBsMXNU9KeAnfSnKZXjPQZjowmfHbskrjF1jBHKU+WrQUpTfX?=
 =?us-ascii?Q?Yzsd6LmBpps1NHoqBZNCpfJkroe0XfrMxO/c9uYXjpOvrV0mD4rRUcvS6RdL?=
 =?us-ascii?Q?80rl+OiwphwgNd2T5nOu0OMvQRcNPISAel2Vw+7c0RDsQlaOBmd1QOCPKeFx?=
 =?us-ascii?Q?LrnFwk3hQRVptjw6jYewKbAMZ1bpSTWQYWnSB2SSzhM8ubvCe7zojmJACqTj?=
 =?us-ascii?Q?+l2COXeufrvbW8qEYxJFvGmAsrULXHHsQoSLAMyA8CYaAxSFDbmWB0KRlPtc?=
 =?us-ascii?Q?csogC58I1OGaR/o+pRpk8dB+r4vdZnKx5CzLppd5I80PfKVm8hm8GDhshQ7/?=
 =?us-ascii?Q?zjghv5/vwzm9yvTtKgxRWt3tl5q7BypQrbyZd1+r3p0My0r8KxTzzWvUOss2?=
 =?us-ascii?Q?9a/TYAARlvWhcXYvfTwQnWAXGZPMpwhuqC2Du85rn2fdhKrFaOJiSM6xZKQY?=
 =?us-ascii?Q?dcdnGxNmQu9xieWuMe/d28j6wWPMstdMBm38+1kjezEdpdsqT9ous/SWhuWD?=
 =?us-ascii?Q?Sz5s9HI6EmIn8gIW0RJ29RPEP5EUHX1jdpR/TJ7Tk7h1Vd3cqiYWFNIka/Ka?=
 =?us-ascii?Q?LIqYo7XYJcvDmtAmYQgaWQno64SblwtHEAa0iY31Vg63UKIOZMIz8srd8aBW?=
 =?us-ascii?Q?66rrG4tJzUsROyxolWaQBsfiDKJRw9IqpLDYrFivAkaNp6v4D/2+xlomkxWy?=
 =?us-ascii?Q?XfSYn1pDMrZLv0zLarRAisyR7jh18L1SAC8VEtYz14v3e0mHk9CnrjL8pvmm?=
 =?us-ascii?Q?rodVDuIqLTZBS6Fs4S8l7JWJLUSuLiyJ3HVikiJacy0A4eNChe+0YaNqt+IX?=
 =?us-ascii?Q?nQiVo1b6Ar7eIls25D7nMJcMVjksMPFRS5OQNYsS9ZOvctglXtQwhEiAlzqQ?=
 =?us-ascii?Q?QYEjYprtSalVb9Y3diFHScqUX8rM62F+Hk6jLyKpdPxZLGVoJJeaTL4oD83L?=
 =?us-ascii?Q?CXwsEinqDrLZr5jFcH5ACxOYSuVChd2OzCGjmTuzCNpBfxL8sivLKvmQnxpX?=
 =?us-ascii?Q?XISiJcOxmbSFusX5G2b7jaVcIefhLJA69yAsMRrB+iTmnkDT/fFjSaOD7Mi8?=
 =?us-ascii?Q?uljMXPGMGP1H9/Ey4dRwNDwtf4w85aCI73V7nQUtNSVOOoi0Q4FfLTOrSJ0W?=
 =?us-ascii?Q?4nfyZNgtTKiN0TuHkVrcXAlgHpNnxi7kmOc8bj8uqaOkj6LClUYXxlgKaFYW?=
 =?us-ascii?Q?sNC5xL84WarGwnb2MnpkqXA2EzdDyKS9058CogqzZoLJnQ5eTCnUV1mtbc2m?=
 =?us-ascii?Q?Ix4AbRywKFuvxqdk/qncISqfLKf+vn9mD+PZ27olhqA+q0tgIeSGaO9uuuFi?=
 =?us-ascii?Q?gU4ktYHNflb4uzsGm2OeZ+Gstlx7S7LmaDr2Ajan5WMTuUQ1sBvPJhBD/P0Y?=
 =?us-ascii?Q?22gdbFQ2PFnidIQq3SBsB6yfkyj+h78hfZew2lrC5DBQZAy8tmIEFWKywto7?=
 =?us-ascii?Q?vvdBt9axAkyw/fykP/j6NbfcWtY8iypCOaTCvjBwqyxTEmd3wYMJQkaA9imS?=
 =?us-ascii?Q?p4b7tgB5cChM4jGpodtvQGFGaJtDTB2aNFFiRkQwqWBPpkC9mLqMz0AB74x7?=
 =?us-ascii?Q?WNeWTKDAQEvbch1nRAS5FgvxiAhcPaU=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b929053-1a35-4935-ea27-08da31f4b1be
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 May 2022 19:47:05.1300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /sj17t9+gNmX3iMqZP0xBTK3XSZkWyn/JNkQ276PwBntrb7mRCstSlkpAZ9PHXwbUE0Rap6QajBO9H7zroQyNDf54TDl7QI76MgD9nEa/1o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB5904
X-Proofpoint-ORIG-GUID: ZYj9Zg2c4pcx63ocCA8bgOrmRm7eYqMe
X-Proofpoint-GUID: ZYj9Zg2c4pcx63ocCA8bgOrmRm7eYqMe
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-05-09_05,2022-05-09_02,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 clxscore=1015
 adultscore=0 bulkscore=0 impostorscore=0 lowpriorityscore=0 phishscore=0
 malwarescore=0 priorityscore=1501 mlxscore=0 mlxlogscore=768
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2205090102
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Previously the macb_poll method was checking the RSR register after
completing its RX receive work to see if additional packets had been
received since IRQs were disabled, since this controller does not
maintain the pending IRQ status across IRQ disable. It also had to
double-check the register after re-enabling IRQs to detect if packets
were received after the first check but before IRQs were enabled.

Using the RSR register for this purpose is problematic since it reflects
the global device state rather than the per-queue state, so if packets
are being received on multiple queues it may end up retriggering receive
on a queue where the packets did not actually arrive and not on the one
where they did arrive. This will also cause problems with an upcoming
change to use NAPI for the TX path where use of multiple queues is more
likely.

Add a macb_rx_pending function to check the RX ring to see if more
packets have arrived in the queue, and use that to check if NAPI should
be rescheduled rather than the RSR register. By doing this, we can just
ignore the global RSR register entirely, and thus save some extra device
register accesses at the same time.

This also makes the previous first check for pending packets rather
redundant, since it would be checking the RX ring state which was just
checked in the receive work function. Therefore we can get rid of it and
just check after enabling interrupts whether packets are already
pending.

Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 65 +++++++++++-------------
 1 file changed, 31 insertions(+), 34 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 6434e74c04f1..160dc5ad84ae 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1554,54 +1554,51 @@ static int macb_rx(struct macb_queue *queue, struct napi_struct *napi,
 	return received;
 }
 
+static bool macb_rx_pending(struct macb_queue *queue)
+{
+	struct macb *bp = queue->bp;
+	unsigned int		entry;
+	struct macb_dma_desc	*desc;
+
+	entry = macb_rx_ring_wrap(bp, queue->rx_tail);
+	desc = macb_rx_desc(queue, entry);
+
+	/* Make hw descriptor updates visible to CPU */
+	rmb();
+
+	return (desc->addr & MACB_BIT(RX_USED)) != 0;
+}
+
 static int macb_poll(struct napi_struct *napi, int budget)
 {
 	struct macb_queue *queue = container_of(napi, struct macb_queue, napi);
 	struct macb *bp = queue->bp;
 	int work_done;
-	u32 status;
 
-	status = macb_readl(bp, RSR);
-	macb_writel(bp, RSR, status);
+	work_done = bp->macbgem_ops.mog_rx(queue, napi, budget);
 
-	netdev_vdbg(bp->dev, "poll: status = %08lx, budget = %d\n",
-		    (unsigned long)status, budget);
+	netdev_vdbg(bp->dev, "poll: queue = %u, work_done = %d, budget = %d\n",
+		    (unsigned int)(queue - bp->queues), work_done, budget);
 
-	work_done = bp->macbgem_ops.mog_rx(queue, napi, budget);
-	if (work_done < budget) {
-		napi_complete_done(napi, work_done);
+	if (work_done < budget && napi_complete_done(napi, work_done)) {
+		queue_writel(queue, IER, bp->rx_intr_mask);
 
-		/* RSR bits only seem to propagate to raise interrupts when
-		 * interrupts are enabled at the time, so if bits are already
-		 * set due to packets received while interrupts were disabled,
+		/* Packet completions only seem to propagate to raise
+		 * interrupts when interrupts are enabled at the time, so if
+		 * packets were received while interrupts were disabled,
 		 * they will not cause another interrupt to be generated when
 		 * interrupts are re-enabled.
-		 * Check for this case here. This has been seen to happen
-		 * around 30% of the time under heavy network load.
+		 * Check for this case here to avoid losing a wakeup. This can
+		 * potentially race with the interrupt handler doing the same
+		 * actions if an interrupt is raised just after enabling them,
+		 * but this should be harmless.
 		 */
-		status = macb_readl(bp, RSR);
-		if (status) {
+		if (macb_rx_pending(queue)) {
+			queue_writel(queue, IDR, bp->rx_intr_mask);
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 				queue_writel(queue, ISR, MACB_BIT(RCOMP));
-			napi_reschedule(napi);
-		} else {
-			queue_writel(queue, IER, bp->rx_intr_mask);
-
-			/* In rare cases, packets could have been received in
-			 * the window between the check above and re-enabling
-			 * interrupts. Therefore, a double-check is required
-			 * to avoid losing a wakeup. This can potentially race
-			 * with the interrupt handler doing the same actions
-			 * if an interrupt is raised just after enabling them,
-			 * but this should be harmless.
-			 */
-			status = macb_readl(bp, RSR);
-			if (unlikely(status)) {
-				queue_writel(queue, IDR, bp->rx_intr_mask);
-				if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
-					queue_writel(queue, ISR, MACB_BIT(RCOMP));
-				napi_schedule(napi);
-			}
+			netdev_vdbg(bp->dev, "poll: packets pending, reschedule\n");
+			napi_schedule(napi);
 		}
 	}
 
-- 
2.31.1


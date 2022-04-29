Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39060515872
	for <lists+netdev@lfdr.de>; Sat, 30 Apr 2022 00:32:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381514AbiD2WfV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 18:35:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381515AbiD2WfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 18:35:19 -0400
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC92C4839C
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 15:31:59 -0700 (PDT)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 23TK0YI5032058;
        Fri, 29 Apr 2022 18:31:49 -0400
Received: from can01-yt3-obe.outbound.protection.outlook.com (mail-yt3can01lp2175.outbound.protection.outlook.com [104.47.75.175])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3fprsjavq1-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 29 Apr 2022 18:31:49 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCPW0ttvgQf7+OrNART0eMdDYIGvuSnbUHDPgl/wbBMhSxBg5p7mh8v4rriFyC9YZoJk4F65lTp9fm6ghDh/XoyuRZ6p+j+JNTPBJ+LlgcNKn1bdM15MLxAXPBKjvlnhHryFX7Ek8kp7rHaR3H9aNKg1nT9xf2rYAlU0PaZ/PiIpaGysz60wiPpDzWseQQfQUa4h5PF2BWM5i/cJzIXGOOzFB2AZLl9hiJBKUtug6tHrPMVJBPhdhiJCV7bcgHw/gZEX+cb3hQbpfzRxK1G/FAfrNqR7MhVC1Ti79UyphsYb8qhTYOmP3s26RMaZgbtFV41LEPKFPES3dpx6JHf6vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=trSxq4evSUgRS9zcY07+Vli3az9XHfM28VbK2LfYQYg=;
 b=nagMeROoHu312VB0rnK+4LC2OuMmEX+W6OoY+AIDRgySLf6DvDdgYT/5fJ0eC5PfLLbMGOkBqr0h7ALZVIpeL3sRHoXdBxQEqQFmkidZp8znsyETQ6bkzdBTVbTdatNF4i5yrL2HvPnr3Wf4Ttq2SFDj9Saa2rkyEvv7YIui8OH/iXucTIwb0UNQaT88rc3bNQ3z0f0gR4gNIOAcS85jp0I6cFbJ6ZZi3y9cES+ls5FQngF6Sfe7YzSfKIg+IDQtPA0TM4Wr36ZOm/ND0WrZSClXVz9/WQHofA1UH11jJcPX57WjnX/0IofSdqiZXP2ktrGiR5yzZIkq+AEYIT6t8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=trSxq4evSUgRS9zcY07+Vli3az9XHfM28VbK2LfYQYg=;
 b=b6Ld8YqEV/FGA3KH1/FPJLKQfScJWnT7tNodHNuiuexIzG33QU6n5D0g/A0O3++sKnUXOs904fQnL5Jakx/G+NIRRb9gt6jwNhFbWmtNNC+B9JCYCZt4HTaNnlSyuhASBp5zdtfJV9IySx5GdozaVGweWtdnrT3eW86UARlPEAA=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:66::9)
 by YT1PR01MB8361.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:c0::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.13; Fri, 29 Apr
 2022 22:31:47 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::4dea:7f7d:cc9a:1c83%2]) with mapi id 15.20.5206.014; Fri, 29 Apr 2022
 22:31:47 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 1/2] net: macb: simplify/cleanup NAPI reschedule checking
Date:   Fri, 29 Apr 2022 16:31:21 -0600
Message-Id: <20220429223122.3642255-2-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220429223122.3642255-1-robert.hancock@calian.com>
References: <20220429223122.3642255-1-robert.hancock@calian.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0097.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:85::15) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:66::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ed9803b2-8abb-4530-15ba-08da2a300c21
X-MS-TrafficTypeDiagnostic: YT1PR01MB8361:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB83613EEF7788C2E9423A93E4ECFC9@YT1PR01MB8361.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: whCvLQ9Pfide0RFxPHbV2Jwj4/GEGNvpVJSmkMZv0k/jE/nM5Rm0Xk4+jzsJ1ZqQptPr7GgZjd4xBAqDtA7WeKYCRJyAweeAx/zMem+zEGW64bi9zlwEIPB6xNJXOCO8uukqLJ6lB1vAVDi0sHSNd/sNqiTzzYU8RrpvTDwWyor+YA1tDVxH2ib5CfY8zQa6DZyNcbxMyA+xafWowKo7L867fuUI45xCuL86E8xr+va22id/mfbmNx+wVqIyr29qCqYtYsqxaMDKe6pRHDlKF8L6R9T9FGbEIF8WItJehkx9D27jvOIvlsHgxyx93S0OwUfhyMEYcZkyZpOPsn726+2SVmuPMcHlqE3CS9Vb+EFQE421jFJZamB5oaUJyL3XFuyIGy5v1q5GheekRJbKMk562pdqDp8/zhg2GNwg3PI0HblmEPq3vDlqMNiB/FbOUmNh4Jq7TqtTSinfFdVeCGYFJgrVvdT36uPOIstGjC/o+4XhTbagFx7hUG0uow494NDbD1tyGRpzKHso5kLwtZe54064ccHk+iVgReBH2zXPgVdVsA1m0ybjubHVtgfX/xPTZ1F6c3qMHgVdejuuFOvmes2R27xTKR9gv9U1dkAIhASwUQp9z9260eOZOG9iN1LPf6YYIZ4QEXZUDXIhABLqxutXW4zph50bmRm2+mJAnVWsgYaflq6WRcwbY9E2F1GB3uo+F1yjkQ8ne4DoaQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(6506007)(36756003)(6916009)(1076003)(6666004)(316002)(2906002)(2616005)(107886003)(44832011)(6486002)(508600001)(5660300002)(186003)(8936002)(83380400001)(8676002)(66476007)(4326008)(6512007)(66946007)(66556008)(26005)(86362001)(38350700002)(38100700002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hQ2i0hb13vND1aQxUfZTcyRKwdkxgu5E7YW9663Jh81qfzXnP/FxrAlXH5eA?=
 =?us-ascii?Q?JUDE85MmtmD3rhE3m4XW4elFZBPPnRigw74XL2gGdV9ovqbjzxhdF/rgs0Z1?=
 =?us-ascii?Q?W74IY6vb9ZlVzK+2QAFlyFulbEaW9czbRH32pCgDWsZqnAF4VIRQk9cjaivc?=
 =?us-ascii?Q?EdxTFdIZXzyB0iPUxPhaW1CU4YFqEIGQmitcQ7A6LoUtrR+QLxO7Xg0S1kXF?=
 =?us-ascii?Q?7C8pN8oxP/+tH2RpWVW/ezKL6bDvqCClxxheES8F0FRNpG4qLN3PW1cPFICQ?=
 =?us-ascii?Q?VFAthHzykBeCScdpA4yLyt3oFvh4DW0IDlzgnpcVX18xNr7Fw+mu76x3wkfp?=
 =?us-ascii?Q?cfC2OZ+cS8SU19u3goDTxI72lyPrPTgBhWu6k0Ck3lJcxE99zNYauqocgFFy?=
 =?us-ascii?Q?6zOFwLA0CpO5Jplnxddjxiau1OLI65IfMpH+VUcuvi6M7pfhAluPzCQ0dChN?=
 =?us-ascii?Q?yNSPdKjIZWg+eT70sywD3Q8v9ys9xr+e6BOnEgDMnq+8DwCGza1vNlAp2rAW?=
 =?us-ascii?Q?yneXeDhZaO5kTwR4XNP2JJFRE9D5TUUEAxql6F7qvuQddalojxifm5t8Aow0?=
 =?us-ascii?Q?bhrbGrwrryk08yQuXcCu9xMBVANCoVejY4iI35vI2Zuuw2iQ7oB/CWVlQULi?=
 =?us-ascii?Q?awXYOG8FI00mxjO1RXEDeho2+v34NNTdECnL+mKYEYLfLZxS4Hlr71QQrBHW?=
 =?us-ascii?Q?UzeZnQuJxiWP2vvF5TyLeCiKWyZ3BIqmSYKkB2+k6H7y+XA2iGkOnD3ABLRN?=
 =?us-ascii?Q?ALXYB+u5r7Izld+rztIuK6hmqzbPkRDGQ8VDiBuDJMa4rTWjo6ZThOWWI8WY?=
 =?us-ascii?Q?Ui53Cthc7zYlpQtUFtV4XXF+fOZSOWjaff+dg3HeiiWdA3XFUpbEW7TFzRLT?=
 =?us-ascii?Q?mp7Rf8qCx6ao88E69gH4iH3ouZT8HNXkFMqPaApZA5LZX5eyRW19jldE+glQ?=
 =?us-ascii?Q?HHnkYKR4UcV+uWa6JQBus2tVXevrCfnFb0iF46AcnAU0fbIqOLdC8OLePbLP?=
 =?us-ascii?Q?v3oAXqVsQGzUN+KMWixkMgzCmRsFQpONpnOkrVdpZuUj3JkREc/614rj94Zh?=
 =?us-ascii?Q?nhcdv7gu8Vb0kY07EyGHMYwM1x0zs+XM9gAcsKnzmDkNPvVf9fDxfQ0RTuMk?=
 =?us-ascii?Q?Pe5pVZgnjtrN1FYJ96JcvP3BegyEkfBYp4tsU5mzPK1lhKju0+f5/Vy0lCvY?=
 =?us-ascii?Q?2HK9L9l7bQqgn+OOvsR56eg5NG5MRtCQYVSkPft+BgDhItOg+KIEBb4GZSDx?=
 =?us-ascii?Q?IeGaHypAQxew/ly2WMEzRvya4/Kd39h+6EB1NjDy3mtvphW9R/6D74S37+4g?=
 =?us-ascii?Q?0qlcrgwPafKVis/fBdWVxCTDATZBSGH6aYbbzfyTCjukdDXbfojNsX66CxB8?=
 =?us-ascii?Q?4UOtP/JDvCnVPkcWyO/NmYu/Bx6SAjjod/hGbpayob8xJniXy5hllmYTbrs9?=
 =?us-ascii?Q?6bBu9XgiL2x9RldxMHy5yHOaqKaodCoQSxGfNsu3fuSV3n+gA4ikq5qIKDP3?=
 =?us-ascii?Q?BqAB0zajK7HOgg4S9k8t1ZzRnXgM7eNmaWSV8yCe9cgOzQN1pz8r907rBJgd?=
 =?us-ascii?Q?nfoDGJ+tSApUeEYHJQNa4q+CfCPAy7WzZGxizrVqWtKVuVUeOAyuZB38vjmq?=
 =?us-ascii?Q?ltu1QVFEct3zx0QFZ/PnT17aHUeVQFYsgLivujR15JJ6fT6qKvRGELdVcHFd?=
 =?us-ascii?Q?f7Zb8yagOjCg//KHswE30hhO5kX+XD/5TfrbeEb8nJL5vkHOUybGPa+TOQBH?=
 =?us-ascii?Q?dj4VFsVZscAlS4cwaN4V2kq9kbuBqbU=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed9803b2-8abb-4530-15ba-08da2a300c21
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Apr 2022 22:31:47.7887
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: B+8U8Z9CtEnFQ7WNaNjjAbDH4Olqo+7jiz8Y8UuKlb3XNozGiIWxx9Xr2wsPH4cE1N846KR05jGC1kCnUqeYdde3qTbLIDEGTUSWMyPgjEU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8361
X-Proofpoint-GUID: kKgNPoxsYSzHvkydklH2-PmpGIHq0O1U
X-Proofpoint-ORIG-GUID: kKgNPoxsYSzHvkydklH2-PmpGIHq0O1U
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.858,Hydra:6.0.486,FMLib:17.11.64.514
 definitions=2022-04-29_10,2022-04-28_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 adultscore=0
 lowpriorityscore=0 malwarescore=0 priorityscore=1501 suspectscore=0
 mlxlogscore=715 mlxscore=0 clxscore=1015 spamscore=0 bulkscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204290119
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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


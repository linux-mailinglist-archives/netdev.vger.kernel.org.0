Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB2CE4CC4BA
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 19:11:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234164AbiCCSLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 13:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233967AbiCCSLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 13:11:50 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C20291A3618;
        Thu,  3 Mar 2022 10:11:03 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 223DxVKo013243;
        Thu, 3 Mar 2022 13:10:53 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2051.outbound.protection.outlook.com [104.47.60.51])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ejy1xr6yx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 03 Mar 2022 13:10:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OSOPSUYTyM79+h0ifLe6yKmKYbG3xJbLeos+1ZdW10k2CnbDe1AEcd1m93+04Y2v5Fp3XdjAu5rScAxmIImSDPcPICDuqaVXfBey5KxWa5mbceNHLZzPlpGUqQCuzrlGwFULjEfVG8W9h8hzJGojObq03QSupwseLokhLtLmJgT5ZnqZnuz4QPLN14JDMMa+j5P8JniKzPOHUElYj7neVXEh3PTRMI40Va9v8zWig4mF/kSu4tn8yakDj0sKXSYzwoXf4UrULxBb+VDv3frQ1qt0USc9s/8Ihurlzh23Ippnnqt59faVEeOGFzhzBms0y6379S/RkzLpunWQhn6b9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=W3oRtmu1BURXKvwlKYpnqonJdAn0sZhJIQfPiqQ2JM4=;
 b=JoSZsjvUWV4+WF72P5RR0CC1QnOSum2kL3NdsfvrDADnJ//6fFM286P1e8RYNzOZ+ImTOOBpE7J1CHZUXXRb2N5/pOmfi23sICMjqOGZFBCX79pQgELn79+ZSkzPESa9D0Xadbqm0yzfQzhmU+FozQGn/RqFMm8yvXmYFA0GHY0PaHFRmU+hk6Z6CNinQwjjIvKCAJvxSwoS+D99BgJrWWKoAGCNfHM9f/JlXO2+7iHxDLZc0YWe9+t8pny8CeeVU7rqQz5F3NPgnrCYJzjG2N34RBUI6JQqfYslLt920XTH2fBWw6RkCXHAknUupoz1KIhFBMvNmx2j4IqVhF4ltQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3oRtmu1BURXKvwlKYpnqonJdAn0sZhJIQfPiqQ2JM4=;
 b=B0epfcc+yNALDPGQzEVFO+XADfdDnnHY07qinRI8tJjpkGc+35KLYCRtF02sdlrh4liiTgk/R5LYZiHB2Ip/mEZBKgn6Hm67TB/qUDaLQad0qGmJWJBsxBn7R2fMG7OIi9PrQkfH5yy7juB+oZ6rF59+mvP1c7Q9hXEOpIoxyH0=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT1PR01MB8780.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:cb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.15; Thu, 3 Mar
 2022 18:10:50 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.014; Thu, 3 Mar 2022
 18:10:50 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, soren.brinkmann@xilinx.com,
        scott.mcnutt@siriusxm.com,
        Robert Hancock <robert.hancock@calian.com>,
        stable@vger.kernel.org
Subject: [PATCH net v2] net: macb: Fix lost RX packet wakeup race in NAPI receive
Date:   Thu,  3 Mar 2022 12:10:27 -0600
Message-Id: <20220303181027.168204-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MW4P220CA0017.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:303:115::22) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 441f56ff-41e2-4a94-2701-08d9fd412629
X-MS-TrafficTypeDiagnostic: YT1PR01MB8780:EE_
X-Microsoft-Antispam-PRVS: <YT1PR01MB87804A419ED4B1304A9BB060EC049@YT1PR01MB8780.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RJM1B/uk1AFRfwcNW8vysHkdPTMmeIdCVGF05WfTqFNg9lqg2+4isiJh2piTBfsUmb/tbQ+ElbISBRdd/nxangsRTfxzFideJ/k5urrJuzI3vEQj/Y7VmJl6Al1lOCjLvj8E90vFU/3k8o8wfd/ljAuAHkjYhkTDp+pSOkxh9euaLxkSY6deXhRBLg/H3MatVFdGSGvWldniCydTFahOkRiW+fPgaK3TwACq9T3F2D4gzU56GYJtkCEAH6Z1mlRthuZTmFSnIHsOckPUB2vzlBU7QWEJ7Dk27aaZfs8gdv1o3bkL/TDzbzAlJtPW3FRWoUMVW4HnB+BxjmVk6x2pqPWkiS/4JvW1lw9wOHGYkH5xPK/r840xqsw9CRKK2lOlSOzQuKA6pDUuKU2PeJS121fPFfth3BKp7e0QhT2JGJ276HyuRr1p+etoLdxDIODjbLzOwCowGI/I/SDrexRct+SVAcOo0ZwLqZoiBpzetLDYHOAsHBBCOaCIEyY4NK1y4PRP1nYqy2CboKMYyfTp8XaXS//kobKJMheZpCpfry274l7/hEOvdJgH2vZV2Ya4Y4FZ0Vt9GpCAJIZEFqaBBrzibiCwBe3xAm/R1sWJseAnVhyRNiTx9nyAepDH67FdBvl79ufhjCtKAL30+KdQQP1RwGcJziyyGmOvee5Jc4MLGZikQC3jxkUp+1tXxvNPQ2hjc3jnn8kPVRO+x6SS4A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(1076003)(6666004)(316002)(6916009)(186003)(26005)(36756003)(38100700002)(38350700002)(2616005)(44832011)(86362001)(5660300002)(6506007)(8936002)(52116002)(4326008)(8676002)(66946007)(66476007)(66556008)(6486002)(6512007)(508600001)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?e8br1t9LajpuYOGo3pUkbZM3B73M7lqXVshS5NVwbbHrgEIs25VANDQny0qV?=
 =?us-ascii?Q?N/WDa2Vpy/DpUv//NQIckuz5/Z2o8B4YAaD4SBhhcGKyZVTDY4T5eB05OdfS?=
 =?us-ascii?Q?oi688vVde80w1HZ3dJLN6pshr8S3GYApZ73eHNGvpFNW7bck/F9J68WHqcVG?=
 =?us-ascii?Q?9WqQjn97Nnqh4CfHf1BepPByXb4LA1TTcV9DnApqEFJYLNTWRMsNZ8HGNhAo?=
 =?us-ascii?Q?yFwIAtXTxal9X3Sms0pX8JZsTexe5sqaprxjDLm1k533+GYbWg42++GULTUP?=
 =?us-ascii?Q?0ztJj4yu8bfwWTtYGyTnTm/7DjB2ng9L2A/k6TurFK/FDWYIuM0fHRvcgl5R?=
 =?us-ascii?Q?3d8CsMJOCc7LD162wDBvmrHNt0y12uwbXsW2XnMINYfS/eH0SavgGI3497R5?=
 =?us-ascii?Q?3YW/KRc5uWuhtHjjbUamEld1iaKU/U+bLB3RY5na1lVSd7R0zdDQ6Q/YNRq6?=
 =?us-ascii?Q?+uu3IZ8bY2SliovNc9B++weihwwrdigSnMG5NJG8EtSDaiRK5oeTujmxjscF?=
 =?us-ascii?Q?fz54vb3fS6bkSjDzpaKy8snwSs2Zg2Csoa/AupXNRRH9ccBZeGtgA/2yhKpG?=
 =?us-ascii?Q?3o1IfbmXcsUIPohLJDRtaDO6VkmdPL9ula+GFw8xYUANBUCYScTTLtaCrb25?=
 =?us-ascii?Q?LgxyuUKZ+dcJIRwl/7ltcvCWO12+Jq3NCTYUvwwLjxFJJKkwEH4NYdrfECTW?=
 =?us-ascii?Q?++Dc70NibVaV/1SD+bCPJr9E5u+duVP4Oekp6Bjny2JBjE2/yCbClzQCrlPS?=
 =?us-ascii?Q?NiAadOquPc5BKRGK5/UkKhTbKuKVy7/lBx+UXmhkM5NPR6uCcP3VqEgyeWPy?=
 =?us-ascii?Q?+WXM1C1ILCCLwF/X8tyZi0lKOVNNIVvOckn/nrzflsg/bdwv4zAN49kX0rEV?=
 =?us-ascii?Q?fDUt6dhJp+wc04PzVrmx/7uPPHaWv1S6eGZ6rFuElRtx/jSuWyjYLDIDXmwo?=
 =?us-ascii?Q?vhfMum2j36fqLFSq0qPvDd4F/Ss1xzYypnhHiqzd7vs7mXXhapkMDmmhEpT+?=
 =?us-ascii?Q?qZWb1awU1POOK5Y3GxMxEGUYhM5FVcIajl+CdKLX5ep6YmeeNAMYNBpiP8Nc?=
 =?us-ascii?Q?2x2OGxxUdtshJAmoqHRyLJx+NHpMDuOCZn5KkhYYe2KrnJmrxzmRD/XNksxC?=
 =?us-ascii?Q?l1htUOCsD1XtVGHwhde1v1mBw9kJuS5E8ZrO4sIPJKGyMDW4ep+sMFHMWXkr?=
 =?us-ascii?Q?ZIpFH+VG4/Dew1HLwpP+VwIx6qqLIboJ804z61HRl4ChFHRSF0aCB+TsklrQ?=
 =?us-ascii?Q?FvsSabTV3X/5JHD0d38BybHz2lCZ3U6lDDZFqf9JLoCe7HuuWF25WOeJjNYR?=
 =?us-ascii?Q?8IRTWdwXFgDxBjR/6uXrOU9zSDTFSHZW/E4/dR0J2lu2kuMeg5qfv/Hx5SMq?=
 =?us-ascii?Q?Z9USUDqk0lSrUF0zoImhP1uxDwXrzl5vJZoPH6RA1i33GUhkc6CU3ZV1Us5h?=
 =?us-ascii?Q?cVXkB0Uw3HtvoNhXzkqbybIGxULx1b7lHahcj2B9aSksEkQb/MM8xbC8ZVhf?=
 =?us-ascii?Q?1LRaXeLoHZjZV6OcU3nCJJm0m3BT3mqqRIs7ULmMrssaQaQO6savsmMQ8Enl?=
 =?us-ascii?Q?4eVpz/cc+a+uls+JBpsLhcrHWkJ4rv/9A/ak4GMCHtZtCgFsPHqImIhXgas6?=
 =?us-ascii?Q?yCnFIn2OEyYF36YgG8QjF5wRK7OQwkTYCMiTqV2IyU5nvJTiVWBLMd9Q/2a/?=
 =?us-ascii?Q?4CtR7A=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 441f56ff-41e2-4a94-2701-08d9fd412629
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2022 18:10:50.7849
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gFTwGx31lmSkI/5nTfZgM0nG73IZZ3LZNVlJEPneAfsEH/stTW1W8rs6bzasoL7khWl/piLADyi5YPCw2InpUUwqZp9NIMlmBn5yYQbwJ+0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT1PR01MB8780
X-Proofpoint-GUID: 1pN-6SP4Uk6BJP1UAfPLlgkHG4XK7Vmx
X-Proofpoint-ORIG-GUID: 1pN-6SP4Uk6BJP1UAfPLlgkHG4XK7Vmx
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-03_09,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=582 bulkscore=0
 lowpriorityscore=0 malwarescore=0 clxscore=1015 mlxscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2203030083
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is an oddity in the way the RSR register flags propagate to the
ISR register (and the actual interrupt output) on this hardware: it
appears that RSR register bits only result in ISR being asserted if the
interrupt was actually enabled at the time, so enabling interrupts with
RSR bits already set doesn't trigger an interrupt to be raised. There
was already a partial fix for this race in the macb_poll function where
it checked for RSR bits being set and re-triggered NAPI receive.
However, there was a still a race window between checking RSR and
actually enabling interrupts, where a lost wakeup could happen. It's
necessary to check again after enabling interrupts to see if RSR was set
just prior to the interrupt being enabled, and re-trigger receive in that
case.

This issue was noticed in a point-to-point UDP request-response protocol
which periodically saw timeouts or abnormally high response times due to
received packets not being processed in a timely fashion. In many
applications, more packets arriving, including TCP retransmissions, would
cause the original packet to be processed, thus masking the issue.

Fixes: 02f7a34f34e3 ("net: macb: Re-enable RX interrupt only when RX is done")
Cc: stable@vger.kernel.org
Co-developed-by: Scott McNutt <scott.mcnutt@siriusxm.com>
Signed-off-by: Scott McNutt <scott.mcnutt@siriusxm.com>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---

Changes since v1:
-removed unrelated cleanup
-added notes on observed frequency of branches to comments

 drivers/net/ethernet/cadence/macb_main.c | 25 +++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 98498a76ae16..d13f06cf0308 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1573,7 +1573,14 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	if (work_done < budget) {
 		napi_complete_done(napi, work_done);
 
-		/* Packets received while interrupts were disabled */
+		/* RSR bits only seem to propagate to raise interrupts when
+		 * interrupts are enabled at the time, so if bits are already
+		 * set due to packets received while interrupts were disabled,
+		 * they will not cause another interrupt to be generated when
+		 * interrupts are re-enabled.
+		 * Check for this case here. This has been seen to happen
+		 * around 30% of the time under heavy network load.
+		 */
 		status = macb_readl(bp, RSR);
 		if (status) {
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
@@ -1581,6 +1588,22 @@ static int macb_poll(struct napi_struct *napi, int budget)
 			napi_reschedule(napi);
 		} else {
 			queue_writel(queue, IER, bp->rx_intr_mask);
+
+			/* In rare cases, packets could have been received in
+			 * the window between the check above and re-enabling
+			 * interrupts. Therefore, a double-check is required
+			 * to avoid losing a wakeup. This can potentially race
+			 * with the interrupt handler doing the same actions
+			 * if an interrupt is raised just after enabling them,
+			 * but this should be harmless.
+			 */
+			status = macb_readl(bp, RSR);
+			if (unlikely(status)) {
+				queue_writel(queue, IDR, bp->rx_intr_mask);
+				if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
+					queue_writel(queue, ISR, MACB_BIT(RCOMP));
+				napi_schedule(napi);
+			}
 		}
 	}
 
-- 
2.31.1


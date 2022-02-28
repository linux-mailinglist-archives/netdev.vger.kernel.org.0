Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072DE4C7843
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 19:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235851AbiB1SpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 13:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240879AbiB1SpF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 13:45:05 -0500
X-Greylist: delayed 536 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Feb 2022 10:43:37 PST
Received: from mx0c-0054df01.pphosted.com (mx0c-0054df01.pphosted.com [67.231.159.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AD04286DF;
        Mon, 28 Feb 2022 10:43:35 -0800 (PST)
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 21SFDLFZ002901;
        Mon, 28 Feb 2022 13:34:25 -0500
Received: from can01-qb1-obe.outbound.protection.outlook.com (mail-qb1can01lp2054.outbound.protection.outlook.com [104.47.60.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3eh0uhr5h8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 28 Feb 2022 13:34:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aBSFQi+vY2mQ1VaWmwvtvID9bBiZUC2xR/tSLwgcVTMbSVhq6lAC9xo847xIm1x8xIedl512DJFOXyF/HdbukMCwM3TuIot/bgotalfNyMP3e7pAi0PNE69em7q2DfLM3cnKHkHKhFYMxElJ3Efh+p6v1x8kDwWM18U2Ik6Aj2GhR654O+9DVjCkOl0+sx/nUa4GJF39onuGGD3LMTh0KtGlfJmjpDD2eGiNKy0a30KSBiotdUiLn4GzbfpX+Vj8smS5YkQi2eAV5xJgetoLfuqe/LbMz1Vwt1k4c5umvB7vGilHHK9SY8Z0XNfkXGn1JUzv/B7SeWPsAfsfVcv4xg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YOz8jXeU39mt3GdZWG4jIWk1XRGhgqApcALjwX8t6r0=;
 b=Ecanjlxw/r5+GNGN8V3A0WhOXC0HblLyxw2BD6AIrYwvqp3E7BS6krzQmyt3slMTzHEChu58z0kyVSFez+LnsRjTMZJFZHCvyz5fp05ULNAq/UDPrLZT17f1oCSuCldvjT63BdsvDXk387KCdAlYhm68R3S/QNWvpBhh18DmG9I45PE/d7LtWDkaj2iIq414CeJ4MgF8tVG+7cxBbCfkIs6/KMAmEkCy7jWJ04GOSSpxF6AZpt01QEmWGCO/ScR7i4gTGCgBoSh+4U0IdSXC8uiBpIeKYn38d16XRDoofBKJ3Xq+Y+G5aVNeim3NY7CcyJXkSBfvVbRTzXLQV0Cw1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOz8jXeU39mt3GdZWG4jIWk1XRGhgqApcALjwX8t6r0=;
 b=Ce3Xgf1bgmC+83bZUSltBYR3o7HFkP2AoXhAytMR3L0apY2vvv4y0imBB6axi6L+mVerjnP4+79hFvCpVCRlG0qTadDD69SZN4jDETLQ5kLeXFRh0/xm9ssHkzY30shn2os9u/rscwBA64uCCuZ2Rcoen/vgh/Ib9fN3hl7cLCw=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YT2PR01MB6144.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:4e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.26; Mon, 28 Feb
 2022 18:34:23 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5017.027; Mon, 28 Feb 2022
 18:34:23 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
        davem@davemloft.net, kuba@kernel.org, soren.brinkmann@xilinx.com,
        scott.mcnutt@siriusxm.com,
        Robert Hancock <robert.hancock@calian.com>,
        stable@vger.kernel.org
Subject: [PATCH net] net: macb: Fix lost RX packet wakeup race in NAPI receive
Date:   Mon, 28 Feb 2022 12:33:28 -0600
Message-Id: <20220228183328.338143-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CO2PR04CA0191.namprd04.prod.outlook.com
 (2603:10b6:104:5::21) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0dac1e96-8495-4284-176c-08d9fae8f0c5
X-MS-TrafficTypeDiagnostic: YT2PR01MB6144:EE_
X-Microsoft-Antispam-PRVS: <YT2PR01MB6144A8DA0E44917513FDF95AEC019@YT2PR01MB6144.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lTz4miI9dlfIqKRRQHtmnHA3owIsUWCal9zevMRdqql058xN8NrVoi8oOffaXroCwOura3/jb+JfB3SiryTDmonekeMSh4uIVKE9FmKs9VsWsw9fxB1T5Puy180kaJLsI/vEV2iNGjpvqcnMq+6vIlHjksWcxAeol4S1qHSOxY4my/mz4u0mrN9354fWJ8uBUXLXGC3e/+zDMDgfHluVYzdQs9QXRRxf1ay29wkpPgvX1RVSimfAFo8wOSxG3szeEwRy8zWDFX4tG9FBN+2ikY7LrqiaVC+y4QIKEQH1gwwEE4uL9rYpPcUCrss3Gj66lDyTuAo/rbYP2vbP/Af4gNaB2hyqSOEIRs4/Zumn9Sr5NmYelZoK7P5EJq6sEJAOoEbWkhcXEI+AXOYC3jr9Fr9gCYk4RM99dVPyvCH1LOMklzzSiVJNirfv9+InyWcuZfQ5E6CTQ5YE3o8V5THcR37BeZQw+2IEkKmkHeVZtiEdsQ2ml0Tb/qd3wbVw0Cf5eBGOo/Lwp5ZwhPxEhj7ETx7AosN340CiKvYgVB7f0El/PhSMFJvajBlhh605oWvEK1nOO26/cWNCA05hmm8JGec/o7IGj3gTd+USn1U7ogwHWg+1Rwz1IE3inCr0JRKGuNKGyJBNW8pZotQLl3tM+0b+OwZv1o7SpcZYgsZbRzz9ZFR1Rfya1As4bY0VboS6Xz0FY2SPp3KIxgbBOctfAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(6506007)(6512007)(36756003)(508600001)(2906002)(8676002)(5660300002)(66556008)(66476007)(66946007)(6486002)(83380400001)(86362001)(8936002)(44832011)(26005)(1076003)(2616005)(38100700002)(186003)(38350700002)(6916009)(316002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3k8zmVojqBWRTgEQ9Jx+x4oVxqI+4wE/TfX+Hk0mC6cpOfL9M8NMn90dAB6S?=
 =?us-ascii?Q?eO1G7Dpqu576gGI0fZSfulfdiBR9W6jpiZkdiw11/DOosAhp6cYBn0UewAqa?=
 =?us-ascii?Q?nx4pmDCTEHssV03+koRkMq3xktN2smjGm6DfJJYXUEHQT6KKHsdgNhHsWjiU?=
 =?us-ascii?Q?ggE+DH/c+9/KirjxDOyYTrtM05zrFd3zgIHjk9AOFk8QeQAwx234UgqKs1XI?=
 =?us-ascii?Q?P4/5wZxaaz+CBOXZl8ViyUs9a+xmF/qenKgHn20I1cFuBzVkKfbuZICrQPLO?=
 =?us-ascii?Q?NbpXtogXsE5J7VcX9dUeq0S9cBBvlruIVFz4uFdDjsAN0CNkMoUbf4Fs/5/R?=
 =?us-ascii?Q?pOSV5PH14/yH/zUzbcBBOn+inmfrjYWDHFlvL//bpwESTuxisG5GoTRP0dCX?=
 =?us-ascii?Q?42Mujg1xiPbsyhQXwjsF31j1/J8dMnmEBaA5dzfTSo+TsCFHKw4SUYJNruek?=
 =?us-ascii?Q?yIQZYoxSlPawog18vQkdRJMCXKpQGzrwQLhD0a3Wd82AuDK8BzB1looXPim5?=
 =?us-ascii?Q?cIHoc3fv1ukgIUuJODzNWvSuKvTEBnwxbzGThwlGpdytr/qoIn14b2wFqwhE?=
 =?us-ascii?Q?Rzrb6qGngR5FpaK0GuLX2OYrN9PYjVWtHI9JpF6TB9I54FJlooKl10xyaJ6z?=
 =?us-ascii?Q?tc+y7fklW0+B48ZdVGRQb1xTeosQghbEA6vxy64qV0YLVEmNq5slOpe9K5bF?=
 =?us-ascii?Q?rkQEy6h9ZoYuOW+YmRrOgwrpJln1P79HI1W47qlbKRUbCQKaQGNf3XoXAUVa?=
 =?us-ascii?Q?e/9GwftpT1OuC0WMzKJlNPmctY4gsKfWNTtVdQc2mVRfx2hajjIhP3MPOdX4?=
 =?us-ascii?Q?fUJ/iGOiUYJANiOqySlDH6LtcRovP0QrOl9aBcO4tk2wBVxTTCXjOV0Q/Gjs?=
 =?us-ascii?Q?BZSY/fV2Af9Mwxn3a7M2N6MpvgQi4biFgYgKWRa5+nnD1ww1txuiURp8HoGd?=
 =?us-ascii?Q?NRfFPenxl2LyGSU6Xh/MdDKP2U0R26NSc9GJ0SZtT285cIAFR8M5Y4+LRyYY?=
 =?us-ascii?Q?iQpSGDu8K+5MiDDJ2n5NnOuzQa3KrL5m6UFHKwTU3eW4OJ7p531trsRiV0DJ?=
 =?us-ascii?Q?7foyTb/NRbCbOWDOwnKvuc8HF8k0JPDq1Ab5KJXuPuJSQf3xy/Gd/c0/VJY7?=
 =?us-ascii?Q?eseEczRpf0RAHpyPvJus1LdYNXCl6LAvTouGqwXe73miiM+Gl0my4zb/bZej?=
 =?us-ascii?Q?Wx4ks5M/0+Pdyg7IFl23N5tJiuowfENtciS5YX2RocvNfnPDX7gNb5VZtVYa?=
 =?us-ascii?Q?RFpX7pfGmeVGrun7npf/+ZL0GSuoVaGhhwwFPUM1Cqm0A6uDxzV3tXTLI2+/?=
 =?us-ascii?Q?HQberKDSVqH+BcCoXQoRnOZVmpvmKtLVCtK3gy8gj2TTf7jURNHkW+Qnqv4k?=
 =?us-ascii?Q?dWteE6HYmt7WHAePdQyYIp8pz5Kqd5MxTV+c2TwZNzgWk6tdzgpN23/biHfe?=
 =?us-ascii?Q?SxX2oDl3IlnFMOvClDwqhp8bjM8LOGDYRv9e1aRhu8Cog+gUQLUOupqx8KJn?=
 =?us-ascii?Q?jBiv/miDhZiJdKegRLQzQ4qzIxwd1FNb6TkyxfOO4JfkulZKuHW5Utdhp83T?=
 =?us-ascii?Q?Wg2VYfBhIUc6woVJF6pi9PJsMEfw/cjIF9v0mEGq2joUCnJuKS/R07hqTs1P?=
 =?us-ascii?Q?lC8HrS7bKr2yV5Ikwtre36ZK6IuBOfUlTKiCOkH7qAYsIOOS23HieWDGutI+?=
 =?us-ascii?Q?OXQMuxZoK2+WOfmfXh49DzYfmTU=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dac1e96-8495-4284-176c-08d9fae8f0c5
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Feb 2022 18:34:23.1096
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wO54k8whCMBW+mz5dXsjZWAr1a9N9l/qE8+G1pfdZudzggw8tFBiYvqRQ8Lap+vt+kp4XYmDLPmK4KSOrqV2ASNQoUWA2+zo/XvZbnfeM2A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YT2PR01MB6144
X-Proofpoint-GUID: D75lsiRHTPWeID-kKrE1odmC6kv37Q44
X-Proofpoint-ORIG-GUID: D75lsiRHTPWeID-kKrE1odmC6kv37Q44
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-02-28_08,2022-02-26_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxscore=0 lowpriorityscore=0
 adultscore=0 malwarescore=0 suspectscore=0 bulkscore=0 mlxlogscore=693
 clxscore=1011 spamscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202280093
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

Also change from using napi_reschedule to napi_schedule, as the only
difference is the presence of a return value which wasn't used here
anyway.

Fixes: 02f7a34f34e3 ("net: macb: Re-enable RX interrupt only when RX is done")
Cc: stable@vger.kernel.org
Co-developed-by: Scott McNutt <scott.mcnutt@siriusxm.com>
Signed-off-by: Scott McNutt <scott.mcnutt@siriusxm.com>
Signed-off-by: Robert Hancock <robert.hancock@calian.com>
---
 drivers/net/ethernet/cadence/macb_main.c | 26 ++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cadence/macb_main.c b/drivers/net/ethernet/cadence/macb_main.c
index 98498a76ae16..338660fe1d93 100644
--- a/drivers/net/ethernet/cadence/macb_main.c
+++ b/drivers/net/ethernet/cadence/macb_main.c
@@ -1573,14 +1573,36 @@ static int macb_poll(struct napi_struct *napi, int budget)
 	if (work_done < budget) {
 		napi_complete_done(napi, work_done);
 
-		/* Packets received while interrupts were disabled */
+		/* RSR bits only seem to propagate to raise interrupts when
+		 * interrupts are enabled at the time, so if bits are already
+		 * set due to packets received while interrupts were disabled,
+		 * they will not cause another interrupt to be generated when
+		 * interrupts are re-enabled.
+		 * Check for this case here.
+		 */
 		status = macb_readl(bp, RSR);
 		if (status) {
 			if (bp->caps & MACB_CAPS_ISR_CLEAR_ON_WRITE)
 				queue_writel(queue, ISR, MACB_BIT(RCOMP));
-			napi_reschedule(napi);
+			napi_schedule(napi);
 		} else {
 			queue_writel(queue, IER, bp->rx_intr_mask);
+
+			/* Packets could have been received in the window
+			 * between the check above and re-enabling interrupts.
+			 * Therefore, a double-check is required to avoid
+			 * losing a wakeup. This can potentially race with
+			 * the interrupt handler doing the same actions if an
+			 * interrupt is raised just after enabling them, but
+			 * this should be harmless.
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


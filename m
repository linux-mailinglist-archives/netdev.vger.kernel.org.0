Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C99B467F37A
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 02:08:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbjA1BIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 20:08:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjA1BH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 20:07:58 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2045.outbound.protection.outlook.com [40.107.8.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0BD22DF2
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 17:07:56 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eJddFpxMyfkTTm+LQCBth1DfqOmzPMGqMYFhTKS/uou8B6ajedAC/C5EOpImYP13N8Tk3pSNusdSezlPcPq1yL6TZtfP/YY0z+l+9mHEXUNuCjoC/JntNvSs+2RLKZD+G7A7rO0goKjLhgTePbeZaWuqoaK5hqa7hWPuJDmM+A5ipP8NAcPUTNALam0wlz72TyX4/9/dnCwN1R0ZwKUhDxdNSA0Fdyz2i/5THK8SvZcSrwAbB78HNAmN1RaEKeozW/dI+zfZ+wtdFl+W3+AHPDKkEOmlRt7Bs81eP/tCuH4L2t7SvR/3JdPZV+auE1P4+Oejn4JIzgv05cGYypBF+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SQ/HRhSTUPAJcny8iglQSqomH26sDv1dVC2Lmj4hbqc=;
 b=WEzQw0+Pg8dmESRl10P0A/f85KrdvUta/noBdWIeYJ99LANHl0JSK+uQcLlM4jrRPG7eB0TP69tPAPlbkdCSuIp12PsiXYq9YA/HOqxU91E7an/EtQbfwSYoFugfXDkkhjfUQvqyNF64cW2QbzzCefR5SF4EyCwtO/UwbgW1OnOJEOyRvghMwr0J1eTQNq4WRFODMolL2PkLmzALR97+FpDEyfFGgtnNOLz2VEXul5F5MrbrrM6Nf+/e9wq+SLHubX/S3wgc0Y43DLn105TFtmoFSRVOL/G7QcIzWOp1RVO6Ap1o0n0YS4eF8aT6MQ0y3R1O5T/6A6vEKh3TWAYsfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SQ/HRhSTUPAJcny8iglQSqomH26sDv1dVC2Lmj4hbqc=;
 b=PF6mWwEvanGJx6m//LjdEaAzGS2frBA4YtoI/HcvvVFz7OLp8VCPf8kehdRJ8y2yqSnuP49SODx27o4nZflL9+sGxsMgpqoFOL63BqI5h9G4ndvF2DojgCm+U+fG8WOgtMmtvSUDQ+3QCBRRoiWm33aHbeVcfjCcJkR23UhE0Ss=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by PAXPR04MB9203.eurprd04.prod.outlook.com (2603:10a6:102:222::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.25; Sat, 28 Jan
 2023 01:07:51 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3cfb:3ae7:1686:a68b%7]) with mapi id 15.20.6043.025; Sat, 28 Jan 2023
 01:07:51 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: [RFC PATCH net-next 04/15] net/sched: taprio: avoid calling child->ops->dequeue(child) twice
Date:   Sat, 28 Jan 2023 03:07:08 +0200
Message-Id: <20230128010719.2182346-5-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
References: <20230128010719.2182346-1-vladimir.oltean@nxp.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BE1P281CA0128.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:b10:7a::18) To VI1PR04MB5136.eurprd04.prod.outlook.com
 (2603:10a6:803:55::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: VI1PR04MB5136:EE_|PAXPR04MB9203:EE_
X-MS-Office365-Filtering-Correlation-Id: 7542fb23-7ea4-4f9d-f302-08db00cc1407
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: M5JXpK18+WviQu7zIAfYg++n50k2UHKbAv1k/RO8wFO6+EcuFboulUGe55EguyJFmITXDuQKKW9JqsYM+a+yTfzfVrW503j/+KSUJEy339q1p29Z2BZb5AILYBOjrEcuLVXh1lbdXG75p2d+/ZlBQiVsZpYu6zQHnCeFxbyijbe41YIBgfP2Xr83Zdz5x/CAYE8YVwSVHIc90fMj0FXkqLJQyh48DokvDx1dwUt3JGvTHuj5L0XX+IkPSFYYtUyVjZ/zg84geFuOpi7xDkrooIzLejSd1QybZXLc45JmFOOhdiZeTBIoSVCTMgUWhaWTF0a8wGR/E00kfnN/gfw5i/GlNVhXyAzHPo3UDtycWKbusdluXeN3tJRG2mMmV7WvvcprgMoOmLjqkSOrpSQtxHC5CrkXyiAmL7hQBFK1VsEpPNAuugpA6eDj6qj+si8Jhe7WgxuTlq2uT/zfu/xylvrAoKyQc/XzB1A/P4Ct34qWJUrpq0kRyKm+ewptnYkrOKMsZOpATSSU8hGT6DmO019vMIUYOOKdE8fdV8efbfmoqRvYps/5vjka7CaXX/hBWTCfhs9LCOsXmNr6F71meNL0vhxn9ZiglSGWZIjLHRljb/7VzH+MNr4hdrvViAcOQlMFCqLvQGFm8JAiUgPzWWtYlFQ62ntG8k6jN6NB2YbGsy7F1nj6v7OyiXS00s8F9Sr382A6ZUvnJbxI+C1/Xg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(346002)(396003)(39860400002)(136003)(366004)(376002)(451199018)(186003)(36756003)(6506007)(1076003)(6512007)(26005)(38350700002)(5660300002)(38100700002)(44832011)(2906002)(6486002)(6666004)(52116002)(2616005)(86362001)(83380400001)(6916009)(4326008)(66946007)(54906003)(478600001)(66476007)(66556008)(316002)(8676002)(8936002)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?1P7Bu/8XM5XPkS7oCIZyskwW4NiKUCOVgRPb6jPPwCqUxfNPe9TZhZHWssXF?=
 =?us-ascii?Q?D9b2PsaDuJqW3fkSfGRmU3rzZUbASTG0ueGGMl6z9AtEt2AY3qI58HBgSDUx?=
 =?us-ascii?Q?GOnWQkVOtYFqwiyNhZ3SnhAVi4j1h4iVXVVXohbvepBrTtgORHQ/vAHK02gz?=
 =?us-ascii?Q?4YOf8p4KdGn3CMTLYBDM1VxoD2LxmVXYcpu4NDJeINuYjhk9k//q9k8CP19X?=
 =?us-ascii?Q?tMb7LJEryF+cYmrbykqsaR2O664gHKaYXDfkgI7dw5EkwtRdwJLuCrbU2AFP?=
 =?us-ascii?Q?BH42OpVMlyVHNVGk0Rk8bxlLufuvllp1BDP58/OChAB29feqZuNVeiw5kGD6?=
 =?us-ascii?Q?iMt2z8OlByeysOVzrU58SS5nNXG2lIcYGv/v+pLU0Nw02EZODLa9KFhUT87f?=
 =?us-ascii?Q?YWTygJPIOtgTf7bI/p4huic+th0kL4sPu+Q4Ps8mPLisxief22Rv1mV5fjMe?=
 =?us-ascii?Q?OK76WxnLz5b3Y4p1/RvOReP5gDDVb+pA5t4vilNcgJuCffKO+FIKucZf7E12?=
 =?us-ascii?Q?B6DL6uid44eeIS4hxN9+Be/+XnOkCzPbM9TfVmKUx+pF1wg9fBEicEsziBJf?=
 =?us-ascii?Q?gWzRdu4HGTS8J987WpURVuqXQyGeZ24+6pqSj5yoJo0Uo1r21AIGunBSDzVT?=
 =?us-ascii?Q?XNXU1iX8sYxk9sA6z4oD4gDMopIIljS0r5e4Tjm55FzbRl2ume9uJiJ2nJwk?=
 =?us-ascii?Q?0614Vp9r8xBGHlX52vgQDX8Fqvmycj8xq5c4of2SLJ4PBF2fn0Zij70CdDNW?=
 =?us-ascii?Q?pYAeLhE/8gv/cYg90Tz3348+i7KCqNsDAqcm4prxv8oRBHCmtLP91FAQMWyx?=
 =?us-ascii?Q?rxpgLeMoXAETH3RjkGzGggAGe8qzKWnz6II4awzpoQhwiuMHwx5hEM7sz1px?=
 =?us-ascii?Q?Iqn+RsmCY8X5lnMOy0OQ1NBEIHZiRDbD7sITDgMLKZ/f8CICtG/Cx5RoO6b1?=
 =?us-ascii?Q?XaJsYkzt0n1JyffziT9wGRBmRIvtB/K+i2oHa1yoRUuiLojWUGV4Nfm0q0gJ?=
 =?us-ascii?Q?61KfLNlmBVU+hYnelfC+kgoOCvjnlJuLC6o71yT6omFKSMiCqshtiT5mYj7R?=
 =?us-ascii?Q?QwaMfqRq2XlzwMCA1qmvPZ+VBNnToTsLnNTHlBply1tSvjmf5oxAcMlmcYgC?=
 =?us-ascii?Q?Y9G5jzmL0ORNV4tUP0WVCMdC2MZvd65o4fNAnJARQQFMFMx/Yvmg9ySgavOV?=
 =?us-ascii?Q?leuawUTjtGk0u0VIGiB/nYNdudPVkNdrYUYxY5djWrzvViZDG8BUQ/Txbfux?=
 =?us-ascii?Q?cn1/cY4jxlOBmHHiuknYHTXzgXWiPhpGNc2O9KMvCHHZoHyYanxj0lUJwwh3?=
 =?us-ascii?Q?NUtkWCXQU85IQUPaIufYyWktN8+vOgk8LdmE6P/Ty3JHTA+NWIpkR5LT6Xbh?=
 =?us-ascii?Q?oaxvyx+gQ+L+TeD87a99kUvLrf2QEWl48QW9tc5OZVFE8YkSO6S9IV/8Giog?=
 =?us-ascii?Q?CgANndsb2loDdnAErjDCPRLbzUdDywRyexycoECtVcLUt9gQk7EmcyzxmM+x?=
 =?us-ascii?Q?11LKZoQl7iMGiSqr4wyDijO6wahep2opBgN4KDXNDDz8VK60xNiGESeeZqdt?=
 =?us-ascii?Q?kFwuxqYnSpD8mUTjGVyuo10RuusFQAnj2ijZU5l00XVNhChh9jahBjslrI0z?=
 =?us-ascii?Q?VA=3D=3D?=
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7542fb23-7ea4-4f9d-f302-08db00cc1407
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2023 01:07:51.4169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S8vb4flHqhtnq/hyNDsIIK0xfbpLKy1Ba6ONtlVdNU4MN0404Ysgvq2sSR3nKP65SOkG00en0WnPjSexPUxeVQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9203
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Simplify taprio_dequeue_from_txq() by noticing that we can goto one call
earlier than the previous skb_found label. This is possible because
we've unified the treatment of the child->ops->dequeue(child) return
call, we always try other TXQs now, instead of abandoning the root
dequeue completely if we failed in the peek() case.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 net/sched/sch_taprio.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/net/sched/sch_taprio.c b/net/sched/sch_taprio.c
index fed8ccc000dc..30741b950b46 100644
--- a/net/sched/sch_taprio.c
+++ b/net/sched/sch_taprio.c
@@ -526,12 +526,8 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	if (unlikely(!child))
 		return NULL;
 
-	if (TXTIME_ASSIST_IS_ENABLED(q->flags)) {
-		skb = child->ops->dequeue(child);
-		if (!skb)
-			return NULL;
-		goto skb_found;
-	}
+	if (TXTIME_ASSIST_IS_ENABLED(q->flags))
+		goto skip_peek_checks;
 
 	skb = child->ops->peek(child);
 	if (!skb)
@@ -558,11 +554,11 @@ static struct sk_buff *taprio_dequeue_from_txq(struct Qdisc *sch, int txq,
 	    atomic_sub_return(len, &entry->budget) < 0)
 		return NULL;
 
+skip_peek_checks:
 	skb = child->ops->dequeue(child);
 	if (unlikely(!skb))
 		return NULL;
 
-skb_found:
 	qdisc_bstats_update(sch, skb);
 	qdisc_qstats_backlog_dec(sch, skb);
 	sch->q.qlen--;
-- 
2.34.1


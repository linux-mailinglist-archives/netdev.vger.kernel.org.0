Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9B06647D78
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 06:49:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229561AbiLIFtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 00:49:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLIFtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 00:49:13 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2079.outbound.protection.outlook.com [40.107.7.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CC7379E6;
        Thu,  8 Dec 2022 21:49:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=leEEkMrcnklRXNe0ddPFkkkKcrIn1k6cG2QjlsGxjUPN0sF0bYSCrZ3RhYr7xNjhToJzR8Te99MHKAlAiHmCNTqkbnY98SGPCHpQJ7OBR//iB2orkxjwloMPkS4hs5VeY3kny54OtUxi1+7wjKDdnzWeWio1ZUJo5tDt5BL/7RK7NDcL40xQ7EDYE+MWSTqMWmV3sOp9swEhr9uv+6i1xMHvjUWc0gPXLRqrHjlU0KynI1orYXoHOTaCumoC+dgY65o/6WtEYvH75xAkuy22BZT9b1okOnmqJnKzAWyf+PrN5Y03rcY2U3sPXUBMvg7rZLtE8iX+wnM9BAhseVqaxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2hGjgZ/L5gjD7eDK7KLTJRK8Ec12wHm78IV9BLntFsA=;
 b=YZ/t7HnEfQJQ0WiZK/YIVORznd4dfZ69uwLQFRWMw91P66yPhs6fxapPnRji7xwpCmnJgkJ0ndiCnX9EFYxmUqQKsbs7XOlb18C5bAG2m6B2I/6fGdqUGf5D0faxLIZ9jGB+U+clwv85YKBTsTD57ogd07/vKF3r6DdNeQ1hoR6/fEfT4lVwujjxkGntgCiA841CeAtaSPxRjLbAPc5nSGVyj4vQfrsGMUQTfFYOyIl990t9FVeYIrx5FtlrEzgbx/3r+CgOPcuyVtGNtXFcQkvnIbSRwk+B+2GYmFwWE1NctA9VN1C+C/BcwlNzgxiTSn0ox7xuh3+O2dDZK7bOnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2hGjgZ/L5gjD7eDK7KLTJRK8Ec12wHm78IV9BLntFsA=;
 b=JOIFNfPcawUbJyqU1LXuCuxGntgB+Nrem6ZZOLjwcXSMKBIRPlQErKZ8n+Yf2eX/QViMkZNRBdwWEXxpg9EmhEXy3PSU7gZXIORjidn0bS2t/91u3QCLs3tTz9Xf93P4vSqBo2k+S7s0OOkGUd7REnbWU7Ye5hXb2A8fKDdfUh7B/px6FvzCAmGred8egLsKQoRPGfNPG69/LupOqGiR93ri+DBr/v0ZcFrR4eQZn3COjm22mkZsmvwNpG2+t26oaLtT3hjqi3k/cYcPeOhX5m/q08oferlTXkzVBrJ4+tAxGM+SwG/EEwkTMb5j4X1BWh/wye4AaPlp+L0lPLETTw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com (2603:10a6:20b:42d::19)
 by AM9PR04MB7491.eurprd04.prod.outlook.com (2603:10a6:20b:283::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Fri, 9 Dec
 2022 05:49:05 +0000
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a]) by AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a%4]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 05:49:04 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     marcelo.leitner@gmail.com, kuba@kernel.org, vyasevich@gmail.com,
        nhorman@tuxdriver.com
Cc:     mkubecek@suse.com, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com, Firo Yang <firo.yang@suse.com>
Subject: [PATCH v3 1/1] sctp: sysctl: make extra pointers netns aware
Date:   Fri,  9 Dec 2022 13:48:54 +0800
Message-Id: <20221209054854.23889-1-firo.yang@suse.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYAPR01CA0001.jpnprd01.prod.outlook.com (2603:1096:404::13)
 To AS8PR04MB9009.eurprd04.prod.outlook.com (2603:10a6:20b:42d::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB9009:EE_|AM9PR04MB7491:EE_
X-MS-Office365-Filtering-Correlation-Id: 9b768b9a-dfec-4412-217b-08dad9a914b8
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jmt8Gf/gtur39bBpElUwzf0PiZ/G8U8CZ9KXq5aZGKtuXfBzmwXrhPEzJrlZ/SmrOdSx5NFVvx3DM6sGuIHKi4GGeatzBH3JbmEpQsEp0u9pk32h4vQ5EQI9RxeLLtEMKCMGig9rwGXzXEmvD0WDD0hD1e8aoAgEX5PJ9E3UpvgH7i/Dwldl7iQ7Ng4GPiwgst3DGKTCDj78ewEBSE7saARel7lXIbqanFAvDjyQiKUSA8VHbfx5yoRJuyAJiF2Qe9z83eS/zyJohHJf+gma+aJUbpfYXG7+9PZzPcn5F9XF8pNin6d7YpfjQ1LhNcqm898U1SOEr5SbBfo0aJOVl+12z1k8sXpxrX9ZO2JEQe71sKhPkBMW12YMMHu5OxvLyUhBrM2eoRSe+oOK+8CwXTXvCjJP+AR58UVNphNXAdXAO1NPMutFi5HbpQPuzedeE8sojiaZSlOp5W3V+ACSKwVHLf75KeBtnhV94nhaP7siwMwQdV4sUm0/h4+mIFi+uQ5IN84PEa84aokGT22c2BJlgbChOmbwqlcSu96FOnO8XJSPBEnynKs/isfEPhdvXc8TtSqxR/amd+clLEJvoCtgtsmMG/9MMIp+PpEM/AKYBoIhf1U/OdmnwfBpds4UgmY1qI2Cbg+M/OwqNj/78Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB9009.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(2906002)(41300700001)(7416002)(5660300002)(44832011)(8936002)(83380400001)(86362001)(36756003)(38100700002)(6506007)(316002)(186003)(6512007)(6666004)(107886003)(478600001)(6486002)(66556008)(66946007)(4326008)(1076003)(2616005)(66476007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?iJJrHQeGRFLS6RDIm7rPA62+OpQ3pmXlA9AwL7lYoxrFj08JwWhuJt/06BzS?=
 =?us-ascii?Q?j1PUOWQXf9fOWwTmCBhBV/0PF0CQLFP+6DiQ2/+K/dogykx/zF/VpfqCELP8?=
 =?us-ascii?Q?10sgeZiBY1L3sumMcSFpr9P58BDvIl2E7sXr3b9tTLFALqourO/3Z7k9QObF?=
 =?us-ascii?Q?NLCc33pG/C+obiJuT53AVnH5P0SMhcJgu++AjRzHCA8fG9TBtXmg97jL8YHg?=
 =?us-ascii?Q?HuEVQDrNiXVdPjDiH+HrydNEL9X4WxqZ/vYk8ooY/bk7DNR7vqCGXCgKdj03?=
 =?us-ascii?Q?QOLXOElF9dI+YNrjxScoKjohpuotDttYZ8V8k79YjVipJnzBLjjsXnsWEu2w?=
 =?us-ascii?Q?VxqhnbL1DXZgwfCNMb1GBmwK4TFJ5U0prZftB+CHOBqcAqNt2YDjh1rYSX+Z?=
 =?us-ascii?Q?UX8yRK1RcOTR1vlaGoSFo47sKVga365/O7C5R8ZhVnkCvC/BBJ1MUiUfnO6N?=
 =?us-ascii?Q?0tgoA0pbdCWLm1La2QFXx+qOFcPUtyDeDnAYLLGD1saFgbgzD3p9/f1Xs+Ot?=
 =?us-ascii?Q?UHdvkPLf+W7vT9pDxgRjaCcTU8pWWEDSXBs2kcGreThF8E+mpkcfF7DZYyS2?=
 =?us-ascii?Q?WVE5kYyd91DpFIlI23jua3cIMEJbmvU4PHV/0/OcjjKDPdMKp76JU5o+YVd/?=
 =?us-ascii?Q?ReyDaQV4grYyej4pNcIghGTot/F7JMzDtHe3VHxWNFjZTbdNRQwojjqmCevB?=
 =?us-ascii?Q?Bqm//Z/ReIigkvTA7rzpqfrhgAcpBtl7TMAM1nYB4m4bluLrHsZf0NiCvMi9?=
 =?us-ascii?Q?euCLOtX2oTW2+P3ZuuIRr+hAPZP5/wvEyxfpjd70KrBU577HrRUJaTBcvtf6?=
 =?us-ascii?Q?7L043BZ/0EoeUUTOZAt9cTkhFCZkCYf8euUL1v9VHTjEMtPXB/IX3VQz3Oxd?=
 =?us-ascii?Q?z2YNl69XcZNYtq88Pcmm94hq6zhqSBVr83H0D07QMJc/FNdyIgH/K4CuzGlD?=
 =?us-ascii?Q?hclsbsTHjYwHG42yABHWgrsVDgB1B4m+W1aMZITTtMhKEVPOLOk+w2yl0IjQ?=
 =?us-ascii?Q?zv69CiyDnsv9oWibefVN1BQuM+XF7ANrsvJaYwgCm4iKRRcw9IgMxc5HfBSr?=
 =?us-ascii?Q?55xsEB95UDFFcWXqqRXiQJRorvRkopSvHd7omWPalyVQYn4AUqEbTO5vd4hl?=
 =?us-ascii?Q?a6SHjTspdWQJR2pMKbckB73I2iOEj9x2M5/s/nwrDfiFMm3kZNWqBwMC1g1o?=
 =?us-ascii?Q?rTIYh4CVpgY3t1nzDySc0d2HJyY3SzQrc609F7fSieDh0zzaGDMv2AuJNJXm?=
 =?us-ascii?Q?+CLofQImG+RxxJBa9w7F6c8QlStxJFUjOCGiQGCb9cVKbMczzZpo0o9nLyY6?=
 =?us-ascii?Q?ovBk7Mi9Deo+m+FNbcxcOceoTz74VPx1RZ9t/9S2qA5xBxZc72PuV4SeWX9m?=
 =?us-ascii?Q?OWfIVTwCkCnWfN+ZDfn1VR9AV0Sp/wO6OQsKBgbHUAP145817zyiIXnqSyrY?=
 =?us-ascii?Q?vIQWAm4KSKL2SXVL78ua0sElcXC+En/gLouJOs6yQt78KS1CVvTb1gCYDfWr?=
 =?us-ascii?Q?eSZNAVHFaItsiq6bEZs6uxF4avbUli0BqmI4cQQJ89RdkwMOdsNWpBPVZn4j?=
 =?us-ascii?Q?tjsayvxukkDwRW3iqW9YATuMXdZWUrqtBn9W4PWSPN/pTIUvs8tIQlraIqpl?=
 =?us-ascii?Q?FSge0F7Qjo9utgH4IPbU5ulJOvFFmACYeHZEhiZsURvP?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b768b9a-dfec-4412-217b-08dad9a914b8
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB9009.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2022 05:49:04.8376
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YIGShJtPSw96m0sADzcZ+Rf0CQ/nr7PDwzFmbhUceGxxaSpL13YhpoCopx8G8BXqrdw6Zq3PBMnfRfxtTe60tQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7491
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Recently, a customer reported that from their container whose
net namespace is different to the host's init_net, they can't set
the container's net.sctp.rto_max to any value smaller than
init_net.sctp.rto_min.

For instance,
Host:
sudo sysctl net.sctp.rto_min
net.sctp.rto_min = 1000

Container:
echo 100 > /mnt/proc-net/sctp/rto_min
echo 400 > /mnt/proc-net/sctp/rto_max
echo: write error: Invalid argument

This is caused by the check made from this'commit 4f3fdf3bc59c
("sctp: add check rto_min and rto_max in sysctl")'
When validating the input value, it's always referring the boundary
value set for the init_net namespace.

Having container's rto_max smaller than host's init_net.sctp.rto_min
does make sense. Consider that the rto between two containers on the
same host is very likely smaller than it for two hosts.

So to fix this problem, as suggested by Marcelo, this patch makes the
extra pointers of rto_min, rto_max, pf_retrans, and ps_retrans point
to the corresponding variables from the newly created net namespace while
the new net namespace is being registered in sctp_sysctl_net_register.

Fixes: 4f3fdf3bc59c ("sctp: add check rto_min and rto_max in sysctl")
Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Signed-off-by: Firo Yang <firo.yang@suse.com>
---
 net/sctp/sysctl.c | 73 ++++++++++++++++++++++++++++-------------------
 1 file changed, 44 insertions(+), 29 deletions(-)

v2 -> v3: 
 * Explicitly specifying indexes in sctp_net_table[].

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index b46a416787ec..43ebf090029d 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -84,17 +84,18 @@ static struct ctl_table sctp_table[] = {
 	{ /* sentinel */ }
 };
 
+/* The following index defines are used in sctp_sysctl_net_register().
+ * If you add new items to the sctp_net_table, please ensure that
+ * the index values of these defines hold the same meaning indicated by
+ * their macro names when they appear in sctp_net_table.
+ */
+#define SCTP_RTO_MIN_IDX       0
+#define SCTP_RTO_MAX_IDX       1
+#define SCTP_PF_RETRANS_IDX    2
+#define SCTP_PS_RETRANS_IDX    3
+
 static struct ctl_table sctp_net_table[] = {
-	{
-		.procname	= "rto_initial",
-		.data		= &init_net.sctp.rto_initial,
-		.maxlen		= sizeof(unsigned int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1         = SYSCTL_ONE,
-		.extra2         = &timer_max
-	},
-	{
+	[SCTP_RTO_MIN_IDX] = {
 		.procname	= "rto_min",
 		.data		= &init_net.sctp.rto_min,
 		.maxlen		= sizeof(unsigned int),
@@ -103,7 +104,7 @@ static struct ctl_table sctp_net_table[] = {
 		.extra1         = SYSCTL_ONE,
 		.extra2         = &init_net.sctp.rto_max
 	},
-	{
+	[SCTP_RTO_MAX_IDX] =  {
 		.procname	= "rto_max",
 		.data		= &init_net.sctp.rto_max,
 		.maxlen		= sizeof(unsigned int),
@@ -112,6 +113,33 @@ static struct ctl_table sctp_net_table[] = {
 		.extra1         = &init_net.sctp.rto_min,
 		.extra2         = &timer_max
 	},
+	[SCTP_PF_RETRANS_IDX] = {
+		.procname	= "pf_retrans",
+		.data		= &init_net.sctp.pf_retrans,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &init_net.sctp.ps_retrans,
+	},
+	[SCTP_PS_RETRANS_IDX] = {
+		.procname	= "ps_retrans",
+		.data		= &init_net.sctp.ps_retrans,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &init_net.sctp.pf_retrans,
+		.extra2		= &ps_retrans_max,
+	},
+	{
+		.procname	= "rto_initial",
+		.data		= &init_net.sctp.rto_initial,
+		.maxlen		= sizeof(unsigned int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1         = SYSCTL_ONE,
+		.extra2         = &timer_max
+	},
 	{
 		.procname	= "rto_alpha_exp_divisor",
 		.data		= &init_net.sctp.rto_alpha,
@@ -207,24 +235,6 @@ static struct ctl_table sctp_net_table[] = {
 		.extra1		= SYSCTL_ONE,
 		.extra2		= SYSCTL_INT_MAX,
 	},
-	{
-		.procname	= "pf_retrans",
-		.data		= &init_net.sctp.pf_retrans,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= SYSCTL_ZERO,
-		.extra2		= &init_net.sctp.ps_retrans,
-	},
-	{
-		.procname	= "ps_retrans",
-		.data		= &init_net.sctp.ps_retrans,
-		.maxlen		= sizeof(int),
-		.mode		= 0644,
-		.proc_handler	= proc_dointvec_minmax,
-		.extra1		= &init_net.sctp.pf_retrans,
-		.extra2		= &ps_retrans_max,
-	},
 	{
 		.procname	= "sndbuf_policy",
 		.data		= &init_net.sctp.sndbuf_policy,
@@ -586,6 +596,11 @@ int sctp_sysctl_net_register(struct net *net)
 	for (i = 0; table[i].data; i++)
 		table[i].data += (char *)(&net->sctp) - (char *)&init_net.sctp;
 
+	table[SCTP_RTO_MIN_IDX].extra2 = &net->sctp.rto_max;
+	table[SCTP_RTO_MAX_IDX].extra1 = &net->sctp.rto_min;
+	table[SCTP_PF_RETRANS_IDX].extra2 = &net->sctp.ps_retrans;
+	table[SCTP_PS_RETRANS_IDX].extra1 = &net->sctp.pf_retrans;
+
 	net->sctp.sysctl_header = register_net_sysctl(net, "net/sctp", table);
 	if (net->sctp.sysctl_header == NULL) {
 		kfree(table);
-- 
2.26.2


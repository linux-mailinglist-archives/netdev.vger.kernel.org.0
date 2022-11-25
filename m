Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E95638972
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 13:12:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKYMMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 07:12:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiKYMMJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 07:12:09 -0500
Received: from EUR03-DBA-obe.outbound.protection.outlook.com (mail-dbaeur03on2070.outbound.protection.outlook.com [40.107.104.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 596A242994;
        Fri, 25 Nov 2022 04:12:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hThJgdhLUYwPz1B9R3YPoaVaEFZmhKjUmiTcapAvbTxjCNbhILXq7PTJM/p3N+n+xNJQvBspPlqrPNcwSF4ubHF271/qZn4fJwAn0TrH0JcKaAY6sc31J3uGRA6a/epGQ/ev4VwBlnPGMq/Vt5uRccQ0e3n1KaZTjGvYPWLrg1/EaTaNIsav4VObax2CsMesUeZ3GskECf5J8LKsxBl7UuvEnz5RfPoT1YcDXorORXIgDlKE3jbxKRe/DaX4QVXSbyDugVsMEBBRyfH3Y+kgszbS3FK+1jd6ai2YIqekwvLU706cPpZRhSGHXowY2datjjOUFnmrVXqltinYUmZ/cA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QnwkxFY4L8c7k1QOWdUSKz2nTt9ZvQAdihy8EjQhl2Y=;
 b=acZkO47XYa4dGfpnK4W7yN79cg0j7vUPCrARBFr2O+YDaeNsQr/RYDGBcuJuyzEIx94XjIfDdCael+NQwdIbdEwf+r923oOi1+IgndOGG5iJytIuEsZYpXjOCVqLHj9L1GzZWUKOGCfqH+9wEdY8Xdr3VfKLRDlX+igpjEapTV2BLfBKXAERGOQgzM+i49bDcD7bMdGjm2XJQw0YcXZ2RcvV1rprXaRNnxs5LlUXHkvAzcTUnyoDnm+wQPPFpHnR2yscH4b++sXRNO6i1HUrCGbi0m7tzFOy/+MrW7IyY5mb5/HPnc08Sbwhig+m+dh7VwG6SjR/6VYzKxwUGlvNAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QnwkxFY4L8c7k1QOWdUSKz2nTt9ZvQAdihy8EjQhl2Y=;
 b=JoXUrQG0TXl19ESa7xQjlC93Ceu8u12XijGS7fYpCXBaaAPsrvYN7qbT5+byeqRK0KkVZLbedInJZjZZ4KjPeUot86QGk0elKbunO35HwyVxjvYqxflFNgrovnu9Bz9ZZwGrG0qxAjtoo6Aj8K6AkcpzzOOMZ7umj8IeoEmbKlgt0PPQfIUES9JaWdlrMxPzhVw1fJvEiFsRGEDMqdGq+93KAcSOSsVHKWJwTW+gGQGihwKWDSHEn1Z5kYZzzYIPn8oyO90Mcl3rr6D7BJDsdZByU29WpZDn6Pw6lo03jE3iBkwzOagzFHqBoDJaLhU2XdgQuyWZDwccej5BTz8OgQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com (2603:10a6:20b:42d::19)
 by DB8PR04MB7083.eurprd04.prod.outlook.com (2603:10a6:10:121::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.20; Fri, 25 Nov
 2022 12:12:02 +0000
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a]) by AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a%3]) with mapi id 15.20.5857.020; Fri, 25 Nov 2022
 12:12:02 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     marcelo.leitner@gmail.com, vyasevich@gmail.com,
        nhorman@tuxdriver.com
Cc:     mkubecek@suse.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com, Firo Yang <firo.yang@suse.com>
Subject: [PATCH v2 1/1] sctp: sysctl: make extra pointers netns aware
Date:   Fri, 25 Nov 2022 20:11:27 +0800
Message-Id: <20221125121127.40815-1-firo.yang@suse.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0006.apcprd02.prod.outlook.com
 (2603:1096:4:194::8) To AS8PR04MB9009.eurprd04.prod.outlook.com
 (2603:10a6:20b:42d::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB9009:EE_|DB8PR04MB7083:EE_
X-MS-Office365-Filtering-Correlation-Id: 2c40b1db-9050-45d7-fe90-08dacede42d2
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: XcafJS5iHjMl/+FKOHgCPV/nC8YY3xiXYpr8l9IFwQpxwFYi+1nde0fW59Do1DIBtRPWIUuJuqVn6Ou18UOCmBRTsynyRgm8L1psDp5VD3SmEgHpWrBozLgT1dwrWqavlpOYfl66QF6Ybj3rrrCwQYJT+gDEB/xiu41Ds0DbkLEqJh90SF6otA5IcptUjM8DF8Aqc95eCPE0cdtJ0QtJfF8zOPBtmUueCsFV5/62KGM8cnGELq6Ed2iriVynMNH7E4Ji0YgNfoOQfvvAhNG+hh1Sz49Gw9Grpv6ifoP5DbtYbGAbfZd7mlanfp7RAyfHD7oulzBC4CTycUPgQ+AAmeYJ6Bu6yaqAgI4kBd28OPMl8ly+VYRNdlSXPB5YWzhnK1zsvtZGHBHZwdYZ+iFB4OkvI3sPgLEN7AlICc/YkWQXY+7lr+o3JPxa5ksoXmiEoSXVpXMdfX1WSLS9JWV3OcDSJheS+wFaQjY/n0odJSyE/cBFTTs+37h0Jq8hxSp9KevaB1n5ns5USeQHuNdrozdBj9wlZSyAOtYPCRSOAcWNJTY1P3MaY+ufU2TKWvQvq9ATJCA9Egi7IfDIKsc5gilwFsHKGAmvOEFh08/8Tbs74t8tGhW2NdI21aePU46HOGGpXyNgab5kIGfK5vJNNQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB9009.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(136003)(366004)(396003)(39860400002)(346002)(451199015)(8936002)(316002)(7416002)(86362001)(186003)(44832011)(6506007)(6512007)(1076003)(2906002)(478600001)(2616005)(6486002)(107886003)(83380400001)(6666004)(38100700002)(66946007)(5660300002)(36756003)(8676002)(4326008)(41300700001)(66556008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3O8J2TP7NYKdyTArmlGVvQy24QEIVG81HaC+2bm7sknglSAcG2S6bw9SMOpP?=
 =?us-ascii?Q?ac55G1OtY4nYqhi3hedzmPvZZdeltRZ54e5aDr3i3A2tQD2M0jM4lFcB9Bbv?=
 =?us-ascii?Q?4bySgWK67ZOTXrNYctnkVfjr42xWgPPdo4YQ+Qg7mRXXSrK1PyKucUggYQi/?=
 =?us-ascii?Q?vkXBP3ZMXXWDbo2Opquolme+rhDtifK1oovkoZkFQ6OtW9DNDC4rNd3YwX1Z?=
 =?us-ascii?Q?RHB2GmQrQDluB858nk66DPbolQkBoJf92m0N7delqf/t6/fsunyo6PMlEMkg?=
 =?us-ascii?Q?VG2ttOhSyBRHK6I7yXZRGUzGuuOANjEMnnVuWR74/B3XIK4flliwk4Jxltqv?=
 =?us-ascii?Q?2p6nXGODr9xi3oa/Kd++9a1vwo6V1GdRK+qhshkHc1HtodQK9ELQuoNqPGhn?=
 =?us-ascii?Q?vNn7KBYXiIZ6IwoS2Oz/2W9+wglRPwDkb8gt7OwzNuVnH34Q2slNFoobpY23?=
 =?us-ascii?Q?OZST9ubX13cNyDRp0kEjesL8ji8Q4qv9LiRvFARI2FLQRUXspnK0E/XumE0K?=
 =?us-ascii?Q?m0PHbcGFnOCAFPDw3mNFwsA6g7H9H08uO9RUaavsa30vWKHpX1eJeurkZlrO?=
 =?us-ascii?Q?BSMvFVtbFIEHQ3NSNCYEPzfWwSrpg2BsZqv09t7D4K0eUvvuEU/UBEZZHfFY?=
 =?us-ascii?Q?Yn7L2EgGAcRWZXQ3zNzzG+7No4sWc89VF4PmMwxkFO5gQYOI6VLp1G4zKf73?=
 =?us-ascii?Q?Rtu+sDqmSumuTlegc4c7FItUZreeB9ruHwwJdRtQP5WTDuev5FTctZO+Vnjz?=
 =?us-ascii?Q?hDmki4HTGyQBvFcp09G4MnIZUdOEKkB2TnM5Gf1+jyog4O+2DG2AY1iHZ2EX?=
 =?us-ascii?Q?Q6U5H+NyU6mqlt8igX9HUSaP8F+erIz6lK58vUSwtqmqwaT7/NvOJh4/YJr3?=
 =?us-ascii?Q?ZeFhT0aH74/64M8UOX6zDpIYTbR7SfIMsIyyjI4ec2udou7P2g30khrlxE6q?=
 =?us-ascii?Q?pR+X7ve8ftmF5K276zplX4mzUeuqX1vuMgCwSvgVA1dTNTDSP+ifkGqFXHAJ?=
 =?us-ascii?Q?Rd2fvt1/pT9fo6RQM4EP8cRM7PkKa6qIBPiy9vNUvtg/wsDP0bH21vB1EV6+?=
 =?us-ascii?Q?h7zQ+0ePcNO5dfdIQm7aXRbfYW0eHPLHOP4K10w3F/mpBw/+IK+VIaDaD4gg?=
 =?us-ascii?Q?qwtGEJMs07Z1zNhP6g2Zwrrg/rT0ztFqrnnkMm6NvQ1O5pnZteiFgDzwZ1Y7?=
 =?us-ascii?Q?NrWAryztvIYMCBevqOfCubVNy9fus66JC0kHBSoye0BEbV/EQbGG73bG6I5C?=
 =?us-ascii?Q?oX9e3qIk3o/f6MvCRGufLsCt5qJS2/92JpfRJ/A/aOYQt9K23Wz0ZfaWePOw?=
 =?us-ascii?Q?ss4n0dJTEZ6lF+N5ImZPSEqPxHNE7BS2iBIUlb19V02IPNvQFvvW/u4d5udx?=
 =?us-ascii?Q?E0CFOfyV/YevcphOYIPeWiYNA2EPwv6tTzQSU3Bvlb2hmDpmWpCd9wIVBLRy?=
 =?us-ascii?Q?8eUrZU4QTi4ZlrKQfS95QqMEHdUKGoYGhIi71gVFbj6VicsTeskweHyGqyai?=
 =?us-ascii?Q?KTQgcBGW/igGekCOq9HMolMMNcQqFwTadWInX5qTr8X+Vp9dTfwr43Uaz/OM?=
 =?us-ascii?Q?C8t6tVw6hbxqLXPnTt3CwcdXCFM1EET1ra7UxyKNAFYdDsI2dlAflP1UV7g5?=
 =?us-ascii?Q?1amH+otALIpysLhbFNfNBAinKDh+JoN/v3ZOFQ6Ot6ID?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c40b1db-9050-45d7-fe90-08dacede42d2
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB9009.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 12:12:02.7719
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RdpEG57hfwmKJh9+0aCI3hXgIRkW7zQIVlcnYo4GtqBcwCrgr6HqHbjfrVvvoZbiAZuKOS7Dxbw50Pfgva7YLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7083
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
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
Signed-off-by: Firo Yang <firo.yang@suse.com>
---
 net/sctp/sysctl.c | 51 ++++++++++++++++++++++++++++++-----------------
 1 file changed, 33 insertions(+), 18 deletions(-)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index b46a416787ec..516ab67475e1 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -84,6 +84,16 @@ static struct ctl_table sctp_table[] = {
 	{ /* sentinel */ }
 };
 
+/* The following index defines are used in sctp_sysctl_net_register().
+ * If you add new items to the sctp_net_table, please ensure that
+ * the index values of these defines hold the same meaning indicated by
+ * their macro names when they appear in sctp_net_table.
+ */
+#define SCTP_RTO_MIN_IDX       1
+#define SCTP_RTO_MAX_IDX       2
+#define SCTP_PF_RETRANS_IDX    3
+#define SCTP_PS_RETRANS_IDX    4
+
 static struct ctl_table sctp_net_table[] = {
 	{
 		.procname	= "rto_initial",
@@ -112,6 +122,24 @@ static struct ctl_table sctp_net_table[] = {
 		.extra1         = &init_net.sctp.rto_min,
 		.extra2         = &timer_max
 	},
+	{
+		.procname	= "pf_retrans",
+		.data		= &init_net.sctp.pf_retrans,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= &init_net.sctp.ps_retrans,
+	},
+	{
+		.procname	= "ps_retrans",
+		.data		= &init_net.sctp.ps_retrans,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec_minmax,
+		.extra1		= &init_net.sctp.pf_retrans,
+		.extra2		= &ps_retrans_max,
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


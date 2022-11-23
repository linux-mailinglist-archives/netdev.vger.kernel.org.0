Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 719D56357DD
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 10:48:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238187AbiKWJri (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 04:47:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238183AbiKWJrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 04:47:12 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70044.outbound.protection.outlook.com [40.107.7.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC86E2AE1B;
        Wed, 23 Nov 2022 01:44:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cqnvmUcw0f6AbmTnldDdBh/Y0FbhuZpyAku37EN4EkIuGCW1J6Mxb3tB9TcNzrl5J6UY585byCdxq4KtIRBdc511d09MmiNQmKKJzSEup6Y1IprwvhQkv6vrubBwXOHVRYLFD9MUIHSHoIxV6v5JN9UwguEheF6471yBnvWdpenVeQjCvis4bxaBDAfd2vHUmjpOZM8VcRVZKuovd4Nb9DiDamgmhdVsMHt+v3dS28Pfaa31/TmgRMuI8o2UrRxJDHkPNrz4nlDYuTOiJVfWfjtqX3rXrF3aKvO93RCMSWEtWONYWMU9p2rVICIvafFMhWmr2IIV6+0RrJhz8Debgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VJtCMomGTuxfCsQ0zkm+jz89kZG4Tyn2z2H8MIAH/Sk=;
 b=TBWb4Q42vKANpRQLsh0Ycg6CLZJLBFld7373cm9fKkboNVGAPJkSJC+Ylx2naPECgfI7yEGvoI+7LnV3xkibuPbT93LBMiqu3ve6tMhH9ilDcGtgnmZ5iifW5zYebJggDLlpCSsAQb0v1dThjiofur9LqWY9mrLRx+nKYp3LrVQd8UfYiH5FFioLA3kFEN3nIRS31eetZ2aEROZ+7MeF5Pyb4wAavihGKtzHm3CF786djSEo1P5PsvGa1sweNlnFKfSmXwX5zJJ0jdHbw2QTfpssccc7NQhg6oGNIdF6cbUGTEfvbtVT+M5zhvMPEjsq8iGe/cWe+2PBJP0u9gYHrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VJtCMomGTuxfCsQ0zkm+jz89kZG4Tyn2z2H8MIAH/Sk=;
 b=znVj8hZcbgCJk5p9hlzACkb0t5wGKykhWTVt25tnJbXstuAOjUv7cVPubIXxas7Xvp+YlOe74FhxMLG4rpW1lABqhvHj94slc2OWQuL9C7fT0KRzrwyHgRVNze6AvcDZ5/BkJ0Jwe2mnc8gGkzZrLNgPJsQpn+L6MR7uqZ/8dURulAWGPfucot9Sqaru190q+c5Ajwrvlh1sQIrAyFjtIonCCnsm4U9ZzpzAR0PCT6vmgXqMqeLVZ43eFvPCDW82RliWCS6iXuUoWr9hewxhF1m7Uxmnqrb0d6+peuqJV3BZAyeK7VPdTa9ODWHTKwTHnFjp0fTKwarCwba1Y3HDyA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com (2603:10a6:20b:42d::19)
 by AM7PR04MB6855.eurprd04.prod.outlook.com (2603:10a6:20b:dc::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.17; Wed, 23 Nov
 2022 09:44:16 +0000
Received: from AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a]) by AS8PR04MB9009.eurprd04.prod.outlook.com
 ([fe80::696b:5418:b458:196a%3]) with mapi id 15.20.5857.017; Wed, 23 Nov 2022
 09:44:16 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     vyasevich@gmail.com, nhorman@tuxdriver.com,
        marcelo.leitner@gmail.com
Cc:     mkubecek@suse.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        firogm@gmail.com, Firo Yang <firo.yang@suse.com>
Subject: [PATCH 1/1] sctp: sysctl: referring the correct net namespace
Date:   Wed, 23 Nov 2022 17:44:06 +0800
Message-Id: <20221123094406.32654-1-firo.yang@suse.com>
X-Mailer: git-send-email 2.38.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TY1PR01CA0184.jpnprd01.prod.outlook.com (2603:1096:403::14)
 To AS8PR04MB9009.eurprd04.prod.outlook.com (2603:10a6:20b:42d::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AS8PR04MB9009:EE_|AM7PR04MB6855:EE_
X-MS-Office365-Filtering-Correlation-Id: cc563c60-001b-4cf4-723d-08dacd374958
X-LD-Processed: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba,ExtFwd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /RSRARIxdCBzBjOT+nNW9J38UnYkICAw4jrd4kBryS7UaT4DruAU8ugB3LyGVIhsSJMOP67EIT8hE+zwXbdl4rRG6Iq4tcXPuJjcv3IPd7imfy6Bvsp/XXJbtuDl+lcO3OF2APPW7yQt0+DHgJBTjeTdkFrBnNtL/JUfw1p1KqBUJCctePN11GGeCQYmVBiMqgTdI8xEcRORPBXRgkofq6CGJlHXmOdf3bFoPhi2ilB+YKjpCvB2FKeyuqBUvCIL8hGK2RwwzVvGnqJlSBv44wVDN0RYkX3+szrwCtokrokCqS5uX11sDaACUi0Fj4ji2wFrG5EbFO4EZwkJ3GBHZZonv3s4jCmeSKhu4V2jM8bDuhkKZvjqu+W6EicxXvqq7ONjX9v0xq6a8VmBOPzi6b1L6hVTqdNDUIPsSbvI3jjasBdrMoNOklax7XJJyQ0bXuUqvsvKQQfOeg27u/X/4CMLqzQv7TWLlKNZHfQCaHfX/kQwJ7qmxjyeHlG3wZL94L36BeuJ7er4DapLkHHEjQR2xhk0IbtoKYR5kH4XBZGm8opwy3UkGAVJFjgy/WU/yIcP7SIqxMJyHaeVnIboEh8/1QajHFSmcdm75qpvEbDXRUI0tN31Q5Hq9mBA4ebwtzBS5RYQflWSVbDTbbTj2g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB9009.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(346002)(136003)(39860400002)(376002)(366004)(451199015)(7416002)(316002)(8936002)(5660300002)(186003)(66556008)(2616005)(86362001)(66476007)(1076003)(6486002)(8676002)(66946007)(6666004)(107886003)(478600001)(4326008)(6512007)(6506007)(41300700001)(38100700002)(83380400001)(2906002)(36756003)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?oyRWWidKv+T9vkOPRP/JsR7amsBIjMW5xSGN/kVE9HXRGwivZKjsiV0zjELW?=
 =?us-ascii?Q?cW0QAnoy+5RyRcFeuqbAmvDzDhLZ4c9F/NJnmZM1oc/lqd2npy3rbr5IxNiO?=
 =?us-ascii?Q?iigLZTdNH/g9RlFXHOmBT0QolTPl67TNr5e6Qs26HxrabRu2T/RmMQuiIrlb?=
 =?us-ascii?Q?7PNOr84DzUcnt317rU5e1hq2Y6gjkygtwN+pbeRu2MhlxTWa/NjelubBcDhr?=
 =?us-ascii?Q?letm7lrG9PebG2p8NC1vULIuudLgZjOsUwWmugTwrgSLvs0q2EUg9Djmi1bC?=
 =?us-ascii?Q?5qvq1Vj+R03147T0dgUKS96U/i+WvtCpydMeJszN2Ma15MYreMfNgKHYa7nf?=
 =?us-ascii?Q?I8+kb6yvJcAxjdxWQdSNOIhfB/UHPO2g1nJ6fJCNZ7NPQnM1A9gopvc15+73?=
 =?us-ascii?Q?FgazQTaQdeRGH6vfnA2ech8YjsIOC0o1AaYjHIokN9y2VHL4NYwRHNg7EOVk?=
 =?us-ascii?Q?BO73TTMVkuXLiCd9eq5XAqj5j2RK/QwwtTwWjHaXY6VHDAin1p7qEKGhYZSW?=
 =?us-ascii?Q?gbIXRNNNT3YB5tlrhyVCfWFztXnPYy5h7NR2VQII4TqJHVG9W4Ehq8KFId6w?=
 =?us-ascii?Q?L4pgW5kXGBZRI31n3+K6w66M1o7JuCzEpi7EbcKhHHpg7Lbwbm+TtDVy6crb?=
 =?us-ascii?Q?kh1krvoo5HDXQxt8sQceqdwl7hoAKwNUhDzbZvfxGsdH0TdwgjfoLXNkebkm?=
 =?us-ascii?Q?WOoO1IeJKfiLSWavXCtROOABRYIvwTfB9qtlduMJKwQ6+yGBIrTse0n/AChi?=
 =?us-ascii?Q?eTvA0xpUcVDmUdykmBGAL0eRSNrZg3i1RXjARvCaXcGwABEc+e0YYUrYhUYb?=
 =?us-ascii?Q?Qvy6geTq2x1bfstBS2eewTQqJAqCe4QPZyBMrgo2cVy0OeBI64imfhHVxRqS?=
 =?us-ascii?Q?sUt005H6wNUs4Wnk63z1xlfasMvyeEKZ6RMLDZZoed0xCuXpQbQ6nt71xCNS?=
 =?us-ascii?Q?qvk5/JgwadimkkV87XX1+z+rG6gEaGItK70NrsOPchSw9XpHs5gQWoMmSgWv?=
 =?us-ascii?Q?lJnLxnGbr7fhf2O9+V2NRa9LfNGy8mVnVYIqJJxyt3cPjkU5FFf3zG4Wsrtg?=
 =?us-ascii?Q?inPKmTXzZlolw2sabZG80fJxOMTQ3CbZQ0Web7ZZXivCTUUs4LG3iEwNW66u?=
 =?us-ascii?Q?0IHncAJXJYWbT8iJCWUMFaEFMdzcpRym/XHo2zvy0spqJ7C/+SN6P7u6gXyQ?=
 =?us-ascii?Q?ofY32sZo9WLRDirtqw9J2Uli+iKtN+Aqi7bTWtF2ClH7dUio5kdFK6l0IhsH?=
 =?us-ascii?Q?G9rUDlpjkA6kiovKQnjN0r/t+mBrse6wrlJ/tTiFKPDxc1VMWe5DfHQDnkKe?=
 =?us-ascii?Q?+gdKw7xJ9Ls0YwDRDMvius3Cp3ZPhCcsrQRrwl00aj8z42Eglh8G8BKLJPcJ?=
 =?us-ascii?Q?5kBZayTjSSCy4w03YPVj72bo7+zhEaudRpaNDZvFi3SMznj53lzqfphi9906?=
 =?us-ascii?Q?EIpehfQSGVH8HFTSFB9rlEbwOM1aqJPFy+37SDWFGEx3+DWjbMMgcLXPH78u?=
 =?us-ascii?Q?4Jow2i9y9pkcdgTTA5e0uVieiBhwKkJNEvjC4ZoYK7SlzGouDnBnwVrXpULk?=
 =?us-ascii?Q?faahF2JnPLYFHYvFNlvrAGtRm9a+vhdYrBY0B7I8XWWcXUXVjRE2o0J5lFJw?=
 =?us-ascii?Q?Mrxxt/KsqAJnEZrtKleXQYBSv8lpR9GcEil2LcAi4OFF?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc563c60-001b-4cf4-723d-08dacd374958
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB9009.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Nov 2022 09:44:16.6765
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vSfMDomz0Ve2USl8WCUbEM/pYDCLweUGxOXJHNwCbCNuQPkVjI5XXg2QL5K+kohLOVqYv2ErPGMaOUj+LDbkjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM7PR04MB6855
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
does make sense. Considering that the rto between two containers on the
same host is very likely smaller than it for two hosts.

So to fix this problem, just referring the boundary value from the net
namespace where the new input value came from shold be enough.

Signed-off-by: Firo Yang <firo.yang@suse.com>
---
 net/sctp/sysctl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/sctp/sysctl.c b/net/sctp/sysctl.c
index b46a416787ec..e167df4dc60b 100644
--- a/net/sctp/sysctl.c
+++ b/net/sctp/sysctl.c
@@ -429,6 +429,9 @@ static int proc_sctp_do_rto_min(struct ctl_table *ctl, int write,
 	else
 		tbl.data = &net->sctp.rto_min;
 
+	if (net != &init_net)
+		max = net->sctp.rto_max;
+
 	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
 	if (write && ret == 0) {
 		if (new_value > max || new_value < min)
@@ -457,6 +460,9 @@ static int proc_sctp_do_rto_max(struct ctl_table *ctl, int write,
 	else
 		tbl.data = &net->sctp.rto_max;
 
+	if (net != &init_net)
+		min = net->sctp.rto_min;
+
 	ret = proc_dointvec(&tbl, write, buffer, lenp, ppos);
 	if (write && ret == 0) {
 		if (new_value > max || new_value < min)
-- 
2.26.2


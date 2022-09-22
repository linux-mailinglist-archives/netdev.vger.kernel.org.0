Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC2B5E5B44
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 08:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229919AbiIVGWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 02:22:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbiIVGWU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 02:22:20 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2072.outbound.protection.outlook.com [40.107.223.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF622B5A4C
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 23:22:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ha/TLZDwdkhiw1CReL3QF4VHANJZYOcwlimlWjA3rK6t3CWdzqklvUNVbNJ2c5i4QYkRFz4uhC4YRvaGbeJAG5J7HdJ6KaZvImS1B9szLTNSCye+kGq6kJ5hUDiTaqkTu7WgJiMc4rpkD+Z6x7VmtOi2gGScS9XPzDJkmjwlamwsopeE6SCqmubAQrBOXsSXqI3SWjIAxtA2qG5b0TJ0J2Juj/bCSyQB6IzIdKa96S/BCI7tonzy12adaTJ7AG6cvkZTHc6GGIDHJkh/2KaZyDU46geI4ESxGd2Zx1POhl1/xjDo+RLWus/12FwrD1jvdYVGs9O8ePeYgeYbu73u5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9xE7gh7AzNDz8r8hlym+M2agT/nnW/ntN9rB5cXYhxE=;
 b=etm6+79IfnKS3VhmQhEf7FMLlgYgOnRdiUjsaFbhQQS6QPOPiR8esYPcVjLozOkfu2CC1S/3a33dpuyaG582VyJsHOzhhHvWnFDKGQrgAPFBepx+xYScgSsEULsH0pYhGPQllZkHQqLSCiEmPCfM0PnKFpKLzad9omJohWUBpv+X6cdfadlpUbynlaRNa3pWCKIyEslATk/iNsKnfacl3vJaE5lxCPQ2uMHGRJ1BapL5bZtNcZcLtZE9PaGd9EdQmmoLJGWpGTADORXVaDC/WGBFoXldpl3Fbu6RMcQdk9U9v/UGMnRwo1bV7rgBIuPXLjnsUz7EEFglwZOhBI6GAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9xE7gh7AzNDz8r8hlym+M2agT/nnW/ntN9rB5cXYhxE=;
 b=Z7A8MZ6YGbGUzN8Ds37KdCRYLS8w6s6Zw4sr4upLMxSCZUbPeV3gCjX/8kRN1Lge8Aw7NXmHV88QsOJ4+oluc9z7GKn5ufYswP48Pk+2X4vSO+tqaGxwtVpQeiRdaW08veGGnEn0I9QKWrcHJ4aTPtEHiooe7EVzFIpS1iN+eRU8MVmhMG+ol9iLzOD4Ro5RTFZcfqg9yOJopvFOQ+3n7KP97uch6ousn6cuIMHI00d0kBd9mfsdrBxcLv+e2Y2nk+YQEUfDqiY4c7yMJyBkJl0XFz7SBi0oldueLStxxa05FHPCfXI4OucWhCfCzySsCaFshxj0KMf0fLeDYWzAeg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by DS7PR12MB6237.namprd12.prod.outlook.com (2603:10b6:8:97::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.16; Thu, 22 Sep
 2022 06:22:18 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::4842:360d:be7:d2f%4]) with mapi id 15.20.5654.014; Thu, 22 Sep 2022
 06:22:18 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2 1/4] bridge: Do not print stray prefixes in monitor mode
Date:   Thu, 22 Sep 2022 15:19:35 +0900
Message-Id: <20220922061938.202705-2-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220922061938.202705-1-bpoirier@nvidia.com>
References: <20220922061938.202705-1-bpoirier@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: TYCPR01CA0081.jpnprd01.prod.outlook.com
 (2603:1096:405:3::21) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|DS7PR12MB6237:EE_
X-MS-Office365-Filtering-Correlation-Id: 75aa328c-65ca-4f9e-e8a2-08da9c62cc85
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UZ0mTHFMQkjKVXibpCIrN850SruQrxwNeYWgDN7+uwHjsG5lpiKwg89eHffQP2x0bktkwPTvl4Kldp6Wi5W6YmJqSzaoxyVOi4sMnqV9PW1/VUWSXEKPhlleQA3B8HcFWi4Df3COY1nODfOaLuXszvPClvPteNjK7T7SdpLR78KGEK7uq1OcYUQ0e7SzyYVy8Y+8ab5Rhy/jszGUpATOPaL/el+yaJDZ8ETAqslRke/SZMRKMH7sQW89oNdDuHdK+3rPRJEj+OXkYrBdAuWPPHl2v0foLToOrdk2EfNBu2vKidG/r1OmOI2QSnAiGt0X8Y9fsToPrSUWwioIgBfKK63Q35e9X5JsDYpVU9oZUPJ3u5ysla2asLPclz4PjZCYFyzUagig2o4oK8Q19akfeM6DgrRsadjcmoYKAEyoJwcN6LubWBhBXTVUDtpJBwEjq2ptoaLfVW+gLEDMB+/qsLcGIGwn+tl0M3kWL4AS7qt6gCCTo5OrVOgBIXhS0RsNorUVB+AmjfOaO7hpiFdQQxt3GYZJs+kpMh2O0RvRG6iVTPxp0i7t1KQDr5LfTO7avA4RTsERgD50TMUC1ExnEwujg5O0+51/S1spYCk4YRp0ShI7tDSVeYF0sZnz/QrpGh4PrQelqmADyULYUZJ4fu2GWLWtwKtol93B0k9CL0kJOuEcFJLqsGCSymGVWMvku8dih4DxFRbfnjV3OoE7oQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(366004)(396003)(376002)(136003)(451199015)(6916009)(54906003)(4326008)(478600001)(316002)(6486002)(86362001)(8676002)(66946007)(66556008)(41300700001)(66476007)(8936002)(66574015)(83380400001)(26005)(6506007)(186003)(6512007)(6666004)(5660300002)(107886003)(38100700002)(2616005)(1076003)(36756003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?CG3tJZRiV0hvcP3mx2MDxaU4bRBy0+KpSD9Ozno2dbzz2pL7L7mcqxcqLKm/?=
 =?us-ascii?Q?I6/ikXyGTaSBLU+/fmS1qXIH5VlYTY2AymZLCWhv+EweUWpruH8dDNSecI4S?=
 =?us-ascii?Q?zJp7rBW7RCF2P9DOEo7Qn11XrbMsboTgvaZhjt/Ni78MZeUyu/Ji3oYR8h9l?=
 =?us-ascii?Q?1mAi0TIRmRBk3vwe6qrMrYYFwM83QrxhLK+oeOGafBH8uEpkYEH1Z69gBAuc?=
 =?us-ascii?Q?oaICgUb9KV1cAxqu4tnGLpVoCp2eOeOJ7tdiE6/3sbGhOdl78PRFk8614Vdt?=
 =?us-ascii?Q?g/Jv7yUv6s7aXjLNQfFn71bkPCPEOT/rqcgyZ8WazPMEUx14/SRNxtnV7idH?=
 =?us-ascii?Q?Ps4VOYEKBY9OmkyKUNI5h7o7iFFcJ3crPErBvJKaRKlAj1kgIe1vxNw7dbkj?=
 =?us-ascii?Q?zqH8M0B4DlJ1g1nwOptOEZo7kkJLdft7Us41AQCLZMGGBaCwNplh3aNNBTOY?=
 =?us-ascii?Q?wpkJxP9d+AZ8DCiGD9DM7cisSmhGpbhagH3JVMDUnoQRLEEpJkYzW0qZSjgH?=
 =?us-ascii?Q?kauI9/qr8ICiLnf+K/Lh39bO/PFq1yzLh8SaLhL3lPNQ2J4yLdWP26zoWU09?=
 =?us-ascii?Q?9WhGkmWMrhs8i1r3ZPs1+vuY9PiEQ+spkRmjO0NRQlNzLbxTc/HmG/AbnLzE?=
 =?us-ascii?Q?kPNnJKfduCRPZTi1xiJQmBE7/0IA8m8qAK6aOJYRfS9a80kGkvpCOWMcLV04?=
 =?us-ascii?Q?JChgsgs502s/Kiqq3mmxmre+TZcwj8E7MXexBKxM+ZkDpyYe8oBcSikqbDQU?=
 =?us-ascii?Q?v+xHTiZJZpY3QF5OKQhgeknNUeyyHpu2dfo/R/uZHz6to1mvbg43+GG7kQS0?=
 =?us-ascii?Q?hPCQ7xHp4K8PoQ1gpGCZP8Auhthku9ZqGKhRsE6vlEq+NsI5/XMj3ZJRX8+k?=
 =?us-ascii?Q?hAY6UBosZ5g2EgfrUjorBt7r2SP0NI2LLaIYYtid70Mpz8t59wisJQ+cv90y?=
 =?us-ascii?Q?iXe5pVDoF3Ro2Wr37nSoTiAnPF8pL/vYmcPV6SMRXHAiiAo0e1IPXU8L8Z2c?=
 =?us-ascii?Q?YibbTlSPrtiGzS+J93ofWYkJ8Sej7tc2EW1FZY1eudiqaR4IHavSkC7GP8vo?=
 =?us-ascii?Q?x4wfkX+FyT73GjdEt9pDz5QDOfpg2v5tjh4+QhxPDPtUC1Y1LcFiVAQswW1r?=
 =?us-ascii?Q?90lcFVa67PHaqZmUqz6J3rHMM6D2LOCj2cjEiAlYdTFUbBi1nXIjephj8G8M?=
 =?us-ascii?Q?v9bVtAkQxu6SlIAg/1hc/WX4pi+Ihcror1Zy/DnMZZeEzo7Lgga3WCrCvgCe?=
 =?us-ascii?Q?gdn7Ec+ASOhvL7BZv/but15HseY9lDqIzcCkMVkGspBh54pUlPCWE/Vjn+Ac?=
 =?us-ascii?Q?q044dTXXAHStkcjTp6lBbpExSuHMNc9RdOnTrPoKfNQJBNfKHVp1FelwZNlN?=
 =?us-ascii?Q?/o8lfMZeLwB6HRIQLPPTA9HNc7u/YcL+WyWXlgmXgh6PuiMEv2M5qD9OF8CG?=
 =?us-ascii?Q?1ckDCrBR4hYcHWsiG/Nztsu7PvMGJbuvPVsuMozk54XxnQQsr21ubMLDr21J?=
 =?us-ascii?Q?QFxbkALEi6q8Z2p1ANlWD6atUxhF+9xV3d2gaunReuiQaCYj386AHqk5AbHm?=
 =?us-ascii?Q?6flUbogthUbknq56RSYUaWAXmkDe55S864tsqkZt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75aa328c-65ca-4f9e-e8a2-08da9c62cc85
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2022 06:22:18.1213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2dhMpx2yB2BGbVvIAsEOP4d27RudO/0n/nYY8T4EDNCvOVDb0fn3WsDsBkyLtaz2bRJ6GbTj1NtOlsiCPZGxzA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB6237
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When using `bridge monitor` with the '-timestamp' option or the "all"
parameter, prefixes are printed before the actual event descriptions.
Currently, those prefixes are printed for each netlink message that's
received. However, some netlink messages do not lead to an event
description being printed. That's usually because a message is not related
to AF_BRIDGE. This results in stray prefixes being printed.

Restructure accept_msg() and its callees such that prefixes are only
printed after a message has been checked for eligibility.

The issue can be witnessed using the following commands:
	ip link add dummy0 type dummy
	# Start `bridge monitor all` now in another terminal.
	# Cause a stray "[LINK]" to be printed (family 10).
	# It does not appear yet because the output is line buffered.
	ip link set dev dummy0 up
	# Cause a stray "[NEIGH]" to be printed (family 2).
	ip neigh add 10.0.0.1 lladdr 02:00:00:00:00:01 dev dummy0
	# Cause a genuine entry to be printed, which flushes the previous
	# output.
	bridge fdb add 02:00:00:00:00:01 dev dummy0
	# We now see:
	# [LINK][NEIGH][NEIGH]02:00:00:00:00:01 dev dummy0 self permanent

Fixes: d04bc300c3e3 ("Add bridge command")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
---
 bridge/br_common.h |  1 +
 bridge/fdb.c       |  3 +++
 bridge/link.c      |  4 ++++
 bridge/mdb.c       |  3 +++
 bridge/monitor.c   | 35 ++++++++++-------------------------
 bridge/vlan.c      |  4 ++++
 bridge/vni.c       |  4 ++++
 7 files changed, 29 insertions(+), 25 deletions(-)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index 841f0594..da677df8 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -16,6 +16,7 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor,
 		   bool global_only);
 int print_vnifilter_rtm(struct nlmsghdr *n, void *arg, bool monitor);
 void br_print_router_port_stats(struct rtattr *pattr);
+void print_headers(FILE *fp, const char *label);
 
 int do_fdb(int argc, char **argv);
 int do_mdb(int argc, char **argv);
diff --git a/bridge/fdb.c b/bridge/fdb.c
index 5f71bde0..775feb12 100644
--- a/bridge/fdb.c
+++ b/bridge/fdb.c
@@ -179,6 +179,8 @@ int print_fdb(struct nlmsghdr *n, void *arg)
 	if (filter_dynamic && (r->ndm_state & NUD_PERMANENT))
 		return 0;
 
+	print_headers(fp, "[NEIGH]");
+
 	open_json_object(NULL);
 	if (n->nlmsg_type == RTM_DELNEIGH)
 		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
@@ -810,6 +812,7 @@ static int fdb_flush(int argc, char **argv)
 int do_fdb(int argc, char **argv)
 {
 	ll_init_map(&rth);
+	timestamp = 0;
 
 	if (argc > 0) {
 		if (matches(*argv, "add") == 0)
diff --git a/bridge/link.c b/bridge/link.c
index 3810fa04..fef3a9ef 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -230,6 +230,8 @@ int print_linkinfo(struct nlmsghdr *n, void *arg)
 	if (!name)
 		return -1;
 
+	print_headers(fp, "[LINK]");
+
 	open_json_object(NULL);
 	if (n->nlmsg_type == RTM_DELLINK)
 		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
@@ -588,6 +590,8 @@ static int brlink_show(int argc, char **argv)
 int do_link(int argc, char **argv)
 {
 	ll_init_map(&rth);
+	timestamp = 0;
+
 	if (argc > 0) {
 		if (matches(*argv, "set") == 0 ||
 		    matches(*argv, "change") == 0)
diff --git a/bridge/mdb.c b/bridge/mdb.c
index 7b5863d3..d3afc900 100644
--- a/bridge/mdb.c
+++ b/bridge/mdb.c
@@ -380,6 +380,8 @@ int print_mdb_mon(struct nlmsghdr *n, void *arg)
 	if (ret != 1)
 		return ret;
 
+	print_headers(fp, "[MDB]");
+
 	if (n->nlmsg_type == RTM_DELMDB)
 		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
 
@@ -564,6 +566,7 @@ static int mdb_modify(int cmd, int flags, int argc, char **argv)
 int do_mdb(int argc, char **argv)
 {
 	ll_init_map(&rth);
+	timestamp = 0;
 
 	if (argc > 0) {
 		if (matches(*argv, "add") == 0)
diff --git a/bridge/monitor.c b/bridge/monitor.c
index f17c1906..e321516a 100644
--- a/bridge/monitor.c
+++ b/bridge/monitor.c
@@ -35,42 +35,22 @@ static void usage(void)
 	exit(-1);
 }
 
-static int print_tunnel_rtm(struct nlmsghdr *n, void *arg, bool monitor)
-{
-	struct tunnel_msg *tmsg = NLMSG_DATA(n);
-
-	if (tmsg->family == PF_BRIDGE)
-		return print_vnifilter_rtm(n, arg, monitor);
-
-	return 0;
-}
-
 static int accept_msg(struct rtnl_ctrl_data *ctrl,
 		      struct nlmsghdr *n, void *arg)
 {
 	FILE *fp = arg;
 
-	if (timestamp)
-		print_timestamp(fp);
-
 	switch (n->nlmsg_type) {
 	case RTM_NEWLINK:
 	case RTM_DELLINK:
-		if (prefix_banner)
-			fprintf(fp, "[LINK]");
-
 		return print_linkinfo(n, arg);
 
 	case RTM_NEWNEIGH:
 	case RTM_DELNEIGH:
-		if (prefix_banner)
-			fprintf(fp, "[NEIGH]");
 		return print_fdb(n, arg);
 
 	case RTM_NEWMDB:
 	case RTM_DELMDB:
-		if (prefix_banner)
-			fprintf(fp, "[MDB]");
 		return print_mdb_mon(n, arg);
 
 	case NLMSG_TSTAMP:
@@ -79,21 +59,26 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 
 	case RTM_NEWVLAN:
 	case RTM_DELVLAN:
-		if (prefix_banner)
-			fprintf(fp, "[VLAN]");
 		return print_vlan_rtm(n, arg, true, false);
 
 	case RTM_NEWTUNNEL:
 	case RTM_DELTUNNEL:
-		if (prefix_banner)
-			fprintf(fp, "[TUNNEL]");
-		return print_tunnel_rtm(n, arg, true);
+		return print_vnifilter_rtm(n, arg, true);
 
 	default:
 		return 0;
 	}
 }
 
+void print_headers(FILE *fp, const char *label)
+{
+	if (timestamp)
+		print_timestamp(fp);
+
+	if (prefix_banner)
+		fprintf(fp, "%s", label);
+}
+
 int do_monitor(int argc, char **argv)
 {
 	char *file = NULL;
diff --git a/bridge/vlan.c b/bridge/vlan.c
index 390a2037..13df1e84 100644
--- a/bridge/vlan.c
+++ b/bridge/vlan.c
@@ -1032,6 +1032,7 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor, bool global_only
 	struct br_vlan_msg *bvm = NLMSG_DATA(n);
 	int len = n->nlmsg_len;
 	struct rtattr *a;
+	FILE *fp = arg;
 	int rem;
 
 	if (n->nlmsg_type != RTM_NEWVLAN && n->nlmsg_type != RTM_DELVLAN &&
@@ -1053,6 +1054,8 @@ int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor, bool global_only
 	if (filter_index && filter_index != bvm->ifindex)
 		return 0;
 
+	print_headers(fp, "[VLAN]");
+
 	if (n->nlmsg_type == RTM_DELVLAN)
 		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
 
@@ -1333,6 +1336,7 @@ static int vlan_global(int argc, char **argv)
 int do_vlan(int argc, char **argv)
 {
 	ll_init_map(&rth);
+	timestamp = 0;
 
 	if (argc > 0) {
 		if (matches(*argv, "add") == 0)
diff --git a/bridge/vni.c b/bridge/vni.c
index a0c2792c..e776797a 100644
--- a/bridge/vni.c
+++ b/bridge/vni.c
@@ -309,6 +309,7 @@ int print_vnifilter_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 	int len = n->nlmsg_len;
 	bool first = true;
 	struct rtattr *t;
+	FILE *fp = arg;
 	int rem;
 
 	if (n->nlmsg_type != RTM_NEWTUNNEL &&
@@ -331,6 +332,8 @@ int print_vnifilter_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 	if (filter_index && filter_index != tmsg->ifindex)
 		return 0;
 
+	print_headers(fp, "[TUNNEL]");
+
 	if (n->nlmsg_type == RTM_DELTUNNEL)
 		print_bool(PRINT_ANY, "deleted", "Deleted ", true);
 
@@ -418,6 +421,7 @@ static int vni_show(int argc, char **argv)
 int do_vni(int argc, char **argv)
 {
 	ll_init_map(&rth);
+	timestamp = 0;
 
 	if (argc > 0) {
 		if (strcmp(*argv, "add") == 0)
-- 
2.37.2


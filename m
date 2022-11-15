Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9062562A3B4
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 22:08:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbiKOVIF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 16:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbiKOVID (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 16:08:03 -0500
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (mail-bn8nam04on2057.outbound.protection.outlook.com [40.107.100.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CAC27DD3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 13:08:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=muoLZvcb7wCrV4ElhngLuURCBpsehjvRDzReiF0YpCMvu/ncFNmy7oGK6UI3+kYjtxGU7vvIaBHrtc7aA1VKvil3yybh9Z/M4fF0acjamDsND1IcDzbmFLu1gjiYLntFEW2i3kSLFs8dQV78qZnH6tfKrp7fnO3ij3oFelaleQ1PDEPejjbXADF9Sz990udLQXI0ivqFW8LCtZgmH5auxocw9j0COgtOjwmKbwDm2d6ZN2Hy4uv9W3x7Hrw3UK7E67CKlE8sajj6YPJv25ydE1bS0xo9BEsQWeEgwOXkqsQ5/f1jmAkbnOdDUcjiDmCmmV/7B39pG1wcUR1OaK56Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SvHNDkapPcUoRudgM6hbxLa0MO4ikpEnbAhAEE+BROk=;
 b=WfyvcWpcW11Zxt1I2DAWl/KeAM3TyfkLmMsX6TZ6QUQAR0zms++JpmQNMxdKFTuciN2blxH5wi/m5rzKJnpgv8xDtXPQ6vNv7STjFERURc8Hr1Gmm8ftQpOAPJ7v5WbUj7CMH87wemxpUNJkuPMw6dWmIf00GrQCm23WbDp3Wnlqf4ZrV2qz+B/lrNy0rYYSy5nxK+d6SRpjhN/U8TI7qnMCnku2Slf/NFuN3CDlED+puKL9wPgqrx76ZLgUynO6hCwEtpcNbwW1Rl+yoH3h/z0atRahdggwynp00MnrFcoQuCNSO6opmkFRNPHXp7vanxcHn1qD9rwj/UdP1VOTcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SvHNDkapPcUoRudgM6hbxLa0MO4ikpEnbAhAEE+BROk=;
 b=IHyaOw4Mtj3A4k2vPlG2GZ2P78hLplrNspXEeUKqYmPlSlXecRFjTQee8e1b+sqmeHjxg2n5KK5gcTsY2MewaMKdv5jYZsV3r78Sj7r5ksyECnumCFBW56MEm7hd9cpDpEFki5QFZzN89yBBLBUm8MRBQiJBoAXGFhgDB92HTBvTLfDs8Y1UXt5uvrm0Yh3nnnhLp6xBHEF/yhnzv+XAslLMMZgyhOHCNpbZ51VYTevranlmhErrhQ+ZMHFCfn7Th5SvusxDhsBn9fPN6hsu/oOSNOReHrFv5kQMedKwZFJNoJ6HKFCgZ71SvMaFsz7h/1x8XXzPZ/q+PNBM9lTrCQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from MN2PR12MB4373.namprd12.prod.outlook.com (2603:10b6:208:261::8)
 by MN2PR12MB4567.namprd12.prod.outlook.com (2603:10b6:208:263::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.18; Tue, 15 Nov
 2022 21:07:58 +0000
Received: from MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::9e16:85ac:e8ba:98c7]) by MN2PR12MB4373.namprd12.prod.outlook.com
 ([fe80::9e16:85ac:e8ba:98c7%9]) with mapi id 15.20.5813.017; Tue, 15 Nov 2022
 21:07:58 +0000
From:   Benjamin Poirier <bpoirier@nvidia.com>
To:     David Ahern <dsahern@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, Ido Schimmel <idosch@nvidia.com>,
        Roopa Prabhu <roopa@nvidia.com>
Subject: [PATCH iproute2-next] bridge: Remove unused function argument
Date:   Tue, 15 Nov 2022 16:07:15 -0500
Message-Id: <20221115210715.172728-1-bpoirier@nvidia.com>
X-Mailer: git-send-email 2.37.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0287.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::13) To MN2PR12MB4373.namprd12.prod.outlook.com
 (2603:10b6:208:261::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN2PR12MB4373:EE_|MN2PR12MB4567:EE_
X-MS-Office365-Filtering-Correlation-Id: 6f9f97a5-5c45-4236-e5c7-08dac74d7912
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: i17mB/S5QPni7vnR3zMZ+CFXnFPv1224RTT2TdXrdkN3ufKvnh2crzAoNv0SNMOI4EEuTtpFBpAuOkcrD2UKDk57D6gjDbduGRVdR3Qg4D4+lLnBTndZTulNXzrey1l+ORleZbIXRjI1sbm7V9iWRXxYfDb9W2irLpuLOZlLDq8wExUC27vnqwsWPjI2bnyGXV1UyaCrhxLvb6cNQdqvZjiSR98GfIvKpXmbAq+wUdfbQA4Wuo58NT3za265/S9KAGhhEUy1JNhvgW5t4JnSDAod71PRIa2wtryxw05zSBJ3h8rUTXm7aeXYsyrBi+cGWZw2053mW7IkUOeFDu4q4z0eyMb0fZodWCZSZ/FyqxqSBySDHbLaA4V1giC3oPDD6pLwL02bLuoBOorO9FygH24ERLE6U8wPJ7C0wK6uqRgEBCbSh70o5XhOR2yUJ1h8ys59uKt9aFcMCZY18u5vMsm7E3fh7gLaRms+pBs8/1SfRyBOLQ83jdWSkchbTv3n1DUzHfQNWTbBKZRKVi6cPRfuSTXwa/pukg15wCj32J4wULitZ73bwEpNWlao+6IBXoTkqegV+RvYa9afjr6VEWHvoQRgQ1oSFMrNjNWGwBK/Fu+Bp7gdkIZN6WIZ/t8R8TCBYORFol7mOPhG0dtAu/1gvr+35UlfBlfMWS2KlZoNJMx1qAlGCoPtL3dle7TnVw0AwKrBBAXce59SgVtbJA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR12MB4373.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(346002)(136003)(39860400002)(376002)(451199015)(5660300002)(2906002)(41300700001)(66476007)(8676002)(66946007)(66556008)(316002)(6486002)(110136005)(54906003)(4326008)(66574015)(6506007)(6666004)(107886003)(86362001)(2616005)(83380400001)(1076003)(186003)(478600001)(6512007)(26005)(8936002)(38100700002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?SZSRerA9EltHfVQcIntKh4ulQIDwZoOF4jAxETH85LetDyjdIqig5N6q6sY9?=
 =?us-ascii?Q?6dA3QaY3GMHWWA/7UFOtvWxoWh3bG10oPbTqDnbp3XJiPjOLmwIBWUPYwMmA?=
 =?us-ascii?Q?YNeNEJSMAjE+Qug9MQnJY8DVMCMX5zreEk7KfjAFLvzN2kReWg7Y6aYIe1RV?=
 =?us-ascii?Q?YtuMit1hsj63btADXzZvMLaU3gPJrzMkk0uq7g0W8jBee/wnH5gZ+fmtKhUZ?=
 =?us-ascii?Q?X9nxvPxXnldETRzfKMehZ5SZMu14Lct+e1Jz1NDu8v9qbwlvLNpIAfzYYymM?=
 =?us-ascii?Q?Yenhp7AhQ2C3VxALucZXw97Y24LOZZkfyJNev/hIF4stPe9uywPQqrdO4iOi?=
 =?us-ascii?Q?EHgDHXopMZ26Eh2Lq/eLzWzqH20wNCAhLdzoEu/Xg/tc5+uoVY8txDMe8M+B?=
 =?us-ascii?Q?ygO7eCmf5N6EoI9vocyAktPn19g8IvG8g69M3ZMKS0FPlTws4zSCx1z+bVF2?=
 =?us-ascii?Q?3VNP7DC4bIEzF/kZIBMc1RRKgs6+sMKOeFUQtFEDZXgeGF3tLTe47ANL880z?=
 =?us-ascii?Q?yRslFcPvJp0odzyrjf3OctMM9hnz4t7pPBgppCL7Yr4WKLVKa3Ye+a2C1Clt?=
 =?us-ascii?Q?XXLz8ocIGTMtTg88OV1jhrCwJ1H/3ryA9fvpOJG5DEygmbQ6FVQfBPtEcL8O?=
 =?us-ascii?Q?uht1IfFC7ifzclZC21vWlLZBy8O+Wf0iRPQb9S1O51M581AD1/QhWAAJUTcG?=
 =?us-ascii?Q?QU2gTkw4/1xlhnqOl/qW1iBWKPUhIwRRu+57jZuW3zJSSxp5x0dPcCuXJZIw?=
 =?us-ascii?Q?t+X7TJ4DYKG/veeOy1b8Y+yOpno+pgzbF0uUWB+7otPy9TrWeqjFPM/oot+T?=
 =?us-ascii?Q?Qcg/NeRkB8raLXUeYVcFUhhALJri5nNge1gDpyWsX2sq5KcttpAFyIiuE/lW?=
 =?us-ascii?Q?MtwwFZ40mOmgZ81QAGawrxvyZsjlCWp15eQVtjLA8SYE8oBCcCjBEH6r0veL?=
 =?us-ascii?Q?ElW+lf8eDFJnhbYZ9BrFstTX7fgH0rbxSTcn0EA6m6r6LqyEJmJuKv11x1Hn?=
 =?us-ascii?Q?ZvAHZtMCx9gYIKcCav53njoczn1gl/ep+IjaDmdGYlnFP1IowOHPkzoxHkzi?=
 =?us-ascii?Q?3oXyZmmBwixPRajHEeeHaUb/u45MkzwGVhPH/0npfWQA67zVM9uPjl7Trgd+?=
 =?us-ascii?Q?gSa9Y0qzkhSX4wk9TBimBob9V6KaxcR7HbDUU3pKE8gFQRHBhhllKGByAp6Z?=
 =?us-ascii?Q?8ayjPDesUSF7bG5iMKGO8k3kQ3UERJ8xjawRlzPkv1PdQq472Xnrier0rzh6?=
 =?us-ascii?Q?P0mRuVAPCFXqv1tSdNr+Cfg36FcQlx2PbRID8m7myu3Ede97beR5Pf9JFAKl?=
 =?us-ascii?Q?3o5yGMwCuO3xPqGsBLGlnykRc8yoFqqp1SehIVi5FFDVQ0KEbCBpt5pL4NAS?=
 =?us-ascii?Q?UNgdqv5/yogPkarmWB9ZAe96Z8mp7/KxEQ+DPB+XlajwSyh8adRnQ/KPY7Bl?=
 =?us-ascii?Q?2xp3HWuc70zvT0iNjyM7LL/lh/R0QfmMjuqGkuwrq2sgVk9MkwAHKCWYo2jM?=
 =?us-ascii?Q?qtMyiQ59Vu/+JwZg4RBetvlJV8TiAJOtRWAcEJeN5NXDU07oozcKdHIcSSGF?=
 =?us-ascii?Q?7rYuZPGSfNk2cYNu9Fl2Pemy8vEBntGS5/9tW1kS?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f9f97a5-5c45-4236-e5c7-08dac74d7912
X-MS-Exchange-CrossTenant-AuthSource: MN2PR12MB4373.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Nov 2022 21:07:58.5599
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qavdppGQWZpI138a3LFdfU1vwKndcX5PTd6UraAoy5ALz84rD9Uj1cLOWlJKfdF00yV2XHJ9Bj3RZqelcwLnFw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4567
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

print_vnifilter_rtm() was probably modeled on print_vlan_rtm() but the
'monitor' argument is unused in the vnifilter case.

Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
---
 bridge/br_common.h | 2 +-
 bridge/monitor.c   | 2 +-
 bridge/vni.c       | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/bridge/br_common.h b/bridge/br_common.h
index da677df8..1bdee658 100644
--- a/bridge/br_common.h
+++ b/bridge/br_common.h
@@ -14,7 +14,7 @@ void print_stp_state(__u8 state);
 int parse_stp_state(const char *arg);
 int print_vlan_rtm(struct nlmsghdr *n, void *arg, bool monitor,
 		   bool global_only);
-int print_vnifilter_rtm(struct nlmsghdr *n, void *arg, bool monitor);
+int print_vnifilter_rtm(struct nlmsghdr *n, void *arg);
 void br_print_router_port_stats(struct rtattr *pattr);
 void print_headers(FILE *fp, const char *label);
 
diff --git a/bridge/monitor.c b/bridge/monitor.c
index e321516a..d82f45cc 100644
--- a/bridge/monitor.c
+++ b/bridge/monitor.c
@@ -63,7 +63,7 @@ static int accept_msg(struct rtnl_ctrl_data *ctrl,
 
 	case RTM_NEWTUNNEL:
 	case RTM_DELTUNNEL:
-		return print_vnifilter_rtm(n, arg, true);
+		return print_vnifilter_rtm(n, arg);
 
 	default:
 		return 0;
diff --git a/bridge/vni.c b/bridge/vni.c
index e776797a..940f251c 100644
--- a/bridge/vni.c
+++ b/bridge/vni.c
@@ -303,7 +303,7 @@ static void print_vni(struct rtattr *t, int ifindex)
 	print_string(PRINT_FP, NULL, "%s", _SL_);
 }
 
-int print_vnifilter_rtm(struct nlmsghdr *n, void *arg, bool monitor)
+int print_vnifilter_rtm(struct nlmsghdr *n, void *arg)
 {
 	struct tunnel_msg *tmsg = NLMSG_DATA(n);
 	int len = n->nlmsg_len;
@@ -364,7 +364,7 @@ int print_vnifilter_rtm(struct nlmsghdr *n, void *arg, bool monitor)
 
 static int print_vnifilter_rtm_filter(struct nlmsghdr *n, void *arg)
 {
-	return print_vnifilter_rtm(n, arg, false);
+	return print_vnifilter_rtm(n, arg);
 }
 
 static int vni_show(int argc, char **argv)
-- 
2.37.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E9563E5197
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 05:43:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbhHJDnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 23:43:45 -0400
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:29153
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234613AbhHJDno (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Aug 2021 23:43:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gTK1TM5+/oUEKxvwIaq27qTvjaESPu+zb9fzpSBbvn09pZhldRSgyYc8bRqpspAceSb5AYV/pXkLGF5Jel2VxDjIEhVYluXCJXesfD8GI119eVWbvg0DyBaONcZB9YwKrT9RC/iZSZPv5zYOMhI+NFRWwbs862Uj8FyygsiypFcxnwxX8AD5O3IPKz4zJ4UbV/SI3dW64FLs1X42ZzumjGFOPXNn7IxRicXQcSeaJgyDrKuKJ4+Kflq8IpGkMXhLLLtaJLrtSMYTgSlqG2F6AWySfNzFeD8nOniM+ic9Bj+3eYyx93/I+Tkehpaww4TAs1GW/f63eIzNC/GUL2YBBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YK2dGcMEDAtZI2FSK8nOt9pW273gTpm3iRbbbhgCuEc=;
 b=fy74HV9aB4VJke0dfSmmgzZz6pnDFpBaYbe3GCtEBXYFZFIzt2rR/aJ/kzTgIKIqRHLFk50+h46F0ncYn/YolcY8aSi12xH6twqgpw8zFt18urI+920px7jQ9M3lkREvAJWsw+RpgUZFOB1OCElDbt4T71Z26F80IU/DC3eQzb4DJOolHATfL7jL2wr5SQyNb0TFv9oa9ONx0h+24ckAQV4rbJYjOGmZN8LhAIEp5hhiss/6G9U8gXvPI6NdZDjsDAUWLi2XWgP6RMC7qcSEfuNpfPq55sY6kS+u/w2F517bn5FScdLxyZPxwticuDiCyUJgKIJ7QgXZwRP8BZzDtg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YK2dGcMEDAtZI2FSK8nOt9pW273gTpm3iRbbbhgCuEc=;
 b=ZSNtbAkJTodGv28Y0Hwk9UtbUjX0OzYGDGFEQ3HKKhDPQ/CQncBhA+CzlZ7kAZ4Ohi9/Snv9HCnj+vIRegeWO8p/p6D28htxmbGuN+SjyeA8w7VOD8ISaDf/6bK4Yd59M+hb/Qx5c3qaUyve6AAzyQKnO+oDToViiblVyQlHmDKoZUoycNxU30V/BuDbzfPhE9Ezp1A0P3B+M7rLXJsBYiQc2OWAcA67LSjJWLK7yjnX8j+Ib3Gri+sWBdWe4DU1WcUytRlBLIPJKsSrj1D0kQxSwfkAIVdi1/rmV1Vk5rpKsJ/RjyeVAkJL1bcLDo4EajhHbBj2MFF4JcbvAtvyxQ==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from MW3PR12MB4473.namprd12.prod.outlook.com (2603:10b6:303:56::19)
 by MW2PR12MB2492.namprd12.prod.outlook.com (2603:10b6:907:8::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 03:43:22 +0000
Received: from MW3PR12MB4473.namprd12.prod.outlook.com
 ([fe80::81fb:9d82:3986:4c86]) by MW3PR12MB4473.namprd12.prod.outlook.com
 ([fe80::81fb:9d82:3986:4c86%4]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 03:43:22 +0000
From:   Mark Bloch <mbloch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     xiyou.wangcong@gmail.com, vladbu@nvidia.com,
        cong.wang@bytedance.com, jhs@mojatatu.com, jiri@resnulli.us
Subject: [net-next PATCH v2] net/sched: cls_api, reset flags on replay
Date:   Tue, 10 Aug 2021 03:43:05 +0000
Message-Id: <20210810034305.63997-1-mbloch@nvidia.com>
X-Mailer: git-send-email 2.14.1
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0164.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:1::27) To MW3PR12MB4473.namprd12.prod.outlook.com
 (2603:10b6:303:56::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from r-vrt-26-1.mtr.labs.mlnx (37.142.13.130) by MR2P264CA0164.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 03:43:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 298c1e18-268e-4c1b-f59b-08d95bb1003e
X-MS-TrafficTypeDiagnostic: MW2PR12MB2492:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MW2PR12MB24928090A594D63BD5F54128AFF79@MW2PR12MB2492.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:983;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iDfiWMwYkKtctwOFuoFzUe4nVO1pIDbsTDw7RpxR8gVqsco/AyelYt0TzMePasrhwBy+YcZfmArJ/GtK68IdSbUXx/LBUJokTKC7azpEmbqbBU3XI9s7VXKfQ50dtgmbUfvtB4l3pQLmqbSZXbnPQIdCUwWydEzfDyiz38OI2y8K52yH8yFyHq5uVC6ADcV6Taj7gxDMLA0CuDNVD+7oxieRgdG8vFfoWcJBLcG3JeBTc6prgs89zXiOzOe0zuPgdGhUXPxTDwqDB/+5DIxsKCvyzCKBZIk7a95YR6n3CFyGHZqBJw7X6Z9JVxySKLSe+OAanm8Q8VA4tEkB/KSojkqa0jfVnoYyAcL5sM0k+WOjOMeLEQ++IvYZiXR0Jv/21u7frUjK/PcYoaeNRP4ettMIfdgX7INmUIfxN2kILyptCIkBvqXM6mhlk43+2+dapCUZVyzK/t1e3xcrOXxypnXWFX1yvgPg5UzgHS2qjJRIVh8/gFVPHmZ9N+bbgqrU9cJvpnSWxq5Hy2KbJApzEOFT5ZTb5jF4oNH0dno4kY0pZVTcuf7/HlRzx8AqvwvH2svTAoFUWOZoAq6WX/Z9ywTMP2OknueNH5GTsXtwiyjBxSMIjHC5aweWglh7G0Dd7h4b5PB2Hs60GuWbnkbOuudGKWGfVDq+VSOvZhYiNdrvM0XKqmUAU4o6pSU1ufs8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR12MB4473.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(346002)(396003)(376002)(39860400002)(83380400001)(5660300002)(6916009)(38350700002)(36756003)(26005)(52116002)(38100700002)(1076003)(66556008)(4326008)(66476007)(6506007)(6512007)(66946007)(2906002)(6666004)(478600001)(956004)(8676002)(8936002)(186003)(2616005)(316002)(86362001)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?VetvU1FzlGcAm03LLBgATTIDq5OVakkxNlRX6Czm4G6ucAp3xyCsBPCuqULf?=
 =?us-ascii?Q?6RAlq7xKdrOYhq1HftlJ0XDazEM6ZWGBsRKUosDa45eBfaJ0S0nlWSfOrLaq?=
 =?us-ascii?Q?iBLu+TX4HWR2osW5y6yJQgMJMdpkBKMZMovLlS/Kevo+0Ek0sKgln4DWTLvB?=
 =?us-ascii?Q?6yntzWqB1UbjOvpXcYb7zSS/xqfwhe1PeuUOzsR8U+OhOum0xkuA0Oa4gxZb?=
 =?us-ascii?Q?eDR5t9jbXTNW/QFoATwB8WJ4vdgQfM1N2hYflH9seZDO5T2C/7OuN740lI2F?=
 =?us-ascii?Q?nQGsXzU679L+CwSrMUrDeM2Rtu5ySvthfjUCiskCpFRWRn3RDOwxZbjP3ER/?=
 =?us-ascii?Q?z5Js319Njx7kVrXGIcpgTXuhuDb10ySDO3rji5eZlMpoz9fe4dnYfvftSCho?=
 =?us-ascii?Q?MUCEX4uI+y/VhQDRJY7N7+C5VsRwMbFweu+SObssJ/BEmxbArXuJ+PQEUKbw?=
 =?us-ascii?Q?7zSxUibe9UnFbxdIp7sMcPYS11zOVE+MX41ryrv5Lr4vSXvojD8LwvzZOXPe?=
 =?us-ascii?Q?UAwKvk8zS+voDunKHb4giabZvGDzOej3IZwbzqqX3xYFAqc8sCdDqFFGyP3F?=
 =?us-ascii?Q?Lc9dcNlC1ancIPLnWa+GmWcRjJDv4KjR/ScILK5uX8WFmDm9AgcbV6I+CtM8?=
 =?us-ascii?Q?S0jkw/rcYtf5FHZ7+uFi9fIZKUgGhvge5FjDIzYNrPG/iAKIgtmsb9JEv1ze?=
 =?us-ascii?Q?l4jDrdKpVr07XLjAi4qLZKwf8jGPNqmLsXYizbFpLm3ufSGCGe6bI20/JZWn?=
 =?us-ascii?Q?yYpfSuUZPHTJpfpy4I3235uRWiwiG8lFhBdVCL8hChZ5drVQBhYYsDJNLgQi?=
 =?us-ascii?Q?cxpCtigt9aWz5utvWbg7pwIYPWOmjUhV3jJrZqcNj4C1VkyKb65Zcsdrq+ef?=
 =?us-ascii?Q?h+y02zkpFL/dxCXKCRbkO+30TZ+uOvKxSVhgdVxKXZ0V/PafDS8H1JW/Zrr5?=
 =?us-ascii?Q?ZOaoNuTh/GI7Er16ExfX8oL7veDJ2qNLbmzxsNRkqRDUarI5wU67imaCyKL2?=
 =?us-ascii?Q?j6yO0bFc7T46KtI0Rk78iFClntNXxtrQfy24v0kxGf8hMRtSWcELkrE84Uxx?=
 =?us-ascii?Q?WuCXGfL5KAoold9Mt/za5L2hzkXcoIumNNXx17vdBWEuMcsOM3CKY/bpOQiM?=
 =?us-ascii?Q?e4ate1ytPL1Eh65LBcDps0ZoBwLPef4PRxD5jXev55VcPTwBfU+KTr07yjdF?=
 =?us-ascii?Q?xZIc02YuJIiIKjTKqDV2xIvGNkhBK+92suY0Dp/YfBjg3T6LOqX32YTaxJ+X?=
 =?us-ascii?Q?L1V3aBgSfAQ6QD0pc6xcwDlSKiAggGL0arUjAsi2GcM/mAxpqSoCpg4GORgK?=
 =?us-ascii?Q?D0lpZs9UmMsiQu8mM8cw+dNp?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 298c1e18-268e-4c1b-f59b-08d95bb1003e
X-MS-Exchange-CrossTenant-AuthSource: MW3PR12MB4473.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 03:43:22.3062
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bHAGWWuziYeUbivOkvD2gsRbiZ8aQGZKe3JVR7oEuxfZp7Tn+VU50bq69KPNxQ7SCKVz5jtVZrn1XsM/Ekp/Hw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR12MB2492
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc_new_tfilter() can replay a request if it got EAGAIN. The cited commit
didn't account for this when it converted TC action ->init() API
to use flags instead of parameters. This can lead to passing stale flags
down the call chain which results in trying to lock rtnl when it's
already locked, deadlocking the entire system.

Fix by making sure to reset flags on each replay.

============================================
WARNING: possible recursive locking detected
5.14.0-rc3-custom-49011-g3d2bbb4f104d #447 Not tainted
--------------------------------------------
tc/37605 is trying to acquire lock:
ffffffff841df2f0 (rtnl_mutex){+.+.}-{3:3}, at: tc_setup_cb_add+0x14b/0x4d0

but task is already holding lock:
ffffffff841df2f0 (rtnl_mutex){+.+.}-{3:3}, at: tc_new_tfilter+0xb12/0x22e0

other info that might help us debug this:
 Possible unsafe locking scenario:
       CPU0
       ----
  lock(rtnl_mutex);
  lock(rtnl_mutex);

 *** DEADLOCK ***
 May be due to missing lock nesting notation
1 lock held by tc/37605:
 #0: ffffffff841df2f0 (rtnl_mutex){+.+.}-{3:3}, at: tc_new_tfilter+0xb12/0x22e0

stack backtrace:
CPU: 0 PID: 37605 Comm: tc Not tainted 5.14.0-rc3-custom-49011-g3d2bbb4f104d #447
Hardware name: Mellanox Technologies Ltd. MSN2010/SA002610, BIOS 5.6.5 08/24/2017
Call Trace:
 dump_stack_lvl+0x8b/0xb3
 __lock_acquire.cold+0x175/0x3cb
 lock_acquire+0x1a4/0x4f0
 __mutex_lock+0x136/0x10d0
 fl_hw_replace_filter+0x458/0x630 [cls_flower]
 fl_change+0x25f2/0x4a64 [cls_flower]
 tc_new_tfilter+0xa65/0x22e0
 rtnetlink_rcv_msg+0x86c/0xc60
 netlink_rcv_skb+0x14d/0x430
 netlink_unicast+0x539/0x7e0
 netlink_sendmsg+0x84d/0xd80
 ____sys_sendmsg+0x7ff/0x970
 ___sys_sendmsg+0xf8/0x170
 __sys_sendmsg+0xea/0x1b0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f7b93b6c0a7
Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 00 f3 0f 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2e 00 00 00 0f 05 <48>
RSP: 002b:00007ffe365b3818 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7b93b6c0a7
RDX: 0000000000000000 RSI: 00007ffe365b3880 RDI: 0000000000000003
RBP: 00000000610a75f6 R08: 0000000000000001 R09: 0000000000000000
R10: fffffffffffff3a9 R11: 0000000000000246 R12: 0000000000000001
R13: 0000000000000000 R14: 00007ffe365b7b58 R15: 00000000004822c0

Fixes: 695176bfe5de ("net_sched: refactor TC action init API")
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Vlad Buslov <vladbu@nvidia.com>
---
v2: Removed Change-Id tag.
---
 net/sched/cls_api.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 69185e311422..4a7043a4e5d6 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -1949,7 +1949,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	int err;
 	int tp_created;
 	bool rtnl_held = false;
-	u32 flags = 0;
+	u32 flags;
 
 	if (!netlink_ns_capable(skb, net->user_ns, CAP_NET_ADMIN))
 		return -EPERM;
@@ -1970,6 +1970,7 @@ static int tc_new_tfilter(struct sk_buff *skb, struct nlmsghdr *n,
 	tp = NULL;
 	cl = 0;
 	block = NULL;
+	flags = 0;
 
 	if (prio == 0) {
 		/* If no priority is provided by the user,
-- 
2.14.1


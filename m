Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A21895BA89B
	for <lists+netdev@lfdr.de>; Fri, 16 Sep 2022 10:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbiIPItd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Sep 2022 04:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiIPItb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Sep 2022 04:49:31 -0400
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2056.outbound.protection.outlook.com [40.107.243.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E8F71020
        for <netdev@vger.kernel.org>; Fri, 16 Sep 2022 01:49:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R5rbPKT0PM/U5pkBWVmvYxieG/ANpLWNhS2x5yyTO5KhS/7mBA2grFj4n9hroqpBPWa6uzqzcwL/TZf1hYYNtBHT9JxzJPEKFn9/6D82nUP9VlPNdEi31s0XSTIzYCo9d3hax7w73iEwt+GJ5yyeEVEma+MoGSfP4m5MH9J34wF1fRDqpkLqm9x4L3OvGHXp3OcrgDGieBOPw7tfr0lfYabXoEVCpR3XEdJM8yqzu8qaJlxVDHo1LtguzlSmg1KiHZWx1CXTi97QbZuH+ra63s+XeCZ5nHpOQLNuRMJxXkNEXkuERM33Ir+VXeq+kje0BSAQT/gl8E3Nrn2+F3Mz+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=poO8IJUTKOJQIBpo6iqVUl/TamKeSTMiialAtNAxxzM=;
 b=gIzgsUXSh3HuvsM/uo0ydsF1ZspNZuU4Ss6XEIPZI7HO5jbZBLlEPq7k5jn+0+0wj1ub4UByRBOmLGdLPiDxOAxYKZMHmcm3E7bh1kJB7fx6SE2qwnPFOHH1TXTM4J5L7YHAEwx98EQB7/OV68a8hMpfNwS9O2cUHqxtjeObPxsePiIDbhuaPJFf9vdrXQAKLR/fudlLm8RARqx0+owgJUyEfEhJI94ZW4MPDhkmU2/C18/v4mMZODlFT6IViyRhwJ8NitqwHwfB2K1Ptko6pZIDcEDlt62opkJFlY+fdZnjgKSMhPZrHKs9bxaAOw+1Frj+LAlRugiQyVks0ddpPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=poO8IJUTKOJQIBpo6iqVUl/TamKeSTMiialAtNAxxzM=;
 b=WXa8ylYuSX27YZhPyeZCNh3KJDPvm3UDJ2tuUw3rdE3a7qvUdEq1U6h1MCLYWqvS5aR/nA/JHFyZMBGSIP1O4EebcqaVDslHq80if0qV9vCo9lxTbW5lBjwmYzAUmsNLxf268WyctuYHVVJ/dNXVUvO8PWhYYA+rVHfJoX3HmN5uld/nULDYsLmYOPbhyNX9m+vbIpRxfDYW+j7E0j5/gin8pzcIs72JJ5yX+pxcR4Km2mgBMDNABcloSTxXtw/NuTcHXHfTwBIT0oyVoOGxbikoLosXLm+3lKr4O9m8S7Vku9Y+CQp6zPB3MokIh0eW9dzB+Q2TwSI8TNgnmn+0Iw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ1PR12MB6145.namprd12.prod.outlook.com (2603:10b6:a03:45c::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Fri, 16 Sep
 2022 08:49:25 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2f04:b3e6:43b5:c532]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::2f04:b3e6:43b5:c532%5]) with mapi id 15.20.5632.015; Fri, 16 Sep 2022
 08:49:25 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        rroberto2r@gmail.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net] ipv6: Fix crash when IPv6 is administratively disabled
Date:   Fri, 16 Sep 2022 11:48:21 +0300
Message-Id: <20220916084821.229287-1-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0071.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::39) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|SJ1PR12MB6145:EE_
X-MS-Office365-Filtering-Correlation-Id: d08f64f4-c719-4570-80f2-08da97c05b80
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: leuWsQzFW1yugT11WldHw5qDK/rQuab7l8WdmOJrX/qz6O83mLeF+rKziYinBFmNFEi/fuYtQkbs5sUKDTC+tUaKOU9GsjPfAOmWkwHB5hBnsv28JBKHiB85ShU9UacqHIssKcIUZKhtHGhtE3ADCoqICgghf/gO+yL5jfDIn+Jtb8f4v4uCN7AA9/tFxI4KCvo4P1iWbZ7Szpz/zKahMbJbw2oV5pGdxW3okauQdbwjSciPV/sXWJmCiJTyit4YlP/rXRj8Dmb5rhkXSifDuIyUHm50axnxYyPVklrqVNXTcojcv2zWcgvWGIX451VYMRBWm2p60wbpFB1T+sZfPesyHWdhvtjSb6VEp2pqFWQAlFA0AyCrhwjzhrVaNk76yCWrmUYgO41get3lNsvogS5oiFxB9k20+z1cEbhoWsRZ7TCFDHp8bHXE9h9UP18B5VOsVpQ8n9R4++Xeo2RH0pD7DSB2/uTq8E9ePuB8RMY3Sm8hTlYqNhj/+sdCx/67BHg+exGfsgi+2YUQJUrodFDguH6m3G/HBJeA96ZA1zBPzXPvbeTlLq2UqIzqwQG1n4SfGnGtdIVqsMDtqiosX5xifKOlDYR2sGnvpEFbn7CJ4tgWgtVg5BKn5FdMuwU4dEiBwHrsxqGMo5MjoECIfqm3smwBwu5PgNILqC7UNsJm+8mtG44O3XTGL1r5gRIzKjxN0EvPc16Dn4crYWfyoA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(366004)(396003)(136003)(376002)(451199015)(2906002)(86362001)(8936002)(66476007)(5660300002)(4326008)(8676002)(66556008)(66946007)(26005)(36756003)(1076003)(6512007)(2616005)(6506007)(6486002)(41300700001)(186003)(316002)(38100700002)(478600001)(107886003)(6666004)(83380400001)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?h0lymjBUtnuHqW/K5nbEVv3rFpkEi2wA4YOAM9KbI+DJx1w402aHJB+Q6Ti4?=
 =?us-ascii?Q?M5w+Mi89Hmm0AXr+Nrhqlx9u+CHWBfzMITRN/O4NDkeOS911vdp3cAQsxU/5?=
 =?us-ascii?Q?B8mfhaO6FDrPz4FFTTZLRg5hP2/jMBhw9Rb+H8NUr4Yy+tXRWGqMUZghmNHl?=
 =?us-ascii?Q?L4dhg9FiF8KGAOLfMu+dLxZ1V4JeaQh32PttJSNWVAn1oqj8AzKbY9F9AQrM?=
 =?us-ascii?Q?ITnTtfF0iEDcXUytPQLOOrMVcg+Th61PF59eU4yANGzl7rBzwVuerYPlTiTd?=
 =?us-ascii?Q?tZ7sA8/+YoViJOXRYhsa3Cy8L+DrUfpKrqJlBeazhqu2l3OVsmBKgEcD9fLC?=
 =?us-ascii?Q?lAKKcM5s8oMnySFUgZtoPrzPH2sZiCOAWdxnFDLBgaJ8v77uSsSsjAgwRL+h?=
 =?us-ascii?Q?TXbt4KRfio/KXoKjuhnAmLvNzXmeeA6y1mVzd8kzT5Yqw920DWJLGAmOF1yC?=
 =?us-ascii?Q?FHT43ww5UpujIsY8LXjO2f4LegdgbpdO0ThfUjGuUPuteBgYJ8zGKZ4eU12e?=
 =?us-ascii?Q?9acxWf+xJYz4b56Jh37fEXE3raImANyvL9fuUYghG3RSbGSgh1wLI+2uknna?=
 =?us-ascii?Q?PcuFzz8n6FsXvktAC3ho8/RKWQNETvfbS2MoFOSh3o4oo82xJKufkVw4Y50o?=
 =?us-ascii?Q?xAR+vpRSy7ir7E/npGQ0vXzZH+ASLNdodOrY7klUEeU27mLk6eJFYi8Soh0K?=
 =?us-ascii?Q?bCYlI9Y7cVQxcIp7EzOsAxKFWz/dIiT4t+tfWyHOQijoMeZar3dOzceeMyHs?=
 =?us-ascii?Q?aUciEgY4TjrjyaNAey7exJdSOG/qLvfbH3k/tSP4BebeG2FLMZiXpIfRPol6?=
 =?us-ascii?Q?fCPFQuTlmypIwLBQ8RBUfng5XJ9zWLS/3ofNh6PN2gQGi51yWgsMLTDZT7FP?=
 =?us-ascii?Q?thdGCYzYgSylnHHVusrQMUwCEL4CloEfW6wAQ/TTr4oY3jb55bgoPuYLn3pI?=
 =?us-ascii?Q?SK7YVSxHYEQfIdoU1zNJ5zrLYHyFm/zF6VbIP8VDgXGY0xHMCZiXRzqa/1H+?=
 =?us-ascii?Q?y87enL0nDuTcU8Ar0sJYyEyHWXtpRUwxHZhDroOiDAYe46MRLYOHkPSNiGbP?=
 =?us-ascii?Q?m/ev3Lq3z8isJRo0Of6rUYufKz+g6VZXPuW3d2zRmkOJRoe0VQ+rIn3C20w3?=
 =?us-ascii?Q?KqBCtN4BrhF24n4brMR103F7optPOgPrSfjBcYqkGp1/6sU7ECBWlRGU2DUi?=
 =?us-ascii?Q?uZxDgT9ggw/FxkYanWR40LUiHuztxERd/kNFeT3H5eUUa2NDAtKvSk9g4lO9?=
 =?us-ascii?Q?1aiBTsOvYfMVKGcL7/mvkPY4MoLXuw3Nno77lJRtAooLnGng2oJBbm6c40dx?=
 =?us-ascii?Q?4cR/t7z4vncI2BrtDIyzG/Ui2toz2LY9WhY5aI1vO+c2RBWZi8THB31wguHp?=
 =?us-ascii?Q?K0OpC8ly8OQ9OyMy2sbrpcpAm6uXMmQQp93+zv5qCOFRvCFuXtY1mpLp+CYI?=
 =?us-ascii?Q?vREPMTphm0hMZaLsKSOWPvPy+Zbvy6BZYqDTvYpTEeo8/X2wOFIsETd3Kg3F?=
 =?us-ascii?Q?HQW8KApruqucPvffuLhDUWSOEjxdUoO7qq+HX+/64Cw3avcaiJGzdy+W/kF+?=
 =?us-ascii?Q?AzsMwHmX+AzmisqobVSUgYGRLAU2q0F6Pw46uzSN?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d08f64f4-c719-4570-80f2-08da97c05b80
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Sep 2022 08:49:25.3353
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FB5TYcSNR4yM+/d8At/9AbGN/9qFSvFhCZA7s+Na8hTX7cobtmKkL5Nw+WcttXdgWp2HcD+y2oTJn9p6oNYX9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR12MB6145
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The global 'raw_v6_hashinfo' variable can be accessed even when IPv6 is
administratively disabled via the 'ipv6.disable=1' kernel command line
option, leading to a crash [1].

Fix by restoring the original behavior and always initializing the
variable, regardless of IPv6 support being administratively disabled or
not.

[1]
 BUG: unable to handle page fault for address: ffffffffffffffc8
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 173e18067 P4D 173e18067 PUD 173e1a067 PMD 0
 Oops: 0000 [#1] PREEMPT SMP KASAN
 CPU: 3 PID: 271 Comm: ss Not tainted 6.0.0-rc4-custom-00136-g0727a9a5fbc1 #1396
 Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.0-1.fc36 04/01/2014
 RIP: 0010:raw_diag_dump+0x310/0x7f0
 [...]
 Call Trace:
  <TASK>
  __inet_diag_dump+0x10f/0x2e0
  netlink_dump+0x575/0xfd0
  __netlink_dump_start+0x67b/0x940
  inet_diag_handler_cmd+0x273/0x2d0
  sock_diag_rcv_msg+0x317/0x440
  netlink_rcv_skb+0x15e/0x430
  sock_diag_rcv+0x2b/0x40
  netlink_unicast+0x53b/0x800
  netlink_sendmsg+0x945/0xe60
  ____sys_sendmsg+0x747/0x960
  ___sys_sendmsg+0x13a/0x1e0
  __sys_sendmsg+0x118/0x1e0
  do_syscall_64+0x34/0x80
  entry_SYSCALL_64_after_hwframe+0x63/0xcd

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 0daf07e52709 ("raw: convert raw sockets to RCU")
Reported-by: Roberto Ricci <rroberto2r@gmail.com>
Tested-by: Roberto Ricci <rroberto2r@gmail.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/ipv6/af_inet6.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/af_inet6.c b/net/ipv6/af_inet6.c
index 2ce0c44d0081..dbb1430d6cc2 100644
--- a/net/ipv6/af_inet6.c
+++ b/net/ipv6/af_inet6.c
@@ -1070,13 +1070,13 @@ static int __init inet6_init(void)
 	for (r = &inetsw6[0]; r < &inetsw6[SOCK_MAX]; ++r)
 		INIT_LIST_HEAD(r);
 
+	raw_hashinfo_init(&raw_v6_hashinfo);
+
 	if (disable_ipv6_mod) {
 		pr_info("Loaded, but administratively disabled, reboot required to enable\n");
 		goto out;
 	}
 
-	raw_hashinfo_init(&raw_v6_hashinfo);
-
 	err = proto_register(&tcpv6_prot, 1);
 	if (err)
 		goto out;
-- 
2.37.1


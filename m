Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F56567CD2
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 05:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231820AbiGFDuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 23:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231979AbiGFDty (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 23:49:54 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70094.outbound.protection.outlook.com [40.107.7.94])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06AE820F71
        for <netdev@vger.kernel.org>; Tue,  5 Jul 2022 20:48:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rz5DBiXe+Bqg6JAd1XYV34LepxGZyQGGGwsdzL+qxUF0RyBSY9QhrS1dE7S61fbRtA/sGHTjMhghower0NzU9YQ6tL1ae9p0b1fw4Wj9+z7cfGqCz1XizX947ydhQzRkjxyl1hQVXx3PaxoigsvuSiR00TZUajBMe8qFY8UxuBZK2XRy7Hn5+G0sNuA9oFIzDlBlo+Ni7nDFSJJTd8LR0ZJrGaF6Hku1hBnDgMhgRRAaPjWj7RcRsUk+PNRfRFAIGryWthIWV1HVmfzetQQudNfk9fttTwNZr3nJoe8PVr6ISVDT2cabf+pWTScXqfR2GZ41sgMINapFIqBLnwEW0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=liMwI2+2WwO5BrMl7NLeheyFbYQ2CLaLyKviPUHYhPM=;
 b=JKdLikU0yg3WZgJMTmmT04XkdCYp3HZvalW8oCbbViOjEfmfs/SFCjIgaGMkVzhdxm54UVLqpCFTQKn6fcqhrbR7QSj2Rfn0l7m+FrctV3ucrVfLMNuvQ9C+PfH34EPnKysT4XaDLcgfecdI85sQGHiHHHeKcQWDH0FDrxNId2b06bvFW2yinnAuHN3ykmarvpt7oOge3GBUfSYnZzQQ8qYHPC4+NgISeN9UdLq1IL/PMbq/T+kkDFzaQYh1A+1d3eozgx56rgZ0z4QqQVUJp+PJB7ZP8lBirM+EvopzPSrHQy25aABLcaXWSgrVJRP15AmWE7vlcb5HFuT/kzLXwQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=liMwI2+2WwO5BrMl7NLeheyFbYQ2CLaLyKviPUHYhPM=;
 b=AvWiJMdv+lBZNGjqcgaoSIBOM0ze0TFczup7aLKEVgzjuPOKB3gZESFe1FrriFDbJYG99mUXUzRpI56oKIuP2K3UjpI2bA6UTL003Xa1N7pzRyu85x8aCDpm9z+5mmy/FK9CM87XUV0qUpWaXeEBf4A4Wdl5LdQon9ZMZWNUBLY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from PA4PR05MB7647.eurprd05.prod.outlook.com (2603:10a6:102:fb::12)
 by PR3PR05MB7018.eurprd05.prod.outlook.com (2603:10a6:102:60::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Wed, 6 Jul
 2022 03:48:04 +0000
Received: from PA4PR05MB7647.eurprd05.prod.outlook.com
 ([fe80::a167:e9b9:97aa:21b5]) by PA4PR05MB7647.eurprd05.prod.outlook.com
 ([fe80::a167:e9b9:97aa:21b5%3]) with mapi id 15.20.5395.021; Wed, 6 Jul 2022
 03:48:04 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org, davem@davemloft.net
Cc:     syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com
Subject: [net] tipc: fix uninit-value in tipc_nl_node_reset_link_stats
Date:   Wed,  6 Jul 2022 10:47:52 +0700
Message-Id: <20220706034752.5729-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0019.apcprd02.prod.outlook.com
 (2603:1096:4:195::13) To PA4PR05MB7647.eurprd05.prod.outlook.com
 (2603:10a6:102:fb::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 95b0a383-c45d-4803-be77-08da5f0254f5
X-MS-TrafficTypeDiagnostic: PR3PR05MB7018:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tL74Smcyr74+ECYDZxuvtK/a5A5gCmi/wtw4zqifZhYYix7XZUPT9uj/HMQqB//s9FG8fzQsGrsMVjdddd0f41QfJnhP3wsnbGJi/DEPYRDrM4DiikqwHlSGGBIJDhx5qBPi2bAnsZvaR1uez2ivNdOZUs6as+UNEWpbQ8DkxFta5+yjfJNruM0swlQO9EfRIhNnr6mhir/60Bg23ohqUHLyPwva/JjLbnLyAZB4xg89X8x5xG+/WBXmAOa/TtIq12FnS7tbhsd8c+MXpWlt8vbBt+mo+3JQaF6n4VQRxT5kjZq19wqq/DrmldC03p2eJL61xrn0RDEGNXMcUEIcbeeIC+y6Gu9KNikfHR6xKiLOqchP9E1KsyW6ReRr3IpVI2LlZ2MAK8Km5g7bBX49JybISbPP6nGvpnIyOQGAgEtQH7K35aVCJD9H/ub/1p0hUQzH2fZplCSWu5FobsSrW82WdU+Z8VUlQdQVzi46GG3t421e2yWQfajZ3VBfbrwQInMhaCky//gQpCjGJmcIQrPfo12MaSZkQjrNaPx7Ljg40d95BNtm+00yaJJmWqt4DyVeqiVtA/6NZI1SStw2zifbpSk3uDfX1489GRhPEziWPUGh8SzEI0bdhyrrlA2iJRXSZ+IXmIzAb2/BkFdtsbUlbGCcazecK1zMS76FzwyTUN50yP+JgkjsKfEnM999KXylkb7/h7eAmThB/K9Cm4bwx/Ei/WJL8QR8rSTHor2rrIx3STNpbEinNK6lYM6JE6IVNzcIde5ksueQDN6lyGKtIKWERJbNATv7uUr2fZa8/DWMZhuvht0RTg9miTZGhI7TWPFsouKSg7iukZQNtw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR05MB7647.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(376002)(39850400004)(346002)(316002)(38350700002)(38100700002)(7416002)(921005)(36756003)(26005)(6512007)(41300700001)(2906002)(6486002)(8676002)(4326008)(66556008)(186003)(83380400001)(66946007)(66476007)(55236004)(5660300002)(103116003)(52116002)(8936002)(478600001)(2616005)(1076003)(6506007)(6666004)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?W33/0usazyXR2MqIehXO9JLfcyYcIKgKJQBFHPUWGhgLOFlov+GzhqCaOP0b?=
 =?us-ascii?Q?TuPrGaf43pHWBN/a3goRODXLA737cqrK5CLlNeCVEjs6qYBDvjXjSRUubskl?=
 =?us-ascii?Q?SO4arDHL4FdSk4BgIFPv0mYoVf8aSlIHLkXqgoQs7H2A8hgAuTfB1b6JQVBm?=
 =?us-ascii?Q?viC8fCRKpWI8S0oSQkFZebGva9BacqGQ3beFQzHM/PCqTgx+UMxxKntMQJqF?=
 =?us-ascii?Q?EkfhQj0JJuqmFLchLmg9rHjk3+M8tudCovUps94AYnKsebxKYubGujKSsWAn?=
 =?us-ascii?Q?Io99mPE6yqBSOZiN7342jrdUMcmcs3R7+nvUHrCrywZv/J7VcnPQMTweJRMI?=
 =?us-ascii?Q?vqzF+DWQBzZ+jBGg74zP0CxUMl36qyiOMWc1bAdTrVegluthTBDgL+Al7Kjm?=
 =?us-ascii?Q?O3obas1MeskPHNK2zGS+V/zKj2bkIo+q0eKkNvXFvHyTrbyO1gtZ23GTlDPb?=
 =?us-ascii?Q?2jssADEsILUWw7s1vrsA9536xH3yltNdSHLw7Z3nUKkrva3O5WkEjWKnyTvO?=
 =?us-ascii?Q?iwanA/aVoQbt4weSodjCdgS1F1rl4aYDPSv3TlE8+JU+caevTz3PdFVpXf7s?=
 =?us-ascii?Q?rlYxEPrc0d5hLY9aClc2FFuixeiIH6lm8PaBXB1hGEf9llYRQflSzunWxBgW?=
 =?us-ascii?Q?DFLsv/zh8OBLdvUpuerJCWaeb/ZrAs4U3898y4vZPrlIPkI5x3jLegxsR5G2?=
 =?us-ascii?Q?e5VhtsjtjSRTs1r/7NO2sotTf2Cu5HUJUqEWsHdOmthnArqW6kv8WdSxhww3?=
 =?us-ascii?Q?z3L+6MJztjo6D1pvH11n7Je+bLUWLeYCs9QVCs2z5+yJC48G54OEIhCxUwuI?=
 =?us-ascii?Q?mMkdHtwJJK7urkCXnhtfmxcvUYveN335AtzEEk7f/rXvRzfBt4nfH82JNhF9?=
 =?us-ascii?Q?Gefs8CP3ERurnZ2mQlZIfQmvKe7jBCZteWGy4/uGB/9vFOzXKDXnbZs7APK7?=
 =?us-ascii?Q?yEcsf1awmY7k8HrgBXPCTpZ2akfcswempzX46FzLKgBWr8X1YBWEuUVxByUn?=
 =?us-ascii?Q?WsMJoBV1EyswlvRkodJK/V6PgRL54ONiDbwp6FGePR8i4BNj+rdkjG5lZzGP?=
 =?us-ascii?Q?cvYiGs/q7bs2hMbubSgPEZ0aA8pAI0dzJteef+Aalnv4p/OFENGqROrpC1J5?=
 =?us-ascii?Q?pDzuNhcfbhrxRmPgnXpqFPD4hV6o81gZmyso8NJk+koYKI2k5Uq+cmjxeuxJ?=
 =?us-ascii?Q?YdMX9CLPy96sApYRL5x9jTC/aVKo49dnRANYqR5MJT7V0vo06cud+lE44cl9?=
 =?us-ascii?Q?7mBRJ3YUDEeNAKvOXeKD4o8kH/ijIQciJFZ8c/ysFI2CNxJzEMZ1cVt+nAgB?=
 =?us-ascii?Q?b3Yn9Q2f9oy7SFCn3R1kE6BEFSc3YPfveNoBWRs+IX96quRK2Yn7QBQgbLea?=
 =?us-ascii?Q?ZFIH2c85g+4bDHD7wXrZjDfmnzwR5KLxfm9iuZTWBRhJ5HAUxHxEhWfQC0TI?=
 =?us-ascii?Q?/EwUtitz9vOf+Ez0JjA9boW0rb2mkBO7l4MSZjA27xN2GBnLOVOKUXPfMj5Q?=
 =?us-ascii?Q?YAbnKEi6fkg49nz+/Ar71yJUVmFbysRQw70HHRu0wKwfX9bVvMCkDE1Kvh+U?=
 =?us-ascii?Q?+45oDYqJyf28N9pcW88Tlk+NT73RoWwFtac03eyal9RCsdN3xQ5ZKiWaPNQG?=
 =?us-ascii?Q?RA=3D=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 95b0a383-c45d-4803-be77-08da5f0254f5
X-MS-Exchange-CrossTenant-AuthSource: PA4PR05MB7647.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jul 2022 03:48:04.8654
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: V2OOyfJ7wv+nUxz5Gh7gtGIvvxbltwJY+Xf0OgTXY/VGva6q3wPlDkoi+e375C7+uuCIJ6ZS+KZyIHZTEyeEgMyXjc8xNdRJ8QUS9TaZx+8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR05MB7018
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot found the following issue on:
==================================================================
BUG: KMSAN: uninit-value in strlen lib/string.c:495 [inline]
BUG: KMSAN: uninit-value in strstr+0xb4/0x2e0 lib/string.c:840
 strlen lib/string.c:495 [inline]
 strstr+0xb4/0x2e0 lib/string.c:840
 tipc_nl_node_reset_link_stats+0x41e/0xba0 net/tipc/node.c:2582
 genl_family_rcv_msg_doit net/netlink/genetlink.c:731 [inline]
 genl_family_rcv_msg net/netlink/genetlink.c:775 [inline]
 genl_rcv_msg+0x103f/0x1260 net/netlink/genetlink.c:792
 netlink_rcv_skb+0x3a5/0x6c0 net/netlink/af_netlink.c:2501
 genl_rcv+0x3c/0x50 net/netlink/genetlink.c:803
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0xf3b/0x1270 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x1288/0x1440 net/netlink/af_netlink.c:1921
 sock_sendmsg_nosec net/socket.c:714 [inline]
 sock_sendmsg net/socket.c:734 [inline]
 ____sys_sendmsg+0xabc/0xe90 net/socket.c:2492
 ___sys_sendmsg+0x2a5/0x350 net/socket.c:2546
 __sys_sendmsg net/socket.c:2575 [inline]
 __do_sys_sendmsg net/socket.c:2584 [inline]
 __se_sys_sendmsg net/socket.c:2582 [inline]
 __x64_sys_sendmsg+0x367/0x540 net/socket.c:2582
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x46/0xb0
==================================================================

This is because link name string is not validated before it's used
in calling strstr() and strlen().

Reported-by: syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com
Fixes: 03b6fefd9bb4 ("tipc: add support for broadcast rcv stats dumping")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
v2: remove redundant check
---
 net/tipc/node.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index b48d97cbbe29..80885780caa2 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2574,8 +2574,10 @@ int tipc_nl_node_reset_link_stats(struct sk_buff *skb, struct genl_info *info)
 	if (!attrs[TIPC_NLA_LINK_NAME])
 		return -EINVAL;
 
-	link_name = nla_data(attrs[TIPC_NLA_LINK_NAME]);
+	if (nla_len(attrs[TIPC_NLA_LINK_NAME]) <= 0)
+		return -EINVAL;
 
+	link_name = nla_data(attrs[TIPC_NLA_LINK_NAME]);
 	err = -EINVAL;
 	if (!strcmp(link_name, tipc_bclink_name)) {
 		err = tipc_bclink_reset_stats(net, tipc_bc_sndlink(net));
-- 
2.30.2


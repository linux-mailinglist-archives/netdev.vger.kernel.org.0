Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11EE7566048
	for <lists+netdev@lfdr.de>; Tue,  5 Jul 2022 02:58:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231649AbiGEAvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 20:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233931AbiGEAvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 20:51:19 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2136.outbound.protection.outlook.com [40.107.22.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E22E08F
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 17:51:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eY7zGbK9PJOiY/zoUxsB+7uy6fBfuq+L9ynhh/RzTuBJiGrj75fCovjjmYv9vknoc8RTGj/Adk1CZoMODwALTdFPHy/VRvW96a4SRtz6vO1Mkqzsev3hS4xqjGr+gaRf/HnxfvHEUzgWSVNJKPBWpd3XK/QBFYbxYimd+WvN4zPV8m9zLKYWQXLhJDSv3012TdITbo1nB0rjTfhY8qFDX+uaU1v3Ex5Vo8ozb3qv8jmNDcqhFS76cf218/BNgJDNyEoNjJIf4wXQRm15NXLzl7640BVw/6rgkpSJqHMaN6LtUFHhdsQHRmTphjczOxjbWzhuG7uj0QGDCQ9EZ0ky2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+Bx+p4/uYpGtoV/S1yCMvoTVGFQQ3SOcRL7lTrjZB00=;
 b=eGMi1doeju9+QaqFAQq/tQy6kPuq23ccbXb5NNJARRnaDIPT3H/dkdtDZDEmBV4GYtKt3wI8IlYaZZCQFyKkJYTNkPdA5SsiofTaxEmGoRg/AwZtid63ALfyfDiIqLBPRWjfwC7770QPZlMNhFyObJxqJUnIREg53l0kiWdqwknsyH1KyyroG6fp3XdZCI1GzPGmj8F3lmppFQkeXgIkm+QvGBILoPpMCQBdGZN4t1XtX47j4j4VFTKG9rr6RJbdvd5JHaO21LBZNm28hB14PBIblbbjBVRXvangWn+WE9wQuH27H7rjBSV7uu8dQ8bvzevqhvpzoDhLHXqQNxBwRA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Bx+p4/uYpGtoV/S1yCMvoTVGFQQ3SOcRL7lTrjZB00=;
 b=lJ39tH9WVmrvNdiQ/EiFuFoAISGehO482SDgsoL3kCkKBKJzSM1x2jtVzByRYTsribPFD6kpTORypqXD1RmiRDG00Y1dOMDF3GLJdfAOyFCJVUtMLuEojJ+/Po+IzHK7lO8JJFA9byU6lM8QFrcZLwitEVoY4D71DzGCIeSxFUE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com (2603:10a6:10:21f::6)
 by VI1PR05MB6942.eurprd05.prod.outlook.com (2603:10a6:800:182::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.21; Tue, 5 Jul
 2022 00:51:12 +0000
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::f429:2b60:9077:6ba8]) by DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::f429:2b60:9077:6ba8%7]) with mapi id 15.20.5395.021; Tue, 5 Jul 2022
 00:51:12 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org, davem@davemloft.net
Cc:     syzbot+a73d24a22eeeebe5f244@syzkaller.appspotmail.com
Subject: [net-next] tipc: fix uninit-value in tipc_nl_node_reset_link_stats
Date:   Tue,  5 Jul 2022 07:50:57 +0700
Message-Id: <20220705005058.3971-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SGXP274CA0001.SGPP274.PROD.OUTLOOK.COM (2603:1096:4:b8::13)
 To DB9PR05MB7641.eurprd05.prod.outlook.com (2603:10a6:10:21f::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b7cee4ee-835d-4a75-2391-08da5e2074d6
X-MS-TrafficTypeDiagnostic: VI1PR05MB6942:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3xCQiyQRFMAeSAfdVljZqoYpCJs5QTmQuZzwCKWT8Ots/j3kSLCoxh32JiE9ZJiWWhpDYxldD9YETFvPYE9Zug1dazf47CRdso0BI8miX3V+JgWhr6vcx+Rfj1qGfdFEnUYVm1HbCIgfglSXAodcGb1k+M+RYwj8YoEhaSfg5vIV3C7haf12+vTOFM757HCiS0dJwFjp2srQiue2GiC0mJXSNMx4nQO5lNONqMx7tN905MBAeEKjbZba6musIM80AucIHiCmTW+yqvqYYWmTjOnn5gRyX8WAUW1mjGAvQzG7pboL8tQpbLYJa4yK2i1M92rbLI9T8le+kFtDdrow+pitCgRWGJIWLTuqHOKi4nU0GVXY1srGphLYD4p05FWtwRsrTuVMiSFxcMXIWflgTP44ac5oxcpg0B4hmizyI4IpuQplaiJ7V6+GjmBwNJXxxnpw/aBcVWBo359D0ar7tbmdy4OAqWV56hT5waBxhoKWECRdYpyZDRID9OMIqVwQAPH9ex/gt4ULaMb3BW1/m1n8RsDpizDfIxuJ6YBly8ElNGsTKnm5Y06yxklsDFAofFculEqnZhK3mBbkbpHIELtyG3OZ3HD8yHsxGbMuvXs9sAVQuCvhy6kHO0oQB4ivwiahMBUpbVltfvkZn6R1cgYqP81BroRAB5+N2JLLFFtz6LTf4HfURhqge6yu+ckZgXhBifnyVpDpEXFEhOHM76S9qgJWF989KORVszBnsWipa8CxNmRNLRXjXFCxNxqMwUtPI1nAUKRT8cWt2ELaxIFC059fsT9WNKyKmNR29KSD/Ufl0uz7OibaYpzwwVj+YiY6yccCNBiNadL+rSDBlA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB7641.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39840400004)(366004)(136003)(396003)(346002)(376002)(66476007)(66556008)(66946007)(8676002)(2906002)(921005)(83380400001)(4326008)(36756003)(86362001)(103116003)(5660300002)(8936002)(7416002)(316002)(55236004)(52116002)(38100700002)(41300700001)(6512007)(6486002)(6506007)(478600001)(26005)(186003)(2616005)(1076003)(38350700002)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?B9JhLskyDr0isGWmKApGBukXvBJNZeN5KJVoLJZIxKWTqSm7KN9nScThKaBy?=
 =?us-ascii?Q?/dtv0v8+3P59fBBcRPgf0W3kOKkPFsR7oNFkffOJhIk9N56k4eG/Ba6RyUDk?=
 =?us-ascii?Q?BAxDPaX9KOworjj4hYS0Poo+vSDMbywTTJCqVi5BVjAu5jQ1xUWg2HcJkC+k?=
 =?us-ascii?Q?y5T7av0AP2ZCJV7/qbjF3i+iu/R3kAvz/OPwrcZtoLZmHGgjcewPiDHFGJln?=
 =?us-ascii?Q?4XdgvOg4OMjQXpNjr6CgfT+6YLaXz7mlAYEXjCp3cefWv7/aIeUuuMANtpRm?=
 =?us-ascii?Q?2l4AMN/uQ44vnNQfy32JT8VuWJFfxE+Uhb+FxMPB+upq36zmbgSBkU8I+R+N?=
 =?us-ascii?Q?izxmxbXaZkDi32oUp6jA0D0MCsIOJzrPo42Mo3uCdRFShHXULnGYE8+gKKNJ?=
 =?us-ascii?Q?3ReKgznJKm1cYQYMF1zkSwLuUN6xuJpmOqlSSxn+WhhtsoOuGqhe2D5MGVsK?=
 =?us-ascii?Q?6Wp0gWUaPUTGU2jfMeQPv7gV8pDBiFLvA//jAvMBzT2bi2uP2tLLwnKQJY6P?=
 =?us-ascii?Q?vKa05//Kxftarea3LuUTN7iBTY9nOv8tDDsAyhHgaxQgSi3/WMoJ1aU7h8s1?=
 =?us-ascii?Q?VcZ0P08ean3IQNDVRclFxYX+yerXKch2iYCtR5xnnNYSu1RbmJLKU6oCtOXl?=
 =?us-ascii?Q?kUqSuLUsVNu0BuqURJDYBNi914Foq2AB+oY/ZHIA04EFsJ3Fv50HoeIlMbk3?=
 =?us-ascii?Q?P1XbU6xucuMiYR6qpbtVSJewIntGVdNf8lKpuBBKjVwVkkyEDro+mOVmr5EU?=
 =?us-ascii?Q?y84ryeSiewFQjT1DhVuwwALmF1DAeKYsJ/2bq/+F3XAGenrI3a77EvMS8lNr?=
 =?us-ascii?Q?JI2Ni/wdsO6Dd/Xh04BNfCx8D1pZ+PfTeaIQjSHe4pkTwFJUG7mSSQ0ooThG?=
 =?us-ascii?Q?mwBn9HDkU304oVz/wLuhYVxmqEAzSC9I1LHhQYbiFmJLNxr/R7fynmD6T9TL?=
 =?us-ascii?Q?f40S5bUJlikdUczGug/l/kBcHYPs8/vYupz6A7jkZtKxxitx8m+h/B8TILRf?=
 =?us-ascii?Q?OZD3JmMV8g2ctW4UfxN1Jsu5GuicN5awDDyb3xWcPY6hQTVDZ7JIhYWKmWU1?=
 =?us-ascii?Q?lJYKN7Skyk8shyfvKZPvrRwVmeYsrGG/D1XNDu6jB/aI9tt1n5OeE0LuMeIi?=
 =?us-ascii?Q?13kLpGxoE+fGwCqsDAJ2gZMobwPQ0kmILG6Fmh1TXZjUHneHn3gMonhr5mH1?=
 =?us-ascii?Q?W/xlAKI9QN9/tGA6Uu3pgGc6IMinGzVYmn2MMUo+4kfBNwhsea2JM9KFLZ8p?=
 =?us-ascii?Q?PgIdxgvFJlsadpCVQkGYi+4yliqOJG/ZiU/MMIe+HGIJqWVxmRstjjOazsLu?=
 =?us-ascii?Q?1egFA9AyuIpb/kQr3IxlYbCTk/Y3XelvPOeW3muv0VQxop4PncQK0+g2BjRK?=
 =?us-ascii?Q?CTFQczLUUNCsC6EMjgP3wcA71+RgaUqL9f11kinp4dUWsf71czXBPkAfFUIn?=
 =?us-ascii?Q?zbKZnY2WGjbLpNFcWd05PAVee2PprIBfE7bzmijRL7ENbIx/eshdRFLDkUkB?=
 =?us-ascii?Q?mNQgdDD0oLDlGNzHqZSb1kNh/EZVL9x1Ie47wDG/LccxRv1mn5Ts7GM96z0I?=
 =?us-ascii?Q?VLdgyH58qCqUf+iKtsSKimqO2kSexmjzQOAgisoYtvlFWOeM9GTREO+jpNcn?=
 =?us-ascii?Q?8g=3D=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: b7cee4ee-835d-4a75-2391-08da5e2074d6
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB7641.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Jul 2022 00:51:12.1626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K1UYfn1+bWCP1EwN+JborbAWzdGzowkajZAO3lMW6Qvt4SzXgEiTGDl1uVSmT0aM8n1/x5tCs92fvq6xtojjerivArqCb0wBSJgKk+LLrQk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6942
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
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/node.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/tipc/node.c b/net/tipc/node.c
index b48d97cbbe29..23419a599471 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -2561,6 +2561,7 @@ int tipc_nl_node_reset_link_stats(struct sk_buff *skb, struct genl_info *info)
 	struct net *net = sock_net(skb->sk);
 	struct tipc_net *tn = tipc_net(net);
 	struct tipc_link_entry *le;
+	int len;
 
 	if (!info->attrs[TIPC_NLA_LINK])
 		return -EINVAL;
@@ -2574,7 +2575,14 @@ int tipc_nl_node_reset_link_stats(struct sk_buff *skb, struct genl_info *info)
 	if (!attrs[TIPC_NLA_LINK_NAME])
 		return -EINVAL;
 
+	len = nla_len(attrs[TIPC_NLA_LINK_NAME]);
+	if (len <= 0)
+		return -EINVAL;
+
 	link_name = nla_data(attrs[TIPC_NLA_LINK_NAME]);
+	len = min_t(int, len, TIPC_MAX_LINK_NAME);
+	if (!memchr(link_name, '\0', len))
+		return -EINVAL;
 
 	err = -EINVAL;
 	if (!strcmp(link_name, tipc_bclink_name)) {
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E707D6955EB
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 02:26:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbjBNB0b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 20:26:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229601AbjBNB03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 20:26:29 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2138.outbound.protection.outlook.com [40.107.7.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 655DA144BF
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 17:26:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=axk1SdWI5VMkSkxfX3MTTPVY1VYBKxdeTHTlKxReL6HNOLv+xSo4cuKB/S9I7ZqQI96VGzBf+cDfKa7k+/A0LTQ11PNvkP0hec0aMyK8+pzuRFDa+Ngu/Ur3G+EjmiHvdaPFGd7GI2uskCkrv8s/Gr0OjSAdZQEhjHAALj970aT/iXs/9rM5zYVEj/0/5/J5FzCtmz/M5YfFdpsJXECF/XMUFJ/jDQtTBPzbId3V54VfMqwAuhbY1qLzCBb+fNwN5ZtE6jN+CEZh7PpKbd55LDlpkkaZ5yOrahriUOinTAHFPpGcCf5LMnPpLoyclmHRwf4VQHGVkyTn76tmek4SSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ycvM1JJYUJwH2m5Sp6CfCMdQo+OI28NcpehL+f6B6DQ=;
 b=QbvQ3rGOQJMyHQ/1pSfzyejZbW6fhNKxx4yGdJ45kW+5sfA/jTmmF0RLYKFncuhzhxQtTrXTcj4qzMvhNBR7BbWVkWYHH/6cl+GTqkND1BxQJGDOtljEr0YfbBRauQaMc0REAABgUPW7H/Jy3GjpynDQrK8+qR/R0WQkcep6c60XTT3JPxAJ7lvoD4+yAXo3qAcyKnCPiOlFQMg8dzdw44K0x9MYw0DB3X/3C/4d8EnMamDZZHhpMMNx5JfWlaIx3CtdbDX+WXQpsyuJVG6/t4tzHwoNVKB8mrdQajVgMy9xevypPH0CPoyDlZ5TJrBLweY+aOA2RRhwV7BcbU1HTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ycvM1JJYUJwH2m5Sp6CfCMdQo+OI28NcpehL+f6B6DQ=;
 b=lvPXLGhu1vpDZJb6PVI94nhXMjFBuG9+TF3IKFOQHEwvReZtYxhXnL1pLsCEqvCqovLIw5OwxiiB1BwPDLzIwAOH6LneFi6i1QpLt2FOH77wJ+P1baCXWrPJAub2rEZDcj54EZcGAgvRRJ3KF2TH/H9Gwegm1Nw/PN+gmrxCrZk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by AS8PR05MB10758.eurprd05.prod.outlook.com (2603:10a6:20b:63f::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 01:26:22 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4%3]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 01:26:21 +0000
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com,
        viro@zeniv.linux.org.uk,
        syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
Subject: [PATCH v3 net 1/1] tipc: fix kernel warning when sending SYN message
Date:   Tue, 14 Feb 2023 01:26:06 +0000
Message-Id: <20230214012606.5804-1-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR02CA0053.apcprd02.prod.outlook.com
 (2603:1096:4:196::16) To DB9PR05MB9078.eurprd05.prod.outlook.com
 (2603:10a6:10:36a::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR05MB9078:EE_|AS8PR05MB10758:EE_
X-MS-Office365-Filtering-Correlation-Id: 7576fc81-bbcc-4ef2-fe69-08db0e2a7ad9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +BpBzWqsRMIa1HcnpbKmH2w1DW6Q7QngXpbPu0O1BXjHyJ3g6B0q9264stRfBiBhBocg4+acAVn4SV/eAnAZgZ3XvKT1kHMnrlrdxWBFS5fzSl4lms2vQ46VI9v+ApTjChAzGjYM7QSvjfTmC1r7VE/sd/6XbjPPypO6xqe3moweOQImic+nz86JlljhXL2ttwVDVMj0V0HK/NswZnZLKylWfj/5hUfftp0gmbqpcOo9h8nDnKVYcR95c0LVvO0ayCLfV99FJ2M/1bi+OedqLLBlUuEDNN+qu10etuPv/ExraWJrPsCk6Ge3vVdiUOF1dm1exKt4qi/jyoMalovWvyPsnTZqHsHR5O01p+yU6AxNgcVY8PbSz5Eq5tbFJXpods+U6xQgieZkP2C/Mlb4tGqb0qc5EuF6RuOQz4Ku4Nn0yNbRK+gY++TRbX2CCL5eQByYdy0JrabYSYn8wY5wytHIAJw5H3qTQt6jrJ6pvSB/D2DCXoe+XmR7Z8Ihcnb1t1sxjc5V3eEGqq+hhwrhzfoZGIYxRoQhDPuzf0L7gFv2M1hCt2CC219JIw/7D6rGcvhDIp9oR7cTAVQyyMB839tOBPVPznhybLK5zxV8nBZvXuOX/vkUvMQgGXVa3JLgkAw+rUt44tD6Oq0tb4ziCSvFVNbwETq4vmDcgOsOhYDDXe3l8SwsnB03LIyVBcRu4DvO2+yjodGvLuFZnS05gg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(396003)(346002)(136003)(39850400004)(376002)(451199018)(2906002)(15650500001)(83380400001)(2616005)(38350700002)(38100700002)(86362001)(66946007)(66556008)(316002)(8936002)(66476007)(5660300002)(36756003)(41300700001)(4326008)(8676002)(6506007)(1076003)(6666004)(103116003)(26005)(6512007)(186003)(52116002)(6486002)(478600001)(6916009);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LJlvZDfeHSeKwpjBWJcBvXLeWCT5Mnno2dbTd9b1u8aMoQs8fOWBolgEm9Pi?=
 =?us-ascii?Q?53BJ6toRfh/Cs5UQN7BrIY4Uguyc+9x/E+dhuUn6VCAuxlM4UTww52DOrUNZ?=
 =?us-ascii?Q?PDXJFC2atoZhCvRYzKdsBRcCa7p+K3S4jEIP66bxW31R9e335XUBXI2UoUyO?=
 =?us-ascii?Q?F5JyG2xPfZwFh+q49Z0JmiDIZH6vrJV+Su8nROcLlEXZm2QT8duZDp9/XdXz?=
 =?us-ascii?Q?Oqzc9KVNzxBCh0Ubn3DIY0pYT4W66VWL+Qlqb+CLVin0E7AxzADxW6zDoyIr?=
 =?us-ascii?Q?OeSfx2r6rEzErWPJ75SUHc3ES4F4MfH2eV8Vvu2Qsh+2AjkndabMDKdIg9EE?=
 =?us-ascii?Q?VgguIu8BAaoEqYtF50hpa61WaXqcd8TqklJGAEHYDpuOU9bb0QT4b4Yc9ygA?=
 =?us-ascii?Q?VAWGNalj8lJjgjDJmNeNHuntrtV5pO4QTjnUxiE2cD6gUz9OTotClgKp6Q2O?=
 =?us-ascii?Q?RiJYZqFnemhEQN+RIo3tDmOSCpVnQ9Xgi+tyvefJ869BJIaGXhpwNnPRteBa?=
 =?us-ascii?Q?ypmY+6hPrhmEyrBIZ9JxljOdjptxMQjln5jK6DBI7qFmbDKIRTPGjekPC05l?=
 =?us-ascii?Q?FzyRwt86meLOjRHmR56HuvpyoTnrK8bncnxE9BqwhFGwQlD23Q4sisfcXU+2?=
 =?us-ascii?Q?kHfgh+/tqeX/Tnd5efNQxa9Hl/Fx9PAz1wHi7q4/1lMC2nDFB5hMebGGWXDm?=
 =?us-ascii?Q?EbOwu0sbtLwxqJJu2HjoJbVYZ9zl0FvCOaqGNIhU76jlU/obRA09QNrbrxSJ?=
 =?us-ascii?Q?TLH0u2SVYf3YNcFvuvLt3JWB6ZkvVfc4zro21eddtjOvo4ZbeOScfs1qTHGb?=
 =?us-ascii?Q?6vIW1Ws7FM16XNjwQHY8MkS4HwL2HnD/bpdUzbnlSE4bgKXiydneM2HXCl/r?=
 =?us-ascii?Q?nGrNARiud3WA6u8uIdu1cnIiY1NjuhMqUQgH0Ei7WdUnwn7j5ONyDS+KkHtS?=
 =?us-ascii?Q?H1d7wU4lz/1M8N8BU+bcw4vRHLIselSvrQ2fzgCW2/xgedtwAoTO00fvVbGO?=
 =?us-ascii?Q?oyrQ58bVuXiKnwcvfBCalfkZjI3x7uCNvNCnCgHghe3a89qfTONo9J5BVq8F?=
 =?us-ascii?Q?BXh1TrqzfBWOmINBQdbmLp4N1+kA/E11tXCOgi/i9QHq9Z3L07hTKEOV5Zdh?=
 =?us-ascii?Q?0X5ssXMPofeAM26Jg4p9ZP/c6d4WvDTOpdm8lfwvkLAgC8frMhA6Knal1gle?=
 =?us-ascii?Q?OnizC0OVHdQUFI6xBy+i2OO5b9rHmLvRnIheHagIMpoZb94C6wVmEymL0YlY?=
 =?us-ascii?Q?g+OwijHZxGnQVzqLpbpXVPX0oSrvotKf8VyvBCtslFswKYcsouAkKNElpKi+?=
 =?us-ascii?Q?KQe15o1nvCYjciHKiygW0SP61iQICZM5ohymheKm1Yu7SGKCEOOTw8l4UUS5?=
 =?us-ascii?Q?jJJJhJ5gYMPBjUN7a1lNzeE7fF872d3WI99F1ZX6OfUaTFcxanwijcSCDBJq?=
 =?us-ascii?Q?CydCP3G2J1ZRWaIJYDu8DGgrgFF8KWum4FALQwVXS7oG2AmLpLt3nIkW9DNg?=
 =?us-ascii?Q?q0ItWIskn6CVOv4F3Tpc97AXcf5gE0W1TzUgxP5cHcS0AYILoA8sc9AULXsT?=
 =?us-ascii?Q?tgoY4NoRvFkUhe2VUB0FaKWxQX7Ojarnq4N2U4tB/z2xhXOgYZw3rTs3ApKc?=
 =?us-ascii?Q?uw=3D=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 7576fc81-bbcc-4ef2-fe69-08db0e2a7ad9
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Feb 2023 01:26:21.8391
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vdNuHVwcAAemvOCsK5hZSGMiz9nzwUbfnhM82NQuWBqrTL71t2pUSPbobSgLYj/JXo7HOUm8v1a2xYWFkfYgTMfeqZNNu5Y4fGdZDnQIzeU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR05MB10758
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When sending a SYN message, this kernel stack trace is observed:

...
[   13.396352] RIP: 0010:_copy_from_iter+0xb4/0x550
...
[   13.398494] Call Trace:
[   13.398630]  <TASK>
[   13.398630]  ? __alloc_skb+0xed/0x1a0
[   13.398630]  tipc_msg_build+0x12c/0x670 [tipc]
[   13.398630]  ? shmem_add_to_page_cache.isra.71+0x151/0x290
[   13.398630]  __tipc_sendmsg+0x2d1/0x710 [tipc]
[   13.398630]  ? tipc_connect+0x1d9/0x230 [tipc]
[   13.398630]  ? __local_bh_enable_ip+0x37/0x80
[   13.398630]  tipc_connect+0x1d9/0x230 [tipc]
[   13.398630]  ? __sys_connect+0x9f/0xd0
[   13.398630]  __sys_connect+0x9f/0xd0
[   13.398630]  ? preempt_count_add+0x4d/0xa0
[   13.398630]  ? fpregs_assert_state_consistent+0x22/0x50
[   13.398630]  __x64_sys_connect+0x16/0x20
[   13.398630]  do_syscall_64+0x42/0x90
[   13.398630]  entry_SYSCALL_64_after_hwframe+0x63/0xcd

It is because commit a41dad905e5a ("iov_iter: saner checks for attempt
to copy to/from iterator") has introduced sanity check for copying
from/to iov iterator. Lacking of copy direction from the iterator
viewpoint would lead to kernel stack trace like above.

This commit fixes this issue by initializing the iov iterator with
the correct copy direction when sending SYN or ACK without data.

Fixes: f25dcc7687d4 ("tipc: tipc ->sendmsg() conversion")
Reported-by: syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
---
v3: adapt to Paolo and Jakub's comments

 net/tipc/socket.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index b35c8701876a..a38733f2197a 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -2614,6 +2614,7 @@ static int tipc_connect(struct socket *sock, struct sockaddr *dest,
 		/* Send a 'SYN-' to destination */
 		m.msg_name = dest;
 		m.msg_namelen = destlen;
+		iov_iter_kvec(&m.msg_iter, ITER_SOURCE, NULL, 0, 0);
 
 		/* If connect is in non-blocking case, set MSG_DONTWAIT to
 		 * indicate send_msg() is never blocked.
@@ -2776,6 +2777,7 @@ static int tipc_accept(struct socket *sock, struct socket *new_sock, int flags,
 		__skb_queue_head(&new_sk->sk_receive_queue, buf);
 		skb_set_owner_r(buf, new_sk);
 	}
+	iov_iter_kvec(&m.msg_iter, ITER_SOURCE, NULL, 0, 0);
 	__tipc_sendstream(new_sock, &m, 0);
 	release_sock(new_sk);
 exit:
-- 
2.34.1


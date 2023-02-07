Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4C968CBDD
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 02:21:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbjBGBVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 20:21:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjBGBVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 20:21:09 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04on2120.outbound.protection.outlook.com [40.107.8.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB5331A4AF
        for <netdev@vger.kernel.org>; Mon,  6 Feb 2023 17:21:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y4mOvUwVgMUILi5gUX0wjUrIvdFnWYURit2GGqfD3S8/5wVlZBKHIT9d79QXjd6ZMYiUgVzLwv0JOK48Urwyn0MsXUQOi2vlPgpenG18FnDZayDYw5qVrGhftRZAFW62ZUMN7xoVmMfd9n+n7o79NOImt+t2voBMJGRCuDCM45xkIIKaf5fLddphuvOIsSa4O4id9Y+lEmks1nXHpqAodVrFItMBI07aRbN64hHK+FbxwJciXJiNPxG9OHkbq8UbMOXCAXFXNIw3iWIq7la2A0u76/2E6PLDwcc9KzVmST/E6NKTc84iiJPNPd/Oy5CetYwUO2Kyl+ba8+gOJjkS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=c9sO2B8Wr4MkhKUMNTMoLP1bc5zZPNtd3UR2ON6/Zng=;
 b=GxtEzjrA16nGpSYZVRfI3BEV+fX3AEpRZ/ESswat+SSS+qWh0O0wUD45m3+HauuoDZav7KEk0XqURPXCZ3CJJQ7IOEs+CtcGmkK5NnXhk/cSuVtVW/dlgY9HOSxkIHwDukNvVFILbQO+nPxWFr6Ss+/RZZEzieXzuMZ6S/SAa02zpN/mCaX9e7CEAzEzrWeyIYsIopMvb3sMLQQJwtWMiNTifxpgjHk5CvMVbahGlYo9rHZGJJ9PK/GF6Spb3CdSSm5+mIe8rL/nJXDKuotwPVw6WrDasDn77w54XdD7XHtgdiwtDKtUjS2WGzxvztJ/2qLe0WNru709j5aDftgbTQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=c9sO2B8Wr4MkhKUMNTMoLP1bc5zZPNtd3UR2ON6/Zng=;
 b=Dg9C4XxvbY7Gb6ySy2dSJStmSBVKf1nv4dHVy0XxjcAm9UvXDRyByHFfJIvXPmXRW+YTqY4wYCCro55Wt6+Iyf0mVnWF9BCy8ZXZZDk8CfI1MZ9QjZzkBquPQw+qkeSDqdQbXLLGljAlLrq5fm8kh6pnB6u3fa9iopy9XHFNlKQ=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com (2603:10a6:10:36a::7)
 by PAWPR05MB10037.eurprd05.prod.outlook.com (2603:10a6:102:33d::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.31; Tue, 7 Feb
 2023 01:21:01 +0000
Received: from DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4]) by DB9PR05MB9078.eurprd05.prod.outlook.com
 ([fe80::6540:d504:91f2:af4%3]) with mapi id 15.20.6064.028; Tue, 7 Feb 2023
 01:21:01 +0000
From:   Tung Nguyen <tung.q.nguyen@dektech.com.au>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, edumazet@google.com,
        pabeni@redhat.com, jmaloy@redhat.com, ying.xue@windriver.com,
        viro@zeniv.linux.org.uk,
        syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
Subject: [PATCH net 1/1] tipc: fix kernel warning when sending SYN message
Date:   Tue,  7 Feb 2023 01:20:46 +0000
Message-Id: <20230207012046.8683-1-tung.q.nguyen@dektech.com.au>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2PR01CA0054.apcprd01.prod.exchangelabs.com
 (2603:1096:4:193::22) To DB9PR05MB9078.eurprd05.prod.outlook.com
 (2603:10a6:10:36a::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DB9PR05MB9078:EE_|PAWPR05MB10037:EE_
X-MS-Office365-Filtering-Correlation-Id: 833c994b-6ef1-4dfe-cbfe-08db08a992d6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fZYbL1GhGIjBGBS/EQo0YKLnbOJtikoB8SeIFD/oqV5DSsSiOw0C6N1TKvidTLZQN8bdIVwiH9EIlquJ6CysfsdUFREvjYIy7a+8OoCI5ZDGkFe21USKBhkwNJjs3CqnLz+Lx+6ItBh7dXnlfcBjGwAZfVu6M9smOnKGsw0a+EFE95cR68F+0N/VLfSusqWAW9Dlpez3UcqM3ScnMhrDKLy2YKuJ/vkmesAMXviZ77ph7udXgTfIHhy/qQK68uvH22y+9AY+Lucy68Syj2/qPSAfcYiizU1DyPCI1AyzyK52Xr2/P15JyrJTRy58tO8XLqj3jt3MTSj+FVkrhhKSEpai16DjGi+JTzQ+S8COSn5B40EKu/Obv34mk5BqFNQ2gcnO3JUg8WwJRqnGGOPZYE2cNaJuVSm0DRwBO0LImU1KloKWIFfNNNYgSaxXKOEsz5m6mhrslz6lQrJ58y8DJIpqZEqULB2vSEow8y+d2pKdtu/Oq79uVBpUHdeV8M2IN54H/pBJ1CguSaJr8+Ac4UxLHVxnxLS1nU1LASSBapbR1A5BLkO6Rx6Q3fNkd6MG8iGr0smgz4vSILqfkhOtg0IIKnP+r6sHaG3IZFGFR7sah6FNfqVf3gdr8XNTnXZWIeb69Qvj4l9ZHljiOJVPcayZI0p2n2Us2rfD0KFLqYilbK0G1hOM0NCeQQCffAF9BlB+nX0Orgq5+JKtdhOolw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB9078.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39840400004)(136003)(346002)(366004)(396003)(376002)(451199018)(38350700002)(52116002)(66476007)(2906002)(186003)(26005)(6512007)(41300700001)(6506007)(8676002)(6666004)(8936002)(103116003)(66556008)(1076003)(66946007)(6916009)(4326008)(6486002)(15650500001)(36756003)(38100700002)(316002)(5660300002)(86362001)(478600001)(83380400001)(2616005);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?lw/NqCUHWsa/M0Dna2var1aQMn5WAb3Jb/92/HDaqGzP1wDzQ3dtFVg5Dcpa?=
 =?us-ascii?Q?7dOvmZ7zFsGkRd+ciFwZTzPSG7rOXDsdW5MMA1DdfrGnAkal9aiZmWV2uR2U?=
 =?us-ascii?Q?MDv6bGjXUPaLNs+YBXqpFc5YsIr8kcRbDMF6/iY8h7LXPFi+BTwj0lk2qKeH?=
 =?us-ascii?Q?yrohUBqdCJ3ByO0jmtqG6nFIAEKAGYlrZM5j/mwkgLpQMgskfKB5DC4d4tr6?=
 =?us-ascii?Q?BgzWoY7i7C0aAA2O0+v3FFNIUV2bdhWgOC3maACWMln0hPdcJTN3MV5G3N5Y?=
 =?us-ascii?Q?9O9LvKW6id/Vv2iFJQ5rPXHyuT6Fcg/Vf8LmUx5OsNkzyRC3NyDAWFA5t/QO?=
 =?us-ascii?Q?5lcpYFQE0rLQIj5Tg5UokkRLFmxsP/GWckCRNwaQhN1EqmfOnaFAx78akvL4?=
 =?us-ascii?Q?EAs6901mdzUv6jLe54c/Nt7+sc85u28Anz4egoGEE+Fxssl28vuyBhzVEb+V?=
 =?us-ascii?Q?/OHcYOZr/4isjQpyHG6Xik5DvYmcqFIDq54fD/sKxvfBgqHwmH1cZmf6lhG5?=
 =?us-ascii?Q?oxOti6PtnCfIJ5edcT/Tstnj4Z5O3UbifyW7YmNwpbjDAsP0opkF2rgdjvuX?=
 =?us-ascii?Q?kvGz20QdtHIa4DZxtQuN+WSl4ijB2zBgY8FaKhG5Tv3GsvSfNwOpFi7V9YaM?=
 =?us-ascii?Q?ok/civm1al2zvpLD4fEJTupXkez5PQYF1oummfVklvn7dUHkNFl6TVMpweMr?=
 =?us-ascii?Q?oqqgbHf901gaZsfMlIgGN7bQ8yKcFD91iWpm+fvfiq/hW0rKt0muiV+zlU2z?=
 =?us-ascii?Q?ftw1h/D/UvTDc4Uoa7htk0Y2ltzLwhMgEJdP3vExFSJpBSFKcV54SoJEVMkt?=
 =?us-ascii?Q?4ghnvN3H/AquRkibCKQ08KclTMCWgY5tO3W6gy8OT7HK766xh7vkL+Zz6VqD?=
 =?us-ascii?Q?Dqz/NEpxq+PijmjtTrVj8BiUatFsve3dr2Yg5A+gWBs3cVxiNulYsORb6Cd9?=
 =?us-ascii?Q?U6+kReKoufwlUjHEmJdMqSzH4pJ75CL1oZDGrR6qZSWSgKiIqy3V5m5kk9Ci?=
 =?us-ascii?Q?UpPCLU+1Ea/B17zA0XnFJX36sCvHGcOwQ1nTDzKyN/atqpAAv25+rlbeVEAk?=
 =?us-ascii?Q?0kTX0lJSxlqTUuyasL+L0kYEMQxTaTMJQ6aweuepDI8FXJL9aFHJ/RE8lDOE?=
 =?us-ascii?Q?+VelVLr4ZxZntjGZBij9aHemMu0mI3d6B4g0XA7+gkz+6yqJgmWWLpHWrKHQ?=
 =?us-ascii?Q?Xdq3br00i827Fb2DVjJoiH7fiCLZ1f3sCwXTpkH4pGRVXKUMduE77zY2G6Ff?=
 =?us-ascii?Q?pRBLxEnLXHqZt6AN+N+upxw7r9PswfnfprQPLoKV+cZGgvLRWRSMxdxYQ+YA?=
 =?us-ascii?Q?yu+DkJSOPXiBwhPM/tddCuW6LmVka4C1pYqY+Yfic4aaBZFhu0zhPGqdC6XP?=
 =?us-ascii?Q?SUCQstGoYa6QtFzcmSAjWOLfcQBmyOY+AnSG7oFAg8S/qjINomvg5SHDoCrF?=
 =?us-ascii?Q?pV2plySE9kOXBL+JoDIxUJTZ0BD4ku77Rr2iofcNag47qUekMDDT6YAwbRDL?=
 =?us-ascii?Q?m5aecX61+DnTnhpN5NGw5cJgcrwB4VRyouGqV0tczFRrZKCReRjH4L/Hvc5n?=
 =?us-ascii?Q?R7XW6+59qBxMemN/cPy7xBqtM7KFt47drg22cLdD/tGEKLeS8n7UU4YERCj8?=
 =?us-ascii?Q?iA=3D=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 833c994b-6ef1-4dfe-cbfe-08db08a992d6
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB9078.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2023 01:21:01.1759
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aK9Q+F+wysx9kMB/RnDX4istqLwHCSBuOsdT9kwwCzOo/77eURDM53n6eG3kIpt3fNjo7lEWUWWzLhNxclg5xiq6hxGPHYopxep/1zZEzoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWPR05MB10037
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
the correct copy direction.

Reported-by: syzbot+d43608d061e8847ec9f3@syzkaller.appspotmail.com
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
---
 net/tipc/msg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index 5c9fd4791c4b..cce118fea07a 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -381,6 +381,9 @@ int tipc_msg_build(struct tipc_msg *mhdr, struct msghdr *m, int offset,
 
 	msg_set_size(mhdr, msz);
 
+	if (!dsz)
+		iov_iter_init(&m->msg_iter, ITER_SOURCE, NULL, 0, 0);
+
 	/* No fragmentation needed? */
 	if (likely(msz <= pktmax)) {
 		skb = tipc_buf_acquire(msz, GFP_KERNEL);
-- 
2.34.1


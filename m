Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE054EEF2
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 03:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378727AbiFQBqK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 21:46:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233507AbiFQBqI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 21:46:08 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2093.outbound.protection.outlook.com [40.107.20.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB461CFCE
        for <netdev@vger.kernel.org>; Thu, 16 Jun 2022 18:46:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OlYEiYzh4Gwiam/GGsSMBHgQ2QjDBhnbmV9b2vj9n/PfGtw7XiBnmpBmKtrvQRAe7IyapuNFkRjQqPX5iTKuP1C+xhYiDYtEYBCQnM8edRWeYlpyyT6BsY6E7A15N0nfFiZ8VGfO67hiY91/21UUahG3og0dHdSds4jNfueV3V8HXsNDcoeBD5epqAUdVpfKDXsrFQICSvwJyO/aleYL4b/8f5RABeQf0fMLorbz/9INAjHWzjR8Do7vTAVG+XzHuYqCk+uBhZdB9I6T7qMf5+8Z/5vM/nbVLlh6JDEHGXBdN9xesrHhr+68p2q84cL5ikTs+7cb/5djwNWI5o7VYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GiMteV4TX9fEmoVJRgcY9ER1CEnhk/7NMQRFtnCtfb8=;
 b=O9FL9lwSfHVmHhssGUQxS21sKfFvhB9K1QuPOwJSMfJdeGqN1FTmA7ExnHwHdmukSVTWy5otjYnW8vgQgnkmsYMNupl0vVanU/eIH819cRF6sjRpVjhPVFXgH8U3HYdx+YJbyQTza4dHHayqFRYjEUzmiO/5y9UPKVT9GjT4+sin9s+aSG4biJBgtPQDcyBmnDWvl9y1QibX0tnBba/Vlr0kgkpmeKcYdhyeTF0xWPcJNsVptXogB2d1HYKMCKHCfGqxS3FiwAvvmc3miJdU1YdRWi7f6YKVaaQvAhFfRH9AgLWl/Ud44CIHSYocMbMqrycSSDN0T0gv46vfdvH90w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=dektech.com.au; dmarc=pass action=none
 header.from=dektech.com.au; dkim=pass header.d=dektech.com.au; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dektech.com.au;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GiMteV4TX9fEmoVJRgcY9ER1CEnhk/7NMQRFtnCtfb8=;
 b=jGjTVKkYeOQ4V+q3gyd7iMM4Y/h5i0Ibk+a8tGvpMN/0bT09ni5Amb5yxFLoKGxnvtIVUwBMJHCcGuZHVX9gdATdGx51LdG24476A/YVU8HUV5x8TA+7rFNtCcoqLdyE7wQ5OELwkSUjJquGBomEQe+ZSqeZ2+I9o93iCAtoBl8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=dektech.com.au;
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com (2603:10a6:10:21f::6)
 by PR3PR05MB6985.eurprd05.prod.outlook.com (2603:10a6:102:2f::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Fri, 17 Jun
 2022 01:46:04 +0000
Received: from DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::f429:2b60:9077:6ba8]) by DB9PR05MB7641.eurprd05.prod.outlook.com
 ([fe80::f429:2b60:9077:6ba8%6]) with mapi id 15.20.5353.016; Fri, 17 Jun 2022
 01:46:04 +0000
From:   Hoang Le <hoang.h.le@dektech.com.au>
To:     jmaloy@redhat.com, maloy@donjonn.com, ying.xue@windriver.com,
        tung.q.nguyen@dektech.com.au, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, tipc-discussion@lists.sourceforge.net,
        netdev@vger.kernel.org
Cc:     syzbot+47af19f3307fc9c5c82e@syzkaller.appspotmail.com
Subject: [net] tipc: fix use-after-free Read in tipc_named_reinit
Date:   Fri, 17 Jun 2022 08:45:51 +0700
Message-Id: <20220617014551.3235-1-hoang.h.le@dektech.com.au>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0036.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::11) To DB9PR05MB7641.eurprd05.prod.outlook.com
 (2603:10a6:10:21f::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ebaa5df-8734-45b1-891c-08da5003239a
X-MS-TrafficTypeDiagnostic: PR3PR05MB6985:EE_
X-Microsoft-Antispam-PRVS: <PR3PR05MB698586CBB88347C7459A93FFF1AF9@PR3PR05MB6985.eurprd05.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lCXCm2JHcaRRBNu6qqZu3BCB3xMtWYkl/nGYos0rk1EPCKXVyoEwVTtFH28hV1xcTr873z++dXy8HLUIzqGD6iC+69ycXII8v1JkJrhC+z+YGLqCcpz32Sill5Txi0ANl5Hou1en4tIdf4uDf/ftx12DzdJSLksxgHl0r3PgrdeGV7jdbwGL2hfp8KPVkJ694D7GxWi+eYpniOmw854r17mpmnndF/sLd7ogfA0enbDZtMykmXZZhcUnf4Y6pM8E9gFMSeK5pHmj1P7h0H920/oWLvVlXuJbRYR53nv2Xbe4EWlR9mrrCvcAuV+QvJ8xMVZ56jFdyHqCenDFbz23bd0wNKA2kncqHiiFesQ6nM7jR+AHThbc9+xa49LMCo+/sGyYEhgrs73B7zbME/8JlKx+i/HqfPdgIEip8wN5APuerMyXAb8lJ54Yl809RvvD5KRGaD602dXd+Es19ccRzqb9VSKHFx9MRJBlNS5cjDJ9lqcgnN/aeDb3DWdIS56+voxO7xy3enWY1qXcgya8j8laVOqBO8hkvfiAgaaXD6tOkXuY03dpvfKY2M1F1mF5P+F749CPmDAzxXip03ZUK4QMP6cLGhlYADMJ31MFVbT7O5SWFcOKTjwGVoAoQOBVncNdzT68BWZDHG+VGrs/aQxsvetT0CqHk9D7fPSHsyqrh5mTxR6vJ+Fwwm0fmECr+ihV2+DAuscfWBJbD37gsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR05MB7641.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39850400004)(136003)(346002)(366004)(396003)(508600001)(6486002)(8936002)(5660300002)(103116003)(6512007)(186003)(1076003)(83380400001)(2616005)(2906002)(6666004)(26005)(52116002)(86362001)(41300700001)(55236004)(6506007)(66946007)(66556008)(4326008)(66476007)(8676002)(316002)(36756003)(38100700002)(38350700002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?u3ZnK6odf73h3RSoaB0yBJVYuz3uoFZis4779OJmmpTI8fDmxdDGPLjdFHeR?=
 =?us-ascii?Q?1TIdh43XZMCMEyL/N1BttuO99XKHiASelqciRa5U3gpiFwVdgOoLzI8fl8BI?=
 =?us-ascii?Q?2x4TuFKz4Zqn4Nex8E705gqYZ3RJfV0R73556eUxGsfrrADM0i2EYnoF8X/5?=
 =?us-ascii?Q?98WhEWKFNJs+23/PIFWQyNp1ONhF/IUM87aDNdUjcyH3AVI+JjRSmEJvSU88?=
 =?us-ascii?Q?wKyhrv+dXHNocvrSsM8bcashMdZKS8sYqK5OMVkb84BoyGXjCY4zWHYBFxr/?=
 =?us-ascii?Q?DgMV7B2L0mEP2imCFtRzfb3BifEXog2NBibw2r5BrH7zURbfW4BoGyxSdbEE?=
 =?us-ascii?Q?WwIDes0S8bHsg4G2bWzFTRyoMx49cVs5EsIG3OZnOzsAs0DLEhD2Ft36bOw0?=
 =?us-ascii?Q?g1l/u6fsgUkqF1BmKL0VS8GIGq340B+KvK9JETU7nVcNt4xf473eoYeN6Ge8?=
 =?us-ascii?Q?hY0jHj/z9zyopAfuReUEi/Ru550fzvmRu3+3Hs52fWniFZDh8AeJCWE1exOK?=
 =?us-ascii?Q?IttSMzuo6dRbDLZsp+SGozlnMwM8uULFqOUjDP8pNMeLmQ6SYtfbDqPPCOdH?=
 =?us-ascii?Q?4gQcQjjLvhEXiyjwISIWRYqvy0WSc5O9wcd2ANsJon0MZgmOmg0G/3lsRBi4?=
 =?us-ascii?Q?BxfZUeEBU7IfPoGZihEW73LD3VB/zpNVN551hYQESgwpnPu7chhHSJpquOc7?=
 =?us-ascii?Q?CUpoQsHhvynm2wEFJMBunkTx9RVjSZb+B9v5KCpDlZHCgD3N1Tit2/zIUPME?=
 =?us-ascii?Q?ytlj/J04fk9sH2OSkedeidGtdFNUISst/2qsCLSIngtL/pY/bVUwHwHQDCoz?=
 =?us-ascii?Q?0pTJ+IQkZACCeisXDKWm1hDZmN+LqShdnFlsfdo3C6ErY7VIAfmeUMWDqpI2?=
 =?us-ascii?Q?/oyAmE/iTsaQ9Ff+hfQDjG83ShLl/orOTQWMLVqFLHph8UhcgPvPoBEaNxF2?=
 =?us-ascii?Q?Rfcq8HWgwUpikUgCiuLxAuak37Wl9JttvHJT286eu0orLNTkM0oU6GN2lfMb?=
 =?us-ascii?Q?SeKDxC8oqL5UFjbTxt8tns5T6VEAQrSW96Wgkn+pYkmDBH2EiwGB3QV6sGwj?=
 =?us-ascii?Q?vRyYvx6aLVmv+fnTovEcKw6JqkNV/+95LSTb/bkhAMM713Zqd8iL2HtfnHb0?=
 =?us-ascii?Q?dbciZuArWf+M4mPn0w0ZHluAqzo653Me1Y8YY7tfTUm8V+zRlasfvxsYfiVk?=
 =?us-ascii?Q?xKjF26luVKcfYrXyCFYfJHw0eZcw2IELhZH+mRzUG12bNrW69mPnUD8DezNO?=
 =?us-ascii?Q?V9Chbuucxl5gO9cZ+mTXP6kfU3AB1Q/nbuLWJLp9St9mk815+FTolKCUvog6?=
 =?us-ascii?Q?Of3g3rsz6Q/pi9bT8duzad73yY8VG/fxaFtTkADea6F3ZFAqCLcdLEor2S6c?=
 =?us-ascii?Q?ztDVOaRkUbNu05wKc+TKsgn/r0VQPcYfKeZT47x9cqtv3DmVl9tmKvX2SMDi?=
 =?us-ascii?Q?U6qgIAhYZBQ5WeYAhb7d8lola2wgBm3p28l4CiKYyfJCY0R8z9zTROpvOHU+?=
 =?us-ascii?Q?faJxPEVd06dR4/uePv/f0sD+l/VGCPBI5Rhda9HvRiELZUfuLtt+npHY1YQA?=
 =?us-ascii?Q?zEjxIdtLG5j58fVqpXfyGHPfVl/UjW/wVMwkNW+iOBAHTzhMwVdXDdX9fBYP?=
 =?us-ascii?Q?dRgBC5/5ODdo2ZDacuN7QW3DTJNvLSP/A9V/t72VQFLTpZ+WezTosFcUhFB6?=
 =?us-ascii?Q?OXjEImL0wUqh3SC5p6hW0xFJFpwCtUIJeOVtawUXadiTBy1ydhFbbW/YCpLu?=
 =?us-ascii?Q?nlYAXzytbVPuACscYnsdK6IoI+3fvKU=3D?=
X-OriginatorOrg: dektech.com.au
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ebaa5df-8734-45b1-891c-08da5003239a
X-MS-Exchange-CrossTenant-AuthSource: DB9PR05MB7641.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Jun 2022 01:46:04.2706
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 1957ea50-0dd8-4360-8db0-c9530df996b2
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3KhyXeouCO96e1CPvrI0BRI+DSmbLUScGX/70KsVfUh+KDC70FQniujLLr69pU7capxiWZW5UcI2b6MRnhSLjAYKPuHvIKedDehDhV6nIBI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR05MB6985
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
BUG: KASAN: use-after-free in tipc_named_reinit+0x94f/0x9b0
net/tipc/name_distr.c:413
Read of size 8 at addr ffff88805299a000 by task kworker/1:9/23764

CPU: 1 PID: 23764 Comm: kworker/1:9 Not tainted
5.18.0-rc4-syzkaller-00878-g17d49e6e8012 #0
Hardware name: Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Workqueue: events tipc_net_finalize_work
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495
mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 tipc_named_reinit+0x94f/0x9b0 net/tipc/name_distr.c:413
 tipc_net_finalize+0x234/0x3d0 net/tipc/net.c:138
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>
[...]
==================================================================

In the commit
d966ddcc3821 ("tipc: fix a deadlock when flushing scheduled work"),
the cancel_work_sync() function just to make sure ONLY the work
tipc_net_finalize_work() is executing/pending on any CPU completed before
tipc namespace is destroyed through tipc_exit_net(). But this function
is not guaranteed the work is the last queued. So, the destroyed instance
may be accessed in the work which will try to enqueue later.

In order to completely fix, we re-order the calling of cancel_work_sync()
to make sure the work tipc_net_finalize_work() was last queued and it
must be completed by calling cancel_work_sync().

Reported-by: syzbot+47af19f3307fc9c5c82e@syzkaller.appspotmail.com
Fixes: d966ddcc3821 ("tipc: fix a deadlock when flushing scheduled work")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
---
 net/tipc/core.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/tipc/core.c b/net/tipc/core.c
index 3f4542e0f065..434e70eabe08 100644
--- a/net/tipc/core.c
+++ b/net/tipc/core.c
@@ -109,10 +109,9 @@ static void __net_exit tipc_exit_net(struct net *net)
 	struct tipc_net *tn = tipc_net(net);
 
 	tipc_detach_loopback(net);
+	tipc_net_stop(net);
 	/* Make sure the tipc_net_finalize_work() finished */
 	cancel_work_sync(&tn->work);
-	tipc_net_stop(net);
-
 	tipc_bcast_stop(net);
 	tipc_nametbl_stop(net);
 	tipc_sk_rht_destroy(net);
-- 
2.30.2


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0617154B35B
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 16:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348583AbiFNOgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 10:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348272AbiFNOfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 10:35:55 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 577423B542;
        Tue, 14 Jun 2022 07:35:48 -0700 (PDT)
Received: from dggpemm500022.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4LMrY35BLLzjY2V;
        Tue, 14 Jun 2022 22:34:15 +0800 (CST)
Received: from dggpemm500011.china.huawei.com (7.185.36.110) by
 dggpemm500022.china.huawei.com (7.185.36.162) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 22:35:45 +0800
Received: from [10.136.114.193] (10.136.114.193) by
 dggpemm500011.china.huawei.com (7.185.36.110) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Tue, 14 Jun 2022 22:35:44 +0800
Message-ID: <0c0468ae-5fe3-a71f-c987-18475756caca@huawei.com>
Date:   Tue, 14 Jun 2022 22:35:44 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [syzbot] WARNING: ODEBUG bug in route4_destroy
Content-Language: en-US
To:     syzbot <syzbot+2e3efb5eb71cb5075ba7@syzkaller.appspotmail.com>
References: <000000000000a81af205cb2e2878@google.com>
CC:     <davem@davemloft.net>, <jhs@mojatatu.com>, <jiri@resnulli.us>,
        <kuba@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <syzkaller-bugs@googlegroups.com>,
        <xiyou.wangcong@gmail.com>
From:   Zhen Chen <chenzhen126@huawei.com>
In-Reply-To: <000000000000a81af205cb2e2878@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.193]
X-ClientProxiedBy: dggems703-chm.china.huawei.com (10.3.19.180) To
 dggpemm500011.china.huawei.com (7.185.36.110)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 21/9/5 0:46, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    57f780f1c433 atlantic: Fix driver resume flow.
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=162590a5300000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=765eea9a273a8879
> dashboard link: https://syzkaller.appspot.com/bug?extid=2e3efb5eb71cb5075ba7
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11979286300000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14391933300000
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2e3efb5eb71cb5075ba7@syzkaller.appspotmail.com
> 
> ------------[ cut here ]------------
> ODEBUG: activate active (active state 1) object type: rcu_head hint: 0x0
> WARNING: CPU: 0 PID: 8461 at lib/debugobjects.c:505 debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> Modules linked in:
> CPU: 0 PID: 8461 Comm: syz-executor318 Not tainted 5.14.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:505
> Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd e0 c8 e3 89 4c 89 ee 48 c7 c7 e0 bc e3 89 e8 f0 de 0d 05 <0f> 0b 83 05 95 53 92 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
> RSP: 0018:ffffc9000160efb0 EFLAGS: 00010286
> RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
> RDX: ffff8880224a8000 RSI: ffffffff815d85b5 RDI: fffff520002c1de8
> RBP: 0000000000000001 R08: 0000000000000000 R09: 0000000000000000
> R10: ffffffff815d23ee R11: 0000000000000000 R12: ffffffff898d3320
> R13: ffffffff89e3c3a0 R14: 0000000000000000 R15: ffffffff898d3320
> FS:  00007f00d3339700(0000) GS:ffff8880b9c00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f00d3318718 CR3: 0000000018f1d000 CR4: 00000000001506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  debug_object_activate+0x2da/0x3e0 lib/debugobjects.c:672
>  debug_rcu_head_queue kernel/rcu/rcu.h:176 [inline]
>  __call_rcu kernel/rcu/tree.c:3013 [inline]
>  call_rcu+0x2c/0x750 kernel/rcu/tree.c:3109
>  queue_rcu_work+0x82/0xa0 kernel/workqueue.c:1754
>  route4_queue_work net/sched/cls_route.c:272 [inline]
>  route4_destroy+0x4b9/0x9a0 net/sched/cls_route.c:299
>  tcf_proto_destroy+0x6a/0x2d0 net/sched/cls_api.c:297
>  tcf_proto_put+0x8c/0xc0 net/sched/cls_api.c:309
>  tcf_chain_flush+0x21a/0x360 net/sched/cls_api.c:615
>  tcf_block_flush_all_chains net/sched/cls_api.c:1016 [inline]
>  __tcf_block_put+0x15a/0x510 net/sched/cls_api.c:1178
>  tcf_block_put_ext net/sched/cls_api.c:1383 [inline]
>  tcf_block_put_ext net/sched/cls_api.c:1375 [inline]
>  tcf_block_put+0xde/0x130 net/sched/cls_api.c:1393
>  drr_destroy_qdisc+0x44/0x1d0 net/sched/sch_drr.c:458
>  qdisc_destroy+0xc4/0x4d0 net/sched/sch_generic.c:1025
>  qdisc_put+0xcd/0xe0 net/sched/sch_generic.c:1044
>  notify_and_destroy net/sched/sch_api.c:1006 [inline]
>  qdisc_graft+0xc7c/0x1260 net/sched/sch_api.c:1078
>  tc_modify_qdisc+0xba4/0x1a60 net/sched/sch_api.c:1674
>  rtnetlink_rcv_msg+0x413/0xb80 net/core/rtnetlink.c:5575
>  netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2504
>  netlink_unicast_kernel net/netlink/af_netlink.c:1314 [inline]
>  netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1340
>  netlink_sendmsg+0x86d/0xdb0 net/netlink/af_netlink.c:1929
>  sock_sendmsg_nosec net/socket.c:703 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:723
>  ____sys_sendmsg+0x6e8/0x810 net/socket.c:2394
>  ___sys_sendmsg+0xf3/0x170 net/socket.c:2448
>  __sys_sendmsg+0xe5/0x1b0 net/socket.c:2477
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x445ef9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f00d3339308 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00000000004cb468 RCX: 0000000000445ef9
> RDX: 0000000000000000 RSI: 0000000020000040 RDI: 0000000000000004
> RBP: 00000000004cb460 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000000000000008 R11: 0000000000000246 R12: 00000000004cb46c
> R13: 000000000049b074 R14: 6d32cc5e8ead0600 R15: 0000000000022000
> 

This looks like  route4_destroy is deleting the 'fold' which has been freed by tcf_queue_work in route4_change. It means 'fold' is still in the table.
I have tested this patch on syzbot and it works well, but I am not sure whether it will introduce other issues...

diff --git a/net/sched/cls_route.c b/net/sched/cls_route.c
index a35ab8c27866..758c21f9d628 100644
--- a/net/sched/cls_route.c
+++ b/net/sched/cls_route.c
@@ -526,7 +526,7 @@ static int route4_change(struct net *net, struct sk_buff *in_skb,
 	rcu_assign_pointer(f->next, f1);
 	rcu_assign_pointer(*fp, f);
 
-	if (fold && fold->handle && f->handle != fold->handle) {
+	if (fold && f->handle != fold->handle) {
 		th = to_hash(fold->handle);
 		h = from_hash(fold->handle >> 16);
 		b = rtnl_dereference(head->table[th]);

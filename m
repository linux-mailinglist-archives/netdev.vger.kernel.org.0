Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEC4374F25
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 08:04:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231254AbhEFGFD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 02:05:03 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37240 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbhEFGEy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 02:04:54 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14661lou127795;
        Thu, 6 May 2021 06:01:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=zhQ+WA48JFGmjO7TRq0Yk5NHFcEYkX271Vzs97/pf3o=;
 b=Ana1tJafEBjo9fm/Muh8iwODAYq4bFDa7CZbuo6HhhypGzoke9dCS7LwcNIZRBesp1Ot
 uUBcrIJ5KzMNLm0u/RpafZHHG34A0eSP23Uvp7gCu7UyNwDjI3Cl0U2gsn4GFrV45JLy
 UxR9ldXZ9+Puc47v1Huy7kX8pqMiRP0hIciKrWb+XkqrSViWJvaU/E7CS7Pz3ENebaUu
 HkhWz/5NMd1yczkFK25buL8zhe93rL+P+43pss7bx6VeuKxDWVIiu9pW/cP87c/xIQtz
 C1gskgMwfblHC0Cn80sxihdcObcCV3FcZAApgDkc2JSDI8LJUJqghbZM2ltnQA3wnqBJ lA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 38bebc3usx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 06:01:47 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14661LrK035995;
        Thu, 6 May 2021 06:01:47 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by userp3030.oracle.com with ESMTP id 38bebuu60g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 06:01:47 +0000
Received: from userp3030.oracle.com (userp3030.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 14661kxs037884;
        Thu, 6 May 2021 06:01:46 GMT
Received: from aserv0121.oracle.com (aserv0121.oracle.com [141.146.126.235])
        by userp3030.oracle.com with ESMTP id 38bebuu603-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 May 2021 06:01:46 +0000
Received: from abhmp0007.oracle.com (abhmp0007.oracle.com [141.146.116.13])
        by aserv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 14661e00032277;
        Thu, 6 May 2021 06:01:41 GMT
Received: from kadam (/102.36.221.92)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Wed, 05 May 2021 23:01:40 -0700
Date:   Thu, 6 May 2021 09:01:33 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     ETenal <etenalcxz@gmail.com>
Cc:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: KASAN: use-after-free Read in hci_chan_del
Message-ID: <20210506060133.GA1955@kadam>
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-ORIG-GUID: fIWI81ykfdUOcjQJUyShvOfVph_bNFP2
X-Proofpoint-GUID: fIWI81ykfdUOcjQJUyShvOfVph_bNFP2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9975 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 phishscore=0 spamscore=0 adultscore=0 clxscore=1011 mlxscore=0
 malwarescore=0 mlxlogscore=999 impostorscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2105060040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 04, 2021 at 02:50:03PM -0700, ETenal wrote:
> Hi,
> 
> This is SyzScope, a research project that aims to reveal high-risk
> primitives from a seemingly low-risk bug (UAF/OOB read, WARNING, BUG, etc.).
> 
> We are currently testing seemingly low-risk bugs on syzbot's open
> section(https://syzkaller.appspot.com/upstream), and try to reach out to
> kernel developers as long as SyzScope discovers any high-risk primitives.
> 
> Please let us know if SyzScope indeed helps, and any suggestions/feedback.
> 
> Regrading the bug "KASAN: use-after-free Read in hci_chan_del", SyzScope
> reports 3 memory write capability.
> 
> The detailed comments can be found at https://sites.google.com/view/syzscope/kasan-use-after-free-read-in-hci_chan_del
> 

I don't understand what you are saying at all.  This looks like a normal
syzbot email.  Are you saying that part of it generated by SyzScope?
I don't think there is anyone who thinks a UAF/OOB read is low impact.

There are no comments at the "detailed comments" URL.

regards,
dan carpenter

> On 8/2/2020 1:45 PM, syzbot wrote:
> > Hello,
> > 
> > syzbot found the following issue on:
> > 
> > HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=11b8d570900000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
> > dashboard link: https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
> > compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f7ceea900000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e5de04900000
> > 
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com
> > 
> > IPVS: ftp: loaded support on port[0] = 21
> > ==================================================================
> > BUG: KASAN: use-after-free in hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
> > Read of size 8 at addr ffff8880a9591f18 by task syz-executor081/6793
> > 
> > CPU: 0 PID: 6793 Comm: syz-executor081 Not tainted 5.8.0-rc7-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >   __dump_stack lib/dump_stack.c:77 [inline]
> >   dump_stack+0x1f0/0x31e lib/dump_stack.c:118
> >   print_address_description+0x66/0x5a0 mm/kasan/report.c:383
> >   __kasan_report mm/kasan/report.c:513 [inline]
> >   kasan_report+0x132/0x1d0 mm/kasan/report.c:530
> >   hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
> >   l2cap_conn_del+0x4c2/0x650 net/bluetooth/l2cap_core.c:1900
> >   hci_disconn_cfm include/net/bluetooth/hci_core.h:1355 [inline]
> >   hci_conn_hash_flush+0x127/0x200 net/bluetooth/hci_conn.c:1536
> >   hci_dev_do_close+0xb7b/0x1040 net/bluetooth/hci_core.c:1761
> >   hci_unregister_dev+0x16d/0x1590 net/bluetooth/hci_core.c:3606
> >   vhci_release+0x73/0xc0 drivers/bluetooth/hci_vhci.c:340
> >   __fput+0x2f0/0x750 fs/file_table.c:281
> >   task_work_run+0x137/0x1c0 kernel/task_work.c:135
> >   exit_task_work include/linux/task_work.h:25 [inline]
> >   do_exit+0x601/0x1f80 kernel/exit.c:805
> >   do_group_exit+0x161/0x2d0 kernel/exit.c:903
> >   __do_sys_exit_group+0x13/0x20 kernel/exit.c:914
> >   __se_sys_exit_group+0x10/0x10 kernel/exit.c:912
> >   __x64_sys_exit_group+0x37/0x40 kernel/exit.c:912
> >   do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
> >   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > RIP: 0033:0x444fe8
> > Code: Bad RIP value.
> > RSP: 002b:00007ffe96e46e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> > RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000444fe8
> > RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
> > RBP: 00000000004ccdd0 R08: 00000000000000e7 R09: ffffffffffffffd0
> > R10: 00007f5ee25cd700 R11: 0000000000000246 R12: 0000000000000001
> > R13: 00000000006e0200 R14: 0000000000000000 R15: 0000000000000000
> > 
> > Allocated by task 6821:
> >   save_stack mm/kasan/common.c:48 [inline]
> >   set_track mm/kasan/common.c:56 [inline]
> >   __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
> >   kmem_cache_alloc_trace+0x234/0x300 mm/slab.c:3551
> >   kmalloc include/linux/slab.h:555 [inline]
> >   kzalloc include/linux/slab.h:669 [inline]
> >   hci_chan_create+0x9a/0x270 net/bluetooth/hci_conn.c:1692
> >   l2cap_conn_add+0x66/0xb00 net/bluetooth/l2cap_core.c:7699
> >   l2cap_connect_cfm+0xdb/0x12b0 net/bluetooth/l2cap_core.c:8097
> >   hci_connect_cfm include/net/bluetooth/hci_core.h:1340 [inline]
> >   hci_remote_features_evt net/bluetooth/hci_event.c:3210 [inline]
> >   hci_event_packet+0x1164c/0x18260 net/bluetooth/hci_event.c:6061
> >   hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
> >   process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
> >   worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
> >   kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
> >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
> > 
> > Freed by task 1530:
> >   save_stack mm/kasan/common.c:48 [inline]
> >   set_track mm/kasan/common.c:56 [inline]
> >   kasan_set_free_info mm/kasan/common.c:316 [inline]
> >   __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
> >   __cache_free mm/slab.c:3426 [inline]
> >   kfree+0x10a/0x220 mm/slab.c:3757
> >   hci_disconn_loglink_complete_evt net/bluetooth/hci_event.c:4999 [inline]
> >   hci_event_packet+0x304e/0x18260 net/bluetooth/hci_event.c:6188
> >   hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
> >   process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
> >   worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
> >   kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
> >   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
> > 
> > The buggy address belongs to the object at ffff8880a9591f00
> >   which belongs to the cache kmalloc-128 of size 128
> > The buggy address is located 24 bytes inside of
> >   128-byte region [ffff8880a9591f00, ffff8880a9591f80)
> > The buggy address belongs to the page:
> > page:ffffea0002a56440 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a9591800
> > flags: 0xfffe0000000200(slab)
> > raw: 00fffe0000000200 ffffea0002a5a648 ffffea00028a4a08 ffff8880aa400700
> > raw: ffff8880a9591800 ffff8880a9591000 000000010000000a 0000000000000000
> > page dumped because: kasan: bad access detected
> > 
> > Memory state around the buggy address:
> >   ffff8880a9591e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >   ffff8880a9591e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > > ffff8880a9591f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >                              ^
> >   ffff8880a9591f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >   ffff8880a9592000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> > ==================================================================
> > 
> > 
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> > 
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/c2004663-e54a-7fbc-ee19-b2749549e2dd%40gmail.com.

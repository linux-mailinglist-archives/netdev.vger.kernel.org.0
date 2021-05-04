Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C278A37320C
	for <lists+netdev@lfdr.de>; Tue,  4 May 2021 23:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232301AbhEDVvD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 17:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231478AbhEDVvC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 17:51:02 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECABEC061574;
        Tue,  4 May 2021 14:50:06 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id b15so411162pfl.4;
        Tue, 04 May 2021 14:50:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=IZnDKiFZ8CqzWkbuMrj9inU1SRr2OCzA7LNNTXRdhJw=;
        b=DL9jVRWfYdE629y44frfGuUL8TcJOBoPV4ksOG4b4+2OZm6j6UqezXCJH0KzRY5Ehz
         kUm+8ZhwrG1wHNMw+FpQE5N28W8Wv70rLm2H0x4xMrQdBSgPXp5eocNXQemKQZOESTyt
         NPGtVTn7DovE0ePvsPdalxnrHBgHJV3aNRTWzXPz6jw/XLxUq7TqCrfZYgs/zqrb2ydS
         eAmpZzTcB9TZE/JTLg6Oubhmu1o68fO58Lsqw+Knaoh7/Qsx4Q0MYlD7ydUZ0ID3BWbT
         Z0T8MkYadTtIKcxTJKN7J6i2UabTYObH51ewnz5U+FE6oEsPbK1C0RSED2oMSoEdTCbh
         6jUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=IZnDKiFZ8CqzWkbuMrj9inU1SRr2OCzA7LNNTXRdhJw=;
        b=n9FBNPAgPCD5Za08WyO7VwoPRKkBaQ8RXMtjey3uCe2f/gmp/GyHcI6Ux4xlRtjpl1
         FpT1+nWyUZSjE805tOyU67SEzG/yjk514hC+lXXJg+gRetL+e3aKmz6f0mXrfa4ChwUv
         SMcyKc6q9GJET4VIuCtc/yjcWJcQjGmEG6XnYt/AbyLDhyLdFxdsfMT+3nKwNJgbWcmZ
         78X82M0nGnCwVLyhSeiad3Rv+kge7qUm/1kwIGIaIrUIIpHJoWL2WvhwDQ/Hyj58eQn+
         FbbF2nEYfmUuzEcx5jDruXikWoZI8H8K90+TTuZvzV6Yd+ojU8EuyNYdFvl0INEL5rh1
         fH3Q==
X-Gm-Message-State: AOAM532gwTBdzZ1tp1jMXbx+3+GdUh/tzcBuQyqQrcRkP3KecG1skjYV
        hQW6xOXxZcoDnfT/tygVUJ0=
X-Google-Smtp-Source: ABdhPJyogW9s6Scoep48bLJ9GB3u8EniQlVjSzYCyxWb/ZLzvzR2LCqRyc0m5Zout8BD//UjYRrSsg==
X-Received: by 2002:a62:3344:0:b029:24c:735c:4546 with SMTP id z65-20020a6233440000b029024c735c4546mr25284058pfz.1.1620165006195;
        Tue, 04 May 2021 14:50:06 -0700 (PDT)
Received: from [192.168.1.41] (097-090-198-083.res.spectrum.com. [97.90.198.83])
        by smtp.gmail.com with ESMTPSA id o4sm14232075pjg.2.2021.05.04.14.50.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 14:50:05 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in hci_chan_del
To:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000adea7f05abeb19cf@google.com>
From:   ETenal <etenalcxz@gmail.com>
Message-ID: <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
Date:   Tue, 4 May 2021 14:50:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <000000000000adea7f05abeb19cf@google.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This is SyzScope, a research project that aims to reveal high-risk 
primitives from a seemingly low-risk bug (UAF/OOB read, WARNING, BUG, etc.).

We are currently testing seemingly low-risk bugs on syzbot's open 
section(https://syzkaller.appspot.com/upstream), and try to reach out to 
kernel developers as long as SyzScope discovers any high-risk primitives.

Please let us know if SyzScope indeed helps, and any suggestions/feedback.

Regrading the bug "KASAN: use-after-free Read in hci_chan_del", SyzScope 
reports 3 memory write capability.

The detailed comments can be found at 
https://sites.google.com/view/syzscope/kasan-use-after-free-read-in-hci_chan_del

On 8/2/2020 1:45 PM, syzbot wrote:
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=11b8d570900000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
> dashboard link: https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f7ceea900000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e5de04900000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com
>
> IPVS: ftp: loaded support on port[0] = 21
> ==================================================================
> BUG: KASAN: use-after-free in hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
> Read of size 8 at addr ffff8880a9591f18 by task syz-executor081/6793
>
> CPU: 0 PID: 6793 Comm: syz-executor081 Not tainted 5.8.0-rc7-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>   __dump_stack lib/dump_stack.c:77 [inline]
>   dump_stack+0x1f0/0x31e lib/dump_stack.c:118
>   print_address_description+0x66/0x5a0 mm/kasan/report.c:383
>   __kasan_report mm/kasan/report.c:513 [inline]
>   kasan_report+0x132/0x1d0 mm/kasan/report.c:530
>   hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
>   l2cap_conn_del+0x4c2/0x650 net/bluetooth/l2cap_core.c:1900
>   hci_disconn_cfm include/net/bluetooth/hci_core.h:1355 [inline]
>   hci_conn_hash_flush+0x127/0x200 net/bluetooth/hci_conn.c:1536
>   hci_dev_do_close+0xb7b/0x1040 net/bluetooth/hci_core.c:1761
>   hci_unregister_dev+0x16d/0x1590 net/bluetooth/hci_core.c:3606
>   vhci_release+0x73/0xc0 drivers/bluetooth/hci_vhci.c:340
>   __fput+0x2f0/0x750 fs/file_table.c:281
>   task_work_run+0x137/0x1c0 kernel/task_work.c:135
>   exit_task_work include/linux/task_work.h:25 [inline]
>   do_exit+0x601/0x1f80 kernel/exit.c:805
>   do_group_exit+0x161/0x2d0 kernel/exit.c:903
>   __do_sys_exit_group+0x13/0x20 kernel/exit.c:914
>   __se_sys_exit_group+0x10/0x10 kernel/exit.c:912
>   __x64_sys_exit_group+0x37/0x40 kernel/exit.c:912
>   do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
>   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> RIP: 0033:0x444fe8
> Code: Bad RIP value.
> RSP: 002b:00007ffe96e46e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000444fe8
> RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
> RBP: 00000000004ccdd0 R08: 00000000000000e7 R09: ffffffffffffffd0
> R10: 00007f5ee25cd700 R11: 0000000000000246 R12: 0000000000000001
> R13: 00000000006e0200 R14: 0000000000000000 R15: 0000000000000000
>
> Allocated by task 6821:
>   save_stack mm/kasan/common.c:48 [inline]
>   set_track mm/kasan/common.c:56 [inline]
>   __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
>   kmem_cache_alloc_trace+0x234/0x300 mm/slab.c:3551
>   kmalloc include/linux/slab.h:555 [inline]
>   kzalloc include/linux/slab.h:669 [inline]
>   hci_chan_create+0x9a/0x270 net/bluetooth/hci_conn.c:1692
>   l2cap_conn_add+0x66/0xb00 net/bluetooth/l2cap_core.c:7699
>   l2cap_connect_cfm+0xdb/0x12b0 net/bluetooth/l2cap_core.c:8097
>   hci_connect_cfm include/net/bluetooth/hci_core.h:1340 [inline]
>   hci_remote_features_evt net/bluetooth/hci_event.c:3210 [inline]
>   hci_event_packet+0x1164c/0x18260 net/bluetooth/hci_event.c:6061
>   hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
>   process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>   worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>   kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
>
> Freed by task 1530:
>   save_stack mm/kasan/common.c:48 [inline]
>   set_track mm/kasan/common.c:56 [inline]
>   kasan_set_free_info mm/kasan/common.c:316 [inline]
>   __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
>   __cache_free mm/slab.c:3426 [inline]
>   kfree+0x10a/0x220 mm/slab.c:3757
>   hci_disconn_loglink_complete_evt net/bluetooth/hci_event.c:4999 [inline]
>   hci_event_packet+0x304e/0x18260 net/bluetooth/hci_event.c:6188
>   hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
>   process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>   worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>   kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>   ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
>
> The buggy address belongs to the object at ffff8880a9591f00
>   which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 24 bytes inside of
>   128-byte region [ffff8880a9591f00, ffff8880a9591f80)
> The buggy address belongs to the page:
> page:ffffea0002a56440 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a9591800
> flags: 0xfffe0000000200(slab)
> raw: 00fffe0000000200 ffffea0002a5a648 ffffea00028a4a08 ffff8880aa400700
> raw: ffff8880a9591800 ffff8880a9591000 000000010000000a 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>   ffff8880a9591e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>   ffff8880a9591e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>> ffff8880a9591f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                              ^
>   ffff8880a9591f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>   ffff8880a9592000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>
>
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches
>

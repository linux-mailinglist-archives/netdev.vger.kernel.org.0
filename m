Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10CA4267892
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 09:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgILHgG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 03:36:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgILHgD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 03:36:03 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C78AFC061573;
        Sat, 12 Sep 2020 00:36:03 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d6so8887169pfn.9;
        Sat, 12 Sep 2020 00:36:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=yYff2w6zlApOTzpZkutXOi9traPBbtwOxlc9tQk8BEM=;
        b=ZyEAXGRTCfDJ2C44NKeQntFzg/c6PLNgJoZkMV6VfQf9VbcqxSrEyq97A9n2lGEZn9
         eGVQoslijGaDhRrgoQ0jv1L4ZRyQG4AXI1gdCLlthZmD0ehqrD9NnP0IOTgZt9/m3oua
         DrgWNWLi0jy1hiddHKq1QcjPRmkMCtUttwKb88zLn5wE9barXBjq7Yk2i0BtNErqBQLC
         q+X2CNSmvGqAcYvLakhnzI/RXdKM08vyaegXdglMfTQ482cg1BKfeFJHOqrNXTtf30pY
         G2Ah4X46Yrelys300zVEkzmn6TiTilwP/H1rlHOaVnzvhXQ2BHH+GS5Pfpqo79pykue8
         xOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=yYff2w6zlApOTzpZkutXOi9traPBbtwOxlc9tQk8BEM=;
        b=licDfG0+ufqtgwkCkSxFYVtdKS7aUoDJMBjU0UZE8i5gxKZ53Ssogog09SnAQhBOZS
         MAQcIEs+l7p2gwd1kEpauFT/Q0/9t+F0BxaXmZwcFG2iX0JD4pO2S1/FfueLjK5mjhH9
         Axwn/t6WWP77hX1NDpy/Km7JTzWdiWsyIcUgms+uNqJ0kfuOuh54E4848onelXM9OecD
         aJepIIsEiR6KQjKEnKGa5maDppMcptdZkBLjERBJHYuHYjTZqRoRhlO/sp1NLw2hS3yy
         S2fH6+SNfIMdAFvsJJZf1eY2VR00fwjUJP+bTWW2wr9oqMlgADpQlwnSQvJZH5XAQ7K7
         ZVfw==
X-Gm-Message-State: AOAM531Nvjn6zqw6gu1013X5APgoi0nQWXI17KJFzVgK+76Hg/zZ/vkZ
        e3rrsh37eQshqd7M9Gfp7Do=
X-Google-Smtp-Source: ABdhPJxu8IcukOIJI1s0BZL8A6kNS9HU/8+niTwFoTZlQ/bxh93pdbXAW7OLkjrea/0pcLPu4TC0Fw==
X-Received: by 2002:a63:205d:: with SMTP id r29mr4090921pgm.278.1599896163066;
        Sat, 12 Sep 2020 00:36:03 -0700 (PDT)
Received: from [192.168.0.104] ([49.207.202.95])
        by smtp.gmail.com with ESMTPSA id y25sm4252568pfn.71.2020.09.12.00.35.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2020 00:36:02 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in hci_get_auth_info
To:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+13010b6a10bbd82cc79c@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        netdev <netdev@vger.kernel.org>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>
References: <000000000000e8fb4b05ac58372e@google.com>
 <CACT4Y+Z2Sz8kHxaQNuupfck7X0rUtr4ghDty9ahDTUm2H41Mwg@mail.gmail.com>
From:   Anant Thazhemadam <anant.thazhemadam@gmail.com>
Message-ID: <f3724ef6-7c89-5c24-685e-00327046e144@gmail.com>
Date:   Sat, 12 Sep 2020 13:05:56 +0530
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CACT4Y+Z2Sz8kHxaQNuupfck7X0rUtr4ghDty9ahDTUm2H41Mwg@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11-09-2020 15:20, Dmitry Vyukov wrote:
> On Sat, Aug 8, 2020 at 8:56 AM syzbot
> <syzbot+13010b6a10bbd82cc79c@syzkaller.appspotmail.com> wrote:
>> Hello,
>>
>> syzbot found the following issue on:
>>
>> HEAD commit:    d6efb3ac Merge tag 'tty-5.9-rc1' of git://git.kernel.org/p..
>> git tree:       upstream
>> console output: https://syzkaller.appspot.com/x/log.txt?x=14ad2134900000
>> kernel config:  https://syzkaller.appspot.com/x/.config?x=61ec43e42a83feae
>> dashboard link: https://syzkaller.appspot.com/bug?extid=13010b6a10bbd82cc79c
>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12fd9bc6900000
>>
>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>> Reported-by: syzbot+13010b6a10bbd82cc79c@syzkaller.appspotmail.com
> +Anant who had some questions re this issue.

This bug doesn't seem to be getting triggered anymore for the appropriate kernel(s).
However, given that neither the cause bisection, nor the fix bisection seem to have
suceeded, it makes it all the more difficult to zero down on the commit that might've
fixed this bug. Would it be okay to consider this a one-off, or invalid and close it off?
(unless someone can point out the commit that fixed this, of course).

Thanks for CCing me onto this, Dmitry.

Thanks,
Anant


>
>> ==================================================================
>> BUG: KASAN: use-after-free in __mutex_waiter_is_first kernel/locking/mutex.c:200 [inline]
>> BUG: KASAN: use-after-free in __mutex_lock_common+0x12cd/0x2fc0 kernel/locking/mutex.c:1040
>> Read of size 8 at addr ffff88808e668060 by task syz-executor.4/19584
>>
>> CPU: 0 PID: 19584 Comm: syz-executor.4 Not tainted 5.8.0-syzkaller #0
>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>> Call Trace:
>>  __dump_stack lib/dump_stack.c:77 [inline]
>>  dump_stack+0x1f0/0x31e lib/dump_stack.c:118
>>  print_address_description+0x66/0x5a0 mm/kasan/report.c:383
>>  __kasan_report mm/kasan/report.c:513 [inline]
>>  kasan_report+0x132/0x1d0 mm/kasan/report.c:530
>>  __mutex_waiter_is_first kernel/locking/mutex.c:200 [inline]
>>  __mutex_lock_common+0x12cd/0x2fc0 kernel/locking/mutex.c:1040
>>  __mutex_lock kernel/locking/mutex.c:1103 [inline]
>>  mutex_lock_nested+0x1a/0x20 kernel/locking/mutex.c:1118
>>  hci_get_auth_info+0x69/0x3a0 net/bluetooth/hci_conn.c:1689
>>  hci_sock_bound_ioctl net/bluetooth/hci_sock.c:957 [inline]
>>  hci_sock_ioctl+0x5ae/0x750 net/bluetooth/hci_sock.c:1060
>>  sock_do_ioctl+0x7b/0x260 net/socket.c:1047
>>  sock_ioctl+0x4aa/0x690 net/socket.c:1198
>>  vfs_ioctl fs/ioctl.c:48 [inline]
>>  ksys_ioctl fs/ioctl.c:753 [inline]
>>  __do_sys_ioctl fs/ioctl.c:762 [inline]
>>  __se_sys_ioctl+0xf9/0x160 fs/ioctl.c:760
>>  do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>> RIP: 0033:0x45ccd9
>> Code: 2d b6 fb ff c3 66 2e 0f 1f 84 00 00 00 00 00 66 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 0f 83 fb b5 fb ff c3 66 2e 0f 1f 84 00 00 00 00
>> RSP: 002b:00007f113a564c78 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
>> RAX: ffffffffffffffda RBX: 000000000001d300 RCX: 000000000045ccd9
>> RDX: 0000000020000000 RSI: 00000000800448d7 RDI: 0000000000000005
>> RBP: 000000000078bf40 R08: 0000000000000000 R09: 0000000000000000
>> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000078bf0c
>> R13: 00007ffd62ea93af R14: 00007f113a5659c0 R15: 000000000078bf0c
>>
>> Allocated by task 6822:
>>  save_stack mm/kasan/common.c:48 [inline]
>>  set_track mm/kasan/common.c:56 [inline]
>>  __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
>>  kmem_cache_alloc_trace+0x234/0x300 mm/slab.c:3551
>>  kmalloc include/linux/slab.h:555 [inline]
>>  kzalloc include/linux/slab.h:669 [inline]
>>  hci_alloc_dev+0x4c/0x1aa0 net/bluetooth/hci_core.c:3543
>>  __vhci_create_device drivers/bluetooth/hci_vhci.c:99 [inline]
>>  vhci_create_device+0x113/0x520 drivers/bluetooth/hci_vhci.c:148
>>  process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>>  worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>>  kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>>
>> Freed by task 9965:
>>  save_stack mm/kasan/common.c:48 [inline]
>>  set_track mm/kasan/common.c:56 [inline]
>>  kasan_set_free_info mm/kasan/common.c:316 [inline]
>>  __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
>>  __cache_free mm/slab.c:3426 [inline]
>>  kfree+0x10a/0x220 mm/slab.c:3757
>>  bt_host_release+0x18/0x20 net/bluetooth/hci_sysfs.c:86
>>  device_release+0x70/0x1a0 drivers/base/core.c:1796
>>  kobject_cleanup lib/kobject.c:704 [inline]
>>  kobject_release lib/kobject.c:735 [inline]
>>  kref_put include/linux/kref.h:65 [inline]
>>  kobject_put+0x1a0/0x2c0 lib/kobject.c:752
>>  vhci_release+0x7b/0xc0 drivers/bluetooth/hci_vhci.c:341
>>  __fput+0x2f0/0x750 fs/file_table.c:281
>>  task_work_run+0x137/0x1c0 kernel/task_work.c:135
>>  exit_task_work include/linux/task_work.h:25 [inline]
>>  do_exit+0x5f3/0x1f20 kernel/exit.c:806
>>  do_group_exit+0x161/0x2d0 kernel/exit.c:903
>>  __do_sys_exit_group+0x13/0x20 kernel/exit.c:914
>>  __ia32_sys_exit_group+0x0/0x40 kernel/exit.c:912
>>  __x64_sys_exit_group+0x37/0x40 kernel/exit.c:912
>>  do_syscall_64+0x31/0x70 arch/x86/entry/common.c:46
>>  entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>
>> The buggy address belongs to the object at ffff88808e668000
>>  which belongs to the cache kmalloc-8k of size 8192
>> The buggy address is located 96 bytes inside of
>>  8192-byte region [ffff88808e668000, ffff88808e66a000)
>> The buggy address belongs to the page:
>> page:ffffea0002399a00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 head:ffffea0002399a00 order:2 compound_mapcount:0 compound_pincount:0
>> flags: 0xfffe0000010200(slab|head)
>> raw: 00fffe0000010200 ffffea000217a208 ffffea0001e6c008 ffff8880aa4021c0
>> raw: 0000000000000000 ffff88808e668000 0000000100000001 0000000000000000
>> page dumped because: kasan: bad access detected
>>
>> Memory state around the buggy address:
>>  ffff88808e667f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>  ffff88808e667f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> ffff88808e668000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>                                                        ^
>>  ffff88808e668080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>  ffff88808e668100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>> ==================================================================
>>
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> See https://goo.gl/tpsmEJ for more information about syzbot.
>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>
>> syzbot will keep track of this issue. See:
>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>> syzbot can test patches for this issue, for details see:
>> https://goo.gl/tpsmEJ#testing-patches
>>
>> --
>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000e8fb4b05ac58372e%40google.com.

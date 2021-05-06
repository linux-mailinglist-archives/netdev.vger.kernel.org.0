Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF1C374F78
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 08:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232081AbhEFGnZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 02:43:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbhEFGnY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 May 2021 02:43:24 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE094C061574;
        Wed,  5 May 2021 23:42:26 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id d10so4007884pgf.12;
        Wed, 05 May 2021 23:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Vl3bbQU1HDguIinwTuJ2lDDBKgrunztvaaF8VkSSzKk=;
        b=ZoMt0wSYDni2lC4krp7pKBLEx8V/BCEhTXOucHna5g1P+bUMAdR/k9TnFRHL58VXgu
         k0zQSqTdSrkUizwFmsLDC3GkNDM/DVZ1PDbutajIFrXQtMZoRqUL/K8wSyzyrlmQTLQ6
         tuq2c09zUBICt5DPeUK4ZlXmc/AeU/oQvnFw8VY8TVX6CSr+cgIwZytVX3v5kJZSrmfB
         bNi4WJ6QuuPqdj/ITdILpwd0eubDj+ZrciERYx2/nAEr96nU4fkS9jIhTjXQdvioeCfI
         mdoKaTEb8VcE6NtIJdRbzVR44qqxS9KK2Xu6rHLB8+4Yc9QeIn9+yWXWJIwJDGnSwM+4
         MlBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Vl3bbQU1HDguIinwTuJ2lDDBKgrunztvaaF8VkSSzKk=;
        b=JN/hAQ24hvay6uwM9GuMW2SXdW7eYH8GxVBOZ3ciKqBHmZBxeofMDnot98MThirqq6
         cSsIHp4CuhKxtjSZ9pVhr5qkZ9eVv+LhqYCrTEYejSAiRNeSGHmGiXkJNXUWCCeW+eFK
         YKgNZ3ZZkD+N7B0Vdonvll2XXHb1ZQmye9L8BlWCb0pqEzidknZVMXhK6reYrwy+ZQPa
         RTjG5QW14AbHS17sIrO/lbhCZHMQoPDu6N72Mh6HIPnNNYOnxDiry6azVg41tMDtL0k6
         V/dwWXEeaGikBAAw5pQQMfzCAQa0eI/Of2ydTGErvFHN2dNBE1x49QRz6jEJzVIF2de7
         PX0Q==
X-Gm-Message-State: AOAM532E1U/Yt++mXLUgpc6Li7AIOxm1E/sQZhaLlXGeN7L74pR26sjA
        x3Wz4EHKTklGeBbVTy4lklA=
X-Google-Smtp-Source: ABdhPJw2y+MFeZ5IH6JgbEeBSCP/9PucRon197q4hI/Sz3nAufEBiQ4o55cHMhEcSuCxD63c/fTeHw==
X-Received: by 2002:a05:6a00:2b5:b029:28e:9c4b:b8b4 with SMTP id q21-20020a056a0002b5b029028e9c4bb8b4mr2822741pfs.22.1620283346177;
        Wed, 05 May 2021 23:42:26 -0700 (PDT)
Received: from [192.168.1.14] (097-090-198-083.res.spectrum.com. [97.90.198.83])
        by smtp.gmail.com with ESMTPSA id ls6sm8456369pjb.57.2021.05.05.23.42.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 23:42:25 -0700 (PDT)
Subject: Re: KASAN: use-after-free Read in hci_chan_del
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     davem@davemloft.net, johan.hedberg@gmail.com, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
        marcel@holtmann.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
References: <000000000000adea7f05abeb19cf@google.com>
 <c2004663-e54a-7fbc-ee19-b2749549e2dd@gmail.com>
 <20210506060133.GA1955@kadam>
From:   SyzScope <syzscope@gmail.com>
Message-ID: <a83f6b09-5415-623a-e2b1-330ca6d5dfc4@gmail.com>
Date:   Wed, 5 May 2021 23:42:32 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210506060133.GA1955@kadam>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

Sorry for the confusing. This bug was reported by a normal syzbot email. 
What we are trying to do is discovering more primitives such as memory 
write or function pointer dereference hidden behind the primitive shown 
on syzbot(which is a memory read in hci_chan_del() in this case).

We realized that some primitives may not be found by fuzzing because of 
the heap layout. By symbolizing the UAF/OOB memory and perform a 
symbolic execution, we are able to go deeper in the buggy code instead 
of encountering kernel panic(NULL pointer dereference from UAF/OOB 
memory) or complicated constraints that prevent fuzzing from entering.

In our measurement, we found that memory write bugs are usually fixed 
faster than memory read bugs or non-security bugs(e.g., WARNING). Thus, 
we think evaluating the real impact of a bug helps people understand the 
how risky the bug really is and benefit the patching process.

Regarding this bug, syzbot originally reported a memory read primitive 
(KASAN read  in hci_chan_del()). In the detailed comments URL, we are 
showing that we find a memory write primitive using the same PoC on 
syzbot, we believe the memory write primitive makes the bug more risky.


On 05/05/2021 23:01, Dan Carpenter wrote:
> On Tue, May 04, 2021 at 02:50:03PM -0700, ETenal wrote:
>> Hi,
>>
>> This is SyzScope, a research project that aims to reveal high-risk
>> primitives from a seemingly low-risk bug (UAF/OOB read, WARNING, BUG, etc.).
>>
>> We are currently testing seemingly low-risk bugs on syzbot's open
>> section(https://syzkaller.appspot.com/upstream), and try to reach out to
>> kernel developers as long as SyzScope discovers any high-risk primitives.
>>
>> Please let us know if SyzScope indeed helps, and any suggestions/feedback.
>>
>> Regrading the bug "KASAN: use-after-free Read in hci_chan_del", SyzScope
>> reports 3 memory write capability.
>>
>> The detailed comments can be found at https://sites.google.com/view/syzscope/kasan-use-after-free-read-in-hci_chan_del
>>
> I don't understand what you are saying at all.  This looks like a normal
> syzbot email.  Are you saying that part of it generated by SyzScope?
> I don't think there is anyone who thinks a UAF/OOB read is low impact.
>
> There are no comments at the "detailed comments" URL.
>
> regards,
> dan carpenter
>
>> On 8/2/2020 1:45 PM, syzbot wrote:
>>> Hello,
>>>
>>> syzbot found the following issue on:
>>>
>>> HEAD commit:    ac3a0c84 Merge git://git.kernel.org/pub/scm/linux/kernel/g..
>>> git tree:       upstream
>>> console output: https://syzkaller.appspot.com/x/log.txt?x=11b8d570900000
>>> kernel config:  https://syzkaller.appspot.com/x/.config?x=e59ee776d5aa8d55
>>> dashboard link: https://syzkaller.appspot.com/bug?extid=305a91e025a73e4fd6ce
>>> compiler:       clang version 10.0.0 (https://github.com/llvm/llvm-project/ c2443155a0fb245c8f17f2c1c72b6ea391e86e81)
>>> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f7ceea900000
>>> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17e5de04900000
>>>
>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>> Reported-by: syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com
>>>
>>> IPVS: ftp: loaded support on port[0] = 21
>>> ==================================================================
>>> BUG: KASAN: use-after-free in hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
>>> Read of size 8 at addr ffff8880a9591f18 by task syz-executor081/6793
>>>
>>> CPU: 0 PID: 6793 Comm: syz-executor081 Not tainted 5.8.0-rc7-syzkaller #0
>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>> Call Trace:
>>>    __dump_stack lib/dump_stack.c:77 [inline]
>>>    dump_stack+0x1f0/0x31e lib/dump_stack.c:118
>>>    print_address_description+0x66/0x5a0 mm/kasan/report.c:383
>>>    __kasan_report mm/kasan/report.c:513 [inline]
>>>    kasan_report+0x132/0x1d0 mm/kasan/report.c:530
>>>    hci_chan_del+0x33/0x130 net/bluetooth/hci_conn.c:1707
>>>    l2cap_conn_del+0x4c2/0x650 net/bluetooth/l2cap_core.c:1900
>>>    hci_disconn_cfm include/net/bluetooth/hci_core.h:1355 [inline]
>>>    hci_conn_hash_flush+0x127/0x200 net/bluetooth/hci_conn.c:1536
>>>    hci_dev_do_close+0xb7b/0x1040 net/bluetooth/hci_core.c:1761
>>>    hci_unregister_dev+0x16d/0x1590 net/bluetooth/hci_core.c:3606
>>>    vhci_release+0x73/0xc0 drivers/bluetooth/hci_vhci.c:340
>>>    __fput+0x2f0/0x750 fs/file_table.c:281
>>>    task_work_run+0x137/0x1c0 kernel/task_work.c:135
>>>    exit_task_work include/linux/task_work.h:25 [inline]
>>>    do_exit+0x601/0x1f80 kernel/exit.c:805
>>>    do_group_exit+0x161/0x2d0 kernel/exit.c:903
>>>    __do_sys_exit_group+0x13/0x20 kernel/exit.c:914
>>>    __se_sys_exit_group+0x10/0x10 kernel/exit.c:912
>>>    __x64_sys_exit_group+0x37/0x40 kernel/exit.c:912
>>>    do_syscall_64+0x73/0xe0 arch/x86/entry/common.c:384
>>>    entry_SYSCALL_64_after_hwframe+0x44/0xa9
>>> RIP: 0033:0x444fe8
>>> Code: Bad RIP value.
>>> RSP: 002b:00007ffe96e46e68 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
>>> RAX: ffffffffffffffda RBX: 0000000000000001 RCX: 0000000000444fe8
>>> RDX: 0000000000000001 RSI: 000000000000003c RDI: 0000000000000001
>>> RBP: 00000000004ccdd0 R08: 00000000000000e7 R09: ffffffffffffffd0
>>> R10: 00007f5ee25cd700 R11: 0000000000000246 R12: 0000000000000001
>>> R13: 00000000006e0200 R14: 0000000000000000 R15: 0000000000000000
>>>
>>> Allocated by task 6821:
>>>    save_stack mm/kasan/common.c:48 [inline]
>>>    set_track mm/kasan/common.c:56 [inline]
>>>    __kasan_kmalloc+0x103/0x140 mm/kasan/common.c:494
>>>    kmem_cache_alloc_trace+0x234/0x300 mm/slab.c:3551
>>>    kmalloc include/linux/slab.h:555 [inline]
>>>    kzalloc include/linux/slab.h:669 [inline]
>>>    hci_chan_create+0x9a/0x270 net/bluetooth/hci_conn.c:1692
>>>    l2cap_conn_add+0x66/0xb00 net/bluetooth/l2cap_core.c:7699
>>>    l2cap_connect_cfm+0xdb/0x12b0 net/bluetooth/l2cap_core.c:8097
>>>    hci_connect_cfm include/net/bluetooth/hci_core.h:1340 [inline]
>>>    hci_remote_features_evt net/bluetooth/hci_event.c:3210 [inline]
>>>    hci_event_packet+0x1164c/0x18260 net/bluetooth/hci_event.c:6061
>>>    hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
>>>    process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>>>    worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>>>    kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>>>    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
>>>
>>> Freed by task 1530:
>>>    save_stack mm/kasan/common.c:48 [inline]
>>>    set_track mm/kasan/common.c:56 [inline]
>>>    kasan_set_free_info mm/kasan/common.c:316 [inline]
>>>    __kasan_slab_free+0x114/0x170 mm/kasan/common.c:455
>>>    __cache_free mm/slab.c:3426 [inline]
>>>    kfree+0x10a/0x220 mm/slab.c:3757
>>>    hci_disconn_loglink_complete_evt net/bluetooth/hci_event.c:4999 [inline]
>>>    hci_event_packet+0x304e/0x18260 net/bluetooth/hci_event.c:6188
>>>    hci_rx_work+0x236/0x9c0 net/bluetooth/hci_core.c:4705
>>>    process_one_work+0x789/0xfc0 kernel/workqueue.c:2269
>>>    worker_thread+0xaa4/0x1460 kernel/workqueue.c:2415
>>>    kthread+0x37e/0x3a0 drivers/block/aoe/aoecmd.c:1234
>>>    ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:293
>>>
>>> The buggy address belongs to the object at ffff8880a9591f00
>>>    which belongs to the cache kmalloc-128 of size 128
>>> The buggy address is located 24 bytes inside of
>>>    128-byte region [ffff8880a9591f00, ffff8880a9591f80)
>>> The buggy address belongs to the page:
>>> page:ffffea0002a56440 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff8880a9591800
>>> flags: 0xfffe0000000200(slab)
>>> raw: 00fffe0000000200 ffffea0002a5a648 ffffea00028a4a08 ffff8880aa400700
>>> raw: ffff8880a9591800 ffff8880a9591000 000000010000000a 0000000000000000
>>> page dumped because: kasan: bad access detected
>>>
>>> Memory state around the buggy address:
>>>    ffff8880a9591e00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>    ffff8880a9591e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>>> ffff8880a9591f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>>>                               ^
>>>    ffff8880a9591f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>>    ffff8880a9592000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>>> ==================================================================
>>>
>>>
>>> ---
>>> This report is generated by a bot. It may contain errors.
>>> See https://goo.gl/tpsmEJ for more information about syzbot.
>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>
>>> syzbot will keep track of this issue. See:
>>> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
>>> syzbot can test patches for this issue, for details see:
>>> https://goo.gl/tpsmEJ#testing-patches
>>>
>> -- 
>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/c2004663-e54a-7fbc-ee19-b2749549e2dd%40gmail.com.

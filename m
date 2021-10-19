Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE49432F19
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 09:14:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234304AbhJSHQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 03:16:42 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:38554 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233888AbhJSHQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 03:16:37 -0400
Received: by mail-io1-f71.google.com with SMTP id m7-20020a6b7b47000000b005dc506c5e04so12657619iop.5
        for <netdev@vger.kernel.org>; Tue, 19 Oct 2021 00:14:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=CXKVnUGmYGztxjAsNd+4B7UFAUm4UxN5Bde/sRxdqFg=;
        b=P8nkoFvgGY5wyF0UYvE8H3nFieniiipTOmORrcLe7jfQYUBY66KtmaoHo4V1APZ5Mt
         1rOzK4HSYNLKU8TZ4+9na9qiXJsQ7vW1mHN2/JXEV7H6vvnMsy1PXKoBBxaVtYnKAyFn
         2RKvohjwe17Pd5Ar+zdRXgOsfDo3J+cOaQAOD9p9GSqDCEpaLQSlxekstYD0BzmVpe73
         7SqoF3WU9G3rVN6SS7xr33Z7xotAeOE0fh1wmR9tDKvv8nnQsifVFqySn2di9555r4UI
         L1rvwW2hX25psmKrPP2sP+vw9D6Mycl4QOznbjH8AhpCP26QcdyM768JIm4+s7sZ/MZq
         dGjA==
X-Gm-Message-State: AOAM531GC82BubiG5asdcUYwpJd8CKA2qSVBjSf7BUBLm+hV6rLsaybV
        1FSx8RmHaEbH4+9iF9P3sRZXOArzSxHQfPh9bv5CcceAdTUU
X-Google-Smtp-Source: ABdhPJxGmij+PCT4D9LnfkRCqcQCHZWhCvbAaRvQu8+p+R5mmcMXkCsB75dXrbxeVEE2K9ajgSoxQCKBNb/1/ZRQBEolZqc32Idv
MIME-Version: 1.0
X-Received: by 2002:a02:ccf1:: with SMTP id l17mr2998059jaq.131.1634627664695;
 Tue, 19 Oct 2021 00:14:24 -0700 (PDT)
Date:   Tue, 19 Oct 2021 00:14:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000004b5a3705ceaf6908@google.com>
Subject: [syzbot] KASAN: use-after-free Read in cipso_v4_doi_add
From:   syzbot <syzbot+93dba5b91f0fed312cbd@syzkaller.appspotmail.com>
To:     davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        paul@paul-moore.com, syzkaller-bugs@googlegroups.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    26d657410983 MAINTAINERS: Update entry for the Stratix10 f..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=110cb258b00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1de5da8af5c2277d
dashboard link: https://syzkaller.appspot.com/bug?extid=93dba5b91f0fed312cbd
compiler:       Debian clang version 11.0.1-2, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+93dba5b91f0fed312cbd@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in cipso_v4_doi_search net/ipv4/cipso_ipv4.c:363 [inline]
BUG: KASAN: use-after-free in cipso_v4_doi_add+0x4e0/0x7c0 net/ipv4/cipso_ipv4.c:420
Read of size 4 at addr ffff88803f6a5a00 by task syz-executor.3/14359

CPU: 1 PID: 14359 Comm: syz-executor.3 Not tainted 5.15.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0x1dc/0x2d8 lib/dump_stack.c:106
 print_address_description+0x66/0x3e0 mm/kasan/report.c:256
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report+0x19a/0x1f0 mm/kasan/report.c:459
 cipso_v4_doi_search net/ipv4/cipso_ipv4.c:363 [inline]
 cipso_v4_doi_add+0x4e0/0x7c0 net/ipv4/cipso_ipv4.c:420
 smk_cipso_doi+0x2d3/0x580 security/smack/smackfs.c:706
 smk_write_doi+0x1ab/0x270 security/smack/smackfs.c:1615
 vfs_write+0x327/0xe90 fs/read_write.c:592
 ksys_write+0x18f/0x2c0 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f31447cba39
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f3141d41188 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f31448cef60 RCX: 00007f31447cba39
RDX: 0000000000000014 RSI: 0000000020000640 RDI: 0000000000000003
RBP: 00007f3144825c5f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffd5bc3df9f R14: 00007f3141d41300 R15: 0000000000022000

Allocated by task 14339:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc+0xdc/0x110 mm/kasan/common.c:513
 kasan_kmalloc include/linux/kasan.h:264 [inline]
 kmem_cache_alloc_trace+0x9f/0x310 mm/slub.c:3233
 kmalloc include/linux/slab.h:591 [inline]
 smk_cipso_doi+0x200/0x580 security/smack/smackfs.c:696
 smk_write_doi+0x1ab/0x270 security/smack/smackfs.c:1615
 vfs_write+0x327/0xe90 fs/read_write.c:592
 ksys_write+0x18f/0x2c0 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 14339:
 kasan_save_stack mm/kasan/common.c:38 [inline]
 kasan_set_track+0x4c/0x80 mm/kasan/common.c:46
 kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:360
 ____kasan_slab_free+0x10d/0x150 mm/kasan/common.c:366
 kasan_slab_free include/linux/kasan.h:230 [inline]
 slab_free_hook mm/slub.c:1700 [inline]
 slab_free_freelist_hook+0x129/0x1a0 mm/slub.c:1725
 slab_free mm/slub.c:3483 [inline]
 kfree+0xcf/0x2f0 mm/slub.c:4543
 smk_cipso_doi+0x3b7/0x580
 smk_write_doi+0x1ab/0x270 security/smack/smackfs.c:1615
 vfs_write+0x327/0xe90 fs/read_write.c:592
 ksys_write+0x18f/0x2c0 fs/read_write.c:647
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88803f6a5a00
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 0 bytes inside of
 64-byte region [ffff88803f6a5a00, ffff88803f6a5a40)
The buggy address belongs to the page:
page:ffffea0000fda940 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x3f6a5
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea0000866240 000000170000000d ffff888011041640
raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY), pid 6522, ts 209857791495, free_ts 209857731843
 prep_new_page mm/page_alloc.c:2424 [inline]
 get_page_from_freelist+0x779/0xa30 mm/page_alloc.c:4153
 __alloc_pages+0x255/0x580 mm/page_alloc.c:5375
 alloc_slab_page mm/slub.c:1763 [inline]
 allocate_slab+0xcc/0x4d0 mm/slub.c:1900
 new_slab mm/slub.c:1963 [inline]
 ___slab_alloc+0x41e/0xc40 mm/slub.c:2994
 __slab_alloc mm/slub.c:3081 [inline]
 slab_alloc_node mm/slub.c:3172 [inline]
 kmem_cache_alloc_node_trace+0x2c4/0x350 mm/slub.c:3256
 kmalloc_node include/linux/slab.h:609 [inline]
 kzalloc_node include/linux/slab.h:732 [inline]
 __get_vm_area_node+0x13a/0x2f0 mm/vmalloc.c:2416
 __vmalloc_node_range+0xe3/0x890 mm/vmalloc.c:3010
 __vmalloc_node mm/vmalloc.c:3069 [inline]
 vzalloc+0x75/0x80 mm/vmalloc.c:3139
 alloc_counters+0xd2/0x800 net/ipv6/netfilter/ip6_tables.c:817
 copy_entries_to_user net/ipv6/netfilter/ip6_tables.c:839 [inline]
 get_entries net/ipv6/netfilter/ip6_tables.c:1041 [inline]
 do_ip6t_get_ctl+0xf57/0x1f40 net/ipv6/netfilter/ip6_tables.c:1672
 nf_getsockopt+0x2ab/0x2d0 net/netfilter/nf_sockopt.c:116
 ipv6_getsockopt+0x4ae/0x3f30 net/ipv6/ipv6_sockglue.c:1486
 __sys_getsockopt+0x29f/0x560 net/socket.c:2220
 __do_sys_getsockopt net/socket.c:2235 [inline]
 __se_sys_getsockopt net/socket.c:2232 [inline]
 __x64_sys_getsockopt+0xb1/0xc0 net/socket.c:2232
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1338 [inline]
 free_pcp_prepare+0xc29/0xd20 mm/page_alloc.c:1389
 free_unref_page_prepare mm/page_alloc.c:3315 [inline]
 free_unref_page+0x7d/0x580 mm/page_alloc.c:3394
 __vunmap+0x926/0xa70 mm/vmalloc.c:2621
 copy_entries_to_user net/ipv6/netfilter/ip6_tables.c:884 [inline]
 get_entries net/ipv6/netfilter/ip6_tables.c:1041 [inline]
 do_ip6t_get_ctl+0x186d/0x1f40 net/ipv6/netfilter/ip6_tables.c:1672
 nf_getsockopt+0x2ab/0x2d0 net/netfilter/nf_sockopt.c:116
 ipv6_getsockopt+0x4ae/0x3f30 net/ipv6/ipv6_sockglue.c:1486
 __sys_getsockopt+0x29f/0x560 net/socket.c:2220
 __do_sys_getsockopt net/socket.c:2235 [inline]
 __se_sys_getsockopt net/socket.c:2232 [inline]
 __x64_sys_getsockopt+0xb1/0xc0 net/socket.c:2232
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x44/0xd0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88803f6a5900: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88803f6a5980: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>ffff88803f6a5a00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                   ^
 ffff88803f6a5a80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88803f6a5b00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
==================================================================


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

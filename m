Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 112EE3CF5B9
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 10:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhGTH0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 03:26:19 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:36500 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbhGTHZm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Jul 2021 03:25:42 -0400
Received: by mail-il1-f197.google.com with SMTP id j13-20020a056e02218db02902141528bc7cso8482071ila.3
        for <netdev@vger.kernel.org>; Tue, 20 Jul 2021 01:06:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=RSoxm6kbkunXbFnv/eDw4UxonYNCbvrRW5kEO1iiWmI=;
        b=fe8ysxnNezw/oAVSVb7UfRtqNG/pXUnZg55omBi0zDgmdl08DBpPcQW+jkyn16KOo6
         u4suYwt5XZbU6gtIEBAvXJ5VpKUfNSkMsNThGNhB+V58fnNkXRWA7R834zMBqnbJndNk
         zK9V8fpq9t8T/mjl59Zg3DBQYpfgWFxXy8ZB9SEf1OGv84XqfDvxBn34/zk3NJXFYe3d
         uc4YdDl35NzAvYqxoakqmgt0zbDSPCTkbBA5n/PRYP/3l7VR6cKTZmRAPSniuWFgS0H0
         vd+ywyDVemtLl7LI/JRajTjpyV2cCfuKJ8H3o+CFPo24u/Dkez5XeA74f+fWFLTYyjxd
         laHg==
X-Gm-Message-State: AOAM532i2lnIBfmMuG96fUen8O+XytPSFL19FqCPnOyU27tcwK3r/17K
        Zek18kbI152zXNBpmE9Ccxi6tplXbON7sMlZ8W9qredmAm5m
X-Google-Smtp-Source: ABdhPJzAQmEztfocHppkmQFjEKtKhxqrsSkrwdml7rWc+k0+hYvhefyfv4m6HFR/TS7D6GiMDrgNhLmz8/F/mSjiLC/TpoWZNdgY
MIME-Version: 1.0
X-Received: by 2002:a92:c524:: with SMTP id m4mr19246707ili.42.1626768380973;
 Tue, 20 Jul 2021 01:06:20 -0700 (PDT)
Date:   Tue, 20 Jul 2021 01:06:20 -0700
In-Reply-To: <000000000000a0982305c6e5c9f5@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000007adfd505c78987d1@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in sctp_auth_shkey_hold
From:   syzbot <syzbot+b774577370208727d12b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, hdanton@sina.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        lucien.xin@gmail.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org, nhorman@tuxdriver.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    0d6835ffe50c net: phy: Fix data type in DP83822 dp8382x_di..
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15b3f6f2300000
kernel config:  https://syzkaller.appspot.com/x/.config?x=da140227e4f25b17
dashboard link: https://syzkaller.appspot.com/bug?extid=b774577370208727d12b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11f6055c300000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=162a9040300000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+b774577370208727d12b@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:111 [inline]
BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
BUG: KASAN: use-after-free in sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
Write of size 4 at addr ffff888027eb5018 by task syz-executor843/8468

CPU: 1 PID: 8468 Comm: syz-executor843 Not tainted 5.14.0-rc1-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
 print_address_description.constprop.0.cold+0x6c/0x309 mm/kasan/report.c:233
 __kasan_report mm/kasan/report.c:419 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:436
 check_region_inline mm/kasan/generic.c:183 [inline]
 kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
 instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
 atomic_fetch_add_relaxed include/asm-generic/atomic-instrumented.h:111 [inline]
 __refcount_add include/linux/refcount.h:193 [inline]
 __refcount_inc include/linux/refcount.h:250 [inline]
 refcount_inc include/linux/refcount.h:267 [inline]
 sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
 sctp_set_owner_w net/sctp/socket.c:131 [inline]
 sctp_sendmsg_to_asoc+0x152e/0x2180 net/sctp/socket.c:1865
 sctp_sendmsg+0x103b/0x1d30 net/sctp/socket.c:2027
 inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:821
 sock_sendmsg_nosec net/socket.c:703 [inline]
 sock_sendmsg+0xcf/0x120 net/socket.c:723
 __sys_sendto+0x21c/0x320 net/socket.c:2019
 __do_sys_sendto net/socket.c:2031 [inline]
 __se_sys_sendto net/socket.c:2027 [inline]
 __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2027
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43efe9
Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff191e50c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0100000000000000 RCX: 000000000043efe9
RDX: 000000000000ffa0 RSI: 0000000020000140 RDI: 0000000000000003
RBP: 0000000000402fd0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000403060
R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488

Allocated by task 8468:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:46 [inline]
 set_alloc_info mm/kasan/common.c:434 [inline]
 ____kasan_kmalloc mm/kasan/common.c:513 [inline]
 ____kasan_kmalloc mm/kasan/common.c:472 [inline]
 __kasan_kmalloc+0x9b/0xd0 mm/kasan/common.c:522
 kmalloc include/linux/slab.h:591 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 sctp_auth_shkey_create+0x85/0x1f0 net/sctp/auth.c:84
 sctp_auth_asoc_copy_shkeys+0x1e8/0x350 net/sctp/auth.c:363
 sctp_association_init net/sctp/associola.c:257 [inline]
 sctp_association_new+0x1829/0x2250 net/sctp/associola.c:298
 sctp_connect_new_asoc+0x1ac/0x770 net/sctp/socket.c:1088
 __sctp_connect+0x3d0/0xc30 net/sctp/socket.c:1194
 sctp_connect net/sctp/socket.c:4804 [inline]
 sctp_inet_connect+0x15e/0x200 net/sctp/socket.c:4819
 __sys_connect_file+0x155/0x1a0 net/socket.c:1879
 __sys_connect+0x161/0x190 net/socket.c:1896
 __do_sys_connect net/socket.c:1906 [inline]
 __se_sys_connect net/socket.c:1903 [inline]
 __x64_sys_connect+0x6f/0xb0 net/socket.c:1903
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 8468:
 kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
 kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:360
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free mm/kasan/common.c:328 [inline]
 __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:374
 kasan_slab_free include/linux/kasan.h:229 [inline]
 slab_free_hook mm/slub.c:1650 [inline]
 slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1675
 slab_free mm/slub.c:3235 [inline]
 kfree+0xeb/0x650 mm/slub.c:4295
 sctp_auth_shkey_destroy net/sctp/auth.c:101 [inline]
 sctp_auth_shkey_release+0x100/0x160 net/sctp/auth.c:107
 sctp_auth_set_key+0x508/0x6d0 net/sctp/auth.c:862
 sctp_setsockopt_auth_key net/sctp/socket.c:3643 [inline]
 sctp_setsockopt+0x4919/0xa5e0 net/sctp/socket.c:4682
 __sys_setsockopt+0x2db/0x610 net/socket.c:2159
 __do_sys_setsockopt net/socket.c:2170 [inline]
 __se_sys_setsockopt net/socket.c:2167 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2167
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff888027eb5000
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 24 bytes inside of
 32-byte region [ffff888027eb5000, ffff888027eb5020)
The buggy address belongs to the page:
page:ffffea00009fad40 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x27eb5
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffffea000056e240 0000000d0000000d ffff888010841500
raw: 0000000000000000 0000000080400040 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12c40(GFP_NOFS|__GFP_NOWARN|__GFP_NORETRY), pid 1, ts 15828671942, free_ts 14464854502
 prep_new_page mm/page_alloc.c:2433 [inline]
 get_page_from_freelist+0xa72/0x2f80 mm/page_alloc.c:4166
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5374
 alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2244
 alloc_slab_page mm/slub.c:1713 [inline]
 allocate_slab+0x32b/0x4c0 mm/slub.c:1853
 new_slab mm/slub.c:1916 [inline]
 new_slab_objects mm/slub.c:2662 [inline]
 ___slab_alloc+0x4ba/0x820 mm/slub.c:2825
 __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2865
 slab_alloc_node mm/slub.c:2947 [inline]
 slab_alloc mm/slub.c:2989 [inline]
 __kmalloc+0x312/0x330 mm/slub.c:4133
 kmalloc include/linux/slab.h:596 [inline]
 kzalloc include/linux/slab.h:721 [inline]
 tomoyo_encode2.part.0+0xe9/0x3a0 security/tomoyo/realpath.c:45
 tomoyo_encode2 security/tomoyo/realpath.c:31 [inline]
 tomoyo_encode+0x28/0x50 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x186/0x620 security/tomoyo/realpath.c:288
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_check_open_permission+0x272/0x380 security/tomoyo/file.c:771
 tomoyo_file_open security/tomoyo/tomoyo.c:311 [inline]
 tomoyo_file_open+0xa3/0xd0 security/tomoyo/tomoyo.c:306
 security_file_open+0x52/0x4f0 security/security.c:1633
 do_dentry_open+0x353/0x11d0 fs/open.c:813
 do_open fs/namei.c:3374 [inline]
 path_openat+0x1c23/0x27f0 fs/namei.c:3507
 do_filp_open+0x1aa/0x400 fs/namei.c:3534
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1343 [inline]
 free_pcp_prepare+0x2c5/0x780 mm/page_alloc.c:1394
 free_unref_page_prepare mm/page_alloc.c:3329 [inline]
 free_unref_page+0x19/0x690 mm/page_alloc.c:3408
 kasan_depopulate_vmalloc_pte+0x5c/0x70 mm/kasan/shadow.c:375
 apply_to_pte_range mm/memory.c:2532 [inline]
 apply_to_pmd_range mm/memory.c:2576 [inline]
 apply_to_pud_range mm/memory.c:2612 [inline]
 apply_to_p4d_range mm/memory.c:2648 [inline]
 __apply_to_page_range+0x694/0x1080 mm/memory.c:2682
 kasan_release_vmalloc+0xa7/0xc0 mm/kasan/shadow.c:485
 __purge_vmap_area_lazy+0x8f9/0x1c50 mm/vmalloc.c:1670
 _vm_unmap_aliases.part.0+0x3f0/0x500 mm/vmalloc.c:2073
 _vm_unmap_aliases mm/vmalloc.c:2047 [inline]
 vm_unmap_aliases+0x47/0x50 mm/vmalloc.c:2096
 change_page_attr_set_clr+0x241/0x500 arch/x86/mm/pat/set_memory.c:1740
 change_page_attr_set arch/x86/mm/pat/set_memory.c:1790 [inline]
 set_memory_nx+0xb2/0x110 arch/x86/mm/pat/set_memory.c:1938
 free_init_pages+0x73/0xc0 arch/x86/mm/init.c:887
 kernel_init+0x24/0x1d0 init/main.c:1491
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:295

Memory state around the buggy address:
 ffff888027eb4f00: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
 ffff888027eb4f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888027eb5000: fa fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
                            ^
 ffff888027eb5080: fb fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
 ffff888027eb5100: fb fb fb fb fc fc fc fc fb fb fb fb fc fc fc fc
==================================================================


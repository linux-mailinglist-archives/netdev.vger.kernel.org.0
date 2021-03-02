Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA5032B37F
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352671AbhCCEAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383235AbhCBLFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 06:05:25 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE34C06178B
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 03:03:36 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id b3so14372201qtj.10
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 03:03:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=J3ikdx4bgEoWr60N8YJM/UFK+GXVchd7MQyf1W8dD6Y=;
        b=rCOHlbYVsUFJ5jCO915/sp407cuKNrvUL5Fhj1ov/u19LqijjyUtbQGTcECLpgPmD2
         R4rDKNpn+BLxS1XWWAGP10LmUD01/8SbCQ4LWrOVgwp3YJp36HHLDapkHHKN9AR4E1Pt
         HV6rFiCokKvEWqIjuBVlBRCM4zK70bWgSCN+6bf5UgEbIlGBBTubyoYHN32vsR3iSF/m
         VzVwjKNp5Yoz6ti6Z1wBqBRQMNWf2E7+P18FTqK6s7nhpFp0Cfjd7v0SAxX48WNLdNba
         71P97h7tr5Dai8AcVnn9gNBqEgSF805R0Ip9EebHG3sRm2fZmd4iqC5C7IgzUArTO7jl
         qr+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=J3ikdx4bgEoWr60N8YJM/UFK+GXVchd7MQyf1W8dD6Y=;
        b=VBH83F9O4bCiil9Yhp/C8geJoYakiF2aOKbbKAGCGj5W7r07XNEzUaxihM7P/n86pj
         U+CwpfIqyeA8Kcppzp8cWlc91psEdUQ3XnJ7p/S9y8G9CCfaHdNThPrfY5lw5HSwEb9A
         V7oziNpQNtf16Akjw4o6BJF+80Sf7nU5v4mYlOzDiJtrvZZ5HxnAC2czNHuoCHbRrcVZ
         0G/tPvTt048G+klVZE4CgWTpUVLPtfu4879rNn54QAxH142cccFCreqRvIk/U0T6YaJX
         aSHKPyzELQRJ28z6OV5jGux1ZeBLGE3FIHqXZlfV6BNOOtq5p7W4O4HSbuCr9h8IkWhG
         tOtQ==
X-Gm-Message-State: AOAM5315yZjF6JDEvGkV0a4LKB3udnUmKmdq2DQeIJ6n3ZW3hQultdoM
        O+zJVS6l22WRuJkkgh0SHhfJ2EsJ5ts74O7H5rPyOA==
X-Google-Smtp-Source: ABdhPJzWywaMfVhojw89uFC60fs7zk9QZs52P/3Dp2N/80gWfTXl+6FdInmMZMcHcbq7Oj5F02J73116l8slUYX8r+g=
X-Received: by 2002:a05:622a:c9:: with SMTP id p9mr16969500qtw.337.1614683015042;
 Tue, 02 Mar 2021 03:03:35 -0800 (PST)
MIME-Version: 1.0
References: <0000000000006305c005bc8ba7f0@google.com>
In-Reply-To: <0000000000006305c005bc8ba7f0@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Tue, 2 Mar 2021 12:03:24 +0100
Message-ID: <CACT4Y+YFtUHzWcU3VBvxsdq-V_4hN_ZDs4riZiHPt4f0cy8ryA@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in cipso_v4_genopt
To:     syzbot <syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com>
Cc:     David Miller <davem@davemloft.net>, dsahern@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 2, 2021 at 12:01 PM syzbot
<syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    5695e516 Merge tag 'io_uring-worker.v3-2021-02-25' of git:..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=168c27f2d00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=e33ab2de74f48295
> dashboard link: https://syzkaller.appspot.com/bug?extid=9ec037722d2603a9f52e
> compiler:       Debian clang version 11.0.1-2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+9ec037722d2603a9f52e@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in cipso_v4_genopt+0x1078/0x1700 net/ipv4/cipso_ipv4.c:1784
> Read of size 1 at addr ffff888017bba510 by task kworker/1:3/4821
>
> CPU: 1 PID: 4821 Comm: kworker/1:3 Not tainted 5.11.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Workqueue: events p9_write_work
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x125/0x19e lib/dump_stack.c:120
>  print_address_description+0x5f/0x3a0 mm/kasan/report.c:232
>  __kasan_report mm/kasan/report.c:399 [inline]
>  kasan_report+0x15e/0x210 mm/kasan/report.c:416
>  cipso_v4_genopt+0x1078/0x1700 net/ipv4/cipso_ipv4.c:1784
>  cipso_v4_sock_setattr+0x7c/0x460 net/ipv4/cipso_ipv4.c:1866
>  netlbl_sock_setattr+0x28e/0x2f0 net/netlabel/netlabel_kapi.c:995
>  smack_netlbl_add security/smack/smack_lsm.c:2404 [inline]
>  smack_socket_post_create+0x13b/0x280 security/smack/smack_lsm.c:2774
>  security_socket_post_create+0x6f/0xd0 security/security.c:2122
>  __sock_create+0x62f/0x8c0 net/socket.c:1424
>  udp_sock_create4+0x73/0x5f0 net/ipv4/udp_tunnel_core.c:20
>  udp_sock_create include/net/udp_tunnel.h:59 [inline]
>  rxrpc_open_socket net/rxrpc/local_object.c:129 [inline]
>  rxrpc_lookup_local+0xd54/0x14d0 net/rxrpc/local_object.c:226
>  rxrpc_sendmsg+0x481/0x8a0 net/rxrpc/af_rxrpc.c:541
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg net/socket.c:674 [inline]
>  sock_write_iter+0x31a/0x470 net/socket.c:1001
>  __kernel_write+0x52c/0x990 fs/read_write.c:550
>  kernel_write+0x63/0x80 fs/read_write.c:579
>  p9_fd_write net/9p/trans_fd.c:430 [inline]
>  p9_write_work+0x5ed/0xd20 net/9p/trans_fd.c:481
>  process_one_work+0x789/0xfd0 kernel/workqueue.c:2275
>  worker_thread+0xac1/0x1300 kernel/workqueue.c:2421
>  kthread+0x39a/0x3c0 kernel/kthread.c:292
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> Allocated by task 4802:
>  kasan_save_stack mm/kasan/common.c:38 [inline]
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:427 [inline]
>  ____kasan_kmalloc+0xc2/0xf0 mm/kasan/common.c:506
>  kasan_kmalloc include/linux/kasan.h:233 [inline]
>  __kmalloc+0xb4/0x370 mm/slub.c:4055
>  kmalloc include/linux/slab.h:559 [inline]
>  kzalloc include/linux/slab.h:684 [inline]
>  tomoyo_encode2+0x25a/0x560 security/tomoyo/realpath.c:45
>  tomoyo_encode security/tomoyo/realpath.c:80 [inline]
>  tomoyo_realpath_from_path+0x5c3/0x610 security/tomoyo/realpath.c:288
>  tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
>  tomoyo_path_perm+0x191/0x570 security/tomoyo/file.c:822
>  security_inode_getattr+0xc0/0x140 security/security.c:1288
>  vfs_getattr fs/stat.c:131 [inline]
>  vfs_statx+0xe8/0x320 fs/stat.c:199
>  vfs_fstatat fs/stat.c:217 [inline]
>  vfs_lstat include/linux/fs.h:3240 [inline]
>  __do_sys_newlstat fs/stat.c:372 [inline]
>  __se_sys_newlstat fs/stat.c:366 [inline]
>  __x64_sys_newlstat+0x81/0xd0 fs/stat.c:366
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Freed by task 4802:
>  kasan_save_stack mm/kasan/common.c:38 [inline]
>  kasan_set_track+0x3d/0x70 mm/kasan/common.c:46
>  kasan_set_free_info+0x1f/0x40 mm/kasan/generic.c:357
>  ____kasan_slab_free+0x100/0x140 mm/kasan/common.c:360
>  kasan_slab_free include/linux/kasan.h:199 [inline]
>  slab_free_hook mm/slub.c:1562 [inline]
>  slab_free_freelist_hook+0x13a/0x200 mm/slub.c:1600
>  slab_free mm/slub.c:3161 [inline]
>  kfree+0xcf/0x2b0 mm/slub.c:4213
>  tomoyo_path_perm+0x447/0x570 security/tomoyo/file.c:842
>  security_inode_getattr+0xc0/0x140 security/security.c:1288
>  vfs_getattr fs/stat.c:131 [inline]
>  vfs_statx+0xe8/0x320 fs/stat.c:199
>  vfs_fstatat fs/stat.c:217 [inline]
>  vfs_lstat include/linux/fs.h:3240 [inline]
>  __do_sys_newlstat fs/stat.c:372 [inline]
>  __se_sys_newlstat fs/stat.c:366 [inline]
>  __x64_sys_newlstat+0x81/0xd0 fs/stat.c:366
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Last potentially related work creation:
>  kasan_save_stack+0x27/0x50 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xee/0x120 mm/kasan/generic.c:345
>  __call_rcu kernel/rcu/tree.c:3039 [inline]
>  call_rcu+0x12f/0x8a0 kernel/rcu/tree.c:3114
>  cipso_v4_doi_remove+0x2e2/0x310 net/ipv4/cipso_ipv4.c:531
>  netlbl_cipsov4_remove+0x219/0x390 net/netlabel/netlabel_cipso_v4.c:715
>  genl_family_rcv_msg_doit net/netlink/genetlink.c:739 [inline]
>  genl_family_rcv_msg net/netlink/genetlink.c:783 [inline]
>  genl_rcv_msg+0xe4e/0x1280 net/netlink/genetlink.c:800
>  netlink_rcv_skb+0x190/0x3a0 net/netlink/af_netlink.c:2502
>  genl_rcv+0x24/0x40 net/netlink/genetlink.c:811
>  netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>  netlink_unicast+0x786/0x940 net/netlink/af_netlink.c:1338
>  netlink_sendmsg+0x9ae/0xd50 net/netlink/af_netlink.c:1927
>  sock_sendmsg_nosec net/socket.c:654 [inline]
>  sock_sendmsg net/socket.c:674 [inline]
>  ____sys_sendmsg+0x519/0x800 net/socket.c:2350
>  ___sys_sendmsg net/socket.c:2404 [inline]
>  __sys_sendmsg+0x2bf/0x370 net/socket.c:2433
>  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The buggy address belongs to the object at ffff888017bba500
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 16 bytes inside of
>  64-byte region [ffff888017bba500, ffff888017bba540)
> The buggy address belongs to the page:
> page:000000004f188e85 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x17bba
> flags: 0xfff00000000200(slab)
> raw: 00fff00000000200 dead000000000100 dead000000000122 ffff888010841640
> raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
>
> Memory state around the buggy address:
>  ffff888017bba400: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
>  ffff888017bba480: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
> >ffff888017bba500: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>                          ^
>  ffff888017bba580: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
>  ffff888017bba600: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
> ==================================================================


Besides these 2 crashes, we've also seen one on a 4.19 based kernel, see below.
Based on the reports with mismatching stacks, it looks like
cipso_v4_genopt is doing some kind of wild pointer access (uninit
pointer?).


netlink: 'syz-executor.0': attribute type 4 has an invalid length.
==================================================================
BUG: KASAN: use-after-free in
cipso_v4_genopt.part.0.constprop.0+0x11f3/0x1400
net/ipv4/cipso_ipv4.c:1795
Read of size 1 at addr ffff8881f41bb790 by task syz-executor.1/7116

CPU: 0 PID: 7116 Comm: syz-executor.1 Not tainted
4.19.121-syzkaller-00217-g3b679299c55f #0
Hardware name: Google Google Compute Engine/Google Compute Engine,
BIOS Google 01/01/2011
Call Trace:
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x10d/0x199 lib/dump_stack.c:118
 print_address_description.cold+0x54/0x204 mm/kasan/report.c:256
 kasan_report_error mm/kasan/report.c:354 [inline]
 kasan_report.part.0.cold+0x187/0x2db mm/kasan/report.c:412
 cipso_v4_genopt.part.0.constprop.0+0x11f3/0x1400 net/ipv4/cipso_ipv4.c:1795
 cipso_v4_genopt net/ipv4/cipso_ipv4.c:1786 [inline]
 cipso_v4_sock_setattr+0x7b/0x450 net/ipv4/cipso_ipv4.c:1877
 netlbl_sock_setattr+0x1cd/0x2a0 net/netlabel/netlabel_kapi.c:1003
 smack_netlabel+0x13a/0x180 security/smack/smack_lsm.c:2511
 smack_socket_post_create security/smack/smack_lsm.c:2852 [inline]
 smack_socket_post_create+0xd0/0x190 security/smack/smack_lsm.c:2830
 security_socket_post_create+0x69/0xc0 security/security.c:1381
 __sock_create+0x5ba/0x740 net/socket.c:1292
 sock_create net/socket.c:1316 [inline]
 __sys_socket+0xf4/0x200 net/socket.c:1346
 __do_sys_socket net/socket.c:1355 [inline]
 __se_sys_socket net/socket.c:1353 [inline]
 __x64_sys_socket+0x74/0xb0 net/socket.c:1353
 do_syscall_64+0xbc/0x130 arch/x86/entry/common.c:293
 entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x465ef9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48
89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d
01 f0 ff ff 73 01 c3 48 c7 c1 bc ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4fc3392188 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
RAX: ffffffffffffffda RBX: 000000000056bf60 RCX: 0000000000465ef9
RDX: 0000000000000002 RSI: 0000000000000003 RDI: 0000040000000002
RBP: 00000000004bd8bc R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000056bf60
R13: 00007ffdccf28b3f R14: 00007f4fc3392300 R15: 0000000000022000

Allocated by task 397:
 set_track mm/kasan/kasan.c:460 [inline]
 kasan_kmalloc+0xc2/0xe0 mm/kasan/kasan.c:553
 kmem_cache_alloc_node_trace+0x129/0x210 mm/slub.c:2769
 kmalloc_node include/linux/slab.h:553 [inline]
 kzalloc_node include/linux/slab.h:720 [inline]
 __get_vm_area_node+0x12d/0x3b0 mm/vmalloc.c:1394
 __vmalloc_node_range mm/vmalloc.c:1748 [inline]
 __vmalloc_node mm/vmalloc.c:1804 [inline]
 __vmalloc_node_flags mm/vmalloc.c:1818 [inline]
 vzalloc+0xeb/0x1a0 mm/vmalloc.c:1857
 do_ipt_get_ctl+0x4f2/0x8e0 net/ipv4/netfilter/ip_tables.c:803
 nf_sockopt net/netfilter/nf_sockopt.c:104 [inline]
 nf_getsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:122
 ip_getsockopt net/ipv4/ip_sockglue.c:1574 [inline]
 ip_getsockopt+0x16c/0x1c0 net/ipv4/ip_sockglue.c:1554
 tcp_getsockopt+0x8b/0xd0 net/ipv4/tcp.c:3605
 __sys_getsockopt+0x13a/0x220 net/socket.c:1938
 __do_sys_getsockopt net/socket.c:1949 [inline]
 __se_sys_getsockopt net/socket.c:1946 [inline]
 __x64_sys_getsockopt+0xbf/0x160 net/socket.c:1946
 do_syscall_64+0xbc/0x130 arch/x86/entry/common.c:293
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

Freed by task 397:
 set_track mm/kasan/kasan.c:460 [inline]
 __kasan_slab_free+0x11f/0x160 mm/kasan/kasan.c:521
 slab_free_hook mm/slub.c:1371 [inline]
 slab_free_freelist_hook+0x5a/0x110 mm/slub.c:1398
 slab_free mm/slub.c:2963 [inline]
 kfree+0xc7/0x2a0 mm/slub.c:3928
 __vunmap+0x3da/0x550 mm/vmalloc.c:1537
 vfree+0x6a/0x100 mm/vmalloc.c:1598
 copy_entries_to_user net/ipv4/netfilter/ip_tables.c:870 [inline]
 get_entries net/ipv4/netfilter/ip_tables.c:1027 [inline]
 do_ipt_get_ctl+0x6ed/0x8e0 net/ipv4/netfilter/ip_tables.c:1703
 nf_sockopt net/netfilter/nf_sockopt.c:104 [inline]
 nf_getsockopt+0x77/0xd0 net/netfilter/nf_sockopt.c:122
 ip_getsockopt net/ipv4/ip_sockglue.c:1574 [inline]
 ip_getsockopt+0x16c/0x1c0 net/ipv4/ip_sockglue.c:1554
 tcp_getsockopt+0x8b/0xd0 net/ipv4/tcp.c:3605
 __sys_getsockopt+0x13a/0x220 net/socket.c:1938
 __do_sys_getsockopt net/socket.c:1949 [inline]
 __se_sys_getsockopt net/socket.c:1946 [inline]
 __x64_sys_getsockopt+0xbf/0x160 net/socket.c:1946
 do_syscall_64+0xbc/0x130 arch/x86/entry/common.c:293
 entry_SYSCALL_64_after_hwframe+0x49/0xbe

The buggy address belongs to the object at ffff8881f41bb780
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 16 bytes inside of
 64-byte region [ffff8881f41bb780, ffff8881f41bb7c0)
The buggy address belongs to the page:
page:ffffea0007d06ec0 count:1 mapcount:0 mapping:ffff8881f6c03600 index:0x0
flags: 0x200000000000100(slab)
raw: 0200000000000100 dead000000000100 dead000000000200 ffff8881f6c03600
raw: 0000000000000000 00000000002a002a 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected

Memory state around the buggy address:
 ffff8881f41bb680: 00 fc fc fc fc fc fc fc fb fb fb fb fb fb fb fb
 ffff8881f41bb700: fc fc fc fc 00 00 00 00 00 fc fc fc fc fc fc fc
>ffff8881f41bb780: fb fb fb fb fb fb fb fb fc fc fc fc 00 00 00 00
                         ^
 ffff8881f41bb800: 00 00 fc fc fc fc fc fc 00 00 00 00 00 00 fc fc
 ffff8881f41bb880: fc fc fc fc 00 00 00 00 00 00 fc fc fc fc fc fc
==================================================================

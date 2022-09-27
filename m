Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF335ED0A1
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 00:59:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231773AbiI0W7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 18:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiI0W7S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 18:59:18 -0400
Received: from mail-oa1-x36.google.com (mail-oa1-x36.google.com [IPv6:2001:4860:4864:20::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF450EF090;
        Tue, 27 Sep 2022 15:59:16 -0700 (PDT)
Received: by mail-oa1-x36.google.com with SMTP id 586e51a60fabf-13175b79807so5149610fac.9;
        Tue, 27 Sep 2022 15:59:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=ZWhbXo4LHHOgqEY3MQYQGmP0WVsbYvhjsz/W36gZzVI=;
        b=JrkkY9/wWFIvfQ0dvTDYi6mrEW1SSO1/kcDOUvFeC9xZrG9+kTDhSIuFGxX7OfYA+f
         KdCMe3aU52bro9i+vmWl72sfBnHMW6+b3IoP4DdmPOfzVqmq9Db8V4g7sf8hCujrgKfA
         qukyVD3NIHEq3cGlxnfPOrmhiU4O0b/DCGk9UIrMJDID5clZTQ5ZiEfDGxp83Gakr0Gq
         RkYKzMgkS2jaqOvefEIwTV6k3Kafn7PKNyAhdXlpERAFxDxj9yZx3SZ3RjEa6PWgBXeq
         CvEWR2bdn3+n4YDbvj8LfJeYXUvZwUEkC6Bcdi1Lx8nCzKa2dcultFN16124x5tEu77a
         knqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=ZWhbXo4LHHOgqEY3MQYQGmP0WVsbYvhjsz/W36gZzVI=;
        b=7OE5nv7LpsE48J3NJ1k4G2VO1UwFJcHEqMtLn43MorLbtnn39KiNeKYTha9HYBoed0
         RvtsrMarTDUWn4A74OVuCkujCYBC6rWYvo6iqYba7d/p9VwiiE/ZCpO2yRpGWcrFMf8C
         tLnF2uZeW+nXiLId+l2qZXORjisJk5m2CGibve63PkHup3590lQQcDav/qrxQMnASuQv
         EPODMIonYj/5lxVaQOSOi/GQrDk5R7OoNBP4xQ5d0UXdgZjJ4i3Wci/lv1DaBGoFlnax
         FOMQxWoD5j6YnwvbkRwg/3iTtiJXWBmx4GKo0MJ5R0o2pyifHhBlZwttrSuirNY4SFUU
         SWjg==
X-Gm-Message-State: ACrzQf1ws5KI3GCc8c8DB1F7coNEl5BSP3MWsm+1b9aQR3+EWuC8K5Ij
        UCM9U68Ie7e2qY5esn4mFNLwxDlIPjHe/LFiclk=
X-Google-Smtp-Source: AMsMyM5sS4jw0h2JbCUGtPHH2kVbGsiot79GdN1r7qbvIQMBDfUxHd3hBatAL8YCG7cbwtYxOlCxwNZyZa7TCQxI4Uc=
X-Received: by 2002:a05:6870:9614:b0:11d:3906:18fc with SMTP id
 d20-20020a056870961400b0011d390618fcmr3683600oaq.190.1664319555991; Tue, 27
 Sep 2022 15:59:15 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000212d3205e9984e12@google.com>
In-Reply-To: <000000000000212d3205e9984e12@google.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 27 Sep 2022 18:58:34 -0400
Message-ID: <CADvbK_csG9_6coaKE0hqnzRudhTi3BXOsaANGfH2QC1Cx8OO5w@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Write in sctp_auth_shkey_hold (2)
To:     syzbot <syzbot+a236dd8e9622ed8954a3@syzkaller.appspotmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, vyasevich@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 26, 2022 at 2:14 PM syzbot
<syzbot+a236dd8e9622ed8954a3@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    cb71b93c2dc3 Add linux-next specific files for 20220628
> git tree:       linux-next
> console+strace: https://syzkaller.appspot.com/x/log.txt?x=12e40342080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=badbc1adb2d582eb
> dashboard link: https://syzkaller.appspot.com/bug?extid=a236dd8e9622ed8954a3
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1689249a080000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1618ab1c080000
>
> Bisection is inconclusive: the issue happens on the oldest tested release.
>
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1155cda4080000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=1355cda4080000
> console output: https://syzkaller.appspot.com/x/log.txt?x=1555cda4080000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+a236dd8e9622ed8954a3@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
> BUG: KASAN: use-after-free in atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
> BUG: KASAN: use-after-free in __refcount_add include/linux/refcount.h:193 [inline]
> BUG: KASAN: use-after-free in __refcount_inc include/linux/refcount.h:250 [inline]
> BUG: KASAN: use-after-free in refcount_inc include/linux/refcount.h:267 [inline]
> BUG: KASAN: use-after-free in sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
> Write of size 4 at addr ffff88807cd4ad98 by task syz-executor284/3719
>
> CPU: 0 PID: 3719 Comm: syz-executor284 Not tainted 5.19.0-rc4-next-20220628-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 06/29/2022
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description mm/kasan/report.c:317 [inline]
>  print_report.cold+0x2ba/0x719 mm/kasan/report.c:433
>  kasan_report+0xbe/0x1f0 mm/kasan/report.c:495
>  check_region_inline mm/kasan/generic.c:183 [inline]
>  kasan_check_range+0x13d/0x180 mm/kasan/generic.c:189
>  instrument_atomic_read_write include/linux/instrumented.h:101 [inline]
>  atomic_fetch_add_relaxed include/linux/atomic/atomic-instrumented.h:116 [inline]
>  __refcount_add include/linux/refcount.h:193 [inline]
>  __refcount_inc include/linux/refcount.h:250 [inline]
>  refcount_inc include/linux/refcount.h:267 [inline]
>  sctp_auth_shkey_hold+0x22/0xa0 net/sctp/auth.c:112
>  sctp_set_owner_w net/sctp/socket.c:132 [inline]
>  sctp_sendmsg_to_asoc+0xbd5/0x1a20 net/sctp/socket.c:1863
>  sctp_sendmsg+0x1053/0x1d50 net/sctp/socket.c:2025
>  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:734
The call trace is very similar with the one fixed in:

commit 58acd10092268831e49de279446c314727101292
Author: Xin Long <lucien.xin@gmail.com>
Date:   Tue Jul 20 16:07:01 2021 -0400

    sctp: update active_key for asoc when old key is being replaced

It was caused by active_key not being updated.

"setsockopt$inet_sctp6_SCTP_AUTH_KEY(r0, 0x84, 0x17,
&(0x7f00000002c0)={0x0, 0x0, 0x1, "8b"}, 0x9) (fail_nth: 5)"

If the 5th failure is the one in sctp_auth_asoc_init_active_key(),
this same issue will be triggered.

I will prepare a fix to handle the error returned from
sctp_auth_asoc_init_active_key() in sctp_auth_set_key().

Thanks.


>  __sys_sendto+0x21a/0x320 net/socket.c:2116
>  __do_sys_sendto net/socket.c:2128 [inline]
>  __se_sys_sendto net/socket.c:2124 [inline]
>  __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2124
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7f9b40d281d9
> Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 a1 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f9b40cb52d8 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f9b40db04b0 RCX: 00007f9b40d281d9
> RDX: 0000000000000001 RSI: 0000000020000400 RDI: 0000000000000003
> RBP: 00007f9b40d7d5dc R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007f9b40cb52f0
> R13: 00007f9b40db04b8 R14: 0100000000000000 R15: 0000000000022000
>  </TASK>
>
> Allocated by task 3717:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:45 [inline]
>  set_alloc_info mm/kasan/common.c:436 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:515 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:474 [inline]
>  __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:524
>  kmalloc include/linux/slab.h:600 [inline]
>  kzalloc include/linux/slab.h:733 [inline]
>  sctp_auth_shkey_create+0x85/0x1f0 net/sctp/auth.c:84
>  sctp_auth_asoc_copy_shkeys+0x1e8/0x350 net/sctp/auth.c:363
>  sctp_association_init net/sctp/associola.c:257 [inline]
>  sctp_association_new+0x189e/0x2330 net/sctp/associola.c:298
>  sctp_connect_new_asoc+0x1ac/0x770 net/sctp/socket.c:1089
>  sctp_sendmsg_new_asoc net/sctp/socket.c:1691 [inline]
>  sctp_sendmsg+0x13d7/0x1d50 net/sctp/socket.c:1998
>  inet_sendmsg+0x99/0xe0 net/ipv4/af_inet.c:819
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  sock_sendmsg+0xcf/0x120 net/socket.c:734
>  __sys_sendto+0x21a/0x320 net/socket.c:2116
>  __do_sys_sendto net/socket.c:2128 [inline]
>  __se_sys_sendto net/socket.c:2124 [inline]
>  __x64_sys_sendto+0xdd/0x1b0 net/socket.c:2124
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> Freed by task 3720:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  kasan_set_track+0x21/0x30 mm/kasan/common.c:45
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
>  ____kasan_slab_free mm/kasan/common.c:366 [inline]
>  ____kasan_slab_free+0x166/0x1c0 mm/kasan/common.c:328
>  kasan_slab_free include/linux/kasan.h:200 [inline]
>  slab_free_hook mm/slub.c:1754 [inline]
>  slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1780
>  slab_free mm/slub.c:3534 [inline]
>  kfree+0xe2/0x4d0 mm/slub.c:4562
>  sctp_auth_shkey_destroy net/sctp/auth.c:101 [inline]
>  sctp_auth_shkey_release+0x100/0x160 net/sctp/auth.c:107
>  sctp_auth_set_key+0x443/0x960 net/sctp/auth.c:866
>  sctp_setsockopt_auth_key net/sctp/socket.c:3640 [inline]
>  sctp_setsockopt+0x4c33/0xa9a0 net/sctp/socket.c:4683
>  __sys_setsockopt+0x2d6/0x690 net/socket.c:2251
>  __do_sys_setsockopt net/socket.c:2262 [inline]
>  __se_sys_setsockopt net/socket.c:2259 [inline]
>  __x64_sys_setsockopt+0xba/0x150 net/socket.c:2259
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> The buggy address belongs to the object at ffff88807cd4ad80
>  which belongs to the cache kmalloc-32 of size 32
> The buggy address is located 24 bytes inside of
>  32-byte region [ffff88807cd4ad80, ffff88807cd4ada0)
>
> The buggy address belongs to the physical page:
> page:ffffea0001f35280 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x7cd4a
> flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000000200 0000000000000000 dead000000000122 ffff888011841500
> raw: 0000000000000000 0000000000400040 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12820(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY), pid 3653, tgid 3653 (kworker/1:6), ts 62971434672, free_ts 62952459810
>  prep_new_page mm/page_alloc.c:2535 [inline]
>  get_page_from_freelist+0x210d/0x3a30 mm/page_alloc.c:4282
>  __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5506
>  alloc_pages+0x1aa/0x310 mm/mempolicy.c:2280
>  alloc_slab_page mm/slub.c:1824 [inline]
>  allocate_slab+0x27e/0x3d0 mm/slub.c:1969
>  new_slab mm/slub.c:2029 [inline]
>  ___slab_alloc+0x89d/0xef0 mm/slub.c:3031
>  __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3118
>  slab_alloc_node mm/slub.c:3209 [inline]
>  slab_alloc mm/slub.c:3251 [inline]
>  kmem_cache_alloc_trace+0x323/0x3e0 mm/slub.c:3282
>  kmalloc include/linux/slab.h:600 [inline]
>  kzalloc include/linux/slab.h:733 [inline]
>  ref_tracker_alloc+0x14c/0x550 lib/ref_tracker.c:85
>  __netdev_tracker_alloc include/linux/netdevice.h:3960 [inline]
>  netdev_hold include/linux/netdevice.h:3989 [inline]
>  dst_init+0xe0/0x520 net/core/dst.c:52
>  dst_alloc+0x16b/0x1f0 net/core/dst.c:96
>  ip6_dst_alloc+0x2e/0x90 net/ipv6/route.c:344
>  icmp6_dst_alloc+0x6d/0x680 net/ipv6/route.c:3261
>  ndisc_send_skb+0x10eb/0x1730 net/ipv6/ndisc.c:487
>  ndisc_send_ns+0xa6/0x120 net/ipv6/ndisc.c:665
>  addrconf_dad_work+0xbf9/0x12d0 net/ipv6/addrconf.c:4171
>  process_one_work+0x991/0x1610 kernel/workqueue.c:2289
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1453 [inline]
>  free_pcp_prepare+0x5e4/0xd20 mm/page_alloc.c:1503
>  free_unref_page_prepare mm/page_alloc.c:3383 [inline]
>  free_unref_page_list+0x16f/0xb90 mm/page_alloc.c:3525
>  release_pages+0xbe8/0x1810 mm/swap.c:1017
>  tlb_batch_pages_flush+0xa8/0x1a0 mm/mmu_gather.c:58
>  tlb_flush_mmu_free mm/mmu_gather.c:255 [inline]
>  tlb_flush_mmu mm/mmu_gather.c:262 [inline]
>  tlb_finish_mmu+0x147/0x7e0 mm/mmu_gather.c:353
>  exit_mmap+0x1fe/0x720 mm/mmap.c:3212
>  __mmput+0x128/0x4c0 kernel/fork.c:1180
>  mmput+0x5c/0x70 kernel/fork.c:1201
>  exit_mm kernel/exit.c:510 [inline]
>  do_exit+0xa09/0x29f0 kernel/exit.c:782
>  do_group_exit+0xd2/0x2f0 kernel/exit.c:925
>  __do_sys_exit_group kernel/exit.c:936 [inline]
>  __se_sys_exit_group kernel/exit.c:934 [inline]
>  __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:934
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> Memory state around the buggy address:
>  ffff88807cd4ac80: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
>  ffff88807cd4ad00: 00 00 00 00 fc fc fc fc fa fb fb fb fc fc fc fc
> >ffff88807cd4ad80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
>                             ^
>  ffff88807cd4ae00: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
>  ffff88807cd4ae80: 00 00 00 00 fc fc fc fc 00 00 00 00 fc fc fc fc
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
> For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 967DF512B36
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 07:58:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbiD1GBg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 02:01:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236607AbiD1GBf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 02:01:35 -0400
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A646644A33
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 22:58:21 -0700 (PDT)
Received: by mail-il1-f198.google.com with SMTP id s10-20020a92c5ca000000b002cc45dade1aso1226036ilt.20
        for <netdev@vger.kernel.org>; Wed, 27 Apr 2022 22:58:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=c1CjGBVY8lidPMWVx3e/63feK8jYuLHcDjXbYqW87i8=;
        b=nr1zQVFd/7jD3k684z0D86pQbhfeMJw2h610uIIzgUcihIM0jj+teFF5F6vR6MU3lT
         IZPSZld5ykNbL9WJ5cTfJ59uDutbpha8E8o+htaLOdL4sGbqSNKaa6X4dOkgw6COyWII
         kYN57HtOUTQVMSU79iWyccwP3/7oytAM76yNO5heogB69yUn1k6y3aXbF3PoTq2VEzgQ
         FRpRz3Aro/OZz1m4WuzJmbFc9lYxL0a7ycdVy49MqGO9ePQPmVR0uMq07OvHWjtQuVWw
         BOTl0Jt/yxu9Nuohq3uxElx5YsU1f53X4IIC9dIcDTCNljmzUS7pXMG2ygF6fUdq+9HW
         EhJg==
X-Gm-Message-State: AOAM5332bCdtKRk8G1cLV3gIRzrLsOFHXM45hCTs/wbCETGpYMRCLywN
        bpUAiqmwBFl+RrJUjHjuUfnAkhm4R1q39BiRrgnsPZwXhiE2
X-Google-Smtp-Source: ABdhPJywSqjwVHGts4Eo5ddkrTkIpeDLFCzHjOkS7qrhqtCdClWJQZUaiAh2rCJtc4A9vyjWGL6UtBERKtdYwPR3ndD7KPcgE5qG
MIME-Version: 1.0
X-Received: by 2002:a02:271d:0:b0:307:ea12:ff8b with SMTP id
 g29-20020a02271d000000b00307ea12ff8bmr14865021jaa.274.1651125501067; Wed, 27
 Apr 2022 22:58:21 -0700 (PDT)
Date:   Wed, 27 Apr 2022 22:58:21 -0700
In-Reply-To: <000000000000af7f9905da904400@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f8869805ddb09c27@google.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in dst_destroy
From:   syzbot <syzbot+736f4a4f98b21dba48f0@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, syzkaller-bugs@googlegroups.com,
        yajun.deng@linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    03fa8fc93e44 Merge branch 'remove-virt_to_bus-drivers'
git tree:       net-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13db7c44f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=6e95eee1a1aa4fb4
dashboard link: https://syzkaller.appspot.com/bug?extid=736f4a4f98b21dba48f0
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1239a4e4f00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13a4b3b8f00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+736f4a4f98b21dba48f0@syzkaller.appspotmail.com

==================================================================
BUG: KASAN: use-after-free in dst_destroy+0x3c7/0x400 net/core/dst.c:118
Read of size 8 at addr ffff88801ebb8870 by task ksoftirqd/0/15

CPU: 0 PID: 15 Comm: ksoftirqd/0 Not tainted 5.18.0-rc3-syzkaller-01429-g03fa8fc93e44 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 dst_destroy+0x3c7/0x400 net/core/dst.c:118
 rcu_do_batch kernel/rcu/tree.c:2535 [inline]
 rcu_core+0x7b1/0x1880 kernel/rcu/tree.c:2786
 __do_softirq+0x29b/0x9c2 kernel/softirq.c:558
 run_ksoftirqd kernel/softirq.c:921 [inline]
 run_ksoftirqd+0x2d/0x60 kernel/softirq.c:913
 smpboot_thread_fn+0x645/0x9c0 kernel/smpboot.c:164
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298
 </TASK>

Allocated by task 3623:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:469
 kasan_slab_alloc include/linux/kasan.h:224 [inline]
 slab_post_alloc_hook mm/slab.h:749 [inline]
 slab_alloc_node mm/slub.c:3217 [inline]
 slab_alloc mm/slub.c:3225 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3232 [inline]
 kmem_cache_alloc+0x204/0x3b0 mm/slub.c:3242
 kmem_cache_zalloc include/linux/slab.h:704 [inline]
 net_alloc net/core/net_namespace.c:403 [inline]
 copy_net_ns+0x125/0x760 net/core/net_namespace.c:458
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3132
 __do_sys_unshare kernel/fork.c:3203 [inline]
 __se_sys_unshare kernel/fork.c:3201 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3201
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

The buggy address belongs to the object at ffff88801ebb8000
 which belongs to the cache net_namespace of size 6784
The buggy address is located 2160 bytes inside of
 6784-byte region [ffff88801ebb8000, ffff88801ebb9a80)

The buggy address belongs to the physical page:
page:ffffea00007aee00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1ebb8
head:ffffea00007aee00 order:3 compound_mapcount:0 compound_pincount:0
flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010dcd3c0
raw: 0000000000000000 0000000080040004 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3623, tgid 3623 (syz-executor323), ts 317565134167, free_ts 317561201837
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
 alloc_slab_page mm/slub.c:1799 [inline]
 allocate_slab+0x26c/0x3c0 mm/slub.c:1944
 new_slab mm/slub.c:2004 [inline]
 ___slab_alloc+0x8df/0xf20 mm/slub.c:3005
 __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3092
 slab_alloc_node mm/slub.c:3183 [inline]
 slab_alloc mm/slub.c:3225 [inline]
 __kmem_cache_alloc_lru mm/slub.c:3232 [inline]
 kmem_cache_alloc+0x360/0x3b0 mm/slub.c:3242
 kmem_cache_zalloc include/linux/slab.h:704 [inline]
 net_alloc net/core/net_namespace.c:403 [inline]
 copy_net_ns+0x125/0x760 net/core/net_namespace.c:458
 create_new_namespaces+0x3f6/0xb20 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0xc1/0x1f0 kernel/nsproxy.c:226
 ksys_unshare+0x445/0x920 kernel/fork.c:3132
 __do_sys_unshare kernel/fork.c:3203 [inline]
 __se_sys_unshare kernel/fork.c:3201 [inline]
 __x64_sys_unshare+0x2d/0x40 kernel/fork.c:3201
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3423
 skb_free_head+0xac/0x110 net/core/skbuff.c:655
 skb_release_data+0x67a/0x810 net/core/skbuff.c:677
 skb_release_all net/core/skbuff.c:742 [inline]
 __kfree_skb net/core/skbuff.c:756 [inline]
 consume_skb net/core/skbuff.c:915 [inline]
 consume_skb+0xc2/0x160 net/core/skbuff.c:909
 skb_free_datagram+0x1b/0x1f0 net/core/datagram.c:324
 netlink_recvmsg+0x61a/0xea0 net/netlink/af_netlink.c:1999
 sock_recvmsg_nosec net/socket.c:948 [inline]
 sock_recvmsg net/socket.c:966 [inline]
 sock_recvmsg net/socket.c:962 [inline]
 ____sys_recvmsg+0x2be/0x5f0 net/socket.c:2632
 ___sys_recvmsg+0x127/0x200 net/socket.c:2674
 __sys_recvmsg+0xe2/0x1a0 net/socket.c:2704
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88801ebb8700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801ebb8780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff88801ebb8800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff88801ebb8880: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff88801ebb8900: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
==================================================================


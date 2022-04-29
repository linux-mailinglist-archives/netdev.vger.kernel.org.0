Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A59E514FC9
	for <lists+netdev@lfdr.de>; Fri, 29 Apr 2022 17:43:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241040AbiD2PqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Apr 2022 11:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231540AbiD2PqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Apr 2022 11:46:23 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E2AA5E8B
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 08:43:04 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so10859829pju.2
        for <netdev@vger.kernel.org>; Fri, 29 Apr 2022 08:43:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LF/zimh1rkh6fmrh/L8U3i5FA1iQGih+QEvPNm4qhTI=;
        b=BasswaIHYu9dpsWekaaYysRHcW7FAmIdjyG/aZ3AhS13LiW37/kro6GYAghfaH1b8M
         6TnHG1hedAfYcfKPVu8vhgV8IYruD2XN+VUy2v0/+e8ureOdn9MnM2kgSKTzZ8Cb0WqL
         mbC91QR90uB496nev7BlHG5VsHZHrJqU9dYBsBDt9gOD+7C4k4O4IdRgNpzMsp5r2Kch
         jkL9igSkmh9MAyil8Wvkje2J+7virBvpxkwZJxgcs7cSZiU6bxBNnUJdgbKyIXT+CGiZ
         DtRZyDjNxDZjp6dZ8PBoed2t2N0h2/8IxGNP+Uo+30pbxU1S9/c7Xs5cVsFPF1kY84N4
         JNGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LF/zimh1rkh6fmrh/L8U3i5FA1iQGih+QEvPNm4qhTI=;
        b=n/68XHrD/YaTP76d14FY+RAYPhIQv8TUrsWpLylYPmP87DzSJ/6XdtQdyljO+9uSDL
         K+BIjKeMQDUzZeWWiE6wWVSWUrUeSxv/BxL4fn8u4m8SjMWu5rFnfhL3EhQMJi4BDsEq
         RwddnnFSOvnUm95bO41E4g/0fiHTlAD3K8VoN/ZOqSIwCA0I9d4oIDHIfbay3qg8Qen/
         /f/ksPjWy804dvR816DEOqTPCctAacejdkzHI/pMivmIRyCBr6kRMnbV0Saahi6PVy2W
         D4a+3RMUsjqfBvn2QDnXC8oa6/goZ5ZRwPeTuL6aAp3Y7pHi3XwGsD0PKxvDPxWpRZK2
         Ddcw==
X-Gm-Message-State: AOAM532iZLpcaQSRvAi9Uj6gQbDQsBboIVcClMCop7c3zdBwM653QJ+W
        9iC2fAf58XR0lalb+iK+QFY=
X-Google-Smtp-Source: ABdhPJzBqkMyJqIFh/LTMwtFc8nIef3KHFxQbs7J2P3zLKqlaOSEyfWVIBmyYsWsU60MnoZXZ39Hjw==
X-Received: by 2002:a17:90b:3145:b0:1d9:ab18:910e with SMTP id ip5-20020a17090b314500b001d9ab18910emr4587278pjb.57.1651246983361;
        Fri, 29 Apr 2022 08:43:03 -0700 (PDT)
Received: from edumazet1.svl.corp.google.com ([2620:15c:2c4:201:a265:137a:7be3:938f])
        by smtp.gmail.com with ESMTPSA id j127-20020a62c585000000b0050d567f70c2sm3543590pfg.171.2022.04.29.08.43.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 08:43:02 -0700 (PDT)
From:   Eric Dumazet <eric.dumazet@gmail.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        syzbot <syzkaller@googlegroups.com>,
        Flavio Leitner <fbl@sysclose.org>
Subject: [PATCH net] net: igmp: respect RCU rules in ip_mc_source() and ip_mc_msfilter()
Date:   Fri, 29 Apr 2022 08:42:57 -0700
Message-Id: <20220429154257.2054294-1-eric.dumazet@gmail.com>
X-Mailer: git-send-email 2.36.0.464.gb9c8b46e94-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

syzbot reported an UAF in ip_mc_sf_allow() [1]

Whenever RCU protected list replaces an object,
the pointer to the new object needs to be updated
_before_ the call to kfree_rcu() or call_rcu()

Because kfree_rcu(ptr, rcu) got support for NULL ptr
only recently in commit 12edff045bc6 ("rcu: Make kfree_rcu()
ignore NULL pointers"), I chose to use the conditional
to make sure stable backports won't miss this detail.

if (psl)
    kfree_rcu(psl, rcu);

net/ipv6/mcast.c has similar issues, addressed in a separate patch.

[1]
BUG: KASAN: use-after-free in ip_mc_sf_allow+0x6bb/0x6d0 net/ipv4/igmp.c:2655
Read of size 4 at addr ffff88807d37b904 by task syz-executor.5/908

CPU: 0 PID: 908 Comm: syz-executor.5 Not tainted 5.18.0-rc4-syzkaller-00064-g8f4dd16603ce #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0xeb/0x467 mm/kasan/report.c:313
 print_report mm/kasan/report.c:429 [inline]
 kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
 ip_mc_sf_allow+0x6bb/0x6d0 net/ipv4/igmp.c:2655
 raw_v4_input net/ipv4/raw.c:190 [inline]
 raw_local_deliver+0x4d1/0xbe0 net/ipv4/raw.c:218
 ip_protocol_deliver_rcu+0xcf/0xb30 net/ipv4/ip_input.c:193
 ip_local_deliver_finish+0x2ee/0x4c0 net/ipv4/ip_input.c:233
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_local_deliver+0x1b3/0x200 net/ipv4/ip_input.c:254
 dst_input include/net/dst.h:461 [inline]
 ip_rcv_finish+0x1cb/0x2f0 net/ipv4/ip_input.c:437
 NF_HOOK include/linux/netfilter.h:307 [inline]
 NF_HOOK include/linux/netfilter.h:301 [inline]
 ip_rcv+0xaa/0xd0 net/ipv4/ip_input.c:556
 __netif_receive_skb_one_core+0x114/0x180 net/core/dev.c:5405
 __netif_receive_skb+0x24/0x1b0 net/core/dev.c:5519
 netif_receive_skb_internal net/core/dev.c:5605 [inline]
 netif_receive_skb+0x13e/0x8e0 net/core/dev.c:5664
 tun_rx_batched.isra.0+0x460/0x720 drivers/net/tun.c:1534
 tun_get_user+0x28b7/0x3e30 drivers/net/tun.c:1985
 tun_chr_write_iter+0xdb/0x200 drivers/net/tun.c:2015
 call_write_iter include/linux/fs.h:2050 [inline]
 new_sync_write+0x38a/0x560 fs/read_write.c:504
 vfs_write+0x7c0/0xac0 fs/read_write.c:591
 ksys_write+0x127/0x250 fs/read_write.c:644
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f3f12c3bbff
Code: 89 54 24 18 48 89 74 24 10 89 7c 24 08 e8 99 fd ff ff 48 8b 54 24 18 48 8b 74 24 10 41 89 c0 8b 7c 24 08 b8 01 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 44 24 08 e8 cc fd ff ff 48
RSP: 002b:00007f3f13ea9130 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f3f12d9bf60 RCX: 00007f3f12c3bbff
RDX: 0000000000000036 RSI: 0000000020002ac0 RDI: 00000000000000c8
RBP: 00007f3f12ce308d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000036 R11: 0000000000000293 R12: 0000000000000000
R13: 00007fffb68dd79f R14: 00007f3f13ea9300 R15: 0000000000022000
 </TASK>

Allocated by task 908:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track mm/kasan/common.c:45 [inline]
 set_alloc_info mm/kasan/common.c:436 [inline]
 ____kasan_kmalloc mm/kasan/common.c:515 [inline]
 ____kasan_kmalloc mm/kasan/common.c:474 [inline]
 __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:524
 kasan_kmalloc include/linux/kasan.h:234 [inline]
 __do_kmalloc mm/slab.c:3710 [inline]
 __kmalloc+0x209/0x4d0 mm/slab.c:3719
 kmalloc include/linux/slab.h:586 [inline]
 sock_kmalloc net/core/sock.c:2501 [inline]
 sock_kmalloc+0xb5/0x100 net/core/sock.c:2492
 ip_mc_source+0xba2/0x1100 net/ipv4/igmp.c:2392
 do_ip_setsockopt net/ipv4/ip_sockglue.c:1296 [inline]
 ip_setsockopt+0x2312/0x3ab0 net/ipv4/ip_sockglue.c:1432
 raw_setsockopt+0x274/0x2c0 net/ipv4/raw.c:861
 __sys_setsockopt+0x2db/0x6a0 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 753:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 kasan_set_track+0x21/0x30 mm/kasan/common.c:45
 kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
 ____kasan_slab_free mm/kasan/common.c:366 [inline]
 ____kasan_slab_free+0x13d/0x180 mm/kasan/common.c:328
 kasan_slab_free include/linux/kasan.h:200 [inline]
 __cache_free mm/slab.c:3439 [inline]
 kmem_cache_free_bulk+0x69/0x460 mm/slab.c:3774
 kfree_bulk include/linux/slab.h:437 [inline]
 kfree_rcu_work+0x51c/0xa10 kernel/rcu/tree.c:3318
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

Last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0x7e/0x90 mm/kasan/generic.c:348
 kvfree_call_rcu+0x74/0x990 kernel/rcu/tree.c:3595
 ip_mc_msfilter+0x712/0xb60 net/ipv4/igmp.c:2510
 do_ip_setsockopt net/ipv4/ip_sockglue.c:1257 [inline]
 ip_setsockopt+0x32e1/0x3ab0 net/ipv4/ip_sockglue.c:1432
 raw_setsockopt+0x274/0x2c0 net/ipv4/raw.c:861
 __sys_setsockopt+0x2db/0x6a0 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Second to last potentially related work creation:
 kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
 __kasan_record_aux_stack+0x7e/0x90 mm/kasan/generic.c:348
 call_rcu+0x99/0x790 kernel/rcu/tree.c:3074
 mpls_dev_notify+0x552/0x8a0 net/mpls/af_mpls.c:1656
 notifier_call_chain+0xb5/0x200 kernel/notifier.c:84
 call_netdevice_notifiers_info+0xb5/0x130 net/core/dev.c:1938
 call_netdevice_notifiers_extack net/core/dev.c:1976 [inline]
 call_netdevice_notifiers net/core/dev.c:1990 [inline]
 unregister_netdevice_many+0x92e/0x1890 net/core/dev.c:10751
 default_device_exit_batch+0x449/0x590 net/core/dev.c:11245
 ops_exit_list+0x125/0x170 net/core/net_namespace.c:167
 cleanup_net+0x4ea/0xb00 net/core/net_namespace.c:594
 process_one_work+0x996/0x1610 kernel/workqueue.c:2289
 worker_thread+0x665/0x1080 kernel/workqueue.c:2436
 kthread+0x2e9/0x3a0 kernel/kthread.c:376
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

The buggy address belongs to the object at ffff88807d37b900
 which belongs to the cache kmalloc-64 of size 64
The buggy address is located 4 bytes inside of
 64-byte region [ffff88807d37b900, ffff88807d37b940)

The buggy address belongs to the physical page:
page:ffffea0001f4dec0 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88807d37b180 pfn:0x7d37b
flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
raw: 00fff00000000200 ffff888010c41340 ffffea0001c795c8 ffff888010c40200
raw: ffff88807d37b180 ffff88807d37b000 000000010000001f 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x342040(__GFP_IO|__GFP_NOWARN|__GFP_COMP|__GFP_HARDWALL|__GFP_THISNODE), pid 2963, tgid 2963 (udevd), ts 139732238007, free_ts 139730893262
 prep_new_page mm/page_alloc.c:2441 [inline]
 get_page_from_freelist+0xba2/0x3e00 mm/page_alloc.c:4182
 __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5408
 __alloc_pages_node include/linux/gfp.h:587 [inline]
 kmem_getpages mm/slab.c:1378 [inline]
 cache_grow_begin+0x75/0x350 mm/slab.c:2584
 cache_alloc_refill+0x27f/0x380 mm/slab.c:2957
 ____cache_alloc mm/slab.c:3040 [inline]
 ____cache_alloc mm/slab.c:3023 [inline]
 __do_cache_alloc mm/slab.c:3267 [inline]
 slab_alloc mm/slab.c:3309 [inline]
 __do_kmalloc mm/slab.c:3708 [inline]
 __kmalloc+0x3b3/0x4d0 mm/slab.c:3719
 kmalloc include/linux/slab.h:586 [inline]
 kzalloc include/linux/slab.h:714 [inline]
 tomoyo_encode2.part.0+0xe9/0x3a0 security/tomoyo/realpath.c:45
 tomoyo_encode2 security/tomoyo/realpath.c:31 [inline]
 tomoyo_encode+0x28/0x50 security/tomoyo/realpath.c:80
 tomoyo_realpath_from_path+0x186/0x620 security/tomoyo/realpath.c:288
 tomoyo_get_realpath security/tomoyo/file.c:151 [inline]
 tomoyo_path_perm+0x21b/0x400 security/tomoyo/file.c:822
 security_inode_getattr+0xcf/0x140 security/security.c:1350
 vfs_getattr fs/stat.c:157 [inline]
 vfs_statx+0x16a/0x390 fs/stat.c:232
 vfs_fstatat+0x8c/0xb0 fs/stat.c:255
 __do_sys_newfstatat+0x91/0x110 fs/stat.c:425
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
page last free stack trace:
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1356 [inline]
 free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1406
 free_unref_page_prepare mm/page_alloc.c:3328 [inline]
 free_unref_page+0x19/0x6a0 mm/page_alloc.c:3423
 __vunmap+0x85d/0xd30 mm/vmalloc.c:2667
 __vfree+0x3c/0xd0 mm/vmalloc.c:2715
 vfree+0x5a/0x90 mm/vmalloc.c:2746
 __do_replace+0x16b/0x890 net/ipv6/netfilter/ip6_tables.c:1117
 do_replace net/ipv6/netfilter/ip6_tables.c:1157 [inline]
 do_ip6t_set_ctl+0x90d/0xb90 net/ipv6/netfilter/ip6_tables.c:1639
 nf_setsockopt+0x83/0xe0 net/netfilter/nf_sockopt.c:101
 ipv6_setsockopt+0x122/0x180 net/ipv6/ipv6_sockglue.c:1026
 tcp_setsockopt+0x136/0x2520 net/ipv4/tcp.c:3696
 __sys_setsockopt+0x2db/0x6a0 net/socket.c:2180
 __do_sys_setsockopt net/socket.c:2191 [inline]
 __se_sys_setsockopt net/socket.c:2188 [inline]
 __x64_sys_setsockopt+0xba/0x150 net/socket.c:2188
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Memory state around the buggy address:
 ffff88807d37b800: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
 ffff88807d37b880: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
>ffff88807d37b900: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
                   ^
 ffff88807d37b980: fb fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
 ffff88807d37ba00: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc

Fixes: c85bb41e9318 ("igmp: fix ip_mc_sf_allow race [v5]")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
Cc: Flavio Leitner <fbl@sysclose.org>
---
 net/ipv4/igmp.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/igmp.c b/net/ipv4/igmp.c
index 2ad3c7b42d6d271baf941e7f74feaf981dff8036..1d9e6d5e9a76c5c22d78d7da5b0efbf61d8feb88 100644
--- a/net/ipv4/igmp.c
+++ b/net/ipv4/igmp.c
@@ -2403,9 +2403,10 @@ int ip_mc_source(int add, int omode, struct sock *sk, struct
 			/* decrease mem now to avoid the memleak warning */
 			atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
 				   &sk->sk_omem_alloc);
-			kfree_rcu(psl, rcu);
 		}
 		rcu_assign_pointer(pmc->sflist, newpsl);
+		if (psl)
+			kfree_rcu(psl, rcu);
 		psl = newpsl;
 	}
 	rv = 1;	/* > 0 for insert logic below if sl_count is 0 */
@@ -2507,11 +2508,13 @@ int ip_mc_msfilter(struct sock *sk, struct ip_msfilter *msf, int ifindex)
 		/* decrease mem now to avoid the memleak warning */
 		atomic_sub(struct_size(psl, sl_addr, psl->sl_max),
 			   &sk->sk_omem_alloc);
-		kfree_rcu(psl, rcu);
-	} else
+	} else {
 		(void) ip_mc_del_src(in_dev, &msf->imsf_multiaddr, pmc->sfmode,
 			0, NULL, 0);
+	}
 	rcu_assign_pointer(pmc->sflist, newpsl);
+	if (psl)
+		kfree_rcu(psl, rcu);
 	pmc->sfmode = msf->imsf_fmode;
 	err = 0;
 done:
-- 
2.36.0.464.gb9c8b46e94-goog


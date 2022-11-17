Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB39862D757
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 10:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239814AbiKQJou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 04:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234797AbiKQJol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 04:44:41 -0500
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B129970A37
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:44:36 -0800 (PST)
Received: by mail-io1-f71.google.com with SMTP id n8-20020a6b4108000000b006de520dc5c9so631823ioa.19
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 01:44:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O1roJ9vgdIn1CFlxSBfJPQCcALI91L+yUdiC/k2B3U4=;
        b=YE6bCscOfcEzQuTixn/PBCwDuNgVgkpxMYSKol8ksFMOGoGapfBTPZ8s1brSgTDJim
         24/p5X+F63NKI12B20vgnCD8YSaWe1svXzZlRbxAeQwImXb60h1KdzDysa2WNnfHdATu
         H/QscP/z40sKaPluHPnSaxv+GiUO+bPLDMSoZ3GRz+BRR5zWB6aQdCQTlpXz8mrr9VVt
         KiJO4+g4ur4Thb3R+5JdLt7f1wQUaMmPf0JxybkC5YGaAh9049odOKFOYr68e3cEjTux
         moR/E6QN25EQrAlZ+FMgaX6uPHSi0sPIIWL2LLrKlyOnAHm0aZj6GvDpiOD92BKgQPug
         vz6Q==
X-Gm-Message-State: ANoB5pk/g4d1D12HpbwoANWqeXlU1oKgO6R6VTW+NoPAioysFN2tOZEe
        TmJOfwrJbvwi8VOX1Gyjc1d6VbTx34PDcAvVpv5Bv5l7hlVI
X-Google-Smtp-Source: AA0mqf5xgiN5kGv8lEvzqNuPFFxNi+mgoHY+OfxSIp/vrAlRu759OO3msfSsmXBMzpCVNnEI1kyUGKXoCMaI2pgV4F8coF5cgSo8
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4cd:b0:302:9269:f3d2 with SMTP id
 f13-20020a056e0204cd00b003029269f3d2mr838844ils.87.1668678276054; Thu, 17 Nov
 2022 01:44:36 -0800 (PST)
Date:   Thu, 17 Nov 2022 01:44:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e38b6605eda76f98@google.com>
Subject: [syzbot] possible deadlock in l2tp_tunnel_register
From:   syzbot <syzbot+de987172bb74a381879b@syzkaller.appspotmail.com>
To:     davem@davemloft.net, edumazet@google.com, jakub@cloudflare.com,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pabeni@redhat.com,
        syzkaller-bugs@googlegroups.com, tparkin@katalix.com
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

Hello,

syzbot found the following issue on:

HEAD commit:    064bc7312bd0 netdevsim: Fix memory leak of nsim_dev->fa_co..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=16948779880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a33ac7bbc22a8c35
dashboard link: https://syzkaller.appspot.com/bug?extid=de987172bb74a381879b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/0634e1c0e4cb/disk-064bc731.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/fe1039d2de22/vmlinux-064bc731.xz
kernel image: https://storage.googleapis.com/syzbot-assets/5a0d673875fa/bzImage-064bc731.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+de987172bb74a381879b@syzkaller.appspotmail.com

========================================================
WARNING: possible irq lock inversion dependency detected
6.1.0-rc4-syzkaller-00212-g064bc7312bd0 #0 Not tainted
--------------------------------------------------------
syz-executor.0/4763 just changed the state of lock:
ffff8880785323b8 (clock-AF_INET6){+++.}-{2:2}, at: l2tp_tunnel_register+0x126/0x1210 net/l2tp/l2tp_core.c:1477
but this lock was taken by another, SOFTIRQ-safe lock in the past:
 (&tcp_hashinfo.bhash[i].lock){+.-.}-{2:2}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(clock-AF_INET6);
                               local_irq_disable();
                               lock(&tcp_hashinfo.bhash[i].lock);
                               lock(clock-AF_INET6);
  <Interrupt>
    lock(&tcp_hashinfo.bhash[i].lock);

 *** DEADLOCK ***

1 lock held by syz-executor.0/4763:
 #0: ffff88807d11e130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1721 [inline]
 #0: ffff88807d11e130 (sk_lock-AF_PPPOX){+.+.}-{0:0}, at: pppol2tp_connect+0xadc/0x1a10 net/l2tp/l2tp_ppp.c:675

the shortest dependencies between 2nd lock and 1st lock:
 -> (&tcp_hashinfo.bhash[i].lock){+.-.}-{2:2} {
    HARDIRQ-ON-W at:
                      lock_acquire kernel/locking/lockdep.c:5668 [inline]
                      lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
                      __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
                      _raw_spin_lock_bh+0x33/0x40 kernel/locking/spinlock.c:178
                      spin_lock_bh include/linux/spinlock.h:355 [inline]
                      inet_csk_get_port+0x66a/0x2640 net/ipv4/inet_connection_sock.c:496
                      __inet6_bind+0x625/0x1b20 net/ipv6/af_inet6.c:412
                      inet6_bind+0x177/0x220 net/ipv6/af_inet6.c:471
                      rds_tcp_listen_init+0x2a9/0x4e0 net/rds/tcp_listen.c:307
                      rds_tcp_init_net+0x21d/0x4f0 net/rds/tcp.c:573
                      ops_init+0xb9/0x680 net/core/net_namespace.c:135
                      __register_pernet_operations net/core/net_namespace.c:1153 [inline]
                      register_pernet_operations+0x35a/0x850 net/core/net_namespace.c:1222
                      register_pernet_device+0x2a/0x80 net/core/net_namespace.c:1309
                      rds_tcp_init+0x65/0xd3 net/rds/tcp.c:731
                      do_one_initcall+0x141/0x780 init/main.c:1303
                      do_initcall_level init/main.c:1376 [inline]
                      do_initcalls init/main.c:1392 [inline]
                      do_basic_setup init/main.c:1411 [inline]
                      kernel_init_freeable+0x6ff/0x788 init/main.c:1631
                      kernel_init+0x1e/0x1d0 init/main.c:1519
                      ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
    IN-SOFTIRQ-W at:
                      lock_acquire kernel/locking/lockdep.c:5668 [inline]
                      lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
                      __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
                      _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
                      spin_lock include/linux/spinlock.h:350 [inline]
                      __inet_inherit_port+0x297/0x14e0 net/ipv4/inet_hashtables.c:229
                      tcp_v4_syn_recv_sock+0xb5b/0x14c0 net/ipv4/tcp_ipv4.c:1588
                      tcp_check_req+0x632/0x1aa0 net/ipv4/tcp_minisocks.c:786
                      tcp_v4_rcv+0x24b4/0x3980 net/ipv4/tcp_ipv4.c:2030
                      ip_protocol_deliver_rcu+0x9f/0x7c0 net/ipv4/ip_input.c:205
                      ip_local_deliver_finish+0x2ec/0x4c0 net/ipv4/ip_input.c:233
                      NF_HOOK include/linux/netfilter.h:302 [inline]
                      NF_HOOK include/linux/netfilter.h:296 [inline]
                      ip_local_deliver+0x1ae/0x200 net/ipv4/ip_input.c:254
                      dst_input include/net/dst.h:455 [inline]
                      ip_sublist_rcv_finish+0x9a/0x2c0 net/ipv4/ip_input.c:575
                      ip_list_rcv_finish net/ipv4/ip_input.c:625 [inline]
                      ip_sublist_rcv+0x533/0x980 net/ipv4/ip_input.c:633
                      ip_list_rcv+0x31e/0x470 net/ipv4/ip_input.c:668
                      __netif_receive_skb_list_ptype net/core/dev.c:5532 [inline]
                      __netif_receive_skb_list_core+0x548/0x8f0 net/core/dev.c:5580
                      __netif_receive_skb_list net/core/dev.c:5632 [inline]
                      netif_receive_skb_list_internal+0x75f/0xd90 net/core/dev.c:5723
                      gro_normal_list include/net/gro.h:433 [inline]
                      gro_normal_list include/net/gro.h:429 [inline]
                      napi_complete_done+0x1f5/0x890 net/core/dev.c:6064
                      virtqueue_napi_complete drivers/net/virtio_net.c:401 [inline]
                      virtnet_poll+0xd08/0x1300 drivers/net/virtio_net.c:1678
                      __napi_poll+0xb8/0x770 net/core/dev.c:6498
                      napi_poll net/core/dev.c:6565 [inline]
                      net_rx_action+0xa00/0xde0 net/core/dev.c:6676
                      __do_softirq+0x1fb/0xadc kernel/softirq.c:571
                      invoke_softirq kernel/softirq.c:445 [inline]
                      __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
                      irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
                      common_interrupt+0xad/0xd0 arch/x86/kernel/irq.c:240
                      asm_common_interrupt+0x26/0x40 arch/x86/include/asm/idtentry.h:640
                      native_safe_halt arch/x86/include/asm/irqflags.h:51 [inline]
                      arch_safe_halt arch/x86/include/asm/irqflags.h:89 [inline]
                      acpi_safe_halt drivers/acpi/processor_idle.c:112 [inline]
                      acpi_idle_do_entry+0x1fd/0x2a0 drivers/acpi/processor_idle.c:572
                      acpi_idle_enter+0x368/0x510 drivers/acpi/processor_idle.c:709
                      cpuidle_enter_state+0x1af/0xd40 drivers/cpuidle/cpuidle.c:239
                      cpuidle_enter+0x4e/0xa0 drivers/cpuidle/cpuidle.c:356
                      call_cpuidle kernel/sched/idle.c:155 [inline]
                      cpuidle_idle_call kernel/sched/idle.c:236 [inline]
                      do_idle+0x3f7/0x590 kernel/sched/idle.c:303
                      cpu_startup_entry+0x18/0x20 kernel/sched/idle.c:400
                      start_secondary+0x256/0x300 arch/x86/kernel/smpboot.c:262
                      secondary_startup_64_no_verify+0xce/0xdb
    INITIAL USE at:
                     lock_acquire kernel/locking/lockdep.c:5668 [inline]
                     lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
                     __raw_spin_lock_bh include/linux/spinlock_api_smp.h:126 [inline]
                     _raw_spin_lock_bh+0x33/0x40 kernel/locking/spinlock.c:178
                     spin_lock_bh include/linux/spinlock.h:355 [inline]
                     inet_csk_get_port+0x66a/0x2640 net/ipv4/inet_connection_sock.c:496
                     __inet6_bind+0x625/0x1b20 net/ipv6/af_inet6.c:412
                     inet6_bind+0x177/0x220 net/ipv6/af_inet6.c:471
                     rds_tcp_listen_init+0x2a9/0x4e0 net/rds/tcp_listen.c:307
                     rds_tcp_init_net+0x21d/0x4f0 net/rds/tcp.c:573
                     ops_init+0xb9/0x680 net/core/net_namespace.c:135
                     __register_pernet_operations net/core/net_namespace.c:1153 [inline]
                     register_pernet_operations+0x35a/0x850 net/core/net_namespace.c:1222
                     register_pernet_device+0x2a/0x80 net/core/net_namespace.c:1309
                     rds_tcp_init+0x65/0xd3 net/rds/tcp.c:731
                     do_one_initcall+0x141/0x780 init/main.c:1303
                     do_initcall_level init/main.c:1376 [inline]
                     do_initcalls init/main.c:1392 [inline]
                     do_basic_setup init/main.c:1411 [inline]
                     kernel_init_freeable+0x6ff/0x788 init/main.c:1631
                     kernel_init+0x1e/0x1d0 init/main.c:1519
                     ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:306
  }
  ... key      at: [<ffffffff91d7c600>] __key.1+0x0/0x40
  ... acquired at:
   __raw_read_lock_bh include/linux/rwlock_api_smp.h:176 [inline]
   _raw_read_lock_bh+0x3f/0x70 kernel/locking/spinlock.c:252
   sock_i_uid+0x1f/0xb0 net/core/sock.c:2542
   sk_reuseport_match net/ipv4/inet_connection_sock.c:383 [inline]
   inet_csk_get_port+0x869/0x2640 net/ipv4/inet_connection_sock.c:514
   __inet6_bind+0x625/0x1b20 net/ipv6/af_inet6.c:412
   inet6_bind+0x177/0x220 net/ipv6/af_inet6.c:471
   __sys_bind+0x1ed/0x260 net/socket.c:1776
   __do_sys_bind net/socket.c:1787 [inline]
   __se_sys_bind net/socket.c:1785 [inline]
   __x64_sys_bind+0x73/0xb0 net/socket.c:1785
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd

-> (clock-AF_INET6){+++.}-{2:2} {
   HARDIRQ-ON-W at:
                    lock_acquire kernel/locking/lockdep.c:5668 [inline]
                    lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
                    __raw_write_lock_bh include/linux/rwlock_api_smp.h:202 [inline]
                    _raw_write_lock_bh+0x33/0x40 kernel/locking/spinlock.c:334
                    sock_orphan include/net/sock.h:2090 [inline]
                    sk_common_release+0xc6/0x390 net/core/sock.c:3672
                    inet_release+0x132/0x270 net/ipv4/af_inet.c:428
                    inet6_release+0x50/0x70 net/ipv6/af_inet6.c:488
                    __sock_release+0xcd/0x280 net/socket.c:650
                    sock_close+0x1c/0x20 net/socket.c:1365
                    __fput+0x27c/0xa90 fs/file_table.c:320
                    task_work_run+0x16f/0x270 kernel/task_work.c:179
                    resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
                    exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
                    exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
                    __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
                    syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
                    do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
                    entry_SYSCALL_64_after_hwframe+0x63/0xcd
   HARDIRQ-ON-R at:
                    lock_acquire kernel/locking/lockdep.c:5668 [inline]
                    lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
                    __raw_read_lock_bh include/linux/rwlock_api_smp.h:176 [inline]
                    _raw_read_lock_bh+0x3f/0x70 kernel/locking/spinlock.c:252
                    sock_i_uid+0x1f/0xb0 net/core/sock.c:2542
                    udp_lib_lport_inuse+0x32/0x490 net/ipv4/udp.c:140
                    udp_lib_get_port+0x835/0x18c0 net/ipv4/udp.c:306
                    __inet6_bind+0x625/0x1b20 net/ipv6/af_inet6.c:412
                    inet6_bind+0x177/0x220 net/ipv6/af_inet6.c:471
                    __sys_bind+0x1ed/0x260 net/socket.c:1776
                    __do_sys_bind net/socket.c:1787 [inline]
                    __se_sys_bind net/socket.c:1785 [inline]
                    __x64_sys_bind+0x73/0xb0 net/socket.c:1785
                    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
                    do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
                    entry_SYSCALL_64_after_hwframe+0x63/0xcd
   SOFTIRQ-ON-W at:
                    lock_acquire kernel/locking/lockdep.c:5668 [inline]
                    lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
                    __raw_write_lock include/linux/rwlock_api_smp.h:209 [inline]
                    _raw_write_lock+0x2e/0x40 kernel/locking/spinlock.c:300
                    l2tp_tunnel_register+0x126/0x1210 net/l2tp/l2tp_core.c:1477
                    pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
                    __sys_connect_file+0x153/0x1a0 net/socket.c:1976
                    __sys_connect+0x165/0x1a0 net/socket.c:1993
                    __do_sys_connect net/socket.c:2003 [inline]
                    __se_sys_connect net/socket.c:2000 [inline]
                    __x64_sys_connect+0x73/0xb0 net/socket.c:2000
                    do_syscall_x64 arch/x86/entry/common.c:50 [inline]
                    do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
                    entry_SYSCALL_64_after_hwframe+0x63/0xcd
   INITIAL USE at:
                   lock_acquire kernel/locking/lockdep.c:5668 [inline]
                   lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
                   __raw_write_lock_bh include/linux/rwlock_api_smp.h:202 [inline]
                   _raw_write_lock_bh+0x33/0x40 kernel/locking/spinlock.c:334
                   sock_orphan include/net/sock.h:2090 [inline]
                   sk_common_release+0xc6/0x390 net/core/sock.c:3672
                   inet_release+0x132/0x270 net/ipv4/af_inet.c:428
                   inet6_release+0x50/0x70 net/ipv6/af_inet6.c:488
                   __sock_release+0xcd/0x280 net/socket.c:650
                   sock_close+0x1c/0x20 net/socket.c:1365
                   __fput+0x27c/0xa90 fs/file_table.c:320
                   task_work_run+0x16f/0x270 kernel/task_work.c:179
                   resume_user_mode_work include/linux/resume_user_mode.h:49 [inline]
                   exit_to_user_mode_loop kernel/entry/common.c:171 [inline]
                   exit_to_user_mode_prepare+0x23c/0x250 kernel/entry/common.c:203
                   __syscall_exit_to_user_mode_work kernel/entry/common.c:285 [inline]
                   syscall_exit_to_user_mode+0x1d/0x50 kernel/entry/common.c:296
                   do_syscall_64+0x46/0xb0 arch/x86/entry/common.c:86
                   entry_SYSCALL_64_after_hwframe+0x63/0xcd
   INITIAL READ USE at:
                        lock_acquire kernel/locking/lockdep.c:5668 [inline]
                        lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
                        __raw_read_lock_bh include/linux/rwlock_api_smp.h:176 [inline]
                        _raw_read_lock_bh+0x3f/0x70 kernel/locking/spinlock.c:252
                        sock_i_uid+0x1f/0xb0 net/core/sock.c:2542
                        udp_lib_lport_inuse+0x32/0x490 net/ipv4/udp.c:140
                        udp_lib_get_port+0x835/0x18c0 net/ipv4/udp.c:306
                        __inet6_bind+0x625/0x1b20 net/ipv6/af_inet6.c:412
                        inet6_bind+0x177/0x220 net/ipv6/af_inet6.c:471
                        __sys_bind+0x1ed/0x260 net/socket.c:1776
                        __do_sys_bind net/socket.c:1787 [inline]
                        __se_sys_bind net/socket.c:1785 [inline]
                        __x64_sys_bind+0x73/0xb0 net/socket.c:1785
                        do_syscall_x64 arch/x86/entry/common.c:50 [inline]
                        do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
                        entry_SYSCALL_64_after_hwframe+0x63/0xcd
 }
 ... key      at: [<ffffffff91d5caa0>] af_callback_keys+0xa0/0x300
 ... acquired at:
   mark_lock kernel/locking/lockdep.c:4598 [inline]
   mark_usage kernel/locking/lockdep.c:4547 [inline]
   __lock_acquire+0x893/0x56d0 kernel/locking/lockdep.c:5009
   lock_acquire kernel/locking/lockdep.c:5668 [inline]
   lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
   __raw_write_lock include/linux/rwlock_api_smp.h:209 [inline]
   _raw_write_lock+0x2e/0x40 kernel/locking/spinlock.c:300
   l2tp_tunnel_register+0x126/0x1210 net/l2tp/l2tp_core.c:1477
   pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
   __sys_connect_file+0x153/0x1a0 net/socket.c:1976
   __sys_connect+0x165/0x1a0 net/socket.c:1993
   __do_sys_connect net/socket.c:2003 [inline]
   __se_sys_connect net/socket.c:2000 [inline]
   __x64_sys_connect+0x73/0xb0 net/socket.c:2000
   do_syscall_x64 arch/x86/entry/common.c:50 [inline]
   do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
   entry_SYSCALL_64_after_hwframe+0x63/0xcd


stack backtrace:
CPU: 1 PID: 4763 Comm: syz-executor.0 Not tainted 6.1.0-rc4-syzkaller-00212-g064bc7312bd0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 print_irq_inversion_bug kernel/locking/lockdep.c:222 [inline]
 check_usage_backwards kernel/locking/lockdep.c:4105 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4198 [inline]
 mark_lock.part.0.cold+0x61/0xd8 kernel/locking/lockdep.c:4634
 mark_lock kernel/locking/lockdep.c:4598 [inline]
 mark_usage kernel/locking/lockdep.c:4547 [inline]
 __lock_acquire+0x893/0x56d0 kernel/locking/lockdep.c:5009
 lock_acquire kernel/locking/lockdep.c:5668 [inline]
 lock_acquire+0x1e3/0x630 kernel/locking/lockdep.c:5633
 __raw_write_lock include/linux/rwlock_api_smp.h:209 [inline]
 _raw_write_lock+0x2e/0x40 kernel/locking/spinlock.c:300
 l2tp_tunnel_register+0x126/0x1210 net/l2tp/l2tp_core.c:1477
 pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
 __sys_connect_file+0x153/0x1a0 net/socket.c:1976
 __sys_connect+0x165/0x1a0 net/socket.c:1993
 __do_sys_connect net/socket.c:2003 [inline]
 __se_sys_connect net/socket.c:2000 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2000
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6ed8e8b639
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6ed9c29168 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00007f6ed8fabf80 RCX: 00007f6ed8e8b639
RDX: 000000000000002e RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00007f6ed8ee6ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc86db2b3f R14: 00007f6ed9c29300 R15: 0000000000022000
 </TASK>
BUG: sleeping function called from invalid context at include/linux/percpu-rwsem.h:49
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 4763, name: syz-executor.0
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 PID: 4763 Comm: syz-executor.0 Not tainted 6.1.0-rc4-syzkaller-00212-g064bc7312bd0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd1/0x138 lib/dump_stack.c:106
 __might_resched.cold+0x222/0x26b kernel/sched/core.c:9890
 percpu_down_read include/linux/percpu-rwsem.h:49 [inline]
 cpus_read_lock+0x1b/0x140 kernel/cpu.c:310
 static_key_slow_inc+0x12/0x20 kernel/jump_label.c:158
 udp_tunnel_encap_enable include/net/udp_tunnel.h:187 [inline]
 setup_udp_tunnel_sock+0x43d/0x550 net/ipv4/udp_tunnel_core.c:81
 l2tp_tunnel_register+0xc51/0x1210 net/l2tp/l2tp_core.c:1509
 pppol2tp_connect+0xcdc/0x1a10 net/l2tp/l2tp_ppp.c:723
 __sys_connect_file+0x153/0x1a0 net/socket.c:1976
 __sys_connect+0x165/0x1a0 net/socket.c:1993
 __do_sys_connect net/socket.c:2003 [inline]
 __se_sys_connect net/socket.c:2000 [inline]
 __x64_sys_connect+0x73/0xb0 net/socket.c:2000
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f6ed8e8b639
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6ed9c29168 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
RAX: ffffffffffffffda RBX: 00007f6ed8fabf80 RCX: 00007f6ed8e8b639
RDX: 000000000000002e RSI: 0000000020000000 RDI: 0000000000000003
RBP: 00007f6ed8ee6ae9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffc86db2b3f R14: 00007f6ed9c29300 R15: 0000000000022000
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

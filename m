Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFE86560749
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 19:21:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231534AbiF2RVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 13:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbiF2RVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 13:21:19 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1323D498
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 10:21:14 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id s1so23468006wra.9
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 10:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nInAPILD3692be6/y628T5ZOhov3cRKSkyl8DeThGPY=;
        b=UQi8uFO+M1aKaBOu8TKJXiIYUckj3dIU9ZpjE7hQDdAuLKvJAX/cKOWaCZYufPprH8
         L28XegoX6Qc/t0G2kUvdWuVsTAfEkjiC/dndALnW27rwkPa9Kd0oYlgykIal6NiAnYFh
         uWchij7wsEkKgEtN08lIEBkgG9N/5xV0X1ikiGLeRw65kycX4ukmDhfYW9U1xk/+byrp
         C6LhLm1le7UZ10glgIvTYKuLtIg674v4z7JYQWINZpKxuusjuR0b1izmHUszMUX295qD
         lH6ZG7ky8gt0r1zxQw17AyOMCe1i3R/Ph1wsvxdTZnlW2NqM7hFv565s/CtJ+ADoXW60
         5/1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nInAPILD3692be6/y628T5ZOhov3cRKSkyl8DeThGPY=;
        b=GUWp4iBa6yvW6NJZEZmXN4eKuPMeN29cIf/v13LMV4FxWZ7wFBmKG2Pmi5PB1D3oXp
         DbAiYjgFTBBUHGlRSqK4bdaWB+xlTm3RjrJWsGNclnCIZM5EQPacPrnLk7QJYKvUKgb/
         ajaM6NFhn8scRKpap5Vu92kV5ZaAmoBPLGSv7Io9Kx2QpH9CfdZgQIeowDu5lhKJIq7J
         XvY8QjsAID9kVQOtnxP+zvph87FFW1P3XFyBOXp5xU7W4ILECF/ME8xjT7x95mwYs+yN
         LZ7N0AMRDm++u21LiYwRRylbjcLfbnOIsGVCw7YAoJlt0WpPePGKF6Glyqg4e/4TtxbH
         kS/g==
X-Gm-Message-State: AJIora80avXqnQz5Ugww9ZzcM/LVLFqTyi0NGTdTb1vt+FidFw6yXvDg
        MD+BJDQDq6zog2LPtQP9J78LE6xdRwIl4SH0CZGJ
X-Google-Smtp-Source: AGRyM1vXOyGFovBjiH3CIANoqUaTBKffwn4W6SbJ7Mcn1OAirKgPULZXM1izVfn/GLdRFThsAiV8fyBK21HG8tYQHPI=
X-Received: by 2002:a5d:6645:0:b0:21d:17c3:e10e with SMTP id
 f5-20020a5d6645000000b0021d17c3e10emr4159151wrw.483.1656523272969; Wed, 29
 Jun 2022 10:21:12 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000065911f05e294e691@google.com>
In-Reply-To: <00000000000065911f05e294e691@google.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 29 Jun 2022 13:21:02 -0400
Message-ID: <CAHC9VhSDOhCz8L=sAR49RzHXWj0V3q5gDSLzp9AQwHWR+n8XtA@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in selinux_socket_recvmsg
To:     syzbot <syzbot+04b20e641c99a5d99ac2@syzkaller.appspotmail.com>
Cc:     andrii@kernel.org, anton@enomsg.org, ast@kernel.org,
        bpf@vger.kernel.org, ccross@android.com, daniel@iogearbox.net,
        eparis@parisplace.org, john.fastabend@gmail.com, kafai@fb.com,
        keescook@chromium.org, kpsingh@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        selinux@vger.kernel.org, songliubraving@fb.com,
        stephen.smalley.work@gmail.com, syzkaller-bugs@googlegroups.com,
        tony.luck@intel.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 29, 2022 at 8:00 AM syzbot
<syzbot+04b20e641c99a5d99ac2@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    941e3e791269 Merge tag 'for_linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=175b3f90080000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3a010dbf6a7af480
> dashboard link: https://syzkaller.appspot.com/bug?extid=04b20e641c99a5d99ac2
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+04b20e641c99a5d99ac2@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: use-after-free in sock_has_perm security/selinux/hooks.c:4535 [inline]
> BUG: KASAN: use-after-free in selinux_socket_recvmsg+0x278/0x2b0 security/selinux/hooks.c:4899
> Read of size 8 at addr ffff8880787ec480 by task syz-executor.3/5491

Despite the SELinux functions listed above, it looks like this may be
an issue with the netrom code calling sock_put() too many times.  I
know very little about netrom, but I wonder if the issue might be
nr_heartbeat_expiry() calling nr_destroy_socket(), which could drop a
reference to the sock, and then calling sock_put() at the end of
nr_heartbeat_expiry() potentially resulting in the sock being released
prematurely.

> CPU: 0 PID: 5491 Comm: syz-executor.3 Not tainted 5.19.0-rc4-syzkaller-00014-g941e3e791269 #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0xeb/0x467 mm/kasan/report.c:313
>  print_report mm/kasan/report.c:429 [inline]
>  kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
>  sock_has_perm security/selinux/hooks.c:4535 [inline]
>  selinux_socket_recvmsg+0x278/0x2b0 security/selinux/hooks.c:4899
>  security_socket_recvmsg+0x5c/0xc0 security/security.c:2223
>  sock_recvmsg net/socket.c:1011 [inline]
>  ____sys_recvmsg+0x23b/0x600 net/socket.c:2711
>  ___sys_recvmsg+0x127/0x200 net/socket.c:2753
>  do_recvmmsg+0x254/0x6d0 net/socket.c:2847
>  __sys_recvmmsg net/socket.c:2926 [inline]
>  __do_sys_recvmmsg net/socket.c:2949 [inline]
>  __se_sys_recvmmsg net/socket.c:2942 [inline]
>  __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2942
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> RIP: 0033:0x7fa488689109
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fa4875dd168 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
> RAX: ffffffffffffffda RBX: 00007fa48879c100 RCX: 00007fa488689109
> RDX: 00000000000005dd RSI: 0000000020000540 RDI: 0000000000000004
> RBP: 00007fa4886e305d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000040012062 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ffd8d55b81f R14: 00007fa4875dd300 R15: 0000000000022000
>  </TASK>
>
> Allocated by task 5468:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:45 [inline]
>  set_alloc_info mm/kasan/common.c:436 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:515 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:474 [inline]
>  __kasan_kmalloc+0xa6/0xd0 mm/kasan/common.c:524
>  kasan_kmalloc include/linux/kasan.h:234 [inline]
>  __do_kmalloc mm/slab.c:3696 [inline]
>  __kmalloc+0x209/0x4d0 mm/slab.c:3705
>  kmalloc include/linux/slab.h:605 [inline]
>  sk_prot_alloc+0x110/0x290 net/core/sock.c:1975
>  sk_alloc+0x36/0x770 net/core/sock.c:2028
>  nr_create+0xb2/0x5f0 net/netrom/af_netrom.c:433
>  __sock_create+0x353/0x790 net/socket.c:1515
>  sock_create net/socket.c:1566 [inline]
>  __sys_socket_create net/socket.c:1603 [inline]
>  __sys_socket_create net/socket.c:1588 [inline]
>  __sys_socket+0x12f/0x240 net/socket.c:1636
>  __do_sys_socket net/socket.c:1649 [inline]
>  __se_sys_socket net/socket.c:1647 [inline]
>  __x64_sys_socket+0x6f/0xb0 net/socket.c:1647
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x46/0xb0
>
> Freed by task 15:
>  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
>  kasan_set_track+0x21/0x30 mm/kasan/common.c:45
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
>  ____kasan_slab_free mm/kasan/common.c:366 [inline]
>  ____kasan_slab_free+0x13d/0x180 mm/kasan/common.c:328
>  kasan_slab_free include/linux/kasan.h:200 [inline]
>  __cache_free mm/slab.c:3425 [inline]
>  kfree+0x113/0x310 mm/slab.c:3796
>  sk_prot_free net/core/sock.c:2011 [inline]
>  __sk_destruct+0x5e5/0x710 net/core/sock.c:2097
>  sk_destruct net/core/sock.c:2112 [inline]
>  __sk_free+0x1a4/0x4a0 net/core/sock.c:2123
>  sk_free+0x78/0xa0 net/core/sock.c:2134
>  sock_put include/net/sock.h:1927 [inline]
>  nr_heartbeat_expiry+0x2de/0x460 net/netrom/nr_timer.c:148
>  call_timer_fn+0x1a5/0x6b0 kernel/time/timer.c:1474
>  expire_timers kernel/time/timer.c:1519 [inline]
>  __run_timers.part.0+0x679/0xa80 kernel/time/timer.c:1790
>  __run_timers kernel/time/timer.c:1768 [inline]
>  run_timer_softirq+0xb3/0x1d0 kernel/time/timer.c:1803
>  __do_softirq+0x29b/0x9c2 kernel/softirq.c:571
>
> The buggy address belongs to the object at ffff8880787ec000
>  which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 1152 bytes inside of
>  2048-byte region [ffff8880787ec000, ffff8880787ec800)
>
> The buggy address belongs to the physical page:
> page:ffffea0001e1fb00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x787ec
> flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000000200 ffffea000099a248 ffffea0001e40888 ffff888011840800
> raw: 0000000000000000 ffff8880787ec000 0000000100000001 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x3420c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_COMP|__GFP_HARDWALL|__GFP_THISNODE), pid 5390, tgid 5382 (syz-executor.5), ts 476769442431, free_ts 475866169421
>  prep_new_page mm/page_alloc.c:2456 [inline]
>  get_page_from_freelist+0x1290/0x3b70 mm/page_alloc.c:4198
>  __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5426
>  __alloc_pages_node include/linux/gfp.h:587 [inline]
>  kmem_getpages mm/slab.c:1363 [inline]
>  cache_grow_begin+0x75/0x350 mm/slab.c:2569
>  cache_alloc_refill+0x27f/0x380 mm/slab.c:2942
>  ____cache_alloc mm/slab.c:3024 [inline]
>  ____cache_alloc mm/slab.c:3007 [inline]
>  __do_cache_alloc mm/slab.c:3253 [inline]
>  slab_alloc mm/slab.c:3295 [inline]
>  __do_kmalloc mm/slab.c:3694 [inline]
>  __kmalloc_track_caller+0x3b0/0x4d0 mm/slab.c:3711
>  __do_krealloc mm/slab_common.c:1185 [inline]
>  krealloc+0x87/0xf0 mm/slab_common.c:1218
>  krealloc_array include/linux/slab.h:660 [inline]
>  snd_pcm_hw_rule_add+0x41c/0x590 sound/core/pcm_lib.c:1133
>  snd_pcm_hw_constraints_init sound/core/pcm_native.c:2582 [inline]
>  snd_pcm_open_substream+0x958/0x1820 sound/core/pcm_native.c:2733
>  snd_pcm_oss_open_file sound/core/oss/pcm_oss.c:2454 [inline]
>  snd_pcm_oss_open.part.0+0x6dc/0x1320 sound/core/oss/pcm_oss.c:2535
>  snd_pcm_oss_open+0x3c/0x50 sound/core/oss/pcm_oss.c:2499
>  soundcore_open+0x44e/0x620 sound/sound_core.c:593
>  chrdev_open+0x266/0x770 fs/char_dev.c:414
>  do_dentry_open+0x4a1/0x11f0 fs/open.c:848
>  do_open fs/namei.c:3520 [inline]
>  path_openat+0x1c71/0x2910 fs/namei.c:3653
>  do_filp_open+0x1aa/0x400 fs/namei.c:3680
>  do_sys_openat2+0x16d/0x4c0 fs/open.c:1278
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1371 [inline]
>  free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1421
>  free_unref_page_prepare mm/page_alloc.c:3343 [inline]
>  free_unref_page+0x19/0x6a0 mm/page_alloc.c:3438
>  kasan_depopulate_vmalloc_pte+0x5c/0x70 mm/kasan/shadow.c:359
>  apply_to_pte_range mm/memory.c:2625 [inline]
>  apply_to_pmd_range mm/memory.c:2669 [inline]
>  apply_to_pud_range mm/memory.c:2705 [inline]
>  apply_to_p4d_range mm/memory.c:2741 [inline]
>  __apply_to_page_range+0x686/0x1030 mm/memory.c:2775
>  kasan_release_vmalloc+0xa7/0xc0 mm/kasan/shadow.c:469
>  __purge_vmap_area_lazy+0x8f9/0x1c50 mm/vmalloc.c:1722
>  drain_vmap_area_work+0x52/0xe0 mm/vmalloc.c:1751
>  process_one_work+0x996/0x1610 kernel/workqueue.c:2289
>  worker_thread+0x665/0x1080 kernel/workqueue.c:2436
>  kthread+0x2e9/0x3a0 kernel/kthread.c:376
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:302
>
> Memory state around the buggy address:
>  ffff8880787ec380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8880787ec400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff8880787ec480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                    ^
>  ffff8880787ec500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8880787ec580: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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

-- 
paul-moore.com

Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B62A38D959
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 08:53:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231691AbhEWGxj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 02:53:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231681AbhEWGxg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 02:53:36 -0400
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE30C06138B
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 23:52:09 -0700 (PDT)
Received: by mail-qk1-x72a.google.com with SMTP id k4so13017614qkd.0
        for <netdev@vger.kernel.org>; Sat, 22 May 2021 23:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3B98/YjFTPMLJUh0/1KRBVA8/76frlg1v110acGzMEg=;
        b=vP9JMOrheZhsSQxdzHTPpsVLOx93NAsnpxVjx7qWDjqiPOA5sPxeKgqLRpH/YuB3hr
         1qe60N79JPZxkEv0X6phzI4CifdnGlE+t6Nva9C3zQZovpMGOkVp5lmoGr777iNT03W0
         v5F8fmk7Xq+CA6TOZstNVcgk9PqWhgYDqQBQfDPEEDpbdsZDINL7kkzeDTqoBYqnH6zs
         sIYXQ+TeL+b7KMd+a72+xHzcSrboJGUiVE8RzEzhdLf1wC2DqY0uTNbNPFHzgYorXpOY
         9raAazXFrPu6VKjQ1jxhlUBJEICMCHM7VJIPNiT7EKV+xi5+Qpw3AmZTtIcTUB3thFmP
         lBAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3B98/YjFTPMLJUh0/1KRBVA8/76frlg1v110acGzMEg=;
        b=ZiDYZhQHvNFwlg8lyOV7R/JpTfnHGQiqKf22Byiy4VOcb1Md5+RLYwv5krKjhyzxju
         u3AWq3CTwnB6/pH3ZEcpENlAjXM2vJ08udL/REsbXg8KhY2y+tpeigBUGdPDI20LkVJM
         rajQqRgwpWXeBpkmO3pj99JNepzJs41GMIZSos08pJOk8mC/UBnIJieMRyUmZkkHB4AB
         NNiBmjURETAuoSNUwNEa+o/eznaa5Ga0S99580dKTa70f0lI0oSMIgLz1tf9MQKcY84s
         kqdWPRw12Dyg+duMvArOD5T4Lw2/xLuLJop/I2oY4442p8KMPMScDekyp8IphLtFv4L1
         qN2Q==
X-Gm-Message-State: AOAM533EtMwahQh3b50h7xRSnAkkU6r5YRBbjdVVM+GremV9UpK3u442
        T+CHT83T79nWVxSHYPXfSGPdV/cS2509AV7E1uQ4iw==
X-Google-Smtp-Source: ABdhPJybtfNNH0p75laysKYjeecXDAfkDnX74lkQEOtFjdMIaaxxvonlEZuLerS023UXGnaoGTPnypA/Te66B8HZiWU=
X-Received: by 2002:a37:4694:: with SMTP id t142mr22939783qka.265.1621752727959;
 Sat, 22 May 2021 23:52:07 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000f034fc05c2da6617@google.com>
In-Reply-To: <000000000000f034fc05c2da6617@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Sun, 23 May 2021 08:51:56 +0200
Message-ID: <CACT4Y+ZGkye_MnNr92qQameXVEHNc1QkpmNrG3W8Yd1Xg_hfhw@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in check_all_holdout_tasks_trace
To:     syzbot <syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com>,
        rcu@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Shakeel Butt <shakeelb@google.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 21, 2021 at 7:29 PM syzbot
<syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com> wrote:
>
> Hello,
>
> syzbot found the following issue on:
>
> HEAD commit:    f18ba26d libbpf: Add selftests for TC-BPF management API
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=17f50d1ed00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=8ff54addde0afb5d
> dashboard link: https://syzkaller.appspot.com/bug?extid=7b2b13f4943374609532
>
> Unfortunately, I don't have any reproducer for this issue yet.
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+7b2b13f4943374609532@syzkaller.appspotmail.com

This looks rcu-related. +rcu mailing list

> ==================================================================
> BUG: KASAN: use-after-free in check_all_holdout_tasks_trace+0x302/0x420 kernel/rcu/tasks.h:1084
> Read of size 1 at addr ffff88802767a05c by task rcu_tasks_trace/12
>
> CPU: 0 PID: 12 Comm: rcu_tasks_trace Not tainted 5.12.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  __dump_stack lib/dump_stack.c:79 [inline]
>  dump_stack+0x141/0x1d7 lib/dump_stack.c:120
>  print_address_description.constprop.0.cold+0x5b/0x2f8 mm/kasan/report.c:233
>  __kasan_report mm/kasan/report.c:419 [inline]
>  kasan_report.cold+0x7c/0xd8 mm/kasan/report.c:436
>  check_all_holdout_tasks_trace+0x302/0x420 kernel/rcu/tasks.h:1084
>  rcu_tasks_wait_gp+0x594/0xa60 kernel/rcu/tasks.h:358
>  rcu_tasks_kthread+0x31c/0x6a0 kernel/rcu/tasks.h:224
>  kthread+0x3b1/0x4a0 kernel/kthread.c:313
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> Allocated by task 8477:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:428 [inline]
>  __kasan_slab_alloc+0x84/0xa0 mm/kasan/common.c:461
>  kasan_slab_alloc include/linux/kasan.h:236 [inline]
>  slab_post_alloc_hook mm/slab.h:524 [inline]
>  slab_alloc_node mm/slub.c:2912 [inline]
>  kmem_cache_alloc_node+0x269/0x3e0 mm/slub.c:2948
>  alloc_task_struct_node kernel/fork.c:171 [inline]
>  dup_task_struct kernel/fork.c:865 [inline]
>  copy_process+0x5c8/0x7120 kernel/fork.c:1947
>  kernel_clone+0xe7/0xab0 kernel/fork.c:2503
>  __do_sys_clone+0xc8/0x110 kernel/fork.c:2620
>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Freed by task 12:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_set_track+0x1c/0x30 mm/kasan/common.c:46
>  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:357
>  ____kasan_slab_free mm/kasan/common.c:360 [inline]
>  ____kasan_slab_free mm/kasan/common.c:325 [inline]
>  __kasan_slab_free+0xfb/0x130 mm/kasan/common.c:368
>  kasan_slab_free include/linux/kasan.h:212 [inline]
>  slab_free_hook mm/slub.c:1581 [inline]
>  slab_free_freelist_hook+0xdf/0x240 mm/slub.c:1606
>  slab_free mm/slub.c:3166 [inline]
>  kmem_cache_free+0x8a/0x740 mm/slub.c:3182
>  __put_task_struct+0x26f/0x400 kernel/fork.c:747
>  trc_wait_for_one_reader kernel/rcu/tasks.h:935 [inline]
>  check_all_holdout_tasks_trace+0x179/0x420 kernel/rcu/tasks.h:1081
>  rcu_tasks_wait_gp+0x594/0xa60 kernel/rcu/tasks.h:358
>  rcu_tasks_kthread+0x31c/0x6a0 kernel/rcu/tasks.h:224
>  kthread+0x3b1/0x4a0 kernel/kthread.c:313
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
>
> Last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>  __call_rcu kernel/rcu/tree.c:3038 [inline]
>  call_rcu+0xb1/0x750 kernel/rcu/tree.c:3113
>  put_task_struct_rcu_user+0x7f/0xb0 kernel/exit.c:180
>  release_task+0xca1/0x1690 kernel/exit.c:226
>  wait_task_zombie kernel/exit.c:1108 [inline]
>  wait_consider_task+0x2fb5/0x3b40 kernel/exit.c:1335
>  do_wait_thread kernel/exit.c:1398 [inline]
>  do_wait+0x724/0xd40 kernel/exit.c:1515
>  kernel_wait4+0x14c/0x260 kernel/exit.c:1678
>  __do_sys_wait4+0x13f/0x150 kernel/exit.c:1706
>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Second to last potentially related work creation:
>  kasan_save_stack+0x1b/0x40 mm/kasan/common.c:38
>  kasan_record_aux_stack+0xe5/0x110 mm/kasan/generic.c:345
>  __call_rcu kernel/rcu/tree.c:3038 [inline]
>  call_rcu+0xb1/0x750 kernel/rcu/tree.c:3113
>  put_task_struct_rcu_user+0x7f/0xb0 kernel/exit.c:180
>  context_switch kernel/sched/core.c:4342 [inline]
>  __schedule+0x91e/0x23e0 kernel/sched/core.c:5147
>  preempt_schedule_common+0x45/0xc0 kernel/sched/core.c:5307
>  preempt_schedule_thunk+0x16/0x18 arch/x86/entry/thunk_64.S:35
>  try_to_wake_up+0xa12/0x14b0 kernel/sched/core.c:3489
>  wake_up_process kernel/sched/core.c:3552 [inline]
>  wake_up_q+0x96/0x100 kernel/sched/core.c:597
>  futex_wake+0x3e9/0x490 kernel/futex.c:1634
>  do_futex+0x326/0x1780 kernel/futex.c:3738
>  __do_sys_futex+0x2a2/0x470 kernel/futex.c:3796
>  do_syscall_64+0x3a/0xb0 arch/x86/entry/common.c:47
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The buggy address belongs to the object at ffff888027679c40
>  which belongs to the cache task_struct of size 6976
> The buggy address is located 1052 bytes inside of
>  6976-byte region [ffff888027679c40, ffff88802767b780)
> The buggy address belongs to the page:
> page:ffffea00009d9e00 refcount:1 mapcount:0 mapping:0000000000000000 index:0xffff88802767b880 pfn:0x27678
> head:ffffea00009d9e00 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 ffffea000071e208 ffffea0000950808 ffff888140005140
> raw: ffff88802767b880 0000000000040003 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 243, ts 14372676818, free_ts 0
>  prep_new_page mm/page_alloc.c:2358 [inline]
>  get_page_from_freelist+0x1033/0x2b60 mm/page_alloc.c:3994
>  __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5200
>  alloc_pages+0x18c/0x2a0 mm/mempolicy.c:2272
>  alloc_slab_page mm/slub.c:1644 [inline]
>  allocate_slab+0x2c5/0x4c0 mm/slub.c:1784
>  new_slab mm/slub.c:1847 [inline]
>  new_slab_objects mm/slub.c:2593 [inline]
>  ___slab_alloc+0x44c/0x7a0 mm/slub.c:2756
>  __slab_alloc.constprop.0+0xa7/0xf0 mm/slub.c:2796
>  slab_alloc_node mm/slub.c:2878 [inline]
>  kmem_cache_alloc_node+0x12f/0x3e0 mm/slub.c:2948
>  alloc_task_struct_node kernel/fork.c:171 [inline]
>  dup_task_struct kernel/fork.c:865 [inline]
>  copy_process+0x5c8/0x7120 kernel/fork.c:1947
>  kernel_clone+0xe7/0xab0 kernel/fork.c:2503
>  kernel_thread+0xb5/0xf0 kernel/fork.c:2555
>  call_usermodehelper_exec_work kernel/umh.c:174 [inline]
>  call_usermodehelper_exec_work+0xcc/0x180 kernel/umh.c:160
>  process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
>  worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
>  kthread+0x3b1/0x4a0 kernel/kthread.c:313
>  ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff888027679f00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888027679f80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88802767a000: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                     ^
>  ffff88802767a080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88802767a100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/000000000000f034fc05c2da6617%40google.com.

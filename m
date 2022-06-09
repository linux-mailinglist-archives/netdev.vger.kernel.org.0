Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F5C3544314
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 07:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238226AbiFIFX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 01:23:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230391AbiFIFX2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 01:23:28 -0400
Received: from mail-vk1-xa32.google.com (mail-vk1-xa32.google.com [IPv6:2607:f8b0:4864:20::a32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6A9387B1;
        Wed,  8 Jun 2022 22:23:26 -0700 (PDT)
Received: by mail-vk1-xa32.google.com with SMTP id g15so6606711vkm.0;
        Wed, 08 Jun 2022 22:23:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y8LOAUGx+7ZOJ0YW/Z32MJjE6RY2eEgqF1wtJSUBc5Q=;
        b=GHB0B2y0X+7xLMbUNiQWBFH22gQXxnwgkM47xiTbojpFut3v+WQw+beYFZcOLXgBfs
         fb2s4QzwjwOSurx435DO6mrKUZaM3R9YCWhs0U69POW+oopw79PC3HCsetijAR6L1487
         ygqUuyFCMCqIU/6fN3RWlWyvLaADrrMkFWckZZgX7s4ElH3cJ64bmczPaTmvJupR+3Lz
         aK0A+y/ELTwtjMw3PCFGbZzlP1npTWQ8Cqspw9t+GDNL/w9IhZoTbVg96HpMoBQDpQnw
         VjJIOixlIV806qtD98CyDwOZ2rz7SEZcskPWsZ0iomZrF0F+ThwwG5HsOPAKXF1eulGv
         gtZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y8LOAUGx+7ZOJ0YW/Z32MJjE6RY2eEgqF1wtJSUBc5Q=;
        b=5CLvtiHCdwmxAkYJ3z3EEMkug1j1Vg8V9S8EpfTCFM9IczqRDnnCjJgps048QQqoWc
         pKzz39tpNb3K6d2bfTVgN0EHSmH0QP3guQ+mQcrJokCuQoQKJQOQjnO+SgeLp+1hVB8U
         QFm0iww2+XAB2Z4+UnP5HhGghkNbZsti5apnyPshZrEDCUgS7htubelXsJunM+5Ggpz3
         5HXWiV+JthpEPWUcmx+WV5sAAewfxqEO2tdES/M0rgYHz4hh8UlRREzzP8i297ze0PNX
         tqm8BXOH12q3TOYuSusEcl7iZPXjRI9j2hH6FYczhk5EUqngyQvF7Q8WJTCG+Pme7paM
         eumw==
X-Gm-Message-State: AOAM530HTsFNpFRQpEMG0WkGf6ccWoRKn4ERzYRYBVyovQlbxDx/eJ9G
        axickNBUAlQkNbbx3K0rXfHpNXjyffPPrNnkWe3KGPUaycLDaA==
X-Google-Smtp-Source: ABdhPJwVTiJ4BpNeuYQniJN913Th/LEHMkPFhB8ZeTs2KQtzfDZymPPnUl7VJNKra3BSX0Wt/A2uK6vHznvs708Ow2c=
X-Received: by 2002:a05:6122:1904:b0:35e:74c4:5366 with SMTP id
 bw4-20020a056122190400b0035e74c45366mr4978134vkb.12.1654752205401; Wed, 08
 Jun 2022 22:23:25 -0700 (PDT)
MIME-Version: 1.0
References: <00000000000022208805e0df247a@google.com> <CAJnrk1YyQnBGd9j_89vYxeZy0NWOGW=yJ+kdxYPvGPGpScX4dQ@mail.gmail.com>
In-Reply-To: <CAJnrk1YyQnBGd9j_89vYxeZy0NWOGW=yJ+kdxYPvGPGpScX4dQ@mail.gmail.com>
From:   Joanne Koong <joannelkoong@gmail.com>
Date:   Wed, 8 Jun 2022 22:23:14 -0700
Message-ID: <CAJnrk1ZXe_mTW4Y=tNhP5K-cH9r0K_BEgrZM6Gxxj+n95on6aA@mail.gmail.com>
Subject: Re: [syzbot] KASAN: use-after-free Read in inet_bind2_bucket_find
To:     syzbot <syzbot+98fd2d1422063b0f8c44@syzkaller.appspotmail.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>, dsahern@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, kuniyu@amazon.co.jp,
        linux-kernel@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs@googlegroups.com, Yonghong Song <yhs@fb.com>,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 7, 2022 at 1:20 PM Joanne Koong <joannelkoong@gmail.com> wrote:
>
> On Tue, Jun 7, 2022 at 10:44 AM syzbot
> <syzbot+98fd2d1422063b0f8c44@syzkaller.appspotmail.com> wrote:
> >
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    664a393a2663 Merge tag 'input-for-v5.19-rc0' of git://git...
> > git tree:       upstream
> > console+strace: https://syzkaller.appspot.com/x/log.txt?x=10c9bf5bf00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=9b19cdd2d45cc221
> > dashboard link: https://syzkaller.appspot.com/bug?extid=98fd2d1422063b0f8c44
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=154a123df00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13b9d8cdf00000
> >
> > The issue was bisected to:
> >
> > commit d5a42de8bdbe25081f07b801d8b35f4d75a791f4
> > Author: Joanne Koong <joannelkoong@gmail.com>
> > Date:   Fri May 20 00:18:33 2022 +0000
> >
> >     net: Add a second bind table hashed by port and address
> >
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15c72eedf00000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=17c72eedf00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=13c72eedf00000
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+98fd2d1422063b0f8c44@syzkaller.appspotmail.com
> > Fixes: d5a42de8bdbe ("net: Add a second bind table hashed by port and address")
> >
> > ==================================================================
> > BUG: KASAN: use-after-free in read_pnet include/net/net_namespace.h:361 [inline]
> > BUG: KASAN: use-after-free in ib2_net include/net/inet_hashtables.h:116 [inline]
> > BUG: KASAN: use-after-free in check_bind2_bucket_match net/ipv4/inet_hashtables.c:765 [inline]
> > BUG: KASAN: use-after-free in inet_bind2_bucket_find+0x562/0x620 net/ipv4/inet_hashtables.c:819
> > Read of size 8 at addr ffff888020cbc980 by task syz-executor537/3958
> >
> > CPU: 0 PID: 3958 Comm: syz-executor537 Not tainted 5.18.0-syzkaller-11080-g664a393a2663 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  print_address_description.constprop.0.cold+0xeb/0x495 mm/kasan/report.c:313
> >  print_report mm/kasan/report.c:429 [inline]
> >  kasan_report.cold+0xf4/0x1c6 mm/kasan/report.c:491
> >  read_pnet include/net/net_namespace.h:361 [inline]
> >  ib2_net include/net/inet_hashtables.h:116 [inline]
> >  check_bind2_bucket_match net/ipv4/inet_hashtables.c:765 [inline]
> >  inet_bind2_bucket_find+0x562/0x620 net/ipv4/inet_hashtables.c:819
> >  __inet_hash_connect+0xaaa/0x1450 net/ipv4/inet_hashtables.c:949
> >  dccp_v4_connect+0xc5c/0x16f0 net/dccp/ipv4.c:108
> >  __inet_stream_connect+0x8cf/0xed0 net/ipv4/af_inet.c:660
> >  inet_stream_connect+0x53/0xa0 net/ipv4/af_inet.c:724
> >  __sys_connect_file+0x14f/0x190 net/socket.c:1979
> >  io_connect+0x15f/0x690 fs/io_uring.c:6724
> >  io_issue_sqe+0x40c6/0xa9c0 fs/io_uring.c:8351
> >  io_queue_sqe fs/io_uring.c:8706 [inline]
> >  io_req_task_submit+0xce/0x400 fs/io_uring.c:3066
> >  handle_tw_list fs/io_uring.c:2938 [inline]
> >  tctx_task_work+0x16a/0xe10 fs/io_uring.c:2967
> >  task_work_run+0xdd/0x1a0 kernel/task_work.c:177
> >  ptrace_notify+0x114/0x140 kernel/signal.c:2372
> >  ptrace_report_syscall include/linux/ptrace.h:427 [inline]
> >  ptrace_report_syscall_exit include/linux/ptrace.h:489 [inline]
> >  syscall_exit_work kernel/entry/common.c:249 [inline]
> >  syscall_exit_to_user_mode_prepare+0xdb/0x230 kernel/entry/common.c:276
> >  __syscall_exit_to_user_mode_work kernel/entry/common.c:281 [inline]
> >  syscall_exit_to_user_mode+0x9/0x50 kernel/entry/common.c:294
> >  do_syscall_64+0x42/0xb0 arch/x86/entry/common.c:86
> >  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> > RIP: 0033:0x7f0041a50b99
> > Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
> > RSP: 002b:00007f0041a022f8 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> > RAX: 0000000000000200 RBX: 00007f0041ad8428 RCX: 00007f0041a50b99
> > RDX: 0000000000000000 RSI: 00000000000045f5 RDI: 0000000000000003
> > RBP: 00007f0041ad8420 R08: 0000000000000000 R09: 0000000000000004
> > R10: 0000000000000009 R11: 0000000000000246 R12: 00007f0041aa6064
> > R13: 0000000000000003 R14: 00007f0041a02400 R15: 0000000000022000
> >  </TASK>
> >
> > Allocated by task 3861:
> >  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
> >  kasan_set_track mm/kasan/common.c:45 [inline]
> >  set_alloc_info mm/kasan/common.c:436 [inline]
> >  __kasan_slab_alloc+0x90/0xc0 mm/kasan/common.c:469
> >  kasan_slab_alloc include/linux/kasan.h:224 [inline]
> >  slab_post_alloc_hook mm/slab.h:750 [inline]
> >  slab_alloc_node mm/slub.c:3214 [inline]
> >  slab_alloc mm/slub.c:3222 [inline]
> >  __kmem_cache_alloc_lru mm/slub.c:3229 [inline]
> >  kmem_cache_alloc+0x204/0x3b0 mm/slub.c:3239
> >  inet_bind2_bucket_create+0x37/0x360 net/ipv4/inet_hashtables.c:91
> >  __inet_hash_connect+0xef5/0x1450 net/ipv4/inet_hashtables.c:951
> >  dccp_v4_connect+0xc5c/0x16f0 net/dccp/ipv4.c:108
> >  __inet_stream_connect+0x8cf/0xed0 net/ipv4/af_inet.c:660
> >  inet_stream_connect+0x53/0xa0 net/ipv4/af_inet.c:724
> >  __sys_connect_file+0x14f/0x190 net/socket.c:1979
> >  io_connect+0x15f/0x690 fs/io_uring.c:6724
> >  io_issue_sqe+0x40c6/0xa9c0 fs/io_uring.c:8351
> >  io_queue_sqe fs/io_uring.c:8706 [inline]
> >  io_submit_sqe fs/io_uring.c:8968 [inline]
> >  io_submit_sqes+0x16b0/0x8020 fs/io_uring.c:9079
> >  __do_sys_io_uring_enter+0x117f/0x2360 fs/io_uring.c:12008
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >
> > Freed by task 3861:
> >  kasan_save_stack+0x1e/0x40 mm/kasan/common.c:38
> >  kasan_set_track+0x21/0x30 mm/kasan/common.c:45
> >  kasan_set_free_info+0x20/0x30 mm/kasan/generic.c:370
> >  ____kasan_slab_free mm/kasan/common.c:366 [inline]
> >  ____kasan_slab_free+0x166/0x1a0 mm/kasan/common.c:328
> >  kasan_slab_free include/linux/kasan.h:200 [inline]
> >  slab_free_hook mm/slub.c:1727 [inline]
> >  slab_free_freelist_hook+0x8b/0x1c0 mm/slub.c:1753
> >  slab_free mm/slub.c:3507 [inline]
> >  kmem_cache_free+0xdd/0x5a0 mm/slub.c:3524
> >  inet_bind2_bucket_destroy net/ipv4/inet_hashtables.c:137 [inline]
> >  inet_bind2_bucket_destroy net/ipv4/inet_hashtables.c:133 [inline]
> >  __inet_put_port net/ipv4/inet_hashtables.c:174 [inline]
> >  inet_put_port+0x4a0/0x6f0 net/ipv4/inet_hashtables.c:182
> >  dccp_set_state+0x1be/0x3a0 net/dccp/proto.c:103
> >  dccp_done+0x19/0x100 net/dccp/proto.c:138
> >  dccp_rcv_state_process+0xc31/0x1820 net/dccp/input.c:662
> >  dccp_v4_do_rcv+0xf9/0x1a0 net/dccp/ipv4.c:695
> >  sk_backlog_rcv include/net/sock.h:1061 [inline]
> >  __release_sock+0x134/0x3b0 net/core/sock.c:2849
> >  release_sock+0x54/0x1b0 net/core/sock.c:3404
> >  inet_stream_connect+0x76/0xa0 net/ipv4/af_inet.c:725
> >  __sys_connect_file+0x14f/0x190 net/socket.c:1979
> >  io_connect+0x15f/0x690 fs/io_uring.c:6724
> >  io_issue_sqe+0x40c6/0xa9c0 fs/io_uring.c:8351
> >  io_queue_sqe fs/io_uring.c:8706 [inline]
> >  io_submit_sqe fs/io_uring.c:8968 [inline]
> >  io_submit_sqes+0x16b0/0x8020 fs/io_uring.c:9079
> >  __do_sys_io_uring_enter+0x117f/0x2360 fs/io_uring.c:12008
> >  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >  entry_SYSCALL_64_after_hwframe+0x46/0xb0
> >
> > The buggy address belongs to the object at ffff888020cbc980
> >  which belongs to the cache dccp_bind2_bucket of size 56
> > The buggy address is located 0 bytes inside of
> >  56-byte region [ffff888020cbc980, ffff888020cbc9b8)
> >
> > The buggy address belongs to the physical page:
> > page:ffffea0000832f00 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x20cbc
> > flags: 0xfff00000000200(slab|node=0|zone=1|lastcpupid=0x7ff)
> > raw: 00fff00000000200 0000000000000000 dead000000000122 ffff88802393ca00
> > raw: 0000000000000000 0000000000200020 00000001ffffffff 0000000000000000
> > page dumped because: kasan: bad access detected
> > page_owner tracks the page as allocated
> > page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12a20(GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY), pid 3856, tgid 3855 (syz-executor537), ts 156131029362, free_ts 153495137859
> >  prep_new_page mm/page_alloc.c:2456 [inline]
> >  get_page_from_freelist+0x1290/0x3b70 mm/page_alloc.c:4198
> >  __alloc_pages+0x1c7/0x510 mm/page_alloc.c:5426
> >  alloc_pages+0x1aa/0x310 mm/mempolicy.c:2272
> >  alloc_slab_page mm/slub.c:1797 [inline]
> >  allocate_slab+0x26c/0x3c0 mm/slub.c:1942
> >  new_slab mm/slub.c:2002 [inline]
> >  ___slab_alloc+0x985/0xd90 mm/slub.c:3002
> >  __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3089
> >  slab_alloc_node mm/slub.c:3180 [inline]
> >  slab_alloc mm/slub.c:3222 [inline]
> >  __kmem_cache_alloc_lru mm/slub.c:3229 [inline]
> >  kmem_cache_alloc+0x360/0x3b0 mm/slub.c:3239
> >  inet_bind2_bucket_create+0x37/0x360 net/ipv4/inet_hashtables.c:91
> >  __inet_hash_connect+0xef5/0x1450 net/ipv4/inet_hashtables.c:951
> >  dccp_v4_connect+0xc5c/0x16f0 net/dccp/ipv4.c:108
> >  __inet_stream_connect+0x8cf/0xed0 net/ipv4/af_inet.c:660
> >  inet_stream_connect+0x53/0xa0 net/ipv4/af_inet.c:724
> >  __sys_connect_file+0x14f/0x190 net/socket.c:1979
> >  io_connect+0x15f/0x690 fs/io_uring.c:6724
> >  io_issue_sqe+0x40c6/0xa9c0 fs/io_uring.c:8351
> >  io_queue_sqe fs/io_uring.c:8706 [inline]
> >  io_submit_sqe fs/io_uring.c:8968 [inline]
> >  io_submit_sqes+0x16b0/0x8020 fs/io_uring.c:9079
> > page last free stack trace:
> >  reset_page_owner include/linux/page_owner.h:24 [inline]
> >  free_pages_prepare mm/page_alloc.c:1371 [inline]
> >  free_pcp_prepare+0x549/0xd20 mm/page_alloc.c:1421
> >  free_unref_page_prepare mm/page_alloc.c:3343 [inline]
> >  free_unref_page+0x19/0x6a0 mm/page_alloc.c:3438
> >  __unfreeze_partials+0x17c/0x1a0 mm/slub.c:2521
> >  qlink_free mm/kasan/quarantine.c:168 [inline]
> >  qlist_free_all+0x6a/0x170 mm/kasan/quarantine.c:187
> >  kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:294
> >  __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:446
> >  kasan_slab_alloc include/linux/kasan.h:224 [inline]
> >  slab_post_alloc_hook mm/slab.h:750 [inline]
> >  slab_alloc_node mm/slub.c:3214 [inline]
> >  kmem_cache_alloc_node+0x255/0x3f0 mm/slub.c:3264
> >  __alloc_skb+0x215/0x340 net/core/skbuff.c:414
> >  alloc_skb include/linux/skbuff.h:1426 [inline]
> >  dccp_connect+0x204/0x720 net/dccp/output.c:560
> >  dccp_v4_connect+0x1140/0x16f0 net/dccp/ipv4.c:128
> >  __inet_stream_connect+0x8cf/0xed0 net/ipv4/af_inet.c:660
> >  inet_stream_connect+0x53/0xa0 net/ipv4/af_inet.c:724
> >  __sys_connect_file+0x14f/0x190 net/socket.c:1979
> >  io_connect+0x15f/0x690 fs/io_uring.c:6724
> >  io_issue_sqe+0x40c6/0xa9c0 fs/io_uring.c:8351
> >  io_queue_sqe fs/io_uring.c:8706 [inline]
> >  io_submit_sqe fs/io_uring.c:8968 [inline]
> >  io_submit_sqes+0x16b0/0x8020 fs/io_uring.c:9079
> >
> > Memory state around the buggy address:
> >  ffff888020cbc880: fa fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
> >  ffff888020cbc900: fa fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
> > >ffff888020cbc980: fa fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
> >                    ^
> >  ffff888020cbca00: fa fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
> >  ffff888020cbca80: fa fb fb fb fb fb fb fc fc fc fc fc fc fc fc fc
> > ==================================================================
> >
> I will look into where inet_bind_bucket_create gets passed in a NULL
> net and submit a follow-up.
> >
I think this will be fixed when a separate lock is added for the bhash2 table.
From the logs, it looks like there were two sockets on different port
numbers that hashed to the same bhash2 hashbucket and were being
accessed at the same time (eg one freeing the bind2 bucket from the
cache, one iterating through the list of the hashbucket's bind2
buckets and checking the bucket that was getting freed right as it was
getting freed)

> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches

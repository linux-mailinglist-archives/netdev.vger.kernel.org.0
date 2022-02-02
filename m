Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A874A7563
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 17:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345711AbiBBQE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 11:04:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345625AbiBBQE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 11:04:57 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE10EC06173D;
        Wed,  2 Feb 2022 08:04:56 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id q63so20632216pja.1;
        Wed, 02 Feb 2022 08:04:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aNuQvBe7j5cv8tDrKLiSJdatSHQjWEnR2roLR+pwH1w=;
        b=EvPO+OhimaaOj2cYwGaj54jQXe1PTsCA7+WdCaaOK3knKLtQJeD2WtWyXILtV3S/0P
         AziP0VjTNpAIcyVxbfs2gf7eOUF12xWd4sB63rPITHDwKzfjbhJ3cDb3uI+9G7y7x1Xi
         6F0wRLWGpRg3cw0crnl/kDuuB3PVYwj0KXw6QHv59yFWkXR1EJGy9v84j4d1jrv1KTRC
         Qk8oO92/8DEV5QxBhx3mojWEXT1I9qDvnnIrX/87P5lyCqRy584UWZ2uV7twT3gPhCqh
         TLrlxagGYIi51P3FTwq+4yGHKEOoC4PmbThebUpF0D92Is4XWffXflgRJkprr7cEPsTj
         MC/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aNuQvBe7j5cv8tDrKLiSJdatSHQjWEnR2roLR+pwH1w=;
        b=U78Aos4k+9uG8AlFTDYGXL1kvpMdI7XviKYC2Vq2TOCK+QCvPRqevVpQrO8WmriigG
         sHDxVH7gw4wchuBX+kzSsdc6+MF8H1RztLX35AQ6JSurqN3E4PZ4YUg5nLI1nokssziC
         j2u+HCUNKWuvmiQHDNyQljXMXzAOaMkR05mraQ6kT6y7a74fm3P1gjuZnvoHV3x1kkn8
         cwxZo3RMV3yE4zMrWteUyN7DVgnFxJZmgOr3Ff6wh4l5u3eW8Hd02d2aL+a/o+opE5oz
         zNzXmyUTksjnWnjVtXtG4mlhzrel5HdKg26r1bAr3cAcPti14EVGuX+1+d94ul6pIsyM
         WREA==
X-Gm-Message-State: AOAM531EpLJL8X4YazJc0tBfIqo7t+7mbteDE0unnuf06swFjV+IfSPQ
        C7PdOs6WAh0zkkO/7xbMuv4By7WyIeFgedIHx3Q=
X-Google-Smtp-Source: ABdhPJzainhgM8qUrOAedZw6WGf+RGp+SMmxpL+JPrhtAaMhuxloYI67n94mMfDELeTzMV5X4T0ZhT9eKw32fDLDFzM=
X-Received: by 2002:a17:90b:1e41:: with SMTP id pi1mr8665184pjb.62.1643817896192;
 Wed, 02 Feb 2022 08:04:56 -0800 (PST)
MIME-Version: 1.0
References: <000000000000df66a505d68df8d1@google.com> <000000000000d4b6fd05d708ab03@google.com>
In-Reply-To: <000000000000d4b6fd05d708ab03@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 2 Feb 2022 08:04:44 -0800
Message-ID: <CAADnVQLjvX54EXbiWC2yXAomypwYoc3MmEdp7fHxG+Zse+83Pw@mail.gmail.com>
Subject: Re: [syzbot] KASAN: slab-out-of-bounds Write in bpf_prog_test_run_xdp
To:     syzbot <syzbot+6d70ca7438345077c549@syzkaller.appspotmail.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        KP Singh <kpsingh@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lorenzo, please take a look. I suspect it's xdp frags related.

On Wed, Feb 2, 2022 at 5:05 AM syzbot
<syzbot+6d70ca7438345077c549@syzkaller.appspotmail.com> wrote:
>
> syzbot has found a reproducer for the following issue on:
>
> HEAD commit:    dd5152ab338c Merge branch 'bpf-btf-dwarf5'
> git tree:       bpf-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=15b770dbb00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=b210f94c3ec14b22
> dashboard link: https://syzkaller.appspot.com/bug?extid=6d70ca7438345077c549
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10044d98700000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1613fa8fb00000
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6d70ca7438345077c549@syzkaller.appspotmail.com
>
> ==================================================================
> BUG: KASAN: slab-out-of-bounds in __skb_frag_set_page include/linux/skbuff.h:3242 [inline]
> BUG: KASAN: slab-out-of-bounds in bpf_prog_test_run_xdp+0x10ac/0x1150 net/bpf/test_run.c:972
> Write of size 8 at addr ffff88801dc53000 by task syz-executor098/3592
>
> CPU: 1 PID: 3592 Comm: syz-executor098 Not tainted 5.16.0-syzkaller-11587-gdd5152ab338c #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> Call Trace:
>  <TASK>
>  __dump_stack lib/dump_stack.c:88 [inline]
>  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
>  print_address_description.constprop.0.cold+0x8d/0x336 mm/kasan/report.c:255
>  __kasan_report mm/kasan/report.c:442 [inline]
>  kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
>  __skb_frag_set_page include/linux/skbuff.h:3242 [inline]
>  bpf_prog_test_run_xdp+0x10ac/0x1150 net/bpf/test_run.c:972
>  bpf_prog_test_run kernel/bpf/syscall.c:3356 [inline]
>  __sys_bpf+0x1858/0x59a0 kernel/bpf/syscall.c:4658
>  __do_sys_bpf kernel/bpf/syscall.c:4744 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4742 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4742
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7fada7c9e229
> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff58406588 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fada7c9e229
> RDX: 0000000000000048 RSI: 0000000020000000 RDI: 000000000000000a
> RBP: 00007fada7c62210 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007fada7c622a0
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
>
> Allocated by task 3592:
>  kasan_save_stack+0x1e/0x50 mm/kasan/common.c:38
>  kasan_set_track mm/kasan/common.c:46 [inline]
>  set_alloc_info mm/kasan/common.c:437 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:516 [inline]
>  ____kasan_kmalloc mm/kasan/common.c:475 [inline]
>  __kasan_kmalloc+0xa9/0xd0 mm/kasan/common.c:525
>  kmalloc include/linux/slab.h:586 [inline]
>  kzalloc include/linux/slab.h:715 [inline]
>  bpf_test_init.isra.0+0x9f/0x150 net/bpf/test_run.c:411
>  bpf_prog_test_run_xdp+0x2f8/0x1150 net/bpf/test_run.c:941
>  bpf_prog_test_run kernel/bpf/syscall.c:3356 [inline]
>  __sys_bpf+0x1858/0x59a0 kernel/bpf/syscall.c:4658
>  __do_sys_bpf kernel/bpf/syscall.c:4744 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:4742 [inline]
>  __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:4742
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> The buggy address belongs to the object at ffff88801dc52000
>  which belongs to the cache kmalloc-4k of size 4096
> The buggy address is located 0 bytes to the right of
>  4096-byte region [ffff88801dc52000, ffff88801dc53000)
> The buggy address belongs to the page:
> page:ffffea0000771400 refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1dc50
> head:ffffea0000771400 order:3 compound_mapcount:0 compound_pincount:0
> flags: 0xfff00000010200(slab|head|node=0|zone=1|lastcpupid=0x7ff)
> raw: 00fff00000010200 0000000000000000 dead000000000122 ffff888010c42140
> raw: 0000000000000000 0000000080040004 00000001ffffffff 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 3592, ts 49734537716, free_ts 49716400399
>  prep_new_page mm/page_alloc.c:2434 [inline]
>  get_page_from_freelist+0xa72/0x2f50 mm/page_alloc.c:4165
>  __alloc_pages+0x1b2/0x500 mm/page_alloc.c:5389
>  alloc_pages+0x1aa/0x310 mm/mempolicy.c:2271
>  alloc_slab_page mm/slub.c:1799 [inline]
>  allocate_slab mm/slub.c:1944 [inline]
>  new_slab+0x28a/0x3b0 mm/slub.c:2004
>  ___slab_alloc+0x87c/0xe90 mm/slub.c:3018
>  __slab_alloc.constprop.0+0x4d/0xa0 mm/slub.c:3105
>  slab_alloc_node mm/slub.c:3196 [inline]
>  slab_alloc mm/slub.c:3238 [inline]
>  kmem_cache_alloc_trace+0x289/0x2c0 mm/slub.c:3255
>  kmalloc include/linux/slab.h:581 [inline]
>  kzalloc include/linux/slab.h:715 [inline]
>  ima_calc_file_hash_tfm+0x282/0x3b0 security/integrity/ima/ima_crypto.c:477
>  ima_calc_file_shash security/integrity/ima/ima_crypto.c:515 [inline]
>  ima_calc_file_hash+0x19d/0x4b0 security/integrity/ima/ima_crypto.c:572
>  ima_collect_measurement+0x4c9/0x570 security/integrity/ima/ima_api.c:254
>  process_measurement+0xd37/0x1920 security/integrity/ima/ima_main.c:337
>  ima_bprm_check+0xd0/0x220 security/integrity/ima/ima_main.c:491
>  security_bprm_check+0x7d/0xa0 security/security.c:869
>  search_binary_handler fs/exec.c:1714 [inline]
>  exec_binprm fs/exec.c:1767 [inline]
>  bprm_execve fs/exec.c:1836 [inline]
>  bprm_execve+0x732/0x19b0 fs/exec.c:1798
>  do_execveat_common+0x5e3/0x780 fs/exec.c:1925
>  do_execve fs/exec.c:1993 [inline]
>  __do_sys_execve fs/exec.c:2069 [inline]
>  __se_sys_execve fs/exec.c:2064 [inline]
>  __x64_sys_execve+0x8f/0xc0 fs/exec.c:2064
> page last free stack trace:
>  reset_page_owner include/linux/page_owner.h:24 [inline]
>  free_pages_prepare mm/page_alloc.c:1352 [inline]
>  free_pcp_prepare+0x374/0x870 mm/page_alloc.c:1404
>  free_unref_page_prepare mm/page_alloc.c:3325 [inline]
>  free_unref_page+0x19/0x690 mm/page_alloc.c:3404
>  __unfreeze_partials+0x320/0x340 mm/slub.c:2536
>  qlink_free mm/kasan/quarantine.c:157 [inline]
>  qlist_free_all+0x6d/0x160 mm/kasan/quarantine.c:176
>  kasan_quarantine_reduce+0x180/0x200 mm/kasan/quarantine.c:283
>  __kasan_slab_alloc+0xa2/0xc0 mm/kasan/common.c:447
>  kasan_slab_alloc include/linux/kasan.h:260 [inline]
>  slab_post_alloc_hook mm/slab.h:732 [inline]
>  slab_alloc_node mm/slub.c:3230 [inline]
>  slab_alloc mm/slub.c:3238 [inline]
>  kmem_cache_alloc+0x202/0x3a0 mm/slub.c:3243
>  getname_flags.part.0+0x50/0x4f0 fs/namei.c:138
>  getname_flags+0x9a/0xe0 include/linux/audit.h:323
>  user_path_at_empty+0x2b/0x60 fs/namei.c:2800
>  user_path_at include/linux/namei.h:57 [inline]
>  vfs_statx+0x142/0x390 fs/stat.c:221
>  vfs_fstatat fs/stat.c:243 [inline]
>  __do_sys_newfstatat+0x96/0x120 fs/stat.c:412
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Memory state around the buggy address:
>  ffff88801dc52f00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88801dc52f80: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff88801dc53000: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                    ^
>  ffff88801dc53080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88801dc53100: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> ==================================================================
>

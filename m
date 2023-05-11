Return-Path: <netdev+bounces-1613-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C2E96FE860
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 02:14:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EFF0B2815BA
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 00:14:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 77E62623;
	Thu, 11 May 2023 00:13:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6713A622
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 00:13:57 +0000 (UTC)
Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D27422A
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 17:13:54 -0700 (PDT)
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-769036b47a7so526414439f.0
        for <netdev@vger.kernel.org>; Wed, 10 May 2023 17:13:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683764033; x=1686356033;
        h=content-transfer-encoding:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kpwYvUZfRjlIZVuVnL5DbEC1U/pIjk152uhUoDQJdOs=;
        b=RWmB+oFWL/5lVlku9Lw0s9fxkEShhUmKScYpF2ZMZb4FDDHs05JkFe7E810SLaoTBK
         E8ONnnlT15zONeWGwfOOLWLKVfTLT1OEtU4QarPVq/p1iX3XmUaGCZynown2vFlWc2AI
         io8lZNTtgw7w1yHbxo+7iaOp0MxrKpVzp4nvBchXsFShkwPWsueqrYRVr+lOe4dOz70B
         TxFdKR0FUnrHD2GALmlB86doxCgOgFsdmDwIq3XXZ0H8W86QFYUrn03ofq/OqMF/hpQG
         9Dr8OhbpzP5vMjeFYeeYQAiAof1eGf2ec3Ovb7wVFGbscS024nTxu5PFLM5tzoVDauKo
         e/8Q==
X-Gm-Message-State: AC+VfDzhP063pfIi5/2VUh/3hs3OCn5nKY2wqjRVOQXN9hih+3fWi7sT
	ctqb/2y4FRYwg1s6FAIKKxu6IFJbcusMjDN+rGDH6oDBJ5Ft
X-Google-Smtp-Source: ACHHUZ4GIkLv2E5ocLzQGBrzsgDEnKV9Sw3phR0mDE2iM39WZSx7ujY+orEvwTzZkP7ctu62iHjb3vzPuphNrPu92F0IydMtBDP7
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a5d:8055:0:b0:76c:50ad:8d89 with SMTP id
 b21-20020a5d8055000000b0076c50ad8d89mr4125624ior.3.1683764033463; Wed, 10 May
 2023 17:13:53 -0700 (PDT)
Date: Wed, 10 May 2023 17:13:53 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000019af1d05fb5fdd99@google.com>
Subject: [syzbot] [bpf?] KASAN: slab-out-of-bounds Write in copy_array (2)
From: syzbot <syzbot+d742fd7d34097f949179@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, davem@davemloft.net, haoluo@google.com, hawk@kernel.org, 
	john.fastabend@gmail.com, jolsa@kernel.org, kpsingh@kernel.org, 
	kuba@kernel.org, linux-kernel@vger.kernel.org, llvm@lists.linux.dev, 
	martin.lau@linux.dev, nathan@kernel.org, ndesaulniers@google.com, 
	netdev@vger.kernel.org, sdf@google.com, song@kernel.org, 
	syzkaller-bugs@googlegroups.com, trix@redhat.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

syzbot found the following issue on:

HEAD commit:    950b879b7f02 riscv: Fixup race condition on PG_dcache_clea.=
.
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/riscv/linux.g=
it fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=3D17eaa0c6280000
kernel config:  https://syzkaller.appspot.com/x/.config?x=3Decebece1b90c034=
2
dashboard link: https://syzkaller.appspot.com/bug?extid=3Dd742fd7d34097f949=
179
compiler:       riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110, GN=
U ld (GNU Binutils for Debian) 2.35.2
userspace arch: riscv64

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/5ab=
53d394dbf/non_bootable_disk-950b879b.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/938475579d6c/vmlinux-=
950b879b.xz
kernel image: https://storage.googleapis.com/syzbot-assets/bcf263d8c574/Ima=
ge-950b879b.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit=
:
Reported-by: syzbot+d742fd7d34097f949179@syzkaller.appspotmail.com

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in copy_array+0x8a/0xe8 kernel/bpf/verifier.=
c:1072
Write of size 80 at addr ff6000000e196e80 by task syz-executor.1/5213

CPU: 1 PID: 5213 Comm: syz-executor.1 Tainted: G        W          6.2.0-rc=
1-syzkaller #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000b9ea>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.=
c:121
[<ffffffff83402b96>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:12=
7
[<ffffffff83442726>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff83442726>] dump_stack_lvl+0xe0/0x14c lib/dump_stack.c:106
[<ffffffff83409674>] print_address_description mm/kasan/report.c:306 [inlin=
e]
[<ffffffff83409674>] print_report+0x1e4/0x4c0 mm/kasan/report.c:417
[<ffffffff804ead14>] kasan_report+0xb8/0xe6 mm/kasan/report.c:517
[<ffffffff804ec266>] check_region_inline mm/kasan/generic.c:173 [inline]
[<ffffffff804ec266>] kasan_check_range+0x32/0x148 mm/kasan/generic.c:189
[<ffffffff804ece9a>] memcpy+0x32/0x64 mm/kasan/shadow.c:66
[<ffffffff8029a914>] copy_array+0x8a/0xe8 kernel/bpf/verifier.c:1072
[<ffffffff8029d13e>] copy_verifier_state+0x6c/0x462 kernel/bpf/verifier.c:1=
250
[<ffffffff802c2eae>] pop_stack kernel/bpf/verifier.c:1314 [inline]
[<ffffffff802c2eae>] do_check kernel/bpf/verifier.c:14031 [inline]
[<ffffffff802c2eae>] do_check_common+0x397a/0x6608 kernel/bpf/verifier.c:16=
289
[<ffffffff802cb0da>] do_check_main kernel/bpf/verifier.c:16352 [inline]
[<ffffffff802cb0da>] bpf_check+0x45b2/0x5a5a kernel/bpf/verifier.c:16936
[<ffffffff80291fc0>] bpf_prog_load+0xc90/0x12b0 kernel/bpf/syscall.c:2619
[<ffffffff80295a76>] __sys_bpf+0x622/0x31d2 kernel/bpf/syscall.c:4979
[<ffffffff80298f16>] __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
[<ffffffff80298f16>] sys_bpf+0x28/0x36 kernel/bpf/syscall.c:5081
[<ffffffff80005ff6>] ret_from_syscall+0x0/0x2

Allocated by task 5213:
 stack_trace_save+0xa6/0xd8 kernel/stacktrace.c:122
 kasan_save_stack+0x2c/0x5a mm/kasan/common.c:45
 kasan_set_track+0x1a/0x26 mm/kasan/common.c:52
 kasan_save_alloc_info+0x1a/0x24 mm/kasan/generic.c:507
 ____kasan_kmalloc mm/kasan/common.c:371 [inline]
 ____kasan_kmalloc mm/kasan/common.c:330 [inline]
 __kasan_krealloc+0xfa/0x11a mm/kasan/common.c:439
 kasan_krealloc include/linux/kasan.h:231 [inline]
 __do_krealloc mm/slab_common.c:1361 [inline]
 krealloc+0x82/0xae mm/slab_common.c:1398
 push_jmp_history+0xd2/0x140 kernel/bpf/verifier.c:2592
 is_state_visited kernel/bpf/verifier.c:13552 [inline]
 do_check kernel/bpf/verifier.c:13752 [inline]
 do_check_common+0x47be/0x6608 kernel/bpf/verifier.c:16289
 do_check_main kernel/bpf/verifier.c:16352 [inline]
 bpf_check+0x45b2/0x5a5a kernel/bpf/verifier.c:16936
 bpf_prog_load+0xc90/0x12b0 kernel/bpf/syscall.c:2619
 __sys_bpf+0x622/0x31d2 kernel/bpf/syscall.c:4979
 __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
 sys_bpf+0x28/0x36 kernel/bpf/syscall.c:5081
 ret_from_syscall+0x0/0x2

The buggy address belongs to the object at ff6000000e196e80
 which belongs to the cache kmalloc-96 of size 96
The buggy address is located 0 bytes inside of
 96-byte region [ff6000000e196e80, ff6000000e196ee0)

The buggy address belongs to the physical page:
page:ff1c00000238e580 refcount:1 mapcount:0 mapping:0000000000000000 index:=
0x0 pfn:0x8e396
ksm flags: 0xffe000000000200(slab|node=3D0|zone=3D0|lastcpupid=3D0x7ff)
raw: 0ffe000000000200 ff60000008201780 ff1c0000024db740 0000000000000003
raw: 0000000000000000 0000000080200020 00000001ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x12c40(GF=
P_NOFS|__GFP_NOWARN|__GFP_NORETRY), pid 2674, tgid 2674 (dhcpcd), ts 215113=
436000, free_ts 215046751000
 __set_page_owner+0x32/0x182 mm/page_owner.c:190
 set_page_owner include/linux/page_owner.h:31 [inline]
 post_alloc_hook+0xf8/0x11a mm/page_alloc.c:2524
 prep_new_page mm/page_alloc.c:2531 [inline]
 get_page_from_freelist+0xc0e/0x1118 mm/page_alloc.c:4283
 __alloc_pages+0x1b0/0x165a mm/page_alloc.c:5549
 alloc_pages+0x132/0x25e mm/mempolicy.c:2286
 alloc_slab_page mm/slub.c:1851 [inline]
 allocate_slab mm/slub.c:1998 [inline]
 new_slab+0x270/0x382 mm/slub.c:2051
 ___slab_alloc+0x57e/0xaa6 mm/slub.c:3193
 __slab_alloc.constprop.0+0x5a/0x98 mm/slub.c:3292
 __slab_alloc_node mm/slub.c:3345 [inline]
 slab_alloc_node mm/slub.c:3442 [inline]
 __kmem_cache_alloc_node+0xf2/0x2e4 mm/slub.c:3491
 __do_kmalloc_node mm/slab_common.c:967 [inline]
 __kmalloc+0x34/0xe2 mm/slab_common.c:981
 kmalloc include/linux/slab.h:584 [inline]
 kzalloc include/linux/slab.h:720 [inline]
 tomoyo_get_name+0x1f0/0x2f4 security/tomoyo/memory.c:173
 tomoyo_parse_name_union+0xfa/0x156 security/tomoyo/util.c:260
 tomoyo_update_path_acl security/tomoyo/file.c:395 [inline]
 tomoyo_write_file+0x3f4/0x74e security/tomoyo/file.c:1022
 tomoyo_write_domain2+0x102/0x18c security/tomoyo/common.c:1143
 tomoyo_add_entry security/tomoyo/common.c:2033 [inline]
 tomoyo_supervisor+0x364/0xc08 security/tomoyo/common.c:2094
 tomoyo_audit_path_log security/tomoyo/file.c:168 [inline]
 tomoyo_path_permission security/tomoyo/file.c:587 [inline]
 tomoyo_path_permission+0x152/0x18e security/tomoyo/file.c:573
page last free stack trace:
 __reset_page_owner+0x4a/0xf8 mm/page_owner.c:148
 reset_page_owner include/linux/page_owner.h:24 [inline]
 free_pages_prepare mm/page_alloc.c:1446 [inline]
 free_pcp_prepare+0x254/0x48e mm/page_alloc.c:1496
 free_unref_page_prepare mm/page_alloc.c:3369 [inline]
 free_unref_page+0x60/0x2ae mm/page_alloc.c:3464
 free_the_page mm/page_alloc.c:750 [inline]
 __free_pages+0xd6/0x106 mm/page_alloc.c:5635
 free_pages.part.0+0xd8/0x13a mm/page_alloc.c:5646
 free_pages+0xe/0x18 mm/page_alloc.c:5643
 pgd_free include/asm-generic/pgalloc.h:193 [inline]
 mm_free_pgd kernel/fork.c:737 [inline]
 __mmdrop+0x88/0x2f0 kernel/fork.c:795
 mmdrop include/linux/sched/mm.h:50 [inline]
 mmdrop_sched include/linux/sched/mm.h:78 [inline]
 finish_task_switch.isra.0+0x32e/0x426 kernel/sched/core.c:5148
 context_switch kernel/sched/core.c:5247 [inline]
 __schedule+0x64c/0x1274 kernel/sched/core.c:6555
 schedule+0x7a/0x102 kernel/sched/core.c:6631
 schedule_hrtimeout_range_clock+0x2da/0x2e2 kernel/time/hrtimer.c:2296
 schedule_hrtimeout_range+0x28/0x36 kernel/time/hrtimer.c:2351
 poll_schedule_timeout.constprop.0+0x84/0xde fs/select.c:244
 do_poll fs/select.c:965 [inline]
 do_sys_poll+0x512/0x94a fs/select.c:1015
 __do_sys_ppoll fs/select.c:1121 [inline]
 sys_ppoll+0x18a/0x1b0 fs/select.c:1101
 ret_from_syscall+0x0/0x2

Memory state around the buggy address:
 ff6000000e196d80: 00 00 00 00 00 00 00 00 00 04 fc fc fc fc fc fc
 ff6000000e196e00: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>ff6000000e196e80: 00 00 fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ff6000000e196f00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
 ff6000000e196f80: 00 00 00 00 00 00 00 00 00 00 00 06 fc fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
warn_alloc: 3 callbacks suppressed
syz-executor.1: vmalloc error: size 4096, vm_struct allocation failed, mode=
:0xcc0(GFP_KERNEL), nodemask=3D(null),cpuset=3Dsyz1,mems_allowed=3D0
CPU: 1 PID: 5213 Comm: syz-executor.1 Tainted: G    B   W          6.2.0-rc=
1-syzkaller #0
Hardware name: riscv-virtio,qemu (DT)
Call Trace:
[<ffffffff8000b9ea>] dump_backtrace+0x2e/0x3c arch/riscv/kernel/stacktrace.=
c:121
[<ffffffff83402b96>] show_stack+0x34/0x40 arch/riscv/kernel/stacktrace.c:12=
7
[<ffffffff83442726>] __dump_stack lib/dump_stack.c:88 [inline]
[<ffffffff83442726>] dump_stack_lvl+0xe0/0x14c lib/dump_stack.c:106
[<ffffffff834427ae>] dump_stack+0x1c/0x24 lib/dump_stack.c:113
[<ffffffff80489c32>] warn_alloc+0x168/0x22c mm/page_alloc.c:4356
[<ffffffff8047ecc4>] __vmalloc_node_range+0xb6c/0xdb4 mm/vmalloc.c:3192
[<ffffffff8001938c>] bpf_jit_alloc_exec+0x46/0x52 arch/riscv/net/bpf_jit_co=
re.c:190
[<ffffffff802856ea>] bpf_jit_binary_alloc+0x96/0x13c kernel/bpf/core.c:1025
[<ffffffff8001910a>] bpf_int_jit_compile+0x886/0xaa6 arch/riscv/net/bpf_jit=
_core.c:112
[<ffffffff80287586>] bpf_prog_select_runtime+0x1a2/0x22e kernel/bpf/core.c:=
2190
[<ffffffff80291fe4>] bpf_prog_load+0xcb4/0x12b0 kernel/bpf/syscall.c:2623
[<ffffffff80295a76>] __sys_bpf+0x622/0x31d2 kernel/bpf/syscall.c:4979
[<ffffffff80298f16>] __do_sys_bpf kernel/bpf/syscall.c:5083 [inline]
[<ffffffff80298f16>] sys_bpf+0x28/0x36 kernel/bpf/syscall.c:5081
[<ffffffff80005ff6>] ret_from_syscall+0x0/0x2
Mem-Info:
active_anon:26162 inactive_anon:84 isolated_anon:0
 active_file:0 inactive_file:7832 isolated_file:0
 unevictable:768 dirty:22 writeback:0
 slab_reclaimable:5680 slab_unreclaimable:24335
 mapped:8731 shmem:3924 pagetables:292
 sec_pagetables:0 bounce:0
 kernel_misc_reclaimable:0
 free:231175 free_pcp:515 free_cma:4096
Node 0 active_anon:104648kB inactive_anon:336kB active_file:0kB inactive_fi=
le:31328kB unevictable:3072kB isolated(anon):0kB isolated(file):0kB mapped:=
34924kB dirty:88kB writeback:0kB shmem:15696kB writeback_tmp:0kB kernel_sta=
ck:5408kB pagetables:1168kB sec_pagetables:0kB all_unreclaimable? no
Node 0 DMA32 free:924700kB boost:0kB min:4656kB low:6012kB high:7368kB rese=
rved_highatomic:0KB active_anon:104648kB inactive_anon:336kB active_file:0k=
B inactive_file:31328kB unevictable:3072kB writepending:88kB present:209510=
4kB managed:1359004kB mlocked:0kB bounce:0kB free_pcp:2060kB local_pcp:1596=
kB free_cma:16384kB
lowmem_reserve[]: 0 0 0
Node 0 DMA32: 2659*4kB (UME) 2000*8kB (UME) 981*16kB (UME) 519*32kB (UME) 1=
86*64kB (UME) 35*128kB (UME) 7*256kB (M) 9*512kB (ME) 5*1024kB (ME) 7*2048k=
B (MEC) 201*4096kB (MC) =3D 924476kB
Node 0 hugepages_total=3D0 hugepages_free=3D0 hugepages_surp=3D0 hugepages_=
size=3D1048576kB
Node 0 hugepages_total=3D4 hugepages_free=3D4 hugepages_surp=3D0 hugepages_=
size=3D2048kB
11756 total pagecache pages
0 pages in swap cache
Free swap  =3D 0kB
Total swap =3D 0kB
523776 pages RAM
0 pages HighMem/MovableOnly
184025 pages reserved
4096 pages cma reserved


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the bug is already fixed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to change bug's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the bug is a duplicate of another bug, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup


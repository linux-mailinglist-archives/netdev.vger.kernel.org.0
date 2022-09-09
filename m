Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA2D05B42A0
	for <lists+netdev@lfdr.de>; Sat, 10 Sep 2022 00:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230509AbiIIWsf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 18:48:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiIIWse (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 18:48:34 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B901FC678
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 15:48:32 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id o10-20020a6b5a0a000000b0068aba769d73so2398048iob.4
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 15:48:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=hZ0sk6GtJ/mTRESHsdFOvkaVVjN/Wqt7oUUKzm3DAe8=;
        b=HTiuEKS9G5JHtbojhkwMa3feETeSHT6r/bZj91hogLGetieF4Ux/iZRVFbKU8PYtEt
         YWiE+aPkNF2xjEyYymegdcy4k8iJBN+nBrzerVcDVg/FtFKSpuLqEPK4LPGssL9cqOb2
         eUWO6jHq6fVZxUcV05xf4pXW1K69V30i0dxU5P+RW5jlm2NtaJrsdN4jEq7LVmlT51qm
         3GfUnBHPe+GcWRvUIojkyyZ0hcnc0v0mQqU/AXu7augqgCSNMh71jCVlIRPoOGhVTewS
         fotpBznLpCjfhpL4v0YdHSENHKN2VqNwBhc3/gZVRcys4hB/9zOdbUpkwsNQL8yfdcBG
         GIzw==
X-Gm-Message-State: ACgBeo1aLpW5TBreIjR4zcxfG9ZDiphZMNE8wH3VIjYcF3Vt7tnKUchP
        8itutckACty+kvaqzKwev8sDfr53sdcWnhwcMsihZdvwTIOA
X-Google-Smtp-Source: AA6agR435MDd/F7lHyXeyHhwzx6HnFFs8kd+Q2Xn/CywCUrsZRX8aW0Ei8GaPhzGGDO9OuEWyu59RxPXGSvEv626zAt6BAU53jhd
MIME-Version: 1.0
X-Received: by 2002:a05:6602:29c7:b0:68b:3a08:4512 with SMTP id
 z7-20020a05660229c700b0068b3a084512mr7911988ioq.199.1662763711517; Fri, 09
 Sep 2022 15:48:31 -0700 (PDT)
Date:   Fri, 09 Sep 2022 15:48:31 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005ed86405e846585a@google.com>
Subject: [syzbot] WARNING: ODEBUG bug in htab_map_alloc
From:   syzbot <syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com>
To:     andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, haoluo@google.com, john.fastabend@gmail.com,
        jolsa@kernel.org, kpsingh@kernel.org, linux-kernel@vger.kernel.org,
        martin.lau@linux.dev, netdev@vger.kernel.org, sdf@google.com,
        song@kernel.org, syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SORTED_RECIPS,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    274052a2b0ab Merge branch 'bpf-allocator'
git tree:       bpf-next
console+strace: https://syzkaller.appspot.com/x/log.txt?x=11a26bcd080000
kernel config:  https://syzkaller.appspot.com/x/.config?x=924833c12349a8c0
dashboard link: https://syzkaller.appspot.com/bug?extid=5d1da78b375c3b5e6c2b
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=114109f5080000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11b3b56d080000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/be8eff3df48b/disk-274052a2.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/cd3150e84ddd/vmlinux-274052a2.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+5d1da78b375c3b5e6c2b@syzkaller.appspotmail.com

------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: percpu_counter hint: 0x0
WARNING: CPU: 0 PID: 3624 at lib/debugobjects.c:502 debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Modules linked in:
CPU: 0 PID: 3624 Comm: syz-executor257 Not tainted 5.19.0-syzkaller-14117-g274052a2b0ab #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
RIP: 0010:debug_print_object+0x16e/0x250 lib/debugobjects.c:502
Code: ff df 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 af 00 00 00 48 8b 14 dd 60 0c 49 8a 4c 89 ee 48 c7 c7 00 00 49 8a e8 df f1 38 05 <0f> 0b 83 05 65 86 dd 09 01 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e c3
RSP: 0018:ffffc90003edfa90 EFLAGS: 00010282
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff8880773cbb00 RSI: ffffffff8161f148 RDI: fffff520007dbf44
RBP: 0000000000000001 R08: 0000000000000005 R09: 0000000000000000
R10: 0000000080000000 R11: 0000000000000000 R12: ffffffff8a4b90c0
R13: ffffffff8a490520 R14: 0000000000000000 R15: dffffc0000000000
FS:  00007f0136485700(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00000000200004c0 CR3: 0000000072b25000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
 __debug_check_no_obj_freed lib/debugobjects.c:989 [inline]
 debug_check_no_obj_freed+0x301/0x420 lib/debugobjects.c:1020
 slab_free_hook mm/slub.c:1729 [inline]
 slab_free_freelist_hook+0xeb/0x1c0 mm/slub.c:1780
 slab_free mm/slub.c:3534 [inline]
 kfree+0xe2/0x580 mm/slub.c:4562
 kvfree+0x42/0x50 mm/util.c:655
 htab_map_alloc+0xc76/0x1620 kernel/bpf/hashtab.c:632
 find_and_alloc_map kernel/bpf/syscall.c:131 [inline]
 map_create kernel/bpf/syscall.c:1105 [inline]
 __sys_bpf+0xa82/0x5f80 kernel/bpf/syscall.c:4938
 __do_sys_bpf kernel/bpf/syscall.c:5060 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5058 [inline]
 __x64_sys_bpf+0x75/0xb0 kernel/bpf/syscall.c:5058
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7f01364d3919
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 11 15 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0136485318 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f013655b3e8 RCX: 00007f01364d3919
RDX: 0000000000000048 RSI: 00000000200004c0 RDI: 0000000000000000
RBP: 00007f013655b3e0 R08: 00007f0136485700 R09: 0000000000000000
R10: 00007f0136485700 R11: 0000000000000246 R12: 00007f013655b3ec
R13: 00007ffee9a220af R14: 00007f0136485400 R15: 0000000000022000
 </TASK>
irq event stamp: 19441
hardirqs last  enabled at (19445): [<ffffffff816188e8>] __down_trylock_console_sem+0x108/0x120 kernel/printk/printk.c:247
hardirqs last disabled at (19448): [<ffffffff816188ca>] __down_trylock_console_sem+0xea/0x120 kernel/printk/printk.c:245
softirqs last  enabled at (19350): [<ffffffff814914c3>] invoke_softirq kernel/softirq.c:445 [inline]
softirqs last  enabled at (19350): [<ffffffff814914c3>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
softirqs last disabled at (19341): [<ffffffff814914c3>] invoke_softirq kernel/softirq.c:445 [inline]
softirqs last disabled at (19341): [<ffffffff814914c3>] __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
---[ end trace 0000000000000000 ]---


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches

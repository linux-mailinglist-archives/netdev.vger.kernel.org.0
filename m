Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9151399021
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:37:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbhFBQj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 12:39:27 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:48035 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229927AbhFBQj1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 12:39:27 -0400
Received: by mail-il1-f197.google.com with SMTP id c2-20020a92d3c20000b02901d9fda18626so2005235ilh.14
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 09:37:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=kaa2yadqbxfM98fGWlqhzlCBWMNgO1nQ34AqbCOd+Ug=;
        b=SJDp4ANwLO0zHTnChDxGp1os1zNFo6l7f4f2MoPLF7Nac6Qk7lyrefrq3HlV/dBch/
         aLrDjKIlooqHwdC/LDCoDzp9TurLsRJn22zMV+GPc3W3j74ZOAaf7uc8pcczEh75SjrB
         W5V16MCKuonNYJ2D9kFR0BR5QywjJ4ON8lybGEIjkwDrcdRxACLAxXlmjcRCTqIW5BM1
         8ZFXwzYlNX3nDj0Txb7DQBwhdmKP6Eip+8PmWF7qZYmG1bNYDPmkRPvB/BI1hs70HitN
         DTbxuHR20ekNEJz3BiVf5cRNmR6+ouHHn2sj0IFuYu96lPVA9SuLCrg+U8xj5aQis05x
         SSIw==
X-Gm-Message-State: AOAM530jsxPBSJMRtnLUaofM0WRkjAvvfnMNMrOtro3m0MNYnntCr93J
        Onp5uRqNaU8ExX8N4QpXBU/lDVjJIPqHBrcZeKeObxjkMl7w
X-Google-Smtp-Source: ABdhPJxb5RcIkLclOuo1ds69KxkNJjR6Hh8O7u1W6hGDT2+NlVonxrtP5jwVaNsLbchUvHguaT3xNifgIYEO4vigrPmZLqnx7FC5
MIME-Version: 1.0
X-Received: by 2002:a05:6638:1008:: with SMTP id r8mr15472439jab.112.1622651847194;
 Wed, 02 Jun 2021 09:37:27 -0700 (PDT)
Date:   Wed, 02 Jun 2021 09:37:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000f23c9e05c3cb1250@google.com>
Subject: [syzbot] general protection fault in lock_page_memcg
From:   syzbot <syzbot+15a9609cfd4687eb7269@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, cgroups@vger.kernel.org,
        coreteam@netfilter.org, davem@davemloft.net, dsahern@kernel.org,
        fw@strlen.de, hannes@cmpxchg.org, kadlec@netfilter.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        mhocko@kernel.org, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, pablo@netfilter.org,
        syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com,
        yoshfuji@linux-ipv6.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    a1f92694 Add linux-next specific files for 20210518
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=112d5fcfd00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d612e75ffd53a6d3
dashboard link: https://syzkaller.appspot.com/bug?extid=15a9609cfd4687eb7269
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=143ecb5fd00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11c7326bd00000

The issue was bisected to:

commit f9006acc8dfe59e25aa75729728ac57a8d84fc32
Author: Florian Westphal <fw@strlen.de>
Date:   Wed Apr 21 07:51:08 2021 +0000

    netfilter: arp_tables: pass table pointer via nf_hook_ops

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=16d4af03d00000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=15d4af03d00000
console output: https://syzkaller.appspot.com/x/log.txt?x=11d4af03d00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+15a9609cfd4687eb7269@syzkaller.appspotmail.com
Fixes: f9006acc8dfe ("netfilter: arp_tables: pass table pointer via nf_hook_ops")

general protection fault, probably for non-canonical address 0xdffffd1002ed3a01: 0000 [#1] PREEMPT SMP KASAN
KASAN: probably user-memory-access in range [0x000008801769d008-0x000008801769d00f]
CPU: 1 PID: 8455 Comm: syz-executor974 Not tainted 5.13.0-rc2-next-20210518-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:_compound_head include/linux/page-flags.h:182 [inline]
RIP: 0010:lock_page_memcg+0x29/0x7d0 mm/memcontrol.c:1984
Code: 00 48 b8 00 00 00 00 00 fc ff df 55 48 89 e5 41 57 49 89 ff 41 56 41 55 41 54 4c 8d 67 08 4c 89 e2 53 48 c1 ea 03 48 83 ec 20 <80> 3c 02 00 0f 85 10 06 00 00 49 8b 47 08 48 8d 50 ff a8 01 4c 0f
RSP: 0018:ffffc9000194f8b8 EFLAGS: 00010286
RAX: dffffc0000000000 RBX: 00001e801769d000 RCX: 0000000000000000
RDX: 0000011002ed3a01 RSI: ffffffff81aee7cd RDI: 000008801769d000
RBP: ffffc9000194f900 R08: 0000000000000000 R09: ffff88801cf9b82f
R10: ffffffff81be0aa6 R11: 000000000000003f R12: 000008801769d008
R13: 0000000000000001 R14: 000008801769d000 R15: 000008801769d000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000480de8 CR3: 00000000127fa000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 page_remove_rmap+0x25/0x1480 mm/rmap.c:1348
 zap_huge_pmd+0x9c4/0xfb0 mm/huge_memory.c:1689
 zap_pmd_range mm/memory.c:1362 [inline]
 zap_pud_range mm/memory.c:1404 [inline]
 zap_p4d_range mm/memory.c:1425 [inline]
 unmap_page_range+0x1aac/0x2660 mm/memory.c:1446
 unmap_single_vma+0x198/0x300 mm/memory.c:1491
 unmap_vmas+0x16d/0x2f0 mm/memory.c:1523
 exit_mmap+0x1d0/0x620 mm/mmap.c:3201
 __mmput+0x122/0x470 kernel/fork.c:1096
 mmput+0x58/0x60 kernel/fork.c:1117
 exit_mm kernel/exit.c:502 [inline]
 do_exit+0xb0a/0x2a70 kernel/exit.c:813
 do_group_exit+0x125/0x310 kernel/exit.c:923
 __do_sys_exit_group kernel/exit.c:934 [inline]
 __se_sys_exit_group kernel/exit.c:932 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:932
 do_syscall_64+0x31/0xb0 arch/x86/entry/common.c:47
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x43da89
Code: Unable to access opcode bytes at RIP 0x43da5f.
RSP: 002b:00007ffc45bf0b08 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00000000004ae230 RCX: 000000000043da89
RDX: 000000000000003c RSI: 00000000000000e7 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffffffffffc0 R09: 0000000000000000
R10: 0000000000000003 R11: 0000000000000246 R12: 00000000004ae230
R13: 0000000000000001 R14: 0000000000000000 R15: 0000000000000001
Modules linked in:
---[ end trace 048141dd003294dd ]---
RIP: 0010:_compound_head include/linux/page-flags.h:182 [inline]
RIP: 0010:lock_page_memcg+0x29/0x7d0 mm/memcontrol.c:1984
Code: 00 48 b8 00 00 00 00 00 fc ff df 55 48 89 e5 41 57 49 89 ff 41 56 41 55 41 54 4c 8d 67 08 4c 89 e2 53 48 c1 ea 03 48 83 ec 20 <80> 3c 02 00 0f 85 10 06 00 00 49 8b 47 08 48 8d 50 ff a8 01 4c 0f
RSP: 0018:ffffc9000194f8b8 EFLAGS: 00010286
RAX: dffffc0000000000 RBX: 00001e801769d000 RCX: 0000000000000000
RDX: 0000011002ed3a01 RSI: ffffffff81aee7cd RDI: 000008801769d000
RBP: ffffc9000194f900 R08: 0000000000000000 R09: ffff88801cf9b82f
R10: ffffffff81be0aa6 R11: 000000000000003f R12: 000008801769d008
R13: 0000000000000001 R14: 000008801769d000 R15: 000008801769d000
FS:  0000000000000000(0000) GS:ffff8880b9d00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000480de8 CR3: 00000000127fa000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
For information about bisection process see: https://goo.gl/tpsmEJ#bisection
syzbot can test patches for this issue, for details see:
https://goo.gl/tpsmEJ#testing-patches

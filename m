Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C41A11243E
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 09:15:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfLDIPK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 03:15:10 -0500
Received: from mail-il1-f198.google.com ([209.85.166.198]:36813 "EHLO
        mail-il1-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726166AbfLDIPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Dec 2019 03:15:09 -0500
Received: by mail-il1-f198.google.com with SMTP id v15so667930iln.3
        for <netdev@vger.kernel.org>; Wed, 04 Dec 2019 00:15:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=3gxsHwvlUUBpSvK315i8o2sg/roLIxlVFL41wPQysKk=;
        b=tMGtyM5zRqN/2ldVc8YwWOEFcomerFCf/TPqIut0EcuBSOvN4I7tJNpq9qM03d8LFT
         Qu2PZI0mFg/Ljw54MjXmQdbsZP1Rv2GzFre5SJ1096enbheJffJ8dMhSrJ/abbm46q8P
         5B8HdYlNZ6fHF5qKv5f25kEATVuoW87Kz3JEW1r9FNPdsHIkPutyf3pibhI0XHFkrs8q
         rgB/e1RKNvels449+rLA/Rlmu1uamjIi2F62cyoMtqfYh634T4aLgVGaJeUIC+Sg1Spn
         BBJZUxTX86q5zLyE2Pr7g+jhIMCTzKemNyKlzdRmCOloBdIF/XPs5KVml+VBBwSTtM6f
         5e9Q==
X-Gm-Message-State: APjAAAXdNM4sR5B09BL7691DqdtoiwSXZ5MNivTK/RLQIPOxAXUnUozx
        2zOmIFNJEIyrQULGFqsh9tPgXKR1x3VJQYpzDHf8nn6b45VZ
X-Google-Smtp-Source: APXvYqzIxmgXZ1QBxq9xD17imaY7z6J5sKHlCL+TCugehyRVkX/brVHwcBEz4gS5IceA/HyMOfHDPcia0dyBirhn7V2aKi4P33dF
MIME-Version: 1.0
X-Received: by 2002:a02:a148:: with SMTP id m8mr1878744jah.69.1575447308616;
 Wed, 04 Dec 2019 00:15:08 -0800 (PST)
Date:   Wed, 04 Dec 2019 00:15:08 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000314c120598dc69bd@google.com>
Subject: BUG: unable to handle kernel paging request in pcpu_alloc
From:   syzbot <syzbot+82e323920b78d54aaed5@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, kafai@fb.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    1ab75b2e Add linux-next specific files for 20191203
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=10edf2eae00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=de1505c727f0ec20
dashboard link: https://syzkaller.appspot.com/bug?extid=82e323920b78d54aaed5
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=156ef061e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11641edae00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+82e323920b78d54aaed5@syzkaller.appspotmail.com

RDX: 000000000000003c RSI: 0000000020000080 RDI: 0c00000000000000
RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000018
R13: 0000000000000004 R14: 0000000000000005 R15: 0000000000000000
BUG: unable to handle page fault for address: fffff91ffff00000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffe6067 P4D 21ffe6067 PUD aa56c067 PMD aa56d067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8999 Comm: syz-executor865 Not tainted  
5.4.0-next-20191203-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:121 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:135 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:166 [inline]
RIP: 0010:check_memory_region_inline mm/kasan/generic.c:182 [inline]
RIP: 0010:check_memory_region+0x9c/0x1a0 mm/kasan/generic.c:192
Code: c9 4d 0f 49 c1 49 c1 f8 03 45 85 c0 0f 84 10 01 00 00 41 83 e8 01 4e  
8d 44 c0 08 eb 0d 48 83 c0 08 4c 39 c0 0f 84 a7 00 00 00 <48> 83 38 00 74  
ed 4c 8d 40 08 eb 09 48 83 c0 01 49 39 c0 74 53 80
RSP: 0018:ffffc90001f67a80 EFLAGS: 00010216
RAX: fffff91ffff00000 RBX: fffff91ffff01000 RCX: ffffffff819e1589
RDX: 0000000000000001 RSI: 0000000000008000 RDI: ffffe8ffff800000
RBP: ffffc90001f67a98 R08: fffff91ffff01000 R09: 0000000000001000
R10: fffff91ffff00fff R11: ffffe8ffff807fff R12: fffff91ffff00000
R13: 0000000000008000 R14: 0000000000000000 R15: ffff88821fffd100
FS:  00000000011a7880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff91ffff00000 CR3: 00000000a94ad000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
  memset+0x24/0x40 mm/kasan/common.c:107
  memset include/linux/string.h:410 [inline]
  pcpu_alloc+0x589/0x1380 mm/percpu.c:1734
  __alloc_percpu_gfp+0x28/0x30 mm/percpu.c:1783
  bpf_array_alloc_percpu kernel/bpf/arraymap.c:35 [inline]
  array_map_alloc+0x698/0x7d0 kernel/bpf/arraymap.c:159
  find_and_alloc_map kernel/bpf/syscall.c:123 [inline]
  map_create kernel/bpf/syscall.c:654 [inline]
  __do_sys_bpf+0x478/0x3810 kernel/bpf/syscall.c:3012
  __se_sys_bpf kernel/bpf/syscall.c:2989 [inline]
  __x64_sys_bpf+0x73/0xb0 kernel/bpf/syscall.c:2989
  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
  entry_SYSCALL_64_after_hwframe+0x49/0xbe
RIP: 0033:0x442f99
Code: e8 ec 09 03 00 48 83 c4 18 c3 0f 1f 80 00 00 00 00 48 89 f8 48 89 f7  
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff  
ff 0f 83 cb 08 fc ff c3 66 2e 0f 1f 84 00 00 00 00
RSP: 002b:00007ffc8aa156d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 0000000000442f99
RDX: 000000000000003c RSI: 0000000020000080 RDI: 0c00000000000000
RBP: 0000000000000000 R08: 0000000000000002 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000018
R13: 0000000000000004 R14: 0000000000000005 R15: 0000000000000000
Modules linked in:
CR2: fffff91ffff00000
---[ end trace 449f8b43dad6ffb8 ]---
RIP: 0010:memory_is_nonzero mm/kasan/generic.c:121 [inline]
RIP: 0010:memory_is_poisoned_n mm/kasan/generic.c:135 [inline]
RIP: 0010:memory_is_poisoned mm/kasan/generic.c:166 [inline]
RIP: 0010:check_memory_region_inline mm/kasan/generic.c:182 [inline]
RIP: 0010:check_memory_region+0x9c/0x1a0 mm/kasan/generic.c:192
Code: c9 4d 0f 49 c1 49 c1 f8 03 45 85 c0 0f 84 10 01 00 00 41 83 e8 01 4e  
8d 44 c0 08 eb 0d 48 83 c0 08 4c 39 c0 0f 84 a7 00 00 00 <48> 83 38 00 74  
ed 4c 8d 40 08 eb 09 48 83 c0 01 49 39 c0 74 53 80
RSP: 0018:ffffc90001f67a80 EFLAGS: 00010216
RAX: fffff91ffff00000 RBX: fffff91ffff01000 RCX: ffffffff819e1589
RDX: 0000000000000001 RSI: 0000000000008000 RDI: ffffe8ffff800000
RBP: ffffc90001f67a98 R08: fffff91ffff01000 R09: 0000000000001000
R10: fffff91ffff00fff R11: ffffe8ffff807fff R12: fffff91ffff00000
R13: 0000000000008000 R14: 0000000000000000 R15: ffff88821fffd100
FS:  00000000011a7880(0000) GS:ffff8880ae900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffff91ffff00000 CR3: 00000000a94ad000 CR4: 00000000001406e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches

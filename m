Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6391D4E862
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 14:57:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbfFUM5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 08:57:09 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:49705 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726663AbfFUM5J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 08:57:09 -0400
Received: by mail-io1-f71.google.com with SMTP id x24so10579678ioh.16
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 05:57:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=A2VyUgGWSWywv45HUYrnIhNKgZQgapXa0xol2XPthjo=;
        b=UB4OZ5UXdHsZEc5eFyRJtpnASoO5UypkWegoqGXOiWX8NgrcqwHdnlwWMESzybAsY1
         6dBbLtUo2VIB/12bEwtb9/SlObrODt7CLKm6SL59IrFQlMaIdOxDxbPg99bhBkpjxrDB
         fPCNyG14pr8jZiQNdODhb/RhpQ71sf2XuyHUKath3vEYmJmAjnomEVamDm31EN5OfpJ1
         nSjHrBefPPQv4a+jCW6QF/RSEc7GUfkgqR9erizCXg2BUemfu8oOf5DALAsKTP6txUIi
         7sl++o2CPPu3+PH1W8t0f5N4XryldV8epLOuInBELz1apllcexOpiqoz4JIYSRmfjfyb
         PlQQ==
X-Gm-Message-State: APjAAAWyQkb1zRrxCruwmRxT+MBt9VNOLJhKLOf3GZCTgFWO5+RjNcuA
        lw82U82AKCi2ZN982CumrWnGyQynGhEmXvjmogTcJ+jpu17B
X-Google-Smtp-Source: APXvYqwEAPS8Ttb1NEzMaqieQyGHRSY3lNKotU5V0uQHcZCAPmIWBd1axRTsm58KdcPaci/eIZUZBNxE3PxBpaAQ1QfNpju3lp1Q
MIME-Version: 1.0
X-Received: by 2002:a6b:b256:: with SMTP id b83mr16068710iof.48.1561121827887;
 Fri, 21 Jun 2019 05:57:07 -0700 (PDT)
Date:   Fri, 21 Jun 2019 05:57:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000000ac4f058bd50039@google.com>
Subject: WARNING in is_bpf_text_address
From:   syzbot <syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com>
To:     ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
        davem@davemloft.net, hawk@kernel.org, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, kafai@fb.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        songliubraving@fb.com, syzkaller-bugs@googlegroups.com,
        xdp-newbies@vger.kernel.org, yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

syzbot found the following crash on:

HEAD commit:    abf02e29 Merge tag 'pm-5.2-rc6' of git://git.kernel.org/pu..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=15336041a00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=28ec3437a5394ee0
dashboard link: https://syzkaller.appspot.com/bug?extid=bd3bba6ff3fcea7a6ec6
compiler:       clang version 9.0.0 (/home/glider/llvm/clang  
80fee25776c2fb61e74c1ecb1a523375c2500b69)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14ae828aa00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+bd3bba6ff3fcea7a6ec6@syzkaller.appspotmail.com

WARNING: CPU: 1 PID: 8444 at kernel/bpf/core.c:851 bpf_jit_free+0x1a8/0x1f0
Kernel panic - not syncing: panic_on_warn set ...
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x1d8/0x2f8 lib/dump_stack.c:113
  panic+0x28a/0x7c9 kernel/panic.c:219
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#1] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886f758 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886f790 R08: ffffffff818032cb R09: ffffed1015d66bf8
R10: ffffed1015d66bf8 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#2] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886f2e0 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886f318 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#3] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886ee60 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886ee98 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#4] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886e9e0 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886ea18 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#5] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886e560 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886e598 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#6] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886e0e0 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886e118 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#7] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886dc60 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886dc98 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#8] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886d7e0 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886d818 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#9] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886d360 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886d398 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#10] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886cee0 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886cf18 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#11] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886ca60 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886ca98 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page fault for address: fffffbfff400c000
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 21ffee067 P4D 21ffee067 PUD 21ffed067 PMD a3fe2067 PTE 0
Oops: 0000 [#12] PREEMPT SMP KASAN
CPU: 1 PID: 8444 Comm: kworker/1:5 Not tainted 5.2.0-rc5+ #4
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_prog_free_deferred
RIP: 0010:bpf_get_prog_addr_region kernel/bpf/core.c:537 [inline]
RIP: 0010:bpf_tree_comp kernel/bpf/core.c:600 [inline]
RIP: 0010:__lt_find include/linux/rbtree_latch.h:115 [inline]
RIP: 0010:latch_tree_find include/linux/rbtree_latch.h:208 [inline]
RIP: 0010:bpf_prog_kallsyms_find kernel/bpf/core.c:674 [inline]
RIP: 0010:is_bpf_text_address+0x201/0x3b0 kernel/bpf/core.c:709
Code: 25 81 f5 ff 4d 39 f4 76 10 e8 1b 7f f5 ff 49 83 c7 10 eb 46 0f 1f 44  
00 00 4c 89 e0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84  
c0 75 7d 41 8b 1c 24 48 c1 e3 0c 4c 01 e3 48 89 df
RSP: 0018:ffff88808886c5e0 EFLAGS: 00010806
RAX: 1ffffffff400c000 RBX: 0000000000000001 RCX: dffffc0000000000
RDX: ffff8880961b8680 RSI: ffffffffffffffff RDI: ffffffffa0060000
RBP: ffff88808886c618 R08: ffffffff818032cb R09: 0000000000000001
R10: ffffffff81811539 R11: 1ffff11015d66bf7 R12: ffffffffa0060000
R13: 0000000000000000 R14: ffffffffffffffff R15: ffff88808914cab8
FS:  0000000000000000(0000) GS:ffff8880aeb00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: fffffbfff400c000 CR3: 00000000a3ba4000 CR4: 00000000001406e0
Call Trace:
BUG: unable to handle page


---
This bug is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this bug report. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
syzbot can test patches for this bug, for details see:
https://goo.gl/tpsmEJ#testing-patches

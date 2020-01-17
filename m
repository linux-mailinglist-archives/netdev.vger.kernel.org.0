Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83F6814066B
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 10:40:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729129AbgAQJjM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 04:39:12 -0500
Received: from mail-il1-f197.google.com ([209.85.166.197]:35197 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729030AbgAQJjL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 04:39:11 -0500
Received: by mail-il1-f197.google.com with SMTP id h18so18335388ilc.2
        for <netdev@vger.kernel.org>; Fri, 17 Jan 2020 01:39:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=A4/U4UrkTKcxcGAlIspe/ocMHXIdH0kJgqb8CqaSZic=;
        b=EReD8gMSmrHXrHI8lW/zAvHAIXSRIn/STJ+b2geB3pleWhhdtPkpd0BzWZW2RNEbQa
         7RRCXDW7efJ+ICdfxwPmf7xFKulQVlhvXitVaf/5VGDDyc+p0WTbKfl89WluCL5W6fD5
         qDMs/ntfChVOQWhizil9JP3Cp0dcMYsicr/yKfd5TOfo3GKsoAZy8s6ynYYVcc+aZgqF
         OcmV1r2yMwSafZLXoQlPq6+wCioISYhPoHfYPabYmP5qyNlELpiHRplScmRDaqyXsBCz
         yMvqfMg3nCLI6RQuTa9DDJ3Mx0UQvI3TLHBkSukSDk7tYpWXyi7HpfiutdM3xE7z5BAa
         sJ0w==
X-Gm-Message-State: APjAAAXHyr/gbzHnDsf//ZPQ+5J/5yOTV+r+7FtDnXs8PLkV8Blm4bHa
        WJn9MK9DfOtyaii6BRJoLIez+7aLJ5PaQ9U3OX+EJiezqW0p
X-Google-Smtp-Source: APXvYqzzHR8vGnogFsiE07xYB2aNaD3AJPyjJ2yf2kqHMWgTxoo+rbUTnUtk9KghvrjYg8BG9lV4/4ISO3yT96xk91v3N9E+eeaK
MIME-Version: 1.0
X-Received: by 2002:a92:88d0:: with SMTP id m77mr2373438ilh.9.1579253950789;
 Fri, 17 Jan 2020 01:39:10 -0800 (PST)
Date:   Fri, 17 Jan 2020 01:39:10 -0800
In-Reply-To: <0000000000003e5aa90598ed7415@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000bf411c059c52b660@google.com>
Subject: Re: BUG: sleeping function called from invalid context in lock_sock_nested
From:   syzbot <syzbot+c2f1558d49e25cc36e5e@syzkaller.appspotmail.com>
To:     andriin@fb.com, ast@kernel.org, bpf@vger.kernel.org,
        daniel@iogearbox.net, davem@davemloft.net, eric.dumazet@gmail.com,
        herbert@gondor.apana.org.au, john.fastabend@gmail.com,
        kafai@fb.com, linux-crypto@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, songliubraving@fb.com,
        syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk,
        yhs@fb.com
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following crash on:

HEAD commit:    93ad0f96 net: wan: lapbether.c: Use built-in RCU list chec..
git tree:       net
console output: https://syzkaller.appspot.com/x/log.txt?x=1159eb8ee00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=7e89bd00623fe71e
dashboard link: https://syzkaller.appspot.com/bug?extid=c2f1558d49e25cc36e5e
compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1070cad1e00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=17de84a5e00000

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: syzbot+c2f1558d49e25cc36e5e@syzkaller.appspotmail.com

BUG: sleeping function called from invalid context at net/core/sock.c:2935
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 3198, name:  
kworker/0:112
4 locks held by kworker/0:112/3198:
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: __write_once_size  
include/linux/compiler.h:226 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: arch_atomic64_set  
arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:855 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:40 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: set_work_data  
kernel/workqueue.c:615 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at:  
process_one_work+0x88b/0x1740 kernel/workqueue.c:2235
  #1: ffffc9000951fdc0 ((work_completion)(&map->work)){+.+.}, at:  
process_one_work+0x8c1/0x1740 kernel/workqueue.c:2239
  #2: ffffffff899a3f00 (rcu_read_lock){....}, at: sock_hash_free+0x0/0x540  
net/core/sock_map.c:317
  #3: ffffc90002478d20 (&htab->buckets[i].lock){+...}, at:  
sock_hash_free+0x131/0x540 net/core/sock_map.c:865
Preemption disabled at:
[<ffffffff86341331>] sock_hash_free+0x131/0x540 net/core/sock_map.c:865
CPU: 0 PID: 3198 Comm: kworker/0:112 Not tainted 5.5.0-rc5-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS  
Google 01/01/2011
Workqueue: events bpf_map_free_deferred
Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0x197/0x210 lib/dump_stack.c:118
  ___might_sleep.cold+0x1fb/0x23e kernel/sched/core.c:6800
  __might_sleep+0x95/0x190 kernel/sched/core.c:6753
  lock_sock_nested+0x39/0x120 net/core/sock.c:2935
  lock_sock include/net/sock.h:1531 [inline]
  sock_hash_free+0x29f/0x540 net/core/sock_map.c:868
  bpf_map_free_deferred+0xb3/0x100 kernel/bpf/syscall.c:327
  process_one_work+0x9af/0x1740 kernel/workqueue.c:2264
  worker_thread+0x98/0xe40 kernel/workqueue.c:2410
  kthread+0x361/0x430 kernel/kthread.c:255
  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
BUG: scheduling while atomic: kworker/0:112/3198/0x00000202
4 locks held by kworker/0:112/3198:
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: __write_once_size  
include/linux/compiler.h:226 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: arch_atomic64_set  
arch/x86/include/asm/atomic64_64.h:34 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: atomic64_set  
include/asm-generic/atomic-instrumented.h:855 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: atomic_long_set  
include/asm-generic/atomic-long.h:40 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at: set_work_data  
kernel/workqueue.c:615 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at:  
set_work_pool_and_clear_pending kernel/workqueue.c:642 [inline]
  #0: ffff8880aa426d28 ((wq_completion)events){+.+.}, at:  
process_one_work+0x88b/0x1740 kernel/workqueue.c:2235
  #1: ffffc9000951fdc0 ((work_completion)(&map->work)){+.+.}, at:  
process_one_work+0x8c1/0x1740 kernel/workqueue.c:2239
  #2: ffffffff899a3f00 (rcu_read_lock){....}, at: sock_hash_free+0x0/0x540  
net/core/sock_map.c:317
  #3: ffffc90002478d20 (&htab->buckets[i].lock){+...}, at:  
sock_hash_free+0x131/0x540 net/core/sock_map.c:865
Modules linked in:
Preemption disabled at:
[<ffffffff86341331>] sock_hash_free+0x131/0x540 net/core/sock_map.c:865


Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADF6252984
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 10:54:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727860AbgHZIyW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 04:54:22 -0400
Received: from mail-il1-f197.google.com ([209.85.166.197]:41257 "EHLO
        mail-il1-f197.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727792AbgHZIyR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 04:54:17 -0400
Received: by mail-il1-f197.google.com with SMTP id l71so1038313ild.8
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 01:54:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=KWA98gUVVPLAB5mEnwjYg2XuRfaodeLtZ5bQKkNE1+8=;
        b=klGVqmB1re0voNo5OgY83QRRpi/7toDgTr6Z7gVYEVlTeEYThh6wxdrt3kbhdBXSQP
         Qk80aQqbCfmNHEi7PczPDuQWUY45O0jYl+hrs46tSsvFxFPVVD0xyT9tAjaLIsfGhIxY
         spTpx4ApgYGb1o/6Dj1a3pF/Ohs9K1DedQ31QDPoPHs1K+LOpeMpkE7SJD3hEWWRx1A1
         fr6qRqPpcZ160socInjq6xzZXnC8mE9NenuKEZ1/rAwA92TIkPTjgocJOwATFCyhCl9i
         XoCmCl5UP1U5KB1cRZlJRkXIKMG94TYuOF7ZKSZY5BvQCs6J7P+UJE8w/c1hUZcNz48m
         nxTA==
X-Gm-Message-State: AOAM530GndnwbKxhgZgoX0PdHIc6AFGN0G7krYkUgmx4PqbKqW7DOQVu
        c07EtPjjs00F85GYRxQfOsxvmkZ9elDWWxB13IfsFx6A85LL
X-Google-Smtp-Source: ABdhPJwojF1/sq+xfygWWoJd7PvjM53WyuPf8Nd+Tw6jH4PzPCaeufjMYI+Yv+PKmImWIEaesLI5rp/287INPrLafU2b3mDtP40z
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3ea:: with SMTP id s10mr4453619jaq.2.1598432056177;
 Wed, 26 Aug 2020 01:54:16 -0700 (PDT)
Date:   Wed, 26 Aug 2020 01:54:16 -0700
In-Reply-To: <001a1143e62eb6a9510565640e76@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000e7fab005adc3f636@google.com>
Subject: Re: WARNING: ODEBUG bug in __do_softirq
From:   syzbot <syzbot+51c9bdfa559769d2f897@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, anna.schumaker@netapp.com,
        bfields@fieldses.org, bp@alien8.de, davem@davemloft.net,
        douly.fnst@cn.fujitsu.com, hpa@zytor.com, jlayton@kernel.org,
        konrad.wilk@oracle.com, len.brown@intel.com,
        linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
        mingo@kernel.org, mingo@redhat.com, netdev@vger.kernel.org,
        paulmck@kernel.org, peterz@infradead.org, puwen@hygon.cn,
        rafael.j.wysocki@intel.com, syzkaller-bugs@googlegroups.com,
        tglx@linutronix.de, trond.myklebust@hammerspace.com,
        trond.myklebust@primarydata.com, vbabka@suse.cz, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    3a00d3df Add linux-next specific files for 20200825
git tree:       linux-next
console output: https://syzkaller.appspot.com/x/log.txt?x=15080fa9900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=9ef0a5f95935d447
dashboard link: https://syzkaller.appspot.com/bug?extid=51c9bdfa559769d2f897
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17927a2e900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=132b8ede900000

The issue was bisected to:

commit 5b317cbf2bcb85a1e96ce87717cb991ecab1dd4d
Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Date:   Fri Feb 22 09:17:11 2019 +0000

    Merge branch 'pm-cpufreq-fixes'

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=171ead5d200000
final oops:     https://syzkaller.appspot.com/x/report.txt?x=149ead5d200000
console output: https://syzkaller.appspot.com/x/log.txt?x=109ead5d200000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+51c9bdfa559769d2f897@syzkaller.appspotmail.com
Fixes: 5b317cbf2bcb ("Merge branch 'pm-cpufreq-fixes'")

------------[ cut here ]------------
ODEBUG: free active (active state 0) object type: work_struct hint: afs_manage_cell+0x0/0x11c0 fs/afs/cell.c:498
WARNING: CPU: 1 PID: 16 at lib/debugobjects.c:485 debug_print_object+0x160/0x250 lib/debugobjects.c:485
Modules linked in:
CPU: 1 PID: 16 Comm: ksoftirqd/1 Not tainted 5.9.0-rc2-next-20200825-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:debug_print_object+0x160/0x250 lib/debugobjects.c:485
Code: dd 60 56 94 88 48 89 fa 48 c1 ea 03 80 3c 02 00 0f 85 bf 00 00 00 48 8b 14 dd 60 56 94 88 48 c7 c7 c0 4b 94 88 e8 eb bd a4 fd <0f> 0b 83 05 13 50 1b 07 01 48 83 c4 20 5b 5d 41 5c 41 5d c3 48 89
RSP: 0018:ffffc90000d7fbf8 EFLAGS: 00010086
RAX: 0000000000000000 RBX: 0000000000000003 RCX: 0000000000000000
RDX: ffff8880a9686440 RSI: ffffffff815da937 RDI: fffff520001aff71
RBP: 0000000000000001 R08: 0000000000000001 R09: ffff8880ae720f8b
R10: 0000000000000000 R11: 203a47554245444f R12: ffffffff89ba35e0
R13: ffffffff814b6290 R14: dead000000000100 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880ae700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f9120aabe78 CR3: 0000000088b2e000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 __debug_check_no_obj_freed lib/debugobjects.c:967 [inline]
 debug_check_no_obj_freed+0x301/0x41c lib/debugobjects.c:998
 kfree+0xf0/0x2c0 mm/slab.c:3755
 rcu_do_batch kernel/rcu/tree.c:2474 [inline]
 rcu_core+0x61e/0x1220 kernel/rcu/tree.c:2709
 __do_softirq+0x2de/0xa24 kernel/softirq.c:298
 run_ksoftirqd kernel/softirq.c:652 [inline]
 run_ksoftirqd+0x89/0x100 kernel/softirq.c:644
 smpboot_thread_fn+0x655/0x9e0 kernel/smpboot.c:165
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294


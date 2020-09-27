Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73724279D31
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 02:38:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728855AbgI0AiS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 20:38:18 -0400
Received: from mail-il1-f199.google.com ([209.85.166.199]:45029 "EHLO
        mail-il1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgI0AiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Sep 2020 20:38:17 -0400
Received: by mail-il1-f199.google.com with SMTP id i3so5553688ilr.11
        for <netdev@vger.kernel.org>; Sat, 26 Sep 2020 17:38:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=fDiQouvi58KqMcl70Pm7uMuNUtLTT67ERZXcegS8S1U=;
        b=pCVdymHw/Ig3tiq8F7e8ghiCV1gnHhtzKVn5CYm9egDLH7D/8R0xmEPyIo8Zo+6q1B
         hgmyutqnnwPD328OXgWXSrXpWN1BrAN6Jp45J0iFOSByFyE8hX/64ieITSORI3hGzR0z
         kr1NUL/zunNUl7ELfq1kIUxxPX7aew9MUMJDewmvSO2h1oglYN1rUaJ+PrBk8xJeVTpN
         9RQvkr41rfnSjI+TYlswqwJHytoVnrUwEGdwf8nvXf5ORQdfeIL5kK7VovHfWehjng4l
         cE/wOk0nrA5QZqfVYSNUa6UZuICwVBo9m3HxMtSqysNY0+h2G6MQO9IHf904XoAtH+3J
         wjyw==
X-Gm-Message-State: AOAM532H8dknNPR08cuZWDsyKCJZhXPFK/+4RNaTpF89wp1UuVRcvgmR
        H8c6XtqJXmzq+3puHQnwoqC4xhCQusfMjKRaaWECre6Fr2L1
X-Google-Smtp-Source: ABdhPJyYQ0IdidmXzIFIr5tonQjfTHkMbga+TsmTwCAfjrqzbnx88uP1TAd+Y0FyyVyIkV/L62XdrWx53VMGoWs0pxtrFYpyMlyq
MIME-Version: 1.0
X-Received: by 2002:a6b:5804:: with SMTP id m4mr3207206iob.14.1601167096465;
 Sat, 26 Sep 2020 17:38:16 -0700 (PDT)
Date:   Sat, 26 Sep 2020 17:38:16 -0700
In-Reply-To: <000000000000bd9ee505b01f60e2@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000002cbe905b040c47c@google.com>
Subject: Re: WARNING in hrtimer_forward
From:   syzbot <syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    ba5f4cfe bpf: Add comment to document BTF type PTR_TO_BTF_..
git tree:       bpf-next
console output: https://syzkaller.appspot.com/x/log.txt?x=13f316e5900000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d44e1360b76d34dc
dashboard link: https://syzkaller.appspot.com/bug?extid=ca740b95a16399ceb9a5
compiler:       gcc (GCC) 10.1.0-syz 20200507
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1148fe4b900000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f5218d900000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+ca740b95a16399ceb9a5@syzkaller.appspotmail.com

------------[ cut here ]------------
WARNING: CPU: 0 PID: 6901 at kernel/time/hrtimer.c:932 hrtimer_forward+0x1e3/0x260 kernel/time/hrtimer.c:932
Kernel panic - not syncing: panic_on_warn set ...
CPU: 0 PID: 6901 Comm: kworker/u4:1 Not tainted 5.9.0-rc6-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: phy4 ieee80211_iface_work
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:77 [inline]
 dump_stack+0x198/0x1fd lib/dump_stack.c:118
 panic+0x382/0x7fb kernel/panic.c:231
 __warn.cold+0x20/0x4b kernel/panic.c:600
 report_bug+0x1bd/0x210 lib/bug.c:198
 handle_bug+0x38/0x90 arch/x86/kernel/traps.c:234
 exc_invalid_op+0x14/0x40 arch/x86/kernel/traps.c:254
 asm_exc_invalid_op+0x12/0x20 arch/x86/include/asm/idtentry.h:536
RIP: 0010:hrtimer_forward+0x1e3/0x260 kernel/time/hrtimer.c:932
Code: e5 4d 0f 4e ec e8 ad 24 10 00 4c 89 6b 20 e8 a4 24 10 00 4c 89 f0 48 83 c4 18 5b 5d 41 5c 41 5d 41 5e 41 5f c3 e8 8d 24 10 00 <0f> 0b 45 31 f6 eb dd e8 81 24 10 00 4c 89 e0 48 8b 3c 24 48 99 48
RSP: 0018:ffffc90000007d90 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88808ded4b78 RCX: ffffffff81666168
RDX: ffff8880942f0200 RSI: ffffffff816662b3 RDI: 0000000000000001
RBP: 00000000061a8000 R08: 0000000000000001 R09: ffff8880942f0b00
R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
R13: 000000a6d77ff62e R14: 0000000000000001 R15: dffffc0000000000
 mac80211_hwsim_beacon+0x159/0x1a0 drivers/net/wireless/mac80211_hwsim.c:1726
 __run_hrtimer kernel/time/hrtimer.c:1524 [inline]
 __hrtimer_run_queues+0x6a9/0xfc0 kernel/time/hrtimer.c:1588
 hrtimer_run_softirq+0x17b/0x360 kernel/time/hrtimer.c:1605
 __do_softirq+0x1f8/0xb23 kernel/softirq.c:298
 asm_call_on_stack+0xf/0x20 arch/x86/entry/entry_64.S:706
 </IRQ>
 __run_on_irqstack arch/x86/include/asm/irq_stack.h:22 [inline]
 run_on_irqstack_cond arch/x86/include/asm/irq_stack.h:48 [inline]
 do_softirq_own_stack+0x9d/0xd0 arch/x86/kernel/irq_64.c:77
 invoke_softirq kernel/softirq.c:393 [inline]
 __irq_exit_rcu kernel/softirq.c:423 [inline]
 irq_exit_rcu+0x235/0x280 kernel/softirq.c:435
 sysvec_apic_timer_interrupt+0x51/0xf0 arch/x86/kernel/apic/apic.c:1091
 asm_sysvec_apic_timer_interrupt+0x12/0x20 arch/x86/include/asm/idtentry.h:581
RIP: 0010:arch_local_irq_restore arch/x86/include/asm/paravirt.h:770 [inline]
RIP: 0010:lock_acquire+0x27b/0xaf0 kernel/locking/lockdep.c:5032
Code: ba 00 00 00 00 00 fc ff df 48 c1 e8 03 80 3c 10 00 0f 85 1d 07 00 00 48 83 3d d8 41 a0 08 00 0f 84 73 05 00 00 4c 89 ff 57 9d <0f> 1f 44 00 00 48 b8 00 00 00 00 00 fc ff df 48 03 44 24 08 48 c7
RSP: 0018:ffffc90000e37c18 EFLAGS: 00000286
RAX: 1ffffffff13f8d7d RBX: ffff8880942f0200 RCX: 0000000000000001
RDX: dffffc0000000000 RSI: 0000000000000008 RDI: 0000000000000286
RBP: ffffc90000e37da8 R08: 0000000000000000 R09: ffffffff8d108aa7
R10: fffffbfff1a21154 R11: 0000000000000000 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000286
 process_one_work+0x8bb/0x1670 kernel/workqueue.c:2245
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2415
 kthread+0x3b5/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294
Kernel Offset: disabled
Rebooting in 86400 seconds..


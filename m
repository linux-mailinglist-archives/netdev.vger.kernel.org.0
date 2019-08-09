Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDFF38749E
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 10:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406022AbfHIIx7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 04:53:59 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:38005 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406003AbfHIIx7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 04:53:59 -0400
Received: by mail-ot1-f65.google.com with SMTP id d17so129966183oth.5
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 01:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZoBls2C+U4f9Nf+prWZNwWqMkPQFkHYNMYkvPukqrug=;
        b=q/nNPN15UvkVq0N5V77Og5myO0DRlUMkSHgXHdK8k8XFPmW4bVUAN12ijuzdIo2KTW
         eCDEejkZvohR9zFbnU9Moat4g7WYV/h3j3ut3x3QQQsFKfwlIxJ1uEsU6OXvFtTrwIdx
         kUWEgvQuqulAc4OYv571mmOYBBzHl02eQgRJkRQcpztZprXEmq+ofppuOJK4qcqVidxM
         jz7qBr64MIQsFhmU0j2DbIezYG1syl3UmYoPPAQo15b/g4Dfji8T5X/DpZEjcOeP1ASo
         f2frq+udKxQNkTbrWppJFMsNj+Zig6yZe9vWtK1WXLyXdaovUOUTPCtbWBzLzxe56b/I
         8+Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZoBls2C+U4f9Nf+prWZNwWqMkPQFkHYNMYkvPukqrug=;
        b=BxscHTeHfFlPxltf3V1DTuWZOSB4a9OWeYLY7ZC7u5c1c1W1zRPaEn/G4vegYJ1hNH
         vepRArWGJaRXrW6KCVLIDnlblSFUmUM6+SxhKxPd0n+0pWoygAkddsvKGs4LKqKGakep
         nF9iql+7G5ziOUIncrFhnbtr60TEYjpS7fTW/kEZe2O5j48QJ6fu5osc9oiJek1M9T9d
         6nkhvmjCkLwNwlj5U5g0U4apIYEvF5hoIBn0woDzz4Pr784MiqEAEX0jZfaeS6865UmG
         Vvx/CG4rrHhR0SWUuxn2htE4qAkk1Q4lRjquUT0VIqmaXuJqDB+TJFqMYt+L03pgpGTZ
         dCEg==
X-Gm-Message-State: APjAAAXEKxDmwrPCydtIaccwKX7xg2PH3T/Ya4EjXIojvAxB5Uwhio0a
        N17YvqmTxVMybEqD+rNA1xyr+7evhcZ8ZSY90W+f+qHLUzy21A==
X-Google-Smtp-Source: APXvYqyHl309j/Dz6Bnrl6vCRjEg8Q4Otd6ho+TwFqg+kAEwtrNFYLxHk1BeUJZIAZN3WDlH78fwEk52BnK2wNJJ5do=
X-Received: by 2002:a02:c00c:: with SMTP id y12mr11181363jai.65.1565340837377;
 Fri, 09 Aug 2019 01:53:57 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000a244b3058f9dc7d6@google.com> <4616850c-bf9e-d32a-3cfb-dbbaec5e17f2@I-love.SAKURA.ne.jp>
In-Reply-To: <4616850c-bf9e-d32a-3cfb-dbbaec5e17f2@I-love.SAKURA.ne.jp>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Fri, 9 Aug 2019 10:53:46 +0200
Message-ID: <CACT4Y+Y7d29kA1fpS13QvSopknuChPANRc9evxeWiJd-zkyNug@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in tomoyo_socket_sendmsg_permission
To:     Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc:     syzbot <syzbot+b91501546ab4037f685f@syzkaller.appspotmail.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-hams <linux-hams@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 12:08 AM Tetsuo Handa
<penguin-kernel@i-love.sakura.ne.jp> wrote:
>
> On 2019/08/09 1:45, syzbot wrote:
> > Hello,
> >
> > syzbot found the following crash on:
> >
> > HEAD commit:    107e47cc vrf: make sure skb->data contains ip header to ma..
> > git tree:       net
> > console output: https://syzkaller.appspot.com/x/log.txt?x=139506d8600000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=4dba67bf8b8c9ad7
> > dashboard link: https://syzkaller.appspot.com/bug?extid=b91501546ab4037f685f
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
>
> This is not TOMOYO's bug. LSM modules expect that "struct sock" does not go away.
>
> Also, another use-after-free (presumably on the same "struct sock") was concurrently
> inflight at nr_insert_socket() in net/netrom/af_netrom.c . Thus, suspecting netrom's bug.

There is a number of UAFs/refcount bugs in nr sockets lately. Most
likely it's the same issue them. Most of them were bisected to:

commit c8c8218ec5af5d2598381883acbefbf604e56b5e
Date: Thu Jun 27 21:30:58 2019 +0000
  netrom: fix a memory leak in nr_rx_frame()

+Cong


> [  625.441058][    C0] ------------[ cut here ]------------
> [  625.446837][    C0] refcount_t: increment on 0; use-after-free.
> [  625.461518][    C0] WARNING: CPU: 0 PID: 0 at lib/refcount.c:156 refcount_inc_checked+0x61/0x70
> [  625.479173][    C0] Kernel panic - not syncing: panic_on_warn set ...
> [  625.746558][    C0] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.2.0+ #97
> [  625.746575][    C0] Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> [  625.755731][    C0] Call Trace:
> [  625.770091][    C0]  <IRQ>
> [  625.777543][    C0]  dump_stack+0x172/0x1f0
> [  625.786005][    C0]  ? refcount_inc_not_zero_checked+0x1f0/0x200
> [  625.794831][    C0]  panic+0x2dc/0x755
> [  625.805217][    C0]  ? add_taint.cold+0x16/0x16
> [  625.813697][    C0]  ? __kasan_check_write+0x14/0x20
> [  625.822433][    C0]  ? __warn.cold+0x5/0x4c
> [  625.832388][    C0]  ? __warn+0xe7/0x1e0
> [  625.841820][    C0]  ? refcount_inc_checked+0x61/0x70
> [  625.851148][    C0]  __warn.cold+0x20/0x4c
> [  625.859701][    C0]  ? vprintk_emit+0x1ea/0x700
> [  625.867208][    C0]  ? refcount_inc_checked+0x61/0x70
> [  625.875413][    C0]  report_bug+0x263/0x2b0
> [  625.884580][    C0]  do_error_trap+0x11b/0x200
> [  625.893730][    C0]  do_invalid_op+0x37/0x50
> [  625.902936][    C0]  ? refcount_inc_checked+0x61/0x70
> [  625.911858][    C0]  invalid_op+0x14/0x20
> [  625.920825][    C0] RIP: 0010:refcount_inc_checked+0x61/0x70
> [  625.929407][    C0] Code: 1d 3f 6e 64 06 31 ff 89 de e8 cb d2 35 fe 84 db 75 dd e8 82 d1 35 fe 48 c7 c7 40 09 c6 87 c6 05 1f 6e 64 06 01 e8 77 39 07 fe <0f> 0b eb c1 90 90 90 90 90 90 90 90 90 90 90 55 48 89 e5 41 57 41
> [  625.937608][    C0] RSP: 0018:ffff8880ae809bf0 EFLAGS: 00010282
> [  625.948510][    C0] RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> [  625.957237][    C0] RDX: 0000000000000100 RSI: ffffffff815c3a26 RDI: ffffed1015d01370
> [  625.967249][    C0] RBP: ffff8880ae809c00 R08: ffffffff88c7a1c0 R09: fffffbfff14a775b
> [  625.991542][    C0] R10: fffffbfff14a775a R11: ffffffff8a53bad7 R12: ffff8880a066f480
> [  626.002193][    C0] R13: ffff8880a066f468 R14: ffff88808d69ef48 R15: ffff88808d69ef20
> [  626.014844][    C0]  ? vprintk_func+0x86/0x189
> [  626.027298][    C0]  nr_insert_socket+0x2d/0xe0
> [  626.041237][    C0]  nr_rx_frame+0x1605/0x1e73
> [  626.051737][    C0]  nr_loopback_timer+0x7b/0x170
> [  626.073842][    C0]  call_timer_fn+0x1ac/0x780
> [  626.092970][    C0]  ? nr_process_rx_frame+0x1540/0x1540
> [  626.108552][    C0]  ? msleep_interruptible+0x150/0x150
> [  626.118574][    C0]  ? run_timer_softirq+0x685/0x17a0
> [  626.131811][    C0]  ? trace_hardirqs_on+0x67/0x240
> [  626.145424][    C0]  ? __kasan_check_read+0x11/0x20
> [  626.156592][    C0]  ? nr_process_rx_frame+0x1540/0x1540
> [  626.164362][    C0]  ? nr_process_rx_frame+0x1540/0x1540
> [  626.175423][    C0]  run_timer_softirq+0x697/0x17a0
> [  626.188804][    C0]  ? add_timer+0x930/0x930
> [  626.202652][    C0]  ? kvm_clock_read+0x18/0x30
> [  626.215813][    C0]  ? kvm_sched_clock_read+0x9/0x20
> [  626.231378][    C0]  ? sched_clock+0x2e/0x50
> [  626.231395][    C0]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  626.231408][    C0]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  626.231432][    C0]  __do_softirq+0x262/0x98c
> [  626.244512][    C0]  ? sched_clock_cpu+0x1b/0x1b0
> [  626.244531][    C0]  irq_exit+0x19b/0x1e0
> [  626.244545][    C0]  smp_apic_timer_interrupt+0x1a3/0x610
> [  626.244558][    C0]  apic_timer_interrupt+0xf/0x20
> [  626.244563][    C0]  </IRQ>
> [  626.244579][    C0] RIP: 0010:native_safe_halt+0xe/0x10
> [  626.244606][    C0] Code: b8 94 73 fa eb 8a 90 90 90 90 90 90 e9 07 00 00 00 0f 00 2d 34 25 4f 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 24 25 4f 00 fb f4 <c3> 90 55 48 89 e5 41 57 41 56 41 55 41 54 53 e8 0e 56 27 fa e8 c9
> [  626.257081][    C0] RSP: 0018:ffffffff88c07ce8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff13
> [  626.269812][    C0] RAX: 1ffffffff11a5e05 RBX: ffffffff88c7a1c0 RCX: 0000000000000000
> [  626.281053][    C0] RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffffffff88c7aa4c
> [  626.290913][    C0] RBP: ffffffff88c07d18 R08: ffffffff88c7a1c0 R09: 0000000000000000
> [  626.303361][    C0] R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
> [  626.314081][    C0] R13: ffffffff89a4f778 R14: 0000000000000000 R15: 0000000000000000
> [  626.314116][    C0]  ? default_idle+0x4e/0x360
> [  626.323075][    C0]  arch_cpu_idle+0xa/0x10
> [  626.333543][    C0]  default_idle_call+0x84/0xb0
> [  626.341839][    C0]  do_idle+0x413/0x760
> [  626.370736][    C0]  ? retint_kernel+0x2b/0x2b
> [  626.383044][    C0]  ? arch_cpu_idle_exit+0x80/0x80
> [  626.400071][    C0]  ? do_idle+0x387/0x760
> [  626.418085][    C0]  cpu_startup_entry+0x1b/0x20
> [  626.431835][    C0]  rest_init+0x245/0x37b
> [  626.459420][    C0]  arch_call_rest_init+0xe/0x1b
> [  626.471993][    C0]  start_kernel+0x912/0x951
> [  626.482387][    C0]  ? mem_encrypt_init+0xb/0xb
> [  626.495105][    C0]  ? __sanitizer_cov_trace_const_cmp4+0x16/0x20
> [  626.507125][    C0]  ? x86_family+0x41/0x50
> [  626.519773][    C0]  ? __sanitizer_cov_trace_const_cmp1+0x1a/0x20
> [  626.532837][    C0]  x86_64_start_reservations+0x29/0x2b
> [  626.545019][    C0]  x86_64_start_kernel+0x77/0x7b
> [  626.558711][    C0]  secondary_startup_64+0xa4/0xb0
> [  626.897092][    C0] Kernel Offset: disabled
> [  626.901428][    C0] Rebooting in 86400 seconds..
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/4616850c-bf9e-d32a-3cfb-dbbaec5e17f2%40I-love.SAKURA.ne.jp.

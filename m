Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29C6562C7A0
	for <lists+netdev@lfdr.de>; Wed, 16 Nov 2022 19:29:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbiKPS3e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Nov 2022 13:29:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233205AbiKPS3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Nov 2022 13:29:32 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26AF391E2;
        Wed, 16 Nov 2022 10:29:30 -0800 (PST)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1668623368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MBCp0Vo3Pdd121MgdNPezLvHBf5M1gYbYl1NxXK8N4I=;
        b=GyEkWitgMfku57mbbIPcwTVcioxe/C0xXlo3Ir8yKF1G6RPrBjBbX0kQKsF7hBn9yTPSDd
        6uO6FFMSbo9ThWS79es4BU+9lXCDmPJ+Se71yJnsXZGn8+s6qIiGFuorwx9Q6dAQcMf23z
        +qgqxcVqn5KzUIiXvlT9eUjtjv49AgdqF7eMs4ORlLUuu/YLrnkO86hfcQmmvzT0cj/1yf
        16HFKh5dA3Rdr68ZXO8KHPKKeffN6z3NsBpiJRTJ1sUAJwl5jPwHyolB+WWGaG1Lmk3qyp
        prHpj4sFkiT3liMEl6krD2wZ63kqeXFcMMsSft8E2pLN+JmUpRxeIRw/n22EGQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1668623368;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MBCp0Vo3Pdd121MgdNPezLvHBf5M1gYbYl1NxXK8N4I=;
        b=Ho59w5qtR7asU99YTRJPGwVFIyM9tzCwHaoLup2hFSH2sE82X11FL/8bsjffYUA44iqQFl
        Ou7sphlYl479qpAg==
To:     syzbot <syzbot+6fb78d577e89e69602f9@syzkaller.appspotmail.com>,
        ben-linux@fluff.org, bp@alien8.de, daniel.sneddon@linux.intel.com,
        dave.hansen@linux.intel.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        netdev@vger.kernel.org, pbonzini@redhat.com,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        syzkaller-bugs@googlegroups.com, x86@kernel.org,
        Steven Rostedt <rosted@goodmis.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Subject: Re: [syzbot] WARNING in call_timer_fn
In-Reply-To: <0000000000009d5daa05ed9815fa@google.com>
References: <0000000000009d5daa05ed9815fa@google.com>
Date:   Wed, 16 Nov 2022 19:29:27 +0100
Message-ID: <878rkapxbs.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16 2022 at 07:25, syzbot wrote:
> HEAD commit:    7eba4505394e net: dcb: move getapptrust to separate function
> git tree:       net-next
> console output: https://syzkaller.appspot.com/x/log.txt?x=16626ce9880000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=893a728fb1a6b263
> dashboard link: https://syzkaller.appspot.com/bug?extid=6fb78d577e89e69602f9
> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16899f35880000
>
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/68b1a18c1aad/disk-7eba4505.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/f03970850c94/vmlinux-7eba4505.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/4775c120c4c6/bzImage-7eba4505.xz
>
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+6fb78d577e89e69602f9@syzkaller.appspotmail.com
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5978 at kernel/workqueue.c:1438 __queue_work+0xf70/0x13b0 kernel/workqueue.c:1438
> Modules linked in:
> CPU: 0 PID: 5978 Comm: syz-executor.3 Not tainted 6.1.0-rc4-syzkaller-01070-g7eba4505394e #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/26/2022
> RIP: 0010:__queue_work+0xf70/0x13b0 kernel/workqueue.c:1438
> Code: e0 07 83 c0 03 38 d0 7c 09 84 d2 74 05 e8 e8 64 7b 00 8b 5b 2c 31 ff 83 e3 20 89 de e8 09 5e 2e 00 85 db 75 42 e8 50 61 2e 00 <0f> 0b e9 7e f7 ff ff e8 44 61 2e 00 0f 0b e9 10 f7 ff ff e8 38 61
> RSP: 0018:ffffc90000007c98 EFLAGS: 00010046
> RAX: 0000000000000000 RBX: 0000000000000100 RCX: 0000000000000100
> RDX: ffff888022ba9d40 RSI: ffffffff8151be20 RDI: 0000000000000005
> RBP: ffffc90000007d60 R08: 0000000000000005 R09: 0000000000000000
> R10: 0000000000000100 R11: 0000000000000001 R12: ffff88806ccf4b30
> R13: ffff88806ccf4b78 R14: 0000000000000000 R15: ffff88807568f000
> FS:  0000000000000000(0000) GS:ffff8880b9a00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005555558e1708 CR3: 0000000076b84000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  <IRQ>
>  call_timer_fn+0x1da/0x7c0 kernel/time/timer.c:1474
>  expire_timers kernel/time/timer.c:1514 [inline]
>  __run_timers.part.0+0x4a3/0xaf0 kernel/time/timer.c:1790
>  __run_timers kernel/time/timer.c:1768 [inline]
>  run_timer_softirq+0xb7/0x1d0 kernel/time/timer.c:1803
>  __do_softirq+0x1fb/0xadc kernel/softirq.c:571
>  invoke_softirq kernel/softirq.c:445 [inline]
>  __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
>  irq_exit_rcu+0x9/0x20 kernel/softirq.c:662
>  sysvec_apic_timer_interrupt+0x97/0xc0 arch/x86/kernel/apic/apic.c:1107
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:649
> RIP: 0010:lock_acquire+0x227/0x630 kernel/locking/lockdep.c:5636
> Code: 76 9f 7e 83 f8 01 0f 85 3a 03 00 00 9c 58 f6 c4 02 0f 85 25 03 00 00 48 83 7c 24 08 00 74 01 fb 48 b8 00 00 00 00 00 fc ff df <48> 01 c3 48 c7 03 00 00 00 00 48 c7 43 08 00 00 00 00 48 8b 84 24
> RSP: 0018:ffffc90006f678d0 EFLAGS: 00000206
> RAX: dffffc0000000000 RBX: 1ffff92000decf1d RCX: 0000000000000001
> RDX: 1ffff110045754f1 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: 0000000000000001 R09: ffffffff912a75ef
> R10: fffffbfff2254ebd R11: 1ffffffff212a1df R12: 0000000000000000
> R13: 0000000000000000 R14: ffff88807568f138 R15: 0000000000000000
>  __flush_workqueue+0x118/0x13a0 kernel/workqueue.c:2809
>  drain_workqueue+0x1a9/0x3c0 kernel/workqueue.c:2974
>  hci_dev_close_sync+0x2f3/0x1200 net/bluetooth/hci_sync.c:4809
>  hci_dev_do_close+0x31/0x70 net/bluetooth/hci_core.c:554
>  hci_unregister_dev+0x183/0x4e0 net/bluetooth/hci_core.c:2702
>  vhci_release+0x80/0xf0 drivers/bluetooth/hci_vhci.c:568
>  __fput+0x27c/0xa90 fs/file_table.c:320
>  task_work_run+0x16f/0x270 kernel/task_work.c:179
>  exit_task_work include/linux/task_work.h:38 [inline]
>  do_exit+0xb3d/0x2a30 kernel/exit.c:820
>  do_group_exit+0xd4/0x2a0 kernel/exit.c:950
>  __do_sys_exit_group kernel/exit.c:961 [inline]
>  __se_sys_exit_group kernel/exit.c:959 [inline]
>  __x64_sys_exit_group+0x3e/0x50 kernel/exit.c:959
>  do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>  do_syscall_64+0x39/0xb0 arch/x86/entry/common.c:80
>  entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7f3d8a68b639
> Code: Unable to access opcode bytes at 0x7f3d8a68b60f.
> RSP: 002b:00007ffd554b9878 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
> RAX: ffffffffffffffda RBX: 0000000000000029 RCX: 00007f3d8a68b639
> RDX: 00007f3d8a68cc8a RSI: 0000000000000000 RDI: 0000000000000007
> RBP: 0000000000000007 R08: ffffffffff000000 R09: 0000000000000029
> R10: 00000000000003b8 R11: 0000000000000246 R12: 00007ffd554b9f00
> R13: 0000000000000003 R14: 00007ffd554b9e9c R15: 00007f3d8a782b60

That's precisely the case I described here:

  https://lore.kernel.org/all/87iljhsftt.ffs@tglx

and the final fix is here:

  https://lore.kernel.org/all/20221115195802.415956561@linutronix.de

but that will take a bit to get upstream. In the meanwhile someone could
sprinkle 'if (in_shutdown)' conditionals into the code to prevent the
splat.

Thanks,

        tglx


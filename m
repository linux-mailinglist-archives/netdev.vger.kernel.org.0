Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C285E16A385
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 11:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbgBXKJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 05:09:09 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:38444 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726509AbgBXKJJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 05:09:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582538947;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BQdYnPP8HxWs+uZSgi16J0io0jxrlBhTUBFnRERUtY0=;
        b=D8FmkQp0udkdeEADRP4hCcsBZ9r/aH080QAXfRWoyQ/fUsuEpS/GBls9H5pbOD6C2hJq3T
        MDgcNixp+ZD8cMnkKSBEtT9mdfIRadgf0DU033Nbr1ResfhIq2wT3dt79v+A3BTm093vVf
        i2a3QtUY/AiqZyvBKvd4PN5k9YcvTJY=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-133-k2ImwHmEOhKuHJunkvxbzA-1; Mon, 24 Feb 2020 05:08:59 -0500
X-MC-Unique: k2ImwHmEOhKuHJunkvxbzA-1
Received: by mail-wr1-f69.google.com with SMTP id d9so2148686wrv.21
        for <netdev@vger.kernel.org>; Mon, 24 Feb 2020 02:08:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BQdYnPP8HxWs+uZSgi16J0io0jxrlBhTUBFnRERUtY0=;
        b=WfGNiwynrMj5zvpc02yseVUBHKslosstNNiLJtAvpQ4M1ZJGwhHfgRkwDMai4sKsXp
         Un4GjaPfxY+IAN2u4SLsNt/1GAGNQkInATiRN5uAACI7YS6peUvh8c2azITi4Nr+5LTZ
         VOjTXKEEhvxdRpPr7IPHVnTayVIPkyF6sHJ/n19JpJ9vDDOBavOZQJdqUcnatbN0v8lq
         Q78RJiK9UlUy6GfyTmnXqp4vG9O6hCAy/L8SJtzPoF8VLQ1agF/CXjq9f3PD1WYz3zNv
         fUwnSBF3Z9UHH4AnYmHc70NZid5W8NMW194qqhpjRwE7w50PrxLs1qM+scOZtcRVVlfp
         SWPA==
X-Gm-Message-State: APjAAAUqhYFSOmNWpNSNcJzxqUEjJy8c2uFoTqvlCWcJGB6iYeRP5fLK
        HPFX6oaSfFqtLqkB7QdTV9Qb2IY6C3VWXuLPfeeOsFKZat+NsV++8NlVkVtVMwri/7YavSEHI/e
        B9fPULtCpbtLSWz7O
X-Received: by 2002:a1c:7215:: with SMTP id n21mr22393115wmc.154.1582538937469;
        Mon, 24 Feb 2020 02:08:57 -0800 (PST)
X-Google-Smtp-Source: APXvYqyE4VmiFmFepaEFd75/8+zzFgL7ObJlpFle4PqpDqB2QHVsKB60yaKVF9TylbfHLQMGQmxcKg==
X-Received: by 2002:a1c:7215:: with SMTP id n21mr22393032wmc.154.1582538936560;
        Mon, 24 Feb 2020 02:08:56 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id d18sm12577197wrw.49.2020.02.24.02.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 02:08:55 -0800 (PST)
Date:   Mon, 24 Feb 2020 11:08:53 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Hillf Danton <hdanton@sina.com>, Dexuan Cui <decui@microsoft.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     syzbot <syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com>,
        davem@davemloft.net, kuba@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com,
        virtualization@lists.linux-foundation.org
Subject: Re: INFO: task hung in lock_sock_nested (2)
Message-ID: <20200224100853.wd67e7rqmtidfg7y@steredhat>
References: <0000000000004241ff059f2eb8a4@google.com>
 <20200223075025.9068-1-hdanton@sina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200223075025.9068-1-hdanton@sina.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 23, 2020 at 03:50:25PM +0800, Hillf Danton wrote:
> On Sat, 22 Feb 2020 10:58:12 -0800
> > syzbot found the following crash on:
> > 
> > HEAD commit:    2bb07f4e tc-testing: updated tdc tests for basic filter
> > git tree:       net-next
> > console output: https://syzkaller.appspot.com/x/log.txt?x=122efdede00000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=768cc3d3e277cc16
> > dashboard link: https://syzkaller.appspot.com/bug?extid=731710996d79d0d58fbc
> > compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14887de9e00000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=149eec81e00000
> > 
> > The bug was bisected to:
> > 
> > commit 408624af4c89989117bb2c6517bd50b7708a2fcd
> > Author: Stefano Garzarella <sgarzare@redhat.com>
> > Date:   Tue Dec 10 10:43:06 2019 +0000
> > 
> >     vsock: use local transport when it is loaded
> > 
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1011e27ee00000
> > final crash:    https://syzkaller.appspot.com/x/report.txt?x=1211e27ee00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=1411e27ee00000
> > 
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+731710996d79d0d58fbc@syzkaller.appspotmail.com
> > Fixes: 408624af4c89 ("vsock: use local transport when it is loaded")
> > 
> > INFO: task syz-executor280:9768 blocked for more than 143 seconds.
> >       Not tainted 5.6.0-rc1-syzkaller #0
> > "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > syz-executor280 D27912  9768   9766 0x00000000
> > Call Trace:
> >  context_switch kernel/sched/core.c:3386 [inline]
> >  __schedule+0x934/0x1f90 kernel/sched/core.c:4082
> >  schedule+0xdc/0x2b0 kernel/sched/core.c:4156
> >  __lock_sock+0x165/0x290 net/core/sock.c:2413
> >  lock_sock_nested+0xfe/0x120 net/core/sock.c:2938
> >  virtio_transport_release+0xc4/0xd60 net/vmw_vsock/virtio_transport_common.c:832
> >  vsock_assign_transport+0xf3/0x3b0 net/vmw_vsock/af_vsock.c:454
> >  vsock_stream_connect+0x2b3/0xc70 net/vmw_vsock/af_vsock.c:1288
> >  __sys_connect_file+0x161/0x1c0 net/socket.c:1857
> >  __sys_connect+0x174/0x1b0 net/socket.c:1874
> >  __do_sys_connect net/socket.c:1885 [inline]
> >  __se_sys_connect net/socket.c:1882 [inline]
> >  __x64_sys_connect+0x73/0xb0 net/socket.c:1882
> >  do_syscall_64+0xfa/0x790 arch/x86/entry/common.c:294
> >  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> > RIP: 0033:0x440209
> > Code: Bad RIP value.
> > RSP: 002b:00007ffdb9f67718 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> > RAX: ffffffffffffffda RBX: 00000000004002c8 RCX: 0000000000440209
> > RDX: 0000000000000010 RSI: 0000000020000440 RDI: 0000000000000003
> > RBP: 00000000006ca018 R08: 00000000004002c8 R09: 00000000004002c8
> > R10: 00000000004002c8 R11: 0000000000000246 R12: 0000000000401a90
> > R13: 0000000000401b20 R14: 0000000000000000 R15: 0000000000000000
> > 
> > Showing all locks held in the system:
> > 1 lock held by khungtaskd/951:
> >  #0: ffffffff89bac240 (rcu_read_lock){....}, at: debug_show_all_locks+0x5f/0x279 kernel/locking/lockdep.c:5333
> > 1 lock held by rsyslogd/9652:
> >  #0: ffff8880a6533120 (&f->f_pos_lock){+.+.}, at: __fdget_pos+0xee/0x110 fs/file.c:821
> > 2 locks held by getty/9742:
> >  #0: ffff8880a693f090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
> >  #1: ffffc900061bb2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> > 2 locks held by getty/9743:
> >  #0: ffff88809f7a1090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
> >  #1: ffffc900061b72e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> > 2 locks held by getty/9744:
> >  #0: ffff88809be3e090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
> >  #1: ffffc900061632e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> > 2 locks held by getty/9745:
> >  #0: ffff88808eb1e090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
> >  #1: ffffc900061bf2e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> > 2 locks held by getty/9746:
> >  #0: ffff88808d33a090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
> >  #1: ffffc900061732e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> > 2 locks held by getty/9747:
> >  #0: ffff8880a6a0c090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
> >  #1: ffffc900061c32e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> > 2 locks held by getty/9748:
> >  #0: ffff8880a6e4d090 (&tty->ldisc_sem){++++}, at: ldsem_down_read+0x33/0x40 drivers/tty/tty_ldsem.c:340
> >  #1: ffffc900061332e0 (&ldata->atomic_read_lock){+.+.}, at: n_tty_read+0x220/0x1bf0 drivers/tty/n_tty.c:2156
> > 1 lock held by syz-executor280/9768:
> >  #0: ffff8880987cb8d0 (sk_lock-AF_VSOCK){+.+.}, at: lock_sock include/net/sock.h:1516 [inline]
> >  #0: ffff8880987cb8d0 (sk_lock-AF_VSOCK){+.+.}, at: vsock_stream_connect+0xfb/0xc70 net/vmw_vsock/af_vsock.c:1258
> > 
> > =============================================
> > 
> > NMI backtrace for cpu 1
> > CPU: 1 PID: 951 Comm: khungtaskd Not tainted 5.6.0-rc1-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > Call Trace:
> >  __dump_stack lib/dump_stack.c:77 [inline]
> >  dump_stack+0x197/0x210 lib/dump_stack.c:118
> >  nmi_cpu_backtrace.cold+0x70/0xb2 lib/nmi_backtrace.c:101
> >  nmi_trigger_cpumask_backtrace+0x23b/0x28b lib/nmi_backtrace.c:62
> >  arch_trigger_cpumask_backtrace+0x14/0x20 arch/x86/kernel/apic/hw_nmi.c:38
> >  trigger_all_cpu_backtrace include/linux/nmi.h:146 [inline]
> >  check_hung_uninterruptible_tasks kernel/hung_task.c:205 [inline]
> >  watchdog+0xb11/0x10c0 kernel/hung_task.c:289
> >  kthread+0x361/0x430 kernel/kthread.c:255
> >  ret_from_fork+0x24/0x30 arch/x86/entry/entry_64.S:352
> > Sending NMI from CPU 1 to CPUs 0:
> > NMI backtrace for cpu 0
> > CPU: 0 PID: 0 Comm: swapper/0 Not tainted 5.6.0-rc1-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
> > RIP: 0010:group_is_overloaded kernel/sched/fair.c:7929 [inline]
> > RIP: 0010:group_classify kernel/sched/fair.c:7964 [inline]
> > RIP: 0010:update_sg_lb_stats kernel/sched/fair.c:8077 [inline]
> > RIP: 0010:update_sd_lb_stats kernel/sched/fair.c:8565 [inline]
> > RIP: 0010:find_busiest_group+0xa33/0x3250 kernel/sched/fair.c:8793
> > Code: 89 f8 83 e0 07 83 c0 03 40 38 f0 7c 09 40 84 f6 0f 85 f7 1f 00 00 48 8b b5 c0 fd ff ff 41 8b 41 2c 48 c1 ee 03 42 0f b6 34 26 <40> 84 f6 74 0a 40 80 fe 03 0f 8e 8f 1f 00 00 44 8b 6b 20 44 39 ea
> > RSP: 0018:ffffc90000007850 EFLAGS: 00000a06
> > RAX: 000000000000006e RBX: ffffc90000007938 RCX: 00000000000003fa
> > RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff8880a9a8282c
> > RBP: ffffc90000007af0 R08: ffffffff89a7a440 R09: ffff8880a9a82800
> > R10: 0000000000000000 R11: ffff8880a9a83f27 R12: dffffc0000000000
> > R13: ffff8880a9a83e80 R14: ffffc90000007ac8 R15: ffffc90000007c08
> > FS:  0000000000000000(0000) GS:ffff8880ae800000(0000) knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: ffffffffff600400 CR3: 000000009fde0000 CR4: 00000000001406f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> > Call Trace:
> >  <IRQ>
> >  load_balance+0x38c/0x2b50 kernel/sched/fair.c:9161
> >  rebalance_domains+0x739/0x1000 kernel/sched/fair.c:9588
> >  _nohz_idle_balance+0x336/0x3f0 kernel/sched/fair.c:10002
> >  nohz_idle_balance kernel/sched/fair.c:10048 [inline]
> >  run_rebalance_domains+0x1c6/0x2d0 kernel/sched/fair.c:10237
> >  __do_softirq+0x262/0x98c kernel/softirq.c:292
> >  invoke_softirq kernel/softirq.c:373 [inline]
> >  irq_exit+0x19b/0x1e0 kernel/softirq.c:413
> >  scheduler_ipi+0x38c/0x610 kernel/sched/core.c:2349
> >  smp_reschedule_interrupt+0x78/0x4c0 arch/x86/kernel/smp.c:244
> >  reschedule_interrupt+0xf/0x20 arch/x86/entry/entry_64.S:853
> >  </IRQ>
> > RIP: 0010:native_safe_halt+0xe/0x10 arch/x86/include/asm/irqflags.h:61
> > Code: 58 f5 c3 f9 eb 8a cc cc cc cc cc cc e9 07 00 00 00 0f 00 2d 74 40 58 00 f4 c3 66 90 e9 07 00 00 00 0f 00 2d 64 40 58 00 fb f4 <c3> cc 55 48 89 e5 41 57 41 56 41 55 41 54 53 e8 ce ac 72 f9 e8 e9
> > RSP: 0018:ffffffff89a07ce8 EFLAGS: 00000286 ORIG_RAX: ffffffffffffff02
> > RAX: 1ffffffff136761a RBX: ffffffff89a7a440 RCX: 0000000000000000
> > RDX: dffffc0000000000 RSI: 0000000000000006 RDI: ffffffff89a7acd4
> > RBP: ffffffff89a07d18 R08: ffffffff89a7a440 R09: 0000000000000000
> > R10: 0000000000000000 R11: 0000000000000000 R12: dffffc0000000000
> > R13: ffffffff8aa5ab80 R14: 0000000000000000 R15: 0000000000000000
> >  arch_cpu_idle+0xa/0x10 arch/x86/kernel/process.c:686
> >  default_idle_call+0x84/0xb0 kernel/sched/idle.c:94
> >  cpuidle_idle_call kernel/sched/idle.c:154 [inline]
> >  do_idle+0x3c8/0x6e0 kernel/sched/idle.c:269
> >  cpu_startup_entry+0x1b/0x20 kernel/sched/idle.c:361
> >  rest_init+0x23b/0x371 init/main.c:654
> >  arch_call_rest_init+0xe/0x1b
> >  start_kernel+0x886/0x8c5 init/main.c:992
> >  x86_64_start_reservations+0x29/0x2b arch/x86/kernel/head64.c:490
> >  x86_64_start_kernel+0x77/0x7b arch/x86/kernel/head64.c:471
> >  secondary_startup_64+0xa4/0xb0 arch/x86/kernel/head_64.S:242
> > 
> > 
> > ---
> > This bug is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> > 
> > syzbot will keep track of this bug report. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > For information about bisection process see: https://goo.gl/tpsmEJ#bisection
> > syzbot can test patches for this bug, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
> 
> 
> Seems like vsock needs a word to track lock owner in an attempt to
> avoid trying to lock sock while the current is the lock owner.

Thanks for this possible solution.
What about using sock_owned_by_user()?

We should fix also hyperv_transport, because it could suffer from the same
problem.

At this point, it might be better to call vsk->transport->release(vsk)
always with the lock taken and remove it in the transports as in the
following patch.

What do you think?


diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 9c5b2a91baad..a073d8efca33 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -753,20 +753,18 @@ static void __vsock_release(struct sock *sk, int level)
 		vsk = vsock_sk(sk);
 		pending = NULL;	/* Compiler warning. */
 
-		/* The release call is supposed to use lock_sock_nested()
-		 * rather than lock_sock(), if a sock lock should be acquired.
-		 */
-		if (vsk->transport)
-			vsk->transport->release(vsk);
-		else if (sk->sk_type == SOCK_STREAM)
-			vsock_remove_sock(vsk);
-
 		/* When "level" is SINGLE_DEPTH_NESTING, use the nested
 		 * version to avoid the warning "possible recursive locking
 		 * detected". When "level" is 0, lock_sock_nested(sk, level)
 		 * is the same as lock_sock(sk).
 		 */
 		lock_sock_nested(sk, level);
+
+		if (vsk->transport)
+			vsk->transport->release(vsk);
+		else if (sk->sk_type == SOCK_STREAM)
+			vsock_remove_sock(vsk);
+
 		sock_orphan(sk);
 		sk->sk_shutdown = SHUTDOWN_MASK;
 
diff --git a/net/vmw_vsock/hyperv_transport.c b/net/vmw_vsock/hyperv_transport.c
index 3492c021925f..510f25f4a856 100644
--- a/net/vmw_vsock/hyperv_transport.c
+++ b/net/vmw_vsock/hyperv_transport.c
@@ -529,9 +529,7 @@ static void hvs_release(struct vsock_sock *vsk)
 	struct sock *sk = sk_vsock(vsk);
 	bool remove_sock;
 
-	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	remove_sock = hvs_close_lock_held(vsk);
-	release_sock(sk);
 	if (remove_sock)
 		vsock_remove_sock(vsk);
 }
diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index d9f0c9c5425a..f3c4bab2f737 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -829,7 +829,6 @@ void virtio_transport_release(struct vsock_sock *vsk)
 	struct sock *sk = &vsk->sk;
 	bool remove_sock = true;
 
-	lock_sock_nested(sk, SINGLE_DEPTH_NESTING);
 	if (sk->sk_type == SOCK_STREAM)
 		remove_sock = virtio_transport_close(vsk);
 
@@ -837,7 +836,6 @@ void virtio_transport_release(struct vsock_sock *vsk)
 		list_del(&pkt->list);
 		virtio_transport_free_pkt(pkt);
 	}
-	release_sock(sk);
 
 	if (remove_sock)
 		vsock_remove_sock(vsk);

Thanks,
Stefano

